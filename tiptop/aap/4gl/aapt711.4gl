# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: aapt711.4gl
# Descriptions...: 信用狀開狀付款作業
# Date & Author..: 95/11/10 By Roger
# Modify.........: 97/04/22 By Star [將apc_file 改為 npp_file,npq_file ]
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-490271 04/09/14 By Kitty 修改為當幣別與本國幣別相同時原幣金額=本幣金額
# Modify.........: No.MOD-4A0003 04/10/01 By ching 活存時,異動碼不可空白
# Modify.........: No.MOD-4A0043 04/10/05 By ching 銀存異動應有電腦編號
# Modify.........: No.FUN-4B0054 04/11/23 By ching add 匯率開窗 call s_rate
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-4C0040 04/12/14 By Smapmin 新增ala86付款日期欄位
# Modify.........: No.MOD-530563 05/03/26 By saki 做原幣跟本幣小數取位
# Modify.........: No.MOD-530821 05/03/29 By saki 付款方式改變需更新相關欄位
#                                                 per檔拿掉本幣支付匯率欄位,預設為1
# Modify.........: No:BUG-530818 05/04/11 By Nicola 回復MOD-530821拿掉的本幣支付匯率欄位
#                                                   未輸入開票單別，不可執行"開票產生"
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify ........: No.FUN-560002 05/06/03 By day  單據編號修改
# Modify.........: NO.MOD-420449 05/07/11 By Yiting key值可更改
# Modify.........: No.MOD-5A0258 05/10/20 By Smapmin 銀行日期(nme02)應default ala86(付款日)而非ala08(開狀日)
# Modify.........: No.TQC-5C0027 05/12/07 By Smapmin 分錄原幣為0時,幣別應為本國幣別,匯率應為1
# Modify.........: NO.FUN-5C0015 05/12/20 By alana
#                   call s_def_npq.4gl 抓取異動碼、摘要default值
# Modify.........: NO.MOD-5C0011 06/01/05 BY yiting 出帳匯率小數取位錯誤
# Modify.........: No.MOD-5C0125 06/01/20 By Smapmin 類別不可輸入
# Modify.........: No.MOD-620089 06/03/02 By Smapmin 會計日期改為付款日期
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: No.FUN-630106 06/04/03 By Smapmin FUNCTION t711_y_nme考慮多工廠的作法
# Modify.........: No.FUN-640239 06/04/25 By Smapmin CALL s_bankex2改為CALL s_bankex
# Modify.........: No.FUN-650006 06/05/03 By Smapmin 付款日期不可小於開狀日期
# Modify.........: No.TQC-660072 06/06/14 By Dido 補充TQC-630070
# Modify.........: No.FUN-660122 06/06/19 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-5C0011 06/06/22 By rainy 支存則nme12(參考單號是給開票單號),else給預購單號
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/07/31 By Rayven 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680019 06/08/08 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680029 06/08/23 By Rayven 新增多帳套功能
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hellen 本原幣取位修改
# Modify.........: No.FUN-6A0016 06/11/11 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-690015 06/12/01 By Smapmin 當開狀應攤金額為0時,可以直接確認.
# Modify.........: No.MOD-690058 06/12/08 By Smapmin 由於銀行類別為'1'時是不須寫入 nme_file 的,故修正為"當銀行類別為2時,就給nme12的值"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By wujie   網銀功能相關修改，nme新增欄位
# Modify.........: No.FUN-730064 07/04/02 By arman   會計科目加帳套
# Modify.........: No.MOD-740346 07/04/23 By Rayven 不使用網銀時不去判斷是否未轉
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-820161 08/02/26 By chenl   修正分錄底稿子函數傳入值錯誤。
# Modify.........: No.FUN-850003 08/05/05 By Smapmin 增加列印功能
# Modify.........: No.MOD-850050 08/05/09 By Sarah ala92的選項0:其他,改為3:其他(與nma28一致)
# Modify.........: No.FUN-850038 08/05/12 By TSD.sar2436 自定欄位功能修改
# Modify.........: No.FUN-840242 08/06/25 By xiaofeizhu 報表輸出有aapr710改為aapr711
# Modify.........: No.MOD-8C0113 08/12/11 By Sarah t711_g_gl_2()段,產生差異科目時應抓aps_file指定的科目
# Modify.........: No.MOD-970223 09/07/23 By mike 選原幣付款時, 本幣 金額沒有依原幣金額*匯率 ( 依幣別小數位取位)                    
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alaplant該為ala97 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: NO.FUN-990031 09/10/26 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下;开放营运中心可录
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.TQC-A10060 10/01/12 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No.TQC-A50001 10/05/05 By Dido ala85 應 ala80 = '1' 才需要給預設值 
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.FUN-9A0036 10/07/26 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/26 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/26 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-AA0087 11/01/26 By chenmoyan 異動碼設定類型改善
# Modify.........: No.MOD-B30295 11/03/14 By Dido 若無支付保證金則分錄的幣別與匯率應為本幣與1
# Modify.........: No.MOD-B30391 11/03/17 By lixia 錄底稿的支出"開狀保證金"項次裡的"匯率"不等於單頭"出帳匯率"
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: NO.FUN-B30211 11/03.30 By yangtingting 離開MAIN時沒有 add cl_used(1)
# Modify.........: NO.TQC-B40142 11/04/18 By yinhy 已產生票據的資料，应不可更改"開票單號"
# Modify.........: No.MOD-B40162 11/04/18 By Dido 結案不可修改 
# Modify.........: No.TQC-B50008 11/05/04 By yinhy 採用原幣支付保證金,本幣保證金欄位應該灰掉不讓輸入值
# Modify.........: No:FUN-B40056 11/05/10 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:CHI-B40043 11/04/21 By Sarah 若aapt720沒有輸入保證金、手續費、郵電費但aapt711有輸入,
#                                                  則分錄產生的差額科目應為aps46;反之則產生的差額科目應為aps42/aps43
# Modify.........: No:MOD-B50095 11/05/11 By Dido 若為費用科目則分錄原幣金額應與本幣金額相同 
# Modify.........: No:FUN-B50066 11/05/18 By yinhy 增加外幣支票開票功能
# Modify.........: No:MOD-B60223 11/06/25 By Sarah 確認時,若沒輸入支票欄位則卡銀存異動碼需有值
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B90062 11/09/14 By wujie 产生nme_file时同时产生tic_file
# Modify.........: No.MOD-BB0139 11/11/14 By Dido 寫入 nme12 給予預設值  
# Modify.........: No.MOD-BC0106 11/12/15 By Polly 增加判斷，當ala86為null時，才給予ala77預設值 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30599 12/03/12 by JinJJ 增加银行简称nma02_1,nma02_2由银行编号ala81，ala91自动带出
# Modify.........: No:MOD-C30680 12/03/14 By wangrr 執行開票作業時nmd08賦值ala05,nmd23賦值nms15
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:MOD-C80022 12/08/03 By Polly 銀行異動碼開窗排除「存提別1」的資料
# Modify.........: No:MOD-CB0038 12/11/06 by Polly 調整SQL語法，將ORDER BY前增加控白；調整l_sql型態
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1 LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(20),
    g_argv2 STRING,                #TQC-630070      #執行功能
    g_ala   RECORD LIKE ala_file.*,
    g_nme   RECORD LIKE nme_file.*,
    g_nmd   RECORD LIKE nmd_file.*,
    g_ala_t RECORD LIKE ala_file.*,
    g_ala01_t LIKE ala_file.ala01,
    g_t1    LIKE oay_file.oayslip,                 #No.FUN-550030  #No.FUN-690028 VARCHAR(5)
    g_before_input_done LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    l_cnt   LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    g_dbs_gl  LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    g_plant_gl  LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),  #No.FUN-980059
    g_dbs_nm  LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    gl_no_b,gl_no_e  LIKE abb_file.abb01,  # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
    tot              LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
     g_wc,g_sql          string  #No:FUN-580092 HCN
DEFINE g_system         LIKE type_file.chr2        # No.FUN-690028  VARCHAR(2)
DEFINE g_zero           LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_N              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_str           STRING     #No.FUN-670060 
DEFINE   g_wc_gl         STRING     #No.FUN-670060
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   g_void          LIKE type_file.chr1    # No.FUN-690028 VARCHAR(01)
DEFINE   g_bookno1,g_bookno2 LIKE aza_file.aza81#No.FUN-9A0036
DEFINE   g_bookno3       LIKE aza_file.aza81    #No.FUN-D40118   Add
DEFIne   g_flag          LIKE type_file.chr1    #FUN-9A0036
DEFINE   g_npq25         LIKE npq_file.npq25    #FUN-9A0036
DEFINE   g_azi04_2       LIKE azi_file.azi04    #FUN-A40067


MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B30211 
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)   #執行功能   #TQC-630070
    LET g_plant_new=g_apz.apz04p CALL s_getdbs() LET g_dbs_nm=g_dbs_new
    IF cl_null(g_dbs_nm) THEN LET g_dbs_nm = NULL END IF
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET g_dbs_gl=g_dbs_new
    IF cl_null(g_dbs_gl) THEN LET g_dbs_gl = NULL END IF
    INITIALIZE g_ala.* TO NULL
    INITIALIZE g_ala_t.* TO NULL
 
     LET g_forupd_sql = "SELECT * FROM ala_file WHERE ala01 = ? FOR UPDATE "
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
     DECLARE t711_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 14
    OPEN WINDOW t711_w AT p_row,p_col WITH FORM "aap/42f/aapt711"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("ala04",TRUE)
    END IF
    CALL cl_set_comp_visible("ala930,gem02b",g_aaz.aaz90='Y')
 
   # 先以g_argv2判斷直接執行哪種功能：
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t711_q()
            END IF
         OTHERWISE          #TQC-660072
            CALL t711_q()   #TQC-660072
      END CASE
   END IF
 
      LET g_action_choice=""
      CALL t711_menu()
 
    CLOSE WINDOW t711_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION t711_cs()
    CLEAR FORM
    IF cl_null(g_argv1) THEN
   INITIALIZE g_ala.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                ala97,ala01,ala23,ala80,                                    #No.FUN-980017
                 ala74   ,ala08,ala20,ala51,ala86,ala04,ala930,  #MOD-4C0040 #FUN-680019
                ala78   ,alafirm,alaclos,ala21,
                alaud01,alaud02,alaud03,alaud04,alaud05,
                alaud06,alaud07,alaud08,alaud09,alaud10,
                alaud11,alaud12,alaud13,alaud14,alaud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
         ON ACTION CONTROLP     #85-10-15
            CASE
               WHEN INFIELD(ala01) # APO
                  CALL q_ala(TRUE,TRUE,g_ala.ala01)
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala01
               WHEN INFIELD(ala81) #外幣支付銀行
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_nma"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ala.ala81
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ala81
                  NEXT FIELD ala81
               WHEN INFIELD(ala91) #本幣支付銀行
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_nma"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ala.ala91
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ala91
                  NEXT FIELD ala91
               WHEN INFIELD(ala96) #銀行異動碼
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_nmc"             #MOD-C80022 mark
                  LET g_qryparam.form ="q_nmc002"          #MOD-C80022 add
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ala.ala96
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ala96
                  NEXT FIELD ala96
               WHEN INFIELD(ala931) #開票單別
                  LET g_t1=s_get_doc_no(g_ala.ala931)
                  LET g_sys = 'ANM'
                  CALL q_nmy(TRUE,FALSE,g_t1,'1','AAP') RETURNING g_t1  #TQC-670008
                  LET g_ala.ala931= g_t1
                  DISPLAY BY NAME g_ala.ala931
                  NEXT FIELD ala931
               #No.FUN-B50066  --Begin
               WHEN INFIELD(ala12) #開票單別
                  LET g_t1=s_get_doc_no(g_ala.ala12)
                  LET g_sys = 'ANM'
                  CALL q_nmy(TRUE,FALSE,g_t1,'1','AAP') RETURNING g_t1  #TQC-670008
                  LET g_ala.ala12= g_t1
                  DISPLAY BY NAME g_ala.ala12
                  NEXT FIELD ala12
               #No.FUN-B50066  --End
               WHEN INFIELD(ala04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala04
                  NEXT FIELD ala04
               WHEN INFIELD(ala930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala930
                  NEXT FIELD ala930
               OTHERWISE
                  EXIT CASE
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
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup') #FUN-980030
 
       ELSE LET g_wc=" ala01='",g_argv1,"'"
    END IF
    LET g_sql="SELECT ala01 FROM ala_file ", # 組合出 SQL 指令
       #" WHERE ",g_wc CLIPPED, "ORDER BY ala01"     #MOD-CB0038 mark
              " WHERE ",g_wc CLIPPED,                #MOD-CB0038 add
              " ORDER BY ala01"                      #MOD-CB0038 add
    PREPARE t711_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t711_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t711_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ala_file WHERE ",g_wc CLIPPED
    PREPARE t711_precount FROM g_sql
    DECLARE t711_count CURSOR FOR t711_precount
END FUNCTION
 
FUNCTION t711_menu()
    DEFINE l_cmd        LIKE type_file.chr1000    #FUN-850003
    DEFINE l_wc         STRING   #FUN-850003
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
            IF g_aza.aza63 = 'N' THEN
               CALL cl_set_act_visible("maintain_entry_sheet_2",FALSE)
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t711_q()
            END IF
        ON ACTION next
            CALL t711_fetch('N')
        ON ACTION previous
            CALL t711_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t711_u()
            END IF
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              LET l_wc = 'ala01="',g_ala.ala01,'"'
             # LET l_cmd = "aapr711 '",g_today CLIPPED,"' ''",                #FUN-840242 aapr710-->aapr711    #FUN-C30085 mark    
               LET l_cmd = "aapg711 '",g_today CLIPPED,"' ''",   #FUN-C30085 add 
                         " '",g_lang CLIPPED,"' 'Y' '' '1' '",l_wc CLIPPED,"'"
              DISPLAY l_cmd 
              CALL cl_cmdrun(l_cmd)
           END IF
        ON ACTION gen_check
            #CALL t711_g_nmd(g_ala.ala91,1,g_ala.ala95,g_ala.ala95) #No.FUN-B50066
            CALL t711_g_nmd()                                       #No.FUN-B50066
        ON ACTION gen_entry_sheet
           CALL t711_g_gl(g_ala.ala01,5,0)
        ON ACTION maintain_entry_sheet
           CALL s_fsgl('LC',5,g_ala.ala01,0,g_apz.apz02b,0,g_ala.ala78,'0',g_apz.apz02p) #No.FUN-680029 add '0',g_apz.apz02p
           CALL cl_navigator_setting( g_curs_index, g_row_count )  #No.FUN-680029
        ON ACTION maintain_entry_sheet_2
           CALL s_fsgl('LC',5,g_ala.ala01,0,g_apz.apz02c,0,g_ala.ala78,'1',g_apz.apz02p)
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION carry_voucher
           IF g_ala.ala78 = 'Y' THEN 
              CALL t711_carry_voucher()  
           ELSE 
              CALL cl_err('','atm-402',1)
           END IF  
        ON ACTION undo_carry_voucher 
           IF g_ala.ala78 = 'Y' THEN 
              CALL t711_undo_carry_voucher() 
           ELSE 
              CALL cl_err('','atm-403',1)
           END IF  
 
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t711_y()
               IF g_ala.alafirm = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_ala.ala78,"","",g_ala.alaclos,g_void,"")
            END IF
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t711_z()
               IF g_ala.alafirm = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_ala.ala78,"","",g_ala.alaclos,g_void,"")
            END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           IF g_ala.alafirm = 'X' THEN
              LET g_void = 'Y'
           ELSE
              LET g_void = 'N'
           END IF
           CALL cl_set_field_pic(g_ala.ala78,"","",g_ala.alaclos,g_void,"")
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL t711_fetch('/')
        ON ACTION first
            CALL t711_fetch('F')
        ON ACTION last
            CALL t711_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ala.ala01 IS NOT NULL THEN
                  LET g_doc.column1 = "ala01"
                  LET g_doc.value1 = g_ala.ala01
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
    CLOSE t711_cs
END FUNCTION
 
 
FUNCTION t711_i(p_cmd)
    DEFINE   li_result   LIKE type_file.num5      #No.FUN-560002  #No.FUN-690028 SMALLINT
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        g_t1            LIKE oay_file.oayslip,        #No.FUN-550030  #No.FUN-690028 VARCHAR(5)
        l_flag          LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_nma10            LIKE nma_file.nma10, #FUN-660117
        l_nnp06            LIKE nnp_file.nnp06
 
    INPUT BY NAME
         g_ala.ala97,    #FUN-990031
         g_ala.ala01, #MOD-420449
         g_ala.ala80,g_ala.ala86,g_ala.ala04,g_ala.ala930,g_ala.ala74,g_ala.ala81,g_ala.ala82,g_ala.ala84,  #MOD-4C0040 #FUN-680019
         g_ala.ala34,g_ala.ala85,g_ala.ala91,g_ala.ala92,g_ala.ala94,   # No.MOD-530821
        g_ala.ala951,g_ala.ala952,g_ala.ala953,g_ala.ala95,
        g_ala.ala96,g_ala.ala93,g_ala.ala931,g_ala.ala76,g_ala.ala932,
        g_ala.ala83,
        g_ala.alaud01,g_ala.alaud02,g_ala.alaud03,g_ala.alaud04,
        g_ala.alaud05,g_ala.alaud06,g_ala.alaud07,g_ala.alaud08,
        g_ala.alaud09,g_ala.alaud10,g_ala.alaud11,g_ala.alaud12,
        g_ala.alaud13,g_ala.alaud14,g_ala.alaud15,
        g_ala.ala12,g_ala.ala13,g_ala.ala14        #No.FUN-B50066
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t711_set_entry(p_cmd)
         CALL t711_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         
       AFTER FIELD ala97
          IF NOT cl_null(g_ala.ala97) THEN
             SELECT count(*) INTO l_n FROM azw_file WHERE azw01 = g_ala.ala97
                AND azw02 = g_legal
             IF l_n = 0 THEN
               CALL cl_err('sel_azw','agl-171',0)
               NEXT FIELD ala97
             END IF
          END IF

      AFTER FIELD ala34
        #-TQC-A50001-add-
         IF g_ala.ala80 = '1' THEN 
            LET g_ala.ala85=g_ala.ala34*g_ala.ala84 #MOD-970223    
         ELSE
            LET g_ala.ala85=0    
         END IF 
        #-TQC-A50001-end-
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_ala.ala20   #NO.CHI-6A0004
         LET g_ala.ala34 = cl_digcut(g_ala.ala34,t_azi04)   #NO.CHI-6A0004
         DISPLAY g_ala.ala34 TO ala34
         LET g_ala.ala85 = cl_digcut(g_ala.ala85,g_azi04) #MOD-970223                                                               
         DISPLAY BY NAME g_ala.ala85 #MOD-970223           
 
        BEFORE FIELD ala80
          CALL t711_set_entry(p_cmd)
 
        AFTER FIELD ala80
           IF g_ala.ala80 IS NOT NULL THEN
              IF g_ala.ala80 NOT MATCHES "[01]" THEN
                 NEXT FIELD ala80
              END IF
              IF (g_ala_t.ala80 != g_ala.ala80) AND (g_ala.ala80='0') THEN
                 LET g_ala.ala81='' LET g_ala.ala82='' LET g_ala.ala83=NULL
                 LET g_ala.ala84='' LET g_ala.ala85=0
                 DISPLAY BY NAME g_ala.ala81, g_ala.ala82, g_ala.ala83,
                                 g_ala.ala84, g_ala.ala85
                 LET tot = g_ala.ala85 + g_ala.ala95
                 LET tot = cl_digcut(tot,g_azi04)   #NO.CHI-6A0004
                 DISPLAY BY NAME tot
              END IF

           END IF
           CALL t711_set_no_entry(p_cmd)
 
        BEFORE FIELD ala96
            IF cl_null(g_ala.ala96) THEN
               LET g_ala.ala96 = g_apz.apz58
               DISPLAY BY NAME g_ala.ala96
            END IF
             CALL t711_set_entry(p_cmd) #MOD-4A0003
 
        AFTER FIELD ala96
            IF NOT cl_null(g_ala.ala96) THEN
               CALL t711_ala96(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ala.ala96,g_errno,0)
                  LET g_ala.ala96 = g_ala_t.ala96
                  DISPLAY BY NAME g_ala.ala96
                  NEXT FIELD ala96
               END IF
            END IF
             CALL t711_set_no_entry(p_cmd) #MOD-4A0003
        #No.FUN-B50066  --Begin
        BEFORE FIELD ala81
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM nmd_file
            WHERE nmd01 = g_ala.ala12
            AND nmd30 <> 'X'
          IF l_n >0 THEN
            CALL cl_set_comp_entry("ala12,ala13,ala14",FALSE)
          END IF
       
        #No.FUN-B50066  --Begin
        AFTER FIELD ala81
          IF g_ala.ala81 IS NOT NULL THEN  
            SELECT nma28 INTO g_ala.ala82
              FROM nma_file WHERE nma01=g_ala.ala81
            IF STATUS THEN 
              CALL cl_err('sel nma:',STATUS,0)
              CALL cl_err3("sel","nma_file",g_ala.ala81,"",STATUS,"","sel nma:",1)  #No.FUN-660122
              NEXT FIELD ala81 
            END IF            
            DISPLAY BY NAME g_ala.ala82
            CALL t711_ala81() #MOD-C30599
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM nmd_file
             WHERE nmd01 = g_ala.ala12
               AND nmd30 <> 'X'              
            IF g_ala.ala82 MATCHES '[23]' OR l_n > 0 THEN
               CALL cl_set_comp_entry("ala12,ala13,ala14",FALSE)
            ELSE 
           	   CALL cl_set_comp_entry("ala12,ala13,ala14",TRUE)
            END IF
          END IF
          #No.FUN-B50066  --End

        AFTER FIELD ala82
          IF g_ala.ala82 IS NOT NULL THEN
             SELECT COUNT(*) INTO l_n FROM nma_file
              WHERE nma01 = g_ala.ala81 AND nma28 = g_ala.ala82
             IF l_n <= 0 THEN
                NEXT FIELD ala82
             END IF             
          END IF
          
         
        AFTER FIELD ala84
          IF g_ala.ala84 IS NOT NULL THEN
            LET g_ala.ala85 = g_ala.ala34 * g_ala.ala84
            SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = g_ala.ala20   #NO.CHI-6A0004
            LET g_ala.ala84 = cl_digcut(g_ala.ala84,t_azi07)   #NO.CHI-6A0004
            DISPLAY BY NAME g_ala.ala84
 
            LET g_ala.ala85 = cl_digcut(g_ala.ala85,g_azi04)   #NO.CHI-6A0004
            DISPLAY BY NAME g_ala.ala85
          END IF
 
        BEFORE FIELD ala84
            IF g_ala.ala84 = 0 OR g_ala.ala84 IS NULL THEN # 計算平均出帳匯率
               CALL s_bankex(g_ala.ala81,g_ala.ala08) RETURNING g_ala.ala84     #FUN-640239
               DISPLAY BY NAME g_ala.ala84
            END IF
 
        AFTER FIELD ala85
           LET g_ala.ala85 = cl_digcut(g_ala.ala85,g_azi04)   #NO.CHI-6A0004
           DISPLAY g_ala.ala85 TO ala85
 
        AFTER FIELD ala951
           LET g_ala.ala951 = cl_digcut(g_ala.ala951,g_azi04)   #NO.CHI-6A0004
           DISPLAY g_ala.ala951 TO ala951
 
        AFTER FIELD ala952
           LET g_ala.ala952 = cl_digcut(g_ala.ala952,g_azi04)   #NO.CHI-6A0004
           DISPLAY g_ala.ala952 TO ala952
 
        AFTER FIELD ala953
           LET g_ala.ala953 = cl_digcut(g_ala.ala953,g_azi04)   #NO.CHI-6A0004
           DISPLAY g_ala.ala953 TO ala953
 
           LET g_ala.ala95 = g_ala.ala951+g_ala.ala952+g_ala.ala953
           LET g_ala.ala95 = cl_digcut(g_ala.ala95,g_azi04)   #NO.CHI-6A0004
           DISPLAY BY NAME g_ala.ala95
 
        AFTER FIELD ala95
           LET g_ala.ala95 = cl_digcut(g_ala.ala95,g_azi04)   #NO.CHI-6A0004
           DISPLAY g_ala.ala95 TO ala95
 
        BEFORE FIELD ala86
           IF cl_null(g_ala.ala86) THEN             #MOD-BC0106 add
              LET g_ala.ala86 = g_ala.ala77
              DISPLAY g_ala.ala86 TO ala86
           END IF                                   #MOD-BC0106 add
 
        AFTER FIELD ala86
           IF NOT cl_null(g_ala.ala86) THEN
              IF g_ala.ala86 < g_ala.ala08 THEN
                 CALL cl_err('','anm-112',0)
                 NEXT FIELD ala86
              END IF
           END IF
 
 
        BEFORE FIELD ala91
          #CALL t711_set_entry(p_cmd)
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM nmd_file
            WHERE nmd01 = g_ala.ala931
            AND nmd30 <> 'X'
          IF l_n >0 THEN
            CALL cl_set_comp_entry("ala931,ala76,ala932",FALSE)
          END IF
          
        AFTER FIELD ala91
          IF g_ala.ala91 IS NOT NULL THEN
            SELECT nma10,nma28 INTO l_nma10,g_ala.ala92
              FROM nma_file WHERE nma01=g_ala.ala91
              IF STATUS THEN 
              CALL cl_err('sel nma:',STATUS,0)   #No.FUN-660122
              CALL cl_err3("sel","nma_file",g_ala.ala91,"",STATUS,"","sel nma:",1)  #No.FUN-660122
              NEXT FIELD ala91 
            END IF
            IF l_nma10!=g_aza.aza17 THEN
               CALL cl_err(g_ala.ala91,'aap-800',1)    #85-10-15
               NEXT FIELD ala91
            END IF
            DISPLAY BY NAME g_ala.ala92
            
            CALL t711_ala91()   #MOD-C30599
            
            IF g_ala.ala94 IS NULL OR g_ala.ala94 = 0 THEN
               LET g_ala.ala94 = g_ala.ala51
            END IF

            IF g_ala.ala952 IS NULL OR g_ala.ala952 = 0 THEN   #手續費
               LET g_ala.ala952 = g_ala.ala53
               DISPLAY BY NAME g_ala.ala952
            END IF
            IF g_ala.ala953 IS NULL OR g_ala.ala953 = 0 THEN   #郵電費
               LET g_ala.ala953 = g_ala.ala54
               DISPLAY BY NAME g_ala.ala953
            END IF
          END IF
          CALL t711_set_no_entry(p_cmd)
          #No.FUN-B50066  --End
           LET l_n = 0
           SELECT COUNT(*) INTO l_n FROM nmd_file
            WHERE nmd01 = g_ala.ala931
            AND nmd30 <> 'X'              
           IF g_ala.ala92 MATCHES '[23]' OR l_n > 0 THEN
              CALL cl_set_comp_entry("ala931,ala76,ala932",FALSE)
           ELSE 
           	  CALL cl_set_comp_entry("ala931,ala76,ala932",TRUE)
           END IF
           #No.FUN-B50066  --End

        AFTER FIELD ala931
          IF g_ala.ala931 IS NOT NULL THEN             
             CALL s_check_no("anm",g_ala.ala931,"","1","","","")
             RETURNING li_result,g_ala.ala931
             IF (NOT li_result) THEN
                NEXT FIELD ala931
             END IF
             
          END IF
 
        AFTER FIELD ala76
            IF NOT cl_null(g_ala.ala76) THEN
               SELECT COUNT(*) INTO l_n FROM nna_file,nma_file
                WHERE nna01 = nma01
                  AND nna01 = g_ala.ala91
                  AND nna02 = g_ala.ala76
               IF l_n = 0 THEN
                  CALL cl_err(g_ala.ala76,'anm-954',0) NEXT FIELD ala76
               END IF
            END IF
 
        AFTER FIELD ala932
            IF g_ala.ala932 IS NOT NULL THEN
               CALL s_chknot(g_ala.ala91,g_ala.ala932,g_ala.ala76)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ala.ala932,g_errno,0)
                  NEXT FIELD ala932
               END IF
            END IF
            
         #No.FUN-B50066  --Begin
         AFTER FIELD ala12
          IF g_ala.ala12 IS NOT NULL THEN             
             CALL s_check_no("anm",g_ala.ala12,"","1","","","")
             RETURNING li_result,g_ala.ala12
             IF (NOT li_result) THEN
                NEXT FIELD ala12
             END IF
             
          END IF
 
        AFTER FIELD ala13
            IF NOT cl_null(g_ala.ala13) THEN
               SELECT COUNT(*) INTO l_n FROM nna_file,nma_file
                WHERE nna01 = nma01
                  AND nna01 = g_ala.ala81
                  AND nna02 = g_ala.ala13
               IF l_n = 0 THEN
                  CALL cl_err(g_ala.ala13,'anm-954',0) 
                  NEXT FIELD ala13
               END IF
            END IF
 
        AFTER FIELD ala14
            IF g_ala.ala14 IS NOT NULL THEN
               CALL s_chknot(g_ala.ala81,g_ala.ala14,g_ala.ala13)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ala.ala14,g_errno,0)
                  NEXT FIELD ala14
               END IF
            END IF
        #No.FUN-B50066  --End
         AFTER FIELD ala94                      # No: MOD-530821
          IF g_ala.ala94 IS NOT NULL THEN
            IF g_ala.ala94 = 0     THEN NEXT FIELD ala94 END IF
            IF g_ala.ala80='0' THEN
               IF g_ala.ala951 = 0 OR cl_null(g_ala.ala951) THEN
                  LET g_ala.ala951=g_ala.ala34 * g_ala.ala94
               END IF
            ELSE LET g_ala.ala951=0
            END IF
            IF g_ala.ala952 = 0 OR cl_null(g_ala.ala952) THEN
               SELECT nnp06 INTO l_nnp06 FROM nnp_file
                WHERE nnp01=g_ala.ala33 AND nnp03=g_ala.ala35
               LET g_ala.ala952 = g_ala.ala23 * l_nnp06/100 * g_ala.ala94
               IF g_ala.ala952 IS NULL THEN LET g_ala.ala952 = 0 END IF
            END IF
            DISPLAY BY NAME g_ala.ala951,g_ala.ala952
          END IF
          
        AFTER FIELD ala04
           IF NOT cl_null(g_ala.ala04) THEN
                CALL t711_ala04()                 # 帳款部門
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala04,g_errno,0)
                   LET g_ala.ala04 = g_ala_t.ala04
                   DISPLAY BY NAME g_ala.ala04
                   NEXT FIELD ala04
                END IF
                DISPLAY s_costcenter_desc(g_ala.ala04) TO FORMONLY.gem02
                LET g_ala.ala930=s_costcenter(g_ala.ala04)
                DISPLAY s_costcenter_desc(g_ala.ala930) TO FORMONLY.gem02b
           END IF
        AFTER FIELD ala930 
           IF NOT s_costcenter_chk(g_ala.ala930) THEN
              NEXT FIELD ala930
           ELSE
              DISPLAY s_costcenter_desc(g_ala.ala930) TO FORMONLY.gem02b
           END IF
        AFTER FIELD alaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_ala.alauser = s_get_data_owner("ala_file") #FUN-C10039
           LET g_ala.alagrup = s_get_data_group("ala_file") #FUN-C10039
            LET l_flag='N'
            LET tot = g_ala.ala85 + g_ala.ala95
            LET tot = cl_digcut(tot,g_azi04)   #NO.CHI-6A0004
            DISPLAY BY NAME tot
            LET g_ala.ala95 = g_ala.ala951+g_ala.ala952+g_ala.ala953
            LET g_ala.ala95 = cl_digcut(g_ala.ala95,g_azi04)   #NO.CHI-6A0004
            DISPLAY BY NAME g_ala.ala95
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err(g_ala.ala01,'9033',0)
                 NEXT FIELD ala01
            END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP     #85-10-15
            CASE
               WHEN INFIELD(ala81) #外幣支付銀行
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_nma"
                  LET g_qryparam.default1 = g_ala.ala81
                  CALL cl_create_qry() RETURNING g_ala.ala81
                  DISPLAY BY NAME g_ala.ala81
                  NEXT FIELD ala81
               WHEN INFIELD(ala91) #本幣支付銀行
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_nma"
                  LET g_qryparam.default1 = g_ala.ala91
                  CALL cl_create_qry() RETURNING g_ala.ala91
                  DISPLAY BY NAME g_ala.ala91
                  NEXT FIELD ala91
               WHEN INFIELD(ala96) #銀行異動碼
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_nmc"             #MOD-C80022 mark
                  LET g_qryparam.form ="q_nmc002"          #MOD-C80022 add
                  LET g_qryparam.default1 = g_ala.ala96
                  CALL cl_create_qry() RETURNING g_ala.ala96
                  DISPLAY BY NAME g_ala.ala96
                  NEXT FIELD ala96
               WHEN INFIELD(ala931) #開票單別
                  LET g_t1=s_get_doc_no(g_ala.ala931)
                  LET g_sys='ANM'
                  #CALL q_nmy(FALSE,FALSE,g_t1,'1',g_sys) RETURNING g_t1  #TQC-670008
                  CALL q_nmy(FALSE,FALSE,g_t1,'1','AAP') RETURNING g_t1   #TQC-670008
                  LET g_ala.ala931=g_t1
                  DISPLAY BY NAME g_ala.ala931
                  NEXT FIELD ala931
                #No.FUN-B50066 --Begin
                WHEN INFIELD(ala12) #開票單別
                  LET g_t1=s_get_doc_no(g_ala.ala12)
                  LET g_sys='ANM'
                  CALL q_nmy(FALSE,FALSE,g_t1,'1','AAP') RETURNING g_t1   #TQC-670008
                  LET g_ala.ala12=g_t1
                  DISPLAY BY NAME g_ala.ala12
                  NEXT FIELD ala12
                #No.FUN-B50066 --End
                WHEN INFIELD(ala84)
                   LET l_nma10=''
                   SELECT nma10 INTO l_nma10 FROM nma_file
                    WHERE nma01=g_ala.ala81
                   CALL s_rate(l_nma10,g_ala.ala84)
                   RETURNING g_ala.ala84
                   DISPLAY BY NAME g_ala.ala84
                WHEN INFIELD(ala94)
                   LET l_nma10=''
                   SELECT nma10 INTO l_nma10 FROM nma_file
                    WHERE nma01=g_ala.ala91
                   CALL s_rate(l_nma10,g_ala.ala95)
                   RETURNING g_ala.ala94
                   DISPLAY BY NAME g_ala.ala94
                   NEXT FIELD ala94
               WHEN INFIELD(ala04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_ala.ala04
                  DISPLAY BY NAME g_ala.ala04
                  NEXT FIELD ala04
               WHEN INFIELD(ala930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_ala.ala930
                  DISPLAY BY NAME g_ala.ala930
                  NEXT FIELD ala930
               OTHERWISE
                  EXIT CASE
            END CASE
 
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
 
 
FUNCTION t711_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ala01",TRUE)
   END IF
 
   IF INFIELD(ala80) OR (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ala81,ala84,ala85",TRUE)
     CALL cl_set_comp_required("ala81,ala84,ala85",FALSE)
   END IF
 
   IF INFIELD(ala91) OR (NOT g_before_input_done) THEN      
      CALL cl_set_comp_entry("ala931,ala76,ala932",TRUE)
   END IF
   
   #No.FUN-B50066  --Begin
   IF INFIELD(ala81) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ala12,ala13,ala14",TRUE)
   END IF
   #No.FUN-B50066  --End
   
   IF INFIELD(ala96) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_required("ala96",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION t711_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   l_n     LIKE type_file.num5    #No.TQC-B40142 

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ala01",FALSE)
   END IF
 
   IF INFIELD(ala80) OR (NOT g_before_input_done) THEN
      IF g_ala.ala80 = '0' THEN
         CALL cl_set_comp_entry("ala81,ala84,ala85",FALSE)    #MOD-5C0125
         CALL cl_set_comp_entry("ala951",TRUE)    #TQC-B50008 
      END IF
      IF g_ala.ala80 = '1' THEN
         CALL cl_set_comp_required("ala81,ala84,ala85",TRUE)  #MOD-4A0043     #MOD-5C0125
         CALL cl_set_comp_entry("ala951",FALSE)    #TQC-B50008 
      END IF
   END IF
 
   IF INFIELD(ala91) OR (NOT g_before_input_done) THEN
      IF g_ala.ala92  MATCHES '[23]' THEN   #MOD-850050 mod '[02]'->'[23]'
         CALL cl_set_comp_entry("ala931,ala76,ala932",FALSE)
      END IF
   END IF
 
   #No.FUN-B50066  --Begin
   IF INFIELD(ala81) OR (NOT g_before_input_done) THEN
      IF g_ala.ala82  MATCHES '[23]' THEN
         CALL cl_set_comp_entry("ala12,ala13,ala14",FALSE)
      END IF
   END IF
   #No.FUN-B50066  --End
   
   IF INFIELD(ala96) OR (NOT g_before_input_done) THEN
      IF g_ala.ala82='2' OR g_ala.ala92='2' THEN
         CALL cl_set_comp_required("ala96",TRUE)
      END IF
   END IF
   #No.TQC-B40142  --Begin
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
     SELECT COUNT(*) INTO l_n FROM nmd_file
      WHERE nmd11 = g_ala.ala01
        AND nmd30 <> 'X' 
     IF l_n>0 THEN
        CALL cl_set_comp_entry("ala931,ala76,ala932",FALSE)
        CALL cl_set_comp_entry("ala12,ala13,ala14",FALSE)   #No.FUN-B50066
     END IF
   END IF
   #No.TQC-B40142  --End
 
END FUNCTION
 
FUNCTION t711_ala96(p_cmd)
 DEFINE  p_cmd       LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
         l_nmc02     LIKE nmc_file.nmc02,
         l_nmcacti   LIKE nmc_file.nmcacti
 
    LET g_errno = ' '
    SELECT nmc02,nmcacti
      INTO l_nmc02,l_nmcacti FROM nmc_file
      WHERE nmc01 = g_ala.ala96
        AND nmc03 = '2'
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-024' LET l_nmc02 = ' '
         WHEN l_nmcacti  ='N'  LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_nmc02 TO FORMONLY.nmc02
    END IF
END FUNCTION

#--MOD-C30599 start---
FUNCTION t711_ala81()
 DEFINE  l_nma02_1   LIKE nma_file.nma02

    SELECT nma02 INTO l_nma02_1
      FROM nma_file WHERE nma01 = g_ala.ala81

    DISPLAY l_nma02_1 TO FORMONLY.nma02_1 
END FUNCTION
#--MOD-C30599 end---

#--MOD-C30599 start---
FUNCTION t711_ala91()
 DEFINE  l_nma02_2   LIKE nma_file.nma02
         
    SELECT nma02 INTO l_nma02_2
      FROM nma_file WHERE nma01 = g_ala.ala91

    DISPLAY l_nma02_2 TO FORMONLY.nma02_2 
END FUNCTION
#--MOD-C30599 end---


 
FUNCTION t711_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ala.* TO NULL              #NO.FUN-6A0016
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t711_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t711_count
    FETCH t711_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t711_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
       INITIALIZE g_ala.* TO NULL
    ELSE
        CALL t711_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t711_fetch(p_flala)
    DEFINE
        p_flala          LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flala
        WHEN 'N' FETCH NEXT     t711_cs INTO g_ala.ala01
        WHEN 'P' FETCH PREVIOUS t711_cs INTO g_ala.ala01
        WHEN 'F' FETCH FIRST    t711_cs INTO g_ala.ala01
        WHEN 'L' FETCH LAST     t711_cs INTO g_ala.ala01
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
            FETCH ABSOLUTE g_jump t711_cs INTO g_ala.ala01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
        INITIALIZE g_ala.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flala
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ala.* FROM ala_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ala01 = g_ala.ala01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ala_file",g_ala.ala01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
       LET g_data_owner = g_ala.alauser     #No.FUN-4C0047
       LET g_data_group = g_ala.alagrup     #No.FUN-4C0047
       CALL t711_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t711_show()
    LET g_ala_t.* = g_ala.*
    LET tot = g_ala.ala85 + g_ala.ala95
    DISPLAY BY NAME
        g_ala.ala97,g_ala.ala01,g_ala.ala08,g_ala.ala96,                                         #No.FUN-980017
         g_ala.ala20,g_ala.ala51,g_ala.ala86,g_ala.ala04,g_ala.ala930,g_ala.ala21,g_ala.ala34,   #MOD-4C0040 #FUN-680019
        g_ala.ala23,g_ala.ala80,g_ala.ala74,
        g_ala.ala81,g_ala.ala82,g_ala.ala83,g_ala.ala84,g_ala.ala85,
        g_ala.ala91,g_ala.ala92,g_ala.ala931,g_ala.ala76,
         g_ala.ala932,g_ala.ala93,g_ala.ala94,   #No.MOD-530821
        g_ala.ala951,g_ala.ala952,g_ala.ala953,g_ala.ala95,
        g_ala.alafirm, g_ala.alaclos, g_ala.ala78, tot,
           g_ala.alaud01,g_ala.alaud02,g_ala.alaud03,g_ala.alaud04,
           g_ala.alaud05,g_ala.alaud06,g_ala.alaud07,g_ala.alaud08,
           g_ala.alaud09,g_ala.alaud10,g_ala.alaud11,g_ala.alaud12,
           g_ala.alaud13,g_ala.alaud14,g_ala.alaud15,
           g_ala.ala12,g_ala.ala13,g_ala.ala14
 
    CALL t711_ala96('d')
    CALL t711_ala81()   #MOD-C30599
    CALL t711_ala91()   #MOD-C30599
    IF g_ala.alafirm = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    DISPLAY s_costcenter_desc(g_ala.ala04) TO FORMONLY.gem02   #FUN-680019
    DISPLAY s_costcenter_desc(g_ala.ala930) TO FORMONLY.gem02b #FUN-680019
    CALL cl_set_field_pic(g_ala.ala78,"","",g_ala.alaclos,g_void,"")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t711_u()
    IF g_ala.ala01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ala.* FROM ala_file
     WHERE ala01=g_ala.ala01
    IF g_ala.alafirm='N' THEN CALL cl_err(g_ala.ala01,'aap-717',0) RETURN END IF
    IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_ala.ala78='Y' THEN CALL cl_err(g_ala.ala01,'axm-101',0) RETURN END IF
    IF g_ala.alaclos='Y' THEN CALL cl_err('','9004',0) RETURN END IF      #MOD-B40162
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ala01_t = g_ala.ala01
    BEGIN WORK
    OPEN t711_cl USING g_ala.ala01
    FETCH t711_cl INTO g_ala.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL t711_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t711_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ala.*=g_ala_t.*
            CALL t711_show()
            CALL cl_err(g_ala.ala01,9001,0)
            EXIT WHILE
        END IF
        UPDATE ala_file SET ala_file.* = g_ala.*    # 更新DB
            WHERE ala01 = g_ala01_t            # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ala_file",g_ala01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t711_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ala.ala01,'U')
END FUNCTION
 
FUNCTION t711_y()
   IF g_ala.ala01 IS NULL THEN RETURN END IF
    SELECT * INTO g_ala.* FROM ala_file
     WHERE ala01=g_ala.ala01
   IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_ala.alafirm='N' THEN            #85-10-15
      CALL cl_err(g_ala.ala01,'aap-234',0)
      RETURN
   END IF
   IF g_ala.alaclos='Y' THEN
      CALL cl_err(g_ala.ala01,'aap-238',0)
      RETURN
   END IF
   IF g_ala.ala78='Y' THEN
      CALL cl_err(g_ala.ala01,'aap-232',0)
      RETURN
   END IF
   IF g_ala.ala91 IS NULL THEN
      CALL cl_err(g_ala.ala01,'aap-233',0)
      RETURN
   END IF
   IF g_ala.ala95 IS NULL THEN
      CALL cl_err(g_ala.ala01,'aap-235',0)
      RETURN
   END IF
   #IF g_ala.ala92='1' AND g_ala.ala931 IS NULL THEN  #No.FUN-B50066 
   IF (g_ala.ala92='1' AND g_ala.ala931 IS NULL) OR   #No.FUN-B50066
      (g_ala.ala82='1' AND g_ala.ala12 IS NULL)THEN   #No.FUN-B50066
      CALL cl_err(g_ala.ala01,'aap-236',0)
      RETURN
   END IF
  #str MOD-B60223 add
  #確認時,支付銀行為活存,或沒輸入支票欄位,則卡銀存異動碼需有值
   IF (g_ala.ala82='2' OR g_ala.ala92='2' OR g_ala.ala931 IS NULL)
      AND g_ala.ala96 IS NULL THEN
      CALL cl_err(g_ala.ala96,'aap-307',0)
      RETURN
   END IF
  #end MOD-B60223 add
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   INITIALIZE g_nme.* TO NULL
   INITIALIZE g_nmd.* TO NULL
   BEGIN WORK LET g_success='Y'
   OPEN t711_cl USING g_ala.ala01
   FETCH t711_cl INTO g_ala.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_ala.ala59=g_ala.ala85+g_ala.ala95+g_ala.ala56   #FUN-690015
   IF g_ala.ala59 > 0 THEN   #FUN-690015
      CALL s_chknpq1(g_ala.ala01,0,5,'0',g_aza.aza81)           #check平衡否  #No.FUN-680029 add '0'     #NO.FUN-730064
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq1(g_ala.ala01,0,5,'1',g_aza.aza82)       #No.MOD-820161
      END IF
   END IF   #FUN-690015
   IF g_success = 'N' THEN RETURN END IF
   IF g_ala.ala80 = '1' AND g_ala.ala82 MATCHES "[2]" THEN
      CALL t711_y_nme(g_ala.ala81,g_ala.ala84,g_ala.ala34,g_ala.ala85)
                RETURNING g_ala.ala83 DISPLAY BY NAME g_ala.ala83
   END IF

   IF g_ala.ala92 = '2' THEN
      LET g_nme.nme12 = g_ala.ala01
      LET g_nme.nme17 = ''
   END IF
   IF g_ala.ala92 MATCHES "[2]" THEN
      CALL t711_y_nme(g_ala.ala91,1,g_ala.ala95,g_ala.ala95)
                RETURNING g_ala.ala93 DISPLAY BY NAME g_ala.ala93
   END IF
   UPDATE ala_file SET ala78 = 'Y', ala83=g_ala.ala83, ala93=g_ala.ala93,
                                    ala59=g_ala.ala59, ala931=g_ala.ala931
                                    ,ala12=g_ala.ala92 #No.FUN-B50066
          WHERE ala01 = g_ala.ala01
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ala.ala01,'Y')
      LET g_ala.ala78 ='Y'
      DISPLAY BY NAME g_ala.ala78
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t711_y_nme(p_bank,p_ex,p_amt1,p_amt2)
   DEFINE p_bank       LIKE nme_file.nme01     # No.FUN-690028 VARCHAR(11)
   DEFINE p_ex         LIKE azj_file.azj03     # No.FUN-690028 DEC(20,10)  #FUN-4B0079
   DEFINE p_amt1,p_amt2     LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_serial     LIKE type_file.chr20       # No.FUN-690028 VARCHAR(10)
   DEFINE l_sql        STRING   #FUN-630106
   DEFINE l_legal      LIKE azw_file.azw02     #FUN-980001 add

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   IF p_amt2 IS NULL OR p_amt2 = 0 THEN RETURN 0 END IF
 

  #LET l_sql = "SELECT MAX(nme00)+1 FROM ",g_dbs_nm,"nme_file"   #FUN-A50102
   LET l_sql = "SELECT MAX(nme00)+1 FROM ",cl_get_target_table(g_plant_new,'nme_file')   #FUN-A50102
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
   PREPARE n1 FROM l_sql
   EXECUTE n1 INTO g_nme.nme00
   IF g_nme.nme00 IS NULL THEN LET g_nme.nme00=1 END IF
 
   LET g_nme.nme01=p_bank
   LET g_nme.nme02=g_ala.ala86    #MOD-5A0258
   LET g_nme.nme03=g_ala.ala96
   LET g_nme.nme04=p_amt1
   LET g_nme.nme05='L/C No.:',g_ala.ala01
   LET g_nme.nme07=p_ex
   LET g_nme.nme08=p_amt2
   LET g_nme.nme12 = g_ala.ala01  #MOD-BB0139
   LET g_nme.nme15=g_ala.ala04
   LET g_nme.nme16=g_ala.ala86   #MOD-620089
   LET g_nme.nme17 = ''           #MOD-BB0139
   LET g_nme.nmeacti='Y'                  #85-10-15
   LET g_nme.nmeuser=g_user
   LET g_nme.nmeoriu = g_user #FUN-980030
   LET g_nme.nmeorig = g_grup #FUN-980030
   LET g_nme.nmegrup=g_ala.alagrup
   LET g_nme.nme21='1'
   LET g_nme.nme22='11'
   LET g_nme.nme24='9'
   CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001 add
   LET g_nme.nmelegal=l_legal #FUN-980001 add

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

  #LET g_sql="INSERT INTO ",g_dbs_nm,"nme_file",   #FUN-A50102
   LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'nme_file'),   #FUN-A50102
             "       (nme00,nme01,nme02,nme16,nme021,nme03,nme04,nme05,nme07,",
#            "        nme08,nme12,nme13,nme15,nme17,nmeacti,nmeuser,nmegrup,nme21,nme22,nme23,nme24,nmelegal,nmeoriu,nmeorig)",#TQC-A10060 add nmeoriu,nmeorig  #No.FUN-730032 #FUN-980001 add  #FUN-B30166 Mark
             "        nme08,nme12,nme13,nme15,nme17,nmeacti,nmeuser,nmegrup,nme21,nme22,nme23,nme24,nme27,nmelegal,nmeoriu,nmeorig)",#TQC-A10060 add nmeoriu,nmeorig  #No.FUN-730032 #FUN-980001 add  #FUN-B30166 add nme27
             " VALUES(",g_nme.nme00,",",
                     "'",g_nme.nme01,"',",
                     "'",g_nme.nme02,"',",
                     "'",g_nme.nme16,"',",
                     "'",g_nme.nme021,"',",
                     "'",g_nme.nme03,"',",
                     "'",g_nme.nme04,"',",
                     "'",g_nme.nme05,"',",
                     "'",g_nme.nme07,"',",
                     "'",g_nme.nme08,"',",
                     "'",g_nme.nme12,"',",
                     "'",g_nme.nme13,"',",
                     "'",g_nme.nme15,"',",
                     "'",g_nme.nme17,"',",
                     "'",g_nme.nmeacti,"',",
                     "'",g_nme.nmeuser,"',",
                     "'",g_nme.nmegrup,"',",
                     "'",g_nme.nme21,"',",
                     "'",g_nme.nme22,"',",
                     "'",g_nme.nme23,"',",
                     "'",g_nme.nme24,"',", #FUN-980001 add
                     "'",g_nme.nme27,"',", #FUN-B30166 add
                     "'",g_nme.nmelegal,"',", #FUN-980001 add
                     "'",g_nme.nmeoriu,"',", #TQC-A10060  add
                     "'",g_nme.nmeorig,"')"  #TQC-A10060  add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE t711_y_nme_p FROM g_sql
   EXECUTE t711_y_nme_p
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('ins nme:',SQLCA.SQLCODE,1) LET g_success='N' RETURN l_serial
   END IF
   CALL s_flows_nme(g_nme.*,'1',g_plant_new)   #No.FUN-B90062  
   LET l_serial=SQLCA.SQLERRD[2]
    RETURN g_nme.nme00 #MOD-4A0043
END FUNCTION

#No.FUN-B50066  --Begin
#FUNCTION t711_g_nmd(p_bank,p_ex,p_amt1,p_amt2)
#   DEFINE li_result   LIKE type_file.num5      #No.FUN-560002  #No.FUN-690028 SMALLINT
#   DEFINE p_bank       LIKE nme_file.nme01      # No.FUN-690028 VARCHAR(11)
#   DEFINE p_ex         LIKE azj_file.azj03      # No.FUN-690028 DEC(20,10)  #FUN-4B0079
#   DEFINE p_amt1,p_amt2     LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
#   DEFINE l_serial       LIKE type_file.chr20   # No.FUN-690028 VARCHAR(10)
#   DEFINE l_n            LIKE type_file.num5    #No.FUN-690028 SMALLINT
# 
#   IF cl_null(g_ala.ala01) THEN
#      RETURN
#   END IF
# 
#   SELECT * INTO g_ala.* FROM ala_file WHERE ala01 = g_ala.ala01
# 
#   IF g_ala.alafirm = 'X' THEN
#      CALL cl_err('','9024',0)
#      RETURN
#   END IF
# 
#   IF g_ala.ala92 = '2' THEN    #活存
#      RETURN
#   END IF
#   
#   SELECT COUNT(*) INTO l_n FROM nmd_file
#    WHERE nmd11 = g_ala.ala01
#      AND nmd30 <> 'X'
# 
#   IF l_n>0 THEN
#      CALL cl_err(g_ala.ala01,'aap-290',1)
#      RETURN
#   END IF
# 
#   SELECT COUNT(*) INTO l_n FROM nmd_file
#    WHERE nmd01 = g_ala.ala931
#      AND nmd30 <> 'X'
# 
#   IF l_n > 0 THEN
#      CALL cl_err(g_ala.ala931,'aap-741',1)
#      RETURN
#   END IF
# 
#   IF cl_null(g_ala.ala931) THEN
#      CALL cl_err(g_ala.ala931,'anm-217',1)
#      RETURN
#   END IF
# 
#   LET g_success = 'Y' #No.7875
#   BEGIN WORK          #No.7875
# 
#      CALL s_auto_assign_no("anm",g_ala.ala931,g_ala.ala08,"1","","","","","")
#           RETURNING li_result,g_ala.ala931
#      IF (NOT li_result) THEN
#         RETURN
#      END IF
#
# 
#   DISPLAY BY NAME g_ala.ala931
# 
#   UPDATE ala_file SET ala931 = g_ala.ala931
#    WHERE ala01 = g_ala.ala01
# 
#   IF STATUS OR SQLCA.SQLCODE THEN
#      CALL cl_err3("upd","ala_file",g_ala.ala01,"",SQLCA.sqlcode,"","upd ala931:",1)  #No.FUN-660122
#      LET g_success = 'N'
#      ROLLBACK WORK  #No.7875
#      RETURN
#   END IF
# 
#   LET g_nmd.nmd01 = g_ala.ala931
#   LET g_nmd.nmd02 = g_ala.ala932
#   LET g_nmd.nmd03 = p_bank
#   LET g_nmd.nmd04 = p_amt1
#   LET g_nmd.nmd26 = p_amt2
#   LET g_nmd.nmd05 = g_ala.ala08
#   LET g_nmd.nmd07 = g_ala.ala08
#   LET g_nmd.nmd08 = g_ala.ala07
# 
#   SELECT alg02 INTO g_nmd.nmd24 FROM alg_file
#    WHERE alg01 = g_ala.ala07
# 
#   SELECT pmc081 INTO g_nmd.nmd09 FROM pmc_file
#    WHERE pmc01 = g_ala.ala07
# 
#   LET g_nmd.nmd11 = g_ala.ala01
#   LET g_nmd.nmd12 = '1'
#   LET g_nmd.nmd13 = g_ala.ala08
#   LET g_nmd.nmd15 = g_ala.ala08
#   LET g_nmd.nmd18 = g_ala.ala04
#   LET g_nmd.nmd19 = p_ex
#   LET g_nmd.nmd21 = g_aza.aza17
#   LET g_nmd.nmd28 = g_ala.ala08
#   LET g_nmd.nmd29 = g_ala.ala08
#   LET g_nmd.nmd30 = 'N'
#   LET g_nmd.nmd31 = g_ala.ala76
#   LET g_nmd.nmd33 = g_nmd.nmd19       #bug no:A049
#   LET g_nmd.nmduser = g_user
#   LET g_nmd.nmdgrup = g_ala.alagrup              #85-10-15
#   LET g_nmd.nmdlegal= g_legal #FUN-980001 add
# 
#   LET g_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
#   LET g_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
#   INSERT INTO nmd_file VALUES(g_nmd.*)            # 注意多工廠環境
#   IF STATUS OR SQLCA.SQLCODE THEN
#      CALL cl_err3("ins","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","ins nmd",1)  #No.FUN-660122
#      SELECT * INTO g_ala.* FROM ala_file
#       WHERE ala01 = g_ala.ala01
#      CALL t711_show()
#      LET g_success='N'
#   END IF
# 
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#   ELSE
#      ROLLBACK WORK
#   END IF
# 
#END FUNCTION

FUNCTION t711_g_nmd()
   DEFINE li_result   LIKE type_file.num5      #No.FUN-560002  #No.FUN-690028 SMALLINT
   #DEFINE p_bank       LIKE nme_file.nme01      # No.FUN-690028 VARCHAR(11)
   DEFINE p_ex         LIKE azj_file.azj03      # No.FUN-690028 DEC(20,10)  #FUN-4B0079
   #DEFINE p_amt1,p_amt2     LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_serial       LIKE type_file.chr20   # No.FUN-690028 VARCHAR(10)
   DEFINE l_n            LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_n_fc         LIKE type_file.num5    #No.FUN-B50066
   IF cl_null(g_ala.ala01) THEN
      RETURN
   END IF
 
   SELECT * INTO g_ala.* FROM ala_file WHERE ala01 = g_ala.ala01
 
   IF g_ala.alafirm = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_ala.ala92 = '2' THEN    #活存
      RETURN
   END IF

   SELECT COUNT(*) INTO l_n FROM nmd_file
    WHERE nmd11 = g_ala.ala01
      AND nmd30 <> 'X'
   IF l_n>1 THEN 
      CALL cl_err(g_ala.ala01,'aap-290',1)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_n FROM nmd_file
    WHERE nmd01 = g_ala.ala931
      AND nmd30 <> 'X'

   SELECT COUNT(*) INTO l_n_fc FROM nmd_file
    WHERE nmd01 = g_ala.ala12
      AND nmd30 <> 'X'

   IF l_n > 0 AND l_n_fc > 0 THEN
      CALL cl_err('','aap-741',1) 
      RETURN
   END IF
                       
   IF cl_null(g_ala.ala931) AND cl_null(g_ala.ala12) THEN  
      CALL cl_err(g_ala.ala931,'anm-217',1)
      RETURN
   END IF
 
   LET g_success = 'Y' #No.7875

   LET g_nmd.nmd05 = g_ala.ala08
   LET g_nmd.nmd07 = g_ala.ala08
   #LET g_nmd.nmd08 = g_ala.ala07  #MOD-C30680 mark--
   LET g_nmd.nmd08 = g_ala.ala05   #MOD-C30680 add--
 
   SELECT alg02 INTO g_nmd.nmd24 FROM alg_file
    WHERE alg01 = g_ala.ala07
 
   SELECT pmc081 INTO g_nmd.nmd09 FROM pmc_file
    WHERE pmc01 = g_ala.ala07
 
   LET g_nmd.nmd11 = g_ala.ala01
   LET g_nmd.nmd12 = '1'
   LET g_nmd.nmd13 = g_ala.ala08
   LET g_nmd.nmd15 = g_ala.ala08
   LET g_nmd.nmd18 = g_ala.ala04
   LET g_nmd.nmd19 = p_ex
   LET g_nmd.nmd21 = g_aza.aza17
   LET g_nmd.nmd28 = g_ala.ala08
   LET g_nmd.nmd29 = g_ala.ala08
   LET g_nmd.nmd30 = 'N'
   #MOD-C30680--add--str
   IF g_nmz.nmz11 = 'Y' THEN
      SELECT nms15 INTO g_nmd.nmd23 FROM nms_file WHERE nms01 =g_nmd.nmd18
   ELSE
      SELECT nms15 INTO g_nmd.nmd23 FROM nms_file WHERE nms01 =' '
   END IF
   #MOD-C30680--add--end
 
   LET g_nmd.nmd33 = g_nmd.nmd19 
   LET g_nmd.nmduser = g_user
   LET g_nmd.nmdgrup = g_ala.alagrup
   LET g_nmd.nmdlegal= g_legal
 
   LET g_nmd.nmdoriu = g_user 
   LET g_nmd.nmdorig = g_grup  
   
   BEGIN WORK   
     IF l_n = 0 AND g_ala.ala92 = '1' THEN   #No.FUN-B50066 #本币未产生支票资料 
      CALL s_auto_assign_no("anm",g_ala.ala931,g_ala.ala08,"1","","","","","")
           RETURNING li_result,g_ala.ala931
      IF (NOT li_result) THEN
         RETURN
      END IF

 
   DISPLAY BY NAME g_ala.ala931
 
   UPDATE ala_file SET ala931 = g_ala.ala931
    WHERE ala01 = g_ala.ala01
 
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("upd","ala_file",g_ala.ala01,"",SQLCA.sqlcode,"","upd ala931:",1)  #No.FUN-660122
      LET g_success = 'N'
      ROLLBACK WORK  #No.7875
      RETURN
   END IF
 
   LET g_nmd.nmd01 = g_ala.ala931
   LET g_nmd.nmd02 = g_ala.ala932
   LET g_nmd.nmd03 = g_ala.ala91
   LET g_nmd.nmd04 = g_ala.ala95
   LET g_nmd.nmd26 = 0
   LET g_nmd.nmd31 = g_ala.ala76

   INSERT INTO nmd_file VALUES(g_nmd.*)            # 注意多工廠環境
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("ins","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","ins nmd",1)  #No.FUN-660122
      SELECT * INTO g_ala.* FROM ala_file
       WHERE ala01 = g_ala.ala01
      CALL t711_show()
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
  END IF 
  
  BEGIN WORK   
    IF l_n_fc = 0 AND g_ala.ala82 = '1' THEN
      CALL s_auto_assign_no("anm",g_ala.ala12,g_ala.ala08,"1","","","","","")
           RETURNING li_result,g_ala.ala12
      IF (NOT li_result) THEN
         RETURN
      END IF

 
   DISPLAY BY NAME g_ala.ala12
 
   UPDATE ala_file SET ala12 = g_ala.ala12
    WHERE ala01 = g_ala.ala01
 
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("upd","ala_file",g_ala.ala01,"",SQLCA.sqlcode,"","upd ala12:",1) 
      LET g_success = 'N'
      ROLLBACK WORK  #No.7875
      RETURN
   END IF
 
   LET g_nmd.nmd01 = g_ala.ala12
   LET g_nmd.nmd02 = g_ala.ala14
   LET g_nmd.nmd03 = g_ala.ala81
   LET g_nmd.nmd04 = g_ala.ala34
   LET g_nmd.nmd26 = g_ala.ala85
   LET g_nmd.nmd31 = g_ala.ala13
   
   INSERT INTO nmd_file VALUES(g_nmd.*)            # 注意多工廠環境
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("ins","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","ins nmd",1) 
      SELECT * INTO g_ala.* FROM ala_file
       WHERE ala01 = g_ala.ala01
      CALL t711_show()
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
  END IF 
END FUNCTION
#No.FUN-B50066  --End

FUNCTION t711_z()
   IF g_ala.ala01 IS NULL THEN RETURN END IF
    SELECT * INTO g_ala.* FROM ala_file
     WHERE ala01=g_ala.ala01
   IF g_ala.ala78='N' THEN RETURN END IF
   IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
   
   IF NOT cl_null(g_ala.ala74) THEN                                                                                                 
      CALL cl_err(g_ala.ala01,'axr-370',0) RETURN                                                                                
   END IF                                                                                                                           
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK LET g_success='Y'
   OPEN t711_cl USING g_ala.ala01
   FETCH t711_cl INTO g_ala.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   IF g_ala.ala80 = '1' AND g_ala.ala82 MATCHES "[2]" THEN
      IF g_ala.ala83 IS NOT NULL THEN CALL t711_z_nme(g_ala.ala83) END IF
      LET g_ala.ala83=NULL
   END IF

   IF g_ala.ala92='2' THEN
      CALL t711_z_nme(g_ala.ala93)
      LET g_ala.ala93=NULL
   END IF
   IF g_success='Y'
      THEN LET g_ala.ala78='N'
           UPDATE ala_file SET ala78 = 'N',ala83=g_ala.ala83,ala93=g_ala.ala93
                  WHERE ala01 = g_ala.ala01
           DISPLAY BY NAME g_ala.ala78,g_ala.ala83,g_ala.ala93
           COMMIT WORK
      ELSE ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t711_z_nme(p_no)
   DEFINE p_no         LIKE type_file.num10       # No.FUN-690028 INTEGER      # 開票單號/收支單號
   DEFINE l_nme24      LIKE nme_file.nme24    #No.FUN-730032
   DEFINE l_aza73      LIKE aza_file.aza73    #No.MOD-740346
   
   MESSAGE "del nme:",p_no
   IF p_no IS NULL OR p_no = 0 THEN RETURN END IF
  #LET g_sql="SELECT aza73 FROM ",g_dbs_nm CLIPPED,"aza_file"   #FUN-A50102
   LET g_sql="SELECT aza73 FROM ",cl_get_target_table(g_plant_new,'aza_file')  #FUN-A50102
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE t711_aza_p FROM g_sql
   DECLARE t711_aza_c CURSOR FOR t711_aza_p
   OPEN t711_aza_c
   FETCH t711_aza_c INTO l_aza73
   IF l_aza73 = 'Y' THEN
     #LET g_sql="SELECT nme24 FROM ",g_dbs_nm CLIPPED,"nme_file",  #FUN-A50102
      LET g_sql="SELECT nme24 FROM ",cl_get_target_table(g_plant_new,'nme_file'),  #FUN-A50102
                " WHERE nme00=",p_no  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE t711_z_nme_p1 FROM g_sql
      FOREACH t711_z_nme_p1 INTO l_nme24
         IF l_nme24 <> '9' THEN
            CALL cl_err('','anm-043',1)
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END IF #No.MOD-740346 
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
   #FUN-B40056  --begin
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),
             " WHERE tic04 in (",
            " SELECT nme12 FROM ",cl_get_target_table(g_plant_new,'nme_file'),
             " WHERE nme00=",p_no," )"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE t711_z_tic_p FROM g_sql
   EXECUTE t711_z_tic_p
   IF STATUS THEN
      CALL cl_err('del tic:',STATUS,1) LET g_success='N' RETURN
   END IF
   #FUN-B40056  --end 
   END IF                 #No.TQC-B70021 
  #LET g_sql="DELETE FROM ",g_dbs_nm,"nme_file",   #FUN-A50102
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'nme_file'),  #FUN-A50102
             " WHERE nme00=",p_no
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE t711_z_nme_p FROM g_sql
   EXECUTE t711_z_nme_p
   IF STATUS THEN
      CALL cl_err('del nme:',STATUS,1) LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('no nme deleted:',SQLCA.SQLCODE,1) LET g_success='N' RETURN
   END IF
END FUNCTION
 
FUNCTION t711_g_gl(p_apno,p_sw1,p_sw2)
   DEFINE p_apno           LIKE ala_file.ala01
   DEFINE p_sw1            LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 5
   DEFINE p_sw2            LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 0.初開狀   1/2/3.修改
   DEFINE l_buf            LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(70)
   DEFINE l_n              LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_ala74       LIKE ala_file.ala74
 
   LET g_success = 'Y'  #No.FUN-680029
   IF p_apno IS NULL THEN
      LET g_success = 'N' #No.FUN-680029
      RETURN
   END IF
   SELECT ala74 INTO l_ala74 FROM ala_file
    WHERE ala01=p_apno
   IF NOT cl_null(l_ala74) THEN
      LET g_success = 'N' #No.FUN-680029
      RETURN
   END IF
   BEGIN WORK  #No.FUN-680029
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE nppsys = 'LC' AND npp01 = p_apno
      AND npp00 = p_sw1 AND npp011 = p_sw2
   IF l_n > 0 THEN
      IF NOT s_ask_entry(p_apno) THEN
         LET g_success = 'N' #No.FUN-680029
         RETURN
      END IF  #Genero 
#FUN-B40056--add--str--
     LET l_n = 0 
     SELECT COUNT(*) INTO l_n FROM tic_file
      WHERE tic04 = p_apno
     IF l_n > 0 THEN
        IF NOT cl_confirm('sub-533') THEN
           LET g_success = 'N' 
           RETURN
        ELSE
           DELETE FROM tic_file WHERE tic04 = p_apno
           IF STATUS THEN
              CALL cl_err3("del","tic_file","","",STATUS,"","",1)
              LET g_success = 'N'
              ROLLBACK WORK
              RETURN
           END IF
        END IF
     END IF
#FUN-B40056--add--end-- 
      DELETE FROM npp_file
       WHERE nppsys = 'LC' AND npp01 = p_apno
         AND npp00 = p_sw1 AND npp011 = p_sw2
      IF STATUS THEN
         CALL cl_err3("del","npp_file","","",STATUS,"","",1)
         LET g_success = 'N' #No.FUN-680029
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM npq_file
       WHERE npqsys = 'LC' AND npq01 = p_apno
         AND npq00 = p_sw1 AND npq011 = p_sw2
      IF STATUS THEN
         CALL cl_err3("del","npq_file","","",STATUS,"","",1)
         LET g_success = 'N' #No.FUN-680029
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   CALL t711_g_gl_2(p_apno,p_sw1,p_sw2,'0')    #付款傳票  #No.FUN-680029 add '0'
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL t711_g_gl_2(p_apno,p_sw1,p_sw2,'1')
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t711_g_gl_2(p_apno,p_sw1,p_sw2,p_npptype)  #No.FUN-680029 add p_npptype
   DEFINE p_sw1       LIKE type_file.num5        # No.FUN-690028 SMALLINT {LC  (1.應付 2.直接付款 3.付款 4.外購)   }
   DEFINE p_sw2       LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 0.初開狀   1/2/3.修改
   DEFINE p_apno      LIKE ala_file.ala01
   DEFINE p_npptype   LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_dept      LIKE ala_file.ala04
   DEFINE l_ala            RECORD LIKE ala_file.*
   DEFINE l_pmc03     LIKE pmc_file.pmc03  #FUN-660117
   DEFINE l_npp            RECORD LIKE npp_file.*
   DEFINE l_npq            RECORD LIKE npq_file.*
   DEFINE l_aps            RECORD LIKE aps_file.*
   DEFINE l_mesg      LIKE ze_file.ze03      # No.FUN-690028 VARCHAR(30)
   DEFINE l_msg       LIKE ze_file.ze03      # No.FUN-690028 VARCHAR(30)
   DEFINE l_diff      LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_aag05     LIKE aag_file.aag05
   DEFINE l_aaa03     LIKE aaa_file.aaa03    #FUN-A40067
   DEFINE l_flag      LIKE type_file.chr1    #MOD-B50095
   DEFINE l_aag44     LIKE aag_file.aag44    #No.FUN-D40118   Add

   LET g_bookno3 = Null   #No.FUN-D40118   Add
 
   SELECT * INTO l_ala.* FROM ala_file WHERE ala01 = p_apno
   IF STATUS THEN
      LET g_success = 'N'  #No.FUN-680029
      RETURN
   END IF
   IF g_ala.alafirm='X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'  #No.FUN-680029
      RETURN
    END IF
#--FUN-9A0036 start---
   CALL s_get_bookno(YEAR(l_ala.ala08))
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(l_ala.ala08,'aoo-081',1)
      LET g_success = 'N'
      RETURN
   END IF
#--FUN-9A0036 end----
    IF g_apz.apz13 = 'Y'
       THEN LET l_dept = g_ala.ala04
       ELSE LET l_dept = ' '
    END IF
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_dept
   IF STATUS THEN INITIALIZE l_aps.* TO NULL END IF
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF l_aps.aps231 IS NULL THEN LET l_aps.aps231 = l_ala.ala42 END IF
   ELSE
      IF l_aps.aps236 IS NULL THEN LET l_aps.aps236 = l_ala.ala421 END IF
   END IF
   CALL cl_getmsg('aap-111',g_lang) RETURNING l_mesg       #預估保險費
   # 首先, Insert 一筆單頭
   INITIALIZE l_npp.* TO NULL
   LET l_npp.nppsys = 'LC'             #系統別
   LET l_npp.npp00  = p_sw1            #類別
   LET l_npp.npp01  = l_ala.ala01      #單號
   LET l_npp.npp011 = p_sw2            #異動序號
    LET l_npp.npp02  = l_ala.ala86      #異動日期 = 付款日期    #MOD-4C0040  異動日期改以付款日期為基準
   LET l_npp.npptype = p_npptype       #No.FUN-680029
   LET l_npp.npplegal = g_legal #FUN-980001 add
   INSERT INTO npp_file VALUES (l_npp.*)
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('ins npp#1',SQLCA.SQLCODE,1)
      LET g_success = 'N'  #No.FUN-680029
   END IF
 
   # 然後, Insert 其單身
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqsys = 'LC'             #系統別
   LET l_npq.npq00  = p_sw1            #類別
   LET l_npq.npq01  = l_ala.ala01      #單號
   LET l_npq.npq011 = p_sw2            #異動序號
   LET l_npq.npq02  = 0                #項次
   LET l_npq.npq07  = 0                #本幣金額
   LET l_npq.npq24  = l_ala.ala20      #幣別
   LET l_npq.npq25  = l_ala.ala51      #匯率
   LET l_npq.npqtype = p_npptype       #No.FUN-680029
   LET g_npq25 = l_npq.npq25           #FUN-9A0036

  #No.FUN-D40118 ---Add--- Start
   IF l_npq.npqtype = '1' THEN
      LET g_bookno3 = g_bookno2
   ELSE
      LET g_bookno3 = g_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End
 
   #-->廠商簡稱
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=l_ala.ala05
   IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
#--->借方科目 (應付帳款)
   LET l_npq.npq07  =
         (l_ala.ala52+l_ala.ala53+l_ala.ala54+l_ala.ala55+l_ala.ala57)
   IF l_ala.ala20=g_aza.aza17 THEN
      LET l_npq.npq07f=l_npq.npq07
   ELSE
      LET l_npq.npq07f = l_ala.ala34
   END IF
   IF l_npq.npq07 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1         #項次
      IF p_npptype = '0' THEN  #No.FUN-680029
         IF l_ala.ala73 IS NULL
            THEN LET l_npq.npq03 = l_ala.ala42     #應付科目
            ELSE LET l_npq.npq03 = l_ala.ala43     #銀存過渡科目
         END IF
      ELSE
         IF l_ala.ala73 IS NULL
            THEN LET l_npq.npq03 = l_ala.ala421
            ELSE LET l_npq.npq03 = l_ala.ala431
         END IF
      END IF
     #FUN-D10065----mark--str
     #LET l_npq.npq04 = l_ala.ala01 CLIPPED,' ',      # L/C NO
     #                  l_ala.ala20 CLIPPED,' ',      # CURR
     #                  l_ala.ala24 USING '<<<<<<<<<<.<<<'      # Amt
     #FUN-D10065----mark--end
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = g_aza.aza81                  #NO.FUN-730064
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t711_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '1'             #D/C
      LET l_npq.npq21 = l_ala.ala05     #廠商編號
      LET l_npq.npq22 = l_pmc03         #廠商簡稱
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
      LET l_npq.npq04 = NULL #FUN-D10065 add
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_aza.aza81)    #NO.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_ala.ala01 CLIPPED,' ',      # L/C NO
                           l_ala.ala20 CLIPPED,' ',      # CURR
                           l_ala.ala24 USING '<<<<<<<<<<.<<<'      # Amt
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_aza.aza81)               #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087 add
      LET l_npq.npqlegal = g_legal #FUN-980001 add
#No.FUN-9A0036 --Begin                                                          
      IF p_npptype = '1' THEN                                                   
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","ins npq-1",1)  #No.FUN-660122
         LET g_success = 'N'  #No.FUN-680029
      END IF
   END IF
#--->借方科目 (差異)
   LET l_diff = (l_ala.ala85+l_ala.ala95) -
                (l_ala.ala52+l_ala.ala53+l_ala.ala54+l_ala.ala55+l_ala.ala57)
   IF l_diff != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1

     #str CHI-B40043 add
     #aapt720沒有輸入保證金(ala56)+手續費(ala53)+郵電費(ala54),
     #但aapt711有輸入保證金(ala951)+手續費(ala952)+郵電費(ala953)時,
     #產生的差額科目應該是費用科目(aps46);反之則產生的差額科目應該是匯兌損益科目(aps42,aps43)
     # flag = 'N' 代表費用科目   #MOD-B50095 
      LET l_flag = 'N'           #MOD-B50095 
      IF l_ala.ala56+l_ala.ala53+l_ala.ala54 != l_ala.ala951+l_ala.ala952+l_ala.ala953 THEN
         IF p_npptype = '0' THEN
            LET l_npq.npq03 = l_aps.aps46
         ELSE
            LET l_npq.npq03 = l_aps.aps461
         END IF
         LET l_npq.npq07f = l_diff         #MOD-B50095
      ELSE
     #end CHI-B40043 add
         IF l_diff > 0 THEN
            IF p_npptype = '0' THEN
               LET l_npq.npq03 = l_aps.aps42
            ELSE
               LET l_npq.npq03 = l_aps.aps421
            END IF
         ELSE
            IF p_npptype = '0' THEN
               LET l_npq.npq03 = l_aps.aps43
            ELSE
               LET l_npq.npq03 = l_aps.aps431
            END IF
         END IF
         LET l_flag = 'Y'                  #MOD-B50095 
         LET l_npq.npq07f = 0              #MOD-B50095
      END IF   #CHI-B40043 add
      CALL cl_getmsg('aap-745',g_lang) RETURNING l_msg
     #LET l_npq.npq04 = l_msg          #FUN-D10065  mark
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = g_aza.aza81              #NO.FUN-730064
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t711_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '1'
     #LET l_npq.npq07f = 0              #MOD-B50095 mark
      LET l_npq.npq21 = l_ala.ala05     #廠商編號
      LET l_npq.npq22 = l_pmc03         #廠商簡稱
      LET l_npq.npq07 = l_diff
      IF l_npq.npq07 < 0 THEN
         LET l_npq.npq06 = '2' LET l_npq.npq07 = l_npq.npq07 * -1
        #-MOD-B50095-add-
         IF l_flag = 'N' THEN
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF 
        #-MOD-B50095-end-
      END IF
     LET l_npq.npq24 = g_aza.aza17
     LET l_npq.npq25 = 1
     LET g_npq25 = l_npq.npq25           #FUN-9A0036
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
      LET l_npq.npq04 = NULL #FUN-D10065 add
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_aza.aza81)      #NO.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_msg
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_aza.aza81)               #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087 add
      LET l_npq.npqlegal = g_legal #FUN-980001 add
#No.FUN-9A0036 --Begin                                                          
      IF p_npptype = '1' THEN                                                   
#FUN-A40067 --Begin                                                             
         SELECT aaa03 INTO l_aaa03 FROM aaa_file                                
          WHERE aaa01 = g_bookno2                                               
         SELECT azi04 INTO g_azi04_2 FROM azi_file                              
          WHERE azi01 = l_aaa03                                                 
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","ins npq-2",1)  #No.FUN-660122
         LET g_success = 'N'  #No.FUN-680029
      END IF
   END IF
#--->貸方科目(銀行存款-原幣保證金)
   IF l_ala.ala85 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq03 = 'bankacct'
      IF p_npptype = '0' THEN  #No.FUN-680029
         SELECT nma05 INTO l_npq.npq03 FROM nma_file WHERE nma01=l_ala.ala81
      ELSE
         SELECT nma051 INTO l_npq.npq03 FROM nma_file WHERE nma01=l_ala.ala81
      END IF
      CALL cl_getmsg('aap-744',g_lang) RETURNING l_msg
     #LET l_npq.npq04 = l_ala.ala01 CLIPPED,' ',l_msg        #FUN-D10065  mark
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t711_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '2'
      LET l_npq.npq07f= l_ala.ala34
      LET l_npq.npq21 = ' '             #廠商編號
      LET l_npq.npq22 = ' '             #廠商簡稱
      LET l_npq.npq07 = l_ala.ala85
      LET l_npq.npq24  = l_ala.ala20      #幣別
      #LET l_npq.npq25  = l_ala.ala51      #匯率#MOD-B30391 mark
      LET l_npq.npq25  = l_ala.ala84            #MOD-B30391 add
      LET g_npq25 = l_npq.npq25           #FUN-9A0036
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
      LET l_npq.npq04 = NULL #FUN-D10065 add
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_aza.aza81)         #NO.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_ala.ala01 CLIPPED,' ',l_msg
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_aza.aza81)               #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087 add
      LET l_npq.npqlegal = g_legal #FUN-980001 add
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS OR SQLCA.SQLCODE THEN
        CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","ins npq-3",1)  #No.FUN-660122
        LET g_success = 'N'  #No.FUN-680029
      END IF
   END IF
#--->貸方科目(銀行存款-本幣保證金+手續費)
   IF l_ala.ala95 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         SELECT nma05 INTO l_npq.npq03
           FROM nma_file WHERE nma01=l_ala.ala91
      ELSE
         SELECT nma051 INTO l_npq.npq03
           FROM nma_file WHERE nma01=l_ala.ala91
      END IF
      IF g_apz.apz52 = '1' AND l_ala.ala92='1' THEN
         IF p_npptype = '0' THEN  #No.FUN-680029
            LET l_npq.npq03 = l_aps.aps24      # 貸: 應付票據
         ELSE
            LET l_npq.npq03 = l_aps.aps241
         END IF
      END IF
     #IF l_ala.ala85 != 0 THEN                      #MOD-B30295 mark
      IF l_ala.ala85 != 0 OR l_ala.ala951 = 0 THEN  #MOD-B30295
        #LET l_npq.npq04 = l_ala.ala01 CLIPPED,' ', '開狀手續費'    #FUN-D10065  mark
        #-MOD-B50095-add-
         IF l_flag = 'N' THEN
            LET l_npq.npq07f = l_ala.ala95  
         ELSE
        #-MOD-B50095-end-
            LET l_npq.npq07f= 0             
         END IF   #MOD-B50095
         LET l_npq.npq24  = g_aza.aza17      #幣別
         LET l_npq.npq25  = 1      #匯率
      ELSE 
         LET l_npq.npq04 = l_ala.ala01 CLIPPED,' ', '開狀保証金+手續費'
         LET l_npq.npq07f= l_ala.ala34
         LET l_npq.npq24  = l_ala.ala20      #幣別
         LET l_npq.npq25  = l_ala.ala51      #匯率
      END IF
      LET g_npq25 = l_npq.npq25           #FUN-9A0036
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = g_aza.aza81        #NO.FUN-730064
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t711_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '2'
      LET l_npq.npq21 = ' '             #廠商編號
      LET l_npq.npq22 = ' '             #廠商簡稱
      LET l_npq.npq07 = l_ala.ala95
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
      LET l_npq.npq04 = NULL #FUN-D10065 add
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_aza.aza81)      #NO.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         IF l_ala.ala85 != 0 OR l_ala.ala951 = 0 THEN
            LET l_npq.npq04 = l_ala.ala01 CLIPPED,' ', '開狀手續費'
         ELSE
            LET l_npq.npq04 = l_ala.ala01 CLIPPED,' ', '開狀保証金+手續費'
         END IF
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_aza.aza81)               #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087 add
      LET l_npq.npqlegal = g_legal #FUN-980001 add
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","ins npq-3",1)  #No.FUN-660122
         LET g_success = 'N'  #No.FUN-680029
      END IF
 
   END IF
   CALL t110_gen_diff(l_npp.*)              #FUN-A40033 Add
   CALL s_flows('3',g_bookno1,l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021
END FUNCTION
 
FUNCTION t711_carry_voucher()
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
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102   
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_ala.ala74,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
    PREPARE aba_pre2 FROM l_sql
    DECLARE aba_cs2 CURSOR FOR aba_pre2
    OPEN aba_cs2
    FETCH aba_cs2 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_ala.ala74,'aap-991',1)
       RETURN
    END IF
 
    #開窗作業
    LET g_plant_new= g_apz.apz02p
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
    LET g_plant_gl = g_apz.apz02p   #No.FUN-980059
 
    OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("axrt200_p")
 
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("gl_no1",FALSE)
    END IF
     
    INPUT l_apygslp,l_apygslp1 WITHOUT DEFAULTS FROM FORMONLY.gl_no,FORMONLY.gl_no1  #No.FUN-680029 add l_apyglsp1
    
       AFTER FIELD gl_no
          CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_plant_gl)     #No.TQC-9B0162
                RETURNING li_result,l_apygslp
          IF (NOT li_result) THEN
             NEXT FIELD gl_no
          END IF
    
       AFTER FIELD gl_no1
          CALL s_check_no("agl",l_apygslp1,"","1","aac_file","aac01",g_plant_gl)    #No.TQC-9B0162
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
             NEXT FIELD gl_no  
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
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp1,'1',' ',' ','AGL') #No.FUN-980059
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
       CALL cl_err(g_ala.ala01,'axr-070',1)
       RETURN
    END IF
    CALL s_get_doc_no(l_apygslp) RETURNING g_t1
    LET g_wc_gl = 'npp01 = "',g_ala.ala01,'" AND npp011 = 0'
    LET g_str="aapp800 '",g_wc_gl CLIPPED,"' '",g_plant,"' '4' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_t1,"' '",g_ala.ala08,"' 'Y' '0' 'Y' '",g_apz.apz02c,"' '",l_apygslp1,"'"  #No.FUN-680029
    CALL cl_cmdrun_wait(g_str)
    SELECT ala74 INTO g_ala.ala74 FROM ala_file
     WHERE ala01 = g_ala.ala01
    DISPLAY BY NAME g_ala.ala74
    
END FUNCTION
 
FUNCTION t711_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
 #DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000) #MOD-CB0038 mark
  DEFINE l_sql      STRING                 #MOD-CB0038 add
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_ala.ala74,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_ala.ala74,'axr-071',1)
       RETURN
    END IF
    LET g_str="aapp810 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_ala.ala74,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT ala74 INTO g_ala.ala74 FROM ala_file
     WHERE ala01 = g_ala.ala01
    DISPLAY BY NAME g_ala.ala74
END FUNCTION
FUNCTION t711_ala04()
DEFINE l_gemacti LIKE gem_file.gemacti
    SELECT gemacti INTO l_gemacti
      FROM gem_file WHERE gem01 = g_ala.ala04
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
END FUNCTION
 
FUNCTION t711_set_npq05(p_dept,p_ala930)
DEFINE p_dept   LIKE gem_file.gem01,
       p_ala930 LIKE ala_file.ala930
       
   IF g_aaz.aaz90='Y' THEN
      RETURN p_ala930
   ELSE
      RETURN p_dept
   END IF
END FUNCTION
#No.FUN-A40033 --Begin
FUNCTION t110_gen_diff(p_npp)
DEFINE p_npp   RECORD LIKE npp_file.*
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   IF p_npp.npptype = '1' THEN
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno2
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
         #FUN-D10065--add--str--
         CALL s_def_npq3(g_bookno1,l_npq1.npq03,g_prog,l_npq1.npq01,'','')
         RETURNING l_npq1.npq04
         #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno2
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno2) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",p_npp.npp01,"",STATUS,"","",1) #FUN-670091
            LET g_success = 'N'
            ROLLBACK WORK
         END IF   
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
 
#No.FUN-9C0077 程式精簡

