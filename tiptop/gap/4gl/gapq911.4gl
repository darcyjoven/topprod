# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gapq911.4gl
# Descriptions...: 供應商業務匯總帳列印
# Date & Author..: 03/05/21 by Carrier
# Modify.........: No.MOD-530675 05/03/26 By Day 期別判別錯誤
# Modify.........: No.MOD-580353 05/09/15 By Smnprin 選了期別之後還是會把其他的期別打印出來
# Modify.........; NO.TQC-650054 06/05/12 by yiting 報表錯誤
# Modify.........: No.FUN-660071 06/06/13 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smnprin 修改外部參數接收
# Modify.........: No.FUN-670003 06/07/10 By Czl  帳別權限修改
# Modify.........: No.FUN-670107 06/08/24 By cheunl voucher型報表轉template1
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-740064 07/04/16 By arman  會計科目加帳套
# Modify.........: No.FUN-840076 08/04/17 By liuxqa 修改報表的分組
# Modify.........: No.FUN-850030 08/05/30 By dxfwo  報表查詢化
# Modify.........: No.TQC-8B0035 08/11/18 By wujie   sql里加上npr08是null或者空格的條件 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920083 09/02/10 By liuxqa 950行，將l_c改為y_c
# Modify.........: No.MOD-920215 09/02/17 By chenl  調整匯率計算方式。
# Modify.........: No.MOD-920234 09/02/20 By liuxqa l_wc中條件中加上npq22.
# Modify.........: No.MOD-930203 09/03/20 By Carrier 串gapq910時,傳tm.b(打印外幣否)值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980120 09/09/01 By xiaofeizhu	增加“按幣別分頁”
# Modify.........: No.FUN-9C0072 10/01/09 By vealxu 精簡程式碼
# Modify.........: No:FUN-A40009 10/04/07 By wujie 查询界面点退出回到主画面，而不是关闭程序
#                                                  点击单据联查按钮后，光标保持在原来所在的行，而不是回到第一行
# Modify.........: No.FUN-B20054 10/02/24 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B60303 11/06/23 By wujie 串查改为gglq910 
# Modify.........: No:MOD-C70021 12/07/03 By Carrier串查改为gglq910
# Modify.........: No:MOD-C60030 12/06/06 By yinhy 客戶編號提供開窗
# Modify.........: No:TQC-BC0063 12/08/24 By wangwei TQC-B60303改錯
# Modify.........: No.FUN-C80102 12/10/23 By zhangweib 報表改善追單
# Modify.........: No.FUN-CB0146 13/01/08 By zhangweib 報表執行效率優化
# Modify.........: No.MOD-D20156 13/02/25 By yinhy 過濾掉npr01為' '的資料
# Modify.........: No.MOD-D40201 13/04/25 By yinhy 加傳npr11參數
# Modify.........: No.TQC-D60015 13/06/24 By yangtt 修改串連參數g_msg
# Modify.........: No.FUN-D50056 13/05/16 By lujh 跨期的查詢，不用分上下頁顯示，目前查看1-3月份的時候，
#                                                 會分三頁顯示，應該不需要分頁顯示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
		wc      LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(1000)     # Where condition
                yy      LIKE type_file.num5,     #NO FUN-690009 SMALLINT
                m1      LIKE type_file.num5,     #NO FUN-690009 SMALLINT
                m2      LIKE type_file.num5,     #NO FUN-690009 SMALLINT
                o       LIKE aaa_file.aaa01,     #NO.FUN-670003 
                b       LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
               #c       LIKE type_file.chr1,     #FUN-980120                      #FUN-C80102 mark
               # Prog. Version..: '5.30.06-13.03.12(01)       #FUN-C80102 mark
                e       LIKE type_file.chr1,                                      #FUN-C80102
                f       LIKE type_file.chr1,                                      #FUN-C80102
		more    LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)       # Input more condition(Y/N)
           END RECORD,
           g_d      LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(01)
           g_null   LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(01) 
           g_print  LIKE type_file.chr1,         #NO FUN-690009 SMALLINT
           g_aza17  LIKE aza_file.aza17,
           l_aza17  LIKE aza_file.aza17,
           l_aaz64  LIKE aaz_file.aaz64,
           l_aaa    RECORD LIKE aaa_file.*,
           l_aag02  LIKE aag_file.aag02,
           g_qcyef  LIKE npr_file.npr06f,
           g_qcye   LIKE npr_file.npr06f,
           g_npr06f LIKE npr_file.npr06f,
           g_npr07f LIKE npr_file.npr06f,
           g_npr06  LIKE npr_file.npr06f,
           g_npr07  LIKE npr_file.npr06f,
           t_qcyef  LIKE npr_file.npr06f,
           t_qcye   LIKE npr_file.npr06f,
           t_npr06f LIKE npr_file.npr06f,
           t_npr07f LIKE npr_file.npr06f,
           t_npr06  LIKE npr_file.npr06f,
           t_npr07  LIKE npr_file.npr06f
 
DEFINE   g_i        LIKE type_file.num5     #NO FUN-690009 SMALLINT  #count/index for any purpose
DEFINE   g_sql      STRING
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_npr00    LIKE npr_file.npr00
DEFINE   g_aag02    LIKE aag_file.aag02
DEFINE   g_npr05    LIKE npr_file.npr05
DEFINE   g_npr11    LIKE npr_file.npr11     #FUN-980120
DEFINE   g_cnt      LIKE type_file.num10
DEFINE   g_npr      DYNAMIC ARRAY OF RECORD
                    npr00      LIKE npr_file.npr00,              #FUN-C80102
                    aag02      LIKE aag_file.aag02,              #FUN-C80102
                    npr01      LIKE type_file.chr50,
                    npr02      LIKE npr_file.npr02,
                    npr11      LIKE npr_file.npr11,
                    pb_dc      LIKE type_file.chr10,                            
                    pb_balf    LIKE npr_file.npr06f,                            
                    npr11_pb   LIKE npq_file.npq25,                             
                    pb_bal     LIKE npr_file.npr06f,
                    df         LIKE npr_file.npr06f,
                    npr11_d    LIKE npq_file.npq25,
                    d          LIKE npr_file.npr06f,
                    cf         LIKE npr_file.npr06f,
                    npr11_c    LIKE npq_file.npq25,
                    c          LIKE npr_file.npr06f,
                    dc         LIKE type_file.chr10,
                    balf       LIKE npr_file.npr06f,
                    npr11_bal  LIKE npq_file.npq25,
                    bal        LIKE npr_file.npr06f
                    END RECORD
DEFINE   g_pr       RECORD
                    npr00      LIKE npr_file.npr00,
                    aag02      LIKE aag_file.aag02,
                    #npr05      LIKE npr_file.npr05,   #FUN-D50056 mark                    npr05      LIKE npr_file.npr05,
                    npr01      LIKE type_file.chr50,
                    npr02      LIKE npr_file.npr02,
                    npr11      LIKE npr_file.npr11,
                    type       LIKE type_file.chr10,
                    pb_dc      LIKE type_file.chr10,
                    pb_balf    LIKE npr_file.npr06f,
                    npr11_pb   LIKE npq_file.npq25,
                    pb_bal     LIKE npr_file.npr06f,
                    memo       LIKE abb_file.abb04,
                    df         LIKE npr_file.npr06f,
                    npr11_d    LIKE npq_file.npq25,
                    d          LIKE npr_file.npr06f,
                    cf         LIKE npr_file.npr06f,
                    npr11_c    LIKE npq_file.npq25,
                    c          LIKE npr_file.npr06f,
                    dc         LIKE type_file.chr10,
                    balf       LIKE npr_file.npr06f,
                    npr11_bal  LIKE npq_file.npq25,
                    bal        LIKE npr_file.npr06f,
                    azi04      LIKE azi_file.azi04,
                    azi05      LIKE azi_file.azi05,
                    azi07      LIKE azi_file.azi07
                    END RECORD
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_row_count    LIKE type_file.num10  
DEFINE   g_curs_index   LIKE type_file.num10  
DEFINE   g_jump         LIKE type_file.num10  
DEFINE   mi_no_ask      LIKE type_file.num5   
DEFINE   l_ac           LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680126  SMALLINT
DEFINE   l_table        STRING,                                                                                                       
         g_str          STRING
DEFINE   g_test         LIKE type_file.num5   #No.FUN-CB0146  Add For Test
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   INITIALIZE tm.* TO NULL            # Default condition

   LET g_test = 0  #No.FUN-CB0146 Add
 
   SELECT aza17 INTO l_aza17 FROM aza_file WHERE aza01 = '0'
   IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF
   SELECT aaz64 INTO l_aaz64 FROM aaz_file WHERE aaz00 = '0'
   IF SQLCA.sqlcode THEN 
      CALL cl_err('aaz_file',-100,0) 
      CALL cl_err3("sel","aaz_file","","",-100,"","aaz_file",0) #No.FUN-660071
      EXIT PROGRAM
   END IF
   SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = l_aaz64
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","aaa_file","","",-100,"","aaa_file",0) #No.FUN-660071
      EXIT PROGRAM 
   END IF
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = l_aaa.aaa01
      AND aaf02 = g_lang
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","aaf_file","","",-100,"","aaf_file",0) #No.FUN-660071
      EXIT PROGRAM
   END IF
 
  LET g_pdate = ARG_VAL(1)
  LET g_towhom = ARG_VAL(2)
  LET g_rlang = ARG_VAL(3)
  LET g_bgjob = ARG_VAL(4)
  LET g_prtway = ARG_VAL(5)
  LET g_copies = ARG_VAL(6)
  LET tm.wc = ARG_VAL(7)
  LET tm.yy = ARG_VAL(8)
  LET tm.m1 = ARG_VAL(9)
  LET tm.m2 = ARG_VAL(10)
  LET tm.o = ARG_VAL(11)
  LET tm.b = ARG_VAL(12)
# LET tm.c = ARG_VAL(13)         #FUN-980120  #FUN-C80102 mark
# LET tm.d = ARG_VAL(14)                      #FUN-C80102 mark
  LET tm.e = ARG_VAL(13)                      #FUN-C80102
  LET tm.f = ARG_VAL(14)                      #FUN-C80102
  LET g_rep_user = ARG_VAL(15)
  LET g_rep_clas = ARG_VAL(16)
  LET g_template = ARG_VAL(17)
 
   CALL q911_out_1()
 
   OPEN WINDOW q911_w AT 5,10
        WITH FORM "gap/42f/gapq911_1" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
   IF cl_null(tm.wc) THEN
      CALL gapq911_tm(0,0)             # Input print condition
   ELSE
     #CALL gapq911()   #TQC-610053  #No.FUN-CB0146 Add
      CALL gapq911v()               #No.FUN-CB0146 Add
   END IF
 
   CALL q911_menu()
   DROP TABLE gapq911_tmp;
   CLOSE WINDOW q911_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION q911_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(500)
 
   WHILE TRUE
      CALL q911_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               #FUN-C80102---add---str
               CALL cl_set_comp_visible("pb_balf,npr11_pb",TRUE)
               CALL cl_set_comp_visible("npr11,df,cf,balf",TRUE)
               CALL cl_set_comp_visible("npr11_d,npr11_c,npr11_bal",TRUE)
               #FUN-C80102---add---end
               CALL gapq911_tm(0,0)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q911_out_2()
            END IF
         WHEN "drill_detail"
            IF cl_chk_act_auth() THEN
               CALL q911_drill_detail()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_npr),'','')
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_npr00 IS NOT NULL THEN
                  LET g_doc.column1 = "npr00"
                  LET g_doc.value1 = g_npr00
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION gapq911_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031 
   DEFINE li_chk_bookno  LIKE type_file.num5     #No.FUN-670003 #NO FUN-690009 SMALLINT
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009 SMALLINT
          l_n            LIKE type_file.num5,    #NO FUN-690009 SMALLINT
          l_flag         LIKE type_file.num5,    #NO FUN-690009 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(1000)
   
   CLEAR FORM #清除畫面   #FUN-C80102  add
   CALL g_npr.clear()     #FUN-C80102  add 
  #FUN-C80102--mark--str---
  # LET p_row = 4 LET p_col =25
 
  # OPEN WINDOW gapq911_w AT p_row,p_col WITH FORM "gap/42f/gapq911"
  #     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  #  CALL cl_ui_locale("gapq911")
  #FUN-C80102--mark--end---
 
   CALL cl_opmsg('p')
   LET tm.yy    = l_aaa.aaa04
   LET tm.m1    = l_aaa.aaa05
   LET tm.m2    = l_aaa.aaa05
   LET tm.o     = l_aaa.aaa01
   LET tm.b     = 'N'
  #LET tm.c     = 'N'                     #FUN-980120   #FUN-C80102 mark
   LET tm.e     = 'N'                                   #FUN-C80102
  #LET tm.d     = 'N'                                   #FUN-C80102 mark
   LET tm.f     = 'Y'                                   #FUN-C80102
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
#  DISPLAY BY NAME tm.yy,tm.m1,tm.m2,tm.o,tm.b,tm.c,tm.d,tm.more            #FUN-980120 Add tm.c   #FUN-C80102
   DISPLAY BY NAME tm.yy,tm.m1,tm.m2,tm.o,tm.b,tm.e                                           #FUN-C80102
WHILE TRUE
##FUN-C80102----mark------str----------
##FUN-B20054--add--str--
   DIALOG ATTRIBUTE(unbuffered)
#      INPUT BY NAME tm.o ATTRIBUTE(WITHOUT DEFAULTS)
#          AFTER FIELD o 
#            IF NOT cl_null(tm.o) THEN
#                   CALL s_check_bookno(tm.o,g_user,g_plant)
#                    RETURNING li_chk_bookno
#                IF (NOT li_chk_bookno) THEN
#                    NEXT FIELD o
#                END IF
#                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.o
#               IF STATUS THEN
#                   CALL cl_err3("sel","aaa_file",tm.o,"","agl-043","","",0)
#                   NEXT FIELD o
#                END IF
#            END IF
#       END INPUT
#FUN-B20054--add--end--
#   CONSTRUCT BY NAME tm.wc ON npr01,npr00
#       BEFORE CONSTRUCT
#           CALL cl_qbe_init()
# 
#       #FUN-B20054--mark--str--
#       #ON ACTION CONTROLP
#       #   CASE WHEN INFIELD(npr00)     #科目代號
#       #           CALL cl_init_qry_var()
#       #           LET g_qryparam.state= 'c'
#       #           LET g_qryparam.form = 'q_aag'
#       #           CALL cl_create_qry() RETURNING g_qryparam.multiret
#      #           DISPLAY g_qryparam.multiret TO npr00
#       #           NEXT FIELD npr00
#       #   END CASE
#       #
#       #ON ACTION locale
#       #   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#       #   LET g_action_choice = "locale"
#      #   EXIT CONSTRUCT
#       #
#       #ON IDLE g_idle_seconds
#       #   CALL cl_on_idle()
#       #   CONTINUE CONSTRUCT
#       #
#       #ON ACTION about         #MOD-4C0121
#       #   CALL cl_about()      #MOD-4C0121
#       #
#       #ON ACTION help          #MOD-4C0121
#       #   CALL cl_show_help()  #MOD-4C0121
#       #
#       #ON ACTION controlg      #MOD-4C0121
#       #   CALL cl_cmdask()     #MOD-4C0121
#       #
#       #ON ACTION exit
#       #   LET INT_FLAG = 1
#       #   EXIT CONSTRUCT
#       #
#       #ON ACTION qbe_select
#       #   CALL cl_qbe_select()  
#       #FUN-B20054--mark--end--
# 
#   END CONSTRUCT
   #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030   #FUN-B20054 TO AFTER END DIALOG
   #FUN-B20054--mark--str--
   #IF g_action_choice = "locale" THEN
   #   LET g_action_choice = ""
   #   CALL cl_dynamic_locale()
   #   CONTINUE WHILE
   #END IF
   #FUN-B20054--mark--end--
 
   #FUN-B20054--mark--str--
   #IF INT_FLAG THEN
#No.FIN-A40009 --begin
#     LET INT_FLAG = 0 CLOSE WINDOW gapq911_w EXIT PROGRAM
#  END IF
   #ELSE
   #FUN-B20054--mark--str--
#No.FIN-A40009 --end
#FUN-B20054--TO AFTER END DIALOG--end--
#   IF tm.wc = ' 1=1' THEN
#      CALL cl_err('','9046',0) CONTINUE WHILE
#   END IF
#FUN-B20054--TO AFTER END DIALOG--end--
#FUN-C80102----mark---end-----------------
#  INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.b,tm.c,tm.d,tm.more               #FUN-980120 Add tm.c  #FUN-B20054 TO del o     #FUN-C80102 mark
   INPUT BY NAME tm.o,tm.yy,tm.m1,tm.m2,tm.e,tm.b                                                                 #FUN-C80102
         #WITHOUT DEFAULTS                                              #FUN-B20054
         ATTRIBUTE(WITHOUT DEFAULTS)                                    #FUN-B20054
         
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)


       #FUN-C80102----add-----str
       AFTER FIELD o
           IF cl_null(tm.o) THEN
              CALL cl_err('','mfg3018',0)
              NEXT FIELD o
           END IF
           IF NOT cl_null(tm.o) THEN
              CALL s_check_bookno(tm.o,g_user,g_plant)
              RETURNING li_chk_bookno
           IF (NOT li_chk_bookno) THEN
              NEXT FIELD o
           END IF
           SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.o
           IF STATUS THEN
              CALL cl_err3("sel","aaa_file",tm.o,"","agl-043","","",0)
              NEXT FIELD o
              END IF
           END IF
       #FUN-C80102----add----end 
       AFTER FIELD yy
          IF cl_null(tm.yy) THEN
             CALL cl_err('','mfg3018',0)
             NEXT FIELD yy
          END IF
 
       AFTER FIELD m1
          IF cl_null(tm.m1) OR tm.m1 > 13 OR tm.m1 < 1 THEN
             CALL cl_err(tm.m1,'agl-013',0)
             NEXT FIELD m1
          END IF
 
       AFTER FIELD m2
          IF cl_null(tm.m2) OR tm.m2 > 13 OR tm.m2 < 1 THEN
             CALL cl_err(tm.m1,'agl-013',0)
             NEXT FIELD m2
          END IF
          IF tm.m2 < tm.m1 THEN
             CALL cl_err('','agl-157',0)
             NEXT FIELD m1
          END IF
 
       #FUN-B20054--mark--str--
       #AFTER FIELD o
       #   IF cl_null(tm.o) THEN
       #      CALL cl_err('','mfg3018',0)
       #      NEXT FIELD o
       #   END IF
       #   CALL s_check_bookno(tm.o,g_user,g_plant) 
       #        RETURNING li_chk_bookno
       #   IF (NOT li_chk_bookno) THEN
       #        NEXT FIELD o
       #   END IF 
       #   SELECT * FROM aaa_file WHERE aaa01 = tm.o
       #   IF SQLCA.sqlcode THEN
       #      CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0) #No.FUN-660071
       #      NEXT FIELD o
       #   END IF
       #   SELECT aaa03 INTO l_aza17 FROM aaa_file WHERE aaa01 = tm.o
       #   IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF   #使用本國幣別   
       #FUN-B20054--mark--end--
 
       AFTER FIELD b
          IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
             NEXT FIELD b
          END IF
      #FUN-C80102-----mod--------str
      # AFTER FIELD c
      #    IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
      #       NEXT FIELD c
      #    END IF        
        
      #  ON CHANGE b
      #     IF tm.b = 'N' THEN 
      #        LET tm.c = 'N' 
      #        DISPLAY tm.c TO c
      #     END IF
 
      #  ON CHANGE c
      #     IF tm.c = 'Y' THEN 
      #        LET tm.b = 'Y' 
      #        DISPLAY tm.b TO b
      #     END IF
 
      # AFTER FIELD d
      #     IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN NEXT FIELD d END IF
 
      # AFTER FIELD more
      #     IF tm.more = 'Y'
      #        THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
      #                            g_bgjob,g_time,g_prtway,g_copies)
      #                  RETURNING g_pdate,g_towhom,g_rlang,
      #                            g_bgjob,g_time,g_prtway,g_copies
      #     END IF
       AFTER FIELD e
          IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
             NEXT FIELD e
          END IF

        ON CHANGE b
           IF tm.b = 'N' THEN
              LET tm.e = 'N'
              DISPLAY tm.e TO e
           END IF
 
        ON CHANGE e
           IF tm.e = 'Y' THEN
              LET tm.b = 'Y'
              DISPLAY tm.b TO b
           END IF
 
      #FUN-C80102----mod------end------

       #FUN-B20054--mark--str--
       #ON ACTION CONTROLZ
       #   CALL cl_show_req_fields()
       #
       #ON ACTION CONTROLG
       #   CALL cl_cmdask()    # Command execution
       #
       #ON IDLE g_idle_seconds
       #   CALL cl_on_idle()
       #   CONTINUE INPUT
       #
       #ON ACTION about         #MOD-4C0121
       #   CALL cl_about()      #MOD-4C0121
       #
       #ON ACTION help          #MOD-4C0121
       #   CALL cl_show_help()  #MOD-4C0121
       #
       #ON ACTION exit
       #   LET INT_FLAG = 1
       #   EXIT INPUT
       #
       #ON ACTION qbe_save
       #   CALL cl_qbe_save()  
       #FUN-B20054--mark--end--
 
   END INPUT                  
   #FUN-C80102---add---str
   CONSTRUCT tm.wc ON npr00,npr01,npr02,npr11
                  FROM s_npr[1].npr00,s_npr[1].npr01,s_npr[1].npr02,s_npr[1].npr11
   BEFORE CONSTRUCT
      CALL cl_qbe_init()

    END CONSTRUCT
   #FUN-C80102---add---end 
   #FUN-B20054--add--str--
      ON ACTION CONTROLP
          CASE  
             WHEN INFIELD(o)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.state = "c"
                LET g_qryparam.default1 = tm.o
                CALL cl_create_qry() RETURNING tm.o
                DISPLAY tm.o TO FORMONLY.o
                NEXT FIELD o
             WHEN INFIELD(npr00)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO npr00
                NEXT FIELD npr00
             #No.MOD-C60030  --Begin
             WHEN INFIELD(npr01)
                CALL cl_init_qry_var()
                LET g_qryparam.state= 'c'
                LET g_qryparam.form = 'q_npq'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO npr01
                NEXT FIELD npr01
             #No.MOD-C60030  --End
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
         #FUN-C80102------mark---str
         #No.TQC-BC0063 --Begin
         # IF cl_null(tm.wc) OR tm.wc = ' 1=1' THEN
         #    CALL cl_err('','9046',0)
         #   NEXT FIELD npr01         #FUN-C80102
         # END IF
         #FUN-C80102-----mark--end
          #No.TQC-BC0063 --End
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
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null)
    IF INT_FLAG THEN
       LET INT_FLAG = 0                                   #FUN-C80102
       RETURN                                             #FUN-C80102
   #FUN-C8102---mark---str
   # ELSE
   #    IF tm.wc = ' 1=1' THEN
   #       CALL cl_err('','9046',0) 
   #       CONTINUE WHILE
   #    END IF
   #FUN-C8102---mark---end
    END IF
   #FUN-B20054--add--end
 
#No.FUN-A40009 --begin 
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0 CLOSE WINDOW gapq911_w EXIT PROGRAM
#  END IF
#No.FUN-A40009 --end
   
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gapq911'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gapq911','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'" ,
                         " '",tm.yy    CLIPPED,"'" ,
                         " '",tm.m1    CLIPPED,"'" ,
                         " '",tm.m2    CLIPPED,"'" ,
                         " '",tm.o     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                        # " '",tm.c     CLIPPED,"'",             #FUN-980120    #FUN-C80102
                        # " '",tm.d     CLIPPED,"'",                            #FUN-C80102
                         " '",tm.e     CLIPPED,"'",                             #FUN-C80102
                         " '",tm.f     CLIPPED,"'",                             #FUN-C80102
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('gapq911',g_time,l_cmd)    # Execute cmd at later time
      END IF
     #CLOSE WINDOW gapq911_w                                       #FUN-C80102 mark
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF          #No.FUN-A40009
   CALL cl_wait()
  # #FUN-C80102--add--str--
  #  CALL q911_b_askkey()
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
    END IF
    #FUN-C80102--add--end--
  #CALL gapq911()                #No.FUN-CB0146 Add
   CALL gapq911v()               #No.FUN-CB0146 Add
   ERROR ""
   EXIT WHILE   #No.FUN-850030
END WHILE
#   CLOSE WINDOW gapq911_w                 #FUN-C80102
#No.FUN-A40009 --begin  
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF           
#No.FUN-A40009 --end 
 
   IF tm.b = 'Y' THEN
      CALL cl_set_comp_visible("pb_balf,pb_bal,npr11_pb",TRUE)
      CALL cl_set_comp_visible("npr11,df,d,cf,c,balf,bal",TRUE)
      CALL cl_set_comp_visible("npr11_d,npr11_c,npr11_bal",TRUE)
      CALL cl_getmsg("ggl-216",g_lang) RETURNING g_msg                          
      CALL cl_set_comp_att_text("pb_balf",g_msg CLIPPED)                        
      CALL cl_getmsg("ggl-217",g_lang) RETURNING g_msg                          
      CALL cl_set_comp_att_text("pb_bal",g_msg CLIPPED)
      CALL cl_getmsg("ggl-201",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("df",g_msg CLIPPED)
      CALL cl_getmsg("ggl-202",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-203",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("cf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-204",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-218",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("balf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-219",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   ELSE
      CALL cl_set_comp_visible("pb_balf,npr11_pb",FALSE)
      CALL cl_set_comp_visible("npr11,df,cf,balf",FALSE)
      CALL cl_set_comp_visible("npr11_d,npr11_c,npr11_bal",FALSE)
      CALL cl_getmsg("ggl-220",g_lang) RETURNING g_msg                          
      CALL cl_set_comp_att_text("pb_bal",g_msg CLIPPED)
      CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-221",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   END IF
  #IF tm.c = 'Y' THEN                             #FUN-C80102
   IF tm.e = 'Y' THEN                             #FUN-C80102
      CALL cl_set_comp_visible("npr11c",TRUE)                                                                                       
   ELSE
      CALL cl_set_comp_visible("npr11c",FALSE)
   END IF
   LET g_npr00 = NULL
   LET g_aag02 = NULL
   LET g_npr05 = NULL
   LET g_npr11 = NULL         #FUN-980120
   CLEAR FORM
   CALL g_npr.clear()
   CALL gapq911_cs()
END FUNCTION

 
FUNCTION gapq911()
   DEFINE l_name    LIKE type_file.chr20,   #NO FUN-690009 VARCHAR(20)       # External(Disk) file name
          l_sql     LIKE type_file.chr1000, #NO FUN-690009 VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000, #NO FUN-690009 VARCHAR(1000)
          l_i       LIKE type_file.num5,    #NO FUN-690009 SMALLINT
          l_qcyef   LIKE npr_file.npr06f,
          l_qcye    LIKE npr_file.npr06f,
          m_npr06f  LIKE npr_file.npr06f,
          m_npr07f  LIKE npr_file.npr07f,
          m_npr06   LIKE npr_file.npr06f,
          m_npr07   LIKE npr_file.npr07f,
          l_npr06f  LIKE npr_file.npr06f,
          l_npr06   LIKE npr_file.npr06f,
          l_npr07f  LIKE npr_file.npr06f,
          l_npr07   LIKE npr_file.npr06f,
          sr1       RECORD
                    npr00    LIKE npr_file.npr00,
                    npr01    LIKE npr_file.npr01,  #客戶
                    npr02    LIKE npr_file.npr02,  #簡稱
                    npr11    LIKE npr_file.npr11   #幣種
                    END RECORD,
          sr        RECORD
                    npr00    LIKE npr_file.npr00,  #科目
                    npr05    LIKE npr_file.npr05,  #期
                    npr01    LIKE npr_file.npr01,  #客戶
                    npr02    LIKE npr_file.npr02,  #簡稱
                    npr11    LIKE npr_file.npr11,  #幣種
                    npr06f   LIKE npr_file.npr06f,
                    npr06    LIKE npr_file.npr06 ,
                    npr07f   LIKE npr_file.npr07f,
                    npr07    LIKE npr_file.npr07 ,
                    qcyef    LIKE npr_file.npr06f,
                    qcye     LIKE npr_file.npr06f,
                    df_y     LIKE npr_file.npr06f,
                    d_y      LIKE npr_file.npr06f,
                    cf_y     LIKE npr_file.npr06f,
                    c_y      LIKE npr_file.npr06f
                    END RECORD
 
     LET g_prog = 'gapr911'
     CALL gapq911_table()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
     LET l_sql = " SELECT UNIQUE npr00,npr01,npr02,npr11 FROM npr_file ",
                 "  WHERE (npr08 = '",g_plant CLIPPED,"' OR npr08 IS NULL OR npr08 =' ')",    #No.TQC-8B0035
                 "    AND npr09 = '",tm.o    CLIPPED,"'",
                 "    AND npr01 <> ' ' ",   #MOD-D20156
                 "    AND ",tm.wc CLIPPED
     PREPARE gapq911_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gapq911_curs1 CURSOR FOR gapq911_pr1
 
    #IF tm.c = 'Y' THEN                  #FUN-C80102 
     IF tm.e = 'Y' THEN                                     
     LET l_sql1="SELECT npr00,npr05,npr01,npr02,npr11,SUM(npr06f),",
                "       SUM(npr06),SUM(npr07f),SUM(npr07),0,0,0,0,0,0 ",
                "  FROM npr_file ",
                " WHERE npr00 = ? AND npr01 = ? ",
                "   AND npr02 = ? AND npr11 = ? ",
                "   AND npr05 = ? ",
                "   AND (npr08 = '",g_plant CLIPPED,"' OR npr08 IS NULL OR npr08 =' ')",    #No.TQC-8B0035
                "   AND npr09 = '",tm.o    CLIPPED,"'",
                "   AND npr04 = ",tm.yy,
                "   AND ",tm.wc CLIPPED,
                " GROUP BY npr00,npr01,npr02,npr11,npr05 ",
                " ORDER BY npr00,npr01,npr02,npr11,npr05 "
     ELSE
     LET l_sql1="SELECT npr00,npr05,npr01,npr02,npr11,SUM(npr06f),",
                "       SUM(npr06),SUM(npr07f),SUM(npr07),0,0,0,0,0,0 ",
                "  FROM npr_file ",
                " WHERE npr00 = ? AND npr01 = ? ",
                "   AND npr02 = ? AND npr11 = ? ",
                "   AND npr05 = ? ",
                "   AND (npr08 = '",g_plant CLIPPED,"' OR npr08 IS NULL OR npr08 =' ')",    #No.TQC-8B0035
                "   AND npr09 = '",tm.o    CLIPPED,"'",
                "   AND npr04 = ",tm.yy,
                "   AND ",tm.wc CLIPPED,
                " GROUP BY npr00,npr05,npr01,npr02,npr11 ",
                " ORDER BY npr00,npr05,npr01,npr02,npr11 "
     END IF                                                                            #FUN-980120--Add
                
     PREPARE gapq911_prepare1 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gapq911_cursd CURSOR FOR gapq911_prepare1
     IF SQLCA.sqlcode THEN
        CALL cl_err('declare',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
 
     CALL cl_outnam('gapr911') RETURNING l_name  #NO.TQC-650054
    #IF tm.c = 'Y' THEN                          #FUN-980120  #FUN-C80102
     IF tm.e = 'Y' THEN                                       #FUN-C80102
        START REPORT gapq911_rep1 TO l_name      #FUN-980120  
     ELSE                                        #FUN-980120
        START REPORT gapq911_rep TO l_name
     END IF                                      #FUN-980120
     LET g_pageno = 0
 
     LET t_qcyef   = 0
     LET t_qcye    = 0
     LET t_npr06f  = 0
     LET t_npr07f  = 0
     LET t_npr06   = 0
     LET t_npr07   = 0
 
     FOREACH gapq911_curs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
                                                                                
       #計算期初余額及期間異動
       LET g_null = ''
       CALL q911_qcye_qjyd(sr1.npr01,sr1.npr02,sr1.npr00,sr1.npr11,tm.m1,tm.m2) 
            RETURNING g_null                                                    
                                                                                
       #IF tm.d = 'N' THEN   #期初為零且無異動不打印                         #FUN-C80102
        IF tm.f = 'N' THEN   #期初為零且無異動不打印                         #FUN-C80102 
          IF g_null = 'N' THEN                                                  
             CONTINUE FOREACH                                                   
          END IF                                                                
       END IF
 
       FOR l_i = tm.m1 TO tm.m2
           LET g_test = g_test + 1       #No.FUN-CB0146 Add
           LET g_print = 'N'
           FOREACH gapq911_cursd USING sr1.npr00,sr1.npr01,sr1.npr02,
                                       sr1.npr11,l_i INTO sr.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,0)
                 EXIT FOREACH
              END IF
              LET g_print = 'Y'
              IF cl_null(sr.npr06f) THEN LET sr.npr06f = 0 END IF
              IF cl_null(sr.npr07f) THEN LET sr.npr07f = 0 END IF
              IF cl_null(sr.npr06)  THEN LET sr.npr06 = 0 END IF
              IF cl_null(sr.npr07)  THEN LET sr.npr07 = 0 END IF              
             #IF tm.c = 'Y' THEN                                    #FUN-C80102
              IF tm.e = 'Y' THEN                                    #FUN-C80102
                 OUTPUT TO REPORT gapq911_rep1(sr.*)
              ELSE
              	 OUTPUT TO REPORT gapq911_rep(sr.*)
              END IF	    
           END FOREACH
           IF g_print = 'N' THEN
              CALL q911_qcye_qjyd(sr1.npr01,sr1.npr02,sr1.npr00,
                                  sr1.npr11,l_i,l_i)
                   RETURNING g_null                                             
             # IF tm.d = 'N' THEN   #期初為零且無異動不打印            #FUN-C80102
             IF tm.f = 'N' THEN   #期初為零且無異動不打印                         #FUN-C80102
                 IF g_null = 'N' THEN                                           
                    CONTINUE FOR                                                
                 END IF                                                         
              END IF                                                            
              INITIALIZE sr.* TO NULL
              LET sr.npr00  = sr1.npr00
              LET sr.npr05  = l_i 
              LET sr.npr01  = sr1.npr01
              LET sr.npr02  = sr1.npr02
              LET sr.npr11  = sr1.npr11
              LET sr.npr06f = 0
              LET sr.npr07f = 0
              LET sr.npr06  = 0
              LET sr.npr07  = 0
            # IF tm.c = 'Y' THEN    #FUN-C80102
              IF tm.e = 'Y' THEN    #FUN-C80102
                 OUTPUT TO REPORT gapq911_rep1(sr.*)
              ELSE
              	 OUTPUT TO REPORT gapq911_rep(sr.*)
              END IF	    
           END IF
       END FOR
     END FOREACH
 
     
    #IF tm.c = 'Y' THEN                          #FUN-980120  #FUN-C80102
     IF tm.e = 'Y' THEN    #FUN-C80102
        FINISH REPORT gapq911_rep1               #FUN-980120  
     ELSE                                        #FUN-980120
        FINISH REPORT gapq911_rep
     END IF                                      #FUN-980120     
     LET g_prog = 'gapq911'
     DISPLAY "No.: ",g_test    #No.FUN-CB0146 Add
END FUNCTION
 
REPORT gapq911_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(1)
          sr        RECORD
                    npr00    LIKE npr_file.npr00,  #科目
                    npr05    LIKE npr_file.npr05,  #期
                    npr01    LIKE npr_file.npr01,  #客戶
                    npr02    LIKE npr_file.npr02,  #簡稱
                    npr11    LIKE npr_file.npr11,  #幣種
                    npr06f   LIKE npr_file.npr06f,
                    npr06    LIKE npr_file.npr06 ,
                    npr07f   LIKE npr_file.npr07f,
                    npr07    LIKE npr_file.npr07 ,
                    qcyef    LIKE npr_file.npr06f,
                    qcye     LIKE npr_file.npr06f,
                    df_y     LIKE npr_file.npr06f,
                    d_y      LIKE npr_file.npr06f,
                    cf_y     LIKE npr_file.npr06f,
                    c_y      LIKE npr_file.npr06f
                    END RECORD,
          l_cnt                        LIKE type_file.num5,
          l_npr06f                     LIKE npr_file.npr06f,
          l_npr06                      LIKE npr_file.npr06f,
          l_npr07f                     LIKE npr_file.npr06f,
          l_npr07                      LIKE npr_file.npr06f,
          t_bal,t_balf                 LIKE npr_file.npr06f,                    
          n_bal,n_balf                 LIKE npr_file.npr06f,
          n_pb_bal,n_pb_balf           LIKE npr_file.npr06f,                    
          l_pb_dc                      LIKE type_file.chr10,                    
          pb_bal,pb_balf               LIKE npr_file.npr06f,#期初               
          tt_pb_bal,tt_pb_balf         LIKE npr_file.npr06f,                    
          tt_bal                       LIKE npr_file.npr06f,
          l_d,l_df,l_c,l_cf            LIKE npr_file.npr06f,                    
          y_d,y_df,y_c,y_cf            LIKE npr_file.npr06f,                    
          y_pb_bal,y_bal               LIKE npr_file.npr06f,  #合計
          l_npr11_c,l_npr11_d          LIKE npq_file.npq25,                  
          l_npr11_pb,l_npr11_bal       LIKE npq_file.npq25,                  
          pb_dc                        LIKE type_file.chr10,
          l_dc                         LIKE type_file.chr10 
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.npr00,sr.npr05,sr.npr01,sr.npr02,sr.npr11
  FORMAT
   PAGE HEADER
        LET g_pageno = g_pageno + 1
 
   BEFORE GROUP OF sr.npr00     
      LET l_aag02 = Null   #No.FUN-CB0146 Add
      SELECT aag02 INTO l_aag02 FROM aag_file
       WHERE aag00 = tm.o
         AND aag01 = sr.npr00
 
   BEFORE GROUP OF sr.npr05
      LET y_pb_bal = 0
      LET y_bal = 0
 
   BEFORE GROUP OF sr.npr02
      LET tt_pb_bal  = 0   #期初BY客戶匯總 tm.b = 'Y'
      LET tt_bal     = 0   #期末BY客戶匯總 tm.b = 'Y'
 
      IF tm.b = 'N' THEN  #不打印外幣
         #期初余額 pb_dc,pb_bal
         LET l_npr06f = 0  LET l_npr07f = 0
         LET l_npr06 = 0  LET l_npr07 = 0
         SELECT SUM(npr06),SUM(npr07)  #期初余額
           INTO l_npr06,l_npr07
           FROM npr_file
          WHERE npr00 = sr.npr00 
            AND npr01 = sr.npr01 AND npr02 = sr.npr02
            AND npr04 = tm.yy    AND npr05 < sr.npr05
            AND (npr08 = g_plant OR npr08 IS NULL OR npr08 =' ') AND npr09 = tm.o   #No.TQC-8B0035
         IF cl_null(l_npr06) THEN LET l_npr06 = 0 END IF
         IF cl_null(l_npr07) THEN LET l_npr07 = 0 END IF
         LET pb_bal  = l_npr06 - l_npr07
      END IF
 
   ON EVERY ROW
      IF tm.b = 'Y' THEN
         #期初余額 pb_dc,pb_balf,pb_bal
         LET l_npr06f = 0  LET l_npr07f = 0
         LET l_npr06 = 0  LET l_npr07 = 0
         SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07)  #期初余額
           INTO l_npr06f,l_npr07f,l_npr06,l_npr07
           FROM npr_file
          WHERE npr00 = sr.npr00 
            AND npr01 = sr.npr01 AND npr02 = sr.npr02
            AND npr11 = sr.npr11
            AND npr04 = tm.yy    AND npr05 < sr.npr05
            AND (npr08 = g_plant OR npr08 IS NULL OR npr08 =' ') AND npr09 = tm.o   #No.TQC-8B0035
         IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
         IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
         IF cl_null(l_npr06) THEN LET l_npr06 = 0 END IF
         IF cl_null(l_npr07) THEN LET l_npr07 = 0 END IF
         LET pb_balf = l_npr06f - l_npr07f
         LET pb_bal  = l_npr06 - l_npr07
         IF pb_bal > 0 THEN
            LET n_pb_bal = pb_bal
            LET n_pb_balf= pb_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
         ELSE
            IF pb_bal = 0 THEN
               LET n_pb_bal = pb_bal
               LET n_pb_balf= pb_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
            ELSE
               LET n_pb_bal = pb_bal * -1
               LET n_pb_balf= pb_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
            END IF
         END IF
 
         LET tt_pb_balf = tt_pb_balf + pb_balf
         LET tt_pb_bal  = tt_pb_bal  + pb_bal 
         LET y_pb_bal = y_pb_bal + pb_bal
 
         #期間
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file    
          WHERE azi01 = sr.npr11
         IF cl_null(sr.npr06f) THEN LET sr.npr06f = 0 END IF
         IF cl_null(sr.npr07f) THEN LET sr.npr07f = 0 END IF
         IF cl_null(sr.npr06) THEN LET sr.npr06 = 0 END IF
         IF cl_null(sr.npr07) THEN LET sr.npr07 = 0 END IF
 
         #期末
         LET t_bal   = sr.npr06 - sr.npr07 + pb_bal
         LET t_balf  = sr.npr06f - sr.npr07f + pb_balf
 
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
 
         LET tt_bal  = tt_bal  + t_bal
         LET l_npr11_d = sr.npr06 / sr.npr06f
         LET l_npr11_c = sr.npr07 / sr.npr07f
         LET l_npr11_bal = n_bal / n_balf
         LET l_npr11_pb  = n_pb_bal / n_pb_balf
         IF cl_null(l_npr11_pb)  THEN LET l_npr11_pb  = 0 END IF
         IF cl_null(l_npr11_bal) THEN LET l_npr11_bal = 0 END IF
         IF cl_null(l_npr11_d) THEN LET l_npr11_d = 0 END IF
         IF cl_null(l_npr11_c) THEN LET l_npr11_c = 0 END IF
         INSERT INTO gapq911_tmp
         VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,sr.npr11,'2',
                l_pb_dc,n_pb_balf,l_npr11_pb,n_pb_bal,
                '',sr.npr06f,l_npr11_d,sr.npr06,sr.npr07f,l_npr11_c,sr.npr07,
                l_dc,n_balf,l_npr11_bal,n_bal,
                t_azi04,t_azi05,t_azi07)
         PRINT
      END IF
 
   AFTER GROUP OF sr.npr02
      IF tm.b = 'N' THEN
         #期初
         IF pb_bal > 0 THEN
            LET n_pb_bal = pb_bal
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
         ELSE
            IF pb_bal = 0 THEN
               LET n_pb_bal = pb_bal
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
            ELSE
               LET n_pb_bal = pb_bal * -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
            END IF
         END IF
 
         LET y_pb_bal = y_pb_bal + pb_bal
 
         #期間
         LET l_d = GROUP SUM(sr.npr06) 
         LET l_c = GROUP SUM(sr.npr07) 
         IF cl_null(l_d)  THEN LET l_d  = 0 END IF
         IF cl_null(l_c)  THEN LET l_c  = 0 END IF
 
         #期末
         LET t_bal   = l_d  - l_c  + pb_bal
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
 
         #type = '2' #本期
         INSERT INTO gapq911_tmp
         VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,'','2',
                l_pb_dc,0,0,n_pb_bal,
                '',0,0,l_d,0,0,l_c,
                l_dc,0,0,n_bal,
                t_azi04,t_azi05,t_azi07)
         PRINT
      ELSE
         LET l_cnt = GROUP COUNT(*)
         IF l_cnt > 1 THEN
            #打印客戶小計
            #期初
            IF tt_pb_bal > 0 THEN
               LET n_pb_bal = tt_pb_bal
               CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
            ELSE
               IF tt_pb_bal = 0 THEN
                  LET n_pb_bal = tt_pb_bal
                  CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
               ELSE
                  LET n_pb_bal = tt_pb_bal * -1
                  CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
               END IF
            END IF
 
            #期間
            LET l_d = GROUP SUM(sr.npr06) 
            LET l_c = GROUP SUM(sr.npr07) 
            IF cl_null(l_d)  THEN LET l_d  = 0 END IF
            IF cl_null(l_c)  THEN LET l_c  = 0 END IF
 
            #期末
            LET t_bal   = l_d  - l_c  + tt_pb_bal
 
            IF t_bal > 0 THEN
               LET n_bal = t_bal
               CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
            ELSE
               IF t_bal = 0 THEN
                  LET n_bal = t_bal
                  CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
               ELSE
                  LET n_bal = t_bal * -1
                  CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
               END IF
            END IF
 
            #type = '3' #客戶合計
            CALL cl_getmsg('ggl-224',g_lang) RETURNING g_msg
            INSERT INTO gapq911_tmp
            VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,'','3',
                   l_pb_dc,0,0,n_pb_bal,
                   g_msg,0,0,l_d,0,0,l_c,
                   l_dc,0,0,n_bal,
                   t_azi04,t_azi05,t_azi07)
         END IF
      END IF
 
   AFTER GROUP OF sr.npr05
      #期初
      IF y_pb_bal > 0 THEN
         LET n_pb_bal = y_pb_bal
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
      ELSE
         IF y_pb_bal = 0 THEN
            LET n_pb_bal = y_pb_bal
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
         ELSE
            LET n_pb_bal = y_pb_bal * -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
         END IF
      END IF
 
      LET y_d = GROUP SUM(sr.npr06) 
      LET y_c = GROUP SUM(sr.npr07) 
      IF cl_null(y_d)  THEN LET y_d  = 0 END IF
      IF cl_null(y_c)  THEN LET y_c  = 0 END IF
 
      #期末
       LET t_bal   = y_d  - y_c  + y_pb_bal   #No.MOD-920083 mod  by liuxqa
 
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
      CALL cl_getmsg('ggl-223',g_lang) RETURNING g_msg
      INSERT INTO gapq911_tmp
      VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,'','4',
             l_pb_dc,0,0,n_pb_bal,
             g_msg,0,0,y_d,0,0,y_c,
             l_dc,0,0,n_bal,
             t_azi04,t_azi05,t_azi07)
 
END REPORT
 
REPORT gapq911_rep1(sr)
   DEFINE l_last_sw LIKE type_file.chr1,     
          sr        RECORD
                    npr00    LIKE npr_file.npr00,  #科目
                    npr05    LIKE npr_file.npr05,  #期
                    npr01    LIKE npr_file.npr01,  #客戶
                    npr02    LIKE npr_file.npr02,  #簡稱
                    npr11    LIKE npr_file.npr11,  #幣種
                    npr06f   LIKE npr_file.npr06f,
                    npr06    LIKE npr_file.npr06 ,
                    npr07f   LIKE npr_file.npr07f,
                    npr07    LIKE npr_file.npr07 ,
                    qcyef    LIKE npr_file.npr06f,
                    qcye     LIKE npr_file.npr06f,
                    df_y     LIKE npr_file.npr06f,
                    d_y      LIKE npr_file.npr06f,
                    cf_y     LIKE npr_file.npr06f,
                    c_y      LIKE npr_file.npr06f
                    END RECORD,
          l_cnt                        LIKE type_file.num5,
          l_npr06f                     LIKE npr_file.npr06f,
          l_npr06                      LIKE npr_file.npr06f,
          l_npr07f                     LIKE npr_file.npr06f,
          l_npr07                      LIKE npr_file.npr06f,
          t_bal,t_balf                 LIKE npr_file.npr06f,                    
          n_bal,n_balf                 LIKE npr_file.npr06f,
          n_pb_bal,n_pb_balf           LIKE npr_file.npr06f,                    
          l_pb_dc                      LIKE type_file.chr10,                    
          pb_bal,pb_balf               LIKE npr_file.npr06f,#期初               
          tt_pb_bal,tt_pb_balf         LIKE npr_file.npr06f,                    
          tt_bal                       LIKE npr_file.npr06f,
          l_d,l_df,l_c,l_cf            LIKE npr_file.npr06f,                    
          y_d,y_df,y_c,y_cf            LIKE npr_file.npr06f,                    
          y_pb_bal,y_pb_balf           LIKE npr_file.npr06f,  #合計
          l_npr11_c,l_npr11_d          LIKE npq_file.npq25,                  
          l_npr11_pb,l_npr11_bal       LIKE npq_file.npq25,                  
          pb_dc                        LIKE type_file.chr10,
          l_dc                         LIKE type_file.chr10
          
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.npr00,sr.npr11,sr.npr05,sr.npr01,sr.npr02
  FORMAT
   PAGE HEADER
        LET g_pageno = g_pageno + 1
 
   BEFORE GROUP OF sr.npr00     
      SELECT aag02 INTO l_aag02 FROM aag_file
       WHERE aag00 = tm.o
         AND aag01 = sr.npr00       
 
   BEFORE GROUP OF sr.npr11
      LET y_pb_bal = 0
      LET y_pb_balf = 0
 
   BEFORE GROUP OF sr.npr05
      LET y_pb_bal = 0
      LET y_pb_balf = 0
 
   BEFORE GROUP OF sr.npr01
      LET tt_pb_bal  = 0   
      LET tt_bal     = 0               
 
   ON EVERY ROW
      IF tm.b = 'Y' THEN
         #期初余額 pb_dc,pb_balf,pb_bal
         LET l_npr06f = 0  LET l_npr07f = 0
         LET l_npr06 = 0  LET l_npr07 = 0
         SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07)  #期初余額
           INTO l_npr06f,l_npr07f,l_npr06,l_npr07
           FROM npr_file
          WHERE npr00 = sr.npr00 
            AND npr01 = sr.npr01 AND npr02 = sr.npr02
            AND npr11 = sr.npr11
            AND npr04 = tm.yy    AND npr05 < sr.npr05
            AND (npr08 = g_plant OR npr08 IS NULL OR npr08 =' ') AND npr09 = tm.o
         IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
         IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
         IF cl_null(l_npr06) THEN LET l_npr06 = 0 END IF
         IF cl_null(l_npr07) THEN LET l_npr07 = 0 END IF
         LET pb_balf = l_npr06f - l_npr07f
         LET pb_bal  = l_npr06 - l_npr07
         IF pb_bal > 0 THEN
            LET n_pb_bal = pb_bal
            LET n_pb_balf= pb_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
         ELSE
            IF pb_bal = 0 THEN
               LET n_pb_bal = pb_bal
               LET n_pb_balf= pb_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
            ELSE
               LET n_pb_bal = pb_bal * -1
               LET n_pb_balf= pb_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
            END IF
         END IF
 
         LET tt_pb_balf = tt_pb_balf + pb_balf
         LET tt_pb_bal  = tt_pb_bal  + pb_bal 
         LET y_pb_bal = y_pb_bal + pb_bal
         LET y_pb_balf = y_pb_balf + pb_balf
 
         #期間
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file    
          WHERE azi01 = sr.npr11
         IF cl_null(sr.npr06f) THEN LET sr.npr06f = 0 END IF
         IF cl_null(sr.npr07f) THEN LET sr.npr07f = 0 END IF
         IF cl_null(sr.npr06) THEN LET sr.npr06 = 0 END IF
         IF cl_null(sr.npr07) THEN LET sr.npr07 = 0 END IF
 
         #期末
         LET t_bal   = sr.npr06 - sr.npr07 + pb_bal
         LET t_balf  = sr.npr06f - sr.npr07f + pb_balf
 
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
 
         LET tt_bal  = tt_bal  + t_bal
         LET l_npr11_d = sr.npr06 / sr.npr06f
         LET l_npr11_c = sr.npr07 / sr.npr07f
         LET l_npr11_bal = n_bal / n_balf
         LET l_npr11_pb  = n_pb_bal / n_pb_balf
 
         IF cl_null(l_npr11_pb)  THEN LET l_npr11_pb  = 0 END IF
         IF cl_null(l_npr11_bal) THEN LET l_npr11_bal = 0 END IF
         IF cl_null(l_npr11_d) THEN LET l_npr11_d = 0 END IF
         IF cl_null(l_npr11_c) THEN LET l_npr11_c = 0 END IF
         INSERT INTO gapq911_tmp
         VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,sr.npr11,'2',
                l_pb_dc,n_pb_balf,l_npr11_pb,n_pb_bal,
                '',sr.npr06f,l_npr11_d,sr.npr06,sr.npr07f,l_npr11_c,sr.npr07,
                l_dc,n_balf,l_npr11_bal,n_bal,
                t_azi04,t_azi05,t_azi07)
      END IF
 
             
   AFTER GROUP OF sr.npr05
      #期初
      IF y_pb_bal > 0 THEN
         LET n_pb_bal = y_pb_bal
         LET n_pb_balf = y_pb_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
      ELSE
         IF y_pb_bal = 0 THEN
            LET n_pb_bal = y_pb_bal
            LET n_pb_balf = y_pb_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
         ELSE
            LET n_pb_bal = y_pb_bal * -1
            LET n_pb_balf = y_pb_balf * -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
         END IF
      END IF
 
      LET y_d = GROUP SUM(sr.npr06) 
      LET y_c = GROUP SUM(sr.npr07) 
      IF cl_null(y_d)  THEN LET y_d  = 0 END IF
      IF cl_null(y_c)  THEN LET y_c  = 0 END IF
      
      LET y_df = GROUP SUM(sr.npr06f) 
      LET y_cf = GROUP SUM(sr.npr07f) 
      IF cl_null(y_df)  THEN LET y_df  = 0 END IF
      IF cl_null(y_cf)  THEN LET y_cf  = 0 END IF      
 
      #期末
       LET t_bal   = y_d  - y_c  + y_pb_bal
       LET t_balf   = y_df  - y_cf  + y_pb_balf   
 
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf = t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf = t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf = t_balf * -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
      CALL cl_getmsg('ggl-223',g_lang) RETURNING g_msg
      INSERT INTO gapq911_tmp
      VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,sr.npr11,'4',
             l_pb_dc,n_pb_balf,l_npr11_pb,n_pb_bal,
             g_msg,y_df,0,y_d,y_cf,0,y_c,
             l_dc,n_balf,l_npr11_bal,n_bal,
             t_azi04,t_azi05,t_azi07)                   
 
END REPORT
 
FUNCTION q911_out()
END FUNCTION
 
FUNCTION gapq911_table()
     DROP TABLE gapq911_tmp;
     #FUN-D50056--mark--str--
     #CREATE TEMP TABLE gapq911_tmp(
     #               npr00       LIKE npr_file.npr00,
     #               aag02       LIKE aag_file.aag02,
     #               npr05       LIKE npr_file.npr05,
     #               npr01       LIKE npr_file.npr01,
     #               npr02       LIKE npr_file.npr02,
     #               npr11       LIKE npr_file.npr11,
     #               type        LIKE type_file.chr1,
     #               pb_dc       LIKE type_file.chr10,
     #               pb_balf     LIKE npr_file.npr06,
     #               npr11_pb    LIKE npq_file.npq25,
     #               pb_bal      LIKE npr_file.npr06,
     #               memo        LIKE type_file.chr50,
     #               df          LIKE npr_file.npr06,
     #               npr11_d     LIKE npq_file.npq25,
     #               d           LIKE npr_file.npr06,
     #               cf          LIKE npr_file.npr06,
     #               npr11_c     LIKE npq_file.npq25,
     #               c           LIKE npr_file.npr06,
     #               dc          LIKE type_file.chr10,
     #               balf        LIKE npr_file.npr06,
     #               npr11_bal   LIKE npq_file.npq25,
     #               bal         LIKE npr_file.npr06,
     #               azi04       LIKE azi_file.azi04,
     #               azi05       LIKE azi_file.azi05,
     #               azi07       LIKE azi_file.azi07);
     #FUN-D50056--mark--end--
     #FUN-D50056--add--str--
     CREATE TEMP TABLE gapq911_tmp(
                    npr00       LIKE npr_file.npr00,
                    aag02       LIKE aag_file.aag02,
                    npr01       LIKE npr_file.npr01,
                    npr02       LIKE npr_file.npr02,
                    npr11       LIKE npr_file.npr11,
                    type        LIKE type_file.chr1,
                    pb_dc       LIKE type_file.chr10,
                    pb_balf     LIKE npr_file.npr06,
                    npr11_pb    LIKE npq_file.npq25,
                    pb_bal      LIKE npr_file.npr06,
                    memo        LIKE type_file.chr50,
                    df          LIKE npr_file.npr06,
                    npr11_d     LIKE npq_file.npq25,
                    d           LIKE npr_file.npr06,
                    cf          LIKE npr_file.npr06,
                    npr11_c     LIKE npq_file.npq25,
                    c           LIKE npr_file.npr06,
                    dc          LIKE type_file.chr10,
                    balf        LIKE npr_file.npr06,
                    npr11_bal   LIKE npq_file.npq25,
                    bal         LIKE npr_file.npr06,
                    azi04       LIKE azi_file.azi04,
                    azi05       LIKE azi_file.azi05,
                    azi07       LIKE azi_file.azi07);
      #FUN-D50056--add--end--    
END FUNCTION
 
FUNCTION q911_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npr TO s_npr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#No.FUN-A40009 --begin
         IF g_rec_b != 0 AND l_ac != 0 THEN  
            CALL fgl_set_arr_curr(l_ac)     
         END IF                            
#No.FUN-A40009 --end
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION drill_detail
         LET g_action_choice="drill_detail"
         EXIT DISPLAY
 
      ON ACTION first
         CALL gapq911_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION previous
         CALL gapq911_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL gapq911_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL gapq911_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL gapq911_fetch('L')
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
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
 
FUNCTION gapq911_cs() 
  #IF tm.c = 'Y' THEN                                                         #FUN-980120   #FUN-C80102
    IF tm.e = 'Y' THEN                                  #FUN-C80102
     #LET g_sql = "SELECT UNIQUE npr00,aag02,npr05,npr11 FROM gapq911_tmp ",   #FUN-980120    #FUN-D50056 mark
     #            " ORDER BY npr00,aag02,npr11,npr05"                          #FUN-980120    #FUN-D50056 mark
     LET g_sql = "SELECT UNIQUE npr00,aag02,npr11 FROM gapq911_tmp ",                         #FUN-D50056 add
                 " ORDER BY npr00,aag02,npr11"                                                #FUN-D50056 add     LET g_sql = "SELECT UNIQUE npr00,aag02,npr05,npr11 FROM gapq911_tmp ",   #FUN-980120
   ELSE                                                                       #FUN-980120
     #LET g_sql = "SELECT UNIQUE npr00,aag02,npr05 FROM gapq911_tmp ",         #FUN-D50056 mark
     #            " ORDER BY npr00,aag02,npr05"                                #FUN-D50056 mark
     LET g_sql = "SELECT UNIQUE npr00,aag02 FROM gapq911_tmp ",                #FUN-D50056 add
                 " ORDER BY npr00,aag02"                                       #FUN-D50056 add
   END IF                                                                     #FUN-980120 
     PREPARE gapq911_ps FROM g_sql
     DECLARE gapq911_curs SCROLL CURSOR WITH HOLD FOR gapq911_ps
 
   #IF tm.c = 'Y' THEN                                                         #FUN-980120  #FUN-C80102
   IF tm.e = 'Y' THEN                                  #FUN-C80102
     #LET g_sql = "SELECT UNIQUE npr00,aag02,npr05,npr11 FROM gapq911_tmp ",   #FUN-980120    #FUN-D50056 mark
     #            "  INTO TEMP x "                                             #FUN-980120    #FUN-D50056 mark
     LET g_sql = "SELECT UNIQUE npr00,aag02,npr11 FROM gapq911_tmp ",          #FUN-D50056 add
                 "  INTO TEMP x "                                              #FUN-D50056 add
   ELSE                                                                       #FUN-980120 
     #LET g_sql = "SELECT UNIQUE npr00,aag02,npr05 FROM gapq911_tmp ",         #FUN-D50056 mark
     #            "  INTO TEMP x "   	                                       #FUN-D50056 mark
     LET g_sql = "SELECT UNIQUE npr00,aag02 FROM gapq911_tmp ",          #FUN-D50056 add
                 "  INTO TEMP x "                                              #FUN-D50056 add	              
   END IF                                                                     #FUN-980120
   
     DROP TABLE x     
     PREPARE gapq911_ps1 FROM g_sql
     EXECUTE gapq911_ps1
 
     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gapq911_ps2 FROM g_sql
     DECLARE gapq911_cnt CURSOR FOR gapq911_ps2
 
     OPEN gapq911_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gapq911_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gapq911_cnt 
        FETCH gapq911_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gapq911_fetch('F')
     END IF
END FUNCTION
 
FUNCTION gapq911_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680126 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680126 INTEGER
   
  #IF tm.c = 'Y' THEN                                                         #FUN-980120      #FUN-C80102
  IF tm.e = 'Y' THEN                                                                           #FUN-C80102 
   CASE p_flag
      #FUN-D50056--mark--str--
      #WHEN 'N' FETCH NEXT     gapq911_curs INTO g_npr00,g_aag02,g_npr05,g_npr11    #FUN-980120 Add npr11
      #WHEN 'P' FETCH PREVIOUS gapq911_curs INTO g_npr00,g_aag02,g_npr05,g_npr11    #FUN-980120 Add npr11
      #WHEN 'F' FETCH FIRST    gapq911_curs INTO g_npr00,g_aag02,g_npr05,g_npr11    #FUN-980120 Add npr11
      #WHEN 'L' FETCH LAST     gapq911_curs INTO g_npr00,g_aag02,g_npr05,g_npr11    #FUN-980120 Add npr11
      #FUN-D50056--mark--end--
      #FUN-D50056--add--str--
      WHEN 'N' FETCH NEXT     gapq911_curs INTO g_npr00,g_aag02,g_npr11    
      WHEN 'P' FETCH PREVIOUS gapq911_curs INTO g_npr00,g_aag02,g_npr11    
      WHEN 'F' FETCH FIRST    gapq911_curs INTO g_npr00,g_aag02,g_npr11    
      WHEN 'L' FETCH LAST     gapq911_curs INTO g_npr00,g_aag02,g_npr11 
      #FUN-D50056--add--end--
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
 
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
 
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         #FETCH ABSOLUTE g_jump gapq911_curs INTO g_npr00,g_aag02,g_npr05,g_npr11    #FUN-980120 Add npr11  #FUN-D50056 mark
         FETCH ABSOLUTE g_jump gapq911_curs INTO g_npr00,g_aag02,g_npr11      #FUN-D50056 add          FETCH ABSOLUTE g_jump gapq911_curs INTO g_npr00,g_aag02,g_npr05,g_npr11    #FUN-980120 Add npr11
         LET mi_no_ask = FALSE
   END CASE
   ELSE
   CASE p_flag
      #FUN-D50056--mark--str--
      #WHEN 'N' FETCH NEXT     gapq911_curs INTO g_npr00,g_aag02,g_npr05
      #WHEN 'P' FETCH PREVIOUS gapq911_curs INTO g_npr00,g_aag02,g_npr05
      #WHEN 'F' FETCH FIRST    gapq911_curs INTO g_npr00,g_aag02,g_npr05
      #WHEN 'L' FETCH LAST     gapq911_curs INTO g_npr00,g_aag02,g_npr05
      #FUN-D50056--mark--end--
      #FUN-D50056--add--str--
      WHEN 'N' FETCH NEXT     gapq911_curs INTO g_npr00,g_aag02
      WHEN 'P' FETCH PREVIOUS gapq911_curs INTO g_npr00,g_aag02
      WHEN 'F' FETCH FIRST    gapq911_curs INTO g_npr00,g_aag02
      WHEN 'L' FETCH LAST     gapq911_curs INTO g_npr00,g_aag02
      #FUN-D50056--add--end--
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
 
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
 
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         #FETCH ABSOLUTE g_jump gapq911_curs INTO g_npr00,g_aag02,g_npr05     #FUN-D50056 mark    
         FETCH ABSOLUTE g_jump gapq911_curs INTO g_npr00,g_aag02              #FUN-D50056 add            FETCH ABSOLUTE g_jump gapq911_curs INTO g_npr00,g_aag02,g_npr05
         LET mi_no_ask = FALSE
   END CASE   
   END IF
   
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npr00,SQLCA.sqlcode,0)
      INITIALIZE g_npr00 TO NULL
      INITIALIZE g_aag02 TO NULL
      INITIALIZE g_npr05 TO NULL
     #IF tm.c = 'Y' THEN                                                   #FUN-980120  #FUN-C80102
      IF tm.e = 'Y' THEN                                                                #FUN-C80102
         INITIALIZE g_npr11 TO NULL                                        #FUN-980120
      END IF                                                               #FUN-980120
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump #CKP3
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   CALL gapq911_show()
END FUNCTION
 
FUNCTION gapq911_show()
 
  #DISPLAY g_npr00 TO npr00                              #FUN-C80102
  #DISPLAY g_aag02 TO aag02                              #FUN-C80102
   DISPLAY tm.yy   TO yy
   DISPLAY g_npr05 TO mm
   DISPLAY g_npr11 TO npr11c                             #FUN-980120 Add
   #FUN-C80102--add--str---
   DISPLAY tm.o    TO o
   DISPLAY tm.m1   TO m1
   DISPLAY tm.m2   TO m2
   DISPLAY tm.b    TO b
   DISPLAY tm.f    TO f
   DISPLAY tm.e    TO e
   #FUN-C80102--add---end--
   CALL gapq911_b_fill()
 
   CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION gapq911_b_fill()                     #BODY FILL UP
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1
  DEFINE  l_memo     LIKE abb_file.abb04 
 
  # IF tm.c = 'Y' THEN                                                         #FUN-980120   #FUN-C80102
  IF tm.e = 'Y'   THEN                                                                        #FUN-C80102
   LET g_sql = "SELECT npr00,aag02,npr01,npr02,npr11,",                          #FUN-C80102 add  npr00,aag02
               "       pb_dc,pb_balf,npr11_pb,pb_bal,",
               "       df,npr11_d,d,cf,npr11_c,c,",
               "       dc,balf,npr11_bal,bal,",
               "       azi04,azi05,azi07,type,memo ",
               " FROM gapq911_tmp",
               " WHERE npr00 ='",g_npr00,"'",
               #"   AND npr05 ='",g_npr05,"'",   #FUN-D50056 mark               "   AND npr05 ='",g_npr05,"'",
               "   AND npr11 ='",g_npr11,"'",                                 #FUN-980120
               " ORDER BY npr01,npr02,npr11,type "
   ELSE
   LET g_sql = "SELECT npr00,aag02,npr01,npr02,npr11,",                       #FUN-C80102 add  npr00,aag02
               "       pb_dc,pb_balf,npr11_pb,pb_bal,",
               "       df,npr11_d,d,cf,npr11_c,c,",
               "       dc,balf,npr11_bal,bal,",
               "       azi04,azi05,azi07,type,memo ",
               " FROM gapq911_tmp",
               " WHERE npr00 ='",g_npr00,"'",
               #"   AND npr05 ='",g_npr05,"'",    #FUN-D50056 mark               "   AND npr05 ='",g_npr05,"'",
               " ORDER BY npr01,npr02,npr11,type "
   END IF
 
   PREPARE gapq911_pb FROM g_sql
   DECLARE npr_curs  CURSOR FOR gapq911_pb        #CURSOR
   CALL g_npr.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH npr_curs INTO g_npr[g_cnt].*,t_azi04,t_azi05,t_azi07,l_type,l_memo
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_npr[g_cnt].d      = cl_numfor(g_npr[g_cnt].d,20,g_azi04)
      LET g_npr[g_cnt].c      = cl_numfor(g_npr[g_cnt].c,20,g_azi04)
      LET g_npr[g_cnt].bal    = cl_numfor(g_npr[g_cnt].bal,20,g_azi04)
      LET g_npr[g_cnt].pb_bal = cl_numfor(g_npr[g_cnt].pb_bal,20,g_azi04)
 
      LET g_npr[g_cnt].df  = cl_numfor(g_npr[g_cnt].df,20,t_azi04)
      LET g_npr[g_cnt].cf  = cl_numfor(g_npr[g_cnt].cf,20,t_azi04)
      LET g_npr[g_cnt].balf= cl_numfor(g_npr[g_cnt].balf,20,t_azi04)
      LET g_npr[g_cnt].pb_balf= cl_numfor(g_npr[g_cnt].pb_balf,20,t_azi04)
 
      LET g_npr[g_cnt].npr11_d= cl_numfor(g_npr[g_cnt].npr11_d,20,t_azi07)
      LET g_npr[g_cnt].npr11_c= cl_numfor(g_npr[g_cnt].npr11_c,20,t_azi07)
      LET g_npr[g_cnt].npr11_bal= cl_numfor(g_npr[g_cnt].npr11_bal,20,t_azi07)
      LET g_npr[g_cnt].npr11_pb = cl_numfor(g_npr[g_cnt].npr11_pb,20,t_azi07)
      
      #IF tm.c = 'N' THEN                                  #FUN-980120--Add       #FUN-C80102
      IF tm.e = 'N' THEN                    #FUN-C80102
      IF l_type = '3' OR l_type = '4' THEN
         LET g_npr[g_cnt].df = NULL
         LET g_npr[g_cnt].npr11_d= NULL
         LET g_npr[g_cnt].cf = NULL
         LET g_npr[g_cnt].npr11_c= NULL
         LET g_npr[g_cnt].balf = NULL
         LET g_npr[g_cnt].npr11_bal = NULL
         LET g_npr[g_cnt].pb_balf = NULL
         LET g_npr[g_cnt].npr11_pb  = NULL
         IF l_type = '3' THEN                                                   
            #客戶小計                                                           
            LET g_npr[g_cnt].npr01 = g_npr[g_cnt].npr01 CLIPPED,"(",g_npr[g_cnt].npr02 CLIPPED,")"
         ELSE                                                                   
            #單身合計                                                           
            LET g_npr[g_cnt].npr01 = NULL                                       
         END IF                                                                 
         LET g_npr[g_cnt].npr02 = l_memo
      END IF
      IF l_type = '2' THEN
         IF tm.b = 'N' THEN
            LET g_npr[g_cnt].balf= NULL
            LET g_npr[g_cnt].npr11_bal = NULL
            LET g_npr[g_cnt].pb_balf= NULL
            LET g_npr[g_cnt].npr11_pb = NULL
         END IF
      END IF
     ELSE               
      IF l_type = '3' OR l_type = '4' THEN
         LET g_npr[g_cnt].npr11_d= NULL
         LET g_npr[g_cnt].npr11_c= NULL
         LET g_npr[g_cnt].npr11_bal = NULL
         LET g_npr[g_cnt].npr11_pb  = NULL         
         IF l_type = '3' THEN                                                   
            #客戶小計                                                           
            LET g_npr[g_cnt].npr01 = g_npr[g_cnt].npr01 CLIPPED,"(",g_npr[g_cnt].npr02 CLIPPED,")"
         ELSE                                                                   
            #單身合計                                                           
            LET g_npr[g_cnt].npr01 = NULL                                       
         END IF                                                                 
         LET g_npr[g_cnt].npr02 = l_memo
      END IF
      IF l_type = '2' THEN
         IF tm.b = 'N' THEN
            LET g_npr[g_cnt].balf= NULL
            LET g_npr[g_cnt].npr11_bal = NULL
            LET g_npr[g_cnt].pb_balf= NULL
            LET g_npr[g_cnt].npr11_pb = NULL
         END IF
      END IF
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_npr.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
FUNCTION q911_qcye_qjyd(p_npr01,p_npr02,p_npr00,p_npr11,p_m1,p_m2)              
  DEFINE p_npr01       LIKE npr_file.npr01                                      
  DEFINE p_npr02       LIKE npr_file.npr02                                      
  DEFINE p_npr00       LIKE npr_file.npr00                                      
  DEFINE p_npr11       LIKE npr_file.npr11                                      
  DEFINE p_m1          LIKE npr_file.npr05                                      
  DEFINE p_m2          LIKE npr_file.npr05                                      
  DEFINE l_qcye        LIKE npr_file.npr06f                                     
  DEFINE l_qcyef       LIKE npr_file.npr06f                                     
  DEFINE m_npr06f      LIKE npr_file.npr06f                                     
  DEFINE m_npr06       LIKE npr_file.npr06f                                     
  DEFINE m_npr07f      LIKE npr_file.npr06f                                     
  DEFINE m_npr07       LIKE npr_file.npr06f                                     
  DEFINE l_flag        LIKE type_file.chr1                                      
                                                                                
       LET l_flag = 'Y'   #有異動
       SELECT SUM(npr06f-npr07f),SUM(npr06-npr07)  #期初余額
         INTO l_qcyef,l_qcye
         FROM npr_file
        WHERE npr00 = p_npr00 AND npr01 = p_npr01
          AND npr02 = p_npr02 AND npr11 = p_npr11
          AND npr04 = tm.yy   AND npr05 < p_m1
          AND (npr08 = g_plant OR npr08 IS NULL OR npr08 =' ') AND npr09 = tm.o   #No.TQC-8B0035
       IF cl_null(l_qcyef) THEN LET l_qcyef = 0 END IF
       IF cl_null(l_qcye)  THEN LET l_qcye  = 0 END IF
 
       SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07)  #期間余額
         INTO m_npr06f,m_npr07f,m_npr06,m_npr07
         FROM npr_file
        WHERE npr00 = p_npr00 AND npr01 = p_npr01
          AND npr02 = p_npr02 AND npr11 = p_npr11
          AND npr04 = tm.yy     AND npr05 BETWEEN p_m1 AND p_m2 
          AND (npr08 = g_plant OR npr08 IS NULL OR npr08 =' ') AND npr09 = tm.o   #No.TQC-8B0035
       IF cl_null(m_npr06f) THEN LET m_npr06f = 0 END IF
       IF cl_null(m_npr07f) THEN LET m_npr07f = 0 END IF
       IF cl_null(m_npr06)  THEN LET m_npr06  = 0 END IF
       IF cl_null(m_npr07)  THEN LET m_npr07  = 0 END IF
 
       IF tm.b = 'N'   AND l_qcye = 0  AND      #本幣
          m_npr06 = 0 AND m_npr07 = 0 THEN
          LET l_flag = 'N'                       #期初為零且無異動
       END IF
       IF tm.b='Y' AND l_qcyef=0 AND l_qcye=0 AND m_npr06f=0   #外幣
          AND m_npr07f=0  AND m_npr06=0 AND m_npr07=0 THEN
          LET l_flag = 'N'
       END IF
 
       RETURN l_flag
END FUNCTION
 
FUNCTION q911_drill_detail()
   DEFINE #l_wc    LIKE type_file.chr50
          l_wc          STRING    #NO.FUN-910082
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_bdate2 LIKE type_file.dat   ##TQC-D60015 add
   DEFINE l_edate2 LIKE type_file.dat   ##TQC-D60015 add
 
   IF cl_null(g_npr00) THEN RETURN END IF  #科目
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_npr[l_ac].npr01) THEN RETURN END IF
   IF NOT cl_null(g_npr11) THEN 
      LET l_wc = 'npq21 = "',g_npr[l_ac].npr01,'" AND npq22 = "',g_npr[l_ac].npr02,'" AND npq03 = "',g_npr00,'" AND npq24 = "',g_npr11,'"' #No.MOD-920234 mod by liuxqa   #MOD-D40201 add npq24
   ELSE
      LET l_wc = 'npq21 = "',g_npr[l_ac].npr01,'" AND npq22 = "',g_npr[l_ac].npr02,'" AND npq03 = "',g_npr00,'"' #No.MOD-920234 mod by liuxqa 
   END IF

  #CALL s_azn01(tm.yy,g_npr05) RETURNING l_bdate,l_edate  #TQC-D60015
  #LET l_bdate = MDY(g_npr05,1,tm.yy)  #TQC-D60015
   ##TQC-D60015--add--str--
   CALL s_azn01(tm.yy,tm.m1) RETURNING l_bdate,l_edate
   LET l_bdate = MDY(tm.m1,1,tm.yy)
   CALL s_azn01(tm.yy,tm.m2) RETURNING l_bdate2,l_edate2
   LET l_bdate2 = MDY(tm.m2,1,tm.yy)
   ##TQC-D60015--add--end--
 
#  LET g_msg = "gapq910 '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.o,"' '",tm.b,"' '1' '",tm.d,"' '' '' '' ''"  #MOD-930203
   #LET g_msg = "gapq910 '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.o,"' '",tm.b,"' '",g_npr[l_ac].npr11,"' '1' '",tm.d,"' '' '' '' ''"  #MOD-930203  TQC-B60303
#   LET g_msg = "gglq910 '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.o,"' '",tm.b,"' '",g_npr[l_ac].npr11,"' '",tm.c,"' '1' '",tm.d,"' '' '' '' ''"  #TQC-BC0063    #FUN-C80102  mark
   #LET g_msg = "gglq910 '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.o,"' '",tm.b,"' '",g_npr[l_ac].npr11,"' '",tm.e,"' '1' '",tm.f,"' '' '' '' ''"        #FUN-C80102  add   #TQC-D60015
    LET g_msg = "gglq910 '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate2,"' '",tm.o,"' '",tm.b,"' '",g_npr[l_ac].npr11,"' '",tm.e,"' '1' '",tm.f,"' 'N' 'N' '' '' '' ''"   #TQC-D60015
   CALL cl_cmdrun(g_msg)
 
 
END FUNCTION
 
FUNCTION q911_out_1()
   LET g_sql = "npr00.npr_file.npr00,",
               "aag02.aag_file.aag02,",
               "npr05.npr_file.npr05,",
               "npr01.type_file.chr50,",
               "npr02.npr_file.npr02,",
               "npr11.npr_file.npr11,",
               "type.type_file.chr10,",
               "pb_dc.type_file.chr10,",
               "pb_balf.npr_file.npr06f,",
               "npr11_pb.npq_file.npq25,",
               "pb_bal.npr_file.npr06f,",
               "memo.abb_file.abb04,",
               "df.npr_file.npr06f,",
               "npr11_d.npq_file.npq25,",
               "d.npr_file.npr06f,",
               "cf.npr_file.npr06f,",
               "npr11_c.npq_file.npq25,",
               "c.npr_file.npr06f,",
               "dc.type_file.chr10,",
               "balf.npr_file.npr06f,",
               "npr11_bal.npq_file.npq25,",
               "bal.npr_file.npr06f,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07 "
 
   LET l_table = cl_prt_temptable('gapq911',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ? )               "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
END FUNCTION
             
FUNCTION q911_out_2()
   DEFINE l_name             LIKE type_file.chr20  #FUN-980120
 
   CALL cl_del_data(l_table)                       #NO.FUN-7B0026
 
   DECLARE cr_curs CURSOR FOR 
    SELECT * FROM gapq911_tmp
     ORDER BY npr00,npr05,type asc      #No.FUN-CB0146   Add
   FOREACH cr_curs INTO g_pr.*
       EXECUTE insert_prep USING g_pr.*
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   IF g_zz05='Y' THEN 
      CALL cl_wcchp(tm.wc,'npr01,npr00')
           RETURNING g_str 
   END IF
   LET g_str=g_str CLIPPED,";",tm.yy,";",g_azi04
   
   IF tm.b = 'N' THEN
       LET l_name = 'gapq911'
   ELSE
      #IF tm.c = 'Y' THEN            #FUN-C80102
       IF tm.e = 'Y' THEN            #FUN-C80102
          LET l_name = 'gapq911_2'  
       ELSE                               
          LET l_name = 'gapq911_1'
       END IF    
   END IF
   CALL cl_prt_cs3('gapq911',l_name,g_sql,g_str)   
   
END FUNCTION
#No.FUN-9C0072 精簡程式碼 

#No.FUN-CB0146 ---start--- Add
FUNCTION gapq911v()
   DEFINE l_name    LIKE type_file.chr20,
          l_sql     STRING,
          l_sql1    STRING,
          l_i       LIKE type_file.num5,
          l_qcyef   LIKE npr_file.npr06f,
          l_qcye    LIKE npr_file.npr06f,
          m_npr06f  LIKE npr_file.npr06f,
          m_npr07f  LIKE npr_file.npr07f,
          m_npr06   LIKE npr_file.npr06f,
          m_npr07   LIKE npr_file.npr07f,
          l_npr06f  LIKE npr_file.npr06f,
          l_npr06   LIKE npr_file.npr06f,
          l_npr07f  LIKE npr_file.npr06f,
          l_npr07   LIKE npr_file.npr06f,
          l_pb_dc0  LIKE type_file.chr10,
          l_pb_dc1  LIKE type_file.chr10,
          l_pb_dc2  LIKE type_file.chr10
 
   LET g_prog = 'gapr911'
   CALL gapq911_table()
   CALL gapq911v_table()
   SELECT zo02 INTO g_company FROM zo_file
    WHERE zo01 = g_rlang
 
   DISPLAY "START TIME: ",TIME
   LET l_sql = "INSERT INTO gapq911v_tmp "
   #LET l_sql = l_sql," SELECT UNIQUE npr00,npr01,npr02,npr11,q911v_tmp.npr05 FROM npr_file,q911v_tmp ",   #FUN-D50056 mark
   LET l_sql = l_sql," SELECT UNIQUE npr00,npr01,npr02,npr11 FROM npr_file ",    #FUN-D50056 add   LET l_sql = l_sql," SELECT UNIQUE npr00,npr01,npr02,npr11,q911v_tmp.npr05 FROM npr_file,q911v_tmp ",
                     "  WHERE (npr08 = '",g_plant CLIPPED,"' OR npr08 IS NULL OR npr08 =' ')",
                     "    AND npr09 = '",tm.o CLIPPED,"'",
                     "    AND npr01 <> ' '",                 #MOD-D20156
                     "    AND ",tm.wc CLIPPED
   PREPARE gapq911v_pr1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   EXECUTE gapq911v_pr1

   CALL cl_replace_str(tm.wc,'npr','s.npr') RETURNING tm.wc
   LET l_sql1="INSERT INTO gapq911_tmp "
   #LET l_sql1=l_sql1,"SELECT t.npr00,aag02,t.npr05,t.npr01,t.npr02,t.npr11,'2','',0,0,0,'',",        #FUN-D50056 mark
   LET l_sql1=l_sql1,"SELECT t.npr00,aag02,t.npr01,t.npr02,t.npr11,'2','',0,0,0,'',",                 #FUN-D50056 add
                     "       CASE WHEN (SUM(s.npr06f)) IS NULL THEN 0 ELSE (SUM(s.npr06f)) END,0,",
                     "       CASE WHEN (SUM(s.npr06) ) IS NULL THEN 0 ELSE (SUM(s.npr06) ) END,",
                     "       CASE WHEN (SUM(s.npr07f)) IS NULL THEN 0 ELSE (SUM(s.npr07f)) END,0,",
                     "       CASE WHEN (SUM(s.npr07) ) IS NULL THEN 0 ELSE (SUM(s.npr07) ) END,'',",
                     "       0,0,0,'','',''",
                     "  FROM gapq911v_tmp t LEFT OUTER JOIN npr_file s ON",
                     "       s.npr00 = t.npr00 AND s.npr01 = t.npr01 ",
                     "   AND s.npr02 = t.npr02 AND s.npr11 = t.npr11 ",
                     #"   AND s.npr05 = t.npr05 ",   #FUN-D50056 mark
                     "    AND s.npr05 BETWEEN '",tm.m1,"' AND '",tm.m2,"'",   #FUN-D50056 add
                     "   AND (s.npr08 = '",g_plant CLIPPED,"' OR s.npr08 IS NULL OR s.npr08 =' ')",
                     "   AND s.npr09 = '",tm.o    CLIPPED,"'",
                     "   AND s.npr04 = ",tm.yy,
                     "   AND ",tm.wc CLIPPED,
                     "                      LEFT OUTER JOIN aag_file ON t.npr00 = aag01 AND aag00 = '",tm.o,"'"
   IF tm.e = 'Y' THEN                                     
      #LET l_sql1=l_sql1," GROUP BY t.npr00,aag02,t.npr01,t.npr02,t.npr11,t.npr05 ",    #FUN-D50056 mark
      #                  " ORDER BY t.npr00,t.npr01,t.npr02,t.npr11,t.npr05 "           #FUN-D50056 mark
      LET l_sql1=l_sql1," GROUP BY t.npr00,aag02,t.npr01,t.npr02,t.npr11 ",             #FUN-D50056 add
                        " ORDER BY t.npr00,t.npr01,t.npr02,t.npr11 "                    #FUN-D50056 add
   ELSE
      #LET l_sql1=l_sql1," GROUP BY t.npr00,aag02,t.npr05,t.npr01,t.npr02,t.npr11 ",    #FUN-D50056 mark
      #                  " ORDER BY t.npr00,t.npr05,t.npr01,t.npr02,t.npr11 "           #FUN-D50056 mark
      LET l_sql1=l_sql1," GROUP BY t.npr00,aag02,t.npr01,t.npr02,t.npr11 ",             #FUN-D50056 add
                        " ORDER BY t.npr00,t.npr01,t.npr02,t.npr11 "                    #FUN-D50056 add
   END IF
                
   PREPARE gapq911v_prepare1 FROM l_sql1
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXECUTE gapq911v_prepare1
   
   #計算期末原幣金額
   LET l_sql = "UPDATE gapq911_tmp a SET pb_balf = (SELECT CASE WHEN SUM(b.npr06f - b.npr07f) IS NULL THEN 0 ELSE SUM(b.npr06f - b.npr07f) END",
               "                                      FROM npr_file b",
               "                                     WHERE b.npr00 = a.npr00  ",
               "                                       AND b.npr01 = a.npr01  ",
               "                                       AND b.npr02 = a.npr02  ",
               #"                                       AND b.npr05 < a.npr05  ",      #FUN-D50056 mark
               "                                       AND b.npr05 < '",tm.m1,"'",     #FUN-D50056 add
               "                                       AND (b.npr08 = '",g_plant,"' OR b.npr08 IS NULL OR b.npr08 =' ') AND b.npr09 = '",tm.o,"'",
               "                                       AND b.npr04 = '",tm.yy,"'",
               "                                       AND b.npr11 = a.npr11),",
               "                        pb_bal = (SELECT CASE WHEN SUM(b.npr06 - b.npr07) IS NULL THEN 0 ELSE SUM(b.npr06 - b.npr07) END",
               "                                     FROM npr_file b",
               "                                     WHERE b.npr00 = a.npr00  ",
               "                                       AND b.npr01 = a.npr01  ",
               "                                       AND b.npr02 = a.npr02  ",
               #"                                       AND b.npr05 < a.npr05  ",      #FUN-D50056 mark
               "                                       AND b.npr05 < '",tm.m1,"'",     #FUN-D50056 add
               "                                       AND (b.npr08 = '",g_plant,"' OR b.npr08 IS NULL OR b.npr08 =' ') AND b.npr09 = '",tm.o,"'",
               "                                       AND b.npr04 = '",tm.yy,"'",
               "                                       AND b.npr11 = a.npr11)"
   PREPARE gapq911v_upd1 FROM l_sql
   EXECUTE gapq911v_upd1
   
   #計算期末本幣金額
   LET l_sql = "UPDATE gapq911_tmp a SET bal = d - c + pb_bal,",
               "                         balf= df-cf+ pb_balf"
   PREPARE gapq911v_upd2 FROM l_sql
   EXECUTE gapq911v_upd2
   
   CALL cl_getmsg('ggl-223',g_lang) RETURNING g_msg
   IF tm.e = 'Y' THEN
      #LET l_sql = "INSERT INTO gapq911_tmp SELECT npr00,aag02,npr05,'','',npr11,'4','',",     #FUN-D50056 mark
      LET l_sql = "INSERT INTO gapq911_tmp SELECT npr00,aag02,'','',npr11,'4','',",            #FUN-D50056 add
                  "                               SUM(pb_balf),0,SUM(pb_bal),'",g_msg,"',0,",
                  "                               0,SUM(d),0,0,SUM(C),'',SUM(balf),0,",
                  "                               SUM(d - c + pb_bal),'','','' FROM gapq911_tmp",
                  #"                         GROUP BY npr00,aag02,npr05,npr11"                 #FUN-D50056 mark
                  "                         GROUP BY npr00,aag02,npr11"                        #FUN-D50056 add
   ELSE
      #LET l_sql = "INSERT INTO gapq911_tmp SELECT npr00,aag02,npr05,'','','','4','',",        #FUN-D50056 mark
      LET l_sql = "INSERT INTO gapq911_tmp SELECT npr00,aag02,'','','','4','',",               #FUN-D50056 add
                  "                               SUM(pb_balf),0,SUM(pb_bal),'",g_msg,"',0,",
                  "                               0,SUM(d),0,0,SUM(C),'',SUM(balf),0,",
                  "                               SUM(d - c + pb_bal),'','','' FROM gapq911_tmp",
                  #"                         GROUP BY npr00,aag02,npr05"                       #FUN-D50056 mark
                  "                         GROUP BY npr00,aag02"                              #FUN-D50056 add
   END IF
   PREPARE gapq911v_upd4 FROM l_sql
   EXECUTE gapq911v_upd4

   IF tm.e = 'N' THEN
      IF tm.b = 'Y' THEN
         CALL cl_getmsg('ggl-224',g_lang) RETURNING g_msg
         #LET l_sql = "INSERT INTO gapq911_tmp SELECT npr00,aag02,npr05,npr01,npr02,npr11,'3',",   #FUN-D50056 mark
         LET l_sql = "INSERT INTO gapq911_tmp SELECT npr00,aag02,npr01,npr02,npr11,'3',",          #FUN-D50056 add
                     "                               SUM(pb_dc),0,0,SUM(pb_bal),COUNT(npr02),0,",
                     "                               0,SUM(d),0,0,SUM(C),'',0,0,",
                     "                               SUM(d - c + pb_bal),'','','' FROM gapq911_tmp",
                     "                         WHERE type = '2'",
                     #"                         GROUP BY npr00,aag02,npr05,npr01,nrp02,npr11",     #FUN-D50056 mark
                     "                         GROUP BY npr00,aag02,npr01,nrp02,npr11",            #FUN-D50056 add
                     "                        HAVING COUNT(npr02) > 1"
         PREPARE gapq911v_upd5 FROM l_sql
         EXECUTE gapq911v_upd5
         LET l_sql = "UPDATE gapq911_tmp SET memo = '",g_msg,"'",
                     " WHERE type = '3' "
         PREPARE gapq911v_upd51 FROM l_sql
         EXECUTE gapq911v_upd51
      ELSE
         #LET l_SQL = "INSERT INTO gapq911_tmp SELECT npr00,aag02,npr05,npr01,npr02,'','2',",      #FUN-D50056 mark
         LET l_SQL = "INSERT INTO gapq911_tmp SELECT npr00,aag02,npr01,npr02,'','2',",             #FUN-D50056 add
                     "                               SUM(pb_dc),0,0,SUM(pb_bal),'',0,",
                     "                               0,SUM(d),0,0,SUM(C),'',0,0,",
                     "                               SUM(d - c + pb_bal),'','','' FROM gapq911_tmp",
                     "                         WHERE type = '2'",
                     #"                         GROUP BY npr00,aag02,npr05,npr01,npr02"            #FUN-D50056 mark
                     "                         GROUP BY npr00,aag02,npr01,npr02"                   #FUN-D50056 add
         PREPARE gapq911v_upd6 FROM l_sql
         EXECUTE gapq911v_upd6
         
         LET l_sql = "DELETE FROM gapq911_tmp WHERE type = 2 AND npr11 IS NOT NULL"
         PREPARE gapq911v_upd7 FROM l_sql
         EXECUTE gapq911v_upd7
      END IF
   END IF
                  
   CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc0   #平
   CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc1   #藉
   CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc2   #貸

   LET l_sql = "UPDATE gapq911_tmp SET pb_dc = CASE WHEN pb_bal = 0 THEN '",l_pb_dc0,"' ",
               "                                    WHEN pb_bal > 0 THEN '",l_pb_dc1,"' ",
               "                                    ELSE '",l_pb_dc2,"' END,",
               "                          dc = CASE WHEN    bal = 0 THEN '",l_pb_dc0,"' ",
               "                                    WHEN    bal > 0 THEN '",l_pb_dc1,"' ",
               "                                    ELSE '",l_pb_dc2,"' END "
   PREPARE gapq911v_upd8 FROM l_sql
   EXECUTE gapq911v_upd8

   #金额更新为正数、计算汇率
   LET l_sql = "UPDATE gapq911_tmp SET pb_balf = CASE WHEN pb_balf < 0 THEN pb_balf * (-1) ELSE pb_balf END,",
               "                       pb_bal  = CASE WHEN pb_bal  < 0 THEN pb_bal  * (-1) ELSE pb_bal  END,",
               "                       df      = CASE WHEN df      < 0 THEN df      * (-1) ELSE df      END,",
               "                       d       = CASE WHEN d       < 0 THEN d       * (-1) ELSE d       END,",
               "                       cf      = CASE WHEN cf      < 0 THEN cf      * (-1) ELSE cf      END,",
               "                       c       = CASE WHEN c       < 0 THEN c       * (-1) ELSE c       END,",
               "                       balf    = CASE WHEN balf    < 0 THEN balf    * (-1) ELSE balf    END,",
               "                       bal     = CASE WHEN bal     < 0 THEN bal     * (-1) ELSE bal     END,",
               "                       npr11_pb= CASE WHEN pb_balf > 0 THEN pb_bal / pb_balf ELSE 0     END,",
               "                       npr11_d = CASE WHEN df      > 0 THEN d      / df      ELSE 0     END,",
               "                       npr11_c = CASE WHEN cf      > 0 THEN c      / cf      ELSE 0     END,",
               "                      npr11_bal= CASE WHEN balf    > 0 THEN bal     /balf    ELSE 0     END"
   PREPARE gapq911v_upd9 FROM l_sql
   EXECUTE gapq911v_upd9

   LET l_sql ="UPDATE gapq911_tmp t SET t.azi04 = CASE WHEN (SELECT s.azi04 FROM azi_file s WHERE s.azi01 = t.npr11) IS NULL THEN 6 ",
              "                                        ELSE (SELECT s.azi04 FROM azi_file s WHERE s.azi01 = t.npr11) END,",
              "                         t.azi05 = CASE WHEN (SELECT s.azi05 FROM azi_file s WHERE s.azi01 = t.npr11) IS NULL THEN 6 ",
              "                                        ELSE (SELECT s.azi05 FROM azi_file s WHERE s.azi01 = t.npr11) END,",
              "                         t.azi07 = CASE WHEN (SELECT s.azi07 FROM azi_file s WHERE s.azi01 = t.npr11) IS NULL THEN 6 ",
              "                                        ELSE (SELECT s.azi07 FROM azi_file s WHERE s.azi01 = t.npr11) END"
   PREPARE gapq911v_upd10 FROM l_sql
   EXECUTE gapq911v_upd10

   LET g_prog = 'gapq911'
   DISPLAY "END   TIME: ",TIME
END FUNCTION

FUNCTION gapq911v_table()
   DEFINE i      LIKE type_file.num5
   #記錄期別區間
   DROP TABLE q911v_tmp;
   CREATE TEMP TABLE q911v_tmp(
                    npr05       LIKE npr_file.npr05);
   DROP TABLE gapq911v_tmp;
   #FUN-D50056--mark--str--
   #CREATE TEMP TABLE gapq911v_tmp(
   #                 npr00       LIKE npr_file.npr00,
   #                 npr01       LIKE npr_file.npr01,
   #                 npr02       LIKE npr_file.npr02,
   #                 npr11       LIKE npr_file.npr11,
   #                 npr05       LIKE npr_file.npr05);
   #FUN-D50056--mark--end--
   #FUN-D50056--add--str--
   CREATE TEMP TABLE gapq911v_tmp(
                    npr00       LIKE npr_file.npr00,
                    npr01       LIKE npr_file.npr01,
                    npr02       LIKE npr_file.npr02,
                    npr11       LIKE npr_file.npr11);
   #FUN-D50056--add--end--
   FOR i = tm.m1 TO tm.m2
      INSERT INTO q911v_tmp(npr05) VALUES(i)
   END FOR
   
END FUNCTION
#No.FUN-CB0146 ---end  --- Add
