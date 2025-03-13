# Prog. Version..: '5.30.07-13.05.20(00010)'     #
#
# Pattern name...: gglq702.4gl
# Descriptions...: 核算項明細帳
# Input parameter:
# Return code....:
# Date & Author..: 08/06/11 By Carrier  #No.FUN-850030
# Modify.........: No.FUN-850030 08/07/24 By dxfwo 新增程序從21區移植到31區
# Modify.........: No.MOD-910048 09/01/13 By wujie 匯率計算反了
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-930163 09/04/01 By elva 新增按幣別分頁選項
# Modify.........: No.MOD-940388 09/04/30 By wujie 字串連接%前要加轉義符\
# Modify.........: No.FUN-8B0106 09/06/09 By Cockroach CR段修改
# Modify.........: No.TQC-970049 09/07/13 By xiaofeizhu 修改CR報表錯誤
# Modify.........: No.TQC-970310 09/07/28 By xiaofeizhu 調整期初數值不對的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0052 09/10/26 By Carrier 核算項11調整為99
# Modify.........: No.FUN-9C0072 10/01/10 By vealxu 精簡程式碼
# Modify.........: No.FUN-A40011 10/04/06 By lilingyu 科目編號 核算項值增加開窗查詢
# Modify.........: No:FUN-A40009 10/04/07 By wujie 查询界面点退出回到主画面，而不是关闭程序
#                                                  点击单据联查按钮后，光标保持在原来所在的行，而不是回到第一行
# Modify.........: No.FUN-A40020 10/04/09 By Carrier 独立科目层及设置为1 
# Modify.........: No.TQC-A50151 10/05/26 By Carrier 加一行LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
# Modify.........: No:TQC-A80026 10/08/06 By xiaofeizhu 增加幣別INPUT選項,可以單一幣種打印
# Modify.........: No:MOD-A80039 10/08/05 By xiaofeizhu 不打印外幣時，從aed_file抓取資料
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.FUN-B20055 11/02/22 By destiny 輸入改為DIALOG寫法 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:CHI-B30027 11/04/27 By Sarah 勾選列印外幣時請預設勾選按幣別分頁,這樣才能查詢出原幣餘額
# Modify.........: No:MOD-B50163 11/05/18 By Dido 排序問題調整 
# Modify.........: No:TQC-B60041 11/06/09 By wujie 本年合计扣除年期初
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No.TQC-C50211 12/05/28 By wujie 无法显示核算项资料来源为缺省时的核算项名称
# Modify.........: No:CHI-C70031 12/10/18 By fengmy 去除CE、CA憑證資料，否則月末結轉損益後，查詢不到損益類科目
# Modify.........: No.FUN-C80102 12/10/17 By zhangweib 財務報表改善追單
# Modify.........: No.TQC-CC0122 13/01/11 By lujh 1、接受參數順序有誤 2、agls103中顯示核算項名稱aaz119=N時，隱藏核算項名稱 3、打印外幣欄位無法開窗
#                                                 4、起始日期和截止日期不在同一年度時報錯提示  
# Modify.........: No:FUN-D40044 13/04/25 By lujh 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額
# Modify.........: No:TQC-D60020 13/06/21 By yangtt 1.單身科目編號欄位開窗建議增加科目名稱欄位的顯示
#                                                   2.單身核算項值欄位開窗建議增加核算項名稱欄位的顯示
# Modify.........: No.TQC-DC0064 13/12/19 By wangrr 當'單據狀態'為'2:已過帳'時'含未審核憑證'不顯示
# Modify.........: No.CHI-D60013 18/11/21 By lixwz  结果顺序修正
# Modify.........: No:181217     18/12/17 By pulf  调整No.CHI-D60013顺序逻辑

DATABASE ds
 
GLOBALS "../../config/top.global"  #No.FUN-850030
 
   DEFINE tm      RECORD
                  wc1      STRING,
                  wc2      STRING,
                  a        LIKE type_file.chr2,
                  b        LIKE type_file.chr2,
                  e        LIKE azi_file.azi01, #TQC-A80026 Add
                  #c        LIKE type_file.chr2,    #FUN-C80102  mark
                  f        LIKE type_file.chr2,     #FUN-C80102  add
                  m        LIKE type_file.chr2,     #FUN-C80102  add
                  #d        LIKE type_file.chr1, #TQC-930163   #FUN-C80102  mark
                  g        LIKE type_file.chr1,     #FUN-C80102  add
                  i        LIKE type_file.chr1,     #FUN-D40044  add
                  more     LIKE type_file.chr1
                  END RECORD,
          yy,mm            LIKE type_file.num10,
          mm1,nn1          LIKE type_file.num10,
          bdate,edate      LIKE type_file.dat,
          l_flag           LIKE type_file.chr1,
          bookno           LIKE aaa_file.aaa01,
          g_cnnt           LIKE type_file.num5
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING
 
DEFINE   g_field    LIKE gaq_file.gaq01
DEFINE   g_gaq01    LIKE gaq_file.gaq01
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_aag01    LIKE ted_file.ted01
DEFINE   g_aag02    LIKE aag_file.aag02
DEFINE   g_ted02    LIKE ted_file.ted02
DEFINE   g_ted02_d  LIKE ze_file.ze03
DEFINE   g_ted09    LIKE ted_file.ted09 #TQC-930163
DEFINE   g_aba04    LIKE aba_file.aba04
DEFINE   g_abb      DYNAMIC ARRAY OF RECORD
                    aag01      LIKE aag_file.aag01,    #FUN-C80102  add
                    aag02      LIKE aag_file.aag02,    #FUN-C80102  add
                    ted02      LIKE ted_file.ted02,    #FUN-C80102  add
                    ted02_d    LIKE ze_file.ze03,      #FUN-C80102  add
                    aba02      LIKE aba_file.aba02,
                    aba01      LIKE aba_file.aba01,
                    abb04      LIKE abb_file.abb04,
                    abb24      LIKE abb_file.abb24,
                    df         LIKE abb_file.abb07,
                    abb25_d    LIKE abb_file.abb25,
                    d          LIKE abb_file.abb07,
                    cf         LIKE abb_file.abb07,
                    abb25_c    LIKE abb_file.abb25,
                    c          LIKE abb_file.abb07,
                    dc         LIKE type_file.chr10,
                    balf       LIKE abb_file.abb07,
                    abb25_bal  LIKE abb_file.abb25,
                    bal        LIKE abb_file.abb07
                    END RECORD
DEFINE   g_pr       RECORD
                    aag01      LIKE aag_file.aag01,
                    aag02      LIKE type_file.chr1000,
                    ted02      LIKE ted_file.ted02,
                    ted02_d    LIKE ze_file.ze03,
                    aba04      LIKE aba_file.aba04,
                    type       LIKE type_file.chr1,
                    aba02      LIKE aba_file.aba02,
                    aba01      LIKE aba_file.aba01,
                    abb04      LIKE abb_file.abb04,
                    abb24      LIKE abb_file.abb24,
                    abb06      LIKE abb_file.abb06,
                    abb07      LIKE abb_file.abb07,
                    abb07f     LIKE abb_file.abb07f,
                    d          LIKE abb_file.abb07,
                    df         LIKE abb_file.abb07,
                    abb25_d    LIKE abb_file.abb25,
                    c          LIKE abb_file.abb07,
                    cf         LIKE abb_file.abb07,
                    abb25_c    LIKE abb_file.abb25,
                    dc         LIKE type_file.chr10,
                    bal        LIKE abb_file.abb07,
                    balf       LIKE abb_file.abb07,
                    abb25_bal  LIKE abb_file.abb25,
                    pagenum    LIKE type_file.num5,
                    azi04      LIKE azi_file.azi04,
                    azi05      LIKE azi_file.azi05,
                    azi07      LIKE azi_file.azi07
                    END RECORD
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   l_ac           LIKE type_file.num5
DEFINE   g_aee02        LIKE aee_file.aee02   #No.TQC-C50211
DEFINE   g_comb         ui.ComboBox           #FUN-C80102 add
DEFINE   l_cnt          LIKE type_file.num5   #No:181217 add 
 
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
 
   LET bookno     = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.wc1     = ARG_VAL(8)
   LET tm.wc1    = cl_replace_str(tm.wc1, "\\\"", "'")   #FUN-C80102 add
   LET tm.wc2     = ARG_VAL(9)
   LET tm.wc2    = cl_replace_str(tm.wc2, "\\\"", "'")   #FUN-C80102 add
   LET bdate      = ARG_VAL(10)
   LET edate      = ARG_VAL(11)
   LET tm.a       = ARG_VAL(12)
   LET tm.b       = ARG_VAL(13)
   #LET tm.c       = ARG_VAL(14)   #FUN-C80102  mark
   LET tm.f       = ARG_VAL(14)    #FUN-C80102  add
   #LET tm.d       = ARG_VAL(15)   #FUN-C80102  mark
   #LET tm.g       = ARG_VAL(14)    #FUN-C80102  add   TQC-CC0122 mark
   LET tm.g       = ARG_VAL(15)    #TQC-CC0122  add
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)
   LET tm.e       = ARG_VAL(20)    #TQC-A80026 Add
   LET tm.m       = ARG_VAL(21)    #FUN-C80102  add
   LET tm.i       = ARG_VAL(22)    #FUN-D40044 add 
 
   CALL q702_out_1()
   IF bookno IS NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81
   END IF
 
   OPEN WINDOW q702_w AT 5,10
        WITH FORM "ggl/42f/gglq702_1" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL gglq702_tm()
      ELSE 
         #IF tm.d = 'N' THEN  #FUN-C80102  mark
         IF tm.g = 'N' THEN   #FUN-C80102  add
           CALL gglq702()
         ELSE  
           CALL gglq702_1()
         END IF
           CALL gglq702_t()
   END IF
 
   CALL q702_menu()
   DROP TABLE gglq702_tmp;
   CLOSE WINDOW q702_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q702_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q702_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq702_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q702_out_2()
            END IF
         WHEN "drill_down"
            IF cl_chk_act_auth() THEN
               CALL q702_drill_down()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_abb),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_aag01 IS NOT NULL THEN
                  LET g_doc.column1 = "ted01"
                  LET g_doc.value1 = g_aag01
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION gglq702_tm()
   DEFINE lc_qbe_sn       LIKE gbm_file.gbm01    #FUN-C80102  add
   DEFINE p_row,p_col     LIKE type_file.num5,
          l_i             LIKE type_file.num5,
          l_cmd           LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5     #FUN-B20010 add

   CLEAR FORM #清除畫面   #FUN-C80102  add
   CALL g_abb.clear()   #FUN-C80102  add 
 
   CALL s_dsmark(bookno)

   #FUN-C80102--mark--str---
   #LET p_row = 4 LET p_col = 12
   #OPEN WINDOW gglq702_w1 AT p_row,p_col
   #     WITH FORM "ggl/42f/gglq702"
   #     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #CALL cl_ui_locale("gglq702")
   #FUN-C80102--mark--end---

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
 
   #TQC-CC0122--add--str--
   IF g_aaz.aaz119 ='N' THEN
      CALL cl_set_comp_visible("ted02_d",FALSE)
   ELSE
      CALL cl_set_comp_visible("ted02_d",TRUE)
   END IF
   CALL cl_set_comp_entry('e',FALSE) 
   #TQC-CC0122--add--end--

   CALL s_shwact(0,0,bookno)
   CALL cl_opmsg('p')
   CALL q702_getday()   #FUN-C80102  add
   INITIALIZE tm.* TO NULL
   #LET bdate   = g_today     #FUN-C80102  mark
   #LET edate   = g_today     #FUN-C80102  mark
   LET tm.a    = '1'
   LET tm.b    = 'N'
   LET tm.e    = ''  #TQC-A80026 Add
   #LET tm.c    = 'N'    #FUN-C80102  mark
   LET tm.f    = '1'     #FUN-C80102  add
   #LET tm.d    = 'N' #TQC-930163  #FUN-C80102  mark
   LET tm.g    = 'N'     #FUN-C80102  add 
   LET tm.m    = 'N'     #FUN-C80102  add 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.i ='N'    #FUN-D40044 add
   WHILE TRUE
     #No.FUN-B20010  --Begin
     #DISPLAY BY NAME bookno    #FUN-C80102  mark
     #FUN-B20055--begin
#     INPUT BY NAME bookno WITHOUT DEFAULTS
# 
#        AFTER FIELD bookno
#            IF cl_null(bookno) THEN NEXT FIELD bookno END IF
#            CALL s_check_bookno(bookno,g_user,g_plant)
#                 RETURNING li_chk_bookno
#            IF (NOT li_chk_bookno) THEN
#               NEXT FIELD bookno
#            END IF
#            SELECT * FROM aaa_file WHERE aaa01 = bookno
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("sel","aaa_file",bookno,"","aap-229","","",0)
#               NEXT FIELD bookno
#            END IF
#            
#        ON ACTION CONTROLZ
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG CALL cl_cmdask()
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
# 
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(bookno)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_aaa'
#                 LET g_qryparam.default1 =bookno
#                 CALL cl_create_qry() RETURNING bookno
#                 DISPLAY BY NAME bookno
#                 NEXT FIELD bookno                           
#           END CASE
# 
#        ON ACTION about
#           CALL cl_about()
# 
#        ON ACTION help
#           CALL cl_show_help()
# 
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT INPUT
#     END INPUT
#     #No.FUN-B20010  --End
#     
#     CONSTRUCT BY NAME tm.wc1 ON aag01
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(aag01)
#                 CALL cl_init_qry_var()
##                LET g_qryparam.form = 'q_aag'         #FUN-A40011
#                 LET g_qryparam.form = 'q_aag12'       #FUN-A40011 
#                 LET g_qryparam.state= 'c'
#                 LET g_qryparam.where = " ted00 = '",bookno CLIPPED,"'"   #FUN-B20010 add 
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO aag01
#                 NEXT FIELD aag01
#           END CASE
# 
#        ON ACTION locale
#           CALL cl_show_fld_cont()
#           LET g_action_choice = "locale"
#           EXIT CONSTRUCT
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
# 
#        ON ACTION about
#           CALL cl_about()
# 
#        ON ACTION help
#           CALL cl_show_help()
# 
#        ON ACTION controlg
#           CALL cl_cmdask()
# 
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#     END CONSTRUCT
#     IF g_action_choice = "locale" THEN
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE
#     END IF
# 
#     IF INT_FLAG THEN
##FUN-A40009 --begin
##       LET INT_FLAG = 0 CLOSE WINDOW gglq702_w1 EXIT PROGRAM
##    END IF
#     ELSE
##FUN-A40009 --end
# 
#     CONSTRUCT BY NAME tm.wc2 ON ted02
##FUN-A40011 --begin--
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(ted02)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_ted'       
#                 LET g_qryparam.state= 'c'
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO ted02
#                 NEXT FIELD ted02
#           END CASE
##FUN-A40011 --end--     
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
# 
#        ON ACTION about
#           CALL cl_about()
# 
#        ON ACTION help
#           CALL cl_show_help()
# 
#        ON ACTION controlg
#           CALL cl_cmdask()
# 
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#     END CONSTRUCT
#     IF g_action_choice = "locale" THEN
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE
#     END IF
##No.FUN-A40009 --begin
#     IF INT_FLAG THEN
##        LET INT_FLAG = 0 CLOSE WINDOW gglq702_w1 EXIT PROGRAM
##    END IF
#     ELSE
##No.FUN-A40009 --end
# 
#     DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.more #TQC-930163
#     #INPUT BY NAME bookno,bdate,edate,tm.a,tm.c,tm.b,tm.e,tm.d,tm.more #TQC-930163  #TQC-A80026 Add tm.e #FUN-B20010
#     INPUT BY NAME bdate,edate,tm.a,tm.c,tm.b,tm.e,tm.d,tm.more #FUN-B20010 去掉bookno
#           WITHOUT DEFAULTS
#       
#       #No.FUN-B20010  --Begin
#       #AFTER FIELD bookno
#       #   IF cl_null(bookno) THEN NEXT FIELD bookno END IF
#       #   SELECT aaa02 FROM aaa_file WHERE aaa01=bookno AND aaaacti IN ('Y','y')
#       #   IF STATUS THEN CALL cl_err('sel aaa:',STATUS,0) NEXT FIELD bookno END IF
#       #No.FUN-B20010  --End
#       
#        AFTER FIELD bdate
#           IF cl_null(bdate) THEN
#              NEXT FIELD bdate
#           END IF
# 
#        AFTER FIELD edate
#           IF cl_null(edate) THEN
#              LET edate =g_lastdat
#           ELSE
#              IF YEAR(bdate) <> YEAR(edate) THEN NEXT FIELD edate END IF
#           END IF
#           IF edate < bdate THEN
#              CALL cl_err(' ','agl-031',0)
#              NEXT FIELD edate
#           END IF
# 
#        AFTER FIELD a
#           IF tm.a NOT MATCHES "[123456789]" AND tm.a <> "10"
#              AND tm.a <> "99" THEN  #No.FUN-9A0052
#              NEXT FIELD a
#           END IF
#
##        AFTER FIELD b                                          #TQC-A80026 Mark
##          IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF  #TQC-A80026 Mark
#
#        #TQC-970049  --begin
##        ON CHANGE b                                            #TQC-A80026 Mark
##           IF tm.b = 'N' THEN                                  #TQC-A80026 Mark
##              LET tm.d = 'N'                                   #TQC-A80026 Mark
##              DISPLAY tm.d TO d                                #TQC-A80026 Mark
##           END IF                                              #TQC-A80026 Mark
#
#        #TQC-A80026--Add--Begin
#        AFTER FIELD b
#           IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF
#           IF tm.b='Y' THEN 
#              CALL cl_set_comp_entry('e',TRUE)
#           ELSE
#           	  CALL cl_set_comp_entry('e',FALSE)
#           	  LET tm.e=''
#           	  DISPLAY tm.e TO e
#           END IF
#             
#        ON CHANGE b
#           IF tm.b='Y' THEN 
#              CALL cl_set_comp_entry('e',TRUE)
#           ELSE
#              LET tm.d = 'N' 
#              DISPLAY tm.d TO d          
#           	  CALL cl_set_comp_entry('e',FALSE)
#           	  LET tm.e=''
#           	  DISPLAY tm.e TO e 
#           END IF
#             
#        AFTER FIELD e
#           IF NOT cl_null(tm.e) THEN 
#              SELECT azi01 FROM azi_file WHERE azi01 = tm.e
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err(tm.e,'agl-109',0)   
#                 NEXT FIELD e
#              END IF
#           END IF
#        #TQC-A80026--Add--End
# 
#        ON CHANGE d
#           IF tm.d = 'Y' THEN 
#              LET tm.b = 'Y' 
#              DISPLAY tm.b TO b
#           END IF
# 
#        AFTER FIELD c
#           IF tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
# 
#        AFTER FIELD more
#           IF tm.more = 'Y'
#              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                        g_bgjob,g_time,g_prtway,g_copies)
#              RETURNING g_pdate,g_towhom,g_rlang,
#                        g_bgjob,g_time,g_prtway,g_copies
#           END IF
# 
#        ON ACTION CONTROLZ
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG CALL cl_cmdask()
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
# 
#        ON ACTION CONTROLP
#           CASE
#             #No.FUN-B20010  --Begin
#             #WHEN INFIELD(bookno)
#             #   CALL cl_init_qry_var()
#             #   LET g_qryparam.form = 'q_aaa'
#             #   LET g_qryparam.default1 =bookno
#             #   CALL cl_create_qry() RETURNING bookno
#             #   DISPLAY BY NAME bookno
#             #   NEXT FIELD bookno
#             #No.FUN-B20010  --End
#              #TQC-A80026--Add--Begin   
#              WHEN INFIELD(e)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_azi'
#                 LET g_qryparam.default1 =tm.e
#                 CALL cl_create_qry() RETURNING tm.e
#                 DISPLAY BY NAME tm.e
#                 NEXT FIELD e
#              #TQC-A80026--Add--End                 
#           END CASE
# 
#        ON ACTION about
#           CALL cl_about()
# 
#        ON ACTION help
#           CALL cl_show_help()
# 
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT INPUT
#     END INPUT
     #DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.more   #FUN-C80102  mark
     #FUN-C80102--mark--str--
     #DIALOG ATTRIBUTES(UNBUFFERED)
     
     #INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
 
     #   AFTER FIELD bookno
     #       IF cl_null(bookno) THEN NEXT FIELD bookno END IF
     #       CALL s_check_bookno(bookno,g_user,g_plant)
     #            RETURNING li_chk_bookno
     #       IF (NOT li_chk_bookno) THEN
     #          NEXT FIELD bookno
     #       END IF
     #       SELECT * FROM aaa_file WHERE aaa01 = bookno
     #       IF SQLCA.sqlcode THEN
     #          CALL cl_err3("sel","aaa_file",bookno,"","aap-229","","",0)
     #          NEXT FIELD bookno
     #       END IF
                                       
     #END INPUT
     
     #CONSTRUCT BY NAME tm.wc1 ON aag01

     #END CONSTRUCT
  
     #CONSTRUCT BY NAME tm.wc2 ON ted02

     #END CONSTRUCT
     #FUN-C80102--mark--end--
     
     #INPUT BY NAME bdate,edate,tm.a,tm.c,tm.b,tm.e,tm.d,tm.more ATTRIBUTE(WITHOUT DEFAULTS=TRUE)   #FUN-C80102  mark
     #FUN-C80102--add--str---
     DIALOG ATTRIBUTES(UNBUFFERED)
     INPUT BY NAME bookno,bdate,edate,tm.a,tm.f,tm.m,tm.b,tm.e,tm.g,tm.i ATTRIBUTE(WITHOUT DEFAULTS=TRUE)   #FUN-D40044 tm.i   
        
        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

        AFTER FIELD bookno
            IF cl_null(bookno) THEN NEXT FIELD bookno END IF
            CALL s_check_bookno(bookno,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD bookno
            END IF
            SELECT * FROM aaa_file WHERE aaa01 = bookno
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",bookno,"","aap-229","","",0)
               NEXT FIELD bookno
            END IF
      #FUN-C80102--add--end---
            
        AFTER FIELD bdate
           IF cl_null(bdate) THEN
              NEXT FIELD bdate
           END IF
 
        AFTER FIELD edate
           IF cl_null(edate) THEN
              LET edate =g_lastdat
           ELSE
              #IF YEAR(bdate) <> YEAR(edate) THEN NEXT FIELD edate END IF   #TQC-CC0122  mark 
              #TQC-CC0122--add--str--
              IF s_get_aznn(g_plant,bookno,bdate,1) <> s_get_aznn(g_plant,bookno,edate,1) THEN   
                 CALL cl_err('','gxr-001',0)
                 NEXT FIELD bdate
              END IF
              #TQC-CC0122--add--end--
           END IF
           IF edate < bdate THEN
              CALL cl_err(' ','agl-031',0)
              NEXT FIELD edate
           END IF
 
        AFTER FIELD a
           IF tm.a NOT MATCHES "[123456789]" AND tm.a <> "10"
              AND tm.a <> "99" THEN  #No.FUN-9A0052
              NEXT FIELD a
           END IF

       ON CHANGE m
           IF tm.m NOT MATCHES "[YyNn]" THEN NEXT FIELD m END IF

        AFTER FIELD b
           IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF
           IF tm.b='Y' THEN 
              CALL cl_set_comp_entry('e',TRUE)
              #LET tm.d='Y'       #CHI-B30027 add   #FUN-C80102  mark
              #DISPLAY tm.d TO d  #CHI-B30027 add   #FUN-C80102  mark
              LET tm.g='Y'            #FUN-C80102  add
              DISPLAY tm.g TO g       #FUN-C80102  add
           ELSE
              CALL cl_set_comp_entry('e',FALSE)
              LET tm.e=''
              DISPLAY tm.e TO e
           END IF
             
        ON CHANGE b
           IF tm.b='Y' THEN 
              CALL cl_set_comp_entry('e',TRUE)
              #LET tm.d='Y'       #CHI-B30027 add   #FUN-C80102  mark
              #DISPLAY tm.d TO d  #CHI-B30027 add   #FUN-C80102  mark
              LET tm.g='Y'        #FUN-C80102  add
              DISPLAY tm.g TO g   #FUN-C80102  add  
           ELSE
              #LET tm.d = 'N'       #FUN-C80102  mark
              #DISPLAY tm.d TO d    #FUN-C80102  mark
              LET tm.g = 'N'        #FUN-C80102  add
              DISPLAY tm.g TO g     #FUN-C80102  add
           	  CALL cl_set_comp_entry('e',FALSE)
           	  LET tm.e=''
           	  DISPLAY tm.e TO e 
           END IF
             
        AFTER FIELD e
           IF NOT cl_null(tm.e) THEN 
              SELECT azi01 FROM azi_file WHERE azi01 = tm.e
              IF SQLCA.sqlcode THEN
                 CALL cl_err(tm.e,'agl-109',0)   
                 NEXT FIELD e
              END IF
           END IF

        #FUN-C80102--mark--str--
        #ON CHANGE d
        #   IF tm.d = 'Y' THEN 
        #      LET tm.b = 'Y' 
        #      DISPLAY tm.b TO b
        #   END IF
        #FUN-C80102--mark--end--

        #FUN-C80102--add--str--
        ON CHANGE g
           IF tm.g = 'Y' THEN 
              LET tm.b = 'Y' 
              DISPLAY tm.g TO g
              DISPLAY tm.b TO b
           END IF
        #FUN-C80102--add--end--

        #FUN-C80102--mark--str---
        #AFTER FIELD c
        #   IF tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
        #FUN-C80102--mark--end---

        #FUN-C80102--add--str---
        ON CHANGE f
           #IF tm.f NOT MATCHES "[YN]" THEN NEXT FIELD f END IF #TQC-DC0064 mark
           #TQC-DC0064--add--str--
           IF tm.f='2' THEN
              LET tm.m='N'
              CALL cl_set_comp_visible("m",FALSE)
           ELSE
              CALL cl_set_comp_visible("m",TRUE)
           END IF
           #TQC-DC0064--add--end
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
        #                g_bgjob,g_time,g_prtway,g_copies)
        #      RETURNING g_pdate,g_towhom,g_rlang,
        #                g_bgjob,g_time,g_prtway,g_copies
        #   END IF
        #FUN-C80102--mark--add---
 
     #END INPUT   #FUN-C80102 mark

     #TQC-CC0122--unmark--str--
     #FUN-C80102--mark--str--
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(bookno)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa'
                LET g_qryparam.default1 =bookno
                CALL cl_create_qry() RETURNING bookno
                DISPLAY BY NAME bookno
                NEXT FIELD bookno
      #        WHEN INFIELD(aag01)
      #           CALL cl_init_qry_var()
      #           LET g_qryparam.form = 'q_aag12'       #FUN-A40011
      #           LET g_qryparam.state= 'c'
      #           LET g_qryparam.where = " ted00 = '",bookno CLIPPED,"'"   #FUN-B20010 add
      #           CALL cl_create_qry() RETURNING g_qryparam.multiret
      #           DISPLAY g_qryparam.multiret TO aag01
      #           NEXT FIELD aag01
      #        WHEN INFIELD(ted02)
      #           CALL cl_init_qry_var()
      #           LET g_qryparam.form = 'q_ted'
      #           LET g_qryparam.state= 'c'
      #           CALL cl_create_qry() RETURNING g_qryparam.multiret
      #           DISPLAY g_qryparam.multiret TO ted02
      #           NEXT FIELD ted02
              WHEN INFIELD(e)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_azi'
                LET g_qryparam.default1 =tm.e
                CALL cl_create_qry() RETURNING tm.e
                DISPLAY BY NAME tm.e
                NEXT FIELD e
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
       #TQC-CC0122--unmark--end--

       # ON ACTION accept
       #    EXIT DIALOG
       #
       # ON ACTION cancel
       #    LET INT_FLAG = 1
       #    EXIT DIALOG
       #FUN-C80102--mark--end--
                  
     #END DIALOG    #FUN-C80102 mark
     END INPUT      #FUN-C80102 add
     #FUN-C80102--add--str--
     CONSTRUCT tm.wc1 ON aag01
                  FROM s_abb[1].aag01
     BEFORE CONSTRUCT
        CALL cl_qbe_init()

       ON ACTION CONTROLP
         CASE 
           WHEN INFIELD(aag01)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = 'q_aag12'     #TQC-D60020
                 LET g_qryparam.form = 'q_aag12_1'   #TQC-D60020       
                 LET g_qryparam.state= 'c'
                 LET g_qryparam.where = " ted00 = '",bookno CLIPPED,"'"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aag01
                 NEXT FIELD aag01           
              #TQC-CC0122--mark--str--
              #WHEN INFIELD(bookno)
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form = 'q_aaa'
              #   LET g_qryparam.default1 =bookno
              #   CALL cl_create_qry() RETURNING bookno
              #   DISPLAY BY NAME bookno
              #   NEXT FIELD bookno
              #WHEN INFIELD(e)
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form = 'q_azi'
              #   LET g_qryparam.default1 =tm.e
              #   CALL cl_create_qry() RETURNING tm.e
              #   DISPLAY BY NAME tm.e
              #   NEXT FIELD e
              #TQC-CC0122--mark--end--
         END CASE

     END CONSTRUCT
     CONSTRUCT tm.wc2 ON ted02
                   FROM s_abb[1].ted02
     BEFORE CONSTRUCT
       CALL cl_qbe_init()

       ON ACTION CONTROLP
         CASE 
           WHEN INFIELD(ted02)                                                
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = 'q_ted'  #TQC-D60020
                 LET g_qryparam.form = 'q_aee1'  #TQC-D60020       
                 LET g_qryparam.state= 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ted02
                 NEXT FIELD ted02         
         END CASE
     END CONSTRUCT

     ON ACTION accept
        EXIT DIALOG        
       
     ON ACTION cancel
        LET INT_FLAG=1
        EXIT DIALOG       
    END DIALOG  
    #FUN-C80102--add--end--
     
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW gglq702_w1
        RETURN
     END IF          
     #FUN-B20055--end 
#No.FUN-A40009 --begin
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0 CLOSE WINDOW gglq702_w1 EXIT PROGRAM
#    END IF
#No.FUN-A40009 --end
     #FUN-C80102--mark--str--
     #LET mm1 = MONTH(bdate)
     #LET nn1 = MONTH(edate)
     #FUN-C80102--mark--end--
     #FUN-C80102--add--str--
     LET mm1 = s_get_aznn(g_plant,g_aza.aza81,bdate,3)
     LET nn1 = s_get_aznn(g_plant,g_aza.aza81,edate,3)
     #FUN-C80102--add--end--
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file
         WHERE zz01='gglq702'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglq702','9031',1)
        ELSE
           LET tm.wc1=cl_wcsub(tm.wc1)
           LET l_cmd = l_cmd CLIPPED,
                      " '",bookno CLIPPED,"'",
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                      " '",g_rlang CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.wc1 CLIPPED,"'",
                      " '",tm.wc2 CLIPPED,"'",
                      " '",bdate CLIPPED,"'",
                      " '",edate CLIPPED,"'",
                      " '",tm.a CLIPPED,"'",
                      " '",tm.b CLIPPED,"'",
                      #" '",tm.c CLIPPED,"'",    #FUN-C80102  mark
                      " '",tm.f CLIPPED,"'",     #FUN-C80102  add
                      " '",tm.m CLIPPED,"'",     #FUN-C80102  add
                      #" '",tm.d CLIPPED,"'", #TQC-930163   #FUN-C80102  mark
                      " '",tm.g CLIPPED,"'",     #FUN-C80102  add
                      " '",g_rep_user CLIPPED,"'",
                      " '",g_rep_clas CLIPPED,"'",
                      " '",g_template CLIPPED,"'",
                      " '",g_rpt_name CLIPPED,"'",
                      " '",tm.e       CLIPPED,"'"    #TQC-A80026 ADD
           CALL cl_cmdat('gglq702',g_time,l_cmd)
        END IF
        CLOSE WINDOW gglq702_w1   
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     #END IF           #No.FUN-A40009
     #END IF           #No.FUN-A40009
     CALL cl_wait()
     #IF tm.d = 'N' THEN   #FUN-C80102  mark
     IF tm.g = 'N' THEN    #FUN-C80102  add
        CALL gglq702()
     ELSE
        CALL gglq702_1()
     END IF
     ERROR ""
     EXIT WHILE
   END WHILE
   #CLOSE WINDOW gglq702_w1   #FUN-C80102  mark
#No.FUN-A40009 --begin  
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF           
#No.FUN-A40009 --end 
   CALL gglq702_t()
 
END FUNCTION
 
FUNCTION gglq702_curs1()
  DEFINE #l_sql   LIKE type_file.chr1000
         l_sql   STRING      #NO.FUN-910082
  DEFINE #l_sql1  LIKE type_file.chr1000
         l_sql1   STRING      #NO.FUN-910082
  DEFINE 
         l_wc2         STRING       #NO.FUN-910082

     #FUN-C80102--mark--str--
     #LET mm1 = MONTH(bdate)
     #LET nn1 = MONTH(edate)
     #FUN-C80102--mark--end--
     #FUN-C80102--add--str--
     LET mm1 = s_get_aznn(g_plant,g_aza.aza81,bdate,3)
     LET nn1 = s_get_aznn(g_plant,g_aza.aza81,edate,3)
     #FUN-C80102--add--end--
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
     CASE tm.a
          WHEN '1'   LET g_field = 'abb11'
                     LET g_gaq01 = 'aag15'
                     LET g_aee02 ='1'        #No.TQC-C50211
          WHEN '2'   LET g_field = 'abb12'
                     LET g_gaq01 = 'aag16'
                     LET g_aee02 ='2'        #No.TQC-C50211
          WHEN '3'   LET g_field = 'abb13'
                     LET g_gaq01 = 'aag17'
                     LET g_aee02 ='3'        #No.TQC-C50211
          WHEN '4'   LET g_field = 'abb14'
                     LET g_gaq01 = 'aag18'
                     LET g_aee02 ='4'        #No.TQC-C50211
          WHEN '5'   LET g_field = 'abb31'
                     LET g_gaq01 = 'aag31'
                     LET g_aee02 ='5'        #No.TQC-C50211
          WHEN '6'   LET g_field = 'abb32'
                     LET g_gaq01 = 'aag32'
                     LET g_aee02 ='6'        #No.TQC-C50211
          WHEN '7'   LET g_field = 'abb33'
                     LET g_gaq01 = 'aag33'
                     LET g_aee02 ='7'        #No.TQC-C50211
          WHEN '8'   LET g_field = 'abb34'
                     LET g_gaq01 = 'aag34'
                     LET g_aee02 ='8'        #No.TQC-C50211
          WHEN '9'   LET g_field = 'abb35'
                     LET g_gaq01 = 'aag35'
                     LET g_aee02 ='9'        #No.TQC-C50211
          WHEN '10'  LET g_field = 'abb36'
                     LET g_gaq01 = 'aag36'
                     LET g_aee02 ='10'        #No.TQC-C50211
          WHEN '99'  LET g_field = 'abb37'  #No.FUN-9A0052
                     LET g_gaq01 = 'aag37'
                     LET g_aee02 ='99'        #No.TQC-C50211
     END CASE
     IF cl_null(g_field) THEN 
        LET g_field = 'abb11'
     END IF
     IF cl_null(g_gaq01) THEN
        LET g_gaq01 = 'aag15'
     END IF
 
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
 
     #查找科目
     LET l_sql1= "SELECT aag01,aag02 FROM aag_file ",
                 " WHERE aag03 ='2' ",
                 "   AND aag00 = '",bookno,"' ",
#                "   AND aag24 <> 1 ",           #一級統治不要出來,BY蔡曉峰規定  #No.FUN-A40020
                 "   AND NOT (aag24 = 1 AND aag07 = '1') ", #No.FUN-A40020 
                 "   AND ",tm.wc1 CLIPPED
     PREPARE gglq702_aag01_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglq702_aag01_cs1 CURSOR FOR gglq702_aag01_p1
 
     #查找核算項
     LET l_sql1 = "SELECT UNIQUE ted02,ted09 FROM ted_file ", #TQC-930163
                  " WHERE ted00 = '",bookno,"'",
                  "   AND ted01 LIKE ? ",           #account
                  "   AND ted011 = '",tm.a,"'",
                  "   AND ",tm.wc2 CLIPPED
     #TQC-A80026--Add--Begin             
     IF NOT cl_null(tm.e) THEN
        LET l_sql1 = l_sql1 CLIPPED," AND ted09 = '",tm.e,"'"
     END IF
     #TQC-A80026--Add--End                  
     PREPARE gglq702_ted02_p11 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_ted02_cs11 CURSOR FOR gglq702_ted02_p11
 
     LET l_wc2 = tm.wc2
     LET l_wc2 = cl_replace_str(l_wc2,"ted02",g_field)
     LET l_wc2 = cl_replace_str(l_wc2,"ted09","abb24") #TQC-930163

     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN 
     #   LET l_sql1 = " SELECT ",g_field CLIPPED,",abb24 FROM aba_file,abb_file", #TQC-930163
     #             "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #             "    AND aba00 = '",bookno,"'",
     #             "    AND abb03 LIKE ? ",       #account
     #             "    AND ",g_field CLIPPED," IS NOT NULL",
     #             "    AND ",l_wc2
     #END IF 
     #FUN-C80102--add--end--
     #IF tm.m ='N' THEN    #FUN-C80102  add
     #   IF tm.f = '1' THEN   #FUN-C80102  add
     #      LET l_sql1 = " SELECT ",g_field CLIPPED,",abb24 FROM aba_file,abb_file", #TQC-930163
     #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                   "    AND aba00 = '",bookno,"'",
     #                   "    AND abb03 LIKE ? ",       #account
     #                   "    AND ",g_field CLIPPED," IS NOT NULL",
     #                   #"    AND aba19 = 'Y'   AND abapost = 'N'",   #FUN-C80102  mark
     #                   "    AND aba19 = 'Y'  ",      #FUN-C80102  add 
     #                   "    AND ",l_wc2
     ##FUN-C80102--add--str--
     #   ELSE
     #      LET l_sql1 = " SELECT ",g_field CLIPPED,",abb24 FROM aba_file,abb_file", 
     #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                   "    AND aba00 = '",bookno,"'",
     #                   "    AND abb03 LIKE ? ",      
     #                   "    AND ",g_field CLIPPED," IS NOT NULL",
     #                   "    AND aba19 = 'Y'   AND abapost = 'Y'",   
     #                   "    AND ",l_wc2
     #   END IF
     #END IF 
     #FUN-C80102--add--end--
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql1 = " SELECT ",g_field CLIPPED,",abb24 FROM aba_file,abb_file", #TQC-930163
                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                  "    AND aba00 = '",bookno,"'",
                  "    AND abb03 LIKE ? ",       #account
                  "    AND ",g_field CLIPPED," IS NOT NULL",
                  "    AND ",l_wc2

     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql1 = l_sql1,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql1 = l_sql1,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql1 = l_sql1," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql1 = l_sql1," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     #TQC-A80026--Add--Begin             
     IF NOT cl_null(tm.e) THEN
        LET l_sql1 = l_sql1 CLIPPED," AND abb24 = '",tm.e,"'"
     END IF
     #TQC-A80026--Add--End 
     LET l_sql1 = l_sql1 CLIPPED," ORDER BY aba02,aba01,abb02 "   #MOD-B50163
     PREPARE gglq702_ted02_p21 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_ted02_cs21 CURSOR FOR gglq702_ted02_p21
 
     #期初余額
     #1~mm-1
     LET l_sql = "SELECT SUM(ted05),SUM(ted06),SUM(ted10),SUM(ted11) FROM ted_file",
                 " WHERE ted00 = '",bookno,"'",
                 "   AND ted01 LIKE ? ",                  #科目
                 "   AND ted02 = ? ",                     #核算項
                 "   AND ted09 = ? ",  #TQC-930163
                 "   AND ted011 = '",tm.a,"'",
                 "   AND ted03 = ",yy,
                 "   AND ted04 < ",mm                     #期初
     PREPARE gglq702_qc1_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qc1_cs1 CURSOR FOR gglq702_qc1_p1
     #mm(1~bdate-1)
     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #               "    AND abb06 = ? ",
     #               "    AND abb24 = ? ",  
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 = ",mm,
     #               "    AND aba02 < '",bdate,"'"
     #END IF 
     #IF tm.m  = 'N' THEN 
     #   IF tm.f  = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #                  "    AND abb06 = ? ",
     #                  "    AND abb24 = ? ",  #TQC-930163
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND aba02 < '",bdate,"'",
     #                  "    AND aba19 = 'Y' "  #過帳
     #   ELSE
    #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #                  "    AND abb06 = ? ",
     #                  "    AND abb24 = ? ",  #TQC-930163
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND aba02 < '",bdate,"'",
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'"  #過帳 
     #   END IF   #FUN-C80102  add
     #END IF      #FUN-C80102  add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    "    AND aba00 = '",bookno,"'",
                    "    AND abb03 LIKE ?   ",               #科目
                    "    AND ",g_field CLIPPED," = ? ",      #核算項值
                    "    AND abb06 = ? ",
                    "    AND abb24 = ? ",  
                    "    AND aba03 = ",yy,
                    "    AND aba04 = ",mm,
                    "    AND aba02 < '",bdate,"'"

     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     PREPARE gglq702_qc2_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qc2_cs1 CURSOR FOR gglq702_qc2_p1
 
     #tm.c = 'Y'
     #1~mm-1
     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND aba00 = '",bookno,"'",
     #            "    AND abb03 LIKE ?   ",               #科目
     #            "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #            "    AND abb06 = ? ",
     #            "    AND abb24 = ? ",  
     #            "    AND aba03 = ",yy,
     #            "    AND aba04 < ",mm
     #END IF 
     #IF tm.m = 'N' THEN
     #   IF tm.f = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #               "    AND abb06 = ? ",
     #               "    AND abb24 = ? ",  
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 < ",mm,
     #               "    AND aba19 = 'Y' "  #期初未過帳
     #   ELSE
    #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #               "    AND abb06 = ? ",
     #               "    AND abb24 = ? ",  #TQC-930163
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 < ",mm,
     #               #"    AND aba19 = 'Y' AND abapost = 'N'"  #期初未過帳
     #               "    AND aba19 = 'Y' AND abapost = 'Y'" 
     #   END IF  #FUN-C80102  add
     #END IF     #FUN-C80102  add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND abb06 = ? ",
                 "    AND abb24 = ? ",  
                 "    AND aba03 = ",yy,
                 "    AND aba04 < ",mm

     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq702_qc3_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qc3_cs1 CURSOR FOR gglq702_qc3_p1
     #mm(1~bdate-1)
     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND aba00 = '",bookno,"'",
     #            "    AND abb03 LIKE ?   ",               #科目
     #            "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #            "    AND aba03 = ",yy,
     #            "    AND aba04 = ",mm,
     #            "    AND abb06 = ? ",
     #            "    AND abb24 = ? ",  
     #            "    AND aba02 < '",bdate,"'"
     #END IF 
     #IF tm.m = 'N' THEN 
     #   IF tm.f = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND abb06 = ? ",
     #                  "    AND abb24 = ? ",  #TQC-930163
     #                  "    AND aba02 < '",bdate,"'",
     #                  "    AND aba19 = 'Y' " 
     #   ELSE
    #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND abb06 = ? ",
     #                  "    AND abb24 = ? ",  #TQC-930163
     #                  "    AND aba02 < '",bdate,"'",
     #                  #"    AND aba19 = 'Y' AND abapost = 'N'"  #期初未過帳
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'" 
     #   END IF   #FUN-C80102  add
     #END IF      #FUN-C80102  add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND aba03 = ",yy,
                 "    AND aba04 = ",mm,
                 "    AND abb06 = ? ",
                 "    AND abb24 = ? ",  
                 "    AND aba02 < '",bdate,"'"

     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq702_qc4_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qc4_cs1 CURSOR FOR gglq702_qc4_p1
 
     #當期異動
     #IF tm.m = 'Y' THEN    #FUN-C80102  add   #FUN-C80102  mark
        LET l_sql = " SELECT '','','','',0,aba02,aba01,abb04,",
                    "        abb06,abb07,abb07f,abb24,abb25, ",
                    "        0,0,0,0,0,0,0,0,0,0             ",
                    "   FROM aba_file a,abb_file ",
                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    "    AND aba00 = '",bookno,"'",
                    "    AND abb03 LIKE ?   ",               #科目
                    "    AND ",g_field CLIPPED," = ? ",      #核算項值
                    "    AND aba03 = ",yy,
                    "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
                    #"    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))",  #CHI-C70031  #FUN-D40044  mark
                    "    AND aba04 = ? ",
                    "    AND abb24 = ? " #TQC-930163
                    #"    AND aba19 = 'Y' "      #FUN-C80102  mark
                    #" ORDER BY aba02,aba01,abb02 "   #FUN-C80102  add  #FUN-C80102 mark
     #END IF    #FUN-C80102  add   #FUN-C80102  mark

     #FUN-D40044--add--str--
     IF tm.i = 'N' THEN 
        LET l_sql = l_sql CLIPPED," AND NOT EXISTS (",
            " SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01 ",
            "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))"
     END IF
     #FUN-D40044--add--end--

     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.m = 'N' THEN 
     #   LET l_sql = " SELECT '','','','',0,aba02,aba01,abb04,",
     #               "        abb06,abb07,abb07f,abb24,abb25, ",
     #               "        0,0,0,0,0,0,0,0,0,0             ",
     #               "   FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #               "    AND aba03 = ",yy,
     #               "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
     #               "    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))",  #CHI-C70031
     #               "    AND aba04 = ? ",
     #               "    AND abb24 = ? ", 
     #               "    AND aba19 = 'Y' "     
     #FUN-C80102--add--end--
     #   #IF tm.c = 'N' THEN   #FUN-C80102  mark
     #   IF tm.f = '2' THEN    #FUN-C80102  add
     #      #LET l_sql = l_sql CLIPPED," AND abapost = 'Y' ORDER BY aba02"   #過帳  #FUN-A40011 #MOD-B50163 mark
     #      LET l_sql = l_sql CLIPPED," AND abapost = 'Y' ",     #過帳   #MOD-B50163       
     #                             " ORDER BY aba02,aba01,abb02 "     #MOD-B50163 
#FUN-A40011 --begin--
     #   ELSE
     #      LET l_sql = l_sql CLIPPED," ORDER BY aba02,aba01,abb02 "     #MOD-B50163 add aba01,abb02  
#FUN-A40011 --end--                   
     #   END IF
     #END IF   #FUN-C80102  add 
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 = 'N' or aba19 ='Y')",
                        " ORDER BY aba02,aba01,abb02 " 
        ELSE
           LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))",
                        " ORDER BY aba02,aba01,abb02 " 
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND  aba19 ='Y'", 
                        " ORDER BY aba02,aba01,abb02 " 
        ELSE
           LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'",
                        " ORDER BY aba02,aba01,abb02 " 
        END IF
     END IF
     #FUN-C80102--add--end--
 
     PREPARE gglq702_qj1_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qj1_cs1 CURSOR FOR gglq702_qj1_p1
 
END FUNCTION
 
FUNCTION gglq702_1()
   DEFINE l_name               LIKE type_file.chr20,
          l_sql,l_sql1          STRING,      #NO.FUN-910082
          l_date,l_date1       LIKE aba_file.aba02,
          l_i                  LIKE type_file.num5,
          qc_ted05             LIKE ted_file.ted05,
          qc_ted06             LIKE ted_file.ted06,
          qc_ted10             LIKE ted_file.ted10,
          qc_ted11             LIKE ted_file.ted11,
          qc1_ted05            LIKE ted_file.ted05,
          qc1_ted06            LIKE ted_file.ted06,
          qc1_ted10            LIKE ted_file.ted10,
          qc1_ted11            LIKE ted_file.ted11,
          qc2_ted05            LIKE ted_file.ted05,
          qc2_ted06            LIKE ted_file.ted06,
          qc2_ted10            LIKE ted_file.ted10,
          qc2_ted11            LIKE ted_file.ted11,
          qc3_ted05            LIKE ted_file.ted05,
          qc3_ted06            LIKE ted_file.ted06,
          qc3_ted10            LIKE ted_file.ted10,
          qc3_ted11            LIKE ted_file.ted11,
          qc4_ted05            LIKE ted_file.ted05,
          qc4_ted06            LIKE ted_file.ted06,
          qc4_ted10            LIKE ted_file.ted10,
          qc4_ted11            LIKE ted_file.ted11,
          l_qcye               LIKE abb_file.abb07,
          l_qcyef              LIKE abb_file.abb07,
          t_qcye               LIKE abb_file.abb07,
          t_qcyef              LIKE abb_file.abb07,
          l_ted02              LIKE ted_file.ted02,
          l_ted02_d            LIKE ze_file.ze03,
          l_ted09              LIKE ted_file.ted09, #TQC-930163
          l_aag01_str          LIKE type_file.chr50,
          t_bal,t_balf                 LIKE abb_file.abb07,
          t_debit,t_debitf             LIKE abb_file.abb07,
          t_credit,t_creditf           LIKE abb_file.abb07,
          l_d,l_df,l_c,l_cf            LIKE abb_file.abb07,
          n_bal,n_balf                 LIKE abb_file.abb07,
          l_abb25_c,l_abb25_d,l_abb25_bal LIKE abb_file.abb25,
          t_date2                      LIKE type_file.dat,
          t_date1                      LIKE type_file.dat,
          l_flag1                      LIKE type_file.chr1, #TQC-930163 
          l_flag2                      LIKE type_file.chr1, #TQC-930163
          l_flag4                      LIKE type_file.chr1, #TQC-970310 
          l_dc                         LIKE type_file.chr10,
          l_year                       LIKE type_file.num10,
          l_month                      LIKE type_file.num10,
          sr1                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02
                               END RECORD,
          sr2                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               ted02    LIKE ted_file.ted02,
                               ted02_d  LIKE ze_file.ze03,
                               ted09    LIKE ted_file.ted09 #TQC-930163
                               END RECORD,
          sr                   RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               ted02    LIKE ted_file.ted02,
                               ted02_d  LIKE ze_file.ze03,
                               aba04    LIKE aba_file.aba04,
                               aba02    LIKE aba_file.aba02,
                               aba01    LIKE aba_file.aba01,
                               abb04    LIKE abb_file.abb04,
                               abb06    LIKE abb_file.abb06,
                               abb07    LIKE abb_file.abb07,
                               abb07f   LIKE abb_file.abb07f,
                               abb24    LIKE abb_file.abb24,
                               abb25    LIKE abb_file.abb25,
                               qcye     LIKE abb_file.abb07,
                               qcyef    LIKE abb_file.abb07,
                               qc_md    LIKE abb_file.abb07,
                               qc_mdf   LIKE abb_file.abb07,
                               qc_mc    LIKE abb_file.abb07,
                               qc_mcf   LIKE abb_file.abb07,
                               qc_yd    LIKE abb_file.abb07,
                               qc_ydf   LIKE abb_file.abb07,
                               qc_yc    LIKE abb_file.abb07,
                               qc_ycf   LIKE abb_file.abb07
                               END RECORD
DEFINE   l_chr                 LIKE type_file.chr1   #FUN-A40011

 
     CALL gglq702_table()
     LET l_flag1 = 'N'                         #TQC-970049
     LET l_flag2 = 'N'                         #TQC-970049   
 
     #IF tm.d='N' THEN   #FUN-C80102  mark
     IF tm.g ='N' THEN   #FUN-C80102  add
        CALL gglq702_curs()
     ELSE
        CALL gglq702_curs1()
     END IF
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
     FOREACH gglq702_aag01_cs1 INTO sr1.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach gglq702_aag01_cs1',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr1.aag01 CLIPPED,'\%'    #No.MOD-940388
        FOREACH gglq702_ted02_cs11 USING l_aag01_str
                                  INTO l_ted02,l_ted09  #TQC-930163
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq702_ted02_cs11',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #get dimension description
#          CALL gglq702_get_ahe02(l_aag01_str,l_ted02,g_gaq01) #TQC-930163
           CALL gglq702_get_ahe02(sr1.aag01,l_ted02,g_gaq01) #TQC-930163  #No.TQC-C50211
                RETURNING l_ted02_d
           INSERT INTO gglq702_ted_tmp VALUES(sr1.aag01,sr1.aag02,l_ted02,l_ted02_d,l_ted09) #TQC-930163
#          IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN #CHI-C30115 mark
           IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
              CALL cl_err3('ins','gglq702_ted_tmp',sr1.aag01,l_ted02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
 
        FOREACH gglq702_ted02_cs21 USING l_aag01_str
                                  INTO l_ted02,l_ted09 #TQC-930163
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq702_ted02_cs21',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #get dimension description
#          CALL gglq702_get_ahe02(l_aag01_str,l_ted02,g_gaq01) #TQC-930163
           CALL gglq702_get_ahe02(sr1.aag01,l_ted02,g_gaq01) #TQC-930163  #No.TQC-C50211
                RETURNING l_ted02_d
           INSERT INTO gglq702_ted_tmp VALUES(sr1.aag01,sr1.aag02,l_ted02,l_ted02_d,l_ted09) #TQC-930163
#          IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN #CHI-C30115 mark
           IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
              CALL cl_err3('ins','gglq702_ted_tmp',sr1.aag01,l_ted02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
     END FOREACH
 
     LET g_prog = 'gglr301'
     LET g_pageno = 0
     LET l_cnt = 0  #No:181217 add 
 
     DECLARE gglq702_cs11 CURSOR FOR
      SELECT UNIQUE aag01,aag02,ted02,ted02_d,ted09 FROM gglq702_ted_tmp
       ORDER BY aag01,ted02
 
     FOREACH gglq702_cs11 INTO sr2.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach gglq702_cs11',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr2.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr2.aag01 CLIPPED,'\%'    #No.MOD-940388
 
        #期初
        LET qc1_ted05 = 0  LET qc1_ted06 = 0
        LET qc1_ted10 = 0  LET qc1_ted11 = 0
        LET qc2_ted05 = 0  LET qc2_ted06 = 0
        LET qc2_ted10 = 0  LET qc2_ted11 = 0
        LET qc3_ted05 = 0  LET qc3_ted06 = 0
        LET qc3_ted10 = 0  LET qc3_ted11 = 0
        LET qc4_ted05 = 0  LET qc4_ted06 = 0
        LET qc4_ted10 = 0  LET qc4_ted11 = 0
        #1~mm-1
        OPEN gglq702_qc1_cs1 USING l_aag01_str,sr2.ted02,sr2.ted09 #TQC-930163
        FETCH gglq702_qc1_cs1 INTO qc1_ted05,qc1_ted06,qc1_ted10,qc1_ted11
        CLOSE gglq702_qc1_cs1
        IF cl_null(qc1_ted05) THEN LET qc1_ted05 = 0 END IF
        IF cl_null(qc1_ted06) THEN LET qc1_ted06 = 0 END IF
        IF cl_null(qc1_ted10) THEN LET qc1_ted10 = 0 END IF
        IF cl_null(qc1_ted11) THEN LET qc1_ted11 = 0 END IF
        #mm(day 1~<bdate)
        OPEN gglq702_qc2_cs1 USING l_aag01_str,sr2.ted02,'1',sr2.ted09 #TQC-930163
        FETCH gglq702_qc2_cs1 INTO qc2_ted05,qc2_ted10
        CLOSE gglq702_qc2_cs1
        OPEN gglq702_qc2_cs1 USING l_aag01_str,sr2.ted02,'2',sr2.ted09 #TQC-930163
        FETCH gglq702_qc2_cs1 INTO qc2_ted06,qc2_ted11
        CLOSE gglq702_qc2_cs1
        IF cl_null(qc2_ted05) THEN LET qc2_ted05 = 0 END IF
        IF cl_null(qc2_ted06) THEN LET qc2_ted06 = 0 END IF
        IF cl_null(qc2_ted10) THEN LET qc2_ted10 = 0 END IF
        IF cl_null(qc2_ted11) THEN LET qc2_ted11 = 0 END IF
 
        #IF tm.c = 'Y' THEN   #FUN-C80102  mark
           #1~mm-1
           OPEN gglq702_qc3_cs1 USING l_aag01_str,sr2.ted02,'1',sr2.ted09 #TQC-930163
           FETCH gglq702_qc3_cs1 INTO qc3_ted05,qc3_ted10
           CLOSE gglq702_qc3_cs1
           OPEN gglq702_qc3_cs1 USING l_aag01_str,sr2.ted02,'2',sr2.ted09 #TQC-930163
           FETCH gglq702_qc3_cs1 INTO qc3_ted06,qc3_ted11
           CLOSE gglq702_qc3_cs1
           IF cl_null(qc3_ted05) THEN LET qc3_ted05 = 0 END IF
           IF cl_null(qc3_ted06) THEN LET qc3_ted06 = 0 END IF
           IF cl_null(qc3_ted10) THEN LET qc3_ted10 = 0 END IF
           IF cl_null(qc3_ted11) THEN LET qc3_ted11 = 0 END IF
           #mm(1~bdate-1)
           OPEN gglq702_qc4_cs1 USING l_aag01_str,sr2.ted02,'1',sr2.ted09 #TQC-930163
           FETCH gglq702_qc4_cs1 INTO qc4_ted05,qc4_ted10
           CLOSE gglq702_qc4_cs1
           OPEN gglq702_qc4_cs1 USING l_aag01_str,sr2.ted02,'2',sr2.ted09 #TQC-930163
           FETCH gglq702_qc4_cs1 INTO qc4_ted06,qc4_ted11
           CLOSE gglq702_qc4_cs1
           IF cl_null(qc4_ted05) THEN LET qc4_ted05 = 0 END IF
           IF cl_null(qc4_ted06) THEN LET qc4_ted06 = 0 END IF
           IF cl_null(qc4_ted10) THEN LET qc4_ted10 = 0 END IF
           IF cl_null(qc4_ted11) THEN LET qc4_ted11 = 0 END IF
        #END IF   #FUN-C80102  mark
        LET qc_ted05 = qc1_ted05 + qc2_ted05 + qc3_ted05 + qc4_ted05
        LET qc_ted06 = qc1_ted06 + qc2_ted06 + qc3_ted06 + qc4_ted06
        LET qc_ted10 = qc1_ted10 + qc2_ted10 + qc3_ted10 + qc4_ted10
        LET qc_ted11 = qc1_ted11 + qc2_ted11 + qc3_ted11 + qc4_ted11
 
        LET l_qcye  = qc_ted05 - qc_ted06
        LET l_qcyef = qc_ted10 - qc_ted11
        #若t_qcye = 0 & 異間異動為零，則不打印
        LET t_qcye  = l_qcye
        LET t_qcyef = l_qcyef
        LET l_flag4 = 'N'                          #TQC-970310

        LET l_chr   = 'Y'   #FUN-A40011     
        FOR l_i = mm1 TO nn1
            LET l_flag='N'
            FOREACH gglq702_qj1_cs1 USING l_aag01_str,sr2.ted02,l_i,sr2.ted09 #TQC-930163
                                    INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET l_flag='Y'
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.ted02   = sr2.ted02
               LET sr.ted02_d = sr2.ted02_d
               LET sr.aba04   = l_i
               LET sr.qcye    = l_qcye
               LET sr.qcyef   = l_qcyef
 
               LET sr.qc_md   = qc2_ted05 + qc4_ted05
               LET sr.qc_mdf  = qc2_ted10 + qc4_ted10
               LET sr.qc_mc   = qc2_ted06 + qc4_ted06
               LET sr.qc_mcf  = qc2_ted11 + qc4_ted11
 
               LET sr.qc_yd   = qc1_ted05 + qc3_ted05
               LET sr.qc_ydf  = qc1_ted10 + qc3_ted10
               LET sr.qc_yc   = qc1_ted06 + qc3_ted06
               LET sr.qc_ycf  = qc1_ted11 + qc3_ted11
 
               IF sr.abb06 = '1' THEN
                  LET t_qcye  = t_qcye + sr.abb07
                  LET t_qcyef = t_qcyef+ sr.abb07
               ELSE
                  LET t_qcye  = t_qcye - sr.abb07
                  LET t_qcyef = t_qcyef- sr.abb07
               END IF
 
               
      IF l_flag1 = 'N' THEN
        IF l_flag4 = 'N' THEN                                     #TQC-970310 add 
          LET t_bal     = sr.qcye
          LET t_balf    = sr.qcyef
#No.TQC-B60041 --begin
          LET t_debit   = sr.qc_md
          LET t_debitf  = sr.qc_mdf
          LET t_credit  = sr.qc_mc
          LET t_creditf = sr.qc_mcf 
#         LET t_debit   = sr.qc_yd  + sr.qc_md
#         LET t_debitf  = sr.qc_ydf + sr.qc_mdf
#         LET t_credit  = sr.qc_yc  + sr.qc_mc
#         LET t_creditf = sr.qc_ycf + sr.qc_mcf 
#No.TQC-B60041 --end
          LET l_flag4 = 'Y'                                       #TQC-970310 add
        END IF                                                    #TQC-970310 add                 
         #IF sr.aba04 = MONTH(bdate) THEN   #FUN-C80102  mark
         IF sr.aba04 = s_get_aznn(g_plant,g_aza.aza81,bdate,3) THEN   #FUN-C80102  add
            LET t_date2 = bdate
         ELSE
            LET t_date2 = MDY(sr.aba04,1,yy)
         END IF
 
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
 
         CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
         LET l_abb25_bal = n_bal / n_balf 
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         
         IF l_chr = 'Y' THEN   #FUN-A40011          
            INSERT INTO gglq702_tmp
            VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'1', 
                   t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
                 #  l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)          #No:181217 mark
                   l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'1') #No:181217 add
         END IF    #FUN-A40011                  
         LET l_flag1 = 'Y'
         LET l_flag2 = 'N'
         LET l_chr = 'N'   #FUN-A40011         
      END IF   
      
      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
         IF cl_null(sr.abb07)  THEN LET sr.abb07  = 0 END IF
         IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
         IF sr.abb06 = 1 THEN
            LET t_bal   = t_bal   + sr.abb07
            LET t_balf  = t_balf  + sr.abb07f
            LET t_debit = t_debit + sr.abb07
            LET t_debitf= t_debitf+ sr.abb07f
         ELSE
            LET t_bal    = t_bal    - sr.abb07
            LET t_balf   = t_balf   - sr.abb07f
            LET t_credit = t_credit + sr.abb07
            LET t_creditf= t_creditf+ sr.abb07f
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
         IF sr.abb06 = '1' THEN
            LET l_d  = sr.abb07
            LET l_df = sr.abb07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.abb07
            LET l_cf = sr.abb07f
         END IF
 
 
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)          #No:181217 mark
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'2') #No:181217 add
      END IF
      LET l_cnt=l_cnt+1   #No:181217 add
            END FOREACH
            IF l_flag = "N" THEN
               IF t_qcye = 0 AND t_qcyef = 0 
                  AND qc_ted05 = 0 AND qc_ted06 = 0 THEN
                  CONTINUE FOR
               END IF
               INITIALIZE sr.* TO NULL
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.ted02   = sr2.ted02
               LET sr.ted02_d = sr2.ted02_d
               LET sr.aba04   = l_i
               LET sr.qcye    = l_qcye
               LET sr.qcyef   = l_qcyef
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET sr.aba02   = l_date1
               LET sr.aba01   = NULL
               LET sr.abb04   = NULL
               LET sr.abb06   = NULL
               LET sr.abb07   = 0
               LET sr.abb07f  = 0
               LET sr.abb24   = sr2.ted09   
               LET sr.abb25   = 0
 
               LET sr.qc_md   = qc2_ted05 + qc4_ted05
               LET sr.qc_mdf  = qc2_ted10 + qc4_ted10
               LET sr.qc_mc   = qc2_ted06 + qc4_ted06
               LET sr.qc_mcf  = qc2_ted11 + qc4_ted11
 
               LET sr.qc_yd   = qc1_ted05 + qc3_ted05
               LET sr.qc_ydf  = qc1_ted10 + qc3_ted10
               LET sr.qc_yc   = qc1_ted06 + qc3_ted06
               LET sr.qc_ycf  = qc1_ted11 + qc3_ted11 
               
      IF l_flag1 = 'N' THEN
        IF l_flag4 = 'N' THEN                                     #TQC-970310 add 
          LET t_bal     = sr.qcye
          LET t_balf    = sr.qcyef
#No.TQC-B60041 --begin
          LET t_debit   = sr.qc_md
          LET t_debitf  = sr.qc_mdf
          LET t_credit  = sr.qc_mc
          LET t_creditf = sr.qc_mcf 
#         LET t_debit   = sr.qc_yd  + sr.qc_md
#         LET t_debitf  = sr.qc_ydf + sr.qc_mdf
#         LET t_credit  = sr.qc_yc  + sr.qc_mc
#         LET t_creditf = sr.qc_ycf + sr.qc_mcf 
#No.TQC-B60041 --end
          LET l_flag4 = 'Y'                                       #TQC-970310 add
        END IF                                                    #TQC-970310 add          
         #IF sr.aba04 = MONTH(bdate) THEN      #FUN-C80102  mark
         IF sr.aba04 = s_get_aznn(g_plant,g_aza.aza81,bdate,3) THEN   #FUN-C80102  add
            LET t_date2 = bdate
         ELSE
            LET t_date2 = MDY(sr.aba04,1,yy)
         END IF
 
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
 
         CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
         LET l_abb25_bal = n_bal / n_balf 
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF l_chr ='Y' THEN  #FUN-A40011          
            INSERT INTO gglq702_tmp
            VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'1', 
                  t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
                  #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)           #No:181217 mark
                   l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'3') #No:181217 add
         END IF    #FUN-A40011                      
         LET l_flag1 = 'Y'
         LET l_flag2 = 'N'
         LET l_chr = 'N'      #FUN-A40011          
      END IF   
      
      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
         IF cl_null(sr.abb07)  THEN LET sr.abb07  = 0 END IF
         IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
         IF sr.abb06 = 1 THEN
            LET t_bal   = t_bal   + sr.abb07
            LET t_balf  = t_balf  + sr.abb07f
            LET t_debit = t_debit + sr.abb07
            LET t_debitf= t_debitf+ sr.abb07f
         ELSE
            LET t_bal    = t_bal    - sr.abb07
            LET t_balf   = t_balf   - sr.abb07f
            LET t_credit = t_credit + sr.abb07
            LET t_creditf= t_creditf+ sr.abb07f
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
         IF sr.abb06 = '1' THEN
            LET l_d  = sr.abb07
            LET l_df = sr.abb07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.abb07
            LET l_cf = sr.abb07f
         END IF
 
 
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
               # l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)          #No:181217 mark
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'3') #No:181217 add
      END IF
            END IF
 
      IF l_flag2 = 'N' THEN
         CALL s_yp(edate) RETURNING l_year,l_month
         IF sr.aba04 = l_month THEN
            LET t_date2  = edate
         ELSE
            CALL s_azn01(yy,sr.aba04) RETURNING t_date1,t_date2
         END IF
   
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
   
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
 
         SELECT SUM(abb07) INTO l_d 
           FROM  gglq702_tmp
          WHERE abb06 = '1'   AND abb07 IS NOT NULL                     #TQC-970310
            AND ted02 = sr.ted02 AND aba04 = sr.aba04
            AND abb24 = sr.abb24
            AND aag01 = sr.aag01                                    #FUN-A40011            
         SELECT SUM(abb07f) INTO l_df 
           FROM  gglq702_tmp
          WHERE abb06 = '1'   AND abb07 IS NOT NULL                     #TQC-970310          
            AND ted02 = sr.ted02 AND aba04 = sr.aba04
            AND abb24 = sr.abb24
            AND aag01 = sr.aag01                                    #FUN-A40011            
         SELECT SUM(abb07) INTO l_c 
           FROM  gglq702_tmp
          WHERE abb06 = '2'   AND abb07 IS NOT NULL                     #TQC-970310          
            AND ted02 = sr.ted02 AND aba04 = sr.aba04
            AND abb24 = sr.abb24            
            AND aag01 = sr.aag01                                    #FUN-A40011            
         SELECT SUM(abb07f) INTO l_cf 
           FROM  gglq702_tmp
          WHERE abb06 = '2'   AND abb07 IS NOT NULL                     #TQC-970310          
            AND ted02 = sr.ted02 AND aba04 = sr.aba04
            AND abb24 = sr.abb24            
            AND aag01 = sr.aag01                                    #FUN-A40011            
   
         IF cl_null(l_d)  THEN LET l_d  = 0 END IF
         IF cl_null(l_df) THEN LET l_df = 0 END IF
         IF cl_null(l_c)  THEN LET l_c  = 0 END IF
         IF cl_null(l_cf) THEN LET l_cf = 0 END IF
         IF sr.aba04 = mm1 THEN
            LET l_d  = l_d  + sr.qc_md
            LET l_df = l_df + sr.qc_mdf
            LET l_c  = l_c  + sr.qc_mc
            LET l_cf = l_cf + sr.qc_mcf
         END IF
         CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d)   THEN LET l_abb25_d   = 0 END IF
         IF cl_null(l_abb25_c)   THEN LET l_abb25_c   = 0 END IF
         INSERT INTO gglq702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'3',
                t_date2,'',g_msg,sr.abb24,'',0,0,
                l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
                #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)          #No:181217 mark
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'4') #No:181217 add
   
   
         CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
         LET l_abb25_d = t_debit / t_debitf
         LET l_abb25_c = t_credit / t_creditf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'4', 
                t_date2,'',g_msg,sr.abb24,'',0,0,
                t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
                #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)            #No:181217 mark
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'4')   #No:181217 add
      END IF 
      LET l_flag1 = 'N'      
         
        END FOR
        LET l_cnt=l_cnt+1 #No:181217 add 
     END FOREACH
 
 
END FUNCTION
 
FUNCTION gglq702_cs()
     #IF tm.d = 'N' THEN   #FUN-C80102  mark
     IF tm.g = 'N' THEN    #FUN-C80102  add
#        LET g_sql = "SELECT UNIQUE aag01,aag02,ted02,ted02_d,'',aba04", #TQC-930163   #FUN-A40011 mark
         LET g_sql = "SELECT UNIQUE aag01,aag02,ted02,ted02_d,''",                     #FUN-A40011 
                    "  FROM gglq702_tmp ",
#                    " ORDER BY aag01,ted02,aba04 " #TQC-930163  #FUN-A40011 mark
                     " ORDER BY aag01,ted02 "                    #FUN-A40011 
     ELSE
#        LET g_sql = "SELECT UNIQUE aag01,aag02,ted02,ted02_d,abb24,aba04", #TQC-930163 #FUN-A40011 mark
         LET g_sql = "SELECT UNIQUE aag01,aag02,ted02,ted02_d,abb24",                   #FUN-A40011 
                    "  FROM gglq702_tmp ",
#                    " ORDER BY aag01,ted02,abb24,aba04 " #TQC-930163   #FUN-A40011 mark
                     " ORDER BY aag01,ted02,abb24 "                     #FUN-A40011 
     END IF
     PREPARE gglq702_ps FROM g_sql
     DECLARE gglq702_curs SCROLL CURSOR WITH HOLD FOR gglq702_ps
 
     #IF tm.d = 'N' THEN   #FUN-C80102  mark
     IF tm.g = 'N' THEN    #FUN-C80102  add
#        LET g_sql = "SELECT UNIQUE aag01,aag02,ted02,ted02_d,aba04", #TQC-930163   #FUN-A40011 mark
         LET g_sql = "SELECT UNIQUE aag01,aag02,ted02,ted02_d",                     #FUN-A40011 
                    "  FROM gglq702_tmp ",
                    "  INTO TEMP x "
     ELSE
#        LET g_sql = "SELECT UNIQUE aag01,aag02,ted02,ted02_d,abb24,aba04", #TQC-930163  #FUN-A40011 mark
         LET g_sql = "SELECT UNIQUE aag01,aag02,ted02,ted02_d,abb24",                    #FUN-A40011 
                    "  FROM gglq702_tmp ",
                    "  INTO TEMP x "
     END IF
     DROP TABLE x
     PREPARE gglq702_ps1 FROM g_sql
     EXECUTE gglq702_ps1
 
     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq702_ps2 FROM g_sql
     DECLARE gglq702_cnt CURSOR FOR gglq702_ps2
 
     OPEN gglq702_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq702_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq702_cnt
        FETCH gglq702_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq702_fetch('F')
     END IF
END FUNCTION
 
FUNCTION gglq702_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq702_curs INTO g_aag01,g_aag02,g_ted02,g_ted02_d,g_ted09 # ,g_aba04  #TQC-930163 #FUN-A40011 mark g_aba04
      WHEN 'P' FETCH PREVIOUS gglq702_curs INTO g_aag01,g_aag02,g_ted02,g_ted02_d,g_ted09 #,g_aba04  #TQC-930163  #FUN-A40011 mark g_aba04
      WHEN 'F' FETCH FIRST    gglq702_curs INTO g_aag01,g_aag02,g_ted02,g_ted02_d,g_ted09 #,g_aba04  #TQC-930163  #FUN-A40011 mark g_aba04
      WHEN 'L' FETCH LAST     gglq702_curs INTO g_aag01,g_aag02,g_ted02,g_ted02_d,g_ted09 #,g_aba04  #TQC-930163  #FUN-A40011 mark g_aba04 
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
         FETCH ABSOLUTE g_jump gglq702_curs INTO g_aag01,g_aag02,g_ted02,g_ted02_d,g_ted09 #,g_aba04 #TQC-930163  #FUN-A40011 mark g_aba04
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aag01,SQLCA.sqlcode,0)
      INITIALIZE g_aag01 TO NULL
      INITIALIZE g_aag02 TO NULL
      INITIALIZE g_ted02 TO NULL
      INITIALIZE g_ted02_d TO NULL
      INITIALIZE g_ted09 TO NULL #TQC-930163
#      INITIALIZE g_aba04 TO NULL  #FUN-A40011 mark 
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
 
   CALL gglq702_show()
END FUNCTION
 
FUNCTION gglq702_show()

   #FUN-C80102--mark--str---
   #DISPLAY g_aag01 TO aag01
   #DISPLAY g_aag02 TO aag02
   #DISPLAY g_ted02 TO ted02
   #DISPLAY g_ted02_d TO ted02_d
   #FUN-C80102--mark--end---
   DISPLAY g_ted09 TO ted09  #TQC-930163
   DISPLAY yy TO yy
#  DISPLAY g_aba04 TO mm   #FUN-A40011 mark
   DISPLAY tm.a TO a

   #FUN-C80102--add--str---
   DISPLAY bookno TO bookno
   DISPLAY bdate TO bdate
   DISPLAY edate TO edate
   DISPLAY tm.f TO f
   DISPLAY tm.m TO m
   DISPLAY tm.b TO b
   DISPLAY tm.e TO e
   DISPLAY tm.g TO g
   #FUN-C80102--add--end---
   DISPLAY tm.i    TO i   #FUN-D40044 add
 
   CALL gglq702_b_fill()
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION gglq702_b_fill()
  DEFINE  l_abb06    LIKE abb_file.abb06
  DEFINE  l_type     LIKE type_file.chr1
 
   LET g_sql = "SELECT aag01,aag02,ted02,ted02_d,aba02,aba01,abb04,abb24,df,abb25_d,d,",    #FUN-C80102  add  aag01,aag02,ted02,ted02_d
               "       cf,abb25_c,c,dc,balf,abb25_bal,bal,",
               "       azi04,azi05,azi07,abb06,type ",
               "  FROM gglq702_tmp",
               " WHERE aag01 ='",g_aag01,"'",
               "   AND ted02 ='",g_ted02,"'"   #,  #FUN-A40011   mark
#               "   AND aba04 = ",g_aba04          #FUN-A40011   mark
   #IF tm.d = 'Y' THEN    #FUN-C80102  mark
   IF tm.g = 'Y' THEN     #FUN-C80102  add
      LET g_sql = g_sql CLIPPED,
                  "   AND (abb24 ='",g_ted09,"' OR abb24 IS NULL)"  ,
                 #" ORDER BY aba02,type,aba01 "  #MOD-B50163 mark
                  #" ORDER BY aba02,aba01 "       #CHI-D60013 mark  #MOD-B50163
                  " ORDER BY aba02,odr,odr1 "   #CHI-D60013  #No:181217 add 
   ELSE
      LET g_sql = g_sql CLIPPED,'',
                 #" ORDER BY aba02,type,aba01 "  #MOD-B50163 mark
                  #" ORDER BY aba02,aba01 "       #CHI-D60013 mark  #MOD-B50163
                  " ORDER BY aba02,odr,odr1 "   #CHI-D60013  #No:181217 add 
   END IF
 
   PREPARE gglq702_pb FROM g_sql
   DECLARE abb_curs  CURSOR FOR gglq702_pb
 
   CALL g_abb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH abb_curs INTO g_abb[g_cnt].*,t_azi04,t_azi05,t_azi07,l_abb06,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_abb[g_cnt].d   = cl_numfor(g_abb[g_cnt].d,20,g_azi04)
      LET g_abb[g_cnt].c   = cl_numfor(g_abb[g_cnt].c,20,g_azi04)
      LET g_abb[g_cnt].bal = cl_numfor(g_abb[g_cnt].bal,20,g_azi04)
      LET g_abb[g_cnt].df  = cl_numfor(g_abb[g_cnt].df,20,t_azi04)
      LET g_abb[g_cnt].cf  = cl_numfor(g_abb[g_cnt].cf,20,t_azi04)
      LET g_abb[g_cnt].balf= cl_numfor(g_abb[g_cnt].balf,20,t_azi04)
      LET g_abb[g_cnt].abb25_d= cl_numfor(g_abb[g_cnt].abb25_d,20,t_azi07)
      LET g_abb[g_cnt].abb25_c= cl_numfor(g_abb[g_cnt].abb25_c,20,t_azi07)
      LET g_abb[g_cnt].abb25_bal= cl_numfor(g_abb[g_cnt].abb25_bal,20,t_azi07)
 
      IF l_type = '1' THEN
         LET g_abb[g_cnt].d = NULL
         LET g_abb[g_cnt].df= NULL
         LET g_abb[g_cnt].abb25_d= NULL
         LET g_abb[g_cnt].c = NULL
         LET g_abb[g_cnt].cf = NULL
         LET g_abb[g_cnt].abb25_c= NULL
         LET g_abb[g_cnt].abb25_bal = NULL
         #IF tm.d = 'N' THEN  #TQC-930163    #FUN-C80102  mark
         IF tm.g = 'N' THEN    #FUN-C80102  add
            LET g_abb[g_cnt].balf= NULL
         END IF
      END IF
      IF l_type = '3' OR l_type = '4' THEN
         LET g_abb[g_cnt].abb25_d= NULL
         LET g_abb[g_cnt].abb25_c= NULL
         LET g_abb[g_cnt].abb25_bal = NULL
         #IF tm.d = 'N' THEN    #FUN-C80102  mark
         IF tm.g = 'N' THEN     #FUN-C80102  add
            LET g_abb[g_cnt].df = NULL
            LET g_abb[g_cnt].cf = NULL
            LET g_abb[g_cnt].balf = NULL
         END IF
      END IF
      IF l_type = '2' THEN
         #IF tm.d = 'N' THEN  #TQC-930163   #FUN-C80102  mark
         IF tm.g = 'N' THEN    #FUN-C80102  add
            LET g_abb[g_cnt].balf= NULL 
            LET g_abb[g_cnt].abb25_bal = NULL
         END IF
      END IF
      IF l_abb06 = '1' THEN
         LET g_abb[g_cnt].c = NULL
         LET g_abb[g_cnt].cf = NULL
         LET g_abb[g_cnt].abb25_c= NULL
      END IF
      IF l_abb06 = '2' THEN
         LET g_abb[g_cnt].d = NULL
         LET g_abb[g_cnt].df= NULL
         LET g_abb[g_cnt].abb25_d= NULL
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_abb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
FUNCTION q702_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abb TO s_abb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#No.FUN-A40009 --begin
         IF g_rec_b != 0 AND l_ac != 0 THEN  
            CALL fgl_set_arr_curr(l_ac)     
         END IF                            
#No.FUN-A40009 --end
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION drill_down
         LET g_action_choice="drill_down"
         EXIT DISPLAY
 
      ON ACTION first
         CALL gglq702_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL gglq702_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL gglq702_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL gglq702_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL gglq702_fetch('L')
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
 
FUNCTION q702_out_1()
 
   LET g_prog = 'gglq702'
   LET g_sql = " aag01.aag_file.aag01,",
               " aag02.aag_file.aag02,",
               " ted02.ted_file.ted02,",
               " ted02_d.ze_file.ze03,",
               " aba04.aba_file.aba04,",
               " type.type_file.chr1,",
               " aba02.aba_file.aba02,",
               " aba01.aba_file.aba01,",
               " abb04.abb_file.abb04,",
               " abb24.abb_file.abb24,",
               " abb06.abb_file.abb06,",
               " abb07.abb_file.abb07,",
               " abb07f.abb_file.abb07f,",
               " d.abb_file.abb07,",
               " df.abb_file.abb07,",
               " abb25_d.abb_file.abb25,",
               " c.abb_file.abb07,",
               " cf.abb_file.abb07,",
               " abb25_c.abb_file.abb25,",
               " dc.type_file.chr10,",
               " bal.abb_file.abb07,",
               " balf.abb_file.abb07,",
               " abb25_bal.abb_file.abb25,",
               " pagenum.type_file.num5,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " azi07.azi_file.azi07 "
 
   LET l_table = cl_prt_temptable('gglq702',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?)          "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION q702_out_2()
   DEFINE l_name             LIKE type_file.chr20
   DEFINE l_aag01            LIKE aag_file.aag01
   DEFINE l_ted02            LIKE ted_file.ted02
 
   LET g_prog = 'gglq702'
 
   CALL cl_del_data(l_table)
 
   LET l_aag01 = NULL
   LET l_ted02 = NULL
   #IF tm.d <> 'Y' THEN  #No.TQC-930163     #FUN-C80102  mark
   IF tm.g <> 'Y' THEN   #FUN-C80102  add
      DECLARE gglq702_tmp_curs CURSOR FOR
       SELECT * FROM gglq702_tmp
        ORDER BY aag01,ted02,aba04,aba02,aba01
      FOREACH gglq702_tmp_curs INTO g_pr.*
         #查詢和打印時不太一樣，打印時,僅打印一個期初余額
         IF l_aag01 <> g_pr.aag01 OR l_ted02 <> g_pr.ted02 THEN
            LET l_aag01 = NULL
            LET l_ted02 = NULL
         END IF
         IF g_pr.type = '1' THEN
            IF l_aag01 IS NULL AND l_ted02 IS NULL THEN
               LET l_aag01 = g_pr.aag01
               LET l_ted02 = g_pr.ted02
            ELSE
               CONTINUE FOREACH
            END IF
         END IF
         EXECUTE insert_prep USING g_pr.*
      END FOREACH
   ELSE 
      DECLARE gglq702_tmp_curs1 CURSOR FOR
        SELECT * FROM gglq702_tmp
          ORDER BY aag01,ted02,abb24,aba04,aba02,aba01
      FOREACH gglq702_tmp_curs1 INTO g_pr.*
         EXECUTE insert_prep USING g_pr.*
      END FOREACH
   END IF #No.TQC-930163
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
 
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'aag01')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",yy,";",g_azi04,";",tm.a
 
   IF tm.b = 'N' THEN
       LET l_name = 'gglq702'
   ELSE
       #IF tm.d = 'N' THEN #No.TQC-930163   #FUN-C80102  mark
       IF tm.g = 'N' THEN    #FUN-C80102  add
          LET l_name = 'gglq702_1'
       END IF             #No.TQC-930163
       #IF tm.d = 'Y' THEN     #FUN-C80102  mark
       IF tm.g = 'Y' THEN      #FUN-C80102  add
          LET l_name = 'gglq702_2'
       END IF 
   END IF
   CALL cl_prt_cs3('gglq702',l_name,g_sql,g_str)
 
END FUNCTION
 
FUNCTION gglq702_table()
     DROP TABLE gglq702_ted_tmp;
     CREATE TEMP TABLE gglq702_ted_tmp(
                    aag01       LIKE aag_file.aag01,
                    aag02       LIKE type_file.chr1000,      #No.MOD-940388
                    ted02       LIKE ted_file.ted02,
                    ted02_d     LIKE ze_file.ze03,
                    ted09       LIKE ted_file.ted09); #TQC-930163
 
     DROP TABLE gglq702_tmp;
     CREATE TEMP TABLE gglq702_tmp(
                    aag01       LIKE aag_file.aag01,
                    aag02       LIKE type_file.chr1000,      #No.MOD-940388
                    ted02       LIKE ted_file.ted02,
                    ted02_d     LIKE ze_file.ze03,  
                    aba04       LIKE aba_file.aba04,
                    type        LIKE type_file.chr1,
                    aba02       LIKE aba_file.aba02,
                    aba01       LIKE aba_file.aba01,
                    abb04       LIKE abb_file.abb04,
                    abb24       LIKE abb_file.abb24,
                    abb06       LIKE abb_file.abb06,
                    abb07       LIKE abb_file.abb07,
                    abb07f      LIKE abb_file.abb07f,
                    d           LIKE abb_file.abb07,
                    df          LIKE abb_file.abb07,
                    abb25_d     LIKE abb_file.abb25,
                    c           LIKE abb_file.abb07,
                    cf          LIKE abb_file.abb07,
                    abb25_c     LIKE abb_file.abb25,
                    dc          LIKE type_file.chr10,
                    bal         LIKE abb_file.abb07,
                    balf        LIKE abb_file.abb07,
                    abb25_bal   LIKE abb_file.abb25,
                    pagenum     LIKE type_file.num5,
                    azi04       LIKE azi_file.azi04,
                    azi05       LIKE azi_file.azi05,
                    azi07       LIKE azi_file.azi07,
                    odr1        LIKE type_file.num5,    #No:181217 add 
                    odr         LIKE type_file.chr1);   #CHI-D60013 add odr
                   #azi07       LIKE azi_file.azi07);   #CHI-D60013 mark
END FUNCTION
 
FUNCTION gglq702_get_ahe02(p_aag01_str,p_ted02,p_gaq01) #TQC-930163
  DEFINE p_aag01_str     LIKE type_file.chr50
  DEFINE p_ted02         LIKE ted_file.ted02
  DEFINE p_gaq01         LIKE gaq_file.gaq01  #TQC-930163
  DEFINE l_ahe01         LIKE ahe_file.ahe01
  DEFINE l_ahe04         LIKE ahe_file.ahe04
  DEFINE l_ahe05         LIKE ahe_file.ahe05
  DEFINE l_ahe07         LIKE ahe_file.ahe07
  DEFINE #l_sql1          LIKE type_file.chr1000
         l_sql1          STRING      #NO.FUN-910082
  DEFINE l_ahe02_d       LIKE ze_file.ze03
  DEFINE l_ahe03         LIKE ahe_file.ahe03  #No.TQC-C50211
 
     #查找核算項值
     LET l_sql1 = " SELECT ",p_gaq01 CLIPPED," FROM aag_file ",
                  "  WHERE aag00 = '",bookno,"'",
                  "    AND aag01 LIKE ? ",
                  "    AND aag07 IN ('2','3') ",
                  "    AND ",p_gaq01 CLIPPED," IS NOT NULL"
     PREPARE gglq702_gaq01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_gaq01_cs SCROLL CURSOR FOR gglq702_gaq01_p  #只能取第一個
     #取核算項名稱
     LET l_ahe01 = NULL
     OPEN gglq702_gaq01_cs USING p_aag01_str
     IF SQLCA.sqlcode THEN
        CLOSE gglq702_gaq01_cs
        RETURN NULL
     END IF
     FETCH FIRST gglq702_gaq01_cs INTO l_ahe01
     IF SQLCA.sqlcode THEN
        CLOSE gglq702_gaq01_cs
        RETURN NULL
     END IF
     CLOSE gglq702_gaq01_cs
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
          #NOT cl_null(l_ahe07) THEN                       #No.TQC-C50211 mark
           NOT cl_null(l_ahe07) AND l_ahe03 = '1' THEN     #No.TQC-C50211
           LET l_ahe02_d = ''                              #No.TQC-C50211
           LET l_sql1 = "SELECT UNIQUE ",l_ahe07 CLIPPED,
                        "  FROM ",l_ahe04 CLIPPED,
                        " WHERE ",l_ahe05 CLIPPED," = '",p_ted02,"'"
           PREPARE ahe_p1 FROM l_sql1
           EXECUTE ahe_p1 INTO l_ahe02_d
        END IF
#No.TQC-C50211 --begin
        IF l_ahe03 = '2' THEN
           LET l_ahe02_d = ''
           SELECT aee04 INTO l_ahe02_d
             FROM aee_file
            WHERE aee00 = bookno
              AND aee01 = p_aag01_str
              AND aee02 = g_aee02
              AND aee03 = p_ted02
        END IF
#No.TQC-C50211 --end
     END IF
 
     RETURN l_ahe02_d
END FUNCTION
 
FUNCTION gglq702_t()
   IF tm.b = 'Y' THEN
      CALL cl_set_comp_visible("abb24,df,d,cf,c,balf,bal",TRUE)
      CALL cl_set_comp_visible("abb25_d,abb25_c,abb25_bal",TRUE)
      CALL cl_getmsg("ggl-201",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("df",g_msg CLIPPED)
      CALL cl_getmsg("ggl-202",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-203",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("cf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-204",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-205",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("balf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-206",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
      #IF tm.d = 'Y' THEN   #FUN-C80102  mark
      IF tm.g = 'Y' THEN    #FUN-C80102  add
         CALL cl_set_comp_visible("ted09",TRUE)
      ELSE
         CALL cl_set_comp_visible("ted09",FALSE)
      END IF
   ELSE
      CALL cl_set_comp_visible("ted09,abb24,abb25,df,cf,balf",FALSE) #TQC-930163 
      CALL cl_set_comp_visible("abb25_d,abb25_c,abb25_bal",FALSE)
      CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-209",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   END IF
   LET g_aag01 = NULL
   LET g_aag02 = NULL
   LET g_ted02 = NULL
   LET g_ted02_d = NULL
   LET g_ted09 = NULL  #TQC-930163
   CLEAR FORM
   CALL g_abb.clear()
   CALL gglq702_cs()
 
END FUNCTION
 
FUNCTION q702_drill_down()  
   DEFINE 
          l_wc         STRING       #NO.FUN-910082
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
 
   IF cl_null(g_aag01) THEN RETURN END IF
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_abb[l_ac].aba01) THEN RETURN END IF
   LET g_msg = "aglt110 '",g_abb[l_ac].aba01,"'"
   CALL cl_cmdrun(g_msg)
 
END FUNCTION
 
FUNCTION gglq702_curs()
  DEFINE #l_sql   LIKE type_file.chr1000
         l_sql   STRING      #NO.FUN-910082
  DEFINE #l_sql1  LIKE type_file.chr1000
         l_sql1   STRING      #NO.FUN-910082
  DEFINE 
         l_wc2         STRING       #NO.FUN-910082

     #FUN-C80102--mark--str--
     #LET mm1 = MONTH(bdate)
     #LET nn1 = MONTH(edate)
     #FUN-C80102--mark--end--
     #FUN-C80102--add--str--
     LET mm1 = s_get_aznn(g_plant,g_aza.aza81,bdate,3)
     LET nn1 = s_get_aznn(g_plant,g_aza.aza81,edate,3)
     #FUN-C80102--add--end--
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
     CASE tm.a
          WHEN '1'   LET g_field = 'abb11'
                     LET g_gaq01 = 'aag15'
                     LET g_aee02 ='1'        #No.TQC-C50211
          WHEN '2'   LET g_field = 'abb12'
                     LET g_gaq01 = 'aag16'
                     LET g_aee02 ='2'        #No.TQC-C50211
          WHEN '3'   LET g_field = 'abb13'
                     LET g_gaq01 = 'aag17'
                     LET g_aee02 ='3'        #No.TQC-C50211
          WHEN '4'   LET g_field = 'abb14'
                     LET g_gaq01 = 'aag18'
                     LET g_aee02 ='4'        #No.TQC-C50211
          WHEN '5'   LET g_field = 'abb31'
                     LET g_gaq01 = 'aag31'
                     LET g_aee02 ='5'        #No.TQC-C50211
          WHEN '6'   LET g_field = 'abb32'
                     LET g_gaq01 = 'aag32'
                     LET g_aee02 ='6'        #No.TQC-C50211
          WHEN '7'   LET g_field = 'abb33'
                     LET g_gaq01 = 'aag33'
                     LET g_aee02 ='7'        #No.TQC-C50211
          WHEN '8'   LET g_field = 'abb34'
                     LET g_gaq01 = 'aag34'
                     LET g_aee02 ='8'        #No.TQC-C50211
          WHEN '9'   LET g_field = 'abb35'
                     LET g_gaq01 = 'aag35'
                     LET g_aee02 ='9'        #No.TQC-C50211
          WHEN '10'  LET g_field = 'abb36'
                     LET g_gaq01 = 'aag36'
                     LET g_aee02 ='10'        #No.TQC-C50211
          WHEN '99'  LET g_field = 'abb37'  #No.FUN-9A0052
                     LET g_gaq01 = 'aag37'
                     LET g_aee02 ='99'        #No.TQC-C50211
     END CASE
     IF cl_null(g_field) THEN 
        LET g_field = 'abb11'
     END IF
     IF cl_null(g_gaq01) THEN
        LET g_gaq01 = 'aag15'
     END IF
 
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')  #No.TQC-A50151
 
     #查找科目
     LET l_sql1= "SELECT aag01,aag02 FROM aag_file ",
                 " WHERE aag03 ='2' ",
                 "   AND aag00 = '",bookno,"' ",
#                "   AND aag24 <> 1 ",           #一級統治不要出來,BY蔡曉峰規定  #No.FUN-A40020
                 "   AND NOT (aag24 = 1 AND aag07 = '1') ", #No.FUN-A40020 
                 "   AND ",tm.wc1 CLIPPED
     PREPARE gglq702_aag01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglq702_aag01_cs CURSOR FOR gglq702_aag01_p
 
     #查找核算項
     LET l_sql1 = "SELECT UNIQUE ted02 FROM ted_file ",
                  " WHERE ted00 = '",bookno,"'",
                  "   AND ted01 LIKE ? ",           #account
                  "   AND ted011 = '",tm.a,"'",
                  "   AND ",tm.wc2 CLIPPED
     LET l_sql1 = cl_replace_str(l_sql1,"ted","aed")        #MOD-A80039 Add             
     PREPARE gglq702_ted02_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_ted02_cs1 CURSOR FOR gglq702_ted02_p1
 
     LET l_wc2 = tm.wc2
     LET l_wc2 = cl_replace_str(l_wc2,"ted02",g_field)

     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN 
     #   LET l_sql1 = " SELECT ",g_field CLIPPED," FROM aba_file,abb_file",
     #                "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                "    AND aba00 = '",bookno,"'",
     #                "    AND abb03 LIKE ? ",       #account
     #                "    AND ",g_field CLIPPED," IS NOT NULL",
     #                "    AND ",l_wc2
     #END IF 
     #IF tm.m = 'N' THEN 
     #   IF tm.f = '1' THEN 
     #      LET l_sql1 = " SELECT ",g_field CLIPPED," FROM aba_file,abb_file",
     #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                   "    AND aba00 = '",bookno,"'",
     #                   "    AND abb03 LIKE ? ",       #account
     #                   "    AND ",g_field CLIPPED," IS NOT NULL",
     #                   "    AND aba19 = 'Y'  ",
     #                   "    AND ",l_wc2
     #   ELSE 
     ##FUN-C80102--add--end--
     #      LET l_sql1 = " SELECT ",g_field CLIPPED," FROM aba_file,abb_file",
     #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                   "    AND aba00 = '",bookno,"'",
     #                   "    AND abb03 LIKE ? ",       #account
     #                   "    AND ",g_field CLIPPED," IS NOT NULL",
     #                   #"    AND aba19 = 'Y'   AND abapost = 'N'",   #FUN-C80102  mark
     #                   "    AND aba19 = 'Y'   AND abapost = 'Y'",    #FUN-C80102  add
     #                   "    AND ",l_wc2
     #    END IF    #FUN-C80102  add
     #END IF        #FUN-C80102  add
     #FUN-C80102--mark--end--


     #FUN-C80102--add--str--
     LET l_sql1 = " SELECT ",g_field CLIPPED," FROM aba_file,abb_file",
                     "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                     "    AND aba00 = '",bookno,"'",
                     "    AND abb03 LIKE ? ",       #account
                     "    AND ",g_field CLIPPED," IS NOT NULL",
                     "    AND ",l_wc2
     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql1 = l_sql1,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql1 = l_sql1,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql1 = l_sql1," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql1 = l_sql1," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq702_ted02_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_ted02_cs2 CURSOR FOR gglq702_ted02_p2
 
     #期初余額
     #1~mm-1
#    LET l_sql = "SELECT SUM(ted05),SUM(ted06),SUM(ted10),SUM(ted11) FROM ted_file", #MOD-A80039 Mark
     LET l_sql = "SELECT SUM(ted05),SUM(ted06),0,0 FROM ted_file",                   #MOD-A80039 Add     
                 " WHERE ted00 = '",bookno,"'",
                 "   AND ted01 LIKE ? ",                  #科目
                 "   AND ted02 = ? ",                     #核算項
                 "   AND ted011 = '",tm.a,"'",
                 "   AND ted03 = ",yy,
                 "   AND ted04 < ",mm                     #期初
     LET l_sql = cl_replace_str(l_sql,"ted","aed")        #MOD-A80039 Add
     PREPARE gglq702_qc1_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qc1_cs CURSOR FOR gglq702_qc1_p
     #mm(1~bdate-1)

     #FUN-C80102--mark--end--
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND aba00 = '",bookno,"'",
     #            "    AND abb03 LIKE ?   ",               #科目
     #            "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #            "    AND abb06 = ? ",
     #            "    AND aba03 = ",yy,
     #            "    AND aba04 = ",mm,
     #            "    AND aba02 < '",bdate,"'"
     #END IF 
     #IF tm.m = 'N' THEN 
     #   IF tm.f = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #                  "    AND abb06 = ? ",
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND aba02 < '",bdate,"'",
     #                  "    AND aba19 = 'Y' "  
     #   ELSE 
     # #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #                  "    AND abb06 = ? ",
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND aba02 < '",bdate,"'",
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'" 
     #   END IF   #FUN-C80102  add
     #END IF      #FUN-C80102  add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND abb06 = ? ",
                 "    AND aba03 = ",yy,
                 "    AND aba04 = ",mm,
                 "    AND aba02 < '",bdate,"'"
     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq702_qc2_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qc2_cs CURSOR FOR gglq702_qc2_p
 
     #tm.c = 'Y'
     #1~mm-1
     #FUN-C80102--mark--end--
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #               "    AND abb06 = ? ",
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 < ",mm
     #END IF 
     #IF tm.m = 'N' THEN 
     #   IF tm.f = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND aba00 = '",bookno,"'",
     #            "    AND abb03 LIKE ?   ",               #科目
     #            "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #            "    AND abb06 = ? ",
     #            "    AND aba03 = ",yy,
     #            "    AND aba04 < ",mm,
     #            "    AND aba19 = 'Y' "  
     #   ELSE 
     ##FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND aba00 = '",bookno,"'",
     #            "    AND abb03 LIKE ?   ",               #科目
     #            "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #            "    AND abb06 = ? ",
     #            "    AND aba03 = ",yy,
     #            "    AND aba04 < ",mm,
     #            #"    AND aba19 = 'Y' AND abapost = 'N'"  #期初未過帳   #FUN-C80102  mark
     #            "    AND aba19 = 'Y' AND abapost = 'N'"   #FUN-C80102  add
     #   END IF   #FUN-C80102  add
     #END IF      #FUN-C80102  add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--end--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    "    AND aba00 = '",bookno,"'",
                    "    AND abb03 LIKE ?   ",               #科目
                    "    AND ",g_field CLIPPED," = ? ",      #核算項值
                    "    AND abb06 = ? ",
                    "    AND aba03 = ",yy,
                    "    AND aba04 < ",mm
     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq702_qc3_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qc3_cs CURSOR FOR gglq702_qc3_p
     #mm(1~bdate-1)
     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND aba00 = '",bookno,"'",
     #            "    AND abb03 LIKE ?   ",               #科目
     #            "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #            "    AND aba03 = ",yy,
     #            "    AND aba04 = ",mm,
     #            "    AND abb06 = ? ",
     #            "    AND aba02 < '",bdate,"'"
     #END IF 
     #IF tm.m = 'N' THEN 
     #   IF tm.f = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND aba00 = '",bookno,"'",
     #            "    AND abb03 LIKE ?   ",               #科目
     #            "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #            "    AND aba03 = ",yy,
     #            "    AND aba04 = ",mm,
     #            "    AND abb06 = ? ",
     #            "    AND aba02 < '",bdate,"'",
     #            "    AND aba19 = 'Y' "  
     #   ELSE 
     # #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND abb06 = ? ",
     #                  "    AND aba02 < '",bdate,"'",
     #                  #"    AND aba19 = 'Y' AND abapost = 'N'"  #期初未過帳  #FUN-C80102  mark
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'"   #FUN-C80102  add
     #   END IF    #FUN-C80102  add
     # END IF      #FUN-C80102  add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND aba03 = ",yy,
                 "    AND aba04 = ",mm,
                 "    AND abb06 = ? ",
                 "    AND aba02 < '",bdate,"'" 

     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
      
     PREPARE gglq702_qc4_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qc4_cs CURSOR FOR gglq702_qc4_p
 
     #當期異動
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN    #FUN-C80102 mark
        LET l_sql = " SELECT '','','','',0,aba02,aba01,abb04,",
                    "        abb06,abb07,abb07f,abb24,abb25, ",
                    "        0,0,0,0,0,0,0,0,0,0             ",
                    "   FROM aba_file a,abb_file ",
                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    "    AND aba00 = '",bookno,"'",
                    "    AND abb03 LIKE ?   ",               #科目
                    "    AND ",g_field CLIPPED," = ? ",      #核算項值
                    "    AND aba03 = ",yy,
                    #"    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))",  #CHI-C70031  #FUN-D40044 mark
                    "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
                    "    AND aba04 = ? "
     #END IF  #FUN-C80102 mark

     #FUN-D40044--add--str--
     IF tm.i = 'N' THEN 
        LET l_sql = l_sql CLIPPED," AND NOT EXISTS (",
            " SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01 ",
            "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))"
     END IF
     #FUN-D40044--add--end--

     #FUN-C80102--mark--str--
     #IF tm.m = 'N' THEN 
     #FUN-C80102--add--end--
     #   LET l_sql = " SELECT '','','','',0,aba02,aba01,abb04,",
     #               "        abb06,abb07,abb07f,abb24,abb25, ",
     #               "        0,0,0,0,0,0,0,0,0,0             ",
     #               "   FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND ",g_field CLIPPED," = ? ",      #核算項值
     #               "    AND aba03 = ",yy,
     #               "    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))",  #CHI-C70031
     #               "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
     #               "    AND aba04 = ? ",
     #               "    AND aba19 = 'Y' "
     #   #IF tm.c = 'N' THEN   #FUN-C80102  mark
     #   IF tm.f = '2' THEN    #FUN-C80102  add
     #      #LET l_sql = l_sql CLIPPED," AND abapost = 'Y' ORDER BY aba02"   #過帳   #FUN-A40011 #MOD-B50163 mark
     #      LET l_sql = l_sql CLIPPED," AND abapost = 'Y' ",           #過帳   #MOD-B50163 
     #                            " ORDER BY aba02,aba01,abb02 "           #MOD-B50163 
#FUN-A40011 --begin--
     #      ELSE
     #         LET l_sql = l_sql CLIPPED," ORDER BY aba02,aba01,abb02 "           #MOD-B50163  
#FUN-A40011 --end--                   
     #   END IF
     #END IF   #FUN-C80102  add

     #FUN-C80102--add--str--
     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 = 'N' or aba19 ='Y')",
                           " ORDER BY aba02,aba01,abb02 "   
        ELSE
           LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))",
                            " ORDER BY aba02,aba01,abb02 "   
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND  aba19 ='Y'",
                          " ORDER BY aba02,aba01,abb02 "   
        ELSE
           LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'",
                          " ORDER BY aba02,aba01,abb02 "   
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq702_qj1_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq702_qj1_cs CURSOR FOR gglq702_qj1_p
 
END FUNCTION
 
FUNCTION gglq702()
   DEFINE l_name               LIKE type_file.chr20,
          l_sql,l_sql1          STRING,      #NO.FUN-910082
          l_date,l_date1       LIKE aba_file.aba02,
          l_i                  LIKE type_file.num5,
          qc_ted05             LIKE ted_file.ted05,
          qc_ted06             LIKE ted_file.ted06,
          qc_ted10             LIKE ted_file.ted10,
          qc_ted11             LIKE ted_file.ted11,
          qc1_ted05            LIKE ted_file.ted05,
          qc1_ted06            LIKE ted_file.ted06,
          qc1_ted10            LIKE ted_file.ted10,
          qc1_ted11            LIKE ted_file.ted11,
          qc2_ted05            LIKE ted_file.ted05,
          qc2_ted06            LIKE ted_file.ted06,
          qc2_ted10            LIKE ted_file.ted10,
          qc2_ted11            LIKE ted_file.ted11,
          qc3_ted05            LIKE ted_file.ted05,
          qc3_ted06            LIKE ted_file.ted06,
          qc3_ted10            LIKE ted_file.ted10,
          qc3_ted11            LIKE ted_file.ted11,
          qc4_ted05            LIKE ted_file.ted05,
          qc4_ted06            LIKE ted_file.ted06,
          qc4_ted10            LIKE ted_file.ted10,
          qc4_ted11            LIKE ted_file.ted11,
          l_qcye               LIKE abb_file.abb07,
          l_qcyef              LIKE abb_file.abb07,
          t_qcye               LIKE abb_file.abb07,
          t_qcyef              LIKE abb_file.abb07,
          l_ted02              LIKE ted_file.ted02,
          l_ted02_d            LIKE ze_file.ze03,
          l_aag01_str          LIKE type_file.chr50,
          t_bal,t_balf                 LIKE abb_file.abb07,
          t_debit,t_debitf             LIKE abb_file.abb07,
          t_credit,t_creditf           LIKE abb_file.abb07,
          l_d,l_df,l_c,l_cf            LIKE abb_file.abb07,
          n_bal,n_balf                 LIKE abb_file.abb07,
          l_abb25_c,l_abb25_d,l_abb25_bal LIKE abb_file.abb25,
          t_date2                      LIKE type_file.dat,
          t_date1                      LIKE type_file.dat,
          l_dc                         LIKE type_file.chr10,
          l_year                       LIKE type_file.num10,
          l_month                      LIKE type_file.num10,          
          l_flag3                      LIKE type_file.chr1,          #TQC-970049
          l_flag4                      LIKE type_file.chr1,          #TQC-970310
          sr1                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02
                               END RECORD,
          sr2                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               ted02    LIKE ted_file.ted02,
                               ted02_d  LIKE ze_file.ze03
                               END RECORD,
          sr                   RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               ted02    LIKE ted_file.ted02,
                               ted02_d  LIKE ze_file.ze03,
                               aba04    LIKE aba_file.aba04,
                               aba02    LIKE aba_file.aba02,
                               aba01    LIKE aba_file.aba01,
                               abb04    LIKE abb_file.abb04,
                               abb06    LIKE abb_file.abb06,
                               abb07    LIKE abb_file.abb07,
                               abb07f   LIKE abb_file.abb07f,
                               abb24    LIKE abb_file.abb24,
                               abb25    LIKE abb_file.abb25,
                               qcye     LIKE abb_file.abb07,
                               qcyef    LIKE abb_file.abb07,
                               qc_md    LIKE abb_file.abb07,
                               qc_mdf   LIKE abb_file.abb07,
                               qc_mc    LIKE abb_file.abb07,
                               qc_mcf   LIKE abb_file.abb07,
                               qc_yd    LIKE abb_file.abb07,
                               qc_ydf   LIKE abb_file.abb07,
                               qc_yc    LIKE abb_file.abb07,
                               qc_ycf   LIKE abb_file.abb07
                               END RECORD
DEFINE l_chr                   LIKE type_file.chr1    #FUN-A40011 
 
     CALL gglq702_table()
     LET l_flag3 = 'N'                      #TQC-970049
 
     #IF tm.d='N' THEN      #FUN-C80102  mark
     IF tm.g = 'N' THEN     #FUN-C80102  add
        CALL gglq702_curs()
     ELSE
        CALL gglq702_curs1()
     END IF
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
     FOREACH gglq702_aag01_cs INTO sr1.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach gglq702_aag01_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr1.aag01 CLIPPED,'\%'    #No.MOD-940388
        FOREACH gglq702_ted02_cs1 USING l_aag01_str
                                  INTO l_ted02
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq702_ted02_cs1',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #get dimension description
#          CALL gglq702_get_ahe02(l_aag01_str,l_ted02,g_gaq01) #TQC-930163
           CALL gglq702_get_ahe02(sr1.aag01,l_ted02,g_gaq01) #TQC-930163  #No.TQC-C50211
                RETURNING l_ted02_d
           INSERT INTO gglq702_ted_tmp VALUES(sr1.aag01,sr1.aag02,l_ted02,l_ted02_d,'') #TQC-930163
#          IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN #CHI-C30115 mark
           IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
              CALL cl_err3('ins','gglq702_ted_tmp',sr1.aag01,l_ted02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
 
        FOREACH gglq702_ted02_cs2 USING l_aag01_str
                                  INTO l_ted02
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq702_ted02_cs2',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #get dimension description
#          CALL gglq702_get_ahe02(l_aag01_str,l_ted02,g_gaq01) #TQC-930163
           CALL gglq702_get_ahe02(sr1.aag01,l_ted02,g_gaq01) #TQC-930163  #No.TQC-C50211
                RETURNING l_ted02_d
           INSERT INTO gglq702_ted_tmp VALUES(sr1.aag01,sr1.aag02,l_ted02,l_ted02_d,'') #TQC-930163
#          IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN #CHI-C30115 mark
           IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
              CALL cl_err3('ins','gglq702_ted_tmp',sr1.aag01,l_ted02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
     END FOREACH
 
     LET g_prog = 'gglr301'
     LET g_pageno = 0
     LET l_cnt = 0  #No:181217 add 
 
     DECLARE gglq702_cs1 CURSOR FOR
      SELECT UNIQUE aag01,aag02,ted02,ted02_d FROM gglq702_ted_tmp
       ORDER BY aag01,ted02
 
     FOREACH gglq702_cs1 INTO sr2.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach gglq702_cs1',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr2.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr2.aag01 CLIPPED,'\%'    #No.MOD-940388
 
        #期初
        LET qc1_ted05 = 0  LET qc1_ted06 = 0
        LET qc1_ted10 = 0  LET qc1_ted11 = 0
        LET qc2_ted05 = 0  LET qc2_ted06 = 0
        LET qc2_ted10 = 0  LET qc2_ted11 = 0
        LET qc3_ted05 = 0  LET qc3_ted06 = 0
        LET qc3_ted10 = 0  LET qc3_ted11 = 0
        LET qc4_ted05 = 0  LET qc4_ted06 = 0
        LET qc4_ted10 = 0  LET qc4_ted11 = 0
        #1~mm-1
        OPEN gglq702_qc1_cs USING l_aag01_str,sr2.ted02
        FETCH gglq702_qc1_cs INTO qc1_ted05,qc1_ted06,qc1_ted10,qc1_ted11
        CLOSE gglq702_qc1_cs
        IF cl_null(qc1_ted05) THEN LET qc1_ted05 = 0 END IF
        IF cl_null(qc1_ted06) THEN LET qc1_ted06 = 0 END IF
        IF cl_null(qc1_ted10) THEN LET qc1_ted10 = 0 END IF
        IF cl_null(qc1_ted11) THEN LET qc1_ted11 = 0 END IF
        #mm(day 1~<bdate)
        OPEN gglq702_qc2_cs USING l_aag01_str,sr2.ted02,'1'
        FETCH gglq702_qc2_cs INTO qc2_ted05,qc2_ted10
        CLOSE gglq702_qc2_cs
        OPEN gglq702_qc2_cs USING l_aag01_str,sr2.ted02,'2'
        FETCH gglq702_qc2_cs INTO qc2_ted06,qc2_ted11
        CLOSE gglq702_qc2_cs
        IF cl_null(qc2_ted05) THEN LET qc2_ted05 = 0 END IF
        IF cl_null(qc2_ted06) THEN LET qc2_ted06 = 0 END IF
        IF cl_null(qc2_ted10) THEN LET qc2_ted10 = 0 END IF
        IF cl_null(qc2_ted11) THEN LET qc2_ted11 = 0 END IF
 
        #IF tm.c = 'Y' THEN   #FUN-C80102  mark
           #1~mm-1
           OPEN gglq702_qc3_cs USING l_aag01_str,sr2.ted02,'1'
           FETCH gglq702_qc3_cs INTO qc3_ted05,qc3_ted10
           CLOSE gglq702_qc3_cs
           OPEN gglq702_qc3_cs USING l_aag01_str,sr2.ted02,'2'
           FETCH gglq702_qc3_cs INTO qc3_ted06,qc3_ted11
           CLOSE gglq702_qc3_cs
           IF cl_null(qc3_ted05) THEN LET qc3_ted05 = 0 END IF
           IF cl_null(qc3_ted06) THEN LET qc3_ted06 = 0 END IF
           IF cl_null(qc3_ted10) THEN LET qc3_ted10 = 0 END IF
           IF cl_null(qc3_ted11) THEN LET qc3_ted11 = 0 END IF
           #mm(1~bdate-1)
           OPEN gglq702_qc4_cs USING l_aag01_str,sr2.ted02,'1'
           FETCH gglq702_qc4_cs INTO qc4_ted05,qc4_ted10
           CLOSE gglq702_qc4_cs
           OPEN gglq702_qc4_cs USING l_aag01_str,sr2.ted02,'2'
           FETCH gglq702_qc4_cs INTO qc4_ted06,qc4_ted11
           CLOSE gglq702_qc4_cs
           IF cl_null(qc4_ted05) THEN LET qc4_ted05 = 0 END IF
           IF cl_null(qc4_ted06) THEN LET qc4_ted06 = 0 END IF
           IF cl_null(qc4_ted10) THEN LET qc4_ted10 = 0 END IF
           IF cl_null(qc4_ted11) THEN LET qc4_ted11 = 0 END IF
        #END IF   #FUN-C80102  mark
        LET qc_ted05 = qc1_ted05 + qc2_ted05 + qc3_ted05 + qc4_ted05
        LET qc_ted06 = qc1_ted06 + qc2_ted06 + qc3_ted06 + qc4_ted06
        LET qc_ted10 = qc1_ted10 + qc2_ted10 + qc3_ted10 + qc4_ted10
        LET qc_ted11 = qc1_ted11 + qc2_ted11 + qc3_ted11 + qc4_ted11
 
        LET l_qcye  = qc_ted05 - qc_ted06
        LET l_qcyef = qc_ted10 - qc_ted11
        #若t_qcye = 0 & 異間異動為零，則不打印
        LET t_qcye  = l_qcye
        LET t_qcyef = l_qcyef
        LET l_flag4 = 'N'                #TQC-970310
        
        LET l_chr = 'Y'        #FUN-A40011 
        FOR l_i = mm1 TO nn1
            LET l_flag='N'
            FOREACH gglq702_qj1_cs USING l_aag01_str,sr2.ted02,l_i INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET l_flag='Y'
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.ted02   = sr2.ted02
               LET sr.ted02_d = sr2.ted02_d
               LET sr.aba04   = l_i
               LET sr.qcye    = l_qcye
               LET sr.qcyef   = l_qcyef
 
               LET sr.qc_md   = qc2_ted05 + qc4_ted05
               LET sr.qc_mdf  = qc2_ted10 + qc4_ted10
               LET sr.qc_mc   = qc2_ted06 + qc4_ted06
               LET sr.qc_mcf  = qc2_ted11 + qc4_ted11
 
               LET sr.qc_yd   = qc1_ted05 + qc3_ted05
               LET sr.qc_ydf  = qc1_ted10 + qc3_ted10
               LET sr.qc_yc   = qc1_ted06 + qc3_ted06
               LET sr.qc_ycf  = qc1_ted11 + qc3_ted11
 
               IF sr.abb06 = '1' THEN
                  LET t_qcye  = t_qcye + sr.abb07
                  LET t_qcyef = t_qcyef+ sr.abb07
               ELSE
                  LET t_qcye  = t_qcye - sr.abb07
                  LET t_qcyef = t_qcyef- sr.abb07
               END IF
 
      IF l_flag3 = 'N' THEN
        IF l_flag4 = 'N' THEN                                     #TQC-970310 add 
          LET t_bal     = sr.qcye
          LET t_balf    = sr.qcyef
#No.TQC-B60041 --begin
          LET t_debit   = sr.qc_md
          LET t_debitf  = sr.qc_mdf
          LET t_credit  = sr.qc_mc
          LET t_creditf = sr.qc_mcf 
#         LET t_debit   = sr.qc_yd  + sr.qc_md
#         LET t_debitf  = sr.qc_ydf + sr.qc_mdf
#         LET t_credit  = sr.qc_yc  + sr.qc_mc
#         LET t_creditf = sr.qc_ycf + sr.qc_mcf 
#No.TQC-B60041 --end
          LET l_flag4 = 'Y'                                       #TQC-970310 add
        END IF                                                    #TQC-970310 add      
      #IF sr.aba04 = MONTH(bdate) THEN     #FUN-C80102  mark
      IF sr.aba04 = s_get_aznn(g_plant,g_aza.aza81,bdate,3) THEN   #FUN-C80102  add
         LET t_date2 = bdate
      ELSE
         LET t_date2 = MDY(sr.aba04,1,yy)
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.abb24
 
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
 
      CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
      LET l_abb25_bal = n_bal / n_balf   
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF l_chr = 'Y' THEN   #FUN-A40011       
        INSERT INTO gglq702_tmp
        VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'1',
             t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
             #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)       #CHI-D60013 mark
             #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,'1')   #CHI-D60013  #No:181217 mark
                 l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'1')       #No:181217 add
      END IF    #FUN-A40011
      LET l_chr = 'N'    #FUN-A40011              
      LET l_flag3 = 'Y'
      END IF
 
      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
         IF cl_null(sr.abb07)  THEN LET sr.abb07  = 0 END IF
         IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
         IF sr.abb06 = 1 THEN
            LET t_bal   = t_bal   + sr.abb07
            LET t_balf  = t_balf  + sr.abb07f
            LET t_debit = t_debit + sr.abb07
            LET t_debitf= t_debitf+ sr.abb07f
         ELSE
            LET t_bal    = t_bal    - sr.abb07
            LET t_balf   = t_balf   - sr.abb07f
            LET t_credit = t_credit + sr.abb07
            LET t_creditf= t_creditf+ sr.abb07f
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
         IF sr.abb06 = '1' THEN
            LET l_d  = sr.abb07
            LET l_df = sr.abb07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.abb07
            LET l_cf = sr.abb07f
         END IF
 
 
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)       #CHI-D60013 mark
               # l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,'2')   #CHI-D60013  #No:181217 mark
                 l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'2')          #No:181217 add
      END IF     
      LET l_cnt=l_cnt+1   #No:181217 add  
            END FOREACH
            IF l_flag = "N" THEN
               IF t_qcye = 0 AND t_qcyef = 0 
                  AND qc_ted05 = 0 AND qc_ted06 = 0 THEN #TQC-930163 
                  CONTINUE FOR
               END IF
               INITIALIZE sr.* TO NULL
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.ted02   = sr2.ted02
               LET sr.ted02_d = sr2.ted02_d
               LET sr.aba04   = l_i
               LET sr.qcye    = l_qcye
               LET sr.qcyef   = l_qcyef
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET sr.aba02   = l_date1
               LET sr.aba01   = NULL
               LET sr.abb04   = NULL
               LET sr.abb06   = NULL
               LET sr.abb07   = 0
               LET sr.abb07f  = 0
               LET sr.abb24   = NULL
               LET sr.abb25   = 0
 
               LET sr.qc_md   = qc2_ted05 + qc4_ted05
               LET sr.qc_mdf  = qc2_ted10 + qc4_ted10
               LET sr.qc_mc   = qc2_ted06 + qc4_ted06
               LET sr.qc_mcf  = qc2_ted11 + qc4_ted11
 
               LET sr.qc_yd   = qc1_ted05 + qc3_ted05
               LET sr.qc_ydf  = qc1_ted10 + qc3_ted10
               LET sr.qc_yc   = qc1_ted06 + qc3_ted06
               LET sr.qc_ycf  = qc1_ted11 + qc3_ted11
 
      IF l_flag3 = 'N' THEN
        IF l_flag4 = 'N' THEN                                     #TQC-970310 add 
          LET t_bal     = sr.qcye
          LET t_balf    = sr.qcyef
#No.TQC-B60041 --begin
          LET t_debit   = sr.qc_md
          LET t_debitf  = sr.qc_mdf
          LET t_credit  = sr.qc_mc
          LET t_creditf = sr.qc_mcf 
#         LET t_debit   = sr.qc_yd  + sr.qc_md
#         LET t_debitf  = sr.qc_ydf + sr.qc_mdf
#         LET t_credit  = sr.qc_yc  + sr.qc_mc
#         LET t_creditf = sr.qc_ycf + sr.qc_mcf 
#No.TQC-B60041 --end
          LET l_flag4 = 'Y'                                       #TQC-970310 add
        END IF                                                    #TQC-970310 add            
      #IF sr.aba04 = MONTH(bdate) THEN     #FUN-C80102  mark
      IF sr.aba04 = s_get_aznn(g_plant,g_aza.aza81,bdate,3) THEN    #FUN-C80102  add
         LET t_date2 = bdate
      ELSE
         LET t_date2 = MDY(sr.aba04,1,yy)
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.abb24
 
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
 
      CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
      LET l_abb25_bal = n_bal / n_balf   
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF l_chr = 'Y' THEN    #FUN-A40011      
        INSERT INTO gglq702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'1',
              t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
              #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)           #No:181217 mark
              l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'3')  #No:181217 mark
      END IF     #FUN-A40011  
      LET l_chr = 'N'     #FUN-A40011                  
      LET l_flag3 = 'Y'
      END IF
 
      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
         IF cl_null(sr.abb07)  THEN LET sr.abb07  = 0 END IF
         IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
         IF sr.abb06 = 1 THEN
            LET t_bal   = t_bal   + sr.abb07
            LET t_balf  = t_balf  + sr.abb07f
            LET t_debit = t_debit + sr.abb07
            LET t_debitf= t_debitf+ sr.abb07f
         ELSE
            LET t_bal    = t_bal    - sr.abb07
            LET t_balf   = t_balf   - sr.abb07f
            LET t_credit = t_credit + sr.abb07
            LET t_creditf= t_creditf+ sr.abb07f
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
         IF sr.abb06 = '1' THEN
            LET l_d  = sr.abb07
            LET l_df = sr.abb07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.abb07
            LET l_cf = sr.abb07f
         END IF
 
 
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)           #No:181217 mark
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'3')  #No:181217 mark
      END IF      
            END IF
 
      CALL s_yp(edate) RETURNING l_year,l_month
      IF sr.aba04 = l_month THEN
         LET t_date2  = edate
      ELSE
         CALL s_azn01(yy,sr.aba04) RETURNING t_date1,t_date2
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.abb24
 
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
 
      
      SELECT SUM(abb07) INTO l_d
        FROM gglq702_tmp 
       WHERE abb06 = '1'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND ted02 = sr.ted02 
         AND aag01 = sr.aag01                                    #FUN-A40011             
      SELECT SUM(abb07f) INTO l_df
        FROM gglq702_tmp 
       WHERE abb06 = '1'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND ted02 = sr.ted02 
         AND aag01 = sr.aag01                                    #FUN-A40011             
      SELECT SUM(abb07) INTO l_c
        FROM gglq702_tmp 
       WHERE abb06 = '2'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND ted02 = sr.ted02 
         AND aag01 = sr.aag01                                    #FUN-A40011             
      SELECT SUM(abb07f) INTO l_cf
        FROM gglq702_tmp 
       WHERE abb06 = '2'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND ted02 = sr.ted02  
         AND aag01 = sr.aag01                                    #FUN-A40011             
      IF cl_null(l_d)  THEN LET l_d  = 0 END IF
      IF cl_null(l_df) THEN LET l_df = 0 END IF
      IF cl_null(l_c)  THEN LET l_c  = 0 END IF
      IF cl_null(l_cf) THEN LET l_cf = 0 END IF
      IF sr.aba04 = mm1 THEN
         LET l_d  = l_d  + sr.qc_md
         LET l_df = l_df + sr.qc_mdf
         LET l_c  = l_c  + sr.qc_mc
         LET l_cf = l_cf + sr.qc_mcf
      END IF
      CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg
      LET l_abb25_d = l_d / l_df
      LET l_abb25_c = l_c / l_cf
      LET l_abb25_bal = n_bal / n_balf
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF cl_null(l_abb25_d)   THEN LET l_abb25_d   = 0 END IF
      IF cl_null(l_abb25_c)   THEN LET l_abb25_c   = 0 END IF
      INSERT INTO gglq702_tmp
      VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'3',
             t_date2,'',g_msg,sr.abb24,'',0,0,
             l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
             #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)       #CHI-D60013 mark
             #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,'3')   #CHI-D60013  #No:181217 mark
              l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'4')          #No:181217 add
 
 
      CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
      LET l_abb25_d = t_debit / t_debitf
      LET l_abb25_c = t_credit / t_creditf
      LET l_abb25_bal = n_bal / n_balf
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
      IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
      INSERT INTO gglq702_tmp
      VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'4',
             t_date2,'',g_msg,sr.abb24,'',0,0,
             t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
              #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)       #CHI-D60013 mark
             #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,'3')   #CHI-D60013  #No:181217 mark
              l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_cnt,'4')          #No:181217 add
      LET l_flag3 = 'N'                       #TQC-970049
        END FOR
      LET l_cnt=l_cnt+1 #No:181217 add 
     END FOREACH
 
 
END FUNCTION

#FUN-C80102--add--str--
#獲取當期的第一天和最後一天
FUNCTION q702_getday()
   DEFINE l_year     LIKE  type_file.num5
   DEFINE l_month    LIKE  type_file.num5
   DEFINE l_firstday   STRING 
   DEFINE l_lastday    STRING
   LET l_year = year(g_today)
   LET l_month = month(g_today)
   CASE 
      WHEN  (l_month = '1' OR l_month = '3' OR l_month = '5' OR l_month = '7' OR 
            l_month = '8' OR l_month = '10' OR l_month = '12' )
             IF l_month = '10' OR l_month = '12' THEN 
                LET l_firstday = l_year USING '<<<<<<','/',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/',l_month USING '<<<<<<','/31'
             ELSE
                LET l_firstday = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/31'
             END IF 
      WHEN  (l_month = '4' OR l_month = '6' OR l_month = '9' OR l_month = '11')
             IF l_month = '11' THEN 
                LET l_firstday = l_year USING '<<<<<<','/',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/',l_month USING '<<<<<<','/30'
             ELSE
                LET l_firstday = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/30'
             END IF 
                 
      WHEN   (l_month = '2')  
             IF (l_year MOD 4 = 0 AND l_year MOD 100 !=0) OR (l_year MOD 400 = 0) THEN
                LET l_firstday = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/29'
             ELSE
                LET l_firstday = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/28'
             END IF
   END CASE   
   LET l_firstday = l_firstday.substring(3,l_firstday.getLength())
   LET l_lastday = l_lastday.substring(3,l_lastday.getLength())
   LET bdate = l_firstday
   LET edate = l_lastday  
   
END FUNCTION 
#FUN-C80102--mark--end--

#No.FUN-9C0072 精簡程式碼 
 
