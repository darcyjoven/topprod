# Prog. Version..: '5.30.07-13.05.20(00010)'     #
#
# Pattern name...: gglq704.4gl
# Descriptions...: 科目部門余額查詢
# Date & Author..: 08/06/19 by Carrier  #No.FUN-850030
# Modify.........: No.FUN-850030 08/07/24 By dxfwo 新增程序從21區移植到31區
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-930163 09/04/03 By elva 新增打印外幣選項
# Modify.........: No.MOD-940388 09/04/30 By wujie 字串連接%前要加轉義符\
# Modify.........: No.TQC-970049 09/07/24 By xiaofeizhu 修改少抓取幣別的錯誤
# Modify.........: No.TQC-970310 09/07/28 By xiaofeizhu 修改原幣和匯率無顯示的錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0084 09/10/27 By Carrier 增加部门construct 
# Modify.........: No:FUN-A40009 10/04/07 By wujie 查询界面点退出回到主画面，而不是关闭程序
#                                                  点击单据联查按钮后，光标保持在原来所在的行，而不是回到第一行
# Modify.........: No:FUN-A80034 10/08/04 By wujie 追21区FUN-A40013
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:CHI-C70031 12/10/18 By wangwei 去除CE、CA憑證資料，否則月末結轉損益後，查詢不到損益類科目
# Modify.........: No:CHI-CB0006 12/11/16 By fengmy 增加"貨幣性科目"和"是否打印內部管理科目"
# Modify.........: No.FUN-C80102 12/10/12 By zhangweib 財務報表改善追單
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.TQC-CC0122 12/12/26 By lujh FUN-CB0069追單:1.增加最低级科目对应金额合计2.增加挑选科目类别的下拉框
# Modify.........: No:FUN-D30014 13/03/07 By lujh FUN-CB0146 追單 程序優化
# Modify.........: No:FUN-D40044 13/04/25 By lujh 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額
# Modify.........: No:MOD-D60148 13/06/19 By fengmy 合計前,update 貸方數據
# Modify.........: No:MOD-D90099 13/09/22 By fengmy 未勾選'列印原幣'不顯示幣種欄位
# Modify.........: No:MOD-DB0058 13/11/08 By fengmy 同科目同部门根据期别只显示一次
# Modify.........: No.TQC-DC0064 13/12/19 By wangrr 當'單據狀態'為'2:已過帳'時'含未審核憑證'不顯示

DATABASE ds
GLOBALS "../../config/top.global"  #No.FUN-850030
 
DEFINE tm             RECORD
		     # wc      LIKE type_file.chr1000,
               wc      STRING,       #NO.FUN-910082
               wc1     STRING,       #No.FUN-9A0084
               wc2     STRING,       #FUN-C80102  add
               yy      LIKE type_file.num5,
               m1      LIKE type_file.num5,
               m2      LIKE type_file.num5,
               o       LIKE aaa_file.aaa01,
               b       LIKE type_file.chr1,
               aag07   LIKE aag_file.aag07,  #TQC-CC0122
               aag24   LIKE aag_file.aag24,  #TQC-CC0122
               g       LIKE type_file.chr1,  #FUN-C80102  add 
               f       LIKE type_file.chr1,  #FUN-C80102  add
               #c       LIKE type_file.chr1, #TQC-930163   #FUN-C80102  mark
               a       LIKE type_file.chr1,  #FUN-C80102  add
               #d       LIKE type_file.chr1, #No.FUN-A80034  #FUN-C80102  mark
               e       LIKE type_file.chr1,  #FUN-C80102  add 
               aag09   LIKE aag_file.aag09,  #CHI-CB0006
               aag38   LIKE aag_file.aag38,  #CHI-CB0006
               i       LIKE type_file.chr1,  #FUN-D40044  add
 		      more    LIKE type_file.chr1
                      END RECORD
DEFINE g_i            LIKE type_file.num5
DEFINE l_table        STRING
DEFINE g_str          STRING
DEFINE g_sql          STRING
DEFINE g_rec_b        LIKE type_file.num10
DEFINE g_aao01        LIKE aao_file.aao01
DEFINE g_aag02        LIKE aag_file.aag02
DEFINE g_aao04        LIKE aao_file.aao04
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_aao          DYNAMIC ARRAY OF RECORD
                      aao01     LIKE aao_file.aao01,   #FUN-C80102  add
                      aag02     LIKE aag_file.aag02,   #FUN-C80102  add
                      aao02     LIKE type_file.chr50,
                      gem02     LIKE gem_file.gem02,
                      tao09     LIKE tao_file.tao09,#TQC-930163 
                      pb_dc     LIKE type_file.chr10,
                      pb_balf   LIKE aao_file.aao05,#TQC-930163 
                      abb25_pb  LIKE abb_file.abb25, #TQC-930163 
                      pb_bal    LIKE aao_file.aao05,
                      df        LIKE tao_file.tao10, #TQC-930163 
                      abb25_d   LIKE abb_file.abb25, #TQC-930163 
                      d         LIKE aao_file.aao05,
                      cf        LIKE tao_file.tao11, #TQC-930163 
                      abb25_c   LIKE abb_file.abb25, #TQC-930163 
                      c         LIKE aao_file.aao05,
                      dc        LIKE type_file.chr10,
                      balf      LIKE aao_file.aao05, #TQC-930163 
                      abb25_bal LIKE abb_file.abb25, #TQC-930163 
                      bal       LIKE aao_file.aao05
                      END RECORD
DEFINE g_pr           RECORD
                      aao01   LIKE aao_file.aao01,
                      aag02   LIKE aag_file.aag02,
                      aao04   LIKE aao_file.aao04,
                      aao02   LIKE type_file.chr50,
                      gem02   LIKE gem_file.gem02,
                      tao09     LIKE tao_file.tao09,#TQC-930163 
                      type    LIKE type_file.chr10,
                      pb_dc   LIKE type_file.chr10,
                      pb_balf   LIKE aao_file.aao05,#TQC-930163 
                      abb25_pb  LIKE abb_file.abb25, #TQC-930163 
                      pb_bal  LIKE aao_file.aao05,
                      memo    LIKE abb_file.abb04,
                      df        LIKE tao_file.tao10, #TQC-930163 
                      abb25_d   LIKE abb_file.abb25, #TQC-930163 
                      d       LIKE aao_file.aao05,
                      cf        LIKE tao_file.tao11, #TQC-930163 
                      abb25_c   LIKE abb_file.abb25, #TQC-930163 
                      c       LIKE aao_file.aao05,
                      dc      LIKE type_file.chr10,
                      balf      LIKE aao_file.aao05, #TQC-930163 
                      abb25_bal LIKE abb_file.abb25, #TQC-930163 
                      bal     LIKE aao_file.aao05
                      END RECORD
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE l_ac           LIKE type_file.num5
DEFINE g_tao09        LIKE tao_file.tao09   #FUN-C80102  add
 
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
   #No.FUN-9A0084  --Begin                                                      
   LET tm.wc      = ARG_VAL(7)                                                  
   LET tm.wc1     = ARG_VAL(8)                                                  
   LET tm.yy      = ARG_VAL(9)                                                  
   LET tm.m1      = ARG_VAL(10)                                                 
   LET tm.m2      = ARG_VAL(11)                                                 
   LET tm.o       = ARG_VAL(12)                                                 
   LET tm.b       = ARG_VAL(13)    
   LET tm.f       = ARG_VAL(14)   
   #LET tm.c       = ARG_VAL(14)   #FUN-C80102  mark
   LET tm.a       = ARG_VAL(15)    #FUN-C80102  add
   #FUN-C80102--mod--str--
   LET g_rep_user = ARG_VAL(16)                                                 
   LET g_rep_clas = ARG_VAL(17)                                                 
   LET g_template = ARG_VAL(18)                                                 
   LET g_rpt_name = ARG_VAL(19) 
   #FUN-C80102--mod--end--   
   LET tm.g       = ARG_VAL(20)    #FUN-C80102  add
   #No.FUN-9A0084  --End 
   LET tm.aag07   = ARG_VAL(21)    #TQC-CC0122
   LET tm.aag24   = ARG_VAL(22)    #TQC-CC0122
 
   CALL q704_out_1()
 
   OPEN WINDOW q704_w AT 5,10
        WITH FORM "ggl/42f/gglq704_1" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()

   CALL cl_set_comp_entry('e',FALSE)  #FUN-C80102  add
 
   IF cl_null(tm.wc) THEN
      CALL gglq704_tm(0,0)
   ELSE
      #TQC-930163 --begin
      CALL gglq704_t()
      #IF tm.c = 'N' THEN     #FUN-C80102  mark
      IF tm.a = 'N' THEN      #FUN-C80102  add
         #CALL gglq704()      #FUN-D30014  mark
         CALL gglq704v()      #FUN-D30014  add
      ELSE
         #CALL gglq704_1()    #FUN-D30014  mark
         CALL gglq704v_1()    #FUN-D30014  add
      END IF
      #TQC-930163 --end
   END IF
 
   CALL q704_menu()
   DROP TABLE gglq704_tmp;
   CLOSE WINDOW q704_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q704_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q704_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq704_tm(0,0)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q704_out_2()
            END IF
         WHEN "drill_detail"
            IF cl_chk_act_auth() THEN
               CALL q704_drill_detail()
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
               IF g_aao01 IS NOT NULL THEN
                  LET g_doc.column1 = "aao01"
                  LET g_doc.value1 = g_aao01
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION gglq704_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_flag         LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5

   #FUN-C80102--add--str--
   CLEAR FORM #清除畫面  
   CALL g_aao.clear()    
   DELETE FROM gglq704_tmp
   LET g_row_count = '0'
   #FUN-C80102--add--end--

   #FUN-C80102--mark--str---
   #LET p_row = 4 LET p_col =25
 
   #OPEN WINDOW gglq704_w AT p_row,p_col WITH FORM "ggl/42f/gglq704"
   #    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #CALL cl_ui_locale("gglq704")
   #FUN-C80102--mark--end---
 
   CALL cl_set_comp_entry('aag24',TRUE)   #TQC-CC0122  add

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy = YEAR(g_today)
   LET tm.m1 = MONTH(g_today)
   LET tm.m2 = MONTH(g_today)
   LET tm.o  = g_aza.aza81
   #LET tm.b = 'N'   #FUN-C80102 mark
   LET tm.b = '1'   #FUN-C80102 add
   LET tm.g = 'N'   #FUN-C80102  add  
   LET tm.aag07='1' #TQC-CC0122
   LET tm.aag24='1' #TQC-CC0122
   LET tm.f  = 'N'   #FUN-C80102 add
   #LET tm.c = 'N' #TQC-930163    #FUN-C80102  mark
   LET tm.a = 'N'  #FUN-C80102  add   
   #LET tm.d ='N'   #No.FUN-A80034  #FUN-C80102  mark
   LET tm.e ='N'   #FUN-C80102  add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.aag09  = 'Y'                #No.CHI-CB0006
   LET tm.aag38  = 'N'                #No.CHI-CB0006
   LET tm.i ='N'    #FUN-D40044 add
WHILE TRUE
#No.FUN-B20010  --Begin    
#   CONSTRUCT BY NAME tm.wc ON aag01
# 
#       BEFORE CONSTRUCT
#           CALL cl_qbe_init()
 
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(aag01)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_aag'
#                LET g_qryparam.state= 'c'
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aag01
#                NEXT FIELD aag01
#          END CASE
# 
#       ON ACTION locale
#          CALL cl_show_fld_cont()
#          LET g_action_choice = "locale"
#          EXIT CONSTRUCT
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
# 
#       ON ACTION about
#          CALL cl_about()
# 
#       ON ACTION help
#          CALL cl_show_help()
# 
#       ON ACTION controlg
#          CALL cl_cmdask()
# 
#       ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT CONSTRUCT
# 
#       ON ACTION qbe_select
#          CALL cl_qbe_select()
#    END CONSTRUCT

#    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
#    IF g_action_choice = "locale" THEN
#       LET g_action_choice = ""
#       CALL cl_dynamic_locale()
#       CONTINUE WHILE
#    END IF

#    IF INT_FLAG THEN
##No.FUN-A40009 --begin
##      LET INT_FLAG = 0 CLOSE WINDOW gglq704_w
##      CALL cl_used(g_prog,g_time,2) RETURNING g_time
##      EXIT PROGRAM
##   END IF
#    ELSE
##No.FUN-A40009 --end
#    IF tm.wc = ' 1=1' THEN
#       CALL cl_err('','9046',0) CONTINUE WHILE
#    END IF

   #No.FUN-9A0084  --Begin                                                      
#   CONSTRUCT BY NAME tm.wc1 ON aao02                                            
#                                                                                
#       BEFORE CONSTRUCT                                                         
#           CALL cl_qbe_init()                                                   
#                                                                               
#       ON ACTION CONTROLP                                                       
#          CASE                                                                  
#             WHEN INFIELD(aao02)                                                
#                CALL cl_init_qry_var()                                          
#                LET g_qryparam.form = 'q_gem'                                   
#                LET g_qryparam.state= 'c'                                       
#                CALL cl_create_qry() RETURNING g_qryparam.multiret              
#                DISPLAY g_qryparam.multiret TO aao02                            
#                NEXT FIELD aao02                                                
#          END CASE                                                              
#                                                                                
#       ON ACTION locale                                                         
#          CALL cl_show_fld_cont()                                               
#          LET g_action_choice = "locale"                                        
#          EXIT CONSTRUCT                                                        
#                                                                                
#       ON IDLE g_idle_seconds      
#          CALL cl_on_idle()                                                     
#          CONTINUE CONSTRUCT                                                    
#                                                                                
#       ON ACTION about                                                          
#          CALL cl_about()                                                       
#                                                                                
#       ON ACTION help                                                           
#          CALL cl_show_help()                                                   
#                                                                                
#       ON ACTION controlg                                                       
#          CALL cl_cmdask()                                                      
#                                                                                
#       ON ACTION exit                                                           
#          LET INT_FLAG = 1                                                      
#          EXIT CONSTRUCT                                                        
#                                                                                
#       ON ACTION qbe_select                                                     
#          CALL cl_qbe_select()                                                  
#                                                                                
#    END CONSTRUCT     
                                                    
#    IF g_action_choice = "locale" THEN                                          
#       LET g_action_choice = ""           
#       CALL cl_dynamic_locale()                                                 
#       CONTINUE WHILE                                                           
#    END IF                                                                      
                                                                                
#    IF INT_FLAG THEN  
                                                       
#No.FUN-A40009 --begin
#      LET INT_FLAG = 0 CLOSE WINDOW gglq704_w                                  
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time                           
#      EXIT PROGRAM                                                             
#   END IF                                                                      
#    ELSE
#No.FUN-A40009 --begin
    #No.FUN-9A0084  --End  
    #INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.o,tm.b,tm.c,tm.d,tm.more WITHOUT DEFAULTS#TQC-970049    #No.FUN-A80034 #FUN-B20010
#  
#          
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
# 
##No.FUN-A80034 --begin
#        BEFORE FIELD c
#           CALL cl_set_comp_entry('d',TRUE)
#        AFTER FIELD c
#           IF tm.d NOT MATCHES "[YyNn]"  THEN
#              NEXT FIELD d
#           END IF
#           IF tm.c ='N' THEN 
#              LET tm.d ='N'
#              CALL cl_set_comp_entry('d',FALSE)
#           END IF 
#           
#        AFTER FIELD d
#           IF tm.d NOT MATCHES "[YyNn]"  THEN
#              NEXT FIELD d
#           END IF
#           IF tm.c ='N' THEN LET tm.d ='N' END IF 
##No.FUN-A80034 --end
#
#       AFTER FIELD o
#          IF cl_null(tm.o) THEN NEXT FIELD o END IF
#          CALL s_check_bookno(tm.o,g_user,g_plant)
#               RETURNING li_chk_bookno
#          IF (NOT li_chk_bookno) THEN
#             NEXT FIELD o
#          END IF
#          SELECT * FROM aaa_file WHERE aaa01 = tm.o
#          IF SQLCA.sqlcode THEN
#             CALL cl_err3("sel","aaa_file",tm.o,"","aap-229","","",0)
#             NEXT FIELD o
#          END IF
#
#       
#        AFTER FIELD more
#           IF tm.more = 'Y'
#              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                                  g_bgjob,g_time,g_prtway,g_copies)
#                        RETURNING g_pdate,g_towhom,g_rlang,
#                                  g_bgjob,g_time,g_prtway,g_copies
#           END IF

#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(o)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_aaa'
#                CALL cl_create_qry() RETURNING tm.o
#                DISPLAY BY NAME tm.o
#                NEXT FIELD o
#          END CASE
#  
#       
#        ON ACTION CONTROLZ
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

#    END INPUT
#No.FUN-B20010  --Mark End
   #No.FUN-B20010  --Begin
   #FUN-C80102--mark--str--- 
   #DIALOG ATTRIBUTE(unbuffered)   
   #INPUT BY NAME tm.o ATTRIBUTE(WITHOUT DEFAULTS) 
 
   #     BEFORE INPUT
   #         CALL cl_qbe_display_condition(lc_qbe_sn)
 
   #     AFTER FIELD o
   #        IF cl_null(tm.o) THEN NEXT FIELD o END IF
   #        CALL s_check_bookno(tm.o,g_user,g_plant)
   #             RETURNING li_chk_bookno
   #        IF (NOT li_chk_bookno) THEN
   #           NEXT FIELD o
   #        END IF
   #        SELECT * FROM aaa_file WHERE aaa01 = tm.o
   #        IF SQLCA.sqlcode THEN
   #           CALL cl_err3("sel","aaa_file",tm.o,"","aap-229","","",0)
   #           NEXT FIELD o
   #        END IF

   # END INPUT

    
    #CONSTRUCT BY NAME tm.wc ON aag01
 
    #   BEFORE CONSTRUCT
    #       CALL cl_qbe_init()
    #END CONSTRUCT
    
    #CONSTRUCT BY NAME tm.wc1 ON aao02                                            
                                                                                
    #   BEFORE CONSTRUCT                                                         
    #       CALL cl_qbe_init()
    #END CONSTRUCT
    #FUN-C80102--mark--end--- 
    
    #INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.b,tm.c,tm.d,tm.more ATTRIBUTE(WITHOUT DEFAULTS) #FUN-B20010 去掉tm.o    #FUN-C80102  mark
    DIALOG ATTRIBUTE(unbuffered)  #FUN-C80102  add
    INPUT BY NAME tm.o,tm.yy,tm.m1,tm.m2,tm.b,tm.aag07,tm.aag24,tm.g,tm.f,tm.a,tm.e,tm.aag09,tm.aag38,tm.i  #CHI-CB0006 add aag09,aag38   #TQC-CC0122  add tm.aag07,tm.aag24  #FUN-D40044 add tm.i
     ATTRIBUTE(WITHOUT DEFAULTS)    #FUN-C80102  add
         
 
        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

        #FUN-C80102--add--str--- 
        AFTER FIELD o
           IF cl_null(tm.o) THEN NEXT FIELD o END IF
           CALL s_check_bookno(tm.o,g_user,g_plant)
                RETURNING li_chk_bookno
           IF (NOT li_chk_bookno) THEN
              NEXT FIELD o
           END IF
           SELECT * FROM aaa_file WHERE aaa01 = tm.o
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","aaa_file",tm.o,"","aap-229","","",0)
              NEXT FIELD o
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

        #TQC-DC0064--add--str--
        ON CHANGE b
           IF tm.b='2' THEN
              LET tm.g='N'
              CALL cl_set_comp_visible("g",FALSE)
           ELSE
              CALL cl_set_comp_visible("g",TRUE)
           END IF
        #TQC-DC0064--add--end

        #FUN-C80102--mark--str--
        #BEFORE FIELD c
        #   CALL cl_set_comp_entry('d',TRUE)
        #FUN-C80102--mark--end--

        #FUN-C80102--mark--str--
        #AFTER FIELD c   
        #   IF tm.d NOT MATCHES "[YyNn]"  THEN   
        #      NEXT FIELD d                      
        #   END IF
        #   IF tm.c ='N' THEN     
        #      LET tm.d ='N'      
        #      CALL cl_set_comp_entry('d',FALSE)  
        #   END IF 
        #FUN-C80102--mark--end--

        #FUN-C80102--add--str--
        ON CHANGE g   
           IF tm.g NOT MATCHES "[YyNn]"  THEN   
              NEXT FIELD g                     
           END IF
        
        ON CHANGE f   
           IF tm.f NOT MATCHES "[YyNn]"  THEN   
              NEXT FIELD f                      
           END IF
        #FUN-C80102--add--end--
        
        #FUN-C80102--add--str--
        ON CHANGE a   
           IF tm.e NOT MATCHES "[YyNn]"  THEN   
              NEXT FIELD e                      
           END IF
           IF tm.a ='N' THEN     
              LET tm.e ='N'      
              CALL cl_set_comp_entry('e',FALSE)  
           END IF 
           IF tm.a ='Y' THEN          
              CALL cl_set_comp_entry('e',TRUE)  
           END IF
        #FUN-C80102--add--end--

        #FUN-C80102--mark--str--
        #AFTER FIELD d
        #   IF tm.d NOT MATCHES "[YyNn]"  THEN
        #      NEXT FIELD d
        #   END IF
        #   IF tm.c ='N' THEN LET tm.d ='N' END IF 
        #FUN-C80102--mark--end--

        #FUN-C80102--add--str--
        #AFTER FIELD e   #FUN-C80102  mark
        ON CHANGE e      #FUN-C80102  add
           IF tm.e NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD e
           END IF
           IF tm.a ='N' THEN LET tm.e ='N' END IF 
        #FUN-C80102--add--end--
        
        #FUN-C80102--mark--str--   
        #AFTER FIELD more
        #   IF tm.more = 'Y'
        #      THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
        #                          g_bgjob,g_time,g_prtway,g_copies)
        #                RETURNING g_pdate,g_towhom,g_rlang,
        #                          g_bgjob,g_time,g_prtway,g_copies
        #   END IF
        #FUN-C80102--mark--end--

        #TQC-CC0122----add---str
        AFTER FIELD aag07
           IF NOT cl_null(tm.aag07) THEN
              IF tm.aag07 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag07
              END IF
           END IF
        ON CHANGE aag07
           IF tm.aag07 = '1' THEN
              CALL cl_set_comp_entry("aag24",TRUE)
           ELSE
              IF tm.aag07  ='2' THEN
                 LET tm.aag24 = '99'
              ELSE
                 LET tm.aag24 = ''
              END IF
              CALL cl_set_comp_entry("aag24",FALSE)
           END IF
        AFTER FIELD aag24
           IF tm.aag24 <=0 THEN
              CALL cl_err('','ggl-816',0)
              NEXT FIELD aag24
           END IF
        #TQC-CC0122---addd--end

        #FUN-D40044--add--str---
        ON CHANGE i
           IF tm.i NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD i
           END IF
        #FUN-D40044--add--end---

    #END INPUT     #FUN-C80102  mark 
        
    ON ACTION CONTROLP
           CASE
              WHEN INFIELD(o)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_aaa'
                 CALL cl_create_qry() RETURNING tm.o
                 DISPLAY BY NAME tm.o
                 NEXT FIELD o
              #FUN-C80102--mark--str--- 
              #WHEN INFIELD(aag01)
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form = 'q_aag'
              #  LET g_qryparam.state= 'c'
              #  LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"   #FUN-B20010 add              
              #  CALL cl_create_qry() RETURNING g_qryparam.multiret
              #  DISPLAY g_qryparam.multiret TO aag01
              #  NEXT FIELD aag01
              #WHEN INFIELD(aao02)                                                
              #  CALL cl_init_qry_var()                                          
              #  LET g_qryparam.form = 'q_gem'                                   
              #  LET g_qryparam.state= 'c'                                       
              #  CALL cl_create_qry() RETURNING g_qryparam.multiret              
              #  DISPLAY g_qryparam.multiret TO aao02                            
              #  NEXT FIELD aao02
              #FUN-C80102--mark--end--- 
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
        
    #No.FUN-C80102 ---start--- Mark
    #ON ACTION accept
    #  EXIT DIALOG   
 
    #ON ACTION cancel
    #   LET INT_FLAG=1
    #   EXIT DIALOG        
    #No.FUN-C80102 ---start--- Mark
   #END DIALOG              #FUN-C80102 mark
   END INPUT                #FUN-C80102 add
   #FUN-C80102--add--str--
   CONSTRUCT tm.wc ON aao01
                  FROM s_aao[1].aao01
      BEFORE CONSTRUCT
         CALL cl_qbe_init()


      ON ACTION CONTROLP
        CASE 
          WHEN INFIELD(aao01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aag'
               LET g_qryparam.state= 'c'
               LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"           
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aao01
               NEXT FIELD aao01
        END CASE

    END CONSTRUCT
    CONSTRUCT tm.wc1 ON aao02
                   FROM s_aao[1].aao02
    BEFORE CONSTRUCT
      CALL cl_qbe_init()


      ON ACTION CONTROLP
       CASE 
          WHEN INFIELD(aao02)                                                
               CALL cl_init_qry_var()                                          
               LET g_qryparam.form = 'q_gem'                                   
               LET g_qryparam.state= 'c'                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret              
               DISPLAY g_qryparam.multiret TO aao02                            
               NEXT FIELD aao02
       END CASE

    END CONSTRUCT

    CONSTRUCT tm.wc2 ON tao09
                   FROM s_aao[1].tao09
    BEFORE CONSTRUCT
      CALL cl_qbe_init()


      ON ACTION CONTROLP
       CASE 
          WHEN INFIELD(tao09)                                                
               CALL cl_init_qry_var()                                          
               LET g_qryparam.form = 'q_azi'                                   
               LET g_qryparam.state= 'c'                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret              
               DISPLAY g_qryparam.multiret TO tao09                            
               NEXT FIELD tao09
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
   #FUN-C80102--add--str--
   IF INT_FLAG THEN
       LET INT_FLAG = 0 
       RETURN
    END IF 
    #FUN-C80102--add--end--
   #No.FUN-B20010  --End
#No.FUN-A40009 --begin
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW gglq704_w
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
#No.FUN-A40009 --end
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file
              WHERE zz01='gglq704'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglq704','9031',1)
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")  #"
          LET l_cmd = l_cmd CLIPPED,
                          " '",g_pdate    CLIPPED,"'",
                          " '",g_towhom   CLIPPED,"'",
                          " '",g_rlang    CLIPPED,"'",
                          " '",g_bgjob    CLIPPED,"'",
                          " '",g_prtway   CLIPPED,"'",
                          " '",g_copies   CLIPPED,"'",
                          " '",tm.wc      CLIPPED,"'" ,
                          " '",tm.wc1     CLIPPED,"'",  #No.FUN-9A0084
                          " '",tm.yy      CLIPPED,"'" ,
                          " '",tm.m1      CLIPPED,"'" ,
                          " '",tm.m2      CLIPPED,"'" ,
                          " '",tm.o       CLIPPED,"'",
                          " '",tm.b       CLIPPED,"'",
                          #" '",tm.c       CLIPPED,"'", #TQC-930163   #FUN-C80102  mark
                          " '",tm.a       CLIPPED,"'",  #FUN-C80102  add
                          " '",g_rep_user CLIPPED,"'",
                          " '",g_rep_clas CLIPPED,"'",
                          " '",g_template CLIPPED,"'",
                          " '",g_rpt_name CLIPPED,"'"
          CALL cl_cmdat('gglq704',g_time,l_cmd)
       END IF
       #CLOSE WINDOW gglq704_w    #FUN-C80102  mark
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    #END IF                 #No.FUN-A40009  #FUN-B20010 mark
    #END IF                 #No.FUN-A40009  #FUN-B20010 mark
    CALL cl_wait()
    #TQC-930163  --begin
    #IF tm.c = 'N' THEN    #FUN-C80102  mark
    IF tm.a = 'N' THEN     #FUN-C80102  add
       #CALL gglq704()     #FUN-D30014  mark
       CALL gglq704v()     #FUN-D30014  add
    ELSE
       #CALL gglq704_1()   #FUN-D30014  mark
       CALL gglq704v_1()   #FUN-D30014  add
    END IF
    #TQC-930163  --end
    ERROR ""
    EXIT WHILE
END WHILE
   #CLOSE WINDOW gglq704_w   #FUN-C80102  mark
#No.FUN-A40009 --begin  
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF           
#No.FUN-A40009 --end 
 
   CALL gglq704_t() #TQC-930163
   LET g_aao01 = NULL
   LET g_aag02 = NULL
   LET g_aao04 = NULL
   CLEAR FORM
   CALL g_aao.clear()
   CALL gglq704_cs()
 
END FUNCTION

#FUN-D30014--mark--str-- 
#FUNCTION gglq704()
#  DEFINE l_name             LIKE type_file.chr20,
#         #l_sql              LIKE type_file.chr1000,
#         #l_sql1             LIKE type_file.chr1000,
#         l_sql,l_sql1       STRING,       #NO.FUN-910082
#         l_aao              LIKE type_file.chr1000,
#         l_abb              LIKE type_file.chr1000,
#         l_i                LIKE type_file.num5,
#         qc_aao05           LIKE aao_file.aao05,  #期初
#         qc_aao06           LIKE aao_file.aao06,
#         qj_aao05           LIKE aao_file.aao05,  #期間
#         qj_aao06           LIKE aao_file.aao06,
#         l_aao051           LIKE aao_file.aao05,
#         l_aao061           LIKE aao_file.aao06,
#         l_aao052           LIKE aao_file.aao05,
#         l_aao062           LIKE aao_file.aao06,
#         l_aao02            LIKE aao_file.aao02,
#         l_aag01_str        LIKE type_file.chr50,
#         l_aaa09            LIKE aaa_file.aaa09,   #CHI-C70031
#         l_aeh11            LIKE aeh_file.aeh11,   #CHI-C70031
#         l_aeh12            LIKE aeh_file.aeh12,   #CHI-C70031
#         l_aeh15            LIKE aeh_file.aeh15,   #CHI-C70031
#         l_aeh16            LIKE aeh_file.aeh16,   #CHI-C70031
#         sr1                RECORD
#                            aag01    LIKE aag_file.aag01,
#                            aag02    LIKE aag_file.aag02
#                            END RECORD,
#         sr                 RECORD
#                            aao01    LIKE aao_file.aao01,
#                            aag02    LIKE aag_file.aag02,
#                            aao04    LIKE aao_file.aao04,
#                            aao02    LIKE aao_file.aao02,
#                            gem02    LIKE gem_file.gem02,
#                            aao05    LIKE aao_file.aao05,
#                            aao06    LIKE aao_file.aao06,
#                            qcye     LIKE aao_file.aao05
#                            END RECORD
#  DEFINE l_wc2              STRING   #No.FUN-9A0084
#
#    CALL gglq704_table()
#    SELECT zo02 INTO g_company FROM zo_file
#     WHERE zo01 = g_rlang
#    #科目
#    LET tm.wc = cl_replace_str(tm.wc,'aao01','aag01')
#    IF tm.aag07 = '3' THEN       #TQC-CC0122  add
#       LET l_sql = " SELECT aag01,aag02 FROM aag_file ",
#                   "  WHERE aag00 = '",tm.o,"'",
#                   "    AND ",tm.wc CLIPPED
#    #TQC-CC0122--add--str--
#    ELSE
#       LET l_sql = " SELECT aag01,aag02 FROM aag_file ",
#                   "  WHERE aag00 = '",tm.o,"'",
#                   "    AND ",tm.wc CLIPPED,
#                   "    AND ((aag07 ='",tm.aag07,"' AND aag24 = '",tm.aag24,"') OR aag07 = '3')"
#    END IF 
#    #TQC-CC0122--add--end--
#    #No.CHI-CB0006  --Begin
#    IF tm.aag09 = 'Y' THEN
#         LET l_sql = l_sql CLIPPED,
#                   "  AND aag09 = 'Y' "
#    END IF
#           
#    IF tm.aag38 = 'N' THEN
#         LET l_sql = l_sql CLIPPED,
#                   "  AND aag38 = 'N' "
#    END IF
#    #No.CHI-CB0006  --End
#    PREPARE gglq704_pr1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_aag01_cs CURSOR FOR gglq704_pr1
#
#    #部門
#    #No.FUN-9A0084  --Begin                                                    
#    LET l_sql1 = "SELECT UNIQUE aao02 FROM aao_file ",                         
#                 " WHERE aao00 = '",tm.o,"'",                                  
#                 "   AND aao01 = ?",           #科目                           
#                 "   AND ",tm.wc1                                              
#    #No.FUN-9A0084  --End           
#    PREPARE gglq704_aao02_p1 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_aao02_p1',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_aao02_cs1 CURSOR FOR gglq704_aao02_p1
#    
#    #tm.b = 'Y'
#    #FUN-C80102--mark--str-- 
#    #FUN-C80102--add--str--
#    #IF tm.g = 'Y' THEN 
#    #   LET l_sql1 = " SELECT UNIQUE abb05 FROM aba_file,abb_file",
#    #                "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #                "    AND aba00 = '",tm.o,"'",
#    #                "    AND abb03 LIKE ? ",       #科目
#    #                "    AND abb05 IS NOT NULL"
#    #END IF 
#    #IF tm.g = 'N' THEN 
#    #   IF tm.b = '1' THEN 
#    #      LET l_sql1 = " SELECT UNIQUE abb05 FROM aba_file,abb_file",
#    #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #                   "    AND aba00 = '",tm.o,"'",
#    #                   "    AND abb03 LIKE ? ",       #科目
#    #                   "    AND abb05 IS NOT NULL",
#    #                   "    AND aba19 = 'Y'   "
#    #   ELSE 
#    #FUN-C80102--add--end--
#    #      LET l_sql1 = " SELECT UNIQUE abb05 FROM aba_file,abb_file",
#    #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #                   "    AND aba00 = '",tm.o,"'",
#    #                   "    AND abb03 LIKE ? ",       #科目
#    #                   "    AND abb05 IS NOT NULL",
#    #                   #"    AND aba19 = 'Y'   AND abapost = 'N'"   #FUN-C80102  mark
#    #                   "    AND aba19 = 'Y'   AND abapost = 'Y'"    #FUN-C80102  add
#    #   END IF 
#    #END IF 
#    #FUN-C80102--mark--end-- 

#    #FUN-C80102--add--str-- 
#    LET l_sql1 = " SELECT UNIQUE abb05 FROM aba_file,abb_file",
#                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#                    "    AND aba00 = '",tm.o,"'",
#                    "    AND abb03 LIKE ? ",       #科目
#                    "    AND abb05 IS NOT NULL"
#    IF tm.g = 'Y' THEN
#       IF tm.b = '1' THEN 
#          LET l_sql1 = l_sql1 , "AND (aba19 = 'N' or aba19 ='Y')"
#       ELSE
#          LET l_sql1 = l_sql1," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))"
#       END IF 
#    END IF 
#    IF tm.g = 'N' THEN 
#       IF tm.b = '1' THEN
#          LET l_sql1 = l_sql1," AND  aba19 ='Y'"
#       ELSE          
#          LET l_sql1 = l_sql1," AND aba19 ='Y' AND abapost = 'Y'"
#       END IF
#    END IF 
#    #FUN-C80102--add--str-- 
#    
#    #No.FUN-9A0084  --Begin                                                    
#    LET l_wc2 = tm.wc1                                                         
#    LET l_wc2 = cl_replace_str(l_wc2,'aao02','abb05')                          
#    LET l_sql1 = l_sql1 CLIPPED," AND ",l_wc2                                  
#    #No.FUN-9A0084  --End     
#
#    PREPARE gglq704_aao02_p2 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_aao02_p1',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_aao02_cs2 CURSOR FOR gglq704_aao02_p2
#    
#    #共用條件
#    LET l_aao = "SELECT SUM(aao05),SUM(aao06) FROM aao_file",
#                " WHERE aao00 = '",tm.o,"'",
#                "   AND aao01 = ? ",                   #科目
#                "   AND aao02 = ? ",                   #部門
#                "   AND aao03 = ",tm.yy

#    #FUN-C80102--mark--str--
#    #FUN-C80102--add--str--
#    #IF tm.g = 'Y' THEN 
#    #   LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #               "    AND aba00 = '",tm.o,"'",
#    #               "    AND abb03 LIKE ?   ",             #科目
#    #               "    AND abb05 = ? ",                  #部門值
#    #               "    AND aba03 = ",tm.yy
#    #END IF
#    #IF tm.g = 'Y' THEN  
#    #   IF tm.b = '1' THEN 
#    #      LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #                  "    AND aba00 = '",tm.o,"'",
#    #                  "    AND abb03 LIKE ?   ",             #科目
#    #                  "    AND abb05 = ? ",                  #部門值
#    #                  "    AND aba03 = ",tm.yy,
#    #                  "    AND aba19 = 'Y'  "  #未過帳
#    #   ELSE
#    #FUN-C80102--add--end--
#    #      LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #                  "    AND aba00 = '",tm.o,"'",
#    #                  "    AND abb03 LIKE ?   ",             #科目
#    #                  "    AND abb05 = ? ",                  #部門值
#    #                  "    AND aba03 = ",tm.yy,
#    #                  #"    AND aba19 = 'Y'   AND abapost = 'N'"  #未過帳   #FUN-C80102  mark
#    #                  "    AND aba19 = 'Y'   AND abapost = 'Y'"    #FUN-C80102  add
#    #   END IF    #FUN-C80102  add
#    #END IF       #FUN-C80102  add
#    #FUN-C80102--mark--end--

#    #FUN-C80102--add--str--
#    LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#                "    AND aba00 = '",tm.o,"'",
#                "    AND abb03 LIKE ?   ",             #科目
#                "    AND abb05 = ? ",                  #部門值
#                "    AND aba03 = ",tm.yy
#    IF tm.g = 'Y' THEN 
#       IF tm.b = '1' THEN 
#          LET l_abb = l_abb , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
#       ELSE
#          LET l_abb = l_abb, "  AND aba19 = 'N'"
#       END IF 
#    END IF 
#    IF tm.g = 'N' THEN
#       IF tm.b = '1' THEN
#          LET l_abb = l_abb, " AND (aba19 ='Y' and abapost = 'N') "
#       ELSE
#          LET l_abb = l_abb, " AND  aba19 = 1 "
#       END IF
#    END IF 
#    #FUN-C80102--add--end--
#    
#    #當期異動
#    LET l_sql1 = l_aao CLIPPED, "   AND aao04 = ? "  #當期
#    PREPARE gglq704_qj_p1 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_qj_p1',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_qj_cs1 CURSOR FOR gglq704_qj_p1
#    
#    #tm.b = 'Y' #未過帳 - 借/貸
#    LET l_sql1 = " SELECT SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
#                 "    AND aba04 = ?   ",              #當期未過帳資料
#                 "    AND abb06 = ?   ",
#                 "    AND aba19 <> 'X' "  #CHI-C80041
#    PREPARE gglq704_qj_p2 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_qj_p2',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_qj_cs2 CURSOR FOR gglq704_qj_p2
#
#    #期初余額
#    LET l_sql1 = l_aao CLIPPED, "   AND aao04 < ? "  #期初
#    PREPARE gglq704_qc_p1 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_qc_p1',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_qc_cs1 CURSOR FOR gglq704_qc_p1
#
#    #tm.b = 'Y' #未過帳 - 借/貸
#    LET l_sql1 = " SELECT SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
#                 "    AND aba04 < ?   ",              #當期未過帳資料
#                 "    AND abb06 = ?   ",
#                 "    AND aba19 <> 'X' "  #CHI-C80041
#    PREPARE gglq704_qc_p2 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_qc_p2',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_qc_cs2 CURSOR FOR gglq704_qc_p2
#
#    DECLARE gglq704_aao02_cs CURSOR FOR
#            SELECT * FROM gglq704_aao02
#             ORDER BY aao02
#
#    LET g_pageno  = 0
#    LET g_prog = 'gglr300'
#
#    CALL cl_outnam('gglr300') RETURNING l_name
#    START REPORT gglq704_rep TO l_name
#
#    FOREACH gglq704_aag01_cs INTO sr1.*  #科目
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('gglq704_aag01_cs foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#      END IF
#
#      #此作業也要打印統治科目的金額，但是aao/abb中都存放得是明細或是獨立科目
#      #所以要用LIKE的方式，取出統治科目對應的明細科目的金額
#      #此作業的前提，明細科目的前幾碼一定和其上屬統治相同 ruled by 蔡曉峰
#      IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
#      LET l_aag01_str = sr1.aag01 CLIPPED,'\%'    #No.MOD-940388
#
#      FOREACH gglq704_aao02_cs1 USING sr1.aag01
#                                INTO l_aao02
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('gglq704_aao02_cs1 foreach:',SQLCA.sqlcode,0)
#           EXIT FOREACH
#        END IF
#        IF cl_null(l_aao02) THEN CONTINUE FOREACH END IF
#        INSERT INTO gglq704_aao02 VALUES(l_aao02,'') #TQC-930163 
#      END FOREACH
#      #IF tm.b = 'Y' THEN   #FUN-C80102 mark
#         FOREACH gglq704_aao02_cs2 USING l_aag01_str
#                                   INTO l_aao02
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('gglq704_aao02_cs2 foreach:',SQLCA.sqlcode,0)
#              EXIT FOREACH
#           END IF
#           IF cl_null(l_aao02) THEN CONTINUE FOREACH END IF
#           INSERT INTO gglq704_aao02 VALUES(l_aao02,'') #TQC-930163 
#         END FOREACH
#      #END IF   #FUN-C80102 mark
#    
#      FOREACH gglq704_aao02_cs INTO l_aao02 #TQC-930163 
#          IF SQLCA.sqlcode THEN
#             CALL cl_err('gglq704_aao02_cs2 foreach:',SQLCA.sqlcode,0)
#             EXIT FOREACH
#          END IF
#          FOR l_i = tm.m1 TO tm.m2
#              #期初
#              LET l_aao051 = 0  LET l_aao061 = 0
#              LET l_aao052 = 0  LET l_aao062 = 0
#
#              OPEN gglq704_qc_cs1 USING sr1.aag01,l_aao02,l_i
#              FETCH gglq704_qc_cs1 INTO l_aao051,l_aao061
#              CLOSE gglq704_qc_cs1
#              IF cl_null(l_aao051) THEN LET l_aao051 = 0 END IF
#              IF cl_null(l_aao061) THEN LET l_aao061 = 0 END IF
#
#              #IF tm.b = 'Y' THEN   #FUN-C80102 mark
#                 OPEN gglq704_qc_cs2 USING l_aag01_str,l_aao02,l_i,'1'
#                 FETCH gglq704_qc_cs2 INTO l_aao052
#                 CLOSE gglq704_qc_cs2
#                 IF cl_null(l_aao052) THEN LET l_aao052 = 0 END IF
#  
#                 OPEN gglq704_qc_cs2 USING l_aag01_str,l_aao02,l_i,'2'
#                 FETCH gglq704_qc_cs2 INTO l_aao062
#                 CLOSE gglq704_qc_cs2
#                 IF cl_null(l_aao062) THEN LET l_aao062 = 0 END IF
#              #END IF   #FUN-C80102 mark
#              #No.CHI-C70031  --Begin
#              LET l_aeh11 = 0
#              LET l_aeh12 = 0
#              SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
#              CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, l_aao02,l_aao02,NULL,
#              NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
#              0,       l_i-1,       NULL,      NULL,     NULL,    NULL,
#              NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
#              RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
#              #No.CHI-C70031  --End 
#              LET qc_aao05 = l_aao051 + l_aao052-l_aeh11   #CHI-C70031 add l_aeh11
#              LET qc_aao06 = l_aao061 + l_aao062- l_aeh12  #CHI-C70031 add l_aeh12
#              
#              #期間
#              LET l_aao051 = 0  LET l_aao061 = 0
#              LET l_aao052 = 0  LET l_aao062 = 0
#
#              OPEN gglq704_qj_cs1 USING sr1.aag01,l_aao02,l_i
#              FETCH gglq704_qj_cs1 INTO l_aao051,l_aao061
#              CLOSE gglq704_qj_cs1
#              IF cl_null(l_aao051) THEN LET l_aao051 = 0 END IF
#              IF cl_null(l_aao061) THEN LET l_aao061 = 0 END IF
#
#              #IF tm.b = 'Y' THEN   #FUN-C80102 mark
#                 OPEN gglq704_qj_cs2 USING l_aag01_str,l_aao02,l_i,'1'
#                 FETCH gglq704_qj_cs2 INTO l_aao052
#                 CLOSE gglq704_qj_cs2
#                 IF cl_null(l_aao052) THEN LET l_aao052 = 0 END IF
#
#                 OPEN gglq704_qj_cs2 USING l_aag01_str,l_aao02,l_i,'2'
#                 FETCH gglq704_qj_cs2 INTO l_aao062
#                 CLOSE gglq704_qj_cs2
#                 IF cl_null(l_aao062) THEN LET l_aao062 = 0 END IF
#              #END IF    #FUN-C80102 mark
#              #No.CHI-C70031  --Begin
#              LET l_aeh11 = 0
#              LET l_aeh12 = 0
#              SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
#              CALL s_minus_ce(tm.o, sr1.aag01, sr1.aag01, l_aao02,l_aao02,NULL,
#              NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
#              l_i,       l_i,       NULL,      NULL,     NULL,    NULL,
#              NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
#              RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
#              #No.CHI-C70031  --End
#              LET qj_aao05 = l_aao051 + l_aao052- l_aeh11  #CHI-C70031 add l_aeh11
#              LET qj_aao06 = l_aao061 + l_aao062- l_aeh12  #CHI-C70031 add l_aeh12
#              
#              #無期初也沒有本期異動，則不打印
#              IF qc_aao05 = 0 AND qc_aao06 = 0 AND
#                 qj_aao05 = 0 AND qj_aao06 = 0 THEN
#                 CONTINUE FOR
#              END IF
#
#              INITIALIZE sr.* TO NULL
#              LET sr.aao01  = sr1.aag01
#              LET sr.aag02  = sr1.aag02
#              LET sr.aao04  = l_i
#              LET sr.aao02  = l_aao02
#              #取部門名稱
#              SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = l_aao02
#              LET sr.aao05 = qj_aao05
#              LET sr.aao06 = qj_aao06
#              LET sr.qcye  = qc_aao05 - qc_aao06
#              OUTPUT TO REPORT gglq704_rep(sr.*,'','','','') #TQC-930163 
#          END FOR
#      END FOREACH
#    END FOREACH
#    FINISH REPORT gglq704_rep
#    CALL gglq704_tmp_sum()                       #No.FUN-A80034
#END FUNCTION
#FUN-D30014--mark--end--

#FUN-D30014--add--str--
FUNCTION gglq704v()
   DEFINE l_name             LIKE type_file.chr20,
          #l_sql              LIKE type_file.chr1000,
          #l_sql1             LIKE type_file.chr1000,
          l_sql,l_sql1       STRING,       #NO.FUN-910082
          l_aao              LIKE type_file.chr1000,
          l_abb              LIKE type_file.chr1000,
          l_i                LIKE type_file.num5,
          qc_aao05           LIKE aao_file.aao05,  #期初
          qc_aao06           LIKE aao_file.aao06,
          qj_aao05           LIKE aao_file.aao05,  #期間
          qj_aao06           LIKE aao_file.aao06,
          l_aao051           LIKE aao_file.aao05,
          l_aao061           LIKE aao_file.aao06,
          l_aao052           LIKE aao_file.aao05,
          l_aao062           LIKE aao_file.aao06,
          l_aao01            LIKE aao_file.aao01,   #FUN-D30014
          l_aao02            LIKE aao_file.aao02,
          l_aag01_str        LIKE type_file.chr50,
          l_aaa09            LIKE aaa_file.aaa09,  
          l_aeh11            LIKE aeh_file.aeh11,   
          l_aeh12            LIKE aeh_file.aeh12,   
          l_aeh15            LIKE aeh_file.aeh15,   
          l_aeh16            LIKE aeh_file.aeh16,   
          l_aeh11_1          LIKE aeh_file.aeh11,   #FUN-D30014
          l_aeh12_1          LIKE aeh_file.aeh12,   #FUN-D30014
          l_aeh15_1          LIKE aeh_file.aeh15,   #FUN-D30014
          l_aeh16_1          LIKE aeh_file.aeh16,   #FUN-D30014
          l_bal              LIKE aao_file.aao05,   #FUN-D30014
          l_pb_bal           LIKE aao_file.aao05,   #FUN-D30014
          l_pb_dc            LIKE type_file.chr10,  #FUN-D30014
          l_dc               LIKE type_file.chr10,  #FUN-D30014
          sr1                RECORD
                             aag01    LIKE aag_file.aag01,
                             aag02    LIKE aag_file.aag02
                             END RECORD,
          sr                 RECORD
                             aao01    LIKE aao_file.aao01,
                             aag02    LIKE aag_file.aag02,
                             aao04    LIKE aao_file.aao04,
                             aao02    LIKE aao_file.aao02,
                             gem02    LIKE gem_file.gem02,
                             aao05    LIKE aao_file.aao05,
                             aao06    LIKE aao_file.aao06,
                             qcye     LIKE aao_file.aao05
                             END RECORD
   DEFINE l_wc2              STRING  
   DEFINE qj_sum_aao05       LIKE aao_file.aao05  #MOD-DB0058 add
   DEFINE qj_sum_aao06       LIKE aao_file.aao06  #MOD-DB0058 add
     DISPLAY "START TIME:",TIME
     CALL gglq704_table()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
     #科目
     LET tm.wc = cl_replace_str(tm.wc,'aao01','aag01')
     LET l_sql = "INSERT INTO gglq704_temp1 "
     LET l_sql = l_sql," SELECT UNIQUE aag01,aag02,aao02,'' FROM aag_file ",
            #    "  LEFT OUTER JOIN aao_file ON aao00 = aag00 AND aao02 <> ' ' AND aao02 IS NOT NULL ",
                 "  ,aao_file WHERE aao00 = aag00 AND aao02 <> ' ' AND aao02 IS NOT NULL ",
                 "    AND aao01 LIKE aag01||'%' ",
                 "    AND aag00 = '",tm.o,"'",
            #    "  WHERE aag00 = '",tm.o,"'",
                 "    AND ",tm.wc CLIPPED,
                 "    AND ",tm.wc1
     IF tm.aag07 = '3' THEN                     
        LET l_sql = l_sql CLIPPED
     ELSE
        LET l_sql = l_sql CLIPPED,
                    "    AND ((aag07 ='",tm.aag07,"' AND aag24 = '",tm.aag24,"') OR aag07 = '3')"   
     END IF 
     IF tm.aag09 = 'Y' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag09 = 'Y' "
     END IF

     IF tm.aag38 = 'N' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag38 = 'N' "
     END IF
     PREPARE gglq704_prep FROM l_sql
     EXECUTE gglq704_prep

     LET l_sql = "INSERT INTO gglq704_temp1 "
     LET l_sql = l_sql," SELECT UNIQUE aag01,aag02,abb05,'' FROM aag_file,aba_file,abb_file ",
                 "   WHERE aba00 = abb00 AND aba01 = abb01 AND aag00 = aba00 AND abb03 LIKE aag01||'%'",
                 "    AND abb05 IS NOT NULL AND abb05 <> ' '",
                 "    AND aag00 = '",tm.o,"'",
                 "    AND ",tm.wc CLIPPED,
                 "    AND ",tm.wc1
     IF tm.aag07 = '3' THEN
        LET l_sql = l_sql CLIPPED
     ELSE
        LET l_sql = l_sql CLIPPED,
                    "    AND ((aag07 ='",tm.aag07,"' AND aag24 = '",tm.aag24,"') OR aag07 = '3')"
     END IF
     IF tm.aag09 = 'Y' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag09 = 'Y' "
     END IF

     IF tm.aag38 = 'N' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag38 = 'N' "
     END IF
     IF tm.g = 'Y' THEN
        IF tm.b = '1' THEN
           LET l_sql = l_sql , "AND (aba19 = 'N' or aba19 ='Y')"
        ELSE
           LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))"
        END IF
     END IF
     IF tm.g = 'N' THEN
        IF tm.b = '1' THEN
           LET l_sql = l_sql," AND  aba19 ='Y'"
        ELSE
           LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'"
        END IF
     END IF
     PREPARE gglq704_prep1 FROM l_sql
     EXECUTE gglq704_prep1

     DECLARE gglq704_aao02_cs3 CURSOR FOR
             SELECT UNIQUE * FROM gglq704_temp1 

     #共用條件
     LET l_aao = "SELECT SUM(aao05),SUM(aao06) FROM aao_file",
                 " WHERE aao00 = '",tm.o,"'",
                 "   AND aao01 = ? ",                   #科目
                 "   AND aao02 = ? ",                   #部門
                 "   AND aao03 = ",tm.yy

     LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",tm.o,"'",
                 "    AND abb03 LIKE ?   ",             #科目
                 "    AND abb05 = ? ",                  #部門值
                 "    AND aba03 = ",tm.yy
     IF tm.g = 'Y' THEN
        IF tm.b = '1' THEN
           LET l_abb = l_abb , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_abb = l_abb, "  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.g = 'N' THEN
        IF tm.b = '1' THEN
           LET l_abb = l_abb, " AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_abb = l_abb, " AND  aba19 = 1 "
        END IF
     END IF
     #lujh 1219--add--end--

     #當期異動
     LET l_sql1 = l_aao CLIPPED, "   AND aao04 = ? "  #當期
     PREPARE gglq704_qj_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq704_qj_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq704_qj_cs1 CURSOR FOR gglq704_qj_p1

     #tm.b = 'Y' #未過帳 - 借/貸
     LET l_sql1 = " SELECT SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
                  "    AND aba04 = ?   ",              #當期未過帳資料
                  "    AND abb06 = ?   "
     PREPARE gglq704_qj_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq704_qj_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq704_qj_cs2 CURSOR FOR gglq704_qj_p2

     #期初余額
     LET l_sql1 = l_aao CLIPPED, "   AND aao04 < ? "  #期初
     PREPARE gglq704_qc_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq704_qc_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq704_qc_cs1 CURSOR FOR gglq704_qc_p1

     #tm.b = 'Y' #未過帳 - 借/貸
     LET l_sql1 = " SELECT SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
                  "    AND aba04 < ?   ",              #當期未過帳資料
                  "    AND abb06 = ?   "
     PREPARE gglq704_qc_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq704_qc_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq704_qc_cs2 CURSOR FOR gglq704_qc_p2 

     PREPARE gglq704_aao02_prep2 FROM l_sql1
     EXECUTE gglq704_aao02_prep2
     
     FOREACH gglq704_aao02_cs3 INTO sr1.*,l_aao02
         IF SQLCA.sqlcode THEN
            CALL cl_err('gglq704_aao02_cs3 foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET l_aag01_str = sr1.aag01 CLIPPED,'\%'   
         LET l_bal = 0   LET l_pb_bal = 0
        #FOR l_i = tm.m1 TO tm.m2     #MOD-DB0058 mark
             #期初
             LET l_aao051 = 0  LET l_aao061 = 0
             LET l_aao052 = 0  LET l_aao062 = 0
            #OPEN gglq704_qc_cs1 USING sr1.aag01,l_aao02,l_i  #MOD-DB0058 mark
             OPEN gglq704_qc_cs1 USING sr1.aag01,l_aao02,tm.m1  #MOD-DB0058 
               FETCH gglq704_qc_cs1 INTO l_aao051,l_aao061
               CLOSE gglq704_qc_cs1
               IF cl_null(l_aao051) THEN LET l_aao051 = 0 END IF
               IF cl_null(l_aao061) THEN LET l_aao061 = 0 END IF

               #IF tm.b = 'Y' THEN   #FUN-C80102 mark
               #IF tm.b = '1' THEN    #lujh 1219 add
                 #OPEN gglq704_qc_cs2 USING l_aag01_str,l_aao02,l_i,'1' #MOD-DB0058 mark
                  OPEN gglq704_qc_cs2 USING l_aag01_str,l_aao02,tm.m1,'1' #MOD-DB0058 
                  FETCH gglq704_qc_cs2 INTO l_aao052
                  CLOSE gglq704_qc_cs2
                  IF cl_null(l_aao052) THEN LET l_aao052 = 0 END IF

                 #OPEN gglq704_qc_cs2 USING l_aag01_str,l_aao02,tm.m1,'2' #MOD-DB0058 mark
                  OPEN gglq704_qc_cs2 USING l_aag01_str,l_aao02,tm.m1,'2' #MOD-DB0058 
                  FETCH gglq704_qc_cs2 INTO l_aao062
                  CLOSE gglq704_qc_cs2
                  IF cl_null(l_aao062) THEN LET l_aao062 = 0 END IF
               #END IF   #FUN-C80102 mark   #lujh 1219 unmark
               #No.CHI-C70031  --Begin
               LET l_aeh11 = 0
               LET l_aeh12 = 0
               SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
               CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, l_aao02,l_aao02,NULL,
               NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
             # 0,       l_i-1,       NULL,      NULL,     NULL,    NULL,     #MOD-DB0058 mark
               0,       tm.m1-1,       NULL,      NULL,     NULL,    NULL,   #MOD-DB0058
               NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
               RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
               #No.CHI-C70031  --End
               IF tm.i = 'N' THEN    #FUN-D40044 add
                  LET qc_aao05 = l_aao051 + l_aao052 -l_aeh11   #CHI-C70031 add l_aeh11
                  LET qc_aao06 = l_aao061 + l_aao062- l_aeh12   #CHI-C70031 add l_aeh12
               #FUN-D40044--add--str--
               ELSE
                  LET qc_aao05 = l_aao051 + l_aao052
                  LET qc_aao06 = l_aao061 + l_aao062
               END IF  
               #FUN-D40044--add--end--
          LET qj_sum_aao05 = 0 #MOD-DB0058 add
          LET qj_sum_aao06 = 0 #MOD-DB0058 add
          FOR l_i = tm.m1 TO tm.m2     #MOD-DB0058
             OPEN gglq704_qj_cs1 USING sr1.aag01,l_aao02,l_i
               FETCH gglq704_qj_cs1 INTO l_aao051,l_aao061
               CLOSE gglq704_qj_cs1
               IF cl_null(l_aao051) THEN LET l_aao051 = 0 END IF
               IF cl_null(l_aao061) THEN LET l_aao061 = 0 END IF

               #IF tm.b = 'Y' THEN   #FUN-C80102 mark
               #IF tm.b = '1' THEN   #lujh 1219  add
                  OPEN gglq704_qj_cs2 USING l_aag01_str,l_aao02,l_i,'1'
                  FETCH gglq704_qj_cs2 INTO l_aao052
                  CLOSE gglq704_qj_cs2
                  IF cl_null(l_aao052) THEN LET l_aao052 = 0 END IF

                  OPEN gglq704_qj_cs2 USING l_aag01_str,l_aao02,l_i,'2'
                  FETCH gglq704_qj_cs2 INTO l_aao062
                  CLOSE gglq704_qj_cs2
                  IF cl_null(l_aao062) THEN LET l_aao062 = 0 END IF
               #END IF    #FUN-C80102 mark   #lujh 1219 unmark
               LET l_aeh11 = 0
               LET l_aeh12 = 0
               SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
               CALL s_minus_ce(tm.o, sr1.aag01, sr1.aag01, l_aao02,l_aao02,NULL,
               NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
               l_i,       l_i,       NULL,      NULL,     NULL,    NULL,
               NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
               RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16

               IF tm.i = 'N' THEN    #FUN-D40044 add
                  LET qj_aao05 = l_aao051 + l_aao052- l_aeh11  #CHI-C70031 add l_aeh11
                  LET qj_aao06 = l_aao061 + l_aao062- l_aeh12  #CHI-C70031 add l_aeh12
               #FUN-D40044--add--str--
               ELSE
                  LET qj_aao05 = l_aao051 + l_aao052
                  LET qj_aao06 = l_aao061 + l_aao062
               END IF 
               #FUN-D40044--add--end--
             #無期初也沒有本期異動，則不打印
             IF qc_aao05 = 0 AND qc_aao06 = 0 AND
                qj_aao05 = 0 AND qj_aao06 = 0 THEN
                CONTINUE FOR                   
             END IF
               LET qj_sum_aao05 = qj_sum_aao05 + qj_aao05  #MOD-DB0058 add
               LET qj_sum_aao06 = qj_sum_aao06 + qj_aao06  #MOD-DB0058 add
               
           END FOR    #MOD-DB0058    
             
          
             INITIALIZE sr.* TO NULL
             LET sr.aao01  = sr1.aag01
             LET sr.aag02  = sr1.aag02
            #LET sr.aao04  = l_i    #MOD-DB0058 mark
             LET sr.aao04  = l_i-1  #MOD-DB0058
             LET sr.aao02  = l_aao02
             #取部門名稱
             SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = l_aao02
            #LET sr.aao05 = qj_aao05   #MOD-DB0058 mark
            #LET sr.aao06 = qj_aao06   #MOD-DB0058 mark
             LET sr.aao05 = qj_sum_aao05   #MOD-DB0058 
             LET sr.aao06 = qj_sum_aao06   #MOD-DB0058
             LET sr.qcye  = qc_aao05 - qc_aao06
             IF cl_null(sr.aao05) THEN LET sr.aao05 = 0 END IF
             IF cl_null(sr.aao06) THEN LET sr.aao06 = 0 END IF
             LET l_bal = sr.aao05 - sr.aao06 + sr.qcye
             IF sr.qcye < 0 THEN
                LET l_pb_bal = sr.qcye * -1
             ELSE
                LET l_pb_bal = sr.qcye 
             END IF
             IF l_bal < 0 THEN
                LET l_bal = l_bal * -1
             ELSE 
                LET l_bal = l_bal
             END IF

             #FUN-D30014----add---str---
             IF sr.qcye > 0 THEN
                CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
             ELSE
                IF sr.qcye = 0 THEN
                   CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
                ELSE
                   CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
                END IF
             END IF

             IF (sr.aao05 - sr.aao06 + sr.qcye) > 0 THEN
                CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
             ELSE
                IF (sr.aao05 - sr.aao06 + sr.qcye)  = 0 THEN
                   CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
                ELSE
                   CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
                END IF
             END IF
             #FUN-D30014----add---end---

             INSERT INTO gglq704_tmp
              VALUES(sr.aao01,sr.aag02,sr.aao04,sr.aao02,sr.gem02,'2',
                     '',l_pb_dc,0,0,l_pb_bal,'',0,0,sr.aao05,0,0,sr.aao06,l_dc,0,0,l_bal)
        #END FOR    #MOD-DB0058 mark
     END FOREACH
     
     CALL gglq704_tmp_sum()                     
     DISPLAY "END TIME:",TIME
END FUNCTION
#FUN-D30014---add--end--
 
REPORT gglq704_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,
          sr        RECORD
                    aao01    LIKE aao_file.aao01,
                    aag02    LIKE aag_file.aag02,
                    aao04    LIKE aao_file.aao04,
                    aao02    LIKE aao_file.aao02,
                    gem02    LIKE gem_file.gem02,
                    aao05    LIKE aao_file.aao05,
                    aao06    LIKE aao_file.aao06,
                    qcye     LIKE aao_file.aao05,
                    #TQC-930163  --begin
                    tao09    LIKE tao_file.tao09,
                    tao10    LIKE tao_file.tao10,
                    tao11    LIKE tao_file.tao11,
                    qcyef    LIKE tao_file.tao10
                    #TQC-930163  --end
                    END RECORD,
          l_cnt                        LIKE type_file.num5,
          t_bal                        LIKE aao_file.aao05,
	  n_bal                        LIKE aao_file.aao05,
          n_pb_bal                     LIKE aao_file.aao05,
          t_balf                       LIKE aao_file.aao05,#TQC-930163 
	  n_balf                       LIKE aao_file.aao05,#TQC-930163 
          n_pb_balf                    LIKE aao_file.aao05,#TQC-930163 
          l_abb25_pb                   LIKE abb_file.abb25,#TQC-930163                       
          l_abb25_d                    LIKE abb_file.abb25,#TQC-930163
          l_abb25_c                    LIKE abb_file.abb25,#TQC-930163
          l_abb25_bal                  LIKE abb_file.abb25,#TQC-930163
          l_pb_dc                      LIKE type_file.chr10,
          l_dc                         LIKE type_file.chr10
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aao01,sr.aao04,sr.aao02
  FORMAT
   PAGE HEADER
      LET g_pageno = g_pageno + 1
 
   ON EVERY ROW
         IF cl_null(sr.aao05) THEN LET sr.aao05 = 0 END IF
         IF cl_null(sr.aao06) THEN LET sr.aao06 = 0 END IF
         LET t_bal   = sr.aao05 - sr.aao06 + sr.qcye
         LET t_balf  = sr.tao10 - sr.tao11 + sr.qcyef #TQC-930163 
 
         IF sr.qcye > 0 THEN
            LET n_pb_bal = sr.qcye
            LET n_pb_balf= sr.qcyef #TQC-930163 
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
         ELSE
            IF sr.qcye = 0 THEN
               LET n_pb_bal = sr.qcye
               LET n_pb_balf= sr.qcyef  #TQC-930163 
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
            ELSE
               LET n_pb_bal = sr.qcye * -1
               LET n_pb_balf= sr.qcyef * -1 #TQC-930163 
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
            END IF
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf  #TQC-930163 
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf  #TQC-930163 
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf * -1  #TQC-930163 
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
         #TQC-930163  --begin
         LET l_abb25_pb = n_pb_bal / n_pb_balf    
         LET l_abb25_d  = sr.aao05 / sr.tao10
         LET l_abb25_c  = sr.aao06 / sr.tao11
         LET l_abb25_bal = n_bal / n_balf    
         IF cl_null(l_abb25_pb) THEN LET l_abb25_pb = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         #TQC-930163  --end
 
         INSERT INTO gglq704_tmp
       #TQC-930163  --begin
       # VALUES(sr.aao01,sr.aag02,sr.aao04,sr.aao02,sr.gem02,'2',
       #        l_pb_dc,n_pb_bal,'',sr.aao05,sr.aao06,l_dc,n_bal)
         VALUES(sr.aao01,sr.aag02,sr.aao04,sr.aao02,sr.gem02,'2',
                sr.tao09,l_pb_dc,n_pb_balf,l_abb25_pb,n_pb_bal,'',sr.tao10,
                l_abb25_d,sr.aao05,sr.tao11,l_abb25_c,sr.aao06,l_dc,
                n_balf,l_abb25_bal,n_bal) 
       #TQC-930163  --end
 
END REPORT
 
FUNCTION gglq704_table()
     DROP TABLE gglq704_aao02;
     CREATE TEMP TABLE gglq704_aao02(
                    aao01       LIKE aao_file.aao01,  #FUN-CB0146  add
                    aao02       LIKE aao_file.aao02,
                    tao09       LIKE tao_file.tao09); #TQC-930163 
     CREATE UNIQUE INDEX gglq704_aao02_01 ON gglq704_aao02(aao02,tao09); #TQC-930163 

     #FUN-D30014----add---str--
     DROP TABLE gglq704_temp1;
     CREATE TEMP TABLE gglq704_temp1(
                    aag01       LIKE aag_file.aag01,
                    aag02       LIKE aag_file.aag02,
                    aao02       LIKE aao_file.aao02,
                    tao09       LIKE tao_file.tao09);
     #FUN-D30014----add---end--
                  
     DROP TABLE gglq704_tmp;
     CREATE TEMP TABLE gglq704_tmp(
                    aao01       LIKE aao_file.aao01,
#                   aag02       LIKE aag_file.aag02,
                    aag02       LIKE type_file.chr1000,      #No.MOD-940388
                    aao04       LIKE aao_file.aao05,
                    aao02       LIKE aao_file.aao02,
                    gem02       LIKE gem_file.gem02,
                    type        LIKE type_file.chr1,
                    tao09       LIKE tao_file.tao09, #TQC-930163 
                    pb_dc       LIKE type_file.chr10,
                    pb_balf     LIKE aao_file.aao05, #TQC-930163 
                    abb25_pb    LIKE abb_file.abb25, #TQC-930163 
                    pb_bal      LIKE aao_file.aao05,
                    memo        LIKE ze_file.ze03,
                    df          LIKE aao_file.aao05, #TQC-930163 
                    abb25_d     LIKE abb_file.abb25, #TQC-930163 
                    d           LIKE aao_file.aao05,
                    cf          LIKE aao_file.aao05, #TQC-930163 
                    abb25_c     LIKE abb_file.abb25, #TQC-930163 
                    c           LIKE aao_file.aao05,
                    dc          LIKE type_file.chr10,
                    balf        LIKE aao_file.aao05, #TQC-930163                   
                    abb25_bal   LIKE abb_file.abb25, #TQC-930163 
                    bal         LIKE aao_file.aao05); 
                    
END FUNCTION
 
FUNCTION q704_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aao TO s_aao.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION drill_detail
         LET g_action_choice="drill_detail"
         EXIT DISPLAY
 
      ON ACTION first
         CALL gglq704_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL gglq704_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL gglq704_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL gglq704_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL gglq704_fetch('L')
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
 
FUNCTION gglq704_cs()
     #FUN-C80102--add--str--
     IF tm.f = 'Y' THEN 
        IF tm.e = 'Y' THEN 
           LET g_sql = "SELECT UNIQUE aao01,aag02,aao04,tao09 FROM gglq704_tmp ",
                 " ORDER BY aao01,aag02,aao04,tao09"
        ELSE
           LET g_sql = "SELECT UNIQUE aao01,aag02,aao04,'' FROM gglq704_tmp ",
                 " ORDER BY aao01,aag02,aao04"
        END IF 
     ELSE
        IF tm.e = 'Y' THEN 
           LET g_sql = "SELECT UNIQUE '','',aao04,tao09 FROM gglq704_tmp ",
                 " ORDER BY tao09"
        ELSE
           LET g_sql = "SELECT UNIQUE '','',aao04,'' FROM gglq704_tmp "
                 #" ORDER BY aao01,aag02,aao04"
        END IF
     END IF 
     #FUN-C80102--add--end--
     
     #FUN-C80102--mark--str--
     #LET g_sql = "SELECT UNIQUE aao01,aag02,aao04 FROM gglq704_tmp ",
     #            " ORDER BY aao01,aag02,aao04"
     #FUN-C80102--mark--end--
     PREPARE gglq704_ps FROM g_sql
     DECLARE gglq704_curs SCROLL CURSOR WITH HOLD FOR gglq704_ps

     #FUN-C80102--add--str--
     IF tm.f = 'Y' THEN 
        IF tm.e = 'Y' THEN 
           LET g_sql = "SELECT UNIQUE aao01,aag02,aao04,tao09 FROM gglq704_tmp ",
                       "  INTO TEMP x "
        ELSE
           LET g_sql = "SELECT UNIQUE aao01,aag02,aao04 FROM gglq704_tmp ",
                       "  INTO TEMP x "
        END IF 
     ELSE
        IF tm.e = 'Y' THEN 
           LET g_sql = "SELECT UNIQUE tao09 FROM gglq704_tmp ",
                       "  INTO TEMP x "
        ELSE
           LET g_sql = "SELECT * FROM gglq704_tmp ",
                       "  INTO TEMP x "
        END IF 
     END IF 
     #FUN-C80102--add--end--

     #FUN-C80102--mark--str--
     #LET g_sql = "SELECT UNIQUE aao01,aag02,aao04 FROM gglq704_tmp ",
     #            "  INTO TEMP x "
     #FUN-C80102--mark--end--
     DROP TABLE x
     PREPARE gglq704_ps1 FROM g_sql
     EXECUTE gglq704_ps1

     LET g_sql = "SELECT COUNT(*) FROM x",
                 "  WHERE ",tm.wc2,   #FUN-C80102 add
                 "    AND ",tm.wc1    #FUN-C80102 add
     PREPARE gglq704_ps2 FROM g_sql
     DECLARE gglq704_cnt CURSOR FOR gglq704_ps2
 
     OPEN gglq704_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq704_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq704_cnt
        FETCH gglq704_cnt INTO g_row_count 
        IF tm.f = 'Y' THEN  #FUN-C80102 add
           DISPLAY g_row_count TO FORMONLY.cnt
           CALL gglq704_fetch('F')
        #FUN-C80102--add--str--
        ELSE
           IF tm.e = 'Y' THEN 
              DISPLAY g_row_count TO FORMONLY.cnt
           END IF          
        END IF 
        IF g_row_count = '0' THEN 
           INITIALIZE tm.* TO NULL
        END IF 
        CALL gglq704_fetch('F') 
        #FUN-C80102--add--end--
     END IF
END FUNCTION
 
FUNCTION gglq704_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq704_curs INTO g_aao01,g_aag02,g_aao04,g_tao09   #FUN-C80102  add #FUN-C80102
      WHEN 'P' FETCH PREVIOUS gglq704_curs INTO g_aao01,g_aag02,g_aao04,g_tao09   #FUN-C80102  add #FUN-C80102
      WHEN 'F' FETCH FIRST    gglq704_curs INTO g_aao01,g_aag02,g_aao04,g_tao09   #FUN-C80102  add #FUN-C80102
      WHEN 'L' FETCH LAST     gglq704_curs INTO g_aao01,g_aag02,g_aao04,g_tao09   #FUN-C80102  add #FUN-C80102
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
         FETCH ABSOLUTE g_jump gglq704_curs INTO g_aao01,g_aag02,g_aao04,g_tao09  #FUN-C80102  add g_tao09
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aao01,SQLCA.sqlcode,0)
      INITIALIZE g_aao01 TO NULL
      INITIALIZE g_aag02 TO NULL
      INITIALIZE g_aao04 TO NULL
      INITIALIZE g_tao09 TO NULL    #FUN-C80102  add
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      #FUN-C80102--add--str-- 
      IF tm.f = 'N' THEN 
         IF tm.e = 'N' THEN 
            LET g_row_count = '0'
         END IF 
      END IF 
      #FUN-C80102--add--end-- 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   CALL gglq704_show()
END FUNCTION
 
FUNCTION gglq704_show()
 
   DISPLAY g_aao01 TO aao01
   DISPLAY g_aag02 TO aag02
   DISPLAY tm.o    TO o
   DISPLAY tm.yy   TO yy
   DISPLAY tm.m1   TO m1
   DISPLAY tm.m2   TO m2
   DISPLAY tm.b    TO b
   DISPLAY tm.aag07 TO aag07   #TQC-CC0122 add
   DISPLAY tm.aag24 TO aag24   #TQC-CC0122 add
   DISPLAY tm.aag09 TO aag09   #TQC-CC0122 add
   DISPLAY tm.aag38 TO aag38   #TQC-CC0122 add
   DISPLAY tm.g    TO g    #FUN-C80102 add 
   DISPLAY tm.f    TO f    #FUN-C80102 add 
   DISPLAY tm.a    TO a
   DISPLAY tm.e    TO e
   #DISPLAY g_aao04 TO mm   #FUN-C80102 mark
   DISPLAY tm.i    TO i   #FUN-D40044 add
   
   CALL gglq704_b_fill()
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION gglq704_b_fill()
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1
  DEFINE  l_memo     LIKE abb_file.abb04
  DEFINE  l_qyce     LIKE aao_file.aao05  #FUN-D30014
  DEFINE  qc_aao05   LIKE aao_file.aao05  #FUN-D30014
  DEFINE  qc_aao06   LIKE aao_file.aao05  #FUN-D30014
  DEFINE  l_cr       LIKE type_file.chr10 #MOD-D60148
  
  #TQC-930163  --begin
  #LET g_sql = "SELECT aao02,gem02,pb_dc,pb_bal,",
  #            "       d,c,dc,bal,type,memo ",
   IF tm.f = 'Y' THEN  #FUN-C80102 add
      IF tm.e = 'Y' THEN    #FUN-C80102 add
         LET g_sql = "SELECT aao01,aag02,aao02,gem02,tao09,pb_dc,pb_balf,abb25_pb,pb_bal,",    #FUN-C80102 add aao01,aag02
                     "       df,abb25_d,d,cf,abb25_c,c,dc,balf,abb25_bal,bal,type,memo ",
   #TQC-930163  --end
                     " FROM gglq704_tmp",
                     " WHERE aao01 ='",g_aao01,"'",
                     "   AND tao09 ='",g_tao09,"'",   #FUN-C80102 add
                     "   AND aao04 = ",g_aao04,
                     "   AND ",tm.wc2,                #FUN-C80102 add
                     " ORDER BY tao09,type,aao02,gem02 "   #No.FUN-A80034
   #FUN-C80102--add--str--
      ELSE
         LET g_sql = "SELECT aao01,aag02,aao02,gem02,tao09,pb_dc,pb_balf,abb25_pb,pb_bal,",    
                     "       df,abb25_d,d,cf,abb25_c,c,dc,balf,abb25_bal,bal,type,memo ",
                     " FROM gglq704_tmp",
                     " WHERE aao01 ='",g_aao01,"'",
                     "   AND aao04 = ",g_aao04,
                     "   AND ",tm.wc2,               
                     " ORDER BY tao09,type,aao02,gem02 "   
      END IF 
   ELSE
      IF tm.e = 'Y' THEN 
         LET g_sql = "SELECT aao01,aag02,aao02,gem02,tao09,pb_dc,pb_balf,abb25_pb,pb_bal,",    #FUN-C80102 add aao01,aag02
                     "       df,abb25_d,d,cf,abb25_c,c,dc,balf,abb25_bal,bal,type,memo ",
                     " FROM gglq704_tmp",
                     " WHERE ",tm.wc2,  
                     "   AND tao09 ='",g_tao09,"'",
                     " ORDER BY tao09,type,aao02,gem02 "  
      ELSE
         LET g_sql = "SELECT aao01,aag02,aao02,gem02,tao09,pb_dc,pb_balf,abb25_pb,pb_bal,",    #FUN-C80102 add aao01,aag02
                     "       df,abb25_d,d,cf,abb25_c,c,dc,balf,abb25_bal,bal,type,memo ",
                     " FROM gglq704_tmp",
                     " WHERE ",tm.wc2,        
                     " ORDER BY tao09,type,aao02,gem02 "  
      END IF 
   END IF 
   #FUN-C80102--add--end--
 
   PREPARE gglq704_pb FROM g_sql
   DECLARE aao_curs  CURSOR FOR gglq704_pb
 
   CALL g_aao.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH aao_curs INTO g_aao[g_cnt].*,l_type,l_memo
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_aao[g_cnt].d      = cl_numfor(g_aao[g_cnt].d,20,g_azi04)
      LET g_aao[g_cnt].c      = cl_numfor(g_aao[g_cnt].c,20,g_azi04)
      LET g_aao[g_cnt].bal    = cl_numfor(g_aao[g_cnt].bal,20,g_azi04)
      LET g_aao[g_cnt].pb_bal = cl_numfor(g_aao[g_cnt].pb_bal,20,g_azi04)

      #FUN-D30014----add---str--
      LET g_aao[g_cnt].abb25_pb = g_aao[g_cnt].pb_bal / g_aao[g_cnt].pb_balf
      LET g_aao[g_cnt].abb25_d = g_aao[g_cnt].d / g_aao[g_cnt].df     
      LET g_aao[g_cnt].abb25_c = g_aao[g_cnt].c / g_aao[g_cnt].cf     
      LET g_aao[g_cnt].abb25_bal = g_aao[g_cnt].bal / g_aao[g_cnt].balf
      #FUN-D30014----add---end--
    
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH


   #TQC-CC0122----add----str
   #MOD-D60148--begin   
   CALL cl_getmsg('ggl-212',g_lang) RETURNING l_cr  #貸  
   UPDATE gglq704_tmp 
      SET pb_balf = pb_balf*-1, pb_bal=pb_bal*-1
    WHERE pb_dc = l_cr
   UPDATE gglq704_tmp 
      SET balf = balf*-1 , bal =bal*-1
    WHERE dc = l_cr 
   #MOD-D60148--end 
   IF g_cnt - 1 > 0 THEN
      IF tm.f = 'N' THEN
         IF tm.aag07 <> '3' THEN          
            SELECT '','','','','','',SUM(pb_balf),'',SUM(pb_bal),
                   SUM(df),'',SUM(d),SUM(cf),'',SUM(c),'',SUM(balf),'',SUM(bal)
            INTO g_aao[g_cnt].*
            FROM gglq704_tmp  
         ELSE
            SELECT '','','','','','',SUM(pb_balf),'',SUM(pb_bal),
                   SUM(df),'',SUM(d),SUM(cf),'',SUM(c),'',SUM(balf),'',SUM(bal)
            INTO g_aao[g_cnt].*
            FROM gglq704_tmp
            WHERE aao01 IN (SELECT aag01 FROM aag_file WHERE (aag07 = '2' OR aag07 = '3') AND aag00 = tm.o) 
         END IF
      ELSE
         SELECT '','','','','','',SUM(pb_balf),'',SUM(pb_bal),
                   SUM(df),'',SUM(d),SUM(cf),'',SUM(c),'',SUM(balf),'',SUM(bal)
            INTO g_aao[g_cnt].*
            FROM gglq704_tmp
         WHERE aao01 =g_aao01
      END IF
      
#MOD-D60148--begin
#      LET g_aao[g_cnt].pb_dc = cl_getmsg('axr107',g_lang)
      LET g_aao[g_cnt].gem02 = cl_getmsg('axr107',g_lang)
      IF g_aao[g_cnt].pb_bal>0 THEN
         CALL cl_getmsg('ggl-211',g_lang) RETURNING g_aao[g_cnt].pb_dc
      ELSE
      	 IF g_aao[g_cnt].pb_bal=0 THEN
      	    CALL cl_getmsg('ggl-210',g_lang) RETURNING g_aao[g_cnt].pb_dc
      	 ELSE
      	 	  LET g_aao[g_cnt].pb_bal = g_aao[g_cnt].pb_bal *-1
      	 	  CALL cl_getmsg('ggl-212',g_lang) RETURNING g_aao[g_cnt].pb_dc
      	 END IF
      END IF
      IF g_aao[g_cnt].bal>0 THEN
         CALL cl_getmsg('ggl-211',g_lang) RETURNING g_aao[g_cnt].dc
      ELSE
      	 IF g_aao[g_cnt].bal=0 THEN
      	    CALL cl_getmsg('ggl-210',g_lang) RETURNING g_aao[g_cnt].dc
      	 ELSE
      	 	  LET g_aao[g_cnt].bal = g_aao[g_cnt].bal *-1
      	 	  CALL cl_getmsg('ggl-212',g_lang) RETURNING g_aao[g_cnt].dc
      	 END IF
      END IF
#MOD-D60148--end
   END IF
   #TQC-CC0122--add--str--

   #FUN-C80102--add--str--
   IF tm.e = 'N' THEN
      LET g_aao[g_cnt].pb_balf = NULL
      LET g_aao[g_cnt].df = NULL
      LET g_aao[g_cnt].cf = NULL
      LET g_aao[g_cnt].balf = NULL
   END IF
   #FUN-C80102--add--end--
   #CALL g_aao.deleteElement(g_cnt)   #TQC-CC0122  mark
   LET g_rec_b = g_cnt - 1

   #FUN-C80102--add--str--
   IF tm.f = 'N' THEN
      IF tm.e = 'N' THEN
         DISPLAY g_rec_b TO FORMONLY.cnt
      END IF
   END IF
   #FUN-C80102--add--end--
 
END FUNCTION
 
FUNCTION q704_out_1()
   LET g_prog = 'gglq704'
   LET g_sql = "aao01.aao_file.aao01,",
               "aag02.aag_file.aag02,",
               "aao04.aao_file.aao04,",
               "aao02.type_file.chr50,",
               "gem02.gem_file.gem02,",
               "type.type_file.chr10,",
               "tao09.tao_file.tao09,",  #No.TQC-930163
               "pb_dc.type_file.chr10,",
               "pb_balf.aao_file.aao05,",  #No.TQC-930163
               "abb25_pb.abb_file.abb25,", #No.TQC-930163
               "pb_bal.aao_file.aao05,",
               "memo.abb_file.abb04,",
               "df.aao_file.aao05,",       #No.TQC-930163
               "abb25_d.abb_file.abb25,",  #No.TQC-930163
               "d.aao_file.aao05,",
               "cf.aao_file.aao05,",       #No.TQC-930163
               "abb25_c.abb_file.abb25,",  #No.TQC-930163
               "c.aao_file.aao05,",
               "dc.type_file.chr10,",
               "balf.aao_file.aao05,",     #No.TQC-930163
               "abb25_bal.abb_file.abb25,",#No.TQC-930163
               "bal.aao_file.aao05 "
 
   LET l_table = cl_prt_temptable('gglq704',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?,?,?,?,?,?,?,?,?, ",  #No.TQC-930163
               "        ?, ?, ? )                     "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION q704_out_2()
 
   LET g_prog = 'gglq704'
   CALL cl_del_data(l_table)
 
   DECLARE cr_curs CURSOR FOR
    SELECT * FROM gglq704_tmp
   FOREACH cr_curs INTO g_pr.*
       EXECUTE insert_prep USING g_pr.*
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'aao01')
           RETURNING g_str
   END IF
   LET g_str=g_str CLIPPED,";",tm.yy,";",g_azi04
 
   #IF tm.c = 'Y' THEN     #FUN-C80102  mark                                #No.TQC-930163
   IF tm.a = 'Y' THEN      #FUN-C80102  add
      CALL cl_prt_cs3('gglq704','gglq704_1',g_sql,g_str)  #No.TQC-930163 
   ELSE                                                   #No.TQC-930163 
      CALL cl_prt_cs3('gglq704','gglq704',g_sql,g_str)
   END IF   #No.TQC-930163
END FUNCTION
 
FUNCTION q704_drill_detail()
   DEFINE 
          #l_wc1   LIKE type_file.chr50
          l_wc1         STRING,       #NO.FUN-910082
          l_wc2         STRING       #NO.FUN-910082
  # DEFINE l_wc2   LIKE type_file.chr50
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_flag3 LIKE type_file.chr1  #TQC-930163 
 
   #IF g_aao01 IS NULL THEN RETURN END IF    #FUN-C80102  mark 
   IF g_aao[l_ac].aao01 IS NULL THEN RETURN END IF   #FUN-C80102  add
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_aao[l_ac].aao02) THEN RETURN END IF
 
  #LET l_wc1 = 'aag01 like "',g_aao01,'%"'            #FUN-C80102 
   LET l_wc1 = 'aag01 like "',g_aao[l_ac].aao01,'%"'  #FUN-C80102
   LET l_wc2 = 'tao02 = "',g_aao[l_ac].aao02,'"'
 
   #TQC-930163 --begin
   LET l_flag3='N'
   #IF tm.c ='Y' THEN    #FUN-C80102  mark 
   IF tm.a ='Y' THEN     #FUN-C80102  add
      LET l_wc2 = l_wc2 CLIPPED,' AND tao09 = "',g_aao[l_ac].tao09,'"'
      LET l_flag3='Y'
   END IF
   #TQC-930163 --end
   DISPLAY g_aao04 TO mm
   #CALL s_azn01(tm.yy,tm.m2) RETURNING l_bdate,l_edate
   #LET l_bdate = MDY(tm.m1,1,tm.yy)
   CALL s_azn01(tm.yy,g_aao04) RETURNING l_bdate,l_edate    #FUN-C80102  mark
   #CALL s_azn01(tm.yy,g_aao[l_ac].aao04) RETURNING l_bdate,l_edate     #FUN-C80102  add
  #LET g_msg = "gglq705 '",tm.o,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc1 CLIPPED,"' '",l_wc2 CLIPPED,"' '",l_bdate,"' '",l_edate,"' 'N' '",tm.b,"' '' '' '' ''" 
   #LET g_msg = "gglq705 '",tm.o,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc1 CLIPPED,"' '",l_wc2 CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.c,"' '",tm.b,"' '",l_flag3,"' '' '' '' '' " #TQC-930163  #FUN-C80102  mark
   #LET g_msg = "gglq705 '",tm.o,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc1 CLIPPED,"' '",l_wc2 CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.a,"' '",tm.b,"' '",l_flag3,"' '' '' '' '' '",tm.g,"' '1=1' '' "   #FUN-C80102  add  '",tm.g,"'  '1=1'  #TQC-CC0122  add ''  #FUN-D40044 mark
   #FUN-D40044--add--str--
   LET g_msg = "gglq705 '",tm.o,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc1 CLIPPED,
               "' '",l_wc2 CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.a,"' '",tm.b,
               "' '",l_flag3,"' '' '' '' '' '",tm.g,"' '1=1' '",tm.aag24,"' '",tm.f,
               "' 'N' '",tm.aag09,"' '",tm.aag38,"' '",tm.i,"'"
   #FUN-D40044--add--end--
   CALL cl_cmdrun(g_msg)
 
END FUNCTION

#FUN-D30014--mark--str-- 
#TQC-930163  --begin
#FUNCTION gglq704_1()
#  DEFINE l_name             LIKE type_file.chr20,
#         #l_sql              LIKE type_file.chr1000,
#         #l_sql1             LIKE type_file.chr1000,
#         l_sql,l_sql1       STRING,       #NO.FUN-910082
#         l_tao              LIKE type_file.chr1000,
#         l_abb              LIKE type_file.chr1000,
#         l_i                LIKE type_file.num5,
#         qc_tao05           LIKE tao_file.tao05,  #期初
#         qc_tao06           LIKE tao_file.tao06,
#         qc_tao10           LIKE tao_file.tao10,  #期初
#         qc_tao11           LIKE tao_file.tao11,
#         qj_tao05           LIKE tao_file.tao05,  #期間
#         qj_tao06           LIKE tao_file.tao06,
#         qj_tao10           LIKE tao_file.tao10,  #期間
#         qj_tao11           LIKE tao_file.tao11,
#         l_tao051           LIKE tao_file.tao05,
#         l_tao061           LIKE tao_file.tao06,
#         l_tao052           LIKE tao_file.tao05,
#         l_tao062           LIKE tao_file.tao06,
#         l_tao101           LIKE tao_file.tao10,
#         l_tao102           LIKE tao_file.tao10,
#         l_tao111           LIKE tao_file.tao11,
#         l_tao112           LIKE tao_file.tao11,
#         l_tao02            LIKE tao_file.tao02,
#         l_tao09            LIKE tao_file.tao09,
#         l_aag01_str        LIKE type_file.chr50,
#         l_aaa09            LIKE aaa_file.aaa09,   #CHI-C70031
#         l_aeh11            LIKE aeh_file.aeh11,   #CHI-C70031
#         l_aeh12            LIKE aeh_file.aeh12,   #CHI-C70031
#         l_aeh15            LIKE aeh_file.aeh15,   #CHI-C70031
#         l_aeh16            LIKE aeh_file.aeh16,   #CHI-C70031
#         sr3                RECORD
#                            aag01    LIKE aag_file.aag01,
#                            aag02    LIKE aag_file.aag02
#                            END RECORD,
#         sr4                RECORD
#                            tao01    LIKE tao_file.tao01,
#                            aag02    LIKE aag_file.aag02,
#                            tao04    LIKE tao_file.tao04,
#                            tao02    LIKE tao_file.tao02,
#                            gem02    LIKE gem_file.gem02,
#                            tao05    LIKE tao_file.tao05,
#                            tao06    LIKE tao_file.tao06,
#                            qcye     LIKE tao_file.tao05,
#                            tao09    LIKE tao_file.tao09,
#                            tao10    LIKE tao_file.tao10,
#                            tao11    LIKE tao_file.tao11,
#                            qcyef    LIKE tao_file.tao10 
#                            END RECORD
#  DEFINE l_wc2              STRING   #No.FUN-9A0084
#
#    CALL gglq704_table()
#    SELECT zo02 INTO g_company FROM zo_file
#     WHERE zo01 = g_rlang
#    #科目
#    LET tm.wc = cl_replace_str(tm.wc,'aao01','aag01')
#    IF tm.aag07 = '3' THEN   #TQC-CC0122  add 
#       LET l_sql = " SELECT aag01,aag02 FROM aag_file ",
#                   "  WHERE aag00 = '",tm.o,"'",
#                   "    AND ",tm.wc CLIPPED                                    
#    #TQC-CC0122--add--str--
#    ELSE
#       LET l_sql = " SELECT aag01,aag02 FROM aag_file ",
#                   "  WHERE aag00 = '",tm.o,"'",
#                   "    AND ",tm.wc CLIPPED,
#                   "    AND ((aag07 ='",tm.aag07,"' AND aag24 = '",tm.aag24,"') OR aag07 = '3')"
#    END IF 

#    IF tm.aag09 = 'Y' THEN  
#         LET l_sql = l_sql CLIPPED,
#                   "  AND aag09 = 'Y' "
#    END IF
#         
#    IF tm.aag38 = 'N' THEN  
#         LET l_sql = l_sql CLIPPED,  
#                   "  AND aag38 = 'N' "
#    END IF             

#    #TQC-CC0122--add--end--
#    PREPARE gglq704_pr11 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_aag01_cs1 CURSOR FOR gglq704_pr11
#
#    #部門
#    LET l_sql1 = "SELECT UNIQUE tao02,tao09 FROM tao_file ",
#                 " WHERE tao00 = '",tm.o,"'",
#                 "   AND tao01 = ?"            #科目
#    #No.FUN-9A0084  --Begin                                                    
#    LET l_wc2 = tm.wc1                                                         
#    LET l_wc2 = cl_replace_str(l_wc2,'aao02','tao02')                          
#    LET l_sql1 = l_sql1 CLIPPED," AND ",l_wc2                                  
#    #No.FUN-9A0084  --End
#    PREPARE gglq704_tao02_p1 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_tao02_p1',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_tao02_cs1 CURSOR FOR gglq704_tao02_p1
#    
#    #tm.b = 'Y'
#    #FUN-C80102--mark--str--
#    #FUN-C80102--add--str--
#    #IF tm.g = 'Y' THEN 
#    #   LET l_sql1 = " SELECT UNIQUE abb05,abb24 FROM aba_file,abb_file",        #TQC-970049 Add abb24
#    #                "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #                "    AND aba00 = '",tm.o,"'",
#    #                "    AND abb03 LIKE ? ",       #科目
#    #                "    AND abb05 IS NOT NULL"
#    #END IF 
#    #IF tm.g = 'N' THEN 
#    #   IF tm.b = '1' THEN 
#    #      LET l_sql1 = " SELECT UNIQUE abb05,abb24 FROM aba_file,abb_file",        #TQC-970049 Add abb24
#    #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #                   "    AND aba00 = '",tm.o,"'",
#    #                   "    AND abb03 LIKE ? ",       #科目
#    #                   "    AND abb05 IS NOT NULL",
#    #                   "    AND aba19 = 'Y'  "
#    #   ELSE 
#    #FUN-C80102--add--end--
#    #      LET l_sql1 = " SELECT UNIQUE abb05,abb24 FROM aba_file,abb_file",        #TQC-970049 Add abb24
#    #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #                   "    AND aba00 = '",tm.o,"'",
#    #                   "    AND abb03 LIKE ? ",       #科目
#    #                   "    AND abb05 IS NOT NULL",
#    #                   #"    AND aba19 = 'Y'   AND abapost = 'N'"   #FUN-C80102  mark
#    #                   "    AND aba19 = 'Y'   AND abapost = 'Y'"
#    #   END IF    #FUN-C80102  add
#    #END IF       #FUN-C80102  add
#    #FUN-C80102--mark--end--

#    #FUN-C80102--add--str--
#    LET l_sql1 = " SELECT UNIQUE abb05,abb24 FROM aba_file,abb_file",        
#                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#                 "    AND aba00 = '",tm.o,"'",
#                 "    AND abb03 LIKE ? ",       #科目
#                 "    AND abb05 IS NOT NULL"     

#    IF tm.g = 'Y' THEN
#       IF tm.b = '1' THEN 
#          LET l_sql1 = l_sql1 , "AND (aba19 = 'N' or aba19 ='Y')"
#       ELSE
#          LET l_sql1 = l_sql1," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))"
#       END IF 
#    END IF 
#    IF tm.g = 'N' THEN 
#       IF tm.b = '1' THEN
#          LET l_sql1 = l_sql1," AND  aba19 ='Y'"
#       ELSE          
#          LET l_sql1 = l_sql1," AND aba19 ='Y' AND abapost = 'Y'"
#       END IF
#    END IF 
#    #FUN-C80102--add--end--
#    
#    #No.FUN-9A0084  --Begin                                                    
#    LET l_wc2 = tm.wc1                                                         
#    LET l_wc2 = cl_replace_str(l_wc2,'aao02','abb05')                          
#    LET l_sql1 = l_sql1 CLIPPED," AND ",l_wc2                                  
#    #No.FUN-9A0084  --End
#
#    PREPARE gglq704_tao02_p2 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_tao02_p1',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_tao02_cs2 CURSOR FOR gglq704_tao02_p2
#    
#    #共用條件
#    LET l_tao = "SELECT SUM(tao05),SUM(tao06),SUM(tao10),SUM(tao11) FROM tao_file",
#                " WHERE tao00 = '",tm.o,"'",
#                "   AND tao01 = ? ",                   #科目
#                "   AND tao02 = ? ",                   #部門
#                "   AND tao09 = ? ",  #幣種   #TQC-930163 
#                "   AND tao03 = ",tm.yy

#    #FUN-C80102--add--str--
#    #FUN-C80102--add--str--
#    #IF tm.g = 'Y' THEN 
#    #   LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #               "    AND aba00 = '",tm.o,"'",
#    #               "    AND abb03 LIKE ?   ",             #科目
#    #               "    AND abb05 = ? ",                  #部門值
#    #               "    AND abb24 = ? ", 
#    #               "    AND aba03 = ",tm.yy
#    #END IF 
#    #IF tm.g = 'N' THEN 
#    #   IF tm.b = '1' THEN 
#    #       LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #            "    AND aba00 = '",tm.o,"'",
#    #            "    AND abb03 LIKE ?   ",             #科目
#    #            "    AND abb05 = ? ",                  #部門值
#    #            "    AND abb24 = ? ", 
#    #            "    AND aba03 = ",tm.yy,
#    #            "    AND aba19 = 'Y'   "  
#    #   ELSE 
#    #FUN-C80102--add--end--
#    #       LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#    #                   "    AND aba00 = '",tm.o,"'",
#    #                   "    AND abb03 LIKE ?   ",             #科目
#    #                   "    AND abb05 = ? ",                  #部門值
#    #                   "    AND abb24 = ? ", #TQC-930163 
#    #                   "    AND aba03 = ",tm.yy,
#    #                   #"    AND aba19 = 'Y'   AND abapost = 'N'"  #未過帳    #FUN-C80102  mark  
#    #                   "    AND aba19 = 'Y'   AND abapost = 'Y'"   #FUN-C80102  add
#    #   END IF    #FUN-C80102  add
#    # END IF      #FUN-C80102  add
#    #FUN-C80102--add--end--

#    #FUN-C80102--add--str--
#     LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#                   "    AND aba00 = '",tm.o,"'",
#                   "    AND abb03 LIKE ?   ",             #科目
#                   "    AND abb05 = ? ",                  #部門值
#                   "    AND abb24 = ? ", 
#                   "    AND aba03 = ",tm.yy
#     IF tm.g = 'Y' THEN 
#        IF tm.b = '1' THEN 
#           LET l_abb = l_abb , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
#        ELSE
#           LET l_abb = l_abb, "  AND aba19 = 'N'"
#        END IF 
#     END IF 
#     IF tm.g = 'N' THEN
#        IF tm.b = '1' THEN
#           LET l_abb = l_abb, " AND (aba19 ='Y' and abapost = 'N') "
#        ELSE
#           LET l_abb = l_abb, " AND  aba19 = 1 "
#        END IF
#     END IF 
#     #FUN-C80102--add--end--
#
#    #當期異動
#    LET l_sql1 = l_tao CLIPPED, "   AND tao04 = ? "  #當期
#    PREPARE gglq704_qj1_p1 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_qj_p1',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_qj1_cs1 CURSOR FOR gglq704_qj1_p1
#    
#    #tm.b = 'Y' #未過帳 - 借/貸
#    LET l_sql1 = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",l_abb CLIPPED,   #TQC-970310 Add SUM(abb07f)     
#                 "    AND aba04 = ?   ",              #當期未過帳資料
#                 "    AND abb06 = ?   ",
#                 "    AND aba19 <> 'X' "  #CHI-C80041
#    PREPARE gglq704_qj1_p2 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_qj1_p2',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_qj1_cs2 CURSOR FOR gglq704_qj1_p2
#
#    #期初余額
#    LET l_sql1 = l_tao CLIPPED, "   AND tao04 < ? "  #期初
#    PREPARE gglq704_qc1_p1 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_qc1_p1',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_qc1_cs1 CURSOR FOR gglq704_qc1_p1
#
#    #tm.b = 'Y' #未過帳 - 借/貸
#    LET l_sql1 = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",l_abb CLIPPED,
#                 "    AND aba04 < ?   ",              #當期未過帳資料
#                 "    AND abb06 = ?   ",
#                 "    AND aba19 <> 'X' "  #CHI-C80041
#    PREPARE gglq704_qc1_p2 FROM l_sql1
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('gglq704_qc1_p2',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE gglq704_qc1_cs2 CURSOR FOR gglq704_qc1_p2
#
#    DECLARE gglq704_tao02_cs CURSOR FOR
#            SELECT * FROM gglq704_aao02
#             ORDER BY aao02
#
#    LET g_pageno  = 0
#    LET g_prog = 'gglr300'
#
#    CALL cl_outnam('gglr300') RETURNING l_name
#    START REPORT gglq704_rep TO l_name
#
#    FOREACH gglq704_aag01_cs1 INTO sr3.*  #科目
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('gglq704_aag01_cs1 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#      END IF
#
#      #此作業也要打印統治科目的金額，但是tao/abb中都存放得是明細或是獨立科目
#      #所以要用LIKE的方式，取出統治科目對應的明細科目的金額
#      #此作業的前提，明細科目的前幾碼一定和其上屬統治相同 ruled by 蔡曉峰
#      IF cl_null(sr3.aag01) THEN CONTINUE FOREACH END IF
#      LET l_aag01_str = sr3.aag01 CLIPPED,'\%'    #No.MOD-940388
#
#      FOREACH gglq704_tao02_cs1 USING sr3.aag01
#                                INTO l_tao02,l_tao09
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('gglq704_tao02_cs1 foreach:',SQLCA.sqlcode,0)
#           EXIT FOREACH
#        END IF
#        IF cl_null(l_tao02) THEN CONTINUE FOREACH END IF
#        INSERT INTO gglq704_aao02 VALUES(l_tao02,l_tao09)
#      END FOREACH
#      #IF tm.b = 'Y' THEN   #FUN-C80102 mark
#         FOREACH gglq704_tao02_cs2 USING l_aag01_str
#                                   INTO l_tao02,l_tao09
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('gglq704_tao02_cs2 foreach:',SQLCA.sqlcode,0)
#              EXIT FOREACH
#           END IF
#           IF cl_null(l_tao02) THEN CONTINUE FOREACH END IF
#           INSERT INTO gglq704_aao02 VALUES(l_tao02,l_tao09)
#         END FOREACH
#      #END IF   #FUN-C80102 mark
#    
#      FOREACH gglq704_tao02_cs INTO l_tao02,l_tao09
#          IF SQLCA.sqlcode THEN
#             CALL cl_err('gglq704_tao02_cs2 foreach:',SQLCA.sqlcode,0)
#             EXIT FOREACH
#          END IF
#          FOR l_i = tm.m1 TO tm.m2
#              #期初
#              LET l_tao051 = 0  LET l_tao061 = 0
#              LET l_tao052 = 0  LET l_tao062 = 0
#              LET l_tao101 = 0  LET l_tao111 = 0
#              LET l_tao102 = 0  LET l_tao112 = 0
#
#              OPEN gglq704_qc1_cs1 USING sr3.aag01,l_tao02,l_tao09,l_i
#
#              OPEN gglq704_qc1_cs1 USING sr3.aag01,l_tao02,l_tao09,l_i
#              FETCH gglq704_qc1_cs1 INTO l_tao051,l_tao061,l_tao101,l_tao111
#              CLOSE gglq704_qc1_cs1
#              IF cl_null(l_tao051) THEN LET l_tao051 = 0 END IF
#              IF cl_null(l_tao061) THEN LET l_tao061 = 0 END IF
#              IF cl_null(l_tao101) THEN LET l_tao101 = 0 END IF
#              IF cl_null(l_tao111) THEN LET l_tao111 = 0 END IF
#
#              #IF tm.b = 'Y' THEN   #FUN-C80102 mark
#                 OPEN gglq704_qc1_cs2 USING l_aag01_str,l_tao02,l_tao09,l_i,'1'
#                 FETCH gglq704_qc1_cs2 INTO l_tao052,l_tao102
#                 CLOSE gglq704_qc1_cs2
#                 IF cl_null(l_tao052) THEN LET l_tao052 = 0 END IF
#                 IF cl_null(l_tao102) THEN LET l_tao102 = 0 END IF
#  
#                 OPEN gglq704_qc1_cs2 USING l_aag01_str,l_tao02,l_tao09,l_i,'2'
#                 FETCH gglq704_qc1_cs2 INTO l_tao062,l_tao112
#                 CLOSE gglq704_qc1_cs2
#                 IF cl_null(l_tao062) THEN LET l_tao062 = 0 END IF
#                 IF cl_null(l_tao112) THEN LET l_tao112 = 0 END IF
#              #END IF     #FUN-C80102 mark
#              #No.CHI-C70031  --Begin
#              LET l_aeh11 = 0       LET l_aeh12 = 0
#              LET l_aeh15 = 0       LET l_aeh16 = 0
#              SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
#              CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, l_tao02,l_tao02,NULL,
#              NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
#              l_i,       l_i,       l_tao09,      NULL,     NULL,    NULL,
#              NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
#              RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
#              #No.CHI-C70031  --End 
#              LET qc_tao05 = l_tao051 + l_tao052 - l_aeh11  #CHI-C70031 add l_aeh11
#              LET qc_tao06 = l_tao061 + l_tao062 - l_aeh12  #CHI-C70031 add l_aeh12
#              LET qc_tao10 = l_tao101 + l_tao102 - l_aeh15  #CHI-C70031 add l_aeh15
#              LET qc_tao11 = l_tao111 + l_tao112 - l_aeh16  #CHI-C70031 add l_aeh16 
#              
#              #期間
#              LET l_tao051 = 0  LET l_tao061 = 0
#              LET l_tao052 = 0  LET l_tao062 = 0
#              LET l_tao101 = 0  LET l_tao111 = 0
#              LET l_tao102 = 0  LET l_tao112 = 0
#
#              OPEN gglq704_qj1_cs1 USING sr3.aag01,l_tao02,l_tao09,l_i
#              FETCH gglq704_qj1_cs1 INTO l_tao051,l_tao061,l_tao101,l_tao111
#              CLOSE gglq704_qj1_cs1
#              IF cl_null(l_tao051) THEN LET l_tao051 = 0 END IF
#              IF cl_null(l_tao061) THEN LET l_tao061 = 0 END IF
#              IF cl_null(l_tao101) THEN LET l_tao101 = 0 END IF
#              IF cl_null(l_tao111) THEN LET l_tao111 = 0 END IF
#
#              #IF tm.b = 'Y' THEN   #FUN-C80102 mark
#                 OPEN gglq704_qj1_cs2 USING l_aag01_str,l_tao02,l_tao09,l_i,'1'
#                 FETCH gglq704_qj1_cs2 INTO l_tao052,l_tao102
#                 CLOSE gglq704_qj1_cs2
#                 IF cl_null(l_tao052) THEN LET l_tao052 = 0 END IF
#                 IF cl_null(l_tao102) THEN LET l_tao102 = 0 END IF
#
#                 OPEN gglq704_qj1_cs2 USING l_aag01_str,l_tao02,l_tao09,l_i,'2'
#                 FETCH gglq704_qj1_cs2 INTO l_tao062,l_tao112
#                 CLOSE gglq704_qj1_cs2
#                 IF cl_null(l_tao062) THEN LET l_tao062 = 0 END IF
#                 IF cl_null(l_tao112) THEN LET l_tao112 = 0 END IF
#              #END IF   #FUN-C80102 mark
#              #No.CHI-C70031  --Begin
#              LET l_aeh11 = 0       LET l_aeh12 = 0
#              LET l_aeh15 = 0       LET l_aeh16 = 0
#              SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
#              CALL s_minus_ce(tm.o, sr3.aag01, sr3.aag01, l_tao02,l_tao02,NULL,
#              NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
#              l_i,       l_i,       l_tao09,      NULL,     NULL,    NULL,
#              NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
#              RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
#              #No.CHI-C70031  --End
#              LET qj_tao05 = l_tao051 + l_tao052- l_aeh11  #CHI-C70031 add l_aeh11
#              LET qj_tao06 = l_tao061 + l_tao062- l_aeh12  #CHI-C70031 add l_aeh12
#              LET qj_tao10 = l_tao101 + l_tao102- l_aeh15  #CHI-C70031 add l_aeh15
#              LET qj_tao11 = l_tao111 + l_tao112- l_aeh16  #CHI-C70031 add l_aeh16
#              
#              #無期初也沒有本期異動，則不打印
#              IF qc_tao05 = 0 AND qc_tao06 = 0 AND
#                 qj_tao05 = 0 AND qj_tao06 = 0 THEN
#                 CONTINUE FOR
#              END IF
#
#              INITIALIZE sr4.* TO NULL
#              LET sr4.tao01  = sr3.aag01
#              LET sr4.aag02  = sr3.aag02
#              LET sr4.tao04  = l_i
#              LET sr4.tao02  = l_tao02
#              #取部門名稱
#              SELECT gem02 INTO sr4.gem02 FROM gem_file WHERE gem01 = l_tao02
#              LET sr4.tao09  = l_tao09
#              LET sr4.tao05 = qj_tao05
#              LET sr4.tao06 = qj_tao06
#              LET sr4.qcye  = qc_tao05 - qc_tao06
#              LET sr4.tao10 = qj_tao10
#              LET sr4.tao11 = qj_tao11
#              LET sr4.qcyef = qc_tao10 - qc_tao11
#              OUTPUT TO REPORT gglq704_rep(sr4.*)
#          END FOR
#      END FOREACH
#    END FOREACH
#    FINISH REPORT gglq704_rep
#    CALL gglq704_tmp_sum()                       #No.FUN-A80034
#END FUNCTION
#FUN-D30014--mark--end--

#FUN-D30014---add---str--
FUNCTION gglq704v_1()
   DEFINE l_name             LIKE type_file.chr20,
          #l_sql              LIKE type_file.chr1000,
          #l_sql1             LIKE type_file.chr1000,
          l_sql,l_sql1       STRING,       #NO.FUN-910082
          l_tao              LIKE type_file.chr1000,
          l_abb              LIKE type_file.chr1000,
          l_i                LIKE type_file.num5,
          qc_tao05           LIKE tao_file.tao05,  #期初
          qc_tao06           LIKE tao_file.tao06,
          qc_tao10           LIKE tao_file.tao10,  #期初
          qc_tao11           LIKE tao_file.tao11,
          qj_tao05           LIKE tao_file.tao05,  #期間
          qj_tao06           LIKE tao_file.tao06,
          qj_tao10           LIKE tao_file.tao10,  #期間
          qj_tao11           LIKE tao_file.tao11,
          l_tao051           LIKE tao_file.tao05,
          l_tao061           LIKE tao_file.tao06,
          l_tao052           LIKE tao_file.tao05,
          l_tao062           LIKE tao_file.tao06,
          l_tao101           LIKE tao_file.tao10,
          l_tao102           LIKE tao_file.tao10,
          l_tao111           LIKE tao_file.tao11,
          l_tao112           LIKE tao_file.tao11,
          l_tao01            LIKE tao_file.tao01,  #FUN-D30014
          l_tao02            LIKE tao_file.tao02,
          l_tao09            LIKE tao_file.tao09,
          l_aag01_str        LIKE type_file.chr50,
          l_aaa09            LIKE aaa_file.aaa09,   #CHI-C70031
          l_aeh11            LIKE aeh_file.aeh11,   #CHI-C70031
          l_aeh12            LIKE aeh_file.aeh12,   #CHI-C70031
          l_aeh15            LIKE aeh_file.aeh15,   #CHI-C70031
          l_aeh16            LIKE aeh_file.aeh16,   #CHI-C70031
          l_aeh11_1          LIKE aeh_file.aeh11,   #FUN-D30014
          l_aeh12_1          LIKE aeh_file.aeh12,   #FUN-D30014
          l_aeh15_1          LIKE aeh_file.aeh15,   #FUN-D30014
          l_aeh16_1          LIKE aeh_file.aeh16,   #FUN-D30014
          l_bal              LIKE aao_file.aao05,   #FUN-D30014
          l_pb_bal           LIKE aao_file.aao05,   #FUN-D30014
          l_pb_dc            LIKE type_file.chr10,  #FUN-D30014
          l_dc               LIKE type_file.chr10,  #FUN-D30014
          l_balf             LIKE aao_file.aao05,   #FUN-D30014
          l_pb_balf          LIKE aao_file.aao05,   #FUN-D30014
          sr3                RECORD
                             aag01    LIKE aag_file.aag01,
                             aag02    LIKE aag_file.aag02
                             END RECORD,
          sr4                RECORD
                             tao01    LIKE tao_file.tao01,
                             aag02    LIKE aag_file.aag02,
                             tao04    LIKE tao_file.tao04,
                             tao02    LIKE tao_file.tao02,
                             gem02    LIKE gem_file.gem02,
                             tao05    LIKE tao_file.tao05,
                             tao06    LIKE tao_file.tao06,
                             qcye     LIKE tao_file.tao05,
                             tao09    LIKE tao_file.tao09,
                             tao10    LIKE tao_file.tao10,
                             tao11    LIKE tao_file.tao11,
                             qcyef    LIKE tao_file.tao10 
                             END RECORD
   DEFINE l_wc2              STRING   #No.FUN-9A0084
   DEFINE qj_sum_tao05       LIKE tao_file.tao05  #MOD-DB0058 add
   DEFINE qj_sum_tao06       LIKE tao_file.tao06  #MOD-DB0058 add
   DEFINE qj_sum_tao10       LIKE tao_file.tao10  #MOD-DB0058 add
   DEFINE qj_sum_tao11       LIKE tao_file.tao11  #MOD-DB0058 add
     CALL gglq704_table()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
     #科目
     LET tm.wc = cl_replace_str(tm.wc,'aao01','aag01')
     LET l_sql = " INSERT INTO gglq704_temp1 "
     IF tm.aag07 = '3' THEN   #FUN-C80102  add
        LET l_sql = l_sql," SELECT UNIQUE aag01,aag02,tao02,tao09 FROM aag_file ",
                  # "  LEFT OUTER JOIN tao_file ON tao00 = aag00 AND aag01 = tao01 ",
                    "  ,tao_file WHERE tao00 = aag00 AND tao02 <> ' ' AND tao02 IS NOT NULL ",
                    "    AND tao01 LIKE aag01||'%' ",  
                    "    AND aag00 = '",tm.o,"'",
                  # "  WHERE aag00 = '",tm.o,"'",
                    "    AND ",tm.wc CLIPPED                                    
     ELSE
        LET l_sql = l_sql," SELECT UNIQUE aag01,aag02,tao02,tao09 FROM aag_file ",
                  # "  LEFT OUTER JOIN tao_file ON tao00 = aag00 AND aag01 = tao01 ",
                    "  ,tao_file WHERE tao00 = aag00 AND tao02 <> ' ' AND tao02 IS NOT NULL ",
                    "    AND tao01 LIKE aag01||'%' ",
                    "    AND aag00 = '",tm.o,"'",
                  # "  WHERE aag00 = '",tm.o,"'",
                    "    AND ",tm.wc CLIPPED,
                    "    AND ((aag07 ='",tm.aag07,"' AND aag24 = '",tm.aag24,"') OR aag07 = '3')"   
     END IF 
     
     IF tm.aag09 = 'Y' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag09 = 'Y' "
     END IF

     IF tm.aag38 = 'N' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag38 = 'N' "
     END IF

     PREPARE gglq704_pre1 FROM l_sql
     EXECUTE gglq704_pre1

     LET tm.wc = cl_replace_str(tm.wc,'aao01','aag01')
     LET l_sql = "INSERT INTO gglq704_temp1"
     IF tm.aag07 = '3' THEN   #FUN-C80102  add
        LET l_sql = l_sql," SELECT UNIQUE aag01,aag02,abb05,abb24 FROM aag_file,aba_file,abb_file ",
                    "  WHERE aba00 = abb00 AND aba01 = abb01 AND aag00 = abb00",
                    "    AND abb03 LIKE aag01||'%' AND abb05 IS NOT NULL AND abb05 <> ' ' ",
                    "    AND aag00 = '",tm.o,"'",
                    "    AND ",tm.wc CLIPPED
     ELSE
        LET l_sql = l_sql," SELECT UNIQUE aag01,aag02,abb05,abb24 FROM aag_file,aba_file,abb_file ",
                    "  WHERE aba00 = abb00 AND aba01 = abb01 AND aag00 = abb00",
                    "    AND abb03 LIKE aag01||'%' AND abb05 IS NOT NULL AND abb05 <> ' ' ",
                    "    AND aag00 = '",tm.o,"'",
                    "    AND ",tm.wc CLIPPED,
                    "    AND ((aag07 ='",tm.aag07,"' AND aag24 = '",tm.aag24,"') OR aag07 = '3')"
     END IF

     IF tm.aag09 = 'Y' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag09 = 'Y' "
     END IF

     IF tm.aag38 = 'N' THEN
          LET l_sql = l_sql CLIPPED,
                    "  AND aag38 = 'N' "
     END IF

     IF tm.g = 'Y' THEN
        IF tm.b = '1' THEN  
           LET l_sql = l_sql ,"AND (aba19 = 'N' or aba19 ='Y')"
        ELSE             
           LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))"
        END IF           
     END IF  
     IF tm.g = 'N' THEN
        IF tm.b = '1' THEN 
           LET l_sql = l_sql," AND  aba19 ='Y'"
        ELSE             
           LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'"
        END IF           
     END IF              
     
     LET l_wc2 = tm.wc1
     LET l_wc2 = cl_replace_str(l_wc2,'aao02','abb05')
     LET l_sql = l_sql CLIPPED," AND ",l_wc2
     PREPARE gglq704_pre2 FROM l_sql
     EXECUTE gglq704_pre2

     DECLARE gglq704_tao02_cs3 CURSOR FOR 
             SELECT UNIQUE * FROM gglq704_temp1
 
     #共用條件
     LET l_tao = "SELECT SUM(tao05),SUM(tao06),SUM(tao10),SUM(tao11) FROM tao_file",
                 " WHERE tao00 = '",tm.o,"'",
                 "   AND tao01 = ? ",                   #科目
                 "   AND tao02 = ? ",                   #部門
                 "   AND tao09 = ? ",  #幣種   #TQC-930163
                 "   AND tao03 = ",tm.yy

      #lujh 1219--add--str--
      LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    "    AND aba00 = '",tm.o,"'",
                    "    AND abb03 LIKE ?   ",             #科目
                    "    AND abb05 = ? ",                  #部門值
                    "    AND abb24 = ? ",
                    "    AND aba03 = ",tm.yy
      IF tm.g = 'Y' THEN
         IF tm.b = '1' THEN
            LET l_abb = l_abb , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
         ELSE
            LET l_abb = l_abb, "  AND aba19 = 'N'"
         END IF
      END IF
      IF tm.g = 'N' THEN
         IF tm.b = '1' THEN
            LET l_abb = l_abb, " AND (aba19 ='Y' and abapost = 'N') "
         ELSE
            LET l_abb = l_abb, " AND  aba19 = 1 "
         END IF
      END IF
      #lujh 1219--add--end--

     #當期異動
     LET l_sql1 = l_tao CLIPPED, "   AND tao04 = ? "  #當期
     PREPARE gglq704_qj1_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq704_qj_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq704_qj1_cs1 CURSOR FOR gglq704_qj1_p1

     #tm.b = 'Y' #未過帳 - 借/貸
     LET l_sql1 = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",l_abb CLIPPED,   #TQC-970310 Add SUM(abb07f)
                  "    AND aba04 = ?   ",              #當期未過帳資料
                  "    AND abb06 = ?   "
     PREPARE gglq704_qj1_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq704_qj1_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq704_qj1_cs2 CURSOR FOR gglq704_qj1_p2

     #期初余額
     LET l_sql1 = l_tao CLIPPED, "   AND tao04 < ? "  #期初
     PREPARE gglq704_qc1_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq704_qc1_p1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq704_qc1_cs1 CURSOR FOR gglq704_qc1_p1

     #tm.b = 'Y' #未過帳 - 借/貸
     LET l_sql1 = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",l_abb CLIPPED,
                  "    AND aba04 < ?   ",              #當期未過帳資料
                  "    AND abb06 = ?   "
     PREPARE gglq704_qc1_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('gglq704_qc1_p2',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq704_qc1_cs2 CURSOR FOR gglq704_qc1_p2 
     
     FOREACH gglq704_tao02_cs3 INTO sr3.*,l_tao02,l_tao09
         IF SQLCA.sqlcode THEN
            CALL cl_err('gglq704_tao02_cs3 foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         IF cl_null(sr3.aag01) THEN CONTINUE FOREACH END IF       
         LET l_aag01_str = sr3.aag01 CLIPPED,'\%'  
        #FOR l_i = tm.m1 TO tm.m2     #MOD-DB0058 mark
             #期初
               LET l_tao051 = 0  LET l_tao061 = 0
               LET l_tao052 = 0  LET l_tao062 = 0
               LET l_tao101 = 0  LET l_tao111 = 0
               LET l_tao102 = 0  LET l_tao112 = 0

               OPEN gglq704_qc1_cs1 USING sr3.aag01,l_tao02,l_tao09,l_i

              #OPEN gglq704_qc1_cs1 USING sr3.aag01,l_tao02,l_tao09,l_i  #MOD-DB0058 mark
               OPEN gglq704_qc1_cs1 USING sr3.aag01,l_tao02,l_tao09,tm.m1  #MOD-DB0058
               FETCH gglq704_qc1_cs1 INTO l_tao051,l_tao061,l_tao101,l_tao111
               CLOSE gglq704_qc1_cs1
               IF cl_null(l_tao051) THEN LET l_tao051 = 0 END IF
               IF cl_null(l_tao061) THEN LET l_tao061 = 0 END IF
               IF cl_null(l_tao101) THEN LET l_tao101 = 0 END IF
               IF cl_null(l_tao111) THEN LET l_tao111 = 0 END IF

               #IF tm.b = 'Y' THEN   #FUN-C80102 mark
                 #OPEN gglq704_qc1_cs2 USING l_aag01_str,l_tao02,l_tao09,l_i,'1'    #MOD-DB0058 mark
                  OPEN gglq704_qc1_cs2 USING l_aag01_str,l_tao02,l_tao09,tm.m1,'1'  #MOD-DB0058
                  FETCH gglq704_qc1_cs2 INTO l_tao052,l_tao102
                  CLOSE gglq704_qc1_cs2
                  IF cl_null(l_tao052) THEN LET l_tao052 = 0 END IF
                  IF cl_null(l_tao102) THEN LET l_tao102 = 0 END IF

                 #OPEN gglq704_qc1_cs2 USING l_aag01_str,l_tao02,l_tao09,l_i,'2'    #MOD-DB0058 mark
                  OPEN gglq704_qc1_cs2 USING l_aag01_str,l_tao02,l_tao09,tm.m1,'2'  #MOD-DB0058 
                  FETCH gglq704_qc1_cs2 INTO l_tao062,l_tao112
                  CLOSE gglq704_qc1_cs2
                  IF cl_null(l_tao062) THEN LET l_tao062 = 0 END IF
                  IF cl_null(l_tao112) THEN LET l_tao112 = 0 END IF
               #END IF     #FUN-C80102 mark
               #No.CHI-C70031  --Begin
               LET l_aeh11 = 0       LET l_aeh12 = 0
               LET l_aeh15 = 0       LET l_aeh16 = 0
               SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
               CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, l_tao02,l_tao02,NULL,
               NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
              #l_i,       l_i,       l_tao09,      NULL,     NULL,    NULL,   #MOD-DB0058 mark
               tm.m1,    tm.m1,       l_tao09,      NULL,     NULL,    NULL,  #MOD-DB0058 
               NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
               RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
               #No.CHI-C70031  --End
               IF tm.i = 'N' THEN     #FUN-D40044  add
                  LET qc_tao05 = l_tao051 + l_tao052 - l_aeh11  #CHI-C70031 add l_aeh11
                  LET qc_tao06 = l_tao061 + l_tao062 - l_aeh12  #CHI-C70031 add l_aeh12
                  LET qc_tao10 = l_tao101 + l_tao102 - l_aeh15  #CHI-C70031 add l_aeh15
                  LET qc_tao11 = l_tao111 + l_tao112 - l_aeh16  #CHI-C70031 add l_aeh16
               #FUN-D40044--add--str--
               ELSE
                  LET qc_tao05 = l_tao051 + l_tao052 
                  LET qc_tao06 = l_tao061 + l_tao062 
                  LET qc_tao10 = l_tao101 + l_tao102 
                  LET qc_tao11 = l_tao111 + l_tao112 
               END IF 
               #FUN-D40044--add--end--
           LET qj_sum_tao05 = 0  #MOD-DB0058 add
           LET qj_sum_tao06 = 0  #MOD-DB0058 add
           LET qj_sum_tao10 = 0  #MOD-DB0058 add
           LET qj_sum_tao11 = 0  #MOD-DB0058 add
           FOR l_i = tm.m1 TO tm.m2     #MOD-DB0058       
               #期間
               LET l_tao051 = 0  LET l_tao061 = 0
               LET l_tao052 = 0  LET l_tao062 = 0
               LET l_tao101 = 0  LET l_tao111 = 0
               LET l_tao102 = 0  LET l_tao112 = 0

               OPEN gglq704_qj1_cs1 USING sr3.aag01,l_tao02,l_tao09,l_i
               FETCH gglq704_qj1_cs1 INTO l_tao051,l_tao061,l_tao101,l_tao111
               CLOSE gglq704_qj1_cs1
               IF cl_null(l_tao051) THEN LET l_tao051 = 0 END IF
               IF cl_null(l_tao061) THEN LET l_tao061 = 0 END IF
               IF cl_null(l_tao101) THEN LET l_tao101 = 0 END IF
               IF cl_null(l_tao111) THEN LET l_tao111 = 0 END IF

               #IF tm.b = 'Y' THEN   #FUN-C80102 mark
                  OPEN gglq704_qj1_cs2 USING l_aag01_str,l_tao02,l_tao09,l_i,'1'
                  FETCH gglq704_qj1_cs2 INTO l_tao052,l_tao102
                  CLOSE gglq704_qj1_cs2
                  IF cl_null(l_tao052) THEN LET l_tao052 = 0 END IF
                  IF cl_null(l_tao102) THEN LET l_tao102 = 0 END IF

                  OPEN gglq704_qj1_cs2 USING l_aag01_str,l_tao02,l_tao09,l_i,'2'
                  FETCH gglq704_qj1_cs2 INTO l_tao062,l_tao112
                  CLOSE gglq704_qj1_cs2
                  IF cl_null(l_tao062) THEN LET l_tao062 = 0 END IF
                  IF cl_null(l_tao112) THEN LET l_tao112 = 0 END IF
               #END IF   #FUN-C80102 mark
               #No.CHI-C70031  --Begin
               LET l_aeh11 = 0       LET l_aeh12 = 0
               LET l_aeh15 = 0       LET l_aeh16 = 0
               SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
               CALL s_minus_ce(tm.o, sr3.aag01, sr3.aag01, l_tao02,l_tao02,NULL,
               NULL,      NULL,      NULL,      NULL,     NULL,    tm.yy,
               l_i,       l_i,       l_tao09,      NULL,     NULL,    NULL,
               NULL,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'1')
               RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
               #No.CHI-C70031  --End
               IF tm. i ='N' THEN      #FUN-D40044  add
                  LET qj_tao05 = l_tao051 + l_tao052- l_aeh11  #CHI-C70031 add l_aeh11
                  LET qj_tao06 = l_tao061 + l_tao062- l_aeh12  #CHI-C70031 add l_aeh12
                  LET qj_tao10 = l_tao101 + l_tao102- l_aeh15  #CHI-C70031 add l_aeh15
                  LET qj_tao11 = l_tao111 + l_tao112- l_aeh16  #CHI-C70031 add l_aeh16
               #FUN-D40044--add--str--
               ELSE
                  LET qj_tao05 = l_tao051 + l_tao052
                  LET qj_tao06 = l_tao061 + l_tao062
                  LET qj_tao10 = l_tao101 + l_tao102
                  LET qj_tao11 = l_tao111 + l_tao112
               END IF 
               #FUN-D40044--add--end--
                  
               #無期初也沒有本期異動，則不打印
               IF qc_tao05 = 0 AND qc_tao06 = 0 AND
                  qj_tao05 = 0 AND qj_tao06 = 0 THEN
                  CONTINUE FOR
               END IF  
               LET qj_sum_tao05 = qj_sum_tao05 + qj_tao05  #MOD-DB0058 add
               LET qj_sum_tao06 = qj_sum_tao06 + qj_tao06  #MOD-DB0058 add  
               LET qj_sum_tao10 = qj_sum_tao10 + qj_tao10  #MOD-DB0058 add
               LET qj_sum_tao11 = qj_sum_tao11 + qj_tao11  #MOD-DB0058 add       
          END FOR    #MOD-DB0058
             INITIALIZE sr4.* TO NULL
             LET sr4.tao01  = sr3.aag01
             LET sr4.aag02  = sr3.aag02
             LET sr4.tao04  = l_i
             LET sr4.tao02  = l_tao02
             #取部門名稱
             SELECT gem02 INTO sr4.gem02 FROM gem_file WHERE gem01 = l_tao02
             LET sr4.tao09  = l_tao09
#             LET sr4.tao05 = qj_tao05  #MOD-DB0058 mark
#             LET sr4.tao06 = qj_tao06  #MOD-DB0058 mark
             LET sr4.tao05 = qj_sum_tao05  #MOD-DB0058 
             LET sr4.tao06 = qj_sum_tao06  #MOD-DB0058 
             LET sr4.qcye  = qc_tao05 - qc_tao06
#             LET sr4.tao10 = qj_tao10  #MOD-DB0058 mark
#             LET sr4.tao11 = qj_tao11  #MOD-DB0058 mark
             LET sr4.tao10 = qj_sum_tao10  #MOD-DB0058 
             LET sr4.tao11 = qj_sum_tao11  #MOD-DB0058 
             LET sr4.qcyef = qc_tao10 - qc_tao11
             IF cl_null(sr4.tao05) THEN LET sr4.tao05 = 0 END IF
             IF cl_null(sr4.tao06) THEN LET sr4.tao06 = 0 END IF
             IF cl_null(sr4.tao10) THEN LET sr4.tao10 = 0 END IF
             IF cl_null(sr4.tao11) THEN LET sr4.tao11 = 0 END IF
             LET l_bal = sr4.tao05 - sr4.tao06 + sr4.qcye
             LET l_balf = sr4.tao10 - sr4.tao11 + sr4.qcyef
            
             IF sr4.qcye < 0 THEN
                LET l_pb_bal = sr4.qcye * -1
                LET l_pb_balf = sr4.qcyef * -1
             ELSE
                LET l_pb_bal = sr4.qcye
                LET l_pb_balf = sr4.qcyef
             END IF
             IF l_bal < 0 THEN
                LET l_bal = l_bal * -1
                LET l_balf = l_balf * -1
             ELSE
                LET l_bal = l_bal
                LET l_balf = l_balf
             END IF

             IF sr4.qcye > 0 THEN
                CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
             ELSE
                IF sr4.qcye = 0 THEN
                   CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
                ELSE
                   CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
                END IF
             END IF

             IF (sr4.tao05 - sr4.tao06 + sr4.qcye) > 0 THEN
                CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
             ELSE
                IF (sr4.tao05 - sr4.tao06 + sr4.qcye)  = 0 THEN
                   CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
                ELSE
                   CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
                END IF
             END IF

             INSERT INTO gglq704_tmp
              VALUES(sr4.tao01,sr4.aag02,sr4.tao04,sr4.tao02,sr4.gem02,'2',
                     sr4.tao09,l_pb_dc,l_pb_balf,0,l_pb_bal,'',sr4.tao10,0,sr4.tao05,
                     sr4.tao11,0,sr4.tao06,l_dc,l_balf,0,l_bal)
        #END FOR    #MOD-DB0058 mark
     END FOREACH
     
     CALL gglq704_tmp_sum()                   
END FUNCTION
#FUN-D30014---add---end--
 
FUNCTION gglq704_t()
   #IF tm.c = 'Y' THEN    #FUN-C80102  mark
   IF tm.a = 'Y' THEN     #FUN-C80102  add
      CALL cl_set_comp_visible("tao09,pb_balf,abb25_pb,df,abb25_d,cf,abb25_c,balf,abb25_bal",TRUE)  #FUN-C80102  mark  #MOD-D90099 remark
     #CALL cl_set_comp_visible("pb_balf,abb25_pb,df,abb25_d,cf,abb25_c,balf,abb25_bal",TRUE)   #FUN-C80102  add  #MOD-D90099 mark
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
      CALL cl_getmsg("ggl-205",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("balf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-206",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   ELSE
      CALL cl_set_comp_visible("tao09,pb_balf,abb25_pb,df,abb25_d,cf,abb25_c,balf,abb25_bal",FALSE)   #FUN-C80102  mark  #MOD-D90099 remark
     #CALL cl_set_comp_visible("pb_balf,abb25_pb,df,abb25_d,cf,abb25_c,balf,abb25_bal",FALSE)   #FUN-C80102  add    #MOD-D90099 mark
      CALL cl_getmsg("ggl-213",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pb_bal",g_msg CLIPPED)
      CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-209",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   END IF
 
END FUNCTION
#TQC-930163  --end
#No.FUN-A80034 --begin
FUNCTION gglq704_tmp_sum()
DEFINE l_aao01    LIKE aao_file.aao01
DEFINE l_aao04    LIKE aao_file.aao04
DEFINE l_aag02    LIKE aag_file.aag02
DEFINE l_df       LIKE ted_file.ted05
DEFINE l_cf       LIKE ted_file.ted05
DEFINE l_d        LIKE ted_file.ted05
DEFINE l_c        LIKE ted_file.ted05
DEFINE l_tao09    LIKE tao_file.tao09
DEFINE l_sqlc     STRING
DEFINE l_sqld     STRING
DEFINE l_msg      LIKE type_file.chr1000
DEFINE l_i        LIKE type_file.num5

   #IF tm.c = 'N' THEN    #FUN-C80102  mark
   IF tm.a = 'N' THEN     #FUN-C80102  add
      LET g_sql = "SELECT aao01,aag02,aao04,'',SUM(df),SUM(cf),SUM(d),SUM(c) ",
                  "  FROM gglq704_tmp",
                  " GROUP BY aao01,aag02,aao04 ",
                  " ORDER BY aao01,aag02,aao04 "
   ELSE 
      #IF tm.d ='Y' THEN  #FUN-C80102  mark
      IF tm.e ='Y' THEN   #FUN-C80102  add
         LET g_sql = "SELECT aao01,aag02,aao04,tao09,SUM(df),SUM(cf),SUM(d),SUM(c) ",
                     "  FROM gglq704_tmp",
                     " GROUP BY aao01,aag02,aao04,tao09 ",
                     " ORDER BY aao01,aag02,aao04,tao09 "
      ELSE 
         LET g_sql = "SELECT aao01,aag02,aao04,'',0,0,SUM(d),SUM(c) ",
                     "  FROM gglq704_tmp",
                     " GROUP BY aao01,aag02,aao04 ",
                     " ORDER BY aao01,aag02,aao04 "
      END IF 
   END IF 
 
   PREPARE gglq704_sum_mp FROM g_sql
   DECLARE gglq704_sum_m  CURSOR FOR gglq704_sum_mp   
   CALL cl_getmsg('ggl-214',g_lang) RETURNING l_msg  
   FOREACH gglq704_sum_m INTO l_aao01,l_aag02,l_aao04,l_tao09,l_df,l_cf,l_d,l_c
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_c) THEN LET l_c =0 END IF 
      IF cl_null(l_cf) THEN LET l_cf =0 END IF
      IF cl_null(l_d) THEN LET l_d =0 END IF
      IF cl_null(l_df) THEN LET l_cf =0 END IF
      #IF tm.d ='N' THEN    #FUN-C80102  mark
      IF tm.e ='N' THEN     #FUN-C80102  add
         LET l_cf = NULL 
         LET l_df = NULL 
      END IF 
      INSERT INTO gglq704_tmp 
      VALUES(l_aao01,l_aag02,l_aao04,l_msg,'','3',l_tao09,
             '','','','','',l_df,'',l_d,l_cf,'',l_c,'','','','') 
               
   END FOREACH  

   FOR l_i = tm.m1 TO tm.m2      
       #IF tm.c = 'N' THEN    #FUN-C80102  mark
       IF tm.a = 'N' THEN     #FUN-C80102  add
          LET g_sql = "SELECT aao01,aag02,'','',SUM(df),SUM(cf),SUM(d),SUM(c) ",
                      "  FROM gglq704_tmp",
                      " WHERE aao04 <= '",l_i,"'",
                      "   AND type <> '3' ",
                      "   AND type <> '4' ",
                      " GROUP BY aao01,aag02 ",
                      " ORDER BY aao01,aag02 "
       ELSE 
       	  #IF tm.d ='Y' THEN    #FUN-C80102  mark
          IF tm.e ='Y' THEN     #FUN-C80102  add
             LET g_sql = "SELECT aao01,aag02,'',tao09,SUM(df),SUM(cf),SUM(d),SUM(c) ",
                         "  FROM gglq704_tmp",
                         " WHERE aao04 <= '",l_i,"'",
                         "   AND type <> '3' ",
                         "   AND type <> '4' ",
                         " GROUP BY aao01,aag02,tao09 ",
                         " ORDER BY aao01,aag02,tao09 "
          ELSE 
             LET g_sql = "SELECT aao01,aag02,'','',0,0,SUM(d),SUM(c) ",
                         "  FROM gglq704_tmp",
                         " WHERE aao04 <= '",l_i,"'",
                         "   AND type <> '3' ",
                         "   AND type <> '4' ",
                         " GROUP BY aao01,aag02 ",
                         " ORDER BY aao01,aag02 "
          END IF 
       END IF 
       PREPARE gglq704_sum_yp FROM g_sql
       DECLARE gglq704_sum_y  CURSOR FOR gglq704_sum_yp   
       CALL cl_getmsg('ggl-215',g_lang) RETURNING l_msg
       FOREACH gglq704_sum_y INTO l_aao01,l_aag02,l_aao04,l_tao09,l_df,l_cf,l_d,l_c
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(l_c) THEN LET l_c =0 END IF 
          IF cl_null(l_cf) THEN LET l_cf =0 END IF
          IF cl_null(l_d) THEN LET l_d =0 END IF
          IF cl_null(l_df) THEN LET l_cf =0 END IF
          LET l_aao04 = l_i
          #IF tm.d ='N' THEN     #FUN-C80102  mark
          IF tm.e ='N' THEN      #FUN-C80102  add
             LET l_cf = NULL 
             LET l_df = NULL 
          END IF 
          INSERT INTO gglq704_tmp 
          VALUES(l_aao01,l_aag02,l_aao04,l_msg,'','4',l_tao09,
                 '','','','','',l_df,'',l_d,l_cf,'',l_c,'','','','')     
	     END FOREACH  
	 END FOR 
END FUNCTION 
#No.FUN-A80034 --end
#FUN-CB0069
