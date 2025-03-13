# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: gglt102.4gl
# Descriptions...: 长期投资成本法轉權益法作業
# Date & Author..: 10/11/04 By lutingting
# Modify.........: NO.FUN-B40104 11/05/05 By xjll  合並報表回收產品
# Modify.........: No.FUN-B60134 11/06/27 By xjll  根据大連華錄修改部份程式
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: No.FUN-B90009 11/09/01 By lutingting自動產生單身時,asp22(調整科目-本年)默認值改為給asz14合併投資收益科目
# Modify.........: No.FUN-B90018 11/09/02 By lutingting自動產生單身時,第二單身抓取asii_file的條件還要增加當前族群是分層合併
# Modify.........: No.FUN-B90034 11/09/05 By lutingting單頭幣別取合併族群最上層公司的記帳幣別
# Modify.........: No.FUN-B90057 11/09/06 By lutingting調整分錄改為借:長投 貸:投資收益,不再拆分
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No.TQC-C30136 12/03/08 By xujing 處理ON ACITON衝突問題
# Modify.........: No.TQC-C70023 12/07/04 By lujh 投資公司欄位檢查報錯有誤
#                                                 單身【子公司編號】欄位錄入無效值，仍能通過，未做有效性檢查
#                                                 單身【被投資公司】欄位輸入無效值，報錯信息agl-323有誤。
# Modify.........: NO.FUN-C80020 12/11/12 By Carrier 增加key 值字段 asm20/asn20/asnn20 合并年度 asm21/asn21/asnn21 合并期别
# Modify.........: No.TQC-C90057 12/11/12 By Carrier asj09/asj11/asj12空时赋值
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 By xumm 修改FUN-D30032遗留问题

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-BB0036

DEFINE g_aso01          LIKE aso_file.aso01,
       g_aso02          LIKE aso_file.aso02,
       g_aso03          LIKE aso_file.aso03,
       g_aso05          LIKE aso_file.aso05,
       g_aso09          LIKE aso_file.aso09,
       g_aso04          LIKE aso_file.aso04,
       g_aso10          LIKE aso_file.aso10,
       g_aso11          LIKE aso_file.aso11,
       g_aso01_t        LIKE aso_file.aso01,
       g_aso02_t        LIKE aso_file.aso02,
       g_aso03_t        LIKE aso_file.aso03,
       g_aso05_t        LIKE aso_file.aso05,
       g_aso04_t        LIKE aso_file.aso04,
       g_aso09_t        LIKE aso_file.aso09,
       g_aso10_t        LIKE aso_file.aso10,
       g_aso11_t        LIKE aso_file.aso11,
       g_aso01_o        LIKE aso_file.aso01,
       g_aso02_O        LIKE aso_file.aso02,
       g_aso03_o        LIKE aso_file.aso03,
       g_aso05_o        LIKE aso_file.aso05,
       g_aso04_o        LIKE aso_file.aso04,
       g_aso09_o        LIKE aso_file.aso09,
       g_aso10_o        LIKE aso_file.aso10,
       g_aso11_o        LIKE aso_file.aso11,
       b_aso            RECORD LIKE aso_file.*,
       g_aso            DYNAMIC ARRAY OF RECORD            #程式變數(Program Variables)
                           aso06 LIKE aso_file.aso06,      #長期股權投資科目#
                           aso07 LIKE aso_file.aso07,      #子公司關係人編號#
                           aso08 LIKE aso_file.aso08      #金額#
                        END RECORD,
       g_aso_t          RECORD
                           aso06 LIKE aso_file.aso06,
                           aso07 LIKE aso_file.aso07,
                           aso08 LIKE aso_file.aso08
                        END RECORD,
       b_asp            RECORD LIKE asp_file.*,
       g_asp            DYNAMIC ARRAY OF RECORD            #程式變數(Program Variables)
                           asp06 LIKE asp_file.asp06,      #被投資公司#
                           asp06_desc LIKE asg_file.asg02, #被投资公司名称
                           asp08 LIKE asp_file.asp08,      #母公司關係人編號#
                           asp07 LIKE asp_file.asp07,      #所有者權益科目#
                           asp09 LIKE asp_file.asp09,      #子公司幣別#
                           asp10 LIKE asp_file.asp10,      #金額#
                           asp19 LIKE asp_file.asp19,      #本期发生额
                           asp11 LIKE asp_file.asp11,      #再衡量匯率#
                           asp12 LIKE asp_file.asp12,      #轉換匯率#
                           asp13 LIKE asp_file.asp13,      #合並報表金額#
                           asp20 LIKE asp_file.asp20,      #本期发生额
                           asp14_1 LIKE asp_file.asp14,    #年初投资比例
                           asp14 LIKE asp_file.asp14,      #投資比例#
                           asp15 LIKE asp_file.asp15,      #投資公司股權科目#
                           asp16 LIKE asp_file.asp16,      #金額#
                           asp21 LIKE asp_file.asp21,      #本期发生额
                           asp17 LIKE asp_file.asp17,       #投資公司調整科目#
                           asp22 LIKE asp_file.asp22       #本期发生额
                        END RECORD,
       g_asp_t          RECORD
                           asp06 LIKE asp_file.asp06,      #被投資公司#
                           asp06_desc LIKE asg_file.asg02, #被投资公司名称
                           asp08 LIKE asp_file.asp08,      #母公司關係人編號#
                           asp07 LIKE asp_file.asp07,      #所有者權益科目#
                           asp09 LIKE asp_file.asp09,      #子公司幣別#
                           asp10 LIKE asp_file.asp10,      #金額#
                           asp19 LIKE asp_file.asp19,      #本期发生额
                           asp11 LIKE asp_file.asp11,      #再衡量匯率#
                           asp12 LIKE asp_file.asp12,      #轉換匯率#
                           asp13 LIKE asp_file.asp13,      #合並報表金額#
                           asp20 LIKE asp_file.asp20,      #本期发生额
                           asp14_1 LIKE asp_file.asp14,
                           asp14 LIKE asp_file.asp14,      #投資比例#
                           asp15 LIKE asp_file.asp15,      #投資公司股權科目#
                           asp16 LIKE asp_file.asp16,      #金額#
                           asp21 LIKE asp_file.asp21,      #本期发生额
                           asp17 LIKE asp_file.asp17,       #投資公司調整科目#
                           asp22 LIKE asp_file.asp22       #本期发生额
                        END RECORD,
       g_wc,g_wc2,g_sql string,
       g_rec_b1         LIKE type_file.num5,
       l_ac1            LIKE type_file.num5,
       p_row,p_col      LIKE type_file.num5
#主程式開始
DEFINE g_forupd_sql     STRING
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_chr            LIKE type_file.chr1
DEFINE g_chr2           LIKE type_file.chr1
DEFINE g_chr3           LIKE type_file.chr1
DEFINE g_cnt            LIKE type_file.num10
DEFINE g_i              LIKE type_file.num5
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_str            STRING
DEFINE g_wc_gl          STRING
DEFINE g_row_count      LIKE type_file.num10
DEFINE g_curs_index     LIKE type_file.num10
DEFINE g_jump           LIKE type_file.num10
DEFINE l_ac2            LIKE type_file.num5
DEFINE g_rec_b2         LIKE type_file.num5
DEFINE g_wc3            STRING
DEFINE g_b_flag         STRING
DEFINE t_azi04_1        LIKE azi_file.azi04   #母公司币别取位
DEFINE t_azi04_2        LIKE azi_file.azi04   #子公司币别取位
DEFINE mi_no_ask        LIKE type_file.num5
DEFINE g_asz            RECORD LIKE asz_file.*
#FUN-B80135--add--str--
DEFINE g_aaa07          LIKE aaa_file.aaa07
DEFINE g_year           LIKE type_file.chr4
DEFINE g_month          LIKE type_file.chr2
#FUN-B80135--add—end--

MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
   END IF

   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
     RETURNING g_time

   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0'
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
   #FUN-B80135--add--end

   SELECT * INTO g_asz.* FROM asz_file WHERE asz00 = '0'

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      LET p_row = 2 LET p_col = 3
      OPEN WINDOW t004_w AT p_row,p_col
        WITH FORM "ggl/42f/gglt102"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_init()
   END IF

   CALL cl_set_comp_visible("asp08",FALSE)
   CALL t004_menu()

   CLOSE WINDOW t004_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間)
      RETURNING g_time

END MAIN

FUNCTION t004_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01

   CLEAR FORM                             #清除畫面
   CALL g_asp.clear()
   CALL g_aso.clear()
   INITIALIZE g_aso01 TO NULL
   INITIALIZE g_aso02 TO NULL
   INITIALIZE g_aso03 TO NULL
   INITIALIZE g_aso05 TO NULL
   INITIALIZE g_aso09 TO NULL
   INITIALIZE g_aso04 TO NULL
   INITIALIZE g_aso10 TO NULL
   DISPLAY g_aso11 TO aso11
   CALL cl_set_head_visible("","YES")

      DIALOG ATTRIBUTES(UNBUFFERED)

      CONSTRUCT g_wc ON aso01,aso02,aso03,aso05,aso09,aso04,aso11,aso10,
                        aso06,aso07,aso08
              FROM aso01,aso02,aso03,aso05,aso09,aso04,aso11,aso10,
                   s_aso[1].aso06,s_aso[1].aso07,s_aso[1].aso08

             #Modifi NO.FUN-B40104  增加查询开窗功能
         #####TQC-C30136---mark---str#####
         #ON ACTION CONTROLP
         #   CASE
         #      WHEN INFIELD(aso03)
         #         CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aso03"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aso03
         #        NEXT FIELD aso05
         #
         #      WHEN INFIELD(aso05)
         #        CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aso05"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aso05
         #        NEXT FIELD aso09

         #       WHEN INFIELD(aso04)
         #        CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aso04"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aso04
         #        NEXT FIELD aso11
         #
         #
         #       WHEN INFIELD(aso06)
         #        CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aso06"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aso06
         #        NEXT FIELD aso06

         #
         #       WHEN INFIELD(aso07)
         #        CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aso07"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aso07
         #        NEXT FIELD aso08
         #

         #
         #        OTHERWISE EXIT CASE
         #     END CASE
         #####TQC-C30136---mark---end#####
		  BEFORE CONSTRUCT
		    CALL cl_qbe_display_condition(lc_qbe_sn)

      END CONSTRUCT

      CONSTRUCT g_wc2 ON asp06,asp08,asp07,asp09,asp10,asp19,asp11,
                         asp12,asp13,asp20,asp14,asp14_1,asp15,asp16,asp21,asp17,asp22
              FROM s_asp[1].asp06,s_asp[1].asp08,s_asp[1].asp07,
                   s_asp[1].asp09,s_asp[1].asp10,s_asp[1].asp19,s_asp[1].asp11,
                   s_asp[1].asp12,s_asp[1].asp13,s_asp[1].asp20,s_asp[1].asp14,
                   s_asp[1].asp14_1,
                   s_asp[1].asp15,s_asp[1].asp16,s_asp[1].asp21,s_asp[1].asp17,
                   s_asp[1].asp22

		  BEFORE CONSTRUCT
		    CALL cl_qbe_display_condition(lc_qbe_sn)

      END CONSTRUCT

          ON ACTION CONTROLP
             CASE
                WHEN INFIELD(aso01)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aso"
                  LET g_qryparam.arg1 = "2"       #No.TQC-A90057
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aso01
                NEXT FIELD aso01


               WHEN INFIELD(asp06)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asp06"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asp06
                NEXT FIELD asp06

                WHEN INFIELD(asp07)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asp07"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asp07
                  NEXT FIELD asp07

                WHEN INFIELD(asp15)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asp15"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asp15
                  NEXT FIELD asp15

                 WHEN INFIELD(asp17)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asp17"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asp17
                  NEXT FIELD asp17


                  WHEN INFIELD(asp22)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asp22"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asp22
                  NEXT FIELD asp22

                #TQC-C30136---add---str---
                WHEN INFIELD(aso03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aso03"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aso03
                  NEXT FIELD aso05

                WHEN INFIELD(aso05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aso05"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aso05
                  NEXT FIELD aso09

                 WHEN INFIELD(aso04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aso04"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret

                 WHEN INFIELD(aso06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aso06"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aso06
                  NEXT FIELD aso06


                 WHEN INFIELD(aso07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aso07"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aso07
                  NEXT FIELD aso08
                  #TQC-C30136---add---end---
                  OTHERWISE EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

          ON ACTION about
             CALL cl_about()

          ON ACTION help
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
      END DIALOG

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF

   IF cl_null(g_wc2) THEN
      LET g_wc2 =' 1=1'
   END IF

   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT UNIQUE aso01,aso02,aso03,aso04,aso05,aso11 FROM aso_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY aso01,aso02,aso03,aso04,aso05,aso11"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE aso01,aso02,aso03,aso04,aso05,aso11 ",
                  "  FROM aso_file,asp_file",
                  " WHERE aso01 = asp01 AND aso02 = asp02 AND aso03 = asp03 ",
                  "   AND aso04 = asp04 AND aso05 = asp05 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED,
                  " ORDER BY aso01,aso02,aso03,aso04,aso05,aso11"
   END IF

   PREPARE t004_prepare FROM g_sql
   DECLARE t004_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t004_prepare

   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT UNIQUE aso01,aso02,aso03,aso04,aso05,aso11 FROM aso_file",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
   ELSE
      LET g_sql="SELECT UNIQUE aso01,aso02,aso03,aso04,aso05,aso11 ",
                "  FROM aso_file,asp_file",
                " WHERE aso01 = asp01 AND aso02 = asp02 AND aso03 = asp03 ",
                "   AND aso04 = asp04 AND aso05 = asp05 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED,
                " INTO TEMP x "
   END IF
   DROP TABLE x
   PREPARE t004_pre_x FROM g_sql
   EXECUTE t004_pre_x
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE t004_precount FROM g_sql
   DECLARE t004_count CURSOR FOR t004_precount

END FUNCTION

FUNCTION t004_menu()

   WHILE TRUE
      CALL t004_bp("G")
      CALL cl_set_act_visible("close",FALSE)
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t004_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t004_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t004_r()
            END IF


         WHEN "detail"
            IF cl_chk_act_auth() THEN
               #CASE g_b_flag
               #     WHEN '1'
                              CALL t004_b1()
                    #WHEN '2' CALL t004_b2()
               #END CASE
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "gen_entry"    #產生調整分錄#
            CALL t004_v()

         WHEN "qry_sheet"    #查詢調整分錄#
            IF cl_chk_act_auth() THEN
               LET g_msg="gglt1003 '",g_aso11,"' '",g_aso10,"' "
              CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
     END CASE
   END WHILE
END FUNCTION

FUNCTION t004_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_asp.clear()
   CALL g_aso.clear()
   INITIALIZE g_aso01 LIKE aso_file.aso01  #DEFAULT 設定
   INITIALIZE g_aso02 LIKE aso_file.aso02  #DEFAULT 設定
   INITIALIZE g_aso03 LIKE aso_file.aso03  #DEFAULT 設定
   INITIALIZE g_aso05 LIKE aso_file.aso09  #DEFAULT 設定
   INITIALIZE g_aso09 LIKE aso_file.aso09  #DEFAULT 設定
   INITIALIZE g_aso04 LIKE aso_file.aso04  #DEFAULT 設定
   INITIALIZE g_aso10 LIKE aso_file.aso10  #DEFAULT 設定
   INITIALIZE g_aso11 LIKE aso_file.aso11  #DEFAULT 設定
   INITIALIZE g_aso01_t LIKE aso_file.aso01  #DEFAULT 設定
   INITIALIZE g_aso02_t LIKE aso_file.aso02  #DEFAULT 設定
   INITIALIZE g_aso03_t LIKE aso_file.aso03  #DEFAULT 設定
   INITIALIZE g_aso05_t LIKE aso_file.aso09  #DEFAULT 設定
   INITIALIZE g_aso09_t LIKE aso_file.aso09  #DEFAULT 設定
   INITIALIZE g_aso04_t LIKE aso_file.aso04  #DEFAULT 設定
   INITIALIZE g_aso10_t LIKE aso_file.aso10  #DEFAULT 設定
   INITIALIZE g_aso11_t LIKE aso_file.aso11  #DEFAULT 設定
   SELECT asz01 INTO g_aso11 FROM asz_file WHERE asz00 = '0'
   DISPLAY g_aso11 TO aso11
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL t004_i("a")                #輸入單頭
      IF INT_FLAG THEN
         LET g_aso01 = NULL
         LET g_aso02 = NULL
         LET g_aso03 = NULL
         LET g_aso04 = NULL
         LET g_aso05 = NULL
         LET g_aso09 = NULL
         LET g_aso10 = NULL
         LET g_aso11 = NULL
         DISPLAY g_aso01,g_aso02,g_aso03,g_aso05,g_aso09,g_aso04,g_aso10,g_aso11
              TO aso01,aso02,aso03,aso05,aso09,aso04,aso10,g_aso11
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF g_aso01 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF
      IF g_aso02 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF
      IF g_aso03 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF
      IF g_aso04 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF
      IF g_aso05 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF

      CALL g_aso.clear()
      LET g_rec_b1=0
      CALL g_asp.clear()
      LET g_rec_b2=0

      LET l_ac1=1

      CALL t004_g_b()                  #自动生成单身   #101125
      CALL t004_b1()                   #輸入單身
      #CALL t004_b2()

      LET g_aso01_t = g_aso01    ##保留舊值
      LET g_aso02_t = g_aso02    ##保留舊值
      LET g_aso03_t = g_aso03    ##保留舊值
      LET g_aso04_t = g_aso04    ##保留舊值
      LET g_aso05_t = g_aso05    ##保留舊值
      LET g_aso10_t = g_aso10    ##保留舊值
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION t004_u()
   DEFINE l_yy,l_mm   LIKE type_file.num5               #No.FUN-680123 SMALLINT

   IF s_shut(0) THEN RETURN END IF

   IF cl_null(g_aso01) OR cl_null(g_aso02) OR cl_null(g_aso03) OR cl_null(g_aso04)
      OR cl_null(g_aso11) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_success = 'Y'   #MOD-730060
    BEGIN WORK

    WHILE TRUE
        CALL t004_i('u')
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        EXIT WHILE
    END WHILE
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF   #MOD-730060
END FUNCTION


#處理INPUT
FUNCTION t004_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1       #a:輸入 u:更改
  DEFINE l_flag          LIKE type_file.chr1       #判斷必要欄位是否有輸入
  DEFINE l_n             LIKE type_file.num5
  DEFINE l_cnt           LIKE type_file.num5

    DISPLAY g_aso01,g_aso02,g_aso03,g_aso05,g_aso09,g_aso04,g_aso10,g_aso11
         TO aso01,aso02,aso03,g_aso05,aso09,aso04,aso10,g_aso11

    CALL cl_set_head_visible("","YES")

    INPUT g_aso01,g_aso02,g_aso03,g_aso05
        WITHOUT DEFAULTS
        FROM aso01,aso02,aso03,aso05

        BEFORE INPUT
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE

        AFTER FIELD aso01
            IF cl_null(g_aso01) THEN
               NEXT FIELD aso01
            END IF
            #No.FUN-B80135--add--str--
            IF NOT cl_null(g_aso01) THEN
               IF g_aso01 < 0 THEN
                  CALL cl_err(g_aso01,'apj-035',0)
                  NEXT FIELD aso01
               END IF

                IF g_aso01<g_year  THEN
                   CALL cl_err(g_aso01,'atp-164',0)
                   NEXT FIELD aso01
                END IF
                IF g_aso01=g_year AND g_aso02 <= g_month THEN
                   CALL cl_err(g_aso02,'atp-164',0)
                   NEXT FIELD aso02
                END IF
            END IF
            #No.FUN-B80135--add--end


        AFTER FIELD aso02
           IF NOT cl_null(g_aso02) THEN
               IF g_aso02 < 1 OR g_aso02 > 12 THEN
                  CALL cl_err(' ','agl-020',0)
                  NEXT FIELD aso02
               END IF
           #FUN-B80135--add--str--
               IF g_aso01=g_year AND g_aso02<=g_month THEN
                  CALL cl_err(g_aso02,'atp-164',0)
                  NEXT FIELD aso02
               END IF
            #FUN-B80135--add--end
           ELSE
              NEXT FIELD aso02
           END IF

        AFTER FIELD aso03
            IF NOT cl_null(g_aso03) THEN
               CALL t004_aso03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('aso03',g_errno,0)
                  NEXT FIELD aso03
               END IF
               #FUN-B90034--add--str--
               SELECT asg06 INTO g_aso09 FROM asg_file,asa_file
                WHERE asg01 = asa02 AND asa01 = g_aso03
                  AND asa04 = 'Y'
               DISPLAY g_aso09 TO aso09
               SELECT azi04 INTO t_azi04_1 FROM azi_file
                WHERE azi01 = g_aso09
               #FUN-B90034--add--end
            ELSE
               NEXT FIELD aso03
            END IF

        AFTER FIELD aso05
            IF NOT cl_null(g_aso05) THEN
               IF g_aso05!=g_aso05_t OR g_aso05_t IS NULL THEN
                  SELECT COUNT(*) INTO l_cnt FROM asa_file
                   WHERE asa01 = g_aso03 AND asa02 = g_aso05
                  IF l_cnt<1 THEN
                     #CALL cl_err('','agl-325',0)   #TQC-C70023  mark
                     CALL cl_err('','agl-450',0)    #TQC-C70023  add
                     LET g_aso05 = g_aso05_t
                     NEXT FIELD aso05
#FUN-B90034--mark--str--
#                 ELSE
#                    SELECT asg07 INTO g_aso09 FROM asg_file
#                     WHERE asg01 = g_aso05
#                    DISPLAY g_aso09 TO aso09
#                    SELECT azi04 INTO t_azi04_1 FROM azi_file
#                     WHERE azi01 = g_aso09
#FUN-B90034--mark--end
                  END IF
               END IF
            END IF

       # AFTER FIELD aso10
       #     IF NOT cl_null(g_aso10) THEN
       #        CALL t004_aso10()
       #        IF NOT cl_null(g_errno) THEN
       #           CALL cl_err('aso10',g_errno,0)
       #           NEXT FIELD aso10
       #        END IF
       #     ELSE
       #        NEXT FIELD aso10
       #     END IF
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF p_cmd = 'a' THEN
               IF NOT cl_null(g_aso01) AND NOT cl_null(g_aso02) AND
                  NOT cl_null(g_aso03) AND NOT cl_null(g_aso05) THEN
                  IF g_aso01_t IS NULL OR (g_aso01!=g_aso01_t) OR
                     g_aso02_t IS NULL OR (g_aso02!=g_aso02_t) OR
                     g_aso03_t IS NULL OR (g_aso03!=g_aso03_t) OR
                     g_aso05_t IS NULL OR (g_aso05!=g_aso05_t) THEN
                     SELECT COUNT(*) INTO l_n FROM aso_file
                      WHERE aso01 = g_aso01 AND aso02 = g_aso02
                        AND aso03 = g_aso03 AND aso05 = g_aso05
                     IF l_n>0 THEN
                        CALL cl_err('',-239,0)
                        NEXT FIELD aso01
                     END IF
                  END IF
               END IF
            END IF

        ON ACTION CONTROLP     #ok
            CASE
               WHEN INFIELD(aso03)   #族群编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asa1"
                  LET g_qryparam.default1 = g_aso03
                  CALL cl_create_qry() RETURNING g_aso03
                  DISPLAY g_aso03 TO aso03
                  CALL t004_aso03('d')
                  NEXT FIELD aso03
               WHEN INFIELD(aso05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_asa3"
                     LET g_qryparam.default1 = g_aso05
                     LET g_qryparam.arg1 = g_aso03
                     CALL cl_create_qry() RETURNING g_aso05
                     DISPLAY g_aso05 TO aso05
                     NEXT FIELD aso05
              # WHEN INFIELD(aso10)
              #    CALL q_aac(FALSE,TRUE,g_aso10,'A','','','GGL') RETURNING g_aso10
              #    DISPLAY g_aso10 TO aso10
              #    NEXT FIELD aso10
            END CASE

        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()
    END INPUT
END FUNCTION

FUNCTION t004_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aso01 TO NULL
    INITIALIZE g_aso02 TO NULL
    INITIALIZE g_aso03 TO NULL
    INITIALIZE g_aso04 TO NULL
    INITIALIZE g_aso05 TO NULL
    INITIALIZE g_aso10 TO NULL
   #MESSAGE ""
    CALL cl_msg("")                          #FUN-640246

    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t004_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
   #MESSAGE " SEARCHING ! "
    CALL cl_msg(" SEARCHING ! ")                              #FUN-640246

    OPEN t004_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aso01 TO NULL
        INITIALIZE g_aso02 TO NULL
        INITIALIZE g_aso03 TO NULL
        INITIALIZE g_aso04 TO NULL
        INITIALIZE g_aso05 TO NULL
        INITIALIZE g_aso10 TO NULL
        INITIALIZE g_aso11 TO NULL
    ELSE
        OPEN t004_count
        FETCH t004_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t004_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
   #MESSAGE ""
    CALL cl_msg("")                              #FUN-640246

END FUNCTION

FUNCTION t004_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,              #No.FUN-680123 VARCHAR(1),               #處理方式
    l_abso          LIKE type_file.num10              #No.FUN-680123 INTEGER                #絕對的筆數

    CASE p_flag
        WHEN 'N' FETCH NEXT     t004_cs INTO g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_aso11
        WHEN 'P' FETCH PREVIOUS t004_cs INTO g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_aso11
        WHEN 'F' FETCH FIRST    t004_cs INTO g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_aso11
        WHEN 'L' FETCH LAST     t004_cs INTO g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_aso11
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
            FETCH ABSOLUTE g_jump t004_cs INTO g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_aso11
            LET mi_no_ask = FALSE
    END CASE

    SELECT UNIQUE aso01,aso02,aso03,aso04,aso05,aso10,aso11
      INTO g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_aso10,g_aso11
      FROM aso_file
     WHERE aso01 = g_aso01 AND aso02 = g_aso02 AND aso03 = g_aso03
       AND aso05 = g_aso05 AND aso04 = g_aso04 AND aso11 = g_aso11
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aso01 TO NULL
        INITIALIZE g_aso02 TO NULL
        INITIALIZE g_aso03 TO NULL
        INITIALIZE g_aso04 TO NULL
        INITIALIZE g_aso05 TO NULL
        INITIALIZE g_aso10 TO NULL
        INITIALIZE g_aso11 TO NULL
    ELSE
       CALL t004_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION

FUNCTION t004_show()
   DISPLAY g_aso01 TO aso01
   DISPLAY g_aso02 TO aso02
   DISPLAY g_aso03 TO aso03
   DISPLAY g_aso04 TO aso04
   DISPLAY g_aso05 TO aso05
   DISPLAY g_aso10 TO aso10
   DISPLAY g_aso11 TO aso11

   #FUN-B90034--mod--str-
   #SELECT asg07 INTO g_aso09 FROM asg_file WHERE asg01 = g_aso05
   SELECT asg06 INTO g_aso09 FROM asg_file,asa_file
    WHERE asg01 = asa02 AND asa01 = g_aso03
      AND asa04 = 'Y'
   #FUN-B90034--mod--end
   DISPLAY g_aso09 TO aso09
   CALL t004_b_fill(g_wc)
   CALL t004_b_fill2(g_wc2)
END FUNCTION

FUNCTION t004_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1,              #No.FUN-680123 VARCHAR(1),
           l_n          LIKE type_file.num5               #No.FUN-680123 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF g_aso01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_aso02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_aso03 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_aso04 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_aso11 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT aso10 INTO g_aso10 FROM aso_file WHERE aso01 = g_aso01
       AND aso02 = g_aso02 AND aso03 = g_aso03 AND aso05 = g_aso05
    IF NOT cl_null(g_aso10) THEN CALL cl_err('','agl-353',0) RETURN END IF

    BEGIN WORK
    IF cl_delh(15,16) THEN
        DELETE FROM aso_file WHERE aso01 = g_aso01 AND aso02 = g_aso02 AND aso03 = g_aso03
                               AND aso04 = g_aso04 AND aso11 = g_aso11 AND aso05 = g_aso05
        IF SQLCA.SQLERRD[3]=0
             THEN CALL cl_err3("del","aso_file","","","","","No aso deleted",1)
             ROLLBACK WORK RETURN
        END IF
        DELETE FROM asp_file WHERE asp01 = g_aso01 AND asp02 = g_aso02
           AND asp03 = g_aso03 AND asp04 = g_aso04
           AND asp05 = g_aso05
        LET g_msg=TIME
        CLEAR FORM
        CALL g_asp.clear()
        CALL g_aso.clear()
        MESSAGE ""
        LET g_sql = "SELECT UNIQUE aso01,aso02,aso03,aso04,aso05,aso11",
                    "  FROM aso_file ",
                    "  INTO TEMP y"
        DROP TABLE y
        PREPARE t004_pre_y FROM g_sql
        EXECUTE t004_pre_y
        LET g_sql = "SELECT COUNT(*) FROM y"
        PREPARE t004_precount2 FROM g_sql
        DECLARE t004_count2 CURSOR FOR t004_precount2
        OPEN t004_count2
        FETCH t004_count2 INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t004_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t004_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t004_fetch('/')
        END IF

    END IF
    COMMIT WORK
END FUNCTION

FUNCTION t004_b1()
DEFINE l_ac1_t          LIKE type_file.num5,
       l_row,l_col     LIKE type_file.num5,
       l_n,l_cnt       LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_b2            LIKE type_file.chr1000,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5,
       l_ac2_t         LIKE type_file.num5
DEFINE l_asg01         LIKE asg_file.asg01
    SELECT azi04 INTO t_azi04_1 FROM azi_file WHERE azi01 = g_aso09
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT aso06,aso07,aso08 FROM aso_file ",
                       "  WHERE aso01 = ? AND aso02 = ? AND aso03 = ? AND aso04 = ? ",
                       "    AND aso05 = ? AND aso06 = ? AND aso07 = ? AND aso11 = ? ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t004_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET g_forupd_sql = " SELECT * FROM asp_file WHERE asp01 = ? AND asp02 = ? AND asp03 = ? ",
                       "    AND asp04 = ? AND asp05 = ? AND asp06 = ? AND asp07 = ? AND asp18 = ?",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t004_bcl_asp CURSOR FROM g_forupd_sql

    LET l_ac1_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    IF g_rec_b1>0 THEN LET l_ac1 = 1 END IF
    IF g_rec_b2>0 THEN LET l_ac2 = 1 END IF


    DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT ARRAY g_aso  FROM s_aso.*
            ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
            LET g_b_flag = '1'     #TQC-D40025 Add

        BEFORE ROW
            LET p_cmd = ''
            LET l_ac1 = ARR_CURR()
            DISPLAY l_ac1 TO FORMONLY.cn3
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()

            IF g_rec_b1>=l_ac1 THEN
               BEGIN WORK
               LET g_success = 'Y'
               LET p_cmd='u'
               LET g_aso01_t = g_aso01         #BACKUP
               LET g_aso02_t = g_aso02         #BACKUP
               LET g_aso03_t = g_aso03         #BACKUP
               LET g_aso04_t = g_aso04         #BACKUP
               LET g_aso05_t = g_aso05         #BACKUP
               LET g_aso10_t = g_aso10         #BACKUP
               LET g_aso11_t = g_aso11         #BACKUP
               LET g_aso_t.* = g_aso[l_ac1].*  #BACKUP
               OPEN t004_bcl USING g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,
                                   g_aso_t.aso06,g_aso_t.aso07,g_aso11
               IF STATUS THEN
                  CALL cl_err("OPEN t004_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
                  CLOSE t004_bcl
                  ROLLBACK WORK


               ELSE

                  FETCH t004_bcl INTO g_aso[l_ac1].*


                  IF SQLCA.sqlcode THEN
                      CALL cl_err('lock aso',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_success = 'N'   #MOD-730060
               CANCEL INSERT
            END IF
            INSERT INTO aso_file(aso01,aso02,aso03,aso04,aso05,aso06,aso07,aso08,aso09,aso10,aso11,asolegal)
                          VALUES(g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_aso[l_ac1].aso06,
                                 g_aso[l_ac1].aso07,g_aso[l_ac1].aso08,g_aso09,
                                 g_aso10,g_aso11,g_legal)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'   #MOD-730060
               CALL cl_err3("ins","aso_file",g_aso05,g_aso[l_ac1].aso06,SQLCA.sqlcode,"","ins aso",1)
               CANCEL INSERT
               ROLLBACK WORK
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b1=g_rec_b1+1
               DISPLAY g_rec_b1 TO FORMONLY.cn2
               COMMIT WORK
            END IF


        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_aso[l_ac1].* TO NULL      #900423
            LET g_aso_t.* = g_aso[l_ac1].*
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD aso06


        AFTER FIELD aso06
            IF NOT cl_null(g_aso[l_ac1].aso06) THEN
                  CALL t004_aag('a',g_aso[l_ac1].aso06)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_aso[l_ac1].aso06,g_errno,0)
                     NEXT FIELD aso06
                  END IF
                  IF g_aso[l_ac1].aso06! = g_aso_t.aso06 OR g_aso_t.aso06 IS NULL THEN
                      CALL t004_get_aso08()
                  END IF
            END IF
        AFTER FIELD aso07
            IF NOT cl_null(g_aso[l_ac1].aso07) THEN
                  IF g_aso[l_ac1].aso07! = g_aso_t.aso07 OR g_aso_t.aso07 IS NULL THEN
                     CALL t004_get_aso08()
                  END IF
                  #TQC-C70023--add--str--
                  SELECT  COUNT(*) INTO l_n FROM asg_file WHERE asg01 = g_aso[l_ac1].aso07
                  IF l_n = 0 THEN
                     CALL cl_err('','agl-451',0)
                     NEXT FIELD aso07
                  END IF
                  #TQC-C70023--add--end--
            END IF

        AFTER FIELD aso08
            IF NOT cl_null(g_aso[l_ac1].aso08) THEN
               IF g_aso[l_ac1].aso08<0 THEN
                  NEXT FIELD aso08
               END IF
            END IF
        BEFORE DELETE                            #是否取消單身
            IF g_aso_t.aso06 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   LET g_success = 'N'
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   LET g_success = 'N'
                   CANCEL DELETE
                END IF
                DELETE FROM aso_file
                 WHERE aso01 = g_aso01 AND aso02 = g_aso02 AND aso03 = g_aso03
                   AND aso04 = g_aso04 AND aso05 = g_aso05
                   AND aso06 = g_aso_t.aso06 AND aso07 = g_aso_t.aso07
                   AND aso11 = g_aso11
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","aso_file","","",SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                    CANCEL DELETE
                END IF
                IF g_success = 'Y' THEN
                   LET g_rec_b1=g_rec_b1-1
                   DISPLAY g_rec_b1 TO FORMONLY.cn2
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                END IF
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aso[l_ac1].* = g_aso_t.*
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aso[l_ac1].aso06,-263,1)
               LET g_aso[l_ac1].* = g_aso_t.*
               LET g_success='N'   #MOD-730060
            ELSE
               UPDATE aso_file SET aso06 = g_aso[l_ac1].aso06,
                                   aso07 = g_aso[l_ac1].aso07,
                                   aso08 = g_aso[l_ac1].aso08
                WHERE aso01 = g_aso01 AND aso02 = g_aso02 AND aso03 = g_aso03
                  AND aso04 = g_aso04 AND aso05 = g_aso05
                  AND aso06 = g_aso_t.aso06 AND aso07 = g_aso_t.aso07
                  AND aso11 = g_aso11
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","aso_file","","",SQLCA.sqlcode,"","upd aso",1)
                  LET g_aso[l_ac1].* = g_aso_t.*
                  LET g_success='N'
               END IF
            END IF
            IF g_success = 'Y' THEN
               MESSAGE 'UPDAET O.K'
               COMMIT WORK
            ELSE
               MESSAGE 'UPDATE ERR'
               ROLLBACK WORK
            END IF

        AFTER ROW
            LET l_ac1 = ARR_CURR()
           #LET l_ac1_t = l_ac1   #FUN-D30032 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aso[l_ac1].* = g_aso_t.*
               END IF
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            LET l_ac1_t = l_ac1   #FUN-D30032 Add
            CLOSE t004_bcl
            COMMIT WORK

  #     ON ACTION controls                     #TQC-C30136
  #      CALL cl_set_head_visible("","AUTO")   #TQC-C30136

        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(aso06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_aso[l_ac1].aso06
                     LET g_qryparam.arg1 = g_aso11
                     CALL cl_create_qry() RETURNING g_aso[l_ac1].aso06
                     DISPLAY BY NAME g_aso[l_ac1].aso06
                     NEXT FIELD aso06
               WHEN INFIELD(aso07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_asg"
                     LET g_qryparam.default1 = g_aso[l_ac1].aso07
                     CALL cl_create_qry() RETURNING g_aso[l_ac1].aso07
                     DISPLAY BY NAME g_aso[l_ac1].aso07
                     NEXT FIELD aso07
               OTHERWISE EXIT CASE
            END CASE

       #####TQC-C30136---mark---str#####
       #ON ACTION CONTROLZ
       #   CALL cl_show_req_fields()

       #ON ACTION CONTROLG
       #   CALL cl_cmdask()


       #ON ACTION CONTROLF
       # CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
       # CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
       #-------------------------------#
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
       #-------------------------------#
       # ON ACTION about
       #    CALL cl_about()

       # ON ACTION help
       #    CALL cl_show_help()
       #####TQC-C30136---mark---end#####

      END INPUT

      INPUT ARRAY g_asp FROM s_asp.*
            ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
            LET g_b_flag = '2'     #TQC-D40025 Add

        BEFORE ROW
            LET p_cmd = ''
            LET l_ac2 = ARR_CURR()
            DISPLAY l_ac2 TO FORMONLY.cn3
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_success = 'Y'
            BEGIN WORK

            IF g_rec_b2>=l_ac2 THEN
               LET p_cmd='u'
               LET g_asp_t.* = g_asp[l_ac2].*  #BACKUP
               OPEN t004_bcl_asp USING g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,
                                       g_asp_t.asp06,g_asp_t.asp07,g_aso11
               IF STATUS THEN
                  CALL cl_err("OPEN t004_bcl_asp:", STATUS, 1)
                  LET l_lock_sw = "Y"
                  CLOSE t004_bcl_asp
                  ROLLBACK WORK

               ELSE

                  FETCH t004_bcl_asp INTO b_asp.*


                  IF SQLCA.sqlcode THEN
                      CALL cl_err('lock asp',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      CALL t004_b_move_to()
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_success = 'N'
               CANCEL INSERT
            END IF
            CALL t004_b_move_back()

            INSERT INTO asp_file VALUES(b_asp.asp01,b_asp.asp02,b_asp.asp03,b_asp.asp04,
                                        b_asp.asp05,b_asp.asp06,b_asp.asp07,b_asp.asp08,
                                        b_asp.asp09,b_asp.asp10,b_asp.asp11,b_asp.asp12,
                                        b_asp.asp13,b_asp.asp14,b_asp.asp15,b_asp.asp16,
                                        b_asp.asp17,b_asp.asp18,b_asp.asp19,b_asp.asp20,
                                        b_asp.asp21,b_asp.asp22,b_asp.asplegal)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'
               CALL cl_err3("ins","asp_file","","",SQLCA.sqlcode,"","ins asp",1)
               CANCEL INSERT
               ROLLBACK WORK
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cn3
               COMMIT WORK
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_asp[l_ac2].* TO NULL
            LET b_asp.asp01=g_aso01
            LET b_asp.asp02=g_aso02
            LET b_asp.asp03=g_aso03
            LET b_asp.asp04=g_aso04
            LET b_asp.asp05=g_aso05
            LET b_asp.asp11=g_aso11
            LET b_asp.asplegal=g_legal
            LET g_asp_t.* = g_asp[l_ac2].*
            CALL cl_show_fld_cont()
            NEXT FIELD asp06

        AFTER FIELD asp06  #被投公司编号
           IF NOT cl_null(g_asp[l_ac2].asp06) THEN
              IF p_cmd = 'a' OR ( g_asp_t.asp06! = g_asp[l_ac2].asp06 OR g_asp_t.asp06 IS NULL) THEN
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM asp_file
                  WHERE asp01 = g_aso01 AND asp02 = g_aso02
                    AND asp03 = g_aso03 AND asp04 = g_aso04
                    AND asp05 = g_aso05 AND asp06 = g_asp[l_ac2].asp06
                    AND asp07 = g_asp[l_ac2].asp07
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_asp[l_ac2].asp06 = g_asp_t.asp06
                    NEXT FIELD asp06
                 END IF
                 SELECT asg01 INTO l_asg01 FROM asg_file WHERE asg08 = g_asp[l_ac2].asp06
                    AND asg01 IN(SELECT asb04 FROM asa_file,asb_file
                                  WHERE asa01 = asb01 AND asa02 = asb02
                                    AND asa03 = asb03 AND asa01 = g_aso03
                                    AND asa02 = g_aso05 )
                 LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM asg_file
                   WHERE asg08 = g_asp[l_ac2].asp06
                 IF l_n<1 THEN
                    LET g_asp[l_ac2].asp06 = g_asp_t.asp06
                    #CALL cl_err('','agl-323',0)     #TQC-C70023  mark
                    CALL cl_err('','agl-452',0)      #TQC-C70023  add
                    NEXT FIELD asp06
                 ELSE
                    SELECT asg02,asg06 INTO g_asp[l_ac2].asp06_desc,g_asp[l_ac2].asp09 FROM asg_file
                     WHERE asg01 = l_asg01
                    DISPLAY BY NAME g_asp[l_ac2].asp06_desc
                    DISPLAY BY NAME g_asp[l_ac2].asp09
                    SELECT azi04 INTO t_azi04_2 FROM azi_file
                     WHERE azi01 = g_asp[l_ac2].asp09
                     CALL s_get_asp14(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                          RETURNING g_asp[l_ac2].asp14
                     CALL s_get_asp14_1(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                          RETURNING g_asp[l_ac2].asp14_1
                    DISPLAY BY NAME g_asp[l_ac2].asp14
                    CALL t004_get_asp10(l_asg01,g_asp[l_ac2].asp07)
                      RETURNING g_asp[l_ac2].asp10,g_asp[l_ac2].asp19
                    CALL t004_get_asp13(g_asp[l_ac2].asp10,g_asp[l_ac2].asp19,g_asp[l_ac2].asp11,g_asp[l_ac2].asp12)
                       RETURNING g_asp[l_ac2].asp13,g_asp[l_ac2].asp20
                    CALL t004_get_asp16(g_asp[l_ac2].asp13,g_asp[l_ac2].asp20,g_asp[l_ac2].asp14,g_asp[l_ac2].asp14_1)
                       RETURNING g_asp[l_ac2].asp16,g_asp[l_ac2].asp21
                 END IF
              END IF
           ELSE
              NEXT FIELD asp06
           END IF

        AFTER FIELD asp07   #所有者权益科目
           IF NOT cl_null(g_asp[l_ac2].asp07) THEN
              IF g_asp[l_ac2].asp07!=g_asp_t.asp07 OR g_asp_t.asp07 IS NULL THEN
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM asp_file
                  WHERE asp01 = g_aso01 AND asp02 = g_aso02
                    AND asp03 = g_aso03 AND asp04 = g_aso04
                    AND asp05 = g_aso05 AND asp06 = g_asp[l_ac2].asp06
                    AND asp07 = g_asp[l_ac2].asp07
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_asp[l_ac2].asp07 = g_asp_t.asp07
                    NEXT FIELD asp07
                 END IF
                 CALL t004_aag('a',g_asp[l_ac2].asp07)
                 IF NOT cl_null(g_errno) THEN
                    LET g_asp[l_ac2].asp07 = g_asp_t.asp07
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD asp07
                 ELSE
                    SELECT asg01 INTO l_asg01 FROM asg_file WHERE asg08 = g_asp[l_ac2].asp06
                       AND asg01 IN(SELECT asb04 FROM asa_file,asb_file
                                     WHERE asa01 = asb01 AND asa02 = asb02
                                      AND asa03 = asb03 AND asa01 = g_aso03
                                       AND asa02 = g_aso05 )
                    SELECT azi04 INTO t_azi04_2 FROM azi_file
                     WHERE azi01 = g_asp[l_ac2].asp09
                    CALL t004_get_asp10(l_asg01,g_asp[l_ac2].asp07)
                      RETURNING g_asp[l_ac2].asp10,g_asp[l_ac2].asp19
                    CALL t004_get_asp13(g_asp[l_ac2].asp10,g_asp[l_ac2].asp19,g_asp[l_ac2].asp11,g_asp[l_ac2].asp12)
                       RETURNING g_asp[l_ac2].asp13,g_asp[l_ac2].asp20
                    CALL t004_get_asp16(g_asp[l_ac2].asp13,g_asp[l_ac2].asp20,g_asp[l_ac2].asp14,g_asp[l_ac2].asp14_1)
                       RETURNING g_asp[l_ac2].asp16,g_asp[l_ac2].asp21
                 END IF
              END IF
           END IF

        AFTER FIELD asp11  #再衡量汇率
           IF NOT cl_null(g_asp[l_ac2].asp11) THEN
              IF g_asp[l_ac2].asp11! = g_asp_t.asp11 OR g_asp_t.asp11 IS NULL THEN
                 IF g_asp[l_ac2].asp11 <0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD asp11
                 ELSE
                    CALL t004_get_asp13(g_asp[l_ac2].asp10,g_asp[l_ac2].asp19,g_asp[l_ac2].asp11,g_asp[l_ac2].asp12)
                       RETURNING g_asp[l_ac2].asp13,g_asp[l_ac2].asp20
                    CALL t004_get_asp16(g_asp[l_ac2].asp13,g_asp[l_ac2].asp20,g_asp[l_ac2].asp14,g_asp[l_ac2].asp14_1)
                       RETURNING g_asp[l_ac2].asp16,g_asp[l_ac2].asp21
                    DISPLAY BY NAME g_asp[l_ac2].asp13
                    DISPLAY BY NAME g_asp[l_ac2].asp20
                    DISPLAY BY NAME g_asp[l_ac2].asp16
                    DISPLAY BY NAME g_asp[l_ac2].asp21
                 END IF
              END IF
           END IF

        AFTER FIELD asp12  #转换汇率
           IF NOT cl_null(g_asp[l_ac2].asp12) THEN
              IF g_asp[l_ac2].asp12! = g_asp_t.asp12 OR g_asp_t.asp12 IS NULL THEN
                 IF g_asp[l_ac2].asp12 <0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD asp12
                 ELSE
                    CALL t004_get_asp13(g_asp[l_ac2].asp10,g_asp[l_ac2].asp19,g_asp[l_ac2].asp11,g_asp[l_ac2].asp12)
                       RETURNING g_asp[l_ac2].asp13,g_asp[l_ac2].asp20
                    CALL t004_get_asp16(g_asp[l_ac2].asp13,g_asp[l_ac2].asp20,g_asp[l_ac2].asp14,g_asp[l_ac2].asp14_1)
                       RETURNING g_asp[l_ac2].asp16,g_asp[l_ac2].asp21
                    DISPLAY BY NAME g_asp[l_ac2].asp13
                    DISPLAY BY NAME g_asp[l_ac2].asp20
                    DISPLAY BY NAME g_asp[l_ac2].asp16
                    DISPLAY BY NAME g_asp[l_ac2].asp21
                 END IF
              END IF
           END IF

        AFTER FIELD asp14   #投资比例%
           IF NOT cl_null(g_asp[l_ac2].asp14) THEN
              IF g_asp[l_ac2].asp14!=g_asp_t.asp14 OR g_asp_t.asp14 IS NULL THEN
                 IF g_asp[l_ac2].asp14<0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD asp14
                 ELSE
                    CALL t004_get_asp16(g_asp[l_ac2].asp13,g_asp[l_ac2].asp20,g_asp[l_ac2].asp14,g_asp[l_ac2].asp14_1)
                       RETURNING g_asp[l_ac2].asp16,g_asp[l_ac2].asp21
                    DISPLAY BY NAME g_asp[l_ac2].asp16
                    DISPLAY BY NAME g_asp[l_ac2].asp21
                 END IF
              END IF
           END IF

        AFTER FIELD asp15  #投资股权科目
           IF NOT cl_null(g_asp[l_ac2].asp15) THEN
              IF g_asp[l_ac2].asp15!=g_asp_t.asp15 OR g_asp_t.asp15 IS NULL THEN
                 CALL t004_aag('a',g_asp[l_ac2].asp15)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD asp15
                 END IF
              END IF
           END IF

        AFTER FIELD asp17  #期初余额调整科目
           IF NOT cl_null(g_asp[l_ac2].asp17) THEN
              IF g_asp[l_ac2].asp17!=g_asp_t.asp17 OR g_asp_t.asp17 IS NULL THEN
                 CALL t004_aag('a',g_asp[l_ac2].asp17)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD asp17
                 END IF
              END IF
           END IF

        AFTER FIELD asp22  #本期发生调整科目
           IF NOT cl_null(g_asp[l_ac2].asp22) THEN
              IF g_asp[l_ac2].asp22!=g_asp_t.asp22 OR g_asp_t.asp22 IS NULL THEN
                 CALL t004_aag('a',g_asp[l_ac2].asp22)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD asp22
                 END IF
              END IF
           END IF
        BEFORE DELETE                            #是否取消單身
            IF  g_asp_t.asp06 IS NOT NULL AND g_asp_t.asp06 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   LET g_success = 'N'
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   LET g_success = 'N'
                   CANCEL DELETE
                END IF
                DELETE FROM asp_file
                 WHERE asp01=g_aso01 AND asp02 = g_aso02 AND asp03 = g_aso03
                   AND asp04=g_aso04 AND asp05 = g_aso05
                   AND asp06=g_asp_t.asp06 AND asp18 = g_aso11
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","asp_file","","",SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                    CANCEL DELETE
                END IF
                IF g_success = 'Y' THEN
                   LET g_rec_b2=g_rec_b2-1
                   DISPLAY g_rec_b2 TO FORMONLY.cn3
                   #IF cl_null(g_asp_t.asp06) THEN
                   #   LET g_rec_b2=g_rec_b2-1
                   #END IF
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                END IF
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_asp[l_ac2].* = g_asp_t.*
               CLOSE t004_bcl_asp
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err('',-263,1)
               LET g_asp[l_ac2].* = g_asp_t.*
               LET g_success='N'
            ELSE
               CALL t004_b_move_back()
               UPDATE asp_file SET * = b_asp.*
                WHERE asp01=g_aso01 AND asp02 = g_aso02 AND asp03 = g_aso03
                  AND asp04=g_aso04 AND asp05 = g_aso05 AND asp06 = g_asp_t.asp06
                  AND asp07=g_asp_t.asp07
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","asp_file","","",SQLCA.sqlcode,"","upd asp",1)
                  LET g_asp[l_ac2].* = g_asp_t.*
                  LET g_success='N'
               END IF
            END IF
            IF g_success = 'Y' THEN
               MESSAGE 'UPDAET O.K'
               COMMIT WORK
            ELSE
               MESSAGE 'UPDATE ERR'
               ROLLBACK WORK
            END IF

        AFTER ROW
            LET l_ac2 = ARR_CURR()
           #LET l_ac2_t = l_ac2       #FUN-D30032 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_asp[l_ac2].* = g_asp_t.*
               END IF
               CLOSE t004_bcl_asp
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            LET l_ac2_t = l_ac2       #FUN-D30032 Add
            CLOSE t004_bcl_asp
            COMMIT WORK

        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(asp06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_asg"
                     LET g_qryparam.default1 = g_asp[l_ac2].asp06
                     CALL cl_create_qry() RETURNING g_asp[l_ac2].asp06
                     DISPLAY BY NAME g_asp[l_ac2].asp06
                     NEXT FIELD asp06
                WHEN INFIELD(asp07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_asp[l_ac2].asp07
                     LET g_qryparam.arg1 = g_aso11
                     CALL cl_create_qry() RETURNING g_asp[l_ac2].asp07
                     DISPLAY BY NAME g_asp[l_ac2].asp07
                     NEXT FIELD asp07
                WHEN INFIELD(asp15)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_asp[l_ac2].asp15
                     LET g_qryparam.arg1 = g_aso11
                     CALL cl_create_qry() RETURNING g_asp[l_ac2].asp15
                     DISPLAY BY NAME g_asp[l_ac2].asp15
                     NEXT FIELD asp15
               WHEN INFIELD(asp17)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_asp[l_ac2].asp17
                     LET g_qryparam.arg1 = g_aso11
                     CALL cl_create_qry() RETURNING g_asp[l_ac2].asp17
                     DISPLAY BY NAME g_asp[l_ac2].asp17
                     NEXT FIELD asp17
               WHEN INFIELD(asp22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_asp[l_ac2].asp22
                     LET g_qryparam.arg1 = g_aso11
                     CALL cl_create_qry() RETURNING g_asp[l_ac2].asp22
                     DISPLAY BY NAME g_asp[l_ac2].asp22
                     NEXT FIELD asp22
               OTHERWISE EXIT CASE
            END CASE
   #####TQC-C30136---mark---str#####
   #    ON ACTION CONTROLF         #
   #     CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
   #     CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
   #-------------------------------#
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
   #-------------------------------#
   #  ON ACTION about              #
   #     CALL cl_about()           #
   #####TQC-C30136---mark---end#####
      END INPUT

      #TQC-D40025--add--begin--
      BEFORE DIALOG
         CASE g_b_flag
              WHEN '1' NEXT FIELD aso06 
              WHEN '2' NEXT FIELD asp06
         END CASE
      #TQC-D40025--add--end--

      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         #TQC-D40025--------ADD----STR
         LET INT_FLAG = 0
         IF g_b_flag = '1' THEN
             IF p_cmd = 'u' THEN
                LET g_aso[l_ac1].* = g_aso_t.*
             ELSE
                CALL g_aso.deleteElement(l_ac1)
                IF g_rec_b1 != 0 THEN
                   LET g_action_choice = "detail"
                END IF
             END IF
             CLOSE t004_bcl
             ROLLBACK WORK
         END IF
         IF g_b_flag = '2' THEN
            IF p_cmd = 'u' THEN
               LET g_asp[l_ac2].* = g_asp_t.*
            ELSE 
               CALL g_asp.deleteElement(l_ac2)
               IF g_rec_b2 != 0 THEN
                  LET g_action_choice = "detail"
               END IF
            END IF
            CLOSE t004_bcl_asp
            ROLLBACK WORK
         END IF
         #TQC-D40025--------ADD----END
         EXIT DIALOG


       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

    END DIALOG

    CLOSE t004_bcl
    CLOSE t004_bcl_asp
    COMMIT WORK
    CALL t004_show()
END FUNCTION

FUNCTION t004_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc          LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(200)

    IF cl_null(p_wc) THEN LET p_wc = " 1=1" END IF
    LET g_sql = "SELECT aso06,aso07,aso08 FROM aso_file ",
                " WHERE aso01 = '",g_aso01,"' AND aso02 = '",g_aso02,"'",
                "   AND aso03 = '",g_aso03,"' AND aso04 = '",g_aso04,"'",
                "   AND aso05 = '",g_aso05,"' AND aso11 = '",g_aso11,"'",
                "   AND ",p_wc CLIPPED,                     #單身
                " ORDER BY aso06"

    PREPARE t004_pb FROM g_sql
    DECLARE aso_curs                       #SCROLL CURSOR
        CURSOR FOR t004_pb
    CALL g_aso.clear()
    LET g_rec_b1 = 0
    LET g_cnt = 1
    FOREACH aso_curs INTO g_aso[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aso.deleteElement(g_cnt)
    LET g_rec_b1=g_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
     CALL t004_bp_refresh()
END FUNCTION


FUNCTION t004_b_fill2(p_wc2)
DEFINE p_wc2    LIKE type_file.chr1000
DEFINE l_asg01  LIKE asg_file.asg01
    IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF
    LET g_sql = "SELECT asp06,'',asp08,asp07,asp09,asp10,asp19,asp11,asp12,",
                "       asp13,asp20,'',asp14,asp15,asp16,asp21,asp17,asp22 ",
                "  FROM asp_file WHERE asp01 = '",g_aso01,"'",
                "   AND asp02 = '",g_aso02,"' AND asp03 = '",g_aso03,"'",
                "   AND asp04 = '",g_aso04,"'",
                "   AND asp05 = '",g_aso05,"' AND asp18 = '",g_aso11,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY asp06"
    PREPARE t004_pb_2 FROM g_sql
    DECLARE t004_asp_curs CURSOR FOR t004_pb_2
    CALL g_asp.clear()
    LET g_rec_b2 = 0
    LET g_cnt = 1
    FOREACH t004_asp_curs INTO g_asp[g_cnt].*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT asg02 INTO g_asp[g_cnt].asp06_desc FROM asg_file WHERE asg01 = g_asp[g_cnt].asp06
       SELECT asg01 INTO l_asg01 FROM asg_file WHERE asg08 = g_asp[g_cnt].asp06
          AND asg01 IN(SELECT asb04 FROM asa_file,asb_file
                        WHERE asa01 = asb01 AND asa02 = asb02
                          AND asa03 = asb03 AND asa01 = g_aso03
                          AND asa02 = g_aso05 )
       CALL s_get_asp14_1(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
            RETURNING g_asp[g_cnt].asp14_1
       LET g_cnt = g_cnt +1
       IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_asp.deleteElement(g_cnt)
    LET g_rec_b2=g_cnt - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    CALL t004_bp_refresh_2()
END FUNCTION

FUNCTION t004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680123 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)

   DISPLAY ARRAY g_aso TO s_aso.* ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='1'

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()


      AFTER DISPLAY
        CONTINUE DIALOG

   END DISPLAY
   DISPLAY ARRAY g_asp TO s_asp.* ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='2'

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()

      AFTER DISPLAY
        CONTINUE DIALOG

   END DISPLAY

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      #ON ACTION modify
      #   LET g_action_choice="modify"
      #   EXIT DIALOG

      ON ACTION first
         CALL t004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_asp",1)
         END IF
         EXIT DIALOG

      ON ACTION previous
         CALL t004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_asp",1)
         END IF
	 EXIT DIALOG

      ON ACTION jump
         CALL t004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_asp",1)
         END IF
	 EXIT DIALOG

      ON ACTION next
         CALL t004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_asp",1)
         END IF
   	 EXIT DIALOG

      ON ACTION last
         CALL t004_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_asp",1)
         END IF
	 EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG
         LET l_ac1 = 1

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      #FUN-D30032----Add---Str
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DIALOG
      #FUN-D30032----Add---End 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION gen_entry #调整分錄產生
         LET g_action_choice="gen_entry"
         EXIT DIALOG

      ON ACTION qry_sheet #查询调整分录
         LET g_action_choice="qry_sheet"
         EXIT DIALOG


      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac1 = ARR_CURR()
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DIALOG


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      #--
      &include "qry_string.4gl"
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t004_bp_refresh()

   #FUN-640246
   IF g_bgjob = 'Y' THEN
      RETURN
   END IF
   #END FUN-640246

   DISPLAY ARRAY g_aso TO s_aso.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


   END DISPLAY
END FUNCTION

FUNCTION t004_b_move_to()
   LET g_asp[l_ac2].asp06 = b_asp.asp06
   SELECT asg02 INTO g_asp[l_ac2].asp06_desc FROM asp_file
    WHERE asa01 = g_asp[l_ac2].asp06
   LET g_asp[l_ac2].asp07 = b_asp.asp07
   LET g_asp[l_ac2].asp08 = b_asp.asp08
   LET g_asp[l_ac2].asp09 = b_asp.asp09
   LET g_asp[l_ac2].asp10 = b_asp.asp10
   LET g_asp[l_ac2].asp11 = b_asp.asp11
   LET g_asp[l_ac2].asp12 = b_asp.asp12
   LET g_asp[l_ac2].asp13 = b_asp.asp13
   LET g_asp[l_ac2].asp14 = b_asp.asp14
   LET g_asp[l_ac2].asp15 = b_asp.asp15
   LET g_asp[l_ac2].asp16 = b_asp.asp16
   LET g_asp[l_ac2].asp17 = b_asp.asp17
   LET g_asp[l_ac2].asp19 = b_asp.asp19
   LET g_asp[l_ac2].asp20 = b_asp.asp20
   LET g_asp[l_ac2].asp21 = b_asp.asp21
   LET g_asp[l_ac2].asp22 = b_asp.asp22
END FUNCTION

FUNCTION t004_b_move_back()
   INITIALIZE b_asp.* TO NULL
   LET b_asp.asp01 = g_aso01
   LET b_asp.asp02 = g_aso02
   LET b_asp.asp03 = g_aso03
   LET b_asp.asp04 = g_aso04
   LET b_asp.asp05 = g_aso05
   LET b_asp.asp06 = g_asp[l_ac2].asp06
   LET b_asp.asp07 = g_asp[l_ac2].asp07
   SELECT asg08 INTO b_asp.asp08 FROM asg_file
    WHERE asg01 = g_aso05
   LET b_asp.asp09 = g_asp[l_ac2].asp09
   LET b_asp.asp10 = g_asp[l_ac2].asp10
   LET b_asp.asp11 = g_asp[l_ac2].asp11
   LET b_asp.asp12 = g_asp[l_ac2].asp12
   LET b_asp.asp13 = g_asp[l_ac2].asp13
   LET b_asp.asp14 = g_asp[l_ac2].asp14
   LET b_asp.asp15 = g_asp[l_ac2].asp15
   LET b_asp.asp16 = g_asp[l_ac2].asp16
   LET b_asp.asp17 = g_asp[l_ac2].asp17
   LET b_asp.asp18 = g_aso11
   LET b_asp.asp19 = g_asp[l_ac2].asp19
   LET b_asp.asp20 = g_asp[l_ac2].asp20
   LET b_asp.asp21 = g_asp[l_ac2].asp21
   LET b_asp.asp22 = g_asp[l_ac2].asp22
   LET b_asp.asplegal = g_legal
END FUNCTION


FUNCTION t004_bp_refresh_2()

   IF g_bgjob = 'Y' THEN
      RETURN
   END IF

   DISPLAY ARRAY g_asp TO s_asp.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()


   END DISPLAY
END FUNCTION


FUNCTION t004_aso03(p_cmd)  #族群编号
   DEFINE p_cmd     LIKE type_file.chr1

   LET g_errno = ' '

   SELECT asa02 INTO g_aso04
     FROM asa_file WHERE asa01 = g_aso03
      AND asa04 = 'Y'

   CASE WHEN SQLCA.sqlcode = 100      LET g_errno = 'agl-246'
     OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY g_aso04 TO aso04
   END IF
END FUNCTION

FUNCTION t004_aac01(p_t1)
   DEFINE l_aacacti   LIKE aac_file.aacacti
   DEFINE l_aac11     LIKE aac_file.aac11
   DEFINE p_t1        LIKE aac_file.aac01

   LET g_errno = ' '
   SELECT aacacti INTO l_aacacti FROM aac_file
    WHERE aac01 = p_t1

   CASE  WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-035'
         WHEN l_aacacti = 'N'      LET g_errno = 'agl-321'
         WHEN l_aac11<>'Y'         LET g_errno = 'agl-322'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION t004_aag(p_cmd,p_aag01)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE p_aag01   LIKE aag_file.aag01
DEFINE l_aag02   LIKE aag_file.aag02
DEFINE l_aagacti LIKE aag_file.aagacti
DEFINE l_aag07   LIKE aag_file.aag07


   LET g_errno = ' '
   SELECT aag02,aag07,aagacti INTO l_aag02,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag00 = g_aso11 AND aag01 = p_aag01
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
        WHEN l_aagacti = 'N'     LET g_errno = '9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
        OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE

END FUNCTION

FUNCTION t004_v()
DEFINE l_asj RECORD LIKE asj_file.*
DEFINE l_ask RECORD LIKE ask_file.*
DEFINE l_asp RECORD LIKE asp_file.*
DEFINE l_asp06_t LIKE asp_file.asp06
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_aso08   LIKE aso_file.aso08
DEFINE li_result LIKE type_file.num5
DEFINE l_asj11   LIKE asj_file.asj11
DEFINE l_asj12   LIKE asj_file.asj12
DEFINE l_asg08   LIKE asg_file.asg08
DEFINE g_t1      LIKE aac_file.aac01
DEFINE i         LIKE type_file.num5
#FUN-B90057--add--str--
DEFINE l_amt     LIKE asp_file.asp15
DEFINE l_asp06   LIKE asp_file.asp06
DEFINE l_asp15   LIKE asp_file.asp15
#FUN-B90057--add-end

   SELECT COUNT(*) INTO l_cnt FROM asj_file
    WHERE asj00 = g_aso11 AND asj00 = g_aso11 AND asj01 = g_aso10
   IF l_cnt > 0 THEN
      IF NOT s_ask_entry(g_aso10) THEN RETURN END IF #Genero
   END IF
   DELETE FROM asj_file WHERE asj00 = g_aso11 AND asj01 = g_aso10
   DELETE FROM ask_file WHERE ask00 = g_aso11 AND ask01 = g_aso10

   LET p_row = 12 LET p_col = 10
   OPEN WINDOW t0041_w AT 14,10 WITH FORM "ggl/42f/gglt1021"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("gglt1021")
   INPUT g_t1 WITHOUT DEFAULTS FROM aac01
     AFTER FIELD aac01
        IF NOT cl_null(g_t1) THEN
           CALL t004_aac01(g_t1)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('aac01',g_errno,0)
              NEXT FIELD aac01
           END IF
        ELSE
           NEXT FIELD aac01
        END IF
     ON ACTION CONTROLP
         CASE WHEN INFIELD(aac01)
              CALL q_aac(FALSE,TRUE,g_t1,'A','','','GGL') RETURNING g_t1
              DISPLAY g_t1 TO aac01
              NEXT FIELD aac01
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT

   CLOSE WINDOW t0041_w                 #結束畫面
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   INITIALIZE l_asj.* TO NULL
   INITIALIZE l_ask.* TO NULL
   INITIALIZE l_asp.* TO NULL
   CALL s_showmsg_init()
   LET g_success = 'Y'
   BEGIN WORK
  #CALL s_auto_assign_no("GGL",g_t1,g_today,"","asj_file","asj01",g_plant,2,g_aso11)  #carrier 20111024
   CALL s_auto_assign_no("AGL",g_t1,g_today,"","asj_file","asj01",g_plant,2,g_aso11)  #carrier 20111024
               RETURNING li_result,l_asj.asj01
   IF (NOT li_result) THEN
      CALL s_errmsg('asj_file','asj01',l_asj.asj01,'abm-621',1)
      LET g_success = 'N'
   END IF
   ####产生调整分录单头档
   LET l_asj.asj00 = g_aso11
   LET l_asj.asj02 = g_today
   LET l_asj.asj03 = g_aso01
   LET l_asj.asj04 = g_aso02
   LET l_asj.asj05 = g_aso03
   LET l_asj.asj06 = g_aso05
   SELECT asg05 INTO l_asj.asj07
     FROM asg_file WHERE asg01 = l_asj.asj06
   LET l_asj.asj08 = '1'  #调整作业
   LET l_asj.asj081= 'U'
   LET l_asj.asj11 = 0    #单身产生后回写
   LET l_asj.asj21 = '00' #版本
   LET l_asj.asj12 = 0    #单身产生后回写
   LET l_asj.asjconf = 'Y'
   LET l_asj.asjuser = g_user
   LET l_asj.asjgrup = g_grup
   LET l_asj.asjlegal=g_legal  #所属法人

   #FUN-B80135--add--str--
    IF l_asj.asj03 < g_year OR (l_asj.asj03 = g_year AND l_asj.asj04<=g_month) THEN
       CALL cl_err('','atp-164',0)
       LET g_success='N'
       RETURN
      END IF
      #FUN-B80135--add--end

   #No.TQC-C90057  --Begin
   IF cl_null(l_asj.asj09) THEN LET l_asj.asj09 = 'N' END IF
   IF cl_null(l_asj.asj11) THEN LET l_asj.asj11 =  0  END IF
   IF cl_null(l_asj.asj12) THEN LET l_asj.asj12 =  0  END IF
   #No.TQC-C90057  --End

   INSERT INTO asj_file VALUES(l_asj.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('asj_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #FUN-B90057--add--str--
   LET l_ask.ask01 = l_asj.asj01
   LET l_ask.ask00 = l_asj.asj00
   LET g_sql = "SELECT SUM(asp16+asp21),asp06,asp15 FROM asp_file ",
               " WHERE asp01 = '",g_aso01,"' AND asp02 = '",g_aso02,"'",
               "   AND asp03 = '",g_aso03,"' AND asp04 = '",g_aso04,"'",
               "   AND asp05 = '",g_aso05,"' AND asp18 = '",g_aso11,"'",
               " GROUP BY asp06,asp15",
               " ORDER BY asp06,asp15"
   PREPARE sel_asp_pre FROM g_sql
   DECLARE sel_asp_curs CURSOR FOR sel_asp_pre
   FOREACH sel_asp_curs INTO l_amt,l_asp06,l_asp15
       IF STATUS THEN
          CALL s_errmsg('asp_file','foreach','',STATUS,1)
          LET g_success = 'N'
       END IF
       SELECT MAX(ask02+1) INTO l_ask.ask02 FROM ask_file
        WHERE ask00 = l_asj.asj00 AND ask01 = l_ask.ask01
       IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 = 1 END IF
       LET l_ask.ask03 = l_asp15
       LET l_ask.ask05 = l_asp06
       LET l_ask.ask06 = '1'
       SELECT aso08 INTO l_aso08 FROM aso_file WHERE aso01 = g_aso01
          AND aso02 = g_aso02 AND aso03 = g_aso03 AND aso04 = g_aso04
          AND aso05 = g_aso05 AND aso06 = l_asp15 AND aso07 = l_asp06
       IF cl_null(l_aso08) THEN LET l_aso08 = 0 END IF
       LET l_ask.ask07 = l_amt-l_aso08
       LET l_ask.asklegal = g_legal
       INSERT INTO ask_file VALUES(l_ask.*)    ##借方
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
       SELECT MAX(ask02+1) INTO l_ask.ask02 FROM ask_file
        WHERE ask00 = l_asj.asj00 AND ask01 = l_ask.ask01
       IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 = 1 END IF
       LET l_ask.ask06 = '2'
       LET l_ask.ask03 = g_asz.asz14    ###投資收益
       INSERT INTO ask_file VALUES(l_ask.*)    ##借方
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
   END FOREACH
   #FUN-B90057--add--end
#FUN-B90057--mark--str--
#  LET g_sql = "SELECT * FROM asp_file ",
#              " WHERE asp01 = '",g_aso01,"' AND asp02 = '",g_aso02,"'",
#              "   AND asp03 = '",g_aso03,"' AND asp04 = '",g_aso04,"'",
#              "   AND asp05 = '",g_aso05,"' AND asp18 = '",g_aso11,"'",
#              " ORDER BY asp06,asp07"
#  PREPARE sel_asp_pre FROM g_sql
#  DECLARE sel_asp_curs CURSOR FOR sel_asp_pre
#  FOREACH sel_asp_curs INTO l_asp.*
#      IF STATUS THEN
#         CALL s_errmsg('asp_file','foreach','',STATUS,1)
#         LET g_success = 'N'
#      END IF
#      LET l_ask.ask01 = l_asj.asj01
#      LET l_ask.ask00 = l_asj.asj00
#      LET l_asg08 = l_asp.asp06
#      LET l_ask.ask05 = l_asp.asp06
#      LET l_cnt = 0
#      SELECT COUNT(*) INTO l_cnt FROM ask_file WHERE ask00 = l_ask.ask00
#         AND ask01 = l_ask.ask01 AND ask06 = '1'  #借方
#         AND ask03 = l_asp.asp15
#         AND ask05 = l_asg08
#      IF l_cnt>0 THEN   #相同子公司相同投资公司股权科目借方金额才汇总
#         UPDATE ask_file SET ask07 = ask07+l_asp.asp16+l_asp.asp21
#          WHERE ask00 = l_ask.ask00 AND ask01 = l_ask.ask01
#            AND ask06 = '1' AND ask03 = l_asp.asp15
#            AND ask05 = l_asg08
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#            CALL s_errmsg('ask_file','update',l_asj.asj01,SQLCA.sqlcode,1)
#            LET g_success = 'N'
#         END IF
#         FOR i= 1 TO 2
#            ######贷方要新增
#            SELECT max(ask02) INTO l_ask.ask02 FROM ask_file
#             WHERE ask01 = l_ask.ask01 AND ask00 = l_ask.ask00
#            IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 =0 END IF
#            LET l_ask.ask02 = l_ask.ask02+1
#            LET l_ask.ask06 = '2'
#            IF i = 1 THEN
#               LET l_ask.ask07 = l_asp.asp16
#               LET l_ask.ask03 = l_asp.asp17
#            ELSE
#               LET l_ask.ask07 = l_asp.asp21
#               LET l_ask.ask03 = l_asp.asp22
#            END IF
#            IF l_ask.ask07 = 0 THEN CONTINUE FOR END IF
#             LET l_ask.asklegal=g_legal   #所属法人
#            INSERT INTO ask_file VALUES(l_ask.*)
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#               CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
#               LET g_success = 'N'
#            END IF
#         END FOR
#      ELSE
#         ######借方
#         SELECT max(ask02) INTO l_ask.ask02 FROM ask_file
#          WHERE ask01 = l_ask.ask01 AND ask00 = l_ask.ask00
#         IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 =0 END IF
#         LET l_ask.ask02 = l_ask.ask02+1
#         LET l_ask.ask03 = l_asp.asp15
#         LET l_ask.ask06 = '1'
#         LET l_aso08 = 0
#         SELECT aso08 INTO l_aso08 FROM aso_file WHERE aso01 = g_aso01
#            AND aso02 = g_aso02 AND aso03 = g_aso03 AND aso04 = g_aso04
#            AND aso05 = g_aso05 AND aso06 = l_asp.asp15 AND aso07 = l_asp.asp06
#         IF cl_null(l_aso08) THEN LET l_aso08 = 0 END IF
#         LET l_ask.ask07 = l_asp.asp16+l_asp.asp21-l_aso08
#         LET l_ask.asklegal = g_legal
#         INSERT INTO ask_file VALUES(l_ask.*)
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#            CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
#            LET g_success = 'N'
#         END IF

#         FOR i= 1 TO 2
#            #贷方
#            LET l_ask.ask06 = '2'
#            SELECT max(ask02) INTO l_ask.ask02 FROM ask_file
#             WHERE ask01 = l_ask.ask01 AND ask00 = l_ask.ask00
#            IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 =1 END IF
#            LET l_ask.ask02 = l_ask.ask02+1
#            IF i = 1 THEN
#               LET l_ask.ask03 = l_asp.asp17
#               LET l_ask.ask07 = l_asp.asp16-l_aso08
#            ELSE
#               LET l_ask.ask03 = l_asp.asp22
#               LET l_ask.ask07 = l_asp.asp21
#            END IF
#            IF l_ask.ask07 = 0 THEN CONTINUE FOR END IF
#            LET l_ask.asklegal=g_legal     #所属法人
#            INSERT INTO ask_file VALUES(l_ask.*)
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#               CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
#               LET g_success = 'N'
#            END IF
#         END FOR
#      ####INSERT
#      END IF
#  END FOREACH
#FUN-B90057--mark--end
   #UPDATE asj_file  借方总金额,贷方总金额
   SELECT SUM(ask07) INTO l_asj11 FROM ask_file WHERE ask00 = l_asj.asj00
      AND ask01 = l_asj.asj01 AND ask06 = '1'   #借方
   SELECT SUM(ask07) INTO l_asj12 FROM ask_file WHERE ask00 = l_asj.asj00
      AND ask01 = l_asj.asj01 AND ask06 = '2'   #贷方
   IF cl_null(l_asj11) THEN LET l_asj11 = 0 END IF
   IF cl_null(l_asj12) THEN LET l_asj12 = 0 END IF
   UPDATE asj_file SET asj11 = l_asj11,
                       asj12 = l_asj12
    WHERE asj00 = l_asj.asj00
      AND asj01 = l_asj.asj01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('asj_file','update',l_asj.asj01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   UPDATE aso_file SET aso10 = l_asj.asj01
    WHERE aso01 = g_aso01 AND aso02 = g_aso02 AND aso03 = g_aso03
      AND aso04 = g_aso04 AND aso05 = g_aso05 AND aso11 = g_aso11
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('aso_file','update',l_asj.asj01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_aso10 = l_asj.asj01
      DISPLAY g_aso10 TO aso10
   ELSE
      CALL s_showmsg()
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t004_get_aso08()
DEFINE l_aso08 LIKE aso_file.aso08

    SELECT SUM(asn08-asn09) INTO l_aso08 FROM asn_file
     WHERE asn01 = g_aso03 AND asn02 = g_aso05
       AND asn04 = g_aso[l_ac1].aso06
       AND asn05 = g_aso[l_ac1].aso07
      #No.FUN-C80020  --Begin
       AND asn20 = g_aso01
       AND asn21 = g_aso02
      #No.FUN-C80020  --End
       AND asn06 = g_aso01 AND asn07 <= g_aso02
   IF cl_null(l_aso08) THEN
      LET g_aso[l_ac1].aso08 = 0
   ELSE
      CALL cl_digcut(l_aso08,t_azi04_1) RETURNING l_aso08
      LET g_aso[l_ac1].aso08 = l_aso08
   END IF

END FUNCTION

FUNCTION t004_get_asp10(p_asp06,p_asp07)
DEFINE p_asp06 LIKE asp_file.asp06   #被投资公司
DEFINE p_asp07 LIKE asp_file.asp07   #所有者权益科目
DEFINE l_asp10 LIKE asp_file.asp10   #期初金额
DEFINE l_asp19 LIKE asp_file.asp19   #本期发生额
DEFINE l_amt0  LIKE asp_file.asp19
DEFINE l_amt1  LIKE asp_file.asp19

   SELECT SUM(asm08-asm07) INTO l_asp10 FROM asm_file   #期初余额
    WHERE asm01 = g_aso03 AND asm02 = p_asp06
      AND asm04 = p_asp07 AND asm05 = g_aso01
      #No.FUN-C80020  --Begin
      AND asm20 = g_aso01
      AND asm21 = g_aso02
      #No.FUN-C80020  --End
      AND asm06 = 0     #期别
   IF cl_null(l_asp10) THEN
      SELECT SUM(asi09-asi08) INTO l_asp10 FROM asi_file
       WHERE asi01 = g_aso03 AND asi04= p_asp06
         AND asi05 = p_asp07 AND asi06 = g_aso01-1
         AND asi07  = 12  #期别
   END IF
   IF cl_null(l_asp10) THEN LET l_asp10 = 0 END IF
   SELECT SUM(asm08-asm07) INTO l_asp19 FROM asm_file  #本期发生额
    WHERE asm01 = g_aso03 AND asm02 = p_asp06
      AND asm04 = p_asp07 AND asm05 = g_aso01
      #No.FUN-C80020  --Begin
      AND asm20 = g_aso01
      AND asm21 = g_aso02
      #No.FUN-C80020  --End
      AND asm06 BETWEEN 0 AND g_aso02     #期别
   LET l_asp19 = l_asp19-l_asp10
   IF cl_null(l_asp19) THEN
      SELECT SUM(asi09-asi08) INTO l_amt0 FROM asi_file
       WHERE asi01 = g_aso03 AND asi04= p_asp06
         AND asi05 = p_asp07 AND asi06 = g_aso01-1
         AND asi07  = 12  #期别
      IF cl_null(l_amt0) THEN LET l_amt0 = 0 END IF
      SELECT SUM(asi09-asi08) INTO l_amt1 FROM asi_file
       WHERE asi01 = g_aso03 AND asi04= p_asp06
         AND asi05 = p_asp07 AND asi06 = g_aso01
         AND asi07  = g_aso02  #期别
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
      LET l_asp19 = l_amt1-l_amt0
   END IF
   IF cl_null(l_asp10) THEN LET l_asp10 = 0 END IF
   IF cl_null(l_asp19) THEN LET l_asp19 = 0 END IF
   CALL cl_digcut(l_asp10,t_azi04_2) RETURNING l_asp10
   CALL cl_digcut(l_asp19,t_azi04_2) RETURNING l_asp19

   RETURN l_asp10,l_asp19
END FUNCTION

FUNCTION t004_get_asp13(p_asp10,p_asp19,p_asp11,p_asp12)
DEFINE p_asp10 LIKE asp_file.asp10
DEFINE p_asp19 LIKE asp_file.asp19
DEFINE p_asp11 LIKE asp_file.asp11
DEFINE p_asp12 LIKE asp_file.asp12
DEFINE l_asp13 LIKE asp_file.asp13
DEFINE l_asp20 LIKE asp_file.asp20

  IF cl_null(p_asp11) THEN LET p_asp11 = 0 END IF
  IF cl_null(p_asp12) THEN LET p_asp12 = 0 END IF
  LET l_asp13 = p_asp10*p_asp11*p_asp12
  LET l_asp20 = p_asp19*p_asp11*p_asp12
  CALL cl_digcut(l_asp13,t_azi04_1) RETURNING l_asp13
  CALL cl_digcut(l_asp20,t_azi04_1) RETURNING l_asp20

  RETURN l_asp13,l_asp20
END FUNCTION

FUNCTION t004_get_asp16(p_asp13,p_asp20,p_asp14,p_asp14_1)
DEFINE p_asp13 LIKE asp_file.asp13
DEFINE p_asp20 LIKE asp_file.asp20
DEFINE p_asp14 LIKE asp_file.asp14
DEFINE p_asp14_1 LIKE asp_file.asp14
DEFINE l_asp16 LIKE asp_file.asp16
DEFINE l_asp21 LIKE asp_file.asp21

  IF cl_null(p_asp14) THEN LET p_asp14 = 0 END IF
  IF cl_null(p_asp14_1) THEN LET p_asp14_1 = 0 END IF
  #LET l_asp16 = p_asp13*p_asp14/100
  LET l_asp16 = p_asp13*p_asp14_1/100
  #LET l_asp21 = p_asp20*p_asp14/100
  LET l_asp21 = (p_asp13+p_asp20)*p_asp14/100-l_asp16
  IF cl_null(l_asp16) THEN LET l_asp16 = 0 END IF
  IF cl_null(l_asp21) THEN LET l_asp21 = 0 END IF
  CALL cl_digcut(l_asp16,t_azi04_1) RETURNING l_asp16
  CALL cl_digcut(l_asp21,t_azi04_1) RETURNING l_asp21

  RETURN l_asp16,l_asp21
END FUNCTION
FUNCTION t004_g_b()   #自动生成单身
DEFINE g_asb04 DYNAMIC ARRAY OF LIKE asb_file.asb04
DEFINE g_aag01 DYNAMIC ARRAY OF LIKE aag_file.aag01      #记录长期股权投资科目
#DEFINE g_aag01_1 DYNAMIC ARRAY OF LIKE aag_file.aag01    #记录所有者权益类科目
DEFINE g_aag01_1 DYNAMIC ARRAY OF RECORD
                 aag01 LIKE aag_file.aag01,
                 aag19 LIKE aag_file.aag19
                 END RECORD
DEFINE l_cnt1  LIKE type_file.num5
DEFINE l_cnt2  LIKE type_file.num5
DEFINE l_cnt3  LIKE type_file.num5
DEFINE l_cnt4  LIKE type_file.num5
DEFINE i       LIKE type_file.num5
DEFINE l_asg08 LIKE asg_file.asg08
DEFINE l_asg01 LIKE asg_file.asg01
DEFINE l_asb06 LIKE asb_file.asb06      # No.FUN-B60134
DEFINE l_asii  RECORD LIKE asii_file.*  # No.FUN-B60134
DEFINE l_aag19 LIKE aag_file.aag19      # No.FUN-B60134
DEFINE l_asa02 LIKE asa_file.asa02      # NO.FUN-B60134
DEFINE l_asa07 LIKE asa_file.asa07      # No.FUN-B90018

    IF NOT cl_confirm('agl-443') THEN  RETURN END IF
    SELECT azi04 INTO t_azi04_1 FROM azi_file
                      WHERE azi01 = g_aso09
    BEGIN WORK
    LET g_success = 'Y'
    CALL s_showmsg_init()
    #####1.所有下属公司
    LET l_cnt1 = 1
    LET l_cnt3 = 1
    LET g_sql = " SELECT asb04 FROM asb_file ",
                "  WHERE asb01 = '",g_aso03,"'",
                "    AND asb02 = '",g_aso05,"'"
    PREPARE sel_asb04 FROM g_sql
    DECLARE sel_asb04_cur CURSOR FOR sel_asb04
    FOREACH sel_asb04_cur INTO g_asb04[l_cnt1]    #子公司编号
       IF STATUS THEN
          CALL s_errmsg(' ',' ','foreah',STATUS,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       ####2.产生第一单身
       LET l_cnt2 = 1
       LET g_sql = "SELECT aag01 FROM aag_file ",
                   " WHERE aag00 = '",g_aso11,"'",
                   "   AND aag07 IN ('2','3')",
                   #"   AND aag19 = '",9,"'"      #长期股权投资
                   "   AND aag19 IN ('10','35') "      #长期股权投资
       PREPARE sel_aag01_pre FROM g_sql
       DECLARE sel_aag01_cur CURSOR FOR sel_aag01_pre
       FOREACH sel_aag01_cur INTO g_aag01[l_cnt2]
          IF STATUS THEN
             CALL s_errmsg(' ',' ','foreah',STATUS,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          LET g_aso[l_cnt3].aso06 = g_aag01[l_cnt2]
          SELECT asg08 INTO g_aso[l_cnt3].aso07
            FROM asg_file
           WHERE asg01 = g_asb04[l_cnt1]
          LET g_aso[l_cnt3].aso08 = 0
          SELECT SUM(asn08-asn09) INTO g_aso[l_cnt3].aso08 FROM asn_file
           WHERE asn01 = g_aso03 AND asn02 = g_aso05
             AND asn04 = g_aso[l_cnt3].aso06
             AND asn05 = g_aso[l_cnt3].aso07
             #No.FUN-C80020  --Begin
             AND asn20 = g_aso01
             AND asn21 = g_aso02
             #No.FUN-C80020  --End
             AND asn06 = g_aso01 AND asn07 <= g_aso02
          IF cl_null(g_aso[l_cnt3].aso08) THEN
             LET g_aso[l_cnt3].aso08 = 0
             CONTINUE FOREACH
          ELSE
             CALL cl_digcut(g_aso[l_cnt3].aso08,t_azi04_1) RETURNING g_aso[l_cnt3].aso08
          END IF
          INSERT INTO aso_file(aso01,aso02,aso03,aso04,aso05,aso06,aso07,aso08,aso09,aso10,aso11,asolegal)
                        VALUES(g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_aso[l_cnt3].aso06,
                               g_aso[l_cnt3].aso07,g_aso[l_cnt3].aso08,g_aso09,
                               g_aso10,g_aso11,g_legal)
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_success = 'N'
             LET g_showmsg=g_aso05,"/",g_aso[l_cnt3].aso06
             CALL s_errmsg('aso05,aso06',g_showmsg,'ins aso',SQLCA.sqlcode,1)
          ELSE
             LET g_success = 'Y'
          END IF
          LET l_cnt2 = l_cnt2+1
          LET l_cnt3 = l_cnt3+1
       END FOREACH
       LET l_cnt1 = l_cnt1+1
    END FOREACH
    CALL g_aso.deleteElement(l_cnt3)
    ####3.产生第二单身
    LET l_cnt2 = 1
    LET l_cnt4 = 1
    FOR i = 1 TO g_aso.getLength()
        IF i>1 THEN
           IF g_aso[i].aso07 = g_aso[i-1].aso07 THEN CONTINUE FOR END IF
        END IF
        SELECT asa07 INTO l_asa07 FROM asa_file WHERE asa01 = g_aso03   #FUN-B90018
      # FUN-B60134--add--str--
      # SELECT asa02 INTO l_asa02 FROM asa_file WHERE asa01 = g_aso03 AND asa04 = 'Y'   #FUN-B90018
        SELECT asg01 INTO l_asg01 FROM asg_file WHERE asg08 = g_aso[i].aso07
           AND asg01 IN(SELECT asb04 FROM asa_file,asb_file
                         WHERE asa01 = asb01 AND asa02 = asb02
                           AND asa03 = asb03 AND asa01 = g_aso03
                           AND asa02 = g_aso05 )
        SELECT asb06 INTO l_asb06 FROM asb_file WHERE asb01 = g_aso03
          #AND asb04 = l_asg01 AND asb02 = l_asa02   #FUN-B90018
           AND asb04 = l_asg01 AND asb02 = g_aso05   #FUN-B90018
       #IF l_asb06 = 'N' THEN   #FUN-B90018
        IF l_asb06 = 'N' AND l_asa07 = 'Y' THEN   #FUN-B90018
           LET g_sql = " SELECT * FROM asii_file ",
                       "  WHERE asii04 = '",l_asg01,"' AND asii06 = '",g_aso01,"'",
                       "    AND asii07 = '",g_aso02,"' AND asii12 = '",g_aso09,"'"
           PREPARE sel_asii_pre FROM g_sql
           DECLARE sel_asii_cur CURSOR FOR sel_asii_pre
           FOREACH sel_asii_cur INTO l_asii.*
               LET g_asp[l_cnt4].asp06 = g_aso[i].aso07   #关系人
               LET g_asp[l_cnt4].asp07 = l_asii.asii05
               LET g_asp[l_cnt4].asp17 = g_aaz.aaz114
               LET g_asp[l_cnt4].asp09 = l_asii.asii12
              SELECT azi04 INTO t_azi04_2 FROM azi_file
               WHERE azi01 = g_asp[l_cnt4].asp09
              CALL s_get_asp14(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                   RETURNING g_asp[l_cnt4].asp14
              CALL s_get_asp14_1(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                   RETURNING g_asp[l_cnt4].asp14_1
              LET g_asp[l_cnt4].asp10 =l_asii.asii08
              LET g_asp[l_cnt4].asp19 =l_asii.asii09

              IF g_asp[l_cnt4].asp10 =0 AND g_asp[l_cnt4].asp19 =0 THEN
                 CONTINUE FOREACH
              END IF
             SELECT asg08 INTO l_asg08 FROM asg_file
              WHERE asg01 = g_aso05
             LET g_asp[l_cnt4].asp11 = 1
             LET g_asp[l_cnt4].asp12 = 1
             LET g_asp[l_cnt4].asp13 = g_asp[l_cnt4].asp10
             LET g_asp[l_cnt4].asp20 = g_asp[l_cnt4].asp19
             CALL s_get_asp14(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                  RETURNING g_asp[l_cnt4].asp14
             CALL s_get_asp14_1(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                  RETURNING g_asp[l_cnt4].asp14_1
            CALL t004_get_asp16(g_asp[l_cnt4].asp13,g_asp[l_cnt4].asp20,g_asp[l_cnt4].asp14,g_asp[l_cnt4].asp14_1)
                  RETURNING g_asp[l_cnt4].asp16,g_asp[l_cnt4].asp21
            LET g_asp[l_cnt4].asp15 = g_aaz.aaz102
             SELECT aag19 INTO l_aag19 FROM aag_file WHERE aag00 = g_aso11 AND aag01 = l_asii.asii05
            #FUN-B90009--mod--str--
            #IF l_aag19 = '46' THEN
            #   LET g_asp[l_cnt4].asp22= g_aaz.aaz103
            #ELSE
            #   LET g_asp[l_cnt4].asp22 = g_asp[l_cnt4].asp07
            #END IF
             LET g_asp[l_cnt4].asp22 = g_asz.asz14
            #FUN-B90009--mod--end

#111101 lilingyu --begin--
            IF cl_null(g_asp[l_cnt4].asp08) THEN
               LET g_asp[l_cnt4].asp08 = ' '
            END IF
            IF cl_null(g_asp[l_cnt4].asp14) THEN
               LET g_asp[l_cnt4].asp14 = 0
            END IF
#111101 lilingyu --end--

             INSERT INTO asp_file(asp01,asp02,asp03,asp04,asp05,asp06,asp07,
                                  asp08,asp09,asp10,asp11,asp12,asp13,asp14,
                                  asp15,asp16,asp17,asp18,asp19,asp20,asp21,
                                  asp22)
                          VALUES(g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_asp[l_cnt4].asp06,
                                 g_asp[l_cnt4].asp07,l_asg08,g_asp[l_cnt4].asp09,g_asp[l_cnt4].asp10,
                                 g_asp[l_cnt4].asp11,g_asp[l_cnt4].asp12,g_asp[l_cnt4].asp13,
                                 g_asp[l_cnt4].asp14,g_asp[l_cnt4].asp15,g_asp[l_cnt4].asp16,
                                 g_asp[l_cnt4].asp17,g_aso11,g_asp[l_cnt4].asp19,
                                 g_asp[l_cnt4].asp20,g_asp[l_cnt4].asp21,g_asp[l_cnt4].asp22)
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 LET g_success = 'N'
                 CALL s_errmsg('aso05',g_aso05,'ins asp',SQLCA.sqlcode,1)
              ELSE
                 LET g_success = 'Y'
              END IF
              LET l_cnt4 = l_cnt4+1
           END FOREACH
        ELSE
 #  FUN-B60134--add--end
        #LET g_sql = "SELECT aag01 FROM aag_file ",
        LET g_sql = "SELECT aag01,aag19 FROM aag_file ",
                    " WHERE aag00 = '",g_aso11,"'",
                    "   AND aag07 IN ('2','3')",
                    #"   AND aag19 IN ('44','45','46','47')"   #权益类
                    "   AND aag19 IN ('19','20','21','22')"   #权益类
        PREPARE sel_aag01_cur1 FROM g_sql
        DECLARE sel_aag01_pre1 CURSOR FOR sel_aag01_cur1
        #FOREACH sel_aag01_pre1 INTO g_aag01_1[l_cnt2]
        FOREACH sel_aag01_pre1 INTO g_aag01_1[l_cnt2].aag01,g_aag01_1[l_cnt2].aag19
           IF STATUS THEN
              CALL s_errmsg(' ',' ','foreah',STATUS,1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           LET g_asp[l_cnt4].asp06 = g_aso[i].aso07   #关系人
           SELECT asg01 INTO l_asg01 FROM asg_file WHERE asg08 = g_aso[i].aso07
              AND asg01 IN(SELECT asb04 FROM asa_file,asb_file
                            WHERE asa01 = asb01 AND asa02 = asb02
                              AND asa03 = asb03 AND asa01 = g_aso03
                              AND asa02 = g_aso05 )
           LET g_asp[l_cnt4].asp07 = g_aag01_1[l_cnt2].aag01
           LET g_asp[l_cnt4].asp17 = g_asz.asz06
           SELECT asg06 INTO g_asp[l_cnt4].asp09 FROM asg_file   #子公司币别
            WHERE asg01 = l_asg01
           SELECT azi04 INTO t_azi04_2 FROM azi_file
            WHERE azi01 = g_asp[l_cnt4].asp09
           CALL s_get_asp14(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                RETURNING g_asp[l_cnt4].asp14
           CALL s_get_asp14_1(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                RETURNING g_asp[l_cnt4].asp14_1
           LET g_asp[l_cnt4].asp10 = 0
           CALL t004_get_asp10(l_asg01,g_asp[l_cnt4].asp07)
                      RETURNING g_asp[l_cnt4].asp10,g_asp[l_cnt4].asp19
           IF g_asp[l_cnt4].asp10 =0 AND g_asp[l_cnt4].asp19 =0 THEN
              CONTINUE FOREACH
           END IF
           SELECT asg08 INTO l_asg08 FROM asg_file
            WHERE asg01 = g_aso05
           LET g_asp[l_cnt4].asp11 = 1
           LET g_asp[l_cnt4].asp12 = 1
           LET g_asp[l_cnt4].asp13 = g_asp[l_cnt4].asp10
           LET g_asp[l_cnt4].asp20 = g_asp[l_cnt4].asp19
           CALL s_get_asp14(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                RETURNING g_asp[l_cnt4].asp14
           CALL s_get_asp14_1(g_aso03,g_aso05,l_asg01,g_aso01,g_aso02)
                RETURNING g_asp[l_cnt4].asp14_1
           CALL t004_get_asp16(g_asp[l_cnt4].asp13,g_asp[l_cnt4].asp20,g_asp[l_cnt4].asp14,g_asp[l_cnt4].asp14_1)
                RETURNING g_asp[l_cnt4].asp16,g_asp[l_cnt4].asp21
           LET g_asp[l_cnt4].asp15 = g_asz.asz13
          #FUN-B90009--mod--str--
          #IF g_aag01_1[l_cnt2].aag19 = '22' THEN
          #   LET g_asp[l_cnt4].asp22= g_asz.asz14
          #ELSE
          #   LET g_asp[l_cnt4].asp22 = g_asp[l_cnt4].asp07
          #END IF
           LET g_asp[l_cnt4].asp22= g_asz.asz14
          #FUN-B90009--mod--end

#111101 lilingyu --begin--
            IF cl_null(g_asp[l_cnt4].asp08) THEN
               LET g_asp[l_cnt4].asp08 = ' '
            END IF
            IF cl_null(g_asp[l_cnt4].asp14) THEN
               LET g_asp[l_cnt4].asp14 = 0
            END IF
#111101 lilingyu --end--

           INSERT INTO asp_file(asp01,asp02,asp03,asp04,asp05,asp06,asp07,
                                asp08,asp09,asp10,asp11,asp12,asp13,asp14,
                                asp15,asp16,asp17,asp18,asp19,asp20,asp21,
                                asp22,asplegal)
                        VALUES(g_aso01,g_aso02,g_aso03,g_aso04,g_aso05,g_asp[l_cnt4].asp06,
                               g_asp[l_cnt4].asp07,l_asg08,g_asp[l_cnt4].asp09,g_asp[l_cnt4].asp10,
                               g_asp[l_cnt4].asp11,g_asp[l_cnt4].asp12,g_asp[l_cnt4].asp13,
                               #g_asp[l_cnt4].asp14,' ',g_asp[l_cnt4].asp16,
                               g_asp[l_cnt4].asp14,g_asp[l_cnt4].asp15,g_asp[l_cnt4].asp16,
                               g_asp[l_cnt4].asp17,g_aso11,g_asp[l_cnt4].asp19,
                               g_asp[l_cnt4].asp20,g_asp[l_cnt4].asp21,g_asp[l_cnt4].asp22,g_legal)
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              LET g_success = 'N'
              CALL s_errmsg('aso05',g_aso05,'ins asp',SQLCA.sqlcode,1)
           ELSE
              LET g_success = 'Y'
           END IF
           LET l_cnt2 = l_cnt2+1
           LET l_cnt4 = l_cnt4+1
        END FOREACH
        END IF   # NO.FUN-B60134
    END FOR
    CALL g_asp.deleteElement(l_cnt4)
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
       CALL s_showmsg()
    END IF
    CALL t004_b_fill( '1=1')
    CALL t004_b_fill2( '1=1')
END FUNCTION
#NO.FUN-B40104
