# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: s_g_ar.4gl    
# Descriptions...: 自動產生應收帳款副程式
# Date & Author..: 96/05/07 By Roger
# Remark ........: 
# Modify.........: 97-04-17 modify by joanne 1.不判斷參數 ooz17
#                                            2.因銷退折讓需自動編號, 故
#                                              增加傳銷退折讓單號
# Modify.........: 97-07-25 By sophia axrp310增加單別,若輸入則自動編號,
#                                     否則dafualt原單號
# Modify.........: 01-04-16 by plum 傳參數增加一個: 科目類別 for 銷退用
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No:8690 03/11/11 By Kitty 1064行oma60改oma61
# Modify.........: No:9647 04/06/08 By Kitty 原作法造成科目取錯
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-530879 05/04/19 By Nicola 銷退折讓產生沒有判斷單身筆數的參數
# Modify ........: No.MOD-540136 05/05/05 By ching fix限額問題
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-560070 05/06/15 By Smapmin 單位數量改抓計價單位計價數量
# Modify.........: No.FUN-560116 05/07/07 By Nicola 新增顯示(MESSAGE)產生單號,使有用發票限額 知道產生過程
# Modify.........: No.MOD-580015 05/08/03 By Smapmin 自動產生時,轉入出貨單之專案代碼(oga46)
# Modify.........: No.MOD-580158 05/08/24 By Smapmin 應收款日及票到期日,在銷退折讓拋轉時,
#                                                    應預設該銷退折讓單的立帳日期
# Modify.........: No.FUN-5A0124 05/10/20 By elva insert帳款資料時加oma65欄位
# Modify.........: No.MOD-590092 05/10/25 By Carrier 拆分時數量計算錯誤
# Modify.........: No.MOD-5B0140 05/12/07 By Smapmin LET oma60=oma24
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.MOD-630073 06/03/30 By Smapmin 發票限額的處理僅限於大陸版
# Modify.........: No.FUN-640029 06/04/14 By kim GP3.0 匯率改善功能
# Modify.........: No.FUN-640191 06/04/14 By kim GP3.0 匯率改善功能
# Modify.........: No.TQC-5C0086 05/12/21 By Carrier AR月底重評修改 
# Modify.........: NO.FUN-630015 06/05/25 By YITING s_rdate2改 s_rdatem
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: NO.FUN-670026 06/07/26 By Tracy 應收銷退合并
# Modify.........: No.FUN-680001 06/08/02 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670047 06/08/16 By Ray 增加兩帳套功能
# Modify.........: No.FUN-680022 06/08/23 By cl  多帳期處理
# Modify.........: No.FUN-680022 06/08/29 By Tracy s_rdatem()增加一個參數 
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-660073 06/09/08 By Nicola 訂單樣品修改
# Modify.........: NO.FUN-690012 06/10/30 BY rainy  omb33<--oba11
# Modify.........: No.MOD-6A0102 06/11/07 By Smapmin insert into omb_file 時,要加上insert omb00
# Modify.........: No.MOD-6C0041 06/12/07 By Smapmin 銷貨折讓產生應收帳款時,要帶出收款條件
# Modify.........: No.TQC-6B0151 06/12/08 By Smapmin 數量應抓取計價數量
# Modify.........: No.MOD-680041 06/12/08 By Smapmin 訂金本幣金額與立帳本幣金額不符
# Modify.........: No.MOD-6C0100 06/12/18 By Elva 加ogb1005為空時的判斷
# Modify.........: No.MOD-6C0157 06/12/25 By Smapmin 出貨單的INVOICE NO無法產生至應收帳款
# Modify.........: No.TQC-6C0085 06/12/26 By chenl   修正金額錯誤，及單身理由碼錯誤。
# Modify.........: No.TQC-680074 06/12/27 By Smapmin 為因應s_rdatem.4gl程式內對於dbname的處理,故LET g_dbs2=g_dbs,'.'
# Modify.........: No.FUN-710050 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720017 07/02/07 By Smapmin 原幣未稅/含稅金額不需再重算
# Modify.........: No.MOD-730100 07/03/21 By Smapmin 修改SQL條件
# Modify.........: No.TQC-740047 07/04/12 By Rayven axrp310立帳若數量為0，依舊會有單價金額
# Modify.........: No.MOD-740413 07/05/09 By chenl   若oma51,oma51f為空則賦0值
# Modify.........: No.MOD-760008 07/06/04 By Smapmin 無論是否拋轉傳票,都應LET oma34 = oha09
# Modify.........: No.MOD-760078 07/06/20 By Smapmin g_azi<->t_azi
# Modify.........: No.MOD-760144 07/06/29 By Smapmin 修改WHERE 條件
# Modify.........: No.TQC-7B0062 07/11/13 By wujie   oma和omc的金額截位不同,導致四舍五入時有差異
# Modify.........: No.TQC-7B0082 07/11/14 By wujie   若多帳期按比率來產生omc，比率位數大于設定的金額截位，會造成omc金額四舍五入，與oma金額不符
# Modify.........: No.TQC-7B0097 07/11/19 By Smapmin 未拋轉簽核欄位
# Modify.........: No.MOD-7B0192 07/11/22 By Smapmin 判斷金額為NULL時,給0
# Modify.........: No.TQC-7B0144 07/11/27 By chenl  1.生成的應收單未對oma64賦值。
# Modify.........:                                  2.修正數值錯誤。
# Modify.........: No.TQC-7C0146 07/12/19 By claire 中斷點出貨單需對oma99給值
# Modify.........: No.FUN-810045 08/03/23 By rainy 項目管理，專案相關欄位代入omb
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-850063 08/05/19 By Sarah s_g_ar_11_omb()裡應判斷oma00='11'去抓omb_file資料,s_g_ar_12_omb()裡增加當oma00='12'or'13'時抓oba11->omb32
# Modify.........: No.MOD-850248 08/05/26 By Sarah s_g_ar_21()最後增加CALL s_up_omb()
# Modify.........: No.TQC-870024 08/07/16 By lutingting 將單號為TQC-810037由21區過單到31區：應收金額應考慮折扣率
# Modify.........: No.MOD-8B0198 08/11/20 By Sarah 計算oma52,oma53前需判斷oma213,當oma213='N'時維持原算法,當oma213='Y'時,應以含稅金額回推
# Modify.........: No.MOD-8C0001 08/12/01 By claire 中斷點銷退單需對oma99給值
# Modify.........: No.MOD-8C0100 08/12/10 By sherry 通過出貨單上的“拋轉應收”按鈕生成的應收單據中，oma66沒有賦值
# Modify.........: NO.FUN-8C0078 08/12/22 BY yiting 訂金/尾款立帳多期
# Modify.........: No.MOD-910143 09/01/14 By Sarah 自動產生時,轉入訂單之專案代碼(oea46)
# Modify.........: No.MOD-920331 09/02/26 By liuxqa 如果出貨單同時使用了多倉批和料號替代功能，
#                                            在INSERT OMB_FILE時，沒有考慮多倉批ogc_file的資料，
#                                            會造成立賬單身料號和真正的異動料號不一致。
# Modify.........: No.MOD-920366 09/02/26 By Smapmin 銷退單立帳時沒有insert omc_file
# Modify.........: No.MOD-920269 09/02/26 By Sarah 出貨拋轉時,訂金金額(oma52,oma53)應為未含稅金額
# Modify.........: No.CHI-920086 09/03/03 By Sarah
#                  當有訂單變更且有訂金比率時,依據以下規則處理:
#                  1.若大於待抵金額時,應以待抵金額為主,剩餘金額則放入未稅金額中,若有稅率需一併計算稅額
#                  2.若小於待抵金額時,則維持目前金額
# Modify.........: No.MOD-930061 09/03/06 By shiwuying 有關發票限額控管，不超過就LET p_flag = 'N'
# Modify.........: No.MOD-930202 09/03/19 By ve007 銷退單立帳未帶出理由碼
# Modify.........: No.FUN-930141 09/03/23 By ve007 MOD-930202的BUG
# Modify.........: No.MOD-940286 09/04/22 By lilingyu 若有多倉儲出貨時,第二筆應收產生的數量會是負數
# Modify.........: No.TQC-940147 09/04/24 By liuxqa mark MOD-920331
# Modify.........: No.MOD-950104 09/05/12 By lilingyu 單價omob13只抓ogb13
# Modify.........: No.FUN-860006 09/03/25 By jamie 新增"單價為0立帳"選項
# Modify.........: No.MOD-960308 09/06/25 By Sarah s_g_ar_bu()段,g_oma.oma52取位移到IF l_oma54 < g_oma.omg52 THEN前
# Modify.......... No.FUN-960140 09/06/29 By lutingting GP5.2修改
# Modify.........: No.MOD-980026 09/08/05 By mike FUNCTION s_g_ar_21_oma()段,增加給予值oma161=0,oma162=100,oma163=0                 
# Modify.........: No.TQC-8C0091 09/08/18 By hongmei 同FUN-8C0078
# Modify.........: No.FUN-980011 09/08/28 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/17 By douzh 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/16 By lutingtingGP5.2財務 根据occ73生成应收
# Modify.........: No:MOD-9A0086 09/10/29 By mike FUNCTION s_g_ar_12()段,抓取g_ooy.*值的段落请往前搬到CALL s_g_ar_12_oma()前        
# Modify.........: No:FUN-9A0093 09/10/30 By lutingting拋轉時給omb44賦值
# Modify.........: No:MOD-9B0073 09/11/12 By xiaofeizhu axrp310在拋轉賬款的時候，如果遇到單价為0的情況，在拋轉的時候會將數量也置為0
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No:FUN-9C0014 09/12/03 By shiwuying axrp310改為可從同法人下不同DB抓資料
# Modify.........: NO.MOD-9C0288 09/12/19 By lutingting 抓取到得直接收款若為空則給值0
# Modify.........: No.FUN-9C0072 09/12/23 By vealxu 精簡程式碼
# Modify.........: No:MOD-9C0459 09/12/31 By Sarah FUNCTION s_g_ar_21()段增加抓取g_ooy.*值
# Modify.........: No:TQC-A10117 10/01/13 By wujie oma62用错
# Modify.........: No:TQC-A10118 10/01/13 By wujie 漏改oma59处
# Modify.........: No:FUN-A10104 10/01/19 By shiwuying 函數傳參部份修改
# Modify.........: No:TQC-A10154 10/01/25 By sherry 修正TQC-A10117的錯誤
# Modify.........: No:MOD-A30162 10/03/23 By sabrina 取消oma07的判斷
# Modify.........: No:CHI-A50040 10/05/28 By Dido 出貨金額採倒扣制;尾款金額抓取訂單金額比率計算 
# Modify.........: No:TQC-A60027 10/06/08 By Dido 出貨金額採倒扣制抓取已出貨金額與訂單金額調整 
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 1.取消訂單/尾款分期立帳欄位 2.增加訂單多帳期維護3.加接收期別參數
# Modify.........: No.FUN-A50102 10/07/02 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/07/05 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-A70015 10/07/06 By Nicola 需考慮無訂單出貨
# Modify.........: No:MOD-A70194 10/07/27 By Dido 無訂單出貨應與原出貨計算相同 
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056問題
# Modify.........: No:MOD-AA0002 10/10/01 By Dido 客戶編號與收款客戶編號若為 MISC 則抓取原單據客戶簡稱 
# Modify.........: No:MOD-AA0185 10/10/29 By Dido 若客戶為 MISC 則 oma042/oma044 預設值調整為 occm02/occm04 
# Modify.........: No:MOD-AB0101 10/11/11 By Dido SUM ogb14 應以出貨單為主;SUM omb16 應排除作廢部分 
# Modify.........: No:MOD-AB0164 10/11/17 By Dido oga71 需新增至 oma71 
# Modify.........: No:FUN-AC0025 10/12/03 By zhangll  流通财务改善
# Modify.........: No:FUN-AC0027 10/12/17 By lilingyu 流通财务改善
# Modify.........: No:FUN-AB0034 10/12/30 By wujie    流通财务改善
# Modify.........: No:MOD-B10012 11/01/04 By Dido 超交需增加訂單項次條件 
# Modify.........: No.MOD-B10040 11/01/06 By Dido 科目類別請先給客戶慣用科目類別occ67,否則再帶ooz08 
# Modify.........: No.FUN-B10058 11/01/25 By lutingting 流通财务改善
# Modify.........: No.MOD-B30185 11/03/15 By lutingting 订金税额要搭配流通参数以及occ73
# Modify.........: No.FUN-B40032 11/04/13 By baogc 有關應收賬款的修改
# Modify.........: No.MOD-B50216 11/05/25 By Dido 超交出貨金額計算與過濾條件調整;過濾作廢條件 
# Modify.........: No.MOD-B50230 11/05/26 By Dido 計算訂單數量取消項次,依整張訂單數量比對給予訂金金額 
# Modify.........: No.TQC-B60089 11/06/15 By Dido 出貨原幣一律採用倒扣計算,本幣金額依原幣與匯率乘算即可 
# Modify.........: No.TQC-B70009 11/07/01 By wujie 抛转应收帐款时单身科目取值改变
# Modify.........: No.TQC-B70118 11/07/13 By Carrier 流通业态&客户设制'按交款金额产生应收'occ73='Y'时,出货应收不考虑订金是否已经收,取出货总金额-尾款
# Modify.........: No.CHI-B90025 11/09/28 By Polly 程式梳理專案，將計算單身至單頭的程式段合併成一隻
# Modify.........: No.FUN-BA0109 11/11/22 By yinhy 更改omb33，omb331取值
# Modify.........: No.FUN-C10055 12/01/18 By fanbj 調整應收賬款的oma70欄位值
# Modify.........: No:MOD-C20102 12/02/14 By Polly 清空g_omb.*
# Modify.........: No:TQC-C20565 12/03/01 By zhangweib 若單身有分攤折價時，則歸入到直接收款轉費用類型
# Modify.........: No:FUN-C60036 12/06/14 By xuxz oaz92 = 'Y' and aza26 = '2'
# Modify.........: No:FUN-C60036 12/06/29 By minpp 增加omf00查询条件
# Modify.........: No:MOD-C70203 12/08/01 By Elise FUNCTION s_g_ar_12_omb 增加 omb33 清空動作
# Modify.........: No:FUN-C80066 12/08/17 By Lori POS或流通銷退單據轉銷退折讓時,稅額計算不應由單頭的稅率/含稅否計算,應由銷退單單身稅別各自計算稅額
# Modify.........: No:TQC-C80083 12/08/22 By lujh 單價為0時，零售行業可以立賬
# Modify.........: No:MOD-CA0083 12/10/12 By yinhy 給omb33賦值前先清空g_omb.omb33的值
# Modify.........: No:FUN-C90078 12/10/17 By minpp  抓科目时加判断，oma08=1时按原逻辑，否则给外销科目
# Modify.........: No:FUN-CB0057 12/11/14 By xuxz 合併立賬
# Modify.........: No:MOD-D10067 13/01/10 By apo 呼叫s_rdatem時,參數g_plant2改用g_plant_new
# Modify.........: No:MOD-CC0087 13/01/17 By Carrier axmt670单身为折让单据时,有MISC正向费用时,INSERT omb_file中的正向费用数量及金额应为负数
# Modify.........: No:MOD-CA0087 13/01/23 by apo 計價數量為0時，不需抓取
# Modify.........: No:MOD-CA0047 13/01/23 By apo 留置時occacti= 'H'，將判斷微調occacti<>N，讓axrp304仍能轉帶入客戶簡稱oma032
# Modify.........: No:TQC-D10093 13/01/25 By xuxz 走開票流程時無需按限額拆分
# Modify.........: No.FUN-D10101 13/03/07 By wangrr 9主機追單到30主機,axrt300單身新增已開票數量欄位，賦默認值0
# Modify.........: No.FUN-D40067 13/04/18 By xuxz 走開票流程時候嘗試axrt300單身金額直接去axmt670單身金額
# Modify.........: No.FUN-D50008 13/05/23 By lixiang axmt670增加發票日期字段omf31,拋轉到oma09
# Modify.........: No.FUN-D50008 13/05/23 By lixiang axmt670增加發票日期字段omf31,拋轉到oma09
# Modify.........: No.MOD-D60052 13/06/06 By xuxz 不走開票流程無需ohb in omf
# Modify.........: No.MOD-D60122 13/06/15 BY yinhy 沒有出貨單時，oma08按照幣種區分內銷，外銷

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_g_ar.global"      #No.FUN-860006  add  
 
DEFINE g_oma RECORD LIKE oma_file.*
DEFINE g_omb RECORD LIKE omb_file.*
DEFINE g_oga RECORD LIKE oga_file.*
DEFINE g_ogb RECORD LIKE ogb_file.*
DEFINE g_oha RECORD LIKE oha_file.*
DEFINE g_ohb RECORD LIKE ohb_file.*
DEFINE g_oea RECORD LIKE oea_file.*
DEFINE g_oeaa RECORD LIKE oeaa_file.*    #No:FUN-A50103
DEFINE g_oeb RECORD LIKE oeb_file.*
DEFINE g_ofb RECORD LIKE ofb_file.*
DEFINE g_begin       LIKE oma_file.oma01            #No.FUN-680123 VARCHAR(16)               #No.FUN-550071
DEFINE g_oga021      LIKE oga_file.oga021
DEFINE un_gui_qty    LIKE ogb_file.ogb12       #No.FUN-680123 DEC(15,3)  #FUN-4C0013
DEFINE un_gui_act    LIKE ogb_file.ogb14       #No.FUN-670026
DEFINE exT           LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)         #匯率採用方式 (S.銷售 C.海關)
DEFINE g_oma05       LIKE oma_file.oma05       #No.FUN-680123 VARCHAR(1)         #發票別
DEFINE g_way         LIKE oma_file.oma13       #No.FUN-680123 VARCHAR(04)        #科目分類=> ool #TQC-840066
DEFINE g_net         LIKE oox_file.oox10       #No.TQC-5C0086 
DEFINE g_source      LIKE oma_file.oma66       #No.FUN-680123 VARCHAR(10)        #FUN-630043
DEFINE g_oas         RECORD LIKE oas_file.*    #no.FUN-8C0078 add
DEFINE g_sql         STRING                    #NO.FUN-8C0078 add
DEFINE g_oob         RECORD  LIKE oob_file.*   #No.FUN-960140
DEFINE g_ooa         RECORD  LIKE ooa_file.*   #No.FUN-960140
DEFINE g_dept        LIKE    nmh_file.nmh15    #No.FUN-960140
DEFINE g_nmh         RECORD   LIKE nmh_file.*  #No.FUN-960140
DEFINE g_nms         RECORD   LIKE nms_file.*  #No.FUN-960140
DEFINE g_check       LIKE type_file.chr1       #No.FUN-960140 
# 由訂單或出貨單產生應收
DEFINE g_cnt           LIKE type_file.num10      #No.FUN-680123 INTEGER   
DEFINE g_i             LIKE type_file.num5       #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE g_msg           LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(72)
DEFINE g_dbs2          LIKE type_file.chr30   #TQC-680074
#DEFINE g_plant2        LIKE type_file.chr10   #FUN-980020   #MOD-D10067 mark
DEFINE l_dbs           LIKE type_file.chr21   #No.FUN-9C0014 Add
DEFINE l_azp01         LIKE azp_file.azp01    #No.FUN-A10104
DEFINE g_occ73         LIKE occ_file.occ73    #No.FUN-AB0034
DEFINE g_oma00         LIKE oma_file.oma00 
DEFINE g_mTax          LIKE type_file.chr1    # FUN-C10055 add

#FUN-C60036 add--str
DEFINE g_omf00    LIKE omf_file.omf00  #minpp
DEFINE g_omf01    LIKE omf_file.omf01     
DEFINE g_omf02    LIKE omf_file.omf02     
DEFINE g_oaz92        LIKE oaz_file.oaz92
DEFINE g_ogb03         LIKE ogb_file.ogb03 #FUN-C60036
DEFINE g_oaz93        LIKE oaz_file.oaz93
 DEFINE g_ohb03         LIKE ohb_file.ohb03 #FUN-C60036 add
DEFINE   ls_n,ls_n2     LIKE type_file.num10 #FUN-C60036 add xuxz
#FUN-C60036 add--end

FUNCTION s_g_ar(p_no,p_period,p_oma00,p_oma02,p_oma09,p_oma05,p_oma01,p_way,p_source,p_plant,p_omf00,p_omf01,p_omf02)       #No.FUN-9C0014 #No.FUN-A10104    #No:FUN-A50103#FUN-C60036 add omf01,omf02#minpp add omf00
   DEFINE p_no       LIKE oma_file.oma16     #No.FUN-680123 VARCHAR(16)        #訂單單號/出貨單號/銷退單號   #No.FUN-550071                     
   DEFINE p_period   LIKE oma_file.oma165    #期別     #No:FUN-A50103 
   DEFINE p_oma00    LIKE oma_file.oma00     #No.FUN-680123 VARCHAR(02)        #應收類別 (11.訂金應收 12.出貨
                                     #          13.尾款 21.銷退折讓 )
   DEFINE p_oma02    LIKE oma_file.oma02     #No.FUN-680123 DATE            #立帳日期
   DEFINE p_oma09    LIKE oma_file.oma09     #No.FUN-680123 DATE            #發票日期
   DEFINE p_oma05    LIKE oma_file.oma05     #No.FUN-680123 VARCHAR(1)         #發票別
   DEFINE p_oma01    LIKE oma_file.oma01     #銷退折讓單號(僅'21'需傳值)   #FUN-560070  #No.FUN-680123 VARCHAR(16)
   DEFINE p_way      LIKE ool_file.ool01     #科目分類=> ool #No.FUN-680123 VARCHAR(04)
   DEFINE p_source   LIKE oma_file.oma66     #FUN-630043 #No.FUN-680123 VARCHAR(10) 
  #DEFINE p_dbs      LIKE type_file.chr21    #No.FUN-9C0014 Add #No.FUN-A10104
   DEFINE p_plant    LIKE azp_file.azp01     #No.FUN-A10104
   DEFINE p_omf01    LIKE omf_file.omf01     #FUN-C60036 add
   DEFINE p_omf02    LIKE omf_file.omf02     #FUN-C60036 add
   DEFINE p_omf00    LIKE omf_file.omf00     #FUN-C60036 minpp add

   WHENEVER ERROR CONTINUE
   #LET g_plant2 = g_plant        #FUN-980020   #MOD-D10067 mark
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)   #FUN-9B0106
   SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file#FUN-C60036 add
   IF cl_null(p_no) AND g_oaz.oaz92 = 'N' THEN
      RETURN g_oma.oma01,g_oma.oma01
   END IF
   SELECT oaz92,oaz93 INTO g_oaz92,g_oaz93 FROM oaz_file #FUN-C60036 add
   LET g_begin = NULL
   INITIALIZE g_oma.* TO NULL
   INITIALIZE g_omb.* TO NULL    #MOD-C20102 add
   LET g_oma.oma00 = p_oma00
   LET g_oma.oma02 = p_oma02     
   LET g_oma05 = p_oma05
   LET g_way = p_way
   LET g_source = p_source   #FUN-630043
   #FUN-C60036--add-str
   LET g_omf00 = p_omf00 #minpp
   LET g_omf01 = p_omf01
   LET g_omf02 = p_omf02
   #FUN-C60036--add--end
#No.FUN-A10104 -BEGIN-----
#  LET l_dbs = p_dbs         #No.FUN-9C0014 Add
   IF cl_null(p_plant) THEN
      LET l_dbs = ''
      LET g_plant_new = ''    #FUN-A60056
      LET l_azp01 = ''
   ELSE
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
      LET l_azp01 = p_plant
   END IF
#No.FUN-A10104 -END-------
   LET g_oma.oma09 = p_oma09
   LET g_oma.oma16 = p_no
 
   IF p_oma00 = '11' THEN
      CALL s_g_ar_11(p_no,p_period,p_oma01)    #No:FUN-A50103  
   END IF
 
   #IF p_oma00 = '12' THEN   #FUN-B10058
   IF p_oma00 = '12' OR p_oma00 = '19' THEN    #FUN-B10058
      CALL s_g_ar_12(p_no,p_oma01)
   END IF
 
   IF p_oma00 = '13' THEN
     #CALL s_g_ar_12(p_no,p_oma01)   #CHI-A50040 mark
      CALL s_g_ar_11(p_no,p_period,p_oma01)   #CHI-A50040    #No:FUN-A50103 
   END IF
 
   #IF p_oma00 = '21' THEN   #FUN-B10058
   IF p_oma00 = '21' OR p_oma00 = '28' THEN    #FUN-B10058
      CALL s_g_ar_21(p_no,p_oma01)
   END IF
 
   IF g_oma.oma01 IS NULL THEN 
      LET g_success = 'N'
   END IF
 
   RETURN g_begin,g_oma.oma01
 
END FUNCTION
 
#----------------------------(產生訂金應收)----------------------------
FUNCTION s_g_ar_11(p_no,p_period,p_oma01)    #No:FUN-A50103   
   DEFINE p_no        LIKE oea_file.oea01     #單號 #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
   DEFINE p_period    LIKE oma_file.oma165    #期別     #No:FUN-A50103 
   DEFINE p_oma01     LIKE oma_file.oma01     #單號 #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
   DEFINE l_oma01     LIKE oma_file.oma01     #單號 #No.FUN-550071 #No.FUN-680123 VARCHAR(16) 
   DEFINE li_result   LIKE type_file.num5     #No.FUN-550071 #No.FUN-680123 SMALLINT
   DEFINE l_oas05     LIKE oas_file.oas05     #FUN-8C0078
   DEFINE l_cnt       LIKE type_file.num5     #FUN-8C0078
   DEFINE l_oea32     LIKE oea_file.oea32     #FUN-8C0078
   DEFINE l_oeb_cnt   LIKE type_file.num5     #FUN-8C0078
   DEFINE l_n         LIKE type_file.num5  
   DEFINE p_plant     LIKE azw_file.azw01     #FUN-A60056
   DEFINE l_oeaa08    LIKE oeaa_file.oeaa08   #CHI-B90025 add
   DEFINE l_oea01     LIKE oea_file.oea01     #CHI-B90025 add

  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN 
  #   SELECT * INTO g_oea.* FROM oea_file WHERE oea01=p_no
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = " SELECT * FROM ",l_dbs CLIPPED,"oea_file WHERE oea01='",p_no,"'"
      LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
                  " WHERE oea01='",p_no,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
      PREPARE sel_oea_pre1 FROM g_sql
      EXECUTE sel_oea_pre1 INTO g_oea.*
  #END IF    #FUN-A60056 

   IF STATUS THEN 
      IF g_bgerr THEN
         CALL s_errmsg('oea',p_no,'s_g_ar_11:sel oea',STATUS,1)        
      ELSE
         CALL cl_err3("sel","oea_file",p_no,"",STATUS,"","s_g_ar_11:sel oea",1)
      END IF
      LET g_success='N'
      RETURN
   END IF

   #-----No:FUN-A50103-----
   IF cl_null(l_dbs) THEN 
      IF g_oma.oma00 = '11' THEN
         SELECT * INTO g_oeaa.* 
           FROM oeaa_file
          WHERE oeaa01 = p_no
            AND oeaa02 = '1' 
            AND oeaa03 = p_period
      ELSE
         SELECT * INTO g_oeaa.* 
           FROM oeaa_file
          WHERE oeaa01 = p_no
            AND oeaa02 = '2' 
            AND oeaa03 = p_period
      END IF
   ELSE
      IF g_oma.oma00 = '11' THEN
         #LET g_sql = " SELECT * FROM ",l_dbs CLIPPED,"oeaa_file ",
         LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'oeaa_file'), #FUN-A50102
                     "  WHERE oeaa01='",p_no,"'",
                     "    AND oeaa02='1' ",
                     "    AND oeaa03=",p_period
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102                
         PREPARE sel_oeaa_pre1 FROM g_sql
         EXECUTE sel_oeaa_pre1 INTO g_oeaa.*
      ELSE
         #LET g_sql = " SELECT * FROM ",l_dbs CLIPPED,"oeaa_file ",
         LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'oeaa_file'), #FUN-A50102
                     "  WHERE oeaa01='",p_no,"'",
                     "    AND oeaa02='2' ",
                     "    AND oeaa03=",p_period
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102               
         PREPARE sel_oeaa_pre2 FROM g_sql
         EXECUTE sel_oeaa_pre2 INTO g_oeaa.*
      END IF
   END IF

   IF STATUS THEN 
      IF g_bgerr THEN
         CALL s_errmsg('oeaa',p_no,'s_g_ar_11:sel oeaa',STATUS,1)        
      ELSE
         CALL cl_err3("sel","oeaa_file",p_no,"",STATUS,"","s_g_ar_11:sel oeaa",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
   #-----No:FUN-A50103 END-----

   IF NOT cl_null(g_oea.oea80) THEN    #付款條件
      LET l_oea32 = g_oea.oea80   
   ELSE                           
      LET l_oea32 = g_oea.oea32   
   END IF   
 
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   SELECT COUNT(*) INTO l_n FROM rxx_file
  #    WHERE rxx00 = '01' AND rxx01 = p_no
  #      AND rxxplant = g_oea.oeaplant
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"rxx_file ",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'rxx_file'), #FUN-A50102
                  " WHERE rxx00 = '01' AND rxx01 = '",p_no,"'",
                  "   AND rxxplant = '",g_oea.oeaplant,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
      PREPARE sel_rxx_pre2 FROM g_sql
      EXECUTE sel_rxx_pre2 INTO l_n
  #END IF    #FUN-A60056

   IF l_n >0 THEN LET g_check='Y' ELSE LET g_check = 'N' END IF 

 ##-----No:FUN-A50103 Mark-----
 ##-CHI-A50040-add- 
 # IF g_oma.oma00='13' THEN 
 #    SELECT COUNT(*) INTO g_cnt FROM oma_file,omb_file 
 #     WHERE oma00='13' AND oma01=omb01 
 #        AND omb31=g_oea.oea01 AND omavoid='N'     #No.MOD-520011
 #    IF g_cnt >0 THEN
 #       IF g_bgerr THEN
 #          CALL s_errmsg('','',g_oea.oea01,'axr-261',1)
 #       ELSE
 #          CALL cl_err(g_oga.oga01,'axr-261',1)
 #       END IF
 #       LET g_success='N' RETURN 
 #    END IF
 # END IF
 ##-CHI-A50040-end- 
 ##-----No:FUN-A50103 Mark END-----

  #IF g_oea.oea918 = 'N' OR g_check = 'Y' THEN                        #FUN-8C0078 訂金立帳多期  #FUN-960140
   IF g_check = 'Y' THEN                        #FUN-8C0078 訂金立帳多期  #FUN-960140    #No:FUN-A50103
      CALL s_g_ar_11_oma(p_oma01)
     #FUN-A60056--mark--str--
     #IF cl_null(l_dbs) THEN
     #   LET g_sql = "SELECT * FROM oeb_file",
     #               " WHERE oeb01='",p_no,"'",
     #               "   AND oeb1003!='2' AND oeb1012!='Y'"
     #ELSE
     #FUN-A60056--mar--end
         #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oeb_file",
         LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                     " WHERE oeb01='",p_no,"'",
                     "   AND oeb1003!='2' AND oeb1012!='Y'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
     #END IF  #FUN-A60056       
      PREPARE s_g_ar_11_pre3 FROM g_sql
      DECLARE s_g_ar_11_c CURSOR FOR s_g_ar_11_pre3
      LET g_omb.omb03 = 0
      FOREACH s_g_ar_11_c INTO g_oeb.*
         IF STATUS THEN 
            IF g_bgerr THEN
               CALL s_errmsg('','','s_g_ar_11:foreach oeb',STATUS,1)
            ELSE
               CALL cl_err('s_g_ar_11:foreach oeb',STATUS,1)
            END IF
            LET g_success='N' 
            RETURN 
         END IF
         
         IF g_enter_account = "N" AND g_oeb.oeb13 = 0 AND g_azw.azw04 <> '2' THEN   #TQC-C80083  add g_azw.azw04 <> '2'
            CONTINUE FOREACH 
         END IF 
        #------------------MOD-CA0087----------------(S)
         IF g_oeb.oeb917 = 0 THEN
            CONTINUE FOREACH
         END IF
        #------------------MOD-CA0087----------------(E)
 
         LET g_omb.omb03 = g_omb.omb03 + 1
         LET l_oas05 = 0          #FUN-8C0078 add
         IF g_check = 'N' AND ((g_oma.oma08 = '1' AND g_omb.omb03 > g_ooz.ooz121) OR
            (g_oma.oma08 = '2' AND g_omb.omb03 > g_ooz.ooz122)) THEN
           #-------------------------------No.CHI-B90025----------------------------------start
            IF g_oma.oma00='11' THEN
               SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
                WHERE oeaa01 = g_oma.oma16
                  AND oeaa02 = '1'
                  AND oeaa03 = g_oma.oma165
                  AND oeaa01 = oea01
            END IF
            IF g_oma.oma00='13' THEN
               SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
                WHERE oeaa01 = g_oma.oma16
                  AND oeaa02 = '2'
                  AND oeaa03 = g_oma.oma165
                  AND oeaa01 = oea01
            END IF
            CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
            CALL s_g_ar_omc()
           #CALL s_g_ar_bu(l_oas05)  #FUN-8C0078 mod
           #-------------------------------No.CHI-B90025----------------------------------end
            LET l_oma01 = s_get_doc_no(p_oma01)
            CALL  s_auto_assign_no("axr",l_oma01,g_oma.oma02,g_oma.oma00,"oma_file","oma01",
                      "","","")
                      RETURNING li_result,l_oma01
            IF (NOT li_result) THEN
               IF g_bgerr THEN
                  CALL s_errmsg('','',l_oma01,'mfg-059',1)
               ELSE
                  CALL cl_err(l_oma01,'mfg-059',1)
               END IF
               LET g_success = 'N'
            END IF
 
            CALL s_g_ar_11_oma(l_oma01)
            LET g_omb.omb03 = 1
         END IF
         CALL s_g_ar_11_omb()
         IF g_success = 'N' THEN RETURN END IF
      END FOREACH
     #-------------------------------No.CHI-B90025----------------------------------start
      IF g_oma.oma00='11' THEN
         SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
          WHERE oeaa01 = g_oma.oma16
            AND oeaa02 = '1'
            AND oeaa03 = g_oma.oma165
            AND oeaa01 = oea01
       END IF
       IF g_oma.oma00='13' THEN
          SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
           WHERE oeaa01 = g_oma.oma16
             AND oeaa02 = '2'
             AND oeaa03 = g_oma.oma165
             AND oeaa01 = oea01
       END IF
       CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
       CALL s_g_ar_omc()
      #CALL s_g_ar_bu(l_oas05)  #FUN-8C0078 mod
      #-------------------------------No.CHI-B90025----------------------------------end
   ELSE
     #FUN-A60056--mark--str--
     #IF cl_null(l_dbs) THEN
     #   SELECT COUNT(*) INTO l_oeb_cnt FROM oeb_file
     #    WHERE oeb01=p_no
     #      AND oeb1003!='2' AND oeb1012!='Y'
     #ELSE
     #FUN-A60056--mark--end
         #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oeb_file",
         LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                     " WHERE oeb01='",p_no,"'",
                     "   AND oeb1003!='2' AND oeb1012!='Y'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102                
         PREPARE sel_oeb_pre4 FROM g_sql
         EXECUTE sel_oeb_pre4 INTO l_oeb_cnt
     #END IF   #FUN-A60056
      IF g_check = 'N' AND ((g_oea.oea08 = '1' AND l_oeb_cnt > g_ooz.ooz121) OR
         (g_oea.oea08 = '2' AND l_oeb_cnt > g_ooz.ooz122)) THEN
          LET l_oas05 = 0 
          LET l_cnt = 1 
         #FUN-A60056--mark--str--
         #IF cl_null(l_dbs) THEN
         #   LET g_sql = "SELECT * FROM oeb_file ",
         #               " WHERE oeb01='",p_no,"'",
         #               "   AND oeb1003!='2' AND oeb1012!='Y'"
         #ELSE
         #FUN-A60056--mark--end
             #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oeb_file",
             LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                         " WHERE oeb01='",p_no,"'",
                         "   AND oeb1003!='2' AND oeb1012!='Y'"
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
         #END IF     #FUN-A60056 
          PREPARE sel_oeb_pre5 FROM g_sql
          DECLARE s_g_ar_11_c1 CURSOR FOR sel_oeb_pre5
          FOREACH s_g_ar_11_c1 INTO g_oeb.*
              IF STATUS THEN 
                  IF g_bgerr THEN
                     CALL s_errmsg('','','s_g_ar_11:foreach oeb',STATUS,1)
                  ELSE
                     CALL cl_err('s_g_ar_11:foreach oeb',STATUS,1)
                  END IF
                  LET g_success='N' 
                  RETURN 
              END IF
              #---內包一層FOREACH 找oas_file分期條件---
              IF cl_null(l_dbs) THEN
                 LET g_sql = "SELECT * FROM oas_file WHERE oas01= '",l_oea32,"'"
              ELSE
                 #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oas_file WHERE oas01= '",l_oea32,"'"
                 LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oas_file'), #FUN-A50102
                             " WHERE oas01= '",l_oea32,"'"
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	             CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
              END IF              
              PREPARE s_g_ar_oas_p1 FROM g_sql                # RUNTIME 編譯
              DECLARE s_g_ar_oas_c1       
                  CURSOR FOR s_g_ar_oas_p1
              FOREACH s_g_ar_oas_c1 INTO g_oas.*   #收款條件資料
                  IF cl_null(g_oas.oas05) THEN   
                      LET l_oas05 = 0              #收款比率  
                  ELSE
                      LET l_oas05 = g_oas.oas05 
                  END IF 
                  IF l_cnt = 1 THEN                 #第一筆AR以傳入的單號寫入
                      LET l_oma01 = p_oma01
                  ELSE
                      LET l_oma01 = s_get_doc_no(p_oma01)   #第一筆之後自動取號
                      CALL  s_auto_assign_no("axr",l_oma01,g_oma.oma02,g_oma.oma00,"oma_file","oma01",
                                "","","")
                                RETURNING li_result,l_oma01
                      IF (NOT li_result) THEN
                         IF g_bgerr THEN
                            CALL s_errmsg('','',l_oma01,'mfg-059',1)
                         ELSE
                            CALL cl_err(l_oma01,'mfg-059',1)
                         END IF
                         LET g_success = 'N'
                      END IF
                  END IF
                  CALL s_g_ar_11_oma(l_oma01)              #寫入AR單頭資料
                  SELECT MAX(omb03) INTO g_omb.omb03
                    FROM omb_file where omb01 = l_oma01
                  IF cl_null(g_omb.omb03) OR g_omb.omb03 = 0 THEN
                      LET g_omb.omb03 = 1
                  ELSE 
                      LET g_omb.omb03 = g_omb.omb03 + 1
                  END IF 
                  CALL s_g_ar_11_omb()                     #寫入AR單身資料
                  IF g_success = 'N' THEN RETURN END IF
                  LET l_cnt = l_cnt + 1
                 #-------------------------------No.CHI-B90025----------------------------------start
                  IF g_oma.oma00='11' THEN
                     SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
                      WHERE oeaa01 = g_oma.oma16
                        AND oeaa02 = '1'
                        AND oeaa03 = g_oma.oma165
                        AND oeaa01 = oea01
                  END IF
                  IF g_oma.oma00='13' THEN
                     SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
                      WHERE oeaa01 = g_oma.oma16
                        AND oeaa02 = '2'
                        AND oeaa03 = g_oma.oma165
                        AND oeaa01 = oea01
                  END IF
                  CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
                  CALL s_g_ar_omc()
                 #CALL s_g_ar_bu(l_oas05)  #更新單頭金額
                 #-------------------------------No.CHI-B90025----------------------------------end
              END FOREACH
          END FOREACH
      ELSE
         CALL s_g_ar_11_oma(p_oma01)
        #FUN-A60056--mark--str--
        #IF cl_null(l_dbs) THEN
        #   LET g_sql = "SELECT * FROM oeb_file",
        #               " WHERE oeb01='",p_no,"'",
        #               "   AND oeb1003!='2' AND oeb1012!='Y'"
        #ELSE
        #FUN-A60056--mark--end
            #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oeb_file",
            LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                        " WHERE oeb01='",p_no,"'",
                        "   AND oeb1003!='2' AND oeb1012!='Y'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
        #END IF        #FUN-A60056 
         PREPARE s_g_ar_11_pre4 FROM g_sql
         DECLARE s_g_ar_11_4 CURSOR FOR s_g_ar_11_pre4
         LET g_omb.omb03 = 0
         FOREACH s_g_ar_11_4 INTO g_oeb.*
            IF STATUS THEN 
               IF g_bgerr THEN
                  CALL s_errmsg('','','s_g_ar_11:foreach oeb',STATUS,1)
               ELSE
                  CALL cl_err('s_g_ar_11:foreach oeb',STATUS,1)
               END IF
               LET g_success='N' 
               RETURN 
            END IF
            
            IF g_enter_account = "N" AND g_oeb.oeb13 = 0 AND g_azw.azw04 <> '2' THEN   #TQC-C80083  add g_azw.azw04 <> '2'
               CONTINUE FOREACH 
            END IF 
         
            LET g_omb.omb03 = g_omb.omb03 + 1

            CALL s_g_ar_11_omb()
            IF g_success = 'N' THEN RETURN END IF
         END FOREACH
        #-------------------------------No.CHI-B90025----------------------------------start
         IF g_oma.oma00='11' THEN
            SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
             WHERE oeaa01 = g_oma.oma16
               AND oeaa02 = '1'
               AND oeaa03 = g_oma.oma165
               AND oeaa01 = oea01
         END IF
         IF g_oma.oma00='13' THEN
            SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
             WHERE oeaa01 = g_oma.oma16
               AND oeaa02 = '2'
               AND oeaa03 = g_oma.oma165
               AND oeaa01 = oea01
         END IF
         CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
         CALL S_g_ar_omc()
        #CALL s_g_ar_bu(l_oas05)  #FUN-8C0078 mod
        #-------------------------------No.CHI-B90025----------------------------------end
         #-----No:FUN-A50103-----
      #  #LET g_sql = "SELECT * FROM oas_file WHERE oas01= '",l_oea32,"'"
         #IF cl_null(l_dbs) THEN
         #   LET g_sql = "SELECT * FROM oas_file WHERE oas01= '",l_oea32,"'"
         #ELSE
         #   LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oas_file WHERE oas01= '",l_oea32,"'"
         #END IF
         #PREPARE s_g_ar_oas_p2 FROM g_sql                # RUNTIME 編譯
         #DECLARE s_g_ar_oas_c2       
         #    CURSOR FOR s_g_ar_oas_p2
         #LET l_cnt = 1
         #FOREACH s_g_ar_oas_c2 INTO g_oas.*   #收款條件資料
         #    IF cl_null(g_oas.oas05) THEN 
         #        LET l_oas05 = 0 
         #    ELSE
         #        LET l_oas05 = g_oas.oas05 
         #    END IF 
         #    IF l_cnt = 1 THEN 
         #        LET l_oma01 = p_oma01
         #    ELSE
         #        LET l_oma01 = s_get_doc_no(p_oma01)
         #        CALL  s_auto_assign_no("axr",l_oma01,g_oma.oma02,g_oma.oma00,"oma_file","oma01",
         #                  "","","")
         #                  RETURNING li_result,l_oma01
         #        IF (NOT li_result) THEN
         #           IF g_bgerr THEN
         #              CALL s_errmsg('','',l_oma01,'mfg-059',1)
         #           ELSE
         #              CALL cl_err(l_oma01,'mfg-059',1)
         #           END IF
         #           LET g_success = 'N'
         #        END IF
         #    END IF
         #    CALL s_g_ar_11_oma(l_oma01)
         #    IF cl_null(l_dbs) THEN
         #       LET g_sql = "SELECT * FROM oeb_file",
         #                   " WHERE oeb01='",p_no,"'",
         #                   "   AND oeb1003!='2' AND oeb1012!='Y'"
         #    ELSE
         #       LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oeb_file",
         #                   " WHERE oeb01='",p_no,"'",
         #                   "   AND oeb1003!='2' AND oeb1012!='Y'"
         #    END IF
         #    PREPARE sel_oeb_pre6 FROM g_sql
         #    DECLARE s_g_ar_11_c2 CURSOR FOR sel_oeb_pre6
         #    LET g_omb.omb03 = 0
         #    FOREACH s_g_ar_11_c2 INTO g_oeb.*
         #        IF STATUS THEN 
         #            IF g_bgerr THEN
         #               CALL s_errmsg('','','s_g_ar_11:foreach oeb',STATUS,1)
         #            ELSE
         #               CALL cl_err('s_g_ar_11:foreach oeb',STATUS,1)
         #            END IF
         #            LET g_success='N' 
         #            RETURN 
         #        END IF
         #        LET g_omb.omb03 = g_omb.omb03 + 1
         #        CALL s_g_ar_11_omb()
         #        IF g_success = 'N' THEN RETURN END IF
         #        LET l_cnt = l_cnt + 1
         #    END FOREACH
         #    CALL s_g_ar_bu(l_oas05)  #更新單頭金額
         #END FOREACH
         #-----No:FUN-A50103 END-----
      END IF
   END IF

   IF g_check = 'Y' THEN
   #  CALL s_ins_w(g_oma.oma00,g_oma.oma16,g_oma.oma01,'0',l_dbs) #No.FUN-9C0014 #No.FUN-A10104
      CALL s_ins_w(g_oma.oma00,g_oma.oma16,g_oma.oma01,'0',l_azp01) #No.FUN-A10104
           RETURNING g_success
   END IF
END FUNCTION
 
FUNCTION s_g_ar_11_oma(p_oma01)
   DEFINE p_oma01   LIKE oma_file.oma01,     #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
          l_occ06   LIKE occ_file.occ06,
          l_occ07   LIKE occ_file.occ07,
          tot1_12   LIKE oma_file.oma52,     #CHI-A50040
          tot2_12   LIKE oma_file.oma53,     #CHI-A50040
          tot1_23   LIKE oma_file.oma54t,    #CHI-A50040
          tot2_23   LIKE oma_file.oma56t     #CHI-A50040
   DEFINE g_t1      LIKE ooy_file.ooyslip    #TQC-7B0097
   DEFINE l_cnt     LIKE type_file.num10     #FUN-C10055  add
 
   CALL s_g_ar_oma_default()

   IF NOT cl_null(p_oma01) THEN
      LET g_oma.oma01 = p_oma01
   ELSE
      LET g_oma.oma01 = g_oea.oea01
   END IF

   LET g_oma.oma165 = g_oeaa.oeaa03    #No:FUN-A50103

   LET g_oma.oma66 = g_oea.oeaplant      #FUN-960140 add 090824
   LET g_oma.omalegal = g_oea.oealegal  #No.FUN-960140
#  LET g_oma.oma70    = '2'             #No.FUN-960140   #FUN-B40032 MARK

###-FUN-B40032- ADD - BEGIN ---------------------------------------------
   IF g_oea.oea94 <> '' THEN
      LET g_oma.oma70 = '3'
      LET g_mTax= TRUE            #FUN-C10055 add 
   ELSE
      LET g_oma.oma70 = '2'
      LET g_mTax= FALSE           #FUN-C10055 add
   END IF

   #FUN-C10055--start add ------------------------------
   IF g_mTax = FALSE THEN
      SELECT COUNT(*) INTO l_cnt
        FROM oeg_file
       WHERE oeg01 = g_oma.oma16
      IF l_cnt > 0 THEN 
         LET g_mTax = TRUE
      END IF   
   END IF 
   #FUN-C10055--end add --------------------------------
###-FUN-B40032- ADD -  END  ---------------------------------------------

   LET g_oma.oma03 = g_oea.oea03                 #訂單中的客戶 

   IF cl_null(g_oea.oea17) OR g_oea.oea17 = '' THEN #如果訂單中的收款客戶為空，則從客戶主檔抓取）
      SELECT occ07 into g_oma.oma68 FROM occ_file WHERE occ01 = g_oea.oea03
      IF cl_null(l_dbs) THEN
         SELECT occ07 into g_oma.oma68 FROM occ_file WHERE occ01 = g_oea.oea03
      ELSE
         #LET g_sql = "SELECT occ07 FROM ",l_dbs CLIPPED,"occ_file",
         LET g_sql = "SELECT occ07 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                     " WHERE occ01 = '",g_oea.oea03,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
         PREPARE sel_occ_pre60 FROM g_sql
         EXECUTE sel_occ_pre60 INTO g_oma.oma68
      END IF
   ELSE  
      LET g_oma.oma68 = g_oea.oea17              #訂單中的收款客戶 
   END IF 

   IF NOT cl_null(g_oma.oma68) THEN
      IF cl_null(l_dbs) THEN
         SELECT occ02 INTO g_oma.oma69 FROM occ_file
          WHERE occ01 = g_oma.oma68
      ELSE
         #LET g_sql = "SELECT occ02 FROM ",l_dbs CLIPPED,"occ_file",
         LET g_sql = "SELECT occ02 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                     " WHERE occ01 = '",g_oma.oma68,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
         PREPARE sel_occ_pre7 FROM g_sql
         EXECUTE sel_occ_pre7 INTO g_oma.oma69
      END IF
   END IF

   IF cl_null(l_dbs) THEN
      SELECT occ02,occ11,occ18,occ231,occ37
        INTO g_oma.oma032,g_oma.oma042,g_oma.oma043,g_oma.oma044,g_oma.oma40
       #FROM occ_file WHERE occ01=g_oma.oma03 AND occacti = 'Y'    #MOD-CA0047 mark
        FROM occ_file WHERE occ01=g_oma.oma03 AND occacti <> 'N'   #MOD-CA0047
   ELSE
      LET g_sql = "SELECT occ02,occ11,occ18,occ231,occ37",
                  #"  FROM ",l_dbs CLIPPED,"occ_file ",
                  "  FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                 #" WHERE occ01='",g_oma.oma03,"' AND occacti = 'Y'"    #MOD-CA0047 mark
                  " WHERE occ01='",g_oma.oma03,"' AND occacti <> 'N'"   #MOD-CA0047
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102               
      PREPARE sel_occ_pre8 FROM g_sql
      EXECUTE sel_occ_pre8
         INTO g_oma.oma032,g_oma.oma042,g_oma.oma043,g_oma.oma044,g_oma.oma40
   END IF
  #-MOD-AA0002-add-
   IF g_oma.oma03 = 'MISC' THEN
      LET g_oma.oma032 = g_oea.oea032
     #-MOD-AA0185-add-
      LET g_sql = "SELECT occm02,occm04 ",
                  "  FROM ",cl_get_target_table(g_plant_new,'oea_file'),",", 
                  "       ",cl_get_target_table(g_plant_new,'occm_file'), 
                  " WHERE oea01='",g_oea.oea01,"'",
                  "   AND oea<> 'X'",
                  "   AND oea01 = occm01"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE sel_occm_pre FROM g_sql
      EXECUTE sel_occm_pre INTO g_oma.oma042,g_oma.oma044
     #-MOD-AA0185-end-
   END IF
   IF g_oma.oma68 = 'MISC' THEN
      LET g_oma.oma69 = g_oea.oea032
   END IF
  #-MOD-AA0002-end-

   LET g_oma.oma05 = g_oea.oea05
   IF g_oma05 IS NOT NULL THEN LET g_oma.oma05 = g_oma05 END IF
   LET g_oma.oma04 = g_oma.oma03
   LET g_oma.oma08 = g_oea.oea08
  #SELECT ooz08 INTO g_oma.oma13 FROM ooz_file WHERE ooz00='0' #MOD-B10040 mark
  #-MOD-B10040-add-
   SELECT occ67 INTO g_oma.oma13 FROM occ_file
     WHERE occ01 = g_oma.oma03
   IF cl_null(g_oma.oma13) THEN 
      LET g_oma.oma13 = g_ooz.ooz08
   END IF
  #-MOD-B10040-emd-
   SELECT ool11 INTO g_oma.oma18 FROM ool_file WHERE ool01=g_oma.oma13
   IF g_aza.aza63 = 'Y' THEN
      SELECT ool111 INTO g_oma.oma181 FROM ool_file WHERE ool01=g_oma.oma13
   END IF
 
   LET g_oma.oma14 = g_oea.oea14
   LET g_oma.oma15 = g_oea.oea15
   LET g_oma.oma161= g_oea.oea161
   LET g_oma.oma162= g_oea.oea162
   LET g_oma.oma163= g_oea.oea163
   LET g_oma.oma21 = g_oea.oea21
   LET g_oma.oma211= g_oea.oea211
   LET g_oma.oma212= g_oea.oea212
   LET g_oma.oma213= g_oea.oea213
   LET g_oma.oma23 = g_oea.oea23

   IF cl_null(l_dbs) THEN
      SELECT gec08,gec06 INTO g_oma.oma171,g_oma.oma172 FROM gec_file
       WHERE gec01 = g_oma.oma21 AND gec011 = '2'
   ELSE
      #LET g_sql = "SELECT gec08,gec06 FROM ",l_dbs CLIPPED,"gec_file ",
      LET g_sql = "SELECT gec08,gec06 FROM ",cl_get_target_table(g_plant_new,'gec_file'), #FUN-A50102
                  " WHERE gec01 = '",g_oma.oma21,"' AND gec011 = '2' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
      PREPARE sel_gec_pre8 FROM g_sql
      EXECUTE sel_gec_pre8 INTO g_oma.oma171,g_oma.oma172
   END IF

   IF g_oma.oma08='1' THEN 
      LET exT=g_ooz.ooz17 
   ELSE 
      LET exT=g_ooz.ooz63 
   END IF

   CALL s_curr3(g_oma.oma23,g_oma.oma02,exT) RETURNING g_oma.oma24
   CALL s_curr3(g_oma.oma23,g_oma.oma09,exT) RETURNING g_oma.oma58

   # 若採用訂單匯率立帳,則匯率=訂單匯率
   IF g_oea.oea18 IS NOT NULL AND g_oea.oea18='Y' THEN
     #LET g_oma.oma24 = g_oea.oea24
     #LET g_oma.oma58 = g_oea.oea24
      LET g_oma.oma24 = g_oeaa.oeaa07    #No:FUN-A50103
      LET g_oma.oma58 = g_oeaa.oeaa07    #No:FUN-A50103
   END IF

   IF cl_null(g_oma.oma24) THEN LET g_oma.oma24=1 END IF
   IF cl_null(g_oma.oma58) THEN LET g_oma.oma58=1 END IF

   LET g_oma.oma60 = g_oma.oma24    #bug no:A060
   LET g_oma.oma25 = g_oea.oea25
   LET g_oma.oma26 = g_oea.oea26

 # #-----No:FUN-A50103-----
 ##IF NOT cl_null(g_oea.oea80) THEN    #No.FUN-680022 add                        #CHI-A50040 mark
 # IF g_oma.oma00='11' AND NOT cl_null(g_oea.oea80) THEN    #No.FUN-680022 add   #CHI-A50040
 #    LET g_oma.oma32 = g_oea.oea80    #No.FUN-680022 add
 ##ELSE                                #No.FUN-680022 add                        #CHI-A50040 mark
 ##   LET g_oma.oma32 = g_oea.oea32                                              #CHI-A50040 mark
 # END IF                              #No.FUN-680022 add

 ##-CHI-A50040-add-
 # IF g_oma.oma00='13' AND NOT cl_null(g_oea.oea81) THEN    
 #    LET g_oma.oma32 = g_oea.oea81   
 # END IF
 # IF cl_null(g_oma.oma32) THEN
 #    LET g_oma.oma32 = g_oea.oea32
 # END IF 
 # #-CHI-A50040-end-
 # LET g_oma.oma11 = g_oma.oma02
 # LET g_oma.oma12 = g_oma.oma02

 # #-CHI-A50040-add-
 # IF g_oma.oma161 > 0 THEN
 #    IF g_oma.oma00='13' AND g_oma.oma162=0 THEN
 #       IF cl_null(g_oma.oma19) THEN
 #          IF cl_null(l_dbs) THEN
 #             SELECT oma19 INTO g_oma.oma19 FROM oma_file
 #              WHERE oma16=g_oea.oea01 AND oma00='11' AND omavoid='N'
 #          ELSE
 #             LET g_sql = "SELECT oma19 FROM ",l_dbs CLIPPED,"oma_file",
 #                         " WHERE oma16='",g_oea.oea01,"' AND oma00='11' ",
 #                         "   AND omavoid='N'"
 #             PREPARE sel_oga_pre24 FROM g_sql
 #             EXECUTE sel_oga_pre24 INTO g_oma.oma19
 #          END IF
 #       END IF
 #    END IF
 #    IF NOT cl_null(g_oma.oma19) THEN   #check 訂金產生的待抵是否已沖平
 #       IF g_ooz.ooz07 = 'N' THEN
 #          SELECT COUNT(*) INTO g_cnt FROM oma_file
 #           WHERE oma01=g_oma.oma19 AND (oma56t-oma57) >0 
 #             AND omaconf='Y'  AND omavoid='N' AND oma00='23'
 #       ELSE                                                                                                                       
 #          SELECT COUNT(*) INTO g_cnt FROM oma_file                                                                                
 #           WHERE oma01=g_oma.oma19 AND oma61 >0                                                                                   
 #             AND omaconf='Y'  AND omavoid='N' AND oma00='23'                                                                      
 #       END IF                                                                                                                     
 #       IF g_cnt =0 THEN   #表待抵均已沖完
 #          LET g_oma.oma19=' '
 #       END IF
 #       SELECT SUM(oma52),SUM(oma53) INTO tot1_12,tot2_12 FROM oma_file
 #        WHERE oma19=g_oma.oma19 AND oma00='12' AND omavoid='N'
 #          AND oma16=g_oma.oma16
 #       SELECT SUM(oma54t),SUM(oma56t) INTO tot1_23,tot2_23 FROM oma_file
 #        WHERE oma01=g_oma.oma19 AND oma00='23' AND omavoid='N'
 #       IF cl_null(tot1_23) THEN LET tot1_23=0 END IF
 #       IF cl_null(tot2_23) THEN LET tot1_23=0 END IF
 #       IF cl_null(tot1_12) THEN LET tot1_12=0 END IF
 #       IF cl_null(tot2_12) THEN LET tot1_12=0 END IF
 #       IF tot1_12 - tot1_23 =0 OR tot2_12 - tot2_23=0 THEN
 #          LET g_oma.oma19=' '
 #       END IF
 #    END IF
 # END IF
 ##-CHI-A50040-add-
   LET g_oma.oma32 = g_oeaa.oeaa04
   LET g_oma.oma11 = g_oeaa.oeaa05
   LET g_oma.oma12 = g_oeaa.oeaa06
   IF g_oea.oea261 > 0 THEN
      IF g_oma.oma00='13' AND g_oea.oea262=0 THEN
         IF cl_null(g_oma.oma19) THEN
            LET g_oma.oma19 = g_oea.oea01
         END IF
      END IF
      IF NOT cl_null(g_oma.oma19) THEN   #check 訂金產生的待抵是否已沖平
         IF g_ooz.ooz07 = 'N' THEN
            SELECT COUNT(*) INTO g_cnt FROM oma_file
             WHERE oma16=g_oma.oma19 AND (oma56t-oma57) >0 
               AND omaconf='Y'  AND omavoid='N' AND oma00='23'
         ELSE                                                                                                                       
            SELECT COUNT(*) INTO g_cnt FROM oma_file                                                                                
             WHERE oma16=g_oma.oma19 AND oma61 >0                                                                                   
               AND omaconf='Y'  AND omavoid='N' AND oma00='23'                                                                      
         END IF                                                                                                                     
         IF g_cnt =0 THEN   #表待抵均已沖完
            LET g_oma.oma19=' '
         END IF
         SELECT SUM(oma52),SUM(oma53) INTO tot1_12,tot2_12 FROM oma_file
          #WHERE oma19=g_oma.oma19 AND oma00='12' AND omavoid='N'   #FUN-B10058
          WHERE oma19=g_oma.oma19 AND (oma00='12' OR oma00 = '19') AND omavoid='N'  #FUN-B10058
            AND oma16=g_oma.oma16
         SELECT SUM(oma54t),SUM(oma56t) INTO tot1_23,tot2_23 FROM oma_file
          WHERE oma16=g_oma.oma19 AND oma00='23' AND omavoid='N'
         IF cl_null(tot1_23) THEN LET tot1_23=0 END IF
         IF cl_null(tot2_23) THEN LET tot1_23=0 END IF
         IF cl_null(tot1_12) THEN LET tot1_12=0 END IF
         IF cl_null(tot2_12) THEN LET tot1_12=0 END IF
         IF tot1_12 - tot1_23 =0 OR tot2_12 - tot2_23=0 THEN
            LET g_oma.oma19=' '
         END IF
      END IF
   END IF
 # #-----No:FUN-A50103 END-----

   LET g_oma.oma63 = g_oea.oea46       #MOD-910143 add
   LET g_oma.oma65 = '1'               #FUN-5A0124

   IF g_source IS NULL OR cl_null(g_source) THEN                                                                                                  
      LET g_oma.oma66=g_plant                                                                                                       
   ELSE                                                                                                                             
      LET g_oma.oma66 = g_source  #FUN-630043
   END IF   #MOD-8C0100 add 

   IF g_aaz.aaz90='Y' THEN
     #FUN-A60056--mark--str--
     #IF cl_null(l_dbs) THEN
     #   LET g_sql = "SELECT oeb930 FROM oeb_file",
     #               " WHERE oeb01='",g_oea.oea01,"'",
     #               "   AND oeb930 IS NOT NULL",
     #               " ORDER BY oeb03"
     #ELSE
     #FUN-A60056--mark--end
         #LET g_sql = "SELECT oeb930 FROM ",l_dbs CLIPPED,"oeb_file",
         LET g_sql = "SELECT oeb930 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                     " WHERE oeb01='",g_oea.oea01,"'",
                     "   AND oeb930 IS NOT NULL",
                     " ORDER BY oeb03"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
     #END IF   #FUN-A60056
      PREPARE sel_oeb_pre9 FROM g_sql
      DECLARE s_g_ar_11_oma_c CURSOR FOR sel_oeb_pre9
      OPEN s_g_ar_11_oma_c
      FETCH s_g_ar_11_oma_c INTO g_oma.oma930
      CLOSE s_g_ar_11_oma_c
   END IF

  ##-----No:FUN-A50103 Mark-----
  #CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,g_oea.oea02,g_plant2) #FUN-980020
  #                  RETURNING g_oma.oma11,g_oma.oma12
  ##-----No:FUN-A50103 Mark END-----

   IF cl_null(g_oma.oma51) THEN
      LET g_oma.oma51 = 0
   END IF

   IF cl_null(g_oma.oma51f) THEN
      LET g_oma.oma51f = 0
   END IF

   LET g_t1 = g_oma.oma01[1,g_doc_len] 

   SELECT ooyapr INTO g_oma.omamksg FROM ooy_file 
     WHERE ooyslip = g_t1

   LET g_oma.oma64 = '0'        #No.TQC-7B0144 

   LET g_oma.omalegal = g_legal #FUN-980011 add
   LET g_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oma.omaorig = g_grup      #No.FUN-980030 10/01/04

#FUN-AC0027 --begin--
   IF cl_null(g_oma.oma74) THEN
      LET g_oma.oma74 = '1'
   END IF 
   IF cl_null(g_oma.oma73) THEN
      LET g_oma.oma73 = 0 
   END IF 
   IF cl_null(g_oma.oma73f) THEN
      LET g_oma.oma73f = 0
   END IF
#FUN-AC0027 --end--
   INSERT INTO oma_file VALUES(g_oma.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
      LET g_msg='ins oma:(',g_oma.oma01,')'
      IF g_bgerr THEN
         CALL s_errmsg('','',g_msg,STATUS,1)
      ELSE
         CALL cl_err3("ins","oma_file",g_oma.oma01,"",STATUS,"",g_msg,1)
      END IF
      LET g_success='N'
      RETURN 
   END IF

   IF g_begin IS NULL THEN LET g_begin = g_oma.oma01 END IF

END FUNCTION
 
FUNCTION s_g_ar_11_omb()
   DEFINE l_oba11   LIKE oba_file.oba11   #FUN-690012
   DEFINE l_azf14   LIKE azf_file.azf14   #FUN-810045
   DEFINE l_azf20   LIKE azf_file.azf20   #FUN-BA0109
   DEFINE l_azf201  LIKE azf_file.azf201  #FUN-BA0109
   LET g_omb.omb33 = NULL            #MOD-CA0083
   LET g_omb.omb331 = NULL           #MOD-CA0083
   LET g_omb.omb01 = g_oma.oma01
   LET g_omb.omb31 = g_oeb.oeb01
   LET g_omb.omb32 = g_oeb.oeb03
   LET g_omb.omb04 = g_oeb.oeb04
   LET g_omb.omb05 = g_oeb.oeb916   #FUN-560070
   LET g_omb.omb06 = g_oeb.oeb06
   LET g_omb.omb40 = g_oeb.oeb1001  #No.FUN-660073
   LET g_omb.omb12 = g_oeb.oeb917   #FUN-560070
   IF cl_null(g_oeb.oeb1006) THEN
      LET g_omb.omb13 = g_oeb.oeb13   
   ELSE
      LET g_omb.omb13 = g_oeb.oeb13*(g_oeb.oeb1006/100)
   END IF
   LET g_omb.omb38 = '1'   #No.FUN-670026 #訂單  
   LET g_omb.omb39 = 'N'   #No.FUN-670026 
 
   CALL cl_digcut(g_omb.omb13,t_azi03) RETURNING g_omb.omb13   #MOD-760078
###-FUN-B40032- MARK - BEGIN -----------------------------------------------------------
#  IF g_oma.oma213 = 'N'  #含稅否
#     THEN IF g_omb.omb12 != 0 THEN     #數量
#             LET g_omb.omb14 =g_omb.omb12*g_omb.omb13  #數量*原幣單價
#          END IF
#          CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
#            LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)  #FUN-960141  #FUN-960140 取消960141 mark
#          CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t   #MOD-760078
#     ELSE IF g_omb.omb12 != 0 THEN
#            LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
#          END IF
#          CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t   #MOD-760078
#            LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100) #FUN-960141
#          CALL cl_digcut(g_omb.omb14,t_azi04)RETURNING g_omb.omb14   #MOD-760078
#  END IF
###-FUN-B40032- MARK -  END  -----------------------------------------------------------
###-FUN-B40032- ADD  - BEGIN -----------------------------------------------------------
   #IF g_oma.oma70 = '3' THEN                  #FUN-C10055 MARK
   IF g_mTax = TRUE THEN                     #FUN-C10055 add          
      LET g_omb.omb14 = g_oeb.oeb14
      LET g_omb.omb14t = g_oeb.oeb14t
   ELSE
      IF g_oma.oma213 = 'N' THEN #含稅否
         IF g_omb.omb12 != 0 THEN     #數量
            LET g_omb.omb14 =g_omb.omb12*g_omb.omb13  #數量*原幣單價
         END IF
         CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
         LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)  #FUN-960141  #FUN-960140 取消960141 mark
         CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t   #MOD-760078
      ELSE 
         IF g_omb.omb12 != 0 THEN
            LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
         END IF
         CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t   #MOD-760078
         LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100) #FUN-960141
         CALL cl_digcut(g_omb.omb14,t_azi04)RETURNING g_omb.omb14   #MOD-760078
      END IF
   END IF
###-FUN-B40032- ADD  -  END  -----------------------------------------------------------
   LET g_omb.omb15 =g_omb.omb13 *g_oma.oma24
   LET g_omb.omb16 =g_omb.omb14 *g_oma.oma24
   LET g_omb.omb16t=g_omb.omb14t*g_oma.oma24
   LET g_omb.omb17 =g_omb.omb13 *g_oma.oma58
   LET g_omb.omb18 =g_omb.omb14 *g_oma.oma58
   LET g_omb.omb18t=g_omb.omb14t*g_oma.oma58
   CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15   #MOD-760078
   CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16   #MOD-760078
   CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t  #MOD-760078
   CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17   #MOD-760078
   CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18   #MOD-760078
   CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t  #MOD-760078
 
   LET g_omb.omb36 = g_oma.oma24                    #A060
   LET g_omb.omb37 = g_omb.omb16t - g_omb.omb35     #A060
   LET g_omb.omb34 = 0 LET g_omb.omb35 = 0 
   LET g_omb.omb00 = g_oma.oma00   #MOD-6A0102
   MESSAGE g_omb.omb03,' ',g_omb.omb04,' ',g_omb.omb12
   LET g_omb.omb930= g_oeb.oeb930 #FUN-680001
  
   
   #IF g_oma.oma00 ='11' THEN   #MOD-850063 mod '12'->'11'                        #CHI-A50040 mark
   #IF g_oma.oma00 ='11' OR g_oma.oma00 ='13' THEN   #MOD-850063 mod '12'->'11'   #CHI-A50040   #yinhy130627
      LET l_oba11 = NULL
      IF cl_null(l_dbs) THEN
          SELECT oba11 INTO l_oba11
            FROM oba_file,ima_file
           WHERE oba01 = ima_file.ima131
             AND ima01 = g_omb.omb04
      ELSE
         LET g_sql = " SELECT oba11 ",
                     #"   FROM ",l_dbs CLIPPED,"oba_file,",l_dbs CLIPPED,"ima_file",
                     "   FROM ",cl_get_target_table(g_plant_new,'oba_file'),",", #FUN-A50102
                                cl_get_target_table(g_plant_new,'ima_file'),     #FUN-A50102
                     "  WHERE oba01 = ima_file.ima131",
                     "    AND ima01 = '",g_omb.omb04,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102                
         PREPARE sel_oba_pre10 FROM g_sql
         EXECUTE sel_oba_pre10 INTO l_oba11
      END IF
      IF SQLCA.sqlcode THEN
         LET l_oba11 = NULL
      IF g_bgerr THEN
         CALL s_errmsg('','',"sel oba",STATUS,0)
      ELSE
         CALL cl_err3("sel","oba_file",g_omb.omb04,"",STATUS,"","sel oba",0)
      END IF
      END IF
      LET g_omb.omb33 = l_oba11
   #END IF  #yinhy130627 mark
  
   LET g_omb.omb41 = g_oeb.oeb41
   LET g_omb.omb42 = g_oeb.oeb42
   IF NOT cl_null(g_omb.omb40) THEN
      IF cl_null(l_dbs) THEN
         #SELECT azf14 INTO l_azf14                   #FUN-BA0109
         SELECT azf20,azf201 INTO l_azf20,l_azf201    #FUN-BA0109
           FROM azf_file
          WHERE azf01=g_omb.omb40 AND azf02='2' AND azfacti='Y'
      ELSE
         #LET g_sql = "SELECT azf14 ",    
         LET g_sql = "SELECT azf20,azf201 ",          #FUN-BA0109
                     #"  FROM ",l_dbs CLIPPED,"azf_file",
                     "  FROM ",cl_get_target_table(g_plant_new,'azf_file'), #FUN-A50102
                     " WHERE azf01='",g_omb.omb40,"' AND azf02='2' AND azfacti='Y'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102               
         PREPARE sel_azf_pre11 FROM g_sql
         #EXECUTE sel_azf_pre11 INTO l_azf14           #FUN-BA0109
         EXECUTE sel_azf_pre11 INTO l_azf20,l_azf201   #FUN-BA0109
      END IF
      #IF NOT cl_null(l_azf14) THEN LET g_omb.omb33=l_azf14 END IF    #FUN-BA0109
      IF NOT cl_null(l_azf20) THEN LET g_omb.omb33=l_azf20 END IF     #FUN-BA0109
   END IF
 
   IF g_aza.aza63='Y' AND cl_null(g_omb.omb331) THEN
      #LET g_omb.omb331 = g_omb.omb33                                    #FUN-BA0109
      IF NOT cl_null(l_azf201) THEN LET g_omb.omb331=l_azf201 END IF     #FUN-BA0109
   END IF
 
   LET g_omb.omblegal = g_legal #FUN-980011 add
   LET g_omb.omb44 = g_oeb.oebplant    #FUN-9A0093 
   LET g_omb.omb48 = 0   #FUN-D10101 add
   INSERT INTO omb_file VALUES(g_omb.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
      IF g_bgerr THEN
         LET g_showmsg=g_omb.omb01,"/",g_omb.omb03
         CALL s_errmsg('omb01,omb03',g_showmsg,'ins omb',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.sqlcode,"","ins omb",1)
      END IF
      LET g_success='N'
      RETURN 
   END IF
###-FUN-B40032- ADD - BEGIN -------------------------------------------
###-將訂單單身稅別明細複製到應收單身稅別明細-###
   #IF g_oma.oma70 = '3' THEN          #FUN-C10055 mark
   IF g_mTax = TRUE THEN               #FUN-C10055 add
      LET g_sql = 
         "INSERT INTO oml_file (oml01,oml02,oml03,oml04,oml05,oml06,oml07,  ",
         "                      oml08,oml08t,oml09,omldate,omlgrup,         ",
         "                      omllegal,omlmodu,omlorig,omloriu,omluser)   ",
         "SELECT '",g_oma.oma01,"'",",oeg02,oeg03,oeg04,oeg05,oeg06,        ",
         "            oeg07,oeg08,oeg08t,oeg09,'','",g_grup,"','",g_legal,"'",
         "                        ,'','",g_grup,"','",g_user,"','",g_user,"'",
        #"  FROM oeg_file ",
         "  FROM ",cl_get_target_table(g_plant_new,'oeg_file'), #By shi
         " WHERE oeg01 = '",g_oeb.oeb01,"'",
         "   AND oeg02 = '",g_oeb.oeb03,"'" #By shi
      PREPARE ins_oml_pre1 FROM g_sql
      EXECUTE ins_oml_pre1
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            LET g_showmsg=g_oma.oma01
            CALL s_errmsg('oml01',g_showmsg,'ins oml',SQLCA.SQLCODE,1)
         ELSE   
            CALL cl_err3("ins","oml_file",g_oma.oma01,"",SQLCA.sqlcode,"","ins oml",1)
         END IF
         LET g_success='N'
         RETURN 
      END IF
   END IF
###-FUN-B40032- ADD -  END  -------------------------------------------

END FUNCTION

#----------------------------(產生出貨應收)----------------------------
FUNCTION s_g_ar_12(p_no,p_oma01)
   DEFINE p_no            LIKE oga_file.oga01     #單號 #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
   DEFINE p_oma01         LIKE oma_file.oma01     #單號 #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
   DEFINE l_oma01         LIKE oma_file.oma01     #單號 #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
   DEFINE l_ogb60         LIKE ogb_file.ogb60
   DEFINE l_slip          LIKE ooy_file.ooyslip
   DEFINE l_flag          LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(01)
   DEFINE l_qty           LIKE ogb_file.ogb12
   DEFINE l_ogb1013       LIKE ogb_file.ogb1013   #No.FUN-670026
   DEFINE li_result       LIKE type_file.num5     #No.FUN-550071 #No.FUN-680123 SMALLINT
   DEFINE l_oas05         LIKE oas_file.oas05     #FUN-8C0078
   DEFINE l_cnt           LIKE type_file.num5     #FUN-8C0078
   DEFINE l_oea32         LIKE oea_file.oea32     #FUN-8C0078
   DEFINE l_ogb_cnt       LIKE type_file.num5     #FUN-8C0078
   DEFINE l_n             LIKE type_file.num5 
   DEFINE l_oeaa08        LIKE oeaa_file.oeaa08   #CHI-B90025 add
   DEFINE l_oea01         LIKE oea_file.oea01     #CHI-B90025 add 
   LET ls_n = 0
   #FUN-C60036-add--str
   LET g_sql = " SELECT COUNT(*) FROM omf_file ",
               "  WHERE omf10 = '9' ",
               "    AND omf00 = '",g_omf00,"'"
   PREPARE omf10_per FROM g_sql
   EXECUTE omf10_per INTO ls_n
   LET ls_n2 = 0
   LET g_sql = " SELECT COUNT(*) FROM omf_file ",
               "  WHERE omf10! = '9' ",
               "    AND omf00 = '",g_omf00,"'"
   PREPARE omf10_per2 FROM g_sql
   EXECUTE omf10_per2 INTO ls_n2
   #FUN-C60036 add--end
   
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=p_no
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oga_file WHERE oga01='",p_no,"'"
      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                  " WHERE oga01='",p_no,"'"
      
                                    
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102  
      PREPARE sel_oga_pre12 FROM g_sql
      EXECUTE sel_oga_pre12 INTO g_oga.*
  #END IF   #FUN-A60056

   LET l_oas05 = 0   #FUN-8C0078 add

  #IF STATUS AND g_oaz.oaz92 = 'N' THEN #FUN-CB0057 mark
   IF STATUS AND NOT (g_aza.aza26 = '2' AND g_oaz92 = 'Y') THEN #FUN-CB0057 add 
      IF g_bgerr THEN
         CALL s_errmsg('oga01',p_no,'s_g_ar_12:sel oga',STATUS,1)
      ELSE
         CALL cl_err3("sel","oga_file",p_no,"",STATUS,"","s_g_ar_12:sel oga",1)
      END IF
      LET g_success='N'
      RETURN
   END IF

  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   SELECT COUNT(*) INTO l_n FROM rxx_file
  #    WHERE rxx00 = '02' AND rxx01 = p_no
  #      AND rxxplant = g_oga.ogaplant
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"rxx_file",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'rxx_file'), #FUN-A50102
                  " WHERE rxx00 = '02' AND rxx01 = '",p_no,"'",
                  "   AND rxxplant = '",g_oga.ogaplant,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
      PREPARE sel_rxx_pre13 FROM g_sql
      EXECUTE sel_rxx_pre13 INTO l_n
  #END IF   #FUN-A60056



   IF g_oga.oga00='1' THEN      # 全部項次已開發票, 則 return,oga00='1'一般出貨
    #-CHI-A50040-mark- 
    #IF g_oma.oma00='13' THEN 
    #   SELECT COUNT(*) INTO g_cnt FROM oma_file,omb_file 
    #    WHERE oma00='13' AND oma01=omb01 
    #       AND omb31=g_oga.oga01 AND omavoid='N'     #No.MOD-520011
    #   IF g_cnt >0 THEN
    #      IF g_bgerr THEN
    #         CALL s_errmsg('','',g_oga.oga01,'axr-261',1)
    #      ELSE
    #         CALL cl_err(g_oga.oga01,'axr-261',1)
    #      END IF
    #      LET g_success='N' RETURN 
    #   END IF
    #ELSE
    #-CHI-A50040-end- 
       SELECT SUM(omb12) INTO l_ogb60 FROM oma_file,omb_file
        WHERE omb31 = g_oga.oga01
          #AND omb01 = oma01 AND omavoid = 'N' AND oma00='12'  #FUN-B10058 
          AND omb01 = oma01 AND omavoid = 'N' AND (oma00='12' OR oma00 = '19')  #FUN-B10058  
          AND omb38 = '2'  AND omb39! = 'N'      #No.FUN-670026  
 
       IF l_ogb60 IS NULL THEN LET l_ogb60 = 0 END IF
 
      #FUN-A60056--mark--str--
      #IF cl_null(l_dbs) THEN
      #   SELECT SUM(ogb917) INTO un_gui_qty FROM ogb_file
      #    WHERE ogb01=p_no
      #      AND (ogb1005 = '1' OR ogb1005 IS NULL)
      #      AND (ogb1012 = 'N' OR ogb1012 IS NULL)
      #ELSE
      #FUN-A60056--mark--end
          #LET g_sql = "SELECT SUM(ogb917) FROM ",l_dbs CLIPPED,"ogb_file ",
          LET g_sql = "SELECT SUM(ogb917) FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                      " WHERE ogb01='",p_no,"'",
                      "   AND (ogb1005 = '1' OR ogb1005 IS NULL)",
                      "   AND (ogb1012 = 'N' OR ogb1012 IS NULL)"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
          PREPARE sel_ogb_pre14 FROM g_sql
          EXECUTE sel_ogb_pre14 INTO un_gui_qty
      #END IF   #FUN-A60056
       SELECT SUM(omb14) INTO l_ogb1013 FROM oma_file,omb_file 
        WHERE omb31 = g_oga.oga01
          #AND omb01 = oma01 AND omavoid = 'N' AND oma00 = '12' AND omb38 = '4'  #FUN-B10058
          AND omb01 = oma01 AND omavoid = 'N' AND (oma00 = '12' OR oma00 = '19') AND omb38 = '4' #FUN-B10058

      #FUN-A60056--mark--str--
      #IF cl_null(l_dbs) THEN
      #   SELECT SUM(ogb14) INTO un_gui_act FROM ogb_file 
      #    WHERE ogb01 = p_no AND ogb1005 = '2'
      #ELSE
      #FUN-A60056--mark--end
          #LET g_sql = "SELECT SUM(ogb14) FROM ",l_dbs CLIPPED,"ogb_file",
          LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102 #
                      " WHERE ogb01 = '",p_no,"' AND ogb1005 = '2'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102	
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
          PREPARE sel_ogb_pre15 FROM g_sql
          EXECUTE sel_ogb_pre15 INTO un_gui_act
      #END IF    #FUN-A60056
 
       LET un_gui_act=un_gui_act-l_ogb1013
 
       IF un_gui_qty IS NULL THEN LET un_gui_qty = 0 END IF
 
       LET un_gui_qty = un_gui_qty - l_ogb60
 
    #END IF   #CHI-A50040 mark
   END IF
 
       LET l_slip=s_get_doc_no(p_oma01)  #MOD-9A0086                                                                                
       SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = l_slip  #MOD-9A0086    
       CALL s_g_ar_12_oma(p_oma01)
#No.FUN-AB0034 --begin
       IF cl_null(l_dbs) THEN
          SELECT occ73 INTO g_occ73 FROM occ_file
           WHERE occ01 = g_oma.oma68
       ELSE
          #LET g_sql = "SELECT occ73 FROM ",l_dbs CLIPPED,"occ_file",
          LET g_sql = "SELECT occ73 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                      " WHERE occ01 = '",g_oma.oma68,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
          PREPARE sel_occ_pre50 FROM g_sql
          EXECUTE sel_occ_pre50 INTO g_occ73
       END IF
       
       IF cl_null(g_occ73) THEN LET g_occ73 = 'N' END IF      #MOD-9C0288
       IF l_n >0 AND g_occ73 ='Y' THEN LET g_check='Y' ELSE LET g_check = 'N' END IF 
#No.FUN-AB0034 --end
      #FUN-A60056--mark--str--
      #IF cl_null(l_dbs) THEN
      #   LET g_sql = "SELECT * FROM ogb_file WHERE ogb01='",p_no,"'"
      #ELSE
      #FUN-A60056--mark--end
          #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"ogb_file WHERE ogb01='",p_no,"'"
         #LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102#FUN-C60036 mark
          LET g_sql = "SELECT ogb03 FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
                      " WHERE ogb01='",p_no,"'"
          #FUN-C60036--add--str
          IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
             LET g_sql =  " SELECT omf21 FROM omf_file ",
                          " WHERE omf01 = '",g_omf01,"'",
                          "   AND omf00 = '",g_omf00,"'",  #minpp add
                          "   AND omf02 = '",g_omf02,"'"
                         #"   AND omf09 = '",l_azp01,"'",#FUN-CB0057 mark
                         #"   AND omf11 = '",p_no,"'"#FUN-CB0057 mark
         END IF
         #FUN-C60036--add--end
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102  
      #END IF   #FUN-A60056
       PREPARE sel_ogb_pre16 FROM g_sql
       DECLARE s_g_ar_12_c CURSOR FOR sel_ogb_pre16
       LET g_omb.omb03 = 0
       LET g_oma.oma52 = 0    #No.FUN-960140
       LET g_oma.oma53 = 0    #No.FUN-960140
      #FOREACH s_g_ar_12_c INTO g_ogb.*#FUN-C60036
       FOREACH s_g_ar_12_c INTO g_ogb03 #FUN-C60036
          LET g_ogb.ogb03 = g_ogb03
         IF STATUS THEN 
            IF g_bgerr THEN
               CALL s_errmsg('','','s_g_ar_12:foreach ogb',STATUS,1)
            ELSE
               CALL cl_err('s_g_ar_12:foreach ogb',STATUS,1)
            END IF
            LET g_success='N' RETURN 
         END IF
         #FUN-C60036--add--str
            IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' AND NOT cl_null(p_no) THEN 
              #SELECT omf12 INTO g_ogb.ogb03 FROM omf_file  #FUN-CB0057 mark
               SELECT omf11,omf12 INTO p_no,g_ogb.ogb03 FROM omf_file #FUN-CB0057 add
                WHERE omf00 = g_omf00
                  AND omf21 = g_ogb03
            #FUN-C90078-add--str
            ELSE
               LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
                           " WHERE ogb01='",p_no,"'",
                           "   AND ogb03 = '",g_ogb03,"'"
           #FUN-C90078--add--end
            END IF 
            LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
                        " WHERE ogb01='",p_no,"'",
                        "   AND ogb03 = '",g_ogb.ogb03,"'" 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
            PREPARE sel_ogb_ogb03 FROM g_sql
            EXECUTE sel_ogb_ogb03 INTO g_ogb.*
        IF g_oaz92 = 'Y' AND g_aza.aza26 = '2'  THEN
           IF cl_null(p_no) THEN 
           INITIALIZE g_ogb.* TO NULL

        SELECT omf11,omf12,omf13,omf916,omf14,' ',omf917,0,0,omf28,omf29,omf29t,' ',' ',' ',omf09
          INTO g_ogb.ogb01,g_ogb.ogb03,g_ogb.ogb04,g_ogb.ogb916,g_ogb.ogb06,g_ogb.ogb1001,g_ogb.ogb917,
               g_ogb.ogb47,g_ogb.ogb12,g_ogb.ogb13,g_ogb.ogb14,g_ogb.ogb14t,g_ogb.ogb41,g_ogb.ogb42,g_ogb.ogb930,
               g_ogb.ogbplant
          FROM omf_file
         WHERE omf00 = g_omf00
           AND omf21 = g_ogb03
        LET g_ogb.ogb1005 = '0'
        ELSE
        SELECT omf28,omf917,omf29,omf29t INTO 
            g_ogb.ogb13,g_ogb.ogb917,g_ogb.ogb14,g_ogb.ogb14t FROM omf_file
        WHERE omf08 = 'Y'  
          AND omf04 IS NULL 
          AND omf09 = l_azp01
          AND omf01 = g_omf01
          AND omf00 = g_omf00 #minpp  add
          AND omf02 = g_omf02
          AND omf12 = g_ogb.ogb03
          AND omf11 = g_oga.oga01
          AND omf10 = '1' 
        END IF 
        END IF 
        #FUN-C60036--add--end
         IF g_enter_account = "N" AND g_ogb.ogb13 = 0 AND g_azw.azw04 <> '2' THEN    #TQC-C80083  add g_azw.azw04 <> '2'
            CONTINUE FOREACH
         END IF 
 
         LET g_omb.omb03 = g_omb.omb03 + 1
         IF g_check = 'N' AND ((g_oma.oma08 = '1' AND g_omb.omb03 > g_ooz.ooz121) OR
            (g_oma.oma08 = '2' AND g_omb.omb03 > g_ooz.ooz122)) THEN
           #-------------------------------No.CHI-B90025----------------------------------start
            IF g_oma.oma00='11' THEN
               SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
                WHERE oeaa01 = g_oma.oma16
                  AND oeaa02 = '1'
                  AND oeaa03 = g_oma.oma165
                  AND oeaa01 = oea01
            END IF
            IF g_oma.oma00='13' THEN
               SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
                WHERE oeaa01 = g_oma.oma16
                  AND oeaa02 = '2'
                  AND oeaa03 = g_oma.oma165
                  AND oeaa01 = oea01
            END IF
            CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
            CALL s_g_ar_omc()
           #CALL s_g_ar_bu(l_oas05)  #FUN-8C0078 mod
          #-------------------------------No.CHI-B90025----------------------------------end
            LET l_oma01 = s_get_doc_no(p_oma01)
            CALL  s_auto_assign_no("axr",l_oma01,g_oma.oma02,g_oma.oma00,"oma_file","oma01",
                      "","","")
                      RETURNING li_result,l_oma01
            IF (NOT li_result) THEN
               IF g_bgerr THEN
                  CALL s_errmsg('','',l_oma01,'mfg-059',1)
               ELSE
                  CALL cl_err(l_oma01,'mfg-059',1)
               END IF
               LET g_success = 'N'
            END IF
            CALL s_g_ar_12_oma(l_oma01)
            LET g_omb.omb03 = 1
         END IF
         LET l_qty = 0
 
         IF g_ogb.ogb1005 != '2' OR cl_null(g_ogb.ogb1005) THEN #MOD-6C0100                          #No.FUN-670026 對于出貨和返利分別處理
            CALL s_g_ar_12_omb(l_qty) RETURNING l_flag,l_qty   #No.FUN-670026  
            WHILE TRUE           #MOD-540136
               IF g_check = 'N' AND g_aza.aza26='2' AND g_ooy.ooy10 = 'Y' AND l_flag = 'Y' AND l_qty > 0 THEN   #MOD-630073 #FUN-960140
                 #-------------------------------No.CHI-B90025----------------------------------start
                  IF g_oma.oma00='11' THEN
                     SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
                      WHERE oeaa01 = g_oma.oma16
                        AND oeaa02 = '1'
                        AND oeaa03 = g_oma.oma165
                        AND oeaa01 = oea01
                  END IF
                  IF g_oma.oma00='13' THEN
                     SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
                      WHERE oeaa01 = g_oma.oma16
                        AND oeaa02 = '2'
                        AND oeaa03 = g_oma.oma165
                        AND oeaa01 = oea01
                  END IF
                  CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
                  CALL s_g_ar_omc()
                 #CALL s_g_ar_bu(l_oas05)  #FUN-8C0078 mod
                 #-------------------------------No.CHI-B90025----------------------------------end
                   LET l_oma01 = s_get_doc_no(p_oma01)
                   CALL  s_auto_assign_no("axr",l_oma01,g_oma.oma02,g_oma.oma00,"oma_file","oma01", "","","")
                       RETURNING li_result,l_oma01
                   IF (NOT li_result) THEN
                      IF g_bgerr THEN
                         CALL s_errmsg('','',l_oma01,'mfg-059',1)
                      ELSE
                         CALL cl_err(l_oma01,'mfg-059',1)
                      END IF
                      LET g_success = 'N'
                  END IF
                  CALL s_g_ar_12_oma(l_oma01)
                  LET g_omb.omb03 = 1
                  CALL s_g_ar_12_omb(l_qty) RETURNING l_flag,l_qty    
               ELSE           #MOD-540136
                  EXIT WHILE  #MOD-540136
               END IF
            END WHILE    #MOD-540136
         ELSE  
            CALL s_g_ar_12_omb_1() 
         END IF         #No.FUN-670026
         IF g_success = 'N' THEN RETURN END IF
      END FOREACH 
 
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   LET g_sql = "SELECT * FROM ofb_file WHERE ofb01=g_oga.oga27 AND ofb31 IS NULL"
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"ofb_file ",
      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'ofb_file'), #FUN-A50102
                  " WHERE ofb01='",g_oga.oga27,"' AND ofb31 IS NULL"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
  #END IF    #FUN-A60056
   PREPARE sel_ofb_pre17 FROM g_sql
   DECLARE s_g_ar_12_c2 CURSOR FOR sel_ofb_pre17
   FOREACH s_g_ar_12_c2 INTO g_ofb.*
      IF STATUS THEN 
         IF g_bgerr THEN
            CALL s_errmsg('','','s_g_ar_12:foreach ofb',STATUS,1)
         ELSE
            CALL cl_err('s_g_ar_12:foreach ofb',STATUS,1)
         END IF
         LET g_success='N'
         RETURN
      END IF
      LET g_omb.omb03 = g_omb.omb03 + 1
      CALL s_g_ar_122_omb()
      IF g_success = 'N' THEN RETURN END IF
   END FOREACH
  #-------------------------------No.CHI-B90025----------------------------------start
   IF g_oma.oma00='11' THEN
      SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
       WHERE oeaa01 = g_oma.oma16
         AND oeaa02 = '1'
         AND oeaa03 = g_oma.oma165
         AND oeaa01 = oea01
   END IF
   IF g_oma.oma00='13' THEN
      SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
       WHERE oeaa01 = g_oma.oma16
         AND oeaa02 = '2'
         AND oeaa03 = g_oma.oma165
         AND oeaa01 = oea01
   END IF
   CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
   CALL s_g_ar_omc()
  #CALL s_g_ar_bu(l_oas05)  #FUN-8C0078 mod
  #-------------------------------No.CHI-B90025----------------------------------end
   IF g_oaz92 != 'Y' AND g_aza.aza26 != '2' THEN #FUN-C60036 add
      CALL s_up_omb(g_oma.oma01)
   END IF #FUN-C60036 add
   IF g_check = 'Y' THEN
   #  CALL s_ins_w(g_oma.oma00,g_oma.oma16,g_oma.oma01,'0',l_dbs) #No.FUN-9C0014 #No.FUN-A10104
      CALL s_ins_w(g_oma.oma00,g_oma.oma16,g_oma.oma01,'0',l_azp01) #No.FUN-A10104
           RETURNING g_success
   END IF
END FUNCTION
 
FUNCTION s_g_ar_12_oma(p_oma01)
  DEFINE p_oma01   LIKE oma_file.oma01,    #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
         l_oea18   LIKE oeA_file.oea18,
         l_oea24   LIKE oeA_file.oea24,
         l_oea02   LIKE oea_file.oea02,    #No.FUN-680022 add
         l_occ06   LIKE occ_file.occ06,
         l_occ07   LIKE occ_file.occ07,
         tot1_12   LIKE oma_file.oma52,
         tot2_12   LIKE oma_file.oma53,
         tot1_23   LIKE oma_file.oma54t,
         tot2_23   LIKE oma_file.oma56t 
  DEFINE g_t1      LIKE ooy_file.ooyslip    #TQC-7B0097
  DEFINE l_cnt     LIKE type_file.num10     #FUN-C10055 add
  DEFINE l_omf07   LIKE omf_file.omf07 #FUN-C60036 add
  DEFINE l_oma24   LIKE oma_file.oma24 #FUN-C60036 add 
   CALL s_g_ar_oma_default()
   #FUN-C60036--add-str
   IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
   LET l_omf07 = g_oga.oga23
  #SELECT DISTINCT omf03,omf01,omf02,omf05,omf06,omf07,omf22 #FUN-D50008 mark
   SELECT DISTINCT omf31,omf01,omf02,omf05,omf06,omf07,omf22 #FUN-D50008 add
     INTO g_oma.oma09,g_oma.oma10,g_oma.oma75,g_oga.oga03,g_oga.oga21,g_oga.oga23,g_oma.oma24
     FROM omf_file
    WHERE omf01 =g_omf01 AND omf02 = g_omf02
      AND omf00 = g_omf00                         #minpp  add
     #AND omf08 = 'Y' AND omf10 = '1'
     #AND omf04 IS NULL
     #AND omf09 = l_azp01
   SELECT gec04,gec05 INTO g_oga.oga211,g_oga.oga212 FROM gec_file 
    WHERE gec01 = g_oga.oga21 AND gec011= '2'
   IF cl_null(g_oga.oga23) THEN LET g_oga.oga23 = l_omf07 END IF 
   END IF
   #FUN-C60036--add--end
   IF NOT cl_null(p_oma01) THEN
      LET g_oma.oma01 = p_oma01
     #FUN-A60056--mark--str--
     #IF cl_null(l_dbs) THEN
     #   SELECT oga27 INTO g_oma.oma67 FROM oga_file
     #    WHERE oga01=g_oma.oma16
     #ELSE
     #FUN-A60056--mark--end
         #LET g_sql = "SELECT oga27 FROM ",l_dbs CLIPPED,"oga_file",
         LET g_sql = "SELECT oga27 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                     " WHERE oga01='",g_oma.oma16,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
         PREPARE sel_ogb_pre18 FROM g_sql
         EXECUTE sel_ogb_pre18 INTO g_oma.oma67
     #END IF   #FUN-A60056
   ELSE
     #FUN-A60056--mark--str--
     #IF cl_null(l_dbs) THEN
     #   SELECT ofa01 INTO g_oma.oma01 FROM ofa_file
     #    WHERE ofa011=g_oga.oga011
     #ELSE
     #FUN-A60056--mark--end
        #LET g_sql = "SELECT ofa01 FROM ofa_file",    #FUN-A70139
         LET g_sql = "SELECT ofa01 FROM ",cl_get_target_table(g_plant_new,'ofa_file'),  #FUN-A70139
                     " WHERE ofa011='",g_oga.oga011,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-A70139
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A70139
         PREPARE sel_ogb_pre19 FROM g_sql
         EXECUTE sel_ogb_pre19 INTO g_oma.oma01
     #END IF    #FUN-A60056
     IF g_oma.oma01 IS NULL THEN                  # 無 INVOICE # 則取出貨單號
        LET g_oma.oma01 = g_oga.oga01
     ELSE
        LET g_oma.oma67=g_oma.oma01   
     END IF
   END IF
    
   LET g_oma.oma66 = g_oea.oeaplant          #FUN-960140 add 090824
   LET g_oma.omalegal = g_oea.oealegal      #FUN-960140
#  LET g_oma.oma70    = '2'                 #FUN-960140  #FUN-B40032 MARK

###-FUN-B40032- ADD - BEGIN ---------------------------------------------
   IF g_oga.oga94 = 'Y' THEN
      LET g_oma.oma70 = '3'
      LET g_mTax = TRUE               #FUN-C10055 add
   ELSE
      LET g_oma.oma70 = '2'
      LET g_mTax = FALSE              #FUN-C10055 add
   END IF

   #FUN-C10055--start add --------------------------------------
   IF g_mTax = FALSE THEN
      SELECT COUNT(*) INTO l_cnt
        FROM ogi_file
       WHERE ogi01 = g_oma.oma16
      IF l_cnt > 0 THEN 
         LET g_mTax = TRUE
      END IF 
   END IF   
   #FUN-C10055--end add ----------------------------------------
###-FUN-B40032- ADD -  END  ---------------------------------------------

   LET g_oma.oma03 = g_oga.oga03                 #出貨單中的客戶 
   IF cl_null(g_oga.oga18) OR g_oga.oga18='' THEN #如果出貨單中的收款客戶為空，則從客戶主檔抓取）
      IF cl_null(l_dbs) THEN
         SELECT occ07 INTO g_oma.oma68 FROM occ_file 
          WHERE occ01 = g_oga.oga03
      ELSE
         #LET g_sql = " SELECT occ07 FROM ",l_dbs CLIPPED,"occ_file",
         LET g_sql = " SELECT occ07 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                     "  WHERE occ01 = '",g_oga.oga03,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
         PREPARE sel_occ_pre20 FROM g_sql
         EXECUTE sel_occ_pre20 INTO g_oma.oma68
      END IF
   ELSE  
      LET g_oma.oma68 = g_oga.oga18              #出貨單中的收款客戶 
   END IF 
   IF NOT cl_null(g_oma.oma68) THEN
      IF cl_null(l_dbs) THEN
         SELECT occ02 INTO g_oma.oma69 FROM occ_file 
          WHERE occ01 = g_oma.oma68                 #再抓取收款客戶簡稱 
      ELSE
         #LET g_sql = "SELECT occ02 FROM ",l_dbs CLIPPED,"occ_file",
         LET g_sql = "SELECT occ02 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                     " WHERE occ01 = '",g_oma.oma68,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102                
         PREPARE sel_occ_pre21 FROM g_sql
         EXECUTE sel_occ_pre21 INTO g_oma.oma69
      END IF
   END IF
   IF cl_null(l_dbs) THEN
      SELECT occ02,occ11,occ18,occ231,occ37
        INTO g_oma.oma032,g_oma.oma042,g_oma.oma043,g_oma.oma044,g_oma.oma40
       #FROM occ_file WHERE occ01=g_oma.oma03 AND occacti = 'Y'    #MOD-CA0047 mark
        FROM occ_file WHERE occ01=g_oma.oma03 AND occacti <> 'N'   #MOD-CA0047 add
   ELSE
      LET g_sql = "SELECT occ02,occ11,occ18,occ231,occ37",
                  #"  FROM ",l_dbs CLIPPED,"occ_file",
                  "  FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                 #" WHERE occ01='",g_oma.oma03,"' AND occacti = 'Y'"    #MOD-CA0047 mark
                  " WHERE occ01='",g_oma.oma03,"' AND occacti <> 'N'"   #MOD-CA0047
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102                
      PREPARE sel_occ_pre22 FROM g_sql
      EXECUTE sel_occ_pre22
         INTO g_oma.oma032,g_oma.oma042,g_oma.oma043,g_oma.oma044,g_oma.oma40
   END IF
  #-MOD-AA0002-add-
   IF g_oma.oma03 = 'MISC' THEN
      LET g_oma.oma032 = g_oga.oga032
     #-MOD-AA0185-add-
      IF NOT cl_null(g_oga.oga16) THEN
         LET g_oma.oma042 = g_oga.oga033
         LET g_sql = "SELECT occm04 ",
                     "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", 
                     "       ",cl_get_target_table(g_plant_new,'oea_file'),",", 
                     "       ",cl_get_target_table(g_plant_new,'occm_file'), 
                     " WHERE oga01='",g_oga.oga01,"'",
                     "   AND oga16 = oea01 AND oeaconf <> 'X' ",
                     "   AND oea01 = occm01"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE sel_occm_pre12 FROM g_sql
         EXECUTE sel_occm_pre12 INTO g_oma.oma044
      ELSE
         LET g_sql = "SELECT occm02,occm04 ",
                     "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", 
                     "       ",cl_get_target_table(g_plant_new,'ogb_file'),",", 
                     "       ",cl_get_target_table(g_plant_new,'oea_file'),",", 
                     "       ",cl_get_target_table(g_plant_new,'occm_file'), 
                     " WHERE oga01 = ogb01 ",
                     "   AND oga01='",g_oga.oga01,"' AND ogb03 = 1 ",
                     "   AND ogb31 = oea01 AND oeaconf <> 'X' ",
                     "   AND oea01 = occm01"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE sel_occm_pre122 FROM g_sql
         EXECUTE sel_occm_pre122 INTO g_oma.oma042,g_oma.oma044
      END IF
     #-MOD-AA0185-end-
   END IF
   IF g_oma.oma68 = 'MISC' THEN
      LET g_oma.oma69 = g_oga.oga032
   END IF
  #-MOD-AA0002-end-
   LET g_oma.oma04 = g_oma.oma03
   LET g_oma.oma08 = g_oga.oga08
   LET g_oma.oma05 = g_oga.oga05
   IF g_oma05 IS NOT NULL THEN LET g_oma.oma05 = g_oma05 END IF
   LET g_oma.oma07 = g_oga.oga07
   LET g_oma.oma13 = g_oga.oga13
   IF cl_null(g_oma.oma13) THEN   #抓取參數預設值 NO:0874
     #SELECT ooz08 INTO g_oma.oma13 FROM ooz_file   #MOD-B10040 mark 
     # WHERE ooz00='0'                              #MOD-B10040
     #-MOD-B10040-add-
      SELECT occ67 INTO g_oma.oma13 FROM occ_file
        WHERE occ01 = g_oma.oma03
      IF cl_null(g_oma.oma13) THEN 
         LET g_oma.oma13 = g_ooz.ooz08
      END IF
     #-MOD-B10040-emd-
   END IF
   LET g_oma.oma14 = g_oga.oga14 LET g_oma.oma15 = g_oga.oga15
   LET g_oma.oma161= g_oga.oga161 LET g_oma.oma162= g_oga.oga162
   LET g_oma.oma163= g_oga.oga163
   SELECT ool11 INTO g_oma.oma18 FROM ool_file WHERE ool01=g_oma.oma13
   IF g_aza.aza63 = 'Y' THEN
      SELECT ool111 INTO g_oma.oma181 FROM ool_file WHERE ool01=g_oma.oma13
   END IF
   IF g_oma.oma161 > 0 THEN 
      #IF g_oma.oma00='12' THEN   #FUN-B10058
      IF g_oma.oma00='12' OR g_oma.oma00 = '19' THEN   #FUN-B10058
         LET g_omb.omb33 = ''   #MOD-C70203 add
         #-----No:FUN-A50103-----
         LET g_oma.oma19 = g_oga.oga16
        #SELECT oma19 INTO g_oma.oma19 FROM oma_file
        #  WHERE oma16=g_oga.oga16 AND oma00='11' AND omavoid='N'    #No.MOD-520011
        ##-----No:FUN-A50103 END-----
         IF g_oga.oga00='4' AND cl_null(g_oma.oma19) THEN
            #-----No:FUN-A50103-----
            SELECT oga16 INTO g_oma.oma19 FROM oga_file
             WHERE oga00='4' AND oga01=g_oga.oga01
           #SELECT oma19 INTO g_oma.oma19 FROM oga_file,oma_file
           # WHERE oga00='4' AND oga01=g_oga.oga01 AND oma00='11' 
           #   AND oma16=oga16
           ##-----No:FUN-A50103 END-----
         END IF
     #-CHI-A50040-mark-
     #ELSE
     #  IF g_oma.oma00='13' AND g_oma.oma162=0 THEN
     #     IF cl_null(g_oma.oma19) THEN
     #        IF g_oga.oga00='4' THEN
     #           IF cl_null(l_dbs) THEN
     #              SELECT oma19 INTO g_oma.oma19 FROM oga_file,oma_file
     #               WHERE oga00='4' AND oga01=g_oga.oga01 AND oma00='11'
     #                 AND oma16=oga16 AND omavoid='N'
     #           ELSE
     #              LET g_sql = "SELECT oma19 FROM ",l_dbs CLIPPED,"oga_file,oma_file",
     #                          " WHERE oga00='4' AND oga01='",g_oga.oga01,"' AND oma00='11'",
     #                          "   AND oma16=oga16 AND omavoid='N'"
     #              PREPARE sel_oga_pre23 FROM g_sql
     #              EXECUTE sel_oga_pre23 INTO g_oma.oma19
     #           END IF
     #        ELSE
     #           IF cl_null(l_dbs) THEN
     #              SELECT oma19 INTO g_oma.oma19 FROM oga_file,oma_file
     #               WHERE oga01=g_oga.oga01 AND oma00='11' AND oma16=oga16 AND omavoid='N'
     #           ELSE
     #              LET g_sql = "SELECT oma19 FROM ",l_dbs CLIPPED,"oga_file,oma_file",
     #                          " WHERE oga01='",g_oga.oga01,"' AND oma00='11' ",
     #                          "   AND oma16=oga16 AND omavoid='N'"
     #              PREPARE sel_oga_pre24 FROM g_sql
     #              EXECUTE sel_oga_pre24 INTO g_oma.oma19
     #           END IF
     #        END IF
     #     END IF
     #  END IF
     #-CHI-A50040-end-
      END IF

      IF NOT cl_null(g_oma.oma19) THEN   #check 訂金產生的待抵是否已沖平
         IF g_ooz.ooz07 = 'N' THEN
            SELECT COUNT(*) INTO g_cnt FROM oma_file
           # WHERE oma01=g_oma.oma19 AND (oma56t-oma57) >0 
             WHERE oma16=g_oma.oma19 AND (oma56t-oma57) >0    #No:FUN-A50103
               AND omaconf='Y'  AND omavoid='N' AND oma00='23'
         ELSE                                                                                                                       
            SELECT COUNT(*) INTO g_cnt FROM oma_file                                                                                
            #WHERE oma01=g_oma.oma19 AND oma61 >0                                                                                   
             WHERE oma16=g_oma.oma19 AND oma61 >0    #No:FUN-A50103
               AND omaconf='Y'  AND omavoid='N' AND oma00='23'                                                                      
         END IF                                                                                                                     
         IF g_cnt =0 THEN   #表待抵均已沖完
            LET g_oma.oma19=' '
         END IF
         SELECT SUM(oma52),SUM(oma53) INTO tot1_12,tot2_12 FROM oma_file
          #WHERE oma19=g_oma.oma19 AND oma00='12' AND omavoid='N'   #FUN-B10058
          WHERE oma19=g_oma.oma19 AND (oma00='12' OR oma00 = '19') AND omavoid='N'   #FUN-B10058
            AND oma16=g_oma.oma16
         SELECT SUM(oma54t),SUM(oma56t) INTO tot1_23,tot2_23 FROM oma_file
         #WHERE oma01=g_oma.oma19 AND oma00='23' AND omavoid='N'
          WHERE oma16=g_oma.oma19 AND oma00='23' AND omavoid='N'    #No:FUN-A50103
         IF cl_null(tot1_23) THEN LET tot1_23=0 END IF
         IF cl_null(tot2_23) THEN LET tot1_23=0 END IF
         IF cl_null(tot1_12) THEN LET tot1_12=0 END IF
         IF cl_null(tot2_12) THEN LET tot1_12=0 END IF
         IF tot1_12 - tot1_23 =0 OR tot2_12 - tot2_23=0 THEN
            LET g_oma.oma19=' '
         END IF
      END IF
   END IF

   LET g_oma.oma21 = g_oga.oga21
   LET g_oma.oma211= g_oga.oga211
   LET g_oma.oma212= g_oga.oga212
   LET g_oma.oma213= g_oga.oga213
   LET g_oma.oma23 = g_oga.oga23
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   SELECT gec08,gec06 INTO g_oma.oma171,g_oma.oma172 FROM gec_file
  #    WHERE gec01 = g_oma.oma21 AND gec011 = '2'
  #   SELECT oga021 INTO g_oga021 FROM oga_file WHERE oga01=g_oma.oma16
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT gec08,gec06 FROM ",l_dbs CLIPPED,"gec_file",
      LET g_sql = "SELECT gec08,gec06 FROM ",cl_get_target_table(g_plant_new,'gec_file'), #FUN-A50102
                  " WHERE gec01 = '",g_oma.oma21,"' AND gec011 = '2'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
      PREPARE sel_gec_pre25 FROM g_sql
      EXECUTE sel_gec_pre25 INTO g_oma.oma171,g_oma.oma172
      #LET g_sql = "SELECT oga021 FROM ",l_dbs CLIPPED,"oga_file WHERE oga01='",g_oma.oma16,"'"
      LET g_sql = "SELECT oga021 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                  " WHERE oga01='",g_oma.oma16,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102  
      PREPARE sel_oga_pre26 FROM g_sql
      EXECUTE sel_oga_pre26 INTO g_oga021
  #END IF   #FUN-A60056
   IF SQLCA.sqlcode THEN
      LET g_oga021=NULL
   END IF
   IF g_oma.oma08='1' THEN 
      LET exT=g_ooz.ooz17 
   ELSE 
      LET exT=g_ooz.ooz63 
   END IF
   LET l_oma24 = g_oma.oma24 #FUN-C60036--add-str
   IF g_oma.oma23 = g_aza.aza17 THEN
      LET g_oma.oma24 = 1
      LET g_oma.oma58 = 1
   ELSE 
      IF (NOT cl_null(g_oga021)) AND (g_oga021>0) THEN
         CALL s_curr3(g_oma.oma23,g_oga021,exT) RETURNING g_oma.oma24
      ELSE
         CALL s_curr3(g_oma.oma23,g_oma.oma02,exT) RETURNING g_oma.oma24
      END IF
      CALL s_curr3(g_oma.oma23,g_oma.oma09,exT) RETURNING g_oma.oma58
      #No.+069 010417 by linda add 若採用訂單匯率立帳,則匯率=訂單匯率
      LET l_oea18=''  LET l_oea24=''
     #FUN-A60056--mark--str--
     #IF cl_null(l_dbs) THEN
     #   LET g_sql = "SELECT UNIQUE oea18,oea24 ",
     #               "  FROM oea_file,ogb_file ",
     #               " WHERE oea01 = ogb31 ",
     #               "   AND ogb01 = '",g_oga.oga01,"'"
     #ELSE
     #FUN-A60056--mark--end
         LET g_sql = "SELECT UNIQUE oea18,oea24 ",
                     #"  FROM ",l_dbs CLIPPED,"oea_file,",l_dbs CLIPPED,"ogb_file ",
                     "  FROM ",cl_get_target_table(g_plant_new,'oea_file'),",", #FUN-A50102
                               cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
                     " WHERE oea01 = ogb31 ",
                     "   AND ogb01 = '",g_oga.oga01,"'"
     #END IF    #FUN-A60056
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
      PREPARE sel_oea_pre27 FROM g_sql
      DECLARE oea18_chk CURSOR FOR sel_oea_pre27
      OPEN oea18_chk 
      FETCH oea18_chk INTO l_oea18,l_oea24
      IF l_oea18 IS NOT NULL AND l_oea18='Y' THEN
         LET g_oma.oma24 = l_oea24
         LET g_oma.oma58 = l_oea24
      END IF
      IF cl_null(g_oma.oma24) THEN LET g_oma.oma24=1 END IF
      IF cl_null(g_oma.oma58) THEN
         #FUN-C60036--add--str
         IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
            LET g_oma.oma58=l_oma24
         ELSE
         #FUN-C60036--ad--end
            LET g_oma.oma58=1
         END IF 
      END IF
   END IF
   #FUN-C60036--add--str
   IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
      LET g_oma.oma24 = l_oma24
      LET g_oma.oma58 = l_oma24
   END IF
   #FUN-C60036--add--end
   
   LET g_oma.oma25 = g_oga.oga25
   LET g_oma.oma26 = g_oga.oga26
  #-CHI-A50040-mark-
  #IF g_oma.oma00='13' THEN
  #   IF cl_null(l_dbs) THEN
  #      SELECT oea81 INTO g_oma.oma32 FROM oea_file WHERE oea01=g_oga.oga16
  #   ELSE
  #      LET g_sql = "SELECT oea81 FROM ",l_dbs CLIPPED,"oea_file WHERE oea01='",g_oga.oga16,"'"
  #      PREPARE sel_oea_pre28 FROM g_sql
  #      EXECUTE sel_oea_pre28 INTO g_oma.oma32
  #   END IF
  #   IF cl_null(g_oma.oma32) THEN
  #      LET g_oma.oma32 = g_oga.oga32 
  #   END IF
  #ELSE
      LET g_oma.oma32 = g_oga.oga32
  #END IF
  #-CHI-A50040-end-
   LET g_oma.oma11 = g_oma.oma02 LET g_oma.oma12  =g_oma.oma02
   LET l_oea02 =  NULL
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   SELECT oea02 INTO l_oea02 FROM oea_file WHERE oea01=g_oga.oga16
  #ELSE
  #FUN-A60056--mark--enhd
      #LET g_sql = "SELECT oea02 FROM ",l_dbs CLIPPED,"oea_file WHERE oea01='",g_oga.oga16,"'"
      LET g_sql = "SELECT oea02 FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
                  " WHERE oea01='",g_oga.oga16,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
      PREPARE sel_oea_pre29 FROM g_sql
      EXECUTE sel_oea_pre29 INTO l_oea02
  #END IF   #FUN-A60056
   CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,
                 #l_oea02,g_plant2) #FUN-980020   #MOD-D10067 mark
                 l_oea02,g_plant_new) #MOD-D10067
                     RETURNING g_oma.oma11,g_oma.oma12
   #No.+074 010423 by linda add 外銷方式,經海關/非經海關等方式
   LET g_oma.oma35 = g_oga.oga35
   LET g_oma.oma36 = g_oga.oga36
   LET g_oma.oma37 = g_oga.oga37
   LET g_oma.oma38 = g_oga.oga38
   LET g_oma.oma39 = g_oga.oga39
   LET g_oma.oma63 = g_oga.oga46   #MOD-580015
   LET g_oma.oma65 = '1'
   LET g_oma.oma60 = g_oma.oma24   #MOD-5B0140
   IF g_source IS NULL OR cl_null(g_source) THEN                                                                                                  
      LET g_oma.oma66=g_plant                                                                                                       
   ELSE                                                                                                                             
      LET g_oma.oma66 = g_source  #FUN-630043
   END IF   #MOD-8C0100 add  
   IF g_aaz.aaz90='Y' THEN
     #FUN-A60056--mark--str--
     #IF cl_null(l_dbs) THEN
     #   LET g_sql = "SELECT ogb930 FROM ogb_file",
     #               " WHERE ogb01='",g_oga.oga01,"'",
     #               "   AND ogb930 IS NOT NULL"
     #ELSE
     #FUN-A60056--mark--end
         #LET g_sql = "SELECT ogb930 FROM ",l_dbs CLIPPED,"ogb_file",
         LET g_sql = "SELECT ogb930 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                     " WHERE ogb01='",g_oga.oga01,"'",
                     "   AND ogb930 IS NOT NULL"
     #END IF   #FN-A60056
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
      PREPARE sel_ogb_pre30 FROM g_sql
      DECLARE s_g_ar_12_oma_c CURSOR FOR sel_ogb_pre30
      OPEN s_g_ar_12_oma_c
      FETCH s_g_ar_12_oma_c INTO g_oma.oma930
      CLOSE s_g_ar_12_oma_c
   END IF

   IF cl_null(g_oma.oma51) THEN
      LET g_oma.oma51 = 0
   END IF

   IF cl_null(g_oma.oma51f) THEN
      LET g_oma.oma51f = 0
   END IF

   LET g_t1 = g_oma.oma01[1,g_doc_len] 
   SELECT ooyapr INTO g_oma.omamksg FROM ooy_file 
    WHERE ooyslip = g_t1

   LET g_oma.oma64 = '0'        #No.TQC-7B0144 
   LET g_oma.oma71 = g_oga.oga71  #MOD-AB0164
   LET g_oma.oma99 = g_oga.oga99  #TQC-7C0146
 
   LET g_oma.omalegal = g_legal #FUN-980011 add
 
   LET g_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
#FUN-AC0027 --begin--
   LET g_oma.oma74 = g_oga.oga57  #Add No.FUN-AC0025
   IF cl_null(g_oma.oma74) THEN
      LET g_oma.oma74 = '1'
   END IF
   IF cl_null(g_oma.oma73) THEN
      LET g_oma.oma73 = 0
   END IF
   IF cl_null(g_oma.oma73f) THEN
      LET g_oma.oma73f = 0
   END IF
#FUN-AC0027 --end--
   IF g_aza.aza26 = '2' AND g_oaz92 = 'Y' THEN #FUN-CB0057 add
      LET g_oma.oma76 = g_omf00 #FUN-CB0057 add
   END IF #FUN-CB0057 add

   INSERT INTO oma_file VALUES(g_oma.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
      LET g_msg='ins oma:(',g_oma.oma01,')'
   IF g_bgerr THEN
      CALL s_errmsg('oma01',g_oma.oma01,g_msg,SQLCA.SQLCODE,1)
   ELSE
      CALL cl_err3("ins","oma_file",g_oma.oma01,"",SQLCA.SQLCODE,"",g_msg,1)
   END IF
      LET g_success='N' RETURN 
   ELSE
      MESSAGE g_oma.oma01           #No.FUN-560116
      CALL ui.Interface.refresh()   #No.FUN-560116
      
   END IF
   IF g_begin IS NULL THEN LET g_begin = g_oma.oma01 END IF
END FUNCTION
 
FUNCTION s_g_ar_12_omb(p_qty)
   DEFINE l_omb18t   LIKE omb_file.omb18t
   DEFINE l_amt      LIKE omb_file.omb18t
   DEFINE l_qty      LIKE omb_file.omb12         #FUN-4C0013
   DEFINE p_flag     LIKE type_file.chr1         #No.FUN-680123 VARCHAR(01)
   DEFINE p_qty      LIKE omb_file.omb12
   DEFINE l_qty2     LIKE omb_file.omb12
   DEFINE l_azf14    LIKE azf_file.azf14         #FUN-810045
   DEFINE l_azf20    LIKE azf_file.azf20         #FUN-BA0109
   DEFINE l_azf201   LIKE azf_file.azf201        #FUN-BA0109
   DEFINE l_oba11    LIKE oba_file.oba11         #MOD-850063 add
   DEFINE l_n        LIKE type_file.num5        #No.FUN-960140
   DEFINE l_rxx04    LIKE rxx_file.rxx04        #No.FUN-960140
   DEFINE l_oeb917   LIKE oeb_file.oeb917        #CHI-A50040
   DEFINE l_ogb917   LIKE ogb_file.ogb917        #CHI-A50040
   DEFINE l_ogb47_p  LIKE ogb_file.ogb47         #No.TQC-C20565
   DEFINE l_oba111   LIKE oba_file.oba111        #FUN-C90078
     LET g_omb.omb33 = NULL            #MOD-CA0083
     LET g_omb.omb331 = NULL           #MOD-CA0083  
     LET g_omb.omb01 = g_oma.oma01
     LET g_omb.omb31 = g_ogb.ogb01
     LET g_omb.omb32 = g_ogb.ogb03
     LET g_omb.omb04 = g_ogb.ogb04
     LET g_omb.omb05 = g_ogb.ogb916   #FUN-560070
     LET g_omb.omb06 = g_ogb.ogb06
     LET g_omb.omb40 = g_ogb.ogb1001  #No.FUN-660073
     #FUN-C60036--add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
        IF cl_null(g_ogb.ogb01) THEN  
        SELECT omf11,omf12,omf13,omf916,omf14,' ',omf917,0,0,omf28,omf29,omf29t,' ',' ',' ',omf09
          INTO g_ogb.ogb01,g_ogb.ogb03,g_ogb.ogb04,g_ogb.ogb916,g_ogb.ogb06,g_ogb.ogb1001,g_ogb.ogb917,
               g_ogb.ogb47,g_ogb.ogb12,g_ogb.ogb13,g_ogb.ogb14,g_ogb.ogb14t,g_ogb.ogb41,g_ogb.ogb42,g_ogb.ogb930,
               g_ogb.ogbplant
          FROM omf_file
         WHERE omf00 = g_omf00
           AND omf21 = g_ogb03
        ELSE
        SELECT omf28,omf917,omf29,omf29t INTO 
            g_ogb.ogb13,g_ogb.ogb917,g_ogb.ogb14,g_ogb.ogb14t FROM omf_file
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00   #minpp  add
           AND omf02 = g_omf02
           AND omf12 = g_ogb.ogb03
           AND omf11 = g_ogb.ogb01
           AND omf04 IS NULL
           AND omf09 = l_azp01
        END IF 
     END IF 
     IF cl_null(g_ogb.ogb60) THEN LET g_ogb.ogb60 = 0 END IF
     IF cl_null(g_ogb.ogb64) THEN lET g_ogb.ogb64 = 0 END IF
     #FUN-C60036--add--end
    
    #IF g_oma.oma00='12' THEN                          #CHI-A50040 mark
     #FUN-C60036 --add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
        LET g_omb.omb12 = g_ogb.ogb917
     ELSE
     #FUN-C60036--add--end
        LET g_omb.omb12 = g_ogb.ogb917-g_ogb.ogb60-g_ogb.ogb64  #NO:5009   #FUN-560070
     END IF #FUN-C60036--add
    #ELSE                                              #CHI-A50040 mark
    #   LET g_omb.omb12 = g_ogb.ogb917   #FUN-560070   #CHI-A50040 mark
    #END IF                                            #CHI-A50040 mark
     IF g_check = 'N' AND g_aza.aza26 = '2' AND g_ooy.ooy10 = 'Y' AND p_qty > 0 THEN    #MOD-630073 #FUN-960140
        LET g_omb.omb12 = p_qty
     END IF
     
     IF cl_null(g_ogb.ogb1006)  THEN
        LET g_omb.omb13 = g_ogb.ogb13
     ELSE
       #No.TQC-C20565 ---start---   Add
        IF g_ogb.ogb04 = 'MISCCARD' THEN
           LET l_ogb47_p = g_ogb.ogb47/g_ogb.ogb12
           LET g_omb.omb13 = g_ogb.ogb13 + l_ogb47_p
        ELSE
       #No.TQC-C20565 ---start---   Add
           LET g_omb.omb13 = g_ogb.ogb13*(g_ogb.ogb1006/100)
        END IF #No.TQC-C20565   Add
     END IF
     IF g_omb.omb12 = 0 THEN
        LET g_omb.omb13 = 0
        LET g_omb.omb14 = 0
        LET g_omb.omb14t= 0
     END IF
     CALL cl_digcut(g_omb.omb13,t_azi03) RETURNING g_omb.omb13   #MOD-760078
###-FUN-B40032- MARK - BEGIN ------------------------------------------------------
#    IF g_oma.oma213 = 'N'
#       THEN IF g_omb.omb12 != 0 THEN
#               LET g_omb.omb14 =g_omb.omb12*g_omb.omb13
#            END IF
#            CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
#            LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)
#            CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
#       ELSE IF g_omb.omb12 != 0 THEN
#              LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
#            END IF
#            CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
#            LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100)
#            CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
#    END IF
###-FUN-B40032- MARK -  END  ------------------------------------------------------
###-FUN-B40032- ADD  - BEGIN ------------------------------------------------------
     #IF g_oma.oma70 = '3' THEN             #FUN-C10055 mark
     IF g_mTax = TRUE THEN                    #FUN-C10055 add
        LET g_omb.omb14 = g_ogb.ogb14
        LET g_omb.omb14t = g_ogb.ogb14t
     ELSE
        IF g_oma.oma213 = 'N' THEN
           IF g_omb.omb12 != 0 THEN
              LET g_omb.omb14 =g_omb.omb12*g_omb.omb13
           END IF
           CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
           LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)
           CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
        ELSE 
           IF g_omb.omb12 != 0 THEN
              LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
           END IF  
           CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
           LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100)
           CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
        END IF
     END IF
###-FUN-B40032- ADD  -  END  ------------------------------------------------------
     #Add No:FUN-AC0025
     LET g_omb.omb45 = g_ogb.ogb49    #商户编号
#by elva mark begin
#    IF g_oma.oma74 ='2' THEN
#       LET g_omb.omb14 = g_omb.omb14t  #omb16,omb18不用再复制，根据后面的计算公式，含税和未税值是一样的
#    END IF
#by elva mark end
     #FUN-C60036--add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
        IF cl_null(g_ogb.ogb01) THEN
        SELECT omf11,omf12,omf13,omf916,omf14,' ',omf917,0,0,omf28,omf29,omf29t,' ',' ',' ',omf09
          INTO g_ogb.ogb01,g_ogb.ogb03,g_ogb.ogb04,g_ogb.ogb916,g_ogb.ogb06,g_ogb.ogb1001,g_ogb.ogb917,
               g_ogb.ogb47,g_ogb.ogb12,g_ogb.ogb13,g_ogb.ogb14,g_ogb.ogb14t,g_ogb.ogb41,g_ogb.ogb42,g_ogb.ogb930,
               g_ogb.ogbplant
          FROM omf_file
         WHERE omf00 = g_omf00
           AND omf21 = g_ogb03
        ELSE
        SELECT omf28,omf917,omf29,omf29t INTO
            g_ogb.ogb13,g_ogb.ogb917,g_ogb.ogb14,g_ogb.ogb14t FROM omf_file
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00   #minpp  add
           AND omf02 = g_omf02
           AND omf12 = g_ogb.ogb03
           AND omf11 = g_ogb.ogb01
           AND omf04 IS NULL
           AND omf09 = l_azp01
        END IF
    #   SELECT omf28,omf16,omf29,omf29t INTO 
    #       g_omb.omb13,g_omb.omb12,g_omb.omb14,g_omb.omb14t FROM omf_file
    #    WHERE omf01 = g_omf01
    #      AND omf00 = g_omf00   #minpp  add 
    #      AND omf02 = g_omf02
    #      AND omf12 = g_ogb.ogb03
    #      AND omf11 = g_ogb.ogb01
    #      AND omf04 IS NULL
    #      AND omf09 = l_azp01
     END IF 
     #FUN-C60036--add--end
     #End Add No:FUN-AC0025
     LET g_omb.omb15 =g_omb.omb13 *g_oma.oma24
     LET g_omb.omb16 =g_omb.omb14 *g_oma.oma24
     LET g_omb.omb16t=g_omb.omb14t*g_oma.oma24
     LET g_omb.omb17 =g_omb.omb13 *g_oma.oma58
     LET g_omb.omb18 =g_omb.omb14 *g_oma.oma58
     LET g_omb.omb18t=g_omb.omb14t*g_oma.oma58
     CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15   #MOD-760078
     CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16   #MOD-760078
     CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t  #MOD-760078
     CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17   #MOD-760078
     CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18   #MOD-760078
     CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t  #MOD-760078
     #超過發票限額則拆數量
     LET p_flag = 'N'
     LET p_qty = 0
     IF g_check = 'N' AND g_aza.aza26 = '2' AND g_ooy.ooy10 = 'Y' AND g_oaz.oaz92 !='Y' THEN   #MOD-630073 #FUN-960140#TQC-D10093 add oaz92
        SELECT SUM(omb18t) INTO l_omb18t FROM omb_file WHERE omb01=g_oma.oma01
        IF cl_null(l_omb18t) THEN LET l_omb18t = 0 END IF
        IF l_omb18t + g_omb.omb18t > g_ooy.ooy11 THEN
           LET p_flag = 'Y'
           LET l_amt = g_ooy.ooy11
        ELSE
           LET p_flag = 'N'       #No.MOD-930061
           LET l_amt = l_omb18t + g_omb.omb18t 
        END IF
        IF p_flag = 'Y' THEN      #MOD-9B0073 Add
           IF g_omb.omb12 > 1 THEN
              LET l_qty = (l_amt - l_omb18t) / (g_omb.omb18t / g_omb.omb12)
              LET p_qty = g_omb.omb12 - l_qty
              LET g_omb.omb12 = l_qty
           ELSE  
              LET l_qty2 = (l_amt - l_omb18t)/ (g_omb.omb18t / g_omb.omb12)
              LET p_qty = g_omb.omb12 - l_qty2
              LET g_omb.omb12 = l_qty2
           END IF
           IF g_oma.oma213 = 'N' THEN
              IF g_omb.omb12 != 0 THEN
                 LET g_omb.omb14 =g_omb.omb12*g_omb.omb13
              END IF
              CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
              LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)
              CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
           ELSE 
              IF g_omb.omb12 != 0 THEN
                 LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
              END IF
              CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
              LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100)
              CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
           END IF
           #Add No:FUN-AC0025
#by elva mark begin
#          IF g_oma.oma74 ='2' THEN
#             LET g_omb.omb14 = g_omb.omb14t  #omb16,omb18不用再复制，根据后面的计算公式，含税和未税值是一样的
#          END IF
#by elva mark end
           #End Add No:FUN-AC0025
           LET g_omb.omb15 =g_omb.omb13 *g_oma.oma24
           LET g_omb.omb16 =g_omb.omb14 *g_oma.oma24
           LET g_omb.omb16t=g_omb.omb14t*g_oma.oma24
           LET g_omb.omb17 =g_omb.omb13 *g_oma.oma58
           LET g_omb.omb18 =g_omb.omb14 *g_oma.oma58
           LET g_omb.omb18t=g_omb.omb14t*g_oma.oma58
           CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15   #MOD-760078
           CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16   #MOD-760078
           CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t  #MOD-760078
           CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17   #MOD-760078
           CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18   #MOD-760078
           CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t  #MOD-760078
        END IF                                                         #MOD-9B0073 Add
     END IF
     MESSAGE g_omb.omb03,' ',g_omb.omb04,' ',g_omb.omb12
     LET g_omb.omb36 = g_oma.oma24                          #A060
     LET g_omb.omb37 = g_omb.omb16t-g_omb.omb35             #A060
     LET g_omb.omb34 = 0 LET g_omb.omb35 = 0 
     LET g_omb.omb00 = g_oma.oma00   #MOD-6A0102
     LET g_omb.omb38 = '2'                       #出貨單 
      #FUN-C60036 add--str
     IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 = '2' AND cl_null(g_ogb.ogb01)  THEN 
        LET g_omb.omb38 = '99'
     END IF 
     #FUN-C60036--add--end
     LET g_omb.omb39 = g_ogb.ogb1012             #搭贈
     IF g_omb.omb39 = 'Y' THEN                   #如為搭贈
        LET g_omb.omb14 = 0
        LET g_omb.omb14t= 0
        LET g_omb.omb16 = 0
        LET g_omb.omb16t= 0
        LET g_omb.omb18 = 0
        LET g_omb.omb18t= 0
     END IF
   ##當oma00='12'or'13'時,需依料件產品分類至axmi110的抓取'銷貨收入科目'(oba11)寫入omb33   #CHI-A50040 mark 
    #當oma00='12''時,需依料件產品分類至axmi110的抓取'銷貨收入科目'(oba11)寫入omb33        #CHI-A50040
#No.TQC-B70009 --begin
    #IF g_oma.oma00 ='12' OR g_oma.oma00 ='13' THEN                                       #CHI-A50040 mark
     #IF g_oma.oma00 ='12' THEN                                                            #CHI-A50040  #FUN-B10058
#     IF g_oma.oma00 ='12' OR g_oma.oma00 = '19' THEN      #FUN-B10058                                     
#        LET l_oba11 = NULL
#        IF cl_null(l_dbs) THEN
#           SELECT oba11 INTO l_oba11
#             FROM oba_file,ima_file
#            WHERE oba01 = ima_file.ima131
#              AND ima01 = g_omb.omb04
#        ELSE
#           LET g_sql = "SELECT oba11 ",
#                       #" FROM ",l_dbs CLIPPED,"oba_file,",l_dbs CLIPPED,"ima_file",
#                       " FROM ",cl_get_target_table(g_plant_new,'oba_file'),",", #FUN-A50102
#                                cl_get_target_table(g_plant_new,'ima_file'),     #FUN-A50102
#                       " WHERE oba01 = ima_file.ima131",
#                       " AND ima01 = '",g_omb.omb04,"'"
#           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
#	       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
#           PREPARE sel_oba_pre31 FROM g_sql
#           EXECUTE sel_oba_pre31 INTO l_oba11
#        END IF
#        IF SQLCA.sqlcode THEN
#           LET l_oba11 = NULL
#           IF g_bgerr THEN
#              CALL s_errmsg('','',"sel oba",STATUS,0)
#           ELSE
#              CALL cl_err3("sel","oba_file",g_omb.omb04,"",STATUS,"","sel oba",0)
#           END IF
#        END IF
#        LET g_omb.omb33 = l_oba11
#     END IF
#     LET g_omb.omb930= g_ogb.ogb930 #FUN-680001
#     LET g_omb.omb41 = g_ogb.ogb41
#     LET g_omb.omb42 = g_ogb.ogb42
#     IF NOT cl_null(g_omb.omb40) THEN
#        IF cl_null(l_dbs) THEN
#           SELECT azf14 INTO l_azf14
#             FROM azf_file
#            WHERE azf01=g_omb.omb40 AND azf02='2' AND azfacti='Y'
#        ELSE
#           LET g_sql = "SELECT azf14 ",
#                       #"  FROM ",l_dbs CLIPPED,"azf_file",
#                       "  FROM ",cl_get_target_table(g_plant_new,'azf_file'), #FUN-A50102
#                       " WHERE azf01='",g_omb.omb40,"' AND azf02='2' AND azfacti='Y'"
#           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
#	       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102            
#           PREPARE sel_azf_pre32 FROM g_sql
#           EXECUTE sel_azf_pre32 INTO l_azf14
#        END IF
#       IF NOT cl_null(l_azf14) THEN LET g_omb.omb33=l_azf14 END IF
#     END IF
#     #Add No:FUN-AC0025
#     IF g_oma.oma74='2' THEN
#        SELECT ool36 INTO g_omb.omb33 FROM ool_file
#         WHERE ool01=g_oma.oma13
#        IF g_aza.aza63 = 'Y' THEN
#           SELECT ool361 INTO g_omb.omb331 FROM ool_file
#            WHERE ool01=g_oma.oma13
#        END IF
#     END IF


     IF g_oma.oma00 ='12' OR g_oma.oma00 = '19' THEN      #FUN-B10058                                     
        IF NOT cl_null(g_omb.omb40) THEN
           IF cl_null(l_dbs) THEN
              IF g_oma.oma08='1' THEN                     #FUN-C90078 
                 #SELECT azf14 INTO l_azf14                  #FUN-BA0109
                 SELECT azf20.azf201 INTO l_azf20,l_azf201   #FUN-BA0109
                   FROM azf_file
                  WHERE azf01=g_omb.omb40 AND azf02='2' AND azfacti='Y'
              #FUN-C90078--add--str
              ELSE
                 SELECT azf21.azf211 INTO l_azf20,l_azf201   #FUN-BA0109
                   FROM azf_file
                  WHERE azf01=g_omb.omb40 AND azf02='2' AND azfacti='Y'
              END IF
              #FUN-C90078--add--end
           ELSE
              IF g_oma.oma08='1' THEN                     #FUN-C90078
                 #LET g_sql = "SELECT azf14 ",
                 LET g_sql = "SELECT azf20,azf201 ",         #FUN-BA0109
                          "  FROM ",cl_get_target_table(g_plant_new,'azf_file'), #FUN-A50102
                          " WHERE azf01='",g_omb.omb40,"' AND azf02='2' AND azfacti='Y'"
              #FUN-C90078--add--str
              ELSE
                 LET g_sql = "SELECT azf21,azf211 ",
                             "  FROM ",cl_get_target_table(g_plant_new,'azf_file'),
                             " WHERE azf01='",g_omb.omb40,"' AND azf02='2' AND azfacti='Y'"
              END IF
              #FUN-C90078--add--end
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102            
              PREPARE sel_azf_pre32 FROM g_sql
              #EXECUTE sel_azf_pre32 INTO l_azf14
              EXECUTE sel_azf_pre32 INTO l_azf20,l_azf201  #FUN-BA0109
           END IF
           #IF NOT cl_null(l_azf14) THEN LET g_omb.omb33=l_azf14 END IF  #FUN-BA0109
           IF NOT cl_null(l_azf20) THEN LET g_omb.omb33=l_azf20 END IF   #FUN-BA0109
        END IF
        IF g_aza.aza63='Y' AND cl_null(g_omb.omb331) THEN
          #LET g_omb.omb331 = g_omb.omb33                                  #FUN-BA0109
          IF NOT cl_null(l_azf201) THEN LET g_omb.omb331=l_azf201 END IF   #FUN-BA0109
        END IF
        IF cl_null(g_omb.omb33) THEN 
           LET l_oba11 = NULL
           IF cl_null(l_dbs) THEN
              IF g_oma.oma08='1' THEN                     #FUN-C90078
                 SELECT oba11 INTO l_oba11
                   FROM oba_file,ima_file
                  WHERE oba01 = ima_file.ima131
                    AND ima01 = g_omb.omb04
              #FUN-C90078--add--str
              ELSE
                 SELECT oba17 INTO l_oba11
                   FROM oba_file,ima_file
                  WHERE oba01 = ima_file.ima131
                    AND ima01 = g_omb.omb04
              END IF
              #FUN-C90078--add--end
           ELSE
              IF g_oma.oma08='1' THEN                     #FUN-C90078
                 LET g_sql = "SELECT oba11 ",
                             " FROM ",cl_get_target_table(g_plant_new,'oba_file'),",", #FUN-A50102
                                      cl_get_target_table(g_plant_new,'ima_file'),     #FUN-A50102
                             " WHERE oba01 = ima_file.ima131",
                             " AND ima01 = '",g_omb.omb04,"'"
                 #FUN-C90078--add--str
              ELSE
                 LET g_sql = "SELECT oba17 ",
                             " FROM ",cl_get_target_table(g_plant_new,'oba_file'),",",
                                      cl_get_target_table(g_plant_new,'ima_file'),
                             " WHERE oba01 = ima_file.ima131",
                             " AND ima01 = '",g_omb.omb04,"'"
              END IF
              #FUN-C90078--add--end
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
              PREPARE sel_oba_pre31 FROM g_sql
              EXECUTE sel_oba_pre31 INTO l_oba11
           END IF
           IF SQLCA.sqlcode THEN
              LET l_oba11 = NULL
              IF g_bgerr THEN
                 CALL s_errmsg('','',"sel oba",STATUS,0)
              ELSE
                 CALL cl_err3("sel","oba_file",g_omb.omb04,"",STATUS,"","sel oba",0)
              END IF
           END IF
           LET g_omb.omb33 = l_oba11
           #FUN-C90078--add--str
           IF g_aza.aza63='Y' THEN
              IF g_oma.oma08 = '1' THEN
                 LET g_sql = "SELECT oba111 ",
                             "  FROM ",cl_get_target_table(g_plant_new,'oba_file'),",",
                                       cl_get_target_table(g_plant_new,'ima_file'),
                             " WHERE oba01 = ima_file.ima131",
                             "   AND ima01 = '",g_omb.omb04,"'"
              ELSE
                 LET g_sql = "SELECT oba171 ",
                             "  FROM ",cl_get_target_table(g_plant_new,'oba_file'),",",
                                       cl_get_target_table(g_plant_new,'ima_file'),
                             " WHERE oba01 = ima_file.ima131",
                             "   AND ima01 = '",g_omb.omb04,"'"
              END IF
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql
              CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
              PREPARE sel_oba_pre19_1 FROM g_sql
              EXECUTE sel_oba_pre19_1 INTO l_oba111
              IF SQLCA.sqlcode THEN
                 LET l_oba111 = NULL
                 CALL s_errmsg('ima01',g_omb.omb04,"sel oba" ,STATUS,0)
              END IF
              LET g_omb.omb331 = l_oba111
           END IF
         #FUN-C90078--add--end
        END IF 
        IF cl_null(g_omb.omb33) THEN
           IF g_oma.oma08='1' THEN                     #FUN-C90078
              SELECT ool41 INTO g_omb.omb33 
                FROM ool_file
               WHERE ool01 = g_oma.oma13
              IF g_aza.aza63 = 'Y' THEN
                 SELECT ool411 INTO g_omb.omb331 
                   FROM ool_file
                  WHERE ool01 = g_oma.oma13
              END IF         
           #FUN-C90078-add---str
           ELSE
              SELECT ool40 INTO g_omb.omb33
                FROM ool_file
               WHERE ool01 = g_oma.oma13
              IF g_aza.aza63 = 'Y' THEN
                 SELECT ool401 INTO g_omb.omb331
                   FROM ool_file
                  WHERE ool01 = g_oma.oma13
              END IF
           END IF
           #FUN-C90078-add--end      
        END IF 
        IF g_oma.oma74 = '2' THEN
           SELECT ool36 INTO g_omb.omb33 
             FROM ool_file
            WHERE ool01 = g_oma.oma13
           IF g_aza.aza63 = 'Y' THEN
              SELECT ool361 INTO g_omb.omb331 
                FROM ool_file
               WHERE ool01 = g_oma.oma13
           END IF               
        END IF    
     END IF
     LET g_omb.omb930= g_ogb.ogb930 #FUN-680001
     LET g_omb.omb41 = g_ogb.ogb41
     LET g_omb.omb42 = g_ogb.ogb42

#No.TQC-B70009 --end
 
     LET g_omb.omblegal = g_legal #FUN-980011 add
     LET g_omb.omb44 = g_ogb.ogbplant   #FUN-9A0093 

     #FUN-C60036--add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
        IF cl_null(g_ogb.ogb01) THEN 
          #SELECT omf19,omf19t INTO g_omb.omb16,g_omb.omb16t#FUN-D40067 mark
        SELECT omf19,omf19t,omf29,omf29t INTO g_omb.omb16,g_omb.omb16t,g_omb.omb14,g_omb.omb14t #FUN-D40067 add
          FROM omf_file
           WHERE omf00 = g_omf00
            AND omf21 = g_ogb03
        ELSE
       #SELECT omf19,omf19t INTO g_omb.omb16,g_omb.omb16t#FUN-D40067 mark
        SELECT omf19,omf19t,omf29,omf29t INTO g_omb.omb16,g_omb.omb16t,g_omb.omb14,g_omb.omb14t #FUN-D40067 add
          FROM omf_file
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00 
           AND omf02 = g_omf02
           AND omf12 = g_ogb.ogb03
           AND omf11 = g_ogb.ogb01
           AND omf04 IS NULL
           AND omf09 = l_azp01 
        END IF 
        LET g_omb.omb18 = g_omb.omb16
        LET g_omb.omb18t = g_omb.omb16t
     END IF 
     CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16
     CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t
     CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18
     CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t
     CALL cl_digcut(g_omb.omb14,t_azi04)RETURNING g_omb.omb14#FUN-D40067 add
     CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t#FUN-D40067 add     
     IF cl_null(g_omb.omb46) THEN LET g_omb.omb46 = ' ' END IF 
     IF g_omb.omb32 = 0 THEN LET g_omb.omb32 = '' END IF
     #FUN-C60036--add--end
     LET g_omb.omb48 = 0   #FUN-D10101 add
     INSERT INTO omb_file VALUES(g_omb.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
     IF g_bgerr THEN
        LET g_showmsg=g_omb.omb01,"/",g_omb.omb03
        CALL s_errmsg('omb01,omb03',g_showmsg,'ins omb',SQLCA.SQLCODE,1)
     ELSE
        CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.SQLCODE,"","ins omb",1)
     END IF
     LET g_success='N' RETURN p_flag,p_qty
     ELSE
        #FUN-C60036--add--str
      IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
         UPDATE omf_file SET omf04 = g_oma.oma01 
          WHERE omf01 = g_omf01
           AND  omf00 = g_omf00   #minpp  add
           AND omf02 = g_omf02
           AND omf21 = g_ogb03
          #AND omf11 = g_oga.oga01
          #AND omf12 = g_ogb.ogb03
         IF STATUS OR SQLCA.SQLCODE THEN
            LET g_showmsg=g_oma.oma10,"/",g_oma.oma75                                             
            CALL s_errmsg('omf01,omf02',g_showmsg,"upd omf",SQLCA.SQLCODE,1)                       
            LET g_success='N'
         END IF
      END IF 
      #FUN-C60036--add--end
        
     END IF
###-FUN-B40032- ADD - BEGIN ---------------------------------------------------
     #IF g_oma.oma70 = '3' THEN              #FUN-C10055 mark
     IF g_mTax = TRUE THEN                   #FUN-C10055 add
        LET g_sql =
           "INSERT INTO oml_file (oml01,oml02,oml03,oml04,oml05,oml06,oml07,  ",
           "                      oml08,oml08t,oml09,omldate,omlgrup,         ",
           "                      omllegal,omlmodu,omlorig,omloriu,omluser)   ",
           "SELECT '",g_oma.oma01,"'",",ogi02,ogi03,ogi04,ogi05,ogi06,        ",
           "            ogi07,ogi08,ogi08t,ogi09,'','",g_grup,"','",g_legal,"'",
           "                        ,'','",g_grup,"','",g_user,"','",g_user,"'",
          #"  FROM ogi_file ",
           "  FROM ",cl_get_target_table(g_plant_new,'ogi_file'), #By shi
           " WHERE ogi01 = '",g_ogb.ogb01,"'",
           "   AND ogi02 = '",g_ogb.ogb03,"'" #By shi
        PREPARE ins_oml_pre2 FROM g_sql
        EXECUTE ins_oml_pre2
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           IF g_bgerr THEN
              LET g_showmsg=g_oma.oma01
              CALL s_errmsg('oml01',g_showmsg,'ins oml',SQLCA.SQLCODE,1)
           ELSE
              CALL cl_err3("ins","oml_file",g_oma.oma01,"",SQLCA.sqlcode,"","ins oml",1)
           END IF
           LET g_success='N'
           RETURN p_flag,p_qty
        END IF
       #By shi Begin---
        LET g_cnt = 0
        LET g_sql = " SELECT COUNT(*) FROM omk_file ",
                    "  WHERE omk01='",g_oma.oma01,"'"
        PREPARE sel_omk_pre FROM g_sql
        EXECUTE sel_omk_pre INTO g_cnt
        IF g_cnt = 0 THEN
       #By shi End-----
           LET g_sql =
             #By shi Begin---
             #"INSERT INTO oml_file (oml01,oml02,oml03,oml04,oml05,oml06,oml07,  ",
             #"                      oml08,oml08t,oml09,omldate,omlgrup,         ",
             #"                      omllegal,omlmodu,omlorig,omloriu,omluser)   ",
             #"SELECT ",g_oma.oma01,",ogh02,ogh03,ogh04,ogh05,ogh06,ogh07,       ",
             #"                       ogh08,ogh08t,ogh09,'',",g_grup,",",g_legal,",
             #"                      ,'',",g_grup,",",g_user,",",g_user          ",
             #"  FROM ogh_file ",
             #" WHERE ogh01 = ",g_oeb.oeb01
              "INSERT INTO omk_file (omk01,omk02,omk03,omk04,omk05,omk06,omk07,  ",
              "                      omk07t,omk08,omk09,omkdate,omkgrup,         ",
              "                      omklegal,omkmodu,omkorig,omkoriu,omkuser)   ",
              "SELECT '",g_oma.oma01,"',ogh02,ogh03,ogh04,ogh05,ogh06,ogh07,       ",
              "                       ogh07t,ogh08,ogh09,'','",g_grup,"','",g_legal,"',",
              "                       '','",g_grup,"','",g_user,"','",g_user,"'",
              "  FROM ",cl_get_target_table(g_plant_new,'ogh_file'),
              " WHERE ogh01 = '",g_ogb.ogb01,"'"
             #By shi End-----
           PREPARE ins_omk_pre3 FROM g_sql
           EXECUTE ins_omk_pre3
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              IF g_bgerr THEN
                 LET g_showmsg=g_oma.oma01
                 CALL s_errmsg('omk01',g_showmsg,'ins omk',SQLCA.SQLCODE,1)
              ELSE
                 CALL cl_err3("ins","omk_file",g_oma.oma01,"",SQLCA.sqlcode,"","ins omk",1)
              END IF
              LET g_success='N'
              RETURN p_flag,p_qty
           END IF
        END IF #By shi Add
     END IF
###-FUN-B40032- ADD -  END  ---------------------------------------------------
     RETURN p_flag,p_qty
END FUNCTION
 
FUNCTION s_g_ar_122_omb()
  DEFINE l_azf20   LIKE  azf_file.azf20    #FUN-BA0109
  DEFINE l_azf201  LIKE  azf_file.azf201   #FUN-BA0109
     LET g_omb.omb33 = NULL            #MOD-CA0083
     LET g_omb.omb331 = NULL           #MOD-CA0083  
     LET g_omb.omb01 = g_oma.oma01
     LET g_omb.omb31 = NULL
     LET g_omb.omb32 = NULL
     LET g_omb.omb04 = g_ofb.ofb04
     LET g_omb.omb05 = g_ofb.ofb916   #FUN-560070
     LET g_omb.omb06 = g_ofb.ofb06
     LET g_omb.omb12 = g_ofb.ofb917   #FUN-560070
     LET g_omb.omb13 = g_ofb.ofb13
     CALL cl_digcut(g_omb.omb13,t_azi03)RETURNING g_omb.omb13   #MOD-760078
     IF g_oma.oma213 = 'N'
        THEN LET g_omb.omb14 =g_omb.omb12*g_omb.omb13
             CALL cl_digcut(g_omb.omb14,t_azi04)RETURNING g_omb.omb14   #MOD-760078
             LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)
             CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
        ELSE LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
             CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
             LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100)
             CALL cl_digcut(g_omb.omb14,t_azi04)RETURNING g_omb.omb14   #MOD-760078
     END IF
     LET g_omb.omb15 =g_omb.omb13 *g_oma.oma24
     LET g_omb.omb16 =g_omb.omb14 *g_oma.oma24
     LET g_omb.omb16t=g_omb.omb14t*g_oma.oma24
     LET g_omb.omb17 =g_omb.omb13 *g_oma.oma58
     LET g_omb.omb18 =g_omb.omb14 *g_oma.oma58
     LET g_omb.omb18t=g_omb.omb14t*g_oma.oma58
     CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15   #MOD-760078
     CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16   #MOD-760078
     CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t  #MOD-760078
     CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17   #MOD-760078
     CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18   #MOD-760078
     CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t  #MOD-760078
     MESSAGE g_omb.omb03,' ',g_omb.omb04,' ',g_omb.omb12
     LET g_omb.omb36 = g_oma.oma24                     #A060
     LET g_omb.omb37 = g_omb.omb16t - g_omb.omb35      #A060
     LET g_omb.omb34 = 0 LET g_omb.omb35 = 0 
     LET g_omb.omb00 = g_oma.oma00   #MOD-6A0102
     LET g_omb.omb930= g_oma.oma930 #FUN-680001
    #FUN-A60056--mark--str--
    #IF cl_null(l_dbs) THEN
    #   SELECT oeb41,oeb42,oeb1001 INTO g_omb.omb41,g_omb.omb42,g_omb.omb40
    #     FROM oeb_file
    #    WHERE oeb01 = g_ofb.ofb31 AND oeb03 = g_ofb.ofb32
    #ELSE
    #FUN-A60056--mark--end
        LET g_sql = "SELECT oeb41,oeb42,oeb1001 ",
                    #"  FROM ",l_dbs CLIPPED,"oeb_file",
                    "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                    " WHERE oeb01 = '",g_ofb.ofb31,"' AND oeb03 = '",g_ofb.ofb32,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102  
        PREPARE sel_ofb_pre33 FROM g_sql
        EXECUTE sel_ofb_pre33 INTO g_omb.omb41,g_omb.omb42,g_omb.omb40
    #END IF   #FUN-A60056
     IF NOT cl_null(g_omb.omb40) THEN
        #SELECT azf14 INTO g_omb.omb33
        SELECT azf20,azf201 INTO l_azf20,l_azf201
          FROM azf_file
         WHERE azf01=g_omb.omb40 AND azf02='2' AND azfacti='Y'
     END IF
     IF NOT cl_null(l_azf20) THEN LET g_omb.omb33=l_azf20 END IF     #FUN-BA0109
     IF g_aza.aza63='Y' AND cl_null(g_omb.omb331) THEN
        #LET g_omb.omb331 = g_omb.omb33                                    #FUN-BA0109
        IF NOT cl_null(l_azf201) THEN LET g_omb.omb331=l_azf201 END IF     #FUN-BA0109
     END IF
 
     LET g_omb.omblegal = g_legal #FUN-980011 add
     LET g_omb.omb44 = g_ofb.ofbplant    #FUN-9A0093
     LET g_omb.omb48 = 0   #FUN-D10101 add
     INSERT INTO omb_file VALUES(g_omb.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
     IF g_bgerr THEN
        LET g_showmsg=g_omb.omb01,"/",g_omb.omb03
        CALL s_errmsg('omb01,omb03',g_showmsg,'ins omb',SQLCA.SQLCODE,1)
     ELSE
        CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.SQLCODE,"","ins omb",1)
     END IF
        LET g_success='N' RETURN 
     END IF
END FUNCTION
#----------------------------(產生銷退折讓)----------------------------
FUNCTION s_g_ar_21(p_no,p_oma01)
   DEFINE p_no            LIKE oga_file.oga01     #單號 #No.FUN-550071 #No.FUN-680123 VARCHAR(16) 
   DEFINE p_oma01         LIKE oma_file.oma01     #單號 #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
   DEFINE l_oma01         LIKE oma_file.oma01     #單號 #No.FUN-550071 #No.FUN-680123 VARCHAR(16) 
   DEFINE l_slip          LIKE ooy_file.ooyslip
   DEFINE l_flag          LIKE type_file.chr1     #No.FUN-680123 VARCHAR(01)
   DEFINE l_qty           LIKE ogb_file.ogb12
   DEFINE li_result       LIKE type_file.num5     #No.FUN-550071 #No.FUN-680123 SMALLINT
   DEFINE l_oas05         LIKE oas_file.oas05     #FUN-8C0078 add
   DEFINE l_n             LIKE type_file.num5  
   DEFINE l_oeaa08        LIKE oeaa_file.oeaa08   #CHI-B90025 add
   DEFINE l_oea01         LIKE oea_file.oea01     #CHI-B90025 add

   LET ls_n = 0
   LET g_sql = " SELECT COUNT(*) FROM omf_file ",
               "  WHERE omf10 = '9' ",
               "    AND omf00 = '",g_omf00,"'"
   PREPARE omf10_per3 FROM g_sql
   EXECUTE omf10_per3 INTO ls_n
   LET ls_n2 = 0
   LET g_sql = " SELECT COUNT(*) FROM omf_file ",
               "  WHERE omf10! = '9' ",
               "    AND omf00 = '",g_omf00,"'"
   PREPARE omf10_per23 FROM g_sql
   EXECUTE omf10_per23 INTO ls_n2
   #FUN-C60036--add--end
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   SELECT * INTO g_oha.* FROM oha_file WHERE oha01=p_no
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oha_file WHERE oha01='",p_no,"'"
      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                  " WHERE oha01='",p_no,"'"
      
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE sel_oha_pre34 FROM g_sql
      EXECUTE sel_oha_pre34 INTO g_oha.*
   #END IF   #FUN-A60056
   LET l_oas05 = 0  #FUN-8C0078 add
 
   IF STATUS AND g_oaz.oaz92 = 'N' THEN 
   IF g_bgerr THEN
      CALL s_errmsg('oha01',p_no,'s_g_ar_21:sel oha',STATUS,1)
   ELSE
      CALL cl_err3("sel","oha_file",p_no,"",STATUS,"","s_g_ar_21:sel oha",1)
   END IF
      LET g_success = 'N'
      RETURN 
   END IF
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   SELECT COUNT(*) INTO l_n FROM rxx_file
  #    WHERE rxx00 = '02' AND rxx01 = p_no
  #      AND rxxplant = g_oha.ohaplant
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"rxx_file",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'rxx_file'), #FUN-A50102
                  " WHERE rxx00 = '03' AND rxx01 = '",p_no,"'",   #No.FUN-AB0034 02 -->03
                  "   AND rxxplant = '",g_oha.ohaplant,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102            
      PREPARE sel_rxx_pre35 FROM g_sql
      EXECUTE sel_rxx_pre35 INTO l_n
  #END IF   #FUN-A60056

 
   LET l_slip=s_get_doc_no(p_oma01)                            #MOD-9C0459 add
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = l_slip  #MOD-9C0459 add
   CALL s_g_ar_21_oma(p_oma01)
#No.FUN-AB0034 --begin
   IF cl_null(l_dbs) THEN
      SELECT occ73 INTO g_occ73 FROM occ_file
       WHERE occ01 = g_oma.oma68
   ELSE
      #LET g_sql = "SELECT occ73 FROM ",l_dbs CLIPPED,"occ_file",
      LET g_sql = "SELECT occ73 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                  " WHERE occ01 = '",g_oma.oma68,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
      PREPARE sel_occ_pre51 FROM g_sql
      EXECUTE sel_occ_pre51 INTO g_occ73
   END IF

   IF cl_null(g_occ73) THEN LET g_occ73 = 'N' END IF      #MOD-9C0288
   IF l_n >0 AND g_occ73 ='Y' THEN LET g_check='Y' ELSE LET g_check = 'N' END IF 
#No.FUN-AB0034 --end
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   LET g_sql = "SELECT * FROM ohb_file WHERE ohb01='",p_no,"'"
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"ohb_file WHERE ohb01='",p_no,"'"
     #LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102 #FUN-C60036 mark
      LET g_sql = "SELECT ohb03 FROM ",cl_get_target_table(g_plant_new,'ohb_file'),#FUN-C60036 add
                  " WHERE ohb01='",p_no,"'"
      #FUN-C60036--add--str
      IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
        #IF ls_n > 0 THEN #FUN-CB0057 mark
            LET g_sql = " SELECT omf21 FROM omf_file ",
                        "  WHERE omf00 = '",g_omf00,"'"
        #               "   AND omf09 = '",l_azp01,"'",#FUN-CB0057 mark
        #               "    AND omf11 = '",p_no,"'"#FUN-CB0057 mark
        #MOD-D60052 --mark--str
        #ElSE
        #   LET g_sql = g_sql CLIPPED ,
        #           " AND ohb03 IN ( SELECT omf12 FROM omf_file ",
        #                           " WHERE omf01 = '",g_omf01,"'",
        #                           "   AND omf00 = '",g_omf00,"'",    #minpp  add
        #                           "   AND omf02 = '",g_omf02,"'",
        #                           "   AND omf09 = '",l_azp01,"'",
        #                           "   AND omf11 = '",p_no,"' )"
        #MOD-D60052 --mark--end
        #END IF#FUN-CB0057 mark
      END IF
      #FUN-C60036--add--end
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102 
  #END IF   #FUN-A60056
   PREPARE sel_ohb_pre36 FROM g_sql
   DECLARE s_g_ar_21_c CURSOR FOR sel_ohb_pre36
 
   LET g_omb.omb03 = 0
 
  #LET l_slip=s_get_doc_no(p_oma01)     #No.FUN-550071         #MOD-9C0459 mark
  #SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = l_slip  #MOD-9C0459 mark
 
  #FOREACH s_g_ar_21_c INTO g_ohb.*#FUN-C60036 mark
   FOREACH s_g_ar_21_c INTO g_ohb03 #FUN-C60036 add
    
   #  #FUN-C60036--add--str
   #  IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' AND NOT cl_null(p_no) THEN
   #     SELECT omf12 INTO g_ohb.ohb03 FROM omf_file
   #      WHERE omf00 = g_omf00
   #              AND omf21 = g_ohb03
   #  END IF 
   #  LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
   #              "  WHERE ohb01 = '",p_no,"'",
   #              "    AND ohb03 = '",g_ohb.ohb03,"'"
   #  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
   #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   #        PREPARE sel_ohb_ohb03 FROM g_sql
   #        EXECUTE sel_ohb_ohb03 INTO g_ohb.*
   # IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
   #    IF cl_null(g_ohb.ohb01)  THEN 
   #       INITIALIZE g_ohb.* TO NULL
   #       SELECT omf11,omf12,omf13,omf917,omf14,' ',omf917,0,omf28,omf29,omf29t,' ',omf09
   #         INTO g_ohb.ohb01,g_ohb.ohb03,g_ohb.ohb04,g_ohb.ohb916,g_ohb.ohb06,g_ohb.ohb1001,g_ohb.ohb917,
   #               g_ohb.ohb12,g_ohb.ohb13,g_ohb.ohb14,g_ohb.ohb14t,g_ohb.ohb930,g_ohb.ohbplant
   #         FROM omf_file
   #        WHERE omf00 = g_omf00
   #          AND omf21 = g_ohb03
   #       IF NOT cl_null(g_ohb.ohb01) AND NOT cl_null(g_ohb.ohb03) THEN 
   #          SELECT * INTO g_ohb.* FROM ohb_file WHERE ohb01 = g_ohb.ohb01 AND ohb03 = g_ohb.ohb03
   #       END IF 
   #    ELSE
   #    SELECT omf28,omf16 INTO g_ohb.ohb13,g_ohb.ohb917 FROM omf_file 
   #     WHERE omf01 = g_omf01
   #       AND omf00 = g_omf00   #minpp  add
   #       AND omf02 = g_omf02
   #       AND omf12 = g_ohb.ohb03
   #       AND omf11 = g_ohb.ohb01
   #       AND omf04 IS NULL
   #       AND omf09 = l_azp01
   #   END IF 
   # END IF 
   # #FUN-C60036--add--end
      
      IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','s_g_ar_21:foreach ohb',STATUS,1)
      ELSE
         CALL cl_err('s_g_ar_21:foreach ohb',STATUS,1)
      END IF
         LET g_success = 'N'
         RETURN 
      END IF
      #FUN-C60036--add--str
      LET g_ohb.ohb03 = g_ohb03
      IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' AND NOT cl_null(p_no) THEN
        #SELECT omf12 INTO g_ohb.ohb03 FROM omf_file#FUN-CB0057 mark
         SELECT omf11,omf12 INTO p_no,g_ohb.ohb03 FROM omf_file#FUN-CB0057 add
          WHERE omf00 = g_omf00
                  AND omf21 = g_ohb03
      END IF
      LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
                  "  WHERE ohb01 = '",p_no,"'",
                  "    AND ohb03 = '",g_ohb.ohb03,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
            PREPARE sel_ohb_ohb03 FROM g_sql
            EXECUTE sel_ohb_ohb03 INTO g_ohb.*
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
        IF cl_null(p_no)  THEN
           INITIALIZE g_ohb.* TO NULL
           SELECT omf11,omf12,omf13,omf916,omf14,' ',omf917,0,omf28,omf29,omf29t,' ',omf09
             INTO g_ohb.ohb01,g_ohb.ohb03,g_ohb.ohb04,g_ohb.ohb916,g_ohb.ohb06,g_ohb.ohb1001,g_ohb.ohb917,
                   g_ohb.ohb12,g_ohb.ohb13,g_ohb.ohb14,g_ohb.ohb14t,g_ohb.ohb930,g_ohb.ohbplant
             FROM omf_file
            WHERE omf00 = g_omf00
              AND omf21 = g_ohb03
           IF NOT cl_null(g_ohb.ohb01) AND NOT cl_null(g_ohb.ohb03) THEN
              SELECT * INTO g_ohb.* FROM ohb_file WHERE ohb01 = g_ohb.ohb01 AND ohb03 = g_ohb.ohb03
           END IF
        ELSE
        SELECT omf28,omf917 INTO g_ohb.ohb13,g_ohb.ohb917 FROM omf_file
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00   #minpp  add
           AND omf02 = g_omf02
           AND omf12 = g_ohb.ohb03
           AND omf11 = g_ohb.ohb01
           AND omf04 IS NULL
           AND omf09 = l_azp01
       END IF
     END IF
     #FUN-C60036--add--end
      IF cl_null(g_ohb.ohb1012) THEN
         LET g_ohb.ohb1012 = 0
      END IF
      LET g_omb.omb03 = g_omb.omb03 + 1
 
      IF g_check = 'N' AND ((g_oma.oma08 = '1' AND g_omb.omb03 > g_ooz.ooz121) OR
         (g_oma.oma08 = '2' AND g_omb.omb03 > g_ooz.ooz122)) THEN
        #-------------------------------No.CHI-B90025----------------------------------start
         IF g_oma.oma00='11' THEN
            SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
             WHERE oeaa01 = g_oma.oma16
               AND oeaa02 = '1'
               AND oeaa03 = g_oma.oma165
               AND oeaa01 = oea01
         END IF
         IF g_oma.oma00='13' THEN
            SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
             WHERE oeaa01 = g_oma.oma16
               AND oeaa02 = '2'
               AND oeaa03 = g_oma.oma165
               AND oeaa01 = oea01
         END IF
         CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
         CALL s_g_ar_omc()
        #CALL s_g_ar_bu(l_oas05)  #FUN-8C0078 mod
        #-------------------------------No.CHI-B90025----------------------------------end
         LET l_oma01 = s_get_doc_no(p_oma01)
         CALL  s_auto_assign_no("axr",l_oma01,g_oma.oma02,g_oma.oma00,"oma_file","oma01",
                                "","","")
               RETURNING li_result,l_oma01
         IF (NOT li_result) THEN
         IF g_bgerr THEN
            CALL s_errmsg('','',l_oma01,'mfg-059',1)
         ELSE
            CALL cl_err(l_oma01,'mfg-059',1)
         END IF
            LET g_success = 'N'
         END IF
 
         LET l_slip=s_get_doc_no(l_oma01)                            #MOD-9C0459 add
         SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = l_slip  #MOD-9C0459 add
         CALL s_g_ar_21_oma(l_oma01)
 
         LET g_omb.omb03 = 1
      END IF
      
      LET l_qty = 0
 
      IF g_ogb.ogb1005 != '2' OR cl_null(g_ogb.ogb1005) THEN      #對于出貨和返利退回分別處理 #MOD-6C0100
         CALL s_g_ar_21_omb(l_qty,p_no) RETURNING l_flag,l_qty    #No.FUN-9C0014 Add p_no
      ELSE
         CALL s_g_ar_21_omb_1() 
      END IF 
 
      IF g_check = 'N' AND g_aza.aza26 = '2' AND g_ooy.ooy10 = 'Y' AND l_flag = 'Y' AND l_qty > 0 THEN   #MOD-630073
        #-------------------------------No.CHI-B90025----------------------------------start
         IF g_oma.oma00='11' THEN
            SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
             WHERE oeaa01 = g_oma.oma16
               AND oeaa02 = '1'
               AND oeaa03 = g_oma.oma165
               AND oeaa01 = oea01
         END IF
         IF g_oma.oma00='13' THEN
            SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
             WHERE oeaa01 = g_oma.oma16
               AND oeaa02 = '2'
               AND oeaa03 = g_oma.oma165
               AND oeaa01 = oea01
         END IF
         CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
         CALL s_g_ar_omc()
        #CALL s_g_ar_bu(l_oas05)  #FUN-8C0078 mod
        #-------------------------------No.CHI-B90025----------------------------------end
         LET l_oma01 = s_get_doc_no(p_oma01)
         CALL  s_auto_assign_no("axr",l_oma01,g_oma.oma02,g_oma.oma00,"oma_file","oma01",
                                "","","")
               RETURNING li_result,l_oma01
         IF (NOT li_result) THEN
         IF g_bgerr THEN
            CALL s_errmsg('','',l_oma01,'mfg-059',1)
         ELSE
            CALL cl_err(l_oma01,'mfg-059',1)
         END IF
            LET g_success = 'N'
         END IF
 
         LET l_slip=s_get_doc_no(l_oma01)                            #MOD-9C0459 add
         SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = l_slip  #MOD-9C0459 add
         CALL s_g_ar_21_oma(l_oma01)
 
         LET g_omb.omb03 = 1
 
      IF g_ogb.ogb1005 != '2' OR cl_null(g_ogb.ogb1005) THEN      #對于出貨和返利退回分別處理 #MOD-6C0100
         CALL s_g_ar_21_omb(l_qty,p_no) RETURNING l_flag,l_qty    #No.FUN-9C0014 Add p_no
      ELSE
         CALL s_g_ar_21_omb_1() 
      END IF 
      END IF
 
      IF g_success = 'N' THEN
         RETURN
      END IF
 
   END FOREACH

  #-------------------------------No.CHI-B90025----------------------------------start
   IF g_oma.oma00='11' THEN
      SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
       WHERE oeaa01 = g_oma.oma16
         AND oeaa02 = '1'
         AND oeaa03 = g_oma.oma165
         AND oeaa01 = oea01
   END IF
   IF g_oma.oma00='13' THEN
      SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
       WHERE oeaa01 = g_oma.oma16
         AND oeaa02 = '2'
         AND oeaa03 = g_oma.oma165
         AND oeaa01 = oea01
   END IF
   CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
   CALL s_g_ar_omc()
  #CALL s_g_ar_bu(l_oas05)  #FUN-8C0078 mod
  #-------------------------------No.CHI-B90025----------------------------------end 
   #調整尾差
   IF g_oaz92 != 'Y' AND g_aza.aza26 != '2' THEN #FUN-C60036 add 
      CALL s_up_omb(g_oma.oma01)   #MOD-850248 add
   END IF #FUN-C60036 add
 
END FUNCTION
 
FUNCTION s_g_ar_21_oma(p_oma01)
   DEFINE p_oma01   LIKE oma_file.oma01,    #No.FUN-550071 #No.FUN-680123 VARCHAR(16) 
          l_occ06   LIKE occ_file.occ06,
          l_occ07   LIKE occ_file.occ07,
          l_ool     RECORD LIKE ool_file.*
  DEFINE g_t1      LIKE ooy_file.ooyslip    #TQC-7B0097
  DEFINE l_omf07   LIKE omf_file.omf07      #FUN-C60036 add
  DEFINE l_oma24   LIKE oma_file.oma24      #FUN-C60036 add
  DEFINE l_cnt     LIKE type_file.num10     #FUN-C80066 add

   CALL s_g_ar_oma_default()
   #FUN-C60036--add-str
   IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
   LET l_omf07 = g_oha.oha23
  #SELECT DISTINCT omf03,omf01,omf02,omf05,omf06,omf07,omf22   #FUN-D50008 mark
   SELECT DISTINCT omf31,omf01,omf02,omf05,omf06,omf07,omf22   #FUN-D50008 add
     INTO g_oma.oma09,g_oma.oma10,g_oma.oma75,g_oha.oha03,g_oha.oha21,g_oha.oha23,g_oma.oma24
     FROM omf_file
    WHERE omf01 =g_omf01 AND omf02 = g_omf02
      AND omf00 = g_omf00   #minpp  add
  #   AND omf08 = 'Y' AND omf10 = '2'
  #   AND omf04 IS NULL
  #   AND omf09 = l_azp01
   SELECT gec04,gec05 INTO g_oha.oha211,g_oha.oha212 FROM gec_file 
    WHERE gec01 = g_oha.oha21 AND gec011= '2'
   IF cl_null(g_oha.oha23) THEN LET g_oha.oha23 = l_omf07 END IF 
   END IF 
   #FUN-C60036--add--end
   LET g_oma.oma01 = p_oma01
  #LET g_oma.oma70    = '2'  #Add No.FUN-AC0025    #FUN-C80066 add

   #FUN-C80066 add begin---
   IF g_oha.oha94 = 'Y' THEN    
      LET g_oma.oma70 = '3'     
      LET g_mTax = TRUE         
   ELSE 
      LET g_oma.oma70    = '2'  
      LET g_mTax = FALSE        
   END IF                       

   IF g_oma.oma70 = '2' THEN
     SELECT COUNT(*) INTO l_cnt FROM ogk_file WHERE ogk01 = g_oma.oma16
     IF l_cnt > 0 THEN
        LET g_mTax = TRUE
     END IF
   END IF
   #FUN-C80066 add end-----

   LET g_oma.oma03 = g_oha.oha03                 #銷退單中的客戶
   IF cl_null(g_oha.oha1001) OR g_oha.oha1001 = '' THEN   #如果銷退單中的收款客>                                                    
      IF cl_null(l_dbs) THEN
         SELECT occ07 INTO g_oma.oma68
           FROM occ_file
          WHERE occ01=g_oha.oha03
      ELSE
         LET g_sql = "SELECT occ07 ",
                     #"  FROM ",l_dbs CLIPPED,"occ_file",
                     "  FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                     " WHERE occ01='",g_oha.oha03,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102            
         PREPARE sel_occ_pre37 FROM g_sql
         EXECUTE sel_occ_pre37 INTO g_oma.oma68
      END IF
   ELSE                                                                                                                             
      LET g_oma.oma68=g_oha.oha1001              #銷退單中的收款客戶                                                                
   END IF                                                                                                                           
   IF NOT cl_null(g_oma.oma68) THEN                                                                                                 
      SELECT occ02 INTO g_oma.oma69
        FROM occ_file
       WHERE occ01=g_oma.oma68                   #再抓取收款客戶簡稱
      IF cl_null(l_dbs) THEN
         SELECT occ02 INTO g_oma.oma69
           FROM occ_file
          WHERE occ01=g_oma.oma68
      ELSE
         #LET g_sql = "SELECT occ02 FROM ",l_dbs CLIPPED,"occ_file ",
         LET g_sql = "SELECT occ02 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                     " WHERE occ01='",g_oma.oma68,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
         PREPARE sel_occ_pre38 FROM g_sql
         EXECUTE sel_occ_pre38 INTO g_oma.oma69
      END IF
   END IF
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   SELECT occ02,occ11,occ18,occ231,occ37
  #     INTO g_oma.oma032,g_oma.oma042,g_oma.oma043,g_oma.oma044,g_oma.oma40
  #     FROM occ_file
  #    WHERE occ01 = g_oma.oma03
  #      AND occacti = 'Y'
  #   SELECT oga05 INTO g_oma.oma05 FROM oga_file
  #    WHERE oga01 = (SELECT UNIQUE ohb31 FROM ohb_file WHERE ohb01 = g_oha.oha01)
  #ELSE
  #FUN-A60056--mark--end
      LET g_sql = "SELECT occ02,occ11,occ18,occ231,occ37",
                  #"  FROM ",l_dbs CLIPPED,"occ_file",
                  "  FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                 #" WHERE occ01 = '",g_oma.oma03,"' AND occacti = 'Y'"   #MOD-CA0047 mark
                  " WHERE occ01 = '",g_oma.oma03,"' AND occacti <> 'N'"  #MOD-CA0047
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
      PREPARE sel_occ_pre39 FROM g_sql
      EXECUTE sel_occ_pre39 INTO g_oma.oma032,g_oma.oma042,g_oma.oma043,g_oma.oma044,g_oma.oma40

      #LET g_sql = "SELECT oga05 FROM ",l_dbs CLIPPED,"oga_file",
      #            " WHERE oga01 = (SELECT UNIQUE ohb31 FROM ",l_dbs CLIPPED,"ohb_file",
      LET g_sql = "SELECT oga05 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                  " WHERE oga01 = (SELECT UNIQUE ohb31 FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                  "                 WHERE ohb01 = '",g_oha.oha01,"')"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102               
      PREPARE sel_oga_pre40 FROM g_sql
      EXECUTE sel_oga_pre40 INTO g_oma.oma05
  #END IF   #FUN-A60056
  #-MOD-AA0002-add-
   IF g_oma.oma03 = 'MISC' THEN
      LET g_oma.oma032 = g_oha.oha032
   END IF
   IF g_oma.oma68 = 'MISC' THEN
      LET g_oma.oma69 = g_oha.oha032
   END IF
  #-MOD-AA0002-end-
 
   LET g_oma.oma04 = g_oma.oma03
   LET g_oma.oma08 = g_oha.oha08
   #No.MOD-D60122  --Begin
   IF cl_null(g_oma.oma08) THEN
   	  IF g_oha.oha23 = g_aza.aza17 THEN
   	     LET g_oma.oma08 = '1'
      ELSE
   	     LET g_oma.oma08 = '2'
   	  END IF
   END IF
   #No.MOD-D60122  --End
   LET g_oma.oma14 = g_oha.oha14 LET g_oma.oma15 = g_oha.oha15
   LET g_oma.oma21 = g_oha.oha21
   LET g_oma.oma211= g_oha.oha211 LET g_oma.oma212= g_oha.oha212
   LET g_oma.oma213= g_oha.oha213 LET g_oma.oma23 = g_oha.oha23
 
   IF g_oma.oma08='1' THEN 
      LET exT=g_ooz.ooz17 
   ELSE 
      LET exT=g_ooz.ooz63 
   END IF
 
   IF cl_null(l_dbs) THEN
      SELECT gec08,gec06 INTO g_oma.oma171,g_oma.oma172 FROM gec_file
       WHERE gec01 = g_oma.oma21 AND gec011 = '2'
   ELSE
      #LET g_sql = "SELECT gec08,gec06 FROM ",l_dbs CLIPPED,"gec_file",
      LET g_sql = "SELECT gec08,gec06 FROM ",cl_get_target_table(g_plant_new,'gec_file'), #FUN-A50102
                  " WHERE gec01 = '",g_oma.oma21,"' AND gec011 = '2'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
      PREPARE sel_gec_pre41 FROM g_sql
      EXECUTE sel_gec_pre41 INTO g_oma.oma171,g_oma.oma172
   END IF
 
   LET l_oma24 = g_oma.oma24 #FUN-C60036--add-str
   IF g_oma.oma23=g_aza.aza17 THEN
      LET g_oma.oma24 = 1 LET g_oma.oma58 = 1
   ELSE
      SELECT oma24,oma58 INTO g_oma.oma24,g_oma.oma58 #取原出貨AR立帳匯率
        FROM oma_file
       WHERE oma16=g_oha.oha16
      IF STATUS THEN
         #no.5504找不到原出貨單匯率則default銷退單上的匯率
         IF NOT cl_null(g_oha.oha24) THEN
            LET g_oma.oma24 = g_oha.oha24
            LET g_oma.oma58 = g_oha.oha24
         ELSE  #no.5504(end)
            CALL s_curr3(g_oma.oma23,g_oma.oma02,exT) RETURNING g_oma.oma24
            CALL s_curr3(g_oma.oma23,g_oma.oma09,exT) RETURNING g_oma.oma58
            IF cl_null(g_oma.oma24) THEN LET g_oma.oma24=1 END IF
            IF cl_null(g_oma.oma58) THEN
               #FUN-C60036--add--str
               IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
                  LET g_oma.oma58=l_oma24
               ELSE 
               #FUN-C60036--ad--end
                  LET g_oma.oma58=1 
               END IF
            END IF
         END IF
      END IF
   END IF
   #FUN-C60036--add--str
   IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
      LET g_oma.oma24 = l_oma24
      LET g_oma.oma58 = l_oma24
   END IF
   #FUN-C60036--add--end
   LET g_oma.oma25 = g_oha.oha25
   LET g_oma.oma26 = g_oha.oha26
   LET g_oma.oma13=g_way
 
   IF cl_null(g_oma.oma13) THEN   
     #SELECT ooz08 INTO g_oma.oma13 FROM ooz_file WHERE ooz00='0' #MOD-B10040 mark
     #-MOD-B10040-add-
      SELECT occ67 INTO g_oma.oma13 FROM occ_file
        WHERE occ01 = g_oma.oma03
      IF cl_null(g_oma.oma13) THEN 
         LET g_oma.oma13 = g_ooz.ooz08
      END IF
     #-MOD-B10040-emd-
   END IF
 
   SELECT * INTO l_ool.* FROM ool_file WHERE ool01=g_oma.oma13
   LET g_oma.oma34 = g_oha.oha09   #MOD-760008
   IF g_ooy.ooydmy1='Y' THEN
      LET g_oma.oma18=l_ool.ool26
      IF g_aza.aza63 = 'Y' THEN
         LET g_oma.oma181=l_ool.ool261
      END IF
   ELSE
      #IF g_oma.oma00='21' THEN   #FUN-B00158
      IF g_oma.oma00='21' OR g_oma.oma00 = '28' THEN   #FUN-B10058
         IF g_oma.oma34 ='5' THEN
            LET g_oma.oma18=l_ool.ool47
            IF g_aza.aza63 = 'Y' THEN
               LET g_oma.oma181=l_ool.ool471
            END IF
         ELSE
            LET g_oma.oma18=l_ool.ool42
            IF g_aza.aza63 = 'Y' THEN
               LET g_oma.oma181=l_ool.ool421
            END IF
         END IF
      END IF
 
      IF g_oma.oma00='22' THEN
         LET g_oma.oma18=l_ool.ool25
         IF g_aza.aza63 = 'Y' THEN
            LET g_oma.oma181=l_ool.ool251
         END IF
      END IF
 
      IF g_oma.oma00='25' THEN
         LET g_oma.oma18=l_ool.ool51
         IF g_aza.aza63 = 'Y' THEN
            LET g_oma.oma181=l_ool.ool511
         END IF
      END IF
   END IF
 
   LET g_oma.oma66 = g_oha.ohaplant      #FUN-960140 add 090824
   LET g_oma.omalegal = g_oha.ohalegal  #FUN-960140
 
  #FUN-A60056--mod--str--
  #SELECT oga32 INTO g_oma.oma32 FROM oga_file
  #  WHERE oga01 = g_oha.oha16
   LET g_sql = "SELECT oga32 FROM ",cl_get_target_table(g_plant_new,'oga_file'),
               " WHERE oga01 = '",g_oha.oha16,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE sel_oga32 FROM g_sql
   EXECUTE sel_oga32 INTO g_oma.oma32
  #FUN-A60056--mod--end
   IF cl_null(g_oma.oma32) THEN
      IF cl_null(l_dbs) THEN
         SELECT occ45 INTO g_oma.oma32 FROM occ_file
          WHERE occ01 = g_oha.oha03
      ELSE
         #LET g_sql = "SELECT occ45 FROM ",l_dbs CLIPPED,"occ_file",
         LET g_sql = "SELECT occ45 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                     " WHERE occ01 = '",g_oha.oha03,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102               
         PREPARE sel_occ_pre42 FROM g_sql
         EXECUTE sel_occ_pre42 INTO g_oma.oma32
      END IF
   END IF
 
   LET g_oma.oma11 = g_oma.oma02 LET g_oma.oma12  =g_oma.oma02   #MOD-580158
   LET g_oma.oma65 = '1' #FUN-5A0124
   LET g_oma.oma60 = g_oma.oma24   #MOD-5B0140
   IF g_source IS NULL OR cl_null(g_source) THEN                                                                                                    
      LET g_oma.oma66=g_plant                                                                                                       
   ELSE                                                                                                                             
      LET g_oma.oma66 = g_source  #FUN-630043
   END IF   #MOD-8C0100 add  
   IF g_aaz.aaz90='Y' THEN
     #FUN-A60056--mark--str--
     #IF cl_null(l_dbs) THEN
     #   LET g_sql = "SELECT ohb930 FROM ohb_file",
     #               " WHERE ohb01='",g_oha.oha01,"'",
     #               "   AND ohb930 IS NOT NULL",
     #               " ORDER BY ohb03"
     #ELSE
     #FUN-A60056--mark--end
         #LET g_sql = "SELECT ohb930 FROM ",l_dbs CLIPPED,"ohb_file",
         LET g_sql = "SELECT ohb930 FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                     " WHERE ohb01='",g_oha.oha01,"'",
                     "   AND ohb930 IS NOT NULL",
                     " ORDER BY ohb03"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
     #END IF    #FUN-A60056
      PREPARE sel_ohb_pre43 FROM g_sql
      DECLARE s_g_ar_21_oma_c CURSOR FOR sel_ohb_pre43
      OPEN s_g_ar_21_oma_c
      FETCH s_g_ar_21_oma_c INTO g_oma.oma930
      CLOSE s_g_ar_21_oma_c
   END IF
   IF cl_null(g_oma.oma51) THEN
      LET g_oma.oma51 = 0
   END IF
   IF cl_null(g_oma.oma51f) THEN
      LET g_oma.oma51f = 0
   END IF
   LET g_t1 = g_oma.oma01[1,g_doc_len] 
   SELECT ooyapr INTO g_oma.omamksg FROM ooy_file 
     WHERE ooyslip = g_t1
   LET g_oma.oma64 = '0'          #No.TQC-7B0144 
   LET g_oma.oma99 = g_oha.oha99  #MOD-8C0001
   LET g_oma.oma161 = 0 #MOD-980026                                                                                                 
   LET g_oma.oma162 = 100 #MOD-980026                                                                                               
   LET g_oma.oma163 = 0 #MOD-980026   
   LET g_oma.omalegal = g_legal #FUN-980011 add
   LET g_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
#FUN-AC0027 --begin--
   LET g_oma.oma74 = g_oha.oha57  #Add No.FUN-AC0025
   IF cl_null(g_oma.oma74) THEN
      LET g_oma.oma74 = '1'
   END IF
   IF cl_null(g_oma.oma73) THEN
      LET g_oma.oma73 = 0
   END IF
   IF cl_null(g_oma.oma73f) THEN
      LET g_oma.oma73f = 0
   END IF
#FUN-AC0027 --end--
   IF g_aza.aza26 = '2' AND g_oaz92 = 'Y' THEN #FUN-CB0057 add
      LET g_oma.oma76 = g_omf00 #FUN-CB0057 add
   END IF #FUN-CB0057 add

   INSERT INTO oma_file VALUES(g_oma.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
   IF g_bgerr THEN
      CALL s_errmsg('','','ins oma',SQLCA.SQLCODE,1)
   ELSE
      CALL cl_err3("ins","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","ins oma",1)
   END IF
      LET g_success='N'
      RETURN
   END IF
 
   IF g_begin IS NULL THEN 
      LET g_begin = g_oma.oma01
   END IF
 
END FUNCTION
 
FUNCTION s_g_ar_21_omb(p_qty,p_no)              #No.FUN-9C0014 Add p_no
   DEFINE p_no       LIKE oea_file.oea01        #No.FUN-9C0014 Add
   DEFINE l_omb18t   LIKE omb_file.omb18t
   DEFINE l_amt      LIKE omb_file.omb18t
   DEFINE l_qty      LIKE omb_file.omb12        #FUN-4C0013
   DEFINE p_flag     LIKE type_file.chr1        #No.FUN-680123 VARCHAR(01)
   DEFINE p_qty      LIKE omb_file.omb12
   DEFINE l_qty2     LIKE omb_file.omb12
   DEFINE l_n        LIKE type_file.num5  
   DEFINE l_azf20    LIKE azf_file.azf20        #FUN-BA0109
   DEFINE l_azf201   LIKE azf_file.azf201       #FUN-BA0109
   DEFINE l_omf10    LIKE omf_file.omf10        #No.MOD-CC0087
   DEFINE l_omf19t   LIKE omf_file.omf19t       #No.MOD-CC0087
   
   LET g_omb.omb33 = NULL            #MOD-CA0083
   LET g_omb.omb331 = NULL           #MOD-CA0083
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN
  #   SELECT COUNT(*) INTO l_n FROM rxx_file
  #    WHERE rxx00 = '02' AND rxx01 = p_no
  #      AND rxxplant = g_oha.ohaplant
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"rxx_file",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'rxx_file'), #FUN-A50102
                  " WHERE rxx00 = '03' AND rxx01 = '",p_no,"'",   #No.FUN-AB0034 02 -->03
                  "   AND rxxplant = '",g_oha.ohaplant,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
      PREPARE sel_rxx_pre44 FROM g_sql
      EXECUTE sel_rxx_pre44 INTO l_n
  #END IF   #FUN-A60056
   IF l_n >0 THEN LET g_check='Y' ELSE LET g_check = 'N' END IF 
     LET g_omb.omb01 = g_oma.oma01
     LET g_omb.omb31 = g_ohb.ohb01
     LET g_omb.omb32 = g_ohb.ohb03
     LET g_omb.omb04 = g_ohb.ohb04
     LET g_omb.omb05 = g_ohb.ohb916   #FUN-560070
     LET g_omb.omb06 = g_ohb.ohb06
     IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 = '2' THEN  
     LET g_omb.omb12 = g_ogb.ogb917
     ELSE
     LET g_omb.omb12 = g_ohb.ohb917-g_ohb.ohb60   #FUN-560070
     END IF 
     IF g_check = 'N' AND g_aza.aza26 = '2' AND g_ooy.ooy10 = 'Y' AND p_qty > 0 THEN    #MOD-630073
        LET g_omb.omb12 = p_qty
     END IF

     IF cl_null(g_ohb.ohb1003) THEN         #ohb1003 折扣率
        LET g_omb.omb13 = g_ohb.ohb13       #omb13   原幣單價
     ELSE 
        LET g_omb.omb13 = g_ohb.ohb13*(g_ohb.ohb1003/100)
     END IF

     LET g_omb.omb14 = g_ohb.ohb14
     LET g_omb.omb14t= g_ohb.ohb14t
     CALL cl_digcut(g_omb.omb13,t_azi03) RETURNING g_omb.omb13   #MOD-760078

     #FUN-C80066 mark begin---
     #IF g_oma.oma213 = 'N'
     #   THEN IF g_omb.omb12 > 0 THEN
     #           LET g_omb.omb14 =g_omb.omb12*g_omb.omb13
     #        END IF
     #        CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
     #        LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)
     #        CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t   #MOD-760078
     #   ELSE IF g_omb.omb12 > 0 THEN
     #           LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
     #        END IF
     #        CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t   #MOD-760078
     #        LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100)
     #        CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
     #END IF
     #FUN-C80066  mark end---

     #Add No:FUN-AC0025
     LET g_omb.omb45 = g_ohb.ohb70    #商户编号
     #by elva mark begin
     #    IF g_oma.oma74 ='2' THEN
     #       LET g_omb.omb14 = g_omb.omb14t  #omb16,omb18不用再复制，根据后面的计算公式，含税和未税值是一样的
     #    END IF
     #by elva mark end
     #FUN-C60036--add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
        #No.MOD-CC0087  --Begin
        SELECT omf10,omf19t INTO l_omf10,l_omf19t FROM omf_file
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00   #minpp  add
           AND omf02 = g_omf02
           AND omf21 = g_ohb03
        IF l_omf10 = '2' OR l_omf19t < 0 THEN
        #No.MOD-CC0087  --End
           SELECT abs(omf28),abs(omf917),abs(omf29),abs(omf29t) INTO 
               g_omb.omb13,g_omb.omb12,g_omb.omb14,g_omb.omb14t FROM omf_file 
            WHERE omf01 = g_omf01
              AND omf00 = g_omf00   #minpp  add
              AND omf02 = g_omf02
              AND omf21 = g_ohb03
            # AND omf12 = g_ohb.ohb03
            # AND omf11 = g_ohb.ohb01
            # AND omf04 IS NULL
            # AND omf09 = l_azp01
        #No.MOD-CC0087  --Begin
        ELSE
           SELECT abs(omf28),abs(omf917)*-1,abs(omf29)*-1,abs(omf29t)*-1 INTO
               g_omb.omb13,g_omb.omb12,g_omb.omb14,g_omb.omb14t FROM omf_file
            WHERE omf01 = g_omf01
              AND omf00 = g_omf00   #minpp  add
              AND omf02 = g_omf02
              AND omf21 = g_ohb03
        END IF
        #No.MOD-CC0087  --End
     END IF 
     #FUN-C60036--add--end
     #End Add No:FUN-AC0025
     LET g_omb.omb15 =g_omb.omb13 *g_oma.oma24
     LET g_omb.omb16 =g_omb.omb14 *g_oma.oma24
     LET g_omb.omb16t=g_omb.omb14t*g_oma.oma24
     LET g_omb.omb17 =g_omb.omb13 *g_oma.oma58
     LET g_omb.omb18 =g_omb.omb14 *g_oma.oma58
     LET g_omb.omb18t=g_omb.omb14t*g_oma.oma58

     CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15   #MOD-760078
     CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16   #MOD-760078
     CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t  #MOD-760078
     CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17   #MOD-760078
     CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18   #MOD-760078
     CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t  #MOD-760078
     #超過發票限額則拆數量
     LET p_flag = 'N'
     LET p_qty = 0
     IF g_check = 'N' AND g_aza.aza26 = '2' AND g_ooy.ooy10 = 'Y' AND g_oaz.oaz92 != 'Y' THEN   #MOD-630073#TQC-D10093 add oaz92
        SELECT SUM(omb18t) INTO l_omb18t FROM omb_file WHERE omb01=g_oma.oma01
        IF cl_null(l_omb18t) THEN LET l_omb18t = 0 END IF
        IF l_omb18t + g_omb.omb18t > g_ooy.ooy11 THEN
           LET p_flag = 'Y'
           LET l_amt = g_ooy.ooy11 - l_omb18t
           IF g_omb.omb12 > 1 THEN
              LET l_qty = l_amt / (g_omb.omb18t / g_omb.omb12)
              LET p_qty = g_omb.omb12 - l_qty
              LET g_omb.omb12 = l_qty
           ELSE  
              LET l_qty2 = l_amt / (g_omb.omb18t / g_omb.omb12) - 0.001
              LET p_qty = g_omb.omb12 - l_qty2
              LET g_omb.omb12 = l_qty2
           END IF
           IF g_oma.oma213 = 'N' THEN
              IF g_omb.omb12 != 0 THEN
                 LET g_omb.omb14 =g_omb.omb12*g_omb.omb13
              END IF
              CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
              LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)
              CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
           ELSE 
              IF g_omb.omb12 != 0 THEN
                 LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
              END IF
              CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   #MOD-760078
              LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100)
              CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
           END IF
           #Add No:FUN-AC0025
#by elva mark begin
#          IF g_oma.oma74 ='2' THEN
#             LET g_omb.omb14 = g_omb.omb14t  #omb16,omb18不用再复制，根据后面的计算公式，含税和未税值是一样的
#          END IF
#by elva mark end
           #End Add No:FUN-AC0025
           LET g_omb.omb15 =g_omb.omb13 *g_oma.oma24
           LET g_omb.omb16 =g_omb.omb14 *g_oma.oma24
           LET g_omb.omb16t=g_omb.omb14t*g_oma.oma24
           LET g_omb.omb17 =g_omb.omb13 *g_oma.oma58
           LET g_omb.omb18 =g_omb.omb14 *g_oma.oma58
           LET g_omb.omb18t=g_omb.omb14t*g_oma.oma58
           CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15   #MOD-760078
           CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16   #MOD-760078
           CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t  #MOD-760078
           CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17   #MOD-760078
           CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18   #MOD-760078
           CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t  #MOD-760078
        END IF
     END IF
     MESSAGE g_omb.omb03,' ',g_omb.omb04,' ',g_omb.omb12
     LET g_omb.omb36 = g_oma.oma24                  #A060
     LET g_omb.omb37 = g_omb.omb16t - g_omb.omb35   #A060
     LET g_omb.omb34 = 0 LET g_omb.omb35 = 0 
     LET g_omb.omb00 = g_oma.oma00   #MOD-6A0102
     LET g_omb.omb38 = '3'                    #銷退單                                                                               
     IF cl_null(g_omb.omb31) THEN LET g_omb.omb38 = '99' END IF 
     LET g_omb.omb39 = g_ohb.ohb1004          #搭贈                                                                                 
     IF g_omb.omb39 = 'Y' THEN                #如為搭贈                                                                             
        LET g_omb.omb14 = 0                                                                                                         
        LET g_omb.omb14t= 0                                                                                                         
        LET g_omb.omb16 = 0                                                                                                         
        LET g_omb.omb16t= 0                                                                                                         
        LET g_omb.omb18 = 0                                                                                                         
        LET g_omb.omb18t= 0                                                                                                         
     END IF                                                                                                                         
     LET g_omb.omb930=g_ohb.ohb930 #FUN-680001
    #FUN-A60056--mark--str--
    #IF cl_null(l_dbs) THEN #No.FUN-9C0014 Add
    #SELECT oeb41,oeb42 INTO g_omb.omb41,g_omb.omb42
    #  FROM oeb_file 
    # WHERE oeb01 = g_ohb.ohb33 AND oeb03 = g_ohb.ohb34
    #LET g_omb.omb40 = g_ohb.ohb50
    #IF cl_null(g_omb.omb40) THEN
    #  SELECT oeb1001 INTO g_omb.omb40
    #    FROM oeb_file 
    #  WHERE oeb01 = g_ohb.ohb33 AND oeb03 = g_ohb.ohb34
    #  END IF            #NO.FUN-930141
    #IF NOT cl_null(g_omb.omb40) THEN
    #   SELECT azf14 INTO g_omb.omb33
    #     FROM azf_file
    #    WHERE azf01=g_omb.omb40 AND azf02='2' AND azfacti='Y' 
    #END IF
    #ELSE
    #FUN-A60056--mark--end
        LET g_sql = "SELECT oeb41,oeb42 ",
                    #"  FROM ",l_dbs CLIPPED,"oeb_file",
                    "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                    " WHERE oeb01 = '",g_ohb.ohb33,"' AND oeb03 = '",g_ohb.ohb34,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102              
        PREPARE sel_oeb_pre45 FROM g_sql
        EXECUTE sel_oeb_pre45 INTO g_omb.omb41,g_omb.omb42

        LET g_omb.omb40 = g_ohb.ohb50
        IF cl_null(g_omb.omb40) THEN
           #LET g_sql = "SELECT oeb1001 FROM ",l_dbs CLIPPED,"oeb_file",
           LET g_sql = "SELECT oeb1001 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                       " WHERE oeb01 = '",g_ohb.ohb33,"' AND oeb03 = '",g_ohb.ohb34,"'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102              
           PREPARE sel_oeb_pre46 FROM g_sql
           EXECUTE sel_oeb_pre46 INTO g_omb.omb40
        END IF
        IF NOT cl_null(g_omb.omb40) THEN
           #LET g_sql = "SELECT azf14 ",         #FUN-BA0109
           LET g_sql = "SELECT azf20,azf201 ",   #FUN-BA0109
                       #"  FROM ",l_dbs CLIPPED,"azf_file",
                       "  FROM ",cl_get_target_table(g_plant_new,'azf_file'), #FUN-A50102
                       " WHERE azf01='",g_omb.omb40,"' AND azf02='2' AND azfacti='Y'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
           PREPARE sel_azf_pre47 FROM g_sql
           #EXECUTE sel_azf_pre47 INTO g_omb.omb33         #FUN-BA0109
           EXECUTE sel_azf_pre47 INTO l_azf20,l_azf201     #FUN-BA0109
        END IF
    #END IF  #FUN-A60056 

     IF NOT cl_null(l_azf20) THEN LET g_omb.omb33=l_azf20 END IF     #FUN-BA0109
     IF g_aza.aza63='Y' AND cl_null(g_omb.omb331) THEN
        #LET g_omb.omb331 = g_omb.omb33                                    #FUN-BA0109
        IF NOT cl_null(l_azf201) THEN LET g_omb.omb331=l_azf201 END IF     #FUN-BA0109
     END IF
     #Add No:FUN-AC0025
     IF g_oma.oma74='2' THEN
        SELECT ool36 INTO g_omb.omb33 FROM ool_file
         WHERE ool01=g_oma.oma13
        IF g_aza.aza63 = 'Y' THEN
           SELECT ool361 INTO g_omb.omb331 FROM ool_file
            WHERE ool01=g_oma.oma13
        END IF
     END IF
     #End Add No:FUN-AC0025
     
  
 
     LET g_omb.omblegal = g_legal #FUN-980011 add
     LET g_omb.omb44 = g_ohb.ohbplant    #FUN-9A0093 
     #FUN-C60036--add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
        SELECT abs(omf19),abs(omf19t) INTO g_omb.omb16,g_omb.omb16t
          FROM omf_file
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00
           AND omf02 = g_omf02
           AND omf21 = g_ohb03
         # AND omf12 = g_ohb.ohb03
         # AND omf11 = g_ohb.ohb01
         # AND omf04 IS NULL
         # AND omf09 = l_azp01
        #No.MOD-CC0087  --Begin
        IF cl_null(l_omf10) THEN
           SELECT omf10,omf19t INTO l_omf10,l_omf19t FROM omf_file
            WHERE omf01 = g_omf01
              AND omf00 = g_omf00   #minpp  add
              AND omf02 = g_omf02
              AND omf21 = g_ohb03
        END IF
        IF l_omf10 = '2' OR l_omf19t < 0 THEN
        ELSE
           LET g_omb.omb16 = g_omb.omb16 * - 1
           LET g_omb.omb16t= g_omb.omb16t* - 1
        END IF
        #No.MOD-CC0087  --End
        LET g_omb.omb18 = g_omb.omb16
        LET g_omb.omb18t = g_omb.omb16t
     END IF
     CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16   
     CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t    
     CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18   
     CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t 
     IF g_omb.omb32 = 0 THEN LET g_omb.omb32 = '' END IF
     #FUN-C60036--add--end
     LET g_omb.omb48 = 0   #FUN-D10101 add
     INSERT INTO omb_file VALUES(g_omb.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
     IF g_bgerr THEN
        LET g_showmsg=g_omb.omb01,"/",g_omb.omb03
        CALL s_errmsg('omb01,omb03',g_showmsg,'ins omb',SQLCA.SQLCODE,1)
     ELSE
        CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.sqlcode,"","ins omb",1)
     END IF
        LET g_success='N' RETURN p_flag,p_qty
     ELSE
        #FUN-C60036--add--str
        IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
           UPDATE omf_file SET omf04 = g_oma.oma01 
            WHERE omf01 = g_omf01
             AND omf00 = g_omf00   #minpp  add
             AND omf02 = g_omf02
             AND omf21 = g_ohb03
           # AND omf11 = g_oha.oha01
           # AND omf12 = g_ohb.ohb03
           IF STATUS OR SQLCA.SQLCODE THEN
              LET g_showmsg=g_oma.oma10,"/",g_oma.oma75                                             
              CALL s_errmsg('omf01,omf02',g_showmsg,"upd omf",SQLCA.SQLCODE,1)                       
              LET g_success='N'
           END IF
        END IF 
        #FUN-C60036--add--end
     END IF

    RETURN p_flag,p_qty
END FUNCTION
 
#----------------------------------------No.CHI-B90025------------------start-mark
#----------------------------(單身更新單頭)----------------------------
#FUNCTION s_g_ar_bu(p_oas05)    #FUN-8C0078 
#  DEFINE p_oas05  LIKE oas_file.oas05    #FUN-8C0078
#  DEFINE l_oma54  LIKE oma_file.oma54    #CHI-920086 add
#  DEFINE l_oma54t LIKE oma_file.oma54t   #CHI-920086 add
#  DEFINE l_oma56  LIKE oma_file.oma56    #CHI-920086 add
#  DEFINE l_oma56t LIKE oma_file.oma56t   #CHI-920086 add
#  DEFINE l_oeb47  LIKE oeb_file.oeb47    #FUN-960140 090910 add
#  DEFINE l_rxx04  LIKE rxx_file.rxx04  
#  DEFINE l_occ73  LIKE occ_file.occ73
#  DEFINE l_flag   LIKE type_file.chr1    #No.FUN-9C0014 Add
#  DEFINE l_sumogb14  LIKE ogb_file.ogb14   #CHI-A50040     #出貨總金額(未稅)
#  DEFINE l_sumogb14t LIKE ogb_file.ogb14t  #CHI-A50040     #出貨總金額(含稅)
#  DEFINE l_11_oma54  LIKE oma_file.oma54   #CHI-A50040     #訂金金額(未稅)
#  DEFINE l_11_oma54t LIKE oma_file.oma54t  #CHI-A50040     #訂金金額(含稅)
#  DEFINE l_12_oma52  LIKE oma_file.oma52   #TQC-A60027     #分批訂金金額(未稅)
#  DEFINE l_12_oma54  LIKE oma_file.oma54   #CHI-A50040     #分批出貨金額(未稅)
#  DEFINE l_12_oma54t LIKE oma_file.oma54t  #CHI-A50040     #分批出貨金額(含稅)
#  DEFINE l_13_oma54  LIKE oma_file.oma54   #CHI-A50040     #尾款金額(未稅)
#  DEFINE l_13_oma54t LIKE oma_file.oma54t  #CHI-A50040     #尾款金額(含稅)
#  DEFINE l_oeb917    LIKE oeb_file.oeb917  #CHI-A50040
#  DEFINE l_ogb917    LIKE ogb_file.ogb917  #CHI-A50040
#  DEFINE l_sumogb917 LIKE ogb_file.ogb917  #MOD-B50230     #出貨總數量
#  DEFINE l_flag2     LIKE type_file.chr1   #CHI-A50040 
#  DEFINE l_sumomb16  LIKE omb_file.omb16   #CHI-A50040     #出貨總金額(未稅)
#  DEFINE l_sumomb16t LIKE omb_file.omb16t  #CHI-A50040     #出貨總金額(含稅)
#  DEFINE l_11_oma56  LIKE oma_file.oma56   #CHI-A50040     #訂金金額(未稅)
#  DEFINE l_11_oma56t LIKE oma_file.oma56t  #CHI-A50040     #訂金金額(含稅)
#  DEFINE l_12_oma53  LIKE oma_file.oma53   #TQC-A60027     #分批訂金金額(未稅)
#  DEFINE l_12_oma56  LIKE oma_file.oma56   #CHI-A50040     #分批出貨金額(未稅)
#  DEFINE l_12_oma56t LIKE oma_file.oma56t  #CHI-A50040     #分批出貨金額(含稅)
#  DEFINE l_13_oma56  LIKE oma_file.oma56   #CHI-A50040     #尾款金額(未稅)
#  DEFINE l_13_oma56t LIKE oma_file.oma56t  #CHI-A50040     #尾款金額(含稅)
#  DEFINE l_sumomb18  LIKE omb_file.omb18   #CHI-A50040     #發票出貨總金額(未稅)
#  DEFINE l_sumomb18t LIKE omb_file.omb18t  #CHI-A50040     #發票出貨總金額(含稅)
#  DEFINE l_11_oma59  LIKE oma_file.oma59   #CHI-A50040     #發票訂金金額(未稅)
#  DEFINE l_11_oma59t LIKE oma_file.oma59t  #CHI-A50040     #發票訂金金額(含稅)
#  DEFINE l_12_oma59  LIKE oma_file.oma59   #CHI-A50040     #發票分批出貨金額(未稅)
#  DEFINE l_12_oma59t LIKE oma_file.oma59t  #CHI-A50040     #發票分批出貨金額(含稅)
#  DEFINE l_13_oma59  LIKE oma_file.oma59   #CHI-A50040     #發票尾款金額(未稅)
#  DEFINE l_13_oma59t LIKE oma_file.oma59t  #CHI-A50040     #發票尾款金額(含稅)
#  DEFINE l_oea61     LIKE oea_file.oea61    #No:FUN-A50103
#  DEFINE l_oea1008   LIKE oea_file.oea1008  #No:FUN-A50103
#  DEFINE l_oea261    LIKE oea_file.oea261   #No:FUN-A50103
#  DEFINE l_oea262    LIKE oea_file.oea262   #No:FUN-A50103
#  DEFINE l_oea263    LIKE oea_file.oea263   #No:FUN-A50103
#  DEFINE l_cnt       LIKE type_file.num5   #MOD-A70194

#  #-----No:FUN-A50103-----
#  IF g_oma.oma00='13' THEN
#     SELECT oea61,oea1008,oea261,oea262,oea263
#       INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
#      FROM oea_file
#     WHERE oea01 = g_oma.oma16
#  END IF

#  #IF g_oma.oma00 = '12' THEN   #FUN-B10058
#  IF g_oma.oma00 = '12' OR g_oma.oma00 = '19' THEN   #FUN-B10058
#     SELECT oea61,oea1008,oea261,oea262,oea263
#       INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
#      FROM oea_file
#     WHERE oea01 = g_ogb.ogb31
#  END IF
#  #-----No:FUN-A50103 END-----

#  #-----No:CHI-A70015-----
#  IF STATUS THEN     #找不到訂單，表無訂單出貨
#     LET l_oea61 = 100
#     LET l_oea1008 = 100
#     LET l_oea261 = 0
#     LET l_oea262 = 100
#     LET l_oea263 = 0
#  END IF
#  #-----No:CHI-A70015 END-----

# #No.FUN-9C0014 BEGIN -----
# #FUN-A60056--mark--str--
# #IF cl_null(l_dbs) THEN
# #   SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file                                                                                 
# #    WHERE rxx01 = g_oea.oea01 AND rxx03 = '1'
# #      AND rxx00 = '01'
# #ELSE
# #FUN-A60056--mark--end
#     #LET g_sql = "SELECT SUM(rxx04) FROM ",l_dbs CLIPPED,"rxx_file",
#No.FUN-AB0034 --begin
#   IF g_oma.oma00 = '11' THEN 
#     LET g_sql = "SELECT SUM(rxx04) FROM ",cl_get_target_table(g_plant_new,'rxx_file'), #FUN-A50102
#                 " WHERE rxx01 = '",g_oea.oea01,"' AND rxx03 = '1'",
#                 "   AND rxx00 = '01'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
#           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102               
#     PREPARE sel_rxx_pre48 FROM g_sql
#     EXECUTE sel_rxx_pre48 INTO l_rxx04
#   END IF 
#No.FUN-AB0034 --end

# #END IF   #FUN-A60056

#  IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF        #MOD-9C0288

#  IF cl_null(l_dbs) THEN
#     SELECT occ73 INTO l_occ73 FROM occ_file
#      WHERE occ01 = g_oma.oma68
#  ELSE
#     #LET g_sql = "SELECT occ73 FROM ",l_dbs CLIPPED,"occ_file",
#     LET g_sql = "SELECT occ73 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
#                 " WHERE occ01 = '",g_oma.oma68,"'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
#     PREPARE sel_occ_pre49 FROM g_sql
#     EXECUTE sel_occ_pre49 INTO l_occ73
#  END IF

#  IF cl_null(l_occ73) THEN LET l_occ73 = 'N' END IF      #MOD-9C0288

#  LET l_flag = 'N'
# #No.FUN-9C0014 END -------

#  LET g_oma.oma50 = 0
#  LET g_oma.oma50t = 0
#  LET g_oma.oma73  = 0  #Add No:FUN-AC0025   #本币代收
#  LET g_oma.oma73f = 0  #Add No:FUN-AC0025   #原币代收
#  LET l_flag2 = 'N'           #CHI-A50040

#  SELECT SUM(omb14),SUM(omb14t)
#    INTO g_oma.oma50,g_oma.oma50t
#    FROM omb_file
#   WHERE omb01 = g_oma.oma01
#  IF g_oma.oma50  IS NULL THEN LET g_oma.oma50=0 END IF
#  IF g_oma.oma50t IS NULL THEN LET g_oma.oma50t=0 END IF #plum add
# #Add No:FUN-AC0025
#  #IF g_oma.oma74 = '2' AND (g_oma.oma00 ='21' OR g_oma.oma00 ='12') THEN   #FUN-B10058
#  IF g_oma.oma74 = '2' AND (g_oma.oma00 ='28' OR g_oma.oma00 ='19') THEN    #FUN-B10058
#    #SELECT SUM(omb14),SUM(omb16) INTO g_oma.oma73f,g_oma.oma73 #by elva
#     SELECT SUM(omb14t),SUM(omb16t) INTO g_oma.oma73f,g_oma.oma73 #by elva
#       FROM omb_file WHERE omb01=g_oma.oma01
#     IF g_oma.oma73 IS NULL THEN LET g_oma.oma73=0 END IF
#     IF g_oma.oma73f IS NULL THEN LET g_oma.oma73f=0 END IF
#  ELSE
#     LET g_oma.oma73 = 0
#     LET g_oma.oma73f= 0
#  END IF
# #End Add No:FUN-AC0025
#  LET g_oma.oma52 = 0  #MOD-680041
#
#  #FUN-B10058--add--str--
#  IF g_oma.oma00 = '19' THEN
#     LET g_oma00 = '12'
#  ELSE
#     LET g_oma00 = g_oma.oma00 
#  END IF 
#  #FUN-B10058--add--end

#  #CASE WHEN g_oma.oma00 = '11'    #FUN-B10058
#  CASE WHEN g_oma00 = '11'         #FUN-B10058
#            #FUN-990031--add--str--若客戶設置為按交款金額立應收,或者交款金額大訂金比率金額,則按照交款金額立應收,
#            ##                     否則按照訂金比率立應收
#          # IF l_occ73 = 'N' AND l_rxx04 <= g_oma.oma50 *g_oma.oma161/100 THEN  #No.FUN-9C0014
#            IF l_occ73 = 'N' THEN  #No.FUN-9C0014
#              ##-----No:FUN-A50103-----
#               IF g_oma.oma213 = 'Y' THEN
#                  LET g_oma.oma54t = g_oeaa.oeaa08
#                  LET g_oma.oma54  = g_oma.oma54t/(1+ g_oma.oma211/100)
#               ELSE
#                  LET g_oma.oma54  = g_oeaa.oeaa08
#                  LET g_oma.oma54t = g_oma.oma54*(1+ g_oma.oma211/100)
#               END IF
#              #IF p_oas05 > 0 THEN
#              #   LET g_oma.oma54 = (((g_oma.oma50 *g_oma.oma161/100)*p_oas05)/100)
#              #   LET g_oma.oma54t= (((g_oma.oma50t*g_oma.oma161/100)*p_oas05)/100)
#              #ELSE
#              #   LET g_oma.oma54 = g_oma.oma50 *g_oma.oma161/100
#              #   LET g_oma.oma54t= g_oma.oma50t*g_oma.oma161/100
#              #END IF
#              ##-----No:FUN-A50103 END-----
#            ELSE
#               LET g_oma.oma54t = l_rxx04
#               LET g_oma.oma54 = l_rxx04
#               LET l_flag = 'Y'
#            END IF 
#       #WHEN g_oma.oma00 = '12'   #FUN-B10058
#       WHEN g_oma00 = '12'        #FUN-B10058
#          #-TQC-B60089-mark-
#          ##-MOD-A70194-add-
#          # LET l_cnt = 0
#          ##-MOD-AB0101-add-
#          ##SELECT count(*) INTO l_cnt
#          ##  FROM oeb_file
#          ## WHERE oeb01 = g_ogb.ogb31 AND oeb03 = g_ogb.ogb32
#          # LET g_sql = "SELECT COUNT(*) ",
#          #             "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'),        
#          #             " WHERE oeb01 = '",g_ogb.ogb31,"' AND oeb03 = '",g_ogb.ogb32,"'"
#          # CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#          # CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#          # PREPARE sel_oeb_pre01 FROM g_sql
#          # EXECUTE sel_oeb_pre01 INTO l_cnt  
#          ##-MOD-A70194-end-
#          #-TQC-B60089-end-
#           #-CHI-A50040-add- 
#           #若出貨數量大於訂單數量即表示超交
#           #SELECT oeb917 INTO l_oeb917  
#           #  FROM oeb_file
#           #  WHERE oeb01 = g_ogb.ogb31 AND oeb03 = g_ogb.ogb32
#           #LET g_sql = "SELECT oeb917 ",         #MOD-B50230 mark
#            LET g_sql = "SELECT SUM(oeb917) ",    #MOD-B50230
#                        "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'),        
#                       #" WHERE oeb01 = '",g_ogb.ogb31,"' AND oeb03 = '",g_ogb.ogb32,"'" #MOD-B50230 mark
#                        " WHERE oeb01 = '",g_ogb.ogb31,"'"                               #MOD-B50230
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#            PREPARE sel_oeb_pre02 FROM g_sql
#            EXECUTE sel_oeb_pre02 INTO l_oeb917  
#           #-MOD-AB0101-end-
#            IF l_oeb917  IS NULL THEN LET l_oeb917 = 0 END IF
#           #抓取非此張出貨單的其他同訂單
#           #-MOD-AB0101-add-
#           #SELECT SUM(ogb917) INTO l_ogb917  
#           #  FROM ogb_file,oga_file                                          #TQC-A60027
#           #  WHERE ogb01 <> g_ogb.ogb01 AND ogb31 = g_ogb.ogb31 AND ogb32 = g_ogb.ogb32
#           #    AND (oga10 IS NOT NULL AND oga10 <> ' ' ) AND oga01 = ogb01   #TQC-A60027
#            LET g_sql = "SELECT SUM(ogb917)",
#                        "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",",        
#                                  cl_get_target_table(g_plant_new,'ogb_file'),           
#                        " WHERE ogb01 <> '",g_ogb.ogb01,"' AND ogb31 = '",g_ogb.ogb31,"'",
#                       #"   AND ogb32 = '",g_ogb.ogb32,"'",      #MOD-B50230 mark
#                        "   AND (oga10 IS NOT NULL AND oga10 <> ' ' ) ",
#                       #"   AND oga01 = ogb01 AND oga09 IN ('2','3','4','8','A')"                  #MOD-B50216 mark 
#                        "   AND oga01 = ogb01 ",                                                   #MOD-B50216  
#                        "   AND ((oga09 = '2' AND oga65 = 'N') OR (oga09 IN ('3','4','8','A'))) "  #MOD-B50216
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#            PREPARE sel_ogb_pre01 FROM g_sql
#            EXECUTE sel_ogb_pre01 INTO l_ogb917  
#           #-MOD-AB0101-end-
#            IF l_ogb917  IS NULL THEN LET l_ogb917 = 0 END IF
#           #-MOD-B50230-add-
#           #抓取此張出貨單的總數量
#            LET l_sumogb917 = 0
#            LET g_sql = "SELECT SUM(ogb917)",
#                        "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",",        
#                                  cl_get_target_table(g_plant_new,'ogb_file'),           
#                        " WHERE ogb01 = '",g_ogb.ogb01,"' AND ogb31 = '",g_ogb.ogb31,"'",
#                        "   AND oga01 = ogb01 ",                                                   
#                        "   AND ((oga09 = '2' AND oga65 = 'N') OR (oga09 IN ('3','4','8','A'))) " 
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#            PREPARE sel_ogb_pre08 FROM g_sql
#            EXECUTE sel_ogb_pre08 INTO l_sumogb917  
#            IF l_sumogb917  IS NULL THEN LET l_sumogb917 = 0 END IF
#           #抓取不是本張出貨單的其他訂金應收之訂金金額
#            LET l_12_oma52 = 0
#            LET g_sql = " SELECT SUM(oma52) ",
#                        " FROM oma_file ",
#                        " WHERE oma01 IN (SELECT oma01 FROM oma_file,",cl_get_target_table(g_plant_new,'ogb_file'),  
#                        " WHERE oma16 = ogb01 ",
#                        "   AND oma16 <> '",g_ogb.ogb01,"'",
#                        "   AND (oma00 = '12' OR oma00 = '19')",  
#                        "   AND omavoid = 'N' ", 
#                        "   AND ogb31 = '",g_ogb.ogb31,"' AND omaconf = 'N')"
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#            PREPARE sel_ogb_pre09 FROM g_sql
#            EXECUTE sel_ogb_pre09 INTO l_12_oma52
#            IF l_12_oma52  IS NULL THEN LET l_12_oma52 = 0 END IF   
#           #-MOD-B50230-end-
#          #-TQC-B60089-mark-
#          ##IF l_oeb917 < g_ogb.ogb917+l_ogb917 THEN
#          ##IF l_oeb917 <= g_ogb.ogb917+l_ogb917 THEN    #No:FUN-A50103      #MOD-A70194 mark
#          #  IF l_oeb917 <= g_ogb.ogb917+l_ogb917 AND l_cnt > 0 THEN          #MOD-A70194
#          ##IF l_oeb917 < g_ogb.ogb917+l_ogb917 AND l_cnt > 0 THEN     #MOD-A70194 #MOD-B50230 mark
#          # IF l_oeb917 < l_sumogb917+l_ogb917 AND l_cnt > 0 THEN                  #MOD-B50230
#          #    LET l_flag2 = 'Y'   
#          #   #-MOD-AB0101-add-
#          #   #SELECT SUM(ogb14),SUM(ogb14t)
#          #   #  INTO l_sumogb14,l_sumogb14t
#          #   #  FROM ogb_file
#          #   # WHERE ogb31 = g_ogb.ogb31 
#          #   #此訂單在出貨單的金額 
#          #    LET g_sql = "SELECT SUM(ogb14),SUM(ogb14t)",
#          #                "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",",        
#          #                          cl_get_target_table(g_plant_new,'ogb_file'),",",        
#          #                "         oma_file,omb_file ",                            #MOD-B50216
#          #                " WHERE ogb31 = '",g_ogb.ogb31,"'",
#          #               #"   AND ogb32 = '",g_ogb.ogb32,"'",                       #MOD-B10012 #MOD-B50230 mark 
#          #                "   AND oma01 = omb01 ",                                  #MOD-B50216
#          #                "   AND omavoid = 'N' ",                                  #MOD-B50216 
#          #                "   AND omb31 = ogb01 ",                                  #MOD-B50216 
#          #                "   AND omb32 = ogb03 ",                                  #MOD-B50216
#          #               #"   AND oga01 = ogb01 AND oga09 IN ('2','3','4','8','A')"                  #MOD-B50216 mark 
#          #                "   AND oga01 = ogb01 ",                                                   #MOD-B50216  
#          #                "   AND ((oga09 = '2' AND oga65 = 'N') OR (oga09 IN ('3','4','8','A'))) "  #MOD-B50216
#          #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#          #    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#          #    PREPARE sel_ogb_pre02 FROM g_sql
#          #    EXECUTE sel_ogb_pre02 INTO l_sumogb14,l_sumogb14t 
#          #   #-MOD-AB0101-end-
#          #    IF l_sumogb14  IS NULL THEN LET l_sumogb14 = 0 END IF
#          #    IF l_sumogb14t IS NULL THEN LET l_sumogb14t = 0 END IF

#          #    #-----No:FUN-A50103-----
#          #   #此訂單的訂金金額 
#          #    SELECT SUM(oma54),SUM(oma54t)
#          #      INTO l_11_oma54,l_11_oma54t
#          #      FROM oma_file
#          #     WHERE oma16 = g_ogb.ogb31
#          #       AND oma00 = '11' 
#          #    IF g_oma.oma213 = 'Y' THEN
#          #      ##-----No:CHI-A70015-----
#          #      #SELECT oea263 INTO l_13_oma54t
#          #      #  FROM oea_file
#          #      # WHERE oea01 = g_ogb.ogb31
#          #       LET l_13_oma54t = l_oea263  
#          #       #-----No:CHI-A70015 END-----
#          #       LET l_13_oma54  = l_13_oma54t/(1+ g_oma.oma211/100)
#          #       CALL cl_digcut(l_13_oma54,t_azi04) RETURNING l_13_oma54
#          #    ELSE
#          #      ##-----No:CHI-A70015-----
#          #      #SELECT oea263 INTO l_13_oma54
#          #      #  FROM oea_file
#          #      # WHERE oea01 = g_ogb.ogb31
#          #       LET l_13_oma54 = l_oea263  
#          #       #-----No:CHI-A70015 END-----
#          #       LET l_13_oma54t = l_13_oma54 *(1+ g_oma.oma211/100)
#          #       CALL cl_digcut(l_13_oma54t,t_azi04) RETURNING l_13_oma54t
#          #    END IF
#          #   #SELECT oma50,oma50t,oma54,oma54t
#          #   #  INTO l_13_oma54,l_13_oma54t,l_11_oma54,l_11_oma54t
#          #   #  FROM oma_file
#          #   # WHERE oma16 = g_ogb.ogb31 AND oma00 = '11' 
#          #    IF l_11_oma54  IS NULL THEN LET l_11_oma54 = 0 END IF   
#          #    IF l_11_oma54t IS NULL THEN LET l_11_oma54t = 0 END IF 
#          #    IF l_13_oma54  IS NULL THEN LET l_13_oma54 = 0 END IF
#          #    IF l_13_oma54t IS NULL THEN LET l_13_oma54t = 0 END IF
#     
#          #   #LET l_13_oma54 = l_13_oma54  * g_oma.oma163/100
#          #   #LET l_13_oma54t= l_13_oma54t * g_oma.oma163/100
#          #   #CALL cl_digcut(l_13_oma54,t_azi04)  RETURNING l_13_oma54 
#          #   #CALL cl_digcut(l_13_oma54t,t_azi04) RETURNING l_13_oma54t 
#          #   ##-----No:FUN-A50103 END-----
#          #   #-MOD-B10012-add-
#          #   #SELECT SUM(oma52),SUM(oma54),SUM(oma54t)                 #TQC-A60027
#          #   #  INTO l_12_oma52,l_12_oma54,l_12_oma54t                 #TQC-A60027
#          #   #  FROM oma_file
#          #   # WHERE oma01 IN (SELECT oma01 FROM oma_file,ogb_file  
#          #   #                  WHERE oma16 = ogb01
#          #   #                    AND oma16 <> g_ogb.ogb01
#          #   #                    AND oma00 = '12' 
#          #   #                    AND omavoid = 'N' 
#          #   #                    AND ogb31 = g_ogb.ogb31) 
#          #   #抓取不是本張出貨單的其他出貨應收之未稅與含稅金額
#          #    LET g_sql = " SELECT SUM(oma54),SUM(oma54t) ",    #MOD-B50230 remove SUM(oma52) 
#          #                " FROM oma_file ",
#          #                " WHERE oma01 IN (SELECT oma01 FROM oma_file,",cl_get_target_table(g_plant_new,'ogb_file'),  
#          #                " WHERE oma16 = ogb01 ",
#          #                "   AND oma16 <> '",g_ogb.ogb01,"'",
#          #                #"   AND oma00 = '12' ",  #FUN-B10058 
#          #                "   AND (oma00 = '12' OR oma00 = '19')",  #FUN-B10058 
#          #                "   AND omavoid = 'N' ", 
#          #                "   AND ogb31 = '",g_ogb.ogb31,"')"   
#          #               #"   AND ogb32 = '",g_ogb.ogb32,"')"    #MOD-B50230 mark
#          #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#          #    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#          #    PREPARE sel_ogb_pre04 FROM g_sql
#          #    EXECUTE sel_ogb_pre04 INTO l_12_oma54,l_12_oma54t #MOD-B50230 remove SUM(oma52) 
#          #   #-MOD-B10012-end-
#          #   #IF l_12_oma52  IS NULL THEN LET l_12_oma52 = 0 END IF    #TQC-A60027 #MOD-B50230 mark 
#          #    IF l_12_oma54  IS NULL THEN LET l_12_oma54 = 0 END IF
#          #    IF l_12_oma54t IS NULL THEN LET l_12_oma54t = 0 END IF

#          #    LET g_oma.oma54 = l_sumogb14 - l_11_oma54 - l_12_oma54 - l_13_oma54
#          #    LET g_oma.oma54t= l_sumogb14t - l_11_oma54t - l_12_oma54t - l_13_oma54t

#          #    IF g_check = 'N' THEN 
#          #       LET g_oma.oma52 = l_11_oma54 - l_12_oma52   #無收款 訂單轉銷貨收入實際計算 #TQC-A60027
#          #    ELSE                
#          #       LET g_oma.oma52 = 0                         #有收款 訂單轉銷貨收入為0
#          #    END IF
#          # ELSE
#          #    #-----No:FUN-A50103-----
#          #   ##-----No:CHI-A70015-----
#          #   #SELECT oea61,oea1008,oea262
#          #   #  INTO l_oea61,l_oea1008,l_oea262
#          #   #  FROM oea_file
#          #   # WHERE oea01 = g_ogb.ogb31
#          #   ##-----No:CHI-A70015 END-----
#          #    IF g_check = 'N' THEN   #出貨單沒有收款,按照出貨比率立賬
#          #       IF g_oma.oma213 = 'Y' THEN 
#          #          LET g_oma.oma54 = g_oma.oma50 * l_oea262 / l_oea1008
#          #          LET g_oma.oma54t= g_oma.oma50t* l_oea262 / l_oea1008
#          #          LET g_oma.oma52 = g_oma.oma50 * l_oea261 / l_oea1008  #無收款 訂單轉銷貨收入實際計算
#          #       ELSE
#          #          LET g_oma.oma54 = g_oma.oma50 * l_oea262 / l_oea61
#          #          LET g_oma.oma54t= g_oma.oma50t* l_oea262 / l_oea61
#          #          LET g_oma.oma52 = g_oma.oma50 * l_oea261 / l_oea61  #無收款 訂單轉銷貨收入實際計算
#          #       END IF
#          #    ELSE                    #若有收款,且有尾款,按照出貨金額-尾款金額立帳
#          #       LET g_oma.oma54 = g_oma.oma50*((100-g_oma.oma163)/100)
#          #       LET g_oma.oma54t= g_oma.oma50t*((100-g_oma.oma163)/100)
#          #       LET g_oma.oma52 = 0                               #有收款 訂單轉銷貨收入為0
#          #    END IF
#          #   #IF g_check = 'N' THEN   #出貨單沒有收款,按照出貨比率立賬
#          #   #   LET g_oma.oma54 = g_oma.oma50 *g_oma.oma162/100
#          #   #   LET g_oma.oma54t= g_oma.oma50t*g_oma.oma162/100
#          #   #   LET g_oma.oma52 = g_oma.oma50 *g_oma.oma161/100   #無收款 訂單轉銷貨收入實際計算
#          #   #ELSE                    #若有收款,且有尾款,按照出貨金額-尾款金額立帳
#          #   #   LET g_oma.oma54 = g_oma.oma50*((100-g_oma.oma163)/100)
#          #   #   LET g_oma.oma54t= g_oma.oma50t*((100-g_oma.oma163)/100)
#          #   #   LET g_oma.oma52 = 0                               #有收款 訂單轉銷貨收入為0
#          #   #END IF
#          #   ##-----No:FUN-A50103 END-----
#          # END IF
#          #-TQC-B60089-end-
#           #-CHI-A50040-end-
#           #-CHI-A50040-mark-
#           ##若沒有收款,按照出貨比率立賬
#           ##若有收款,且有尾款,按照出貨金額-尾款金額立帳
#           #IF g_check = 'N' THEN   #出貨單沒有收款
#           #   LET g_oma.oma54 = g_oma.oma50 *g_oma.oma162/100
#           #   LET g_oma.oma54t= g_oma.oma50t*g_oma.oma162/100
#           #ELSE
#No.TQC-A10117 --begin
#           #   #TQC-A10154---Begin
#           #   #LET g_oma.oma54 = g_oma.oma50*(100-g_oma.oma163/100)
#           #   #LET g_oma.oma54t = g_oma.oma50t*(100-g_oma.oma163/100)
#           #   LET g_oma.oma54 = g_oma.oma50*((100-g_oma.oma163)/100)
#           #   LET g_oma.oma54t = g_oma.oma50t*((100-g_oma.oma163)/100)
#           #   #TQC-A10154---End 
#           #   LET g_oma.oma54 = g_oma.oma50*(1-g_oma.oma163/100)
#           #   LET g_oma.oma54t = g_oma.oma50t*(1-g_oma.oma163/100)
#No.TQC-A10117 --end
#           #END IF
#           #IF g_oma.oma07='N' OR cl_null(g_oma.oma07) THEN       #MOD-A30162 mark
#           # #有收款 訂單轉銷貨收入為0
#           # #無收款 訂單轉銷貨收入實際計算
#           #   IF g_check = 'Y' THEN #有收款
#           #      LET g_oma.oma52 = 0
#           #   ELSE 
#           #      LET g_oma.oma52 = g_oma.oma50 *g_oma.oma161/100
#           #   END IF   #FUN-960140 add
#           #-CHI-A50040-end-
#              #CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52   #MOD-960308 add   #TQC-A60027
#           #-TQC-B60089-add-
#            LET g_oma.oma52 = g_oma.oma50 *g_oma.oma161/100
#            LET l_13_oma54  = g_oma.oma50 *g_oma.oma163/100
#            LET l_13_oma54t = g_oma.oma50t *g_oma.oma163/100
#            CALL cl_digcut(l_13_oma54,t_azi04) RETURNING l_13_oma54 
#            CALL cl_digcut(l_13_oma54t,t_azi04) RETURNING l_13_oma54t 
#           #-TQC-B60089-end-
#            #判斷變更後金額是否超出原待抵金額,
#            #若是的話,oma52=原待抵金額,oma54=變更後金額-原待抵金額
#            IF NOT cl_null(g_oma.oma19) THEN    #待抵帳款單號不為空
#               LET l_oma54=0  LET l_oma54t=0
#              #SELECT (oma54t-oma55),oma54t INTO l_oma54,l_oma54t
#               SELECT SUM(oma54t-oma55),SUM(oma54t) INTO l_oma54,l_oma54t    #No:FUN-A50103
#                 FROM oma_file 
#              # WHERE oma01=g_oma.oma19 
#                WHERE oma16=g_oma.oma19     #No:FUN-A50103
#              #IF l_oma54 < g_oma.oma52 THEN   #MOD-B50230 mark
#               IF l_oma54 < g_oma.oma52 OR l_oeb917 <= l_sumogb917+l_ogb917 THEN #MOD-B50230 
#                 #LET g_oma.oma54 = g_oma.oma52 - l_oma54   #原幣未稅金額   #CHI-A50040 mark   
#                 #LET g_oma.oma54t= g_oma.oma52 - l_oma54t  #原幣應收金額   #CHI-A50040 mark
#                 #LET g_oma.oma52 = l_oma54                 #原幣訂金       #MOD-B50230 mark
#                  LET g_oma.oma52 = l_oma54 - l_12_oma52    #原幣訂金       #MOD-B50230
#               END IF
#            ELSE                     #TQC-B60089 
#              LET g_oma.oma52 = 0    #TQC-B60089
#            END IF
#            #No.TQC-B70118  --Begin
#            IF g_check = 'Y' THEN
#               LET g_oma.oma52 = 0
#               LET g_oma.oma53 = 0
#            END IF
#            #No.TQC-B70118  --End
#            CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52   #MOD-760078
#            LET g_oma.oma54 = g_oma.oma50 - g_oma.oma52 - l_13_oma54    #TQC-B60089
#            LET g_oma.oma54t= g_oma.oma50t - g_oma.oma52 - l_13_oma54t  #TQC-B60089
#           #END IF                   #MOD-A30162 mark
#       #WHEN g_oma.oma00 = '13'   #FUN-B10058
#       WHEN g_oma00 = '13'        #FUN-B10058
#            #-----No:FUN-A50103-----
#            IF g_oma.oma213 = 'Y' THEN
#               LET g_oma.oma54t = g_oeaa.oeaa08
#               LET g_oma.oma54  = g_oma.oma54t/(1+ g_oma.oma211/100)
#            ELSE
#               LET g_oma.oma54  = g_oeaa.oeaa08
#               LET g_oma.oma54t = g_oma.oma54*(1+ g_oma.oma211/100)
#            END IF
#            IF l_oea262=0 AND l_oea263 >0 AND NOT cl_null(g_oma.oma19) THEN
#               IF g_oma.oma213 = 'Y' THEN 
#                  LET g_oma.oma52 = g_oma.oma50 * l_oea261 / l_oea1008
#               ELSE
#                  LET g_oma.oma52 = g_oma.oma50 * l_oea261 / l_oea61 
#               END IF
#               CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52    #No.TQC-750093 g_azi -> t_azi
#            END IF
#           #LET g_oma.oma54 = g_oma.oma50 *g_oma.oma163/100
#           #LET g_oma.oma54t= g_oma.oma50t*g_oma.oma163/100
#           #No.+232 010615 by plum 出貨比率=0,尾款直接請款
#           #IF g_oma.oma162=0 AND g_oma.oma163 >0 AND 
#           #   NOT cl_null(g_oma.oma19) THEN
#           #   IF g_oma.oma213='N' THEN   #MOD-8B0198 add
#           #      LET g_oma.oma52 = g_oma.oma50 *g_oma.oma161/100
#           #   ELSE
#           #      LET g_oma.oma52 = g_oma.oma50t*g_oma.oma161/100
#           #   END IF
#           #   CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52   #MOD-760078
#           #END IF
#           ##-----No:FUN-A50103 END-----
#       OTHERWISE
#            LET g_oma.oma54 = g_oma.oma50
#            LET g_oma.oma54t= g_oma.oma50t
#  END CASE

###-FUN-B40032- ADD - BEGIN ---------------------------------------------------
#  IF g_oma.oma70 = '3' THEN
#     SELECT SUM(omb14),SUM(omb14t) INTO g_oma.oma54,g_oma.oma54t 
#       FROM omb_file 
#      WHERE omb01 = g_omb.omb01
#     IF g_azw.azw04 = '2' AND g_oma.oma00 = '11' AND g_check = 'Y' AND l_occ73 = 'Y' THEN  #有收款時,訂金應收稅額為0  #MOD-B30185 add azw04 occ73
#        LET g_oma.oma54x = 0
#        LET g_oma.oma54 = g_oma.oma54t
#     ELSE
#        LET g_oma.oma54x = g_oma.oma54t - g_oma.oma54
#     END IF
#     CALL cl_digcut(g_oma.oma54,t_azi04) RETURNING g_oma.oma54
#     CALL cl_digcut(g_oma.oma54t,t_azi04) RETURNING g_oma.oma54t
#     CALL cl_digcut(g_oma.oma54x,t_azi04) RETURNING g_oma.oma54x
#  ELSE
###-FUN-B40032- ADD -  END  ---------------------------------------------------
#     IF g_oma.oma213='N'   THEN
#        CALL cl_digcut(g_oma.oma54,t_azi04) RETURNING g_oma.oma54   #MOD-760078
#        IF g_azw.azw04 = '2' AND g_oma.oma00 = '11' AND g_check = 'Y' AND l_occ73 = 'Y' THEN  #有收款時,訂金應收稅額為0  #MOD-B30185 add azw04 occ73
#           LET g_oma.oma54x = 0
#        ELSE
#           LET g_oma.oma54x=g_oma.oma54*g_oma.oma211/100
#        END IF   #FUN-960140 
#        CALL cl_digcut(g_oma.oma54x,t_azi04) RETURNING g_oma.oma54x   #MOD-760078
#        LET g_oma.oma54t=g_oma.oma54+g_oma.oma54x
#     ELSE 
#        CALL cl_digcut(g_oma.oma54t,t_azi04) RETURNING g_oma.oma54t   #MOD-760078
#        IF g_azw.azw04 = '2' AND g_oma.oma00 = '11' AND g_check = 'Y' AND l_occ73 = 'Y' THEN  #有收款時,訂金應收稅額為0  #MOD-B30185 add azw04 occ73
#           LET g_oma.oma54x = 0
#        ELSE
#           LET g_oma.oma54x=g_oma.oma54t*g_oma.oma211/(100+g_oma.oma211)
#        END IF  #FUN-960140
#        CALL cl_digcut(g_oma.oma54x,t_azi04) RETURNING g_oma.oma54x   #MOD-760078
#        LET g_oma.oma54 =g_oma.oma54t-g_oma.oma54x
#     END IF
#  END IF     #FUN-B40032 ADD

#No.FUN-AB0034 --begin
#   #FUN-960140 090910--add--str--若有分攤折價,則應收應減去分攤折價得金額
#   IF cl_null(l_dbs) THEN  #No.FUN-9C0014 Add
#      IF g_oma.oma00 = '11' THEN   
#         SELECT SUM(oeb47) INTO l_oeb47 FROM oeb_file WHERE oeb01 = g_oea.oea01
#      ELSE 
#         IF g_oma.oma00 = '12' THEN   #CHI-A50040
#            SELECT SUM(ogb47) INTO l_oeb47 FROM ogb_file WHERE ogb01 = g_oga.oga01
#         END IF                       #CHI-A50040
#      END IF 
#   ELSE
#      IF g_oma.oma00 = '11' THEN                    
#         #LET g_sql = "SELECT SUM(oeb47) FROM ",l_dbs CLIPPED,"oeb_file WHERE oeb01 = '",g_oea.oea01,"'"
#         LET g_sql = "SELECT SUM(oeb47) FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
#                     " WHERE oeb01 = '",g_oea.oea01,"'"
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
#	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102 
#         PREPARE sel_oeb_pre50 FROM g_sql
#         EXECUTE sel_oeb_pre50 INTO l_oeb47
#      ELSE
#         IF g_oma.oma00 = '12' THEN   #CHI-A50040
#            #LET g_sql = "SELECT SUM(ogb47) FROM ",l_dbs CLIPPED,"ogb_file WHERE ogb01 = '",g_oga.oga01,"'"
#            LET g_sql = "SELECT SUM(ogb47) FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
#                        " WHERE ogb01 = '",g_oga.oga01,"'"
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
#	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102 
#            PREPARE sel_oeb_pre51 FROM g_sql
#            EXECUTE sel_oeb_pre51 INTO l_oeb47
#         END IF                       #CHI-A50040
#      END IF
#   END IF
# 
#   IF g_oma.oma00 = '11' THEN
#   #  IF l_oeb47>0  AND g_oma.oma161>0 THEN    #No.FUN-9C0014
#      IF l_oeb47>0  AND g_oma.oma161>0 AND l_flag = 'N' THEN    #No.FUN-9C0014
#         LET g_oma.oma54 = g_oma.oma54-l_oeb47*g_oma.oma161/100
#         LET g_oma.oma54t = g_oma.oma54t-l_oeb47*g_oma.oma161/100
#      END IF 
#   END IF 
# 
#   IF g_oma.oma00 = '12' THEN
#      IF l_oeb47>0 AND g_oma.oma162>0 THEN
#         LET g_oma.oma54 = g_oma.oma54-l_oeb47
#         LET g_oma.oma54t = g_oma.oma54t-l_oeb47
#      END IF 
#   END IF 
#No.FUN-AB0034 --end
#  #------------------------------------------------------------
#  LET g_oma.oma56 = 0 LET g_oma.oma56t= 0
#  LET g_oma.oma53 = 0   #MOD-680041

#  SELECT SUM(omb16),SUM(omb16t) INTO g_oma.oma56,g_oma.oma56t
#    FROM omb_file WHERE omb01=g_oma.oma01

#  IF g_oma.oma56  IS NULL THEN LET g_oma.oma56 =0 END IF   #MOD-7B0192

#  IF g_oma.oma56t IS NULL THEN LET g_oma.oma56t=0 END IF   #MOD-7B0192

#  #CASE WHEN g_oma.oma00 = '11'   #FUN-B10058
#  CASE WHEN g_oma00 = '11'        #FUN-B10058
#            #FUN-990031--add--str--若客戶設置為按交款金額立應收,或者交款金額大訂金比率金額,則按照交款金額立應收,                   
#            ##                     否則按照訂金比率立應收                                                                          
#          # IF l_occ73 = 'N' AND l_rxx04<=g_oma.oma50 *g_oma.oma161/100 THEN #No.FUN-9C0014
#            IF l_occ73 = 'N' THEN #No.FUN-9C0014
#               #-----No:FUN-A50103-----
#               LET g_oma.oma56  = g_oma.oma54 * g_oma.oma24
#               LET g_oma.oma56t = g_oma.oma54t* g_oma.oma24
#              #IF p_oas05 > 0 THEN
#              #   LET g_oma.oma56 = (((g_oma.oma56 *g_oma.oma161/100)*p_oas05)/100)
#              #   LET g_oma.oma56t= (((g_oma.oma56t*g_oma.oma161/100)*p_oas05)/100)
#              #ELSE
#              #   LET g_oma.oma56 = g_oma.oma56 *g_oma.oma161/100 
#              #   LET g_oma.oma56t= g_oma.oma56t*g_oma.oma161/100
#              #END IF                  #FUN-8C0078 add
#              ##-----No:FUN-A50103 END-----
#            ELSE
#            #No.FUN-9C0014 BEGIN -----
#            #  LET g_oma.oma56t  = l_rxx04
#            #  LET g_oma.oma56 = l_rxx04
#               LET g_oma.oma56t  = l_rxx04 * g_oma.oma24
#               LET g_oma.oma56 = l_rxx04 * g_oma.oma24
#            #No.FUN-9C0014 END -------
#            END IF 
#
#       #WHEN g_oma.oma00 = '12'   #FUN-B10058
#       WHEN g_oma00 = '12'        #FUN-B10058
#          #-TQC-B60089-add-
#          ##-MOD-B50230-add-
#          ##抓取不是本張出貨單的其他訂金應收之訂金金額
#          # LET l_12_oma53 = 0
#          # LET g_sql = " SELECT SUM(oma53) ",
#          #             " FROM oma_file ",
#          #             " WHERE oma01 IN (SELECT oma01 FROM oma_file,",cl_get_target_table(g_plant_new,'ogb_file'),  
#          #             " WHERE oma16 = ogb01 ",
#          #             "   AND oma16 <> '",g_ogb.ogb01,"'",
#          #             "   AND (oma00 = '12' OR oma00 = '19')", 
#          #             "   AND omavoid = 'N' ", 
#          #             "   AND ogb31 = '",g_ogb.ogb31,"' AND omaconf = 'N')"
#          # CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#          # CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#          # PREPARE sel_ogb_pre10 FROM g_sql
#          # EXECUTE sel_ogb_pre10 INTO l_12_oma53
#          # IF l_12_oma53  IS NULL THEN LET l_12_oma53 = 0 END IF   
#          ##-MOD-B50230-end-
#          ##-CHI-A50040-add-
#          # IF l_flag2 = 'Y' THEN
#          #   #-MOD-AB0101-add-
#          #   #SELECT SUM(omb16),SUM(omb16t)
#          #   #  INTO l_sumomb16,l_sumomb16t
#          #   #  FROM omb_file,ogb_file
#          #   # WHERE omb31 = ogb01 AND omb32 = ogb03 AND ogb31 = g_ogb.ogb31 
#          #   #此訂單在出貨單的金額 
#          #    LET g_sql = "SELECT SUM(omb16),SUM(omb16t) ",
#          #                "  FROM oma_file,omb_file,",
#          #                        cl_get_target_table(g_plant_new,'ogb_file'),        
#          #                " WHERE omb31 = ogb01 AND omb32 = ogb03 AND ogb31 = '",g_ogb.ogb31,"'",
#          #               #"   AND ogb32 = '",g_ogb.ogb32,"'",                 #MOD-B10012 #MOD-B50230 mark 
#          #                "   AND oma01 = omb01 AND omavoid = 'N'"  
#          #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#          #    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#          #    PREPARE sel_ogb_pre03 FROM g_sql
#          #    EXECUTE sel_ogb_pre03 INTO l_sumomb16,l_sumomb16t 
#          #   #-MOD-AB0101-end-
#          #    IF l_sumomb16  IS NULL THEN LET l_sumomb16 = 0 END IF
#          #    IF l_sumomb16t IS NULL THEN LET l_sumomb16t = 0 END IF

#          #   ##-----No:FUN-A50103-----
#          #   #此訂單的訂金金額 
#          #    SELECT SUM(oma56),SUM(oma56t)
#          #      INTO l_11_oma56,l_11_oma56t
#          #      FROM oma_file
#          #     WHERE oma16 = g_ogb.ogb31
#          #       AND oma00 = '11' 
#          #    IF g_oma.oma213 = 'Y' THEN
#          #      ##-----No:CHI-A70015-----
#          #      #SELECT oea263 INTO l_13_oma56t
#          #      #  FROM oea_file
#          #      # WHERE oea01 = g_ogb.ogb31
#          #       LET l_13_oma56t = l_oea263  
#          #       #-----No:CHI-A70015 END-----
#          #       LET l_13_oma56t = l_13_oma56t * g_oma.oma24
#          #       LET l_13_oma56  = l_13_oma56t/(1+ g_oma.oma211/100)
#          #       CALL cl_digcut(l_13_oma56,t_azi04) RETURNING l_13_oma56
#          #    ELSE
#          #      ##-----No:CHI-A70015-----
#          #      #SELECT oea263 INTO l_13_oma56
#          #      #  FROM oea_file
#          #      # WHERE oea01 = g_ogb.ogb31
#          #       LET l_13_oma56 = l_oea263  
#          #       #-----No:CHI-A70015 END-----
#          #       LET l_13_oma56  = l_13_oma56  * g_oma.oma24
#          #       LET l_13_oma56t = l_13_oma56 *(1+ g_oma.oma211/100)
#          #       CALL cl_digcut(l_13_oma56t,t_azi04) RETURNING l_13_oma56t
#          #    END IF
#          #   #SELECT oma50*oma24,oma50t*oma24,oma56,oma56t              #TQC-A60027 
#          #   #  INTO l_13_oma56,l_13_oma56t,l_11_oma56,l_11_oma56t
#          #   #  FROM oma_file
#          #   # WHERE oma16 = g_ogb.ogb31 AND oma00 = '11' 
#          #    IF l_11_oma56  IS NULL THEN LET l_11_oma56 = 0 END IF  
#          #    IF l_11_oma56t IS NULL THEN LET l_11_oma56t = 0 END IF
#          #    IF l_13_oma56  IS NULL THEN LET l_13_oma56 = 0 END IF
#          #    IF l_13_oma56t IS NULL THEN LET l_13_oma56t = 0 END IF
#     
#          #   #LET l_13_oma56 = l_13_oma56  * g_oma.oma163/100
#          #   #LET l_13_oma56t= l_13_oma56t * g_oma.oma163/100
#          #   #CALL cl_digcut(l_13_oma56,g_azi04)  RETURNING l_13_oma56 
#          #   #CALL cl_digcut(l_13_oma56t,g_azi04) RETURNING l_13_oma56t 
#          #   ##-----No:FUN-A50103 END-----
#          #   #-MOD-B10012-add-
#          #   #SELECT SUM(oma53),SUM(oma56),SUM(oma56t)                #TQC-A60027
#          #   #  INTO l_12_oma53,l_12_oma56,l_12_oma56t                #TQC-A60027
#          #   #  FROM oma_file
#          #   # WHERE oma01 IN (SELECT oma01 FROM oma_file,ogb_file  
#          #   #                  WHERE oma16 = ogb01
#          #   #                    AND oma16 <> g_ogb.ogb01
#          #   #                    AND oma00 = '12' 
#          #   #                    AND omavoid = 'N' 
#          #   #                    AND ogb31 = g_ogb.ogb31) 
#          #   #抓取不是本張出貨單的其他出貨應收之未稅與含稅金額
#          #    LET g_sql = " SELECT SUM(oma56),SUM(oma56t) ",    #MOD-B50230 remove l_12_oma53
#          #                " FROM oma_file ",
#          #                " WHERE oma01 IN (SELECT oma01 FROM oma_file,",cl_get_target_table(g_plant_new,'ogb_file'),  
#          #                " WHERE oma16 = ogb01 ",
#          #                "   AND oma16 <> '",g_ogb.ogb01,"'",
#          #                #"   AND oma00 = '12' ",   #FUN-B10058 
#          #                "   AND (oma00 = '12' OR oma00 = '19')",  #FUN-B10058 
#          #                "   AND omavoid = 'N' ", 
#          #                "   AND ogb31 = '",g_ogb.ogb31,"')" 
#          #               #"   AND ogb32 = '",g_ogb.ogb32,"')"       #MOD-B50230 mark 
#          #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#          #    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#          #    PREPARE sel_ogb_pre05 FROM g_sql
#          #    EXECUTE sel_ogb_pre05 INTO l_12_oma56,l_12_oma56t #MOD-B50230 remove l_12_oma53 
#          #   #-MOD-B10012-end-
#          #   #IF l_12_oma53  IS NULL THEN LET l_12_oma53 = 0 END IF   #TQC-A60027 #MOD-B50230 mark 
#          #    IF l_12_oma56  IS NULL THEN LET l_12_oma56 = 0 END IF
#          #    IF l_12_oma56t IS NULL THEN LET l_12_oma56t = 0 END IF

#          #    LET g_oma.oma56 = l_sumomb16 - l_11_oma56 - l_12_oma56 - l_13_oma56
#          #    LET g_oma.oma56t= l_sumomb16t - l_11_oma56t - l_12_oma56t - l_13_oma56t
#          #    IF g_check = 'N' THEN  #無收款
#          #       LET g_oma.oma53 = l_11_oma56 - l_12_oma53    #訂單轉銷貨收入實際計算
#          #    ELSE                  #有收款
#          #       LET g_oma.oma53 = 0             #訂單轉銷貨收入為0
#          #    END IF
#          # ELSE
#          #    #-----No:FUN-A50103-----
#          #   ##-----No:CHI-A70015-----
#          #   #SELECT oea61,oea1008,oea262
#          #   #  INTO l_oea61,l_oea1008,l_oea262
#          #   #  FROM oea_file
#          #   # WHERE oea01 = g_ogb.ogb31
#          #   ##-----No:CHI-A70015 END-----
#          #    IF g_check = 'N' THEN   #無收款
#          #       IF g_oma.oma213 = 'Y' THEN 
#          #          LET g_oma.oma53 = g_oma.oma56 * l_oea261 / l_oea1008
#          #          LET g_oma.oma56 = g_oma.oma56 * l_oea262 / l_oea1008
#          #          LET g_oma.oma56t= g_oma.oma56t* l_oea262 / l_oea1008
#          #       ELSE
#          #          LET g_oma.oma53 = g_oma.oma56 * l_oea261 / l_oea61 
#          #          LET g_oma.oma56 = g_oma.oma56 * l_oea262 / l_oea61
#          #          LET g_oma.oma56t= g_oma.oma56t* l_oea262 / l_oea61
#          #       END IF
#          #    ELSE                 #有收款
#          #       LET g_oma.oma53 = 0                               #訂單轉銷貨收入為0
#          #       LET g_oma.oma56 = g_oma.oma56*((100-g_oma.oma163)/100)
#          #       LET g_oma.oma56t = g_oma.oma56t*((100-g_oma.oma163)/100)
#          #    END IF
#          #   #IF g_check = 'N' THEN  #無收款
#          #   #   LET g_oma.oma53 = g_oma.oma56 *g_oma.oma161/100   #訂單轉銷貨收入實際計算
#          #   #   LET g_oma.oma56 = g_oma.oma56 *g_oma.oma162/100
#          #   #   LET g_oma.oma56t= g_oma.oma56t*g_oma.oma162/100
#          #   #ELSE                  #有收款
#          #   #   LET g_oma.oma53 = 0                               #訂單轉銷貨收入為0
#          #   #   LET g_oma.oma56 = g_oma.oma56*((100-g_oma.oma163)/100)
#          #   #   LET g_oma.oma56t = g_oma.oma56t*((100-g_oma.oma163)/100)
#          #   #END IF
#          #   ##-----No:FUN-A50103 END-----
#          # END IF 
#          #-TQC-B60089-end-
#           #-CHI-A50040-end-
#           #IF g_oma.oma07='N' OR cl_null(g_oma.oma07) THEN   #MOD-A30162 mark
#           #-CHI-A50040-mark-
#           # #有收款 訂單轉銷貨收入為0
#           # #無收款 訂單轉銷貨收入實際計算
#           #   IF g_check = 'Y' THEN  #有收款
#           #      LET g_oma.oma53 = 0
#           #   ELSE
#           #      LET g_oma.oma53 = g_oma.oma56 *g_oma.oma161/100
#           #   END IF   #FUN-960140 add
#           #-CHI-A50040-end-
#            LET g_oma.oma53 = g_oma.oma52 * g_oma.oma24            #TQC-B60089
#            CALL cl_digcut(g_oma.oma53,g_azi04) RETURNING g_oma.oma53   #MOD-760078
#           #END IF                                            #MOD-A30162 mark
#           #-CHI-A50040-mark-
#           #IF g_check = 'N' THEN  #無收款
#           #   LET g_oma.oma56 = g_oma.oma56 *g_oma.oma162/100
#           #   LET g_oma.oma56t= g_oma.oma56t*g_oma.oma162/100
#           #ELSE                  #有收款
#No.TQC-A10118 --begin
#           #   #TQC-A10154---Begin
#           #   #LET g_oma.oma56 = g_oma.oma56*(100-g_oma.oma163/100)
#           #   #LET g_oma.oma56t = g_oma.oma56t*(100-g_oma.oma163/100)
#           #   LET g_oma.oma56 = g_oma.oma56*((100-g_oma.oma163)/100)
#           #   LET g_oma.oma56t = g_oma.oma56t*((100-g_oma.oma163)/100)
#           #   #TQC-A10154---End
#           #   LET g_oma.oma56 = g_oma.oma56*(1-g_oma.oma163/100)
#           #   LET g_oma.oma56t = g_oma.oma56t*(1-g_oma.oma163/100)
#No.TQC-A10118 --end
#           #END IF
#           #-CHI-A50040-end-
#           #-TQC-B60089-add-
#           #單頭本幣與單身本幣尾差調整
#            LET l_oma56=0 
#            LET l_oma56t=0
#            SELECT SUM(omb16),SUM(omb16t) INTO l_sumomb16,l_sumomb16t
#              FROM omb_file
#             WHERE omb01 = g_oma.oma01 
#            IF l_sumomb16  IS NULL THEN LET l_sumomb16 = 0 END IF
#            IF l_sumomb16t IS NULL THEN LET l_sumomb16t = 0 END IF
#            LET g_oma.oma56 = g_oma.oma54 *g_oma.oma24
#            LET l_oma56 = g_oma.oma53 + g_oma.oma56 
#            CALL cl_digcut(l_oma56,g_azi04) RETURNING l_oma56  
#            LET l_oma56 = l_oma56 - l_sumomb16
#            IF l_oma56 <> 0 THEN
#               LET g_oma.oma56 = g_oma.oma56 - l_oma56
#            END IF
#            LET g_oma.oma56t= g_oma.oma54t*g_oma.oma24
#            LET l_oma56t = g_oma.oma53 + g_oma.oma56t 
#            CALL cl_digcut(l_oma56t,g_azi04) RETURNING l_oma56t  
#            #No.TQC-B70118  --Begin
#            #LET l_oma56t = l_oma56t - l_sumomb16
#            LET l_oma56t = l_oma56t - l_sumomb16t
#            #No.TQC-B70118  --End  
#            IF l_oma56t <> 0 THEN
#               LET g_oma.oma56t = g_oma.oma56t - l_oma56t
#            END IF
#           #-TQC-B60089-end-
#            #判斷變更後金額是否超出原待抵金額,
#            #若是的話,oma53=原待抵金額,oma54=變更後金額-原待抵金額
#           #-TQC-B60089-mark-
#           #IF NOT cl_null(g_oma.oma19) THEN    #待抵帳款單號不為空
#           #   LET l_oma56=0 LET l_oma56t=0
#           #  #SELECT (oma56t-oma57),oma56t INTO l_oma56,l_oma56t
#           #   SELECT SUM(oma56t-oma57),SUM(oma56t) INTO l_oma56,l_oma56t
#           #     FROM oma_file 
#           #   #WHERE oma01=g_oma.oma19 
#           #    WHERE oma16=g_oma.oma19     #No:FUN-A50103
#           #  #IF l_oma56 < g_oma.oma53 THEN   #MOD-B50230 mark
#           #   IF l_oma56 < g_oma.oma53 OR l_oeb917 <= l_sumogb917+l_ogb917 THEN                #MOD-B50230
#           #     #LET g_oma.oma56 = g_oma.oma53 - l_oma56   #本幣未稅金額   #CHI-A50040 mark 
#           #     #LET g_oma.oma56t= g_oma.oma53 - l_oma56t  #本幣應收金額   #CHI-A50040 mark
#           #     #LET g_oma.oma53 = l_oma56                 #本幣訂金     #MOD-B50230 mark 
#           #      LET g_oma.oma53 = l_oma56 - l_12_oma53    #本幣訂金     #MOD-B50230
#           #   END IF
#           #END IF
#           #-TQC-B60089-end-
#       #WHEN g_oma.oma00 = '13'   #FUN-B10058
#       WHEN g_oma00 = '13'        #FUN-B10058
#            #-----No:FUN-A50103-----
#            LET g_oma.oma56  = g_oma.oma54 * g_oma.oma24
#            LET g_oma.oma56t = g_oma.oma54t* g_oma.oma24
#            IF l_oea262 = 0 AND l_oea263 > 0 THEN
#               LET g_oma.oma53  = g_oma.oma52 * g_oma.oma24
#               CALL cl_digcut(g_oma.oma53,g_azi04) RETURNING g_oma.oma53 
#            END IF
#           #IF g_oma.oma162=0 AND g_oma.oma163 >0 THEN
#           #   IF g_oma.oma213='N' THEN   #MOD-8B0198 add
#           #      LET g_oma.oma53 = g_oma.oma56 *g_oma.oma161/100
#           #   ELSE
#           #      LET g_oma.oma53 = g_oma.oma56t*g_oma.oma161/100
#           #   END IF
#           #   CALL cl_digcut(g_oma.oma53,g_azi04) RETURNING g_oma.oma53   #MOD-760078
#           #END IF
#           #LET g_oma.oma56 = g_oma.oma56 *g_oma.oma163/100
#           #LET g_oma.oma56t= g_oma.oma56t*g_oma.oma163/100
#           ##-----No:FUN-A50103 END-----
#  END CASE

#  IF g_oma.oma56  IS NULL THEN LET g_oma.oma56 =0 END IF

#  IF g_oma.oma56t IS NULL THEN LET g_oma.oma56t=0 END IF

###-FUN-B40032- ADD - BEGIN ---------------------------------------------------
#  IF g_oma.oma70 = '3' THEN
#     SELECT SUM(omb16),SUM(omb16t) INTO g_oma.oma56,g_oma.oma56t 
#       FROM omb_file 
#      WHERE omb01 = g_omb.omb01
#     IF g_oma.oma00 = '11' AND g_check = 'Y' THEN  #訂金有收款,稅額為0
#        LET g_oma.oma56x = 0
#        LET g_oma.oma56 = g_oma.oma56t
#     ELSE
#        LET g_oma.oma56x = g_oma.oma56t - g_oma.oma56
#     END IF
#     CALL cl_digcut(g_oma.oma56,t_azi04) RETURNING g_oma.oma56
#     CALL cl_digcut(g_oma.oma56t,t_azi04) RETURNING g_oma.oma56t
#     CALL cl_digcut(g_oma.oma56x,t_azi04) RETURNING g_oma.oma56x
#  ELSE
###-FUN-B40032- ADD -  END  ---------------------------------------------------
#     IF g_oma.oma213='N' THEN
#        CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56   #MOD-760078
#        IF g_oma.oma00 = '11' AND g_check = 'Y' THEN  #訂金有收款,稅額為0
#           LET g_oma.oma56x = 0
#        ELSE
#           LET g_oma.oma56x=g_oma.oma56*g_oma.oma211/100
#        END IF   #FUN-960140
#        CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x   #MOD-760078
#        LET g_oma.oma56t=g_oma.oma56+g_oma.oma56x
#     ELSE
#        CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t   #MOD-760078
#        IF g_oma.oma00 = '11' AND g_check = 'Y' THEN  #訂金有收款,稅額為0
#           LET g_oma.oma56x = 0
#        ELSE
#           LET g_oma.oma56x=g_oma.oma56t*g_oma.oma211/(100+g_oma.oma211)
#        END IF  #FUN-960140
#        CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x   #MOD-760078
#        LET g_oma.oma56 =g_oma.oma56t-g_oma.oma56x
#     END IF
#  END IF           #FUN-B40032 ADD

#No.FUN-AB0034 --begin
#   IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
#   IF g_oma.oma00 = '11' THEN       
#      SELECT SUM(oeb47) INTO l_oeb47 FROM oeb_file WHERE oeb01 = g_oea.oea01
#   ELSE
#      IF g_oma.oma00 = '12' THEN   #CHI-A50040  
#         SELECT SUM(ogb47) INTO l_oeb47 FROM ogb_file WHERE ogb01 = g_oga.oga01
#      END IF                       #CHI-A50040
#   END IF 
#   #No.FUN-9C0014 BEGIN -----
#   ELSE
#      IF g_oma.oma00 = '11' THEN
#         #LET g_sql = "SELECT SUM(oeb47) FROM ",l_dbs CLIPPED,"oeb_file WHERE oeb01 = '",g_oea.oea01,"'" 
#         LET g_sql = "SELECT SUM(oeb47) FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
#                     " WHERE oeb01 = '",g_oea.oea01,"'"
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
#	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102 
#         PREPARE sel_oeb_pre52 FROM g_sql
#         EXECUTE sel_oeb_pre52 INTO l_oeb47
#      ELSE
#         IF g_oma.oma00 = '12' THEN   #CHI-A50040 
#            #LET g_sql = "SELECT SUM(ogb47) FROM ",l_dbs CLIPPED,"ogb_file WHERE ogb01 = '",g_oga.oga01,"'"
#            LET g_sql = "SELECT SUM(ogb47) FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
#                        " WHERE ogb01 = '",g_oga.oga01,"'"
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
#	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102 
#            PREPARE sel_oeb_pre53 FROM g_sql
#            EXECUTE sel_oeb_pre53 INTO l_oeb47
#         END IF                       #CHI-A50040
#      END IF
#   END IF
#   #No.FUN-9C0014 END -------
# 
#   IF g_oma.oma00 = '11' THEN
#   #  IF l_oeb47>0 AND g_oma.oma161 >0  THEN   #No.FUN-9C0014
#      IF l_oeb47>0 AND g_oma.oma161 >0  AND l_flag = 'N' THEN   #No.FUN-9C0014
#         LET g_oma.oma56 = g_oma.oma56-l_oeb47*g_oma.oma161/100 
#         LET g_oma.oma56t = g_oma.oma56t-l_oeb47*g_oma.oma161/100 
#      END IF 
#   END IF 
# 
#   IF g_oma.oma00 = '12' THEN
#      IF l_oeb47>0 AND g_oma.oma162>0 THEN
#         LET g_oma.oma56 = g_oma.oma56-l_oeb47
#         LET g_oma.oma56t = g_oma.oma56t-l_oeb47
#      END IF                                                                                                                        
#   END IF 
#  #FUN-960140 090910--add--end
#No.FUN-AB0034 --end   
#  #------------------------------------------------------------
#  LET g_oma.oma59 = 0 LET g_oma.oma59t= 0
#  SELECT SUM(omb18),SUM(omb18t) INTO g_oma.oma59,g_oma.oma59t
#    FROM omb_file
#   WHERE omb01=g_oma.oma01

#  #CASE WHEN g_oma.oma00 = '11'   #FUN-B10058 
#  CASE WHEN g_oma00 = '11'        #FUN-B10058 
#            #-----No:FUN-A50103-----
#            LET g_oma.oma59  = g_oma.oma54 * g_oma.oma58
#            LET g_oma.oma59t = g_oma.oma54t* g_oma.oma58
#           ##--NO.FUN-8C0078 start----
#           #IF p_oas05 > 0 THEN
#           #    LET g_oma.oma59 = (((g_oma.oma59 *g_oma.oma161/100)*p_oas05)/100)
#           #    LET g_oma.oma59t= (((g_oma.oma59t*g_oma.oma161/100)*p_oas05)/100) 
#           #ELSE
#           ##--NO.FUN-8C0078 end----
#           #    LET g_oma.oma59 = g_oma.oma59 *g_oma.oma161/100
#           #    LET g_oma.oma59t= g_oma.oma59t*g_oma.oma161/100
#           #END IF   #FUN-8C0078 add
#           ##-----No:FUN-A50103 END-----
#       #FUN-960140 add
#        #WHEN g_oma.oma00 = '12'    #FUN-B10058
#        WHEN g_oma00 = '12'         #FUN-B10058 
#          #-TQC-B60089-mark-
#          ##-CHI-A50040-add-
#          # IF l_flag2 = 'Y' THEN
#          #   #-MOD-B10012-add-
#          #   #SELECT SUM(omb18),SUM(omb18t)
#          #   #  INTO l_sumomb18,l_sumomb18t
#          #   #  FROM omb_file,ogb_file
#          #   # WHERE omb31 = ogb01 AND omb32 = ogb03 AND ogb31 = g_ogb.ogb31 
#          #   #此訂單在出貨單的金額 
#          #    LET g_sql = "SELECT SUM(omb18),SUM(omb18t) ",
#          #                "  FROM oma_file,omb_file,",
#          #                        cl_get_target_table(g_plant_new,'ogb_file'),        
#          #                " WHERE omb31 = ogb01 AND omb32 = ogb03 AND ogb31 = '",g_ogb.ogb31,"'",
#          #               #"   AND ogb32 = '",g_ogb.ogb32,"'",        #MOD-B50230 mark 
#          #                "   AND oma01 = omb01 AND omavoid = 'N'"  
#          #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#          #    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#          #    PREPARE sel_ogb_pre06 FROM g_sql
#          #    EXECUTE sel_ogb_pre06 INTO l_sumomb18,l_sumomb18t 
#          #   #-MOD-B10012-end-
#          #    IF l_sumomb18  IS NULL THEN LET l_sumomb18 = 0 END IF
#          #    IF l_sumomb18t IS NULL THEN LET l_sumomb18t = 0 END IF

#          #   ##-----No:FUN-A50103-----
#          #   #此訂單的訂金金額 
#          #    SELECT SUM(oma59),SUM(oma59t)
#          #      INTO l_11_oma59,l_11_oma59t
#          #      FROM oma_file
#          #     WHERE oma16 = g_ogb.ogb31
#          #       AND oma00 = '11' 
#          #    IF g_oma.oma213 = 'Y' THEN
#          #      ##-----No:CHI-A70015-----
#          #      #SELECT oea263 INTO l_13_oma59t
#          #      #  FROM oea_file
#          #      # WHERE oea01 = g_ogb.ogb31
#          #       LET l_13_oma59t = l_oea263  
#          #       #-----No:CHI-A70015 END-----
#          #       LET l_13_oma59t = l_13_oma59t * g_oma.oma58
#          #       LET l_13_oma59  = l_13_oma59t/(1+ g_oma.oma211/100)
#          #       CALL cl_digcut(l_13_oma59,t_azi04) RETURNING l_13_oma59
#          #    ELSE
#          #      ##-----No:CHI-A70015-----
#          #      #SELECT oea263 INTO l_13_oma59
#          #      #  FROM oea_file
#          #      # WHERE oea01 = g_ogb.ogb31
#          #       LET l_13_oma59 = l_oea263  
#          #       #-----No:CHI-A70015 END-----
#          #       LET l_13_oma59  = l_13_oma59 * g_oma.oma58
#          #       LET l_13_oma59t = l_13_oma59 *(1+ g_oma.oma211/100)
#          #       CALL cl_digcut(l_13_oma59t,t_azi04) RETURNING l_13_oma59t
#          #    END IF
#          #   #SELECT oma50*oma58,oma50t*oma58,oma59,oma59t            #TQC-A60027 
#          #   #  INTO l_13_oma59,l_13_oma59t,l_11_oma59,l_11_oma59t
#          #   #  FROM oma_file
#          #   # WHERE oma16 = g_ogb.ogb31 AND oma00 = '11' 
#          #    IF l_11_oma59  IS NULL THEN LET l_11_oma59 = 0 END IF
#          #    IF l_11_oma59t IS NULL THEN LET l_11_oma59t = 0 END IF
#          #    IF l_13_oma59  IS NULL THEN LET l_13_oma59 = 0 END IF
#          #    IF l_13_oma59t IS NULL THEN LET l_13_oma59t = 0 END IF
#     
#          #   #LET l_13_oma59 = l_13_oma59  * g_oma.oma163/100
#          #   #LET l_13_oma59t= l_13_oma59t * g_oma.oma163/100
#          #   #CALL cl_digcut(l_13_oma59,g_azi04)  RETURNING l_13_oma59 
#          #   #CALL cl_digcut(l_13_oma59t,g_azi04) RETURNING l_13_oma59t 
#          #   ##-----No:FUN-A50103 END-----
#          #   #-MOD-B10012-add-
#          #   #SELECT SUM(oma59),SUM(oma59t)
#          #   #  INTO l_12_oma59,l_12_oma59t
#          #   #  FROM oma_file
#          #   # WHERE oma01 IN (SELECT oma01 FROM oma_file,ogb_file  
#          #   #                  WHERE oma16 = ogb01
#          #   #                    AND oma16 <> g_ogb.ogb01
#          #   #                    AND oma00 = '12' 
#          #   #                    AND omavoid = 'N' 
#          #   #                    AND ogb31 = g_ogb.ogb31) 
#          #   #抓取不是本張出貨單的其他出貨應收之未稅與含稅金額
#          #    LET g_sql = " SELECT SUM(oma59),SUM(oma59t) ",
#          #                " FROM oma_file ",
#          #                " WHERE oma01 IN (SELECT oma01 FROM oma_file,",cl_get_target_table(g_plant_new,'ogb_file'),  
#          #                " WHERE oma16 = ogb01 ",
#          #                "   AND oma16 <> '",g_ogb.ogb01,"'",
#          #                #"   AND oma00 = '12' ",  #FUN-B10058 
#          #                "   AND (oma00 = '12' OR oma00 = '19')",   #FUN-B10058 
#          #                "   AND omavoid = 'N' ", 
#          #                "   AND ogb31 = '",g_ogb.ogb31,"')"      
#          #               #"   AND ogb32 = '",g_ogb.ogb32,"')"     #MOD-B50230 mark
#          #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#          #    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#          #    PREPARE sel_ogb_pre07 FROM g_sql
#          #    EXECUTE sel_ogb_pre07 INTO l_12_oma59,l_12_oma59t 
#          #   #-MOD-B10012-end-
#          #    IF l_12_oma59  IS NULL THEN LET l_12_oma59 = 0 END IF
#          #    IF l_12_oma59t IS NULL THEN LET l_12_oma59t = 0 END IF

#          #    LET g_oma.oma59 = l_sumomb18 - l_11_oma59 - l_12_oma59 - l_13_oma59
#          #    LET g_oma.oma59t= l_sumomb18t - l_11_oma59t - l_12_oma59t - l_13_oma59t
#          # ELSE
#          #    #-----No:FUN-A50103-----
#          #   ##-----No:CHI-A70015-----
#          #   #SELECT oea61,oea1008,oea262
#          #   #  INTO l_oea61,l_oea1008,l_oea262
#          #   #  FROM oea_file
#          #   # WHERE oea01 = g_ogb.ogb31
#          #   ##-----No:CHI-A70015 END-----
#          #    IF g_check = 'N' THEN   #無收款
#          #       IF g_oma.oma213 = 'Y' THEN 
#          #          LET g_oma.oma59 = g_oma.oma59 * l_oea262 / l_oea1008
#          #          LET g_oma.oma59t= g_oma.oma59t* l_oea262 / l_oea1008
#          #       ELSE
#          #          LET g_oma.oma59 = g_oma.oma59 * l_oea262 / l_oea61
#          #          LET g_oma.oma59t= g_oma.oma59t* l_oea262 / l_oea61
#          #       END IF
#          #    ELSE                    #有收款
#          #        LET g_oma.oma59 = g_oma.oma59 *(100-g_oma.oma163)/100
#          #        LET g_oma.oma59t= g_oma.oma59t*(100-g_oma.oma163)/100
#          #    END IF
#          #   #IF g_check = 'N' THEN  #無收款
#          #   #    LET g_oma.oma59 = g_oma.oma59 *g_oma.oma162/100
#          #   #    LET g_oma.oma59t= g_oma.oma59t*g_oma.oma162/100
#          #   #ELSE
#          #   #    LET g_oma.oma59 = g_oma.oma59 *(100-g_oma.oma163)/100
#          #   #    LET g_oma.oma59t= g_oma.oma59t*(100-g_oma.oma163)/100
#          #   #END IF
#          # END IF 
#          ##-CHI-A50040-end-
#          ##-CHI-A50040-mark-
#          ###FUN-960140 mod- --str--
#          ##IF g_check = 'N' THEN  #無收款
#          ##    LET g_oma.oma59 = g_oma.oma59 *g_oma.oma162/100
#          ##    LET g_oma.oma59t= g_oma.oma59t*g_oma.oma162/100
#          ##ELSE
#No.TQC-A10118 --begin
#          ##    LET g_oma.oma59 = g_oma.oma59 *(100-g_oma.oma163)/100
#          ##    LET g_oma.oma59t= g_oma.oma59t*(100-g_oma.oma163)/100
#          ##    LET g_oma.oma59 = g_oma.oma59 *(1-g_oma.oma163)/100
#          ##    LET g_oma.oma59t= g_oma.oma59t*(1-g_oma.oma163)/100
#No.TQC-A10118 --end
#          ##END IF
#          ###FUN-960140 mod- --end--
#          ##-CHI-A50040-end-
#          #-TQC-B60089-end-
#           LET g_oma.oma59 = g_oma.oma54 *g_oma.oma58   #TQC-B60089
#           LET g_oma.oma59t= g_oma.oma54t*g_oma.oma58   #TQC-B60089
#       #FUN-960140 end
#       #WHEN g_oma.oma00 = '13'    #FUN-B10058
#       WHEN g_oma00 = '13'         #FUN-B10058
#          #-----No:FUN-A50103-----
#          LET g_oma.oma59  = g_oma.oma54 * g_oma.oma58
#          LET g_oma.oma59t = g_oma.oma54t* g_oma.oma58
#          CALL cl_digcut(g_oma.oma59 ,t_azi04) RETURNING g_oma.oma59
#          CALL cl_digcut(g_oma.oma59t,t_azi04) RETURNING g_oma.oma59t
#         #LET g_oma.oma59 = g_oma.oma59 *g_oma.oma163/100
#         #LET g_oma.oma59t= g_oma.oma59t*g_oma.oma163/100
#         ##-----No:FUN-A50103 END-----
#  END CASE
#  IF g_oma.oma59  IS NULL THEN LET g_oma.oma59 =0 END IF
#  IF g_oma.oma59t IS NULL THEN LET g_oma.oma59t=0 END IF
#  
###-FUN-B40032- ADD - BEGIN ---------------------------------------------------
#  IF g_oma.oma70 = '3' THEN
#     SELECT SUM(omb16),SUM(omb16t) INTO g_oma.oma59,g_oma.oma59t 
#       FROM omb_file 
#      WHERE omb01 = g_omb.omb01
#     IF g_oma.oma00 = '11' AND g_azw.azw04 = '2' AND l_occ73 = 'Y' THEN
#        LET g_oma.oma59x = 0
#        LET g_oma.oma59 = g_oma.oma59t
#     ELSE
#        LET g_oma.oma59x = g_oma.oma59t - g_oma.oma59
#     END IF
#     CALL cl_digcut(g_oma.oma59,t_azi04) RETURNING g_oma.oma59
#     CALL cl_digcut(g_oma.oma59t,t_azi04) RETURNING g_oma.oma59t
#     CALL cl_digcut(g_oma.oma59x,t_azi04) RETURNING g_oma.oma59x
#  ELSE
###-FUN-B40032- ADD -  END  ---------------------------------------------------
#     IF g_oma.oma213='N' THEN 
#        CALL cl_digcut(g_oma.oma59,g_azi04) RETURNING g_oma.oma59   #MOD-760078
#        #IF g_oma.oma00 = '11' THEN   #FUN-960140   #MOD-B30185
#        IF g_oma.oma00 = '11' AND g_azw.azw04 = '2' AND l_occ73 = 'Y' THEN   #MOD-B30185
#           LET g_oma.oma59x = 0
#        ELSE
#           LET g_oma.oma59x=g_oma.oma59*g_oma.oma211/100
#        END IF    #FUN_960140
#        CALL cl_digcut(g_oma.oma59x,g_azi04) RETURNING g_oma.oma59x   #MOD-760078
#        LET g_oma.oma59t=g_oma.oma59+g_oma.oma59x
#     ELSE
#        CALL cl_digcut(g_oma.oma59t,g_azi04) RETURNING g_oma.oma59t   #MOD-760078
#        #IF g_oma.oma00 = '11' THEN   #FUN-960140  #MOD-B30185
#        IF g_oma.oma00 = '11' AND g_azw.azw04 = '2' AND l_occ73 = 'Y' THEN   #MOD-B30185
#           LET g_oma.oma59x = 0
#        ELSE
#           LET g_oma.oma59x=g_oma.oma59t*g_oma.oma211/(100+g_oma.oma211)
#        END IF    #FUN_960140 
#        CALL cl_digcut(g_oma.oma59x,g_azi04) RETURNING g_oma.oma59x   #MOD-760078
#        LET g_oma.oma59 =g_oma.oma59t-g_oma.oma59x
#     END IF
#  END IF            #FUN-B40032 ADD

#  LET g_oma.oma61 = g_oma.oma56t-g_oma.oma57    #bug no:A060 No:8690
#  #No.TQC-5C0086  --Begin                                                                                                          
#  CALL s_ar_oox03(g_oma.oma01) RETURNING g_net                                                                                     
#  LET g_oma.oma61 = g_oma.oma61+g_net                                                                                              
#  #No.TQC-5C0086  --End 
#  #------------------------------------------------------------
#   #No.FUN-B10058 --by elva begin
#   IF g_oma.oma00='19' OR g_oma.oma00='28' THEN
#     LET g_oma.oma54 = 0
#     LET g_oma.oma54x = 0
#     LET g_oma.oma56 = 0
#     LET g_oma.oma56x = 0
#     LET g_oma.oma54t = g_oma.oma73f
#     LET g_oma.oma56t = g_oma.oma73
#   END IF
#   #No.FUN-B10058 --by elva end
#No.TQC-7B0062 --begin
#   CALL cl_digcut(g_oma.oma54t,t_azi04) RETURNING g_oma.oma54t 
#  #CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma54t     #No.TQC-7B0144 mark  
#   CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t     #No.TQC-7B0144 
#No.TQC-7B0062 --end
#   UPDATE oma_file SET
#          oma50=g_oma.oma50,oma50t=g_oma.oma50t,
#          oma73=g_oma.oma73,oma73f=g_oma.oma73f,  #Add No:FUN-AC0025
#          oma52=g_oma.oma52,oma53=g_oma.oma53,
#          oma54=g_oma.oma54,oma54x=g_oma.oma54x,oma54t=g_oma.oma54t,
#          oma56=g_oma.oma56,oma56x=g_oma.oma56x,oma56t=g_oma.oma56t,
#          oma59=g_oma.oma59,oma59x=g_oma.oma59x,oma59t=g_oma.oma59t,
#          oma55=g_oma.oma55,oma57=g_oma.oma57,oma61=g_oma.oma61
#          WHERE oma01=g_oma.oma01
#   #No.+041 010330 by plum
#   #IF STATUS THEN CALL cl_err('upd oma50',STATUS,1)
#    IF STATUS OR SQLCA.SQLCODE THEN
#       CALL cl_err('upd oma50',SQLCA.SQLCODE,1)   #No.FUN-660116
#       CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","upd oma50",1)    #No.FUN-660116  #NO.FUN-710050
#NO.FUN-710050------begin
#       IF g_bgerr THEN
#          CALL s_errmsg('oma01',g_oma.oma11,'upd oma50',SQLCA.SQLCODE,1)
#       ELSE
#          CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","upd oma50",1)
#       END IF
#NO.FUN-710050-------end
#       LET g_success='N' RETURN
#   #No.FUN-680022--begin-- add
#    ELSE
#       CALL s_g_ar_omc()    #No:FUN-A50103
#      ##-----No:FUN-A50103 Mark-----
#      ##--FUN-8C0078 start---
#      #CASE 
#      #  WHEN g_oma.oma00 = '11' 
#      #    IF g_oea.oea918 = 'Y' THEN     #訂金立帳多期
#      #        CALL s_g_ar_omc_1()
#      #    ELSE
#      #        CALL s_g_ar_omc()
#      #    END IF                     
#      #  WHEN g_oma.oma00 = '12'
#      #    CALL s_g_ar_omc()
#      #  WHEN g_oma.oma00 = '13'
#      #    IF g_oea.oea919 = 'Y' THEN     #訂金立帳多期
#      #        CALL s_g_ar_omc_1()
#      #    ELSE
#      #        CALL s_g_ar_omc()
#      #    END IF                      
#      #  WHEN g_oma.oma00 = '21'   #MOD-920366
#      #    CALL s_g_ar_omc()   #MOD-920366
#
#      #END CASE
#      ##CALL s_g_ar_omc()
#      ##--FUN-8C0078 end----------
#      ##-----No:FUN-A50103 Mark END-----
#   #No.FUN-680022--end-- add
#    END IF
#   #No.+041..end
#END FUNCTION
#-------------------------------------------No.CHI-B90025-------------------end-mark
 
FUNCTION s_g_ar_oma_default()
 
   LET g_oma.oma01 = NULL
   LET g_oma.oma08 = '1'
   LET g_oma.oma07 = 'N'
   LET g_oma.oma17 = '1'
   LET g_oma.oma171 = '31'
   LET g_oma.oma172 = '1'
   LET g_oma.oma173 = YEAR(g_oma.oma02)
   LET g_oma.oma174 = MONTH(g_oma.oma02)
   LET g_oma.oma20 = 'Y'
   LET g_oma.oma50 = 0
   LET g_oma.oma50t = 0
   LET g_oma.oma73  = 0  #Add No:FUN-AC0025   #本币代收
   LET g_oma.oma73f = 0  #Add No:FUN-AC0025   #原币代收
   LET g_oma.oma74 = '1' #Add No:FUN-AC0025 
   LET g_oma.oma52 = 0
   LET g_oma.oma53 = 0
   LET g_oma.oma54 = 0
   LET g_oma.oma54x = 0
   LET g_oma.oma54t = 0 
   LET g_oma.oma55 = 0
   LET g_oma.oma56 = 0
   LET g_oma.oma56x = 0
   LET g_oma.oma56t = 0
   LET g_oma.oma57 = 0
   LET g_oma.oma59 = 0
   LET g_oma.oma59x = 0
   LET g_oma.oma61 = 0          #bug no:A060
   LET g_oma.oma59t = 0
   LET g_oma.oma64 = '0'        #No.FUN-9C0014
   LET g_oma.omaconf = 'N'
   LET g_oma.omavoid = 'N'
   LET g_oma.omaprsw = 0
   LET g_oma.omauser = g_user
   LET g_oma.omaoriu = g_user #FUN-980030
   LET g_oma.omaorig = g_grup #FUN-980030
   LET g_oma.omagrup = g_grup
   LET g_oma.omadate = TODAY
END FUNCTION
 
#No.FUN-670026  --start-- 
FUNCTION s_g_ar_12_omb_1()
  DEFINE l_ogb14_ret  LIKE ogb_file.ogb14
  DEFINE l_azf14      LIKE azf_file.azf14   #FUN-BA0109
  DEFINE l_azf141     LIKE azf_file.azf141  #FUN-BA0109
  LET g_omb.omb33 = NULL            #MOD-CA0083
  LET g_omb.omb331 = NULL           #MOD-CA0083  
  LET g_omb.omb38 = '4'                          #出貨返利
  LET g_omb.omb39 = 'N'
  LET g_omb.omb04 = ''
  LET g_omb.omb05 = ''
  LET g_omb.omb06 = ''
  LET g_omb.omb12 = 0
  LET g_omb.omb13 = 0
  LET g_omb.omb15 = 0
  LET g_omb.omb17 = 0
 
  LET g_omb.omb01 = g_oma.oma01
  LET g_omb.omb31 = g_ogb.ogb01
  LET g_omb.omb32 = g_ogb.ogb03

  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN  #No.FUN-9C0014 Add 
  #SELECT SUM(ohb14) INTO l_ogb14_ret FROM ohb_file,oha_file 
  # WHERE oha01 = ohb01 
  #   AND oha09 = '3'
  #   AND ohb31 = g_ogb.ogb01 
  #   AND ohb32 = g_ogb.ogb03 
  #   AND ohaconf = 'Y' 
  #   AND ohapost = 'Y'
  ##No.FUN-9C0014 BEGIN -----
  #ELSE
  #FUN-A60056--mark--end
      #LET g_sql = "SELECT SUM(ohb14) FROM ",l_dbs CLIPPED,"ohb_file,",l_dbs CLIPPED,"oha_file",
      LET g_sql = "SELECT SUM(ohb14) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",", #FUN-A50102
                                            cl_get_target_table(g_plant_new,'oha_file'),     #FUN-A50102
                  " WHERE oha01 = ohb01",
                  "   AND oha09 = '3'",
                  "   AND ohb31 = '",g_ogb.ogb01,"'",
                  "   AND ohb32 = '",g_ogb.ogb03,"'",
                  "   AND ohaconf = 'Y'",
                  "   AND ohapost = 'Y'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102             
      PREPARE sel_oeb_pre54 FROM g_sql
      EXECUTE sel_oeb_pre54 INTO l_ogb14_ret
  #END IF   #FUN-A60056
#No.FUN-9C0014 END -------
   
  IF cl_null(g_ogb.ogb1013) THEN LET g_ogb.ogb1013 = 0 END IF  #MOD-6C0100
  IF cl_null(l_ogb14_ret) THEN LET l_ogb14_ret = 0 END IF  #MOD-6C0100
 #IF g_oma.oma00='12' THEN             #CHI-A50040 mark
     LET g_omb.omb14 = g_ogb.ogb14 - g_ogb.ogb1013 - l_ogb14_ret
 #ELSE                                 #CHI-A50040 mark
 #   LET g_omb.omb14 = g_ogb.ogb14     #CHI-A50040 mark
 #END IF                               #CHI-A50040 mark
  #FUN-C60036--add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
        SELECT omf28,omf917,omf29,omf29t INTO 
            g_omb.omb13,g_omb.omb12,g_omb.omb14,g_omb.omb14t FROM omf_file 
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00   #minpp  add
           AND omf02 = g_omf02
           AND omf12 = g_ohb.ohb03
           AND omf11 = g_ohb.ohb01
           AND omf04 IS NULL
           AND omf09 = l_azp01
     END IF 
     #FUN-C60036--add--end
  CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
  LET g_omb.omb14 = g_omb.omb14 * (-1)
 
 
 #IF g_oma.oma213 = 'N'  THEN     #No.TQC-6C0085 mark
     LET g_omb.omb14t = g_omb.omb14 * (1 + g_oma.oma211/100)
     CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t   #MOD-760078
 #No.TQC-6C0085--begin-- mark
 #ELSE 
 #   IF g_omb.omb12 != 0 THEN
 #      LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
 #   END IF
 #   CALL cl_digcut(g_omb.omb14t,g_azi04)RETURNING g_omb.omb14t
 #END IF
 #No.TQC-6C0085--end-- mark
  #Add No:FUN-AC0025
  LET g_omb.omb45 = g_ogb.ogb49    #商户编号
#by elva mark begin
# IF g_oma.oma74 ='2' THEN
#    LET g_omb.omb14 = g_omb.omb14t  #omb16,omb18不用再复制，根据后面的计算公式，含税和未税值是一样的
# END IF
#by elva mark end
  #End Add No:FUN-AC0025
  LET g_omb.omb16 =g_omb.omb14 *g_oma.oma24
  LET g_omb.omb16t=g_omb.omb14t*g_oma.oma24
  LET g_omb.omb18 =g_omb.omb14 *g_oma.oma58
  LET g_omb.omb18t=g_omb.omb14t*g_oma.oma58
  CALL cl_digcut(g_omb.omb16, g_azi04) RETURNING g_omb.omb16   #MOD-760078
  CALL cl_digcut(g_omb.omb16t,g_azi04) RETURNING g_omb.omb16t  #MOD-760078
  CALL cl_digcut(g_omb.omb18, g_azi04) RETURNING g_omb.omb18   #MOD-760078
  CALL cl_digcut(g_omb.omb18t,g_azi04) RETURNING g_omb.omb18t  #MOD-760078
 
  MESSAGE g_omb.omb03,' ',g_omb.omb14
  LET g_omb.omb36 = g_oma.oma24     
  LET g_omb.omb37 = g_omb.omb16t-g_omb.omb35  
  LET g_omb.omb34 = 0 
  LET g_omb.omb40 = g_ogb.ogb1001  #No.TQC-6C0085
  LET g_omb.omb35 = 0 
  LET g_omb.omb930=g_ogb.ogb930 #FUN-680001
  LET g_omb.omb00 = g_oma.oma00   #MOD-6A0102
 #FUN-810045 begin
  LET g_omb.omb41 = g_ogb.ogb41
  LET g_omb.omb42 = g_ogb.ogb42
  IF NOT cl_null(g_omb.omb40) THEN
  #No.FUN-9C0014 BEGIN -----
     IF cl_null(l_dbs) THEN
     SELECT azf14,azf141 INTO l_azf14,l_azf141
       FROM azf_file
      WHERE azf01=g_omb.omb40 AND azf02='2' AND azfacti='Y'
     ELSE
        #LET g_sql = "SELECT azf14 FROM ",l_dbs CLIPPED,"azf_file",
        LET g_sql = "SELECT azf14,azf141 FROM ",cl_get_target_table(g_plant_new,'azf_file'), #FUN-A50102 #FUN-BA0109 add azf141
                    " WHERE azf01='",g_omb.omb40,"' AND azf02='2' AND azfacti='Y'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102            
        PREPARE sel_azf_pre55 FROM g_sql
        EXECUTE sel_azf_pre55 INTO l_azf14,l_azf141      #FUN-BA0109
     END IF
     
  #No.FUN-9C0014 END -------
  END IF
  IF NOT cl_null(l_azf14) THEN LET g_omb.omb33=l_azf14 END IF           #FUN-BA0109
  IF g_aza.aza63='Y' AND cl_null(g_omb.omb331) THEN
     #LET g_omb.omb331 = g_omb.omb33                                    #FUN-BA0109
     IF NOT cl_null(l_azf141) THEN LET g_omb.omb331=l_azf141 END IF     #FUN-BA0109
  END IF	
  #Add No:FUN-AC0025
  IF g_oma.oma74='2' THEN
     SELECT ool36 INTO g_omb.omb33 FROM ool_file
      WHERE ool01=g_oma.oma13
     IF g_aza.aza63 = 'Y' THEN
        SELECT ool361 INTO g_omb.omb331 FROM ool_file
         WHERE ool01=g_oma.oma13
     END IF
  END IF
  #End Add No:FUN-AC0025
  
 
  LET g_omb.omblegal = g_legal #FUN-980011 add
 
 #FUN-810045 end
  LET g_omb.omb44 = g_ogb.ogbplant    #FUN-9A0093
  #FUN-C60036--add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
        IF cl_null(g_ogb.ogb01) THEN#FUN-D40067 add
          #SELECT omf19,omf19t INTO g_omb.omb16,g_omb.omb16t#FUN-D40067 mark
       #FUN-D40067--add--str
        SELECT omf19,omf19t,omf29,omf29t INTO g_omb.omb16,g_omb.omb16t,g_omb.omb14,g_omb.omb14t #FUN-D40067 add
          FROM omf_file
           WHERE omf00 = g_omf00
            AND omf21 = g_ogb03
        ELSE
       #FUN-D40067--add--end
       #SELECT omf19,omf19t INTO g_omb.omb16,g_omb.omb16t#FUN-D40067 mark
           SELECT omf19,omf19t,omf29,omf29t INTO g_omb.omb16,g_omb.omb16t,g_omb.omb14,g_omb.omb14t #FUN-D40067 add
          FROM omf_file
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00
           AND omf02 = g_omf02
           AND omf12 = g_ogb.ogb03
           AND omf11 = g_ogb.ogb01
           AND omf04 IS NULL
           AND omf09 = l_azp01
        END IF #FUN-D40067 add           
        LET g_omb.omb18 = g_omb.omb16
        LET g_omb.omb18t = g_omb.omb16t
     END IF
     CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16
     CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t
     CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18
     CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t
     CALL cl_digcut(g_omb.omb14,t_azi04)RETURNING g_omb.omb14#FUN-D40067 add
     CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t#FUN-D40067 add     
  #FUN-C60036--add--end
  LET g_omb.omb48 = 0   #FUN-D10101 add
  INSERT INTO omb_file VALUES(g_omb.*)
 #IF STATUS OR SQLCA.SQLCODE THEN #MOD-6C0100
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
#    CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.SQLCODE,"","ins omb",1)    #No.FUN-660116  #NO.FUN-710050
#NO.FUN-710050------begin
  IF g_bgerr THEN
     LET g_showmsg=g_omb.omb01,"/",g_omb.omb03
     CALL s_errmsg('omb01,omb03',g_showmsg,"ins omb",SQLCA.SQLCODE,1)
  ELSE
     CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.SQLCODE,"","ins omb",1)
  END IF
#NO.FUN-710050-------end
     LET g_success='N' 
  END IF
END FUNCTION
 
FUNCTION s_g_ar_21_omb_1()
   DEFINE l_omb18t   LIKE omb_file.omb18t
   DEFINE l_amt      LIKE omb_file.omb18t
   DEFINE l_qty      LIKE omb_file.omb12 
   DEFINE p_flag     LIKE type_file.chr1        #No.FUN-680123 VARCHAR(01)
   DEFINE p_qty      LIKE omb_file.omb12
   DEFINE l_qty2     LIKE omb_file.omb12
   DEFINE l_azf14    LIKE azf_file.azf14   #FUN-BA0109
   DEFINE l_azf141   LIKE azf_file.azf141  #FUN-BA0109
   LET g_omb.omb33 = NULL            #MOD-CA0083
   LET g_omb.omb331 = NULL           #MOD-CA0083s  
   LET g_omb.omb38 = '5'                         #返利退回                                                                          
   LET g_omb.omb39 = 'N'                                                                                                             
   LET g_omb.omb04 = ''                                                                                                              
   LET g_omb.omb05 = ''                                                                                                              
   LET g_omb.omb06 = ''                                                                                                              
   LET g_omb.omb12 = 0                                                                                                               
   LET g_omb.omb13 = 0                                                                                                               
   LET g_omb.omb15 = 0                                                                                                               
   LET g_omb.omb17 = 0        
   LET g_omb.omb01 = g_oma.oma01
   LET g_omb.omb31 = g_ohb.ohb01
   LET g_omb.omb32 = g_ohb.ohb03
   LET g_omb.omb14 = g_ohb.ohb14 - g_ohb.ohb1012   
   LET g_omb.omb14t= g_ohb.ohb14t
   CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
   LET g_omb.omb14 = g_omb.omb14 * (-1)       
 
   IF g_oma.oma213 = 'N' THEN
      LET g_omb.omb14t = g_omb.omb14 * (1+g_oma.oma211/100)
      CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t   #MOD-760078
   ELSE 
      IF g_omb.omb12 > 0 THEN
         LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
      END IF
      CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t   #MOD-760078
      LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100)
      CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   #MOD-760078
   END IF
  #FUN-C60036--add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
        SELECT omf28,omf917,omf29,omf29t INTO 
            g_omb.omb13,g_omb.omb12,g_omb.omb14,g_omb.omb14t FROM omf_file 
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00   #minpp  add
           AND omf02 = g_omf02
           AND omf12 = g_ohb.ohb03
           AND omf11 = g_ohb.ohb01
           AND omf04 IS NULL
           AND omf09 = l_azp01
     END IF 
     #FUN-C60036--add--end
   #Add No:FUN-AC0025
   LET g_omb.omb45 = g_ohb.ohb70    #商户编号
#by elva mark begin
#  IF g_oma.oma74 ='2' THEN
#     LET g_omb.omb14 = g_omb.omb14t  #omb16,omb18不用再复制，根据后面的计算公式，含税和未税值是一样的
#  END IF
#by elva mark end
   #End Add No:FUN-AC0025
   LET g_omb.omb16 =g_omb.omb14 *g_oma.oma24
   LET g_omb.omb16t=g_omb.omb14t*g_oma.oma24
   LET g_omb.omb18 =g_omb.omb14 *g_oma.oma58
   LET g_omb.omb18t=g_omb.omb14t*g_oma.oma58
   CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16   #MOD-760078
   CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t  #MOD-760078
   CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18   #MOD-760078
   CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t  #MOD-760078
 
   MESSAGE g_omb.omb03,' ',g_omb.omb14
   LET g_omb.omb36 = g_oma.oma24                
   LET g_omb.omb37 = g_omb.omb16t - g_omb.omb35  
   LET g_omb.omb34 = 0 
   LET g_omb.omb35 = 0 
   LET g_omb.omb930=g_ohb.ohb930 #FUN-680001
   #FUN-810045 add begin
    #由 ohb33/34 訂單單號/序號回訂單抓專案相關欄位
#FUN-A60056--mod--str--
#    #No.FUN-9C0014 BEGIN -----
#    SELECT oeb41,oeb42,oeb1001 INTO g_omb.omb41,g_omb.omb42,g_omb.omb40
#      FROM oeb_file 
##      WHERE oeb01 = g_ohb.ofb33 AND oeb03 = g_ohb.ofb34
#      WHERE oeb01 =  g_ohb.ohb33 AND oeb03 = g_ohb.ohb34    #NO.MOD-930202
     LET g_sql = "SELECT oeb41,oeb42,oeb1001 ",
                 "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'),             
                 " WHERE oeb01 = '",g_ohb.ohb33,"'",
                 "   AND oeb03 = '",g_ohb.ohb34,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
     PREPARE sel_oeb41 FROM g_sql
     EXECUTE sel_oeb41 INTO g_omb.omb41,g_omb.omb42,g_omb.omb40
#FUN-A60056--mod--end
     IF NOT cl_null(g_omb.omb40) THEN
        #SELECT azf14 INTO g_omb.omb33                  #FUN-BA0109
        SELECT azf14,azf141 INTO l_azf14,l_azf141      #FUN-BA0109
          FROM azf_file
         WHERE azf01=g_omb.omb40 AND azf02='2' AND azfacti='Y'
     END IF
     IF NOT cl_null(l_azf14) THEN LET g_omb.omb33=l_azf14 END IF           #FUN-BA0109
     IF g_aza.aza63='Y' AND cl_null(g_omb.omb331) THEN
  	#LET g_omb.omb331 = g_omb.omb33                                    #FUN-BA0109
        IF NOT cl_null(l_azf141) THEN LET g_omb.omb331=l_azf141 END IF     #FUN-BA0109
     END IF
     #Add No:FUN-AC0025
     IF g_oma.oma74='2' THEN
        SELECT ool36 INTO g_omb.omb33 FROM ool_file
         WHERE ool01=g_oma.oma13
        IF g_aza.aza63 = 'Y' THEN
           SELECT ool361 INTO g_omb.omb331 FROM ool_file
            WHERE ool01=g_oma.oma13
        END IF
     END IF
     #End Add No:FUN-AC0025
 
   #FUN-810045 add end 
 
   LET g_omb.omblegal = g_legal #FUN-980011 add
   LET g_omb.omb44 = g_ohb.ohbplant    #FUN-9A0093
   #FUN-C60036--add--str
     IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
        SELECT omf19,omf19t INTO g_omb.omb16,g_omb.omb16t
          FROM omf_file
         WHERE omf01 = g_omf01
           AND omf00 = g_omf00
           AND omf02 = g_omf02
           AND omf12 = g_ohb.ohb03
           AND omf11 = g_ohb.ohb01
           AND omf04 IS NULL
           AND omf09 = l_azp01
        LET g_omb.omb18 = g_omb.omb16
        LET g_omb.omb18t = g_omb.omb16t
     END IF
     CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16
     CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t
     CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18
     CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t
   #FUN-C60036--add--end
   LET g_omb.omb48 = 0   #FUN-D10101 add
   INSERT INTO omb_file VALUES(g_omb.*)
  #IF STATUS OR SQLCA.SQLCODE THEN   #MOD-6C0100
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
#     CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.sqlcode,"","ins omb",1)       #NO.FUN-710050 
#NO.FUN-710050------begin
  IF g_bgerr THEN
     LET g_showmsg=g_omb.omb01,"/",g_omb.omb03
     CALL s_errmsg('omb01,omb03',g_showmsg,"ins omb",SQLCA.SQLCODE,1)
  ELSE
     CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.sqlcode,"","ins omb",1)
  END IF
#NO.FUN-710050-------end
      LET g_success='N'
    #FUN-C60036--add--str
  ELSE 
      IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
         UPDATE omf_file SET omf04 = g_oma.oma01 
          WHERE omf01 = g_omf01
           AND omf00 = g_omf00   #minpp  add
           AND omf02 = g_omf02
           AND omf11 = g_oha.oha01
           AND omf12 = g_ohb.ohb03
         IF STATUS OR SQLCA.SQLCODE THEN
            LET g_showmsg=g_oma.oma10,"/",g_oma.oma75                                             
            CALL s_errmsg('omf01,omf02',g_showmsg,"upd omf",SQLCA.SQLCODE,1)                       
            LET g_success='N'
         END IF
      END IF 
      #FUN-C60036--add--end
   END IF
END FUNCTION
 
#No.FUN-670026  --end--   
 
#No.FUN-680022--begin-- add
FUNCTION s_g_ar_omc()
   DEFINE l_oas          RECORD LIKE oas_file.*
   DEFINE l_omc          RECORD LIKE omc_file.*
   DEFINE l_oas02        LIKE oas_file.oas02
   DEFINE l_n            LIKE type_file.num5                #No.FUN-680123 SMALLINT
   DEFINE l_oea02        LIKE oea_file.oea02 
   DEFINE l_omc08        LIKE omc_file.omc08                #No.TQC-7B0082
   DEFINE l_omc09        LIKE omc_file.omc09                #No.TQC-7B0082

   #No.FUN-9C0014 BEGIN ----- 
   IF cl_null(l_dbs) THEN
      SELECT DISTINCT(oas02) INTO l_oas02 FROM oas_file WHERE oas01=g_oma.oma32
   ELSE
      #LET g_sql = "SELECT DISTINCT(oas02) FROM ",l_dbs CLIPPED,"oas_file WHERE oas01='",g_oma.oma32,"'"
      #LET g_sql = "SELECT DISTINCT(oas02) FROM ",l_dbs CLIPPED,
      LET g_sql = "SELECT DISTINCT(oas02) FROM ",cl_get_target_table(g_plant_new,'oas_file'), #FUN-A50102
                  " WHERE oas01='",g_oma.oma32,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE sel_oas_pre56 FROM g_sql
      EXECUTE sel_oas_pre56 INTO l_oas02
   END IF
   #No.FUN-9C0014 END -------
   INITIALIZE l_omc.* TO NULL

 # IF l_oas02='1' AND g_oma.oma00 != '21' THEN
   IF l_oas02='1' AND g_oma.oma00 != '21' AND g_oma.oma00 <>'11' AND g_oma.oma00<>'13' AND g_oma.oma00<>'28' THEN    #No:FUN-A50103  #FUN-B10058 add 28
      LET l_n=1
     #FUN-A60056--mod--str--
     #SELECT oea02 INTO l_oea02 FROM oea_file
     # WHERE oea01 = g_oma.oma16
      LET g_sql = "SELECT oea02 FROM ",cl_get_target_table(g_plant_new,'oea_file'),
                  " WHERE oea01 = '",g_oma.oma16,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE sel_oea02 FROM g_sql
      EXECUTE sel_oea02 INTO l_oea02
     #FUN-A60056--mod--end
      IF cl_null(l_oea02) THEN
         LET l_oea02 = g_oma.oma02
      END IF
   #No.FUN-9C0014 BEGIN -----
   #  DECLARE s_g_ar_cs1 CURSOR FOR 
   #    SELECT * FROM oas_file WHERE oas01=g_oma.oma32
      IF cl_null(l_dbs) THEN
         LET g_sql = "SELECT * FROM oas_file WHERE oas01='",g_oma.oma32,"'"
      ELSE
         #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oas_file WHERE oas01='",g_oma.oma32,"'"
         LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oas_file'), #FUN-A50102
                     " WHERE oas01='",g_oma.oma32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      END IF
      PREPARE sel_oas_pre57 FROM g_sql
      DECLARE s_g_ar_cs1 CURSOR FOR sel_oas_pre57
   #No.FUN-9C0014 END -------
      FOREACH s_g_ar_cs1 INTO l_oas.*
        LET l_omc.omc01=g_oma.oma01
        LET l_omc.omc02=l_n
        LET l_omc.omc03=l_oas.oas04
        CALL s_rdatem(g_oma.oma03,l_omc.omc03,g_oma.oma02,g_oma.oma09,
                      #l_oea02,g_dbs)    #No.FUN-680022 add oma02   #TQC-680074
                      #l_oea02,g_dbs2)   #No.FUN-680022 add oma02   #TQC-680074 #FUN-980020 mark
                      #l_oea02,g_plant2)  #FUN-980020   #MOD-D10067 mark
                      l_oea02,g_plant_new)  #FUN-980020    #MOD-D10067
             RETURNING l_omc.omc04,l_omc.omc05
        LET l_omc.omc06=g_oma.oma24
        LET l_omc.omc07=g_oma.oma60
        LET l_omc.omc08=g_oma.oma54t*(l_oas.oas05/100)
        CALL cl_digcut(l_omc.omc08,t_azi04) RETURNING l_omc.omc08   #MOD-760078
        LET l_omc.omc09=g_oma.oma56t*(l_oas.oas05/100)
        CALL cl_digcut(l_omc.omc09,g_azi04) RETURNING l_omc.omc09
        LET l_omc.omc10=0
        CALL cl_digcut(l_omc.omc10,t_azi04) RETURNING l_omc.omc10   #MOD-760078
        LET l_omc.omc11=0
        CALL cl_digcut(l_omc.omc11,g_azi04) RETURNING l_omc.omc11
        LET l_omc.omc12=g_oma.oma10
        LET l_omc.omc13=l_omc.omc09-l_omc.omc11
        LET l_omc.omc14=0
        LET l_omc.omc15=0
        LET l_omc.omclegal = g_legal #FUN-980011 add
        INSERT INTO omc_file VALUES (l_omc.*)
       #IF SQLCA.sqlcode THEN  #MOD-6C0100
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
#          CALL cl_err3("ins","omc_file",g_oma.oma32,"",SQLCA.sqlcode,"","insert omc_file",1)     #NO.FUN-710050
           #NO.FUN-710050------begin
           IF g_bgerr THEN
              LET g_showmsg=l_omc.omc01,"/",l_omc.omc02
              CALL s_errmsg('omc01,omc02',g_showmsg,"insert omc_file",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("ins","omc_file",g_oma.oma32,"",SQLCA.sqlcode,"","insert omc_file",1)
           END IF
           #NO.FUN-710050-------end            
           LET g_success='N'
           EXIT FOREACH
        ELSE
           LET l_n=l_n+1 
        END IF
      END FOREACH
   END IF

   #No.TQC-7B0082 --begin   
   SELECT SUM(omc08),SUM(omc09) INTO l_omc08,l_omc09 FROM omc_file
    WHERE omc01 = g_oma.oma01

   IF (l_omc08 - g_oma.oma54t) <>0 OR (l_omc09 - g_oma.oma56t) <>0 THEN
      UPDATE omc_file SET omc08 =omc08 - l_omc08 + g_oma.oma54t,
                          omc09 =omc09 - l_omc09 + g_oma.oma56t
       WHERE omc01 =g_oma.oma01
         AND omc02 =l_omc.omc02
   END IF

   #No.TQC-7B0082 --end
 # IF l_oas02='2' OR cl_null(l_oas.oas02) OR g_oma.oma00='21' THEN 
   IF l_oas02='2' OR cl_null(l_oas.oas02) OR g_oma.oma00='21'
      OR g_oma.oma00='11' OR g_oma.oma00='13' OR g_oma.oma00='28' THEN     #No:FUN-A50103 #FUN-B10058 add 28
      LET l_omc.omc01=g_oma.oma01
      LET l_omc.omc02='1'
      LET l_omc.omc03=g_oma.oma32
      LET l_omc.omc04=g_oma.oma11
      LET l_omc.omc05=g_oma.oma12
      LET l_omc.omc06=g_oma.oma24
      LET l_omc.omc07=g_oma.oma60
      LET l_omc.omc08=g_oma.oma54t
      CALL cl_digcut(l_omc.omc08,t_azi04) RETURNING l_omc.omc08   #MOD-760078
      LET l_omc.omc09=g_oma.oma56t
      CALL cl_digcut(l_omc.omc09,g_azi04) RETURNING l_omc.omc09
      LET l_omc.omc10=0
      CALL cl_digcut(l_omc.omc10,t_azi04) RETURNING l_omc.omc10   #MOD-760078
      LET l_omc.omc11=0
      CALL cl_digcut(l_omc.omc11,g_azi04) RETURNING l_omc.omc11
      LET l_omc.omc12=g_oma.oma10
      LET l_omc.omc13=l_omc.omc09-l_omc.omc11
      LET l_omc.omc14=0
      LET l_omc.omc15=0
      LET l_omc.omclegal = g_legal #FUN-980011 add
      INSERT INTO omc_file VALUES (l_omc.*)
     #IF SQLCA.sqlcode THEN   #MOD-6C0100
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
#        CALL cl_err3("ins","omc_file",g_oma.oma32,"",SQLCA.sqlcode,"","insert omc_file",1)      #NO.FUN-710050
         #NO.FUN-710050------begin
         IF g_bgerr THEN
            LET g_showmsg=l_omc.omc01,"/",l_omc.omc02
            CALL s_errmsg('omc01,omc02',g_showmsg,"insert omc_file",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","omc_file",g_oma.oma32,"",SQLCA.sqlcode,"","insert omc_file",1)
         END IF
         #NO.FUN-710050-------end            
         LET g_success='N'
      END IF 
   END IF

END FUNCTION 
#No.FUN-680022--end-- add
 
#--FUN-8C0078 start----  #訂金立帳多期
FUNCTION s_g_ar_omc_1()
DEFINE   l_oas          RECORD LIKE oas_file.*
DEFINE   l_omc          RECORD LIKE omc_file.*
DEFINE   l_oas02        LIKE oas_file.oas02
DEFINE   l_n            LIKE type_file.num5                #No.FUN-680123 SMALLINT
DEFINE   l_oea02        LIKE oea_file.oea02 
DEFINE   l_omc08        LIKE omc_file.omc08                #No.TQC-7B0082
DEFINE   l_omc09        LIKE omc_file.omc09                #No.TQC-7B0082
 
    LET l_oas.* = g_oas.*
#No.FUN-9C0014 BEGIN -----
#   SELECT DISTINCT(oas02) INTO l_oas02 FROM oas_file WHERE oas01=g_oma.oma32
    IF cl_null(l_dbs) THEN
       SELECT DISTINCT(oas02) INTO l_oas02 FROM oas_file WHERE oas01=g_oma.oma32
    ELSE
       #LET g_sql = "SELECT DISTINCT(oas02) FROM ",l_dbs CLIPPED,"oas_file WHERE oas01='",g_oma.oma32,"'"
       LET g_sql = "SELECT DISTINCT(oas02) FROM ",cl_get_target_table(g_plant_new,'oas_file'), #FUN-A50102
                   " WHERE oas01='",g_oma.oma32,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE sel_oas_pre58 FROM g_sql
       EXECUTE sel_oas_pre58 INTO l_oas02
    END IF
#No.FUN-9C0014 END -------
    INITIALIZE l_omc.* TO NULL
    IF l_oas02='1' AND g_oma.oma00 != '21' THEN
       LET l_n=1
    #No.FUN-9C0014 BEGIN -----
    #  SELECT oea02 INTO l_oea02 FROM oea_file
    #   WHERE oea01 = g_oma.oma16
      #FUN-A60056--mark--str--
      #IF cl_null(l_dbs) THEN
      #   SELECT oea02 INTO l_oea02 FROM oea_file
      #    WHERE oea01 = g_oma.oma16
      #ELSE
      #FUN-A60056--mark--end
          #LET g_sql = "SELECT oea02 FROM ",l_dbs CLIPPED,"oea_file",
          LET g_sql = "SELECT oea02 FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
                      " WHERE oea01 = '",g_oma.oma16,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102            
          PREPARE sel_oea_pre59 FROM g_sql
          EXECUTE sel_oea_pre59 INTO l_oea02
      #END IF   #FUN-A60056
    #No.FUN-9C0014 END -------
       IF cl_null(l_oea02) THEN
          LET l_oea02 = g_oma.oma02
       END IF
       LET l_omc.omc01=g_oma.oma01
       LET l_omc.omc02=l_n
       LET l_omc.omc03=l_oas.oas04
       CALL s_rdatem(g_oma.oma03,l_omc.omc03,g_oma.oma02,g_oma.oma09,
                     #l_oea02,g_dbs)   #No.FUN-680022 add oma02 #TQC-680074
                     #l_oea02,g_dbs2)  #No.FUN-680022 add oma02 #TQC-680074 #FUN-980020 mark
                     #l_oea02,g_plant2) #FUN-980020   #MOD-D10067 mark
                     l_oea02,g_plant_new)             #MOD-D10067
            RETURNING l_omc.omc04,l_omc.omc05
       LET l_omc.omc06=g_oma.oma24
       LET l_omc.omc07=g_oma.oma60
       LET l_omc.omc08=g_oma.oma54t
       CALL cl_digcut(l_omc.omc08,t_azi04) RETURNING l_omc.omc08   #MOD-760078
       LET l_omc.omc09=g_oma.oma56t
       CALL cl_digcut(l_omc.omc09,g_azi04) RETURNING l_omc.omc09
       LET l_omc.omc10=0
       CALL cl_digcut(l_omc.omc10,t_azi04) RETURNING l_omc.omc10   #MOD-760078
       LET l_omc.omc11=0
       CALL cl_digcut(l_omc.omc11,g_azi04) RETURNING l_omc.omc11
       LET l_omc.omc12=g_oma.oma10
       LET l_omc.omc13=l_omc.omc09-l_omc.omc11
       LET l_omc.omc14=0
       LET l_omc.omc15=0
       LET l_omc.omclegal = g_legal #FUN-980011 add
       INSERT INTO omc_file VALUES (l_omc.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
             IF g_bgerr THEN
                LET g_showmsg=l_omc.omc01,"/",l_omc.omc02
                CALL s_errmsg('omc01,omc02',g_showmsg,"insert omc_file",SQLCA.sqlcode,1)
             ELSE
                CALL cl_err3("ins","omc_file",g_oma.oma32,"",SQLCA.sqlcode,"","insert omc_file",1)
             END IF
             LET g_success='N'
         END IF
    END IF
    SELECT SUM(omc08),SUM(omc09) INTO l_omc08,l_omc09 FROM omc_file
     WHERE omc01 = g_oma.oma01
    IF (l_omc08 - g_oma.oma54t) <>0 OR (l_omc09 - g_oma.oma56t) <>0 THEN
    UPDATE omc_file SET omc08 =omc08 - l_omc08 + g_oma.oma54t,
                        omc09 =omc09 - l_omc09 + g_oma.oma56t
     WHERE omc01 =g_oma.oma01
       AND omc02 =l_omc.omc02
    END IF
    IF l_oas02='2' OR cl_null(l_oas.oas02) OR g_oma.oma00='21' THEN 
       LET l_omc.omc01=g_oma.oma01
       LET l_omc.omc02='1'
       LET l_omc.omc03=g_oma.oma32
       LET l_omc.omc04=g_oma.oma11
       LET l_omc.omc05=g_oma.oma12
       LET l_omc.omc06=g_oma.oma24
       LET l_omc.omc07=g_oma.oma60
       LET l_omc.omc08=g_oma.oma54t
       CALL cl_digcut(l_omc.omc08,t_azi04) RETURNING l_omc.omc08   #MOD-760078
       LET l_omc.omc09=g_oma.oma56t
       CALL cl_digcut(l_omc.omc09,g_azi04) RETURNING l_omc.omc09
       LET l_omc.omc10=0
       CALL cl_digcut(l_omc.omc10,t_azi04) RETURNING l_omc.omc10   #MOD-760078
       LET l_omc.omc11=0
       CALL cl_digcut(l_omc.omc11,g_azi04) RETURNING l_omc.omc11
       LET l_omc.omc12=g_oma.oma10
       LET l_omc.omc13=l_omc.omc09-l_omc.omc11
       LET l_omc.omc14=0
       LET l_omc.omc15=0
       LET l_omc.omclegal = g_legal #FUN-980011 add
       INSERT INTO omc_file VALUES (l_omc.*)
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN #MOD-6C0100
         IF g_bgerr THEN
            LET g_showmsg=l_omc.omc01,"/",l_omc.omc02
            CALL s_errmsg('omc01,omc02',g_showmsg,"insert omc_file",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","omc_file",g_oma.oma32,"",SQLCA.sqlcode,"","insert omc_file",1)
         END IF
         LET g_success='N'
       END IF 
    END IF
END FUNCTION 
#--FUN-8C0078 end-------------------------
#No.FUN-9C0072 精簡程式碼
