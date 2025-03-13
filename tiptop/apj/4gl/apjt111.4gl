# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apjt111.4gl
# Descriptions...: WBS備注維護作業
# Date & Author..: No.FUN-790025 07/10/26 By lala
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-790025
# Modify.........: No.TQC-840009 
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pjc01         LIKE pjc_file.pjc01,
    g_pjc01_t       LIKE pjc_file.pjc01,
    g_pjc           DYNAMIC ARRAY OF RECORD
        pjc02       LIKE pjc_file.pjc02,
        pjc03       LIKE pjc_file.pjc03
                    END RECORD,
    g_pjc_t         RECORD
        pjc02       LIKE pjc_file.pjc02,
        pjc03       LIKE pjc_file.pjc03
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_wc            STRING,
    g_rec_b         LIKE type_file.num5,
    l_ac            LIKE type_file.num5,
    g_ss            LIKE type_file.chr1,
    l_flag          LIKE type_file.chr1,
    g_pjaconf       LIKE pja_file.pjaconf
 
DEFINE g_forupd_sql         STRING
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_i                  LIKE type_file.num5
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE g_argv1              LIKE pjb_file.pjb01            #FUN-790025 add  by douzh 
DEFINE g_argv2              LIKE pjb_file.pjb02            #FUN-790025 add  by douzh 
DEFINE g_cn         LIKE type_file.num5
 
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5
 
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
 
   LET g_argv1 = ARG_VAL(1)                           #FUN-790025 add  by douzh          
   LET g_argv2 = ARG_VAL(2)                           #FUN-790025 add  by douzh 
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW t111_w AT p_row,p_col
     WITH FORM "apj/42f/apjt111"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   LET g_forupd_sql = "SELECT pjc01 FROM pjc_file",
                      " WHERE pjc01 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t111_cl CURSOR FROM g_forupd_sql
 
   CALL cl_ui_init()
   LET g_wc2 = '1=1'
   CALL t111_b_fill(g_wc2)
   LET g_action_choice=""
   
   IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN 
      SELECT count(*) INTO g_cn FROM pjc_file WHERE pjc01 = g_argv2
      IF g_cn > 0 THEN
         CALL t111_q()
      ELSE
#        CALL t111_a()
         CALL t111_pjc01('a')
         CALL t111_b()
      END IF
   END IF
      CALL t111_menu()
   CLOSE WINDOW t111_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t111_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
 
   CLEAR FORM                             
   IF cl_null(g_argv1) THEN                 #FUN-790025 add  by douzh 
      CALL g_pjc.clear()
     
      CALL cl_set_head_visible("","YES")   
      INITIALIZE g_pjc01 TO NULL   
 
      CONSTRUCT BY NAME g_wc ON pjc01
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
          CASE
             WHEN INFIELD(pjc01) 
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pjb"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pjc01
                NEXT FIELD pjc01 
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
 
      CONSTRUCT g_wc2 ON pjc02,pjc03
              FROM s_pjc[1].pjc02,s_pjc[1].pjc03
 
		
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
   ELSE                                                            #FUN-790025 add  by douzh
      LET g_wc="pjc01='",g_argv2,"'"                               #FUN-790025 add  by douzh   
   END IF                                                          #FUN-790025 add  by douzh 
 
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
 
    LET g_sql = "SELECT UNIQUE pjc01 ",
               " FROM pjc_file ",
               " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
               " ORDER BY pjc01"
   PREPARE t111_prepare FROM g_sql
   DECLARE t111_cs
       SCROLL CURSOR WITH HOLD FOR t111_prepare
 
   IF g_wc2 = " 1=1" THEN                     
       LET g_sql_tmp="SELECT UNIQUE pjc01 FROM pjc_file WHERE ",g_wc CLIPPED,  
                 " INTO TEMP x"
   ELSE
       LET g_sql_tmp="SELECT UNIQUE pjc01 FROM pjc_file WHERE ",  
                 g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " INTO TEMP x"
   END IF
  
   DROP TABLE x                            
   PREPARE t111_precount_x FROM g_sql_tmp  
   EXECUTE t111_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
 
   PREPARE t111_precount FROM g_sql
   DECLARE t111_count CURSOR FOR t111_precount
    
END FUNCTION
 
FUNCTION t111_menu()
 
   WHILE TRUE
      CALL t111_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t111_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t111_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t111_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t111_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjc),'','')
            END IF
 
         WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_pjc01 IS NOT NULL THEN
                LET g_doc.column1 = "pjc01"
                LET g_doc.value1 = g_pjc01
                CALL cl_doc()
             END IF
          END IF
      END CASE
   END WHILE
END FUNCTION
 
#FUNCTION t111_a()
#  MESSAGE ""
#  CLEAR FORM
#  CALL g_pjc.clear()
#  IF s_shut(0) THEN RETURN END IF
#  LET g_pjc01 = NULL
#  CALL cl_opmsg('a')
 
#  WHILE TRUE
#     IF NOT cl_null(g_argv1) AND g_argv2 IS NOT NULL THEN
#        LET g_pjc01 = g_argv2
#        DISPLAY g_pjc01 TO pjc01
#     END IF
#     CALL t111_pjc01('a')
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CALL cl_err('',9001,0)
#        EXIT WHILE
#     END IF
 
#     IF cl_null(g_pjc01) THEN
#        CONTINUE WHILE
#     END IF
 
#     LET g_rec_b = 0
#     CALL t111_b()
 
#     LET g_pjc01_t=g_pjc01
#     EXIT WHILE
#  END WHILE
#END FUNCTION
 
FUNCTION t111_pjc01(p_cmd)
DEFINE l_pjb01     LIKE pjb_file.pjb01,
       l_pjb03     LIKE pjb_file.pjb03,
       l_pja02     LIKE pja_file.pja02,
       p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN
      SELECT pjb03
      INTO l_pjb03
      FROM pjb_file WHERE pjb01=g_argv1
      AND pjb02 = g_argv2
   ELSE
      SELECT pjb01,pjb03
      INTO l_pjb01,l_pjb03
      FROM pjb_file WHERE pjb02=g_pjc01
   END IF
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-004'
                                  LET l_pjb01   = NULL
                                  LET l_pjb03   = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN
      SELECT pja02 INTO l_pja02
        FROM pja_file WHERE  pja01=g_argv1
   ELSE
      SELECT pja02 INTO l_pja02
        FROM pja_file WHERE  pja01=l_pjb01
   END IF
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-004'
                                  LET l_pja02   = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN
         LET l_pjb01 = g_argv1
         LET g_pjc01 = g_argv2
         DISPLAY g_pjc01 TO pjc01
      END IF
      DISPLAY l_pjb01 TO pjb01
      DISPLAY l_pjb03 TO pjb03
      DISPLAY l_pja02 TO pja02
   END IF
END FUNCTION
 
FUNCTION t111_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_pjc01 TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pjc.clear()
 
   CALL t111_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjc01 = NULL
      RETURN
   END IF
 
   OPEN t111_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjc01 = NULL
   ELSE
      OPEN t111_count
      FETCH t111_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t111_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t111_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t111_cs INTO g_pjc01
        WHEN 'P' FETCH PREVIOUS t111_cs INTO g_pjc01
        WHEN 'F' FETCH FIRST    t111_cs INTO g_pjc01
        WHEN 'L' FETCH LAST     t111_cs INTO g_pjc01
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
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
      END IF
      FETCH ABSOLUTE g_jump t111_cs INTO g_pjc01
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pjc01,SQLCA.sqlcode,0)
       INITIALIZE g_pjc01 TO NULL
       DISPLAY g_pjc01 TO pjc01
    ELSE
       OPEN t111_count
       FETCH t111_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL t111_show()
 
END FUNCTION
 
FUNCTION t111_show()
 
   DISPLAY g_pjc01 TO pjc01
   CALL t111_pjc01('a')
   CALL t111_b_fill(' 1=1')
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t111_b()
DEFINE
   l_pjc02         LIKE pjc_file.pjc02,
   l_pjc03         LIKE pjc_file.pjc03,
   l_ac_t          LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5
  ,l_pjaclose      LIKE pja_file.pjaclose     #FUN-960038
 
   LET g_action_choice = ""
 
   IF g_pjc01 IS NULL AND g_argv1 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF s_shut(0) THEN RETURN END IF
 
   LET g_pjc01_t=g_pjc01
 
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,pjb_file
    WHERE pjb02=g_pjc01 AND pjb01=pja01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err3("sel","pja_file",g_pjc01,"","apj-602","","",1)
      RETURN
   END IF
#No.FUN-960038 --End
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT pjc02,pjc03 FROM pjc_file",
                      " WHERE pjc01=? AND pjc02=?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t111_bcl CURSOR FROM g_forupd_sql
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pjc WITHOUT DEFAULTS FROM s_pjc.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         LET g_pjc01_t = g_pjc01
         IF g_rec_b >= l_ac THEN
         BEGIN WORK
            LET p_cmd='u'
            LET g_pjc_t.* = g_pjc[l_ac].*
            OPEN t111_cl USING g_pjc01
            IF STATUS THEN
               CALL cl_err("OPEN t111_cl:", STATUS, 1)
               CLOSE t111_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t111_cl INTO g_pjc01
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pjc01,SQLCA.sqlcode,0)
               RETURN
            END IF
            LET p_cmd='u'
 
            OPEN t111_bcl USING g_pjc01,g_pjc_t.pjc02
            IF STATUS THEN
               CALL cl_err("OPEN t111_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH t111_bcl INTO g_pjc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjc_t.pjc02,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjc[l_ac].* TO NULL
         LET g_pjc_t.* = g_pjc[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD pjc02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pjc_file(pjc01,pjc02,pjc03)
             VALUES(g_pjc01,g_pjc[l_ac].pjc02,g_pjc[l_ac].pjc03)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pjc_file",g_pjc[l_ac].pjc02,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD pjc02
         IF cl_null(g_pjc[l_ac].pjc02) THEN
            SELECT max(pjc02)+1 INTO g_pjc[l_ac].pjc02
              FROM pjc_file
             WHERE pjc01 = g_pjc01
            IF cl_null(g_pjc[l_ac].pjc02) THEN
               LET g_pjc[l_ac].pjc02 = 1
            END IF
         END IF
      AFTER FIELD pjc02
         IF NOT cl_null(g_pjc[l_ac].pjc02) THEN
            IF g_pjc[l_ac].pjc02 != g_pjc_t.pjc02 OR g_pjc_t.pjc02 IS NULL THEN
            SELECT count(*) INTO l_n FROM pjc_file
             WHERE pjc02 = g_pjc[l_ac].pjc02
               AND pjc01 = g_pjc01
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_pjc[l_ac].pjc02 = g_pjc_t.pjc02
               NEXT FIELD pjc02
            END IF
         END IF
         IF g_pjc[l_ac].pjc02<=0 THEN
               CALL cl_err('pjc02','aec-994',0)
               NEXT FIELD pjc02
            END IF
          ELSE
             CALL cl_err('pjc02','apm-915',0)
             NEXT FIELD pjc02
         END IF
      AFTER FIELD pjc03                 
         IF g_pjc_t.pjc03 IS NULL OR (g_pjc[l_ac].pjc03 != g_pjc_t.pjc03) THEN
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pjc[l_ac].pjc03,g_errno,0)
               LET g_pjc[l_ac].pjc03 = g_pjc_t.pjc03
               DISPLAY BY NAME g_pjc[l_ac].pjc03
               NEXT FIELD pjc03
            END IF
         END IF
         LET g_pjc_t.pjc03 = g_pjc[l_ac].pjc03
         CALL t111_set_no_entry(p_cmd)
 
      BEFORE DELETE
         IF g_pjc_t.pjc02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pjc_file
             WHERE pjc02 = g_pjc_t.pjc02
               AND pjc01 = g_pjc01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pjc_file",g_pjc_t.pjc02,"",SQLCA.sqlcode,"","",1)
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
            LET g_pjc[l_ac].* = g_pjc_t.*
            CLOSE t111_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pjc[l_ac].pjc02,-263,1)
            CALL cl_err(g_pjc[l_ac].pjc03,-263,1)
            LET g_pjc[l_ac].* = g_pjc_t.*
         ELSE
            UPDATE pjc_file SET pjc01 = g_pjc01,
                                pjc02 = g_pjc[l_ac].pjc02,
                                pjc03 = g_pjc[l_ac].pjc03
             WHERE pjc01=g_pjc01
               AND pjc02=g_pjc_t.pjc02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pjc_file",g_pjc01,"",SQLCA.sqlcode,"","",1)
               LET g_pjc[l_ac].* = g_pjc_t.*
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
                LET g_pjc[l_ac].* = g_pjc_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjc.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t111_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t111_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO
         IF INFIELD(pjc02) AND l_ac > 1 THEN
            LET g_pjc[l_ac].* = g_pjc[l_ac-1].*
            LET g_pjc[l_ac].pjc02 = NULL
            NEXT FIELD pjc02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
 
   CLOSE t111_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t111_b_askkey()
 
   CLEAR FORM
   CALL g_pjc.clear()
   CONSTRUCT g_wc2 ON pjc02,pjc03 FROM s_pjc[1].pjc02,s_pjc[1].pjc03
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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   CALL t111_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t111_b_fill(p_wc2)
#DEFINE    p_wc2       LIKE type_file.chr1000
DEFINE p_wc2  STRING     #NO.FUN-910082
 
   LET g_sql ="SELECT pjc02,pjc03",
              " FROM pjc_file",
              " WHERE pjc01='",g_pjc01,"' AND ",p_wc2 CLIPPED,
              " ORDER BY 1"
   PREPARE t111_pb FROM g_sql
   DECLARE pjc_curs CURSOR FOR t111_pb
 
   LET g_cnt = 1
   MESSAGE "Searching!"
   CALL g_pjc.clear()
   FOREACH pjc_curs INTO g_pjc[g_cnt].*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pjc.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t111_r()
    DEFINE l_msg       LIKE type_file.chr1000
    DEFINE l_n1,l_n    LIKE type_file.num5
    DEFINE l_pjaconf   LIKE pja_file.pjaconf
    DEFINE l_pjaclose  LIKE pja_file.pjaclose
    IF g_pjc01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
 
    IF cl_null(g_pjc01) THEN RETURN END IF
    LET g_success='Y'
    LET g_pjc01_t = g_pjc01
    SELECT pjaconf INTO g_pjaconf 
        FROM pja_file,pjb_file 
        WHERE pjb02=g_pjc01 AND pjb01=pja01
        
   IF g_pjaconf = 'Y' THEN
      CALL cl_err3("sel","pja_file",g_pjc01,"","anm-105","","",1) 
      RETURN
   END IF
    BEGIN WORK
 
    OPEN t111_cl USING g_pjc01_t
    IF STATUS THEN
       CALL cl_err("OPEN t111_cl:", STATUS, 1)
       CLOSE t111_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t111_cl INTO g_pjc01
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjc01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
    IF cl_delh(0,0) THEN
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pjc01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pjc01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                       #No.FUN-9B0098 10/02/24
       DELETE FROM pjc_file WHERE pjc01 = g_pjc01
       IF STATUS THEN
          CALL cl_err3("del","pjc_file",g_pjc01,"",STATUS,"","",1)
          LET g_success='N'
       END IF
 
       IF g_success = 'Y'  THEN
          CALL cl_cmmsg(4)
          COMMIT WORK
          CLEAR FORM
          DROP TABLE x
          PREPARE t111_precount_x2 FROM g_sql_tmp
          EXECUTE t111_precount_x2
          CALL g_pjc.clear()
          OPEN t111_count
          #FUN-B50063-add-start--
          IF STATUS THEN
             CLOSE t111_cs
             CLOSE t111_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50063-add-end-- 
          FETCH t111_count INTO g_row_count
          #FUN-B50063-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t111_cs
             CLOSE t111_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50063-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN t111_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL t111_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL t111_fetch('/')
          END IF
       ELSE
          CALL cl_rbmsg(4)
          ROLLBACK WORK
       END IF
    END IF
 
    CLOSE t111_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t111_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_n    LIKE type_file.num5
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjc TO s_pjc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t111_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t111_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t111_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION next
         CALL t111_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION last
         CALL t111_fetch('L')
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
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t111_out()
DEFINE      l_sw          LIKE type_file.chr1,
            l_i           LIKE type_file.num5,
            l_name        LIKE type_file.chr20,
            sr            RECORD
            pjb01         LIKE pjb_file.pjb01,
            pja02         LIKE pja_file.pja02,
            pjc01         LIKE pjc_file.pjc01,
            pjb03         LIKE pjb_file.pjb03,
            pjc02         LIKE pjc_file.pjc02,
            pjc03         LIKE pjc_file.pjc03
                          END RECORD
   IF cl_null(g_wc) THEN 
       LET g_wc =" pjc01='",g_pjc01,"'"  
   END IF     
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT pjb01,pja02,pjc01,pjb03,pjc02,pjc03",
             " FROM pjc_file,pjb_file,pja_file",
             " WHERE pjb_file.pjb02 = pjc01 AND pjb_file.pjb01 = pja_file.pja01",
             " AND ",g_wc CLIPPED
   LET g_sql = g_sql CLIPPED," ORDER BY pjc01,pjc02"
   CALL cl_prt_cs1('apjt111','apjt111',g_sql,'')
{   PREPARE t111_pl FROM g_sql
   DECLARE t111_curo CURSOR FOR t111_pl
   CALL cl_outnam('apjt111') RETURNING l_name
   START REPORT t111_rep TO l_name
   FOREACH t111_curo INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       OUTPUT TO REPORT t111_rep(sr.*)
   END FOREACH
 
   FINISH REPORT t111_rep
   CLOSE t111_curo
   ERROR ""
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)}
END FUNCTION
 
{REPORT t111_rep(sr)
    DEFINE
         l_sw          LIKE type_file.chr1,
         sr            RECORD
         pjb01         LIKE pjb_file.pjb01,
         pja02         LIKE pja_file.pja02,
         pjc01         LIKE pjc_file.pjc01,
         pjb03         LIKE pjb_file.pjb03,
         pjc02         LIKE pjc_file.pjc02,
         pjc03         LIKE pjc_file.pjc03
                       END RECORD
    OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.pjc01,sr.pjc02
 
    FORMAT
      PAGE HEADER
         PRINT COLUMN((g_len - FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN((g_len - FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO Using '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT g_dash[1,g_len]
         PRINT COLUMN 10,g_x[31] CLIPPED,
               COLUMN 20,g_c[31],sr.pjb01,
               COLUMN 51,g_x[32] CLIPPED,
               COLUMN 61,g_c[32],sr.pja02
               SKIP 1 LINE
         PRINT COLUMN 10,g_x[33] CLIPPED,
               COLUMN 20,g_c[33],sr.pjc01,
               COLUMN 51,g_x[34] CLIPPED,
               COLUMN 61,g_c[34],sr.pjb03
         PRINT g_dash[1,g_len]
         PRINT g_x[35] CLIPPED,
               g_x[36] CLIPPED
               
         PRINT g_dash1
         LET l_sw = 'y'
      
      BEFORE GROUP OF sr.pjc01
         SKIP TO TOP OF PAGE
      
      ON EVERY ROW
         PRINT COLUMN g_c[35],sr.pjc02,
               COLUMN g_c[36],sr.pjc03
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,COLUMN(g_len-9),
               g_x[7] CLIPPED
         LET   l_sw='n'
         
      PAGE TRAILER
         IF l_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],
                  g_x[5] CLIPPED,COLUMN (g_len - 9),
                  g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 END REPORT
}
 
FUNCTION t111_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' THEN
     CALL cl_set_comp_entry("pjc01",TRUE)
  END IF
END FUNCTION
 
FUNCTION t111_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'u'THEN
     CALL cl_set_comp_entry("pjc01",FALSE)
  END IF
END FUNCTION
# Modify.........: No.FUN-790025 
