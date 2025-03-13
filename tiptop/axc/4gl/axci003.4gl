# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axci003.4gl
# Descriptions...: 人工分攤權數設定作業,製費分攤權數設定作業
# Date & Author..: 09/11/26 By Carrier #No.FUN-9B0118
# Modify.........: No.MOD-9C0292 09/12/19 By Carrier 拿到 重新计算和整批重算的action
# Modify.........: No.MOD-9C0307 09/12/21 By Carrier cay09/cay10 赋值
# Modify.........: No:FUN-9C0112 09/12/22 By Carrier cay05比率变成权数
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:FUN-B40004 11/04/06 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No:MOD-B50167 11/05/19 By wujie  q_gem4-->q_gem
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60190 11/06/17 By xianghui 在進入單身時要將g_action_choice清空
# Modify.........: No.TQC-B60253 11/06/21 By zhangweib 單頭抓數據時加上caylegal
# Modify.........: No.MOD-B80342 11/08/30 By yinhy 單頭"成本中心"cay04"，axrs010中ccz06='2'時為必輸欄位，否則為選填欄位
# Modify.........: No.TQC-B90005 11/09/01 By yinhy 成本中心cay04檢查時，當agls103中aaz90勾選時才用s_costcenter_chk做檢查
# Modify.........: No.MOD-BA0111 11/10/14 By yinhy 複製時，增加單頭"成本中心"cay04"，axrs010中ccz06='2'時為才必輸欄位
# Modify.........: No:MOD-BB0117 11/11/12 By johung 當agls103中aaz90勾選時才檢查s_costcener_chk
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-C90041 12/09/10 By fengmy 檢查是否已存在cay_file中資料時，沒有考慮cay04
# Modify.........: No:MOD-C80052 12/09/28 By wangwei 整批複製時出現axc-005錯誤
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50101 13/05/13 By suncx 整批生成時，QBE條件中部門開窗應過濾掉無效部門
# Modify.........: No:FUN-D60071 13/06/19 By lixh1 增加整批生成后成功与否的提示

DATABASE ds   #No.FUN-9B0118

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE g_caya              RECORD LIKE cay_file.*             #成本分攤比例檔
DEFINE g_caya_t            RECORD LIKE cay_file.*             #成本分攤比例檔(舊值)
DEFINE g_caya_o            RECORD LIKE cay_file.*             #成本分攤比例檔(舊值)
DEFINE g_cay00             LIKE cay_file.cay00                #分攤類別 1.人工 2.製費
DEFINE g_cay11             LIKE cay_file.cay11                #帐套     #No.FUN-9B0118
DEFINE g_cay01             LIKE cay_file.cay01                #年度
DEFINE g_cay02             LIKE cay_file.cay02                #月份
DEFINE g_cay04             LIKE cay_file.cay04                #成本中心
DEFINE g_cay12             LIKE cay_file.cay12                #成本中心
DEFINE g_cay               DYNAMIC ARRAY OF RECORD            #程式變數(Program Variables)
                           cay06   LIKE cay_file.cay06,       #会计科目
                           aag02   LIKE aag_file.aag02,       #会计科目名称
                           cay03   LIKE cay_file.cay03,       #部门编号
                           gem02_2 LIKE gem_file.gem02,       #部门名称
                           cay08   LIKE cay_file.cay08,       #部门属性
                           cay05   LIKE cay_file.cay05,       #分攤比例
                           cayacti LIKE cay_file.cayacti      #有效否
                           END RECORD 
DEFINE g_cay_t             RECORD                             #程式變數 (舊值)
                           cay06   LIKE cay_file.cay06,       #会计科目
                           aag02   LIKE aag_file.aag02,       #会计科目名称
                           cay03   LIKE cay_file.cay03,       #部门编号
                           gem02_2 LIKE gem_file.gem02,       #部门名称
                           cay08   LIKE cay_file.cay08,       #部门属性
                           cay05   LIKE cay_file.cay05,       #分攤比例
                           cayacti LIKE cay_file.cayacti      #有效否
                           END RECORD 
DEFINE g_wc                STRING 
DEFINE g_wc2               STRING 
DEFINE g_sql               STRING 
DEFINE g_rec_b             LIKE type_file.num5                #單身筆數
DEFINE l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT
DEFINE g_argv1             LIKE type_file.chr1

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

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5

   OPTIONS                                    #改變一些系統預設值
       INPUT NO WRAP,
          FIELD ORDER FORM                   #整個畫面會依照p_per設定的欄位順序做輸入，忽略INPUT寫的順序 #FUN-730018
       DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間)

   LET p_row = 4 LET p_col = 15
   OPEN WINDOW i003_w AT p_row,p_col WITH FORM "axc/42f/axci003"    #顯示畫面
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_forupd_sql = "SELECT * from cay_file WHERE cay00=? AND cay01=? AND cay02=? AND cay03=? AND cay04=? AND cay06=? AND cay11 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i003_cl CURSOR FROM g_forupd_sql

   CALL i003_getmsg()
   CALL i003_menu()
   CLOSE WINDOW i003_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間)
END MAIN

FUNCTION i003_cs()

   CLEAR FORM                             #清除畫面
   CALL g_cay.clear()
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_cay00 TO NULL
   INITIALIZE g_cay11 TO NULL
   INITIALIZE g_cay01 TO NULL
   INITIALIZE g_cay02 TO NULL
   INITIALIZE g_cay04 TO NULL
   INITIALIZE g_cay12 TO NULL

   CONSTRUCT g_wc ON cay00,cay11,cay01,cay02,cay04,cay12,
                     cay06,cay03,cay08,cay05,cayacti
                FROM cay00,cay11,cay01,cay02,cay04,cay12,
                     s_cay[1].cay06,s_cay[1].cay03,s_cay[1].cay08,
                     s_cay[1].cay05,s_cay[1].cayacti

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(cay11)       #帐套
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay11
            WHEN INFIELD(cay04)   #成本中心
                 CALL cl_init_qry_var()
#                LET g_qryparam.form     ="q_gem4"
                 LET g_qryparam.form     ="q_gem"   #No.MOD-B50167
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay04
                 NEXT FIELD cay04
            WHEN INFIELD(cay06)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay06
                 NEXT FIELD cay06
            WHEN INFIELD(cay03)   #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay03
                 NEXT FIELD cay03
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cayuser', 'caygrup')

   IF INT_FLAG THEN RETURN END IF


   LET g_sql= "SELECT UNIQUE cay00,cay11,cay01,cay02,cay04,caylegal ",  #TQC-B60253   Add caylegal
              "  FROM cay_file",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY cay00,cay11,cay01,cay02,cay04"
   PREPARE i003_prepare FROM g_sql      #預備一下
   DECLARE i003_b_cs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i003_prepare

   LET g_sql_tmp = "SELECT UNIQUE cay00,cay11,cay01,cay02,cay04 ",
                   "  FROM cay_file",
                   " WHERE ", g_wc CLIPPED,
                   "  INTO TEMP x"
   DROP TABLE x
   PREPARE i003_precount_x FROM g_sql_tmp
   EXECUTE i003_precount_x

   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i003_precount FROM g_sql
   DECLARE i003_count CURSOR FOR i003_precount
END FUNCTION

FUNCTION i003_menu()

   WHILE TRUE
      CALL i003_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i003_a()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i003_u()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i003_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
              CALL i003_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i003_copy()
            END IF

         WHEN "reproduce1"
            IF cl_chk_act_auth() THEN
               CALL i003_batch_copy()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i003_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i003_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.MOD-9C0292  --Begin
         #WHEN "recalculate"   #重新計算
         #   IF cl_chk_act_auth() THEN
         #      IF g_caya.cay09 != '1' THEN
         #         IF cl_sure(0,0) THEN
         #             CALL i003_t(g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay03,
         #                         g_caya.cay06,g_caya.cay09,g_caya.cay10,g_caya.cay11 )
         #         END IF
         #      END IF
         #   END IF
         #No.MOD-9C0292  --End  
         WHEN "generate"      #批次產生
            IF cl_chk_act_auth() THEN
                LET g_success = 'N' #FUN-D60071 
               CALL i003_g()
                #FUN-D60071 -----Begin------
               IF g_success = 'Y' THEN
                  CALL cl_err('','axc-921',1)
               ELSE
                  CALL cl_err('','axc-922',1)
               END IF 
             #FUN-D60071 -----End--------
            END IF
         #No.MOD-9C0292  --Begin
         #WHEN "recalculate1"
         #   IF cl_chk_act_auth() THEN
         #      CALL i003_t1()
         #   END IF
         #No.MOD-9C0292  --End  
         WHEN "exporttoexcel"
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cay),'','')
      END CASE
   END WHILE
END FUNCTION

FUNCTION i003_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_cay.clear()
   INITIALIZE g_cay11 LIKE cay_file.cay11
   INITIALIZE g_cay01 LIKE cay_file.cay01
   INITIALIZE g_cay02 LIKE cay_file.cay02
   INITIALIZE g_cay04 LIKE cay_file.cay04
   INITIALIZE g_cay12 LIKE cay_file.cay12
   INITIALIZE g_caya.* LIKE cay_file.*             #DEFAULT 設定
   #預設值及將數值類變數清成零
   LET g_caya_t.* = g_caya.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_caya.cay00 = '1'
      LET g_caya.cay11 = g_aza.aza81
      LET g_caya.cay01 = g_ccz.ccz01
      LET g_caya.cay02 = g_ccz.ccz02
      LET g_caya.cayuser=g_user
      LET g_caya.caygrup=g_grup
      LET g_caya.caydate=g_today
      LET g_caya.cayacti='Y'
      LET g_caya.cayoriu=g_user
      LET g_caya.cayorig=g_grup
      LET g_caya.caylegal = g_legal    #FUN-A50075
      CALL i003_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
          INITIALIZE g_caya.* TO NULL
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          EXIT WHILE
      END IF
      IF g_caya.cay00 IS NULL OR g_caya.cay01 IS NULL OR g_caya.cay02 IS NULL OR 
         g_caya.cay04 IS NULL OR g_caya.cay11 IS NULL OR g_caya.cay12 IS NULL THEN     # KEY 不可空白
         CONTINUE WHILE
      END IF
      LET g_cay00 = g_caya.cay00
      LET g_cay01 = g_caya.cay01
      LET g_cay02 = g_caya.cay02
      LET g_cay04 = g_caya.cay04
      LET g_cay12 = g_caya.cay12
      LET g_cay11 = g_caya.cay11
      LET g_rec_b=0
      CALL i003_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i003_u()
   DEFINE l_sql    STRING
   DEFINE l_first  LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF
   IF g_cay01 IS NULL OR g_cay02 IS NULL OR g_cay00 IS NULL OR 
      g_cay04 IS NULL OR g_cay11 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')

   LET g_caya_t.*=g_caya.*
   LET g_caya_o.*=g_caya.*
   LET g_caya.caymodu=g_user
   LET g_caya.caygrup=g_grup
   LET g_caya.caydate=g_today
   LET g_success = 'Y'
   BEGIN WORK

   WHILE TRUE
       CALL i003_i("u")                      # 欄位更改
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_caya.cay00   = g_caya_o.cay00
           LET g_caya.cay01   = g_caya_o.cay01
           LET g_caya.cay02   = g_caya_o.cay02
           LET g_caya.cay04   = g_caya_o.cay04
           LET g_caya.cay12   = g_caya_o.cay12
           LET g_caya.cay11   = g_caya_o.cay11
           LET g_caya.caymodu = g_caya_o.caymodu
           LET g_caya.caygrup = g_caya_o.caygrup
           LET g_caya.caydate = g_caya_o.caydate
           CALL cl_err('',9001,0)
           EXIT WHILE
       END IF
       UPDATE cay_file
          SET cay01 = g_caya.cay01,
              cay02 = g_caya.cay02,
              cay00 = g_caya.cay00,
              cay11 = g_caya.cay11,
              cay04 = g_caya.cay04,
              cay12 = g_caya.cay12,
              caymodu = g_caya.caymodu,
              caygrup = g_caya.caygrup,
              caydate = g_caya.caydate
        WHERE cay01 = g_caya_o.cay01
          AND cay02 = g_caya_o.cay02
          AND cay00 = g_caya_o.cay00
          AND cay11 = g_caya_o.cay11
          AND cay04 = g_caya_o.cay04
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","cay_file",g_caya_t.cay01,g_caya_t.cay02,SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
          EXIT WHILE
       END IF
#      CALL i003_chk_u()  #No.FUN-9C0112
       EXIT WHILE
   END WHILE
#  LET g_cay00 = g_caya.cay00
#  LET g_cay01 = g_caya.cay01
#  LET g_cay02 = g_caya.cay02
#  LET g_cay04 = g_caya.cay04
#  LET g_cay11 = g_caya.cay11
#  CALL i003_show()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   OPEN i003_b_cs
   LET g_jump = g_curs_index
   LET mi_no_ask = TRUE
   CALL i003_fetch('/')

END FUNCTION

#處理INPUT
FUNCTION i003_i(p_cmd)
   DEFINE l_flag    LIKE type_file.chr1,             #判斷必要欄位是否有輸入
          p_cmd     LIKE type_file.chr1              #a:輸入 u:更改

   DISPLAY BY NAME g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay04,g_caya.cay12,g_caya.cay11

   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_caya.cay00,g_caya.cay11,g_caya.cay01,g_caya.cay02,g_caya.cay04,g_caya.cay12
                 WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i003_set_entry(p_cmd)
         CALL i003_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         #No.MOD-B80342  --Begin
         IF cl_null(g_caya.cay04) THEN
                  SELECT ccz06 INTO g_ccz.ccz06 FROM ccz_file
            IF g_ccz.ccz06 != '2' THEN
                 LET g_caya.cay04 = ' '
            END IF
         END IF
         #No.MOD-B80342  --End

      AFTER FIELD cay00
         IF NOT cl_null(g_caya.cay00) THEN
            IF g_caya.cay00 NOT matches '[123456]' THEN
               IF p_cmd='a' THEN
                  NEXT FIELD cay00
               ELSE
                  RETURN
               END IF
            END IF
            LET g_caya_t.cay00=g_caya.cay00
         ELSE
            CALL cl_err(g_caya.cay00,'mfg5103',0)
            NEXT FIELD cay00
         END IF

      AFTER FIELD cay01    #年度
         IF NOT cl_null(g_caya.cay01) THEN
            IF g_caya.cay01 < g_ccz.ccz01 THEN
               CALL cl_err(g_caya.cay01,'axc-095',0)
               IF p_cmd='a' THEN
                  NEXT FIELD cay01
               ELSE
                  RETURN
               END IF
            END IF
            LET g_caya_t.cay01=g_caya.cay01
         ELSE
            CALL cl_err(g_caya.cay01,'mfg5103',0)
            NEXT FIELD cay01
         END IF

      AFTER FIELD cay02    #月份
         IF NOT cl_null(g_caya.cay02) THEN
            IF (g_caya.cay01 = g_ccz.ccz01 AND g_caya.cay02 < g_ccz.ccz02 ) THEN
               CALL cl_err(g_caya.cay02,'axc-095',0)
               IF p_cmd='a' THEN
                  NEXT FIELD cay01
               ELSE
                  RETURN
               END IF
            END IF
            IF g_caya.cay02 <0 OR g_caya.cay02 > 12 THEN
               CALL cl_err_msg("","lib-232",1 || "|" || 12,0)
               LET g_caya.cay02=g_caya_t.cay02
               DISPLAY BY NAME g_caya.cay02
               NEXT FIELD cay02
            END IF
            LET g_caya_t.cay02=g_caya.cay02
         ELSE
            CALL cl_err(g_caya.cay02,'mfg5103',0)
            NEXT FIELD cay02
         END IF

      AFTER FIELD cay04    #成本中心
         #No.MOD-B80342 --Begin
         IF cl_null(g_caya.cay04) THEN
            IF g_ccz.ccz06 != '2' THEN
                 LET g_caya.cay04 = ' '
            ELSE 
                 CALL cl_err('','anm-103',0)
                 NEXT FIELD cay04
            END IF
         END IF
         #No.MOD-B80342 --End
         IF NOT cl_null(g_caya.cay04) THEN
            IF g_aaz.aaz90 = 'Y' THEN    #TQC-B90005 add
               IF NOT s_costcenter_chk(g_caya.cay04) THEN
                  LET g_caya.cay04=g_caya_t.cay04
                  DISPLAY BY NAME g_caya.cay04
                  NEXT FIELD cay04
                  DISPLAY NULL TO gem02
               END IF                    #TQC-B90005 add
            ELSE
               DISPLAY s_costcenter_desc(g_caya.cay04) TO gem02
            END IF
            IF p_cmd = 'a' OR p_cmd = 'u' AND   (g_caya.cay00 <> g_caya_o.cay00 OR
               g_caya.cay11 <> g_caya_o.cay11 OR g_caya.cay01 <> g_caya_o.cay01 OR
               g_caya.cay02 <> g_caya_o.cay02 <> g_caya.cay04 <> g_caya_o.cay04) THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM cay_file
                WHERE cay00 = g_caya.cay00
                  AND cay01 = g_caya.cay01
                  AND cay02 = g_caya.cay02
                  AND cay04 = g_caya.cay04
                  AND cay11 = g_caya.cay11
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD cay00
               END IF
            END IF
        #No.MOD-B80342  --Mark Begin
        # ELSE
        #    DISPLAY ' ' TO FORMONLY.gem02
        #    CALL cl_err(g_caya.cay04,'mfg5103',0)
        #    NEXT FIELD cay04
        #No.MOD-B80342  --Mark End
         END IF

      AFTER FIELD cay11    #帐套
         IF NOT cl_null(g_caya.cay11) THEN
            CALL i003_cay11(p_cmd,g_caya.cay11)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_caya.cay11,g_errno,0)
               LET g_caya.cay11=g_caya_t.cay11
               DISPLAY BY NAME g_caya.cay11
               NEXT FIELD cay11
            END IF
         ELSE
            CALL cl_err(g_caya.cay11,'mfg5103',0)
            NEXT FIELD cay11
         END IF

      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         #No.MOD-B80342 --Begin
         IF cl_null(g_caya.cay04) THEN
            IF g_ccz.ccz06 != '2' THEN
                 LET g_caya.cay04 = ' '
            ELSE
                 CALL cl_err('','anm-103',0)
                 NEXT FIELD cay04
            END IF
         END IF
         #No.MOD-B80342 --End

      ON ACTION controlp
         CASE
            WHEN INFIELD(cay11)   #帐套
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING g_caya.cay11
                 DISPLAY BY NAME g_caya.cay11
                 NEXT FIELD cay11
            WHEN INFIELD(cay04)    #成本中心
                 CALL cl_init_qry_var()
#                LET g_qryparam.form     ="q_gem4"
                 LET g_qryparam.form     ="q_gem"   #No.MOD-B50167
                 LET g_qryparam.default1 = g_caya.cay04
                 CALL cl_create_qry() RETURNING g_caya.cay04
                 DISPLAY BY NAME g_caya.cay04
                 NEXT FIELD cay04
            OTHERWISE EXIT CASE
         END CASE

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON ACTION CONTROLR
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

FUNCTION i003_cay11(p_cmd,p_cay11)
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE p_cay11         LIKE cay_file.cay11
   DEFINE l_aaaacti       LIKE aaa_file.aaaacti

   LET g_errno = ' '

   SELECT aaaacti INTO l_aaaacti
     FROM aaa_file
    WHERE aaa01 = p_cay11

   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-095'
        WHEN l_aaaacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE

END FUNCTION

FUNCTION i003_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cay00,cay01,cay02,cay04,cay11",TRUE)
   END IF

END FUNCTION

FUNCTION i003_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cay00,cay01,cay02,cay04,cay11",FALSE)
   END IF

END FUNCTION

FUNCTION i003_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL i003_cs()                    #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i003_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN             #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cay01 TO NULL
   ELSE
      OPEN i003_count
      FETCH i003_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i003_fetch('F')            #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

#處理資料的讀取
FUNCTION i003_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1                  #處理方式

   CASE p_flag
        WHEN 'N' FETCH NEXT     i003_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay04,g_caya.caylegal   #TQC-B60253   Add
        WHEN 'P' FETCH PREVIOUS i003_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay04,g_caya.caylegal   #TQC-B60253   Add
        WHEN 'F' FETCH FIRST    i003_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay04,g_caya.caylegal   #TQC-B60253   Add
        WHEN 'L' FETCH LAST     i003_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay04,g_caya.caylegal   #TQC-B60253   Add
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
             FETCH ABSOLUTE g_jump i003_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay04
             LET mi_no_ask = FALSE
   END CASE

   LET g_caya.cay00 = g_cay00
   LET g_caya.cay01 = g_cay01
   LET g_caya.cay02 = g_cay02
   LET g_caya.cay04 = g_cay04
   LET g_caya.cay11 = g_cay11

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cay01,SQLCA.sqlcode,0)
      INITIALIZE g_cay00 TO NULL  
      INITIALIZE g_cay01 TO NULL  
      INITIALIZE g_cay02 TO NULL  
      INITIALIZE g_cay04 TO NULL  
      INITIALIZE g_cay11 TO NULL
   ELSE
      SELECT UNIQUE cay12 INTO g_cay12 FROM cay_file
       WHERE cay00 = g_cay00
         AND cay01 = g_cay01
         AND cay02 = g_cay02
         AND cay04 = g_cay04
         AND cay11 = g_cay11
      LET g_caya.cay12 = g_cay12
      CALL i003_show()
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
FUNCTION i003_show()
   DEFINE l_gem02     LIKE gem_file.gem02
   DISPLAY BY NAME g_caya.cay00,g_caya.cay01,g_caya.cay02,
                   g_caya.cay04,g_caya.cay11,g_caya.cay12

   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_caya.cay04
   DISPLAY l_gem02 TO FORMONLY.gem02

   CALL i003_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION

#單身
FUNCTION i003_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,                #檢查重複用
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
          p_cmd           LIKE type_file.chr1,                #處理狀態
          l_allow_insert  LIKE type_file.num5,                #可新增否
          l_allow_delete  LIKE type_file.num5                 #可刪除否
   DEFINE l_aag05         LIKE aag_file.aag05

   LET g_action_choice = ''       #TQC-B60190
   IF g_cay00 IS NULL OR g_cay01 IS NULL OR g_cay02 IS NULL OR 
      g_cay11 IS NULL OR g_cay04 IS NULL THEN
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET g_action_choice = ""

   LET g_forupd_sql = "SELECT cay06,'',cay03,'',cay08,cay05,cayacti",
                      "  FROM cay_file ",
                      "  WHERE cay00=?",
                      "    AND cay01=?",
                      "    AND cay02=?",
                      "    AND cay04=?",
                      "    AND cay11=?",
                      "    AND cay03=?",
                      "    AND cay06=?",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_cay WITHOUT DEFAULTS FROM s_cay.*
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
            LET g_cay_t.* = g_cay[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i003_bcl USING g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay04,
                                g_caya.cay11,g_cay_t.cay03,g_cay_t.cay06
            IF STATUS THEN
               CALL cl_err("OPEN i003_bcl:", STATUS, 1)
               CLOSE i003_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i003_bcl INTO g_cay[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_cay_t.cay06,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL i003_cay03(g_cay[l_ac].cay03) RETURNING g_cay[l_ac].gem02_2
            CALL i003_cay06(g_cay[l_ac].cay06,g_caya.cay11) RETURNING g_cay[l_ac].aag02
            CALL i003_set_entry_b(p_cmd) 
            CALL i003_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_cay[l_ac].* TO NULL      #900423
         LET g_cay[l_ac].cay05 = 0
         LET g_cay[l_ac].cayacti = 'Y'
         LET g_cay[l_ac].cay03 = g_cay04
         CALL cl_show_fld_cont()
         LET g_cay_t.* = g_cay[l_ac].*         #新輸入資料
         CALL i003_set_entry_b(p_cmd) 
         CALL i003_set_no_entry_b(p_cmd)
         NEXT FIELD cay06

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO cay_file(cay00,cay01,cay02,cay03,
                              cay04,cay05,cay06,cay08,
                              cay09,cay10,             #No.MOD-9C0307
                              cayacti,cayuser,caygrup,caymodu,
                              caydate,cayoriu,cayorig,cay11,cay12,caylegal)  #FUN-A50075 add legal
         VALUES(g_caya.cay00,g_caya.cay01,g_caya.cay02,g_cay[l_ac].cay03,
                g_caya.cay04,g_cay[l_ac].cay05,g_cay[l_ac].cay06,
                g_cay[l_ac].cay08,'1',' ',g_cay[l_ac].cayacti,   #No.MOD-9C0307
                g_user,g_grup,'',g_today,g_user,g_grup,g_caya.cay11,
                g_caya.cay12,g_caya.caylegal)   #FUN-A50075 add legal
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","cay_file",g_cay[l_ac].cay06,g_cay[l_ac].cay03,SQLCA.sqlcode,"","",1)
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      BEFORE FIELD cay06
         CALL i003_set_entry_b(p_cmd) 

      AFTER FIELD cay06    #科目編號
         IF NOT cl_null(g_cay[l_ac].cay06) THEN
            CALL i003_cay06(g_cay[l_ac].cay06,g_caya.cay11) RETURNING g_cay[l_ac].aag02
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cay[l_ac].cay06,g_errno,0)
#FUN-B10052 --begin--
#                LET g_cay[l_ac].cay06 = g_cay_t.cay06
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag07"
                 LET g_qryparam.arg1 = g_caya.cay11
                 LET g_qryparam.construct = "N"
                 LET g_qryparam.where = " aag01 LIKE '",g_cay[l_ac].cay06 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_cay[l_ac].cay06
                 DISPLAY BY NAME g_cay[l_ac].cay06
#FUN-B10052 --end--
               NEXT FIELD cay06
            END IF
            IF g_cay[l_ac].cay06 IS NOT NULL AND g_cay[l_ac].cay03 IS NOT NULL THEN
               IF p_cmd = 'a' OR p_cmd = 'u' AND (g_cay[l_ac].cay06 <> g_cay_t.cay06
                                             OR   g_cay[l_ac].cay03 <> g_cay_t.cay03) THEN
                  SELECT COUNT(*) INTO g_cnt
                    FROM cay_file
                   WHERE cay00 = g_caya.cay00
                     AND cay01 = g_caya.cay01
                     AND cay02 = g_caya.cay02
                     AND cay04 = g_caya.cay04
                     AND cay11 = g_caya.cay11
                     AND cay03 = g_cay[l_ac].cay03
                     AND cay06 = g_cay[l_ac].cay06
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_cay[l_ac].cay06 = g_cay_t.cay06
                     NEXT FIELD cay06
                  END IF
               END IF
            END IF
#           IF NOT i003_apportion(p_cmd) THEN NEXT FIELD cay06 END IF  #No.FUN-9C0112
         ELSE
            LET g_cay[l_ac].aag02 = NULL
#           CALL cl_err(g_cay[l_ac].cay06,'mfg5103',0)
#           NEXT FIELD cay06
         END IF
         CALL i003_set_no_entry_b(p_cmd)

      AFTER FIELD cay03    #部门
         IF NOT cl_null(g_cay[l_ac].cay03) THEN
            CALL i003_cay03(g_cay[l_ac].cay03) RETURNING g_cay[l_ac].gem02_2
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cay[l_ac].cay03,g_errno,0)
               LET g_cay[l_ac].cay03 = g_cay_t.cay03
               LET g_errno = ' '
               NEXT FIELD cay03
            END IF
            #No.FUN-B40004  --Begin
            LET l_aag05=''
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01 = g_cay[l_ac].cay06
               AND aag00 = g_caya.cay11
            IF l_aag05 = 'Y' THEN
               #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
               IF g_aaz.aaz90 !='Y' THEN
                  CALL s_chkdept(g_aaz.aaz72,g_cay[l_ac].cay06,g_cay[l_ac].cay03,g_caya.cay11)
                       RETURNING g_errno
               END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cay[l_ac].cay03,g_errno,0)
               LET g_cay[l_ac].cay03 = g_cay_t.cay03
               LET g_errno = ' '
               NEXT FIELD cay03
            END IF
            #No.FUN-B40004  --End
            IF g_cay[l_ac].cay06 IS NOT NULL AND g_cay[l_ac].cay03 IS NOT NULL THEN
               IF p_cmd = 'a' OR p_cmd = 'u' AND (g_cay[l_ac].cay06 <> g_cay_t.cay06
                                             OR   g_cay[l_ac].cay03 <> g_cay_t.cay03) THEN
                  SELECT COUNT(*) INTO g_cnt
                    FROM cay_file
                   WHERE cay00 = g_caya.cay00
                     AND cay01 = g_caya.cay01
                     AND cay02 = g_caya.cay02
                     AND cay04 = g_caya.cay04
                     AND cay11 = g_caya.cay11
                     AND cay03 = g_cay[l_ac].cay03
                     AND cay06 = g_cay[l_ac].cay06
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_cay[l_ac].cay06 = g_cay_t.cay06
                     NEXT FIELD cay06
                  END IF
               END IF
            END IF
#           IF NOT i003_apportion(p_cmd) THEN NEXT FIELD cay03 END IF  #No.FUN-9C0112
         ELSE
            LET g_cay[l_ac].gem02_2 = NULL
#           CALL cl_err(g_cay[l_ac].cay03,'mfg5103',0)
#           NEXT FIELD cay03
         END IF

      AFTER FIELD cay05
         IF NOT cl_null(g_cay[l_ac].cay05) THEN
            #No.FUN-9C0112  --Begin
            #IF g_cay[l_ac].cay05 < 0 OR g_cay[l_ac].cay05 > 100 THEN
            #   CALL cl_err(g_cay[l_ac].cay05,"mfg0091",0)
            #   NEXT FIELD cay05
            #END IF
            #IF NOT i003_apportion(p_cmd) THEN NEXT FIELD cay05 END IF
            IF g_cay[l_ac].cay05 < 0 THEN
               CALL cl_err(g_cay[l_ac].cay05,"aec-020",0)
               NEXT FIELD cay05
            END IF
            #No.FUN-9C0112  --End  
         END IF

       BEFORE FIELD cay05
          IF g_cay[l_ac].cay08 = 'A' AND p_cmd = 'a' THEN
             LET g_cay[l_ac].cay05 = 100
          END IF 

      AFTER FIELD cayacti
         IF NOT cl_null(g_cay[l_ac].cayacti) THEN
#           IF NOT i003_apportion(p_cmd) THEN NEXT FIELD cayacti END IF  #No.FUN-9C0112
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_cay_t.cay06 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM cay_file
             WHERE cay00 = g_caya.cay00
               AND cay01 = g_caya.cay01
               AND cay02 = g_caya.cay02
               AND cay04 = g_caya.cay04
               AND cay11 = g_caya.cay11
               AND cay03 = g_cay_t.cay03
               AND cay06 = g_cay_t.cay06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","cay_file",g_caya.cay01,g_caya.cay02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_cay[l_ac].* = g_cay_t.*
            CLOSE i003_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cay[l_ac].cay05,-263,1)
            LET g_cay[l_ac].* = g_cay_t.*
         ELSE
            UPDATE cay_file SET cay03  =g_cay[l_ac].cay03,
                                cay05  =g_cay[l_ac].cay05,
                                cay06  =g_cay[l_ac].cay06,
                                cay08  =g_cay[l_ac].cay08,
                                cayacti=g_cay[l_ac].cayacti,
                                caymodu=g_user,
                                caydate=g_today
                          WHERE cay00  =g_caya.cay00
                            AND cay01  =g_caya.cay01
                            AND cay02  =g_caya.cay02
                            AND cay04  =g_caya.cay04
                            AND cay11  =g_caya.cay11
                            AND cay03  =g_cay_t.cay03
                            AND cay06  =g_cay_t.cay06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","cay_file",g_caya.cay01,g_cay_t.cay06,SQLCA.sqlcode,"","",1)
               LET g_cay[l_ac].* = g_cay_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac           #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_cay[l_ac].* = g_cay_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_cay.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE i003_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac           #FUN-D40030 add
         CLOSE i003_bcl
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
            WHEN INFIELD(cay03)         #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem"
                 CALL cl_create_qry() RETURNING g_cay[l_ac].cay03
                 NEXT FIELD cay03
            WHEN INFIELD(cay06)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag07"
                 LET g_qryparam.arg1 = g_caya.cay11
                 CALL cl_create_qry() RETURNING g_cay[l_ac].cay06
                 NEXT FIELD cay06
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

   CLOSE i003_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i003_cay06(p_cay06,p_bookno)
   DEFINE p_cay06         LIKE cay_file.cay06
   DEFINE p_bookno        LIKE aag_file.aag00
   DEFINE l_aag02         LIKE aag_file.aag02
   DEFINE l_aag03         LIKE aag_file.aag03
   DEFINE l_aag07         LIKE aag_file.aag07
   DEFINE l_aagacti       LIKE aag_file.aagacti

   LET g_errno = ' '

   SELECT aag02,aag03,aag07,aagacti
     INTO l_aag02,l_aag03,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag01 = p_cay06
      AND aag00 = p_bookno
      AND aagacti = 'Y'

   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
        WHEN l_aagacti = 'N'     LET g_errno = '9028'
        WHEN l_aag07   = '1'     LET g_errno = 'agl-015'
        WHEN l_aag03  != '2'     LET g_errno = 'agl-201'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE

   IF NOT cl_null(g_errno) THEN LET l_aag02 = ' ' END IF
   RETURN l_aag02

END FUNCTION

FUNCTION i003_cay03(p_cay03)
   DEFINE p_cay03         LIKE cay_file.cay03 
   DEFINE l_gem02         LIKE gem_file.gem02
   DEFINE l_gemacti       LIKE gem_file.gemacti

   LET g_errno = ' '

   SELECT gem02,gemacti
     INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 = p_cay03

   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-003'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE

   IF NOT cl_null(g_errno) THEN LET l_gem02 = ' ' END IF
   RETURN l_gem02
END FUNCTION

#No.FUN-9C0112  --Begin
#FUNCTION i003_apportion(p_cmd)
#   DEFINE p_cmd           LIKE type_file.chr1
#   DEFINE l_cay05         LIKE cay_file.cay05
#   DEFINE l_str           STRING
#
#   IF g_caya.cay11 IS NULL OR g_caya.cay01 IS NULL OR g_caya.cay02 IS NULL THEN
#      RETURN TRUE
#   END IF
#   IF g_cay[l_ac].cay05 = 'N' THEN
#      RETURN TRUE
#   END IF
#
#   IF g_cay[l_ac].cay06 IS NOT NULL AND g_cay[l_ac].cay03 IS NOT NULL AND 
#      g_cay[l_ac].cayacti IS NOT NULL THEN
#      IF p_cmd = 'a' OR p_cmd = 'u' AND (g_cay[l_ac].cay06 <> g_cay_t.cay06
#                                    OR   g_cay[l_ac].cay03 <> g_cay_t.cay03
#                                    OR   g_cay[l_ac].cay05 <> g_cay_t.cay05
#                                    OR   g_cay[l_ac].cayacti <> g_cay_t.cayacti) THEN
#      ELSE
#         RETURN TRUE
#      END IF
#   ELSE
#      RETURN TRUE
#   END IF
#
#   SELECT SUM(cay05) INTO l_cay05 FROM cay_file
#    WHERE cay11 = g_caya.cay11          #帐套
#      AND cay01 = g_caya.cay01          #年
#      AND cay02 = g_caya.cay02          #月
#      AND cay03 = g_cay[l_ac].cay03     #部门
#      AND cay06 = g_cay[l_ac].cay06     #科目
#      AND cayacti = 'Y'                 #有效
#      AND (cay00 <> g_caya.cay00        #类型
#       OR  cay04 <> g_caya.cay04 )      #成本中心
#   IF cl_null(l_cay05) THEN LET l_cay05 = 0  END IF
#
#   IF l_cay05 + g_cay[l_ac].cay05 > 100 THEN
#      LET l_str = g_bookno CLIPPED,g_caya.cay11 CLIPPED,' ',
#                  g_dept CLIPPED,g_cay[l_ac].cay03 CLIPPED,' ',
#                  g_account CLIPPED,g_cay[l_ac].cay06 CLIPPED,' ',
#                  g_accumulate CLIPPED,l_cay05 Using "<<<.<<",' ',
#                  g_current CLIPPED,g_cay[l_ac].cay05 Using "<<<.<<"
#      CALL cl_err(l_str,'axc-077',1)    #当前部门+当前科目的累计分摊比率超过100了,请检查!
#      RETURN FALSE
#   END IF
#   RETURN TRUE
#
#END FUNCTION
#
##单头key值修改,复制,批次产生的资料,要额外检查单身的cay05是否还满足 部门+科目+帐套+年+月 <=100的条件,
##若不满足,则对于违反此条例的行的cay05置为0
#FUNCTION i003_chk_u()
#   DEFINE l_cay00      LIKE cay_file.cay00
#   DEFINE l_cay01      LIKE cay_file.cay01
#   DEFINE l_cay02      LIKE cay_file.cay02
#   DEFINE l_cay03      LIKE cay_file.cay03
#   DEFINE l_cay04      LIKE cay_file.cay04
#   DEFINE l_cay06      LIKE cay_file.cay06
#   DEFINE l_cay11      LIKE cay_file.cay11
#
#   DECLARE i003_chk_cs1 CURSOR FOR
#    SELECT cay00,cay01,cay02,cay03,cay04,cay06,cay11 FROM cay_file
#     WHERE cay00 = g_caya.cay00
#       AND cay01 = g_caya.cay01
#       AND cay02 = g_caya.cay02
#       AND cay04 = g_caya.cay04
#       AND cay11 = g_caya.cay11
#   FOREACH i003_chk_cs1 INTO l_cay00,l_cay01,l_cay02,l_cay03,l_cay04,l_cay06,l_cay11 
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach i003_chk_cs1',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#         EXIT FOREACH
#      END IF
#      CALL i003_chk_cay05(l_cay00,l_cay01,l_cay02,l_cay03,l_cay04,l_cay06,l_cay11)
#   END FOREACH
#
#END FUNCTION
#
#FUNCTION i003_chk_cay05(p_cay00,p_cay01,p_cay02,p_cay03,p_cay04,p_cay06,p_cay11)
#   DEFINE p_cmd        LIKE type_file.chr1
#   DEFINE p_cay00      LIKE cay_file.cay00
#   DEFINE p_cay01      LIKE cay_file.cay01
#   DEFINE p_cay02      LIKE cay_file.cay02
#   DEFINE p_cay03      LIKE cay_file.cay03
#   DEFINE p_cay04      LIKE cay_file.cay04
#   DEFINE p_cay06      LIKE cay_file.cay06
#   DEFINE p_cay11      LIKE cay_file.cay11
#   DEFINE l_cay05      LIKE cay_file.cay05
#   DEFINE l_current    LIKE cay_file.cay05
#   DEFINE l_str        STRING
#
#   #总共累计
#   SELECT SUM(cay05) INTO l_cay05 FROM cay_file
#    WHERE cay11 = p_cay11        #帐套
#      AND cay01 = p_cay01        #年
#      AND cay02 = p_cay02        #月
#      AND cay03 = p_cay03        #部门
#      AND cay06 = p_cay06        #科目
#      AND cayacti = 'Y'          #有效
#   
#   #此次比率
#   SELECT SUM(cay05) INTO l_current FROM cay_file
#    WHERE cay00 = p_cay00        #类型
#      AND cay01 = p_cay01        #年
#      AND cay02 = p_cay02        #月
#      AND cay03 = p_cay03        #部门
#      AND cay04 = p_cay04        #成本中心
#      AND cay06 = p_cay06        #科目
#      AND cay11 = p_cay11        #帐套
#      AND cayacti = 'Y'          #有效
# 
#   IF cl_null(l_cay05)   THEN LET l_cay05   = 0  END IF
#   IF cl_null(l_current) THEN LET l_current = 0  END IF
#   IF l_cay05 > 100 THEN
#      UPDATE cay_file SET cay05 = 0
#       WHERE cay00 = p_cay00
#         AND cay01 = p_cay01     #年
#         AND cay02 = p_cay02     #月
#         AND cay03 = p_cay03     #部门
#         AND cay04 = p_cay04     #成本中心
#         AND cay06 = p_cay06     #科目
#         AND cay11 = p_cay11     #帐套
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3('upd','cay_file',p_cay11,p_cay01,SQLCA.sqlcode,'','',0)
#         LET g_success = 'N'
#         RETURN
#      END IF
#      LET l_str = g_bookno CLIPPED,p_cay11 CLIPPED,' ',
#                  g_dept CLIPPED,p_cay03 CLIPPED,' ',
#                  g_account CLIPPED,p_cay06 CLIPPED,' ',
#                  g_accumulate CLIPPED,(l_cay05-l_current) Using "<<<.<<",' ',
#                  g_current CLIPPED,l_current Using "<<<.<<"  #modify
#      CALL cl_err(l_str,'axc-077',1)    #当前部门+当前科目的累计分摊比率超过100了,请检查!
#   END IF
#
#END FUNCTION
#No.FUN-9C0112  --End  

#No.MOD-9C0292  --Begin
#FUNCTION i003_t1()
#   DEFINE p_row,p_col  LIKE type_file.num5
#   DEFINE l_sql        STRING
#   DEFINE tm           RECORD
#                        cay11 LIKE cay_file.cay11,
#                        yy    LIKE cay_file.cay01,
#                        mm    LIKE cay_file.cay02
#                       END RECORD
#   DEFINE l_cay        RECORD LIKE cay_file.*
#   DEFINE l_where      STRING
#   DEFINE l_where1     STRING
#   DEFINE l_cay00      LIKE cay_file.cay00
#   DEFINE l_cay01      LIKE cay_file.cay01
#   DEFINE l_cay02      LIKE cay_file.cay02
#   DEFINE l_cay03      LIKE cay_file.cay03
#   DEFINE l_cay06      LIKE cay_file.cay06
#   DEFINE l_cay09      LIKE cay_file.cay09
#   DEFINE l_cay10      LIKE cay_file.cay10
#   DEFINE l_cay11      LIKE cay_file.cay11
#
#   LET p_row = 6 LET p_col = 6
#
#   OPEN WINDOW i003_w_t AT p_row,p_col WITH FORM "axc/42f/axci003_t"
#        ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#   CALL cl_ui_locale("axci003_t")
#
#   INITIALIZE tm.* TO NULL
#   INPUT BY NAME tm.cay11,tm.yy,tm.mm WITHOUT DEFAULTS
#
#      AFTER FIELD cay11
#         IF NOT cl_null(tm.cay11) THEN
#            CALL i003_cay11('a',tm.cay11)
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err(tm.cay11,g_errno,0)
#               LET tm.cay11 = ''
#               DISPLAY BY NAME tm.cay11
#               NEXT FIELD cay11
#            END IF
#         ELSE
#            CALL cl_err(tm.cay11,'mfg5103',0)
#            NEXT FIELD cay11
#         END IF
#
#      AFTER FIELD yy
#         IF cl_null(tm.yy) THEN
#            CALL cl_err(tm.yy,'mfg0037',0)
#            NEXT FIELD yy
#         END IF
#
#      AFTER FIELD mm
#         IF cl_null(tm.mm) THEN
#            CALL cl_err(tm.mm,'mfg0037',0)
#            NEXT FIELD mm
#         ELSE
#            LET l_sql = "SELECT COUNT(*) FROM cay_file",
#                        " WHERE cay01=",tm.yy,
#                        "   AND cay02=",tm.mm,
#                        "   AND cay11='",tm.cay11,"'"
#            #           "   AND cay09 != '1'"
#            PREPARE i003_t1_p1 FROM l_sql
#            DECLARE i003_t1_c1 CURSOR FOR i003_t1_p1
#            OPEN i003_t1_c1
#            FETCH i003_t1_c1 INTO g_cnt
#            IF g_cnt = 0 THEN
#               CALL cl_err('','mfg9089',1)
#               NEXT FIELD cay11
#            END IF
#         END IF
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION help
#         CALL cl_show_help()
#
#      ON ACTION controlg
#         CALL cl_cmdask()
#
#      ON ACTION controlp
#         CASE
#            WHEN INFIELD(cay11)   #分攤來源科目
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form  = "q_aaa"
#                 CALL cl_create_qry() RETURNING tm.cay11
#                 DISPLAY BY NAME tm.cay11
#                 NEXT FIELD cay11
#            OTHERWISE EXIT CASE
#         END CASE
#   END INPUT
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      CLOSE WINDOW i003_w_t
#      RETURN
#   END IF
#   CLOSE WINDOW i003_w_t
#   IF NOT cl_sure(0,0) THEN RETURN END IF
#
#   LET l_sql = "SELECT DISTINCT cay00,cay01,cay02,cay03,cay06,cay09,cay10,cay11 FROM cay_file",
#               " WHERE cay01=",tm.yy,
#               "   AND cay02=",tm.mm,
#               "   AND cay11='",tm.cay11,"'",
#               "   AND cay09 != '1'"
#
#   PREPARE i003_t1 FROM l_sql
#   DECLARE i003_c1 CURSOR FOR i003_t1
#   FOREACH i003_c1 INTO l_cay00,l_cay01,l_cay02,l_cay03,l_cay06,l_cay09,l_cay10,l_cay11
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      CALL i003_t(l_cay00,l_cay01,l_cay02,l_cay03,l_cay06,l_cay09,l_cay10,l_cay11)
#   END FOREACH
#END FUNCTION
#
#FUNCTION i003_t(p_cay00,p_cay01,p_cay02,p_cay03,p_cay06,p_cay09,p_cay10,p_cay11)
#   DEFINE l_sql        STRING,
#          l_dbs        LIKE azp_file.azp03,
#          l_sum        LIKE aao_file.aao05,
#          l_aao01      LIKE aao_file.aao01,
#          l_aao02      LIKE aao_file.aao02,
#          l_aao05      LIKE aao_file.aao05,
#          l_aao06      LIKE aao_file.aao06,
#          l_aag06      LIKE aag_file.aag06,
#          l_tot        LIKE aao_file.aao05,
#          l_cay05      LIKE cay_file.cay05,
#          l_bdate      LIKE cam_file.cam01,
#          l_edate      LIKE cam_file.cam01,
#          l_cam02      LIKE cam_file.cam02,
#          l_cam07      LIKE cam_file.cam07
#   DEFINE l_plant      LIKE type_file.chr10
#   DEFINE p_cay00      LIKE cay_file.cay00
#   DEFINE p_cay01      LIKE cay_file.cay01
#   DEFINE p_cay02      LIKE cay_file.cay02
#   DEFINE p_cay03      LIKE cay_file.cay03
#   DEFINE p_cay06      LIKE cay_file.cay06
#   DEFINE p_cay09      LIKE cay_file.cay09
#   DEFINE p_cay10      LIKE cay_file.cay10
#   DEFINE p_cay11      LIKE cay_file.cay11
#
#   CASE P_cay09
#      WHEN '2'   #科目餘額
#        #當分攤比例來源(cay09) = '2' (科目餘額)時，
#        #根據來源科目編號的科目餘額該成本中心所佔比例更新分攤比例
#         #取參數設定ccz11,ccz12總帳所在工廠編號,帳別
#         LET l_plant = g_ccz.ccz11
#         LET g_plant_new = g_ccz.ccz11
#         CALL s_getdbs()
#         LET l_dbs = g_dbs_new CLIPPED
#
#         #先算科目餘額合計
#         LET l_sql = "SELECT SUM(aao05-aao06)",
#                     "  FROM ",l_dbs CLIPPED,"aao_file, ",
#                               l_dbs CLIPPED,"aag_file ",
#                     " WHERE aao00 ='",p_cay11    ,"'",
#                     "   AND aao01 ='",p_cay10,"'",
#                     "   AND aao02 IN (SELECT cay04 FROM cay_file",
#                     "                  WHERE cay00='",p_cay00,"'",
#                     "                    AND cay01='",p_cay01,"'",
#                     "                    AND cay02='",p_cay02,"'",
#                     "                    AND cay03='",p_cay03,"'",
#                     "                    AND cay06='",p_cay06,"'",
#                     "                    AND cay11='",p_cay11,"'",
#                     "                    AND cayacti='Y')",
#                     "   AND aao03 ='",p_cay01,"'",
#                     "   AND aao04 ='",p_cay02,"'",
#                     "   AND aag01 =aao01",
#                     "   AND aag00 =aao00",
#                     "   AND aag00 = '",p_cay11  ,"'",
#                     "   AND aag07!='1'"    #非統制帳戶
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#         PREPARE i003_t_p1 FROM l_sql
#         DECLARE i003_t_c1 CURSOR FOR i003_t_p1
#         OPEN i003_t_c1
#         FETCH i003_t_c1 INTO l_sum
#         IF cl_null(l_sum) THEN LET l_sum = 0 END IF
#
#         LET l_sql = "SELECT aao01,aao02,aao05,aao06,aag06",
#                     "  FROM ",l_dbs CLIPPED,"aao_file, ",
#                               l_dbs CLIPPED,"aag_file ",
#                     " WHERE aao00 ='",p_cay11    ,"'",
#                     "   AND aao01 ='",p_cay10,"'",
#                     "   AND aao02 IN (SELECT cay04 FROM cay_file",
#                     "                  WHERE cay00='",p_cay00,"'",
#                     "                    AND cay01='",p_cay01,"'",
#                     "                    AND cay02='",p_cay02,"'",
#                     "                    AND cay03='",p_cay03,"'",
#                     "                    AND cay06='",p_cay06,"'",
#                     "                    AND cay11='",p_cay11,"'",
#                     "                    AND cayacti='Y')",
#                     "   AND aao03 ='",p_cay01,"'",
#                     "   AND aao04 ='",p_cay02,"'",
#                     "   AND aag01 =aao01",
#                     "   AND aag00 =aao00",
#                     "   AND aag00 = '",p_cay11  ,"'",
#                     "   AND aag07!='1'"    #非統制帳戶
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#         PREPARE i003_t_p2 FROM l_sql
#         DECLARE i003_t_c2 CURSOR FOR i003_t_p2
#
#         MESSAGE "WORKING !"
#         FOREACH i003_t_c2 INTO l_aao01,l_aao02,l_aao05,l_aao06,l_aag06
#            IF cl_null(l_aao05) THEN LET l_aao05 = 0 END IF
#            IF cl_null(l_aao06) THEN LET l_aao06 = 0 END IF
#            IF l_aag06='1' THEN           #正常餘額為借餘時
#               LET l_tot=l_aao05-l_aao06
#            ELSE
#               LET l_tot=l_aao06-l_aao05
#            END IF
#            LET l_cay05 = l_tot / l_sum
#            IF cl_null(l_cay05) THEN LET l_cay05 = 0 END IF
#
#            UPDATE cay_file SET cay05  =l_cay05,
#                                caymodu=g_user,
#                                caydate=g_today
#                          WHERE cay00  =p_cay00
#                            AND cay01  =p_cay01
#                            AND cay02  =p_cay02
#                            AND cay03  =p_cay03
#                            AND cay06  =p_cay06
#                            AND cay11  =p_cay11
#                            AND cay04  =l_aao02
#                            AND cayacti='Y'
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1)
#               LET g_cay[l_ac].* = g_cay_t.*
#            END IF
#            CALL i003_chk_cay05(p_cay00,p_cay01,p_cay02,p_cay03,l_aao02,p_cay06,p_cay11)
#         END FOREACH
#      WHEN '3'   #約當產量
#        #當分攤比例來源(cay09) = '3' (約當產量)時，
#        #根據約當產量該成本中心所佔比例更新分攤比例
#
#         LET l_bdate = MDY(p_cay02,1,p_cay01)
#         LET l_edate = MDY(p_cay02+1,1,p_cay01)-1
#         #先算約當產量合計
#         LET l_sql = "SELECT SUM(cam07)",
#                     "  FROM cam_file",
#                     " WHERE cam01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
#                     "   AND cam02 IN (SELECT cay04 FROM cay_file",
#                     "                  WHERE cay00='",p_cay00,"'",
#                     "                    AND cay01='",p_cay01,"'",
#                     "                    AND cay11='",p_cay11,"'",
#                     "                    AND cay02='",p_cay02,"'",
#                     "                    AND cay03='",p_cay03,"'",
#                     "                    AND cay06='",p_cay06,"'",
#                     "                    AND cayacti='Y')"
#         PREPARE i003_t_p3 FROM l_sql
#         DECLARE i003_t_c3 CURSOR FOR i003_t_p3
#         OPEN i003_t_c3
#         FETCH i003_t_c3 INTO l_sum
#         IF cl_null(l_sum) THEN LET l_sum = 0 END IF
#
#         LET l_sql = "SELECT cam02,SUM(cam07)",
#                     "  FROM cam_file",
#                     " WHERE cam01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
#                     "   AND cam02 IN (SELECT cay04 FROM cay_file",
#                     "                  WHERE cay00='",p_cay00,"'",
#                     "                    AND cay01='",p_cay01,"'",
#                     "                    AND cay11='",p_cay11,"'",
#                     "                    AND cay02='",p_cay02,"'",
#                     "                    AND cay03='",p_cay03,"'",
#                     "                    AND cay06='",p_cay06,"'",
#                     "                    AND cayacti='Y')",
#                     " GROUP BY cam02"
#         PREPARE i003_t_p4 FROM l_sql
#         DECLARE i003_t_c4 CURSOR FOR i003_t_p4
#
#         MESSAGE "WORKING !"
#         FOREACH i003_t_c4 INTO l_cam02,l_cam07
#            LET l_cay05 = l_cam07 / l_sum
#            IF cl_null(l_cay05) THEN LET l_cay05 = 0 END IF
#
#            UPDATE cay_file SET cay05  =l_cay05,
#                                caymodu=g_user,
#                                caydate=g_today
#                          WHERE cay00  =p_cay00
#                            AND cay01  =p_cay01
#                            AND cay11  =p_cay11
#                            AND cay02  =p_cay02
#                            AND cay03  =p_cay03
#                            AND cay06  =p_cay06
#                            AND cay04  =l_cam02
#                            AND cayacti='Y'
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1)
#               LET g_cay[l_ac].* = g_cay_t.*
#            END IF
#            CALL i003_chk_cay05(p_cay00,p_cay01,p_cay02,p_cay03,l_cam02,p_cay06,p_cay11)
#         END FOREACH
#   END CASE
#   CALL i003_b_fill(" 1=1")                 #單身
#   MESSAGE ""
#END FUNCTION
#No.MOD-9C0292  --End  

#start FUN-670065 add
FUNCTION i003_g()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_sql,l_wc,l_wc1          STRING
   DEFINE d_cnt,a_cnt    LIKE type_file.num5
   DEFINE i,j            LIKE type_file.num5
   DEFINE tm             RECORD
                          cay00 LIKE cay_file.cay00,
                          cay11 LIKE cay_file.cay11,
                          yy    LIKE cay_file.cay01,
                          mm    LIKE cay_file.cay02,
                          cay04 LIKE cay_file.cay04,
                          cay03 LIKE cay_file.cay03,
                          cay06 LIKE cay_file.cay06,
                          cay08 LIKE cay_file.cay08,
                          cay12 LIKE cay_file.cay12
                         END RECORD
   DEFINE l_cay          RECORD LIKE cay_file.*
   DEFINE g_change_lang  LIKE type_file.chr1
   DEFINE l_aag05        LIKE aag_file.aag05

   LET p_row = 6 LET p_col = 6

   OPEN WINDOW i003_w_g AT p_row,p_col WITH FORM "axc/42f/axci003_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("axci003_g")

   INITIALIZE tm.* TO NULL
   LET tm.cay11 = g_aza.aza81
   LET tm.yy    = g_ccz.ccz01
   LET tm.mm    = g_ccz.ccz02
   DISPLAY BY NAME tm.cay11
   DISPLAY tm.yy TO FORMONLY.yy
   DISPLAY tm.mm TO FORMONLY.mm

   WHILE TRUE
      INPUT BY NAME tm.cay00,tm.cay11,tm.yy,tm.mm,tm.cay04,tm.cay08,tm.cay12 WITHOUT DEFAULTS

         AFTER FIELD cay11
            IF NOT cl_null(tm.cay11) THEN
               CALL i003_cay11('a',tm.cay11)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.cay11,g_errno,0)
                  LET tm.cay11 = ''
                  DISPLAY BY NAME tm.cay11
                  NEXT FIELD cay11
               END IF
            ELSE
               CALL cl_err(tm.cay11,'mfg5103',0)
               NEXT FIELD cay11
            END IF

         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               CALL cl_err(tm.yy,'mfg5103',0)
               NEXT FIELD yy
            END IF

         AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               CALL cl_err(tm.mm,'mfg5103',0)
               NEXT FIELD mm
            END IF

         AFTER FIELD cay04    #成本中心
            #No.MOD-BA0111 --Begin
            IF cl_null(tm.cay04) THEN
               IF g_ccz.ccz06 != '2' THEN
                 LET tm.cay04 = ' '
               ELSE
                 CALL cl_err('','anm-103',0)
                 NEXT FIELD cay04
               END IF
            END IF
            #No.MOD-BA0111 --End
            IF g_aaz.aaz90 = 'Y' THEN   #MOD-BB0117 add
               IF NOT cl_null(tm.cay04) THEN
                  IF NOT s_costcenter_chk(tm.cay04) THEN
                     NEXT FIELD cay04
                  END IF
               END IF
            END IF   #MOD-BB0117 add

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION controlp
            CASE
               WHEN INFIELD(cay11)   #分攤來源科目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_aaa"
                    CALL cl_create_qry() RETURNING tm.cay11
                    DISPLAY BY NAME tm.cay11
               WHEN INFIELD(cay04)    #成本中心
                    CALL cl_init_qry_var()
#                   LET g_qryparam.form     ="q_gem4"
                    LET g_qryparam.form     ="q_gem"   #No.MOD-B50167
                    LET g_qryparam.default1 = tm.cay04
                    CALL cl_create_qry() RETURNING tm.cay04
                    DISPLAY BY NAME tm.cay04
                    NEXT FIELD cay04
               OTHERWISE EXIT CASE
            END CASE

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i003_w_g
         RETURN
      END IF

      DIALOG ATTRIBUTES(UNBUFFERED)

         CONSTRUCT BY NAME l_wc ON gem01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(gem01)
                       CALL cl_init_qry_var()
                      #LET g_qryparam.form  = "q_gem"      #MOD-D50101 mark
                       LET g_qryparam.form  = "q_gem3"     #MOD-D50101 q_gem -> q_gem3
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO gem01
                       NEXT FIELD gem01
                   OTHERWISE EXIT CASE
               END CASE
            AFTER CONSTRUCT
         END CONSTRUCT

         CONSTRUCT BY NAME l_wc1 ON aag01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(aag01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form  = "q_aag07"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO aag01
                       NEXT FIELD aag01
                   OTHERWISE EXIT CASE
               END CASE
            AFTER CONSTRUCT
         END CONSTRUCT

         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION accept
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG

      END DIALOG

      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i003_w_g RETURN END IF

      IF NOT cl_confirm('abx-080') THEN    #是否確定執行 (Y/N) ?
         CLOSE WINDOW i003_w_c
         RETURN
      END IF

      LET l_sql="SELECT gem01 FROM gem_file ",
                " WHERE ",l_wc CLIPPED
      PREPARE i003_cay_p1 FROM l_sql
      DECLARE i003_cay_c1 CURSOR FOR i003_cay_p1
      LET l_sql="SELECT aag01 FROM aag_file ",
                " WHERE ",l_wc1 CLIPPED,
                "   AND aag07 <> '1' AND aag03 = '2' ",
                "   AND aagacti = 'Y' ",
                "   AND aag00='",tm.cay11,"'"
      PREPARE i003_cay_p2 FROM l_sql
      DECLARE i003_cay_c2 CURSOR FOR i003_cay_p2

      FOREACH i003_cay_c1 INTO tm.cay03
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_caya.cay01,SQLCA.sqlcode,0)
            RETURN
         END IF
         FOREACH i003_cay_c2 INTO tm.cay06
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_caya.cay01,SQLCA.sqlcode,0)
               RETURN
            END IF

            #先檢查是否已經有存在資料,若有則跳過
            LET g_cnt = 0
            LET l_sql = "SELECT COUNT(*) FROM cay_file ",
                        " WHERE cay00='",tm.cay00,"'",
                        "   AND cay01='",tm.yy,"'",
                        "   AND cay02='",tm.mm,"'",
                        "   AND cay11='",tm.cay11,"'",
                        "   AND cay03='",tm.cay03,"'",
                        "   AND cay06='",tm.cay06,"'",
                        "   AND cay04='",tm.cay04,"'"    #MOD-C90041
            PREPARE i003_g_p1 FROM l_sql
            DECLARE i003_g_c1 CURSOR FOR i003_g_p1
            OPEN i003_g_c1
            FETCH i003_g_c1 INTO g_cnt
            IF g_cnt > 0 THEN
               CONTINUE FOREACH
            END IF

            LET l_cay.cay00=tm.cay00
            LET l_cay.cay01=tm.yy              #年度
            LET l_cay.cay02=tm.mm              #月份
            LET l_cay.cay04=tm.cay04           #成本中心
            LET l_cay.cay06=tm.cay06           #會計科目
            LET l_aag05 = ''
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01 = l_cay.cay06
               AND aag00 = tm.cay11 
            IF l_aag05 = 'N' THEN
               LET l_cay.cay03=' '             #部門編號
            ELSE
               LET l_cay.cay03=tm.cay03        #部門編號
            END IF
            LET l_cay.cay08=tm.cay08           #部門屬性:A.直接部門
            IF l_cay.cay08 = 'A' THEN
               LET l_cay.cay05=100             #分攤比例
            ELSE
               LET l_cay.cay05=0               #分攤比例
            END IF
            LET l_cay.cay11=tm.cay11           #帐套
            LET l_cay.cay12=tm.cay12           #分摊类型
            LET l_cay.cayacti='Y'
            LET l_cay.cayuser=g_user
            LET l_cay.caygrup=g_grup
            LET l_cay.caymodu=''
            LET l_cay.caydate=g_today
            LET l_cay.cay09 = '1'              #No.MOD-9C0307
            LET l_cay.cay10 = ' '              #No.MOD-9C0307
            LET l_cay.caylegal = g_legal       #FUN-A50075

            INSERT INTO cay_file VALUES (l_cay.* )
            IF STATUS THEN
               IF STATUS = -239 THEN
                  CONTINUE FOREACH
               ELSE
                  CALL cl_err3("ins","cay_file",l_cay.cay01,l_cay.cay02,STATUS,"","ins_cay:",1)
                  CLOSE WINDOW i003_w_g
                  RETURN
               END IF
           #FUN-D60071 --------Begin----------
               ELSE
               LET g_success = 'Y'
          #FUN-D60071 --------End------------
            END IF
#           CALL i003_chk_cay05(l_cay.cay00,l_cay.cay01,l_cay.cay02,l_cay.cay03,l_cay.cay04,l_cay.cay06,l_cay.cay11)  #No.FUN-9C0112
         END FOREACH
      END FOREACH
      EXIT WHILE
   END WHILE
   MESSAGE ""
   CLOSE WINDOW i003_w_g
END FUNCTION

FUNCTION i003_copy()
   DEFINE l_sql        STRING
   DEFINE new_cay00    LIKE cay_file.cay00
   DEFINE new_cay11    LIKE cay_file.cay11
   DEFINE new_cay01    LIKE cay_file.cay01
   DEFINE new_cay02    LIKE cay_file.cay02
   DEFINE new_cay04    LIKE cay_file.cay04
   DEFINE new_cay12    LIKE cay_file.cay12
   DEFINE l_gem02      LIKE gem_file.gem02
   DEFINE l_cay        RECORD LIKE cay_file.*
   DEFINE l_i          LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF

   IF g_cay00 IS NULL OR g_cay01 IS NULL OR g_cay02 IS NULL OR 
      g_cay11 IS NULL OR g_cay04 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   DISPLAY "" AT 1,1
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   DISPLAY g_msg AT 2,1

   INITIALIZE l_gem02 TO NULL
   DISPLAY l_gem02 TO FORMONLY.gem02

   CALL i003_set_entry('a')
   WHILE TRUE
      INPUT new_cay00,new_cay11,new_cay01,new_cay02,new_cay04,new_cay12
       FROM cay00,cay11,cay01,cay02,cay04,cay12

#         AFTER FIELD cay00
#           IF cl_null(new_cay00) THEN
#              NEXT FIELD cay00
#           END IF

          AFTER FIELD cay11
            IF NOT cl_null(new_cay11) THEN
                CALL i003_cay11('a',new_cay11)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(new_cay11,g_errno,0)
                   LET new_cay11 = ''
                   DISPLAY new_cay11 TO cay11
                   NEXT FIELD cay11
                END IF
            END IF

          AFTER FIELD cay01
            IF cl_null(new_cay01) THEN
                NEXT FIELD cay01
            END IF
            IF NOT cl_null(new_cay01) THEN
               IF new_cay01 < g_ccz.ccz01 THEN
                  CALL cl_err(new_cay01,'axc-095',0)
                  LET new_cay01 = ''
                  DISPLAY new_cay01 TO cay01
                  NEXT FIELD cay01
               END IF
            END IF

          AFTER FIELD cay02
            IF NOT cl_null(new_cay02) THEN
               IF (new_cay01 = g_ccz.ccz01 AND new_cay02 < g_ccz.ccz02 ) THEN
                  CALL cl_err(new_cay02,'axc-095',0)
                  NEXT FIELD cay01
               END IF
               IF new_cay02 <0 OR new_cay02 > 12 THEN
                  CALL cl_err_msg("","lib-232",1 || "|" || 12,0)
                  LET new_cay02 = ''
                  DISPLAY new_cay02 TO cay02
                  NEXT FIELD cay02
               END IF
            END IF

         AFTER FIELD cay04    #成本中心
            #No.MOD-BA0111 --Begin
            IF cl_null(new_cay04) THEN
               IF g_ccz.ccz06 != '2' THEN
                 LET new_cay04 = ' '
               ELSE
                 CALL cl_err('','anm-103',0)
                 NEXT FIELD cay04
               END IF
            END IF
            #No.MOD-BA0111 --End
            IF g_aaz.aaz90 = 'Y' THEN   #MOD-BB0117 add
               IF NOT cl_null(new_cay04) THEN
                  IF NOT s_costcenter_chk(new_cay04) THEN
                     LET new_cay04 = ''
                     DISPLAY new_cay04 TO cay04
                     NEXT FIELD cay04
                     DISPLAY NULL TO gem02
                  ELSE
                     DISPLAY s_costcenter_desc(new_cay04) TO gem02
                  END IF
               END IF
            END IF   #MOD-BB0117 add
            SELECT COUNT(*) INTO g_cnt
              FROM cay_file
             WHERE cay00 = new_cay00
               AND cay01 = new_cay01
               AND cay02 = new_cay02
               AND cay04 = new_cay04
               AND cay11 = new_cay11
            IF g_cnt > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD cay00
            END IF

           ON ACTION CONTROLP
              CASE
               WHEN INFIELD(cay11)   #帐套
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_aaa"
                    CALL cl_create_qry() RETURNING new_cay11
                    DISPLAY new_cay11 TO cay11
                    NEXT FIELD cay11
               WHEN INFIELD(cay04)    #成本中心
                    CALL cl_init_qry_var()
#                   LET g_qryparam.form     ="q_gem4"
                    LET g_qryparam.form     ="q_gem"   #No.MOD-B50167
                    LET g_qryparam.default1 = new_cay04
                    CALL cl_create_qry() RETURNING new_cay04
                    DISPLAY new_cay04 TO cay04
                    NEXT FIELD cay04
               OTHERWISE EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121

         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121

         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG=0
         DISPLAY g_caya.cay00 TO cay00
         DISPLAY g_caya.cay11 TO cay11
         DISPLAY g_caya.cay01 TO cay01
         DISPLAY g_caya.cay02 TO cay02
         DISPLAY g_caya.cay04 TO cay04
         DISPLAY g_caya.cay12 TO cay12
         RETURN
      END IF
      #No.MOD-BA0111  --Begin
      #IF cl_null(new_cay00) OR cl_null(new_cay11) OR cl_null(new_cay01) OR cl_null(new_cay02) OR cl_null(new_cay04) THEN #MO
      #    CONTINUE WHILE
      #END IF
      IF cl_null(new_cay04) THEN
         IF g_ccz.ccz06 != '2' THEN
               LET new_cay04 = ' '
               IF cl_null(new_cay00) OR cl_null(new_cay11) OR cl_null(new_cay01) OR cl_null(new_cay02) THEN
               CONTINUE WHILE
             END IF
         END IF
      ELSE
         IF cl_null(new_cay00) OR cl_null(new_cay11) OR cl_null(new_cay01) OR cl_null(new_cay02) OR cl_null(new_cay04) THEN
             CONTINUE WHILE
         END IF
       END IF
      #No.MOD-BA0111  --End
      EXIT WHILE
   END WHILE

   BEGIN WORK
   LET g_success='Y'
   DECLARE i003_c CURSOR FOR
    SELECT * FROM cay_file
     WHERE cay00 = g_cay00
       AND cay11 = g_cay11
       AND cay01 = g_cay01
       AND cay02 = g_cay02
       AND cay04 = g_cay04
   LET l_i = 0
   FOREACH i003_c INTO l_cay.*
       LET l_i = l_i+1
       LET l_cay.cay00 = new_cay00
       LET l_cay.cay11 = new_cay11
       LET l_cay.cay01 = new_cay01
       LET l_cay.cay02 = new_cay02
       LET l_cay.cay04 = new_cay04
       LET l_cay.cay12 = new_cay12
       LET l_cay.cayacti='Y'
       LET l_cay.cayuser=g_user
       LET l_cay.caygrup=g_grup
       LET l_cay.caymodu=''
       LET l_cay.caydate=g_today
       LET l_cay.caylegal = g_legal    #FUN-A50075

       INSERT INTO cay_file VALUES(l_cay.*)
       IF STATUS THEN
           CALL cl_err3("ins","cay_file",l_cay.cay00,l_cay.cay11,STATUS,l_cay.cay01,"ins cay",1)
           LET g_success='N'
       END IF
#      CALL i003_chk_cay05(l_cay.cay00,l_cay.cay01,l_cay.cay02,l_cay.cay03,l_cay.cay04,l_cay.cay06,l_cay.cay11)  #No.FUN-9C0112
   END FOREACH
   IF g_success='Y' THEN
       COMMIT WORK
       MESSAGE l_i, ' rows copied!'
       #FUN-C80046---begin
       LET g_caya.cay00 = new_cay00
       LET g_caya.cay11 = new_cay11
       LET g_caya.cay01 = new_cay01
       LET g_caya.cay02 = new_cay02
       LET g_caya.cay04 = new_cay04
       LET g_caya.cay12 = new_cay12
       #FUN-C80046---end
   ELSE
       ROLLBACK WORK
       MESSAGE 'rollback work!'
   END IF
   #No.MOD-9C0307  --Begin
#  OPEN i003_b_cs
#  LET g_jump = g_curs_index
#  LET mi_no_ask = TRUE
#  CALL i003_fetch('/')
   CALL i003_show()
   #No.MOD-9C0307  --End  
   
END FUNCTION

FUNCTION i003_batch_copy()
   DEFINE p_row,p_col  LIKE type_file.num5
   DEFINE l_sql        STRING
   DEFINE tm           RECORD
                        b1    LIKE cay_file.cay11,
                        yy1   LIKE cay_file.cay01,
                        mm1   LIKE cay_file.cay02,
                        b2    LIKE cay_file.cay11,
                        yy2   LIKE cay_file.cay01,
                        mm2   LIKE cay_file.cay02
                       END RECORD
   DEFINE g_caya_new   RECORD LIKE cay_file.*
   DEFINE l_cay        RECORD LIKE cay_file.*

   LET p_row = 6 LET p_col = 6

   OPEN WINDOW i003_w_c AT p_row,p_col WITH FORM "axc/42f/axci003_c"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("axci003_c")

   INITIALIZE tm.* TO NULL
   INPUT BY NAME tm.b1,tm.yy1,tm.mm1,tm.b2,tm.yy2,tm.mm2 WITHOUT DEFAULTS

      AFTER FIELD b1
         IF NOT cl_null(tm.b1) THEN
            CALL i003_cay11('a',tm.b1)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.b1,g_errno,0)
               LET tm.b1=''
               DISPLAY BY NAME tm.b1
               NEXT FIELD b1
            END IF
         ELSE
            CALL cl_err(tm.b1,'mfg5103',0)
            NEXT FIELD b1
         END IF

      AFTER FIELD b2
         IF NOT cl_null(tm.b2) THEN
            CALL i003_cay11('a',tm.b2)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.b2,g_errno,0)
               LET tm.b2=''
               DISPLAY BY NAME tm.b2
               NEXT FIELD b2
            END IF
         ELSE
            CALL cl_err(tm.b2,'mfg5103',0)
            NEXT FIELD b2
         END IF


      AFTER FIELD yy1
         IF cl_null(tm.yy1) THEN
            CALL cl_err(tm.yy1,'mfg0037',0)
            NEXT FIELD yy1
         END IF

      AFTER FIELD mm1
         IF cl_null(tm.mm1) THEN
            CALL cl_err(tm.mm1,'mfg0037',0)
            NEXT FIELD mm1
         ELSE
            SELECT COUNT(*) INTO g_cnt
              FROM cay_file
#            WHERE cay00=g_cay00
             WHERE cay01=tm.yy1
               AND cay02=tm.mm1
               AND cay11=tm.b1
            IF g_cnt = 0 THEN
               CALL cl_err('','mfg9089',1)
               NEXT FIELD b1
            END IF
         END IF

      AFTER FIELD yy2
         IF cl_null(tm.yy2) THEN
            CALL cl_err(tm.yy2,'mfg0037',0)
            NEXT FIELD yy2
         ELSE
            IF tm.yy2 < g_ccz.ccz01 THEN
               CALL cl_err(tm.yy2,'axc-095',0)
               NEXT FIELD yy2
            END IF
         END IF

      AFTER FIELD mm2
         IF cl_null(tm.mm2) THEN
            CALL cl_err(tm.mm2,'mfg0037',0)
            NEXT FIELD mm2
         ELSE
            IF tm.yy2 = g_ccz.ccz01 AND tm.mm2 < g_ccz.ccz02 THEN
               CALL cl_err(tm.mm2,'axc-095',0)
               NEXT FIELD nn2
            END IF
         END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()


      ON ACTION controlp
         CASE
            WHEN INFIELD(b1)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING tm.b1
                 DISPLAY BY NAME tm.b1
            WHEN INFIELD(b2)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING tm.b2
                 DISPLAY BY NAME tm.b2
            OTHERWISE EXIT CASE
         END CASE


   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i003_w_c
      RETURN
   END IF

   LET l_sql = "SELECT * FROM cay_file",
#              " WHERE cay00='",g_cay00,"'",
               " WHERE cay01='",tm.yy1,"'",
               "   AND cay11='",tm.b1 ,"'",
               "   AND cay02='",tm.mm1,"'"

   PREPARE i003_batch_copy FROM l_sql
   DECLARE i003_batch_c CURSOR FOR i003_batch_copy

   LET l_sql = "SELECT COUNT(*) FROM cay_file ",
#              " WHERE cay00='",g_cay00,"'",
               " WHERE cay01='",tm.yy2,"'",
               "   AND cay02='",tm.mm2,"'",
               "   AND cay11='",tm.b2 ,"'",
               "   AND cay00= ? ",           #MOD-C80052
               "   AND cay03= ? ",
               "   AND cay04= ? ",
               "   AND cay06= ? "
    DECLARE i003_batch_c2 CURSOR FROM l_sql

   MESSAGE "WORKING !"
   FOREACH i003_batch_c INTO l_cay.*
     OPEN i003_batch_c2 USING l_cay.cay00,l_cay.cay03,l_cay.cay04,l_cay.cay06   #MOD-C80052 add cay00
     FETCH i003_batch_c2 INTO g_cnt
     IF g_cnt > 0 THEN
        DELETE FROM cay_file WHERE cay00=l_cay.cay00
                               AND cay01=tm.yy2
                               AND cay02=tm.mm2
                               AND cay11=tm.b2
                               AND cay03=l_cay.cay03
                               AND cay04=l_cay.cay04
                               AND cay06=l_cay.cay06
        IF SQLCA.SQLERRD[3] =0 THEN
           CALL cl_err3("del","cay_file",tm.yy2,tm.mm2,'axc-005',"","del_cay",1)
           CLOSE WINDOW i003_w_c
           RETURN
        END IF
      END IF
#     LET l_cay.cay00=g_cay00
      LET l_cay.cay01=tm.yy2
      LET l_cay.cay02=tm.mm2
      LET l_cay.cay11=tm.b2
      LET l_cay.cayacti='Y'
      LET l_cay.cayuser=g_user
      LET l_cay.caygrup=g_grup
      LET l_cay.caymodu=''
      LET l_cay.caydate=g_today
      LET l_cay.caylegal = g_legal    #FUN-A50075

      INSERT INTO cay_file VALUES (l_cay.* )
      IF STATUS THEN
         CALL cl_err3("ins","cay_file",l_cay.cay01,l_cay.cay02,STATUS,"","ins_cay:",1)
         CLOSE WINDOW i003_w_c
         RETURN
      END IF
#     CALL i003_chk_cay05(l_cay.cay00,l_cay.cay01,l_cay.cay02,l_cay.cay03,l_cay.cay04,l_cay.cay06,l_cay.cay11)  #No.FUN-9C0112
   END FOREACH
   MESSAGE ""
   CLOSE WINDOW i003_w_c
END FUNCTION

FUNCTION i003_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc            STRING

   #No.MOD-9C0307  --Begin
   IF cl_null(p_wc) THEN LET p_wc = ' 1=1' END IF
   #No.MOD-9C0307  --End  
   LET g_sql = "SELECT cay06,'',cay03,'',cay08,cay05,cayacti",
               "  FROM cay_file",
               " WHERE cay00 = '",g_cay00,"'",
               "   AND cay01 = '",g_cay01,"'",
               "   AND cay02 = '",g_cay02,"'",
               "   AND cay04 = '",g_cay04,"'",
               "   AND cay11 = '",g_cay11,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY cay00,cay11,cay01,cay02,cay04 "
    PREPARE i003_prepare2 FROM g_sql      #預備一下
    IF SQLCA.SQLCODE THEN
       CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
       RETURN
    END IF
    DECLARE i003_b_c1 CURSOR FOR i003_prepare2
    CALL g_cay.clear()
    LET g_cnt = 1
    FOREACH i003_b_c1 INTO g_cay[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL i003_cay03(g_cay[g_cnt].cay03) RETURNING g_cay[g_cnt].gem02_2
       CALL i003_cay06(g_cay[g_cnt].cay06,g_caya.cay11) RETURNING g_cay[g_cnt].aag02
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cay.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cay TO s_cay.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION first
         CALL i003_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL i003_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY

      ON ACTION jump
         CALL i003_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL i003_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY

      ON ACTION last
         CALL i003_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY


      ON ACTION reproduce1
         LET g_action_choice="reproduce1"
         EXIT DISPLAY


      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      #No.MOD-9C0292  --Begin
      ##@ON ACTION 重新計算
      #ON ACTION recalculate
      #   LET g_action_choice="recalculate"
      #   EXIT DISPLAY
      #No.MOD-9C0292  --End  

      #@ON ACTION 批次產生
      ON ACTION generate
         LET g_action_choice="generate"
         EXIT DISPLAY

      #No.MOD-9C0292  --Begin
      #ON ACTION recalculate1
      #   LET g_action_choice="recalculate1"
      #   EXIT DISPLAY
      #No.MOD-9C0292  --End  

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i003_r()
   IF g_cay01 IS NULL OR g_cay02 IS NULL OR g_cay00 IS NULL OR 
      g_cay04 IS NULL OR g_cay11 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM cay_file WHERE cay00 = g_cay00
                             AND cay01 = g_cay01
                             AND cay02=  g_cay02
                             AND cay04 = g_cay04
                             AND cay11 = g_cay11
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","cay_file",g_cay01,g_cay02,SQLCA.sqlcode,"","BODY DELETE",1)
      ELSE
         CLEAR FORM
         CALL g_cay.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
         PREPARE i003_precount_x2 FROM g_sql_tmp
         EXECUTE i003_precount_x2
         OPEN i003_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i003_b_cs
            CLOSE i003_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i003_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i003_b_cs
            CLOSE i003_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i003_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i003_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i003_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i003_out()
   DEFINE l_cmd   LIKE type_file.chr1000
   DEFINE l_wc    STRING
   DEFINE l_wc1   STRING

    LET l_wc  = g_wc 
    IF cl_null(g_wc) AND NOT cl_null(g_caya.cay00)
                     AND NOT cl_null(g_caya.cay11)
                     AND NOT cl_null(g_caya.cay01)
                     AND NOT cl_null(g_caya.cay02)
                     AND NOT cl_null(g_caya.cay04) THEN
       LET g_wc="     cay00 = '",g_caya.cay00,"'",
                " AND cay11 = '",g_caya.cay11,"'",
                " AND cay01 = '",g_caya.cay01,"'",
                " AND cay02 = '",g_caya.cay02,"'",
                " AND cay04 = '",g_caya.cay04,"'"
    END IF
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    LET l_cmd = 'p_query "axci003" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
    LET g_wc  = l_wc    #MOD-960319 add

END FUNCTION

FUNCTION i003_getmsg()
   CALL cl_getmsg('axc-070',g_lang) RETURNING g_dept          #部门:      
   CALL cl_getmsg('axc-071',g_lang) RETURNING g_account       #科目:      
   CALL cl_getmsg('axc-072',g_lang) RETURNING g_accumulate    #累计比率:    
   CALL cl_getmsg('axc-073',g_lang) RETURNING g_current       #当前比率:    
   CALL cl_getmsg('axc-074',g_lang) RETURNING g_bookno        #帐套:
END FUNCTION

FUNCTION i003_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
  CALL cl_set_comp_entry("cay03",TRUE)
 
END FUNCTION
 
FUNCTION i003_set_no_entry_b(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1 
  DEFINE l_aag05    LIKE aag_file.aag05
 
  IF l_ac = 0 THEN RETURN END IF

  SELECT aag05 INTO l_aag05 FROM aag_file
   WHERE aag01 = g_cay[l_ac].cay06
     AND aag00 = g_cay11
  IF cl_null(l_aag05) THEN LET l_aag05 = 'N' END IF
  IF l_aag05 ='N' THEN
     LET g_cay[l_ac].cay03 = ' '
     CALL cl_set_comp_entry('cay03',FALSE)
  END IF
 
END FUNCTION
