# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi150.4gl
# Descriptions...: 產品客戶維護作業
# Date & Author..: 94/12/21 By Danny
#                  1.客戶編號(obk02)改為10碼 2.幣別不可空白
#                  3.客戶產品編號可空白      4.按放棄鍵則單身資料不見
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0099 05/02/15 By kim 報表轉XML功能
# Modify.........: NO.MOD-590153 05/10/22 BY yiting 若輸入之料件為無效時會出現mfg3283"此供應廠商資料已無效,無法更新任何資料
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/13 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0079 06/12/01 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6A0045 06/12/06 By Claire default obk11-obk14
# Modify.........: No.MOD-6B0146 06/12/06 By Claire default obk11='N'
# Modify.........: No.TQC-6B0120 06/12/13 By pengu 資料筆數不對
# Modify.........: No.TQC-730102 07/04/09 By Smapmin 增加資料所有者等欄位
# Modify.........: No.TQC-740137 07/04/22 By Carrier 調報表打印格式 & 單價/數量非負控制
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780240 07/08/23 By claire 語法調整
# Modify.........: No.TQC-780095 07/09/03 By Melody Primary key
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840019 08/04/28 By lutingting 報表轉為使用CR輸出

# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0025 10/11/10 By chenying FUNCTION i150_cs() 中的 g_wc 加上企業料號條件
# Modify.........: No:FUN-910088 11/11/15 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50077 13/05/11 By suncx axmt360維護客戶產品資料打開本程序時，本程序沒有接收axmt360參數的邏輯，導致沒帶出響應資料維護
# Modify.........: No:FUN-D50045 13/05/15 By zhuhao 单身客户编号开窗可多选插入单身

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_ima           RECORD
                    ima01    LIKE ima_file.ima01,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021
                    END RECORD,
    g_ima_t         RECORD
                    ima01    LIKE ima_file.ima01,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021
                    END RECORD,
    g_ima31         LIKE ima_file.ima31,
    g_imaacti       LIKE ima_file.imaacti,
    g_ima01_t       LIKE ima_file.ima01,
    g_ima02_t       LIKE ima_file.ima02,
    g_obk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    obk02     LIKE obk_file.obk02,
                    occ02     LIKE occ_file.occ02,
                    obk03     LIKE obk_file.obk03,
                    obk04     LIKE obk_file.obk04,
                    obk05     LIKE obk_file.obk05,
                    obk07     LIKE obk_file.obk07,
                    obk08     LIKE obk_file.obk08,
                    obk09     LIKE obk_file.obk09,
                    #-----TQC-730102---------
                    obkuser   LIKE obk_file.obkuser,
                    obkgrup   LIKE obk_file.obkgrup,
                    obkmodu   LIKE obk_file.obkmodu,
                    obkdate   LIKE obk_file.obkdate,
                    obkacti   LIKE obk_file.obkacti
                    #-----END TQC-730102-----
                    END RECORD,
    g_obk_t         RECORD    #程式變數(Program Variables)
                    obk02     LIKE obk_file.obk02,
                    occ02     LIKE occ_file.occ02,
                    obk03     LIKE obk_file.obk03,
                    obk04     LIKE obk_file.obk04,
                    obk05     LIKE obk_file.obk05,
                    obk07     LIKE obk_file.obk07,
                    obk08     LIKE obk_file.obk08,
                    obk09     LIKE obk_file.obk09,
                    #-----TQC-730102---------
                    obkuser   LIKE obk_file.obkuser,
                    obkgrup   LIKE obk_file.obkgrup,
                    obkmodu   LIKE obk_file.obkmodu,
                    obkdate   LIKE obk_file.obkdate,
                    obkacti   LIKE obk_file.obkacti
                    #-----END TQC-730102-----
                    END RECORD,
#    g_wc,g_wc2,g_sql    LIKE type_file.chr1000, #NO.TQC-630166 MARK  #No.FUN-680137 VARCHAR(300)
    g_wc,g_wc2,g_sql     STRING,     #NO.TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680137 SMALLINT
    g_buf           LIKE ima_file.ima01,  #No.FUN-680137 VARCHAR(40)
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-680137 SMALLINT
    l_cmd           LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(200)
DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-680137 SMALLINT

#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680137 SMALLINT

DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE   l_sql          STRING                 #No.FUN-840019
DEFINE   g_str          STRING                 #No.FUN-840019
DEFINE   l_table        STRING                 #No.FUN-840019
DEFINE   g_obk07_t      LIKE obk_file.obk07    #No.FUN-910088 add
DEFINE   g_argv1        LIKE ima_file.ima01    #MOD-D50077 add
DEFINE   g_flag         LIKE type_file.chr1    #FUN-D50045 add

MAIN
#DEFINE
#    l_time        LIKE type_file.chr8                    #計算被使用時間  #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_argv1 = ARG_VAL(1)  #MOD-D50077 add
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF


     CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
        RETURNING g_time                 #NO.FUN-6A0094

   #No.FUN-840019-----start--
   LET l_sql = "ima01.ima_file.ima01,",
               "ima02.ima_file.ima02,",
               "l_ima021a.ima_file.ima021,",
               "obk02.obk_file.obk02,",
               "occ02.occ_file.occ02,",
               "obk03.obk_file.obk03,",
               "l_ima02.ima_file.ima02,",
               "l_ima021b.ima_file.ima021,",
               "obk04.obk_file.obk04,",
               "obk05.obk_file.obk05,",
               "obk07.obk_file.obk07,",
               "obk08.obk_file.obk08,",
               "obk09.obk_file.obk09,",
               "t_azi03.azi_file.azi03"
   LET l_table = cl_prt_temptable('axmi150',l_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF

   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
   #No.FUN-840019-----end

   LET p_row = 2 LET p_col = 12

   OPEN WINDOW i150_w AT p_row,p_col              #顯示畫面
        WITH FORM "axm/42f/axmi150"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

#MOD-D50077 add begin-------------------
    IF NOT cl_null(g_argv1) THEN
       CALL i150_q()
    END IF
#MOD-D50077 add end --------------------

#No.CHI-6A0004-----Begin------
#   SELECT azi03,azi04,azi05
#     INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#     FROM azi_file
#    WHERE azi01=g_aza.aza17
#No.CHI-6A0004-----End-------
   CALL i150_menu()

   CLOSE WINDOW i150_w                 #結束畫面
     CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
        RETURNING g_time             #NO.FUN-6A0094
END MAIN

#QBE 查詢資料
FUNCTION i150_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN

    CLEAR FORM                             #清除畫面
   CALL g_obk.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
    IF NOT cl_null(g_argv1) THEN               #MOD-D50077 add
       LET g_wc = " ima01 = '",g_argv1,"'"     #MOD-D50077 add
       LET g_wc2 = " 1=1"                      #MOD-D50077 add
    ELSE                                       #MOD-D50077 add
    CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       #No.TQC-740137  --Begin
       ON ACTION controlp
          CASE
             WHEN INFIELD(ima01)
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form ="q_ima"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO ima01
          END CASE
       #No.TQC-740137  --End

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
    LET g_wc=g_wc CLIPPED," AND (ima120='1' OR ima120=' ' OR ima120 IS NULL) "  #FUN-AB0025 add
    IF INT_FLAG THEN RETURN END IF

    CONSTRUCT g_wc2 ON obk02,obk03,obk04,obk05,  # 螢幕上取單身條件
                       #obk07,obk08,obk09   #TQC-730102
                       obk07,obk08,obk09,obkuser,obkgrup,obkmodu,obkdate,obkacti   #TQC-730102
            FROM s_obk[1].obk02, s_obk[1].obk03,
                 s_obk[1].obk04, s_obk[1].obk05, s_obk[1].obk07,
                 s_obk[1].obk08, s_obk[1].obk09,
                 s_obk[1].obkuser,s_obk[1].obkgrup,s_obk[1].obkmodu,   #TQC-730102
                 s_obk[1].obkdate,s_obk[1].obkacti   #TQC-730102

		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    ON ACTION controlp
       CASE
          WHEN INFIELD(obk02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_occ"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO obk02
               NEXT FIELD obk02
          WHEN INFIELD(obk05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO obk05
               NEXT FIELD obk05
          WHEN INFIELD(obk07)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gfe"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO obk07
               NEXT FIELD obk07
       END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    END IF   #MOD-D50077 add

    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ima01 FROM ima_file",
                   " WHERE ima130 != '0' AND ", g_wc CLIPPED,
                   " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ima_file.ima01 ",
                   "  FROM ima_file, obk_file",
                   " WHERE ima01 = obk01 AND ima130 != '0'",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF

    PREPARE i150_prepare FROM g_sql
    DECLARE i150_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i150_prepare

    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
  #-----------No.TQC-6B0120 modify
   #    LET g_sql="SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED
   #ELSE
   #    LET g_sql="SELECT COUNT(DISTINCT ima01) FROM ima_file,obk_file",
   #              " WHERE obk01=ima01",
   #              "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED

        LET g_sql="SELECT COUNT(*) FROM ima_file WHERE ima130 != '0' AND ",
                   g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT ima01) FROM ima_file,obk_file",
                  " WHERE obk01=ima01 AND ima130 != '0' ",   #MOD-780240 mark AND",
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
  #-----------No.TQC-6B0120 end
    END IF
    PREPARE i150_precount FROM g_sql
    DECLARE i150_count CURSOR FOR i150_precount
END FUNCTION

FUNCTION i150_menu()

   WHILE TRUE
      CALL i150_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i150_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i150_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i150_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_obk),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ima.ima01 IS NOT NULL THEN
                 LET g_doc.column1 = "ima01"
                 LET g_doc.value1 = g_ima.ima01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
END FUNCTION

#Query 查詢
FUNCTION i150_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )

    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt

    CALL i150_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_ima.* TO NULL
        RETURN
    END IF

    MESSAGE " SEARCHING ! "
    OPEN i150_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL
    ELSE
       OPEN i150_count
       FETCH i150_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i150_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF

    MESSAGE ""

END FUNCTION

#處理資料的讀取
FUNCTION i150_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                  #處理方式  #No.FUN-680137 VARCHAR(1)
    l_imauser       LIKE ima_file.imauser,  #FUN-4C0057  add
    l_imagrup       LIKE ima_file.imagrup   #FUN-4C0057  add

  CASE p_flag
    WHEN 'N' FETCH NEXT     i150_cs INTO g_ima.ima01
    WHEN 'P' FETCH PREVIOUS i150_cs INTO g_ima.ima01
    WHEN 'F' FETCH FIRST    i150_cs INTO g_ima.ima01
    WHEN 'L' FETCH LAST     i150_cs INTO g_ima.ima01
    WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT

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
            FETCH ABSOLUTE g_jump i150_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
  END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL             #No.FUN-6B0079 add
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT ima01,ima02,ima021,ima31,imaacti,imauser,imagrup
      INTO g_ima.*,g_ima31,g_imaacti,l_imauser,l_imagrup
      FROM ima_file
     WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_ima.* TO NULL
       RETURN
    END IF
    LET g_data_owner = l_imauser      #FUN-4C0057 add
    LET g_data_group = l_imagrup      #FUN-4C0057 add
    CALL i150_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i150_show()

    LET g_ima_t.* = g_ima.*                #保存單頭舊值
    DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021

    CALL i150_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION i150_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680137 VARCHAR(1)
    g_obk10         LIKE obk_file.obk10,
    l_obk11         LIKE obk_file.obk11,   #TQC-6A0045
    l_obk12         LIKE obk_file.obk12,   #TQC-6A0045
    l_obk13         LIKE obk_file.obk13,   #TQC-6A0045
    l_obk14         LIKE obk_file.obk14,   #TQC-6A0045
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680137 SMALLINT

    LET g_action_choice = ""
    IF g_ima.ima01 IS NULL THEN RETURN END IF
    IF g_imaacti = 'N' THEN
       #CALL  cl_err('','mfg3283',0)
       CALL  cl_err('','aim-502',0)  #NO.MOD-590153
       RETURN
    END IF

    CALL cl_opmsg('b')


    LET g_forupd_sql =
        #" SELECT obk02,'',obk03,obk04,obk05,obk07,obk08,obk09 FROM obk_file ",   #TQC-730102
        " SELECT obk02,'',obk03,obk04,obk05,obk07,obk08,obk09, ",   #TQC-730102
        "        obkuser,obkgrup,obkmodu,obkdate,obkacti FROM obk_file ",   #TQC-730102
        " WHERE obk01 = ? AND obk02 = ? AND obk05 = ?  FOR UPDATE "  #No.FUN-670099
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i150_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_obk WITHOUT DEFAULTS FROM s_obk.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd =''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()

            BEGIN WORK

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_obk_t.* = g_obk[l_ac].*  #BACKUP
               LET g_obk07_t = g_obk[l_ac].obk07  #No.FUN-910088 add

               OPEN i150_bcl USING g_ima.ima01,g_obk_t.obk02,g_obk_t.obk05
               IF STATUS THEN
                  CALL cl_err("OPEN i150_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i150_bcl INTO g_obk[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_obk_t.obk02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT occ02 INTO g_obk[l_ac].occ02 FROM occ_file
                      WHERE occ01=g_obk[l_ac].obk02
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_obk[l_ac].* TO NULL      #900423
            LET g_obk[l_ac].obk07 = g_ima31       #Default
            LET g_obk[l_ac].obk04 = g_today       #Default
            LET g_obk[l_ac].obk08 = 0             #Default
            LET g_obk[l_ac].obk09 = 0             #Default
            #-----TQC-730102---------
            LET g_obk[l_ac].obkuser = g_user
            LET g_obk[l_ac].obkgrup = g_grup
            LET g_obk[l_ac].obkdate = g_today
            LET g_obk[l_ac].obkacti = 'Y'
            #-----END TQC-730102-----
            LET g_obk_t.* = g_obk[l_ac].*         #新輸入資料
            LET g_obk07_t = NULL        #No.FUN-910088 add
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obk02

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           #MOD-6B0146-begin-mark
           ##TQC-6A0045-begin-add
           #SELECT ima24,ima100,ima101,ima102
           #  INTO l_obk11,l_obk12,l_obk13,l_obk14
           #  FROM ima_file
           # WHERE ima01=g_ima.ima01
           #IF cl_null(l_obk11) THEN
           #   LET l_obk11 = 'N'
           #END IF
           ##TQC-6A0045-end-add
             LET l_obk11 = 'N'
           #MOD-6B0146-end-mark
      #TQC-780095
       IF cl_null(g_obk[l_ac].obk02) THEN LET g_obk[l_ac].obk02=' ' END IF
       IF cl_null(g_obk[l_ac].obk05) THEN LET g_obk[l_ac].obk05=' ' END IF
      #TQC-780095
            INSERT INTO obk_file(obk01,obk02,obk03,obk04,obk05,
                                 obk06,obk07,obk08,obk09,obk10, #No.MOD-4700041
                                 #obk11)  #MOD-6B0146 mark ,obk12,obk13,obk14) #TQC-6A0045 add   #TQC-730102
                                 obk11,obkuser,obkgrup,obkmodu,obkdate,obkacti)  #TQC-730102
                          VALUES(g_ima.ima01,g_obk[l_ac].obk02,
                                 g_obk[l_ac].obk03,g_obk[l_ac].obk04,
                                 g_obk[l_ac].obk05,' ',
                                 g_obk[l_ac].obk07,g_obk[l_ac].obk08,
                                 g_obk[l_ac].obk09,g_obk10,
                                 #l_obk11) #MOD-6B0146 mark ,l_obk12,l_obk13,l_obk14) #TQC-6A0045 add   #TQC-730102
                                 l_obk11,g_obk[l_ac].obkuser,g_obk[l_ac].obkgrup,g_obk[l_ac].obkmodu,   #TQC-730102
                                 g_obk[l_ac].obkdate,g_obk[l_ac].obkacti) #TQC-730102
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_obk[l_ac].obk02,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","obk_file",g_ima.ima01,g_obk[l_ac].obk02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
            END IF

        AFTER FIELD obk02
           IF NOT cl_null(g_obk[l_ac].obk02) THEN
             ##-----No.FUN-670099 Mark-----
             #IF cl_null(g_obk_t.obk02) OR g_obk_t.obk02 != g_obk[l_ac].obk02 THEN
             #   SELECT count(*) INTO l_n FROM obk_file
             #    WHERE obk01 = g_ima.ima01
             #      AND obk02 = g_obk[l_ac].obk02
             #   IF l_n > 0  THEN
             #      CALL cl_err('',-239,0)
             #      LET g_obk[l_ac].obk02 = g_obk_t.obk02
             #      NEXT FIELD obk02
             #   END IF
             #END IF
             ##-----No.FUN-670099 Mark END-----

              SELECT occ02 INTO g_buf FROM occ_file
               WHERE occ01=g_obk[l_ac].obk02
              IF SQLCA.SQLCODE  THEN  #No.7926
#                CALL cl_err('select occ',SQLCA.SQLCODE,0)   #No.FUN-660167
                 CALL cl_err3("sel","occ_file",g_obk[l_ac].obk02,"",SQLCA.SQLCODE,"","select occ",1)  #No.FUN-660167
                 NEXT FIELD obk02
              END IF
              LET g_obk[l_ac].occ02=g_buf
              DISPLAY g_obk[l_ac].occ02 TO s_obk[l_ac].occ02

           END IF

        AFTER FIELD obk05
           IF NOT cl_null(g_obk[l_ac].obk05) THEN
              #-----No.FUN-670099-----
              IF cl_null(g_obk_t.obk05) OR g_obk_t.obk05 != g_obk[l_ac].obk05 THEN
                 SELECT count(*) INTO l_n FROM obk_file
                  WHERE obk01 = g_ima.ima01
                    AND obk02 = g_obk[l_ac].obk02
                    AND obk05 = g_obk[l_ac].obk05
                 IF l_n > 0  THEN
                    CALL cl_err('',-239,0)
                    LET g_obk[l_ac].obk05 = g_obk_t.obk05
                    NEXT FIELD obk05
                 END IF
              END IF
              #-----No.FUN-670099 END-----

              SELECT COUNT(*) INTO g_cnt FROM azi_file
               WHERE azi01=g_obk[l_ac].obk05 AND aziacti='Y'
              IF g_cnt =0 THEN
                 CALL cl_err('sel azi: ','aap-002',0)
                 LET g_obk[l_ac].obk05 = g_obk_t.obk05
                 NEXT FIELD obk05
              END IF

            # LET g_obk_t.obk05 = g_obk[l_ac].obk05

            END IF

        AFTER FIELD obk07
            IF NOT cl_null(g_obk[l_ac].obk07) THEN
               SELECT COUNT(*) INTO g_cnt FROM gfe_file
                WHERE gfe01=g_obk[l_ac].obk07 AND gfeacti='Y'
               IF g_cnt =0 THEN
                  CALL cl_err('sel gfe: ','aoo-012',0)
                  LET g_obk[l_ac].obk07 = g_obk_t.obk07
                  NEXT FIELD obk07
               END IF
               LET g_obk_t.obk07 = g_obk[l_ac].obk07
               #FUN-910088--add--start--
               IF NOT i150_obk09_check() THEN 
                  LET g_obk07_t = g_obk[l_ac].obk07
                  NEXT FIELD obk09 
               END IF 
               LET g_obk07_t = g_obk[l_ac].obk07
               #FUN-910088--add--end--
            END IF


        #No.TQC-740137  --Begin
        AFTER FIELD obk08
            IF NOT cl_null(g_obk[l_ac].obk08) THEN
               IF g_obk[l_ac].obk08 < 0 THEN
                  CALL cl_err(g_obk[l_ac].obk08,'aim-391',0)
                  NEXT FIELD obk08
               END IF
            END IF

        AFTER FIELD obk09
            IF NOT i150_obk09_check()  THEN NEXT FIELD obk09 END IF #FUN-910088--add--

            #FUN-910088--mark--start--
            #IF NOT cl_null(g_obk[l_ac].obk09) THEN
               #IF g_obk[l_ac].obk09 < 0 THEN
                  #CALL cl_err(g_obk[l_ac].obk09,'aim-391',0)
                  #NEXT FIELD obk09
               #END IF
            #END IF
            #FUN-910088--mark--end--
        #No.TQC-740137  --End

        BEFORE DELETE                            #是否取消單身
            IF g_obk_t.obk02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM obk_file
                 WHERE obk01 = g_ima.ima01
                   AND obk02 = g_obk_t.obk02
                   AND obk05 = g_obk_t.obk05   #No.FUN-670099
                IF SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err(g_obk_t.obk02,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","obk_file",g_ima.ima01,g_obk_t.obk02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                   LET g_rec_b = g_rec_b -1
                   COMMIT WORK
                END IF
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obk[l_ac].* = g_obk_t.*
               CLOSE i150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obk[l_ac].obk02,-263,1)
               LET g_obk[l_ac].* = g_obk_t.*
            ELSE
               LET g_obk[l_ac].obkmodu=g_user   #TQC-730102
               LET g_obk[l_ac].obkdate=g_today  #TQC-730102
               UPDATE obk_file SET obk02=g_obk[l_ac].obk02,
                                   obk03=g_obk[l_ac].obk03,
                                   obk04=g_obk[l_ac].obk04,
                                   obk05=g_obk[l_ac].obk05,
                                   obk07=g_obk[l_ac].obk07,
                                   obk08=g_obk[l_ac].obk08,
                                   obk09=g_obk[l_ac].obk09,
                                   obkmodu=g_obk[l_ac].obkmodu,   #TQC-730102
                                   obkdate=g_obk[l_ac].obkdate,   #TQC-730102
                                   obkacti=g_obk[l_ac].obkacti,   #TQC-730102
                                   obk10=g_obk10
                WHERE obk01 = g_ima.ima01
                  AND obk02 = g_obk_t.obk02
                  AND obk05 = g_obk_t.obk05   #No.FUN-670099
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_obk[l_ac].obk02,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","obk_file",g_ima.ima01,g_obk_t.obk02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_obk[l_ac].* = g_obk_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_obk[l_ac].* = g_obk_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_obk.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i150_bcl
            COMMIT WORK

#       ON ACTION CONTROLN
#           CALL i150_b_askkey()
#           EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(obk02) AND l_ac > 1 THEN
                LET g_obk[l_ac].* = g_obk[l_ac-1].*
                NEXT FIELD obk02
            END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION controlp
           CASE
              WHEN INFIELD(obk02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
#No.FUN-D50045 --------- add -------- begin ----------------
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   IF NOT cl_null(g_qryparam.multiret)  THEN
                      CALL i150_obk02()
                      CALL i150_b_fill(" 1=1")
                      COMMIT WORK
                      LET g_flag = TRUE
                      EXIT INPUT
                   END IF
#No.FUN-D50045 --------- add -------- begin ----------------
#No.FUN-D50045 ------- mark -------- begin -----------------
#                   LET g_qryparam.default1 = g_obk[l_ac].obk02
#                   CALL cl_create_qry() RETURNING g_obk[l_ac].obk02
##                   CALL FGL_DIALOG_SETBUFFER( g_obk[l_ac].obk02 )
#                    DISPLAY g_obk[l_ac].obk02 TO obk02            #No.MOD-490371
#                   NEXT FIELD obk02
#No.FUN-D50045 ------- mark -------- end -------------------
              WHEN INFIELD(obk05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azi"
                   LET g_qryparam.default1 = g_obk[l_ac].obk05
                   CALL cl_create_qry() RETURNING g_obk[l_ac].obk05
#                   CALL FGL_DIALOG_SETBUFFER( g_obk[l_ac].obk05 )
                    DISPLAY g_obk[l_ac].obk05 TO obk05            #No.MOD-490371
                   NEXT FIELD obk05
              WHEN INFIELD(obk07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_obk[l_ac].obk07
                   CALL cl_create_qry() RETURNING g_obk[l_ac].obk07
#                   CALL FGL_DIALOG_SETBUFFER( g_obk[l_ac].obk07 )
                    DISPLAY g_obk[l_ac].obk07 TO obk07            #No.MOD-490371
                   NEXT FIELD obk07
           END CASE

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121


    END INPUT

#No.FUN-D50045 --------- add -------- begin ----------------
    IF g_flag THEN
       LET g_flag = FALSE
       CALL i150_b()
    END IF
#No.FUN-D50045 --------- add -------- end ------------------

    CLOSE i150_bcl
    COMMIT WORK

END FUNCTION

FUNCTION i150_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(200)

    CONSTRUCT l_wc2 ON obk02,occ02,obk03,obk04,obk05,obk07,obk08,obk09
            FROM s_obk[1].obk02,s_obk[1].occ02,s_obk[1].obk03,
                 s_obk[1].obk04,s_obk[1].obk05,s_obk[1].obk07,
                 s_obk[1].obk08,s_obk[1].obk09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i150_b_fill(l_wc2)

END FUNCTION

FUNCTION i150_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(200)

   LET g_sql = "SELECT obk02,occ02,obk03,obk04,obk05,obk07,obk08,obk09, ",
               "       obkuser,obkgrup,obkmodu,obkdate,obkacti ",   #TQC-730102
               " FROM obk_file,occ_file",
               " WHERE obk01 ='",g_ima.ima01,"'",  #單頭
               "   AND occ01= obk02 ",
               "   AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY obk02"

   PREPARE i150_pb FROM g_sql
   DECLARE obk_curs CURSOR FOR i150_pb

   CALL g_obk.clear()
   LET g_rec_b = 0
   LET g_cnt = 1

   FOREACH obk_curs INTO g_obk[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1

       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF

   END FOREACH
   CALL g_obk.deleteElement(g_cnt)
   LET g_rec_b =g_cnt-1

END FUNCTION

FUNCTION i150_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_obk TO s_obk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i150_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION previous
         CALL i150_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION jump
         CALL i150_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION next
         CALL i150_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION last
         CALL i150_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---


      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION


FUNCTION i150_out()
DEFINE l_i      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       sr       RECORD
           ima01   LIKE ima_file.ima01,
           ima02   LIKE ima_file.ima02,
           obk02   LIKE obk_file.obk02,
           occ02   LIKE occ_file.occ02,
           obk03   LIKE obk_file.obk03,
           obk04   LIKE obk_file.obk04,
           obk05   LIKE obk_file.obk05,
           obk07   LIKE obk_file.obk07,
           obk08   LIKE obk_file.obk08,
           obk09   LIKE obk_file.obk09
                END RECORD,
       l_name   LIKE type_file.chr20,   #No.FUN-680137 VARCHAR(20)
       l_za05   LIKE type_file.chr1000 #No.FUN-680137CHAR(45)
 DEFINE l_ima02         LIKE ima_file.ima02      #No.FUN-840019
 DEFINE l_ima021a,l_ima021b  LIKE ima_file.ima021  #No.FUN-840019

    CALL cl_del_data(l_table)   #No.FUN-840019
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF

    CALL cl_wait()
    #CALL cl_outnam('axmi150') RETURNING l_name   #No.FUN-840019

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ima01,ima02,obk02,occ02,obk03,obk04,obk05,",
              "       obk07,obk08,obk09",
              " FROM ima_file,obk_file,occ_file",
              " WHERE ima01 = obk01 ",
              "   AND occ01 = obk02 ",
              "   AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY ima01,obk02 "
    PREPARE i150_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i150_co CURSOR FOR i150_p1

    #START REPORT i150_rep TO l_name   #No.FUN-840019

    FOREACH i150_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #No.FUN-840019------start--
        SELECT ima021 INTO l_ima021a FROM ima_file
            WHERE ima01=sr.ima01
        IF SQLCA.sqlcode THEN
            LET l_ima021a = NULL
        END IF
        #no.4560 依幣別取位
        SELECT azi03 INTO t_azi03 FROM azi_file
         WHERE azi01 = sr.obk05
        #no.4560(end)
        SELECT ima02,ima021 INTO l_ima02,l_ima021b FROM ima_file
            WHERE ima01=sr.obk03
        IF SQLCA.sqlcode THEN
            LET l_ima02 = NULL
            LET l_ima021b = NULL
        END IF
        EXECUTE insert_prep USING
           sr.ima01,sr.ima02,l_ima021a,sr.obk02,sr.occ02,sr.obk03,l_ima02,
           l_ima021b,sr.obk04,sr.obk05,sr.obk07,sr.obk08,sr.obk09,t_azi03
        #OUTPUT TO REPORT i150_rep(sr.*)
        #No.FUN-840019------end
    END FOREACH

    #No.FUN-840019---start--
    LET l_sql = "SELECT* FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'ima01,ima02,ima021,obk02,obk03,obk04,obk05,
                     obk07,obk08,obk09,obkuser,obkgrup,obkmodu,obkdate,obkacti')
       RETURNING g_str
    END IF
    CALL cl_prt_cs3('axmi150','axmi150',l_sql,g_str)
    #FINISH REPORT i150_rep

    CLOSE i150_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    #No.FUN-840019---end
END FUNCTION

#No.FUN-910088---start---add---
FUNCTION i150_obk09_check()
   IF NOT cl_null(g_obk[l_ac].obk09) AND NOT cl_null(g_obk[l_ac].obk07) THEN
      IF cl_null(g_obk_t.obk09) OR cl_null(g_obk07_t) OR g_obk_t.obk09 != g_obk[l_ac].obk09 OR g_obk07_t != g_obk[l_ac].obk07 THEN
         LET g_obk[l_ac].obk09=s_digqty(g_obk[l_ac].obk09, g_obk[l_ac].obk07)
         DISPLAY BY NAME g_obk[l_ac].obk09
      END IF
   END IF
   
   IF NOT cl_null(g_obk[l_ac].obk09) THEN
      IF g_obk[l_ac].obk09 < 0 THEN
         CALL cl_err(g_obk[l_ac].obk09,'aim-391',0)
         RETURN FALSE 
      END IF
   END IF

   RETURN TRUE 
END FUNCTION
#No.FUN-910088---end---add---

#No.FUN-840019--start--
#REPORT i150_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
#    l_sql1          STRING, #NO.TQC-630166
#    l_i             LIKE type_file.num5,    #No.FUN-680137 SMALLINT
#    l_ima02         LIKE ima_file.ima02,
#    l_ima021a,l_ima021b  LIKE ima_file.ima021,
#    sr              RECORD
#        ima01       LIKE ima_file.ima01,
#        ima02       LIKE ima_file.ima02,
#        obk02       LIKE obk_file.obk02,
#        occ02       LIKE occ_file.occ02,
#        obk03       LIKE obk_file.obk03,
#        obk04       LIKE obk_file.obk04,
#        obk05       LIKE obk_file.obk05,
#        obk07       LIKE obk_file.obk07,
#        obk08       LIKE obk_file.obk08,
#        obk09       LIKE obk_file.obk09
#                    END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.ima01,sr.obk02
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT
#            PRINT g_dash
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                  g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.ima01
#            SELECT ima021 INTO l_ima021a FROM ima_file
#                WHERE ima01=sr.ima01
#            IF SQLCA.sqlcode THEN
#                LET l_ima021a = NULL
#            END IF
#           PRINT COLUMN g_c[31],g_x[9] CLIPPED,sr.ima01 CLIPPED,
#                 ' ',sr.ima02 CLIPPED,' ',l_ima021a CLIPPED
#           PRINT
#
#        ON EVERY ROW
#           #no.4560 依幣別取位
#           SELECT azi03 INTO t_azi03 FROM azi_file
#            WHERE azi01 = sr.obk05
#           #no.4560(end)
#           SELECT ima02,ima021 INTO l_ima02,l_ima021b FROM ima_file
#               WHERE ima01=sr.obk03
#           IF SQLCA.sqlcode THEN
#               LET l_ima02 = NULL
#               LET l_ima021b = NULL
#           END IF
##          PRINT COLUMN g_c[31],sr.obk02[1,8],  #No.TQC-740137
#           PRINT COLUMN g_c[31],sr.obk02,       #No.TQC-740137
#                 COLUMN g_c[32],sr.occ02,
#                 COLUMN g_c[33],sr.obk03,
#                 COLUMN g_c[34],l_ima02,
#                 COLUMN g_c[35],l_ima021b,
#                 COLUMN g_c[36],sr.obk04,
#                 COLUMN g_c[37],sr.obk05,
#                 COLUMN g_c[38],sr.obk07,
#                 COLUMN g_c[39],cl_numfor(sr.obk08,39,t_azi03),
#                 COLUMN g_c[40],cl_numfor(sr.obk09,40,2)
#
#        AFTER GROUP OF sr.ima01
#           PRINT
#
#        ON LAST ROW
#            PRINT g_dash
#            IF g_zz05 = 'Y' THEN
##NO.TQC-631066 start--
##              IF g_wc[001,080] > ' ' THEN
##	          PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
##              IF g_wc[071,150] > ' ' THEN
##	          PRINT COLUMN 10,     g_wc[071,150] CLIPPED END IF
##              IF g_wc[141,210] > ' ' THEN
##	          PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#               CALL cl_prt_pos_wc(g_wc)
##NO.TQC-631066 end--
#                    PRINT g_dash
#            END IF
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-840019--end


#NO.FUN-D50045 ---------- add --------------- begin --------------
FUNCTION i150_obk02()
   DEFINE l_obk     RECORD LIKE obk_file.*
   DEFINE tok       base.StringTokenizer

   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_qryparam.multiret,"|")
   WHILE tok.hasMoreTokens()
      LET l_obk.obk01 = g_ima.ima01
      LET l_obk.obk02 = tok.nextToken()
      LET l_obk.obk07 = g_ima31
      LET l_obk.obk04 = g_today
      SELECT occ42 INTO l_obk.obk05 FROM occ_file WHERE occ01 = l_obk.obk02
      IF cl_null(l_obk.obk05) THEN
         CALL s_errmsg('obk05',l_obk.obk02,'INS obk_file','afa-111',1)
         CONTINUE WHILE
      END IF
      LET l_obk.obk08 = 0
      LET l_obk.obk09 = 0
      LET l_obk.obk11 = 'N'
      LET l_obk.obkuser = g_user
      LET l_obk.obkgrup = g_grup
      LET l_obk.obkdate = g_today
      LET l_obk.obkacti = 'Y'
      INSERT INTO obk_file VALUES(l_obk.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('obk02',l_obk.obk02,'INS obk_file',SQLCA.sqlcode,1)
         CONTINUE WHILE
      END IF
   END WHILE
   CALL s_showmsg()
END FUNCTION
#NO.FUN-D50045 ---------- add --------------- end ----------------
