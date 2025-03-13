# Prog. Version..: '5.30.07-13.05.20(00009)'     #
# Pattern name...: gglq707.4gl
# Descriptions...: 科目核算項余額查詢-依核算项
# Date & Author..: 10/11/23 by Elva No.FUN-AB0104
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/17 By yinhy 查詢條件為空，跳到科目編號欄位
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-C80026 12/08/03 By lujh  查詢界面點輸入某qbe條件後點擊【退出】應回到主畫面，而不是整個關閉程序
# Modify.........: No:CHI-C70031 12/10/18 By wangwei 去除CE、CA憑證資料，否則月末結轉損益後，查詢不到損益類科目
# Modify.........: No:CHI-CB0006 12/11/16 By fengmy 增加"貨幣性科目"和"是否打印內部管理科目"
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.FUN-D10099 13/03/05 By minpp 報表改善
# Modify.........: No:FUN-D40044 13/04/25 By zhangweib 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm         RECORD
        #wc       LIKE type_file.chr1000,   #FUN-D10099 mark
         wc       STRING,                   #FUN-D10099  add
		   wc2      STRING,     
        #yy        LIKE type_file.num5,      #FUN-D10099  mark
         y         LIKE type_file.num5,      #FUN-D10099  add
         m1        LIKE type_file.num5,
         m2        LIKE type_file.num5,
         o         LIKE aaa_file.aaa01,
         a         LIKE type_file.chr2,
         b         LIKE type_file.chr1,
         e         LIKE type_file.chr1,   #No.FUN-D40044   Add
         aag09     LIKE aag_file.aag09,  #CHI-CB0006
         aag38     LIKE aag_file.aag38,  #CHI-CB0006
         MORE      LIKE type_file.chr1
                   END RECORD,
       g_null    LIKE type_file.chr1,
       g_print   LIKE type_file.chr1

DEFINE g_i            LIKE type_file.num5
DEFINE l_table        STRING,
       g_str          STRING,
       g_sql          STRING

DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_aed02    LIKE aed_file.aed02
DEFINE   g_ahe02_d    LIKE ahe_file.ahe02
DEFINE   g_cnt      LIKE type_file.num10
DEFINE   g_aed      DYNAMIC ARRAY OF RECORD
                    aed01      LIKE aed_file.aed01,
                    aag02   LIKE aag_file.aag02,
                    aed02      LIKE aed_file.aed02,      #FUN-D10099  add
                    ahe02_d    LIKE ahe_file.ahe02,      #FUN-D10099  add           
                    yy      LIKE apm_file.apm04,    
                    mm      LIKE apm_file.apm05,    
                    pb_dc      LIKE type_file.chr10,
                    pb_bal     LIKE aed_file.aed05,
                    d          LIKE aed_file.aed05,
                    c          LIKE aed_file.aed05,
                    dc         LIKE type_file.chr10,
                    bal        LIKE aed_file.aed05
                    END RECORD
DEFINE   g_pr       RECORD 
                    aed03      LIKE aed_file.aed03,
                    aed01      LIKE aed_file.aed01,
                    aag02      LIKE aag_file.aag02,
                    aed04      LIKE aed_file.aed04,
                    aed02      LIKE type_file.chr50,
                    ahe02_d    LIKE ze_file.ze03,
                    type       LIKE type_file.chr10,
                    pb_dc      LIKE type_file.chr10,
                    pb_bal     LIKE aed_file.aed05,
                    memo       LIKE abb_file.abb04,
                    d          LIKE aed_file.aed05,
                    c          LIKE aed_file.aed05,
                    dc         LIKE type_file.chr10,
                    bal        LIKE aed_file.aed05
                    END RECORD
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   l_ac           LIKE type_file.num5
DEFINE   l_ac_t         LIKE type_file.num5   
DEFINE   g_qc           LIKE aed_file.aed05 
DEFINE   g_qm           LIKE aed_file.aed05 
DEFINE   g_d            LIKE aed_file.aed05 
DEFINE   g_c            LIKE aed_file.aed05 
DEFINE   g_comb         ui.ComboBox        #FUN-D10099  add

MAIN  #FUN-AB0104

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

   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#  LET tm.yy = ARG_VAL(8)     #FUN-D10099  mark
   LET tm.y  = ARG_VAL(8)     #FUN-D10099  add`
   LET tm.m1 = ARG_VAL(9)
   LET tm.m2 = ARG_VAL(10)
   LET tm.o = ARG_VAL(11)
   LET tm.a = ARG_VAL(12)
   LET tm.b = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)
   LET tm.wc2     = ARG_VAL(18)

   CALL q707_out_1()

   OPEN WINDOW q707_w AT 5,10
        WITH FORM "ggl/42f/gglq707_1" ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()

   IF cl_null(tm.wc) THEN
       CALL gglq707_tm(0,0)
   ELSE
       CALL gglq707()
   END IF

   CALL q707_menu()
   DROP TABLE gglq707_tmp;
   CLOSE WINDOW q707_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q707_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL q707_bp("G")
      LET l_ac_t = l_ac    
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq707_tm(0,0)
               LET l_ac_t = 0    
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q707_out_2()
            END IF
         WHEN "drill_detail"
            IF cl_chk_act_auth() THEN
               CALL q707_drill_detail()
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
               IF g_aed02 IS NOT NULL THEN
                  LET g_doc.column1 = "aed02"
                  LET g_doc.value1 = g_aed02
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION gglq707_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_flag         LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5
 
  CLEAR FORM #清除畫面   #FUN-D10099  add
  CALL g_aed.clear()   #FUN-D10099  add
  
  #FUN-D10099---mark-str
  #LET p_row = 4 LET p_col =25
  #OPEN WINDOW gglq707_w AT p_row,p_col WITH FORM "ggl/42f/gglq707"
  #    ATTRIBUTE (STYLE = g_win_style CLIPPED)
  #CALL cl_ui_locale("gglq707")
  #FUN-D10099---mark---end

   #FUN-D10099--add--str--
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

   IF g_aaz.aaz119 ='N' THEN
      CALL cl_set_comp_visible("ahe02_d",FALSE)
   ELSE
      CALL cl_set_comp_visible("ahe02_d",TRUE)
   END IF
   #FUN-D10099--add--end--  
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
  #LET tm.yy = YEAR(g_today)     #FUN-D10099 mark
   LET tm.y  = YEAR(g_today)    #FUN-D10099 add
   LET tm.m1 = MONTH(g_today)
   LET tm.m2 = MONTH(g_today)
   LET tm.o  = g_aza.aza81 
   LET tm.a = '1'
  
   LET tm.b = '1'
   LET tm.e = 'N'    #No.FUN-D40044   Add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.aag09  = 'Y'                #No.CHI-CB0006
   LET tm.aag38  = 'N'                #No.CHI-CB0006
WHILE TRUE
   #FUN-D10099---mark---str  
   ##No.FUN-B20010  --Begin
   #DIALOG ATTRIBUTE(unbuffered)
   #INPUT BY NAME tm.o ATTRIBUTE(WITHOUT DEFAULTS)

   #    BEFORE INPUT
   #        CALL cl_qbe_display_condition(lc_qbe_sn)

   #    AFTER FIELD o
   #       IF cl_null(tm.o) THEN NEXT FIELD o END IF
   #       CALL s_check_bookno(tm.o,g_user,g_plant)
   #            RETURNING li_chk_bookno
   #       IF (NOT li_chk_bookno) THEN
   #            NEXT FIELD o
   #       END IF
   #       SELECT * FROM aaa_file WHERE aaa01 = tm.o
   #       IF SQLCA.sqlcode THEN
   #          CALL cl_err3("sel","aaa_file",tm.o,"","aap-229","","",0)
   #          NEXT FIELD o
   #       END IF
   #END INPUT
   ##No.FUN-B20010  --End
   #
   #CONSTRUCT BY NAME tm.wc ON aag01

   #   BEFORE CONSTRUCT
   #       CALL cl_qbe_init()
   #FUN-D10099---mark--end 
#No.FUN-B20010  --Mark Begin
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(aag01)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_aag'
#                LET g_qryparam.state= 'c'
#                LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"   #FUN-B20010 add               
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
#No.FUN-B20010  --Mark End
#   END CONSTRUCT              #FUN-D10099  mark
#No.FUN-B20010  --Mark Begin
#    IF g_action_choice = "locale" THEN
#       LET g_action_choice = ""
#       CALL cl_dynamic_locale()
#       CONTINUE WHILE
#    END IF
#
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0 CLOSE WINDOW gglq707_w
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#No.FUN-B20010  --Mark End
#   CONSTRUCT BY NAME tm.wc2 ON aed02      #FUN-D10099 mark
#No.FUN-B20010  --Mark Begin
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
       
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(aed02)
#               CALL cq_occ4(TRUE,TRUE) RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aed02
#               NEXT FIELD aed02
#         END CASE
       
#    END CONSTRUCT             #FUN-D10099 mark
#No.FUN-B20010  --Mark Begin
#     IF g_action_choice = "locale" THEN
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE
#     END IF
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0 CLOSE WINDOW gglq707_w
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    IF tm.wc2 = ' 1=1' THEN
#       CALL cl_err('','9046',0) CONTINUE WHILE
#    END IF
#No.FUN-B20010  --Mark End  
        
    #INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.o,tm.a,tm.b,tm.more WITHOUT DEFAULTS  #FUN-B20010 mark
   #INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.a,tm.b,tm.aag09,tm.aag38,tm.more ATTRIBUTE(WITHOUT DEFAULTS)   #FUN-B20010 去掉tm.o    #CHI-CB0006 add aag09,aag38    #FUN-D10099 mark
    DIALOG ATTRIBUTES(UNBUFFERED)                                                                 #FUN-D10099  add
    INPUT BY NAME tm.o,tm.y,tm.m1,tm.m2,tm.a,tm.b,tm.aag09,tm.aag38,tm.e ATTRIBUTE(WITHOUT DEFAULTS)   #FUN-D10099  add    #No.FUN-D40044  Add tm.e

        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
        #FUN-D10099--add--str--
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
        #FUN-D10099--add--end--
  
       #FUN-D10099--mark---str
       # AFTER FIELD yy
       #    IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
       #FUN-D10099---MARK--END

       #FUN-D10099--add--str--
        AFTER FIELD y
           IF cl_null(tm.y) THEN NEXT FIELD y END IF
        #FUN-D10099--add--end--
        AFTER FIELD m1
           IF cl_null(tm.m1) OR tm.m1 > 13 OR tm.m1 < 1 THEN
              NEXT FIELD m1
           END IF

        AFTER FIELD m2
           IF cl_null(tm.m2) OR tm.m2 > 13 OR tm.m2 < 1 OR tm.m2 < tm.m1 THEN
              NEXT FIELD m2
           END IF

        AFTER FIELD a
          
           IF tm.a NOT MATCHES "[123456789]" AND tm.a <> "10" AND tm.a <> "99" THEN   
              NEXT FIELD a
           END IF
        
        AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[123]'
            THEN NEXT FIELD b END IF
       
       #FUN-D10099--add--str--
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(o)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               CALL cl_create_qry() RETURNING tm.o
               DISPLAY BY NAME tm.o
               NEXT FIELD o
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
            LET INT_FLAG = 1
            EXIT DIALOG
         #FUN-D10099--add--end--
 
       #No.FUN-B20010  --Begin
       #AFTER FIELD o
       #   IF cl_null(tm.o) THEN NEXT FIELD o END IF
       #   CALL s_check_bookno(tm.o,g_user,g_plant)
       #        RETURNING li_chk_bookno
       #   IF (NOT li_chk_bookno) THEN
       #        NEXT FIELD o
       #   END IF
       #   SELECT * FROM aaa_file WHERE aaa01 = tm.o
       #   IF SQLCA.sqlcode THEN
       #      CALL cl_err3("sel","aaa_file",tm.o,"","aap-229","","",0)
       #      NEXT FIELD o
       #   END IF
       #No.FUN-B20010  --End
       #FUN-D10099---mark---str 
       #AFTER FIELD more
       #   IF tm.more = 'Y'
       #      THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
       #                          g_bgjob,g_time,g_prtway,g_copies)
       #                RETURNING g_pdate,g_towhom,g_rlang,
       #                          g_bgjob,g_time,g_prtway,g_copies
       #   END IF
       #FUN-D10099---mark--end
#No.FUN-B20010  --Mark Begin
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
#No.FUN-B20010  --Mark End
    END INPUT

    #FUN-D10099--add--str--
    CONSTRUCT BY NAME tm.wc ON aed01,aed02
       BEFORE CONSTRUCT
        CALL cl_qbe_init()

       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(aed01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aag'
                LET g_qryparam.state= 'c'
                LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aed01
                NEXT FIELD aed01
          WHEN INFIELD(aed02)     #核算
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aee1'  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aed02
                  NEXT FIELD aed02
       
          END CASE

       ON ACTION ACCEPT
          EXIT DIALOG

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG
    END CONSTRUCT

#    CONSTRUCT BY NAME tm.wc2 ON aed02
#       BEFORE CONSTRUCT
#         CALL cl_qbe_init()
#     
#             #add by liyjg161109 str
#        ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(aed02)     #核算
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= 'c'
#                  LET g_qryparam.form = 'q_aee1'  
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aed02
#                  NEXT FIELD aed02
#          END CASE  
#      #add by liyjg161109 end
#       ON ACTION ACCEPT
#          EXIT DIALOG
#
#       ON ACTION CANCEL
#          LET INT_FLAG=1
#          EXIT DIALOG
#    END CONSTRUCT
    #FUN-D10099--add--end--
  
  #FUN-D10099---mark-str
  # #No.FUN-B20010  --Begin
  # ON ACTION CONTROLP
  #      CASE
  #         WHEN INFIELD(o)
  #            CALL cl_init_qry_var()
  #            LET g_qryparam.form = 'q_aaa'
  #            CALL cl_create_qry() RETURNING tm.o
  #            DISPLAY BY NAME tm.o
  #            NEXT FIELD o
  #         WHEN INFIELD(aag01)
  #             CALL cl_init_qry_var()
  #             LET g_qryparam.form = 'q_aag'
  #             LET g_qryparam.state= 'c'
  #             LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"   #FUN-B20010 add               
  #             CALL cl_create_qry() RETURNING g_qryparam.multiret
  #             DISPLAY g_qryparam.multiret TO aag01
  #             NEXT FIELD aag01
  #         OTHERWISE EXIT CASE
  #      END CASE
  #      ON ACTION locale
  #     CALL cl_show_fld_cont() 
  #     LET g_action_choice = "locale"
  #     EXIT DIALOG
  #  ON ACTION CONTROLR
  #     CALL cl_show_req_fields()

  #  ON ACTION CONTROLG
  #     CALL cl_cmdask()

  #  ON IDLE g_idle_seconds
  #     CALL cl_on_idle()
  #     CONTINUE DIALOG

  #  ON ACTION about    
  #     CALL cl_about()

  #  ON ACTION help   
  #     CALL cl_show_help()

  #  ON ACTION exit
  #     LET INT_FLAG = 1
  #     EXIT DIALOG
  #     
  #  ON ACTION accept
  #     #No.TQC-B30147  --Begin
  #     IF cl_null(tm.wc) OR tm.wc = ' 1=1' THEN
  #      CALL cl_err('','9046',0)
  #      NEXT FIELD aag01
  #     END IF
  #     #No.TQC-B30147  --End
  #     EXIT DIALOG
  #    
  #  ON ACTION cancel
  #     LET INT_FLAG=1
  #     EXIT DIALOG   
  #FUN-D10099---mark---end 
   END DIALOG
   IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CONTINUE WHILE
   END IF
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW gglq707_w
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-D10099  mark
       #EXIT PROGRAM    #TQC-C80026  mark
       RETURN           #TQC-C80026  add
    END IF
    #IF tm.wc2 = ' 1=1' THEN
    #   CALL cl_err('','9046',0) CONTINUE WHILE
    #END IF
    #No.FUN-B20010  --End
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file
              WHERE zz01='gglq707'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglq707','9031',1)
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,
                          " '",g_pdate  CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          " '",g_rlang CLIPPED,"'",
                          " '",g_bgjob  CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc    CLIPPED,"'" ,
                         #" '",tm.yy    CLIPPED,"'" ,     #FUN-D10099  mark
                          " '",tm.y     CLIPPED,"'" ,    #FUN-D10099  add
                          " '",tm.m1    CLIPPED,"'" ,
                          " '",tm.m2    CLIPPED,"'" ,
                          " '",tm.o     CLIPPED,"'",
                          " '",tm.a     CLIPPED,"'",
                          " '",tm.b     CLIPPED,"'",
                          " '",g_rep_user CLIPPED,"'",
                          " '",g_rep_clas CLIPPED,"'",
                          " '",g_template CLIPPED,"'",
                          " '",g_rpt_name CLIPPED,"'"
                          ," '",tm.wc2 CLIPPED,"'"
          CALL cl_cmdat('gglq707',g_time,l_cmd)
       END IF
       CLOSE WINDOW gglq707_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglq707()
    ERROR ""
    EXIT WHILE
END WHILE
  #CLOSE WINDOW gglq707_w     #FUN-D10099 MARK

   LET g_aed02 = NULL
   LET g_ahe02_d = NULL

   CLEAR FORM
   CALL g_aed.clear()
   CALL gglq707_cs()

END FUNCTION

FUNCTION gglq707()
   DEFINE l_name             LIKE type_file.chr20,
          l_sql              LIKE type_file.chr1000,
          l_sql1             LIKE type_file.chr1000,
          l_aed              LIKE type_file.chr1000,
          l_abb              LIKE type_file.chr1000,
          l_i                LIKE type_file.num5,
          qc_aed05           LIKE aed_file.aed05,  
          qc_aed06           LIKE aed_file.aed06,
          qj_aed05           LIKE aed_file.aed05,  
          qj_aed06           LIKE aed_file.aed06,
          l_aed05            LIKE aed_file.aed05,
          l_aed06            LIKE aed_file.aed06,
          l_aed02            LIKE aed_file.aed02,
          l_gaq01            LIKE gaq_file.gaq01,
          l_aag01_str        LIKE type_file.chr50,
          l_ahe02_d          LIKE ze_file.ze03,
          #No.CHI-C70031  --Begin
          l_aeh11                      LIKE aeh_file.aeh11,
          l_aeh12                      LIKE aeh_file.aeh12,
          l_aeh15                      LIKE aeh_file.aeh15,
          l_aeh16                      LIKE aeh_file.aeh16,
          l_aaa09                      LIKE aaa_file.aaa09,
          l_aeh03                      LIKE aeh_file.aeh03,
          l_aeh04                      LIKE aeh_file.aeh04,
          l_aeh05                      LIKE aeh_file.aeh05,
          l_aeh06                      LIKE aeh_file.aeh06,
          l_aeh07                      LIKE aeh_file.aeh07,
          l_aeh31                      LIKE aeh_file.aeh31,
          l_aeh32                      LIKE aeh_file.aeh32,
          l_aeh33                      LIKE aeh_file.aeh33,
          l_aeh34                      LIKE aeh_file.aeh34,
          l_aeh35                      LIKE aeh_file.aeh35,
          l_aeh36                      LIKE aeh_file.aeh36,
          l_aeh37                      LIKE aeh_file.aeh37,
          #No.CHI-C70031  --End

          sr1                RECORD
                             aag01    LIKE aag_file.aag01,
                             aag02    LIKE aag_file.aag02
                             END RECORD,
          sr                 RECORD 
                             aed03    LIKE aed_file.aed03,
                             aed01    LIKE aed_file.aed01,
                             aag02    LIKE aag_file.aag02,
                             aed04    LIKE aed_file.aed04,
                             aed02    LIKE aed_file.aed02,
                             ahe02_d  LIKE ze_file.ze03,
                             aed05    LIKE aed_file.aed05,
                             aed06    LIKE aed_file.aed06,
                             qcye     LIKE aed_file.aed05
                             END RECORD,
          l_field            LIKE     gaq_file.gaq01
DEFINE l_wc2   LIKE type_file.chr1000          

     CASE tm.a
          WHEN '1'   LET l_field = 'abb11'
                     LET l_gaq01 = 'aag15'
          WHEN '2'   LET l_field = 'abb12'
                     LET l_gaq01 = 'aag16'
          WHEN '3'   LET l_field = 'abb13'
                     LET l_gaq01 = 'aag17'
          WHEN '4'   LET l_field = 'abb14'
                     LET l_gaq01 = 'aag18'
          WHEN '5'   LET l_field = 'abb31'
                     LET l_gaq01 = 'aag31'
          WHEN '6'   LET l_field = 'abb32'
                     LET l_gaq01 = 'aag32'
          WHEN '7'   LET l_field = 'abb33'
                     LET l_gaq01 = 'aag33'
          WHEN '8'   LET l_field = 'abb34'
                     LET l_gaq01 = 'aag34'
          WHEN '9'   LET l_field = 'abb35'
                     LET l_gaq01 = 'aag35'
          WHEN '10'  LET l_field = 'abb36'
                     LET l_gaq01 = 'aag36'
         
          WHEN '99'  LET l_field = 'abb37'   
                     LET l_gaq01 = 'aag37'
     END CASE
    
     IF tm.b = '3' THEN
        LET l_field = NULL
     END IF
     CALL gglq707_table()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
     
     LET g_qc=0  LET g_qm=0
     LET g_d=0   LET g_c=0
     
     LET tm.wc = cl_replace_str(tm.wc,"aed01","aag01")    #FUN-D10099 add 
     LET l_sql = " SELECT aag01,aag02 FROM aag_file ",
                 "  WHERE aag00 = '",tm.o,"'",
                 "    AND ",tm.wc CLIPPED
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
     PREPARE gglq707_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq707_aag01_cs CURSOR FOR gglq707_pr1

     
     LET l_sql1 = "SELECT UNIQUE aed02 FROM aed_file ",
                  " WHERE aed00 = '",tm.o,"'",
                  "   AND aed01 LIKE ? ",           
                  "   AND aed011 = '",tm.a,"'"
                  ,"   AND ",tm.wc2 CLIPPED
    
     IF tm.b MATCHES '[12]'  THEN 
        LET l_wc2 = tm.wc2
        LET l_wc2 = cl_replace_str(l_wc2,"aed02",l_field)
        LET l_sql1 = l_sql1 CLIPPED,
                     " UNION ",
                     " SELECT ",l_field CLIPPED," FROM aba_file,abb_file",
                     "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                     "    AND aba00 = '",tm.o,"'",
                     "    AND abb03 LIKE ? ",       
                     "    AND ",l_field CLIPPED," IS NOT NULL",
                     "    AND ",l_wc2,
                     "    AND abapost = 'N' AND abaacti='Y' ",
                     "    AND aba19 <> 'X' "   #CHI-C80041
        IF tm.b='2' THEN
           LET l_sql1 = l_sql1 CLIPPED," AND aba19 = 'Y' "
        END IF
     END IF
     PREPARE gglq707_aed02_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq707_aed02_cs CURSOR FOR gglq707_aed02_p

     
     LET l_aed = "SELECT SUM(aed05),SUM(aed06) FROM aed_file",
                 " WHERE aed00 = '",tm.o,"'",
                 "   AND aed01 LIKE ? ",                
                 "   AND aed02 = ? ",                   
                 "   AND aed011 = '",tm.a,"'",
               # "   AND aed03 = ",tm.yy         #FUN-D10099 mark
                 "   AND aed03 = ",tm.y          #FUN-D10099 add
     LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",tm.o,"'",
                 "    AND abb03 LIKE ?   ",             
                 "    AND ",l_field CLIPPED," = ? ",    
               # "    AND aba03 = ",tm.yy,          #FUN-D10099 mark
                 "    AND aba03 = ",tm.y,          #FUN-D10099 add
                 "    AND abapost = 'N' AND abaacti='Y' ",
                 "    AND aba19 <> 'X' "   #CHI-C80041  
     IF tm.b='2' THEN
        LET l_abb = l_abb CLIPPED," AND aba19 = 'Y' "
     END IF

     #當期異動
     LET l_sql1 = l_aed CLIPPED, "   AND aed04 = ? "  
    
     IF tm.b MATCHES '[12]'  THEN 
        LET l_sql1 = l_sql1 CLIPPED,
                     " UNION ALL ", #不合并重复行 by elva
                     #未過帳 - 借
                     " SELECT SUM(abb07),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                     "    AND abb06 = '1' ",
                     "    AND aba04 = ?   ",              
                     " UNION ALL ", #不合并重复行 by elva
                     #未過帳 - 貸
                     " SELECT 0,SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
                     "    AND abb06 = '2' ",
                     "    AND aba04 = ?   "               
     END IF
     PREPARE gglq707_qj_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq707_qj_cs CURSOR FOR gglq707_qj_p

     #期初余額
     LET l_sql1 = l_aed CLIPPED, "   AND aed04 < ? "  
    
     IF tm.b MATCHES '[12]'  THEN 
        LET l_sql1 = l_sql1 CLIPPED,
                     " UNION ALL",  #不合并重复行 by elva
                     #未過帳 - 借
                     " SELECT SUM(abb07),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                     "    AND abb06 = '1' ",
                     "    AND aba04 < ?   ",              
                     " UNION ALL",  #不合并重复行 by elva
                     #未過帳 - 貸
                     " SELECT 0,SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
                     "    AND abb06 = '2' ",
                     "    AND aba04 < ?   "               
     END IF
     PREPARE gglq707_qc_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq707_qc_cs CURSOR FOR gglq707_qc_p

     #查找核算項值
     LET l_sql1 = " SELECT ",l_gaq01 CLIPPED," FROM aag_file ",
                  "  WHERE aag00 = '",tm.o,"'",
                  "    AND aag01 LIKE ? ",
                  "    AND aag07 IN ('2','3') ",
                  "    AND ",l_gaq01 CLIPPED," IS NOT NULL"
     PREPARE gglq707_gaq01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq707_gaq01_cs SCROLL CURSOR FOR gglq707_gaq01_p  

     LET g_pageno  = 0
     CALL cl_outnam('gglq707') RETURNING l_name
     START REPORT gglq707_rep TO l_name

     FOREACH gglq707_aag01_cs INTO sr1.*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('gglq707_aag01_cs foreach:',SQLCA.sqlcode,0) EXIT FOREACH
       END IF

       #此作業也要打印統治科目的金額，但是aed/abb中都存放得是明細或是獨立科目
       #所以要用LIKE的方式，取出統治科目對應的明細科目的金額
       #此作業的前提，明細科目的前幾碼一定和其上屬統治相同 ruled by 蔡曉峰
       IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
       LET l_aag01_str = sr1.aag01 CLIPPED,'%'

      
       IF tm.b ='3'  THEN 
          FOREACH gglq707_aed02_cs USING l_aag01_str
                                   INTO l_aed02
            IF SQLCA.sqlcode THEN
               CALL cl_err('gglq707_aed02_cs foreach:',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
	    #No.CHI-C70031  --Begin
            LET  l_aeh04  =  NULL
            LET  l_aeh05  =  NULL
            LET  l_aeh06  =  NULL
            LET  l_aeh07  =  NULL
            LET  l_aeh31  =  NULL
            LET  l_aeh32  =  NULL
            LET  l_aeh33  =  NULL
            LET  l_aeh34  =  NULL
            LET  l_aeh35  =  NULL
            LET  l_aeh36  =  NULL
            LET  l_aeh37  =  NULL
            CASE tm.a
                WHEN '1' LET l_aeh04 = l_aed02
                WHEN '2' LET l_aeh05 = l_aed02
                WHEN '3' LET l_aeh06 = l_aed02
                WHEN '4' LET l_aeh07 = l_aed02
                WHEN '5' LET l_aeh31 = l_aed02
                WHEN '6' LET l_aeh32 = l_aed02
                WHEN '7' LET l_aeh33 = l_aed02
                WHEN '8' LET l_aeh34 = l_aed02
                WHEN '9' LET l_aeh35 = l_aed02
                WHEN '10' LET l_aeh36 = l_aed02
             WHEN '99' LET l_aeh37 =l_aed02
            END CASE
            #No.CHI-C70031  --End

            FOR l_i = tm.m1 TO tm.m2
                LET qc_aed05 = 0  
                LET qc_aed06 = 0
                LET qj_aed05 = 0  
                LET qj_aed06 = 0
                FOREACH gglq707_qc_cs USING l_aag01_str,l_aed02,l_i
                                      INTO l_aed05,l_aed06
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('gglq707_aed02_cs foreach:',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  IF cl_null(l_aed05) THEN LET l_aed05 = 0 END IF
                  IF cl_null(l_aed06) THEN LET l_aed06 = 0 END IF
                  LET qc_aed05 = qc_aed05 + l_aed05
                  LET qc_aed06 = qc_aed06 + l_aed06
                END FOREACH
		#No.CHI-C70031  --Begin
                SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
                LET l_aeh11 = 0
                LET l_aeh12 = 0
                CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, NULL,NULL,NULL,
                l_aeh04,  l_aeh05,    l_aeh06,      l_aeh07,     NULL,    tm.y,     #FUN-D10099 change tm.yy to tm.y
                0,       l_i-1,       NULL,      l_aeh31,  l_aeh32,    l_aeh33,
                l_aeh34,  l_aeh35,      l_aeh36,    l_aeh37,     g_plant,  l_aaa09,'1')
                RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
                IF tm.e = 'N' THEN   #No.FUN-D40044   Add
                   LET qc_aed05 = qc_aed05 - l_aeh11
                   LET qc_aed06 = qc_aed06 - l_aeh12
                END IF               #No.FUN-D40044   Add
                #No.CHI-C70031  --End
                LET g_print = 'N'
                FOREACH gglq707_qj_cs USING l_aag01_str,l_aed02,l_i
                                      INTO l_aed05,l_aed06
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach:',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  IF cl_null(l_aed05) THEN LET l_aed05 = 0 END IF
                  IF cl_null(l_aed06) THEN LET l_aed06 = 0 END IF
                  LET qj_aed05 = qj_aed05 + l_aed05
                  LET qj_aed06 = qj_aed06 + l_aed06
                  LET g_print = 'Y'
                END FOREACH
               	#No.CHI-C70031  --Begin
                SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
                LET l_aeh11 = 0
                LET l_aeh12 = 0
                CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, NULL,NULL,NULL,
                l_aeh04,  l_aeh05,    l_aeh06,      l_aeh07,     NULL,    tm.y,      #FUN-D10099 change tm.yy to tm.y
                l_i,       l_i,       NULL,      l_aeh31,  l_aeh32,    l_aeh33,
                l_aeh34,  l_aeh35,      l_aeh36,    l_aeh37,     g_plant,  l_aaa09,'1')
                RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
                IF tm.e = 'N' THEN   #No.FUN-D40044   Add
                   LET qj_aed05 = qj_aed05 - l_aeh11
                   LET qj_aed06 = qj_aed06 - l_aeh12
                END IF               #No.FUN-D40044   Add
                #No.CHI-C70031  --End
 
                #無期初也沒有本期異動，則不打印
                IF (qc_aed05-qc_aed06) = 0 AND
                   qj_aed05 = 0 AND qj_aed06 = 0 THEN
                   CONTINUE FOR
                END IF

                CALL gglq707_get_ahe02(l_aag01_str,l_aed02,sr1.aag01)  
                     RETURNING l_ahe02_d
                INITIALIZE sr.* TO NULL 
              # LET sr.aed03  = tm.yy      #FUN-D10099 mark
                LET sr.aed03  = tm.y           #FUN-D10099 add
                LET sr.aed01  = sr1.aag01
                LET sr.aag02  = sr1.aag02
                LET sr.aed04  = l_i
                LET sr.aed02  = l_aed02
                LET sr.ahe02_d  = l_ahe02_d
                LET sr.aed05 = qj_aed05
                LET sr.aed06 = qj_aed06
                LET sr.qcye  = qc_aed05 - qc_aed06
                OUTPUT TO REPORT gglq707_rep(sr.*)
             END FOR
          END FOREACH
       ELSE
          FOREACH gglq707_aed02_cs USING l_aag01_str,l_aag01_str
                                   INTO l_aed02
            IF SQLCA.sqlcode THEN
               CALL cl_err('gglq707_aed02_cs foreach:',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            #No.CHI-C70031  --Begin
            LET  l_aeh04  =  NULL
            LET  l_aeh05  =  NULL
            LET  l_aeh06  =  NULL
            LET  l_aeh07  =  NULL
            LET  l_aeh31  =  NULL
            LET  l_aeh32  =  NULL
            LET  l_aeh33  =  NULL
            LET  l_aeh34  =  NULL
            LET  l_aeh35  =  NULL
            LET  l_aeh36  =  NULL
            LET  l_aeh37  =  NULL
            CASE tm.a
                WHEN '1' LET l_aeh04 = l_aed02
                WHEN '2' LET l_aeh05 = l_aed02
                WHEN '3' LET l_aeh06 = l_aed02
                WHEN '4' LET l_aeh07 = l_aed02
                WHEN '5' LET l_aeh31 = l_aed02
                WHEN '6' LET l_aeh32 = l_aed02
                WHEN '7' LET l_aeh33 = l_aed02
                WHEN '8' LET l_aeh34 = l_aed02
                WHEN '9' LET l_aeh35 = l_aed02
                WHEN '10' LET l_aeh36 = l_aed02
             WHEN '99' LET l_aeh37 =l_aed02
            END CASE
            #No.CHI-C70031  --End

            FOR l_i = tm.m1 TO tm.m2
                LET qc_aed05 = 0  
                LET qc_aed06 = 0
                LET qj_aed05 = 0  
                LET qj_aed06 = 0
                FOREACH gglq707_qc_cs USING l_aag01_str,l_aed02,l_i,
                                            l_aag01_str,l_aed02,l_i,
                                            l_aag01_str,l_aed02,l_i
                                      INTO l_aed05,l_aed06
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('gglq707_aed02_cs foreach:',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  IF cl_null(l_aed05) THEN LET l_aed05 = 0 END IF
                  IF cl_null(l_aed06) THEN LET l_aed06 = 0 END IF
                  LET qc_aed05 = qc_aed05 + l_aed05
                  LET qc_aed06 = qc_aed06 + l_aed06
                END FOREACH
                #No.CHI-C70031  --Begin
                SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
                LET l_aeh11 = 0
                LET l_aeh12 = 0
                CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, NULL,NULL,NULL,
                l_aeh04,  l_aeh05,    l_aeh06,      l_aeh07,     NULL,    tm.y,          #FUN-D10099 change tm.yy to tm.y
                0,       l_i-1,       NULL,      l_aeh31,  l_aeh32,    l_aeh33,
                l_aeh34,  l_aeh35,      l_aeh36,    l_aeh37,     g_plant,  l_aaa09,'1')
                RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
                IF tm.e = 'N' THEN   #No.FUN-D40044   Add
                   LET qc_aed05 = qc_aed05 - l_aeh11
                   LET qc_aed06 = qc_aed06 - l_aeh12
                END IF               #No.FUN-D40044   Add
                #No.CHI-C70031  --End
                LET g_print = 'N'
                FOREACH gglq707_qj_cs USING l_aag01_str,l_aed02,l_i,
                                            l_aag01_str,l_aed02,l_i,
                                            l_aag01_str,l_aed02,l_i
                                      INTO l_aed05,l_aed06
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach:',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  IF cl_null(l_aed05) THEN LET l_aed05 = 0 END IF
                  IF cl_null(l_aed06) THEN LET l_aed06 = 0 END IF
                  LET qj_aed05 = qj_aed05 + l_aed05
                  LET qj_aed06 = qj_aed06 + l_aed06
                  LET g_print = 'Y'
                END FOREACH
                #No.CHI-C70031  --Begin
                SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01=tm.o
                LET l_aeh11 = 0
                LET l_aeh12 = 0
                CALL s_minus_ce(tm.o, l_aag01_str, l_aag01_str, NULL,NULL,NULL,
                l_aeh04,  l_aeh05,    l_aeh06,      l_aeh07,     NULL,    tm.y,     #FUN-D10099 change tm.yy to tm.y
                l_i,       l_i,       NULL,      l_aeh31,  l_aeh32,    l_aeh33,
                l_aeh34,  l_aeh35,      l_aeh36,    l_aeh37,     g_plant,  l_aaa09,'1')
                RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
                IF tm.e = 'N' THEN   #No.FUN-D40044   Add
                   LET qj_aed05 = qj_aed05 - l_aeh11
                   LET qj_aed06 = qj_aed06 - l_aeh12
                END IF               #No.FUN-D40044   Add
                #No.CHI-C70031  --End
                
                #無期初也沒有本期異動，則不打印
                IF (qc_aed05 -qc_aed06)=0 AND
                   qj_aed05 = 0 AND qj_aed06 = 0 THEN
                   CONTINUE FOR
                END IF

                CALL gglq707_get_ahe02(l_aag01_str,l_aed02,sr1.aag01) 
                     RETURNING l_ahe02_d
                INITIALIZE sr.* TO NULL 
               #LET sr.aed03  = tm.y       #FUN-D10099 mark
                LET sr.aed03  = tm.y           #FUN-D10099 add
                LET sr.aed01  = sr1.aag01
                LET sr.aag02  = sr1.aag02
                LET sr.aed04  = l_i
                LET sr.aed02  = l_aed02
                LET sr.ahe02_d  = l_ahe02_d
                LET sr.aed05 = qj_aed05
                LET sr.aed06 = qj_aed06
                LET sr.qcye  = qc_aed05 - qc_aed06
                OUTPUT TO REPORT gglq707_rep(sr.*)
             END FOR
          END FOREACH
       END IF
     END FOREACH
     FINISH REPORT gglq707_rep
END FUNCTION

REPORT gglq707_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,
          sr        RECORD 
                    aed03    LIKE aed_file.aed03,
                    aed01    LIKE aed_file.aed01,
                    aag02    LIKE aag_file.aag02,
                    aed04    LIKE aed_file.aed04,
                    aed02    LIKE aed_file.aed02,
                    ahe02_d  LIKE ze_file.ze03,
                    aed05    LIKE aed_file.aed05,
                    aed06    LIKE aed_file.aed06,
                    qcye     LIKE aed_file.aed05
                    END RECORD,
          l_cnt                        LIKE type_file.num5,
          t_bal                        LIKE aed_file.aed05,
	  n_bal                        LIKE aed_file.aed05,
          n_pb_bal                     LIKE aed_file.aed05,
          l_pb_dc                      LIKE type_file.chr10,
          l_dc                         LIKE type_file.chr10
    DEFINE l_msg   VARCHAR(100)

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aed02,sr.aed01,sr.aed03,sr.aed04
  FORMAT
   PAGE HEADER
      LET g_pageno = g_pageno + 1

   BEFORE GROUP OF sr.aed01
      LET g_qc=sr.qcye
      LET g_qm=sr.qcye
      LET g_d=0
      LET g_c=0
   ON EVERY ROW
         IF cl_null(sr.aed05) THEN LET sr.aed05 = 0 END IF
         IF cl_null(sr.aed06) THEN LET sr.aed06 = 0 END IF
         LET t_bal   = sr.aed05 - sr.aed06 + sr.qcye
         
         IF sr.qcye > 0 THEN
            LET n_pb_bal = sr.qcye
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
         ELSE
            IF sr.qcye = 0 THEN
               LET n_pb_bal = sr.qcye
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
            ELSE
               LET n_pb_bal = sr.qcye * -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
            END IF
         END IF

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
         
         LET g_qm=g_qm+sr.aed05 - sr.aed06
         LET g_d=g_d+sr.aed05  LET g_c=g_c+sr.aed06
         
         
         INSERT INTO gglq707_tmp
         VALUES(sr.aed03,sr.aed01,sr.aag02,sr.aed04,sr.aed02,sr.ahe02_d,'2',
                l_pb_dc,n_pb_bal,'',sr.aed05,sr.aed06,l_dc,n_bal)
         PRINT
   
   
    AFTER GROUP OF sr.aed01
      #插入合计
      IF g_qc > 0 THEN
         LET n_pb_bal = g_qc
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
      ELSE
         IF g_qc = 0 THEN
            LET n_pb_bal = g_qc
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
         ELSE
            LET n_pb_bal = g_qc * -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
         END IF
      END IF

      IF g_qm > 0 THEN
         LET n_bal = g_qm
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = g_qm
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = g_qm * -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
      
       CALL cl_getmsg('ggl-223',g_lang) RETURNING sr.aag02 
      INSERT INTO gglq707_tmp
         VALUES('',sr.aed01,sr.aag02,'',sr.aed02,sr.ahe02_d,'3',
                l_pb_dc,n_pb_bal,'',g_d,g_c,l_dc,n_bal)
      LET g_qc=0  LET g_qm=0
      LET g_d=0   LET g_c=0
   
END REPORT

FUNCTION gglq707_table()
     DROP TABLE gglq707_tmp;
     CREATE TEMP TABLE gglq707_tmp( 
                    aed03        LIKE aed_file.aed03,
                    aed01        LIKE aed_file.aed01,
                    aag02        LIKE aag_file.aag02,
                    aed04        LIKE aed_file.aed04,
                    aed02        LIKE aed_file.aed02,
                    ahe02_d      LIKE ahe_file.ahe02,
                    type         LIKE type_file.chr1,
                    pb_dc        LIKE type_file.chr10,
                    pb_bal       LIKE type_file.num20_6,  
                    memo         LIKE type_file.chr50,    
                    d            LIKE type_file.num20_6,  
                    c            LIKE type_file.num20_6,  
                    dc           LIKE type_file.chr10,    
                    bal          LIKE type_file.num20_6)  
END FUNCTION

FUNCTION q707_bp(p_ud)
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
         
         IF l_ac_t > 0 THEN
            CALL FGL_SET_ARR_CURR(l_ac_t)
            LET l_ac_t = 0
         END IF
         
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
         CALL gglq707_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL gglq707_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL gglq707_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL gglq707_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL gglq707_fetch('L')
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

FUNCTION gglq707_cs()
 
  
    # LET g_sql = "SELECT UNIQUE aed02,ahe02_d FROM gglq707_tmp ",      #FUN-D10099 mark
    #            " ORDER BY aed02,ahe02_d"                               #FUN-D10099 mark
    LET g_sql = "SELECT UNIQUE aed02 FROM gglq707_tmp ",             #FUN-D10099 add
                 " ORDER BY aed02"                                     #FUN-D10099 add
            PREPARE gglq707_ps FROM g_sql
     DECLARE gglq707_curs SCROLL CURSOR WITH HOLD FOR gglq707_ps

  
    #LET g_sql = "SELECT UNIQUE aed02,ahe02_d FROM gglq707_tmp ",   #FUN-D10099 mark
     LET g_sql = "SELECT UNIQUE aed02 FROM gglq707_tmp ",              #FUN-D10099 
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq707_ps1 FROM g_sql
     EXECUTE gglq707_ps1

     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq707_ps2 FROM g_sql
     DECLARE gglq707_cnt CURSOR FOR gglq707_ps2

     OPEN gglq707_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq707_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq707_cnt
        FETCH gglq707_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq707_fetch('F')
     END IF
END FUNCTION

FUNCTION gglq707_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10

   CASE p_flag
    #FUN-D10099---mark--str
    # WHEN 'N' FETCH NEXT     gglq707_curs INTO g_aed02,g_ahe02_d    
    # WHEN 'P' FETCH PREVIOUS gglq707_curs INTO g_aed02,g_ahe02_d    
    # WHEN 'F' FETCH FIRST    gglq707_curs INTO g_aed02,g_ahe02_d    
    # WHEN 'L' FETCH LAST     gglq707_curs INTO g_aed02,g_ahe02_d    
    #FUN-D10099---mark--end

    #FUN-D10099--add--str--
     WHEN 'N' FETCH NEXT     gglq707_curs INTO g_aed02
     WHEN 'P' FETCH PREVIOUS gglq707_curs INTO g_aed02
     WHEN 'F' FETCH FIRST    gglq707_curs INTO g_aed02
     WHEN 'L' FETCH LAST     gglq707_curs INTO g_aed02
    #FUN-D10099--add--end--
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
   
        #FETCH ABSOLUTE g_jump gglq707_curs INTO g_aed02,g_ahe02_d   #FUN-D10099  mark
         FETCH ABSOLUTE g_jump gglq707_curs INTO g_aed02             #FUN-D10099  add
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aed02,SQLCA.sqlcode,0)
      INITIALIZE g_aed02 TO NULL
      INITIALIZE g_ahe02_d TO NULL
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

   CALL gglq707_show()
END FUNCTION

FUNCTION gglq707_show()

  #DISPLAY g_aed02 TO aed02         #FUN-D10099  mark
  #DISPLAY g_ahe02_d TO ahe02_d      #FUN-D10099  mark
   DISPLAY tm.a    TO a
   #FUN-D10099--add--str--
   DISPLAY tm.o    TO o
   DISPLAY tm.y    TO y
   DISPLAY tm.m1   TO m1
   DISPLAY tm.m2   TO m2
   DISPLAY tm.b    TO b
   DISPLAY tm.aag09 TO aag09
   DISPLAY tm.aag38 TO aag38
   DISPLAY tm.e    TO e   #No.FUN-D40044   Add
   #FUN-D10099--add--end--
   CALL gglq707_b_fill()

   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION gglq707_b_fill()
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1
  DEFINE  l_memo     LIKE abb_file.abb04
  DEFINE  l_aag06    LIKE aag_file.aag06 
  DEFINE  l_pb_dc211 LIKE type_file.chr10 
  DEFINE  l_pb_dc212 LIKE type_file.chr10 
   

   LET g_sql = "SELECT aed01,aag02,aed02,ahe02_d,aed03,aed04,pb_dc,pb_bal,",     #FUN-D10099 add-aed2,ahe02_d
               "       d,c,dc,bal,type,memo ",
               " FROM gglq707_tmp",
               " WHERE aed02 ='",g_aed02,"'",
               " ORDER BY aed01,type,aed04 "

   PREPARE gglq707_pb FROM g_sql
   DECLARE aed_curs  CURSOR FOR gglq707_pb

   CALL g_aed.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   
   CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc211 
   CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc212 

   FOREACH aed_curs INTO g_aed[g_cnt].*,l_type,l_memo
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_aed[g_cnt].d      = cl_numfor(g_aed[g_cnt].d,20,g_azi04)
      LET g_aed[g_cnt].c      = cl_numfor(g_aed[g_cnt].c,20,g_azi04)
      LET g_aed[g_cnt].bal    = cl_numfor(g_aed[g_cnt].bal,20,g_azi04)
      LET g_aed[g_cnt].pb_bal = cl_numfor(g_aed[g_cnt].pb_bal,20,g_azi04)
     
      SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag01=g_aed[g_cnt].aed01
     #IF (l_aag06='1' AND g_aed[g_cnt].dc="贷") OR (l_aag06='2' AND g_aed[g_cnt].dc="借") THEN
     IF (l_aag06='1' AND g_aed[g_cnt].dc=l_pb_dc212) OR (l_aag06='2' AND g_aed[g_cnt].dc=l_pb_dc211) THEN
        CASE l_aag06 
        #WHEN '1'  LET g_aed[g_cnt].dc="借"
        WHEN '1'  LET g_aed[g_cnt].dc=l_pb_dc211
        #WHEN '2'  LET g_aed[g_cnt].dc="贷"
        WHEN '2'  LET g_aed[g_cnt].dc=l_pb_dc212
        OTHERWISE 
        END CASE 
        LET g_aed[g_cnt].bal     =g_aed[g_cnt].bal*-1 
     END IF 
     #IF (l_aag06='1' AND g_aed[g_cnt].pb_dc="贷") OR (l_aag06='2' AND g_aed[g_cnt].pb_dc="借") THEN
     IF (l_aag06='1' AND g_aed[g_cnt].pb_dc=l_pb_dc212) OR (l_aag06='2' AND g_aed[g_cnt].pb_dc=l_pb_dc211) THEN
        CASE l_aag06 
        #WHEN '1'  LET g_aed[g_cnt].pb_dc="借"
        WHEN '1'  LET g_aed[g_cnt].pb_dc=l_pb_dc211
        #WHEN '2'  LET g_aed[g_cnt].pb_dc="贷"
        WHEN '2'  LET g_aed[g_cnt].pb_dc=l_pb_dc212
        OTHERWISE 
        END CASE 
        LET g_aed[g_cnt].pb_bal  =g_aed[g_cnt].pb_bal*-1        
     END IF 
     
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH

   CALL g_aed.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1

END FUNCTION

FUNCTION q707_out_1()
   LET g_prog = 'gglq707'
   LET g_sql = "aed03.aed_file.aed03,",     
               "aed01.aed_file.aed01,",
               "aag02.aag_file.aag02,",
               "aed04.aed_file.aed04,",
               "aed02.type_file.chr50,",
               "ahe02_d.ze_file.ze03,",
               "type.type_file.chr10,",
               "pb_dc.type_file.chr10,",
               "pb_bal.aed_file.aed05,",
               "memo.abb_file.abb04,",
               "d.aed_file.aed05,",
               "c.aed_file.aed05,",
               "dc.type_file.chr10,",
               "bal.aed_file.aed05 "

   LET l_table = cl_prt_temptable('gglq707',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?,    ? )                     "    
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

END FUNCTION

FUNCTION q707_out_2() 
   DEFINE   l_pb_dc      LIKE type_file.chr10,
            l_dc         LIKE type_file.chr10
   DEFINE l_gen02        LIKE gen_file.gen02   

   LET g_prog = 'gglq707'
   CALL cl_del_data(l_table)

   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_user   
   
   DECLARE cr_curs CURSOR FOR
    SELECT * FROM gglq707_tmp
     ORDER BY aed01,type,aed04
   FOREACH cr_curs INTO g_pr.*

        EXECUTE insert_prep USING g_pr.* 

   END FOREACH

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'aed01')
           RETURNING g_str
   END IF
  #LET g_str=g_str CLIPPED,";",tm.yy,";",g_azi04,";",tm.a,";",l_gen02     #FUN-D10099 mark
   LET g_str=g_str CLIPPED,";",tm.y,";",g_azi04,";",tm.a,";",l_gen02      #FUN-D10099 add

   CALL cl_prt_cs3('gglq707','gglq707',g_sql,g_str)
END FUNCTION


FUNCTION gglq707_get_ahe02(p_aag01_str,p_aed02,p_aag01) 
  DEFINE p_aag01_str     LIKE type_file.chr50
  DEFINE p_aed02         LIKE aed_file.aed02
  DEFINE l_ahe01         LIKE ahe_file.ahe01
  DEFINE l_ahe03         LIKE ahe_file.ahe03             
  DEFINE l_ahe04         LIKE ahe_file.ahe04
  DEFINE l_ahe05         LIKE ahe_file.ahe05
  DEFINE l_ahe07         LIKE ahe_file.ahe07
  DEFINE l_sql1          LIKE type_file.chr1000
  DEFINE l_ahe02_d       LIKE ze_file.ze03
  DEFINE p_aag01         LIKE aag_file.aag01             
  DEFINE l_n             LIKE type_file.num5

     
     LET l_ahe01 = NULL
     OPEN gglq707_gaq01_cs USING p_aag01_str
     IF SQLCA.sqlcode THEN
        CLOSE gglq707_gaq01_cs
        RETURN NULL
     END IF
     FETCH FIRST gglq707_gaq01_cs INTO l_ahe01
     IF SQLCA.sqlcode THEN
        CLOSE gglq707_gaq01_cs
        RETURN NULL
     END IF
     CLOSE gglq707_gaq01_cs
     IF NOT cl_null(l_ahe01) THEN
        SELECT ahe03,ahe04,ahe05,ahe07 INTO l_ahe03,l_ahe04,l_ahe05,l_ahe07
          FROM ahe_file
         WHERE ahe01 = l_ahe01
        IF l_ahe03 = '1' THEN 
           IF NOT cl_null(l_ahe04) AND NOT cl_null(l_ahe05) AND
              NOT cl_null(l_ahe07) THEN
              LET l_sql1 = "SELECT UNIQUE ",l_ahe07 CLIPPED,
                           "  FROM ",l_ahe04 CLIPPED,
                           " WHERE ",l_ahe05 CLIPPED," = '",p_aed02,"'"
              PREPARE ahe_p1 FROM l_sql1
              EXECUTE ahe_p1 INTO l_ahe02_d
           END IF
        ELSE
           SELECT COUNT(*) INTO l_n FROM aee_file
            WHERE aee00 = tm.o
              AND aee01 = p_aag01
              AND aee03 = p_aed02
           IF l_n > 1 THEN 
              SELECT DISTINCT aee04 INTO l_ahe02_d FROM aee_file
               WHERE aee00 = tm.o
                 AND aee01 = p_aag01
                 AND aee02 = tm.a
                 AND aee03 = p_aed02
           ELSE
              SELECT DISTINCT aee04 INTO l_ahe02_d FROM aee_file
               WHERE aee00 = tm.o
                 AND aee01 = p_aag01
                 AND aee03 = p_aed02
           END IF 
        END IF
     END IF
     RETURN l_ahe02_d
END FUNCTION

FUNCTION q707_drill_detail()
   DEFINE l_wc1   LIKE type_file.chr50
   DEFINE l_wc2   LIKE type_file.chr50
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat

   IF g_aed02 IS NULL THEN RETURN END IF
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_aed[l_ac].aed01) THEN RETURN END IF

   LET l_wc1 = 'aag01 like "',g_aed[l_ac].aed01,'%"'
   LET l_wc2 = 'ted02 = "',g_aed02,'"'

   #CALL s_azn01(tm.yy,g_aed[l_ac].mm) RETURNING l_bdate,l_edate      #FUN-D10099 mark
    CALL s_azn01(tm.y,g_aed[l_ac].mm) RETURNING l_bdate,l_edate      #FUN-D10099 add

  #LET g_msg = "gglq702 '",tm.o,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc1 CLIPPED,"' '",l_wc2 CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.a,"' 'N' '",tm.b,"' '' '' '' ''" #FUN-D10099 amrk
   #FUN-D10099--add--str--
   IF tm.b = '1' THEN
      LET g_msg = "gglq702 '",tm.o,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc1 CLIPPED,"' '",l_wc2 CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.a,"' 'N' '",tm.b,"' 'N' '' '' '' '' '' 'Y'"
   END IF
   IF tm.b = '2' THEN
      LET g_msg = "gglq702 '",tm.o,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc1 CLIPPED,"' '",l_wc2 CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.a,"' 'N' '1' 'N' '' '' '' '' '' 'N'"
   END IF
   IF tm.b = '3' THEN
      LET g_msg = "gglq702 '",tm.o,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc1 CLIPPED,"' '",l_wc2 CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.a,"' 'N' '2' 'N' '' '' '' '' '' 'N'"
   END IF
   #FUN-D10099--add--end--
  
   CALL cl_cmdrun(g_msg)

END FUNCTION
