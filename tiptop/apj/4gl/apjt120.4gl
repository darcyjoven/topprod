# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apjt120.4gl
# Descriptions...: WBS本階計劃材料維護作業
# Date & Author..: FUN-790025 2007/10/26 By shiwuying
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-840009 08/04/03 By shiwuying 畫面刪除pjfa07
# Modify.........: No.MOD-840322 08/04/21 By shiwuying 單身錄入時增加依BOM 表整批產生功能
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 單身/修改/刪除時加上專案是否'結案'的判斷
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pjfa01         LIKE pjfa_file.pjfa01,
    g_pjfa01_t       LIKE pjfa_file.pjfa01,
    g_pjfa01_o       LIKE pjfa_file.pjfa01,
    g_pjfa           DYNAMIC ARRAY OF RECORD
        pjfa02       LIKE pjfa_file.pjfa02,
        pjfa03       LIKE pjfa_file.pjfa03,
        pjfa04       LIKE pjfa_file.pjfa04,
        ima021       LIKE ima_file.ima021,
        ima25        LIKE ima_file.ima25,
        pjfa05       LIKE pjfa_file.pjfa05,
        pjfa06       LIKE pjfa_file.pjfa06,
#        pjfa07       LIKE pjfa_file.pjfa07,   #No.TQC-840009
        pjfaacti     LIKE pjfa_file.pjfaacti
                     END RECORD,
    g_pjfa_t         RECORD 
        pjfa02       LIKE pjfa_file.pjfa02,
        pjfa03       LIKE pjfa_file.pjfa03,
        pjfa04       LIKE pjfa_file.pjfa04,
        ima021       LIKE ima_file.ima021,
        ima25        LIKE ima_file.ima25,
        pjfa05       LIKE pjfa_file.pjfa05,
        pjfa06       LIKE pjfa_file.pjfa06,
#        pjfa07       LIKE pjfa_file.pjfa07,   #No.TQC-840009
        pjfaacti     LIKE pjfa_file.pjfaacti
                     END RECORD,
    g_pjfa_o         RECORD
        pjfa02       LIKE pjfa_file.pjfa02,
        pjfa03       LIKE pjfa_file.pjfa03,
        pjfa04       LIKE pjfa_file.pjfa04,
        ima021       LIKE ima_file.ima021,
        ima25        LIKE ima_file.ima25,
        pjfa05       LIKE pjfa_file.pjfa05,
        pjfa06       LIKE pjfa_file.pjfa06,
#        pjfa07       LIKE pjfa_file.pjfa07,   #No.TQC-840009
        pjfaacti     LIKE pjfa_file.pjfaacti
                     END RECORD,
    g_argv1          LIKE pjb_file.pjb01,
    g_argv2          LIKE pjfa_file.pjfa01,
    g_wc,g_wc2,g_sql STRING,
    g_rec_b          LIKE type_file.num5,
    g_ss             LIKE type_file.chr1,
 
    l_ac             LIKE type_file.num5,
    p_row,p_col      LIKE type_file.num5 
DEFINE  g_pjaclose   LIKE pja_file.pjaclose     #No.FUN-960038
    
DEFINE g_forupd_sql         STRING       #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt                LIKE type_file.num10 
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10 
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5 
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_str                STRING
DEFINE l_table              STRING
 
MAIN
DEFINE p_row,p_col          LIKE type_file.num5 
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   INITIALIZE g_pjfa01 TO NULL
 
   LET g_forupd_sql = "SELECT pjfa01 FROM pjfa_file",
                      " WHERE pjfa01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t120_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW t120_w AT p_row,p_col
        WITH FORM "apj/42f/apjt120"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      SELECT count(*) INTO g_cnt FROM pjfa_file WHERE pjfa01=g_argv2
      IF g_cnt > 0 THEN
         CALL t120_q()
      ELSE
         CALL t120_pjfa01('a')
         CALL t1201()             #No.MOD-840322
#         CALL t120_b()           #No.MOD-840322
      END IF
   END IF
   IF NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN
      
   END IF
   CALL t120_menu()
   CLOSE WINDOW t120_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION t120_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
 
   CLEAR FORM
   CALL g_pjfa.clear()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc=" pjfa01 = '",g_argv2,"' "
   ELSE
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_pjfa01 TO NULL
   
   CONSTRUCT g_wc ON pjfa01,pjfa02,pjfa03,pjfa04,pjfa05,pjfa06,pjfaacti 
         FROM pjfa01,s_pjfa[1].pjfa02,s_pjfa[1].pjfa03,s_pjfa[1].pjfa04,
                     s_pjfa[1].pjfa05,s_pjfa[1].pjfa06,s_pjfa[1].pjfaacti
       
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
             
       ON ACTION controlp
           CASE
              WHEN INFIELD(pjfa01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pjb"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjfa01
                   NEXT FIELD pjfa01
              WHEN INFIELD(pjfa03)
#FUN-AA0059 --Begin--
                 #  CALL cl_init_qry_var()
                 #  LET g_qryparam.form = "q_ima"
                 #  LET g_qryparam.state = "c"
                 #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO pjfa03
                   NEXT FIELD pjfa03
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
   END IF
   IF INT_FLAG THEN
     RETURN
   END IF
   
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND pjfauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND pjfagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND pjfagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('jfauser', 'jfagrup')
   #End:FUN-980030
  
   IF cl_null(g_wc) THEN
      LET g_wc="1=1"
   END IF
    
   LET g_sql = "SELECT UNIQUE pjfa01 ",
               " FROM pjfa_file ",
               " WHERE ", g_wc CLIPPED, 
               " ORDER BY pjfa01"
   PREPARE t120_prepare FROM g_sql
   DECLARE t120_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t120_prepare
 
  
   LET g_sql_tmp="SELECT UNIQUE pjfa01 FROM pjfa_file WHERE ",
       g_wc CLIPPED,#" AND ",g_wc2 CLIPPED,
       " INTO TEMP x"
   
   DROP TABLE x                            
   PREPARE t120_precount_x FROM g_sql_tmp  
   EXECUTE t120_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE t120_precount FROM g_sql
   DECLARE t120_count CURSOR FOR t120_precount
END FUNCTION
 
 
#No.MOD-840322------------start-------------
FUNCTION t1201()
   DEFINE  l_chr       LIKE type_file.chr1
 
   OPEN WINDOW t1201_w AT p_row,p_col WITH FORM "apj/42f/apjt1201"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("apjt1201")
 
   LET l_chr='1'
   INPUT l_chr WITHOUT DEFAULTS FROM FORMONLY.a
 
      AFTER FIELD a
         IF l_chr NOT MATCHES '[12]' THEN
            NEXT FIELD a
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET l_chr = '1'
   END IF
   CLOSE WINDOW t1201_w 
 
   IF cl_null(l_chr) THEN
      LET l_chr = '1'
   END IF
   LET g_rec_b = 0
   CASE
      WHEN l_chr = '1'
         CALL g_pjfa.clear()
         CALL t120_b()
      WHEN l_chr='2'
         CALL p120(g_pjfa01)
         LET g_wc=NULL
         CALL t120_b_fill(g_wc)
         CALL t120_b()
      OTHERWISE EXIT CASE
   END CASE
#   LET g_pjfa_t.* = g_pjfa.* 
#   LET g_pjfa_o.* = g_pjfa.*
END FUNCTION
#No.MOD-840322-------------end--------------
 
 
FUNCTION t120_menu()
 
   WHILE TRUE
      CALL t120_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t120_q()
            END IF
         
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t120_r()
            END IF
         
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t120_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t120_out()
            END IF
         
         WHEN "help"
            CALL cl_show_help()
         
         WHEN "exit"
            EXIT WHILE
         
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjfa),'','')
            END IF
         
         WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_pjfa01 IS NOT NULL THEN
                LET g_doc.column1 = "pjfa01"
                LET g_doc.value1 = g_pjfa01
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
 
END FUNCTION
 
 
FUNCTION t120_pjfa01(p_cmd)
   DEFINE  l_pjb01     LIKE pjb_file.pjb01,
           l_pjb03     LIKE pjb_file.pjb03,
           l_pjb15     LIKE pjb_file.pjb15,
           l_pjb16     LIKE pjb_file.pjb16,
           l_pjbacti   LIKE pjb_file.pjbacti,
           l_pja02     LIKE pja_file.pja02,
           l_pjaacti   LIKE pja_file.pjaacti,
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN
      SELECT pjb03,pjb15,pjb16
        INTO l_pjb03,l_pjb15,l_pjb16
        FROM pjb_file
       WHERE pjb02=g_argv2 AND pjb01=g_argv1
   ELSE
      SELECT pjb01,pjb03,pjb15,pjb16,pjbacti
        INTO l_pjb01,l_pjb03,l_pjb15,l_pjb16,l_pjbacti
        FROM pjb_file WHERE pjb02=g_pjfa01
   END IF
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-004'
                                  LET l_pjb01   = NULL
                                  LET l_pjb03   = NULL
                                  LET l_pjb15   = NULL
                                  LET l_pjb16   = NULL
        WHEN l_pjbacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN
      SELECT pja02,pjaclose       #No.FUN-960038 ADD pjaclose
        INTO l_pja02,g_pjaclose   #No.FUN-960038 ADD g_pjaclose
        FROM pja_file WHERE pja01=g_argv1
   ELSE
      SELECT pja02,pjaacti,pjaclose       #No.FUN-960038 ADD pjaclose
        INTO l_pja02,l_pjaacti,g_pjaclose #No.FUN-960038 ADD g_pjaclose
        FROM pja_file
       WHERE pja01=l_pjb01
   END IF
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'            
                                  LET l_pja02=NULL
        WHEN l_pjaacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
      IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
         LET l_pjb01 = g_argv1
         LET g_pjfa01 = g_argv2
         DISPLAY g_argv2 TO pjfa01
      END IF
      DISPLAY l_pjb01  TO FORMONLY.pjb01
      DISPLAY l_pjb03  TO FORMONLY.pjb03 
      DISPLAY l_pjb15  TO FORMONLY.pjb15
      DISPLAY l_pjb16  TO FORMONLY.pjb16
      DISPLAY l_pja02  TO FORMONLY.pja02
   END IF
 
END FUNCTION
 
 
FUNCTION t120_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_pjfa01 TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pjfa.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   
   CALL t120_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjfa01=NULL
      RETURN
   END IF
   
   OPEN t120_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjfa01=NULL
   ELSE
      OPEN t120_count
      FETCH t120_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t120_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
 
FUNCTION t120_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式 
   l_abso          LIKE type_file.num10     #絕對的筆數 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t120_cs INTO g_pjfa01
      WHEN 'P' FETCH PREVIOUS t120_cs INTO g_pjfa01
      WHEN 'F' FETCH FIRST    t120_cs INTO g_pjfa01
      WHEN 'L' FETCH LAST     t120_cs INTO g_pjfa01
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
         FETCH ABSOLUTE g_jump t120_cs INTO g_pjfa01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjfa01,SQLCA.sqlcode,0)
      INITIALIZE g_pjfa01 TO NULL
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
   
   CALL t120_show()
 
END FUNCTION
 
 
FUNCTION t120_show()
   LET g_pjfa01_t = g_pjfa01
   LET g_pjfa01_o = g_pjfa01
 
   DISPLAY g_pjfa01  TO pjfa01      #單頭
   CALL t120_pjfa01('d')
   #-->顯示單頭值
   CALL t120_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
 
FUNCTION t120_r()
  DEFINE l_n,i    LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pjfa01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
#No.FUN-960038 --Begin
   IF g_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
   
   BEGIN WORK
 
   OPEN t120_cl USING g_pjfa01
   IF STATUS THEN
      CALL cl_err("OPEN t120_cl:", STATUS, 1)
      CLOSE t120_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t120_cl INTO g_pjfa01           # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjfa01,SQLCA.sqlcode,0)
      CLOSE t120_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t120_show()
 
   IF cl_delh(0,0) THEN   #確認一下
       INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjfa01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjfa01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()#No.FUN-9B0098 10/02/24
      DELETE FROM pjfa_file WHERE pjfa01=g_pjfa01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pjfa_file",g_pjfa01,"",SQLCA.sqlcode,"","BODY DELETE",1)
      ELSE
         CLEAR FORM
 
         CALL g_pjfa.clear()
         LET g_pjfa01 = NULL
         OPEN t120_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t120_cs
            CLOSE t120_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t120_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t120_cs
            CLOSE t120_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t120_cs
         IF g_row_count > 0 THEN
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL t120_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL t120_fetch('/')
            END IF
         END IF
      END IF
      COMMIT WORK
   END IF
 
   CLOSE t120_cl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t120_b()
DEFINE
   l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,       #檢查重複用 
   l_cnt           LIKE type_file.num5,       #檢查重複用 
   l_flag          LIKE type_file.chr1,      
   l_lock_sw       LIKE type_file.chr1,       #單身鎖
   p_cmd           LIKE type_file.chr1,       #處理狀態 
   l_allow_insert  LIKE type_file.num5,       #可新增否
   l_allow_delete  LIKE type_file.num5,       #可刪除否 
   l_msg           LIKE type_file.chr1000
   
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_pjfa01) THEN
      RETURN
   END IF
#No.FUN-960038 --Begin
   IF g_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
 
   LET g_pjfa01_t = g_pjfa01
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT pjfa02,pjfa03,pjfa04,'','',pjfa05,pjfa06,",
#                      "       pjfa07,pjfaacti FROM pjfa_file",  #No.TQC-840009
                      "       pjfaacti FROM pjfa_file",          #No.TQC-840009
                      " WHERE pjfa01=? AND pjfa02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pjfa WITHOUT DEFAULTS FROM s_pjfa.*
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
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_pjfa_t.* = g_pjfa[l_ac].*  #BACKUP
            LET g_pjfa_o.* = g_pjfa[l_ac].*  #BACKUP
 
            OPEN t120_cl USING g_pjfa01
            IF STATUS THEN
               CALL cl_err("OPEN t120_cl:", STATUS, 1)
               CLOSE t120_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t120_cl INTO g_pjfa01     # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pjfa01,SQLCA.sqlcode,0)
               CLOSE t120_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            LET p_cmd='u'
 
            OPEN t120_bcl USING g_pjfa01,g_pjfa_t.pjfa02
            IF STATUS THEN
               CALL cl_err("OPEN t120_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t120_bcl INTO g_pjfa[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjfa_t.pjfa02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT ima021,ima25 INTO g_pjfa[l_ac].ima021,g_pjfa[l_ac].ima25 
                  FROM ima_file
                  WHERE ima01 = g_pjfa[l_ac].pjfa03
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjfa[l_ac].* TO NULL
         LET g_pjfa[l_ac].pjfa05 =  0 
         LET g_pjfa[l_ac].pjfa06 =  g_today 
#         LET g_pjfa[l_ac].pjfaacti='N'           #No.TQC-840009
         LET g_pjfa[l_ac].pjfaacti='Y'           #No.TQC-840009
#         LET g_pjfa[l_ac].pjfa07 =  0            #Body default #No.TQC-840009
         LET g_pjfa_t.* = g_pjfa[l_ac].*         #新輸入資料
         LET g_pjfa_o.* = g_pjfa[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont() 
         NEXT FIELD pjfa02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
#         INSERT INTO pjfa_file  #No.TQC-840009
         INSERT INTO pjfa_file(pjfa01,pjfa02,pjfa03,pjfa04,pjfa05,pjfa06,#No.TQC-840009
                               pjfaacti,pjfadate,pjfagrup,pjfauser,pjfaoriu,pjfaorig)      #No.TQC-840009
             VALUES(g_pjfa01,g_pjfa[l_ac].pjfa02,g_pjfa[l_ac].pjfa03,
                    g_pjfa[l_ac].pjfa04,g_pjfa[l_ac].pjfa05,g_pjfa[l_ac].pjfa06,
#                    g_pjfa[l_ac].pjfa07,g_pjfa[l_ac].pjfaacti,g_today, #No.TQC-840009
                    g_pjfa[l_ac].pjfaacti,g_today,                      #No.TQC-840009
                    g_grup,g_user, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pjfa_file",g_pjfa[l_ac].pjfa02,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD pjfa02                        #default 序號
         IF cl_null(g_pjfa[l_ac].pjfa02) THEN
            SELECT max(pjfa02)+1 INTO g_pjfa[l_ac].pjfa02
              FROM pjfa_file 
             WHERE pjfa01 = g_pjfa01
            IF cl_null(g_pjfa[l_ac].pjfa02) THEN
               LET g_pjfa[l_ac].pjfa02 = 1
            END IF
         END IF
 
      AFTER FIELD pjfa02                        #check 是否重複
         IF NOT cl_null(g_pjfa[l_ac].pjfa02) THEN
            IF g_pjfa[l_ac].pjfa02 != g_pjfa_t.pjfa02 OR g_pjfa_t.pjfa02 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM pjfa_file
                WHERE pjfa02 = g_pjfa[l_ac].pjfa02 AND pjfa01 = g_pjfa01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_pjfa[l_ac].pjfa02 = g_pjfa_t.pjfa02
                  NEXT FIELD pjfa02
               END IF
               IF g_pjfa[l_ac].pjfa02 <= 0 THEN
                  CALL cl_err('pjfa02','aec-994',0)
                  NEXT FIELD pjfa02
               END IF
            END IF
         END IF
 
      BEFORE FIELD pjfa03
         CALL t120_set_entry(p_cmd)
         
      AFTER FIELD pjfa03                  #料件編號
        #FUN-AA0059 -----------------add start----------------------
         IF NOT cl_null(g_pjfa[l_ac].pjfa03) THEN
            IF NOT s_chk_item_no(g_pjfa[l_ac].pjfa03,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_pjfa[l_ac].pjfa03 = g_pjfa_o.pjfa03
               DISPLAY BY NAME g_pjfa[l_ac].pjfa03
               NEXT FIELD pjfa03
            END IF
         END IF
        #FUN-AA0059 ------------------add end----------------------- 
         IF g_pjfa_o.pjfa03 IS NULL OR (g_pjfa[l_ac].pjfa03 != g_pjfa_o.pjfa03) THEN
            IF g_pjfa[l_ac].pjfa03[1,4] !='MISC'  THEN
               CALL t120_pjfa03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjfa[l_ac].pjfa03,g_errno,0)
                  LET g_pjfa[l_ac].pjfa03 = g_pjfa_o.pjfa03
                  DISPLAY BY NAME g_pjfa[l_ac].pjfa03
                  NEXT FIELD pjfa03
               END IF
            ELSE CALL t120_pjfa03('a')
            END IF
         END IF
         LET g_pjfa_o.pjfa03 = g_pjfa[l_ac].pjfa03
         CALL t120_set_no_entry(p_cmd)
         
      BEFORE FIELD pjfa04
         CALL t120_set_entry(p_cmd)
         CALL t120_set_no_entry(p_cmd)
 
      AFTER FIELD pjfa05
         IF NOT cl_null(g_pjfa[l_ac].pjfa05) THEN
            IF g_pjfa[l_ac].pjfa05 < 0 THEN
               CALL cl_err('pjfa05','apj-035',0)
               NEXT FIELD pjfa05
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_pjfa_t.pjfa02 > 0 AND g_pjfa_t.pjfa02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pjfa_file
                 WHERE pjfa01 = g_pjfa01 AND pjfa02=g_pjfa_t.pjfa02
            IF SQLCA.sqlcode THEN
            #  CALL cl_err(g_pjfa_t.pjfa02,SQLCA.sqlcode,0)
               CALL cl_err3("del","pjfa_file",g_pjfa_t.pjfa02,"",SQLCA.sqlcode,"","",1)
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
            LET g_pjfa[l_ac].* = g_pjfa_t.*
            CLOSE t120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pjfa[l_ac].pjfa02,-263,1)
            LET g_pjfa[l_ac].* = g_pjfa_t.*
         ELSE
            UPDATE pjfa_file SET pjfa02 = g_pjfa[l_ac].pjfa02,
                                 pjfa03 = g_pjfa[l_ac].pjfa03,
                                 pjfa04 = g_pjfa[l_ac].pjfa04,
                                 pjfa05 = g_pjfa[l_ac].pjfa05,
                                 pjfa06 = g_pjfa[l_ac].pjfa06,
#                                 pjfa07 = g_pjfa[l_ac].pjfa07, #No.TQC-840009
                                 pjfaacti = g_pjfa[l_ac].pjfaacti,
                                 pjfamodu = g_user,
                                 pjfadate = g_today
             WHERE pjfa01 = g_pjfa01 AND pjfa02=g_pjfa_t.pjfa02
            IF SQLCA.sqlcode THEN
           #   CALL cl_err(g_pjfa[l_ac].pjfa02,SQLCA.sqlcode,0)
               CALL cl_err3("upd","pjfa_file",g_pjfa01,g_pjfa_t.pjfa02,SQLCA.sqlcode,"","",1)
               LET g_pjfa[l_ac].* = g_pjfa_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
                LET g_pjfa[l_ac].* = g_pjfa_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjfa.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t120_bcl
         COMMIT WORK
 
     ON ACTION CONTROLN
        CALL t120_b_askkey()
        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(pjfa02) AND l_ac > 1 THEN
            LET g_pjfa[l_ac].* = g_pjfa[l_ac-1].*
            NEXT FIELD pjfa02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjfa03)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form = "q_ima"
             #  LET g_qryparam.default1 = g_pjfa[l_ac].pjfa03
             #  CALL cl_create_qry() RETURNING g_pjfa[l_ac].pjfa03
               CALL q_sel_ima(FALSE, "q_ima", "", g_pjfa[l_ac].pjfa03, "", "", "", "" ,"",'' )  RETURNING g_pjfa[l_ac].pjfa03
#FUN-AA0059 --End--
               DISPLAY BY NAME g_pjfa[l_ac].pjfa03
               CALL t120_pjfa03('d')
               NEXT FIELD pjfa03
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
 
   CLOSE t120_bcl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t120_pjfa03(p_cmd)
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_ima25    LIKE ima_file.ima44,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT ima02,ima021,ima25,imaacti
      INTO l_ima02,l_ima021,l_ima25,l_imaacti
      FROM ima_file WHERE ima01 = g_pjfa[l_ac].pjfa03
 
   CASE 
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'mfg3006'
                                    LET l_ima02 = NULL
                                    LET l_ima021 = NULL
                                    LET l_ima25 = NULL
      WHEN l_imaacti='N'            LET g_errno = '9028'
      WHEN l_imaacti MATCHES '[PH]' LET g_errno = '9038'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_pjfa[l_ac].pjfa04  = l_ima02
      LET g_pjfa[l_ac].ima021 = l_ima021
      LET g_pjfa[l_ac].ima25 = l_ima25
      DISPLAY BY NAME g_pjfa[l_ac].ima25
      DISPLAY BY NAME g_pjfa[l_ac].pjfa04
      DISPLAY BY NAME g_pjfa[l_ac].ima021
   END IF
 
END FUNCTION
 
 
FUNCTION t120_b_askkey()
#DEFINE   l_wc2          LIKE type_file.chr1000
 DEFINE l_wc2  STRING     #NO.FUN-910082
 
#   CONSTRUCT l_wc2 ON pjfa02,pjfa03,pjfa04,pjfa05,pjfa06,pjfa07,pjfaacti      #螢幕上取單身條件 #No.TQC-840009
    CONSTRUCT l_wc2 ON pjfa02,pjfa03,pjfa04,pjfa05,pjfa06,pjfaacti  #No.TQC-840009
           FROM s_pjfa[1].pjfa02,s_pjfa[1].pjfa03,s_pjfa[1].pjfa04,
#                s_pjfa[1].pjfa05,s_pjfa[1].pjfa06,s_pjfa[1].pjfa07,s_pjfa[1].pjfaacti  #No.TQC-840009
                 s_pjfa[1].pjfa05,s_pjfa[1].pjfa06,s_pjfa[1].pjfaacti                   #No.TQC-840009
 
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
 
   CALL t120_b_fill(l_wc2)
 
END FUNCTION
 
 
FUNCTION t120_b_fill(p_wc2)
#   DEFINE p_wc2          LIKE type_file.chr1000
   DEFINE p_wc2  STRING     #NO.FUN-910082
 
#   LET g_sql="SELECT pjfa02,pjfa03,pjfa04,'','',pjfa05,pjfa06,pjfa07,pjfaacti", #No.TQC-840009 
   LET g_sql="SELECT pjfa02,pjfa03,pjfa04,'','',pjfa05,pjfa06,pjfaacti",         #No.TQC-840009 
             " FROM pjfa_file ",
             " WHERE pjfa01='",g_pjfa01,"' "
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pjfa02 "
   DISPLAY g_sql
   PREPARE t120_pb FROM g_sql
   DECLARE pjfa_cs CURSOR FOR t120_pb
   CALL g_pjfa.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pjfa_cs INTO g_pjfa[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima021,ima25 INTO g_pjfa[g_cnt].ima021,g_pjfa[g_cnt].ima25 FROM ima_file
        WHERE ima01 = g_pjfa[g_cnt].pjfa03
       IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","ima_file",g_pjfa[g_cnt].ima021,"",SQLCA.sqlcode,"","",0)  
         LET g_pjfa[g_cnt].ima021 = NULL
         LET g_pjfa[g_cnt].ima25 = NULL
       END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pjfa.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjfa TO s_pjfa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
         
      ON ACTION first
         CALL t120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
           
      ON ACTION previous
         CALL t120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
        
      ON ACTION jump
         CALL t120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION next
         CALL t120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION last
         CALL t120_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
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
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t120_copy()
   DEFINE l_newno     LIKE pjfa_file.pjfa01,
          l_oldno     LIKE pjfa_file.pjfa01,
          l_gem02     LIKE gem_file.gem02,
          l_cnt       LIKE type_file.num5
   DEFINE li_result   LIKE type_file.num5   
   DEFINE g_tl        LIKE pjfa_file.pjfa01
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjfa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM pjfa01
 
       AFTER FIELD pjfa01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO l_cnt FROM pjfa_file  #判斷是否重復
                  WHERE pjfa01 = l_newno
              IF l_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD pjfa01
              END IF
              SELECT pjb02 FROM pjb_file  
                    WHERE pjb02=l_newno
              IF SQLCA.sqlcode THEN
                  CALL cl_err(l_newno,'apj-004',0)    
                  DISPLAY BY NAME g_pjfa01
                  LET l_newno = NULL
                  NEXT FIELD pjfa01
              END IF
           END IF
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(pjfa01)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_pjb"
              LET g_qryparam.default1 = g_pjfa01
              CALL cl_create_qry() RETURNING l_newno
              DISPLAY l_newno TO pjfa01
              IF SQLCA.sqlcode THEN
                 DISPLAY BY NAME g_pjfa01
                 LET l_newno=NULL
                 NEXT FIELD pjfa01
              END IF
              NEXT FIELD pjfa01
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
    
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_pjfa01 TO pjfa01
      ROLLBACK WORK
      RETURN
    END IF
 
   DROP TABLE y
 
   SELECT * FROM pjfa_file 
       WHERE pjfa01=g_pjfa01
       INTO TEMP y
 
   UPDATE y
       SET pjfa01=l_newno, 
           pjfauser=g_user,
           pjfagrup=g_grup, 
           pjfamodu=NULL,  
           pjfadate=g_today, 
           pjfaacti='Y' 
 
   INSERT INTO pjfa_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pjfa_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pjfa01
   SELECT pjfa01 INTO g_pjfa01 FROM pjfa_file 
          WHERE pjfa01 = l_newno
#   CALL t120_u()
   CALL t120_b()
   #FUN-C80046---begin
   #SELECT pjfa01 INTO g_pjfa01 FROM pjfa_file 
   #       WHERE pjfa01 = l_oldno
   #CALL t120_show()
   #FUN-C80046---end
END FUNCTION
 
 
FUNCTION t120_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF INFIELD(pjfa03) THEN
      CALL cl_set_comp_entry("pjfa04",TRUE)
   END IF
END FUNCTION
 
 
FUNCTION t120_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
      IF g_pjfa[l_ac].pjfa03[1,4] !='MISC' THEN
         CALL cl_set_comp_entry("pjfa04",FALSE)
      END IF
END FUNCTION
 
 
FUNCTION t120_out()
   DEFINE   l_sw          LIKE type_file.chr1,
            l_i           LIKE type_file.num5,
            l_name        LIKE type_file.chr20,
            sr            RECORD
            pjb01         LIKE pjb_file.pjb01,
            pja02         LIKE pja_file.pja02,
            pjfa01        LIKE pjfa_file.pjfa01,
            pjb03         LIKE pjb_file.pjb03,
            pjb15         LIKE pjb_file.pjb15,
            pjb16         LIKE pjb_file.pjb16,
            pjfa02        LIKE pjfa_file.pjfa02,
            pjfa03        LIKE pjfa_file.pjfa03,
            pjfa04        LIKE pjfa_file.pjfa04,
            ima021        LIKE ima_file.ima021,
            ima25         LIKE ima_file.ima25,
            pjfa05        LIKE pjfa_file.pjfa05,
            pjfa06        LIKE pjfa_file.pjfa06,
#            pjfa07        LIKE pjfa_file.pjfa07,  #No.TQC-840009
            pjfaacti      LIKE pjfa_file.pjfaacti
                          END RECORD
            
   IF cl_null(g_pjfa01) THEN 
       CALL cl_err('',9057,0)
       RETURN
   END IF 
   IF cl_null(g_wc) THEN 
       LET g_wc =" pjfa01='",g_pjfa01,"'"  
   END IF     
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#No.TQC-840009-------------------start---------------------------------------
#   LET g_sql="SELECT pjb01,pja02,pjfa01,pjb03,pjb15,pjb16,pjfa02,pjfa03,",
#             " pjfa04,ima021,ima25,pjfa05,pjfa06,pjfa07,pjfaacti" ,
#             " FROM pjfa_file,pjb_file,pja_file,ima_file",
#             " WHERE pjb_file.pjb02 = pjfa01 AND pjb_file.pjb01 = pja_file.pja01",
#             " AND ima_file.ima01 = pjfa_file.pjfa03 AND ",g_wc CLIPPED
 
   LET g_sql="SELECT pjb01,pja02,pjfa01,pjb03,pjb15,pjb16,pjfa02,pjfa03,",
             " pjfa04,ima021,ima25,pjfa05,pjfa06,pjfaacti" ,
             " FROM pjfa_file LEFT OUTER JOIN ima_file ON ima_file.ima01 = pjfa_file.pjfa03 ,pjb_file,pja_file",
             " WHERE pjb_file.pjb02 = pjfa01 AND pjb_file.pjb01 = pja_file.pja01",
             " AND ",g_wc CLIPPED
#No.TQC-840009---------------------end---------------------------------------
   LET g_sql = g_sql CLIPPED," ORDER BY pjfa01,pjfa02"
   
   LET g_str=g_wc clipped
   IF g_zz05='Y' THEN
#      CALL cl_wcchp(g_str,'pjfa01,pjfa02,pjfa03,pjfa04,pjfa05,pjfa06,pjfa07,pjfaacti')  #No.TQC-840009
      CALL cl_wcchp(g_str,'pjfa01,pjfa02,pjfa03,pjfa04,pjfa05,pjfa06,pjfaacti')          #No.TQC-840009
         RETURNING g_str
   ELSE LET g_str=''
   END IF
   CALL cl_prt_cs1('apjt120','apjt120',g_sql,g_str)
 
 END FUNCTION
#NO.FUN-790025
