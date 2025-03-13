# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: anmt420.4gl
# Descriptions...: 外匯交割維護作業
# Date & Author..: 99/05/07 By Iceman FOR TIPTOP 4.00
# Modify.........: No.8145 03/10/14 By Kitty 加上Help說明功能
# Modify.........: No.MOD-490156 04/09/14 By Kitty 輸入完手續費的出帳銀行,會出現錯誤訊息ANM-239
# Modify.........: No.FUN-4B0052 04/11/24 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-530847 05/05/11 By Smapmin 改變"會計分錄是否重新產生"的問法
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.MOD-590425 05/09/26 By Dido 外幣帳戶交易之原幣金額不可計算匯率
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.MOD-5A0236 06/01/03 By Smapmin 產生分錄有誤
# Modify.........: No.MOD-610035 06/01/03 By Smapmin 產生分錄有誤
#                                                    1.提出銀行寫入 nme04 的原幣有誤須帶 gxe08 之數字
#                                                    2.nme08(本幣金額) 未依 aooi050 取位
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.MOD-670057 06/07/13 By Nicola 金額需過濾作廢資料
# Modify.........: No.FUN-670060 06/08/03 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.MOD-680039 06/08/14 By Smapmin 修改產生分錄底稿的流程
# Modify.........: No.FUN-680088 06/08/29 By Ray 多帳套處理
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.MOD-690084 06/10/16 By Smampin 修改分錄資料
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.MOD-740063 07/05/02 By Smapmin 修改分錄資料
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760143 07/06/29 By Smapmin 修改分錄幣別匯率問題
# Modify.........: No.MOD-770018 07/07/13 By Smampin 修改分錄資料 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.CHI-840038 08/04/23 By bnlent  入帳/出帳銀行查詢開窗修改
# Modify.........: No.FUN-850038 08/05/12 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-8B0013 08/11/11 By jan 1.原本gxe01「交易單號」改為-->「交割單號」，并可自動編號/開窗查詢單別
#                                                2.新增gxe19「交易單號」，畫面擺放位置放在「交割單號」之下 
#                                                3.交易次數(gxe011) 本來計算羅輯是依gxe01，改為gxe19為key計算
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.FUN-940036 09/04/06 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.MOD-960305 09/06/25 By Sarah 執行確認時,若單別設定為不用拋轉總帳的就不需CALL s_chknpq2()
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970055 09/08/18 By destiny 修改時會進死循環 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0012 09/12/02 By ddestiny nem_file补PK，在insert表时给PK字段预设值 
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.MOD-A50048 10/05/07 By sabrina FUNCTION t420_v()中，借貸使用gxc_file部份，增加判斷g_nmy.nmydmy3='Y'才產生
# Modify.........: No.MOD-A60097 10/06/15 By Dido 應抓取gxe19單別,若gxe19單別需要產生分錄才抓取gxc_file產生對沖分錄  
# Modify.........: No:CHI-A60037 10/07/08 By Summer 交易單號開窗內容,若已全數交割時,不可再出現
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No:CHI-A90005 10/10/06 By Summer 抓取傳票號碼
# Modify.........: No:MOD-AA0139 10/10/25 By Dido 分錄摘要抓取順序調整 
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整

# Modify.........: NO.FUN-AA0087 11/01/30 By Mengxw
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file  
# Modify.........: No:MOD-BA0007 11/10/04 By Sarah 單別設定自動拋轉傳票,取消確認時沒有將傳票還原
# Modify.........: No.MOD-C30719 12/03/15 By wangrr 對承作日期和交割日期進行控管，承作日期不可大於交割日期
# Modify.........: No.MOD-C30750 12/03/16 By lujh 手續費開窗幣別應改用 aza17
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No:MOD-CA0013 12/10/01 By Polly gxe15開窗改用q_nmc002、gxe16開窗改用q_nmc001
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D10065 13/03/07 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                   判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_gxe       RECORD LIKE gxe_file.*,#外匯交割資料檔
    g_gxc       RECORD LIKE gxc_file.*,#外匯交易資料檔
    g_gxe_t     RECORD LIKE gxe_file.*,
    g_gxe_o     RECORD LIKE gxe_file.*,
    g_nms       RECORD LIKE nms_file.*,
    g_wc,g_sql  string,                #No.FUN-580092 HCN
    g_nma02     LIKE nma_file.nma02,
    g_trno      LIKE gxe_file.gxe01,   #No.FUN-680107 VARCHAR(12)
    g_nmydmy1   LIKE nmy_file.nmydmy1,  #MOD-AC0073
    g_nmydmy3   LIKE nmy_file.nmydmy3,  #MOD-AC0073
    l_cmd       LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(100)
    l_n         LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
DEFINE g_forupd_sql STRING             #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done STRING
DEFINE g_flag        LIKE type_file.chr1    #No.FUN-730032
DEFINE g_bookno1     LIKE aza_file.aza81    #No.FUN-730032
DEFINE g_bookno2     LIKE aza_file.aza82    #No.FUN-730032
DEFINE g_bookno3     LIKE aza_file.aza82    #No.FUN-730032
DEFINE   g_chr          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE   g_str          STRING                 #No.FUN-670060
DEFINE   g_wc_gl        STRING                 #No.FUN-670060
DEFINE   g_t1           LIKE nmy_file.nmyslip, #No.FUN-680107 VARCHAR(5) #單別
         g_dbs_gl       LIKE type_file.chr21   #No.FUN-680107 VARCHAR(21)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_void         LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_npq25        LIKE npq_file.npq25    #No.FUN-9A0036
DEFINE   g_azi04_2      LIKE azi_file.azi04    #FUN-A40067
DEFINE   g_argv1        LIKE type_file.chr20   #CHI-A90005 add
DEFINE   g_argv2        STRING                 #CHI-A90005 add
DEFINE   g_aag44        LIKE aag_file.aag44    #FUN-D40118 add

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF

    #CHI-A90005 add --start--
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)   #執行功能
    #CHI-A90005 add --end--

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082

    SELECT * INTO g_nms.* FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
 
    INITIALIZE g_gxe.* TO NULL
    INITIALIZE g_gxe_t.* TO NULL
    INITIALIZE g_gxe_o.* TO NULL
    LET g_forupd_sql = "SELECT * FROM gxe_file WHERE gxe01 = ? AND gxe011 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t420_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

    OPEN WINDOW t420_w WITH FORM "anm/42f/anmt420"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    #CHI-A90005 add --start--
    #先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t420_q()
             END IF
          OTHERWISE
             CALL t420_q()
       END CASE
    END IF
    #CHI-A90005 add --end--

      LET g_action_choice = ""
      CALL t420_menu()

    CLOSE WINDOW t420_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t420_cs()
    CLEAR FORM
 IF cl_null(g_argv1) THEN  #CHI-A90005 add
    INITIALIZE g_gxe.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                      gxe01,gxe19,gxe02,gxe011,gxe03,gxe06,gxe13,gxe14,gxe141,gxe04,#No.FUN-8B0013
                      gxe05,gxe07,gxe15,gxe08,gxe09,gxe11,gxe071,gxe16,
                      gxe10,gxe18,gxe17,gxe12
                      ,gxeud01,gxeud02,gxeud03,gxeud04,gxeud05,
                      gxeud06,gxeud07,gxeud08,gxeud09,gxeud10,
                      gxeud11,gxeud12,gxeud13,gxeud14,gxeud15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(gxe01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gxe01"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_gxe.gxe01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxe01
                  NEXT FIELD gxe01
               WHEN INFIELD(gxe19)   #FUN-8B0013 gxe01-->gxe19
                #CHI-A60037 mark --start--
                # CALL cl_init_qry_var()
                # LET g_qryparam.form = "q_gxc"
                # LET g_qryparam.state= "c"
                # LET g_qryparam.default1 = g_gxe.gxe19   #FUN-8B0013 gxe01-->gxe19
                # CALL cl_create_qry() RETURNING g_qryparam.multiret
                # DISPLAY g_qryparam.multiret TO gxe19  #FUN-8B0013 gxe01-->gxe19
                # NEXT FIELD gxe19  #FUN-8B0013 gxe01-->gxe19
                #CHI-A60037 mark --end--
                #CHI-A60037 add --start--
                 CALL q_gxc1(TRUE,TRUE,g_gxe.gxe19) RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gxe19 
                 NEXT FIELD gxe19
                #CHI-A60037 add --end--
               WHEN INFIELD(gxe05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_gxe.gxe05
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxe05
                  NEXT FIELD gxe05
               WHEN INFIELD(gxe06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_gxe.gxe06
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxe06
                  NEXT FIELD gxe06
               WHEN INFIELD(gxe07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_gxe.gxe07
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxe07
                  NEXT FIELD gxe07
               WHEN INFIELD(gxe071)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_gxe.gxe071
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxe071
                  NEXT FIELD gxe071
               WHEN INFIELD(gxe15)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_nmc"           #MOD-CA0013 mark
                  LET g_qryparam.form = "q_nmc002"        #MOD-CA0013 add
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_gxe.gxe15
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxe15
                  NEXT FIELD gxe15
               WHEN INFIELD(gxe16)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_nmc"           #MOD-CA0013 mark
                  LET g_qryparam.form = "q_nmc001"        #MOD-CA0013 add
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_gxe.gxe16
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxe16
                  NEXT FIELD gxe16
               WHEN INFIELD(gxe17) #手續費出帳銀行
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_gxe.gxe17
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxe17
                  NEXT FIELD gxe17
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
 #CHI-A90005 add --start--
    ELSE LET g_wc=" gxe01='",g_argv1,"'"
 END IF
 #CHI-A90005 add --end--
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT gxe01,gxe011,gxe19 FROM gxe_file ", # 組合出 SQL 指令 #FUN-8B0013 add gxe19
              " WHERE ",g_wc CLIPPED," ORDER BY gxe01"
    PREPARE t420_pre FROM g_sql           # RUNTIME 編譯
    DECLARE t420_cs                       # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t420_pre
    LET g_sql="SELECT COUNT(*) FROM gxe_file WHERE ",g_wc CLIPPED
    PREPARE t420_precount FROM g_sql
    DECLARE t420_count CURSOR FOR t420_precount
END FUNCTION
 
FUNCTION t420_menu()
    MESSAGE ''
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_aza.aza63 = 'Y' THEN
               CALL cl_set_act_visible("entry_sheet2",TRUE)
            ELSE
               CALL cl_set_act_visible("entry_sheet2",FALSE)
            END IF
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t420_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t420_q()
            END IF
        ON ACTION next  CALL t420_fetch('N')
        ON ACTION previous  CALL t420_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t420_u()
            END IF
 
        ON ACTION void
           LET g_action_choice="void"
           IF cl_chk_act_auth() THEN
             #CALL t420_x()                      #FUN-D20035
              CALL t420_x(1)                     #FUN-D20035
              IF g_gxe.gxe13 = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_gxe.gxe13,"","","",g_void,"")
           END IF
 
        #FUN-D20035----add---str
        ON ACTION undo_void
           LET g_action_choice="void"
           IF cl_chk_act_auth() THEN
              CALL t420_x(2)             
              IF g_gxe.gxe13 = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_gxe.gxe13,"","","",g_void,"")
           END IF
        #FUN-D20035----add---end    
   
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t420_y()
               IF g_gxe.gxe13 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gxe.gxe13,"","","",g_void,"")
            END IF
 
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t420_z()
               IF g_gxe.gxe13 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gxe.gxe13,"","","",g_void,"")
            END IF
 
        ON ACTION carry_voucher
           IF cl_chk_act_auth() THEN
              IF g_gxe.gxe13 = 'Y' THEN
                 CALL t420_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
              END IF
           END IF
        ON ACTION undo_carry_voucher
           IF cl_chk_act_auth() THEN
              IF g_gxe.gxe13 = 'Y' THEN
                 CALL t420_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
              END IF
           END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL t420_r()
            END IF
 
        ON ACTION gen_entry
           LET g_action_choice="gen_entry"
           IF cl_chk_act_auth() THEN
              CALL t420_v('0')
              IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                 CALL t420_v('1')
              END IF
           END IF
 
        ON ACTION entry_sheet
            LET g_action_choice="entry_sheet"
            IF cl_chk_act_auth()  AND g_gxe.gxe13 != 'X' THEN
               CALL s_fsgl('NM',8,g_gxe.gxe01,0,g_nmz.nmz02b,g_gxe.gxe011, 
                            g_gxe.gxe13,'0',g_nmz.nmz02p)      #No.FUN-680088
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               CALL t420_npp02('0')  #No.+086 010502 by plum      #No.FUN-680088
            END IF
 
        ON ACTION entry_sheet2
            LET g_action_choice="entry_sheet2"
            IF cl_chk_act_auth()  AND g_gxe.gxe13 != 'X' THEN
               CALL s_fsgl('NM',8,g_gxe.gxe01,0,g_nmz.nmz02c,g_gxe.gxe011,
                            g_gxe.gxe13,'1',g_nmz.nmz02p)
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               CALL t420_npp02('1')
            END IF
 
        ON ACTION qry_transaction
            LET l_cmd = "anmt300 '",g_gxe.gxe19,"'",g_gxe.gxe011           #FUN-8B0013 gxe01-->gxe19 
            CALL cl_cmdrun_wait(l_cmd CLIPPED)  #FUN-660216 add
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           IF g_gxe.gxe13 = 'X' THEN
              LET g_void = 'Y'
           ELSE
              LET g_void = 'N'
           END IF
           CALL cl_set_field_pic(g_gxe.gxe13,"","","",g_void,"")
 
        ON ACTION exit
           LET g_action_choice = 'exit'
           EXIT MENU
 
        ON ACTION jump CALL t420_fetch('/')
 
        ON ACTION first CALL t420_fetch('F')
 
        ON ACTION last CALL t420_fetch('L')
 
        ON ACTION help    #No.8145
           CALL cl_show_help()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_gxe.gxe01 IS NOT NULL THEN            
                  LET g_doc.column1 = "gxe01"               
                  LET g_doc.column2 = "gxe011"               
                  LET g_doc.column2 = "gxe19"            #FUN-8B0013   
                  LET g_doc.value1 = g_gxe.gxe01            
                  LET g_doc.value2 = g_gxe.gxe011           
                  LET g_doc.value2 = g_gxe.gxe19         #FUN-8B0013  
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
 
           LET g_action_choice = 'exit'
           CONTINUE MENU
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
      &include "qry_string.4gl"
    END MENU
    CLOSE t420_cs
END FUNCTION
 
 
FUNCTION t420_a()
DEFINE li_result  LIKE type_file.num5   #FUN-8B0013
 
    IF s_anmshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_gxe.* LIKE gxe_file.*
    LET g_gxe.gxe011 = 0
    LET g_gxe.gxe02 = '1'
    LET g_gxe.gxe03 = g_today
    LET g_gxe.gxe04 = g_today
    LET g_gxe.gxe08 = 0
    LET g_gxe.gxe09 = 1
    LET g_gxe.gxe10 = 1
    LET g_gxe.gxe11 = 1
    LET g_gxe.gxe13 = 'N'
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL t420_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           LET g_gxe.gxe19 = NULL   #MOD-660086 add #FUN-8B0013 gxe01-->gxe19 
           LET g_gxe.gxe011= NULL   #MOD-660086 add
           LET g_gxe.gxe01= NULL    #FUN-8B0013
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_gxe.gxe01) THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
        CALL s_auto_assign_no("anm",g_gxe.gxe01,g_gxe.gxe04,"J","gxe_file","gxe01","","","")
        RETURNING li_result,g_gxe.gxe01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_gxe.gxe01
 
        LET g_gxe.gxelegal = g_legal 
 
        INSERT INTO gxe_file VALUES(g_gxe.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","gxe_file",g_gxe.gxe01,g_gxe.gxe011,SQLCA.sqlcode,"","",1)  #No.FUN-660148
           ROLLBACK WORK    #FUN-8B0013
           CONTINUE WHILE
        ELSE
          #-MOD-AC0073-add-
           #---判斷是否立即confirm-----
           LET g_t1 = s_get_doc_no(g_gxe.gxe01)    
           SELECT nmydmy1,nmydmy3 INTO g_nmydmy1,g_nmydmy3
             FROM nmy_file
            WHERE nmyslip = g_t1 AND nmyacti = 'Y'
           IF g_nmydmy3 = 'Y' THEN
              IF cl_confirm('axr-309') THEN
                 CALL t420_v('0')  
                 IF g_aza.aza63 = 'Y' THEN
                    CALL t420_v('1')
                 END IF
              END IF
           END IF
           IF g_nmydmy1 = 'Y' AND g_nmydmy3='N' THEN CALL t420_y() END IF
          #-MOD-AC0073-end-
           COMMIT WORK                            #FUN-8B0013
           LET g_gxe_t.* = g_gxe.*                # 保存上筆資料
           SELECT gxe01,gxe011 INTO g_gxe.gxe01,g_gxe.gxe011 FROM gxe_file
            WHERE gxe01 = g_gxe.gxe01
              AND gxe011= g_gxe.gxe011  #no.6537
              AND gxe19 = g_gxe.gxe19   #FUN-8B0013
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t420_i(p_cmd)
    DEFINE p_cmd    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_cnt    LIKE type_file.num5,    #No.FUN-680107 SMALLINT
           l_mxno   LIKE type_file.chr4,    #No.FUN-680107 VARCHAR(04)
           l_buf    LIKE nma_file.nma02,
           l_nmc02  LIKE nmc_file.nmc02,
           l_gxc08  LIKE gxc_file.gxc08,
           l_gxe08  LIKE gxe_file.gxe08,
           l_gxc04  LIKE gxc_file.gxc04,
           l_gxc041 LIKE gxc_file.gxc041,
           l_gxe01  LIKE gxe_file.gxe01     #No.FUN-680107 VARCHAR(08)
DEFINE li_result LIKE type_file.num5        #FUN-8B0013
 
    INPUT BY NAME g_gxe.gxe01,g_gxe.gxe19,g_gxe.gxe02,g_gxe.gxe011,g_gxe.gxe03,  #FUN-8B0013
                  g_gxe.gxe13,g_gxe.gxe14,g_gxe.gxe141,g_gxe.gxe04,
                  g_gxe.gxe07,g_gxe.gxe15,g_gxe.gxe08,g_gxe.gxe09,g_gxe.gxe11,
                  g_gxe.gxe071,g_gxe.gxe16,g_gxe.gxe10,
                  g_gxe.gxe18,g_gxe.gxe17,g_gxe.gxe12
                 ,g_gxe.gxeud01,g_gxe.gxeud02,g_gxe.gxeud03,g_gxe.gxeud04,
                  g_gxe.gxeud05,g_gxe.gxeud06,g_gxe.gxeud07,g_gxe.gxeud08,
                  g_gxe.gxeud09,g_gxe.gxeud10,g_gxe.gxeud11,g_gxe.gxeud12,
                  g_gxe.gxeud13,g_gxe.gxeud14,g_gxe.gxeud15 
                  WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t420_set_entry(p_cmd)
            CALL t420_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("gxe01")    
         CALL cl_set_docno_format("gxe19")    #FUN-8B0013
 
        AFTER FIELD gxe01
          IF NOT cl_null(g_gxe.gxe01) THEN
             IF g_gxe.gxe01 !=g_gxe_t.gxe01 OR g_gxe_t.gxe01 IS NULL THEN           #No.TQC-970055
                CALL s_check_no("anm",g_gxe.gxe01,g_gxe_t.gxe01,"J","gxe_file","gxe01","")
                RETURNING li_result,g_gxe.gxe01                                                                                         
                DISPLAY BY NAME g_gxe.gxe01
                IF(NOT li_result) THEN
                   NEXT FIELD gxe01
                   DISPLAY BY NAME g_gxe.gxe01
                END IF
             END IF                                              #No.TQC-970055   
          END IF
        AFTER FIELD gxe19
           IF NOT cl_null(g_gxe.gxe19) THEN
              IF p_cmd = 'a' THEN
                 SELECT MAX(gxe011) INTO g_cnt FROM gxe_file
                  WHERE gxe19 = g_gxe.gxe19
                 IF cl_null(g_cnt) THEN LET g_cnt=0  END IF
                 LET g_gxe.gxe011 = g_cnt + 1
              END IF
              SELECT gxc01,gxc02,gxc03,gxc04,gxc05,gxc06,gxc08,gxc12
                INTO g_gxe.gxe19,g_gxe.gxe02,g_gxe.gxe03,g_gxe.gxe04,#FUN-8B0013 gxe01-->gxe19 
                     g_gxe.gxe05,g_gxe.gxe06,g_gxe.gxe08,
                     g_gxe.gxe12
                FROM gxc_file
               WHERE gxc01 = g_gxe.gxe19 AND gxc13 = 'Y' #FUN-8B0013 gxe01-->gxe19 
                IF STATUS THEN 
                   CALL cl_err3("sel","gxc_file",g_gxe.gxe19,"","anm-626","","",1)  
                   LET g_gxe.gxe19 = g_gxe_t.gxe19 #FUN-8B0013 gxe01-->gxe19 
                   DISPLAY BY NAME g_gxe.gxe19 #FUN-8B0013 gxe01-->gxe19 
                   NEXT FIELD gxe19   #FUN-8B0013 gxe01-->gxe19 
              END IF
              IF g_gxe.gxe02 = '1' THEN
                 SELECT gxc10 INTO g_gxe.gxe09 FROM gxc_file
                   WHERE gxc01 = g_gxe.gxe19 AND gxc13 = 'Y'  #FUN-8B0013 gxe01-->gxe19 
                 LET g_gxe.gxe10 = s_curr3(g_gxe.gxe05,g_gxe.gxe04,'B')
              ELSE
                 LET g_gxe.gxe09 = s_curr3(g_gxe.gxe06,g_gxe.gxe04,'S')
                 SELECT gxc10 INTO g_gxe.gxe10 FROM gxc_file
                   WHERE gxc01 = g_gxe.gxe19 AND gxc13 = 'Y'  #FUN-8B0013 gxe01-->gxe19 
              END IF
              DISPLAY BY NAME g_gxe.gxe19,g_gxe.gxe02,g_gxe.gxe03,g_gxe.gxe04,#FUN-8B0013 gxe01-->gxe19 
                              g_gxe.gxe05,g_gxe.gxe06,g_gxe.gxe08,g_gxe.gxe10,
                              g_gxe.gxe12,g_gxe.gxe14,g_gxe.gxe17,g_gxe.gxe18,
                              g_gxe.gxe011,
                              g_gxe.gxe09   #MOD-770018
           END IF
        AFTER FIELD gxe04
           IF NOT cl_null(g_gxe.gxe04) THEN
              #MOD-C30719--add--str
              IF g_gxe.gxe04!=g_gxe_t.gxe04 OR cl_null(g_gxe_t.gxe04) THEN
                 IF g_gxe.gxe04<g_gxe.gxe03 THEN
                    CALL cl_err(g_gxe.gxe04,'anm-193',0)
                    NEXT FIELD gxe04
                 END IF
              END IF
              #MOD-C30719--add--end
              SELECT gxc04,gxc041 INTO l_gxc04,l_gxc041
                FROM gxc_file WHERE gxc01 = g_gxe.gxe19  #FUN-8B0013 gxe01-->gxe19 
              IF sqlca.sqlcode THEN
                 LET l_gxc04 = null LET l_gxc041 = null
              END IF
              IF g_gxe.gxe04 < l_gxc04 OR g_gxe.gxe04 > l_gxc041 THEN
                 CALL cl_err(g_gxe.gxe04,'anm-649',0)
                 NEXT FIELD gxe04
              END IF
              IF g_gxe.gxe04 <= g_nmz.nmz10 THEN  #no.5261
                 CALL cl_err('','aap-176',1) NEXT FIELD gxe04
              END IF
           END IF
 
        AFTER FIELD gxe07
           LET l_buf = ''
           IF NOT cl_null(g_gxe.gxe07) THEN
              CALL chk_nma(g_gxe.gxe07,g_gxe.gxe06) RETURNING l_buf
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gxe.gxe07,g_errno,1) NEXT FIELD gxe07
              END IF
              DISPLAY l_buf TO FORMONLY.nma021
           END IF
 
        AFTER FIELD gxe071
           IF NOT cl_null(g_gxe.gxe071) THEN
              LET l_buf = ''
              CALL chk_nma(g_gxe.gxe071,g_gxe.gxe05) RETURNING l_buf
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gxe.gxe071,g_errno,1) NEXT FIELD gxe071
              END IF
              DISPLAY l_buf TO FORMONLY.nma022
           END IF
 
        AFTER FIELD gxe08
           IF NOT cl_null(g_gxe.gxe08) THEN
              #外匯交割承作金額合計不得大於外匯交易承作金額
              SELECT gxc08 INTO l_gxc08 FROM gxc_file WHERE gxc01=g_gxe.gxe19 #FUN-8B0013 gxe01-->gxe19 
              IF cl_null(l_gxc08) THEN  LET l_gxc08 = 0  END IF
              SELECT SUM(gxe08) INTO l_gxe08 FROM gxe_file
               WHERE gxe19=g_gxe.gxe19
                 AND gxe13 <> "X"   #No.MOD-670057
              IF cl_null(l_gxe08) THEN  LET l_gxe08 = 0  END IF
              IF p_cmd = 'a' THEN
                 LET l_gxe08 = l_gxe08 + g_gxe.gxe08
              ELSE
                 IF g_gxe_t.gxe08 <> g_gxe.gxe08 THEN
                    LET l_gxe08 = l_gxe08 - g_gxe_t.gxe08 + g_gxe.gxe08
                 END IF
              END IF
              IF l_gxe08 > l_gxc08  THEN
                 CALL cl_err('','anm-642',0) NEXT FIELD gxe08
              END IF
           END IF
 
        AFTER FIELD gxe15
           IF NOT cl_null(g_gxe.gxe15) THEN
              CALL chk_nmc(g_gxe.gxe15,'2') RETURNING l_nmc02
              IF g_errno <> ' ' THEN
                 CALL cl_err(g_gxe.gxe15,g_errno,1) NEXT FIELD gxe15
              END IF
              DISPLAY l_nmc02 TO FORMONLY.nmc021
           END IF
 
        AFTER FIELD gxe16
           IF NOT cl_null(g_gxe.gxe16) THEN
              CALL chk_nmc(g_gxe.gxe16,'1') RETURNING l_nmc02
              IF g_errno <> ' ' THEN
                 CALL cl_err(g_gxe.gxe16,g_errno,1) NEXT FIELD gxe16
              END IF
              DISPLAY l_nmc02 TO FORMONLY.nmc022
           END IF
 
        AFTER FIELD gxe09
           IF cl_null(g_gxe.gxe09) THEN LET g_gxe.gxe09 = 1 END IF
        AFTER FIELD gxe10
           IF cl_null(g_gxe.gxe10) THEN LET g_gxe.gxe10 = 1 END IF
        AFTER FIELD gxe11
           IF cl_null(g_gxe.gxe11) THEN LET g_gxe.gxe11 = 1 END IF
 
        AFTER FIELD gxe18
           IF g_gxe.gxe18 < 0 and cl_null(g_gxe.gxe18) THEN
              NEXT FIELD gxe18
           END IF
 
        AFTER FIELD gxe17
           LET g_nma02 = ' '
            IF g_gxe.gxe18 > 0 and cl_null(g_gxe.gxe17) THEN   #No.MOD-490156
              CALL cl_err(g_gxe.gxe17,'anm-239',0)
              NEXT FIELD gxe17
           END IF
           IF NOT cl_null(g_gxe.gxe17) THEN
              CALL chk_nma(g_gxe.gxe17,g_aza.aza17) RETURNING l_buf
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gxe.gxe17,g_errno,1) NEXT FIELD gxe17
              END IF
              DISPLAY l_buf TO FORMONLY.nma02
           END IF
 
        AFTER FIELD gxeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(gxe01)
                   LET g_t1=s_get_doc_no(g_gxe.gxe01)
                   CALL q_nmy(FALSE,TRUE,g_t1,'J','ANM') RETURNING g_t1 
                   LET g_gxe.gxe01 = g_t1
                   DISPLAY BY NAME g_gxe.gxe01
                   NEXT FIELD gxe01
               WHEN INFIELD(gxe19)  #FUN-8B0013 gxe01-->gxe19 
                #CHI-A60037 mark --start--
                # CALL cl_init_qry_var()
                # LET g_qryparam.form = "q_gxc"
                # LET g_qryparam.default1 = g_gxe.gxe19  #FUN-8B0013 gxe01-->gxe19 
                # CALL cl_create_qry() RETURNING g_gxe.gxe19  #FUN-8B0013 gxe01-->gxe19 
                # DISPLAY BY NAME g_gxe.gxe19  #FUN-8B0013 gxe01-->gxe19 
                # NEXT FIELD gxe19   #FUN-8B0013 gxe01-->gxe19 
                #CHI-A60037 mark --end--
                #CHI-A60037 add --start--
                 CALL q_gxc1(FALSE,TRUE,g_gxe.gxe19) RETURNING g_gxe.gxe19
                 DISPLAY BY NAME g_gxe.gxe19 
                 NEXT FIELD gxe19
                #CHI-A60037 add --end--
               WHEN INFIELD(gxe07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma8"           #No.CHI-840038 q_nma->q_nma8
                  LET g_qryparam.default1 = g_gxe.gxe07
                  LET g_qryparam.arg1 = g_gxe.gxe06        #No.CHI-840038    
                  CALL cl_create_qry() RETURNING g_gxe.gxe07
                  DISPLAY BY NAME g_gxe.gxe07
                  NEXT FIELD gxe07
               WHEN INFIELD(gxe071)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma8"           #No.CHI-840038 q_nma->q_nma8
                  LET g_qryparam.default1 = g_gxe.gxe071
                  LET g_qryparam.arg1 = g_gxe.gxe05        #No.CHI-840038  
                  CALL cl_create_qry() RETURNING g_gxe.gxe071
                  DISPLAY BY NAME g_gxe.gxe071
                  NEXT FIELD gxe071
               WHEN INFIELD(gxe15)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_nmc"           #MOD-CA0013 mark
                  LET g_qryparam.form = "q_nmc002"        #MOD-CA0013 add
                  LET g_qryparam.default1 = g_gxe.gxe15
                  CALL cl_create_qry() RETURNING g_gxe.gxe15
                  DISPLAY BY NAME g_gxe.gxe15
                  NEXT FIELD gxe15
               WHEN INFIELD(gxe16)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_nmc"           #MOD-CA0013 mark
                  LET g_qryparam.form = "q_nmc001"        #MOD-CA0013 add
                  LET g_qryparam.default1 = g_gxe.gxe16
                  CALL cl_create_qry() RETURNING g_gxe.gxe16
                  DISPLAY BY NAME g_gxe.gxe16
                  NEXT FIELD gxe16
               WHEN INFIELD(gxe17) #手續費出帳銀行
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma8"           #No.CHI-840038 q_nma->q_nma8
                  LET g_qryparam.default1 = g_gxe.gxe17
                  #LET g_qryparam.arg1 = g_gxe.gxe06        #No.CHI-840038   #MOD-C30750   mark
                  LET g_qryparam.arg1 = g_aza.aza17         #MOD-C30750   add 
                  CALL cl_create_qry() RETURNING g_gxe.gxe17
                  DISPLAY BY NAME g_gxe.gxe17
                  NEXT FIELD gxe17
              WHEN INFIELD(gxe09)
                   CALL s_rate(g_gxe.gxe06,g_gxe.gxe09) RETURNING g_gxe.gxe09
                   DISPLAY BY NAME g_gxe.gxe09
                   NEXT FIELD gxe09
              WHEN INFIELD(gxe10)
                   CALL s_rate(g_gxe.gxe05,g_gxe.gxe10) RETURNING g_gxe.gxe10
                   DISPLAY BY NAME g_gxe.gxe10
                   NEXT FIELD gxe10
            END CASE
 
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
 
FUNCTION chk_nma(p_nma01,p_nma10)
    DEFINE p_nma01 LIKE nma_file.nma01
    DEFINE p_nma10 LIKE nma_file.nma10
    DEFINE l_nma02 LIKE nma_file.nma02
    DEFINE l_nma10 LIKE nma_file.nma10
    DEFINE l_nmaacti LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT nma02,nma10,nmaacti INTO l_nma02,l_nma10,l_nmaacti
      FROM nma_file
     WHERE nma01 = p_nma01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                                LET l_nma02 = NULL LET l_nma10 = ' '
         WHEN l_nmaacti='N'     LET g_errno = '9028'
         WHEN p_nma10 !=l_nma10 LET g_errno = 'axm-144' #No:7303
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_nma02
END FUNCTION
 
FUNCTION chk_nmc(p_nmc01,p_nmc03)
    DEFINE p_nmc01 LIKE nmc_file.nmc01
    DEFINE p_nmc03 LIKE nmc_file.nmc03
    DEFINE l_nmc02 LIKE nmc_file.nmc02
    DEFINE l_nmc03 LIKE nmc_file.nmc03
    DEFINE l_nmcacti LIKE nmc_file.nmcacti
 
    LET g_errno = ' '
    SELECT nmc02,nmc03,nmcacti INTO l_nmc02,l_nmc03,l_nmcacti
      FROM nmc_file
     WHERE nmc01 = p_nmc01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-024'
                                LET l_nmc02 = NULL LET l_nmcacti = ' '
         WHEN l_nmcacti='N'     LET g_errno = '9028'
         WHEN p_nmc03 != l_nmc03 LET g_errno = 'anm-151'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_nmc02
END FUNCTION
 
FUNCTION t420_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    LET g_gxe.gxe01 = NULL                  #NO.FUN-6A0011
    LET g_gxe.gxe011= NULL                  #No.FUN-6A0011
    LET g_gxe.gxe19= NULL                   #FUN-8B0013
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t420_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_gxe.gxe01 = NULL               #MOD-660086 add
       LET g_gxe.gxe011= NULL               #MOD-660086 add
       LET g_gxe.gxe19= NULL                #FUN-8B0013
       CLEAR FORM
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t420_count
    FETCH t420_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t420_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_gxe.gxe01,SQLCA.sqlcode,0)
       INITIALIZE g_gxe.* TO NULL
    ELSE
       CALL t420_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t420_fetch(p_flgxe)
    DEFINE
        p_flgxe         LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10    #No.FUN-680107 INTEGER
 
    CASE p_flgxe
        WHEN 'N' FETCH NEXT   t420_cs
                       INTO g_gxe.gxe01,g_gxe.gxe011,g_gxe.gxe19   #FUN-8B0013
        WHEN 'P' FETCH PREVIOUS t420_cs
                       INTO g_gxe.gxe01,g_gxe.gxe011,g_gxe.gxe19   #FUN-8B0013
        WHEN 'F' FETCH FIRST    t420_cs
                       INTO g_gxe.gxe01,g_gxe.gxe011,g_gxe.gxe19   #FUN-8B0013
        WHEN 'L' FETCH LAST     t420_cs
                       INTO g_gxe.gxe01,g_gxe.gxe011,g_gxe.gxe19   #FUN-8B0013
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t420_cs INTO g_gxe.gxe01,g_gxe.gxe011,g_gxe.gxe19 #FUN-8B0013
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxe.gxe01,SQLCA.sqlcode,0)
        INITIALIZE g_gxe.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flgxe
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_gxe.* FROM gxe_file            # 重讀DB,因TEMP有不被更新特性
     WHERE gxe01 = g_gxe.gxe01 AND gxe011 = g_gxe.gxe011
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","gxe_file",g_gxe.gxe01,g_gxe.gxe011,SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       CALL t420_show()                           # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION t420_show()
    DEFINE l_buf     LIKE nma_file.nma02
    DEFINE l_nmc02   LIKE nmc_file.nmc02
 
    LET g_gxe_t.* = g_gxe.*
    DISPLAY BY NAME g_gxe.gxe01,g_gxe.gxe19,g_gxe.gxe011,g_gxe.gxe02,g_gxe.gxe03, #FUN-8B0013 add gxe19
                    g_gxe.gxe04,g_gxe.gxe05,g_gxe.gxe06,g_gxe.gxe07,
                    g_gxe.gxe071,g_gxe.gxe08,g_gxe.gxe15,g_gxe.gxe16,
                    g_gxe.gxe09,g_gxe.gxe10,g_gxe.gxe11,g_gxe.gxe12,
                    g_gxe.gxe13,g_gxe.gxe14,g_gxe.gxe17,g_gxe.gxe18,
                    g_gxe.gxe141
                   ,g_gxe.gxeud01,g_gxe.gxeud02,g_gxe.gxeud03,g_gxe.gxeud04,
                    g_gxe.gxeud05,g_gxe.gxeud06,g_gxe.gxeud07,g_gxe.gxeud08,
                    g_gxe.gxeud09,g_gxe.gxeud10,g_gxe.gxeud11,g_gxe.gxeud12,
                    g_gxe.gxeud13,g_gxe.gxeud14,g_gxe.gxeud15 
    CALL chk_nma(g_gxe.gxe07,'') RETURNING l_buf
    DISPLAY l_buf TO nma021
    CALL chk_nma(g_gxe.gxe071,'') RETURNING l_buf
    DISPLAY l_buf TO nma022
    CALL chk_nma(g_gxe.gxe17,'') RETURNING l_buf
    DISPLAY l_buf   TO nma02
 
    CALL chk_nmc(g_gxe.gxe15,'2') RETURNING l_nmc02
    DISPLAY l_nmc02 TO FORMONLY.nmc021
    CALL chk_nmc(g_gxe.gxe16,'1') RETURNING l_nmc02
    DISPLAY l_nmc02 TO FORMONLY.nmc022
    IF g_gxe.gxe13 = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_gxe.gxe13,"","","",g_void,"")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t420_u()
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_gxe.* FROM gxe_file WHERE gxe01 = g_gxe.gxe01 AND gxe011 = g_gxe.gxe011
    IF cl_null(g_gxe.gxe01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_gxe.gxe13 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_gxe.gxe13 = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gxe_t.* =g_gxe.*
    BEGIN WORK
    OPEN t420_cl USING g_gxe.gxe01,g_gxe.gxe011
    IF STATUS THEN
       CALL cl_err("OPEN t420_cl:", STATUS, 1)
       CLOSE t420_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t420_cl INTO g_gxe.*               # 對DB鎖定
    IF STATUS THEN CALL cl_err(g_gxe.gxe01,STATUS,0) RETURN END IF
    CALL t420_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t420_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_gxe.*=g_gxe_t.*
           CALL t420_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE gxe_file SET gxe_file.* = g_gxe.*    # 更新DB
         WHERE gxe01 = g_gxe.gxe01 AND gxe011 = g_gxe.gxe011             # COLAUTH?
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","gxe_file",g_gxe_t.gxe01,g_gxe_t.gxe011,SQLCA.sqlcode,"","(t420_u:gxe)",1)  #No.FUN-660148
           CONTINUE WHILE
        END IF
        IF g_gxe.gxe04 != g_gxe_t.gxe04 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_gxe.gxe04
            WHERE npp01=g_gxe.gxe01 AND npp00=8 AND npp011=g_gxe.gxe011 
              AND nppsys = 'NM'
           IF STATUS THEN 
              CALL cl_err3("upd","npp_file",g_gxe_t.gxe01,g_gxe_t.gxe011,STATUS,"","upd npp02:",1)  #No.FUN-660148
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t420_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t420_npp02(p_npptype)
  DEFINE p_npptype   LIKE npp_file.npptype      #No.FUN-680088
 
  IF g_gxe.gxe14 IS NULL OR g_gxe.gxe14=' ' THEN
     UPDATE npp_file SET npp02=g_gxe.gxe04
        WHERE npp01=g_gxe.gxe01 AND npp00=8 AND npp011=g_gxe.gxe011 
        AND nppsys = 'NM'
        AND npptype = p_npptype      #No.FUN-680088
     IF STATUS THEN 
        CALL cl_err3("upd","npp_file",g_gxe.gxe01,g_gxe.gxe011,STATUS,"","upd npp02:",1)  #No.FUN-660148
     END IF
  END IF
END FUNCTION
 
FUNCTION t420_r()
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_gxe.* FROM gxe_file WHERE gxe01 = g_gxe.gxe01 AND gxe011 = g_gxe.gxe011
    IF cl_null(g_gxe.gxe01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_gxe.gxe13 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_gxe.gxe13 = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t420_cl USING g_gxe.gxe01,g_gxe.gxe011
    IF STATUS THEN
       CALL cl_err("OPEN t420_cl:", STATUS, 1)
       CLOSE t420_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t420_cl INTO g_gxe.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_gxe.gxe01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t420_show()
    IF cl_delete() THEN
       DELETE FROM gxe_file WHERE gxe01 = g_gxe.gxe01 AND gxe011=g_gxe.gxe011 AND gxe19=g_gxe.gxe19 #FUN-8B0013
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gxe_file",g_gxe.gxe01,g_gxe.gxe011,SQLCA.sqlcode,"","(t420_r:delete gxe)",1)  #No.FUN-660148
          LET g_success ='N'
       END IF
       DELETE FROM npp_file
        WHERE npp01 = g_gxe.gxe01 AND npp011 = g_gxe.gxe011 
          AND nppsys = 'NM'       AND npp00 = 8
       IF STATUS THEN
          CALL cl_err3("del","npp_file",g_gxe.gxe19,g_gxe.gxe011,SQLCA.sqlcode,"","(t420_r:delete npp)",1)  #No.FUN-660148
          LET g_success ='N'
       END IF
       DELETE FROM npq_file
        WHERE npq01 = g_gxe.gxe01 AND npq011 = g_gxe.gxe011 
          AND npqsys = 'NM'       AND npq00 = 8
       IF STATUS THEN
          CALL cl_err3("del","npq_file",g_gxe.gxe19,g_gxe.gxe011,SQLCA.sqlcode,"","(t420_r:delete npq)",1)  #No.FUN-660148
          LET g_success ='N'
       END IF

       #FUN-B40056--add--str--
       DELETE FROM tic_file WHERE tic04 = g_gxe.gxe01
       IF STATUS THEN
          CALL cl_err3("del","tic_file",g_gxe.gxe19,g_gxe.gxe011,SQLCA.sqlcode,"","(t420_r:delete tic)",1)
          LET g_success ='N'
       END IF
       #FUN-B40056--add--end--

       CLEAR FORM
    END IF
    CLOSE t420_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
       OPEN t420_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t420_cs
          CLOSE t420_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t420_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t420_cs
          CLOSE t420_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t420_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t420_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t420_fetch('/')
       END IF
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t420_y()
    DEFINE l_cnt      LIKE type_file.num5   #No.FUN-680107 SMALLINT
    DEFINE ii         LIKE type_file.num5   #No.FUN-680107 SMALLINT
    DEFINE l_d_npq07  LIKE npq_file.npq07   #No.FUN-4C0010
    DEFINE l_c_npq07  LIKE npq_file.npq07   #No.FUN-4C0010
    DEFINE g_nme      RECORD LIKE nme_file.*
    DEFINE l_n        LIKE type_file.num10  #No.FUN-680107 INTEGER #No.FUN-670060
 
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end

    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_gxe.* FROM gxe_file WHERE gxe01 = g_gxe.gxe01 AND gxe011 = g_gxe.gxe011
    IF cl_null(g_gxe.gxe01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_gxe.gxe13 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_gxe.gxe13 = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF  #已confirm
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
    #-->立帳日期不可小於關帳日期
    IF g_gxe.gxe04 <= g_nmz.nmz10 THEN #no.5261
       CALL cl_err(g_gxc.gxc01,'aap-176',1) RETURN
    END IF
    IF NOT cl_confirm('axr-108') THEN RETURN END IF
    CALL s_get_bookno(YEAR(g_gxe.gxe03)) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '1' THEN
       CALL cl_err(YEAR(g_gxe.gxe03),'aoo-081',1)
       RETURN
    END IF
    LET g_t1 = s_get_doc_no(g_gxe.gxe01)                     #MOD-BA0007 add
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1   #MOD-BA0007 add
    IF g_nmy.nmyglcr = 'N' AND g_nmy.nmydmy3 = 'Y' THEN  #No.FUN-670060  #MOD-960305
       CALL s_chknpq2(g_gxe.gxe01,'NM',8,g_gxe.gxe011,'0',g_bookno1)       #No.FUN-730032
       IF g_aza.aza63 ='Y' AND g_success = 'Y' THEN
          CALL s_chknpq2(g_gxe.gxe01,'NM',8,g_gxe.gxe011,'1',g_bookno2)       #No.FUN-730032
       END IF
    END IF  #No.FUN-670060
    IF g_success = 'N' THEN RETURN END IF
    INITIALIZE g_nme.* TO NULL
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t420_cl USING g_gxe.gxe01,g_gxe.gxe011
    IF STATUS THEN
       CALL cl_err("OPEN t420_cl:", STATUS, 1)
       CLOSE t420_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t420_cl INTO g_gxe.*  #鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxe.gxe19,SQLCA.sqlcode,0)#資料被他人LOCK
        CLOSE t420_cl ROLLBACK WORK RETURN
    END IF
      #-->入帳銀行金額增加
      LET g_nme.nme00 = 0
      LET g_nme.nme01 = g_gxe.gxe071   #入帳銀行編號
      LET g_nme.nme02 = g_gxe.gxe04
      LET g_nme.nme03 = g_gxe.gxe16
      LET g_nme.nme05 = g_gxe.gxe12
      SELECT nma05 INTO g_nme.nme06 FROM nma_file
           WHERE nma01 = g_gxe.gxe071 AND nmaacti = 'Y'
      IF g_aza.aza63 = 'Y' THEN
         SELECT nma051 INTO g_nme.nme061 FROM nma_file
          WHERE nma01 = g_gxe.gxe071 AND nmaacti = 'Y'
      END IF
      IF SQLCA.sqlcode THEN LET g_nme.nme06 = ' ' END IF
      IF g_gxe.gxe05 = g_aza.aza17 THEN
           LET g_nme.nme07 = 1
      ELSE LET g_nme.nme07 = g_gxe.gxe10 * g_gxe.gxe11
      END IF
      LET g_nme.nme08 = g_gxe.gxe08 * g_gxe.gxe10 * g_gxe.gxe11 #本幣金額
      LET g_nme.nme04 = g_nme.nme08/g_nme.nme07   #MOD-770018
      LET g_nme.nme08 = cl_digcut(g_nme.nme08,g_azi04)   #MOD-610035
      SELECT azi04 INTO t_azi04 FROM azi_file
        WHERE azi01=g_gxe.gxe05
      LET g_nme.nme04 = cl_digcut(g_nme.nme04,t_azi04)
      LET g_nme.nme12 = g_gxe.gxe01   #FUN-8B0013
      SELECT nmc05 INTO g_nme.nme14 FROM nmc_file
       WHERE nmc01 = g_gxe.gxe16 AND nmcacti = 'Y'
      IF SQLCA.sqlcode THEN LET g_nme.nme14 = ' ' END IF
      LET g_nme.nme16 = g_gxe.gxe04
      LET g_nme.nme18 = g_gxe.gxe011
      LET g_nme.nmeacti = 'Y'
      LET g_nme.nmegrup = g_grup
      LET g_nme.nmeuser = g_user
      LET g_nme.nmeoriu = g_user #FUN-980030
      LET g_nme.nmeorig = g_grup #FUN-980030
      LET g_nme.nmedate = g_today
      LET g_nme.nme21 = 1
      LET g_nme.nme22 = '21'
      LET g_nme.nme23 = ''
      LET g_nme.nme24 = '9'  #No.TQC-750098
      LET g_nme.nme25 = g_gxe.gxe17
 
      LET g_nme.nmelegal = g_legal 
 
#FUN-B30166--add--str
     LET l_date1 = g_today
     LET l_year = YEAR(l_date1)USING '&&&&'
     LET l_month = MONTH(l_date1) USING '&&'
     LET l_day = DAY(l_date1) USING  '&&'
     LET l_time = TIME(CURRENT)
     LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                  l_time[1,2],l_time[4,5],l_time[7,8]
     SELECT MAX(nme27) + 1 INTO g_nme.nme27 FROM nme_file
      WHERE nme27[1,14] = l_dt
     IF cl_null(g_nme.nme27) THEN
        LET g_nme.nme27 = l_dt,'000001'
     END if
#FUN-B30166--add--end

      INSERT INTO nme_file VALUES(g_nme.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","nme_file",g_nme.nme02,"",SQLCA.sqlcode,"","ins_nme_1",1)  #No.FUN-660148
         ROLLBACK WORK
         RETURN
      END IF
      CALL s_flows_nme(g_nme.*,'1',g_plant)   #No.FUN-B90062  
       
      #-->出帳銀行金額減少
      LET g_nme.nme00=0    #No.FUN-9C0012 
      LET g_nme.nme01 = g_gxe.gxe07                #出帳銀行
      LET g_nme.nme02 = g_gxe.gxe04
      LET g_nme.nme03 = g_gxe.gxe15
      LET g_nme.nme05 = g_gxe.gxe12
      SELECT nma05 INTO g_nme.nme06 FROM nma_file
       WHERE nma01 = g_gxe.gxe07 AND nmaacti = 'Y'
      IF g_aza.aza63 = 'Y' THEN
         SELECT nma051 INTO g_nme.nme061 FROM nma_file
          WHERE nma01 = g_gxe.gxe07 AND nmaacti = 'Y'
      END IF
      IF g_gxe.gxe06 = g_aza.aza17 THEN
           LET g_nme.nme07 = 1
      ELSE LET g_nme.nme07 = g_gxe.gxe09 * g_gxe.gxe11  #匯率
      END IF
      LET g_nme.nme08 = g_gxe.gxe08 * g_gxe.gxe09 * g_gxe.gxe11 #本幣金額
      LET g_nme.nme04 = g_nme.nme08/g_nme.nme07   #MOD-770018
      LET g_nme.nme08 = cl_digcut(g_nme.nme08,g_azi04)   #MOD-610035
      SELECT azi04 INTO t_azi04 FROM azi_file
        WHERE azi01=g_gxe.gxe06
      LET g_nme.nme04 = cl_digcut(g_nme.nme04,t_azi04)
      LET g_nme.nme12 = g_gxe.gxe01   #FUN-8B0013
      SELECT nmc05 INTO g_nme.nme14 FROM nmc_file
       WHERE nmc01 = g_gxe.gxe15 AND nmcacti = 'Y'
      IF SQLCA.sqlcode THEN LET g_nme.nme14 = ' ' END IF
      LET g_nme.nme16 = g_gxe.gxe04
      LET g_nme.nme18 = g_gxe.gxe011
      LET g_nme.nmeacti = 'Y'
      LET g_nme.nmegrup = g_grup
      LET g_nme.nmeuser = g_user
      LET g_nme.nmedate = g_today
      LET g_nme.nme21 = 1
      LET g_nme.nme22 = '21'
      LET g_nme.nme23 = ''
      LET g_nme.nme24 = '9'  #No.TQC-750098
      LET g_nme.nme25 = g_gxe.gxe17
 
      LET g_nme.nmelegal = g_legal 
 
#FUN-B30166--add--str
     LET l_date1 = g_today
     LET l_year = YEAR(l_date1)USING '&&&&'
     LET l_month = MONTH(l_date1) USING '&&'
     LET l_day = DAY(l_date1) USING  '&&'
     LET l_time = TIME(CURRENT)
     LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                  l_time[1,2],l_time[4,5],l_time[7,8]
     SELECT MAX(nme27) + 1 INTO g_nme.nme27 FROM nme_file
      WHERE nme27[1,14] = l_dt
     IF cl_null(g_nme.nme27) THEN
        LET g_nme.nme27 = l_dt,'000001'
     END if
#FUN-B30166--add--end

      INSERT INTO nme_file VALUES(g_nme.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","nme_file",g_nme.nme02,"",SQLCA.sqlcode,"","ins_nme_2",1)  #No.FUN-660148
         ROLLBACK WORK
         RETURN
      END IF
      CALL s_flows_nme(g_nme.*,'1',g_plant)   #No.FUN-B90062   
      #-->手續費出帳銀行減少
      IF NOT cl_null(g_gxe.gxe17) AND g_gxe.gxe18 > 0 THEN
         LET g_nme.nme00=0
         LET g_nme.nme01=g_gxe.gxe17
         LET g_nme.nme02=g_gxe.gxe04
         LET g_nme.nme03=g_nmz.nmz39
         IF cl_null(g_nme.nme03) THEN LET g_nme.nme03 = g_gxe.gxe15 END IF
         LET g_nme.nme04=g_gxe.gxe18
         LET g_nme.nme05='TT FEE'
         LET g_nme.nme06=' '
         IF g_aza.aza63 = 'Y' THEN
            LET g_nme.nme061=' '
         END IF
         LET g_nme.nme07=1
         LET g_nme.nme08=g_gxe.gxe18
         LET g_nme.nme08 = cl_digcut(g_nme.nme08,g_azi04)   #MOD-610035
         LET g_nme.nme12=g_gxe.gxe01 
         SELECT nma02 INTO g_nme.nme13 FROM nma_file where nma01=g_gxe.gxe17
         IF STATUS THEN LET g_nme.nme13=g_gxe.gxe17 END IF
 
         SELECT nmc05 INTO g_nme.nme14 FROM nmc_file
          WHERE nmc01 = g_nme.nme03 AND nmcacti = 'Y'
         IF SQLCA.sqlcode THEN LET g_nme.nme14 = ' ' END IF
         LET g_nme.nme16=g_gxe.gxe04
         LET g_nme.nme18 = g_gxe.gxe011
         LET g_nme.nmeacti='Y'
         LET g_nme.nmeuser=g_user
         LET g_nme.nmegrup=g_grup
         LET g_nme.nmedate=TODAY
         LET g_nme.nme21 = 1
         LET g_nme.nme22 = '21'
         LET g_nme.nme23 = ''
         LET g_nme.nme24 = '9'  #No.TQC-750098
         LET g_nme.nme25 = g_gxe.gxe17
 
         LET g_nme.nmelegal = g_legal 

#FUN-B30166--add--str
        LET l_date1 = g_today
        LET l_year = YEAR(l_date1)USING '&&&&'
        LET l_month = MONTH(l_date1) USING '&&'
        LET l_day = DAY(l_date1) USING  '&&'
        LET l_time = TIME(CURRENT)
        LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                     l_time[1,2],l_time[4,5],l_time[7,8]
        SELECT MAX(nme27) + 1 INTO g_nme.nme27 FROM nme_file
         WHERE nme27[1,14] = l_dt
        IF cl_null(g_nme.nme27) THEN
           LET g_nme.nme27 = l_dt,'000001'
        END if
#FUN-B30166--add--end

         INSERT INTO nme_file VALUES(g_nme.*)
         IF STATUS THEN
            CALL cl_err3("ins","nme_file",g_nme.nme02,"",STATUS,"","ins_nme #3",1)  #No.FUN-660148
            ROLLBACK WORK
            RETURN
         END IF
         CALL s_flows_nme(g_nme.*,'1',g_plant)   #No.FUN-B90062 
      END IF
   IF g_nmy.nmyglcr = 'Y' THEN
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_gxe.gxe01  
         AND npq011 = g_gxe.gxe011
         AND npqsys = 'NM'
         AND npq00 = 8
      IF l_n = 0 THEN
         CALL t420_gen_glcr(g_gxe.*,g_nmy.*)
      END IF
      IF g_success = 'Y' THEN 
         CALL s_chknpq2(g_gxe.gxe01,'NM',8,g_gxe.gxe011,'0',g_bookno1)    
         IF g_aza.aza63 ='Y' AND g_success = 'Y' THEN
            CALL s_chknpq2(g_gxe.gxe01,'NM',8,g_gxe.gxe011,'1',g_bookno2)      
         END IF
         IF g_success ='N' THEN RETURN END IF
      END IF
   END IF
 
      UPDATE gxe_file SET gxe13 = 'Y' WHERE gxe01 = g_gxe.gxe01
                                        AND gxe011= g_gxe.gxe011
                                        AND gxe19 = g_gxe.gxe19   #FUN-8B0013
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","gxe_file",g_gxe.gxe01,g_gxe.gxe011,STATUS,"","upd gxe13",1)  #No.FUN-660148
         LET g_success = 'N'
         ROLLBACK WORK
      ELSE
         LET g_gxe.gxe13 = 'Y'
      END IF
    COMMIT WORK
    DISPLAY BY NAME g_gxe.gxe13
   IF g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_gxe.gxe01,'" AND npp011 = ',g_gxe.gxe011  
      LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_gxe.gxe04,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT gxe14,gxe141 INTO g_gxe.gxe14,g_gxe.gxe141 FROM gxe_file
       WHERE gxe01 = g_gxe.gxe01 
      DISPLAY BY NAME g_gxe.gxe14
      DISPLAY BY NAME g_gxe.gxe141
   END IF
   CALL cl_set_field_pic(g_gxe.gxe13,"","","","N","")   #MOD-AC0073
END FUNCTION
 
FUNCTION t420_z()
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_sql       LIKE type_file.chr1000#No.FUN-680107 VARCHAR(1000)            #No.FUN-670060
   DEFINE l_dbs       STRING                #No.FUN-670060
   DEFINE l_nme24     LIKE nme_file.nme24   #No.FUN-730032
 
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_gxe.* FROM gxe_file WHERE gxe01 = g_gxe.gxe01 AND gxe011 = g_gxe.gxe011
    IF cl_null(g_gxe.gxe19) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_gxe.gxe13 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_gxe.gxe13 = 'N' THEN CALL cl_err('','9023',0) RETURN END IF  #未confirm
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
    #-->立帳日期不可小於關帳日期
    IF g_gxe.gxe04 <= g_nmz.nmz10 THEN #no.5261
       CALL cl_err(g_gxc.gxc01,'aap-176',1) RETURN
    END IF
    LET g_t1 = s_get_doc_no(g_gxe.gxe01)                     #MOD-BA0007 add
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   #str MOD-BA0007 mod
   IF NOT cl_null(g_gxe.gxe14) AND g_nmy.nmyglcr = 'N' THEN  #已拋轉總帳 #No.FUN-670060
      CALL cl_err(g_gxe.gxe19,'axr-310',0) RETURN
   END IF
   #end MOD-BA0007 mod
   IF NOT cl_null(g_gxe.gxe14) THEN
      IF NOT g_nmy.nmyglcr = 'Y' THEN
         CALL cl_err(g_gxe.gxe01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_gxe.gxe14,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_gxe.gxe14,'axr-071',1)
         RETURN
      END IF
 
   END IF
    IF NOT cl_confirm('axr-109') THEN RETURN END IF
    LET g_success='Y'
   #--------------------------------CHI-C90051-----------------------------(S)
    IF g_nmy.nmyglcr = 'Y' AND g_nmy.nmydmy3 = 'Y' THEN
       LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxe.gxe14,"' 'Y'"
       CALL cl_cmdrun_wait(g_str)
       SELECT gxe14,gxe141 INTO g_gxe.gxe14,g_gxe.gxe141 FROM gxe_file
       WHERE gxe01 = g_gxe.gxe01
       DISPLAY BY NAME g_gxe.gxe14
       DISPLAY BY NAME g_gxe.gxe141
       IF NOT cl_null(g_gxe.gxe14) THEN
          CALL cl_err('','aap-929',0)
          RETURN
       END IF
    END IF
   #--------------------------------CHI-C90051-----------------------------(E)
    BEGIN WORK
    OPEN t420_cl USING g_gxe.gxe01,g_gxe.gxe011
    IF STATUS THEN
       CALL cl_err("OPEN t420_cl:", STATUS, 1)
       CLOSE t420_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t420_cl INTO g_gxe.*  #鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxe.gxe01,SQLCA.sqlcode,0)#資料被他人LOCK
        CLOSE t420_cl ROLLBACK WORK RETURN
    END IF
    IF g_aza.aza73 = 'Y' THEN
       LET g_sql="SELECT nme24 FROM nme_file",
                 " WHERE nme12='",g_gxe.gxe01,"'",
                 "   AND nme03='",g_gxe.gxe011,"'"
       PREPARE nme24_p1 FROM g_sql
       DECLARE nme24_cs1 CURSOR FOR nme24_p1
       FOREACH nme24_cs1 INTO l_nme24
          IF l_nme24 != '9' THEN
             CALL cl_err(g_gxe.gxe01,'anm-043',1)
             LET g_success='N'
             RETURN
          END IF
       END FOREACH
    END IF
    
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
    #FUN-B40056 --begin
    DELETE FROM tic_file 
     WHERE tic04 IN    #MOD-BA0007 mod tic12->tic04
   (SELECT nme12 FROM nme_file 
     WHERE nme12 = g_gxe.gxe01 
       AND nme18 = g_gxe.gxe011 )
    IF STATUS THEN
       CALL cl_err3("del","tic_file",g_gxe.gxe01,g_gxe.gxe011,STATUS,"","del tic",1)  #No.FUN-660148
       LET g_success='N'
    END IF
    #FUN-B40056 --end
   END IF         #No.TQC-B70021    
    DELETE FROM nme_file WHERE nme12 = g_gxe.gxe01 AND nme18 = g_gxe.gxe011 
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("del","nme_file",g_gxe.gxe01,g_gxe.gxe011,STATUS,"","del nme",1)  #No.FUN-660148
       LET g_success='N'
    END IF
    
    UPDATE gxe_file SET gxe13 = 'N' WHERE gxe01 = g_gxe.gxe01
                                      AND gxe011= g_gxe.gxe011
                                      AND gxe19 = g_gxe.gxe19   #FUN-8B0013
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","gxe_file",g_gxe.gxe01,g_gxe.gxe011,STATUS,"","upd gxe13",1)  #No.FUN-660148
       LET g_success='N'
    ELSE
       LET g_gxe.gxe13 = 'N'
    END IF
    DISPLAY BY NAME g_gxe.gxe13
    IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   #--------------------------------CHI-C90051-----------------------------mark
   #IF g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxe.gxe14,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT gxe14,gxe141 INTO g_gxe.gxe14,g_gxe.gxe141 FROM gxe_file
   #   WHERE gxe01 = g_gxe.gxe01
   #   DISPLAY BY NAME g_gxe.gxe14
   #   DISPLAY BY NAME g_gxe.gxe141
   #END IF
   #--------------------------------CHI-C90051-----------------------------mark
END FUNCTION
 
FUNCTION t420_v(p_npptype)
    DEFINE p_npptype  LIKE npp_file.npptype      #No.FUN-680088
    DEFINE l_npp      RECORD LIKE npp_file.*,
           l_npq      RECORD LIKE npq_file.*,
           l_gxd      RECORD LIKE gxd_file.*,
           l_n        LIKE type_file.num5,       #No.FUN-680107 SMALLINT
           l_buf      LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(80)
           l_damt     LIKE type_file.num20_6,    #No.FUN-680107 dec(20,6)
           l_damtf    LIKE type_file.num20_6,    #No.FUN-680107 dec(20,6)
           l_camt     LIKE type_file.num20_6,    #No.FUN-680107 dec(20,6)
           l_camtf    LIKE type_file.num20_6,    #No.FUN-680107 dec(20,6)
           l_damt1    LIKE type_file.num20_6,    #No.FUN-680107 dec(20,6)
           l_damtf1   LIKE type_file.num20_6,    #No.FUN-680107 dec(20,6)
           l_camt1    LIKE type_file.num20_6,    #No.FUN-680107 dec(20,6)
           l_camtf1   LIKE type_file.num20_6,    #No.FUN-680107 dec(20,6)
           l_nma02    LIKE nma_file.nma02,
           l_nma05    LIKE nma_file.nma05,
           l_nma051   LIKE nma_file.nma051,      #No.FUN-680088
           l_nma10    LIKE nma_file.nma10
    DEFINE l_t1       LIKE nmy_file.nmyslip      #MOD-A60097   #單別
    DEFINE l_nmydmy3  LIKE nmy_file.nmydmy3      #MOD-A60097   
    DEFINE l_aaa03    LIKE aaa_file.aaa03        #FUN-A40067
    DEFINE l_flag     LIKE type_file.chr1        #FUN-D40118 add
 
    LET g_success = 'Y'      #No.FUN-680088
    IF g_gxe.gxe13 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_gxe.gxe13 = 'Y' THEN RETURN END IF  #已confirm
    IF NOT cl_null(g_gxe.gxe14) THEN  #已拋轉總帳
       LET g_success = 'N'      #No.FUN-680088
       CALL cl_err(g_gxe.gxe01,'aap-122',0) RETURN
    END IF
    MESSAGE ''
    IF s_anmshut(0) THEN 
       LET g_success = 'N'      #No.FUN-680088
       RETURN 
    END IF
    LET l_damt1= 0 LET l_camt1= 0
    LET l_damt = 0 LET l_camt = 0
    LET l_damtf = 0 LET l_camtf = 0
    SELECT * INTO g_gxe.* FROM gxe_file WHERE gxe01 = g_gxe.gxe01
                                          AND gxe011 = g_gxe.gxe011
                                          AND gxe19 = g_gxe.gxe19 #FUN-8B0013
    IF cl_null(g_gxe.gxe01) THEN 
       LET g_success = 'N'      #No.FUN-680088
       CALL cl_err('',-400,0) RETURN 
    END IF
    #-->已confirm
    IF g_gxe.gxe13 = 'Y' THEN 
       LET g_success = 'N'      #No.FUN-680088
       CALL cl_err('','9023',0) RETURN 
    END IF
    LET g_trno = g_gxe.gxe01   #FUN-8B0013
    #-->已拋轉總帳
    SELECT COUNT(*) INTO l_n FROM npp_file
     WHERE nppsys= 'NM' AND npp00=8 AND npp01 = g_trno AND npp011=g_gxe.gxe011
       AND nppglno != '' AND nppglno IS NOT NULL
       AND npptype = p_npptype      #No.FUN-680088
    IF l_n > 0 THEN 
       LET g_success = 'N'      #No.FUN-680088
       CALL cl_err(g_trno,'aap-122',1) RETURN 
    END IF
 
    SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys='NM' AND npq00=8 AND npq01=g_trno AND npq011=g_gxe.gxe011
         AND npqtype = p_npptype      #No.FUN-680088
    #-->分錄已存在是否重新產生 (1:no,2:yes)
    IF l_n > 0 THEN
      IF NOT s_ask_entry(g_trno) THEN 
         LET g_success = 'N'      #No.FUN-680088
         RETURN 
      END IF
    END IF

    #FUN-B40056--add--str--
    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM tic_file
     WHERE tic04 = g_trno
    IF l_n > 0 THEN
       IF NOT cl_confirm('sub-533') THEN
          LET g_success = 'N' 
          RETURN
        END IF
     END IF
     DELETE FROM tic_file WHERE tic04 = g_trno
     #FUN-B40056--add--end--

    SELECT COUNT(*) INTO l_n FROM npp_file
       WHERE nppsys='NM' AND npp00=8 AND npp01=g_trno AND npp011=g_gxe.gxe011
         AND npptype = p_npptype      #No.FUN-680088
    IF l_n > 0 THEN
      DELETE FROM npp_file
       WHERE nppsys= 'NM' AND npp00=8 AND npp01 = g_trno AND npp011=g_gxe.gxe011
         AND npptype = p_npptype      #No.FUN-680088
      DELETE FROM npq_file
       WHERE npqsys= 'NM' AND npq00=8 AND npq01 = g_trno AND npq011=g_gxe.gxe011
         AND npqtype = p_npptype      #No.FUN-680088
    END IF
 
    SELECT * INTO l_gxd.* FROM gxd_file WHERE gxd00 = '0'
    INITIALIZE l_npp.* TO NULL
 
    LET l_npp.nppsys= 'NM'
    LET l_npp.npp00 = 8
    LET l_npp.npp01 = g_gxe.gxe01 
    LET l_npp.npp011= g_gxe.gxe011
    LET l_npp.npp02 = g_gxe.gxe04
    LET l_npp.npptype = p_npptype      #No.FUN-680088
 
    LET l_npp.npplegal = g_legal 
    INSERT INTO npp_file VALUES(l_npp.*)
    IF STATUS THEN 
       LET g_success = 'N'      #No.FUN-680088
       CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,STATUS,"","ins npp",1)  #No.FUN-660148
    END IF
 
    INITIALIZE l_npq.* TO NULL
    LET l_npq.npqsys= 'NM'
    LET l_npq.npq00 = 8
    LET l_npq.npq01 = g_gxe.gxe01 
    LET l_npq.npq011= g_gxe.gxe011
    LET l_npq.npq02 = 0
    LET l_npq.npqtype = p_npptype      #No.FUN-680088
    SELECT * INTO g_gxc.* FROM gxc_file WHERE gxc01 = g_gxe.gxe19 #FUN-8B0013 gxe01-->gxe19 
   #-MOD-A60097-add-
    CALL s_get_doc_no(g_gxe.gxe19) RETURNING l_t1  
    SELECT nmydmy3 INTO l_nmydmy3 
      FROM nmy_file 
     WHERE nmyslip = l_t1
   #-MOD-A60097-add-
    CALL s_get_bookno(YEAR(l_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '1' THEN
       CALL cl_err(YEAR(l_npp.npp02),'aoo-081',1)
       LET g_success = 'N'
    END IF
    IF l_npq.npqtype = '0' THEN
       LET g_bookno3 = g_bookno1
    ELSE
       LET g_bookno3 = g_bookno2
    END IF
    #----------借方----------
    # IF gxe02= 1.預購遠匯
    # 借方:應付購入遠匯(gxd02)   承作金額(gxe08)*即期匯率(gxc09)*換匯標準(gxc11)
    #      存入銀行科目(nma05)   承作金額(gxe08)*入帳匯率(gxe10)*換匯標準(gxe11)
    # IF gxe02= 2.預售遠匯
    # 借方:應付遠匯款(gxd06)     承作金額(gxe08)*交割匯率(gxc10)*換匯標準(gxc11)
    #      存入銀行科目(nma05)   承作金額(gxe08)*入帳匯率(gxe10)*換匯標準(gxe11)
      #IF g_nmy.nmydmy3 = 'Y' THEN    #MOD-A50048 add   #MOD-A60097 mark
       IF l_nmydmy3 = 'Y' THEN                          #MOD-A60097
          LET l_npq.npq02 = l_npq.npq02 + 1
          LET l_npq.npq04 = ''                #MOD-AA0139
          #LET l_npq.npq04 = g_gxe.gxe12       #MOD-AA0139 #FUN-D10065 mark
          LET l_npq.npq06 = '1'   #借方
          LET l_npq.npq24 = g_gxe.gxe06
          IF g_gxe.gxe02 = '1' THEN
             IF p_npptype=0 THEN
                LET l_npq.npq03 = l_gxd.gxd02
             ELSE
                LET l_npq.npq03 = l_gxd.gxd021
             END IF
             LET l_npq.npq07 = g_gxe.gxe08 * g_gxc.gxc09 *  g_gxc.gxc11
             LET l_npq.npq25 = g_gxc.gxc09*g_gxc.gxc11  
          ELSE
             IF p_npptype=0 THEN
                LET l_npq.npq03 = l_gxd.gxd06
             ELSE
                LET l_npq.npq03 = l_gxd.gxd061
             END IF
             LET l_npq.npq07 = g_gxe.gxe08 * g_gxc.gxc10 *  g_gxc.gxc11
             LET l_npq.npq25 = g_gxc.gxc10*g_gxc.gxc11  
          END IF
          IF g_aza.aza17 = l_npq.npq24 THEN
             LET l_npq.npq07f = l_npq.npq07
             LET l_npq.npq25 = 1
          ELSE
             LET l_npq.npq07f = g_gxe.gxe08
          END IF
          LET g_npq25 = l_npq.npq25                     #No.FUN-9A0036
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          IF cl_null(l_npq.npq07f) THEN LET l_npq.npq07f = 0 END IF
#         CALL cl_digcut(l_npq.npq07,g_azi04) RETURNING l_npq.npq07   #FUN-A90036
          SELECT azi04 INTO t_azi04 FROM azi_file
            WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
       IF p_npptype = '1' THEN
#FUN-A40067 --Begin
          SELECT aaa03 INTO l_aaa03 FROM aaa_file
           WHERE aaa01 = g_bookno2
          SELECT azi04 INTO g_azi04_2 FROM azi_file
           WHERE azi01 = l_aaa03
#FUN-A40067 --End
          CALL s_newrate(g_bookno1,g_bookno2,
                         l_npq.npq24,g_npq25,l_npp.npp02)
          RETURNING l_npq.npq25
          LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)  #FUN-A40067
       ELSE
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
       END IF
#No.FUN-9A0036 --End
          CALL cl_digcut(l_npq.npq07f,t_azi04) RETURNING l_npq.npq07f
         #LET l_npq.npq04 = l_npq.npq24 CLIPPED,l_npq.npq07f,'*',l_npq.npq25      #MOD-AA0139 mark
          LET l_damt1 = l_damt1 + l_npq.npq07
          IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF
          CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)       #No.FUN-730032
           RETURNING  l_npq.*
          #FUN-D10065--add--str--
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = g_gxe.gxe12
          END IF
          #FUN-D10065--add--end
          CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
         #-MOD-AA0139-add-
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = l_npq.npq24 CLIPPED,l_npq.npq07f,'*',l_npq.npq25
          END IF
         #-MOD-AA0139-end-
          LET l_npq.npqlegal = g_legal 
          #FUN-D40118--add--str--
          SELECT aag44 INTO g_aag44 FROM aag_file
           WHERE aag00 = g_bookno3
             AND aag01 = l_npq.npq03
          IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
             CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
             IF l_flag = 'N'   THEN
                LET l_npq.npq03 = ''
             END IF
          END IF
          #FUN-D40118--add--end--
          INSERT INTO npq_file VALUES(l_npq.*)
          IF STATUS THEN CALL cl_err('ins npq #11',STATUS,1) END IF
       END IF   #MOD-A50048 add
 
       #-->Dr.存入銀行科目(nma05)  承作金額(gxe08)*入帳匯率(gxe10)*換匯標準(gxe11)
       LET l_nma02 = ''
       SELECT nma02,nma05 INTO l_nma02,l_nma05 FROM nma_file 
        WHERE nma01 = g_gxe.gxe071 AND nmaacti = 'Y'
       LET l_npq.npq02 = l_npq.npq02 + 1
       IF p_npptype=0 THEN
          LET l_npq.npq03 = l_nma05
       ELSE
          LET l_npq.npq03 = l_nma051
       END IF
       LET l_npq.npq04 = ''                #MOD-AA0139
       #LET l_npq.npq04 = g_gxe.gxe12       #MOD-AA0139 #FUN-D10065 mark
       LET l_npq.npq06 = '1'
       LET l_npq.npq07 = g_gxe.gxe08 * g_gxe.gxe10 * g_gxe.gxe11
       LET l_npq.npq24 = g_gxe.gxe05  
       LET l_npq.npq25 = g_gxe.gxe10 * g_gxe.gxe11
       IF g_aza.aza17 = l_npq.npq24 THEN
          LET l_npq.npq07f = l_npq.npq07
          LET l_npq.npq25 = 1
       ELSE
          LET l_npq.npq07f = g_gxe.gxe08
       END IF
 
       IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
       IF cl_null(l_npq.npq07f) THEN LET l_npq.npq07f = 0 END IF
       LET g_npq25 = l_npq.npq25                     #No.FUN-9A0036             
#No.FUN-9A0036 --Begin
       IF p_npptype = '1' THEN
#FUN-A40067 --Begin
          SELECT aaa03 INTO l_aaa03 FROM aaa_file
           WHERE aaa01 = g_bookno2
          SELECT azi04 INTO g_azi04_2 FROM azi_file
           WHERE azi01 = l_aaa03
#FUN-A40067 --End
          CALL s_newrate(g_bookno1,g_bookno2,
                         l_npq.npq24,g_npq25,l_npp.npp02)
          RETURNING l_npq.npq25
          LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067         
       ELSE
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
       END IF
#No.FUN-9A0036 --End
#      CALL cl_digcut(l_npq.npq07,g_azi04) RETURNING l_npq.npq07 #FUN-A40067
       SELECT azi04 INTO t_azi04 FROM azi_file
         WHERE azi01 = l_npq.npq24
       CALL cl_digcut(l_npq.npq07f,t_azi04) RETURNING l_npq.npq07f
      #LET l_npq.npq04 = l_npq.npq24 CLIPPED,l_npq.npq07f,'*',l_npq.npq25    #MOD-AA0139 mark
       LET l_damt1 = l_damt1 + l_npq.npq07
       IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF
       CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)       #No.FUN-730032
        RETURNING  l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = g_gxe.gxe12
      END IF
      #FUN-D10065--add--end
       
      CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
      #-MOD-AA0139-add-
       IF cl_null(l_npq.npq04) THEN
          LET l_npq.npq04 = l_npq.npq24 CLIPPED,l_npq.npq07f,'*',l_npq.npq25
       END IF
      #-MOD-AA0139-end-
       LET l_npq.npqlegal = g_legal 
       #FUN-D40118--add--str--
       SELECT aag44 INTO g_aag44 FROM aag_file
        WHERE aag00 = g_bookno3
          AND aag01 = l_npq.npq03
       IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
          CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
          IF l_flag = 'N'   THEN
             LET l_npq.npq03 = ''
          END IF
       END IF
       #FUN-D40118--add--end--
       INSERT INTO npq_file VALUES(l_npq.*)
       IF STATUS THEN CALL cl_err('ins npq #11',STATUS,1) END IF
 
 
  #------------------- 貸方 ------------------------------------
  #IF gxe02= 1.預購遠匯
  # 貸方:應收遠匯款外幣(gxd01)   承作金額(gxe08)*交割匯率(gxc10)*換匯標準(gxc11)
  #      存入銀行科目(nma05)     承作金額(gxe08)*出帳匯率(gxe09)*換匯標準(gxe11)
  #
  #IF gxe02= 2.預售遠匯
  # 貸方:應收出售遠匯款(gxd05)   承作金額(gxe08)*即期匯率(gxc09)*換匯標準(gxc11)
  #      存入銀行科目(nma05)     承作金額(gxe08)*出帳匯率(gxe09)*換匯標準(gxe11)
 
      #IF g_nmy.nmydmy3 = 'Y' THEN    #MOD-A50048 add   #MOD-A60097 mark
       IF l_nmydmy3 = 'Y' THEN                          #MOD-A60097
          LET l_npq.npq02 = l_npq.npq02 + 1
          LET l_npq.npq04 = ''                #MOD-AA0139
          #LET l_npq.npq04 = g_gxe.gxe12       #MOD-AA0139 #FUN-D10065 mark
          LET l_npq.npq06 = '2'           
          LET l_npq.npq24 = g_gxe.gxe05
          IF g_gxe.gxe02 = '1' THEN               #預購遠匯
             IF p_npptype=0 THEN
                LET l_npq.npq03 = l_gxd.gxd01
             ELSE
                LET l_npq.npq03 = l_gxd.gxd011
             END IF
             LET l_npq.npq07 = g_gxe.gxe08 * g_gxc.gxc10 * g_gxc.gxc11
             LET l_npq.npq25 = g_gxc.gxc10 * g_gxc.gxc11   
          ELSE
             IF p_npptype=0 THEN
                LET l_npq.npq03 = l_gxd.gxd05
             ELSE
                LET l_npq.npq03 = l_gxd.gxd051
             END IF
             LET l_npq.npq07 = g_gxe.gxe08 * g_gxc.gxc09 * g_gxc.gxc11
             LET l_npq.npq25 = g_gxc.gxc09 * g_gxc.gxc11   
          END IF
          IF g_aza.aza17 = l_npq.npq24 THEN
             LET l_npq.npq07f = l_npq.npq07
             LET l_npq.npq25 = 1
          ELSE
             LET l_npq.npq07f = g_gxe.gxe08
          END IF
          LET g_npq25 = l_npq.npq25            #No.FUN-9A0036
 
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          IF cl_null(l_npq.npq07f) THEN LET l_npq.npq07f = 0 END IF
         #No.FUN-9A0036 --Begin
          IF p_npptype = '1' THEN
#FUN-A40067 --Begin
             SELECT aaa03 INTO l_aaa03 FROM aaa_file
              WHERE aaa01 = g_bookno2
             SELECT azi04 INTO g_azi04_2 FROM azi_file
              WHERE azi01 = l_aaa03
#FUN-A40067 --End
             CALL s_newrate(g_bookno1,g_bookno2,
                            l_npq.npq24,g_npq25,l_npp.npp02)
             RETURNING l_npq.npq25
             LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
             IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067
          ELSE
             IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
          END IF
         #No.FUN-9A0036 --End
#         CALL cl_digcut(l_npq.npq07,g_azi04) RETURNING l_npq.npq07   #MOD-5A0236 #FUN-A40067
          SELECT azi04 INTO t_azi04 FROM azi_file
            WHERE azi01 = l_npq.npq24
          CALL cl_digcut(l_npq.npq07f,t_azi04) RETURNING l_npq.npq07f
         #LET l_npq.npq04 = l_npq.npq24 CLIPPED,l_npq.npq07f,'*',l_npq.npq25  #MOD-AA0139 mark
          LET l_camt1 = l_camt1 + l_npq.npq07
          IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF   #部門
          CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)       #No.FUN-730032
           RETURNING  l_npq.*
          #FUN-D10065--add--str--
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = g_gxe.gxe12
          END IF
          #FUN-D10065--add--end
          
          CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
         #-MOD-AA0139-add-
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = l_npq.npq24 CLIPPED,l_npq.npq07f,'*',l_npq.npq25
          END IF
         #-MOD-AA0139-end-
          LET l_npq.npqlegal = g_legal 
          #FUN-D40118--add--str--
          SELECT aag44 INTO g_aag44 FROM aag_file
           WHERE aag00 = g_bookno3
             AND aag01 = l_npq.npq03
          IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
             CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
             IF l_flag = 'N'   THEN
                LET l_npq.npq03 = ''
             END IF
          END IF
          #FUN-D40118--add--end--
          INSERT INTO npq_file VALUES(l_npq.*)
          IF STATUS THEN CALL cl_err('ins npq #13',STATUS,1) END IF
       END IF   #MOD-A50048 add
 
 
       #-->Cr.存入銀行科目(nma05)  承作金額(gxe08)*出帳匯率(gxe09)*換匯標準(gxe11)
       SELECT nma02,nma05 INTO l_nma02,l_nma05 FROM nma_file   
        WHERE nma01 = g_gxe.gxe07 AND nmaacti = 'Y'
       LET l_npq.npq02 = l_npq.npq02 + 1
       IF p_npptype=0 THEN
          LET l_npq.npq03 = l_nma05
       ELSE
          LET l_npq.npq03 = l_nma051
       END IF
       LET l_npq.npq04 = ''                #MOD-AA0139
       #LET l_npq.npq04 = g_gxe.gxe12       #MOD-AA0139 #FUN-D10065 mark
       LET l_npq.npq06 = '2'
       LET l_npq.npq07 = g_gxe.gxe08 * g_gxe.gxe09 * g_gxe.gxe11
       LET l_npq.npq24 = g_gxe.gxe06  
       LET l_npq.npq25 = g_gxe.gxe09 * g_gxe.gxe11
       IF g_aza.aza17 = l_npq.npq24 THEN
          LET l_npq.npq07f = l_npq.npq07
          LET l_npq.npq25 = 1 
       ELSE
          LET l_npq.npq07f = g_gxe.gxe08
       END IF
       LET g_npq25 = l_npq.npq25                     #No.FUN-9A0036
 
       IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
       IF cl_null(l_npq.npq07f) THEN LET l_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
       IF p_npptype = '1' THEN
#FUN-A40067 --Begin
          SELECT aaa03 INTO l_aaa03 FROM aaa_file
           WHERE aaa01 = g_bookno2
          SELECT azi04 INTO g_azi04_2 FROM azi_file
           WHERE azi01 = l_aaa03
#FUN-A40067 --End
          CALL s_newrate(g_bookno1,g_bookno2,
                         l_npq.npq24,g_npq25,l_npp.npp02)
          RETURNING l_npq.npq25
          LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)  #FUN-A40067
       ELSE
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
       END IF
#No.FUN-9A0036 --End
#      CALL cl_digcut(l_npq.npq07,g_azi04) RETURNING l_npq.npq07 #FUN-A40067
       SELECT azi04 INTO t_azi04 FROM azi_file
         WHERE azi01 = l_npq.npq24
       CALL cl_digcut(l_npq.npq07f,t_azi04) RETURNING l_npq.npq07f
      #LET l_npq.npq04 = l_npq.npq24 CLIPPED,l_npq.npq07f,'*',l_npq.npq25    #MOD-AA0139 mark
       LET l_camt1 = l_camt1 + l_npq.npq07
       IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF
       CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)       #No.FUN-730032
        RETURNING  l_npq.*
       #FUN-D10065--add--str--
       IF cl_null(l_npq.npq04) THEN
          LET l_npq.npq04 = g_gxe.gxe12
       END IF
       #FUN-D10065--add--end
        
       CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
      #-MOD-AA0139-add-
       IF cl_null(l_npq.npq04) THEN
          LET l_npq.npq04 = l_npq.npq24 CLIPPED,l_npq.npq07f,'*',l_npq.npq25
       END IF
      #-MOD-AA0139-end-
       LET l_npq.npqlegal = g_legal 
       #FUN-D40118--add--str--
       SELECT aag44 INTO g_aag44 FROM aag_file
        WHERE aag00 = g_bookno3
          AND aag01 = l_npq.npq03
       IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
          CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
          IF l_flag = 'N'   THEN
             LET l_npq.npq03 = ''
          END IF
       END IF
       #FUN-D40118--add--end--
       INSERT INTO npq_file VALUES(l_npq.*)
       IF STATUS THEN CALL cl_err('ins npq #14',STATUS,1) END IF
       #-----------------購入遠匯 溢/折價----------------------------------
       # IF (借方金額 - 貸方金額 ) > 0
       #     貸方:外匯匯兌收益(gxd09)     借方金額 - 貸方金額
       # ELSE
       #     借方:外匯匯兌損失(gxd10)     貸方金額 - 借方金額
       #
       LET l_damt1 = l_damt1 - l_camt1  #差額(借-貸)
       IF l_damt1 <> 0 THEN
          LET l_npq.npq02 = l_npq.npq02 + 1
          LET l_npq.npq04 = ''                #MOD-AA0139
          #LET l_npq.npq04 = g_gxe.gxe12       #MOD-AA0139 #FUN-D10065 mark
 
          IF l_damt1 > 0 THEN
             IF p_npptype = '0' THEN
                LET l_npq.npq03 = l_gxd.gxd09
             ELSE
                LET l_npq.npq03 = l_gxd.gxd091
             END IF
             LET l_npq.npq06 = '2'          #貸方
             LET l_npq.npq24 = g_aza.aza17
             LET l_npq.npq25 = 1
             LET l_npq.npq07 = l_damt1
          ELSE
             IF p_npptype = '0' THEN
                LET l_npq.npq03 = l_gxd.gxd10  #科目
             ELSE
                LET l_npq.npq03 = l_gxd.gxd101
             END IF
             LET l_damt1 =  l_damt1 * -1
             LET l_npq.npq06 = '1'          #借方
             LET l_npq.npq24 = g_aza.aza17  #原幣幣別
             LET l_npq.npq25 = 1            #匯率
             LET l_npq.npq07 = l_damt1      #差額
          END IF
          LET g_npq25 = l_npq.npq25         #FUN-A40067
         #LET l_npq.npq04 = g_aza.aza17 CLIPPED,' ',1,' ',l_damt1    #MOD-740063 #MOD-AA0139 mark
          LET l_npq.npq07f = 0   #MOD-5A0236
#No.FUN-9A0036 --Begin
          IF p_npptype = '1' THEN
#FUN-A40067 --Begin
             SELECT aaa03 INTO l_aaa03 FROM aaa_file
              WHERE aaa01 = g_bookno2
             SELECT azi04 INTO g_azi04_2 FROM azi_file
              WHERE azi01 = l_aaa03
#FUN-A40067 --End
             CALL s_newrate(g_bookno1,g_bookno2,
                            l_npq.npq24,g_npq25,l_npp.npp02)
             RETURNING l_npq.npq25
             LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
             IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)  #FUN-A40067
          ELSE
             IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
          END IF
#No.FUN-9A0036 --End
#         CALL cl_digcut(l_npq.npq07,g_azi04) RETURNING l_npq.npq07   #MOD-5A0236 #FUN-A40067 mark
          SELECT azi04 INTO t_azi04 FROM azi_file
            WHERE azi01 = l_npq.npq24
          CALL cl_digcut(l_npq.npq07f,t_azi04) RETURNING l_npq.npq07f
          IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF   #部門
          CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)       #No.FUN-730032
           RETURNING  l_npq.*
          #FUN-D10065--add--str--
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = g_gxe.gxe12
          END IF
          #FUN-D10065--add--end
          CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
         #-MOD-AA0139-add-
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = g_aza.aza17 CLIPPED,' ',1,' ',l_damt1   
          END IF
         #-MOD-AA0139-end-
 
          LET l_npq.npqlegal = g_legal 
          #FUN-D40118--add--str--
          SELECT aag44 INTO g_aag44 FROM aag_file
           WHERE aag00 = g_bookno3
             AND aag01 = l_npq.npq03
          IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
             CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
             IF l_flag = 'N'   THEN
                LET l_npq.npq03 = ''
             END IF
          END IF
          #FUN-D40118--add--end--
          INSERT INTO npq_file VALUES(l_npq.*)
          IF STATUS THEN 
             LET g_success = 'N'      #No.FUN-680088
             CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq #14",1)  #No.FUN-660148
          END IF
       END IF
 #----------------手續費 > 0 ----------------------------------------------
       #借:本票匯票手續費(nms58)        gxe18
       #貸:    手續費出帳銀行(gxe17)        gxe18
       IF g_gxe.gxe18 > 0 THEN
          LET l_nma05 = '' LET l_nma10 = ''
          #手續費出帳銀行(gxe17 -->nma05)
          SELECT nma05,nma051,nma10 INTO l_nma05,l_nma051,l_nma10 FROM nma_file
           WHERE nma01 = g_gxe.gxe17
          #------借方---------------------------------------------
          LET l_npq.npq02 = l_npq.npq02+1
          IF p_npptype = '0' THEN
             LET l_npq.npq03 = g_nms.nms58      #本票匯票手續費
          ELSE
             LET l_npq.npq03 = g_nms.nms581
          END IF
         #LET l_npq.npq04 = 'TT FEE'         #備註    #MOD-AA0139 mark
          LET l_npq.npq04 = ''                        #MOD-AA0139
          #LET l_npq.npq04 = g_gxe.gxe12               #MOD-AA0139 #FUN-D10065 mark
          LET l_npq.npq06 = '1'              #借方
          LET l_npq.npq07f= g_gxe.gxe18
          LET l_npq.npq07 = g_gxe.gxe18
          #LET l_npq.npq24 = l_nma10       #MOD-C30750  mark
          LET l_npq.npq24 = g_aza.aza17    #MOD-C30750  add
          LET l_npq.npq25 = 1
          LET g_npq25 = l_npq.npq25   #FUN-A40067
          IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF
#No.FUN-9A0036 --Begin
          IF p_npptype = '1' THEN
#FUN-A40067 --Begin
             SELECT aaa03 INTO l_aaa03 FROM aaa_file
              WHERE aaa01 = g_bookno2
             SELECT azi04 INTO g_azi04_2 FROM azi_file
              WHERE azi01 = l_aaa03
#FUN-A40067 --End
             CALL s_newrate(g_bookno1,g_bookno2,
                            l_npq.npq24,g_npq25,l_npp.npp02)
             RETURNING l_npq.npq25
             LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
             IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)  #FUN-A40067
          ELSE
             IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
          END IF
#No.FUN-9A0036 --End
#         CALL cl_digcut(l_npq.npq07,g_azi04) RETURNING l_npq.npq07 #FUN-A40067 mark
          SELECT azi04 INTO t_azi04 FROM azi_file
            WHERE azi01 = l_npq.npq24
          CALL cl_digcut(l_npq.npq07f,t_azi04) RETURNING l_npq.npq07f
          CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)       #No.FUN-730032
           RETURNING  l_npq.*
          
          #FUN-D10065--add--str--
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = g_gxe.gxe12
          END IF
          #FUN-D10065--add--end
          CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
         #-MOD-AA0139-add-
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = 'TT FEE'         #備註
          END IF
         #-MOD-AA0139-end-
          LET l_npq.npqlegal = g_legal 
          #FUN-D40118--add--str--
          SELECT aag44 INTO g_aag44 FROM aag_file
           WHERE aag00 = g_bookno3
             AND aag01 = l_npq.npq03
          IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
             CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
             IF l_flag = 'N'   THEN
                LET l_npq.npq03 = ''
             END IF
          END IF
          #FUN-D40118--add--end--
          INSERT INTO npq_file VALUES (l_npq.*)
          #------貸方---------------------------------------------
          IF STATUS THEN 
             LET g_success = 'N'      #No.FUN-680088
             CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq_c3",1)  #No.FUN-660148
          END IF
          LET l_npq.npq02 = l_npq.npq02+1
          IF p_npptype = '0' THEN
             LET l_npq.npq03 = l_nma05
          ELSE
             LET l_npq.npq03 = l_nma051
          END IF
          LET l_npq.npq04 = NULL #FUN-D10065
          LET l_npq.npq05 = ' '
          LET l_npq.npq06 = '2'
          LET l_npq.npq07f= g_gxe.gxe18
          LET l_npq.npq07 = g_gxe.gxe18
          IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF
#No.FUN-9A0036 --Begin
       IF p_npptype = '1' THEN
#FUN-A40067 --Begin
          SELECT aaa03 INTO l_aaa03 FROM aaa_file
           WHERE aaa01 = g_bookno2
          SELECT azi04 INTO g_azi04_2 FROM azi_file
           WHERE azi01 = l_aaa03
#FUN-A40067 --End
          CALL s_newrate(g_bookno1,g_bookno2,
                         l_npq.npq24,g_npq25,l_npp.npp02)
          RETURNING l_npq.npq25
          LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)  #FUN-A40067
       ELSE
          IF cl_null(l_npq.npq07) THEN LET l_npq.npq07 = 0 END IF
          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
       END IF
#No.FUN-9A0036 --End
#         CALL cl_digcut(l_npq.npq07,g_azi04) RETURNING l_npq.npq07 #FUN-A40067 mark
          SELECT azi04 INTO t_azi04 FROM azi_file
            WHERE azi01 = l_npq.npq24
          CALL cl_digcut(l_npq.npq07f,t_azi04) RETURNING l_npq.npq07f
          CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)       #No.FUN-730032
           RETURNING  l_npq.*
 
          CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
          LET l_npq.npqlegal = g_legal 
          #FUN-D40118--add--str--
          SELECT aag44 INTO g_aag44 FROM aag_file
           WHERE aag00 = g_bookno3
             AND aag01 = l_npq.npq03
          IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
             CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
             IF l_flag = 'N'   THEN
                LET l_npq.npq03 = ''
             END IF
          END IF
          #FUN-D40118--add--end--
          INSERT INTO npq_file VALUES (l_npq.*)
          IF STATUS THEN 
             LET g_success = 'N'      #No.FUN-680088
             CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq_c4",1)  #No.FUN-660148
          END IF
      END IF
    CALL t420_gen_diff(l_npp.*)       #FUN-A40033
    CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021   
    CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
    MESSAGE g_msg CLIPPED
END FUNCTION
 
#FUNCTION t420_x()                          #FUN-D20035
FUNCTION t420_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_anmshut(0) THEN RETURN END IF
   SELECT * INTO g_gxe.* FROM gxe_file WHERE gxe01 =g_gxe.gxe01
                                         AND gxe011=g_gxe.gxe011 #no.6537
                                         AND gxe19 = g_gxe.gxe19  #FUN-8B0013
   IF g_gxe.gxe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_gxe.gxe13 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_gxe.gxe13 ='X' THEN RETURN END IF
   ELSE
      IF g_gxe.gxe13 <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
   OPEN t420_cl USING g_gxe.gxe01,g_gxe.gxe011
   IF STATUS THEN
      CALL cl_err("OPEN t420_cl:", STATUS, 1)
      CLOSE t420_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t420_cl INTO g_gxe.*  #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_gxe.gxe01,SQLCA.sqlcode,0)#資料被他人LOCK
       CLOSE t420_cl ROLLBACK WORK RETURN
   END IF
   #-->void轉換01/08/15
  #IF cl_void(0,0,g_gxe.gxe13)   THEN                #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
        LET g_chr=g_gxe.gxe13
       #IF g_gxe.gxe13 ='N' THEN                                       #FUN-D20035
        IF p_type = 1 THEN                                             #FUN-D20035
            LET g_gxe.gxe13='X'
        ELSE
            LET g_gxe.gxe13='N'
        END IF
        UPDATE gxe_file SET gxe13 =g_gxe.gxe13
               WHERE gxe01 = g_gxe.gxe01
                 AND gxe011= g_gxe.gxe011 #no.6537
                 AND gxe19 = g_gxe.gxe19   #FUN-8B0013
    IF STATUS THEN 
       CALL cl_err3("upd","gxe_file",g_gxe.gxe01,g_gxe.gxe011,STATUS,"","upd gxe13:",1)  #No.FUN-660148
       LET g_success='N' END IF
    IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
    SELECT gxe13 INTO g_gxe.gxe13 FROM gxe_file
     WHERE gxe01 = g_gxe.gxe01
       AND gxe011= g_gxe.gxe011  #no.6537
       AND gxe19 = g_gxe.gxe19   #FUN-8B0013
    DISPLAY BY NAME g_gxe.gxe13
   END IF
END FUNCTION
 
FUNCTION t420_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gxe01,gxe19",TRUE) #FUN-8B0013 add gxe19
   END IF
END FUNCTION
 
FUNCTION t420_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gxe01,gxe19",FALSE) #FUN-8B0013
   END IF
END FUNCTION
 
FUNCTION t420_gen_glcr(p_gxe,p_nmy)
  DEFINE p_gxe     RECORD LIKE gxe_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_gxe.gxe01,'axr-070',1)  
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t420_v('0')
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL t420_v('1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t420_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5      #No.FUN-680107 SMALLINT 
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5      #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_gxe.gxe14) OR g_gxe.gxe14 IS NOT NULL THEN
       CALL cl_err(g_gxe.gxe14,'aap-618',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxe.gxe01) RETURNING g_t1  
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN  #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gxe.gxe14,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_gxe.gxe14,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN
    END IF
    IF cl_null(l_nmygslp) OR (cl_null(g_nmy.nmygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680088
       CALL cl_err(g_gxe.gxe01,'axr-070',1)  
       RETURN
    END IF
   LET g_wc_gl = 'npp01 = "',g_gxe.gxe01,'" AND npp011 = ',g_gxe.gxe011
    LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_gxe.gxe04,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT gxe14,gxe141 INTO g_gxe.gxe14,g_gxe.gxe141 FROM gxe_file
     WHERE gxe01 = g_gxe.gxe01  
    DISPLAY BY NAME g_gxe.gxe14
    DISPLAY BY NAME g_gxe.gxe141
    
END FUNCTION
 
FUNCTION t420_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF cl_null(g_gxe.gxe14) OR g_gxe.gxe14 IS NULL THEN
       CALL cl_err(g_gxe.gxe14,'aap-619',1)
       RETURN 
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
   CALL s_get_doc_no(g_gxe.gxe01) RETURNING g_t1  
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_gxe.gxe14,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_gxe.gxe14,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxe.gxe14,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT gxe14,gxe141 INTO g_gxe.gxe14,g_gxe.gxe141 FROM gxe_file
     WHERE gxe01 = g_gxe.gxe01
    DISPLAY BY NAME g_gxe.gxe14
    DISPLAY BY NAME g_gxe.gxe141
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/15
#FUN-A40033 --Begin
FUNCTION t420_gen_diff(p_npp)
DEFINE p_npp   RECORD LIKE npp_file.*
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag           LIKE type_file.chr1    #FUN-D40118 add
   IF p_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(p_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(YEAR(p_npp.npp02),'aoo-081',1)
         LET g_success = 'N'
      END IF
      LET g_bookno3 = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno3
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = p_npp.npp00
            AND npq01 = p_npp.npp01
            AND npq011= p_npp.npp011
            AND npqsys= p_npp.nppsys
         LET l_npq1.npqtype = p_npp.npptype
         LET l_npq1.npq00 = p_npp.npp00
         LET l_npq1.npq01 = p_npp.npp01
         LET l_npq1.npq011= p_npp.npp011
         LET l_npq1.npqsys= p_npp.nppsys
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f = l_npq1.npq07
         LET l_npq1.npqlegal = g_legal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",p_npp.npp01,"",STATUS,"","",1)
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
