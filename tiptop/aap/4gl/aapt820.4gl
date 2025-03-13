# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: aapt820.4gl
# Descriptions...: 信用狀到單作業
# Date & Author..: 95/11/10 By Roger
# Modify.........: MOD-470303 04/07/28 By ching field_pic 錯誤
# Modify.........: No.FUN-4B0054 04/11/23 By ching add 匯率開窗 call s_rate
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0073 04/12/14 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-510147 05/01/24 By kitty  有二個action name寫錯
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-540059 05/06/19 By day 單據編號修改
# Modify.........: No.MOD-590366 05/10/20 By Smapmin 給予預設值.沒有aapr510該支報表程式,故相關程式段先mark起來.
# Modify.........: No.MOD-590440 05/11/03 By ice 依月底重評價對AP未付金額額調整,修正未付金額apa73的計算方法
# Modify.........: No.MOD-5A0393 05/11/09 By Smapmin 單身的到單匯率開窗後的數字(匯率轉換視窗),打小數會被自動轉換成整數
# Modify.........: No.MOD-5B0254 05/11/21 By Smapmin 融資資料產生視窗,只能單選
# Modify.........: NO.MOD-5B0175 05/11/21 BY yiting 產生分錄底稿時, 不須要判斷要default 異動碼值, 因為每家客戶的異動碼值規劃並不同
# Modify.........: No.FUN-590081 05/11/24 By Smapmin 新增列印功能
#                                                    到單匯率應依幣別自動抓取
#                                                    到單匯率沒有卡到幣別小數位取位
# Modify.........: No.MOD-5C0012 05/12/06 By Smapmin 科目資料維護不應只能做"明細科目"
# Modify.........: NO.FUN-5C0015 05/12/20 By alana
# call s_def_npq.4gl 抓取異動碼default值
# Modify.........: No.MOD-610072 06/01/16 By Smapmin 到期還款時,廠商簡稱為空白
# Modify.........: No.MOD-610073 06/01/16 By Smapmin 會計傳票號碼也要拋轉至aapt120
# Modify.........: No.TQC-5C0110 06/01/20 By Smapmin 取消改貸別
# Modify.........: No.MOD-5C0140 06/01/20 By Smapmin 融資單別必需為不拋轉傳票者
# Modify.........: No.MOD-630014 06/03/03 By Smapmin 修改金額後詢問是否重新產生分錄
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.MOD-640015 06/04/06 By Smapmin 轉融資時,新增還息日期欄位.nne43預設為目前工廠
# Modify.........: No.FUN-640022 06/04/10 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-650007 06/05/03 By Smapmin 付款方式類別不為3or8時,alh06不可空白
# Modify.........: No.TQC-660072 06/06/14 By Dido 補充TQC-630070
# Modify.........: No.FUN-660122 06/06/20 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670060 06/08/01 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680019 06/08/08 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680029 06/08/18 By Ray 多帳套修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By hellen 本原幣取位修改
# Modify.........: No.TQC-6A0081 06/11/08 By baogui 報表問題修改 
# Modify.........: No.FUN-6A0016 06/11/14 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.CHI-690070 06/12/06 By Smapmin 回寫aapt110的已付金額
# Modify.........: No.FUN-690104 06/12/06 By Smapmin 拋轉融資視窗的改貸日期放置於 nne111
# Modify.........: No.MOD-680085 06/12/08 By Smapmin 修改幣別取位問題
# Modify.........: No.MOD-690114 06/12/14 By Mandy alh44 = '2',alh06開alg_file else alh06開pmc_file
# Modify.........: No.MOD-690114 06/12/14 By Mandy alh06 不可空白,改由直接在aapt820.per alh06屬性加NOT NULL,REQUIRED
# Modify.........: No.TQC-690081 06/12/14 By Mandy 付款條件開窗增加條件,需符合 AFTER FIELD alh10 check 邏輯
# Modify.........: No.MOD-6C0111 06/12/19 By Smapmin alh52為空白或N時,都要UPDATE ala25
# Modify.........: No.MOD-720025 07/02/06 By Smapmin 給予產生融資資料預設值
# Modify.........: No.FUN-710086 07/02/09 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加CR參數
# Modify.........: No.FUN-730064 07/04/04 By hongmei 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/17 By lora    
# Modify.........: No.MOD-740517 07/04/30 By Smapmin 修正CHI-690070
# Modify.........: No.MOD-750005 07/05/02 By Smapmin 修改"到期還款"與"到期還款還原" update aapt110的已付金額
# Modify.........: No.MOD-740499 07/05/09 By Carrier 審核時,科目檢查時傳錯帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7B0044 07/11/06 By Smapmin 應還日=起息日+還款天數
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.CHI-810016 08/02/19 By Judy 寫入多帳期資料(apc_file)
# Modify.........: No.MOD-830072 08/03/10 By Smapmin列印次數default為0
# Modify.........: No.MOD-830085 08/03/11 By Smapmin 分錄底稿的廠商編號/簡稱未帶出
# Modify.........: No.FUN-850038 08/05/12 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-880094 08/08/13 By Sarah t820_g()段,當alh30不為空時,增加UPDATE apa_file的apa35f,apa35
# Modify.........: No.CHI-890017 08/11/24 By Sarah 回寫apa35時也需一併回寫apa73=apa34-apa35+g_net
# Modify.........: No.MOD-8B0298 08/12/01 By clover alh30狀態須確認才可選擇
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.MOD-930296 09/03/30 By Sarah 新增後無法直接列印
# Modify.........: No.MOD-960220 09/06/18 By baofei USING '<<<<<<<.<<' 改成 USING '<<<<<<<<<<<<<<.<<'                               
# Modify.........: No.MOD-970175 09/07/20 By mike 當抓取aps_file抓不到資料時,應提示參數檔沒資料!  
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980076 09/08/27 By TSD.apple    GP5.2架構重整，移除xxxplant 
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alaplant該為ala97 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/25 By hongmei 抓apz63欄位寫入apa77
# Modify.........: No.FUN-990014 09/09/08 By hongmei 先抓apyvcode申報統編，若無則將apz63的值寫入apa77/apk32
# Modify.........: No.MOD-990158 09/09/16 By mike 功能鍵融資資料產生時(產生到anmt710)，其額度匯率(nneex2)應為aapt710之ala79         
# Modify.........: No.MOD-990222 09/09/25 By Sarah UPDATE apa_file時應一併UPDATE apc_file
# Modify.........: No.CHI-9A0004 09/10/14 By sabrina 當客戶有超押的狀況(即到單金額大於信用狀金額時)
#                                                    預付本幣之計算alh19，應不能大於aapt720預付之10%
#                                                    alh19欄位變更為可輸入，但金額不可大於ala59+ala60
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No:TQC-9C0044 09/12/08 By Carrier alh50比率输入值控管
# Modify.........: No:MOD-9C0448 09/12/30 By Sarah 產生分錄時,若為先到單則借方分錄的匯率應抓到單匯率,若先到貨則抓到貨匯率
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A40003 10/05/21 By wujie   增加apa79，预设为N
# Modify.........: No:FUN-A60024 10/06/12 By wujie   调整apa79的值为0 
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整  
# Modify.........: No.FUN-A50102 10/07/26 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B10030 11/01/19 By Mengxw Remove "switch_plant" action
# Modify.........: No.FUN-B10050 11/01/21 By Carrier 科目查询自动过滤
# Modify.........: No.FUN-AA0087 11/01/27 By Mengxw  異動碼類型設定的改善
# Modify.........: No:FUN-B40056 11/05/10 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:MOD-B50111 11/05/12 By Dido AFTER INPUT 檢核錯誤應跳至 alh03 
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No:MOD-B50138 11/05/17 By Dido 當使用alh06時,npq22應判斷當alh44為'1'才用 pmc_file 
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-B40092 11/08/01 By xujing 改寫報表程式 CALL aapr824 
# Modify.........: No.MOD-B80312 11/08/29 By Polly 修正t820_ins_ap12()中的 apa07改用 l_pmc03
# Modify.........: No.TQC-B90255 11/10/08 By yinhy 查詢時，資料建立者，資料建立部門欄位無法下查詢條件
# Modify.........: No.MOD-BA0144 11/10/20 By Polly FUNCTION t820_ins_ap12 請將 apa35f/apa35 給予 apa34f/apa34
# Modify.........: No:MOD-BC0246 11/12/27 By Dido apa22 部門預設值調整 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C20121 12/02/16 By Polly 進入直接付款action時，重抓t_azi04的值
# Modify.........: No:MOD-C30034 12/03/06 By Polly 因為不會寫入nne_file，故還原MOD-BA0144調整
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:MOD-C80026 12/08/08 By Polly 輸入預購單號後，需將預設值帶出
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
# Modify.........: No:MOD-CC0092 12/12/13 By Vampire FUNCTION t820_ins_ap12/t820_del_ap12 中的 IF g_alh.alh30 IS NOT NULL THEN 整段處理,移至FUNCTION t820_firm1/t820_firm2 的 CALL t820_hu(1,0) 後面  
# Modify.........: No.MOD-D20154 13/03/01 By Polly 調整摘要(npq04)的抓取
# Modify.........: No.FUN-D10065 13/03/05 By qirl npq04給值方式MOD-D20154已經修改過
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_alh   RECORD LIKE alh_file.*,
    g_alh_t RECORD LIKE alh_file.*,
    g_alh_o RECORD LIKE alh_file.*,
    g_alh01_t LIKE alh_file.alh01,
    g_ala   RECORD LIKE ala_file.*,
    g_alk   RECORD LIKE alk_file.*,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    l_no                LIKE apa_file.apa01,              #FUN-660117
    l_date              LIKE type_file.dat,     #No.FUN-690028 DATE
    l_date1             LIKE type_file.dat,     #FUN-690104
    l_date2             LIKE type_file.num10,       # No.FUN-690028 INTEGER,   #MOD-640015
    g_statu             LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),       # 是否從新賦予等級
    g_dbs_gl 	        LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    g_plant_gl 	        LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),  #No.FUN-980059
    g_dbs_nm 	        LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    nm_no_b,nm_no_e 	LIKE type_file.num10,       # No.FUN-690028 INTEGER,
    gl_no_b,gl_no_e     LIKE apa_file.apa01,        # No.FUN-690028 VARCHAR(16),      #No.FUN-550030
    g_pma11             LIKE pma_file.pma11,
    g_buf               LIKE type_file.chr1000,             #  #No.FUN-690028 VARCHAR(78)
    g_tot               LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_rec_b             LIKE type_file.num5,                #單身筆數  #No.FUN-690028 SMALLINT
    g_argv1             LIKE alh_file.alh01,
    g_argv2             STRING,                #TQC-630070      #執行功能
    l_ac                LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
    l_n                 LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
    l_sl                LIKE type_file.num5                 #目前處理的SCREEN LINE  #No.FUN-690028 SMALLINT
DEFINE g_net           LIKE apv_file.apv04    #MOD-59044
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_system         LIKE type_file.chr2        # No.FUN-690028 VARCHAR(2)
DEFINE g_zero           LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_N              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
 
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_str          STRING     #No.FUN-670060
DEFINE   g_wc_gl        STRING     #No.FUN-670060
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   l_table        STRING                 #No.FUN-710086
DEFINE   g_sql1         STRING                 #No.FUN-710086
DEFINE   g_bookno       LIKE aag_file.aag00    #No.FUN-730064
DEFINE   g_bookno1      LIKE aza_file.aza81    #No.FUN-730064
DEFINE   g_bookno2      LIKE aza_file.aza82    #No.FUN-730064
DEFINE   g_flag         LIKE type_file.chr1    #No.FUN-730064
 
MAIN
      DEFINE    p_row,p_col     LIKE type_file.num5    #No.FUN-690028 SMALLINT #No.FUN-6A0055
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)   #執行功能   #TQC-630070
    
    LET g_sql1= "alh00.alh_file.alh00,alh021.alh_file.alh021,alh45.alh_file.alh45,",
                "alh01.alh_file.alh01,alh02.alh_file.alh02,alh72.alh_file.alh72,",
                "alh10.alh_file.alh10,alh44.alh_file.alh44,alhfirm.alh_file.alhfirm,",
                "nne01.nne_file.nne01,alh52.alh_file.alh52,pmc03_1.pmc_file.pmc03,",
                "pmc03_2.pmc_file.pmc03,alh51.alh_file.alh51,alh75.alh_file.alh75,",
                "alh03.alh_file.alh03,alh06.alh_file.alh06,alh11.alh_file.alh11,",
                "alh50.alh_file.alh50,alh07.alh_file.alh07,alh12.alh_file.alh12,",
                "alh18.alh_file.alh18,alh08.alh_file.alh08,alh13.alh_file.alh13,",
                "alh05.alh_file.alh05,alh09.alh_file.alh09,alh14.alh_file.alh14,",
                "alh04.alh_file.alh04,alh15.alh_file.alh15,alh16.alh_file.alh16,",
                "alh19.alh_file.alh19,alh17.alh_file.alh17,alh76.alh_file.alh76,",
                "alh77.alh_file.alh77,alh74.alh_file.alh74" 
 
    LET l_table = cl_prt_temptable('aapt820',g_sql1) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql1
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
 
    LET p_row = 1 LET p_col = 7
 
    OPEN WINDOW t820_w AT p_row,p_col
         WITH FORM "aap/42f/aapt820"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("alh04",TRUE)
    END IF
    CALL cl_set_comp_visible("alh930,gem02b",g_aaz.aaz90='Y')
 
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t820_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t820_a()
            END IF
          OTHERWISE          #TQC-660072
            CALL t820_q()    #TQC-660072
       END CASE
    END IF
 
    CALL t820()
    CLOSE WINDOW t820_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION t820()
    LET g_plant_new=g_apz.apz04p
    CALL s_getdbs()
    IF g_dbs_nm = ' ' THEN LET g_dbs_nm = NULL END IF
 
    LET g_plant_new=g_apz.apz02p
    CALL s_getdbs()
    IF g_dbs_gl = ' ' THEN LET g_dbs_gl = NULL END IF
 
    INITIALIZE g_alh.* TO NULL
    INITIALIZE g_alh_t.* TO NULL
    INITIALIZE g_alh_o.* TO NULL
    CALL t820_lock_cur()
    IF g_argv1<>' ' THEN CALL t820_q() END IF
 
    WHILE TRUE
      LET g_action_choice=""
      CALL t820_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
END FUNCTION
 
FUNCTION t820_lock_cur()
 
    LET g_forupd_sql = " SELECT * FROM alh_file WHERE alh01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t820_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION t820_cs()
    CLEAR FORM
    IF g_argv1<>' ' THEN
       LET g_wc=" alh01='",g_argv1,"'"
     ELSE
   INITIALIZE g_alh.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
              alh01, alh10, alh021,alh02,alh44,   #TQC-5C0110
              alh45,alh72,alhfirm,
              alh52, alh03, alh50, alh18, alh05, alh04,alh930, #FUN-680019
              alh06, alh07, alh08, alh09, alh51, alh75,
              alh74, alh76, alh77,
              alh11, alh12, alh13, alh14, alh15, alh16, alh17,
              alh30, alh31, alh32, alh35, alh36, alh37, alh38,
              alhuser,alhgrup,alhmodu,alhdate,
              alhoriu,alhorig,                                    #No.TQC-B90255
              alhud01,alhud02,alhud03,alhud04,alhud05,
              alhud06,alhud07,alhud08,alhud09,alhud10,
              alhud11,alhud12,alhud13,alhud14,alhud15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(alh03) # L/C
                CALL q_ala(TRUE,TRUE,g_alh.alh03)
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alh03
             WHEN INFIELD(alh05) #PAY TO VENDOR
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_pmc"
                LET g_qryparam.default1 = g_alh.alh05
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alh05
             WHEN INFIELD(alh06)

                IF g_alh.alh44='2' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_alg"
                    LET g_qryparam.default1 = g_alh.alh06
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_pmc"
                    LET g_qryparam.default1 = g_alh.alh06
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                END IF
                DISPLAY g_qryparam.multiret TO alh06
             WHEN INFIELD(alh10)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_pma"
                LET g_qryparam.default1 = g_alh.alh10
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alh10
             WHEN INFIELD(alh11) # CURRENCY
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_azi"
                LET g_qryparam.default1 = g_alh.alh11
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alh11
             WHEN INFIELD(alh04) # Dept CODE
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gem"
                LET g_qryparam.default1 = g_alh.alh04
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alh04
             WHEN INFIELD(alh30) # Dept CODE
               CALL q_alk(TRUE,FALSE,g_alh.alh03,g_alh.alh30)
                         RETURNING g_alh.alh30
                DISPLAY BY NAME g_alh.alh30
             WHEN INFIELD(alh930)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_gem4"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alh930
                NEXT FIELD alh930
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

       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('alhuser', 'alhgrup')
 
    END IF
    LET g_sql="SELECT alh01 FROM alh_file ",
              " WHERE alh00='1' AND ",g_wc CLIPPED, " ORDER BY alh01"
    PREPARE t820_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE t820_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t820_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM alh_file WHERE alh00='1' AND ",g_wc CLIPPED
    PREPARE t820_precount FROM g_sql
    DECLARE t820_count CURSOR FOR t820_precount
END FUNCTION
 
FUNCTION t820_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_aza.aza63 = 'Y' THEN
               CALL cl_set_act_visible("maintain_entry2",TRUE)
            ELSE
               CALL cl_set_act_visible("maintain_entry2",FALSE)
            END IF
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t820_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t820_q()
            END IF
        ON ACTION next
            CALL t820_fetch('N')
        ON ACTION previous
            CALL t820_fetch('P')
       ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              CALL t820_out()
           END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN CALL t820_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN CALL t820_r()
            END IF
        ON ACTION gen_entry
            CALL t820_g_gl(g_alh.alh01,4,2)
        ON ACTION maintain_entry
            CALL s_fsgl('LC',4,g_alh.alh01,0,g_apz.apz02b,2,g_alh.alhfirm,'0',g_apz.apz02p)      #No.FUN-680029
            CALL t820_npp02('0')   #No.+081 010425 by plum add      #No.FUN-680029
        ON ACTION maintain_entry2
            CALL s_fsgl('LC',4,g_alh.alh01,0,g_apz.apz02c,2,g_alh.alhfirm,'1',g_apz.apz02p)      #No.FUN-680029
            CALL t820_npp02('1')   #No.+081 010425 by plum add      #No.FUN-680029
        ON ACTION acct_title CALL t820_s(2)
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t820_firm1()
               CALL cl_set_field_pic(g_alh.alhfirm,"","","","","")
            END IF
        ON ACTION undo_confirm
             LET g_action_choice="undo_confirm"     #No.MOD-510147
            IF cl_chk_act_auth() THEN
               CALL t820_firm2()
               CALL cl_set_field_pic(g_alh.alhfirm,"","","","","")
            END IF
        ON ACTION carry_voucher
            IF cl_chk_act_auth() THEN
               IF g_alh.alhfirm = 'Y' THEN 
                  CALL t820_carry_voucher()  
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF  
           END IF  
        ON ACTION undo_carry_voucher 
            IF cl_chk_act_auth() THEN
               IF g_alh.alhfirm = 'Y' THEN 
                  CALL t820_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF  
           END IF  
        ON ACTION memo
            LET g_action_choice="memo"
            IF cl_chk_act_auth() THEN
               CALL t820_m()
            END IF
        ON ACTION a_p
            LET g_action_choice="a_p"
            IF cl_chk_act_auth() THEN
               IF g_alh.alh45='Y' THEN
                  LET g_msg = "aapt120 '",g_alh.alh01,"' "
                  CALL cl_cmdrun_wait(g_msg CLIPPED)    #FUN-660216 add
               END IF
            END IF
        ON ACTION dute_pay
            LET g_action_choice="dute_pay"
            IF cl_chk_act_auth() THEN
               CALL t820_w()
            END IF
        ON ACTION undo_dute_pay
             LET g_action_choice="undo_dute_pay"         #No.MOD-510147
            IF cl_chk_act_auth() THEN
               CALL t820_x()
            END IF
        ON ACTION gen_financing
            LET g_action_choice="gen_financing"
            IF cl_chk_act_auth() THEN
               CALL t820_g()
            END IF
        ON ACTION maint_financing
            LET g_action_choice="maint_financing"
            IF cl_chk_act_auth() THEN
               LET g_msg="anmt710 '' '' '",g_alh.alh01,"'" CLIPPED
               CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
            END IF
            SELECT nne01 INTO l_no FROM nne_file WHERE nne28=g_alh.alh01
            IF STATUS THEN LET l_no=' ' END IF
            SELECT alh74,alh75 INTO g_alh.alh74,g_alh.alh75 FROM alh_file
             WHERE alh01=g_alh.alh01
            DISPLAY l_no TO FORMONLY.l_no
            DISPLAY BY NAME g_alh.alh74,g_alh.alh75
        #--FUN-B10030--start--
        #ON ACTION switch_plant
        #   CALL t820_d()
        #--FUN-B10030--end--  
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic(g_alh.alhfirm,"","","","","")
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL t820_fetch('/')
        ON ACTION first
            CALL t820_fetch('F')
        ON ACTION last
            CALL t820_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_alh.alh01 IS NOT NULL THEN
                  LET g_doc.column1 = "alh01"
                  LET g_doc.value1 = g_alh.alh01
                  CALL cl_doc()
               END IF
           END IF
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t820_cs
END FUNCTION
 
 
FUNCTION t820_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_alh.* LIKE alh_file.*
    DISPLAY '' TO FROMONLY.l_no
    LET g_alh_t.* = g_alh.*
    LET g_alh01_t = NULL
    LET g_alh.alh00= '1'
    LET g_alh.alh021= g_today
    LET g_alh.alh02 = g_today
    LET g_alh.alh18 = 1
    LET g_alh.alh50 = 0 LET g_alh.alh09 = 0 LET g_alh.alh51 = '1'   #MOD-590366
    LET g_alh.alh12 = 0 LET g_alh.alh13 = 0 LET g_alh.alh14 = 0
    LET g_alh.alh15 = 0 LET g_alh.alh16 = 0 LET g_alh.alh17 = 0
    LET g_alh.alh52 = 'N'   #TQC-5C0016
    LET g_alh.alh19 = 0
    LET g_alh.alh32 = 0
    LET g_alh.alh35 = 1 LET g_alh.alh36 = 0 LET g_alh.alh37 = 0
    LET g_alh.alh38 = 0
    LET g_alh.alh75 = '0'
    LET g_alh.alh76 = 0
    LET g_alh.alh77 = 0
    LET g_alh.alhfirm = 'N'
    LET g_alh.alh44= '1'    #付款方式 1.dute_pay  2.轉融資    #MOD-590366
    LET g_alh.alh45= 'N'    #dute_pay產生否
    LET g_alh.alh04 = g_grup #FUN-680019
    LET g_alh.alh930= s_costcenter(g_alh.alh04) #FUN-680019
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_alh.alhacti ='Y'                   # 有效的資料
        LET g_alh.alhuser = g_user
        LET g_alh.alhoriu = g_user #FUN-980030
        LET g_alh.alhorig = g_grup #FUN-980030
        LET g_alh.alhgrup = g_grup               # 使用者所屬群
        LET g_alh.alhdate = g_today
        LET g_alh.alhinpd = g_today
        LET g_alh.alhlegal= g_legal #FUN-980001 add
 
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_alk.alk01 = g_argv1
        END IF
 
        INITIALIZE g_alh_o.alh04 TO NULL
        CALL t820_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_alh.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_alh.alh01 IS NULL THEN              # KEY 不可空白
           CONTINUE WHILE
        END IF
        CALL t820_s(1)
        INSERT INTO alh_file VALUES(g_alh.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","alh_file",g_alh.alh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
           CONTINUE WHILE
        ELSE
           LET g_alh_t.* = g_alh.*               # 保存上筆資料
           SELECT alh01 INTO g_alh.alh01 FROM alh_file WHERE alh01 = g_alh.alh01
           CALL cl_flow_notify(g_alh.alh01,'I')
        END IF
        CALL t820_firm1()             # NO:2891
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t820_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
    	g_t1            LIKE oay_file.oayslip,               #單別  #No.FUN-690028 VARCHAR(5)
                                               #No.FUN-550030
    	l_dept          LIKE alh_file.alh04,    #Dept  #FUN-660117
        l_amt,l_amt1,l_amt2  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
        l_ala94         LIKE ala_file.ala94,
        l_n             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_ala59         LIKE ala_file.ala59,
        l_ala60         LIKE ala_file.ala60,
        l_ala21         LIKE ala_file.ala21,             #CHI-9A0004 add
        l_ala23         LIKE ala_file.ala23,
        l_ala25         LIKE ala_file.ala25,
        l_ala61         LIKE ala_file.ala61,
        l_ala34         LIKE ala_file.ala34,
        l_alc34         LIKE alc_file.alc34,
        l_alc24         LIKE alc_file.alc24,
        l_tot           LIKE alh_file.alh13,
        l_tot2          LIKE alh_file.alh13
 
    INPUT BY NAME g_alh.alhoriu,g_alh.alhorig,
          g_alh.alh01, g_alh.alh10, g_alh.alh021, g_alh.alh02,   #TQC-5C0110  
          g_alh.alh44, g_alh.alh45, g_alh.alh72, g_alh.alhfirm,
          g_alh.alh52, g_alh.alh03, g_alh.alh50, g_alh.alh18, g_alh.alh05,
          g_alh.alh04, g_alh.alh930,  #FUN-680019
          g_alh.alh06, g_alh.alh07, g_alh.alh08, g_alh.alh09, g_alh.alh51,
          g_alh.alh75, g_alh.alh74, g_alh.alh76, g_alh.alh77,
          g_alh.alh11, g_alh.alh12, g_alh.alh13, g_alh.alh14, g_alh.alh15,
          g_alh.alh16, g_alh.alh19, g_alh.alh17,     #CHI-9A0004 add alh19
          g_alh.alh30, g_alh.alh31, g_alh.alh32, g_alh.alh35, g_alh.alh36,
          g_alh.alh37, g_alh.alh38,
          g_alh.alhuser,g_alh.alhgrup,g_alh.alhmodu,g_alh.alhdate
          ,g_alh.alhud01,g_alh.alhud02,g_alh.alhud03,g_alh.alhud04,
          g_alh.alhud05,g_alh.alhud06,g_alh.alhud07,g_alh.alhud08,
          g_alh.alhud09,g_alh.alhud10,g_alh.alhud11,g_alh.alhud12,
          g_alh.alhud13,g_alh.alhud14,g_alh.alhud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
        AFTER FIELD alh01
          IF NOT cl_null(g_alh.alh01) THEN
            IF (g_alh.alh01 != g_alh01_t) OR (g_alh01_t IS NULL) THEN
                SELECT count(*) INTO g_cnt FROM alh_file
                    WHERE alh01 = g_alh.alh01
                IF g_cnt > 0 THEN                   # 資料重複
                    CALL cl_err(g_alh.alh01,-239,0)
                    LET g_alh.alh01 = g_alh01_t
                    DISPLAY BY NAME g_alh.alh01
                    NEXT FIELD alh01
                END IF
            END IF
          END IF
 
        AFTER FIELD alh021
            CALL s_get_bookno(YEAR(g_alh.alh021))                                                                                    
                 RETURNING g_flag,g_bookno1,g_bookno2                                                                               
            IF g_flag = "1" THEN    #抓不到帳別                                                                                     
               CALL cl_err(g_alh.alh021,'aoo-081',1)                                                                                 
               NEXT FIELD alh021
            END IF                                                                                                                  
 
        AFTER FIELD alh10
          IF NOT cl_null(g_alh.alh10) THEN
            SELECT COUNT(*) INTO g_cnt FROM pma_file
             WHERE pma01 = g_alh.alh10  AND pma11 IN ('2','3','4','6','7','8')
            IF g_cnt = 0 THEN
               CALL cl_err('sel pma','aap-016',0) NEXT FIELD alh10
            END IF
            SELECT pma11 INTO g_pma11 FROM pma_file WHERE pma01 = g_alh.alh10
          END IF
 
        AFTER FIELD alh44
          IF NOT cl_null(g_alh.alh44) THEN
            IF g_alh.alh44 NOT MATCHES '[12]' THEN NEXT FIELD alh44 END IF
            CALL t820_showalh44()
          END IF
 

        AFTER FIELD alh51
          IF NOT cl_null(g_alh.alh51) THEN
            IF g_alh.alh51 NOT MATCHES "[12]" THEN NEXT FIELD alh51
            END IF
          END IF

        AFTER FIELD alh50                                                       
          IF NOT cl_null(g_alh.alh50) THEN                                      
             IF g_alh.alh50 < 0 OR g_alh.alh50 > 100 THEN                       
                CALL cl_err(g_alh.alh50,'mfg0091',0)                            
                NEXT FIELD alh50                                                
             END IF                                                             
          END IF                                                                
 
        AFTER FIELD alh03
            IF g_pma11 MATCHES "[38]" AND g_alh.alh52 IS NULL AND
               g_alh.alh03 IS NULL THEN
               NEXT FIELD alh03
            END IF
            INITIALIZE g_ala.* TO NULL

           IF g_alh.alh03 IS NOT NULL AND  #MOD-5A0393
              (g_alh.alh52 IS NULL OR g_alh.alh52 = 'N') AND                              #MOD-5A0393
              (p_cmd = 'a' OR (p_cmd = 'u' AND g_alh_t.alh03 != g_alh.alh03)) THEN        #MOD-C80026 add
               SELECT * INTO g_ala.* FROM ala_file WHERE ala01=g_alh.alh03
               IF STATUS THEN
                  CALL cl_err3("sel","ala_file",g_alh.alh03,"",STATUS,"","sel ala: ",1)  #No.FUN-660122
                  NEXT FIELD alh03
               END IF
               IF g_ala.alafirm = 'X' THEN
                  CALL cl_err("alafirm='X'",'9024',0) NEXT FIELD alh03
               END IF
               LET g_alh.alh04 = g_ala.ala04
               CALL t820_alh04('a')                         #MOD-C80026 add
               LET g_alh.alh05 = g_ala.ala05
               CALL t820_alh05('d')
               LET g_alh.alh50 = g_ala.ala21
               LET g_alh.alh18 = g_ala.ala79
               LET g_alh.alh06 = g_ala.ala07
               CALL t820_alh06('d')
               LET g_alh.alh07 = g_ala.ala22
               LET g_alh.alh11 = g_ala.ala20
              #-------------------------MOD-C80026------------------------------(S)
               LET g_alh.alh08 = g_alh.alh02 + g_alh.alh07
               LET g_alh.alh13 = g_alh.alh12 * (g_alh.alh50 / 100)
               LET g_alh.alh14 = g_alh.alh12 - g_alh.alh13
               LET g_alh.alh15 = s_curr3(g_alh.alh11,g_alh.alh02,g_apz.apz33)
              #DISPLAY BY NAME g_alh.alh50,g_alh.alh18,g_alh.alh05,                          #MOD-C80026 mark
              #                g_alh.alh04,g_alh.alh06,g_alh.alh07,g_alh.alh11               #MOD-C80026 mark
               DISPLAY BY NAME g_alh.alh50,g_alh.alh18,g_alh.alh05,g_alh.alh04,g_alh.alh06,
                               g_alh.alh07,g_alh.alh11,g_alh.alh08,g_alh.alh13,g_alh.alh14,
                               g_alh.alh15
              #-------------------------MOD-C80026------------------------------(E)
            END IF
        ON CHANGE alh03
            SELECT ala07,ala20,ala23
              INTO g_alh.alh06,g_alh.alh11,g_alh.alh12
               FROM ala_file WHERE ala01 = g_alh.alh03
            CALL s_curr3(g_alh.alh11,g_today,g_apz.apz33) RETURNING g_alh.alh18 #FUN-640022
            DISPLAY BY NAME g_alh.alh06,g_alh.alh11,g_alh.alh12,g_alh.alh18
 

 
        AFTER FIELD alh05
          IF NOT cl_null(g_alh.alh05) THEN
            CALL t820_alh05('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alh.alh05,g_errno,0)
               NEXT FIELD alh05
            END IF
          END IF
 
        AFTER FIELD alh04
          IF NOT cl_null(g_alh.alh04) THEN
            IF g_alh_o.alh04 IS NULL OR g_alh.alh04 != g_alh_o.alh04 THEN
               CALL t820_alh04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_alh.alh04,g_errno,0)
                  IF p_cmd = 'u' THEN
                  LET g_alh_o.alh04 = g_alh.alh04
                  END IF
                  DISPLAY BY NAME g_alh.alh04
                  NEXT FIELD alh04
               END IF
               DISPLAY s_costcenter_desc(g_alh.alh04) TO FORMONLY.gem02 #FUN-680019
               LET g_alh.alh930=s_costcenter(g_alh.alh04) #FUN-680019
               DISPLAY s_costcenter_desc(g_alh.alh930) TO FORMONLY.gem02b #FUN-680019
            END IF
            LET g_alh_o.alh04 = g_alh.alh04            
          ELSE
             DISPLAY NULL TO FORMONLY.gem02 #FUN-680019
          END IF
 
        AFTER FIELD alh06
          IF NOT cl_null(g_alh.alh06) THEN
            CALL t820_alh06('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alh.alh06,g_errno,0)
               LET g_alh.alh06 = g_alh_t.alh06
               DISPLAY BY NAME g_alh.alh06
               NEXT FIELD alh06
            END IF
          END IF
 
        AFTER FIELD alh07
           #IF g_alh.alh08 IS NULL THEN                                        #MOD-C80026 mark
            IF g_alh.alh08 IS NULL  OR                                         #MOD-C80026 add 
              (g_alh_o.alh07 IS NULL OR g_alh_o.alh07 != g_alh.alh07) THEN     #MOD-C80026 add 
               LET g_alh.alh08 = g_alh.alh02 + g_alh.alh07                     #MOD-7B0044 unmark
               DISPLAY BY NAME g_alh.alh08
            END IF
 
        AFTER FIELD alh08
          IF cl_null(g_alh.alh08) THEN
            IF g_alh.alh08 < g_alh.alh02 THEN NEXT FIELD alh08 END IF   #MOD-7B0044
          END IF
 
        AFTER FIELD alh11
          IF cl_null(g_alh.alh11) THEN
            SELECT azi02 INTO g_buf FROM azi_file WHERE azi01=g_alh.alh11
            IF STATUS THEN 
              CALL cl_err3("sel","azi_file",g_alh.alh11,"",STATUS,"","sel azi:",1)  #No.FUN-660122
              NEXT FIELD alh11
              END IF
          END IF
          SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file WHERE azi01=g_alh.alh11   #MOD-680085
         CALL s_curr3(g_alh.alh11,g_alh.alh02,g_apz.apz33) RETURNING g_alh.alh15 #FUN-640022
         LET g_alh.alh15 = cl_digcut(g_alh.alh15,t_azi07)   #MOD-680085
         DISPLAY BY NAME g_alh.alh15
 
 
        AFTER FIELD alh12
          IF NOT cl_null(g_alh.alh12) THEN
             LET g_alh.alh12 = cl_digcut(g_alh.alh12,t_azi04)   #MOD-680085
             LET g_alh.alh13 = g_alh.alh12 * (g_alh.alh50 / 100)
             LET g_alh.alh13 = cl_digcut(g_alh.alh13,t_azi04)   #MOD-680085
             LET g_alh.alh14 = g_alh.alh12 - g_alh.alh13
             LET g_alh.alh14 = cl_digcut(g_alh.alh14,t_azi04)   #MOD-680085
             DISPLAY BY NAME g_alh.alh12,g_alh.alh13,g_alh.alh14   #MOD-680085
          END IF
        AFTER FIELD alh13
          IF NOT cl_null(g_alh.alh13) THEN
             LET g_alh.alh13 = cl_digcut(g_alh.alh13,t_azi04)
             DISPLAY BY NAME g_alh.alh13
          END IF
 
       BEFORE FIELD alh14
            LET g_alh.alh14 = g_alh.alh12 - g_alh.alh13
            DISPLAY BY NAME g_alh.alh13,g_alh.alh14
 
        AFTER FIELD alh14
          IF NOT cl_null(g_alh.alh14) THEN
             LET g_alh.alh14 = cl_digcut(g_alh.alh14,t_azi04)
             DISPLAY BY NAME g_alh.alh14
          END IF
 
        AFTER FIELD alh15
          IF NOT cl_null(g_alh.alh15) THEN
            IF g_alh.alh15=0 THEN NEXT FIELD alh15 END IF
            LET g_alh.alh15 = cl_digcut(g_alh.alh15,t_azi07)   #MOD-680085
            LET g_alh.alh16 = g_alh.alh14 * g_alh.alh15
            LET g_alh.alh16 = cl_digcut(g_alh.alh16,g_azi04)
            DISPLAY BY NAME g_alh.alh16
            SELECT ala23+ala24,ala59+ala60,ala94 INTO l_amt1,l_amt2,l_ala94
                  FROM ala_file WHERE ala01=g_alh.alh03
            IF STATUS THEN LET l_amt1=0 LET l_amt2=0 END IF

            SELECT ala34,ala59,ala60,ala23,ala25,ala61,ala21 
              INTO l_ala34,l_ala59,l_ala60,l_ala23,l_ala25,l_ala61,l_ala21
              FROM ala_file
             WHERE ala01 = g_alh.alh03
            SELECT alc34,alc24 INTO l_alc34,l_alc24 FROM alc_file
             WHERE alc01 = g_alh.alh03
               AND alcfirm <> 'X'  #CHI-C80041
            SELECT SUM(alh13) INTO l_tot FROM alh_file
             WHERE alh03 = g_alh.alh03
               AND alh01 <> g_alh.alh01
             IF cl_null(l_tot) THEN LET l_tot = 0 END IF
             IF cl_null(l_alc34) THEN LET l_alc34 = 0 END IF
             IF cl_null(l_alc24) THEn LEt l_alc24 = 0 END IF
             IF cl_null(l_ala25) THEN LET l_ala25 = 0 END IF
             IF cl_null(l_ala60) THEN LET l_ala60 = 0 END IF
             IF cl_null(l_ala61) THEN LET l_ala61 = 0 END IF
             SELECT SUM(alh19) INTO l_tot2 FROM alh_file
              WHERE alh03 = g_alh.alh03
                AND alh01 <> g_alh.alh01
             IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
            IF (l_tot+g_alh.alh13)/(l_ala23*l_ala21/100) = 1 THEN         #CHI-9A0004 add
               LET g_alh.alh19 = l_ala59+l_ala60-l_tot2
            ELSE IF (l_tot+g_alh.alh13)/(l_ala34+l_alc34)>1 THEN
                     CALL cl_err('','aap-243',0)
                 ELSE
                    LET g_alh.alh19 = (l_ala59+l_ala60-l_ala61)
                                 *(g_alh.alh12/(l_ala23+l_alc24-l_ala25))
                 END IF
            END IF
            #no.A010依幣別取位
            LET g_alh.alh19 = cl_digcut(g_alh.alh19,g_azi04)
            DISPLAY BY NAME g_alh.alh19
 
            IF g_alh.alh11 =g_aza.aza17 THEN
               LET g_alh.alh15 =1
               DISPLAY g_alh.alh15  TO alh15
           ELSE
              LET g_alh.alh15 = cl_digcut(g_alh.alh15,t_azi07)   #MOD-680085
              DISPLAY g_alh.alh15 TO alh15
            END IF
          END IF
 
 
        AFTER FIELD alh30

            INITIALIZE g_alk.* TO NULL
            IF g_alh.alh30 IS NOT NULL THEN
               SELECT * INTO g_alk.* FROM alk_file WHERE alk01=g_alh.alh30 AND alkfirm ='Y' #MOD-8B0298
               IF STATUS AND STATUS != 100 THEN
                  CALL cl_err3("sel","alk_file",g_alh.alh30,"",STATUS,"","sel alk:",1)  #No.FUN-660122
                  NEXT FIELD alh30
               END IF
               IF SQLCA.SQLCODE=100 THEN
                  IF NOT cl_confirm('aap-724') THEN NEXT FIELD alh30 END IF
               END IF
               DISPLAY BY NAME g_alk.alk13
            END IF
            LET g_alh.alh31=g_alk.alk02
            DISPLAY BY NAME g_alh.alh31
        AFTER FIELD alh31
            IF g_alh.alh30 IS NULL OR
               g_alh.alh31 IS NULL #OR g_alh.alh31>g_alh.alh02
               THEN LET g_alh.alh32=0
                    LET g_alh.alh35=1
                    LET g_alh.alh36=0
                    LET g_alh.alh37=0
                    LET g_alh.alh38=0
               ELSE LET g_alh.alh32=g_alk.alk13*(100-g_alh.alh50)/100
                    LET g_alh.alh19=g_alk.alk26
                    LET g_alh.alh41=g_alk.alk41
                    IF g_aza.aza63 = 'Y' THEN
                       LET g_alh.alh411=g_alk.alk411
                    END IF
            END IF
            #no.A010依幣別取位
            LET g_alh.alh32=cl_digcut(g_alh.alh32,t_azi04)   #MOD-680085
            DISPLAY BY NAME g_alh.alh32,g_alh.alh35,g_alh.alh36,
                            g_alh.alh37,g_alh.alh38
        AFTER FIELD alh32
            IF g_alh.alh32 IS NOT NULL AND g_alh.alh32 != 0 THEN
               LET g_alh.alh32 = cl_digcut(g_alh.alh32,t_azi04)   #MOD-680085
               LET g_alh.alh35=g_alk.alk12
               LET g_alh.alh36=g_alk.alk16
               LET g_alh.alh36 = cl_digcut(g_alh.alh36,g_azi04)   #MOD-680085
               LET g_alh.alh37=(g_alh.alh14 - g_alh.alh32) * g_alh.alh15
               LET g_alh.alh37 = cl_digcut(g_alh.alh37,g_azi04)   #MOD-680085
               LET g_alh.alh38=g_alh.alh16-g_alh.alh36-g_alh.alh37
               #no.A010依幣別取位
               LET g_alh.alh38 = cl_digcut(g_alh.alh38,g_azi04)
               DISPLAY BY NAME g_alh.alh32,g_alh.alh35, g_alh.alh36,   #MOD-680085
                               g_alh.alh37, g_alh.alh38
            END IF
 
        AFTER FIELD alh35         #85-10-22
            IF cl_null(g_alh.alh35) OR g_alh.alh35=0 THEN
               LET g_alh.alh35=1
            END IF
 
        AFTER FIELD alh16
            IF NOT cl_null(g_alh.alh16) THEN
               LET g_alh.alh16=cl_digcut(g_alh.alh16,g_azi04)
               DISPLAY BY NAME g_alh.alh16
            END IF
 
        AFTER FIELD alh19
          IF NOT cl_null(g_alh.alh19) THEN
             IF g_alh.alh19 > (l_ala59 + l_ala60) THEN
                CALL cl_err(g_alh.alh19,'aap-208',0)
                NEXT FIELD alh19
             END IF
          END IF
 
        AFTER FIELD alh17
            IF NOT cl_null(g_alh.alh17) THEN
               LET g_alh.alh17=cl_digcut(g_alh.alh17,g_azi04)
               DISPLAY BY NAME g_alh.alh17
            END IF
        AFTER FIELD alh36
            IF NOT cl_null(g_alh.alh36) THEN
               LET g_alh.alh36=cl_digcut(g_alh.alh36,g_azi04)
               DISPLAY BY NAME g_alh.alh36
            END IF
        AFTER FIELD alh37
            IF NOT cl_null(g_alh.alh37) THEN
               LET g_alh.alh37=cl_digcut(g_alh.alh37,g_azi04)
               DISPLAY BY NAME g_alh.alh37
            END IF
        AFTER FIELD alh38
            IF NOT cl_null(g_alh.alh38) THEN
               LET g_alh.alh38=cl_digcut(g_alh.alh38,g_azi04)
               DISPLAY BY NAME g_alh.alh38
            END IF
 
 
        AFTER FIELD alh930 
           IF NOT s_costcenter_chk(g_alh.alh930) THEN
              NEXT FIELD alh930
           ELSE
              DISPLAY s_costcenter_desc(g_alh.alh930) TO g_alh.gem02b
           END IF
 
        AFTER FIELD alhud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alhud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_alh.alhuser = s_get_data_owner("alh_file") #FUN-C10039
           LET g_alh.alhgrup = s_get_data_group("alh_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT END IF
            IF NOT cl_null(g_alh.alh10) AND g_pma11 MATCHES "[38]" AND
               g_alh.alh03 IS NULL THEN
               LET l_flag='Y' DISPLAY BY NAME g_alh.alh03
            END IF

            IF l_flag='Y' THEN NEXT FIELD alh03 END IF   #MOD-B50111 mod alh01 -> alh03
            CALL t820_alh06('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alh.alh06,g_errno,0)
               NEXT FIELD alh06
            END IF
            #MOD-690114 add--------
        ON KEY(F1) NEXT FIELD alh52
        ON KEY(F2) NEXT FIELD alh11
 
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(alh03) # L/C
                 CALL q_ala(FALSE,TRUE,g_alh.alh03) RETURNING g_alh.alh03
                 DISPLAY BY NAME g_alh.alh03
              WHEN INFIELD(alh05) #PAY TO VENDOR
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc"
                 LET g_qryparam.default1 = g_alh.alh05
                 CALL cl_create_qry() RETURNING g_alh.alh05
                 DISPLAY BY NAME g_alh.alh05
              WHEN INFIELD(alh06)
 
                 IF g_alh.alh44='2' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_alg"
                     LET g_qryparam.default1 = g_alh.alh06
                     CALL cl_create_qry() RETURNING g_alh.alh06
                 ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_pmc"
                     LET g_qryparam.default1 = g_alh.alh06
                     CALL cl_create_qry() RETURNING g_alh.alh06
                 END IF
                 DISPLAY BY NAME g_alh.alh06
              WHEN INFIELD(alh10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pma"
                 LET g_qryparam.default1 = g_alh.alh10
                 LET g_qryparam.where=" pma11 MATCHES '[234678]' " #TQC-690081 add
                 CALL cl_create_qry() RETURNING g_alh.alh10
                 DISPLAY BY NAME g_alh.alh10
              WHEN INFIELD(alh11) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_alh.alh11
                 CALL cl_create_qry() RETURNING g_alh.alh11
                 DISPLAY BY NAME g_alh.alh11
              WHEN INFIELD(alh04) # Dept CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_alh.alh04
                 CALL cl_create_qry() RETURNING g_alh.alh04
                 DISPLAY BY NAME g_alh.alh04
              WHEN INFIELD(alh30) # Dept CODE
               CALL q_alk(FALSE,FALSE,g_alh.alh03,g_alh.alh30)
                         RETURNING g_alh.alh30
                 DISPLAY BY NAME g_alh.alh30
              WHEN INFIELD(alh18)
                 CALL s_rate(g_ala.ala20,g_alh.alh18)
                 RETURNING g_alh.alh18
                 DISPLAY BY NAME g_alh.alh18
                 NEXT FIELD alh18
              WHEN INFIELD(alh15)
                 CALL s_rate(g_alh.alh11,g_alh.alh15)
                 RETURNING g_alh.alh15
                 DISPLAY BY NAME g_alh.alh15
                 NEXT FIELD alh15
              WHEN INFIELD(alh35)
                 CALL s_rate(g_alh.alh11,g_alh.alh35)
                 RETURNING g_alh.alh35
                 DISPLAY BY NAME g_alh.alh35
                 NEXT FIELD alh35
              WHEN INFIELD(alh930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_alh.alh930
                 DISPLAY BY NAME g_alh.alh930
                 NEXT FIELD alh930
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
 
FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("alh01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("alh01",FALSE)
   END IF
 
END FUNCTION

 
FUNCTION t820_alh51()
DEFINE l_msg    LIKE ze_file.ze03   # No.FUN-690028 VARCHAR(30)
 
    CASE WHEN g_alh.alh51='0' DISPLAY '        ' TO alh51_desc
         WHEN g_alh.alh51='1'
              CALL cl_getmsg('aap-725',g_lang) RETURNING l_msg
              DISPLAY l_msg TO alh51_desc
         WHEN g_alh.alh51='2'
              CALL cl_getmsg('aap-726',g_lang) RETURNING l_msg
              DISPLAY l_msg TO alh51_desc
         OTHERWISE            DISPLAY '        ' TO alh51_desc
    END CASE
END FUNCTION
 
FUNCTION t820_alh04(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_gemacti LIKE gem_file.gemacti
    DEFINE l_dept    LIKE alh_file.alh04   #FUN-660117
    DEFINE l_aps     RECORD LIKE aps_file.*
 
    SELECT gemacti INTO l_gemacti
           FROM gem_file WHERE gem01 = g_alh.alh04
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    IF p_cmd != 'a' THEN RETURN END IF
    IF g_apz.apz13 = 'Y'
       THEN LET l_dept = g_alh.alh04
       ELSE LET l_dept = ' '
    END IF
    SELECT * INTO l_aps.*
           FROM aps_file WHERE aps01 = l_dept     # 部門預設會計科目檔
    IF STATUS THEN                                                                                                                  
       CALL cl_err_msg('','aap-830',l_dept,1)                                                                          
       RETURN                                                                                                                       
    END IF                                                                                                                          
    IF cl_null(g_alh.alh41) THEN LET g_alh.alh41 = l_aps.aps234 END IF
    IF cl_null(g_alh.alh43) THEN LET g_alh.alh43 = l_aps.aps51 END IF
    IF g_alh.alh44='1' THEN
       IF cl_null(g_alh.alh42) THEN LET g_alh.alh42=l_aps.aps22 END IF
       IF g_aza.aza63 = 'Y' THEN
          IF cl_null(g_alh.alh421) THEN LET g_alh.alh421=l_aps.aps221 END IF
       END IF
    ELSE
       IF cl_null(g_alh.alh42) THEN LET g_alh.alh42=l_aps.aps25 END IF
       IF g_aza.aza63 = 'Y' THEN
          IF cl_null(g_alh.alh421) THEN LET g_alh.alh421=l_aps.aps251 END IF
       END IF
    END IF
    IF g_aza.aza63 = 'Y' THEN
       IF cl_null(g_alh.alh411) THEN LET g_alh.alh411 = l_aps.aps239 END IF
       IF cl_null(g_alh.alh431) THEN LET g_alh.alh431 = l_aps.aps511 END IF
    END IF
END FUNCTION
 
FUNCTION t820_alh05(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_pmc03 LIKE pmc_file.pmc03
 
    SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = g_alh.alh05
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    DISPLAY l_pmc03 TO pmc03
END FUNCTION
 
FUNCTION t820_alh06(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_pmc03 LIKE pmc_file.pmc03
    DEFINE l_alg02 LIKE alg_file.alg02
 
    IF g_alh.alh44 = '2' THEN   #付款方式為2.轉融資
        SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01 = g_alh.alh06
        LET g_errno = ' '
        CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-722'
             WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE
                                                    USING '-----'
        END CASE
        DISPLAY l_alg02 TO pmc03b
    ELSE
        SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = g_alh.alh06
        LET g_errno = ' '
        CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
             WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
        END CASE
        DISPLAY l_pmc03 TO pmc03b
    END IF
END FUNCTION
 
FUNCTION t820_alh11(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_aziacti LIKE azi_file.aziacti
 
    SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = g_alh.alh11
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
         WHEN l_aziacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF g_alh.alh12 = 1 AND g_alh.alh11 != g_aza.aza17 THEN
       CALL s_curr3(g_alh.alh11,g_alh.alh02,g_apz.apz33) RETURNING g_alh.alh12 #FUN-640022
       DISPLAY BY NAME g_alh.alh12
    END IF
END FUNCTION
 
FUNCTION t820_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t820_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t820_count
    FETCH t820_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t820_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_alh.alh01,SQLCA.sqlcode,0)
        INITIALIZE g_alh.* TO NULL
    ELSE
        CALL t820_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t820_fetch(p_flalh)
    DEFINE
        p_flalh          LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flalh
        WHEN 'N' FETCH NEXT     t820_cs INTO g_alh.alh01
        WHEN 'P' FETCH PREVIOUS t820_cs INTO g_alh.alh01
        WHEN 'F' FETCH FIRST    t820_cs INTO g_alh.alh01
        WHEN 'L' FETCH LAST     t820_cs INTO g_alh.alh01
        WHEN '/'
            IF NOT mi_no_ask THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump t820_cs INTO g_alh.alh01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_alh.alh01,SQLCA.sqlcode,0)
        INITIALIZE g_alh.* TO NULL              #No.FUN-6A0016 
        RETURN
    ELSE
       CASE p_flalh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_alh.* FROM alh_file       # 重讀DB,因TEMP有不被更新特性
       WHERE alh01 = g_alh.alh01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","alh_file",g_alh.alh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
       INITIALIZE g_alh.* TO NULL              #No.FUN-6A0016 
    ELSE
       LET g_data_owner = g_alh.alhuser     #No.FUN-4C0047
       LET g_data_group = g_alh.alhgrup     #No.FUN-4C0047
            CALL s_get_bookno(YEAR(g_alh.alh021))                                                                                    
                 RETURNING g_flag,g_bookno1,g_bookno2                                                                               
            IF g_flag = "1" THEN    #抓不到帳別                                                                                     
               CALL cl_err(g_alh.alh021,'aoo-081',1)                                                                                 
            END IF                                                                                                                  
       CALL t820_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t820_show()
    LET g_alh_t.* = g_alh.*
    DISPLAY BY NAME g_alh.alhoriu,g_alh.alhorig,
              g_alh.alh01, g_alh.alh10, g_alh.alh021,g_alh.alh02,   #TQC-5C0110 
              g_alh.alh44, g_alh.alh45, g_alh.alh72, g_alh.alhfirm,
              g_alh.alh52, g_alh.alh03, g_alh.alh50, g_alh.alh18,
              g_alh.alh05, g_alh.alh04, g_alh.alh930,g_alh.alh06, g_alh.alh07, g_alh.alh08,  #FUN-680019
              g_alh.alh09, g_alh.alh51,
              g_alh.alh11, g_alh.alh12, g_alh.alh13, g_alh.alh14,
              g_alh.alh15, g_alh.alh16, g_alh.alh19, g_alh.alh17,
              g_alh.alh30, g_alh.alh31, g_alh.alh32,
              g_alh.alh35, g_alh.alh36, g_alh.alh37,
              g_alh.alh38, g_alh.alh72, g_alh.alhfirm,
              g_alh.alh75, g_alh.alh74, g_alh.alh76, g_alh.alh77,
              g_alh.alhuser,g_alh.alhgrup,g_alh.alhmodu,g_alh.alhdate
              ,g_alh.alhud01,g_alh.alhud02,g_alh.alhud03,g_alh.alhud04,
              g_alh.alhud05,g_alh.alhud06,g_alh.alhud07,g_alh.alhud08,
              g_alh.alhud09,g_alh.alhud10,g_alh.alhud11,g_alh.alhud12,
              g_alh.alhud13,g_alh.alhud14,g_alh.alhud15 
    LET g_msg=''
    SELECT pma11 INTO g_pma11 FROM pma_file WHERE pma01 = g_alh.alh10
    LET l_no=' '
    CALL t820_showno()
    DISPLAY l_no TO FORMONLY.l_no
    CALL t820_showalh44()
    CALL t820_alh05('d')
    CALL t820_alh06('d')
    LET g_alk.alk13=0
    SELECT * INTO g_alk.* FROM alk_file WHERE alk01=g_alh.alh30
    DISPLAY BY NAME g_alk.alk13
    DISPLAY s_costcenter_desc(g_alh.alh04) TO FORMONLY.gem02   #FUN-680019
    DISPLAY s_costcenter_desc(g_alh.alh930) TO FORMONLY.gem02b #FUN-680019
    CALL cl_set_field_pic(g_alh.alhfirm,"","","","","")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t820_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_alh.alh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_alh.* FROM alh_file WHERE alh01=g_alh.alh01
    IF g_alh.alhfirm='Y' THEN CALL cl_err('firm=Y','axm-101',0) RETURN END IF
    IF g_alh.alhacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_alh.alh01,'9027',0)
        RETURN
    END IF
    IF g_alh.alh45 ='Y' THEN    #檢查資料是否己到期付款產生
       CALL cl_err('alh45=Y','aap-309',0)
       RETURN
    END IF
    MESSAGE ""
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN t820_cl USING g_alh.alh01
    IF STATUS THEN
       CALL cl_err("OPEN t820_cl:", STATUS, 1)
       CLOSE t820_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t820_cl INTO g_alh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_alh.alh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_alh01_t = g_alh.alh01
   #LET g_alh_o.* = g_alh.*                      #MOD-C80026 mark
    LET g_alh_t.* = g_alh.*                      #MOD-C80026 add
    LET g_alh.alhmodu=g_user                     #修改者
    LET g_alh.alhdate = g_today                  #修改日期
    CALL t820_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t820_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_alh.*=g_alh_t.*
            CALL t820_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE alh_file SET alh_file.* = g_alh.*    # 更新DB
            WHERE alh01 = g_alh01_t           # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","alh_file",g_alh_t.alh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        END IF
        IF g_alh_t.alh021 != g_alh.alh021 THEN
           UPDATE npp_file SET npp02=g_alh.alh021
            WHERE npp01=g_alh.alh01 AND npp011=2
              AND npp00 = 4         AND nppsys = 'LC'
          IF STATUS THEN 
             CALL cl_err3("upd","npp_file",g_alh_t.alh01,"",STATUS,"","upd npp02:",1)  #No.FUN-660122
          END IF
        END IF
       IF g_alh_t.alh12 != g_alh.alh12 OR 
          g_alh_t.alh13 != g_alh.alh13 OR 
          g_alh_t.alh14 != g_alh.alh14 OR 
          g_alh_t.alh16 != g_alh.alh16 OR 
          g_alh_t.alh32 != g_alh.alh32 OR 
          g_alh_t.alh36 != g_alh.alh36 OR 
          g_alh_t.alh37 != g_alh.alh37 OR 
          g_alh_t.alh38 != g_alh.alh38 THEN
          IF cl_confirm('aap-057') THEN
             CALL t820_g_gl(g_alh.alh01,4,2)
          END IF 
       END IF 
        EXIT WHILE
    END WHILE
    CLOSE t820_cl
    COMMIT WORK
    CALL cl_flow_notify(g_alh.alh01,'U')
END FUNCTION
 
FUNCTION t820_npp02(p_npptype)      #No.FUN-680029
  DEFINE p_npptype    LIKE npp_file.npptype      #No.FUN-680029
 
  IF cl_null(g_alh.alh72) THEN
     UPDATE npp_file SET npp02=g_alh.alh021
      WHERE npp01=g_alh.alh01 AND npp011=2
        AND npp00 = 4         AND nppsys = 'LC'
        AND npptype = p_npptype      #No.FUN-680029
     IF STATUS THEN 
        CALL cl_err3("upd","npp_file",g_alh.alh01,"",STATUS,"","upd npp02:",1)  #No.FUN-660122
     END IF
  END IF
END FUNCTION
 
FUNCTION t820_r()
    DEFINE l_chr   LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_cnt   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_alh.alh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_alh.* FROM alh_file WHERE alh01=g_alh.alh01
    IF g_alh.alhfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_alh.alh45  ='Y' THEN CALL cl_err('alh45=Y','aap-309',0) RETURN END IF
    BEGIN WORK
 
    OPEN t820_cl USING g_alh.alh01
    IF STATUS THEN
       CALL cl_err("OPEN t820_cl:", STATUS, 1)
       CLOSE t820_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t820_cl INTO g_alh.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_alh.alh01,SQLCA.sqlcode,0) RETURN END IF
    CALL t820_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "alh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_alh.alh01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM alh_file WHERE alh01 = g_alh.alh01
        IF STATUS THEN
        CALL cl_err3("del","alh_file",g_alh.alh01,"",STATUS,"","del alh:",1)  #No.FUN-660122
        RETURN END IF       
         
        DELETE FROM npp_file WHERE npp01 = g_ala.ala01 AND nppsys = 'LC'                              
                             AND npp00 = 4 AND npp011 = 2  #no.7601       
        IF STATUS THEN 
        CALL cl_err3("del","npp_file",g_ala.ala01,"",STATUS,"","del npp:",1)  #No.FUN-660122
        RETURN END IF        
        
        DELETE FROM npq_file WHERE npq01 = g_ala.ala01
                             AND npqsys = 'LC' AND npq00 = 4 AND npq011 = 2  #no.7601
        IF STATUS THEN 
        CALL cl_err3("del","npq_file",g_ala.ala01,"",STATUS,"","del npq:",1)  #No.FUN-660122
        RETURN END IF
        #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_ala.ala01
        IF STATUS THEN
           CALL cl_err3("del","tic_file",g_ala.ala01,"",STATUS,"","del tic:",1)
           RETURN
        END IF
        #FUN-B40056--add--end--
	INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add plant,legal
	  VALUES ('saapt820',g_user,g_today,g_msg,g_alh.alh01,'delete',g_plant,g_legal) #FUN-980001 add plant,legal
        CLEAR FORM
        INITIALIZE g_alh.* TO NULL
        OPEN t820_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t820_cs
           CLOSE t820_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH t820_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t820_cs
           CLOSE t820_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t820_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t820_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t820_fetch('/')
        END IF
    END IF
    CLOSE t820_cl
    COMMIT WORK
    CALL cl_flow_notify(g_alh.alh01,'D')
END FUNCTION
 
FUNCTION t820_m()
   DEFINE i,j		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE g_apd     DYNAMIC ARRAY OF RECORD
                    apd02		LIKE apd_file.apd02,
                    apd03		LIKE apd_file.apd03
                    END RECORD,
          g_apd_t   RECORD
                    apd02		LIKE apd_file.apd02,
                    apd03		LIKE apd_file.apd03
                    END RECORD,
    l_ac_t,l_jump   LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690028 SMALLINT
 
   IF g_alh.alh01 IS NULL THEN RETURN END IF
 
 
   OPEN WINDOW t820_m_w AT 8,30 WITH FORM "aap/42f/aapt710_3"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt710_3")
 
 
   DECLARE t820_m_c CURSOR FOR
           SELECT apd02,apd03,' ' FROM apd_file
             WHERE apd01 = g_alh.alh01
             ORDER BY apd02
   LET i = 1
   FOREACH t820_m_c INTO g_apd[i].*
      IF STATUS THEN CALL cl_err('foreach',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
      IF i > 30 THEN EXIT FOREACH END IF
   END FOREACH
   CALL g_apd.deleteElement(i)
   LET i = i - 1
   INPUT ARRAY g_apd WITHOUT DEFAULTS FROM s_apd.*
      ATTRIBUTE(COUNT= i ,MAXCOUNT=g_max_rec,UNBUFFERED)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_n  = ARR_COUNT()
        NEXT FIELD apd02
      AFTER ROW
        IF INT_FLAG THEN EXIT INPUT END IF
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
       LET INT_FLAG = 0 CLOSE WINDOW t820_m_w
       RETURN
   END IF
   CLOSE WINDOW t820_m_w
   LET j = ARR_COUNT()
   BEGIN WORK
   LET g_success = 'Y'
   WHILE TRUE
      DELETE FROM apd_file
             WHERE apd01 = g_alh.alh01
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err3("del","apd_file",g_alh.alh01,"",SQLCA.sqlcode,"","t820_m(ckp#1):",1)  #No.FUN-660122
         EXIT WHILE
      END IF
      FOR i = 1 TO g_apd.getLength()
         IF g_apd[i].apd03 IS NULL THEN CONTINUE FOR END IF
         INSERT INTO apd_file (apd01,apd02,apd03,apdlegal) #FUN-980001 add legal  #FUN-980076 mod
                VALUES(g_alh.alh01,g_apd[i].apd02,g_apd[i].apd03,g_legal) #FUN-980001 add legal #FUN-980076 mod
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("ins","apd_file",g_alh.alh01,"",SQLCA.sqlcode,"","t820_m(ckp#2):",1)  #No.FUN-660122
            EXIT WHILE
         END IF
      END FOR
      EXIT WHILE
   END WHILE
      IF g_success = 'Y'
         THEN COMMIT WORK
         ELSE ROLLBACK WORK
      END IF
END FUNCTION
 
FUNCTION t820_firm1()
   DEFINE l_apa34      LIKE apa_file.apa34  #MOD-CC0092 add
   DEFINE l_apa34f     LIKE apa_file.apa34f #MOD-CC0092 add
   DEFINE l_apc08      LIKE apc_file.apc08  #MOD-CC0092 add
   DEFINE l_apc09      LIKE apc_file.apc09  #MOD-CC0092 add
 
   IF cl_null(g_alh.alh01) THEN RETURN END IF
    SELECT * INTO g_alh.* FROM alh_file WHERE alh01=g_alh.alh01
   IF g_alh.alhfirm='Y' THEN RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   #FUN-B50090 add -end--------------------------
   IF g_alh.alh021<=g_apz.apz57 THEN
      CALL cl_err(g_alh.alh01,'aap-176',1) RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t820_cl USING g_alh.alh01
   IF STATUS THEN
      CALL cl_err("OPEN t820_cl:", STATUS, 1)
      CLOSE t820_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t820_cl INTO g_alh.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alh.alh01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   CALL s_chknpq1(g_alh.alh01,2,4,'0',g_bookno1)        #檢查平衡       #No.FUN-730064  #No.MOD-740499
   IF g_aza.aza63 = 'Y' THEN
      CALL s_chknpq1(g_alh.alh01,2,4,'1',g_bookno2)     #檢查平衡       #No.FUN-730064  #No.MOD-740499
   END IF
   IF g_success = 'N' THEN RETURN END IF
   UPDATE alh_file SET alhfirm = 'Y' WHERE alh01 = g_alh.alh01
   IF STATUS THEN
      CALL cl_err3("upd","alh_file",g_alh.alh01,"",STATUS,"","",1)  #No.FUN-660122
      LET g_success='N'
   END IF
   CALL t820_hu(1,0)

   #MOD-CC0092 add start ----- 
   IF g_alh.alh30 IS NOT NULL THEN
      SELECT apa34,apa34f INTO l_apa34,l_apa34f FROM apa_file
        WHERE apa01=g_alh.alh30
      IF cl_null(l_apa34) THEN LET l_apa34 = 0 END IF
      IF cl_null(l_apa34f) THEN LET l_apa34f = 0 END IF
      CALL t820_comp_oox(g_alh.alh30) RETURNING g_net
      UPDATE apa_file SET apa35f=l_apa34f, 
                          apa35 =l_apa34
                         ,apa73 =apa34-l_apa34+g_net
         WHERE apa01= g_alh.alh30
   
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","apa_file",g_alh.alh30,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
      SELECT apc08,apc09 INTO l_apc08,l_apc09 FROM apc_file
       WHERE apc01=g_alh.alh30
      IF cl_null(l_apc08) THEN LET l_apc08 = 0 END IF
      IF cl_null(l_apc09) THEN LET l_apc09 = 0 END IF
      UPDATE apc_file SET apc10=l_apc08,    
                          apc11=l_apc09,
                          apc13=apc09-l_apc09+g_net
       WHERE apc01= g_alh.alh30 AND apc02=1
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","apc_file",g_alh.alh30,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
   END IF
   #MOD-CC0092 add end   -----

   IF g_success='Y' THEN
      LET g_alh.alhfirm ='Y'
      DISPLAY BY NAME  g_alh.alhfirm
      COMMIT WORK
      CALL cl_flow_notify(g_alh.alh01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t820_firm2()
   DEFINE l_alh72    LIKE alh_file.alh72,
          l_cnt      LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   IF cl_null(g_alh.alh01) THEN RETURN END IF
    SELECT * INTO g_alh.* FROM alh_file WHERE alh01=g_alh.alh01
   IF g_alh.alhfirm='N' THEN RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   #FUN-B50090 add -end--------------------------
   IF g_alh.alh021<=g_apz.apz57 THEN
      CALL cl_err(g_alh.alh01,'aap-176',1) RETURN
   END IF
   SELECT alh72 INTO l_alh72 FROM alh_file WHERE alh01=g_alh.alh01
   IF NOT cl_null(g_alh.alh72) THEN
      CALL cl_err(g_alh.alh01,'axr-370',0) RETURN
   END IF
   IF g_alh.alh45   ='Y' THEN CALL cl_err('alh45=Y','aap-304',0) RETURN END IF
   IF g_alh.alh44='2' THEN
      SELECT COUNT(*) INTO l_cnt FROM nne_file WHERE nne28=g_alh.alh01
      IF l_cnt>0 THEN CALL cl_err(g_alh.alh01,'aap-736',0) RETURN END IF
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK LET g_success='Y'
 
   OPEN t820_cl USING g_alh.alh01
   IF STATUS THEN
      CALL cl_err("OPEN t820_cl:", STATUS, 1)
      CLOSE t820_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t820_cl INTO g_alh.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alh.alh01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE alh_file SET alhfirm = 'N' WHERE alh01 = g_alh.alh01
   IF STATUS THEN
      CALL cl_err3("upd","alh_file",g_alh.alh01,"",STATUS,"","",1)  #No.FUN-660122
      LET g_success='N'
   END IF
   CALL t820_hu(1,0)

   #MOD-CC0092 add start -----
   IF g_alh.alh30 IS NOT NULL THEN
      CALL t820_comp_oox(g_alh.alh30) RETURNING g_net
      UPDATE apa_file SET apa35f=0,
                          apa35 =0
                         ,apa73 =apa34+g_net
         WHERE apa01= g_alh.alh30 
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","apa_file",g_alh.alh30,"",STATUS,"","upd apa_file",1)
         LET g_errno = STATUS
      END IF
      UPDATE apc_file SET apc10=0,
                          apc11=0,
                          apc13=apc09+g_net
       WHERE apc01= g_alh.alh30 AND apc02=1
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","apc_file",g_alh.alh30,"",STATUS,"","upd apc_file",1)
         LET g_errno = STATUS
      END IF
   END IF
   #MOD-CC0092 add end   -----

   IF g_success='Y' THEN
      LET g_alh.alhfirm ='N'
      DISPLAY BY NAME  g_alh.alhfirm
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 

 
FUNCTION t820_s(p_sw)
   DEFINE p_sw	LIKE type_file.chr1  		# 1.不要update alh 2.要update alh  #No.FUN-690028 VARCHAR(1)
   DEFINE aag02_1,aag02_2 ,aag02_3,aag02_4,aag02_5,aag02_6 LIKE aag_file.aag02  #FUN-660117 #No.FUN-680029
   DEFINE o_alh RECORD LIKE alh_file.*
   IF g_alh.alh01 IS NULL THEN RETURN END IF
    SELECT * INTO g_alh.* FROM alh_file
     WHERE alh01=g_alh.alh01
   LET o_alh.*=g_alh.*
 
 
   OPEN WINDOW t820_4_w AT 8,3 WITH FORM "aap/42f/aapt820_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt820_1")
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("alh411,alh421,alh431,aag02_4,aag02_5,aag02_6",TRUE)
    ELSE
       CALL cl_set_comp_visible("alh411,alh421,alh431,aag02_4,aag02_5,aag02_6",FALSE)
    END IF
 
 
 
   SELECT aag02 INTO aag02_1 FROM aag_file WHERE aag01=g_alh.alh41 
                                             AND aag00=g_bookno1     #No.FUN-730064
   SELECT aag02 INTO aag02_2 FROM aag_file WHERE aag01=g_alh.alh42
                                             AND aag00=g_bookno1     #No.FUN-730064
   SELECT aag02 INTO aag02_3 FROM aag_file WHERE aag01=g_alh.alh43
                                             AND aag00=g_bookno1     #No.FUN-730064
   IF g_aza.aza63 = 'Y' THEN
      SELECT aag02 INTO aag02_4 FROM aag_file WHERE aag01=g_alh.alh411
                                                AND aag00=g_bookno2     #No.FUN-730064
      SELECT aag02 INTO aag02_5 FROM aag_file WHERE aag01=g_alh.alh421
                                                AND aag00=g_bookno2     #No.FUN-730064
      SELECT aag02 INTO aag02_6 FROM aag_file WHERE aag01=g_alh.alh431
                                                AND aag00=g_bookno2     #No.FUN-730064
   END IF
   DISPLAY BY NAME aag02_1,aag02_2,aag02_3,aag02_4,aag02_5,aag02_6
   INPUT BY NAME g_alh.alh41,g_alh.alh42,g_alh.alh43,g_alh.alh411,g_alh.alh421,g_alh.alh431
                 WITHOUT DEFAULTS
     #No.FUN-B10050  --Begin
     AFTER FIELD alh41
         IF g_alh.alh41 IS NOT NULL THEN
            #SELECT aag02 INTO aag02_1 FROM aag_file WHERE aag01=g_alh.alh41
            #                                          AND aag00=g_bookno1         #No.FUN-730064
            #IF STATUS THEN 
            #   CALL cl_err3("sel","aag_file",g_alh.alh41,"",STATUS,"","sel aag:",1)  #No.FUN-660122
            #   NEXT FIELD alh41 END IF
            #DISPLAY BY NAME aag02_1
            CALL t820_aag01(g_bookno1,g_alh.alh41,'1')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alh.alh41,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_alh.alh41
               LET g_qryparam.arg1 = g_bookno1
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alh.alh41 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_alh.alh41
               DISPLAY BY NAME g_alh.alh41
               NEXT FIELD alh41
            END IF
         END IF
     AFTER FIELD alh42
         IF g_alh.alh42 IS NOT NULL THEN
            #SELECT aag02 INTO aag02_2 FROM aag_file WHERE aag01=g_alh.alh42
            #                                          AND aag00=g_bookno1     #No.FUN-730064
            #IF STATUS THEN 
            #   CALL cl_err3("sel","aag_file",g_alh.alh42,"",STATUS,"","sel aag:",1)  #No.FUN-660122
            #   NEXT FIELD alh42 END IF
            #DISPLAY BY NAME aag02_2
            CALL t820_aag01(g_bookno1,g_alh.alh42,'2')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alh.alh42,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_alh.alh42
               LET g_qryparam.arg1 = g_bookno1
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alh.alh42 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_alh.alh42
               DISPLAY BY NAME g_alh.alh42
               NEXT FIELD alh42
            END IF
         END IF
     AFTER FIELD alh43
         IF g_alh.alh43 IS NOT NULL THEN
            #SELECT aag02 INTO aag02_3 FROM aag_file WHERE aag01=g_alh.alh43
            #                                          AND aag00=g_bookno1     #No.FUN-730064
            #IF STATUS THEN
            #   CALL cl_err3("sel","aag_file",g_alh.alh43,"",STATUS,"","sel aag:",1)  #No.FUN-660122
            #   NEXT FIELD alh43 END IF
            #DISPLAY BY NAME aag02_3
            CALL t820_aag01(g_bookno1,g_alh.alh43,'3')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alh.alh43,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_alh.alh43
               LET g_qryparam.arg1 = g_bookno1
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alh.alh43 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_alh.alh43
               DISPLAY BY NAME g_alh.alh43
               NEXT FIELD alh43
            END IF
         END IF
     AFTER FIELD alh411
         IF g_alh.alh411 IS NOT NULL THEN
            #SELECT aag02 INTO aag02_4 FROM aag_file WHERE aag01=g_alh.alh411
            #                                          AND aag00=g_bookno2     #No.FUN-730064
            #IF STATUS THEN 
            #   CALL cl_err3("sel","aag_file",g_alh.alh411,"",STATUS,"","sel aag:",1)
            #   NEXT FIELD alh411 END IF
            #DISPLAY BY NAME aag02_4
            CALL t820_aag01(g_bookno2,g_alh.alh411,'4')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alh.alh411,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_alh.alh411
               LET g_qryparam.arg1 = g_bookno2
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alh.alh411 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_alh.alh411
               DISPLAY BY NAME g_alh.alh411
               NEXT FIELD alh411
            END IF
         END IF
     AFTER FIELD alh421
         IF g_alh.alh421 IS NOT NULL THEN
            #SELECT aag02 INTO aag02_5 FROM aag_file WHERE aag01=g_alh.alh421
            #                                          AND aag00=g_bookno2     #No.FUN-730064
            #IF STATUS THEN 
            #   CALL cl_err3("sel","aag_file",g_alh.alh421,"",STATUS,"","sel aag:",1)  #No.FUN-660122
            #   NEXT FIELD alh421 END IF
            #DISPLAY BY NAME aag02_5
            CALL t820_aag01(g_bookno2,g_alh.alh421,'5')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alh.alh421,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_alh.alh421
               LET g_qryparam.arg1 = g_bookno2
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alh.alh421 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_alh.alh421
               DISPLAY BY NAME g_alh.alh421
               NEXT FIELD alh421
            END IF
         END IF
     AFTER FIELD alh431
         IF g_alh.alh431 IS NOT NULL THEN
            #SELECT aag02 INTO aag02_6 FROM aag_file WHERE aag01=g_alh.alh431
            #                                          AND aag00=g_bookno2     #No.FUN-730064
            #IF STATUS THEN
            #   CALL cl_err3("sel","aag_file",g_alh.alh431,"",STATUS,"","sel aag:",1)  #No.FUN-660122
            #   NEXT FIELD alh431 END IF
            #DISPLAY BY NAME aag02_6
            CALL t820_aag01(g_bookno2,g_alh.alh431,'6')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alh.alh431,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_alh.alh431
               LET g_qryparam.arg1 = g_bookno2
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alh.alh431 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_alh.alh431
               DISPLAY BY NAME g_alh.alh431
               NEXT FIELD alh431
            END IF
         END IF
     #No.FUN-B10050  --End  
 
     ON ACTION controlp
        CASE
            WHEN INFIELD(alh41)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 = '2'"    #MOD-5C0012
               LET g_qryparam.default1 = g_alh.alh41
               LET g_qryparam.arg1 = g_bookno1    #No.TQC-740093
               CALL cl_create_qry() RETURNING g_alh.alh41
               DISPLAY BY NAME g_alh.alh41
            WHEN INFIELD(alh42)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 = '2'"     #MOD-5C0012
               LET g_qryparam.default1 = g_alh.alh42
               LET g_qryparam.arg1 = g_bookno1    #No.TQC-740093
               CALL cl_create_qry() RETURNING g_alh.alh42
               DISPLAY BY NAME g_alh.alh42
            WHEN INFIELD(alh43)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 = '2'"      #MOD-5C0012
               LET g_qryparam.default1 = g_alh.alh43
               LET g_qryparam.arg1 = g_bookno1    #No.TQC-740093
               CALL cl_create_qry() RETURNING g_alh.alh43
               DISPLAY BY NAME g_alh.alh43
            WHEN INFIELD(alh411)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 = '2'"
               LET g_qryparam.default1 = g_alh.alh411
               LET g_qryparam.arg1 = g_bookno2    #No.TQC-740093 
               CALL cl_create_qry() RETURNING g_alh.alh411
               DISPLAY BY NAME g_alh.alh411
            WHEN INFIELD(alh421)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 = '2'"     #MOD-5C0012
               LET g_qryparam.default1 = g_alh.alh421
               LET g_qryparam.arg1 = g_bookno2    #No.TQC-740093
               CALL cl_create_qry() RETURNING g_alh.alh421
               DISPLAY BY NAME g_alh.alh421
            WHEN INFIELD(alh431)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 = '2'"      #MOD-5C0012
               LET g_qryparam.default1 = g_alh.alh431
               LET g_qryparam.arg1 = g_bookno2    #No.TQC-740093
               CALL cl_create_qry() RETURNING g_alh.alh431
               DISPLAY BY NAME g_alh.alh431
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
   CLOSE WINDOW t820_4_w
   IF INT_FLAG THEN LET INT_FLAG=0 LET g_alh.*=o_alh.* RETURN END IF
   IF p_sw = '1' THEN RETURN END IF
   UPDATE alh_file SET alh41 = g_alh.alh41,
                       alh42 = g_alh.alh42,
                       alh43 = g_alh.alh43
            WHERE alh01 = g_alh.alh01
   IF g_aza.aza63 = 'Y' THEN
      UPDATE alh_file SET alh411 = g_alh.alh411,
                          alh421 = g_alh.alh421,
                          alh431 = g_alh.alh431
               WHERE alh01 = g_alh.alh01
   END IF
END FUNCTION
 
FUNCTION t820_g_gl(p_apno,p_sw1,p_sw2)
   DEFINE p_apno	LIKE alh_file.alh01
   DEFINE l_alh72       LIKE alh_file.alh72
   DEFINE p_sw1		LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 1.會計傳票
   DEFINE p_sw2		LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 0.Fixed
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   LET g_success = 'Y'  #No.FUN-680029
 
   IF p_apno IS NULL THEN RETURN END IF
   SELECT * INTO g_alh.* FROM alh_file
    WHERE alh01 = p_apno
   IF g_alh.alhfirm = 'Y' THEN RETURN END IF
   SELECT alh72 INTO l_alh72 FROM alh_file
    WHERE alh01=p_apno
   IF NOT cl_null(l_alh72) THEN RETURN END IF
   BEGIN WORK
     SELECT COUNT(*) INTO l_n FROM npp_file
      WHERE npp01 = p_apno AND npp00 = p_sw1 AND npp011 = p_sw2
        AND nppsys = 'LC'
     IF l_n > 0 THEN
        IF NOT s_ask_entry(p_apno) THEN ROLLBACK WORK RETURN END IF #Genero      #No.FUN-680029
        #FUN-B40056--add--str--
        LET l_n = 0
        SELECT COUNT(*) INTO l_n FROM tic_file
         WHERE tic04 = p_apno
        IF l_n > 0 THEN
           IF NOT cl_confirm('sub-533') THEN
              ROLLBACK WORK
              RETURN
           ELSE
              DELETE FROM tic_file WHERE tic04 = p_apno
           END IF
        END IF
        #FUN-B40056--add--end--
        DELETE FROM npp_file
               WHERE npp01 = p_apno AND npp00 = p_sw1 AND npp011 = p_sw2
                 AND nppsys = 'LC'
        DELETE FROM npq_file
               WHERE npq01 = p_apno AND npq00 = p_sw1 AND npq011 = p_sw2
                 AND npqsys = 'LC'
     END IF
     IF p_sw1='4' THEN 
        CALL t820_g_gl_1(p_apno,p_sw1,p_sw2,'0')
        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           CALL t820_g_gl_1(p_apno,p_sw1,p_sw2,'1')
        END IF
     ELSE
        CALL t820_g_gl_2(p_apno,p_sw1,p_sw2,'0')
        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           CALL t820_g_gl_2(p_apno,p_sw1,p_sw2,'1')
        END IF
     END IF
     IF g_success = 'Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t820_g_gl_1(p_apno,p_sw1,p_sw2,p_npptype)      #No.FUN-680029
   DEFINE p_apno	LIKE alh_file.alh01
   DEFINE p_sw1		LIKE type_file.chr1                #1.會計  #No.FUN-690028 VARCHAR(1)
   DEFINE p_sw2		LIKE type_file.chr1                #0.Fixed  #No.FUN-690028 VARCHAR(1)
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_dept	LIKE alh_file.alh04
   DEFINE l_alh		RECORD LIKE alh_file.*
   DEFINE l_pmc03	LIKE pmc_file.pmc03    #FUN-660117
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_aps		RECORD LIKE aps_file.*
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag151      LIKE aag_file.aag151
   DEFINE l_aag44       LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1   #No.FUN-D40118   Add

   SELECT * INTO l_alh.* FROM alh_file WHERE alh01 = p_apno
   IF STATUS THEN 
      LET g_success = 'N'       #No.FUN-680029
      RETURN 
   END IF
    IF g_apz.apz13 = 'Y'
       THEN LET l_dept = g_alh.alh04
       ELSE LET l_dept = ' '
    END IF
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_dept
   IF STATUS THEN 
      INITIALIZE l_aps.* TO NULL
      CALL cl_err_msg('','aap-830',l_dept,1)   #MOD-970175      
      LET g_success = 'N'       #No.FUN-680029
   END IF
   # 首先, Insert 一筆單頭
   INITIALIZE l_npp.* TO NULL
   LET l_npp.nppsys = 'LC'             #系統別
   LET l_npp.npp00  = p_sw1            #類別
   LET l_npp.npp01  = l_alh.alh01      #單號
   LET l_npp.npp011 = p_sw2            #異動序號
   LET l_npp.npp02  = l_alh.alh021     #日期
   LET l_npp.npptype= p_npptype        #No.FUN-680029
   LET l_npp.npplegal= g_legal         #FUN-980001 add
   INSERT INTO npp_file VALUES (l_npp.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp02,STATUS,"","ins npp#1",1)  #No.FUN-660122
      LET g_success = 'N'       #No.FUN-680029
   END IF
 
 
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqsys = 'LC'             #系統別
   LET l_npq.npq01 = l_alh.alh01
   LET l_npq.npq00 = p_sw1
   LET l_npq.npq011= p_sw2
   LET l_npq.npq02 = 0
   LET l_npq.npq05 = l_alh.alh04
   LET l_npq.npq07  = 0                #本幣金額
   LET l_npq.npq07f = 0
   LET l_npq.npq24  = l_alh.alh11      #到單幣別
   LET l_npq.npq25  = l_alh.alh15      #到單匯率
   LET l_npq.npqtype= p_npptype        #No.FUN-680029

  #借:在途存貨/預估應付 -----------------------------------------------------
   LET l_npq.npq02 = l_npq.npq02 + 1
   IF p_npptype = '0' THEN
      LET l_npq.npq03 = l_alh.alh41
      LET g_bookno = g_bookno1  #No.MOD-740499
   ELSE
      LET l_npq.npq03 = l_alh.alh411
      LET g_bookno = g_bookno2  #No.MOD-740499
   END IF
  #--------------------MOD-D20154------------------mark
  #LET l_npq.npq04 = l_alh.alh03 CLIPPED,' ',   # L/C NO
  #                  l_alh.alh11 CLIPPED,' ',   # CURR
  #                  l_alh.alh12 USING '<<<<<<<<<<<<<<.<<'  #MOD-960220
  #--------------------MOD-D20154------------------mark
   LET l_npq.npq06 = '1'
   IF l_alh.alh32 IS NOT NULL AND l_alh.alh32 != 0 THEN
      LET l_npq.npq07f = l_alh.alh32		# 先到貨
      LET l_npq.npq07  = l_alh.alh36		# 先到貨
      LET l_npq.npq25  = l_alh.alh35            #MOD-9C0448 add
   ELSE
      LET l_npq.npq07f = l_alh.alh14		# 先到貨
      LET l_npq.npq07  = l_alh.alh16		# 先到單
      LET l_npq.npq25  = l_alh.alh15            #MOD-9C0448 add
   END IF
   LET l_aag05 = ''
   SELECT aag05,aag151 INTO l_aag05,l_aag151 FROM aag_file
    WHERE aag01 = l_npq.npq03
      AND aag00=g_bookno      #No.FUN-730064      #No.MOD-740499
   IF l_aag05 = 'Y' THEN
      LET l_npq.npq05 = t820_set_npq05(l_alh.alh04,l_alh.alh930) #FUN-680019
   ELSE
      LET l_npq.npq05 = ' '
   END IF
   LET l_npq.npq21=''
   LET l_npq.npq22=''
   LET l_npq.npq21=l_alh.alh05
   SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
    WHERE pmc01 = l_npq.npq21
 
   #若要做異動碼管理
   LET l_npq.npq11 = NULL
   LET l_npq.npq04 = NULL                    #MOD-D20154 add
   CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #NO.FUN-730064
   RETURNING l_npq.*
  #-------------------------MOD-D20154-------------------(S)
   IF cl_null(l_npq.npq04) THEN
      LET l_npq.npq04 = l_alh.alh03 CLIPPED,' ',                           #L/C NO
                        l_alh.alh11 CLIPPED,' ',                           #CURR
                        l_alh.alh12 USING '<<<<<<<<<<<<<<.<<'
   END IF
  #-------------------------MOD-D20154-------------------(E)
   CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
   LET l_npq.npqlegal = g_legal  #FUN-980001 add
  #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = g_bookno
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq_1:",1)  #No.FUN-660122
      LET g_success = 'N'       #No.FUN-680029
   END IF

   LET l_npq.npq25  = l_alh.alh15      #匯率  #MOD-9C0448 add
  #貸:銀行借款/應付遠期LC/a_p------------------------------------------
  #--------------------MOD-D20154------------------mark
  #LET l_npq.npq04 = l_alh.alh03 CLIPPED,' ',	# L/C NO
  #                  l_alh.alh11 CLIPPED,' ',	# CURR
  #           #       l_alh.alh12-l_alh.alh13 USING '<<<<<<<.<<'   #MOD-960220 
  #                  l_alh.alh12-l_alh.alh13 USING '<<<<<<<<<<<<<<.<<'#MOD-960220 
  #--------------------MOD-D20154------------------mark
   LET l_npq.npq02 = l_npq.npq02 + 1
   IF p_npptype = '0' THEN
      LET l_npq.npq03 = l_alh.alh42
   ELSE
      LET l_npq.npq03 = l_alh.alh421
   END IF
   LET l_npq.npq06 = '2'
   LET l_aag05 = ''
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = l_npq.npq03
      AND aag00=g_bookno     #No.FUN-730064  #No.MOD-740499
   IF l_aag05 = 'Y' THEN
      LET l_npq.npq05 = t820_set_npq05(l_alh.alh04,l_alh.alh930) #FUN-680019
   ELSE
      LET l_npq.npq05 = ' '
   END IF
   LET l_npq.npq21=''
   LET l_npq.npq22=''
   IF l_alh.alh44 = '1' THEN   #MOD-B50138
      LET l_npq.npq21 = l_alh.alh06
      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
       WHERE pmc01 = l_npq.npq21
   END IF                      #MOD-B50138
   LET l_npq.npq07f= l_alh.alh14
   LET l_npq.npq07 = l_alh.alh16
   LET l_npq.npq04 = NULL                    #MOD-D20154 add
   CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)       #No.FUN-730064
   RETURNING l_npq.*
  #-------------------------MOD-D20154-------------------(S)
   IF cl_null(l_npq.npq04) THEN
      LET l_npq.npq04 = l_alh.alh03 CLIPPED,' ',                               #L/C NO
                        l_alh.alh11 CLIPPED,' ',                               #CURR
                        l_alh.alh12-l_alh.alh13 USING '<<<<<<<<<<<<<<.<<'
   END IF
  #-------------------------MOD-D20154-------------------(E)
   CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq32,l_npq.npq34     #FUN-AA0087
   LET l_npq.npqlegal = g_legal  #FUN-980001 add
  #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = g_bookno
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq_2:",1)  #No.FUN-660122
      LET g_success = 'N'       #No.FUN-680029
   END IF
  #貸:立帳差異 --------------------------------------------------------------
   IF l_alh.alh37 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_alh.alh43
      ELSE
         LET l_npq.npq03 = l_alh.alh431
      END IF
      LET l_npq.npq06 = '1'
      LET l_npq.npq07f = l_alh.alh14-l_alh.alh32
      LET l_npq.npq07  = l_alh.alh37
      IF l_npq.npq07 < 0 THEN
         LET l_npq.npq06 = '2' LET l_npq.npq07 = l_npq.npq07 * -1
      END IF
      LET l_npq.npq21 = ''
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00=g_bookno      #No.FUN-730064  #No.MOD-740499
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t820_set_npq05(l_alh.alh04,l_alh.alh930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq22=''
      LET l_npq.npq21=l_alh.alh05
      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
       WHERE pmc01 = l_npq.npq21
      LET l_npq.npq04 = NULL                    #MOD-D20154 add
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)         #No.FUN-730064
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
      LET l_npq.npqlegal = g_legal  #FUN-980001 add
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq_3:",1)  #No.FUN-660122 
         LET g_success = 'N'       #No.FUN-680029
      END IF
   END IF
#貸:匯兌差異 --------------------------------------------------------------
   IF l_alh.alh38 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_aps.aps42
      ELSE
         LET l_npq.npq03 = l_aps.aps421
      END IF
      LET l_npq.npq06 = '1'
      LET l_npq.npq07f= 0
      LET l_npq.npq07 = l_alh.alh38
      IF l_npq.npq07 < 0 THEN
         LET l_npq.npq03 = l_aps.aps43
         LET l_npq.npq06 = '2'
         LET l_npq.npq07 = l_npq.npq07 * -1
      END IF
      LET l_npq.npq21 = ''
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00=g_bookno      #No.FUN-730064  #No.MOD-740499
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t820_set_npq05(l_alh.alh04,l_alh.alh930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq22=''
      LET l_npq.npq21=l_alh.alh05
      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
       WHERE pmc01 = l_npq.npq21
      LET l_npq.npq04 = NULL                    #MOD-D20154 add
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34     #FUN-AA0087
      LET l_npq.npqlegal = g_legal  #FUN-980001 add
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq_4:",1)  #No.FUN-660122
         LET g_success = 'N'       #No.FUN-680029
      END IF
   END IF
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021
END FUNCTION
 
FUNCTION t820_g_gl_2(p_apno,p_sw1,p_sw2,p_npptype)      #No.FUN-680029
   DEFINE p_apno	LIKE alh_file.alh01
   DEFINE p_sw1		LIKE type_file.chr1                #1.會計  #No.FUN-690028 VARCHAR(1)
   DEFINE p_sw2		LIKE type_file.chr1                #0.Fixed  #No.FUN-690028 VARCHAR(1)
   DEFINE p_npptype     LIKE npp_file.npptype #No.FUN-680029
   DEFINE l_dept	LIKE alh_file.alh04
   DEFINE l_alh		RECORD LIKE alh_file.*
   DEFINE l_pmc03	LIKE pmc_file.pmc03   #FUN-660117
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_aps		RECORD LIKE aps_file.*
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag44       LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1   #No.FUN-D40118   Add

   SELECT * INTO l_alh.* FROM alh_file WHERE alh01 = p_apno
   IF STATUS THEN LET g_success = 'N' RETURN END IF      #No.FUN-680029
    IF g_apz.apz13 = 'Y'
       THEN LET l_dept = g_alh.alh04
       ELSE LET l_dept = ' '
    END IF
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_dept
   IF STATUS THEN 
      INITIALIZE l_aps.* TO NULL 
      CALL cl_err_msg('','aap-830',l_dept,1)   #MOD-970175     
      LET g_success = 'N'       #No.FUN-680029
   END IF
   # 首先, Insert 一筆單頭
   INITIALIZE l_npp.* TO NULL
   LET l_npp.nppsys = 'LC'             #系統別
   LET l_npp.npp00  = p_sw1            #類別
   LET l_npp.npp01  = l_alh.alh01      #單號
   LET l_npp.npp011 = p_sw2            #異動序號
   LET l_npp.npp02  = l_alh.alh021     #日期
   LET l_npp.npptype= p_npptype        #No.FUN-680029
   LET l_npp.npplegal= g_legal         #FUN-980001 add
   INSERT INTO npp_file VALUES (l_npp.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,STATUS,"","ins npp#1",1)  #No.FUN-660122
      LET g_success = 'N'       #No.FUN-680029
   END IF
 
   # 然後, Insert 單身
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqsys = 'LC'             #系統別
   LET l_npq.npq01 = l_alh.alh01
   LET l_npq.npq00 = p_sw1
   LET l_npq.npq011= p_sw2
   LET l_npq.npqtype= p_npptype        #No.FUN-680029
   LET l_npq.npq02 = 0
   LET l_npq.npq07f = 0
   LET l_npq.npq07  = 0                #本幣金額
   LET l_npq.npq24  = l_alh.alh11      #到單幣別
   LET l_npq.npq25  = l_alh.alh15      #到單匯率
  #借:a_p/銀行借款 -----------------------------------------------------
   LET l_npq.npq02 = l_npq.npq02 + 1
   IF p_npptype = '0' THEN
      LET l_npq.npq03 = l_alh.alh42
      LET g_bookno = g_bookno1  #No.MOD-740499
   ELSE
      LET l_npq.npq03 = l_alh.alh421
      LET g_bookno = g_bookno2  #No.MOD-740499
   END IF
   LET l_npq.npq06 = '1'
   LET l_npq.npq07f = l_alh.alh16
   LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
   LET l_aag05 = ''
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = l_npq.npq03
      AND aag00=g_bookno      #No.FUN-730064  #No.MOD-740499
   IF l_aag05 = 'Y' THEN
      LET l_npq.npq05 = t820_set_npq05(l_alh.alh04,l_alh.alh930) #FUN-680019
   ELSE
      LET l_npq.npq05 = ' '
   END IF
   LET l_npq.npq21=''
   LET l_npq.npq22=''
   LET l_npq.npq21=l_alh.alh05
   SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
    WHERE pmc01 = l_npq.npq21
   LET l_npq.npq04 = NULL                    #MOD-D20154 add
   CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)           #No.FUN-730064
   RETURNING l_npq.*
   CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
   LET l_npq.npqlegal = g_legal  #FUN-980001 add
  #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = g_bookno
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq_1:",1)  #No.FUN-660122
      LET g_success = 'N'       #No.FUN-680029
   END IF
#貸:銀行存款 --------------------------------------------------------------
   LET l_npq.npq02 = l_npq.npq02 + 1
   IF p_npptype = '0' THEN
      LET l_npq.npq03 = l_aps.aps11
   ELSE
      LET l_npq.npq03 = l_aps.aps111
   END IF
   LET l_npq.npq06 = '2'
   LET l_npq.npq07f = l_alh.alh16
   LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
   LET l_aag05 = ''
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = l_npq.npq03  
      AND aag00=g_bookno      #No.FUN-730064  #No.MOD-740499
   IF l_aag05 = 'Y' THEN
      LET l_npq.npq05 = t820_set_npq05(l_alh.alh04,l_alh.alh930) #FUN-680019
   ELSE
      LET l_npq.npq05 = ' '
   END IF
   LET l_npq.npq21=''
   LET l_npq.npq22=''
   LET l_npq.npq21=l_alh.alh05
   SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
    WHERE pmc01 = l_npq.npq21
   LET l_npq.npq04 = NULL                    #MOD-D20154 add
   CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)          #No.FUN-730064
   RETURNING l_npq.*
   CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
   LET l_npq.npqlegal = g_legal  #FUN-980001 add
  #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = g_bookno
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq_2:",1)  #No.FUN-660122
      LET g_success = 'N'       #No.FUN-680029
   END IF
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021   
END FUNCTION
#FUN-B10030--start-- 
#FUNCTION t820_d()
#   DEFINE l_plant,l_dbs	LIKE type_file.chr21       # No.FUN-690028 VARCHAR(21)
 
#            LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
 
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   DATABASE l_dbs
#   CALL cl_ins_del_sid(1,l_plant) #FUN-980030  #FUN-990069
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant
#   LET g_dbs   = l_dbs
#   CALL t820_lock_cur()
#END FUNCTION
#--FUN-B10030--end-- 
FUNCTION t820_hu(u_sw,r_sw)
   DEFINE u_sw,r_sw        LIKE type_file.num5        # No.FUN-690028 SMALLINT
   CALL t820_hu_ala()
   CALL t820_hu_alk()
 
END FUNCTION
 
FUNCTION t820_hu_ala()
   DEFINE tot1,tot2   LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   LET tot1=0 LET tot2=0
   SELECT SUM(alh12),SUM(alh19) INTO tot1,tot2 FROM alh_file
      WHERE alh00='1' AND alh03=g_alh.alh03 AND alhfirm='Y' AND
            (alh52 IS NULL OR alh52 = 'N')
   IF STATUS THEN 
   CALL cl_err3("sel","alh_file",g_alh.alh03,"",STATUS,"","sel sum(alh12):",1)  #No.FUN-660122
   END IF
   IF tot1 IS NULL THEN LET tot1=0 END IF
   IF tot2 IS NULL THEN LET tot2=0 END IF
   #no.5372不更新預付已攤，此金額到貨時更新，以免分批到貨會有誤
   UPDATE ala_file SET ala25=tot1               # 更新LC已到單金額
           WHERE ala01=g_alh.alh03
   IF STATUS THEN 
   CALL cl_err3("upd","ala_file",g_alh.alh03,"",STATUS,"","upd ala25,61:",1)  #No.FUN-660122
   END IF
END FUNCTION
 
FUNCTION t820_hu_alk()
   DEFINE tot1,tot2    LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   IF g_alh.alh30 IS NULL THEN RETURN END IF
   LET tot1=0
   SELECT SUM(alh12) INTO tot1	# 取總共已到單金額
           FROM alh_file WHERE alh30=g_alh.alh30 AND alhfirm='Y' AND alh00='1'
   IF STATUS THEN 
   CALL cl_err3("sel","alh_file",g_alh.alh03,"",STATUS,"","sel sum(alh36):",1)  #No.FUN-660122
   END IF
   IF tot1 IS NULL THEN LET tot1=0 END IF
   UPDATE alk_file SET alk33=tot1	# 更新alk33(已到單金額)
           WHERE alk01=g_alh.alh30
   IF STATUS THEN
   CALL cl_err3("upd","alk_file",g_alh.alh03,"",STATUS,"","upd alk33:",1)  #No.FUN-660122
   END IF
END FUNCTION
 
FUNCTION t820_g()
   DEFINE l_nne       RECORD LIKE nne_file.*
   DEFINE l_cnt       LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE g_t1        LIKE oay_file.oayslip  #No.FUN-550030  #No.FUN-690028 VARCHAR(05)
   DEFINE li_result   LIKE type_file.num5    #No.FUN-550030  #No.FUN-690028 SMALLINT
   DEFINE l_apa34     LIKE apa_file.apa34    #MOD-880094 add
   DEFINE l_apa34f    LIKE apa_file.apa34f   #MOD-880094 add
   DEFINE l_apc08     LIKE apc_file.apc08    #MOD-990222 add
   DEFINE l_apc09     LIKE apc_file.apc09    #MOD-990222 add
 
   IF g_alh.alh01 IS NULL THEN RETURN END IF
   SELECT * INTO g_alh.* FROM alh_file WHERE alh01=g_alh.alh01
   IF g_alh.alhfirm !='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO l_cnt FROM nne_file WHERE nne28=g_alh.alh01
   IF l_cnt>0 THEN CALL cl_err(g_alh.alh01,'aap-736',0) RETURN END IF
 
   IF g_alh.alh44  !='2' THEN CALL cl_err('alh44=1','aap-306',0) RETURN END IF
 
   INITIALIZE l_nne.* TO NULL
   LET l_date=g_today
   LET l_date1=g_today   #FUN-690104
   LET l_date2=0   #MOD-640015
 
 
   OPEN WINDOW t820_g_w AT 8,3 WITH FORM "aap/42f/aapt820_g"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt820_g")
 
   INPUT BY NAME l_nne.nne01,l_date,l_date1,l_date2 WITHOUT DEFAULTS    #FUN-690104
      AFTER FIELD nne01
         IF NOT cl_null(l_nne.nne01) THEN
            IF cl_null(l_nne.nne01) THEN NEXT FIELD nne01 END IF
            LET g_t1 = s_get_doc_no(l_nne.nne01)             #No.FUN-550030
            CALL s_check_no("anm",l_nne.nne01,"","4","nne_file","nne01","")
               RETURNING li_result,l_nne.nne01
            DISPLAY BY NAME l_nne.nne01
            IF (NOT li_result) THEN
               NEXT FIELD nne01
            END IF
            IF g_nmy.nmydmy3= 'Y' THEN
               CALL cl_err(l_nne.nne01,'anm-036',0)
               NEXT FIELD nne01
            END IF

         END IF
 
      AFTER FIELD l_date
	 IF cl_null(l_date) THEN NEXT FIELD l_date END IF
 
      AFTER FIELD l_date1
         IF cl_null(l_date1) THEN NEXT FIELD l_date1 END IF
 
      AFTER FIELD l_date2
         IF cl_null(l_date2) THEN NEXT FIELD l_date2 END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(l_nne.nne01) THEN NEXT FIELD nne01 END IF
         IF cl_null(l_date)      THEN NEXT FIELD l_date END IF
         IF cl_null(l_date1)      THEN NEXT FIELD l_date1 END IF   #FUN-690104
         IF cl_null(l_date2)      THEN NEXT FIELD l_date2 END IF   #MOD-640015
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(nne01)
             
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmy01"
               CALL cl_create_qry() RETURNING l_nne.nne01
               DISPLAY BY NAME l_nne.nne01
               NEXT FIELD nne01
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
   CLOSE WINDOW t820_g_w
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   BEGIN WORK LET g_success='Y'
 
   OPEN t820_cl USING g_alh.alh01
   IF STATUS THEN
      CALL cl_err("OPEN t820_cl:", STATUS, 1)
      CLOSE t820_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t820_cl INTO g_alh.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alh.alh01,SQLCA.sqlcode,0)
       CLOSE t820_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL s_auto_assign_no("anm",l_nne.nne01,g_alh.alh021,"4","nne_file","nne01","","","")
     RETURNING li_result,l_nne.nne01
   IF (NOT li_result) THEN
      RETURN
   END IF

   LET l_no=l_nne.nne01  #No.+204
   SELECT ala03,ala35,ala33,ala79 INTO l_nne.nne15,l_nne.nne06,l_nne.nne30,l_nne.nneex2 #MOD-990158 add nneex2  
     FROM ala_file
    WHERE ala01=g_alh.alh03 AND alafirm <> 'X'
   LET l_nne.nne02=l_date1                     #申請日期
   LET l_nne.nne03=l_date1                     #動用日期
   LET l_nne.nne04=g_alh.alh06                      #信貸銀行
   LET l_nne.nne05=g_alh.alh06                      #存入銀行
   LET l_nne.nne051=' '                             #存入異動碼
   LET l_nne.nne07 ='1'                             #擔保品
   LET l_nne.nne08 =g_alh.alh51                     #付息方式
   LET l_nne.nne09 ='1'                             #計息方式
   LET l_nne.nne10 =' '                             #摘要
   LET l_nne.nne111=l_date                    #融資起始日期   #FUN-690104
   LET l_nne.nne112=g_alh.alh08                     #融資截止日期
   LET l_nne.nne12 =g_alh.alh14                     #融資金額(原幣)
   LET l_nne.nne13 =g_alh.alh09                     #借款利率%
   LET l_nne.nne14 =g_alh.alh09                     #借款利率%
   LET l_nne.nne16 =g_alh.alh11                     #幣別
   LET l_nne.nne17 =g_alh.alh15                     #匯率
   LET l_nne.nne18 =' '                             #現金變動碼
   LET l_nne.nne19 =g_alh.alh16                     #本幣融資金額
   LET l_nne.nne20 =0                               #本幣已還餘額
   LET l_nne.nne21 =' '                             #還款日
   LET l_nne.nne22 =l_date2                             #還息日   #MOD-640015
   LET l_nne.nne23 =0                               #保證手續費利率%
   LET l_nne.nne24 =0                               #手續費用
   LET l_nne.nne25 =0                               #本票折價
   LET l_nne.nne26 =' '                             #結案日期
   LET l_nne.nne27 =0                               #原幣已還餘額
   LET l_nne.nne28 =g_alh.alh01                     #參考單號
   LET l_nne.nne29 =0                               #保證金費用
   LET l_nne.nne43 = g_plant   #MOD-640015
   LET l_nne.nne_c1=g_alh.alh42
   LET l_nne.nneconf ='Y'
   LET l_nne.nneacti ='Y'
   LET l_nne.nneuser =g_user
   LET l_nne.nnegrup =g_grup
   LET l_nne.nne241 = 0
   LET l_nne.nne291 = 0
   LET l_nne.nne34 = 0
   LET l_nne.nne36 = 0
   LET l_nne.nne37 = 0
   LET l_nne.nne371 = 0
   LET l_nne.nne42 = 0
   LET l_nne.nne45 = 0
   LET l_nne.nne46 = 0
   LET l_nne.nne461 = 0
   LET l_nne.nnelegal = g_legal #FUN-980001 add
   LET l_nne.nneoriu = g_user      #No.FUN-980030 10/01/04
   LET l_nne.nneorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO nne_file VALUES (l_nne.*)
   IF status OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("ins","nne_file",l_nne.nne01,"",SQLCA.sqlcode,"","ins nne:",1)  #No.FUN-660122
      LET g_success='N'
   ELSE
      UPDATE alh_file SET alh75='1',alh74=l_date WHERE alh01=g_alh.alh01
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","alh_file",g_alh.alh01,"",SQLCA.sqlcode,"","upd alh74",1)  #No.FUN-660122
         LET g_success='N'
      END IF
      SELECT alh74,alh75 INTO g_alh.alh74,g_alh.alh75 FROM alh_file
       WHERE alh01=g_alh.alh01
      DISPLAY BY NAME  g_alh.alh74,g_alh.alh75
   END IF
   LET l_apa34=0   LET l_apa34f=0
   LET l_apc08=0   LET l_apc09 =0   #MOD-990222 add
   IF g_alh.alh30 IS NOT NULL THEN
      SELECT apa34,apa34f INTO l_apa34,l_apa34f FROM apa_file
        WHERE apa01=g_alh.alh30
      IF cl_null(l_apa34)  THEN LET l_apa34 = 0 END IF
      IF cl_null(l_apa34f) THEN LET l_apa34f= 0 END IF
      CALL t820_comp_oox(g_alh.alh30) RETURNING g_net  #CHI-890017 add
      UPDATE apa_file SET apa35f=l_apa34f,
                          apa35 =l_apa34
                         ,apa73 =apa34-l_apa34+g_net   #CHI-890017 add
       WHERE apa01= g_alh.alh30
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","apa_file",g_alh.alh30,"",SQLCA.sqlcode,"","upd apa_file",1)
         LET g_success = 'N'
      END IF
      SELECT apc08,apc09 INTO l_apc08,l_apc09 FROM apc_file
       WHERE apc01=g_alh.alh30
      IF cl_null(l_apc08) THEN LET l_apc08 = 0 END IF
      IF cl_null(l_apc09) THEN LET l_apc09 = 0 END IF
      UPDATE apc_file SET apc10=l_apc08,
                          apc11=l_apc09,
                          apc13=apc09-l_apc09+g_net
       WHERE apc01= g_alh.alh30 AND apc02=1
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","apc_file",g_alh.alh30,"",SQLCA.sqlcode,"","upd apc_file",1)
         LET g_success = 'N'
      END IF
   END IF
   IF g_success='N' THEN
      CLOSE t820_cl ROLLBACK WORK
   ELSE
      COMMIT WORK
      DISPLAY l_no TO FORMONLY.l_no
      CALL cl_end(20,20)
   END IF
END FUNCTION
 
FUNCTION t820_w()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_alh.alh01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_alh.* FROM alh_file WHERE alh01=g_alh.alh01
    IF g_alh.alhfirm ='N' THEN CALL cl_err('','9029',0) RETURN END IF
    IF g_alh.alhacti ='N' THEN               #檢查資料是否為無效
        CALL cl_err(g_alh.alh01,'9027',0) RETURN
    END IF
    IF g_alh.alh45   ='Y' THEN CALL cl_err('alh45=Y','aap-304',0) RETURN END IF
    IF g_alh.alh44  !='1' THEN CALL cl_err('alh44=2','aap-305',0) RETURN END IF
    IF cl_null(g_alh.alh72) THEN
       CALL cl_err('','aap-276',0)
       RETURN
    END IF
    IF NOT cl_confirm('aap-302') THEN RETURN END IF
    MESSAGE ""
    BEGIN WORK
    LET g_success='Y'
 
    OPEN t820_cl USING g_alh.alh01
    IF STATUS THEN
       CALL cl_err("OPEN t820_cl:", STATUS, 1)
       CLOSE t820_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t820_cl INTO g_alh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_alh.alh01,SQLCA.SQLCODE,0)
       CLOSE t820_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t820_ins_ap12()
    IF g_success='Y' THEN
       UPDATE alh_file SET alh45 ='Y',alh75='1',alh74=l_date
        WHERE alh01=g_alh.alh01
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
          LET g_success='N'
          CALL cl_err3("upd","alh_file",g_alh.alh01,"",SQLCA.sqlcode,"","upd alh45",1)  #No.FUN-660122
       END IF
    END IF
    IF g_success='Y' THEN
       COMMIT WORK
       DISPLAY l_no TO FORMONLY.l_no
       CALL cl_end(20,20)
    ELSE
       CLOSE t820_cl ROLLBACK WORK
    END IF
    SELECT alh45,alh74,alh75 INTO g_alh.alh45,g_alh.alh74,g_alh.alh75
      FROM alh_file
     WHERE alh01=g_alh.alh01
    DISPLAY BY NAME  g_alh.alh45,g_alh.alh74,g_alh.alh75
END FUNCTION
 
FUNCTION t820_x()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_alh.alh01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_alh.* FROM alh_file WHERE alh01=g_alh.alh01
    IF g_alh.alhacti ='N' THEN                  #檢查資料是否為無效
       CALL cl_err(g_alh.alh01,'9027',0) RETURN
    END IF
    IF g_alh.alh44  !='1' THEN CALL cl_err('alh44=2','aap-305',0) RETURN END IF
    IF g_alh.alh45='N' THEN CALL cl_err('alh45=N','aap-308',0) RETURN END IF
    IF NOT cl_confirm('aap-303') THEN RETURN END IF
    MESSAGE ""
    BEGIN WORK
    LET g_success='Y'
 
    OPEN t820_cl USING g_alh.alh01
    IF STATUS THEN
       CALL cl_err("OPEN t820_cl:", STATUS, 1)
       CLOSE t820_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t820_cl INTO g_alh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_alh.alh01,SQLCA.SQLCODE,0)
       CLOSE t820_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t820_del_ap12()
    IF NOT cl_null(g_errno) THEN
       LET g_success='N'
       CALL cl_err(g_alh.alh01,g_errno,1)
    END IF
    IF g_success='Y' THEN
       UPDATE alh_file SET alh45 ='N',alh75='0',alh74=NULL
        WHERE alh01=g_alh.alh01
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
          LET g_success='N'
          CALL cl_err3("upd","alh_file",g_alh.alh01,"",SQLCA.sqlcode,"","upd alh45",1)  #No.FUN-660122
       END IF
     END IF
     IF g_success='Y' THEN
        COMMIT WORK
        DISPLAY ' ' TO FORMONLY.l_no
     ELSE
        CLOSE t820_cl ROLLBACK WORK
        DISPLAY g_alh.alh01 TO FORMONLY.l_no
     END IF
     SELECT alh45,alh74,alh75 INTO g_alh.alh45,g_alh.alh74,g_alh.alh75
       FROM alh_file
      WHERE alh01=g_alh.alh01
     DISPLAY BY NAME  g_alh.alh45,g_alh.alh74,g_alh.alh75
END FUNCTION
 
FUNCTION t820_ins_ap12()
DEFINE l_apa        RECORD LIKE apa_file.*,
       l_apc        RECORD LIKE apc_file.*,    #CHI-810016
       l_paydate    LIKE apa_file.apa12,
       l_alg02      LIKE alg_file.alg02,
       l_gen03      LIKE gen_file.gen03,
       l_pmm20      LIKE pmm_file.pmm20,
       l_pmc03      LIKE pmc_file.pmc03,
       l_gec03      LIKE gec_file.gec03,
       l_gec031     LIKE gec_file.gec031,      #No.FUN-680029
       l_gec04      LIKE gec_file.gec04,
       l_gec06      LIKE gec_file.gec06,
       l_gec08      LIKE gec_file.gec08,
       l_gecacti    LIKE gec_file.gecacti,
      #l_apa34      LIKE apa_file.apa34,   #MOD-750005     #MOD-CC0092 mark
      #l_apa34f     LIKE apa_file.apa34f,  #MOD-750005     #MOD-CC0092 mark
      #l_apc08      LIKE apc_file.apc08,   #MOD-990222 add #MOD-CC0092 mark
      #l_apc09      LIKE apc_file.apc09,   #MOD-990222 add #MOD-CC0092 mark
       g_t1         LIKE oay_file.oayslip  #FUN-990014 add
DEFINE l_alk97      LIKE alk_file.alk97    #FUN-A60056 
    INITIALIZE l_apa.* TO NULL
    LET l_date=g_today
 
 
    OPEN WINDOW t820_w_w AT 8,5 WITH FORM "aap/42f/aapt820_w"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt820_w")
 
 
    INPUT BY NAME l_apa.apa15,l_apa.apa16,l_apa.apa36,l_date
                  WITHOUT DEFAULTS
 
     AFTER FIELD apa15
         IF cl_null(l_apa.apa15) THEN NEXT FIELD apa15 END IF
         SELECT gec03,gec031,gec04,gec06,gec08,gecacti
           INTO l_gec03,l_gec031,l_gec04,l_gec06,l_gec08,l_gecacti FROM gec_file
          WHERE gec01 = l_apa.apa15 AND gec011='1'  #進項
         LET g_errno = ' '
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'
              WHEN l_gecacti = 'N'     LET g_errno = '9028'
              WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
         END CASE
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(l_apa.apa15,g_errno,0) NEXT FIELD apa15
         END IF
         LET l_apa.apa16  = l_gec04
         LET l_apa.apa52  = l_gec03
         IF g_aza.aza63 = 'Y' THEN
            LET l_apa.apa521  = l_gec031
         END IF
         LET l_apa.apa171 = l_gec08
         LET l_apa.apa172 = l_gec06
         DISPLAY BY NAME l_apa.apa16
 
     AFTER FIELD apa16
         IF cl_null(l_apa.apa16) OR l_apa.apa16<0 THEN NEXT FIELD apa16 END IF
 
     AFTER FIELD apa36
         IF cl_null(l_apa.apa36) THEN
            CALL cl_err('apa36 is null ','aap-099',0) NEXT FIELD apa36
         END IF
         CALL t820_apa36(l_apa.apa36)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(l_apa.apa36,g_errno,0)
            NEXT FIELD apa36
         END IF
 
     AFTER FIELD l_date
         IF cl_null(l_date) THEN NEXT FIELD l_date END IF
 
     AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(l_apa.apa15) THEN NEXT FIELD apa15 END IF
         IF cl_null(l_date) THEN NEXT FIELD l_date END IF
 
 
        ON ACTION controlp
            CASE
              WHEN INFIELD(apa15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gec"
                 LET g_qryparam.default1 = l_apa.apa15
                 LET g_qryparam.arg1 = '1'
                 CALL cl_create_qry() RETURNING l_apa.apa15
                 DISPLAY BY NAME l_apa.apa15
                 NEXT FIELD apa15
              WHEN INFIELD(apa36)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_apr"
                 LET g_qryparam.default1 = l_apa.apa36
                 CALL cl_create_qry() RETURNING l_apa.apa36
                 DISPLAY BY NAME l_apa.apa36
                 NEXT FIELD apa36
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
    CLOSE WINDOW t820_w_w
    IF INT_FLAG THEN LET g_success='N' RETURN END IF
 
   #SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=g_alh.alh05        #No.MOD-B80312 mark
    SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=g_alh.alh06        #No.MOD-B80312 add
    SELECT gen03 INTO l_gen03 FROM gen_file WHERE gen01=g_user
    LET l_alg02 = ''   #MOD-610072
    SELECT nma02 INTO l_alg02 FROM nma_file WHERE nma01=g_alh.alh06
    IF cl_null(l_alg02) THEN
       SELECT pmc03 INTO l_alg02 FROM pmc_file
         WHERE pmc01 = g_alh.alh06
    END IF
   #FUN-A60056--mod--str--
   #DECLARE t820_c_w1 CURSOR FOR
   #  SELECT pmm20 FROM alk_file,ale_file,pmm_file
   #   WHERE alk03=g_alh.alh03 AND alk01=ale01 AND pmm01=ale14
   #     AND pmm18 !='X'
   #OPEN t820_c_w1
   #FETCH t820_c_w1 INTO l_pmm20
   #CLOSE t820_c_w1
    SELECT alk97 INTO l_alk97 FROM alk_file
     WHERE alk01 = g_alh.alh30
    LET g_sql = "SELECT pmm20 FROM alk_file,ale_file,",
                 cl_get_target_table(l_alk97,'pmm_file'),
                " WHERE alk03='",g_alh.alh03,"'",
                "   AND alk01=ale01 AND pmm01=ale14",
                "   AND pmm18 !='X'",
                "   AND alkfirm <> 'X' "  #CHI-C80041
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,l_alk97) RETURNING g_sql
    PREPARE sel_pmm20 FROM g_sql
    EXECUTE sel_pmm20 INTO l_pmm20 
   #FUN-A60056--mod--end
    IF cl_null(l_pmm20) THEN LET l_pmm20=g_alh.alh10 END IF
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_alh.alh11  #MOD-C20121 add
    LET l_apa.apa00 = '12'               #帳款性質
    LET l_apa.apa01 = g_alh.alh01        #帳款編號
    LET l_no=l_apa.apa01                 #No.+204
    LET l_apa.apa02 = g_alh.alh021       #帳款日期(到單日期)
    LET l_apa.apa09 = g_alh.alh021       #發票日期
    LET l_apa.apa11 = l_pmm20            #付款方式
    LET l_apa.apa05 = g_alh.alh06        #請款廠商
    LET l_apa.apa06 = g_alh.alh06        #付款廠商
   #LET l_apa.apa07 = l_alg02            #簡稱        #No.MOD-B80312 mark
    LET l_apa.apa07 = l_pmc03            #簡稱        #No.MOD-B80312 add
    CALL s_paydate('a','',l_apa.apa09,l_apa.apa02,l_apa.apa11, l_apa.apa06)
                   RETURNING l_paydate,l_apa.apa64,l_apa.apa24
    IF NOT cl_null(g_errno) THEN
       CALL cl_err(l_apa.apa11,g_errno,1)
       LET g_success='N'
    END IF
    LET l_apa.apa12 = l_paydate          #應付款日
 
    LET l_apa.apa08 = ' '                #發票
    LET l_apa.apa13 = g_alh.alh11        #幣別
    LET l_apa.apa14 = g_alh.alh15        #匯率
    LET l_apa.apa72 = l_apa.apa14        #bug no:A059
    LET l_apa.apa17 = '1'                #抵扣區分
    LET l_apa.apa20 = 0                  #原幣留置金額
    LET l_apa.apa21 = g_user             #人員
   #LET l_apa.apa22 = l_gen03            #部門         #MOD-BC0246 mark
    LET l_apa.apa22 = g_alh.alh04        #部門         #MOD-BC0246
    LET l_apa.apa25 = ' '                #memo
    LET l_apa.apa31f= cl_digcut(g_alh.alh14,t_azi04)   #NO.CHI-6A0004
    LET l_apa.apa32f= 0
    LET l_apa.apa33f= 0
    LET l_apa.apa34f= cl_digcut(g_alh.alh14,t_azi04)   #NO.CHI-6A0004
    LET l_apa.apa35f= 0                                #MOD-BA0144 mark #MOD-C30034 remark
   #LET l_apa.apa35f= l_apa.apa34f                     #MOD-BA0144 add #MOD-C30034 mark
    LET l_apa.apa31 = cl_digcut(g_alh.alh16,g_azi04)
    LET l_apa.apa32 = 0
    LET l_apa.apa33 = 0
    LET l_apa.apa34 = cl_digcut(g_alh.alh16,g_azi04)
    LET l_apa.apa35 = 0                                #MOD-BA0144 mark #MOD-C30034 remark
   #LET l_apa.apa35 = l_apa.apa34                      #MOD-BA0144 add #MOD-C30034 mark
    CALL t820_comp_oox(l_apa.apa01) RETURNING g_net
    LET l_apa.apa73 = l_apa.apa34 - l_apa.apa35 + g_net      #A059
    LET l_apa.apa41 = 'Y'
    LET l_apa.apa42 = 'N'
    LET l_apa.apa43 = ' '
    LET l_apa.apa44 = g_alh.alh72   #MOD-610073
    LET l_apa.apa51 = g_alh.alh41    #借方科目
    LET l_apa.apa54 = g_alh.alh42    #貸方科目
    IF g_aza.aza63 = 'Y' THEN
       LET l_apa.apa511= g_alh.alh411   #借方科目
       LET l_apa.apa541= g_alh.alh421   #貸方科目
    END IF
    LET l_apa.apa55 = '1'
    LET l_apa.apa56 = '0'
    LET l_apa.apa57f= cl_digcut(g_alh.alh14,t_azi04)   #NO.CHI-6A0004
    LET l_apa.apa57 = cl_digcut(g_alh.alh16,g_azi04)
    LET l_apa.apa60f= 0
    LET l_apa.apa60 = 0
    LET l_apa.apa61f= 0
    LET l_apa.apa61 = 0
    LET l_apa.apa65f= 0
    LET l_apa.apa65 = 0
    LET l_apa.apa74 = 'N'
    LET l_apa.apa75 = 'Y'
    LET l_apa.apaacti = 'Y'
    LET l_apa.apainpd = g_today
    LET l_apa.apauser = g_user
    LET l_apa.apagrup = g_grup
    LET l_apa.apadate = g_today
    LET l_apa.apa930=s_costcenter(l_apa.apa22) #FUN-670064
    SELECT ala97 INTO l_apa.apa100 FROM ala_file WHERE ala01=g_alh.alh03          #No.FUN-980017
    IF STATUS THEN LET l_apa.apa100=g_plant END IF
    LET l_apa.apaprno = 0   #MOD-830072
    LET l_apa.apalegal = g_legal #FUN-980001 add 
    CALL s_get_doc_no(l_apa.apa01) RETURNING g_t1
    SELECT apyvcode INTO l_apa.apa77  FROM apy_file WHERE apyslip = g_t1   
      IF cl_null(l_apa.apa77) THEN 
         LET l_apa.apa77 = g_apz.apz63  #FUN-970108 add
      END IF     
    LET l_apa.apaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_apa.apaorig = g_grup      #No.FUN-980030 10/01/04
    LET l_apa.apa79   = '0'         #No.FUN-A40003      #No.FUN-A60024
    INSERT INTO apa_file VALUES(l_apa.*)
    IF STATUS THEN
       CALL cl_err3("ins","apa_file",l_apa.apa01,"",SQLCA.sqlcode,"","p110_ins_apa(ckp#1):",1)  #No.FUN-660122
       LET g_success = 'N' RETURN
    ELSE
       INITIALIZE l_apc.* TO NULL
       LET l_apc.apc01 = l_apa.apa01
       LET l_apc.apc02 = 1
       LET l_apc.apc03 = l_apa.apa11
       LET l_apc.apc04 = l_apa.apa12
       LET l_apc.apc05 = l_apa.apa64
       LET l_apc.apc06 = l_apa.apa14
       LET l_apc.apc07 = l_apa.apa72
       LET l_apc.apc08 = l_apa.apa34f
       LET l_apc.apc09 = l_apa.apa34
       LET l_apc.apc10 = l_apa.apa35f
       LET l_apc.apc11 = l_apa.apa35
       LET l_apc.apc12 = l_apa.apa08
       LET l_apc.apc13 = l_apa.apa73
       LET l_apc.apc14 = l_apa.apa65f
       LET l_apc.apc15 = l_apa.apa65
       LET l_apc.apc16 = l_apa.apa20
       LET l_apc.apclegal = g_legal #FUN-980001 add
       INSERT INTO apc_file VALUES(l_apc.*)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","apc_file",l_apa.apa01,"1",SQLCA.sqlcode,"","ins apc_file",1)
          LET g_success = 'N'
       END IF
    END IF
   #MOD-CC0092 mark start ----- 
   #IF g_alh.alh30 IS NOT NULL THEN   #MOD-740517
   #   SELECT apa34,apa34f INTO l_apa34,l_apa34f FROM apa_file
   #     WHERE apa01=g_alh.alh30
   #   IF cl_null(l_apa34) THEN LET l_apa34 = 0 END IF
   #   IF cl_null(l_apa34f) THEN LET l_apa34f = 0 END IF
   #   CALL t820_comp_oox(g_alh.alh30) RETURNING g_net  #CHI-890017 add
   #   UPDATE apa_file SET apa35f=l_apa34f,
   #                       apa35 =l_apa34
   #                      ,apa73 =apa34-l_apa34+g_net   #CHI-890017 add
   #      WHERE apa01= g_alh.alh30

   #   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
   #      CALL cl_err3("upd","apa_file",g_alh.alh30,"",STATUS,"","",1) 
   #      LET g_success = 'N' RETURN
   #   END IF
   #   SELECT apc08,apc09 INTO l_apc08,l_apc09 FROM apc_file
   #    WHERE apc01=g_alh.alh30
   #   IF cl_null(l_apc08) THEN LET l_apc08 = 0 END IF
   #   IF cl_null(l_apc09) THEN LET l_apc09 = 0 END IF
   #   UPDATE apc_file SET apc10=l_apc08,
   #                       apc11=l_apc09,
   #                       apc13=apc09-l_apc09+g_net
   #    WHERE apc01= g_alh.alh30 AND apc02=1
   #   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
   #      CALL cl_err3("upd","apc_file",g_alh.alh30,"",STATUS,"","",1)
   #      LET g_success = 'N' RETURN
   #   END IF
   #END IF   #MOD-740517
   #MOD-CC0092 mark end   -----
END FUNCTION
 
#FUN-B40092-----mark-----str
#FUNCTION t820_out()
#   DEFINE
#       l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#       l_alh           RECORD LIKE alh_file.*
#   DEFINE  l_pmc03_1   LIKE pmc_file.pmc03
#   DEFINE  l_pmc03_2   LIKE pmc_file.pmc03
#   DEFINE  l_no        LIKE apa_file.apa01
#   DEFINE  
#          l_sql       STRING      #NO.FUN-910082
#   DEFINE  sr RECORD   LIKE alh_file.*
# 
#   CALL cl_del_data(l_table)  #No.FUN-710086
# 
#   IF g_wc IS NULL THEN
#      LET g_wc = "alh01='",g_alh.alh01,"'"
#   END IF
#   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapt820'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 113 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
#   LET g_sql = "SELECT * FROM alh_file WHERE ",g_wc
#   PREPARE t820_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t820_co CURSOR FOR t820_p1
# 
#
#   FOREACH t820_co INTO sr.*     #No.FUN-710086
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
# 
#       SELECT nne01 INTO l_no FROM nne_file
#        WHERE nne28=sr.alh01
#       SELECT pmc03 INTO l_pmc03_1 FROM pmc_file
#        WHERE pmc01 = sr.alh05
#       SELECT pmc03 INTO l_pmc03_2 FROM pmc_file
#        WHERE pmc01 = sr.alh06
# 
#       EXECUTE insert_prep USING sr.alh00,sr.alh021,sr.alh45,sr.alh01,sr.alh02,
#                                 sr.alh72,sr.alh10,sr.alh44,sr.alhfirm,l_no,
#                                 sr.alh52,l_pmc03_1,l_pmc03_2,sr.alh51,sr.alh75,
#                                 sr.alh03,sr.alh06,sr.alh11,sr.alh50,sr.alh07,
#                                 sr.alh12,sr.alh18,sr.alh08,sr.alh13,sr.alh05,
#                                 sr.alh09,sr.alh14,sr.alh04,sr.alh15,sr.alh16,
#                                 sr.alh19,sr.alh17,sr.alh76,sr.alh77,sr.alh74
# 
#   END FOREACH
# 
# 
#   CLOSE t820_co
#   ERROR ""
# 
#   LET g_pdate = g_today
#   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
#   CALL cl_prt_cs3('aapt820','aapt820',l_sql,'')
# 
#END FUNCTION
#FUN-B40092-----mark-----end
#FUN-B40092-----add------str
FUNCTION t820_out()
DEFINE l_cmd        LIKE type_file.chr1000, 
       l_wc         LIKE type_file.chr1000, 
       l_prtway     LIKE type_file.chr1
   CALL cl_wait()
 
    LET l_wc = "alh01='",g_alh.alh01,"'"
 
 #   SELECT zz22 INTO l_prtway FROM zz_file WHERE zz01 = 'aapr824'  #FUN-C30085 mark
    SELECT zz22 INTO l_prtway FROM zz_file WHERE zz01 = 'aapg824' #FUN-C30085 add 

  #  LET l_cmd='aapr824 "',  #FUN-C30085 mark
    LET l_cmd='aapg824 "',  #FUN-C30085 add
        g_today CLIPPED,'" "" "',g_lang CLIPPED,'" "Y" "',l_prtway CLIPPED,'" "1" "',l_wc CLIPPED,'" "" "" "" "" '
   CALL cl_cmdrun(l_cmd)
 
   ERROR ' ' 
END FUNCTION
#FUN-B40092-----add------end
 

 
FUNCTION t820_apa36(l_apa36)
    DEFINE l_apa36     LIKE apa_file.apa36
    DEFINE l_apr02     LIKE apr_file.apr02
    DEFINE l_apracti   LIKE apr_file.apracti
 
    LET g_errno = ' '
    SELECT apr02,apracti INTO l_apr02,l_apracti
      FROM apr_file WHERE apr01 = l_apa36
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-044'
         WHEN l_apracti = 'N'     LET g_errno = 'ams-106'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
END FUNCTION
 
FUNCTION t820_del_ap12()
    DEFINE l_apa35   LIKE apa_file.apa35
    DEFINE l_apaacti LIKE apa_file.apaacti
 
    LET g_errno=' '
    SELECT apa35,apaacti INTO l_apa35,l_apaacti FROM apa_file
     WHERE apa01=g_alh.alh01 AND apa00='12'
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-075'
         WHEN l_apa35 != 0         LET g_errno = 'aap-255'
         WHEN l_apaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    DELETE FROM apa_file WHERE apa01=g_alh.alh01 AND apa00='12'
    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err3("del","apa_file",g_alh.alh01,"",SQLCA.sqlcode,"","del apa:",1)  #No.FUN-660122
       LET g_errno='9051'
    END IF
    DELETE FROM apc_file WHERE apc01 = g_alh.alh01
    IF STATUS THEN
       CALL cl_err3("del","apc_file",g_alh.alh01,"",SQLCA.sqlcode,"","del apc:",1)  
       LET g_success = 'N'
       RETURN
    END IF
   #MOD-CC0092 mark start -----
   #IF g_alh.alh30 IS NOT NULL THEN   
   #   CALL t820_comp_oox(g_alh.alh30) RETURNING g_net  #CHI-890017 add
   #   UPDATE apa_file SET apa35f=0,
   #                       apa35 =0
   #                      ,apa73 =apa34+g_net           #CHI-890017 add
   #      WHERE apa01= g_alh.alh30
   #   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
   #      CALL cl_err3("upd","apa_file",g_alh.alh30,"",STATUS,"","upd apa_file",1) 
   #      LET g_errno = STATUS
   #   END IF
   #   UPDATE apc_file SET apc10=0,
   #                       apc11=0,
   #                       apc13=apc09+g_net
   #    WHERE apc01= g_alh.alh30 AND apc02=1
   #   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
   #      CALL cl_err3("upd","apc_file",g_alh.alh30,"",STATUS,"","upd apc_file",1)
   #      LET g_errno = STATUS
   #   END IF
   #END IF
   #MOD-CC0092 mark end   -----
END FUNCTION
 
FUNCTION t820_showno()
    IF g_alh.alh44='1' THEN
       SELECT apa01 INTO l_no FROM apa_file
        WHERE apa00='12' AND apa01=g_alh.alh01
       IF STATUS THEN LET l_no=' ' END IF
    ELSE
       SELECT nne01 INTO l_no FROM nne_file WHERE nne28=g_alh.alh01
       IF STATUS THEN LET l_no=' ' END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    END IF
END FUNCTION
 
FUNCTION t820_showalh44()
    DEFINE l_sta   LIKE type_file.chr8        # No.FUN-690028 VARCHAR(08)
 
    CASE g_alh.alh44
         WHEN '1' CALL cl_getmsg('aap-312',g_lang) RETURNING l_sta
         WHEN '2' CALL cl_getmsg('aap-313',g_lang) RETURNING l_sta
         OTHERWISE LET l_sta=' '
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    END CASE
    DISPLAY l_sta TO FORMONLY.alh44_a
END FUNCTION
 
FUNCTION t820_comp_oox(p_apv03)
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apv03   LIKE apv_file.apv03
DEFINE l_apa00   LIKE apa_file.apa00
 
    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apv03
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
FUNCTION t820_carry_voucher()
  DEFINE l_apygslp    LIKE apy_file.apygslp
  DEFINE l_apygslp1   LIKE apy_file.apygslp1  #No.FUN-680029
  DEFINE li_result    LIKE type_file.num5     #No.FUN-690028 SMALLINT
  DEFINE g_t1         LIKE oay_file.oayslip  #No.FUN-690028 VARCHAR(5)
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
    #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_apz.apz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_alh.alh72,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_apz.apz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre2 FROM l_sql
    DECLARE aba_cs2 CURSOR FOR aba_pre2
    OPEN aba_cs2
    FETCH aba_cs2 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_alh.alh72,'aap-991',1)
       RETURN
    END IF
 
    #開窗作業
    LET g_plant_new= g_apz.apz02p
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
    LET g_plant_gl =g_apz.apz02p  #No.FUN-980059
 
    OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("axrt200_p")
     
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("gl_no1",FALSE)
    END IF
     
    INPUT l_apygslp,l_apygslp1 WITHOUT DEFAULTS FROM FORMONLY.gl_no,FORMONLY.gl_no1  #No.FUN-680029
    
       AFTER FIELD gl_no
          CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_plant_gl)      #TQC-9B0162
                RETURNING li_result,l_apygslp
          IF (NOT li_result) THEN
             NEXT FIELD gl_no
          END IF
 
       AFTER FIELD gl_no1
          CALL s_check_no("agl",l_apygslp1,"","1","aac_file","aac01",g_plant_gl)     #TQC-9B0162
                RETURNING li_result,l_apygslp1
          IF (NOT li_result) THEN
             NEXT FIELD gl_no1
          END IF
    
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT 
          END IF
          IF cl_null(l_apygslp) THEN
             CALL cl_err('','9033',0)
             NEXT FIELD gl_no  
          END IF
 
          IF cl_null(l_apygslp1) AND g_aza.aza63 = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD gl_no1 
          END IF
    
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON ACTION CONTROLP
          IF INFIELD(gl_no) THEN
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp,'1',' ',' ','AGL')  #No.FUN-980059
             RETURNING l_apygslp
             DISPLAY l_apygslp TO FORMONLY.gl_no
             NEXT FIELD gl_no
          END IF
 
          IF INFIELD(gl_no1) THEN
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp1,'1',' ',' ','AGL')   #No.FUN-980059
             RETURNING l_apygslp1
             DISPLAY l_apygslp1 TO FORMONLY.gl_no1
             NEXT FIELD gl_no1
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
 
    IF INT_FLAG = 1 THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    IF cl_null(l_apygslp) OR (cl_null(l_apygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680029
       CALL cl_err(g_alh.alh01,'axr-070',1)
       RETURN
    END IF
    CALL s_get_doc_no(l_apygslp) RETURNING g_t1
    LET g_wc_gl = 'npp01 = "',g_alh.alh01,'" AND npp011 = 2'
    LET g_str="aapp800 '",g_wc_gl CLIPPED,"' '",g_plant,"' '2' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_t1,"' '",g_alh.alh021,"' 'Y' '0' 'Y' '",g_apz.apz02c,"' '",l_apygslp1,"'"  #No.FUN-680029
    CALL cl_cmdrun_wait(g_str)
    SELECT alh72 INTO g_alh.alh72 FROM alh_file
     WHERE alh01 = g_alh.alh01
    DISPLAY BY NAME g_alh.alh72
    
END FUNCTION
 
FUNCTION t820_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_apz.apz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_alh.alh72,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_apz.apz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_alh.alh72,'axr-071',1)
       RETURN
    END IF
    LET g_str="aapp810 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_alh.alh72,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT alh72 INTO g_alh.alh72 FROM alh_file
     WHERE alh01 = g_alh.alh01
    DISPLAY BY NAME g_alh.alh72
END FUNCTION
 
FUNCTION t820_set_npq05(p_dept,p_alh930)
DEFINE p_dept   LIKE gem_file.gem01,
       p_alh930 LIKE alh_file.alh930
       
   IF g_aaz.aaz90='Y' THEN
      RETURN p_alh930
   ELSE
      RETURN p_dept
   END IF
END FUNCTION
#No.FUN-9C0077 程式精簡

#No.FUN-B10050  --Begin
FUNCTION t820_aag01(p_aag00,p_aag01,p_type)
    DEFINE p_aag00      LIKE aag_file.aag00
    DEFINE p_aag01      LIKE aag_file.aag01
    DEFINE p_type       LIKE type_file.chr1
    DEFINE l_aag02      LIKE aag_file.aag02
    DEFINE l_aag03      LIKE aag_file.aag03
    DEFINE l_aag07      LIKE aag_file.aag07
    DEFINE l_acti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aag03,aag07,aagacti
      INTO l_aag02,l_aag03,l_aag07,l_acti
      FROM aag_file
     WHERE aag00 = p_aag00
       AND aag01 = p_aag01

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-021'
         WHEN l_acti  ='N'         LET g_errno = '9028'
         WHEN l_aag07  = '1'       LET g_errno = 'agl-015'
         WHEN l_aag03 != '2'       LET g_errno = 'agl-201'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF cl_null(g_errno) THEN
       CASE p_type
            WHEN '1'  DISPLAY l_aag02 TO FORMONLY.aag02_1
            WHEN '2'  DISPLAY l_aag02 TO FORMONLY.aag02_2
            WHEN '3'  DISPLAY l_aag02 TO FORMONLY.aag02_3
            WHEN '4'  DISPLAY l_aag02 TO FORMONLY.aag02_4
            WHEN '5'  DISPLAY l_aag02 TO FORMONLY.aag02_5
            WHEN '6'  DISPLAY l_aag02 TO FORMONLY.aag02_6
       END CASE
    END IF
END FUNCTION
#No.FUN-B10050  --End
#FUN-D10065
