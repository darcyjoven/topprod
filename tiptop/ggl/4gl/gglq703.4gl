# Prog. Version..: '5.30.07-13.05.20(00010)'     #
#
# Pattern name...: gglq703.4gl
# Descriptions...: 科目部門帳交叉查詢
# Date & Author..: 08/06/18 by Carrier  #No.FUN-850030
# Modify.........: No.FUN-850030 08/07/24 By dxfwo 新增程序從21區移植到31區
# Modify.........: No.FUN-8A0028 08/10/07 By Carrier 部門資料不存在時,用部門代號default部門說明
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-940388 09/04/30 By wujie 字串連接%前要加轉義符\
# Modify.........: No.MOD-960040 09/06/08 By xiaofeizhu 修改打印時部門順序混亂的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.TQC-A50151 10/05/26 By Carrier MOD-940388追单
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.FUN-B20055 11/02/22 By destiny 輸入改為DIALOG寫法 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-C70153 12/07/23 By lujh 查詢時如點退出鍵，應只退出查詢界面，不應將整個作業都退出
# Modify.........: No:CHI-C70031 12/08/09 By chenying 去除CE、CA憑證資料，否則月末結轉損益後，查詢不到損益類科目
# Modify.........: No:CHI-CB0006 12/11/15 By fengmy 增加"貨幣性科目"和"是否打印內部管理科目"
# Modify.........: No.FUN-C80102 12/10/16 By zhangweib 財務報表改善追單
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.TQC-CC0122 12/12/25 By lujh 1、部門資料重複需修正  2、帳套和部門編號欄位無法開窗
# Modify.........: No.FUN-D30014 13/03/07 By lujh FUN-CB0146追單，程序執行效率優化
# Modify.........: No.FUN-D30041 13/03/15 By xuxz 每行最後一列添加小計欄位
# Modify.........: No:FUN-D40044 13/04/25 By lujh 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額
# Modify.........: No.TQC-DC0064 13/12/19 By wangrr 當'單據狀態'為'2:已過帳'時'含未審核憑證'不顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"  #No.FUN-850030
 
DEFINE tm                 RECORD
                          #wc1     LIKE type_file.chr1000,
                          #wc2     LIKE type_file.chr1000,
                          wc1         STRING,       #NO.FUN-910082
                          wc2         STRING,       #NO.FUN-910082
                          yy      LIKE type_file.num5,
                          mm1     LIKE type_file.num5,
                          mm2     LIKE type_file.num5,
                          o       LIKE aaa_file.aaa01,
                          b       LIKE type_file.chr1,
                          aag09   LIKE aag_file.aag09,  #CHI-CB0006
                          aag38   LIKE aag_file.aag38,  #CHI-CB0006
                          a       LIKE type_file.chr1,    #FUN-C80102  add
                          i       LIKE type_file.chr1,                    #FUN-D40044  add
                          more    LIKE type_file.chr1 
                          END RECORD
DEFINE g_i                LIKE type_file.num5
DEFINE g_sql              STRING
DEFINE g_str              STRING
DEFINE l_table            STRING
DEFINE g_rec_b            LIKE type_file.num10
DEFINE g_mm               LIKE type_file.num5
DEFINE g_cnt              LIKE type_file.num10
DEFINE g_gem              DYNAMIC ARRAY OF RECORD
                          gem01      LIKE gem_file.gem01,
                          gem02      LIKE gem_file.gem02
                          END RECORD
DEFINE g_aao              DYNAMIC ARRAY OF RECORD
                          aag01      LIKE aag_file.aag01,
                          aag02      LIKE aag_file.aag02,
                          #aao02      LIKE aao_file.aao02,     #FUN-C80102  add  FUN-C80102 mark
                          d01        LIKE aao_file.aao05,     
                          d02        LIKE aao_file.aao05,
                          d03        LIKE aao_file.aao05,
                          d04        LIKE aao_file.aao05,
                          d05        LIKE aao_file.aao05,
                          d06        LIKE aao_file.aao05,
                          d07        LIKE aao_file.aao05,
                          d08        LIKE aao_file.aao05,
                          d09        LIKE aao_file.aao05,
                          d10        LIKE aao_file.aao05,
                          d11        LIKE aao_file.aao05,
                          d12        LIKE aao_file.aao05,
                          d13        LIKE aao_file.aao05,
                          d14        LIKE aao_file.aao05,
                          d15        LIKE aao_file.aao05,
                          d16        LIKE aao_file.aao05,
                          d17        LIKE aao_file.aao05,
                          d18        LIKE aao_file.aao05,
                          d19        LIKE aao_file.aao05,
                          d20        LIKE aao_file.aao05,
                          d21        LIKE aao_file.aao05,
                          d22        LIKE aao_file.aao05,
                          d23        LIKE aao_file.aao05,
                          d24        LIKE aao_file.aao05,
                          d25        LIKE aao_file.aao05,
                          d26        LIKE aao_file.aao05,
                          d27        LIKE aao_file.aao05,
                          d28        LIKE aao_file.aao05,
                          d29        LIKE aao_file.aao05,
                          d30        LIKE aao_file.aao05,
                          d31        LIKE aao_file.aao05,
                          d32        LIKE aao_file.aao05,
                          d33        LIKE aao_file.aao05,
                          d34        LIKE aao_file.aao05,
                          d35        LIKE aao_file.aao05,
                          d36        LIKE aao_file.aao05,
                          d37        LIKE aao_file.aao05,
                          d38        LIKE aao_file.aao05,
                          d39        LIKE aao_file.aao05,
                          d40        LIKE aao_file.aao05,
                          d41        LIKE aao_file.aao05,
                          d42        LIKE aao_file.aao05,
                          d43        LIKE aao_file.aao05,
                          d44        LIKE aao_file.aao05,
                          d45        LIKE aao_file.aao05,
                          d46        LIKE aao_file.aao05,
                          d47        LIKE aao_file.aao05,
                          d48        LIKE aao_file.aao05,
                          d49        LIKE aao_file.aao05,
                          d50        LIKE aao_file.aao05
                         ,l_sum      LIKE type_file.num20_6#FUN-D30041 add
                          END RECORD
DEFINE g_title            RECORD
                          mm         LIKE type_file.num5,
                          t01        LIKE gem_file.gem02,
                          t02        LIKE gem_file.gem02,
                          t03        LIKE gem_file.gem02,
                          t04        LIKE gem_file.gem02,
                          t05        LIKE gem_file.gem02,
                          t06        LIKE gem_file.gem02,
                          t07        LIKE gem_file.gem02,
                          t08        LIKE gem_file.gem02,
                          t09        LIKE gem_file.gem02,
                          t10        LIKE gem_file.gem02,
                          t11        LIKE gem_file.gem02,
                          t12        LIKE gem_file.gem02,
                          t13        LIKE gem_file.gem02,
                          t14        LIKE gem_file.gem02,
                          t15        LIKE gem_file.gem02,
                          t16        LIKE gem_file.gem02,
                          t17        LIKE gem_file.gem02,
                          t18        LIKE gem_file.gem02,
                          t19        LIKE gem_file.gem02,
                          t20        LIKE gem_file.gem02,
                          t21        LIKE gem_file.gem02,
                          t22        LIKE gem_file.gem02,
                          t23        LIKE gem_file.gem02,
                          t24        LIKE gem_file.gem02,
                          t25        LIKE gem_file.gem02,
                          t26        LIKE gem_file.gem02,
                          t27        LIKE gem_file.gem02,
                          t28        LIKE gem_file.gem02,
                          t29        LIKE gem_file.gem02,
                          t30        LIKE gem_file.gem02,
                          t31        LIKE gem_file.gem02,
                          t32        LIKE gem_file.gem02,
                          t33        LIKE gem_file.gem02,
                          t34        LIKE gem_file.gem02,
                          t35        LIKE gem_file.gem02,
                          t36        LIKE gem_file.gem02,
                          t37        LIKE gem_file.gem02,
                          t38        LIKE gem_file.gem02,
                          t39        LIKE gem_file.gem02,
                          t40        LIKE gem_file.gem02,
                          t41        LIKE gem_file.gem02,
                          t42        LIKE gem_file.gem02,
                          t43        LIKE gem_file.gem02,
                          t44        LIKE gem_file.gem02,
                          t45        LIKE gem_file.gem02,
                          t46        LIKE gem_file.gem02,
                          t47        LIKE gem_file.gem02,
                          t48        LIKE gem_file.gem02,
                          t49        LIKE gem_file.gem02,
                          t50        LIKE gem_file.gem02
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
   LET tm.b       = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)
   LET tm.a       = ARG_VAL(18)   #FUN-C80102  add
 
   CALL q703_out_1()
 
   OPEN WINDOW q703_w AT 5,10
        WITH FORM "ggl/42f/gglq703_1" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
  
   CALL cl_set_comp_visible("aao02",TRUE)   #FUN-C80102  add 

   IF cl_null(tm.wc1) THEN
       CALL gglq703_tm(0,0)
   ELSE
       #CALL gglq703()      #FUN-D30014 mark
       CALL gglq703v()      #FUN-D30014 add
   END IF
 
   CALL q703_menu()
   DROP TABLE gglq703_tmp;
   CLOSE WINDOW q703_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q703_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q703_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq703_tm(0,0)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q703_out_2()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_aao),'','')
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
 
FUNCTION q703_out_1()
   LET g_sql = " mm1.type_file.num5,    ",
               " aag01.aag_file.aag01,  ",
               " aag02.aag_file.aag02,  ",
               " gem01.gem_file.gem01,  ",                                #MOD-960040 Add
               " gem02.gem_file.gem02,  ",
               " qty1.type_file.num20_6 "
 
   LET l_table = cl_prt_temptable('gglq703',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ? )               "                #MOD-960040 Add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION gglq703_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_flag         LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5

   CLEAR FORM #清除畫面   #FUN-C80102  add
   CALL g_aao.clear()   #FUN-C80102  add 

   #FUN-C80102--mark--str---
   #LET p_row = 4 LET p_col = 13
 
   #OPEN WINDOW gglq703_w1 AT p_row,p_col WITH FORM "ggl/42f/gglq703"
   #     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #CALL cl_ui_locale("gglq703")
   #FUN-C80102--mark--end---
 
   CALL cl_opmsg('p')
   LET tm.yy    = YEAR(g_today)
   LET tm.mm1   = MONTH(g_today)
   LET tm.mm2   = MONTH(g_today)
   LET tm.o     = g_aza.aza81
   #LET tm.b     = 'N'   #FUN-C80102  mark
   LET tm.b     = '1'    #FUN-C80102  add
   LET tm.a     = 'N'    #FUN-C80102  add
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.aag09  = 'Y'                #No.CHI-CB0006
   LET tm.aag38  = 'N'                #No.CHI-CB0006
   LET tm.i ='N'    #FUN-D40044 add
   DISPLAY BY NAME tm.aag09,tm.aag38  #No.CHI-CB0006
   #DISPLAY BY NAME tm.yy,tm.mm1,tm.mm2,tm.o,tm.b,tm.more    #FUN-C80102  mark  
WHILE TRUE

   #No.FUN-B20010  --Begin
   #FUN-B20055--begin
#   INPUT BY NAME tm.o WITHOUT DEFAULTS
# 
#      BEFORE INPUT
#         CALL cl_qbe_display_condition(lc_qbe_sn)
#       
#      AFTER FIELD o
#         IF NOT cl_null(tm.o) THEN
#            CALL s_check_bookno(tm.o,g_user,g_plant)
#                 RETURNING li_chk_bookno
#            IF (NOT li_chk_bookno) THEN
#               NEXT FIELD o
#            END IF
# 
#            SELECT * FROM aaa_file WHERE aaa01 = tm.o
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0)
#               NEXT FIELD o
#            END IF
#         END IF
# 
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(o)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = 'q_aaa'
#               CALL cl_create_qry() RETURNING tm.o
#               DISPLAY BY NAME tm.o
#               NEXT FIELD o
#         END CASE
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
# 
#   END INPUT
#   #No.FUN-B20010  --End
#   CONSTRUCT BY NAME tm.wc1 ON aag01
# 
#      BEFORE CONSTRUCT
#         CALL cl_qbe_init()
# 
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
# 
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
# 
#   END CONSTRUCT
#   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
# 
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW gglq703_w1
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
# 
#   CONSTRUCT BY NAME tm.wc2 ON aao02
# 
#      BEFORE CONSTRUCT
#         CALL cl_qbe_init()
# 
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(aao02)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = 'c'
#               LET g_qryparam.form = 'q_gem'
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aao02
#               NEXT FIELD aao02
#         END CASE
# 
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
# 
#   END CONSTRUCT
# 
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW gglq703_w1
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
# 
#   #INPUT BY NAME tm.yy,tm.mm1,tm.mm2,tm.o,tm.b,tm.more #No.FUN-B20010 mark
#   INPUT BY NAME tm.yy,tm.mm1,tm.mm2,tm.b,tm.more       #No.FUN-B20010 去掉tm.o
#                 WITHOUT DEFAULTS
# 
#      BEFORE INPUT
#         CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#      AFTER FIELD yy
#         IF tm.yy <=0 THEN NEXT FIELD yy END IF
# 
#      AFTER FIELD mm1
#         IF tm.mm1 <=0 OR tm.mm1 > 13 THEN NEXT FIELD mm1 END IF
#         IF NOT cl_null(tm.mm1) AND NOT cl_null(tm.mm2) THEN
#            IF tm.mm1 > tm.mm2 THEN
#               NEXT FIELD mm2
#            END IF
#         END IF
# 
#      AFTER FIELD mm2
#         IF tm.mm2 <=0 OR tm.mm2 > 13 THEN NEXT FIELD mm2 END IF
#         IF NOT cl_null(tm.mm1) AND NOT cl_null(tm.mm2) THEN
#            IF tm.mm1 > tm.mm2 THEN
#               NEXT FIELD mm1
#            END IF
#         END IF
# 
#     #No.FUN-B20010  --Begin
#     #AFTER FIELD o
#     #   IF NOT cl_null(tm.o) THEN
#     #      CALL s_check_bookno(tm.o,g_user,g_plant)
#     #           RETURNING li_chk_bookno
#     #      IF (NOT li_chk_bookno) THEN
#     #         NEXT FIELD o
#     #      END IF
#     #
#     #      SELECT * FROM aaa_file WHERE aaa01 = tm.o
#     #      IF SQLCA.sqlcode THEN
#     #         CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0)
#     #         NEXT FIELD o
#     #      END IF
#     #   END IF
#     #No.FUN-B20010  --End
#     
#      AFTER FIELD more
#         IF tm.more = 'Y'
#            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                                g_bgjob,g_time,g_prtway,g_copies)
#                      RETURNING g_pdate,g_towhom,g_rlang,
#                                g_bgjob,g_time,g_prtway,g_copies
#         END IF
# 
#     #No.FUN-B20010  --Begin
#     #ON ACTION CONTROLP
#     #   CASE
#     #      WHEN INFIELD(o)
#     #         CALL cl_init_qry_var()
#     #         LET g_qryparam.form = 'q_aaa'
#     #         CALL cl_create_qry() RETURNING tm.o
#     #         DISPLAY BY NAME tm.o
#     #         NEXT FIELD o
#     #   END CASE
#     #No.FUN-B20010  --End
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
# 
#   END INPUT
   #FUN-C80102--mark--str---
   #DIALOG ATTRIBUTE(UNBUFFERED)
   #INPUT BY NAME tm.o ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
 
   #   BEFORE INPUT
   #      CALL cl_qbe_display_condition(lc_qbe_sn)
       
   #   AFTER FIELD o
   #      IF NOT cl_null(tm.o) THEN
   #         CALL s_check_bookno(tm.o,g_user,g_plant)
   #              RETURNING li_chk_bookno
   #         IF (NOT li_chk_bookno) THEN
   #            NEXT FIELD o
   #         END IF
 
   #         SELECT * FROM aaa_file WHERE aaa01 = tm.o
   #         IF SQLCA.sqlcode THEN
   #            CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0)
   #            NEXT FIELD o
   #         END IF
   #      END IF
   
   #END INPUT

   #CONSTRUCT BY NAME tm.wc1 ON aag01
 
   #   BEFORE CONSTRUCT
   #      CALL cl_qbe_init()
 
   #END CONSTRUCT
  
   #CONSTRUCT BY NAME tm.wc2 ON aao02
 
   #   BEFORE CONSTRUCT
   #      CALL cl_qbe_init()
   
   #END CONSTRUCT
   #FUN-C80102--mark--end---
 
     #INPUT BY NAME tm.yy,tm.mm1,tm.mm2,tm.b,tm.more      #FUN-C80102  mark
      DIALOG ATTRIBUTE(UNBUFFERED)   #FUN-C80102  add
      INPUT BY NAME tm.o,tm.yy,tm.mm1,tm.mm2,tm.b,tm.a,tm.aag09,tm.aag38,tm.i     #FUN-C80102  add  #CHI-CB0006 add aag09,aag38  #FUN-D40044 add tm.i
         ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
 
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      #FUN-C80102--add--str---
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
      #FUN-C80102--add--end---
 
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
      #TQC-DC0064--add--str--
      ON CHANGE b
         IF tm.b='2' THEN
            LET tm.a='N'
            CALL cl_set_comp_visible("a",FALSE)
         ELSE
            CALL cl_set_comp_visible("a",TRUE)
         END IF
      #TQC-DC0064--add--end

      #FUN-C80102--add--str---
      ON CHANGE a
           IF tm.a NOT MATCHES "[YyNn]" THEN NEXT FIELD a END IF
      #FUN-C80102--add--end---

      #FUN-D40044--add--str---
        ON CHANGE i
           IF tm.i NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD i
           END IF
      #FUN-D40044--add--end---

      #FUN-C80102--mark--str---
      #AFTER FIELD more
      #   IF tm.more = 'Y'
      #      THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
      #                          g_bgjob,g_time,g_prtway,g_copies)
      #                RETURNING g_pdate,g_towhom,g_rlang,
      #                          g_bgjob,g_time,g_prtway,g_copies
      #   END IF
      #FUN-C80102--mark--end---
     #END INPUT    #FUN-C80102 mark  
     
     #TQC-CC0122--mark--str--
     #FUN-C80102--mark--str---    
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(o)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aaa'
              CALL cl_create_qry() RETURNING tm.o
              DISPLAY BY NAME tm.o
              NEXT FIELD o     
     #       WHEN INFIELD(aag01)
     #          CALL cl_init_qry_var()
     #          LET g_qryparam.state = 'c'
     #          LET g_qryparam.form = 'q_aag'
     #          LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"  
     #          CALL cl_create_qry() RETURNING g_qryparam.multiret
     #          DISPLAY g_qryparam.multiret TO aag01
     #          NEXT FIELD aag01         
     #       WHEN INFIELD(aao02)
     #          CALL cl_init_qry_var()
     #          LET g_qryparam.state = 'c'
     #          LET g_qryparam.form = 'q_gem'
     #          CALL cl_create_qry() RETURNING g_qryparam.multiret
     #          DISPLAY g_qryparam.multiret TO aao02
     #          NEXT FIELD aao02
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

        ON ACTION qbe_save
           CALL cl_qbe_save()

     #   ON ACTION accept
     #      EXIT DIALOG   
     #      
     #   ON ACTION cancel 
     #      LET INT_FLAG = 1
     #      EXIT DIALOG       
     #FUN-C80102--mark--end---
            
   #END DIALOG    #FUN-C80102 mark
   END INPUT      #FUN-C80102 add
   #FUN-C80102--add--str--
    CONSTRUCT tm.wc1 ON aag01
                  FROM s_aao[1].aag01
      BEFORE CONSTRUCT
         CALL cl_qbe_init()


      ON ACTION CONTROLP
        CASE 
           #TQC-CC0122--mark--str--
           #WHEN INFIELD(o)
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form = 'q_aaa'
           #   CALL cl_create_qry() RETURNING tm.o
           #   DISPLAY BY NAME tm.o
           #   NEXT FIELD o 
           #TQC-CC0122--mark--end--
          WHEN INFIELD(aag01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = 'q_aag'
               LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aag01
               NEXT FIELD aag01   
        END CASE

    END CONSTRUCT
    
    #FUN-C80102--mark--str--
    #CONSTRUCT tm.wc2 ON aao02
    #               FROM s_aao[1].aao02
    #FUN-C80102--mark--end--
    CONSTRUCT BY NAME tm.wc2 ON aao02      #FUN-C80102  add
       BEFORE CONSTRUCT
          CALL cl_qbe_init()


      ON ACTION CONTROLP
       CASE 
          WHEN INFIELD(aao02)                                                
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = 'q_gem'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aao02
               NEXT FIELD aao02
       END CASE

    END CONSTRUCT

    ON ACTION accept
        EXIT DIALOG        
       
    ON ACTION cancel
        LET INT_FLAG=1
        EXIT DIALOG       
    END DIALOG 
   #FUN-C80102--add--end--
   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF   
   #FUN-B20055--end 
   #FUN-C80102--add--str--
   IF INT_FLAG THEN
       LET INT_FLAG = 0 
       RETURN
   END IF 
   #FUN-C80102--add--end--
   #FUN-C80102--mark--str--
   #IF INT_FLAG THEN
   #   LET INT_FLAG = 0 CLOSE WINDOW gglq703_w1
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   #  #EXIT PROGRAM               #TQC-C70153  mark
   #  RETURN                      #TQC-C70153  add
   #END IF
   #FUN-C80102--mark--end--
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='gglq703'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gglq703','9031',1)
      ELSE
         LET tm.wc1=cl_replace_str(tm.wc1, "'", "\"")
         LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate    CLIPPED,"'",
                         " '",g_towhom   CLIPPED,"'",
                         " '",g_rlang    CLIPPED,"'",
                         " '",g_bgjob    CLIPPED,"'",
                         " '",g_prtway   CLIPPED,"'",
                         " '",g_copies   CLIPPED,"'",
                         " '",tm.wc1     CLIPPED,"'",
                         " '",tm.wc2     CLIPPED,"'",
                         " '",tm.yy      CLIPPED,"'",
                         " '",tm.mm1     CLIPPED,"'",
                         " '",tm.mm2     CLIPPED,"'",
                         " '",tm.o       CLIPPED,"'",
                         " '",tm.b       CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"
         CALL cl_cmdat('gglq703',g_time,l_cmd)
      END IF
      CLOSE WINDOW gglq703_w1    
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   #CALL gglq703()    #FUN-D30014  mark
   CALL gglq703v()    #FUN-D30014  add
   ERROR ""
   EXIT WHILE
END WHILE
   CLOSE WINDOW gglq703_w1
 
   LET g_mm = NULL
   #設置title & 隱藏沒有資料的部門column
   FOR g_i = 1 TO 50
       LET g_field = "d",g_i USING "&<"
       CALL cl_getmsg("ggl-225",g_lang) RETURNING g_msg1
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
   CALL g_aao.clear()
   CALL gglq703_cs()
END FUNCTION

#FUN-D30014--add--str--
FUNCTION gglq703v()
   DEFINE
          l_sql        STRING,      #NO.FUN-910082
          l_flag       LIKE type_file.chr1,
          l_i          LIKE type_file.num5,
          l_cnt        LIKE type_file.num5,
          l_wc1         STRING,       #NO.FUN-910082
          l_wc2         STRING,       #NO.FUN-910082
          l_aao02      LIKE aao_file.aao02,
          l_gem02      LIKE gem_file.gem02,
          l_aag01      LIKE aag_file.aag01,
          t_aag01      LIKE aag_file.aag01,
          l_aag01_str  LIKE type_file.chr50,
          l_aag02      LIKE aag_file.aag02,
          l_aag06      LIKE aag_file.aag06,
          l_aao05      LIKE aao_file.aao05,
          l_aao06      LIKE aao_file.aao06,
          l_aao051     LIKE aao_file.aao05,
          l_aao061     LIKE aao_file.aao06,
          l_abb07      LIKE abb_file.abb07,  #CHI-C70031
          l_abb071     LIKE abb_file.abb07,  #CHI-C70031
          l_sum        LIKE aao_file.aao05,
          l_sum_a      DYNAMIC ARRAY OF LIKE aao_file.aao05,
          l_aaa09      LIKE aaa_file.aaa09,   #CHI-C70031
          l_aeh15      LIKE aeh_file.aeh15,   #CHI-C70031
          l_aeh16      LIKE aeh_file.aeh16    #CHI-C70031
   ###TQC-9C0179 START ###
   DEFINE l_aag02_1  LIKE aag_file.aag02
   DEFINE l_gem02_1  LIKE gem_file.gem02
   ###TQC-9C0179 END ###
   DEFINE l_end_sum    LIKE type_file.num20_6 #FUN-D30041 add


     CALL gglq703_table()
     CALL cl_del_data(l_table)
   DISPLAY "START TIME: ",TIME
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang

     LET l_sql = " SELECT aag01,aag02,aag06 FROM aag_file",
                 "  WHERE aag00 = '",tm.o,"'",
                 "    AND ",tm.wc1
     IF tm.aag09 = 'Y' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag09 = 'Y' "
     END IF

     IF tm.aag38 = 'N' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag38 = 'N' "
     END IF
     PREPARE gglq703_aag01_pv FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq703_aag01_pv',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq703_aag01_csv CURSOR FOR gglq703_aag01_pv

     #科目list
     LET l_sql = "INSERT INTO gglq703_aao01 "
     LET l_wc1=cl_replace_str(tm.wc1,'aag01','aao01')
     LET l_sql =l_sql," SELECT UNIQUE aao01 FROM aao_file ",
                 "  WHERE aao00 = '",tm.o,"'",
                 "    AND aao03 =  ",tm.yy,
                 "    AND aao04 = ?",
                 "    AND aao02 IS NOT NULL ",
                 "    AND ",l_wc1  CLIPPED,
                 "    AND ",tm.wc2 CLIPPED
             #   "  ORDER BY aao01 "
     PREPARE gglq703_aao01 FROM l_sql


     #動態部門title
     #已過帳
     LET l_sql = "INSERT INTO gglq703_aao02 "
#    LET l_sql = l_sql," SELECT UNIQUE aao02,gem02 FROM aao_file,gem_file",
     LET l_sql = l_sql," SELECT UNIQUE aao02 FROM aao_file",
                 "  WHERE aao00 = '",tm.o,"'",
                 "    AND aao03 =  ",tm.yy,
           #     "    AND aao02 = gem01",
                 "    AND aao04 = ?",
                 "    AND aao02 IS NOT NULL ",
                 "    AND ",l_wc1  CLIPPED,
                 "    AND ",tm.wc2 CLIPPED
             #   "  ORDER BY aao02 "
     PREPARE gglq703_aao02 FROM l_sql

     LET l_wc2=cl_replace_str(tm.wc2, 'aao02','abb05')
     LET l_sql = " SELECT COUNT(*) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND abb00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND aba04 = ?",
                 "    AND abb05 IS NOT NULL ",
                 "    AND abb05 <> ' ' ",
                 "    AND abb03 LIKE ? ",
                 "    AND ",l_wc2 CLIPPED
     IF tm.a = 'Y' THEN
        IF tm.b = '1' THEN
           LET l_sql = l_sql," AND (aba19 = 'N' or aba19 ='Y')"
        ELSE
           LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))"
        END IF
     END IF
     IF tm.a = 'N' THEN
        IF tm.b = '1' THEN
           LET l_sql = l_sql," AND  aba19 ='Y'"
        ELSE
           LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'"
        END IF
     END IF

     PREPARE gglq703_aao01_p2v FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq703_aao01_p2v',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF


      LET l_sql = "INSERT INTO gglq703_aao02 "
#     LET l_sql = l_sql," SELECT UNIQUE abb05,gem02 FROM aba_file,abb_file,gem_file ",
      LET l_sql = l_sql," SELECT UNIQUE abb05 FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND abb00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
         #       "    AND abb05 = gem01",
                 "    AND aba04 = ?",
                 "    AND abb05 IS NOT NULL ",
                 "    AND abb03 LIKE ? ",
                 "    AND ",l_wc2 CLIPPED
      IF tm.a = 'Y' THEN
         IF tm.b = '1' THEN
            LET l_sql = l_sql," AND (aba19 = 'N' or aba19 ='Y')",
                              "  ORDER BY abb05 "
         ELSE
            LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))",
                              "  ORDER BY abb05 "
         END IF
      END IF
      IF tm.a = 'N' THEN
         IF tm.b = '1' THEN
            LET l_sql = l_sql," AND  aba19 ='Y'",
                              "  ORDER BY abb05 "
         ELSE
            LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'",
                              "  ORDER BY abb05 "
         END IF
      END IF

     PREPARE gglq703_aao022 FROM l_sql

     LET l_sql = " SELECT SUM(abb07) FROM aba_file ,abb_file",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND aba04 = ?",
                 "    AND abb03 LIKE ?",
                 "    AND abb05 = ?",
                 "    AND abb06 = ?"
     IF tm.a = 'Y' THEN 
        IF tm.b = '1' THEN 
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.a = 'N' THEN 
        IF tm.b = '1' THEN 
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF 
     END IF 

     PREPARE gglq703_abb07_pv FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq703_abb07_pv',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq703_abb07_csv CURSOR FOR gglq703_abb07_pv



     DECLARE gglq703_aao02_csv CURSOR FOR SELECT aao02 FROM gglq703_aao02
 #   DECLARE gglq703_aao02_csv CURSOR FOR SELECT aao02,gem02 FROM gglq703_aao02
      ORDER BY aao02

     DECLARE gglq703_aao01_csv CURSOR FOR SELECT aao01 FROM gglq703_aao01
      ORDER BY aao01

     FOR g_i = tm.mm1 TO tm.mm2
         #gem list
         DELETE FROM gglq703_aao02;
         #account list
         DELETE FROM gglq703_aao01;

         EXECUTE gglq703_aao02 USING g_i
         EXECUTE gglq703_aao01 USING g_i

            LET t_aag01 = NULL
            FOREACH gglq703_aag01_csv INTO t_aag01,l_aag02,l_aag06
               LET l_aag01_str = t_aag01 CLIPPED,"\%"  #No.TQC-A50151

               EXECUTE gglq703_aao022 USING g_i,l_aag01_str
               EXECUTE gglq703_aao01_p2v USING g_i,l_aag01_str INTO l_cnt
                  IF l_cnt >= 1 THEN
                     INSERT INTO gglq703_aao01 VALUES(t_aag01);
                  END IF

            END FOREACH

         LET l_i = 1
         CALL g_gem.clear()
         #當前月份的部門明細

         FOREACH gglq703_aao02_csv INTO l_aao02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq703_aao02_csv:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            LET l_gem02 = NULL
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_aao02
            #No.FUN-8A0028  --Begin
            IF SQLCA.sqlcode = 100 THEN
               LET l_gem02 = l_aao02
            END IF
            #No.FUN-8A0028  --End
            LET g_gem[l_i].gem01 = l_aao02
            LET g_gem[l_i].gem02 = l_gem02
            LET l_i = l_i + 1
         END FOREACH

       # FOREACH gglq703_aao02_csv INTO g_gem[l_i].gem01,g_gem[l_i].gem02
       #    LET l_i = l_i + 1
       # END FOREACH
         LET l_cnt = l_i - 1


         #每個月的部門title
         INSERT INTO gglq703_title VALUES(g_i,g_gem[01].gem02,
            g_gem[02].gem02, g_gem[03].gem02, g_gem[04].gem02,
            g_gem[05].gem02, g_gem[06].gem02, g_gem[07].gem02,
            g_gem[08].gem02, g_gem[09].gem02, g_gem[10].gem02,
            g_gem[11].gem02, g_gem[12].gem02, g_gem[13].gem02,
            g_gem[14].gem02, g_gem[15].gem02, g_gem[16].gem02,
            g_gem[17].gem02, g_gem[18].gem02, g_gem[19].gem02,
            g_gem[20].gem02, g_gem[21].gem02, g_gem[22].gem02,
            g_gem[23].gem02, g_gem[24].gem02, g_gem[25].gem02,
            g_gem[26].gem02, g_gem[27].gem02, g_gem[28].gem02,
            g_gem[29].gem02, g_gem[30].gem02, g_gem[31].gem02,
            g_gem[32].gem02, g_gem[33].gem02, g_gem[34].gem02,
            g_gem[35].gem02, g_gem[36].gem02, g_gem[37].gem02,
            g_gem[38].gem02, g_gem[39].gem02, g_gem[40].gem02,
            g_gem[41].gem02, g_gem[42].gem02, g_gem[43].gem02,
            g_gem[44].gem02, g_gem[45].gem02, g_gem[46].gem02,
            g_gem[47].gem02, g_gem[48].gem02, g_gem[49].gem02,
            g_gem[50].gem02);
         
         FOREACH gglq703_aao01_csv INTO l_aag01
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq703_aao01_csv:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file
             WHERE aag00 = tm.o
               AND aag01 = l_aag01
            LET l_aag01_str = l_aag01 CLIPPED,'\%'    #No.MOD-940388

            CALL l_sum_a.clear()
            LET l_end_sum = 0#FUN-D30041 add
            FOR l_i = 1 TO l_cnt
                LET l_aao05  = 0   LET l_aao06  = 0
                LET l_aao051 = 0   LET l_aao061 = 0
                SELECT SUM(aao05),SUM(aao06) INTO l_aao05,l_aao06
                  FROM aao_file
                 WHERE aao00 = tm.o  AND aao01 = l_aag01
                   AND aao02 = g_gem[l_i].gem01
                   AND aao03 = tm.yy AND aao04 = g_i
                IF cl_null(l_aao05) THEN LET l_aao05 = 0 END IF
                IF cl_null(l_aao06) THEN LET l_aao06 = 0 END IF
                #IF tm.b = 'Y' THEN   #FUN-C80102  mark
                   OPEN gglq703_abb07_csv USING g_i,l_aag01_str,
                                               g_gem[l_i].gem01,'1'
                   FETCH gglq703_abb07_csv INTO l_aao051
                   CLOSE gglq703_abb07_csv
                   IF cl_null(l_aao051) THEN LET l_aao051 = 0 END IF
                   OPEN gglq703_abb07_csv USING g_i,l_aag01_str,
                                               g_gem[l_i].gem01,'2'
                   FETCH gglq703_abb07_csv INTO l_aao061
                   CLOSE gglq703_abb07_csv
                   IF cl_null(l_aao061) THEN LET l_aao061 = 0 END IF
                #END IF   #FUN-C80102  mark
                #No.CHI-C70031  --Begin
                SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
                CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, g_gem[l_i].gem01,g_gem[l_i].gem01,NULL,
                NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
                g_i,       g_i,       NULL,      NULL,     NULL,    NULL,
                NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
                RETURNING  l_abb07,l_abb071,l_aeh15,l_aeh16
                #No.CHI-C70031  --End
                IF tm.i = 'N' THEN     #FUN-D40044 add
                   LET l_sum = l_aao05 - l_aao06 + l_aao051 - l_aao061- l_abb07 + l_abb071    #CHI-C70031 add abb07,abb071
                #FUN-D40044--add--str--
                ELSE
                   LET l_sum = l_aao05 - l_aao06 + l_aao051 - l_aao061
                END IF 
                #FUN-D40044--add--end--
                IF l_aag06 = '2' THEN
                   LET l_sum = l_sum * -1
                END IF
                LET l_sum_a[l_i] = l_sum
                LET l_end_sum = l_end_sum +l_sum_a[l_i]#FUN-D30041 add
                ###TQC-9C0179 START ###
                LET l_aag02_1 = l_aag02[1,30]
                LET l_gem02_1 = g_gem[l_i].gem02[1,30]
                ###TQC-9C0179 END ###
                #EXECUTE insert_prep USING g_i,l_aag01,l_aag02[1,30],g_gem[l_i].gem01,     #MOD-960040 Add g_gem[l_i].gem0
                #                          g_gem[l_i].gem02[1,30],l_sum                                                   
  #TQC-9C0179 mark
                EXECUTE insert_prep USING g_i,l_aag01,l_aag02_1,g_gem[l_i].gem01,     #MOD-960040 Add g_gem[l_i].gem01  #T
                                          l_gem02_1,l_sum          #TQC-9C0179
            END FOR
            #每個月下的單身資料
            #FOR l_i = 1 TO l_cnt   #FUN-C80102  add  #lujh 1225 mark
               #INSERT INTO gglq703_tmp VALUES(g_i, l_aag01, l_aag02,g_gem[l_i].gem01,    #FUN-C80102  add  g_gem[l_i].gem
               INSERT INTO gglq703_tmp VALUES(g_i, l_aag01, l_aag02,    #FUN-C80102  add  g_gem[l_i].gem01  #lujh 1225 add
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
                   l_sum_a[49], l_sum_a[50], l_end_sum);#FUN-D30041 add l_end_sum
                   DISPLAY g_gem[l_i].gem01 TO aoo02
            #END FOR    #FUN-C80102  add   #lujh 1225 mark
         END FOREACH
     END FOR
 DISPLAY TIME
END FUNCTION
#FUN-D30014--add--end--

#FUN-D30014--mark--str--
 FUNCTION gglq703()
   DEFINE #l_sql        LIKE type_file.chr1000,
          l_sql        STRING,      #NO.FUN-910082
          l_flag       LIKE type_file.chr1,
          l_i          LIKE type_file.num5,
          l_cnt        LIKE type_file.num5,
          #l_wc1        LIKE type_file.chr1000,
          #l_wc2        LIKE type_file.chr1000,
          l_wc1         STRING,       #NO.FUN-910082
          l_wc2         STRING,       #NO.FUN-910082
          l_aao02      LIKE aao_file.aao02,
          l_gem02      LIKE gem_file.gem02,
          l_aag01      LIKE aag_file.aag01,
          t_aag01      LIKE aag_file.aag01,
          l_aag01_str  LIKE type_file.chr50,
          l_aag02      LIKE aag_file.aag02,
          l_aag06      LIKE aag_file.aag06,
          l_aao05      LIKE aao_file.aao05,
          l_aao06      LIKE aao_file.aao06,
          l_aao051     LIKE aao_file.aao05,
          l_aao061     LIKE aao_file.aao06,
          l_abb07      LIKE abb_file.abb07,  #CHI-C70031
          l_abb071     LIKE abb_file.abb07,  #CHI-C70031
          l_sum        LIKE aao_file.aao05,
          l_sum_a      DYNAMIC ARRAY OF LIKE aao_file.aao05,
          l_aaa09      LIKE aaa_file.aaa09,   #CHI-C70031
          l_aeh15      LIKE aeh_file.aeh15,   #CHI-C70031
          l_aeh16      LIKE aeh_file.aeh16    #CHI-C70031
   ###TQC-9C0179 START ###
   DEFINE l_aag02_1  LIKE aag_file.aag02
   DEFINE l_gem02_1  LIKE gem_file.gem02
   ###TQC-9C0179 END ###
   DEFINE l_end_sum    LIKE type_file.num20_6 #FUN-D30041 add
 
     CALL gglq703_table()
     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
     LET l_sql = " SELECT aag01,aag02,aag06 FROM aag_file",
                 "  WHERE aag00 = '",tm.o,"'",
                 "    AND ",tm.wc1
     #No.CHI-CB0006  --Begin
     IF tm.aag09 = 'Y' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag09 = 'Y' "
     END IF

     IF tm.aag38 = 'N' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag38 = 'N' "
     END IF
     #No.CHI-CB0006  --End
     PREPARE gglq703_aag01_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq703_aag01_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq703_aag01_cs CURSOR FOR gglq703_aag01_p
 
     #科目list
     LET l_wc1=cl_replace_str(tm.wc1,'aag01','aao01')
     LET l_sql = " SELECT UNIQUE aao01 FROM aao_file ",
                 "  WHERE aao00 = '",tm.o,"'",
                 "    AND aao03 =  ",tm.yy,
                 "    AND aao04 = ?",
                 "    AND aao02 IS NOT NULL ",
                 "    AND ",l_wc1  CLIPPED,
                 "    AND ",tm.wc2 CLIPPED,
                 "  ORDER BY aao01 "
     PREPARE gglq703_aao01_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq703_aao01_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq703_aao01_cs1 CURSOR FOR gglq703_aao01_p1
 
     #tm.b = 'Y' unposted!
     LET l_wc2=cl_replace_str(tm.wc2, 'aao02','abb05')
     #TQC-CC0122--mark--str--
     #FUN-C80102--add--str--
     #IF tm.a = 'Y' THEN 
     #   LET l_sql = " SELECT COUNT(*) FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND abb00 = '",tm.o,"'",
     #            "    AND aba03 =  ",tm.yy,
     #            "    AND aba04 = ?",
     #            "    AND abb05 IS NOT NULL ",
     #            "    AND abb05 <> ' ' ",
     #            "    AND abb03 LIKE ? ",
     #            "    AND aba19 <> 'X' ",   #CHI-C80041
     #            "    AND ",l_wc2 CLIPPED
     #END IF 
     #IF tm.a = 'N' THEN 
     #   IF tm.b = '1' THEN 
     #      LET l_sql = " SELECT COUNT(*) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND abb00 = '",tm.o,"'",
     #                  "    AND aba03 =  ",tm.yy,
     #                  "    AND aba04 = ?",
     #                  "    AND abb05 IS NOT NULL ",
     #                  "    AND abb05 <> ' ' ",
     #                  "    AND abb03 LIKE ? ",
     #                  "    AND ",l_wc2 CLIPPED,
     #                  "    AND aba19 = 'Y' "
     #   ELSE 
     #FUN-C80102--add--end--
     #      LET l_sql = " SELECT COUNT(*) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND abb00 = '",tm.o,"'",
     #                  "    AND aba03 =  ",tm.yy,
     #                  "    AND aba04 = ?",
     #                  "    AND abb05 IS NOT NULL ",
     #                  "    AND abb05 <> ' ' ",
     #                  "    AND abb03 LIKE ? ",
     #                  "    AND ",l_wc2 CLIPPED,
     #                  #"    AND aba19 = 'Y' AND abapost = 'N' "   #FUN-C80102  mark
     #                  "    AND aba19 = 'Y' AND abapost = 'Y' "    #FUN-C80102  add
     #   END IF 
     #END IF 
     #TQC-CC0122--mark--end--
  
     #TQC-CC0122--add--end--
     LET l_sql = " SELECT COUNT(*) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND abb00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND aba04 = ?",
                 "    AND abb05 IS NOT NULL ",
                 "    AND abb05 <> ' ' ",
                 "    AND abb03 LIKE ? ",
                 "    AND ",l_wc2 CLIPPED
     IF tm.a = 'Y' THEN 
        IF tm.b = '1' THEN 
           LET l_sql = l_sql," AND (aba19 = 'N' or aba19 ='Y')"
        ELSE
           LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))"
        END IF 
     END IF 
     IF tm.a = 'N' THEN 
        IF tm.b = '1' THEN 
           LET l_sql = l_sql," AND  aba19 ='Y'"
        ELSE
           LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'"
        END IF 
     END IF  
     #TQC-CC0122--add--str--

     PREPARE gglq703_aao01_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq703_aao01_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq703_aao01_cs2 CURSOR FOR gglq703_aao01_p2
 
     #動態部門title
     #已過帳
     LET l_sql = " SELECT UNIQUE aao02 FROM aao_file ",
                 "  WHERE aao00 = '",tm.o,"'",
                 "    AND aao03 =  ",tm.yy,
                 "    AND aao04 = ?",
                 "    AND aao02 IS NOT NULL ",
                 "    AND ",l_wc1  CLIPPED,
                 "    AND ",tm.wc2 CLIPPED,
                 "  ORDER BY aao02 "
     PREPARE gglq703_aao02_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq703_aao02_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq703_aao02_cs1 CURSOR FOR gglq703_aao02_p1
 
     #tm.b = 'Y' #unposted!
     #TQC-CC0122--mark--end--
     #FUN-C80102--add--str--
     #IF tm.a = 'Y' THEN 
     #   LET l_sql = " SELECT UNIQUE abb05 FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND abb00 = '",tm.o,"'",
     #            "    AND aba03 =  ",tm.yy,
     #            "    AND aba04 = ?",
     #            "    AND abb05 IS NOT NULL ",
     #            "    AND abb03 LIKE ? ",
     #            "    AND aba19 <> 'X' ",   #CHI-C80041
     #            "    AND ",l_wc2 CLIPPED,
     #            "  ORDER BY abb05 "
     #END IF 
     #IF tm.a = 'N' THEN 
     #   IF tm.b = '1' THEN 
     #      LET l_sql = " SELECT UNIQUE abb05 FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND abb00 = '",tm.o,"'",
     #                  "    AND aba03 =  ",tm.yy,
     #                  "    AND aba04 = ?",
     #                  "    AND abb05 IS NOT NULL ",
     #                  "    AND abb03 LIKE ? ",
     #                  "    AND ",l_wc2 CLIPPED,
     #                  "    AND aba19 = 'Y'  ",
     #                  "  ORDER BY abb05 "
     #   ELSE
     #FUN-C80102--add--end--
     #      LET l_sql = " SELECT UNIQUE abb05 FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND abb00 = '",tm.o,"'",
     #                  "    AND aba03 =  ",tm.yy,
     #                  "    AND aba04 = ?",
     #                  "    AND abb05 IS NOT NULL ",
     #                  "    AND abb03 LIKE ? ",
     #                  "    AND ",l_wc2 CLIPPED,
     #                  #"    AND aba19 = 'Y' AND abapost = 'N' ",    #FUN-C80102  mark
     #                  "    AND aba19 = 'Y' AND abapost = 'Y' ",     #FUN-C80102  add
     #                  "  ORDER BY abb05 "
     #    END IF    #FUN-C80102  add
     # END IF       #FUN-C80102  add
     #TQC-CC0122--mark--end--

     #TQC-CC0122--add--str--
      LET l_sql = " SELECT UNIQUE abb05 FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND abb00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND aba04 = ?",
                 "    AND abb05 IS NOT NULL ",
                 "    AND abb03 LIKE ? ",
                 "    AND ",l_wc2 CLIPPED
      IF tm.a = 'Y' THEN 
         IF tm.b = '1' THEN 
            LET l_sql = l_sql," AND (aba19 = 'N' or aba19 ='Y')",
                              "  ORDER BY abb05 "
         ELSE
            LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))",
                              "  ORDER BY abb05 "
         END IF 
      END IF 
      IF tm.a = 'N' THEN 
         IF tm.b = '1' THEN 
            LET l_sql = l_sql," AND  aba19 ='Y'",
                              "  ORDER BY abb05 "
         ELSE
            LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'",
                              "  ORDER BY abb05 "
         END IF 
      END IF  
      #TQC-CC0122--add--end--

     PREPARE gglq703_aao02_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq703_aao02_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq703_aao02_cs2 CURSOR FOR gglq703_aao02_p2
     #TQC-CC0122--mark--end--
     #FUN-C80102--add--str--
     #IF tm.a = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07) FROM aba_file,abb_file",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND aba00 = '",tm.o,"'",
     #            "    AND aba03 =  ",tm.yy,
     #            "    AND aba04 = ?",
     #            "    AND abb03 LIKE ?",
     #            "    AND abb05 = ?",
     #            "    AND abb06 = ?",
     #            "    AND aba19 <> 'X' "   #CHI-C80041
     #END IF 
     #IF tm.a = 'N' THEN 
     #   IF tm.b = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07) FROM aba_file,abb_file",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",tm.o,"'",
     #                  "    AND aba03 =  ",tm.yy,
     #                  "    AND aba04 = ?",
     #                  "    AND abb03 LIKE ?",
     #                  "    AND abb05 = ?",
     #                  "    AND abb06 = ?",
     #                  "    AND aba19 = 'Y' "
     #   ELSE
     #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07) FROM aba_file,abb_file",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",tm.o,"'",
     #                  "    AND aba03 =  ",tm.yy,
     #                  "    AND aba04 = ?",
     #                  "    AND abb03 LIKE ?",
     #                  "    AND abb05 = ?",
     #                  "    AND abb06 = ?",
     #                  #"    AND aba19 = 'Y' AND abapost = 'N'"    #FUN-C80102  mark
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'"     #FUN-C80102  add
     #   END IF   #FUN-C80102  add
     #END IF      #FUN-C80102  add
     #TQC-CC0122--mark--end--

     #TQC-CC0122--add--str--
     LET l_sql = " SELECT SUM(abb07) FROM aba_file ,abb_file",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",tm.o,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND aba04 = ?",
                 "    AND abb03 LIKE ?",
                 "    AND abb05 = ?",
                 "    AND abb06 = ?"
     IF tm.a = 'Y' THEN 
        IF tm.b = '1' THEN 
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.a = 'N' THEN 
        IF tm.b = '1' THEN 
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF 
     END IF 
     #TQC-CC0122--add--end--


     PREPARE gglq703_abb07_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq703_abb07_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq703_abb07_cs CURSOR FOR gglq703_abb07_p
 
 
 
     DECLARE gglq703_aao02_cs CURSOR FOR SELECT aao02 FROM gglq703_aao02
      ORDER BY aao02
 
     DECLARE gglq703_aao01_cs CURSOR FOR SELECT aao01 FROM gglq703_aao01
      ORDER BY aao01
 
     FOR g_i = tm.mm1 TO tm.mm2
         #gem list
         DELETE FROM gglq703_aao02;
         #account list
         DELETE FROM gglq703_aao01;
 
         #部門aao_file
         FOREACH gglq703_aao02_cs1 USING g_i INTO l_aao02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq703_aao02_cs1:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            IF cl_null(l_aao02) THEN CONTINUE FOREACH END IF
            INSERT INTO gglq703_aao02 VALUES(l_aao02)
         END FOREACH
         #科目aao_file
         FOREACH gglq703_aao01_cs1 USING g_i INTO l_aag01
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq703_aao01_cs1:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            IF cl_null(l_aag01) THEN CONTINUE FOREACH END IF
            INSERT INTO gglq703_aao01 VALUES(l_aag01);
         END FOREACH
         #IF tm.b = 'Y' THEN   #FUN-C80102  mark
            LET t_aag01 = NULL
            FOREACH gglq703_aag01_cs INTO t_aag01,l_aag02,l_aag06
               LET l_aag01_str = t_aag01 CLIPPED,"\%"  #No.TQC-A50151
               FOREACH gglq703_aao02_cs2 USING g_i,l_aag01_str INTO l_aao02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach gglq703_aao02_cs2:',SQLCA.sqlcode,0) EXIT FOREACH
                  END IF
                  IF cl_null(l_aao02) THEN CONTINUE FOREACH END IF
                  INSERT INTO gglq703_aao02 VALUES(l_aao02)
               END FOREACH
 
               FOREACH gglq703_aao01_cs2 USING g_i,l_aag01_str INTO l_cnt
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach gglq703_aao01_cs2:',SQLCA.sqlcode,0) EXIT FOREACH
                  END IF
                  IF l_cnt >= 1 THEN
                     INSERT INTO gglq703_aao01 VALUES(t_aag01);
                  END IF
               END FOREACH
            END FOREACH
         #END IF   #FUN-C80102  mark
 
         LET l_i = 1
         CALL g_gem.clear()
         #當前月份的部門明細
         FOREACH gglq703_aao02_cs INTO l_aao02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq703_aao02_cs:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            LET l_gem02 = NULL
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_aao02
            #No.FUN-8A0028  --Begin
            IF SQLCA.sqlcode = 100 THEN
               LET l_gem02 = l_aao02
            END IF
            #No.FUN-8A0028  --End
            LET g_gem[l_i].gem01 = l_aao02
            LET g_gem[l_i].gem02 = l_gem02
            LET l_i = l_i + 1
         END FOREACH
         LET l_cnt = l_i - 1
 
         #每個月的部門title
         INSERT INTO gglq703_title VALUES(g_i,g_gem[01].gem02,
            g_gem[02].gem02, g_gem[03].gem02, g_gem[04].gem02,
            g_gem[05].gem02, g_gem[06].gem02, g_gem[07].gem02,
            g_gem[08].gem02, g_gem[09].gem02, g_gem[10].gem02,
            g_gem[11].gem02, g_gem[12].gem02, g_gem[13].gem02,
            g_gem[14].gem02, g_gem[15].gem02, g_gem[16].gem02,
            g_gem[17].gem02, g_gem[18].gem02, g_gem[19].gem02,
            g_gem[20].gem02, g_gem[21].gem02, g_gem[22].gem02,
            g_gem[23].gem02, g_gem[24].gem02, g_gem[25].gem02,
            g_gem[26].gem02, g_gem[27].gem02, g_gem[28].gem02,
            g_gem[29].gem02, g_gem[30].gem02, g_gem[31].gem02,
            g_gem[32].gem02, g_gem[33].gem02, g_gem[34].gem02,
            g_gem[35].gem02, g_gem[36].gem02, g_gem[37].gem02,
            g_gem[38].gem02, g_gem[39].gem02, g_gem[40].gem02,
            g_gem[41].gem02, g_gem[42].gem02, g_gem[43].gem02,
            g_gem[44].gem02, g_gem[45].gem02, g_gem[46].gem02,
            g_gem[47].gem02, g_gem[48].gem02, g_gem[49].gem02,
            g_gem[50].gem02);
 
         FOREACH gglq703_aao01_cs INTO l_aag01
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq703_aao01_cs:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file
             WHERE aag00 = tm.o
               AND aag01 = l_aag01
            LET l_aag01_str = l_aag01 CLIPPED,'\%'    #No.MOD-940388
 
            CALL l_sum_a.clear()
            LET l_end_sum = 0#FUN-D30041 add
            FOR l_i = 1 TO l_cnt
                LET l_aao05  = 0   LET l_aao06  = 0
                LET l_aao051 = 0   LET l_aao061 = 0
                SELECT SUM(aao05),SUM(aao06) INTO l_aao05,l_aao06
                  FROM aao_file
                 WHERE aao00 = tm.o  AND aao01 = l_aag01
                   AND aao02 = g_gem[l_i].gem01
                   AND aao03 = tm.yy AND aao04 = g_i
                IF cl_null(l_aao05) THEN LET l_aao05 = 0 END IF
                IF cl_null(l_aao06) THEN LET l_aao06 = 0 END IF
                #IF tm.b = 'Y' THEN   #FUN-C80102  mark
                   OPEN gglq703_abb07_cs USING g_i,l_aag01_str,
                                               g_gem[l_i].gem01,'1'
                   FETCH gglq703_abb07_cs INTO l_aao051
                   CLOSE gglq703_abb07_cs
                   IF cl_null(l_aao051) THEN LET l_aao051 = 0 END IF
                   OPEN gglq703_abb07_cs USING g_i,l_aag01_str,
                                               g_gem[l_i].gem01,'2'
                   FETCH gglq703_abb07_cs INTO l_aao061
                   CLOSE gglq703_abb07_cs
                   IF cl_null(l_aao061) THEN LET l_aao061 = 0 END IF
                #END IF   #FUN-C80102  mark
                #No.CHI-C70031  --Begin
                SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
                CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, g_gem[l_i].gem01,g_gem[l_i].gem01,NULL,
                NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
                g_i,       g_i,       NULL,      NULL,     NULL,    NULL,
                NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
                RETURNING  l_abb07,l_abb071,l_aeh15,l_aeh16
                #No.CHI-C70031  --End
                IF tm.i = 'N' THEN     #FUN-D40044 add
                   LET l_sum = l_aao05 - l_aao06 + l_aao051 - l_aao061- l_abb07 + l_abb071    #CHI-C70031 add abb07,abb071
                #FUN-D40044--add--str--
                ELSE
                   LET l_sum = l_aao05 - l_aao06 + l_aao051 - l_aao061
                END IF 
                #FUN-D40044--add--end--
                IF l_aag06 = '2' THEN
                   LET l_sum = l_sum * -1
                END IF
                LET l_sum_a[l_i] = l_sum
                LET l_end_sum = l_end_sum +l_sum_a[l_i]#FUN-D30041 add
                ###TQC-9C0179 START ###
                LET l_aag02_1 = l_aag02[1,30]
                LET l_gem02_1 = g_gem[l_i].gem02[1,30]
                ###TQC-9C0179 END ###
                #EXECUTE insert_prep USING g_i,l_aag01,l_aag02[1,30],g_gem[l_i].gem01,     #MOD-960040 Add g_gem[l_i].gem01 #TQC-9C0179 mark
                #                          g_gem[l_i].gem02[1,30],l_sum                                                     #TQC-9C0179 mark
                EXECUTE insert_prep USING g_i,l_aag01,l_aag02_1,g_gem[l_i].gem01,     #MOD-960040 Add g_gem[l_i].gem01  #TQC-9C0179
                                          l_gem02_1,l_sum          #TQC-9C0179
            END FOR
            #每個月下的單身資料
            #FOR l_i = 1 TO l_cnt   #FUN-C80102  add   #TQC-CC0122 mark
               #INSERT INTO gglq703_tmp VALUES(g_i, l_aag01, l_aag02,g_gem[l_i].gem01,    #FUN-C80102  add  g_gem[l_i].gem01   #TQC-CC0122 mark
               INSERT INTO gglq703_tmp VALUES(g_i, l_aag01, l_aag02,    #FUN-C80102  add  g_gem[l_i].gem01    #TQC-CC0122  add
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
                   l_sum_a[49], l_sum_a[50], l_end_sum);#FUN-D30041 add l_end_sum
            #END FOR    #FUN-C80102  add    #TQC-CC0122  mark
         END FOREACH 
     END FOR
 END FUNCTION
#FUN-D30014--mark--end--
 
FUNCTION q703_out_2()
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc1,'aag01')
           RETURNING g_str
   END IF
   LET g_str=g_str CLIPPED,";",tm.yy,";",g_azi04
 
   CALL cl_prt_cs3('gglq703','gglq703',g_sql,g_str)
END FUNCTION
 
FUNCTION q703_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aao TO s_aao.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL gglq703_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL gglq703_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL gglq703_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL gglq703_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL gglq703_fetch('L')
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
 
FUNCTION gglq703_cs()
     LET g_sql = "SELECT UNIQUE mm FROM gglq703_tmp ",
                 " ORDER BY mm"
     PREPARE gglq703_ps FROM g_sql
     DECLARE gglq703_curs SCROLL CURSOR WITH HOLD FOR gglq703_ps
 
     LET g_sql = "SELECT UNIQUE mm FROM gglq703_tmp ",
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq703_ps1 FROM g_sql
     EXECUTE gglq703_ps1
 
     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq703_ps2 FROM g_sql
     DECLARE gglq703_cnt CURSOR FOR gglq703_ps2
 
     OPEN gglq703_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq703_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq703_cnt
        FETCH gglq703_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq703_fetch('F')
     END IF
END FUNCTION
 
FUNCTION gglq703_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq703_curs INTO g_mm
      WHEN 'P' FETCH PREVIOUS gglq703_curs INTO g_mm
      WHEN 'F' FETCH FIRST    gglq703_curs INTO g_mm
      WHEN 'L' FETCH LAST     gglq703_curs INTO g_mm
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
         FETCH ABSOLUTE g_jump gglq703_curs INTO g_mm
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
 
   CALL gglq703_show()
END FUNCTION
 
FUNCTION gglq703_show()
 
   DISPLAY BY NAME tm.yy
   DISPLAY g_mm TO mm
   #FUN-C80102--add--str--
   DISPLAY tm.o TO o
   DISPLAY tm.mm1 TO mm1
   DISPLAY tm.mm2 TO mm2
   DISPLAY tm.b TO b
   DISPLAY tm.a TO a
   DISPLAY tm.aag09 TO aag09
   DISPLAY tm.aag38 TO aag38
   #CALL cl_set_comp_visible("aao02",FALSE)   #TQC-CC0122  mark
   #FUN-C80102--add--end--
   DISPLAY tm.i    TO i   #FUN-D40044 add
 
   CALL gglq703_b_fill()
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION gglq703_b_fill()
  DEFINE  l_i        LIKE type_file.num5
 
   CALL g_gem.clear()
   SELECT t01,t02,t03,t04,t05,t06,t07,t08,t09,t10,
          t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,
          t21,t22,t23,t24,t25,t26,t27,t28,t29,t30,
          t31,t32,t33,t34,t35,t36,t37,t38,t39,t40,
          t41,t42,t43,t44,t45,t46,t47,t48,t49,t50
     INTO g_gem[01].gem02, g_gem[02].gem02, g_gem[03].gem02,
          g_gem[04].gem02, g_gem[05].gem02, g_gem[06].gem02,
          g_gem[07].gem02, g_gem[08].gem02, g_gem[09].gem02,
          g_gem[10].gem02, g_gem[11].gem02, g_gem[12].gem02,
          g_gem[13].gem02, g_gem[14].gem02, g_gem[15].gem02,
          g_gem[16].gem02, g_gem[17].gem02, g_gem[18].gem02,
          g_gem[19].gem02, g_gem[20].gem02, g_gem[21].gem02,
          g_gem[22].gem02, g_gem[23].gem02, g_gem[24].gem02,
          g_gem[25].gem02, g_gem[26].gem02, g_gem[27].gem02,
          g_gem[28].gem02, g_gem[29].gem02, g_gem[30].gem02,
          g_gem[31].gem02, g_gem[32].gem02, g_gem[33].gem02,
          g_gem[34].gem02, g_gem[35].gem02, g_gem[36].gem02,
          g_gem[37].gem02, g_gem[38].gem02, g_gem[39].gem02,
          g_gem[40].gem02, g_gem[41].gem02, g_gem[42].gem02,
          g_gem[43].gem02, g_gem[44].gem02, g_gem[45].gem02,
          g_gem[46].gem02, g_gem[47].gem02, g_gem[48].gem02,
          g_gem[49].gem02, g_gem[50].gem02
     FROM gglq703_title
    WHERE mm = g_mm
 
   FOR l_i = 1 TO 50
       LET g_field = "d",l_i USING "&<"
      #IF NOT cl_null(g_gem[l_i].gem02) THEN#FUN-D30041 mark
      #可能存在：有部門編號，無部門名稱的情況，所以這邊講cl_null改成is not null
       IF g_gem[l_i].gem02 IS NOT NULL THEN #FUN-D30041 add
          CALL cl_set_comp_att_text(g_field,g_gem[l_i].gem02)
          CALL cl_set_comp_visible(g_field,TRUE)
       ELSE
          CALL cl_set_comp_visible(g_field,FALSE)
       END IF
   END FOR
 
   #LET g_sql = "SELECT aag01,aag02,aao02,d01,d02,d03,d04,d05,d06,d07,d08,d09,d10,",    #FUN-C80102  add  aao02   #TQC-CC0122  mark
   LET g_sql = "SELECT aag01,aag02,d01,d02,d03,d04,d05,d06,d07,d08,d09,d10,",    #FUN-C80102  add  aao02    #TQC-CC0122  add
               "                   d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,",
               "                   d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,",
               "                   d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,",
               "                   d41,d42,d43,d44,d45,d46,d47,d48,d49,d50 ",
               "                  ,l_sum ",#FUN-D30041 add
               "  FROM gglq703_tmp",
               " WHERE mm  = ",g_mm,
               " ORDER BY aag01 "
 
   PREPARE gglq703_pb FROM g_sql
   DECLARE npq_curs  CURSOR FOR gglq703_pb
 
   CALL g_aao.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH npq_curs INTO g_aao[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_aao[g_cnt].d01 = cl_numfor(g_aao[g_cnt].d01,20,g_azi04)
      LET g_aao[g_cnt].d02 = cl_numfor(g_aao[g_cnt].d02,20,g_azi04)
      LET g_aao[g_cnt].d03 = cl_numfor(g_aao[g_cnt].d03,20,g_azi04)
      LET g_aao[g_cnt].d04 = cl_numfor(g_aao[g_cnt].d04,20,g_azi04)
      LET g_aao[g_cnt].d05 = cl_numfor(g_aao[g_cnt].d05,20,g_azi04)
      LET g_aao[g_cnt].d06 = cl_numfor(g_aao[g_cnt].d06,20,g_azi04)
      LET g_aao[g_cnt].d07 = cl_numfor(g_aao[g_cnt].d07,20,g_azi04)
      LET g_aao[g_cnt].d08 = cl_numfor(g_aao[g_cnt].d08,20,g_azi04)
      LET g_aao[g_cnt].d09 = cl_numfor(g_aao[g_cnt].d09,20,g_azi04)
      LET g_aao[g_cnt].d10 = cl_numfor(g_aao[g_cnt].d10,20,g_azi04)
      LET g_aao[g_cnt].d11 = cl_numfor(g_aao[g_cnt].d11,20,g_azi04)
      LET g_aao[g_cnt].d12 = cl_numfor(g_aao[g_cnt].d12,20,g_azi04)
      LET g_aao[g_cnt].d13 = cl_numfor(g_aao[g_cnt].d13,20,g_azi04)
      LET g_aao[g_cnt].d14 = cl_numfor(g_aao[g_cnt].d14,20,g_azi04)
      LET g_aao[g_cnt].d15 = cl_numfor(g_aao[g_cnt].d15,20,g_azi04)
      LET g_aao[g_cnt].d16 = cl_numfor(g_aao[g_cnt].d16,20,g_azi04)
      LET g_aao[g_cnt].d17 = cl_numfor(g_aao[g_cnt].d17,20,g_azi04)
      LET g_aao[g_cnt].d18 = cl_numfor(g_aao[g_cnt].d18,20,g_azi04)
      LET g_aao[g_cnt].d19 = cl_numfor(g_aao[g_cnt].d19,20,g_azi04)
      LET g_aao[g_cnt].d20 = cl_numfor(g_aao[g_cnt].d20,20,g_azi04)
      LET g_aao[g_cnt].d21 = cl_numfor(g_aao[g_cnt].d21,20,g_azi04)
      LET g_aao[g_cnt].d22 = cl_numfor(g_aao[g_cnt].d22,20,g_azi04)
      LET g_aao[g_cnt].d23 = cl_numfor(g_aao[g_cnt].d23,20,g_azi04)
      LET g_aao[g_cnt].d24 = cl_numfor(g_aao[g_cnt].d24,20,g_azi04)
      LET g_aao[g_cnt].d25 = cl_numfor(g_aao[g_cnt].d25,20,g_azi04)
      LET g_aao[g_cnt].d26 = cl_numfor(g_aao[g_cnt].d26,20,g_azi04)
      LET g_aao[g_cnt].d27 = cl_numfor(g_aao[g_cnt].d27,20,g_azi04)
      LET g_aao[g_cnt].d28 = cl_numfor(g_aao[g_cnt].d28,20,g_azi04)
      LET g_aao[g_cnt].d29 = cl_numfor(g_aao[g_cnt].d29,20,g_azi04)
      LET g_aao[g_cnt].d30 = cl_numfor(g_aao[g_cnt].d30,20,g_azi04)
      LET g_aao[g_cnt].d31 = cl_numfor(g_aao[g_cnt].d31,20,g_azi04)
      LET g_aao[g_cnt].d32 = cl_numfor(g_aao[g_cnt].d32,20,g_azi04)
      LET g_aao[g_cnt].d33 = cl_numfor(g_aao[g_cnt].d33,20,g_azi04)
      LET g_aao[g_cnt].d34 = cl_numfor(g_aao[g_cnt].d34,20,g_azi04)
      LET g_aao[g_cnt].d35 = cl_numfor(g_aao[g_cnt].d35,20,g_azi04)
      LET g_aao[g_cnt].d36 = cl_numfor(g_aao[g_cnt].d36,20,g_azi04)
      LET g_aao[g_cnt].d37 = cl_numfor(g_aao[g_cnt].d37,20,g_azi04)
      LET g_aao[g_cnt].d38 = cl_numfor(g_aao[g_cnt].d38,20,g_azi04)
      LET g_aao[g_cnt].d39 = cl_numfor(g_aao[g_cnt].d39,20,g_azi04)
      LET g_aao[g_cnt].d40 = cl_numfor(g_aao[g_cnt].d40,20,g_azi04)
      LET g_aao[g_cnt].d41 = cl_numfor(g_aao[g_cnt].d41,20,g_azi04)
      LET g_aao[g_cnt].d42 = cl_numfor(g_aao[g_cnt].d42,20,g_azi04)
      LET g_aao[g_cnt].d43 = cl_numfor(g_aao[g_cnt].d43,20,g_azi04)
      LET g_aao[g_cnt].d44 = cl_numfor(g_aao[g_cnt].d44,20,g_azi04)
      LET g_aao[g_cnt].d45 = cl_numfor(g_aao[g_cnt].d45,20,g_azi04)
      LET g_aao[g_cnt].d46 = cl_numfor(g_aao[g_cnt].d46,20,g_azi04)
      LET g_aao[g_cnt].d47 = cl_numfor(g_aao[g_cnt].d47,20,g_azi04)
      LET g_aao[g_cnt].d48 = cl_numfor(g_aao[g_cnt].d48,20,g_azi04)
      LET g_aao[g_cnt].d49 = cl_numfor(g_aao[g_cnt].d49,20,g_azi04)
      LET g_aao[g_cnt].d50 = cl_numfor(g_aao[g_cnt].d50,20,g_azi04)
      LET g_aao[g_cnt].l_sum = cl_numfor(g_aao[g_cnt].l_sum,20,g_azi04)#FUN-D30041 add
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_aao.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
FUNCTION gglq703_table()
     DROP TABLE gglq703_aao02;
     CREATE TEMP TABLE gglq703_aao02(
                    aao02       LIKE aao_file.aao02);
     CREATE UNIQUE INDEX gglq703_aao02_01 ON gglq703_aao02(aao02);
 
     DROP TABLE gglq703_aao01;
     CREATE TEMP TABLE gglq703_aao01(
                    aao01       LIKE aao_file.aao01);
     CREATE UNIQUE INDEX gglq703_aao01_01 ON gglq703_aao01(aao01);
 
     DROP TABLE gglq703_title;
     CREATE TEMP TABLE gglq703_title(
                    mm          LIKE type_file.num5,
                    t01         LIKE gem_file.gem02,
                    t02         LIKE gem_file.gem02,
                    t03         LIKE gem_file.gem02,
                    t04         LIKE gem_file.gem02,
                    t05         LIKE gem_file.gem02,
                    t06         LIKE gem_file.gem02,
                    t07         LIKE gem_file.gem02,
                    t08         LIKE gem_file.gem02,
                    t09         LIKE gem_file.gem02,
                    t10         LIKE gem_file.gem02,
                    t11         LIKE gem_file.gem02,
                    t12         LIKE gem_file.gem02,
                    t13         LIKE gem_file.gem02,
                    t14         LIKE gem_file.gem02,
                    t15         LIKE gem_file.gem02,
                    t16         LIKE gem_file.gem02,
                    t17         LIKE gem_file.gem02,
                    t18         LIKE gem_file.gem02,
                    t19         LIKE gem_file.gem02,
                    t20         LIKE gem_file.gem02,
                    t21         LIKE gem_file.gem02,
                    t22         LIKE gem_file.gem02,
                    t23         LIKE gem_file.gem02,
                    t24         LIKE gem_file.gem02,
                    t25         LIKE gem_file.gem02,
                    t26         LIKE gem_file.gem02,
                    t27         LIKE gem_file.gem02,
                    t28         LIKE gem_file.gem02,
                    t29         LIKE gem_file.gem02,
                    t30         LIKE gem_file.gem02,
                    t31         LIKE gem_file.gem02,
                    t32         LIKE gem_file.gem02,
                    t33         LIKE gem_file.gem02,
                    t34         LIKE gem_file.gem02,
                    t35         LIKE gem_file.gem02,
                    t36         LIKE gem_file.gem02,
                    t37         LIKE gem_file.gem02,
                    t38         LIKE gem_file.gem02,
                    t39         LIKE gem_file.gem02,
                    t40         LIKE gem_file.gem02,
                    t41         LIKE gem_file.gem02,
                    t42         LIKE gem_file.gem02,
                    t43         LIKE gem_file.gem02,
                    t44         LIKE gem_file.gem02,
                    t45         LIKE gem_file.gem02,
                    t46         LIKE gem_file.gem02,
                    t47         LIKE gem_file.gem02,
                    t48         LIKE gem_file.gem02,
                    t49         LIKE gem_file.gem02,
                    t50         LIKE gem_file.gem02);
     DROP TABLE gglq703_tmp;
     CREATE TEMP TABLE gglq703_tmp(
                    mm          LIKE type_file.num5,
                    aag01       LIKE aag_file.aag01,
#                   aag02       LIKE aag_file.aag02,
                    aag02       LIKE type_file.chr1000,      #No.MOD-940388
                    d01         LIKE aao_file.aao05,
                    d02         LIKE aao_file.aao05,
                    d03         LIKE aao_file.aao05,
                    d04         LIKE aao_file.aao05,
                    d05         LIKE aao_file.aao05,
                    d06         LIKE aao_file.aao05,
                    d07         LIKE aao_file.aao05,
                    d08         LIKE aao_file.aao05,
                    d09         LIKE aao_file.aao05,
                    d10         LIKE aao_file.aao05,
                    d11         LIKE aao_file.aao05,
                    d12         LIKE aao_file.aao05,
                    d13         LIKE aao_file.aao05,
                    d14         LIKE aao_file.aao05,
                    d15         LIKE aao_file.aao05,
                    d16         LIKE aao_file.aao05,
                    d17         LIKE aao_file.aao05,
                    d18         LIKE aao_file.aao05,
                    d19         LIKE aao_file.aao05,
                    d20         LIKE aao_file.aao05,
                    d21         LIKE aao_file.aao05,
                    d22         LIKE aao_file.aao05,
                    d23         LIKE aao_file.aao05,
                    d24         LIKE aao_file.aao05,
                    d25         LIKE aao_file.aao05,
                    d26         LIKE aao_file.aao05,
                    d27         LIKE aao_file.aao05,
                    d28         LIKE aao_file.aao05,
                    d29         LIKE aao_file.aao05,
                    d30         LIKE aao_file.aao05,
                    d31         LIKE aao_file.aao05,
                    d32         LIKE aao_file.aao05,
                    d33         LIKE aao_file.aao05,
                    d34         LIKE aao_file.aao05,
                    d35         LIKE aao_file.aao05,
                    d36         LIKE aao_file.aao05,
                    d37         LIKE aao_file.aao05,
                    d38         LIKE aao_file.aao05,
                    d39         LIKE aao_file.aao05,
                    d40         LIKE aao_file.aao05,
                    d41         LIKE aao_file.aao05,
                    d42         LIKE aao_file.aao05,
                    d43         LIKE aao_file.aao05,
                    d44         LIKE aao_file.aao05,
                    d45         LIKE aao_file.aao05,
                    d46         LIKE aao_file.aao05,
                    d47         LIKE aao_file.aao05,
                    d48         LIKE aao_file.aao05,
                    d49         LIKE aao_file.aao05,
                    d50         LIKE aao_file.aao05,
                    l_sum       LIKE type_file.num20_6);#FUN-D30041 add
END FUNCTION
 
