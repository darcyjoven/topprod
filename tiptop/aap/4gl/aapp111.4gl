# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Pattern name...: aapp111.4gl
# Descriptions...: 退貨折讓產生
# Date & Author..: 92/12/23 By Roger
# Modify.........: 97/05/13 By Danny 將insert apk_file 刪除
# Modify.........: No.7618 03/07/18 Kammy 發票金額不可直接塞入庫金額，
#                                         應塞退貨金額
# Modify.........: No.8680 03/11/07 Kitty 增加稅別開窗
# Modify.........: No.9518 04/05/05 Kitty line 270行apa13判斷改為用cl_null
# Modify.........: No.B025 04/07/07 Kammy Transaction 控管加強
# Modify.........: No.MOD-510140 05/03/01 By Kitty ins_apk金額錯誤,只有第一筆
# Modify.........: No.MOD-530447 05/03/29 By Nicola 倉退產生折讓資料，付款廠商簡稱不對
# Modify.........: No.FUN-550030 05/05/12 By jackie 單據編號加大
# Modify.........: No.FUN-560002 05/06/03 By Will 單據編號修改
# Modify.........: No.FUN-560091 05/06/16 By Clinton 單位數量改抓計價單位計價數>
# Modify.........: No.FUN-570042 05/07/05 By ching default 折讓付款日=帳款日
# Modify.........: No.MOD-570169 05/07/11 By Smapmin FOREACH p111_cs 前加入LET t_vendor=NULL,LET t_curr=' '
# Modify.........: No.MOD-570214 05/08/03 By Smapmin 拿掉判斷式
# Modify.........: No.FUN-580006 05/08/11 By ice 是否使用進項防偽稅控接口
# Modify.........: No.MOD-590440 05/11/03 By ice 依月底重評價對AP未付金額調整,修正未付金額apa73的計算方法
# Modify.........: No.MOD-5B0210 05/11/23 By Smapmin 拋轉後簽核欄位為NULL
# Modify.........: No.MOD-5B0139 05/12/08 By Smampin apb25按 apa51='STOCK'的邏輯重新抓取科目資料
# Modify.........: No.FUN-5B0089 05/12/30 By Rosayu 產生apa資料後要加判斷單別設定產生分錄底稿
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.TQC-640193 06/04/28 By Smapmin 單別抓取有誤
# Modify.........: No.MOD-660033 06/06/12 By Smapmin 應將多角單據排除在外
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.........: No.MOD-680011 06/08/02 By Smapmin apmt722 可無需輸入採購資料,故移除 pmn_file 的 link
# Modify.........: No.FUN-680027 06/08/14 By Rayven 多帳期修改
# Modify.........: No.FUN-680029 06/08/17 By Rayven 新增多帳套功能
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By Jackho 本（原）幣取位修改
# Modify.........: No.TQC-6B0066 06/12/13 By Rayven 對原幣和本幣合計按幣種進行截位
# Modify.........: No.FUN-710014 07/01/10 By cheunl 錯誤訊息匯整
# Modify.........: No.TQC-740142 07/04/19 By Rayven 根據幣種對小數位截位
# Modify.........: No.TQC-790080 07/09/12 By wujie  若apa64為null，則pac05=apc04
# Modify.........: No.TQC-790130 07/09/26 By chenl  1.在QBE條件里增加查詢條件，發票號碼和廠商編碼
#                                                   2.增加付款條件，付款日期，票據到期日和發票號碼
# Modify.........: No.TQC-790132 07/09/26 By xufeng 當前生成的應付帳款的發票金額是入庫/倉退單中入庫/退貨的金額,
#                                                   而不是入庫/倉退發票資料檔中發票資料
# Modify.........: No.MOD-790056 07/10/05 By Smapmin 匯率/金額取位
# Modify.........: No.MOD-7B0150 07/11/15 By chenl  增加傳入參數g_rvw01發票號碼，并將該號碼顯示到對應界面欄位上。此增加僅針對gapi140調用該程序時，顯示發票號碼。
# Modify.........: No.TQC-7B0083 07/11/21 By Carrier 1.納暫估數量rvv88進行計算/插入多帳期資料apc_file位置修正
#                                                    2.同一請款單分錄僅產生一次,否則每次都要報"分錄已產生,是否重新產生"
#                                                    3.生成至aapt210中的數量為負,要修改成正的
#                                                    4.加入衝暫估功能
# Modify.........: No.TQC-7B0160 07/11/30 By Chenl   傳參rvb22變成rvw01
# Modify.........: No.MOD-7B0207 07/12/07 By Smapmin 修正TQC-790130
# Modify.........: No.MOD-810170 08/01/22 By Smapmin 判斷暫估退貨資料時,多加作廢否的判斷
# Modify.........: No.MOD-820081 08/02/28 By Smapmin 屬於沖暫估帳款才寫入api_file
# Modify.........: No.FUN-810045 08/03/24 By rainy 項目管理，專案相關欄位代入pab_file
# Modify.........: No.FUN-840006 08/04/02 By hellen項目管理，去掉預算編號相關欄位
# Modify.........: No.CHI-840003 08/04/07 By Smapmin 因為aapt210修改單身時,delete/update apk_file的原則為單身項次串到發票檔項次.
#                                                    故發票檔insert的原則也應一致.
# Modify.........: No.CHI-850032 08/06/07 By Sarah 當rvv17(異動數量)=0時,則apa58='3'(扣款折讓)
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.CHI-860024 08/07/09 By Sarah 1.產生aapt210時會有重複問題,請修改產生至單身依明細產生 2.取消UPDATE apb11 = MISC段
# Modify.........: No.MOD-870235 08/07/21 By chenl 若apa00='26'則插入api時，將金額改寫為負數，以保証資料拋轉后與aapt220中衝暫估的邏輯一致。
# Modify.........: No.MOD-870210 08/07/23 By Sarah p111_ins_apb_2()段,不需卡g_apb.apb11不為NULL才可INSERT INTO apb_file
# Modify.........: No.MOD-880132 08/08/18 By chenl 修正MOD-870235。該單修改內容應去除。
# Modify.........: No.MOD-890156 08/09/22 By chenyu p111_ins_apb_2()這個FUNCTION中，insert單身的時候要考慮發票號碼
# Modify.........: No.MOD-890188 08/10/01 By Sarah CALL p111_ins_apk()前增加判斷apb11<>' '才需寫入apk_file
# Modify.........: No.MOD-8A0036 08/10/15 By Sarah 大陸版,當畫面稅別(apa15),稅率(apa16)沒有輸入時,抓gapi140的稅別,稅率
# Modify.........: No.MOD-8B0064 08/11/06 By Sarah 在抓g_apb.apb27前,先清空變數,以免殘留前值
# Modify.........: No.MOD-8B0199 08/11/20 By Sarah 大陸版時匯率請抓取發票匯率rvw12
# Modify.........: No.CHI-8B0055 08/11/27 By claire 中斷點的多角倉退單使用本作業拋折讓
# Modify.........: No.MOD-910014 09/01/05 By Nicola 數量為0 時，api05/api05f直接帶暫估金額
# Modify.........: No.MOD-920263 09/02/26 By Sarah INSERT apb_file前檢查發票號碼(apb11)對應的1*類帳款已確認才可寫入
# Modify.........: No.MOD-930035 09/03/04 By lilingyu 產生到aapt210,未給apa63預設值
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.MOD-940070 09/03/07 By lilingyu api05 api05f未做幣別取位
# Modify.........: No.FUN-940083 09/05/25 By zhaijie批處理邏輯改善
# Modify.........: No.FUN-960141 09/06/29 By dongbg GP5.2修改:增加門店編號欄位
# Modify.........: No.MOD-970246 09/07/27 By mike CHI-8B0055在g_sql增加抓rvu08,寫成"       rvu08 ", 應改成"      ,rvu08 ",
# Modify.........: No.FUN-980001 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/25 By hongmei 抓apz63欄位寫入apa77
# Modify.........: No.FUN-990014 09/09/08 By hongmei 先抓apyvcode申報統編，若無則將apz63的值寫入apa77/apk32
# Modify.........: No:MOD-990168 09/10/21 By mike 调整抓取 apyapr 方式     
# Modify.........: No.FUN-990031 09/10/22 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下,条件选项来源营运中心隐藏中心隐藏 
# Modify.........: No.FUN-9A0093 09/11/02 By lutingting拋轉apb時給欄位apb37賦值
# Modify.........: No.FUN-9C0001 09/12/07 By lutingting QBE門店編號改為來源營運中心,實現可由當前法人下DB得退貨單產生應付賬款
# Modify.........: No.FUN-9C0041 09/12/10 By lutingting t110_stock_act加傳參數營運管中心 
# Modify.........: No:MOD-9C0102 09/12/23 By sabrina 在aap-271的卡關段前面增加檢查，!*類帳款是否已產生
#                                                    若還沒產生則不可產生折讓 
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No:MOD-A10039 10/01/13 By wujie   单价抓发票单价，不是仓退单单价
# Modify.........: No.FUN-A20006 10/02/03 By lutingting 相關sql加上apb37得條件
# Modify.........: No:TQC-A40065 10/04/13 BY xiaofeizhu ¦P¤@¼t°ӡA¦P¤@¹ôA¤£¦Pµ|§O3¸ӥͦ¨¤£¦Pªº§é³æ
# Modify.........: No:CHI-A10006 10/04/19 By Summer 寫入api_file段,若原幣金額加總為剩餘未沖原幣金額,
#                                                   則本幣金額也應全數沖完,將尾差調在金額最大的一筆上
# Modify.........: No:MOD-A40180 10/04/30 By sabrina 當g_aza.aza26='1'時將畫面的rvw01隱藏
# Modify.........: No:TQC-9C0079 10/05/04 By Sarah 因為CALL s_aapt110_gl.4gl後會造成aapp111的TRANSACTION失效,建議產生分錄段移到最後
# Modify.........: No:TQC-950101 10/05/06 By Sarah 非大陸版時,應卡若apb11(發票號碼)為NULL時不可寫入apb_file
# Modify.........: No:FUN-A40003 10/05/21 By wujie   增加apa79，预设为N
# Modify.........: No:FUN-A60024 10/06/12 By wujie   调整apa79的值为0 
# Modify.........: No.FUN-A50102 10/07/21 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A90062 10/09/08 By Dido 取消 rvv17 = 0 時新增 apk_file(非大陸版) 
# Modify.........: No:CHI-A90002 10/10/06 By Summer 應過濾pmcacti='Y'才能立帳
# Modify.........: No:MOD-AA0090 10/10/15 By Dido 於 s_showmsg_init 之前只可使用 g_success 處理 
# Modify.........: No:MOD-AB0037 10/11/04 By Dido 若無 apb11 則帶 rvu15 為預設值 
# Modify.........: No:MOD-AB0111 10/11/11 By Dido 檢核 amd_file 是否存在此發票 
# Modify.........: No:TQC-AB0065 10/11/18 By wujie  无数量有金额的暂估单会漏掉
# Modify.........: No:CHI-AB0011 10/11/19 By Summer QBE增加採購人員(pmm12) 
# Modify.........: No:MOD-AB0206 10/11/23 By Dido api05 計算邏輯調整 
# Modify.........: No:MOD-AC0128 10/12/16 By Dido 產生折讓時 apa171 需轉換 
# Modify.........: No:MOD-B30700 11/03/30 By yinhy gapi140在調用aapp111的時候，發票號碼無法帶出
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:MOD-B40008 11/04/06 By Dido 調整 rvv87 = 0 條件 
# Modify.........: No:MOD-B40074 11/04/12 By Sarah 修正MOD-AB0206,當數量為0時不應用數量*單價來重算金額
# Modify.........: No:FUN-B50016 11/05/04 By Guoch 發票編號開創查詢
# Modify.........: No:MOD-B50028 11/05/05 By Dido 取消多角單類別檢核 
# Modify.........: No:MOD-B50074 11/05/10 By Dido 排除 rvv89/rvb89 = 'Y' 資料 
# Modify.........: NO.TQC-B60093 11/06/17 By Polly 延續FUN-A40041處理，調整g_sys為實際系統代號
# Modify.........: NO.MOD-B80034 11/08/03 By Dido 變數調整
# Modify.........: No.FUN-B80058 11/08/05 By lixia 兩套帳內容修改，新增azf141
# Modify.........: No.TQC-B80156 11/08/23 By guoch rvv01栏位进行控管
# Modify.........: No.TQC-B80250 11/08/31 By guoch apz13为Y,apa22不为空，apa36不需要设置必要栏位
# Modify.........: No.TQC-B90006 11/09/05 By guoch mark TQC-B80250
# Modify.........: No.TQC-B90072 11/09/08 By guoch  营运中心赋默认值
# Modify.........: No.MOD-BA0134 11/10/20 By polly 修正無合乎條件時秀出執行失敗訊息
# Modify.........: No.TQC-BA0177 11/10/28 By yinhy 賬款日不可小于入庫日
# Modify.........: No.MOD-BB0152 11/11/16 By Polly 調整apmt722是無來源倉退單，在執行aapp111無法抓到匯率率、稅別、稅率、幣別
# Modify.........: No.FUN-BB0002 11/11/29 By pauline rvb22無資料時進入取rvv22
# Modify.........: No.TQC-BB0131 11/11/29 By pauline insert apa_file 時apa76給與ruv21
# Modify.........: No:MOD-BC0061 11/12/07 By yinhy p111_cs排除aapt110中已經立賬的資料
# Modify.........: No.MOD-C10001 12/01/02 By Polly FOREACH p111_cs 前將 start_no 與 end_no 清空
# Modify.........: No:TQC-C10046 12/01/12 By yinhy 修正MOD-BC0061 大陸版p111_cs排除aapt210中已經立賬的資料
# Modify.........: No.TQC-C10017 12/02/10 By yinhy 調整apb25，apb26，apb27，apb36，apb31，apb930欄位的值
# Modify.........: No:MOD-C50114 12/05/18 By Polly 若字串中有*號，則不做 aap-444 檢核
# Modify.........: No:MOD-C60015 12/06/08 By Elise QBE時切換語言別會跑到 INPUT
# Modify.........: No:MOD-C60112 12/06/13 By yinhy 用aza26參數分開,大陸功能下把gapi140上的發票號碼寫到aapt210單頭apa08上
# Modify.........: No.FUN-C60071 12/06/27 By suncx FOR l_i = 1 TO l_cnt1  至 END FOR中的SQL中含rvv25 = 'N'的改為rvv25<>'Y'
# Modify.........: No.FUN-C70052 12/07/12 By xuxz 區分採購性質立帳選項
# Modify.........: No.TQC-C70162 12/07/24 By zhangweib 调整start_no和end_no初始化位置,將其移動至抓法人代碼之前
# Modify.........: No.FUN-C80022 12/08/07 By xuxz mod  FUN-C70052 添加採購性質下拉框
# Modify.........: No.FUN-CB0048 13/01/09 By zhangweib 增加rvw18(帳款編號),產生應付賬款時回寫帳款編號到rvw18
# Modify.........: No.FUN-CB0053 13/01/09 By zhangweib 修改g_apa.apa02的初值，如果為背景作業則接收傳入的參數
# Modify.........: No.MOD-D20134 13/03/15 By Vampire 多角單據走一般銷退/倉退後,屬於一般單據應可產生
# Modify.........: No.MOD-D60145 13/06/18 By yinhy 判斷若是留置廠商不可更新金額
# Modify.........: No:TQC-D80023 13/08/14 By lixh1 修改發票編號賦值問題
# Modify.........: No.FUN-D70021 13/07/04 By wangrr MISC料件不判斷跨月是否立暫估

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE t_azi           RECORD LIKE azi_file.*,
       g_azi           RECORD LIKE azi_file.*,
       rvv03_sw        LIKE rvv_file.rvv03,    #FUN-660117
       body_no         LIKE type_file.num5,    #No.FUN-690028 SMALLINT,
       trtype          LIKE apy_file.apyslip,  #No.FUN-690028 VARCHAR(5),  #No.FUN-550030
       purchas_sw      LIKE type_file.chr1,   #No.FUN-C70052 VARCHAR(1),
       g_vendor        LIKE rvv_file.rvv06,    #FUN-660117 #CHAR(10)
       g_vendor2       LIKE pmc_file.pmc04,    #FUN-660117 #CHAR(10)
       g_abbr          LIKE pmc_file.pmc03,    #FUN-660117 #CHAR(10)
       g_cur           LIKE aza_file.aza17,    #FUN-660117 #CHAR(04)
       t_vendor        LIKE rvv_file.rvv06,    #FUN-660117 #CHAR(10)
       t_curr          LIKE apa_file.apa13,    #no.5373
       start_no        LIKE apa_file.apa01,    #FUN-660117 #CHAR(16)
       end_no          LIKE apa_file.apa01,    #FUN-660117 #CHAR(16)
       g_apa           RECORD LIKE apa_file.*,
       g_apb           RECORD LIKE apb_file.*,
       g_apc           RECORD LIKE apc_file.*, #No.FUN-680027
       g_change_lang   LIKE type_file.chr1,    #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
       g_wc,g_sql      STRING                  #No.FUN-580092 HCN
DEFINE g_wc3           STRING  #CHI-AB0011 add
DEFINE g_aps           RECORD LIKE aps_file.*  #No.TQC-7B0083
DEFINE g_net           LIKE apv_file.apv04     #MOD-590440
DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-690028 SMALLINT
DEFINE g_cnt           LIKE type_file.num10    #No.FUN-690028 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE source          LIKE zx_file.zx08       # No.FUN-690028 VARCHAR(10)     #FUN-630043
DEFINE g_rvv930        LIKE rvv_file.rvv930    #FUN-670064
DEFINE g_rvv17         LIKE rvv_file.rvv17     #CHI-850032
DEFINE g_rvw03         LIKE rvw_file.rvw03     #MOD-8A0036 add
DEFINE g_gec031        LIKE gec_file.gec031    #No.FUN-680029
DEFINE g_pmn401        LIKE pmn_file.pmn401    #No.FUN-680029
DEFINE g_rvw01         LIKE rvw_file.rvw01     #No.MOD-7B0150
DEFINE lg_rvw01        LIKE rvw_file.rvw01     #No.MOD-890156
DEFINE g_rvuplant      LIKE rvu_file.rvuplant  #FUN-960141
DEFINE t_rvuplant      LIKE rvu_file.rvuplant  #FUN-960141
DEFINE g_wc2           STRING                  #FUN-9C0001
DEFINE l_dbs           LIKE type_file.chr21    #FUN-9C0001
DEFINE l_azp01         LIKE azp_file.azp01     #FUN-9C0001 
DEFINE t_azp01         LIKE azp_file.azp01     #FUN-9C0001
DEFINE t_azp03         LIKE azp_file.azp03     #FUN-9C0001
DEFINE t_tax           LIKE apa_file.apa15     #TQC-A40065 Add
DEFINE g_apa_gl        DYNAMIC ARRAY OF RECORD #TQC-9C0079 add
                        apa00  LIKE apa_file.apa00,
                        apa01  LIKE apa_file.apa01,
                        azp01  LIKE azp_file.azp01
                       END RECORD
DEFINE g_apb24t        LIKE apb_file.apb24     #MOD-AB0206   #含稅金額
DEFINE g_apa34    LIKE apa_file.apa34   #No.FUN-CB0048   Add
DEFINE g_rvw01_s  LIKE rvw_file.rvw01   #No.FUN-CB0048   Add
DEFINE g_apa01_s  LIKE apa_file.apa01   #No.FUN-CB0048   Add
 
MAIN
   DEFINE ls_date       STRING    #->No.FUN-570112
   DEFINE l_flag        LIKE type_file.chr1    #->No.FUN-570112  #No.FUN-690028 VARCHAR(1)
 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc           = ARG_VAL(1)       #QBE條件
   LET rvv03_sw       = ARG_VAL(2)       #退貨類型
   LET body_no        = ARG_VAL(3)       #折讓單身儲存筆數
   LET trtype         = ARG_VAL(4)       #折讓帳款單別
   LET ls_date        = ARG_VAL(5)
   LET g_apa.apa02    = cl_batch_bg_date_convert(ls_date)   #帳款日期
   LET g_apa.apa15    = ARG_VAL(6)       #稅別
   LET g_apa.apa16    = ARG_VAL(7)       #稅率
   LET g_apa.apa21    = ARG_VAL(8)       #帳款人員
   LET g_apa.apa22    = ARG_VAL(9)       #帳款部門
   LET g_apa.apa36    = ARG_VAL(10)      #帳款類別
   LET g_bgjob        = ARG_VAL(11)      #背景作業
   LET g_rvw01        = ARG_VAL(12)      #發票號碼   #No.MOD-7B0150
   LET g_wc3          = ARG_VAL(13)      #CHI-AB0011 add
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
 
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p111()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p111_process()
            CALL s_showmsg()            #No.FUN-710014
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p111_process()
         CALL s_showmsg()            #No.FUN-710014
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE



   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055

 
END MAIN
 
FUNCTION p111()
   DEFINE l_gec05   LIKE gec_file.gec05      
   DEFINE li_result LIKE type_file.num5              #No.FUN-560002  #No.FUN-690028 SMALLINT
   DEFINE lc_cmd    LIKE type_file.chr1000 # No.FUN-690028 VARCHAR(500)           #No.FUN-570112
   DEFINE l_azp02   LIKE azp_file.azp02   #FUN-630043
   DEFINE l_azp03   LIKE azp_file.azp03   #FUN-630043
   DEFINE l_rvv01   LIKE rvv_file.rvv01   #TQC-B80156
   DEFINE tok base.StringTokenizer        #TQC-B80156
   DEFINE l_cnt     LIKE type_file.num5   #TQC-B80156
   DEFINE l_flg     LIKE type_file.chr1   #TQC-B80156 
   DEFINE l_a       STRING                #TQC-B80156
   DEFINE l_str     STRING                #MOD-C50114 add 
   DEFINE ls_date       STRING   #No.FUN-CB0053
   DEFINE l_rvv09k LIKE rvv_file.rvv09  #add by kuangxj170823

   WHILE TRUE
 
      LET g_action_choice = ""
      OPEN WINDOW p111_w AT p_row,p_col
         WITH FORM "aap/42f/aapp111" ATTRIBUTE (STYLE = g_win_style)
 
      CALL cl_ui_init()
 
      CALL cl_set_comp_visible("group05", FALSE)   #FUN-990031  
 
      CLEAR FORM


     #MOD-A40180---add---start---
      IF g_aza.aza26 = '2' THEN
         CALL cl_set_comp_visible("rvw01",TRUE)   
      ELSE
         CALL cl_set_comp_visible("rvw01",FALSE)   
      END IF
     #MOD-A40180---add---end---
 
      WHILE TRUE
      
           CONSTRUCT BY NAME g_wc2 ON azp01

              ON ACTION locale
                 LET g_change_lang = TRUE    
                 EXIT CONSTRUCT

              BEFORE CONSTRUCT
                  CALL cl_qbe_init()
                  DISPLAY g_plant TO azp01      #TQC-B90072 add

              ON ACTION exit
                 LET INT_FLAG = 1
                 EXIT CONSTRUCT

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

              ON ACTION CONTROLP
                 CASE
                   WHEN INFIELD(azp01)   #來源營運中心
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_azw"     
                        LET g_qryparam.where = "azw02 = '",g_legal,"' "
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO azp01
                        NEXT FIELD azp01
                 END CASE
           END CONSTRUCT

           IF g_change_lang THEN
              LET g_change_lang = FALSE
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()  
             #EXIT WHILE      #MOD-C60015 mark
              CONTINUE WHILE  #MOD-C60015
           END IF
           
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              CLOSE WINDOW p111_w
              CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
              EXIT PROGRAM
           END IF
          
         IF cl_null(g_rvw01) THEN
           CONSTRUCT BY NAME g_wc ON rvv01,rvv09,             #FUN-9C0001
                                     rvw01,rvu04      #add by chenl No.TQC-790130   #MOD-810170
              BEFORE CONSTRUCT
                  CALL cl_qbe_init()
                  
             #TQC-B80156  --begin
              AFTER FIELD rvv01
                #------------------MOD-C50114-----------------(S)
                 LET l_str = GET_FLDBUF(rvv01)
                 LET l_cnt = l_str.getIndexOf('*',1)
                 IF l_cnt = 0 THEN
                #------------------MOD-C50114-----------------(E)
                    CALL s_showmsg_init()
                    LET l_flg = 'Y'
                    LET l_a = GET_FLDBUF(rvv01)
                    LET tok = base.StringTokenizer.create(l_a,"|")
                    WHILE tok.hasMoreTokens()
                        LET l_rvv01 = tok.nextToken()
                        SELECT COUNT(rvu01) INTO l_cnt FROM rvu_file,rvv_file
                         WHERE rvu00 = '3' 
                           AND rvuconf = 'Y' 
                           AND rvv01 = rvu01 
                           AND rvv01 = l_rvv01
                        IF l_cnt <= 0 OR cl_null(l_cnt) THEN
                           LET l_flg = 'N'
                           CALL s_errmsg('rvv01',l_rvv01,'sel_rvv01','aap-444',1)
                        END IF
                    END WHILE 
                    CALL s_showmsg()
                    IF l_flg = 'N' THEN
                       NEXT FIELD rvv01
                    END IF
             #TQC-B80156  --end
                 END IF                      #MOD-C50114 add
 
              ON ACTION CONTROLP
                 CASE
                   WHEN INFIELD(rvv01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_rvu01'
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO FORMONLY.rvv01
                     NEXT FIELD rvv01
                   WHEN INFIELD(rvu04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_pmc'
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO FORMONLY.rvu04
                     NEXT FIELD rvu04
#FUN-B50016 --begin
                   WHEN INFIELD(rvw01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_rvw1'
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvw01
                     NEXT FIELD rvw01
                 END CASE
#FUN-B50016 --end
              ON ACTION locale
                 LET g_change_lang = TRUE       #->No.FUN-570112
                 EXIT CONSTRUCT
 
              ON ACTION exit
                 LET INT_FLAG = 1
                 EXIT CONSTRUCT
 
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
 
           END CONSTRUCT
           LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
          #MOD-C60015---S---
           IF g_change_lang THEN
              LET g_change_lang = FALSE
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()
              CONTINUE WHILE
           END IF

           IF INT_FLAG THEN
              LET INT_FLAG = 0
              CLOSE WINDOW p111_w
              CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
              EXIT PROGRAM
           END IF
          #MOD-C60015---E---
         #No.MOD-B30700 --Mark Begin
         #CHI-AB0011 add --start--
         # IF NOT cl_null(g_rvw01) THEN
         #    DISPLAY g_rvw01 TO FORMONLY.rvw01
         #    LET g_wc = "rvw01 = '",g_rvw01,"'"  #No.TQC-7B0160
         # END IF
         #  
         # IF g_wc = ' 1=1' THEN
         #    CALL cl_err('','9046',0)
         #    CONTINUE WHILE
         # END IF
         #CHI-AB0011 add --end--
         #No.MOD-B30700 --Mark End

          #CHI-AB0011 add --start--
           CONSTRUCT BY NAME g_wc3 ON pmm12 

             ON ACTION locale
                LET g_change_lang = TRUE
                EXIT CONSTRUCT

             BEFORE CONSTRUCT
                 CALL cl_qbe_init()

             ON ACTION CONTROLP
                CASE
                   WHEN INFIELD(pmm12) #採購員
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gen"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO pmm12
                      NEXT FIELD pmm12
                END CASE

             ON ACTION exit
                LET INT_FLAG = 1
                EXIT CONSTRUCT

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

          END CONSTRUCT
          #CHI-AB0011 add --end--

        END IF    #No.MOD-7B0150
 

        IF g_change_lang THEN
           LET g_change_lang = FALSE
           CALL cl_dynamic_locale() 
           CALL cl_show_fld_cont()  #MOD-C60015
          #EXIT WHILE       #MOD-C60015 mark
           CONTINUE WHILE   #MOD-C60015
        END IF
 
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CLOSE WINDOW p111_w
           CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
           EXIT PROGRAM
        END IF
       #No.MOD-B30700 --Begin去掉mark
       #CHI-AB0011 mark --start--
       IF NOT cl_null(g_rvw01) THEN
          DISPLAY g_rvw01 TO FORMONLY.rvw01
          LET g_wc = "rvw01 = '",g_rvw01,"'"  #No.TQC-7B0160
       END IF
        
       IF g_wc = ' 1=1' THEN
          CALL cl_err('','9046',0)
          CONTINUE WHILE
       END IF
       #CHI-AB0011 mark --end--
       #No.MOD-B30700 --End去掉mark
 
        EXIT WHILE
      END WHILE
 
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
 
      LET rvv03_sw = '3'
      # LET body_no = 4
      LET purchas_sw = '1' #FUN-C70052 add#FUN-C80022 mod N--->1
      INITIALIZE g_apa.* TO NULL
     #LET g_apa.apa02 = g_today  #No.FUN-CB0053  Mark
     #No.FUN-CB0053 ---start--- Add
      IF g_bgjob = "N" OR cl_null(g_wc) THEN
         LET ls_date        = ARG_VAL(5)
         LET g_apa.apa02    = cl_batch_bg_date_convert(ls_date)   #帳款日期
      ELSE
         LET g_apa.apa02 = g_today
      END IF
     #No.FUN-CB0053 ---end  --- Add
      LET g_apa.apa21 = g_user
      LET g_apa.apa22 = g_grup
      LET g_bgjob = "N"
 
      INITIALIZE g_apb.* TO NULL
 
      INPUT BY NAME purchas_sw,rvv03_sw,body_no,trtype,g_apa.apa02,g_apa.apa15,g_apa.apa16,#FUN-C70052 add purchas_sw
                    g_apa.apa21,g_apa.apa22,g_apa.apa36,g_bgjob WITHOUT DEFAULTS    #NO.FUN-570112 ADD
         BEFORE INPUT
            IF g_aza.aza26 != '2' THEN
               CALL cl_set_comp_required("apa15,apa16",TRUE)
            ELSE
               CALL cl_set_comp_required("apa15,apa16",FALSE)
            END IF
 
         AFTER FIELD body_no
            IF body_no = 0 THEN
               NEXT FIELD body_no
            END IF
 
         AFTER FIELD trtype
            IF NOT cl_null(trtype) THEN
             #CALL s_check_no(g_sys,trtype,"","21","","","")     #TQC-B60093 mark
              CALL s_check_no("aap",trtype,"","21","","","")     #TQC-B60093 add
                RETURNING li_result,trtype
              IF (NOT li_result) THEN
    	         NEXT FIELD trtype
              END IF

               LET g_apa.apamksg = g_apy.apyapr
            END IF
 
         #add by kuangxj170823 begin
         AFTER FIELD apa02 
              IF NOT cl_null(g_apa.apa02) THEN
                IF NOT cl_null(g_rvw01) THEN
                 LET l_rvv09k = ''
                 SELECT MAX(rvv09) INTO l_rvv09k FROM rvv_file,rvw_file WHERE rvw01 = g_rvw01 AND rvv01 = rvw08

                  IF l_rvv09k > g_apa.apa02  THEN
                     CALL cl_err('','cgap-02',1)
                     NEXT FIELD apa02
                  END IF
               END IF
             END IF 
         #add by kuangxj170823 end
 
         AFTER FIELD apa15
            IF NOT cl_null(g_apa.apa15) THEN
               LET g_gec031 = ''  #No.FUN-680029
               SELECT gec03,gec031,gec04,gec08    #No.FUN-680029 新增gec031                     #MOD-AC0128 mod gec05 -> gec08
                 INTO g_apa.apa52,g_gec031,g_apa.apa16,g_apa.apa171 #No.FUN-680029 新增g_gec031 #MOD-AC0128 mod gec05 -> apa171 
                 FROM gec_file
                WHERE gec01 = g_apa.apa15
                  AND gecacti = 'Y'
                  AND gec011 = '1' #進項
               IF STATUS THEN
                  CALL cl_err3("sel","gec_file",g_apa.apa15,"",SQLCA.sqlcode,"","",0)   #No.FUN-660122
                  NEXT FIELD apa15
               END IF
 
               IF g_aza.aza63 = 'Y' THEN
                  LET g_apa.apa521 = g_gec031
               END IF
              #-MOD-AC0128-add-
              #IF l_gec05  = '3' THEN
              #   LET g_apa.apa171 = '23'
              #ELSE
              #   LET g_apa.apa171 = '24'
              #END IF
               CASE 
                  WHEN (g_apa.apa171 = '21' OR g_apa.apa171 = '25' OR g_apa.apa171 = '26')
                    LET g_apa.apa171  = '23' 
                  WHEN (g_apa.apa171 = '22' OR g_apa.apa171 = '27')
                    LET g_apa.apa171  = '24'
                  WHEN (g_apa.apa171 = '28')
                    LET g_apa.apa171  = '29'
                  WHEN (g_apa.apa171 = 'XX')
                    LET g_apa.apa171  = 'XX'
               END CASE 
              #-MOD-AC0128-end- 
 
               DISPLAY BY NAME g_apa.apa16
            END IF
 
         AFTER FIELD apa21
            IF NOT cl_null(g_apa.apa21) THEN
               CALL p110_apa21('')
               IF NOT cl_null(g_errno) THEN                    #抱歉, 有問題
                  CALL cl_err(g_apa.apa21,g_errno,0)
                  NEXT FIELD apa21
               END IF
            END IF
 
         AFTER FIELD apa22
            IF NOT cl_null(g_apa.apa22) THEN
               CALL p110_apa22('')
               IF NOT cl_null(g_errno) THEN                    #抱歉, 有問題
                  CALL cl_err(g_apa.apa22,g_errno,0)
                  NEXT FIELD apa22
               END IF
            END IF
 
         AFTER FIELD apa36
           #TQC-B90006 mark --begin
           #TQC-B80250 -begin
           # IF NOT (g_apz.apz13 = 'Y' AND NOT cl_null(g_apa.apa22)) THEN
           #    IF cl_null(g_apa.apa36) THEN
           #       CALL cl_err('','aap-405',0)
           #       NEXT FIELD apa36
           #    END IF
           # END IF
           #TQC-B80250 -end
           #TQC-B90006 mark --end
            IF NOT cl_null(g_apa.apa36) THEN
               CALL p110_apa36('')
               IF NOT cl_null(g_errno) THEN                    #抱歉, 有問題
                  CALL cl_err(g_apa.apa36,g_errno,0)
                  NEXT FIELD apa36
               END IF
            END IF
         #TQC-B90006 mark -begin
         #TQC-B80250 -begin
        # AFTER INPUT
        #    IF  INT_FLAG THEN EXIT INPUT END IF
        #    IF NOT (g_apz.apz13 = 'Y' AND NOT cl_null(g_apa.apa22)) THEN
        #       IF cl_null(g_apa.apa36) THEN
        #          CALL cl_err('','aap-405',0)
        #          NEXT FIELD apa36
        #       END IF
        #    END IF
         #TQC-B80250 -end
         #TQC-B90006 mark --end
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(trtype) # 單別
                  CALL q_apy(FALSE,FALSE,trtype,'21','AAP') RETURNING trtype   #TQC-670008
                  DISPLAY BY NAME trtype
               WHEN INFIELD(apa15) # 稅別  No:8680
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gec"
                  LET g_qryparam.arg1 = '1'
                  LET g_qryparam.default1 = g_apa.apa15
                  CALL cl_create_qry() RETURNING g_apa.apa15
                  DISPLAY BY NAME g_apa.apa15
               WHEN INFIELD(apa21) # Class
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_apa.apa21
                  CALL cl_create_qry() RETURNING g_apa.apa21
                  DISPLAY BY NAME g_apa.apa21
               WHEN INFIELD(apa22) # Class
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_apa.apa22
                  CALL cl_create_qry() RETURNING g_apa.apa22
                  DISPLAY BY NAME g_apa.apa22
               WHEN INFIELD(apa36) # Class
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_apr"
                  LET g_qryparam.default1 = g_apa.apa36
                  CALL cl_create_qry() RETURNING g_apa.apa36
                  DISPLAY BY NAME g_apa.apa36
            END CASE
 
         ON ACTION locale
            LET g_change_lang = TRUE      #->No.FUN-570112
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p111_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aapp111"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('aapp111','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET g_wc3=cl_replace_str(g_wc3, "'", "\"") #CHI-AB0011 add
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",rvv03_sw CLIPPED,"'",
                         " '",body_no CLIPPED,"'",
                         " '",trtype CLIPPED,"'",
                         " '",g_apa.apa02 CLIPPED,"'",
                         " '",g_apa.apa15 CLIPPED,"'",
                         " '",g_apa.apa16 CLIPPED,"'",
                         " '",g_apa.apa21 CLIPPED,"'",
                         " '",g_apa.apa22 CLIPPED,"'",
                         " '",g_apa.apa36 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'", #CHI-AB0011 add ,
                         " '",g_wc3 CLIPPED,"'"    #CHI-AB0011 add
            CALL cl_cmdat('aapp111',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p111_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p111_process()
   DEFINE l_yy       LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_mm       LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE gg_cnt     LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_flag     LIKE type_file.chr1    #MOD-870210 mod num5->chr1
   DEFINE t_apb21    LIKE apb_file.apb21
   DEFINE t_apb22    LIKE apb_file.apb22
   DEFINE l_rvv01    LIKE rvv_file.rvv01    #MOD-B40008
   DEFINE l_rvv02    LIKE rvv_file.rvv02    #MOD-B40008
   DEFINE l_rvv09    LIKE rvv_file.rvv09    #MOD-B40008
   DEFINE l_rvv36    LIKE rvv_file.rvv36
   DEFINE l_rvv37    LIKE rvv_file.rvv37
   DEFINE l_rvb22    LIKE rvb_file.rvb22
   DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(800)
   DEFINE l_rvv32    LIKE rvv_file.rvv32    #MOD-5B0139
   DEFINE l_rvv33    LIKE rvv_file.rvv33    #MOD-5B0139
   DEFINE l_rvv88    LIKE rvv_file.rvv88    #No.TQC-7B0083
   DEFINE l_apydmy3  LIKE apy_file.apydmy3  #No.TQC-7B0083
   DEFINE l_trtype   LIKE apy_file.apyslip  #No.TQC-7B0083
   DEFINE l_cnt      LIKE type_file.num5    #MOD-820081
   DEFINE l_cnt1     LIKE type_file.num5    #MOD-8A0036 add
   DEFINE l_i        LIKE type_file.num5    #MOD-8A0036 add
   DEFINE l_rvw03    DYNAMIC ARRAY OF LIKE rvw_file.rvw03   #MOD-8A0036 add
   DEFINE l_rvw12    LIKE rvw_file.rvw12    #MOD-8B0199
   DEFINE l_flag1    LIKE type_file.chr1    #MOD-8A0036 add
   DEFINE l_poz18    LIKE poz_file.poz18
   DEFINE l_poz19    LIKE poz_file.poz19
   DEFINE l_poz01    LIKE poz_file.poz01
   DEFINE l_c        LIKE type_file.num5
   DEFINE l_rvu08    LIKE rvu_file.rvu08
  #DEFINE l_rvu08_t  LIKE rvu_file.rvu08 #FUN-C70052 add#FUN-C80022 mark
   DEFINE l_apa100_t LIKE apa_file.apa100   #FUN-9C0001
   DEFINE l_apa01_t  LIKE apa_file.apa01    #FUN-9C0001
   DEFINE l_gec04     LIKE gec_file.gec04   #MOD-AB0206
   DEFINE l_gec07     LIKE gec_file.gec07   #MOD-AB0206
   DEFINE l_rvv09b LIKE rvv_file.rvv09     #MOD-B40008 
   DEFINE l_rvv09e LIKE rvv_file.rvv09     #MOD-B40008

  #-MOD-B40008-add-
   LET l_rvv09b = MDY(MONTH(g_apa.apa02),1,YEAR(g_apa.apa02))     #取得當月第一天日期
   LET l_rvv09e = s_monend(YEAR(g_apa.apa02),MONTH(g_apa.apa02))  #取得當月最後一天日期
  #-MOD-B40008-end-
 
   LET g_apa34   = 0      #No.FUN-CB0048   Add
   LET g_rvw01   = NULL   #No.FUN-CB0048   Add
   LET g_apa01_s = NULL   #No.FUN-CB0048   Add

   CALL g_apa_gl.clear()   #TQC-9C0079 add

   LET g_sql = "SELECT azp01 FROM azp_file,azw_file ",
               " WHERE ",g_wc2 CLIPPED ,
               "   AND azw01 = azp01 AND azw02 = '",g_legal,"' ",
               " ORDER BY azp01 "
   PREPARE sel_azp03_pre FROM g_sql
   DECLARE sel_azp03_cs CURSOR FOR sel_azp03_pre
   LET t_azp01 = NULL    
   LET t_azp03 = NULL 
   LET t_vendor = NULL
   LET t_curr = ' '
   LET t_tax = ' '            #TQC-A40065 Add
   LET g_i = 1                #TQC-9C0079 add
   LET start_no = ''          #No.TQC-C70162   Mark
   LET end_no = ''            #No.TQC-C70162   Mark
   FOREACH sel_azp03_cs INTO l_azp01
      IF STATUS THEN
         CALL cl_err('p111(ckp#1):',SQLCA.sqlcode,1)
         RETURN
      END IF 
      LET g_plant_new = l_azp01
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
 
      IF g_aza.aza26 = '2' THEN   #MOD-7B0207
         LET g_sql = "SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
                   # "  FROM ",l_dbs CLIPPED,"rvv_file,",l_dbs CLIPPED,"rvu_file,rvw_file ",   #FUN-9C0001         #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(l_azp01,'rvv_file'),",",                    #FUN-A50102
                               cl_get_target_table(l_azp01,'rvu_file'),",rvw_file ",           #FUN-A50102
                     " WHERE ",g_wc CLIPPED," AND rvv03 = '",rvv03_sw,"'",
                    #"   AND (rvv87 - rvv23 - rvv88 > 0 OR rvv87=0) ",  #No.TQC-7B0083 #MOD-B40008 mark
                     "   AND rvv87 - rvv23 - rvv88 > 0 ",                              #MOD-B40008 
                     "   AND rvu01 = rvw08 ",   #No.TQC-790130 add
                    #"   AND rvv01 = rvu01 AND rvuconf = 'Y' AND rvv25 = 'N'",
                     "   AND rvv01 = rvu01 AND rvuconf = 'Y' AND rvv25 <> 'Y'",  #FUN-C60071 rvv25 = 'N' --> rvv25 <> 'Y'
                    #"   AND rvu08 != 'TAP' AND rvu08 != 'TRI'",   #MOD-660033 #MOD-B50028 mark
                    #-MOD-B40008-add-
                    #"   AND (YEAR(rvv09)  !=YEAR('",g_apa.apa02,"') OR ",
                    #"       (YEAR(rvv09)   =YEAR('",g_apa.apa02,"') AND ",
                    #"        MONTH(rvv09) !=MONTH('",g_apa.apa02,"'))) "
                     "   AND rvv09 NOT BETWEEN '",l_rvv09b,"' AND '",l_rvv09e,"'", 
                    #-MOD-B40008-end-
                     "   AND rvv89 <>'Y' AND rvu10 = 'Y' "                         #FUN-940083 add
                  #   ,"   AND rvv31 NOT LIKE 'MISC%'"   #FUN-D70021 add
      ELSE
         LET g_sql = "SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
                     #"  FROM rvv_file,rvu_file ",    #FUN-9C0001
                   # "  FROM ",l_dbs CLIPPED,"rvv_file,",l_dbs CLIPPED,"rvu_file ",    #FUN-9C0001       #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(l_azp01,'rvv_file'),",",            #FUN-A50102
                               cl_get_target_table(l_azp01,'rvu_file'),                #FUN-A50102 
                     " WHERE ",g_wc CLIPPED," AND rvv03 = '",rvv03_sw,"'",
                    #"   AND (rvv87 - rvv23 - rvv88 > 0 OR rvv87=0) ",  #MOD-B40008 mark
                     "   AND rvv87 - rvv23 - rvv88 > 0 ",               #MOD-B40008 
                    #"   AND rvv01 = rvu01 AND rvuconf = 'Y' AND rvv25 = 'N'",
                     "   AND rvv01 = rvu01 AND rvuconf = 'Y' AND rvv25 <> 'Y'",  #FUN-C60071 rvv25 = 'N' --> rvv25 <> 'Y' 
                    #"   AND rvu08 != 'TAP' AND rvu08 != 'TRI'",        #MOD-B50028 mark 
                    #-MOD-B40008-add- 
                    #"   AND (YEAR(rvv09)  !=YEAR('",g_apa.apa02,"') OR ",
                    #"       (YEAR(rvv09)   =YEAR('",g_apa.apa02,"') AND ",
                    #"        MONTH(rvv09) !=MONTH('",g_apa.apa02,"'))) "
                    "   AND rvv09 NOT BETWEEN '",l_rvv09b,"' AND '",l_rvv09e,"'",
                    #-MOD-B40008-end- 
                     "   AND rvv89 <>'Y' AND rvu10 = 'Y' "                         #FUN-940083 add
                  #   ,"   AND rvv31 NOT LIKE 'MISC%'"   #FUN-D70021 add
      END IF
    
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102 
      PREPARE p111_prechk FROM g_sql
      IF STATUS THEN
         CALL cl_err('prechk: ',STATUS,1)
         RETURN
      END IF
    
      DECLARE p111_chkdate CURSOR WITH HOLD FOR p111_prechk
    
      LET l_flag='N'
    
      FOREACH p111_chkdate INTO l_yy,l_mm
         LET l_flag='Y'
         EXIT FOREACH
      END FOREACH
    
     #-MOD-B40008-add-
      IF l_flag = 'N' THEN
        #檢核數量為 0 的部分,需排除暫估的部分 
         IF g_aza.aza26 = '2' THEN   
            LET g_sql = "SELECT rvv01,rvv02,rvv09 ",
                        "  FROM rvv_file,rvu_file,rvw_file ",  
                        " WHERE ",g_wc CLIPPED," AND rvv03 = '",rvv03_sw,"'",
                        "   AND rvv87 = 0 ",                      
                        "   AND rvu01 = rvw08 ",   
                        "   AND rvv01 = rvu01 AND rvuconf = 'Y' AND rvv25 = 'N'",
                        "   AND rvv89 != 'Y' ",            #MOD-B50074
                       #"   AND rvu08 != 'TAP' AND rvu08 != 'TRI'",        #MOD-B50028 mark 
                        "   AND rvv09 NOT BETWEEN '",l_rvv09b,"' AND '",l_rvv09e,"'" 
         ELSE
            LET g_sql = "SELECT rvv01,rvv02,rvv09 ",
                        "  FROM rvv_file,rvu_file ",  
                        " WHERE ",g_wc CLIPPED," AND rvv03 = '",rvv03_sw,"'",
                        "   AND rvv87 = 0 ",       
                        "   AND rvv01 = rvu01 AND rvuconf = 'Y' AND rvv25 = 'N'",
                        "   AND rvv89 != 'Y' ",            #MOD-B50074
                       #"   AND rvu08 != 'TAP' AND rvu08 != 'TRI'",        #MOD-B50028 mark 
                        "   AND rvv09 NOT BETWEEN '",l_rvv09b,"' AND '",l_rvv09e,"'"
         END IF
        
         PREPARE p111_prechk2 FROM g_sql
         IF STATUS THEN
            CALL cl_err('prechk2: ',STATUS,1)
            RETURN
         END IF
        
         DECLARE p111_chkdate2 CURSOR WITH HOLD FOR p111_prechk2
     
         FOREACH p111_chkdate2 INTO l_rvv01,l_rvv02,l_rvv09
            LET l_cnt = 0 
            SELECT COUNT(*) INTO l_cnt 
              FROM apa_file,apb_file
             WHERE apa01 = apb01
               AND apa00 = '26'
               AND apa42 = 'N'
               AND apb21 = l_rvv01 
               AND apb22 = l_rvv02
            IF l_cnt = 0 THEN
               LET l_flag='Y'
               EXIT FOREACH
            END IF
         END FOREACH
      END IF
     #-MOD-B40008-end  

      IF l_flag ='Y' THEN
         LET g_success = 'N'
         CALL cl_err('err:','axr-065',1)
         RETURN
      END IF
    
    
      IF cl_null(g_apa.apa15) THEN
         LET l_flag1 = 'Y'
         LET g_sql = "SELECT rvw03 ",
                   # "  FROM ",l_dbs CLIPPED,"rvv_file,",l_dbs CLIPPED,"rvu_file,rvw_file ",  #FUN-9C0001    #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(l_azp01,'rvv_file'),",",                   #FUN-A50102
                               cl_get_target_table(l_azp01,'rvu_file'),",rvw_file ",          #FUN-A50102 
                     " WHERE ",g_wc CLIPPED," AND rvv03 = '",rvv03_sw,"'",
                     "   AND rvw99 = '",l_azp01,"' ",    #FUN-9C0001
                    #"   AND (rvv87 > rvv23 OR rvv87=0) ",                                   #MOD-B40008 mark
                     "   AND ((rvv87 - rvv23 - rvv88 > 0 ) OR ( rvv23 = 0 AND rvv39 > 0)) ", #MOD-B40008 
                     "   AND rvv01 = rvw08",
                     "   AND rvv02 = rvw09",
                     "   AND rvv01 = rvu01",
                     "   AND rvuconf = 'Y'",
                    #"   AND rvv25 = 'N'",
                     "   AND rvv25 <> 'Y'",   #FUN-C60071  rvv25 = 'N'--> rvv25 <> 'Y'
                     "   AND rvv89 != 'Y' ",            #MOD-B50074
                    #"   AND rvu08 != 'TAP' AND rvu08 != 'TRI'",        #MOD-B50028 mark 
                     " ORDER BY rvw03"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
         PREPARE p111_rvw FROM g_sql
         IF STATUS THEN
            CALL cl_err('p111_rvw: ',STATUS,1)
            RETURN
         END IF
    
         DECLARE p111_rvw_cs CURSOR WITH HOLD FOR p111_rvw
    
         LET l_cnt1 = 1
         FOREACH p111_rvw_cs INTO l_rvw03[l_cnt1]
            LET l_cnt1 = l_cnt1 + 1
         END FOREACH
         LET l_cnt1 = l_cnt1 - 1
      ELSE
         LET l_flag1 = 'N'
         LET l_cnt1 = 1
         LET l_rvw03[1] = g_apa.apa15
      ENd IF
    
      FOR l_i = 1 TO l_cnt1
    
        IF g_aza.aza26 = '2' THEN   #MOD-7B0207
           LET g_sql = "SELECT rvv06,'','','',rvv04,rvv05,'','',rvv38,rvv39,",
                       "       rvv87-rvv23,rvv31,rvv01,rvv02,'','','',rvv36,rvv37,rvv930,rvv17,rvw01 " ,  #FUN-670064   #CHI-850032 add rvv17  #MOD-890156 add rvw01
                       "      ,rvu08,rvv39t ", #FUN-9C0001      #MOD-AB0206 add rvv39t 
                     # "  FROM ",l_dbs CLIPPED,"rvv_file,",l_dbs CLIPPED,"rvu_file,rvw_file",    #FUN-9C0001    #FUN-A50102 mark
                       "  FROM ",cl_get_target_table(l_azp01,'rvv_file'),",",                    #FUN-A50102
                                 cl_get_target_table(l_azp01,'rvu_file'),",rvw_file",            #FUN-A50102
                       " WHERE ",g_wc CLIPPED," AND rvv03 = '",rvv03_sw,"'",
                      #"   AND (rvv87 > rvv23 OR rvv87=0) ",   #FUN-560091                     #MOD-B40008 mark
                       "   AND ((rvv87 - rvv23 - rvv88 > 0 ) OR ( rvv23 = 0 AND rvv39 > 0)) ", #MOD-B40008 
                       "   AND rvv01 = rvw08 ",                     #No.TQC-790130
                       "   AND rvv02 = rvw09 ",                     #No.TQC-7B0083
                       "   AND rvv01 = rvu01",                      #modify 00/05/15
                       "   AND rvuconf = 'Y'",
                      #"   AND rvv25 = 'N'",                        #00/05/21 modify  #CHI-8B0055 mark,   #FUN-C60071 mark
                       "   AND rvv25 <> 'Y'",                       #FUN-C60071 add 
                       "   AND rvvplant = '",l_azp01,"' ",          #FUN-9C0001 ADD
                       "   AND rvw99 = '",l_azp01,"' ",             #FUN-A20006
                       "   AND rvv89 <>'Y' AND rvu10 = 'Y' ",        #FUN-940083 add
                       #"   AND rvw01 NOT IN (SELECT apk03 FROM apk_file WHERE apk03 IS NOT NULL) "   #MOD-BC0061
                       "   AND rvw01 NOT IN (SELECT apk03 FROM apk_file,apa_file WHERE apk01=apa01 AND apa00='21' AND apk03 IS NOT NULL) "   #TQC-C10046
           IF l_flag1 = 'Y' THEN
             LET g_sql = g_sql CLIPPED,"   AND rvw03='",l_rvw03[l_i],"'"
           END IF
        ELSE
           LET g_sql = "SELECT rvv06,'','','',rvv04,rvv05,'','',rvv38,rvv39,",
                       "       rvv87-rvv23,rvv31,rvv01,rvv02,'','','',rvv36,rvv37,rvv930,rvv17,'' " ,   #CHI-850032 add rvv17  #MOD-890156 add last ''
                       "      ,rvu08,rvv39t ",   #FUN-9C0001           #MOD-AB0206 add rvv39t
                     # "  FROM ",l_dbs CLIPPED,"rvv_file,",l_dbs CLIPPED,"rvu_file ",   #FUN-9C0001     #FUN-A50102 mark
                       "  FROM ",cl_get_target_table(l_azp01,'rvv_file'),",",           #FUN-A50102
                                 cl_get_target_table(l_azp01,'rvu_file'),               #FUN-A50102      
                       " WHERE ",g_wc CLIPPED," AND rvv03 = '",rvv03_sw,"'",
                      #"   AND (rvv87 > rvv23 OR rvv87=0) ",                                   #MOD-B40008 mark
                       "   AND ((rvv87 - rvv23 - rvv88 > 0 ) OR ( rvv23 = 0 AND rvv39 > 0)) ", #MOD-B40008 
                       "   AND rvv01 = rvu01", 
                       "   AND rvuconf = 'Y'",
                      #"   AND rvv25 = 'N'",                         #CHI-8B0055 mark,  #FUN-C60071 mark
                       "   AND rvv25 <> 'Y'",                       #FUN-C60071 add
                       "   AND rvvplant = '",l_azp01,"' ",          #FUN-9C0001 ADD
                       "   AND rvv89 <>'Y' AND rvu10 = 'Y' "         #FUN-940083 add
                       #"   AND rvw01 NOT IN (SELECT apk03 FROM apk_file WHERE apk03 IS NOT NULL) "   #MOD-BC0061 #TQC-C10046
        END IF
        LET g_sql=g_sql CLIPPED," ORDER BY  rvv06,rvv01,rvv02 "            #FUN-9C0001
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
        CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
    
        PREPARE p111_prepare FROM g_sql
        IF STATUS THEN
           CALL cl_err('p111_prepare',STATUS,0)
           CALL cl_batch_bg_javamail("N")  #NO.FUN-570112
           CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
           EXIT PROGRAM
        END IF
    
        DECLARE p111_cs CURSOR WITH HOLD FOR p111_prepare
        
        LET t_apb21 = ' '
        LET t_apb22 = ' '
    
        #FOR一筆請款,只產生一次分錄底稿
        LET l_trtype = trtype[1,g_doc_len]
        SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_trtype
        IF SQLCA.sqlcode THEN
          #-MOD-AA0090-add-
          #CALL s_errmsg("apyslip",l_trtype,"sel apy:",SQLCA.sqlcode,1)          #No.FUN-710014
          #LET g_totsuccess = "N"
           LET g_success = 'N'
           CALL cl_err('sel apy:',SQLCA.sqlcode,1) 
           RETURN
          #-MOD-AA0090-end-
        END IF
        
       #LET start_no = ''       #MOD-C10001 add   #No.TQC-C70162   Mark
       #LET end_no = ''         #MOD-C10001 add   #No.TQC-C70162   Mark
        CALL s_showmsg_init()   #No.FUN-710014
        FOREACH p111_cs INTO g_vendor,g_vendor2,g_abbr,g_apa.apa18,g_apb.apb04,
                             g_apb.apb05,g_apb.apb06,g_apb.apb07,g_apb.apb23,
                             g_apb.apb24,g_apb.apb09,g_apb.apb12,g_apb.apb21,
                             g_apb.apb22,g_apb.apb11,g_apa.apa13,g_apa.apa66,
                             l_rvv36,l_rvv37,g_rvv930,g_rvv17,lg_rvw01  #FUN-670064   #CHI-850032 add g_rvv17   #MOD-890156 add lg_rvw01
                            ,l_rvu08,g_apb24t  #CHI-8B0055 add #MOD-AB0206 add 
                            #,g_rvuplant   #FUN-960141 add   #FUN-9C0001
           IF STATUS THEN

              CALL s_errmsg('','','p111(ckp#1):',SQLCA.sqlcode,1)
              LET g_totsuccess='N'
              EXIT FOREACH
           END IF
           #FUN-C80022--add--str
           IF purchas_sw = 1 THEN
              IF l_rvu08 = 'SUB' THEN
                 CONTINUE FOREACH
              END IF
           ELSE
              IF l_rvu08 != 'SUB' THEN
                 CONTINUE FOREACH
              END IF
           END IF
           #FUN-C80022--add--end
           #No.TQC-BA0177  --Begin
           IF l_rvv09  > g_apa.apa02 THEN 
              CONTINUE FOREACH
           END IF 
           #No.TQC-BA0177  --End 
           LET g_apa.apa15 = l_rvw03[l_i]   #MOD-8A0036 add

           #CHI-AB0011 add --start--
           IF g_wc3 != ' 1=1' THEN
              LET l_cnt = 0
              LET g_sql="SELECT COUNT(*) FROM pmm_file ",
                        " WHERE ",g_wc3 CLIPPED,
                        "   AND pmm01 = '",l_rvv36,"'"
              PREPARE p111_precount FROM g_sql
              DECLARE p111_count CURSOR FOR p111_precount
              OPEN p111_count
              FETCH p111_count INTO l_cnt
              IF l_cnt = 0 THEN
                 CONTINUE FOREACH
              END IF
           END IF
           #CHI-AB0011 add --end--
 
         #  LET g_sql = "SELECT pmc04,pmc24 FROM ",l_dbs CLIPPED,"pmc_file",                #FUN-A50102 mark
            LET g_sql = "SELECT pmc04,pmc24 FROM ",cl_get_target_table(l_azp01,'pmc_file'), #FUN-A50102
                        " WHERE pmc01 = '",g_vendor,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102  
            PREPARE sel_pmc04_pre FROM g_sql
            EXECUTE sel_pmc04_pre INTO g_vendor2,g_apa.apa18
           
           IF cl_null(g_vendor2) THEN
              LET g_vendor2 = g_vendor
           END If
    

          # LET g_sql = "SELECT pmc03 FROM ",l_dbs CLIPPED,"pmc_file ",              #FUN-A50102 mark
            LET g_sql = "SELECT pmc03 FROM ",cl_get_target_table(l_azp01,'pmc_file'),#FUN-A50102
                        " WHERE pmc01 = '",g_vendor2,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102
            PREPARE sel_pmc03_pre FROM g_sql
            EXECUTE sel_pmc03_pre INTO g_abbr

          # LET g_sql = "SELECT rvb04,rvb03,rvb22 FROM ",l_dbs CLIPPED,"rvb_file ",               #FUN-A50102 mark
            LET g_sql = "SELECT rvb04,rvb03,rvb22 FROM ",cl_get_target_table(l_azp01,'rvb_file'), #FUN-A50102 
                        " WHERE rvb01 = '",g_apb.apb04,"' ",
                        "   AND rvb02 = '",g_apb.apb05,"' ",
                        "   AND rvb89 != 'Y' "                   #MOD-B50074
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
            PREPARE sel_rvb04_pre FROM g_sql
            EXECUTE sel_rvb04_pre INTO g_apb.apb06,g_apb.apb07,l_rvb22
         #FUN-BB0002 add START
            IF cl_null(l_rvb22) THEN
               LET g_sql = "SELECT rvv22 FROM ",cl_get_target_table(l_azp01,'rvv_file'),
                           " WHERE rvv01 = '",g_apb.apb21,"' ",
                           "   AND rvv02 = '",g_apb.apb22,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
               PREPARE sel_rvb04_pre1 FROM g_sql
               EXECUTE sel_rvb04_pre1 INTO l_rvb22
            END IF
         #FUN-BB0002 add END    
           IF cl_null(g_apb.apb06) THEN
              IF cl_null(g_apb.apb06) THEN

                # LET g_sql = "SELECT rvu113,'',rvu111 FROM ",l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"rvv_file ",   #FUN-A50102 mark
                  LET g_sql = "SELECT rvu113,'',rvu111 FROM ",cl_get_target_table(l_azp01,'rvu_file'),",",           #FUN-A50102
                                                              cl_get_target_table(l_azp01,'rvv_file'),               #FUN-A50102
                              " WHERE rvv01 = rvu01 ",
                              "   AND rvv01 = '",g_apb.apb21,"' ",
                              "   AND rvv02 = '",g_apb.apb22,"' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102      
                  PREPARE sel_rvu113_pre FROM g_sql            
                  EXECUTE sel_rvu113_pre INTO g_apa.apa13,g_apa.apa66,g_apa.apa11        
              ELSE

                # LET g_sql = "SELECT rva113,'',rva111 FROM ",l_dbs CLIPPED,"rva_file,",l_dbs CLIPPED,"rvb_file ",   #FUN-A50102 mark
                  LET g_sql = "SELECT rva113,'',rva111 FROM ",cl_get_target_table(l_azp01,'rva_file'),",",           #FUN-A50102
                                                              cl_get_target_table(l_azp01,'rvb_file'),               #FUN-A50102         
                              " WHERE rvb01 = rva01",
                              "   AND rvb01 = '",g_apb.apb04,"' ",
                              "   AND rvb02 = '",g_apb.apb05,"' ",
                              "   AND rvb89 != 'Y' "                     #MOD-B50074
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102 
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
                  PREPARE sel_rva113_pre FROM g_sql
                  EXECUTE sel_rva113_pre INTO g_apa.apa13,g_apa.apa66,g_apa.apa11
                 #FUN-9C0001--mod--end
              END IF
           ELSE

             # LET g_sql = "SELECT pmm22,pmn122,pmm20 FROM ",l_dbs CLIPPED,"pmm_file, ",l_dbs CLIPPED,"pmn_file ",   #FUN-A50102 mark
               LET g_sql = "SELECT pmm22,pmn122,pmm20 FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",            #FUN-A50102
                                                             cl_get_target_table(l_azp01,'pmn_file'),                #FUN-A50102
                           " WHERE pmn01 = pmm01 ",
                           "   AND pmn01 = '",l_rvv36,"' ",
                           "   AND pmn02 = '",l_rvv37,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
               PREPARE sel_pmm22_pre FROM g_sql
               EXECUTE sel_pmm22_pre INTO g_apa.apa13,g_apa.apa66,g_apa.apa11
           END IF 
    
         IF l_rvu08 = 'TAP' OR l_rvu08 = 'TRI' THEN  

               LET g_sql = "SELECT poz01,poz18,poz19 FROM ",
                         #  l_dbs CLIPPED,"pmm_file,",l_dbs CLIPPED,"poz_file ",           #FUN-A50102 mark
                            cl_get_target_table(l_azp01,'pmm_file'),",",                   #FUN-A50102
                            cl_get_target_table(l_azp01,'poz_file'),                       #FUN-A50102
                           " WHERE pmm904 = poz01",
                           "   AND pmm01  = '",g_apb.apb06,"' ",
                           "   AND pmm901 = 'Y' " ,   #三角貿易否
                           "   AND pmm905 = 'Y' "     #已拋轉
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102
               PREPARE sel_poz01_pre FROM g_sql
               EXECUTE sel_poz01_pre INTO l_poz01,l_poz18,l_poz19 
              #FUN-9C0001--mod--end
    
               LET l_c = 0
              IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN    #已設立中斷點
 
                 # LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"poy_file ",               #FUN-A50102 mark
                   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'poy_file'), #FUN-A50102
                               " WHERE poy01 = '",l_poz01,"' ",
                               "   AND poy04 = '",l_poz18,"' "
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102  
                   PREPARE sel_cou_poy FROM g_sql
                   EXECUTE sel_cou_poy INTO l_c
              END IF 
             IF l_c = 0 THEN
                CALL s_errmsg('apb06',g_apb.apb06,'','axr-162',1) #MOD-D20134 add
                CONTINUE FOREACH
             END IF   
         END IF

           IF g_aza.aza26 != '2' THEN
              SELECT rvw01 INTO g_apb.apb11 FROM rvw_file
               WHERE rvw01 = l_rvb22
             #-MOD-AB0037-add-
              IF cl_null(g_apb.apb11) THEN
                 SELECT rvu15 INTO g_apb.apb11
                   FROM rvu_file
                  WHERE rvu01 = g_apb.apb21 
              END IF
             #-MOD-AB0037-add-
           END IF
    
          #DISPLAY "foreach:",g_vendor,' ',g_cur,' ',g_apb.apb04,' ',g_apb.apb05 AT 1,1 #MOD-B40008 mark
    
           #carrier 這段肯定有問題,要分情況..衝暫估時,可能apb09=0
           IF g_apb.apb09 = 0 THEN

              LET l_rvv88 = 0

             # LET g_sql = "SELECT rvv88 FROM ",l_dbs CLIPPED,"rvv_file ",                #FUN-A50102 mark
               LET g_sql = "SELECT rvv88 FROM ",cl_get_target_table(l_azp01,'rvv_file'),  #FUN-A50102
                           " WHERE rvv01 = '",g_apb.apb21,"' ",
                           "   AND rvv02 = '",g_apb.apb22,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102
               PREPARE sel_rvv88_pre FROM g_sql
               EXECUTE sel_rvv88_pre INTO l_rvv88
              IF cl_null(l_rvv88) THEN LET l_rvv88 = 0 END IF
              IF l_rvv88 = 0 THEN
                 SELECT COUNT(*) INTO g_cnt FROM apb_file,apa_file   #No.TQC-AB0065
                  WHERE apb21 = g_apb.apb21
                    AND apb22 = g_apb.apb22
                    AND apb37 = l_azp01   #FUN-A20006
                    AND apa00 <> '26'   #No.TQC-AB0065   排除暂估的统计
                    AND apa01 = apb01   #No.TQC-AB0065
                 IF g_cnt>0 THEN
                    CONTINUE FOREACH
                 END IF
              END IF
           END IF
    
           IF cl_null(g_apa.apa13) THEN #No.9518

              #LET g_sql = "SELECT pmc22 FROM ",l_dbs CLIPPED,"pmc_file ",                  #FUN-A50102 mark
               LET g_sql = "SELECT pmc22 FROM ",cl_get_target_table(l_azp01,'pmc_file'),    #FUN-A50102  
                           " WHERE pmc01 = '",g_vendor,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
               PREPARE sel_pmc22_pre FROM g_sql
               EXECUTE sel_pmc22_pre INTO g_apa.apa13
           END IF
    
           SELECT * INTO t_azi.* FROM azi_file WHERE azi01 = g_apa.apa13   #No.CHI-6A0004 g_azi-->t_azi
    
           LET g_apb.apb29 = '3'
    
           IF g_apa.apa13 != g_aza.aza17 THEN     #85-11-22
              CALL s_curr3(g_apa.apa13,g_apa.apa02,g_apz.apz33) #FUN-640022
              RETURNING g_apa.apa14
           ELSE
              LET g_apa.apa14=1
           END IF
    
           IF cl_null(g_apa.apa14) THEN
              LET g_apa.apa14=1
           END IF
    
           SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=g_apa.apa13
           LET g_apa.apa14 = cl_digcut(g_apa.apa14,t_azi07)
    
           LET g_apa.apa72=g_apa.apa14
    
           IF g_apb.apb23 IS NULL THEN
              LET g_apb.apb23 = 0
           END IF
    
           IF g_apb.apb09 IS NULL THEN
              LET g_apb.apb09 = 0
           END IF
    
           IF g_apb.apb09 > 0 THEN
              LET g_apb.apb24 = g_apb.apb23 * g_apb.apb09
              IF cl_null(g_apb.apb24) THEN
                 LET g_apb.apb24 = 0
              END IF
              LET g_apb.apb24 = cl_digcut(g_apb.apb24,t_azi.azi04)    #No.CHI-6A0004 g_azi-->t_azi
           END IF
    
           IF g_aza.aza26 = '2' THEN
              LET l_rvw12 = 0
              SELECT rvw12 INTO l_rvw12
                FROM rvw_file
               WHERE rvw08 = g_apb.apb21
                 AND rvw09 = g_apb.apb22
                 AND rvw01 = lg_rvw01    #MOD-890156
              IF cl_null(l_rvw12) THEN LET l_rvw12=1 END IF
              LET g_apb.apb08 = g_apb.apb23 * l_rvw12
              LET g_apb.apb10 = g_apb.apb24 * l_rvw12
           ELSE
             #-MOD-AB0206-add-
              #單價含稅時,不使用單價*數量=金額,改以含稅金額回推稅率,以避免小數位差的問題
              LET l_gec04 = 0   LET l_gec07 = ''
              SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file,pmm_file    
               WHERE gec01 = pmm21 AND pmm01 = g_apb.apb06
                 AND gec011 = '1'  
              IF cl_null(l_gec04) THEN LET l_gec04=0   END IF
              IF cl_null(l_gec07) THEN LET l_gec07='N' END IF
              IF g_apb.apb09 <> 0 THEN   #MOD-B40074 add
                 IF l_gec07='Y' THEN
                    LET g_apb.apb24 = g_apb24t / (1+l_gec04/100)
                 ELSE
                    LET g_apb.apb24 = g_apb.apb23 * g_apb.apb09 
                 END IF
              END IF                     #MOD-B40074 add
              LET g_apb.apb24 = cl_digcut(g_apb.apb24,t_azi.azi04)    
             #-MOD-AB0206-end-
              LET g_apb.apb08 = g_apb.apb23 * g_apa.apa14
              LET g_apb.apb10 = g_apb.apb24 * g_apa.apa14
           END IF   #MOD-8B0199 add
    
           IF cl_null(g_apb.apb10) THEN
              LET g_apb.apb10 = 0
           END IF
    
           LET g_apb.apb10 = cl_digcut(g_apb.apb10,g_azi04)       #No.TQC-740142
           LET g_apb.apb081=g_apb.apb08
           LET g_apb.apb101=g_apb.apb10
    
           IF g_vendor2 IS NULL THEN
              LET g_vendor2 = g_vendor
           END IF
    
           IF g_cur IS NULL THEN
              LET g_cur = g_aza.aza17
           END IF
    
           LET g_pmn401 = ''  #No.FUN-680029
           LET g_apb.apb27 = ''   #MOD-8B0064 add
           IF cl_null(g_apb.apb06) THEN

             # LET g_sql = "SELECT rvv031,rvv86 FROM ",l_dbs CLIPPED,"rvv_file ",                 #FUN-A50102 mark
               LET g_sql = "SELECT rvv031,rvv86 FROM ",cl_get_target_table(l_azp01,'rvv_file'),   #FUN-A50102
                           " WHERE rvv01 = '",g_apb.apb21,"' ",
                           "   AND rvv02 = '",g_apb.apb22,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql      #FUN-A50102
               PREPARE sel_rvv031_pre FROM g_sql
               EXECUTE sel_rvv031_pre INTO g_apb.apb27,g_apb.apb28
             # LET g_sql = "SELECT ima39,ima391 FROM ",l_dbs CLIPPED,"ima_file ",               #FUN-A50102 mark
               LET g_sql = "SELECT ima39,ima391 FROM ",cl_get_target_table(l_azp01,'ima_file'), #FUN-A50102 
                           " WHERE ima01 = '",g_apb.apb12,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
               PREPARE sel_ima39_pre FROM g_sql
               EXECUTE sel_ima39_pre INTO g_apb.apb25,g_pmn401
           ELSE

           #LET g_sql = "SELECT pmn041,pmn86,pmn40,pmn401 FROM ",l_dbs CLIPPED,"pmn_file ",              #FUN-A50102 mark
            LET g_sql = "SELECT pmn041,pmn86,pmn40,pmn401 FROM ",cl_get_target_table(l_azp01,'pmn_file'),#FUN-A50102 
                        " WHERE pmn01 = '",g_apb.apb06,"' ",
                        "   AND pmn02 = '",g_apb.apb07,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
            PREPARE sel_pmn041_pre FROM g_sql
            EXECUTE sel_pmn041_pre INTO g_apb.apb27,g_apb.apb28,g_apb.apb25,g_pmn401
    
           END IF                                               #FUN-940083 add
           IF g_aza.aza63 = 'Y' THEN
              LET g_apb.apb251 = g_pmn401
           END IF
    
           IF g_apb.apb27 IS NULL THEN
 
             # LET g_sql = "SELECT ima02,ima25 FROM ",l_dbs CLIPPED,"ima_file ",                #FUN-A50102 mark
               LET g_sql = "SELECT ima02,ima25 FROM ",cl_get_target_table(l_azp01,'ima_file'),  #FUN-A50102 
                           " WHERE ima01 = '",g_apb.apb12,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
               PREPARE sel_ima02_pre FROM g_sql
               EXECUTE sel_ima02_pre INTO g_apb.apb27,g_apb.apb28
           END IF
    
           IF g_apa.apa51 = 'STOCK' THEN

             # LET g_sql = "SELECT rvv32,rvv33 FROM ",l_dbs CLIPPED,"rvv_file ",                #FUN-A50102 mark
               LET g_sql = "SELECT rvv32,rvv33 FROM ",cl_get_target_table(l_azp01,'rvv_file'),  #FUN-A50102
                           " WHERE rvv01 = '",g_apb.apb21,"' AND rvv02 = '",g_apb.apb22,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
               PREPARE sel_rvv32_pre FROM g_sql
               EXECUTE sel_rvv32_pre INTO l_rvv32,l_rvv33
              CALL t110_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'0',l_azp01)  #No.FUN-680029 新增參數'0'   #FUN-9C0041 add l_azp01
                   RETURNING g_apb.apb25
              IF g_aza.aza63 = 'Y' THEN
                 CALL t110_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'1',l_azp01) #FUN-9C0041 add l_azp01
                      RETURNING g_apb.apb251
              END IF
           END IF
    
           IF t_vendor IS NULL OR

              g_vendor != t_vendor OR t_curr != g_apa.apa13 OR     #no.5373
              t_tax != g_apa.apa15 OR                              #TQC-A40065 Add
           #FUN-C80022--mark--str
           #  (purchas_sw = 'Y' AND #FUN-C70052 add
           # ((l_rvu08 = 'SUB' AND l_rvu08 != l_rvu08_t)OR #FUN-C70052 add
           #  (l_rvu08_t = 'SUB' AND l_rvu08 != 'SUB'))) OR #FUN-C70052 add
           #FUN-C80022--mark--end
              g_apb.apb02 >= body_no THEN
              #No.MOD-D60145  --Begin
              CALL p111_apa05('')
              IF NOT cl_null(g_errno) THEN
                 LET g_success = 'N'
                 CALL s_errmsg("apa05",g_vendor,'',g_errno,1)
                 CONTINUE FOREACH
              END IF
              #No.MOD-D60145  --End
              IF NOT cl_null(g_apa.apa01) THEN
                 LET l_cnt = 0 
                 SELECT COUNT(*) INTO l_cnt FROM apa_file,apb_file
                   WHERE apa01=g_apa.apa01 AND apa01=apb01  
                     AND apb34='Y'
                 IF l_cnt > 0 THEN     
                    CALL p111_ins_api()
                 END IF
                #str TQC-9C0079 mark
                ##同一筆帳款,只做一次分錄產生,否則多筆項次時,會報"分錄已產生,是否重新產生"
                #IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
                #   CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'0',l_azp01)  #No.FUN-680029 新增參數'0'  #FUN-9C0001 add l_azp01
                #   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                #      CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'1',l_azp01)   #FUN-9C0001 add l_azp01
                #   END IF
                #END IF
                #end TQC-9C0079 mark
                 CALL p111_ins_apc()
              END IF
              CALL p111_ins_apa()                   # Insert Head
              IF g_success = 'N' THEN
                 CONTINUE FOREACH              #No.FUN-710014
              END IF
             #LET l_rvu08_t = l_rvu08#FUN-C70052 add#FUN-C80022 mark
              LET t_vendor = g_vendor
              LET t_curr = g_apa.apa13   #no.5373
              LET t_tax = g_apa.apa15    #TQC-A40065 Add
           #FUN-9C0001--add--str--
              LET l_apa100_t = g_apa.apa100
              LET l_apa01_t = g_apa.apa01
           ELSE
              IF l_azp01 <> l_apa100_t THEN
                 UPDATE apa_file SET apa100 = ''
                  WHERE apa01 = l_apa01_t
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","apa_file",g_apa.apa01,g_apa.apa100,SQLCA.sqlcode,"","",1)
                    LET g_success ='N'
                 END IF
              END IF
           #FUN-9C0001--add--end
           END IF
    
           IF g_aza.aza26 = '2' THEN

              CALL p111_ins_apb_2()                                #Insert Body  #CHI-860024 mod p111_ins_apb()->p111_ins_apb_2()
           ELSE
              CALL p111_ins_apb()
           END IF
    
           #當rvv17=0時,不需新增apk_file
           IF g_aza.aza26 != '2' THEN   #CHI-860024 add
             #IF g_rvv17 != 0 THEN     #CHI-850032 add                #MOD-A90062 mark
                 IF NOT cl_null(g_apb.apb11) THEN   #MOD-890188 add
                    CALL p111_ins_apk()
                 END IF                             #MOD-890188 add
             #END IF                   #CHI-850032 add                #MOD-A90062 mark
           END IF                       #CHI-860024 add
    
           LET t_apb21 = g_apb.apb21
           LET t_apb22 = g_apb.apb22
           LET g_i = g_i + 1   #TQC-9C0079 add

        #No.FUN-CB0048 ---start--- Add
         IF g_aza.aza26 = '2' THEN
            IF cl_null(g_apa01_s) THEN                        #第一筆,直接更新rvw18
               LET g_apa01_s = g_apa.apa01
               UPDATE rvw_file SET rvw18 = g_apa01_s
                WHERE rvw01 = lg_rvw01
               LET g_apa34 = g_apa.apa34
               LET g_rvw01_s = lg_rvw01
            ELSE
               IF g_apa01_s != g_apa.apa01 THEN               #第N筆
                  IF lg_rvw01 != g_rvw01_s THEN            #發票編號與舊值不一致,直接更新rvw18
                     LET g_apa01_s = g_apa.apa01
                     UPDATE rvw_file SET rvw18 = g_apa01_s
                      WHERE rvw01 = lg_rvw01
                     LET g_apa34 = g_apa.apa34
                     LET g_rvw01_s = lg_rvw01
                  ELSE
                     IF g_apa34 < g_apa.apa34 THEN          #發票編號一致,當前筆金額大於上一筆,更新rvw18
                        LET g_apa01_s = g_apa.apa01
                        UPDATE rvw_file SET rvw18 = g_apa01_s 
                         WHERE rvw01 = lg_rvw01
                        LET g_apa34 = g_apa.apa34
                        LET g_rvw01_s = lg_rvw01
                     END IF
                  END IF
               END IF
            END IF
         END IF
        #No.FUN-CB0048 ---end  --- Add

        END FOREACH
      END FOR   #MOD-8A0036 add
   END FOREACH   #FUN-9C0001
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
   IF NOT cl_null(g_apa.apa01) THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM apa_file,apb_file
        WHERE apa01=g_apa.apa01 AND apa01=apb01  
          AND apb34='Y'
      IF l_cnt > 0 THEN     
         CALL p111_ins_api()
      END IF
     #str TQC-9C0079 mark
     ##同一筆帳款,只做一次分錄產生,否則多筆項次時,會報"分錄已產生,是否重新產生"
     #IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
     #   CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'0',l_azp01)  #No.FUN-680029 新增參數'0'  #FUN-9C0001 add l_azp01
     #   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
     #      CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'1',l_azp01)  #FUN-9C0001 add l_azp01
     #   END IF
     #END IF
     #end TQC-9C0079 mark
      CALL p111_ins_apc()
   END IF
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_apa.apa13  #No.TQC-6B0066
 
  #str TQC-9C0079 add
  #因為CALL s_aapt110_gl.4gl後會造成aapp111的TRANSACTION失效,建議產生分錄段移到最後
   IF g_success="Y" THEN
      FOR l_i = 1 TO g_i-1
         #同一筆帳款,只做一次分錄產生,否則多筆項次時,會報"分錄已產生,是否重新產生"
         IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
            CALL t110_g_gl(g_apa_gl[l_i].apa00,g_apa_gl[l_i].apa01,'0',g_apa_gl[l_i].azp01)
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL t110_g_gl(g_apa_gl[l_i].apa00,g_apa_gl[l_i].apa01,'1',g_apa_gl[l_i].azp01)
            END IF
         END IF
      END FOR
   END IF
  #end TQC-9C0079 add
 
   IF start_no IS NOT NULL THEN
      DISPLAY start_no TO start_no
      DISPLAY end_no   TO end_no
   ELSE
      LET g_success = 'N'                          #MOD-BA0134
      CALL s_errmsg('','','','aap-129',1)          #No.FUN-710014
   END IF
 
END FUNCTION
 
FUNCTION p111_ins_apa()
  DEFINE li_result LIKE type_file.num5         #No.FUN-560092  #No.FUN-690028 SMALLINT
  DEFINE  g_n      LIKE type_file.num10        # No.FUN-690028 INTEGER
  DEFINE l_trtype  LIKE apy_file.apyslip       #FUN-990014
  DEFINE g_t2      LIKE apy_file.apyslip       #MOD-990168       

   LET g_gec031 = ''   #No.FUN-680029
  #LET g_sql = "SELECT gec03,gec031,gec04,gec06 FROM ",l_dbs CLIPPED,"gec_file ",                #FUN-A50102 mark
   LET g_sql = "SELECT gec03,gec031,gec04,gec06 FROM ",cl_get_target_table(l_azp01,'gec_file'),  #FUN-A50102  
               " WHERE gec01 = '",g_apa.apa15,"' ",
               "   AND gecacti = 'Y' AND gec011 = '1'  "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102 
   PREPARE sel_gec03_pre FROM g_sql
   EXECUTE sel_gec03_pre INTO g_apa.apa52,g_gec031,g_apa.apa16,g_apa.apa172 
   IF g_aza.aza63 = 'Y' THEN
      LET g_apa.apa521 = g_gec031
   END IF
 
   LET g_apa.apa00 = '21'
   LET g_apa.apa05 = g_vendor
   #CHI-A90002 add --start--
   CALL p111_apa05('')
   IF NOT cl_null(g_errno) THEN
      LET g_success = 'N'
      CALL s_errmsg("apa05",g_apa.apa05,'',g_errno,1)
      RETURN
   END IF
   #CHI-A90002 add --end--
   IF cl_null(g_apa.apa11) THEN
    # LET g_sql = "SELECT pmc17 FROM ",l_dbs CLIPPED,"pmc_file ",                 #FUN-A50102 mark
      LET g_sql = "SELECT pmc17 FROM ",cl_get_target_table(l_azp01,'pmc_file'),   #FUN-A50102
                  " WHERE pmc01 = '",g_apa.apa05,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql       #FUN-A50102
      PREPARE sel_pmc17_pre FROM g_sql
      EXECUTE sel_pmc17_pre INTO g_apa.apa11
   END IF
 
   LET g_apa.apa06 = g_vendor2
   LET g_apa.apa07 = g_abbr
   LET g_apa.apa09 = g_apa.apa02
   LET g_apa.apa12 = g_apa.apa02 #FUN-570042
   LET g_apa.apa17 = '1'
   LET g_n=YEAR(g_apa.apa02)
   LET g_apa.apa173=g_n
   LET g_n=MONTH(g_apa.apa02)
   LET g_apa.apa174=g_n
   LET g_apa.apa20 = 0
   LET g_apa.apa24 = 0    #No.TQC-790130
   LET g_apa.apa31f= 0
   LET g_apa.apa31 = 0
   LET g_apa.apa32f= 0
   LET g_apa.apa32 = 0
   LET g_apa.apa33f= 0
   LET g_apa.apa33 = 0
   LET g_apa.apa34f= 0
   LET g_apa.apa34 = 0
   LET g_apa.apa73 = 0                        #bug no:A059
   LET g_apa.apa35f= 0
   LET g_apa.apa35 = 0
   LET g_apa.apa64 = g_apa.apa02    #No.TQC-790130 add
   LET g_apa.apa65f= 0
   LET g_apa.apa65 = 0
   LET g_apa.apa41 = 'N'
   LET g_apa.apa42 = 'N'
   LET g_apa.apa55 = '1'
   LET g_apa.apa56 = '0'
   IF g_rvv17 = 0 THEN
      LET g_apa.apa58 = '3'
   ELSE
      LET g_apa.apa58 = '2'
   END IF
   LET g_apa.apa57f= 0
   LET g_apa.apa57 = 0
   LET g_apa.apa60f= 0
   LET g_apa.apa60 = 0
   LET g_apa.apa61f= 0
   LET g_apa.apa61 = 0
   LET g_apa.apa74 = 'N'
   LET g_apa.apa75 = 'N'
   LET g_apa.apa79 = '0'   #TQC-9C0079 add   #No.FUN-A60024
   LET g_apa.apainpd=g_today
   LET g_apa.apaprno=0
   LET g_apa.apauser=g_user
   LET g_apa.apagrup=g_grup
   LET g_apa.apadate=g_today
   LET g_apa.apaacti='Y'              #資料有效
   LET g_apa.apa930=s_costcenter_stock_apa(g_apa.apa22,g_rvv930,g_apa.apa51)  #FUN-670064
   LET g_t2 = trtype[1,g_doc_len]                                                                                                   
   SELECT apyapr INTO g_apa.apamksg FROM apy_file WHERE apyslip = g_t2

   CALL s_auto_assign_no("aap",trtype,g_apa.apa02,g_apa.apa00,"","","","","")
       RETURNING li_result,g_apa.apa01

   IF g_aza.aza26 !=2 THEN          #MOD-C60112
      LET g_apa.apa08 = 'MISC'  #發票號碼 
   ELSE                             #MOD-C60112
   #  LET g_apa.apa08 = g_rvw01     #MOD-C60112  #TQC-D80023 mark
      LET g_apa.apa08 = lg_rvw01    #TQC-D80023   
      IF cl_null(g_apa.apa08) THEN LET g_apa.apa08 = 'MISC' END IF  #MOD-C60112
   END IF                           #MOD-C60112
 
 
 # LET g_sql = "SELECT rvu99 FROM ",l_dbs CLIPPED,"rvu_file ",                 #FUN-A50102 mark
   LET g_sql = "SELECT rvu99, rvu21 FROM ",cl_get_target_table(l_azp01,'rvu_file'),   #FUN-A50102   #TQC-BB0131 add rvu21
               " WHERE rvu01 = '",g_apb.apb21,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102
   PREPARE sel_rvu99_pre FROM g_sql
   EXECUTE sel_rvu99_pre INTO g_apa.apa99, g_apa.apa76            #TQC-BB0131 add g_apa.apa76 
 
  #DISPLAY "insert apa:",g_apa.apa01,' ',g_apa.apa02,' ',g_apa.apa06 AT 2,1 #MOD-B40008 mark
 
   LET g_apa.apa63 = '0'    #MOD-930035
  #LET g_apa.apa100 = g_rvuplant   #FUN-960141 add 090824  #FUN-9C0001
   LET g_apa.apa100 = l_azp01      #FUN-9C0001
   LET g_apa.apalegal = g_legal    #FUN-980001 add
   LET l_trtype = trtype[1,g_doc_len]
   SELECT apyvcode INTO g_apa.apa77 FROM apy_file WHERE apyslip = l_trtype
   IF cl_null(g_apa.apa77) THEN
      LET g_apa.apa77 = g_apz.apz63   #FUN-970108 add
   END IF  
   LET g_apa.apaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_apa.apaorig = g_grup      #No.FUN-980030 10/01/04
   LET g_apa.apa79 = '0'           #No.FUN-A40003      #No.FUN-A60024
   INSERT INTO apa_file VALUES(g_apa.*)
   IF STATUS THEN
     #CALL cl_err3("ins","apa_file",g_apa.apa01,"",SQLCA.sqlcode,"","p111_ins_apa(ckp#1)",1)   #No.FUN-660122 #CHI-A90002 mark
      CALL s_errmsg("apa01",g_apa.apa01,"p111_ins_apa(ckp#1)",SQLCA.sqlcode,1)    #CHI-A90002
      LET g_success = 'N'
   END IF
   IF start_no IS NULL THEN
      LET start_no = g_apa.apa01
   END IF
 
   LET end_no = g_apa.apa01
   LET g_apb.apb01 = g_apa.apa01
   LET g_apb.apb02 = 0
   LET g_apb.apb13f= 0
   LET g_apb.apb13 = 0
   LET g_apb.apb14f= 0
   LET g_apb.apb14 = 0
   LET g_apb.apb15 = 0
   LET g_apb.apb29 = '3'
   LET g_apb.apb930 = s_costcenter_stock_apb(g_apa.apa930,g_rvv930,g_apa.apa51)  #FUN-670064
   LET g_apa_gl[g_i].apa00=g_apa.apa00   #TQC-9C0079 add
   LET g_apa_gl[g_i].apa01=g_apa.apa01   #TQC-9C0079 add
   LET g_apa_gl[g_i].azp01=l_azp01       #TQC-9C0079 add
 
END FUNCTION
 
FUNCTION p111_ins_apb()
   DEFINE l_cnt          LIKE type_file.num5     #No.FUN-690028 SMALLINT
   DEFINE l_gec05        LIKE gec_file.gec05     #TQC-950101 add
   DEFINE l_invoice      LIKE apa_file.apa08
   DEFINE l_apydmy3      LIKE apy_file.apydmy3   #FUN-5B0089 add
   DEFINE l_trtype       LIKE apy_file.apyslip   # No.FUN-690028 VARCHAR(5) #FUN-5B0089 add
   DEFINE l_rvw12        LIKE rvw_file.rvw12     #No.TQC-790132
   DEFINE l_apk01        LIKE apk_file.apk01     #MOD-920263 add
   DEFINE l_message      LIKE type_file.chr1000  #MOD-920263 add
   DEFINE l_azf141       LIKE azf_file.azf141  #FUN-B80058
 
   LET g_apb.apb02 = g_apb.apb02 + 1
 
  #-MOD-B40008-mark- 
  #DISPLAY "insert apb:",g_apb.apb02,' ',g_apb.apb04,' ',g_apb.apb05,' ',
  #                      g_apb.apb08,' ',g_apb.apb09,' ',g_apb.apb10 AT 3,1
  #-MOD-B40008-end- 
 
   LET g_apb.apb34 = 'N'   #No.TQC-7B0083
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
    WHERE apb21 = g_apb.apb21
      AND apb22 = g_apb.apb22
      AND apa01 = apb01
      AND apa00 = '26'  #暫估應付資料
      AND apa41 ='Y'    #確認
      AND apa42 ='N'    #MOD-810170
      AND apb37 = l_azp01   #FUN-A20006
   IF l_cnt > 0 THEN    #有暫估資料
      LET g_apb.apb34 = 'Y'
   END IF
 
   IF cl_null(g_apb.apb11) THEN
      SELECT apa08 INTO g_apb.apb11 FROM apa_file,apb_file
       WHERE apa06 = g_apa.apa06
         AND apa01 = apb01
         AND apb06 = g_apb.apb06
         AND apb07 = g_apb.apb07
         AND apa00 MATCHES '1*'
     #str TQC-950101 add
     #非大陸版時,應卡若apb11(發票號碼)為NULL時不可寫入apb_file
      IF cl_null(g_apb.apb11) AND g_aza.aza26 != '2' THEN
         SELECT gec05 INTO l_gec05 FROM gec_file WHERE gec01 = g_apa.apa15 
         IF l_gec05 != 'X' THEN
            CALL s_errmsg('apa01',g_apa.apa01,'','aap-226',1)
            LET g_totsuccess = 'N'
         END IF
      END IF
     #end TQC-950101 add
   END IF
 
   IF NOT cl_null(g_apb.apb11) THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM apa_file,apk_file
       WHERE apa01=apk01 
         AND apk03=g_apb.apb11
         AND apa00 MATCHES '1*'
      IF l_cnt > 0 THEN        #MOD-AB0037 mark  #MOD-AB0111 remark
     #IF l_cnt = 0 THEN        #MOD-AB0037       #MOD-AB0111 mark
         #需檢核apa00=1*的apk_file,對應的帳款已確認才可輸入
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM apa_file,apk_file
          WHERE apa01=apk01 
            AND apk03=g_apb.apb11
            AND apa00 MATCHES '1*'
            AND apa41='Y'            #已確認
         IF l_cnt = 0 THEN
            #判斷輸入的發票號碼是否存在amdi100,且已確認
            #若沒有則顯示mfg-043訊息
          # LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"amd_file ",               #FUN-A50102  mark
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'amd_file'), #FUN-A50102
                        " WHERE amd03='",g_apb.apb11,"' AND amd30='Y' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
            PREPARE sel_cou_amd FROM g_sql
            EXECUTE sel_cou_amd INTO l_cnt
            IF l_cnt = 0 THEN
               SELECT apk01 INTO l_apk01
                 FROM apa_file,apk_file
                WHERE apa01=apk01
                  AND apk03=g_apb.apb11
                  AND apa00 MATCHES '1*'

             # LET g_sql = "SELECT gaq03  FROM ",l_dbs CLIPPED,"gaq_file ",                #FUN-A50102 mark
               LET g_sql = "SELECT gaq03  FROM ",cl_get_target_table(l_azp01,'gaq_file'),  #FUN-A50102
                           " WHERE gaq01='apa00' and gaq02=g_lang "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
               PREPARE sel_gaq03_pre FROM g_sql
               EXECUTE sel_gaq03_pre INTO l_message
               LET l_message=l_message,'=1*,',l_apk01,':'
               CALL s_errmsg('apa01',l_message,'','aap-271',1)
               LET g_totsuccess = 'N'
            END IF
         END IF
      ELSE
        #-MOD-AB0111-add-
         SELECT COUNT(*) INTO l_cnt FROM amd_file          
          WHERE amd03=g_apb.apb11 AND amd30='Y'  #已確認  
         IF l_cnt = 0 THEN
            CALL cl_err('','aap-120',1)
            LET g_totsuccess = 'N'
         END IF
        #-MOD-AB0111-end-
      END IF
   END IF
 

   IF cl_null(g_apb.apb06) THEN
      LET g_apb.apb26 = ' '    #No.TQC-C10017   
      LET g_apb.apb35 = ' '    #No.TQC-C10017
      LET g_apb.apb36 = ' '    #No.TQC-C10017
      LET g_apb.apb31 = ' '    #No.TQC-C10017

     #LET g_sql = "SELECT ima39,ima391 FROM ",l_dbs CLIPPED,"ima_file ",                #FUN-A50102 amrk
      LET g_sql = "SELECT ima39,ima391 FROM ",cl_get_target_table(l_azp01,'ima_file'),  #FUN-A50102
                  " WHERE ima01 = '",g_apb.apb12,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
      PREPARE sel_ima39_pre1 FROM g_sql
      EXECUTE sel_ima39_pre1 INTO g_apb.apb25,g_apb.apb251
   ELSE
      LET g_sql = "SELECT pmn40,pmn401,pmn67,pmn122,pmn96,pmn98",
                # "  FROM ",l_dbs CLIPPED,"pmn_file ",               #FUN-A50102 mark
                  "  FROM ",cl_get_target_table(l_azp01,'pmn_file'), #FUN-A50102
                  " WHERE pmn01='",g_apb.apb06,"' AND pmn02='",g_apb.apb07,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102 
      PREPARE sel_pmn40_pre1 FROM g_sql
      EXECUTE sel_pmn40_pre1 INTO g_apb.apb25,g_apb.apb251,g_apb.apb26,
                                  g_apb.apb35,g_apb.apb36,g_apb.apb31
   END IF                                      #FUN-940083 add  
 
   IF cl_null(g_apb.apb25) AND NOT cl_null(g_apb.apb31) THEN
      LET l_azf141 = ''      #FUN-B80058
    # LET g_sql = "SELECT azf14 FROM ",l_dbs CLIPPED,"azf_file ",                #FUN-A50102 mark
      LET g_sql = "SELECT azf14,azf141 FROM ",cl_get_target_table(l_azp01,'azf_file'),  #FUN-A50102
                  " WHERE azf01='",g_apb.apb31,"' ",   #FUN-B80058 add azf141
                  "   AND azf02='2' AND azfacti='Y' AND azf09 = '7' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
      PREPARE sel_azf14_pre1 FROM g_sql
      EXECUTE sel_azf14_pre1 INTO g_apb.apb25,l_azf141  #FUN-B80058
      IF g_aza.aza63='Y' AND cl_null(g_apb.apb251) THEN
         #LET g_apb.apb251 = g_apb.apb25
         LET g_apb.apb251 = l_azf141    ##FUN-B80058
      END IF
   END IF
 
   LET g_apb.apblegal = g_legal         #FUN-980001 add
   LET g_apb.apb37 = l_azp01            #FUN-9C0001
   #TQC-C10017  --Begin
   IF cl_null(g_apb.apb25) THEN LET g_apb.apb25= ' ' END IF 
   IF cl_null(g_apb.apb26) THEN LET g_apb.apb26= ' ' END IF
   IF cl_null(g_apb.apb27) THEN LET g_apb.apb27= ' ' END IF
   IF cl_null(g_apb.apb31) THEN LET g_apb.apb31= ' ' END IF
   IF cl_null(g_apb.apb35) THEN LET g_apb.apb35= ' ' END IF
   IF cl_null(g_apb.apb36) THEN LET g_apb.apb36= ' ' END IF
   IF cl_null(g_apb.apb930) THEN LET g_apb.apb930= ' ' END IF
   #TQC-C10017  --End 
   INSERT INTO apb_file VALUES(g_apb.*)
   IF STATUS THEN
      CALL s_errmsg("apb01",g_apb.apb01,"insert apb_file",SQLCA.sqlcode,1)    #NO.FUN-670007
      LET g_totsuccess = 'N'                                                  #NO.FUN-670007
   END IF
 
   LET g_apa.apa31f= g_apa.apa31f+ g_apb.apb24
   LET g_apa.apa31 = g_apa.apa31 + g_apb.apb10
   CALL cl_digcut(g_apa.apa31f,t_azi.azi04) RETURNING g_apa.apa31f   #MOD-790056
   CALL cl_digcut(g_apa.apa31 ,g_azi04) RETURNING g_apa.apa31   #MOD-790056
   LET g_apa.apa32f= g_apa.apa31f * g_apa.apa16 / 100
   LET g_apa.apa32 = g_apa.apa31  * g_apa.apa16 / 100
   CALL cl_digcut(g_apa.apa32f,t_azi.azi04) RETURNING g_apa.apa32f   #No.CHI-6A0004 g_azi-->t_azi
   CALL cl_digcut(g_apa.apa32 ,g_azi04) RETURNING g_apa.apa32      #No.TQC-740142
   LET g_apa.apa34f= g_apa.apa31f+ g_apa.apa32f
   LET g_apa.apa34 = g_apa.apa31 + g_apa.apa32
   CALL cl_digcut(g_apa.apa34f,t_azi.azi04) RETURNING g_apa.apa34f   #MOD-790056
   CALL cl_digcut(g_apa.apa34 ,g_azi04) RETURNING g_apa.apa34   #MOD-790056
   LET g_apa.apa57f= g_apa.apa57f+ g_apb.apb24
   LET g_apa.apa57 = g_apa.apa57 + g_apb.apb10
   CALL cl_digcut(g_apa.apa57f,t_azi.azi04) RETURNING g_apa.apa57f   #MOD-790056
   CALL cl_digcut(g_apa.apa57 ,g_azi04) RETURNING g_apa.apa57   #MOD-790056
   CALL p111_comp_oox(g_apa.apa01) RETURNING g_net
   LET g_apa.apa73 = g_apa.apa34 - g_apa.apa35 + g_net
   CALL cl_digcut(g_apa.apa73,g_azi04) RETURNING g_apa.apa73   #MOD-790056
 
   UPDATE apa_file SET apa31f=g_apa.apa31f,
                       apa32f=g_apa.apa32f,
                       apa34f=g_apa.apa34f,
                       apa60f=g_apa.apa60f,
                       apa61f=g_apa.apa61f,
                       apa31 =g_apa.apa31 ,
                       apa32 =g_apa.apa32 ,
                       apa34 =g_apa.apa34 ,
                       apa60 =g_apa.apa60 ,
                       apa61 =g_apa.apa61 ,
                       apa56 =g_apa.apa56 ,
                       apa57f=g_apa.apa57f,
                       apa57 =g_apa.apa57,
                       apa73 =g_apa.apa73          #A059
          WHERE apa01 = g_apa.apa01
 
   IF STATUS THEN

      CALL s_errmsg("apa01",g_apa.apa01,"upd apa01",SQLCA.sqlcode,1)            #No.FUN-710014
      LET g_totsuccess = 'N'       #No.FUN-710014
   END IF

   IF g_apb.apb34 = 'N' THEN
      LET g_sql = #"UPDATE rvv_file SET rvv23 = (rvv23 + ?) ",   #FUN-9C0001
                # "UPDATE ",l_dbs CLIPPED,"rvv_file SET rvv23 = (rvv23 + ?) ", #FUN-9C0001       #FUN-A50102 mark
                  "UPDATE ",cl_get_target_table(l_azp01,'rvv_file')," SET rvv23 = (rvv23 + ?) ", #FUN-A50102
                  " WHERE rvv01 = ? AND rvv02 = ?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102 
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102 
      PREPARE p111_ins_apb_p FROM g_sql
      EXECUTE p111_ins_apb_p USING g_apb.apb09,g_apb.apb21,g_apb.apb22
   ELSE
      LET g_sql = #"UPDATE rvv_file SET rvv23 = (rvv23 + ?),",   #FUN-9C0001
                # "UPDATE ",l_dbs CLIPPED,"rvv_file SET rvv23 = (rvv23 + ?),",  #FUN-9C0001      #FUN-A50102 mark
                  "UPDATE ",cl_get_target_table(l_azp01,'rvv_file')," SET rvv23 = (rvv23 + ?),", #FUN-A50102	
                  "                                     rvv88 = (rvv88 - ?) ",
                  " WHERE rvv01 = ? AND rvv02 = ?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
      PREPARE p111_ins_apb_p1 FROM g_sql
      EXECUTE p111_ins_apb_p1 USING g_apb.apb09,g_apb.apb09,g_apb.apb21,g_apb.apb22
   END IF
   IF STATUS THEN

      LET g_showmsg=g_apb.apb21,"/",g_apb.apb22
      CALL s_errmsg("rvv01,rvv02",g_showmsg,"upd rvv:",SQLCA.sqlcode,1)
      LET g_totsuccess = "N"
   END IF
 
END FUNCTION
 
FUNCTION p111_ins_apb_2()   #處理大陸版寫入apb_file段
   DEFINE l_cnt             LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_invoice         LIKE apa_file.apa08
   DEFINE l_apydmy3         LIKE apy_file.apydmy3 #FUN-5B0089 add
   DEFINE l_trtype          LIKE apy_file.apyslip # No.FUN-690028 VARCHAR(5) #FUN-5B0089 add
   DEFINE l_rvw12           LIKE rvw_file.rvw12   #No.TQC-790132
   DEFINE l_azf141          LIKE azf_file.azf141  #FUN-B80058
 
  #-MOD-B40008-mark- 
  #DISPLAY "insert apb:",g_apb.apb02,' ',g_apb.apb04,' ',g_apb.apb05,' ',
  #                      g_apb.apb08,' ',g_apb.apb09,' ',g_apb.apb10 AT 3,1
  #-MOD-B40008-end- 
 
   LET g_apb.apb34 = 'N'   #No.TQC-7B0083
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
    WHERE apb21 = g_apb.apb21
      AND apb22 = g_apb.apb22
      AND apa01 = apb01
      AND apa00 = '26'  #暫估應付資料
      AND apa41 ='Y'    #確認
      AND apa42 ='N'    #MOD-810170
      AND apb37 = l_azp01   #FUN-A20006
   IF l_cnt > 0 THEN    #有暫估資料
      LET g_apb.apb34 = 'Y'
   END IF

      DECLARE apb_curs2 CURSOR FOR
         SELECT rvw01,rvw10,rvw17,rvw05,rvw05f,rvw12   #CHI-860024 add rvw01
           FROM rvw_file
          WHERE rvw08 = g_apb.apb21
            AND rvw09 = g_apb.apb22
            AND rvw01 = lg_rvw01     #No.MOD-890156 add
      FOREACH apb_curs2 INTO g_apb.apb11,g_apb.apb09,g_apb.apb23,   #CHI-860024 add gapb.apb11
                             g_apb.apb10,g_apb.apb24,l_rvw12
         LET g_apb.apb02 = g_apb.apb02 + 1
         #生成至aapt210中的數量/單價/金額都應該是正的
         LET g_apb.apb09 = g_apb.apb09 * -1
         LET g_apb.apb08 = g_apb.apb23 * l_rvw12
         LET g_apb.apb10 = g_apb.apb10*(-1)
         LET g_apb.apb101= g_apb.apb10      #No.MOD-A10039 
         LET g_apb.apb24 = g_apb.apb24*(-1)
 
         IF cl_null(g_apb.apb06) THEN
            LET g_apb.apb26 = ''
            LET g_apb.apb35 = ''
            LET g_apb.apb36 = ''
            LET g_apb.apb31 = ''
           # LET g_sql = "SELECT  ima39,ima391 FROM ",l_dbs CLIPPED,"ima_file ",                #FUN-A50102 mark
             LET g_sql = "SELECT  ima39,ima391 FROM ",cl_get_target_table(l_azp01,'ima_file'),  #FUN-A50102
                         " WHERE  ima01 = '",g_apb.apb12,"' "
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102 mark
             CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
             PREPARE sel_ima39_pre2 FROM g_sql
             EXECUTE sel_ima39_pre2 INTO g_apb.apb25,g_apb.apb251
         ELSE

          LET g_sql = "SELECT pmn40,pmn401,pmn67,pmn122,pmn96,pmn98 ",
                    # "  FROM ",l_dbs CLIPPED,"pmn_file ",               #FUN-A50102 amrk
                      "  FROM ",cl_get_target_table(l_azp01,'pmn_file'), #FUN-A50102
                      " WHERE pmn01='",g_apb.apb06,"' ",
                      "   AND pmn02='",g_apb.apb07,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
          PREPARE sel_pmn40_pre  FROM g_sql
          EXECUTE sel_pmn40_pre  INTO g_apb.apb25,g_apb.apb251,g_apb.apb26,
                                      g_apb.apb35,g_apb.apb36,g_apb.apb31 
 
         END IF         #FUN-940083 add
 
         IF cl_null(g_apb.apb25) AND NOT cl_null(g_apb.apb31) THEN
            LET l_azf141 = ''      #FUN-B80058 
          # LET g_sql = "SELECT azf14 FROM ",l_dbs CLIPPED,"azf_file ",                #FUN-A50102
            LET g_sql = "SELECT azf14,azf141 FROM ",cl_get_target_table(l_azp01,'azf_file'),  #FUN-A50102 
                        " WHERE azf01='",g_apb.apb31,"' ",   #FUN-B80058 add azf141
                        "   AND azf02='2' AND azfacti='Y' AND azf09 = '7' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102	
            PREPARE sel_azf14_pre FROM g_sql
            EXECUTE sel_azf14_pre INTO g_apb.apb25,l_azf141  #FUN-B80058
            IF g_aza.aza63='Y' AND cl_null(g_apb.apb251) THEN
               #LET g_apb.apb251 = g_apb.apb25
               LET g_apb.apb251 = l_azf141  #FUN-B80058
            END IF
         END IF
 
         LET g_apb.apblegal = g_legal         #FUN-980001 add
         LET g_apb.apb37 = l_azp01             #FUN-9C0001
         INSERT INTO apb_file VALUES(g_apb.*)
         IF STATUS THEN
            CALL s_errmsg("apb01",g_apb.apb01,"insert apb_file",SQLCA.sqlcode,1)    #NO.FUN-670007
            LET g_totsuccess = 'N'                                                  #NO.FUN-670007
         END IF
 
         LET g_apa.apa31f= g_apa.apa31f+ g_apb.apb24
         LET g_apa.apa31 = g_apa.apa31 + g_apb.apb10
         CALL cl_digcut(g_apa.apa31f,t_azi.azi04) RETURNING g_apa.apa31f   #MOD-790056
         CALL cl_digcut(g_apa.apa31 ,g_azi04) RETURNING g_apa.apa31   #MOD-790056
         LET g_apa.apa32f= g_apa.apa31f * g_apa.apa16 / 100
         LET g_apa.apa32 = g_apa.apa31  * g_apa.apa16 / 100
         CALL cl_digcut(g_apa.apa32f,t_azi.azi04) RETURNING g_apa.apa32f   #No.CHI-6A0004 g_azi-->t_azi
         CALL cl_digcut(g_apa.apa32 ,g_azi04) RETURNING g_apa.apa32      #No.TQC-740142
         LET g_apa.apa34f= g_apa.apa31f+ g_apa.apa32f
         LET g_apa.apa34 = g_apa.apa31 + g_apa.apa32
         CALL cl_digcut(g_apa.apa34f,t_azi.azi04) RETURNING g_apa.apa34f   #MOD-790056
         CALL cl_digcut(g_apa.apa34 ,g_azi04) RETURNING g_apa.apa34   #MOD-790056
         LET g_apa.apa57f= g_apa.apa57f+ g_apb.apb24
         LET g_apa.apa57 = g_apa.apa57 + g_apb.apb10
         CALL cl_digcut(g_apa.apa57f,t_azi.azi04) RETURNING g_apa.apa57f   #MOD-790056
         CALL cl_digcut(g_apa.apa57 ,g_azi04) RETURNING g_apa.apa57   #MOD-790056
         CALL p111_comp_oox(g_apa.apa01) RETURNING g_net
         LET g_apa.apa73 = g_apa.apa34 - g_apa.apa35 + g_net
         CALL cl_digcut(g_apa.apa73,g_azi04) RETURNING g_apa.apa73   #MOD-790056
 
         UPDATE apa_file SET apa31f=g_apa.apa31f,
                             apa32f=g_apa.apa32f,
                             apa34f=g_apa.apa34f,
                             apa60f=g_apa.apa60f,
                             apa61f=g_apa.apa61f,
                             apa31 =g_apa.apa31 ,
                             apa32 =g_apa.apa32 ,
                             apa34 =g_apa.apa34 ,
                             apa60 =g_apa.apa60 ,
                             apa61 =g_apa.apa61 ,
                             apa56 =g_apa.apa56 ,
                             apa57f=g_apa.apa57f,
                             apa57 =g_apa.apa57,
                             apa73 =g_apa.apa73          #A059
                WHERE apa01 = g_apa.apa01
 
         IF STATUS THEN

            CALL s_errmsg("apa01",g_apa.apa01,"upd apa01",SQLCA.sqlcode,1)            #No.FUN-710014
            LET g_totsuccess = 'N'       #No.FUN-710014
         END IF

         IF g_apb.apb34 = 'N' THEN
            LET g_sql = #"UPDATE rvv_file SET rvv23 = (rvv23 + ?) ",  #FUN-9C0001
                      # " UPDATE ",l_dbs CLIPPED,"rvv_file SET rvv23 = (rvv23 + ?) ",  #FUN-9C0001      #FUN-A50102 mark
                        " UPDATE ",cl_get_target_table(l_azp01,'rvv_file')," SET rvv23 = (rvv23 + ?) ", #FUN-A50102
                        "  WHERE rvv01 = ? AND rvv02 = ?"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102        
            PREPARE p111_ins_apb_p_2 FROM g_sql
            EXECUTE p111_ins_apb_p_2 USING g_apb.apb09,g_apb.apb21,g_apb.apb22
         ELSE
            LET g_sql = #"UPDATE rvv_file SET rvv23 = (rvv23 + ?),",   #FUN-9C0001
                      # "UPDATE ",l_dbs CLIPPED,"rvv_file SET rvv23 = (rvv23 + ?),", #FUN-9C0001       #FUN-A50102 mark
                        "UPDATE ",cl_get_target_table(l_azp01,'rvv_file')," SET rvv23 = (rvv23 + ?),", #FUN-A50102
                        "                                     rvv88 = (rvv88 - ?) ",
                        " WHERE rvv01 = ? AND rvv02 = ?"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102
            PREPARE p111_ins_apb_p1_2 FROM g_sql
            EXECUTE p111_ins_apb_p1_2 USING g_apb.apb09,g_apb.apb09,g_apb.apb21,g_apb.apb22
         END IF
         IF STATUS THEN
            LET g_showmsg=g_apb.apb21,"/",g_apb.apb22
            CALL s_errmsg("rvv01,rvv02",g_showmsg,"upd rvv:",SQLCA.sqlcode,1)
            LET g_totsuccess = "N"
         END IF
 
         IF g_rvv17 != 0 THEN
            IF NOT cl_null(g_apb.apb11) THEN   #MOD-890188 add
               CALL p111_ins_apk()
            END IF                             #MOD-890188 add
         END IF
      END FOREACH   #CHI-860024 add
 
END FUNCTION
 
FUNCTION p111_ins_apk()
   DEFINE l_tax       LIKE apb_file.apb10
   DEFINE l_apb10     LIKE apb_file.apb10          #No.MOD-510140
   DEFINE l_apb24     LIKE apb_file.apb24          #No.MOD-510140
   DEFINE l_invoice   LIKE apa_file.apa08
   DEFINE l_apk05     LIKE apa_file.apa09
   DEFINE l_apk       RECORD LIKE apk_file.*
   DEFINE l_n         LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_azi04     LIKE azi_file.azi04
   DEFINE l_trtype    LIKE apy_file.apyslip      #FUN-990014
   

 
   INITIALIZE l_apk.* TO NULL
   LET l_apk.apk01 = g_apb.apb01              #折讓單
   LET l_apk.apk02 = g_apb.apb02              #項次
 
   #非大陸版功能, 或未使用稅控接口系統, 發票不需拆明細
   IF (g_aza.aza26 != '2' OR g_aza.aza46 = 'N') THEN #No.FUN-580006
      LET l_apk.apk17 = g_apa.apa17
      LET l_apk.apk172 = g_apa.apa172
      DECLARE apk_curs CURSOR FOR SELECT rvw02,rvw03,rvw04,rvw11,rvw12,
                                         SUM(rvw05),SUM(rvw06),
                                         SUM(rvw05f),SUM(rvw06f)
                                    FROM rvw_file
                                   WHERE rvw01 = g_apb.apb11
                                   GROUP BY rvw02,rvw03,rvw04,rvw11,rvw12
 
      OPEN apk_curs
      FETCH apk_curs INTO l_apk.apk05,l_apk.apk11,l_apk.apk29,l_apk.apk12,
                          l_apk.apk13,l_apk.apk08,l_apk.apk07,l_apk.apk08f,
                          l_apk.apk07f

     #-----------------------------------MOD-BB0152----------------------start
      IF sqlca.sqlcode = 100 THEN
         SELECT amd05 INTO l_apk.apk05
           FROM amd_file
          WHERE amd03 = g_apb.apb11
         LET l_apk.apk11 = g_apa.apa15
         LET l_apk.apk29 = g_apa.apa16
         LET l_apk.apk12 = g_apa.apa13
         LET l_apk.apk13 = g_apa.apa14
      END IF
     #-----------------------------------MOD-BB0152------------------------end

      SELECT SUM(apb10),SUM(apb24) INTO l_apb10,l_apb24
        FROM apb_file
       WHERE apb01 = g_apa.apa01
         AND apb02 = g_apb.apb02   
 
      IF cl_null(l_apb10) THEN
         LET l_apb10 = 0
      END IF
 
      IF cl_null(l_apb24) THEN
         LET l_apb24 = 0
      END IF
 
       LET l_apk.apk07 = l_apb10 * g_apa.apa16 / 100     
       LET l_apk.apk08 = l_apb10                         
       LET l_apk.apk07f = l_apb24 * g_apa.apa16 / 100    
       LET l_apk.apk08f = l_apb24                        
 

   ELSE
      SELECT rvw02,rvw04,rvw05,rvw06,rvw07,rvw10,rvw03,rvw11,rvw12,
             rvw05f,rvw06f
        INTO l_apk.apk05,l_apk.apk29,l_apk.apk08,l_apk.apk07,l_apk.apk28,
             l_apk.apk30,l_apk.apk11,l_apk.apk12,l_apk.apk13,l_apk.apk08f,
             l_apk.apk07f
        FROM rvw_file
       WHERE rvw01 = g_apb.apb11
         AND rvw08 = g_apb.apb21
         AND rvw09 = g_apb.apb22
 
      IF l_apk.apk29 > 0 THEN
         LET l_apk.apk172 = 'S'
      END IF
      LET l_apk.apk30 = l_apk.apk30 * -1
      LET l_apk.apk08 = l_apk.apk08  * -1
      LET l_apk.apk07 = l_apk.apk07  * -1
      LET l_apk.apk08f = l_apk.apk08f * -1
      LET l_apk.apk07f = l_apk.apk07f * -1
   END IF
 
   IF l_apk.apk08 IS NULL THEN
      LET l_apk.apk08 = 0
   END IF
 
   IF l_apk.apk07 IS NULL THEN
      LET l_apk.apk07 = 0
   END IF
 
   IF l_apk.apk08f IS NULL THEN
      LET l_apk.apk08f = 0
   END IF
 
   IF l_apk.apk07f IS NULL THEN
      LET l_apk.apk07f = 0
   END IF
 
   LET l_apk.apk06 = l_apk.apk08 + l_apk.apk07
   LET l_apk.apk06f = l_apk.apk08f+ l_apk.apk07f
 
   #no.A010依幣別取位
   LET l_apk.apk06 = cl_digcut(l_apk.apk06,g_azi04)        #No.CHI-6A0004 g_azi-->t_azi  #No.TQC-740142 t_azi-->g_azi
   LET l_apk.apk07 = cl_digcut(l_apk.apk07,g_azi04)        #No.CHI-6A0004 g_azi-->t_azi  #No.TQC-740142 t_azi-->g_azi
   LET l_apk.apk08 = cl_digcut(l_apk.apk08,g_azi04)        #No.CHI-6A0004 g_azi-->t_azi  #No.TQC-740142 t_azi-->g_azi
 
   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = l_apk.apk12
 
   LET l_apk.apk06f = cl_digcut(l_apk.apk06f,l_azi04)
   LET l_apk.apk07f = cl_digcut(l_apk.apk07f,l_azi04)
   LET l_apk.apk08f = cl_digcut(l_apk.apk08f,l_azi04)
 
   LET l_apk.apk03 = g_apb.apb11                  #發票號碼
   LET l_apk.apk04 = g_apa.apa18                  #統一編號
   LET l_apk.apk171 = '23'
   LET l_apk.apk25 = g_apb.apb12
   LET l_apk.apkacti = 'Y'
   LET l_apk.apkuser = g_user
   LET l_apk.apkgrup = g_grup
   LET l_apk.apkdate = today
 
   IF l_apk.apk06 != 0 THEN

      LET l_apk.apklegal = g_legal         #FUN-980001 add
      LET l_trtype = trtype[1,g_doc_len]
      SELECT apyvcode INTO l_apk.apk32 FROM apy_file WHERE apyslip = l_trtype
        IF cl_null(l_apk.apk32) THEN
           LET l_apk.apk32 = g_apz.apz63   #FUN-970108 add
        END IF 
      LET l_apk.apkoriu = g_user      #No.FUN-980030 10/01/04
      LET l_apk.apkorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO apk_file VALUES (l_apk.*)
      IF STATUS THEN
         LET g_showmsg=l_apk.apk01,"/",l_apk.apk02,"/",l_apk.apk03
         CALL s_errmsg("apk01,apk02,apk03",g_showmsg,"ins apk:",SQLCA.sqlcode,1)
         LET g_totsuccess = 'N'
      END IF
   END IF
 

 
END FUNCTION

#CHI-A90002 add --start--
FUNCTION p111_apa05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_pmc05   LIKE pmc_file.pmc05
   DEFINE l_pmcacti LIKE pmc_file.pmcacti

   SELECT pmc05,pmcacti
     INTO l_pmc05,l_pmcacti
     #FROM pmc_file WHERE pmc01 = g_apa.apa05   #MOD-D60145
     FROM pmc_file WHERE pmc01=g_vendor          #MOD-D60145

   LET g_errno = ' '

   CASE
      WHEN l_pmcacti = 'N'            LET g_errno = '9028'
      WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'
     
      WHEN l_pmc05   = '0'            LET g_errno = 'aap-032'        
      WHEN l_pmc05   = '3'            LET g_errno = 'aap-033' 
 
      WHEN STATUS=100 LET g_errno = '100'
      WHEN SQLCA.SQLCODE != 0
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE

   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF

   IF p_cmd='d' THEN
      RETURN
   END IF

END FUNCTION
#CHI-A90002 add --end--
 
FUNCTION p110_apa36(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_apr02     LIKE apr_file.apr02
   DEFINE l_aps       RECORD LIKE aps_file.*
   DEFINE l_depno     LIKE apa_file.apa22   #FUN-660117
   DEFINE l_d_actno   LIKE apt_file.apt03   #FUN-660117
   DEFINE l_c_actno   LIKE apt_file.apt04   #FUN-660117
   DEFINE l_e_actno   LIKE apa_file.apa511  #No.FUN-680029
   DEFINE l_f_actno   LIKE apa_file.apa541  #No.FUN-680029
 
   LET g_errno = ' '
 
   SELECT apr02 INTO l_apr02 FROM apr_file
    WHERE apr01 = g_apa.apa36
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-044'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      LET l_apr02 = ''
   END IF
 
   DISPLAY l_apr02 TO apr02
 
   IF p_cmd = 'd' THEN
      RETURN
   END IF
 
   IF g_apz.apz13 = 'Y' THEN
      LET l_depno = g_apa.apa22
   ELSE
      LET l_depno = ' '
   END IF
 
   SELECT * INTO l_aps.* FROM aps_file
    WHERE aps01 = l_depno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aps_file",l_depno,"",'aap-053',"","",1)   #No.FUN-660122
      RETURN
   END IF
 
   SELECT apt03,apt04 INTO l_d_actno,l_c_actno FROM apt_file
    WHERE apt01 = g_apa.apa36
      AND apt02 = l_depno
   IF SQLCA.sqlcode THEN
      LET l_d_actno = l_aps.aps41
      LET l_c_actno = l_aps.aps45
   END IF
   IF g_aza.aza63 = 'Y' THEN
      SELECT apt031,apt041 INTO l_e_actno,l_f_actno FROM apt_file
       WHERE apt01 = g_apa.apa36
         AND apt02 = l_depno
      IF SQLCA.sqlcode THEN
         LET l_e_actno = l_aps.aps411
         LET l_f_actno = l_aps.aps451
      END IF
   END IF
 
   LET g_apa.apa51 = l_d_actno
   LET g_apa.apa54 = l_c_actno
   IF g_aza.aza63 = 'Y' THEN
      LET g_apa.apa511 = l_e_actno
      LET g_apa.apa541 = l_f_actno
   END IF
 
END FUNCTION
 
FUNCTION p110_apa21(p_cmd)
 
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_gen03   LIKE gen_file.gen03
   DEFINE l_genacti LIKE gen_file.genacti
 
   SELECT gen03,genacti INTO l_gen03,l_genacti
     FROM gen_file
    WHERE gen01 = g_apa.apa21
 
   LET g_errno = ' '
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
 
   LET g_apa.apa22 = l_gen03
   DISPLAY BY NAME g_apa.apa22
 
END FUNCTION
 
FUNCTION p110_apa22(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_gemacti LIKE gem_file.gemacti
 
   SELECT gemacti INTO l_gemacti
     FROM gem_file
    WHERE gem01 = g_apa.apa22
 
   LET g_errno = ' '
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p111_comp_oox(p_apv03)
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
 
FUNCTION p111_ins_apc()
  DEFINE l_apa   RECORD LIKE apa_file.*
 
    SELECT * INTO l_apa.* FROM apa_file WHERE apa01=g_apa.apa01
    IF SQLCA.sqlcode THEN
       IF g_bgerr THEN
          CALL s_errmsg('apa01',g_apa.apa01,'',SQLCA.sqlcode,1)
       ELSE
          CALL cl_err(g_apa.apa01,SQLCA.sqlcode,1)
       END IF
       LET g_success = 'N'
    END IF
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_apa.apa13
    LET g_apc.apc01 = l_apa.apa01
    LET g_apc.apc02 = 1
    IF cl_null(l_apa.apa11) THEN
       SELECT pmc17 INTO g_apc.apc03 FROM pmc_file
        WHERE pmc01 = l_apa.apa05
    ELSE
        LET g_apc.apc03 = l_apa.apa11
    END IF
    LET g_apc.apc04 = l_apa.apa12
    IF cl_null(l_apa.apa64) THEN
       LET g_apc.apc05 = g_apc.apc04
    ELSE
       LET g_apc.apc05 = l_apa.apa64
    END IF
    LET g_apc.apc06 = l_apa.apa14
    LET g_apc.apc07 = l_apa.apa72
    LET g_apc.apc08 = l_apa.apa34f
    LET g_apc.apc09 = l_apa.apa34
    LET g_apc.apc10 = l_apa.apa35f
    LET g_apc.apc11 = l_apa.apa35
    LET g_apc.apc12 = l_apa.apa08
    LET g_apc.apc13 = l_apa.apa73
    LET g_apc.apc14 = l_apa.apa65f
    LET g_apc.apc15 = l_apa.apa65
    LET g_apc.apc16 = l_apa.apa20
    LET g_apc.apc08 = cl_digcut(g_apc.apc08,t_azi04)
    LET g_apc.apc09 = cl_digcut(g_apc.apc09,g_azi04)
    LET g_apc.apc10 = cl_digcut(g_apc.apc10,t_azi04)
    LET g_apc.apc11 = cl_digcut(g_apc.apc11,g_azi04)
    LET g_apc.apc13 = cl_digcut(g_apc.apc13,g_azi04)
    LET g_apc.apc14 = cl_digcut(g_apc.apc14,t_azi04)
    LET g_apc.apc15 = cl_digcut(g_apc.apc15,g_azi04)
    LET g_apc.apc16 = cl_digcut(g_apc.apc16,t_azi04)
    LET g_apc.apclegal = g_legal         #FUN-980001 add
    INSERT INTO apc_file VALUES(g_apc.*)
    IF STATUS THEN
       LET g_success = 'N'
       LET g_showmsg=g_apc.apc01,"/",g_apc.apc03
       CALL s_errmsg('apc01,apc03','','',SQLCA.sqlcode,1)
    END IF
END FUNCTION
 
FUNCTION p111_ins_api()
   DEFINE p_apa            RECORD LIKE apa_file.*
   DEFINE p_apb            RECORD LIKE apb_file.*
   DEFINE p_api            RECORD LIKE api_file.*
   DEFINE l_api            RECORD LIKE api_file.*  #No.FUN-680027 add
   DEFINE l_apc            RECORD LIKE apc_file.*  #No.FUN-680027 add
   DEFINE l_diff_api03     LIKE api_file.api03
   DEFINE l_diff_api05f    LIKE api_file.api05f
   DEFINE l_diff_api05     LIKE api_file.api05
   DEFINE l_apa00          LIKE apa_file.apa00         #No.TQC-5B0220
   DEFINE l_apa13          LIKE apa_file.apa13
   DEFINE l_apa72          LIKE apa_file.apa72
   DEFINE l_apa73          LIKE apa_file.apa73
   DEFINE l_apa541         LIKE apa_file.apa541  #No.FUN-680029
   DEFINE l_apc13          LIKE apc_file.apc13   #No.FUN-680027 add
   DEFINE l_api05          LIKE api_file.api05   #No.FUN-680027
   DEFINE l_api05f         LIKE api_file.api05f  #No.FUN-680027
   DEFINE l_apa14          LIKE apa_file.apa14   #No.FUN-680027
   DEFINE l_amt            LIKE api_file.api05   #No.TQC-7B0083
   DEFINE l_amtf           LIKE api_file.api05f  #No.TQC-7B0083
   DEFINE l_apb10          LIKE api_file.api05   #No.TQC-7B0083
   DEFINE l_apb24          LIKE api_file.api05f  #No.TQC-7B0083
   #No.CHI-A10006 add --start--
   DEFINE l_apa34          LIKE apa_file.apa34
   DEFINE l_apa34f         LIKE apa_file.apa34f
   DEFINE l_apa35          LIKE apa_file.apa35
   DEFINE l_apa35f         LIKE apa_file.apa35f
   #No.CHI-A10006 add --end--
   DEFINE l_gec04          LIKE gec_file.gec04   #MOD-AB0206 
   DEFINE l_gec07          LIKE gec_file.gec07   #MOD-AB0206 
   DEFINE l_apb09          LIKE apb_file.apb09   #MOD-AB0206
   DEFINE l_apb10_1        LIKE apb_file.apb10   #MOD-AB0206
   DEFINE l_apb24_1        LIKE apb_file.apb24   #MOD-AB0206
   DEFINE l_rvv38t         LIKE rvv_file.rvv38t  #MOD-AB0206 
   DEFINE l_apb14          LIKE apb_file.apb14   #MOD-AB0206
   DEFINE l_apb02          LIKE apb_file.apb02   #MOD-AB0206

   LET g_sql = " SELECT apa_file.*,apb_file.* FROM apa_file,apb_file ",
               "  WHERE apa01 = apb01 ",
               "    AND apa01 ='",g_apa.apa01,"' ",
               "    AND apb34 = 'Y'   ",
               "  ORDER BY apa01,apb02 "
 
   PREPARE p110_preapi  FROM g_sql
   IF STATUS THEN
      LET g_showmsg=g_apa.apa01,"/","Y"
      CALL s_errmsg("apa01,apb34",g_showmsg,"prepare",STATUS,0)
      RETURN
   END IF
 
   DECLARE p110_csapi CURSOR WITH HOLD FOR p110_preapi
 
   LET p_api.api02 = '2'
   LET p_api.api01 = g_apa.apa01
 
   FOREACH p110_csapi INTO p_apa.*,p_apb.*
      LET p_api.api01 = p_apa.apa01
      # 尋找該筆資料存在, 何筆暫估中.
      LET p_api.api26 = NULL
      LET p_api.api05f= NULL
      LET p_api.api05 = NULL
      LET p_api.api07 = NULL
      LET p_api.api04 = NULL
 
      LET g_sql = "SELECT apa00,apb01,apb23,apb08,apa22,apa54,apa541",
                  "      ,apa34,apa34f,apa35,apa35f,apb02,apb09,apa14", #No.CHI-A10006 add #MOD-AB0206 add apb02,apb09,apa14
                  "  FROM apb_file,apa_file ",
                  "WHERE apb21 = '",p_apb.apb21,"'",
                  "  AND apb22 = '",p_apb.apb22,"'",
                  "  AND apb01 = apa01",
                  "  AND apa00 IN ('26') ",
                  "  AND apa42 = 'N'"   #MOD-810170
      PREPARE p110_preapb00  FROM g_sql
      IF STATUS THEN
         LET g_showmsg=p_apb.apb21,"/",p_apb.apb22
         CALL s_errmsg("apb21,apb22",g_showmsg,"prepare:",STATUS,0)
         CONTINUE FOREACH
      END IF
 
      DECLARE p110_csapb00 CURSOR WITH HOLD FOR p110_preapb00
 
      LET l_apb02 = ''  #MOD-AB0206
      LET l_apb09 = 0   #MOD-AB0206
      FOREACH p110_csapb00 INTO l_apa00,p_api.api26,p_api.api05f,p_api.api05,p_api.api07,p_api.api04,l_apa541 #No.FUN-680029 新增l_apa541
                               ,l_apa34,l_apa34f,l_apa35,l_apa35f,l_apb02,l_apb09,l_apb14  #No.CHI-A10006 add #MOD-AB0206 add apb02,apb09,apa14
        IF STATUS THEN
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        IF g_aza.aza63 = 'Y' THEN
           LET p_api.api041 = l_apa541
        END IF
        LET p_api.api03 = p_apb.apb02
        LET p_api.api06 = 'UNAP:',p_api.api26

        IF cl_null(p_apb.apb09) OR p_apb.apb09 = 0 THEN
           LET p_api.api05f = p_apb.apb24    #MOD-B80034 mod l_api -> p_api
           LET p_api.api05  = p_apb.apb10    #MOD-B80034 mod l_api -> p_api
        ELSE
           LET p_api.api05f = p_api.api05f * p_apb.apb09
           LET p_api.api05  = p_api.api05  * p_apb.apb09
        END IF

       #-MOD-AB0206-add-
        SELECT gec04,gec07 INTO l_gec04,l_gec07
          FROM gec_file
         WHERE gec01 = p_apa.apa15 
           AND gec011= '1'    
        SELECT rvv38t INTO l_rvv38t                                             
          FROM rvv_file                                                         
         WHERE rvv01 = p_apb.apb21                                              
           AND rvv02 = p_apb.apb22    
        IF p_apb.apb09 <> 0 THEN   #MOD-B40074 add
           IF l_gec07 = 'Y' THEN                                                   
              LET p_api.api05f = l_rvv38t * p_apb.apb09                                    
              LET p_api.api05f = cl_digcut(p_api.api05f,t_azi04)                           
              LET p_api.api05f = p_api.api05f/(1+l_gec04/100)                          
              LET p_api.api05  = p_api.api05f * l_apb14
           END IF
        END IF                     #MOD-B40074 add
        LET l_apb10_1 = 0
        LET l_apb24_1 = 0
        SELECT apb10,apb24 INTO l_apb10_1,l_apb24_1 
          FROM apb_file 
         WHERE apb01=p_api.api26 AND apb02 = l_apb02
        IF p_apb.apb09 = l_apb09 THEN
            LET p_api.api05f = l_apb24_1
            LET p_api.api05  = l_apb10_1 
        END IF 
       #-MOD-AB0206-end-

        SELECT apa13,apa72,apa73
          INTO l_apa13,l_apa72,l_apa73
          FROM apa_file
         WHERE apa01=p_api.api26 AND apa41='Y' AND apa42='N'
        IF g_apz.apz27 = 'Y' AND g_aza.aza17 != l_apa13 THEN
           LET p_api.api05=p_api.api05f*l_apa72
           LET p_api.api05= cl_digcut(p_api.api05,g_azi04)   #No.MOD-650110   #MOD-780215
        END IF
        IF p_api.api05f IS NULL THEN
           LET p_api.api05f = 0
        END IF
        IF p_api.api05 IS NULL THEN
           LET p_api.api05 = 0
        END IF
        LET p_api.api40 = 1
        LET p_api.api35 = p_apb.apb36
        LET p_api.api36 = p_apb.apb31
        LET p_api.api05  = cl_digcut(p_api.api05,g_azi04)                                                                           
        LET p_api.api05f = cl_digcut(p_api.api05f,t_azi04)                                                                          

        #No.CHI-A10006 add --start--
        IF l_apa34f - l_apa35f = p_api.api05f THEN
           LET p_api.api05 = l_apa34 - l_apa35
        END IF
        #No.CHI-A10006 add --end--

        LET p_api.apilegal = g_legal         #FUN-980001 add
        INSERT INTO api_file VALUES(p_api.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3('ins','api_file',p_api.api01,'','',SQLCA.sqlcode,'',1)
           LET g_success = 'N'
        END IF
      END FOREACH
   END FOREACH
 
   #衝暫估的diff值
   LET l_apb10=0
   LET l_apb24=0
   SELECT SUM(apb10),SUM(apb24) INTO l_apb10,l_apb24 FROM apb_file
    WHERE apb01=g_apa.apa01
      AND apb34='N'
   IF cl_null(l_apb10) THEN LET l_apb10=0 END IF
   IF cl_null(l_apb24) THEN LET l_apb24=0 END IF
   LET l_amt  = g_apa.apa31  - g_apa.apa60  - l_apb10 - g_apa.apa33
   LET l_amtf = g_apa.apa31f - g_apa.apa60f - l_apb24 - g_apa.apa33f
   SELECT MAX(api03)+1,SUM(api05f),SUM(api05)
     INTO l_diff_api03,l_diff_api05f,l_diff_api05
     FROM api_file WHERE api01 = p_api.api01
   IF l_amt = l_diff_api05 AND l_amtf = l_diff_api05f THEN
   ELSE
      LET l_diff_api05 = l_amt - l_diff_api05
      LET l_diff_api05 = cl_digcut(l_diff_api05,g_azi04)   #No.MOD-650110   #MOD-780215
      LET l_diff_api05f= l_amtf- l_diff_api05f
      LET l_diff_api05f= cl_digcut(l_diff_api05f,t_azi04)   #No.MOD-650110   #MOD-780215
      IF g_apz.apz13 = 'Y' THEN                                                 
         SELECT * INTO g_aps.* FROM aps_file WHERE aps01 = g_apa.apa22          
      ELSE                                                                      
         SELECT * INTO g_aps.* FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
      END IF 
      LET p_api.api03=l_diff_api03
      LET p_api.api04 =g_aps.aps44                                              
      LET p_api.api041=g_aps.aps441 
      LET p_api.api05f=l_diff_api05f
      LET p_api.api05=l_diff_api05
      LET p_api.api06='UNAP:DIFF'
      LET p_api.api26='DIFF'
      LET p_api.api40=NULL
 
      LET p_api.api35 = ' '
      LET p_api.api36 = ' '
        LET p_api.api05  = cl_digcut(p_api.api05,g_azi04)                                                                           
        LET p_api.api05f = cl_digcut(p_api.api05f,t_azi04)                                                                          
      LET p_api.apilegal = g_legal         #FUN-980001 add
      INSERT INTO api_file VALUES(p_api.*)
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         LET g_showmsg=p_api.api01,"/",p_api.api02,"/",p_api.api03
         CALL s_errmsg("api01,api02,api03",g_showmsg,"insert api diff",SQLCA.sqlcode,1)
      END IF
   END IF
END FUNCTION
#No.FUN-9C0077 程式精簡
