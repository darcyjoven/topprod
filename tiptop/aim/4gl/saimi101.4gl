# Prog. Version..: '5.30.06-13.03.12(00010)'     #
# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimi101.4gl
# Descriptions...: 料件基本資料維護作業-庫存資料
# Date & Author..: 91/04/11 By Lee
# Modify ........: 92/06/18 畫面上增加 [庫存資料處理狀況](ima93[1,1])
#                           的input查詢...... By Lin
# Modify         : 93/03/04  Multiplant Data transfer
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.FUN-4A0041 04/10/06 By Echo 料號開窗
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0246 04/10/15 By Melody prompt出來的視窗只能按Y/N,不能按確定或放棄
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/01/28 By Mandy 報表轉XML
# Modify.........: No.MOD-550085 05/05/16 By pengu 無法正確顯示附圖
# Modify.........: No.MOD-530276 05/06/16 By kim 資料拋轉後,按取消,error code錯誤'使用者並非多工廠使用者
# Modify.........: No.MOD-530699 05/06/17 By kim 每當料件已經有異動後,管控庫存單位不能修改
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.MOD-5A0337 05/10/31 By Sarah CALL cl_confirm的回傳值l_ans是0/1,不是Y/N
# Modify.........: No.MOD-640541 06/04/21 By ice Action"create_item"修改
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: NO.TQC-790093 07/09/20 BY yiting Primary Key的-268訊息 程式修改
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.MOD-7A0102 07/10/18 By Carol 調整圖形顯示
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/28 By hellen 將imaicd_file變成icd專用
# Modify.........: No.FUN-840019 08/04/28 By lutingting報表轉為使用CR輸出
# Modify.........: No.MOD-880183 08/08/29 By wujie  資料拋轉時，庫存量等數量要清0
# Modify.........: No.MOD-870312 08/08/24 By claire 修改庫存單位時,同時更新ima86,ima86_fac
# Modify.........: No.TQC-940177 09/05/11 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0127 09/11/24 By sabrina default發料單位時未default換算率
# Modify.........: No.FUN-9C0072 10/01.05 By vealxu 精簡程式碼
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A50011 10/07/12 By yangfeng 添加aimi100中對子料件的更新
# Modify.........: No.FUN-A50102 10/07/26 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A80017 10/08/13 By Summer 1.資料拋轉功能應與aimi100一樣
#                                                   2.增加"資料拋轉歷史"功能
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 1.只能允許查詢料件性質(ima120)='1' (企業料號')
#                                                   2.程式中如有  INSERT INTO ima_file 時料件性質(ima120)值給'1'(企業料號)
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1  開窗BUG處理
# Modify.........: No.MOD-AC0161 10/12/18 By vealxu call 's_upd_ima_subparts('的程式段，都要先判斷如果行業別是鞋服業才做
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询
# Modify.........: No.FUN-B90102 11/10/18 By qiaozy 服飾開發：子料件不可修改，母料件需要把ima資料更新到子料件中
# Modify.........: No:FUN-BB0086 11/11/29 By tanxc 增加數量欄位小數取位
# Modify.........: No.FUN-B80032 11/12/15 By yangxf ima_file 更新揮寫rtepos

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C40155 12/04/18 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題
# Modify.........: No.FUN-CB0052 12/11/19 By xianghui 發票倉庫控管改善

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aimi100.global" #CHI-A80017 add
GLOBALS "../../sub/4gl/s_data_center.global"   #CHI-A80017 add

DEFINE
         g_ima       RECORD LIKE ima_file.*,
         g_imb       RECORD LIKE imb_file.*,
         g_ima_t     RECORD LIKE ima_file.*,
         g_ima_o     RECORD LIKE ima_file.*,
         g_ima01_t          LIKE ima_file.ima01,
#        g_d2               LIKE ima_file.ima26,    #NO.FUN-A20044
         g_d2               LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
         g_s                LIKE type_file.chr1,    #料件處理狀況    #No.FUN-690026 VARCHAR(1)
         g_sw               LIKE type_file.num5,    #單位是否可轉換  #No.FUN-690026 SMALLINT
         g_wc,g_sql         STRING,                 #TQC-630166
         g_argv1            LIKE ima_file.ima01,
         l_azp03            LIKE azp_file.azp03,
         l_dbs              LIKE azp_file.azp03,
         l_azp01            LIKE azp_file.azp01,   #FUN-A50102
         p_plant            LIKE azp_file.azp01,   #FUN-A50102
         l_zx07             LIKE zx_file.zx07,
         l_zx08             LIKE zx_file.zx08      #MOD-530276
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr                LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                  LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5    #FUN-570110  #No.FUN-690026 SMALLINT
DEFINE g_str                STRING                 #No.FUN-840019
DEFINE l_sql                STRING                 #No.FUN-840019
DEFINE l_table              STRING                 #No.FUN-840019
DEFINE g_ima63_t            LIKE ima_file.ima63    #No.FUN-BB0086 add
DEFINE g_ima25_t            LIKE ima_file.ima25    #No.FUN-BB0086 add

FUNCTION aimi101(p_argv1)
    DEFINE p_argv1         LIKE ima_file.ima01

      LET l_sql = "imaacti.ima_file.imaacti,",
                  "ima01.ima_file.ima01,",
                  "ima02.ima_file.ima02,",
                  "ima05.ima_file.ima05,",
                  "ima08.ima_file.ima08,",
                  "ima25.ima_file.ima25,",
                  "ima021.ima_file.ima021"
      LET l_table = cl_prt_temptable('aimi101',l_sql) CLIPPED
      IF l_table=-1 THEN
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM END IF

      LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " VALUES(?,?,?,?,?,?,?)"
      PREPARE insert_prep FROM l_sql
      IF STATUS THEN
         CALL cl_err('insert_prep:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF

    INITIALIZE g_ima.* TO NULL
    INITIALIZE g_ima_t.* TO NULL
    INITIALIZE g_ima25_t TO NULL   #No.FUN-BB0086 add
    INITIALIZE g_ima63_t TO NULL   #No.FUN-BB0086 add

    LET g_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi101_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR

    LET g_argv1 = p_argv1

    OPEN WINDOW aimi101_w WITH FORM "aim/42f/aimi101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

    #SELECT zx07,zx08,azp03 INTO l_zx07,l_zx08,l_dbs FROM zx_file,azp_file
    SELECT zx07,zx08,azp03,azp01 INTO l_zx07,l_zx08,l_dbs,p_plant FROM zx_file,azp_file  #FUN-A50102
      WHERE zx01 = g_user AND azp01 = zx08              #MOD-530276
    IF SQLCA.sqlcode THEN LET l_zx07 = 'N' END IF

    IF NOT cl_null(g_argv1) THEN
       CALL aimi101_q()
    END IF

    WHILE TRUE
      LET g_action_choice=""
    CALL aimi101_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW aimi101_w
END FUNCTION

FUNCTION aimi101_curs()

    CLEAR FORM
  IF cl_null(g_argv1) THEN
    INITIALIZE g_ima.* TO NULL   #FUN-640213 add

    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ima01,ima02,ima021,ima08,ima05,ima25,ima04,
        ima03,ima07,ima15,ima70,ima23,ima35,ima36,
        ima71,ima271,ima27,ima28,ima63,ima63_fac,ima64,ima641,
#       ima26,ima262,ima261,ima29,ima30,ima73,ima74,ima902,    #NO.FUN-A20044
        ima29,ima30,ima73,ima74,ima902,                        #NO.FUN-A20044
        imauser, imagrup, imamodu, imadate, imaacti
        ,imaoriu,imaorig  #TQC-B90177
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)
#FUN-AA0059 --Begin--
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"      #FUN-AB0025
                CALL cl_create_qry() RETURNING g_qryparam.multiret
              #  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret   #FUN-AB0025
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO ima01
                NEXT FIELD ima01

               WHEN INFIELD(ima23) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ima.ima23
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima23
                  CALL aimi101_peo(g_ima.ima23,'d')
                  NEXT FIELD ima23
               WHEN INFIELD(ima25) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ima.ima25
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima25
                  NEXT FIELD ima25
               WHEN INFIELD (ima35) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imd"
                 LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ima.ima35 #MOD-4A0213
                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima35
                  NEXT FIELD ima35
               WHEN INFIELD (ima36) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ime"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima36
                  NEXT FIELD ima36
               WHEN INFIELD(ima63)                       #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ima.ima63
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima63
                  NEXT FIELD ima63
               OTHERWISE EXIT CASE
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


                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT

    IF INT_FLAG THEN RETURN END IF
    LET g_s=NULL
    INPUT g_s   WITHOUT DEFAULTS FROM s
        AFTER FIELD s  #資料處理狀況
            IF g_s NOT MATCHES '[YN]' THEN
               NEXT FIELD s
            END IF
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
    IF INT_FLAG THEN RETURN END IF
    IF g_s IS NOT NULL THEN
       LET g_wc=g_wc CLIPPED," AND ima93[1,1] matches '",g_s,"' "
    END IF
  ELSE
      LET g_wc = " ima01 = '",g_argv1,"'"
  END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

    LET g_sql="SELECT ima01 FROM ima_file ", # 組合出 SQL 指令
      # " WHERE ",g_wc CLIPPED, " ORDER BY ima01"                  #FUN-A90049 mark
        " WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL) AND ",g_wc CLIPPED, " ORDER BY ima01" #FUN-A90049 add
    PREPARE aimi101_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE aimi101_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi101_prepare
    LET g_sql=
      # "SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED                     #FUN-A90049 mark
        "SELECT COUNT(*) FROM ima_file WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ",g_wc CLIPPED    #FUN-A90049 add
    PREPARE aimi101_precount FROM g_sql
    DECLARE aimi101_count CURSOR FOR aimi101_precount
END FUNCTION

FUNCTION aimi101_menu()
    DEFINE   l_cmd   LIKE type_file.chr1000#No.MOD-640541 #No.FUN-690026 VARCHAR(80)
    MENU ""

        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi101_q()
            END IF
        ON ACTION next
            CALL aimi101_fetch('N')
        ON ACTION previous
            CALL aimi101_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi101_u()
            END IF
        #CHI-A80017 mark --start--
        #ON ACTION carry_data
        #    LET g_action_choice="carry_data"
        #    IF cl_chk_act_auth() THEN
        #         CALL aimi101_dbs()
        #    END IF
        #CHI-A80017 mark --end--
        #CHI-A80017 add --start--
        ON ACTION carry #資料拋轉
           LET g_action_choice = "carry"
           IF cl_chk_act_auth() THEN
              CALL ui.Interface.refresh()
              CALL i101_carry()
           END IF

        ON ACTION qry_carry_history #資料拋轉歷史
           LET g_action_choice = "qry_carry_history"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_ima.ima01) THEN
                 IF NOT cl_null(g_ima.ima916) THEN
                    SELECT gev04 INTO g_gev04 FROM gev_file
                     WHERE gev01 = '1' AND gev02 = g_ima.ima916
                 ELSE      #歷史資料,即沒有ima916的值
                    SELECT gev04 INTO g_gev04 FROM gev_file
                     WHERE gev01 = '1' AND gev02 = g_plant
                 END IF
                 IF NOT cl_null(g_gev04) THEN
                    LET l_cmd='aooq604 "',g_gev04,'" "1" "',g_prog,'" "',g_ima.ima01,'"'
                    CALL cl_cmdrun(l_cmd)
                 END IF
              ELSE
                 CALL cl_err('',-400,0)
              END IF
           END IF
        #CHI-A80017 add --end--

        ON ACTION create_item
           LET g_action_choice="create_item"
           IF cl_chk_act_auth() THEN
              LET l_cmd = "aooi103 '",g_ima.ima01,"'"
              CALL cl_cmdrun_wait(l_cmd)
           END IF

        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
              THEN CALL aimi101_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #圖形顯示
           CALL i101_show_pic()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL aimi101_fetch('/')
        ON ACTION first
            CALL aimi101_fetch('F')
        ON ACTION last
            CALL aimi101_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

        ON ACTION related_document      #相關文件
           LET g_action_choice="related_document"
             IF cl_chk_act_auth() THEN
                IF g_ima.ima01 IS NOT NULL THEN
                   LET g_doc.column1 = "ima01"
                  LET g_doc.value1 = g_ima.ima01
                  CALL cl_doc()
              END IF
           END IF
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

      &include "qry_string.4gl"

    END MENU
    CLOSE aimi101_cs
END FUNCTION

#CHI-A80017 mark --start--
#FUNCTION aimi101_dbs()
#   DEFINE
#          l_ans      LIKE type_file.chr1,      #No.FUN-690026 VARCHAR(1)
#          l_str1     LIKE ze_file.ze03,        #No.FUN-690026 VARCHAR(28)
#          l_str2     LIKE ze_file.ze03,        #No.FUN-690026 VARCHAR(18),
#          l_plant    LIKE azp_file.azp01
#   DEFINE l_imaicd   RECORD LIKE imaicd_file.* #No.FUN-7B0018
#   LET l_ans = ' '
#   CALL cl_getmsg('mfg9138',g_lang) RETURNING l_str1
#   LET l_str1 = l_str1 CLIPPED
#   CALL cl_confirm('mfg9138') RETURNING l_ans
#    IF (l_zx07 = 'N') AND (l_ans=1) THEN #MOD-530276
#      CALL cl_err('','mfg9141',1)
#      RETURN
#   END IF
#   IF l_ans = '1' THEN            #MOD-5A0337
#
#	 DECLARE p_zx1_azp CURSOR FOR
#	 #SELECT UNIQUE azp03 FROM azp_file
#     SELECT UNIQUE azp03,azp01 FROM azp_file   #FUN-A50102
#          WHERE azp053 != 'N' #no.7431
#
#	 LET g_success='Y'
#	 #FOREACH p_zx1_azp INTO l_azp03
#     FOREACH p_zx1_azp INTO l_azp03,l_azp01  #FUN-A50102
#	    IF SQLCA.SQLCODE THEN
#         EXIT FOREACH
#      END IF
#      IF l_azp03 = l_dbs THEN
#         CONTINUE FOREACH
#      END IF
#            #LET g_sql="INSERT INTO ",s_dbstring(l_azp03 CLIPPED),"ima_file ",
#            #          " SELECT * FROM ",s_dbstring(l_dbs CLIPPED),"ima_file ",
#            LET g_sql="INSERT INTO ",cl_get_target_table(l_azp01,'ima_file'), #FUN-A50102
#                      " SELECT * FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#               " WHERE ima01 = ",
#               "'",g_ima.ima01,"'"
#       	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#	       PREPARE i_ima FROM g_sql
#	       EXECUTE i_ima
#	    IF SQLCA.sqlcode THEN
#             IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #NO.TQC-790093
#               #LET g_sql = "UPDATE ",s_dbstring(l_azp03 CLIPPED),"ima_file  SET ",  #TQC-940177
#               LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'ima_file'), #FUN-A50102
#                           "  SET ",  #TQC-940177
#                           "ima15 = '",g_ima.ima15,"',",
#                           "ima70 = '",g_ima.ima70,"',",
#                           "ima25 = '",g_ima.ima25,"',",
#                           "ima23 = '",g_ima.ima23,"',",
#                           "ima35 = '",g_ima.ima35,"',",
#                           "ima36 = '",g_ima.ima36,"',",
#                           "ima71 = '",g_ima.ima71,"',",
#                           "ima271 = ",g_ima.ima271,",",
#                           "ima27 = ",g_ima.ima27,",",
#                           "ima28 = ",g_ima.ima28,",",
#                           "ima63 = '",g_ima.ima63,"',",
#                           "ima64 = ",g_ima.ima64,",",
#                           "ima641 = ",g_ima.ima641,",",
#                           "ima63_fac = ",g_ima.ima63_fac,
#			                 		" WHERE ima01='",g_ima.ima01,"'"
#            	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#                 CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
#               PREPARE u_ima FROM g_sql
#               EXECUTE u_ima
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err(l_azp03,SQLCA.sqlcode,1)
#                  LET g_success = 'N'
#               ELSE
#                  MESSAGE l_azp03,' UPDATE ima_file O.K. '
#               END IF
#            ELSE
#               LET g_success='N'
#               CALL cl_err(l_azp03,'mfg7012',1)
#            END IF
#         ELSE
#            IF s_industry('icd') THEN               #No.FUN-830132 add
#               INITIALIZE l_imaicd.* TO NULL
#               LET l_imaicd.imaicd00 = g_ima.ima01
#               #IF NOT s_ins_imaicd(l_imaicd.*,l_azp03) THEN
#               IF NOT s_ins_imaicd(l_imaicd.*,l_azp01) THEN  #FUN-A50102
#                  LET g_success = 'N'
#               END IF
#            END IF
#          #LET g_sql='UPDATE ',s_dbstring(l_azp03 CLIPPED),'ima_file ',  #TQC-940177
#         LET g_sql='UPDATE ',cl_get_target_table(l_azp01,'ima_file'), #FUN-A50102
##                   ' SET ima26=0,',            #NO.FUN-A20044
##                       ' ima261=0,',           #NO.FUN-A20044
##                       ' ima262=0,',           #NO.FUN-A20044
##                        ' ima93="NNNNNNNN",',  #NO.FUN-A20044
#                    ' SET ima93="NNNNNNNN",',   #NO.FUN-A20044
#                        ' ima94="",',
#                        ' ima95=0,',
#                        ' ima99=0,',
#                        ' ima40=0,',
#                        ' ima41=0',
#                    ' WHERE ima01 = "',g_ima.ima01,'"' CLIPPED
#          CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
#          CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
#          PREPARE i_ima_upd FROM g_sql
#          IF STATUS THEN
#             CALL cl_err('',SQLCA.sqlcode,1)
#             LET g_success = 'N'
#          END IF
#          EXECUTE i_ima_upd
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err('',SQLCA.sqlcode,1)
#             LET g_success = 'N'
#          END IF
#         END IF
#      END FOREACH
#   ELSE
#      LET l_plant = ' '
#      CALL cl_getmsg('mfg9139',g_lang) RETURNING l_str2
#      LET l_str2 = l_str2 CLIPPED
#	WHILE TRUE
#            LET INT_FLAG = 0  ######add for prompt bug
#	   PROMPT l_str2 CLIPPED FOR l_plant
#	      ON IDLE g_idle_seconds
#	         CALL cl_on_idle()
#
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
#
#
#	   END PROMPT
#	   IF INT_FLAG THEN
#		 LET INT_FLAG=0
#		 RETURN
#	   END IF
#	   IF l_plant IS NULL OR l_plant=' ' THEN
#           CONTINUE WHILE
#        END IF
#         IF l_zx08 = l_plant THEN   #MOD-530276
#           CALL cl_err(l_plant,'mfg9143',1)
#        END IF
#	   SELECT azp03 INTO l_azp03 FROM azp_file
#		WHERE azp01=l_plant
#	   IF SQLCA.sqlcode THEN
#              CALL cl_err3("sel","azp_file",l_plant,"","mfg9142","","",1)  #No.FUN-660156
#		 CONTINUE WHILE
#	   END IF
#           #LET g_sql="INSERT INTO ",s_dbstring(l_azp03 CLIPPED),"ima_file ",
#           #          " SELECT * FROM ",s_dbstring(l_dbs CLIPPED),"ima_file ",
#           LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'ima_file'), #FUN-A50102
#                     " SELECT * FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#               " WHERE ima01 = ",
#               "'",g_ima.ima01,"'"
# 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#	   PREPARE i_ima1 FROM g_sql
#	   EXECUTE i_ima1
#	   IF SQLCA.sqlcode THEN
#           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093
#               #LET g_sql = "UPDATE ",s_dbstring(l_azp03 CLIPPED),"ima_file  SET ", #TQC-94017
#               LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'ima_file'), #FUN-A50102
#                           "   SET ",
#                           "ima15 = '",g_ima.ima15,"',",
#                           "ima70 = '",g_ima.ima70,"',",
#                           "ima25 = '",g_ima.ima25,"',",
#                           "ima23 = '",g_ima.ima23,"',",
#                           "ima35 = '",g_ima.ima35,"',",
#                           "ima36 = '",g_ima.ima36,"',",
#                           "ima71 = '",g_ima.ima71,"',",
#                           "ima271 = ",g_ima.ima271,",",
#                           "ima27 = ",g_ima.ima27,",",
#                           "ima28 = ",g_ima.ima28,",",
#                           "ima63 = '",g_ima.ima63,"',",
#                           "ima64 = ",g_ima.ima64,",",
#                           "ima641 = ",g_ima.ima641,",",
#                           "ima63_fac = ",g_ima.ima63_fac,
#					" WHERE ima01='",g_ima.ima01,"'"
# 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
#               PREPARE u_ima1 FROM g_sql
#               EXECUTE u_ima1
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err(l_azp03,SQLCA.sqlcode,1)
#                  LET g_success = 'N'
#               ELSE
#                  MESSAGE l_azp03,' UPDATE ima_file O.K. '
#               END IF
#           ELSE
#              LET g_success='N'
#              CALL cl_err(l_plant,'mfg7012',1)
#           END IF
#         ELSE
#            IF s_industry('icd') THEN               #No.FUN-830132 add
#               INITIALIZE l_imaicd.* TO NULL
#               LET l_imaicd.imaicd00 = g_ima.ima01
#               #IF NOT s_ins_imaicd(l_imaicd.*,l_azp03) THEN
#               IF NOT s_ins_imaicd(l_imaicd.*,l_plant) THEN  #FUN-A50102
#                  LET g_success = 'N'
#               END IF
#            END IF
#            MESSAGE l_plant,' Insert ima_file O.K. '
#          #LET g_sql='UPDATE ',s_dbstring(l_azp03 CLIPPED),'ima_file ', #TQC-940177
#          LET g_sql='UPDATE ',cl_get_target_table(l_plant,'ima_file'), #FUN-A50102
##                   ' SET ima26=0,',            #NO.FUN-A20044
##                       ' ima261=0,',           #NO.FUN-A20044
##                       ' ima262=0,',           #NO.FUN-A20044
##                        ' ima93="NNNNNNNN",',  #NO.FUN-A20044
#                    ' SET ima93="NNNNNNNN",',   #NO.FUN-A20044
#                        ' ima94="",',
#                        ' ima95=0,',
#                        ' ima99=0,',
#                        ' ima40=0,',
#                        ' ima41=0',
#                    ' WHERE ima01 = "',g_ima.ima01,'"' CLIPPED
#          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
#          CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql      #FUN-A50102
#          PREPARE i_ima_upd1 FROM g_sql
#          IF STATUS THEN
#             CALL cl_err('',SQLCA.sqlcode,1)
#             LET g_success = 'N'
#          END IF
#          EXECUTE i_ima_upd1
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err('',SQLCA.sqlcode,1)
#             LET g_success = 'N'
#          END IF
#         END IF
#      END WHILE
#   END IF
#
#
#END FUNCTION
#CHI-A80017 mark --end--
#CHI-A80017 add --start--
FUNCTION i101_carry()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_gew03   LIKE gew_file.gew03

   IF cl_null(g_ima.ima01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_ima.imaacti <> 'Y' THEN
      CALL cl_err(g_ima.ima01,'aoo-090',1)
      RETURN
   END IF

   SELECT ima1010 INTO g_ima.ima1010
     FROM ima_file
    WHERE ima01 = g_ima.ima01
   IF g_ima.ima1010 <> '1' THEN
      CALL cl_err(g_ima.ima01,'aoo-092',3)
      RETURN
   END IF

   #input data center
   LET g_gev04 = NULL

   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file
    WHERE gev01 = '1' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF

   IF cl_null(g_gev04) THEN RETURN END IF

   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
    WHERE gew01 = g_gev04 AND gew02 = '1'
   IF NOT cl_null(l_gew03) THEN
      IF l_gew03 = '2' THEN
          IF NOT cl_confirm('anm-929') THEN RETURN END IF  #詢問是否執行拋轉
      END IF
      #開窗選擇拋轉的db清單
      LET l_sql = "SELECT COUNT(*) FROM &ima_file WHERE ima01='",g_ima.ima01,"'"
      CALL s_dc_sel_db1(g_gev04,'1',l_sql)
      IF INT_FLAG THEN
         LET INT_FLAG=0
         RETURN
      END IF

      CALL g_imax.clear()
      LET g_imax[1].sel = 'Y'
      LET g_imax[1].ima01 = g_ima.ima01
      FOR l_i = 1 TO g_azp1.getLength()
          LET g_azp[l_i].sel   = g_azp1[l_i].sel
          LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
          LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
          LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
      END FOR

      CALL s_showmsg_init()
      CALL s_aimi100_carry(g_imax,g_azp,g_gev04,'0')
      CALL s_showmsg()
   END IF

END FUNCTION
#CHI-A80017 add --end--

FUNCTION aimi101_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #是否必要欄位有輸入  #No.FUN-690026 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(80)
        l_gen02         LIKE gen_file.gen02,
        l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_case      STRING   #No.FUN-BB0086 add
   DEFINE   l_imd10     LIKE imd_file.imd10   #FUN-CB0052

    IF s_shut(0) THEN RETURN END IF
    DISPLAY BY NAME g_ima.imauser,g_ima.imagrup,
        g_ima.imadate, g_ima.imaacti
#   LET g_d2=g_ima.ima262-g_ima.ima26                       #NO.FUN-A20044
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
    LET g_d2=l_n3-l_n1                                      #NO.FUN-A20044
    DISPLAY g_d2 TO FORMONLY.d2
    DISPLAY g_s TO FORMONLY.s
    DISPLAY l_n1 TO FORMONLY.avl_stk_mpsmrp   #NO.FUN-A20044
    DISPLAY l_n2 TO FORMONLY.unavl_stk        #NO.FUN-A20044
    DISPLAY l_n3 TO FORMONLY.avl_stk          #NO.FUN-A20044
    INPUT BY NAME
        g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima08,g_ima.ima05,g_ima.ima25,g_ima.ima04,
        g_ima.ima03,g_ima.ima07,g_ima.ima15,g_ima.ima70,g_ima.ima23,g_ima.ima35,g_ima.ima36,
        g_ima.ima71,g_ima.ima271,g_ima.ima27,g_ima.ima28,g_ima.ima63,g_ima.ima63_fac,g_ima.ima64,g_ima.ima641,
#       g_ima.ima26,g_ima.ima262,g_ima.ima261,g_ima.ima29,g_ima.ima30,g_ima.ima73,g_ima.ima74,g_ima.ima902,
        g_ima.ima29,g_ima.ima30,g_ima.ima73,g_ima.ima74,g_ima.ima902,
        g_ima.imauser, g_ima.imagrup,g_ima.imamodu, g_ima.imadate, g_ima.imaacti
        WITHOUT DEFAULTS

        BEFORE INPUT
             LET g_before_input_done = FALSE
             CALL i101_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE
             #No.FUN-BB0086--add--start--
             IF p_cmd = 'u' THEN 
                LET g_ima25_t = g_ima.ima25   
                LET g_ima63_t = g_ima.ima63   
             END IF    
             IF p_cmd = 'a' THEN 
                LET g_ima25_t = NULL 
                LET g_ima63_t = NULL 
             END IF 
             #No.FUN-BB0086--add--end--

        AFTER FIELD ima07  #ABC碼
            IF g_ima.ima07 NOT MATCHES "[ABC]" THEN #genero
               CALL cl_err(g_ima.ima07,'mfg1002',0)
               LET g_ima.ima07 = g_ima_o.ima07
               DISPLAY BY NAME g_ima.ima07
               NEXT FIELD ima07
            END IF
            LET g_ima_o.ima07 = g_ima.ima07

        AFTER FIELD ima15  #保稅料件
            IF g_ima.ima15 NOT MATCHES "[YN]" THEN #genero
               CALL cl_err(g_ima.ima15,'mfg1002',0)
               LET g_ima.ima15 = g_ima_o.ima15
               DISPLAY BY NAME g_ima.ima15
               NEXT FIELD ima15
            END IF
            LET g_ima_o.ima15 = g_ima.ima15

#@@@@@可使為消耗性料件 1.多倉儲管理(sma12 = 'y')
#@@@@@                 2.使用製程(sma54 = 'y')
        AFTER FIELD ima70  #消耗料件
            IF g_ima.ima70 NOT MATCHES "[YN]" THEN #genero
               CALL cl_err(g_ima.ima70,'mfg1002',0)
               LET g_ima.ima70 = g_ima_o.ima70
               DISPLAY BY NAME g_ima.ima70
               NEXT FIELD ima70
            END IF
            IF (g_ima_o.ima70 IS NULL) OR (g_ima_t.ima70 IS NULL)
                  OR (g_ima.ima70 != g_ima_o.ima70)
              THEN IF g_ima.ima70 NOT MATCHES "[YN]" THEN #genero
                                   #OR g_ima.ima70 IS NULL THEN
                        CALL cl_err(g_ima.ima70,'mfg1002',0)
                        LET g_ima.ima70 = g_ima_o.ima70
                        DISPLAY BY NAME g_ima.ima70
                        NEXT FIELD ima70
                    END IF
            END IF
            LET g_ima_o.ima70 = g_ima.ima70

        AFTER FIELD ima25            #庫存單位
            IF  NOT cl_null(g_ima.ima25) THEN
                IF (g_ima_o.ima25 IS NULL) OR (g_ima_o.ima25 != g_ima.ima25)
                     THEN SELECT gfe01 FROM gfe_file
                           WHERE gfe01=g_ima.ima25 AND gfeacti IN ('y','Y')
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("sel","gfe_file",g_ima.ima25,"",
                                     "mfg1200","","",1)  #No.FUN-660156
                        LET g_ima.ima25 = g_ima_o.ima25
                        DISPLAY BY NAME g_ima.ima25
                        NEXT FIELD ima25
                     END IF
                   LET g_ima.ima86 = g_ima.ima25      #MOD-870312
                   LET g_ima.ima86_fac = 1            #MOD-870312
                 END IF
                 #No.FUN-BB0086--add--start--
                    LET l_case = ""
                    IF NOT i101_ima27_check() THEN 
                       LET l_case = "ima27"
                    END IF 
                    IF NOT i101_ima271_check() THEN 
                       LET l_case = "ima271"
                    END IF 
                    IF NOT i101_ima28_check() THEN 
                       LET l_case = "ima28"
                    END IF 
                    LET g_ima25_t = g_ima.ima25
                    LET g_ima_o.ima25 = g_ima.ima25
                    CASE l_case 
                       WHEN 'ima27'
                          NEXT FIELD ima27
                       WHEN 'ima271'
                          NEXT FIELD ima271
                       WHEN 'ima28'
                          NEXT FIELD ima28
                       OTHERWISE EXIT CASE 
                    END CASE    
                 #No.FUN-BB0086--add--end--
            END IF
            LET g_ima_o.ima25 = g_ima.ima25

        AFTER FIELD ima23            #倉管員
            IF g_ima.ima23 IS NOT NULL THEN
               IF (g_ima_o.ima23 IS NULL) or (g_ima.ima23 != g_ima_o.ima23) THEN
                  CALL aimi101_peo(g_ima.ima23,'a')
                  IF g_chr = 'E' THEN
                     CALL cl_err(g_ima.ima23,'mfg3096',0)
                     LET g_ima.ima23 = g_ima_o.ima23
                     DISPLAY BY NAME g_ima.ima23
                     NEXT FIELD ima23
                  END IF
               END IF
            ELSE LET l_gen02 = NULL
                 DISPLAY l_gen02 TO gen02
            END IF
            LET g_ima_o.ima23 = g_ima.ima23

#單倉時;(MAY APPEND)
        BEFORE FIELD ima35
            IF g_sma.sma12 MATCHES '[Nn]' THEN
            END IF

        #倉庫別與儲位別在 AFTER INPUT 時,才判斷是否為NULL
        #因為若此倉庫無儲位時,必須讓使用者可以回到倉庫別輸入,而不一定得
        #打一個無用的儲位
        AFTER FIELD ima35  #倉庫別
        IF g_ima.ima35 IS NULL OR g_ima.ima35 = ' ' THEN
           LET  g_ima.ima35  = ' '
           LET g_ima.ima36 = ' '
           DISPLAY BY NAME g_ima.ima36
        ELSE
            IF  g_ima.ima35 IS NOT NULL THEN
               IF (g_ima_o.ima35 IS NULL OR g_ima_o.ima35 = ' ')
                   OR (g_ima.ima35 != g_ima_o.ima35)
                    THEN
                       IF NOT s_stkchk(g_ima.ima35,'A') THEN
                           CALL cl_err(g_ima.ima35,'mfg1100',0)
                           LET g_ima.ima35 = g_ima_o.ima35
                           DISPLAY BY NAME g_ima.ima35
                           NEXT FIELD ima35
                       END IF
                END IF
                #FUN-CB0052--add--str--
                SELECT imd10 INTO l_imd10 FROM imd_file
                 WHERE imd01 = g_ima.ima35 AND imdacti='Y'
                IF l_imd10 MATCHES '[Ii]' THEN
                   CALL cl_err(l_imd10,'axm-693',0)
                   NEXT FIELD ima35
                END IF
                #FUN-CB0052--add--end--
            END IF
            LET g_ima_o.ima35 = g_ima.ima35
          END IF

#單倉時;(MAY APPEND)
        BEFORE  FIELD ima36
            IF g_sma.sma12 MATCHES '[Nn]' THEN
            END IF
        AFTER FIELD ima36  #儲位別
{&}     IF g_ima.ima36 IS NULL THEN LET  g_ima.ima36  = ' '  END IF
            IF  g_ima.ima36 IS NOT NULL and g_ima.ima36 !=' '  THEN
               IF (g_ima_o.ima36 IS NULL OR g_ima_o.ima36 = ' ')
                  OR (g_ima.ima36 != g_ima_o.ima36)
                     THEN
                        CALL s_prechk(g_ima.ima01,g_ima.ima35,g_ima.ima36)
                                            RETURNING g_cnt,g_chr
                        IF NOT g_cnt THEN
                            CALL cl_err(g_ima.ima36,'mfg1102',0)
                            NEXT FIELD ima35
                        END IF
                 END IF
            END IF
            LET g_ima_o.ima36 = g_ima.ima36

        AFTER FIELD ima71 #儲存有效天數
            IF g_ima.ima71 < 0 #genero
               THEN CALL cl_err(g_ima.ima71,'mfg0013',0)
                    LET g_ima.ima71 = g_ima_o.ima71
                    DISPLAY BY NAME g_ima.ima71
                    NEXT FIELD ima71
            END IF
            LET g_ima_o.ima71 = g_ima.ima71

        AFTER FIELD ima271
           IF NOT i101_ima271_check()  THEN NEXT FIELD ima271 END IF #FUN-BB0086--add--
           #FUN-BB0086--mark--start--
           # IF g_ima.ima271 < 0 #genero
           # THEN
           #    CALL cl_err(g_ima.ima271,'mfg0013',0)
           #    LET g_ima.ima271 = g_ima_o.ima271
           #    DISPLAY BY NAME g_ima.ima271
           #    NEXT FIELD ima271
           # END IF
           #FUN-BB0086--mark--end--

        AFTER FIELD ima27
           IF NOT i101_ima27_check()  THEN NEXT FIELD ima27 END IF #FUN-BB0086--add--
        #FUN-BB0086--mark--start--
        #    IF g_ima.ima27 < 0 #genero
        #       THEN  CALL cl_err(g_ima.ima27,'mfg0013',0)
        #             LET g_ima.ima27 = g_ima_o.ima27
        #             DISPLAY BY NAME g_ima.ima27
        #             NEXT FIELD ima27
        #    END IF
        #    LET g_ima_o.ima27 = g_ima.ima27
        #FUN-BB0086--mark--end--

        AFTER FIELD ima28
           IF NOT i101_ima28_check() THEN NEXT FIELD ima28 END IF   #No.FUN-BB0086
           #No.FUN-BB0086---mark---start---
           # IF g_ima.ima28 < 0 #genero
           #    THEN CALL cl_err(g_ima.ima28,'mfg0013',0)
           #          LET g_ima.ima28 = g_ima_o.ima28
           #          DISPLAY BY NAME g_ima.ima28
           #         NEXT FIELD ima28
           # END IF
           # LET g_ima_o.ima28 = g_ima.ima28
           #No.FUN-BB0086---mark---end--- 

        BEFORE FIELD ima63           #發料單位=NULL時, Default 庫存單位
            IF g_ima_o.ima63 IS NULL AND g_ima.ima63 IS NULL THEN
               LET g_ima.ima63=g_ima.ima25
               LET g_ima_o.ima63=g_ima.ima25
               LET g_ima.ima63_fac   = 1        #No:MOD-9B0127 add
               LET g_ima_o.ima63_fac = 1        #No:MOD-9B0127 add
               DISPLAY BY NAME g_ima.ima63_fac  #No:MOD-9B0127 add
               DISPLAY BY NAME g_ima.ima63
            END IF

        AFTER FIELD ima63           #發料單位
#輸入時，若為空白，則預設值為庫存單位。
            IF g_ima.ima63 IS NULL
               THEN LET g_ima.ima63=g_ima.ima25
                    DISPLAY BY NAME g_ima.ima63
            END IF
            IF  g_ima.ima63 IS NULL
              THEN LET g_ima.ima63 = g_ima_o.ima63
                   DISPLAY BY NAME g_ima.ima63
            END IF
            IF (g_ima.ima63 != g_ima_o.ima63) #genero
              THEN SELECT gfe01
                     FROM gfe_file WHERE gfe01=g_ima.ima63 AND
                                         gfeacti IN ('Y','y')
                   IF SQLCA.sqlcode  THEN
                      CALL cl_err3("sel","gfe_file",g_ima.ima63,"",
                                   "mfg1326","","",1)  #No.FUN-660156
                      LET g_ima.ima63 = g_ima_o.ima63
                      DISPLAY BY NAME g_ima.ima63
                      NEXT FIELD ima63
                   ELSE IF g_ima.ima63 = g_ima.ima25
                        THEN LET g_ima.ima63_fac = 1
                        ELSE CALL s_umfchk(g_ima.ima01,g_ima.ima63,
                                           g_ima.ima25)
                             RETURNING g_sw,g_ima.ima63_fac
                             IF g_sw = '1' THEN
                                CALL cl_err(g_ima.ima63,'mfg1206',0)
                                LET g_ima.ima63 = g_ima_o.ima63
                                DISPLAY BY NAME g_ima.ima63
                                LET g_ima.ima63_fac = g_ima_o.ima63_fac
                                DISPLAY BY NAME g_ima.ima63_fac
                                NEXT FIELD ima63
                             END IF
                            END IF
                       DISPLAY BY NAME g_ima.ima63_fac
                  END IF
            END IF
            LET g_ima_o.ima63 = g_ima.ima63
            LET g_ima_o.ima63_fac = g_ima.ima63_fac
            #FUN-BB0086---add---start
            LET l_case = ""
            IF NOT i101_ima64_check() THEN
               LET l_case = "ima64"
            END IF

            IF NOT i101_ima641_check() THEN
               LET l_case = "ima641"
            END IF
            LET g_ima63_t = g_ima.ima63
            CASE l_case
               WHEN "ima64"
                  NEXT FIELD ima64
               WHEN "ima641"
                  NEXT FIELD ima641
               OTHERWISE EXIT CASE
            END CASE
            #FUN-BB0086---add---end     

        BEFORE FIELD ima63_fac
#為防本來已有生產單位與單位相同,而轉換率尚無值 MAY
            IF g_ima.ima25 = g_ima.ima63 THEN
               LET g_ima.ima63_fac = 1
            END IF

        AFTER FIELD ima63_fac
            IF g_ima.ima63_fac <= 0 THEN #genero
                CALL cl_err(g_ima.ima63_fac,'mfg1322',0)
                LET g_ima.ima63_fac = g_ima_o.ima63_fac
                DISPLAY BY NAME g_ima.ima63_fac
                NEXT FIELD ima63_fac
            END IF
            LET g_ima_o.ima63_fac = g_ima.ima63_fac

        AFTER FIELD ima64          #發料單位批數
           IF NOT i101_ima64_check()  THEN NEXT FIELD ima64 END IF #FUN-BB0086--add--
        #No.FUN-BB0086---start---mark---
        #   IF g_ima.ima64 < 0 #genero
        #   THEN CALL cl_err(g_ima.ima64,'mfg0013',0)
        #      LET g_ima.ima64 = g_ima_o.ima64
        #      DISPLAY BY NAME g_ima.ima64
        #      NEXT FIELD ima64
        #   END IF
        #   LET g_ima_o.ima64 = g_ima.ima64
        #   RETURN TRUE
        #No.FUN-BB0086---end---mark---


        AFTER FIELD ima641          #最少發料數量
           IF NOT i101_ima641_check()  THEN NEXT FIELD ima641 END IF #FUN-BB0086--add--  
           #No.FUN-BB0086---start---mark---
           #  IF g_ima.ima641 IS NULL OR g_ima.ima641 = ' '
           #     THEN LET g_ima.ima641=0
           #  END IF
           #  IF  g_ima.ima641 < 0
           #     THEN CALL cl_err(g_ima.ima641,'mfg0013',0)
           #          LET g_ima.ima641 = g_ima_o.ima641
           #          DISPLAY BY NAME g_ima.ima641
           #          NEXT FIELD ima641
           #  END IF
           #  IF g_ima.ima64 >1 AND  g_ima.ima641 >0
           #     THEN
           #         IF (g_ima.ima641 mod g_ima.ima64) != 0 THEN
           #                   CALL aimi101_size()
           #         END IF
           #  END IF
           # LET g_ima_o.ima641 = g_ima.ima641
           #No.FUN-BB0086---start---mark---

        AFTER INPUT
           LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
           LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_ima.ima01 IS NULL THEN  #料件編號
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima01
            END IF
            IF g_ima.ima70 NOT MATCHES "[YN]" OR g_ima.ima70 IS NULL THEN
               LET l_flag='Y'   #消耗料件
               DISPLAY BY NAME g_ima.ima70
            END IF
            IF g_ima.ima15 NOT MATCHES "[YN]" OR g_ima.ima15 IS NULL THEN
               LET l_flag='Y'   #保稅料件
               DISPLAY BY NAME g_ima.ima14
            END IF
            IF g_ima.ima25 IS NULL THEN  #庫存單位
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima25
            END IF
            IF g_ima.ima271 IS NULL THEN
               LET l_flag='Y'  #最高儲存數量
               DISPLAY BY NAME g_ima.ima271
            END IF
            IF g_ima.ima27 IS NULL THEN
               LET l_flag='Y'  #安全存量
               DISPLAY BY NAME g_ima.ima27
            END IF
            IF g_ima.ima28 IS NULL THEN
               LET l_flag='Y'  #安全期間
               DISPLAY BY NAME g_ima.ima28
            END IF
            IF g_ima.ima63 IS NULL THEN  #發料單位
               LET g_ima.ima63=g_ima.ima25
               #No.FUN-BB0086--add--start--
               LET g_ima.ima64 = s_digqty(g_ima.ima64,g_ima.ima63)
               LET g_ima.ima641 = s_digqty(g_ima.ima641,g_ima.ima63)
               DISPLAY BY NAME g_ima.ima64,g_ima.ima641
               #No.FUN-BB0086--add--end--
               DISPLAY BY NAME g_ima.ima63
            END IF
            IF g_ima.ima63_fac IS NULL OR g_ima.ima63_fac <=0  THEN  #發料批量
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima63_fac
            END IF
            IF g_ima.ima64 IS NULL  THEN  #發料批量
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima64
            END IF
            IF g_ima.ima641 IS NULL THEN  #發料數量
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima641
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ima15
            END IF

        ON ACTION controlp
            CASE
               WHEN INFIELD(ima23) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_ima.ima23
                 CALL cl_create_qry() RETURNING g_ima.ima23
                  DISPLAY BY NAME g_ima.ima23
                  CALL aimi101_peo(g_ima.ima23,'d')
                  NEXT FIELD ima23
               WHEN INFIELD(ima25) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_ima.ima25
                 CALL cl_create_qry() RETURNING g_ima.ima25
                  DISPLAY BY NAME g_ima.ima25
                  NEXT FIELD ima25
               WHEN INFIELD (ima35) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imd"
                  LET g_qryparam.default1 = g_ima.ima35 #MOD-4A0213
                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                 CALL cl_create_qry() RETURNING g_ima.ima35
                  DISPLAY BY NAME g_ima.ima35
                  NEXT FIELD ima35
               WHEN INFIELD (ima36) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ime"
                  LET g_qryparam.default1 = g_ima.ima36 #MOD-4A0063
                  LET g_qryparam.arg1     = g_ima.ima35 #倉庫編號 #MOD-4A0063
                  LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
                 CALL cl_create_qry() RETURNING g_ima.ima36
                  DISPLAY BY NAME g_ima.ima36
                  NEXT FIELD ima36
               WHEN INFIELD(ima63)                       #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_ima.ima63
                 CALL cl_create_qry() RETURNING g_ima.ima63
                  DISPLAY BY NAME g_ima.ima63
                  NEXT FIELD ima63
               OTHERWISE EXIT CASE
            END CASE

        ON ACTION create_unit
           CALL cl_cmdrun("aooi101 ")

        ON ACTION create_warehouse
           LET l_cmd = 'aimi200'
           CALL cl_cmdrun(l_cmd)

        ON ACTION create_location
           LET l_cmd = "aimi201 '",g_ima.ima35,"'" #BugNo:6598
           CALL cl_cmdrun(l_cmd)

        ON ACTION unit_conversion
           CALL cl_cmdrun("aooi102 ")

   ON ACTION CONTROLR
      CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION

FUNCTION aimi101_size()  #檢查發料數量是否為發料批量之倍數及建議發料數量
DEFINE
        l_count         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_ima641        LIKE ima_file.ima641
      LET l_count = g_ima.ima641 MOD g_ima.ima64
      IF l_count != 0 THEN
        LET l_count = g_ima.ima641/ g_ima.ima64
        LET l_ima641 = ( l_count + 1 ) * g_ima.ima64
        CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
        WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
           PROMPT g_msg CLIPPED,'(',l_ima641,')',':' FOR g_chr
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


           END PROMPT
           IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
        END WHILE
       IF g_chr ='Y' OR g_chr = 'y'  THEN
         LET g_ima.ima641 = l_ima641
       END IF
     DISPLAY BY NAME g_ima.ima64   #No.FUN-BB0086
     DISPLAY BY NAME g_ima.ima641
   END IF
   LET g_chr = NULL
END FUNCTION

FUNCTION aimi101_peo(p_key,p_cmd)    #人員
    DEFINE p_key     LIKE gen_file.gen01,
           p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti

    LET g_chr = ' '
    IF p_key IS NULL THEN
        LET l_gen02=NULL
        LET g_chr = 'E'
    ELSE SELECT gen02,genacti INTO l_gen02,l_genacti
           FROM gen_file
               WHERE gen01 = p_key
            IF SQLCA.sqlcode THEN
                LET g_chr = 'E'
                LET l_gen02 = NULL
            ELSE
                IF l_genacti matches'[Nn]' THEN
                    LET g_chr = 'E'
                END IF
            END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
       THEN DISPLAY l_gen02 TO gen02
  END IF
END FUNCTION

FUNCTION aimi101_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi101_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi101_count
    FETCH aimi101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL
    ELSE
        CALL aimi101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION aimi101_fetch(p_flima)
    DEFINE
        p_flima          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)

    CASE p_flima
        WHEN 'N' FETCH NEXT     aimi101_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS aimi101_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    aimi101_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     aimi101_cs INTO g_ima.ima01
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
            FETCH ABSOLUTE g_jump aimi101_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flima
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",
                     SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_ima.imauser #FUN-4C0053
        LET g_data_group = g_ima.imagrup #FUN-4C0053
        CALL aimi101_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION aimi101_show()
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044

    LET g_ima_t.* = g_ima.*

#   LET g_d2=g_ima.ima262-g_ima.ima26
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
    LET g_d2=l_n3-l_n1                                      #NO.FUN-A20044
    LET g_s=g_ima.ima93[1,1]
    DISPLAY g_d2 TO FORMONLY.d2
    DISPLAY g_s TO FORMONLY.s
    DISPLAY l_n1 TO FORMONLY.avl_stk_mpsmrp   #NO.FUN-A20044
    DISPLAY l_n2 TO FORMONLY.unavl_stk        #NO.FUN-A20044
    DISPLAY l_n3 TO FORMONLY.avl_stk          #NO.FUN-A20044
    DISPLAY BY NAME
        g_ima.ima01, g_ima.ima05, g_ima.ima08, g_ima.ima02, g_ima.ima021,
         g_ima.ima03,g_ima.ima04,      #No.MOD-550085
#       g_ima.ima07, g_ima.ima15, g_ima.ima70, g_ima.ima25, g_ima.ima26,  #NO.FUN-A20044
#       g_ima.ima262,g_ima.ima261,g_ima.ima23, g_ima.ima35, g_ima.ima36,  #NO.FUN-A20044
        g_ima.ima07, g_ima.ima15, g_ima.ima70, g_ima.ima25,               #NO.FUN-A20044
        g_ima.ima23, g_ima.ima35, g_ima.ima36,                            #NO.FUN-A20044
        g_ima.ima902,
        g_ima.ima71, g_ima.ima271,g_ima.ima27, g_ima.ima28, g_ima.ima29,
        g_ima.ima30, g_ima.ima73, g_ima.ima74,
        g_ima.ima63, g_ima.ima63_fac,g_ima.ima64, g_ima.ima641,
        g_ima.imauser, g_ima.imagrup, g_ima.imamodu, g_ima.imadate,
        g_ima.imaacti
        CALL aimi101_peo(g_ima.ima23,'d')
        LET g_doc.column1 = "ima01"
        LET g_doc.value1 = g_ima.ima01
        CALL cl_get_fld_doc("ima04")

        CALL i101_show_pic()

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION aimi101_u()
    DEFINE l_ima   RECORD  LIKE ima_file.*             #FUN-B80032
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ima.ima01,'mfg1000',0)
        RETURN
    END IF

#FUN-B90102----add--begin---- 服飾行業，子料件不可更改
    IF s_industry('slk') THEN
       IF g_ima.ima151='N' AND g_ima.imaag='@CHILD' THEN
          CALL cl_err(g_ima.ima01,'axm_665',1)
          RETURN
       END IF
    END IF
#FUN-B90102----add--end---

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ima01_t = g_ima.ima01
    LET g_ima_o.* = g_ima.*
    BEGIN WORK

    OPEN aimi101_curl USING g_ima.ima01
    IF STATUS THEN
       CALL cl_err("OPEN aimi101_curl:", STATUS, 1)
       CLOSE aimi101_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi101_curl INTO g_ima.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_ima.imamodu=g_user                     #修改者
    LET g_ima.imadate = g_today                  #修改日期
    CALL aimi101_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi101_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ima_t.imadate=g_ima_o.imadate        #TQC-C40219
            LET g_ima_t.imamodu=g_ima_o.imamodu        #TQC-C40219
            LET g_ima.*=g_ima_t.*         #TQC-C40155  #TQC-C40219
           #LET g_ima.*=g_ima_o.*         #TQC-C40155  #TQC-C40219
            CALL aimi101_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_ima.ima93[1,1] = 'Y'
{&}     IF g_ima.ima35 IS NULL THEN LET  g_ima.ima35  = ' '  END IF
{&}     IF g_ima.ima36 IS NULL THEN LET  g_ima.ima36  = ' '  END IF
        IF cl_null(g_ima.ima25) THEN CONTINUE WHILE END IF
        IF cl_null(g_ima.ima63) THEN
           LET g_ima.ima63=g_ima.ima25
           #No.FUN-BB0086--add--start--
           LET g_ima.ima64 = s_digqty(g_ima.ima64,g_ima.ima63)
           LET g_ima.ima641 = s_digqty(g_ima.ima641,g_ima.ima63)
           DISPLAY BY NAME g_ima.ima64,g_ima.ima641
           #No.FUN-BB0086--add--end--
           LET g_ima.ima63_fac=1
        END IF
#       IF cl_null(g_ima.ima26)  THEN LET g_ima.ima26=0  END IF   #NO.FUN-A20044
#       IF cl_null(g_ima.ima261) THEN LET g_ima.ima261=0 END IF   #NO.FUN-A20044
#       IF cl_null(g_ima.ima262) THEN LET g_ima.ima262=0 END IF   #NO.FUN-A20044
        IF cl_null(g_ima.ima27)  THEN LET g_ima.ima27=0  END IF
        IF cl_null(g_ima.ima271) THEN LET g_ima.ima271=0 END IF
        IF cl_null(g_ima.ima28)  THEN LET g_ima.ima28=0  END IF
        IF cl_null(g_ima.ima64)  THEN LET g_ima.ima64=0  END IF
        IF cl_null(g_ima.ima641) THEN LET g_ima.ima641=0 END IF
      #FUN-B80032---------STA-------
       SELECT * INTO l_ima.*
         FROM ima_file
        WHERE ima01 = g_ima.ima01
        IF l_ima.ima02 <> g_ima.ima02 OR l_ima.ima021 <> g_ima.ima021
           OR l_ima.ima25 <> g_ima.ima25 THEN
           IF g_aza.aza88 = 'Y' THEN
              UPDATE rte_file SET rtepos = '2' WHERE rte03 = g_ima.ima01 AND rtepos = '3'
           END IF
        END IF
      #FUN-B80032---------END-------
        UPDATE ima_file SET ima_file.* = g_ima.*    # 更新DB
         WHERE ima01 = g_ima.ima01                  # COLAUTH?
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","ima_file",g_ima01_t,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        ELSE
#No.FUN-A50011 ---begin---
#MOD-AC0161 -------mod start------------
#FUN-B90102-------MARK----BEGIN--------
#            IF s_industry('slk') THEN
#               IF g_ima.ima151 = 'Y' THEN
#                  CALL s_upd_ima_subparts(g_ima.ima01)
#               END IF
#            END IF
#FUN-B90102-------MARK-----END------
#MOD-AC0161 -------mod end-----------------
#No.FUN-A50011  ---end---
            IF g_ima01_t != g_ima.ima01 THEN
                UPDATE imb_file SET imb_file.imb01 = g_ima.ima01    # 更新DB
                     WHERE imb01=g_ima01_t                          # COLAUTH?
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","imb_file",g_ima01_t,"",
                                  SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 END IF
             END IF
             display 'Y' TO formonly.s
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aimi101_curl

#FUN-B90102----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
   IF s_industry('slk') THEN
      IF g_ima.ima151='Y' THEN
         CALL i101_ins_ima()
      END IF
   END IF
#FUN-B90102----add--end---

    COMMIT WORK   #No.+205 mark 拿掉
END FUNCTION

#FUN-B90102----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
FUNCTION i101_ins_ima()

   UPDATE ima_file set
                      ima08=g_ima.ima08,ima05=g_ima.ima05,
                      ima04=g_ima.ima04,ima03=g_ima.ima03,
                      ima25=g_ima.ima25,ima07=g_ima.ima07,ima15=g_ima.ima15,
                      ima70=g_ima.ima70,ima23=g_ima.ima23,ima35=g_ima.ima35,
                      ima36=g_ima.ima36,ima71=g_ima.ima71,ima271=g_ima.ima271,
                      ima27=g_ima.ima27,ima28=g_ima.ima28,ima63=g_ima.ima63,ima63_fac=g_ima.ima63_fac,
                      ima64=g_ima.ima64,ima641=g_ima.ima641,ima29=g_ima.ima29,ima30=g_ima.ima30,
                      ima73=g_ima.ima73,ima74=g_ima.ima74,ima902=g_ima.ima902,
                      imamodu=g_ima.imamodu,imadate=g_ima.imadate
   WHERE ima01 in (SELECT imx000 FROM imx_file WHERE imx00=g_ima.ima01)


END FUNCTION
#FUN-B90102----add--end---

FUNCTION aimi101_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        sr              RECORD LIKE ima_file.*,
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)

    CALL cl_del_data(l_table)      #No.FUN-840019
    IF cl_null(g_wc) THEN
        LET g_wc=" ima01='",g_ima.ima01,"'"
    END IF
    CALL cl_wait()
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimi101'  #No.FUN-840019
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM ima_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE aimi101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE aimi101_curo                         # CURSOR
        CURSOR FOR aimi101_p1


    FOREACH aimi101_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        EXECUTE insert_prep USING
            sr.imaacti,sr.ima01,sr.ima02,sr.ima05,sr.ima08,sr.ima25,sr.ima021
    END FOREACH

    CLOSE aimi101_curo
    ERROR ""
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

    IF g_zz05 = 'Y'  THEN
       CALL cl_wcchp(g_wc,'ima01,ima02,ima021,ima08,ima05,ima25,ima04,
                     ima03,ima07,ima15,ima70,ima23,ima35,ima36,
                     ima71,ima271,ima27,ima28,ima63,ima63_fac,ima64,ima641,
#                    ima26,ima262,ima261,ima29,ima30,ima73,ima74,ima902,   #NO.FUN-A20044
                     ima29,ima30,ima73,ima74,ima902,                       #NO.FUN-A20044
                     imauser, imagrup, imamodu, imadate, imaacti')
       RETURNING  g_str
    END IF
    CALL cl_prt_cs3('aimi101','aimi101',l_sql,g_str)

END FUNCTION

FUNCTION i101_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  DEFINE l_errno STRING
    IF p_cmd='a' THEN
      CALL cl_set_comp_entry("ima25",TRUE)
    END IF

    IF p_cmd='u' THEN
      CALL s_chkitmdel(g_ima.ima01) RETURNING l_errno
      CALL cl_set_comp_entry("ima25",cl_null(l_errno))  #有errmsg表示庫存單位不可修改
    END IF
IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ima01",FALSE)
   END IF
END FUNCTION

FUNCTION i101_show_pic()

     LET g_chr='N'
     IF g_ima.ima1010='1' THEN
        LET g_chr='Y'
     END IF
     CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,""  ,g_ima.imaacti,""    ,"")
                           #確認 ,核准,過帳,結案,作廢,有效         ,申請  ,留置
     #圖形顯示
END FUNCTION
#No.FUN-9C0072 精簡程式碼

#No.FUN-BB0086---start---add---
FUNCTION i101_ima27_check()
   IF NOT cl_null(g_ima.ima27) AND NOT cl_null(g_ima.ima25) THEN
      IF cl_null(g_ima.ima27) OR cl_null(g_ima25_t) OR g_ima_t.ima27 != g_ima.ima27 OR g_ima25_t != g_ima.ima25 THEN
         LET g_ima.ima27=s_digqty(g_ima.ima27, g_ima.ima25)
         DISPLAY BY NAME g_ima.ima27
      END IF
   END IF
   IF g_ima.ima27 < 0 #genero
      THEN  CALL cl_err(g_ima.ima27,'mfg0013',0)
      LET g_ima.ima27 = g_ima_o.ima27
      DISPLAY BY NAME g_ima.ima27
      RETURN FALSE
   END IF
   LET g_ima_o.ima27 = g_ima.ima27
   RETURN TRUE
END FUNCTION

FUNCTION i101_ima271_check()
   IF NOT cl_null(g_ima.ima271) AND NOT cl_null(g_ima.ima25) THEN
      IF cl_null(g_ima.ima271) OR cl_null(g_ima25_t) OR g_ima_t.ima271 != g_ima.ima271 OR g_ima25_t != g_ima.ima25 THEN
         LET g_ima.ima271=s_digqty(g_ima.ima271, g_ima.ima25)
         DISPLAY BY NAME g_ima.ima271
      END IF
   END IF
   IF g_ima.ima271 < 0 #genero
   THEN
      CALL cl_err(g_ima.ima271,'mfg0013',0)
      LET g_ima.ima271 = g_ima_o.ima271
      DISPLAY BY NAME g_ima.ima271
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i101_ima64_check()
   IF NOT cl_null(g_ima.ima64) AND NOT cl_null(g_ima.ima63) THEN
      IF cl_null(g_ima.ima64) OR cl_null(g_ima63_t) OR g_ima_t.ima64 != g_ima.ima64 OR g_ima63_t != g_ima.ima63 THEN
         LET g_ima.ima64=s_digqty(g_ima.ima64,g_ima.ima63)
         DISPLAY BY NAME g_ima.ima64
      END IF
   END IF
   IF g_ima.ima64 < 0 #genero
   THEN CALL cl_err(g_ima.ima64,'mfg0013',0)
        LET g_ima.ima64 = g_ima_o.ima64
        DISPLAY BY NAME g_ima.ima64
        RETURN FALSE
   END IF
   LET g_ima_o.ima64 = g_ima.ima64
   RETURN TRUE
END FUNCTION

FUNCTION i101_ima641_check()
   IF NOT cl_null(g_ima.ima641) AND NOT cl_null(g_ima.ima63) THEN
      IF cl_null(g_ima.ima641) OR cl_null(g_ima63_t) OR g_ima_t.ima641 != g_ima.ima641 OR g_ima63_t != g_ima.ima63 THEN
         LET g_ima.ima641=s_digqty(g_ima.ima641,g_ima.ima63)
         DISPLAY BY NAME g_ima.ima641
      END IF
   END IF
   IF g_ima.ima641 IS NULL OR g_ima.ima641 = ' '
      THEN LET g_ima.ima641=0
   END IF
   IF g_ima.ima641 < 0
      THEN CALL cl_err(g_ima.ima641,'mfg0013',0)
           LET g_ima.ima641 = g_ima_o.ima641
           DISPLAY BY NAME g_ima.ima641
           RETURN FALSE 
   END IF
   IF g_ima.ima64 >1 AND  g_ima.ima641 >0
   THEN
      IF (g_ima.ima641 mod g_ima.ima64) != 0 THEN
         CALL aimi101_size()
      END IF
   END IF
   LET g_ima_o.ima641 = g_ima.ima641
   RETURN TRUE
END FUNCTION

FUNCTION i101_ima28_check()
   IF NOT cl_null(g_ima.ima28) AND NOT cl_null(g_ima.ima63) THEN
      IF cl_null(g_ima.ima28) OR cl_null(g_ima63_t) OR g_ima_t.ima28 != g_ima.ima28 OR g_ima63_t != g_ima.ima63 THEN
         LET g_ima.ima28=s_digqty(g_ima.ima28,g_ima.ima63)
         DISPLAY BY NAME g_ima.ima28
      END IF
   END IF
   IF g_ima.ima28 < 0 #genero
      THEN CALL cl_err(g_ima.ima28,'mfg0013',0)
           LET g_ima.ima28 = g_ima_o.ima28
           DISPLAY BY NAME g_ima.ima28
           RETURN FALSE 
      END IF
   LET g_ima_o.ima28 = g_ima.ima28
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---end---add---

