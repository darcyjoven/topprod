# Prog. Version..: '5.30.07-13.05.20(00010)'     #
# Pattern name...: gglq307.4gl
# Descriptions...: 科目余額表查詢
# Date & Author..: 09/10/22 by Carrier  #No.FUN-9A0052
# Modify.........: No.FUN-A40020 10/04/09 By Carrier 独立科目层及设置为1 & 画面增加打印层级
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.FUN-B20055 11/02/22 By destiny 輸入改為DIALOG寫法 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No:MOD-B70188 11/07/19 By Carrier 将借贷方向show出来
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
# Modify.........: No:MOD-C30751 12/03/16 By minpp 程序中拿掉 aag03 = '2' 的条件
# Modify.........: No.MOD-C40185 12/04/24 By Polly PREPARE gglq307_pre 取消aaa14/aaa15條件
# Modify.........: No.TQC-C60238 12/06/28 By lujh  右側按鈕【總分類帳查詢】串查gglq300時傳tm.g給tm.u不對，應該根據tm.g的值傳N/Y給tm.u
# Modify.........: No:CHI-C70031 12/10/18 By fengmy 去除CE、CA憑證資料，否則月末結轉損益後，查詢不到損益類科目
# Modify.........: No.FUN-C80102 12/10/16 By zhangweib 財務報表改善追單
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.TQC-CC0122 13/01/10 By lujh 1、核算項明細分類帳查詢串查有問題  2、單身下查詢條件查不到值 3、agls103中顯示核算項名稱aaz119=N時，隱藏核算項名稱
# Modify.........: No.FUN-D10072 13/01/17 By lujh 1、串查gglq300時 tm.t默認給Y,2、根據不同單據狀態，傳不同的參數
# Modify.........: No:FUN-D40044 13/04/26 By lujh 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額

DATABASE ds

GLOBALS "../../config/top.global"  #No.FUN-9A0052

DEFINE tm             RECORD
                      wc      STRING,
                      wc1     STRING,
                      wc3     STRING , #add by dengsy170304
                      bookno  LIKE aaa_file.aaa01,
                      yy      LIKE type_file.num5,
                      m1      LIKE type_file.num5,
                      m2      LIKE type_file.num5,
                      s1      LIKE type_file.chr1,  #排序1
                      s2      LIKE type_file.chr1,  #排序2
                      s3      LIKE type_file.chr1,  #排序3
                      a       LIKE type_file.chr1,  #包括所有科目
                      b       LIKE type_file.chr1,  #包括本年有異動
                      e       LIKE type_file.chr1,  #包括無效科目
                      f       LIKE type_file.chr1,  #打印額外名稱
                      i       LIKE type_file.chr1,  #打印外幣
                      lvl     LIKE type_file.num5,  #No.FUN-A40020
                      g       LIKE type_file.chr1,  #資料選項-含未過帳資料
                      h       LIKE type_file.chr1,  #FUN-D40044  add
                      more    LIKE type_file.chr1
                      END RECORD
DEFINE g_i            LIKE type_file.num5
DEFINE l_table        STRING
DEFINE g_str          STRING
DEFINE g_sql          STRING
DEFINE g_rec_b        LIKE type_file.num10
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_aeh          DYNAMIC ARRAY OF RECORD
                      aeh01     LIKE aeh_file.aeh01,
                      aag02     LIKE aag_file.aag02,
                      tt1       LIKE abb_file.abb11,
                      tt1_d     LIKE aee_file.aee04,
                      tt2       LIKE abb_file.abb11,
                      tt2_d     LIKE aee_file.aee04,
                      tt3       LIKE abb_file.abb11,
                      tt3_d     LIKE aee_file.aee04,
                      tt4       LIKE abb_file.abb11,
                      tt4_d     LIKE aee_file.aee04,
                      tt5       LIKE abb_file.abb11,
                      tt5_d     LIKE aee_file.aee04,
                      tt6       LIKE abb_file.abb11,
                      tt6_d     LIKE aee_file.aee04,
                      tt7       LIKE abb_file.abb11,
                      tt7_d     LIKE aee_file.aee04,
                      tt8       LIKE abb_file.abb11,
                      tt8_d     LIKE aee_file.aee04,
                      tt9       LIKE abb_file.abb11,
                      tt9_d     LIKE aee_file.aee04,
                      tt10      LIKE abb_file.abb11,
                      tt10_d    LIKE aee_file.aee04,
                      tt11      LIKE abb_file.abb11,
                      tt11_d    LIKE aee_file.aee04,
                      tt12      LIKE abb_file.abb11,
                      tt12_d    LIKE aee_file.aee04,
                      aeh17     LIKE aeh_file.aeh17,   #幣種
                      dc_qc     LIKE type_file.chr10,  #期初借/貸方向
                      balf_qc   LIKE aah_file.aah04,   #期初原幣余額
                      er_qc     LIKE abb_file.abb25,   #期初匯率
                      bal_qc    LIKE aah_file.aah04,   #期初本幣余額
                      df_qj     LIKE aah_file.aah04,   #期間原幣借方
                      er_d_qj   LIKE abb_file.abb25,   #期間借匯率
                      d_qj      LIKE aah_file.aah04,   #期間本幣借方
                      cf_qj     LIKE aah_file.aah04,   #期間原幣貸方
                      er_c_qj   LIKE abb_file.abb25,   #期間貸匯率
                      c_qj      LIKE aah_file.aah04,   #期間本幣貸方
                      dc_qm     LIKE type_file.chr10,  #期末借/貸方向
                      balf_qm   LIKE aah_file.aah04,   #期末原幣余額
                      er_qm     LIKE abb_file.abb25,   #期末匯率
                      bal_qm    LIKE aah_file.aah04    #期末本幣余額
                      END RECORD
DEFINE g_pr           RECORD
                      aeh01     LIKE aeh_file.aeh01,
                      aag02     LIKE aag_file.aag02,
                      type      LIKE type_file.chr10,
                      memo      LIKE type_file.chr50,
                      tt1       LIKE abb_file.abb11,
                      tt1_d     LIKE aee_file.aee04,
                      tt2       LIKE abb_file.abb11,
                      tt2_d     LIKE aee_file.aee04,
                      tt3       LIKE abb_file.abb11,
                      tt3_d     LIKE aee_file.aee04,
                      tt4       LIKE abb_file.abb11,
                      tt4_d     LIKE aee_file.aee04,
                      tt5       LIKE abb_file.abb11,
                      tt5_d     LIKE aee_file.aee04,
                      tt6       LIKE abb_file.abb11,
                      tt6_d     LIKE aee_file.aee04,
                      tt7       LIKE abb_file.abb11,
                      tt7_d     LIKE aee_file.aee04,
                      tt8       LIKE abb_file.abb11,
                      tt8_d     LIKE aee_file.aee04,
                      tt9       LIKE abb_file.abb11,
                      tt9_d     LIKE aee_file.aee04,
                      tt10      LIKE abb_file.abb11,
                      tt10_d    LIKE aee_file.aee04,
                      tt11      LIKE abb_file.abb11,
                      tt11_d    LIKE aee_file.aee04,
                      tt12      LIKE abb_file.abb11,
                      tt12_d    LIKE aee_file.aee04,
                      aeh17     LIKE aeh_file.aeh17,   #幣種
                      dc_qc     LIKE type_file.chr10,  #期初借/貸方向
                      balf_qc   LIKE aah_file.aah04,   #期初原幣余額
                      er_qc     LIKE abb_file.abb25,   #期初匯率
                      bal_qc    LIKE aah_file.aah04,   #期初本幣余額
                      df_qj     LIKE aah_file.aah04,   #期間原幣借方
                      er_d_qj   LIKE abb_file.abb25,   #期間借匯率
                      d_qj      LIKE aah_file.aah04,   #期間本幣借方
                      cf_qj     LIKE aah_file.aah04,   #期間原幣貸方
                      er_c_qj   LIKE abb_file.abb25,   #期間貸匯率
                      c_qj      LIKE aah_file.aah04,   #期間本幣貸方
                      dc_qm     LIKE type_file.chr10,  #期末借/貸方向
                      balf_qm   LIKE aah_file.aah04,   #期末原幣余額
                      er_qm     LIKE abb_file.abb25,   #期末匯率
                      bal_qm    LIKE aah_file.aah04    #期末本幣余額
                      END RECORD
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE l_ac           LIKE type_file.num5
DEFINE l_ac1          LIKE type_file.num5
DEFINE g_aaa          RECORD LIKE aaa_file.*           #FUN-BC0027 
DEFINE g_comb         ui.ComboBox           #FUN-C80102 add

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.bookno  = ARG_VAL(7)
   LET tm.yy      = ARG_VAL(8)
   LET tm.m1      = ARG_VAL(9)
   LET tm.m2      = ARG_VAL(10)
   LET tm.s1      = ARG_VAL(11)
   LET tm.s2      = ARG_VAL(12)
   LET tm.s3      = ARG_VAL(13)
   #FUN-C80102--mod--str--
   #LET tm.a       = ARG_VAL(14)      #FUN-C80102  mark
   LET tm.b       = ARG_VAL(14)
   #LET tm.e       = ARG_VAL(16)      #FUN-C80102  mark
   LET tm.f       = ARG_VAL(15)
   LET tm.g       = ARG_VAL(16)
   LET tm.lvl     = ARG_VAL(17)   #No.FUN-A40020
   LET tm.i       = ARG_VAL(18)
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET g_rpt_name = ARG_VAL(22)
   #FUN-C80102--mod--end--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL q307_out_1()  #建立臨時表

   OPEN WINDOW q307_w AT 5,10
        WITH FORM "ggl/42f/gglq307_1" ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()
   CALL q307_ui_setting()

   #FUN-C80102--add--str---
   CALL cl_set_comp_visible('tt6,tt10,tt11,tt12',FALSE)
   CALL cl_set_comp_visible('tt6_d,tt10_d,tt11_d,tt12_d',FALSE)
   #FUN-C80102--add--end---

   IF cl_null(tm.yy) THEN
      INITIALIZE tm.* TO NULL
      LET tm.bookno = g_aza.aza81
      #FUN-C80102--mark--str---
      #LET tm.yy     = YEAR(g_today)
      #LET tm.m1     = MONTH(g_today)
      #LET tm.m2     = MONTH(g_today)
      #FUN-C80102--mark--end---
      #FUN-C80102--add--str---
      LET tm.yy     = s_get_aznn(g_plant,g_aza.aza81,g_today,1)
      LET tm.m1     = s_get_aznn(g_plant,g_aza.aza81,g_today,3)
      LET tm.m2     = s_get_aznn(g_plant,g_aza.aza81,g_today,3)
      #FUN-C80102--add--end---
      LET tm.s1     = '1'
      LET tm.s2     = '2'
      LET tm.s3     = ''
      #LET tm.a      = 'N'    #FUN-C80102  mark
      LET tm.b      = 'Y'
      #LET tm.e      = 'N'    #FUN-C80102  mark
      LET tm.f      = 'N'
      LET tm.g      = '1'
      #LET tm.lvl    =  1    #No.FUN-A40020   #FUN-C80102  mark
      LET tm.lvl    =  '99'  #FUN-C80102  add
      LET tm.i      = 'N'
      LET tm.more   = 'N'
      LET g_pdate   = g_today
      LET g_rlang   = g_lang
      LET g_bgjob   = 'N'
      LET g_copies  = '1'
      LET tm.h ='N'                #FUN-D40044  add
      CALL gglq307_tm(0,0)
   ELSE
      CALL gglq307()
   END IF

   CALL q307_menu()
   DROP TABLE gglq307_tmp;
   CLOSE WINDOW q307_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q307_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL q307_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq307_tm(0,0)
            END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL q307_out_2()
#           END IF
         WHEN "drill_general_ledger"
            IF cl_chk_act_auth() THEN
               LET l_ac1 = l_ac  #check drill down focus which row?
               CALL q307_drill_gl()
            END IF
         WHEN "drill_general_ledger_702"
            IF cl_chk_act_auth() THEN
               LET l_ac1 = l_ac  #check drill down focus which row?
               CALL q307_drill_gl2()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_aeh),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               CALL cl_doc()
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION gglq307_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_flag         LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5

   CLEAR FORM #清除畫面   #FUN-C80102  add
   CALL g_aeh.clear()   #FUN-C80102  add

   #FUN-C80102--mark--str---
   #LET p_row = 4 LET p_col =25

   #OPEN WINDOW gglq307_w AT p_row,p_col WITH FORM "ggl/42f/gglq307"
   #     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   #CALL cl_ui_locale("gglq307")
   #FUN-C80102--mark--end---
   CALL q307_ui_setting_1()

   #FUN-C80102---add----str---
   LET g_comb = ui.ComboBox.forName("s1")
   IF g_aaz.aaz88 = '0' THEN
      CALL g_comb.removeItem('2')
      CALL g_comb.removeItem('3')
      CALL g_comb.removeItem('4')
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz88 = '3' THEN
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz88 = '2' THEN
      CALL g_comb.removeItem('4')
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz88 = '1' THEN
      CALL g_comb.removeItem('3')
      CALL g_comb.removeItem('4')
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz125 = '5' THEN
      CALL g_comb.removeItem('7')
      CALL g_comb.removeItem('8')
      CALL g_comb.removeItem('9')
   END IF
   IF g_aaz.aaz125 = '6' THEN
      CALL g_comb.removeItem('8')
      CALL g_comb.removeItem('9')
   END IF
   IF g_aaz.aaz125 = '7' THEN
      CALL g_comb.removeItem('9')
   END IF

   LET g_comb = ui.ComboBox.forName("s2")
   IF g_aaz.aaz88 = '0' THEN
      CALL g_comb.removeItem('2')
      CALL g_comb.removeItem('3')
      CALL g_comb.removeItem('4')
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz88 = '3' THEN
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz88 = '2' THEN
      CALL g_comb.removeItem('4')
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz88 = '1' THEN
      CALL g_comb.removeItem('3')
      CALL g_comb.removeItem('4')
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz125 = '5' THEN
      CALL g_comb.removeItem('7')
      CALL g_comb.removeItem('8')
      CALL g_comb.removeItem('9')
   END IF
   IF g_aaz.aaz125 = '6' THEN
      CALL g_comb.removeItem('8')
      CALL g_comb.removeItem('9')
   END IF
   IF g_aaz.aaz125 = '7' THEN
      CALL g_comb.removeItem('9')
   END IF

   LET g_comb = ui.ComboBox.forName("s3")
   IF g_aaz.aaz88 = '0' THEN
      CALL g_comb.removeItem('2')
      CALL g_comb.removeItem('3')
      CALL g_comb.removeItem('4')
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz88 = '3' THEN
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz88 = '2' THEN
      CALL g_comb.removeItem('4')
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz88 = '1' THEN
      CALL g_comb.removeItem('3')
      CALL g_comb.removeItem('4')
      CALL g_comb.removeItem('5')
   END IF
   IF g_aaz.aaz125 = '5' THEN
      CALL g_comb.removeItem('7')
      CALL g_comb.removeItem('8')
      CALL g_comb.removeItem('9')
   END IF
   IF g_aaz.aaz125 = '6' THEN
      CALL g_comb.removeItem('8')
      CALL g_comb.removeItem('9')
   END IF
   IF g_aaz.aaz125 = '7' THEN
      CALL g_comb.removeItem('9')
   END IF
#FUN-C80102---add----end---
   
   CALL cl_opmsg('p')
   WHILE TRUE
   #FUN-B20055--begin
        #No.FUN-B20010  --Begin
#        INPUT BY NAME tm.bookno WITHOUT DEFAULTS
#
#         BEFORE INPUT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
#
#         AFTER FIELD bookno
#            IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
#            CALL s_check_bookno(tm.bookno,g_user,g_plant)
#                 RETURNING li_chk_bookno
#            IF (NOT li_chk_bookno) THEN
#               NEXT FIELD bookno
#            END IF
#            SELECT * FROM aaa_file WHERE aaa01 = tm.bookno AND aaaacti = 'Y'
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
#               NEXT FIELD bookno
#            END IF        
#
#         ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(bookno)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_aaa'
#                  CALL cl_create_qry() RETURNING tm.bookno
#                  DISPLAY BY NAME tm.bookno
#                  NEXT FIELD bookno
#            END CASE
#
#         ON ACTION CONTROLZ
#            CALL cl_show_req_fields()
#
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
#
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
#
#         ON ACTION about
#            CALL cl_about()
#
#         ON ACTION help
#            CALL cl_show_help()
#
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
#
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#
#      END INPUT
#      #No.FUN-B20010  --End
#      
#      CONSTRUCT BY NAME tm.wc ON aag01
#         ON ACTION locale
#            CALL cl_show_fld_cont()
#            LET g_action_choice = "locale"
#            EXIT CONSTRUCT
#
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
#
#         ON ACTION about
#            CALL cl_about()
#
#         ON ACTION help
#            CALL cl_show_help()
#
#         ON ACTION controlg
#            CALL cl_cmdask()
#
#         ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(aag01)     #科目代號
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aag'
#                  LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"   #FUN-B20010 add                  
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aag01
#                  NEXT FIELD aag01
#            END CASE
#
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
#      END CONSTRUCT
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
#
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 CLOSE WINDOW gglq301_w1 EXIT PROGRAM
#      END IF
#
#      CONSTRUCT BY NAME tm.wc1 ON aeh02,aeh37,aeh04,aeh05,aeh06,aeh07,
#                                  aeh31,aeh32,aeh33,aeh34,aeh35,aeh36
#         ON ACTION locale
#            CALL cl_show_fld_cont()
#            LET g_action_choice = "locale"
#            EXIT CONSTRUCT
#
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
#
#         ON ACTION about
#            CALL cl_about()
#
#         ON ACTION help
#            CALL cl_show_help()
#
#         ON ACTION controlg
#            CALL cl_cmdask()
#
#         ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(aeh02)     #部門
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh02'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh02
#                  NEXT FIELD aeh02
#               WHEN INFIELD(aeh04)     #核算項1
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh04'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh04
#                  NEXT FIELD aeh04
#               WHEN INFIELD(aeh05)     #核算項2
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh05'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh05
#                  NEXT FIELD aeh05
#               WHEN INFIELD(aeh06)     #核算項3
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh06'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh06
#                  NEXT FIELD aeh06
#               WHEN INFIELD(aeh07)     #核算項4
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh07'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh07
#                  NEXT FIELD aeh07
#               WHEN INFIELD(aeh31)     #核算項5
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh31'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh31
#                  NEXT FIELD aeh31
#               WHEN INFIELD(aeh32)     #核算項6
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh32'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh32
#                  NEXT FIELD aeh32
#               WHEN INFIELD(aeh33)     #核算項7
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh33'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh33
#                  NEXT FIELD aeh33
#               WHEN INFIELD(aeh34)     #核算項8
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh34'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh34
#                  NEXT FIELD aeh34
#               WHEN INFIELD(aeh35)     #核算項9
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh35'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh35
#                  NEXT FIELD aeh35
#               WHEN INFIELD(aeh36)     #核算項10
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh36'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh36
#                  NEXT FIELD aeh36
#               WHEN INFIELD(aeh37)     #核算項-關系人
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aeh37'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aeh37
#                  NEXT FIELD aeh37
#            END CASE
#
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
#      END CONSTRUCT
#
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 CLOSE WINDOW gglq301_w1 EXIT PROGRAM
#      END IF
#      #INPUT BY NAME tm.bookno,tm.yy,tm.m1,tm.m2,  #No.FUN-B20010 mark
#      INPUT BY NAME tm.yy,tm.m1,tm.m2,             #No.FUN-B20010
#                    tm.s1,tm.s2,tm.s3,
#                    tm.a,tm.b,tm.e,
#                    tm.f,tm.i,tm.lvl,tm.g,tm.more WITHOUT DEFAULTS  #No.FUN-A40020
#
#         BEFORE INPUT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
#
#         AFTER FIELD yy
#            IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
#            IF tm.yy <= 0 THEN NEXT FIELD yy END IF
#
#         AFTER FIELD m1
#            IF cl_null(tm.m1) OR tm.m1 > 13 OR tm.m1 < 1 THEN
#               NEXT FIELD m1
#            END IF
#
#         AFTER FIELD m2
#            IF cl_null(tm.m2) OR tm.m2 > 13 OR tm.m2 < 1 OR tm.m2 < tm.m1 THEN
#               NEXT FIELD m2
#            END IF
#
#         #No.FUN-A40020  --Begin                                                
#         AFTER FIELD lvl                                                        
#            IF NOT cl_null(tm.lvl) THEN                                         
#               IF tm.lvl <= 0 THEN                                              
#                  NEXT FIELD lvl                                                
#               END IF                                                           
#            END IF                                                              
#         #No.FUN-A40020  --End
#        
#        #No.FUN-A40020  --Begin
#        #AFTER FIELD bookno
#        #   IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
#        #   CALL s_check_bookno(tm.bookno,g_user,g_plant)
#        #        RETURNING li_chk_bookno
#        #   IF (NOT li_chk_bookno) THEN
#        #      NEXT FIELD bookno
#        #   END IF
#        #   SELECT * FROM aaa_file WHERE aaa01 = tm.bookno AND aaaacti = 'Y'
#        #   IF SQLCA.sqlcode THEN
#        #      CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
#        #      NEXT FIELD bookno
#        #   END IF
#        #No.FUN-A40020  --End 
#        
#        AFTER FIELD more
#            IF tm.more = 'Y'
#               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                                   g_bgjob,g_time,g_prtway,g_copies)
#                         RETURNING g_pdate,g_towhom,g_rlang,
#                                   g_bgjob,g_time,g_prtway,g_copies
#            END IF
#
#         AFTER INPUT
#            IF NOT cl_null(tm.m2) AND NOT cl_null(tm.m1) THEN
#               IF tm.m1 > tm.m2 THEN
#                  NEXT FIELD m1
#               END IF
#            END IF
#         
#         #No.FUN-B20010  --Begin
#         #ON ACTION CONTROLP
#         #   CASE
#         #      WHEN INFIELD(bookno)
#         #         CALL cl_init_qry_var()
#         #         LET g_qryparam.form = 'q_aaa'
#         #         CALL cl_create_qry() RETURNING tm.bookno
#         #         DISPLAY BY NAME tm.bookno
#         #         NEXT FIELD bookno
#         #   END CASE
#         #No.FUN-B20010  --End
#
#         ON ACTION CONTROLZ
#            CALL cl_show_req_fields()
#
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
#
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
#
#         ON ACTION about
#            CALL cl_about()
#
#         ON ACTION help
#            CALL cl_show_help()
#
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
#
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#
#      END INPUT
       #FUN-C80102--mark--str---
       #DIALOG ATTRIBUTES(UNBUFFERED)
       # INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

       #  BEFORE INPUT
       #     CALL cl_qbe_display_condition(lc_qbe_sn)

       #  AFTER FIELD bookno
       #     IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
       #     CALL s_check_bookno(tm.bookno,g_user,g_plant)
       #          RETURNING li_chk_bookno
       #     IF (NOT li_chk_bookno) THEN
       #        NEXT FIELD bookno
       #     END IF
       #     SELECT * FROM aaa_file WHERE aaa01 = tm.bookno AND aaaacti = 'Y'
       #     IF SQLCA.sqlcode THEN
       #        CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
       #        NEXT FIELD bookno
       #     END IF        

      #END INPUT
      
      #CONSTRUCT BY NAME tm.wc ON aag01

      #END CONSTRUCT

      #CONSTRUCT BY NAME tm.wc1 ON aeh02,aeh37,aeh04,aeh05,aeh06,aeh07,
      #                            aeh31,aeh32,aeh33,aeh34,aeh35,aeh36
          
      #END CONSTRUCT

      #INPUT BY NAME tm.bookno,tm.yy,tm.m1,tm.m2,            
      #              tm.s1,tm.s2,tm.s3,
      #              tm.a,tm.b,tm.e,
      #              tm.f,tm.i,tm.lvl,tm.g,tm.more ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
      #FUN-C80102--mark--end---

      #FUN-C80102--add--str---
      DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT BY NAME tm.bookno,tm.yy,tm.m1,tm.m2,            
                    tm.s1,tm.s2,tm.s3,tm.i,
                    tm.b,tm.f,tm.lvl,tm.g,tm.h ATTRIBUTE(WITHOUT DEFAULTS=TRUE)   #FUN-D40044 add tm.h
      #FUN-C80102--add--end---

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         #FUN-C80102--add--str---
         AFTER FIELD bookno
            IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
            CALL s_check_bookno(tm.bookno,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD bookno
            END IF
            SELECT * FROM aaa_file WHERE aaa01 = tm.bookno AND aaaacti = 'Y'
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
               NEXT FIELD bookno
            END IF
         #FUN-C80102--add--end---

         AFTER FIELD yy
            IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
            IF tm.yy <= 0 THEN NEXT FIELD yy END IF

         AFTER FIELD m1
            IF cl_null(tm.m1) OR tm.m1 > 13 OR tm.m1 < 1 THEN
               NEXT FIELD m1
            END IF

         AFTER FIELD m2
            IF cl_null(tm.m2) OR tm.m2 > 13 OR tm.m2 < 1 OR tm.m2 < tm.m1 THEN
               NEXT FIELD m2
            END IF

         #FUN-C80102--add--str--
         ON CHANGE i
           IF tm.i NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD i 
           END IF 

         ON CHANGE b
           IF tm.b NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD b 
           END IF

         ON CHANGE f
           IF tm.f NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD f 
           END IF 
         #FUN-C80102--add--end--

                                            
         AFTER FIELD lvl                                                        
            IF NOT cl_null(tm.lvl) THEN                                         
               IF tm.lvl <= 0 THEN                                              
                  NEXT FIELD lvl                                                
               END IF                                                           
            END IF    

        #FUN-D40044--add--str---
        ON CHANGE h
           IF tm.h NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD h
           END IF
        #FUN-D40044--add--end---            

        #FUN-C80102--mark--str---
        #AFTER FIELD more
        #    IF tm.more = 'Y'
        #       THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
        #                           g_bgjob,g_time,g_prtway,g_copies)
        #                 RETURNING g_pdate,g_towhom,g_rlang,
        #                           g_bgjob,g_time,g_prtway,g_copies
        #    END IF
        #FUN-C80102--mark--end---

         AFTER INPUT
            IF NOT cl_null(tm.m2) AND NOT cl_null(tm.m1) THEN
               IF tm.m1 > tm.m2 THEN
                  NEXT FIELD m1
               END IF
            END IF
         
      #END INPUT    #FUN-C80102 mark 
      
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bookno)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  CALL cl_create_qry() RETURNING tm.bookno
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno    
               #FUN-C80102--mark--str---        
               #WHEN INFIELD(aag01)     #科目代號
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aag'
               #   LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"   #FUN-B20010 add                  
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aag01
               #   NEXT FIELD aag01            
               #WHEN INFIELD(aeh02)     #部門
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh02'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh02
               #   NEXT FIELD aeh02
               #WHEN INFIELD(aeh04)     #核算項1
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh04'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh04
               #   NEXT FIELD aeh04
               #WHEN INFIELD(aeh05)     #核算項2
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh05'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh05
               #   NEXT FIELD aeh05
               #WHEN INFIELD(aeh06)     #核算項3
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh06'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh06
               #   NEXT FIELD aeh06
               #WHEN INFIELD(aeh07)     #核算項4
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh07'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh07
               #   NEXT FIELD aeh07
               #WHEN INFIELD(aeh31)     #核算項5
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh31'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh31
               #   NEXT FIELD aeh31
               #WHEN INFIELD(aeh32)     #核算項6
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh32'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh32
               #   NEXT FIELD aeh32
               #WHEN INFIELD(aeh33)     #核算項7
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh33'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh33
               #   NEXT FIELD aeh33
               #WHEN INFIELD(aeh34)     #核算項8
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh34'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh34
               #   NEXT FIELD aeh34
               #WHEN INFIELD(aeh35)     #核算項9
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh35'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh35
               #   NEXT FIELD aeh35
               #WHEN INFIELD(aeh36)     #核算項10
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh36'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh36
               #   NEXT FIELD aeh36
               #WHEN INFIELD(aeh37)     #核算項-關系人
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state= 'c'
               #   LET g_qryparam.form = 'q_aeh37'
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO aeh37
               #   NEXT FIELD aeh37
               #FUN-C80102--mark--add---
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

        #No.FUN-C80102 ---start--- Mark
        #ON ACTION accept
        #   EXIT DIALOG      
        #   
        #ON ACTION cancel 
        #   LET INT_FLAG = 1
        #   EXIT DIALOG      
        #No.FUN-C80102 ---start--- Mark
                              
      #END DIALOG    #FUN-C80102 mark
      END INPUT      #FUN-C80102 add
      #FUN-C80102--add--str--
      CONSTRUCT BY NAME tm.wc ON aeh01
                                
   
         BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
       CASE 
          WHEN INFIELD(aeh01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aag'
                  LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aeh01
                  NEXT FIELD aeh01            
       END CASE

      END CONSTRUCT
      #str------- add by dengsy170304
      CONSTRUCT BY NAME tm.wc3 ON aeh17
                                
   
         BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
       CASE 
          WHEN INFIELD(aeh17)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_azi'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aeh17
                  NEXT FIELD aeh17            
       END CASE

      END CONSTRUCT
      #end------- add by dengsy170304
      CONSTRUCT BY NAME tm.wc1 ON tt1,tt2,tt3,tt4,tt5,tt6,
                                  tt7,tt8,tt9,tt10,tt11,tt12
         BEFORE CONSTRUCT
           CALL cl_qbe_init()


      ON ACTION CONTROLP
         CASE 
              WHEN INFIELD(tt1)     #部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh02'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt1
                  NEXT FIELD tt1
              WHEN INFIELD(tt2)     #核算項-關系人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh37'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt2
                  NEXT FIELD tt2
              WHEN INFIELD(tt3)     #核算項1
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                # LET g_qryparam.form = 'q_aeh04'   #mark by liyjf161109
                  LET g_qryparam.form = 'q_aee1'   #add by liyjf161109
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt3
                  NEXT FIELD tt3
              WHEN INFIELD(tt4)     #核算項2
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh05'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt4
                  NEXT FIELD tt4
              WHEN INFIELD(tt5)     #核算項3
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh06'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt5
                  NEXT FIELD tt5
              WHEN INFIELD(tt6)     #核算項4
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh07'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt6
                  NEXT FIELD tt6
              WHEN INFIELD(tt7)     #核算項5
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh31'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt7
                  NEXT FIELD tt7
              WHEN INFIELD(tt8)     #核算項6
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh32'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt8
                  NEXT FIELD tt8
              WHEN INFIELD(tt9)     #核算項7
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh33'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt9
                  NEXT FIELD tt9
              WHEN INFIELD(tt10)     #核算項8
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh34'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt10
                  NEXT FIELD tt10
              WHEN INFIELD(tt11)     #核算項9
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh35'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt11
                  NEXT FIELD tt11
              WHEN INFIELD(tt12)     #核算項10
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aeh36'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tt12
                  NEXT FIELD tt12
         END CASE

      END CONSTRUCT

      ON ACTION ACCEPT
         EXIT DIALOG        
       
      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG   
      END DIALOG 
      #FUN-C80102--add--str--
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
      #   LET INT_FLAG = 0 CLOSE WINDOW gglq307_w
      #   CALL cl_used(g_prog,g_time,2) RETURNING g_time
      #   EXIT PROGRAM
      #END IF
      #FUN-C80102--mark--end--
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='gglq307'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('gglq307','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,
                            " '",g_pdate    CLIPPED,"'",
                            " '",g_towhom   CLIPPED,"'",
                            " '",g_rlang    CLIPPED,"'",
                            " '",g_bgjob    CLIPPED,"'",
                            " '",g_prtway   CLIPPED,"'",
                            " '",g_copies   CLIPPED,"'",
                            " '",tm.bookno  CLIPPED,"'",
                            " '",tm.yy      CLIPPED,"'" ,
                            " '",tm.m1      CLIPPED,"'" ,
                            " '",tm.m2      CLIPPED,"'" ,
                            " '",tm.s1      CLIPPED,"'",
                            " '",tm.s2      CLIPPED,"'",
                            " '",tm.s3      CLIPPED,"'",
                            #" '",tm.a       CLIPPED,"'",     #FUN-C80102  mark
                            " '",tm.b       CLIPPED,"'",
                            #" '",tm.e       CLIPPED,"'",     #FUN-C80102  mark
                            " '",tm.f       CLIPPED,"'",
                            " '",tm.g       CLIPPED,"'",
                            " '",tm.lvl     CLIPPED,"'",  #No.FUN-A40020
                            " '",tm.i       CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",
                            " '",g_rep_clas CLIPPED,"'",
                            " '",g_template CLIPPED,"'",
                            " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('gglq307',g_time,l_cmd)
         END IF
         #CLOSE WINDOW gglq307_w   #FUN-C80102  mark
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL gglq307()
      ERROR ""
      EXIT WHILE
   END WHILE
   #CLOSE WINDOW gglq307_w    #FUN-C80102  mark

   CLEAR FORM
   CALL g_aeh.clear()
   CALL gglq307_show()
   DISPLAY g_rec_b to FORMONLY.cnt

END FUNCTION

FUNCTION gglq307()
   DEFINE l_name             LIKE type_file.chr20
   DEFINE l_wc1              LIKE type_file.chr1000
   DEFINE l_sql              STRING
   DEFINE l_sql_s            LIKE type_file.chr1000
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_aag01_str        LIKE type_file.chr50
   DEFINE sr1                RECORD
                             aag01    LIKE aag_file.aag01,
                             aag02    LIKE aag_file.aag02,
                             aag13    LIKE aag_file.aag13,
                             aag07    LIKE aag_file.aag07
                             END RECORD
   DEFINE sr                 RECORD
                             aeh01    LIKE aeh_file.aeh01,  #科目編號
                             aag02    LIKE aag_file.aag02,
                             aag07    LIKE aag_file.aag07,
                             type     LIKE type_file.chr1,  #A.期初 B.期間
                             aeh17    LIKE aeh_file.aeh17,  #幣種
                             tt1      LIKE abb_file.abb11,
                             tt2      LIKE abb_file.abb11,
                             tt3      LIKE abb_file.abb11,
                             tt4      LIKE abb_file.abb11,
                             tt5      LIKE abb_file.abb11,
                             tt6      LIKE abb_file.abb11,
                             tt7      LIKE abb_file.abb11,
                             tt8      LIKE abb_file.abb11,
                             tt9      LIKE abb_file.abb11,
                             tt10     LIKE abb_file.abb11,
                             tt11     LIKE abb_file.abb11,
                             tt12     LIKE abb_file.abb11,
                             df       LIKE aah_file.aah04,  #原幣借
                             d        LIKE aah_file.aah04,  #本幣借
                             cf       LIKE aah_file.aah04,  #原幣貸
                             c        LIKE aah_file.aah04   #本幣貸
                             END RECORD
   DEFINE l_abb03            LIKE abb_file.abb03 #科目編號
   DEFINE l_un               LIKE type_file.chr1
   DEFINE l_flag             LIKE type_file.chr1
   #No.CHI-C70031  --Begin
   DEFINE l_aeh11                      LIKE aeh_file.aeh11,
          l_aeh12                      LIKE aeh_file.aeh12,
          l_aeh15                      LIKE aeh_file.aeh15,
          l_aeh16                      LIKE aeh_file.aeh16,
          l_aaa09                      LIKE aaa_file.aaa09
   #No.CHI-C70031  --End

   CALL gglq307_table()   #為最后的單身填充做准備
   SELECT zo02 INTO g_company FROM zo_file
    WHERE zo01 = g_rlang

   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = tm.bookno   #FUN-BC0027 
   
   #科目
   LET tm.wc = cl_replace_str(tm.wc,"aeh01","aag01")      #FUN-C80102 add

   LET l_sql = " SELECT aag01,aag02,aag13,aag07 FROM aag_file ",
               "  WHERE aag00 = '",tm.bookno,"'",
        #      "    AND aag03 = '2' ",     #帳戶   #MOD-C30751  mark
               "    AND aag09 = 'Y' ",              #貨幣性科目
               "    AND ",tm.wc CLIPPED
   #No.FUN-A40020  --Begin                                                      
   #IF tm.h = '1' THEN                      #一级科目&统治科目                  
   #   LET l_sql = l_sql CLIPPED," AND (aag07 = '1' AND aag24 = 1 OR aag07 = '3')"                                                                              
   #END IF                                                                      
   IF cl_null(tm.lvl) THEN LET tm.lvl = 99 END IF                               
   IF NOT cl_null(tm.lvl) THEN                                                  
      LET l_sql = l_sql CLIPPED,                                                
                  "  AND aag24 <= ",tm.lvl                                      
   END IF                                                                       
   #No.FUN-A40020  --End
   #FUN-C80102--mark--str--
   #IF tm.e = 'N' THEN                      #有效科目
   #   LET l_sql = l_sql CLIPPED," AND aagacti = 'Y' "
   #END IF
   #FUN-C80102--mark--end--

   PREPARE gglq307_aag01_p FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare gglq307_aag01_p',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq307_aag01_cs CURSOR FOR gglq307_aag01_p

   LET l_wc1 = tm.wc1
   #FUN-C80102--mark--str--
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh02", "abb05")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh04", "abb11")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh05", "abb12")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh06", "abb13")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh07", "abb14")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh31", "abb31")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh32", "abb32")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh33", "abb33")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh34", "abb34")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh35", "abb35")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh36", "abb36")
   #LET l_wc1 = cl_replace_str(l_wc1, "aeh37", "abb37")
   #FUN-C80102--mark--str--

   #FUN-C80102--add--str--
   LET l_wc1 = cl_replace_str(l_wc1, "tt1", "abb05")
   LET l_wc1 = cl_replace_str(l_wc1, "tt3", "abb11")
   LET l_wc1 = cl_replace_str(l_wc1, "tt4", "abb12")
   LET l_wc1 = cl_replace_str(l_wc1, "tt5", "abb13")
   LET l_wc1 = cl_replace_str(l_wc1, "tt6", "abb14")
   LET l_wc1 = cl_replace_str(l_wc1, "tt7", "abb31")
   LET l_wc1 = cl_replace_str(l_wc1, "tt8", "abb32")
   LET l_wc1 = cl_replace_str(l_wc1, "tt9", "abb33")
   LET l_wc1 = cl_replace_str(l_wc1, "tt10", "abb34")
   LET l_wc1 = cl_replace_str(l_wc1, "tt11", "abb35")
   LET l_wc1 = cl_replace_str(l_wc1, "tt12", "abb36")
   LET l_wc1 = cl_replace_str(l_wc1, "tt2", "abb37")
   #FUN-C80102--add--str--

   #TQC-CC0122--add--str--
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt1", "aeh02")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt3", "aeh04")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt4", "aeh05")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt5", "aeh06")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt6", "aeh07")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt7", "aeh31")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt8", "aeh32")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt9", "aeh33")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt10", "aeh34")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt11", "aeh35")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt12", "aeh36")
   LET tm.wc1 = cl_replace_str(tm.wc1, "tt2", "aeh37")

   #TQC-CC0122--add--end--

   #期初
   LET l_sql=" SELECT aeh01,'','','A',aeh17,aeh02,aeh37,aeh04,aeh05,aeh06,",
             "        aeh07,aeh31,aeh32,aeh33,aeh34,aeh35,aeh36,",
             "        SUM(aeh15),SUM(aeh11),SUM(aeh16),SUM(aeh12) ",
             "   FROM aeh_file ",
             "  WHERE aeh00 = '",tm.bookno,"'",
             "    AND aeh01 LIKE ?",
             "    AND aeh09 =  ",tm.yy,
             "    AND aeh10 < ",tm.m1 ,
#FUN-BC0027 --begin--
#            "    AND aeh01 <> '",g_aaz.aaz31,"'",
#            "    AND aeh01 <> '",g_aaz.aaz32,"'",
            #"    AND aeh01 <> '",g_aaa.aaa14,"'",     #MOD-C40185 mark
            #"    AND aeh01 <> '",g_aaa.aaa15,"'",     #MOD-C40185 mark
#FUN-BC0027 --end--
             "    AND ",tm.wc1 CLIPPED,
             "    AND ",tm.wc3 CLIPPED,  #add by dengsy170304
             " GROUP BY aeh01,aeh17,aeh02,aeh37,aeh04,aeh05,aeh06,",
             "          aeh07,aeh31,aeh32,aeh33,aeh34,aeh35,aeh36 ",
             "  UNION ALL "
   #期間
   IF tm.g='3' THEN
         LET l_sql= l_sql CLIPPED,
                " SELECT aeh01,'','','B',aeh17,aeh02,aeh37,aeh04,aeh05,aeh06,",
                "        aeh07,aeh31,aeh32,aeh33,aeh34,aeh35,aeh36,",
                "        SUM(aeh15),SUM(aeh11),SUM(aeh16),SUM(aeh12) ",
                "   FROM aeh_file ",
                "  WHERE aeh00 = '",tm.bookno,"'",
                "    AND aeh01 LIKE ?",          #勿動 特意放了兩行重復
                "    AND aeh01 LIKE ?",          #勿動 特意放了兩行重復
                "    AND aeh09 =  ",tm.yy,
                "    AND aeh10 BETWEEN ",tm.m1," AND ",tm.m2,
#FUN-BC0027 --begin--             
#               "    AND aeh01 <> '",g_aaz.aaz31,"'",
#               "    AND aeh01 <> '",g_aaz.aaz32,"'",
               #"    AND aeh01 <> '",g_aaa.aaa14,"'",       #MOD-C40185 mark
               #"    AND aeh01 <> '",g_aaa.aaa15,"'",       #MOD-C40185 mark
#FUN-BC0027 --end--             
                "    AND ",tm.wc1 CLIPPED,
                "    AND ",tm.wc3 CLIPPED,  #add by dengsy170304
                " GROUP BY aeh01,aeh17,aeh02,aeh37,aeh04,aeh05,aeh06,",
                "          aeh07,aeh31,aeh32,aeh33,aeh34,aeh35,aeh36 "

   ELSE
      IF tm.g='2' THEN LET l_sql_s=" AND aba19='Y' " ELSE LET l_sql_s=' ' END IF
      IF tm.h = 'N' THEN    #FUN-D40044 add
         LET l_sql= l_sql CLIPPED,
                    " SELECT abb03,'','','B',abb24,abb05,abb37,abb11,abb12,abb13,",
                    "        abb14,abb31,abb32,abb33,abb34,abb35,abb36,",
                    "        SUM(abb07f),SUM(abb07),0,0",
                    "   FROM aba_file a,abb_file",                  #FUN-D40044  add a
                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    #"    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))",  #CHI-C70031  #FUN-D40044 mark
                    "    AND NOT EXISTS (SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01",                                           #FUN-D40044 add
                    "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))",        #FUN-D40044 add 
                    "    AND aba00 = '",tm.bookno,"'", 
                    "    AND aba03 =  ",tm.yy,
                    "    AND aba04 BETWEEN ",tm.m1," AND ",tm.m2,
                    "    AND abb03 LIKE ? ",
#FUN-BC0027 --begin--             
#                   "    AND abb03 <> '",g_aaz.aaz31,"'",
#                   "    AND abb03 <> '",g_aaz.aaz32,"'",
                   #"    AND abb03 <> '",g_aaa.aaa14,"'",          #MOD-C40185 mark
                   #"    AND abb03 <> '",g_aaa.aaa15,"'",          #MOD-C40185 mark
#FUN-BC0027 --end--             
                   "    AND abb06 = '1' ",l_sql_s CLIPPED,
                   "    AND aba19 <> 'X' ",  #CHI-C80041
                   "    AND ",l_wc1 CLIPPED,
                   "  GROUP BY abb03,abb24,abb05,abb37,abb11,abb12,abb13,",
                   "           abb14,abb31,abb32,abb33,abb34,abb35,abb36 ",
                   "  UNION ALL ",
                   " SELECT abb03,'','','B',abb24,abb05,abb37,abb11,abb12,abb13,",
                   "        abb14,abb31,abb32,abb33,abb34,abb35,abb36,",
                   "        0,0,SUM(abb07f),SUM(abb07)",
                   "   FROM aba_file a,abb_file",                  #FUN-D40044  add a
                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                   #"    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))",  #CHI-C70031  #FUN-D40044 mark
                   "    AND NOT EXISTS (SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01",                                           #FUN-D40044 add
                   "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))",        #FUN-D40044 add 
                   "    AND aba00 = '",tm.bookno,"'",
                   "    AND aba03 =  ",tm.yy,
                   "    AND aba04 BETWEEN ",tm.m1," AND ",tm.m2,
                   "    AND abb03 LIKE ? ",
#FUN-BC0027 --begin--             
#                  "    AND abb03 <> '",g_aaz.aaz31,"'",
#                  "    AND abb03 <> '",g_aaz.aaz32,"'",
                  #"    AND abb03 <> '",g_aaa.aaa14,"'",                   #MOD-C40185 mark
                  #"    AND abb03 <> '",g_aaa.aaa15,"'",                   #MOD-C40185 mark
#FUN-BC0027 --end--             
                   "    AND abb06 = '2' ",l_sql_s CLIPPED,
                   "    AND aba19 <> 'X' ",  #CHI-C80041
                   "    AND ",l_wc1 CLIPPED,
                   "  GROUP BY abb03,abb24,abb05,abb37,abb11,abb12,abb13,",
                   "           abb14,abb31,abb32,abb33,abb34,abb35,abb36 " 
      #FUN-D40044--add--str--
      ELSE
         LET l_sql= l_sql CLIPPED,
                    " SELECT abb03,'','','B',abb24,abb05,abb37,abb11,abb12,abb13,",
                    "        abb14,abb31,abb32,abb33,abb34,abb35,abb36,",
                    "        SUM(abb07f),SUM(abb07),0,0",
                    "   FROM aba_file ,abb_file",                 
                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    "    AND aba00 = '",tm.bookno,"'", 
                    "    AND aba03 =  ",tm.yy,
                    "    AND aba04 BETWEEN ",tm.m1," AND ",tm.m2,
                    "    AND abb03 LIKE ? ",        
                   "    AND abb06 = '1' ",l_sql_s CLIPPED,
                   "    AND aba19 <> 'X' ", 
                   "    AND ",l_wc1 CLIPPED,
                   "  GROUP BY abb03,abb24,abb05,abb37,abb11,abb12,abb13,",
                   "           abb14,abb31,abb32,abb33,abb34,abb35,abb36 ",
                   "  UNION ALL ",
                   " SELECT abb03,'','','B',abb24,abb05,abb37,abb11,abb12,abb13,",
                   "        abb14,abb31,abb32,abb33,abb34,abb35,abb36,",
                   "        0,0,SUM(abb07f),SUM(abb07)",
                   "   FROM aba_file ,abb_file",                 
                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                   "    AND aba00 = '",tm.bookno,"'",
                   "    AND aba03 =  ",tm.yy,
                   "    AND aba04 BETWEEN ",tm.m1," AND ",tm.m2,
                   "    AND abb03 LIKE ? ",       
                   "    AND abb06 = '2' ",l_sql_s CLIPPED,
                   "    AND aba19 <> 'X' ",  
                   "    AND ",l_wc1 CLIPPED,
                   "  GROUP BY abb03,abb24,abb05,abb37,abb11,abb12,abb13,",
                   "           abb14,abb31,abb32,abb33,abb34,abb35,abb36 " 
      END IF 
      #FUN-D40044--add--end--
   END IF
   LET l_sql = l_sql CLIPPED,
             " ORDER BY 1,5,6,7,8,9,10,11,12,13,14,15,16,17 "

   PREPARE gglq307_pre FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('gglq307_qc_p3',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq307_cs CURSOR FOR gglq307_pre

   LET g_pageno  = 0
   LET g_prog = 'gglr300'
   CALL cl_outnam('gglr300') RETURNING l_name
   START REPORT gglq307_rep TO l_name

   FOREACH gglq307_aag01_cs INTO sr1.*  #科目
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq307_aag01_cs foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF
      IF tm.f = 'Y' THEN LET sr1.aag02 = sr1.aag13 END IF

      #此作業也要打印統治科目的金額，但是abb中都存放得是明細或是獨立科目
      #所以要用LIKE的方式，取出統治科目對應的明細科目的金額
      #此作業的前提，明細科目的前幾碼一定和其上屬統治相同 ruled by 蔡曉峰
      IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
      #carrier check % or \%
#     LET l_aag01_str = sr1.aag01 CLIPPED,'%'
      LET l_aag01_str = sr1.aag01 CLIPPED,'\%'   #wujie 090428

      LET l_flag = 'N'
      FOREACH gglq307_cs USING l_aag01_str,l_aag01_str,l_aag01_str INTO sr.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('gglq307_cs foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF

         LET l_flag = 'Y'
         LET sr.aeh01 = sr1.aag01  #不能放在foreach外面
         LET sr.aag02 = sr1.aag02
         LET sr.aag07 = sr1.aag07

         IF cl_null(sr.aeh17) THEN LET sr.aeh17 = ' ' END IF
         IF cl_null(sr.tt1)   THEN LET sr.tt1   = ' ' END IF
         IF cl_null(sr.tt2)   THEN LET sr.tt2   = ' ' END IF
         IF cl_null(sr.tt3)   THEN LET sr.tt3   = ' ' END IF
         IF cl_null(sr.tt4)   THEN LET sr.tt4   = ' ' END IF
         IF cl_null(sr.tt5)   THEN LET sr.tt5   = ' ' END IF
         IF cl_null(sr.tt6)   THEN LET sr.tt6   = ' ' END IF
         IF cl_null(sr.tt7)   THEN LET sr.tt7   = ' ' END IF
         IF cl_null(sr.tt8)   THEN LET sr.tt8   = ' ' END IF
         IF cl_null(sr.tt9)   THEN LET sr.tt9   = ' ' END IF
         IF cl_null(sr.tt10)  THEN LET sr.tt10  = ' ' END IF
         IF cl_null(sr.tt11)  THEN LET sr.tt11  = ' ' END IF
         IF cl_null(sr.tt12)  THEN LET sr.tt12  = ' ' END IF
         IF cl_null(sr.df)    THEN LET sr.df    = 0   END IF
         IF cl_null(sr.d)     THEN LET sr.d     = 0   END IF
         IF cl_null(sr.cf)    THEN LET sr.cf    = 0   END IF
         IF cl_null(sr.c)     THEN LET sr.c     = 0   END IF

         #No.CHI-C70031  --Begin
         IF tm.g = '3' THEN            
            SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.bookno
            LET l_aeh11 = 0
            LET l_aeh12 = 0
            LET l_aeh15 = 0
            LET l_aeh16 = 0
            CALL s_minus_ce(tm.bookno, l_aag01_str, l_aag01_str, sr.tt1,sr.tt1,NULL,
            sr.tt3,  sr.tt4,    sr.tt5,      sr.tt6,     NULL,    tm.yy,
            tm.m1,       tm.m2,       sr.aeh17,      sr.tt7,  sr.tt8,    sr.tt9,
            sr.tt10,  sr.tt11,      sr.tt12,    sr.tt2,     g_plant,  l_aaa09,'1')
            RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
            IF tm.h = 'N' THEN       #FUN-D40044 add
               LET sr.df = sr.df - l_aeh15
               LET sr.d  = sr.d  - l_aeh11
               LET sr.cf = sr.cf - l_aeh16
               LET sr.c  = sr.c  - l_aeh12
            END IF                   #FUN-D40044 add
         END IF
         #No.CHI-C70031  --End
         OUTPUT TO REPORT gglq307_rep(sr.*)
      END FOREACH
      #IF l_flag = 'N' AND tm.a = 'Y' THEN  #既無期初,又無期間異動   #FUN-C80102  mark
      IF l_flag = 'N' THEN                                       #FUN-C80102  add  
         LET sr.aeh01 = sr1.aag01  #不能放在foreach外面
         LET sr.aag02 = sr1.aag02
         LET sr.aag07 = sr1.aag07
         LET sr.type  = 'A'
         LET sr.aeh17 = g_aza.aza17
         LET sr.tt1   = ' '
         LET sr.tt2   = ' '
         LET sr.tt3   = ' '
         LET sr.tt4   = ' '
         LET sr.tt5   = ' '
         LET sr.tt6   = ' '
         LET sr.tt7   = ' '
         LET sr.tt8   = ' '
         LET sr.tt9   = ' '
         LET sr.tt10  = ' '
         LET sr.tt11  = ' '
         LET sr.tt12  = ' '
         LET sr.df    = 0
         LET sr.d     = 0
         LET sr.cf    = 0
         LET sr.c     = 0

         OUTPUT TO REPORT gglq307_rep(sr.*)
      END IF
   END FOREACH
   FINISH REPORT gglq307_rep
END FUNCTION

REPORT gglq307_rep(sr)
   DEFINE l_last_sw          LIKE type_file.chr1
   DEFINE sr                 RECORD
                             aeh01    LIKE aeh_file.aeh01,  #科目編號
                             aag02    LIKE aag_file.aag02,
                             aag07    LIKE aag_file.aag07,
                             type     LIKE type_file.chr1,  #A.期初 B.期間
                             aeh17    LIKE aeh_file.aeh17,  #幣種
                             tt1      LIKE abb_file.abb11,
                             tt2      LIKE abb_file.abb11,
                             tt3      LIKE abb_file.abb11,
                             tt4      LIKE abb_file.abb11,
                             tt5      LIKE abb_file.abb11,
                             tt6      LIKE abb_file.abb11,
                             tt7      LIKE abb_file.abb11,
                             tt8      LIKE abb_file.abb11,
                             tt9      LIKE abb_file.abb11,
                             tt10     LIKE abb_file.abb11,
                             tt11     LIKE abb_file.abb11,
                             tt12     LIKE abb_file.abb11,
                             df       LIKE aah_file.aah04,  #原幣借
                             d        LIKE aah_file.aah04,  #本幣借
                             cf       LIKE aah_file.aah04,  #原幣貸
                             c        LIKE aah_file.aah04   #本幣貸
                             END RECORD
   DEFINE sr1                RECORD
                             tt1_d    LIKE aee_file.aee04,
                             tt2_d    LIKE aee_file.aee04,
                             tt3_d    LIKE aee_file.aee04,
                             tt4_d    LIKE aee_file.aee04,
                             tt5_d    LIKE aee_file.aee04,
                             tt6_d    LIKE aee_file.aee04,
                             tt7_d    LIKE aee_file.aee04,
                             tt8_d    LIKE aee_file.aee04,
                             tt9_d    LIKE aee_file.aee04,
                             tt10_d   LIKE aee_file.aee04,
                             tt11_d   LIKE aee_file.aee04,
                             tt12_d   LIKE aee_file.aee04
                             END RECORD
   DEFINE qc_df              LIKE aah_file.aah04
   DEFINE qc_d               LIKE aah_file.aah04
   DEFINE qc_cf              LIKE aah_file.aah04
   DEFINE qc_c               LIKE aah_file.aah04
   DEFINE qj_df              LIKE aah_file.aah04
   DEFINE qj_d               LIKE aah_file.aah04
   DEFINE qj_cf              LIKE aah_file.aah04
   DEFINE qj_c               LIKE aah_file.aah04
   DEFINE balf               LIKE aah_file.aah04
   DEFINE bal                LIKE aah_file.aah04

   DEFINE balf_qc            LIKE aah_file.aah04
   DEFINE bal_qc             LIKE aah_file.aah04
   DEFINE balf_qm            LIKE aah_file.aah04
   DEFINE bal_qm             LIKE aah_file.aah04
   DEFINE dc_qc              LIKE type_file.chr10
   DEFINE dc_qm              LIKE type_file.chr10
   DEFINE er_qc              LIKE abb_file.abb25
   DEFINE er_qm              LIKE abb_file.abb25
   DEFINE er_d_qj            LIKE abb_file.abb25
   DEFINE er_c_qj            LIKE abb_file.abb25
   DEFINE l_flag             LIKE type_file.chr1

   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY sr.aeh01,sr.tt1,sr.tt2,sr.tt3,sr.tt4,sr.tt5,sr.tt6,sr.tt7,
            sr.tt8,sr.tt9,sr.tt10,sr.tt11,sr.tt12,sr.aeh17,sr.type
   FORMAT
    PAGE HEADER
      LET g_pageno = g_pageno + 1

   AFTER GROUP OF sr.aeh17  #打印外幣
      IF tm.i = 'Y' THEN
         #期初
         LET qc_df    = GROUP SUM(sr.df) WHERE sr.type = 'A'  #期初
         LET qc_d     = GROUP SUM(sr.d ) WHERE sr.type = 'A'  #期初
         LET qc_cf    = GROUP SUM(sr.cf) WHERE sr.type = 'A'  #期初
         LET qc_c     = GROUP SUM(sr.c ) WHERE sr.type = 'A'  #期初
         IF cl_null(qc_df) THEN LET qc_df = 0 END IF
         IF cl_null(qc_d ) THEN LET qc_d  = 0 END IF
         IF cl_null(qc_cf) THEN LET qc_cf = 0 END IF
         IF cl_null(qc_c ) THEN LET qc_c  = 0 END IF
         LET balf     = qc_df - qc_cf
         LET bal      = qc_d  - qc_c
         IF bal > 0 THEN
            LET balf_qc = balf
            LET bal_qc  = bal
            CALL cl_getmsg('ggl-211',g_lang) RETURNING dc_qc
         ELSE
            IF bal = 0 THEN
               LET balf_qc = balf
               LET bal_qc  = bal
               CALL cl_getmsg('ggl-210',g_lang) RETURNING dc_qc
            ELSE
               LET balf_qc = balf * -1
               LET bal_qc  = bal  * -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING dc_qc
            END IF
         END IF
         IF balf_qc <> 0 THEN
            LET er_qc = bal_qc / balf_qc
         ELSE
            LET er_qc = 0
         END IF

         #期間
         LET qj_df    = GROUP SUM(sr.df) WHERE sr.type = 'B'  #期間
         LET qj_d     = GROUP SUM(sr.d ) WHERE sr.type = 'B'  #期間
         LET qj_cf    = GROUP SUM(sr.cf) WHERE sr.type = 'B'  #期間
         LET qj_c     = GROUP SUM(sr.c ) WHERE sr.type = 'B'  #期間
         IF cl_null(qj_df) THEN LET qj_df = 0 END IF
         IF cl_null(qj_d ) THEN LET qj_d  = 0 END IF
         IF cl_null(qj_cf) THEN LET qj_cf = 0 END IF
         IF cl_null(qj_c ) THEN LET qj_c  = 0 END IF
         IF qj_df <> 0 THEN
            LET er_d_qj = qj_d / qj_df
         ELSE
            LET er_d_qj = 0
         END IF
         IF qj_cf <> 0 THEN
            LET er_c_qj = qj_c / qj_cf
         ELSE
            LET er_c_qj = 0
         END IF

         #期末
         LET balf     = qc_df - qc_cf + qj_df - qj_cf
         LET bal      = qc_d  - qc_c  + qj_d  - qj_c
         IF bal > 0 THEN
            LET balf_qm = balf
            LET bal_qm  = bal
            CALL cl_getmsg('ggl-211',g_lang) RETURNING dc_qm
         ELSE
            IF bal = 0 THEN
               LET balf_qm = balf
               LET bal_qm  = bal
               CALL cl_getmsg('ggl-210',g_lang) RETURNING dc_qm
            ELSE
               LET balf_qm = balf * -1
               LET bal_qm  = bal  * -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING dc_qm
            END IF
         END IF
         IF balf_qm <> 0 THEN
            LET er_qm = bal_qm / balf_qm
         ELSE
            LET er_qm = 0
         END IF
         #期間有異動或期初不為0的,則一定要打印
         #tm.a='Y' 包括所有科目,則全部科目不care條件都要打印
         #tm.b='Y' 期初有異動,期間有異動,則打印
         IF bal_qc <> 0 OR qj_d <> 0 OR qj_c <> 0 OR bal_qm <> 0 OR
            #tm.a = 'Y'  OR (tm.b = 'Y' AND (qc_d <> 0 OR qc_c <> 0)) THEN   #FUN-C80102  mark
            (tm.b = 'Y' AND (qc_d <> 0 OR qc_c <> 0)) THEN                   #FUN-C80102  add
            INITIALIZE sr1.* TO NULL
            IF sr.tt1 IS NOT NULL THEN
               SELECT gem02 INTO sr1.tt1_d FROM gem_file WHERE gem01 = sr.tt1
            END IF
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'99',sr.tt2)  RETURNING sr1.tt2_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'1' ,sr.tt3)  RETURNING sr1.tt3_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'2' ,sr.tt4)  RETURNING sr1.tt4_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'3' ,sr.tt5)  RETURNING sr1.tt5_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'4' ,sr.tt6)  RETURNING sr1.tt6_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'5' ,sr.tt7)  RETURNING sr1.tt7_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'6' ,sr.tt8)  RETURNING sr1.tt8_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'7' ,sr.tt9)  RETURNING sr1.tt9_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'8' ,sr.tt10) RETURNING sr1.tt10_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'9' ,sr.tt11) RETURNING sr1.tt11_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'10',sr.tt12) RETURNING sr1.tt12_d

            INSERT INTO gglq307_tmp VALUES(sr.aeh01,sr.aag02,sr.aag07,'','',
                   sr.tt1,sr1.tt1_d,sr.tt2,sr1.tt2_d,sr.tt3,sr1.tt3_d,
                   sr.tt4,sr1.tt4_d,sr.tt5,sr1.tt5_d,sr.tt6,sr1.tt6_d,
                   sr.tt7,sr1.tt7_d,sr.tt8,sr1.tt8_d,sr.tt9,sr1.tt9_d,
                   sr.tt10,sr1.tt10_d,sr.tt11,sr1.tt11_d,sr.tt12,sr1.tt12_d,
                   sr.aeh17,dc_qc,balf_qc,er_qc,bal_qc,
                   qj_df,er_d_qj,qj_d,qj_cf,er_c_qj,qj_c,
                   dc_qm,balf_qm,er_qm,bal_qm)
         END IF

      END IF

   AFTER GROUP OF sr.tt12   #不打印外幣
      IF tm.i = 'N' THEN
         #期初
         LET qc_df    = GROUP SUM(sr.df) WHERE sr.type = 'A'  #期初
         LET qc_d     = GROUP SUM(sr.d ) WHERE sr.type = 'A'  #期初
         LET qc_cf    = GROUP SUM(sr.cf) WHERE sr.type = 'A'  #期初
         LET qc_c     = GROUP SUM(sr.c ) WHERE sr.type = 'A'  #期初
         IF cl_null(qc_df) THEN LET qc_df = 0 END IF
         IF cl_null(qc_d ) THEN LET qc_d  = 0 END IF
         IF cl_null(qc_cf) THEN LET qc_cf = 0 END IF
         IF cl_null(qc_c ) THEN LET qc_c  = 0 END IF
         LET balf     = qc_df - qc_cf
         LET bal      = qc_d  - qc_c
         IF bal > 0 THEN
            LET balf_qc = balf
            LET bal_qc  = bal
            CALL cl_getmsg('ggl-211',g_lang) RETURNING dc_qc
         ELSE
            IF bal = 0 THEN
               LET balf_qc = balf
               LET bal_qc  = bal
               CALL cl_getmsg('ggl-210',g_lang) RETURNING dc_qc
            ELSE
               LET balf_qc = balf * -1
               LET bal_qc  = bal  * -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING dc_qc
            END IF
         END IF
         IF balf_qc <> 0 THEN
            LET er_qc = bal_qc / balf_qc
         ELSE
            LET er_qc = 0
         END IF

         #期間
         LET qj_df    = GROUP SUM(sr.df) WHERE sr.type = 'B'  #期間
         LET qj_d     = GROUP SUM(sr.d ) WHERE sr.type = 'B'  #期間
         LET qj_cf    = GROUP SUM(sr.cf) WHERE sr.type = 'B'  #期間
         LET qj_c     = GROUP SUM(sr.c ) WHERE sr.type = 'B'  #期間
         IF cl_null(qj_df) THEN LET qj_df = 0 END IF
         IF cl_null(qj_d ) THEN LET qj_d  = 0 END IF
         IF cl_null(qj_cf) THEN LET qj_cf = 0 END IF
         IF cl_null(qj_c ) THEN LET qj_c  = 0 END IF
         IF qj_df <> 0 THEN
            LET er_d_qj = qj_d / qj_df
         ELSE
            LET er_d_qj = 0
         END IF
         IF qj_cf <> 0 THEN
            LET er_c_qj = qj_c / qj_cf
         ELSE
            LET er_c_qj = 0
         END IF

         #期末
         LET balf     = qc_df - qc_cf + qj_df - qj_cf
         LET bal      = qc_d  - qc_c  + qj_d  - qj_c
         IF bal > 0 THEN
            LET balf_qm = balf
            LET bal_qm  = bal
            CALL cl_getmsg('ggl-211',g_lang) RETURNING dc_qm
         ELSE
            IF bal = 0 THEN
               LET balf_qm = balf
               LET bal_qm  = bal
               CALL cl_getmsg('ggl-210',g_lang) RETURNING dc_qm
            ELSE
               LET balf_qm = balf * -1
               LET bal_qm  = bal  * -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING dc_qm
            END IF
         END IF
         IF balf_qm <> 0 THEN
            LET er_qm = bal_qm / balf_qm
         ELSE
            LET er_qm = 0
         END IF
         #期間有異動或期初不為0的,則一定要打印
         #tm.a='Y' 包括所有科目,則全部科目不care條件都要打印
         #tm.b='Y' 期初有異動,期間有異動,則打印
         IF bal_qc <> 0 OR qj_d <> 0 OR qj_c <> 0 OR bal_qm <> 0 OR
            #tm.a = 'Y'  OR (tm.b = 'Y' AND (qc_d <> 0 OR qc_c <> 0)) THEN     #FUN-C80102  mark
            (tm.b = 'Y' AND (qc_d <> 0 OR qc_c <> 0)) THEN
            INITIALIZE sr1.* TO NULL
            IF sr.tt1 IS NOT NULL THEN
               SELECT gem02 INTO sr1.tt1_d FROM gem_file WHERE gem01 = sr.tt1
            END IF
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'99',sr.tt2)  RETURNING sr1.tt2_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'1' ,sr.tt3)  RETURNING sr1.tt3_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'2' ,sr.tt4)  RETURNING sr1.tt4_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'3' ,sr.tt5)  RETURNING sr1.tt5_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'4' ,sr.tt6)  RETURNING sr1.tt6_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'5' ,sr.tt7)  RETURNING sr1.tt7_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'6' ,sr.tt8)  RETURNING sr1.tt8_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'7' ,sr.tt9)  RETURNING sr1.tt9_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'8' ,sr.tt10) RETURNING sr1.tt10_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'9' ,sr.tt11) RETURNING sr1.tt11_d
            CALL gglq307_aee04(tm.bookno,sr.aeh01,'10',sr.tt12) RETURNING sr1.tt12_d

            INSERT INTO gglq307_tmp VALUES(sr.aeh01,sr.aag02,sr.aag07,'','',
                   sr.tt1,sr1.tt1_d,sr.tt2,sr1.tt2_d,sr.tt3,sr1.tt3_d,
                   sr.tt4,sr1.tt4_d,sr.tt5,sr1.tt5_d,sr.tt6,sr1.tt6_d,
                   sr.tt7,sr1.tt7_d,sr.tt8,sr1.tt8_d,sr.tt9,sr1.tt9_d,
                   sr.tt10,sr1.tt10_d,sr.tt11,sr1.tt11_d,sr.tt12,sr1.tt12_d,
                   sr.aeh17,dc_qc,balf_qc,er_qc,bal_qc,
                   qj_df,er_d_qj,qj_d,qj_cf,er_c_qj,qj_c,
                   dc_qm,balf_qm,er_qm,bal_qm)
         END IF

      END IF

END REPORT

#最后呈現的單身臨時表
FUNCTION gglq307_table()
     DROP TABLE gglq307_tmp;
     CREATE TEMP TABLE gglq307_tmp(
                    aeh01        LIKE aeh_file.aeh01,
                    aag02        LIKE aag_file.aag02,
                    aag07        LIKE aag_file.aag07,
                    type         LIKE type_file.chr1,
                    memo         LIKE abb_file.abb04,
                    tt1          LIKE abb_file.abb11,
                    tt1_d        LIKE aee_file.aee04,
                    tt2          LIKE abb_file.abb11,
                    tt2_d        LIKE aee_file.aee04,
                    tt3          LIKE abb_file.abb11,
                    tt3_d        LIKE aee_file.aee04,
                    tt4          LIKE abb_file.abb11,
                    tt4_d        LIKE aee_file.aee04,
                    tt5          LIKE abb_file.abb11,
                    tt5_d        LIKE aee_file.aee04,
                    tt6          LIKE abb_file.abb11,
                    tt6_d        LIKE aee_file.aee04,
                    tt7          LIKE abb_file.abb11,
                    tt7_d        LIKE aee_file.aee04,
                    tt8          LIKE abb_file.abb11,
                    tt8_d        LIKE aee_file.aee04,
                    tt9          LIKE abb_file.abb11,
                    tt9_d        LIKE aee_file.aee04,
                    tt10         LIKE abb_file.abb11,
                    tt10_d       LIKE aee_file.aee04,
                    tt11         LIKE abb_file.abb11,
                    tt11_d       LIKE aee_file.aee04,
                    tt12         LIKE abb_file.abb11,
                    tt12_d       LIKE aee_file.aee04,
                    aeh17        LIKE aeh_file.aeh17,
                    dc_qc        LIKE type_file.chr10,
                    balf_qc      LIKE abb_file.abb07,
                    er_qc        LIKE abb_file.abb25,
                    bal_qc       LIKE abb_file.abb07,
                    df_qj        LIKE abb_file.abb07,
                    er_d_qj      LIKE abb_file.abb25,
                    d_qj         LIKE abb_file.abb07,
                    cf_qj        LIKE abb_file.abb07,
                    er_c_qj      LIKE abb_file.abb25,
                    c_qj         LIKE abb_file.abb07,
                    dc_qm        LIKE type_file.chr10,
                    balf_qm      LIKE abb_file.abb07,
                    er_qm        LIKE abb_file.abb25,
                    bal_qm       LIKE abb_file.abb07);
END FUNCTION

FUNCTION q307_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_flag LIKE type_file.chr1
   DEFINE   l_aee03 LIKE aee_file.aee03


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aeh TO s_aeh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET l_flag = 'Y'

      BEFORE ROW
         #LILID ADD 090916 --begin
         IF l_flag = 'Y' AND l_ac1 > 1 THEN
            CALL FGL_SET_ARR_CURR(l_ac1)
         END IF
         LET l_flag = 'N'
         #LILID ADD 090916 --end
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY

      ON ACTION drill_general_ledger
         LET g_action_choice="drill_general_ledger"
         EXIT DISPLAY

      ON ACTION drill_general_ledger_702
         LET g_action_choice="drill_general_ledger_702"
         EXIT DISPLAY

      ON ACTION accept  ##add by fuli
         LET g_action_choice="drill_general_ledger"
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

FUNCTION gglq307_show()

   DISPLAY tm.yy TO yy
   DISPLAY tm.m1 TO m1
   DISPLAY tm.m2 TO m2

   #FUN-C80102--add--str---
   DISPLAY tm.bookno TO bookno
   DISPLAY tm.s1 TO s1
   DISPLAY tm.s2 TO s2
   DISPLAY tm.s3 TO s3
   DISPLAY tm.b TO b
   DISPLAY tm.f TO f
   DISPLAY tm.i TO i
   DISPLAY tm.lvl TO lvl
   DISPLAY tm.g TO g
   #FUN-C80102--add--end---
   DISPLAY tm.h    TO h     #FUN-D40044 add

   #No.MOD-B70188  --Begin
   #CALL cl_set_comp_visible('aeh17,dc_qc,balf_qc,er_qc',tm.i = 'Y')
   CALL cl_set_comp_visible('aeh17,balf_qc,er_qc',tm.i = 'Y')
   CALL cl_set_comp_visible('df_qj,er_d_qj,cf_qj,er_c_qj',tm.i = 'Y')
   #CALL cl_set_comp_visible('dc_qm,balf_qm,er_qm',tm.i = 'Y')
   CALL cl_set_comp_visible('balf_qm,er_qm',tm.i = 'Y')
   #No.MOD-B70188  --End  

   CALL gglq307_b_fill()

   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION gglq307_b_fill()
  DEFINE  t_azi04    LIKE azi_file.azi04
  DEFINE  t_azi07    LIKE azi_file.azi07
  DEFINE  l_gaq01    LIKE gaq_file.gaq01
  DEFINE  l_gaq02    LIKE gaq_file.gaq01
  DEFINE  l_gaq03    LIKE gaq_file.gaq01

   CASE tm.s1
        WHEN '1'  LET l_gaq01 = 'tt1'
        WHEN 'C'  LET l_gaq01 = 'tt2'
        WHEN '2'  LET l_gaq01 = 'tt3'
        WHEN '3'  LET l_gaq01 = 'tt4'
        WHEN '4'  LET l_gaq01 = 'tt5'
        WHEN '5'  LET l_gaq01 = 'tt6'
        WHEN '6'  LET l_gaq01 = 'tt7'
        WHEN '7'  LET l_gaq01 = 'tt8'
        WHEN '8'  LET l_gaq01 = 'tt9'
        WHEN '9'  LET l_gaq01 = 'tt10'
        WHEN 'A'  LET l_gaq01 = 'tt11'
        WHEN 'B'  LET l_gaq01 = 'tt12'
        OTHERWISE LET l_gaq01 = 'aeh01'
   END CASE
   CASE tm.s2
        WHEN '1'  LET l_gaq02 = 'tt1'
        WHEN 'C'  LET l_gaq02 = 'tt2'
        WHEN '2'  LET l_gaq02 = 'tt3'
        WHEN '3'  LET l_gaq02 = 'tt4'
        WHEN '4'  LET l_gaq02 = 'tt5'
        WHEN '5'  LET l_gaq02 = 'tt6'
        WHEN '6'  LET l_gaq02 = 'tt7'
        WHEN '7'  LET l_gaq02 = 'tt8'
        WHEN '8'  LET l_gaq02 = 'tt9'
        WHEN '9'  LET l_gaq02 = 'tt10'
        WHEN 'A'  LET l_gaq02 = 'tt11'
        WHEN 'B'  LET l_gaq02 = 'tt12'
        OTHERWISE LET l_gaq02 = 'aeh01'
   END CASE
   CASE tm.s3
        WHEN '1'  LET l_gaq03 = 'tt1'
        WHEN 'C'  LET l_gaq03 = 'tt2'
        WHEN '2'  LET l_gaq03 = 'tt3'
        WHEN '3'  LET l_gaq03 = 'tt4'
        WHEN '4'  LET l_gaq03 = 'tt5'
        WHEN '5'  LET l_gaq03 = 'tt6'
        WHEN '6'  LET l_gaq03 = 'tt7'
        WHEN '7'  LET l_gaq03 = 'tt8'
        WHEN '8'  LET l_gaq03 = 'tt9'
        WHEN '9'  LET l_gaq03 = 'tt10'
        WHEN 'A'  LET l_gaq03 = 'tt11'
        WHEN 'B'  LET l_gaq03 = 'tt12'
        OTHERWISE LET l_gaq03 = 'aeh01'
   END CASE
   LET g_sql = "SELECT aeh01,aag02,tt1,tt1_d,tt2,tt2_d,tt3,tt3_d,tt4,tt4_d,",
               "       tt5,tt5_d,tt6 ,tt6_d ,tt7 ,tt7_d ,tt8,tt8_d,",
               "       tt9,tt9_d,tt10,tt10_d,tt11,tt11_d,tt12,tt12_d,",
               "       aeh17,dc_qc,balf_qc,er_qc,bal_qc,",
               "       df_qj,er_d_qj,d_qj,cf_qj,er_c_qj,c_qj,",
               "       dc_qm,balf_qm,er_qm,bal_qm",
               "  FROM gglq307_tmp ",
               " ORDER BY aeh01,",l_gaq01,",",l_gaq02,",",l_gaq03

   PREPARE gglq307_pb FROM g_sql
   DECLARE aao_curs  CURSOR FOR gglq307_pb

   CALL g_aeh.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH aao_curs INTO g_aeh[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF tm.i = 'N' THEN  #不打印外幣
         LET t_azi04 = g_azi04
         LET t_azi07 = g_azi07
      ELSE
         SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
          WHERE azi01 = g_aeh[g_cnt].aeh17
         IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
         IF cl_null(t_azi07) THEN LET t_azi07 = 0 END IF
      END IF
      LET g_aeh[g_cnt].balf_qc = cl_numfor(g_aeh[g_cnt].balf_qc,20,t_azi04)
      LET g_aeh[g_cnt].bal_qc  = cl_numfor(g_aeh[g_cnt].bal_qc ,20,g_azi04)    #TQC-BB0246 modify t_azi->g_azi
      LET g_aeh[g_cnt].df_qj   = cl_numfor(g_aeh[g_cnt].df_qj  ,20,t_azi04)
      LET g_aeh[g_cnt].d_qj    = cl_numfor(g_aeh[g_cnt].d_qj   ,20,g_azi04)    #TQC-BB0246 modify t_azi->g_azi
      LET g_aeh[g_cnt].cf_qj   = cl_numfor(g_aeh[g_cnt].cf_qj  ,20,t_azi04)
      LET g_aeh[g_cnt].c_qj    = cl_numfor(g_aeh[g_cnt].c_qj   ,20,g_azi04)    #TQC-BB0246 modify t_azi->g_azi
      LET g_aeh[g_cnt].balf_qm = cl_numfor(g_aeh[g_cnt].balf_qm,20,t_azi04)
      LET g_aeh[g_cnt].bal_qm  = cl_numfor(g_aeh[g_cnt].bal_qm ,20,g_azi04)    #TQC-BB0246 modify t_azi->g_azi

      LET g_aeh[g_cnt].er_qc   = cl_numfor(g_aeh[g_cnt].er_qc  ,20,t_azi07)
      LET g_aeh[g_cnt].er_d_qj = cl_numfor(g_aeh[g_cnt].er_d_qj,20,t_azi07)
      LET g_aeh[g_cnt].er_c_qj = cl_numfor(g_aeh[g_cnt].er_c_qj,20,t_azi07)
      LET g_aeh[g_cnt].er_qm   = cl_numfor(g_aeh[g_cnt].er_qm  ,20,t_azi07)

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_aeh.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1

END FUNCTION

FUNCTION q307_out_1()
   LET g_prog = 'gglq307'
   LET g_sql = "aeh01.aeh_file.aeh01,",
               "aag02.aag_file.aag02,",
               "type.type_file.chr10,",
               "memo.type_file.chr50,",
               "tt1.abb_file.abb11,",
               "tt1_d.aee_file.aee04,",
               "tt2.abb_file.abb11,",
               "tt2_d.aee_file.aee04,",
               "tt3.abb_file.abb11,",
               "tt3_d.aee_file.aee04,",
               "tt4.abb_file.abb11,",
               "tt4_d.aee_file.aee04,",
               "tt5.abb_file.abb11,",
               "tt5_d.aee_file.aee04,",
               "tt6.abb_file.abb11,",
               "tt6_d.aee_file.aee04,",
               "tt7.abb_file.abb11,",
               "tt7_d.aee_file.aee04,",
               "tt8.abb_file.abb11,",
               "tt8_d.aee_file.aee04,",
               "tt9.abb_file.abb11,",
               "tt9_d.aee_file.aee04,",
               "tt10.abb_file.abb11,",
               "tt10_d.aee_file.aee04,",
               "tt11.abb_file.abb11,",
               "tt11_d.aee_file.aee04,",
               "tt12.abb_file.abb11,",
               "tt12_d.aee_file.aee04,",
               "qc_aah04.aah_file.aah04,",
               "qc_aah05.aah_file.aah05,",
               "qj_aah04.aah_file.aah04,",
               "qj_aah05.aah_file.aah05,",
               "qm_aah04.aah_file.aah04,",
               "qm_aah05.aah_file.aah05 "

   LET l_table = cl_prt_temptable('gglq307',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " ,
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " ,
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " ,
               "        ?, ?, ?, ?  )                 "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

END FUNCTION

FUNCTION q307_out_2()

   LET g_prog = 'gglq307'
   CALL cl_del_data(l_table)

   DECLARE cr_curs CURSOR FOR
    SELECT * FROM gglq307_tmp
   FOREACH cr_curs INTO g_pr.*
       EXECUTE insert_prep USING g_pr.*
   END FOREACH

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

   LET g_str = NULL
   LET g_str=g_str CLIPPED,";",tm.yy,";",tm.m1,";",tm.m2,";",g_azi04

   CALL cl_prt_cs3('gglq307','gglq307',g_sql,g_str)
END FUNCTION

FUNCTION q307_drill_gl()
   DEFINE l_wc    LIKE type_file.chr50

   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_aeh[l_ac].aeh01) THEN RETURN END IF

   #LET l_wc = 'aag01 like "',g_aeh[l_ac].aeh01,'%"'  #FUN-C80102  mark 
   LET l_wc = 'aah01 like "',g_aeh[l_ac].aeh01,'%"'   #FUN-C80102  add
   #FUN-D10072--mark--str--
   #TQC-C60238--add--str--
   #IF tm.g = '3' THEN
   #   LET g_msg = "gglq300 '",tm.bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' 'N' 'N' 'N' 'Y' '",tm.f,"' '' ",tm.yy," ",tm.m1," ",tm.m2," '' '' '' ''"     
   #ELSE
   #TQC-C60238--add--end--
   #   #LET g_msg = "gglq300 '",tm.bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' 'N' '", tm.g ,"' 'N' 'Y' '",tm.f,"' '' ",tm.yy," ",tm.m1," ",tm.m2," '' '' '' ''"      #TQC-C60238   mark
   #   LET g_msg = "gglq300 '",tm.bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' 'N' 'Y' 'N' 'Y' '",tm.f,"' '' ",tm.yy," ",tm.m1," ",tm.m2," '' '' '' ''"      #TQC-C60238   add  
   #END IF   #TQC-C60238   add
   #FUN-D10072--mark--end--
   #FUN-D10072--add--str--
   IF tm.g = '1' THEN
      LET g_msg = "gglq300 '",tm.bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' 'N' '",tm.g,"' 'N' 'Y' '",tm.f,"' '' ",tm.yy," ",tm.m1," ",tm.m2," '' '' '' '' 'Y' 'N' 'Y'"
   END IF 
   IF tm.g = '2' THEN
      LET g_msg = "gglq300 '",tm.bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' 'N' '1' 'N' 'Y' '",tm.f,"' '' ",tm.yy," ",tm.m1," ",tm.m2," '' '' '' '' 'Y' 'N' 'N'"
   END IF

   IF tm.g = '3' THEN
      LET g_msg = "gglq300 '",tm.bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' 'N' '2' 'N' 'Y' '",tm.f,"' '' ",tm.yy," ",tm.m1," ",tm.m2," '' '' '' '' 'Y' 'N' 'N'"
   END IF
   #FUN-D10072--add--end--
   CALL cl_cmdrun(g_msg)

END FUNCTION

FUNCTION q307_drill_gl2()
   DEFINE l_flag1     LIKE type_file.chr1
   DEFINE l_flag2     LIKE type_file.chr2
   DEFINE l_tt        LIKE abb_file.abb11
   DEFINE l_wc1       STRING
   DEFINE l_wc2       STRING
   DEFINE l_bdate     DATE
   DEFINE l_edate     DATE
   DEFINE l_date1     DATE
   DEFINE l_date2     DATE

   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_aeh[l_ac].aeh01) THEN RETURN END IF

   #IF tm.g = '3' THEN LET l_flag1 = 'N' ELSE LET l_flag1 = 'Y' END IF   #TQC-CC0122  mark
   IF tm.g = '3' THEN LET l_flag1 = '2' ELSE LET l_flag1 = '1' END IF    #TQC-CC0122  add
   CALL s_azn01(tm.yy,tm.m1) RETURNING l_bdate,l_date1
   CALL s_azn01(tm.yy,tm.m2) RETURNING l_date2,l_edate
   LET l_wc1 = 'aag01 = "',g_aeh[l_ac].aeh01,'"'    

   IF NOT cl_null(g_aeh[l_ac].tt12) THEN LET l_tt = g_aeh[l_ac].tt12 LET l_flag2 = '10' END IF
   IF NOT cl_null(g_aeh[l_ac].tt11) THEN LET l_tt = g_aeh[l_ac].tt11 LET l_flag2 = '9'  END IF
   IF NOT cl_null(g_aeh[l_ac].tt10) THEN LET l_tt = g_aeh[l_ac].tt10 LET l_flag2 = '8'  END IF
   IF NOT cl_null(g_aeh[l_ac].tt9)  THEN LET l_tt = g_aeh[l_ac].tt9  LET l_flag2 = '7'  END IF
   IF NOT cl_null(g_aeh[l_ac].tt8)  THEN LET l_tt = g_aeh[l_ac].tt8  LET l_flag2 = '6'  END IF
   IF NOT cl_null(g_aeh[l_ac].tt7)  THEN LET l_tt = g_aeh[l_ac].tt7  LET l_flag2 = '5'  END IF
   IF NOT cl_null(g_aeh[l_ac].tt6)  THEN LET l_tt = g_aeh[l_ac].tt6  LET l_flag2 = '4'  END IF
   IF NOT cl_null(g_aeh[l_ac].tt5)  THEN LET l_tt = g_aeh[l_ac].tt5  LET l_flag2 = '3'  END IF
   IF NOT cl_null(g_aeh[l_ac].tt4)  THEN LET l_tt = g_aeh[l_ac].tt4  LET l_flag2 = '2'  END IF
   IF NOT cl_null(g_aeh[l_ac].tt3)  THEN LET l_tt = g_aeh[l_ac].tt3  LET l_flag2 = '1'  END IF
   IF NOT cl_null(g_aeh[l_ac].tt2)  THEN LET l_tt = g_aeh[l_ac].tt2  LET l_flag2 = '99' END IF

   IF cl_null(l_tt) THEN RETURN END IF
   LET l_wc2 = 'ted02 = "',l_tt,'"'

   #同一行開啟的gglq702的單身內容都是完全相同的,故開啟哪個都無所謂
   CALL gglq307_gglq702(l_wc1,l_wc2,l_flag1,l_flag2,l_bdate,l_edate)

END FUNCTION

FUNCTION gglq307_gglq702(p_wc1,p_wc2,p_flag1,p_flag2,p_bdate,p_edate)
   DEFINE p_wc1       STRING
   DEFINE p_wc2       STRING
   DEFINE p_flag1     LIKE type_file.chr1
   DEFINE p_flag2     LIKE type_file.chr2
   DEFINE p_bdate     DATE
   DEFINE p_edate     DATE

   #LET g_msg = "gglq702 '",tm.bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",p_wc1 CLIPPED,"' '",p_wc2 CLIPPED,"' '",p_bdate,"' '",p_edate,"' '",p_flag2,"' '",tm.i,"' '",p_flag1,"' 'N' '' '' '' '' '' 'N'"   #FUN-C80102  add '' 'N'
   LET g_msg = "gglq702 '",tm.bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",p_wc1 CLIPPED,"' '",p_wc2 CLIPPED,"' '",p_bdate,"' '",p_edate,"' '",p_flag2,"' '",tm.i,"' '",p_flag1,"' 'N' '' '' '' '' '' 'N' '",tm.h,"'"   #FUN-C80102  add '' 'N'   #FUN-D40044 add tm.h
   CALL cl_cmdrun(g_msg)

END FUNCTION

FUNCTION q307_ui_setting()
   DEFINE l_str      STRING
   DEFINE l_str_d    STRING   #TQC-CC0122  add

   CALL cl_set_comp_visible("tt3,tt3_d,tt4,tt4_d,tt5,tt5_d,tt6,tt6_d",FALSE)
   CALL cl_set_comp_visible("tt7,tt7_d,tt8,tt8_d,tt9,tt9_d,tt10,tt10_d",FALSE)
   CALL cl_set_comp_visible("tt11,tt11_d,tt12,tt12_d",FALSE)
   LET l_str = ''
   LET l_str_d = ''   #TQC-CC0122  add
   CASE g_aaz.aaz88
      #TQC-CC0122--mark--str--
      #WHEN '1'   LET l_str = 'tt3,tt3_d'
      #WHEN '2'   LET l_str = 'tt3,tt3_d,tt4,tt4_d'
      #WHEN '3'   LET l_str = 'tt3,tt3_d,tt4,tt4_d,tt5,tt5_d'
      #WHEN '4'   LET l_str = 'tt3,tt3_d,tt4,tt4_d,tt5,tt5_d,tt6,tt6_d'
      #TQC-CC0122--mark--end--
     
      #TQC-CC0122--add--str--
      WHEN '1'   LET l_str = 'tt3'              LET l_str_d = 'tt3_d'
      WHEN '2'   LET l_str = 'tt3,tt4'          LET l_str_d = 'tt3_d,tt4_d'
      WHEN '3'   LET l_str = 'tt3,tt4,tt5'      LET l_str_d = 'tt3_d,tt4_d,tt5_d'
      WHEN '4'   LET l_str = 'tt3,tt4,tt5,tt6'  LET l_str_d = 'tt3_d,tt4_d,tt5_d,tt6_d'
      #TQC-CC0122--add--end--

#FUN-B50105   ---start   Mark
#     WHEN '5'   LET l_str = 'tt3,tt3_d,tt4,tt4_d,tt5,tt5_d,tt6,tt6_d,tt7,tt7_d'
#     WHEN '6'   LET l_str = 'tt3,tt3_d,tt4,tt4_d,tt5,tt5_d,tt6,tt6_d,tt7,tt7_d,tt8,tt8_d'
#     WHEN '7'   LET l_str = 'tt3,tt3_d,tt4,tt4_d,tt5,tt5_d,tt6,tt6_d,tt7,tt7_d,tt8,tt8_d,tt9,tt9_d'
#     WHEN '8'   LET l_str = 'tt3,tt3_d,tt4,tt4_d,tt5,tt5_d,tt6,tt6_d,tt7,tt7_d,tt8,tt8_d,tt9,tt9_d,tt10,tt10_d'
#     WHEN '9'   LET l_str = 'tt3,tt3_d,tt4,tt4_d,tt5,tt5_d,tt6,tt6_d,tt7,tt7_d,tt8,tt8_d,tt9,tt9_d,tt10,tt10_d,tt11,tt11_d'
#     WHEN '10'  LET l_str = 'tt3,tt3_d,tt4,tt4_d,tt5,tt5_d,tt6,tt6_d,tt7,tt7_d,tt8,tt8_d,tt9,tt9_d,tt10,tt10_d,tt11,tt11_d,tt12,tt12_d'
#FUN-B50105   ---end     Mark
   END CASE
#FUN-B50105   ---start   Add
   IF NOT cl_null(l_str) THEN LET l_str = l_str,"," END IF
   IF NOT cl_null(l_str_d) THEN LET l_str_d = l_str_d,"," END IF   #TQC-CC0122  add
   CASE g_aaz.aaz125
      #TQC-CC0122--mark--str--
      #WHEN '5'   LET l_str = l_str,'tt7,tt7_d'
      #WHEN '6'   LET l_str = l_str,'tt7,tt7_d,tt8,tt8_d'
      #WHEN '7'   LET l_str = l_str,'tt7,tt7_d,tt8,tt8_d,tt9,tt9_d'
      #WHEN '8'   LET l_str = l_str,'tt7,tt7_d,tt8,tt8_d,tt9,tt9_d,tt10,tt10_d'
      #TQC-CC0122--mark--end--

      #TQC-CC0122--add--str--
      WHEN '5'   LET l_str = l_str,'tt7'               LET l_str_d = l_str_d,'tt7_d'
      WHEN '6'   LET l_str = l_str,'tt7,tt8'           LET l_str_d = l_str_d,'tt7_d,tt8_d'
      WHEN '7'   LET l_str = l_str,'tt7,tt8,tt9'       LET l_str_d = l_str_d,'tt7_d,tt8_d,tt9_d'
      WHEN '8'   LET l_str = l_str,'tt7,tt8,tt9,tt10'  LET l_str_d = l_str_d,'tt7_d,tt8_d,tt9_d,tt10_d'
      #TQC-CC0122--add--end--
   END CASE
#FUN-B50105   ---end     Add
   CALL cl_set_comp_visible(l_str,TRUE)
   
   #TQC-CC0122--add--str--
   IF g_aaz.aaz119 = 'Y' THEN
      CALL cl_set_comp_visible(l_str_d,TRUE)
   END IF
   #TQC-CC0122--add--end--
END FUNCTION

FUNCTION q307_ui_setting_1()
   DEFINE l_str      STRING

   CALL cl_set_comp_visible("aeh04,aeh05,aeh06,aeh07,aeh31",FALSE)
   CALL cl_set_comp_visible("aeh32,aeh33,aeh34,aeh35,aeh36",FALSE)
   LET l_str = ''
   CASE g_aaz.aaz88
      WHEN '1'   LET l_str = 'aeh04'
      WHEN '2'   LET l_str = 'aeh04,aeh05'
      WHEN '3'   LET l_str = 'aeh04,aeh05,aeh06'
      WHEN '4'   LET l_str = 'aeh04,aeh05,aeh06,aeh07'
#FUN-B50105   ---start   Mark
#     WHEN '5'   LET l_str = 'aeh04,aeh05,aeh06,aeh07,aeh31'
#     WHEN '6'   LET l_str = 'aeh04,aeh05,aeh06,aeh07,aeh31,aeh32'
#     WHEN '7'   LET l_str = 'aeh04,aeh05,aeh06,aeh07,aeh31,aeh32,aeh33'
#     WHEN '8'   LET l_str = 'aeh04,aeh05,aeh06,aeh07,aeh31,aeh32,aeh33,aeh34'
#     WHEN '9'   LET l_str = 'aeh04,aeh05,aeh06,aeh07,aeh31,aeh32,aeh33,aeh34,aeh35'
#     WHEN '10'  LET l_str = 'aeh04,aeh05,aeh06,aeh07,aeh31,aeh32,aeh33,aeh34,aeh35,aeh36'
#FUN-B50105   ---end     Mark
   END CASE
#FUN-B50105   ---start   Add
   IF NOT cl_null(l_str) THEN LET l_str = l_str,"," END IF
   CASE g_aaz.aaz125
      WHEN '5'   LET l_str = l_str,'aeh31'
      WHEN '6'   LET l_str = l_str,'aeh31,aeh32'
      WHEN '7'   LET l_str = l_str,'aeh31,aeh32,aeh33'
      WHEN '8'   LET l_str = l_str,'aeh31,aeh32,aeh33,aeh34'
   END CASE
#FUN-B50105   ---end     Add
   CALL cl_set_comp_visible(l_str,TRUE)

END FUNCTION


