# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: apjt206.4gl
# Descriptions...: 活動預計費用維護作業砐
# Date & Author..: No.FUN-790025 2007/11/12 By  lala
# Modify.........: No.FUN-790025
# Modify.........: No.TQC-840009
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-930106 09/03/18 By destiny pjdb03增加管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0215 10/11/30 By lixh1  科目二是否顯示要看aza63的參數設定
# Modify.........: No.FUN-B10052 11/01/26 By lilingyu 科目查詢自動過濾
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pjdb1          RECORD
        pjdb01       LIKE pjdb_file.pjdb01,
        pjdb02       LIKE pjdb_file.pjdb02
                     END RECORD,
    g_pjdb1_t        RECORD
        pjdb01       LIKE pjdb_file.pjdb01,
        pjdb02       LIKE pjdb_file.pjdb02
                     END RECORD,
    g_pjdb1_o        RECORD
        pjdb01       LIKE pjdb_file.pjdb01,
        pjdb02       LIKE pjdb_file.pjdb02
                     END RECORD,
 
    g_pjdb           DYNAMIC ARRAY OF RECORD
        pjdb03       LIKE pjdb_file.pjdb03,
        azf03        LIKE azf_file.azf03,
        pjdb04       LIKE pjdb_file.pjdb04,
        aag02        LIKE aag_file.aag02,
        pjdb05       LIKE pjdb_file.pjdb05,
        aag02_2      LIKE aag_file.aag02,
        pjdb06       LIKE pjdb_file.pjdb06,
        pjdbacti     LIKE pjdb_file.pjdbacti
                     END RECORD,
    g_pjdb_t         RECORD
        pjdb03       LIKE pjdb_file.pjdb03,
        azf03        LIKE azf_file.azf03,
        pjdb04       LIKE pjdb_file.pjdb04,
        aag02        LIKE aag_file.aag02,
        pjdb05       LIKE pjdb_file.pjdb05,
        aag02_2      LIKE aag_file.aag02,
        pjdb06       LIKE pjdb_file.pjdb06,
        pjdbacti     LIKE pjdb_file.pjdbacti
                     END RECORD,
    g_pjdb_o         RECORD
        pjdb03       LIKE pjdb_file.pjdb03,
        azf03        LIKE azf_file.azf03,
        pjdb04       LIKE pjdb_file.pjdb04,
        aag02        LIKE aag_file.aag02,
        pjdb05       LIKE pjdb_file.pjdb05,
        aag02_2      LIKE aag_file.aag02,
        pjdb06       LIKE pjdb_file.pjdb06,
        pjdbacti     LIKE pjdb_file.pjdbacti
                     END RECORD,
    g_argv1          LIKE pjdb_file.pjdb01,
    g_argv2          LIKE pjdb_file.pjdb02,
    g_wc,g_wc2,g_sql STRING,
    g_rec_b          LIKE type_file.num5,
    l_ac             LIKE type_file.num5,
    p_row,p_col      LIKE type_file.num5
 
DEFINE g_forupd_sql         STRING
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_show               LIKE type_file.chr1
 
MAIN
DEFINE p_row,p_col          LIKE type_file.num5
 
   OPTIONS                                
      INPUT NO WRAP
      DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_pjdb1.pjdb01 TO NULL
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_pjdb1.pjdb01 = g_argv1
   LET g_pjdb1.pjdb02 = g_argv2
 
   LET g_forupd_sql = " SELECT pjdb01,pjdb02 FROM pjdb_file ",
                      " WHERE pjdb01=? AND pjdb02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t206_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW t206_w AT p_row,p_col
        WITH FORM "apj/42f/apjt206"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
#TQC-AB0215 ----------------------------Begin--------------------------
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("pjdb05,aag02_2",FALSE)
   END IF
#TQC-AB0215 ----------------------------End----------------------------
   IF  NOT cl_null(g_argv1) THEN
      IF cl_null(g_argv2) THEN
         LET g_wc=g_wc,"pjdb01 = '",g_argv1 CLIPPED,"'"
      ELSE 
         LET g_wc=g_wc,"pjdb01 = '",g_argv1 CLIPPED,"' AND pjdb02 = '",g_argv2 CLIPPED,"'"
      END IF
      CALL t206_q()
      IF g_rec_b<=0 AND NOT cl_null(g_argv2) THEN
         LET g_pjdb1.pjdb01=g_argv1                                                   
         LET g_pjdb1.pjdb02=g_argv2
         CALL t206_show()
         CALL t206_b()
      END IF
   END IF
#TQC-AB0215 --------------------Begin----------------------
  # IF g_aza.aza63 = 'N' THEN 
  #    CALL cl_set_comp_visible("pjdb05,aag02_2",FALSE)
  # END IF
#TQC-AB0215 --------------------End------------------------
   CALL t206_menu()
   CLOSE WINDOW t206_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t206_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
 
   CLEAR FORM
   CALL g_pjdb.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_pjdb1.* TO NULL
 
   IF cl_null(g_argv1) THEN
   CONSTRUCT BY NAME g_wc ON pjdb01,pjdb02
       
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
       ON ACTION controlp
           CASE
               WHEN INFIELD(pjdb01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pjk"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjdb01
                   NEXT FIELD pjdb01
                   WHEN INFIELD(pjdb02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pjk4"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjdb02
                   NEXT FIELD pjdb02
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
   IF INT_FLAG THEN
     RETURN
   END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           
   #      LET g_wc = g_wc clipped," AND pjdbuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                         
   #      LET g_wc = g_wc clipped," AND pjdbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND pjdbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('jdbuser', 'jdbgrup')
   #End:FUN-980030
   
   CONSTRUCT g_wc2 ON pjdb03,pjdb04,pjdb05,pjdb06,pjdbacti
     FROM s_pjdb[1].pjdb03,s_pjdb[1].pjdb04,
          s_pjdb[1].pjdb05,s_pjdb[1].pjdb06,s_pjdb[1].pjdbacti
 
       BEFORE CONSTRUCT
	   CALL cl_qbe_display_condition(lc_qbe_sn)
       ON ACTION controlp
           CASE
               WHEN INFIELD(pjdb03)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_azf"           #No.FUN-930106
                  LET g_qryparam.form = "q_azf01a"        #No.FUN-930106
                  LET g_qryparam.state = "c"
                 #LET g_qryparam.arg1='2'                 #No.FUN-930106
                  LET g_qryparam.arg1='7'                 #No.FUN-930106
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjdb03
                  NEXT FIELD pjdb03
               WHEN INFIELD(pjdb04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"
		  LET g_qryparam.arg1=g_aza.aza81
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjdb04
                  NEXT FIELD pjdb04
               WHEN INFIELD(pjdb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"
		  LET g_qryparam.arg1=g_aza.aza82
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjdb05
                  NEXT FIELD pjdb05
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
 
       ON ACTION qbe_save
	   CALL cl_qbe_save()
   END CONSTRUCT
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF
   IF cl_null(g_wc2) THEN
     LET g_wc2=" 1=1"
   END IF
   LET g_sql = " SELECT UNIQUE pjdb01,pjdb02 ",
               " FROM pjdb_file ",
               " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
               " ORDER BY pjdb01"
   PREPARE t206_prepare FROM g_sql
   DECLARE t206_cs
       SCROLL CURSOR WITH HOLD FOR t206_prepare
 
  IF g_wc2 = " 1=1" THEN
       LET g_sql_tmp="SELECT UNIQUE pjdb01,pjdb02 FROM pjdb_file WHERE ",g_wc CLIPPED,
                 " INTO TEMP x"
   ELSE
       LET g_sql_tmp="SELECT UNIQUE pjdb01,pjdb02 FROM pjdb_file WHERE ",
                 g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " INTO TEMP x"
   END IF
 
   DROP TABLE x
   PREPARE t206_precount_x FROM g_sql_tmp
   EXECUTE t206_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE t206_precount FROM g_sql
   DECLARE t206_count CURSOR FOR t206_precount
END FUNCTION
 
FUNCTION t206_menu()
 
   WHILE TRUE
      CALL t206_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
              # CALL t206_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t206_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t206_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
#               CALL t206_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
#              CALL t206_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
              # CALL t206_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t206_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc2) THEN LET g_wc2=" 1=1" END IF
               LET g_msg ='p_query "apjt206" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'" "',g_aza.aza81,'" "',g_aza.aza82,'"'
               CALL cl_cmdrun(g_msg)
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjdb),'','')
            END IF
 
         WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_pjdb1.pjdb01 IS NOT NULL THEN
                LET g_doc.column1 = "pjdb01"
                LET g_doc.value1 = g_pjdb1.pjdb01
                CALL cl_doc()
             END IF
          END IF
      END CASE
   END WHILE
 
END FUNCTION
 
#FUNCTION t206_a()
 
#  MESSAGE ""
#  CLEAR FORM
#  CALL g_pjdb.clear()
#  LET g_wc = NULL
#  LET g_wc2= NULL
 
#  IF s_shut(0) THEN
#    RETURN
#  END IF
 
#  INITIALIZE g_pjdb1.pjdb01   LIKE pjdb_file.pjdb01
#  INITIALIZE g_pjdb1.pjdb02   LIKE pjdb_file.pjdb02
 
#  LET g_pjdb1_t.* = g_pjdb1.*
#  LET g_pjdb1_o.* = g_pjdb1.*
#  CALL cl_opmsg('a')
 
#  WHILE TRUE
 
#     CALL t206_i("a")
 
#     IF INT_FLAG THEN
#        INITIALIZE g_pjdb1.* TO NULL
#        LET INT_FLAG = 0
#        CALL cl_err('',9001,0)
#        EXIT WHILE
#     END IF
#     IF cl_null(g_pjdb1.pjdb01) AND cl_null(g_pjdb1.pjdb02) THEN 
#        CONTINUE WHILE
#     END IF
#     IF g_show matches '[Y/N]' AND g_show='Y' THEN
#        CALL t206_b_fill('1=1')
#        LET g_rec_b=g_cnt
#        CALL t206_b()
#     ELSE
#        LET g_rec_b = 0
#        CALL t206_b()
#     END IF
#     LET g_pjdb1_t.pjdb01=g_pjdb1.pjdb01
#     LET g_pjdb1_t.pjdb02=g_pjdb1.pjdb02
#     EXIT WHILE
#  END WHILE
 
#END FUNCTION
 
#FUNCTION t206_i(p_cmd)
#DEFINE
#  l_n,l_cnt       LIKE type_file.num5,
#  l_msg           LIKE type_file.chr1000,
#  p_cmd           LIKE type_file.chr1
 
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#  CALL cl_set_head_visible("","YES")
#  INPUT BY NAME g_pjdb1.pjdb01,g_pjdb1.pjdb02 WITHOUT DEFAULTS
 
#     AFTER FIELD pjdb01
#        DISPLAY "AFTER FIELD pjdb01"
#         IF NOT cl_null(g_pjdb1.pjdb01) THEN
#            IF NOT cl_null(g_pjdb1.pjdb02) THEN
#               IF p_cmd="a" OR
#                       (p_cmd="u" AND g_pjdb1.pjdb01 !=g_pjdb1_t.pjdb01 ) THEN
#                       SELECT count(*) INTO l_n FROM pjdb_file
#                       WHERE pjdb01=g_pjdb1.pjdb01 AND pjdb02 = g_pjdb1.pjdb02
#                  IF l_n > 0  THEN
#                     LET g_show='Y'
#                  END IF
#                  CALL t206_pjdb01('a')
#                       IF NOT cl_null(g_errno) THEN
#                          CALL cl_err('pjdb01:',g_errno,0)
#                          LET g_pjdb1.pjdb01 = g_pjdb1_t.pjdb01
#                          DISPLAY BY NAME g_pjdb1.pjdb01
#                          NEXT FIELD pjdb01
#                       END IF
#                  CALL t206_pjdb02('a')
#                   IF NOT cl_null(g_errno) THEN
#                      CALL cl_err('pjdb02:',g_errno,0)
#                      LET g_pjdb1.pjdb02 = g_pjdb1_t.pjdb02
#                      DISPLAY BY NAME g_pjdb1.pjdb02
#                      NEXT FIELD pjdb02
#                   END IF
#                END IF
 
#            ELSE
#                IF p_cmd="a" OR
#                   (p_cmd="u" AND g_pjdb1.pjdb01 !=g_pjdb1_t.pjdb01) THEN
#                   CALL t206_pjdb01('a')
#                       IF NOT cl_null(g_errno) THEN
#                          CALL cl_err('pjdb01:',g_errno,0)
#                          LET g_pjdb1.pjdb01 = g_pjdb1_t.pjdb01
#                          DISPLAY BY NAME g_pjdb1.pjdb01
#                          NEXT FIELD pjdb01
#                       END IF                       
#                END IF               
#            END IF      
#         END IF      
 
#     AFTER FIELD pjdb02
#        DISPLAY "AFTER FIELD pjdb02"
#         IF NOT cl_null(g_pjdb1.pjdb02) THEN
#            IF  NOT cl_null(g_pjdb1.pjdb01) THEN                
#             IF p_cmd="a" OR
#                  (p_cmd="u" AND g_pjdb1.pjdb02 !=g_pjdb1_t.pjdb02 ) THEN
#               CALL t206_pjdb02('a')
#               IF NOT cl_null(g_errno) THEN
#                 CALL cl_err('pjdb02:',g_errno,0)
#                 LET g_pjdb1.pjdb02 = g_pjdb1_t.pjdb02
#                 DISPLAY BY NAME g_pjdb1.pjdb02
#                 NEXT FIELD pjdb02
#               END IF
#               SELECT count(*) INTO l_n FROM pjdb_file 
#               WHERE pjdb01=g_pjdb1.pjdb01 AND pjdb02=g_pjdb1.pjdb02
#               IF l_n > 0  THEN
#                  LET g_show='Y'
#               END IF 
#             END IF
#           END IF 
#        END IF    
#     ON ACTION CONTROLF 
#        CALL cl_set_focus_form(ui.Interface.getRootNode())
#             RETURNING g_fld_name,g_frm_name 
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
#     ON ACTION controlp
#        CASE
#           WHEN INFIELD(pjdb01)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_pjk"
#              LET g_qryparam.default1 = g_pjdb1.pjdb01
#              LET g_qryparam.default2 = g_pjdb1.pjdb02
#              CALL cl_create_qry() RETURNING g_pjdb1.pjdb01,g_pjdb1.pjdb02
#              CALL FGL_DIALOG_SETBUFFER(g_pjdb1.pjdb01)
#              DISPLAY BY NAME g_pjdb1.pjdb01
#              NEXT FIELD pjdb01
#           WHEN INFIELD(pjdb02)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_pjk"
#              LET g_qryparam.default1 = g_pjdb1.pjdb01
#              LET g_qryparam.default1 = g_pjdb1.pjdb02
#              CALL cl_create_qry() RETURNING g_pjdb1.pjdb01,g_pjdb1.pjdb02
#              CALL FGL_DIALOG_SETBUFFER(g_pjdb1.pjdb02)
#              DISPLAY BY NAME g_pjdb1.pjdb02
#              NEXT FIELD pjdb02
#           OTHERWISE EXIT CASE
#        END CASE
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
 
#     ON ACTION about
#        CALL cl_about()
 
#     ON ACTION help
#        CALL cl_show_help()
 
#     ON ACTION controlg
#        CALL cl_cmdask()
#  END INPUT
#END FUNCTION
 
FUNCTION t206_pjdb01(p_cmd)
   DEFINE  l_pjj02     LIKE pjj_file.pjj02,
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjj02 INTO l_pjj02
      FROM pjj_file WHERE pjj01=g_pjdb1.pjdb01 AND pjjacti='Y'
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-004'
                                  LET l_pjj02   = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_pjj02 TO FORMONLY.pjj02
   END IF
 
END FUNCTION
 
FUNCTION t206_pjdb02(p_cmd)
   DEFINE  l_pjk03     LIKE pjk_file.pjk03,
           l_pjk16     LIKE pjk_file.pjk16, 
           l_pjk17     LIKE pjk_file.pjk17, 
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjk03,pjk16,pjk17 INTO l_pjk03,l_pjk16,l_pjk17
      FROM pjk_file 
      WHERE pjk01=g_pjdb1.pjdb01 AND pjk02=g_pjdb1.pjdb02 AND pjkacti='Y' 
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-004'
                                  LET l_pjk03 = NULL
                                  LET l_pjk16 = NULL 
                                  LET l_pjk17 = NULL 
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_pjk03 TO FORMONLY.pjk03
      DISPLAY l_pjk16 TO FORMONLY.pjk16
      DISPLAY l_pjk17 TO FORMONLY.pjk17
   END IF
 
END FUNCTION
 
FUNCTION t206_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_pjdb1.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pjdb.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t206_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjdb1.pjdb01=NULL
      LET g_pjdb1.pjdb02=NULL
      RETURN
   END IF
 
   OPEN t206_cs 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjdb1.pjdb01=NULL
      LET g_pjdb1.pjdb02=NULL
   ELSE
      OPEN t206_count
      FETCH t206_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t206_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t206_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,    
   l_abso          LIKE type_file.num10    
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t206_cs INTO g_pjdb1.pjdb01,g_pjdb1.pjdb02
      WHEN 'P' FETCH PREVIOUS t206_cs INTO g_pjdb1.pjdb01,g_pjdb1.pjdb02
      WHEN 'F' FETCH FIRST    t206_cs INTO g_pjdb1.pjdb01,g_pjdb1.pjdb02
      WHEN 'L' FETCH LAST     t206_cs INTO g_pjdb1.pjdb01,g_pjdb1.pjdb02
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
         FETCH ABSOLUTE g_jump t206_cs INTO g_pjdb1.pjdb01,g_pjdb1.pjdb02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pjdb1.pjdb01 TO NULL
      INITIALIZE g_pjdb1.pjdb02 TO NULL
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
   
   CALL t206_show()
 
END FUNCTION
 
FUNCTION t206_show()
   LET g_pjdb1_t.* = g_pjdb1.*
   LET g_pjdb1_o.* = g_pjdb1.*
 
   DISPLAY BY NAME g_pjdb1.*
   CALL t206_pjdb01('d')
   CALL t206_pjdb02('d')
 
   CALL t206_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t206_r()
  DEFINE l_n,i    LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pjdb1.pjdb01 IS NULL AND g_pjdb1.pjdb02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t206_cl USING g_pjdb1.pjdb01,g_pjdb1.pjdb02
   IF STATUS THEN
      CALL cl_err("OPEN t206_cl:", STATUS, 1)
      CLOSE t206_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t206_cl INTO g_pjdb1.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL t206_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjdb01"           #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjdb1.pjdb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
      DELETE FROM pjdb_file WHERE pjdb01=g_pjdb1.pjdb01 AND pjdb02=g_pjdb1.pjdb02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pjdb_file","","",SQLCA.sqlcode,"","BODY DELETE",1)
      ELSE
         CLEAR FORM
 
         DROP TABLE x
        # EXECUTE t206_precount_x 
         PREPARE t206_precount_x2 FROM g_sql_tmp
         EXECUTE t206_precount_x2
 
         CALL g_pjdb.clear()
        # LET g_pjdb1.pjdb01 = NULL
        # EXECUTE t206_precount_x
        # SELECT COUNT(*) INTO g_row_count FROM x
         OPEN t206_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t206_cs
            CLOSE t206_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t206_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t206_cs
            CLOSE t206_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t206_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t206_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t206_fetch('/')
         END IF
      END IF
      COMMIT WORK
   END IF
 
   CLOSE t206_cl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t206_b()
DEFINE
   l_ac_t          LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_cnt           LIKE type_file.num5,
   l_flag          LIKE type_file.chr1,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_msg           LIKE type_file.chr1000,
   l_azf14         LIKE azf_file.azf14
DEFINE l_azf09     LIKE azf_file.azf09        #No.FUN-930106
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_pjdb1.pjdb01) AND cl_null(g_pjdb1.pjdb02) THEN
      RETURN
   END IF
 
   LET g_pjdb1_t.pjdb01=g_pjdb1.pjdb01
   LET g_pjdb1_t.pjdb02=g_pjdb1.pjdb02
   CALL cl_opmsg('b')
   LET g_forupd_sql = " SELECT pjdb03,'',pjdb04,'',pjdb05,'',pjdb06,pjdbacti",
                      " FROM pjdb_file",
                      " WHERE pjdb01=? AND pjdb02=? AND pjdb03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t206_bcl CURSOR FROM g_forupd_sql
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pjdb WITHOUT DEFAULTS FROM s_pjdb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_pjdb_t.* = g_pjdb[l_ac].*
            LET g_pjdb_o.* = g_pjdb[l_ac].*
 
            OPEN t206_cl USING g_pjdb1.pjdb01,g_pjdb1.pjdb02
            IF STATUS THEN
               CALL cl_err("OPEN t206_cl:", STATUS, 1)
               CLOSE t206_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t206_cl INTO g_pjdb1.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)
               CLOSE t206_cl
               ROLLBACK WORK
               RETURN
            END IF
            LET p_cmd='u'
 
            OPEN t206_bcl USING g_pjdb1.pjdb01,g_pjdb1.pjdb02,g_pjdb_t.pjdb03
            IF STATUS THEN
               CALL cl_err("OPEN t206_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t206_bcl INTO g_pjdb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjdb_t.pjdb03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL t206_pjdb03('d')
               CALL t206_pjdb04('d')
               IF g_aza.aza63='Y' THEN
               CALL t206_pjdb05('d')
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjdb[l_ac].* TO NULL
         LET g_pjdb[l_ac].pjdbacti ='Y'
         LET g_pjdb_t.* = g_pjdb[l_ac].*
         LET g_pjdb_o.* = g_pjdb[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD pjdb03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pjdb_file(pjdb01,pjdb02,pjdb03,pjdb04,pjdb05,pjdb06,pjdbacti,pjdbuser,pjdbgrup,pjdbmodu,pjdbdate,pjdboriu,pjdborig)
             VALUES(g_pjdb1.pjdb01,g_pjdb1.pjdb02,g_pjdb[l_ac].pjdb03,g_pjdb[l_ac].pjdb04,
                    g_pjdb[l_ac].pjdb05,g_pjdb[l_ac].pjdb06,g_pjdb[l_ac].pjdbacti,
                    g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pjdb_file","","",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
#      BEFORE FIELD pjdb03
#         IF cl_null(g_pjdb[l_ac].pjdb03) THEN
#            SELECT max(pjmb03)+1 INTO g_pjdb[l_ac].pjdb03
#              FROM pjdb_file 
#             WHERE pjdb01 = g_pjdb1.pjdb01 AND pjdb02=g_pjdb1.pjdb02
#            IF cl_null(g_pjdb[l_ac].pjdb03) THEN
#               LET g_pjdb[l_ac].pjdb03 = 1
#            END IF
#         END IF
 
      AFTER FIELD pjdb03
         IF g_pjdb_o.pjdb03 IS NULL OR (g_pjdb[l_ac].pjdb03 != g_pjdb_o.pjdb03) THEN
               CALL t206_pjdb03('a')
            IF g_pjdb[l_ac].pjdb03 != g_pjdb_t.pjdb03 OR g_pjdb_t.pjdb03 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM azf_file
                   WHERE azf01 = g_pjdb[l_ac].pjdb03 AND azfacti = 'Y'
                     AND azf02 ='2'                                    #No.FUN-930106
                  IF l_n = 0 THEN
                     CALL cl_err(g_pjdb[l_ac].pjdb03,'apj-004',0)
                     LET g_pjdb[l_ac].pjdb03 = g_pjdb_t.pjdb03
                     NEXT FIELD pjdb03
                  ELSE 
                  #   DISPLAY BY NAME g_pjdb[l_ac].pjdb04
                     CALL t206_pjdb04('a')
                  END IF
               #No.FUN-930106--begin
               SELECT azf09 INTO l_azf09 FROM azf_file 
                WHERE azf01=g_pjdb[l_ac].pjdb03 AND azf02='2' AND azfacti='Y'
               IF l_azf09 !='7' THEN
                  CALL cl_err('','aoo-406',1)
                  NEXT FIELD pjdb03
               END IF 
               #No.FUN-930106--end 
               IF NOT cl_null(g_pjdb[l_ac].pjdb03) THEN
                  IF g_pjdb[l_ac].pjdb03 != g_pjdb_t.pjdb03 OR g_pjdb_t.pjdb03 IS NULL THEN
                     SELECT COUNT(*) INTO l_n FROM pjdb_file
                      WHERE pjdb03 = g_pjdb[l_ac].pjdb03 AND pjdb01 = g_pjdb1.pjdb01 AND pjdb02 = g_pjdb1.pjdb02
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_pjdb[l_ac].pjdb03 = g_pjdb_t.pjdb03
                        NEXT FIELD pjdb03
                     END IF
                     IF g_pjdb[l_ac].pjdb03 <= 0 THEN
                        CALL cl_err('pjdb02','aec-994',0)
                        NEXT FIELD pjdb03
                     END IF
                  END IF
               END IF
            END IF
         END IF

      BEFORE FIELD pjdb04
         CALL t206_set_entry(p_cmd)
         IF cl_null(g_pjdb[l_ac].pjdb04) THEN
            SELECT azf05 INTO g_pjdb[l_ac].pjdb04
           #FROM pjdb_file                        #No.FUN-930106
            FROM azf_file 
            WHERE azf01=pjdb03
              AND azf02='2'                       #No.FUN-930106
         END IF
         
      AFTER FIELD pjdb04               
         IF g_pjdb_o.pjdb04 IS NULL OR (g_pjdb[l_ac].pjdb04 != g_pjdb_o.pjdb04) THEN
               CALL t206_pjdb04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjdb[l_ac].pjdb04,g_errno,0)
#FUN-B10052 --begin--
#                 LET g_pjdb[l_ac].pjdb04 = g_pjdb_o.pjdb04
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag5"
               LET g_qryparam.default1 = g_pjdb[l_ac].pjdb04
	             LET g_qryparam.arg1=g_aza.aza81
	             LET g_qryparam.construct = 'N'
	             LET g_qryparam.where = " aag01 LIKE '",g_pjdb[l_ac].pjdb04 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_pjdb[l_ac].pjdb04
               CALL t206_pjdb04('d')
#FUN-B10052 --end--
                  DISPLAY BY NAME g_pjdb[l_ac].pjdb04
                  NEXT FIELD pjdb04
               END IF
            ELSE CALL t206_pjdb04('a')
            END IF
         LET g_pjdb_o.pjdb04 = g_pjdb[l_ac].pjdb04
         
      BEFORE FIELD pjdb05
         CALL t206_set_entry(p_cmd)
         IF cl_null(g_pjdb[l_ac].pjdb05) THEN
            SELECT azf051 INTO g_pjdb[l_ac].pjdb05
           #FROM pjdb_file                         #No.FUN-930106   
            FROM azf_file                          #No.FUN-930106
            WHERE azf01=pjdb03
              AND azf02='2'                        #No.FUN-930106
         END IF
 
      AFTER FIELD pjdb05               
         IF g_pjdb_o.pjdb03 IS NULL OR (g_pjdb[l_ac].pjdb03 != g_pjdb_o.pjdb03) THEN
               CALL t206_pjdb05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjdb[l_ac].pjdb05,g_errno,0)
#FUN-B10052 --begin--
#                  LET g_pjdb[l_ac].pjdb05 = g_pjdb_o.pjdb05
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag5"
	             LET g_qryparam.arg1=g_aza.aza82
               LET g_qryparam.default1 = g_pjdb[l_ac].pjdb05
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = " aag01 LIKE '",g_pjdb[l_ac].pjdb05 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_pjdb[l_ac].pjdb05
               CALL t206_pjdb05('d')
#FUN-B10052 --end--
                  DISPLAY BY NAME g_pjdb[l_ac].pjdb05
                  NEXT FIELD pjdb05
               END IF
            ELSE CALL t206_pjdb05('a')
            END IF
         LET g_pjdb_o.pjdb05 = g_pjdb[l_ac].pjdb05
 
      AFTER FIELD pjdb06
         IF NOT cl_null(g_pjdb[l_ac].pjdb06) THEN
            IF g_pjdb[l_ac].pjdb06 < 0 THEN
               CALL cl_err('pjdb06','apj-035',0)
               NEXT FIELD pjdb06
            END IF
         END IF
 
      BEFORE DELETE                           
         IF g_pjdb_t.pjdb03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pjdb_file
                 WHERE pjdb01 = g_pjdb1.pjdb01 AND pjdb02=g_pjdb1.pjdb02 AND pjdb03=g_pjdb_t.pjdb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pjdb_file",g_pjdb_t.pjdb03,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pjdb[l_ac].* = g_pjdb_t.*
            CLOSE t206_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pjdb[l_ac].pjdb03,-263,1)
            LET g_pjdb[l_ac].* = g_pjdb_t.*
         ELSE
            UPDATE pjdb_file SET pjdb03 = g_pjdb[l_ac].pjdb03,
                                 pjdb04 = g_pjdb[l_ac].pjdb04,
                                 pjdb05 = g_pjdb[l_ac].pjdb05,
                                 pjdb06 = g_pjdb[l_ac].pjdb06,
                                 pjdbmodu = g_user,
                                 pjdbgrup = g_grup,
                                 pjdbdate = g_today,
                                 pjdbacti = g_pjdb[l_ac].pjdbacti
             WHERE pjdb01 = g_pjdb1.pjdb01 AND pjdb02 = g_pjdb1.pjdb02 AND pjdb03=g_pjdb_t.pjdb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pjdb_file","",g_pjdb_t.pjdb03,SQLCA.sqlcode,"","",1)
               LET g_pjdb[l_ac].* = g_pjdb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
                LET g_pjdb[l_ac].* = g_pjdb_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjdb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t206_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t206_bcl
         COMMIT WORK
 
     ON ACTION CONTROLN
        CALL t206_b_askkey()
        EXIT INPUT
 
     ON ACTION CONTROLO                       
        IF INFIELD(pjdb03) AND l_ac > 1 THEN
           LET g_pjdb[l_ac].* = g_pjdb[l_ac-1].*
           NEXT FIELD pjdb03
        END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjdb03)
               CALL cl_init_qry_var()
               IF p_cmd='a' THEN               #TQC-840009
                 #LET g_qryparam.form = "q_azf5"                   #TQC-840009  #No.FUN-930106
                  LET g_qryparam.form = "q_azf5_1"                              #No.FUN-930106
                  LET g_qryparam.default1 = g_pjdb[l_ac].pjdb03
                 #LET g_qryparam.arg1='2'
                  LET g_qryparam.arg1='7'                                       #No.FUN-930106
                  CALL cl_create_qry() RETURNING g_pjdb[l_ac].pjdb03,g_pjdb[l_ac].pjdb04     #TQC-840009
                  DISPLAY BY NAME g_pjdb[l_ac].pjdb03,g_pjdb[l_ac].pjdb04             #TQC-840009
                  SELECT azf14 INTO l_azf14 FROM azf_file                          #TQC-840009
                  WHERE azf01 = g_pjdb[l_ac].pjdb03  AND azf02='2' AND azfacti='Y' #TQC-840009
                  LET g_pjdb[l_ac].pjdb04 = l_azf14                                #TQC-840009
                  DISPLAY BY NAME g_pjdb[l_ac].pjdb04
                  CALL t206_pjdb03('a')        #TQC-840009
                  CALL t206_pjdb04('a')        #TQC-840009
               END IF                          #TQC-840009
               IF p_cmd='u' THEN               #TQC-840009
                 #LET g_qryparam.form = "q_azf"                   #TQC-840009      #No.FUN-930106
                  LET g_qryparam.form = "q_azf01a"                                 #No.FUN-930106
                  LET g_qryparam.default1 = g_pjdb[l_ac].pjdb03
                 #LET g_qryparam.arg1='2'                                          #No.FUN-930106 
                  LET g_qryparam.arg1='7'                                          #No.FUN-930106  
                  CALL cl_create_qry() RETURNING g_pjdb[l_ac].pjdb03     #TQC-840009
                  DISPLAY BY NAME g_pjdb[l_ac].pjdb03
                  CALL t206_pjdb03('u')        #TQC-840009
               END IF                          #TQC-840009
               NEXT FIELD pjdb03
            WHEN INFIELD(pjdb04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag5"
               LET g_qryparam.default1 = g_pjdb[l_ac].pjdb04
	       LET g_qryparam.arg1=g_aza.aza81
               CALL cl_create_qry() RETURNING g_pjdb[l_ac].pjdb04
               DISPLAY BY NAME g_pjdb[l_ac].pjdb04
               CALL t206_pjdb04('d')
               NEXT FIELD pjdb04
            WHEN INFIELD(pjdb05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag5"
	       LET g_qryparam.arg1=g_aza.aza82
               LET g_qryparam.default1 = g_pjdb[l_ac].pjdb05
               CALL cl_create_qry() RETURNING g_pjdb[l_ac].pjdb05
               DISPLAY BY NAME g_pjdb[l_ac].pjdb05
               CALL t206_pjdb05('d')
               NEXT FIELD pjdb05
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name
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
 
   CLOSE t206_bcl
   COMMIT WORK
 
END FUNCTION
FUNCTION t206_pjdb03(p_cmd)
   DEFINE  p_cmd      LIKE type_file.chr1,
           l_azf03    LIKE azf_file.azf03,
           l_azfacti  LIKE azf_file.azfacti
 
   LET g_errno = ' '
      SELECT azf03 INTO l_azf03 FROM azf_file
      WHERE azf01 = g_pjdb[l_ac].pjdb03  AND azf02='2' AND azfacti='Y'
      
   CASE
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'mfg5108'
                                    LET l_azf03 = NULL
      WHEN l_azfacti='N'            LET g_errno = '9028'
      WHEN l_azfacti MATCHES '[PH]' LET g_errno = '9038'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_pjdb[l_ac].azf03 = l_azf03
      DISPLAY BY NAME g_pjdb[l_ac].azf03
   END IF
 
#   SELECT aag02 INTO l_aag02 FROM aag_file,aza_file
#      WHERE aag01 = g_pjdb[l_ac].pjdb04 AND aag00=g_aza.aza81
      
#   CASE
#      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'mfg5107'
#                                    LET l_aag02 = NULL
#      WHEN l_aagacti='N'            LET g_errno = '9028'
#      WHEN l_aagacti MATCHES '[PH]' LET g_errno = '9038'
#      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
   
#   IF cl_null(g_errno) or p_cmd = 'd' THEN
#      LET g_pjdb[l_ac].aag02 = l_aag02
#      DISPLAY BY NAME g_pjdb[l_ac].aag02
#   END IF
END FUNCTION
 
FUNCTION t206_pjdb04(p_cmd)
   DEFINE  p_cmd      LIKE type_file.chr1,
           l_aag02    LIKE aag_file.aag02,
           l_aagacti  LIKE aag_file.aagacti
 
   LET g_errno = ' '
      SELECT aag02 INTO l_aag02 FROM aag_file,aza_file
      WHERE aag01 = g_pjdb[l_ac].pjdb04 AND aag00=g_aza.aza81
 
   CASE
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'mfg5107'
                                    LET l_aag02 = NULL
      WHEN l_aagacti='N'            LET g_errno = '9028'
      WHEN l_aagacti MATCHES '[PH]' LET g_errno = '9038'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_pjdb[l_ac].aag02 = l_aag02
      DISPLAY BY NAME g_pjdb[l_ac].aag02
   END IF
END FUNCTION
 
FUNCTION t206_pjdb05(p_cmd)
   DEFINE  p_cmd        LIKE type_file.chr1,
           l_aag02_2    LIKE aag_file.aag02,
           l_aagacti    LIKE aag_file.aagacti
 
   LET g_errno = ' '
      SELECT aag02 INTO l_aag02_2 FROM aag_file,aza_file
      WHERE aag01 = g_pjdb[l_ac].pjdb05 AND aag00=g_aza.aza82
 
   CASE
      WHEN SQLCA.SQLCODE = 100      LET g_errno   = 'mfg5107'
                                    LET l_aag02_2 = NULL
      WHEN l_aagacti='N'            LET g_errno   = '9028'
      WHEN l_aagacti MATCHES '[PH]' LET g_errno   = '9038'
      OTHERWISE                     LET g_errno   = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_pjdb[l_ac].aag02_2 = l_aag02_2
      DISPLAY BY NAME g_pjdb[l_ac].aag02_2
   END IF
END FUNCTION
 
FUNCTION t206_b_askkey()
#DEFINE   l_wc2          LIKE type_file.chr1000
 DEFINE   l_wc2  STRING     #NO.FUN-910082
 
   CONSTRUCT l_wc2 ON pjdb03,pjdb04,pjdb05,pjdb06,pjdbacti      
           FROM s_pjdb[1].pjdb03,s_pjdb[1].pjdb04,s_pjdb[1].pjdb05,
           s_pjdb[1].pjdb06,s_pjdb[1].pjdbacti
 
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL t206_b_fill(l_wc2)
 
END FUNCTION
 
 
FUNCTION t206_b_fill(p_wc2)
#   DEFINE p_wc2          LIKE type_file.chr1000
   DEFINE  p_wc2  STRING     #NO.FUN-910082
 
   LET g_sql="SELECT pjdb03,'',pjdb04,'',pjdb05,'',pjdb06,pjdbacti",
             " FROM pjdb_file ",
             " WHERE pjdb01='",g_pjdb1.pjdb01,"' AND pjdb02='",g_pjdb1.pjdb02,"'"
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pjdb03 "
   DISPLAY g_sql
   PREPARE t206_pb FROM g_sql
   DECLARE pjdb_cs CURSOR FOR t206_pb
   CALL g_pjdb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pjdb_cs INTO g_pjdb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT azf03 INTO g_pjdb[g_cnt].azf03
      FROM azf_file
      WHERE azf01 = g_pjdb[g_cnt].pjdb03 AND azfacti='Y'
        AND azf02 ='2'                                         #No.FUN-930106
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","azf_file",g_pjdb[g_cnt].azf03,"",SQLCA.sqlcode,"","",0)  
         LET g_pjdb[g_cnt].azf03 = NULL
      END IF
      SELECT aag02 INTO g_pjdb[g_cnt].aag02
            FROM aag_file
            WHERE  aag01=g_pjdb[g_cnt].pjdb04 AND aag00=g_aza.aza81 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","aag_file",g_pjdb[g_cnt].pjdb04,"",SQLCA.sqlcode,"","",0)  
         LET g_pjdb[g_cnt].aag02 = NULL
      END IF
      IF g_aza.aza63='Y' THEN
      SELECT aag02 INTO g_pjdb[g_cnt].aag02_2
         FROM aag_file
         WHERE  aag01=g_pjdb[g_cnt].pjdb05 AND aag00=g_aza.aza82 
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","aag_file",g_pjdb[g_cnt].pjdb05,"",SQLCA.sqlcode,"","",0)  
         LET g_pjdb[g_cnt].aag02_2 = NULL
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pjdb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t206_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjdb TO s_pjdb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
     # ON ACTION insert
     #    LET g_action_choice="insert"
     #    EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t206_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t206_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t206_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION next
         CALL t206_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL t206_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
#      ON ACTION invalid
#         LET g_action_choice="invalid"
#         EXIT DISPLAY
 
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
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
 
#FUNCTION t206_copy()
#  DEFINE l_newno1    LIKE pjdb_file.pjdb01,
#         l_newno2    LIKE pjdb_file.pjdb01,
#         l_oldno1    LIKE pjdb_file.pjdb01,
#         l_oldno2    LIKE pjdb_file.pjdb01,
#         l_msg       LIKE type_file.chr1000,
#         l_cnt       LIKE type_file.num5
#  DEFINE li_result   LIKE type_file.num5
#  DEFINE g_tl        LIKE pjdb_file.pjdb01
 
#  IF s_shut(0) THEN
#     RETURN
#  END IF
 
#  IF g_pjdb1.pjdb01 IS NULL OR g_pjdb1.pjdb02 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
 
#  LET g_pjdb1_t.*=g_pjdb1.*
#  LET g_before_input_done = FALSE
 
#  CALL cl_set_head_visible("","YES")
#  INPUT l_newno1,l_newno2 FROM pjdb01,pjdb02
 
#      AFTER FIELD pjdb01
#          IF l_newno1 IS NOT NULL THEN
#             IF l_newno2 IS NOT NULL THEN             
#             SELECT count(*) INTO l_cnt FROM pjdb_file
#                 WHERE pjdb01 = l_newno1 AND pjdb02=l_newno2
#             IF l_cnt > 0 THEN
#                CALL cl_err(l_newno1,-239,0)
#                 NEXT FIELD pjdb01
#             END IF
#             LET  g_pjdb1.pjdb01=l_newno1
#             CALL t206_pjdb01('a')
#                  IF NOT cl_null(g_errno) THEN
#                     CALL cl_err('pjdb01:',g_errno,0)
#                     LET g_pjdb1.pjdb01 = g_pjdb1_t.pjdb01
#                     DISPLAY BY NAME g_pjdb1.pjdb01
#                     NEXT FIELD pjdb01
#                   END IF
#             ELSE
#                 NEXT FIELD pjdb02
#             END IF
#          END IF
 
#      AFTER FIELD pjdb02
#          IF l_newno2 IS NOT NULL THEN
#             IF l_newno1 IS NOT NULL THEN             
#             SELECT count(*) INTO l_cnt FROM pjdb_file
#                 WHERE pjdb01 = l_newno1 AND pjdb02=l_newno2
#             IF l_cnt > 0 THEN
#                CALL cl_err(l_newno2,-239,0)
#                 NEXT FIELD pjdb01
#             END IF
#             LET g_pjdb1.pjdb01=l_newno1
#             LET g_pjdb1.pjdb02=l_newno2
#             CALL t206_pjdb02('a')
#                  IF NOT cl_null(g_errno) THEN
#                     CALL cl_err('pjdb02:',g_errno,0)
#                     LET g_pjdb1.pjdb02 = g_pjdb1_t.pjdb02
#                     DISPLAY BY NAME g_pjdb1.pjdb02
#                     NEXT FIELD pjdb02
#                   END IF
#             ELSE
#                 NEXT FIELD pjdb01
#             END IF
#          END IF
#      ON ACTION controlp
#         CASE
#            WHEN INFIELD(pjdb01)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form="q_pjk"
#               LET g_qryparam.default1 = g_pjdb1.pjdb01
#               CALL cl_create_qry() RETURNING l_newno1
#               DISPLAY l_newno1 TO pjdb01
#               IF SQLCA.sqlcode THEN
#                  DISPLAY BY NAME l_newno1
#                  LET l_newno1=NULL
#                  NEXT FIELD pjdb01
#               END IF
#               NEXT FIELD pjdb01
 
#            WHEN INFIELD(pjdb02)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form="q_pjk"
#               LET g_qryparam.default1 = g_pjdb1.pjdb02
#               CALL cl_create_qry() RETURNING l_newno2
#               DISPLAY l_newno2 TO pjdb02
#               IF SQLCA.sqlcode THEN
#                  DISPLAY BY NAME l_newno2
#                  LET l_newno2=NULL
#                  NEXT FIELD pjdb02
#               END IF
#               NEXT FIELD pjdb02
#            OTHERWISE EXIT CASE    
#         END CASE
 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
 
#     ON ACTION about
#        CALL cl_about()
 
#     ON ACTION help
#        CALL cl_show_help()
 
#     ON ACTION controlg
#        CALL cl_cmdask()
#   END INPUT
 
#   IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     DISPLAY BY NAME g_pjdb1.pjdb01
#     ROLLBACK WORK
#     RETURN
#   END IF
 
#  DROP TABLE y
 
#  SELECT * FROM pjdb_file 
#      WHERE pjdb01=g_pjdb1.pjdb01 AND pjdb02=g_pjdb1.pjdb02
#      INTO TEMP y
 
#  UPDATE y
#      SET pjdb01=l_newno,
#          pjdbuser=g_user,
#          pjdbgrup=g_grup,
#          pjdbmodu=NULL,
#          pjdbdate=g_today,
#          pjdbacti='Y'
 
#  INSERT INTO pjdb_file SELECT * FROM y
 
#  IF SQLCA.sqlcode THEN
#     CALL cl_err3("ins","pjdb_file","","",SQLCA.sqlcode,"","",1)
#     ROLLBACK WORK
#     RETURN
#  ELSE
#     COMMIT WORK
#  END IF
 
#  LET g_cnt=SQLCA.SQLERRD[3]
#  MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
#  LET l_oldno1 = g_pjdb1.pjdb01
#  LET l_oldno2 = g_pjdb1.pjdb02
#  SELECT pjdb01,pjdb02 INTO g_pjdb1.pjdb01,g_pjdb1.pjdb02 FROM pjdb_file
#         WHERE pjdb01 = l_newno1 AND pjdb02 = l_newno2
#   CALL t206_u()
#  CALL t206_b()
#  SELECT pjdb01,pjdb02 INTO g_pjdb1.pjdb01,g_pjdb1.pjdb02 FROM pjdb_file
#         WHERE pjdb01 = l_oldno1 AND pjdb02 = l_oldno2
#  CALL t206_show()
#END FUNCTION
 
FUNCTION t206_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF INFIELD(pjdb03) THEN
      CALL cl_set_comp_entry("pjdb05",TRUE)
   END IF
END FUNCTION
 
FUNCTION t206_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
#      IF g_pjdb[l_ac].pjdb04[1,4] !
END FUNCTION
# Modify.........: No.FUN-790025
 
