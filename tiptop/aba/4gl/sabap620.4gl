# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: abap620
# DESCRIPTIONS...: 条码出货作业
# IMPORTANT......: 回写tlfb_file那段仍未实现。。。
# DATE & AUTHOR..: No:DEV-CB0012 2012/11/13 By TSD.JIE
# Modify.........: No:DEV-CC0002 2012/12/06 By Nina 修正畫面右上角"X"無法關閉表單的問題
# Modify.........: No:DEV-CC0001 2012/12/12 By Mandy abap620/abat620出貨通知單號(box01)開窗報錯
# Modify.........: No:DEV-CC0007 2013/01/03 By Mandy (1)abat3011 齊套數sets有誤
#                                                    (2)imgb04批號欄位隱藏
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---


DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"

DEFINE
    tm   RECORD    #程式變數(Program Variables)
        box01   LIKE box_file.box01
         END  RECORD,
    g_box    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         box11      LIKE  box_file.box11,   #配货类型
         box12      LIKE  box_file.box12,   #系列
         box08      LIKE  box_file.box08,   #安库否
         box02      LIKE  box_file.box02,   #出货通知单项次
         box04      LIKE  box_file.box04,   #料件
         ima02      LIKE  ima_file.ima02,   #品名
         ima021     LIKE  ima_file.ima021,  #规格
         box06      LIKE  box_file.box06,   #预计出货数量
         sets       LIKE  box_file.box06,   #齐套数量
         return_sets  LIKE box_file.box06   #退货齐套数量
           END  RECORD,
    g_box_t    RECORD    #程式變數(Program Variables)
         box11      LIKE  box_file.box11,   #配货类型
         box12      LIKE  box_file.box12,   #系列
         box08      LIKE  box_file.box08,   #安库否
         box02      LIKE  box_file.box02,   #出货通知单项次
         box04      LIKE  box_file.box04,   #料件
         ima02      LIKE  ima_file.ima02,   #品名
         ima021     LIKE  ima_file.ima021,  #规格
         box06      LIKE  box_file.box06,   #预计出货数量
         sets       LIKE  box_file.box06,   #齐套数量
         return_sets  LIKE box_file.box06   #退货齐套数量
           END  RECORD,
    g_imgb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
       #imgb00      LIKE imgb_file.imgb00,   #条码类型 #No:DEV-CB0012--mark
        imgb01      LIKE imgb_file.imgb01,   #条码
       #iba12       LIKE iba_file.iba12,     #包号     #No:DEV-CB0012--mark
        ibb05       LIKE ibb_file.ibb05,     #包号     #No:DEV-CB0012--add
        imgb02      LIKE imgb_file.imgb02,   #仓库
        imgb03      LIKE imgb_file.imgb03,   #库位
        imgb04      LIKE imgb_file.imgb04,   #批号
        imgb05      LIKE imgb_file.imgb05    #数量
       #more        LIKE imgb_file.imgb05,   #多       #No:DEV-CB0012--mark
       #less        LIKE imgb_file.imgb05    #缺       #No:DEV-CB0012--mark
            END  RECORD,
    g_sets      DYNAMIC ARRAY OF RECORD
        sets LIKE imgb_file.imgb05    #单身齐套数量
            END  RECORD,
    g_wc,g_wc2,g_wc3     STRING,
    g_sql                STRING,
    g_cmd                STRING,
    g_rec_b         LIKE type_file.num10,                #單身筆數
    g_rec_b2        LIKE type_file.num10,                #單身筆數
    g_rec_b3        LIKE type_file.num10,
    g_row_count     LIKE type_file.num5,
    g_curs_index    LIKE type_file.num5,
    mi_no_ask       LIKE type_file.num5,
    g_jump          LIKE type_file.num5,
    l_ac            LIKE type_file.num10,                 #目前處理的ARRAY CNT
    l_ac2           LIKE type_file.num10,                 #目前處理的ARRAY CNT
    l_ac3           LIKE type_file.num10,
    g_chr           LIKE type_file.chr1,
    g_flag          LIKE type_file.chr1,
    g_msg           STRING,
    l_cmd           STRING

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE i               LIKE type_file.num5     #count/index for any purpose
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_zz01          LIKE zz_file.zz01
DEFINE g_form          LIKE type_file.chr1
DEFINE g_argv1      LIKE type_file.chr10
DEFINE g_argv2      LIKE box_file.box01

FUNCTION sabap620(p_argv1,p_argv2)
   DEFINE p_argv1     LIKE  type_file.chr10
   DEFINE p_argv2     LIKE  box_file.box01
   WHENEVER ERROR CALL cl_err_msg_log

    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2

    #DEV-CB0012--add--begin
    OPEN WINDOW p620_w AT 0,0 WITH FORM "aba/42f/abap620"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    #DEV-CB0012--add--end

    CALL sabap620_ui_init()
    CALL p620_temp()

    IF NOT cl_null(g_argv1) THEN
       CALL sabap620_q()
    END IF
    CALL sabap620_menu()

    CLOSE WINDOW p620_w  #DEV-CB0012--add
END FUNCTION

FUNCTION p620_temp()
    DROP TABLE sabap620_temp
 #No:DEV-CB0002--mark--begin
 # #SELECT boxb04,boxb05,boxb06,boxb07,boxb08,boxb09,boxb09 a #No:DEV-CB0012--mark
 #  SELECT boxb05,boxb06,boxb07,boxb08,boxb09,boxb09 a        #No:DEV-CB0012--add
 #    FROM boxb_file WHERE 1=2 INTO TEMP sabap620_temp

 #  IF SQLCA.sqlcode THEN
 #     CALL cl_err('sabap620_temp',-261,1)
 #     EXIT PROGRAM
 #  END IF
 #No:DEV-CB0002--mark--end

  #No:DEV-CB0002--add--begin
  CREATE TEMP TABLE sabap620_temp(
     boxb02     LIKE boxb_file.boxb02,
     boxb03     LIKE boxb_file.boxb03,
     boxb05     LIKE boxb_file.boxb05,
     boxb06     LIKE boxb_file.boxb06,
     boxb07     LIKE boxb_file.boxb07,
     boxb08     LIKE boxb_file.boxb08,
     boxb09     LIKE boxb_file.boxb09,
     a          LIKE boxb_file.boxb09)
  #No:DEV-CB0002--add--end
END FUNCTION

FUNCTION sabap620_ui_init()

   CALL cl_set_comp_visible(",imgb04",FALSE) #DEV-CC0007 add /批號(imgb04)欄位隱藏
   CALL cl_set_comp_visible("return_sets",FALSE)
   CALL cl_set_act_visible("so_exp",TRUE)
   CALL cl_set_act_visible("post,undo_post,void,upd_post,delete_axmt620",FALSE)
  #No:DEV-CB0012--mark--begin
  #IF g_argv1 = '3' THEN
  #   CALL cl_set_comp_att_text("box01","杂发单号")
  #   CALL cl_set_comp_att_text("box02","杂发单项次")
  #   CALL cl_set_comp_att_text("box06","杂发备货调整量")
  #   CALL cl_set_comp_visible("box12",FALSE)
  #   CALL cl_set_act_visible("so_exp",FALSE)
  #   #CALL cl_set_act_visible("post,undo_post,void",TRUE)
  #   CALL cl_set_act_visible("post,undo_post",TRUE)
  #END IF
  #IF g_argv1 = '4' THEN
  #   CALL cl_set_comp_att_text("box01","跨厂调拨单号")
  #   CALL cl_set_comp_att_text("box02","跨厂调拨项次")
  #   CALL cl_set_comp_att_text("box06","杂发备货调整量")
  #   CALL cl_set_comp_visible("box12",FALSE)
  #   CALL cl_set_act_visible("so_exp",FALSE)
  #   CALL cl_set_act_visible("post,undo_post,void",TRUE)
  #END IF
  #IF g_argv1 = '5' THEN
  #   CALL cl_set_act_visible("so_exp",FALSE)
  #  # CALL cl_set_act_visible("upd_post,delete_axmt620",TRUE)
  #   CALL cl_set_act_visible("upd_post",TRUE)
  #   CALL cl_set_comp_visible("return_sets",TRUE)
  #END IF
  #No:DEV-CB0012--mark--end

  #No:DEV-CB0012--add--begin
  CASE
     WHEN g_argv1 = '3'   #abat3011
         CALL cl_getmsg('aba-084',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box01",g_msg CLIPPED)
         CALL cl_getmsg('aba-085',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box02",g_msg CLIPPED)
         CALL cl_getmsg('aba-087',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box06",g_msg CLIPPED)
         CALL cl_set_comp_visible("box12",FALSE)
         CALL cl_set_act_visible("so_exp",FALSE)
         CALL cl_set_act_visible("post,undo_post",TRUE)
     WHEN g_argv1 = '5'   #abat620
         CALL cl_set_act_visible("so_exp",FALSE)
         CALL cl_set_act_visible("upd_post",TRUE)
         CALL cl_set_comp_visible("return_sets",TRUE)
  END CASE
  #No:DEV-CB0012--add--end

END FUNCTION

FUNCTION sabap620_menu()
DEFINE l_slip  LIKE oga_file.oga01

   WHILE TRUE
      CALL sabap620_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL sabap620_q()
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL sabap620_post()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL sabap620_undo_post()
            END IF
        #No:DEV-CB0012--mark--begin
        #WHEN "void"
        #   IF cl_chk_act_auth() THEN
        #      CALL sabap620_void()
        #   END IF
        #No:DEV-CB0012--mark--end
         WHEN "upd_post"
            IF cl_chk_act_auth() THEN
               CALL sabap620_upd_post()
            END IF
        #No:DEV-CB0012--mark--begin
        #WHEN "delete_axmt620"
        #   IF cl_chk_act_auth() THEN
        #      CALL sabap620_delete_axmt620()
        #   END IF
        #No:DEV-CB0012--mark--end
#         WHEN "detail"
#            IF cl_chk_act_auth() THEN
#               CALL sabap620_b()
#            END IF
         WHEN "so_exp"
            IF cl_chk_act_auth() THEN
               CALL sabap620_so_exp() RETURNING l_slip
               IF g_success = 'Y' THEN
                  COMMIT WORK
                  CALL cl_err(l_slip,'abm-019',1)
                  LET l_cmd = "axmt620 '",l_slip,"' 'query' "
                  CALL cl_cmdrun_wait(l_cmd)
               END IF
               IF g_success = 'N' THEN
                  ROLLBACK WORK
                  CALL cl_err('','abm-020',0)
               END IF
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION


FUNCTION sabap620_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
   CALL cl_set_head_visible("","YES")
   INITIALIZE tm.* TO NULL
   CALL g_box.CLEAR()
   CALL g_imgb.CLEAR()

   IF NOT cl_null(g_argv2) THEN
      CASE g_argv1
       WHEN '1'
          LET g_wc = " box01 = '",g_argv2,"' AND box14 = 'axmt610' "
      #No:DEV-CB0012--mark--begin
      #WHEN '2'
      #   LET g_wc = " box01 = '",g_argv2,"' AND box14 = 'aimt324' "
      #No:DEV-CB0012--mark--end
       WHEN '3'
          LET g_wc = " box01 = '",g_argv2,"' AND box14 = 'aimt301' "
      #No:DEV-CB0012--mark--begin
      #WHEN '4'
      #   LET g_wc = " box01 = '",g_argv2,"' AND box14 = 'cimt327' "
      #No:DEV-CB0012--mark--end
       WHEN '5'
          LET g_wc = " box01 = '",g_argv2,"' AND box14 = 'axmt610' "
      END CASE
      RETURN
  #END IF #No:DEV-CB0012--mark
   ELSE   #No:DEV-CB0012--add

      DIALOG ATTRIBUTES(UNBUFFERED)

         CONSTRUCT BY NAME g_wc ON box01

            BEFORE CONSTRUCT
                CALL cl_qbe_display_condition(lc_qbe_sn)

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DIALOG

            ON ACTION about
               CALL cl_about()

            ON ACTION HELP
               CALL cl_show_help()

            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION accept
               EXIT DIALOG

            ON ACTION cancel
               LET INT_FLAG = TRUE
               EXIT DIALOG

            ON ACTION exit
               LET INT_FLAG = TRUE
               EXIT DIALOG

            ON ACTION close
               LET INT_FLAG = TRUE
               EXIT DIALOG

            ON ACTION controlp
               CASE
                  WHEN INFIELD(box01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                    #LET g_qryparam.form ="cq_box1" #No:DEV-CB0012--mark
                    #LET g_qryparam.form ="q_box01" #No:DEV-CB0012--add #No:DEV-CB0002--mark
                     #No:DEV-CB0002--add--begin
                     CASE
                        WHEN g_argv1 = '3'   #abat3011
                           LET g_qryparam.form ="q_box05"
                           LET g_qryparam.arg1 ="1"
                       #OTHERWISE EXIT CASE  #DEV-CC0001 mark
                        OTHERWISE            #DEV-CC0001 add
                           LET g_qryparam.form ="q_box01"
                     END CASE
                     #No:DEV-CB0002--add--end
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO box01
                     NEXT FIELD box01
               END CASE
         END CONSTRUCT


         #CONSTRUCT g_wc2 ON box02,box04,box05,box06,box13
         #        FROM s_box[1].box02,s_box[1].box04,
         #             s_box[1].box05,s_box[1].box06,
         #             s_box[1].box13
         #   BEFORE CONSTRUCT
         #      CALL cl_qbe_display_condition(lc_qbe_sn)
         #
         #   ON IDLE g_idle_seconds
         #      CALL cl_on_idle()
         #      CONTINUE DIALOG
         #
         #   ON ACTION about
         #      CALL cl_about()
         #
         #   ON ACTION HELP
         #      CALL cl_show_help()
         #
         #   ON ACTION controlg
         #      CALL cl_cmdask()
         #
         #   ON ACTION qbe_save
         #      CALL cl_qbe_save()
         #
         #   ON ACTION accept
         #      EXIT DIALOG
         #
         #   ON ACTION cancel
         #      LET INT_FLAG = TRUE
         #      EXIT DIALOG
         #
         #   ON ACTION exit
         #      LET INT_FLAG = TRUE
         #      EXIT DIALOG
         #
         #   ON ACTION close
         #      LET INT_FLAG = TRUE
         #      EXIT DIALOG
         #
         #   ON ACTION controlp
         #      CASE
         #         WHEN INFIELD(box09)
         #            CALL cl_init_qry_var()
         #            LET g_qryparam.state = 'c'
         #            LET g_qryparam.form ="cq_box2"
         #            CALL cl_create_qry() RETURNING g_qryparam.multiret
         #            DISPLAY g_qryparam.multiret TO box09
         #            NEXT FIELD box09
         #         OTHERWISE EXIT CASE
         #      END CASE
         #END CONSTRUCT

      END DIALOG
   END IF #No:DEV-CB0012--add

   IF INT_FLAG THEN
      #LET INT_FLAG = FALSE #No:DEV-CB0012--mark
      RETURN
   END IF

   CASE g_argv1
      WHEN '1'
         LET g_wc = g_wc CLIPPED," AND box14 = 'axmt610' "
     #No:DEV-CB0012--mark--begin
     #WHEN '2'
     #   LET g_wc = g_wc CLIPPED," AND box14 = 'aimt324' "
     #No:DEV-CB0012--mark--end
      WHEN '3'
         LET g_wc = g_wc CLIPPED," AND box14 = 'aimt301' "
     #No:DEV-CB0012--mark--begin
     #WHEN '4'
     #   LET g_wc = g_wc CLIPPED," AND box14 = 'cimt327' "
     #No:DEV-CB0012--mark--end
      WHEN '5'
         LET g_wc = g_wc CLIPPED," AND box14 = 'axmt610' "
   END CASE
   IF cl_null(g_wc) THEN LET g_wc = " 1=1 " END IF
   IF cL_null(g_wc2) THEN LET g_wc2 = " 1=1 " END IF

   #No:DEV-CB0012--add--begin
   LET g_sql = "SELECT DISTINCT box01 FROM box_file ",
               " WHERE ",g_wc,
               "   AND ",g_wc2,
               " ORDER BY box01 "
   PREPARE sabap620_prep FROM g_sql
   DECLARE sabap620_cs SCROLL CURSOR WITH HOLD FOR sabap620_prep

   LET g_sql = "SELECT COUNT(DISTINCT box01) FROM box_file ",
               " WHERE ",g_wc,
               "   AND ",g_wc2,
               " ORDER BY box01 "
   PREPARE sabap620_prepcount FROM g_sql
   DECLARE sabap620_count CURSOR FOR sabap620_prepcount
   #No:DEV-CB0012--add--end
END FUNCTION


FUNCTION sabap620_q()

   #No:DEV-CB0012--add--begin
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)

   CALL cl_opmsg('q')
   CLEAR FORM
   INITIALIZE tm.* TO NULL
   CALL g_box.CLEAR()
   CALL g_imgb.CLEAR()
   DISPLAY '   ' TO FORMONLY.cnt
   #No:DEV-CB0012--add--end
   MESSAGE ""

   CALL sabap620_cs()
   #No:DEV-CB0012--add--begin
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      RETURN
   END IF
   #No:DEV-CB0012--add--end

  #No:DEV-CB0012--mark--begin MOVE TO sabap620_cs()
  #LET g_sql = "SELECT DISTINCT box01 FROM box_file ",
  #            " WHERE ",g_wc,
  #            "   AND ",g_wc2,
  #            " ORDER BY box01 "
  #PREPARE sabap620_prep FROM g_sql
  #DECLARE sabap620_cs SCROLL CURSOR WITH HOLD FOR sabap620_prep
  #
  #LET g_sql = "SELECT COUNT(DISTINCT box01) FROM box_file ",
  #            " WHERE ",g_wc,
  #            "   AND ",g_wc2,
  #            " ORDER BY box01 "
  #PREPARE sabap620_prepcount FROM g_sql
  #DECLARE sabap620_count CURSOR FOR sabap620_prepcount
  #No:DEV-CB0012--mark--end
   OPEN sabap620_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE tm.* TO NULL
   ELSE
      OPEN sabap620_count
      FETCH sabap620_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL sabap620_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF

END FUNCTION


FUNCTION sabap620_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680137 VARCHAR(1)
DEFINE l_slip          LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(10)  #No.FUN-640013

   CASE p_flag
       WHEN 'N' FETCH NEXT     sabap620_cs INTO tm.box01
       WHEN 'P' FETCH PREVIOUS sabap620_cs INTO tm.box01
       WHEN 'F' FETCH FIRST    sabap620_cs INTO tm.box01
       WHEN 'L' FETCH LAST     sabap620_cs INTO tm.box01
       WHEN '/'
           IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump

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
           FETCH ABSOLUTE g_jump sabap620_cs INTO tm.box01
           LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err('not found',SQLCA.sqlcode,0)        #No.TQC-6C0183
      INITIALIZE tm.* TO NULL   #No.TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      DISPLAY g_curs_index TO idx
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
   CALL sabap620_show()
END FUNCTION


FUNCTION sabap620_show()
DEFINE  l_ima02   LIKE ima_file.ima02
DEFINE  l_ima021  LIKE ima_file.ima021   #FUN-AA0086

   DISPLAY BY NAME tm.box01

   CALL sabap620_b_fill(tm.box01)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION sabap620_b_fill(p_box01)
DEFINE p_wc2      STRING
DEFINE p_box01    LIKE box_file.box01
DEFINE l_sets     LIKE box_file.box06
DEFINE s_sets     LIKE box_file.box06
#add by zhangym 120516 begin-----
#DEFINE l_iba00    LIKE iba_file.iba00 #No:DEV-CB0012--mark
DEFINE l_iba01    LIKE iba_file.iba01
DEFINE l_box09    LIKE box_file.box09
DEFINE l_box04    LIKE box_file.box04
DEFINE l_cnt      LIKE type_file.num5
DEFINE m_box09    LIKE box_file.box09
DEFINE l_boxb09   LIKE boxb_file.boxb09
DEFINE l_a        LIKE boxb_file.boxb09
DEFINE l_sum1     LIKE box_file.box06
DEFINE l_sum2     LIKE box_file.box06
DEFINE l_sabap620_temp    RECORD
            #boxb04     LIKE boxb_file.boxb04, #No:DEV-CB0012--mark
             boxb02     LIKE boxb_file.boxb02, #No:DEV-CB0002--add
             boxb03     LIKE boxb_file.boxb03, #No:DEV-CB0002--add
             boxb05     LIKE boxb_file.boxb05,
             boxb06     LIKE boxb_file.boxb06,
             boxb07     LIKE boxb_file.boxb07,
             boxb08     LIKE boxb_file.boxb08,
             boxb09     LIKE boxb_file.boxb09,
             a              LIKE boxb_file.boxb09
                           END RECORD
DEFINE l_sabap620_temp_t    RECORD
            #boxb04     LIKE boxb_file.boxb04, #No:DEV-CB0012--mark
             boxb02     LIKE boxb_file.boxb02, #No:DEV-CB0002--add
             boxb03     LIKE boxb_file.boxb03, #No:DEV-CB0002--add
             boxb05     LIKE boxb_file.boxb05,
             boxb06     LIKE boxb_file.boxb06,
             boxb07     LIKE boxb_file.boxb07,
             boxb08     LIKE boxb_file.boxb08,
             boxb09     LIKE boxb_file.boxb09,
             a              LIKE boxb_file.boxb09
                           END RECORD
#add by zhangym 120516 end-----

   LET g_sql = "SELECT DISTINCT box11,box12,box08,box02,box04,ima02,ima021,box06,'','' ",
               "  FROM box_file,ima_file ",
               " WHERE box04 = ima01 ",
               "   AND box01 = '",p_box01,"' ",
               "   AND ",g_wc,
               "   AND ",g_wc2,
               " ORDER BY box11,box12,box02 "

   PREPARE sabap620_pb FROM g_sql
   DECLARE box_cs CURSOR FOR sabap620_pb

   CALL g_box.clear()
   CALL g_sets.CLEAR()
   LET g_cnt = 1

   FOREACH box_cs INTO g_box[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #add by zhangym 120515 begin----
      #IF g_box[g_cnt].box11 = '10' THEN #No:DEV-CB0012--mark
       IF g_box[g_cnt].box11 = '3' THEN  #No:DEV-CB0012--add
         CASE g_argv1
            WHEN '1'
              #No:DEV-CB0012--mark--begin
              #SELECT iba00,iba01 INTO l_iba00,l_iba01 FROM iba_file
              # WHERE iba04 = g_box[g_cnt].box11
              #   AND iba01 = g_box[g_cnt].box04
              #   AND iba00 = '1'
              #SELECT SUM(tlfb05) INTO g_box[g_cnt].sets FROM tlfb_file
              # WHERE tlfb00 = l_iba00
              #   AND tlfb01 = l_iba01
              #   AND tlfb11 = 'abat061'
              #   AND tlfb07 = p_box01
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
              #SELECT SUM(tlfb05) INTO g_box[g_cnt].sets #No:DEV-CB0002--mark
               SELECT -1*SUM(tlfb05*tlfb06) INTO g_box[g_cnt].sets #No:DEV-CB0002--add
                 FROM tlfb_file,ibb_file
                WHERE tlfb01 = ibb01
                  AND tlfb11 = 'abat061'
                  AND tlfb07 = p_box01
                  AND ibb06  = g_box[g_cnt].box04
                  AND ibb02  IN('F','G')   ##條碼產生時機點 F:採購單(apmt540),G:委外採購單(apmt590)
              #No:DEV-CB0012--add--end

            WHEN '3'
              #No:DEV-CB0012--mark--begin
              #SELECT SUM(tlfb05) INTO g_box[g_cnt].sets FROM tlfb_file,iba_file
              # WHERE tlfb00 = iba00
              #   AND tlfb01 = iba01
              #   AND iba04 IN ('10','501')
              #   AND tlfb11 = 'abat031'
              #   AND tlfb07 = p_box01
              #   AND iba09 = g_box[g_cnt].box04
              # GROUP BY iba09
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
               SELECT SUM(tlfb05) INTO g_box[g_cnt].sets
                 FROM tlfb_file,ibb_file
                WHERE tlfb01 = ibb01
                  AND tlfb11 = 'abat031'
                  AND tlfb07 = p_box01
                  AND ibb06 = g_box[g_cnt].box04
                  AND ibb02 IN('I','F','G')   ##條碼產生時機點 I:雜收單(aimt302),F:採購單(apmt540),G:委外採購單(apmt590)
                GROUP BY ibb06
              #No:DEV-CB0012--add--end

           #No:DEV-CB0012--mark--begin
           #WHEN '4'
           #   SELECT SUM(tlfb05) INTO g_box[g_cnt].sets FROM tlfb_file,iba_file
           #    WHERE tlfb00 = iba00
           #      AND tlfb01 = iba01
           #      AND iba04 IN ('10','501')
           #      AND tlfb11 = 'abat0371'
           #      AND tlfb07 = p_box01
           #      AND iba09 = g_box[g_cnt].box04
           #    GROUP BY iba09
           #No:DEV-CB0012--mark--end

            WHEN '5'
              #No:DEV-CB0012--mark--begin
              #SELECT iba00,iba01 INTO l_iba00,l_iba01 FROM iba_file
              # WHERE iba04 = g_box[g_cnt].box11
              #   AND iba01 = g_box[g_cnt].box04
              #   AND iba00 = '1'
              #SELECT SUM(tlfb05) INTO g_box[g_cnt].sets FROM tlfb_file
              # WHERE tlfb00 = l_iba00
              #   AND tlfb01 = l_iba01
              #   AND tlfb11 = 'abat061'
              #   AND tlfb07 = p_box01
              #SELECT iba00,iba01 INTO l_iba00,l_iba01 FROM iba_file
              # WHERE iba04 = g_box[g_cnt].box11
              #   AND iba01 = g_box[g_cnt].box04
              #   AND iba00 = '1'
              #SELECT SUM(tlfb05) INTO g_box[g_cnt].return_sets FROM tlfb_file
              # WHERE tlfb00 = l_iba00
              #   AND tlfb01 = l_iba01
              #   AND tlfb11 = 'abat062'
              #   AND tlfb07 = p_box01
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
               SELECT SUM(tlfb05) INTO g_box[g_cnt].sets
                 FROM tlfb_file,ibb_file
                WHERE tlfb01 = ibb01
                  AND tlfb11 = 'abat061'
                  AND tlfb07 = p_box01
                  AND ibb01  = g_box[g_cnt].box04
                  AND ibb02  IN('F','G')   ##條碼產生時機點 F:採購單(apmt540),G:委外採購單(apmt590)

               SELECT SUM(tlfb05) INTO g_box[g_cnt].return_sets
                 FROM tlfb_file,ibb_file
                WHERE tlfb01 = ibb01
                  AND tlfb11 = 'abat062'
                  AND tlfb07 = p_box01
                  AND ibb01  = g_box[g_cnt].box04
                  AND ibb02  IN('F','G')   ##條碼產生時機點 F:採購單(apmt540),G:委外採購單(apmt590)
              #No:DEV-CB0012--add--end
         END CASE
       END IF


      #IF g_box[g_cnt].box11 = '50' THEN #No:DEV-CB0012--mark
       IF g_box[g_cnt].box11 = '2' THEN  #No:DEV-CB0012--add
         DELETE FROM sabap620_temp
         CASE g_argv1
            WHEN '1'
               #No:DEV-CB0002--add--begin
               CALL p620_sets(tm.box01,g_box[g_cnt].box02,'abat061')
                  RETURNING g_box[g_cnt].sets 
               #No:DEV-CB0002--add--end

         #No:DEV-CB0002--mark--begin
         #    #No:DEV-CB0012--mark--begin
         #    #LET g_sql =  "SELECT boxb04,boxb05,boxb06,boxb07,boxb08,'','' ",
         #    #             "  FROM boxb_file,iba_file ",
         #    #             " WHERE boxb01 = '",tm.box01,"' ",
         #    #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
         #    #             "   AND iba04 = '50' AND iba09 = '",g_box[g_cnt].box04,"' ",
         #    #             " GROUP BY boxb04,boxb05,boxb06,boxb07,boxb08  ",
         #    #             " ORDER BY boxb04,boxb05 "
         #    #No:DEV-CB0012--mark--end
         #    #No:DEV-CB0012--add--begin
         #     DELETE FROM sabap620_temp
         #     LET g_sql =  "SELECT boxb02,boxb03,boxb05,boxb06,boxb07,boxb08,'','' ",
         #                  "  FROM boxb_file,ibb_file ",
         #                  " WHERE boxb01 = '",tm.box01,"' ",
         #                  "   AND ibb01 = boxb05 ",
         #                  "   AND ibb02 = 'A' ",
         #                  "   AND ibb06 = '",g_box[g_cnt].box04,"' ",
         #                  " GROUP BY boxb02,boxb03,boxb05,boxb06,boxb07,boxb08  ",
         #                  " ORDER BY boxb05 "
         #    #No:DEV-CB0012--add--end
         #     PREPARE boxb_pb11 FROM g_sql
         #     DECLARE boxb_cs11 CURSOR FOR boxb_pb11
         #     FOREACH boxb_cs11 INTO l_sabap620_temp.*
         #       #No:DEV-CB0012--mark--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 FROM tlfb_file
         #       # WHERE tlfb00 = l_sabap620_temp.boxb04
         #       #   AND tlfb01 = l_sabap620_temp.boxb05
         #       #   AND tlfb02 = l_sabap620_temp.boxb06
         #       #   AND tlfb03 = l_sabap620_temp.boxb07
         #       #   AND tlfb04 = l_sabap620_temp.boxb08
         #       #   AND tlfb11 = 'abat061'
         #       #   AND tlfb07 = tm.box01
         #       # GROUP BY tlfb00,tlfb01
         #       #No:DEV-CB0012--mark--end
         #       #No:DEV-CB0012--add--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 #No:DEV-CB0002--mark
         #        SELECT -1*SUM(tlfb05*tlfb06) INTO l_sabap620_temp.boxb09
         #          FROM tlfb_file
         #         WHERE tlfb01 = l_sabap620_temp.boxb05
         #           AND tlfb02 = l_sabap620_temp.boxb06
         #           AND tlfb03 = l_sabap620_temp.boxb07
         #           AND tlfb04 = l_sabap620_temp.boxb08
         #           AND tlfb11 = 'abat061'
         #           AND tlfb07 = tm.box01
         #         GROUP BY tlfb01
         #       #No:DEV-CB0012--add--end
         #        IF cl_null(l_sabap620_temp.boxb09) THEN
         #           LET l_sabap620_temp.boxb09 = 0
         #        END IF
         #        INSERT INTO sabap620_temp VALUES(l_sabap620_temp.*)
         #     END FOREACH
         #     SELECT MIN(SUM(boxb09)) INTO l_sum1 FROM sabap620_temp
         #     #GROUP BY boxb04,boxb05 #No:DEV-CB0012--mark
         #      GROUP BY boxb05        #No:DEV-CB0012--add
         #     IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF

         #     DELETE FROM sabap620_temp
         #    #No:DEV-CB0012--mark--begin
         #    #LET g_sql =  "SELECT boxb04,boxb05,boxb06,boxb07,boxb08,'','' ",
         #    #             "  FROM boxb_file,iba_file ",
         #    #             " WHERE boxb01 = '",tm.box01,"' ",
         #    #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
         #    #             "   AND iba04 = '501' AND iba09 = '",g_box[g_cnt].box04,"' ",
         #    #             " GROUP BY boxb04,boxb05,boxb06,boxb07,boxb08  ",
         #    #             " ORDER BY boxb04,boxb05 "
         #    #No:DEV-CB0012--mark--end
         #    #No:DEV-CB0012--add--begin
         #     LET g_sql =  "SELECT boxb02,boxb03,boxb05,boxb06,boxb07,boxb08,'','' ",
         #                  "  FROM boxb_file,ibb_file ",
         #                  " WHERE boxb01 = '",tm.box01,"' ",
         #                  "   AND ibb01 = boxb05 ",
         #                  "   AND ibb02 = 'I' ",
         #                  "   AND ibb06 = '",g_box[g_cnt].box04,"' ",
         #                  " GROUP BY boxb02,boxb03,boxb05,boxb06,boxb07,boxb08  ",
         #                  " ORDER BY boxb05 "
         #    #No:DEV-CB0012--add--end
         #     PREPARE boxb_pb112 FROM g_sql
         #     DECLARE boxb_cs112 CURSOR FOR boxb_pb112
         #     FOREACH boxb_cs112 INTO l_sabap620_temp.*
         #       #No:DEV-CB0012--mark--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 FROM tlfb_file
         #       # WHERE tlfb00 = l_sabap620_temp.boxb04
         #       #   AND tlfb01 = l_sabap620_temp.boxb05
         #       #   AND tlfb02 = l_sabap620_temp.boxb06
         #       #   AND tlfb03 = l_sabap620_temp.boxb07
         #       #   AND tlfb04 = l_sabap620_temp.boxb08
         #       #   AND tlfb11 = 'abat061'
         #       #   AND tlfb07 = tm.box01
         #       # GROUP BY tlfb00,tlfb01
         #       #No:DEV-CB0012--mark--end
         #       #No:DEV-CB0012--add--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 #No:DEV-CB0002--mark
         #        SELECT -1*SUM(tlfb05*tlfb06) INTO l_sabap620_temp.boxb09
         #          FROM tlfb_file
         #         WHERE tlfb01 = l_sabap620_temp.boxb05
         #           AND tlfb02 = l_sabap620_temp.boxb06
         #           AND tlfb03 = l_sabap620_temp.boxb07
         #           AND tlfb04 = l_sabap620_temp.boxb08
         #           AND tlfb11 = 'abat061'
         #           AND tlfb07 = tm.box01
         #         GROUP BY tlfb01
         #       #No:DEV-CB0012--add--end
         #        IF cl_null(l_sabap620_temp.boxb09) THEN
         #           LET l_sabap620_temp.boxb09 = 0
         #        END IF
         #        INSERT INTO sabap620_temp VALUES(l_sabap620_temp.*)
         #     END FOREACH
         #     SELECT MIN(SUM(boxb09)) INTO l_sum2 FROM sabap620_temp
         #     #GROUP BY boxb04,boxb05 #No:DEV-CB0012--mark
         #      GROUP BY boxb05        #No:DEV-CB0012--add
         #     IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
         #     LET g_box[g_cnt].sets = l_sum1 + l_sum2
         #No:DEV-CB0002--mark--end

            WHEN '3'

               #No:DEV-CB0002--add--begin
               CALL p620_sets(tm.box01,g_box[g_cnt].box02,'abat031')
                  RETURNING g_box[g_cnt].sets 
               #No:DEV-CB0002--add--end

         #No:DEV-CB0002--mark--begin
         #    #No:DEV-CB0012--mark--begin
         #    #LET g_sql =  "SELECT boxb04,boxb05,boxb06,boxb07,boxb08,'','' ",
         #    #             "  FROM boxb_file,iba_file ",
         #    #             " WHERE boxb01 = '",tm.box01,"' ",
         #    #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
         #    #             "   AND iba04 = '50' AND iba09 = '",g_box[g_cnt].box04,"' ",
         #    #             " GROUP BY boxb04,boxb05,boxb06,boxb07,boxb08  ",
         #    #             " ORDER BY boxb04,boxb05 "
         #    #No:DEV-CB0012--mark--end
         #    #No:DEV-CB0012--add--begin
         #     DELETE FROM sabap620_temp
         #     LET g_sql =  "SELECT boxb02,boxb03,boxb05,boxb06,boxb07,boxb08,'','' ",
         #                  "  FROM boxb_file,ibb_file ",
         #                  " WHERE boxb01 = '",tm.box01,"' ",
         #                  "   AND ibb01 = boxb05 ",
         #                  "   AND ibb02 = 'A' ",
         #                  "   AND ibb06 = '",g_box[g_cnt].box04,"' ",
         #                  " GROUP BY boxb02,boxb03,boxb05,boxb06,boxb07,boxb08  ",
         #                  " ORDER BY boxb05 "
         #    #No:DEV-CB0012--add--end
         #     PREPARE boxb_pb131 FROM g_sql
         #     DECLARE boxb_cs131 CURSOR FOR boxb_pb131
         #     FOREACH boxb_cs131 INTO l_sabap620_temp.*
         #       #No:DEV-CB0012--mark--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 FROM tlfb_file
         #       # WHERE tlfb00 = l_sabap620_temp.boxb04
         #       #   AND tlfb01 = l_sabap620_temp.boxb05
         #       #   AND tlfb11 = 'abat031'
         #       #   AND tlfb07 = tm.box01
         #       # GROUP BY tlfb00,tlfb01
         #       #No:DEV-CB0012--mark--end
         #       #No:DEV-CB0012--add--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 #No:DEV-CB0002--mark
         #        SELECT -1*SUM(tlfb05*tlfb06) INTO l_sabap620_temp.boxb09
         #          FROM tlfb_file
         #         WHERE tlfb01 = l_sabap620_temp.boxb05
         #           AND tlfb11 = 'abat031'
         #           AND tlfb07 = tm.box01
         #         GROUP BY tlfb01
         #       #No:DEV-CB0012--add--end
         #        IF cl_null(l_sabap620_temp.boxb09) THEN
         #           LET l_sabap620_temp.boxb09 = 0
         #        END IF
         #        INSERT INTO sabap620_temp VALUES(l_sabap620_temp.*)
         #     END FOREACH
         #     SELECT MIN(SUM(boxb09)) INTO l_sum1 FROM sabap620_temp
         #     #GROUP BY boxb04,boxb05 #No:DEV-CB0012--mark
         #      GROUP BY boxb05        #No:DEV-CB0012--add
         #     IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF

         #     DELETE FROM sabap620_temp
         #    #No:DEV-CB0012--mark--begin
         #    #LET g_sql =  "SELECT boxb04,boxb05,boxb06,boxb07,boxb08,'','' ",
         #    #             "  FROM boxb_file,iba_file ",
         #    #             " WHERE boxb01 = '",tm.box01,"' ",
         #    #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
         #    #             "   AND iba04 = '501' AND iba09 = '",g_box[g_cnt].box04,"' ",
         #    #             " GROUP BY boxb04,boxb05,boxb06,boxb07,boxb08  ",
         #    #             " ORDER BY boxb04,boxb05 "
         #    #No:DEV-CB0012--mark--end
         #    #No:DEV-CB0012--add--begin
         #     LET g_sql =  "SELECT boxb02,boxb03,boxb05,boxb06,boxb07,boxb08,'','' ",
         #                  "  FROM boxb_file,ibb_file ",
         #                  " WHERE boxb01 = '",tm.box01,"' ",
         #                  "   AND ibb01 = boxb05 ",
         #                  "   AND ibb02 = 'I'",
         #                  "   AND ibb06 = '",g_box[g_cnt].box04,"' ",
         #                  " GROUP BY boxb02,boxb03,boxb05,boxb06,boxb07,boxb08  ",
         #                  " ORDER BY boxb05 "
         #    #No:DEV-CB0012--add--end
         #     PREPARE boxb_pb133 FROM g_sql
         #     DECLARE boxb_cs133 CURSOR FOR boxb_pb133
         #     FOREACH boxb_cs133 INTO l_sabap620_temp.*
         #       #No:DEV-CB0012--mark--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 FROM tlfb_file
         #       # WHERE tlfb00 = l_sabap620_temp.boxb04
         #       #   AND tlfb01 = l_sabap620_temp.boxb05
         #       #   AND tlfb11 = 'abat031'
         #       #   AND tlfb07 = tm.box01
         #       # GROUP BY tlfb00,tlfb01
         #       #No:DEV-CB0012--mark--end
         #       #No:DEV-CB0012--add--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 #No:DEV-CB0002--mark
         #        SELECT -1*SUM(tlfb05*tlfb06) INTO l_sabap620_temp.boxb09
         #          FROM tlfb_file
         #         WHERE tlfb01 = l_sabap620_temp.boxb05
         #           AND tlfb11 = 'abat031'
         #           AND tlfb07 = tm.box01
         #         GROUP BY tlfb01
         #       #No:DEV-CB0012--add--end
         #        IF cl_null(l_sabap620_temp.boxb09) THEN
         #           LET l_sabap620_temp.boxb09 = 0
         #        END IF
         #        INSERT INTO sabap620_temp VALUES(l_sabap620_temp.*)
         #     END FOREACH
         #     SELECT MIN(SUM(boxb09)) INTO l_sum2 FROM sabap620_temp
         #     #GROUP BY boxb04,boxb05 #No:DEV-CB0012--mark
         #      GROUP BY boxb05        #No:DEV-CB0012--add
         #     #GROUP BY boxb02,boxb03 #No:DEV-CB0002--add

         #     IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
         #     LET g_box[g_cnt].sets = l_sum1 + l_sum2
         #No:DEV-CB0002--mark--end

           #No:DEV-CB0012--mark--begin
           #WHEN '4'
           #   LET g_sql =  "SELECT boxb04,boxb05,boxb06,boxb07,boxb08,'','' ",
           #                "  FROM boxb_file,iba_file ",
           #                " WHERE boxb01 = '",tm.box01,"' ",
           #                "   AND iba00 = boxb04 AND iba01 = boxb05 ",
           #                "   AND iba04 = '50' AND iba09 = '",g_box[g_cnt].box04,"' ",
           #                " GROUP BY boxb04,boxb05,boxb06,boxb07,boxb08  ",
           #                " ORDER BY boxb04,boxb05 "
           #   PREPARE boxb_pb141 FROM g_sql
           #   DECLARE boxb_cs141 CURSOR FOR boxb_pb141
           #   INITIALIZE l_sabap620_temp_t.* TO NULL
           #   FOREACH boxb_cs141 INTO l_sabap620_temp.*
           #      IF NOT cl_null(l_sabap620_temp_t.boxb04) AND
           #         l_sabap620_temp_t.boxb04 = l_sabap620_temp.boxb04
           #         AND l_sabap620_temp_t.boxb05 = l_sabap620_temp.boxb05 THEN
           #         CONTINUE FOREACH
           #      ELSE
           #        SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 FROM tlfb_file
           #         WHERE tlfb00 = l_sabap620_temp.boxb04
           #           AND tlfb01 = l_sabap620_temp.boxb05
           #           AND tlfb11 = 'abat0371'
           #           AND tlfb07 = tm.box01
           #         GROUP BY tlfb00,tlfb01
           #        IF cl_null(l_sabap620_temp.boxb09) THEN
           #           LET l_sabap620_temp.boxb09 = 0
           #        END IF
           #        INSERT INTO sabap620_temp VALUES(l_sabap620_temp.*)
           #        LET l_sabap620_temp_t.* = l_sabap620_temp.*
           #     END IF
           #   END FOREACH
           #   SELECT MIN(SUM(boxb09)) INTO l_sum1 FROM sabap620_temp
           #    GROUP BY boxb04,boxb05
           #   IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
           #   DELETE FROM sabap620_temp
           #   LET g_sql =  "SELECT boxb04,boxb05,boxb06,boxb07,boxb08,'','' ",
           #                "  FROM boxb_file,iba_file ",
           #                " WHERE boxb01 = '",tm.box01,"' ",
           #                "   AND iba00 = boxb04 AND iba01 = boxb05 ",
           #                "   AND iba04 = '501' AND iba09 = '",g_box[g_cnt].box04,"' ",
           #                " GROUP BY boxb04,boxb05,boxb06,boxb07,boxb08  ",
           #                " ORDER BY boxb04,boxb05 "
           #   PREPARE boxb_pb143 FROM g_sql
           #   DECLARE boxb_cs143 CURSOR FOR boxb_pb143
           #   INITIALIZE l_sabap620_temp_t.* TO NULL
           #   FOREACH boxb_cs143 INTO l_sabap620_temp.*
           #      IF NOT cl_null(l_sabap620_temp_t.boxb04) AND
           #         l_sabap620_temp_t.boxb04 = l_sabap620_temp.boxb04
           #         AND l_sabap620_temp_t.boxb05 = l_sabap620_temp.boxb05 THEN
           #         CONTINUE FOREACH
           #      ELSE
           #        SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 FROM tlfb_file
           #         WHERE tlfb00 = l_sabap620_temp.boxb04
           #           AND tlfb01 = l_sabap620_temp.boxb05
           #           AND tlfb11 = 'abat0371'
           #           AND tlfb07 = tm.box01
           #         GROUP BY tlfb00,tlfb01
           #        IF cl_null(l_sabap620_temp.boxb09) THEN
           #           LET l_sabap620_temp.boxb09 = 0
           #        END IF
           #        INSERT INTO sabap620_temp VALUES(l_sabap620_temp.*)
           #        LET l_sabap620_temp_t.* = l_sabap620_temp.*
           #     END IF
           #   END FOREACH
           #   SELECT MIN(SUM(boxb09)) INTO l_sum2 FROM sabap620_temp
           #    GROUP BY boxb04,boxb05
           #   IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
           #   LET g_box[g_cnt].sets = l_sum1 + l_sum2
           #No:DEV-CB0012--mark--end

            WHEN '5'
               #No:DEV-CB0002--add--begin
               CALL p620_sets(tm.box01,g_box[g_cnt].box02,'abat061')
                  RETURNING g_box[g_cnt].sets 

               CALL p620_return_sets(tm.box01,g_box[g_cnt].box02,'abat062')
                  RETURNING g_box[g_cnt].return_sets 
               #No:DEV-CB0002--add--end

         #No:DEV-CB0002--add--begin
         #    #No:DEV-CB0012--mark--begin
         #    #LET g_sql =  "SELECT boxb04,boxb05,boxb06,boxb07,boxb08,'','' ",
         #    #             "  FROM boxb_file,iba_file ",
         #    #             " WHERE boxb01 = '",tm.box01,"' ",
         #    #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
         #    #             "   AND iba04 IN ('50','501') AND iba09 = '",g_box[g_cnt].box04,"' ",
         #    #             " GROUP BY boxb04,boxb05,boxb06,boxb07,boxb08  ",
         #    #             " ORDER BY boxb04,boxb05 "
         #    #No:DEV-CB0012--mark--end
         #    #No:DEV-CB0012--add--begin
         #     DELETE FROM sabap620_temp
         #     LET g_sql =  "SELECT boxb02,boxb03,boxb05,boxb06,boxb07,boxb08,'','' ",
         #                  "  FROM boxb_file,ibb_file ",
         #                  " WHERE boxb01 = '",tm.box01,"' ",
         #                  "   AND ibb01 = boxb05 ",
         #                  "   AND ibb02 IN ('A','I')",
         #                  "   AND ibb06 = '",g_box[g_cnt].box04,"' ",
         #                  " GROUP BY boxb02,boxb03,boxb05,boxb06,boxb07,boxb08  ",
         #                  " ORDER BY boxb05 "
         #    #No:DEV-CB0012--add--end
         #     PREPARE boxb_pb21 FROM g_sql
         #     DECLARE boxb_cs21 CURSOR FOR boxb_pb21
         #     FOREACH boxb_cs21 INTO l_sabap620_temp.*
         #       #No:DEV-CB0012--mark--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 FROM tlfb_file
         #       # WHERE tlfb00 = l_sabap620_temp.boxb04
         #       #   AND tlfb01 = l_sabap620_temp.boxb05
         #       #   AND tlfb11 = 'abat061'
         #       #   AND tlfb07 = tm.box01
         #       # GROUP BY tlfb00,tlfb01
         #       #No:DEV-CB0012--mark--end
         #       #No:DEV-CB0012--add--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 #No:DEV-CB0002--mark
         #        SELECT -1*SUM(tlfb05*tlfb06) INTO l_sabap620_temp.boxb09
         #          FROM tlfb_file
         #         WHERE tlfb01 = l_sabap620_temp.boxb05
         #           AND tlfb11 = 'abat061'
         #           AND tlfb07 = tm.box01
         #         GROUP BY tlfb01
         #       #No:DEV-CB0012--add--end
         #        IF cl_null(l_sabap620_temp.boxb09) THEN
         #           LET l_sabap620_temp.boxb09 = 0
         #        END IF

         #       #No:DEV-CB0012--mark--begin
         #       #SELECT SUM(tlfb05) INTO l_sabap620_temp.a FROM tlfb_file
         #       # WHERE tlfb00 = l_sabap620_temp.boxb04
         #       #   AND tlfb01 = l_sabap620_temp.boxb05
         #       #   AND tlfb11 = 'abat062'
         #       #   AND tlfb07 = tm.box01
         #       # GROUP BY tlfb00,tlfb01
         #       #No:DEV-CB0012--mark--end
         #       #No:DEV-CB0012--add--begin
         #        LET l_sabap620_temp.a = 0
         #        SELECT SUM(tlfb05) INTO l_sabap620_temp.a
         #          FROM tlfb_file
         #         WHERE tlfb01 = l_sabap620_temp.boxb05
         #           AND tlfb11 = 'abat062'
         #           AND tlfb07 = tm.box01
         #         GROUP BY tlfb01
         #       #No:DEV-CB0012--add--end
         #        IF cl_null(l_sabap620_temp.a) THEN
         #           LET l_sabap620_temp.a = 0
         #        END IF
         #        INSERT INTO sabap620_temp VALUES(l_sabap620_temp.*)
         #     END FOREACH

         #     #齊套數
         #     SELECT MIN(SUM(boxb09)) INTO g_box[g_cnt].sets
         #       FROM sabap620_temp
         #     #GROUP BY boxb04,boxb05 #No:DEV-CB0012--mark
         #      GROUP BY boxb05        #No:DEV-CB0012--add

         #     #退貨齊套數
         #     LET g_sql = " SELECT a FROM sabap620_temp "
         #     PREPARE boxb_pb221 FROM g_sql
         #     DECLARE boxb_cs221 CURSOR FOR boxb_pb221
         #     LET l_a = ''
         #     FOREACH boxb_cs221 INTO l_boxb09
         #        IF NOT cl_null(l_a) THEN
         #           IF l_a != l_boxb09 THEN
         #              LET g_box[g_cnt].return_sets = -1
         #              EXIT FOREACH
         #           ELSE
         #              LET g_box[g_cnt].return_sets = l_a
         #           END IF
         #        ELSE
         #           LET l_a = l_boxb09
         #           LET g_box[g_cnt].return_sets = l_boxb09
         #        END IF
         #     END FOREACH
         #No:DEV-CB0002--add--end
         END CASE
       END IF

      #IF g_box[g_cnt].box11 = '52' THEN #No:DEV-CB0012--mark
       IF g_box[g_cnt].box11 = '1' THEN  #No:DEV-CB0012--add
          DELETE FROM sabap620_temp
          CASE g_argv1
             WHEN '1'
              #No:DEV-CB0012--mark--begin
              #LET g_sql =  "SELECT boxb04,boxb05,boxb06,boxb07,boxb08,'','' ",
              #             "  FROM boxb_file,iba_file ",
              #             " WHERE boxb01 = '",tm.box01,"' ",
              #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
              #             "   AND iba04 = '",g_box[g_cnt].box11,"' AND iba06 = '",g_box[g_cnt].box12,"' ",
              #             " GROUP BY boxb04,boxb05,boxb06,boxb07,boxb08  ",
              #             " ORDER BY boxb04,boxb05 "
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
               LET g_sql =  "SELECT boxb02,boxb03,boxb05,boxb06,boxb07,boxb08,'','' ",
                            "  FROM boxb_file,ibb_file ",
                            " WHERE boxb01 = '",tm.box01,"' ",
                            "   AND ibb01 = boxb05 ",
                            "   AND ibb02 = 'H'",
                            "   AND ibb09 = '",g_box[g_cnt].box12,"' ",
                            " GROUP BY boxb02,boxb03,boxb05,boxb06,boxb07,boxb08  ",
                            " ORDER BY boxb05 "
              #No:DEV-CB0012--add--end
               PREPARE boxb_pb12 FROM g_sql
               DECLARE boxb_cs12 CURSOR FOR boxb_pb12
               FOREACH boxb_cs12 INTO l_sabap620_temp.*
                 #No:DEV-CB0012--mark--begin
                 #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 FROM tlfb_file
                 # WHERE tlfb00 = l_sabap620_temp.boxb04
                 #   AND tlfb01 = l_sabap620_temp.boxb05
                 #   AND tlfb11 = 'abat061'
                 #   AND tlfb07 = tm.box01
                 # GROUP BY tlfb00,tlfb01
                 #No:DEV-CB0012--mark--end
                 #No:DEV-CB0012--add--begin
                 #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 #No:DEV-CB0002--mark
                  SELECT -1*SUM(tlfb05*tlfb06) INTO l_sabap620_temp.boxb09
                    FROM tlfb_file
                   WHERE tlfb01 = l_sabap620_temp.boxb05
                     AND tlfb11 = 'abat061'
                     AND tlfb07 = tm.box01
                   GROUP BY tlfb01
                 #No:DEV-CB0012--add--end
                  IF cl_null(l_sabap620_temp.boxb09) THEN
                     LET l_sabap620_temp.boxb09 = 0
                  END IF
                  INSERT INTO sabap620_temp VALUES(l_sabap620_temp.*)
               END FOREACH
               #齊套數
               SELECT MIN(SUM(boxb09)) INTO g_box[g_cnt].sets
                 FROM sabap620_temp
               #GROUP BY boxb04,boxb05 #No:DEV-CB0012--mark
                GROUP BY boxb05        #No:DEV-CB0012--add

             WHEN '5'
               #No:DEV-CB0012--mark--begin
               #LET g_sql =  "SELECT boxb04,boxb05,boxb06,boxb07,boxb08,'','' ",
               #             "  FROM boxb_file,iba_file ",
               #             " WHERE boxb01 = '",tm.box01,"' ",
               #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
               #             "   AND iba04 = '",g_box[g_cnt].box11,"' AND iba06 = '",g_box[g_cnt].box12,"' ",
               #             " GROUP BY boxb04,boxb05,boxb06,boxb07,boxb08  ",
               #             " ORDER BY boxb04,boxb05 "
               #No:DEV-CB0012--mark--end
               #No:DEV-CB0012--add--begin
                LET g_sql =  "SELECT boxb02,boxb03,boxb05,boxb06,boxb07,boxb08,'','' ",
                             "  FROM boxb_file,iba_file ",
                             " WHERE boxb01 = '",tm.box01,"' ",
                             "   AND ibb01 = boxb05 ",
                             "   AND ibb02 = 'H'",
                             "   AND ibb09 = '",g_box[g_cnt].box12,"' ",
                             " GROUP BY boxb02,boxb03,boxb05,boxb06,boxb07,boxb08  ",
                             " ORDER BY boxb05 "
               #No:DEV-CB0012--add--end
                PREPARE boxb_pb22 FROM g_sql
                DECLARE boxb_cs22 CURSOR FOR boxb_pb22
                FOREACH boxb_cs22 INTO l_sabap620_temp.*
                  #No:DEV-CB0012--mark--begin
                  #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 FROM tlfb_file
                  # WHERE tlfb00 = l_sabap620_temp.boxb04
                  #   AND tlfb01 = l_sabap620_temp.boxb05
                  #   AND tlfb11 = 'abat061'
                  #   AND tlfb07 = tm.box01
                  # GROUP BY tlfb00,tlfb01
                  #No:DEV-CB0012--mark--end
                  #No:DEV-CB0012--add--begin
                 #SELECT SUM(tlfb05) INTO l_sabap620_temp.boxb09 #No:DEV-CB0002--mark
                  SELECT -1*SUM(tlfb05*tlfb06) INTO l_sabap620_temp.boxb09
                     FROM tlfb_file
                    WHERE tlfb01 = l_sabap620_temp.boxb05
                      AND tlfb11 = 'abat061'
                      AND tlfb07 = tm.box01
                    GROUP BY tlfb01
                  #No:DEV-CB0012--add--end
                   IF cl_null(l_sabap620_temp.boxb09) THEN
                      LET l_sabap620_temp.boxb09 = 0
                   END IF

                  #No:DEV-CB0012--mark--begin
                  #SELECT SUM(tlfb05) INTO l_sabap620_temp.a FROM tlfb_file
                  # WHERE tlfb00 = l_sabap620_temp.boxb04
                  #   AND tlfb01 = l_sabap620_temp.boxb05
                  #   AND tlfb11 = 'abat062'
                  #   AND tlfb07 = tm.box01
                  # GROUP BY tlfb00,tlfb01
                  #No:DEV-CB0012--mark--end
                  #No:DEV-CB0012--add--begin
                   SELECT SUM(tlfb05) INTO l_sabap620_temp.a
                     FROM tlfb_file
                    WHERE tlfb01 = l_sabap620_temp.boxb05
                      AND tlfb11 = 'abat062'
                      AND tlfb07 = tm.box01
                    GROUP BY tlfb01
                  #No:DEV-CB0012--add--end
                   IF cl_null(l_sabap620_temp.a) THEN
                      LET l_sabap620_temp.a = 0
                   END IF
                   INSERT INTO sabap620_temp VALUES(l_sabap620_temp.*)
                END FOREACH
                #齊套數
                SELECT MIN(SUM(boxb09)) INTO g_box[g_cnt].sets FROM sabap620_temp
                #GROUP BY boxb04,boxb05 #No:DEV-CB0012--mark
                 GROUP BY boxb05        #No:DEV-CB0012--add
                #退貨齊套數
                LET g_sql = " SELECT a FROM sabap620_temp "
                PREPARE boxb_pb222 FROM g_sql
                DECLARE boxb_cs222 CURSOR FOR boxb_pb222
                LET l_a = ''
                FOREACH boxb_cs222 INTO l_boxb09
                   IF NOT cl_null(l_a) THEN
                      IF l_a != l_boxb09 THEN
                         LET g_box[g_cnt].return_sets = -1
                         EXIT FOREACH
                      ELSE
                         LET g_box[g_cnt].return_sets = l_a
                      END IF
                   ELSE
                      LET l_a = l_boxb09
                   END IF
                END FOREACH
          END CASE
          #SELECT box09 INTO l_box09 FROM box_file
          # WHERE box01 = p_box01
          #   AND box02 = g_box[g_cnt].box02
          #SELECT MIN(SUM(tlfb05)) INTO g_box[g_cnt].sets FROM tlfb_file,iba_file
          # WHERE tlfb01 = iba01
          #   AND tlfb00 = iba00
          #   AND iba04 = g_box[g_cnt].box11
          #   #AND iba05 = l_box09
          #   AND iba06 = g_box[g_cnt].box12
          #   AND tlfb11 = 'abat061'
          #   AND tlfb07 = p_box01
          # GROUP BY tlfb01,iba12
          IF g_box[g_cnt].sets > 0 THEN
             LET g_box[g_cnt].sets = g_box[g_cnt].box06
          END IF
          IF g_box[g_cnt].return_sets > 0 THEN
             LET g_box[g_cnt].return_sets = g_box[g_cnt].box06
          END IF
       END IF

       IF cl_null(g_box[g_cnt].sets) THEN
          LET g_box[g_cnt].sets = 0
       END IF
       IF cl_null(g_box[g_cnt].return_sets) THEN
          LET g_box[g_cnt].return_sets = 0
       END IF
       IF cl_null(g_box[g_cnt].box08) THEN
          LET g_box[g_cnt].box08 = 'N'
       END IF
       #add by zhangym 120516 end----
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_box.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO idx2
   LET g_cnt = 0

  ##重新刷新齐套数
  #LET s_sets = 0
  #FOR g_cnt = 1 TO g_rec_b
  #  IF g_box[g_cnt].box2 = 'Y' THEN
  #    LET g_sql = "SELECT MIN(sets) FROM (",
  #    "SELECT tlfb01,NVL(SUM(tlfb05),0) AS sets,'','' ",
  #    "  FROM iba_file,tlfb_file ",
  #    " WHERE iba01 = tlfb01 ",
  #    "   AND iba00 = tlfb00 ",
  #    "   AND tlfb11 = 'abat620' ",
  #    "   AND tlfb09 = '",p_box1,"' ",
  #    "   AND tlfb10 IS NULL ",
  #    "   AND iba09 = '",g_box[g_cnt].box04,"' ",
  #    " GROUP BY tlfb01 ",
  #    " ORDER BY tlfb01 ",
  #    " ) "
  #  ELSE
  #    LET g_sql = "SELECT MIN(sets) FROM (",
  #    "SELECT tlfb01,NVL(SUM(tlfb05),0) AS sets,'','' ",
  #    "  FROM tlfb_file ",
  #    " WHERE tlfb11 = 'abat620' ",
  #    "   AND tlfb09 = '",p_box1,"' ",
  #    "   AND tlfb10 = ",g_box[g_cnt].box3,
  #    " GROUP BY tlfb01 ",
  #    " ORDER BY tlfb01 ",
  #    " ) "
  #  END IF
  #  PREPARE get_sets FROM g_sql
  #  EXECUTE get_sets INTO l_sets
  #  IF g_box[g_cnt].box2 = 'N' THEN
  #     LET g_box[g_cnt].sets = l_sets
  #     CONTINUE FOR
  #  END IF
  #   IF g_cnt = 1 THEN
  #      LET s_sets = 0
  #   END IF
  #   IF g_cnt > 1 THEN
  #      IF g_box[g_cnt].box04 = g_box[g_cnt-1].box04 THEN
  #         LET s_sets = s_sets + g_box[g_cnt-1].sets
  #      ELSE
  #         LET s_sets = 0
  #      END IF
  #   END IF
  #     #还有数量可以配
  #   IF l_sets - s_sets > 0 THEN
  #      IF l_sets - s_sets >= g_box[g_cnt].box6 THEN
  #          LET g_box[g_cnt].sets = g_box[g_cnt].box6
  #      ELSE
  #          LET g_box[g_cnt].sets = l_sets - s_sets
  #      END IF
  #   ELSE
  #      LET g_box[g_cnt].sets = 0
  #   END IF
  #END FOR

END FUNCTION


#FUNCTION sabap620_d_fill(p_box9,p_oba01,p_slip,p_seq)
FUNCTION sabap620_d_fill(p_box11,p_oba01,p_slip,p_seq,p_box04)  #mod by zhangym 120516
DEFINE p_slip     LIKE box_file.box01
DEFINE p_seq      LIKE box_file.box02
DEFINE p_oba01    LIKE box_file.box12
DEFINE p_box11    LIKE box_file.box11
DEFINE s_sets     LIKE box_file.box06
DEFINE p_box04    LIKE box_file.box04  #add by zhangym 120516
DEFINE l_iba04    LIKE iba_file.iba04
DEFINE l_iba06    LIKE iba_file.iba06
#DEFINE l_iba14    LIKE iba_file.iba14 #No:DEV-CB0012--mark
DEFINE l_m        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_ibb02    LIKE ibb_file.ibb02 #No:DEV-CB0012--add
DEFINE l_ibb09    LIKE ibb_file.ibb09 #No:DEV-CB0012--add

  #IF p_box11 = '50' THEN #No:DEV-CB0012--mark
   IF p_box11 = '2' THEN  #No:DEV-CB0012--add
      IF cl_null(p_seq) THEN
      #改写By yangjian  12/04/26
       #LET g_sql = "SELECT tlfb01,iba12,tlfb02,tlfb03,SUM(tlfb05),'','' ",
       #       "  FROM iba_file,tlfb_file ",
       #       " WHERE iba01 = tlfb01 ",
       #       "   AND iba00 = tlfb00 ",
       #       "   AND tlfb11 = 'abat620' ",
       #       "   AND tlfb09 = '",p_slip,"' ",
       #      #"   AND tlfb10 = ",p_seq,
       #       " GROUP BY tlfb01,iba12,tlfb02,tlfb03 ",
       #       " ORDER BY tlfb01,tlfb02,tlfb03"
         CASE g_argv1
            WHEN '1'
              #No:DEV-CB0012--mark--begin
              #LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
              #             "  FROM boxb_file,iba_file ",
              #             " WHERE boxb01 = '",tm.box01,"' ",
              #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
              #             "   AND iba04 IN ('50','501') AND iba09 = '",p_box04,"' ",
              #             " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
              #             " ORDER BY boxb04,boxb05 "
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
               LET g_sql =  "SELECT DISTINCT boxb05,ibb05,boxb06,boxb07,boxb08,'' ",
                            "      ,ibb02,ibb09",
                            "  FROM boxb_file,ibb_file ",
                            " WHERE boxb01 = '",tm.box01,"' ",
                            "   AND ibb01 = boxb05 ",
                            "   AND ibb02 IN ('A','I')",
                            "   AND ibb06 = '",p_box04,"' ",
                            " ORDER BY boxb05 "
              #No:DEV-CB0012--add--end
            
            WHEN '3'
              #No:DEV-CB0012--mark--begin
              #LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
              #             "  FROM boxb_file,iba_file ",
              #             " WHERE boxb01 = '",tm.box01,"' ",
              #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
              #             "   AND iba04 IN ('50','501')  AND iba09 = '",p_box04,"' ",
              #             " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
              #             " ORDER BY boxb04,boxb05 "
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
               LET g_sql =  "SELECT DISTINCT boxb05,ibb05,boxb06,boxb07,boxb08,'' ",
                            "      ,ibb02,ibb09",
                            "  FROM boxb_file,ibb_file ",
                            " WHERE boxb01 = '",tm.box01,"' ",
                            "   AND ibb01 = boxb05 ",
                            "   AND ibb02 IN ('A','I')",
                            "   AND ibb06 = '",p_box04,"' ",
                            " ORDER BY boxb05 "
              #No:DEV-CB0012--add--end
         
           #No:DEV-CB0012--mark--begin
           #WHEN '4'
           #   LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
           #                "  FROM boxb_file,iba_file ",
           #                " WHERE boxb01 = '",tm.box01,"' ",
           #                "   AND iba00 = boxb04 AND iba01 = boxb05 ",
           #                "   AND iba04 IN ('50','501')  AND iba09 = '",p_box04,"' ",
           #                " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
           #                " ORDER BY boxb04,boxb05 "
           #No:DEV-CB0012--mark--end
         
            WHEN '5'
              #No:DEV-CB0012--mark--begin
              #LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
              #             "  FROM boxb_file,iba_file ",
              #             " WHERE boxb01 = '",tm.box01,"' ",
              #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
              #             "   AND iba04 IN ('50','501') AND iba09 = '",p_box04,"' ",
              #             " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
              #             " UNION ",
              #             " SELECT tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04,'' ",
              #             "   FROM tlfb_file,iba_file ",
              #             "  WHERE tlfb00 = iba00 ",
              #             "    AND tlfb01 = iba01 ",
              #             "    AND iba04 IN ('50','501') AND iba09 = '",p_box04,"' ",
              #             "    AND tlfb07 = '",tm.box01,"' ",
              #             "    AND tlfb11 = 'abat062' "
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
               LET g_sql =  "SELECT DISTINCT boxb05,ibb05,boxb06,boxb07,boxb08,'' ",
                            "      ,ibb02,ibb09",
                            "  FROM boxb_file,ibb_file ",
                            " WHERE boxb01 = '",tm.box01,"' ",
                            "   AND ibb01 = boxb05 ",
                            "   AND ibb02 IN ('A','I')",
                            "   AND ibb06 = '",p_box04,"' ",
                            " UNION ",
                            " SELECT tlfb01,ibb05,tlfb02,tlfb03,tlfb04,'' ",
                            "      ,'',''",
                            "   FROM tlfb_file,ibb_file ",
                            "  WHERE tlfb01 = ibb01 ",
                            "    AND ibb02 IN ('A','I')",
                            "    AND ibb06 = '",p_box04,"' ",
                            "    AND tlfb07 = '",tm.box01,"' ",
                            "    AND tlfb11 = 'abat062' "
              #No:DEV-CB0012--add--end
         END CASE
      ELSE
#改写 By yangjian  12/04/26
#         LET g_sql = "SELECT tlfb01,iba12,tlfb02,tlfb03,SUM(tlfb05),'','' ",
#               "  FROM iba_file,tlfb_file ",
#               " WHERE iba01 = tlfb01 ",
#               "   AND iba00 = tlfb00 ",
#               "   AND tlfb11 = 'abat620' ",
#               "   AND tlfb09 = '",p_slip,"' ",
#               "   AND tlfb10 = ",p_seq,
#               " GROUP BY tlfb01,iba12,tlfb02,tlfb03 ",
#               " ORDER BY tlfb01,tlfb02,tlfb03"
         CASE g_argv1
            WHEN '1'
              #No:DEV-CB0012--mark--begin
              #LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
              #             "  FROM boxb_file,iba_file ",
              #             " WHERE boxb01 = '",tm.box01,"' AND boxb02 = '",p_seq,"' ",
              #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
              #             "   AND iba04 IN ('50','501') AND iba09 = '",p_box04,"' ",
              #             " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
              #             " ORDER BY boxb04,boxb05 "
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
               LET g_sql =  "SELECT DISTINCT boxb05,ibb05,boxb06,boxb07,boxb08,'' ",
                            "      ,ibb02,ibb09",
                            "  FROM boxb_file,ibb_file ",
                            " WHERE boxb01 = '",tm.box01,"'",
                            "   AND boxb02 =  ",p_seq,"  ",
                            "   AND ibb01 = boxb05 ",
                            "   AND ibb02 IN ('A','I')",
                            "   AND ibb06 = '",p_box04,"' ",
                            " ORDER BY boxb05 "
              #No:DEV-CB0012--add--end

            WHEN '3'
              #No:DEV-CB0012--mark--begin
              #LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
              #             "  FROM boxb_file,iba_file ",
              #             " WHERE boxb01 = '",tm.box01,"' AND boxb02 = '",p_seq,"' ",
              #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
              #             "   AND iba04 IN ('50','501') AND iba09 = '",p_box04,"' ",
              #             " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
              #             " ORDER BY boxb04,boxb05 "
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
               LET g_sql =  "SELECT DISTINCT boxb05,ibb05,boxb06,boxb07,boxb08,'' ",
                            "      ,ibb02,ibb09",
                            "  FROM boxb_file,ibb_file ",
                            " WHERE boxb01 = '",tm.box01,"'",
                            "   AND boxb02 =  ",p_seq,"  ",
                            "   AND ibb01 = boxb05 ",
                            "   AND ibb02 IN ('A','I')",
                            "   AND ibb06 = '",p_box04,"' ",
                            " ORDER BY boxb05 "
              #No:DEV-CB0012--add--end

           #No:DEV-CB0012--mark--begin
           #WHEN '4'
           #   LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
           #                "  FROM boxb_file,iba_file ",
           #                " WHERE boxb01 = '",tm.box01,"' AND boxb02 = '",p_seq,"' ",
           #                "   AND iba00 = boxb04 AND iba01 = boxb05 ",
           #                "   AND iba04 IN ('50','501') AND iba09 = '",p_box04,"' ",
           #                " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
           #                " ORDER BY boxb04,boxb05 "
           #No:DEV-CB0012--mark--end

            WHEN '5'
              #No:DEV-CB0012--mark--begin
              #LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
              #             "  FROM boxb_file,iba_file ",
              #             " WHERE boxb01 = '",tm.box01,"' AND boxb02 = '",p_seq,"' ",
              #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
              #             "   AND iba04 IN ('50','501') AND iba09 = '",p_box04,"' ",
              #             " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
              #             " UNION ",
              #             " SELECT tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04,'' ",
              #             "   FROM tlfb_file,iba_file ",
              #             "  WHERE tlfb00 = iba00 ",
              #             "    AND tlfb01 = iba01 ",
              #             "    AND iba04 IN ('50','501') AND iba09 = '",p_box04,"' ",
              #             "    AND tlfb07 = '",tm.box01,"' ",
              #             "    AND tlfb08 = '",p_seq,"' ",
              #             "    AND tlfb11 = 'abat062' "
              #No:DEV-CB0012--mark--end
              #No:DEV-CB0012--add--begin
               LET g_sql =  "SELECT DISTINCT boxb05,ibb05,boxb06,boxb07,boxb08,'' ",
                            "      ,ibb02,ibb09",
                            "  FROM boxb_file,ibb_file ",
                            " WHERE boxb01 = '",tm.box01,"'",
                            "   AND boxb02 =  ",p_seq,"  ",
                            "   AND ibb01 = boxb05 ",
                            "   AND ibb02 IN ('A','I') ",
                            "   AND ibb06 = '",p_box04,"' ",
                            " UNION ",
                            " SELECT tlfb01,ibb05,tlfb02,tlfb03,tlfb04,'' ",
                            "      ,'',''",
                            "   FROM tlfb_file,ibb_file ",
                            "  WHERE tlfb01 = ibb01 ",
                            "    AND ibb02 IN ('A','I') ",
                            "    AND ibb06 = '",p_box04,"' ",
                            "    AND tlfb07 = '",tm.box01,"' ",
                            "    AND tlfb08 =  ",p_seq,"  ",
                            "    AND tlfb11 = 'abat062' "
              #No:DEV-CB0012--add--end
         END CASE
      END IF
   END IF

  #IF p_box11 = '52' THEN #No:DEV-CB0012--mark
   IF p_box11 = '1' THEN  #No:DEV-CB0012--add
      CASE g_argv1
         WHEN '1'
           #No:DEV-CB0012--mark--begin
           #LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
           #             "  FROM boxb_file,iba_file ",
           #             " WHERE boxb01 = '",tm.box01,"' ",
           #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
           #             "   AND iba04 = '",p_box11,"' AND iba06 = '",p_oba01,"' ",
           #             " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
           #             " ORDER BY boxb04,boxb05  "
           #No:DEV-CB0012--mark--end
           #No:DEV-CB0012--add--begin
            LET g_sql =  "SELECT DISTINCT boxb05,ibb05,boxb06,boxb07,boxb08,'' ",
                         "      ,ibb02,ibb09",
                         "  FROM boxb_file,ibb_file ",
                         " WHERE boxb01 = '",tm.box01,"' ",
                         "   AND ibb01 = boxb05 ",
                         "   AND ibb02 = 'H'",
                         "   AND ibb09 = '",p_oba01,"' ",
                         " ORDER BY boxb05  "
           #No:DEV-CB0012--add--end
         WHEN '5'
           #No:DEV-CB0012--mark--begin
           #LET g_sql =  "SELECT boxb04,boxb05,iba12,boxb06,boxb07,boxb08,'' ",
           #             "  FROM boxb_file,iba_file ",
           #             " WHERE boxb01 = '",tm.box01,"' ",
           #             "   AND iba00 = boxb04 AND iba01 = boxb05 ",
           #             "   AND iba04 = '",p_box11,"' AND iba06 = '",p_oba01,"' ",
           #             " GROUP BY boxb04,boxb05,iba12,boxb06,boxb07,boxb08  ",
           #             " UNION ",
           #             " SELECT tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04,'' ",
           #             "   FROM tlfb_file,iba_file ",
           #             "  WHERE tlfb00 = iba00 ",
           #             "    AND tlfb01 = iba01 ",
           #             "    AND iba04 = '",p_box11,"' AND iba06 = '",p_oba01,"' ",
           #             "    AND tlfb07 = '",tm.box01,"' ",
           #             "    AND tlfb11 = 'abat062' "
           #No:DEV-CB0012--mark--end
           #No:DEV-CB0012--add--begin
            LET g_sql =  "SELECT DISTINCT boxb05,ibb05,boxb06,boxb07,boxb08,'' ",
                         "      ,ibb02,ibb09",
                         "  FROM boxb_file,ibb_file ",
                         " WHERE boxb01 = '",tm.box01,"' ",
                         "   AND ibb01 = boxb05 ",
                         "   AND ibb02 = 'H'",
                         "   AND ibb09 = '",p_oba01,"' ",
                         " UNION ",
                         " SELECT tlfb01,ibb05,tlfb02,tlfb03,tlfb04,'' ",
                       "      ,'',''",
                         "   FROM tlfb_file,ibb_file ",
                         "  WHERE tlfb01 = ibb01 ",
                         "    AND ibb02 = 'H'",
                         "    AND ibb09 = '",p_oba01,"' ",
                         "    AND tlfb07 = '",tm.box01,"' ",
                         "    AND tlfb11 = 'abat062' "
           #No:DEV-CB0012--add--end
      END CASE
   END IF

  #IF p_box11 = '10' THEN #No:DEV-CB0012--mark
   IF p_box11 = '3' THEN  #No:DEV-CB0012--add
      #add by zhangym 120516 begin-----
      CASE g_argv1
         WHEN '1'
          #No:DEV-CB0012--mark--begin
          #LET g_sql = "SELECT tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04,SUM(tlfb05),'','' ",
          #            "  FROM iba_file,tlfb_file ",
          #            " WHERE iba01 = tlfb01 ",
          #            "   AND iba00 = tlfb00 ",
          #            "   AND tlfb11 = 'abat061' ",
          #            "   AND tlfb07 = '",p_slip,"' ",
          #            #"   AND iba04 = '",p_box11,"' ",
          #            "   AND iba09 = '",p_box04,"' ",
          #            " GROUP BY tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04 ",
          #            " ORDER BY tlfb00,tlfb01,tlfb02,tlfb03,tlfb04"
          #No:DEV-CB0012--mark--end
          #No:DEV-CB0012--add--begin
           LET g_sql = "SELECT tlfb01,ibb05,tlfb02,tlfb03,tlfb04,SUM(tlfb05) ",
                       "      ,ibb02,ibb09",
                       "  FROM ibb_file,tlfb_file ",
                       " WHERE ibb01 = tlfb01 ",
                       "   AND tlfb11 = 'abat061' ",
                       "   AND tlfb07 = '",p_slip,"' ",
                       "   AND ibb06 = '",p_box04,"' ",
                       " GROUP BY tlfb01,ibb05,tlfb02,tlfb03,tlfb04,ibb02,ibb09 ",
                       " ORDER BY tlfb01,tlfb02,tlfb03,tlfb04"
          #No:DEV-CB0012--add--end

         WHEN '3'
          #No:DEV-CB0012--mark--begin
          #LET g_sql = "SELECT tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04,SUM(tlfb05),'','' ",
          #            "  FROM iba_file,tlfb_file ",
          #            " WHERE iba01 = tlfb01 ",
          #            "   AND iba00 = tlfb00 ",
          #            "   AND tlfb11 = 'abat031' ",
          #            "   AND tlfb07 = '",p_slip,"' ",
          #            #"   AND iba04 = '",p_box11,"' ",
          #            "   AND iba09 = '",p_box04,"' ",
          #            " GROUP BY tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04 ",
          #            " ORDER BY tlfb00,tlfb01,tlfb02,tlfb03,tlfb04"
          #No:DEV-CB0012--mark--end
          #No:DEV-CB0012--add--begin
           LET g_sql = "SELECT tlfb01,ibb05,tlfb02,tlfb03,tlfb04,SUM(tlfb05) ",
                       "      ,ibb02,ibb09",
                       "  FROM ibb_file,tlfb_file ",
                       " WHERE ibb01 = tlfb01 ",
                       "   AND tlfb11 = 'abat031' ",
                       "   AND tlfb07 = '",p_slip,"' ",
                       "   AND ibb06 = '",p_box04,"' ",
                       " GROUP BY tlfb01,ibb05,tlfb02,tlfb03,tlfb04,ibb02,ibb09 ",
                       " ORDER BY tlfb01,tlfb02,tlfb03,tlfb04"
          #No:DEV-CB0012--add--end

        #No:DEV-CB0012--mark--begin
        #WHEN '4'
        #  LET g_sql = "SELECT tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04,SUM(tlfb05),'','' ",
        #              "  FROM iba_file,tlfb_file ",
        #              " WHERE iba01 = tlfb01 ",
        #              "   AND iba00 = tlfb00 ",
        #              "   AND tlfb11 = 'abat0371' ",
        #              "   AND tlfb07 = '",p_slip,"' ",
        #              #"   AND iba04 = '",p_box11,"' ",
        #              "   AND iba09 = '",p_box04,"' ",
        #              " GROUP BY tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04 ",
        #              " ORDER BY tlfb00,tlfb01,tlfb02,tlfb03,tlfb04"
        #No:DEV-CB0012--mark--end

         WHEN '5'
          #No:DEV-CB0012--mark--begin
          #LET g_sql = "SELECT tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04,'','','' ",
          #            "  FROM iba_file,tlfb_file ",
          #            " WHERE iba01 = tlfb01 ",
          #            "   AND iba00 = tlfb00 ",
          #            "   AND tlfb11 = 'abat061' ",
          #            "   AND tlfb07 = '",p_slip,"' ",
          #            "   AND iba04 = '",p_box11,"' ",
          #            "   AND iba01 = '",p_box04,"' ",
          #            " GROUP BY tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04 ",
          #            " UNION ",
          #            " SELECT tlfb00,tlfb01,iba12,tlfb02,tlfb03,tlfb04,'','','' ",
          #            "   FROM tlfb_file,iba_file ",
          #            "  WHERE tlfb00 = iba00 ",
          #            "    AND tlfb01 = iba01 ",
          #            "    AND tlfb07 = '",p_slip,"' ",
          #            "    AND iba04 = '",p_box11,"' ",
          #            "    AND iba01 = '",p_box04,"' ",
          #            "    AND tlfb11 = 'abat062' "
          #No:DEV-CB0012--mark--end
          #No:DEV-CB0012--add--begin
           LET g_sql = "SELECT tlfb01,ibb05,tlfb02,tlfb03,tlfb04,'' ",
                       "      ,ibb02,ibb09",
                       "  FROM ibb_file,tlfb_file ",
                       " WHERE ibb01 = tlfb01 ",
                       "   AND tlfb11 = 'abat061' ",
                       "   AND tlfb07 = '",p_slip,"' ",
                       "   AND ibb02 IN('F','G') ",
                       "   AND ibb01 = '",p_box04,"' ",
                       " GROUP BY tlfb01,ibb05,tlfb02,tlfb03,tlfb04,ibb02,ibb09 ",
                       " UNION ",
                       " SELECT tlfb01,ibb05,tlfb02,tlfb03,tlfb04,'','','' ",
                       "      ,'',''",
                       "   FROM tlfb_file,ibb_file ",
                       "  WHERE tlfb01 = ibb01 ",
                       "    AND tlfb07 = '",p_slip,"' ",
                       "    AND ibb02 IN('F','G') ",
                       "    AND ibb01 = '",p_box04,"' ",
                       "    AND tlfb11 = 'abat062' "
          #No:DEV-CB0012--add--end
      END CASE
      #add by zhangym 120516 end-----
   END IF

   PREPARE sabap620_pb_d FROM g_sql
   DECLARE imgb_cs CURSOR FOR sabap620_pb_d

   CALL g_imgb.clear()

#mark by zhangym 120516 begin-----
#   LET s_sets = 0
#   IF g_box[l_ac].box08 = 'N' THEN
#      LET s_sets = g_box[l_ac].sets
#   ELSE
#      FOR g_cnt = 1 TO g_rec_b
#          IF g_box[g_cnt].box04 = g_box[l_ac].box04 AND
#             g_box[g_cnt].box08 = 'Y' THEN
#             LET s_sets = s_sets + g_box[g_cnt].sets
#          END IF
#      END FOR
#   END IF
#mark by zhangym 120516 end-----
   LET g_cnt = 1
   FOREACH imgb_cs INTO g_imgb[g_cnt].*
                       ,l_ibb02,l_ibb09  #No:DEV-CB0012--add
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CASE g_argv1
          WHEN '1'
            #SELECT SUM(tlfb05) INTO g_imgb[g_cnt].imgb05 FROM tlfb_file #No:DEV-CB0002--mark
             SELECT -1*SUM(tlfb05*tlfb06) INTO g_imgb[g_cnt].imgb05 FROM tlfb_file #No:DEV-CB0002--add
             #WHERE tlfb00 = g_imgb[g_cnt].imgb00 #No:DEV-CB0012--mark
             #  AND tlfb01 = g_imgb[g_cnt].imgb01 #No:DEV-CB0012--mark
              WHERE tlfb01 = g_imgb[g_cnt].imgb01 #No:DEV-CB0012--add
                AND tlfb02 = g_imgb[g_cnt].imgb02
                AND tlfb03 = g_imgb[g_cnt].imgb03
                AND tlfb04 = g_imgb[g_cnt].imgb04
                AND tlfb11 = 'abat061'
                AND tlfb07 = tm.box01
             #GROUP BY tlfb00,tlfb01,tlfb02,tlfb03,tlfb04 #No:DEV-CB0012--mark
              GROUP BY tlfb01,tlfb02,tlfb03,tlfb04        #No:DEV-CB0012--add
             IF cl_null(g_imgb[g_cnt].imgb05) THEN
                LET g_imgb[g_cnt].imgb05 = 0
             END IF

            #No:DEV-CB0012--mark--begin
            #SELECT iba04,iba06,iba14 INTO l_iba04,l_iba06,l_iba14 FROM iba_file
            # WHERE iba00 = g_imgb[g_cnt].imgb00
            #   AND iba01 = g_imgb[g_cnt].imgb01
            #IF (l_iba04 = '50' OR l_iba04 = '501') AND NOT cl_null(l_iba14) THEN
            #   LET l_sql = "SELECT COUNT(*) FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05 FROM tlfb_file ",
            #               " WHERE tlfb00 = '",g_imgb[g_cnt].imgb00,"' ",
            #               "   AND tlfb01 LIKE '",l_iba14,"%' ",
            #               "   AND tlfb11 = 'abat061' ",
            #               "   AND tlfb07 = '",tm.box01,"' ",
            #               " GROUP BY tlfb00,tlfb01) a ",
            #               " WHERE a.s_tlfb05 > 0 "
            #   PREPARE boxb_prep FROM l_sql
            #   DECLARE boxb_cs CURSOR FOR boxb_prep
            #   EXECUTE boxb_cs INTO l_m
            #   IF l_m = 0 THEN
            #      CONTINUE FOREACH
            #   END IF
            #END IF
            #IF l_iba04 = '52' AND NOT cl_null(l_iba14) THEN
            #   LET l_sql = "SELECT COUNT(*) FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05 FROM tlfb_file ",
            #               " WHERE tlfb00 = '",g_imgb[g_cnt].imgb00,"' ",
            #               "   AND tlfb01 LIKE '",l_iba14,"%' ",
            #               "   AND tlfb11 = 'abat061' ",
            #               "   AND tlfb07 = '",tm.box01,"' ",
            #               "   AND tlfb18 = '",l_iba06,"' ",
            #               " GROUP BY tlfb00,tlfb01) a ",
            #               " WHERE a.s_tlfb05 > 0 "
            #   PREPARE boxb_prep1 FROM l_sql
            #   DECLARE boxb_cs1 CURSOR FOR boxb_prep1
            #   EXECUTE boxb_cs1 INTO l_m
            #   IF l_m = 0 THEN
            #      CONTINUE FOREACH
            #   END IF
            #END IF
            #No:DEV-CB0012--mark--end
            #No:DEV-CB0012--add--begin
             IF l_ibb02 = 'A' OR l_ibb02 = 'I' THEN  
                LET l_m = 0 
                LET l_sql = "SELECT COUNT(*) ",
                            "  FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05",
                            "          FROM tlfb_file ",
                            "         WHERE tlfb11 = 'abat061' ",
                            "           AND tlfb07 = '",tm.box01,"' ",
                            "         GROUP BY tlfb01) a ",
                            " WHERE a.s_tlfb05 > 0 "
                PREPARE boxb_prep FROM l_sql
                DECLARE boxb_cs CURSOR FOR boxb_prep
                EXECUTE boxb_cs INTO l_m                   
                IF l_m = 0 THEN 
                   CONTINUE FOREACH  
                END IF
             END IF 
             IF l_ibb02 = 'H' THEN 
                LET l_sql = "SELECT COUNT(*) ",
                            "  FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05",
                            "          FROM tlfb_file ",
                            "         WHERE tlfb11 = 'abat061' ",
                            "           AND tlfb07 = '",tm.box01,"' ",
                            "           AND tlfb18 = '",l_ibb09,"' ",
                            "         GROUP BY tlfb01) a ",
                            " WHERE a.s_tlfb05 > 0 "
                PREPARE boxb_prep1 FROM l_sql
                DECLARE boxb_cs1 CURSOR FOR boxb_prep1
                EXECUTE boxb_cs1 INTO l_m                   
                IF l_m = 0 THEN 
                   CONTINUE FOREACH  
                END IF
             END IF 
            #No:DEV-CB0012--add--end

          WHEN '3'
            #SELECT SUM(tlfb05) INTO g_imgb[g_cnt].imgb05 FROM tlfb_file #No:DEV-CB0002--mark
             SELECT -1*SUM(tlfb05*tlfb06) INTO g_imgb[g_cnt].imgb05 FROM tlfb_file #No:DEV-CB0002--add
             #WHERE tlfb00 = g_imgb[g_cnt].imgb00 #No:DEV-CB0012--mark
             #  AND tlfb01 = g_imgb[g_cnt].imgb01 #No:DEV-CB0012--mark
              WHERE tlfb01 = g_imgb[g_cnt].imgb01 #No:DEV-CB0012--add
                AND tlfb02 = g_imgb[g_cnt].imgb02
                AND tlfb03 = g_imgb[g_cnt].imgb03
                AND tlfb04 = g_imgb[g_cnt].imgb04
                AND tlfb11 = 'abat031'
                AND tlfb07 = tm.box01
             #GROUP BY tlfb00,tlfb01,tlfb02,tlfb03,tlfb04 #No:DEV-CB0012--mark
              GROUP BY tlfb01,tlfb02,tlfb03,tlfb04        #No:DEV-CB0012--add
             IF cl_null(g_imgb[g_cnt].imgb05) THEN
                LET g_imgb[g_cnt].imgb05 = 0
             END IF

            #No:DEV-CB0012--mark--begin
            #SELECT iba04,iba06,iba14 INTO l_iba04,l_iba06,l_iba14 FROM iba_file
            # WHERE iba00 = g_imgb[g_cnt].imgb00
            #   AND iba01 = g_imgb[g_cnt].imgb01
            #IF l_iba04 = '50' AND NOT cl_null(l_iba14) THEN
            #   LET l_sql = "SELECT COUNT(*) FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05 FROM tlfb_file ",
            #               " WHERE tlfb00 = '",g_imgb[g_cnt].imgb00,"' ",
            #               "   AND tlfb01 LIKE '",l_iba14,"%' ",
            #               "   AND tlfb11 = 'abat031' ",
            #               "   AND tlfb07 = '",tm.box01,"' ",
            #               " GROUP BY tlfb00,tlfb01) a ",
            #               " WHERE a.s_tlfb05 > 0 "
            #   PREPARE boxb_prep13 FROM l_sql
            #   DECLARE boxb_cs13 CURSOR FOR boxb_prep13
            #   EXECUTE boxb_cs13 INTO l_m
            #   IF l_m = 0 THEN
            #      CONTINUE FOREACH
            #   END IF
            #END IF
            #IF p_box11 = '50' AND l_iba04 = '501' AND NOT cl_null(l_iba14) THEN
            #   LET l_sql = "SELECT COUNT(*) FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05 FROM tlfb_file ",
            #               " WHERE tlfb00 = '",g_imgb[g_cnt].imgb00,"' ",
            #               "   AND tlfb01 LIKE '",l_iba14,l_iba06,"%' ",
            #               "   AND tlfb11 = 'abat031' ",
            #               "   AND tlfb07 = '",tm.box01,"' ",
            #               " GROUP BY tlfb00,tlfb01) a ",
            #               " WHERE a.s_tlfb05 > 0 "
            #   PREPARE boxb_prep132 FROM l_sql
            #   DECLARE boxb_cs132 CURSOR FOR boxb_prep132
            #   EXECUTE boxb_cs132 INTO l_m
            #   IF l_m = 0 THEN
            #      CONTINUE FOREACH
            #   END IF
            #END IF
            #No:DEV-CB0012--mark--end
            #No:DEV-CB0012--add--begin
             IF l_ibb02 = 'A' OR l_ibb02 = 'I' THEN 
                LET l_sql = "SELECT COUNT(*) ",
                            "  FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05",
                            "          FROM tlfb_file ",
                            "         WHERE tlfb11 = 'abat031' ",
                            "           AND tlfb07 = '",tm.box01,"' ",
                            "         GROUP BY tlfb01) a ",
                            " WHERE a.s_tlfb05 > 0 "
                PREPARE boxb_prep13 FROM l_sql
                DECLARE boxb_cs13 CURSOR FOR boxb_prep13
                EXECUTE boxb_cs13 INTO l_m                   
                IF l_m = 0 THEN 
                   CONTINUE FOREACH  
                END IF
             END IF 
            #No:DEV-CB0012--add--end

         #No:DEV-CB0012--mark--begin
         #WHEN '4'
         #   SELECT SUM(tlfb05) INTO g_imgb[g_cnt].imgb05 FROM tlfb_file
         #    WHERE tlfb00 = g_imgb[g_cnt].imgb00
         #      AND tlfb01 = g_imgb[g_cnt].imgb01
         #      AND tlfb02 = g_imgb[g_cnt].imgb02
         #      AND tlfb03 = g_imgb[g_cnt].imgb03
         #      AND tlfb04 = g_imgb[g_cnt].imgb04
         #      AND tlfb11 = 'abat0371'
         #      AND tlfb07 = tm.box01
         #    GROUP BY tlfb00,tlfb01,tlfb02,tlfb03,tlfb04
         #   IF cl_null(g_imgb[g_cnt].imgb05) THEN
         #      LET g_imgb[g_cnt].imgb05 = 0
         #   END IF
         #   SELECT iba04,iba06,iba14 INTO l_iba04,l_iba06,l_iba14 FROM iba_file
         #    WHERE iba00 = g_imgb[g_cnt].imgb00
         #      AND iba01 = g_imgb[g_cnt].imgb01
         #   IF l_iba04 = '50' AND NOT cl_null(l_iba14) THEN
         #      LET l_sql = "SELECT COUNT(*) FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05 FROM tlfb_file ",
         #                  " WHERE tlfb00 = '",g_imgb[g_cnt].imgb00,"' ",
         #                  "   AND tlfb01 LIKE '",l_iba14,"%' ",
         #                  "   AND tlfb11 = 'abat0371' ",
         #                  "   AND tlfb07 = '",tm.box01,"' ",
         #                  " GROUP BY tlfb00,tlfb01) a ",
         #                  " WHERE a.s_tlfb05 > 0 "
         #      PREPARE boxb_prep14 FROM l_sql
         #      DECLARE boxb_cs14 CURSOR FOR boxb_prep14
         #      EXECUTE boxb_cs14 INTO l_m
         #      IF l_m = 0 THEN
         #         CONTINUE FOREACH
         #      END IF
         #   END IF
         #   IF p_box11 = '50' AND l_iba04 = '501' AND NOT cl_null(l_iba14) THEN
         #      LET l_sql = "SELECT COUNT(*) FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05 FROM tlfb_file ",
         #                  " WHERE tlfb00 = '",g_imgb[g_cnt].imgb00,"' ",
         #                  "   AND tlfb01 LIKE '",l_iba14,l_iba06,"%' ",
         #                  "   AND tlfb11 = 'abat0371' ",
         #                  "   AND tlfb07 = '",tm.box01,"' ",
         #                  " GROUP BY tlfb00,tlfb01) a ",
         #                  " WHERE a.s_tlfb05 > 0 "
         #      PREPARE boxb_prep142 FROM l_sql
         #      DECLARE boxb_cs142 CURSOR FOR boxb_prep142
         #      EXECUTE boxb_cs142 INTO l_m
         #      IF l_m = 0 THEN
         #         CONTINUE FOREACH
         #      END IF
         #   END IF
         #No:DEV-CB0012--mark--end

          WHEN '5'
             SELECT (-1)*SUM(tlfb05*tlfb06) INTO g_imgb[g_cnt].imgb05 FROM tlfb_file
             #WHERE tlfb00 = g_imgb[g_cnt].imgb00 #No:DEV-CB0012--mark
             #  AND tlfb01 = g_imgb[g_cnt].imgb01 #No:DEV-CB0012--mark
              WHERE tlfb01 = g_imgb[g_cnt].imgb01 #No:DEV-CB0012--add
                AND tlfb02 = g_imgb[g_cnt].imgb02
                AND tlfb03 = g_imgb[g_cnt].imgb03
                AND tlfb04 = g_imgb[g_cnt].imgb04
                AND (tlfb11 = 'abat061' OR tlfb11 = 'abat062')
                AND tlfb07 = tm.box01
             #GROUP BY tlfb00,tlfb01,tlfb02,tlfb03,tlfb04 #No:DEV-CB0012--mark
              GROUP BY tlfb01,tlfb02,tlfb03,tlfb04        #No:DEV-CB0012--add
             IF cl_null(g_imgb[g_cnt].imgb05) THEN
                LET g_imgb[g_cnt].imgb05 = 0
             END IF

            #No:DEV-CB0012--mark--begin
            #SELECT iba04,iba06,iba14 INTO l_iba04,l_iba06,l_iba14 FROM iba_file
            # WHERE iba00 = g_imgb[g_cnt].imgb00
            #   AND iba01 = g_imgb[g_cnt].imgb01
            #IF (l_iba04 = '50' OR l_iba04 = '501') AND NOT cl_null(l_iba14) THEN
            #   LET l_sql = "SELECT COUNT(*) FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05 FROM tlfb_file ",
            #               " WHERE tlfb00 = '",g_imgb[g_cnt].imgb00,"' ",
            #               "   AND tlfb01 LIKE '",l_iba14,"%' ",
            #               "   AND tlfb11 = 'abat061' ",
            #               "   AND tlfb07 = '",tm.box01,"' ",
            #               " GROUP BY tlfb00,tlfb01) a ",
            #               " WHERE a.s_tlfb05 > 0 "
            #   PREPARE boxb_prep15 FROM l_sql
            #   DECLARE boxb_cs15 CURSOR FOR boxb_prep15
            #   EXECUTE boxb_cs15 INTO l_m
            #   IF l_m = 0 THEN
            #      CONTINUE FOREACH
            #   END IF
            #END IF
            #IF l_iba04 = '52' AND NOT cl_null(l_iba14) THEN
            #   LET l_sql = "SELECT COUNT(*) FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05 FROM tlfb_file ",
            #               " WHERE tlfb00 = '",g_imgb[g_cnt].imgb00,"' ",
            #               "   AND tlfb01 LIKE '",l_iba14,"%' ",
            #               "   AND tlfb11 = 'abat061' ",
            #               "   AND tlfb07 = '",tm.box01,"' ",
            #               "   AND tlfb18 = '",l_iba06,"' ",
            #               " GROUP BY tlfb00,tlfb01) a ",
            #               " WHERE a.s_tlfb05 > 0 "
            #   PREPARE boxb_prep25 FROM l_sql
            #   DECLARE boxb_cs25 CURSOR FOR boxb_prep25
            #   EXECUTE boxb_cs25 INTO l_m
            #   IF l_m = 0 THEN
            #      CONTINUE FOREACH
            #   END IF
            #END IF
            #No:DEV-CB0012--mark--end
            #No:DEV-CB0012--add--begin
             IF l_ibb02 = 'A' OR l_ibb02 = 'I' THEN 
                LET l_sql = "SELECT COUNT(*) ",
                            "  FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05",
                            "          FROM tlfb_file ",
                            "         WHERE tlfb11 = 'abat061' ",
                            "           AND tlfb07 = '",tm.box01,"' ",
                            "         GROUP BY tlfb01) a ",
                            " WHERE a.s_tlfb05 > 0 "
                PREPARE boxb_prep15 FROM l_sql
                DECLARE boxb_cs15 CURSOR FOR boxb_prep15
                EXECUTE boxb_cs15 INTO l_m                   
                IF l_m = 0 THEN 
                   CONTINUE FOREACH  
                END IF
             END IF 
             IF l_ibb02 = 'H' THEN 
                LET l_sql = "SELECT COUNT(*) ",
                            "  FROM (SELECT MAX(SUM(tlfb05)) s_tlfb05",
                            "          FROM tlfb_file ",
                            "         WHERE tlfb11 = 'abat061' ",
                            "           AND tlfb07 = '",tm.box01,"' ",
                            "           AND tlfb18 = '",l_ibb09,"' ",
                            "         GROUP BY tlfb01) a ",
                            " WHERE a.s_tlfb05 > 0 "
                PREPARE boxb_prep25 FROM l_sql
                DECLARE boxb_cs25 CURSOR FOR boxb_prep25
                EXECUTE boxb_cs25 INTO l_m                   
                IF l_m = 0 THEN 
                   CONTINUE FOREACH  
                END IF
             END IF 
            #No:DEV-CB0012--add--end
       END CASE
      #LET g_imgb[g_cnt].more = g_imgb[g_cnt].imgb05 - s_sets #No:DEV-CB0012--mark
       #INSERT INTO sabap620_temp(imgb00,imgb01,imgb02,imgb03,imgb04,imgb05)
       #VALUES(g_imgb[g_cnt].imgb00,g_imgb[g_cnt].imgb01,g_imgb[g_cnt].imgb02,
       #       g_imgb[g_cnt].imgb03,g_imgb[g_cnt].imgb04,g_imgb[g_cnt].imgb05)
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_imgb.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO idx3
   LET g_cnt = 0

END FUNCTION

FUNCTION sabap620_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_sql  STRING

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
  #CALL cl_set_act_visible("accept,cancel,close", FALSE)a   #DEV-CC0002 mark
   CALL cl_set_act_visible("accept,cancel", FALSE)          #DEV-CC0002 add
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_box TO s_box.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

          BEFORE ROW
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
               #非安库可以具体到工单条码
                IF g_box[l_ac].box08 = 'N' THEN
                   CALL sabap620_d_fill(g_box[l_ac].box11,g_box[l_ac].box12,tm.box01,
                                    g_box[l_ac].box02,g_box[l_ac].box04)
                   #CALL sabap620_refresh_sets(l_ac) RETURNING g_box[l_ac].sets
                ELSE
               #安库的话抓所有的配货单条码
                   CALL sabap620_d_fill(g_box[l_ac].box11,g_box[l_ac].box12,tm.box01,'',
                                    g_box[l_ac].box04)
                   #CALL sabap620_refresh_sets(l_ac) RETURNING g_box[l_ac].sets
                END IF
             END IF
      END DISPLAY


      DISPLAY ARRAY g_imgb TO s_imgb.* ATTRIBUTE(COUNT=g_rec_b2)
          BEFORE DISPLAY
            IF l_ac2 > 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF

          BEFORE ROW
             LET l_ac2  = ARR_CURR()
             IF l_ac2  > 0 THEN

             END IF
      END DISPLAY

      BEFORE DIALOG
         CALL cl_navigator_setting( g_curs_index, g_row_count )  #by zhangym 120606
         IF l_ac > 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF


     ON ACTION query
        LET g_action_choice="query"
        EXIT DIALOG

     ON ACTION post
        LET g_action_choice="post"
        EXIT DIALOG

     ON ACTION undo_post
        LET g_action_choice="undo_post"
        EXIT DIALOG

    #No:DEV-CB0012--mark--begin
    #ON ACTION void
    #   LET g_action_choice="void"
    #   EXIT DIALOG
    #No:DEV-CB0012--mark--end

     ON ACTION upd_post
        LET g_action_choice="upd_post"
        EXIT DIALOG

     ON ACTION delete_axmt620
        LET g_action_choice="delete_axmt620"
        EXIT DIALOG

#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DIALOG

      ON ACTION so_exp
         LET g_action_choice="so_exp"
         EXIT DIALOG

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         LET g_action_choice = 'locale'
         EXIT DIALOG

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION first
         CALL sabap620_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DIALOG


      ON ACTION previous
         CALL sabap620_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DIALOG


      ON ACTION jump
         CALL sabap620_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DIALOG


      ON ACTION next
         CALL sabap620_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DIALOG


      ON ACTION last
         CALL sabap620_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DIALOG

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG
  #CALL cl_set_act_visible("accept,cancel,close", TRUE)     #DEV-CC0002 mark
   CALL cl_set_act_visible("accept,cancel", TRUE)           #DEV-CC0002 add
END FUNCTION
 
#FUNCTION sabap620_b()
#DEFINE
#    p_style         LIKE type_file.chr1,                #由何种方式进入单身
#    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
#    l_n             LIKE type_file.num5,                #檢查重複用
#    l_lock_sw       LIKE type_file.chr1,
#    l_sql           STRING,
#    p_cmd           LIKE type_file.chr1,                #處理狀態
#    l_box01      LIKE box_file.box01,
#    l_box02      LIKE box_file.box02
#
#    LET g_action_choice = ""
#    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#
#    IF g_rec_b = 0 THEN RETURN END IF
#    CALL cl_opmsg('b')
#
#    LET g_forupd_sql = "SELECT box01,box02 ",
#                       "  FROM box_file",
#                       " WHERE box01 = ? AND box02=? ",
#                       "   FOR UPDATE"
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE sabap620_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#    INPUT ARRAY g_box WITHOUT DEFAULTS FROM s_box.*
#              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
#              UNBUFFERED, INSERT ROW =FALSE ,
#              DELETE ROW=FALSE,APPEND ROW=FALSE)
#
#      BEFORE INPUT
#            IF g_rec_b != 0 THEN
#               CALL fgl_set_arr_curr(l_ac)
#            END IF
#
#      BEFORE ROW
#            LET p_cmd = ''
#            LET l_ac = ARR_CURR()
#            LET l_n  = ARR_COUNT()
#            LET l_lock_sw = 'N'            #DEFAULT
#            LET g_success = 'Y'
#            LET g_box_t.* = g_box[l_ac].*
#            CALL sabap620_b_entry_b()
#            CALL sabap620_b_no_entry_b()
#            IF g_rec_b>=l_ac THEN
#               BEGIN WORK
#               LET p_cmd='u'
#               LET g_box_t.* = g_box[l_ac].*  #BACKUP
#               OPEN sabap620_bcl USING  tm.box01,g_box[l_ac].box02
#               IF STATUS THEN
#                  CALL cl_err("OPEN sabap620_bcl:", STATUS, 1)
#                  LET l_lock_sw = "Y"
#               ELSE
#                  FETCH sabap620_bcl INTO l_box01,l_box02
#                  IF SQLCA.sqlcode THEN
#                     CALL cl_err('',SQLCA.sqlcode,1)
#                     LET l_lock_sw = "Y"
#                  END IF
#               END IF
#               CALL cl_show_fld_cont()     #FUN-550037(smin)
#            END IF
#
#        BEFORE INSERT
#
#
#        AFTER INSERT
#            LET l_ac = ARR_CURR()
#            LET l_ac_t = l_ac
#            IF g_box[l_ac].box02 IS NULL THEN
#               CANCEL INSERT
#            END IF
#
#        ON ROW CHANGE
#           IF INT_FLAG THEN                 #新增程式段
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              LET g_box[l_ac].* = g_box_t.*
#              CLOSE sabap620_bcl
#              ROLLBACK WORK
#              CONTINUE INPUT
#           END IF
#           IF l_lock_sw="Y" THEN
#               CALL cl_err('',-263,0)
#               LET g_box[l_ac].* =g_box_t.*
#           ELSE
#               UPDATE box_file SET box05 = g_box[l_ac].box05,
#                                      box06 = g_box[l_ac].box06,
#                                      box13 = g_box[l_ac].box13
#               WHERE box01 = tm.box01
#                 AND box02 = g_box[l_ac].box02
#                MESSAGE 'UPDATE O.K'
#                COMMIT WORK
#           END IF
#
#        AFTER ROW
#           LET l_ac = ARR_CURR()         # 新增
#           LET l_ac_t = l_ac             # 新增
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              IF p_cmd='u' THEN
#                 LET g_box[l_ac].* = g_box_t.*
#              END IF
#              CLOSE sabap620_bcl            # 新增
#              ROLLBACK WORK         # 新增
#              EXIT INPUT
#           END IF
#           CLOSE sabap620_bcl            # 新增
#           COMMIT WORK
#
#      AFTER FIELD box06
#          IF NOT cl_null(g_box[l_ac].box06) THEN
#             IF g_box[l_ac].box06 <= 0 THEN
#                CALL cl_err('','aem-042',0)
#                NEXT FIELD box06
#             END IF
#          END IF
#
#        ON ACTION CONTROLZ
#           CALL cl_show_req_fields()
#
#        ON ACTION CONTROLG
#            CALL cl_cmdask()
#
#           ON IDLE g_idle_seconds
#              CALL cl_on_idle()
#              CONTINUE INPUT
#
#        END INPUT
#    IF INT_FLAG THEN
#       LET INT_FLAG = FALSE
#    END IF
#
#END FUNCTION
#
#FUNCTION sabap620_b_entry_b()
#
#    CALL cl_set_comp_entry('chk,box06,box13',TRUE)
#
#END FUNCTION
#
#FUNCTION sabap620_b_no_entry_b()
#
#    CALL cl_set_comp_entry('box02,box04,box05,sets',FALSE)
#
#END FUNCTION

FUNCTION sabap620_so_exp()
DEFINE  l_cmd   STRING
DEFINE  l_slip  LIKE oga_file.oga01
DEFINE  li_result LIKE type_file.num5
DEFINE  l_cnt   LIKE type_file.num5
DEFINE  l_cnt1  LIKE type_file.num5
DEFINE  l_m     LIKE type_file.num5
DEFINE  l_ogb09 LIKE ogb_file.ogb09
DEFINE  l_ogb091 LIKE ogb_file.ogb091
DEFINE  l_ogb092 LIKE ogb_file.ogb092
DEFINE  l_ogb05  LIKE ogb_file.ogb05
DEFINE  l_ogc    RECORD LIKE ogc_file.*
DEFINE  l_doc    LIKE oay_file.oayslip #DEV-CC0007 add

   IF cl_null(tm.box01) THEN
      RETURN  ''
   END IF
   IF g_rec_b =0 THEN RETURN '' END IF

   LET g_success = 'Y'
   CALL sabap620_exp_chk()
   IF g_success = 'N' THEN RETURN '' END IF

   IF NOT cl_confirm('abx-080') THEN RETURN '' END IF

  #DEV-CC0007--mark--str--
  ##TSD.JIE 單別如何取
  #SELECT oayslip INTO l_slip
  #  FROM oay_file
  # WHERE oaytype= '50' AND oayacti = 'Y'
  #   AND oayauno='Y'
  # ORDER BY oayslip
  #IF cl_null(l_slip) THEN
  #   CALL cl_err('','aba-022',1)
  #   RETURN ''
  #END IF
  #DEV-CC0007--mark--end--

   #DEV-CC0007 ----add---str---
   LET l_doc=s_get_doc_no(tm.box01)
   LET l_slip = ''
   SELECT oayb01 INTO l_slip
     FROM oayb_file 
    WHERE oaybslip = l_doc
   IF cl_null(l_slip) THEN
      #請在axmi010先設定此單別於條碼相關時的出貨單別!
      CALL cl_err(l_slip,'aba-130',1)
      RETURN ''
   END IF
   #DEV-CC0007 ----add---end---
   DROP TABLE oga_temp
   DROP TABLE ogb_temp
   SELECT * FROM oga_file WHERE oga01 = tm.box01 INTO TEMP oga_temp
   FOR l_cnt = 1 TO g_rec_b
      SELECT * FROM ogb_file WHERE ogb01 = tm.box01 AND ogb03 = g_box[l_cnt].box02
        INTO TEMP ogb_temp
   END FOR
   INSERT INTO ogb_temp SELECT * FROM ogb_file WHERE ogb01 = tm.box01 AND ogb04 LIKE 'MISC%'
   CALL s_auto_assign_no("axm",l_slip,g_today,"","oga_file","oga01","","","")
     RETURNING li_result,l_slip
   IF NOT li_result THEN
      LET g_success = 'N'
      RETURN  ''
   END IF
   BEGIN WORK

   UPDATE oga_temp SET oga011 = oga01 ,
                       oga69 = g_today,
                       oga02 = g_today,
                       ogaconf ='N',
                       oga55='0',
                       oga09='2',
                       ogaconu=NULL,
                       ogacond=NULL,
                       oga01 = l_slip,
                       oga99 = NULL,
                       oga905 = 'N',
                       oga906 = 'Y'
   UPDATE ogb_temp SET ogb01 = l_slip

   INSERT INTO oga_file SELECT * FROM oga_temp
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","oga_file","g_oga.oga01","",SQLCA.sqlcode,"","ins oga",1)
      LET g_success ='N'
      RETURN ''
   END IF

   FOR g_cnt = 1 TO g_rec_b
     #IF g_box[g_cnt].box11 = '10' THEN #No:DEV-CB0012--mark
      IF g_box[g_cnt].box11 = '3' THEN  #No:DEV-CB0012--add
         CASE g_argv1
           WHEN '1'
           LET l_m = 0
          #No:DEV-CB0012--mark--begin
          #SELECT COUNT(*) INTO l_m FROM (SELECT DISTINCT tlfb02,tlfb03,tlfb04
          #  FROM iba_file,tlfb_file
          # WHERE iba01 = tlfb01
          #   AND iba00 = tlfb00
          #   AND tlfb11 = 'abat061'
          #   AND tlfb07 = tm.box01
          #   AND iba04 = g_box[g_cnt].box11
          #   AND iba01 = g_box[g_cnt].box04)
          #No:DEV-CB0012--mark--end
          #No:DEV-CB0012--add--begin
           SELECT COUNT(*) INTO l_m 
             FROM(SELECT DISTINCT tlfb02,tlfb03,tlfb04
                    FROM ibb_file,tlfb_file 
                   WHERE ibb01 = tlfb01
                     AND tlfb11 = 'abat061' 
                     AND tlfb07 = tm.box01
                     AND ibb02 IN ('F','G')     
                     AND ibb01 = g_box[g_cnt].box04)
          #No:DEV-CB0012--add--end
           IF l_m = 1 THEN
             #No:DEV-CB0012--mark--begin
             #SELECT DISTINCT tlfb02,tlfb03,tlfb04 INTO l_ogb09,l_ogb091,l_ogb092
             #  FROM iba_file,tlfb_file
             # WHERE iba01 = tlfb01
             #   AND iba00 = tlfb00
             #   AND tlfb11 = 'abat061'
             #   AND tlfb07 = tm.box01
             #   AND iba04 = g_box[g_cnt].box11
             #   AND iba01 = g_box[g_cnt].box04
             #No:DEV-CB0012--mark--end
             #No:DEV-CB0012--add--begin
               SELECT DISTINCT tlfb02,tlfb03,tlfb04
                 INTO l_ogb09,l_ogb091,l_ogb092
                 FROM ibb_file,tlfb_file 
                WHERE ibb01 = tlfb01
                  AND tlfb11 = 'abat061' 
                  AND tlfb07 = tm.box01
                  AND ibb02 IN ('F','G')     
                  AND ibb01 = g_box[g_cnt].box04
             #No:DEV-CB0012--add--end

              UPDATE ogb_temp SET ogb09 = l_ogb09,
                                  ogb091 = l_ogb091,
                                  ogb092 = l_ogb092
                            WHERE ogb01 = l_slip
                              AND ogb03 = g_box[g_cnt].box02
           ELSE
             LET g_sql = "SELECT DISTINCT tlfb02,tlfb03,tlfb04 ",
                         "  FROM iba_file,tlfb_file ",
                         " WHERE iba01 = tlfb01 ",
                        #"   AND iba00 = tlfb00 ", #No:DEV-CB0002--mark
                         "   AND tlfb11 = 'abat061' ",
                         "   AND tlfb07 = '",tm.box01,"' ",
                         "   AND iba04 = '",g_box[g_cnt].box11,"'  ",
                         "   AND iba01 = '",g_box[g_cnt].box04,"'  "
             PREPARE ogb_prep FROM g_sql
             DECLARE ogb_cs CURSOR FOR ogb_prep
             FOREACH ogb_cs INTO l_ogb09,l_ogb091,l_ogb092
                INITIALIZE l_ogc.* TO NULL
                LET l_ogc.ogc01 = l_slip
                LET l_ogc.ogc03 = g_box[g_cnt].box02
                LET l_ogc.ogc09 = l_ogb09
                LET l_ogc.ogc091 = l_ogb091
                LET l_ogc.ogc092 = l_ogb092
                SELECT SUM(tlfb05) INTO l_ogc.ogc12
                  FROM tlfb_file
                #WHERE tlfb00 = '1' #No:DEV-CB0002--mark
                 WHERE tlfb01 = g_box[g_cnt].box04
                   AND tlfb02 = l_ogb09
                   AND tlfb03 = l_ogb091
                   AND tlfb04 = l_ogb092
                   AND tlfb07 = tm.box01
                   AND tlfb11 = 'abat061'
               SELECT img09 INTO l_ogc.ogc15
                 FROM img_file
                WHERE img01 = g_box[g_cnt].box04
                  AND img02 = l_ogb09
                  AND img03 = l_ogb091
                  AND img04 = l_ogb092
               SELECT ogb05 INTO l_ogb05 FROM ogb_temp
                WHERE ogb01 = l_slip
                  AND ogb03 = g_box[g_cnt].box02
               IF NOT cl_null(l_ogc.ogc15) THEN
                  CALL s_umfchk(g_box[g_cnt].box04,l_ogb05,l_ogc.ogc15)
                      RETURNING l_cnt1,l_ogc.ogc15_fac
               END IF
               IF cl_null(l_ogc.ogc15_fac) THEN
                  LET l_ogc.ogc15_fac = 1
               END IF
               LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
               LET l_ogc.ogc17 = g_box[g_cnt].box04
               SELECT MAX(ogc18) INTO l_ogc.ogc18 FROM ogc_file
                WHERE ogc01 = l_ogc.ogc01
                  AND ogc03 = l_ogc.ogc03
               IF cl_null(l_ogc.ogc18) THEN
                  LET l_ogc.ogc18 = 1
               ELSE
                  LET l_ogc.ogc18 = l_ogc.ogc18 + 1
               END IF
               LET l_ogc.ogcplant = g_plant
               LET l_ogc.ogclegal = g_legal
               INSERT INTO ogc_file VALUES(l_ogc.*)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","ogc_file","l_ogc.ogc01","l_ogc.ogc03",SQLCA.sqlcode,"","ins ogc",1)
                  LET g_success ='N'
                  RETURN
               END IF
               UPDATE ogb_temp SET ogb17 = 'Y'
                WHERE ogb01 = l_slip
                  AND ogb03 = g_box[g_cnt].box02
            END FOREACH
           END IF
         END CASE
      END IF
         UPDATE ogb_temp SET ogb12 =  g_box[g_cnt].box06,
                             ogb917 = g_box[g_cnt].box06,
                             ogb14 =  ogb14 * g_box[g_cnt].box06/ogb12,
                             ogb14t = ogb14t* g_box[g_cnt].box06/ogb12
          WHERE ogb01 = l_slip
            AND ogb03 = g_box[g_cnt].box02
   END FOR
   INSERT INTO ogb_file SELECT * FROM ogb_temp
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","ogb_file","g_ogb.ogb01","",SQLCA.sqlcode,"","ins ogb",1)
      LET g_success ='N'
      RETURN ''
   END IF
   RETURN l_slip
   #CALL sabap620_split_tlfb()
   #LET l_cmd = "axmp620 '",tm.box01,"' '",g_today,"' '",l_slip,"' 'Y' "
   #CALL cl_cmdrun_wait(l_cmd)

END FUNCTION


FUNCTION sabap620_exp_chk()
 DEFINE l_cnt LIKE type_file.num5

   FOR g_cnt = 1 TO g_rec_b
      IF g_box[g_cnt].box06 != g_box[g_cnt].sets THEN
         CALL cl_err('','aba-021',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOR
   SELECT COUNT(*) INTO l_cnt FROM oga_file
    WHERE oga011 = tm.box01
   IF l_cnt > 0 THEN
      CALL cl_err(tm.box01,'aba-023',1)
      LET g_success = 'N'
      RETURN
   END IF

  #CALL sabap620_multiWare_chk() #No:DEV-CB0012--mark

END FUNCTION


#No:DEV-CB0012--mark--begin
##检查同个料的条码是否各个齐套
#FUNCTION sabap620_multiWare_chk()
#  DEFINE p_slip  LIKE tlfb_file.tlfb09
#
#   FOR g_cnt = 1 TO g_rec_b
#      IF g_box[g_cnt].box08 = 'N'  THEN
#         CONTINUE FOR
#      END IF
#
#      LET g_sql = "SELECT tlfb01,iba12,tlfb02,tlfb03,tlfb04,SUM(tlfb05) ",
#               "  FROM iba_file,tlfb_file ",
#               " WHERE iba01 = tlfb01 ",
#               "   AND iba00 = tlfb00 ",
#               "   AND tlfb11 = 'abat620' ",
#               "   AND tlfb09 = '",p_slip,"' ",
#               " GROUP BY tlfb01,iba12,tlfb02,tlfb03,tlfb04 ",
#               " ORDER BY tlfb01,tlfb02,tlfb03,tlfb04"
#   END FOR
#
#END FUNCTION
#No:DEV-CB0012--mark--end


#No:DEV-CB0002--mark--begin
#拆分并回写条码异动记录档中的出货通知单项次(tlfb10)
#FUNCTION sabap620_split_tlfb(p_slip)
# DEFINE p_slip  LIKE box_file.box01
# DEFINE l_sql   STRING
#
#   LET g_sql = "SELECT tlfb01,iba12,tlfb02,tlfb03,tlfb04,tlfb05,tlfb06 ",
#               "  FROM iba_file,tlfb_file ",
#               " WHERE iba01 = tlfb01 ",
#               "   AND iba00 = tlfb00 ",
#               "   AND tlfb11 = 'abat620' ",
#               "   AND tlfb09 = '",p_slip,"' ",
#               " ORDER BY tlfb01,tlfb02,tlfb03,tlfb04"
#
#   PREPARE sabap620_split FROM g_sql
#   DECLARE split_cs CURSOR FOR sabap620_split
#
#END FUNCTION
#No:DEV-CB0002--mark--end

#mark by zhangym 120606 begin-----
#FUNCTION sabap620_refresh_sets(p_ac)
#DEFINE p_ac   LIKE type_file.num5
#DEFINE l_cnt  LIKE type_file.num5
#DEFINE l_sets LIKE type_file.num10
#DEFINE l_sum  LIKE type_file.num10
#DEFINE m_box09   LIKE box_file.box09
#
# IF g_rec_b2 = 0 THEN
#    LET l_sets = 0
#    RETURN l_sets
# END IF
#
#  #add by zhangym 120516 begin-----
# IF g_box[p_ac].box11 = '52' OR g_box[p_ac].box11 = '10' THEN
#    LET l_sets = g_imgb[1].imgb05
#    IF cl_null(l_sets) THEN LET l_sets = 0 END IF
#    FOR l_cnt = 1 TO g_rec_b2
#
#       IF cl_null(g_imgb[l_cnt].imgb05) THEN
#          LET g_imgb[l_cnt].imgb05 = 0
#       END IF
#
#       IF g_imgb[l_cnt].imgb05 < l_sets THEN
#          LET l_sets = g_imgb[l_cnt].imgb05
#       END IF
#
#    END FOR
#    IF l_sets > 0 THEN
#       LET l_sets = g_box[p_ac].box06
#    END IF
#  ELSE
#  #add by zhangym 120516 end-----
#  CASE g_argv1
#   WHEN '1'
#    LET g_sql = " SELECT box09 FROM box_file WHERE box01 = '",tm.box01,"' ",
#                "    AND box02 = '",g_box[p_ac].box02,"' ",
#                "    AND box04 = '",g_box[p_ac].box04,"' "
#    PREPARE box_pb1 FROM g_sql
#    DECLARE box_cs1 CURSOR FOR box_pb1
#    FOREACH box_cs1 INTO m_box09
#         LET g_sql = "SELECT MIN(SUM(tlfb05)) FROM tlfb_file ",
#                     " WHERE tlfb01 LIKE '",m_box09,"%' ",
#                     "   AND tlfb11 = 'abat061' ",
#                     "   AND tlfb07 = '",tm.box01,"' ",
#                     " GROUP BY tlfb00,tlfb01 "
#         PREPARE box_pb2 FROM g_sql
#         DECLARE box_cs2 CURSOR FOR box_pb2
#         EXECUTE box_cs2 INTO l_sum
#         IF cl_null(l_sum) THEN
#            LET l_sum = 0
#         END IF
#         IF cl_null(l_sets) THEN
#            LET l_sets = 0
#         ELSE
#            LET l_sets = l_sets + l_sum
#         END IF
#     END FOREACH
#   END CASE
#   END IF  #add by zhangym 120516
# RETURN l_sets
#
#END FUNCTION
#mark by zhangym 120606 end-----

FUNCTION sabap620_upd_post()
DEFINE l_slip  LIKE oga_file.oga01

   IF g_rec_b = 0 THEN RETURN END IF

   IF g_argv1 = '5' THEN
      CALL sabap620_upd_post_pre_chk() RETURNING l_slip
      IF g_success = 'N' THEN RETURN END IF
      LET g_cmd = "axmt620 '",l_slip,"' 'query' "
   END IF

   CALL cl_cmdrun_wait(g_cmd)

END FUNCTION

FUNCTION sabap620_upd_post_pre_chk()
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_des   STRING
   DEFINE l_ogapost  LIKE oga_file.ogapost
   DEFINE l_ogaconf  LIKE oga_file.ogaconf
   DEFINE l_slip  LIKE oga_file.oga01
   DEFINE l_oga01 LIKE oga_file.oga01
 
   BEGIN WORK
   LET g_success = 'Y'

   FOR l_cnt = 1 TO g_rec_b
      SELECT oga01 INTO l_oga01 FROM oga_file
       WHERE oga011 = tm.box01

      IF SQLCA.sqlcode THEN
         CALL cl_err(tm.box01,'aba-057',0)
         LET g_success = 'N'
      END IF

      SELECT ogaconf,ogapost INTO l_ogaconf,l_ogapost FROM oga_file
       WHERE oga011 = tm.box01

      IF l_ogapost = 'Y' OR l_ogaconf = 'Y' THEN
         CALL cl_err(tm.box01,'aba-046',0)
         LET g_success = 'N'
      END IF
      IF g_box[l_cnt].return_sets = -1 THEN
         LET g_success = 'N'
         CALL cl_err(tm.box01,'aba-059',1)
      END IF
      IF g_success = 'N' THEN
         #CALL cl_err(l_des,'!',1)
         RETURN ''
      END IF
   END FOR

   FOR l_cnt = 1 TO g_rec_b
      DROP TABLE ogb_temp
      SELECT * FROM ogb_file
       WHERE ogb01 = tm.box01
         AND ogb03 = g_box[l_cnt].box02
        INTO TEMP ogb_temp

      SELECT oga01 INTO l_slip FROM oga_file
       WHERE oga011 = tm.box01
      
      UPDATE ogb_temp SET ogb01 = l_slip
     #IF g_box[l_cnt].box11 = '10' AND g_box[l_cnt].return_sets = 0 THEN #No:DEV-CB0012--mark
      IF g_box[l_cnt].box11 = '3' AND g_box[l_cnt].return_sets = 0 THEN  #No:DEV-CB0012--add
         CONTINUE FOR
      END IF
      DELETE FROM ogb_file WHERE ogb01 = l_slip AND ogb03 = g_box[l_cnt].box02
      DELETE FROM ogc_file WHERE ogc01 = l_slip AND ogb03 = g_box[l_cnt].box02
      IF g_box[l_cnt].sets - g_box[l_cnt].return_sets = 0 THEN
         CONTINUE FOR
      END IF
     #IF g_box[l_cnt].box11 = '10' THEN #No:DEV-CB0012--mark
      IF g_box[l_cnt].box11 = '3' THEN  #No:DEV-CB0012--add
         UPDATE ogb_temp SET ogb09 = '',
                             ogb091 = '',
                             ogb092 = ''
                       WHERE ogb01 = l_slip
                         AND ogb03 = g_box[l_cnt].box02
      END IF
      UPDATE ogb_temp SET ogb12 =  g_box[l_cnt].sets - g_box[l_cnt].return_sets,
                          ogb917 = g_box[l_cnt].sets - g_box[l_cnt].return_sets,
                          ogb14 =  ogb14 * (g_box[l_cnt].sets - g_box[l_cnt].return_sets)/ogb12,
                          ogb14t = ogb14t* (g_box[l_cnt].sets - g_box[l_cnt].return_sets)/ogb12
       WHERE ogb01 = l_slip
         AND ogb03 = g_box[l_cnt].box02
      INSERT INTO ogb_file SELECT * FROM ogb_temp
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ogb_file",l_slip,g_box[l_cnt].box02,SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         EXIT FOR
      END IF
   END FOR
   
   IF g_success = 'Y' THEN
      CALL cl_err(l_slip,'aba-060',1)
      COMMIT WORK
      DROP TABLE ogb_temp
      RETURN l_slip
   ELSE
      CALL cl_err(l_slip,'aba-061',1)
      ROLLBACK WORK
      DROP TABLE ogb_temp
      RETURN ''
   END IF

END FUNCTION

FUNCTION sabap620_post()

   IF g_rec_b = 0 THEN RETURN END IF
  #No:DEV-CB0012--mark--begin
  #IF g_argv1 = '4' THEN
  #   CALL sabap620_b_fill(tm.box01)
  #   CALL sabap620_post_pre_chk_cimt327()
  #   IF g_success = 'N' THEN RETURN END IF
  #   LET g_cmd = "cimt327 '",tm.box01,"' 'query' 'abat3271'"
  #END IF
  #No:DEV-CB0012--mark--end
   IF g_argv1 = '3' THEN
      CALL sabap620_b_fill(tm.box01)
      CALL sabap620_post_pre_chk()
      IF g_success = 'N' THEN RETURN END IF
      LET g_cmd = "aimt301 '",tm.box01,"' 'query' 'abat3011' "
   END IF
   CALL cl_cmdrun_wait(g_cmd)

END FUNCTION

#No:DEV-CB0012--mark--begin
#FUNCTION sabap620_post_pre_chk_cimt327()
#  DEFINE l_cnt   LIKE type_file.num5
#  DEFINE l_des   STRING
#
#  LET g_success = 'Y'
#  FOR l_cnt = 1 TO g_rec_b
#      IF g_box[l_cnt].sets != g_box[l_cnt].box06 THEN
#         LET g_success = 'N'
#         LET l_des = "项次",g_box[l_cnt].box02," 杂发调整数量 与 齐套数量不匹配\n"
#      END IF
#
#      IF g_success = 'N' THEN
#         CALL cl_err(l_des,'!',1)
#         RETURN
#      END IF
#  END FOR
#
#END FUNCTION
#No:DEV-CB0012--mark--end

FUNCTION sabap620_post_pre_chk()
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_des   STRING
  DEFINE l_inb09 LIKE inb_file.inb09
  DEFINE l_inapost  LIKE ina_file.inapost

  BEGIN WORK
  LET g_success = 'Y'
  FOR l_cnt = 1 TO g_rec_b
        SELECT inapost INTO l_inapost FROM ina_file
         WHERE ina01 = tm.box01

        IF l_inapost = 'Y' THEN
           CALL cl_err(tm.box01,'aba-046',0)
           LET g_success = 'N'
           EXIT FOR
        END IF
      SELECT inb09 INTO l_inb09 FROM inb_file
       WHERE inb01 = tm.box01
         AND inb03 = g_box[l_cnt].box02
      IF g_box[l_cnt].sets != g_box[l_cnt].box06 THEN
         LET g_success = 'N'
        #LET l_des = "项次",g_box[l_cnt].box02," 杂发出数量 与 齐套出数量不匹配\n"  #No:DEV-CB0012--mark
         LET l_des = cl_getmsg('aap-417',g_lang),g_box[l_cnt].box02,                #No:DEV-CB0012--add
                     cl_getmsg('aba-115',g_lang)                                    #No:DEV-CB0012--add
      END IF

      IF g_success = 'N' THEN
           CALL cl_err(l_des,'!',1)
           RETURN
        END IF
    END FOR

    FOR l_cnt = 1 TO g_rec_b
        UPDATE inb_file SET inb09 = g_box[l_cnt].box06
         WHERE inb01 = tm.box01
           AND inb03 = g_box[l_cnt].box02
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","inb_file",tm.box01,g_box[l_cnt].box02,SQLCA.sqlcode,"","",1)
           LET g_success = 'N'
           EXIT FOR
        END IF
    END FOR

    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF

END FUNCTION

FUNCTION sabap620_undo_post()

   IF g_rec_b = 0 THEN RETURN END IF
   CALL sabap620_undo_post_pre_chk()
   IF g_success = 'N' THEN RETURN END IF
   LET g_cmd = "aimt301 '",tm.box01,"' 'query' "
   CALL cl_cmdrun_wait(g_cmd)

END FUNCTION

FUNCTION sabap620_undo_post_pre_chk()
 DEFINE l_inapost LIKE ina_file.inapost

   LET g_success = 'Y'
   SELECT inapost INTO l_inapost FROM ina_file
    WHERE ina01 = tm.box01

   IF l_inapost = 'N' THEN
      CALL cl_err(tm.box01,'aba-044',0)
      LET g_success = 'N'
      RETURN
   END IF

END FUNCTION

#No:DEV-CB0012--mark--begin
#FUNCTION sabap620_void()
#
#   IF g_rec_b = 0 THEN RETURN END IF
#   CALL sabap620_void_pre_chk()
#   IF g_success = 'N' THEN RETURN END IF
#   LET g_cmd = "aimt301 '",tm.box01,"' 'query' "
#   CALL cl_cmdrun_wait(g_cmd)
#
#END FUNCTION
#
#FUNCTION sabap620_void_pre_chk()
#  DEFINE l_cnt   LIKE type_file.num5
#  DEFINE l_des   STRING
#  DEFINE l_inb09 LIKE inb_file.inb09
#  DEFINE l_inaconf  LIKE ina_file.inaconf
#
#    LET g_success = 'Y'
#    SELECT inaconf INTO l_inaconf FROM ina_file WHERE ina01 = tm.box01
#    IF l_inaconf = 'X' THEN
#       CALL cl_err(tm.box01,'aba-045',0)
#       LET g_success = 'N'
#       RETURN
#    END IF
#    FOR l_cnt = 1 TO g_rec_b
#        SELECT inb09 INTO l_inb09 FROM inb_file
#         WHERE inb01 = tm.box01
#           AND inb03 = g_box[l_cnt].box02
#        IF g_box[l_cnt].sets > 0 OR g_box[l_cnt].box06 > 0 THEN
#           LET g_success = 'N'
#           LET l_des = "项次",g_box[l_cnt].box02," 杂发出数量 与 齐套出数量必须同时为0才可作废\n"
#        END IF
#        IF g_success = 'N' THEN
#           CALL cl_err(l_des,'!',1)
#           RETURN
#        END IF
#    END FOR
#
#END FUNCTION
#
#FUNCTION sabap620_delete_axmt620()
#
#   IF g_rec_b = 0 THEN RETURN END IF
#   CALL sabap620_delete_axmt620_pre_chk()
#   IF g_success = 'N' THEN RETURN END IF
#   LET g_cmd = "axmt620 2 'query' "
#   CALL cl_cmdrun_wait(g_cmd)
#
#END FUNCTION
#
#FUNCTION sabap620_delete_axmt620_pre_chk()
#  DEFINE l_cnt   LIKE type_file.num5
#  DEFINE l_des   STRING
#  DEFINE l_ogapost  LIKE oga_file.ogapost
#  DEFINE l_m     LIKE type_file.num5
#
#    LET g_success = 'Y'
#    FOR l_cnt = 1 TO g_rec_b
#        LET l_m = 0
#        SELECT COUNT(*) INTO l_m FROM oga_file
#         WHERE oga011 = tm.box01
#
#        IF l_m = 0 THEN
#           CALL cl_err(tm.box01,'aba-049',0)
#           LET g_success = 'N'
#           EXIT FOR
#        END IF
#
#        SELECT ogapost INTO l_ogapost FROM oga_file
#         WHERE oga011 = tm.box01
#
#        IF l_ogapost = 'Y' THEN
#           CALL cl_err(tm.box01,'aba-046',0)
#           LET g_success = 'N'
#           EXIT FOR
#        END IF
#        IF g_box[l_cnt].sets != 0 THEN
#           LET g_success = 'N'
#           LET l_des = "项次",g_box[l_cnt].box02," 齐套数不为0不可执行出货单删除\n"
#        END IF
#        IF g_success = 'N' THEN
#           CALL cl_err(l_des,'!',1)
#           RETURN
#        END IF
#    END FOR
#
#END FUNCTION
#No:DEV-CB0012--mark--end

#No:DEV-CB0002--add--begin
FUNCTION p620_sets(p_box01,p_box02,p_tlfb11)
   DEFINE p_box01   LIKE box_file.box01
   DEFINE p_box02   LIKE box_file.box02
   DEFINE p_tlfb11  LIKE tlfb_file.tlfb11
   DEFINE l_boxb03  LIKE boxb_file.boxb03
   DEFINE l_sql     STRING
   DEFINE l_boxb    RECORD LIKE boxb_file.*
   DEFINE l_qty     LIKE tlfb_file.tlfb05
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_min_tot LIKE tlfb_file.tlfb05
   DEFINE l_min     LIKE tlfb_file.tlfb05

   #找出該張單子有幾組工單條碼
   LET l_sql = " SELECT DISTINCT boxb03 FROM boxb_file",               
               "  WHERE boxb01 = '",p_box01,"'",
               "    AND boxb02 =  ",p_box02
   PREPARE sel_boxb_pb FROM l_sql
   DECLARE sel_boxb_cs CURSOR FOR sel_boxb_pb 


   LET l_sql = " SELECT * FROM boxb_file",
               "  WHERE boxb01 = '",p_box01,"'",
               "    AND boxb02 =  ",p_box02,
               "    AND boxb03 = ?"
   PREPARE sel_boxb_pb2 FROM l_sql
   DECLARE sel_boxb_cs2 CURSOR FOR sel_boxb_pb2

   LET l_min_tot = 0
   FOREACH sel_boxb_cs INTO l_boxb03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      #找出該組條碼最小掃描數量
      LET l_min = 9999999999
      LET l_flag = 'N'
      FOREACH sel_boxb_cs2 USING l_boxb03 INTO l_boxb.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_flag = 'Y'
 
         LET l_qty = 0
         SELECT -1*SUM(tlfb05*tlfb06) INTO l_qty
           FROM tlfb_file
          WHERE tlfb01 = l_boxb.boxb05
            AND tlfb11 = p_tlfb11
            AND tlfb07 = tm.box01
            AND tlfb02 = l_boxb.boxb06 #倉庫 #DEV-CC0007 add
            AND tlfb03 = l_boxb.boxb07 #儲位 #DEV-CC0007 add
          GROUP BY tlfb01
         IF cl_null(l_qty) THEN LET l_qty = 0 END IF

         IF l_min > l_qty THEN
            LET l_min = l_qty 
         END IF
      END FOREACH
      IF l_flag = 'N' THEN
         LET l_min_tot = 0
      END IF

      LET l_min_tot = l_min_tot + l_min
   END FOREACH

   RETURN l_min_tot
END FUNCTION


FUNCTION p620_return_sets(p_box01,p_box02,p_tlfb11)
   DEFINE p_box01   LIKE box_file.box01
   DEFINE p_box02   LIKE box_file.box02
   DEFINE p_tlfb11  LIKE tlfb_file.tlfb11
   DEFINE l_boxb03  LIKE boxb_file.boxb03
   DEFINE l_sql     STRING
   DEFINE l_boxb    RECORD LIKE boxb_file.*
   DEFINE l_qty     LIKE tlfb_file.tlfb05
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_min_tot LIKE tlfb_file.tlfb05
   DEFINE l_min     LIKE tlfb_file.tlfb05
   DEFINE l_max     LIKE tlfb_file.tlfb05

   #找出該張單子有幾組工單條碼
   LET l_sql = " SELECT DISTINCT boxb03 FROM boxb_file",
               "  WHERE boxb01 = '",p_box01,"'",
               "    AND boxb02 =  ",p_box02
   PREPARE sel_boxb_pb3 FROM l_sql
   DECLARE sel_boxb_cs3 CURSOR FOR sel_boxb_pb3


   LET l_sql = " SELECT * FROM boxb_file",
               "  WHERE boxb01 = '",p_box01,"'",
               "    AND boxb02 =  ",p_box02,
               "    AND boxb03 = ?"
   PREPARE sel_boxb_pb4 FROM l_sql
   DECLARE sel_boxb_cs4 CURSOR FOR sel_boxb_pb4

   LET l_min_tot = 0
   FOREACH sel_boxb_cs3 INTO l_boxb03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      #找出該組條碼最小掃描數量
      LET l_min = 9999999999
      LET l_max = 0
      LET l_flag = 'N'
      FOREACH sel_boxb_cs4 USING l_boxb03 INTO l_boxb.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         LET l_qty = 0
         SELECT -1*SUM(tlfb05*tlfb06) INTO l_qty
           FROM tlfb_file
          WHERE tlfb01 = l_boxb.boxb05
            AND tlfb11 = p_tlfb11
            AND tlfb07 = tm.box01
          GROUP BY tlfb01
         IF cl_null(l_qty) THEN LET l_qty = 0 END IF

         IF l_flag = 'N' THEN
            LET l_max = l_qty 
            LET l_min = l_qty 
         ELSE
            IF l_max < l_qty THEN
               LET l_max = l_qty 
            END IF
            IF l_min > l_qty THEN
               LET l_min = l_qty 
            END IF
         END IF

         LET l_flag = 'Y'
      END FOREACH
      IF l_flag = 'N' THEN
         LET l_min_tot = -1
         EXIT FOREACH
      END IF

      IF l_max <> l_min THEN
         LET l_min_tot = -1
         EXIT FOREACH
      ELSE
         LET l_min_tot = l_min
      END IF
   END FOREACH

   RETURN l_min_tot
END FUNCTION
#No:DEV-CB0002--add--end
#DEV-D30025--add

