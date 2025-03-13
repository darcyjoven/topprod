# Prog. Version..: '5.30.07-13.05.20(00007)'     #
#
# Pattern name...: gglq708.4gl
# Descriptions...: 核算項科目明細帳-依核算项
# Date & Author..: 10/11/23 By Elva  No.FUN-AB0104
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No:CHI-C70031 12/10/18 By fengmy 去除CE、CA憑證資料，否則月末結轉損益後，查詢不到損益類科目
# Modify.........: No:FUN-C80102 12/10/18 By zhangweib 報表改善追單
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.TQC-CC0122 12/12/28 By yangtt 部分核算項值沒有期初餘額，且排序混亂
# Modify.........: No:FUN-D40044 13/04/25 By zhangweib 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額
# Modify.........: No.TQC-D60037 13/06/06 By wangrr 修改憑證編號開窗條件,當未勾選"按幣別分頁"時,憑證明細查詢時不需要考慮原幣

DATABASE ds

GLOBALS "../../config/top.global" 

   DEFINE tm      RECORD
                  wc1      STRING,
                  wc2      STRING,
                  wc3      STRING,   #FUN-C80102 add
                  wc4      STRING,   #FUN-C80102 add
                  a        LIKE type_file.chr2,
                  b        LIKE type_file.chr2,
                 #c        LIKE type_file.chr2,   #FUN-C80102 mark
                  c1       LIKE type_file.chr2,   #FUN-C80102 add
                  f        LIKE type_file.chr1,   #FUN-C80102 add
                  more     LIKE type_file.chr1,
                  e        LIKE type_file.chr1    #NO.FUN-D40044   Add
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
DEFINE   g_aba04    LIKE aba_file.aba04
DEFINE   g_abb      DYNAMIC ARRAY OF RECORD 
                    aag01      LIKE aag_file.aag01,
                    aag02      LIKE aag_file.aag02,
                    ted02      LIKE ted_file.ted02,    #FUN-C80102 add
                    ted02_1    LIKE ze_file.ze03,      #FUN-C80102 add
                    yy         LIKE aao_file.aao03,     #单头部门年度月份放到单身
                    mm         LIKE aao_file.aao04,     #单头部门年度月份放到单身
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
                    yy       LIKE aao_file.aao03,
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
DEFINE   l_ac_t         LIKE type_file.num10  #No.100301
DEFINE   g_comb         ui.ComboBox           #FUN-C80102 add
DEFINE   g_abb24        LIKE abb_file.abb24   #FUN-C80102 add

MAIN   #FUN-AB0104
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
   LET tm.wc2     = ARG_VAL(9)
   LET bdate      = ARG_VAL(10)
   LET edate      = ARG_VAL(11)
   LET tm.a       = ARG_VAL(12)
   LET tm.b       = ARG_VAL(13)
  #LET tm.c       = ARG_VAL(14)       #FUN-C80102 mark
   LET tm.c1      = ARG_VAL(14)       #FUN-C80102 add
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)

   CALL q708_out_1()
   IF bookno IS NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81
   END IF

   OPEN WINDOW q708_w AT 5,10
 #       WITH FORM "ggl/42f/gglq708_1" ATTRIBUTE(STYLE = g_win_style)   #FUN-C80102 mark
         WITH FORM "ggl/42f/gglq708" ATTRIBUTE(STYLE = g_win_style)     #FUN-C80102 mark

   CALL cl_ui_init()

   #No.10020502--begin--
   CALL cl_qbe_init()
   #No.10020502--end--

#FUN-C80102---mark---str---
#  IF cl_null(g_bgjob) OR g_bgjob = 'N'
#     THEN CALL gglq708_tm()
#     ELSE CALL gglq708()
#          CALL gglq708_t()
#  END IF
#FUN-C80102---mark---end---

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

   CALL gglq708_tm()    #FUN-C80102 add
   CALL q708_menu()
   DROP TABLE gglq708_tmp;
   CLOSE WINDOW q708_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q708_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL q708_bp("G")
      LET l_ac_t = l_ac     #No.100301 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq708_tm()
               LET l_ac_t = 0       #No.100301
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q708_out_2()
            END IF
         WHEN "drill_down"
            IF cl_chk_act_auth() THEN
               CALL q708_drill_down()
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

FUNCTION gglq708_tm()
   DEFINE p_row,p_col     LIKE type_file.num5,
          l_i             LIKE type_file.num5,
          l_cmd           LIKE type_file.chr1000
   DEFINE lc_qbe_sn       LIKE gbm_file.gbm01  #No.10020502
   DEFINE li_chk_bookno   LIKE type_file.num5  #No.FUN-B20010 
   
   CALL s_dsmark(bookno)
  #FUN-C80102---mark---str---
  #LET p_row = 4 LET p_col = 12
  #OPEN WINDOW gglq708_w1 AT p_row,p_col
  #     WITH FORM "ggl/42f/gglq708"
  #     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  #CALL cl_ui_locale("gglq708")
 #FUN-C80102---mark---end---

   CALL s_shwact(0,0,bookno)
   CALL cl_opmsg('p')
   #FUN-C80102---add----str---
   CLEAR FORM #清除畫面   
   CALL g_abb.clear()
   CALL cl_set_comp_visible("abb24,abb25,df,cf,balf",FALSE)
   CALL cl_set_comp_visible("abb25_d,abb25_c,abb25_bal",FALSE)
   CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
   CALL cl_set_comp_att_text("d",g_msg CLIPPED)
   CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
   CALL cl_set_comp_att_text("c",g_msg CLIPPED)
   CALL cl_getmsg("ggl-209",g_lang) RETURNING g_msg
   CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   #FUN-C80102---add----end---
  #INITIALIZE tm.* TO NULL  #No.100205 mark
#  LET bdate   = g_today    #FUN-C80102 mark
   LET bdate   = g_today - DAY(g_today) + 1    #FUN-C80102 add
   LET edate   = g_today
   LET tm.a    = '1'
   LET tm.b    = 'N'
  #LET tm.c    = 'N' #modify by mb090923
  #LET tm.c    = '1'     FUN-C80120 mark
   LET tm.c1   = '1'     #FUN-C80102 add
   LET tm.f    = 'N'     #FUN-C80102 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.e = 'N'        #No.FUN-D40044  Add
   WHILE TRUE
     #No.FUN-B20010  --Begin
     DIALOG ATTRIBUTE(unbuffered)
    #INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS)    #FUN-C80102 mark
     
     
     INPUT BY NAME bookno,tm.c1,bdate,edate,tm.b,tm.f,tm.a,tm.e ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-C80102 add  #No.FUN-D40044 Add tm.e
          
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
       
       #No.FUN-B20010 --Begin
       #AFTER FIELD bookno
       #   IF cl_null(bookno) THEN NEXT FIELD bookno END IF
       #   SELECT aaa02 FROM aaa_file WHERE aaa01=bookno AND aaaacti IN ('Y','y')
       #   IF STATUS THEN CALL cl_err('sel aaa:',STATUS,0) NEXT FIELD bookno END IF
       #No.FUN-B20010 --End
       
       #FUN-C80120----add----str--
        ON CHANGE b
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
           ELSE
              CALL cl_set_comp_visible("abb24,abb25,df,cf,balf",FALSE)
              CALL cl_set_comp_visible("abb25_d,abb25_c,abb25_bal",FALSE)
              CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("d",g_msg CLIPPED)
              CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("c",g_msg CLIPPED)
              CALL cl_getmsg("ggl-209",g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
           END IF

        AFTER FIELD bdate
           IF cl_null(bdate) THEN
              NEXT FIELD bdate
           END IF

        AFTER FIELD edate
           IF cl_null(edate) THEN
              LET edate =g_lastdat
           ELSE
            # IF YEAR(bdate) <> YEAR(edate) THEN NEXT FIELD edate END IF   #FUN-C80102 mark
              IF s_get_aznn(g_plant,g_aza.aza81,bdate,1) <> s_get_aznn(g_plant,g_aza.aza81,edate,1) THEN   #FUN-C80102 add
                 CALL cl_err(' ','ggl-900',0)    #TQC-CC0122 add
                 NEXT FIELD edate       #FUN-C80102 add
              END IF      #FUN-C80102 add
           END IF
           IF edate < bdate THEN
              CALL cl_err(' ','agl-031',0)
              NEXT FIELD edate
           END IF

        AFTER FIELD a
           IF tm.a NOT MATCHES "[123456789]" AND tm.a <> "10"
              AND tm.a <> "99" THEN  
              NEXT FIELD a
           END IF

        AFTER FIELD b
           IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF

      # AFTER FIELD c        #FUN-C80120 mark
      #    IF cl_null(tm.c) OR tm.c NOT MATCHES '[123]' THEN NEXT FIELD c END IF    #FUN-C80120 mark
        AFTER FIELD c1       #FUN-C80120 add
           IF cl_null(tm.c1) OR tm.c1 NOT MATCHES '[123]' THEN NEXT FIELD c1 END IF  #FUN-C80120 add

        AFTER FIELD f
             IF tm.f='Y' THEN
                LET tm.b='Y'
                DISPLAY BY NAME tm.b
             END IF

          ON CHANGE f
             IF tm.f='Y' THEN
                LET tm.b='Y'
                DISPLAY BY NAME tm.b
             END IF
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
           ELSE
              CALL cl_set_comp_visible("abb24,abb25,df,cf,balf",FALSE)
              CALL cl_set_comp_visible("abb25_d,abb25_c,abb25_bal",FALSE)
              CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("d",g_msg CLIPPED)
              CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("c",g_msg CLIPPED)
              CALL cl_getmsg("ggl-209",g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
           END IF
       #FUN-C80120----add----end--

     END INPUT
     #No.FUN-B20010  --End
     CONSTRUCT BY NAME tm.wc1 ON aag01
#No.FUN-B20010  --Mark Begin
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(aag01)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_aag'
#                 LET g_qryparam.state= 'c'
#                 LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"   #FUN-B20010 add                 
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO aag01
#                 NEXT FIELD aag01
#           END CASE
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
#
#       #No.10020502--begin--
#        ON ACTION qbe_select
#           CALL cl_qbe_select()
#       #No.10020502---end---
#No.FUN-B20010  --Mark End
     END CONSTRUCT
#No.FUN-B20010  --Mark Begin
#     IF g_action_choice = "locale" THEN
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE
#     END IF
#
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0 CLOSE WINDOW gglq708_w1 EXIT PROGRAM
#     END IF
#No.FUN-B20010  --Mark End
     CONSTRUCT BY NAME tm.wc2 ON ted02

       #No.10020502--begin--
        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
       #No.10020502---end---
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
#
#        #No.100205--begin--
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#        #No.100205---end---
#No.FUN-B20010  --Mark End
     END CONSTRUCT
#No.FUN-B20010  --Mark Begin
#     IF g_action_choice = "locale" THEN
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE
#     END IF
#     IF INT_FLAG THEN
#         LET INT_FLAG = 0 CLOSE WINDOW gglq708_w1 EXIT PROGRAM
#     END IF
#
#     DISPLAY BY NAME tm.a,tm.b,tm.c,tm.more
#     INPUT BY NAME bookno,bdate,edate,tm.a,tm.b,tm.c,tm.more  WITHOUT DEFAULTS
#No.FUN-B20010  --Mark End

    #FUN-C80102-----mark----str---
    #INPUT BY NAME bdate,edate,tm.a,tm.b,tm.c,tm.more ATTRIBUTE(WITHOUT DEFAULTS) #FUN-B20010 去掉bookno        
    #
    #   #No.10020502--begin--
    #   BEFORE INPUT
    #       CALL cl_qbe_display_condition(lc_qbe_sn)
    #   #No.10020502---end---
    #  
    #  #No.FUN-B20010 --Begin
    #  #AFTER FIELD bookno
    #  #   IF cl_null(bookno) THEN NEXT FIELD bookno END IF
    #  #   SELECT aaa02 FROM aaa_file WHERE aaa01=bookno AND aaaacti IN ('Y','y')
    #  #   IF STATUS THEN CALL cl_err('sel aaa:',STATUS,0) NEXT FIELD bookno END IF
    #  #No.FUN-B20010 --End
    #  
    #   AFTER FIELD bdate
    #      IF cl_null(bdate) THEN
    #         NEXT FIELD bdate
    #      END IF
    #
    #   AFTER FIELD edate
    #      IF cl_null(edate) THEN
    #         LET edate =g_lastdat
    #      ELSE
    #         IF YEAR(bdate) <> YEAR(edate) THEN NEXT FIELD edate END IF
    #      END IF
    #      IF edate < bdate THEN
    #         CALL cl_err(' ','agl-031',0)
    #         NEXT FIELD edate
    #      END IF
    #
    #   AFTER FIELD a
    #      IF tm.a NOT MATCHES "[123456789]" AND tm.a <> "10"
    #         AND tm.a <> "99" THEN   #add by chenyu --090319
    #        #AND tm.a <> "11" THEN   #mark by chenyu --090319
    #         NEXT FIELD a
    #      END IF
    #
    #   AFTER FIELD b
    #      IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF
    #
    #   AFTER FIELD c
    #      IF cl_null(tm.c) OR tm.c NOT MATCHES '[123]' THEN NEXT FIELD c END IF
    #
    #   AFTER FIELD more
    #      IF tm.more = 'Y'
    #         THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
    #                   g_bgjob,g_time,g_prtway,g_copies)
    #         RETURNING g_pdate,g_towhom,g_rlang,
    #                   g_bgjob,g_time,g_prtway,g_copies
    #      END IF
    #FUN-C80102-----mark----str---
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
#
#        #No.100205--begin--
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#        #No.100205---end---
#No.FUN-B20010  --Mark End
    #END INPUT       #FUN-C80102 mark
     #No.FUN-B20010  --Begin
    #FUN-C80102---add---str--
    CONSTRUCT BY NAME tm.wc4 ON yy,mm,aba02,aba01

        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    CONSTRUCT BY NAME tm.wc3 ON abb24

        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    #FUN-C80102---add---end--
     ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bookno)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_aaa'
                 LET g_qryparam.default1 =bookno
                 CALL cl_create_qry() RETURNING bookno
                 DISPLAY BY NAME bookno
                 NEXT FIELD bookno
               WHEN INFIELD(aag01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_aag'
                 LET g_qryparam.state= 'c'
                 LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"   #FUN-B20010 add                 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aag01
                 NEXT FIELD aag01
              WHEN INFIELD(ted02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_ted'
                 LET g_qryparam.state= 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ted02
                 NEXT FIELD ted02
              WHEN INFIELD(abb24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_azi'
                 LET g_qryparam.state= 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO abb24
                 NEXT FIELD abb24
              WHEN INFIELD(aba01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_aba'
                 LET g_qryparam.state= 'c'
                #LET g_qryparam.where = " aba00 = '",bookno CLIPPED,"'" #TQC-D60037 mark
                 LET g_qryparam.arg1=bookno #TQC-D60037
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aba01
                 NEXT FIELD aba01
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
   #No.FUN-B20010  --End
   IF INT_FLAG THEN
     #LET INT_FLAG = 0 CLOSE WINDOW gglq708_w1     #FUN-C80102 mark
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211   #FUN-C80102 mark
     #EXIT PROGRAM     #FUN-C80102 mark
     LET INT_FLAG = 0  #FUN-C80102 add
     RETURN    #FUN-C80102 add
   END IF
    
    #FUN-C80102-----str---
    #LET mm1 = MONTH(bdate)
    #LET nn1 = MONTH(edate)
     LET mm1 = s_get_aznn(g_plant,g_aza.aza81,bdate,3) 
     LET nn1 = s_get_aznn(g_plant,g_aza.aza81,edate,3)
    #FUN-C80102-----end---
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
    #FUN-C80102-----mark---str--
    #IF g_bgjob = 'Y' THEN
    #   SELECT zz08 INTO l_cmd FROM zz_file
    #    WHERE zz01='gglq708'
    #   IF SQLCA.sqlcode OR l_cmd IS NULL THEN
    #      CALL cl_err('gglq708','9031',1)
    #   ELSE
    #      LET tm.wc1=cl_wcsub(tm.wc1)
    #      LET l_cmd = l_cmd CLIPPED,
    #                 " '",bookno CLIPPED,"'",
    #                 " '",g_pdate CLIPPED,"'",
    #                 " '",g_towhom CLIPPED,"'",
    #                 " '",g_rlang CLIPPED,"'",
    #                 " '",g_bgjob CLIPPED,"'",
    #                 " '",g_prtway CLIPPED,"'",
    #                 " '",g_copies CLIPPED,"'",
    #                 " '",tm.wc1 CLIPPED,"'",
    #                 " '",tm.wc2 CLIPPED,"'",
    #                 " '",bdate CLIPPED,"'",
    #                 " '",edate CLIPPED,"'",
    #                 " '",tm.a CLIPPED,"'",
    #                 " '",tm.b CLIPPED,"'",
    #                 " '",tm.c CLIPPED,"'",
    #                 " '",g_rep_user CLIPPED,"'",
    #                 " '",g_rep_clas CLIPPED,"'",
    #                 " '",g_template CLIPPED,"'",
    #                 " '",g_rpt_name CLIPPED,"'"
    #      CALL cl_cmdat('gglq708',g_time,l_cmd)
    #   END IF
    #   CLOSE WINDOW gglq708_w1
    #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
    #   EXIT PROGRAM
    #END IF
    #FUN-C80102-----mark---end--
     CALL cl_wait()
     CALL gglq708()
     ERROR ""
     EXIT WHILE
   END WHILE
 # CLOSE WINDOW gglq708_w1    #FUN-C80102 mark
   CALL gglq708_t()
   #FUN-C80102----add--str--
   IF tm.f='Y' THEN
      CALL gglq708_cs1()
   ELSE 
      LET g_curs_index=0
      LET g_row_count=0
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL gglq708_show()
   END IF
   #FUN-C80102----add--end--

END FUNCTION

FUNCTION gglq708_curs()
  DEFINE l_sql   LIKE type_file.chr1000
  DEFINE l_sql1  LIKE type_file.chr1000
  DEFINE l_wc2   LIKE type_file.chr1000

    #FUN-C80102---str---
    #LET mm1 = MONTH(bdate)
    #LET nn1 = MONTH(edate)
     LET mm1 = s_get_aznn(g_plant,g_aza.aza81,bdate,3) 
     LET nn1 = s_get_aznn(g_plant,g_aza.aza81,edate,3)
    #FUN-C80102---end---
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
     CASE tm.a
          WHEN '1'   LET g_field = 'abb11'
                     LET g_gaq01 = 'aag15'
          WHEN '2'   LET g_field = 'abb12'
                     LET g_gaq01 = 'aag16'
          WHEN '3'   LET g_field = 'abb13'
                     LET g_gaq01 = 'aag17'
          WHEN '4'   LET g_field = 'abb14'
                     LET g_gaq01 = 'aag18'
          WHEN '5'   LET g_field = 'abb31'
                     LET g_gaq01 = 'aag31'
          WHEN '6'   LET g_field = 'abb32'
                     LET g_gaq01 = 'aag32'
          WHEN '7'   LET g_field = 'abb33'
                     LET g_gaq01 = 'aag33'
          WHEN '8'   LET g_field = 'abb34'
                     LET g_gaq01 = 'aag34'
          WHEN '9'   LET g_field = 'abb35'
                     LET g_gaq01 = 'aag35'
          WHEN '10'  LET g_field = 'abb36'
                     LET g_gaq01 = 'aag36'
          WHEN '99'  LET g_field = 'abb37'  
                     LET g_gaq01 = 'aag37'
     END CASE
     IF cl_null(g_field) THEN 
        LET g_field = 'abb11'
     END IF
     IF cl_null(g_gaq01) THEN
        LET g_gaq01 = 'aag15'
     END IF

     IF g_priv2='4' THEN
        LET tm.wc1 = tm.wc1 CLIPPED," AND aaguser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN
        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     END IF
     IF g_priv3 MATCHES "[5678]" THEN
        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup IN ",cl_chk_tgrup_list()
     END IF

     #查找科目
     LET l_sql1= "SELECT aag01,aag02 FROM aag_file ",
                 " WHERE aag03 ='2' ",
                 "   AND aag00 = '",bookno,"' ",
                 "   AND aag07 <> '1' ",           #一級統治不要出來,BY蔡曉峰規定
                 "   AND ",tm.wc1 CLIPPED
     PREPARE gglq708_aag01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglq708_aag01_cs CURSOR FOR gglq708_aag01_p

     #查找核算項
     LET l_sql1 = "SELECT UNIQUE ted02,ted09 FROM ted_file ",   #No.FUN-D40044   Add ted09
                  " WHERE ted00 = '",bookno,"'",
                  "   AND ted01 LIKE ? ",           #account
                  "   AND ted011 = '",tm.a,"'",
                  "   AND ",tm.wc2 CLIPPED
     PREPARE gglq708_ted02_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq708_ted02_cs1 CURSOR FOR gglq708_ted02_p1

     LET l_wc2 = tm.wc2
     LET l_wc2 = cl_replace_str(l_wc2,"ted02",g_field)
     LET l_sql1 = " SELECT ",g_field CLIPPED,",abb24 FROM aba_file,abb_file",   #No.FUN-D40044 Add abb24
                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                  "    AND aba00 = '",bookno,"'",
                  "    AND abb03 LIKE ? ",       #account
                  "    AND ",g_field CLIPPED," IS NOT NULL",
                 #"    AND aba19 = 'Y'   AND abapost = 'N'", 
                  "    AND ",l_wc2,
                  "  AND abaacti='Y' ",
                  "  AND aba19 <> 'X' "  #CHI-C80041
     IF tm.c1='2' THEN      #FUN-C80102 tm.c -> tm.c1
        LET l_sql1 = l_sql1 CLIPPED," AND aba19 = 'Y' "
     END IF
     IF tm.c1='3' THEN      #FUN-C80102 tm.c -> tm.c1
        LET l_sql1 = l_sql1 CLIPPED," AND abapost = 'Y' "
     END IF
     #End   ---

     PREPARE gglq708_ted02_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq708_ted02_cs2 CURSOR FOR gglq708_ted02_p2

     #查找核算項值
     LET l_sql1 = " SELECT ",g_gaq01 CLIPPED," FROM aag_file ",
                  "  WHERE aag00 = '",bookno,"'",
                  "    AND aag01 LIKE ? ",
                  "    AND aag07 IN ('2','3') ",
                  "    AND ",g_gaq01 CLIPPED," IS NOT NULL"
     PREPARE gglq708_gaq01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq708_gaq01_cs SCROLL CURSOR FOR gglq708_gaq01_p  #只能取第一個

     #期初余額
     #1~mm-1
     LET l_sql = "SELECT SUM(ted05),SUM(ted06),SUM(ted10),SUM(ted11) FROM ted_file",
                 " WHERE ted00 = '",bookno,"'",
                 "   AND ted01 LIKE ? ",                  #科目
                 "   AND ted02 = ? ",                     #核算項
                 "   AND ted011 = '",tm.a,"'",
                 "   AND ted03 = ",yy,
                 "   AND ted04 < ",mm                     #期初
     PREPARE gglq708_qc1_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq708_qc1_cs CURSOR FOR gglq708_qc1_p
     #mm(1~bdate-1)
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file a,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND abb06 = ? ",
                 "    AND aba03 = ",yy,
                 "    AND aba04 = ",mm,
                 "    AND aba02 < '",bdate,"'",
                 "    AND aba19 = 'Y' AND abapost = 'Y'"  #過帳
    #No.FUN-D40044 ---add--- str
    #根據單頭條件,判斷是否包含結轉憑證
     IF tm.e = 'N' THEN
        LET l_sql = l_sql CLIPPED," AND NOT EXISTS (",
            " SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01 ",
            "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))"
     END IF
    #No.FUN-D40044 ---add--- end
     PREPARE gglq708_qc2_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq708_qc2_cs CURSOR FOR gglq708_qc2_p

     #tm.c = 'Y'--->tm.c=3
     #1~mm-1
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file a,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND abb06 = ? ",
                 "    AND aba03 = ",yy,
                 "    AND aba04 < ",mm,
                #"    AND aba19 = 'Y' AND abapost = 'N'"  #期初未過帳
                 "    AND abaacti = 'Y' AND abapost = 'N'",  #期初未過帳
                 "    AND aba19 <> 'X' "  #CHI-C80041
                 IF tm.c1='2' THEN     #FUN-C80102 tm.c -> tm.c1
                    LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
                 END IF 
                #End   ---
    #No.FUN-D40044 ---add--- str
    #根據單頭條件,判斷是否包含結轉憑證
     IF tm.e = 'N' THEN
        LET l_sql = l_sql CLIPPED," AND NOT EXISTS (",
            " SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01 ",
            "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))"
     END IF
    #No.FUN-D40044 ---add--- end
     PREPARE gglq708_qc3_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq708_qc3_cs CURSOR FOR gglq708_qc3_p
     #mm(1~bdate-1)
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file a,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND aba03 = ",yy,
                 "    AND aba04 = ",mm,
                 "    AND abb06 = ? ",
                 "    AND aba02 < '",bdate,"'",
                #"    AND aba19 = 'Y' AND abapost = 'N'"  #期初未過帳
                 "    AND abaacti = 'Y' AND abapost = 'N'",  #期初未過帳
                 "    AND aba19 <> 'X' "  #CHI-C80041
                 IF tm.c1='2' THEN     #FUN-C80102 tm.c -> tm.c1
                    LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
                 END IF 
    #No.FUN-D40044 ---add--- str
    #根據單頭條件,判斷是否包含結轉憑證
     IF tm.e = 'N' THEN
        LET l_sql = l_sql CLIPPED," AND NOT EXISTS (",
            " SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01 ",
            "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))"
     END IF
    #No.FUN-D40044 ---add--- end
     PREPARE gglq708_qc4_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq708_qc4_cs CURSOR FOR gglq708_qc4_p

     #當期異動
     LET l_sql = " SELECT '','','','','',0,aba02,aba01,abb04,",
                 "        abb06,abb07,abb07f,abb24,abb25, ",
                 "        0,0,0,0,0,0,0,0,0,0             ",
                 "   FROM aba_file a,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND aba03 = ",yy,
                 "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
                #"    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN ",         #CHI-C70031  #No.FUN-D40044   Mark
                #"        (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))", #CHI-C70031  #No.FUN-D40044   Mark
                 "    AND aba04 = ? ",
                 "    AND abaacti='Y' ",
                 "    AND aba19 <> 'X' "  #CHI-C80041
     IF tm.c1='2' THEN #已审核    #FUN-C80102 tm.c -> tm.c1
        LET l_sql = l_sql CLIPPED," AND aba19 = 'Y'"
     END IF 
     IF tm.c1='3' THEN #已过帐    #FUN-C80102 tm.c -> tm.c1
        LET l_sql = l_sql CLIPPED," AND abapost = 'Y'"
     END IF 
    #End   ---
    #No.FUN-D40044 ---add--- str
    #根據單頭條件,判斷是否包含結轉憑證
     IF tm.e = 'N' THEN
        LET l_sql = l_sql CLIPPED," AND NOT EXISTS (",
            " SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01 ",
            "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))"
     END IF
    #No.FUN-D40044 ---add--- end

     PREPARE gglq708_qj1_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq708_qj1_cs CURSOR FOR gglq708_qj1_p

END FUNCTION

FUNCTION gglq708()
   DEFINE l_name               LIKE type_file.chr20,
          l_sql,l_sql1         LIKE type_file.chr1000,
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
                               yy       LIKE aao_file.aao03,
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
  #No.FUN-D40044 ---add--- str
   DEFINE l_ted09              LIKE ted_file.ted09
   DEFINE l_aeh11              LIKE aeh_file.aeh11
   DEFINE l_aeh12              LIKE aeh_file.aeh12
   DEFINE l_aeh15              LIKE aeh_file.aeh15
   DEFINE l_aeh16              LIKE aeh_file.aeh16
   DEFINE l_aaa09              LIKE aaa_file.aaa09
   DEFINE l_aeh03              LIKE aeh_file.aeh03
   DEFINE l_aeh04              LIKE aeh_file.aeh04
   DEFINE l_aeh05              LIKE aeh_file.aeh05
   DEFINE l_aeh06              LIKE aeh_file.aeh06
   DEFINE l_aeh07              LIKE aeh_file.aeh07
   DEFINE l_aeh31              LIKE aeh_file.aeh31
   DEFINE l_aeh32              LIKE aeh_file.aeh32
   DEFINE l_aeh33              LIKE aeh_file.aeh33
   DEFINE l_aeh34              LIKE aeh_file.aeh34
   DEFINE l_aeh35              LIKE aeh_file.aeh35
   DEFINE l_aeh36              LIKE aeh_file.aeh36
   DEFINE l_aeh37              LIKE aeh_file.aeh37
  #No.FUN-D40044 ---add--- str

     CALL gglq708_table()

     CALL gglq708_curs()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang

     FOREACH gglq708_aag01_cs INTO sr1.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach gglq708_aag01_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr1.aag01 CLIPPED,'%'
        FOREACH gglq708_ted02_cs1 USING l_aag01_str
                                  INTO l_ted02,l_ted09 #No.FUN-D40044 Add l_ted09
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq708_ted02_cs1',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #get dimension description
          #CALL gglq708_get_ahe02(l_aag01_str,l_ted02)           #No.100113 mark
           CALL gglq708_get_ahe02(l_aag01_str,l_ted02,sr1.aag01) #No.100113 
                RETURNING l_ted02_d
           INSERT INTO gglq708_ted_tmp VALUES(sr1.aag01,sr1.aag02,l_ted02,l_ted02_d,l_ted09)#No.FUN-D40044 Add l_ted09
#          IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN #CHI-C30115 mark
           IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
              CALL cl_err3('ins','gglq708_ted_tmp',sr1.aag01,l_ted02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH

        FOREACH gglq708_ted02_cs2 USING l_aag01_str
                                  INTO l_ted02,l_ted09 #No.FUN-D40044 Add l_ted09
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglq708_ted02_cs2',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #get dimension description
          #CALL gglq708_get_ahe02(l_aag01_str,l_ted02)            #No.100113 mark
           CALL gglq708_get_ahe02(l_aag01_str,l_ted02,sr1.aag01)  #No.100113
                RETURNING l_ted02_d
           INSERT INTO gglq708_ted_tmp VALUES(sr1.aag01,sr1.aag02,l_ted02,l_ted02_d,l_ted09)#No.FUN-D40044 Add l_ted09
#          IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN  #CHI-C30115 mark
           IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
              CALL cl_err3('ins','gglq708_ted_tmp',sr1.aag01,l_ted02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
     END FOREACH

     LET g_prog = 'gglr301'
     CALL cl_outnam('gglr301') RETURNING l_name
     START REPORT gglq708_rep TO l_name
     LET g_pageno = 0

    #No.FUN-D40044 ---add--- str
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
    #No.FUN-D40044 ---add--- end
     
     DECLARE gglq708_cs1 CURSOR FOR
      SELECT UNIQUE aag01,aag02,ted02,ted02_d,ted09 FROM gglq708_ted_tmp   #No.FUN-D40044   Add ted09
       ORDER BY aag01,ted02
     FOREACH gglq708_cs1 INTO sr2.*,l_ted09   #No.FUN-D40044   Add l_ted09
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach gglq708_cs1',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
       #No.FUN-D40044 ---add--- str
        CASE tm.a
           WHEN '1' LET l_aeh04 = sr2.ted02
           WHEN '2' LET l_aeh05 = sr2.ted02
           WHEN '3' LET l_aeh06 = sr2.ted02
           WHEN '4' LET l_aeh07 = sr2.ted02
           WHEN '5' LET l_aeh31 = sr2.ted02
           WHEN '6' LET l_aeh32 = sr2.ted02
           WHEN '7' LET l_aeh33 = sr2.ted02
           WHEN '8' LET l_aeh34 = sr2.ted02
           WHEN '9' LET l_aeh35 = sr2.ted02
           WHEN '10' LET l_aeh36 = sr2.ted02
           WHEN '99' LET l_aeh37 =sr2.ted02
        END CASE
       #No.FUN-D40044 ---add--- str
        IF cl_null(sr2.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr2.aag01 CLIPPED,'%'

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
        OPEN gglq708_qc1_cs USING l_aag01_str,sr2.ted02
        FETCH gglq708_qc1_cs INTO qc1_ted05,qc1_ted06,qc1_ted10,qc1_ted11
        CLOSE gglq708_qc1_cs
        IF cl_null(qc1_ted05) THEN LET qc1_ted05 = 0 END IF
        IF cl_null(qc1_ted06) THEN LET qc1_ted06 = 0 END IF
        IF cl_null(qc1_ted10) THEN LET qc1_ted10 = 0 END IF
        IF cl_null(qc1_ted11) THEN LET qc1_ted11 = 0 END IF
       #No.FUN-D40044 ---add--- str
        IF tm.e = 'N' THEN
           LET l_aeh11 = 0
           LET l_aeh12 = 0
           LET l_aeh15 = 0
           LET l_aeh16 = 0
           CALL s_minus_ce(bookno, l_aag01_str, l_aag01_str, NULL,NULL,NULL,
           l_aeh04,  l_aeh05,    l_aeh06,      l_aeh07,     NULL,    yy,
           0,        mm-1,       l_ted09,      l_aeh31,  l_aeh32,    l_aeh33,
           l_aeh34,  l_aeh35,      l_aeh36,    l_aeh37,     g_plant,  l_aaa09,'1')
              RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
           LET qc1_ted05 = qc1_ted05 - l_aeh11
           LET qc1_ted06 = qc1_ted06 - l_aeh12
           LET qc1_ted10 = qc1_ted10 - l_aeh15
           LET qc1_ted11 = qc1_ted11 - l_aeh16
        END IF
       #No.FUN-D40044 ---add--- str
        #mm(day 1~<bdate)
        OPEN gglq708_qc2_cs USING l_aag01_str,sr2.ted02,'1'
        FETCH gglq708_qc2_cs INTO qc2_ted05,qc2_ted10
        CLOSE gglq708_qc2_cs
        OPEN gglq708_qc2_cs USING l_aag01_str,sr2.ted02,'2'
        FETCH gglq708_qc2_cs INTO qc2_ted06,qc2_ted11
        CLOSE gglq708_qc2_cs
        IF cl_null(qc2_ted05) THEN LET qc2_ted05 = 0 END IF
        IF cl_null(qc2_ted06) THEN LET qc2_ted06 = 0 END IF
        IF cl_null(qc2_ted10) THEN LET qc2_ted10 = 0 END IF
        IF cl_null(qc2_ted11) THEN LET qc2_ted11 = 0 END IF

        IF tm.c1 MATCHES '[12]'  THEN #1 全部 2 已审核   #FUN-C80102 tm.c -> tm.c1
           #1~mm-1
           OPEN gglq708_qc3_cs USING l_aag01_str,sr2.ted02,'1'
           FETCH gglq708_qc3_cs INTO qc3_ted05,qc3_ted10
           CLOSE gglq708_qc3_cs
           OPEN gglq708_qc3_cs USING l_aag01_str,sr2.ted02,'2'
           FETCH gglq708_qc3_cs INTO qc3_ted06,qc3_ted11
           CLOSE gglq708_qc3_cs
           IF cl_null(qc3_ted05) THEN LET qc3_ted05 = 0 END IF
           IF cl_null(qc3_ted06) THEN LET qc3_ted06 = 0 END IF
           IF cl_null(qc3_ted10) THEN LET qc3_ted10 = 0 END IF
           IF cl_null(qc3_ted11) THEN LET qc3_ted11 = 0 END IF
           #mm(1~bdate-1)
           OPEN gglq708_qc4_cs USING l_aag01_str,sr2.ted02,'1'
           FETCH gglq708_qc4_cs INTO qc4_ted05,qc4_ted10
           CLOSE gglq708_qc4_cs
           OPEN gglq708_qc4_cs USING l_aag01_str,sr2.ted02,'2'
           FETCH gglq708_qc4_cs INTO qc4_ted06,qc4_ted11
           CLOSE gglq708_qc4_cs
           IF cl_null(qc4_ted05) THEN LET qc4_ted05 = 0 END IF
           IF cl_null(qc4_ted06) THEN LET qc4_ted06 = 0 END IF
           IF cl_null(qc4_ted10) THEN LET qc4_ted10 = 0 END IF
           IF cl_null(qc4_ted11) THEN LET qc4_ted11 = 0 END IF
        END IF
        LET qc_ted05 = qc1_ted05 + qc2_ted05 + qc3_ted05 + qc4_ted05
        LET qc_ted06 = qc1_ted06 + qc2_ted06 + qc3_ted06 + qc4_ted06
        LET qc_ted10 = qc1_ted10 + qc2_ted10 + qc3_ted10 + qc4_ted10
        LET qc_ted11 = qc1_ted11 + qc2_ted11 + qc3_ted11 + qc4_ted11

        LET l_qcye  = qc_ted05 - qc_ted06
        LET l_qcyef = qc_ted10 - qc_ted11
        #若t_qcye = 0 & 異間異動為零，則不打印
        LET t_qcye  = l_qcye
        LET t_qcyef = l_qcyef

        FOR l_i = mm1 TO nn1
            LET l_flag='N'
            FOREACH gglq708_qj1_cs USING l_aag01_str,sr2.ted02,l_i INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET l_flag='Y' 
               LET sr.yy = yy
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

               OUTPUT TO REPORT gglq708_rep(sr.*)
            END FOREACH
#130401-xh-add-str--
            IF l_flag = "N" THEN
               IF t_qcye = 0 AND t_qcyef = 0 THEN
                  CONTINUE FOR
               END IF
               INITIALIZE sr.* TO NULL
               LET sr.yy = yy
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
               OUTPUT TO REPORT gglq708_rep(sr.*)
            END IF
#130401-xh-add-end--
         
#FUN-C80102----mark---str---
{           IF l_flag = "N" THEN
               IF t_qcye = 0 AND t_qcyef = 0 THEN
                  CONTINUE FOR
               END IF
               INITIALIZE sr.* TO NULL 
               LET sr.yy = yy
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
               OUTPUT TO REPORT gglq708_rep(sr.*)
            END IF}   
#FUN-C80102----mark---end---
        END FOR
     END FOREACH

     FINISH REPORT gglq708_rep

END FUNCTION
#FUN-C80102----mark---str---
{
FUNCTION gglq708_cs()
      LET g_sql = "SELECT UNIQUE ted02,ted02_d",
                 "  FROM gglq708_tmp ",
                 " ORDER BY ted02 "
     PREPARE gglq708_ps FROM g_sql
     DECLARE gglq708_curs SCROLL CURSOR WITH HOLD FOR gglq708_ps

      LET g_sql = "SELECT UNIQUE ted02,ted02_d",
                 "  FROM gglq708_tmp ",
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq708_ps1 FROM g_sql
     EXECUTE gglq708_ps1

     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq708_ps2 FROM g_sql
     DECLARE gglq708_cnt CURSOR FOR gglq708_ps2

     OPEN gglq708_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq708_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq708_cnt
        FETCH gglq708_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq708_fetch('F')
     END IF
END FUNCTION

FUNCTION gglq708_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10

   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq708_curs INTO g_ted02,g_ted02_d
      WHEN 'P' FETCH PREVIOUS gglq708_curs INTO g_ted02,g_ted02_d
      WHEN 'F' FETCH FIRST    gglq708_curs INTO g_ted02,g_ted02_d
      WHEN 'L' FETCH LAST     gglq708_curs INTO g_ted02,g_ted02_d
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
         FETCH ABSOLUTE g_jump gglq708_curs INTO g_ted02,g_ted02_d
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aag01,SQLCA.sqlcode,0)
      INITIALIZE g_ted02 TO NULL
      INITIALIZE g_ted02_d TO NULL
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

   CALL gglq708_show()
END FUNCTION
}
#FUN-C80102----mark---end---
#FUN-C80102----add----str--
FUNCTION gglq708_cs1()   #FUN-C80102

     LET g_sql = "SELECT UNIQUE abb24 FROM gglq708_tmp ",
                 " ORDER BY abb24 "
     PREPARE gglq708_ps FROM g_sql
     DECLARE gglq708_curs SCROLL CURSOR WITH HOLD FOR gglq708_ps

     LET g_sql = "SELECT UNIQUE abb24 FROM gglq708_tmp ",
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq708_ps1 FROM g_sql
     EXECUTE gglq708_ps1

     LET g_sql = "SELECT COUNT(*) FROM x",
                 " WHERE ",tm.wc3 CLIPPED #FUN-C80102 add
     PREPARE gglq708_ps2 FROM g_sql
     DECLARE gglq708_cnt CURSOR FOR gglq708_ps2

     OPEN gglq708_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq708_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq708_cnt
        FETCH gglq708_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq708_fetch('F')
     END IF
END FUNCTION


FUNCTION gglq708_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10

   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq708_curs INTO g_abb24
      WHEN 'P' FETCH PREVIOUS gglq708_curs INTO g_abb24
      WHEN 'F' FETCH FIRST    gglq708_curs INTO g_abb24
      WHEN 'L' FETCH LAST     gglq708_curs INTO g_abb24
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
         FETCH ABSOLUTE g_jump gglq708_curs INTO g_abb24
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

   CALL gglq708_show()
END FUNCTION
#FUN-C80102----add----end--

FUNCTION gglq708_show()

   DISPLAY g_ted02 TO ted02
   DISPLAY g_ted02_d TO ted02_d
   DISPLAY tm.a TO a
   #FUN-C80102----add----str--
   DISPLAY bookno TO bookno
   DISPLAY bdate TO bdate
   DISPLAY edate TO edate
   DISPLAY tm.b TO b
   DISPLAY tm.c1 TO c1
   DISPLAY tm.f TO f
   #FUN-C80102----add----end--
   DISPLAY tm.e TO e   #No.FUN-D40044   Add

   CALL gglq708_b_fill()
   #FUN-C80102----add----str--
   IF tm.f='Y' THEN
      DISPLAY g_row_count TO FORMONLY.cnt
   ELSE
      DISPLAY g_rec_b TO FORMONLY.cnt
   END IF
   #FUN-C80102----add----end--

   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION gglq708_b_fill()
  DEFINE  l_abb06    LIKE abb_file.abb06
  DEFINE  l_type     LIKE type_file.chr1
  DEFINE  l_aag06    LIKE aag_file.aag06  
   
   LET g_sql = "SELECT aag01,aag02,ted02,ted02_d,yy,aba04,aba02,aba01,abb04,abb24,df,abb25_d,d,",  #FUN-C80102 add aed02,ted02_d  
               "       cf,abb25_c,c,dc,balf,abb25_bal,bal,",
               "       azi04,azi05,azi07,abb06,type ",
               "  FROM gglq708_tmp",
               " WHERE ",tm.wc4 CLIPPED," AND ",tm.wc3 CLIPPED  #FUN-C80102 add
              #" WHERE ted02 ='",g_ted02,"'"   #FUN-C80102 mark
              #" ORDER BY aag01,type,aba04,aba02,aba01,order_no "  #FUN-C80102 mark
   #FUN-C80102-----add---str--
   IF tm.f='Y' THEN
      LET g_sql=g_sql CLIPPED," AND abb24='",g_abb24,"' "
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY ted02,aag01,type,aba04,aba02,aba01,order_no "   #TQC-CC0122 add ted02
   #FUN-C80102-----add---end--

   PREPARE gglq708_pb FROM g_sql
   DECLARE abb_curs  CURSOR FOR gglq708_pb

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
      
#NO.130222 mark-------------------------------begin
      {IF l_type = '1' THEN
         LET g_abb[g_cnt].d = NULL
         LET g_abb[g_cnt].df= NULL
         LET g_abb[g_cnt].abb25_d= NULL
         LET g_abb[g_cnt].c = NULL
         LET g_abb[g_cnt].cf = NULL
         LET g_abb[g_cnt].abb25_c= NULL
         LET g_abb[g_cnt].balf= NULL
         LET g_abb[g_cnt].abb25_bal = NULL
      END IF
      IF l_type = '3' OR l_type = '4' THEN
         LET g_abb[g_cnt].df = NULL
         LET g_abb[g_cnt].abb25_d= NULL
         LET g_abb[g_cnt].cf = NULL
         LET g_abb[g_cnt].abb25_c= NULL
         LET g_abb[g_cnt].balf = NULL
         LET g_abb[g_cnt].abb25_bal = NULL
      END IF
      IF l_type = '2' THEN
         LET g_abb[g_cnt].balf= NULL
         LET g_abb[g_cnt].abb25_bal = NULL
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
      END IF }     
#NO.130222 mark---------------------------------end
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      EXIT FOREACH
      END IF
   END FOREACH

   CALL g_abb.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1
   LET g_rec_b = g_cnt 

END FUNCTION

REPORT gglq708_rep(sr)
   DEFINE
          sr                   RECORD 
                               yy       LIKE aao_file.aao03,    
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
                               END RECORD,
          t_bal,t_balf                 LIKE abb_file.abb07,
          t_debit,t_debitf             LIKE abb_file.abb07,
          t_credit,t_creditf           LIKE abb_file.abb07,
          l_d,l_df,l_c,l_cf            LIKE abb_file.abb07,
          n_bal,n_balf                 LIKE abb_file.abb07,
          l_abb25_c,l_abb25_d,l_abb25_bal LIKE abb_file.abb25,
          l_date2                      LIKE type_file.dat,
          l_date1                      LIKE type_file.dat,
          l_dc                         LIKE type_file.chr10,
          l_year                       LIKE type_file.num10,
          l_month                      LIKE type_file.num10
DEFINE    l_aag06                      LIKE aag_file.aag06  
DEFINE    l_order_no                  INT 
DEFINE    l_pb_dc211 LIKE type_file.chr10
DEFINE    l_pb_dc212 LIKE type_file.chr10
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line

    ORDER BY sr.ted02,sr.aag01,sr.yy,sr.aba04,sr.aba02,sr.aba01  #TQC-CC0122 remark
  # ORDER BY sr.abb24,sr.aag01,sr.yy,sr.aba04,sr.aba02,sr.aba01  #TQC-CC0122 mark


  FORMAT
   PAGE HEADER
      LET g_pageno = g_pageno + 1

   BEFORE GROUP OF sr.aag01 
      LET t_bal     = sr.qcye
      LET t_balf    = sr.qcyef
      LET t_debit   = sr.qc_yd  + sr.qc_md
      LET t_debitf  = sr.qc_ydf + sr.qc_mdf
      LET t_credit  = sr.qc_yc  + sr.qc_mc
      LET t_creditf = sr.qc_ycf + sr.qc_mcf
      LET l_order_no=0  
     #FUN-C80102---str---
     #IF sr.aba04 = MONTH(bdate) THEN
      IF sr.aba04 = s_get_aznn(g_plant,g_aza.aza81,bdate,3) THEN
     #FUN-C80102---end---
         LET l_date2 = bdate
      ELSE
         LET l_date2 = MDY(sr.aba04,1,yy)
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
      LET l_abb25_bal = n_bal  / n_balf  
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      INSERT INTO gglq708_tmp
       VALUES(sr.yy,sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'1',
             l_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_order_no)
   ON EVERY ROW
      LET l_order_no=l_order_no+1 #add by hujie 2010-6-1
      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
         IF cl_null(sr.abb07)  THEN LET sr.abb07  = 0 END IF
         IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
         IF sr.abb06 = 1 THEN
          # LET t_bal   = t_bal   + sr.abb07      #No.10052801
          # LET t_balf  = t_balf  + sr.abb07f     #No.10052801
            LET t_debit = t_debit + sr.abb07
            LET t_debitf= t_debitf+ sr.abb07f
         ELSE
          # LET t_bal    = t_bal    - sr.abb07    #No.10052801
          # LET t_balf   = t_balf   - sr.abb07f   #No.10052801
            LET t_credit = t_credit + sr.abb07
            LET t_creditf= t_creditf+ sr.abb07f
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
        #No.10052801--begin--

#        IF sr.abb06 = '1' THEN                      
             LET t_bal  = t_bal  + l_d  - l_c
             LET t_balf = t_balf + l_df - l_cf
#         ELSE                                       
#             LET t_bal  = t_bal  + l_c  - l_d        
#             LET t_balf = t_balf + l_cf - l_df       
#         END IF                                      
        #No.10052801---end---

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
  	 SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag01=sr.aag01 
    CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc211 
    CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc212
    #IF (l_aag06='1' AND l_dc="贷") OR (l_aag06='2' AND l_dc="借") THEN
 #NO.130222 add--------------------------------begin
    #IF (l_aag06='1' AND l_dc=l_pb_dc212) OR (l_aag06='2' AND l_dc=l_pb_dc211) THEN
    #   CASE l_aag06 
    #   #WHEN '1'  LET l_dc="借"
    #   WHEN '1'  LET l_dc=l_pb_dc211
    #   #WHEN '2'  LET l_dc="贷"
    #   WHEN '2'  LET l_dc=l_pb_dc212
    #   OTHERWISE 
    #   END CASE 
    #   LET n_bal = n_bal * -1
    #   LET n_balf= n_balf* -1
    #END IF 
 #NO.130222 add-----------------------------------end
         LET l_abb25_d = l_d  / l_df
         LET l_abb25_c = l_c  / l_cf
         LET l_abb25_bal = n_bal  / n_balf
        #No.100205---end---
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq708_tmp
          VALUES(sr.yy,sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_order_no)
         PRINT
      END IF

   AFTER GROUP OF sr.aag01
      CALL s_yp(edate) RETURNING l_year,l_month
      IF sr.aba04 = l_month THEN
         LET l_date2  = edate
      ELSE
         CALL s_azn01(yy,sr.aba04) RETURNING l_date1,l_date2
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

    SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag01=sr.aag01 
    #IF (l_aag06='1' AND l_dc="贷") OR (l_aag06='2' AND l_dc="借") THEN
 #NO.130222 mark-----------------------begin
    #IF (l_aag06='1' AND l_dc=l_pb_dc212) OR (l_aag06='2' AND l_dc=l_pb_dc211) THEN
    #   CASE l_aag06 
    #   #WHEN '1'  LET l_dc="借"
    #   WHEN '1'  LET l_dc=l_pb_dc211
    #   #WHEN '2'  LET l_dc="贷"
    #   WHEN '2'  LET l_dc=l_pb_dc212
    #   OTHERWISE 
    #   END CASE 
    #   LET n_bal = n_bal * -1
    #   LET n_balf= n_balf* -1
    #END IF
 #NO.130222 mark------------------------end 

      LET l_d = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
      LET l_df= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
      LET l_c = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
      LET l_cf= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
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

      LET l_abb25_d = l_d  / l_df
      LET l_abb25_c = l_c  / l_cf
      LET l_abb25_bal = n_bal  / n_balf

      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF cl_null(l_abb25_d)   THEN LET l_abb25_d   = 0 END IF
      IF cl_null(l_abb25_c)   THEN LET l_abb25_c   = 0 END IF
      INSERT INTO gglq708_tmp
       VALUES('',sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,'','3',
             l_date2,'',g_msg,sr.abb24,'',0,0,
             l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,l_order_no) 
#  AFTER GROUP OF sr.yy         #modify by czh  按年度合计
#     CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
#     LET l_abb25_d = t_debitf / t_debit
#     LET l_abb25_c = t_creditf / t_credit
#     LET l_abb25_bal = n_balf / n_bal
#     IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
#     IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
#     IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
#     INSERT INTO gglq708_tmp
#     VALUES(sr.yy,'','',sr.ted02,sr.ted02_d,sr.aba04,'4',
#            l_date2,'',g_msg,sr.abb24,'',0,0,
#            t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
#            l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
END REPORT

FUNCTION q708_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abb TO s_abb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         #No.100301--begin--
         IF l_ac_t > 0 THEN 
            CALL FGL_SET_ARR_CURR(l_ac_t)
            LET l_ac_t = 0
         END IF 
         #No.100301---end---
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
         CALL gglq708_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL gglq708_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL gglq708_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL gglq708_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL gglq708_fetch('L')
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

FUNCTION q708_out_1()

   LET g_prog = 'gglq708'
   LET g_sql = " yy.aao_file.aao03,",     #add by czh
               " aag01.aag_file.aag01,",
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

   LET l_table = cl_prt_temptable('gglq708',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?,   ?)          "    #modify by czh
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION

FUNCTION q708_out_2()
   DEFINE l_name             LIKE type_file.chr20
   DEFINE l_aag01            LIKE aag_file.aag01
   DEFINE l_ted02            LIKE ted_file.ted02
   DEFINE l_gen02            LIKE gen_file.gen02   #No.FUN-090416 

   LET g_prog = 'gglq708'

   CALL cl_del_data(l_table)

   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_user   #No.FUN-090416    
   
   LET l_aag01 = NULL
   LET l_ted02 = NULL
   DECLARE gglq708_tmp_curs CURSOR FOR
    SELECT * FROM gglq708_tmp
   # ORDER BY ted02,aag01,type,aba04,aba02,aba01
     ORDER BY abb24,aag01,type,aba04,aba02,aba01
   FOREACH gglq708_tmp_curs INTO g_pr.*
      EXECUTE insert_prep USING g_pr.*
   END FOREACH

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''

   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'ted02')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",yy,";",g_azi04,";",tm.a
                    ,";",bdate,";",edate   #add by 44119 090410 打印时显示期间
                    ,";",l_gen02  #No.FUN-090416   
   IF tm.b = 'N' THEN
       LET l_name = 'gglq708'
   ELSE
       LET l_name = 'gglq708_1'
   END IF
   CALL cl_prt_cs3('gglq708',l_name,g_sql,g_str)

END FUNCTION

FUNCTION gglq708_table()
     DROP TABLE gglq708_ted_tmp;
     CREATE TEMP TABLE gglq708_ted_tmp(
                    aag01        LIKE aag_file.aag01,
                    aag02        LIKE aag_file.aag02,
                    ted02        LIKE ted_file.ted02,
                    ted02_d      LIKE type_file.chr1000, #FUN-C80102
                    ted09        LIKE ted_file.ted09);   #No.FUN-D40044   Add

     DROP TABLE gglq708_tmp;
     CREATE TEMP TABLE gglq708_tmp( 
                    yy           LIKE aao_file.aao03,
                    aag01        LIKE aag_file.aag01,
                    aag02        LIKE aag_file.aag02,
                    ted02        LIKE ted_file.ted02,
                    ted02_d      LIKE ze_file.ze03,  
                    aba04        LIKE aba_file.aba04,
                    type         LIKE type_file.chr1,
                    aba02        LIKE aba_file.aba02, 
                    aba01        LIKE aba_file.aba01, 
                    abb04        LIKE abb_file.abb04, 
                    abb24        LIKE abb_file.abb24, 
                    abb06        LIKE abb_file.abb06, 
                    abb07        LIKE abb_file.abb07,
                    abb07f       LIKE abb_file.abb07,
                    d            LIKE abb_file.abb07,
                    df           LIKE abb_file.abb07,
                    abb25_d      LIKE abb_file.abb07,
                    c            LIKE abb_file.abb07,
                    cf           LIKE abb_file.abb07,
                    abb25_c      LIKE abb_file.abb07,
                    dc           LIKE type_file.chr10,
                    bal          LIKE abb_file.abb07,
                    balf         LIKE abb_file.abb07,
                    abb25_bal    LIKE abb_file.abb07,
                    pagenum      LIKE type_file.num5,
                    azi04        LIKE type_file.num5, 
                    azi05        LIKE type_file.num5, 
                    azi07        LIKE type_file.num5, 
                    order_no     LIKE type_file.num5) 
END FUNCTION

FUNCTION gglq708_get_ahe02(p_aag01_str,p_ted02,p_aag01)     #No.100113 
  DEFINE p_aag01_str     LIKE type_file.chr50
  DEFINE p_ted02         LIKE ted_file.ted02
  DEFINE l_ahe01         LIKE ahe_file.ahe01
  DEFINE l_ahe03         LIKE ahe_file.ahe03   #No.100113
  DEFINE l_ahe04         LIKE ahe_file.ahe04
  DEFINE l_ahe05         LIKE ahe_file.ahe05
  DEFINE l_ahe07         LIKE ahe_file.ahe07
  DEFINE l_sql1          LIKE type_file.chr1000
  DEFINE l_ahe02_d       LIKE ze_file.ze03
  DEFINE l_n             LIKE type_file.num5   #no.l00113
  DEFINE p_aag01         LIKE aag_file.aag01   #No.100113

     #取核算項名稱
     LET l_ahe01 = NULL
     OPEN gglq708_gaq01_cs USING p_aag01_str
     IF SQLCA.sqlcode THEN
        #CALL cl_err('open gglq708_gaq01_cs',SQLCA.sqlcode,1)
        CLOSE gglq708_gaq01_cs
        RETURN NULL
     END IF
     FETCH FIRST gglq708_gaq01_cs INTO l_ahe01
     IF SQLCA.sqlcode THEN
        #CALL cl_err('fetch gglq708_gaq01_cs',SQLCA.sqlcode,1)
        CLOSE gglq708_gaq01_cs
        RETURN NULL
     END IF
     CLOSE gglq708_gaq01_cs
     IF NOT cl_null(l_ahe01) THEN
        SELECT ahe03,ahe04,ahe05,ahe07 INTO l_ahe03,l_ahe04,l_ahe05,l_ahe07
          FROM ahe_file
         WHERE ahe01 = l_ahe01
        IF l_ahe03 = '1' THEN 
           IF NOT cl_null(l_ahe04) AND NOT cl_null(l_ahe05) AND
              NOT cl_null(l_ahe07) THEN
              LET l_sql1 = "SELECT UNIQUE ",l_ahe07 CLIPPED,
                           "  FROM ",l_ahe04 CLIPPED,
                           " WHERE ",l_ahe05 CLIPPED," = '",p_ted02,"'"
              PREPARE ahe_p1 FROM l_sql1
              EXECUTE ahe_p1 INTO l_ahe02_d
           END IF
        ELSE
           LET l_sql1 = " SELECT COUNT(*) FROM aee_file ",
                        "  WHERE aee00 = '",bookno CLIPPED,"'",
                        "    AND aee01 = '",p_aag01 CLIPPED,"'",
                        "    AND aee03 = '",p_ted02 CLIPPED,"'"
           PREPARE ahe_cnt_p FROM l_sql1
           EXECUTE ahe_cnt_p INTO l_n

           IF l_n > 1 THEN 
              SELECT DISTINCT aee04 INTO l_ahe02_d FROM aee_file
               WHERE aee00 = bookno
                 AND aee01 = p_aag01
                 AND aee02 = tm.a
              AND aee03 = p_ted02
           ELSE
              SELECT DISTINCT aee04 INTO l_ahe02_d FROM aee_file
               WHERE aee00 = bookno
                 AND aee01 = p_aag01
                 AND aee03 = p_ted02
           END IF 
        END IF 
       #No.100113---end---
     END IF

     RETURN l_ahe02_d
END FUNCTION

FUNCTION gglq708_t()
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
   ELSE
      CALL cl_set_comp_visible("abb24,abb25,df,cf,balf",FALSE)
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
   CLEAR FORM
   CALL g_abb.clear()
#  CALL gglq708_cs()   #FUN-C80102 mark

END FUNCTION

FUNCTION q708_drill_down()  
   DEFINE l_wc    LIKE type_file.chr50
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat

#  IF cl_null(g_ted02) THEN RETURN END IF   #FUN-C80102 mark
   IF tm.f='Y' THEN  #TQC-D60037
   IF cl_null(g_abb24) THEN RETURN END IF   #FUN-C80102 add
   END IF  #TQC-D60037
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_abb[l_ac].aba01) THEN RETURN END IF
   LET g_msg = "aglt110 '",g_abb[l_ac].aba01,"'"
   CALL cl_cmdrun(g_msg)
END FUNCTION
