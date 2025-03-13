# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: anmt605.4gl
# Descriptions...: 投資購買維護作業
# Date & Author..: 02/01/04 By faith
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify.........: No.FUN-4B0052 04/11/24 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.MOD-590401 05/09/21 By Smapmin 由anmt600帶出預設值
# Modify.........: No.FUN-590111 05/09/27 By Nicola 畫面功能大調，並新增分錄底稿功能
# Modify.........: No.FUN-5A0004 05/10/03 By Nicola 畫面欄位調整，存提異動碼需考慮' 存' 或 '提'
# Modify.........: No.MOD-5A0238 05/10/21 By Nicola 修改匯率，一律更新本幣金額
# Modify.........: No.MOD-5A0317 05/10/21 By Nicola 單別設定不拋轉傳票，可直接確認
# Modify.........: No.MOD-5A0269 05/10/21 By Nicola 單別放大為5碼
# Modify.........: NO.MOD-5B0155 05/11/17 BY yiting 應改為 gsb15=gsb15-g_gsh.gsh16-g_gsh.gsh20
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL   CALL s_def_npq() 依設定
#                                                   給摘要與異動碼預設值
# Modify.........: No.FUN-630020 06/03/08 By pengu 流程訊息通知功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660054 06/06/12 By Smapmin 購買編號開窗有問題
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/03 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680088 06/08/29 By day 多帳套修改
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6B0116 06/11/27 By Smapmin 貸方分錄也要有二筆
# Modify.........: No.MOD-710045 07/01/08 By Smapmin 修改單位價格gsb09計算方式
# Modify.........: No.FUN-710070 07/02/07 By rainy 新增所屬部門 gsh26
# Modify.........: No.FUN-6C0051 07/02/13 By rainy 新增三個處理應付票據action
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-760005 07/06/20 By kim 出帳銀行是活存不應可產生應付票據
# Modify.........: No.MOD-760145 07/06/29 By Smapmin 修改幣別位數取位
# Modify.........: NO.TQC-790093 07/09/20 BY yiting Primary Key的-268訊息 程式修改
# Modify.........: No.MOD-7C0184 07/12/25 By Smapmin 修改Transaction架構
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810247 08/01/31 By Smapmin 分錄金額為0者,不產生分錄
# Modify.........: No.MOD-840540 08/04/22 By Smapmin 需過濾無效的費用代碼
# Modify.........: No.MOD-840411 08/04/24 By bnlent  生成的應付票據金額不可為0
# Modify.........: No.FUN-850038 08/05/13 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-870024 08/07/08 By Sarah 將MOD-5B0155修改段搬到取消確認段,確認段gsb15改回原先的計算方式
# Modify.........: No.MOD-8B0080 08/11/07 By Sarah gsh12異動時要重算gsh06=gsh12*gsh09,gsh12=0時要以gsh12=gsh06/gsh09回推
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.FUN-970003 09/07/13 By douzh 增加列印功能
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30007 10/03/03 By Carrier intialize variable         
# Modify.........: No.TQC-A30008 10/03/03 By Carrier nme26 赋值
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.TQC-AB0325 10/12/01 By chenying 新增至 nme_file 失敗
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No:FUN-AA0087 11/01/28 By Mengxw 異動碼類型設定改善
# Modify.........: No:MOD-B20105 11/02/22 By Dido 產生應付票據時,簡稱相關資料應使用 nma_file
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50065 11/06/09 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file  
# Modify.........: No:CHI-B70050 11/08/10 By Polly 新增權限Action控管
# Modify.........: No.MOD-BC0009 11/12/02 By Dido 單別檢核判斷條件調整 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30829 12/03/23 By Polly 呼叫anmp400時，第二與第三參數改用gshuse
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No:FUN-C80018 12/08/06 By minpp 大陸版時如果anmi030沒有維護單身時，anmt100單頭的簿號和支票號碼可以手動輸入
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.FUN-D10065 13/01/17 By wangrr 在調用s_def_npq前npq04=NULL
# Modify.........: No:FUN-D10116 13/03/07 By Polly 增加作廢功能
# Modify.........: No:FUN-D40118 13/05/20 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_gsh          RECORD LIKE gsh_file.*,
    g_gsh_t        RECORD LIKE gsh_file.*,
    g_gsh_o        RECORD LIKE gsh_file.*,
    g_npp          RECORD LIKE npp_file.*,   #No.FUN-590111
    g_npq          RECORD LIKE npq_file.*,   #No.FUN-590111
    g_gsh01_t      LIKE gsh_file.gsh01,
    g_wc,g_sql     STRING,
    g_cmd          LIKE type_file.chr1000,   #No.FUN-680107 VARCHAR(300)
    g_nmydmy1      LIKE nmy_file.nmydmy1,    #MOD-AC0073
    g_nmydmy3      LIKE nmy_file.nmydmy3,    #MOD-AC0073
    g_t1           LIKE oay_file.oayslip     #No.FUN-550057 #No.FUN-680107 VARCHAR(5)
 
DEFINE g_forupd_sql         STRING           #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  STRING
 
DEFINE   g_cnt     LIKE type_file.num10      #No.FUN-680107 INTEGER
DEFINE   g_i       LIKE type_file.num5       #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg     LIKE ze_file.ze03         #No.FUN-680107 VARCHAR(72)
DEFINE   g_msg2    LIKE ze_file.ze03         #No.FUN-6C0051
DEFINE   g_str     STRING                    #No.FUN-670060
DEFINE   g_wc_gl   STRING,                   #No.FUN-670060
         g_dbs_gl  LIKE type_file.chr21      #No.FUN-670060 #NO.FUN-680107 VARCHAR(21)
DEFINE g_flag        LIKE type_file.chr1    #No.FUN-730032
DEFINE g_bookno1     LIKE aza_file.aza81    #No.FUN-730032
DEFINE g_bookno2     LIKE aza_file.aza82    #No.FUN-730032
DEFINE g_bookno3     LIKE aza_file.aza82    #No.FUN-730032
 
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE   g_argv1        LIKE oea_file.oea01     #NO.FUN-680107 VARCHAR(16) #No.FUN-630020 add
DEFINE   g_argv2        STRING                  #No.FUN-630020 add
DEFINE   g_npq25        LIKE npq_file.npq25     #No.FUN-9A0036
DEFINE   g_void         LIKE type_file.chr1     #FUN-D10116 add
DEFINE   g_aag44        LIKE aag_file.aag44     #FUN-D40118 add


MAIN
DEFINE   p_row,p_col    LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
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
    LET g_argv1=ARG_VAL(1)          #No.FUN-630020 add
    LET g_argv2=ARG_VAL(2)          #No.FUN-630020 add
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    INITIALIZE g_gsh.* TO NULL
    INITIALIZE g_gsh_t.* TO NULL
    INITIALIZE g_gsh_o.* TO NULL
    CALL s_get_doc_no(g_gsh.gsh01) RETURNING g_t1     #No.FUN-550071
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
 
    LET g_forupd_sql = "SELECT * FROM gsh_file WHERE gsh01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t605_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 5 LET p_col = 3
 
    OPEN WINDOW t605_w AT p_row,p_col
      WITH FORM "anm/42f/anmt605" ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
   # 先以g_argv2判斷直接執行哪種功能
   # 執行I時，g_argv1是單號
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t605_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t605_a()
            END IF
         OTHERWISE
                CALL t605_q()
      END CASE
   END IF
    LET g_action_choice=""
 
    CALL t605_menu()
 
    CLOSE WINDOW t605_w
 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
END MAIN
 
FUNCTION t605_cs()
 DEFINE l_gsb05   LIKE gsb_file.gsb05,  #投資種類
        l_gsb06   LIKE gsb_file.gsb06,  #投資標的
        l_gsa02   LIKE gsa_file.gsa02   #投資種類名稱
 
    CLEAR FORM
 
    IF cl_null(g_argv1) THEN         #No.FUN-630020 add
   INITIALIZE g_gsh.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON gsh01,gsh02,gsh26,gsh03,gshconf,gsh21,gsh22,   #FUN-710070 #FUN-940036 拿掉gsh11
                                 gsh05,gsh04,gsh07,gsh08,gsh09,gsh10,gsh11,
                                 gsh12,gsh06,gsh13,gsh14,gsh15,gsh16,gsh17,  #No.FUN-5A0004
                                 gsh18,gsh19,gsh20,gsh27,gsh28,  #No.FUN-5A0004   #FUN-6C0051 add gsh27/gsh28
                                 gshuser,gshgrup,gshmodu,gshdate
                                ,gshud01,gshud02,gshud03,gshud04,gshud05,
                                gshud06,gshud07,gshud08,gshud09,gshud10,
                                gshud11,gshud12,gshud13,gshud14,gshud15
     
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
           ON ACTION CONTROLP
               CASE
                   WHEN INFIELD(gsh26)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gem"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh26
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh26
                   WHEN INFIELD(gsh01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gsh"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh01
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh01
                   WHEN INFIELD(gsh03)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gsb"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh03
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh03
                        SELECT gsb05,gsb06 INTO l_gsb05,l_gsb06
                          FROM gsb_file WHERE gsb01 = g_gsh.gsh03
                        SELECT gsa02 INTO l_gsa02 FROM gsa_file
                         WHERE gsa01 = l_gsb05
                        DISPLAY l_gsb05,l_gsb06,l_gsa02 TO gsb05,gsb06,gsa02
                        NEXT FIELD gsh03
                   WHEN INFIELD(gsh11)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nml"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh11
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh11
                        NEXT FIELD gsh11
                   WHEN INFIELD(gsh10)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nmc01"   #No.FUN-5A0004
                        LET g_qryparam.arg1 = "2"         #No.FUN-5A0004
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh10
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh10
                        NEXT FIELD gsh10
                   WHEN INFIELD(gsh07)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nma"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh07
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh07
                        NEXT FIELD gsh07
                   WHEN INFIELD(gsh08)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_azi"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh08
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh08
                        NEXT FIELD gsh08
                   WHEN INFIELD(gsh13)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gsf"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh13
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh13
                        NEXT FIELD gsh13
                   WHEN INFIELD(gsh18)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nml"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh18
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh18
                        NEXT FIELD gsh18
                   WHEN INFIELD(gsh17)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nmc01"   #No.FUN-5A0004
                        LET g_qryparam.arg1 = "2"         #No.FUN-5A0004
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh17
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh17
                        NEXT FIELD gsh17
                   WHEN INFIELD(gsh14)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nma"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh14
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh14
                        NEXT FIELD gsh14
                   WHEN INFIELD(gsh15)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_azi"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gsh.gsh15
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gsh15
                        NEXT FIELD gsh15
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
       #資料權限的檢查
     ELSE
        LET g_wc =" gsh01 = '",g_argv1,"'"
     END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gshuser', 'gshgrup')
 
 
    LET g_sql="SELECT gsh01 FROM gsh_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY gsh01"
    PREPARE t605_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE t605_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t605_prepare
 
    LET g_sql = "SELECT COUNT(*) FROM gsh_file WHERE ",g_wc CLIPPED
    PREPARE t605_precount FROM g_sql
    DECLARE t605_count CURSOR FOR t605_precount
 
END FUNCTION
 
FUNCTION t605_menu()
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_aza.aza63 != 'Y' THEN
               CALL cl_set_act_visible("maintain_entry_sheet2",FALSE)
            ELSE
               CALL cl_set_act_visible("maintain_entry_sheet2",TRUE)
            END IF
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t605_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t605_q()
            END IF
        ON ACTION next
            CALL t605_fetch('N')
        ON ACTION previous
            CALL t605_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t605_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t605_r()
            END IF
 
        ON ACTION output    
            LET g_action_choice="output"      #No.CHI-B70050 add                                                    
            IF cl_chk_act_auth() THEN                                           
               IF NOT cl_null(g_wc) THEN                                        
                 #LET g_msg = 'anmr606 "',g_today,'" "',g_user,    #FUN-C30085 mark          
                  LET g_msg = 'anmg606 "',g_today,'" "',g_user,    #FUN-C30085 add
                              '" "',g_lang,'" ',' "Y" " " "1" "',g_gsh.gsh01,'" "N"'
                  CALL cl_cmdrun(g_msg)                                         
               END IF                                                           
            END IF                                                              
 
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
                CALL t605_firm1()
               #CALL cl_set_field_pic(g_gsh.gshconf,"","","","","")        #FUN-D10116 mark
                CALL cl_set_field_pic(g_gsh.gshconf,"","","",g_void,"")    #FUN-D10116 add
            END IF
 
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
                CALL t605_firm2()
               #CALL cl_set_field_pic(g_gsh.gshconf,"","","","","")        #FUN-D10116 mark
                CALL cl_set_field_pic(g_gsh.gshconf,"","","",g_void,"")    #FUN-D10116 add
            END IF

       #--------------FUN-D10116---------------(S)
        ON ACTION void
           LET g_action_choice = "void"
           IF cl_chk_act_auth() THEN
              CALL t605_x()
              IF g_gsh.gshconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_gsh.gshconf,"","","",g_void,"")
           END IF
       #--------------FUN-D10116---------------(E)
 
        ON ACTION carry_voucher
           IF cl_chk_act_auth() THEN
              IF g_gsh.gshconf = 'Y' THEN
                 CALL t605_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
              END IF
           END IF
        ON ACTION undo_carry_voucher
           IF cl_chk_act_auth() THEN
              IF g_gsh.gshconf = 'Y' THEN
                 CALL t605_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
              END IF
           END IF
        ON ACTION gen_entry_sheet
           LET g_action_choice="gen_entry_sheet"          #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                      #No.CHI-B70050 add
              CALL t605_g_gl(g_gsh.gsh01,'0')
              IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                 CALL t605_g_gl(g_gsh.gsh01,'1')
              END IF
           END IF                                         #No.CHI-B70050 add
 
        ON ACTION maintain_entry_sheet
           LET g_action_choice="maintain_entry_sheet"     #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                      #No.CHI-B70050 add
              CALL s_fsgl('NM',19,g_gsh.gsh01,0,g_nmz.nmz02b,4,g_gsh.gshconf,'0',g_nmz.nmz02p)
              CALL cl_navigator_setting( g_curs_index, g_row_count )
              CALL t605_npp02('0')
           END IF                                         #No.CHI-B70050 add
 
        ON ACTION maintain_entry_sheet2
           LET g_action_choice="maintain_entry_sheet2"     #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                       #No.CHI-B70050 add
              CALL s_fsgl('NM',19,g_gsh.gsh01,0,g_nmz.nmz02c,4,g_gsh.gshconf,'1',g_nmz.nmz02p)
              CALL cl_navigator_setting( g_curs_index, g_row_count )
              CALL t605_npp02('1')
           END IF                                          #No.CHI-B70050 add
 
        ON ACTION gen_n_p
            LET g_action_choice="gen_n_p"      #No.CHI-B70050 add
            IF cl_chk_act_auth() THEN
              CALL t605_g_np()
            END IF

        ON ACTION modify_n_p
            LET g_action_choice="modify_n_p"      #No.CHI-B70050 add
            IF cl_chk_act_auth() THEN
              CALL t605_modify_np()
            END IF
        ON ACTION undo_n_p
            LET g_action_choice="undo_n_p"      #No.CHI-B70050 add
            IF cl_chk_act_auth() THEN
               CALL t605_del_np()
            END IF
 
        ON ACTION help
            CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          #CALL cl_set_field_pic(g_gsh.gshconf,"","","","","")        #FUN-D10116 mark
           CALL cl_set_field_pic(g_gsh.gshconf,"","","",g_void,"")    #FUN-D10116 add
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL t605_fetch('/')
 
        ON ACTION first
            CALL t605_fetch('F')
 
        ON ACTION last
            CALL t605_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_gsh.gsh01 IS NOT NULL THEN
                 LET g_doc.column1 = "gsh01"
                 LET g_doc.value1 = g_gsh.gsh01
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
    CLOSE t605_cs
END FUNCTION
 
FUNCTION t605_a()
DEFINE   l_sta       LIKE type_file.chr4,   #NO.FUN-680107 VARCHAR(04)
         l_time      LIKE ooy_file.ooytype  #NO.FUN-680107 VARCHAR(05)
DEFINE   li_result   LIKE type_file.num5    #No.FUN-550057 #No.FUN-680107 SMALLINT
 
    IF s_anmshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                              # 清螢幕欄位內容
    INITIALIZE g_gsh.* LIKE gsh_file.*
    LET g_gsh_t.*     = g_gsh.*
    LET g_gsh01_t     = NULL
    LET g_gsh.gshuser = g_user
    LET g_gsh.gshoriu = g_user #FUN-980030
    LET g_gsh.gshorig = g_grup #FUN-980030
    LET g_gsh.gshgrup = g_grup              #使用者所屬群
    LET g_gsh.gshdate = g_today
    LET g_gsh.gsh02   = g_today
    LET g_gsh.gshconf = 'N'
    LET g_gsh.gsh04 = 0
    LET g_gsh.gsh05 = 0
    LET g_gsh.gsh06 = 0
    LET g_gsh.gsh09 = 1
    LET g_gsh.gsh12 = 0
    LET g_gsh.gsh16 = 1
    LET g_gsh.gsh19 = 0
    LET g_gsh.gsh20 = 0
    LET g_gsh.gshlegal = g_legal  
    CALL cl_opmsg('a')
 
    WHILE TRUE
 
        CALL t605_i("a")                         # 各欄位輸入
 
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_gsh.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
 
        IF cl_null(g_gsh.gsh01) THEN             # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        BEGIN WORK  #No.7875
        LET g_success='Y'   #MOD-7C0184
 
        CALL s_auto_assign_no("anm",g_gsh.gsh01,g_gsh.gsh02,"F","gsh_file","gsh01","","","")
             RETURNING li_result,g_gsh.gsh01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_gsh.gsh01
 
 
        INSERT INTO gsh_file VALUES (g_gsh.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","gsh_file",g_gsh.gsh01,"",SQLCA.sqlcode,"","t605_ins_gsh:",1)  #No.FUN-660148 #No.FUN-B80067---調整至回滾事務前---
           ROLLBACK WORK #No.7875
           LET g_success = 'N'
           CONTINUE WHILE
        ELSE
          #-MOD-AC0073-add-
           #---判斷是否立即confirm-----
           LET g_t1 = s_get_doc_no(g_gsh.gsh01)    
           SELECT nmydmy1,nmydmy3 INTO g_nmydmy1,g_nmydmy3
             FROM nmy_file
            WHERE nmyslip = g_t1 AND nmyacti = 'Y'
           IF g_nmydmy3 = 'Y' THEN
              IF cl_confirm('axr-309') THEN
                 CALL t605_g_gl(g_gsh.gsh01,'0')
                 IF g_aza.aza63 = 'Y' THEN
                    CALL t605_g_gl(g_gsh.gsh01,'1')
                 END IF
              END IF
           END IF
           IF g_nmydmy1 = 'Y' AND g_nmydmy3='N' THEN CALL t605_firm1() END IF
          #-MOD-AC0073-end-
           COMMIT WORK #No.7875
           CALL cl_flow_notify(g_gsh.gsh01,'I')
        END IF
 
 
        SELECT gsh01 INTO g_gsh.gsh01 FROM gsh_file WHERE gsh01 = g_gsh.gsh01
 
        LET g_gsh_t.* = g_gsh.*
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION t605_i(p_cmd)
    DEFINE
        p_cmd     LIKE type_file.chr1,  #No.FUN-680107 VARCHAR(1)
        l_flag    LIKE type_file.chr1,  #判斷必要欄位是否有輸入 #No.FUN-680107 VARCHAR(1)
        l_n       LIKE type_file.num10, #No.FUN-680107 INTEGER
        g_t1      LIKE oay_file.oayslip,#No.FUN-550057 #No.FUN-680107 VARCHAR(5)
        l_gsb05   LIKE gsb_file.gsb05,  #投資種類
        l_gsb06   LIKE gsb_file.gsb06,  #投資標的
        l_gsbconf LIKE gsb_file.gsbconf,
        l_gsa02   LIKE gsa_file.gsa02,  #投資種類名稱
        l_gsf02   LIKE gsf_file.gsf02   #No.FUN-590111
DEFINE  li_result LIKE type_file.num5   #No.FUN-550057 #No.FUN-680107 SMALLINT
DEFINE  l_cnt     LIKE type_file.num5   #FUN-710070 add
 
    INPUT BY NAME g_gsh.gshoriu,g_gsh.gshorig,g_gsh.gsh01,g_gsh.gsh02,g_gsh.gsh26,g_gsh.gsh03,g_gsh.gshconf,    #FUN-710070 add gsh26
                  g_gsh.gsh21,g_gsh.gsh22,g_gsh.gsh05,g_gsh.gsh04,
                  g_gsh.gsh07,g_gsh.gsh08,g_gsh.gsh09,g_gsh.gsh10,
                  g_gsh.gsh11,g_gsh.gsh12,g_gsh.gsh06,g_gsh.gsh13,  #No.FUN-5A0004
                  g_gsh.gsh14,g_gsh.gsh15,g_gsh.gsh16,g_gsh.gsh17,
                  g_gsh.gsh18,g_gsh.gsh19,g_gsh.gsh20,g_gsh.gshuser,  #No.FUN-5A0004
                  g_gsh.gshgrup,g_gsh.gshmodu,g_gsh.gshdate
                 ,g_gsh.gshud01,g_gsh.gshud02,g_gsh.gshud03,g_gsh.gshud04,
                  g_gsh.gshud05,g_gsh.gshud06,g_gsh.gshud07,g_gsh.gshud08,
                  g_gsh.gshud09,g_gsh.gshud10,g_gsh.gshud11,g_gsh.gshud12,
                  g_gsh.gshud13,g_gsh.gshud14,g_gsh.gshud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t605_set_entry(p_cmd)
            CALL t605_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("gsh01")
         CALL cl_set_docno_format("gsh03")
 
        AFTER FIELD gsh01
          #IF NOT cl_null(g_gsh.gsh01) AND (g_gsh.gsh01!=g_gsh_t.gsh01) THEN     #MOD-BC0009 mark
           IF NOT cl_null(g_gsh.gsh01) THEN                                      #MOD-BC0009   
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_gsh.gsh01 != g_gsh01_t) THEN  #MOD-BC0009
                 CALL s_check_no("anm",g_gsh.gsh01,g_gsh01_t,"F","gsh_file","gsh01","")
                    RETURNING li_result,g_gsh.gsh01
                 DISPLAY BY NAME g_gsh.gsh01
                 IF (NOT li_result) THEN
                    NEXT FIELD gsh01
                 END IF
              END IF       #MOD-BC0009
           END IF
 
        AFTER FIELD gsh02
            IF g_gsh.gsh02 <= g_nmz.nmz10 THEN  #no.5261
               CALL cl_err('','aap-176',1) NEXT FIELD gsh02
            END IF
 
        AFTER FIELD gsh03
            IF NOT cl_null(g_gsh.gsh03) THEN
               IF cl_null(g_gsh_t.gsh03) OR g_gsh.gsh03 != g_gsh_t.gsh03 THEN
                  LET l_gsbconf = ' '
                  SELECT gsb05,gsb06,gsb13,gsbconf
                    INTO l_gsb05,l_gsb06,g_gsh.gsh07,l_gsbconf
                    FROM gsb_file
                   WHERE gsb01 = g_gsh.gsh03
                  IF STATUS THEN
                     CALL cl_err3("sel","gsb_file", g_gsh.gsh03,"",STATUS,"","select gsb",1)  #No.FUN-660148
                     NEXT FIELD gsh03
                  END IF
                  IF l_gsbconf <> 'Y' THEN
                     CALL cl_err(g_gsh.gsh03,'anm-960',0)
                     NEXT FIELD gsh03
                  END IF
                  SELECT gsa02 INTO l_gsa02 FROM gsa_FILE
                   WHERE gsa01 = l_gsb05
                  DISPLAY l_gsb05,l_gsb06,l_gsa02 TO gsb05,gsb06,gsa02
                  SELECT nma10 INTO g_gsh.gsh08 FROM nma_file
                   WHERE nma01 = g_gsh.gsh07
                  LET g_gsh.gsh14 = g_gsh.gsh07
                  LET g_gsh.gsh15 = g_gsh.gsh08
                  DISPLAY BY NAME g_gsh.gsh07,g_gsh.gsh08,g_gsh.gsh14,g_gsh.gsh15
               END IF
            END IF
 
        AFTER FIELD gsh04
            IF cl_null(g_gsh_t.gsh04) OR g_gsh.gsh04 != g_gsh_t.gsh04 THEN  #No.MOD-5A0238
               LET g_gsh.gsh06 = g_gsh.gsh04 * g_gsh.gsh05
               LET g_gsh.gsh06 = cl_digcut(g_gsh.gsh06,g_azi04)   #MOD-760145
               LET g_gsh.gsh12 = g_gsh.gsh06 / g_gsh.gsh09   #No.MOD-5A0238
               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = g_gsh.gsh08
               LET g_gsh.gsh12 = cl_digcut(g_gsh.gsh12,t_azi04)
               DISPLAY BY NAME g_gsh.gsh06,g_gsh.gsh12       #No.MOD-5A0238
            END IF
 
        AFTER FIELD gsh06
            IF g_gsh.gsh06 < 0 THEN
               NEXT FIELD gsh06
            END IF
            LET g_gsh.gsh06 = cl_digcut(g_gsh.gsh06,g_azi04)   #MOD-760145
            DISPLAY BY NAME g_gsh.gsh06   #MOD-760145
            IF g_gsh.gsh09 = 1 THEN
               LET g_gsh.gsh12 = g_gsh.gsh06
               DISPLAY BY NAME g_gsh.gsh12
            ELSE
               IF g_gsh.gsh12 = 0 THEN
                  LET g_gsh.gsh12 = g_gsh.gsh06 / g_gsh.gsh09   #MOD-8B0080
                  SELECT azi04 INTO t_azi04 FROM azi_file
                    WHERE azi01 = g_gsh.gsh08
                  LET g_gsh.gsh12 = cl_digcut(g_gsh.gsh12,t_azi04)  #NO.CHI-6A0004
                  DISPLAY BY NAME g_gsh.gsh12
               END IF
            END IF
 
        BEFORE FIELD gsh07
            CALL t605_set_entry(p_cmd)
 
        AFTER FIELD gsh07
            IF NOT cl_null(g_gsh.gsh07) THEN
               SELECT nma10 INTO g_gsh.gsh08 FROM nma_file
                WHERE nma01 = g_gsh.gsh07
               IF STATUS THEN
                  CALL cl_err3("sel","nma_file",g_gsh.gsh07,"",STATUS,"","select nma",1)  #No.FUN-660148
                  NEXT FIELD gsh07
               END IF
               DISPLAY BY NAME g_gsh.gsh08
 
 
               IF cl_null(g_gsh_t.gsh07) OR g_gsh.gsh07 != g_gsh_t.gsh07 THEN
                  IF g_aza.aza17 = g_gsh.gsh08 THEN    #本幣
                     LET g_gsh.gsh09 = 1
                     LET g_gsh.gsh12 = g_gsh.gsh06   #No.FUN-5A0004
                  ELSE
                     CALL s_curr3(g_gsh.gsh08,g_gsh.gsh02,'B')
                     RETURNING g_gsh.gsh09
                  END IF
                  DISPLAY BY NAME g_gsh.gsh09,g_gsh.gsh12   #No.FUN-5A0004
                  IF g_gsh.gsh12 = 0 THEN
                     LET g_gsh.gsh12 = g_gsh.gsh06 * g_gsh.gsh09
                     SELECT azi04 INTO t_azi04 FROM azi_file
                       WHERE azi01 = g_gsh.gsh08
                     LET g_gsh.gsh12 = cl_digcut(g_gsh.gsh12,t_azi04) #NO.CHI-6A0004
                     DISPLAY BY NAME g_gsh.gsh12
                  END IF
               END IF
               CALL t605_set_no_entry(p_cmd)   #No.FUN-5A0004
            END IF
 
        AFTER FIELD gsh09   #匯率
            IF g_gsh.gsh08 =g_aza.aza17 THEN
               LET g_gsh.gsh09  =1
               DISPLAY BY NAME g_gsh.gsh09
            END IF
            IF cl_null(g_gsh_t.gsh09) OR g_gsh.gsh09 != g_gsh_t.gsh09 THEN
                  LET g_gsh.gsh12 = g_gsh.gsh06 / g_gsh.gsh09
                  SELECT azi04 INTO t_azi04 FROM azi_file
                    WHERE azi01 = g_gsh.gsh08
                  LET g_gsh.gsh12 = cl_digcut(g_gsh.gsh12,t_azi04)
                  DISPLAY BY NAME g_gsh.gsh12
            END IF
 
        AFTER FIELD gsh10
            IF NOT cl_null(g_gsh.gsh10) THEN
               SELECT nmc01 FROM nmc_file
                WHERE nmc01 = g_gsh.gsh10
               IF STATUS THEN
                  CALL cl_err3("sel","nmc_file",g_gsh.gsh10,"",STATUS,"","select nmc",1)  #No.FUN-660148
                  NEXT FIELD gsh10
               END IF
            END IF
 
        AFTER FIELD gsh11
            IF NOT cl_null(g_gsh.gsh11) THEN
               SELECT nml02 FROM nml_file
                WHERE nml01 = g_gsh.gsh11
               IF STATUS THEN
                  CALL cl_err3("sel","nml_file",g_gsh.gsh11,"",STATUS,"","select nml",1)  #No.FUN-660148
                  NEXT FIELD gsh11
               END IF
            END IF
 
        AFTER FIELD gsh12
            IF g_gsh.gsh12 < 0 THEN
               NEXT FIELD gsh12
            END IF
            LET g_gsh.gsh06 = g_gsh.gsh12 * g_gsh.gsh09
            LET g_gsh.gsh06 = cl_digcut(g_gsh.gsh06,g_azi04)
            DISPLAY BY NAME g_gsh.gsh06
            SELECT azi04 INTO t_azi04 FROM azi_file
              WHERE azi01=g_gsh.gsh08
            LET g_gsh.gsh12 = cl_digcut(g_gsh.gsh12,t_azi04)
            DISPLAY BY NAME g_gsh.gsh12
 
        AFTER FIELD gsh13
           IF NOT cl_null(g_gsh.gsh13) THEN
              SELECT gsf02 INTO l_gsf02
                FROM gsf_file
               WHERE gsf01 = g_gsh.gsh13
                 AND gsfacti = 'Y'   #MOD-840540
               IF STATUS THEN
                  CALL cl_err3("sel","gsf_file",g_gsh.gsh13,"",STATUS,"","select nml",1)  #No.FUN-660148
                  NEXT FIELD gsh13
               END IF
               DISPLAY l_gsf02 TO gsf02
            END IF
 
        BEFORE FIELD gsh14
            CALL t605_set_entry(p_cmd)
 
        AFTER FIELD gsh14
            IF NOT cl_null(g_gsh.gsh14) THEN
               SELECT nma10 INTO g_gsh.gsh15 FROM nma_file
                WHERE nma01 = g_gsh.gsh14
               IF STATUS THEN
                  CALL cl_err3("sel","nma_file",g_gsh.gsh14,"",STATUS,"","select nma",1)  #No.FUN-660148
                  NEXT FIELD gsh14
               END IF
               DISPLAY BY NAME g_gsh.gsh15
 
 
               IF cl_null(g_gsh_t.gsh14) OR g_gsh.gsh14 != g_gsh_t.gsh14 THEN
                  IF g_aza.aza17 = g_gsh.gsh15 THEN    #本幣
                     LET g_gsh.gsh16 = 1
                     LET g_gsh.gsh19 = g_gsh.gsh20   #No.FUN-5A0004
                  ELSE
                     CALL s_curr3(g_gsh.gsh15,g_gsh.gsh02,'B')
                     RETURNING g_gsh.gsh16
                  END IF
                  DISPLAY BY NAME g_gsh.gsh16,g_gsh.gsh19   #No.FUN-5A0004
                  IF g_gsh.gsh20 = 0 THEN
                     LET g_gsh.gsh20 = g_gsh.gsh19 * g_gsh.gsh16
                     LET g_gsh.gsh20 = cl_digcut(g_gsh.gsh20,g_azi04)
                     DISPLAY BY NAME g_gsh.gsh20
                  END IF
               END IF
               CALL t605_set_no_entry(p_cmd)   #No.FUN-5A0004
            END IF
 
        AFTER FIELD gsh16   #匯率
            IF g_gsh.gsh15 =g_aza.aza17 THEN
               LET g_gsh.gsh16  =1
               DISPLAY BY NAME g_gsh.gsh16
            END IF
            IF cl_null(g_gsh_t.gsh16) OR g_gsh.gsh16 != g_gsh_t.gsh16 THEN
                  LET g_gsh.gsh20 = g_gsh.gsh19 * g_gsh.gsh16
                  LET g_gsh.gsh20 = cl_digcut(g_gsh.gsh20,g_azi04)
                  DISPLAY BY NAME g_gsh.gsh20
            END IF
 
        AFTER FIELD gsh17
            IF NOT cl_null(g_gsh.gsh17) THEN
               SELECT nmc01 FROM nmc_file
                WHERE nmc01 = g_gsh.gsh17
               IF STATUS THEN
                  CALL cl_err3("sel","nmc_file",g_gsh.gsh17,"",STATUS,"","select nmc",1)  #No.FUN-660148
                  NEXT FIELD gsh17
               END IF
            END IF
 
        AFTER FIELD gsh18
            IF NOT cl_null(g_gsh.gsh18) THEN
               SELECT nml02 FROM nml_file
                WHERE nml01 = g_gsh.gsh18
               IF STATUS THEN
                  CALL cl_err3("sel","nml_file",g_gsh.gsh18,"",STATUS,"","select nml",1)  #No.FUN-660148
                  NEXT FIELD gsh18
               END IF
            END IF
 
        AFTER FIELD gsh19
            IF g_gsh.gsh19 < 0 THEN
               NEXT FIELD gsh19
            END IF
            SELECT azi04 INTO t_azi04 FROM azi_file
              WHERE azi01=g_gsh.gsh15
            LET g_gsh.gsh19 = cl_digcut(g_gsh.gsh19,t_azi04)
            DISPLAY BY NAME g_gsh.gsh19
            IF cl_null(g_gsh_t.gsh19) OR g_gsh.gsh19 != g_gsh_t.gsh19 THEN
               IF g_gsh.gsh20 = 0 THEN
                  LET g_gsh.gsh20 = g_gsh.gsh19 * g_gsh.gsh16
                  LET g_gsh.gsh20 = cl_digcut(g_gsh.gsh20,g_azi04)
                  DISPLAY BY NAME g_gsh.gsh20
               END IF
            END IF
 
        AFTER FIELD gsh20
            IF g_gsh.gsh20 < 0 THEN
               NEXT FIELD gsh20
            END IF
            LET g_gsh.gsh20 = cl_digcut(g_gsh.gsh20,g_azi04)   #MOD-760145
            DISPLAY BY NAME g_gsh.gsh20   #MOD-760145
            IF g_gsh.gsh16 = 1 THEN
               LET g_gsh.gsh19 = g_gsh.gsh20
               DISPLAY BY NAME g_gsh.gsh19
            ELSE
               IF g_gsh.gsh19 = 0 THEN
                  LET g_gsh.gsh19 = g_gsh.gsh20 * g_gsh.gsh16
                  SELECT azi04 INTO t_azi04 FROM azi_file
                    WHERE azi01 = g_gsh.gsh15
                  LET g_gsh.gsh19 = cl_digcut(g_gsh.gsh19,t_azi04) #NO.CHI-6A0004
                  DISPLAY BY NAME g_gsh.gsh19
               END IF
            END IF
        AFTER FIELD gsh26  #所屬部門
          IF NOT cl_null(g_gsh.gsh26) THEN
            LET l_cnt = 0 
            SELECT COUNT(gem01) INTO l_cnt FROM gem_file 
             WHERE gem01 = g_gsh.gsh26
               AND gemacti = 'Y'
            IF l_cnt = 0 THEN
              CALL cl_err('','mfg3097',0)
              NEXT FIELD CURRENT
            END IF 
          END IF
 
        AFTER FIELD gshud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gshud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_gsh.gshuser = s_get_data_owner("gsh_file") #FUN-C10039
           LET g_gsh.gshgrup = s_get_data_group("gsh_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT  END IF
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(gsh26)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_gsh.gsh26
                     CALL cl_create_qry() RETURNING g_gsh.gsh26
                     DISPLAY BY NAME g_gsh.gsh26
                     NEXT FIELD gsh26
 
                WHEN INFIELD(gsh01)
                     LET g_t1 = s_get_doc_no(g_gsh.gsh01)       #No.FUN-550057
                     CALL q_nmy(FALSE,FALSE,g_t1,'F','ANM') RETURNING g_t1  #TQC-670008
                     LET g_gsh.gsh01 = g_t1     #No.FUN-550057
                     DISPLAY BY NAME g_gsh.gsh01
                     NEXT FIELD gsh01
                WHEN INFIELD(gsh03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gsb"
                     LET g_qryparam.default1 = g_gsh.gsh03
                     CALL cl_create_qry() RETURNING g_gsh.gsh03
                     DISPLAY BY NAME g_gsh.gsh03
                     SELECT gsb05,gsb06 INTO l_gsb05,l_gsb06
                       FROM gsb_file WHERE gsb01 = g_gsh.gsh03
                     SELECT gsa02 INTO l_gsa02 FROM gsa_file
                         WHERE gsa01 = l_gsb05
                     DISPLAY l_gsb05,l_gsb06,l_gsa02 TO gsb05,gsb06,gsa02
                     NEXT FIELD gsh03
                WHEN INFIELD(gsh11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nml"
                     LET g_qryparam.default1 = g_gsh.gsh11
                     CALL cl_create_qry() RETURNING g_gsh.gsh11
                     DISPLAY BY NAME g_gsh.gsh11
                     NEXT FIELD gsh11
                WHEN INFIELD(gsh10)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nmc01"   #No.FUN-5A0004
                     LET g_qryparam.arg1 = "2"         #No.FUN-5A0004
                     LET g_qryparam.default1 = g_gsh.gsh10
                     CALL cl_create_qry() RETURNING g_gsh.gsh10
                     DISPLAY BY NAME g_gsh.gsh10
                     NEXT FIELD gsh10
                WHEN INFIELD(gsh07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nma"
                     LET g_qryparam.default1 = g_gsh.gsh07
                     CALL cl_create_qry() RETURNING g_gsh.gsh07
                     DISPLAY BY NAME g_gsh.gsh07
                     NEXT FIELD gsh07
                WHEN INFIELD(gsh09)
                     CALL s_rate(g_gsh.gsh08,g_gsh.gsh09) RETURNING g_gsh.gsh09
                     DISPLAY BY NAME g_gsh.gsh09
                     NEXT FIELD gsh09
                WHEN INFIELD(gsh13)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gsf"
                     LET g_qryparam.default1 = g_gsh.gsh13
                     CALL cl_create_qry() RETURNING g_gsh.gsh13
                     DISPLAY BY NAME g_gsh.gsh13
                     NEXT FIELD gsh13
                WHEN INFIELD(gsh18)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nml"
                     LET g_qryparam.default1 = g_gsh.gsh18
                     CALL cl_create_qry() RETURNING g_gsh.gsh18
                     DISPLAY BY NAME g_gsh.gsh18
                     NEXT FIELD gsh18
                WHEN INFIELD(gsh17)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nmc01"   #No.FUN-5A0004
                     LET g_qryparam.arg1 = "2"         #No.FUN-5A0004
                     LET g_qryparam.default1 = g_gsh.gsh17
                     CALL cl_create_qry() RETURNING g_gsh.gsh17
                     DISPLAY BY NAME g_gsh.gsh17
                     NEXT FIELD gsh17
                WHEN INFIELD(gsh14)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nma"
                     LET g_qryparam.default1 = g_gsh.gsh14
                     CALL cl_create_qry() RETURNING g_gsh.gsh14
                     DISPLAY BY NAME g_gsh.gsh14
                     NEXT FIELD gsh14
                WHEN INFIELD(gsh16)
                     CALL s_rate(g_gsh.gsh15,g_gsh.gsh16) RETURNING g_gsh.gsh16
                     DISPLAY BY NAME g_gsh.gsh16
                     NEXT FIELD gsh16
                OTHERWISE EXIT CASE
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
 
FUNCTION t605_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gsh.* TO NULL              #No.FUN-6A0011
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL t605_cs()                          # 宣告 SCROLL CURSOR
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
 
    OPEN t605_count
    FETCH t605_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN t605_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gsh.gsh01,SQLCA.sqlcode,0)
        INITIALIZE g_gsh.* TO NULL
    ELSE
        CALL t605_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
 
END FUNCTION
 
FUNCTION t605_fetch(p_flgsh)
    DEFINE
        p_flgsh  LIKE type_file.chr1,     #處理的方式  #NO.FUN-680107 VARCHAR(1)
        l_abso   LIKE type_file.num10     #絕對的筆數  #No.FUN-680107 INTEGER
 
    CASE p_flgsh
        WHEN 'N' FETCH NEXT     t605_cs INTO g_gsh.gsh01
        WHEN 'P' FETCH PREVIOUS t605_cs INTO g_gsh.gsh01
        WHEN 'F' FETCH FIRST    t605_cs INTO g_gsh.gsh01
        WHEN 'L' FETCH LAST     t605_cs INTO g_gsh.gsh01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt mod
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
            FETCH ABSOLUTE g_jump t605_cs INTO g_gsh.gsh01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gsh.gsh01,SQLCA.sqlcode,0)
        INITIALIZE g_gsh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flgsh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_gsh.* FROM gsh_file    # 重讀DB,因TEMP有不被更新特性
     WHERE gsh01 = g_gsh.gsh01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","gsh_file",g_gsh.gsh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       LET g_data_owner = g_gsh.gshuser     #No.FUN-4C0063
       LET g_data_group = g_gsh.gshgrup     #No.FUN-4C0063
       CALL t605_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION t605_show()
DEFINE  l_gsb05    LIKE gsb_file.gsb05,    #投資種類
        l_gsb06    LIKE gsb_file.gsb06,    #投資標的
        l_gsa02    LIKE gsa_file.gsa02,    #投資種類名稱
        l_gsf02    LIKE gsf_file.gsf02     #No.FUN-590111
 
    LET g_gsh_t.* = g_gsh.*
 
    DISPLAY BY NAME g_gsh.gshoriu,g_gsh.gshorig, g_gsh.gsh01,g_gsh.gsh02,g_gsh.gsh26,g_gsh.gsh03,g_gsh.gsh04,   #FUN-710070 add gsh26
                    g_gsh.gsh05,g_gsh.gsh06,g_gsh.gsh07,g_gsh.gsh08,
                    g_gsh.gsh09,g_gsh.gsh10,g_gsh.gsh11,g_gsh.gsh12,
                    g_gsh.gsh13,g_gsh.gsh14,g_gsh.gsh15,g_gsh.gsh16,
                    g_gsh.gsh17,g_gsh.gsh18,g_gsh.gsh19,g_gsh.gsh20,
                    g_gsh.gsh27,g_gsh.gsh28,                          #FUN-6C0051 add
                    g_gsh.gsh21,g_gsh.gsh22,g_gsh.gshconf,g_gsh.gshuser,
                    g_gsh.gshgrup,g_gsh.gshmodu,g_gsh.gshdate
                   ,g_gsh.gshud01,g_gsh.gshud02,g_gsh.gshud03,g_gsh.gshud04,
                    g_gsh.gshud05,g_gsh.gshud06,g_gsh.gshud07,g_gsh.gshud08,
                    g_gsh.gshud09,g_gsh.gshud10,g_gsh.gshud11,g_gsh.gshud12,
                    g_gsh.gshud13,g_gsh.gshud14,g_gsh.gshud15 
    SELECT gsb05,gsb06 INTO l_gsb05,l_gsb06
      FROM gsb_file WHERE gsb01 = g_gsh.gsh03
    DISPLAY l_gsb05,l_gsb06 TO gsb05,gsb06
 
    SELECT gsa02 INTO l_gsa02 FROM gsa_file
     WHERE gsa01 = l_gsb05
    DISPLAY l_gsa02 TO gsa02
 
    SELECT gsf02 INTO l_gsf02 FROM gsf_file
     WHERE gsf01 = g_gsh.gsh13
    DISPLAY l_gsf02 TO gsf02
 
   #------------------------FUN-D10116---------------------------(S)
    IF g_gsh.gshconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_gsh.gshconf,"","","",g_void,"")
   #------------------------FUN-D10116---------------------------(E)
   #CALL cl_set_field_pic(g_gsh.gshconf,"","","","","")       #FUN-D10116 mark
 
END FUNCTION
 
FUNCTION t605_u()
 
    IF s_anmshut(0) THEN RETURN END IF
 
    IF g_gsh.gsh01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    SELECT * INTO g_gsh.* FROM gsh_file WHERE gsh01 = g_gsh.gsh01
 
    IF g_gsh.gshconf = 'Y' THEN
       CALL cl_err('','anm-137',0)
       RETURN
    END IF
 
   #----------------FUN-D10116-------------(S)
    IF g_gsh.gshconf = 'X' THEN
       CALL cl_err(g_gsh.gsh01,'9024',0)
       RETURN
    END IF
   #----------------FUN-D10116-------------(E)

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gsh01_t = g_gsh.gsh01
    LET g_gsh_o.*=g_gsh.*
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t605_cl USING g_gsh.gsh01
    IF STATUS THEN
       CALL cl_err("OPEN t605_cl:", STATUS, 1)
       CLOSE t605_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t605_cl INTO g_gsh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gsh.gsh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_gsh.gshmodu = g_user                     #修改者
    LET g_gsh.gshdate = g_today                  #修改日期
    CALL t605_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t605_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_success = 'N'
           LET g_gsh.*=g_gsh_t.*
           CALL t605_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
 
        UPDATE gsh_file SET gsh_file.* = g_gsh.*    # 更新DB
         WHERE gsh01 = g_gsh.gsh01             # COLAUTH?
 
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","gsh_file",g_gsh01_t,"",SQLCA.sqlcode,"","(t650_u:gsh)",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t605_cl
 
    IF g_success = 'Y'THEN
       CALL cl_cmmsg(1)
       COMMIT WORK
       CALL cl_flow_notify(g_gsh.gsh01,'U')
    ELSE
       CALL cl_rbmsg(1)
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION t605_firm1()
   DEFINE l_gsh01_old   LIKE gsh_file.gsh01
   DEFINE l_nme         RECORD LIKE nme_file.*
   DEFINE l_gsc         RECORD LIKE gsc_file.*
   DEFINE l_n           LIKE type_file.num10    #No.FUN-670060  #No.FUN-680107 INTEGER
   DEFINE l_gsb12       LIKE gsb_file.gsb12,   #MOD-710045
          l_t           LIKE oay_file.oayslip   #No.MOD-5A0269  #No.FUN-680107 VARCHAR(5)

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   IF cl_null(g_gsh.gsh02) THEN CALL cl_err('',-400,0) RETURN END IF
 
   SELECT * INTO g_gsh.* FROM gsh_file WHERE gsh01 = g_gsh.gsh01
 
   IF g_gsh.gshconf = 'Y' THEN
      RETURN
   END IF
 
  #----------------FUN-D10116-------------(S)
   IF g_gsh.gshconf = 'X' THEN
      CALL cl_err(g_gsh.gsh01,'9024',0)
      RETURN
   END IF
  #----------------FUN-D10116-------------(E)

#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_gsh.gsh02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_gsh.gsh01,'aap-176',1) RETURN
   END IF
 
   LET l_gsh01_old = g_gsh.gsh01
 
   IF NOT cl_sure(20,20) THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(g_gsh.gsh01)        #No.MOD-5A0269
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(g_nmy.nmydmy3) THEN
      LET g_nmy.nmydmy3 = 'N'
   END IF
 
    CALL s_get_bookno(YEAR(g_gsh.gsh02)) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '1' THEN
       CALL cl_err(YEAR(g_gsh.gsh02),'aoo-081',1)
       LET g_success = 'N'
    END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'N' THEN  #No.FUN-670060
      CALL s_chknpq(g_gsh.gsh01,'NM',4,'0',g_bookno1)       #No.FUN-730032
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_gsh.gsh01,'NM',4,'1',g_bookno2)       #No.FUN-730032
      END IF
      IF g_success ='N' THEN ROLLBACK WORK RETURN END IF    #MOD-7C0184
   END IF
 
   OPEN t605_cl USING g_gsh.gsh01
   IF STATUS THEN
      CALL cl_err("OPEN t605_cl:", STATUS, 1)
      CLOSE t605_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t605_cl INTO g_gsh.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsh.gsh01,SQLCA.sqlcode,0)#資料被他人LOCK
      CLOSE t605_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE gsb_file SET gsb10  = gsb10  + g_gsh.gsh05, #投資數量
                       gsb101 = gsb101 + g_gsh.gsh06, #投資金額
                       gsb15  = gsb15  + g_gsh.gsh06 + g_gsh.gsh20, #支出總額  #No.FUN-5A0004   #MOD-870024 mark回復
                       gsb12  = gsb12  + g_gsh.gsh05, #留倉數量
                       gsb121 = gsb121 + g_gsh.gsh06  #留倉金額
    WHERE gsb01 = g_gsh.gsh03
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","gsb_file",g_gsh.gsh03,"",STATUS,"","upd gsb",1)  #No.FUN-660148
       LET g_success = 'N'
   END IF
 
   #要update gsb09之前,必須先update gsb12,gsb121資料,取最新資料資料來update
   SELECT gsb12 INTO l_gsb12 FROM gsb_file
    WHERE gsb01 = g_gsh.gsh03
   IF l_gsb12 = 0 THEN
      UPDATE gsb_file SET gsb09  = 0                     #單位價格
       WHERE gsb01 = g_gsh.gsh03
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("upd","gsb_file",g_gsh.gsh03,"",STATUS,"","upd gsb1",1)  
          LET g_success = 'N'
      END IF
   ELSE
      UPDATE gsb_file SET gsb09  = gsb121 / gsb12        #單位價格
       WHERE gsb01 = g_gsh.gsh03
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("upd","gsb_file",g_gsh.gsh03,"",STATUS,"","upd gsb2",1)  
          LET g_success = 'N'
      END IF
   END IF
 
   #---投資金額
   INITIALIZE l_nme.* TO NULL     #No.TQC-A30008 
   LET l_nme.nme00 = 0
   LET l_nme.nme01 = g_gsh.gsh07
   LET l_nme.nme02 = g_gsh.gsh02
   LET l_nme.nme03 = g_gsh.gsh10
   LET l_nme.nme04 = g_gsh.gsh12
   LET l_nme.nme07 = g_gsh.gsh09
   LET l_nme.nme08 = g_gsh.gsh06
   LET l_nme.nme12 = g_gsh.gsh01
   LET l_nme.nme14 = g_gsh.gsh11
   LET l_nme.nme16 = g_gsh.gsh02
   LET l_nme.nme17 = ' '
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_nme.nme21 = 1
   LET l_nme.nme22 = '22'
   LET l_nme.nme23 = ''
   LET l_nme.nme24 = '9'  #No.TQC-750098
   LET l_nme.nme25 = ''
   LET l_nme.nme26 = 'N'  #No.TQC-A30008
 
   LET l_nme.nmelegal = g_legal  
 
   LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
   LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

   INSERT INTO nme_file VALUES(l_nme.*)
   IF STATUS THEN
      CALL cl_err3("ins","nme_file",l_nme.nme02,"",STATUS,"","ins nme:",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
 
   #---投資費用
   INITIALIZE l_nme.* TO NULL     #No.TQC-A30008
   LET l_nme.nme00 = 0
   LET l_nme.nme01 = g_gsh.gsh14
   LET l_nme.nme02 = g_gsh.gsh02
   LET l_nme.nme03 = g_gsh.gsh17
   LET l_nme.nme04 = g_gsh.gsh19
   LET l_nme.nme07 = g_gsh.gsh16
   LET l_nme.nme08 = g_gsh.gsh20
   LET l_nme.nme12 = g_gsh.gsh01
   LET l_nme.nme14 = g_gsh.gsh18
   LET l_nme.nme16 = g_gsh.gsh02
   LET l_nme.nme17 = ' '
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
#  LET l_nme.nme21 = 1     #TQC-AB0325 mark
   LET l_nme.nme21 = 2     #TQC-AB0325 add
   LET l_nme.nme22 = '22'
   LET l_nme.nme23 = ''
   LET l_nme.nme24 = '9'  #No.TQC-750098
   LET l_nme.nme25 = ''
   LET l_nme.nme26 = 'N'  #No.TQC-A30008 
   LET l_nme.nmelegal = g_legal  
 
#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

   INSERT INTO nme_file VALUES(l_nme.*)
   IF STATUS THEN
      CALL cl_err3("ins","nme_file",l_nme.nme02,"",STATUS,"","ins nme:",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
   #---UPDATE gsc
   INITIALIZE l_gsc.* TO NULL     #No.TQC-A30007
   LET l_gsc.gsc01 = g_gsh.gsh03
   LET l_gsc.gsc02 = g_gsh.gsh01
   LET l_gsc.gsc03 = g_gsh.gsh02
   LET l_gsc.gsc04 = g_gsh.gsh05
   LET l_gsc.gsc05 = g_gsh.gsh04
   LET l_gsc.gsc06 = g_gsh.gsh06
   LET l_gsc.gsc07 = 1
   LET l_gsc.gsc08 = g_gsh.gsh13
   LET l_gsc.gsc09 = g_gsh.gsh20
 
   LET l_gsc.gsclegal = g_legal  
 
   INSERT INTO gsc_file VALUES(l_gsc.*)
   IF STATUS THEN
      CALL cl_err3("ins","gsc_file",l_gsc.gsc01,l_gsc.gsc02,STATUS,"","ins gsc:",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
 
   IF g_nmy.nmydmy3 = 'Y'AND g_nmy.nmyglcr = 'Y' THEN
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_gsh.gsh01
         AND npq011 = 4
         AND npqsys = 'NM'
         AND npq00 = 19
      IF l_n = 0 THEN
         CALL t605_gen_glcr(g_gsh.*,g_nmy.*)
      END IF
      IF g_success = 'Y' THEN 
         CALL s_chknpq(g_gsh.gsh01,'NM',4,'0',g_bookno1)       #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_gsh.gsh01,'NM',4,'1',g_bookno2)       #No.FUN-730032
         END IF
         IF g_success ='N' THEN ROLLBACK WORK RETURN END IF   #MOD-7C0184
      END IF
   END IF
   #---UPDATE gsh
   UPDATE gsh_file SET gshconf = 'Y'
    WHERE gsh01 = g_gsh.gsh01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","gsh_file",g_gsh.gsh01,"",STATUS,"","upd gshconf",1)  #No.FUN-660148
       LET g_success = 'N'
   END IF
 
   IF g_success='N' THEN
      LET g_gsh.gshconf = 'N'
      ROLLBACK WORK
   ELSE
      LET g_gsh.gshconf = 'Y'
      COMMIT WORK
      CALL cl_flow_notify(g_gsh.gsh01,'Y')
      CALL cl_cmmsg(1)
   END IF
 
   DISPLAY g_gsh.gshconf TO gshconf
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_gsh.gsh01,'" AND npp011 = 4'
     #LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_gsh.gsh02,"' 'Y' '1' 'Y'"   #No.FUN-680088#FUN-860040 #MOD-C30829 mark
      LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '",g_gsh.gshuser,"' '",g_gsh.gshuser,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_gsh.gsh02,"' 'Y' '1' 'Y'"   #MOD-C30829 add
      CALL cl_cmdrun_wait(g_str)
      SELECT gsh21,gsh22 INTO g_gsh.gsh21,g_gsh.gsh22 FROM gsh_file
       WHERE gsh01 = g_gsh.gsh01
      DISPLAY BY NAME g_gsh.gsh21
      DISPLAY BY NAME g_gsh.gsh22
   END IF
  #CALL cl_set_field_pic(g_gsh.gshconf,"","","","","")        #MOD-AC0073 #FUN-D10116 mark
   CALL cl_set_field_pic(g_gsh.gshconf,"","","",g_void,"")    #FUN-D10116 add
 
END FUNCTION
 
FUNCTION t605_firm2()
   DEFINE l_gsh01_old LIKE gsh_file.gsh01
   DEFINE l_gsb12     LIKE gsb_file.gsb12   #MOD-710045
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_sql       LIKE type_file.chr1000#No.FUN-670060  #No.FUN-680107 VARCHAR(1000)
   DEFINE l_dbs       STRING                #No.FUN-670060
   DEFINE l_nme24     LIKE nme_file.nme24   #No.FUN-730032
 
   IF cl_null(g_gsh.gsh02) THEN CALL cl_err('',-400,0) RETURN END IF
 
   SELECT * INTO g_gsh.* FROM gsh_file WHERE gsh01 = g_gsh.gsh01
 
   IF g_gsh.gshconf = 'N' THEN
      RETURN
   END IF
 
  #----------------FUN-D10116-------------(S)
   IF g_gsh.gshconf = 'X' THEN
      CALL cl_err(g_gsh.gsh01,'9024',0)
      RETURN
   END IF
  #----------------FUN-D10116-------------(E)

   IF NOT cl_null(g_gsh.gsh21) AND g_nmy.nmyglcr = 'N' THEN  #已拋轉總帳 #No.FUN-670060
      CALL cl_err(g_gsh.gsh01,"axr-370",1)
      RETURN
   END IF
 
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_gsh.gsh02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_gsh.gsh01,'aap-176',1)
      RETURN
   END IF
 
   LET l_gsh01_old = g_gsh.gsh01       # backup old key value gsh01
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_gsh.gsh01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_gsh.gsh21) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_gsh.gsh01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_gsh.gsh21,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_gsh.gsh21,'axr-071',1)
         RETURN
      END IF
 
   END IF
 
   IF NOT cl_sure(20,20) THEN
      RETURN
   END IF
 
   LET g_success='Y'
 
   #CHI-C90052 add beign---
   IF g_nmy.nmydmy3 = 'Y'AND g_nmy.nmyglcr = 'Y' THEN
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gsh.gsh21,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT gsh21,gsh22 INTO g_gsh.gsh21,g_gsh.gsh22 FROM gsh_file
       WHERE gsh01 = g_gsh.gsh01
      IF NOT cl_null(g_gsh.gsh21) THEN
         CALL cl_err(g_gsh.gsh21,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_gsh.gsh21
      DISPLAY BY NAME g_gsh.gsh22
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
 
   OPEN t605_cl USING g_gsh.gsh01
   IF STATUS THEN
      CALL cl_err("OPEN t605_cl:", STATUS, 1)
      CLOSE t605_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t605_cl INTO g_gsh.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsh.gsh01,SQLCA.sqlcode,0)#資料被他人LOCK
      CLOSE t605_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   #---UPDATE gsb
   UPDATE gsb_file SET gsb10  = gsb10  - g_gsh.gsh05, #投資數量
                       gsb101 = gsb101 - g_gsh.gsh06, #投資金額
                      #gsb15  = gsb15  - g_gsh.gsh06, #支出總額                                  #MOD-870024 mark
                       gsb15  = gsb15  - g_gsh.gsh06 - g_gsh.gsh20,  #支出總額  #NO.MOD-5B0155   #MOD-870024
                       gsb12  = gsb12  - g_gsh.gsh05, #留倉數量
                       gsb121 = gsb121 - g_gsh.gsh06  #留倉金額
    WHERE gsb01 = g_gsh.gsh03
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","gsb_file",g_gsh.gsh03,"",STATUS,"","upd gsb",1)  #No.FUN-660148
       LET g_success = 'N'
   END IF
 
   #要update gsb09之前,必須先update gsb12,gsb121資料,取最新資料資料來update
   SELECT gsb12 INTO l_gsb12 FROM gsb_file
    WHERE gsb01 = g_gsh.gsh03
   IF l_gsb12 = 0 THEN
      UPDATE gsb_file SET gsb09  = 0                     #單位價格
       WHERE gsb01 = g_gsh.gsh03
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("upd","gsb_file",g_gsh.gsh03,"",STATUS,"","upd gsb1",1)  
          LET g_success = 'N'
      END IF
   ELSE
      UPDATE gsb_file SET gsb09  = gsb121 / gsb12        #單位價格
       WHERE gsb01 = g_gsh.gsh03
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("upd","gsb_file",g_gsh.gsh03,"",STATUS,"","upd gsb2",1)  
          LET g_success = 'N'
      END IF
   END IF
 
   IF g_aza.aza73 = 'Y' THEN
      LET g_sql="SELECT nme24 FROM nme_file",
                " WHERE nme12='",g_gsh.gsh01,"'"
      PREPARE nme24_p1 FROM g_sql
      DECLARE nme24_cs1 CURSOR FOR nme24_p1
      FOREACH nme24_cs1 INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_gsh.gsh01,'anm-043',1)
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END IF
   DELETE FROM nme_file WHERE nme12 = g_gsh.gsh01
   IF STATUS THEN
       CALL cl_err3("del","nme_file",g_gsh.gsh01,"",STATUS,"","del nme",1)  #No.FUN-660148
       LET g_success = 'N'
   END IF
   
   #FUN-B40056   --begin
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021    
   DELETE FROM tic_file WHERE tic04 = g_gsh.gsh01
   IF STATUS THEN
       CALL cl_err3("del","tic_file",g_gsh.gsh01,"",STATUS,"","del tic",1)  #No.FUN-660148
       LET g_success = 'N'
   END IF
   #FUN-B40056   --end
   END IF                 #No.TQC-B70021 
   DELETE FROM gsc_file WHERE gsc02 = g_gsh.gsh01
   IF STATUS THEN
       CALL cl_err3("del","gsc_file",g_gsh.gsh01,"",STATUS,"","del gsc",1)  #No.FUN-660148
       LET g_success = 'N'
   END IF
 
   UPDATE gsh_file SET gshconf = 'N' WHERE gsh01 = g_gsh.gsh01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","gsh_file",g_gsh.gsh01,"",STATUS,"","upd gshconf",1)  #No.FUN-660148
       LET g_success = 'N'
   END IF
 
   IF g_success='N' THEN
       LET g_gsh.gshconf = 'Y'
       ROLLBACK WORK
   ELSE
       LET g_gsh.gshconf = 'N'
       COMMIT WORK
       CALL cl_cmmsg(1)
   END IF
 
   DISPLAY g_gsh.gshconf TO gshconf

   #CHI-C90052 mark beign---
   #IF g_nmy.nmydmy3 = 'Y'AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gsh.gsh21,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT gsh21,gsh22 INTO g_gsh.gsh21,g_gsh.gsh22 FROM gsh_file
   #    WHERE gsh01 = g_gsh.gsh01
   #   DISPLAY BY NAME g_gsh.gsh21
   #   DISPLAY BY NAME g_gsh.gsh22
   #END IF
   #CHI-C90052 mark end-----
 
END FUNCTION
 
FUNCTION t605_r()
    DEFINE
        l_chr   LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
        l_time  LIKE oay_file.oayslip    #NO.FUN-680107 VARCHAR(05)
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_gsh.gsh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

   #----------------FUN-D10116-------------(S)
    IF g_gsh.gshconf = 'X' THEN
       CALL cl_err(g_gsh.gsh01,'9024',0)
       RETURN
    END IF
   #----------------FUN-D10116-------------(E)

    SELECT * INTO g_gsh.* FROM gsh_file WHERE gsh01 = g_gsh.gsh01
    IF g_gsh.gshconf = 'Y' THEN  CALL cl_err('','anm-137',0) RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t605_cl USING g_gsh.gsh01
    IF STATUS THEN
       CALL cl_err("OPEN t605_cl:", STATUS, 1)
       CLOSE t605_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t605_cl INTO g_gsh.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gsh.gsh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t605_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gsh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gsh.gsh01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
	DELETE FROM gsh_file
         WHERE gsh01 = g_gsh.gsh01
	IF SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err3("del","gsh_file",g_gsh.gsh01,"",SQLCA.sqlcode,"","(t605_r.gsh)",1)  #No.FUN-660148
        END IF
        IF g_success = 'Y' THEN CLEAR FORM END IF
	INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980005 add plant & legal 
		VALUES ('anmt605',g_user,g_today,g_msg,g_gsh.gsh01,'Delete',g_plant,g_legal)
    END IF
    CLOSE t605_cl
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1) COMMIT WORK
       CALL cl_flow_notify(g_gsh.gsh01,'D')
       OPEN t605_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE t605_cl
          CLOSE t605_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       FETCH t605_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t605_cl
          CLOSE t605_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t605_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t605_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t605_fetch('/')
       END IF
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION

#-----------------FUN-D10116---------------------(S)
FUNCTION t605_x()

   IF s_anmshut(0) THEN RETURN END IF
   IF cl_null(g_gsh.gsh01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK

   OPEN t605_cl USING g_gsh.gsh01
   IF STATUS THEN
      CALL cl_err("OPEN t605_cl:", STATUS, 1)
      CLOSE t605_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t605_cl INTO g_gsh.*               # 對DB鎖定
   IF STATUS THEN
      CALL cl_err(g_gsh.gsh01,SQLCA.sqlcode,0)
      CLOSE t605_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF g_gsh.gshconf = 'Y' THEN
      CALL cl_err(g_gsh.gsh01,'alm-870',2)
      CLOSE t605_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_gsh.gshconf) THEN
      IF g_gsh.gshconf = 'N' THEN                        #切換為作廢
         DELETE FROM npp_file
          WHERE nppsys= 'NM'
            AND npp00 = 19
            AND npp01 = g_gsh.gsh01
            AND npp011 = 4
         IF STATUS THEN
            CALL cl_err3("del","npp_file",g_gsh.gsh01,"",SQLCA.sqlcode,"","",1)
         ELSE
            DELETE FROM npq_file
             WHERE npqsys= 'NM'
               AND npq00 = 19
               AND npq01 = g_gsh.gsh01
               AND npq011 = 4
            IF STATUS THEN
               CALL cl_err3("del","npq_file",g_gsh.gsh01,"",SQLCA.sqlcode,"","",1)
            END IF
         END IF
         LET g_gsh.gshconf = 'X'
      ELSE                                             #取消作廢
         LET g_gsh.gshconf = 'N'
      END IF
      UPDATE gsh_file SET gshconf = g_gsh.gshconf
       WHERE gsh01 = g_gsh.gsh01

      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","gsh_file",g_gsh.gsh01,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_gsh.gsh01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   CLOSE t605_cl
   CALL t605_show()                      # 重新顯示
END FUNCTION
#-----------------FUN-D10116---------------------(E)

FUNCTION t605_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gsh01",TRUE)
   END IF
 
   IF INFIELD(gsh07) THEN
      CALL cl_set_comp_entry("gsh09,gsh12",TRUE)
   END IF
 
   IF INFIELD(gsh14) THEN
      CALL cl_set_comp_entry("gsh16,gsh19",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t605_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gsh01",FALSE)
   END IF
 
   IF INFIELD(gsh07) THEN
      IF g_gsh.gsh08 = g_aza.aza17 THEN
         CALL cl_set_comp_entry("gsh09,gsh12",FALSE)
      END IF
   END IF
 
   IF INFIELD(gsh14) THEN
      IF g_gsh.gsh15 = g_aza.aza17 THEN
         CALL cl_set_comp_entry("gsh16,gsh19",FALSE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t605_g_gl(p_trno,p_npptype)          #No.FUN-680088
   DEFINE p_npptype   LIKE npp_file.npptype   #No.FUN-680088
   DEFINE p_trno      LIKE gsh_file.gsh01
   DEFINE l_buf       LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(90)
   DEFINE l_n         LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_t         LIKE oay_file.oayslip   #No.MOD-5A0269 #NO.FUN-680107 VARCHAR(5)
 
   SELECT * INTO g_gsh.* FROM gsh_file WHERE gsh01 = g_gsh.gsh01
 
   IF p_trno IS NULL THEN
      RETURN
   END IF
 
   IF g_gsh.gshconf='Y' THEN
      CALL cl_err(g_gsh.gsh01,'anm-232',0)
      RETURN
   END IF
 
   IF g_gsh.gshconf='X' THEN
      CALL cl_err(g_gsh.gsh01,'9024',0)
      RETURN
   END IF
 
   #-->立帳日期不可小於關帳日期
   IF g_gsh.gsh02 <= g_nmz.nmz10 THEN
      CALL cl_err(g_gsh.gsh01,'aap-176',1)
      RETURN
   END IF
 
   IF NOT cl_null(g_gsh.gsh21) THEN
      CALL cl_err(g_gsh.gsh01,'aap-122',1)
      RETURN
   END IF
 
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(p_trno)        #No.MOD-5A0269
   SELECT nmydmy3 INTO g_nmy.nmydmy3 FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(g_nmy.nmydmy3) THEN
      LET g_nmy.nmydmy3 = 'N'
   END IF
   IF g_nmy.nmydmy3 = 'N' THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success ="Y"
   IF p_npptype = '0' THEN   #No.FUN-680088
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys = 'NM'
         AND npq00 = 19
         AND npq01 = p_trno
         AND npq011 = 4
         AND npqtype = p_npptype  #No.FUN-680088
      IF l_n > 0 THEN
         IF NOT s_ask_entry(p_trno) THEN
            LET g_success = "N"
         END IF
         #FUN-B40056--add--str--
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM tic_file
          WHERE tic04 = p_trno
         IF l_n > 0 THEN
            IF NOT cl_confirm('sub-533') THEN
               LET g_success = 'N' 
            END IF
         END IF
         DELETE FROM tic_file WHERE tic04 = p_trno
         #FUN-B40056--add--end--
         DELETE FROM npq_file
          WHERE npqsys = 'NM'
            AND npq00 = 19
            AND npq01 = p_trno
            AND npq011 = 4
         IF STATUS THEN
            LET g_success = "N"
         END IF
      END IF
   END IF     #No.FUN-680088
 
   INITIALIZE g_npp.* TO NULL
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =19
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=4
   LET g_npp.npp02 =g_gsh.gsh02
   LET g_npp.npptype=p_npptype   #No.FUN-680088
 
   LET g_npp.npplegal = g_legal  
 
   INSERT INTO npp_file VALUES(g_npp.*)
 
    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #NO.TQC-790093
      UPDATE npp_file SET npp02 = g_npp.npp02
       WHERE nppsys = 'NM'
         AND npp00 = 19
         AND npp01 = p_trno
         AND npp011 = 4
         AND npptype = p_npptype  #No.FUN-680088
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","npp_file",g_npp.npp02,"",STATUS,"","upd npp:",1)  #No.FUN-660148
         LET g_success = "N"
      END IF
   END IF
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('ins npp:',STATUS,1)
      LET g_success = "N"
   END IF
 
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t605_g_gl_1(p_trno,p_npptype)
   CALL t605_gen_diff() #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
   IF g_success = "Y" THEN
      CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
      MESSAGE g_msg CLIPPED
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t605_g_gl_1(p_trno,p_npqtype)       #No.FUN-680088
   DEFINE p_npqtype   LIKE npq_file.npqtype  #No.FUN-680088
   DEFINE p_trno      LIKE gsh_file.gsh01
   DEFINE l_gsb05     LIKE gsb_file.gsb05
   DEFINE l_aag05     LIKE aag_file.aag05    #FUN-710070 add
   DEFINE l_aaa03     LIKE aaa_file.aaa03    #FUN-A40067                        
   DEFINE l_azi04_2   LIKE azi_file.azi04    #FUN-A40067
   DEFINE l_flag      LIKE type_file.chr1    #FUN-D40118 add
 
   INITIALIZE g_npq.* TO NULL
#FUN-A40067 --Begin
   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01 = g_bookno2
   SELECT azi04 INTO l_azi04_2 FROM azi_file
    WHERE azi01 = l_aaa03
#FUN-A40067 --End
   #---投資金額
   LET g_npq.npqtype= p_npqtype  #No.FUN-680088
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npq02 = 1
 
   SELECT gsb05 INTO l_gsb05 FROM gsb_file
    WHERE gsb01 = g_gsh.gsh03
   IF p_npqtype = '0' THEN
      SELECT gsa04 INTO g_npq.npq03 FROM gsa_file
       WHERE gsa01 = l_gsb05
   ELSE
      SELECT gsa041 INTO g_npq.npq03 FROM gsa_file
       WHERE gsa01 = l_gsb05
   END IF
   IF STATUS THEN
      LET g_npq.npq03 = ''
   END IF
 
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
   END IF
   IF g_npq.npqtype = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = g_npq.npq03
      AND aag00 = g_bookno3       #No.FUN-730032
   IF l_aag05 = 'Y' THEN
     LET g_npq.npq05 = g_gsh.gsh26
   ELSE
     LET g_npq.npq05 = ''
   END IF
   LET g_npq.npq04 = NULL #FUN-D10065 
   LET g_npq.npq06 = '1'
   LET g_npq.npq07f= g_gsh.gsh12
   LET g_npq.npq07 = g_gsh.gsh06
   LET g_npq.npq24 = g_gsh.gsh08
   LET g_npq.npq25 = g_gsh.gsh09
   LET g_npq25     = g_npq.npq25      #FUN-9A0036 
 
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
   RETURNING g_npq.*
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087 
   LET g_npq.npqlegal = g_legal  
 
   IF g_npq.npq07 != 0 THEN   #MOD-810247
#No.FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
#FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file 
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN 
            LET g_npq.npq03 = ''
         END IF 
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq1:",1)  #No.FUN-660148
         LET g_success = "N"
      END IF
   END IF   #MOD-810247
 
   #---投資費用
   LET g_npq.npq02 = g_npq.npq02+1
 
   IF p_npqtype = '0' THEN
      SELECT gsf04 INTO g_npq.npq03 FROM gsf_file
       WHERE gsf01 = g_gsh.gsh13
   ELSE
      SELECT gsf041 INTO g_npq.npq03 FROM gsf_file
       WHERE gsf01 = g_gsh.gsh13
   END IF
   IF STATUS THEN
      LET g_npq.npq03 = ''
   END IF
   LET g_npq.npq04 = NULL #FUN-D10065 
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = g_npq.npq03
      AND aag00 = g_bookno3       #No.FUN-730032
   IF l_aag05 = 'Y' THEN
     LET g_npq.npq05 = g_gsh.gsh26
   ELSE
     LET g_npq.npq05 = ''
   END IF
   LET g_npq.npq07f= g_gsh.gsh19
   LET g_npq.npq07 = g_gsh.gsh20
   LET g_npq.npq24 = g_gsh.gsh15
   LET g_npq.npq25 = g_gsh.gsh16
   LET g_npq25     = g_npq.npq25      #FUN-9A0036
 
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
   RETURNING g_npq.*
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
   LET g_npq.npqlegal = g_legal  
 
   IF g_npq.npq07 != 0 THEN   #MOD-810247
#No.FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
#FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq2:",1)  #No.FUN-660148
         LET g_success = "N"
      END IF
   END IF   #MOD-810247
 
   #---貸方
   LET g_npq.npq02 = g_npq.npq02+1
 
   IF p_npqtype = '0' THEN
      SELECT nma05 INTO g_npq.npq03 FROM nma_file
       WHERE nma01 = g_gsh.gsh07
   ELSE
      SELECT nma051 INTO g_npq.npq03 FROM nma_file
       WHERE nma01 = g_gsh.gsh07
   END IF
   IF STATUS THEN
      LET g_npq.npq03 = ''
   END IF
   LET g_npq.npq04 = NULL #FUN-D10065 
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = g_npq.npq03
      AND aag00 = g_bookno3       #No.FUN-730032
   IF l_aag05 = 'Y' THEN
     LET g_npq.npq05 = g_gsh.gsh26
   ELSE
     LET g_npq.npq05 = ''
   END IF
   LET g_npq.npq06 = '2'
   LET g_npq.npq07f= g_gsh.gsh12
   LET g_npq.npq07 = g_gsh.gsh06
   LET g_npq.npq24 = g_gsh.gsh08
   LET g_npq.npq25 = g_gsh.gsh09
   LET g_npq25     = g_npq.npq25      #FUN-9A0036
 
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
   RETURNING g_npq.*
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
   LET g_npq.npqlegal = g_legal  
 
   IF g_npq.npq07 != 0 THEN   #MOD-810247
#No.FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
#FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq3:",1)  #No.FUN-660148
         LET g_success = "N"
      END IF
   END IF   #MOD-810247
 
  LET g_npq.npq02 = g_npq.npq02+1
 
  SELECT nma05 INTO g_npq.npq03 FROM nma_file
   WHERE nma01 = g_gsh.gsh14
  IF STATUS THEN
     LET g_npq.npq03 = ''
  END IF

  #FUN-D10065--add--str--
  LET g_npq.npq04=NULL
  CALL s_def_npq3(g_bookno3,g_npq.npq03,g_prog,g_npq.npq01,'','') RETURNING g_npq.npq04
  #FUN-D10065--add--end

   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = g_npq.npq03
      AND aag00 = g_bookno3       #No.FUN-730032
   IF l_aag05 = 'Y' THEN
     LET g_npq.npq05 = g_gsh.gsh26
   ELSE
     LET g_npq.npq05 = ''
   END IF
  LET g_npq.npq07f= g_gsh.gsh19
  LET g_npq.npq07 = g_gsh.gsh20
  LET g_npq.npq24 = g_gsh.gsh15
  LET g_npq.npq25 = g_gsh.gsh16
  LET g_npq25     = g_npq.npq25      #FUN-9A0036 
 
  LET g_npq.npqlegal = g_legal  
 
   IF g_npq.npq07 != 0 THEN   #MOD-810247
#No.FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
#FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (g_npq.*)
     IF STATUS THEN
        CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq4:",1)
        LET g_success = "N"
     END IF
  END IF   #MOD-810247
 
 
END FUNCTION
 
FUNCTION t605_npp02(p_npptype) #No.FUN-680088
DEFINE p_npptype  LIKE npp_file.npptype  #No.FUN-680088
 
   IF g_gsh.gsh21 IS NULL OR g_gsh.gsh21=' ' THEN
      UPDATE npp_file SET npp02 = g_gsh.gsh02
       WHERE npp01 = g_gsh.gsh01
         AND npp00 = 19
         AND npp011 = 4
         AND nppsys = 'NM'
         AND npptype= p_npptype  #No.FUN-680088
      IF STATUS THEN
         CALL cl_err3("upd","npp_file",g_gsh.gsh01,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t605_gen_glcr(p_gsh,p_nmy)
  DEFINE p_gsh     RECORD LIKE gsh_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_gsh.gsh01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t605_g_gl(g_gsh.gsh01,'0')
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL t605_g_gl(g_gsh.gsh01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t605_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_gsh.gsh21) OR g_gsh.gsh21 IS NOT NULL THEN 
       CALL cl_err(g_gsh.gsh21,'aap-618',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gsh.gsh01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gsh.gsh21,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_gsh.gsh21,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN
    END IF
    IF cl_null(l_nmygslp) THEN
       CALL cl_err(g_gsh.gsh01,'axr-070',1)
       RETURN
    END IF
    IF g_aza.aza63 = 'Y' AND cl_null(g_nmy.nmygslp1) THEN
       CALL cl_err(g_gsh.gsh01,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_gsh.gsh01,'" AND npp011 = 4'
   #LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_gsh.gsh02,"' 'Y' '1' 'Y'"   #No.FUN-680088#FUN-860040 #MOD-C30829 mark
    LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '",g_gsh.gshuser,"' '",g_gsh.gshuser,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_gsh.gsh02,"' 'Y' '1' 'Y'"   #MOD-C30829 add
    CALL cl_cmdrun_wait(g_str)
    SELECT gsh21,gsh22 INTO g_gsh.gsh21,g_gsh.gsh22 FROM gsh_file
     WHERE gsh01 = g_gsh.gsh01
    DISPLAY BY NAME g_gsh.gsh21
    DISPLAY BY NAME g_gsh.gsh22
    
END FUNCTION
 
FUNCTION t605_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF cl_null(g_gsh.gsh21) OR g_gsh.gsh21 IS NULL THEN 
       CALL cl_err(g_gsh.gsh21,'aap-619',1) 
       RETURN 
    END IF 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gsh.gsh01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_gsh.gsh21,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_gsh.gsh21,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gsh.gsh21,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT gsh21,gsh22 INTO g_gsh.gsh21,g_gsh.gsh22 FROM gsh_file
     WHERE gsh01 = g_gsh.gsh01
    DISPLAY BY NAME g_gsh.gsh21
    DISPLAY BY NAME g_gsh.gsh22
END FUNCTION
 
FUNCTION t605_g_np()
   DEFINE l_nmd       RECORD LIKE nmd_file.*
   DEFINE l_nmf       RECORD LIKE nmf_file.*
   DEFINE l_n         LIKE type_file.num10   
   DEFINE l_msg       LIKE type_file.chr1000 
   DEFINE li_result   LIKE type_file.num5  
   DEFINE l_gen       LIKE type_file.num5
   DEFINE tm RECORD
         slip1     LIKE oay_file.oayslip,  
         slip2     LIKE oay_file.oayslip  
         END RECORD 
   DEFINE   p_row,p_col    LIKE type_file.num5     
 
   SELECT * INTO g_gsh.* FROM gsh_file WHERE gsh01 = g_gsh.gsh01
   IF g_gsh.gshconf = 'N' THEN CALL cl_err('','anm-960',0) RETURN END IF   
  #----------------FUN-D10116-------------(S)
   IF g_gsh.gshconf = 'X' THEN
      CALL cl_err(g_gsh.gsh01,'9024',0)
      RETURN
   END IF
  #----------------FUN-D10116-------------(E)
   IF cl_null(g_gsh.gsh07) AND cl_null(g_gsh.gsh14) THEN RETURN END IF
 
   SELECT COUNT(*) INTO l_n FROM nmd_file WHERE nmd01=g_gsh.gsh27 OR nmd01 = g_gsh.gsh28
   IF l_n>0 THEN
      CALL cl_getmsg('aap-741',g_lang) RETURNING l_msg
      ERROR l_msg CLIPPED  RETURN
   END IF
   IF g_gsh.gsh06 = 0 AND g_gsh.gsh20 = 0 THEN
      CALL cl_err('','anm-705',1)
      RETURN
   END IF
 
   LET g_cnt=0
   IF g_aza.aza26!='2' THEN                          #FUN-C80018
      SELECT COUNT(*) INTO g_cnt FROM nma_file,gsh_file
                                WHERE gsh07=nma01
                                  AND gsh07=g_gsh.gsh07
                                  AND nma28='2'
   #FUN-C80018---ADD---STR
   ELSE
      LET g_cnt = 0
   END IF
   #FUN-C80018---ADD---END    
   IF g_cnt>0 THEN
      CALL cl_err('','anm-117',1)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t605_cl USING g_gsh.gsh01
   IF STATUS THEN
      CALL cl_err("OPEN t605_cl:", STATUS, 1)
      CLOSE t605_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t605_cl INTO g_gsh.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsh.gsh01,SQLCA.sqlcode,0)
      CLOSE t605_cl ROLLBACK WORK RETURN
   END IF
 
 
   IF g_gsh.gsh07 = g_gsh.gsh14 AND g_gsh.gsh08 = g_gsh.gsh15
     AND g_gsh.gsh09 = g_gsh.gsh16 THEN
     LET l_gen = 1
   ELSE 
     LET l_gen = 2   
   END IF
 
   LET p_row = 5 LET p_col = 11
 
   OPEN WINDOW t605_exp AT p_row,p_col WITH FORM "anm/42f/anmt605f"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("anmt605f")
 
   LET g_success = 'Y'
   INPUT BY NAME tm.slip1,tm.slip2 
      BEFORE INPUT
       CALL cl_set_comp_visible("slip1,slip2",TRUE)
       IF l_gen = 1 THEN
         CALL cl_set_comp_visible("slip2",FALSE)
       END IF 
       IF g_gsh.gsh06 = 0 THEN    
          CALL cl_set_comp_visible("slip1",FALSE)
       END IF
       IF g_gsh.gsh20 = 0 THEN    
          CALL cl_set_comp_visible("slip2",FALSE)
       END IF
 
      AFTER FIELD slip1
         IF NOT cl_null(tm.slip1) THEN  
           CALL s_check_no("anm",tm.slip1,'',"1","nmd_file","nmd01","")
               RETURNING li_result,tm.slip1
           DISPLAY BY NAME tm.slip1
           IF (NOT li_result) THEN
             NEXT FIELD slip1
           END IF
         END IF
 
      AFTER FIELD slip2
         IF NOT cl_null(tm.slip2) THEN  
           CALL s_check_no("anm",tm.slip2,'',"1","nmd_file","nmd01","")
               RETURNING li_result,tm.slip2
           DISPLAY BY NAME tm.slip2
           IF (NOT li_result) THEN
             NEXT FIELD slip2
           END IF
         END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         CLOSE WINDOW t400global_exp_po
         RETURN
      END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip1)
                 LET tm.slip1 = s_get_doc_no(tm.slip1)       
                 CALL q_nmy(FALSE,TRUE,tm.slip1,'1','ANM')  
                      RETURNING tm.slip1 #票據性質:應付票據
                 DISPLAY BY NAME tm.slip1   
                 NEXT FIELD slip1
            WHEN INFIELD(slip2)
                 LET tm.slip2 = s_get_doc_no(tm.slip2)       
                 CALL q_nmy(FALSE,TRUE,tm.slip2,'1','ANM')  
                      RETURNING tm.slip2 #票據性質:應付票據
                 DISPLAY BY NAME tm.slip2   
                 NEXT FIELD slip2
            OTHERWISE EXIT CASE
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      ROLLBACK WORK      
      CLOSE WINDOW t605_exp
      RETURN
   END IF
   CLOSE WINDOW t605_exp
   
 
   LET g_gsh_t.* = g_gsh.*
   
   IF l_gen = 1 THEN  #只產生一筆
      INITIALIZE l_nmd.* TO NULL
      LET l_nmd.nmd01=tm.slip1
      CALL s_auto_assign_no("anm",l_nmd.nmd01,g_today,"1","nmd_file","nmd01","","","")
           RETURNING li_result,l_nmd.nmd01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         RETURN
      END IF
      LET l_nmd.nmd03=g_gsh.gsh07
      LET l_nmd.nmd04=g_gsh.gsh12+g_gsh.gsh19
      LET l_nmd.nmd05=g_gsh.gsh02
      LET l_nmd.nmd07=g_gsh.gsh02
      LET l_nmd.nmd08=g_gsh.gsh07   #廠商default出帳銀行
     #SELECT alg02,alg021 INTO l_nmd.nmd24,l_nmd.nmd09   #MOD-B20105 mark
     #  FROM alg_file WHERE alg01=l_nmd.nmd08            #MOD-B20105 mark
      SELECT nma02,nma03 INTO l_nmd.nmd24,l_nmd.nmd09    #MOD-B20105 
        FROM nma_file WHERE nma01=l_nmd.nmd08            #MOD-B20105 
      LET l_nmd.nmd25=g_gsh.gsh11
      LET l_nmd.nmd26=g_gsh.gsh06+g_gsh.gsh20    #No:8615 本幣
      CALL cl_getmsg('anm-648',g_lang) RETURNING g_msg
      LET l_nmd.nmd11=g_msg
      LET l_nmd.nmd12='X'
      LET l_nmd.nmd13=g_gsh.gsh02
      LET l_nmd.nmd14='3'
      LET l_nmd.nmd19=g_gsh.gsh09   
      LET l_nmd.nmd21=g_gsh.gsh08
      LET l_nmd.nmd30='N'
      LET l_nmd.nmduser=g_user
      LET l_nmd.nmdgrup=g_grup
      LET l_nmd.nmddate=g_today
      LET l_nmd.nmd34 = g_plant
      LET l_nmd.nmd33=l_nmd.nmd19    #bug no:A049
      MESSAGE l_nmd.nmd01
      LET l_nmd.nmdlegal = g_legal  
      LET l_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
      LET l_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO nmd_file VALUES(l_nmd.*)
      IF STATUS THEN
         CALL cl_err3("ins","nmd_file",l_nmd.nmd01,"",STATUS,"","ins nmd:",1)  
         ROLLBACK WORK RETURN 
      END IF
      INITIALIZE l_nmf.* TO NULL
      LET l_nmf.nmf01=l_nmd.nmd01
      LET l_nmf.nmf02=g_gsh.gsh02
      LET l_nmf.nmf03="1"
      LET l_nmf.nmf04=g_user
      LET l_nmf.nmf05='0'
      LET l_nmf.nmf06='X'
      LET l_nmf.nmf08=0
      LET l_nmf.nmf09=l_nmd.nmd19
 
      LET l_nmf.nmflegal = g_legal  
      
      INSERT INTO nmf_file VALUES(l_nmf.*)            # 注意多工廠環境
      IF STATUS THEN
         CALL cl_err3("ins","nmf_file",l_nmf.nmf01,l_nmf.nmf03,STATUS,"","ins nmf:",1)  
         ROLLBACK WORK RETURN
      END IF
      UPDATE gsh_file SET gsh27=l_nmd.nmd01 WHERE gsh01=g_gsh.gsh01
      IF STATUS THEN
         CALL cl_err3("upd","gsh_file",g_gsh.gsh01,"",STATUS,"","upd gsh27:",1)  
         ROLLBACK WORK RETURN 
      END IF
   ELSE  #產生2筆
    IF g_gsh.gsh06 != 0 THEN    
      INITIALIZE l_nmd.* TO NULL
      LET l_nmd.nmd01=tm.slip1
      CALL s_auto_assign_no("anm",l_nmd.nmd01,g_today,"1","nmd_file","nmd01","","","")
           RETURNING li_result,l_nmd.nmd01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         RETURN
      END IF
      LET l_nmd.nmd03=g_gsh.gsh07
      LET l_nmd.nmd04=g_gsh.gsh12
      LET l_nmd.nmd05=g_gsh.gsh02
      LET l_nmd.nmd07=g_gsh.gsh02
      LET l_nmd.nmd08=g_gsh.gsh07   #廠商default出帳銀行
     #SELECT alg02,alg021 INTO l_nmd.nmd24,l_nmd.nmd09   #MOD-B20105 mark
     #  FROM alg_file WHERE alg01=l_nmd.nmd08            #MOD-B20105 mark
      SELECT nma02,nma03 INTO l_nmd.nmd24,l_nmd.nmd09    #MOD-B20105 
        FROM nma_file WHERE nma01=l_nmd.nmd08            #MOD-B20105 
      LET l_nmd.nmd25=g_gsh.gsh11
      LET l_nmd.nmd26=g_gsh.gsh06    #No:8615 本幣
      CALL cl_getmsg('anm-648',g_lang) RETURNING g_msg
      LET l_nmd.nmd11=g_msg
      LET l_nmd.nmd12='X'
      LET l_nmd.nmd13=g_gsh.gsh02
      LET l_nmd.nmd14='3'
      LET l_nmd.nmd19=g_gsh.gsh09   
      LET l_nmd.nmd21=g_gsh.gsh08
      LET l_nmd.nmd30='N'
      LET l_nmd.nmduser=g_user
      LET l_nmd.nmdgrup=g_grup
      LET l_nmd.nmddate=g_today
      LET l_nmd.nmd34 = g_plant
      LET l_nmd.nmd33=l_nmd.nmd19    #bug no:A049
      MESSAGE l_nmd.nmd01
 
      LET l_nmd.nmdlegal = g_legal  
      INSERT INTO nmd_file VALUES(l_nmd.*)
      IF STATUS THEN
         CALL cl_err3("ins","nmd_file",l_nmd.nmd01,"",STATUS,"","ins nmd:",1)  
         ROLLBACK WORK RETURN 
      END IF
      INITIALIZE l_nmf.* TO NULL
      LET l_nmf.nmf01=l_nmd.nmd01
      LET l_nmf.nmf02=g_gsh.gsh02
      LET l_nmf.nmf03="1"
      LET l_nmf.nmf04=g_user
      LET l_nmf.nmf05='0'
      LET l_nmf.nmf06='X'
      LET l_nmf.nmf08=0
      LET l_nmf.nmf09=l_nmd.nmd19
      LET l_nmf.nmflegal = g_legal  
      INSERT INTO nmf_file VALUES(l_nmf.*)            # 注意多工廠環境
      IF STATUS THEN
         CALL cl_err3("ins","nmf_file",l_nmf.nmf01,l_nmf.nmf03,STATUS,"","ins nmf:",1)  
         ROLLBACK WORK RETURN
      END IF
      UPDATE gsh_file SET gsh27=l_nmd.nmd01 WHERE gsh01=g_gsh.gsh01
      IF STATUS THEN
         CALL cl_err3("upd","gsh_file",g_gsh.gsh01,"",STATUS,"","upd gsh27:",1)  
         ROLLBACK WORK RETURN 
      END IF
    END IF        #No.MOD-840411  --IF g_gsh.gsh06 <>0
    IF g_gsh.gsh20 != 0 THEN    
      INITIALIZE l_nmd.* TO NULL
      LET l_nmd.nmd01=tm.slip2
      CALL s_auto_assign_no("anm",l_nmd.nmd01,g_today,"1","nmd_file","nmd01","","","")
           RETURNING li_result,l_nmd.nmd01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         RETURN
      END IF
      LET l_nmd.nmd03=g_gsh.gsh14
      LET l_nmd.nmd04=g_gsh.gsh19
      LET l_nmd.nmd05=g_gsh.gsh02
      LET l_nmd.nmd07=g_gsh.gsh02
      LET l_nmd.nmd08=g_gsh.gsh14   #廠商default出帳銀行
     #SELECT alg02,alg021 INTO l_nmd.nmd24,l_nmd.nmd09   #MOD-B20105 mark
     #  FROM alg_file WHERE alg01=l_nmd.nmd08            #MOD-B20105 mark
      SELECT nma02,nma03 INTO l_nmd.nmd24,l_nmd.nmd09    #MOD-B20105 
        FROM nma_file WHERE nma01=l_nmd.nmd08            #MOD-B20105 
      LET l_nmd.nmd25=g_gsh.gsh18
      LET l_nmd.nmd26=g_gsh.gsh20    #No:8615 本幣
      CALL cl_getmsg('anm-648',g_lang) RETURNING g_msg
      LET l_nmd.nmd11=g_msg
      LET l_nmd.nmd12='X'
      LET l_nmd.nmd13=g_gsh.gsh02
      LET l_nmd.nmd14='3'
      LET l_nmd.nmd19=g_gsh.gsh16   
      LET l_nmd.nmd21=g_gsh.gsh15
      LET l_nmd.nmd30='N'
      LET l_nmd.nmduser=g_user
      LET l_nmd.nmdgrup=g_grup
      LET l_nmd.nmddate=g_today
      LET l_nmd.nmd34 = g_plant
      LET l_nmd.nmd33=l_nmd.nmd19    
      MESSAGE l_nmd.nmd01
      LET l_nmd.nmdlegal = g_legal  
      INSERT INTO nmd_file VALUES(l_nmd.*)
      IF STATUS THEN
         CALL cl_err3("ins","nmd_file",l_nmd.nmd01,"",STATUS,"","ins nmd:",1)  
         ROLLBACK WORK RETURN 
      END IF
      INITIALIZE l_nmf.* TO NULL
      LET l_nmf.nmf01=l_nmd.nmd01
      LET l_nmf.nmf02=g_gsh.gsh02
      LET l_nmf.nmf03="1"
      LET l_nmf.nmf04=g_user
      LET l_nmf.nmf05='0'
      LET l_nmf.nmf06='X'
      LET l_nmf.nmf08=0
      LET l_nmf.nmf09=l_nmd.nmd19
      LET l_nmf.nmflegal = g_legal  
      INSERT INTO nmf_file VALUES(l_nmf.*)            # 注意多工廠環境
      IF STATUS THEN
         CALL cl_err3("ins","nmf_file",l_nmf.nmf01,l_nmf.nmf03,STATUS,"","ins nmf:",1)  
         ROLLBACK WORK RETURN
      END IF
      UPDATE gsh_file SET gsh28=l_nmd.nmd01 WHERE gsh01=g_gsh.gsh01
      IF STATUS THEN
         CALL cl_err3("upd","gsh_file",g_gsh.gsh01,"",STATUS,"","upd gsh27:",1)  
         ROLLBACK WORK RETURN 
      END IF
    END IF         #No.MOD-840411 --IF g_gsh.gsh20 <> 0
   END IF
   COMMIT WORK
 
   SELECT gsh27,gsh28 INTO g_gsh.gsh27,g_gsh.gsh28 FROM gsh_file WHERE gsh01=g_gsh.gsh01
   DISPLAY BY NAME g_gsh.gsh27,g_gsh.gsh28
   
   CALL t605_modify_np()  
END FUNCTION
 
FUNCTION t605_del_np()
   DEFINE l_nmd       RECORD LIKE nmd_file.*
   DEFINE l_nmf       RECORD LIKE nmf_file.*
   DEFINE l_n         LIKE type_file.num10   
   DEFINE l_msg       LIKE type_file.chr1000 
   DEFINE l_gsh27     LIKE gsh_file.gsh27,
          l_gsh28     LIKE gsh_file.gsh28
 
   SELECT * INTO g_gsh.* FROM gsh_file WHERE gsh01 = g_gsh.gsh01
   IF g_gsh.gshconf = 'N' THEN RETURN END IF
  #----------------FUN-D10116-------------(S)
   IF g_gsh.gshconf = 'X' THEN
      CALL cl_err(g_gsh.gsh01,'9024',0)
      RETURN
   END IF
  #----------------FUN-D10116-------------(E)
   IF cl_null(g_gsh.gsh27) IS NULL AND cl_null(g_gsh.gsh28) THEN RETURN END IF
   IF NOT cl_sure(0,0) THEN
      RETURN
   END IF
   BEGIN WORK
   LET g_success='Y'
   IF NOT cl_null(g_gsh.gsh27) THEN
     SELECT * INTO l_nmd.* FROM nmd_file WHERE nmd01=g_gsh.gsh27
     IF STATUS THEN 
        CALL cl_err3("sel","nmd_file",g_gsh.gsh27,"","anm-221","","",1)   
        ROLLBACK WORK
        RETURN  
     END IF
     IF l_nmd.nmd12 <> 'X' OR (l_nmd.nmd02 IS NOT NULL AND l_nmd.nmd02<>' ') THEN  
        CALL cl_err(l_nmd.nmd12,'anm-236',0)
        ROLLBACK WORK
        RETURN
     END IF
     DELETE FROM nmd_file WHERE nmd01 = g_gsh.gsh27
     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("del","nmd_file",g_gsh.gsh27,"",STATUS,"","del nmd-1",1)
        LET g_success = 'N'
     END IF
     DELETE FROM nmf_file WHERE nmf01 = g_gsh.gsh27
     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("del","nmf_file",g_gsh.gsh27,"",STATUS,"","del nmf-1",1)
        LET g_success = 'N'  
     END IF
     UPDATE gsh_file SET gsh27 = NULL
      WHERE gsh01 = g_gsh.gsh01
     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("upd","gsh_file",g_gsh.gsh01,g_gsh.gsh27,STATUS,"","upd gsh27",1)  
        LET g_success = 'N'
     END IF
   END IF
 
   IF NOT cl_null(g_gsh.gsh28) THEN
     SELECT * INTO l_nmd.* FROM nmd_file WHERE nmd01=g_gsh.gsh28
     IF STATUS THEN 
        CALL cl_err3("sel","nmd_file",g_gsh.gsh28,"","anm-221","","",1)   
        ROLLBACK WORK
        RETURN  
     END IF
     IF l_nmd.nmd12 <> 'X' OR (l_nmd.nmd02 IS NOT NULL AND l_nmd.nmd02<>' ') THEN  
        CALL cl_err(l_nmd.nmd12,'anm-236',0)
        ROLLBACK WORK
        RETURN
     END IF
     DELETE FROM nmd_file WHERE nmd01 = g_gsh.gsh28
     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("del","nmd_file",g_gsh.gsh28,"",STATUS,"","del nmd-2",1)
        LET g_success = 'N'
     END IF
     DELETE FROM nmf_file WHERE nmf01 = g_gsh.gsh28
     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("del","nmf_file",g_gsh.gsh28,"",STATUS,"","del nmf-2",1)
        LET g_success = 'N'  
     END IF
     UPDATE gsh_file SET gsh28 = NULL
      WHERE gsh01 = g_gsh.gsh01
     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("upd","gsh_file",g_gsh.gsh01,g_gsh.gsh28,STATUS,"","upd gsh27",1)  
        LET g_success = 'N'
     END IF
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   SELECT gsh27,gsh28 INTO g_gsh.gsh27,g_gsh.gsh28 FROM gsh_file WHERE gsh01=g_gsh.gsh01
   DISPLAY BY NAME g_gsh.gsh27,g_gsh.gsh28
END FUNCTION
 
FUNCTION t605_modify_np()
    DEFINE l_n LIKE type_file.num5
    SELECT COUNT(*) INTO l_n FROM nmd_file WHERE nmd01=g_gsh.gsh27 OR nmd01 = g_gsh.gsh28
    IF l_n=0 THEN
       RETURN
    END IF
    LET g_msg2 = ' '
    IF NOT (cl_null(g_gsh.gsh27) AND cl_null(g_gsh.gsh28)) THEN
      LET g_msg2 = " nmd01 IN("
    END IF
    IF NOT cl_null(g_gsh.gsh27) THEN 
      LET g_msg2 = g_msg2,"'",g_gsh.gsh27 CLIPPED ,"'"
    END IF
    IF NOT cl_null(g_gsh.gsh28) THEN
         LET g_msg2 = g_msg2,",'",g_gsh.gsh28 CLIPPED,"')"
    ELSE LET g_msg2 = g_msg2,")"
    END IF
    IF cl_null(g_gsh.gsh27) AND NOT cl_null(g_gsh.gsh28) THEN 
       LET g_msg2 = cl_replace_str(g_msg2,","," ")
    END IF
    LET g_msg2 = cl_replace_str(g_msg2,"'","\"")
    LET g_msg="anmt100 '' 'Query' '' '",g_msg2,"'"
    CALL cl_cmdrun_wait(g_msg) 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/15
#FUN-A40033 --Begin
FUNCTION t605_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag           LIKE type_file.chr1     #FUN-D40118 add
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
         LET g_success = 'N'
      END IF
      LET g_bookno3 = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno3
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = g_npp.npp00
            AND npq01 = g_npp.npp01
            AND npq011= g_npp.npp011
            AND npqsys= g_npp.nppsys
         LET l_npq1.npqtype = g_npp.npptype
         LET l_npq1.npq00 = g_npp.npp00
         LET l_npq1.npq01 = g_npp.npp01
         LET l_npq1.npq011= g_npp.npp011
         LET l_npq1.npqsys= g_npp.nppsys
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
         LET l_npq1.npqlegal  = g_legal
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
            CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1)
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End

