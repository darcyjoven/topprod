# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: abat302
# DESCRIPTIONS...: 雜收條碼扣帳作業
# DATE & AUTHOR..: No:DEV-CA0016 2012/10/31 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---


DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"

DEFINE

    tm   RECORD    #程式變數(Program Variables)
        a   LIKE type_file.chr1
         END  RECORD,
    g_inb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         inb01  LIKE  inb_file.inb01,      #工单号
         inb03  LIKE  inb_file.inb03,
         inb04  LIKE  inb_file.inb04,      #料件
         ima02  LIKE  ima_file.ima02,      #品名
         ima021 LIKE  ima_file.ima021,     #规格
         inb09  LIKE  inb_file.inb09,      #入库数量
         sets   LIKE  inb_file.inb08       #齐套数量
           END  RECORD,
    g_max    DYNAMIC ARRAY OF RECORD
         sets   LIKE  inb_file.inb08       #最大入库包数量
           END RECORD,
    g_imgb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        imgb01    LIKE imgb_file.imgb01,   #条码
       #iba12     LIKE iba_file.iba12,     #        #No:DEV-CA0016--mark
        ibb05     LIKE ibb_file.ibb05,     #包號    #No:DEV-CA0016--add
        imgb02    LIKE imgb_file.imgb02,   #仓库
        imgb03    LIKE imgb_file.imgb03,   #库位
        imgb04    LIKE imgb_file.imgb04,   #批号
        imgb05    LIKE imgb_file.imgb05,   #数量
        more          LIKE imgb_file.imgb05,   #多
        less          LIKE imgb_file.imgb05    #缺
            END  RECORD,
    g_wc,g_wc2,g_sql     STRING,
    g_cmd                STRING,
    g_rec_b         LIKE type_file.num10,                #單身筆數
    g_rec_b2        LIKE type_file.num10,                #單身筆數
    g_row_count     LIKE type_file.num5,
    g_curs_index    LIKE type_file.num5,
    mi_no_ask       LIKE type_file.num5,
    g_jump          LIKE type_file.num5,
    l_ac            LIKE type_file.num10,                 #目前處理的ARRAY CNT
    l_ac2           LIKE type_file.num10,                 #目前處理的ARRAY CNT
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

MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF

    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
       RETURNING g_time
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW t302_w AT p_row,p_col WITH FORM "aba/42f/abat302"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    CALL cl_set_comp_visible("more,less",FALSE) #No:DEV-CA0016--add
    CALL t302_menu()
    CLOSE WINDOW t302_w                  #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
       RETURNING g_time
END MAIN

FUNCTION t302_menu()

   WHILE TRUE
      CALL t302_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t302_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "aimt302_post"
            IF l_ac = 0 THEN CONTINUE WHILE END IF
            CALL t302_post(g_inb[l_ac].inb01)
            #CALL t302_show()
      END CASE
   END WHILE
END FUNCTION

FUNCTION t302_q()

   MESSAGE ""
   CLEAR FORM
   CALL g_inb.clear()
   CALL g_max.clear()
   CALL g_imgb.CLEAR()
   CALL t302_cs()
   CALL t302_show()

END FUNCTION

FUNCTION t302_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
      CALL cl_set_head_visible("","YES")
      INITIALIZE tm.* TO NULL
      DIALOG ATTRIBUTES(UNBUFFERED)

      INPUT BY NAME tm.a
         BEFORE INPUT
           LET tm.a = 'N'

           DISPLAY BY NAME tm.a

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

      END INPUT

      CONSTRUCT g_wc ON inb01,inb03,inb04,inb09
              FROM s_inb[1].inb01,s_inb[1].inb03,s_inb[1].inb04,
                   s_inb[1].inb09
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
               WHEN INFIELD(inb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1 = '3'
                  LET g_qryparam.form ="q_ina"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO inb01
                  NEXT FIELD inb01
               WHEN INFIELD(inb04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima18"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO inb04
                  NEXT FIELD inb04
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT

   END DIALOG

   IF INT_FLAG THEN
       LET INT_FLAG = FALSE
       RETURN
   END IF
   IF cl_null(g_wc) THEN LET g_wc = " 1=1 " END IF

END FUNCTION

FUNCTION t302_show()
DEFINE  l_ima02   LIKE ima_file.ima02
DEFINE  l_ima021  LIKE ima_file.ima021   #FUN-AA0086

   CALL t302_b_fill()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t302_b_fill()
DEFINE p_wc2   STRING

   LET g_sql = "SELECT ina01,inb03,inb04,ima02,ima021,inb09,'' ",
               "  FROM ina_file,inb_file,ima_file ",
               " WHERE ina01 = inb01 ",
               "   AND ina00 = '3' ",
               "   AND inb04 = ima01 ",
              #"   AND ima76 IN ('50','501','10') ",                              #No:DEV-CA0016--mark
               "   AND ina01 IN (SELECT ibb03 FROM ibb_file WHERE ibb02 = 'I') ", #No:DEV-CA0016--add
               "   AND ",g_wc
   IF tm.a = 'Y' THEN
      LET g_sql = g_sql," AND inapost = 'Y' "
   END IF
   IF tm.a = 'N' THEN
      LET g_sql = g_sql," AND inapost = 'N' "
   END IF

  #LET g_sql = g_sql ," ORDER BY 1"                   #No:DEV-CA0016--mark
   LET g_sql = g_sql ," ORDER BY ina01,inb03,inb04"   #No:DEV-CA0016--add

   PREPARE t302_pb FROM g_sql
   DECLARE inb_cs CURSOR FOR t302_pb

   CALL g_inb.clear()
   CALL g_max.clear()
   LET g_cnt = 1

   FOREACH inb_cs INTO g_inb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #No:DEV-CA0016--mark--begin
      #LET g_sql =" SELECT MIN(nvl(s_tlfb05,0)) ",
      #           "   FROM iba_file LEFT JOIN (  ",
      #           " SELECT tlfb00,tlfb01,SUM(tlfb05) s_tlfb05 ",
      #           "   FROM tlfb_file ",
      #           "  WHERE tlfb11 = 'abat032' ",
      #           "  GROUP BY tlfb00,tlfb01) ON iba00 = tlfb00 AND iba01 = tlfb01 ",
      #           "  WHERE iba05 = '",g_inb[g_cnt].inb01,"' AND to_number(iba06) = '",g_inb[g_cnt].inb03,"'  "
      #No:DEV-CA0016--mark--end
       #No:DEV-CA0016--add--begin
       LET g_sql =" SELECT MIN(nvl(sets,0)) ",
                  "   FROM ( SELECT tlfb01,SUM(tlfb05*tlfb06) sets ",
                  "          FROM tlfb_file ",
                  "         WHERE tlfb11 = 'abat032' ",
                  "           AND tlfb07 = '",g_inb[g_cnt].inb01,"'",
                  "           AND tlfb08 =  ",g_inb[g_cnt].inb03,
                  "         GROUP BY tlfb01)"
       #No:DEV-CA0016--add--end

       PREPARE get_sets FROM g_sql
       EXECUTE get_sets INTO g_inb[g_cnt].sets
       IF cl_null(g_inb[g_cnt].sets) THEN
          LET g_inb[g_cnt].sets = 0
       END IF
       IF cl_null(g_max[g_cnt].sets) THEN
          LET g_max[g_cnt].sets = 0
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_inb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0

END FUNCTION

FUNCTION t302_d_fill(p_inb01,p_inb03)
   DEFINE p_inb01  LIKE  inb_file.inb01
   DEFINE p_inb03  LIKE  inb_file.inb03
   DEFINE l_iba01  LIKE iba_file.iba01
  #DEFINE l_iba12  LIKE iba_file.iba12 #No:DEV-CA0016--mark

  #No:DEV-CA0016--mark--begin
  #LET g_sql = " SELECT iba01,iba12,tlfb02,tlfb03,tlfb04,nvl(s_tlfb05,0),'','' ",
  #            "   FROM iba_file LEFT JOIN ( ",
  #            " SELECT tlfb00,tlfb01,tlfb02,tlfb03,tlfb04,sum(tlfb05) s_tlfb05 ",
  #            "   FROM tlfb_file ",
  #            "  WHERE tlfb11 = 'abat032' ",
  #            "  GROUP BY tlfb00,tlfb01,tlfb02,tlfb03,tlfb04) on iba00 = tlfb00 and iba01 = tlfb01 ",
  #            "  WHERE iba05 = '",p_inb01,"' AND to_number(iba06) = '",p_inb03,"' ",
  #            "  ORDER BY 1,2 "
  #No:DEV-CA0016--mark--end
   #No:DEV-CA0016--mark--begin
   LET g_sql = " SELECT imgb01,ibb05,imgb02,imgb03,imgb04,NVL(imgb05,0),'','' ",
               "   FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01 ",
               "  WHERE ibb02 = 'I' ",
               "    AND ibb03 = '",p_inb01,"' ",
               "  ORDER BY imgb01 "
   #No:DEV-CA0016--mark--end

   PREPARE t302_pb_d FROM g_sql
   DECLARE imgb_cs CURSOR FOR t302_pb_d

   CALL g_imgb.clear()
   LET g_cnt = 1

   FOREACH imgb_cs INTO g_imgb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
     #多
       LET g_imgb[g_cnt].more = g_imgb[g_cnt].imgb05 - g_inb[l_ac].sets
       IF g_imgb[g_cnt].more = 0 THEN
          LET g_imgb[g_cnt].more = ''
       END IF
     #少
       IF cl_null(g_imgb[g_cnt].imgb05) THEN
          LET g_imgb[g_cnt].less = g_max[l_ac].sets
       ELSE
          LET g_imgb[g_cnt].less = g_max[l_ac].sets - g_imgb[g_cnt].imgb05
          IF g_imgb[g_cnt].less = 0 THEN
             LET g_imgb[g_cnt].less = ''
          END IF
       END IF

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_imgb.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   LET g_cnt = 0

END FUNCTION

FUNCTION t302_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_sql  STRING

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_inb TO s_inb.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

          BEFORE ROW
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
                CALL t302_d_fill(g_inb[l_ac].inb01,g_inb[l_ac].inb03)
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
         IF l_ac > 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF


     ON ACTION query
        LET g_action_choice="query"
        EXIT DIALOG

     ON ACTION aimt302_post
        LET g_action_choice="aimt302_post"
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

FUNCTION t302_post(p_inb01)
   DEFINE p_inb01   LIKE inb_file.inb01
   DEFINE p_inb09   LIKE inb_file.inb09
   DEFINE p_sets    LIKE  inb_file.inb08

   IF g_rec_b = 0 THEN RETURN END IF
   CALL t302_post_pre_chk(p_inb01)
   IF g_success = 'N' THEN RETURN END IF
   LET g_cmd = "aimt302 '",p_inb01,"' 'query' 'abat302' "
   CALL cl_cmdrun_wait(g_cmd)

END FUNCTION

FUNCTION t302_post_pre_chk(p_inb01)
   DEFINE p_inb01   LIKE inb_file.inb01
   DEFINE p_inb09   LIKE inb_file.inb09
   DEFINE p_sets    LIKE  inb_file.inb08
   DEFINE l_inapost  LIKE ina_file.inapost
   DEFINE l_des   STRING
   DEFINE l_cnt     LIKE type_file.num5

   LET g_success = 'Y'

   SELECT inapost INTO l_inapost FROM ina_file
    WHERE ina01 = p_inb01

   IF l_inapost = 'Y' THEN
      CALL cl_err(p_inb01,'aba-047',0)
      LET g_success = 'N'
      RETURN
   END IF

   FOR l_cnt = 1 TO g_rec_b
      IF g_inb[l_cnt].inb01 = p_inb01 THEN
         IF g_inb[l_cnt].inb09 != g_inb[l_cnt].sets THEN
            LET g_success = 'N'
            LET l_des = p_inb01," 杂收数量 与 齐套数量不相等\n"
         END IF

         IF g_success = 'N' THEN
            CALL cl_err(l_des,'!',1)
            RETURN
         END IF
      END IF
   END FOR

END FUNCTION
#DEV-D30025--add



