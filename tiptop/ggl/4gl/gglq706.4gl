# Prog. Version..: '5.30.07-13.05.20(00009)'     #
#
# Pattern name...: gglq706.4gl
# Descriptions...: 科目核算項帳交叉查詢
# Date & Author..: 08/06/24 by Carrier  #No.FUN-850030
# Modify.........: No.FUN-850030 08/07/24 By dxfwo 新增程序從21區移植到31區
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-940157 09/04/13 By chenl QBE條件增加核算項開窗功能。
# Modify.........: No.MOD-940388 09/04/30 By wujie 字串連接%前要加轉義符\
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.MOD-C50145 12/05/21 By yinhy 關係人核算項改為99
# Modify.........: No.TQC-C50211 12/05/28 By wujie 无法显示核算项资料来源为缺省时的核算项名称
# Modify.........: No.TQC-C80025 12/08/03 By lujh 輸入qbe後點擊【退出】應只退出查詢界面，不應將整個作業都退出.
# Modify.........: No:CHI-C70031 12/08/13 By chenying 去除CE、CA憑證資料，否則月末結轉損益後，查詢不到損益類科目
# Modify.........: No:FUN-C80102 12/10/19 By zhangweib 報表改善追單
# Modify.........: No:FUN-D40044 13/04/26 By lujh 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額
DATABASE ds

GLOBALS "../../config/top.global"  #No.FUN-850030

DEFINE tm                 RECORD
                          #wc1     LIKE type_file.chr1000,
                          #wc2     LIKE type_file.chr1000,
                          wc1         STRING,       #NO.FUN-910082
                          wc2         STRING,       #NO.FUN-910082
                          wc3         STRING,       #FUN-C80102 add
                          yy      LIKE type_file.num5,
                          mm1     LIKE type_file.num5,
                          mm2     LIKE type_file.num5,
                          o       LIKE aaa_file.aaa01,
                          a       LIKE type_file.chr2,
                          b       LIKE type_file.chr1,
                          i        LIKE type_file.chr1,     #FUN-D40044  add
                          more    LIKE type_file.chr1
                          END RECORD
DEFINE g_i                LIKE type_file.num5
DEFINE g_sql              STRING
DEFINE g_str              STRING
DEFINE l_table            STRING
DEFINE g_rec_b            LIKE type_file.num10
DEFINE g_mm               LIKE type_file.num5
DEFINE g_cnt              LIKE type_file.num10
DEFINE g_aed_d            DYNAMIC ARRAY OF RECORD
                          aed02      LIKE aed_file.aed02,
                          aed02_d    LIKE ze_file.ze03
                          END RECORD
DEFINE g_aed              DYNAMIC ARRAY OF RECORD
                          aag01      LIKE aag_file.aag01,
                          aag02      LIKE aag_file.aag02,
                          aed02      LIKE aed_file.aed02,     #FUN-C80102 add
                          d01        LIKE aed_file.aed05,
                          d02        LIKE aed_file.aed05,
                          d03        LIKE aed_file.aed05,
                          d04        LIKE aed_file.aed05,
                          d05        LIKE aed_file.aed05,
                          d06        LIKE aed_file.aed05,
                          d07        LIKE aed_file.aed05,
                          d08        LIKE aed_file.aed05,
                          d09        LIKE aed_file.aed05,
                          d10        LIKE aed_file.aed05,
                          d11        LIKE aed_file.aed05,
                          d12        LIKE aed_file.aed05,
                          d13        LIKE aed_file.aed05,
                          d14        LIKE aed_file.aed05,
                          d15        LIKE aed_file.aed05,
                          d16        LIKE aed_file.aed05,
                          d17        LIKE aed_file.aed05,
                          d18        LIKE aed_file.aed05,
                          d19        LIKE aed_file.aed05,
                          d20        LIKE aed_file.aed05,
                          d21        LIKE aed_file.aed05,
                          d22        LIKE aed_file.aed05,
                          d23        LIKE aed_file.aed05,
                          d24        LIKE aed_file.aed05,
                          d25        LIKE aed_file.aed05,
                          d26        LIKE aed_file.aed05,
                          d27        LIKE aed_file.aed05,
                          d28        LIKE aed_file.aed05,
                          d29        LIKE aed_file.aed05,
                          d30        LIKE aed_file.aed05,
                          d31        LIKE aed_file.aed05,
                          d32        LIKE aed_file.aed05,
                          d33        LIKE aed_file.aed05,
                          d34        LIKE aed_file.aed05,
                          d35        LIKE aed_file.aed05,
                          d36        LIKE aed_file.aed05,
                          d37        LIKE aed_file.aed05,
                          d38        LIKE aed_file.aed05,
                          d39        LIKE aed_file.aed05,
                          d40        LIKE aed_file.aed05,
                          d41        LIKE aed_file.aed05,
                          d42        LIKE aed_file.aed05,
                          d43        LIKE aed_file.aed05,
                          d44        LIKE aed_file.aed05,
                          d45        LIKE aed_file.aed05,
                          d46        LIKE aed_file.aed05,
                          d47        LIKE aed_file.aed05,
                          d48        LIKE aed_file.aed05,
                          d49        LIKE aed_file.aed05,
                          d50        LIKE aed_file.aed05
                          END RECORD
DEFINE g_title            RECORD
                          mm         LIKE type_file.num5,
                          t01        LIKE ze_file.ze03,
                          t02        LIKE ze_file.ze03,
                          t03        LIKE ze_file.ze03,
                          t04        LIKE ze_file.ze03,
                          t05        LIKE ze_file.ze03,
                          t06        LIKE ze_file.ze03,
                          t07        LIKE ze_file.ze03,
                          t08        LIKE ze_file.ze03,
                          t09        LIKE ze_file.ze03,
                          t10        LIKE ze_file.ze03,
                          t11        LIKE ze_file.ze03,
                          t12        LIKE ze_file.ze03,
                          t13        LIKE ze_file.ze03,
                          t14        LIKE ze_file.ze03,
                          t15        LIKE ze_file.ze03,
                          t16        LIKE ze_file.ze03,
                          t17        LIKE ze_file.ze03,
                          t18        LIKE ze_file.ze03,
                          t19        LIKE ze_file.ze03,
                          t20        LIKE ze_file.ze03,
                          t21        LIKE ze_file.ze03,
                          t22        LIKE ze_file.ze03,
                          t23        LIKE ze_file.ze03,
                          t24        LIKE ze_file.ze03,
                          t25        LIKE ze_file.ze03,
                          t26        LIKE ze_file.ze03,
                          t27        LIKE ze_file.ze03,
                          t28        LIKE ze_file.ze03,
                          t29        LIKE ze_file.ze03,
                          t30        LIKE ze_file.ze03,
                          t31        LIKE ze_file.ze03,
                          t32        LIKE ze_file.ze03,
                          t33        LIKE ze_file.ze03,
                          t34        LIKE ze_file.ze03,
                          t35        LIKE ze_file.ze03,
                          t36        LIKE ze_file.ze03,
                          t37        LIKE ze_file.ze03,
                          t38        LIKE ze_file.ze03,
                          t39        LIKE ze_file.ze03,
                          t40        LIKE ze_file.ze03,
                          t41        LIKE ze_file.ze03,
                          t42        LIKE ze_file.ze03,
                          t43        LIKE ze_file.ze03,
                          t44        LIKE ze_file.ze03,
                          t45        LIKE ze_file.ze03,
                          t46        LIKE ze_file.ze03,
                          t47        LIKE ze_file.ze03,
                          t48        LIKE ze_file.ze03,
                          t49        LIKE ze_file.ze03,
                          t50        LIKE ze_file.ze03
                          END RECORD
DEFINE g_field            LIKE gaq_file.gaq01
DEFINE g_msg              LIKE type_file.chr1000
DEFINE g_msg1             LIKE type_file.chr1000
DEFINE g_msg2             LIKE type_file.chr1000
DEFINE g_row_count        LIKE type_file.num10
DEFINE g_curs_index       LIKE type_file.num10
DEFINE g_jump             LIKE type_file.num10
DEFINE mi_no_ask          LIKE type_file.num5
DEFINE l_ac               LIKE type_file.num5
DEFINE g_aee02            LIKE aee_file.aee02   #No.TQC-C50211
DEFINE g_comb             ui.ComboBox           #FUN-C80102 add

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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE tm.* TO NULL
   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc1     = ARG_VAL(7)
   LET tm.wc2     = ARG_VAL(8)
   LET tm.yy      = ARG_VAL(9)
   LET tm.mm1     = ARG_VAL(10)
   LET tm.mm2     = ARG_VAL(11)
   LET tm.o       = ARG_VAL(12)
   LET tm.a       = ARG_VAL(13)
   LET tm.b       = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)

   CALL q706_out_1()

   LET g_prog = "gglq706"

   OPEN WINDOW q706_w AT 5,10
 #      WITH FORM "ggl/42f/gglq706_1" ATTRIBUTE(STYLE = g_win_style)   #FUN-C80102 mark
        WITH FORM "ggl/42f/gglq706" ATTRIBUTE(STYLE = g_win_style)     #FUN-C80102 add

   CALL cl_ui_init()

#FUN-C80102---mark--str--
#  IF cl_null(tm.wc1) THEN
#      CALL gglq706_tm(0,0)
#  ELSE
#      CALL gglq706()
#  END IF
#FUN-C80102---mark--end--

#FUN-C80102---add----str---
   LET g_comb = ui.ComboBox.forName("a")
   IF g_aaz.aaz88 = '0' THEN
      CALL g_comb.removeItem('1')
      CALL g_comb.removeItem('2')
      CALL g_comb.removeItem('3')
      CALL g_comb.removeItem('4')
   END IF
   IF g_aaz.aaz88 = '3' THEN
      CALL g_comb.removeItem('4')
   END IF
   IF g_aaz.aaz88 = '2' THEN
      CALL g_comb.removeItem('3')
      CALL g_comb.removeItem('4')
   END IF
   IF g_aaz.aaz88 = '1' THEN
      CALL g_comb.removeItem('2')
      CALL g_comb.removeItem('3')
      CALL g_comb.removeItem('4')
   END IF
   IF g_aaz.aaz125 = '5' THEN
      CALL g_comb.removeItem('6')
      CALL g_comb.removeItem('7')
      CALL g_comb.removeItem('8')
   END IF
   IF g_aaz.aaz125 = '6' THEN
      CALL g_comb.removeItem('7')
      CALL g_comb.removeItem('8')
   END IF
   IF g_aaz.aaz125 = '7' THEN
      CALL g_comb.removeItem('8')
   END IF
#FUN-C80102---add----end---

   CALL gglq706_tm(0,0)   #FUN-C80102 add

   CALL q706_menu()
   DROP TABLE gglq706_tmp;
   CLOSE WINDOW q706_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q706_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL q706_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq706_tm(0,0)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q706_out_2()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_aed),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_mm IS NOT NULL THEN
                  LET g_doc.column1 = "mm"
                  LET g_doc.value1 = g_mm
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q706_out_1()

   LET g_sql = " mm1.type_file.num5,    ",
               " aag01.aag_file.aag01,  ",
               " aag02.aag_file.aag02,  ",
               " gem02.gem_file.gem02,  ",
               " qty1.type_file.num20_6 "

   LET l_table = cl_prt_temptable('gglq706',g_sql) CLIPPED
   IF  l_table = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?)                "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

END FUNCTION

FUNCTION gglq706_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_flag         LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5
  #FUN-C80102----mark---str--
  #LET g_prog = "gglq706"
  #
  #LET p_row = 4 LET p_col = 13
  #
  #OPEN WINDOW gglq706_w1 AT p_row,p_col WITH FORM "ggl/42f/gglq706"
  #     ATTRIBUTE (STYLE = g_win_style CLIPPED)
  #
  #CALL cl_ui_locale("gglq706")
  #FUN-C80102----mark---end--

   CLEAR FORM #清除畫面   #FUN-D40044  add
   CALL g_aed.clear()   #FUN-D40044  add

   CALL cl_opmsg('p')
   LET tm.yy    = YEAR(g_today)
   LET tm.mm1   = MONTH(g_today)
   LET tm.mm2   = MONTH(g_today)
   LET tm.o     = g_aza.aza81
   LET tm.a     = '1'
   LET tm.b     = 'N'
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.i ='N'    #FUN-D40044 add
  #DISPLAY BY NAME tm.yy,tm.mm1,tm.mm2,tm.o,tm.a,tm.b,tm.more  #FUN-C80102 mark
   DISPLAY BY NAME tm.o,tm.yy,tm.mm1,tm.mm2,tm.o,tm.a,tm.b     #FUN-C80102 add
WHILE TRUE
   #No.FUN-B20010  --Begin
   DIALOG ATTRIBUTE(unbuffered)
  #INPUT BY NAME tm.o  ATTRIBUTE(WITHOUT DEFAULTS)    #FUN-C80102 mark
  #FUN-C80102-----add---str--
   INPUT BY NAME tm.o,tm.yy,tm.mm1,tm.mm2,tm.a,tm.b,tm.i ATTRIBUTE(WITHOUT DEFAULTS) #FUN-D40044 add tm.i 

      AFTER FIELD yy
         IF tm.yy <=0 THEN NEXT FIELD yy END IF

      AFTER FIELD mm1
         IF tm.mm1 <=0 OR tm.mm1 > 13 THEN NEXT FIELD mm1 END IF
         IF NOT cl_null(tm.mm1) AND NOT cl_null(tm.mm2) THEN
            IF tm.mm1 > tm.mm2 THEN
               NEXT FIELD mm2
            END IF
         END IF

      AFTER FIELD mm2
         IF tm.mm2 <=0 OR tm.mm2 > 13 THEN NEXT FIELD mm2 END IF
         IF NOT cl_null(tm.mm1) AND NOT cl_null(tm.mm2) THEN
            IF tm.mm1 > tm.mm2 THEN
               NEXT FIELD mm1
            END IF
         END IF

      AFTER FIELD a
         #IF tm.a NOT MATCHES "[123456789]" AND tm.a <> "10" AND tm.a <> "11" THEN  #MOD-C50145  mark
         IF tm.a NOT MATCHES "[123456789]" AND tm.a <> "10" AND tm.a <> "99" THEN   #MOD-C50145
            NEXT FIELD a
         END IF

      #FUN-D40044--add--str---
        ON CHANGE i
           IF tm.i NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD i
           END IF
        #FUN-D40044--add--end---
  #FUN-C80102-----add---end----

      AFTER FIELD o
         IF NOT cl_null(tm.o) THEN
            CALL s_check_bookno(tm.o,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD o
            END IF

            SELECT * FROM aaa_file WHERE aaa01 = tm.o
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0)
               NEXT FIELD o
            END IF
         END IF

   END INPUT
   #No.FUN-B20010  --End

   CONSTRUCT BY NAME tm.wc1 ON aag01

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
#No.FUN-B20010  --Mark Begin
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(aag01)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = 'c'
#               LET g_qryparam.form = 'q_aag'
#               LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"   #FUN-B20010 add
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aag01
#               NEXT FIELD aag01
#         END CASE

#      ON ACTION locale
#         CALL cl_show_fld_cont()
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
#
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION help
#         CALL cl_show_help()
#
#      ON ACTION controlg
#         CALL cl_cmdask()
#
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
#
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#No.FUN-B20010  --Mark End
   END CONSTRUCT
#No.FUN-B20010  --Mark Begin
#   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
#
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
#
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW gglq706_w1
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
#No.FUN-B20010  --Mark End
   CONSTRUCT BY NAME tm.wc2 ON aed02

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
#No.FUN-B20010  --Mark Begin
     #No.MOD-940157--begin--
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(aed02)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = 'c'
#               LET g_qryparam.form = 'q_aee1'
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aed02
#               NEXT FIELD aed02
#         END CASE
#     #No.MOD-940157---end---

#      ON ACTION locale
#         CALL cl_show_fld_cont()
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
#
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION help
#         CALL cl_show_help()
#
#      ON ACTION controlg
#         CALL cl_cmdask()
#
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
#
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#No.FUN-B20010  --Mark End
   END CONSTRUCT

#No.FUN-B20010  --Mark Begin
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
#
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW gglq706_w1
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
#No.FUN-B20010  --Mark End

   #INPUT BY NAME tm.yy,tm.mm1,tm.mm2,tm.o,tm.a,tm.b,tm.more WITHOUT DEFAULTS #FUN-B20010 mark
  #FUN-C80102---mark---str---
  #INPUT BY NAME tm.yy,tm.mm1,tm.mm2,tm.a,tm.b,tm.more ATTRIBUTE(WITHOUT DEFAULTS) #FUN-B20010 去掉tm.o
  #
  #
  #   BEFORE INPUT
  #      CALL cl_qbe_display_condition(lc_qbe_sn)
  #
  #   AFTER FIELD yy
  #      IF tm.yy <=0 THEN NEXT FIELD yy END IF
  #
  #   AFTER FIELD mm1
  #      IF tm.mm1 <=0 OR tm.mm1 > 13 THEN NEXT FIELD mm1 END IF
  #      IF NOT cl_null(tm.mm1) AND NOT cl_null(tm.mm2) THEN
  #         IF tm.mm1 > tm.mm2 THEN
  #            NEXT FIELD mm2
  #         END IF
  #      END IF
  #
  #   AFTER FIELD mm2
  #      IF tm.mm2 <=0 OR tm.mm2 > 13 THEN NEXT FIELD mm2 END IF
  #      IF NOT cl_null(tm.mm1) AND NOT cl_null(tm.mm2) THEN
  #         IF tm.mm1 > tm.mm2 THEN
  #            NEXT FIELD mm1
  #         END IF
  #      END IF
  #FUN-C80102----mark---end---

     #No.FUN-B20010  --Begin
     #AFTER FIELD o
     #   IF NOT cl_null(tm.o) THEN
     #      CALL s_check_bookno(tm.o,g_user,g_plant)
     #           RETURNING li_chk_bookno
     #      IF (NOT li_chk_bookno) THEN
     #         NEXT FIELD o
     #      END IF
     #
     #      SELECT * FROM aaa_file WHERE aaa01 = tm.o
     #      IF SQLCA.sqlcode THEN
     #         CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0)
     #         NEXT FIELD o
     #      END IF
     #   END IF
     #No.FUN-B20010  --End

     #FUN-C80102----mark----str---
     #AFTER FIELD a
     #   IF tm.a NOT MATCHES "[123456789]" AND tm.a <> "10" AND tm.a <> "11" THEN
     #      NEXT FIELD a
     #   END IF
     #
     #AFTER FIELD more
     #   IF tm.more = 'Y'
     #      THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
     #                          g_bgjob,g_time,g_prtway,g_copies)
     #                RETURNING g_pdate,g_towhom,g_rlang,
     #                          g_bgjob,g_time,g_prtway,g_copies
     #   END IF
     #FUN-C80102----mark----end---
#No.FUN-B20010  --Mark Begin
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(o)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_aaa'
#              CALL cl_create_qry() RETURNING tm.o
#              DISPLAY BY NAME tm.o
#              NEXT FIELD o
#        END CASE
#
#      ON ACTION CONTROLZ
#         CALL cl_show_req_fields()
#
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION help
#         CALL cl_show_help()
#
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
#
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#No.FUN-B20010  --Mark End
  #END INPUT     #FUN-C80102 mark
   #No.FUN-B20010  --Begin
   ON ACTION CONTROLP
         CASE
            WHEN INFIELD(o)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               CALL cl_create_qry() RETURNING tm.o
               DISPLAY BY NAME tm.o
               NEXT FIELD o
            WHEN INFIELD(aag01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = 'q_aag'
               LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"   #FUN-B20010 add
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aag01
               NEXT FIELD aag01
            WHEN INFIELD(aed02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = 'q_aee1'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aed02
               NEXT FIELD aed02
            OTHERWISE EXIT CASE
         END CASE
    ON ACTION locale
        CALL cl_show_fld_cont()
        LET g_action_choice = "locale"
        EXIT DIALOG
     ON ACTION CONTROLZ
        CALL cl_show_req_fields()

     ON ACTION CONTROLG
        CALL cl_cmdask()

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG

     ON ACTION about
        CALL cl_about()

     ON ACTION help
        CALL cl_show_help()

     ON ACTION exit
        LET INT_FLAG = 1
        EXIT DIALOG

     ON ACTION accept
        EXIT DIALOG

     ON ACTION cancel
        LET INT_FLAG=1
        EXIT DIALOG
   END DIALOG
   IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN         #TQC-C80025  add
     #CLOSE WINDOW gglq706_w1      #FUN-C80102 mark
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time
     #EXIT PROGRAM  #TQC-C80025  mark
   END IF
   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
  #FUN-C80102----mark---str---
  ##No.FUN-B20010  --End
  #IF g_bgjob = 'Y' THEN
  #   SELECT zz08 INTO l_cmd FROM zz_file
  #          WHERE zz01='gglq706'
  #   IF SQLCA.sqlcode OR l_cmd IS NULL THEN
  #      CALL cl_err('gglq706','9031',1)
  #   ELSE
  #      LET tm.wc1=cl_replace_str(tm.wc1, "'", "\"")
  #      LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
  #      LET l_cmd = l_cmd CLIPPED,
  #                      " '",g_pdate    CLIPPED,"'",
  #                      " '",g_towhom   CLIPPED,"'",
  #                      " '",g_rlang    CLIPPED,"'",
  #                      " '",g_bgjob    CLIPPED,"'",
  #                      " '",g_prtway   CLIPPED,"'",
  #                      " '",g_copies   CLIPPED,"'",
  #                      " '",tm.wc1     CLIPPED,"'",
  #                      " '",tm.wc2     CLIPPED,"'",
  #                      " '",tm.yy      CLIPPED,"'",
  #                      " '",tm.mm1     CLIPPED,"'",
  #                      " '",tm.mm2     CLIPPED,"'",
  #                      " '",tm.o       CLIPPED,"'",
  #                      " '",tm.a       CLIPPED,"'",
  #                      " '",tm.b       CLIPPED,"'",
  #                      " '",g_rep_user CLIPPED,"'",
  #                      " '",g_rep_clas CLIPPED,"'",
  #                      " '",g_template CLIPPED,"'",
  #                      " '",g_rpt_name CLIPPED,"'"
  #      CALL cl_cmdat('gglq706',g_time,l_cmd)
  #   END IF
  #   CLOSE WINDOW gglq706_w1
  #   CALL cl_used(g_prog,g_time,2) RETURNING g_time
  #   EXIT PROGRAM
  #END IF
  #FUN-C80102----mark---end---
   CALL cl_wait()
   CALL gglq706()
   ERROR ""
   EXIT WHILE
END WHILE
 # CLOSE WINDOW gglq706_w1    #FUN-C80102 mark

   LET g_mm = NULL
   #設置title & 隱藏沒有資料的核算項column
   FOR g_i = 1 TO 50
       LET g_field = "d",g_i USING "&<"
       CALL cl_getmsg("ggl-227",g_lang) RETURNING g_msg1
       CALL cl_getmsg("ggl-226",g_lang) RETURNING g_msg2
       LET g_msg = g_msg1 CLIPPED,g_i USING "&<",g_msg2 CLIPPED
       CALL cl_set_comp_att_text(g_field,g_msg)
   END FOR
   CALL cl_set_comp_visible("d01,d02,d03,d04,d05,d06,d07,d08,d09,d10",TRUE)
   CALL cl_set_comp_visible("d11,d12,d13,d14,d15,d16,d17,d18,d19,d20",TRUE)
   CALL cl_set_comp_visible("d21,d22,d23,d24,d25,d26,d27,d28,d29,d30",TRUE)
   CALL cl_set_comp_visible("d31,d32,d33,d34,d35,d36,d37,d38,d39,d40",TRUE)
   CALL cl_set_comp_visible("d41,d42,d43,d44,d45,d46,d47,d48,d49,d50",TRUE)

   CLEAR FORM
   CALL g_aed.clear()
   CALL gglq706_cs()
END FUNCTION

FUNCTION gglq706()
   DEFINE #l_sql        LIKE type_file.chr1000,
          l_sql        STRING ,     #NO.FUN-910082
          l_flag       LIKE type_file.chr1,
          l_i          LIKE type_file.num5,
          l_cnt        LIKE type_file.num5,
          #l_wc1        LIKE type_file.chr1000,
          #l_wc2        LIKE type_file.chr1000,
          l_wc1         STRING,       #NO.FUN-910082
          l_wc2         STRING,       #NO.FUN-910082
          l_aed02      LIKE aed_file.aed02,
          l_aed02_d    LIKE ze_file.ze03,
          l_aag01      LIKE aag_file.aag01,
          t_aag01      LIKE aag_file.aag01,
          l_aag01_str  LIKE type_file.chr50,
          l_aag02      LIKE aag_file.aag02,
          l_aag06      LIKE aag_file.aag06,
          l_aed05      LIKE aed_file.aed05,
          l_aed06      LIKE aed_file.aed06,
          l_aed051     LIKE aed_file.aed05,
          l_aed061     LIKE aed_file.aed06,
          l_abb07      LIKE abb_file.abb07,  #CHI-C70031
          l_abb071     LIKE abb_file.abb07,  #CHI-C70031
          l_sum        LIKE aed_file.aed05,
          l_sum_a      DYNAMIC ARRAY OF LIKE aed_file.aed05,
          l_ahe02_d    LIKE ze_file.ze03,
          l_field      LIKE gaq_file.gaq01,
          l_gaq01      LIKE gaq_file.gaq01
   ###TQC-9C0179 START ###
   DEFINE l_aag02_1  LIKE aag_file.aag02
   DEFINE l_aed02_d1 LIKE ze_file.ze03
   ###TQC-9C0179 END ###

     LET g_prog = "gglq706"

     CASE tm.a
          WHEN '1'   LET l_field = 'abb11'
                     LET l_gaq01 = 'aag15'
                     LET g_aee02 ='1'        #No.TQC-C50211
          WHEN '2'   LET l_field = 'abb12'
                     LET l_gaq01 = 'aag16'
                     LET g_aee02 ='2'        #No.TQC-C50211
          WHEN '3'   LET l_field = 'abb13'
                     LET l_gaq01 = 'aag17'
                     LET g_aee02 ='3'        #No.TQC-C50211
          WHEN '4'   LET l_field = 'abb14'
                     LET l_gaq01 = 'aag18'
                     LET g_aee02 ='4'        #No.TQC-C50211
          WHEN '5'   LET l_field = 'abb31'
                     LET l_gaq01 = 'aag31'
                     LET g_aee02 ='5'        #No.TQC-C50211
          WHEN '6'   LET l_field = 'abb32'
                     LET l_gaq01 = 'aag32'
                     LET g_aee02 ='6'        #No.TQC-C50211
          WHEN '7'   LET l_field = 'abb33'
                     LET l_gaq01 = 'aag33'
                     LET g_aee02 ='7'        #No.TQC-C50211
          WHEN '8'   LET l_field = 'abb34'
                     LET l_gaq01 = 'aag34'
                     LET g_aee02 ='8'        #No.TQC-C50211
          WHEN '9'   LET l_field = 'abb35'
                     LET l_gaq01 = 'aag35'
                     LET g_aee02 ='9'        #No.TQC-C50211
          WHEN '10'  LET l_field = 'abb36'
                     LET l_gaq01 = 'aag36'
                     LET g_aee02 ='10'        #No.TQC-C50211
          #WHEN '11'  LET l_field = 'abb37'    #MOD-C50145 mark
          WHEN '99'  LET l_field = 'abb37'     #MOD-C50145
                     LET l_gaq01 = 'aag37'
                     LET g_aee02 ='99'        #No.TQC-C50211
     END CASE
    #CHI-C70031--mark--str--luttb
    #IF tm.b = 'N' THEN
    #   LET l_field = NULL
    #END IF
    #CHI-C70031--mark--end

     CALL gglq706_table()
     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang

     #loop 科目
     LET l_sql = " SELECT aag01,aag02,aag06 FROM aag_file",
                 "  WHERE aag00 = '",tm.o,"'",
                 "    AND ",tm.wc1
     PREPARE gglq706_aag01_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq706_aag01_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq706_aag01_cs CURSOR FOR gglq706_aag01_p

     #查找核算項值
     LET l_sql = " SELECT ",l_gaq01 CLIPPED," FROM aag_file ",
                 "  WHERE aag00 = '",tm.o,"'",
                 "    AND aag01 LIKE ? ",
                 "    AND aag07 IN ('2','3') ",
                 "    AND ",l_gaq01 CLIPPED," IS NOT NULL"
     PREPARE gglq706_gaq01_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq706_gaq01_cs SCROLL CURSOR FOR gglq706_gaq01_p  #只能取第一個

     #科目是否打印(1)
     LET l_sql = " SELECT COUNT(*) FROM aed_file ",
                 "  WHERE aed00  = '",tm.o,"'",
                 "    AND aed01 LIKE ? ",
                 "    AND aed011 = '",tm.a,"'",
                 "    AND aed02 IS NOT NULL ",
                 "    AND aed03  =  ",tm.yy,
                 "    AND aed04  = ?",
                 "    AND ",tm.wc2 CLIPPED
     PREPARE gglq706_aed01_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq706_aed01_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq706_aed01_cs1 CURSOR FOR gglq706_aed01_p1

     #科目是否打印(2)
     #tm.b = 'Y' unposted!
     LET l_wc2=cl_replace_str(tm.wc2,'aed02',l_field)
     LET l_sql = " SELECT COUNT(*) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND abb00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND aba04 = ?",
                 "    AND abb03 LIKE ? ",
                 "    AND ",l_field CLIPPED," IS NOT NULL ",
                 "    AND ",l_field CLIPPED," <> ' ' ",
                 "    AND ",l_wc2 CLIPPED,
                 "    AND aba19 = 'Y' AND abapost = 'N' "
     PREPARE gglq706_aed01_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq706_aed01_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq706_aed01_cs2 CURSOR FOR gglq706_aed01_p2

     #動態核算項title(1)
     #已過帳
     LET l_sql = " SELECT UNIQUE aed02 FROM aed_file ",
                 "  WHERE aed00  = '",tm.o,"'",
                 "    AND aed01  LIKE ? ",
                 "    AND aed011 = '",tm.a,"'",
                 "    AND aed02  IS NOT NULL ",
                 "    AND aed03  =  ",tm.yy,
                 "    AND aed04  = ?",
                 "    AND ",tm.wc2 CLIPPED,
                 "  ORDER BY aed02 "
     PREPARE gglq706_aed02_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq706_aed02_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq706_aed02_cs1 CURSOR FOR gglq706_aed02_p1

     #動態核算項title(2)
     #tm.b = 'Y' #unposted!
     LET l_sql = " SELECT UNIQUE ",l_field CLIPPED," FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND abb00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND aba04 = ?",
                 "    AND ",l_field CLIPPED," IS NOT NULL ",
                 "    AND ",l_field CLIPPED," <> ' ' ",
                 "    AND abb03 LIKE ? ",
                 "    AND ",l_wc2 CLIPPED,
                 "    AND aba19 = 'Y' AND abapost = 'N' "
     PREPARE gglq706_aed02_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq706_aed02_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq706_aed02_cs2 CURSOR FOR gglq706_aed02_p2

     #異動值(1) 已過帳
     LET l_sql =" SELECT SUM(aed05),SUM(aed06) FROM aed_file",
                "  WHERE aed00  = '",tm.o,"'",
                "    AND aed01 LIKE ? ",
                "    AND aed011 = '",tm.a,"'",
                "    AND aed02  = ? ",
                "    AND aed03  =   ",tm.yy,
                "    AND aed04  = ? "

     PREPARE gglq706_aed05_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq706_aed05_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq706_aed05_cs CURSOR FOR gglq706_aed05_p

     #異動值(2) 未過帳 tm.b = 'Y'
     LET l_sql = " SELECT SUM(abb07) FROM aba_file,abb_file",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND aba04 = ?",
                 "    AND abb03 LIKE ?",
                 "    AND ",l_field CLIPPED," = ? ",
                 "    AND abb06 = ?",
                 "    AND aba19 = 'Y' AND abapost = 'N'"
     PREPARE gglq706_abb07_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq706_abb07_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq706_abb07_cs CURSOR FOR gglq706_abb07_p

     DECLARE gglq706_aed02_cs CURSOR FOR SELECT aed02,aed02_d FROM gglq706_aed02
      ORDER BY aed02

     DECLARE gglq706_aed01_cs CURSOR FOR SELECT aed01 FROM gglq706_aed01
      ORDER BY aed01

     #No.CHI-C70031  --Begin
     LET l_sql = " SELECT SUM(abb07) FROM aba_file,abb_file",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND (aba06 = 'CE' OR (aba06 = 'CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL AND cdb01 = ",tm.yy,
                 "    AND cdb02 = ?)))",
                 "    AND aba04 = ?",
                 "    AND abb03 LIKE ?",
                 "    AND ",l_field CLIPPED," = ? ",
                 "    AND abb06 = ?",
                 "    AND aba19 = 'Y' AND abapost = 'Y'"
     PREPARE gglq706_abb07_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq706_abb07_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq706_abb07_cs1 CURSOR FOR gglq706_abb07_p1

     #No.CHI-C70031  --End
     #月loop
     FOR g_i = tm.mm1 TO tm.mm2
         #aed list
         DELETE FROM gglq706_aed02;
         #account list
         DELETE FROM gglq706_aed01;

         #確定當前月要打印的核算項名稱和科目值
         FOREACH gglq706_aag01_cs INTO t_aag01,l_aag02,l_aag06
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq706_aag01_cs:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            LET l_aag01_str = t_aag01 CLIPPED,"%"
            #核算項aed_file
            FOREACH gglq706_aed02_cs1 USING l_aag01_str,g_i INTO l_aed02
               IF SQLCA.sqlcode THEN
                  CALL cl_err('foreach gglq706_aed02_cs1:',SQLCA.sqlcode,0) EXIT FOREACH
               END IF
               IF cl_null(l_aed02) THEN CONTINUE FOREACH END IF
               #取核算項名稱
#               CALL gglq706_get_ahe02(l_aag01_str,l_aed02)
               CALL gglq706_get_ahe02(t_aag01,l_aed02)   #No.TQC-C50211
                    RETURNING l_ahe02_d
               INSERT INTO gglq706_aed02 VALUES(l_aed02,l_ahe02_d)
            END FOREACH
            #核算項abb_file
            IF tm.b = 'Y' THEN
               FOREACH gglq706_aed02_cs2 USING g_i,l_aag01_str INTO l_aed02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach gglq706_aed02_cs2:',SQLCA.sqlcode,0) EXIT FOREACH
                  END IF
                  IF cl_null(l_aed02) THEN CONTINUE FOREACH END IF
#               CALL gglq706_get_ahe02(l_aag01_str,l_aed02)
               CALL gglq706_get_ahe02(t_aag01,l_aed02)   #No.TQC-C50211
                       RETURNING l_ahe02_d
                  INSERT INTO gglq706_aed02 VALUES(l_aed02,l_ahe02_d)
               END FOREACH
            END IF

            #科目aed_file
            LET l_cnt = 0
            OPEN gglq706_aed01_cs1 USING l_aag01_str,g_i
            FETCH gglq706_aed01_cs1 INTO l_cnt
            CLOSE gglq706_aed01_cs1
            IF l_cnt > 0 THEN
               INSERT INTO gglq706_aed01 VALUES(t_aag01);
            END IF
            #科目abb_file
            IF tm.b = 'Y' THEN
               LET l_cnt = 0
               OPEN gglq706_aed01_cs2 USING g_i,l_aag01_str
               FETCH gglq706_aed01_cs2 INTO l_cnt
               CLOSE gglq706_aed01_cs2
               IF l_cnt > 0 THEN
                  INSERT INTO gglq706_aed01 VALUES(t_aag01);
               END IF
            END IF
         END FOREACH

         LET l_i = 1
         CALL g_aed_d.clear()
         #當前月份的核算項明細
         FOREACH gglq706_aed02_cs INTO l_aed02,l_aed02_d
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq706_aed02_cs:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            LET g_aed_d[l_i].aed02   = l_aed02
            LET g_aed_d[l_i].aed02_d = l_aed02_d
            LET l_i = l_i + 1
         END FOREACH
         LET l_cnt = l_i - 1

         #每個月的核算項title
         INSERT INTO gglq706_title VALUES(g_i,g_aed_d[01].aed02_d,
            g_aed_d[02].aed02_d, g_aed_d[03].aed02_d, g_aed_d[04].aed02_d,
            g_aed_d[05].aed02_d, g_aed_d[06].aed02_d, g_aed_d[07].aed02_d,
            g_aed_d[08].aed02_d, g_aed_d[09].aed02_d, g_aed_d[10].aed02_d,
            g_aed_d[11].aed02_d, g_aed_d[12].aed02_d, g_aed_d[13].aed02_d,
            g_aed_d[14].aed02_d, g_aed_d[15].aed02_d, g_aed_d[16].aed02_d,
            g_aed_d[17].aed02_d, g_aed_d[18].aed02_d, g_aed_d[19].aed02_d,
            g_aed_d[20].aed02_d, g_aed_d[21].aed02_d, g_aed_d[22].aed02_d,
            g_aed_d[23].aed02_d, g_aed_d[24].aed02_d, g_aed_d[25].aed02_d,
            g_aed_d[26].aed02_d, g_aed_d[27].aed02_d, g_aed_d[28].aed02_d,
            g_aed_d[29].aed02_d, g_aed_d[30].aed02_d, g_aed_d[31].aed02_d,
            g_aed_d[32].aed02_d, g_aed_d[33].aed02_d, g_aed_d[34].aed02_d,
            g_aed_d[35].aed02_d, g_aed_d[36].aed02_d, g_aed_d[37].aed02_d,
            g_aed_d[38].aed02_d, g_aed_d[39].aed02_d, g_aed_d[40].aed02_d,
            g_aed_d[41].aed02_d, g_aed_d[42].aed02_d, g_aed_d[43].aed02_d,
            g_aed_d[44].aed02_d, g_aed_d[45].aed02_d, g_aed_d[46].aed02_d,
            g_aed_d[47].aed02_d, g_aed_d[48].aed02_d, g_aed_d[49].aed02_d,
            g_aed_d[50].aed02_d);

         #當前月份，當前科目下各核算項值的異動金額
         FOREACH gglq706_aed01_cs INTO l_aag01
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq706_aed01_cs:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file
             WHERE aag00 = tm.o
               AND aag01 = l_aag01
            LET l_aag01_str = l_aag01 CLIPPED,'\%'    #No.MOD-940388

            CALL l_sum_a.clear()
            #loop當前月下的核算項值
            FOR l_i = 1 TO l_cnt
                LET l_aed05  = 0   LET l_aed06  = 0
                LET l_aed051 = 0   LET l_aed061 = 0
                LET l_abb07 = 0    LET l_abb071 = 0         #No.CHI-C70031
                #異動值(aed_file)
                OPEN gglq706_aed05_cs USING l_aag01_str,g_aed_d[l_i].aed02,g_i
                FETCH gglq706_aed05_cs INTO l_aed05,l_aed06
                CLOSE gglq706_aed05_cs
                IF cl_null(l_aed05) THEN LET l_aed05 = 0 END IF
                IF cl_null(l_aed06) THEN LET l_aed06 = 0 END IF
                #異動值(abb_file)
                IF tm.b = 'Y' THEN
                   OPEN gglq706_abb07_cs USING g_i,l_aag01_str,
                                               g_aed_d[l_i].aed02,'1'
                   FETCH gglq706_abb07_cs INTO l_aed051
                   CLOSE gglq706_abb07_cs
                   IF cl_null(l_aed051) THEN LET l_aed051 = 0 END IF
                   OPEN gglq706_abb07_cs USING g_i,l_aag01_str,
                                               g_aed_d[l_i].aed02,'2'
                   FETCH gglq706_abb07_cs INTO l_aed061
                   CLOSE gglq706_abb07_cs
                   IF cl_null(l_aed061) THEN LET l_aed061 = 0 END IF
                END IF
                #No.CHI-C70031  --Begin
                OPEN gglq706_abb07_cs1 USING g_i,g_i,l_aag01_str,
                                               g_aed_d[l_i].aed02,'1'
                FETCH gglq706_abb07_cs1 INTO l_abb07
                CLOSE gglq706_abb07_cs1
                IF cl_null(l_abb07) THEN LET l_abb07 = 0 END IF
                OPEN gglq706_abb07_cs1 USING g_i,g_i,l_aag01_str,
                                               g_aed_d[l_i].aed02,'2'
                FETCH gglq706_abb07_cs1 INTO l_abb071
                CLOSE gglq706_abb07_cs1
                IF cl_null(l_abb071) THEN LET l_abb071 = 0 END IF
                #No.CHI-C70031  --End
                #當前月-當前科目-當前核算項的發生額
                IF tm.i = 'N' THEN    #FUN-D40044 add
                   LET l_sum = l_aed05 - l_aed06 + l_aed051 - l_aed061 - l_abb07 + l_abb071  #CHI-C70031 add abb07,abb071
                #FUN-D40044--add--str--
                ELSE
                   LET l_sum = l_aed05 - l_aed06 + l_aed051 - l_aed061
                END IF 
                #FUN-D40044--add--end--
                IF l_aag06 = '2' THEN
                   LET l_sum = l_sum * -1
                END IF
                LET l_sum_a[l_i] = l_sum
                #FOR CR print
                #EXECUTE insert_prep USING g_i,l_aag01,l_aag02[1,30],i     #TQC-9C0179 mark
                #                         g_aed_d[l_i].aed02_d[1,30],l_sum #TQC-9C0179 mark
                ###TQC-9C0179 START ###
                LET l_aag02_1 = l_aag02[1,30]
                LET l_aed02_d1 = g_aed_d[l_i].aed02_d[1,30]

                EXECUTE insert_prep USING g_i,l_aag01,l_aag02_1,
                                          l_aed02_d1,l_sum
                ###TQC-9C0179 END ###
            END FOR
            #當前月-當前科目-所有核算項的異動值(最多有50項)
            INSERT INTO gglq706_tmp VALUES(g_i, l_aag01, l_aag02,l_aed02,   #FUN-C80102 add l_aed02
                l_sum_a[01], l_sum_a[02], l_sum_a[03], l_sum_a[04],
                l_sum_a[05], l_sum_a[06], l_sum_a[07], l_sum_a[08],
                l_sum_a[09], l_sum_a[10], l_sum_a[11], l_sum_a[12],
                l_sum_a[13], l_sum_a[14], l_sum_a[15], l_sum_a[16],
                l_sum_a[17], l_sum_a[18], l_sum_a[19], l_sum_a[20],
                l_sum_a[21], l_sum_a[22], l_sum_a[23], l_sum_a[24],
                l_sum_a[25], l_sum_a[26], l_sum_a[27], l_sum_a[28],
                l_sum_a[29], l_sum_a[30], l_sum_a[31], l_sum_a[32],
                l_sum_a[33], l_sum_a[34], l_sum_a[35], l_sum_a[36],
                l_sum_a[37], l_sum_a[38], l_sum_a[39], l_sum_a[40],
                l_sum_a[41], l_sum_a[42], l_sum_a[43], l_sum_a[44],
                l_sum_a[45], l_sum_a[46], l_sum_a[47], l_sum_a[48],
                l_sum_a[49], l_sum_a[50]);
            
         END FOREACH
         #FUN-D40044--add--str--
         LET l_i = 1 
         FOREACH gglq706_aed01_cs INTO l_aag01
            UPDATE gglq706_tmp SET aed02 = g_aed_d[l_i].aed02
             WHERE aag01 = l_aag01
            LET l_i = l_i + 1  
         END FOREACH  
         #FUN-D40044--add--end--
     END FOR
END FUNCTION

FUNCTION q706_out_2()

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc1,'aag01')
           RETURNING g_str
   END IF
   LET g_str=g_str CLIPPED,";",tm.yy,";",g_azi04

   CALL cl_prt_cs3('gglq706','gglq706',g_sql,g_str)
END FUNCTION

FUNCTION q706_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aed TO s_aed.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION first
         CALL gglq706_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL gglq706_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL gglq706_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL gglq706_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL gglq706_fetch('L')
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

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

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

FUNCTION gglq706_cs()
     LET g_sql = "SELECT UNIQUE mm FROM gglq706_tmp ",
                 " ORDER BY mm"
     PREPARE gglq706_ps FROM g_sql
     DECLARE gglq706_curs SCROLL CURSOR WITH HOLD FOR gglq706_ps

     LET g_sql = "SELECT UNIQUE mm FROM gglq706_tmp ",
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq706_ps1 FROM g_sql
     EXECUTE gglq706_ps1

     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq706_ps2 FROM g_sql
     DECLARE gglq706_cnt CURSOR FOR gglq706_ps2

     OPEN gglq706_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq706_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq706_cnt
        FETCH gglq706_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq706_fetch('F')
     END IF
END FUNCTION

FUNCTION gglq706_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10

   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq706_curs INTO g_mm
      WHEN 'P' FETCH PREVIOUS gglq706_curs INTO g_mm
      WHEN 'F' FETCH FIRST    gglq706_curs INTO g_mm
      WHEN 'L' FETCH LAST     gglq706_curs INTO g_mm
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
         FETCH ABSOLUTE g_jump gglq706_curs INTO g_mm
         LET mi_no_ask = FALSE
   END CASE

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

   CALL gglq706_show()
END FUNCTION

FUNCTION gglq706_show()

   DISPLAY BY NAME tm.yy
#  DISPLAY g_mm TO mm    #FUN-C80102  mark
  #FUN-C80102----add---str--
   DISPLAY tm.a TO a
   DISPLAY tm.b TO b
   DISPLAY tm.o TO o
   DISPLAY tm.mm1 TO mm1
   DISPLAY tm.mm2 TO mm2
  #FUN-C80102----add---end--
  DISPLAY tm.i    TO i   #FUN-D40044 add

   CALL gglq706_b_fill()

   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION gglq706_b_fill()
  DEFINE  l_i        LIKE type_file.num5

   CALL g_aed.clear()
   SELECT t01,t02,t03,t04,t05,t06,t07,t08,t09,t10,
          t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,
          t21,t22,t23,t24,t25,t26,t27,t28,t29,t30,
          t31,t32,t33,t34,t35,t36,t37,t38,t39,t40,
          t41,t42,t43,t44,t45,t46,t47,t48,t49,t50
     INTO g_aed_d[01].aed02_d, g_aed_d[02].aed02_d, g_aed_d[03].aed02_d,
          g_aed_d[04].aed02_d, g_aed_d[05].aed02_d, g_aed_d[06].aed02_d,
          g_aed_d[07].aed02_d, g_aed_d[08].aed02_d, g_aed_d[09].aed02_d,
          g_aed_d[10].aed02_d, g_aed_d[11].aed02_d, g_aed_d[12].aed02_d,
          g_aed_d[13].aed02_d, g_aed_d[14].aed02_d, g_aed_d[15].aed02_d,
          g_aed_d[16].aed02_d, g_aed_d[17].aed02_d, g_aed_d[18].aed02_d,
          g_aed_d[19].aed02_d, g_aed_d[20].aed02_d, g_aed_d[21].aed02_d,
          g_aed_d[22].aed02_d, g_aed_d[23].aed02_d, g_aed_d[24].aed02_d,
          g_aed_d[25].aed02_d, g_aed_d[26].aed02_d, g_aed_d[27].aed02_d,
          g_aed_d[28].aed02_d, g_aed_d[29].aed02_d, g_aed_d[30].aed02_d,
          g_aed_d[31].aed02_d, g_aed_d[32].aed02_d, g_aed_d[33].aed02_d,
          g_aed_d[34].aed02_d, g_aed_d[35].aed02_d, g_aed_d[36].aed02_d,
          g_aed_d[37].aed02_d, g_aed_d[38].aed02_d, g_aed_d[39].aed02_d,
          g_aed_d[40].aed02_d, g_aed_d[41].aed02_d, g_aed_d[42].aed02_d,
          g_aed_d[43].aed02_d, g_aed_d[44].aed02_d, g_aed_d[45].aed02_d,
          g_aed_d[46].aed02_d, g_aed_d[47].aed02_d, g_aed_d[48].aed02_d,
          g_aed_d[49].aed02_d, g_aed_d[50].aed02_d
     FROM gglq706_title
    WHERE mm = g_mm

   FOR l_i = 1 TO 50
       LET g_field = "d",l_i USING "&<"
       IF NOT cl_null(g_aed_d[l_i].aed02_d) THEN
          CALL cl_set_comp_att_text(g_field,g_aed_d[l_i].aed02_d)
          CALL cl_set_comp_visible(g_field,TRUE)
       ELSE
          CALL cl_set_comp_visible(g_field,FALSE)
       END IF
   END FOR

   LET g_sql = "SELECT aag01,aag02,aed02,d01,d02,d03,d04,d05,d06,d07,d08,d09,d10,",   #FUN-C80201 add aed02
               "                   d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,",
               "                   d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,",
               "                   d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,",
               "                   d41,d42,d43,d44,d45,d46,d47,d48,d49,d50 ",
               "  FROM gglq706_tmp",
               " WHERE mm  = ",g_mm,
               " ORDER BY aag01 "

   PREPARE gglq706_pb FROM g_sql
   DECLARE npq_curs  CURSOR FOR gglq706_pb

   CALL g_aed.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH npq_curs INTO g_aed[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_aed[g_cnt].d01 = cl_numfor(g_aed[g_cnt].d01,20,g_azi04)
      LET g_aed[g_cnt].d02 = cl_numfor(g_aed[g_cnt].d02,20,g_azi04)
      LET g_aed[g_cnt].d03 = cl_numfor(g_aed[g_cnt].d03,20,g_azi04)
      LET g_aed[g_cnt].d04 = cl_numfor(g_aed[g_cnt].d04,20,g_azi04)
      LET g_aed[g_cnt].d05 = cl_numfor(g_aed[g_cnt].d05,20,g_azi04)
      LET g_aed[g_cnt].d06 = cl_numfor(g_aed[g_cnt].d06,20,g_azi04)
      LET g_aed[g_cnt].d07 = cl_numfor(g_aed[g_cnt].d07,20,g_azi04)
      LET g_aed[g_cnt].d08 = cl_numfor(g_aed[g_cnt].d08,20,g_azi04)
      LET g_aed[g_cnt].d09 = cl_numfor(g_aed[g_cnt].d09,20,g_azi04)
      LET g_aed[g_cnt].d10 = cl_numfor(g_aed[g_cnt].d10,20,g_azi04)
      LET g_aed[g_cnt].d11 = cl_numfor(g_aed[g_cnt].d11,20,g_azi04)
      LET g_aed[g_cnt].d12 = cl_numfor(g_aed[g_cnt].d12,20,g_azi04)
      LET g_aed[g_cnt].d13 = cl_numfor(g_aed[g_cnt].d13,20,g_azi04)
      LET g_aed[g_cnt].d14 = cl_numfor(g_aed[g_cnt].d14,20,g_azi04)
      LET g_aed[g_cnt].d15 = cl_numfor(g_aed[g_cnt].d15,20,g_azi04)
      LET g_aed[g_cnt].d16 = cl_numfor(g_aed[g_cnt].d16,20,g_azi04)
      LET g_aed[g_cnt].d17 = cl_numfor(g_aed[g_cnt].d17,20,g_azi04)
      LET g_aed[g_cnt].d18 = cl_numfor(g_aed[g_cnt].d18,20,g_azi04)
      LET g_aed[g_cnt].d19 = cl_numfor(g_aed[g_cnt].d19,20,g_azi04)
      LET g_aed[g_cnt].d20 = cl_numfor(g_aed[g_cnt].d20,20,g_azi04)
      LET g_aed[g_cnt].d21 = cl_numfor(g_aed[g_cnt].d21,20,g_azi04)
      LET g_aed[g_cnt].d22 = cl_numfor(g_aed[g_cnt].d22,20,g_azi04)
      LET g_aed[g_cnt].d23 = cl_numfor(g_aed[g_cnt].d23,20,g_azi04)
      LET g_aed[g_cnt].d24 = cl_numfor(g_aed[g_cnt].d24,20,g_azi04)
      LET g_aed[g_cnt].d25 = cl_numfor(g_aed[g_cnt].d25,20,g_azi04)
      LET g_aed[g_cnt].d26 = cl_numfor(g_aed[g_cnt].d26,20,g_azi04)
      LET g_aed[g_cnt].d27 = cl_numfor(g_aed[g_cnt].d27,20,g_azi04)
      LET g_aed[g_cnt].d28 = cl_numfor(g_aed[g_cnt].d28,20,g_azi04)
      LET g_aed[g_cnt].d29 = cl_numfor(g_aed[g_cnt].d29,20,g_azi04)
      LET g_aed[g_cnt].d30 = cl_numfor(g_aed[g_cnt].d30,20,g_azi04)
      LET g_aed[g_cnt].d31 = cl_numfor(g_aed[g_cnt].d31,20,g_azi04)
      LET g_aed[g_cnt].d32 = cl_numfor(g_aed[g_cnt].d32,20,g_azi04)
      LET g_aed[g_cnt].d33 = cl_numfor(g_aed[g_cnt].d33,20,g_azi04)
      LET g_aed[g_cnt].d34 = cl_numfor(g_aed[g_cnt].d34,20,g_azi04)
      LET g_aed[g_cnt].d35 = cl_numfor(g_aed[g_cnt].d35,20,g_azi04)
      LET g_aed[g_cnt].d36 = cl_numfor(g_aed[g_cnt].d36,20,g_azi04)
      LET g_aed[g_cnt].d37 = cl_numfor(g_aed[g_cnt].d37,20,g_azi04)
      LET g_aed[g_cnt].d38 = cl_numfor(g_aed[g_cnt].d38,20,g_azi04)
      LET g_aed[g_cnt].d39 = cl_numfor(g_aed[g_cnt].d39,20,g_azi04)
      LET g_aed[g_cnt].d40 = cl_numfor(g_aed[g_cnt].d40,20,g_azi04)
      LET g_aed[g_cnt].d41 = cl_numfor(g_aed[g_cnt].d41,20,g_azi04)
      LET g_aed[g_cnt].d42 = cl_numfor(g_aed[g_cnt].d42,20,g_azi04)
      LET g_aed[g_cnt].d43 = cl_numfor(g_aed[g_cnt].d43,20,g_azi04)
      LET g_aed[g_cnt].d44 = cl_numfor(g_aed[g_cnt].d44,20,g_azi04)
      LET g_aed[g_cnt].d45 = cl_numfor(g_aed[g_cnt].d45,20,g_azi04)
      LET g_aed[g_cnt].d46 = cl_numfor(g_aed[g_cnt].d46,20,g_azi04)
      LET g_aed[g_cnt].d47 = cl_numfor(g_aed[g_cnt].d47,20,g_azi04)
      LET g_aed[g_cnt].d48 = cl_numfor(g_aed[g_cnt].d48,20,g_azi04)
      LET g_aed[g_cnt].d49 = cl_numfor(g_aed[g_cnt].d49,20,g_azi04)
      LET g_aed[g_cnt].d50 = cl_numfor(g_aed[g_cnt].d50,20,g_azi04)

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      EXIT FOREACH
      END IF
   END FOREACH

   CALL g_aed.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1

END FUNCTION

FUNCTION gglq706_table()
     DROP TABLE gglq706_aed02;
     CREATE TEMP TABLE gglq706_aed02(
                    aed02       LIKE aed_file.aed02,
                    aed02_d     LIKE ze_file.ze03);
     #CREATE UNIQUE INDEX gglq706_aed02_01 ON gglq706_aed02(aed02);          #FUN-D40044  mark
     CREATE UNIQUE INDEX gglq706_aed02_01 ON gglq706_aed02(aed02,aed02_d);   #FUN-D40044  add

     DROP TABLE gglq706_aed01;
     CREATE TEMP TABLE gglq706_aed01(
                    aed01       LIKE aed_file.aed01);
     CREATE UNIQUE INDEX gglq706_aed01_01 ON gglq706_aed01(aed01);

     DROP TABLE gglq706_title;
     CREATE TEMP TABLE gglq706_title(
                    mm          LIKE type_file.num5,
                    t01         LIKE ze_file.ze03,
                    t02         LIKE ze_file.ze03,
                    t03         LIKE ze_file.ze03,
                    t04         LIKE ze_file.ze03,
                    t05         LIKE ze_file.ze03,
                    t06         LIKE ze_file.ze03,
                    t07         LIKE ze_file.ze03,
                    t08         LIKE ze_file.ze03,
                    t09         LIKE ze_file.ze03,
                    t10         LIKE ze_file.ze03,
                    t11         LIKE ze_file.ze03,
                    t12         LIKE ze_file.ze03,
                    t13         LIKE ze_file.ze03,
                    t14         LIKE ze_file.ze03,
                    t15         LIKE ze_file.ze03,
                    t16         LIKE ze_file.ze03,
                    t17         LIKE ze_file.ze03,
                    t18         LIKE ze_file.ze03,
                    t19         LIKE ze_file.ze03,
                    t20         LIKE ze_file.ze03,
                    t21         LIKE ze_file.ze03,
                    t22         LIKE ze_file.ze03,
                    t23         LIKE ze_file.ze03,
                    t24         LIKE ze_file.ze03,
                    t25         LIKE ze_file.ze03,
                    t26         LIKE ze_file.ze03,
                    t27         LIKE ze_file.ze03,
                    t28         LIKE ze_file.ze03,
                    t29         LIKE ze_file.ze03,
                    t30         LIKE ze_file.ze03,
                    t31         LIKE ze_file.ze03,
                    t32         LIKE ze_file.ze03,
                    t33         LIKE ze_file.ze03,
                    t34         LIKE ze_file.ze03,
                    t35         LIKE ze_file.ze03,
                    t36         LIKE ze_file.ze03,
                    t37         LIKE ze_file.ze03,
                    t38         LIKE ze_file.ze03,
                    t39         LIKE ze_file.ze03,
                    t40         LIKE ze_file.ze03,
                    t41         LIKE ze_file.ze03,
                    t42         LIKE ze_file.ze03,
                    t43         LIKE ze_file.ze03,
                    t44         LIKE ze_file.ze03,
                    t45         LIKE ze_file.ze03,
                    t46         LIKE ze_file.ze03,
                    t47         LIKE ze_file.ze03,
                    t48         LIKE ze_file.ze03,
                    t49         LIKE ze_file.ze03,
                    t50         LIKE ze_file.ze03);
     DROP TABLE gglq706_tmp;
     CREATE TEMP TABLE gglq706_tmp(
                    mm          LIKE type_file.num5,
                    aag01       LIKE aag_file.aag01,
#                   aag02       LIKE aag_file.aag02,
                    aag02       LIKE type_file.chr1000,      #No.MOD-940388
                    aed02       LIKE aed_file.aed02,      #FUN-C80102 add
                    d01         LIKE aed_file.aed05,
                    d02         LIKE aed_file.aed05,
                    d03         LIKE aed_file.aed05,
                    d04         LIKE aed_file.aed05,
                    d05         LIKE aed_file.aed05,
                    d06         LIKE aed_file.aed05,
                    d07         LIKE aed_file.aed05,
                    d08         LIKE aed_file.aed05,
                    d09         LIKE aed_file.aed05,
                    d10         LIKE aed_file.aed05,
                    d11         LIKE aed_file.aed05,
                    d12         LIKE aed_file.aed05,
                    d13         LIKE aed_file.aed05,
                    d14         LIKE aed_file.aed05,
                    d15         LIKE aed_file.aed05,
                    d16         LIKE aed_file.aed05,
                    d17         LIKE aed_file.aed05,
                    d18         LIKE aed_file.aed05,
                    d19         LIKE aed_file.aed05,
                    d20         LIKE aed_file.aed05,
                    d21         LIKE aed_file.aed05,
                    d22         LIKE aed_file.aed05,
                    d23         LIKE aed_file.aed05,
                    d24         LIKE aed_file.aed05,
                    d25         LIKE aed_file.aed05,
                    d26         LIKE aed_file.aed05,
                    d27         LIKE aed_file.aed05,
                    d28         LIKE aed_file.aed05,
                    d29         LIKE aed_file.aed05,
                    d30         LIKE aed_file.aed05,
                    d31         LIKE aed_file.aed05,
                    d32         LIKE aed_file.aed05,
                    d33         LIKE aed_file.aed05,
                    d34         LIKE aed_file.aed05,
                    d35         LIKE aed_file.aed05,
                    d36         LIKE aed_file.aed05,
                    d37         LIKE aed_file.aed05,
                    d38         LIKE aed_file.aed05,
                    d39         LIKE aed_file.aed05,
                    d40         LIKE aed_file.aed05,
                    d41         LIKE aed_file.aed05,
                    d42         LIKE aed_file.aed05,
                    d43         LIKE aed_file.aed05,
                    d44         LIKE aed_file.aed05,
                    d45         LIKE aed_file.aed05,
                    d46         LIKE aed_file.aed05,
                    d47         LIKE aed_file.aed05,
                    d48         LIKE aed_file.aed05,
                    d49         LIKE aed_file.aed05,
                    d50         LIKE aed_file.aed05);
END FUNCTION

FUNCTION gglq706_get_ahe02(p_aag01_str,p_aed02)
  DEFINE p_aag01_str     LIKE type_file.chr50
  DEFINE p_aed02         LIKE aed_file.aed02
  DEFINE l_ahe01         LIKE ahe_file.ahe01
  DEFINE l_ahe04         LIKE ahe_file.ahe04
  DEFINE l_ahe05         LIKE ahe_file.ahe05
  DEFINE l_ahe07         LIKE ahe_file.ahe07
  DEFINE #l_sql1          LIKE type_file.chr1000
         l_sql1          STRING      #NO.FUN-910082
  DEFINE l_ahe02_d       LIKE ze_file.ze03
  DEFINE l_ahe03         LIKE ahe_file.ahe03  #No.TQC-C50211
  DEFINE p_aag01_str1    LIKE type_file.chr50   #FUN-D40044 add

     #取核算項名稱
     LET l_ahe01 = NULL
     LET p_aag01_str1 = p_aag01_str CLIPPED,"%"   #FUN-D40044 add
     #OPEN gglq706_gaq01_cs USING p_aag01_str     #FUN-D40044 mark
     OPEN gglq706_gaq01_cs USING p_aag01_str1     #FUN-D40044 add
     IF SQLCA.sqlcode THEN
        #CALL cl_err('open gglq706_gaq01_cs',SQLCA.sqlcode,1)
        CLOSE gglq706_gaq01_cs
        RETURN NULL
     END IF
     FETCH FIRST gglq706_gaq01_cs INTO l_ahe01
     IF SQLCA.sqlcode THEN
        #CALL cl_err('fetch gglq706_gaq01_cs',SQLCA.sqlcode,1)
        CLOSE gglq706_gaq01_cs
        RETURN NULL
     END IF
     CLOSE gglq706_gaq01_cs
     IF NOT cl_null(l_ahe01) THEN
#No.TQC-C50211 --begin
        LET l_ahe03 = ''
        LET l_ahe04 = ''
        LET l_ahe05 = ''
        LET l_ahe07 = ''
#No.TQC-C50211 --end
        SELECT ahe03,ahe04,ahe05,ahe07 INTO l_ahe03,l_ahe04,l_ahe05,l_ahe07  #No.TQC-C50211 add ahe03
          FROM ahe_file
         WHERE ahe01 = l_ahe01
        IF NOT cl_null(l_ahe04) AND NOT cl_null(l_ahe05) AND
           NOT cl_null(l_ahe07) THEN
           LET l_sql1 = "SELECT UNIQUE ",l_ahe07 CLIPPED,
                        "  FROM ",l_ahe04 CLIPPED,
                        " WHERE ",l_ahe05 CLIPPED," = '",p_aed02,"'"
           PREPARE ahe_p1 FROM l_sql1
           EXECUTE ahe_p1 INTO l_ahe02_d
        END IF
#No.TQC-C50211 --begin
        IF l_ahe03 = '2' THEN
           LET l_ahe02_d = ''
           SELECT aee04 INTO l_ahe02_d
             FROM aee_file
            WHERE aee00 = tm.o
              AND aee01 = p_aag01_str
              AND aee02 = g_aee02
              AND aee03 = p_aed02
        END IF
#No.TQC-C50211 --end
     END IF

     RETURN l_ahe02_d
END FUNCTION
