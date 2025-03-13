# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: anmi820.4gl
# Descriptions...: 定期存款單維護作業
# Date & Author..: 99/05/06 by Iceman FOR TIPTOP 5.00
# Modify ........: 00/04/12 By Polly Hsu
# Modify ........: 02/12/03 By Kitty
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.8270 03/10/20 By Kitty nme17不可insert null否則anmp320會有誤
# Modify.........: No.MOD-480310 Kammy 在已確認的畫面再壓一次確認會當出
# Modify.........: No.MOD-480397 Kammy 金額不可小於零
# Modify.........: No.MOD-470276 04/09/08 By Yuna
#                         1.anmi820的質押傳票編號及日期應改成ref方式
#                         2.質押跟解除質押加show異動序號
# Modify.........: No.MOD-490293 04/09/21 By Yuna 查詢時無法進到[解除質押]那個page
# Modify.........: No.MOD-490275 04/09/30 By Yuna 解約日期/傳票/傳票日期應改為ref型態較佳
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0052 04/11/23 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-530044 05/03/07 By Kitty  gxf36匯率欄位未放大,也未開窗
# Modify.........: No.MOD-530202 05/03/24 By Smapmin 已確認資料卻可以再次開窗確認
# Modify.........: No.FUN-550037 05/05/12 By saki   欄位comment顯示
# Modify.........: No.MOD-550025 05/05/18 By ching  fix底稿平衡檢查問題
# Modify.........: NO.FUN-550057 05/05/22 By jackie 單據編號加大
# Modify.........: No.MOD-5B0042 05/11/24 By Smapmin 提出銀行不會規定一定要為活存帳戶
# Modify.........: NO.TQC-5B0085 05/11/23 BY yiting 提出金額應以存入本幣金額/提出匯率計算出來才對
#                                                   再計算出提出本幣金額=提出金額*提出匯率
# Modify.........: NO.MOD-5C0027 05/12/14 BY yiting 取位的變數指定錯誤。
# Modify.........: No.TQC-610040 06/01/12 By Smapmin 定存銀行幣別.匯率移到金額之前
# Modify.........: No.FUN-630020 06/03/07 By pengu 流程訊息通知功能
# Modify.........: No.MOD-640499 06/04/18 By Smapmin 修改異動碼開窗
# Modify.........: No.MOD-650006 06/05/03 By Smapmin 檢查存單號碼是否重複
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-5C0093 06/05/29 By rainy 頭新增欄位 '開帳否' (gxf41)
#                                                  確認時如該欄位 'Y'則不需 insert into nme_file
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/02 By Rayven 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680088 06/08/28 By Ray 多帳套處理
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.FUN-680053 06/09/05 By jamie 新增列印功能
# Modify.........: No.CHI-6A0004 06/10/27 By Carrier g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-730012 07/03/06 By Smapmin 修改條件
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/22 By wujie   網銀功能相關修改，nme新增欄位
# Modify.........: No.MOD-740002 07/04/02 By Smapmin 修改存入與提出異動碼開窗
# Modify.........: No.MOD-740346 07/04/23 By Rayven 不使用網銀時不去判斷是否未轉
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-760004 07/06/15 By kim 調整報表
# Modify.........: No.FUN-770038 07/07/13 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-7A0140 07/10/25 By Smapmin 刪除整張單據時要連同分錄一起刪除
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-820151 08/02/26 By Smapmin 已存在質押/解除質押的異動,不可取消確認
# Modify.........: No.FUN-850038 08/05/12 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-860232 08/06/27 By Sarah gxf26計算後需再取位
# Modify.........: No.MOD-870263 08/07/23 By Sarah 增加判斷gxf38='2'時則無須檢查重複性問題
# Modify.........: NO.FUN-870145 08/07/28 BY yiting gxf38 = '2' 不insert into nme_file
# Modify.........: No.FUN-870151 08/08/11 By sherry  匯率調整為用azi07取位
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-920267 09/02/19 By Dido 依據 gxf07 抓取 nme14 預設值
# Modify.........: No.FUN-940036 09/04/06 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.TQC-960133 09/06/12 By sabrina (1) DISPLAY l_stat TO sts 畫面跟欄位對不上產生錯誤
#                                                    (2) _u()重覆beginwork
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No:MOD-A10095 10/01/18 By Sarah 續約的存單資料不可產生分錄但要可確認,也不可產生anmt300資料
# Modify.........: No:TQC-A10164 10/01/26 By Sarah 修正MOD-A10095
# Modify.........: No.FUN-9B0098 10/02/24 By tommas delete cl_doc
# Modify.........: No.MOD-A60016 10/06/03 By sabrina 若單據已存在anmt850(gxl03)則不可取消確認
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A90010 10/09/02 By Dido 匯率應依據 nmz04 判斷抓取 
# Modify.........: No:MOD-A20037 10/10/05 By sabrina 交易單據類型(nme22)沒有給預設值
# Modify.........: No.TQC-AB0406 10/12/02 By lixh1 確認時把NOT NULL的欄位賦默認值
# Modify.........: No.TQC-B10069 11/01/14 By lixh1 整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-B80244 11/08/25 By Polly 修正取消確認時，會將原有存在anmt300單據連同刪除問題
# Modify.........: No.FUN-B90062 11/09/14 By wujie 产生nme_file时同时产生tic_file   
# Modify.........: No.MOD-BC0175 11/12/19 By Polly 當日期、幣別更改時，需重抓匯率和金額
# Modify.........: No:TQC-C10011 12/01/04 By yinhy 狀態頁簽的“資料建立者”和“資料建立部門”欄位無法下查詢條件查詢
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C20015 12/02/02 By Polly 拿掉gxf38 = '2'產生nme_file
# Modify.........: No:MOD-C50059 12/05/09 By Elise anmt850 到期續存時,存入銀行與定存銀行不同時,則需在 anmi820 產生分錄
# Modify.........: No:FUN-C80018 12/08/06 By minpp 大陸版時如果anmi030沒有維護單身時，anmt100單頭的簿號和支票號碼可以手動輸入
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No:FUN-B80125 12/10/25 By Belle 增加作廢選項
# Modify.........: No:MOD-D30193 13/03/22 By Polly 調整作廢改用gxf011控卡

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_argv1  LIKE oea_file.oea01 #NO.FUN-680107 VARCHAR(16) #No.FUN-630020 add
DEFINE g_argv2  STRING              #No.FUN-630020 add
 
DEFINE
    g_gxf                  RECORD LIKE gxf_file.*,
    g_gxf_t                RECORD LIKE gxf_file.*,
    g_gxf_o                RECORD LIKE gxf_file.*,
    g_gxf011_t             LIKE gxf_file.gxf011,   #存單編號
    g_dbs_gl               LIKE type_file.chr21,   #NO.FUN-680107 VARCHAR(21)
    g_plant_gl             LIKE type_file.chr21,   #NO.FUN-980059 VARCHAR(21)
    g_wc,g_sql             string,                 #No.FUN-580092 HCN 
    l_code                 LIKE azo_file.azo06,    #NO.FUN-680107 VARCHAR(7)   #ze01:錯誤訊息代號
    l_stat                 LIKE cre_file.cre08,    #NO.FUN-680107 VARCHAR(10)
    g_buf                  LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(20)
    g_cmd                  LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(100)
    g_t1                   LIKE oay_file.oayslip,  #No.FUN-550057 #No.FUN-680107 VARCHAR(5)
    g_nmydmy1              LIKE type_file.chr1     #NO.FUN-680107 VARCHAR(1)
DEFINE  g_flag         LIKE type_file.chr1       #No.FUN-730032
DEFINE  g_bookno1      LIKE aza_file.aza81       #No.FUN-730032
DEFINE  g_bookno2      LIKE aza_file.aza82       #No.FUN-730032
 
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done STRING     
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680107 INTEGER
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680107 VARCHAR(72)
DEFINE   g_str           STRING                    #No.FUN-670060
DEFINE   g_wc_gl         STRING                    #No.FUN-670060
DEFINE   g_row_count     LIKE type_file.num10      #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10      #No.FUN-680107 INTEGER
DEFINE   g_jump          LIKE type_file.num10      #No.FUN-680107 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5       #No.FUN-680107 SMALLINT
DEFINE   l_table         STRING  #No.FUN-770038
DEFINE   g_void          LIKE type_file.chr1       #FUN-B80125 
 
MAIN
DEFINE   l_za05            LIKE type_file.chr1000    #No.FUN-680107 VARCHAR(40)
DEFINE p_row,p_col       LIKE type_file.num5       #No.FUN-680107 SMALLINT
 
    OPTIONS                                     #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1=ARG_VAL(1)          #No.FUN-630020 add
    LET g_argv2=ARG_VAL(2)          #No.FUN-630020 add
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    LET g_sql = " gxf01.gxf_file.gxf01,",
                " gxf011.gxf_file.gxf011,",
                " gxf02.gxf_file.gxf02,",
                " gxf021.gxf_file.gxf021,",
                " gxf03.gxf_file.gxf03,",
                " gxf04.gxf_file.gxf04,",
                " gxf05.gxf_file.gxf05,",
                " gxf06.gxf_file.gxf06,",
                " gxf07.gxf_file.gxf07,",
                " gxf08.gxf_file.gxf08,",
                " gxf11.gxf_file.gxf11,",
                " gxf12.gxf_file.gxf12,",
                " gxf13.gxf_file.gxf13,",
                " gxf14.gxf_file.gxf14,",
                " gxf24.gxf_file.gxf24,",
                " gxf25.gxf_file.gxf25,",
                " gxf26.gxf_file.gxf26,",
                " gxf27.gxf_file.gxf27,",
                " gxf28.gxf_file.gxf28,",
                " gxf29.gxf_file.gxf29,",
                " gxf30.gxf_file.gxf30,",
                " gxf32.gxf_file.gxf32,",
                " gxf33.gxf_file.gxf33,",
                " gxf33f.gxf_file.gxf33f,",
                " gxf34.gxf_file.gxf34,",
                " gxf35.gxf_file.gxf35,",
                " gxf36.gxf_file.gxf36,",
                " gxf37.gxf_file.gxf37,",
                " gxf38.gxf_file.gxf38,",
                " gxf41.gxf_file.gxf41,",
                " gxfconf.gxf_file.gxfconf,",
                " nma02_1.nma_file.nma02,",
                " nma02_2.nma_file.nma02,",
                " nmc02.nmc_file.nmc02,",
                " nmc02_2.nmc_file.nmc02,",
                " l_str1.type_file.chr1000,",
                " l_str2.type_file.chr1000,",
                " l_str3.type_file.chr1000,",
                " azi07.azi_file.azi07,",      #No.FUN-870151
                " azi07_1.azi_file.azi07 "     #No.FUN-870151
 
    LET l_table = cl_prt_temptable('anmi820',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) "    #FUN-870151 ADD ?,?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
    INITIALIZE g_gxf.* TO NULL
    INITIALIZE g_gxf_t.* TO NULL
    INITIALIZE g_gxf_o.* TO NULL
    LET g_plant_new = g_nmz.nmz02p
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new
 
    LET g_forupd_sql = "SELECT * FROM gxf_file WHERE gxf011 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i820_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW i820_w AT p_row,p_col
         WITH FORM "anm/42f/anmi820"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是出貨單號(oga01)
   # 執行I時，g_argv1是單號(gxf011)
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i820_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i820_a()
            END IF
         OTHERWISE
                CALL i820_q()
      END CASE
   END IF
 
      LET g_action_choice=""
      CALL i820_menu()
 
    CLOSE WINDOW i820_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION i820_cs()
    CLEAR FORM
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF cl_null(g_argv1) THEN         #No.FUN-630020 add
   INITIALIZE g_gxf.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           gxf011, gxf01, gxf38,gxf02, gxf03, gxf05,gxf24,gxf25,gxf021,gxf26,gxf06,
           gxf11, gxfconf,gxf41, gxf04, gxf07, gxf12, #FUN-5C0093 add gxf41
           gxf13, gxf14, gxf29, gxf30, gxf27, gxf28, gxf32,
           gxf33f, gxf33, gxf35,gxf36, gxf34, gxf37, gxf23, gxf15,
           gxf16, gxf08, gxf09, gxf21, gxf10, gxf17, gxf18,
           gxfuser, gxfgrup, gxfmodu, gxfdate, gxfacti,
           gxforiu,gxforig,                          #No.TQC-C10011
           gxf22,gxf19,gxf20,                        #No.MOD-490293
           gxfud01,gxfud02,gxfud03,gxfud04,gxfud05,
           gxfud06,gxfud07,gxfud08,gxfud09,gxfud10,
           gxfud11,gxfud12,gxfud13,gxfud14,gxfud15
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
           
           ON ACTION controlp
               CASE
                 WHEN INFIELD(gxf011)   #申請單號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_gxf"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO gxf011
                      NEXT FIELD gxf011
                 WHEN INFIELD(gxf02)   #原存銀行
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_nma2"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_gxf.gxf02
                      LET g_qryparam.arg1 = 23
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO gxf02
                      NEXT FIELD gxf02
                 WHEN INFIELD(gxf32)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_nma2"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_gxf.gxf32
                      LET g_qryparam.arg1 = 123   #MOD-5B0042
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO gxf32
                      NEXT FIELD gxf32
                 WHEN INFIELD(gxf24)   #幣別
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_azi"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_gxf.gxf24
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO gxf24
                      NEXT FIELD gxf24
                 WHEN INFIELD(gxf07)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_nmc01"   #MOD-740002
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_gxf.gxf07
                      LET g_qryparam.arg1 = '1'   #MOD-740002
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO gxf07
                      NEXT FIELD gxf07
                 WHEN INFIELD(gxf35)   #幣別
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_azi"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_gxf.gxf35
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO gxf35
                      NEXT FIELD gxf35
                 WHEN INFIELD(gxf34)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_nmc01"   #MOD-740002
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_gxf.gxf34
                      LET g_qryparam.arg1 = '2'   #MOD-740002
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO gxf34
                      NEXT FIELD gxf34
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
     ELSE
        LET g_wc =" gxf011 = '",g_argv1,"'"
     END IF
 
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gxfuser', 'gxfgrup')
 
    LET g_sql="SELECT gxf011 FROM gxf_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY gxf011"
    PREPARE i820_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE i820_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i820_prepare
    LET g_sql =
        "SELECT COUNT(*) FROM gxf_file WHERE ",g_wc CLIPPED
    PREPARE i820_recount FROM g_sql
    DECLARE i820_count CURSOR FOR i820_recount
END FUNCTION
 
FUNCTION i820_menu()
  DEFINE      l_cmd    LIKE type_file.chr50    #No.FUN-680107 VARCHAR(30)
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
               CALL i820_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i820_q()
            END IF
         
        ON ACTION output
            LET g_action_choice="output"
            IF  cl_chk_act_auth()
               THEN CALL i820_out()
            END IF
 
       
        ON ACTION next
            CALL i820_fetch('N')
        ON ACTION previous
            CALL i820_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i820_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i820_r()
            END IF
        ON ACTION confirm
             LET g_action_choice="confirm"
             IF cl_chk_act_auth() THEN
                CALL s_showmsg_init()          #TQC-B10069
                CALL i820_y()
               #FUN-B80125--(B)--
                IF g_gxf.gxfconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_gxf.gxfconf,"","","",g_void,g_gxf.gxfacti)
               #FUN-B80125--(E)--
               #CALL cl_set_field_pic(g_gxf.gxfconf,"","","","",g_gxf.gxfacti)   #FUN-B80125 mark
                CALL s_showmsg()               #TQC-B10069
             END IF
        ON ACTION undo_confirm
           LET g_action_choice="undo_confirm" #No.MOD-480292
           IF cl_chk_act_auth() THEN
                CALL i820_z()
             #FUN-B80125--(B)--
              IF g_gxf.gxfconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_gxf.gxfconf,"","","",g_void,g_gxf.gxfacti)
             #FUN-B80125--(E)--
             #CALL cl_set_field_pic(g_gxf.gxfconf,"","","","",g_gxf.gxfacti)    #FUN-B80125 mark
           END IF
       #FUN-B80125--(B)--
        ON ACTION void
           LET g_action_choice="void"
           IF cl_chk_act_auth() THEN
              CALL i820_x()
              IF g_gxf.gxfconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_gxf.gxfconf,"","","",g_void,"")
           END IF
       #FUN-B80125--(E)--
        ON ACTION qry_transaction
            LET g_action_choice="qry_transaction"
            IF cl_chk_act_auth() THEN
               LET g_cmd = "anmq820 '", g_gxf.gxf011,"'"
               CALL cl_cmdrun(g_cmd)
            END IF
        ON ACTION gen_entry
            LET g_action_choice="gen_entry"
            IF cl_chk_act_auth() THEN
               CALL i820_v()
            END IF
        ON ACTION entry_sheet
            LET g_action_choice="entry_sheet"
            IF cl_chk_act_auth() AND not cl_null(g_gxf.gxf011) THEN
               CALL s_fsgl('NM',12,g_gxf.gxf011,g_gxf.gxf26,
                            g_nmz.nmz02b,1,g_gxf.gxfconf,'0',g_nmz.nmz02p)      #No.FUN-680088
               CALL cl_navigator_setting( g_curs_index, g_row_count )      #No.FUN-680088
            END IF
 
        ON ACTION entry_sheet2
            LET g_action_choice="entry_sheet2"
            IF cl_chk_act_auth() AND not cl_null(g_gxf.gxf011) THEN
               CALL s_fsgl('NM',12,g_gxf.gxf011,g_gxf.gxf26,
                            g_nmz.nmz02c,1,g_gxf.gxfconf,'1',g_nmz.nmz02p) 
               CALL cl_navigator_setting( g_curs_index, g_row_count )
            END IF
 
        ON ACTION carry_voucher 
            IF cl_chk_act_auth() THEN
               IF g_gxf.gxfconf = 'Y' THEN 
                  CALL i820_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF  
            END IF  
        ON ACTION undo_carry_voucher  
            IF cl_chk_act_auth() THEN
               IF g_gxf.gxfconf = 'Y' THEN  
                  CALL i820_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF 
            END IF  
 
        ON ACTION entry_deposit_no
            LET g_action_choice="entry_deposit_no"
            IF cl_chk_act_auth() THEN
               CALL i820_1()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic(g_gxf.gxfconf,"","","","",g_gxf.gxfacti)

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i820_fetch('/')
        ON ACTION first
            CALL i820_fetch('F')
        ON ACTION last
            CALL i820_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_gxf.gxf011 IS NOT NULL THEN
               LET g_doc.column1 = "gxf011"
               LET g_doc.value1 = g_gxf.gxf011
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
    CLOSE i820_cs
END FUNCTION
 
 
FUNCTION i820_a()
DEFINE li_result   LIKE type_file.num5        #No.FUN-550057  #No.FUN-680107 SMALLINT
    IF s_anmshut(0) THEN RETURN END IF        #檢查權限
    MESSAGE " "
    CLEAR FORM                                # 清螢墓欄位內容
    INITIALIZE g_gxf.* LIKE gxf_file.*
    LET g_gxf011_t = NULL
    LET g_gxf.gxf021=  0                      # 原存金額
    LET g_gxf.gxf38=  '1'                     # 原存金額
    LET g_gxf.gxf33f=  0                      # 原存金額
    LET g_gxf.gxf27 =  0                      #
    LET g_gxf.gxf28 =  0                      #
    LET g_gxf.gxf06 =  0                      # 利率
    LET g_gxf.gxf09 =  0                      # 實押金額
    LET g_gxf_t.* = g_gxf.*                   # 保留舊值
    LET g_gxf_o.* = g_gxf.*                   # 保留舊值
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_gxf.gxf11   =  0                 # 狀態:0.存入
        LET g_gxf.gxf04   = '1'                # 計息方式
        LET g_gxf.gxfacti = 'Y'                # 有效的資料
        LET g_gxf.gxfconf = 'N'                # confirm碼
        LET g_gxf.gxf41   = 'N'                # 開帳碼   #FUN-5C0093 add
        LET g_gxf.gxf03   = g_today            # 原存日期
        LET g_gxf.gxfuser = g_user             # 使用者
        LET g_gxf.gxforiu = g_user #FUN-980030
        LET g_gxf.gxforig = g_grup #FUN-980030
        LET g_gxf.gxfgrup = g_grup             # 使用者所屬群
        LET g_gxf.gxfdate = g_today            # 更改日期
 
        LET g_gxf.gxflegal = g_legal
 
        CALL i820_i("a")                       # 各欄位輸入
        IF INT_FLAG THEN                       # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_gxf.gxf011 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_gxf.gxf021 <= 0 OR g_gxf.gxf26 <= 0 THEN
           CALL cl_err('','aap-201',1)
           CONTINUE WHILE
        END IF
        BEGIN WORK #No.7875
        CALL s_auto_assign_no("anm",g_gxf.gxf011,g_gxf.gxf03,"G","gxf_file","gxf011","","","")
             RETURNING li_result,g_gxf.gxf011
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_gxf.gxf011
        INSERT INTO gxf_file VALUES(g_gxf.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","gxf_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148  #No.FUN-B80067---調整至回滾事務前---
           ROLLBACK WORK #No.7875
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No.7875
           CALL cl_flow_notify(g_gxf.gxf011,'I')
           LET g_gxf_t.* = g_gxf.*              # 保存上筆資料
           SELECT gxf011 INTO g_gxf.gxf011 FROM gxf_file
            WHERE gxf011 = g_gxf.gxf011
        END IF
        CALL i820_show()
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i820_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,   #狀態               #No.FUN-680107 VARCHAR(1)
       l_flag          LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_n,l_cnt       LIKE type_file.num5    #No.FUN-680107      SMALLINT
DEFINE li_result       LIKE type_file.num5,   #No.FUN-550057      #No.FUN-680107 SMALLINT
       l_azi04         LIKE azi_file.azi04    #NO.MOD-5C0027
 
    DISPLAY BY NAME
        g_gxf.gxf01,g_gxf.gxf011,g_gxf.gxf02,g_gxf.gxf38,g_gxf.gxf021, g_gxf.gxf06,
        g_gxf.gxf24, g_gxf.gxf25, g_gxf.gxf26,
        g_gxf.gxf12, g_gxf.gxf03, g_gxf.gxf04,
        g_gxf.gxf05, g_gxf.gxf07, g_gxf.gxf11,g_gxf.gxf13, g_gxf.gxf14,
        g_gxf.gxf32, g_gxf.gxf33f,g_gxf.gxf33,
        g_gxf.gxf35, g_gxf.gxf36, g_gxf.gxf34, g_gxf.gxf37,
        g_gxf.gxfacti,g_gxf.gxfconf,g_gxf.gxf41,g_gxf.gxfuser,g_gxf.gxfgrup,g_gxf.gxfdate #FUN-5C0093 add gxf41
    INPUT BY NAME g_gxf.gxforiu,g_gxf.gxforig,
        g_gxf.gxf011, g_gxf.gxf01, g_gxf.gxf38,g_gxf.gxf02, g_gxf.gxf03, g_gxf.gxf05, g_gxf.gxf24, g_gxf.gxf25,g_gxf.gxf021,
        g_gxf.gxf26, g_gxf.gxf06, g_gxf.gxf11, g_gxf.gxfconf,g_gxf.gxf41, g_gxf.gxf04, g_gxf.gxf07, g_gxf.gxf12,  #FUN-5C0093 add gxf41
        g_gxf.gxf13, g_gxf.gxf14, g_gxf.gxf29, g_gxf.gxf30, g_gxf.gxf27, g_gxf.gxf28, g_gxf.gxf32,
        g_gxf.gxf33f, g_gxf.gxf33, g_gxf.gxf35,g_gxf.gxf36, g_gxf.gxf34, g_gxf.gxf37, g_gxf.gxf23, g_gxf.gxf15,
        g_gxf.gxf16, g_gxf.gxf08, g_gxf.gxf09, g_gxf.gxf21, g_gxf.gxf10, g_gxf.gxf17, g_gxf.gxf18,
        g_gxf.gxfuser, g_gxf.gxfgrup, g_gxf.gxfmodu, g_gxf.gxfdate, g_gxf.gxfacti,
        g_gxf.gxfud01,g_gxf.gxfud02,g_gxf.gxfud03,g_gxf.gxfud04,
        g_gxf.gxfud05,g_gxf.gxfud06,g_gxf.gxfud07,g_gxf.gxfud08,
        g_gxf.gxfud09,g_gxf.gxfud10,g_gxf.gxfud11,g_gxf.gxfud12,
        g_gxf.gxfud13,g_gxf.gxfud14,g_gxf.gxfud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i820_set_entry(p_cmd)
            CALL i820_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("gxf011")
 
        AFTER FIELD gxf011         #申請號碼
          #IF NOT cl_null(g_gxf.gxf011) AND (g_gxf.gxf011!=g_gxf011_t) THEN                #No.MOD-B80244 mark
           IF NOT cl_null(g_gxf.gxf011) THEN                                               #No.MOD-B80244 add
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_gxf.gxf011 != g_gxf011_t) THEN          #No.MOD-B80244 add
                 CALL s_check_no("anm",g_gxf.gxf011,g_gxf011_t,"G","gxf_file","gxf011","")
                      RETURNING li_result,g_gxf.gxf011
                 DISPLAY BY NAME g_gxf.gxf011
                 IF (NOT li_result) THEN
                    NEXT FIELD gxf011
                 END IF
              END IF                                                                        #No.MOD-B80244 add
          END IF
 
         AFTER FIELD gxf01
           IF NOT cl_null(g_gxf.gxf01) THEN
             #當gxf38狀況為2.續約時,無須檢查重複性問題
              IF (g_gxf.gxf38!='2' AND g_gxf.gxf01!=g_gxf_t.gxf01) OR
                 g_gxf_t.gxf01 IS NULL THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM gxf_file
                   WHERE gxf01 = g_gxf.gxf01
                 IF l_cnt > 0 THEN
                    CALL cl_err(g_gxf.gxf01,-239,0)
                    LET g_gxf.gxf01 = g_gxf_t.gxf01
                    DISPLAY BY NAME g_gxf.gxf01
                    NEXT FIELD gxf01
                 END IF
              END IF
           END IF
 
 
         AFTER FIELD gxf38        #狀況
            IF g_gxf.gxf38 NOT MATCHES '[12]' THEN
               NEXT FIELD gxf38
            END IF
 
         AFTER FIELD gxf02        #原存銀行
            IF NOT cl_null(g_gxf.gxf02) THEN
               IF g_gxf.gxf02 != g_gxf_t.gxf02 OR g_gxf_t.gxf02 IS NULL THEN
                  CALL i820_nma01_1('u')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_gxf.gxf02,g_errno,0)
                     LET g_gxf.gxf02 = g_gxf_o.gxf02
                     DISPLAY BY NAME g_gxf.gxf02
                     NEXT FIELD gxf02
                  END IF
                  IF g_aza.aza17 = g_gxf.gxf24 THEN   #本幣
                     LET g_gxf.gxf25 = 1
                  ELSE
                     CALL s_curr3(g_gxf.gxf24,g_gxf.gxf03,'B')
                       RETURNING g_gxf.gxf25
                  END IF
                  DISPLAY BY NAME g_gxf.gxf25
                  LET g_gxf.gxf26 = g_gxf.gxf021*g_gxf.gxf25
                  CALL cl_digcut(g_gxf.gxf26,g_azi04)
                     RETURNING g_gxf.gxf26
                   DISPLAY BY NAME g_gxf.gxf26
               END IF
               LET g_gxf_t.gxf02=g_gxf.gxf02
            END IF
 
 
         AFTER FIELD gxf021       #原存金額
            IF g_gxf.gxf021 <0 THEN
               CALL cl_err(g_gxf.gxf021,'aom-103',0)
               LET g_gxf.gxf021=g_gxf_o.gxf021
               DISPLAY BY NAME g_gxf.gxf021
               NEXT FIELD gxf021
            END IF
            IF NOT cl_null(g_gxf.gxf021) THEN
               LET g_gxf.gxf26 = g_gxf.gxf021*g_gxf.gxf25
               CALL cl_digcut(g_gxf.gxf26,g_azi04) RETURNING g_gxf.gxf26   #MOD-860232 add
               DISPLAY BY NAME g_gxf.gxf26                                 #MOD-860232 add
               IF p_cmd = 'a' OR g_gxf.gxf021!=g_gxf_t.gxf021 THEN
                   LET g_gxf.gxf33f = g_gxf.gxf26/g_gxf.gxf36
                   SELECT azi04 INTO t_azi04
                     FROM azi_file WHERE azi01=g_gxf.gxf35  #原幣
                   CALL cl_digcut(g_gxf.gxf33f,t_azi04)
                       RETURNING g_gxf.gxf33f
                   LET g_gxf.gxf33 = g_gxf.gxf33f*g_gxf.gxf36
                   CALL cl_digcut(g_gxf.gxf33,g_azi04)
                       RETURNING g_gxf.gxf33
                  LET g_gxf.gxf26 = g_gxf.gxf021*g_gxf.gxf25
                  CALL cl_digcut(g_gxf.gxf26,g_azi04)
                     RETURNING g_gxf.gxf26
                   SELECT azi04 INTO l_azi04
                     FROM azi_file
                    WHERE azi01 = g_gxf.gxf24
                   CALL cl_digcut(g_gxf.gxf021,l_azi04)
                     RETURNING g_gxf.gxf021
                   DISPLAY BY NAME g_gxf.gxf26,g_gxf.gxf33f,g_gxf.gxf33,g_gxf.gxf021
               END IF
            END IF
 
         AFTER FIELD gxf05        #到期日
             IF NOT cl_null(g_gxf.gxf05) THEN           #No.MOD-480398
               IF g_gxf.gxf05 < g_gxf.gxf03 THEN
                  CALL cl_err('','aap-100',1)
                  LET g_gxf.gxf05 = g_gxf_t.gxf05
                  DISPLAY BY NAME g_gxf.gxf05
                  NEXT FIELD gxf03
               END IF
            END IF
 
         AFTER FIELD gxf06        #利率
            IF g_gxf.gxf06 <0 THEN
               CALL cl_err(g_gxf.gxf05,'aom-103',0)
               LET g_gxf.gxf06=g_gxf_o.gxf06
               DISPLAY BY NAME g_gxf.gxf06
               NEXT FIELD gxf06
            END IF
 
         AFTER FIELD gxf03        #原存日期
            IF g_gxf.gxf03 <= g_nmz.nmz10 THEN  #no.5261
               CALL cl_err('','aap-176',1) NEXT FIELD gxf03
            END IF
           #---------------------MOD-BC0175------------------start
            IF g_gxf.gxf03 != g_gxf_t.gxf03 OR g_gxf_t.gxf03 IS NULL THEN
               IF NOT cl_null(g_gxf.gxf24) THEN
                  IF g_aza.aza17 = g_gxf.gxf24 THEN   #本幣
                     LET g_gxf.gxf25 = 1
                  ELSE
                     CALL s_curr3(g_gxf.gxf24,g_gxf.gxf03,'B')
                          RETURNING g_gxf.gxf25
                  END IF
                  DISPLAY BY NAME g_gxf.gxf25
                  LET g_gxf.gxf26 = g_gxf.gxf021*g_gxf.gxf25
                  CALL cl_digcut(g_gxf.gxf26,g_azi04)
                       RETURNING g_gxf.gxf26
                  DISPLAY BY NAME g_gxf.gxf26
               END IF
               IF NOT cl_null(g_gxf.gxf35) THEN
                  IF g_aza.aza17 = g_gxf.gxf35 THEN   #本幣
                     LET g_gxf.gxf36 = 1
                  ELSE
                     IF g_nmz.nmz04='1' THEN
                        CALL s_bankex(g_gxf.gxf32,g_gxf.gxf03) RETURNING g_gxf.gxf36
                     ELSE
                        CALL s_curr3(g_gxf.gxf35,g_gxf.gxf03,'B') RETURNING g_gxf.gxf36
                     END IF
                  END IF
                  DISPLAY BY NAME g_gxf.gxf36
                  LET g_gxf.gxf33f = g_gxf.gxf26/g_gxf.gxf36
                  LET g_gxf.gxf33 = g_gxf.gxf33f * g_gxf.gxf36
                  SELECT azi04 INTO t_azi04
                    FROM azi_file WHERE azi01=g_gxf.gxf35  #原幣
                  CALL cl_digcut(g_gxf.gxf33,g_azi04)
                       RETURNING g_gxf.gxf33
                  CALL cl_digcut(g_gxf.gxf33f,t_azi04)
                       RETURNING g_gxf.gxf33f
                  DISPLAY BY NAME g_gxf.gxf33f,g_gxf.gxf33
               END IF
            END IF
           #---------------------MOD-BC0175--------------------end
 
         AFTER FIELD gxf04        #計息方式
            IF g_gxf.gxf04 >2 OR g_gxf.gxf04<1 THEN
               CALL cl_err(g_gxf.gxf04,'anm-250',0)
               NEXT FIELD gxf04
            END IF
         AFTER FIELD gxf24  #幣別
            IF NOT cl_null(g_gxf.gxf24) THEN
               IF (g_gxf_o.gxf24 IS NULL) OR (g_gxf_o.gxf24 != g_gxf.gxf24) THEN
                   CALL i820_gxf24()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_gxf.gxf24,g_errno,0)
                      LET g_gxf.gxf24 = g_gxf_o.gxf24
                      DISPLAY BY NAME g_gxf.gxf24
                      NEXT FIELD gxf24
                   END IF
                   IF g_aza.aza17 = g_gxf.gxf24 THEN   #本幣
                      LET g_gxf.gxf25 = 1
                   ELSE
                      CALL s_curr3(g_gxf.gxf24,g_gxf.gxf03,'B')
                           RETURNING g_gxf.gxf25
                   END IF
                   DISPLAY BY NAME g_gxf.gxf25
               END IF
            END IF
            LET g_gxf_o.gxf24 = g_gxf.gxf24
 
         AFTER FIELD gxf25  #匯率
              IF g_gxf.gxf25 <= 0 THEN
                 CALL cl_err(g_gxf.gxf25,'mfg0013',0)
                 LET g_gxf.gxf25 = g_gxf_o.gxf25
                 DISPLAY BY NAME g_gxf.gxf25
                 NEXT FIELD gxf25
              END IF
              IF NOT cl_null(g_gxf.gxf25) THEN
                 LET g_gxf_o.gxf25 = g_gxf.gxf25
                 LET g_gxf.gxf26 = g_gxf.gxf021*g_gxf.gxf25
                 CALL cl_digcut(g_gxf.gxf26,g_azi04)
                      RETURNING g_gxf.gxf26
                 IF p_cmd = 'a' OR g_gxf.gxf25!=g_gxf_t.gxf25 THEN
                    LET g_gxf.gxf33 = g_gxf.gxf26
                    LET g_gxf.gxf33f = g_gxf.gxf26/g_gxf.gxf36
                    CALL cl_digcut(g_gxf.gxf33,g_azi04)
                        RETURNING g_gxf.gxf33
                    CALL cl_digcut(g_gxf.gxf33f,t_azi04)
                        RETURNING g_gxf.gxf33f
                    SELECT azi04 INTO l_azi04
                      FROM azi_file WHERE azi01 = g_gxf.gxf24
                    CALL cl_digcut(g_gxf.gxf021,l_azi04)
                        RETURNING g_gxf.gxf021
                 END IF
                                  DISPLAY BY NAME g_gxf.gxf26,g_gxf.gxf33,g_gxf.gxf33f,g_gxf.gxf021
                 IF g_gxf.gxf24 =g_aza.aza17 THEN
                    LET g_gxf.gxf25 =1
                     DISPLAY BY NAME g_gxf.gxf25
                 END IF
 
              END IF
 
         AFTER FIELD gxf07        #異動碼
              IF NOT cl_null(g_gxf.gxf07) THEN
                 SELECT nmc02 INTO g_buf FROM nmc_file
                  WHERE nmc01=g_gxf.gxf07 AND nmc03='1'
                 IF STATUS THEN NEXT FIELD gxf07 END IF
                 DISPLAY g_buf TO FORMONLY.nmc02
              END IF
 
         AFTER FIELD gxf32        #原存銀行
            IF NOT cl_null(g_gxf.gxf32) THEN
               IF g_gxf.gxf32 != g_gxf_t.gxf32 OR g_gxf_t.gxf32 IS NULL THEN
                  CALL i820_nma01_2('u')
                  IF g_errno != ' ' THEN
                     CALL cl_err(g_gxf.gxf32,g_errno,0)
                     LET g_gxf.gxf32 = g_gxf_o.gxf32
                     DISPLAY BY NAME g_gxf.gxf32
                     NEXT FIELD gxf32
                  ELSE
                     IF g_aza.aza17 = g_gxf.gxf35 THEN   #本幣
                        LET g_gxf.gxf36 = 1
                     ELSE
                       #CALL s_curr3(g_gxf.gxf35,g_gxf.gxf03,'B')     #MOD-A90010 mark
                       #     RETURNING g_gxf.gxf36                    #MOD-A90010 mark
                       #-MOD-A90010-add-
                        IF g_nmz.nmz04='1' THEN
                           CALL s_bankex(g_gxf.gxf32,g_gxf.gxf03) RETURNING g_gxf.gxf36
                        ELSE
                           CALL s_curr3(g_gxf.gxf35,g_gxf.gxf03,'B') RETURNING g_gxf.gxf36 
                        END IF
                       #-MOD-A90010-add-
                     END IF
                     DISPLAY BY NAME g_gxf.gxf36
                     LET g_gxf.gxf33f = g_gxf.gxf26/g_gxf.gxf36
                     LET g_gxf.gxf33 = g_gxf.gxf33f * g_gxf.gxf36
                     SELECT azi04 INTO t_azi04
                       FROM azi_file WHERE azi01=g_gxf.gxf35  #原幣
                     CALL cl_digcut(g_gxf.gxf33,g_azi04)
                         RETURNING g_gxf.gxf33
                     CALL cl_digcut(g_gxf.gxf33f,t_azi04)
                         RETURNING g_gxf.gxf33f
                     DISPLAY BY NAME g_gxf.gxf33f,g_gxf.gxf33
                  END IF
               END IF
               LET g_gxf_t.gxf32=g_gxf.gxf32
            END IF
 
         AFTER FIELD gxf35  #幣別
            IF NOT cl_null(g_gxf.gxf35) THEN
               IF (g_gxf_o.gxf35 IS NULL) OR (g_gxf_o.gxf35 != g_gxf.gxf35)
               THEN CALL i820_gxf35()
                    IF g_errno!=' ' THEN
                       CALL cl_err(g_gxf.gxf35,g_errno,0)
                       LET g_gxf.gxf35 = g_gxf_o.gxf35
                       DISPLAY BY NAME g_gxf.gxf35
                       NEXT FIELD gxf35
                     END IF
                     IF g_aza.aza17 = g_gxf.gxf35 THEN   #本幣
                        LET g_gxf.gxf36 = 1
                     ELSE
                       #CALL s_curr3(g_gxf.gxf35,g_gxf.gxf03,'B')     #MOD-A90010 mark
                       #     RETURNING g_gxf.gxf36                    #MOD-A90010 mark
                       #-MOD-A90010-add-
                        IF g_nmz.nmz04='1' THEN
                           CALL s_bankex(g_gxf.gxf32,g_gxf.gxf03) RETURNING g_gxf.gxf36
                        ELSE
                           CALL s_curr3(g_gxf.gxf35,g_gxf.gxf03,'B') RETURNING g_gxf.gxf36 
                        END IF
                       #-MOD-A90010-add-
                     END IF
                     DISPLAY BY NAME g_gxf.gxf36
                END IF
                LET g_gxf_o.gxf35 = g_gxf.gxf35
            END IF
 
         AFTER FIELD gxf36  #匯率
              IF g_gxf.gxf36 <= 0 THEN
                 CALL cl_err(g_gxf.gxf36,'mfg0013',0)
                 LET g_gxf.gxf36 = g_gxf_o.gxf36
                 DISPLAY BY NAME g_gxf.gxf36
                 NEXT FIELD gxf36
              END IF
              IF NOT cl_null(g_gxf.gxf36) THEN
                 LET g_gxf_o.gxf36 = g_gxf.gxf36
                 SELECT azi04 INTO t_azi04
                   FROM azi_file WHERE azi01=g_gxf.gxf35  #原幣
                 LET g_gxf.gxf33 = g_gxf.gxf33f * g_gxf.gxf36
                 CALL cl_digcut(g_gxf.gxf33,g_azi03)
                      RETURNING g_gxf.gxf33
                 DISPLAY BY NAME g_gxf.gxf33f,g_gxf.gxf33
              END IF
 
         AFTER FIELD gxf33f       #原存金額
              IF g_gxf.gxf33f <0 THEN
                 CALL cl_err(g_gxf.gxf33f,'aom-103',0)
                 LET g_gxf.gxf33f=g_gxf_o.gxf33f
                 DISPLAY BY NAME g_gxf.gxf33f
                 NEXT FIELD gxf33f
              END IF
              LET g_gxf.gxf33 = g_gxf.gxf33f*g_gxf.gxf36
                 SELECT azi04 INTO t_azi04
                   FROM azi_file WHERE azi01=g_gxf.gxf35  #原幣
                 CALL cl_digcut(g_gxf.gxf33f,t_azi04)
                      RETURNING g_gxf.gxf33f
                 CALL cl_digcut(g_gxf.gxf33,g_azi04)
                      RETURNING g_gxf.gxf33
              DISPLAY BY NAME g_gxf.gxf33,g_gxf.gxf33f
 
         AFTER FIELD gxf33
              LET g_gxf.gxf33 = g_gxf.gxf33f*g_gxf.gxf36
                 CALL cl_digcut(g_gxf.gxf33,g_azi04)
                      RETURNING g_gxf.gxf33
                 DISPLAY BY NAME g_gxf.gxf33
 
         AFTER FIELD gxf34        #異動碼
              IF NOT cl_null(g_gxf.gxf34) THEN
                 SELECT nmc02 INTO g_buf FROM nmc_file
                  WHERE nmc01=g_gxf.gxf34 AND nmc03='2'
                 IF STATUS THEN NEXT FIELD gxf34 END IF
                 DISPLAY g_buf TO nmc02_2
              END IF
 
         AFTER FIELD gxfud01
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud02
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud03
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud04
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud05
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud06
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud07
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud08
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud09
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud10
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud11
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud12
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud13
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud14
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxfud15
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER INPUT
            #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
          LET g_gxf.gxfuser = s_get_data_owner("gxf_file") #FUN-C10039
          LET g_gxf.gxfgrup = s_get_data_group("gxf_file") #FUN-C10039
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF g_gxf.gxf011 IS NULL THEN
          LET l_flag='Y'
          DISPLAY BY NAME g_gxf.gxf011
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          IF p_cmd='a' THEN NEXT FIELD gxf011 END IF
          IF p_cmd='u' THEN NEXT FIELD gxf011 END IF
       END IF
 
        ON ACTION CONTROLP
            CASE
 
              WHEN INFIELD(gxf011)   #申請單號
                   LET g_t1 = s_get_doc_no(g_gxf.gxf011)       #No.FUN-550057
                   CALL q_nmy(FALSE,FALSE,g_t1,'G','ANM') RETURNING g_t1  #TQC-670008
                   LET g_gxf.gxf011= g_t1    #No.FUN-550057
                   DISPLAY BY NAME g_gxf.gxf011
                   NEXT FIELD gxf011
              WHEN INFIELD(gxf02)   #原存銀行
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma2"
                   LET g_qryparam.default1 = g_gxf.gxf02
                   LET g_qryparam.arg1 = 23
                   CALL cl_create_qry() RETURNING g_gxf.gxf02
                   DISPLAY BY NAME g_gxf.gxf02
                   NEXT FIELD gxf02
              WHEN INFIELD(gxf32)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma2"
                   LET g_qryparam.default1 = g_gxf.gxf32
                   LET g_qryparam.arg1 = 123   #MOD-5B0042
                   CALL cl_create_qry() RETURNING g_gxf.gxf32
                   DISPLAY BY NAME g_gxf.gxf32
                   NEXT FIELD gxf32
              WHEN INFIELD(gxf24)   #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.default1 = g_gxf.gxf24
                   CALL cl_create_qry() RETURNING g_gxf.gxf24
                   DISPLAY BY NAME g_gxf.gxf24
                   NEXT FIELD gxf24
              WHEN INFIELD(gxf07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nmc01"   #MOD-740002
                   LET g_qryparam.default1 = g_gxf.gxf07
                   LET g_qryparam.arg1 = '1'   #MOD-640499
                   CALL cl_create_qry() RETURNING g_gxf.gxf07
                   DISPLAY BY NAME g_gxf.gxf07
                   NEXT FIELD gxf07
              WHEN INFIELD(gxf35)   #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.default1 = g_gxf.gxf35
                   CALL cl_create_qry() RETURNING g_gxf.gxf35
                   DISPLAY BY NAME g_gxf.gxf35
                   NEXT FIELD gxf35
              WHEN INFIELD(gxf34)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nmc01"   #MOD-740002
                   LET g_qryparam.default1 = g_gxf.gxf34
                   LET g_qryparam.arg1 = '2'   #MOD-640499
                   CALL cl_create_qry() RETURNING g_gxf.gxf34
                   DISPLAY BY NAME g_gxf.gxf34
                   NEXT FIELD gxf34
              WHEN INFIELD(gxf25)
                   CALL s_rate(g_gxf.gxf24,g_gxf.gxf25) RETURNING g_gxf.gxf25
                   DISPLAY BY NAME g_gxf.gxf25
                   NEXT FIELD gxf25
              WHEN INFIELD(gxf36)
                   CALL s_rate(g_gxf.gxf35,g_gxf.gxf36) RETURNING g_gxf.gxf36
                   DISPLAY BY NAME g_gxf.gxf36
                   NEXT FIELD gxf36
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
 
FUNCTION i820_gxf24()  #幣別
          DEFINE l_aziacti LIKE azi_file.aziacti
 
          LET g_errno = " "
          SELECT aziacti INTO l_aziacti FROM azi_file
                                        WHERE azi01 = g_gxf.gxf24
          CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                         LET l_aziacti = 0
               WHEN l_aziacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
          END CASE
END FUNCTION
 
FUNCTION i820_gxf35()  #幣別
          DEFINE l_aziacti LIKE azi_file.aziacti
 
          LET g_errno = " "
          SELECT aziacti INTO l_aziacti FROM azi_file
                                        WHERE azi01 = g_gxf.gxf35
          CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                         LET l_aziacti = 0
               WHEN l_aziacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
          END CASE
END FUNCTION
 
FUNCTION i820_gxg07()  #抓取質押傳票編號,傳票日期,異動序號
    DEFINE l_gxg07      LIKE gxg_file.gxg07,
           l_gxg08      LIKE gxg_file.gxg08,
           l_gxg02      LIKE gxg_file.gxg02
 
    LET g_errno = ' '
    DISPLAY ' ' TO FORMONLY.gxg02_1
    SELECT gxg07,gxg08,gxg02 INTO l_gxg07,l_gxg08,l_gxg02 FROM gxg_file
     WHERE gxg011=g_gxf.gxf011 AND gxg021 = '1' AND gxg03 = g_gxf.gxf21
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       LET g_gxf.gxf17=l_gxg07
       LET g_gxf.gxf18=l_gxg08
       DISPLAY l_gxg02 TO FORMONLY.gxg02_1
       DISPLAY BY NAME g_gxf.gxf17,g_gxf.gxf18
    END IF
END FUNCTION
 
FUNCTION i820_gxg10()  #抓取質押解除傳票編號,傳票日期
    DEFINE l_gxg10      LIKE gxg_file.gxg10,
           l_gxg11      LIKE gxg_file.gxg11,
           l_gxg02      LIKE gxg_file.gxg02
 
    LET g_errno = ' '
    DISPLAY ' ' TO FORMONLY.gxg02_2
    SELECT gxg10,gxg11,gxg02 INTO l_gxg10,l_gxg11,l_gxg02 FROM gxg_file
     WHERE gxg011=g_gxf.gxf011 AND gxg021 = '2' AND gxg09 = g_gxf.gxf22
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       LET g_gxf.gxf19=l_gxg10
       LET g_gxf.gxf20=l_gxg11
       DISPLAY l_gxg02 TO FORMONLY.gxg02_2
       DISPLAY BY NAME g_gxf.gxf19,g_gxf.gxf20
    END IF
END FUNCTION
 
FUNCTION i820_gxkglno()  #抓取解約日期,解約傳票編號,解約傳票日期
 DEFINE l_gxk02      LIKE gxk_file.gxk02,
        l_gxkglno    LIKE gxk_file.gxkglno,
        l_gxk30      LIKE gxk_file.gxk30
 
    LET g_errno = ' '
 
    SELECT gxk02,gxkglno,gxk30 INTO l_gxk02,l_gxkglno,l_gxk30
     FROM gxk_file,gxl_file
     WHERE gxk01 = gxl01 AND gxl03=g_gxf.gxf011 AND gxk20 = '2'
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       LET g_gxf.gxf23=l_gxk02
       LET g_gxf.gxf15=l_gxkglno
       LET g_gxf.gxf16=l_gxk30
       DISPLAY BY NAME g_gxf.gxf23,g_gxf.gxf15,g_gxf.gxf16
    END IF
END FUNCTION
 
FUNCTION i820_nma01_1(p_cmd)  #抓取銀行名稱
    DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_nma01      LIKE nma_file.nma01,
           l_nma02      LIKE nma_file.nma02,
           l_nma10      LIKE nma_file.nma10,
           l_nma28      LIKE nma_file.nma28,
           l_nmaacti    LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT nma02,nma10,nmaacti,nma28 INTO l_nma02,l_nma10,l_nmaacti,l_nma28 FROM nma_file
     WHERE nma01 = g_gxf.gxf02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                                   LET l_nma02 = NULL
         WHEN l_nma28='1' 
            IF  g_aza.aza26!='2' THEN  LET g_errno = 'anm-251'  END IF     #FUN-C80018
         WHEN l_nmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY l_nma02 TO nma02_1
    END IF
    IF p_cmd='u' OR p_cmd='a' THEN
       LET g_gxf.gxf24=l_nma10
       DISPLAY BY NAME g_gxf.gxf24
    END IF
END FUNCTION
 
FUNCTION i820_nma01_2(p_cmd)  #抓取銀行名稱
    DEFINE p_cmd        LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
           l_nma01      LIKE nma_file.nma01,
           l_nma02      LIKE nma_file.nma02,
           l_nma10      LIKE nma_file.nma10,
           l_nma28      LIKE nma_file.nma28,
           l_nmaacti    LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT nma02,nma10,nmaacti,nma28 INTO l_nma02,l_nma10,l_nmaacti,l_nma28 FROM nma_file
     WHERE nma01 = g_gxf.gxf32
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                                   LET l_nma02 = NULL
         WHEN l_nmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='d' OR g_errno = ' ' THEN
       DISPLAY l_nma02 TO nma02_2
    END IF
    IF p_cmd='u' OR p_cmd='a' THEN
       LET g_gxf.gxf35=l_nma10
       DISPLAY BY NAME g_gxf.gxf35
    END IF
END FUNCTION
 
FUNCTION i820_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gxf.* TO NULL              #No.FUN-6A0011
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i820_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i820_count
    FETCH i820_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i820_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxf.gxf011,SQLCA.sqlcode,0)
        INITIALIZE g_gxf.* TO NULL
    ELSE
        CALL i820_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i820_fetch(p_flgxf)
    DEFINE
        p_flgxf         LIKE type_file.chr1,    #NO.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10    #No.FUN-680107 INTEGER
 
    CASE p_flgxf
        WHEN 'N' FETCH NEXT     i820_cs INTO g_gxf.gxf011
        WHEN 'P' FETCH PREVIOUS i820_cs INTO g_gxf.gxf011
        WHEN 'F' FETCH FIRST    i820_cs INTO g_gxf.gxf011
        WHEN 'L' FETCH LAST     i820_cs INTO g_gxf.gxf011
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
            FETCH ABSOLUTE g_jump i820_cs INTO g_gxf.gxf011
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxf.gxf011,SQLCA.sqlcode,0)
        INITIALIZE g_gxf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flgxf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_gxf.* FROM gxf_file          # 重讀DB,因TEMP有不被更新特性
     WHERE gxf011 = g_gxf.gxf011
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","gxf_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       LET g_data_owner = g_gxf.gxfuser     #No.FUN-4C0063
       LET g_data_group = g_gxf.gxfgrup     #No.FUN-4C0063
       CALL i820_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i820_show()
    LET g_gxf_o.* = g_gxf.*
    LET g_gxf_t.* = g_gxf.*
    DISPLAY BY NAME g_gxf.gxforiu,g_gxf.gxforig,
        g_gxf.gxf011, g_gxf.gxf01, g_gxf.gxf02, g_gxf.gxf38,g_gxf.gxf021,
        g_gxf.gxf03, g_gxf.gxf04,
        g_gxf.gxf24, g_gxf.gxf25, g_gxf.gxf26,
        g_gxf.gxf27, g_gxf.gxf28, g_gxf.gxf29, g_gxf.gxf30  , g_gxf.gxf07,
        g_gxf.gxf05, g_gxf.gxf06, g_gxf.gxf12, g_gxf.gxf13  , g_gxf.gxf14,
        g_gxf.gxf32, g_gxf.gxf33f,g_gxf.gxf33,
        g_gxf.gxf35, g_gxf.gxf36, g_gxf.gxf34, g_gxf.gxf37,
        g_gxf.gxf23, g_gxf.gxf15, g_gxf.gxf16, g_gxf.gxf08  , g_gxf.gxf09,
        g_gxf.gxf10, g_gxf.gxf21, g_gxf.gxf17, g_gxf.gxf18  , g_gxf.gxf22,
        g_gxf.gxf19, g_gxf.gxf20, g_gxf.gxf11, g_gxf.gxfuser, g_gxf.gxfgrup,
        g_gxf.gxfmodu,g_gxf.gxfdate,g_gxf.gxfacti,g_gxf.gxfconf,g_gxf.gxf41, #FUN-5C0093 add gxf41
        g_gxf.gxfud01,g_gxf.gxfud02,g_gxf.gxfud03,g_gxf.gxfud04,
        g_gxf.gxfud05,g_gxf.gxfud06,g_gxf.gxfud07,g_gxf.gxfud08,
        g_gxf.gxfud09,g_gxf.gxfud10,g_gxf.gxfud11,g_gxf.gxfud12,
        g_gxf.gxfud13,g_gxf.gxfud14,g_gxf.gxfud15 
 
    SELECT nmc02 INTO g_buf FROM nmc_file WHERE nmc01=g_gxf.gxf07
    DISPLAY g_buf TO FORMONLY.nmc02
    SELECT nmc02 INTO g_buf FROM nmc_file WHERE nmc01=g_gxf.gxf34
    DISPLAY g_buf TO FORMONLY.nmc02_2
    CALL i820_nma01_1('d')
    CALL i820_nma01_2('d')
    CALL i820_gxg07()   #抓取質押傳票編號及傳票日期
    CALL i820_gxg10()   #抓取質押解除傳票編號及傳票日期
    CALL i820_gxkglno() #No.MOD-470275 抓取解約日期,解約傳票編號,解約傳票日期
   #FUN-B80125--(B)--
    IF g_gxf.gxfconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_gxf.gxfconf,"","","",g_void,g_gxf.gxfacti)
   #FUN-B80125--(E)--
   #CALL cl_set_field_pic(g_gxf.gxfconf,"","","","",g_gxf.gxfacti)        #FUN-B80125 mark
 
    CALL cl_show_fld_cont()                  #No.FUN-550037
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i820_u()
    IF s_anmshut(0) THEN RETURN END IF                #檢查權限
    SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011 = g_gxf.gxf011
    IF STATUS THEN 
    CALL cl_err3("sel","gxf_file",g_gxf.gxf011,"",STATUS,"","",1)  #No.FUN-660148
    RETURN END IF
   #IF g_gxf.gxfconf='Y' THEN CALL cl_err(g_gxf.gxf011,'anm-105',0) RETURN END IF  #FUN-B80125 mark
   #FUN-B80125--(B)--
    IF g_gxf.gxfconf='Y' THEN
       CALL cl_err(g_gxf.gxf01,'anm-105',2)
       RETURN
    END IF
    IF g_gxf.gxfconf='X' THEN
       CALL cl_err(g_gxf.gxf01,'9024',0)
       RETURN
    END IF
   #FUN-B80125--(E)--
    IF g_gxf.gxf011 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_gxf.gxfacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_gxf.gxf011,'9027',0) RETURN
    END IF
    IF g_gxf.gxf11 != 0  THEN    #若狀態不為0.存入時不可再修改
        CALL cl_err(g_gxf.gxf11,'anm-612',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gxf011_t = g_gxf.gxf011
    LET g_gxf_o.*=g_gxf.*
    BEGIN WORK
    OPEN i820_cl USING g_gxf.gxf011
    IF STATUS THEN
       CALL cl_err("OPEN i820_cl:", STATUS, 1)
       CLOSE i820_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i820_cl INTO g_gxf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxf.gxf011,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_gxf.gxfmodu = g_user                #修改者
    LET g_gxf.gxfdate = g_today               #修改日期
    CALL i820_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i820_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gxf.* = g_gxf_o.*
            CALL i820_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_gxf.gxf021 <= 0 OR g_gxf.gxf26 <= 0 THEN
           CALL cl_err('','aap-201',1)
           CONTINUE WHILE
        END IF
        UPDATE gxf_file SET gxf_file.* = g_gxf.*    # 更新DB
            WHERE gxf011 = g_gxf011_t               # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gxf_file",g_gxf011_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i820_cl
    COMMIT WORK
    CALL cl_flow_notify(g_gxf.gxf011,'U')
END FUNCTION
 
FUNCTION i820_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011 = g_gxf.gxf011
    IF STATUS THEN 
    CALL cl_err3("sel","gxf_file",g_gxf.gxf011,"",STATUS,"","",1)  #No.FUN-660148
    RETURN END IF
   #IF g_gxf.gxfconf='Y' THEN CALL cl_err(g_gxf.gxf011,'anm-105',0) RETURN END IF   #FUN-B80125 mark
   #FUN-B80125--(B)--
    IF g_gxf.gxfconf='Y' THEN
       CALL cl_err(g_gxf.gxf01,'anm-105',2)
       RETURN
    END IF
    IF g_gxf.gxfconf='X' THEN
       CALL cl_err(g_gxf.gxf01,'9024',0)
       RETURN
    END IF
   #FUN-B80125--(E)--
    IF cl_null(g_gxf.gxf011) THEN CALL cl_err('',-400,0) RETURN END IF
    #-->不為存入狀況則不可取消
    IF g_gxf.gxf11 != 0 THEN
       CALL cl_err(g_gxf.gxf17,'anm-643',0) RETURN
    END IF
    BEGIN WORK
    OPEN i820_cl USING g_gxf.gxf011
    IF STATUS THEN
       CALL cl_err("OPEN i820_cl:", STATUS, 1)
       CLOSE i820_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i820_cl INTO g_gxf.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_gxf.gxf011,SQLCA.sqlcode,0) RETURN END IF
    CALL i820_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gxf011"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gxf.gxf011      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM gxf_file WHERE gxf011 = g_gxf.gxf011
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","gxf_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
       END IF
       LET g_t1 = s_get_doc_no(g_gxf.gxf011)                   #MOD-A10095 add
       SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1  #MOD-A10095 add
       IF g_nmy.nmydmy3='Y' AND g_gxf.gxf38!='2' THEN  #MOD-A10095 add
          DELETE FROM npp_file
           WHERE nppsys= 'NM' AND npp00=12 AND npp01 = g_gxf.gxf011 AND npp011=1
          IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","npp_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
          END IF
          DELETE FROM npq_file
           WHERE npqsys= 'NM' AND npq00=12 AND npq01 = g_gxf.gxf011 AND npq011=1
          IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","npq_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
          END IF
          #FUN-B40056--add--str--
          DELETE FROM tic_file WHERE tic04 = g_gxf.gxf011
          IF STATUS THEN
             CALL cl_err3("del","tic_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",1)
          END IF
          #FUN-B40056--add--end--
       END IF   #MOD-A10095 add 
       CLEAR FORM
       OPEN i820_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i820_cs
          CLOSE i820_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i820_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i820_cs
          CLOSE i820_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i820_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i820_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i820_fetch('/')
       END IF
    END IF
    CLOSE i820_cl
    COMMIT WORK
    CALL cl_flow_notify(g_gxf.gxf011,'D')
END FUNCTION
#FUN-B80125--(B)-- 
FUNCTION i820_x()
   DEFINE l_year,l_month  LIKE type_file.num5,
          l_flag          LIKE type_file.chr1

   IF s_anmshut(0) THEN RETURN END IF
  #IF cl_null(g_gxf.gxf01) THEN          #MOD-D30193 mark
   IF cl_null(g_gxf.gxf011) THEN         #MOD-D30193 add
      CALL cl_err('',-400,0)
      RETURN
   END IF
  #SELECT * INTO g_gxf.* FROM gxi_file WHERE gxf01 = g_gxf.gxf01      #MOD-D30193 mark
   SELECT * INTO g_gxf.* FROM gxi_file WHERE gxf011 = g_gxf.gxf011    #MOD-D30193 add
   IF g_gxf.gxfconf='Y' THEN
     #CALL cl_err(g_gxf.gxf01,'anm-105',2)                            #MOD-D30193 mark
      CALL cl_err(g_gxf.gxf011,'anm-105',2)                           #MOD-D30193 add
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK
   OPEN i820_cl USING g_gxf.gxf011
   IF STATUS THEN
      CALL cl_err("OPEN i820_cl:", STATUS, 1)
      CLOSE i820_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i820_cl INTO g_gxf.*
   IF SQLCA.sqlcode THEN
     #CALL cl_err(g_gxf.gxf01,SQLCA.sqlcode,0)          #MOD-D30193 mark
      CALL cl_err(g_gxf.gxf011,SQLCA.sqlcode,0)         #MOD-D30193 add
      CLOSE i820_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_gxf_o.* = g_gxf.*
   LET g_gxf_t.* = g_gxf.*
   CALL i820_show()
   IF cl_void(0,0,g_gxf.gxfconf) THEN
      IF g_gxf.gxfconf='N' THEN    #切換為作廢
         DELETE FROM npp_file
          WHERE nppsys= 'NM' AND npp00=12 AND npp01 = g_gxf.gxf011 AND npp011=1
         IF STATUS THEN
            CALL cl_err3("del","npp_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",1)
         END IF
         DELETE FROM npq_file
          WHERE npqsys= 'NM' AND npq00=12 AND npq01 = g_gxf.gxf011 AND npq011=1
         IF STATUS THEN
            CALL cl_err3("del","npq_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",1)
         END IF
         DELETE FROM tic_file WHERE tic04 = g_gxf.gxf011
         IF STATUS THEN
            CALL cl_err3("del","tic_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",1)
         END IF
         LET g_gxf.gxfconf='X'
      ELSE                         #取消作廢
         LET g_gxf.gxfconf='N'
      END IF
      UPDATE gxf_file SET gxfconf=g_gxf.gxfconf
      #WHERE gxf01 = g_gxf.gxf01                                          #MOD-D30193 mark
       WHERE gxf011 = g_gxf.gxf011                                        #MOD-D30193 add
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        #CALL cl_err3("upd","gxf_file",g_gxf.gxf01,"",STATUS,"","",1)     #MOD-D30193 mark
         CALL cl_err3("upd","gxf_file",g_gxf.gxf011,"",STATUS,"","",1)    #MOD-D30193 add
         LET g_success='N'
      END IF
   END IF
   SELECT gxfconf INTO g_gxf.gxfconf FROM gxf_file
   #WHERE gxf01 = g_gxf.gxf01                            #MOD-D30193 mark
    WHERE gxf011 = g_gxf.gxf011                          #MOD-D30193 add
   DISPLAY BY NAME g_gxf.gxfconf
   CLOSE i820_cl
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
     #CALL cl_flow_notify(g_gxf.gxf01,'V')                #MOD-D30193 mark
      CALL cl_flow_notify(g_gxf.gxf011,'V')               #MOD-D30193 add
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
#FUN-B80125--(E)-- 
FUNCTION i820_y()   #confirm
DEFINE l_nme        RECORD LIKE nme_File.*
DEFINE l_gxf011_old LIKE gxf_file.gxf011
DEFINE only_one     LIKE type_file.chr1     #NO.FUN-680107 VARCHAR(1)
DEFINE l_n          LIKE type_file.num5     #No.FUN-670060 #No.FUN-680107 SMALLINT

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   IF g_gxf.gxfconf = 'Y' THEN
        RETURN
   END IF
  #FUN-B80125--(B)--
   IF g_gxf.gxfconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
  #FUN-B80125--(E)--
   OPEN WINDOW i820_w2 AT 5,14
        WITH FORM "anm/42f/anmi8201"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmi8201")
 
 
   LET l_gxf011_old=g_gxf.gxf011    # backup old key value gxf011
   LET only_one = '1'
   LET g_success='Y'
 
   BEGIN WORK
 
   INPUT BY NAME only_one WITHOUT DEFAULTS
   AFTER FIELD only_one
      IF only_one IS NULL THEN NEXT FIELD only_one END IF
      IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i820_w2 RETURN END IF
   IF only_one = '1' THEN
      SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011 = g_gxf.gxf011
      IF g_gxf.gxfconf='Y' THEN
         CLOSE WINDOW i820_w2  #No.MOD-480310
         RETURN
      END IF
      LET g_wc = " gxf011 = '",g_gxf.gxf011,"' "
   ELSE
      CONSTRUCT BY NAME g_wc ON gxf011,gxf03
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i820_w2 RETURN END IF
      IF NOT cl_sure(20,20) THEN CLOSE WINDOW i820_w2 RETURN END IF
   END IF
   #資料權限的檢查
 
   MESSAGE "WORKING !"
   LET g_sql = "SELECT * FROM gxf_file ",
               " WHERE ",g_wc CLIPPED,
               " AND (gxfconf='N' OR gxfconf IS NULL)"
   PREPARE i820_firm1_p1 FROM g_sql
#  IF STATUS THEN CALL cl_err('i820_firm1_p1',STATUS,1) END IF  #TQC-B10069
   IF STATUS THEN                                      #TQC-B10069
      CALL s_errmsg("","",'i820_firm1_p1','STATUS',1)  #TQC-B10069
      LET g_success = 'N'                              #TQC-B10069
   END IF                                              #TQC-B10069 
   DECLARE i820_firm1_curs CURSOR FOR i820_firm1_p1
 
   LET g_success = 'Y'  #No.MOD-480310
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   FOREACH i820_firm1_curs INTO g_gxf.*
#TQC-B10069 -----------------------Begin-------------------------------------
   #  IF STATUS THEN CALL cl_err('foreach',STATUS,1) EXIT FOREACH END IF    
      IF STATUS THEN
         CALL s_errmsg("","",'foreach',STATUS,1) 
         LET g_success = 'N'                              
         EXIT FOREACH
      END IF 
#TQC-B10069 -----------------------End---------------------------------------
      IF g_gxf.gxf03 <= g_nmz.nmz10 THEN #no.5261
#TQC-B10069 ------------------------Begin------------------------------------
      #  CALL cl_err(g_gxf.gxf011,'aap-176',1) LET g_success='N' EXIT FOREACH
         CALL s_errmsg("gxf011",g_gxf.gxf011,"",'aap-176',1)
         LET g_success='N'        
         CONTINUE FOREACH     
#TQC-B10069 ------------------------End--------------------------------------
      END IF
 
      LET g_t1=''
      INITIALIZE g_nmy.* TO NULL
      LET g_t1 = s_get_doc_no(g_gxf.gxf011)       #No.FUN-550057
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
 
      CALL s_get_bookno(YEAR(g_gxf.gxf03)) RETURNING g_flag,g_bookno1,g_bookno2       #No.FUN-740009
      IF g_flag = '1' THEN
      #  CALL cl_err(YEAR(g_gxf.gxf03),'aoo-081',1)                          #TQC-B10069
         CALL s_errmsg("gxf03",g_gxf.gxf011,YEAR(g_gxf.gxf03),'aap-176',1)   #TQC-B10069
         LET g_success = 'N' 
      END IF
      IF g_nmy.nmydmy3='Y' AND g_nmy.nmyglcr='N' AND g_gxf.gxf38!='2' THEN  #No.FUN-670060  #MOD-A10095  #TQC-A10164 mod
          CALL s_chknpq1(g_gxf.gxf011,1,12,'0',g_bookno1)   #-->NO:0151
          IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
             CALL s_chknpq1(g_gxf.gxf011,1,12,'1',g_bookno2)   #-->NO:0151       #No.FUN-730032
          END IF
       #  IF g_success ='N' THEN EXIT FOREACH END IF      #TQC-B10069
          IF g_success ='N' THEN CONTINUE FOREACH END IF  #TQC-B10069
      END IF
 
      IF g_nmy.nmydmy3='Y' AND g_nmy.nmyglcr='Y' AND g_gxf.gxf38!='2' THEN  #MOD-A10095 mod
         SELECT COUNT(*) INTO l_n FROM npq_file 
          WHERE npqsys= 'NM'
            AND npq00=12
            AND npq01 = g_gxf.gxf011
            AND npq011=1
         IF l_n = 0 THEN
            CALL i820_gen_glcr(g_gxf.*,g_nmy.*)
         END IF
         IF g_success = 'Y' THEN 
            CALL s_chknpq1(g_gxf.gxf011,1,12,'0',g_bookno1)   #-->NO:0151       #No.FUN-730032
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL s_chknpq1(g_gxf.gxf011,1,12,'1',g_bookno2)   #-->NO:0151       #No.FUN-730032
            END IF
         #  IF g_success ='N' THEN EXIT FOREACH END IF      #TQC-B10069
            IF g_success ='N' THEN CONTINUE FOREACH END IF  #TQC-B10069 
         END IF
      END IF 
 
      IF g_success='Y' THEN
         UPDATE gxf_file SET gxfconf='Y' WHERE gxf011=g_gxf.gxf011
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         #   CALL cl_err3("upd","gxf_file",g_gxf.gxf011,"",STATUS,"","upd gxfconf",1)  #No.FUN-660148
             CALL s_errmsg("gxf011",g_gxf.gxf011,"upd gxfconf",'STATUS',1)             #TQC-B10069
             LET g_success='N'                 #TQC-B10069
             CONTINUE FOREACH                  #TQC-B10069
         #   LET g_success='N' EXIT FOREACH    #TQC-B10069
         END IF
      END IF
     #IF g_gxf.gxf41 != 'Y' AND g_gxf.gxf38 != '2' THEN  #No.FUN-5C0093 判斷gxf41如為'Y' 則不insert into nme_file #NO.FUN-870145 #MOD-C20015 mark
      IF g_gxf.gxf41 != 'Y' THEN                         #MOD-C20015 add
         INITIALIZE l_nme.* TO NULL
         #新增銀行存款異動記錄檔
         LET l_nme.nme00 = 0
         LET l_nme.nme01 = g_gxf.gxf02
         LET l_nme.nme02 = g_gxf.gxf03
         LET l_nme.nme16 = g_gxf.gxf03
         LET l_nme.nme03 = g_gxf.gxf07
         LET l_nme.nme04 = g_gxf.gxf021
         LET l_nme.nme05 = g_gxf.gxf12
         SELECT nma05 INTO l_nme.nme06 FROM nma_file
          WHERE nma01 = l_nme.nme01
         IF g_aza.aza63 = 'Y' THEN
            SELECT nma051 INTO l_nme.nme061 FROM nma_file
             WHERE nma01 = l_nme.nme01
         END IF
         LET l_nme.nme07 = g_gxf.gxf25
         LET l_nme.nme08 = g_gxf.gxf26
         LET l_nme.nme12 = g_gxf.gxf011
         SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
          WHERE nmc01 = g_gxf.gxf07
         LET l_nme.nme17 = ' '        #No:8270
         LET l_nme.nmeuser = g_user
         LET l_nme.nmegrup = g_grup
         LET l_nme.nmedate = g_today
         LET l_nme.nme21 = '1'
         LET l_nme.nme22 = '17'
         LET l_nme.nme24 = '9'
 
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
#TQC-B10069 ----------------------------------Begin--------------------------------------
         #  CALL cl_err3("ins","nme_file",l_nme.nme01,"",STATUS,"","ins nme1:",1)  #No.FUN-660148
         #  LET g_success='N' EXIT FOREACH
            CALL s_errmsg("",l_nme.nme01,"ins nme1:",'STATUS',1) 
            LET g_success='N'
            CONTINUE FOREACH
#TQC-B10069 ----------------------------------End----------------------------------------
         END IF
         CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062 
         INITIALIZE l_nme.* TO NULL
         LET l_nme.nme00 = 0
         LET l_nme.nme01 = g_gxf.gxf32
         LET l_nme.nme02 = g_gxf.gxf03
         LET l_nme.nme03 = g_gxf.gxf34
         LET l_nme.nme04 = g_gxf.gxf33f
         LET l_nme.nme05 = g_gxf.gxf37
         SELECT nma05 INTO l_nme.nme06 FROM nma_file
          WHERE nma01 = l_nme.nme01
         IF g_aza.aza63 = 'Y' THEN
            SELECT nma051 INTO l_nme.nme061 FROM nma_file
             WHERE nma01 = l_nme.nme01
         END IF
         LET l_nme.nme07 = g_gxf.gxf36      #no.6772
         LET l_nme.nme08 = g_gxf.gxf33
         LET l_nme.nme12 = g_gxf.gxf011
         SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
          WHERE nmc01 = g_gxf.gxf34
         LET l_nme.nme16 = g_gxf.gxf03
         LET l_nme.nme17 = ' '              #No:8270
         LET l_nme.nmeuser = g_user
         LET l_nme.nmegrup = g_grup
         LET l_nme.nmedate = g_today
         LET l_nme.nme22 = '17'             #MOD-A20037 add
         LET l_nme.nme21 = '0'              #TQC-AB0406 
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
#TQC-B10069 ---------------------------Begin------------------------------
         #  CALL cl_err3("ins","nme_file",l_nme.nme01,"",STATUS,"","ins nme2:",1)  #No.FUN-660148
         #  LET g_success='N' EXIT FOREACH
            CALL s_errmsg("",l_nme.nme01,"ins nme2:",'STATUS',1) 
            LET g_success='N'
            CONTINUE FOREACH
#TQC-B10069 ---------------------------End-------------------------------- 
         END IF
         CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
      END IF #No.FUN-5C0093
   END FOREACH  
   CLOSE WINDOW i820_w2  #MOD-550025  
      IF g_success='N' THEN
         SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011 = l_gxf011_old
         ROLLBACK WORK RETURN
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_gxf.gxf011,'Y')  
         CALL cl_cmmsg(1)                      
      END IF
   SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011 = l_gxf011_old
 
   IF g_nmy.nmydmy3='Y' AND g_nmy.nmyglcr='Y' AND g_success='Y' AND
      g_gxf.gxf38!='2' THEN   #MOD-A10095 add
      LET g_wc_gl = 'npp01 = "',g_gxf.gxf011,'" AND npp011 = 1'
      LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_gxf.gxf03,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
      CALL cl_cmdrun_wait(g_str) 
      SELECT gxf13,gxf14 INTO g_gxf.gxf13,g_gxf.gxf14 FROM gxf_file                                                                 
       WHERE gxf011 = g_gxf.gxf011                                                                                                    
      DISPLAY BY NAME g_gxf.gxf13                                                                                                   
      DISPLAY BY NAME g_gxf.gxf14                                                                                                   
   END IF                                                                                                                           
 
   DISPLAY g_gxf.gxfconf TO gxfconf
END FUNCTION
 
FUNCTION i820_z()
   DEFINE l_aba19      LIKE aba_file.aba19     #No.FUN-670060
   DEFINE l_dbs        STRING                  #No.FUN-670060
   DEFINE l_sql        STRING                  #No.FUN-670060   
   DEFINE l_nme24      LIKE nme_file.nme24    #No.FUN-730032
   DEFINE l_cnt        LIKE type_file.num5    #MOD-820151
 
   #FUN-B80125--Begin--
   IF g_gxf.gxfconf='N' THEN RETURN END IF
   IF g_gxf.gxfconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   #FUN-B80125---End---
    IF cl_null(g_gxf.gxf011) THEN RETURN END IF
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt FROM gxg_file 
      WHERE gxg011=g_gxf.gxf011
    IF l_cnt > 0 THEN
       CALL cl_err(g_gxf.gxf011,'anm-123',0)
       RETURN
    END IF
   #MOD-A60016---add---start---
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt FROM gxl_file 
      WHERE gxl03=g_gxf.gxf011
    IF l_cnt > 0 THEN
       CALL cl_err(g_gxf.gxf011,'anm-643',0)
       RETURN
    END IF
   #MOD-A60016---add---end---    
    SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011=g_gxf.gxf011
    IF cl_null(g_gxf.gxfconf) OR g_gxf.gxfconf='N' THEN RETURN END IF
    IF g_gxf.gxf27>0 OR g_gxf.gxf11<>'0' THEN CALL cl_err(g_gxf.gxf011,'anm-285',1) RETURN END IF
 
 
 #FUN-B50090 add begin-------------------------
 #重新抓取關帳日期
    LET g_sql ="SELECT nmz10 FROM nmz_file ",
               " WHERE nmz00 = '0'"
    PREPARE nmz10_p1 FROM g_sql
    EXECUTE nmz10_p1 INTO g_nmz.nmz10
 #FUN-B50090 add -end--------------------------
    #-->立帳日期不可小於關帳日期
    IF g_gxf.gxf03 <= g_nmz.nmz10 THEN #no.5261
       CALL cl_err(g_gxf.gxf011,'aap-176',1) RETURN
    END IF
 
    #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原 
    CALL s_get_doc_no(g_gxf.gxf011) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF NOT cl_null(g_gxf.gxf13) OR NOT cl_null(g_gxf.gxf14) THEN
       IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
          CALL cl_err(g_gxf.gxf011,'axr-370',0) RETURN 
       END IF 
    END IF 
    IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN                                                                              
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
       #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gxf.gxf13,"'"
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre FROM l_sql
       DECLARE aba_cs CURSOR FOR aba_pre
       OPEN aba_cs
       FETCH aba_cs INTO l_aba19
       IF l_aba19 = 'Y' THEN
          CALL cl_err(g_gxf.gxf13,'axr-071',1)
          RETURN                                                                                                                     
       END IF                                                                                                                        
    END IF                                                                                                                           
 
    IF NOT cl_confirm('axr-109') THEN RETURN END IF
    LET g_success='Y'
   #--------------------------------CHI-C90051-----------------------------(S)
    IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
       LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxf.gxf13,"' 'Y'"
       CALL cl_cmdrun_wait(g_str)
       SELECT gxf13,gxf14 INTO g_gxf.gxf13,g_gxf.gxf14 FROM gxf_file
        WHERE gxf011 = g_gxf.gxf011
       DISPLAY BY NAME g_gxf.gxf13
       DISPLAY BY NAME g_gxf.gxf14
       IF NOT cl_null(g_gxf.gxf13) THEN
          CALL cl_err('','aap-929',0)
          RETURN
       END IF
    END IF
   #--------------------------------CHI-C90051-----------------------------(E)
    BEGIN WORK
    LET g_gxf.gxfconf='N'
    UPDATE gxf_file SET gxfconf='N'
     WHERE gxf011=g_gxf.gxf011
    IF STATUS THEN LET g_success='N' CALL cl_err('upd gxf',STATUS,0) END IF
    IF g_aza.aza73 = 'Y' THEN #No.MOD-740346
       LET g_sql="SELECT nme24 FROM nme_file",
                 " WHERE nme12='",g_gxf.gxf011,"'" 
       PREPARE i820_z_nme_p FROM g_sql
       FOREACH i820_z_nme_p INTO l_nme24
          IF l_nme24 <> '9' THEN
             CALL cl_err('','anm-043',1)
             LET g_success='N'
             RETURN
          END IF
       END FOREACH
    END IF #No.MOD-740346
    DELETE FROM nme_file WHERE nme12=g_gxf.gxf011
    IF STATUS THEN LET g_success='N' CALL cl_err('del nme',STATUS,0) END IF
    #FUN-B40056 --begin
    IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
       DELETE FROM tic_file WHERE tic04=g_gxf.gxf011
       IF STATUS THEN LET g_success='N' CALL cl_err('del tic',STATUS,0) END IF
    END IF
    #FUN-B40056 --end
    IF g_success='Y' THEN COMMIT WORK
                     ELSE ROLLBACK WORK LET g_gxf.gxfconf='Y' END IF
 
   #--------------------------------CHI-C90051-----------------------------mark
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN 
   #   LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxf.gxf13,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str) 
   #   SELECT gxf13,gxf14 INTO g_gxf.gxf13,g_gxf.gxf14 FROM gxf_file 
   #    WHERE gxf011 = g_gxf.gxf011
   #   DISPLAY BY NAME g_gxf.gxf13
   #   DISPLAY BY NAME g_gxf.gxf14
   #END IF 
   #--------------------------------CHI-C90051-----------------------------mark
 
    DISPLAY BY NAME g_gxf.gxfconf
END FUNCTION
 
FUNCTION i820_v() #產生分錄
DEFINE only_one   LIKE type_file.chr1        #NO.FUN-680107 VARCHAR(1)
DEFINE l_wc       LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(101)
       l_t1       LIKE oay_file.oayslip,     #NO.FUN-680107 VARCHAR(5) #No.FUN-550057
       l_nmydmy3  LIKE nmy_file.nmydmy3
DEFINE l_gxf      RECORD LIKE gxf_file.*
 
  #FUN-B80125--Begin--
   IF g_gxf.gxfconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
  #FUN-B80125---End---
 
   OPEN WINDOW i820_w1 AT 5,14
        WITH FORM "anm/42f/anmi8201"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmi8201")
 
 
   LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
     AFTER FIELD only_one
      IF only_one IS NULL THEN NEXT FIELD only_one END IF
      IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i820_w1 RETURN END IF
   IF only_one = '1'
      THEN
         LET l_wc = " gxf011 = '",g_gxf.gxf011,"' "
      ELSE
         CONSTRUCT BY NAME l_wc ON gxf011,gxf03
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
         IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i820_w1 RETURN END IF
   END IF
   CLOSE WINDOW i820_w1
   LET l_gxf.* = g_gxf.*   # backup old value
   MESSAGE "WORKING !"
   LET g_sql = "SELECT * FROM gxf_file WHERE ",l_wc CLIPPED,
               " ORDER BY gxf011"
   PREPARE i820_v_p FROM g_sql
   DECLARE i820_v_c CURSOR WITH HOLD FOR i820_v_p
   LET g_success='Y' #no.5573
   BEGIN WORK #no.5573
   FOREACH i820_v_c INTO g_gxf.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_t1 = s_get_doc_no(g_gxf.gxf011)       #No.FUN-550057
      IF NOT cl_null(g_gxf.gxf13) THEN
         #該entry_sheet已拋轉總帳系統, 不允許重新產生 !
         CALL cl_getmsg('aap-122',g_lang) RETURNING g_msg
         MESSAGE g_gxf.gxf011,g_msg
         sleep 1
         CONTINUE FOREACH
      END IF
     #IF g_gxf.gxf38 = '2' THEN   #續約                        #MOD-C50059 mark
      IF g_gxf.gxf38 = '2' AND g_gxf.gxf02 = g_gxf.gxf32 THEN  #MOD-C50059
         #續約的存單資料不可產生分錄
         CALL cl_err(g_gxf.gxf011,'anm-820',0)
         CONTINUE FOREACH
      END IF
      #判斷該單別是否須拋轉總帳
      SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t1
      IF STATUS OR cl_null(l_nmydmy3) THEN LET l_nmydmy3 = 'N' END IF
      IF l_nmydmy3 = 'N' THEN CONTINUE FOREACH END IF
      IF g_gxf.gxfconf='Y' THEN
         CALL cl_getmsg('anm-232',g_lang) RETURNING g_msg
         MESSAGE g_gxf.gxf011,g_msg
         sleep 1
         CONTINUE FOREACH
      END IF
      CALL s_i820_gl(g_gxf.gxf011,'0')
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_i820_gl(g_gxf.gxf011,'1')
      END IF
   END FOREACH
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF #no.5573
   LET g_gxf.*=l_gxf.*
   MESSAGE " "
END FUNCTION
 
FUNCTION i820_1()
DEFINE  l_n             LIKE type_file.num5,   #No.FUN-680107 SMALLINT
        g_gxf01_o       LIKE gxf_file.gxf01
 
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011 = g_gxf.gxf011
    IF STATUS THEN 
       CALL cl_err3("sel","gxf_file",g_gxf.gxf011,"",STATUS,"","",1)  #No.FUN-660148
       RETURN END IF
    IF g_gxf.gxf011 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_gxf.gxf11 = '3' OR g_gxf.gxf11 = '4' THEN RETURN END IF
 
    DISPLAY BY NAME  g_gxf.gxf01
    LET g_gxf01_o = g_gxf.gxf01
    INPUT BY NAME g_gxf.gxf01 WITHOUT DEFAULTS
 
    AFTER FIELD gxf01         #存單號碼
       IF g_gxf.gxf01 IS NULL THEN
          CALL cl_err(g_gxf.gxf01,'anm-003',0)
          NEXT FIELD gxf01
       END IF
       SELECT COUNT(*) INTO l_n FROM gxf_file
        WHERE gxf01 = g_gxf.gxf01 AND gxf011<>g_gxf.gxf011   #No:8133
       IF l_n > 0 THEN                  # Duplicated
          CALL cl_err(g_gxf.gxf01,-239,0)
          NEXT FIELD gxf01
       END IF
     AFTER INPUT
        #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           RETURN
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
     BEGIN WORK
     LET g_success = 'Y'
     UPDATE gxf_file SET gxf01 = g_gxf.gxf01
      WHERE gxf011 = g_gxf.gxf011
     IF STATUS THEN
        CALL cl_err3("upd","gxf_file",g_gxf.gxf011,"",STATUS,"","upd gxf",1)  #No.FUN-660148
        LET g_gxf.gxf01 = g_gxf01_o
        DISPLAY BY NAME g_gxf.gxf01
        LET g_success = 'N'
     END IF
     IF g_success='N' THEN
        ROLLBACK WORK
     ELSE
        COMMIT WORK
        CALL cl_cmmsg(1)
     END IF
END FUNCTION
 
FUNCTION i820_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gxf011",TRUE)
   END IF
END FUNCTION
 
FUNCTION i820_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd='u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gxf011",FALSE)
   END IF
END FUNCTION
 
FUNCTION i820_gen_glcr(p_gxf,p_nmy)
  DEFINE p_gxf     RECORD LIKE gxf_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_gxf.gxf011,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_i820_gl(g_gxf.gxf011,'0')
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL s_i820_gl(g_gxf.gxf011,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION i820_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5    #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING 
  DEFINE l_n          LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_gxf.gxf13) OR g_gxf.gxf13 IS NOT NULL THEN
       CALL cl_err(g_gxf.gxf13,'aap-618',1)
       RETURN
    END IF
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxf.gxf011) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gxf.gxf13,"'"
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_gxf.gxf13,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1)  #FUN-940036
       RETURN
       #開窗作業
       LET g_plant_new= g_nmz.nmz02p
       CALL s_getdbs()
       LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
       LET g_plant_gl= g_nmz.nmz02p  #No.FUN-980059
 
       OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_locale("axrt200_p")
        
       INPUT l_nmygslp WITHOUT DEFAULTS FROM FORMONLY.gl_no
    
          AFTER FIELD gl_no
             CALL s_check_no("agl",l_nmygslp,"","1","aac_file","aac01",g_plant_gl) #No.FUN-560190 #TQC-9B0162
                   RETURNING li_result,l_nmygslp
             IF (NOT li_result) THEN
                NEXT FIELD gl_no
             END IF
     
          AFTER INPUT
             IF INT_FLAG THEN
                EXIT INPUT 
             END IF
             IF cl_null(l_nmygslp) THEN
                CALL cl_err('','9033',0)
                NEXT FIELD gl_no  
             END IF
    
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          ON ACTION CONTROLG
             CALL cl_cmdask()
          ON ACTION CONTROLP
             IF INFIELD(gl_no) THEN
                CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_nmygslp,'1',' ',' ','AGL')  #No.FUN-980059
                RETURNING l_nmygslp
                DISPLAY l_nmygslp TO FORMONLY.gl_no
                NEXT FIELD gl_no
             END IF
    
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
     
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
     
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
     
          ON ACTION exit  #加離開功能genero
             LET INT_FLAG = 1
             EXIT INPUT
 
       END INPUT
       CLOSE WINDOW t200p  
    END IF
    IF cl_null(l_nmygslp) OR (cl_null(g_nmy.nmygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680088
       CALL cl_err(g_gxf.gxf011,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_gxf.gxf011,'" AND npp011 = 1'
    LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_gxf.gxf03,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
    CALL cl_cmdrun_wait(g_str) 
    SELECT gxf13,gxf14 INTO g_gxf.gxf13,g_gxf.gxf14 FROM gxf_file                                                                 
     WHERE gxf011 = g_gxf.gxf011                                                                                                    
    DISPLAY BY NAME g_gxf.gxf13                                                                                                   
    DISPLAY BY NAME g_gxf.gxf14                                                                                                   
END FUNCTION
 
FUNCTION i820_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_dbs      STRING 
  DEFINE l_sql      STRING
  
    IF cl_null(g_gxf.gxf13) OR g_gxf.gxf13 IS NULL THEN
       CALL cl_err(g_gxf.gxf13,'aap-619',1)
       RETURN 
    END IF 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxf.gxf01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_gxf.gxf13,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_gxf.gxf13,'axr-071',1)
       RETURN
    END IF
    LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxf.gxf13,"' 'Y'"
    CALL cl_cmdrun_wait(g_str) 
    SELECT gxf13,gxf14 INTO g_gxf.gxf13,g_gxf.gxf14 FROM gxf_file 
     WHERE gxf011 = g_gxf.gxf011
    DISPLAY BY NAME g_gxf.gxf13
    DISPLAY BY NAME g_gxf.gxf14
END FUNCTION
 
FUNCTION i820_out()
   DEFINE l_name      LIKE type_file.chr20,    #No.FUN-680107 VARCHAR(20)
          l_buf       LIKE type_file.chr6,     #No.FUN-680107 VARCHAR(6)
          l_sql       STRING
   DEFINE sr          RECORD
                      gxf      RECORD LIKE gxf_file.*,
                      nma02_1  LIKE nma_file.nma02,
                      nma02_2  LIKE nma_file.nma02,   
                      nmc02    LIKE nmc_file.nmc02,
                      nmc02_2  LIKE nmc_file.nmc02,
                      azi07   LIKE azi_file.azi07,     #No.FUN-870151
                      azi07_1  LIKE azi_file.azi07     #No.FUN-870151
                      END RECORD
   DEFINE l_str1      LIKE type_file.chr1000   #No.FUN-770038
   DEFINE l_str2      LIKE type_file.chr1000   #No.FUN-770038
   DEFINE l_str3      LIKE type_file.chr1000   #No.FUN-770038
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0082
 
   CALL cl_del_data(l_table)
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmi820'
 
   LET l_sql = "SELECT gxf_file.*,'','','',''",
               "  FROM gxf_file",
               " WHERE ",g_wc CLIPPED,
               " ORDER BY gxf01"
 
   PREPARE i820_pre FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE i820_curs CURSOR FOR i820_pre
 
 
   FOREACH i820_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_buf = s_get_doc_no(sr.gxf.gxf01)
 
      SELECT nmc02 INTO sr.nmc02  FROM nmc_file 
       WHERE nmc01=sr.gxf.gxf07
  
      SELECT nmc02 INTO sr.nmc02_2 FROM nmc_file 
       WHERE nmc01=sr.gxf.gxf34
 
      SELECT nma02 INTO sr.nma02_1 FROM nma_file
       WHERE nma01=sr.gxf.gxf02
   
      SELECT nma02 INTO sr.nma02_2 FROM nma_file
       WHERE nma01=sr.gxf.gxf32     #MOD-730012
       
      SELECT azi07 INTO sr.azi07 FROM azi_file 
       WHERE azi01 = sr.gxf.gxf24
      SELECT azi07 INTO sr.azi07_1 FROM azi_file 
       WHERE azi01 = sr.gxf.gxf35       
 
      IF NOT cl_null(sr.gxf.gxf11) THEN
         LET l_str1=sr.gxf.gxf11 USING "<<<<&",":",i820_getdesc('gxf11',sr.gxf.gxf11)
      ELSE
         LET l_str1=NULL
      END IF
      IF NOT cl_null(sr.gxf.gxf38) THEN
         LET l_str2=sr.gxf.gxf38,":",i820_getdesc('gxf38',sr.gxf.gxf38)
      ELSE
         LET l_str2=NULL
      END IF
      IF NOT cl_null(sr.gxf.gxf04) THEN
         LET l_str3=sr.gxf.gxf04 USING "<<<<&",":",i820_getdesc('gxf04',sr.gxf.gxf04)
      ELSE
         LET l_str3=NULL
      END IF
      EXECUTE insert_prep USING
              sr.gxf.gxf01, sr.gxf.gxf011, sr.gxf.gxf02,  sr.gxf.gxf021,
              sr.gxf.gxf03, sr.gxf.gxf04,  sr.gxf.gxf05,  sr.gxf.gxf06,  
              sr.gxf.gxf07, sr.gxf.gxf08,  sr.gxf.gxf11,  sr.gxf.gxf12,  
              sr.gxf.gxf13, sr.gxf.gxf14,  sr.gxf.gxf24,  sr.gxf.gxf25, 
              sr.gxf.gxf26, sr.gxf.gxf27,  sr.gxf.gxf28,  sr.gxf.gxf29, 
              sr.gxf.gxf30, sr.gxf.gxf32,  sr.gxf.gxf33,  sr.gxf.gxf33f, 
              sr.gxf.gxf34, sr.gxf.gxf35,  sr.gxf.gxf36,  sr.gxf.gxf37,  
              sr.gxf.gxf38, sr.gxf.gxf41,  sr.gxf.gxfconf, sr.nma02_1,
              sr.nma02_2, sr.nmc02, sr.nmc02_2,
              l_str1, l_str2, l_str3
              ,sr.azi07,sr.azi07_1     #No.FUN-870151
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'gxf011')
           RETURNING g_str
   END IF
   CALL cl_prt_cs3('anmi820','anmi820',g_sql,g_str)
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0082
 
END FUNCTION
 
 
FUNCTION i820_getdesc(p_field,p_value)
   DEFINE p_field LIKE gae_file.gae02
   DEFINE p_value LIKE gae_file.gae02
   DEFINE l_sql STRING
   DEFINE l_res   LIKE gae_file.gae04
   LET l_sql="SELECT gae04 FROM gae_file WHERE gae01='anmi820'",
             " AND gae03='",g_lang,"' AND gae02='",
             p_field CLIPPED,"_",p_value CLIPPED,"'"
   DECLARE i820_getdesc_c CURSOR FROM l_sql
   FOREACH i820_getdesc_c INTO l_res
      EXIT FOREACH
   END FOREACH
   RETURN l_res CLIPPED
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14

