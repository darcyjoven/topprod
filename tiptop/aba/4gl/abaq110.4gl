# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: abaq110.4gl
# Descriptions...: 料件條碼庫存明細數量查詢
# Date & Author..: No:DEV-CB0019 2012/11/19 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No.DEV-D40016 2013/04/19 By Mandy ibb_file多加ibb11使用否欄位

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    tm            RECORD
                   wc    STRING, #LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 CHAR(500) #No:MOD-A10034 modify
                   wc2   STRING  #LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 CHAR(500) #No:MOD-A10034 modify
                  END RECORD,
    g_ima         RECORD
                   ima01  LIKE ima_file.ima01,   # 料件編號
                   ima02  LIKE ima_file.ima02,   # 品名規格
                   ima021 LIKE ima_file.ima021,  # 品名規格
                   ima930 LIKE ima_file.ima930,  # 使用條碼否
                   ima932 LIKE ima_file.ima932   # 條碼產生時機
                  END RECORD,
    g_ima37       LIKE ima_file.ima37,
    g_ima38       LIKE ima_file.ima38,
    g_img         DYNAMIC ARRAY OF RECORD
                   img02   LIKE img_file.img02, #倉庫編號
                  #img03   LIKE img_file.img03, #存放位置 #No:DEV-CB0002--mark
                  #img04   LIKE img_file.img04, #存放批號 #No:DEV-CB0002--mark
                   img09   LIKE img_file.img09, #庫存單位
                   img10   LIKE img_file.img10  #庫存數量
                  END RECORD,
    g_imgb        DYNAMIC ARRAY OF RECORD
                   imgb01  LIKE imgb_file.imgb01, #條碼
                   ibb02   LIKE ibb_file.ibb02,   #包號
                   imgb02  LIKE imgb_file.imgb02, #倉庫
                   imgb03  LIKE imgb_file.imgb03, #儲位
                  #imgb04  LIKE imgb_file.imgb04, #批號 #No:DEV-CB0002--mark
                   imgb05  LIKE imgb_file.imgb05  #庫存
                  END RECORD,
    g_cmd         LIKE type_file.chr1000,
    g_argv1       LIKE ima_file.ima01,          #INPUT ARGUMENT - 1
    g_query_flag  LIKE type_file.num5,          #第一次進入程式時即進入Query之後進入next
    g_sql         string,                       #WHERE CONDITION
    g_rec_b       LIKE type_file.num10,         #單身筆數
    g_rec_b2      LIKE type_file.num10          #單身2筆數

DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt          LIKE type_file.num10
DEFINE l_ac           LIKE type_file.num10
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01

MAIN
   DEFINE      l_sl   LIKE type_file.num5

   OPTIONS                                 #改變一些系統預設值
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

   LET g_query_flag=1
   LET g_argv1 = ARG_VAL(1)               #參數值(1) Part#

   LET p_row = 3 LET p_col = 2
   OPEN WINDOW q110_w AT p_row,p_col
        WITH FORM "aba/42f/abaq110"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()


   CALL q110_menu()
   CLOSE WINDOW q110_w

   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
      RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q110_cs()
   DEFINE l_ima930   LIKE ima_file.ima930

   LET l_ima930 = 'Y'

   IF g_argv1 != ' ' THEN
      LET tm.wc = "ima01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
      CALL g_img.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL                      # Default condition
      INITIALIZE g_ima.* TO NULL
      CALL cl_set_head_visible("","YES")

      DISPLAY l_ima930 TO ima930

      CONSTRUCT BY NAME tm.wc ON ima01,ima02,ima021,ima932 # 螢幕上取單頭條件


         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()
         
         ON ACTION help
            CALL cl_show_help()
         
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL q110_b_askkey()
      IF INT_FLAG THEN RETURN END IF
   END IF

   MESSAGE ' WAIT '

   IF cl_null(tm.wc) THEN LET tm.wc = ' 1=1' END IF
   IF cl_null(tm.wc2) THEN LET tm.wc2 = ' 1=1' END IF
   LET tm.wc = tm.wc CLIPPED, " AND ima930 = '",l_ima930,"'"

   IF tm.wc2=' 1=1' THEN
      LET g_sql=" SELECT ima01 FROM ima_file ",
                " WHERE ",tm.wc CLIPPED
    ELSE
      LET g_sql=" SELECT UNIQUE ima_file.ima01 FROM ima_file,img_file ",
                "  WHERE ima01=img01",
                "   AND ",tm.wc CLIPPED,
                "   AND ",tm.wc2 CLIPPED
   END IF

   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q110_prepare FROM g_sql
   DECLARE q110_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q110_prepare

   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF tm.wc2=' 1=1' THEN
      LET g_sql=" SELECT COUNT(*) FROM ima_file ",
                " WHERE ",tm.wc CLIPPED
    ELSE
      LET g_sql=" SELECT COUNT(UNIQUE ima01) FROM ima_file,img_file ",
                "  WHERE ima01=img01",
                "   AND ",tm.wc CLIPPED,
                "   AND ",tm.wc2 CLIPPED
   END IF

   PREPARE q110_pp  FROM g_sql
   DECLARE q110_count   CURSOR FOR q110_pp
END FUNCTION

FUNCTION q110_b_askkey()
   CONSTRUCT tm.wc2 ON img02,img03,img04,img09,img10
        FROM s_img[1].img02,s_img[1].img03,s_img[1].img04,
             s_img[1].img09,s_img[1].img10

      BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_save
        CALL cl_qbe_save()
   END CONSTRUCT
END FUNCTION

FUNCTION q110_menu()

   WHILE TRUE
      CALL q110_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q110_q()
            END IF
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),base.TypeInfo.create(g_imgb),'')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q110_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q110_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF

    OPEN q110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q110_count
       FETCH q110_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q110_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION

FUNCTION q110_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式
    l_abso          LIKE type_file.num10     #絕對的筆數

    CASE p_flag
        WHEN 'N' FETCH NEXT     q110_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q110_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q110_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q110_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump q110_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL
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
    SELECT ima01,ima02,ima021,ima930,ima932,'','','',ima37,ima38
      INTO g_ima.*,g_ima37,g_ima38
      FROM ima_file
     WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)
       RETURN
    END IF
    CALL q110_show()
END FUNCTION

FUNCTION q110_show()
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   CALL q110_b_fill() #單身
   LET l_ac = ARR_CURR()
   CALL g_imgb.clear()
   IF l_ac > 0 THEN
     #No:DEV-CB0002--mark--begin
     #CALL q110_c_fill(g_img[l_ac].img02,g_img[l_ac].img03,
     #                 g_img[l_ac].img04)
     #No:DEV-CB0002--mark--end
      CALL q110_c_fill(g_img[l_ac].img02) #No:DEV-CB0002--add
   END IF
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q110_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE tot       LIKE img_file.img10
   DEFINE l_img21   LIKE img_file.img21
   DEFINE l_tot     LIKE img_file.img21 #No:DEV-CB0002--add

   LET l_sql =
       #No:DEV-CB0002--mark--begin
       #"SELECT img02,img03,img04,img09,img10,",
       #"       img21 ",
       #"  FROM img_file",
       #" WHERE img01 = '",g_ima.ima01,"'",
       #"   AND ", tm.wc2 CLIPPED,
       #" ORDER BY img02,img03,img09"
       #No:DEV-CB0002--mark--end

        #No:DEV-CB0002--add--begin
        "SELECT img02,img09,SUM(img10),",
        "       SUM(img10*img21) ",
        "  FROM img_file",
        " WHERE img01 = '",g_ima.ima01,"'",
        "   AND ", tm.wc2 CLIPPED,
        " GROUP BY img02,img09"
        #No:DEV-CB0002--add--end
    PREPARE q110_pb FROM l_sql
    DECLARE q110_bcs                       #BODY CURSOR
        CURSOR FOR q110_pb

    CALL g_img.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    LET tot   = 0
   #FOREACH q110_bcs INTO g_img[g_cnt].*,l_img21 #No:DEV-CB0002--mark
    FOREACH q110_bcs INTO g_img[g_cnt].*,l_tot   #No:DEV-CB0002--add
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach q110_bcs1:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
      #LET tot   = tot + g_img[g_cnt].img10 * l_img21 #No:DEV-CB0002--mark
       LET tot   = tot + l_tot                        #No:DEV-CB0002--add
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_img.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY BY NAME tot
    LET g_cnt = 0
END FUNCTION

#FUNCTION q110_c_fill(p_img02,p_img03,p_img04) #No:DEV-CB0002--mark
FUNCTION q110_c_fill(p_img02)                  #No:DEV-CB0002--add
   DEFINE p_img02   LIKE img_file.img02
   DEFINE p_img03   LIKE img_file.img03
   DEFINE p_img04   LIKE img_file.img04
   DEFINE l_sql     STRING

#  IF cl_null(p_img02) THEN LET p_img02 = ' ' END IF
#  IF cl_null(p_img03) THEN LET p_img03 = ' ' END IF
#  IF cl_null(p_img04) THEN LET p_img04 = ' ' END IF

   LET l_sql =
       #"SELECT imgb01,ibb05,imgb02,imgb03,imgb04,imgb05",
        "SELECT UNIQUE imgb01,ibb05,imgb02,imgb03,imgb05",
        "  FROM imgb_file,ibb_file",
        " WHERE imgb01 = ibb01 ",
        "   AND imgb02 = '",p_img02,"'",
       #No:DEV-CB0002--mark--begin
       #"   AND imgb03 = '",p_img03,"'",
       #"   AND imgb04 = '",p_img04,"'",
       #No:DEV-CB0002--mark--end
        "   AND ibb06  = '",g_ima.ima01,"'",
        "   AND ibb11 = 'Y' ",#DEV-D40016 add 使用否='Y'
        " ORDER BY imgb01,ibb05"


    PREPARE q110_pb2 FROM l_sql
    DECLARE q110_bcs2 CURSOR FOR q110_pb2

    CALL g_imgb.clear()
    LET g_rec_b2=0
    LET g_cnt = 1
    FOREACH q110_bcs2 INTO g_imgb[g_cnt].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach q110_bcs2:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_imgb.deleteElement(g_cnt)
    LET g_rec_b2= g_cnt-1
   #DISPLAY g_rec_b2 TO FORMONLY.cn3
    LET g_cnt = 0
END FUNCTION

FUNCTION q110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL cl_show_fld_cont()
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL g_imgb.clear()
            IF l_ac > 0 THEN
              #No:DEV-CB0002--mark--begin
              #CALL q110_c_fill(g_img[l_ac].img02,g_img[l_ac].img03,
              #                 g_img[l_ac].img04)
              #No:DEV-CB0002--mark--end
               CALL q110_c_fill(g_img[l_ac].img02) #No:DEV-CB0002--add
            END IF
      END DISPLAY

      DISPLAY ARRAY g_imgb TO s_imgb.* ATTRIBUTE(COUNT=g_rec_b2)

      END DISPLAY

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION first
         CALL q110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DIALOG


      ON ACTION previous
         CALL q110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG


      ON ACTION jump
         CALL q110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG


      ON ACTION next
         CALL q110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG


      ON ACTION last
         CALL q110_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG


      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION accept
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         EXIT DIALOG

      ON ACTION about
         CALL cl_about()

      AFTER DIALOG
         CONTINUE DIALOG

     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#DEV-CB0019--add
#DEV-D30025--add
