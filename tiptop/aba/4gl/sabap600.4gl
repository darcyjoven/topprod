# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: sabap600
# DESCRIPTIONS...: 配貨單產生作業
# DATE & AUTHOR..: No:DEV-CB0001 2012/11/05 By TSD.JIE
# Modify.........: No:DEV-CB0008 12/11/12 By TSD.JIE 修改參數檔
# Modify.........: No:DEV-CB0018 12/11/19 By TSD.JIE 調整安庫box08欄位取值的方式
# Modify.........: No:DEV-CC0001 12/12/04 By Mandy 訂單包裝類抓取資料異常
# Modify.........: No:DEV-CC0007 12/12/24 By Mandy (1)abap610 右下畫面應有入庫條碼資料卻無顯示 ，導致無法配貨成功
#                                                  (2)abap610 右下畫面<批號>欄位請隱藏,<庫位>繁體中文名稱改為<儲位> 
#                                                  (3)訂單包裝類 產生配貨box09/box10 欄位值為空
#                                                  (4)工單成品類 因為單身右邊顯示的條碼資訊有關聯到倉庫/儲位,所以單頭增加顯示倉庫/儲位二欄位
#                                                  (5)<批號>欄位隱藏
#                                                  (6)訂單包裝類的,boxb02和boxb03 值為零==>不正確調整
# Modify.........: No.DEV-D30025 13/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No.130710     13/07/10 By zhangjiao 修正DIALOG写法错误。交互指令中写多个同样action 


DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"

DEFINE

    tm   RECORD
         ogb01   LIKE  ogb_file.ogb01,
         ogb03   STRING
         END  RECORD,
    g_a1 DYNAMIC ARRAY OF RECORD
           a_oba01  LIKE oba_file.oba01,
           a_oba02  LIKE oba_file.oba02,
           a_chuhuo  LIKE type_file.chr1
       END RECORD,
    g_a1_t  RECORD
           a_oba01  LIKE oba_file.oba01,
           a_oba02  LIKE oba_file.oba02,
           a_chuhuo  LIKE type_file.chr1
       END RECORD,
    g_a2    DYNAMIC ARRAY OF RECORD
         a_ogb01     LIKE  ogb_file.ogb01,
         a_ogb03     LIKE  ogb_file.ogb03,
         a_ogb04     LIKE  ogb_file.ogb04,
         a_ima02     LIKE  ima_file.ima02,
         a_ima021    LIKE  ima_file.ima021,
         a_ogb12     LIKE  ogb_file.ogb12
           END  RECORD,
    g_a3    DYNAMIC ARRAY OF RECORD
       #a_imgb00    LIKE imgb_file.imgb00,   #类型 #No:DEV-CB0001--mark
        a_imgb01    LIKE imgb_file.imgb01,   #条码
       #a_iba12     LIKE iba_file.iba12,     #包号 #No:DEV-CB0001--mark
        a_ibb05     LIKE ibb_file.ibb05,     #包号 #No:DEV-CB0001--add
        a_imgb02    LIKE imgb_file.imgb02,   #仓库
        a_imgb03    LIKE imgb_file.imgb03,   #库位
        a_imgb04    LIKE imgb_file.imgb04,   #批号
        a_imgb05    LIKE imgb_file.imgb05    #数量
       #a_more      LIKE imgb_file.imgb05,   #多   #No:DEV-CB0001--mark
       #a_less      LIKE imgb_file.imgb05    #缺   #No:DEV-CB0001--mark
            END  RECORD,
    g_b1 DYNAMIC ARRAY OF RECORD
         b_ogb01    LIKE ogb_file.ogb01,
         b_ogb03    LIKE ogb_file.ogb03,
         b_ogb04    LIKE ogb_file.ogb04,
         b_ima02    LIKE ima_file.ima02,
         b_ima021   LIKE ima_file.ima021,
         b_ogb12    LIKE ogb_file.ogb12,
         b_anku     LIKE type_file.chr1,
         b_ogb09    LIKE ogb_file.ogb09, #DEV-CC0007 add 倉庫
         b_ogb091   LIKE ogb_file.ogb091 #DEV-CC0007 add 儲位
       END RECORD,
    g_b2    DYNAMIC ARRAY OF RECORD
         b_type      LIKE  ibb_file.ibb02, #DEV-CC0001 add
         b_sfb01     LIKE  sfb_file.sfb01,
         b_inb03     LIKE  inb_file.inb03,
         b_e_date    LIKE  sfb_file.sfb13,
         b_sfb04     LIKE  sfb_file.sfb04,
         b_sfb08     LIKE  sfb_file.sfb08,
         b_sfb09     LIKE  sfb_file.sfb09,
         b_sets      LIKE  sfb_file.sfb08,
         b_e_sets    LIKE  sfb_file.sfb08
           END  RECORD,
    g_b2_t  RECORD
         b_type      LIKE  ibb_file.ibb02, #DEV-CC0001 add
         b_sfb01     LIKE  sfb_file.sfb01,
         b_inb03     LIKE  inb_file.inb03,
         b_e_date    LIKE  sfb_file.sfb13,
         b_sfb04     LIKE  sfb_file.sfb04,
         b_sfb08     LIKE  sfb_file.sfb08,
         b_sfb09     LIKE  sfb_file.sfb09,
         b_sets      LIKE  sfb_file.sfb08,
         b_e_sets    LIKE  sfb_file.sfb08
           END  RECORD,
    g_b3    DYNAMIC ARRAY OF RECORD
       #b_imgb00    LIKE imgb_file.imgb00,   #类型 #No:DEV-CB0001--mark
        b_imgb01    LIKE imgb_file.imgb01,   #条码
       #b_iba12     LIKE iba_file.iba12,     #包号 #No:DEV-CB0001--mark
        b_ibb05     LIKE ibb_file.ibb05,     #包号 #No:DEV-CB0001--add
        b_imgb02    LIKE imgb_file.imgb02,   #仓库
        b_imgb03    LIKE imgb_file.imgb03,   #库位
        b_imgb04    LIKE imgb_file.imgb04,   #批号
        b_imgb05    LIKE imgb_file.imgb05    #数量
       #b_more      LIKE imgb_file.imgb05,   #多   #No:DEV-CB0001--mark
       #b_less      LIKE imgb_file.imgb05    #缺   #No:DEV-CB0001--mark
            END  RECORD,
    g_c1 DYNAMIC ARRAY OF RECORD
           c_ogb01  LIKE ogb_file.ogb01,
           c_ogb03  LIKE ogb_file.ogb03,
           c_ogb04  LIKE ogb_file.ogb04,
           c_ima02  LIKE ima_file.ima02,
           c_ima021 LIKE ima_file.ima021,
           c_ogb12  LIKE ogb_file.ogb12,
           c_choose LIKE ogb_file.ogb12
       END RECORD,
    g_c1_t RECORD
           c_ogb01  LIKE ogb_file.ogb01,
           c_ogb03  LIKE ogb_file.ogb03,
           c_ogb04  LIKE ogb_file.ogb04,
           c_ima02  LIKE ima_file.ima02,
           c_ima021 LIKE ima_file.ima021,
           c_ogb12  LIKE ogb_file.ogb12,
           c_choose  LIKE ogb_file.ogb12
       END RECORD,
    g_c2    DYNAMIC ARRAY OF RECORD
       #c_imgb00    LIKE imgb_file.imgb00,   #条码类型 #No:DEV-CB0001--mark
        c_imgb01    LIKE imgb_file.imgb01,   #条码
       #c_iba12     LIKE iba_file.iba12,     #包号 #No:DEV-CB0001--mark
        c_ibb05     LIKE ibb_file.ibb05,     #包号 #No:DEV-CB0001--add
        c_imgb02    LIKE imgb_file.imgb02,   #仓库
        c_imgb03    LIKE imgb_file.imgb03,   #库位
        c_imgb04    LIKE imgb_file.imgb04,   #批号
        c_imgb05    LIKE imgb_file.imgb05    #数量
       #c_more      LIKE imgb_file.imgb05,   #多       #No:DEV-CB0001--mark
       #c_less      LIKE imgb_file.imgb05    #缺       #No:DEV-CB0001--mark
            END  RECORD,
    g_ogb       RECORD LIKE ogb_file.*,
    g_oga       RECORD LIKE oga_file.*,
    g_imm       RECORD LIKE imm_file.*,
    g_ina       RECORD LIKE ina_file.*,
    g_wc,g_wc2,g_wc3     STRING,
    g_sql                STRING,
    g_rec_a         LIKE type_file.num10,
    g_rec_a2        LIKE type_file.num10,
    g_rec_a3        LIKE type_file.num10,
    g_rec_b         LIKE type_file.num10,
    g_rec_b2        LIKE type_file.num10,
    g_rec_b3        LIKE type_file.num10,
    g_rec_c         LIKE type_file.num10,
    g_rec_c2        LIKE type_file.num10,
    g_row_count     LIKE type_file.num5,
    g_curs_index    LIKE type_file.num5,
    mi_no_ask       LIKE type_file.num5,
    g_jump          LIKE type_file.num5,
    l_ac            LIKE type_file.num10,
    l_ac2           LIKE type_file.num10,
    l_ac3           LIKE type_file.num10,
    l_bc            LIKE type_file.num10,
    l_bc2           LIKE type_file.num10,
    l_bc3           LIKE type_file.num10,
    l_cc            LIKE type_file.num10,
    l_cc2           LIKE type_file.num10,
    g_chr           LIKE type_file.chr1,
    g_flag          LIKE type_file.chr1,
    g_msg           STRING

DEFINE g_current_row STRING
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_zz01          LIKE zz_file.zz01
DEFINE g_argv3         LIKE type_file.chr10
DEFINE g_form          LIKE type_file.chr10
DEFINE g_ins_box       LIKE type_file.chr1 #只要有配貨單一筆成功即LET g_ins_box = 'Y' #DEV-CC0001 add

FUNCTION sabap600(p_argv1,p_argv2,p_argv3)
   DEFINE p_argv1  LIKE  ogb_file.ogb01
   DEFINE p_argv2  LIKE  ogb_file.ogb03
   DEFINE p_argv3  LIKE  type_file.chr10

   WHENEVER ERROR CALL cl_err_msg_log
   WHENEVER ERROR CONTINUE


  #SELECT * INTO g_sba.* FROM sba_file WHERE 1=1         #No:DEV-CB0008--mark
   SELECT * INTO g_ibd.* FROM ibd_file WHERE ibd01 = '0' #No:DEV-CB0008--add
   IF SQLCA.SQLCODE THEN
      CALL cl_err('','aba-000',1)
      RETURN
   END IF
   INITIALIZE tm.* TO NULL

   LET tm.ogb01  = p_argv1
   LET tm.ogb03  = p_argv2
   LET g_argv3 = p_argv3

    OPEN WINDOW p600_w AT p_row,p_col WITH FORM "aba/42f/sabap600"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    CALL p600_ui_init()
    CALL p600_temp()

    IF cl_null(tm.ogb01) THEN
       CALL p600_tm(0,0)
    ELSE
       CALL sabap600_main()
    END IF

    CALL p600_menu()
    CLOSE WINDOW p600_w                  #結束畫面

END FUNCTION

FUNCTION p600_temp()
    DROP TABLE sabap600_temp
    SELECT ogb01,ogb03,ogb31,ogb12
      FROM ogb_file WHERE 1=2 INTO TEMP sabap600_temp
    IF SQLCA.sqlcode THEN
       CALL cl_err('sabap600_temp',-261,1)
       EXIT PROGRAM
    END IF
END FUNCTION

FUNCTION p600_ui_init()

  #No:DEV-CB0001--mark--begin
  #CASE g_argv3
  #  WHEN  'aimt324'
  #    CALL cl_set_comp_visible("Page4",FALSE)
  #    CALL cl_set_comp_att_text("b_ogb01",'调拨单号')
  #    CALL cl_set_comp_att_text("b_sfb01",'工单号/杂收单号')
  #    CALL cl_set_comp_att_text("c_ogb01",'调拨单号')
  #  WHEN  'cimt327'
  #    CALL cl_set_comp_visible("Page4",FALSE)
  #    CALL cl_set_comp_att_text("b_ogb01",'跨厂调拨单号')
  #    CALL cl_set_comp_att_text("b_sfb01",'工单号/杂收单号')
  #    CALL cl_set_comp_att_text("c_ogb01",'跨厂调拨单号')
  #  WHEN  'aimt301'
  #    CALL cl_set_comp_visible("Page4",FALSE)
  #    CALL cl_set_comp_att_text("b_ogb01",'杂发单号')
  #    CALL cl_set_comp_att_text("b_sfb01",'工单号/杂收单号')
  #    CALL cl_set_comp_att_text("c_ogb01",'杂发单号')
  #  WHEN  'axmt610'
  #     CALL cl_set_comp_visible("Page4",TRUE)
  #END CASE
  #No:DEV-CB0001--mark--end

   CALL cl_set_comp_visible("a_imgb04,b_imgb04,c_imgb04",FALSE)          #DEV-CC0007 add 批號欄位隱藏
  #No:DEV-CB0001--add--begin
   CASE g_argv3
      WHEN  'axmt610'
         CALL cl_set_comp_visible("Page4",TRUE)
         CALL cl_getmsg('aba-088',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("b_ogb01",g_msg CLIPPED)
        #CALL cl_getmsg('aba-092',g_lang) RETURNING g_msg    #DEV-CC0001 mark
        #CALL cl_set_comp_att_text("b_sfb01",g_msg CLIPPED)  #DEV-CC0001 mark
         CALL cl_getmsg('aba-088',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("c_ogb01",g_msg CLIPPED)

      WHEN  'aimt301'
         CALL cl_set_comp_visible("Page4",FALSE)
         CALL cl_getmsg('aba-084',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("b_ogb01",g_msg CLIPPED)
        #CALL cl_getmsg('aba-093',g_lang) RETURNING g_msg    #DEV-CC0001 mark
        #CALL cl_set_comp_att_text("b_sfb01",g_msg CLIPPED)  #DEV-CC0001 mark
         CALL cl_getmsg('aba-084',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("c_ogb01",g_msg CLIPPED)

      WHEN  'aimt324'
         CALL cl_set_comp_visible("Page4",FALSE)
         CALL cl_getmsg('aba-080',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("b_ogb01",g_msg CLIPPED)
        #CALL cl_getmsg('aba-093',g_lang) RETURNING g_msg    #DEV-CC0001 mark
        #CALL cl_set_comp_att_text("b_sfb01",g_msg CLIPPED)  #DEV-CC0001 mark
         CALL cl_getmsg('aba-080',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("c_ogb01",g_msg CLIPPED)
   END CASE
  #No:DEV-CB0001--add--end

END FUNCTION

FUNCTION p600_menu()

   WHILE TRUE
      CALL p600_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p600_tm(0,0)
            END IF
         WHEN "accept_a"
            IF cl_chk_act_auth() THEN
               CALL p600_b_a()
            END IF
         WHEN "accept_b"
            IF cl_chk_act_auth() THEN
               CALL p600_b_b()
            END IF
         WHEN "accept_c"
            IF cl_chk_act_auth() THEN
               CALL p600_b_c()
            END IF
         WHEN "gen_box"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()
               CALL p600_gen_box()
               IF g_success = 'N' THEN
                  CALL s_showmsg()
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


FUNCTION p600_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_flag         LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5

   LET p_row = 4 LET p_col = 13

   OPEN WINDOW abap600_w1 AT p_row,p_col WITH FORM "aba/42f/sabap600_a"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("sabap600_a")

  #No:DEV-CA0017--mark--begin
  #CASE g_argv3
  #  WHEN 'aimt324'
  #    CALL cl_set_comp_att_text("ogb01",'调拨单号')
  #  WHEN 'cimt327'
  #    CALL cl_set_comp_att_text("ogb01",'跨厂调拨单号')
  #  WHEN 'aimt301'
  #    CALL cl_set_comp_att_text("ogb01",'杂发单号')
  #  WHEN 'axmt610'
  #END CASE
  #No:DEV-CA0017--mark--end

  #No:DEV-CB0001--add--begin
   CASE g_argv3
      WHEN  'axmt610'
         CALL cl_getmsg('aba-088',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("ogb01",g_msg CLIPPED)
      WHEN  'aimt301'
         CALL cl_getmsg('aba-084',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("ogb01",g_msg CLIPPED)
      WHEN  'aimt324'
         CALL cl_getmsg('aba-080',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("ogb01",g_msg CLIPPED)
   END CASE
  #No:DEV-CB0001--add--end

   CALL cl_opmsg('p')
   DISPLAY BY NAME tm.ogb01,tm.ogb03
   WHILE TRUE
      DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME tm.ogb01,tm.ogb03 ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
 
          BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
          
          #No.130710----mark by zhangjiao---Str
          #ON ACTION CONTROLZ
          #   CALL cl_show_req_fields()
          #
          #ON ACTION CONTROLG
          #   CALL cl_cmdask()
          #No.130710----mark by zhangjiao---End 

          AFTER FIELD ogb01
             CASE g_argv3
               WHEN 'aimt324'
                INITIALIZE g_imm.* TO NULL
                SELECT * INTO g_imm.* FROM imm_file
                 WHERE imm01 = tm.ogb01
                IF g_imm.immconf != 'Y' THEN
                   CALL cl_err(tm.ogb01,'aba-040',0)
                   NEXT FIELD ogb01
                END IF
              #No:DEV-CB0001--makr--begin
              #WHEN 'cimt327'
              # INITIALIZE g_imm.* TO NULL
              # SELECT * INTO g_imm.* FROM imm_file
              #  WHERE imm01 = tm.ogb01
              #    AND imm10 = '3'
              # #IF g_imm.immconf != 'Y' THEN
              # IF g_imm.imm04 != 'Y' THEN
              #    CALL cl_err(tm.ogb01,'aba-040',0)
              #    NEXT FIELD ogb01
              # END IF
              #No:DEV-CB0001--makr--end
               WHEN 'aimt301'
                INITIALIZE g_ina.* TO NULL
                SELECT * INTO g_ina.* FROM ina_file
                 WHERE ina01 = tm.ogb01
                IF g_ina.inaconf != 'Y' THEN
                   CALL cl_err(tm.ogb01,'aba-040',0)
                   NEXT FIELD ogb01
                END IF
               WHEN 'axmt610'
                INITIALIZE g_oga.* TO NULL
                SELECT * INTO g_oga.* FROM oga_file
                 WHERE ogb01 = tm.ogb01
                IF g_oga.ogaconf != 'Y' THEN
                   CALL cl_err(tm.ogb01,'aba-025',0)
                   NEXT FIELD ogb01
                END IF
             END CASE
 
          #No.130710----mark by zhangjiao---Str
          #ON IDLE g_idle_seconds
          #   CALL cl_on_idle()
          #   CONTINUE DIALOG
          #
          #ON ACTION about
          #   CALL cl_about()
          # 
          #ON ACTION help
          #   CALL cl_show_help()
          # 
          #ON ACTION exit
          #   LET INT_FLAG = 1
          #   EXIT DIALOG
          #
          #ON ACTION qbe_save
          #   CALL cl_qbe_save()
          #No.130710----mark by zhangjiao---End 
 
      END INPUT
 
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ogb01)
                  CALL cl_init_qry_var()
                  CASE g_argv3
                    WHEN 'aimt324'
                     #LET g_qryparam.form = 'cq_imm01' #No:DEV-CB0001--mark
                      LET g_qryparam.form = 'q_imm1'   #No:DEV-CB0001--add
                   #No:DEV-CB0001--mark--begin
                   #WHEN 'cimt327'
                   #  LET g_qryparam.FORM = 'q_imm105'
                   #No:DEV-CB0001--mark--end
                    WHEN 'aimt301'
                      LET g_qryparam.form = 'q_ina'
                    WHEN 'axmt610'
                     #LET g_qryparam.form = 'cq_oga7'  #No:DEV-CB0001--mark
                      LET g_qryparam.form = 'q_oga16'  #No:DEV-CB0001--add
                      LET g_qryparam.arg1 = "1','5"
                  END CASE
                  CALL cl_create_qry() RETURNING tm.ogb01
                  DISPLAY BY NAME tm.ogb01
                  NEXT FIELD ogb01
              #No:DEV-CB0001--mark--begin
              #WHEN INFIELD(ogb03)
              #   CALL cl_init_qry_var()
              #   CASE g_argv3
              #     WHEN 'aimt324'
              #      LET g_qryparam.form = 'cq_imm01'
              #     WHEN 'axmt610'
              #      LET g_qryparam.form = 'cq_ogb01'
              #      LET g_qryparam.where = " ogb01='",tm.ogb01,"' "
              #   END CASE
              #   CALL cl_create_qry() RETURNING tm.ogb01,tm.ogb03
              #   DISPLAY BY NAME tm.ogb01,tm.ogb03
              #   NEXT FIELD ogb03
              #No:DEV-CB0001--mark--end
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
 
            ON ACTION accept
              #EXIT DIALOG     #No:DEV-CB0001--mark
               ACCEPT DIALOG   #No:DEV-CB0001--add
 
            ON ACTION cancel
               LET INT_FLAG = 1
               EXIT DIALOG
 
      END DIALOG
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW abap600_w1
         RETURN
      END IF
      CLOSE WINDOW abap600_w1
      CALL cl_wait()
      TRUNCATE sabap600_temp
      CALL sabap600_main()
      ERROR ""
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION sabap600_main()
DEFINE l_cnt  LIKE type_file.num5

   CLEAR FORM
   CALL g_a1.CLEAR()  CALL g_a2.CLEAR()  CALL g_a3.CLEAR()
   CALL g_b1.CLEAR()  CALL g_b2.CLEAR()  CALL g_b3.CLEAR()
   CALL g_c1.CLEAR()  CALL g_c2.CLEAR()
   LET g_current_row = ''

  CASE g_argv3
    WHEN 'aimt324'
      SELECT * INTO g_imm.* FROM imm_file
       WHERE imm01 = tm.ogb01
   #No:DEV-CB0001--mark--begin
   #WHEN 'cimt327'
   #  SELECT * INTO g_imm.* FROM imm_file
   #   WHERE imm01 = tm.ogb01
   #     AND imm10 = '3'
   #No:DEV-CB0001--mark--end
    WHEN 'aimt301'
      SELECT * INTO g_ina.* FROM ina_file
       WHERE ina01 = tm.ogb01
    WHEN 'axmt610'
      SELECT * INTO g_oga.* FROM oga_file
       WHERE oga01 = tm.ogb01
  END CASE
  #page1 屏风类
   CALL p600_b_fill_a()
    #屏风类初始数据界面显示
    IF g_rec_a > 0 THEN
       LET l_ac = 1
       CALL p600_c_fill_a(g_a1[1].a_oba01)
       IF g_rec_a2 > 0 THEN
          LET l_ac2 = 1
          CALL p600_d_fill_a(g_a1[1].a_oba01)
       END IF
    END IF
  #page2 工单成品类
   CALL p600_b_fill_b()
    #工单成品类初始数据界面显示
    IF g_rec_b > 0 THEN
       LET l_bc= 1
       CALL p600_c_fill_b(g_b1[1].b_ogb01,g_b1[1].b_ogb03,g_b1[1].b_ogb04,g_b1[1].b_anku)
       IF g_rec_b2 > 0 THEN
          LET l_bc2 = 1
          CALL p600_d_fill_b(g_b2[1].b_sfb01,g_b2[1].b_inb03,1,g_b1[1].b_ogb01,g_b1[1].b_ogb03)
       END IF
    END IF
  #page3 外购成品类
   CALL p600_b_fill_c()
    IF g_rec_b > 0 THEN
       LET l_cc= 1
       CALL p600_d_fill_c(g_c1[1].c_ogb04,l_cc)
    END IF

END FUNCTION

#Page1.屏风类 显示所有的系列，只从完成出货通知单角度来考量，无视出货项次
FUNCTION p600_b_fill_a()

   LET g_sql = "SELECT DISTINCT oba01,oba02,'N' ",
               "  FROM oba_file,ogb_file,ima_file ",
               " WHERE ogb01 ='",tm.ogb01,"' ",
               "   AND ogb04 = ima01 ",
              #"   AND ima76 = '52' ", #No:DEV-CB0001--mark
               "   AND ima932= 'H' ",  #No:DEV-CB0001--add  #條碼產生時機點：'H':訂單包裝單
               "   AND ima131 = oba01 ",
               "   AND ogb03 NOT IN (SELECT box02 FROM box_file WHERE box01 = '",tm.ogb01,"') "

   PREPARE b_fill_a FROM g_sql
   DECLARE b_cs_a CURSOR FOR b_fill_a
   LET g_cnt = 1
   FOREACH b_cs_a INTO g_a1[g_cnt].*
      IF STATUS THEN EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_a1.deleteElement(g_cnt)
   LET g_rec_a = g_cnt - 1
   DISPLAY g_rec_a TO a_idx
END FUNCTION

#Page2 工单成品类 显示所有的出货通知单项次
FUNCTION p600_b_fill_b()
DEFINE l_cnt LIKE type_file.num5

   CASE g_argv3
     WHEN  'aimt324'
      #LET g_sql = "SELECT imn01,imn02,imn03,ima02,ima021,imn10,'' ",             #DEV-CC0007 mark
       LET g_sql = "SELECT imn01,imn02,imn03,ima02,ima021,imn10,'' ,imn04,imn05", #DEV-CC0007 add imn04,imn05
                   "  FROM imn_file,ima_file",
                   " WHERE imn01 = '",tm.ogb01,"' ",
                   "   AND ima01 = imn03 ",
                  #"   AND ima76 IN ('50','501') ", #No:DEV-CB0001--mark
                   "   AND ima932 = 'A' ",          #No:DEV-CB0001--add #'A':工單
                   "   AND imn02 NOT IN (SELECT box02 FROM box_file WHERE box01 = '",tm.ogb01,"') "
       IF NOT cl_null(tm.ogb03) THEN
          LET g_sql = g_sql ," AND imn02 IN ",tm.ogb03
       END IF
    #No:DEV-CB0001--mark--begin
    #WHEN  'cimt327'
    #  LET g_sql = "SELECT imn01,imn02,imn03,ima02,ima021,imn10,'' ",
    #              "  FROM imn_file,ima_file",
    #              " WHERE imn01 = '",tm.ogb01,"' ",
    #              "   AND ima01 = imn03 ",
    #              "   AND ima76 IN ('50','501') ",
    #              "   AND imn02 NOT IN (SELECT box02 FROM box_file WHERE box01 = '",tm.ogb01,"') "
    #  IF NOT cl_null(tm.ogb03) THEN
    #     LET g_sql = g_sql ," AND imn02 IN ",tm.ogb03
    #  END IF
    #No:DEV-CB0001--mark--end
     WHEN  'aimt301'
      #LET g_sql = "SELECT inb01,inb03,inb04,ima02,ima021,inb09,'' ",             #DEV-CC0007 mark
       LET g_sql = "SELECT inb01,inb03,inb04,ima02,ima021,inb09,'',inb05,inb06 ", #DEV-CC0007 add inb05,inb06
                   "  FROM inb_file,ima_file",
                   " WHERE inb01 = '",tm.ogb01,"' ",
                   "   AND ima01 = inb04 ",
                  #"   AND ima76 IN ('50','501') ", #No:DEV-CB0001--mark
                   "   AND ima932 = 'A' ",          #No:DEV-CB0001--add #'A':工單
                   "   AND inb03 NOT IN (SELECT box02 FROM box_file WHERE box01 = '",tm.ogb01,"') "
       IF NOT cl_null(tm.ogb03) THEN
          LET g_sql = g_sql ," AND inb03 IN ",tm.ogb03
       END IF
     WHEN 'axmt610'
      #LET g_sql = "SELECT ogb01,ogb03,ogb04,ima02,ima021,ogb12,'' ",             #DEV-CC0007 mark
       LET g_sql = "SELECT ogb01,ogb03,ogb04,ima02,ima021,ogb12,'',ogb09,ogb091 ",#DEV-CC0007 add ogb09,ogb091
                   "  FROM ogb_file,ima_file",
                   " WHERE ogb01 = '",tm.ogb01,"' ",
                   "   AND ima01 = ogb04 ",
                  #"   AND ima76 IN ('50','501') ", #No:DEV-CB0001--mark
                   "   AND ima932 = 'A' ",          #No:DEV-CB0001--add #'A':工單
                   "   AND ogb04 NOT LIKE 'MISC%' ",
                   "   AND ogb03 NOT IN (SELECT box02 FROM box_file WHERE box01 = '",tm.ogb01,"') "
       IF NOT cl_null(tm.ogb03) THEN
          LET g_sql = g_sql ," AND ogb03 IN ",tm.ogb03
       END IF
   END CASE

   PREPARE b_fill_b FROM g_sql
   DECLARE b_cs_b CURSOR FOR b_fill_b
   LET g_cnt = 1
   FOREACH b_cs_b INTO g_b1[g_cnt].*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt = 0
     #No:DEV-CB0001--mark--begin
     ##是否走工单成品
     # SELECT tc_imb03 INTO g_b1[g_cnt].b_anku FROM tc_imb_file
     #  WHERE tc_imb01 = g_b1[g_cnt].b_ogb04 AND rownum = 1
     #  ORDER BY tc_imb04 desc,tc_imb05 desc
     # IF cl_null(g_b1[g_cnt].b_anku) THEN
     #    LET g_b1[g_cnt].b_anku = 'N'
     # END IF
     #No:DEV-CB0001--mark--end

     #No:DEV-CB0018--mark--begin
      SELECT ima934 INTO g_b1[g_cnt].b_anku
        FROM ima_file
       WHERE ima01 = g_b1[g_cnt].b_ogb04
      IF cl_null(g_b1[g_cnt].b_anku) THEN
         LET g_b1[g_cnt].b_anku = 'Y'
      END IF
     #No:DEV-CB0018--mark--end

    #原来工单是否安库逻辑，与上面那段合并一起，暂时先将原来写法
    #保留在下面。
#      SELECT COUNT(*) INTO l_cnt
#        FROM ogb_file,sfb_file
#       WHERE ogb01 =g_b1[g_cnt].b_ogb01 and ogb03 = g_b1[g_cnt].b_ogb03
#         AND ogb31= sfb22 and ogb32 = sfb221
#      IF l_cnt > 0 THEN
#         LET g_b1[g_cnt].b_anku = 'N'
#      ELSE
#         LET g_b1[g_cnt].b_anku = 'Y'
#      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_b1.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO b_idx

END FUNCTION

#Page2 外购成品类 显示所有的出货通知单项次
FUNCTION p600_b_fill_c()
DEFINE l_cnt LIKE type_file.num5

  CASE g_argv3
    WHEN 'aimt324'
      LET g_sql = "SELECT imn01,imn02,imn03,ima02,ima021,imn10,'' ",
                  "  FROM imn_file,ima_file",
                  " WHERE imn01 = '",tm.ogb01,"' ",
                  "   AND ima01 = imn03 ",
                 #"   AND ima76 IN ('10','501') ", #No:DEV-CB0001--mark
                  "   AND ima932 IN ('F','G') ",   #No:DEV-CB0001--add   #條碼產生時機點'F':採購單 'G':G:委外採購單
                  "   AND imn02 NOT IN (SELECT box02 FROM box_file WHERE box01 = '",tm.ogb01,"') "
      IF NOT cl_null(tm.ogb03) THEN
         LET g_sql = g_sql ," AND imn02 IN ",tm.ogb03
      END IF
   #No:DEV-CB0001--mark--begin
   #WHEN 'cimt327'
   #  LET g_sql = "SELECT imn01,imn02,imn03,ima02,ima021,imn10,'' ",
   #              "  FROM imn_file,ima_file",
   #              " WHERE imn01 = '",tm.ogb01,"' ",
   #              "   AND ima01 = imn03 ",
   #              "   AND ima76 IN ('10','501') ",
   #              "   AND imn02 NOT IN (SELECT box02 FROM box_file WHERE box01 = '",tm.ogb01,"') "
   #  IF NOT cl_null(tm.ogb03) THEN
   #     LET g_sql = g_sql ," AND imn02 IN ",tm.ogb03
   #  END IF
   #No:DEV-CB0001--mark--end
    WHEN 'aimt301'
      LET g_sql = "SELECT inb01,inb03,inb04,ima02,ima021,inb09,'' ",
                  "  FROM inb_file,ima_file",
                  " WHERE inb01 = '",tm.ogb01,"' ",
                  "   AND ima01 = inb04 ",
                 #"   AND ima76 IN ('10','501') ", #No:DEV-CB0001--mark
                  "   AND ima932 IN ('F','G') ",   #No:DEV-CB0001--add   #條碼產生時機點'F':採購單 'G':G:委外採購單
                  "   AND inb03 NOT IN (SELECT box02 FROM box_file WHERE box01 = '",tm.ogb01,"') "
      IF NOT cl_null(tm.ogb03) THEN
         LET g_sql = g_sql ," AND inb03 IN ",tm.ogb03
      END IF
    WHEN 'axmt610'
      LET g_sql = "SELECT ogb01,ogb03,ogb04,ima02,ima021,ogb12,'' ",
                  "  FROM ogb_file,ima_file",
                  " WHERE ogb01 = '",tm.ogb01,"' ",
                  "   AND ima01 = ogb04 ",
                 #"   AND ima76 IN ('10','501') ", #No:DEV-CB0001--mark
                  "   AND ima932 IN ('F','G') ",   #No:DEV-CB0001--add   #條碼產生時機點'F':採購單 'G':G:委外採購單
                  "   AND ogb03 NOT IN (SELECT box02 FROM box_file WHERE box01 = '",tm.ogb01,"') "
      IF NOT cl_null(tm.ogb03) THEN
         LET g_sql = g_sql ," AND ogb03 IN ",tm.ogb03
      END IF
  END CASE

   PREPARE b_fill_c FROM g_sql
   DECLARE b_cs_c CURSOR FOR b_fill_c
   LET g_cnt = 1
   FOREACH b_cs_c INTO g_c1[g_cnt].*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt = 0
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_c1.deleteElement(g_cnt)
   LET g_rec_c = g_cnt - 1
   DISPLAY g_rec_c TO c_idx

END FUNCTION

#Page1 屏风类
FUNCTION p600_c_fill_a(p_oba01)
DEFINE p_oba01  LIKE oba_file.oba01

  CALL g_a2.CLEAR()
  CALL g_a3.CLEAR()
  LET g_sql = "SELECT ogb01,ogb03,ogb04,ima02,ima021,ogb12 ",
              "  FROM ogb_file,ima_file ",
              " WHERE ogb01 = '",tm.ogb01,"' ",
              "   AND ima131 = '",p_oba01,"' ",
              "   AND ogb04 = ima01 ",
              "   AND ima932 = 'H' " #DEV-CC0001 add
  PREPARE c_fill_a FROM g_sql
  DECLARE c_cs_a CURSOR FOR c_fill_a
  LET g_cnt = 1
  FOREACH c_cs_a INTO g_a2[g_cnt].*
     IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
     IF g_cnt > g_max_rec THEN
        CALL cl_err('',9035,0)
        EXIT FOREACH
     END IF
     LET g_cnt = g_cnt + 1
  END FOREACH
  CALL g_a2.deleteElement(g_cnt)
  LET g_rec_a2 = g_cnt - 1
  DISPLAY g_rec_a2 TO a_cnt
END FUNCTION

#Page2 工单成品类
FUNCTION p600_c_fill_b(p_ogb01,p_ogb03,p_sfb05,p_anku)
DEFINE p_wc2   STRING
DEFINE p_ogb01 LIKE ogb_file.ogb01
DEFINE p_ogb03 LIKE ogb_file.ogb03
DEFINE p_sfb05 LIKE sfb_file.sfb05
DEFINE p_anku  LIKE type_file.chr1
DEFINE l_wh  LIKE  inb_file.inb05  #DEV-CC0007 add 倉庫
DEFINE l_loc LIKE  inb_file.inb06  #DEV-CC0007 add 儲位

   CALL g_b2.CLEAR()
   CALL g_b3.CLEAR()
  #No:DEV-CB0001--mark--begin
  #CASE g_argv3
  #  WHEN 'aimt324'
  #       LET g_sql = "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #                   "  FROM sfb_file oa, ",
  #                   " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #                   "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #                   " WHERE oc.sfv11 = oa.sfb01 ",
  #                   "   AND oa.sfb01 IN (SELECT iba14 FROM iba_file WHERE iba16 = '1' AND iba09 = '",p_sfb05,"') ",
  #                   " UNION ",
  #                   "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #                   "  FROM sfb_file oa, ",
  #                   " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #                   "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #                   " WHERE oc.sfv11 = oa.sfb01 ",
  #                   "   AND oa.sfb05 IN (SELECT iba09 FROM iba_file WHERE iba16 = '2' AND iba09 = '",p_sfb05,"') ",
  #                   " UNION ",
  #                   "SELECT ina01,inb03,ina02,'',0,inb16,'','' ",
  #                   "  FROM ina_file,inb_file,iba_file ",
  #                   " WHERE ina01 = inb01 ",
  #                   "   AND inb01 = iba05 ",
  #                   "   AND inb03 = iba06 ",
  #                   "   AND iba09 = '",p_sfb05,"' ",
  #                   "   AND iba16 = '2' "
  # #   LET g_sql = "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",
  # #               "  FROM sfb_file oa, ",
  # #               " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  # #               "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  # #               " WHERE oa.sfb05 = '",p_sfb05,"' ",
  # #               "   AND oa.sfb01 = oc.sfv11 ",
  # #               "   AND oa.sfb22 IS NULL ",
  # #               " UNION ",
  # #               " SELECT ina01,inb03,ina02,'',0,inb16,'','' ",
  # #               "   FROM ina_file,inb_file,iba_file ",
  # #               "  WHERE ina01 = inb01 ",
  # #               "    AND inb01 = iba05 ",
  # #               "    AND inb03 = iba06 ",
  # #               "    AND iba09 = '",p_sfb05,"' ",
  # #               "    AND iba16 = '2' "
  # #               #"  ORDER BY ina02 "
  #  WHEN 'cimt327'
  #       LET g_sql = "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #                   "  FROM sfb_file oa, ",
  #                   " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #                   "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #                   " WHERE oc.sfv11 = oa.sfb01 ",
  #                   "   AND oa.sfb01 IN (SELECT iba14 FROM iba_file WHERE iba16 = '1' AND iba09 = '",p_sfb05,"') ",
  #                   " UNION ",
  #                   "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #                   "  FROM sfb_file oa, ",
  #                   " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #                   "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #                   " WHERE oc.sfv11 = oa.sfb01 ",
  #                   "   AND oa.sfb05 IN (SELECT iba09 FROM iba_file WHERE iba16 = '2' AND iba09 = '",p_sfb05,"') ",
  #                   " UNION ",
  #                   "SELECT ina01,inb03,ina02,'',0,inb16,'','' ",
  #                   "  FROM ina_file,inb_file,iba_file ",
  #                   " WHERE ina01 = inb01 ",
  #                   "   AND inb01 = iba05 ",
  #                   "   AND inb03 = iba06 ",
  #                   "   AND iba09 = '",p_sfb05,"' ",
  #                   "   AND iba16 = '2' "
  #  WHEN 'aimt301'
  #       LET g_sql = "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #                   "  FROM sfb_file oa, ",
  #                   " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #                   "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #                   " WHERE oc.sfv11 = oa.sfb01 ",
  #                   "   AND oa.sfb01 IN (SELECT iba14 FROM iba_file WHERE iba16 = '1' AND iba09 = '",p_sfb05,"') ",
  #                   " UNION ",
  #                   "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #                   "  FROM sfb_file oa, ",
  #                   " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #                   "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #                   " WHERE oc.sfv11 = oa.sfb01 ",
  #                   "   AND oa.sfb05 IN (SELECT iba09 FROM iba_file WHERE iba16 = '2' AND iba09 = '",p_sfb05,"') ",
  #                   " UNION ",
  #                   "SELECT ina01,inb03,ina02,'',0,inb16,'','' ",
  #                   "  FROM ina_file,inb_file,iba_file ",
  #                   " WHERE ina01 = inb01 ",
  #                   "   AND inb01 = iba05 ",
  #                   "   AND inb03 = iba06 ",
  #                   "   AND iba09 = '",p_sfb05,"' ",
  #                   "   AND iba16 = '2' "
  #  WHEN 'axmt610'
  #       LET g_sql = "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #                   "  FROM sfb_file oa, ",
  #                   " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #                   "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #                   " WHERE oc.sfv11 = oa.sfb01 ",
  #                   "   AND oa.sfb01 IN (SELECT iba14 FROM iba_file WHERE iba16 = '1' AND iba09 = '",p_sfb05,"') ",
  #                   " UNION ",
  #                   "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #                   "  FROM sfb_file oa, ",
  #                   " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #                   "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #                   " WHERE oc.sfv11 = oa.sfb01 ",
  #                   "   AND oa.sfb05 IN (SELECT iba09 FROM iba_file WHERE iba16 = '2' AND iba09 = '",p_sfb05,"') ",
  #                   " UNION ",
  #                   "SELECT ina01,inb03,ina02,'',0,inb16,'','' ",
  #                   "  FROM ina_file,inb_file,iba_file ",
  #                   " WHERE ina01 = inb01 ",
  #                   "   AND inb01 = iba05 ",
  #                   "   AND inb03 = iba06 ",
  #                   "   AND iba09 = '",p_sfb05,"' ",
  #                   "   AND iba16 = '2' "

  #  #  IF p_anku = 'Y' THEN
  #  #     LET g_sql = "SELECT DISTINCT sfb01,'',oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #  #                 "  FROM sfb_file oa, ",
  #  #                 " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #  #                 "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #  #                 " WHERE oa.sfb05 = '",p_sfb05,"' ",
  #  #                 "   AND oa.sfb01 = oc.sfv11 ",
  #  #                 "   AND oa.sfb22 IS NULL ",
  #  #                 " ORDER BY oc.e_date "
  #  #  ELSE
  #  #     LET g_sql = "SELECT DISTINCT sfb01,'',oc.e_date,sfb04,sfb08,sfb09,'','' ",
  #  #                 "  FROM sfb_file oa,ogb_file ob, ",
  #  #                 " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
  #  #                 "   WHERE iu.sfu01 = iv.sfv01 ) oc",
  #  #                 " WHERE oc.sfv11 = oa.sfb01 ",
  #  #                 "   AND sfb22 = ogb31 ",
  #  #                 "   AND sfb221= ogb32 ",
  #  #                 "   AND ogb01 = '",p_ogb01,"' ",
  #  #                 "   AND ogb03 =",p_ogb03,
  #  #                 " ORDER BY oc.e_date "
  #  #  END IF
  #END CASE
  #No:DEV-CB0001--mark--end

  #No:DEV-CB0001--add--begin
  #LET g_sql = "SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",     #DEV-CC0001 mark
   LET g_sql = "SELECT DISTINCT 'A',sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ", #DEV-CC0001 add
               "  FROM sfb_file oa, ",
               " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
               "   WHERE iu.sfu01 = iv.sfv01 ) oc",
               " WHERE oc.sfv11 = oa.sfb01 ",
               "   AND oa.sfb01 IN (SELECT ibb03 FROM ibb_file",
               "                     WHERE ibb06 = '",p_sfb05,"' AND ibb02 = 'A')",
               " UNION ",
              #"SELECT DISTINCT sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",      #DEV-CC0001 mark
               "SELECT DISTINCT 'A',sfb01,0,oc.e_date,sfb04,sfb08,sfb09,'','' ",  #DEV-CC0001 add
               "  FROM sfb_file oa, ",
               " (SELECT sfv11,sfu02 AS e_date FROM sfu_file iu,sfv_file iv ",
               "   WHERE iu.sfu01 = iv.sfv01 ) oc",
               " WHERE oc.sfv11 = oa.sfb01 ",
               "   AND oa.sfb05 IN (SELECT ibb06 FROM ibb_file",
               "                     WHERE ibb06 = '",p_sfb05,"' AND ibb02 = 'A')",
               " UNION ",
              #"SELECT ina01,inb03,ina02,'',0,inb16,'','' ",        #DEV-CC0001 mark
               "SELECT 'I',ina01,inb03,ina02,'',0,inb16,'','' ",    #DEV-CC0001 add
               "  FROM ina_file,inb_file,ibb_file ",
               " WHERE ina01 = inb01 ",
               "   AND inb01 = ibb03 ",          #來源單號
               "   AND inb03 = ibb04 ",          #來源項次
               "   AND ibb06 = '",p_sfb05,"' ",  #料號
               "   AND ibb02 = 'I' "             #條碼產生時機點'I':雜收單
  #No:DEV-CB0001--add--end
   PREPARE c_fill_b FROM g_sql
   DECLARE c_cs_b CURSOR FOR c_fill_b

   LET g_cnt = 1
   FOREACH c_cs_b INTO g_b2[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#       LET g_sql = "SELECT MIN(sets) FROM ( ",
#                   #" SELECT imgb01,iba12,nvl(imgb05,0) AS sets ",
#                   " SELECT imgb01,iba12,imgb02,SUM(imgb05) AS sets ",
#                   "   FROM iba_file,imgb_file ",
#                   "  WHERE iba14 = '",g_b2[g_cnt].b_sfb01,"' ",
#                   "    AND imgb01(+) = iba01 ",
#                   "    AND imgb00(+) = iba00 ",
#                   " ) "
      #DEV-CC0007 add---str---
      LET l_wh = ''
      LET l_loc = ''                                      
      CASE g_argv3
          WHEN 'axmt610'
               SELECT ogb09,ogb091 INTO l_wh,l_loc FROM ogb_file 
                WHERE ogb01 = p_ogb01 
                  AND ogb03 = p_ogb03
          WHEN 'aimt301'
               SELECT inb05,inb06 INTO l_wh,l_loc FROM inb_file 
                WHERE inb01 = p_ogb01 
                  AND inb03 = p_ogb03
          WHEN 'aimt324'
               SELECT imn04,imn05 INTO l_wh,l_loc FROM imn_file 
                WHERE imn01 = p_ogb01 
                  AND imn02 = p_ogb03
      END CASE
      #DEV-CC0007 add---end---
      #No:DEV-CB0001--mark--begin
      #LET g_sql = "SELECT MIN(SUM(imgb05)) ",
      #            "   FROM iba_file,imgb_file ",
      #            "  WHERE iba14 = '",g_b2[g_cnt].b_sfb01,"' ",
      #            "    AND imgb01(+) = iba01 ",
      #            "    AND imgb00(+) = iba00 ",
      #            "  GROUP BY imgb01,iba12 "
      #No:DEV-CB0001--mark--end
      #No:DEV-CB0001--add--begin
       LET g_sql = "SELECT MIN(SUM(imgb05)) ",
                   "   FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                   "  WHERE ibb03 = '",g_b2[g_cnt].b_sfb01,"' ",
                   "    AND imgb02 = '",l_wh,"'",  #DEV-CC0007 add 倉庫
                   "    AND imgb03 = '",l_loc,"'", #DEV-CC0007 add 儲位 
                   "  GROUP BY imgb01,ibb05 "
      #No:DEV-CB0001--add--end

       PREPARE get_sets FROM g_sql
       EXECUTE get_sets INTO g_b2[g_cnt].b_sets
      #IF g_b2[g_cnt].b_sets < 0 THEN                                  #DEV-CC0007 mark
       IF g_b2[g_cnt].b_sets < 0 OR cl_null(g_b2[g_cnt].b_sets) THEN   #DEV-CC0007 add
          LET g_b2[g_cnt].b_sets = 0
       END IF

      #非安库，直接从工单转出数量
       CASE g_argv3
          WHEN 'axmt610'
           # IF p_anku = 'N' THEN
           #    LET g_b2[g_cnt].b_e_sets = g_b2[g_cnt].b_sets
           # ELSE
               SELECT ogb12 INTO g_b2[g_cnt].b_e_sets FROM sabap600_temp
                WHERE ogb01 = p_ogb01
                  AND ogb03 = p_ogb03
                  AND ogb31 = g_b2[g_cnt].b_sfb01
           # END IF
          WHEN 'aimt301'
             SELECT ogb12 INTO g_b2[g_cnt].b_e_sets FROM sabap600_temp
              WHERE ogb01 = p_ogb01
                AND ogb03 = p_ogb03
                AND ogb31 = g_b2[g_cnt].b_sfb01
          WHEN 'aimt324'
             SELECT ogb12 INTO g_b2[g_cnt].b_e_sets FROM sabap600_temp
              WHERE ogb01 = p_ogb01
                AND ogb03 = p_ogb03
                AND ogb31 = g_b2[g_cnt].b_sfb01
         #No:DEV-CB0001--mark--begin
         #WHEN 'cimt327'
         #   SELECT ogb12 INTO g_b2[g_cnt].b_e_sets FROM sabap600_temp
         #    WHERE ogb01 = p_ogb01
         #      AND ogb03 = p_ogb03
         #      AND ogb31 = g_b2[g_cnt].b_sfb01
         #No:DEV-CB0001--mark--end
        END CASE
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_b2.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO b_cnt

END FUNCTION

#Page3 外购成品类
FUNCTION p600_c_fill_c()

END FUNCTION

#Page1 屏风类
FUNCTION p600_d_fill_a(p_xilie)
DEFINE p_xilie  LIKE oba_file.oba01

  #No:DEV-CB0001--mark--begin
  #LET g_sql = "SELECT DISTINCT iba00,iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #            "  FROM iba_file,imgb_file,ogb_file ",
  #            " WHERE iba01 = imgb01(+) ",
  #            "   AND iba00 = imgb00(+) ",
  #            "   AND iba04 = '52' ",
  #            "   AND iba14 = ogb31 ",
  #            "   AND ogb01 = '",tm.ogb01,"' ",
  #            "   AND iba11 = '",p_xilie,"' ",
  #            " ORDER BY iba01 "
  #No:DEV-CB0001--mark--end

 #DEV-CC0001---mark---str---
 ##No:DEV-CB0001--add--begin    #條碼, 包號, 倉庫,  儲位,  批號,庫存
 # LET g_sql = "SELECT DISTINCT ibb01,iba05,imgb02,imgb03,imgb04,imgb05 ",
 #             "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01, ",
 #             "       ogb_file ",
 #             " WHERE ibb02 = 'H' ",            #H:訂單包裝單(abai140)
 #             "   AND ibb14 = ogb31 ",          #來源單號
 #             "   AND ogb01 = '",tm.ogb01,"' ", #查詢條件的出貨通知單號
 #             "   AND iba11 = '",p_xilie,"' ",  #傳入的產品分類碼(系列)
 #             " ORDER BY ibb01 "
 ##No:DEV-CB0001--add--end
 #DEV-CC0001---mark---end---
 #DEV-CC0001---add----str---
  #LET g_sql = "SELECT DISTINCT ibb01,iba05,imgb02,imgb03,imgb04,imgb05 ", #DEV-CC0007 mark
   LET g_sql = "SELECT DISTINCT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ", #DEV-CC0007 add
               "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01 ",
               " WHERE ibb02 = 'H' ",            #H:訂單包裝單(abai140)
               "   AND ibb09 = '",p_xilie,"' "   #傳入的產品分類碼(系列)
   IF NOT cl_null(tm.ogb03) THEN
       LET g_sql = g_sql CLIPPED,
          #" AND ibb03 IN SELECT ogb31 FROM ogb_file WHERE ogb01 = '",tm.ogb01,"' AND ogb03 = '",tm.ogb03,"' )"  #來源單號=此張出貨通知單的訂單單號   #DEV-CC0007 mark
           " AND ibb03 IN (SELECT ogb31 FROM ogb_file WHERE ogb01 = '",tm.ogb01,"' AND ogb03 = '",tm.ogb03,"' )"  #來源單號=此張出貨通知單的訂單單號  #DEV-CC0007 add
   ELSE
       LET g_sql = g_sql CLIPPED,
          #" AND ibb03 IN SELECT ogb31 FROM ogb_file WHERE ogb01 = '",tm.ogb01,"' )"  #來源單號=此張出貨通知單的訂單單號             #DEV-CC0007 mark
           " AND ibb03 IN (SELECT ogb31 FROM ogb_file WHERE ogb01 = '",tm.ogb01,"' )"  #來源單號=此張出貨通知單的訂單單號            #DEV-CC0007 add
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY ibb01 "
 #DEV-CC0001---add----end---

   PREPARE d_fill_a FROM g_sql
   DECLARE d_cs_a CURSOR FOR d_fill_a

   CALL g_a3.CLEAR()
   LET g_cnt = 1

   FOREACH d_cs_a INTO g_a3[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#       IF g_imgb[g_cnt].imgb05 - g_sfb[l_ac].sets > 0 THEN   #多
#          LET g_imgb[g_cnt].more = g_imgb[g_cnt].imgb05 - g_sfb[l_ac].sets
#       ELSE IF g_imgb[g_cnt].imgb05 - g_sfb[l_ac].sets < 0 THEN   #少
#               LET g_imgb[g_cnt].less = g_sfb[l_ac].sets - g_imgb[g_cnt].imgb05
#            END IF
#       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_a3.deleteElement(g_cnt)
   LET g_rec_a3 = g_cnt - 1
   DISPLAY g_rec_a3 TO a_cn2

END FUNCTION

#Page2 工单成品类
FUNCTION p600_d_fill_b(p_sfb01,p_inb03,p_ac,p_ogb01,p_ogb03)
   DEFINE p_sfb01  LIKE  sfb_file.sfb01
   DEFINE p_inb03  LIKE  inb_file.inb03
   DEFINE p_ac     LIKE  type_file.num5
   DEFINE p_ogb01  LIKE  ogb_file.ogb01
   DEFINE p_ogb03  LIKE  ogb_file.ogb03
   DEFINE l_m      LIKE  type_file.num5
   DEFINE l_inb05  LIKE  inb_file.inb05
   DEFINE l_inb06  LIKE  inb_file.inb06  #DEV-CC0007 add
   DEFINE l_wh     LIKE  inb_file.inb05  #DEV-CC0007 add
   DEFINE l_loc    LIKE  inb_file.inb06  #DEV-CC0007 add

  #No:DEV-CB0001--mark--begin
  #CASE g_argv3
  #   WHEN 'axmt610'
  #      LET g_sql = "SELECT iba00,iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                  "  FROM iba_file,imgb_file ",
  #                  " WHERE iba01 = imgb01(+) ",
  #                  "   AND iba00 = imgb00(+) ",
  #                  "   AND imgb02 != '",g_sba.sba31,"' ",
  #                  "   AND imgb03 != '",g_sba.sba32,"' ",
  #                  "   AND iba14 = '",p_sfb01,"' ",
  #                  " ORDER BY iba01 "
  #   WHEN 'aimt301'
  #      SELECT inb05 INTO l_inb05 FROM inb_file WHERE inb01 = p_ogb01 AND inb03 = p_ogb03
  #      LET l_m = 0
  #      SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_sfb01
  #      IF l_m > 0 THEN
  #         LET g_sql = "SELECT iba00,iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                     "  FROM iba_file,imgb_file ",
  #                     " WHERE iba01 = imgb01(+) ",
  #                     "   AND iba00 = imgb00(+) ",
  #                     "   AND imgb02 != '",g_sba.sba31,"' ",
  #                     "   AND imgb02 = '",l_inb05,"' ",
  #                     "   AND imgb03 != '",g_sba.sba32,"' ",
  #                     "   AND iba14 = '",p_sfb01,"' ",
  #                     " ORDER BY iba01 "
  #      ELSE
  #         LET g_sql = "SELECT iba00,iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                     "  FROM iba_file,imgb_file ",
  #                     " WHERE iba01 = imgb01(+) ",
  #                     "   AND iba00 = imgb00(+) ",
  #                     "   AND imgb02 != '",g_sba.sba31,"' ",
  #                     "   AND imgb02 = '",l_inb05,"' ",
  #                     "   AND imgb03 != '",g_sba.sba32,"' ",
  #                     "   AND iba14 = '",p_sfb01,"' ",
  #                     "   AND iba15 = '",p_inb03,"' ",
  #                     " ORDER BY iba01 "
  #      END IF
  #   WHEN 'aimt324'
  #      LET l_m = 0
  #      SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_sfb01
  #      IF l_m > 0 THEN
  #         LET g_sql = "SELECT iba00,iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                     "  FROM iba_file,imgb_file ",
  #                     " WHERE iba01 = imgb01(+) ",
  #                     "   AND iba00 = imgb00(+) ",
  #                     "   AND imgb02 != '",g_sba.sba31,"' ",
  #                     "   AND imgb03 != '",g_sba.sba32,"' ",
  #                     "   AND iba14 = '",p_sfb01,"' ",
  #                     " ORDER BY iba01 "
  #      ELSE
  #         LET g_sql = "SELECT iba00,iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                     "  FROM iba_file,imgb_file ",
  #                     " WHERE iba01 = imgb01(+) ",
  #                     "   AND iba00 = imgb00(+) ",
  #                     "   AND imgb02 != '",g_sba.sba31,"' ",
  #                     "   AND imgb03 != '",g_sba.sba32,"' ",
  #                     "   AND iba14 = '",p_sfb01,"' ",
  #                     "   AND iba15 = '",p_inb03,"' ",
  #                     " ORDER BY iba01 "
  #      END IF
  #   WHEN 'cimt327'
  #      LET l_m = 0
  #      SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_sfb01
  #      IF l_m > 0 THEN
  #         LET g_sql = "SELECT iba00,iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                     "  FROM iba_file,imgb_file ",
  #                     " WHERE iba01 = imgb01(+) ",
  #                     "   AND iba00 = imgb00(+) ",
  #                     "   AND imgb02 != '",g_sba.sba31,"' ",
  #                     "   AND imgb03 != '",g_sba.sba32,"' ",
  #                     "   AND iba14 = '",p_sfb01,"' ",
  #                     " ORDER BY iba01 "
  #      ELSE
  #         LET g_sql = "SELECT iba00,iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #                     "  FROM iba_file,imgb_file ",
  #                     " WHERE iba01 = imgb01(+) ",
  #                     "   AND iba00 = imgb00(+) ",
  #                     "   AND imgb02 != '",g_sba.sba31,"' ",
  #                     "   AND imgb03 != '",g_sba.sba32,"' ",
  #                     "   AND iba14 = '",p_sfb01,"' ",
  #                     "   AND iba15 = '",p_inb03,"' ",
  #                     " ORDER BY iba01 "
  #      END IF
  #END CASE
  #No:DEV-CB0001--mark--end
  #No:DEV-CB0001--add--begin
   CASE g_argv3
      WHEN 'axmt610'
         #DEV-CC0007 add---str---
         LET l_wh  = ''
         LET l_loc = ''                                  
         SELECT ogb09,ogb091 INTO l_wh,l_loc 
           FROM ogb_file 
          WHERE ogb01 = p_ogb01 
            AND ogb03 = p_ogb03
         #DEV-CC0007 add---end---

         LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                     "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                     " WHERE ibb03 = '",p_sfb01,"' ",
                     "   AND imgb02 = '",l_wh  ,"' ",       #No:DEV-CC0007 add
                     "   AND imgb03 = '",l_loc ,"' ",       #No:DEV-CC0007 add 
                    #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                    #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                     "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                     "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                     " ORDER BY ibb01 "

      WHEN 'aimt301'
         LET l_inb05 = ''
         LET l_inb06 = ''                                      #DEV-CC0007 add
        #SELECT inb05 INTO l_inb05 FROM inb_file               #DEV-CC0007 mark
         SELECT inb05,inb06 INTO l_inb05,l_inb06 FROM inb_file #DEV-CC0007 add inb06
          WHERE inb01 = p_ogb01 AND inb03 = p_ogb03
         LET l_m = 0
         SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_sfb01
         IF l_m > 0 THEN
            LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                        "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                        " WHERE imgb02 = '",l_inb05,"' ",
                        "   AND imgb03 = '",l_inb06,"' ",      #No:DEV-CC0007 add 
                       #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                       #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                       "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                       "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                        "   AND ibb03 = '",p_sfb01,"' ",
                        " ORDER BY ibb01 "
         ELSE
            LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                        "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                        " WHERE imgb02 = '",l_inb05,"' ",
                        "   AND imgb03 = '",l_inb06,"' ",      #No:DEV-CC0007 add 
                       #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                       #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                        "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                        "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                        "   AND ibb03 = '",p_sfb01,"' ",
                        "   AND ibb04 = '",p_inb03,"' ",
                        " ORDER BY ibb01 "
         END IF

      WHEN 'aimt324'
         #DEV-CC0007 add---str---
         LET l_wh  = ''
         LET l_loc = ''                                  
         SELECT imn04,imn05 INTO l_wh,l_loc 
           FROM imn_file 
          WHERE imn01 = p_ogb01 
            AND imn02 = p_ogb03
         #DEV-CC0007 add---end---
         LET l_m = 0
         SELECT COUNT(*) INTO l_m FROM sfb_file WHERE sfb01 = p_sfb01
         IF l_m > 0 THEN
            LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                        "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                        " WHERE ibb03 = '",p_sfb01,"' ",
                        "   AND imgb02 = '",l_wh  ,"' ",       #No:DEV-CC0007 add
                        "   AND imgb03 = '",l_loc ,"' ",       #No:DEV-CC0007 add 
                       #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                       #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                        "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                        "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                        " ORDER BY ibb01 "
         ELSE
            LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
                        "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
                        " WHERE ibb03 = '",p_sfb01,"' ",
                        "   AND ibb04 = '",p_inb03,"' ",
                       #"   AND imgb02 != '",g_sba.sba31,"' ", #No:DEV-CB0008--mark
                       #"   AND imgb03 != '",g_sba.sba32,"' ", #No:DEV-CB0008--mark
                        "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
                        "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
                        " ORDER BY ibb01 "
         END IF
   END CASE
  #No:DEV-CB0001--add--end

   PREPARE d_fill_b FROM g_sql
   DECLARE d_cs_b CURSOR FOR d_fill_b

   CALL g_b3.clear()
   LET g_cnt = 1

   FOREACH d_cs_b INTO g_b3[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #No:DEV-CB0001--mark--begin
      #IF g_b3[g_cnt].b_imgb05 - g_b2[p_ac].b_sets > 0 THEN   #多
      #   LET g_b3[g_cnt].b_more = g_b3[g_cnt].b_imgb05 - g_b2[p_ac].b_sets
      #ELSE IF g_b3[g_cnt].b_imgb05 - g_b2[p_ac].b_sets < 0 THEN   #少
      #        LET g_b3[g_cnt].b_less = g_b2[p_ac].b_sets - g_b3[g_cnt].b_imgb05
      #     END IF
      #END IF
      #No:DEV-CB0001--mark--end
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_b3.deleteElement(g_cnt)
   LET g_rec_b3 = g_cnt - 1
   DISPLAY g_rec_b3 TO b_cn2
END FUNCTION

#Page3 外购成品类
FUNCTION p600_d_fill_c(p_ima01,p_ac)
DEFINE p_ima01  LIKE ima_file.ima01
DEFINE p_ac     LIKE type_file.num5

  #No:DEV-CB0001--mark--begin
  #LET g_sql = "SELECT iba00,iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #            "  FROM iba_file,imgb_file ",
  #            " WHERE iba01 = imgb01 ",
  #            "   AND iba00 = imgb00 ",
  #            "   AND imgb02 != '",g_sba.sba31,"' ",
  #            "   AND imgb03 != '",g_sba.sba32,"' ",
  #            "   AND iba09 = '",p_ima01,"' ",
  #            " ORDER BY iba01 "
  #No:DEV-CB0001--mark--end
  #No:DEV-CB0001--add--begin
   LET g_sql = "SELECT UNIQUE ibb01,ibb05,imgb02,imgb03,imgb04,imgb05 ",
               "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01  ",
               " WHERE ibb06 = '",p_ima01,"' ",
               "   AND ibb02 IN ('F','G') ",   #條碼產生時機點'F':採購單 'G':G:委外採購單
               "   AND NOT(imgb02 = '",g_ibd.ibd03,"' ",      #No:DEV-CB0008--add
               "           AND imgb03 = '",g_ibd.ibd04,"') ", #No:DEV-CB0008--add
               " ORDER BY ibb01 "
  #No:DEV-CB0001--add--end

   PREPARE d_fill_c FROM g_sql
   DECLARE d_cs_c CURSOR FOR d_fill_c

   CALL g_c2.clear()
   LET g_cnt = 1

   FOREACH d_cs_c INTO g_c2[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #No:DEV-CB0001--mark--begin
      #IF g_c2[g_cnt].c_imgb05 - g_c1[p_ac].c_ogb12 > 0 THEN   #多
      #   LET g_c2[g_cnt].c_more = g_c2[g_cnt].c_imgb05 - g_c1[p_ac].c_ogb12
      #ELSE IF g_c2[g_cnt].c_imgb05 - g_c1[p_ac].c_ogb12 < 0 THEN   #少
      #        LET g_c2[g_cnt].c_less = g_c1[p_ac].c_ogb12 - g_c2[g_cnt].c_imgb05
      #     END IF
      #END IF
      #No:DEV-CB0001--mark--end
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_c2.deleteElement(g_cnt)
   LET g_rec_c2 = g_cnt - 1
   DISPLAY g_rec_c2 TO c_cnt


END FUNCTION


FUNCTION p600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_sql  STRING

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_a1 TO s_a1.* ATTRIBUTE(COUNT=g_rec_a)
          BEFORE DISPLAY
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_current_row = "s_a1"

          BEFORE ROW
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
                CALL p600_c_fill_a(g_a1[l_ac].a_oba01)
                CALL p600_d_fill_a(g_a1[l_ac].a_oba01)
             END IF
      END DISPLAY

      DISPLAY ARRAY g_a2 TO s_a2.* ATTRIBUTE(COUNT=g_rec_a2)
         BEFORE DISPLAY
            CALL fgl_set_arr_curr(1)
            LET g_current_row = "s_a1"

         BEFORE ROW

       END DISPLAY

       DISPLAY ARRAY g_a3 TO s_a3.* ATTRIBUTE(COUNT=g_rec_a3)
          BEFORE DISPLAY
             CALL fgl_set_arr_curr(1)
             LET g_current_row = "s_a1"

          BEFORE ROW

       END DISPLAY

      DISPLAY ARRAY g_b1 TO s_b1.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY
            IF l_bc > 0 THEN
               CALL fgl_set_arr_curr(l_bc)
            END IF
            LET g_current_row = "s_b1"

          BEFORE ROW
             LET l_bc  = ARR_CURR()
             IF l_bc  > 0 THEN
                CALL p600_c_fill_b(g_b1[l_bc].b_ogb01,g_b1[l_bc].b_ogb03,g_b1[l_bc].b_ogb04,g_b1[l_bc].b_anku)
                IF g_rec_b2 >0 THEN
                   CALL p600_d_fill_b(g_b2[1].b_sfb01,g_b2[1].b_inb03,1,g_b1[1].b_ogb01,g_b1[1].b_ogb03)
                END IF
                CALL ui.Interface.refresh()
             END IF
      END DISPLAY


      DISPLAY ARRAY g_b2 TO s_b2.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL fgl_set_arr_curr(1)
            LET g_current_row = "s_b1"

         BEFORE ROW
            LET l_bc2= ARR_CURR()
            IF l_bc2 > 0 THEN
               CALL p600_d_fill_b(g_b2[l_bc2].b_sfb01,g_b2[l_bc2].b_inb03,l_bc2,g_b1[l_bc].b_ogb01,g_b1[l_bc].b_ogb03)
               CALL ui.Interface.refresh()
            END IF

       END DISPLAY

       DISPLAY ARRAY g_b3 TO s_b3.* ATTRIBUTE(COUNT=g_rec_b3)
          BEFORE DISPLAY
             CALL fgl_set_arr_curr(1)
             LET g_current_row = "s_b1"

          BEFORE ROW

       END DISPLAY

       DISPLAY ARRAY g_c1 TO s_c1.* ATTRIBUTE(COUNT=g_rec_c)
          BEFORE DISPLAY
            IF l_cc > 0 THEN
               CALL fgl_set_arr_curr(l_cc)
            END IF
            LET g_current_row = "s_c1"

          BEFORE ROW
             LET l_cc = ARR_CURR()
             IF l_cc  > 0 THEN
                CALL p600_d_fill_c(g_c1[l_cc].c_ogb04,l_cc)
                CALL ui.Interface.refresh()
             END IF
      END DISPLAY

      DISPLAY ARRAY g_c2 TO s_c2.* ATTRIBUTE(COUNT=g_rec_c2)
         BEFORE DISPLAY
            CALL fgl_set_arr_curr(1)
            LET g_current_row = "s_c1"

         BEFORE ROW
            LET l_cc2= ARR_CURR()
            IF l_cc2 > 0 THEN
            END IF

       END DISPLAY

      BEFORE DIALOG
         IF cl_null(g_current_row) THEN
            IF g_rec_a > 0 THEN
               LET g_current_row = "s_a1"
               NEXT FIELD a_oba01
            ELSE IF g_rec_b > 0 THEN
            	       LET g_current_row = "s_b1"
                       NEXT FIELD b_ogb01
            	    ELSE IF g_rec_c > 0 THEN
            	    	      LET g_current_row = "s_c1"
                              NEXT FIELD c_ogb01
            	    	   ELSE
            	    	      LET g_current_row = "s_a1"
                              NEXT FIELD a_oba01
            	    	   END IF
            	    END IF
            END IF
         ELSE
         	  CASE g_current_row
         	     WHEN "s_a1"
         	        NEXT FIELD a_oba01
         	     WHEN "s_b1"
         	        NEXT FIELD b_ogb01
         	     WHEN "s_c1"
         	        NEXT FIELD c_ogb01
         	     OTHERWISE
         	        NEXT FIELD a_oba01
            END CASE
         END IF
        #CALL dialog.setCurrentRow(g_current_row,1)


     ON ACTION query
        LET g_action_choice="query"
        EXIT DIALOG

#      ON ACTION detail
#         LET g_action_choice="detail"
#         EXIT DIALOG

     #ON ACTION accept
     #   LET g_action_choice="detail"
     #   LET l_ac= ARR_CURR()
     #   EXIT DIALOG

      ON action accept_a
         LET g_action_choice="accept_a"
         LET l_ac = ARR_CURR()
         EXIT dialog

      ON action accept_b
         LET g_action_choice="accept_b"
         LET l_bc2 = ARR_CURR()
         EXIT dialog

      ON action accept_c
         LET g_action_choice="accept_c"
         LET l_cc = ARR_CURR()
         EXIT dialog

      ON action pg1
         LET g_current_row = "s_a1"
         CONTINUE DIALOG

      ON action pg2
         LET g_current_row = "s_b1"
         CONTINUE DIALOG

      ON action pg3
         LET g_current_row = "s_c1"
         CONTINUE DIALOG

      ON ACTION gen_box
         LET g_action_choice="gen_box"
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
   CALL cl_set_act_visible("accept,cancel,close", TRUE)
END FUNCTION


FUNCTION p600_b_a()
DEFINE
    p_style         LIKE type_file.chr1,
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    l_gen02         LIKE gen_file.gen02,
    l_sql           STRING,
    p_cmd           LIKE type_file.chr1,
    l_buf           LIKE imd_file.imd02,
    l_result        BOOLEAN ,
    l_idx           LIKE type_file.num5,
    l_oea01         LIKE oea_file.oea01

    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF

    IF g_rec_a = 0 THEN RETURN END IF
    CALL cl_opmsg('b')

    INPUT ARRAY g_a1 WITHOUT DEFAULTS FROM s_a1.*
              ATTRIBUTE (COUNT=g_rec_a,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW =FALSE ,
              DELETE ROW=FALSE,APPEND ROW=FALSE)

      BEFORE INPUT
            IF g_rec_a != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

      BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'
            LET g_success = 'Y'
            LET g_a1_t.* = g_a1[l_ac].*
            CALL p600_set_entry_a()
            CALL p600_set_no_entry_a()
            IF g_rec_a>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_a1_t.* = g_a1[l_ac].*
               CALL p600_c_fill_a(g_a1[l_ac].a_oba01)
               CALL p600_d_fill_a(g_a1[l_ac].a_oba01)
               CALL p600_a_refresh()
               CALL cl_show_fld_cont()
            END IF

        AFTER FIELD a_chuhuo
           #勾选上时要决断这个系列已经齐套出。
           #这个地方由 出货通知单审核时保证，这里不再做检查
           IF g_a1[l_ac].a_chuhuo = 'Y' THEN
              SELECT DISTINCT ogb31 INTO l_oea01 FROM ogb_file,ima_file
               WHERE ogb01 = tm.ogb01
                 AND ima01 = ogb04
                 AND ima131 = g_a1[l_ac].a_oba01
              CALL p600_chk_qitao(l_oea01,g_a1[l_ac].a_oba01) RETURNING l_result,l_idx
              IF NOT l_result THEN
                 CALL cl_err(l_idx,'aba-027',0)
                 LET g_a1[l_ac].a_chuhuo = g_a1_t.a_chuhuo
                 NEXT FIELD a_chuhuo
              END IF
           END IF

        BEFORE INSERT


        AFTER INSERT
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF g_a1[l_ac].a_oba01 IS NULL THEN
               CANCEL INSERT
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_a1[l_ac].* = g_a1_t.*
              ROLLBACK WORK
              CONTINUE INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err('',-263,0)
               LET g_a1[l_ac].* =g_a1_t.*
           ELSE
             # UPDATE sfb_file SET sfb05 = g_sfb[l_ac].sfb05,
             #                     sfb06 = g_sfb[l_ac].sfb06,
             #                     sfb07 = g_sfb[l_ac].sfb07
             # WHERE sfb01 = tm.sfb01
             #   AND sfb03 = g_sfb[l_ac].sfb03
             #  MESSAGE 'UPDATE O.K'
                COMMIT WORK
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_a1[l_ac].* = g_a1_t.*
              END IF
              ROLLBACK WORK
              EXIT INPUT
           END IF
           COMMIT WORK

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


FUNCTION p600_b_b()
DEFINE
    p_style         LIKE type_file.chr1,
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    l_iba        RECORD LIKE iba_file.*,
    l_imgb          RECORD LIKE imgb_file.*,
    l_gen02         LIKE gen_file.gen02,
    l_sql           STRING,
    p_cmd           LIKE type_file.chr1,
    l_buf           LIKE imd_file.imd02,
    l_sfb01         LIKE sfb_file.sfb01

    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF

    IF g_rec_b2 = 0 THEN RETURN END IF

#    CASE g_argv3
#     WHEN 'axmt610'
#       IF g_b1[l_bc].b_anku = 'N' THEN
#          CALL cl_err('','aba-013',1)
#          RETURN
#       END IF
#    END CASE

    CALL cl_opmsg('b')

#    LET g_forupd_sql = "SELECT sfb01 ",
#                       "  FROM sfb_file",
#                       " WHERE sfb01 = ? ",
#                       "   FOR UPDATE"
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE p600_bcl CURSOR FROM g_forupd_sql

    INPUT ARRAY g_b2 WITHOUT DEFAULTS FROM s_b2.*
              ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW =FALSE ,
              DELETE ROW=FALSE,APPEND ROW=FALSE)

      BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_bc2)
            END IF

      BEFORE ROW
            LET p_cmd = ''
            LET l_bc2 = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'
            LET g_success = 'Y'
            LET g_b2_t.* = g_b2[l_bc2].*
            CALL p600_set_entry_b()
            CALL p600_set_no_entry_b()
            IF g_rec_b2>=l_bc2 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_b2_t.* = g_b2[l_bc2].*
#               OPEN p600_bcl USING  g_b2[l_bc2].b_sfb01
#               IF STATUS THEN
#                  CALL cl_err("OPEN p600_bcl:", STATUS, 1)
#                  LET l_lock_sw = "Y"
#               ELSE
#                  FETCH p600_bcl INTO l_sfb01
#                  IF SQLCA.sqlcode THEN
#                     CALL cl_err('',SQLCA.sqlcode,1)
#                     LET l_lock_sw = "Y"
#                  END IF
#               END IF
               CALL cl_show_fld_cont()
            END IF

        AFTER FIELD b_e_sets
           IF NOT cl_null(g_b2[l_bc2].b_e_sets) THEN
              IF g_b2[l_bc2].b_e_sets > g_b2[l_bc2].b_sets THEN
                 CALL cl_err('','aba-016',0)
                 LET g_b2[l_bc2].b_e_sets = g_b2_t.b_e_sets
                 NEXT FIELD b_e_sets
              END IF
           END IF

        BEFORE INSERT


        AFTER INSERT
            LET l_bc2 = ARR_CURR()
            LET l_ac_t = l_bc2
            IF g_b2[l_bc2].b_sfb01 IS NULL THEN
               CANCEL INSERT
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_b2[l_bc2].* = g_b2_t.*
              #CLOSE p600_bcl
              ROLLBACK WORK
              CONTINUE INPUT
           END IF
           SELECT COUNT(*) INTO l_n FROM sabap600_temp
            WHERE ogb01 = g_b1[l_bc].b_ogb01
              AND ogb03 = g_b1[l_bc].b_ogb03
              AND ogb31 = g_b2[l_bc2].b_sfb01
           IF l_n = 0 THEN
              INSERT INTO sabap600_temp VALUES(
                g_b1[l_bc].b_ogb01,g_b1[l_bc].b_ogb03,
                g_b2[l_bc2].b_sfb01,g_b2[l_bc2].b_e_sets)
           ELSE
              UPDATE sabap600_temp SET ogb12 = g_b2[l_bc2].b_e_sets
               WHERE ogb01 = g_b1[l_bc].b_ogb01
                 AND ogb03 = g_b1[l_bc].b_ogb03
                 AND ogb31 = g_b2[l_bc2].b_sfb01
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err('',-263,0)
               LET g_b2[l_bc2].* =g_b2_t.*
           ELSE
             # UPDATE sfb_file SET sfb05 = g_sfb[l_ac].sfb05,
             #                     sfb06 = g_sfb[l_ac].sfb06,
             #                     sfb07 = g_sfb[l_ac].sfb07
             # WHERE sfb01 = tm.sfb01
             #   AND sfb03 = g_sfb[l_ac].sfb03
             #  MESSAGE 'UPDATE O.K'
                COMMIT WORK
           END IF

        AFTER ROW
           LET l_bc2 = ARR_CURR()
           LET l_ac_t = l_bc2
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_b2[l_bc2].* = g_b2_t.*
              END IF
              #CLOSE p600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #CLOSE p600_bcl
           COMMIT WORK

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

FUNCTION p600_b_c()
DEFINE
    p_style         LIKE type_file.chr1,
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    l_iba           RECORD LIKE iba_file.*,
    l_imgb          RECORD LIKE imgb_file.*,
    l_gen02         LIKE gen_file.gen02,
    l_sql           STRING,
    p_cmd           LIKE type_file.chr1,
    l_buf           LIKE imd_file.imd02,
    l_imgb05        LIKE imgb_file.imgb05

    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF

    IF g_rec_c = 0 THEN RETURN END IF
    CALL cl_opmsg('b')

    INPUT ARRAY g_c1 WITHOUT DEFAULTS FROM s_c1.*
              ATTRIBUTE (COUNT=g_rec_c,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW =FALSE ,
              DELETE ROW=FALSE,APPEND ROW=FALSE)

      BEFORE INPUT
            IF g_rec_c != 0 THEN
               CALL fgl_set_arr_curr(l_cc)
            END IF

      BEFORE ROW
            LET p_cmd = ''
            LET l_cc = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'
            LET g_success = 'Y'
            LET g_c1_t.* = g_c1[l_cc].*
            CALL p600_set_entry_c()
            CALL p600_set_no_entry_c()
            IF g_rec_c>=l_cc THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_c1_t.* = g_c1[l_cc].*
               CALL cl_show_fld_cont()
            END IF

        AFTER FIELD c_choose
           IF NOT cl_null(g_c1[l_cc].c_choose) THEN
              IF g_rec_c2 > 0 THEN
                 LET l_imgb05 = 0
                 FOR g_cnt = 1 TO g_rec_c2
                    IF cl_null(g_c2[g_cnt].c_imgb05) THEN LET g_c2[g_cnt].c_imgb05 = 0 END IF
                    LET l_imgb05 = l_imgb05 + g_c2[g_cnt].c_imgb05
                 END FOR
              END IF
              IF g_c1[l_cc].c_choose > l_imgb05 THEN
                 CALL cl_err('','aba-026',0)
                 NEXT FIELD c_choose
              END IF


           END IF

        BEFORE INSERT


        AFTER INSERT
            LET l_cc = ARR_CURR()
            LET l_ac_t = l_cc
            IF g_c1[l_cc].c_ogb01 IS NULL THEN
               CANCEL INSERT
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_c1[l_cc].* = g_c1_t.*
              ROLLBACK WORK
              CONTINUE INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err('',-263,0)
               LET g_c1[l_cc].* =g_c1_t.*
           ELSE
                COMMIT WORK
           END IF

        AFTER ROW
           LET l_cc = ARR_CURR()
           LET l_ac_t = l_cc
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_c1[l_cc].* = g_c1_t.*
              END IF
              ROLLBACK WORK
              EXIT INPUT
           END IF
           COMMIT WORK

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

FUNCTION p600_set_entry_a()
    CALL cl_set_comp_entry("a_chuhuo",TRUE)
END FUNCTION

FUNCTION p600_set_no_entry_a()
    CALL cl_set_comp_entry("a_oba01,a_oba02",FALSE)
END FUNCTION

FUNCTION p600_set_entry_b()
    CALL cl_set_comp_entry("b_e_sets",TRUE)
END FUNCTION

FUNCTION p600_set_no_entry_b()
    CALL cl_set_comp_entry("b_sfb01,b_e_date,b_sfb04,b_sfb08,b_sfb09,b_sets",FALSE)
END FUNCTION

FUNCTION p600_set_entry_c()
    CALL cl_set_comp_entry("c_choose",TRUE)
END FUNCTION

FUNCTION p600_set_no_entry_c()
    CALL cl_set_comp_entry("c_ogb01,c_ogb03,c_ogb04,c_ima02,c_ima021,c_ogb12,",FALSE)
END FUNCTION


#生成装箱单底稿
FUNCTION p600_gen_box()
DEFINE l_cmd  LIKE type_file.chr1000

   LET g_success = 'Y'
   CALL p600_box_chk()
   IF g_success = 'N' THEN RETURN END IF
   IF NOT cl_confirm('abx-080') THEN RETURN END IF
   ##--生成配货单底稿(box_file)

   BEGIN WORK

# ##先删掉原来配货单，再重新生成
#   DELETE FROM box_file WHERE box01 = tm.ogb01
#      IF SQLCA.SQLCODE  THEN
#         CALL s_errmsg('box01',tm.ogb01,'del box',SQLCA.SQLCODE,1)
#         LET g_success = 'N'
#      END IF
#   DELETE FROM boxb_file WHERE boxb01 = tm.ogb01
#      IF SQLCA.SQLCODE  THEN
#         CALL s_errmsg('boxb01',tm.ogb01,'del boxb',SQLCA.SQLCODE,1)
#         LET g_success = 'N'
#      END IF

   LET g_ins_box = 'N' #DEV-CC0001 add
   CALL p600_gen_box1()
   IF g_success = 'Y' THEN
      CALL p600_gen_box2()
   END IF
   IF g_success = 'Y' THEN
      CALL p600_gen_box3()
   END IF

   IF g_success = 'Y' THEN
     #CALL cl_err('','aba-017',1) #DEV-CC0001 mark
     #DEV-CC0001 add---str---
      IF g_ins_box = 'Y' THEN 
          CALL cl_err(tm.ogb01,'aba-017',1)
      END IF
     #DEV-CC0001 add---str---
      COMMIT WORK
      CASE g_argv3
        WHEN 'aimt301'
           LET l_cmd = "abat301 '",tm.ogb01,"' "
           CALL cl_cmdrun(l_cmd)
        WHEN 'aimt324'
           LET l_cmd = "abat324 '",tm.ogb01,"' "
           CALL cl_cmdrun(l_cmd)
       #No:DEV-CB0001--mark--begin
       #WHEN 'cimt327'
       #   LET l_cmd = "abat327 '",tm.ogb01,"' "
       #   CALL cl_cmdrun(l_cmd)
       #No:DEV-CB0001--mark--end
        WHEN 'axmt610'
           LET l_cmd = "abat610 '",tm.ogb01,"' "
           CALL cl_cmdrun(l_cmd)
      END CASE
   END IF
   IF g_success = 'N' THEN
      MESSAGE "生成失败!"
      ROLLBACK WORK
   END IF

END FUNCTION


#生成屏风类的配货单
FUNCTION p600_gen_box1()
DEFINE l_box  RECORD LIKE box_file.*
DEFINE l_boxb RECORD LIKE boxb_file.*
DEFINE l_idx     LIKE type_file.num5
DEFINE l_idx2    LIKE type_file.num5
DEFINE l_idx3    LIKE type_file.num5
DEFINE l_box03 LIKE type_file.num5

   IF g_rec_a = 0 THEN RETURN  END IF
   FOR l_idx = 1 TO g_rec_a
      IF g_a1[l_idx].a_chuhuo = 'N' THEN
         CONTINUE FOR
      END IF
      CALL p600_c_fill_a(g_a1[l_idx].a_oba01)
      CALL p600_d_fill_a(g_a1[l_idx].a_oba01)

      FOR l_idx2 = 1 TO g_rec_a2
         INITIALIZE l_box.* TO NULL
         SELECT MAX(box03) INTO l_box03 FROM box_file
          WHERE box01 = g_a2[l_idx2].a_ogb01
            AND box02 = g_a2[l_idx2].a_ogb03
         IF cl_null(l_box03) THEN LET l_box03 = 0 END IF

         LET l_box.box01 = g_a2[l_idx2].a_ogb01
         LET l_box.box02 = g_a2[l_idx2].a_ogb03
         LET l_box.box03 = l_box03 +1
         LET l_box.box04 = g_a2[l_idx2].a_ogb04
         LET l_box.box05 = g_a2[l_idx2].a_ogb12
         LET l_box.box06 = g_a2[l_idx2].a_ogb12
         LET l_box.box07 = g_a2[l_idx2].a_ogb12
        #LET l_box.box11 = '52' #No:DEV-CB0001--mark
         LET l_box.box11 = '1'  #No:DEV-CB0001--add
         LET l_box.box12 = g_a1[l_idx].a_oba01
         LET l_box.boxplant = g_plant
         LET l_box.boxlegal = g_legal
         LET l_box.boxuser= g_user
         LET l_box.boxgrup= g_grup
         LET l_box.boxoriu = g_user
         LET l_box.boxorig = g_grup
         LET l_box.boxacti = 'Y'
         LET l_box.box14 = g_argv3
         #DEV-CC0007---add----str---
         #=>抓工單單號
         LET l_box.box09 = NULL
         SELECT sfb01 
           INTO l_box.box09
           FROM sfb_file,oga_file
          WHERE sfb22 = oga16 #訂單單號
            AND oga01 = g_a2[l_idx2].a_ogb01 #出通單號
            AND sfb05 = g_a2[l_idx2].a_ogb04 #料號

         #=>抓入庫日期
         LET l_box.box10 = NULL
         SELECT sfu02
          INTO l_box.box10
          FROM sfu_file,sfv_file
         WHERE sfu01 = sfv01
           AND sfv11 = l_box.box09
           AND sfupost = 'Y'
         #DEV-CC0007---add----end---
         INSERT INTO box_file VALUES(l_box.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('box03',l_box.box03,'ins 屏风配货单',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
      END FOR
      FOR l_idx3 = 1 TO g_rec_a3
          INITIALIZE l_boxb.* TO NULL
          LET l_boxb.boxb01 = tm.ogb01
         #LET l_boxb.boxb02 = 0           #DEV-CC0007 mark
         #LET l_boxb.boxb03 = 0           #DEV-CC0007 mark
          LET l_boxb.boxb02 = l_box.box02 #DEV-CC0007 add
          LET l_boxb.boxb03 = l_box.box03 #DEV-CC0007 add
         #LET l_boxb.boxb04 = g_a3[l_idx3].a_imgb00 #No:DEV-CB0001--mark
          LET l_boxb.boxb05 = g_a3[l_idx3].a_imgb01
          LET l_boxb.boxb06 = g_a3[l_idx3].a_imgb02
          LET l_boxb.boxb07 = g_a3[l_idx3].a_imgb03
          LET l_boxb.boxb08 = g_a3[l_idx3].a_imgb04
          LET l_boxb.boxb09 = g_a3[l_idx3].a_imgb05
          LET l_boxb.boxbplant = g_plant
          LET l_boxb.boxblegal = g_legal
          INSERT INTO boxb_file VALUES(l_boxb.*)
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL s_errmsg('boxb01',l_boxb.boxb03,'ins 屏风配货单子档',SQLCA.SQLCODE,1)
             LET g_success = 'N'
          ELSE
             LET g_ins_box = 'Y' #DEV-CC0001 add
          END IF
      END FOR

   END FOR

END FUNCTION


#生成工单成品类的配货单

FUNCTION p600_gen_box2()
DEFINE l_idx   LIKE type_file.num5
DEFINE l_idx2  LIKE type_file.num5
DEFINE l_idx3  LIKE type_file.num5
DEFINE l_box  RECORD LIKE box_file.*
DEFINE l_boxb RECORD LIKE boxb_file.*
DEFINE l_box03 LIKE type_file.num5
DEFINE l_inb05   LIKE inb_file.inb05


   FOR l_idx = 1 TO g_rec_b
      INITIALIZE l_box.* TO NULL
      CALL p600_c_fill_b(g_b1[l_idx].b_ogb01,g_b1[l_idx].b_ogb03,g_b1[l_idx].b_ogb04,g_b1[l_idx].b_anku)

      LET l_box.box01 = g_b1[l_idx].b_ogb01
      LET l_box.box02 = g_b1[l_idx].b_ogb03
      LET l_box.box04 = g_b1[l_idx].b_ogb04
      LET l_box.box05 = g_b1[l_idx].b_ogb12
      LET l_box.box06 = g_b1[l_idx].b_ogb12
      LET l_box.box08 = g_b1[l_idx].b_anku
     #LET l_box.box11 = '50' #No:DEV-CB0001--mark
      LET l_box.box11 = '2'  #No:DEV-CB0001--add
      LET l_box.boxplant = g_plant
      LET l_box.boxlegal = g_legal
      LET l_box.boxuser= g_user
      LET l_box.boxgrup= g_grup
      LET l_box.boxoriu = g_user
      LET l_box.boxorig = g_grup
      LET l_box.boxacti = 'Y'
      LET l_box.box14 = g_argv3
      FOR l_idx2 = 1 TO g_rec_b2
         CALL p600_d_fill_b(g_b2[l_idx2].b_sfb01,g_b2[l_idx2].b_inb03,l_idx2,g_b1[l_idx].b_ogb01,g_b1[l_idx].b_ogb03)
         IF cl_null(g_b2[l_idx2].b_e_sets) OR
             g_b2[l_idx2].b_e_sets =0 THEN
             CONTINUE FOR
         END IF
         SELECT MAX(box03) INTO l_box03 FROM box_file
          WHERE box01 = g_b1[l_idx].b_ogb01
            AND box02 = g_b1[l_idx].b_ogb03
         IF cl_null(l_box03) THEN LET l_box03 = 0 END IF
         LET l_box.box03 = l_box03 + 1
         LET l_box.box07 = g_b2[l_idx2].b_e_sets
         LET l_box.box09 = g_b2[l_idx2].b_sfb01
         LET l_box.box10 = g_b2[l_idx2].b_e_date
         INSERT INTO box_file VALUES(l_box.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('box03',l_box.box03,'ins 工单成品配货单',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
         FOR l_idx3 = 1 TO g_rec_b3
            INITIALIZE l_boxb.* TO NULL
            LET l_boxb.boxb01 = tm.ogb01
            LET l_boxb.boxb02 = l_box.box02
            LET l_boxb.boxb03 = l_box.box03
           #LET l_boxb.boxb04 = g_b3[l_idx3].b_imgb00 #No:DEV-CB0001--mark
            LET l_boxb.boxb05 = g_b3[l_idx3].b_imgb01
            SELECT inb05 INTO l_inb05 FROM inb_file WHERE inb01 = l_box.box01 AND inb03 = l_box.box02
            IF g_b3[l_idx3].b_imgb02 != l_inb05 THEN
            	 CONTINUE FOR
            END IF
            LET l_boxb.boxb06 = g_b3[l_idx3].b_imgb02
            LET l_boxb.boxb07 = g_b3[l_idx3].b_imgb03
            LET l_boxb.boxb08 = g_b3[l_idx3].b_imgb04
            LET l_boxb.boxb09 = g_b3[l_idx3].b_imgb05
            LET l_boxb.boxbplant = g_plant
            LET l_boxb.boxblegal = g_legal
            INSERT INTO boxb_file VALUES(l_boxb.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL s_errmsg('boxb01',l_boxb.boxb03,'ins  工单成品配货单子档',SQLCA.SQLCODE,1)
             LET g_success = 'N'
            ELSE
             LET g_ins_box = 'Y' #DEV-CC0001 add
            END IF
         END FOR
      END FOR
   END FOR

END FUNCTION


#生成外购成品的配货单
FUNCTION p600_gen_box3()
DEFINE l_idx  LIKE type_file.num5
DEFINE l_idx2 LIKE type_file.num5
DEFINE l_box  RECORD LIKE box_file.*
DEFINE l_boxb RECORD LIKE boxb_file.*
DEFINE l_box03 LIKE type_file.num5

   FOR l_idx = 1 TO g_rec_c
      IF g_c1[l_idx].c_choose > 0 THEN
         INITIALIZE l_box.* TO NULL
         CALL p600_d_fill_c(g_c1[l_idx].c_ogb04,l_idx)

         IF cl_null(g_c1[l_idx].c_choose) OR
            g_c1[l_idx].c_choose = 0 THEN
            CONTINUE FOR
         END IF
         SELECT MAX(box03) INTO l_box03 FROM box_file
          WHERE box01 = g_c1[l_idx].c_ogb01
            AND box02 = g_c1[l_idx].c_ogb03
         IF cl_null(l_box03) THEN LET l_box03 = 0 END IF
         LET l_box03 = l_box03 + 1

         LET l_box.box01 = g_c1[l_idx].c_ogb01
         LET l_box.box02 = g_c1[l_idx].c_ogb03
         LET l_box.box03 = l_box03
         LET l_box.box04 = g_c1[l_idx].c_ogb04
         LET l_box.box05 = g_c1[l_idx].c_ogb12
         LET l_box.box06 = g_c1[l_idx].c_choose
         LET l_box.box07 = g_c1[l_idx].c_choose
        #LET l_box.box11 = '10' #No:DEV-CB0001--mark
         LET l_box.box11 = '3'  #No:DEV-CB0001--add
         LET l_box.boxplant = g_plant
         LET l_box.boxlegal = g_legal
         LET l_box.boxuser= g_user
         LET l_box.boxgrup= g_grup
         LET l_box.boxoriu = g_user
         LET l_box.boxorig = g_grup
         LET l_box.boxacti = 'Y'
         LET l_box.box14 = g_argv3
         INSERT INTO box_file VALUES(l_box.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('box03',l_box.box03,'ins 外购成品配货单',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
         FOR l_idx2 = 1 TO g_rec_c2
            INITIALIZE l_boxb.* TO NULL
            LET l_boxb.boxb01 = tm.ogb01
            LET l_boxb.boxb02 = l_box.box02
            LET l_boxb.boxb03 = l_box.box03
           #LET l_boxb.boxb04 = g_c2[l_idx2].c_imgb00 #No:DEV-CB0001--mark
            LET l_boxb.boxb05 = g_c2[l_idx2].c_imgb01
            LET l_boxb.boxb06 = g_c2[l_idx2].c_imgb02
            LET l_boxb.boxb07 = g_c2[l_idx2].c_imgb03
            LET l_boxb.boxb08 = g_c2[l_idx2].c_imgb04
            LET l_boxb.boxb09 = g_c2[l_idx2].c_imgb05
            LET l_boxb.boxbplant = g_plant
            LET l_boxb.boxblegal = g_legal
            INSERT INTO boxb_file VALUES(l_boxb.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL s_errmsg('boxb01',l_boxb.boxb03,'ins 外购成品配货单子档',SQLCA.SQLCODE,1)
             LET g_success = 'N'
            ELSE
             LET g_ins_box = 'Y' #DEV-CC0001 add
            END IF
         END FOR
      END IF
   END FOR

END FUNCTION



#检查配货单底稿数量合计是否合理
FUNCTION p600_box_chk()
DEFINE s_sum  LIKE  sfb_file.sfb08

#   LET s_sum = 0
#   FOR g_cnt = 1 TO g_rec_b
#       IF cl_null(g_sfb[g_cnt].e_sets) THEN
#          LET g_sfb[g_cnt].e_sets = 0
#       END IF
#       LET s_sum = s_sum + g_sfb[g_cnt].e_sets
#   END FOR
#   IF s_sum > g_ogb.ogb12 THEN
#      CALL s_errmsg('',s_sum,'sum>ogb12','aba-014',1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#   IF s_sum < g_ogb.ogb12 THEN
#      CALL cl_err('','aba-015',1)       #只是警告下
#   END IF
END FUNCTION

FUNCTION p600_a_refresh()

   DISPLAY ARRAY g_a1 TO s_a1.* ATTRIBUTE(unbuffered)

     BEFORE DISPLAY
        EXIT DISPLAY

   END DISPLAY

   DISPLAY ARRAY g_a2 TO s_a2.* ATTRIBUTE(unbuffered)

     BEFORE DISPLAY
        EXIT DISPLAY

   END DISPLAY

   DISPLAY ARRAY g_a3 TO s_a3.* ATTRIBUTE(unbuffered)

     BEFORE DISPLAY
        EXIT DISPLAY

   END DISPLAY
   CALL ui.Interface.refresh()

END FUNCTION

FUNCTION p600_b_refresh()

   DISPLAY ARRAY g_b1 TO s_b1.* ATTRIBUTE(unbuffered)

     BEFORE DISPLAY
        EXIT DISPLAY

   END DISPLAY

   DISPLAY ARRAY g_b2 TO s_b2.* ATTRIBUTE(unbuffered)

     BEFORE DISPLAY
        EXIT DISPLAY

   END DISPLAY

   DISPLAY ARRAY g_b3 TO s_b3.* ATTRIBUTE(unbuffered)

     BEFORE DISPLAY
        EXIT DISPLAY

   END DISPLAY
   CALL ui.Interface.refresh()

END FUNCTION

FUNCTION p600_c_refresh()

   DISPLAY ARRAY g_c1 TO s_c1.* ATTRIBUTE(unbuffered)

     BEFORE DISPLAY
        EXIT DISPLAY

   END DISPLAY

   DISPLAY ARRAY g_c2 TO s_c2.* ATTRIBUTE(unbuffered)

     BEFORE DISPLAY
        EXIT DISPLAY

   END DISPLAY

   CALL ui.Interface.refresh()

END FUNCTION

FUNCTION p600_chk_qitao(p_oea01,p_oba01)
   DEFINE p_oea01  LIKE oea_file.oea01
   DEFINE p_oba01  LIKE oba_file.oba01
  #DEFINE l_sum    LIKE pak_file.pak03 #No:DEV-CB0001--mark
  #DEFINE l_cnt    LIKE pak_file.pak03 #No:DEV-CB0001--mark
   DEFINE l_sum    LIKE ibc_file.ibc03 #No:DEV-CB0001--mark
   DEFINE l_cnt    LIKE ibc_file.ibc03 #No:DEV-CB0001--mark

   #No:DEV-CB0001--mark--begin
   #SELECT DISTINCT pak03 INTO l_sum FROM pak_file
   # WHERE pak01 = p_oea01
   #   AND pak00 = '2'
   #   AND pak08 = p_oba01
   #No:DEV-CB0001--mark--end
   #No:DEV-CB0001--add--begin
    SELECT DISTINCT ibc03 INTO l_sum FROM ibc_file
     WHERE ibc01 = p_oea01
       AND ibc00 = '2'
       AND ibc08 = p_oba01
   #No:DEV-CB0001--add--end

    IF cl_null(l_sum) OR l_sum=0 THEN
       RETURN FALSE ,1
    END IF

    FOR l_cnt = 1 TO l_sum

       IF g_rec_a3 < l_cnt THEN RETURN FALSE ,l_cnt END IF
       IF cl_null(g_a3[l_cnt].a_imgb05) OR g_a3[l_cnt].a_imgb05 <=0 THEN
          RETURN FALSE,l_cnt
       END IF

    END FOR
    RETURN TRUE,0

END FUNCTION
#DEV-D30025--add


