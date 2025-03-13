# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: axcq310.4gl
# Descriptions...: 制造费用分摊分录底稿产生作业
# Date & Author..: 09/12/01 By Carrier #No.FUN-9B0118
# Modify.........: No.FUN-AA0025 10/11/16 By Elva 成本分录改善
# Modify.........: No.FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No.FUN-B20010 11/02/23 By Elva 傳參修正
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:FUN-BB0038 11/11/08 By elva 成本改善
# Modify.........: No:MOD-C40106 12/04/17 By yinhy 若本币原币都为零，则分录底稿不必产生此资料
# Modify.........: No:MOD-D20062 13/02/18 By wujie 没有带出agli121预设的摘要
#                                                  若科目不为部门管理，分录中的部门应为“ ”，而不是带主画面的部门和成本中心
# Modify.........: No:CHI-CB0025 13/03/05 By Alberti 分錄底稿金額必須依幣別取位,並處理尾差
# Modify.........: No:FUN-D60095 13/06/24 By max1 增加傳參
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.FUN-D80058 13/08/16 By lujh 將制費分攤按核算項進行結轉

DATABASE ds   #No.FUN-9B0118

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE g_cdb00             LIKE cdb_file.cdb00
DEFINE g_cdb01             LIKE cdb_file.cdb01
DEFINE g_cdb02             LIKE cdb_file.cdb02
DEFINE g_cdb11             LIKE cdb_file.cdb11
DEFINE g_cdb13             LIKE cdb_file.cdb13
DEFINE g_cdblegal          LIKE cdb_file.cdblegal  #FUN-BB0038
DEFINE g_cdb               DYNAMIC ARRAY OF RECORD
                           cdb03   LIKE cdb_file.cdb03,
                           cdb04   LIKE cdb_file.cdb04,
                           cdb08   LIKE cdb_file.cdb08,
                           cdb12   LIKE cdb_file.cdb12,
                           aag02   LIKE aag_file.aag02,
                           cdb05   LIKE cdb_file.cdb05
                           END RECORD
DEFINE g_cdb_t             RECORD
                           cdb03   LIKE cdb_file.cdb03,
                           cdb04   LIKE cdb_file.cdb04,
                           cdb08   LIKE cdb_file.cdb08,
                           cdb12   LIKE cdb_file.cdb12,
                           aag02   LIKE aag_file.aag02,
                           cdb05   LIKE cdb_file.cdb05
                           END RECORD
DEFINE g_cdb_cnt           LIKE type_file.num5
DEFINE g_cmi               DYNAMIC ARRAY OF RECORD          #程式變數(Program Variables)
                           cmi05   LIKE cmi_file.cmi05,
                           cmi06   LIKE cmi_file.cmi06,
                           b_bal   LIKE aah_file.aah04,
                           aah04   LIKE aah_file.aah04,
                           aah05   LIKE aah_file.aah05,
                           cmi08   LIKE cmi_file.cmi08,
                           e_bal   LIKE aah_file.aah04,
                           #FUN-D80058--add--str--
                           cmi35   LIKE cmi_file.cmi35,
                           cmi13   LIKE cmi_file.cmi13,
                           cmi14   LIKE cmi_file.cmi14,
                           cmi15   LIKE cmi_file.cmi15,
                           cmi16   LIKE cmi_file.cmi16,
                           cmi17   LIKE cmi_file.cmi17,
                           cmi18   LIKE cmi_file.cmi18,
                           cmi19   LIKE cmi_file.cmi19,
                           cmi20   LIKE cmi_file.cmi20,
                           cmi21   LIKE cmi_file.cmi21,
                           cmi22   LIKE cmi_file.cmi22,
                           cmi23   LIKE cmi_file.cmi23,
                           cmi24   LIKE cmi_file.cmi24,
                           cmi25   LIKE cmi_file.cmi25,
                           cmi26   LIKE cmi_file.cmi26,
                           cmi27   LIKE cmi_file.cmi27,
                           cmi28   LIKE cmi_file.cmi28,
                           cmi29   LIKE cmi_file.cmi29,
                           cmi30   LIKE cmi_file.cmi30,
                           cmi31   LIKE cmi_file.cmi31,
                           cmi32   LIKE cmi_file.cmi32,
                           cmi33   LIKE cmi_file.cmi33,
                           cmi34   LIKE cmi_file.cmi34
                           #FUN-D80058--add--end--
                           END RECORD
DEFINE g_cmi_cnt           LIKE type_file.num5
DEFINE g_cdb_index         LIKE type_file.num5
DEFINE g_cmi_index         LIKE type_file.num5
DEFINE g_wc                STRING 
DEFINE g_wc_cmi            STRING 
DEFINE g_wc_cdb            STRING 
DEFINE g_sql               STRING 
DEFINE g_rec_b             LIKE type_file.num5                #單身筆數
DEFINE l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT
DEFINE g_argv1             LIKE type_file.chr1
DEFINE g_nppglno           LIKE npp_file.nppglno  #FUN-BB0038
DEFINE g_wc1               STRING    #FUN-D60095  add 

#主程式開始
DEFINE g_forupd_sql        STRING                             #SELECT ...  FOR UPDATE SQL
DEFINE g_sql_tmp           STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5                #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_flag              LIKE type_file.chr1
DEFINE l_table             STRING               
DEFINE g_str               STRING              
DEFINE g_bookno            STRING
DEFINE g_dept              STRING
DEFINE g_account           STRING
DEFINE g_accumulate        STRING
DEFINE g_current           STRING
DEFINE g_npptype           LIKE npp_file.npptype
DEFINE g_aag44             LIKE aag_file.aag44   #FUN-D40118 add

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5

   OPTIONS                                    #改變一些系統預設值
       INPUT NO WRAP
       DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間)

   #FUN-D60095--add--str--
   LET g_wc1 = ARG_VAL(1)
   LET g_wc1 = cl_replace_str(g_wc1, "\\\"", "'")
   #FUN-D60095--add--end--

   LET p_row = 4 LET p_col = 15
   OPEN WINDOW q310_w AT p_row,p_col WITH FORM "axc/42f/axcq310"    #顯示畫面
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #FUN-D60095--add--str--
   IF NOT cl_null(g_wc1) THEN 
      CALL q310_q() 
   END IF
   #FUN-D60095--add--end--

   CALL q310_menu()
   CLOSE WINDOW q310_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間)
END MAIN

FUNCTION q310_cs()

   CLEAR FORM                             #清除畫面
   CALL g_cdb.clear()
   CALL g_cmi.clear()
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_cdb00 TO NULL
   INITIALIZE g_cdb11 TO NULL
   INITIALIZE g_cdb01 TO NULL
   INITIALIZE g_cdb02 TO NULL
   INITIALIZE g_cdb13 TO NULL
   INITIALIZE g_cdblegal TO NULL  #FUN-BB0038
   INITIALIZE g_nppglno TO NULL  #FUN-BB0038

    IF cl_null(g_wc1) THEN  #FUN-D60095 add
   CONSTRUCT g_wc ON cdb11,cdb00,cdb01,cdb02,cdb13,cdblegal  #FUN-BB0038
                FROM cdb11,cdb00,cdb01,cdb02,cdb13,cdblegal   #FUN-BB0038

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(cdb00)       #帐套
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cdb00
                 NEXT FIELD cdb00
            OTHERWISE EXIT CASE
         END CASE

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
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT
  # LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cdbuser', 'cdbgrup') #mark by  max1
  # IF INT_FLAG THEN RETURN END IF mark by max1 
  END IF    #FUN-D60095 add
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cdbuser', 'cdbgrup')

   IF INT_FLAG THEN RETURN END IF
   
   #FUN-D60095--add--str--
   IF cl_null(g_wc) THEN
      LET g_wc = '1=1'
   END IF
   IF cl_null(g_wc1) THEN 
      LET g_wc1 = '1=1'
   END IF
   #FUN-D60095--add--end--

   LET g_sql= "SELECT UNIQUE cdb11,cdb00,cdb01,cdb02 ",
              "  FROM cdb_file",
              " WHERE ", g_wc CLIPPED,
              "   AND ", g_wc1 CLIPPED,    #FUN-D60095 add
              " ORDER BY cdb11,cdb00,cdb01,cdb02"
   PREPARE q310_prepare FROM g_sql      #預備一下
   DECLARE q310_b_cs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR q310_prepare

   LET g_sql_tmp = "SELECT UNIQUE cdb11,cdb00,cdb01,cdb02 ",
                   "  FROM cdb_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND ", g_wc1 CLIPPED,    #FUN-D60095 add
                   "  INTO TEMP x"
   DROP TABLE x
   PREPARE q310_precount_x FROM g_sql_tmp
   EXECUTE q310_precount_x

   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE q310_precount FROM g_sql
   DECLARE q310_count CURSOR FOR q310_precount
END FUNCTION

FUNCTION q310_menu()
   DEFINE   li_index   LIKE type_file.num5
   DEFINE   li_i       LIKE type_file.num5
   DEFINE   l_cmi08    LIKE cmi_file.cmi08

   #以前用ARR_CURR()跟fgl_set_arr_curr()都必須改成
   #DIALOG.getCurrentRow()跟DIALOG.setCurrentRow(), 才可以正確指定是哪個table 的row指標

   WHILE TRUE
      CALL cl_set_act_visible("accept,cancel",FALSE)
      #進入DIALOG畫面會閃一下, 為什麼!!
      DIALOG ATTRIBUTES(UNBUFFERED)
         #基本上已經是把進入s_cmi當做進入單頭頁面
         DISPLAY ARRAY g_cmi TO s_cmi.*
            BEFORE DISPLAY
               CALL cl_navigator_setting(g_curs_index,g_row_count)
            BEFORE ROW
               LET g_cmi_index = DIALOG.getCurrentRow("s_cmi")
         #  ON ACTION accept
         #     LET g_action_choice = "detail"
         #     EXIT DIALOG
         END DISPLAY

         DISPLAY ARRAY g_cdb TO s_cdb.*
            BEFORE DISPLAY
               CALL cl_navigator_setting(g_curs_index,g_row_count)

            BEFORE ROW
               LET g_cdb_index = DIALOG.getCurrentRow("s_cdb")

            ON ACTION accept
               LET g_action_choice = "detail"
               EXIT DIALOG
         END DISPLAY
         ON ACTION detail
            LET g_action_choice="detail"
            EXIT DIALOG
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG
#str----add by huanglf170113
         ON ACTION exporttoexcel
            LET g_action_choice="exporttoexcel"
            EXIT DIALOG
#str----end by huanglf170113            
         ON ACTION next
            LET g_action_choice="next"
#           CALL DIALOG.setCurrentRow("s_cmi",1)
#           CALL DIALOG.setCurrentRow("s_cdb",1)
            EXIT DIALOG
         ON ACTION previous
            LET g_action_choice="previous"
#           CALL DIALOG.setCurrentRow("s_cmi",1)
#           CALL DIALOG.setCurrentRow("s_cdb",1)
            EXIT DIALOG
         ON ACTION jump
            LET g_action_choice="jump"
#           CALL DIALOG.setCurrentRow("s_cmi",1)
#           CALL DIALOG.setCurrentRow("s_cdb",1)
            EXIT DIALOG
         ON ACTION first
            LET g_action_choice="first"
#           CALL DIALOG.setCurrentRow("s_cmi",1)
#           CALL DIALOG.setCurrentRow("s_cdb",1)
            EXIT DIALOG
         ON ACTION last
            LET g_action_choice="last"
#           CALL DIALOG.setCurrentRow("s_cmi",1)
#           CALL DIALOG.setCurrentRow("s_cdb",1)
            EXIT DIALOG
         ON ACTION gen_entry
            LET g_action_choice="gen_entry"
            EXIT DIALOG
         ON ACTION entry_sheet
            LET g_action_choice="entry_sheet"
            EXIT DIALOG
         ON ACTION help
            CALL cl_show_help()
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
         ON ACTION controlg
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION close
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT DIALOG
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
         #FUN-BB0038 --begin
         ON action carry_voucher
            LET g_action_choice="carry_voucher"
            EXIT DIALOG 

         ON action undo_carry_voucher
            LET g_action_choice="undo_carry_voucher"
            EXIT DIALOG 
         #FUN-BB0038 --end

         #carrier 20130619  --Begin
         ON action voucher_qry
            LET g_action_choice="voucher_qry"
            EXIT DIALOG 
         #carrier 20130619  --End  

      END DIALOG
      CALL cl_set_act_visible("accept,cancel",TRUE)

      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_wc1 = NULL   #FUN-D60095 add
               CALL q310_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL q310_b()
         #  ELSE
         #     LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q310_out()
            END IF
         WHEN "gen_entry"
            CALL q310_g()
         WHEN "next"
            CALL q310_fetch('N')
         WHEN "previous"
            CALL q310_fetch('P')
         WHEN "jump"
            CALL q310_fetch('/')
         WHEN "first"
            CALL q310_fetch('F')
         WHEN "last"
            CALL q310_fetch('L')
         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_cdb13) THEN
                  SELECT SUM(cmi08) INTO l_cmi08 FROM cmi_file
                   WHERE cmi00 = g_cdb00
                     AND cmi01 = g_cdb01
                     AND cmi02 = g_cdb02
                     AND cmi04 <> '1'
                     AND cmiacti = 'Y'
                  IF g_cdb00 = g_ccz.ccz12 THEN
                     LET g_npptype  = '0'
                  ELSE
                     LET g_npptype  = '1'
                  END IF
                  #CALL s_fsgl('CA',1,g_cdb13,0,g_cdb00,1,'N',g_npptype,g_cdb13)   #FUN-B20010 mark
                  CALL s_fsgl('CA',8,g_cdb13,0,g_cdb00,1,'N',g_npptype,g_cdb13)    #FUN-B20010
#                 LET g_msg="axci100 'CA' '1' '",g_cdb13,"' ",l_cmi08," '",g_cdb00,"' '1' 'N'" 
#                 CALL cl_cmdrun(g_msg)
               END IF
            END IF
         #FUN-BB0038 --begin
         WHEN "carry_voucher"
            IF cl_null(g_nppglno)  THEN
               LET g_msg ="axcp301 ",g_cdb13," '' '' '' ",
                          "'' '' '' 'N' '' ''"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdb13 AND nppsys ='CA' AND npp00 =8 AND npp011 =1
               DISPLAY g_nppglno TO nppglno 
            END IF      

         WHEN "undo_carry_voucher"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            LET g_msg ="axcp302 '",g_plant,"' '",g_cdb00,"' '",g_nppglno CLIPPED,"' 'Y'"
            CALL cl_wait()
            CALL cl_cmdrun_wait(g_msg)
            SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdb13 AND nppsys ='CA' AND npp00 =8 AND npp011 =1
            DISPLAY g_nppglno TO nppglno       
         #FUN-BB0038 --end   
         #carrier 20130619  --Begin
         WHEN "voucher_qry"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            CALL s_voucher_qry(g_nppglno)
         #carrier 20130619  --End  
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cmi),'','')

      END CASE
   END WHILE
END FUNCTION

FUNCTION q310_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL q310_cs()                    #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q310_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN             #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cdb01 TO NULL
   ELSE
      OPEN q310_count
      FETCH q310_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q310_fetch('F')            #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

#處理資料的讀取
FUNCTION q310_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1                  #處理方式

   CASE p_flag
        WHEN 'N' FETCH NEXT     q310_b_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02
        WHEN 'P' FETCH PREVIOUS q310_b_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02
        WHEN 'F' FETCH FIRST    q310_b_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02
        WHEN 'L' FETCH LAST     q310_b_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02
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
             FETCH ABSOLUTE g_jump q310_b_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02
             LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdb01,SQLCA.sqlcode,0)
      INITIALIZE g_cdb11 TO NULL
      INITIALIZE g_cdb00 TO NULL  
      INITIALIZE g_cdb01 TO NULL  
      INITIALIZE g_cdb02 TO NULL  
      INITIALIZE g_cdb13 TO NULL  
      INITIALIZE g_cdblegal TO NULL   #FUN-BB0038
   ELSE
      SELECT cdb13,cdblegal INTO g_cdb13,g_cdblegal FROM cdb_file   #FUN-BB0038
       WHERE cdb11 = g_cdb11
         AND cdb00 = g_cdb00
         AND cdb01 = g_cdb01
         AND cdb02 = g_cdb02

      CALL q310_show()
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

#將資料顯示在畫面上
FUNCTION q310_show()
   DEFINE l_gem02     LIKE gem_file.gem02
   DEFINE l_azt02     LIKE azt_file.azt02  #FUN-BB0038
   DISPLAY g_cdb11,g_cdb00,g_cdb01,g_cdb02,g_cdb13,g_cdblegal TO cdb11,cdb00,cdb01,cdb02,cdb13,cdblegal #FUN-BB0038

   #FUN-BB0038 --begin
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_cdblegal
   IF NOT cl_null(g_cdb13) THEN
      SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdb13 AND nppsys ='CA' AND npp00 =8 AND npp011 =1
   ELSE
      LET g_nppglno = NULL 
   END IF
   DISPLAY l_azt02 TO azt02
   DISPLAY g_nppglno TO nppglno
   #FUN-BB0038 --end
   CALL q310_b_fill1(' 1=1')               #單身
   CALL q310_b_fill2(' 1=1')               #單身
   CALL cl_show_fld_cont()
END FUNCTION

#單身
FUNCTION q310_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,                #檢查重複用
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
          p_cmd           LIKE type_file.chr1,                #處理狀態
          l_allow_insert  LIKE type_file.num5,                #可新增否
          l_allow_delete  LIKE type_file.num5                 #可刪除否

   IF g_cdb00 IS NULL OR g_cdb01 IS NULL OR g_cdb02 IS NULL OR g_cdb11 IS NULL THEN
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET g_action_choice = ""

   LET g_forupd_sql = "SELECT cdb03,cdb04,cdb08,cdb12,'',cdb05",
                      "  FROM cdb_file ",
                      "  WHERE cdb00=?",
                      "    AND cdb01=?",
                      "    AND cdb02=?",
                      "    AND cdb11=?",
                      "    AND cdb03=?",
                      "    AND cdb04=?",
                      "    AND cdb08=?",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q310_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE

   INPUT ARRAY g_cdb WITHOUT DEFAULTS FROM s_cdb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b>=l_ac THEN
            LET g_cdb_t.* = g_cdb[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN q310_bcl USING g_cdb00,g_cdb01,g_cdb02,g_cdb11,
                                g_cdb_t.cdb03,g_cdb_t.cdb04,g_cdb_t.cdb08
            IF STATUS THEN
               CALL cl_err("OPEN q310_bcl:", STATUS, 1)
               CLOSE q310_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH q310_bcl INTO g_cdb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_cdb_t.cdb03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL q310_cdb12(g_cdb[l_ac].cdb12,g_cdb00) RETURNING g_cdb[l_ac].aag02
            CALL cl_show_fld_cont()
         END IF

      AFTER FIELD cdb12    #科目編號
         IF NOT cl_null(g_cdb[l_ac].cdb12) THEN
            CALL q310_cdb12(g_cdb[l_ac].cdb12,g_cdb00) RETURNING g_cdb[l_ac].aag02
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cdb[l_ac].cdb12,g_errno,0)
#FUN-B10052 --begin--
#              LET g_cdb[l_ac].cdb12 = g_cdb_t.cdb12

                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag07"
                 LET g_qryparam.arg1 = g_cdb00
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.where = " aag01 LIKE '",g_cdb[l_ac].cdb12 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_cdb[l_ac].cdb12
                 DISPLAY BY NAME g_cdb[l_ac].cdb12
#FUN-B10052 --end--
               NEXT FIELD cdb12
            END IF
            DISPLAY BY NAME g_cdb[l_ac].aag02
         ELSE
            LET g_cdb[l_ac].aag02 = NULL
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_cdb[l_ac].* = g_cdb_t.*
            CLOSE q310_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cdb[l_ac].cdb05,-263,1)
            LET g_cdb[l_ac].* = g_cdb_t.*
         ELSE
            UPDATE cdb_file SET cdb12  =g_cdb[l_ac].cdb12,
                                cdbmodu=g_user,
                                cdbdate=g_today
                          WHERE cdb00  =g_cdb00
                            AND cdb01  =g_cdb01
                            AND cdb02  =g_cdb02
                            AND cdb11  =g_cdb11
                            AND cdb03  =g_cdb_t.cdb03
                            AND cdb04  =g_cdb_t.cdb04
                            AND cdb08  =g_cdb_t.cdb08
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","cdb_file",g_cdb_t.cdb03,g_cdb_t.cdb04,SQLCA.sqlcode,"","",1)
               LET g_cdb[l_ac].* = g_cdb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_cdb[l_ac].* = g_cdb_t.*
            END IF
            CLOSE q310_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE q310_bcl
         COMMIT WORK

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON ACTION controlp
         CASE
            WHEN INFIELD(cdb12)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag07"
                 LET g_qryparam.arg1 = g_cdb00
                 CALL cl_create_qry() RETURNING g_cdb[l_ac].cdb12
                 NEXT FIELD cdb12
            OTHERWISE EXIT CASE
         END CASE

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT

   CLOSE q310_bcl
   COMMIT WORK
END FUNCTION

FUNCTION q310_cdb12(p_cdb12,p_bookno)
   DEFINE p_cdb12         LIKE cdb_file.cdb12
   DEFINE p_bookno        LIKE aag_file.aag00
   DEFINE l_aag02         LIKE aag_file.aag02
   DEFINE l_aag03         LIKE aag_file.aag03
   DEFINE l_aag07         LIKE aag_file.aag07
   DEFINE l_aagacti       LIKE aag_file.aagacti

   LET g_errno = ' '

   SELECT aag02,aag03,aag07,aagacti
     INTO l_aag02,l_aag03,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag01 = p_cdb12
      AND aag00 = p_bookno

   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
        WHEN l_aagacti = 'N'     LET g_errno = '9028'
        WHEN l_aag07   = '1'     LET g_errno = 'agl-015'
        WHEN l_aag03  != '2'     LET g_errno = 'agl-201'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE

   IF NOT cl_null(g_errno) THEN LET l_aag02 = ' ' END IF
   RETURN l_aag02

END FUNCTION

FUNCTION q310_b_fill1(p_wc)              #BODY FILL UP
   DEFINE p_wc            STRING
   DEFINE l_flag          LIKE type_file.num5          #FUN-D80058 add
   DEFINE l_flag_t        LIKE type_file.num5          #FUN-D80058 add

   LET g_sql = "SELECT cmi05,cmi06,0,0,0,SUM(cmi08),0",
               "       cmi35,cmi13,cmi14,cmi15,cmi16,cmi17,cmi18,cmi19,",   #FUN-D80058 add
               "       cmi20,cmi21,cmi22,cmi23,cmi24,cmi25,cmi26,cmi27,",   #FUN-D80058 add
               "       cmi28,cmi29,cmi30,cmi31,cmi32,cmi33,cmi34",          #FUN-D80058 add
               "  FROM cmi_file",
               " WHERE cmi00 = '",g_cdb00,"'",
               "   AND cmi01 =  ",g_cdb01,
               "   AND cmi02 =  ",g_cdb02,
               "   AND cmi04 <> '1'  ",               #不含人工
               "   AND cmiacti = 'Y' ",
               "   AND ",p_wc CLIPPED ,
               " GROUP BY cmi05,cmi06,",
               " cmi35,cmi13,cmi14,cmi15,cmi16,cmi17,cmi18,cmi19,",      #FUN-D80058 add
               " cmi20,cmi21,cmi22,cmi23,cmi24,cmi25,cmi26,cmi27,",      #FUN-D80058 add
               " cmi28,cmi29,cmi30,cmi31,cmi32,cmi33,cmi34",             #FUN-D80058 add
               " ORDER BY cmi05,cmi06"
    PREPARE q310_prepare2 FROM g_sql      #預備一下
    IF SQLCA.SQLCODE THEN
       CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
       RETURN
    END IF
    DECLARE q310_b_c1 CURSOR FOR q310_prepare2
    CALL g_cmi.clear()
    LET g_cnt = 1
    LET l_flag_t = 0     #FUN-D80058 add
    FOREACH q310_b_c1 INTO g_cmi[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL q310_aah(g_cmi[g_cnt].cmi05,g_cmi[g_cnt].cmi06,g_cmi[g_cnt].cmi08,
                     g_cmi[g_cnt].cmi13,g_cmi[g_cnt].cmi15,g_cmi[g_cnt].cmi17,    #FUN-D80058 add
                     g_cmi[g_cnt].cmi19,g_cmi[g_cnt].cmi21,g_cmi[g_cnt].cmi23,    #FUN-D80058 add
                     g_cmi[g_cnt].cmi25,g_cmi[g_cnt].cmi27,g_cmi[g_cnt].cmi29,    #FUN-D80058 add
                     g_cmi[g_cnt].cmi31,g_cmi[g_cnt].cmi33)                       #FUN-D80058 add
            RETURNING g_cmi[g_cnt].b_bal,g_cmi[g_cnt].aah04,
                      g_cmi[g_cnt].aah05,g_cmi[g_cnt].e_bal
       #FUN-D80058--add--str--
       LET l_flag = 0
       IF NOT cl_null(g_cmi[g_cnt].cmi13) THEN
          LET l_flag = 1
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi15) THEN
          LET l_flag = 2
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi17) THEN
          LET l_flag = 3
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi19) THEN
          LET l_flag = 4
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi21) THEN
          LET l_flag = 5
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi23) THEN
          LET l_flag = 6
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi25) THEN
          LET l_flag = 7
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi27) THEN
          LET l_flag = 8
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi29) THEN
          LET l_flag = 9
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi31) THEN
          LET l_flag = 10
       END IF
       IF NOT cl_null(g_cmi[g_cnt].cmi33) THEN
          LET l_flag = 11
       END IF
       IF l_flag >= l_flag_t THEN
          LET l_flag_t = l_flag
       END IF
       #FUN-D80058--add--end--
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL q310_visible(l_flag_t)    #FUN-D80058 add
    CALL g_cmi.deleteElement(g_cnt)
    MESSAGE ""
#   LET g_rec_b=g_cnt-1
#   DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q310_b_fill2(p_wc)              #BODY FILL UP
   DEFINE p_wc            STRING

   LET g_sql = "SELECT cdb03,cdb04,cdb08,cdb12,'',cdb05",
               "  FROM cdb_file",
               " WHERE cdb00 = '",g_cdb00,"'",
               "   AND cdb01 =  ",g_cdb01,
               "   AND cdb02 =  ",g_cdb02,
               "   AND cdb11 = '",g_cdb11,"'",
               "   AND cdb04 <> '1' ",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY cdb03,cdb04,cdb08 "
    PREPARE q310_prepare3 FROM g_sql      #預備一下
    IF SQLCA.SQLCODE THEN
       CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
       RETURN
    END IF
    DECLARE q310_b_c2 CURSOR FOR q310_prepare3
    CALL g_cdb.clear()
    LET g_cnt = 1
    FOREACH q310_b_c2 INTO g_cdb[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT aag02 INTO g_cdb[g_cnt].aag02 FROM aag_file
        WHERE aag00 = g_cdb00
          AND aag01 = g_cdb[g_cnt].cdb12
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cdb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q310_out()
   DEFINE l_cmd   LIKE type_file.chr1000
   DEFINE l_wc    STRING
   DEFINE l_wc1   STRING

#   LET l_wc  = g_wc 
#   IF cl_null(g_wc) AND NOT cl_null(g_cdba.cdb00)
#                    AND NOT cl_null(g_cdba.cdb11)
#                    AND NOT cl_null(g_cdba.cdb01)
#                    AND NOT cl_null(g_cdba.cdb02)
#                    AND NOT cl_null(g_cdba.cdb04) THEN
#      LET g_wc="     cdb00 = '",g_cdba.cdb00,"'",
#               " AND cdb11 = '",g_cdba.cdb11,"'",
#               " AND cdb01 = '",g_cdba.cdb01,"'",
#               " AND cdb02 = '",g_cdba.cdb02,"'",
#               " AND cdb04 = '",g_cdba.cdb04,"'"
#   END IF
#   IF cl_null(g_wc) THEN
#      CALL cl_err('','9057',0)
#      RETURN
#   END IF
#   LET l_cmd = 'p_query "axcq310" "',g_wc CLIPPED,'"'
#   CALL cl_cmdrun(l_cmd)
#   LET g_wc  = l_wc    #MOD-960319 add

END FUNCTION

#FUNCTION q310_aah(p_aah01,p_aao02,p_cmi08)    #FUN-D80058 mark
FUNCTION q310_aah(p_aah01,p_aao02,p_cmi08,p_cmi13,p_cmi15,p_cmi17,p_cmi19,p_cmi21,p_cmi23,p_cmi25,p_cmi27,p_cmi29,p_cmi31,p_cmi33)   #FUN-D80058 add
   DEFINE p_aah01      LIKE aah_file.aah01
   DEFINE p_aao02      LIKE aao_file.aao02
   DEFINE p_cmi08      LIKE cmi_file.cmi08
   DEFINE l_b_bal      LIKE aah_file.aah04
   DEFINE l_e_bal      LIKE aah_file.aah04
   DEFINE l_aah04      LIKE aah_file.aah04
   DEFINE l_aah05      LIKE aah_file.aah04
   DEFINE l_d          LIKE aah_file.aah04
   DEFINE l_c          LIKE aah_file.aah04
   #FUN-D80058--add--str--
   DEFINE p_cmi13      LIKE cmi_file.cmi13
   DEFINE p_cmi15      LIKE cmi_file.cmi15
   DEFINE p_cmi17      LIKE cmi_file.cmi17
   DEFINE p_cmi19      LIKE cmi_file.cmi19
   DEFINE p_cmi21      LIKE cmi_file.cmi21
   DEFINE p_cmi23      LIKE cmi_file.cmi23
   DEFINE p_cmi25      LIKE cmi_file.cmi25
   DEFINE p_cmi27      LIKE cmi_file.cmi27
   DEFINE p_cmi29      LIKE cmi_file.cmi29
   DEFINE p_cmi31      LIKE cmi_file.cmi31
   DEFINE p_cmi33      LIKE cmi_file.cmi33
   DEFINE l_aeh11      LIKE aeh_file.aeh11
   DEFINE l_aeh12      LIKE aeh_file.aeh12
   #FUN-D80058--add--end--

   IF cl_null(p_aah01) THEN RETURN END IF
   IF cl_null(p_cmi08) THEN LET p_cmi08 = 0 END IF
   IF cl_null(p_aao02) THEN
      #FUN-D80058--add--end--
      IF NOT cl_null(p_cmi13) OR NOT cl_null(p_cmi15) OR
         NOT cl_null(p_cmi17) OR NOT cl_null(p_cmi19) OR
         NOT cl_null(p_cmi21) OR NOT cl_null(p_cmi23) OR
         NOT cl_null(p_cmi25) OR NOT cl_null(p_cmi27) OR
         NOT cl_null(p_cmi29) OR NOT cl_null(p_cmi31) OR
         NOT cl_null(p_cmi33) THEN

         #期初
          SELECT SUM(aeh11),SUM(aeh12) INTO l_aeh11,l_aeh12
            FROM aeh_file
           WHERE aeh00 = g_cdb00
             AND aeh01 = p_aah01
             AND aeh09 = g_cdb01
             AND aeh10 < g_cdb02
             AND aeh04 = p_cmi13
             AND aeh05 = p_cmi15
             AND aeh06 = p_cmi17
             AND aeh07 = p_cmi19
             AND aeh31 = p_cmi21
             AND aeh32 = p_cmi23
             AND aeh33 = p_cmi25
             AND aeh34 = p_cmi27
             AND aeh35 = p_cmi29
             AND aeh36 = p_cmi31
             AND aeh37 = p_cmi33
          IF cl_null(l_aeh11) THEN LET l_aeh11 = 0 END IF
          IF cl_null(l_aeh12) THEN LET l_aeh12 = 0 END IF
          LET l_b_bal = l_aeh11 - l_aeh12

          #期间
          SELECT SUM(aeh11),SUM(aeh12) INTO l_d,l_c
            FROM aeh_file
           WHERE aeh00 = g_cdb00
             AND aeh01 = p_aah01
             AND aeh09 = g_cdb01
             AND aeh10 = g_cdb02
             AND aeh04 = p_cmi13
             AND aeh05 = p_cmi15
             AND aeh06 = p_cmi17
             AND aeh07 = p_cmi19
             AND aeh31 = p_cmi21
             AND aeh32 = p_cmi23
             AND aeh33 = p_cmi25
             AND aeh34 = p_cmi27
             AND aeh35 = p_cmi29
             AND aeh36 = p_cmi31
             AND aeh37 = p_cmi33
          IF cl_null(l_d) THEN LET l_d = 0 END IF
          IF cl_null(l_c) THEN LET l_c = 0 END IF

          SELECT SUM(abb07) INTO l_aeh11 FROM aba_file,abb_file,aag_file
           WHERE aba00 = abb00
             AND aba01 = abb01
             AND abb00 = aag00
             AND abb03 = aag01
             AND abb00 = g_cdb00
             AND abb03 = p_aah01
             AND aba03 = g_cdb01
             AND aba04 = g_cdb02
             AND aba06 = 'CA'
             AND abb06 = '1'
             AND abapost = 'Y'
             AND abb11 = p_cmi13
             AND abb12 = p_cmi15
             AND abb13 = p_cmi17
             AND abb14 = p_cmi19
             AND abb31 = p_cmi21
             AND abb32 = p_cmi23
             AND abb33 = p_cmi25
             AND abb34 = p_cmi27
             AND abb35 = p_cmi29
             AND abb36 = p_cmi31
             AND abb37 = p_cmi33
          SELECT SUM(abb07) INTO l_aeh12 FROM aba_file,abb_file,aag_file
           WHERE aba00 = abb00
             AND aba01 = abb01
             AND abb00 = aag00
             AND abb03 = aag01
             AND abb00 = g_cdb00
             AND abb03 = p_aah01
             AND aba03 = g_cdb01
             AND aba04 = g_cdb02
             AND aba06 = 'CA'
             AND abb06 = '2'
             AND abapost = 'Y'
             AND abb11 = p_cmi13
             AND abb12 = p_cmi15
             AND abb13 = p_cmi17
             AND abb14 = p_cmi19
             AND abb31 = p_cmi21
             AND abb32 = p_cmi23
             AND abb33 = p_cmi25
             AND abb34 = p_cmi27
             AND abb35 = p_cmi29
             AND abb36 = p_cmi31
             AND abb37 = p_cmi33
          IF cl_null(l_aeh11) THEN LET l_aeh11 = 0 END IF
          IF cl_null(l_aeh12) THEN LET l_aeh12 = 0 END IF
          LET l_d = l_d - l_aeh11
          LET l_c = l_c - l_aeh12
       ELSE
       #FUN-D80058--add--end--
      #期初
      SELECT SUM(aah04),SUM(aah05) INTO l_aah04,l_aah05
        FROM aah_file
       WHERE aah00 = g_cdb00
         AND aah01 = p_aah01
         AND aah02 = g_cdb01
         AND aah03 < g_cdb02
      IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
      IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF
      LET l_b_bal = l_aah04 - l_aah05

      #期间
      SELECT SUM(aah04),SUM(aah05) INTO l_d,l_c
        FROM aah_file
       WHERE aah00 = g_cdb00
         AND aah01 = p_aah01
         AND aah02 = g_cdb01
         AND aah03 = g_cdb02
      IF cl_null(l_d) THEN LET l_d = 0 END IF
      IF cl_null(l_c) THEN LET l_c = 0 END IF

      SELECT SUM(abb07) INTO l_aah04 FROM aba_file,abb_file,aag_file
       WHERE aba00 = abb00 
         AND aba01 = abb01
         AND abb00 = aag00
         AND abb03 = aag01
         AND abb00 = g_cdb00
         AND abb03 = p_aah01
         AND aba03 = g_cdb01
         AND aba04 = g_cdb02
         AND aba06 = 'CA'
         AND abb06 = '1'
         AND abapost = 'Y'
      SELECT SUM(abb07) INTO l_aah05 FROM aba_file,abb_file,aag_file
       WHERE aba00 = abb00 
         AND aba01 = abb01
         AND abb00 = aag00
         AND abb03 = aag01
         AND abb00 = g_cdb00
         AND abb03 = p_aah01
         AND aba03 = g_cdb01
         AND aba04 = g_cdb02
         AND aba06 = 'CA'
         AND abb06 = '2'
         AND abapost = 'Y'
      IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF 
      IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF 
      LET l_d = l_d - l_aah04
      LET l_c = l_c - l_aah05
      END IF
   ELSE
      #期初
      SELECT SUM(aao05),SUM(aao06) INTO l_aah04,l_aah05
        FROM aao_file
       WHERE aao00 = g_cdb00
         AND aao01 = p_aah01
         AND aao02 = p_aao02
         AND aao03 = g_cdb01
         AND aao04 < g_cdb02
      IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
      IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF
      LET l_b_bal = l_aah04 - l_aah05

      #期间
      SELECT SUM(aao05),SUM(aao06) INTO l_d,l_c
        FROM aao_file
       WHERE aao00 = g_cdb00
         AND aao01 = p_aah01
         AND aao02 = p_aao02
         AND aao03 = g_cdb01
         AND aao04 = g_cdb02
      IF cl_null(l_d) THEN LET l_d = 0 END IF
      IF cl_null(l_c) THEN LET l_c = 0 END IF

      SELECT SUM(abb07) INTO l_aah04 FROM aba_file,abb_file,aag_file
       WHERE aba00 = abb00 
         AND aba01 = abb01
         AND abb00 = aag00
         AND abb03 = aag01
         AND abb00 = g_cdb00
         AND abb03 = p_aah01
         AND abb05 = p_aao02
         AND aba03 = g_cdb01
         AND aba04 = g_cdb02
         AND aba06 = 'CA'
         AND abb06 = '1'
         AND abapost = 'Y'
      SELECT SUM(abb07) INTO l_aah05 FROM aba_file,abb_file,aag_file
       WHERE aba00 = abb00 
         AND aba01 = abb01
         AND abb00 = aag00
         AND abb03 = aag01
         AND abb00 = g_cdb00
         AND abb03 = p_aah01
         AND abb05 = p_aao02
         AND aba03 = g_cdb01
         AND aba04 = g_cdb02
         AND aba06 = 'CA'
         AND abb06 = '2'
         AND abapost = 'Y'
      IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF 
      IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF 
      LET l_d = l_d - l_aah04
      LET l_c = l_c - l_aah05
   END IF

   LET l_e_bal = l_b_bal + l_d - l_c - p_cmi08
   IF cl_null(l_e_bal) THEN LET l_e_bal = 0 END IF

   RETURN l_b_bal,l_d,l_c,l_e_bal

END FUNCTION


FUNCTION q310_g()
   DEFINE l_npp01     LIKE npp_file.npp01
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_exist     LIKE type_file.chr1
   DEFINE l_cmi08     LIKE cmi_file.cmi08
   DEFINE l_cdb05     LIKE cdb_file.cdb05
   DEFINE l_nppglno   LIKE npp_file.nppglno

   IF cl_null(g_cdb11) OR cl_null(g_cdb00) OR cl_null(g_cdb01) OR cl_null(g_cdb02) THEN
      RETURN
   END IF

   SELECT SUM(cmi08) INTO l_cmi08 FROM cmi_file
    WHERE cmi00 = g_cdb00
      AND cmi01 = g_cdb01
      AND cmi02 = g_cdb02
      AND cmi04 <> '1'
      AND cmiacti = 'Y'
   SELECT SUM(cdb05) INTO l_cdb05 FROM cdb_file
    WHERE cdb00 = g_cdb00
      AND cdb01 = g_cdb01
      AND cdb02 = g_cdb02
      AND cdb11 = g_cdb11
      AND cdb04 <> '1' 
   IF cl_null(l_cmi08) THEN LET l_cmi08 = 0 END IF
   IF cl_null(l_cdb05) THEN LET l_cdb05 = 0 END IF

   IF l_cmi08 <> l_cdb05 THEN
      CALL cl_err('','axc-079',0)
      RETURN
   END IF
   IF l_cmi08 = 0 THEN
      CALL cl_err('cmi08','axc-080',0)
      RETURN
   END IF
   IF l_cdb05 = 0 THEN
      CALL cl_err('cdb05','axc-080',0)
      RETURN
   END IF

   LET l_npp01 = g_cdb11 CLIPPED,'-',g_cdb01 USING "&&&&",g_cdb02 USING "&&",'0001'

   IF g_cdb00 = g_ccz.ccz12 THEN
      LET g_npptype  = '0'
   ELSE
      LET g_npptype  = '1'
   END IF

   LET l_exist = 'N'
   LET l_cnt = 0

   #已生成成本分录底稿
   SELECT COUNT(*) INTO l_cnt FROM npp_file
  # WHERE npp00   = 1  #FUN-AA0025
    WHERE npp00   = 8  #FUN-AA0025
      AND npp01   = l_npp01
      AND npp011  = 1
      AND nppsys  = 'CA'
      AND npptype = g_npptype
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN
      LET l_exist = 'Y'
   END IF

   IF l_exist = 'Y' THEN
      #check是否已经抛转凭证
      SELECT nppglno INTO l_nppglno FROM npp_file
   #   WHERE npp00   = 1  #FUN-AA0025
       WHERE npp00   = 8  #FUN-AA0025
         AND npp01   = l_npp01
         AND npp011  = 1
         AND nppsys  = 'CA'
         AND npptype = g_npptype
      IF NOT cl_null(l_nppglno) THEN
         CALL cl_err(l_nppglno,'axc-078',0)
         RETURN
      END IF
   END IF

   IF l_exist = 'Y' THEN
      IF NOT cl_confirm('mfg8002') THEN
         RETURN
      END IF 
   ELSE
      IF NOT cl_confirm('axr-309') THEN
         RETURN
      END IF
   END IF

   LET g_success = 'Y'
   BEGIN WORK
   CALL s_showmsg_init()
   CALL q310_g1(l_npp01)
   IF g_success = 'Y' THEN
      UPDATE cdb_file SET cdb13 = l_npp01 
       WHERE cdb00 = g_cdb00
         AND cdb11 = g_cdb11
         AND cdb01 = g_cdb01
         AND cdb02 = g_cdb02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('cdb13',l_npp01,'update cdb13',SQLCA.sqlcode,1)
         LET g_success = 'N'
#     ELSE
#        LET g_cdb13 = l_npp01
#        DISPLAY g_cdb13 TO cdb13
      END IF
   END IF
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT cdb13 INTO g_cdb13 FROM cdb_file
    WHERE cdb00 = g_cdb00
      AND cdb11 = g_cdb11
      AND cdb01 = g_cdb01
      AND cdb02 = g_cdb02
   DISPLAY g_cdb13 TO cdb13
#  CLOSE q310_b_cs          
#  OPEN q310_b_cs          

END FUNCTION

FUNCTION q310_g1(p_npp01)
   DEFINE p_npp01     LIKE npp_file.npp01
   DEFINE l_npp       RECORD LIKE npp_file.*
   DEFINE l_npq       RECORD LIKE npq_file.*
   DEFINE l_cmi_cnt   LIKE type_file.num5
   DEFINE l_cdb_cnt   LIKE type_file.num5
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_npq02     LIKE npq_file.npq02
   DEFINE l_date      LIKE type_file.dat
   DEFINE l_npq07f_d  LIKE npq_file.npq07     #CHI-CB0025 add
   DEFINE l_npq07_d   LIKE npq_file.npq07     #CHI-CB0025 add
   DEFINE l_npq07f_c  LIKE npq_file.npq07     #CHI-CB0025 add
   DEFINE l_npq07_c   LIKE npq_file.npq07     #CHI-CB0025 add
   DEFINE l_diff_f    LIKE npq_file.npq07     #CHI-CB0025 add
   DEFINE l_diff      LIKE npq_file.npq07     #CHI-CB0025 add
   DEFINE l_aag05     LIKE aag_file.aag05     #No.MOD-D20062
   DEFINE l_flag      LIKE type_file.chr1     #FUN-D40118 add
   
   INITIALIZE l_npp.* TO NULL
   INITIALIZE l_npq.* TO NULL

   LET l_npp.nppsys   = 'CA'
  #LET l_npp.npp00    = 1  #FUN-AA0025
   LET l_npp.npp00    = 8  #FUN-AA0025
   LET l_npp.npp01    = p_npp01
   LET l_npp.npp011   = 1
   LET l_date         = MDY(g_cdb02,1,g_cdb01)
   LET l_npp.npp02    = s_last(l_date)
   LET l_npp.npp03    = NULL
   LET l_npp.npp06    = g_plant
   LET l_npp.nppglno  = NULL
   LET l_npp.npptype  = g_npptype
   LET l_npp.npplegal = g_legal  #FUN-980009 add

   DELETE FROM npp_file
    WHERE nppsys  = 'CA'
     #AND npp00   = 1  #FUN-AA0025
      AND npp00   = 8  #FUN-AA0025
      AND npp01   = p_npp01
      AND npp011  = 1
      AND npptype = g_npptype

   INSERT INTO npp_file VALUES(l_npp.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('nppsys','CA','insert npp_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_bgjob = 'N' THEN 
       MESSAGE l_npp.npp01
   END IF

   #insert npq_file 單身
   DELETE FROM npq_file
    WHERE npqsys  = 'CA'
     #AND npq00   = 1 #FUN-AA0025
      AND npq00   = 8 #FUN-AA0025
      AND npq01   = p_npp01
      AND npq011  = 1
      AND npqtype = g_npptype

   IF STATUS THEN LET g_success = 'N' RETURN END IF
#FUN-B40056 --Begin
   DELETE FROM tic_file WHERE tic04 = p_npp01

   IF STATUS THEN LET g_success = 'N' RETURN END IF
#FUN-B40056 --End

   LET l_cmi_cnt = g_cmi.getlength()
   LET l_npq02 = 1
   FOR l_i = 1  TO l_cmi_cnt
       INITIALIZE l_npq.* TO NULL
       LET l_npq.npqsys ='CA'
      #LET l_npq.npq00  = 1 #FUN-AA0025
       LET l_npq.npq00  = 8 #FUN-AA0025
       LET l_npq.npq01  =p_npp01
       LET l_npq.npq011 = 1
       LET l_npq.npq02 = l_npq02
       LET l_npq.npq03 = g_cmi[l_i].cmi05
#No.MOD-D20062 --begin
#       LET l_npq.npq04 = ''
#       LET l_npq.npq05 = g_cmi[l_i].cmi06
       CALL s_def_npq3(g_cdb00,l_npq.npq03,g_prog,l_npq.npq01,'','') RETURNING l_npq.npq04  #摘要 
       LET l_aag05 ='' 
       SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = g_cdb00 AND aag01 = l_npq.npq03
       IF l_aag05 ='Y' THEN 
          LET l_npq.npq05 = g_cmi[l_i].cmi06
       ELSE 
          LET l_npq.npq05 = ' '
       END IF 
#No.MOD-D20062 --end
 #      IF g_cmi[l_i].cmi08 > 0 THEN
          LET l_npq.npq06 = '2'
          LET l_npq.npq07f = g_cmi[l_i].cmi08
          LET l_npq.npq07  = g_cmi[l_i].cmi08
  #     ELSE
  #        LET l_npq.npq06 = '2'  #add by huanglf170113
  #        LET l_npq.npq07f = g_cmi[l_i].cmi08 * -1
  #        LET l_npq.npq07  = g_cmi[l_i].cmi08 * -1
  #     END IF
       LET l_npq.npq07f  = cl_digcut(l_npq.npq07f,t_azi04)    #CHI-CB0025 add
       LET l_npq.npq07   = cl_digcut(l_npq.npq07,g_azi04)     #CHI-CB0025 add
       LET l_npq.npq08 = NULL
       LET l_npq.npq11 = ' '
       LET l_npq.npq12 = ' '
       LET l_npq.npq13 = ' '
       LET l_npq.npq14 = ' '
       LET l_npq.npq15 = NULL
       LET l_npq.npq21 = NULL
       LET l_npq.npq22 = NULL
       LET l_npq.npq24 = g_aza.aza17
       LET l_npq.npq25 = 1
       LET l_npq.npq30 = g_plant
       LET l_npq.npq31 = ' '
       LET l_npq.npq32 = ' '
       LET l_npq.npq33 = ' '
       LET l_npq.npq34 = ' '
       LET l_npq.npq35 = ' '
       LET l_npq.npq36 = ' '
       LET l_npq.npq37 = ' '
       LET l_npq.npqtype = g_npptype
       LET l_npq.npqlegal = g_legal 
       #No.MOD-C40106  --Begin
       IF l_npq.npq07 = 0 AND l_npq.npq07f = 0 THEN 
           CONTINUE FOR
       END IF 
       #No.MOD-C40106  --End
       #FUN-D40118--add--str--
       SELECT aag44 INTO g_aag44 FROM aag_file
        WHERE aag00 = g_cdb00
          AND aag01 = l_npq.npq03
       IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
          CALL s_chk_ahk(l_npq.npq03,g_cdb00) RETURNING l_flag
          IF l_flag = 'N'   THEN
             LET l_npq.npq03 = ''
          END IF
       END IF
       #FUN-D40118--add--end--
       INSERT INTO npq_file VALUES(l_npq.*)
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
          LET g_success = 'N'
          RETURN
       END IF
       LET l_npq02 = l_npq02 + 1 
   END FOR

   LET l_cdb_cnt = g_cdb.getlength()
   FOR l_i = 1  TO l_cdb_cnt
       INITIALIZE l_npq.* TO NULL
       LET l_npq.npqsys ='CA'
      #LET l_npq.npq00  = 1  #FUN-AA0025
       LET l_npq.npq00  = 8  #FUN-AA0025
       LET l_npq.npq01  =p_npp01
       LET l_npq.npq011 = 1
       LET l_npq.npq02 = l_npq02
       LET l_npq.npq03 = g_cdb[l_i].cdb12
#No.MOD-D20062 --begin
#       LET l_npq.npq04 = ''
#       LET l_npq.npq05 = g_cdb[l_i].cdb03
       CALL s_def_npq3(g_cdb00,l_npq.npq03,g_prog,l_npq.npq01,'','') RETURNING l_npq.npq04  #摘要 
       LET l_aag05 ='' 
       SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = g_cdb00 AND aag01 = l_npq.npq03
       IF l_aag05 ='Y' THEN 
          LET l_npq.npq05 = g_cdb[l_i].cdb03
       ELSE 
          LET l_npq.npq05 = ' '
       END IF 
#No.MOD-D20062 --end
       LET l_npq.npq06 = '1'
       LET l_npq.npq07f = g_cdb[l_i].cdb05
       LET l_npq.npq07  = g_cdb[l_i].cdb05
       LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)    #CHI-CB0025 add
       LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)     #CHI-CB0025 add
       LET l_npq.npq08 = NULL
       LET l_npq.npq11 = ' '
       LET l_npq.npq12 = ' '
       LET l_npq.npq13 = ' '
       LET l_npq.npq14 = ' '
       LET l_npq.npq15 = NULL
       LET l_npq.npq21 = NULL
       LET l_npq.npq22 = NULL
       LET l_npq.npq24 = g_aza.aza17
       LET l_npq.npq25 = 1
       LET l_npq.npq30 = g_plant
       LET l_npq.npq31 = ' '
       LET l_npq.npq32 = ' '
       LET l_npq.npq33 = ' '
       LET l_npq.npq34 = ' '
       LET l_npq.npq35 = ' '
       LET l_npq.npq36 = ' '
       LET l_npq.npq37 = ' '
       LET l_npq.npqtype = g_npptype
       LET l_npq.npqlegal = g_legal 
       #No.MOD-C40106  --Begin
       IF l_npq.npq07 = 0 AND l_npq.npq07f = 0 THEN
           CONTINUE FOR
       END IF
       #No.MOD-C40106  --End
       #FUN-D40118--add--str--
       SELECT aag44 INTO g_aag44 FROM aag_file
        WHERE aag00 = g_cdb00 
          AND aag01 = l_npq.npq03
       IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
          CALL s_chk_ahk(l_npq.npq03,g_cdb00) RETURNING l_flag
          IF l_flag = 'N'   THEN
             LET l_npq.npq03 = ''
          END IF
       END IF
       #FUN-D40118--add--end--
       INSERT INTO npq_file VALUES(l_npq.*)
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
          LET g_success = 'N'
          RETURN
       END IF
       LET l_npq02 = l_npq02 + 1 
   END FOR
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021
#CHI-CB0025 str add-----
  #調整尾差到第一項
   SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d
     FROM npq_file 
    WHERE npqsys  = 'CA'
      AND npq00   = 8 
      AND npq01   = p_npp01
      AND npq011  = 1
      AND npq06   = '1'
      AND npqtype = g_npptype


   SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c
     FROM npq_file 
    WHERE npqsys  = 'CA'
      AND npq00   = 8 
      AND npq01   = p_npp01
      AND npq011  = 1
      AND npq06   = '2'
      AND npqtype = g_npptype
   LET l_diff_f = 0 
   LET l_diff   = 0 
   LET l_diff_f = l_npq07f_d - l_npq07f_c
   LET l_diff   = l_npq07_d  - l_npq07_c

   IF l_diff_f <> 0 THEN 
   SELECT MIN(npq02) INTO l_npq02  
     FROM npq_file 
    WHERE npqsys  = 'CA'
      AND npq00   = 8 
      AND npq01   = p_npp01
      AND npq011  = 1
      AND npq06   = '2'
      AND npqtype = g_npptype

   UPDATE npq_file 
      SET npq07f = npq07f + l_diff_f
    WHERE npqsys  = 'CA'
      AND npq00   = 8 
      AND npq01   = p_npp01
      AND npq011  = 1
      AND npq02   = l_npq02
      AND npq06   = '2'
      AND npqtype = g_npptype
   END IF

   IF l_diff <> 0 THEN 
   SELECT MIN(npq02) INTO l_npq02  
     FROM npq_file 
    WHERE npqsys  = 'CA'
      AND npq00   = 8 
      AND npq01   = p_npp01
      AND npq011  = 1
      AND npq06   = '2'
      AND npqtype = g_npptype

   UPDATE npq_file 
      SET npq07  = npq07 + l_diff 
    WHERE npqsys  = 'CA'
      AND npq00   = 8 
      AND npq01   = p_npp01
      AND npq011  = 1
      AND npq02   = l_npq02
      AND npq06   = '2'
      AND npqtype = g_npptype
   END IF
  #CHI-CB0025 end add-----   
END FUNCTION

#FUN-D80058--add--str--
FUNCTION q310_visible(p_code)
   DEFINE p_code    LIKE type_file.num5

   CALL cl_set_comp_visible("cmi13,cmi14,cmi15,cmi16,cmi17,cmi18",TRUE)
   CALL cl_set_comp_visible("cmi19,cmi20,cmi21,cmi22,cmi23,cmi24",TRUE)
   CALL cl_set_comp_visible("cmi25,cmi26,cmi27,cmi28,cmi29,cmi30",TRUE)
   CALL cl_set_comp_visible("cmi31,cmi32,cmi33,cmi34",TRUE)
   CASE p_code
      WHEN  1
         CALL cl_set_comp_visible("cmi15,cmi16,cmi17,cmi18,cmi19,cmi20",FALSE)
         CALL cl_set_comp_visible("cmi21,cmi22,cmi23,cmi24,cmi25,cmi26",FALSE)
         CALL cl_set_comp_visible("cmi27,cmi28,cmi29,cmi30,cmi31,cmi32",FALSE)
         CALL cl_set_comp_visible("cmi33,cmi34",FALSE)
      WHEN  2
         CALL cl_set_comp_visible("cmi17,cmi18,cmi19,cmi20,cmi21,cmi22",FALSE)
         CALL cl_set_comp_visible("cmi23,cmi24,cmi25,cmi26,cmi27,cmi28",FALSE)
         CALL cl_set_comp_visible("cmi29,cmi30,cmi31,cmi32,cmi33,cmi34",FALSE)
      WHEN 3
         CALL cl_set_comp_visible("cmi19,cmi20,cmi21,cmi22,cmi23,cmi24",FALSE)
         CALL cl_set_comp_visible("cmi25,cmi26,cmi27,cmi28,cmi29,cmi30",FALSE)
         CALL cl_set_comp_visible("cmi31,cmi32,cmi33,cmi34",FALSE)
      WHEN 4
         CALL cl_set_comp_visible("cmi21,cmi22,cmi23,cmi24,cmi25,cmi26",FALSE)
         CALL cl_set_comp_visible("cmi27,cmi28,cmi29,cmi30,cmi31,cmi32",FALSE)
         CALL cl_set_comp_visible("cmi33,cmi34",FALSE)
      WHEN 5
         CALL cl_set_comp_visible("cmi23,cmi24,cmi25,cmi26,cmi27,cmi28",FALSE)
         CALL cl_set_comp_visible("cmi29,cmi30,cmi31,cmi32,cmi33,cmi34",FALSE)
      WHEN 6
         CALL cl_set_comp_visible("cmi25,cmi26,cmi27,cmi28,cmi29,cmi30",FALSE)
         CALL cl_set_comp_visible("cmi31,cmi32,cmi33,cmi34",FALSE)
      WHEN 7
         CALL cl_set_comp_visible("cmi27,cmi28,cmi29,cmi30,cmi31,cmi32",FALSE)
         CALL cl_set_comp_visible("cmi33,cmi34",FALSE)
      WHEN 8
         CALL cl_set_comp_visible("cmi29,cmi30,cmi31,cmi32,cmi33,cmi34",FALSE)
      WHEN 9
         CALL cl_set_comp_visible("cmi31,cmi32,cmi33,cmi34",FALSE)
      WHEN 10
         CALL cl_set_comp_visible("cmi33,cmi34",FALSE)
      WHEN 0
         CALL cl_set_comp_visible("cmi13,cmi14,cmi15,cmi16,cmi17,cmi18",FALSE)
         CALL cl_set_comp_visible("cmi19,cmi20,cmi21,cmi22,cmi23,cmi24",FALSE)
         CALL cl_set_comp_visible("cmi25,cmi26,cmi27,cmi28,cmi29,cmi30",FALSE)
         CALL cl_set_comp_visible("cmi31,cmi32,cmi33,cmi34",FALSE)
   END CASE
END FUNCTION
#FUN-D80058--add--end--
