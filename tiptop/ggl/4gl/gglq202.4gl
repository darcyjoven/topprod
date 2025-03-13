# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: gglq202.4gl
# Descriptions...:
# Date & Author..: 08/11/18 by chenl
# Modify.........: No.FUN-8C0022 08/12/23 By chenl 新增程序。
# Modify.........: No.MOD-920055 09/02/04 By chenl 調整字段大小。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/21 By yinhy 科目查询自动过滤
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD                 #No.FUN-8C0022
          b       LIKE aaa_file.aaa01,
          aag08   LIKE aag_file.aag08,
          yy      LIKE type_file.num5,
          bm      LIKE type_file.num5,
          em      LIKE type_file.num5,
          h       LIKE type_file.chr1,
          e       LIKE type_file.chr1,
          more    LIKE type_file.chr1
                  END RECORD
DEFINE  g_q202    DYNAMIC ARRAY OF RECORD
        aba04     LIKE aba_file.aba04,     #期間
        aba02_mm  LIKE type_file.chr2,     #月份
        aba02_dd  LIKE type_file.chr2,     #日期
          aba01   LIKE aba_file.aba01,     #憑証編號
          abb02   LIKE abb_file.abb02,     #項次 
          abb04   LIKE abb_file.abb04,     #摘要
          c001     LIKE abb_file.abb07,    #借方-存放50個欄位
          c002     LIKE abb_file.abb07,
          c003     LIKE abb_file.abb07,
          c004     LIKE abb_file.abb07,
          c005     LIKE abb_file.abb07,
          c006     LIKE abb_file.abb07,
          c007     LIKE abb_file.abb07,
          c008     LIKE abb_file.abb07,
          c009     LIKE abb_file.abb07,
          c010     LIKE abb_file.abb07,
          c011     LIKE abb_file.abb07,
          c012     LIKE abb_file.abb07,
          c013     LIKE abb_file.abb07,
          c014     LIKE abb_file.abb07,
          c015     LIKE abb_file.abb07,
          c016     LIKE abb_file.abb07,
          c017     LIKE abb_file.abb07,
          c018     LIKE abb_file.abb07,
          c019     LIKE abb_file.abb07,
          c020     LIKE abb_file.abb07,
          c021     LIKE abb_file.abb07,
          c022     LIKE abb_file.abb07,
          c023     LIKE abb_file.abb07,
          c024     LIKE abb_file.abb07,
          c025     LIKE abb_file.abb07,
          c026     LIKE abb_file.abb07,
          c027     LIKE abb_file.abb07,
          c028     LIKE abb_file.abb07,
          c029     LIKE abb_file.abb07,
          c030     LIKE abb_file.abb07,
          c031     LIKE abb_file.abb07,
          c032     LIKE abb_file.abb07,
          c033     LIKE abb_file.abb07,
          c034     LIKE abb_file.abb07,
          c035     LIKE abb_file.abb07,
          c036     LIKE abb_file.abb07,
          c037     LIKE abb_file.abb07,
          c038     LIKE abb_file.abb07,
          c039     LIKE abb_file.abb07,
          c040     LIKE abb_file.abb07,
          c041     LIKE abb_file.abb07,
          c042     LIKE abb_file.abb07,
          c043     LIKE abb_file.abb07,
          c044     LIKE abb_file.abb07,
          c045     LIKE abb_file.abb07,
          c046     LIKE abb_file.abb07,
          c047     LIKE abb_file.abb07,
          c048     LIKE abb_file.abb07,
          c049     LIKE abb_file.abb07,
          c050     LIKE abb_file.abb07,
          c051     LIKE abb_file.abb07,    #貸方-存放50個欄位
          c052     LIKE abb_file.abb07,
          c053     LIKE abb_file.abb07,
          c054     LIKE abb_file.abb07,
          c055     LIKE abb_file.abb07,
          c056     LIKE abb_file.abb07,
          c057     LIKE abb_file.abb07,
          c058     LIKE abb_file.abb07,
          c059     LIKE abb_file.abb07,
          c060     LIKE abb_file.abb07,
          c061     LIKE abb_file.abb07,
          c062     LIKE abb_file.abb07,
          c063     LIKE abb_file.abb07,
          c064     LIKE abb_file.abb07,
          c065     LIKE abb_file.abb07,
          c066     LIKE abb_file.abb07,
          c067     LIKE abb_file.abb07,
          c068     LIKE abb_file.abb07,
          c069     LIKE abb_file.abb07,
          c070     LIKE abb_file.abb07,
          c071     LIKE abb_file.abb07,
          c072     LIKE abb_file.abb07,
          c073     LIKE abb_file.abb07,
          c074     LIKE abb_file.abb07,
          c075     LIKE abb_file.abb07,
          c076     LIKE abb_file.abb07,
          c077     LIKE abb_file.abb07,
          c078     LIKE abb_file.abb07,
          c079     LIKE abb_file.abb07,
          c080     LIKE abb_file.abb07,
          c081     LIKE abb_file.abb07,
          c082     LIKE abb_file.abb07,
          c083     LIKE abb_file.abb07,
          c084     LIKE abb_file.abb07,
          c085     LIKE abb_file.abb07,
          c086     LIKE abb_file.abb07,
          c087     LIKE abb_file.abb07,
          c088     LIKE abb_file.abb07,
          c089     LIKE abb_file.abb07,
          c090     LIKE abb_file.abb07,
          c091     LIKE abb_file.abb07,
          c092     LIKE abb_file.abb07,
          c093     LIKE abb_file.abb07,
          c094     LIKE abb_file.abb07,
          c095     LIKE abb_file.abb07,
          c096     LIKE abb_file.abb07,
          c097     LIKE abb_file.abb07,
          c098     LIKE abb_file.abb07,
          c099     LIKE abb_file.abb07,
          c100     LIKE abb_file.abb07,
          abb06   LIKE type_file.chr4,     #借貸別 #No.MOD-920055
          balance LIKE abb_file.abb07      #余額
                  END RECORD
DEFINE  g_abb     RECORD
          aba00   LIKE aba_file.aba00,
          aba01   LIKE aba_file.aba01,
          aba02   LIKE aba_file.aba02,
          aba04   LIKE aba_file.aba04,
          abb02   LIKE abb_file.abb02,
          abb03   LIKE abb_file.abb03,
          abb04   LIKE abb_file.abb04,
          abb06   LIKE abb_file.abb06,
          abb07   LIKE abb_file.abb07,
          aag02   LIKE aag_file.aag02,
          aag06   LIKE aag_file.aag06,
          bal     LIKE abb_file.abb07,
          colno   LIKE type_file.num5,
          begno   LIKE type_file.chr1
                  END RECORD
DEFINE  g_aag     RECORD
          aag00   LIKE aag_file.aag00,
          aag01   LIKE aag_file.aag01,
          aag02   LIKE aag_file.aag02,
          aag06   LIKE aag_file.aag06,
          aag07   LIKE aag_file.aag07,
          aag08   LIKE aag_file.aag08,
          aag09   LIKE aag_file.aag09,
          aag13   LIKE aag_file.aag13,
          colno   LIKE type_file.num5
                  END RECORD
DEFINE  g_aah     RECORD LIKE aah_file.*
DEFINE  g_cnt     LIKE type_file.num10
DEFINE  g_sql     STRING
DEFINE  g_str     STRING
DEFINE  l_table   STRING
DEFINE  g_rec_b   LIKE type_file.num10
DEFINE  l_ac      LIKE type_file.num5
DEFINE  g_colnum  LIKE type_file.num5
DEFINE  g_unit    LIKE type_file.num5
DEFINE  g_bookno  LIKE aah_file.aah00
DEFINE  g_bal     LIKE abb_file.abb07
DEFINE  g_mm      LIKE type_file.num5
DEFINE  g_curs_index LIKE type_file.num10
DEFINE  g_row_count  LIKE type_file.num10
DEFINE  g_jump             LIKE type_file.num10
DEFINE  mi_no_ask          LIKE type_file.num5
DEFINE  g_msg              LIKE type_file.chr1000
DEFINE  g_prtcol  LIKE type_file.num5  
 
GLOBALS "../../config/top.global"
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   LET tm.aag08 = ARG_VAL(9)
   LET tm.yy    = ARG_VAL(10)
   LET tm.bm    = ARG_VAL(11)
   LET tm.em    = ARG_VAL(12)
   LET tm.h     = ARG_VAL(13)
   LET tm.e     = ARG_VAL(14)
   LET g_unit   = ARG_VAL(15)
 
   IF cl_null(tm.h) THEN LET tm.h = 'Y' END IF
   IF cl_null(tm.e) THEN LET tm.e = 'N' END IF
   IF cl_null(g_unit) THEN LET g_unit = 1 END IF
 
   LET g_colnum = 100
   LET g_prtcol = 16
 
   CALL q202_out_prep()
   IF g_success = 'N' THEN EXIT PROGRAM END IF
   CALL q202_tmp_table('c')
   IF g_success = 'N' THEN EXIT PROGRAM END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW q202_w AT 0,0 WITH FORM "ggl/42f/gglq202"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      CALL q202_tm()
   ELSE
      CALL gglq202()
      #CALL q202_b_fill()
      
   END IF
 
   CALL q202_menu()
   CALL q202_tmp_table('d')
   CLOSE WINDOW q202_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q202_cs()
   LET g_sql = " SELECT DISTINCT aba04 FROM gglq202_abb ORDER BY aba04"
   PREPARE q202_ps FROM g_sql
   DECLARE q202_curs SCROLL CURSOR WITH HOLD FOR q202_ps
   
   OPEN q202_curs
   IF SQLCA.sqlcode THEN
      CALL cl_err('OPEN q202_curs',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   ELSE
      CALL q202_fetch('F')
   END IF
 
END FUNCTION 
 
FUNCTION q202_menu()
   WHILE TRUE
      CALL q202_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q202_tm()
            END IF
         WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL q202_out()
           END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_q202),'','')
            END IF
         WHEN "show_voucher"
            CALL q202_show_voucher()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q202_tm()
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE li_chk_bookno  LIKE type_file.num5
DEFINE l_cmd          LIKE type_file.chr1000
 
   LET p_row = 0
   LET p_col = 0
   OPEN WINDOW r202_w AT p_row,p_col WITH FORM "ggl/42f/gglr202"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
 
   CALL cl_ui_locale("gglr202")
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL
   LET tm.b    = g_aza.aza81
   LET tm.e    = 'N'
   LET tm.h    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      DISPLAY BY NAME tm.b
      DISPLAY BY NAME tm.more
      INPUT BY NAME tm.b,tm.aag08,tm.yy,tm.bm,tm.em,tm.h,tm.e,tm.more
            WITHOUT DEFAULTS
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT
 
         AFTER FIELD b
            IF NOT cl_null(tm.b) THEN
               CALL s_check_bookno(tm.b,g_user,g_plant)
                    RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD b
               END IF
               #No.FUN-B10053  --Begin  
               IF NOT cl_null(tm.aag08) THEN
                  LET g_cnt=0
                  SELECT COUNT(*) INTO g_cnt FROM aag_file
                   WHERE aag01= tm.aag08
                     AND aag00= tm.b
                     AND aag07= "1"
                  IF g_cnt=0 THEN
                     NEXT FIELD aag08
                  ELSE
                     CALL cl_err('','mfg5103',0)
                     NEXT FIELD aag08
                  END IF
               END IF
               #No.FUN-B10053  --End
               SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
               IF STATUS THEN
                  CALL cl_err3("sel","aaa.file",tm.b,"",STATUS,"","sel aaa:",0)
                  NEXT FIELD b
               END IF
            END IF
 
         AFTER FIELD aag08
            IF NOT cl_null(tm.aag08) THEN
               LET g_cnt=0
               SELECT COUNT(*) INTO g_cnt FROM aag_file
                WHERE aag01= tm.aag08
                  AND aag00= tm.b
                  AND aag07= "1"
               #No.FUN-B10053  --Begin
               IF g_cnt=0 THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag2"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = tm.aag08
                  LET g_qryparam.arg1 = tm.b
                  LET g_qryparam.where = " aag01 LIKE '",tm.aag08 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING tm.aag08
                  DISPLAY BY NAME tm.aag08
                  #No.FUN-B10053  --End
                  NEXT FIELD aag08
               END IF
            ELSE
               CALL cl_err('','mfg5103',0)
               NEXT FIELD aag08
            END IF
 
         AFTER FIELD yy
            IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
         AFTER FIELD bm
            IF NOT cl_null(tm.bm) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.bm > 12 OR tm.bm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD bm
                  END IF
               ELSE
                  IF tm.bm > 13 OR tm.bm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD bm
                  END IF
               END IF
            END IF
            IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
 
 
         AFTER FIELD em
            IF NOT cl_null(tm.em) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.em > 12 OR tm.em < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em
                  END IF
               ELSE
                  IF tm.em > 13 OR tm.em < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em
                  END IF
               END IF
            END IF
            IF cl_null(tm.em) THEN NEXT FIELD em END IF
            IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT 
            IF cl_null(tm.yy) THEN NEXT FIELD yy END IF 
            IF cl_null(tm.bm) THEN NEXT FIELD bm END IF 
            IF cl_null(tm.em) THEN NEXT FIELD em END IF 
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(aag08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aag2'
                  LET g_qryparam.arg1 = tm.b
                  LET g_qryparam.default1 = tm.aag08
                  CALL cl_create_qry() RETURNING tm.aag08
                  DISPLAY BY NAME tm.aag08
                  NEXT FIELD aag08
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY BY NAME tm.b
                  NEXT FIELD b
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         EXIT WHILE
      END IF
 
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='gglq202'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('gglq202','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.aag08 CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bm CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",g_unit CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('gglq202',g_time,l_cmd)
         END IF
         CLOSE WINDOW r202_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      ERROR ""
      EXIT WHILE
   END WHILE
   CLOSE WINDOW r202_w
   IF INT_FLAG THEN
      #LET INT_FLAG = 0 RETURN                      #FUN-B10053
      LET INT_FLAG = 0 CLOSE WINDOW r202_w RETURN   #FUN-B10053
   END IF
   CALL cl_wait()
   CALL gglq202()
 
   CLEAR FORM
   CALL q202_cs()
 
END FUNCTION
 
 
FUNCTION q202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_q202 TO s_q202.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
        #CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL q202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL q202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL q202_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION show_voucher
         LET g_action_choice = 'show_voucher'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION gglq202()
DEFINE   l_n       LIKE type_file.num10
 
    LET g_bal = 0
    CALL q202_del_tmp()
    CALL q202_get_aag(tm.aag08)
    SELECT COUNT(*) INTO l_n FROM gglq202_aag
    IF l_n = 0 THEN
       CALL cl_err('sel aag:','aap-129',1)
       RETURN
    END IF
    CALL q202_deal_aag()
 
    CALL q202_get_abb()
    SELECT COUNT(*) INTO l_n FROM gglq202_abb
    IF l_n = 0 THEN
       CALL cl_err('sel abb:','aap-129',1)
       RETURN
    END IF
 
    CALL q202_deal_abb()
 
    CALL q202_deal_b()
    
    CALL q202_format_form()
 
END FUNCTION
 
#查找該統制科目下的所有非統制科目
FUNCTION q202_get_aag(p_aag08)
DEFINE   p_aag08     LIKE aag_file.aag08
DEFINE   l_sql       STRING
DEFINE   l_max       LIKE type_file.num5
DEFINE   j           LIKE type_file.num5
DEFINE   i           LIKE type_file.num5
DEFINE   l_aag       DYNAMIC ARRAY OF RECORD
           aag00     LIKE aag_file.aag00,
           aag01     LIKE aag_file.aag01,
           aag02     LIKE aag_file.aag02,
           aag06     LIKE aag_file.aag06,
           aag07     LIKE aag_file.aag07,
           aag08     LIKE aag_file.aag08,
           aag09     LIKE aag_file.aag09,
           aag13     LIKE aag_file.aag13,
           colno     LIKE type_file.num5
                     END RECORD
 
   CALL l_aag.clear()
   LET l_sql = "SELECT aag00,aag01,aag02,aag06,aag07,aag08,aag09, ",
               "       aag13,0  ",
               "  FROM aag_file ",
               " WHERE aag00 = '",tm.b,"'",
               "   AND aag01 <> '",p_aag08,"'",
               "   AND aag08 = '",p_aag08,"'"
 
   IF tm.h = 'Y' THEN
      LET l_sql = l_sql , " AND aag09 = 'Y' "
   END IF
   LET l_sql = l_sql," ORDER BY aag01 "
 
   PREPARE q202_get_aag_prep FROM l_sql
   DECLARE q202_get_aag_cs CURSOR FOR q202_get_aag_prep
   LET j = 1
   FOREACH q202_get_aag_cs INTO l_aag[j].*
      LET j = j + 1
   END FOREACH
   CALL l_aag.deleteElement(j)
 
   FOR i = 1 TO j-1
      IF l_aag[i].aag07 <> '1' THEN
         INSERT INTO gglq202_aag VALUES(l_aag[i].*)
      ELSE
         CALL q202_get_aag(l_aag[i].aag01)
      END IF
   END FOR
 
END FUNCTION
 
#處理會計科目信息
FUNCTION q202_deal_aag()
DEFINE  l_max     LIKE type_file.num5
DEFINE  i         LIKE type_file.num5
 
        INITIALIZE g_abb.* TO NULL 
        INITIALIZE g_aag.* TO NULL
        DECLARE q202_deal_aag_cs CURSOR FOR
          SELECT * FROM gglq202_aag ORDER BY aag06,aag01 
 
        FOREACH q202_deal_aag_cs INTO g_aag.*
          #確定科目在畫面table中列的位置
           LET l_max = 0
           SELECT MAX(colno) INTO l_max FROM gglq202_aag
           IF l_max = 0 THEN
              LET l_max = 1
           ELSE
              LET l_max = l_max + 1
           END IF
           LET g_aag.colno = l_max
 
          #日期區間內，每個會計月份該科目的期初信息。同時插入本期合計和本年合計資料，數據會由后期計算后回寫。
           FOR i = tm.bm TO tm.em
               IF g_aag.aag06 = '1' THEN
                  SELECT SUM(aah04 - aah05) INTO g_abb.abb07 FROM aah_file
                   WHERE aah00 = g_aag.aag00
                     AND aah01 = g_aag.aag01
                     AND aah02 = tm.yy
                     AND aah03 < i
               END IF
               IF g_aag.aag06 = '2' THEN
                  SELECT SUM(aah05 - aah04) INTO g_abb.abb07 FROM aah_file
                   WHERE aah00 = g_aag.aag00
                     AND aah01 = g_aag.aag01
                     AND aah02 = tm.yy
                     AND aah03 < i
               END IF
               IF cl_null(g_abb.abb07) THEN LET g_abb.abb07 = 0 END IF 
               LET g_abb.aba00 = g_aag.aag00
               LET g_abb.aba01 = ''
               LET g_abb.aba02 = g_today
               LET g_abb.aba04 = i
               LET g_abb.abb02 = 0
               LET g_abb.abb03 = g_aag.aag01
               LET g_abb.abb04 = ''
               LET g_abb.abb06 = g_aag.aag06
               LET g_abb.abb07 = g_abb.abb07 / g_unit
               LET g_abb.abb07 = cl_digcut(g_abb.abb07,g_azi04)
               LET g_abb.aag02 = g_aag.aag02
               LET g_abb.aag06 = g_aag.aag06
               LET g_abb.bal   = g_abb.abb07
               LET g_abb.colno = g_aag.colno
               LET g_abb.begno = 'B'         #表示-期初數據
               INSERT INTO gglq202_abb VALUES(g_abb.*)
               
               LET g_abb.begno = 'E'         #表示-本期合計數據
               LET g_abb.abb07 = 0
               LET g_abb.bal   = 0
               INSERT INTO gglq202_abb VALUES(g_abb.*)
               
               LET g_abb.begno = 'Y'         #表示-本年合計數據
               LET g_abb.abb07 = 0
               LET g_abb.bal   = 0
               INSERT INTO gglq202_abb VALUES(g_abb.*)
           END FOR 
           UPDATE gglq202_aag SET colno = g_aag.colno
            WHERE aag01 = g_aag.aag01
 
        END FOREACH
 
END FUNCTION
 
#抓取憑証資料并插入至臨時表
FUNCTION q202_get_abb()
DEFINE   l_sql    STRING
 
    INITIALIZE g_abb.* TO NULL
    LET l_sql = "SELECT aba00,aba01,aba02,aba04,abb02,abb03, ",
                "       abb04,abb06,abb07,aag02,aag06,0,gglq202_aag.colno,'D' ",
                "  FROM aba_file, abb_file,gglq202_aag",
                " WHERE aba01 = abb01 ",
                "   AND aba00 = abb00 ",
                "   AND aba03 = ",tm.yy,
                "   AND aba04 BETWEEN ",tm.bm,"  AND ",tm.em,
                "   AND aba00 = '",tm.b,"'",
                "   AND abapost= 'Y' ",
                "   AND abb03 = gglq202_aag.aag01 ",
                " ORDER BY aba02,aba01,abb02"
    PREPARE q202_abb_prep FROM l_sql
    DECLARE q202_abb_cs CURSOR FOR q202_abb_prep
 
        FOREACH q202_abb_cs INTO g_abb.*
          LET g_abb.abb07 = g_abb.abb07 / g_unit
          LET g_abb.abb07 = cl_digcut(g_abb.abb07,g_azi04)
          INSERT INTO gglq202_abb VALUES(g_abb.*)
        END FOREACH
 
 
END FUNCTION
 
#處理憑証信息
FUNCTION q202_deal_abb()
DEFINE   l_aba04  LIKE aba_file.aba04 
DEFINE   i        LIKE type_file.num5
DEFINE   l_bel_d  LIKE abb_file.abb07
DEFINE   l_bel_c  LIKE abb_file.abb07
DEFINE   l_sql    STRING 
 
    LET l_sql = "SELECT * FROM gglq202_abb ",
                " WHERE begno = 'D' AND aba04 = ? ",     #begno='D' -表示該資料是從憑証而來。
                " ORDER BY aba02,aba01,abb02 " 
    PREPARE q202_deal_abb_prep FROM l_sql 
    DECLARE q202_deal_abb_cs CURSOR FOR q202_deal_abb_prep
    
    FOR l_aba04 = tm.bm TO tm.em 
    
        SELECT SUM(abb07) INTO l_bel_d FROM gglq202_abb
         WHERE aag06 = '1' AND aba04 = l_aba04 
           AND begno = 'B'
        SELECT SUM(abb07) INTO l_bel_c FROM gglq202_abb
         WHERE aag06 = '2' AND aba04 = l_aba04
           AND begno = 'B'
        
        IF cl_null(l_bel_d) THEN LET l_bel_d = 0 END IF
        IF cl_null(l_bel_c) THEN LET l_bel_c = 0 END IF
        
        LET g_bal = l_bel_d - l_bel_c
        
        FOREACH q202_deal_abb_cs USING l_aba04 INTO g_abb.*
        
           IF g_abb.abb06 = 1 THEN
              LET g_bal = g_bal + g_abb.abb07
           ELSE
              LET g_bal = g_bal - g_abb.abb07
           END IF
        
           LET g_abb.bal = g_bal
           IF g_abb.abb06<> g_abb.aag06 THEN
              LET g_abb.abb07 = g_abb.abb07*-1
           END IF
        
          UPDATE gglq202_abb SET abb07 = g_abb.abb07,
                                   bal = g_abb.bal
           WHERE aba01 = g_abb.aba01 AND abb02 = g_abb.abb02
        
        END FOREACH
    END FOR 
 
END FUNCTION
 
FUNCTION q202_deal_b()
DEFINE   l_sql        STRING
DEFINE   l_cnt        LIKE type_file.num5
DEFINE   l_ac         LIKE type_file.num10
DEFINE   l_d_tot      LIKE abb_file.abb07
DEFINE   l_c_tot      LIKE abb_file.abb07
DEFINE   i            LIKE type_file.num5
DEFINE   j            LIKE type_file.num5
DEFINE   l_abb07      LIKE abb_file.abb07
DEFINE   l_amt        LIKE abb_file.abb07
 
    CALL g_q202.clear()
    INITIALIZE g_abb.* TO NULL
    LET l_ac = 1
    LET g_rec_b = 0
 
    DECLARE q202_beging_cs CURSOR FOR
     SELECT * FROM gglq202_abb 
      WHERE begno = 'B' AND aba04 = ?
      ORDER BY colno
 
    DECLARE q202_detail_cs CURSOR FOR
     SELECT * FROM gglq202_abb 
      WHERE begno = 'D' AND aba04 = ?
      ORDER BY aba02,aba01,abb02
      
    DECLARE q202_end_cs CURSOR FOR 
     SELECT * FROM gglq202_abb
      WHERE begno = 'E' AND aba04 = ?
     ORDER BY colno
     
    DECLARE q202_year_cs CURSOR FOR 
     SELECT * FROM gglq202_abb
      WHERE begno = 'Y' AND aba04 = ?
     ORDER BY colno
 
    FOR i = tm.bm TO tm.em
       CALL g_q202.clear()
       LET l_d_tot = 0
       LET l_c_tot = 0
       LET g_q202[1].aba04    = i
       LET g_q202[1].aba02_mm = 0
       LET g_q202[1].aba02_dd = 0
       LET g_q202[1].abb04    = cl_getmsg('ggl-213',g_lang)
       CALL q202_default()
       INSERT INTO gglq202_tmp VALUES(g_q202[1].*)
       FOREACH q202_beging_cs  USING i INTO g_abb.*
           IF g_abb.aag06 = '1' THEN
              LET l_d_tot = l_d_tot + g_abb.abb07
           ELSE
              LET l_c_tot = l_c_tot + g_abb.abb07
           END IF
           LET l_sql = "UPDATE gglq202_tmp SET c",g_abb.colno USING '&&&'," = ",g_abb.abb07,
                       " WHERE aba04 = ",i," AND aba02_mm = 0 "
           PREPARE q202_upd_prep1 FROM l_sql
           EXECUTE q202_upd_prep1
       END FOREACH
       LET g_q202[1].balance = l_d_tot - l_c_tot
       CASE
         WHEN g_q202[1].balance<0
           LET g_q202[1].abb06 = cl_getmsg('ggl-212',g_lang)
           LET g_q202[1].balance = g_q202[1].balance * -1
         WHEN g_q202[1].balance=0
           LET g_q202[1].abb06 = cl_getmsg('ggl-210',g_lang)
         WHEN g_q202[1].balance>0
           LET g_q202[1].abb06 = cl_getmsg('ggl-211',g_lang)
       END CASE
       
       UPDATE gglq202_tmp SET abb06   = g_q202[1].abb06,
                              balance = g_q202[1].balance
        WHERE aba04 = i 
       
       CALL g_q202.clear()
       FOREACH q202_detail_cs USING i INTO g_abb.*
           CASE
             WHEN g_abb.bal > 0
               LET g_q202[1].abb06 = cl_getmsg('ggl-211',g_lang)
               LET g_q202[1].balance = g_abb.bal
             WHEN g_abb.bal = 0
               LET g_q202[1].abb06 = cl_getmsg('ggl-210',g_lang)
               LET g_q202[1].balance = g_abb.bal
             WHEN g_abb.bal < 0
               LET g_q202[1].abb06 = cl_getmsg('ggl-212',g_lang)
               LET g_q202[1].balance = g_abb.bal * -1
           END CASE
           LET g_q202[1].aba02_mm = MONTH(g_abb.aba02)
           LET g_q202[1].aba02_dd = DAY(g_abb.aba02)
           LET g_q202[1].aba01    = g_abb.aba01
           LET g_q202[1].abb02    = g_abb.abb02
           LET g_q202[1].abb04    = g_abb.abb04
           LET g_q202[1].aba04    = i
           CALL q202_default()
           INSERT INTO gglq202_tmp VALUES(g_q202[1].*)
           LET l_sql = " UPDATE gglq202_tmp SET ",
                       "        c", g_abb.colno USING '&&&'," =",g_abb.abb07,
           " WHERE aba01 = '",g_abb.aba01,"' ",
                             "   AND abb02 =  ",g_abb.abb02
       
           PREPARE q202_upd_prep2 FROM l_sql
           EXECUTE q202_upd_prep2
       
       END FOREACH
 
       
       CALL g_q202.clear()
       LET l_d_tot = 0
       LET l_c_tot = 0
       LET g_q202[1].aba04    = i
       LET g_q202[1].aba02_mm = 13
       LET g_q202[1].aba02_dd = 0
       LET g_q202[1].aba01    = NULL 
       LET g_q202[1].abb04    = cl_getmsg('ggl-214',g_lang)
       CALL q202_default()
       INSERT INTO gglq202_tmp VALUES(g_q202[1].*)
       FOREACH q202_end_cs USING i INTO g_abb.*
          LET l_amt = 0
          SELECT SUM(abb07) INTO l_abb07 FROM gglq202_abb 
           WHERE aba04 = i AND colno = g_abb.colno
             AND begno = 'B'
          IF cl_null(l_abb07) THEN LET l_abb07 = 0 END IF
          LET l_amt = l_amt + l_abb07 
          SELECT SUM(abb07) INTO l_abb07 FROM gglq202_abb 
           WHERE aba04 = i AND colno = g_abb.colno
             AND begno = 'D'
          IF cl_null(l_abb07) THEN LET l_abb07 = 0 END IF 
          LET l_amt = l_amt + l_abb07
          IF g_abb.aag06 = 1 THEN 
             LET l_d_tot = l_d_tot + l_amt
          ELSE 
             LET l_c_tot = l_c_tot + l_amt
          END IF 
          LET l_sql = " UPDATE gglq202_tmp SET c",g_abb.colno USING '&&&',
                      " =",l_abb07 ," WHERE aba02_mm = 13 ",
                      " AND aba04 = ",i
          PREPARE q202_upd_prep3 FROM l_sql 
          EXECUTE q202_upd_prep3
          
          UPDATE gglq202_abb SET abb07 = l_abb07
           WHERE aba04 = i AND colno = g_abb.colno AND begno = 'E'
       END FOREACH 
       LET g_q202[1].balance = l_d_tot - l_c_tot
       CASE
         WHEN g_q202[1].balance<0
           LET g_q202[1].abb06 = cl_getmsg('ggl-212',g_lang)
           LET g_q202[1].balance = g_q202[1].balance * -1
         WHEN g_q202[1].balance=0
           LET g_q202[1].abb06 = cl_getmsg('ggl-210',g_lang)
         WHEN g_q202[1].balance>0
           LET g_q202[1].abb06 = cl_getmsg('ggl-211',g_lang)
       END CASE
       UPDATE gglq202_tmp SET balance = g_q202[1].balance,
                              abb06   = g_q202[1].abb06
        WHERE aba04 = i AND aba02_mm = 13
       
       CALL g_q202.clear()
       LET l_d_tot = 0
       LET l_c_tot = 0
       LET g_q202[1].aba04    = i
       LET g_q202[1].aba02_mm = 14
       LET g_q202[1].aba02_dd = 0
       LET g_q202[1].aba01    = NULL 
       LET g_q202[1].abb04    = cl_getmsg('ggl-215',g_lang)
       CALL q202_default()
       INSERT INTO gglq202_tmp VALUES(g_q202[l_ac].*)
       FOREACH q202_year_cs USING i INTO g_abb.*  
          LET l_amt = 0 
          SELECT abb07 INTO l_abb07 FROM gglq202_abb
           WHERE aba04 = i AND colno = g_abb.colno
             AND begno = 'B'
          IF cl_null(l_abb07) THEN LET l_abb07 = 0 END IF 
          LET l_amt = l_amt + l_abb07
          SELECT abb07 INTO l_abb07 FROM gglq202_abb
           WHERE aba04 = i AND colno = g_abb.colno
             AND begno = 'E'
          IF cl_null(l_abb07) THEN LET l_abb07 = 0 END IF 
          LET l_amt = l_amt + l_abb07
          IF g_abb.aag06 = 1 THEN 
             LET l_d_tot = l_d_tot + l_amt
          ELSE 
             LET l_c_tot = l_c_tot + l_amt
          END IF 
          LET l_sql = " UPDATE gglq202_tmp SET c",g_abb.colno USING '&&&',
                      " =",l_amt, " WHERE aba02_mm = 14 ",
                      " AND aba04 = ",i
          PREPARE q202_upd_prep4 FROM l_sql 
          EXECUTE q202_upd_prep4   
          UPDATE gglq202_abb SET abb07 = l_amt 
           WHERE aba04 = i AND colno = g_abb.colno AND begno = 'Y'
       END FOREACH  
       LET g_q202[1].balance = l_d_tot - l_c_tot
       CASE
         WHEN g_q202[1].balance<0
           LET g_q202[1].abb06 = cl_getmsg('ggl-212',g_lang)
           LET g_q202[1].balance = g_q202[1].balance * -1
         WHEN g_q202[1].balance=0
           LET g_q202[1].abb06 = cl_getmsg('ggl-210',g_lang)
         WHEN g_q202[1].balance>0
           LET g_q202[1].abb06 = cl_getmsg('ggl-211',g_lang)
       END CASE
       UPDATE gglq202_tmp SET balance = g_q202[1].balance,
                              abb06   = g_q202[1].abb06
        WHERE aba04 = i AND aba02_mm = 14            
        
        
        
    END FOR 
END FUNCTION
 
FUNCTION q202_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q202_curs INTO g_mm
      WHEN 'P' FETCH PREVIOUS q202_curs INTO g_mm
      WHEN 'F' FETCH FIRST    q202_curs INTO g_mm
      WHEN 'L' FETCH LAST     q202_curs INTO g_mm
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
         FETCH ABSOLUTE g_jump q202_curs INTO g_mm
         LET mi_no_ask = FALSE
   END CASE
 
   LET g_row_count =  tm.em - tm.bm + 1
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mm,SQLCA.sqlcode,0)
      INITIALIZE g_mm    TO NULL
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
   END IF
 
   CALL g202_show()
 
END FUNCTION 
 
FUNCTION g202_show()
DEFINE   l_unit     LIKE type_file.chr4
 
    INITIALIZE g_abb.* TO NULL
    CALL g_q202.clear()
 
    LET l_unit = cl_getmsg('sub-137',g_lang)
    LET l_ac = 0
    SELECT COUNT(*) INTO l_ac FROM gglq202_aag
    IF l_ac = 0 THEN RETURN END IF
 
    LET l_ac = 0
    SELECT COUNT(*) INTO l_ac FROM gglq202_abb
    IF l_ac = 0 THEN RETURN END IF
 
    CLEAR FORM
 
    DISPLAY tm.b  TO FORMONLY.aag00
    DISPLAY tm.yy TO FORMONLY.yy
    DISPLAY g_mm  TO FORMONLY.mm
    DISPLAY g_row_count TO FORMONLY.cn
    DISPLAY BY NAME g_aza.aza17
    DISPLAY l_unit TO FORMONLY.unit
 
    CALL q202_b_fill()
 
 
 
END FUNCTION 
 
FUNCTION q202_b_fill()
 
    CALL g_q202.clear()
    LET l_ac = 1
 
    DECLARE q202_get_tmp_cs CURSOR FOR
     SELECT * FROM gglq202_tmp 
      WHERE aba04 = g_mm
     ORDER BY aba02_mm,aba02_dd
    FOREACH q202_get_tmp_cs INTO g_q202[l_ac].*
       IF g_q202[l_ac].aba02_mm = 0 
       OR g_q202[l_ac].aba02_mm = 13 
       OR g_q202[l_ac].aba02_mm = 14 THEN
          LET g_q202[l_ac].aba02_mm = NULL
          LET g_q202[l_ac].aba02_dd = NULL
       END IF
       LET g_q202[l_ac].aba02_dd = g_q202[l_ac].aba02_dd USING '&&'
       LET l_ac = l_ac + 1
       IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
       END IF
    END FOREACH
 
   DISPLAY l_ac-1 TO FORMONLY.cnt
END FUNCTION
 
FUNCTION q202_show_voucher()
 
    IF cl_null(tm.b) THEN RETURN END IF
    IF g_q202.getLength() = 0 THEN RETURN END IF
    IF cl_null(g_q202[l_ac].aba01) THEN RETURN END IF
    LET g_str = "aglt110 '",tm.b,"' '",g_q202[l_ac].aba01,"'"
    CALL cl_cmdrun(g_str)
 
END FUNCTION
 
FUNCTION q202_format_form()
DEFINE   l_aag02        LIKE aag_file.aag02
DEFINE   l_aag06        LIKE aag_file.aag06
DEFINE   l_colno        LIKE type_file.num5
DEFINE   i              LIKE type_file.num5
DEFINE   l_cmd          STRING
DEFINE   l_c_chr        STRING
DEFINE   l_d_chr        STRING
DEFINE   l_title        STRING
 
 
    LET l_cmd = ''
    FOR i = 1 TO g_colnum
        LET l_cmd = l_cmd ,'c',i USING '&&&'
        IF i < g_colnum THEN LET l_cmd = l_cmd , ',' END IF
    END FOR
    CALL cl_set_comp_visible(l_cmd,FALSE)
 
    LET l_cmd = ''
 
    LET l_d_chr = cl_getmsg('ggl-211',g_lang)
    LET l_c_chr = cl_getmsg('ggl-212',g_lang)
    DECLARE q202_aag02_06_cs  CURSOR FOR
     SELECT aag02,aag06,colno FROM gglq202_aag
 
    FOREACH q202_aag02_06_cs INTO l_aag02,l_aag06,l_colno
       IF l_aag06 = '1' THEN
          LET l_title = l_aag02,'(',l_d_chr,')'
       ELSE
          LET l_title = l_aag02,'(',l_c_chr,')'
       END IF
       LET l_cmd = 'c',l_colno USING '&&&'
       CALL cl_set_comp_att_text(l_cmd,l_title)
       CALL cl_set_comp_visible(l_cmd,TRUE)
    END FOREACH
 
END FUNCTION
 
 
 
FUNCTION q202_tmp_table(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1
DEFINE   l_sql   STRING
DEFINE   i       LIKE type_file.num5
 
   IF p_cmd = 'c' THEN
      LET g_success = 'Y'
      CREATE TEMP TABLE gglq202_aag(
                aag00  LIKE aag_file.aag00,
                aag01  LIKE aag_file.aag01,
                aag02  LIKE aag_file.aag02,
                aag06  LIKE aag_file.aag06,
                aag07  LIKE aag_file.aag07,
                aag08  LIKE aag_file.aag08,
                aag09  LIKE aag_file.aag09,
                aag13  LIKE aag_file.aag13,
                colno  LIKE type_file.num5);
      IF SQLCA.sqlcode THEN
         CALL cl_err('CREATE TEMP TABLE q202_aag01',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
 
      CREATE TEMP TABLE gglq202_abb(
                aba00  LIKE aba_file.aba00,
                aba01  LIKE aba_file.aba01,
                aba02  LIKE aba_file.aba02,
                aba04  LIKE aba_file.aba04,
                abb02  LIKE abb_file.abb02,
                abb03  LIKE abb_file.abb03,
                abb04  LIKE abb_file.abb04,
                abb06  LIKE abb_file.abb06,
                abb07  LIKE abb_file.abb07,
                aag02  LIKE aag_file.aag02,
                aag06  LIKE aag_file.aag06,
                bal    LIKE abb_file.abb07,
                colno  LIKE type_file.num5,
                begno  LIKE type_file.chr1);
      IF SQLCA.sqlcode THEN
         CALL cl_err('CREATE TEMP TABLE gglq202_abb:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
 
      LET l_sql = "CREATE TEMP TABLE gglq202_tmp( ",
                  "   aba04     LIKE aba_file.aba04, ",
                  "   aba02_mm  LIKE type_file.num5, ",
                  "   aba02_dd  LIKE type_file.num5, ",
                  "      aba01  LIKE aba_file.aba01, ",
                  "      abb02  LIKE abb_file.abb02, ",
                  "      abb04  LIKE abb_file.abb04, "
      FOR i = 1 TO g_colnum
          LET l_sql = l_sql ,"  c",i USING '&&&'," DECIMAL(20,6) DEFAULT 0,"
      END FOR
 
      LET l_sql = l_sql ,"  abb06   VARCHAR(4),",
                         "  balance DECIMAL(20,6) DEFAULT 0) "
      PREPARE q202_cre_tmp_prep FROM l_sql
      EXECUTE q202_cre_tmp_prep
      IF SQLCA.sqlcode THEN
         CALL cl_err('CREATE TEMP TABLE gglq202_tmp:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
 
   END IF
   IF p_cmd = 'd' THEN
      DROP TABLE gglq202_aag;
      DROP TABLE gglq202_abb;
      DROP TABLE gglq202_tmp;
   END IF
 
END FUNCTION
 
#清空臨時表
FUNCTION q202_del_tmp()
 
   DELETE FROM gglq202_aag;
   DELETE FROM gglq202_abb;
   DELETE FROM gglq202_tmp;
END FUNCTION
 
FUNCTION q202_out_prep()
DEFINE   i      LIKE type_file.num5
 
     LET g_success = 'Y'
     LET g_sql="aba04.aba_file.aba04, ",
               "aba02_mm.type_file.num5,",
               "aba02_dd.type_file.num5,",
               "aba01.aba_file.aba01, ",
               "abb02.abb_file.abb02, ",
               "abb04.abb_file.abb04, "
     FOR i = 1 TO g_prtcol
         LET g_sql = g_sql , "c",i USING '&&&' , ".aag_file.aag02 "
         IF i <> g_prtcol THEN 
            LET g_sql = g_sql,','
         END IF 
     END FOR 
     LET l_table = cl_prt_temptable('gglq202',g_sql) CLIPPED
     IF l_table = -1 THEN LET g_success ='N' RETURN  END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,"  
     FOR i = 1 TO g_prtcol
         LET g_sql = g_sql ,"? "
         IF i <> g_prtcol THEN 
            LET g_sql = g_sql , ','
         END IF 
     END FOR 
     LET g_sql = g_sql,"  ) "
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        LET g_success = 'N'
        RETURN
     END IF
 
END FUNCTION
 
FUNCTION q202_out()
DEFINE   i         LIKE type_file.num5
DEFINE   l_aag02   LIKE aag_file.aag02
DEFINE   l_aag06   LIKE aag_file.aag06
DEFINE   l_colno   LIKE type_file.num5
DEFINE   l_cmd     STRING 
DEFINE   l_cnt     LIKE type_file.num5
DEFINE   sr        RECORD
          aba04    LIKE aba_file.aba04,
          aba02_mm LIKE type_file.num5,
          aba02_dd LIKE type_file.num5,
          aba01    LIKE aba_file.aba01,
          abb02    LIKE abb_file.abb02,
          abb04    LIKE abb_file.abb04,
          c001     LIKE type_file.chr30,
          c002     LIKE type_file.chr30,
          c003     LIKE type_file.chr30,
          c004     LIKE type_file.chr30,
          c005     LIKE type_file.chr30,
          c006     LIKE type_file.chr30,
          c007     LIKE type_file.chr30,
          c008     LIKE type_file.chr30,
          c009     LIKE type_file.chr30,
          c010     LIKE type_file.chr30,
          c011     LIKE type_file.chr30,
          c012     LIKE type_file.chr30,
          c013     LIKE type_file.chr30,
          c014     LIKE type_file.chr30,
          c015     LIKE type_file.chr30,
          c016     LIKE type_file.chr30
                   END RECORD 
 
    CALL cl_del_data(l_table)
    
    SELECT COUNT(aag01) INTO l_cnt FROM gglq202_aag
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
    
    LET g_sql = " SELECT aba04,aba02_mm,aba02_dd,aba01,abb02,abb04,"
    IF l_cnt > 0 THEN 
       IF l_cnt >= g_prtcol THEN 
          LET l_cnt = g_prtcol - 2
       END IF 
       FOR i = 1 TO l_cnt
           LET g_sql = g_sql,"c",i USING '&&&',","
       END FOR 
    END IF 
    LET g_sql = g_sql,"abb06,balance FROM gglq202_tmp ",
                      " ORDER BY aba04,aba02_mm,aba02_dd,aba01,abb02"
                      
    PREPARE q202_out_prep FROM g_sql 
    DECLARE q202_out_cs CURSOR FOR q202_out_prep
    
    FOR i = tm.bm TO tm.em
        INITIALIZE sr.* TO NULL 
        LET sr.aba04 = i
        LET sr.aba02_mm = -1
        EXECUTE insert_prep USING sr.*
    END FOR 
    DECLARE q202_title_cs CURSOR FOR 
      SELECT aag02,aag06,colno FROM gglq202_aag ORDER BY colno
               
    FOREACH q202_title_cs INTO l_aag02,l_aag06,l_colno
      IF l_aag06 = '1' THEN 
         LET l_cmd = cl_getmsg('ggl-211',g_lang)     
      END IF 
      IF l_aag06 = '2' THEN 
         LET l_cmd = cl_getmsg('ggl-212',g_lang)
      END IF 
      LET l_aag02 = l_aag02,'(',l_cmd,')'
      LET g_sql = " UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " SET c",l_colno USING '&&&', " = '",l_aag02,"'",
                  " WHERE aba02_mm = -1 "
      PREPARE q202_upd_15_prep FROM g_sql
      EXECUTE q202_upd_15_prep
    END FOREACH 
    LET l_aag02 = cl_getmsg('ggl-228',g_lang)
    LET g_sql = " UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " SET c",l_cnt+1 USING '&&&', " = '",l_aag02,"'",
                  " WHERE aba02_mm = -1 "
    PREPARE q202_upd_15_1_prep FROM g_sql
    EXECUTE q202_upd_15_1_prep
    LET l_aag02 = cl_getmsg('ggl-209',g_lang)
    LET g_sql = " UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " SET c",l_cnt+2 USING '&&&', " = '",l_aag02,"'",
                  " WHERE aba02_mm = -1 "
    PREPARE q202_upd_15_2_prep FROM g_sql
    EXECUTE q202_upd_15_2_prep
 
    FOREACH q202_out_cs INTO sr.*
        EXECUTE insert_prep USING sr.*
    END FOREACH 
     
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY aba04,aba02_mm,aba02_dd,aba01,abb02 "
 
   LET g_str='',';','',';','',';',g_azi04,';',l_cnt
    
    CALL cl_prt_cs3('gglq202','gglq202',g_sql,g_str)
 
END FUNCTION
 
FUNCTION q202_default()
 
    LET g_q202[1].c001 = 0    LET g_q202[1].c002 = 0    LET g_q202[1].c003 = 0
    LET g_q202[1].c004 = 0    LET g_q202[1].c005 = 0    LET g_q202[1].c006 = 0
    LET g_q202[1].c007 = 0    LET g_q202[1].c008 = 0    LET g_q202[1].c009 = 0
    LET g_q202[1].c010 = 0    LET g_q202[1].c011 = 0    LET g_q202[1].c012 = 0
    LET g_q202[1].c013 = 0    LET g_q202[1].c014 = 0    LET g_q202[1].c015 = 0
    LET g_q202[1].c016 = 0    LET g_q202[1].c017 = 0    LET g_q202[1].c018 = 0
    LET g_q202[1].c019 = 0    LET g_q202[1].c020 = 0    LET g_q202[1].c021 = 0
    LET g_q202[1].c022 = 0    LET g_q202[1].c023 = 0    LET g_q202[1].c024 = 0
    LET g_q202[1].c025 = 0    LET g_q202[1].c026 = 0    LET g_q202[1].c027 = 0
    LET g_q202[1].c028 = 0    LET g_q202[1].c029 = 0    LET g_q202[1].c030 = 0
    LET g_q202[1].c031 = 0    LET g_q202[1].c032 = 0    LET g_q202[1].c033 = 0
    LET g_q202[1].c034 = 0    LET g_q202[1].c035 = 0    LET g_q202[1].c036 = 0
    LET g_q202[1].c037 = 0    LET g_q202[1].c038 = 0    LET g_q202[1].c039 = 0
    LET g_q202[1].c040 = 0    LET g_q202[1].c041 = 0    LET g_q202[1].c042 = 0
    LET g_q202[1].c043 = 0    LET g_q202[1].c044 = 0    LET g_q202[1].c045 = 0
    LET g_q202[1].c046 = 0    LET g_q202[1].c047 = 0    LET g_q202[1].c048 = 0
    LET g_q202[1].c049 = 0    LET g_q202[1].c050 = 0    LET g_q202[1].c051 = 0
    LET g_q202[1].c052 = 0    LET g_q202[1].c053 = 0    LET g_q202[1].c054 = 0
    LET g_q202[1].c055 = 0    LET g_q202[1].c056 = 0    LET g_q202[1].c057 = 0
    LET g_q202[1].c058 = 0    LET g_q202[1].c059 = 0    LET g_q202[1].c060 = 0
    LET g_q202[1].c061 = 0    LET g_q202[1].c062 = 0    LET g_q202[1].c063 = 0
    LET g_q202[1].c064 = 0    LET g_q202[1].c065 = 0    LET g_q202[1].c066 = 0
    LET g_q202[1].c067 = 0    LET g_q202[1].c068 = 0    LET g_q202[1].c069 = 0
    LET g_q202[1].c070 = 0    LET g_q202[1].c071 = 0    LET g_q202[1].c072 = 0
    LET g_q202[1].c073 = 0    LET g_q202[1].c074 = 0    LET g_q202[1].c075 = 0
    LET g_q202[1].c076 = 0    LET g_q202[1].c077 = 0    LET g_q202[1].c078 = 0
    LET g_q202[1].c079 = 0    LET g_q202[1].c080 = 0    LET g_q202[1].c081 = 0
    LET g_q202[1].c082 = 0    LET g_q202[1].c083 = 0    LET g_q202[1].c084 = 0
    LET g_q202[1].c085 = 0    LET g_q202[1].c086 = 0    LET g_q202[1].c087 = 0
    LET g_q202[1].c088 = 0    LET g_q202[1].c089 = 0    LET g_q202[1].c090 = 0
    LET g_q202[1].c091 = 0    LET g_q202[1].c092 = 0    LET g_q202[1].c093 = 0
    LET g_q202[1].c094 = 0    LET g_q202[1].c095 = 0    LET g_q202[1].c096 = 0
    LET g_q202[1].c097 = 0    LET g_q202[1].c098 = 0    LET g_q202[1].c099 = 0
    LET g_q202[1].c100 = 0
END FUNCTION 
