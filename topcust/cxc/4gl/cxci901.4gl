# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cxci901.4gl
# Descriptions...: 每月料件替代维护作业
# Date & Author..: 91/06/21 By Lee
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm              RECORD 
         ta_ccu01      LIKE type_file.num5,
         ta_ccu02      LIKE type_file.num5
               END RECORD,
    g_ta_ccu           DYNAMIC ARRAY OF RECORD 
        ta_ccu03       LIKE ta_ccu_file.ta_ccu03,
        ima02          LIKE ima_file.ima02,
        ima021         LIKE ima_file.ima021,
        ta_ccu04       LIKE ta_ccu_file.ta_ccu04,
        ima02_1        LIKE ima_file.ima02,
        ima021_1       LIKE ima_file.ima021
                    END RECORD,
    g_ta_ccu_t         RECORD
        ta_ccu03       LIKE ta_ccu_file.ta_ccu03,
        ima02          LIKE ima_file.ima02,
        ima021         LIKE ima_file.ima021,
        ta_ccu04       LIKE ta_ccu_file.ta_ccu04,
        ima02_1        LIKE ima_file.ima02,
        ima021_1       LIKE ima_file.ima021
                    END RECORD,
    g_wc               STRING,
    g_wc2,g_sql        STRING,  #No.FUN-580092 HCN
    g_rec_b            LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac               LIKE type_file.num5      #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
DEFINE g_i             LIKE type_file.num5
DEFINE g_argv1         LIKE type_file.num5
DEFINE g_argv2         LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_buf               LIKE gem_file.gem02
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   LET g_argv1=ARG_VAL(1)  #年度
   LET g_argv2=ARG_VAL(2)  #期别
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_forupd_sql = "SELECT ta_ccu01,ta_ccu02 FROM ta_ccu_file WHERE ta_ccu01 = ? AND ta_ccu02 = ? AND rownum = 1 FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i901_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i901_w WITH FORM "cxc/42f/cxci901"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("cxci901")
   CALL cl_ui_init()
 
   CALL i901_menu()
 
   CLOSE WINDOW i901_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION i901_cs()
DEFINE lc_qbe_sn           LIKE gbm_file.gbm01

   CLEAR FORM
   CALL g_ta_ccu.clear()

   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " ta_ccu01 = '",g_argv1,"' AND ta_ccu02 = '",g_argv2,"'"
      LET g_wc2 = " 1=1"
   ELSE
      WHILE TRUE
         CALL cl_set_head_visible("","YES")
         INITIALIZE tm.* TO NULL
         DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON ta_ccu01,ta_ccu02
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
         END CONSTRUCT

         CONSTRUCT g_wc2 ON ta_ccu03,ta_ccu04
              FROM s_ta_ccu[1].ta_ccu03,s_ta_ccu[1].ta_ccu04
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT

         ON ACTION controlp
            CASE
               WHEN INFIELD(ta_ccu03)   #料件
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ta_ccu03
                  NEXT FIELD ta_ccu03
               WHEN INFIELD(ta_ccu04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ta_ccu04
                  NEXT FIELD ta_ccu04
               OTHERWISE
                  EXIT CASE
            END CASE

         ON ACTION accept
            EXIT DIALOG

         ON ACTION exit
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION controlg
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION help
            CALL cl_show_help()

         ON ACTION about
            CALL cl_about()

         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION qbe_save
            CALL cl_qbe_save()

         END DIALOG
         IF INT_FLAG THEN RETURN END IF
         EXIT WHILE
      END WHILE
   END IF

   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT UNIQUE ta_ccu01,ta_ccu02 ",
                  "  FROM ta_ccu_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY ta_ccu01,ta_ccu02 "
   ELSE
      LET g_sql = "SELECT UNIQUE ta_ccu01,ta_ccu02 ",
                  "  FROM ta_ccu_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED,
                  " ORDER BY ta_ccu01,ta_ccu02 "
   END IF
   PREPARE i901_prepare FROM g_sql
   DECLARE i901_cs SCROLL CURSOR WITH HOLD FOR i901_prepare

   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(UNIQUE ta_ccu01||ta_ccu02) ",
                "  FROM ta_ccu_file ",
                " WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(UNIQUE ta_ccu01||ta_ccu02) ",
                "  FROM ta_ccu_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE i901_precount FROM g_sql
   DECLARE i901_count CURSOR FOR i901_precount
END FUNCTION
 
FUNCTION i901_menu()
 
   WHILE TRUE
      CALL i901_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i901_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i901_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i901_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i901_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i901_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output" 
#            IF cl_chk_act_auth() THEN
#               CALL i901_out()
#            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#         WHEN "related_document"  #No.MOD-470515
#            IF cl_chk_act_auth() THEN
#               IF g_ta_ccu02 IS NOT NULL THEN
#                  LET g_doc.column1 = "ta_ccu02"
#                  LET g_doc.value1 = g_ta_ccu02
#                  CALL cl_doc()
#               END IF
#            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ta_ccu),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION

FUNCTION i901_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ta_ccu TO s_ta_ccu.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION first
         CALL i901_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL i901_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL i901_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL i901_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL i901_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i901_a()

   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_ta_ccu.clear()

   INITIALIZE tm.* TO NULL
   CALL cl_opmsg('a')

   WHILE TRUE
      LET tm.ta_ccu01 = g_ccz.ccz01
      LET tm.ta_ccu02 = g_ccz.ccz02
      CALL i901_i("a")
      IF INT_FLAG THEN
         INITIALIZE tm.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_ta_ccu.clear()
      LET g_rec_b = 0
      CALL i901_b()
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i901_i(p_cmd)
DEFINE p_cmd               LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF

   DISPLAY BY NAME tm.ta_ccu01,tm.ta_ccu02

   CALL cl_set_head_visible("","YES")
   INPUT BY NAME tm.ta_ccu01,tm.ta_ccu02 WITHOUT DEFAULTS 
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT INPUT
         END IF 
         IF cl_null(tm.ta_ccu01) THEN
            NEXT FIELD ta_ccu01 
         END IF  
         IF cl_null(tm.ta_ccu02) THEN
            NEXT FIELD ta_ccu02 
         END IF 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
      
      ON ACTION HELP
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()
      
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT
           
   END INPUT
END FUNCTION
 
FUNCTION i901_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ta_ccu.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL i901_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      RETURN
   END IF

   OPEN i901_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE tm.* TO NULL
   ELSE
      OPEN i901_count
      FETCH i901_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i901_fetch('F')
   END IF
 
END FUNCTION

FUNCTION i901_fetch(p_flag)
DEFINE p_flag              LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     i901_cs INTO tm.ta_ccu01,tm.ta_ccu02
      WHEN 'P' FETCH PREVIOUS i901_cs INTO tm.ta_ccu01,tm.ta_ccu02
      WHEN 'F' FETCH FIRST    i901_cs INTO tm.ta_ccu01,tm.ta_ccu02
      WHEN 'L' FETCH LAST     i901_cs INTO tm.ta_ccu01,tm.ta_ccu02
      WHEN '/'
           IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0
              PROMPT g_msg CLIPPED,': ' FOR g_jump

                 ON ACTION controlg
                    CALL cl_cmdask()

                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()

                 ON ACTION help
                    CALL cl_show_help()

                 ON ACTION about
                    CALL cl_about()

              END PROMPT
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump i901_cs INTO tm.ta_ccu01,tm.ta_ccu02
           LET g_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(tm.ta_ccu01,SQLCA.sqlcode,0)
      INITIALIZE tm.* TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF

   CALL i901_show()
END FUNCTION

FUNCTION i901_show()
DEFINE l_gen02             LIKE gen_file.gen02

   DISPLAY BY NAME tm.ta_ccu01,tm.ta_ccu02

   CALL i901_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i901_b()
   DEFINE l_ac_t          LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = " "
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(tm.ta_ccu01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
   LET g_forupd_sql = " SELECT ta_ccu03,'','',ta_ccu04,'','' FROM ta_ccu_file ",
                      "  WHERE ta_ccu01= ? AND ta_ccu02= ? AND ta_ccu03= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i901_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_ta_ccu WITHOUT DEFAULTS FROM s_ta_ccu.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT

         BEGIN WORK
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt
           FROM ta_ccu_file
          WHERE ta_ccu01 = tm.ta_ccu01
            AND ta_ccu02 = tm.ta_ccu02
         IF g_cnt > 0 THEN
            OPEN i901_cl USING tm.ta_ccu01,tm.ta_ccu02
            IF STATUS THEN
               CALL cl_err("OPEN i901_cl:",STATUS,1)
               CLOSE i901_cl
               ROLLBACK WORK
               RETURN
            END IF

            FETCH i901_cl INTO tm.ta_ccu01,tm.ta_ccu02
            IF SQLCA.sqlcode THEN
               CALL cl_err(tm.ta_ccu01,SQLCA.sqlcode,0)
               CLOSE i901_cl
               ROLLBACK WORK
               RETURN
            END IF
         END IF
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ta_ccu_t.* = g_ta_ccu[l_ac].*  #BACKUP
            OPEN i901_bcl USING tm.ta_ccu01,tm.ta_ccu02,g_ta_ccu_t.ta_ccu03
            IF STATUS THEN
               CALL cl_err("OPEN i901_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i901_bcl INTO g_ta_ccu[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ta_ccu_t.ta_ccu03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i901_ta_ccu03('d')
                  CALL i901_ta_ccu04('d')
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ta_ccu[l_ac].* TO NULL
         LET g_ta_ccu_t.* = g_ta_ccu[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD ta_ccu03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO ta_ccu_file(ta_ccu01,ta_ccu02,ta_ccu03,ta_ccu04)
                       VALUES(tm.ta_ccu01,tm.ta_ccu02,g_ta_ccu[l_ac].ta_ccu03,
                              g_ta_ccu[l_ac].ta_ccu04)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ta_ccu_file",g_ta_ccu[l_ac].ta_ccu03,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD ta_ccu03                        #check 編號是否重複
         IF NOT cl_null(g_ta_ccu[l_ac].ta_ccu03) THEN
            IF g_ta_ccu[l_ac].ta_ccu03 != g_ta_ccu_t.ta_ccu03 
               OR g_ta_ccu_t.ta_ccu03 IS NULL THEN
               SELECT count(*) INTO l_n FROM ta_ccu_file
                WHERE ta_ccu01 = tm.ta_ccu01
                  AND ta_ccu02 = tm.ta_ccu02
                  AND ta_ccu03 = g_ta_ccu[l_ac].ta_ccu03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD ta_ccu03
               END IF
               CALL i901_ta_ccu03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ta_ccu[l_ac].ta_ccu03,g_errno,0)
                  NEXT FIELD ta_ccu03
               END IF
               
               LET l_n = 0
               SELECT count(*) INTO l_n FROM ta_ccu_file
                WHERE ta_ccu01 = tm.ta_ccu01
                  AND ta_ccu02 = tm.ta_ccu02
                  AND ta_ccu04 = g_ta_ccu[l_ac].ta_ccu03
               IF l_n > 0 THEN
                  CALL cl_err(g_ta_ccu[l_ac].ta_ccu03,'cxc-010',0)
                  NEXT FIELD ta_ccu03
               END IF
            END IF
         END IF
 
      AFTER FIELD ta_ccu04                        #check 編號是否重複
         IF NOT cl_null(g_ta_ccu[l_ac].ta_ccu04) THEN
            IF g_ta_ccu[l_ac].ta_ccu04 != g_ta_ccu_t.ta_ccu04 
               OR g_ta_ccu_t.ta_ccu04 IS NULL THEN
               CALL i901_ta_ccu04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ta_ccu[l_ac].ta_ccu04,g_errno,0)
                  NEXT FIELD ta_ccu04
               END IF
               IF g_ta_ccu[l_ac].ta_ccu04 = g_ta_ccu[l_ac].ta_ccu03 THEN
                  CALL cl_err(g_ta_ccu[l_ac].ta_ccu04,'mfg2626',0)
                  NEXT FIELD ta_ccu04
               END IF

               LET l_n = 0
               SELECT count(*) INTO l_n FROM ta_ccu_file
                WHERE ta_ccu01 = tm.ta_ccu01
                  AND ta_ccu02 = tm.ta_ccu02
                  AND ta_ccu03 = g_ta_ccu[l_ac].ta_ccu04
               IF l_n > 0 THEN
                  CALL cl_err(g_ta_ccu[l_ac].ta_ccu04,'cxc-010',0)
                  NEXT FIELD ta_ccu04
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_ta_ccu_t.ta_ccu03 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM ta_ccu_file WHERE ta_ccu01 = tm.ta_ccu01
                                      AND ta_ccu02 = tm.ta_ccu02
                                      AND ta_ccu03 = g_ta_ccu_t.ta_ccu03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ta_ccu_file",g_ta_ccu_t.ta_ccu03,"",SQLCA.sqlcode,"","",1) 
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
            LET g_ta_ccu[l_ac].* = g_ta_ccu_t.*
            CLOSE i901_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ta_ccu[l_ac].ta_ccu03,-263,1)
            LET g_ta_ccu[l_ac].* = g_ta_ccu_t.*
         ELSE
            UPDATE ta_ccu_file 
               SET ta_ccu03=g_ta_ccu[l_ac].ta_ccu03,
                   ta_ccu04=g_ta_ccu[l_ac].ta_ccu04
             WHERE ta_ccu01 = tm.ta_ccu01
               AND ta_ccu02 = tm.ta_ccu02
               AND ta_ccu03 = g_ta_ccu_t.ta_ccu03 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ta_ccu_file",'',g_ta_ccu_t.ta_ccu03,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_ta_ccu[l_ac].* = g_ta_ccu_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ta_ccu[l_ac].* = g_ta_ccu_t.*
            END IF
            CLOSE i901_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D40030 Add
         CLOSE i901_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ta_ccu03) #料件編號
               CALL q_sel_ima(FALSE,"q_ima","",g_ta_ccu[l_ac].ta_ccu03,"","","","","",'')
                  RETURNING g_ta_ccu[l_ac].ta_ccu03
               DISPLAY BY NAME g_ta_ccu[l_ac].ta_ccu03
               CALL i901_ta_ccu03('d')
               NEXT FIELD ta_ccu03
            WHEN INFIELD(ta_ccu04) #料件編號
               CALL q_sel_ima(FALSE,"q_ima","",g_ta_ccu[l_ac].ta_ccu04,"","","","","",'')
                  RETURNING g_ta_ccu[l_ac].ta_ccu04
               DISPLAY BY NAME g_ta_ccu[l_ac].ta_ccu04
               CALL i901_ta_ccu04('d')
               NEXT FIELD ta_ccu04
             OTHERWISE
         END CASE
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END INPUT
 
   CLOSE i901_bcl
 
   COMMIT WORK
 
END FUNCTION

FUNCTION i901_r()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(tm.ta_ccu01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   BEGIN WORK

   OPEN i901_cl USING tm.ta_ccu01,tm.ta_ccu02
   IF STATUS THEN
      CALL cl_err("OPEN i901_cl:",STATUS,1)
      CLOSE i901_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i901_cl INTO tm.ta_ccu01,tm.ta_ccu02
   IF SQLCA.sqlcode THEN
      CALL cl_err(tm.ta_ccu01,SQLCA.sqlcode,0)
      CLOSE i901_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i901_show()

   IF cl_delh(0,0) THEN
      DELETE FROM ta_ccu_file WHERE ta_ccu01 = tm.ta_ccu01 AND ta_ccu02 = tm.ta_ccu02
      CLEAR FORM
      CALL g_ta_ccu.clear()
      OPEN i901_count
      FETCH i901_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i901_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i901_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i901_fetch('/')
      END IF
   END IF

   CLOSE i901_cl
   COMMIT WORK
END FUNCTION

FUNCTION i901_copy()
DEFINE t_ccu01     LIKE ta_ccu_file.ta_ccu01
DEFINE t_ccu02     LIKE ta_ccu_file.ta_ccu02

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(tm.ta_ccu01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET t_ccu01 = tm.ta_ccu01  #备份旧值
   LET t_ccu02 = tm.ta_ccu02  #备份旧值

   WHILE TRUE
      CALL i901_i("a")
      IF INT_FLAG THEN
         INITIALIZE tm.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET tm.ta_ccu01 = t_ccu01
         LET tm.ta_ccu02 = t_ccu02
         DISPLAY BY NAME tm.ta_ccu01,tm.ta_ccu02
         RETURN
      END IF
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt
        FROM ta_ccu_file
       WHERE ta_ccu01 = tm.ta_ccu01
         AND ta_ccu02 = tm.ta_ccu02
      IF g_cnt > 0 THEN
         CALL cl_err('',-239,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   DROP TABLE x
   SELECT * FROM ta_ccu_file WHERE ta_ccu01 = t_ccu01 AND ta_ccu02 = t_ccu02 INTO TEMP x

   LET g_success = 'Y'
   BEGIN WORK

   UPDATE x
      SET ta_ccu01   = tm.ta_ccu01,
          ta_ccu02   = tm.ta_ccu02

   INSERT INTO ta_ccu_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ta_ccu_file","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_msg("Copy Ok!")
   ELSE
      ROLLBACK WORK
   END IF
   DROP TABLE x

   IF g_success = 'N' THEN
      LET tm.ta_ccu01 = t_ccu01
      LET tm.ta_ccu02 = t_ccu02
      DISPLAY BY NAME tm.ta_ccu01,tm.ta_ccu02
   END IF
   LET g_wc2 = ' 1=1'
   CALL i901_show()
END FUNCTION
 
FUNCTION i901_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
   LET g_sql = "SELECT ta_ccu03,a.ima02,a.ima021,ta_ccu04,b.ima02,b.ima021 ",
               "  FROM ta_ccu_file,ima_file a,ima_file b ",
               " WHERE ta_ccu03 = a.ima01(+) ",
               "   AND ta_ccu04 = b.ima01(+) ",
               "   AND ta_ccu01 = ",tm.ta_ccu01,
               "   AND ta_ccu02 = ",tm.ta_ccu02,
               "   AND ", p_wc2 CLIPPED,                     #單身
               " ORDER BY ta_ccu03 "
   PREPARE i901_pb FROM g_sql
   DECLARE ta_ccu_curs CURSOR FOR i901_pb
 
   CALL g_ta_ccu.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH ta_ccu_curs INTO g_ta_ccu[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      
   END FOREACH
 
   CALL g_ta_ccu.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i901_ta_ccu03(p_cmd)  #料件
DEFINE p_cmd               LIKE type_file.chr1,
       l_ima02             LIKE ima_file.ima02,
       l_ima021            LIKE ima_file.ima021,
       l_ima25             LIKE ima_file.ima25,
       l_imaacti           LIKE ima_file.imaacti

   LET g_errno = ' '
   SELECT ima02,ima021,ima25,imaacti
     INTO l_ima02,l_ima021,l_ima25,l_imaacti
     FROM ima_file
    WHERE ima01 = g_ta_ccu[l_ac].ta_ccu03

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg0002'
         LET l_ima02 = NULL
         LET l_ima021= NULL
      WHEN l_imaacti='N'
         LET g_errno = '9028'
      WHEN l_imaacti MATCHES '[PH]'
         LET g_errno = '9038'
      OTHERWISE
        LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_ta_ccu[l_ac].ima02 = l_ima02
      LET g_ta_ccu[l_ac].ima021= l_ima021
   END IF
   DISPLAY BY NAME g_ta_ccu[l_ac].ima02,g_ta_ccu[l_ac].ima021
END FUNCTION
 
FUNCTION i901_ta_ccu04(p_cmd)  #料件
DEFINE p_cmd               LIKE type_file.chr1,
       l_ima02             LIKE ima_file.ima02,
       l_ima021            LIKE ima_file.ima021,
       l_ima25             LIKE ima_file.ima25,
       l_imaacti           LIKE ima_file.imaacti

   LET g_errno = ' '
   SELECT ima02,ima021,ima25,imaacti
     INTO l_ima02,l_ima021,l_ima25,l_imaacti
     FROM ima_file
    WHERE ima01 = g_ta_ccu[l_ac].ta_ccu04

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg0002'
         LET l_ima02 = NULL
         LET l_ima021= NULL
      WHEN l_imaacti='N'
         LET g_errno = '9028'
      WHEN l_imaacti MATCHES '[PH]'
         LET g_errno = '9038'
      OTHERWISE
        LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_ta_ccu[l_ac].ima02_1 = l_ima02
      LET g_ta_ccu[l_ac].ima021_1= l_ima021
   END IF
   DISPLAY BY NAME g_ta_ccu[l_ac].ima02_1,g_ta_ccu[l_ac].ima021_1
END FUNCTION
 
FUNCTION i901_g()


END FUNCTION
