# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: apjt204.4gl
# Descriptions...: 活動預計人力耗用維護
# Date & Author..: FUN-790025 2007/11/09 By shiwuying
# Modify.........: No.TQC-840009 08/04/08 By shiwuying
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/09/29 By Smapmin 人事table drop
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_pjhb01         LIKE pjhb_file.pjhb01,
    g_pjhb02         LIKE pjhb_file.pjhb02,
    g_pjhb01_t       LIKE pjhb_file.pjhb01,
    g_pjhb02_t       LIKE pjhb_file.pjhb02,
    g_pjhb01_o       LIKE pjhb_file.pjhb01,
    g_pjhb02_o       LIKE pjhb_file.pjhb02,
    g_pja01          LIKE pja_file.pja01,
    g_pjhb1          RECORD
        pjhb01       LIKE pjhb_file.pjhb01,
        pjhb02       LIKE pjhb_file.pjhb02
                     END RECORD,
    g_pjhb           DYNAMIC ARRAY OF RECORD 
        pjhb03       LIKE pjhb_file.pjhb03,
        pjhb04       LIKE pjhb_file.pjhb04,
        #cpi02        LIKE cpi_file.cpi02,   #TQC-B90211
        cpi02        LIKE type_file.chr100,   #TQC-B90211
        pjx02        LIKE pjx_file.pjx02,
        pjx03        LIKE pjx_file.pjx03,
        pjhb05       LIKE pjhb_file.pjhb05,
        amt          LIKE type_file.num20_6,
        pjhbacti     LIKE pjhb_file.pjhbacti
                     END RECORD,
    g_pjhb_t         RECORD
        pjhb03       LIKE pjhb_file.pjhb03,
        pjhb04       LIKE pjhb_file.pjhb04,
        #cpi02        LIKE cpi_file.cpi02,   #TQC-B90211
        cpi02        LIKE type_file.chr100,   #TQC-B90211
        pjx02        LIKE pjx_file.pjx02,
        pjx03        LIKE pjx_file.pjx03,
        pjhb05       LIKE pjhb_file.pjhb05,
        amt          LIKE type_file.num20_6,
        pjhbacti     LIKE pjhb_file.pjhbacti
                     END RECORD,
    g_pjhb_o         RECORD                 #程式變數 (舊值)
        pjhb03       LIKE pjhb_file.pjhb03,
        pjhb04       LIKE pjhb_file.pjhb04,
        #cpi02        LIKE cpi_file.cpi02,   #TQC-B90211
        cpi02        LIKE type_file.chr100,   #TQC-B90211
        pjx02        LIKE pjx_file.pjx02,
        pjx03        LIKE pjx_file.pjx03,
        pjhb05       LIKE pjhb_file.pjhb05,
        amt          LIKE type_file.num20_6,
        pjhbacti     LIKE pjhb_file.pjhbacti
                     END RECORD,
    g_argv1          LIKE pjhb_file.pjhb01,    #網絡編號
    g_argv2          LIKE pjhb_file.pjhb02,    #活動編號
    g_wc,g_wc2,g_sql STRING,
    g_rec_b          LIKE type_file.num5,      #單身筆數
    l_ac             LIKE type_file.num5,
    g_ss             LIKE type_file.chr1,
    p_row,p_col      LIKE type_file.num5,
    g_pjaconf        LIKE pja_file.pjaconf
 
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
   LET g_pjhb01 = g_argv1
   LET g_pjhb02 = g_argv2
 
   LET g_forupd_sql = "SELECT pjhb01,pjhb02 FROM pjhb_file",
                      " WHERE pjhb01=? AND pjhb02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t204_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW t204_w AT p_row,p_col      #顯示畫面
        WITH FORM "apj/42f/apjt204"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      SELECT count(*) INTO g_cnt FROM pjhb_file WHERE pjhb01=g_argv1
                                                  AND pjhb02=g_argv2
      IF g_cnt >0 THEN
         CALL t204_q()
      ELSE
         LET g_pjhb01=g_argv1
         LET g_pjhb02=g_argv2
         CALL t204_show()
         CALL t204_b()
      END IF
   END IF
   IF NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN
      CALL t204_q()
   END IF
 
   CALL t204_menu()
 
   CLOSE WINDOW t204_w 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION t204_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   
   CLEAR FORM                             #清除畫面
   CALL g_pjhb.clear()
   IF NOT cl_null(g_argv1) THEN
      LET g_wc=" pjhb01 = '",g_argv1,"' " CLIPPED
      IF NOT cl_null(g_argv2) THEN
         LET g_wc=" pjhb01= '",g_argv1 clipped,"' AND pjhb02= '",g_argv2 CLIPPED,"'"
      END IF
   ELSE
      #螢幕上取單頭條件
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_pjhb01 TO NULL
      INITIALIZE g_pjhb02 TO NULL
      
      CONSTRUCT g_wc ON pjhb01,pjhb02,pjhb03,pjhb04,pjhb05,pjhbacti
         FROM pjhb01,pjhb02,s_pjhb[1].pjhb03,s_pjhb[1].pjhb04,
              s_pjhb[1].pjhb05,s_pjhb[1].pjhbacti
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
         ON ACTION controlp
            CASE
                WHEN INFIELD(pjhb01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pjk"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjhb01
                   NEXT FIELD pjhb01
                WHEN INFIELD(pjhb02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pjk1"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjhb02
                   NEXT FIELD pjhb02
                WHEN INFIELD(pjhb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pjx"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjhb04
                   NEXT FIELD pjhb04
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
   #      LET g_wc = g_wc clipped," AND pjhbuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND pjhbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND pjhbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('jhbuser', 'jhbgrup')
   #End:FUN-980030
   
   LET g_sql = "SELECT UNIQUE pjhb01,pjhb02 ",
               " FROM pjhb_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY pjhb01,pjhb02"
   PREPARE t204_prepare FROM g_sql
   DECLARE t204_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t204_prepare
 
   LET g_sql_tmp="SELECT UNIQUE pjhb01,pjhb02 FROM pjhb_file WHERE ",
                 g_wc CLIPPED,
                 " INTO TEMP x"
   
   DROP TABLE x
   PREPARE t204_precount_x FROM g_sql_tmp
   EXECUTE t204_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE t204_precount FROM g_sql
   DECLARE t204_count CURSOR FOR t204_precount
END FUNCTION
 
FUNCTION t204_menu()
   WHILE TRUE
      CALL t204_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t204_q()
            END IF
            
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t204_r()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN 
               CALL t204_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t204_out()
            END IF
         
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjhb),'','')
            END IF
            
         WHEN "related_document"  
          IF cl_chk_act_auth() THEN
             IF g_pjhb01 IS NOT NULL THEN
                LET g_doc.column1 = "pjhb01"
                LET g_doc.column2 = "pjhb02"
                LET g_doc.value1 = g_pjhb01
                LET g_doc.value2 = g_pjhb02
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t204_pjhb01(p_cmd)
    DEFINE l_pjj02     LIKE pjj_file.pjj02,
           l_pjjacti   LIKE pjj_file.pjjacti,
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjj02,pjjacti
     INTO l_pjj02,l_pjjacti
     FROM pjj_file WHERE pjj01=g_pjhb01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-048'
                                  LET l_pjj02   = NULL
                                  LET l_pjjacti = NULL
        WHEN l_pjjacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno)  OR p_cmd='d' THEN
      DISPLAY l_pjj02  TO FORMONLY.pjj02
   END IF
 
END FUNCTION
 
 
FUNCTION t204_pjhb02(p_cmd)
    DEFINE l_pjk03     LIKE pjk_file.pjk03,
           l_pjk16     LIKE pjk_file.pjk16,
           l_pjk17    LIKE pjk_file.pjk17,
           l_pjkacti   LIKE pjk_file.pjkacti,
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjk03,pjk16,pjk17,pjkacti
     INTO l_pjk03,l_pjk16,l_pjk17,l_pjkacti
     FROM pjk_file WHERE pjk01 = g_pjhb01 AND pjk02=g_pjhb02
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-047'
                                  LET l_pjk03   = NULL
                                  LET l_pjk16   = NULL
                                  LET l_pjk17   = NULL
                                  LET l_pjkacti = NULL
        WHEN l_pjkacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno)  OR p_cmd='d' THEN
      DISPLAY l_pjk03  TO FORMONLY.pjk03
      DISPLAY l_pjk16  TO FORMONLY.pjk16
      DISPLAY l_pjk17  TO FORMONLY.pjk17
   END IF
END FUNCTION
 
 
FUNCTION t204_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pjhb.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL t204_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjhb01=NULL
      LET g_pjhb02=NULL
      RETURN
   END IF
 
   OPEN t204_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjhb01=NULL
      LET g_pjhb02=NULL
   ELSE
      OPEN t204_count
      FETCH t204_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t204_fetch('F')
   END IF
 END FUNCTION
 
 
FUNCTION t204_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式 
   l_abso          LIKE type_file.num10     #絕對的筆數 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t204_cs INTO g_pjhb01,g_pjhb02
      WHEN 'P' FETCH PREVIOUS t204_cs INTO g_pjhb01,g_pjhb02
      WHEN 'F' FETCH FIRST    t204_cs INTO g_pjhb01,g_pjhb02
      WHEN 'L' FETCH LAST     t204_cs INTO g_pjhb01,g_pjhb02
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
         FETCH ABSOLUTE g_jump t204_cs INTO g_pjhb01,g_pjhb02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjhb01,SQLCA.sqlcode,0)
      INITIALIZE g_pjhb01 TO NULL
      INITIALIZE g_pjhb02 TO NULL 
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
   CALL t204_show()
END FUNCTION
 
 
FUNCTION t204_show()
   LET g_pjhb01_t = g_pjhb01
   LET g_pjhb01_o = g_pjhb01
   LET g_pjhb02_t = g_pjhb02
   LET g_pjhb02_o = g_pjhb02
   DISPLAY g_pjhb01,g_pjhb02 TO pjhb01,pjhb02 
   CALL t204_pjhb01('d')
   CALL t204_pjhb02('d')
   CALL t204_b_fill(g_wc)              
   CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION t204_r()
  DEFINE l_n,i    LIKE type_file.num5  
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pjhb01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
 
   LET g_pjhb01_t=g_pjhb01
   LET g_pjhb02_t=g_pjhb02
   BEGIN WORK
 
   OPEN t204_cl USING g_pjhb01_t,g_pjhb02_t
   IF STATUS THEN
      CALL cl_err("OPEN t204_cl:", STATUS, 1)
      CLOSE t204_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t204_cl INTO g_pjhb1.*              # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjhb01,SQLCA.sqlcode,0)
      CLOSE t204_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t204_show()
 
   IF cl_delh(0,0) THEN   #確認一下
       INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjhb01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "pjhb02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjhb01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_pjhb02       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()#No.FUN-9B0098 10/02/24
      DELETE FROM pjhb_file WHERE pjhb01=g_pjhb01 AND  pjhb02=g_pjhb02
      IF SQLCA.sqlcode THEN
      #  CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
         CALL cl_err3("del","pjhb_file",g_pjhb01,"",SQLCA.sqlcode,"","BODY DELETE",1) 
      ELSE
         CLEAR FORM
 
         DROP TABLE x
        #EXECUTE t204_precount_x 
         PREPARE t204_precount_x2 FROM g_sql_tmp 
         EXECUTE t204_precount_x2 
 
         CALL g_pjhb.clear()
         LET g_pjhb01 = NULL LET g_pjhb02 = NULL
         #EXECUTE t204_precount_x 
         #SELECT COUNT(*) INTO g_row_count FROM x #MOD-5A0004 mark
         OPEN t204_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t204_cs
            CLOSE t204_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t204_count INTO g_row_count 
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t204_cs
            CLOSE t204_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t204_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t204_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t204_fetch('/')
         END IF
      END IF
      COMMIT WORK
   END IF
 
   CLOSE t204_cl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION t204_b()
DEFINE
   l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,       #檢查重複用        
   l_cnt           LIKE type_file.num5,       #檢查重複用        
   l_flag          LIKE type_file.chr1,       
   l_lock_sw       LIKE type_file.chr1,       #單身鎖住否        
   p_cmd           LIKE type_file.chr1,       #處理狀態          
   l_allow_insert  LIKE type_file.num5,       #可新增否         
   l_allow_delete  LIKE type_file.num5        #可刪除否          
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pjhb01) THEN RETURN END IF
 
   IF cl_null(g_pjhb02) THEN RETURN END IF
 
   LET g_pjhb01_t=g_pjhb01
   LET g_pjhb02_t=g_pjhb02
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT pjhb03,pjhb04,'','','',pjhb05,'',pjhbacti",
                      " FROM pjhb_file",
                      " WHERE pjhb01=? AND pjhb02=? AND pjhb03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t204_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pjhb WITHOUT DEFAULTS FROM s_pjhb.*
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
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_pjhb_t.* = g_pjhb[l_ac].*  #BACKUP
            LET g_pjhb_o.* = g_pjhb[l_ac].*  #BACKUP
 
            OPEN t204_cl USING g_pjhb01,g_pjhb02
            IF STATUS THEN
               CALL cl_err("OPEN t204_cl:", STATUS, 1)
               CLOSE t204_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t204_cl INTO g_pjhb01,g_pjhb02     # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pjhb01,SQLCA.sqlcode,0)
               ROLLBACK WORK
               RETURN
            END IF
            LET p_cmd='u'
 
            OPEN t204_bcl USING g_pjhb01,g_pjhb02,g_pjhb_t.pjhb03
            IF STATUS THEN
               CALL cl_err("OPEN t204_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t204_bcl INTO g_pjhb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjhb_t.pjhb03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL t204_pjhb04('d')
               LET g_pjhb[l_ac].amt = g_pjhb[l_ac].pjx03 * g_pjhb[l_ac].pjhb05
               DISPLAY BY NAME g_pjhb[l_ac].amt
            END IF
            CALL cl_show_fld_cont() 
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjhb[l_ac].* TO NULL
         LET g_pjhb[l_ac].pjhbacti = 'Y'  #No.TQC-840009
         LET g_pjhb_t.* = g_pjhb[l_ac].*         #新輸入資料
         LET g_pjhb_o.* = g_pjhb[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD pjhb03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pjhb_file(pjhb01,pjhb02,pjhb03,pjhb04,pjhb05,
                               pjhbacti,pjhbuser,pjhbgrup,pjhbdate,pjhboriu,pjhborig)
                        VALUES(g_pjhb01,g_pjhb02,g_pjhb[l_ac].pjhb03,
                               g_pjhb[l_ac].pjhb04,g_pjhb[l_ac].pjhb05,
                               g_pjhb[l_ac].pjhbacti,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
         #  CALL cl_err(g_pjhb[l_ac].pjhb03,SQLCA.sqlcode,0)
            CALL cl_err3("ins","pjhb_file","","",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
            LET g_pjhb[l_ac].amt = g_pjhb[l_ac].pjx03 * g_pjhb[l_ac].pjhb05
            DISPLAY BY NAME g_pjhb[l_ac].amt
         END IF
 
      BEFORE FIELD pjhb03                        #default 序號
         IF cl_null(g_pjhb[l_ac].pjhb03) THEN
            SELECT max(pjhb03)+1 INTO g_pjhb[l_ac].pjhb03
              FROM pjhb_file
             WHERE pjhb01 = g_pjhb01 AND pjhb02 = g_pjhb02
            IF cl_null(g_pjhb[l_ac].pjhb03) THEN
               LET g_pjhb[l_ac].pjhb03 = 1
            END IF
         END IF
 
      AFTER FIELD pjhb03                         #check 是否重複
         IF NOT cl_null(g_pjhb[l_ac].pjhb03) THEN
            IF g_pjhb[l_ac].pjhb03 != g_pjhb_t.pjhb03 OR g_pjhb_t.pjhb03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM pjhb_file
                WHERE pjhb01 = g_pjhb01 AND pjhb02 = g_pjhb02
                  AND pjhb03 = g_pjhb[l_ac].pjhb03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_pjhb[l_ac].pjhb03 = g_pjhb_t.pjhb03
                  NEXT FIELD pjhb03
               END IF
            END IF
         END IF
         
      AFTER FIELD pjhb04 
         IF NOT cl_null(g_pjhb[l_ac].pjhb04) THEN
            IF g_pjhb[l_ac].pjhb04 != g_pjhb_t.pjhb04 OR g_pjhb_t.pjhb04 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM pjx_file
                WHERE pjx01 = g_pjhb[l_ac].pjhb04 AND pjxacti = 'Y'
               IF l_n = 0 THEN
                  CALL cl_err(g_pjhb[l_ac].pjhb04,'apj-034',0)
                  LET g_pjhb[l_ac].pjhb04 = g_pjhb_t.pjhb04
                  NEXT FIELD pjhb04
               END IF
               SELECT COUNT(*) INTO l_n FROM pjhb_file
                WHERE pjhb01 = g_pjhb01 AND pjhb02 = g_pjhb02
                  AND pjhb04 = g_pjhb[l_ac].pjhb04
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_pjhb[l_ac].pjhb04 = g_pjhb_t.pjhb04
                  NEXT FIELD pjhb04
               END IF
               CALL t204_pjhb04('d')
            END IF
         END IF
 
      AFTER FIELD pjhb05
         IF NOT cl_null(g_pjhb[l_ac].pjhb05) THEN
            IF g_pjhb[l_ac].pjhb05 < 0 THEN
               CALL cl_err(g_pjhb[l_ac].pjhb05,'apj-035',0)           
               NEXT FIELD pjhb05
            ELSE                  #No.TQC-840009
               LET g_pjhb[l_ac].amt = g_pjhb[l_ac].pjx03 * g_pjhb[l_ac].pjhb05  #No.TQC-840009
               DISPLAY BY NAME g_pjhb[l_ac].amt                #No.TQC-840009
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_pjhb_t.pjhb03 > 0 AND g_pjhb_t.pjhb03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pjhb_file
             WHERE pjhb01 = g_pjhb01
               AND pjhb02 = g_pjhb02
               AND pjhb03= g_pjhb_t.pjhb03
            IF SQLCA.sqlcode THEN
            #  CALL cl_err(g_pjhb_t.pjhb03,SQLCA.sqlcode,0)
               CALL cl_err3("del","pjhb_file",g_pjhb_t.pjhb03,"",SQLCA.sqlcode,"","",1)
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
            LET g_pjhb[l_ac].* = g_pjhb_t.*
            CLOSE t204_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pjhb[l_ac].pjhb03,-263,1)
            LET g_pjhb[l_ac].* = g_pjhb_t.*
         ELSE
            UPDATE pjhb_file SET 
                                pjhb03 = g_pjhb[l_ac].pjhb03,
                                pjhb04 = g_pjhb[l_ac].pjhb04,
                                pjhb05 = g_pjhb[l_ac].pjhb05,
                                pjhbacti = g_pjhb[l_ac].pjhbacti,
                                pjhbmodu = g_user,
                                pjhbdate = g_today,
                                pjhbgrup = g_grup
             WHERE pjhb01 = g_pjhb01
               AND pjhb02 = g_pjhb02
               AND pjhb03 = g_pjhb_t.pjhb03
            IF SQLCA.sqlcode THEN
           #   CALL cl_err(g_pjhb[l_ac].pjhb03,SQLCA.sqlcode,0)
               CALL cl_err3("upd","pjhb_file",g_pjhb01,g_pjhb_t.pjhb03,SQLCA.sqlcode,"","",1)
               LET g_pjhb[l_ac].* = g_pjhb_t.*
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
                LET g_pjhb[l_ac].* = g_pjhb_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjhb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t204_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30034 add
         CLOSE t204_bcl
         COMMIT WORK
         
#     ON ACTION CONTROLN
#        CALL t204_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(pjhb03) AND l_ac > 1 THEN
            LET g_pjhb[l_ac].* = g_pjhb[l_ac-1].*
            NEXT FIELD pjhb03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjhb04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pjx"
               LET g_qryparam.default1 = g_pjhb[l_ac].pjhb04
               CALL cl_create_qry() RETURNING g_pjhb[l_ac].pjhb04
                DISPLAY BY NAME g_pjhb[l_ac].pjhb04
               CALL  t204_pjhb04('d')
               NEXT FIELD pjhb04
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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
   CLOSE t204_bcl
   COMMIT WORK
 END FUNCTION
 
FUNCTION t204_pjhb04(p_cmd) 
    DEFINE #l_cpi02    LIKE cpi_file.cpi02,   #TQC-B90211
           l_pjx02    LIKE pjx_file.pjx02,
           l_pjx03    LIKE pjx_file.pjx03,
           l_pjxacti  LIKE pjx_file.pjxacti,
           p_cmd      LIKE type_file.chr1 
 
   LET g_errno = ' '
   #-----TQC-B90211---------
   #SELECT cpi02,pjx02,pjx03,pjxacti
   #  INTO l_cpi02,l_pjx02,l_pjx03,l_pjxacti
   #  FROM cpi_file,pjx_file WHERE pjx01 = g_pjhb[l_ac].pjhb04 AND cpi01=pjx01
   SELECT pjx02,pjx03,pjxacti
     INTO l_pjx02,l_pjx03,l_pjxacti
     FROM pjx_file WHERE pjx01 = g_pjhb[l_ac].pjhb04
   #-----END TQC-B90211-----
 
   CASE WHEN SQLCA.SQLCODE = 100      LET g_errno = 'mfg3006'
                                      #LET l_cpi02 = NULL   #TQC-B90211
                                      LET l_pjx02 = NULL
                                      LET l_pjx03 = NULL
        WHEN l_pjxacti='N'            LET g_errno = '9028'
        WHEN l_pjxacti MATCHES '[PH]' LET g_errno = '9038'
        OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      #LET g_pjhb[l_ac].cpi02 = l_cpi02   #TQC-B90211
      LET g_pjhb[l_ac].pjx02 = l_pjx02
      LET g_pjhb[l_ac].pjx03 = l_pjx03
 
      #DISPLAY BY NAME g_pjhb[l_ac].cpi02   #TQC-B90211
      DISPLAY BY NAME g_pjhb[l_ac].pjx02
      DISPLAY BY NAME g_pjhb[l_ac].pjx03
   END IF
END FUNCTION
 
 
FUNCTION t204_b_askkey()
#DEFINE    l_wc2          LIKE type_file.chr1000
 DEFINE l_wc2  STRING     #NO.FUN-910082 
 
   CONSTRUCT l_wc2 ON pjhb03,pjhb04,pjhb05,pjhb06,pjhbacti      #螢幕上取單身條件
           FROM s_pjhb[1].pjhb03,s_pjhb[1].pjhb04,
           s_pjhb[1].pjhb05,s_pjhb[1].pjhbacti
 
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
 
   CALL t204_b_fill(l_wc2)
END FUNCTION
 
 
FUNCTION t204_b_fill(p_wc2)
#DEFINE p_wc2          LIKE type_file.chr1000
DEFINE p_wc2  STRING     #NO.FUN-910082
 
   LET g_sql="SELECT pjhb03,pjhb04,'','','',pjhb05,'',pjhbacti",
             " FROM pjhb_file",
             " WHERE pjhb01='",g_pjhb01,"' AND pjhb02='",g_pjhb02,"'",
             " AND ",p_wc2 CLIPPED,  #單身
             " ORDER BY pjhb03"
 
   PREPARE t204_pb FROM g_sql
   DECLARE pjhb_cs CURSOR FOR t204_pb
   CALL g_pjhb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pjhb_cs INTO g_pjhb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #-----TQC-B90211---------
      #SELECT cpi02,pjx02,pjx03 INTO g_pjhb[g_cnt].cpi02,g_pjhb[g_cnt].pjx02,g_pjhb[g_cnt].pjx03
      #   FROM cpi_file,pjx_file
      #  WHERE pjx01 = g_pjhb[g_cnt].pjhb04 AND cpi01=pjx01
      # IF SQLCA.sqlcode THEN
      #   CALL cl_err3("sel","pjx_file",g_pjhb[g_cnt].pjx02,"",SQLCA.sqlcode,"","",0)  
      #   LET g_pjhb[g_cnt].cpi02 = NULL
      #   LET g_pjhb[g_cnt].pjx02 = NULL
      #   LET g_pjhb[g_cnt].pjx03 = NULL
      # END IF
      SELECT pjx02,pjx03 INTO g_pjhb[g_cnt].pjx02,g_pjhb[g_cnt].pjx03
         FROM pjx_file
        WHERE pjx01 = g_pjhb[g_cnt].pjhb04 
       IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pjx_file",g_pjhb[g_cnt].pjx02,"",SQLCA.sqlcode,"","",0)  
         LET g_pjhb[g_cnt].pjx02 = NULL
         LET g_pjhb[g_cnt].pjx03 = NULL
       END IF
      #-----END TQC-B90211-----
       
       LET g_pjhb[g_cnt].amt = g_pjhb[g_cnt].pjx03 * g_pjhb[g_cnt].pjhb05
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_pjhb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t204_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjhb TO s_pjhb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t204_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY 
           
      ON ACTION previous
         CALL t204_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION jump
         CALL t204_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION next
         CALL t204_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY 
 
      ON ACTION last
         CALL t204_fetch('L')
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
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t204_out()                                                             
   DEFINE l_cmd           LIKE type_file.chr1000                               
 
   IF cl_null(g_wc)                 
      AND NOT cl_null(g_pjhb01) AND NOT cl_null(g_pjhb02) THEN    
      LET g_wc=" pjhb01= '",g_pjhb01,"' AND pjhb02='",g_pjhb02,"' "
   END IF                                                                      
   IF cl_null(g_wc)  THEN                                                       
      CALL cl_err('','9057',0)
      RETURN
   END IF                                    
   LET l_cmd = 'p_query "apjt204" "',g_wc CLIPPED,'" '                         
   CALL cl_cmdrun(l_cmd)                                                       
   RETURN                                                                      
END FUNCTION 
#NO.FUN-790025
