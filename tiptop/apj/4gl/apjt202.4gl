# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: apjt202.4gl
# Descriptions...: 網絡間活動關系定義作業
# Date & Author..: No.FUN-790025 2007/11/27 By  zhangyajun
# Modify.........: No.TQC-840009 2008/04/03 By Zhangyajun BUG 修改
# Modify.........: No.TQC-840018 2008/04/14 By Zhangyajun 松弛時間(pjl05)改為>=0
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/07/30 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_pjl1         RECORD   
        pjl01       LIKE pjl_file.pjl01,
        pjluser     LIKE pjl_file.pjluser,
        pjlgrup     LIKE pjl_file.pjlgrup,
        pjlmodu     LIKE pjl_file.pjlmodu,
        pjldate     LIKE pjl_file.pjldate 
                     END RECORD,
    g_pjl1_t        RECORD   
        pjl01       LIKE pjl_file.pjl01,
        pjluser     LIKE pjl_file.pjluser,
        pjlgrup     LIKE pjl_file.pjlgrup,
        pjlmodu     LIKE pjl_file.pjlmodu,
        pjldate     LIKE pjl_file.pjldate     
                     END RECORD,
    g_pjl1_o        RECORD   
        pjl01       LIKE pjl_file.pjl01,
        pjluser     LIKE pjl_file.pjluser,
        pjlgrup     LIKE pjl_file.pjlgrup,
        pjlmodu     LIKE pjl_file.pjlmodu,
        pjldate     LIKE pjl_file.pjldate 
                     END RECORD,
 
    g_pjl           DYNAMIC ARRAY OF RECORD      
        pjl02       LIKE pjl_file.pjl02,
        pjk03       LIKE pjk_file.pjk03,
        pjl03       LIKE pjl_file.pjl03,
        pjk03_2     LIKE pjk_file.pjk03,
        pjl04       LIKE pjl_file.pjl04,
        pjl05       LIKE pjl_file.pjl05        
                     END RECORD,
    g_pjl_t         RECORD 
        pjl02       LIKE pjl_file.pjl02,
        pjk03       LIKE pjk_file.pjk03,
        pjl03       LIKE pjl_file.pjl03,
        pjk03_2     LIKE pjk_file.pjk03,
        pjl04       LIKE pjl_file.pjl04,
        pjl05       LIKE pjl_file.pjl05
                     END RECORD,
    g_pjl_o         RECORD
        pjl02       LIKE pjl_file.pjl02,
        pjk03       LIKE pjk_file.pjk03,
        pjl03       LIKE pjl_file.pjl03,
        pjk03_2     LIKE pjk_file.pjk03,
        pjl04       LIKE pjl_file.pjl04,
        pjl05       LIKE pjl_file.pjl05
                     END RECORD,
    g_wc,g_wc2,g_sql STRING,
    g_rec_b          LIKE type_file.num5,
    l_ac             LIKE type_file.num5,
    p_row,p_col      LIKE type_file.num5 
    
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
DEFINE g_argv1              LIKE pjj_file.pjj01
DEFINE g_argv2              LIKE pjk_file.pjk02
DEFINE g_errmsg             LIKE type_file.chr1000 
 
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
   INITIALIZE g_pjl1.pjl01 TO NULL
   
   LET g_forupd_sql = "SELECT pjl01,pjluser,pjlgrup,pjlmodu,pjldate FROM pjl_file",
                      " WHERE pjl01=?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t202_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW t202_w AT p_row,p_col
        WITH FORM "apj/42f/apjt202"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_pjl1.pjl01 = g_argv1
   IF NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN
      LET g_wc=g_wc,"pjl01 = '",g_argv1 CLIPPED,"'"
    LET g_action_choice="query"
    IF cl_chk_act_auth() THEN
    CALL t202_q()
    END IF
    IF g_rec_b<=0 THEN
       LET g_pjl1.pjl01 = g_argv1
       CALL t202_show()
       LET l_ac = g_rec_b + 1
       LET g_action_choice="detail"
       IF cl_chk_act_auth() THEN
       CALL t202_b()
       END IF
    END IF
   END IF
   CALL t202_menu()
   CLOSE WINDOW t202_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION t202_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
 
   CLEAR FORM
   CALL g_pjl.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_pjl1.* TO NULL
   
   IF cl_null(g_argv1) THEN
   CONSTRUCT BY NAME g_wc ON pjl01
       
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
             
       ON ACTION controlp
           CASE
               WHEN INFIELD(pjl01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pjj2"
                   CALL cl_create_qry() RETURNING g_pjl1.pjl01
                   DISPLAY BY NAME g_pjl1.pjl01
                   NEXT FIELD pjl01
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
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND pjluser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND pjlgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND pjlgrup IN ",cl_chk_tgrup_list()
   #   END IF 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjluser', 'pjlgrup')
   #End:FUN-980030
   CONSTRUCT g_wc2 ON pjl02,pjl03,pjl04,pjl05        
     FROM s_pjl[1].pjl02,s_pjl[1].pjl03,s_pjl[1].pjl04,s_pjl[1].pjl05
 
       BEFORE CONSTRUCT
	   CALL cl_qbe_display_condition(lc_qbe_sn)
       ON ACTION controlp
           CASE
               WHEN INFIELD(pjl02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pjk2"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1=g_pjl1.pjl01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjl02
                  NEXT FIELD pjl02
               WHEN INFIELD(pjl03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pjk2"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1=g_pjl1.pjl01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjl03
                  NEXT FIELD pjl03
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
   LET g_sql = "SELECT UNIQUE pjl01 ",
               " FROM pjl_file ",
               " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
               " ORDER BY pjl01"
   PREPARE t202_prepare FROM g_sql
   DECLARE t202_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t202_prepare
 
  IF g_wc2 = " 1=1" THEN
       LET g_sql_tmp="SELECT UNIQUE pjl01 FROM pjl_file WHERE ",g_wc CLIPPED,
                 " INTO TEMP x"
   ELSE
       LET g_sql_tmp="SELECT UNIQUE pjl01 FROM pjl_file WHERE ",
                 g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " INTO TEMP x"
   END IF
   
   DROP TABLE x                            
   PREPARE t202_precount_x FROM g_sql_tmp  
   EXECUTE t202_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE t202_precount FROM g_sql
   DECLARE t202_count CURSOR FOR t202_precount
END FUNCTION
 
FUNCTION t202_menu()
 
   WHILE TRUE
      CALL t202_bp("G")
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t202_q()
            END IF
         
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t202_r()
            END IF
              
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t202_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t202_out()
            END IF
         
         WHEN "help"
            CALL cl_show_help()
         
         WHEN "exit"
            EXIT WHILE
         
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjl),'','')
            END IF
         
         WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_pjl1.pjl01 IS NOT NULL THEN
                LET g_doc.column1 = "pjl01"
                LET g_doc.value1 = g_pjl1.pjl01
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t202_pjl01(p_cmd)
DEFINE  l_pjj02     LIKE pjj_file.pjj02,  
        l_pjj04     LIKE pjj_file.pjj04,
        l_pja02     LIKE pja_file.pja02,
        l_pjj05     LIKE pjj_file.pjj05,
        l_pjj06     LIKE pjj_file.pjj06,
        l_pjjacti   LIKE pjj_file.pjjacti,
        l_pjaacti   LIKE pja_file.pjaacti,
        l_pjaclose  LIKE pja_file.pjaclose, #No.FUN-960038
        p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjj02,pjj04,pjj05,pjj06,pjjacti 
      INTO l_pjj02,l_pjj04,l_pjj05,l_pjj06,l_pjjacti
      FROM pjj_file
      WHERE pjj01=g_pjl1.pjl01 
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-006'
                                  LET l_pjj02 = NULL
                                  LET l_pjj04 = NULL
                                  LET l_pjj05 = NULL
                                  LET l_pjj06 = NULL
        WHEN l_pjjacti='N'        LET g_errno = '9028'                                                           
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   SELECT pja02,pjaacti,pjaclose INTO l_pja02,l_pjaacti,l_pjaclose FROM pja_file #No.FUN-960038 add pjaclose
         WHERE pja01=l_pjj04  
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-006'
                                  LET l_pja02 = NULL                                
        WHEN l_pjaacti='N'        LET g_errno = '9028'                                                           
        WHEN l_pjaclose='Y'       LET g_errno = 'abg-503'      #No.FUN-960038
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_pjj02 TO FORMONLY.pjj02
      DISPLAY l_pjj04 TO FORMONLY.pjj04
      DISPLAY l_pjj05 TO FORMONLY.pjj05
      DISPLAY l_pjj06 TO FORMONLY.pjj06
      DISPLAY l_pja02 TO FORMONLY.pja02
   END IF
 
END FUNCTION
 
FUNCTION t202_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_pjl1.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pjl.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   
   CALL t202_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjl1.pjl01=NULL
      RETURN
   END IF
   
   OPEN t202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjl1.pjl01=NULL
   ELSE
      OPEN t202_count
      FETCH t202_count INTO g_row_count
      IF g_row_count > 0 THEN
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t202_fetch('F')                  # 讀出TEMP第一筆並顯示
      ELSE 
        CALL cl_err('',100,0)
      END IF
   END IF
 
END FUNCTION
 
 
FUNCTION t202_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式 
   l_abso          LIKE type_file.num10     #絕對的筆數 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t202_cs INTO g_pjl1.pjl01
      WHEN 'P' FETCH PREVIOUS t202_cs INTO g_pjl1.pjl01
      WHEN 'F' FETCH FIRST    t202_cs INTO g_pjl1.pjl01
      WHEN 'L' FETCH LAST     t202_cs INTO g_pjl1.pjl01
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
         FETCH ABSOLUTE g_jump t202_cs INTO g_pjl1.pjl01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pjl1.pjl01 TO NULL
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
   
   CALL t202_show()
 
END FUNCTION
 
FUNCTION t202_show()
   LET g_pjl1_t.* = g_pjl1.*
   LET g_pjl1_o.* = g_pjl1.*
   
   DISPLAY BY NAME g_pjl1.pjl01         #單頭
   CALL t202_pjl01('d')
   
   CALL t202_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t202_r()
  DEFINE l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
  DEFINE l_n    LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pjl1.pjl01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,pjj_file
    WHERE pja01=pjj04
      AND pjj01=g_pjl1.pjl01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
   BEGIN WORK
 
   OPEN t202_cl USING g_pjl1.pjl01
   IF STATUS THEN
      CALL cl_err("OPEN t202_cl:", STATUS, 1)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t202_cl INTO g_pjl1.*           # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL t202_show()
 
   IF cl_delh(0,0) THEN   #確認一下
       INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjl01"          #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjl1.pjl01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()#No.FUN-9B0098 10/02/24
      DELETE FROM pjl_file WHERE pjl01=g_pjl1.pjl01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pjl_file","","",SQLCA.sqlcode,"","BODY DELETE",1)
      ELSE
         CLEAR FORM
 
         DROP TABLE x
         PREPARE t202_precount_x2 FROM g_sql_tmp
         EXECUTE t202_precount_x2
         CALL g_pjl.clear()
         OPEN t202_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t202_cs
            CLOSE t202_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t202_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t202_cs
            CLOSE t202_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t202_cs
         IF g_row_count>0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t202_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t202_fetch('/')
         END IF
         END IF
      END IF
      COMMIT WORK
   END IF
 
   CLOSE t202_cl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t202_b()
DEFINE  l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
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
 
   IF cl_null(g_pjl1.pjl01) THEN
      RETURN
   END IF
#No.FUN-960038 --Begin                                                                                                              
   SELECT pjaclose INTO l_pjaclose                                                                                                  
     FROM pja_file,pjj_file                                                                                                         
    WHERE pja01=pjj04                                                                                                               
      AND pjj01=g_pjl1.pjl01                                                                                                        
   IF l_pjaclose = 'Y' THEN                                                                                                         
      CALL cl_err('','apj-602',0)                                                                                                   
      RETURN                                                                                                                        
   END IF                                                                                                                           
#No.FUN-960038 --End
   
   LET g_pjl1_t.pjl01=g_pjl1.pjl01
   CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT pjl02,'',pjl03,'',pjl04,pjl05"," FROM pjl_file",                      
#                      " WHERE pjl01 = ? AND pjl02 = ? AND pjl03 = ? FOR UPDATE"  #TQC-840009 mark
                      " WHERE pjl01 = ? AND pjl02 = ? AND pjl03 = ? FOR UPDATE"   #TQC-840009
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t202_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pjl WITHOUT DEFAULTS FROM s_pjl.*
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
            LET g_pjl_t.* = g_pjl[l_ac].*  #BACKUP
            LET g_pjl_o.* = g_pjl[l_ac].*  #BACKUP
 
            OPEN t202_cl USING g_pjl1.pjl01
            IF STATUS THEN
               CALL cl_err("OPEN t202_cl:", STATUS, 1)
               CLOSE t202_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t202_cl INTO g_pjl1.*     
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)
               CLOSE t202_cl
               ROLLBACK WORK
               RETURN
            END IF
 
#            OPEN t202_bcl USING g_pjl1.pjl01                             #TQC-840009 mark
            OPEN t202_bcl USING g_pjl1.pjl01,g_pjl_t.pjl02,g_pjl_t.pjl03  #TQC-840009 
            IF STATUS THEN
               CALL cl_err("OPEN t202_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t202_bcl INTO g_pjl[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjl_t.pjl03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL t202_pjl02('d')
               CALL t202_pjl03('d')
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjl[l_ac].* TO NULL
         LET g_pjl[l_ac].pjl04='1'             #初始值
         LET g_pjl[l_ac].pjl05= 0 
         LET g_pjl_t.* = g_pjl[l_ac].*         #新輸入資料
         LET g_pjl_o.* = g_pjl[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD pjl02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pjl_file(pjl01,pjl02,pjl03,pjl04,pjl05,pjluser,pjlgrup,pjlmodu,pjldate,pjloriu,pjlorig)
             VALUES(g_pjl1.pjl01,g_pjl[l_ac].pjl02,g_pjl[l_ac].pjl03,g_pjl[l_ac].pjl04,
                    g_pjl[l_ac].pjl05,g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pjl_file","","",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
     AFTER FIELD pjl02                      
         IF NOT cl_null(g_pjl[l_ac].pjl02) THEN         
#             IF  g_pjl[l_ac].pjl02 !=g_pjl_t.pjl02 OR g_pjl_t.pjl02 IS NULL OR g_pjl1.pjl01!=g_pjl1_o.pjl01  THEN  #TQC-840009 mark
              IF p_cmd='a' OR (p_cmd='u' AND g_pjl[l_ac].pjl02!=g_pjl_t.pjl02) THEN    #TQC-840009
               CALL t202_pjl02('a')
               IF NOT cl_null(g_errno) THEN
                 LET g_errmsg = g_pjl[l_ac].pjl03
                 CALL cl_err(g_errmsg,g_errno,0)
                 LET g_pjl[l_ac].pjl02=g_pjl_t.pjl02
                 NEXT FIELD pjl02
               END IF
             IF NOT cl_null(g_pjl[l_ac].pjl03) THEN
               IF g_pjl[l_ac].pjl02=g_pjl[l_ac].pjl03 THEN
                 LET g_errmsg = g_pjl[l_ac].pjl03
                 CALL cl_err(g_errmsg,'apj-046',0)
                 LET g_pjl[l_ac].pjl02=g_pjl_t.pjl02
                 LET g_pjl[l_ac].pjk03_2=g_pjl_t.pjk03_2
                 NEXT FIELD pjl02
               END IF
               SELECT COUNT(*) INTO l_n FROM pjl_file
                     WHERE pjl01 = g_pjl1.pjl01 AND pjl02 = g_pjl[l_ac].pjl02 
                           AND pjl03 = g_pjl[l_ac].pjl03
               IF l_n > 0 THEN 
                 LET g_errmsg=g_pjl1.pjl01,",",g_pjl[l_ac].pjl02,",",g_pjl[l_ac].pjl03
                 CALL cl_err(g_errmsg,-239,1)
                 LET g_pjl[l_ac].pjl02=g_pjl_t.pjl02  #TQC-840009
                 NEXT FIELD pjl02
               END IF
             END IF
             END IF
          END IF
      AFTER FIELD pjl03                       
         IF NOT cl_null(g_pjl[l_ac].pjl03) THEN
#            IF g_pjl[l_ac].pjk03 !=g_pjl_t.pjl03 OR g_pjl_t.pjl03 IS NULL OR g_pjl1.pjl01!=g_pjl1_o.pjl01  THEN  #TQC-840009
             IF p_cmd='a' OR (p_cmd='u' AND g_pjl[l_ac].pjl03!=g_pjl_t.pjl03) THEN    #TQC-840009  
               CALL t202_pjl03('a')
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_pjl[l_ac].pjl03=g_pjl_t.pjl03
                 NEXT FIELD pjl03
                END IF
            IF NOT cl_null(g_pjl[l_ac].pjl02) THEN
               IF g_pjl[l_ac].pjl02=g_pjl[l_ac].pjl03 THEN
                 CALL cl_err('pjl03','apj-046',0)
                 LET g_pjl[l_ac].pjl03=g_pjl_t.pjl03
                 LET g_pjl[l_ac].pjk03_2=g_pjl_t.pjk03_2
                 NEXT FIELD pjl03
               END IF
               SELECT COUNT(*) INTO l_n FROM pjl_file
                     WHERE pjl01 = g_pjl1.pjl01 AND pjl02 = g_pjl[l_ac].pjl02 
                           AND pjl03 = g_pjl[l_ac].pjl03
               IF l_n > 0 THEN 
                   LET g_errmsg=g_pjl1.pjl01,",",g_pjl[l_ac].pjl02,",",g_pjl[l_ac].pjl03  
                   CALL cl_err(g_errmsg,-239,1)
                   LET g_pjl[l_ac].pjl03=g_pjl_t.pjl03 #TQC-840009
                   NEXT FIELD pjl03
               END IF
             END IF
             END IF
          END IF
 
      AFTER FIELD pjl05
         IF NOT cl_null(g_pjl[l_ac].pjl05) THEN
#            IF g_pjl[l_ac].pjl05 <= 0 THEN    #TQC-840018 mark
             IF g_pjl[l_ac].pjl05 < 0 THEN     #TQC-840018
               LET g_errmsg = g_pjl[l_ac].pjl05
#               CALL cl_err(g_errmsg,'apj-036',0) #TQC-840018 mark
               CALL cl_err(g_errmsg,'apj-035',0)  #TQC-840018
               NEXT FIELD pjl05
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_pjl_t.pjl02 IS NOT NULL AND g_pjl_t.pjl03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pjl_file
                 WHERE pjl01 = g_pjl1.pjl01 AND pjl02=g_pjl_t.pjl02 AND pjl03=g_pjl_t.pjl03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pjl_file",g_pjl_t.pjl02,g_pjl_t.pjl03,SQLCA.sqlcode,"","",1)
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
            LET g_pjl[l_ac].* = g_pjl_t.*
            CLOSE t202_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err('',-263,1)
            LET g_pjl[l_ac].* = g_pjl_t.*
         ELSE
            UPDATE pjl_file SET  pjl02 = g_pjl[l_ac].pjl02,
                                 pjl03 = g_pjl[l_ac].pjl03,
                                 pjl04 = g_pjl[l_ac].pjl04,
                                 pjl05 = g_pjl[l_ac].pjl05,
                                 pjlmodu = g_user,
                                 pjldate = g_today
             WHERE pjl01 = g_pjl1.pjl01 AND pjl02 = g_pjl_t.pjl02 AND pjl03=g_pjl_t.pjl03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pjl_file","","",SQLCA.sqlcode,"","",1)
               LET g_pjl[l_ac].* = g_pjl_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac              #FUN-D30034 mark
        #LET g_pjl_t.* = g_pjl[l_ac].*  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
                LET g_pjl[l_ac].* = g_pjl_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjl.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t202_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         CLOSE t202_bcl
         COMMIT WORK
 
     ON ACTION CONTROLN
        CALL t202_b_askkey()
        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(pjl02) AND l_ac > 1 THEN
            LET g_pjl[l_ac].* = g_pjl[l_ac-1].*
            NEXT FIELD pjl02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjl02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pjk2"
               LET g_qryparam.default1 = g_pjl[l_ac].pjl02
               LET g_qryparam.arg1=g_pjl1.pjl01
               CALL cl_create_qry() RETURNING g_pjl[l_ac].pjl02
               DISPLAY BY NAME g_pjl[l_ac].pjl02
               CALL t202_pjl02('d')
               NEXT FIELD pjl02
            WHEN INFIELD(pjl03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pjk2"
               LET g_qryparam.default1 = g_pjl[l_ac].pjl03
               LET g_qryparam.arg1=g_pjl1.pjl01
               CALL cl_create_qry() RETURNING g_pjl[l_ac].pjl03
               DISPLAY BY NAME g_pjl[l_ac].pjl03
               CALL t202_pjl03('d')
               NEXT FIELD pjl03
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
 
   CLOSE t202_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t202_pjl02(p_cmd)
DEFINE l_pjk03    LIKE pjk_file.pjk03,
       l_pjkacti  LIKE pjk_file.pjkacti,    
       p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjk03,pjkacti
      INTO l_pjk03,l_pjkacti
      FROM pjk_file 
      WHERE pjk01=g_pjl1.pjl01 AND pjk02 = g_pjl[l_ac].pjl02
 
   CASE 
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'apj-047'
                                    LET l_pjk03 = NULL
      WHEN l_pjkacti='N'            LET g_errno = '9028'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_pjl[l_ac].pjk03  = l_pjk03
      DISPLAY BY NAME g_pjl[l_ac].pjk03
   END IF
 
END FUNCTION
 
FUNCTION t202_pjl03(p_cmd)
DEFINE l_pjk03_2    LIKE pjk_file.pjk03,
       l_pjkacti  LIKE pjk_file.pjkacti,    
       p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjk03,pjkacti
      INTO l_pjk03_2,l_pjkacti
      FROM pjk_file 
      WHERE pjk01=g_pjl1.pjl01 AND pjk02 = g_pjl[l_ac].pjl03
 
   CASE 
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'apj-047'
                                    LET l_pjk03_2 = NULL
      WHEN l_pjkacti='N'            LET g_errno = '9028'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_pjl[l_ac].pjk03_2  = l_pjk03_2
      DISPLAY BY NAME g_pjl[l_ac].pjk03_2
   END IF
 
END FUNCTION
 
FUNCTION t202_b_askkey()
#DEFINE   l_wc2          LIKE type_file.chr1000
 DEFINE l_wc2  STRING     #NO.FUN-910082
 
   CONSTRUCT l_wc2 ON pjl02,pjl03,pjl04,pjl05      #螢幕上取單身條件
           FROM s_pjl[1].pjl02,s_pjl[1].pjl03,s_pjl[1].pjl04,
                s_pjl[1].pjl05
 
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
 
   CALL t202_b_fill(l_wc2)
 
END FUNCTION
 
 
FUNCTION t202_b_fill(p_wc2)
#   DEFINE p_wc2          LIKE type_file.chr1000
   DEFINE p_wc2  STRING     #NO.FUN-910082
 
   LET g_sql="SELECT pjl02,'',pjl03,'',pjl04,pjl05",
             " FROM pjl_file ",
             " WHERE pjl01='",g_pjl1.pjl01,"'"
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pjl02 "
   DISPLAY g_sql
   PREPARE t202_pb FROM g_sql
   DECLARE pjl_cs CURSOR FOR t202_pb
   CALL g_pjl.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pjl_cs INTO g_pjl[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT pjk03 INTO g_pjl[g_cnt].pjk03 FROM pjk_file
        WHERE pjk01 = g_pjl1.pjl01 AND pjk02 = g_pjl[g_cnt].pjl02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pjk_file",g_pjl[g_cnt].pjl02,"",SQLCA.sqlcode,"","",0)  
         LET g_pjl[g_cnt].pjl02 = NULL
         LET g_pjl[g_cnt].pjk03 = NULL
       END IF
      SELECT pjk03 INTO g_pjl[g_cnt].pjk03_2 FROM pjk_file
        WHERE pjk01 = g_pjl1.pjl01 AND pjk02 = g_pjl[g_cnt].pjl03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pjk_file",g_pjl[g_cnt].pjl03,"",SQLCA.sqlcode,"","",0)  
         LET g_pjl[g_cnt].pjl03 = NULL
         LET g_pjl[g_cnt].pjk03_2 = NULL
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pjl.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjl TO s_pjl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
           
      ON ACTION previous
         CALL t202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
        
      ON ACTION jump
         CALL t202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION next
         CALL t202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION last
         CALL t202_fetch('L')
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
 
FUNCTION t202_out()
   IF cl_null(g_pjl1.pjl01) OR g_rec_b=0 THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF cl_null(g_wc) THEN LET g_wc="pjl01 = '",g_pjl1.pjl01 CLIPPED,"'" END IF
   IF cl_null(g_wc2) THEN LET g_wc2=" 1=1" END IF                                                                      
   LET g_msg ='p_query "apjt202" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                               
   CALL cl_cmdrun(g_msg)
END FUNCTION
#No.FUN-790025
