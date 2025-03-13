# Prog. Version..: '5.30.07-13.05.20(00010)'     #
#
# Pattern name...: gglq705.4gl
# Descriptions...: 核算項明細帳
# Input parameter:
# Return code....:
# Date & Author..: 08/06/19 By Carrier  #No.FUN-850030
# Modify.........: No.FUN-850030 08/07/24 By dxfwo 新增程序從21區移植到31區
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-930163 09/04/07 By elva 新增按幣別分頁
# Modify.........: No.MOD-940388 09/04/30 By wujie 字串連接%前要加轉義符\
# Modify.........: No.FUN-8B0106 09/06/10 By Cockroach CR段修改
# Modify.........: No.TQC-970049 09/07/24 By xiaofeizhu 修改CR報表錯誤
# Modify.........: No.TQC-970310 09/07/28 By xiaofeizhu 調整期初數值不對的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40011 10/04/06 By lilingyu 科目編號 部門增加開窗查詢
# Modify.........: No:FUN-A40009 10/04/07 By wujie 查询界面点退出回到主画面，而不是关闭程序
#                                                  点击单据联查按钮后，光标保持在原来所在的行，而不是回到第一行
# Modify.........: No.FUN-A40020 10/04/09 By Carrier 独立科目层及设置为1 
# Modify.........: No.TQC-A50151 10/05/26 By Carrier 加一行LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
# Modify.........: No.MOD-B10170 11/01/26 By wujie    期初tao排除非明细和独立科目的金额
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:CHI-C70031 12/10/18 By fengmy 去除CE、CA憑證資料，否則月末結轉損益後，查詢不到損益類科目
# Modify.........: No:CHI-CB0006 12/11/16 By fengmy 增加"貨幣性科目"和"是否打印內部管理科目"
# Modify.........: No.FUN-C80102 12/10/15 By zhangweib 財務報表改善追單
# Modify.........: No.TQC-CC0122 12/12/27 By lujh  1、增加科目層級 2、查詢顯示資料時，aag09和aag38欄位的顯示值非Y/N狀態  3、起始日期和截止日期不在同一年度時報錯提示
# Modify.........: No.MOD-C70312 13/01/17 By Polly 餘額計算順序應呈現在單身上,不應再重新排序
# Modify.........: No.FUN-D10075 13/03/07 By wangrr 9主機追單到30主機,增加按科目分頁，按部門分頁 
# Modify.........: No:FUN-D40044 13/04/26 By lujh 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額
# Modify.........: No.TQC-DC0064 13/12/19 By wangrr 當'單據狀態'為'2:已過帳'時'含未審核憑證'不顯示

DATABASE ds
 
GLOBALS "../../config/top.global"  #No.FUN-850030
 
DEFINE tm                RECORD
                         wc1        STRING,
                         wc2        STRING,
                         wc3        STRING,   #FUN-C80102  add
                         b          LIKE type_file.chr2,
                         #c          LIKE type_file.chr2,   #FUN-C80102  mark
                         a          LIKE type_file.chr2,    #FUN-C80102  add
                         aag24      LIKE aag_file.aag24,    #TQC-CC0122 add
                         g          LIKE type_file.chr2,    #FUN-C80102  add
                         #d          LIKE type_file.chr1, #TQC-930163   #FUN-C80102  mark
                         e          LIKE type_file.chr2,    #FUN-C80102  add  
                         aag09      LIKE aag_file.aag09,  #CHI-CB0006
                         aag38      LIKE aag_file.aag38,  #CHI-CB0006
                         f       LIKE type_file.chr1,       #FUN-D10075  add
                         i       LIKE type_file.chr1,       #FUN-D10075  add
                         h       LIKE type_file.chr1,       #FUN-D40044  add
                         more       LIKE type_file.chr1
                         END RECORD,
       yy,mm             LIKE type_file.num10,
       mm1,nn1           LIKE type_file.num10,
       bdate,edate       LIKE type_file.dat,
       l_flag            LIKE type_file.chr1,
       bookno            LIKE aaa_file.aaa01,
       g_cnnt            LIKE type_file.num5
 
DEFINE g_aaa03           LIKE aaa_file.aaa03
DEFINE g_cnt             LIKE type_file.num10
DEFINE g_i               LIKE type_file.num5
DEFINE l_table           STRING
DEFINE g_str             STRING
DEFINE g_sql             STRING
DEFINE g_rec_b           LIKE type_file.num10
DEFINE g_aag01           LIKE tao_file.tao01
DEFINE g_aag02           LIKE aag_file.aag02
DEFINE g_tao02           LIKE tao_file.tao02
DEFINE g_gem02           LIKE gem_file.gem02
DEFINE g_tao09           LIKE tao_file.tao09  #TQC-930163 
DEFINE g_abb24           LIKE abb_file.abb24  #FUN-C80102  add
DEFINE g_aba04           LIKE aba_file.aba04
#darcy:2025/02/14 add s---
DEFINE g_abb_excel      DYNAMIC ARRAY OF RECORD
                         aag01      LIKE aag_file.aag01,    #FUN-C80102  add
                         aag02      LIKE aag_file.aag02,    #FUN-C80102  add
                         tao02      LIKE aao_file.aao02,    #FUN-C80102  add
                         gem02      LIKE gem_file.gem02,    #FUN-C80102  add
                         aba02      LIKE aba_file.aba02,
                         aba01      LIKE aba_file.aba01,
                         abb04      LIKE abb_file.abb04,
                         #abb24      LIKE abb_file.abb24,
                         abb24      LIKE abb_file.abb01,
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
#darcy:2025/02/14 add e---
DEFINE g_abb             DYNAMIC ARRAY OF RECORD
                         aag01      LIKE aag_file.aag01,    #FUN-C80102  add
                         aag02      LIKE aag_file.aag02,    #FUN-C80102  add
                         tao02      LIKE aao_file.aao02,    #FUN-C80102  add
                         gem02      LIKE gem_file.gem02,    #FUN-C80102  add
                         aba02      LIKE aba_file.aba02,
                         aba01      LIKE aba_file.aba01,
                         abb04      LIKE abb_file.abb04,
                         #abb24      LIKE abb_file.abb24,
                         abb24      LIKE abb_file.abb01,
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
DEFINE g_pr              RECORD
                         aag01      LIKE aag_file.aag01,
                         aag02      LIKE type_file.chr1000,
                         tao02      LIKE tao_file.tao02,
                         gem02      LIKE gem_file.gem02,
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
DEFINE g_msg             LIKE type_file.chr1000
DEFINE g_row_count       LIKE type_file.num10
DEFINE g_curs_index      LIKE type_file.num10
DEFINE g_jump            LIKE type_file.num10
DEFINE mi_no_ask         LIKE type_file.num5
DEFINE l_ac              LIKE type_file.num5
 
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
   LET tm.b       = ARG_VAL(12)
   #LET tm.c       = ARG_VAL(13)   #FUN-C80102  mark
   LET tm.a       = ARG_VAL(13)    #FUN-C80102  add
   #TQC-930163 --begin
   #LET tm.d       = ARG_VAL(14)   #FUN-C80102  mark
   LET tm.e       = ARG_VAL(14)    #FUN-C80102  add
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)
   #TQC-930163 --end
   LET tm.g       = ARG_VAL(19)    #FUN-C80102  add
   LET tm.wc3     = ARG_VAL(20)    #FUN-C80102  add
   LET tm.aag24   = ARG_VAL(21)    #TQC-CC0122  add
   LET tm.f       = ARG_VAL(22)    #FUN-D10075  add
   LET tm.i       = ARG_VAL(23)    #FUN-D10075  add
   LET tm.aag09   = ARG_VAL(24)    #FUN-D10075  add
   LET tm.aag38   = ARG_VAL(25)    #FUN-D10075  add
   LET tm.h       = ARG_VAL(26)    #FUN-D40044  add

   CALL q705_out_1()
   #FUN-C80102--add--str--
   #IF bookno IS NULL OR bookno = ' ' THEN
   #   LET bookno = g_aza.aza81
   #END IF
   #FUN-C80102--add--end--
 
   OPEN WINDOW q705_w AT 5,10
        WITH FORM "ggl/42f/gglq705_1" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL gglq705_tm()
      ELSE    
         #TQC-930163 --begin
         #IF tm.d = 'N' THEN    #FUN-C80102  mark
         IF tm.e = 'N' THEN     #FUN-C80102  add
            CALL gglq705()
         ELSE
            CALL gglq705_1()
         END IF
         #TQC-930163 --end
         CALL gglq705_t()
   END IF
 
   CALL q705_menu()
   DROP TABLE gglq705_tmp;
   CLOSE WINDOW q705_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q705_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q705_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq705_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q705_out_2()
            END IF
         WHEN "drill_down"
            IF cl_chk_act_auth() THEN
               CALL q705_drill_down()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               #darcy:2025/02/14 mod s---
               -- CALL cl_export_to_excel
               -- (ui.Interface.getRootNode(),base.TypeInfo.create(g_abb),'','')
               call cl_download_by_explorer(
                        cl_expexcel1( "s_abb",base.typeinfo.create(g_abb_excel))
                    )
               #darcy:2025/02/14 mod e---
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_aag01 IS NOT NULL THEN
                  LET g_doc.column1 = "tao01"
                  LET g_doc.value1 = g_aag01
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION gglq705_tm()
   DEFINE p_row,p_col     LIKE type_file.num5,
          l_i             LIKE type_file.num5,
          l_cmd           LIKE type_file.chr1000
   DEFINE lc_qbe_sn       LIKE gbm_file.gbm01    #FUN-B20010
   DEFINE li_chk_bookno   LIKE type_file.num5    #FUN-B20010

   #FUN-C80102--add--str--
   CLEAR FORM #清除畫面   
   CALL g_abb.clear()   
   DELETE FROM gglq705_tmp  
   LET g_row_count ='0'   
   IF bookno IS NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81
   END IF
   #FUN-C80102--add--end--
   CALL s_dsmark(bookno)

   #FUN-C80102--mark--str---
   #LET p_row = 4 LET p_col = 12
   #OPEN WINDOW gglq705_w1 AT p_row,p_col
   #     WITH FORM "ggl/42f/gglq705"
   #     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #CALL cl_ui_locale("gglq705")
   #FUN-C80102--mark--str---
 
   CALL s_shwact(0,0,bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   
   CALL q705_getday()   #FUN-C80102  add
   #LET bdate   = g_today   #FUN-C80102  mark
   #LET edate   = g_today   #FUN-C80102  mark
   LET tm.b    = 'N'
   #LET tm.c    = 'N'   #FUN-C80102  mark
   LET tm.a    = '1'   #FUN-C80102  add  
   LET tm.aag24 = '99'  #TQC-CC0122  add
   LET tm.g    = 'N'   #FUN-C80102  add    
   #LET tm.d    = 'N' #TQC-930163  #FUN-C80102  mark
   LET tm.e    = 'N'    #FUN-C80102  add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.aag09  = 'Y'                #No.CHI-CB0006
   LET tm.aag38  = 'N'                #No.CHI-CB0006
   LET tm.f  = 'N'              #FUN-D10075  add
   LET tm.i  = 'N'              #FUN-D10075  add
   LET tm.h ='N'                #FUN-D40044  add
   WHILE TRUE
     #No.FUN-B20010  --Begin
     #FUN-C80102--mark--str--- 
     #DIALOG ATTRIBUTE(unbuffered)    
     #INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS)
        
     #   BEFORE INPUT
     #       CALL cl_qbe_display_condition(lc_qbe_sn)
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
     #No.FUN-B20010  --End
     #FUN-C80102--mark--end--- 
     
     #CONSTRUCT BY NAME tm.wc1 ON aag01    #FUN-C80102  mark
#No.FUN-B20010  --Mark Begin
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(aag01)
#                 CALL cl_init_qry_var()
##                 LET g_qryparam.form = 'q_aag'     #FUN-A40011
#                  LET g_qryparam.form = 'q_aag13'   #FUN-A40011
#                 LET g_qryparam.state= 'c'
#                 LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"   #FUN-B20010 add                              
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
#No.FUN-B20010  --Mark End
     #END CONSTRUCT       #FUN-C80102  mark
#No.FUN-B20010  --Mark Begin
#     IF g_action_choice = "locale" THEN
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE
#     END IF
# 
#     IF INT_FLAG THEN
#No.FUN-B20010  --Mark End
#No.FUN-A40009 --begin
#       LET INT_FLAG = 0 CLOSE WINDOW gglq705_w1 EXIT PROGRAM
#    END IF
#     ELSE
#No.FUN-A40009 --end
 
     #CONSTRUCT BY NAME tm.wc2 ON tao02    #FUN-C80102 mark
#No.FUN-B20010  --Mark Begin
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(tao02)
#                 CALL cl_init_qry_var()
##                 LET g_qryparam.form = 'q_gem'       #FUN-A40011
#                  LET g_qryparam.form = 'q_gem6'      #FUN-A40011
#                 LET g_qryparam.state= 'c'
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO tao02
#                 NEXT FIELD tao02
#           END CASE
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
     #END CONSTRUCT       #FUN-C80102 mark
#No.FUN-B20010  --Mark Begin
#     IF g_action_choice = "locale" THEN
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE
#     END IF
#    # IF INT_FLAG THEN
#No.FUN-B20010  --Mark End
#No.FUN-A40009 --begin
#        LET INT_FLAG = 0 CLOSE WINDOW gglq705_w1 EXIT PROGRAM
#    END IF
    # ELSE
#No.FUN-A40009 --end
 
     #DISPLAY BY NAME tm.b,tm.c,tm.more
     #INPUT BY NAME bookno,bdate,edate,tm.c,tm.b,tm.d,tm.more WITHOUT DEFAULTS #TQC-930163 #FUN-B20010
#No.FUN-B20010  --Mark End
     #INPUT BY NAME bdate,edate,tm.c,tm.b,tm.d,tm.more ATTRIBUTE(WITHOUT DEFAULTS) #FUN-B20010 去掉bookno    #FUN-C80102 mark
     DIALOG ATTRIBUTE(unbuffered)    #FUN-C80102 add
     INPUT BY NAME bookno,bdate,edate,tm.a,tm.aag24,tm.g,tm.b,tm.e,tm.aag09,tm.aag38 
                   ,tm.f,tm.i,tm.h   #FUN-D10075 add f,i    #FUN-D40044 add tm.h
        ATTRIBUTE(WITHOUT DEFAULTS)   #FUN-C80102 add   #CHI-CB0006 add aag09,aag38 #TQC-CC0122 add tm.aag24
           
       
       #No.FUN-B20010 --Begin
       #AFTER FIELD bookno
       #   IF cl_null(bookno) THEN NEXT FIELD bookno END IF
       #   SELECT aaa02 FROM aaa_file WHERE aaa01=bookno AND aaaacti IN ('Y','y')
       #   IF STATUS THEN CALL cl_err('sel aaa:',STATUS,0) NEXT FIELD bookno END IF
       #No.FUN-B20010 --End

        #FUN-C80102--add--str--- 
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
              IF YEAR(bdate) <> YEAR(edate) THEN NEXT FIELD edate END IF   #TQC-CC0122  mark
             ##TQC-CC0122--add--str--
             #IF s_get_aznn(g_plant,bookno,bdate,1) <> s_get_aznn(g_plant,bookno,edate,1) THEN
             #   CALL cl_err('','gxr-001',0)
             #   NEXT FIELD bdate
             #END IF
             ##TQC-CC0122--add--end--
           END IF
           IF edate < bdate THEN
              CALL cl_err(' ','agl-031',0)
              NEXT FIELD edate
           END IF

        #TQC-DC0064--add--str--
        ON CHANGE a
           IF tm.a='2' THEN
              LET tm.g='N'
              CALL cl_set_comp_visible("g",FALSE)
           ELSE
              CALL cl_set_comp_visible("g",TRUE)
           END IF
        #TQC-DC0064--add--end

        #FUN-C80102--mark--str---
        #AFTER FIELD b
        #   IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF
        #FUN-C80102--mark--end---

        #FUN-C80102--mark--str---
        #AFTER FIELD c
        #   IF tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
        #FUN-C80102--mark--add---
        
        ON CHANGE b
           IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF  #FUN-C80102  add
           IF tm.b = 'N' THEN 
              #LET tm.d = 'N'      #FUN-C80102  mark
              #DISPLAY tm.d TO d   #FUN-C80102  mark
              LET tm.e = 'N'       #FUN-C80102  add
              DISPLAY tm.e TO e    #FUN-C80102  add
           END IF

        #FUN-C80102--add--str--
        ON CHANGE g
           IF tm.g NOT MATCHES "[YN]" THEN NEXT FIELD g END IF  
        #FUN-C80102--add--end--
           
        #TQC-CC0122--add--str--
        AFTER FIELD aag24
           IF tm.aag24 <=0 THEN
              CALL cl_err('','ggl-816',0)
              NEXT FIELD aag24
           END IF
        #TQC-CC0122--add--end--

        #FUN-C80102--mark--str---
        #ON CHANGE d
        #   IF tm.d = 'Y' THEN 
        #      LET tm.b = 'Y' 
        #      DISPLAY tm.b TO b
        #   END IF
        #FUN-C80102--mark--str---
        #FUN-C80102--add--str---
        ON CHANGE e
           IF tm.e = 'Y' THEN 
              LET tm.b = 'Y' 
              DISPLAY tm.e TO e
           END IF
        #FUN-C80102--add--end---
        #TQC-930163  --end
        
        #FUN-D10075--add--str--
        ON CHANGE f   
           IF tm.f NOT MATCHES "[YyNn]"  THEN   
              NEXT FIELD f                      
           END IF
        ON CHANGE i   
           IF tm.i NOT MATCHES "[YyNn]"  THEN   
              NEXT FIELD i                      
           END IF
        #FUN-D10075--add--end--   

        #FUN-D40044--add--str---
        ON CHANGE h
           IF tm.h NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD h
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
        #FUN-C80102--mark--str---
#No.FUN-B20010  --Mark Begin 
#        ON ACTION CONTROLZ
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG CALL cl_cmdask()
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(bookno)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_aaa'
#                LET g_qryparam.default1 =bookno
#                CALL cl_create_qry() RETURNING bookno
#                DISPLAY BY NAME bookno
#                NEXT FIELD bookno
#          END CASE
#  
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
#No.FUN-B20010  --Mark End
     #END INPUT   #FUN-C80102 mark
     ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bookno)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_aaa'
                 LET g_qryparam.default1 =bookno
                 CALL cl_create_qry() RETURNING bookno
                 DISPLAY BY NAME bookno
                 NEXT FIELD bookno
              #FUN-C80102--mark--str---
              #WHEN INFIELD(aag01)
              #   CALL cl_init_qry_var()
              #    LET g_qryparam.form = 'q_aag13'
              #   LET g_qryparam.state= 'c'
              #   LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"   #FUN-B20010 add                              
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
              #   DISPLAY g_qryparam.multiret TO aag01
              #   NEXT FIELD aag01
              #WHEN INFIELD(tao02)
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form = 'q_gem6'
              #   LET g_qryparam.state= 'c'
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
              #   DISPLAY g_qryparam.multiret TO tao02
              #   NEXT FIELD tao02
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
        
    #No.FU-C80102 ---start--- Mark
    #ON ACTION accept
    #   EXIT DIALOG        
    #  
    #ON ACTION cancel
    #   LET INT_FLAG=1 
    #   EXIT DIALOG       
    #No.FU-C80102 ---start--- Mark

   #END DIALOG              #FUN-C80102 mark
   END INPUT                #FUN-C80102 add
   #FUN-C80102--add--str--
   CONSTRUCT tm.wc1 ON aag01
                  FROM s_abb[1].aag01
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
        CASE 
          WHEN INFIELD(aag01)
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aag13'
                 LET g_qryparam.state= 'c'
                 LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"   
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aag01
                 NEXT FIELD aag01
        END CASE

    END CONSTRUCT
    CONSTRUCT tm.wc2 ON tao02
                   FROM s_abb[1].tao02
    BEFORE CONSTRUCT
      CALL cl_qbe_init()


      ON ACTION CONTROLP
       CASE 
          WHEN INFIELD(tao02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_gem7'
                 LET g_qryparam.state= 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tao02
                 NEXT FIELD tao02
       END CASE

    END CONSTRUCT

    CONSTRUCT tm.wc3 ON aba02,aba01,abb24
                  FROM s_abb[1].aba02,s_abb[1].aba01,s_abb[1].abb24
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
        CASE 
          WHEN INFIELD(aba01)
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aba02'
                 LET g_qryparam.state= 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aba01
                 NEXT FIELD aba01
          WHEN INFIELD(abb24)
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azi'
                 LET g_qryparam.state= 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO abb24
                 NEXT FIELD abb24
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
#No.FUN-A40009 --begin
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0 CLOSE WINDOW gglq705_w1 EXIT PROGRAM
#    END IF
#No.FUN-A40009 --end
     LET mm1 = MONTH(bdate)
     LET nn1 = MONTH(edate)
 
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file
         WHERE zz01='gglq705'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglq705','9031',1)
        ELSE
           LET tm.wc1=cl_wcsub(tm.wc1)
           LET l_cmd = l_cmd CLIPPED,
                      " '",bookno     CLIPPED,"'",
                      " '",g_pdate    CLIPPED,"'",
                      " '",g_towhom   CLIPPED,"'",
                      " '",g_rlang    CLIPPED,"'",
                      " '",g_bgjob    CLIPPED,"'",
                      " '",g_prtway   CLIPPED,"'",
                      " '",g_copies   CLIPPED,"'",
                      " '",tm.wc1     CLIPPED,"'",
                      " '",tm.wc2     CLIPPED,"'",
                      " '",bdate      CLIPPED,"'",
                      " '",edate      CLIPPED,"'",
                      " '",tm.b       CLIPPED,"'",
                      " '",tm.g       CLIPPED,"'",    #FUN-C80102  add
                      #" '",tm.c       CLIPPED,"'",   #FUN-C80102  mark
                      " '",tm.a       CLIPPED,"'",    #FUN-C80102  add
                      #" '",tm.d       CLIPPED,"'", #TQC-930163   #FUN-C80102  mark
                      " '",tm.e       CLIPPED,"'",    #FUN-C80102  add
                      " '",g_rep_user CLIPPED,"'",
                      " '",g_rep_clas CLIPPED,"'",
                      " '",g_template CLIPPED,"'",
                      " '",g_rpt_name CLIPPED,"'"
           CALL cl_cmdat('gglq705',g_time,l_cmd)
        END IF
        CLOSE WINDOW gglq705_w1   
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
#     END IF           #No.FUN-A40009  #FUN-B20010 mark
#     END IF           #No.FUN-A40009  #FUN-B20010 mark
     CALL cl_wait()

     #TQC-930163 --begin
     #IF tm.d = 'N' THEN    #FUN-C80102  mark
     IF tm.e = 'N' THEN     #FUN-C80102  add
        CALL gglq705()
     ELSE
        CALL gglq705_1()
     END IF
     #TQC-930163 --begin
     ERROR ""
     EXIT WHILE
   END WHILE
   #CLOSE WINDOW gglq705_w1   #FUN-C80102  mark
#No.FUN-A40009 --begin   
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF           
#No.FUN-A40009 --end 
 
   CALL gglq705_t()
 
END FUNCTION
 
#TQC-930163 --begin
FUNCTION gglq705_curs1()
  DEFINE #l_sql   LIKE type_file.chr1000
         l_sql   STRING      #NO.FUN-910082
  DEFINE #l_sql1  LIKE type_file.chr1000
         l_sql1   STRING      #NO.FUN-910082
  DEFINE 
          #l_wc2   LIKE type_file.chr1000
          l_wc2         STRING       #NO.FUN-910082
 
     LET mm1 = MONTH(bdate)
     LET nn1 = MONTH(edate)
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
     #查找科目
     IF cl_null(tm.aag24) THEN   #TQC-CC0122 add
        LET l_sql1= "SELECT aag01,aag02 FROM aag_file ",
                    " WHERE aag03 ='2' ",
                    "   AND aag00 = '",bookno,"' ",
#                   "   AND aag24 <> 1 ",           #一級統治不要出來,BY蔡曉峰規定 #No.FUN-A40020
                    "   AND NOT (aag24 = 1 AND aag07 = '1') ", #No.FUN-A40020
                    "   AND ",tm.wc1 CLIPPED
     #TQC-CC0122--add--str--
     ELSE
        LET l_sql1= "SELECT aag01,aag02 FROM aag_file ",
                    " WHERE aag03 ='2' ",
                    "   AND aag00 = '",bookno,"' ",
#                   "   AND aag24 <> 1 ",           #一級統治不要出來,BY蔡曉峰規定 #No.FUN-A40020
                    "   AND NOT (aag24 = 1 AND aag07 = '1') ", #No.FUN-A40020
                    "   AND aag24 = '",tm.aag24,"'", 
                    "   AND ",tm.wc1 CLIPPED
     END IF
     #TQC-CC0122--add--end--     
     #No.CHI-CB0006  --Begin
     IF tm.aag09 = 'Y' THEN
          LET l_sql1 = l_sql1 CLIPPED,
                    "  AND aag09 = 'Y' "
     END IF
       
     IF tm.aag38 = 'N' THEN
          LET l_sql1 = l_sql1 CLIPPED,
                    "  AND aag38 = 'N' "
     END IF
     #No.CHI-CB0006  --End
     PREPARE gglq705_aag01_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglq705_aag01_cs1 CURSOR FOR gglq705_aag01_p1
 
     #查找核算項
     LET l_sql1 = "SELECT UNIQUE tao02,tao09 FROM tao_file ",
                  " WHERE tao00 = '",bookno,"'",
        #         "   AND tao01 = ?",           #account #
                  "   AND tao01 LIKE ?",           #account
                  "   AND tao02 IS NOT NULL ",
                  "   AND ",tm.wc2 CLIPPED
     PREPARE gglq705_tao02_p11 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_tao02_cs11 CURSOR FOR gglq705_tao02_p11
 
     LET l_wc2 = tm.wc2
     LET l_wc2 = cl_replace_str(l_wc2,"tao02","abb05")
     LET l_wc2 = cl_replace_str(l_wc2,"tao09","abb24") #TQC-930163 

     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.g = 'Y' THEN 
     #   LET l_sql1 = " SELECT UNIQUE abb05,abb24 FROM aba_file,abb_file",
     #                "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                "    AND aba00 = '",bookno,"'",
     #                "    AND abb03 LIKE ? ",       #account
     #                "    AND abb05 IS NOT NULL",
     #                "    AND ",l_wc2
     #END IF 
     #IF tm.g = 'N' THEN 
     #   IF tm.a = '1' THEN 
     #      LET l_sql1 = " SELECT UNIQUE abb05,abb24 FROM aba_file,abb_file",
     #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                   "    AND aba00 = '",bookno,"'",
     #                   "    AND abb03 LIKE ? ",       #account
     #                   "    AND abb05 IS NOT NULL",
     #                   "    AND aba19 = 'Y' ",
     #                   "    AND ",l_wc2
     #   ELSE 
     #FUN-C80102--add--end--
     #      LET l_sql1 = " SELECT UNIQUE abb05,abb24 FROM aba_file,abb_file",
     #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                   "    AND aba00 = '",bookno,"'",
     #                   "    AND abb03 LIKE ? ",       #account
     #                   "    AND abb05 IS NOT NULL",
     #                   #"    AND aba19 = 'Y'   AND abapost = 'N'",     #FUN-C80102  mark
     #                   "    AND aba19 = 'Y'   AND abapost = 'Y'",      #FUN-C80102  add
     #                   "    AND ",l_wc2
     #   END IF   #FUN-C80102  add
     #END IF      #FUN-C80102  add
     #FUN-C80102--mark--end-- 

     #FUN-C80102--add--str--
     LET l_sql1 = " SELECT UNIQUE abb05,abb24 FROM aba_file,abb_file",
                     "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                     "    AND aba00 = '",bookno,"'",
                     "    AND abb03 LIKE ? ",       #account
                     "    AND abb05 IS NOT NULL",
                     "    AND ",l_wc2
     IF tm.g = 'Y' THEN 
        IF tm.a = '1' THEN 
           LET l_sql1 = l_sql1 , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql1 = l_sql1, "  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.g = 'N' THEN
        IF tm.a = '1' THEN
           LET l_sql1 = l_sql1, " AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql1 =  " AND  aba19 = 1 "
        END IF
     END IF 
     #FUN-C80102--add--end--
     
     PREPARE gglq705_tao02_p21 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_tao02_cs21 CURSOR FOR gglq705_tao02_p21
 
     #期初余額
     #1~mm-1
     LET l_sql = "SELECT SUM(tao05),SUM(tao06),SUM(tao10),SUM(tao11) FROM tao_file,aag_file ",   #No.MOD-B10170
                 " WHERE tao00 = '",bookno,"'",
                #"   AND tao01 = ? ",                  #科目
                 "   AND tao01 LIKE ? ",                  #科目
                 "   AND tao02 = ? ",                  #部門
                 "   AND tao09 = ? ",                  #幣別
#No.MOD-B10170 --begin  
                 "   AND tao01 = aag01 ",  
                 "   AND aag00 = '",bookno,"'",      
                 "   AND aag07 <> '1' ",    
#No.MOD-B10170 --end 
                 "   AND tao03 = ",yy,
                 "   AND tao04 < ",mm                  #期初
     PREPARE gglq705_qc1_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qc1_cs1 CURSOR FOR gglq705_qc1_p1
     #mm(1~bdate-1)
     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.g = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND abb05 = ? ",                    #部門
     #               "    AND abb24 = ? ",                    #幣別
     #               "    AND abb06 = ? ",
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 = ",mm,
     #               "    AND aba02 < '",bdate,"'"
     #END IF 
     #IF tm.g = 'N' THEN 
     #   IF tm.a = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #部門
     #                  "    AND abb24 = ? ",                    #幣別
     #                  "    AND abb06 = ? ",
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND aba02 < '",bdate,"'",
     #                  "    AND aba19 = 'Y' "  
     #   ELSE 
     #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #部門
     #                  "    AND abb24 = ? ",                    #幣別
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
                    "    AND abb05 = ? ",                    #部門
                    "    AND abb24 = ? ",                    #幣別
                    "    AND abb06 = ? ",
                    "    AND aba03 = ",yy,
                    "    AND aba04 = ",mm,
                    "    AND aba02 < '",bdate,"'"
     IF tm.g = 'Y' THEN 
        IF tm.a = '1' THEN 
           LET l_sql = l_sql , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql, "  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.g = 'N' THEN
        IF tm.a = '1' THEN
           LET l_sql = l_sql, " AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql =  " AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq705_qc2_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qc2_cs1 CURSOR FOR gglq705_qc2_p1
 
     #tm.c = 'Y'
     #1~mm-1
     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.g = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND abb05 = ? ",                    #部門
     #               "    AND abb24 = ? ",                    #幣別
     #               "    AND abb06 = ? ",
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 < ",mm
     #END IF 
     #IF tm.g = 'N' THEN 
     #   IF tm.a = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #部門
     #                  "    AND abb24 = ? ",                    #幣別
     #                  "    AND abb06 = ? ",
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 < ",mm,
     #                  "    AND aba19 = 'Y' "  #期初未過帳
     #   ELSE 
     #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #部門
     #                  "    AND abb24 = ? ",                    #幣別
     #                  "    AND abb06 = ? ",
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 < ",mm,
     #                  #"    AND aba19 = 'Y' AND abapost = 'N'"  #期初未過帳   #FUN-C80102  mark
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'"               #FUN-C80102  add
     #   END IF     #FUN-C80102  add
     #END IF        #FUN-C80102  add
     #FUN-C80102--add--end--

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND abb05 = ? ",                    #部門
                 "    AND abb24 = ? ",                    #幣別
                 "    AND abb06 = ? ",
                 "    AND aba03 = ",yy,
                 "    AND aba04 < ",mm
     IF tm.g = 'Y' THEN 
        IF tm.a = '1' THEN 
           LET l_sql = l_sql , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql, "  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.g = 'N' THEN
        IF tm.a = '1' THEN
           LET l_sql = l_sql, " AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql =  " AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq705_qc3_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qc3_cs1 CURSOR FOR gglq705_qc3_p1
     #mm(1~bdate-1)
     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.g = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND abb05 = ? ",                    #部門
     #               "    AND abb24 = ? ",                    #幣別
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 = ",mm,
     #               "    AND abb06 = ? ",
     #               "    AND aba02 < '",bdate,"'"
     #END IF 
     #IF tm.g = 'Y' THEN 
     #   IF tm.a = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #部門
     #                  "    AND abb24 = ? ",                    #幣別
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND abb06 = ? ",
     #                  "    AND aba02 < '",bdate,"'",
     #                  "    AND aba19 = 'Y' "  #期初未過帳
     #   ELSE 
    #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #部門
     #                  "    AND abb24 = ? ",                    #幣別
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND abb06 = ? ",
     #                  "    AND aba02 < '",bdate,"'",
     #                  #"    AND aba19 = 'Y' AND abapost = 'N'"  #期初未過帳  #FUN-C80102 mark
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'"              #FUN-C80102 add
     #   END IF     #FUN-C80102 add
     #END IF        #FUN-C80102 add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND abb05 = ? ",                    #部門
                 "    AND abb24 = ? ",                    #幣別
                 "    AND aba03 = ",yy,
                 "    AND aba04 = ",mm,
                 "    AND abb06 = ? ",
                 "    AND aba02 < '",bdate,"'"
     IF tm.g = 'Y' THEN 
        IF tm.a = '1' THEN 
           LET l_sql = l_sql , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql, "  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.g = 'N' THEN
        IF tm.a = '1' THEN
           LET l_sql = l_sql, " AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql =  " AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq705_qc4_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qc4_cs1 CURSOR FOR gglq705_qc4_p1
 
     #當期異動
     #IF tm.g = 'Y' THEN    #FUN-C80102  mark
        LET l_sql = " SELECT '','','','',0,aba02,aba01,abb04,",
                 "        abb06,abb07,abb07f,abb24,abb25, ",
                 "        0,0,0,0,0,0,0,0,0,0             ",
                 "   FROM aba_file a,abb_file ",                  #FUN-D40044 add a
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND abb05 = ? ",                    #部門
                 "    AND abb24 = ? ",                    #幣別
                 "    AND aba03 = ",yy,
                 "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
                 #"    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN ",         #CHI-C70031  #FUN-D40044 mark
                 #"        (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))", #CHI-C70031  #FUN-D40044 mark
                 "    AND aba04 = ? "

     #FUN-D40044--add--str--
     IF tm.h = 'N' THEN 
        LET l_sql = l_sql CLIPPED," AND NOT EXISTS (",
            " SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01 ",
            "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))"
     END IF
     #FUN-D40044--add--end--
                 #" ORDER BY aba02"    #FUN-C80102  mark
     #END IF    #FUN-C80102  mark
     #FUN-C80102--mark--str--
     #IF tm.g = 'N' THEN 
     #   LET l_sql = " SELECT '','','','',0,aba02,aba01,abb04,",
     #               "        abb06,abb07,abb07f,abb24,abb25, ",
     #               "        0,0,0,0,0,0,0,0,0,0             ",
     #               "   FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND abb05 = ? ",                    #部門
     #               "    AND abb24 = ? ",                    #幣別
     #               "    AND aba03 = ",yy,
     #               "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
     #               "    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN ",         #CHI-C70031
     #               "        (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))", #CHI-C70031
     #               "    AND aba04 = ? ",
     #               "    AND aba19 = 'Y' "    
          
     #   #IF tm.c = 'N' THEN   #FUN-C80102  mark
     #   IF tm.a = '2' THEN    #FUN-C80102  add
     #      LET l_sql = l_sql CLIPPED," AND abapost = 'Y' ORDER BY aba02"   #筁眀  #FUN-A40011 add order by
#FUN-A40011 --begin--
     #   ELSE
     #      LET l_sql = l_sql CLIPPED," ORDER BY aba02"  
#FUN-A40011 --end--           
     #   END IF
     #END IF  #FUN-C80102  add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     IF tm.g ='Y' THEN 
        IF tm.a = '1' THEN
           LET l_sql = l_sql," AND (aba19 = 'N' or aba19 ='Y')",
                        " ORDER BY aba02 " 
        ELSE
           LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))",
                        " ORDER BY aba02 " 
        END IF
     END IF
     IF tm.g ='N' THEN
        IF tm.a = '1' THEN
           LET l_sql = l_sql," AND  aba19 ='Y'", 
                        " ORDER BY aba02 " 
        ELSE
           LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'",
                        " ORDER BY aba02 " 
        END IF
     END IF
     #FUN-C80102--add--end--
 
     PREPARE gglq705_qj1_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qj1_cs1 CURSOR FOR gglq705_qj1_p1
 
END FUNCTION
 
FUNCTION gglq705_1()
   DEFINE l_name               LIKE type_file.chr20,
          #l_sql,l_sql1         LIKE type_file.chr1000,
          l_sql,l_sql1         STRING ,     #NO.FUN-910082
          l_date,l_date1       LIKE aba_file.aba02,
          l_i                  LIKE type_file.num5,
          qc_tao05             LIKE tao_file.tao05,
          qc_tao06             LIKE tao_file.tao06,
          qc_tao10             LIKE tao_file.tao10,
          qc_tao11             LIKE tao_file.tao11,
          qc1_tao05            LIKE tao_file.tao05,
          qc1_tao06            LIKE tao_file.tao06,
          qc1_tao10            LIKE tao_file.tao10,
          qc1_tao11            LIKE tao_file.tao11,
          qc2_tao05            LIKE tao_file.tao05,
          qc2_tao06            LIKE tao_file.tao06,
          qc2_tao10            LIKE tao_file.tao10,
          qc2_tao11            LIKE tao_file.tao11,
          qc3_tao05            LIKE tao_file.tao05,
          qc3_tao06            LIKE tao_file.tao06,
          qc3_tao10            LIKE tao_file.tao10,
          qc3_tao11            LIKE tao_file.tao11,
          qc4_tao05            LIKE tao_file.tao05,
          qc4_tao06            LIKE tao_file.tao06,
          qc4_tao10            LIKE tao_file.tao10,
          qc4_tao11            LIKE tao_file.tao11,
          l_qcye               LIKE abb_file.abb07,
          l_qcyef              LIKE abb_file.abb07,
          t_qcye               LIKE abb_file.abb07,
          t_qcyef              LIKE abb_file.abb07,
          l_tao02              LIKE tao_file.tao02,
          l_tao09              LIKE tao_file.tao09,
          l_gem02              LIKE gem_file.gem02,
          l_aag01_str          LIKE type_file.chr50,
#FUN-8B0106 ADD START
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
#FUN-8B0106 ADD END          
          sr1                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02
                               END RECORD,
          sr2                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               tao02    LIKE tao_file.tao02,
                               gem02    LIKE gem_file.gem02,
                               tao09    LIKE tao_file.tao09 #TQC-930163 
                               END RECORD,
          sr                   RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               tao02    LIKE tao_file.tao02,
                               gem02    LIKE gem_file.gem02,
                          #    tao09    LIKE tao_file.tao09, #TQC-930163 
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
DEFINE  l_chr                  LIKE type_file.chr1     #FUN-A40011 
 
     CALL gglq705_table()
     LET l_flag1 = 'N'                         #TQC-970049
     LET l_flag2 = 'N'                         #TQC-970049     
 
     CALL gglq705_curs1()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
     FOREACH gglq705_aag01_cs1 INTO sr1.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach gglq705_aag01_cs1',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr1.aag01 CLIPPED,'\%'    #No.MOD-940388
       #FOREACH gglq705_tao02_cs1 USING sr1.aag01
        FOREACH gglq705_tao02_cs11 USING l_aag01_str
                                   INTO l_tao02,l_tao09
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq705_tao02_cs11',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(l_tao02) THEN CONTINUE FOREACH END IF
           LET l_gem02 = NULL
           SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_tao02
           INSERT INTO gglq705_tao_tmp VALUES(sr1.aag01,sr1.aag02,l_tao02,l_gem02,l_tao09)
           IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN
              CALL cl_err3('ins','gglq705_tao_tmp',sr1.aag01,l_tao02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
 
        FOREACH gglq705_tao02_cs21 USING l_aag01_str
                                   INTO l_tao02,l_tao09
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq705_tao02_cs2',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(l_tao02) THEN CONTINUE FOREACH END IF
           LET l_gem02 = NULL
           SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_tao02
           INSERT INTO gglq705_tao_tmp VALUES(sr1.aag01,sr1.aag02,l_tao02,l_gem02,l_tao09)
           IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN
              CALL cl_err3('ins','gglq705_tao_tmp',sr1.aag01,l_tao02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
     END FOREACH
 
     LET g_prog = 'gglr301'
     #CALL cl_outnam('gglr301') RETURNING l_name  #FUN-8B0106 MARK
     #START REPORT gglq705_rep1 TO l_name         #FUN-8B0106 MARK
     LET g_pageno = 0
 
     DECLARE gglq705_cs11 CURSOR FOR
      SELECT UNIQUE aag01,aag02,tao02,gem02,tao09 FROM gglq705_tao_tmp
       ORDER BY aag01,tao02
 
     FOREACH gglq705_cs11 INTO sr2.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach gglq705_cs1',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr2.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr2.aag01 CLIPPED,'\%'    #No.MOD-940388
 
        #期初
        LET qc1_tao05 = 0  LET qc1_tao06 = 0
        LET qc1_tao10 = 0  LET qc1_tao11 = 0
        LET qc2_tao05 = 0  LET qc2_tao06 = 0
        LET qc2_tao10 = 0  LET qc2_tao11 = 0
        LET qc3_tao05 = 0  LET qc3_tao06 = 0
        LET qc3_tao10 = 0  LET qc3_tao11 = 0
        LET qc4_tao05 = 0  LET qc4_tao06 = 0
        LET qc4_tao10 = 0  LET qc4_tao11 = 0
        #1~mm-1
       #OPEN gglq705_qc1_cs USING sr2.aag01,sr2.tao02
        OPEN gglq705_qc1_cs1 USING l_aag01_str,sr2.tao02,sr2.tao09
        FETCH gglq705_qc1_cs1 INTO qc1_tao05,qc1_tao06,qc1_tao10,qc1_tao11
        CLOSE gglq705_qc1_cs1
        IF cl_null(qc1_tao05) THEN LET qc1_tao05 = 0 END IF
        IF cl_null(qc1_tao06) THEN LET qc1_tao06 = 0 END IF
        IF cl_null(qc1_tao10) THEN LET qc1_tao10 = 0 END IF
        IF cl_null(qc1_tao11) THEN LET qc1_tao11 = 0 END IF
        #mm(day 1~<bdate)
        OPEN gglq705_qc2_cs1 USING l_aag01_str,sr2.tao02,sr2.tao09,'1'
        FETCH gglq705_qc2_cs1 INTO qc2_tao05,qc2_tao10
        CLOSE gglq705_qc2_cs1
        OPEN gglq705_qc2_cs1 USING l_aag01_str,sr2.tao02,sr2.tao09,'2'
        FETCH gglq705_qc2_cs1 INTO qc2_tao06,qc2_tao11
        CLOSE gglq705_qc2_cs1
        IF cl_null(qc2_tao05) THEN LET qc2_tao05 = 0 END IF
        IF cl_null(qc2_tao06) THEN LET qc2_tao06 = 0 END IF
        IF cl_null(qc2_tao10) THEN LET qc2_tao10 = 0 END IF
        IF cl_null(qc2_tao11) THEN LET qc2_tao11 = 0 END IF
 
        #IF tm.c = 'Y' THEN   #FUN-C80102  mark
           #1~mm-1
           OPEN gglq705_qc3_cs1 USING l_aag01_str,sr2.tao02,sr2.tao09,'1'
           FETCH gglq705_qc3_cs1 INTO qc3_tao05,qc3_tao10
           CLOSE gglq705_qc3_cs1
           OPEN gglq705_qc3_cs1 USING l_aag01_str,sr2.tao02,sr2.tao09,'2'
           FETCH gglq705_qc3_cs1 INTO qc3_tao06,qc3_tao11
           CLOSE gglq705_qc3_cs1
           IF cl_null(qc3_tao05) THEN LET qc3_tao05 = 0 END IF
           IF cl_null(qc3_tao06) THEN LET qc3_tao06 = 0 END IF
           IF cl_null(qc3_tao10) THEN LET qc3_tao10 = 0 END IF
           IF cl_null(qc3_tao11) THEN LET qc3_tao11 = 0 END IF
           #mm(1~bdate-1)
           OPEN gglq705_qc4_cs1 USING l_aag01_str,sr2.tao02,sr2.tao09,'1'
           FETCH gglq705_qc4_cs1 INTO qc4_tao05,qc4_tao10
           CLOSE gglq705_qc4_cs1
           OPEN gglq705_qc4_cs1 USING l_aag01_str,sr2.tao02,sr2.tao09,'2'
           FETCH gglq705_qc4_cs1 INTO qc4_tao06,qc4_tao11
           CLOSE gglq705_qc4_cs1
           IF cl_null(qc4_tao05) THEN LET qc4_tao05 = 0 END IF
           IF cl_null(qc4_tao06) THEN LET qc4_tao06 = 0 END IF
           IF cl_null(qc4_tao10) THEN LET qc4_tao10 = 0 END IF
           IF cl_null(qc4_tao11) THEN LET qc4_tao11 = 0 END IF
        #END IF   #FUN-C80102  mark
        LET qc_tao05 = qc1_tao05 + qc2_tao05 + qc3_tao05 + qc4_tao05
        LET qc_tao06 = qc1_tao06 + qc2_tao06 + qc3_tao06 + qc4_tao06
        LET qc_tao10 = qc1_tao10 + qc2_tao10 + qc3_tao10 + qc4_tao10
        LET qc_tao11 = qc1_tao11 + qc2_tao11 + qc3_tao11 + qc4_tao11
 
        LET l_qcye  = qc_tao05 - qc_tao06
        LET l_qcyef = qc_tao10 - qc_tao11
        #若t_qcye = 0 & 異間異動為零，則不打印
        LET t_qcye  = l_qcye
        LET t_qcyef = l_qcyef
        LET l_flag4 = 'N'                            #TQC-970310

        LET l_chr = 'Y'     #FUN-A40011 
        FOR l_i = mm1 TO nn1
            LET l_flag='N'
            FOREACH gglq705_qj1_cs1 USING l_aag01_str,sr2.tao02,sr2.tao09,l_i 
                                    INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET l_flag='Y'
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.tao02   = sr2.tao02
               LET sr.gem02   = sr2.gem02  
              #LET sr.tao09   = sr2.tao09
               LET sr.aba04   = l_i
               LET sr.qcye    = l_qcye
               LET sr.qcyef   = l_qcyef
 
               LET sr.qc_md   = qc2_tao05 + qc4_tao05
               LET sr.qc_mdf  = qc2_tao10 + qc4_tao10
               LET sr.qc_mc   = qc2_tao06 + qc4_tao06
               LET sr.qc_mcf  = qc2_tao11 + qc4_tao11
 
               LET sr.qc_yd   = qc1_tao05 + qc3_tao05
               LET sr.qc_ydf  = qc1_tao10 + qc3_tao10
               LET sr.qc_yc   = qc1_tao06 + qc3_tao06
               LET sr.qc_ycf  = qc1_tao11 + qc3_tao11
 
               IF sr.abb06 = '1' THEN
                  LET t_qcye  = t_qcye + sr.abb07
                  LET t_qcyef = t_qcyef+ sr.abb07
               ELSE
                  LET t_qcye  = t_qcye - sr.abb07
                  LET t_qcyef = t_qcyef- sr.abb07
               END IF
 
             #  OUTPUT TO REPORT gglq705_rep1(sr.*)  #FUN-8B0106 MARK
#No.FUN-8B0106 ADD START    
      IF l_flag4 = 'N' THEN                                     #TQC-970310 add    
         LET t_bal     = sr.qcye
         LET t_balf    = sr.qcyef
         LET t_debit   = sr.qc_yd  + sr.qc_md
         LET t_debitf  = sr.qc_ydf + sr.qc_mdf
         LET t_credit  = sr.qc_yc  + sr.qc_mc
         LET t_creditf = sr.qc_ycf + sr.qc_mcf
         LET l_flag4 = 'Y'                                      #TQC-970310 add
      END IF                                                    #TQC-970310 add      
#TQC-970049--Add--Begin--#
      IF l_flag1 = 'N' THEN
      IF sr.aba04 = MONTH(bdate) THEN
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
        INSERT INTO gglq705_tmp
        VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'1',
             t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF             #FUN-A40011
      LET l_chr = 'N'    #FUN-A40011
                   
      LET l_flag1 = 'Y'
      END IF
#TQC-970049--Add--End--#      
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
         INSERT INTO gglq705_tmp
         VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF
        
#No.FUN-8B0106 ADD END    
         
            END FOREACH
            IF l_flag = "N" THEN
               IF t_qcye = 0 AND t_qcyef = 0 
                  AND qc_tao05 = 0 AND qc_tao06 = 0 THEN
                  CONTINUE FOR
               END IF 
               INITIALIZE sr.* TO NULL
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.tao02   = sr2.tao02
               LET sr.gem02   = sr2.gem02  
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
              #LET sr.abb24   = NULL
               LET sr.abb24   = sr2.tao09
               LET sr.abb25   = 0
 
               LET sr.qc_md   = qc2_tao05 + qc4_tao05
               LET sr.qc_mdf  = qc2_tao10 + qc4_tao10
               LET sr.qc_mc   = qc2_tao06 + qc4_tao06
               LET sr.qc_mcf  = qc2_tao11 + qc4_tao11
 
               LET sr.qc_yd   = qc1_tao05 + qc3_tao05
               LET sr.qc_ydf  = qc1_tao10 + qc3_tao10
               LET sr.qc_yc   = qc1_tao06 + qc3_tao06
               LET sr.qc_ycf  = qc1_tao11 + qc3_tao11
              #  OUTPUT TO REPORT gglq705_rep1(sr.*)  #FUN-8B0106 MARK
#No.FUN-8B0106 ADD START    
      IF l_flag4 = 'N' THEN                                     #TQC-970310 add    
         LET t_bal     = sr.qcye
         LET t_balf    = sr.qcyef
         LET t_debit   = sr.qc_yd  + sr.qc_md
         LET t_debitf  = sr.qc_ydf + sr.qc_mdf
         LET t_credit  = sr.qc_yc  + sr.qc_mc
         LET t_creditf = sr.qc_ycf + sr.qc_mcf
         LET l_flag4 = 'Y'                                      #TQC-970310 add
      END IF                                                    #TQC-970310 add      
#TQC-970049--Add--Begin--#
      IF l_flag1 = 'N' THEN
      IF sr.aba04 = MONTH(bdate) THEN
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
      IF l_chr = 'Y' THEN        #FUN-A40011      
         INSERT INTO gglq705_tmp
          VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'1',
              t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
              l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF             #FUN-A40011
      LET l_chr = 'N'    #FUN-A40011
                    
      LET l_flag1 = 'Y'
      END IF
#TQC-970049--Add--End--#      
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
         INSERT INTO gglq705_tmp
         VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF
        
#No.FUN-8B0106 ADD END    
            END IF            
#No.FUN-8B0106 ADD START
#TQC-970049--Mark--Begin--# 
#     LET t_bal     = sr.qcye
#     LET t_balf    = sr.qcyef
#     LET t_debit   = sr.qc_yd  + sr.qc_md
#     LET t_debitf  = sr.qc_ydf + sr.qc_mdf
#     LET t_credit  = sr.qc_yc  + sr.qc_mc
#     LET t_creditf = sr.qc_ycf + sr.qc_mcf
#     IF sr.aba04 = MONTH(bdate) THEN
#        LET t_date2 = bdate
#     ELSE
#        LET t_date2 = MDY(sr.aba04,1,yy)
#     END IF
 
#     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#      WHERE azi01 = sr.abb24
 
#     IF t_bal > 0 THEN
#        LET n_bal = t_bal
#        LET n_balf= t_balf
#        CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#     ELSE
#        IF t_bal = 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#        ELSE
#           LET n_bal = t_bal * -1
#           LET n_balf= t_balf* -1
#           CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#        END IF
#     END IF
 
#     CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
#     LET l_abb25_bal = n_bal / n_balf
#     IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#     INSERT INTO gglq705_tmp
#     VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'1',
#            t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
#            l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#     LET l_flag1 = 'Y'
#TQC-970049--Mark--End--#      
      
      IF l_flag2 = 'N' THEN
         CALL s_yp(edate) RETURNING l_year,l_month
         IF sr.aba04 = l_month THEN
            LET t_date2 = edate
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
           FROM  gglq705_tmp
#         WHERE sr.abb06 = '1'   AND sr.abb07 IS NOT NULL              #TQC-970310 Mark
          WHERE abb06 = '1'   AND abb07 IS NOT NULL                    #TQC-970310
            AND tao02 = sr.tao02 AND aba04 = sr.aba04
            AND abb24 = sr.abb24                                       #TQC-970310
            AND aag01 = sr.aag01                                       #FUN-A40011            
         SELECT SUM(abb07f) INTO l_df 
           FROM  gglq705_tmp
#         WHERE sr.abb06 = '1'   AND sr.abb07 IS NOT NULL              #TQC-970310 Mark
          WHERE abb06 = '1'   AND abb07 IS NOT NULL                    #TQC-970310          
            AND tao02 = sr.tao02 AND aba04 = sr.aba04
            AND abb24 = sr.abb24                                       #TQC-970310
            AND aag01 = sr.aag01                                       #FUN-A40011            
         SELECT SUM(abb07) INTO l_c 
           FROM  gglq705_tmp
#         WHERE sr.abb06 = '2'   AND sr.abb07 IS NOT NULL              #TQC-970310 Mark
#           AND tao02 = tao02 AND aba04 = sr.aba04                     #TQC-970310 Mark
          WHERE abb06 = '2'   AND abb07 IS NOT NULL                    #TQC-970310          
            AND tao02 = sr.tao02 AND aba04 = sr.aba04                  #TQC-970310
            AND abb24 = sr.abb24                                       #TQC-970310
            AND aag01 = sr.aag01                                       #FUN-A40011            
         SELECT SUM(abb07f) INTO l_cf 
           FROM  gglq705_tmp
#         WHERE sr.abb06 = '2'   AND sr.abb07 IS NOT NULL              #TQC-970310 Mark
          WHERE abb06 = '2'   AND abb07 IS NOT NULL                    #TQC-970310          
            AND tao02 = sr.tao02 AND aba04 = sr.aba04            
            AND abb24 = sr.abb24                                       #TQC-970310   
            AND aag01 = sr.aag01                                       #FUN-A40011
             
         #LET l_d = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
         #LET l_df= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
         #LET l_c = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
         #LET l_cf= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
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
       #TQC-930163 --begin
       # LET l_abb25_d = l_df / l_d
       # LET l_abb25_c = l_cf / l_c
       # LET l_abb25_bal = n_balf / n_bal
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
       #TQC-930163 --end
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d)   THEN LET l_abb25_d   = 0 END IF
         IF cl_null(l_abb25_c)   THEN LET l_abb25_c   = 0 END IF
         INSERT INTO gglq705_tmp
         VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'3',
                t_date2,'',g_msg,sr.abb24,'',0,0,
                l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
   
   
         CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
         LET l_abb25_d = t_debit / t_debitf
         LET l_abb25_c = t_credit / t_creditf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq705_tmp
         VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'4',
                t_date2,'',g_msg,sr.abb24,'',0,0,
                t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF      
 
#No.FUN-8B0106 ADD END
      LET l_flag1 = 'N'                   #TQC-970049             
        END FOR
     END FOREACH
 
   #  FINISH REPORT gglq705_rep1    #No.FUN-8B0106 mark
 
END FUNCTION
#TQC-930163 --end
 
FUNCTION gglq705_cs()
     #TQC-930163 --begin
     #IF tm.d = 'N' THEN    #FUN-C80102  mark
   #FUN-D10075--mark--str--
   #  IF tm.e = 'N' THEN     #FUN-C80102  add
#  #      LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,'',aba04", #TQC-930163  #FUN-A40011 mark
   #      LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,''",   #FUN-A40011 
   #                 "  FROM gglq705_tmp ",
#  #                  " ORDER BY aag01,tao02,aba04 "  #TQC-930163   #FUN-A40011 mark
   #                  " ORDER BY aag01,tao02 "                      #FUN-A40011 
   #  ELSE
#  #      LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,abb24,aba04", #TQC-930163   #FUN-A40011 mark
   #       #LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,abb24",                   #FUN-A40011   #FUN-C80102  mark
   #       LET g_sql = "SELECT UNIQUE '','','','',abb24", 
   #                   "  FROM gglq705_tmp ",
#  #                   " ORDER BY aag01,tao02,abb24,aba04 "  #TQC-930163  #FUN-A40011 mark
   #                   #" ORDER BY aag01,tao02,abb24 "                     #FUN-A40011   #FUN-C80102  mark
   #                   " ORDER BY abb24 "     #FUN-C80102  add
   #  END IF
   #FUN-D10075--mark--end
     #TQC-930163 --end
   #FUN-D10075--add--str--
   IF tm.f = 'Y' THEN
        IF tm.i = 'Y' THEN 
           IF tm.e = 'Y' THEN 
              LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,abb24", 
                          "  FROM gglq705_tmp ",
                          " ORDER BY aag01,tao02,abb24 "  
           ELSE
              LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,''", 
                          "  FROM gglq705_tmp ",
                          " ORDER BY aag01,tao02 "
           END IF 
        ELSE
           IF tm.e = 'Y' THEN 
              LET g_sql = "SELECT UNIQUE aag01,aag02,'','',abb24", 
                          "  FROM gglq705_tmp ",
                          " ORDER BY aag01,abb24 "  
           ELSE
              LET g_sql = "SELECT UNIQUE aag01,aag02,'','',''", 
                          "  FROM gglq705_tmp ",
                          " ORDER BY aag01 "
           END IF
        END IF 
     ELSE
        IF tm.i = 'Y' THEN 
           IF tm.e = 'Y' THEN 
              LET g_sql = "SELECT UNIQUE '','',tao02,gem02,abb24", 
                          "  FROM gglq705_tmp ",
                          " ORDER BY tao02,abb24 "  
           ELSE
              LET g_sql = "SELECT UNIQUE '','',tao02,gem02,''", 
                          "  FROM gglq705_tmp ",
                          " ORDER BY tao02 "
           END IF 
        ELSE
           IF tm.e = 'Y' THEN 
              LET g_sql = "SELECT UNIQUE '','','','',abb24", 
                          "  FROM gglq705_tmp ",
                          " ORDER BY abb24 "  
           ELSE
              LET g_sql = "SELECT UNIQUE '','','','',''", 
                          "  FROM gglq705_tmp "
           END IF
        END IF 
     END IF  
   #FUN-D10075--add--end
     PREPARE gglq705_ps FROM g_sql
     DECLARE gglq705_curs SCROLL CURSOR WITH HOLD FOR gglq705_ps
 
     #TQC-930163 --begin
     #IF tm.d = 'N' THEN   #FUN-C80102  mark
   #FUN-D10075--mark--str--
   #  IF tm.e = 'N' THEN    #FUN-C80102  add
#  #      LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,aba04", #TQC-930163   #FUN-A40011 mark
   #      LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02",    #FUN-A40011 
   #                 "  FROM gglq705_tmp ",
   #                 "  INTO TEMP x "
   #  ELSE
 # #      LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,abb24,aba04", #TQC-930163   #FUN-A40011 mark
   #      #LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,abb24",         #FUN-A40011  #FUN-C80102  mark
   #      LET g_sql = "SELECT UNIQUE abb24",    #FUN-C80102  add
   #                  "  FROM gglq705_tmp ",
   #                  "  INTO TEMP x "
   #  END IF
   #FUN-D10075--mark--end
     #TQC-930163 --end
   #FUN-D10075--add--str--
   IF tm.f = 'Y' THEN 
        IF tm.i = 'Y' THEN 
           IF tm.e = 'Y' THEN 
              LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02,abb24",     
                          "  FROM gglq705_tmp ",
                          "  INTO TEMP x "
           ELSE
              LET g_sql = "SELECT UNIQUE aag01,aag02,tao02,gem02",     
                          "  FROM gglq705_tmp ",
                          "  INTO TEMP x "
           END IF 
        ELSE
           IF tm.e = 'Y' THEN 
              LET g_sql = "SELECT UNIQUE aag01,aag02,abb24",     
                          "  FROM gglq705_tmp ",
                          "  INTO TEMP x "
           ELSE
              LET g_sql = "SELECT UNIQUE aag01,aag02",     
                          "  FROM gglq705_tmp ",
                          "  INTO TEMP x "
           END IF 
        END IF 
     ELSE
        IF tm.i = 'Y' THEN 
           IF tm.e = 'Y' THEN 
              LET g_sql = "SELECT UNIQUE tao02,gem02,abb24",     
                          "  FROM gglq705_tmp ",
                          "  INTO TEMP x "
           ELSE
              LET g_sql = "SELECT UNIQUE tao02,gem02",     
                          "  FROM gglq705_tmp ",
                          "  INTO TEMP x "
           END IF 
        ELSE
           IF tm.e = 'Y' THEN 
              LET g_sql = "SELECT UNIQUE abb24",     
                          "  FROM gglq705_tmp ",
                          "  INTO TEMP x "
           ELSE
              LET g_sql = "SELECT * ",     
                          "  FROM gglq705_tmp ",
                          "  INTO TEMP x "
           END IF 
        END IF
     END IF 
     #FUN-D10075--add--end
     DROP TABLE x
     PREPARE gglq705_ps1 FROM g_sql
     EXECUTE gglq705_ps1
 
     LET g_sql = "SELECT COUNT(*) FROM x",
                 " WHERE ",tm.wc3     #FUN-C80102
     PREPARE gglq705_ps2 FROM g_sql
     DECLARE gglq705_cnt CURSOR FOR gglq705_ps2
 
     LET g_aag01 = NULL
     LET g_aag02 = NULL
     LET g_tao02 = NULL
     LET g_gem02 = NULL
     LET g_aba04  = NULL
     OPEN gglq705_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq705_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq705_cnt
        FETCH gglq705_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq705_fetch('F')
     END IF
END FUNCTION
 
FUNCTION gglq705_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10


      CASE p_flag
         #FUN-C80102--mark--str--
         #WHEN 'N' FETCH NEXT     gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_tao09  #,g_aba04  #TQC-930163   #FUN-A40011 mark
         #WHEN 'P' FETCH PREVIOUS gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_tao09  #,g_aba04  #TQC-930163   #FUN-A40011 mark
         #WHEN 'F' FETCH FIRST    gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_tao09  #,g_aba04  #TQC-930163   #FUN-A40011 mark 
         #WHEN 'L' FETCH LAST     gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_tao09  #,g_aba04  #TQC-930163   #FUN-A40011 mark 
         #FUN-C80102--mark--end--

         #FUN-C80102--add--str--
         WHEN 'N' FETCH NEXT     gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_abb24  
         WHEN 'P' FETCH PREVIOUS gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_abb24  
         WHEN 'F' FETCH FIRST    gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_abb24  
         WHEN 'L' FETCH LAST     gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_abb24
         #FUN-C80102--add--end--
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
         #FETCH ABSOLUTE g_jump gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_tao09 #,g_aba04  #TQC-930163   #FUN-A40011 mark    #FUN-C80102  mark
         FETCH ABSOLUTE g_jump gglq705_curs INTO g_aag01,g_aag02,g_tao02,g_gem02,g_abb24     #FUN-C80102  add
         LET mi_no_ask = FALSE
      END CASE

 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aag01,SQLCA.sqlcode,0)
      INITIALIZE g_aag01 TO NULL
      INITIALIZE g_aag02 TO NULL
      INITIALIZE g_tao02 TO NULL
      INITIALIZE g_gem02 TO NULL
      #INITIALIZE g_tao09 TO NULL  #TQC-930163 
      INITIALIZE g_abb24 TO NULL   #FUN-C80102  add
#      INITIALIZE g_aba04 TO NULL   #FUN-A40011 mark
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
      IF g_row_count = '0' THEN 
         INITIALIZE tm.* TO NULL
         INITIALIZE bookno TO NULL
         INITIALIZE bdate TO NULL
         INITIALIZE edate TO NULL
      END IF 
      #FUN-C80102--add--end--
      #FUN-D10075--add--str-- 
      IF tm.f = 'N' THEN 
         IF tm.i = 'N' THEN 
            IF tm.e = 'N' THEN 
               LET g_row_count = '0'
            END IF 
         END IF 
      END IF 
      #FUN-D10075--add--end--
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   CALL gglq705_show()
END FUNCTION
 
FUNCTION gglq705_show()

   #FUN-C80102--mark--str--
   #DISPLAY g_aag01 TO aag01
   #DISPLAY g_aag02 TO aag02
   #DISPLAY g_tao02 TO tao02
   #DISPLAY g_gem02 TO gem02 
   #FUN-C80102--mark--end--

   #FUN-C80102--add--str--
   DISPLAY bookno TO bookno    
   DISPLAY bdate  TO bdate     
   DISPLAY edate  TO edate     
   DISPLAY tm.a   TO a
   DISPLAY tm.aag24 TO aag24  #TQC-CC0122  add
   DISPLAY tm.g   TO g
   DISPLAY tm.b   TO b
   DISPLAY tm.e   TO e   
   #FUN-C80102--add--end--
   DISPLAY g_tao09 TO tao09  #TQC-930163 
   #DISPLAY yy TO yy    #FUN-C80102  mark
#  DISPLAY g_aba04 TO mm  #FUN-A40011 mark
 
   #TQC-CC0122--add--str--
   DISPLAY tm.aag09 TO aag09
   DISPLAY tm.aag38 TO aag38
   #TQC-CC0122--add--end--

   #FUN-D10075--add--str--
   DISPLAY tm.f    TO f
   DISPLAY tm.i    TO i
   #FUN-D10075--add--end--
   DISPLAY tm.h    TO h     #FUN-D40044 add

   CALL gglq705_b_fill()
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION gglq705_b_fill()
  DEFINE  l_abb06    LIKE abb_file.abb06
  DEFINE  l_type     LIKE type_file.chr1
 
   LET g_sql = "SELECT aag01,aag02,tao02,gem02,aba02,aba01,abb04,abb24,df,abb25_d,d,",     #FUN-C80102  add aag01,aag02,tao02,gem02
               "       cf,abb25_c,c,dc,balf,abb25_bal,bal,",
               "       azi04,azi05,azi07,abb06,type ",
               "  FROM gglq705_tmp",
               " WHERE ",tm.wc3    #FUN-C80102  add
               #" WHERE aag01 ='",g_aag01,"'",      #FUN-C80102  mark
               #"   AND tao02 ='",g_tao02,"'",    #   #FUN-A40011 mark  #FUN-C80102  mark
               #"    AND ",tm.wc3  #FUN-C80102  add  #FUN-C80102  mark
#               "   AND aba04 = ",g_aba04    #FUN-A40011 mark
   #TQC-930163 --begin
   #           " ORDER BY type,aba02,aba01 "
   #IF tm.d = 'Y' THEN     #FUN-C80102  mark
   #FUN-D10075--mark--str--
   #IF tm.e = 'Y' THEN      #FUN-C80102  add
   #   LET g_sql = g_sql CLIPPED,
   #              #"   AND (abb24 ='",g_tao09,"' OR abb24 IS NULL)",      #FUN-C80102  mark
   #               "   AND (abb24 ='",g_abb24,"' OR abb24 IS NULL)"       #FUN-C80102  add
   #              #" ORDER BY aag01,tao02,aba02,type,aba01 "              #FUN-C80102  add  aag01,tao02 #MOD-C70312 mark
   #ELSE
   #   LET g_sql = g_sql CLIPPED,
   #               "   AND aag01 ='",g_aag01,"'",
   #               "   AND tao02 ='",g_tao02,"'" 
   #              #" ORDER BY aag01,tao02,aba02,type,aba01 "              #FUN-C80102  add  aag01,tao02 #MOD-C70312 mark
   #END IF
   #FUN-D10075--mark--end
   #TQC-930163 --end
 
   #FUN-D10075--add--str--
   IF tm.f = 'Y' THEN 
      IF tm.i = 'Y' THEN 
         IF tm.e = 'Y' THEN 
            LET g_sql = g_sql CLIPPED,
                        "   AND aag01 ='",g_aag01,"'",
                        "   AND tao02 ='",g_tao02,"'",
                        "   AND (abb24 ='",g_abb24,"' OR abb24 IS NULL)",  
                        " ORDER BY aag01,tao02,abb24,aba02,type,aba01 "  
         ELSE
            LET g_sql = g_sql CLIPPED,
                        "   AND aag01 ='",g_aag01,"'",
                        "   AND tao02 ='",g_tao02,"'",
                        " ORDER BY aag01,tao02,abb24,aba02,type,aba01 " 
         END IF 
      ELSE
         IF tm.e = 'Y' THEN 
            LET g_sql = g_sql CLIPPED,
                        "   AND aag01 ='",g_aag01,"'",
                        "   AND (abb24 ='",g_abb24,"' OR abb24 IS NULL)",  
                        " ORDER BY aag01,tao02,abb24,aba02,type,aba01 " 
         ELSE
            LET g_sql = g_sql CLIPPED,
                        "   AND aag01 ='",g_aag01,"'",
                        " ORDER BY aag01,tao02,abb24,aba02,type,aba01 "  
         END IF 
      END IF 
   ELSE
      IF tm.i = 'Y' THEN 
         IF tm.e = 'Y' THEN 
            LET g_sql = g_sql CLIPPED,
                        "   AND tao02 ='",g_tao02,"'",
                        "   AND (abb24 ='",g_abb24,"' OR abb24 IS NULL)",  
                        " ORDER BY aag01,tao02,abb24,aba02,type,aba01 " 
         ELSE
            LET g_sql = g_sql CLIPPED,
                        "   AND tao02 ='",g_tao02,"'",
                        " ORDER BY aag01,tao02,abb24,aba02,type,aba01 "  
         END IF 
      ELSE
         IF tm.e = 'Y' THEN 
            LET g_sql = g_sql CLIPPED,
                        "   AND (abb24 ='",g_abb24,"' OR abb24 IS NULL)",  
                        " ORDER BY aag01,tao02,abb24,aba02,type,aba01 " 
         ELSE
            LET g_sql = g_sql CLIPPED,
                        " ORDER BY aag01,tao02,abb24,aba02,type,aba01 " 
         END IF 
      END IF 
   END IF 
   #FUN-D10075--add--end

   PREPARE gglq705_pb FROM g_sql
   DECLARE abb_curs  CURSOR FOR gglq705_pb
 
   CALL g_abb.clear()
   call g_abb_excel.clear() #darcy:2025/02/14 add
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH abb_curs INTO g_abb_excel[g_cnt].*,t_azi04,t_azi05,t_azi07,l_abb06,l_type
   #darcy:2025/02/14 mod g_abb - > g_abb_excel
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #darcy:2025/02/14 mod s---
      # g_abb-> g_abb_excel
      LET g_abb_excel[g_cnt].d   = cl_numfor(g_abb_excel[g_cnt].d,20,g_azi04)
      LET g_abb_excel[g_cnt].c   = cl_numfor(g_abb_excel[g_cnt].c,20,g_azi04)
      LET g_abb_excel[g_cnt].bal = cl_numfor(g_abb_excel[g_cnt].bal,20,g_azi04)
      LET g_abb_excel[g_cnt].df  = cl_numfor(g_abb_excel[g_cnt].df,20,t_azi04)
      LET g_abb_excel[g_cnt].cf  = cl_numfor(g_abb_excel[g_cnt].cf,20,t_azi04)
      LET g_abb_excel[g_cnt].balf= cl_numfor(g_abb_excel[g_cnt].balf,20,t_azi04)
      LET g_abb_excel[g_cnt].abb25_d= cl_numfor(g_abb_excel[g_cnt].abb25_d,20,t_azi07)
      LET g_abb_excel[g_cnt].abb25_c= cl_numfor(g_abb_excel[g_cnt].abb25_c,20,t_azi07)
      LET g_abb_excel[g_cnt].abb25_bal= cl_numfor(g_abb_excel[g_cnt].abb25_bal,20,t_azi07)
 
      IF l_type = '1' THEN
         LET g_abb_excel[g_cnt].d = NULL
         LET g_abb_excel[g_cnt].df= NULL
         LET g_abb_excel[g_cnt].abb25_d= NULL
         LET g_abb_excel[g_cnt].c = NULL
         LET g_abb_excel[g_cnt].cf = NULL
         LET g_abb_excel[g_cnt].abb25_c= NULL
       # LET g_abb_excel[g_cnt].balf= NULL
         #IF tm.d = 'N' THEN  #TQC-930163    #FUN-C80102  mark
         IF tm.e = 'N' THEN                  #FUN-C80102  add
            LET g_abb_excel[g_cnt].balf= NULL
         END IF
         LET g_abb_excel[g_cnt].abb25_bal = NULL
      END IF
      IF l_type = '3' OR l_type = '4' THEN
         #TQC-930163   --begin
         LET g_abb_excel[g_cnt].abb25_d= NULL
         LET g_abb_excel[g_cnt].abb25_c= NULL
         LET g_abb_excel[g_cnt].abb25_bal = NULL
         #IF tm.d = 'N' THEN        #FUN-C80102  mark
         IF tm.e = 'N' THEN         #FUN-C80102  add 
            LET g_abb_excel[g_cnt].df = NULL
            LET g_abb_excel[g_cnt].cf = NULL
            LET g_abb_excel[g_cnt].balf = NULL
         END IF
         #TQC-930163   --end
      END IF
      IF l_type = '2' THEN
         #IF tm.d = 'N' THEN  #TQC-930163     #FUN-C80102  mark
         IF tm.e = 'N' THEN                   #FUN-C80102  add 
            LET g_abb_excel[g_cnt].balf= NULL
            LET g_abb_excel[g_cnt].abb25_bal = NULL
         END IF
      END IF
      IF l_abb06 = '1' THEN
         LET g_abb_excel[g_cnt].c = NULL
         LET g_abb_excel[g_cnt].cf = NULL
         LET g_abb_excel[g_cnt].abb25_c= NULL
      END IF
      IF l_abb06 = '2' THEN
         LET g_abb_excel[g_cnt].d = NULL
         LET g_abb_excel[g_cnt].df= NULL
         LET g_abb_excel[g_cnt].abb25_d= NULL
      END IF
      if g_cnt < g_max_rec THEN
         let g_abb[g_cnt].*  = g_abb_excel[g_cnt].*
      end if
      #darcy:2025/02/14 mod e---

      LET g_cnt = g_cnt + 1
      #darcy:2025/02/14 mark s---
      -- IF g_cnt > g_max_rec THEN
      --    CALL cl_err( '', 9035, 0 )
      -- EXIT FOREACH
      -- END IF
      #darcy:2025/02/14 mark e---
   END FOREACH

   
   #FUN-C80102--add--str--
   LET g_msg = cl_getmsg('ggl-215',g_lang)
   IF g_cnt - 1 > 0 THEN
      #FUN-D10075--mark--str--
      #IF tm.e = 'Y' THEN 
      #    SELECT '','','','','','','','',SUM(df),'',SUM(d),SUM(cf),'',SUM(c),'',
      #           SUM(balf),'',SUM(bal)
      #    INTO g_abb[g_cnt].*
      #    FROM gglq705_tmp
      #    WHERE abb24 = g_abb24
      #      AND abb04 = g_msg
      # ELSE 
      #    SELECT '','','','','','','','',SUM(df),'',SUM(d),SUM(cf),'',SUM(c),'',
      #           SUM(balf),'',SUM(bal)
      #    INTO g_abb[g_cnt].*
      #    FROM gglq705_tmp
      #    WHERE aag01 = g_aag01
      #      AND tao02 = g_tao02
      #      AND abb04 = g_msg
      # END IF
      #FUN-D10075--mark--end
      #FUN-D10075--add--str--
      #darcy:2025/02/14 mod s---
      # g_abb -> g_abb_excel
       IF tm.f = 'Y' THEN 
          IF tm.i = 'Y' THEN 
             IF tm.e = 'Y' THEN 
                SELECT '','','','','','','','','','',SUM(d),'','',SUM(c),'',
                       '','',SUM(bal)
                  INTO g_abb_excel[g_cnt].*
                  FROM gglq705_tmp
                 WHERE aag01 = g_aag01
                   AND tao02 = g_tao02
                   AND abb24 = g_abb24
                   AND abb04 = g_msg
             ELSE
                SELECT '','','','','','','','','','',SUM(d),'','',SUM(c),'',
                       '','',SUM(bal)
                  INTO g_abb_excel[g_cnt].*
                  FROM gglq705_tmp
                 WHERE aag01 = g_aag01
                   AND tao02 = g_tao02
                   AND abb04 = g_msg
             END IF
          ELSE
             IF tm.e = 'Y' THEN 
                SELECT '','','','','','','','','','',SUM(d),'','',SUM(c),'',
                       '','',SUM(bal)
                  INTO g_abb_excel[g_cnt].*
                  FROM gglq705_tmp
                 WHERE aag01 = g_aag01
                   AND abb24 = g_abb24
                   AND abb04 = g_msg
             ELSE
                SELECT '','','','','','','','','','',SUM(d),'','',SUM(c),'',
                       '','',SUM(bal)
                  INTO g_abb_excel[g_cnt].*
                  FROM gglq705_tmp
                 WHERE aag01 = g_aag01
                   AND abb04 = g_msg
             END IF 
          END IF 
       ELSE
          IF tm.i = 'Y' THEN 
             IF tm.e = 'Y' THEN 
                SELECT '','','','','','','','','','',SUM(d),'','',SUM(c),'',
                       '','',SUM(bal)
                  INTO g_abb_excel[g_cnt].*
                  FROM gglq705_tmp  
                 WHERE tao02 = g_tao02
                   AND abb24 = g_abb24
                   AND abb04 = g_msg
             ELSE
                SELECT '','','','','','','','','','',SUM(d),'','',SUM(c),'',
                       '','',SUM(bal)
                  INTO g_abb_excel[g_cnt].*
                  FROM gglq705_tmp
                 WHERE tao02 = g_tao02
                   AND abb04 = g_msg
             END IF
          ELSE
             IF tm.e = 'Y' THEN 
                SELECT '','','','','','','','','','',SUM(d),'','',SUM(c),'',
                       '','',SUM(bal)
                  INTO g_abb_excel[g_cnt].*
                  FROM gglq705_tmp
                 WHERE abb24 = g_abb24
                   AND abb04 = g_msg
             ELSE
                SELECT '','','','','','','','','','',SUM(d),'','',SUM(c),'',
                       '','',SUM(bal)
                  INTO g_abb_excel[g_cnt].*
                  FROM gglq705_tmp
                 WHERE abb04 = g_msg
             END IF 
          END IF 
       END IF 
       #FUN-D10075--add--end 
       LET g_abb_excel[g_cnt].abb24 = cl_getmsg('axr107',g_lang)
   END IF 
   #FUN-C80102--add--end--
   let g_abb[g_abb.getlength()+1].* = g_abb_excel[g_cnt].*
   #darcy:2025/02/14 mod e---
 
   #CALL g_abb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
 
#No.FUN-8B0106 mark start
##TQC-930163  --begin
#REPORT gglq705_rep1(sr)
#  DEFINE
#         sr                   RECORD
#                              aag01    LIKE aag_file.aag01,
#                              aag02    LIKE aag_file.aag02,
#                              tao02    LIKE tao_file.tao02,
#                              gem02    LIKE gem_file.gem02,
#                              aba04    LIKE aba_file.aba04,
#                              aba02    LIKE aba_file.aba02,
#                              aba01    LIKE aba_file.aba01,
#                              abb04    LIKE abb_file.abb04,
#                              abb06    LIKE abb_file.abb06,
#                              abb07    LIKE abb_file.abb07,
#                              abb07f   LIKE abb_file.abb07f,
#                              abb24    LIKE abb_file.abb24,
#                              abb25    LIKE abb_file.abb25,
#                              qcye     LIKE abb_file.abb07,
#                              qcyef    LIKE abb_file.abb07,
#                              qc_md    LIKE abb_file.abb07,
#                              qc_mdf   LIKE abb_file.abb07,
#                              qc_mc    LIKE abb_file.abb07,
#                              qc_mcf   LIKE abb_file.abb07,
#                              qc_yd    LIKE abb_file.abb07,
#                              qc_ydf   LIKE abb_file.abb07,
#                              qc_yc    LIKE abb_file.abb07,
#                              qc_ycf   LIKE abb_file.abb07
#                              END RECORD,
#         t_bal,t_balf                 LIKE abb_file.abb07,
#         t_debit,t_debitf             LIKE abb_file.abb07,
#         t_credit,t_creditf           LIKE abb_file.abb07,
#         l_d,l_df,l_c,l_cf            LIKE abb_file.abb07,
#         n_bal,n_balf                 LIKE abb_file.abb07,
#         l_abb25_c,l_abb25_d,l_abb25_bal LIKE abb_file.abb25,
#         l_date2                      LIKE type_file.dat,
#         l_date1                      LIKE type_file.dat,
#         l_flag1                      LIKE type_file.chr1, #TQC-930163 
#         l_flag2                      LIKE type_file.chr1, #TQC-930163 
#         l_dc                         LIKE type_file.chr10,
#         l_year                       LIKE type_file.num10,
#         l_month                      LIKE type_file.num10
 
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
 
# #ORDER BY sr.aag01,sr.tao02,sr.aba04,sr.aba02,sr.aba01
#  ORDER BY sr.aag01,sr.tao02,sr.abb24,sr.aba04,sr.aba02,sr.aba01
 
# FORMAT
#  PAGE HEADER
#     LET g_pageno = g_pageno + 1
 
#  BEFORE GROUP OF sr.tao02
#     LET t_bal     = sr.qcye
#     LET t_balf    = sr.qcyef
#     LET t_debit   = sr.qc_yd  + sr.qc_md
#     LET t_debitf  = sr.qc_ydf + sr.qc_mdf
#     LET t_credit  = sr.qc_yc  + sr.qc_mc
#     LET t_creditf = sr.qc_ycf + sr.qc_mcf
#     LET l_flag1 = 'N'
#     LET l_flag2 = 'N'
 
#  BEFORE GROUP OF sr.abb24
#     LET t_bal     = sr.qcye
#     LET t_balf    = sr.qcyef
#     LET t_debit   = sr.qc_yd  + sr.qc_md
#     LET t_debitf  = sr.qc_ydf + sr.qc_mdf
#     LET t_credit  = sr.qc_yc  + sr.qc_mc
#     LET t_creditf = sr.qc_ycf + sr.qc_mcf
#     IF sr.aba04 = MONTH(bdate) THEN
#        LET l_date2 = bdate
#     ELSE
#        LET l_date2 = MDY(sr.aba04,1,yy)
#     END IF
 
#     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#      WHERE azi01 = sr.abb24
 
#     IF t_bal > 0 THEN
#        LET n_bal = t_bal
#        LET n_balf= t_balf
#        CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#     ELSE
#        IF t_bal = 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#        ELSE
#           LET n_bal = t_bal * -1
#           LET n_balf= t_balf* -1
#           CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#        END IF
#     END IF
 
#     CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
#     LET l_abb25_bal = n_bal / n_balf
#     IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#     INSERT INTO gglq705_tmp
#     VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'1',
#            l_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
#            l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#     LET l_flag1 = 'Y'
 
#  BEFORE GROUP OF sr.aba04
#     IF l_flag1 = 'N' THEN
#        IF sr.aba04 = MONTH(bdate) THEN
#           LET l_date2 = bdate
#        ELSE
#           LET l_date2 = MDY(sr.aba04,1,yy)
#        END IF
 
#        SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#         WHERE azi01 = sr.abb24
 
#        IF t_bal > 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#        ELSE
#           IF t_bal = 0 THEN
#              LET n_bal = t_bal
#              LET n_balf= t_balf
#              CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#           ELSE
#              LET n_bal = t_bal * -1
#              LET n_balf= t_balf* -1
#              CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#           END IF
#        END IF
 
#        CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
#        LET l_abb25_bal = n_bal / n_balf
#        IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#        INSERT INTO gglq705_tmp
#        VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'1',
#               l_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
#               l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#     END IF
 
#  ON EVERY ROW
#     LET l_flag1 = 'N'
#     LET l_flag2 = 'N'
#     IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
#        SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#         WHERE azi01 = sr.abb24
#        IF cl_null(sr.abb07)  THEN LET sr.abb07  = 0 END IF
#        IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
#        IF sr.abb06 = 1 THEN
#           LET t_bal   = t_bal   + sr.abb07
#           LET t_balf  = t_balf  + sr.abb07f
#           LET t_debit = t_debit + sr.abb07
#           LET t_debitf= t_debitf+ sr.abb07f
#        ELSE
#           LET t_bal    = t_bal    - sr.abb07
#           LET t_balf   = t_balf   - sr.abb07f
#           LET t_credit = t_credit + sr.abb07
#           LET t_creditf= t_creditf+ sr.abb07f
#        END IF
 
#        IF t_bal > 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#        ELSE
#           IF t_bal = 0 THEN
#              LET n_bal = t_bal
#              LET n_balf= t_balf
#              CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#           ELSE
#              LET n_bal = t_bal * -1
#              LET n_balf= t_balf* -1
#              CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#           END IF
#        END IF
#        IF sr.abb06 = '1' THEN
#           LET l_d  = sr.abb07
#           LET l_df = sr.abb07f
#           LET l_c  = 0
#           LET l_cf = 0
#        ELSE
#           LET l_d  = 0
#           LET l_df = 0
#           LET l_c  = sr.abb07
#           LET l_cf = sr.abb07f
#        END IF
 
 
#        LET l_abb25_d = l_d / l_df
#        LET l_abb25_c = l_c / l_cf
#        LET l_abb25_bal = n_bal / n_balf
#        IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#        IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
#        IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
#        INSERT INTO gglq705_tmp
#        VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'2',
#               sr.aba02,sr.aba01,sr.abb04,
#               sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
#               l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
#               l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#        PRINT
#     END IF
 
#  AFTER GROUP OF sr.abb24
#     IF l_flag2 = 'N' THEN
#        CALL s_yp(edate) RETURNING l_year,l_month
#        IF sr.aba04 = l_month THEN
#           LET l_date2 = edate
#        ELSE
#           CALL s_azn01(yy,sr.aba04) RETURNING l_date1,l_date2
#        END IF
#  
#        SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#         WHERE azi01 = sr.abb24
#  
#        IF t_bal > 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#        ELSE
#           IF t_bal = 0 THEN
#              LET n_bal = t_bal
#              LET n_balf= t_balf
#              CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#           ELSE
#              LET n_bal = t_bal * -1
#              LET n_balf= t_balf* -1
#              CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#           END IF
#        END IF
#  
#        LET l_d = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
#        LET l_df= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
#        LET l_c = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
#        LET l_cf= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
#        IF cl_null(l_d)  THEN LET l_d  = 0 END IF
#        IF cl_null(l_df) THEN LET l_df = 0 END IF
#        IF cl_null(l_c)  THEN LET l_c  = 0 END IF
#        IF cl_null(l_cf) THEN LET l_cf = 0 END IF
#        IF sr.aba04 = mm1 THEN
#           LET l_d  = l_d  + sr.qc_md
#           LET l_df = l_df + sr.qc_mdf
#           LET l_c  = l_c  + sr.qc_mc
#           LET l_cf = l_cf + sr.qc_mcf
#        END IF
#        CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg
#      #TQC-930163 --begin
#      # LET l_abb25_d = l_df / l_d
#      # LET l_abb25_c = l_cf / l_c
#      # LET l_abb25_bal = n_balf / n_bal
#        LET l_abb25_d = l_d / l_df
#        LET l_abb25_c = l_c / l_cf
#        LET l_abb25_bal = n_bal / n_balf
#      #TQC-930163 --end
#        IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#        IF cl_null(l_abb25_d)   THEN LET l_abb25_d   = 0 END IF
#        IF cl_null(l_abb25_c)   THEN LET l_abb25_c   = 0 END IF
#        INSERT INTO gglq705_tmp
#        VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'3',
#               l_date2,'',g_msg,sr.abb24,'',0,0,
#               l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
#               l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#  
#  
#        CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
#        LET l_abb25_d = t_debit / t_debitf
#        LET l_abb25_c = t_credit / t_creditf
#        LET l_abb25_bal = n_bal / n_balf
#        IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#        IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
#        IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
#        INSERT INTO gglq705_tmp
#        VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'4',
#               l_date2,'',g_msg,sr.abb24,'',0,0,
#               t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
#               l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#     END IF
 
#  AFTER GROUP OF sr.aba04
#     CALL s_yp(edate) RETURNING l_year,l_month
#     IF sr.aba04 = l_month THEN
#        LET l_date2 = edate
#     ELSE
#        CALL s_azn01(yy,sr.aba04) RETURNING l_date1,l_date2
#     END IF
 
#     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#      WHERE azi01 = sr.abb24
 
#     IF t_bal > 0 THEN
#        LET n_bal = t_bal
#        LET n_balf= t_balf
#        CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#     ELSE
#        IF t_bal = 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#        ELSE
#           LET n_bal = t_bal * -1
#           LET n_balf= t_balf* -1
#           CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#        END IF
#     END IF
 
#     LET l_d = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
#     LET l_df= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
#     LET l_c = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
#     LET l_cf= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
#     IF cl_null(l_d)  THEN LET l_d  = 0 END IF
#     IF cl_null(l_df) THEN LET l_df = 0 END IF
#     IF cl_null(l_c)  THEN LET l_c  = 0 END IF
#     IF cl_null(l_cf) THEN LET l_cf = 0 END IF
#     IF sr.aba04 = mm1 THEN
#        LET l_d  = l_d  + sr.qc_md
#        LET l_df = l_df + sr.qc_mdf
#        LET l_c  = l_c  + sr.qc_mc
#        LET l_cf = l_cf + sr.qc_mcf
#     END IF
#     CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg
#   #TQC-930163 --begin
#   # LET l_abb25_d = l_df / l_d
#   # LET l_abb25_c = l_cf / l_c
#   # LET l_abb25_bal = n_balf / n_bal
#     LET l_abb25_d = l_d / l_df
#     LET l_abb25_c = l_c / l_cf
#     LET l_abb25_bal = n_bal / n_balf
#   #TQC-930163 --end
#     IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#     IF cl_null(l_abb25_d)   THEN LET l_abb25_d   = 0 END IF
#     IF cl_null(l_abb25_c)   THEN LET l_abb25_c   = 0 END IF
#     INSERT INTO gglq705_tmp
#     VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'3',
#            l_date2,'',g_msg,sr.abb24,'',0,0,
#            l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
#            l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
 
 
#     CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
#     LET l_abb25_d = t_debit / t_debitf
#     LET l_abb25_c = t_credit / t_creditf
#     LET l_abb25_bal = n_bal / n_balf
#     IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#     IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
#     IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
#     INSERT INTO gglq705_tmp
#     VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'4',
#            l_date2,'',g_msg,sr.abb24,'',0,0,
#            t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
#            l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#  LET l_flag2='Y'
#  LET l_flag1='N' 
#END REPORT
##TQC-930163  --end
##No.FUN-8B0106 mark end
 
FUNCTION q705_bp(p_ud)
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
         CALL gglq705_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL gglq705_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL gglq705_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL gglq705_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL gglq705_fetch('L')
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
 
FUNCTION q705_out_1()
 
   LET g_prog = 'gglq705'
   LET g_sql = " aag01.aag_file.aag01,",
               " aag02.aag_file.aag02,",
               " tao02.tao_file.tao02,",
               " gem02.gem_file.gem02,",
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
 
   LET l_table = cl_prt_temptable('gglq705',g_sql) CLIPPED
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
 
FUNCTION q705_out_2()
   DEFINE l_name             LIKE type_file.chr20
   DEFINE l_aag01            LIKE aag_file.aag01
   DEFINE l_tao02            LIKE tao_file.tao02
 
   LET g_prog = 'gglq705'
 
   CALL cl_del_data(l_table)
 
   LET l_aag01 = NULL
   LET l_tao02 = NULL
   #IF tm.d <> 'Y' THEN  #No.TQC-930163    #FUN-C80102  mark
   IF tm.e <> 'Y' THEN                     #FUN-C80102  add
      DECLARE gglq705_tmp_curs CURSOR FOR
       SELECT * FROM gglq705_tmp
        ORDER BY aag01,tao02,aba04,aba02,aba01
      FOREACH gglq705_tmp_curs INTO g_pr.*
         #查詢和打印時不太一樣，打印時,僅打印一個期初余額
         IF l_aag01 <> g_pr.aag01 OR l_tao02 <> g_pr.tao02 THEN
            LET l_aag01 = NULL
            LET l_tao02 = NULL
         END IF
         IF g_pr.type = '1' THEN
            IF l_aag01 IS NULL AND l_tao02 IS NULL THEN
               LET l_aag01 = g_pr.aag01
               LET l_tao02 = g_pr.tao02
            ELSE
               CONTINUE FOREACH
            END IF
         END IF
         EXECUTE insert_prep USING g_pr.*
      END FOREACH
   ELSE 
      DECLARE gglq705_tmp_curs1 CURSOR FOR
       SELECT * FROM gglq705_tmp
        ORDER BY aag01,tao02,abb24,aba04,aba02,aba01
      FOREACH gglq705_tmp_curs1 INTO g_pr.*
         EXECUTE insert_prep USING g_pr.*
      END FOREACH
   END IF #No.TQC-930163
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
 
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'aag01')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",yy,";",g_azi04
   IF tm.b = 'N' THEN
       LET l_name = 'gglq705'
   ELSE
       #IF tm.d = 'Y' THEN          #No.TQC-930163    #FUN-C80102  mark
       IF tm.e = 'Y' THEN          #FUN-C80102  add
          LET l_name = 'gglq705_2' #No.TQC-930163  
       ELSE                        #No.TQC-930163        
          LET l_name = 'gglq705_1'
       END IF    #No.TQC-930163
   END IF
   CALL cl_prt_cs3('gglq705',l_name,g_sql,g_str)
 
END FUNCTION
 
FUNCTION gglq705_table()
     DROP TABLE gglq705_tao_tmp;
     CREATE TEMP TABLE gglq705_tao_tmp(
                    aag01       LIKE aag_file.aag01,
#                   aag02       LIKE aag_file.aag02,
                    aag02       LIKE type_file.chr1000,      #No.MOD-940388
                    tao02       LIKE tao_file.tao02,
                    gem02       LIKE gem_file.gem02,
                    tao09       LIKE tao_file.tao09); #TQC-930163 
 
     DROP TABLE gglq705_tmp;
     CREATE TEMP TABLE gglq705_tmp(
                    aag01       LIKE aag_file.aag01,
#                   aag02       LIKE aag_file.aag02,
                    aag02       LIKE type_file.chr1000,      #No.MOD-940388
                    tao02       LIKE tao_file.tao02,
                    gem02       LIKE gem_file.gem02, 
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
                    azi07       LIKE azi_file.azi07);
END FUNCTION
 
FUNCTION gglq705_t()
   IF tm.b = 'Y' THEN
      #TQC-930163  --begin
      #IF tm.d = 'Y' THEN     #FUN-C80102  mark
      IF tm.e = 'Y' THEN      #FUN-C80102  add
         CALL cl_set_comp_visible("tao09",TRUE)
      ELSE
         CALL cl_set_comp_visible("tao09",FALSE)
      END IF
      #TQC-930163  --end
      #CALL cl_set_comp_visible("abb24,df,d,cf,c,balf,bal",TRUE)  #FUN-C80102 mark
      CALL cl_set_comp_visible("df,d,cf,c,balf,bal",TRUE)         #FUN-C80102 add
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
   ELSE
      #CALL cl_set_comp_visible("tao09,abb24,abb25,df,cf,balf",FALSE) #TQC-930163  #FUN-C80102 mark
      CALL cl_set_comp_visible("tao09,abb25,df,cf,balf",FALSE)    #FUN-C80102 add
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
   LET g_tao02 = NULL
   LET g_gem02 = NULL
   CLEAR FORM
   CALL g_abb.clear()
   CALL gglq705_cs()
 
END FUNCTION
 
FUNCTION q705_drill_down()  
   DEFINE 
          #l_wc    LIKE type_file.chr50
         l_wc         STRING       #NO.FUN-910082
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
 
   #IF cl_null(g_aag01) THEN RETURN END IF           #FUN-C80102 mark
   IF cl_null(g_abb[l_ac].aag01) THEN RETURN END IF  #FUN-C80102 add
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_abb[l_ac].aba01) THEN RETURN END IF
   LET g_msg = "aglt110 '",g_abb[l_ac].aba01,"'"
   CALL cl_cmdrun(g_msg)
 
END FUNCTION
 
FUNCTION gglq705_curs()
  DEFINE #l_sql   LIKE type_file.chr1000
         l_sql   STRING      #NO.FUN-910082
  DEFINE #l_sql1  LIKE type_file.chr1000
         l_sql1   STRING      #NO.FUN-910082
  DEFINE 
          #l_wc2   LIKE type_file.chr1000
          l_wc2         STRING       #NO.FUN-910082
 
     LET mm1 = MONTH(bdate)
     LET nn1 = MONTH(edate)
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')  #No.TQC-A50151
     #End:FUN-980030
 
     #查找科目
     IF cl_null(tm.aag24) THEN   #TQC-CC0122 add
        LET l_sql1= "SELECT aag01,aag02 FROM aag_file ",
                    " WHERE aag03 ='2' ",
                    "   AND aag00 = '",bookno,"' ",
#                   "   AND aag24 <> 1 ",           #一級統治不要出來,BY蔡曉峰規定 #No.FUN-A40020
                    "   AND NOT (aag24 = 1 AND aag07 = '1') ", #No.FUN-A40020
                    "   AND ",tm.wc1 CLIPPED
     #TQC-CC0122--add--str--
     ELSE
        LET l_sql1= "SELECT aag01,aag02 FROM aag_file ",
                    " WHERE aag03 ='2' ",
                    "   AND aag00 = '",bookno,"' ",
#                   "   AND aag24 <> 1 ",           #一級統治不要出來,BY蔡曉峰規定 #No.FUN-A40020
                    "   AND NOT (aag24 = 1 AND aag07 = '1') ", #No.FUN-A40020
                    "   AND aag24 = '",tm.aag24,"'", 
                    "   AND ",tm.wc1 CLIPPED
     END IF
     #TQC-CC0122--add--end--
     #TQC-CC0122--add--str--
     IF tm.aag09 = 'Y' THEN
          LET l_sql1 = l_sql1 CLIPPED,
                    "  AND aag09 = 'Y' "
     END IF

     IF tm.aag38 = 'N' THEN
          LET l_sql1 = l_sql1 CLIPPED,
                    "  AND aag38 = 'N' "
     END IF
     #TQC-CC0122--add--end--
     PREPARE gglq705_aag01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglq705_aag01_cs CURSOR FOR gglq705_aag01_p
 
     #查找核算項
     LET l_sql1 = "SELECT UNIQUE tao02 FROM tao_file ",
                  " WHERE tao00 = '",bookno,"'",
        #         "   AND tao01 = ?",           #account #
                  "   AND tao01 LIKE ?",           #account
                  "   AND tao02 IS NOT NULL ",
                  "   AND ",tm.wc2 CLIPPED
     PREPARE gglq705_tao02_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_tao02_cs1 CURSOR FOR gglq705_tao02_p1
 
     LET l_wc2 = tm.wc2
     LET l_wc2 = cl_replace_str(l_wc2,"tao02","abb05")

     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.g = 'Y' THEN 
     #   LET l_sql1 = " SELECT UNIQUE abb05 FROM aba_file,abb_file",
     #                "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                "    AND aba00 = '",bookno,"'",
     #                "    AND abb03 LIKE ? ",       #account
     #                "    AND abb05 IS NOT NULL",
     #                "    AND ",l_wc2
     #END IF 
     #IF tm.g = 'N' THEN
     #   IF tm.a ='1' THEN 
     #      LET l_sql1 = " SELECT UNIQUE abb05 FROM aba_file,abb_file",
     #             "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #             "    AND aba00 = '",bookno,"'",
     #             "    AND abb03 LIKE ? ",       #account
     #             "    AND abb05 IS NOT NULL",
     #             "    AND aba19 = 'Y'   ",
     #             "    AND ",l_wc2
     #   ELSE
    #FUN-C80102--add--end--
     #      LET l_sql1 = " SELECT UNIQUE abb05 FROM aba_file,abb_file",
     #                   "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                   "    AND aba00 = '",bookno,"'",
     #                   "    AND abb03 LIKE ? ",       #account
     #                   "    AND abb05 IS NOT NULL",
     #                   #"    AND aba19 = 'Y'   AND abapost = 'N'",   #FUN-C80102 mark
     #                   "    AND aba19 = 'Y'   AND abapost = 'Y'",    #FUN-C80102 add
     #                   "    AND ",l_wc2
     #   END IF   #FUN-C80102 add
     #END IF      #FUN-C80102 add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql1 = " SELECT UNIQUE abb05 FROM aba_file,abb_file",
                     "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                     "    AND aba00 = '",bookno,"'",
                     "    AND abb03 LIKE ? ",       #account
                     "    AND abb05 IS NOT NULL",
                     "    AND ",l_wc2
     IF tm.g = 'Y' THEN 
        IF tm.a = '1' THEN 
           LET l_sql1 = l_sql1 , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql1 = l_sql1, "  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.g = 'N' THEN
        IF tm.a = '1' THEN
           LET l_sql1 = l_sql1, " AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql1 =  " AND  aba19 = 1 "
        END IF
     END IF 
     #FUN-C80102--add--end--
     
     PREPARE gglq705_tao02_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_tao02_cs2 CURSOR FOR gglq705_tao02_p2
 
     #期初余額
     #1~mm-1
     LET l_sql = "SELECT SUM(tao05),SUM(tao06),SUM(tao10),SUM(tao11) FROM tao_file,aag_file ",   #No.MOD-B10170
                 " WHERE tao00 = '",bookno,"'",
                #"   AND tao01 = ? ",                  #科目
                 "   AND tao01 LIKE ? ",                  #科目
                 "   AND tao02 = ? ",                  #核算項
#No.MOD-B10170 --begin  
                 "   AND tao01 = aag01 ",  
                 "   AND aag00 = '",bookno,"'",      
                 "   AND aag07 <> '1' ",    
#No.MOD-B10170 --end 
                 "   AND tao03 = ",yy,
                 "   AND tao04 < ",mm                  #期初
     PREPARE gglq705_qc1_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qc1_cs CURSOR FOR gglq705_qc1_p
     #mm(1~bdate-1)

     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.g = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND abb05 = ? ",                    #核算項值
     #               "    AND abb06 = ? ",
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 = ",mm,
     #               "    AND aba02 < '",bdate,"'"
     #END IF 
     #IF tm.g = 'N' THEN 
     #   IF tm.a = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #            "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #            "    AND aba00 = '",bookno,"'",
     #            "    AND abb03 LIKE ?   ",               #科目
     #            "    AND abb05 = ? ",                    #核算項值
     #            "    AND abb06 = ? ",
     #            "    AND aba03 = ",yy,
     #            "    AND aba04 = ",mm,
     #            "    AND aba02 < '",bdate,"'",
     #            "    AND aba19 = 'Y' AND abapost = 'Y'"  #過帳
     #   ELSE 
    #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #核算項值
     #                  "    AND abb06 = ? ",
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND aba02 < '",bdate,"'",
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'"  #過帳
     #   END IF    #FUN-C80102  add
     #END IF       #FUN-C80102  add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND abb05 = ? ",                    #核算項值
                 "    AND abb06 = ? ",
                 "    AND aba03 = ",yy,
                 "    AND aba04 = ",mm,
                 "    AND aba02 < '",bdate,"'"
     IF tm.g = 'Y' THEN 
        IF tm.a = '1' THEN 
           LET l_sql = l_sql , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql, "  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.g = 'N' THEN
        IF tm.a = '1' THEN
           LET l_sql = l_sql, " AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql =  " AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq705_qc2_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qc2_cs CURSOR FOR gglq705_qc2_p
 
     #tm.c = 'Y'
     #1~mm-1
     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.g = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND abb05 = ? ",                    #核算項值
     #               "    AND abb06 = ? ",
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 < ",mm
     #END IF 
     #IF tm.g = 'N' THEN 
     #   IF tm.a = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #核算項值
     #                  "    AND abb06 = ? ",
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 < ",mm,
     #                  "    AND aba19 = 'Y' "  #期初未過帳
     #   ELSE 
     # #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #核算項值
     #                  "    AND abb06 = ? ",
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 < ",mm,
     #                  #"    AND aba19 = 'Y' AND abapost = 'N'"  #期初未過帳   #FUN-C80102 mark
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'"               #FUN-C80102 add
     #   END IF    #FUN-C80102 add
     #END IF       #FUN-C80102 add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND abb05 = ? ",                    #核算項值
                 "    AND abb06 = ? ",
                 "    AND aba03 = ",yy,
                 "    AND aba04 < ",mm
     IF tm.g = 'Y' THEN 
        IF tm.a = '1' THEN 
           LET l_sql = l_sql , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql, "  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.g = 'N' THEN
        IF tm.a = '1' THEN
           LET l_sql = l_sql, " AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql =  " AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglq705_qc3_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qc3_cs CURSOR FOR gglq705_qc3_p
     #mm(1~bdate-1)
     #FUN-C80102--mark--str--
     #FUN-C80102--add--str--
     #IF tm.g = 'Y' THEN 
     #   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND abb05 = ? ",                    #核算項值
     #               "    AND aba03 = ",yy,
     #               "    AND aba04 = ",mm,
     #               "    AND abb06 = ? ",
     #               "    AND aba02 < '",bdate,"'"
     #END IF 
     #IF tm.g = 'N' THEN 
     #   IF tm.a = '1' THEN 
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #核算項值
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND abb06 = ? ",
     #                  "    AND aba02 < '",bdate,"'",
     #                  "    AND aba19 = 'Y' " 
     #   ELSE 
     #FUN-C80102--add--end--
     #      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
     #                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #                  "    AND aba00 = '",bookno,"'",
     #                  "    AND abb03 LIKE ?   ",               #科目
     #                  "    AND abb05 = ? ",                    #核算項值
     #                  "    AND aba03 = ",yy,
     #                  "    AND aba04 = ",mm,
     #                  "    AND abb06 = ? ",
     #                  "    AND aba02 < '",bdate,"'",
     #                  #"    AND aba19 = 'Y' AND abapost = 'N'" #期初未過帳  #FUN-C80102 mark
     #                  "    AND aba19 = 'Y' AND abapost = 'Y'"    #FUN-C80102 add
     #   END IF   #FUN-C80102 add
     # END IF     #FUN-C80102 add
     #FUN-C80102--mark--end--

     #FUN-C80102--add--str--
      LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                  "    AND aba00 = '",bookno,"'",
                  "    AND abb03 LIKE ?   ",               #科目
                  "    AND abb05 = ? ",                    #核算項值
                  "    AND aba03 = ",yy,
                  "    AND aba04 = ",mm,
                  "    AND abb06 = ? ",
                  "    AND aba02 < '",bdate,"'"
      IF tm.g = 'Y' THEN 
        IF tm.a = '1' THEN 
           LET l_sql = l_sql , "  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql, "  AND aba19 = 'N'"
        END IF 
     END IF 
     IF tm.g = 'N' THEN
        IF tm.a = '1' THEN
           LET l_sql = l_sql, " AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql =  " AND  aba19 = 1 "
        END IF
     END IF
      #FUN-C80102--add--end--
      
     PREPARE gglq705_qc4_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qc4_cs CURSOR FOR gglq705_qc4_p
 
     #當期異動
     #FUN-C80102--add--str--
     #IF tm.g = 'Y' THEN     #FUN-C80102  mark
        LET l_sql = " SELECT '','','','',0,aba02,aba01,abb04,",
                    "        abb06,abb07,abb07f,abb24,abb25, ",
                    "        0,0,0,0,0,0,0,0,0,0             ",
                    "   FROM aba_file a,abb_file ",                      #FUN-D40044 add a
                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    "    AND aba00 = '",bookno,"'",
                    "    AND abb03 LIKE ?   ",               #科目
                    "    AND abb05 = ? ",                    #核算項值
                    "    AND aba03 = ",yy,
                    "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
                    #"    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN ",         #CHI-C70031  #FUN-D40044 mark
                    #"        (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))", #CHI-C70031  #FUN-D40044 mark
                    "    AND aba04 = ? "
                    #" ORDER BY aba02"   #FUN-C80102  mark
                    
     #FUN-D40044--add--str--
     IF tm.h = 'N' THEN 
        LET l_sql = l_sql CLIPPED," AND NOT EXISTS (",
            " SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01 ",
            "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))"
     END IF
     #FUN-D40044--add--end--
     
     #END IF    #FUN-C80102  mark
     #FUN-C80102--mark--str--
     #IF tm.g = 'N' THEN 
     #   LET l_sql = " SELECT '','','','',0,aba02,aba01,abb04,",
     #               "        abb06,abb07,abb07f,abb24,abb25, ",
     #               "        0,0,0,0,0,0,0,0,0,0             ",
     #               "   FROM aba_file,abb_file ",
     #               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
     #               "    AND aba00 = '",bookno,"'",
     #               "    AND abb03 LIKE ?   ",               #科目
     #               "    AND abb05 = ? ",                    #核算項值
     #               "    AND aba03 = ",yy,
     #               "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
     #               "    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN ",         #CHI-C70031
     #               "        (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))", #CHI-C70031
     #               "    AND aba04 = ? ",
     #               "    AND aba19 = 'Y' "
     #   #IF tm.c = 'N' THEN   #FUN-C80102  mark
     #   IF tm.a = '2' THEN    #FUN-C80102  add
     #      LET l_sql = l_sql CLIPPED," AND abapost = 'Y' ORDER BY aba02"   #筁眀    #FUN-A40011 add order by
#FUN-A40011 --begin--        
     #   ELSE
     #	  LET l_sql = l_sql CLIPPED," ORDER BY aba02"         
#FUN-A40011 --end--     	          
     #   END IF
    #END IF    #FUN-C80102  add
    #FUN-C80102--mark--end--

    #FUN-C80102--add--str--
     IF tm.g ='Y' THEN 
        IF tm.a = '1' THEN
           LET l_sql = l_sql," AND (aba19 = 'N' or aba19 ='Y')",
                        " ORDER BY aba02 " 
        ELSE
           LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))",
                        " ORDER BY aba02 " 
        END IF
     END IF
     IF tm.g ='N' THEN
        IF tm.a = '1' THEN
           LET l_sql = l_sql," AND  aba19 ='Y'", 
                        " ORDER BY aba02 " 
        ELSE
           LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'",
                        " ORDER BY aba02 " 
        END IF
     END IF
     #FUN-C80102--add--end--
 
     PREPARE gglq705_qj1_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq705_qj1_cs CURSOR FOR gglq705_qj1_p
 
END FUNCTION
 
FUNCTION gglq705()
   DEFINE l_name               LIKE type_file.chr20,
          #l_sql,l_sql1         LIKE type_file.chr1000,
          l_sql,l_sql1         STRING ,     #NO.FUN-910082
          l_date,l_date1       LIKE aba_file.aba02,
          l_i                  LIKE type_file.num5,
          qc_tao05             LIKE tao_file.tao05,
          qc_tao06             LIKE tao_file.tao06,
          qc_tao10             LIKE tao_file.tao10,
          qc_tao11             LIKE tao_file.tao11,
          qc1_tao05            LIKE tao_file.tao05,
          qc1_tao06            LIKE tao_file.tao06,
          qc1_tao10            LIKE tao_file.tao10,
          qc1_tao11            LIKE tao_file.tao11,
          qc2_tao05            LIKE tao_file.tao05,
          qc2_tao06            LIKE tao_file.tao06,
          qc2_tao10            LIKE tao_file.tao10,
          qc2_tao11            LIKE tao_file.tao11,
          qc3_tao05            LIKE tao_file.tao05,
          qc3_tao06            LIKE tao_file.tao06,
          qc3_tao10            LIKE tao_file.tao10,
          qc3_tao11            LIKE tao_file.tao11,
          qc4_tao05            LIKE tao_file.tao05,
          qc4_tao06            LIKE tao_file.tao06,
          qc4_tao10            LIKE tao_file.tao10,
          qc4_tao11            LIKE tao_file.tao11,
          l_qcye               LIKE abb_file.abb07,
          l_qcyef              LIKE abb_file.abb07,
          t_qcye               LIKE abb_file.abb07,
          t_qcyef              LIKE abb_file.abb07,
          l_tao02              LIKE tao_file.tao02,
          l_gem02              LIKE gem_file.gem02,
          l_aag01_str          LIKE type_file.chr50,
#FUN-8B0106 ADD START            
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
#FUN-8B0106 ADD END
          l_flag3                      LIKE type_file.chr1,          #TQC-970049
          l_flag4                      LIKE type_file.chr1,          #TQC-970310           
          sr1                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02
                               END RECORD,
          sr2                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               tao02    LIKE tao_file.tao02,
                               gem02    LIKE gem_file.gem02
                               END RECORD,
          sr                   RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               tao02    LIKE tao_file.tao02,
                               gem02    LIKE gem_file.gem02,
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
DEFINE  l_chr                  LIKE type_file.chr1     #FUN-A40011 
 
     CALL gglq705_table()
     LET l_flag3 = 'N'                      #TQC-970049
 
     CALL gglq705_curs()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
     FOREACH gglq705_aag01_cs INTO sr1.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach gglq705_aag01_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr1.aag01 CLIPPED,'\%'    #No.MOD-940388
       #FOREACH gglq705_tao02_cs1 USING sr1.aag01
        FOREACH gglq705_tao02_cs1 USING l_aag01_str
                                  INTO l_tao02
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq705_tao02_cs1',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(l_tao02) THEN CONTINUE FOREACH END IF
           LET l_gem02 = NULL
           SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_tao02
           INSERT INTO gglq705_tao_tmp VALUES(sr1.aag01,sr1.aag02,l_tao02,l_gem02,'') #TQC-930163 
           IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN
              CALL cl_err3('ins','gglq705_tao_tmp',sr1.aag01,l_tao02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
 
        FOREACH gglq705_tao02_cs2 USING l_aag01_str
                                  INTO l_tao02
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq705_tao02_cs2',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(l_tao02) THEN CONTINUE FOREACH END IF
           LET l_gem02 = NULL
           SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_tao02
           INSERT INTO gglq705_tao_tmp VALUES(sr1.aag01,sr1.aag02,l_tao02,l_gem02,'') #TQC-930163 
           IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN
              CALL cl_err3('ins','gglq705_tao_tmp',sr1.aag01,l_tao02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
     END FOREACH
 
     LET g_prog = 'gglr301'
     #CALL cl_outnam('gglr301') RETURNING l_name  #FUN-8B0106 mark
     #START REPORT gglq705_rep TO l_name          #FUN-8B0106 mark
     LET g_pageno = 0
 
     DECLARE gglq705_cs1 CURSOR FOR
      SELECT UNIQUE aag01,aag02,tao02,gem02 FROM gglq705_tao_tmp
       ORDER BY aag01,tao02
 
     FOREACH gglq705_cs1 INTO sr2.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach gglq705_cs1',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr2.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr2.aag01 CLIPPED,'\%'    #No.MOD-940388
 
        #期初
        LET qc1_tao05 = 0  LET qc1_tao06 = 0
        LET qc1_tao10 = 0  LET qc1_tao11 = 0
        LET qc2_tao05 = 0  LET qc2_tao06 = 0
        LET qc2_tao10 = 0  LET qc2_tao11 = 0
        LET qc3_tao05 = 0  LET qc3_tao06 = 0
        LET qc3_tao10 = 0  LET qc3_tao11 = 0
        LET qc4_tao05 = 0  LET qc4_tao06 = 0
        LET qc4_tao10 = 0  LET qc4_tao11 = 0
        #1~mm-1
       #OPEN gglq705_qc1_cs USING sr2.aag01,sr2.tao02
        OPEN gglq705_qc1_cs USING l_aag01_str,sr2.tao02
        FETCH gglq705_qc1_cs INTO qc1_tao05,qc1_tao06,qc1_tao10,qc1_tao11
        CLOSE gglq705_qc1_cs
        IF cl_null(qc1_tao05) THEN LET qc1_tao05 = 0 END IF
        IF cl_null(qc1_tao06) THEN LET qc1_tao06 = 0 END IF
        IF cl_null(qc1_tao10) THEN LET qc1_tao10 = 0 END IF
        IF cl_null(qc1_tao11) THEN LET qc1_tao11 = 0 END IF
        #mm(day 1~<bdate)
        OPEN gglq705_qc2_cs USING l_aag01_str,sr2.tao02,'1'
        FETCH gglq705_qc2_cs INTO qc2_tao05,qc2_tao10
        CLOSE gglq705_qc2_cs
        OPEN gglq705_qc2_cs USING l_aag01_str,sr2.tao02,'2'
        FETCH gglq705_qc2_cs INTO qc2_tao06,qc2_tao11
        CLOSE gglq705_qc2_cs
        IF cl_null(qc2_tao05) THEN LET qc2_tao05 = 0 END IF
        IF cl_null(qc2_tao06) THEN LET qc2_tao06 = 0 END IF
        IF cl_null(qc2_tao10) THEN LET qc2_tao10 = 0 END IF
        IF cl_null(qc2_tao11) THEN LET qc2_tao11 = 0 END IF
 
        #IF tm.c = 'Y' THEN   #FUN-C80102  mark
           #1~mm-1
           OPEN gglq705_qc3_cs USING l_aag01_str,sr2.tao02,'1'
           FETCH gglq705_qc3_cs INTO qc3_tao05,qc3_tao10
           CLOSE gglq705_qc3_cs
           OPEN gglq705_qc3_cs USING l_aag01_str,sr2.tao02,'2'
           FETCH gglq705_qc3_cs INTO qc3_tao06,qc3_tao11
           CLOSE gglq705_qc3_cs
           IF cl_null(qc3_tao05) THEN LET qc3_tao05 = 0 END IF
           IF cl_null(qc3_tao06) THEN LET qc3_tao06 = 0 END IF
           IF cl_null(qc3_tao10) THEN LET qc3_tao10 = 0 END IF
           IF cl_null(qc3_tao11) THEN LET qc3_tao11 = 0 END IF
           #mm(1~bdate-1)
           OPEN gglq705_qc4_cs USING l_aag01_str,sr2.tao02,'1'
           FETCH gglq705_qc4_cs INTO qc4_tao05,qc4_tao10
           CLOSE gglq705_qc4_cs
           OPEN gglq705_qc4_cs USING l_aag01_str,sr2.tao02,'2'
           FETCH gglq705_qc4_cs INTO qc4_tao06,qc4_tao11
           CLOSE gglq705_qc4_cs
           IF cl_null(qc4_tao05) THEN LET qc4_tao05 = 0 END IF
           IF cl_null(qc4_tao06) THEN LET qc4_tao06 = 0 END IF
           IF cl_null(qc4_tao10) THEN LET qc4_tao10 = 0 END IF
           IF cl_null(qc4_tao11) THEN LET qc4_tao11 = 0 END IF
        #END IF   #FUN-C80102  add
        LET qc_tao05 = qc1_tao05 + qc2_tao05 + qc3_tao05 + qc4_tao05
        LET qc_tao06 = qc1_tao06 + qc2_tao06 + qc3_tao06 + qc4_tao06
        LET qc_tao10 = qc1_tao10 + qc2_tao10 + qc3_tao10 + qc4_tao10
        LET qc_tao11 = qc1_tao11 + qc2_tao11 + qc3_tao11 + qc4_tao11
 
        LET l_qcye  = qc_tao05 - qc_tao06
        LET l_qcyef = qc_tao10 - qc_tao11
        #若t_qcye = 0 & 異間異動為零，則不打印
        LET t_qcye  = l_qcye
        LET t_qcyef = l_qcyef
        LET l_flag4 = 'N'                       #TQC-970310

        LET l_chr   = 'Y'   #FUN-A40011       
        FOR l_i = mm1 TO nn1
            LET l_flag='N'
            FOREACH gglq705_qj1_cs USING l_aag01_str,sr2.tao02,l_i INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET l_flag='Y'
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.tao02   = sr2.tao02
               LET sr.gem02   = sr2.gem02  
               LET sr.aba04   = l_i
               LET sr.qcye    = l_qcye
               LET sr.qcyef   = l_qcyef
 
               LET sr.qc_md   = qc2_tao05 + qc4_tao05
               LET sr.qc_mdf  = qc2_tao10 + qc4_tao10
               LET sr.qc_mc   = qc2_tao06 + qc4_tao06
               LET sr.qc_mcf  = qc2_tao11 + qc4_tao11
 
               LET sr.qc_yd   = qc1_tao05 + qc3_tao05
               LET sr.qc_ydf  = qc1_tao10 + qc3_tao10
               LET sr.qc_yc   = qc1_tao06 + qc3_tao06
               LET sr.qc_ycf  = qc1_tao11 + qc3_tao11
 
               IF sr.abb06 = '1' THEN
                  LET t_qcye  = t_qcye + sr.abb07
                  LET t_qcyef = t_qcyef+ sr.abb07
               ELSE
                  LET t_qcye  = t_qcye - sr.abb07
                  LET t_qcyef = t_qcyef- sr.abb07
               END IF
 
               #OUTPUT TO REPORT gglq705_rep(sr.*) #FUN-8B0106 mark
#No.FUN-8B0106 ADD START
      IF l_flag4 = 'N' THEN                                     #TQC-970310 add    
         LET t_bal     = sr.qcye
         LET t_balf    = sr.qcyef
         LET t_debit   = sr.qc_yd  + sr.qc_md
         LET t_debitf  = sr.qc_ydf + sr.qc_mdf
         LET t_credit  = sr.qc_yc  + sr.qc_mc
         LET t_creditf = sr.qc_ycf + sr.qc_mcf
         LET l_flag4 = 'Y'                                      #TQC-970310 add
      END IF                                                    #TQC-970310 add      
#TQC-970049--Add--Begin--#
      IF l_flag3 = 'N' THEN
      IF sr.aba04 = MONTH(bdate) THEN
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
     #LET l_abb25_bal = n_balf / n_bal #TQC-930163 
      LET l_abb25_bal = n_bal / n_balf #TQC-930163 
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF l_chr = 'Y' THEN    #FUN-A40011      
         INSERT INTO gglq705_tmp
         VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'1',
             t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF                #FUN-A40011
      LET l_chr = 'N'       #FUN-A40011 
                   
      LET l_flag3 = 'Y'
      END IF             
#TQC-970049--Add--End--#      
      
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
 
 
        #TQC-930163 --begin
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
        # LET l_abb25_d = l_df / l_d
        # LET l_abb25_c = l_cf / l_c
        # LET l_abb25_bal = n_balf / n_bal
        #TQC-930163 --end
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq705_tmp
         VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF
#No.FUN-8B0106 ADD END               
            END FOREACH
            IF l_flag = "N" THEN
               #TQC-930163  --begin
               IF t_qcye = 0 AND t_qcyef = 0 
                  AND qc_tao05 = 0 AND qc_tao06 = 0 THEN
                  CONTINUE FOR
               END IF
               #TQC-930163  --end
               INITIALIZE sr.* TO NULL
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.tao02   = sr2.tao02
               LET sr.gem02   = sr2.gem02  
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
 
               LET sr.qc_md   = qc2_tao05 + qc4_tao05
               LET sr.qc_mdf  = qc2_tao10 + qc4_tao10
               LET sr.qc_mc   = qc2_tao06 + qc4_tao06
               LET sr.qc_mcf  = qc2_tao11 + qc4_tao11
 
               LET sr.qc_yd   = qc1_tao05 + qc3_tao05
               LET sr.qc_ydf  = qc1_tao10 + qc3_tao10
               LET sr.qc_yc   = qc1_tao06 + qc3_tao06
               LET sr.qc_ycf  = qc1_tao11 + qc3_tao11
               #OUTPUT TO REPORT gglq705_rep(sr.*) #FUN-8B0106 mark
#No.FUN-8B0106 ADD START
      IF l_flag4 = 'N' THEN                                     #TQC-970310 add    
         LET t_bal     = sr.qcye
         LET t_balf    = sr.qcyef
         LET t_debit   = sr.qc_yd  + sr.qc_md
         LET t_debitf  = sr.qc_ydf + sr.qc_mdf
         LET t_credit  = sr.qc_yc  + sr.qc_mc
         LET t_creditf = sr.qc_ycf + sr.qc_mcf
         LET l_flag4 = 'Y'                                      #TQC-970310 add
      END IF                                                    #TQC-970310 add     
#TQC-970049--Add--Begin--#
      IF l_flag3 = 'N' THEN
      IF sr.aba04 = MONTH(bdate) THEN
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
     #LET l_abb25_bal = n_balf / n_bal #TQC-930163 
      LET l_abb25_bal = n_bal / n_balf #TQC-930163 
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF l_chr = 'Y' THEN   #FUN-A40011      
         INSERT INTO gglq705_tmp
         VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'1',
             t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF               #FUN-A40011
      LET l_chr = 'N'      #FUN-A40011        
      LET l_flag3 = 'Y'
      END IF             
#TQC-970049--Add--End--#      
      
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
 
 
        #TQC-930163 --begin
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
        # LET l_abb25_d = l_df / l_d
        # LET l_abb25_c = l_cf / l_c
        # LET l_abb25_bal = n_balf / n_bal
        #TQC-930163 --end
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq705_tmp
         VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF
#No.FUN-8B0106 ADD END               
            END IF
#No.FUN-8B0106 ADD START
#TQC-970049--Mark--Begin--#
#     IF sr.aba04 = MONTH(bdate) THEN
#        LET t_date2 = bdate
#     ELSE
#        LET t_date2 = MDY(sr.aba04,1,yy)
#     END IF
 
#     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#      WHERE azi01 = sr.abb24
 
#     IF t_bal > 0 THEN
#        LET n_bal = t_bal
#        LET n_balf= t_balf
#        CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#     ELSE
#        IF t_bal = 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#        ELSE
#           LET n_bal = t_bal * -1
#           LET n_balf= t_balf* -1
#           CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#        END IF
#     END IF
 
#     CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
#    #LET l_abb25_bal = n_balf / n_bal #TQC-930163 
#     LET l_abb25_bal = n_bal / n_balf #TQC-930163 
#     IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#     INSERT INTO gglq705_tmp
#     VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'1',
#            t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
#            l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#TQC-970049--Mark--End--#
             
      CALL s_yp(edate) RETURNING l_year,l_month
      IF sr.aba04 = l_month THEN
         LET t_date2 = edate
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
        FROM gglq705_tmp 
       WHERE abb06 = '1'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND tao02 = sr.tao02
         AND aag01 = sr.aag01                                       #FUN-A40011              
      SELECT SUM(abb07f) INTO l_df
        FROM gglq705_tmp 
       WHERE abb06 = '1'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND tao02 = sr.tao02 
         AND aag01 = sr.aag01                                       #FUN-A40011              
      SELECT SUM(abb07) INTO l_c
        FROM gglq705_tmp 
       WHERE abb06 = '2'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND tao02 = sr.tao02 
         AND aag01 = sr.aag01                                       #FUN-A40011              
      SELECT SUM(abb07f) INTO l_cf
        FROM gglq705_tmp 
       WHERE abb06 = '2'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND tao02 = sr.tao02         
         AND aag01 = sr.aag01                                       #FUN-A40011     
               
      #LET l_d = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
      #LET l_df= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
      #LET l_c = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
      #LET l_cf= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
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
      #TQC-930163 --begin
     # LET l_abb25_d = l_df / l_d
     # LET l_abb25_c = l_cf / l_c
     # LET l_abb25_bal = n_balf / n_bal
      LET l_abb25_d = l_d / l_df
      LET l_abb25_c = l_c / l_cf
      LET l_abb25_bal = n_bal / n_balf
      #TQC-930163 --end
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF cl_null(l_abb25_d)   THEN LET l_abb25_d   = 0 END IF
      IF cl_null(l_abb25_c)   THEN LET l_abb25_c   = 0 END IF
      INSERT INTO gglq705_tmp
      VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'3',
             t_date2,'',g_msg,sr.abb24,'',0,0,
             l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
 
 
      CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
      #TQC-930163 --begin
      #LET l_abb25_d = t_debitf / t_debit
      #LET l_abb25_c = t_creditf / t_credit
      #LET l_abb25_bal = n_balf / n_bal
      LET l_abb25_d = t_debit / t_debitf
      LET l_abb25_c = t_credit / t_creditf
      LET l_abb25_bal = n_bal / n_balf
      #TQC-930163 --end
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
      IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
      INSERT INTO gglq705_tmp
      VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'4',
             t_date2,'',g_msg,sr.abb24,'',0,0,
             t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)             
              
#No.FUN-8B0106 ADD END
      LET l_flag3 = 'N'                       #TQC-970049              
        END FOR
     END FOREACH
 
     #FINISH REPORT gglq705_rep   #No.FUN-8B0106 MARK  
 
END FUNCTION

#FUN-C80102--add--str--
#獲取當期的第一天和最後一天
FUNCTION q705_getday()
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
 
#No.FUN-8B0106 mark start 
#REPORT gglq705_rep(sr)
#  DEFINE
#         sr                   RECORD
#                              aag01    LIKE aag_file.aag01,
#                              aag02    LIKE aag_file.aag02,
#                              tao02    LIKE tao_file.tao02,
#                              gem02    LIKE gem_file.gem02,
#                              aba04    LIKE aba_file.aba04,
#                              aba02    LIKE aba_file.aba02,
#                              aba01    LIKE aba_file.aba01,
#                              abb04    LIKE abb_file.abb04,
#                              abb06    LIKE abb_file.abb06,
#                              abb07    LIKE abb_file.abb07,
#                              abb07f   LIKE abb_file.abb07f,
#                              abb24    LIKE abb_file.abb24,
#                              abb25    LIKE abb_file.abb25,
#                              qcye     LIKE abb_file.abb07,
#                              qcyef    LIKE abb_file.abb07,
#                              qc_md    LIKE abb_file.abb07,
#                              qc_mdf   LIKE abb_file.abb07,
#                              qc_mc    LIKE abb_file.abb07,
#                              qc_mcf   LIKE abb_file.abb07,
#                              qc_yd    LIKE abb_file.abb07,
#                              qc_ydf   LIKE abb_file.abb07,
#                              qc_yc    LIKE abb_file.abb07,
#                              qc_ycf   LIKE abb_file.abb07
#                              END RECORD,
#         t_bal,t_balf                 LIKE abb_file.abb07,
#         t_debit,t_debitf             LIKE abb_file.abb07,
#         t_credit,t_creditf           LIKE abb_file.abb07,
#         l_d,l_df,l_c,l_cf            LIKE abb_file.abb07,
#         n_bal,n_balf                 LIKE abb_file.abb07,
#         l_abb25_c,l_abb25_d,l_abb25_bal LIKE abb_file.abb25,
#         l_date2                      LIKE type_file.dat,
#         l_date1                      LIKE type_file.dat,
#         l_dc                         LIKE type_file.chr10,
#         l_year                       LIKE type_file.num10,
#         l_month                      LIKE type_file.num10
 
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
 
#  ORDER BY sr.aag01,sr.tao02,sr.aba04,sr.aba02,sr.aba01
 
# FORMAT
#  PAGE HEADER
#     LET g_pageno = g_pageno + 1
 
#  BEFORE GROUP OF sr.tao02
#     LET t_bal     = sr.qcye
#     LET t_balf    = sr.qcyef
#     LET t_debit   = sr.qc_yd  + sr.qc_md
#     LET t_debitf  = sr.qc_ydf + sr.qc_mdf
#     LET t_credit  = sr.qc_yc  + sr.qc_mc
#     LET t_creditf = sr.qc_ycf + sr.qc_mcf
 
#  BEFORE GROUP OF sr.aba04
#     IF sr.aba04 = MONTH(bdate) THEN
#        LET l_date2 = bdate
#     ELSE
#        LET l_date2 = MDY(sr.aba04,1,yy)
#     END IF
 
#     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#      WHERE azi01 = sr.abb24
 
#     IF t_bal > 0 THEN
#        LET n_bal = t_bal
#        LET n_balf= t_balf
#        CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#     ELSE
#        IF t_bal = 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#        ELSE
#           LET n_bal = t_bal * -1
#           LET n_balf= t_balf* -1
#           CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#        END IF
#     END IF
 
#     CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
#    #LET l_abb25_bal = n_balf / n_bal #TQC-930163 
#     LET l_abb25_bal = n_bal / n_balf #TQC-930163 
#     IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#     INSERT INTO gglq705_tmp
#     VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'1',
#            l_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
#            l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
 
#  ON EVERY ROW
#     IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
#        SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#         WHERE azi01 = sr.abb24
#        IF cl_null(sr.abb07)  THEN LET sr.abb07  = 0 END IF
#        IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
#        IF sr.abb06 = 1 THEN
#           LET t_bal   = t_bal   + sr.abb07
#           LET t_balf  = t_balf  + sr.abb07f
#           LET t_debit = t_debit + sr.abb07
#           LET t_debitf= t_debitf+ sr.abb07f
#        ELSE
#           LET t_bal    = t_bal    - sr.abb07
#           LET t_balf   = t_balf   - sr.abb07f
#           LET t_credit = t_credit + sr.abb07
#           LET t_creditf= t_creditf+ sr.abb07f
#        END IF
 
#        IF t_bal > 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#        ELSE
#           IF t_bal = 0 THEN
#              LET n_bal = t_bal
#              LET n_balf= t_balf
#              CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#           ELSE
#              LET n_bal = t_bal * -1
#              LET n_balf= t_balf* -1
#              CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#           END IF
#        END IF
#        IF sr.abb06 = '1' THEN
#           LET l_d  = sr.abb07
#           LET l_df = sr.abb07f
#           LET l_c  = 0
#           LET l_cf = 0
#        ELSE
#           LET l_d  = 0
#           LET l_df = 0
#           LET l_c  = sr.abb07
#           LET l_cf = sr.abb07f
#        END IF
 
 
#       #TQC-930163 --begin
#        LET l_abb25_d = l_d / l_df
#        LET l_abb25_c = l_c / l_cf
#        LET l_abb25_bal = n_bal / n_balf
#       # LET l_abb25_d = l_df / l_d
#       # LET l_abb25_c = l_cf / l_c
#       # LET l_abb25_bal = n_balf / n_bal
#       #TQC-930163 --end
#        IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#        IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
#        IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
#        INSERT INTO gglq705_tmp
#        VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'2',
#               sr.aba02,sr.aba01,sr.abb04,
#               sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
#               l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
#               l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#        PRINT
#     END IF
 
#  AFTER GROUP OF sr.aba04
#     CALL s_yp(edate) RETURNING l_year,l_month
#     IF sr.aba04 = l_month THEN
#        LET l_date2 = edate
#     ELSE
#        CALL s_azn01(yy,sr.aba04) RETURNING l_date1,l_date2
#     END IF
 
#     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#      WHERE azi01 = sr.abb24
 
#     IF t_bal > 0 THEN
#        LET n_bal = t_bal
#        LET n_balf= t_balf
#        CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
#     ELSE
#        IF t_bal = 0 THEN
#           LET n_bal = t_bal
#           LET n_balf= t_balf
#           CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
#        ELSE
#           LET n_bal = t_bal * -1
#           LET n_balf= t_balf* -1
#           CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
#        END IF
#     END IF
 
#     LET l_d = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
#     LET l_df= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
#     LET l_c = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
#     LET l_cf= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
#     IF cl_null(l_d)  THEN LET l_d  = 0 END IF
#     IF cl_null(l_df) THEN LET l_df = 0 END IF
#     IF cl_null(l_c)  THEN LET l_c  = 0 END IF
#     IF cl_null(l_cf) THEN LET l_cf = 0 END IF
#     IF sr.aba04 = mm1 THEN
#        LET l_d  = l_d  + sr.qc_md
#        LET l_df = l_df + sr.qc_mdf
#        LET l_c  = l_c  + sr.qc_mc
#        LET l_cf = l_cf + sr.qc_mcf
#     END IF
#     CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg
#     #TQC-930163 --begin
#    # LET l_abb25_d = l_df / l_d
#    # LET l_abb25_c = l_cf / l_c
#    # LET l_abb25_bal = n_balf / n_bal
#     LET l_abb25_d = l_d / l_df
#     LET l_abb25_c = l_c / l_cf
#     LET l_abb25_bal = n_bal / n_balf
#     #TQC-930163 --end
#     IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#     IF cl_null(l_abb25_d)   THEN LET l_abb25_d   = 0 END IF
#     IF cl_null(l_abb25_c)   THEN LET l_abb25_c   = 0 END IF
#     INSERT INTO gglq705_tmp
#     VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'3',
#            l_date2,'',g_msg,sr.abb24,'',0,0,
#            l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
#            l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
 
 
#     CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
#     #TQC-930163 --begin
#     #LET l_abb25_d = t_debitf / t_debit
#     #LET l_abb25_c = t_creditf / t_credit
#     #LET l_abb25_bal = n_balf / n_bal
#     LET l_abb25_d = t_debit / t_debitf
#     LET l_abb25_c = t_credit / t_creditf
#     LET l_abb25_bal = n_bal / n_balf
#     #TQC-930163 --end
#     IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#     IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
#     IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
#     INSERT INTO gglq705_tmp
#     VALUES(sr.aag01,sr.aag02,sr.tao02,sr.gem02,sr.aba04,'4',
#            l_date2,'',g_msg,sr.abb24,'',0,0,
#            t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
#            l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
#END REPORT
##No.FUN-8B0106 mark end



