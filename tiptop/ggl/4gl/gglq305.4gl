# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: gglq305.4gl
# Descriptions...: 科目余額表查詢
# Date & Author..: 08/06/25 by Carrier  #No.FUN-850030
# Modify.........: No.FUN-850030 08/07/24 By dxfwo 從21區移植到31區 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-940388 09/04/30 By wujie 字串連接%前要加轉義符\ 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A30008 10/04/15 By destiny 增加显示年初余额等字段
# Modify.........: No.FUN-A40020 10/04/09 By Carrier 独立科目层及设置为1 & 画面增加打印层级
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.FUN-B20055 11/02/22 By destiny 輸入改為DIALOG寫法 
# Modify.........: No.TQC-B30153 11/03/18 By wujie   5.25不支持原来的GROUP SUM写法
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-C70061 12/07/13 By xuxz 增加tm.h "顯示統制科目" 
# Modify.........: No.MOD-C80198 12/08/27 By yinhy  進入FOREACH之後應先執行INITIALIZE sr.* TO NULL來清空sr
# Modify.........: No.FUN-C90029 12/10/15 By yinhy 增加"含未確認傳票"選項
# Modify.........: No.FUN-C80092 12/12/07 By lixh1 增加寫入日誌功能
# Modify.........: No:FUN-C80102 12/12/12 By zhangweib 報表改善追單
# Modify.........: No:FUN-C80102 12/12/19 By yangtt 添加金額根據幣種顯示小數位數
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.TQC-CC0122 12/12/26 By yangtt 1、串連時添加參數tm.i  2、【本幣期間異動借方】和【本幣期間異動貸方】金額合計累加了
# Modify.........: No.FUN-D10072 13/01/17 By yangtt 科目層級默認為空
# Modify.........: No.FUN-D10072 13/01/23 By yangtt 金額翻倍修改
# Modify.........: No.MOD-D20052 13/02/25 By yinhy 默認科目層級為99
# Modify.........: No.MOD-CC0102 13/03/18 By yinhy 增加"條件查詢"按鈕功能
# Modify.........: No.MOD-D30190 13/03/26 By yinhy 勾選已過帳無法查詢到數據
# Modify.........: No.MOD-D50259 13/05/29 By fengmy 列印长度小数取位原币取值错误
# Modify.........: No.FUN-D40121 13/06/28 By lujh 增加傳參
# Modify.........: No.MOD-DB0015 13/11/01 By fengmy 去掉餘額方向判斷
# Modify.........: No.FUN-D40121 13/11/15 By fengmy 補上FUN-D40121缺失內容

DATABASE ds
 
GLOBALS "../../config/top.global"  #No.FUN-850030
 
DEFINE tm             RECORD
                      bookno  LIKE aaa_file.aaa01,
                      yy      LIKE type_file.num5,
                      m1      LIKE type_file.num5,
                      m2      LIKE type_file.num5,
                      a       LIKE type_file.chr1,  #含未過帳資料
                      b       LIKE type_file.chr1,  #額外名稱
#                     c       LIKE type_file.chr1,  #資料選項   #No.FUN-A40020
                      lvl     LIKE type_file.num5,  #层级       #No.FUN-A40020
                      d       LIKE type_file.chr1,  #No.FUN-A30008
                      e       LIKE azi_file.azi01,  #No.FUN-A30008
                      f       LIKE type_file.chr1,  #No.FUN-A30008
                      wc      STRING,               #No.FUN-A30008
                      wc2     STRING,               #FUN-C80102
                      g       LIKE type_file.chr1,  #No.FUN-A30008
                      h       LIKE type_file.chr1,  #FUN-C70061 add
                      i       LIKE type_file.chr1,  #FUN-C90029 add
 		      more    LIKE type_file.chr1
                      END RECORD
DEFINE g_i            LIKE type_file.num5
DEFINE l_table        STRING
DEFINE g_str          STRING
DEFINE g_sql          STRING
DEFINE g_rec_b        LIKE type_file.num10
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_aah          DYNAMIC ARRAY OF RECORD
                      aah01     LIKE aah_file.aah01,
                     #aag02     LIKE aag_file.aag02,      #FUN-C80102 Mark
                      aag02     LIKE type_file.chr1000,   #FUN-C80102 Add
                      abb24     LIKE abb_file.abb24, #No.FUN-A30008
                      nc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      nc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      nc_aah04  LIKE aah_file.aah04, #No.FUN-A30008        
                      nc_aah05  LIKE aah_file.aah05, #No.FUN-A30008
                      qc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      qc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      qc_aah04  LIKE aah_file.aah04, 
                      qc_aah05  LIKE aah_file.aah05, 
                      qj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      qj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      qj_aah04  LIKE aah_file.aah04,
                      qj_aah05  LIKE aah_file.aah05,
                      qm_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      qm_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      qm_aah04  LIKE aah_file.aah04, 
                      qm_aah05  LIKE aah_file.aah05,
                      lj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      lj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      lj_aah04  LIKE aah_file.aah04, #No.FUN-A30008
                      lj_aah05  LIKE aah_file.aah05  #No.FUN-A30008
                      END RECORD
DEFINE g_pr           RECORD
                      aah01     LIKE aah_file.aah01,
                      aag02     LIKE aag_file.aag02,
                      type      LIKE type_file.chr10,
                      memo      LIKE type_file.chr50,
                      abb24     LIKE abb_file.abb24, #No.FUN-A30008
                      nc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      nc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      nc_aah04  LIKE aah_file.aah04, #No.FUN-A30008        
                      nc_aah05  LIKE aah_file.aah05, #No.FUN-A30008
                      qc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      qc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      qc_aah04  LIKE aah_file.aah04, 
                      qc_aah05  LIKE aah_file.aah04, 
                      qj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      qj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      qj_aah04  LIKE aah_file.aah04,
                      qj_aah05  LIKE aah_file.aah04,
                      qm_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      qm_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      qm_aah04  LIKE aah_file.aah04, 
                      qm_aah05  LIKE aah_file.aah04,
                      lj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                      lj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                      lj_aah04  LIKE aah_file.aah04, #No.FUN-A30008
                      lj_aah05  LIKE aah_file.aah05  #No.FUN-A30008
                      END RECORD
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE l_ac           LIKE type_file.num5
DEFINE g_abb24        LIKE abb_file.abb24 
#No.TQC-B30153 --begin
DEFINE g_qc_aah04     LIKE aah_file.aah04
DEFINE g_qc_aah05     LIKE aah_file.aah05
DEFINE g_qj_aah04     LIKE aah_file.aah04
DEFINE g_qj_aah05     LIKE aah_file.aah05
DEFINE g_qm_aah04     LIKE aah_file.aah04
DEFINE g_qm_aah05     LIKE aah_file.aah05
DEFINE g_nc_aah04     LIKE aah_file.aah04
DEFINE g_nc_aah05     LIKE aah_file.aah05
DEFINE g_lj_aah04     LIKE aah_file.aah04
DEFINE g_lj_aah05     LIKE aah_file.aah05
#No.TQC-B30153 --end
DEFINE g_cka00        LIKE cka_file.cka00   #FUN-C80092

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
   LET tm.a       = ARG_VAL(11)
   LET tm.b       = ARG_VAL(12)
   LET tm.lvl     = ARG_VAL(13)  #No.FUN-A40020 
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)
   #No.FUN-A30008--begin
   LET tm.d       = ARG_VAL(18)
   LET tm.e       = ARG_VAL(19)
   LET tm.f       = ARG_VAL(20)
   LET tm.wc      = ARG_VAL(21)
   LET tm.wc      = cl_replace_str(tm.wc, "\\\"", "'")   #FUN-D40121 add
   LET tm.g       = ARG_VAL(22)
   #No.FUN-A30008--end 
   LET tm.i       = ARG_VAL(23) #FUN-D40121 add
   LET tm.h       = ARG_VAL(24) #FUN-D40121 add
   CALL q305_out_1()
 
   OPEN WINDOW q305_w AT 5,10
#       WITH FORM "ggl/42f/gglq305_1" ATTRIBUTE(STYLE = g_win_style) #FUN-C80102 mark
        WITH FORM "ggl/42f/gglq305" ATTRIBUTE(STYLE = g_win_style)   #FUN-C80102 add
 
   CALL cl_ui_init()

#FUN-C80102----mark---str--
#  IF cl_null(tm.yy) THEN
#     CALL gglq305_tm(0,0)
#  ELSE
#     CALL gglq305()
#  END IF
#FUN-C80102----mark---end--

   IF cl_null(tm.wc) THEN   #FUN-D40121 add
      CALL q305_q()         #FUN-C80102
   #FUN-D40121--add--str--
   ELSE
      CALL gglq305()
      CALL gglq305_s()
   END IF
   #FUN-D40121--add--end--
   CALL q305_menu()
   DROP TABLE gglq305_tmp;
   CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
   CLOSE WINDOW q305_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q305_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q305_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
              #CALL gglq305_tm(0,0)  #FUN-C80102 Mark
               CALL q305_q()         #FUN-C80102 Add
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q305_out_2()
            END IF
         WHEN "drill_general_ledger"
            IF cl_chk_act_auth() THEN
               CALL q305_drill_gl()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_aah),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               CALL cl_doc()
            END IF
      END CASE
   END WHILE
END FUNCTION

#No.FUN-C80102 ---start--- Mark
#FUNCTION gglq305_tm(p_row,p_col)
#DEFINE lc_qbe_sn         LIKE gbm_file.gbm01
#  DEFINE p_row,p_col    LIKE type_file.num5,
#         l_n            LIKE type_file.num5,
#         l_flag         LIKE type_file.num5,
#         l_cmd          LIKE type_file.chr1000
#  DEFINE li_chk_bookno  LIKE type_file.num5
#  DEFINE l_n1           LIKE type_file.num5
#  LET p_row = 4 LET p_col =25
#
#  OPEN WINDOW gglq305_w AT p_row,p_col WITH FORM "ggl/42f/gglq305"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#  CALL cl_ui_locale("gglq305")
#
#  CALL cl_opmsg('p')
#  INITIALIZE tm.* TO NULL
#  LET tm.bookno = g_aza.aza81
#  LET tm.yy     = YEAR(g_today)
#  LET tm.m1     = MONTH(g_today)
#  LET tm.m2     = MONTH(g_today)
#  LET tm.a      = 'N'
#  LET tm.b      = 'N'
#  LET tm.lvl    = 1      #No.FUN-A40020 
#  LET tm.more   = 'N'
#  LET g_pdate   = g_today
#  LET g_rlang   = g_lang
#  LET g_bgjob   = 'N'
#  LET g_copies  = '1'
#  LET tm.d      = 'N'                #No.FUN-A30008
#  LET tm.e      = ''                 #No.FUN-A30008
#  LET tm.f      = 'N'                #No.FUN-A30008
#  LET tm.g      = 'N'                #No.FUN-A30008
#  LET tm.h      = 'Y'                #No.FUN-C70061 add
#  LET tm.i      = 'N'                #No.FUN-C90029
#  CALL cl_set_comp_entry('e',FALSE)  #No.FUN-A30008
#WHILE TRUE
#     #No.FUN-B20010  --Begin
#     DISPLAY BY NAME tm.bookno
#      INPUT BY NAME tm.bookno WITHOUT DEFAULTS
# 
#        BEFORE INPUT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#        AFTER FIELD bookno
#           IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
#           CALL s_check_bookno(tm.bookno,g_user,g_plant)
#                RETURNING li_chk_bookno
#           IF (NOT li_chk_bookno) THEN
#              NEXT FIELD bookno
#           END IF
#           SELECT * FROM aaa_file WHERE aaa01 = tm.bookno
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
#              NEXT FIELD bookno
#           END IF
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(bookno)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_aaa'
#                 CALL cl_create_qry() RETURNING tm.bookno
#                 DISPLAY BY NAME tm.bookno
#                 NEXT FIELD bookno                            
#           END CASE
# 
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
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
# 
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
# 
#    END INPUT
#    #No.FUN-B20010  --End
#    
#      CONSTRUCT BY NAME tm.wc ON aag01
#
#         ON ACTION CONTROLP
#            CASE
#                WHEN INFIELD(aag01)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= "c"
#                  LET g_qryparam.form = "q_aag_1"
#                  LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"   #FUN-B20010 add
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aag01
#                  NEXT FIELD aag01
#               OTHERWISE
#                  EXIT CASE
#            END CASE
#
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
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
#      END CONSTRUCT
#    #INPUT BY NAME tm.bookno,tm.yy,tm.m1,tm.m2,tm.a,tm.b,tm.d,tm.e,tm.f,tm.g,tm.lvl,tm.more     #No.FUN-A30008  #No.FUN-A40020 #B20010 mark
#    INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.a,tm.b,tm.d,tm.e,tm.f,tm.g,tm.lvl,tm.more  #FUN-B20010
#          WITHOUT DEFAULTS
# 
#        BEFORE INPUT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#        AFTER FIELD yy
#           IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
#           IF tm.yy <= 0 THEN NEXT FIELD yy END IF
# 
#        AFTER FIELD m1
#           IF cl_null(tm.m1) OR tm.m1 > 13 OR tm.m1 < 1 THEN
#              NEXT FIELD m1
#           END IF
# 
#        AFTER FIELD m2
#           IF cl_null(tm.m2) OR tm.m2 > 13 OR tm.m2 < 1 OR tm.m2 < tm.m1 THEN
#              NEXT FIELD m2
#           END IF
#       #No.FUN-B20010 --Begin
#       #AFTER FIELD bookno
#       #   IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
#       #   CALL s_check_bookno(tm.bookno,g_user,g_plant)
#       #        RETURNING li_chk_bookno
#       #   IF (NOT li_chk_bookno) THEN
#       #      NEXT FIELD bookno
#       #   END IF
#       #   SELECT * FROM aaa_file WHERE aaa01 = tm.bookno
#       #   IF SQLCA.sqlcode THEN
#       #      CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
#       #      NEXT FIELD bookno
#       #   END IF
#       #No.FUN-B20010 --End
#       
#        #No.FUN-A40020  --Begin                                                 
#        AFTER FIELD lvl                                                         
#           IF NOT cl_null(tm.lvl) THEN                                          
#              IF tm.lvl <= 0 THEN                                               
#                 NEXT FIELD lvl                                                 
#              END IF                                                            
#           END IF                                                               
#        #No.FUN-A40020  --End 
#
##No.FUN-A30008--begin
#        AFTER FIELD d
#           IF tm.d='Y' THEN 
#              CALL cl_set_comp_entry('e',TRUE)
#           ELSE
#           	  CALL cl_set_comp_entry('e',FALSE)
#           	  LET tm.e=''
#           END IF  
#        ON CHANGE d
#           IF tm.d='Y' THEN 
#              CALL cl_set_comp_entry('e',TRUE)
#           ELSE
#           	  CALL cl_set_comp_entry('e',FALSE)
#           	  LET tm.e='' 
#           END IF  
#        AFTER FIELD e
#           IF NOT cl_null(tm.e) THEN 
#              SELECT azi01 FROM azi_file WHERE azi01 = tm.e
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err(tm.e,'agl-109',0)   
#                 NEXT FIELD e
#              END IF
#           END IF 
#        AFTER FIELD f
#           IF tm.f='Y' THEN 
#              LET tm.d='Y'
#              DISPLAY BY NAME tm.d
#              CALL cl_set_comp_entry('e',TRUE)
#           #ELSE 
#           #	 LET tm.d='N'
#           #	 DISPLAY BY NAME tm.d
#           #	 CALL cl_set_comp_entry('e',FALSE)
#           #	 LET tm.e=''
#           END IF 
#        ON CHANGE f
#           IF tm.f='Y' THEN 
#              LET tm.d='Y'
#              DISPLAY BY NAME tm.d
#              CALL cl_set_comp_entry('e',TRUE)
#           #ELSE 
#           #	 LET tm.d='N'
#           #	 DISPLAY BY NAME tm.d
#           #	 CALL cl_set_comp_entry('e',FALSE)
#           #	 LET tm.e=''
#           END IF 
##No.FUN-A30008--end 
#        AFTER FIELD more
#           IF tm.more = 'Y'
#              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                                  g_bgjob,g_time,g_prtway,g_copies)
#                        RETURNING g_pdate,g_towhom,g_rlang,
#                                  g_bgjob,g_time,g_prtway,g_copies
#           END IF
# 
#        ON ACTION CONTROLP
#           CASE  
#              #No.FUN-B20010  --Begin
#              #WHEN INFIELD(bookno)
#              #   CALL cl_init_qry_var()
#              #   LET g_qryparam.form = 'q_aaa'
#              #   CALL cl_create_qry() RETURNING tm.bookno
#              #   DISPLAY BY NAME tm.bookno
#              #   NEXT FIELD bookno
#              #No.FUN-A30008--begin  
#              #No.FUN-B20010  --End 
#              WHEN INFIELD(e)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_azi'
#                 LET g_qryparam.default1 =tm.e
#                 CALL cl_create_qry() RETURNING tm.e
#                 DISPLAY BY NAME tm.e
#                 NEXT FIELD e                    
#              #No.FUN-A30008--end               
#           END CASE
# 
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
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
# 
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
# 
#    END INPUT
#    DIALOG ATTRIBUTES(UNBUFFERED)
#    
#       INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS=TRUE)	
#        
#          BEFORE INPUT
#              CALL cl_qbe_display_condition(lc_qbe_sn)
#        
#          AFTER FIELD bookno
#             IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
#             CALL s_check_bookno(tm.bookno,g_user,g_plant)
#                  RETURNING li_chk_bookno
#             IF (NOT li_chk_bookno) THEN
#                NEXT FIELD bookno
#             END IF
#             SELECT * FROM aaa_file WHERE aaa01 = tm.bookno
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
#                NEXT FIELD bookno
#             END IF
#             
#        END INPUT 
#             
#        CONSTRUCT BY NAME tm.wc ON aag01
#        
#        END CONSTRUCT 
#
#        INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.a,tm.b,tm.d,tm.e,tm.f,tm.g,tm.h,tm.i,tm.lvl,tm.more   #FUN-C90029 add tm.i
#          ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
#          
#         BEFORE INPUT
#             CALL cl_qbe_display_condition(lc_qbe_sn)
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
#         AFTER FIELD lvl                                                         
#            IF NOT cl_null(tm.lvl) THEN                                          
#               IF tm.lvl <= 0 THEN                                               
#                  NEXT FIELD lvl                                                 
#               END IF                                                            
#            END IF                                                               
#        
#         AFTER FIELD d
#            IF tm.d='Y' THEN 
#               CALL cl_set_comp_entry('e',TRUE)
#            ELSE
#            	  CALL cl_set_comp_entry('e',FALSE)
#            	  LET tm.e=''
#            END IF  
#            
#         ON CHANGE d
#            IF tm.d='Y' THEN 
#               CALL cl_set_comp_entry('e',TRUE)
#            ELSE
#            	  CALL cl_set_comp_entry('e',FALSE)
#            	  LET tm.e='' 
#            END IF  
#            
#         AFTER FIELD e
#            IF NOT cl_null(tm.e) THEN 
#               SELECT azi01 FROM azi_file WHERE azi01 = tm.e
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err(tm.e,'agl-109',0)   
#                  NEXT FIELD e
#               END IF
#            END IF 
#            
#         AFTER FIELD f
#            IF tm.f='Y' THEN 
#               LET tm.d='Y'
#               DISPLAY BY NAME tm.d
#               CALL cl_set_comp_entry('e',TRUE)
#            END IF 
#            
#         ON CHANGE f
#            IF tm.f='Y' THEN 
#               LET tm.d='Y'
#               DISPLAY BY NAME tm.d
#               CALL cl_set_comp_entry('e',TRUE)
#            END IF 
#        
#         AFTER FIELD more
#            IF tm.more = 'Y'
#               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                                   g_bgjob,g_time,g_prtway,g_copies)
#                         RETURNING g_pdate,g_towhom,g_rlang,
#                                   g_bgjob,g_time,g_prtway,g_copies
#            END IF    
#            
#        END INPUT    
#        
#          ON ACTION CONTROLP
#             CASE
#                WHEN INFIELD(bookno)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = 'q_aaa'
#                   CALL cl_create_qry() RETURNING tm.bookno
#                   DISPLAY BY NAME tm.bookno
#                   NEXT FIELD bookno    
#                WHEN INFIELD(aag01)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= "c"
#                  LET g_qryparam.form = "q_aag_1"
#                  LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"   #FUN-B20010 add
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aag01
#                WHEN INFIELD(e)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = 'q_azi'
#                   LET g_qryparam.default1 =tm.e
#                   CALL cl_create_qry() RETURNING tm.e
#                   DISPLAY BY NAME tm.e
#                   NEXT FIELD e                       
#                  NEXT FIELD aag01                                            
#             END CASE
#                                         
#          ON ACTION qbe_save
#             CALL cl_qbe_save()
#        
#           ON ACTION locale
#              CALL cl_show_fld_cont()
#              LET g_action_choice = "locale"
#              EXIT DIALOG
#                 
#          ON ACTION CONTROLR
#             CALL cl_show_req_fields()
#        
#          ON ACTION CONTROLG
#             CALL cl_cmdask()
#        
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE DIALOG
#        
#          ON ACTION about
#             CALL cl_about()
#        
#          ON ACTION help
#             CALL cl_show_help()
#        
#          ON ACTION exit
#             LET INT_FLAG = 1
#             EXIT DIALOG
#                      
#        ON ACTION accept
#           EXIT DIALOG 
#           
#        ON ACTION cancel 
#           LET INT_FLAG = 1
#           EXIT DIALOG     
#           
#   END DIALOG 
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF          
#   
#   IF INT_FLAG THEN
#No.FUN-A30008 --begin
#      LET INT_FLAG = 0 CLOSE WINDOW gglq305_w
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#      RETURN
#No.FUN-A30008 --end
#   END IF
#   
#FUN-B20055--end     
#   IF g_bgjob = 'Y' THEN
#      SELECT zz08 INTO l_cmd FROM zz_file
#             WHERE zz01='gglq305'
#      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
#         CALL cl_err('gglq305','9031',1)
#      ELSE
#         LET l_cmd = l_cmd CLIPPED,
#                         " '",g_pdate    CLIPPED,"'",
#                         " '",g_towhom   CLIPPED,"'",
#                         " '",g_rlang    CLIPPED,"'",
#                         " '",g_bgjob    CLIPPED,"'",
#                         " '",g_prtway   CLIPPED,"'",
#                         " '",g_copies   CLIPPED,"'",
#                         " '",tm.bookno  CLIPPED,"'",
#                         " '",tm.yy      CLIPPED,"'" ,
#                         " '",tm.m1      CLIPPED,"'" ,
#                         " '",tm.m2      CLIPPED,"'" ,
#                         " '",tm.a       CLIPPED,"'",
#                         " '",tm.b       CLIPPED,"'",
#                         " '",tm.lvl     CLIPPED,"'",  #No.FUN-A40020
#                         " '",g_rep_user CLIPPED,"'",
#                         " '",g_rep_clas CLIPPED,"'",
#                         " '",g_template CLIPPED,"'",
#                         " '",g_rpt_name CLIPPED,"'",
#                         " '",tm.d       CLIPPED,"'",       #No.FUN-A30008
#                         " '",tm.e       CLIPPED,"'",       #No.FUN-A30008
#                         " '",tm.f       CLIPPED,"'",       #No.FUN-A30008
#                         " '",tm.wc      CLIPPED,"'",       #No.FUN-A30008
#                         " '",tm.g       CLIPPED,"'"        #No.FUN-A30008
#         CALL cl_cmdat('gglq305',g_time,l_cmd)
#      END IF
#      CLOSE WINDOW gglq305_w
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
#   CALL cl_wait()
#   CALL gglq305()
#   ERROR ""
#   EXIT WHILE
#END WHILE
#  CLOSE WINDOW gglq305_w
#
#  CLEAR FORM
#  CALL g_aah.clear()
#  CALL gglq305_s()
#   CALL gglq305_show()
#   DISPLAY g_rec_b to FORMONLY.cnt
#
#END FUNCTION
#No.FUN-C80102 ---end  --- Mark

#FUN-C80102----add----str---
FUNCTION q305_q()
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_flag         LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5
   DEFINE l_n1           LIKE type_file.num5
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q305_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   MESSAGE "SERCHING!"                                          
   MESSAGE ""
END FUNCTION    

FUNCTION q305_cs() 
   DEFINE  l_cnt LIKE type_file.num5
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   DEFINE li_chk_bookno  LIKE type_file.num5

   CLEAR FORM #清除畫面
   CALL g_aah.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL
   LET tm.bookno = g_aza.aza81
   LET tm.yy     = YEAR(g_today)
   LET tm.m1     = MONTH(g_today)
   LET tm.m2     = MONTH(g_today)
   LET tm.a      = '2' 
   LET tm.b      = 'N'
#  LET tm.lvl    = 1   
   #LET tm.lvl    = NULL    #FUN-D10072   #MOD-D20052
   LET tm.lvl    = 99                     #MOD-D20052 
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   LET tm.d      = 'N'         
   LET tm.e      = ''           
   LET tm.f      = 'N'           
   LET tm.g      = 'N'            
   LET tm.h      = 'Y'             
   LET tm.i      = 'N'
   CALL cl_set_comp_entry('i',FALSE)
   IF tm.d='Y' THEN
      CALL cl_set_comp_visible("abb24,nc_tah09,nc_tah10,qc_tah09,qc_tah10,qj_tah09",TRUE)
      CALL cl_set_comp_visible("qj_tah10,qm_tah09,qm_tah10,lj_tah09,lj_tah10",TRUE)
   ELSE
      CALL cl_set_comp_visible("abb24,nc_tah09,nc_tah10,qc_tah09,qc_tah10,qj_tah09",FALSE)
      CALL cl_set_comp_visible("qj_tah10,qm_tah09,qm_tah10,lj_tah09,lj_tah10",FALSE)
   END IF
 

   DIALOG ATTRIBUTES(UNBUFFERED)
     
        INPUT tm.bookno,tm.yy,tm.m1,tm.m2,tm.b,tm.d,tm.f,tm.g,tm.lvl,tm.h,tm.a,tm.i
           FROM aah00,yy,m1,m2,b,d,f,g,lvl,h,a,i ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
         
           BEFORE INPUT
               CALL cl_qbe_display_condition(lc_qbe_sn)
         
           AFTER FIELD aah00
              IF cl_null(tm.bookno) THEN NEXT FIELD aah00 END IF
              CALL s_check_bookno(tm.bookno,g_user,g_plant)
                   RETURNING li_chk_bookno
              IF (NOT li_chk_bookno) THEN
                 NEXT FIELD aah00
              END IF
              SELECT * FROM aaa_file WHERE aaa01 = tm.bookno
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
                 NEXT FIELD aah00
              END IF
              
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
             
          AFTER FIELD lvl
             IF NOT cl_null(tm.lvl) THEN
                IF tm.lvl <= 0 THEN
                   NEXT FIELD lvl
                END IF
             END IF

          ON CHANGE a
             IF tm.a = '2' THEN
                LET tm.i = 'N'
                CALL cl_set_comp_entry('i',FALSE)
             ELSE
                CALL cl_set_comp_entry('i',TRUE)
             END IF

          ON CHANGE d
             IF tm.d='Y' THEN
                CALL cl_set_comp_visible("abb24,nc_tah09,nc_tah10,qc_tah09,qc_tah10,qj_tah09",TRUE)
                CALL cl_set_comp_visible("qj_tah10,qm_tah09,qm_tah10,lj_tah09,lj_tah10",TRUE)
             ELSE
                CALL cl_set_comp_visible("abb24,nc_tah09,nc_tah10,qc_tah09,qc_tah10,qj_tah09",FALSE)
                CALL cl_set_comp_visible("qj_tah10,qm_tah09,qm_tah10,lj_tah09,lj_tah10",FALSE)
             END IF

          AFTER FIELD f
             IF tm.f='Y' THEN
                LET tm.d='Y'
                DISPLAY BY NAME tm.d
             END IF

          ON CHANGE f
             IF tm.f='Y' THEN
                LET tm.d='Y'
                DISPLAY BY NAME tm.d
             END IF  
             IF tm.d='Y' THEN
                CALL cl_set_comp_visible("abb24,nc_tah09,nc_tah10,qc_tah09,qc_tah10,qj_tah09",TRUE)
                CALL cl_set_comp_visible("qj_tah10,qm_tah09,qm_tah10,lj_tah09,lj_tah10",TRUE)
             ELSE
                CALL cl_set_comp_visible("abb24,nc_tah09,nc_tah10,qc_tah09,qc_tah10,qj_tah09",FALSE)
                CALL cl_set_comp_visible("qj_tah10,qm_tah09,qm_tah10,lj_tah09,lj_tah10",FALSE)
             END IF
      END INPUT    
  
      CONSTRUCT BY NAME tm.wc ON aah01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      CONSTRUCT BY NAME tm.wc2 ON abb24
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aah00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               CALL cl_create_qry() RETURNING tm.bookno
               DISPLAY BY NAME tm.bookno
               NEXT FIELD aah00
            WHEN INFIELD(aah01)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_aag_1"
              LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aah01
            WHEN INFIELD(abb24)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_azi"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO abb24
         END CASE    
         
      ON ACTION qbe_save
         CALL cl_qbe_save()

      #No.MOD-CC0102  --Begin
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.MOD-CC0102  --End
      
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
         ACCEPT DIALOG 
         
      ON ACTION cancel 
         LET INT_FLAG = 1
         EXIT DIALOG     
            
   END DIALOG 
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
    END IF          
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0 
       RETURN
    END IF

    CALL gglq305()
    CALL gglq305_s()
END FUNCTION
#FUN-C80102-----add---end---

#No.FUN-A30008--begin 
#FUNCTION gglq305()
#   DEFINE l_name             LIKE type_file.chr20,
#          #l_sql              LIKE type_file.chr1000,
#          l_sql              STRING,      #NO.FUN-910082
#          l_aao              LIKE type_file.chr1000,
#          l_i                LIKE type_file.num5,
#          l_aah              LIKE type_file.chr1000,
#          l_abb              LIKE type_file.chr1000,
#          qc_aah04           LIKE aah_file.aah04,  #期初
#          qc_aah05           LIKE aah_file.aah05,
#          qm_aah04           LIKE aah_file.aah04,  #期末
#          qm_aah05           LIKE aah_file.aah05,
#          l_aah041           LIKE aah_file.aah04,
#          l_aah051           LIKE aah_file.aah05,
#          l_aah042           LIKE aah_file.aah04,
#          l_aah052           LIKE aah_file.aah05,
#          l_aag01            LIKE aag_file.aag01,
#          l_aag01_str        LIKE type_file.chr50,
#          sr1                RECORD
#                             aag01    LIKE aag_file.aag01,
#                             aag02    LIKE aag_file.aag02,
#                             aag13    LIKE aag_file.aag13,
#                             aag24    LIKE aag_file.aag24
#                             END RECORD,
#          sr                 RECORD
#                             aah01     LIKE aah_file.aah01,
#                             aag02     LIKE aag_file.aag02,
#                             aag24     LIKE aag_file.aag24,
#                             abb24     LIKE abb_file.abb24, #No.FUN-A30008
#                             nc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
#                             nc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
#                             nc_aah04  LIKE aah_file.aah04, #No.FUN-A30008        
#                             nc_aah05  LIKE aah_file.aah05, #No.FUN-A30008
#                             qc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
#                             qc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
#                             qc_aah04  LIKE aah_file.aah04, 
#                             qc_aah05  LIKE aah_file.aah05, 
#                             qj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
#                             qj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
#                             qj_aah04  LIKE aah_file.aah04,
#                             qj_aah05  LIKE aah_file.aah05,
#                             qm_tah09  LIKE tah_file.tah09, #No.FUN-A30008
#                             qm_tah10  LIKE tah_file.tah10, #No.FUN-A30008
#                             qm_aah04  LIKE aah_file.aah04, 
#                             qm_aah05  LIKE aah_file.aah05,
#                             lj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
#                             lj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
#                             lj_aah04  LIKE aah_file.aah04, #No.FUN-A30008
#                             lj_aah05  LIKE aah_file.aah05  #No.FUN-A30008
#                             END RECORD
# 
#     CALL gglq305_table()
#     SELECT zo02 INTO g_company FROM zo_file
#      WHERE zo01 = g_rlang
#     #科目
#     LET l_sql = " SELECT aag01,aag02,aag13,aag24 FROM aag_file ",
#                 "  WHERE aag00 = '",tm.bookno,"'",
#                 "    AND aag03 = '2' "              #帳戶
#     IF tm.c = '1' THEN   #一級科目&統治科目
#        LET l_sql = l_sql CLIPPED,
#                    "  AND (aag07 = '1' AND aag24 = 1 OR aag07 = '3' ) "
#     END IF
#   
#     PREPARE gglq305_aag01_p FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('prepare gglq305_aag01_p',SQLCA.sqlcode,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM
#     END IF
#     DECLARE gglq305_aag01_cs CURSOR FOR gglq305_aag01_p
# 
#     #共用條件 aah_file
#     LET l_aah = " SELECT SUM(aah04),SUM(aah05) FROM aah_file",
#                 "  WHERE aah00 = '",tm.bookno,"'",
#                 "    AND aah01 = ?",
#                 "    AND aah02 =  ",tm.yy
#     #共用條件 abb_file
#     LET l_abb = " SELECT SUM(abb07) FROM aba_file,abb_file",
#                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#                 "    AND aba00 = '",tm.bookno,"'",
#                 "    AND aba03 =  ",tm.yy,
#                 "    AND abb03 LIKE ? ",
#                 "    AND abb06 = ?",
#                 "    AND aba19 = 'Y' AND abapost = 'N' "
# 
#     #期初(1)-aah_file
#     LET l_sql = l_aah CLIPPED, " AND aah03 < ",tm.m1
#     PREPARE gglq305_qc_p1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('gglq305_qc_p1',SQLCA.sqlcode,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM
#     END IF
#     DECLARE gglq305_qc_cs1 CURSOR FOR gglq305_qc_p1
#     
#     #期初(2)-abb_file & tm.a = 'Y'
#     LET l_sql = l_abb CLIPPED," AND aba04 < ",tm.m1
#     PREPARE gglq305_qc_p2 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('gglq305_qc_p2',SQLCA.sqlcode,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM
#     END IF
#     DECLARE gglq305_qc_cs2 CURSOR FOR gglq305_qc_p2
# 
#     #期間(1)-aah_file
#     LET l_sql = l_aah CLIPPED, " AND aah03 BETWEEN ",tm.m1," AND ",tm.m2
#     PREPARE gglq305_qj_p1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('gglq305_qj_p1',SQLCA.sqlcode,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM
#     END IF
#     DECLARE gglq305_qj_cs1 CURSOR FOR gglq305_qj_p1
# 
#     #期間(2)-abb_file
#     LET l_sql = l_abb CLIPPED, " AND aba04 BETWEEN ",tm.m1," AND ",tm.m2
#     PREPARE gglq305_qj_p2 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('gglq305_qj_p2',SQLCA.sqlcode,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM
#     END IF
#     DECLARE gglq305_qj_cs2 CURSOR FOR gglq305_qj_p2
# 
#     LET g_pageno  = 0
#     LET g_prog = 'gglr300'
#     CALL cl_outnam('gglr300') RETURNING l_name
#     START REPORT gglq305_rep TO l_name
# 
#     FOREACH gglq305_aag01_cs INTO sr1.*  #科目
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('gglq305_aag01_cs foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#        END IF
#        IF tm.b = 'Y' THEN LET sr1.aag02 = sr1.aag13 END IF
# 
#        #此作業也要打印統治科目的金額，但是abb中都存放得是明細或是獨立科目
#        #所以要用LIKE的方式，取出統治科目對應的明細科目的金額
#        #此作業的前提，明細科目的前幾碼一定和其上屬統治相同 ruled by 蔡曉峰
#        IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
#        LET l_aag01_str = sr1.aag01 CLIPPED,'\%'    #No.MOD-940388
# 
#        #期初值
#        LET l_aah041 = 0    LET l_aah051 = 0
#        LET l_aah042 = 0    LET l_aah052 = 0
#        OPEN gglq305_qc_cs1 USING sr1.aag01
#        FETCH gglq305_qc_cs1 INTO l_aah041,l_aah051
#        CLOSE gglq305_qc_cs1
#        IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
#        IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF
#        IF tm.a = 'Y' THEN
#           OPEN gglq305_qc_cs2 USING l_aag01_str,'1'
#           FETCH gglq305_qc_cs2 INTO l_aah042
#           CLOSE gglq305_qc_cs2
#           IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
#           OPEN gglq305_qc_cs2 USING l_aag01_str,'2'
#           FETCH gglq305_qc_cs2 INTO l_aah052
#           CLOSE gglq305_qc_cs2
#           IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
#        END IF
#        LET qc_aah04 = l_aah041 + l_aah042
#        LET qc_aah05 = l_aah051 + l_aah052
#        IF qc_aah04 > qc_aah05 THEN
#           LET sr.qc_aah04 = qc_aah04 - qc_aah05
#           LET sr.qc_aah05 = 0
#        ELSE
#           IF qc_aah04 < qc_aah05 THEN
#              LET sr.qc_aah04 = 0
#              LET sr.qc_aah05 = qc_aah05 - qc_aah04
#           ELSE
#              LET sr.qc_aah04 = 0
#              LET sr.qc_aah05 = 0
#           END IF
#        END IF
# 
#        #期間
#        LET l_aah041 = 0    LET l_aah051 = 0
#        LET l_aah042 = 0    LET l_aah052 = 0
#        OPEN gglq305_qj_cs1 USING sr1.aag01
#        FETCH gglq305_qj_cs1 INTO l_aah041,l_aah051
#        CLOSE gglq305_qj_cs1
#        IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
#        IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF
#        IF tm.a = 'Y' THEN
#           OPEN gglq305_qj_cs2 USING l_aag01_str,'1'
#           FETCH gglq305_qj_cs2 INTO l_aah042
#           CLOSE gglq305_qj_cs2
#           IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
#           OPEN gglq305_qj_cs2 USING l_aag01_str,'2'
#           FETCH gglq305_qj_cs2 INTO l_aah052
#           CLOSE gglq305_qj_cs2
#           IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
#        END IF
#        LET sr.qj_aah04 = l_aah041 + l_aah042
#        LET sr.qj_aah05 = l_aah051 + l_aah052
# 
#        IF sr.qc_aah04 = 0 AND sr.qc_aah05 = 0 AND
#           sr.qj_aah04 = 0 AND sr.qj_aah05 = 0 THEN
#           CONTINUE FOREACH
#        END IF
# 
#        #期末
#        LET qm_aah04 = qc_aah04 + sr.qj_aah04
#        LET qm_aah05 = qc_aah05 + sr.qj_aah05
#        IF qm_aah04 > qm_aah05 THEN
#           LET sr.qm_aah04 = qm_aah04 - qm_aah05
#           LET sr.qm_aah05 = 0
#        ELSE
#           IF qm_aah04 < qm_aah05 THEN
#              LET sr.qm_aah04 = 0
#              LET sr.qm_aah05 = qm_aah05 - qm_aah04
#           ELSE
#              LET sr.qm_aah04 = 0
#              LET sr.qm_aah05 = 0
#           END IF
#        END IF
#        LET sr.aah01 = sr1.aag01
#        LET sr.aag02 = sr1.aag02
#        LET sr.aag24 = sr1.aag24
#        OUTPUT TO REPORT gglq305_rep(sr.*)
#     END FOREACH
#     FINISH REPORT gglq305_rep
#END FUNCTION
FUNCTION gglq305()
   DEFINE l_name             LIKE type_file.chr20,
          #l_sql              LIKE type_file.chr1000,
          l_sql              STRING,      #NO.FUN-910082
          l_aao              LIKE type_file.chr1000,
          l_i                LIKE type_file.num5,
          l_aah              LIKE type_file.chr1000,
          l_abb              LIKE type_file.chr1000,
          l_tah              LIKE type_file.chr1000,
          l_sql1             LIKE type_file.chr1000,
          l_sql2             LIKE type_file.chr1000,
          qc_aah04           LIKE aah_file.aah04,  #期初
          qc_aah05           LIKE aah_file.aah05,
          qm_aah04           LIKE aah_file.aah04,  #期末
          qm_aah05           LIKE aah_file.aah05,
          lj_aah04           LIKE aah_file.aah04,  #累计
          lj_aah05           LIKE aah_file.aah05,
          nc_aah04           LIKE aah_file.aah04,  #年初
          nc_aah05           LIKE aah_file.aah05,     
          qc_tah09           LIKE tah_file.tah09,  #期初
          qc_tah10           LIKE tah_file.tah10,
          qj_tah09           LIKE tah_file.tah09,  #期初
          qj_tah10           LIKE tah_file.tah10,
          qm_tah09           LIKE tah_file.tah09,  #期末
          qm_tah10           LIKE tah_file.tah10,
          lj_tah09           LIKE tah_file.tah09,  #累计
          lj_tah10           LIKE tah_file.tah10,
          nc_tah09           LIKE tah_file.tah09,  #年初
          nc_tah10           LIKE tah_file.tah10,       
          l_tah091           LIKE tah_file.tah09,
          l_tah101           LIKE tah_file.tah10,
          l_tah092           LIKE tah_file.tah09,
          l_tah102           LIKE tah_file.tah10,                  
          l_aah041           LIKE aah_file.aah04,
          l_aah051           LIKE aah_file.aah05,
          l_aah042           LIKE aah_file.aah04,
          l_aah052           LIKE aah_file.aah05,
          l_aag01            LIKE aag_file.aag01,
          l_aag01_str        LIKE type_file.chr50,
          l_t                LIKE type_file.chr50,
          l_curr             DYNAMIC ARRAY OF LIKE azi_file.azi01,
          sr1                RECORD
                             aag01    LIKE aag_file.aag01,
                             aag02    LIKE aag_file.aag02,
                             aag06    LIKE aag_file.aag06,  #TQC-CC0122 add
                             aag13    LIKE aag_file.aag13,
                             aag24    LIKE aag_file.aag24
                             END RECORD,
          sr                 RECORD
                             aah01     LIKE aah_file.aah01,
                             aag02     LIKE aag_file.aag02,
                             aag24     LIKE aag_file.aag24,
                             abb24     LIKE abb_file.abb24, #No.FUN-A30008
                             nc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             nc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             nc_aah04  LIKE aah_file.aah04, #No.FUN-A30008        
                             nc_aah05  LIKE aah_file.aah05, #No.FUN-A30008
                             qc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             qc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             qc_aah04  LIKE aah_file.aah04, 
                             qc_aah05  LIKE aah_file.aah05, 
                             qj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             qj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             qj_aah04  LIKE aah_file.aah04,
                             qj_aah05  LIKE aah_file.aah05,
                             qm_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             qm_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             qm_aah04  LIKE aah_file.aah04, 
                             qm_aah05  LIKE aah_file.aah05,
                             lj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             lj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             lj_aah04  LIKE aah_file.aah04, #No.FUN-A30008
                             lj_aah05  LIKE aah_file.aah05  #No.FUN-A30008
                             END RECORD
     DEFINE  l_msg           STRING    #FUN-C80092

#FUN-C80092 -----------Begin-------------
     LET l_msg = "tm.bookno = '",tm.bookno,"'",";","tm.yy = '",tm.yy,"'",";","tm.m1 = '",tm.m1,"'",";",
                 "tm.m2 = '",tm.m2,"'",";","tm.a = '",tm.a,"'",";","tm.b = '",tm.b,"'",";","tm.lvl = '",tm.lvl,"'"
,";",
                 "tm.d = '",tm.d,"'",";","tm.e = '",tm.e,"'",";","tm.f = '",tm.f,"'",";","tm.g = '",tm.g,"'",";",
                 "tm.h = '",tm.h,"'"
     CALL s_log_ins(g_prog,'','',tm.wc,l_msg)
          RETURNING g_cka00
#FUN-C80092 -----------End--------------
     CALL gglq305_table()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
     #科目
     LET tm.wc = cl_replace_str(tm.wc,"aah01","aag01")      #FUN-C80102 add
     LET l_sql = " SELECT aag01,aag02,aag06,aag13,aag24 FROM aag_file ",   #TQC-CC0122 add aag06
                 "  WHERE aag00 = '",tm.bookno,"'",
                 "    AND aag03 = '2' ",              #帳戶
                 "  AND ",tm.wc CLIPPED 
     #No.FUN-A40020  --Begin
     #IF tm.c = '1' THEN   #一級科目&統治科目
     #   LET l_sql = l_sql CLIPPED,
     #               "  AND (aag07 = '1' AND aag24 = 1 OR aag07 = '3' ) "
     #END IF
     IF cl_null(tm.lvl) THEN LET tm.lvl = 99 END IF                             
     IF NOT cl_null(tm.lvl) THEN                                                
        LET l_sql = l_sql CLIPPED,                                              
                    "  AND aag24 <= ",tm.lvl                                    
     END IF 
     #No.FUN-A40020  --End  

     #No.FUN-C70061--add--str
     IF tm.h = 'N' THEN 
        LET l_sql = l_sql CLIPPED,
                    "  AND aag07 <> '1' "
     END IF 
     #No.FUN-C70061--add--end

     PREPARE gglq305_aag01_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('prepare gglq305_aag01_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_aag01_cs CURSOR FOR gglq305_aag01_p
                      
     #共用條件 aah_file
     LET l_aah = " SELECT SUM(aah04),SUM(aah05) FROM aah_file",
                 "  WHERE aah00 = '",tm.bookno,"'",
                 "    AND aah01 = ?",
                 "    AND aah02 =  ",tm.yy
     #共用條件 abb_file
     LET l_abb = " SELECT SUM(abb07),sum(abb07f) FROM aba_file,abb_file",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",tm.bookno,"'",
                 "    AND aba03 =  ",tm.yy,
                 "    AND abb03 LIKE ? ",
                 "    AND abb06 = ?",
                 "    AND aba19 <> 'X' ",   #CHI-C80041
                 "    AND abaacti = 'Y' "  #FUN-D10072--130123
                #"    AND aba19 = 'Y' AND abapost = 'N' "    #FUN-C90029 mark
                #"    AND abapost = 'N' "                    #FUN-C90029 #FUN-C80102 mark

#FUN-D10072--130123--mod
#    #FUN-C80102-----add---str---
#    IF tm.i = 'Y' THEN
#       LET l_abb = l_abb CLIPPED
#    ELSE
#       #單據性質為全部(包括：已確認已過帳 和 已確認未過帳)
#       IF tm.a = '1' THEN
#          LET l_abb = l_abb CLIPPED,"  AND aba19 = 'Y' "
#       END IF
#       #單據性質為已過帳
#       IF tm.a = '2' THEN
#          LET l_abb = l_abb CLIPPED,"  AND abapost = 'Y' "
#       END IF
#    END IF
#    #FUN-C80102-----add---end---
     #IF tm.i = 'Y' THEN
     #   IF tm.a = '1' THEN
     #      LET l_abb = l_abb CLIPPED," AND ( aba19 = 'N' OR ( aba19 = 'Y' AND abapost = 'N'))"
     #   ELSE
     #      LET l_abb = l_abb CLIPPED," AND aba19 = 'N' "
     #   END IF
     #ELSE
     #   IF tm.a = '1' THEN
     #      LET l_abb = l_abb CLIPPED," AND (aba19 = 'Y' AND abapost = 'N') "
     #   ELSE
     #      LET l_abb = l_abb CLIPPED," AND aba19 = 1 "
     #   END IF
     #END IF
#FUN-D10072--130123--mod
     
     #FUN-D40121--mark--str-131115-
     #No.MOD-D30190  --Begin
#    IF tm.a = '2' THEN
#        LET l_abb = l_abb CLIPPED," AND abapost = 'N' "
#    END IF  
     #No.MOD-D30190  --End        
     #No.FUN-C90029  --Begin
#    IF tm.i = 'N' THEN
#       LET l_abb = l_abb CLIPPED," AND aba19 = 'Y' "
#    END IF
     #No.FUN-C90029  --End
     #FUN-D40121--mark--end--
     
     #FUN-D40121--add--str-131115-
     IF tm.i = 'Y' THEN
        IF tm.a = '1' THEN
           LET l_abb = l_abb CLIPPED," AND ( aba19 = 'N' OR ( aba19 = 'Y' AND abapost = 'N'))"
        ELSE
           LET l_abb = l_abb CLIPPED," AND aba19 = 'N' "
        END IF
     ELSE
        IF tm.a = '1' THEN
           LET l_abb = l_abb CLIPPED," AND (aba19 = 'Y' AND abapost = 'N') "
        ELSE
           LET l_abb = l_abb CLIPPED," AND aba19 = 1 "
        END IF
     END IF
     #FUN-D40121--add--end--
     #期初(1)-aah_file
     LET l_sql = l_aah CLIPPED, " AND aah03 < ",tm.m1
     PREPARE gglq305_qc_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('gglq305_qc_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_qc_cs1 CURSOR FOR gglq305_qc_p1
     
     #期初(2)-abb_file & tm.a = 'Y'
     LET l_sql = l_abb CLIPPED," AND aba04 < ",tm.m1
     PREPARE gglq305_qc_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('gglq305_qc_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_qc_cs2 CURSOR FOR gglq305_qc_p2
     #原币期初-异动
     LET l_sql=l_abb CLIPPED," AND aba04 < ",tm.m1," AND abb24= ? "
     PREPARE gglq305_ybqc_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('gglq305_qc_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_ybqc_cs2 CURSOR FOR gglq305_ybqc_p2
     #本年累计
     LET l_sql=l_aah CLIPPED," AND aah03<= ",tm.m2
     PREPARE gglq305_lj_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('gglq305_qc_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_lj_cs CURSOR FOR gglq305_lj_p
     #本年累计(2)
     LET l_sql=l_abb CLIPPED," AND aba04<= ",tm.m2
     PREPARE gglq305_lj_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('gglq305_qc_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_lj_cs2 CURSOR FOR gglq305_lj_p2     
     #期間(1)-aah_file
     LET l_sql = l_aah CLIPPED, " AND aah03 BETWEEN ",tm.m1," AND ",tm.m2
     PREPARE gglq305_qj_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('gglq305_qj_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_qj_cs1 CURSOR FOR gglq305_qj_p1
 
     #期間(2)-abb_file
     LET l_sql = l_abb CLIPPED, " AND aba04 BETWEEN ",tm.m1," AND ",tm.m2
     PREPARE gglq305_qj_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('gglq305_qj_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_qj_cs2 CURSOR FOR gglq305_qj_p2
     #原币期间-异动
     LET l_sql = l_abb CLIPPED, " AND aba04 BETWEEN ",tm.m1," AND ",tm.m2," AND abb24= ? "
     PREPARE gglq305_ybqj_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('gglq305_qj_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_ybqj_cs2 CURSOR FOR gglq305_ybqj_p2
     #原币本年累计-异动
     LET l_sql = l_abb CLIPPED, " AND aba04 <= ",tm.m2," AND abb24= ? "
     PREPARE gglq305_yblj_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('gglq305_qj_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_yblj_cs2 CURSOR FOR gglq305_yblj_p2          
     #foreach幣別
     LET l_sql1 = " SELECT UNIQUE tah08 FROM tah_file WHERE tah00='",tm.bookno,"' ",
                 "   AND tah01 LIKE ? AND tah02='",tm.yy,"' "
    #FUN-C80102---mark--str--
    #IF NOT cl_null(tm.e) THEN 
    #   LET l_sql1=l_sql1 CLIPPED," AND tah08='",tm.e,"' "
    #END IF 
    #FUN-C80102---mark--end--
    #IF tm.a='Y' THEN    #FUN-C80102 mark 
     IF tm.a='1' THEN    #FUN-C80102 add  
        LET l_sql1 = l_sql1 CLIPPED," UNION SELECT UNIQUE abb24 FROM aba_file,abb_file",
                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                   "    AND aba00 = '",tm.bookno,"'",
                   "    AND aba03 = ",tm.yy,
                   "    AND abaacti='Y' ",
                   "    AND abb03 LIKE ? ",
                   "    AND aba19 <> 'X' "   #CHI-C80041   
       #FUN-C80102----mark---str---                         
       #IF NOT cl_null(tm.e) THEN
       #   LET l_sql1 = l_sql1 CLIPPED," AND abb24 = '",tm.e,"'"
       #END IF             
       #FUN-C80102----mark---end---          
     ELSE 
        #以下寫法,是為了不因為tm.a='Y'或是'N',分兩種using參數個數     	
     	  LET l_sql1=l_sql1 CLIPPED," AND 1= ? "               
     END IF    
     
     PREPARE gglq305_abb24_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('prepare gglq305_abb24_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_abb24_cs CURSOR FOR gglq305_abb24_p
     
     LET l_tah=" SELECT SUM(tah04),sum(tah05),SUM(tah09),SUM(tah10) FROM tah_file ",
                " WHERE tah00='",tm.bookno,"' AND tah01= ? AND tah02='",tm.yy,"' ",
                " AND tah08= ? "
     #原币期初
     LET l_sql2=l_tah CLIPPED," AND tah03< ",tm.m1           
     PREPARE gglq305_ybqc_p FROM l_sql2
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('prepare gglq305_abb24_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_ybqc_cs CURSOR FOR gglq305_ybqc_p      
     #原币期间
     LET l_sql2=l_tah CLIPPED," AND tah03 BETWEEN ",tm.m1," AND ",tm.m2  
     PREPARE gglq305_ybqj_p FROM l_sql2
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('prepare gglq305_ybqj_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_ybqj_cs CURSOR FOR gglq305_ybqj_p     
     #原币本年累计
     LET l_sql2=l_tah CLIPPED," AND tah03 <= ",tm.m2
     PREPARE gglq305_yblj_p FROM l_sql2
     IF SQLCA.sqlcode != 0 THEN
        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
        CALL cl_err('prepare gglq305_yblj_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq305_yblj_cs CURSOR FOR gglq305_yblj_p                                      
     LET g_pageno  = 0
     LET g_prog = 'gglr300'
     CALL cl_outnam('gglr300') RETURNING l_name
#No.TQC-B30153 --begin
     LET g_qc_aah04 = 0
     LET g_qc_aah05 = 0
     LET g_qj_aah04 = 0
     LET g_qj_aah05 = 0
     LET g_qm_aah04 = 0
     LET g_qm_aah05 = 0
     LET g_nc_aah04 = 0
     LET g_nc_aah05 = 0
     LET g_lj_aah04 = 0
     LET g_lj_aah05 = 0
#No.TQC-B30153 --end
     START REPORT gglq305_rep TO l_name
 
     FOREACH gglq305_aag01_cs INTO sr1.*  #科目
        IF SQLCA.sqlcode THEN
           CALL cl_err('gglq305_aag01_cs foreach:',SQLCA.sqlcode,0) EXIT FOREACH
        END IF
        INITIALIZE sr.* TO NULL  #MOD-C80198
        IF tm.b = 'Y' THEN LET sr1.aag02 = sr1.aag13 END IF
 
        #此作業也要打印統治科目的金額，但是abb中都存放得是明細或是獨立科目
        #所以要用LIKE的方式，取出統治科目對應的明細科目的金額
        #此作業的前提，明細科目的前幾碼一定和其上屬統治相同 ruled by 蔡曉峰
        IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr1.aag01 CLIPPED,'\%'    #No.MOD-940388
        #本币年初值-抓取本年第0期值
        SELECT aah04,aah05 INTO sr.nc_aah04,sr.nc_aah05 FROM aah_file 
         WHERE aah00=tm.bookno AND aah01=sr1.aag01 
           AND aah02=tm.yy AND aah03=0 
        IF cl_null(sr.nc_aah04) THEN LET sr.nc_aah04=0 END IF 
        IF cl_null(sr.nc_aah05) THEN LET sr.nc_aah05=0 END IF
        #期初值
        LET l_aah041 = 0    LET l_aah051 = 0
        LET l_aah042 = 0    LET l_aah052 = 0
        OPEN gglq305_qc_cs1 USING sr1.aag01
        FETCH gglq305_qc_cs1 INTO l_aah041,l_aah051
        CLOSE gglq305_qc_cs1
        IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
        IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF
       #IF tm.a = 'Y' THEN  #FUN-C80102 mark
#FUN-D10072--130123-remark
        #TQC-CC0122--mark--str--
        #IF tm.a='1' THEN    #FUN-C80102 add
            OPEN gglq305_qc_cs2 USING l_aag01_str,'1'
            FETCH gglq305_qc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq305_qc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            OPEN gglq305_qc_cs2 USING l_aag01_str,'2'
            FETCH gglq305_qc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq305_qc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
        #END IF
        #TQC-CC0122--mark--end--
#FUN-D10072--130123-remark
       
        LET qc_aah04 = l_aah041 + l_aah042
        LET qc_aah05 = l_aah051 + l_aah052
        IF qc_aah04 > qc_aah05 THEN  #MOD-DB0015 remark
       #IF sr1.aag06 = '1' THEN   #TQC-CC0122 add  #MOD-DB0015 mark
           LET sr.qc_aah04 = qc_aah04 - qc_aah05
           LET sr.qc_aah05 = 0
        ELSE
           IF qc_aah04 < qc_aah05 THEN   #MOD-DB0015 remark
          #IF sr1.aag06 = '2' THEN   #TQC-CC0122 add    #MOD-DB0015 mark
              LET sr.qc_aah04 = 0
              LET sr.qc_aah05 = qc_aah05 - qc_aah04
           ELSE
              LET sr.qc_aah04 = 0
              LET sr.qc_aah05 = 0
           END IF
        END IF
 
        #期間
        LET l_aah041 = 0    LET l_aah051 = 0
        LET l_aah042 = 0    LET l_aah052 = 0
        OPEN gglq305_qj_cs1 USING sr1.aag01
        FETCH gglq305_qj_cs1 INTO l_aah041,l_aah051
        CLOSE gglq305_qj_cs1
        IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
        IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF
       #IF tm.a = 'Y' THEN  #FUN-C80102 mark
#FUN-D10072--130123-remark
        #TQC-CC0122--mark--str--
        #IF tm.a='1' THEN    #FUN-C80102 add
            OPEN gglq305_qj_cs2 USING l_aag01_str,'1'
            FETCH gglq305_qj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq305_qj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            OPEN gglq305_qj_cs2 USING l_aag01_str,'2'
            FETCH gglq305_qj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq305_qj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
        #END IF
        #TQC-CC0122--mark--end--
#FUN-D10072--130123-remark
        LET sr.qj_aah04 = l_aah041 + l_aah042
        LET sr.qj_aah05 = l_aah051 + l_aah052

        #mark by sunyan 210413---s 
        #IF sr.qc_aah04 = 0 AND sr.qc_aah05 = 0 AND
        #   sr.qj_aah04 = 0 AND sr.qj_aah05 = 0 THEN
        #   CONTINUE FOREACH
        #END IF
        #mark by sunyan 210413---e 

        #期末
        LET qm_aah04 = qc_aah04 + sr.qj_aah04
        LET qm_aah05 = qc_aah05 + sr.qj_aah05
        LET sr.qm_aah04 = qm_aah04
        LET sr.qm_aah05 = qm_aah05
       IF qm_aah04 > qm_aah05 THEN    #MOD-DB0015 remark
      #IF sr1.aag06 = '1' THEN   #TQC-CC0122 add   #MOD-DB0015 mark
           LET sr.qm_aah04 = qm_aah04 - qm_aah05
           LET sr.qm_aah05 = 0
        ELSE
          IF qm_aah04 < qm_aah05 THEN #MOD-DB0015 remark
         #IF sr1.aag06 = '2' THEN   #TQC-CC0122 add #MOD-DB0015 mark
              LET sr.qm_aah04 = 0
              LET sr.qm_aah05 = qm_aah05 - qm_aah04
           ELSE
              LET sr.qm_aah04 = 0
              LET sr.qm_aah05 = 0
           END IF
        END IF

        #本年累计
        LET l_aah041=0 LET l_aah051=0
        LET l_aah042=0 LET l_aah052=0
        OPEN gglq305_lj_cs USING sr1.aag01
        FETCH gglq305_lj_cs INTO l_aah041,l_aah051
        IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
        IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF
        CLOSE gglq305_lj_cs
       #IF tm.a='Y' THEN    #FUN-C80102 mark
#FUN-D10072--130123-remark
        #TQC-CC0122--mark--str--
        #IF tm.a='1' THEN    #FUN-C80102 add
            OPEN gglq305_lj_cs2 USING l_aag01_str,'1'
            FETCH gglq305_lj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq305_lj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            OPEN gglq305_lj_cs2 USING l_aag01_str,'2'
            FETCH gglq305_lj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq305_lj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
        #END IF 
        #TQC-CC0122--mark--str--
#FUN-D10072--130123-remark
        LET lj_aah04=l_aah041+l_aah042
        LET lj_aah05=l_aah051+l_aah052

        LET sr.lj_aah04 = lj_aah04  #TQC-CC0122 add
        LET sr.lj_aah05 = lj_aah05  #TQC-CC0122 add
     
       #add by sunyan 210413---s
        IF sr.lj_aah04 = 0 AND sr.lj_aah05 = 0 AND sr.qc_aah04 = 0 AND sr.qc_aah05 = 0 AND
           sr.qj_aah04 = 0 AND sr.qj_aah05 = 0 AND sr.qm_aah04 = 0 AND sr.qm_aah05 = 0 AND
           sr.nc_aah04 = 0 AND sr.nc_aah05 = 0 THEN
           CONTINUE FOREACH
        END IF
        #add by sunyan 210413---e 
       #TQC-CC0122----mark---str--
       #IF lj_aah04 > lj_aah05 THEN
       #   LET sr.lj_aah04 = lj_aah04 - lj_aah05
       #   LET sr.lj_aah05 = 0
       #ELSE
       #   IF lj_aah04 < lj_aah05 THEN
       #      LET sr.lj_aah04 = 0
       #      LET sr.lj_aah05 = lj_aah05 - lj_aah04
       #   ELSE
       #      LET sr.lj_aah04 = 0
       #      LET sr.lj_aah05 = 0
       #   END IF
       #END IF
       #TQC-CC0122----mark---end--
        LET sr.aah01 = sr1.aag01
        LET sr.aag02 = sr1.aag02
        LET sr.aag24 = sr1.aag24

        IF tm.d='N' THEN 
           IF cl_null(sr.nc_tah09) THEN LET sr.nc_tah09=0 END IF 
           IF cl_null(sr.nc_tah10) THEN LET sr.nc_tah10=0 END IF 
           #FUN-C80102----add---str--
           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = sr.abb24     #原幣
           SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17  #本幣
           LET sr.nc_tah09 = cl_digcut(sr.nc_tah09,t_azi04)   #原幣
           LET sr.nc_tah10 = cl_digcut(sr.nc_tah10,t_azi04)
           LET sr.nc_aah04 = cl_digcut(sr.nc_aah04,g_azi04)   #本幣
           LET sr.nc_aah05 = cl_digcut(sr.nc_aah05,g_azi04)
           LET sr.qc_tah09 = cl_digcut(sr.qc_tah09,t_azi04)
           LET sr.qc_tah10 = cl_digcut(sr.qc_tah10,t_azi04)
           LET sr.qc_aah04 = cl_digcut(sr.qc_aah04,g_azi04)
           LET sr.qc_aah05 = cl_digcut(sr.qc_aah05,g_azi04)
           LET sr.qj_tah09 = cl_digcut(sr.qj_tah09,t_azi04)
           LET sr.qj_tah10 = cl_digcut(sr.qj_tah10,t_azi04)
           LET sr.qj_aah04 = cl_digcut(sr.qj_aah04,g_azi04)
           LET sr.qj_aah05 = cl_digcut(sr.qj_aah05,g_azi04)
           LET sr.qm_tah09 = cl_digcut(sr.qm_tah09,t_azi04)
           LET sr.qm_tah10 = cl_digcut(sr.qm_tah10,t_azi04)
           LET sr.qm_aah04 = cl_digcut(sr.qm_aah04,g_azi04)
           LET sr.qm_aah05 = cl_digcut(sr.qm_aah05,g_azi04)
           LET sr.lj_tah09 = cl_digcut(sr.lj_tah09,t_azi04)
           LET sr.lj_tah10 = cl_digcut(sr.lj_tah10,t_azi04)
           LET sr.lj_aah04 = cl_digcut(sr.lj_aah04,g_azi04)
           LET sr.lj_aah05 = cl_digcut(sr.lj_aah05,g_azi04)
           #FUN-C80102----add---end--
           OUTPUT TO REPORT gglq305_rep(sr.*)
           CONTINUE FOREACH 
        END IF 
        LET l_i = 1
        #抓取币种--根据币种抓取对应的原币及本币金额
       #IF tm.a='Y' THEN    #FUN-C80102 mark 
        IF tm.a='1' THEN    #FUN-C80102 add
           LET l_t=l_aag01_str
        ELSE 
        	 LET l_t=1
        END IF 
        FOREACH gglq305_abb24_cs USING l_aag01_str,l_t INTO l_curr[l_i]
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq305_abb24_cs',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           
           #原币，本币年初余额
           SELECT tah09,tah10 INTO sr.nc_tah09,sr.nc_tah10 FROM tah_file WHERE tah00=tm.bookno
              AND tah01=sr1.aag01 AND tah02=tm.yy AND tah03=0 AND tah08=l_curr[l_i]
           IF cl_null(sr.nc_tah09) THEN LET sr.nc_tah09=0 END IF 
           IF cl_null(sr.nc_tah10) THEN LET sr.nc_tah10=0 END IF
           SELECT tah04,tah05 INTO sr.nc_aah04,sr.nc_aah05 FROM tah_file WHERE tah00=tm.bookno
              AND tah01=sr1.aag01 AND tah02=tm.yy AND tah03=0 AND tah08=l_curr[l_i]
           IF cl_null(sr.nc_aah04) THEN LET sr.nc_aah04=0 END IF 
           IF cl_null(sr.nc_aah05) THEN LET sr.nc_aah05=0 END IF
           #原币，本币期初
           LET l_aah041=0   LET l_aah051=0
           LET l_aah042=0   LET l_aah052=0
           LET l_tah091=0   LET l_tah101=0
           LET l_tah092=0   LET l_tah102=0
           OPEN gglq305_ybqc_cs USING sr1.aag01,l_curr[l_i]
           FETCH gglq305_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
           CLOSE gglq305_ybqc_cs
           IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
           IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
           IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
           IF cl_null(l_tah101) THEN LET l_tah101=0 END IF            
          #IF tm.a = 'Y' THEN  #FUN-C80102 mark
#FUN-D10072--130123-remark
           #TQC-CC0122--mark--str--
           #IF tm.a='1' THEN    #FUN-C80102 add 
               OPEN gglq305_ybqc_cs2 USING l_aag01_str,'1',l_curr[l_i]
               FETCH gglq305_ybqc_cs2 INTO l_aah042,l_tah092
               CLOSE gglq305_ybqc_cs2
               IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
               IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
               OPEN gglq305_ybqc_cs2 USING l_aag01_str,'2',l_curr[l_i]
               FETCH gglq305_ybqc_cs2 INTO l_aah052,l_tah102
               CLOSE gglq305_ybqc_cs2
               IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
               IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF
           #END IF
           #TQC-CC0122--mark--end--
#FUN-D10072--130123-remark
           LET qc_aah04 = l_aah041 + l_aah042
           LET qc_aah05 = l_aah051 + l_aah052
           IF qc_aah04 > qc_aah05 THEN    #MOD-DB0015 remark
          #IF sr1.aag06 = '1' THEN  #TQC-CC0122 add   #MOD-DB0015 mark
              LET sr.qc_aah04 = qc_aah04 - qc_aah05
              LET sr.qc_aah05 = 0
           ELSE
              IF qc_aah04 < qc_aah05 THEN   #MOD-DB0015 remark
             #IF sr1.aag06 = '2' THEN  #TQC-CC0122 add  #MOD-DB0015 mark
                 LET sr.qc_aah04 = 0
                 LET sr.qc_aah05 = qc_aah05 - qc_aah04
              ELSE
                 LET sr.qc_aah04 = 0
                 LET sr.qc_aah05 = 0
              END IF
           END IF           
           LET qc_tah09 = l_tah091 + l_tah092
           LET qc_tah10 = l_tah101 + l_tah102
           IF qc_tah09 > qc_tah10 THEN   #MOD-DB0015 remark
          #IF sr1.aag06 = '1' THEN  #TQC-CC0122 add   #MOD-DB0015 mark
              LET sr.qc_tah09 = qc_tah09 - qc_tah10
              LET sr.qc_tah10 = 0
           ELSE
              IF qc_tah09 < qc_tah10 THEN #MOD-DB0015 remark
             #IF sr1.aag06 = '2' THEN  #TQC-CC0122 add   #MOD-DB0015 mark
                 LET sr.qc_tah09 = 0
                 LET sr.qc_tah10 = qc_tah10 - qc_tah09
              ELSE
                 LET sr.qc_tah09 = 0
                 LET sr.qc_tah10 = 0
              END IF
           END IF
           #原币，本币期间
           LET l_aah041=0   LET l_aah051=0
           LET l_aah042=0   LET l_aah052=0           
           LET l_tah091=0   LET l_tah101=0
           LET l_tah092=0   LET l_tah102=0
           OPEN gglq305_ybqj_cs USING sr1.aag01,l_curr[l_i]
           FETCH gglq305_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
           CLOSE gglq305_ybqj_cs
           IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
           IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
           IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
           IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 
          #IF tm.a = 'Y' THEN  #FUN-C80102 mark
#FUN-D10072--130123-remark
           #TQC-CC0122--mark--str--
           #IF tm.a='1' THEN    #FUN-C80102 add
               OPEN gglq305_ybqj_cs2 USING l_aag01_str,'1',l_curr[l_i]
               FETCH gglq305_ybqj_cs2 INTO l_aah042,l_tah092
               CLOSE gglq305_ybqj_cs2
               IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
               IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
               OPEN gglq305_ybqj_cs2 USING l_aag01_str,'2',l_curr[l_i]
               FETCH gglq305_ybqj_cs2 INTO l_aah052,l_tah102
               CLOSE gglq305_ybqj_cs2
               IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
               IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF
           #END IF
           #TQC-CC0122--mark--end--
#FUN-D10072--130123-remark
           LET sr.qj_aah04 = l_aah041 + l_aah042
           LET sr.qj_aah05 = l_aah051 + l_aah052
           LET sr.qj_tah09 = l_tah091 + l_tah092
           LET sr.qj_tah10 = l_tah101 + l_tah102
#           IF sr.qc_aah04 = 0 AND sr.qc_aah05 = 0 AND
#              sr.qj_aah04 = 0 AND sr.qj_aah05 = 0 AND 
#              sr.qc_tah09 = 0 AND sr.qc_tah10 = 0 AND 
#              sr.qj_tah09 = 0 AND sr.qj_tah10 = 0 THEN
#              CONTINUE FOREACH
#           END IF        
   
#           LET qj_aah04 = l_aah041 + l_aah042
#           LET qj_aah05 = l_aah051 + l_aah052
#           IF qj_aah04 > qj_aah05 THEN
#              LET sr.qj_aah04 = qj_aah04 - qj_aah05
#              LET sr.qj_aah05 = 0
#           ELSE
#              IF qj_aah04 < qj_aah05 THEN
#                 LET sr.qj_aah04 = 0
#                 LET sr.qj_aah05 = qj_aah05 - qj_aah04
#              ELSE
#                 LET sr.qj_aah04 = 0
#                 LET sr.qj_aah05 = 0
#              END IF
#           END IF                      
#           LET qj_tah09 = l_tah091 + l_tah092
#           LET qj_tah10 = l_tah101 + l_tah102
#           IF qj_tah09 > qj_tah10 THEN
#              LET sr.qj_tah09 = qj_tah09 - qj_tah10
#              LET sr.qj_tah10 = 0
#           ELSE
#              IF qj_tah09 < qj_tah10 THEN
#                 LET sr.qj_tah09 = 0
#                 LET sr.qj_tah10 = qj_tah10 - qj_tah09
#              ELSE
#                 LET sr.qj_tah09 = 0
#                 LET sr.qj_tah10 = 0
#              END IF
#           END IF       
           #期末
           LET qm_tah09 = qc_tah09 + sr.qj_tah09
           LET qm_tah10 = qc_tah10 + sr.qj_tah10
           IF qm_tah09 > qm_tah10 THEN      #MOD-DB0015 remark
          #IF sr1.aag06 = '1' THEN  #TQC-CC0122 add   #MOD-DB0015 mark
              LET sr.qm_tah09 = qm_tah09 - qm_tah10
              LET sr.qm_tah10 = 0
           ELSE
              IF qm_tah09 < qm_tah10 THEN   #MOD-DB0015 remark
             #IF sr1.aag06 = '2' THEN  #TQC-CC0122 add #MOD-DB0015 mark
                 LET sr.qm_tah09 = 0
                 LET sr.qm_tah10 = qm_tah10 - qm_tah09
              ELSE
                 LET sr.qm_tah09 = 0
                 LET sr.qm_tah10 = 0
              END IF
           END IF     
           LET qm_aah04 = qc_aah04 + sr.qj_aah04
           LET qm_aah05 = qc_aah05 + sr.qj_aah05
           IF qm_aah04 > qm_aah05 THEN     #MOD-DB0015 remark
          #IF sr1.aag06 = '1' THEN  #TQC-CC0122 add  #MOD-DB0015 mark
              LET sr.qm_aah04 = qm_aah04 - qm_aah05
              LET sr.qm_aah05 = 0
           ELSE
              IF qm_aah04 < qm_aah05 THEN  #MOD-DB0015 remark
             #IF sr1.aag06 = '2' THEN  #TQC-CC0122 add  #MOD-DB0015 mark
                 LET sr.qm_aah04 = 0
                 LET sr.qm_aah05 = qm_aah05 - qm_aah04
              ELSE
                 LET sr.qm_aah04 = 0
                 LET sr.qm_aah05 = 0
              END IF
           END IF                
           LET sr.abb24= l_curr[l_i]   
           #原币,本币本年累计
           LET l_tah091=0   LET l_tah101=0
           LET l_tah092=0   LET l_tah102=0
           LET l_aah041=0   LET l_aah051=0
           LET l_aah042=0   LET l_aah052=0
           OPEN gglq305_yblj_cs USING sr1.aag01,l_curr[l_i]
           FETCH gglq305_yblj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
           IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
           IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
           IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
           IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 
           CLOSE gglq305_lj_cs
          #IF tm.a='Y' THEN    #FUN-C80102 mark 
#FUN-D10072--130123-remark
           #TQC-CC0122--mark--str--           
           #IF tm.a='1' THEN    #FUN-C80102 add 
               OPEN gglq305_yblj_cs2 USING l_aag01_str,'1',l_curr[l_i]
               FETCH gglq305_yblj_cs2 INTO l_aah042,l_tah092
               CLOSE gglq305_yblj_cs2
               IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
               IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
               OPEN gglq305_yblj_cs2 USING l_aag01_str,'2',l_curr[l_i]
               FETCH gglq305_yblj_cs2 INTO l_aah052,l_tah102
               CLOSE gglq305_yblj_cs2
               IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
               IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF
           #END IF 
           #TQC-CC0122--mark--end--
#FUN-D10072--130123-remark
           LET sr.lj_aah04=l_aah041+l_aah042
           LET sr.lj_aah05=l_aah051+l_aah052
           
#           IF lj_aah04 > lj_aah05 THEN
#              LET sr.lj_aah04 = lj_aah04 - lj_aah05
#              LET sr.lj_aah05 = 0
#           ELSE
#              IF lj_aah04 < lj_aah05 THEN
#                 LET sr.lj_aah04 = 0
#                 LET sr.lj_aah05 = lj_aah05 - lj_aah04
#              ELSE
#                 LET sr.lj_aah04 = 0
#                 LET sr.lj_aah05 = 0
#              END IF
#           END IF           
           LET sr.lj_tah09=l_tah091+l_tah092
           LET sr.lj_tah10=l_tah101+l_tah102
#           IF lj_tah09 > lj_tah10 THEN
#              LET sr.lj_tah09 = lj_tah09 - lj_tah10
#              LET sr.lj_tah10 = 0
#           ELSE
#              IF lj_tah09 < lj_tah10 THEN
#                 LET sr.lj_tah09 = 0
#                 LET sr.lj_tah10 = lj_tah10 - lj_tah09
#              ELSE
#                 LET sr.lj_tah09 = 0
#                 LET sr.lj_tah10 = 0
#              END IF
#           END IF
           
           #FUN-C80102----add---str--
           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = sr.abb24     #原幣
           SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17  #本幣
           LET sr.nc_tah09 = cl_digcut(sr.nc_tah09,t_azi04)   #原幣
           LET sr.nc_tah10 = cl_digcut(sr.nc_tah10,t_azi04)
           LET sr.nc_aah04 = cl_digcut(sr.nc_aah04,g_azi04)   #本幣
           LET sr.nc_aah05 = cl_digcut(sr.nc_aah05,g_azi04)
           LET sr.qc_tah09 = cl_digcut(sr.qc_tah09,t_azi04)
           LET sr.qc_tah10 = cl_digcut(sr.qc_tah10,t_azi04)
           LET sr.qc_aah04 = cl_digcut(sr.qc_aah04,g_azi04)
           LET sr.qc_aah05 = cl_digcut(sr.qc_aah05,g_azi04)
           LET sr.qj_tah09 = cl_digcut(sr.qj_tah09,t_azi04)
           LET sr.qj_tah10 = cl_digcut(sr.qj_tah10,t_azi04)
           LET sr.qj_aah04 = cl_digcut(sr.qj_aah04,g_azi04)
           LET sr.qj_aah05 = cl_digcut(sr.qj_aah05,g_azi04)
           LET sr.qm_tah09 = cl_digcut(sr.qm_tah09,t_azi04)
           LET sr.qm_tah10 = cl_digcut(sr.qm_tah10,t_azi04)
           LET sr.qm_aah04 = cl_digcut(sr.qm_aah04,g_azi04)
           LET sr.qm_aah05 = cl_digcut(sr.qm_aah05,g_azi04)
           LET sr.lj_tah09 = cl_digcut(sr.lj_tah09,t_azi04)
           LET sr.lj_tah10 = cl_digcut(sr.lj_tah10,t_azi04)
           LET sr.lj_aah04 = cl_digcut(sr.lj_aah04,g_azi04)
           LET sr.lj_aah05 = cl_digcut(sr.lj_aah05,g_azi04)
           #FUN-C80102----add---end--

           OUTPUT TO REPORT gglq305_rep(sr.*)
           LET l_i = l_i + 1
        END FOREACH
     END FOREACH
     FINISH REPORT gglq305_rep
END FUNCTION
#No.FUN-A30008--end 
REPORT gglq305_rep(sr)
   DEFINE l_last_sw          LIKE type_file.chr1,
          sr                 RECORD
                             aah01     LIKE aah_file.aah01,
                             aag02     LIKE aag_file.aag02,
                             aag24     LIKE aag_file.aag24,
                             abb24     LIKE abb_file.abb24, #No.FUN-A30008
                             nc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             nc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             nc_aah04  LIKE aah_file.aah04, #No.FUN-A30008        
                             nc_aah05  LIKE aah_file.aah05, #No.FUN-A30008
                             qc_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             qc_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             qc_aah04  LIKE aah_file.aah04, 
                             qc_aah05  LIKE aah_file.aah05, 
                             qj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             qj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             qj_aah04  LIKE aah_file.aah04,
                             qj_aah05  LIKE aah_file.aah05,
                             qm_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             qm_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             qm_aah04  LIKE aah_file.aah04, 
                             qm_aah05  LIKE aah_file.aah05,
                             lj_tah09  LIKE tah_file.tah09, #No.FUN-A30008
                             lj_tah10  LIKE tah_file.tah10, #No.FUN-A30008
                             lj_aah04  LIKE aah_file.aah04, #No.FUN-A30008
                             lj_aah05  LIKE aah_file.aah05  #No.FUN-A30008
                             END RECORD,
          qc_aah04           LIKE aah_file.aah04,
          qc_aah05           LIKE aah_file.aah05,
          qj_aah04           LIKE aah_file.aah04,
          qj_aah05           LIKE aah_file.aah05,
          qm_aah04           LIKE aah_file.aah04,
          qm_aah05           LIKE aah_file.aah05,
          #No.FUN-A30008--begin 
          nc_aah04           LIKE aah_file.aah04,
          nc_aah05           LIKE aah_file.aah05,
          lj_aah04           LIKE aah_file.aah04,
          lj_aah05           LIKE aah_file.aah05,
          nc_tah09           LIKE tah_file.tah09,
          nc_tah10           LIKE tah_file.tah10,
          qc_tah09           LIKE tah_file.tah09,
          qc_tah10           LIKE tah_file.tah10,
          qj_tah09           LIKE tah_file.tah09,
          qj_tah10           LIKE tah_file.tah10,
          qm_tah09           LIKE tah_file.tah09,
          qm_tah10           LIKE tah_file.tah10,
          lj_tah09           LIKE tah_file.tah09,
          lj_tah10           LIKE tah_file.tah10
          #No.FUN-A30008--end
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aah01
  FORMAT
   PAGE HEADER
      LET g_pageno = g_pageno + 1
      
   ON EVERY ROW
      INSERT INTO gglq305_tmp
      VALUES(sr.aah01,sr.aag02,'2','',sr.abb24,sr.nc_tah09,sr.nc_tah10,sr.nc_aah04,sr.nc_aah05,
             sr.qc_tah09,sr.qc_tah10,sr.qc_aah04,sr.qc_aah05,sr.qj_tah09,sr.qj_tah10,sr.qj_aah04,
             sr.qj_aah05,sr.qm_tah09,sr.qm_tah10,sr.qm_aah04,sr.qm_aah05,sr.lj_tah09,sr.lj_tah10,
             sr.lj_aah04,sr.lj_aah05)
#No.TQC-B30153 --begin
      IF cl_null(sr.qc_aah04) THEN LET sr.qc_aah04 = 0 END IF
      IF cl_null(sr.qc_aah05) THEN LET sr.qc_aah05 = 0 END IF
      IF cl_null(sr.qj_aah04) THEN LET sr.qj_aah04 = 0 END IF
      IF cl_null(sr.qj_aah05) THEN LET sr.qj_aah05 = 0 END IF
      IF cl_null(sr.qm_aah04) THEN LET sr.qm_aah04 = 0 END IF
      IF cl_null(sr.qm_aah05) THEN LET sr.qm_aah05 = 0 END IF
      IF cl_null(sr.nc_aah04) THEN LET sr.nc_aah04 = 0 END IF
      IF cl_null(sr.nc_aah05) THEN LET sr.nc_aah05 = 0 END IF
      IF cl_null(sr.lj_aah04) THEN LET sr.lj_aah04 = 0 END IF
      IF cl_null(sr.lj_aah05) THEN LET sr.lj_aah05 = 0 END IF 

      IF sr.aag24 ='1' THEN LET g_qc_aah04 = sr.qc_aah04 + g_qc_aah04 END IF
      IF sr.aag24 ='1' THEN LET g_qc_aah05 = sr.qc_aah05 + g_qc_aah05 END IF
      IF sr.aag24 ='1' THEN LET g_qj_aah04 = sr.qj_aah04 + g_qj_aah04 END IF
      IF sr.aag24 ='1' THEN LET g_qj_aah05 = sr.qj_aah05 + g_qj_aah05 END IF
      IF sr.aag24 ='1' THEN LET g_qm_aah04 = sr.qm_aah04 + g_qm_aah04 END IF
      IF sr.aag24 ='1' THEN LET g_qm_aah05 = sr.qm_aah05 + g_qm_aah05 END IF
      IF sr.aag24 ='1' THEN LET g_nc_aah04 = sr.nc_aah04 + g_nc_aah04 END IF
      IF sr.aag24 ='1' THEN LET g_nc_aah05 = sr.nc_aah05 + g_nc_aah05 END IF
      IF sr.aag24 ='1' THEN LET g_lj_aah04 = sr.lj_aah04 + g_lj_aah04 END IF
      IF sr.aag24 ='1' THEN LET g_lj_aah05 = sr.lj_aah05 + g_lj_aah05 END IF    
#No.TQC-B30153 --end              
   ON LAST ROW
      LET qc_aah04 = 0    LET qc_aah05 = 0
      LET qj_aah04 = 0    LET qj_aah05 = 0
      LET qm_aah04 = 0    LET qm_aah05 = 0
      LET nc_aah04 = 0    LET nc_aah05 = 0 
      LET lj_aah04 = 0    LET lj_aah05 = 0 
      IF tm.d='N' THEN
#No.TQC-B30153 --begin
      LET qc_aah04 = g_qc_aah04 
      LET qc_aah05 = g_qc_aah05 
      LET qj_aah04 = g_qj_aah04 
      LET qj_aah05 = g_qj_aah05 
      LET qm_aah04 = g_qm_aah04 
      LET qm_aah05 = g_qm_aah05 
      LET nc_aah04 = g_nc_aah04 
      LET nc_aah05 = g_nc_aah05 
      LET lj_aah04 = g_lj_aah04 
      LET lj_aah05 = g_lj_aah05 
      
      LET g_qc_aah04 = 0
      LET g_qc_aah05 = 0
      LET g_qj_aah04 = 0
      LET g_qj_aah05 = 0
      LET g_qm_aah04 = 0
      LET g_qm_aah05 = 0
      LET g_nc_aah04 = 0
      LET g_nc_aah05 = 0
      LET g_lj_aah04 = 0
      LET g_lj_aah05 = 0
         #No.FUN-A40020  --Begin
#         LET qc_aah04 = GROUP SUM(sr.qc_aah04) WHERE sr.aag24 = 1
#         LET qc_aah05 = GROUP SUM(sr.qc_aah05) WHERE sr.aag24 = 1
#         LET qj_aah04 = GROUP SUM(sr.qj_aah04) WHERE sr.aag24 = 1
#         LET qj_aah05 = GROUP SUM(sr.qj_aah05) WHERE sr.aag24 = 1
#         LET qm_aah04 = GROUP SUM(sr.qm_aah04) WHERE sr.aag24 = 1
#         LET qm_aah05 = GROUP SUM(sr.qm_aah05) WHERE sr.aag24 = 1
#         LET nc_aah04 = GROUP SUM(sr.nc_aah04) WHERE sr.aag24 = 1
#         LET nc_aah05 = GROUP SUM(sr.nc_aah05) WHERE sr.aag24 = 1
#         LET lj_aah04 = GROUP SUM(sr.lj_aah04) WHERE sr.aag24 = 1
#         LET lj_aah05 = GROUP SUM(sr.lj_aah05) WHERE sr.aag24 = 1                                       
#         #No.FUN-A40020  --End  
#No.TQC-B30153 --end
         IF cl_null(qc_aah04) THEN LET qc_aah04 = 0 END IF
         IF cl_null(qc_aah05) THEN LET qc_aah05 = 0 END IF
         IF cl_null(qj_aah04) THEN LET qj_aah04 = 0 END IF
         IF cl_null(qj_aah05) THEN LET qj_aah05 = 0 END IF
         IF cl_null(qm_aah04) THEN LET qm_aah04 = 0 END IF
         IF cl_null(qm_aah05) THEN LET qm_aah05 = 0 END IF
         IF cl_null(nc_aah04) THEN LET nc_aah04 = 0 END IF
         IF cl_null(nc_aah05) THEN LET nc_aah05 = 0 END IF
         IF cl_null(lj_aah04) THEN LET lj_aah04 = 0 END IF
         IF cl_null(lj_aah05) THEN LET lj_aah05 = 0 END IF   
         CALL cl_getmsg('ggl-223',g_lang) RETURNING g_msg
         IF NOT cl_null(sr.aah01) THEN 
         INSERT INTO gglq305_tmp
         VALUES('',g_msg,'3','','','','',nc_aah04,nc_aah05,'','',qc_aah04,qc_aah05,
                '','',qj_aah04,qj_aah05,'','',qm_aah04,qm_aah05,'','',
                lj_aah04,lj_aah05)     
         END IF      
      END IF  
END REPORT
 
FUNCTION gglq305_table()
     DROP TABLE gglq305_tmp;
     CREATE TEMP TABLE gglq305_tmp(
                    aah01       LIKE aah_file.aah01,
#                   aag02       LIKE aag_file.aag02,
                    aag02       LIKE type_file.chr1000,        #No.MOD-940388
                    type        LIKE type_file.chr1,
                    memo        LIKE type_file.chr50,
                    abb24       LIKE abb_file.abb24, #No.FUN-A30008
                    nc_tah09    LIKE tah_file.tah09, #No.FUN-A30008
                    nc_tah10    LIKE tah_file.tah10, #No.FUN-A30008
                    nc_aah04    LIKE aah_file.aah04, #No.FUN-A30008        
                    nc_aah05    LIKE aah_file.aah05, #No.FUN-A30008
                    qc_tah09    LIKE tah_file.tah09, #No.FUN-A30008
                    qc_tah10    LIKE tah_file.tah10, #No.FUN-A30008
                    qc_aah04    LIKE aah_file.aah04, 
                    qc_aah05    LIKE aah_file.aah05, 
                    qj_tah09    LIKE tah_file.tah09, #No.FUN-A30008
                    qj_tah10    LIKE tah_file.tah10, #No.FUN-A30008
                    qj_aah04    LIKE aah_file.aah04,
                    qj_aah05    LIKE aah_file.aah05,
                    qm_tah09    LIKE tah_file.tah09, #No.FUN-A30008
                    qm_tah10    LIKE tah_file.tah10, #No.FUN-A30008
                    qm_aah04    LIKE aah_file.aah04, 
                    qm_aah05    LIKE aah_file.aah05,
                    lj_tah09    LIKE tah_file.tah09, #No.FUN-A30008
                    lj_tah10    LIKE tah_file.tah10, #No.FUN-A30008
                    lj_aah04    LIKE aah_file.aah04, #No.FUN-A30008
                    lj_aah05    LIKE aah_file.aah05); #No.FUN-A30008
#                    pagenum     LIKE type_file.num5);#No.FUN-A30008  
END FUNCTION

FUNCTION q305_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aah TO s_aah.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#No.FUN-A30008 --begin
         IF g_rec_b != 0 AND l_ac != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
#No.FUN-A30008 --end
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION drill_general_ledger
         LET g_action_choice="drill_general_ledger"
         EXIT DISPLAY
      #No.FUN-A30008--begin
      ON ACTION first
         CALL gglq305_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL gglq305_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL gglq305_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL gglq305_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL gglq305_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
      #No.FUN-A30008--end    
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
#No.FUN-A30008--begin
FUNCTION gglq305_s()
   IF tm.d='Y' THEN 
      CALL cl_set_comp_visible("abb24,nc_tah09,nc_tah10,qc_tah09,qc_tah10,qj_tah09",TRUE)
      CALL cl_set_comp_visible("qj_tah10,qm_tah09,qm_tah10,lj_tah09,lj_tah10",TRUE)
   ELSE 
      CALL cl_set_comp_visible("abb24,nc_tah09,nc_tah10,qc_tah09,qc_tah10,qj_tah09",FALSE)
      CALL cl_set_comp_visible("qj_tah10,qm_tah09,qm_tah10,lj_tah09,lj_tah10",FALSE)
   END IF 
   IF tm.g='N' THEN 
      CALL cl_set_comp_visible("nc_tah09,nc_tah10,nc_aah04,nc_aah05",FALSE)
   ELSE 
   	  IF tm.d='N' THEN
   	     CALL cl_set_comp_visible("nc_aah04,nc_aah05",TRUE)
   	     CALL cl_set_comp_visible("nc_tah09,nc_tah10",FALSE)
   	  ELSE 
   	   	CALL cl_set_comp_visible("nc_tah09,nc_tah10,nc_aah04,nc_aah05",TRUE)
   	  END IF 
   END IF 
   IF tm.f='Y' AND tm.d='Y' THEN 
      CALL cl_set_comp_visible("e",TRUE)
   ELSE 
   	 CALL cl_set_comp_visible("e",FALSE)
   END IF 
   IF tm.g='Y' THEN 
      IF tm.d='N' THEN 
         CALL cl_set_comp_visible("nc_tah09,nc_tah10",FALSE)
      ELSE 
      	 
      END IF 
   END IF 
   CALL gglq305_t()
   IF tm.f='Y' THEN 
#     CALL q305_cs()    #FUN-C80102 mark
      CALL gglq305_cs1()   #FUN-C80102 add
   ELSE  
   	  LET g_curs_index=0
   	  LET g_row_count=0
   	  CALL cl_navigator_setting( g_curs_index, g_row_count )
   	  CALL gglq305_show()
   END IF 
END FUNCTION  
FUNCTION gglq305_t()
    IF tm.d='N' THEN 
       CALL cl_getmsg("ggl-229",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("nc_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-230",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("nc_aah05",g_msg CLIPPED)
       CALL cl_getmsg("ggl-231",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qc_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-232",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qc_aah05",g_msg CLIPPED)
       CALL cl_getmsg("ggl-233",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qj_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-234",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qj_aah05",g_msg CLIPPED)
       CALL cl_getmsg("ggl-235",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qm_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-236",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qm_aah05",g_msg CLIPPED)
       CALL cl_getmsg("ggl-237",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("lj_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-238",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("lj_aah05",g_msg CLIPPED)
    ELSE 
       CALL cl_getmsg("ggl-239",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("nc_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-240",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("nc_aah05",g_msg CLIPPED)
       CALL cl_getmsg("ggl-241",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qc_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-242",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qc_aah05",g_msg CLIPPED)
       CALL cl_getmsg("ggl-243",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qj_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-244",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qj_aah05",g_msg CLIPPED)
       CALL cl_getmsg("ggl-245",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qm_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-246",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qm_aah05",g_msg CLIPPED)
       CALL cl_getmsg("ggl-247",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("lj_aah04",g_msg CLIPPED)
       CALL cl_getmsg("ggl-248",g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("lj_aah05",g_msg CLIPPED)    	 
    END IF 
END FUNCTION 

#FUNCTION gglq305_cs() 
FUNCTION gglq305_cs1()   #FUN-C80102 

     LET g_sql = "SELECT UNIQUE abb24 FROM gglq305_tmp ",
                 " ORDER BY abb24 "
     PREPARE gglq305_ps FROM g_sql
     DECLARE gglq305_curs SCROLL CURSOR WITH HOLD FOR gglq305_ps

     LET g_sql = "SELECT UNIQUE abb24 FROM gglq305_tmp ",
                 " WHERE abb24 IS NOT NULL ", #FUN-C80102 add
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq305_ps1 FROM g_sql
     EXECUTE gglq305_ps1

     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq305_ps2 FROM g_sql
     DECLARE gglq305_cnt CURSOR FOR gglq305_ps2

     OPEN gglq305_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq305_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq305_cnt
        FETCH gglq305_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq305_fetch('F')
     END IF
END FUNCTION

FUNCTION gglq305_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10

   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq305_curs INTO g_abb24
      WHEN 'P' FETCH PREVIOUS gglq305_curs INTO g_abb24
      WHEN 'F' FETCH FIRST    gglq305_curs INTO g_abb24
      WHEN 'L' FETCH LAST     gglq305_curs INTO g_abb24
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
         FETCH ABSOLUTE g_jump gglq305_curs INTO g_abb24
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_abb24,SQLCA.sqlcode,0)
      INITIALIZE g_abb24 TO NULL
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

   CALL gglq305_show()
END FUNCTION
#No.FUN-A30008--end
FUNCTION gglq305_show()
 
   DISPLAY tm.yy TO yy
   DISPLAY tm.m1 TO m1
   DISPLAY tm.m2 TO m2
#  DISPLAY g_abb24  TO e  #FUN-C80102 mark 
   #FUN-D40121--add--str--
   DISPLAY tm.bookno TO aah00
   DISPLAY tm.d TO d
   DISPLAY tm.f TO f
   DISPLAY tm.b TO b
   DISPLAY tm.g TO g
   DISPLAY tm.lvl TO lvl
   DISPLAY tm.a TO a
   DISPLAY tm.h TO h
   DISPLAY tm.i TO i
   #FUN-D40121--add--end--
   CALL gglq305_b_fill()
   IF tm.f='Y' THEN 
      DISPLAY g_row_count TO FORMONLY.cnt
   ELSE 
   	  DISPLAY g_rec_b TO FORMONLY.cnt
   END IF 
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION gglq305_b_fill()
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1
  #No.FUN-A30008--begin 
  DEFINE  i          LIKE type_file.num5,
          qc_aah04   LIKE aah_file.aah04,
          qc_aah05   LIKE aah_file.aah05,
          qj_aah04   LIKE aah_file.aah04,
          qj_aah05   LIKE aah_file.aah05,
          qm_aah04   LIKE aah_file.aah04,
          qm_aah05   LIKE aah_file.aah05,
          nc_aah04   LIKE aah_file.aah04,
          nc_aah05   LIKE aah_file.aah05,
          lj_aah04   LIKE aah_file.aah04,
          lj_aah05   LIKE aah_file.aah05,
          nc_tah09   LIKE tah_file.tah09,
          nc_tah10   LIKE tah_file.tah10,
          qc_tah09   LIKE tah_file.tah09,
          qc_tah10   LIKE tah_file.tah10,
          qj_tah09   LIKE tah_file.tah09,
          qj_tah10   LIKE tah_file.tah10,
          qm_tah09   LIKE tah_file.tah09,
          qm_tah10   LIKE tah_file.tah10,
          lj_tah09   LIKE tah_file.tah09,
          lj_tah10   LIKE tah_file.tah10      
   #No.FUN-A30008--end 
   DEFINE l_aag07    LIKE aag_file.aag07  #TQC-CC0122   
   DEFINE l_aag24    LIKE aag_file.aag24  #TQC-CC0122

   #FUN-D40121--add--str--
   IF cl_null(tm.wc) THEN
      LET tm.wc = "1=1"
   END IF
   IF cl_null(tm.wc2) THEN
      LET tm.wc2 = "1=1"
   END IF
   #FUN-D40121--add--end--
   LET tm.wc = cl_replace_str(tm.wc,"aag01","aah01")      #FUN-C80102 add
   LET g_sql = "SELECT distinct aah01,aag02,abb24,nc_tah09,nc_tah10,nc_aah04,nc_aah05,qc_tah09,qc_tah10,qc_aah04,qc_aah05,",
               "       qj_tah09,qj_tah10,qj_aah04,qj_aah05,qm_tah09,qm_tah10,qm_aah04,qm_aah05,lj_tah09,lj_tah10,",
               "       lj_aah04,lj_aah05,type ",
               "  FROM gglq305_tmp  ",
               "  WHERE ",tm.wc CLIPPED ,  #FUN-C80102 add
               "    AND ",tm.wc2 CLIPPED   #FUN-C80102 add
               
   IF tm.f='Y' THEN 
     #LET g_sql=g_sql CLIPPED," WHERE abb24='",g_abb24,"' "   #No.FUN-C80102   Mark
      LET g_sql=g_sql CLIPPED," AND abb24='",g_abb24,"' "     #No.FUN-C80102   Add
   END IF 
   IF tm.d='Y' THEN 
      LET g_sql=g_sql CLIPPED," ORDER BY type,aah01,abb24 "
   ELSE
   	  LET g_sql=g_sql CLIPPED," ORDER BY type,aah01 "
   END IF 
   PREPARE gglq305_pb FROM g_sql
   DECLARE aao_curs  CURSOR FOR gglq305_pb
 
   CALL g_aah.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH aao_curs INTO g_aah[g_cnt].*,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
   #MOD-D50259--begin
     #LET g_aah[g_cnt].nc_tah09  = cl_numfor(g_aah[g_cnt].nc_tah09,20,g_azi04)
      LET g_aah[g_cnt].nc_tah09  = cl_numfor(g_aah[g_cnt].nc_tah09,20,t_azi04)
     #LET g_aah[g_cnt].nc_tah10  = cl_numfor(g_aah[g_cnt].nc_tah10,20,g_azi04)
      LET g_aah[g_cnt].nc_tah10  = cl_numfor(g_aah[g_cnt].nc_tah10,20,t_azi04)
   #MOD-D50259--end
      LET g_aah[g_cnt].nc_aah04  = cl_numfor(g_aah[g_cnt].nc_aah04,20,g_azi04)
      LET g_aah[g_cnt].nc_aah05  = cl_numfor(g_aah[g_cnt].nc_aah05,20,g_azi04)
   #MOD-D50259--begin
     #LET g_aah[g_cnt].qc_tah09  = cl_numfor(g_aah[g_cnt].qc_tah09,20,g_azi04)
      LET g_aah[g_cnt].qc_tah09  = cl_numfor(g_aah[g_cnt].qc_tah09,20,t_azi04)
     #LET g_aah[g_cnt].qc_tah10  = cl_numfor(g_aah[g_cnt].qc_tah10,20,g_azi04)
      LET g_aah[g_cnt].qc_tah10  = cl_numfor(g_aah[g_cnt].qc_tah10,20,t_azi04)
   #MOD-D50259--end
      LET g_aah[g_cnt].qc_aah04  = cl_numfor(g_aah[g_cnt].qc_aah04,20,g_azi04)
      LET g_aah[g_cnt].qc_aah05  = cl_numfor(g_aah[g_cnt].qc_aah05,20,g_azi04)
   #MOD-D50259--begin
     #LET g_aah[g_cnt].qj_tah09  = cl_numfor(g_aah[g_cnt].qj_tah09,20,g_azi04)
      LET g_aah[g_cnt].qj_tah09  = cl_numfor(g_aah[g_cnt].qj_tah09,20,t_azi04)
     #LET g_aah[g_cnt].qj_tah10  = cl_numfor(g_aah[g_cnt].qj_tah10,20,g_azi04)
      LET g_aah[g_cnt].qj_tah10  = cl_numfor(g_aah[g_cnt].qj_tah10,20,t_azi04)
   #MOD-D50259--end
      LET g_aah[g_cnt].qj_aah04  = cl_numfor(g_aah[g_cnt].qj_aah04,20,g_azi04)
      LET g_aah[g_cnt].qj_aah05  = cl_numfor(g_aah[g_cnt].qj_aah05,20,g_azi04)
   #MOD-D50259--begin
     #LET g_aah[g_cnt].qm_tah09  = cl_numfor(g_aah[g_cnt].qm_tah09,20,g_azi04)
      LET g_aah[g_cnt].qm_tah09  = cl_numfor(g_aah[g_cnt].qm_tah09,20,t_azi04)
     #LET g_aah[g_cnt].qm_tah10  = cl_numfor(g_aah[g_cnt].qm_tah10,20,g_azi04)
      LET g_aah[g_cnt].qm_tah10  = cl_numfor(g_aah[g_cnt].qm_tah10,20,t_azi04)
   #MOD-D50259--end
      LET g_aah[g_cnt].qm_aah04  = cl_numfor(g_aah[g_cnt].qm_aah04,20,g_azi04)
      LET g_aah[g_cnt].qm_aah05  = cl_numfor(g_aah[g_cnt].qm_aah05,20,g_azi04)
   #MOD-D50259--begin
     #LET g_aah[g_cnt].lj_tah09  = cl_numfor(g_aah[g_cnt].lj_tah09,20,g_azi04)
      LET g_aah[g_cnt].lj_tah09  = cl_numfor(g_aah[g_cnt].lj_tah09,20,t_azi04)
     #LET g_aah[g_cnt].lj_tah10  = cl_numfor(g_aah[g_cnt].lj_tah10,20,g_azi04)
      LET g_aah[g_cnt].lj_tah10  = cl_numfor(g_aah[g_cnt].lj_tah10,20,t_azi04)
   #MOD-D50259--end
      LET g_aah[g_cnt].lj_aah04  = cl_numfor(g_aah[g_cnt].lj_aah04,20,g_azi04)
      LET g_aah[g_cnt].lj_aah05  = cl_numfor(g_aah[g_cnt].lj_aah05,20,g_azi04)
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   
   CALL g_aah.deleteElement(g_cnt)  
   #No.FUN-A30008--begin
   LET g_cnt=g_cnt-1
   LET g_rec_b = g_cnt
#   IF tm.f='Y' THEN 
   IF g_cnt>0 THEN 
      IF tm.d='Y' THEN 
         LET nc_tah09=0  LET nc_tah10=0
         LET qc_tah09=0  LET qc_tah10=0
         LET qj_tah09=0  LET qj_tah10=0
         LET qm_tah09=0  LET qm_tah10=0
         LET lj_tah09=0  LET lj_tah10=0  
         LET nc_aah04=0  LET nc_aah05=0
         LET qc_aah04=0  LET qc_aah05=0
         LET qj_aah04=0  LET qj_aah05=0
         LET qm_aah04=0  LET qm_aah05=0
         LET lj_aah04=0  LET lj_aah05=0
         FOR i=1 TO g_cnt 
            SELECT aag07,aag24 INTO l_aag07,l_aag24 FROM aag_file WHERE aag01 = g_aah[i].aah01    #TQC-CC0122
            IF l_aag07 != '2' AND l_aag24 = '1' THEN      #TQC-CC0122
            LET qc_tah09 = g_aah[i].qc_tah09+qc_tah09 
            LET qc_tah10 = g_aah[i].qc_tah10+qc_tah10
            LET qj_tah09 = g_aah[i].qj_tah09+qj_tah09
            LET qj_tah10 = g_aah[i].qj_tah10+qj_tah10
            LET qm_tah09 = g_aah[i].qm_tah09+qm_tah09 
            LET qm_tah10 = g_aah[i].qm_tah10+qm_tah10
            LET nc_tah09 = g_aah[i].nc_tah09+nc_tah09 
            LET nc_tah10 = g_aah[i].nc_tah10+nc_tah10
            LET lj_tah09 = g_aah[i].lj_tah09+lj_tah09 
            LET lj_tah10 = g_aah[i].lj_tah10+lj_tah10
            LET qc_aah04 = g_aah[i].qc_aah04+qc_aah04 
            LET qc_aah05 = g_aah[i].qc_aah05+qc_aah05
            LET qj_aah04 = g_aah[i].qj_aah04+qj_aah04
            LET qj_aah05 = g_aah[i].qj_aah05+qj_aah05
            LET qm_aah04 = g_aah[i].qm_aah04+qm_aah04 
            LET qm_aah05 = g_aah[i].qm_aah05+qm_aah05
            LET nc_aah04 = g_aah[i].nc_aah04+nc_aah04 
            LET nc_aah05 = g_aah[i].nc_aah05+nc_aah05
            LET lj_aah04 = g_aah[i].lj_aah04+lj_aah04 
            LET lj_aah05 = g_aah[i].lj_aah05+lj_aah05                                           
            END IF    #TQC-CC0122
         END FOR 
         CALL cl_getmsg('ggl-223',g_lang) RETURNING g_msg
         LET g_cnt=g_cnt+1
         IF tm.f='Y' THEN 
            LET g_aah[g_cnt].nc_tah09=qc_tah09
            LET g_aah[g_cnt].nc_tah10=qc_tah10
            LET g_aah[g_cnt].qc_tah09=qc_tah09
            LET g_aah[g_cnt].qc_tah10=qc_tah10
            LET g_aah[g_cnt].qj_tah09=qj_tah09
            LET g_aah[g_cnt].qj_tah10=qj_tah10
            LET g_aah[g_cnt].qm_tah09=qm_tah09
            LET g_aah[g_cnt].qm_tah10=qm_tah10
            LET g_aah[g_cnt].lj_tah09=lj_tah09
            LET g_aah[g_cnt].lj_tah10=lj_tah10
            LET g_aah[g_cnt].nc_aah04=qc_aah04
            LET g_aah[g_cnt].nc_aah05=qc_aah05
            LET g_aah[g_cnt].qc_aah04=qc_aah04
            LET g_aah[g_cnt].qc_aah05=qc_aah05
            LET g_aah[g_cnt].qj_aah04=qj_aah04
            LET g_aah[g_cnt].qj_aah05=qj_aah05
            LET g_aah[g_cnt].qm_aah04=qm_aah04
            LET g_aah[g_cnt].qm_aah05=qm_aah05
            LET g_aah[g_cnt].lj_aah04=lj_aah04
            LET g_aah[g_cnt].lj_aah05=lj_aah05
            LET g_aah[g_cnt].aag02=g_msg
            LET g_aah[g_cnt].abb24=g_abb24     
         ELSE    
            LET g_aah[g_cnt].nc_aah04=qc_aah04
            LET g_aah[g_cnt].nc_aah05=qc_aah05
            LET g_aah[g_cnt].qc_aah04=qc_aah04
            LET g_aah[g_cnt].qc_aah05=qc_aah05
            LET g_aah[g_cnt].qj_aah04=qj_aah04
            LET g_aah[g_cnt].qj_aah05=qj_aah05
            LET g_aah[g_cnt].qm_aah04=qm_aah04
            LET g_aah[g_cnt].qm_aah05=qm_aah05
            LET g_aah[g_cnt].lj_aah04=lj_aah04
            LET g_aah[g_cnt].lj_aah05=lj_aah05
            LET g_aah[g_cnt].aag02=g_msg         	
         END IF 
      END IF 
   END IF 
   #No.FUN-A30008--end 
END FUNCTION
 
FUNCTION q305_out_1()
   LET g_prog = 'gglq305'
   LET g_sql = "aah01.aah_file.aah01,",
               "aag02.aag_file.aag02,",
               "type.type_file.chr10,",
               "memo.type_file.chr50,",
               "abb24.abb_file.abb24,",
               "nc_tah09.tah_file.tah09,",
               "nc_tah10.tah_file.tah10,",
               "nc_aah04.aah_file.aah04,",
               "nc_aah05.aah_file.aah05,",
               "qc_tah09.tah_file.tah09,",
               "qc_tah10.tah_file.tah10,",
               "qc_aah04.aah_file.aah04,",
               "qc_aah05.aah_file.aah05,",
               "qj_tah09.tah_file.tah09,",
               "qj_tah10.tah_file.tah10,",
               "qj_aah04.aah_file.aah04,",
               "qj_aah05.aah_file.aah05,",
               "qm_tah09.tah_file.tah09,",
               "qm_tah10.tah_file.tah10,",
               "qm_aah04.aah_file.aah04,",
               "qm_aah05.aah_file.aah05,",
               "lj_tah09.tah_file.tah09,",
               "lj_tah10.tah_file.tah10,",
               "lj_aah04.aah_file.aah04,",
               "lj_aah05.aah_file.aah05"
 
   LET l_table = cl_prt_temptable('gglq305',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION q305_out_2()
DEFINE   l_m     LIKE type_file.chr20
DEFINE   l_sql   STRING 

   LET g_prog = 'gglq305'
   CALL cl_del_data(l_table)
   LET l_sql=" SELECT * FROM gglq305_tmp "
   IF tm.d='Y' THEN 
      LET l_sql=l_sql CLIPPED," WHERE type='2' "
   END IF 
   PREPARE cr_p FROM l_sql 
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('cr_p',SQLCA.sqlcode,1)
   END IF
   DECLARE cr_curs CURSOR FOR cr_p
        
   FOREACH cr_curs INTO g_pr.*
       EXECUTE insert_prep USING g_pr.*
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   LET g_str = NULL
   LET g_str=g_str CLIPPED,";",tm.yy,";",tm.m1,";",tm.m2,";",g_azi04,";",tm.f
#   IF tm.f='Y' THEN 
#      LET l_m='gglq305_1'
#   ELSE 
#   	  IF tm.g='Y' THEN 
#   	     LET l_m='gglq305_3'
#   	  ELSE 
#   	  	 LET l_m='gglq305'
#   	  END IF 
#   END IF       
   IF tm.d='Y' THEN             #打印外币
      IF tm.g='Y' THEN          #打印年初余额
         LET l_m='gglq305_1'
      ELSE  
      	 LET l_m='gglq305_2'
      END IF  
   ELSE 
      IF tm.g='Y' THEN          #打印年初余额
         LET l_m='gglq305_3'
      ELSE  
      	 LET l_m='gglq305'
      END IF     	
   END IF 
   CALL cl_prt_cs3('gglq305',l_m,g_sql,g_str)
END FUNCTION
 
FUNCTION q305_drill_gl()
   DEFINE 
        #l_wc    LIKE type_file.chr50
        l_wc         STRING       #NO.FUN-910082
 
   IF l_ac = 0 THEN RETURN END IF 
   IF cl_null(g_aah[l_ac].aah01) THEN RETURN END IF
 
  #LET l_wc = 'aag01 like "',g_aah[l_ac].aah01,'%"'   #FUN-C80102 mark
   LET l_wc = 'aah01 like "',g_aah[l_ac].aah01,'%"'   #FUN-C80102 add
   LET g_msg = "gglq300 '",tm.bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",
               l_wc CLIPPED,"' 'N' '",tm.a,"' 'N' 'Y' '",tm.b,"' '' ",
               tm.yy," ",tm.m1," ",tm.m2," '' '' '' '' 'Y' 'Y' '",tm.i,"'"  #FUN-C70061 add '' 'Y' end    #TQC-CC0122 add Y(科目分頁),tm.i
   CALL cl_cmdrun(g_msg)
 
END FUNCTION
