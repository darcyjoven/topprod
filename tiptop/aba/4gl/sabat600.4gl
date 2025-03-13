# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: sabat600
# DESCRIPTIONS...: 配货单查询
# DATE & AUTHOR..: No:DEV-CA0017 2012/11/06 By TSD.JIE
# Modify.........: No:DEV-CB0008 12/11/12 By TSD.JIE 修改參數檔
# Modify.........: No:DEV-CC0002 12/12/06 By Nina 修正畫面右上角"X"無法關閉表單的問題
# Modify.........: No:DEV-CC0001 12/12/12 By Mandy abat610/abat324 出貨通知單號(box01)開窗報錯
# Modify.........: No:DEV-CC0007 12/12/24 By Mandy (1)abat610 1:訂單包裝時 右下的條碼資料無顯示
#                                                  (2)abat610 1:訂單包裝時 齊套數無顯示
#                                                  (3)abat610 右下批號欄位(imgb04)隱藏
#                                                  (4)批號欄位(imgb04)隱藏
#                                                  (5)齊套數(sets)/工單齊套數(b_sets)隱藏
#                                                  (6)訂單包裝類,重新產生配貨單時,boxb_file無法刪除
# Modify.........: No.DEV-D30025 13/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"

DEFINE

    tm   RECORD    #程式變數(Program Variables)
         box01     LIKE box_file.box01,
         boxuser   LIKE box_file.boxuser,
         boxgrup   LIKE box_file.boxgrup,
         boxoriu   LIKE box_file.boxoriu,
         boxorig   LIKE box_file.boxorig,
         boxmodu   LIKE box_file.boxmodu,
         boxdate   LIKE box_file.boxdate,
         boxacti   LIKE box_file.boxacti
         END  RECORD,
    g_box    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         chk       LIKE type_file.chr1,   #勾选
         box11     LIKE box_file.box11,   #配货类型
         box12     LIKE box_file.box12,   #系列
         box02     LIKE box_file.box02,   #出货通知单项次
         box04     LIKE box_file.box04,   #料件
         ima02     LIKE ima_file.ima02,   #品名
         ima021    LIKE ima_file.ima021,  #规格
         box05     LIKE box_file.box05,   #出货数量
         box06     LIKE box_file.box06,   #预计出货数量
         sets      LIKE box_file.box05,   #齐套数量
         box13     LIKE box_file.box13    #月台
           END  RECORD,
    g_box_t    RECORD   #程式變數(Program Variables)
         chk       LIKE type_file.chr1,           #勾选
         box11     LIKE box_file.box11,   #配货类型
         box12     LIKE box_file.box12,   #系列
         box02     LIKE box_file.box02,   #出货通知单项次
         box04     LIKE box_file.box04,   #料件
         ima02     LIKE ima_file.ima02,   #品名
         ima021    LIKE ima_file.ima021,  #规格
         box05     LIKE box_file.box05,   #出货数量
         box06     LIKE box_file.box06,   #预计出货数量
         sets      LIKE box_file.box05,   #齐套数量
         box13     LIKE box_file.box13    #月台
           END  RECORD,
    g_box2       DYNAMIC ARRAY OF RECORD
         box09     LIKE box_file.box09,
         box07     LIKE box_file.box07,
         box10     LIKE box_file.box10,
         b_sets    LIKE box_file.box05
           END RECORD,
    g_imgb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        imgb01    LIKE imgb_file.imgb01,   #条码
       #iba12     LIKE iba_file.iba12,     #包号 #No:DEV-CA0017--mark
        ibb05     LIKE ibb_file.ibb05,     #包号 #No:DEV-CA0017--add
        imgb02    LIKE imgb_file.imgb02,   #仓库
        imgb03    LIKE imgb_file.imgb03,   #库位
        imgb04    LIKE imgb_file.imgb04,   #批号
        imgb05    LIKE imgb_file.imgb05    #数量
       #more      LIKE imgb_file.imgb05,   #多   #No:DEV-CA0017--mark
       #less      LIKE imgb_file.imgb05    #缺   #No:DEV-CA0017--mark
            END  RECORD,
    g_wc,g_wc2,g_wc3     STRING,
    g_sql                STRING,
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
    g_msg           STRING

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE i               LIKE type_file.num5     #count/index for any purpose
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_zz01          LIKE zz_file.zz01
DEFINE g_form          LIKE type_file.chr1
DEFINE l_table      STRING
DEFINE l_table1     STRING
DEFINE g_str        STRING
DEFINE g_argv1      LIKE type_file.chr10
DEFINE g_argv2      LIKE box_file.box01


FUNCTION  sabat600(p_argv1,p_argv2)
   DEFINE p_argv1  LIKE  type_file.chr10
   DEFINE p_argv2  LIKE  box_file.box01
   WHENEVER ERROR CALL cl_err_msg_log

  #SELECT * INTO g_sba.* FROM sba_file WHERE 1=1         #No:DEV-CB0008--mark
   SELECT * INTO g_ibd.* FROM ibd_file WHERE ibd01 = '0' #No:DEV-CB0008--add

   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2

   #DEV-CA0017--add--begin
   OPEN WINDOW t600_w AT 0,0 WITH FORM "aba/42f/abat610"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   #DEV-CA0017--add--end

   CALL sabat600_ui_init()
   IF NOT cl_null(g_argv1) THEN
      CALL sabat600_q()
   END IF
   CALL sabat600_menu()

   CLOSE WINDOW t600_w #DEV-CA0017--add
END FUNCTION

FUNCTION sabat600_ui_init()

  #No:DEV-CA0017--mark--begin
  #IF g_argv1 = '2' THEN
  #   CALL cl_set_comp_att_text("box01","调拨单号")
  #   CALL cl_set_comp_att_text("box02","调拨单项次")
  #   CALL cl_set_comp_att_text("box05","调拨数量")
  #   CALL cl_set_comp_att_text("box06","调拨备货调整量")
  #   CALL cl_set_comp_visible("box12,box13",FALSE)
  #END IF
  #IF g_argv1 = '3' THEN
  #   CALL cl_set_comp_att_text("box01","杂发单号")
  #   CALL cl_set_comp_att_text("box02","杂发单项次")
  #   CALL cl_set_comp_att_text("box05","杂发数量")
  #   CALL cl_set_comp_att_text("box06","杂发备货调整量")
  #   CALL cl_set_comp_visible("box12,box13",FALSE)
  #END IF
  #IF g_argv1 = '4' THEN
  #   CALL cl_set_comp_att_text("box01","跨厂调拨单号")
  #   CALL cl_set_comp_att_text("box02","跨厂调拨项次")
  #   CALL cl_set_comp_att_text("box05","调拨数量")
  #   CALL cl_set_comp_att_text("box06","调拨备货调整量")
  #   CALL cl_set_comp_visible("box12,box13",FALSE)
  #END IF
  #No:DEV-CA0017--mark--end

   CALL cl_set_comp_visible("sets,b_sets,imgb04",FALSE) #DEV-CC0007 add 齊套數(sets)/工單齊套數(b_sets)/批號(imgb04)欄位隱藏

  #No:DEV-CA0017--add--begin
   CASE
      WHEN g_argv1 = '1'  #abap610  出貨
         CALL cl_getmsg('aba-088',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box01",g_msg CLIPPED)
         CALL cl_getmsg('aba-089',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box02",g_msg CLIPPED)
         CALL cl_getmsg('aba-090',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box05",g_msg CLIPPED)
         CALL cl_getmsg('aba-091',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box06",g_msg CLIPPED)
         CALL cl_set_comp_visible("box12,box13",TRUE)
      WHEN g_argv1 = '2'  #abap324  雜發 
         CALL cl_getmsg('aba-080',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box01",g_msg CLIPPED)
         CALL cl_getmsg('aba-081',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box02",g_msg CLIPPED)
         CALL cl_getmsg('aba-082',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box05",g_msg CLIPPED)
         CALL cl_getmsg('aba-083',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box06",g_msg CLIPPED)
         CALL cl_set_comp_visible("box12,box13",FALSE)
      WHEN g_argv1 = '3'  #abap301  調撥
         CALL cl_getmsg('aba-084',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box01",g_msg CLIPPED)
         CALL cl_getmsg('aba-085',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box02",g_msg CLIPPED)
         CALL cl_getmsg('aba-086',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box05",g_msg CLIPPED)
         CALL cl_getmsg('aba-087',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("box06",g_msg CLIPPED)
         CALL cl_set_comp_visible("box12,box13",FALSE)
   END CASE
  #No:DEV-CA0017--add--end

END FUNCTION


FUNCTION sabat600_menu()
   WHILE TRUE
      CALL sabat600_bp("G")
      CASE g_action_choice
         #add by zhangym 120110 begin-----
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL sabat600_out()
            END IF
         #add by zhangym 120110 end-----
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL sabat600_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL sabat600_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL sabat600_b()
            END IF
         WHEN "regen_box"
            IF cl_chk_act_auth() THEN
               CALL sabat600_regen_box()
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

FUNCTION sabat600_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
   CALL cl_set_head_visible("","YES")
   INITIALIZE tm.* TO NULL
   CALL g_box.CLEAR()
   CALL g_box2.CLEAR()
   CALL g_imgb.CLEAR()

   IF NOT cl_null(g_argv2) THEN
      CASE g_argv1
         WHEN '1'
            LET g_wc = " box01 = '",g_argv2,"' AND box14 = 'axmt610' "
         WHEN '2'
            LET g_wc = " box01 = '",g_argv2,"' AND box14 = 'aimt324' "
         WHEN '3'
            LET g_wc = " box01 = '",g_argv2,"' AND box14 = 'aimt301' "
        #No:DEV-CA0017--mark--begin
        #WHEN '4'
        #   LET g_wc = " box01 = '",g_argv2,"' AND box14 = 'cimt327' "
        #No:DEV-CA0017--mark--end
      END CASE
      LET g_wc2 = " 1=1"
      LET g_wc3 = " 1=1"
     #RETURN #No:DEV-CA0017--mark
  #END IF #No:DEV-CA0017--mark
   ELSE   #No:DEV-CA0017--add

      DIALOG ATTRIBUTES(UNBUFFERED)
   
         CONSTRUCT BY NAME g_wc ON box01,
                   boxuser,boxgrup,boxoriu,boxorig,
                   boxmodu,boxdate,boxacti
   
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
                    #LET g_qryparam.form ="cq_box1" #No:DEV-CA0017--mark
                    #LET g_qryparam.form ="q_box01" #No:DEV-CA0017--add #No:DEV-CB0002--mark
                     #No:DEV-CB0002--add--begin
                     CASE
                        WHEN g_argv1 = '3'
                           LET g_qryparam.form ="q_box05"
                           LET g_qryparam.arg1 ="1"
                        WHEN g_argv1 = '2' #abat324        #DEV-CC0001 add
                           LET g_qryparam.form ="q_box06"  #DEV-CC0001 add
                       #OTHERWISE EXIT CASE                #DEV-CC0001 mark
                        OTHERWISE          #abat610        #DEV-CC0001 add
                           LET g_qryparam.form ="q_box01"
                     END CASE
                     #No:DEV-CB0002--add--end
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO box01
                     NEXT FIELD box01
                  WHEN INFIELD(box04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                    #LET g_qryparam.form ="cq_box4" #No:DEV-CA0017--mark
                     LET g_qryparam.form ="q_box03" #No:DEV-CA0017--add
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO box04
                     NEXT FIELD box04
                  OTHERWISE EXIT CASE
               END CASE
         END CONSTRUCT
   
   
         CONSTRUCT g_wc2 ON box02,box04,box05,box06,box13
                 FROM s_box[1].box02,s_box[1].box04,
                      s_box[1].box05,s_box[1].box06,
                      s_box[1].box13
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
   
            ON ACTION qbe_save
               CALL cl_qbe_save()
   
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
                  WHEN INFIELD(box09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                    #LET g_qryparam.form ="cq_box2" #No:DEV-CA0017--mark
                     LET g_qryparam.form ="q_box02" #No:DEV-CA0017--add
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO box09
                     NEXT FIELD box09
                  OTHERWISE EXIT CASE
               END CASE
         END CONSTRUCT
   
         CONSTRUCT g_wc3 ON box09,box07,box10
                 FROM s_box2[1].box09,s_box2[1].box07,
                      s_box2[1].box10
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
   
            ON ACTION qbe_save
               CALL cl_qbe_save()
   
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
                  WHEN INFIELD(box09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_ima18"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO box09
                     NEXT FIELD box09
                  OTHERWISE EXIT CASE
               END CASE
         END CONSTRUCT
   
      END DIALOG

   END IF    #No:DEV-CA0017--add

   IF INT_FLAG THEN
      #LET INT_FLAG = FALSE #No:DEV-CA0017--mark
      RETURN
   END IF
   CASE g_argv1
      WHEN '1'
         LET g_wc = g_wc CLIPPED," AND box14 = 'axmt610' "
      WHEN '2'
         LET g_wc = g_wc CLIPPED," AND box14 = 'aimt324' "
      WHEN '3'
         LET g_wc = g_wc CLIPPED," AND box14 = 'aimt301' "
     #No:DEV-CA0017--mark--begin
     #WHEN '4'
     #   LET g_wc = g_wc CLIPPED," AND box14 = 'cimt327' "
     #No:DEV-CA0017--mark--end
   END CASE
   IF cl_null(g_wc) THEN LET g_wc = " 1=1 " END IF
   IF cL_null(g_wc2) THEN LET g_wc2 = " 1=1 " END IF
   IF cl_null(g_wc3) THEN LET g_wc3 = " 1=1 " END IF

   #No:DEV-CA0017--add--begin
   LET g_sql = "SELECT DISTINCT box01 FROM box_file ",
               " WHERE ",g_wc,
               "   AND ",g_wc2,
               "   AND ",g_wc3,
               " ORDER BY box01 "
   PREPARE sabat600_prep FROM g_sql
   DECLARE sabat600_cs SCROLL CURSOR WITH HOLD FOR sabat600_prep

   LET g_sql = "SELECT COUNT(DISTINCT box01) FROM box_file ",
               " WHERE ",g_wc,
               "   AND ",g_wc2,
               "   AND ",g_wc3,
               " ORDER BY box01 "
   PREPARE sabat600_prepcount FROM g_sql
   DECLARE sabat600_count CURSOR FOR sabat600_prepcount
   #No:DEV-CA0017--add--end
END FUNCTION


FUNCTION sabat600_q()

   #No:DEV-CA0017--add--begin
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)

   CALL cl_opmsg('q')
   CLEAR FORM
   INITIALIZE tm.* TO NULL
   CALL g_box.CLEAR()
   CALL g_box2.CLEAR()
   CALL g_imgb.CLEAR()
   DISPLAY '   ' TO FORMONLY.cnt
   #No:DEV-CA0017--add--end

   MESSAGE ""
   CALL sabat600_cs()
   #No:DEV-CA0017--add--begin
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      RETURN
   END IF
   #No:DEV-CA0017--add--end

  #No:DEV-CA0017--mark--begin #搬到sabat600_cs()
  #LET g_sql = "SELECT DISTINCT box01 FROM box_file ",
  #            " WHERE ",g_wc,
  #            "   AND ",g_wc2,
  #            "   AND ",g_wc3,
  #            " ORDER BY box01 "
  #PREPARE sabat600_prep FROM g_sql
  #DECLARE sabat600_cs SCROLL CURSOR WITH HOLD FOR sabat600_prep

  #LET g_sql = "SELECT COUNT(DISTINCT box01) FROM box_file ",
  #            " WHERE ",g_wc,
  #            "   AND ",g_wc2,
  #            "   AND ",g_wc3,
  #            " ORDER BY box01 "
  #PREPARE sabat600_prepcount FROM g_sql
  #DECLARE sabat600_count CURSOR FOR sabat600_prepcount
  #No:DEV-CA0017--mark--end

   OPEN sabat600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE tm.* TO NULL
   ELSE
      OPEN sabat600_count
      FETCH sabat600_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL sabat600_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF

END FUNCTION



FUNCTION sabat600_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680137 VARCHAR(1)
DEFINE l_slip          LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(10)  #No.FUN-640013

   CASE p_flag
       WHEN 'N' FETCH NEXT     sabat600_cs INTO tm.box01
       WHEN 'P' FETCH PREVIOUS sabat600_cs INTO tm.box01
       WHEN 'F' FETCH FIRST    sabat600_cs INTO tm.box01
       WHEN 'L' FETCH LAST     sabat600_cs INTO tm.box01
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
           FETCH ABSOLUTE g_jump sabat600_cs INTO tm.box01
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

   SELECT DISTINCT box01,
          boxuser,boxgrup,boxoriu,boxorig,boxmodu,
          boxdate,boxacti
          INTO tm.* FROM box_file WHERE box01 = tm.box01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","box_file",tm.box01,"",SQLCA.sqlcode,"","",1)  #No.FUN-650108
      INITIALIZE tm.* TO NULL
      RETURN
   END IF
   CALL sabat600_show()
END FUNCTION


FUNCTION sabat600_show()
   DEFINE  l_ima02   LIKE ima_file.ima02
   DEFINE  l_ima021  LIKE ima_file.ima021   #FUN-AA0086

   DISPLAY BY NAME tm.box01,
             tm.boxuser,tm.boxgrup,tm.boxoriu,
             tm.boxorig,tm.boxmodu,tm.boxdate,
             tm.boxacti

   CALL sabat600_b_fill(tm.box01)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION sabat600_b_fill(p_box01)
   DEFINE l_oga16 LIKE oga_file.oga16 #DEV-CC0007 add
   DEFINE p_wc2   STRING
   DEFINE p_box01 LIKE box_file.box01
   #add by zhangym 120516 begin-----
  #DEFINE l_iba00 LIKE iba_file.iba00 #No:DEV-CA0017--mark
   DEFINE l_iba01 LIKE iba_file.iba01
   DEFINE l_box09 LIKE box_file.box09
   #add by zhangym 120516 end-----

   LET g_sql = "SELECT DISTINCT 'N',box11,box12,box02,box04,ima02,ima021,box05,box06,'',box13 ",
               "  FROM box_file,ima_file ",
               " WHERE box04 = ima01 ",
               "   AND box01 = '",p_box01,"' ",
               "   AND ",g_wc,
               "   AND ",g_wc2,
               "   AND ",g_wc3,
               " ORDER BY box11,box12,box02 "

   PREPARE sabat600_pb FROM g_sql
   DECLARE box_cs CURSOR FOR sabat600_pb

   CALL g_box.clear()
   LET g_cnt = 1

   FOREACH box_cs INTO g_box[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #No:DEV-CA0017--mark--begin
      ##add by zhangym 120515 begin----
      #IF g_box[g_cnt].box11 = '10' THEN
      #   SELECT iba00,iba01 INTO l_iba00,l_iba01 FROM iba_file
      #    WHERE iba04 = g_box[g_cnt].box11
      #      AND iba01 = g_box[g_cnt].box04
      #   SELECT SUM(imgb05) INTO g_box[g_cnt].sets FROM imgb_file
      #    WHERE imgb00 = l_iba00
      #      AND imgb01 = l_iba01
      #END IF
      #IF g_box[g_cnt].box11 = '50' THEN
      #   SELECT box09 INTO l_box09 FROM box_file
      #    WHERE box01 = p_box01
      #      AND box02 = g_box[g_cnt].box02
      #   SELECT MIN(SUM(imgb05)) INTO g_box[g_cnt].sets FROM imgb_file,iba_file
      #    WHERE imgb00 = iba00
      #      AND imgb01 = iba01
      #      AND iba04 = g_box[g_cnt].box11
      #      AND iba05 = l_box09
      #    GROUP BY imgb01,iba12
      #END IF
      #IF g_box[g_cnt].box11 = '52' THEN
      #   SELECT box09 INTO l_box09 FROM box_file
      #    WHERE box01 = p_box01
      #      AND box02 = g_box[g_cnt].box02
      #   SELECT iba00,iba01 INTO l_iba00,l_iba01 FROM iba_file
      #    WHERE iba04 = g_box[g_cnt].box11
      #      AND iba05 = l_box09
      #      AND iba06 = g_box[g_cnt].box12
      #   SELECT MIN(imgb05) INTO g_box[g_cnt].sets FROM imgb_file
      #    WHERE imgb00 = l_iba00
      #      AND imgb01 = l_iba01
      #   IF g_box[g_cnt].sets > 0 THEN
      #      LET g_box[g_cnt].sets = g_box[g_cnt].box05
      #   END IF
      #END IF
      #IF cl_null(g_box[g_cnt].sets) THEN
      #   LET g_box[g_cnt].sets = 0
      #END IF
      ##add by zhangym 120516 end----
      #No:DEV-CA0017--mark--end

      #No:DEV-CA0017--add--begin
       CASE
          WHEN g_box[g_cnt].box11 = '3'
             SELECT SUM(imgb05) INTO g_box[g_cnt].sets
               FROM imgb_file,ibb_file
              WHERE imgb01 = ibb01
                AND imgb01 = g_box[g_cnt].box04
                AND ibb02 IN ('F','G')      #條碼產生時機點'F':採購單 'G':G:委外採購單
              GROUP BY imgb01,ibb05

          WHEN g_box[g_cnt].box11 = '2'
             LET l_box09 = ''
             SELECT box09 INTO l_box09
               FROM box_file
              WHERE box01 = p_box01
                AND box02 = g_box[g_cnt].box02
             SELECT MIN(SUM(imgb05)) INTO g_box[g_cnt].sets
               FROM imgb_file,ibb_file
              WHERE imgb01 = ibb01
                AND ibb03 = l_box09
              GROUP BY imgb01,ibb05

          WHEN g_box[g_cnt].box11 = '1'
            #DEV-CC0007--mark---str---
            #LET l_box09 = ''
            #SELECT box09 INTO l_box09 FROM box_file
            # WHERE box01 = p_box01
            #   AND box02 = g_box[g_cnt].box02
            #DEV-CC0007--mark---end---
            #DEV-CC0007--add----str---
             LET l_oga16 = NULL
             SELECT oga16 INTO l_oga16
               FROM oga_file
              WHERE oga01 = tm.box01
                AND oga09 IN ('1','5') #1.出貨通知單 5.三角貿易出貨通知單 
            #DEV-CC0007--add----end---
             SELECT MIN(SUM(imgb05)) INTO g_box[g_cnt].sets
               FROM imgb_file,ibb_file
              WHERE imgb01 = ibb01
                AND ibb02 = 'H'           #條碼產生時機點:H:訂單包裝單(abai140)
                AND ibb09 = g_box[g_cnt].box12
               #AND ibb03 = l_box09 #DEV-CC0007 mark
                AND ibb03 = l_oga16 #DEV-CC0007 add
              GROUP BY imgb01,ibb05
             IF g_box[g_cnt].sets > 0 THEN
                LET g_box[g_cnt].sets = g_box[g_cnt].box05
             END IF
       END CASE
       IF cl_null(g_box[g_cnt].sets) THEN LET g_box[g_cnt].sets = 0 END IF
      #No:DEV-CA0017--add--end

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

END FUNCTION

#FUNCTION sabat600_box_fill(p_box01,p_box02)         #DEV-CC0007 mark
FUNCTION sabat600_box_fill(p_box01,p_box02,p_box11)  #DEV-CC0007 add
   DEFINE p_box01  LIKE box_file.box01
   DEFINE p_box02  LIKE box_file.box02
   DEFINE p_wc2   STRING
   DEFINE l_oga16  LIKE oga_file.oga16 #DEV-CC0007 add
   DEFINE p_box11  LIKE box_file.box11 #DEV-CC0007 add

   LET g_sql = "SELECT box09,box07,box10,'' ",
               "  FROM box_file ",
               " WHERE box01 = '",p_box01,"' ",
               "   AND box02 = ",p_box02,
               "   AND ",g_wc,
               "   AND ",g_wc2,
               "   AND ",g_wc3,
               " ORDER BY box10 "

   PREPARE sabat600_pb2 FROM g_sql
   DECLARE box2_cs CURSOR FOR sabat600_pb2

   CALL g_box2.clear()
   LET g_cnt = 1

   FOREACH box2_cs INTO g_box2[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#       LET g_sql = "SELECT MIN(sets) FROM ( ",
#                   " SELECT imgb01,iba12,nvl(imgb05,0) AS sets ",
#                   "   FROM iba_file,imgb_file ",
#                   "  WHERE iba14 = '",g_box2[g_cnt].box09,"' ",
#                   "    AND imgb01(+) = iba01 ",
#                   "    AND imgb00(+) = iba00 ",
#                   " ) "
      #No:DEV-CA0017--mark--begin
      #LET g_sql = "SELECT MIN(SUM(imgb05)) ",
      #            "   FROM iba_file,imgb_file ",
      #            "  WHERE iba14 = '",g_box2[g_cnt].box09,"' ",
      #            "    AND imgb01(+) = iba01 ",
      #            "    AND imgb00(+) = iba00 ",
      #            "  GROUP BY imgb01,iba12 "
      #No:DEV-CA0017--mark--end
      #DEV-CC0007---add---str---
      IF p_box11 = '1' THEN #1:訂單包裝類
           LET l_oga16 = NULL
           SELECT oga16 INTO l_oga16
             FROM oga_file
            WHERE oga01 = tm.box01
              AND oga09 IN ('1','5') #1.出貨通知單 5.三角貿易出貨通知單 
           LET g_sql = "SELECT MIN(SUM(imgb05)) ",
                       "   FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01",
                       "  WHERE ibb03 = '",l_oga16,"' ", #來源單號
                       "  GROUP BY imgb01,ibb05 "
      ELSE
      #DEV-CC0007---add---end---
          #No:DEV-CA0017--add--begin
          LET g_sql = "SELECT MIN(SUM(imgb05)) ",
                      "   FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01",
                      "  WHERE ibb03 = '",g_box2[g_cnt].box09,"' ",
                      "  GROUP BY imgb01,ibb05 "
          #No:DEV-CA0017--add--end
      END IF #DEV-CC0007 add if
      PREPARE get_sets FROM g_sql
      EXECUTE get_sets INTO g_box2[g_cnt].b_sets
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_box2.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO idx3
   LET g_cnt = 0

END FUNCTION

#FUNCTION sabat600_d_fill(p_box10)
#FUNCTION sabat600_d_fill(p_box09,p_box12,p_box02)   #add by zhangym 120515 #No:DEV-CA0017--mark
FUNCTION sabat600_d_fill(p_box09,p_box12,p_box02,p_box11,p_box04)           #No:DEV-CA0017--add
   DEFINE p_box09  LIKE  box_file.box09
   DEFINE p_box12  LIKE  box_file.box12   #add by zhangym 120515
   DEFINE p_box02  LIKE  box_file.box02
   DEFINE p_box11  LIKE  box_file.box11 #No:DEV-CA0017--add
   DEFINE p_box04  LIKE  box_file.box04 #No:DEV-CA0017--add
   DEFINE l_ogb31      LIKE  ogb_file.ogb31
   DEFINE l_m          LIKE  type_file.num5
   DEFINE l_inb05      LIKE  inb_file.inb05
   DEFINE l_inb06      LIKE  inb_file.inb06 #DEV-CC0007 add

  #No:DEV-CA0017--mark--begin
  #IF cl_null(p_box12) THEN
  #   CASE g_argv1
  #      WHEN '1'
  #        LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                    "  FROM iba_file,imgb_file ",
  #                    " WHERE iba01 = imgb01(+) ",
  #                    "   AND iba00 = imgb00(+) ",
  #                    "   AND imgb02 != '",g_sba.sba31,"' ",
  #                    "   AND imgb03 != '",g_sba.sba32,"' ",
  #                    "   AND iba05 = '",p_box09,"' ",
  #                    " ORDER BY iba01 "
  #      WHEN '2'
  #        LET l_m = 0
  #        SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_box09
  #        IF l_m > 0 THEN
  #           LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                       "  FROM iba_file,imgb_file ",
  #                       " WHERE iba01 = imgb01(+) ",
  #                       "   AND iba00 = imgb00(+) ",
  #                       "   AND imgb02 != '",g_sba.sba31,"' ",
  #                       "   AND imgb03 != '",g_sba.sba32,"' ",
  #                       "   AND iba14 = '",p_box09,"' ",
  #                       " ORDER BY iba01 "
  #        ELSE
  #           LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                       "  FROM iba_file,imgb_file ",
  #                       " WHERE iba01 = imgb01(+) ",
  #                       "   AND iba00 = imgb00(+) ",
  #                       "   AND imgb02 != '",g_sba.sba31,"' ",
  #                       "   AND imgb03 != '",g_sba.sba32,"' ",
  #                       "   AND iba14 = '",p_box09,"' ",
  #                       "   AND iba15 = '",p_box02,"' ",
  #                       " ORDER BY iba01 "
  #        END IF
  #      WHEN '3'
  #        SELECT inb05 INTO l_inb05 FROM inb_file
  #         WHERE inb01 = tm.box01 AND inb03 = p_box02
  #        LET l_m = 0
  #        SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_box09
  #        IF l_m > 0 THEN
  #           LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                       "  FROM iba_file,imgb_file ",
  #                       " WHERE iba01 = imgb01(+) ",
  #                       "   AND iba00 = imgb00(+) ",
  #                       "   AND imgb02 != '",g_sba.sba31,"' ",
  #                       "   AND imgb02 = '",l_inb05,"' ",
  #                       "   AND imgb03 != '",g_sba.sba32,"' ",
  #                       "   AND iba14 = '",p_box09,"' ",
  #                       " ORDER BY iba01 "
  #        ELSE
  #           LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                       "  FROM iba_file,imgb_file ",
  #                       " WHERE iba01 = imgb01(+) ",
  #                       "   AND iba00 = imgb00(+) ",
  #                       "   AND imgb02 != '",g_sba.sba31,"' ",
  #                       "   AND imgb02 = '",l_inb05,"' ",
  #                       "   AND imgb03 != '",g_sba.sba32,"' ",
  #                       "   AND iba14 = '",p_box09,"' ",
  #                       "   AND iba15 = '",p_box02,"' ",
  #                       " ORDER BY iba01 "
  #        END IF
  #      WHEN '4'
  #        LET l_m = 0
  #        SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_box09
  #        IF l_m > 0 THEN
  #           LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                       "  FROM iba_file,imgb_file ",
  #                       " WHERE iba01 = imgb01(+) ",
  #                       "   AND iba00 = imgb00(+) ",
  #                       "   AND imgb02 != '",g_sba.sba31,"' ",
  #                       "   AND imgb03 != '",g_sba.sba32,"' ",
  #                       "   AND iba14 = '",p_box09,"' ",
  #                       " ORDER BY iba01 "
  #        ELSE
  #           LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                       "  FROM iba_file,imgb_file ",
  #                       " WHERE iba01 = imgb01(+) ",
  #                       "   AND iba00 = imgb00(+) ",
  #                       "   AND imgb02 != '",g_sba.sba31,"' ",
  #                       "   AND imgb03 != '",g_sba.sba32,"' ",
  #                       "   AND iba14 = '",p_box09,"' ",
  #                       "   AND iba15 = '",p_box02,"' ",
  #                       " ORDER BY iba01 "
  #        END IF
  #   END CASE
  #ELSE
  #   LET l_ogb31 = ''
  #   SELECT ogb31 INTO l_ogb31 FROM ogb_file
  #    WHERE ogb01 = tm.box01 AND ogb03 = p_box02
  #   LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #               "  FROM iba_file,imgb_file ",
  #               " WHERE iba01 = imgb01(+) ",
  #               "   AND iba00 = imgb00(+) ",
  #               "   AND imgb02 != '",g_sba.sba31,"' ",
  #               "   AND imgb03 != '",g_sba.sba32,"' ",
  #               #"   AND iba14 = '",p_box09,"' ",
  #               "   AND iba14 = '",l_ogb31,"' ",
  #               "   AND iba11 = '",p_box12,"' ",
  #               " ORDER BY iba01 "
  #END IF
  #No:DEV-CA0017--mark--end

  #No:DEV-CA0017--add--begin
   CASE
      WHEN p_box11 = '3' #外購
         LET g_sql = "SELECT UNIQUE ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                     "  FROM ibb_file,imgb_file ",
                     " WHERE ibb01 = imgb01 ",
                    #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                    #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                     "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                     "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                     "   AND ibb02 IN ('F','G') ",   #條碼產生時機點'F':採購單 'G':G:委外採購單
                     "   AND ibb06 = '",p_box04,"' ",
                     " ORDER BY ibb01 "

       WHEN p_box11 = '1' OR p_box11 = '2'
          IF NOT cl_null(p_box12) THEN
             LET l_ogb31 = ''
             SELECT ogb31 INTO l_ogb31 FROM ogb_file
              WHERE ogb01 = tm.box01 AND ogb03 = p_box02
             LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                         "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                         " WHERE ibb03 = '",l_ogb31,"' ",
                        #"   AND ibb04 = '",p_box12,"' ", #DEV-CC0007 mark
                         "   AND ibb09 = '",p_box12,"' ", #DEV-CC0007 add
                        #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                        #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                         "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                         "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                         " ORDER BY ibb01 "
          ELSE
             CASE g_argv1
                WHEN '1'
                  LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                              "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                              " WHERE ibb03 = '",p_box09,"' ",
                             #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                             #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                              "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                              "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                              " ORDER BY ibb01 "
          
                WHEN '2'
                  LET l_m = 0
                  SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_box09
                  IF l_m > 0 THEN
                     LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                                 "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                                 " WHERE ibb03 = '",p_box09,"' ",
                                #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                                #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                                 "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                                 "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                                 " ORDER BY ibb01 "
                  ELSE
                     LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                                 "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                                 " WHERE ibb03 = '",p_box09,"' ",
                                #"   AND ibb04 = '",p_box02,"' ", #No:DEV-CB0002--mark
                                #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                                #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                                 "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                                 "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                                 " ORDER BY ibb01 "
                  END IF
          
                WHEN '3'
                 #SELECT inb05 INTO l_inb05 FROM inb_file                #DEV-CC0007 add
                  SELECT inb05,inb06 INTO l_inb05,l_inb06 FROM inb_file  #DEV-CC0007 add
                   WHERE inb01 = tm.box01 AND inb03 = p_box02
                  LET l_m = 0
                  SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_box09
                  IF l_m > 0 THEN
                     LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                                 "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                                 " WHERE imgb02 = '",l_inb05,"' ",
                                 "   AND imgb03 = '",l_inb06,"' ",      #No:DEV-CC0007 add 
                                #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                                #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                                 "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                                 "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                                 "   AND ibb03 = '",p_box09,"' ",
                                 " ORDER BY ibb01 "
                  ELSE
                     LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                                 "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                                 " WHERE imgb02 = '",l_inb05,"' ",
                                #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                                #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                                 "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                                 "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                                 "   AND ibb03 = '",p_box09,"' ",
                                #"   AND ibb04 = '",p_box02,"' ", #No:DEV-CB0002--mark
                                 " ORDER BY ibb01 "
                  END IF
             END CASE
          END IF
   END CASE
  #No:DEV-CA0017--add--end

   PREPARE sabat600_pb_d FROM g_sql
   DECLARE imgb_cs CURSOR FOR sabat600_pb_d

   CALL g_imgb.clear()
   LET g_cnt = 1

   FOREACH imgb_cs INTO g_imgb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #No:DEV-CA0017--mark--begin
      #IF g_imgb[g_cnt].imgb05 - g_box2[l_ac2].b_sets > 0 THEN   #多
      #   LET g_imgb[g_cnt].more = g_imgb[g_cnt].imgb05 - g_box2[l_ac2].b_sets
      #ELSE IF g_imgb[g_cnt].imgb05 - g_box2[l_ac2].b_sets < 0 THEN   #少
      #        LET g_imgb[g_cnt].less = g_box2[l_ac2].b_sets - g_imgb[g_cnt].imgb05
      #     END IF
      #END IF
      #No:DEV-CA0017--mark--end
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_imgb.deleteElement(g_cnt)
   LET g_rec_b3=g_cnt-1
   DISPLAY g_rec_b3 TO idx4
   LET g_cnt = 0

END FUNCTION

#No:DEV-CA0017--mark--begin MOVE TO sabat600_d_fill()
##add by zhangym 120515 begin------
#FUNCTION sabat600_d_fill_1(p_box11,p_box04)
#   DEFINE p_box11  LIKE  box_file.box11
#   DEFINE p_box04  LIKE  box_file.box04
#
#   LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
#               "  FROM iba_file,imgb_file ",
#               " WHERE iba01 = imgb01 ",
#               "   AND iba00 = imgb00 ",
#               "   AND imgb02 != '",g_sba.sba31,"' ",
#               "   AND imgb03 != '",g_sba.sba32,"' ",
#               #"   AND iba04 = '",p_box11,"' ",
#               "   AND iba09 = '",p_box04,"' ",
#               " ORDER BY iba01 "
#
#   PREPARE sabat600_pb_d1 FROM g_sql
#   DECLARE imgb_cs1 CURSOR FOR sabat600_pb_d1
#
#   CALL g_imgb.clear()
#   LET g_cnt = 1
#
#   FOREACH imgb_cs1 INTO g_imgb[g_cnt].*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#  #     IF g_imgb[g_cnt].imgb05 - g_box2[l_ac2].b_sets > 0 THEN   #多
#  #        LET g_imgb[g_cnt].more = g_imgb[g_cnt].imgb05 - g_box2[l_ac2].b_sets
#  #     ELSE IF g_imgb[g_cnt].imgb05 - g_box2[l_ac2].b_sets < 0 THEN   #少
#  #             LET g_imgb[g_cnt].less = g_box2[l_ac2].b_sets - g_imgb[g_cnt].imgb05
#  #          END IF
#  #     END IF
#       LET g_cnt = g_cnt + 1
#       IF g_cnt > g_max_rec THEN
#          CALL cl_err( '', 9035, 0 )
#          EXIT FOREACH
#       END IF
#   END FOREACH
#   CALL g_imgb.deleteElement(g_cnt)
#   LET g_rec_b3=g_cnt-1
#   DISPLAY g_rec_b3 TO idx4
#   LET g_cnt = 0
#
#END FUNCTION
##add by zhangym 120515 end------
#No:DEV-CA0017--mark--end

FUNCTION sabat600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_sql  STRING

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
  #CALL cl_set_act_visible("accept,cancel,close", FALSE)        #DEV-CC0002 mark
   CALL cl_set_act_visible("accept,cancel", FALSE)              #DEV-CC0002 add
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_box TO s_box.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

          BEFORE ROW
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
               #CALL sabat600_box_fill(tm.box01,g_box[l_ac].box02)                     #DEV-CC0007 mark
                CALL sabat600_box_fill(tm.box01,g_box[l_ac].box02,g_box[l_ac].box11)   #DEV-CC0007 add
               #No:DEV-CA0017--mark--begin
               ##add by zhangym 120515 begin-----
               #IF g_box[l_ac].box11 = '10' THEN
               #   CALL sabat600_d_fill_1(g_box[l_ac].box11,g_box[l_ac].box04)
               #END IF
               #IF g_box[l_ac].box11 = '50' THEN
               ##add by zhangym 120515 end-----
               #   IF g_rec_b2 > 0 THEN
               #      LET l_ac2 = 1
               #      CALL sabat600_d_fill(g_box2[l_ac2].box09,g_box[l_ac].box12,g_box[l_ac].box02)
               #   END IF
               ##add by zhangym 120515 begin-----
               #END IF
               #IF g_box[l_ac].box11 = '52' THEN
               #   IF g_rec_b2 > 0 THEN
               #      LET l_ac2 = 1
               #      CALL sabat600_d_fill(g_box2[l_ac2].box09,g_box[l_ac].box12,g_box[l_ac].box02)
               #   END IF
               #END IF
               ##add by zhangym 120515 end----
               #No:DEV-CA0017--mark--end
               #No:DEV-CA0017--add--begin
                IF g_rec_b2 > 0 THEN
                   LET l_ac2 = 1
                   CALL sabat600_d_fill(g_box2[l_ac2].box09,g_box[l_ac].box12,
                                        g_box[l_ac].box02,
                                        g_box[l_ac].box11,g_box[l_ac].box04)
                END IF
               #No:DEV-CA0017--add--end
             END IF
      END DISPLAY

      DISPLAY ARRAY g_box2 TO s_box2.* ATTRIBUTE(COUNT=g_rec_b2)
          BEFORE DISPLAY
            IF l_ac2 > 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF

          BEFORE ROW
             LET l_ac2  = ARR_CURR()
             IF l_ac2  > 0 THEN
               #CALL sabat600_d_fill(g_box2[l_ac2].box09,g_box[l_ac].box12,g_box[l_ac].box02) #No:DEV-CA0017--mark
                #No:DEV-CA0017--add--begin
                CALL sabat600_d_fill(g_box2[l_ac2].box09,g_box[l_ac].box12,
                                     g_box[l_ac].box02,
                                     g_box[l_ac].box11,g_box[l_ac].box04)
                #No:DEV-CA0017--add--end
             END IF
      END DISPLAY

      DISPLAY ARRAY g_imgb TO s_imgb.* ATTRIBUTE(COUNT=g_rec_b3)
          BEFORE DISPLAY
            IF l_ac3 > 0 THEN
               CALL fgl_set_arr_curr(l_ac3)
            END IF

          BEFORE ROW
             LET l_ac3  = ARR_CURR()
             IF l_ac3  > 0 THEN

             END IF
      END DISPLAY

      BEFORE DIALOG
         CALL cl_navigator_setting( g_curs_index, g_row_count )  #by zhangym 120606
         IF l_ac > 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

     #add by zhangym 120111 begin-----
     ON ACTION output
        LET g_action_choice="output"
        EXIT DIALOG
     #add by zhangym 120111 end-----

     ON ACTION query
        LET g_action_choice="query"
        EXIT DIALOG

      ON ACTION insert
        LET g_action_choice="insert"
        EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG

      ON ACTION regen_box
         LET g_action_choice="regen_box"
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

     #DEV-CC0002 add str---
      ON ACTION close
         LET INT_FLAG = FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
     #DEV-CC0002 add end---

      ON ACTION first
         CALL sabat600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG


      ON ACTION previous
         CALL sabat600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG


      ON ACTION jump
         CALL sabat600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG


      ON ACTION next
         CALL sabat600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG


      ON ACTION last
         CALL sabat600_fetch('L')
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

FUNCTION sabat600_b()
DEFINE
    p_style         LIKE type_file.chr1,                #由何种方式进入单身
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,
    l_sql           STRING,
    p_cmd           LIKE type_file.chr1,                #處理狀態
    l_box01      LIKE box_file.box01,
    l_box02      LIKE box_file.box02,
    l_t             LIKE type_file.num5   #add by zhangym 120516

    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF

    IF g_rec_b = 0 THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT box01,box02 ",
                       "  FROM box_file",
                       " WHERE box01 = ? AND box02=? ",
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE sabat600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_box WITHOUT DEFAULTS FROM s_box.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW =FALSE ,
              DELETE ROW=FALSE,APPEND ROW=FALSE)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

       #BEGIN WORK #No:DEV-CA0017--mark
       
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'            #DEFAULT
            LET g_success = 'Y'
            LET g_box_t.* = g_box[l_ac].*
            CALL sabat600_b_entry_b()
            CALL sabat600_b_no_entry_b()
           #No:DEV-CA0017--mark--begin  搬到sabat600_b_entry_b()
           ##add by zhangym 120516 begin----
           #IF g_box[l_ac].box11 = '52' THEN
           #   CALL cl_set_comp_entry('box06',FALSE)
           #ELSE
           #   CALL cl_set_comp_entry('box06',TRUE)
           #END IF
           #No:DEV-CA0017--mark--end
            #add by zhangym 120516 end-----
            #LET g_box[l_ac].sets = 0   #mark by zhangym 120516
            IF l_ac  > 0 THEN
               #CALL sabat600_box_fill(tm.box01,g_box[l_ac].box02)  #mark by zhangym 120516
               #CALL sabat600_refresh()
               #No:DEV-CA0017--mark--begin
               ##add by zhangym 120515 begin-----
               #IF g_box[l_ac].box11 = '10' THEN
               #   CALL sabat600_d_fill_1(g_box[l_ac].box11,g_box[l_ac].box04)
               #END IF
               #IF g_box[l_ac].box11 = '50' THEN
               ##add by zhangym 120515 end-----
               #   IF g_rec_b2 > 0 THEN
               #      LET l_ac2 = 1
               #      CALL sabat600_d_fill(g_box2[l_ac2].box09,g_box[l_ac].box12,g_box[l_ac].box02)
               #   END IF
               ##add by zhangym 120515 begin-----
               #END IF
               #IF g_box[l_ac].box11 = '52' THEN
               #   IF g_rec_b2 > 0 THEN
               #      LET l_ac2 = 1
               #      CALL sabat600_d_fill(g_box2[l_ac2].box09,g_box[l_ac].box12,g_box[l_ac].box02)
               #   END IF
               #END IF
               ##add by zhangym 120515 end-----
               #No:DEV-CA0017--mark--end
               #No:DEV-CA0017--add--begin
                IF g_rec_b2 > 0 THEN
                   LET l_ac2 = 1
                   CALL sabat600_d_fill(g_box2[l_ac2].box09,g_box[l_ac].box12,
                                        g_box[l_ac].box02,
                                        g_box[l_ac].box11,g_box[l_ac].box04)
                END IF
               #No:DEV-CA0017--add--end
            END IF
#mark by zhangym 120516 begin-----
#            FOR g_cnt = 1 TO g_rec_b2
#                IF cl_null(g_box2[g_cnt].b_sets) THEN LET g_box2[g_cnt].b_sets = 0 END IF
#                LET g_box[l_ac].sets = g_box[l_ac].sets + g_box2[g_cnt].b_sets
#            END FOR
#mark by zhangym 120516 end-----
            IF cl_null(g_box[l_ac].sets) THEN LET g_box[l_ac].sets = 0 END IF
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_box_t.* = g_box[l_ac].*  #BACKUP
               OPEN sabat600_bcl USING  tm.box01,g_box[l_ac].box02
               IF STATUS THEN
                  CALL cl_err("OPEN sabat600_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH sabat600_bcl INTO l_box01,l_box02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        BEFORE INSERT


        AFTER INSERT
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF g_box[l_ac].box02 IS NULL THEN
               CANCEL INSERT
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_box[l_ac].* = g_box_t.*
              CLOSE sabat600_bcl
              ROLLBACK WORK
              CONTINUE INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err('',-263,0)
              LET g_box[l_ac].* =g_box_t.*
           ELSE
              UPDATE box_file SET box05 = g_box[l_ac].box05,
                                  box06 = g_box[l_ac].box06,
                                  box13 = g_box[l_ac].box13
              WHERE box01 = tm.box01
                AND box03 = g_box[l_ac].box02
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_box[l_ac].* = g_box_t.*
              END IF
              CLOSE sabat600_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE sabat600_bcl            # 新增
           COMMIT WORK

        #add by zhangym 120516 begin-----
        ON CHANGE chk
            IF NOT cl_null(g_box[l_ac].box12) THEN
              #IF g_box[l_ac].box11 = '52' THEN #No:DEV-CA0017--mark
               IF g_box[l_ac].box11 = '1'  THEN #No:DEV-CA0017--add
                  FOR l_t = 1 TO g_rec_b
                      IF g_box[l_t].box12 = g_box[l_ac].box12 THEN
                         LET g_box[l_t].chk = g_box[l_ac].chk
                      END IF
                  END FOR
               END IF
            END IF
        #add by zhangym 120516 end-----
        
        AFTER FIELD box06
            IF NOT cl_null(g_box[l_ac].box06) THEN
               IF g_box[l_ac].box06 <= 0 THEN
                  CALL cl_err('','aem-042',0)
                  NEXT FIELD box06
               END IF
               IF g_box[l_ac].box06 >g_box[l_ac].sets THEN
                  CALL cl_err('','aba-024',0)
                  NEXT FIELD box06
               END IF
            END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = FALSE
    END IF

END FUNCTION

FUNCTION sabat600_b_entry_b()

   CALL cl_set_comp_entry('chk,box06,box13',TRUE)

   CALL cl_set_comp_entry('box06',TRUE) #No:DEV-CA0017--add

END FUNCTION

FUNCTION sabat600_b_no_entry_b()

   CALL cl_set_comp_entry('box12,box11,box02,box04,box05,sets',FALSE)

   #No:DEV-CA0017--add--begin
   IF g_box[l_ac].box11 = '1' THEN
      CALL cl_set_comp_entry('box06',FALSE)
   END IF
   #No:DEV-CA0017--add--end
END FUNCTION

FUNCTION sabat600_regen_box()
   DEFINE  l_str  STRING
   DEFINE  l_str1  STRING
   DEFINE  l_cmd  STRING
   DEFINE  l_boxb04   LIKE boxb_file.boxb04
   DEFINE  l_boxb05   LIKE boxb_file.boxb05
   DEFINE  l_iba06    LIKE iba_file.iba06
   DEFINE  l_ibb09    LIKE ibb_file.ibb09 #No:DEV-CA0017--add

   LET l_str = ' '
   FOR g_cnt = 1 TO g_rec_b
      IF g_box[g_cnt].chk = 'Y' THEN
         DELETE FROM box_file WHERE box01 = tm.box01 AND box02 = g_box[g_cnt].box02
         IF SQLCA.sqlcode THEN
            CALL cl_err3("delete","box_file",tm.box01,g_box[g_cnt].box02,SQLCA.sqlcode,"","",1)
            EXIT FOR
         END IF
         IF NOT cl_null(g_box[g_cnt].box12) THEN
            LET g_sql = "SELECT DISTINCT boxb04,boxb05 FROM boxb_file ",
                        " WHERE boxb01 = '",tm.box01,"' "
            PREPARE t600_pb1 FROM g_sql
            DECLARE t600_cs1 CURSOR FOR t600_pb1
            FOREACH t600_cs1 INTO l_boxb04,l_boxb05
              #No:DEV-CA0017--mark--begin
              #SELECT iba06 INTO l_iba06 FROM iba_file
              # WHERE iba00 = l_boxb04
              #   AND iba01 = l_boxb05
              #IF g_box[g_cnt].box12 = l_iba06 THEN
              #   DELETE FROM boxb_file WHERE boxb01 = tm.box01
              #                           AND boxb04 = l_boxb04
              #                           AND boxb05 = l_boxb05
              #   IF SQLCA.sqlcode THEN
              #      CALL cl_err3("delete","boxb_file",tm.box01,"",SQLCA.sqlcode,"","",1)
              #      EXIT FOREACH
              #   END IF
              #END IF
              #No:DEV-CA0017--mark--end

              #No:DEV-CA0017--add--begin
               LET l_ibb09 = ''
               SELECT ibb09 INTO l_ibb09
                 FROM ibb_file
               #WHERE ibb01 = l_box05  #DEV-CC0007 mark
                WHERE ibb01 = l_boxb05 #DEV-CC0007 add
                  AND ibb02 = 'H' #條碼產生時機點:H:訂單包裝單(abai140)
               IF g_box[g_cnt].box12 = l_ibb09 THEN
                  DELETE FROM boxb_file WHERE boxb01 = tm.box01
                                          AND boxb05 = l_boxb05
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("delete","boxb_file",tm.box01,"",SQLCA.sqlcode,"","",1)
                     EXIT FOREACH
                  END IF
               END IF
              #No:DEV-CA0017--add--end
            END FOREACH
         ELSE
            DELETE FROM boxb_file WHERE boxb01 = tm.box01 
                                    AND boxb02 = g_box[g_cnt].box02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("delete","boxb_file",tm.box01,g_box[g_cnt].box02,SQLCA.sqlcode,"","",1)
               EXIT FOR
            END IF
         END IF
      END IF
   END FOR
#   IF cl_null(l_str) THEN
#      CALL cl_err('','aba-018',1)
#      RETURN
#   END IF
#   LET l_str = l_str.subString(1,l_str.getLength()-1)
#   LET l_str = "(",l_str,")"
   CASE g_argv1
      WHEN '1'
         LET l_cmd = "abap610 '",tm.box01,"' "
      WHEN '2'
         LET l_cmd = "abap324 '",tm.box01,"' "
      WHEN '3'
         LET l_cmd = "abap301 '",tm.box01,"' "
     #No:DEV-CA0017--mark--begin
     #WHEN '4'
     #   LET l_cmd = "abap327 '",tm.box01,"' "
     #No:DEV-CA0017--mark--end
   END CASE
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION


FUNCTION sabat600_a()
   DEFINE  l_str  STRING
   DEFINE  l_str1  STRING
   DEFINE  l_cmd  STRING

  #No:DEV-CA0017--mark--begin
  #LET l_cmd = "abap610 '",tm.box01,"' "
  #CALL cl_cmdrun_wait(l_cmd)
  #No:DEV-CA0017--mark--end

  #No:DEV-CA0017--add--begin
   CASE g_argv1
      WHEN '1'
         LET l_cmd = "abap610 '",tm.box01,"' "
      WHEN '2'
         LET l_cmd = "abap324 '",tm.box01,"' "
      WHEN '3'
         LET l_cmd = "abap301 '",tm.box01,"' "
   END CASE
   CALL cl_cmdrun_wait(l_cmd)
  #No:DEV-CA0017--add--end
END FUNCTION

FUNCTION sabat600_refresh()

   DISPLAY ARRAY g_box TO s_box.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
        EXIT DISPLAY
   END DISPLAY

   DISPLAY ARRAY g_box2 TO s_box2.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
        EXIT DISPLAY
   END DISPLAY

   DISPLAY ARRAY g_imgb TO s_imgb.* ATTRIBUTE(COUNT=g_rec_b3)
      BEFORE DISPLAY
        EXIT DISPLAY
   END DISPLAY

END FUNCTION

FUNCTION sabat600_out()
   DEFINE l_cmd  STRING
 
   IF cl_null(tm.box01) THEN RETURN END IF
 
  #No:DEV-CB0002--mark--begin
  #CASE g_argv1
  #   WHEN '1'
  #      LET l_cmd = "abar600 '",tm.box01,"' '1' "
  #      CALL cl_cmdrun(l_cmd)
  #   WHEN '2'
  #      LET l_cmd = "abar600 '",tm.box01,"' '3' "
  #      CALL cl_cmdrun(l_cmd)
  #   WHEN '3'
  #      LET l_cmd = "abar600 '",tm.box01,"' '2' "
  #      CALL cl_cmdrun(l_cmd)
  #  #No:DEV-CA0017--mark--begin
  #  #WHEN '4'
  #  #   LET l_cmd = "abar600 '",tm.box01,"' '4' "
  #  #   CALL cl_cmdrun(l_cmd)
  #  #No:DEV-CA0017--mark--end
  #END CASE
  #No:DEV-CB0002--mark--end

   #No:DEV-CB0002--add--begin
   CASE g_argv1
      WHEN '1'
         LET g_msg=' box01="',tm.box01 CLIPPED,'"'
         LET l_cmd = "abar600",
             " '",g_today CLIPPED,"' ''",
             " '",g_lang CLIPPED,"' 'Y' '' '1'",
             " '' '' '' '' ",
             " '",g_msg CLIPPED,"' ",
             " '1' "
         CALL cl_cmdrun_wait(l_cmd)

      WHEN '2'
         LET g_msg=' box01="',tm.box01 CLIPPED,'"'
         LET l_cmd = "abar600",
             " '",g_today CLIPPED,"' ''",
             " '",g_lang CLIPPED,"' 'Y' '' '1'",
             " '' '' '' '' ",
             " '",g_msg CLIPPED,"' ",
             " '3' "
         CALL cl_cmdrun_wait(l_cmd)

      WHEN '3'
         LET g_msg=' box01="',tm.box01 CLIPPED,'"'
         LET l_cmd = "abar600",
             " '",g_today CLIPPED,"' ''",
             " '",g_lang CLIPPED,"' 'Y' '' '1'",
             " '' '' '' '' ",
             " '",g_msg CLIPPED,"' ",
             " '2' "
         CALL cl_cmdrun_wait(l_cmd)
   END CASE
   #No:DEV-CB0002--add--end

END FUNCTION
#DEV-D30025--add


