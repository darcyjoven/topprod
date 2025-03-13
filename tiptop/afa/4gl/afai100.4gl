# Prog. Version..: '5.30.06-13.04.10(00010)'     #
#
# Pattern name...: afai100.4gl
# Descriptions...: 固定資產維護作業
# Date & Author..: 96/05/17 By Sophia
# Date & Modify..: 02/10/15 BY MAGGIE   No.A032
# Date & Modify..: #03/07/17 By Wiky#No:7620 控管要在分攤部門為1的faj24地方控管
# Modify.........: No:A086 04/06/23 By Danny 增加自動編碼
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470515 04/07/23 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-480005 04/08/12 By Nicola 複製加上錯誤訊息提示
# Modify.........: No.MOD-490214 04/09/21 By Yuna
#                     改為依faj23不同:1的時候開q_gem;
#                     2的時候將右邊有的功能鍵分攤類別查詢放在開窗的功能中,並將此功能鍵拿掉
# Modify.........: No.MOD-4A0062 Kammy 資產類別若未修改，仍要抓g_fab13出來，方便後續利用
# Modify.........: No.MOD-4A0186 BY Kitty UPDATE的sqlerrd[3]=0的判斷都拿掉
# Modify.........: No.MOD-4B0094 04/11/16 By Nicola 財產編號為空白時，應不可確認
# Modify.........: No.MOD-4C0020 04/12/03 By Mandy 在資料1掛入一個相關文件,但是在查詢時所有的資產的相關文件,都可看到這個相關文件
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-510173 05/01/28 By kitty 將4gl的中文字改到za
# Modify.........: No.MOD-530231 05/04/18 By Smapmin 輸入折舊科目存檔後再進入隨便選任一頁簽切換後,此欄位資料會消失...
# Modify.........: No.MOD-530114 05/04/19 By Niocla 判斷欄位不可空白
# Modify.........: No.MOD-550059 05/05/23 By ching  修改不可更動key value
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: No.MOD-560088 05/06/28 By day    將序號自動編號改為確定存入時再取號
# Modify.........: No.FUN-570197 05/08/02 By Sarah 新增一action'其他資料', 則可修改該頁簽資料
# Modify.........: No.MOD-570148 05/08/08 By Smapmin 輸入類別後自動帶出科目資料
# Modify.........: No.MOD-580279 05/08/29 By Smapmin 複製時,財產編號欄位無法進入.
#                                                    新增時，稅簽的本期累折與本期銷帳累折要預設為零.
#                                                    所有金額的欄位要依幣別做取位的動作
# Modify.........: No.FUN-5B0099 05/11/22 By Smapmin 若faj43='4' and 未折減額=預留殘值,faj43不update='1'
# Modify.........: No.FUN-5B0050 05/11/29 By Sarah 當faj42(投資抵減否)不為0或1時,不得取消確認
# Modify.........: No.MOD-610015 06/01/05 By Smapmin 列印備註資料
# Modify.........: No.MOD-610119 06/01/20 By Smapmin 取消確認時,要以本張單子判斷是否為直接資本化
# Modify.........: No.TQC-630004 06/03/06 By Smapmin 資產狀態已無'C'這個選項,故相關程式予以修正
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.MOD-670118 06/07/27 By Smapmin 取得與入帳日期要即時變更
# Modify.........: No.FUN-680028 06/08/22 By day 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-690024 06/09/19 By jamie 判斷pmcacti
# Modify.........: No.TQC-690099 06/09/25 By Tracy 增加faj108,faj109兩個欄位
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i100_q() 一開始應清空g_faj.*值
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.TQC-680123 06/12/05 By Smapmin 增加最近折舊年度與期別二個欄位
# Modify.........: No.MOD-690002 06/12/05 By Smapmin AFTER INPUT段也要判斷分攤方式與分攤部門/類別的正確性
# Modify.........: No.MOD-690077 06/12/05 By Smapmin 手動輸入的序號不可重複
# Modify.........: No.MOD-690087 06/12/05 By Smapmin 序號必須為數字
# Modify.........: No.TQC-6C0009 06/12/06 By Rayven 打印沒有‘接下頁’和‘結束’
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-710112 07/03/26 By Judy 頁簽一般資料/稅簽資料,數字欄位控管
# MOdify.........: No.MOD-730111 07/03/28 By Smapmin 當財產編號不為空白時,才會CHECK是否與底稿財產編號相同
# MOdify.........: No.FUN-740026 07/04/10 By sherry  會計科目加帳套
# MOdify.........: No.TQC-740055 07/04/16 By Xufeng  錄入時候，序號只可以輸入數字類型，但是復制過來的可以輸入其他類型的符號
# Modify.........: No.TQC-740137 07/04/22 By Carrier aag00取aza81/aza82,不用s_get_bookno來取帳套了
# Modify.........: No.MOD-750008 07/05/04 By Smapmin 修改耐用年限與未用年限default問題
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760047 07/06/13 By Smapmin 刪除要回寫fak91時,除判斷fak02/fak022之外,亦需判斷fak90/fak901
# Modify.........: No.MOD-760120 07/06/26 By Smapmin 幣別為本國幣時,原幣與本幣成本必須相等
# Modify.........: No.MOD-790134 07/07/26 By destiny 報表改為使用crystal report
# Modify.........: No.MOD-780116 07/08/17 By Smapmin faj13/faj35/faj108/faj109依本幣取位
# Modify.........: No.MOD-780111 07/08/20 By Smapmin 修改afa-047/afa-048提示訊息顯示時機
# Modify.........: No.TQC-7B0052 07/11/12 By xufeng  把類型改為"主件"時,附號沒有清空
# Modify.........: No.TQC-7B0056 07/11/12 By Rayven  "開始計提"應該根據自然月換算成當前會計月的年月
#                                                    復制時，請不要復制“已使用工作量”
# Modify.........: No.FUN-7A0079 07/11/28 By Nicola 顯示欄位faj71,faj72,faj73,faj74,faj75
# Modify.........: No.MOD-7B0246 07/11/29 By Smapmin 選擇不提列折舊的類別,不應有"無折舊科目"的訊息出現.
# Modify.........: No.TQC-810016 08/01/07 By chenl  增加對單位欄位內容的控管。
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.CHI-810009 08/01/17 By Smapmin 依主件耐用年限/未用年限Default附件耐用年限/未用年限
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.MOD-830170 08/03/22 By Pengu 1.若設定資產序號自動編號(faa03='Y')則應將faj01設為no entry
#                                                  2.自動編號之最大序號應捉已使用資產序號編號的欄位+1
# Modify.........: No.FUN-840006 08/04/02 By hellen  項目管理，去掉預算編號相關欄位
# Modify.........: No.MOD-840660 08/04/25 By chenl   增加入賬日期等于關賬日期的判斷。
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.FUN-850068 08/05/13 By TSD.odyliao 自定欄位功能修改 
# Modify.........: No.MOD-850214 08/05/28 By Sarah AFTER FIELD faj02增加檢核財產編號+附號為' '是否重複
# Modify.........: No.MOD-860048 08/06/09 By Sarah faj201於新增後需重新顯示
# Modify.........: No.FUN-850146 08/06/18 By sherry 列印資料->資產類別/制造廠商/供應商/分攤部門/保管部門后方加show名稱
# Modify.........: No.MOD-890075 08/09/11 By Sarah 1.寫入Temptable時,每一筆廠商與部門名稱的變數舊值需先清除
#                                                  2.增加顯示保管人員姓名
# Modify.........: No.MOD-890254 08/09/26 By clover 稅簽本期累折faj205欄位應要可以修改,參照faj203
# Modify.........: No.MOD-8A0008 08/10/09 By Sarah faj66應另CALL i100_6668(),依據不同的稅簽折舊方式計算正確的faj66,而非直接帶入faj31
# Modify.........: No.MOD-8C0184 08/12/19 By sherry 復制的時候沒有進行自動編號
# Modify.........: No.MOD-8C0190 08/12/22 By Sarah 取消確認前需先檢核該筆資產是否已存在fap_file,若已存在則不可取消確認
# Modify.........: No.MOD-910119 09/01/14 By Sarah 當faj28不為0時,資產科目跟累折科目改為必要輸入
# Modify.........: No.MOD-910201 09/01/17 By Sarah AFTER FIELD faj24段,當faj23<>'1'時,先不需判斷faj24為空時不可離開
# Modify.........: No.MOD-920109 09/02/07 By Sarah 輸入序號時,需檢核輸入值是否為10碼,若不是需提示訊息
# Modify.........: No.MOD-920181 09/02/13 By Smapmin 先建配件再建主件,主件會無法insert
# Modify.........: No.MOD-920258 09/02/19 By Sarah 存檔前需以財編號碼去資料庫找是否已存在,若是則需再重編財編號碼
# Modify.........: No.MOD-950043 09/05/08 By lilingyu 在INSERT INTO faj_file前,增加判斷faj02+faj022不可已存在資料庫,若已存在不可新增
# Modify.........: No.TQC-950142 09/05/27 By xiaofeizhu 修改faj24的管控
# Modify.........: No.TQC-950145 09/06/02 By xiaofeizhu 原來抓取geb02給faj12邏輯不對，加個欄位顯示geb02
# Modify.........: No.MOD-960275 09/06/25 By mike 1.變量使用錯誤,2.加入兩個子報表   
# Modify.........: No.TQC-970136 09/07/16 By xiaofeizhu 插入faj_file時，數據庫中NOT NULL的字段需要加判斷，如果為NULL則賦' '或者0 
# Modify.........: No.TQC-970139 09/07/16 By xiaofeizhu faj24的開窗由q_fad改為q_fad1
# Modify.........: No.MOD-970112 09/07/16 By baofei 1.未用年限不可大于耐用年限 2.faj27改為必輸欄位
# Modify.........: No.CHI-970002 09/07/24 By mike 增加faj331/faj681     
# Modify.........: No.MOD-980082 09/08/12 By mike 將AFTER FIELD faj28段MOD-910119所加程式段(清空faj53,faj531,faj54,faj541)mark      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下  
# Modify.........: No:MOD-990240 09/10/21 By mike FUNCTION i100_show(),在g_faj.faj33的后面增加显示g_faj.faj331                      
# Modify.........: No:TQC-9B0113 09/11/25 By wujie 土地性质的资产，开始计提栏位
# Modify.........: No:MOD-9B0171 09/11/25 By Sarah 新增時若輸入的型態非主件需將faj022清為null
# Modify.........: No:MOD-9C0054 09/12/04 By wujie 直接资本化的资料审核时应控管日期小于关帐日期
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A40033 10/04/07 By lilingyu 如果是大陸版,則按調整后資產總成本*殘值率 來計算"調整后的預計殘值"
# Modify.........: No.TQC-A40059 10/04/12 By Dido 增加附號條件 
# Modify.........: No.MOD-A40190 10/05/03 By sabrina UPDATE faj_file判斷sqlca時多判斷sqlca.sqlerrd[3]=0 
# Modify.........: No.MOD-A50116 10/05/19 By sabrina 當faa22>=4時會有錯誤
# Modify.........: No.MOD-A70075 10/07/09 By Dido 確認時檢核科目允許與拒絕部門設定
# Modify.........: No:CHI-A70052 10/08/02 By Summer 增加判斷若faa15!='4'時隱藏faj331與faj681
# Modify.........: No.FUN-9A0036 10/08/09 By vealxu 增加"族群"之欄位
# Modify.........: No:MOD-A90111 10/09/16 By Dido faj203/faj204/faj205/faj206 輸入後不應再被清為 0 
# Modify.........: No:MOD-AA0151 10/10/25 By Dido 入帳日若小於關帳日則不可取消確認 
# Modify.........: No:MOD-AB0001 10/11/01 By Dido 財產編號欄位輸入控制調整 
# Modify.........: No:MOD-AB0039 10/11/04 By 新增與修改 faj43 只允許維護 0取得,4折畢狀態 
# Modify.........: No:CHI-AA0019 10/11/04 By Summer AFTER FIELD faj27段,判斷輸入值是否為6碼數字,若不是則顯示sub-005
# Modify.........: No:CHI-AA0022 10/11/04 By Summer faj02在查詢時增加開窗功能
# Modify.........: No:MOD-AB0118 10/11/12 By 當 faa03,faa06 皆為 'Y' 時,財編不可輸入 
# Modify.........: No:MOD-AC0289 10/12/24 By Summer afa-091的檢核應該只有當faa20!='2'才做 
# Modify.........: No.FUN-B10053 11/01/24 By yinhy 科目查询自动过滤
# Modify.........: No.TQC-B20040 11/02/14 By zhangll 修改更改狀態下的where條件錯誤
# Modify.........: No.TQC-B20046 11/02/14 By zhangll 取消編輯狀態下的附號開窗
# Modify.........: No.MOD-B30109 11/03/12 By Dido faj11/faj12 增加檢核
# Modify.........: No.MOD-B30367 11/03/17 By lixia 主類別檔(afai010)設定之科目資料有問題時,賦值錯誤信息
# Modify.........: NO.MOD-B30625 11/03/21 BY Dido 若已盤點則不可取消確認 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: NO:MOD-B40011 11/04/11 By lixiang 判斷式調整
# Modify.........: No:FUN-B40004 11/04/14 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No:FUN-B50035 11/05/09 By wujie 更改数量时，单价等于取得成本总额/数量 
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.TQC-B50091 11/05/20 By chenmoayn 重新計算財簽二的取得成本
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60319 11/06/24 By yinhy 未使用財簽二的功能時，(faj432)資產狀態（財簽二）應隱藏
# Modify.........: No:MOD-B70018 11/07/04 By JoHung 修改i100_faj2422()判斷的科目欄位 faj53改為faj531
# Modify.........: No:TQC-B70023 11/07/04 By Dido 修改/刪除/其他資料段增加 faj01 條件
# Modify.........: No:CHI-B80018 11/08/12 By Polly faj33調整增加調整成本(faj141)
# Modify.........: No:MOD-B80285 11/08/26 By Polly 修正修改時沒有檢核財編編號重複問題
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-B80081 11/10/17 By Sakura 資產停用(faj105)欄位移除
# Modify.........: No:FUN-BA0112 11/11/07 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:MOD-BB0018 11/11/12 By johung 科目作明部門明細管理時(aag05='Y')，如果不提折舊則不管控
# Modify.........: No:MOD-BB0267 11/11/26 By johung 修改update fak91的判斷
# Modify.........: No:MOD-BB0280 11/11/26 By johung 修正變數key錯問題
# Modify.........: No:FUN-BB0086 11/12/29 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-BB0093 12/01/12 By Sakura 新增稅簽/財簽二基本資料開帳作業
# Modify.........: No:FUN-BB0122 12/01/12 By Sakura 財二維護Action  faj1012,faj1022開放可輸
#                                                   稅簽維護Action  faj103,faj104開放可輸
# Modify.........: No:FUN-BB0131 12/01/12 By Sakura 財簽二資料維護時，調整成本(財簽二)應可開放調整
# Modify.........: No:FUN-BB0158 12/01/12 By Sakura 財簽二資料維護時，會科應可開放調整
# Modify.........: No:MOD-C10164 12/01/18 By Polly 調整afa-346條件，當不提列折舊時，faj55可不輸入
# Modify.........: No:TQC-C10113 12/01/30 By wujie 查询时增加oriu，orig栏位 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20183 12/02/21 By fengrui 數量欄位小數取位處理
# Modify.........: No:MOD-C20120 12/04/05 By wujie 增加faj922对应fak01，删除时调整对分割，合并的fak91的更新
# Modify.........: No:MOD-C30856 12/03/26 By Polly 判斷fja26是空值，才將faj25的值結予faj26
# Modify.........: No:MOD-C40166 12/04/20 By Elise 再財簽二要無殘值，且折舊方式也要更改為 2.平均無殘值
# Modify.........: No:TQC-C50117 12/05/16 By xuxz afj15"幣種"與aoos010設定的“本國幣種”相同時，faj14等于faj16
# Modify.........: No:TQC-C50181 12/05/21 By lujh 財簽一的多部門分攤類型，財簽二也可以開窗並選擇輸入。
# Modify.........: No:MOD-C50130 12/05/21 By Polly 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:FUN-C50124 12/05/27 By minpp 根據faj09的取值，給折舊日期賦值
# Modify.........: No.CHI-C60010 12/06/14 By wangrr 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:MOD-C50172 12/05/28 By Polly 增加faa_file LUCK CURSOR應用
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-CA0163 12/10/26 By Polly afai100刪除時，調整將fak90改為'N'的條件
# Modify.........: No:MOD-C90160 12/10/30 By Polly 1.預留殘值=未折減額或未耐用年限(月數)=0且折舊方方 <>0的情況下將資產狀態更新為4:折畢
#                                                  2.折畢的情況且不存在在fan_file可做取消確認的動作
# Modify.........: No:MOD-CB0030 12/11/05 By suncx 點擊'多部門分攤'時，應該帶出的是當前固定資產所對應的資料
# Modify.........: No:FUN-CB0080 13/01/09 By wangrr 9主機追單到30,新增資料清單頁簽
# Modify.........: No:FUN-CA0082 13/01/09 By zhangweib 新增action 整批複製
# Modify.........: No:MOD-D10167 13/02/04 By Polly 1.當列管資產(faj28='0')時開放輸入科目
#                                                  2.當非列管資產(faj28<>'0')時,資產科目/累折科目不應開放任意修改
#                                                  3.增加檢核核折舊科目(faj55)
# Modify.........: No:TQC-D20011 13/02/18 By wangrr 將資料清單頁簽名稱與畫面檔名稱修改一致，雙擊資料清單顯示到主畫面內容不一致
# Modify.........: No:MOD-D30240 13/04/01 By Alberti 修改FUNCTION i100_out()內的g_wc
# Modify.........: No:MOD-CB0243 13/04/03 By apo 增對自動編號做faa_file LUCK CURSOR動作
# Modify.........: No:TQC-D40022 13/04/10 By zhangweib 判斷資料清單頁簽(item_list)是否顯示應該使用aza26
# Modify.........: No:MOD-D60243 13/06/28 By yuhuabao  當faa20=1，新增固定資產卡片afai100時，當？入完“折舊科目”faj55欄位后，程序報錯“(afa-317)折舊科目 部門折舊費用科目(afai080)無設置折舊科目資料，請補？入

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_faj               RECORD LIKE faj_file.*,
       g_faj_t             RECORD LIKE faj_file.*,
       g_faj_o             RECORD LIKE faj_file.*,
       g_fab13             LIKE fab_file.fab13,
       g_fab23             LIKE fab_file.fab23,     #殘值率 NO.A032
       g_fab232            LIKE fab_file.fab232,    #殘值率 NO.A032   #No:FUN-AB0088
       g_faj01_t           LIKE faj_file.faj01,
       g_c1                LIKE type_file.chr20,           #No.FUN-680070 VARCHAR(15)
       g_m1                LIKE type_file.chr20,           #No.FUN-680070 VARCHAR(15)
       g_cmd               LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
       g_flag              LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_faj53             LIKE faj_file.faj53,
        g_wc,g_sql          string  #No.FUN-580092 HCN
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_i             LIKE type_file.num5     #COUNT/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_before_input_done   STRING
DEFINE g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_bookno1      LIKE aza_file.aza81         #No.FUN-740026
DEFINE g_bookno2      LIKE aza_file.aza82         #No.FUN-740026
DEFINE g_str          STRING                      #No.MOD-790134
DEFINE l_table        STRING                      #No.MOD-790134
DEFINE l_table1       STRING                      #MOD-960275                                                                       
DEFINE l_table2       STRING                      #MOD-960275     
DEFINE g_argv1     LIKE faj_file.faj02     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
DEFINE g_azi04_1      LIKE azi_file.azi04         #TQC-B50091
DEFINE g_faj18_t      LIKE faj_file.faj18   #No.FUN-BB0086
DEFINE g_action       LIKE type_file.num5         #FUN-BB0122 
#No.FUN-CB0080 ---start--- Add
DEFINE g_faj_1        DYNAMIC ARRAY OF RECORD
          faj01       LIKE faj_file.faj01,
          faj021      LIKE faj_file.faj021,
          faj02       LIKE faj_file.faj02,
          faj022      LIKE faj_file.faj022,
          faj03       LIKE faj_file.faj03,
          faj04       LIKE faj_file.faj04,
          faj05       LIKE faj_file.faj05,
          faj09       LIKE faj_file.faj09,
          faj93       LIKE faj_file.faj93,
          faj10       LIKE faj_file.faj10,
          pmc03_10    LIKE pmc_file.pmc03,
          faj11       LIKE faj_file.faj11,
          pmc03_11    LIKE pmc_file.pmc03,
          faj06       LIKE faj_file.faj06,
          faj07       LIKE faj_file.faj07,
          faj08       LIKE faj_file.faj08,
          faj18       LIKE faj_file.faj18,
          faj17       LIKE faj_file.faj17,
          faj13       LIKE faj_file.faj13,
          faj14       LIKE faj_file.faj14,
          faj19       LIKE faj_file.faj19,
          gen02_19    LIKE gen_file.gen02,
          faj20       LIKE faj_file.faj20,
          gem02_20    LIKE gem_file.gem02,
          faj21       LIKE faj_file.faj21,
          faj22       LIKE faj_file.faj22
                      END RECORD
DEFINE g_bp_flag      LIKE type_file.chr10
DEFINE g_rec_b1       LIKE type_file.num10
DEFINE l_ac1          LIKE type_file.num5
#No.FUN-CB0080 ---end  --- Add

MAIN
    DEFINE p_row,p_col     LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
    LET g_sql ="faj01.faj_file.faj01,  faj02.faj_file.faj02,",
               "faj021.faj_file.faj021,faj022.faj_file.faj022,",
               "faj03.faj_file.faj03,  faj04.faj_file.faj04,",
               "faj05.faj_file.faj05,  faj06.faj_file.faj06,",
               "faj061.faj_file.faj061,faj07.faj_file.faj07,",
               "faj071.faj_file.faj071,faj08.faj_file.faj08,",
               "faj09.faj_file.faj09,  faj10.faj_file.faj10,",
               "faj11.faj_file.faj11,  faj12.faj_file.faj12,",
               "faj13.faj_file.faj13,  faj14.faj_file.faj14,",
               "faj141.faj_file.faj141,faj15.faj_file.faj15,",
               "faj16.faj_file.faj16,  faj17.faj_file.faj17,",
               "faj18.faj_file.faj18,  faj19.faj_file.faj19,",
               "faj20.faj_file.faj20,  faj21.faj_file.faj21,",
               "faj22.faj_file.faj22,  faj23.faj_file.faj23,",
               "faj24.faj_file.faj24,  faj25.faj_file.faj25,",
               "faj26.faj_file.faj26,  faj27.faj_file.faj27,",
               "faj28.faj_file.faj28,  faj29.faj_file.faj29,",
               "faj30.faj_file.faj30,  faj31.faj_file.faj31,",
               "faj32.faj_file.faj32,  faj33.faj_file.faj33,",
               "faj331.faj_file.faj331,",   #CHI-970002     
               "faj35.faj_file.faj35,  faj36.faj_file.faj36,",
               "faj43.faj_file.faj43,  faj44.faj_file.faj44,",
               "faj45.faj_file.faj45,  faj451.faj_file.faj451,",
               "faj46.faj_file.faj46,  faj461.faj_file.faj461,",
               "faj47.faj_file.faj47,  faj471.faj_file.faj471,",
               "faj48.faj_file.faj48,  faj49.faj_file.faj49,",
               "faj51.faj_file.faj51,",
               "faj52.faj_file.faj52,  faj58.faj_file.faj58,",
               "faj59.faj_file.faj59,  l_str.type_file.chr20,",  #MOD-960275    
               "fab02.fab_file.fab02,  pmc03.pmc_file.pmc03,",
               "pmc03_1.pmc_file.pmc03,gem02.gem_file.gem02,",
               "gem02_1.gem_file.gem02,gen02.gen_file.gen02"   #MOD-890075 add gen02
 
    LET l_table = cl_prt_temptable('afai100',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF

    LET g_sql = "fam00.fam_file.fam00,",                                                                                            
                "fam01.fam_file.fam01,",                                                                                            
                "fam04.fam_file.fam04,",                                                                                            
                "fam05.fam_file.fam05"                                                                                              
    LET l_table1 = cl_prt_temptable('afai1001',g_sql) CLIPPED                                                                       
    IF  l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                      
    LET g_sql = "fam00.fam_file.fam00,",                                                                                            
                "fam01.fam_file.fam01,",                                                                                            
                "fam04.fam_file.fam04,",                                                                                            
                "fam05.fam_file.fam05"                                                                                              
    LET l_table2 = cl_prt_temptable('afai1002',g_sql) CLIPPED                                                                       
    IF l_table2 = -1 THEN EXIT PROGRAM END IF                                                                                       

 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
    INITIALIZE g_faj.* TO NULL
    INITIALIZE g_faj_t.* TO NULL
    INITIALIZE g_faj_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM faj_file WHERE faj01 =? AND faj02 = ? AND faj022 =? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl CURSOR  FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW i100_w AT p_row,p_col
         WITH FORM "afa/42f/afai100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #  IF g_aza.aza63 = 'N' THEN  #大陸版
    IF g_faa.faa31 = 'N' THEN   #No:FUN-AB0088
       CALL cl_set_comp_visible("faj531,faj541,faj551,aag02_1a,aag02_2a,aag02_3a,page2,faj432",FALSE)   #No:FUN-AB0088 #No.TQC-B60319 faj432 #TQC-D20011 mark   #No.TQC-D40022   Remark
      #CALL cl_set_comp_visible("faj531,faj541,faj551,aag02_1a,aag02_2a,aag02_3a,item_list,faj432",FALSE) #TQC-D20011 page2->item_list   #No.TQC-D40022   Mark
	   CALL cl_set_act_visible("fin_audit2", FALSE) #FUN-BB0093 Add
    ELSE
       CALL cl_set_comp_visible("page2,faj432",TRUE)   #No:FUN-AB0088  #No.TQC-B60319 faj432 #TQC-D20011 mark   #No.TQC-D40022   Remark
      #CALL cl_set_comp_visible("item_list,faj432",TRUE) #TQC-D20011 page2->item_list                           #No.TQC-D40022   Mark
	   CALL cl_set_act_visible("fin_audit2", TRUE) #FUN-BB0093 Add
    END IF
    IF g_aza.aza26 = '2' THEN
       CALL i100_set_comb()
       CALL i100_set_comments()
    END IF

   #No.TQC-D40022 ---start--- Add
    IF g_aza.aza26 = '2' THEN
       CALL cl_set_comp_visible("item_list",TRUE)
    ELSE
       CALL cl_set_comp_visible("item_list",FALSE)
    END IF
   #No.TQC-D40022 ---end  --- Add
 
    #CHI-A70052 add --start--
    IF g_faa.faa15 != '4' THEN
    #  CALL cl_set_comp_visible("faj331,faj681,faj3312",FALSE)      #No:FUN-AB0088   #No:FUN-B60140
       CALL cl_set_comp_visible("faj331,faj681",FALSE)
    END IF
    #CHI-A70052 add --end--
    
    #-----No:FUN-B60140-----
     IF g_faa.faa152 != '4' THEN
        CALL cl_set_comp_visible("faj3312",FALSE)
     END IF
    #-----No:FUN-B60140-----

   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            END IF
         OTHERWISE        
            CALL i100_q() 
      END CASE
   END IF
 
 
      LET g_action_choice=""
    CALL i100_menu()
 
 
    CLOSE WINDOW i100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
END MAIN
 
FUNCTION i100_cs()
    CLEAR FORM
    INITIALIZE g_faj.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" faj02='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        faj01,faj021,faj02,faj022,faj03,faj04,faj05,faj09,faj93,faj10,                   #FUN-9A0036 add faj93
        faj11,faj12,faj06,faj061,faj07,faj071,faj08,faj18,faj17,faj171,faj13,
        faj14,faj15,faj16,faj43,faj201,
        faj432,
        fajconf,faj19,faj20,faj21,faj22,           #No:FUN-AB0088
        fajuser,fajgrup,fajoriu,fajorig,fajmodu,fajdate,   #No.TQC-C10113 add oriu,orig
        faj23,faj24,faj25,faj26,faj27,faj34,faj35,faj36,faj28,faj29,faj30,
        faj31,faj32,faj203,faj33,faj331,faj57,faj571,faj141,faj58,faj59,faj60,faj204,faj108, #No.TQC-690099 add faj108    #TQC-680123 #CHI-970002 add faj331
        #-----No:FUN-AB0088-----
        #Asset 2
        faj143,faj144,faj142,faj1072,
        faj232,faj242,faj262,faj272,
        faj342,faj352,faj362,faj282,faj292,faj302,
        faj312,faj322,faj2032,faj332,faj3312,faj572,faj5712,
        faj1412,faj582,faj592,faj602,faj2042,faj1082,
        #-----No:FUN-AB0088 END-----
        faj62,faj109,faj103,faj104,faj110,faj71,faj72,faj73,faj61,faj64, #No.FUN-7A0079
        faj65,faj66,faj67,faj205,faj68,faj681,faj74,faj741,faj63,faj69,faj70, #CHI-970002 add faj681
        faj206,faj111,
        #faj37,faj105,faj106,faj107,faj38,faj39,faj40,faj41,faj42,faj421, #No:FUN-B80081 mark
        faj37,faj106,faj107,faj38,faj39,faj40,faj41,faj42,faj421, #No:FUN-B80081 add,移除faj105
        faj422,faj423,faj56,
        faj53,faj54,faj55,  
        faj531,faj541,faj551,   #No.FUN-680028
        faj44,faj45,faj451,faj46,faj461,faj47,faj471,faj48,faj49, #No.FUN-840006 去掉faj50字段
        faj51,faj52
        ,fajud01,fajud02,fajud03,fajud04,fajud05,
        fajud06,fajud07,fajud08,fajud09,fajud10,
        fajud11,fajud12,fajud13,fajud14,fajud15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              #CHI-AA0022 add --start--
              WHEN INFIELD(faj02)   #財產編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.multiret_index = 1
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj02
                 NEXT FIELD faj02
              #CHI-AA0022 add --end--
              WHEN INFIELD(faj022)   #財產編號附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.multiret_index = 2
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj022
                 NEXT FIELD faj022
              WHEN INFIELD(faj04)   #資產類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_fab"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj04
                 NEXT FIELD faj04
              WHEN INFIELD(faj05)   #次要類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_fac"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj05
                 NEXT FIELD faj05
              WHEN INFIELD(faj10)   #製造廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj10
                 NEXT FIELD faj10
              WHEN INFIELD(faj11)   #製造廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 #LET g_qryparam.form = "q_pmc"     #add by guanyao160818
                 LET g_qryparam.form = "cq_faj11"   #add by guanyao160818
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj11
                 NEXT FIELD faj11
              WHEN INFIELD(faj12)   #原產地
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_geb"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj12
                 NEXT FIELD faj12
              WHEN INFIELD(faj18)   #計量單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj18
                 NEXT FIELD faj18
              WHEN INFIELD(faj15)   #原幣幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj15
                 NEXT FIELD faj15
              WHEN INFIELD(faj19)   #保管人
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj19
                 NEXT FIELD faj19
              WHEN INFIELD(faj20)   #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj20
                 NEXT FIELD faj20
              WHEN INFIELD(faj21)   #存放位置
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faf"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj21
                 NEXT FIELD faj21
              WHEN INFIELD(faj22)   #存放工廠
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azw"     #FUN-990031 add 
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj22
                 NEXT FIELD faj22
              WHEN INFIELD(faj24)   #分攤部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj24
                 NEXT FIELD faj24
             #-----No:FUN-AB0088-----
              WHEN INFIELD(faj242)   #▒▒▒u▒▒▒▒
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 #LET g_qryparam.default1 = g_faj.faj242
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj242
                 NEXT FIELD faj242
              #-----No:FUN-AB0088 END-----
              WHEN INFIELD(faj44)   #進貨工廠
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj44
                 NEXT FIELD faj44
              WHEN INFIELD(faj53)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_faj.faj53
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj53
                 NEXT FIELD faj53
              WHEN INFIELD(faj54)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_faj.faj54
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj54
                 NEXT FIELD faj54
              WHEN INFIELD(faj55)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_faj.faj55
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj55
                 NEXT FIELD faj55
              WHEN INFIELD(faj531)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_faj.faj531
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj531
                 NEXT FIELD faj531
              WHEN INFIELD(faj541)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_faj.faj541
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj541
                 NEXT FIELD faj541
              WHEN INFIELD(faj551)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_faj.faj551
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj551
                 NEXT FIELD faj551
              ##-----No:FUN-BA0112 add STR-----
              WHEN INFIELD(faj143)   #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj143
                 NEXT FIELD faj143              
              ##-----No:FUN-BA0112 add END-----
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
   END IF  #FUN-7C0050

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
 
    LET g_sql="SELECT faj01,faj02,faj022 FROM faj_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY faj01,faj02,faj022"  #TQC-D20011 add faj02,faj022
    PREPARE i100_prepare FROM g_sql           # RUNTIME 編譯
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) RETURN END IF
    DECLARE i100_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
    LET g_sql= "SELECT COUNT(*) FROM faj_file ",
               " WHERE ",g_wc CLIPPED
    PREPARE i100_count_pre  FROM g_sql
    DECLARE i100_count CURSOR FOR i100_count_pre #CKP

    #No.FUN-CB0080 ---start--- Add
    LET g_sql= "SELECT faj01,faj021,faj02,faj022,faj03,faj04,faj05,faj09,",
               "       faj93,faj10, ''   ,faj11, ''   ,faj06,faj07,faj08,",
               "       faj18,faj17, faj13,faj14, faj19,''   ,faj20,''   ,faj21,faj22",
               "  FROM faj_file ",
               " WHERE ",g_wc CLIPPED,
               " ORDER BY faj01,faj02,faj022"   #TQC-D20011 add faj02,faj022
    PREPARE afai100_prepare FROM g_sql
    DECLARE afai100_list_cur CURSOR FOR afai100_prepare #CKP
   #No.FUN-CB0080 ---end  --- Add
END FUNCTION
 
FUNCTION i100_menu()
DEFINE l_cmd STRING,   #MOD-CB0030 add
       l_wc  STRING    #MOD-CB0030 add
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
           
        #No.FUN-CB0080 ---start--- Add
        ON ACTION item_list
           LET g_action_choice = "" 
           CALL i100_b_menu()  
           CALL cl_set_act_visible("accept,cancel", FALSE)
           LET g_action_choice = ""  
       #No.FUN-CB0080 ---end  --- Add
       
        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i100_a()
           END IF
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i100_q()
           END IF
           NEXT OPTION "next"
        ON ACTION next
            CALL i100_fetch('N')
        ON ACTION previous
            CALL i100_fetch('P')
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i100_u()
           END IF
           NEXT OPTION "next"
        ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
              CALL i100_r()
           END IF
           NEXT OPTION "next"
       ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
              CALL i100_copy()
           END IF
       ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              CALL i100_out()
           END IF
       ON ACTION memo
           LET g_action_choice="memo"
           IF cl_chk_act_auth() THEN
              CALL s_afa_memo('1',g_faj.faj02,' ',g_faj.faj022)
           END IF
 
       ON ACTION multi_dept_apport
           LET g_action_choice="multi_dept_apport"
           IF cl_chk_act_auth() THEN
              #MOD-CB0030 add begin----------------------------------------
              LET l_wc = "fad03='",g_faj.faj53,"' AND fad04='",g_faj.faj24,"' AND fad07='1'"
              IF g_faa.faa31 = 'Y' THEN
                 LET l_wc = "(",l_wc CLIPPED,") OR (fad03='",g_faj.faj531,"' AND fad04='",g_faj.faj242,"' AND fad07='2')"
              END IF
              LET l_wc=cl_replace_str(l_wc, "'", "\"")
              LET l_cmd = "afai030 '",l_wc,"'"
              #MOD-CB0030 add end------------------------------------------
             #CALL cl_cmdrun('afai030' CLIPPED)                             #MOD-CB0030 mark
              CALL cl_cmdrun(l_cmd)                                         #MOD-CB0030 add
           END IF
 
       ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
              CALL i100_y()
              CALL i100_b_fill()    #No.FUN-CB0080 Add
           END IF
    
       ON ACTION undo_confirm
           LET g_action_choice="undo_confirm"
           IF cl_chk_act_auth() THEN
              CALL i100_z()
              CALL i100_b_fill()    #No.FUN-CB0080 Add
           END IF
#FUN-BB0093   ---start
       ON ACTION fin_audit2
           LET g_action_choice="fin_audit2"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_faj.faj432) THEN
                 LET g_action = '1' #FUN-BB0122 add
                 CALL i100_fin_audit2()
                 LET g_action = '0' #FUN-BB0122 add
              ELSE
                 IF g_faj.faj432 NOT MATCHES '[01]' THEN
                    CALL cl_err('','afa-415',0)
                    LET g_action = '0' #FUN-BB0122 add                  
                 ELSE
                    LET g_action = '1' #FUN-BB0122 add                 
                    CALL i100_fin_audit2()                    
                    LET g_action = '0' #FUN-BB0122 add                  
                 END IF
              END IF
           END IF
       ON ACTION mntn_depr_tax
           LET g_action_choice="mntn_depr_tax"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_faj.faj201) THEN
                 LET g_action = '1' #FUN-BB0122 add              
                 CALL i100_mntn_depr_tax()
                 LET g_action = '0' #FUN-BB0122 add              
              ELSE
                 IF g_faj.faj201 NOT MATCHES '[01]' THEN
                    CALL cl_err('','afa-415',0)
                    LET g_action = '0' #FUN-BB0122 add                    
                 ELSE
                    LET g_action = '1' #FUN-BB0122 add                 
                    CALL i100_mntn_depr_tax()
                    LET g_action = '0' #FUN-BB0122 add                  
                 END IF
              END IF
           END IF           
#FUN-BB0093   ---end
 
       ON ACTION tran_log_details
          CALL i100_4()
       ON ACTION tran_log
          CALL i100_5()
       ON ACTION relating_material
          IF not cl_null(g_faj.faj02) THEN
             LET g_cmd = "afaq300 '",g_faj.faj02,"'",
                         " '",g_faj.faj022,"'" clipped
             CALL cl_cmdrun(g_cmd)
          END IF
       #add by liyjf181219 str   
       ON ACTION modify_fp
          CALL i100_fp()
      #add by liyjf181219 end
          
       ON ACTION help
          CALL cl_show_help()
        ON ACTION related_document    #No.MOD-470515
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_faj.faj01 IS NOT NULL THEN
                LET g_doc.column1 = "faj01"
                LET g_doc.value1 = g_faj.faj01
                 LET g_doc.column2 = "faj02"      #MOD-4C0020
                 LET g_doc.value2 = g_faj.faj02   #MOD-4C0020
                 LET g_doc.column3 = "faj022"     #MOD-4C0020
                 LET g_doc.value3 = g_faj.faj022  #MOD-4C0020
                CALL cl_doc()
             END IF
          END IF
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          IF g_aza.aza26 = '2' THEN
             CALL i100_set_comb()
             CALL i100_set_comments()
          END IF
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
       ON ACTION jump
          CALL i100_fetch('/')
       ON ACTION first
          CALL i100_fetch('F')
       ON ACTION last
          CALL i100_fetch('L')
       ON ACTION controlg
          CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
          LET g_action_choice = "exit"
          CONTINUE MENU
 
       ON ACTION other
          LET g_action_choice = "other"
          IF cl_chk_act_auth() THEN
             CALL i100_other()
          END IF
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
      &include "qry_string.4gl"
      #No:FUN-CA0082   ---start--- Add
       ON ACTION all_copy
          LET g_action_choice="all_copy"
          IF cl_chk_act_auth() THEN
             CALL i100_allcopy()
          END IF
      #No:FUN-CA0082   ---end  --- Add
 
    END MENU
END FUNCTION
 
FUNCTION i100_a()
DEFINE l_faa031   LIKE faa_file.faa031
DEFINE l_faj01    LIKE faj_file.faj01
DEFINE l_str           STRING,   #MOD-690087
       l_len,i         LIKE type_file.num5 #MOD-690087
DEFINE l_count    LIKE type_file.num5      #MOD-950043
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_faj.* LIKE faj_file.*
    LET g_faj01_t        = NULL
    LET g_faj_t.* = g_faj.*
    LET g_faj_o.* = g_faj.*
    CALL cl_opmsg('a')
   #---------------------------------MOD-C50172------------------------------------------(S)
    LET g_forupd_sql = "SELECT * FROM faa_file WHERE faa00 = '0' FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE faa_cl CURSOR FROM g_forupd_sql
   #---------------------------------MOD-C50172------------------------------------------(E)
    WHILE TRUE
        LET g_faj.faj021 = '1'
        LET g_faj.faj03  = '1'
        LET g_faj.faj43  = '0'  LET g_faj.faj201='0'
        LET g_faj.faj35  = 0
       # 初始值給零
        LET g_faj.faj13  = 0 LET g_faj.faj14  = 0
        LET g_faj.faj141 = 0 LET g_faj.faj16  = 0
        LET g_faj.faj17  = 0 LET g_faj.faj171 = 0
        LET g_faj.faj29  = 0 LET g_faj.faj30  = 0
        LET g_faj.faj31  = 0 LET g_faj.faj32  = 0
        LET g_faj.faj33  = 0 LET g_faj.faj35  = 0
        LET g_faj.faj331 = 0   #CHI-970002     
        LET g_faj.faj58  = 0 LET g_faj.faj59  = 0
        LET g_faj.faj60  = 0 LET g_faj.faj62  = 0
        LET g_faj.faj63  = 0 LET g_faj.faj64  = 0
        LET g_faj.faj65  = 0 LET g_faj.faj66  = 0
        LET g_faj.faj67  = 0 LET g_faj.faj68  = 0
        LET g_faj.faj681 = 0   #CHI-970002     
        LET g_faj.faj69  = 0 LET g_faj.faj70  = 0
        LET g_faj.faj86  = 0 LET g_faj.faj87  = 0
        LET g_faj.faj203 = 0 LET g_faj.faj205 = 0   #MOD-580279
        LET g_faj.faj206 = 0    #MOD-580279
        LET g_faj.faj204 = 0                        #MOD-A90111
        LET g_faj.faj101 = 0  LET g_faj.faj102 = 0
        LET g_faj.faj103 = 0  LET g_faj.faj104 = 0
        #LET g_faj.faj105 = 'N' #No:FUN-B80081 mark
        LET g_faj.faj106 = 0  LET g_faj.faj107 = 0
        LET g_faj.faj108 = 0  LET g_faj.faj109 = 0
        LET g_faj.faj110 = 0  LET g_faj.faj111 = 0
        LET g_faj.faj71 = 'N'  LET g_faj.faj72 = 0  #No.FUN-7A0079
        LET g_faj.faj73 = 0  LET g_faj.faj74 = 0  #No.FUN-7A0079
        LET g_faj.faj741 = 0  #No.FUN-7A0079
        LET g_faj.fajuser = g_user               #使用者
        LET g_faj.fajoriu = g_user #FUN-980030
        LET g_faj.fajorig = g_grup #FUN-980030
        LET g_faj.fajmodu = g_user
        LET g_faj.fajgrup = g_grup               #使用者所屬群
        LET g_faj.fajdate = g_today
        LET g_faj.fajconf = 'N'
        #-----No:FUN-AB0088-----
        LET g_faj.faj232  = '1'
        LET g_faj.faj242  = ' '
        LET g_faj.faj282  = '1'
        LET g_faj.faj342  = 'N'
        LET g_faj.faj432 = '0'
        LET g_faj.faj352  = 0
        LET g_faj.faj142  = 0
        LET g_faj.faj1412 = 0
        LET g_faj.faj292  = 0
        LET g_faj.faj302  = 0
        LET g_faj.faj312  = 0
        LET g_faj.faj322  = 0
        LET g_faj.faj332  = 0
        LET g_faj.faj3312 = 0
        LET g_faj.faj352  = 0
        LET g_faj.faj582  = 0
        LET g_faj.faj592  = 0
        LET g_faj.faj602  = 0
        LET g_faj.faj2032 = 0
        LET g_faj.faj2042 = 0
        LET g_faj.faj1012 = 0
        LET g_faj.faj1022 = 0
        LET g_faj.faj1062 = 0
        LET g_faj.faj1072 = 0
        LET g_faj.faj1082 = 0
        SELECT aaa03 INTO g_faj.faj143 FROM aaa_file
         WHERE aaa01 = g_faa.faa02c
       #--------------------MOD-C50130--------------(S)
        IF NOT cl_null(g_faj.faj143) THEN
           SELECT azi04 INTO g_azi04_1 FROM azi_file
            WHERE azi01 = g_faj.faj143
        END IF
       #--------------------MOD-C50130--------------(E)
        CALL s_curr(g_faj.faj143,g_today) RETURNING g_faj.faj144
        #-----No:FUN-AB0088 END-----
        LET g_faj.faj144=cl_digcut(g_faj.faj144,g_azi04_1) #CHI-C60010 add
        IF g_aza.aza31 = 'Y' THEN
          #CALL s_auno(g_faj.faj02,'4','') RETURNING g_faj.faj02,g_faj.faj06  #No.FUN-850100  #No.FUN-CA0082   Mark
           CALL s_auno1(g_faj.faj02,'4','') RETURNING g_faj.faj02,g_faj.faj06 #No.FUN-CA0082   Add
        END IF
       #-------------------------MOD-C50172----------(S)
        BEGIN WORK          
        IF g_faa.faa03 = 'Y' THEN             #MOD-CB0243 add
           OPEN faa_cl        
           IF STATUS  THEN   
              CALL cl_err('OPEN faa_curl',STATUS,1)
              RETURN 
           END IF
        END IF                                #MOD-CB0243 add
       #-------------------------MOD-C50172----------(S) 
        CALL i100_i("a")                         # 各欄位輸入
 
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           INITIALIZE g_faj.* TO NULL
           CALL cl_err('',9001,0)
           CLEAR FORM
           IF g_faa.faa03 = 'Y' THEN             #MOD-CB0243 add
              CLOSE faa_cl                       #MOD-CB0243 add
           END IF                                #MOD-CB0243 add
           ROLLBACK WORK                         #MOD-CB0243 add
           EXIT WHILE
        END IF
 
            IF g_faa.faa03 = 'Y' AND cl_null(g_faj_t.faj01) THEN  #自動編號   #MOD-690087
               SELECT faa031 INTO g_faa.faa031 FROM faa_file
               DISPLAY 'faa031',g_faa.faa031
               IF NOT cl_null(g_faa.faa031) THEN
                  LET l_str = g_faa.faa031
                  LET l_len = l_str.getlength()
                  FOR i = 1 TO l_len
                      IF l_str.substring(i,i) NOT MATCHES '[0123456789]' THEN
#                         CALL cl_err(g_faa.faa031,'apy-020',0)   #CHI-B40058
                         CALL cl_err(g_faa.faa031,'afa-205',0)    #CHI-B40058 
                      END IF
                  END FOR
               END IF
               IF cl_null(g_faa.faa031) THEN LET g_faa.faa031 = 0 END IF
               LET l_faa031 = g_faa.faa031 + 1
               DISPLAY '+1',l_faa031
               LET l_faj01 = l_faa031 USING '&&&&&&&&&&'
               DISPLAY 'using',l_faj01
               LET g_faj.faj01 = l_faj01
               DISPLAY BY NAME g_faj.faj01
               LET g_faj_t.faj01 = g_faj.faj01
               LET g_faj_o.faj01 = g_faj.faj01
            END IF
            IF g_faa.faa06 = 'Y' AND cl_null(g_faj.faj02) THEN
               LET g_faj.faj02 = g_faj.faj01
               DISPLAY BY NAME g_faj.faj02
            END IF
 
        IF cl_null(g_faj.faj01) THEN
           LET g_faj.faj01=' '
        END IF
 
        IF cl_null(g_faj.faj01) AND g_faa.faa04='N' THEN
            CONTINUE WHILE
        END IF
 
        IF cl_null(g_faj.faj58)  THEN LET g_faj.faj58 = 0    END IF
        IF cl_null(g_faj.faj13)  THEN LET g_faj.faj13 = 0    END IF
        IF cl_null(g_faj.faj141) THEN LET g_faj.faj141 = 0   END IF
        IF cl_null(g_faj.faj16)  THEN LET g_faj.faj16 = 0    END IF
        IF cl_null(g_faj.faj17)  THEN LET g_faj.faj17 = 0    END IF
        IF cl_null(g_faj.faj171) THEN LET g_faj.faj171 = 0   END IF
        IF cl_null(g_faj.faj29)  THEN LET g_faj.faj29 = 0    END IF
        IF cl_null(g_faj.faj30)  THEN LET g_faj.faj30 = 0    END IF
        IF cl_null(g_faj.faj33)  THEN LET g_faj.faj33 = 0    END IF
        IF cl_null(g_faj.faj331) THEN LET g_faj.faj331= 0    END IF   #CHI-970002   
        IF cl_null(g_faj.faj34)  THEN LET g_faj.faj34 = 0    END IF
        IF cl_null(g_faj.faj35)  THEN LET g_faj.faj35 = 0    END IF
        IF cl_null(g_faj.faj36)  THEN LET g_faj.faj36 = 0    END IF
        IF cl_null(g_faj.faj421) THEN LET g_faj.faj421 = 0   END IF
        IF cl_null(g_faj.faj422) THEN LET g_faj.faj422 = 0   END IF
        IF cl_null(g_faj.faj423) THEN LET g_faj.faj423 = 0   END IF
        IF cl_null(g_faj.faj451) THEN LET g_faj.faj451 = 0   END IF
        IF cl_null(g_faj.faj461) THEN LET g_faj.faj461 = 0   END IF
        IF cl_null(g_faj.faj471) THEN LET g_faj.faj471 = 0   END IF
        IF cl_null(g_faj.faj59)  THEN LET g_faj.faj59 = 0    END IF
        IF cl_null(g_faj.faj60)  THEN LET g_faj.faj60 = 0    END IF
        IF cl_null(g_faj.faj63)  THEN LET g_faj.faj63 = 0    END IF
        IF cl_null(g_faj.faj64)  THEN LET g_faj.faj64 = 0    END IF
        IF cl_null(g_faj.faj65)  THEN LET g_faj.faj65 = 0    END IF
        IF cl_null(g_faj.faj68)  THEN LET g_faj.faj68 = 0    END IF
        IF cl_null(g_faj.faj681) THEN LET g_faj.faj681= 0    END IF   #CHI-970002      
        IF cl_null(g_faj.faj69)  THEN LET g_faj.faj69 = 0    END IF
        IF cl_null(g_faj.faj70)  THEN LET g_faj.faj70 = 0    END IF
        IF cl_null(g_faj.faj72)  THEN LET g_faj.faj72 = 0    END IF
        IF cl_null(g_faj.faj73)  THEN LET g_faj.faj73 = 0    END IF
        IF cl_null(g_faj.faj80)  THEN LET g_faj.faj80 = 0    END IF
        IF cl_null(g_faj.faj81)  THEN LET g_faj.faj81 = 0    END IF
        IF cl_null(g_faj.faj86)  THEN LET g_faj.faj86 = 0    END IF
        IF cl_null(g_faj.faj87)  THEN LET g_faj.faj87 = 0    END IF
        IF cl_null(g_faj.faj100) THEN
           LET g_faj.faj100 = g_faj.faj26
        END IF
        IF cl_null(g_faj.faj101) THEN LET g_faj.faj101 = 0   END IF
        IF cl_null(g_faj.faj102) THEN LET g_faj.faj102 = 0   END IF
        IF cl_null(g_faj.faj103) THEN LET g_faj.faj103 = 0   END IF
        IF cl_null(g_faj.faj104) THEN LET g_faj.faj104 = 0   END IF
        IF cl_null(g_faj.faj106) THEN LET g_faj.faj106 = 0   END IF
        IF cl_null(g_faj.faj107) THEN LET g_faj.faj107 = 0   END IF
        IF cl_null(g_faj.faj108) THEN LET g_faj.faj108 = 0   END IF
        IF cl_null(g_faj.faj109) THEN LET g_faj.faj109 = 0   END IF
        IF cl_null(g_faj.faj110) THEN LET g_faj.faj110 = 0   END IF
        IF cl_null(g_faj.faj111) THEN LET g_faj.faj111 = 0   END IF
        #-----No:FUN-AB0088-----
        IF cl_null(g_faj.faj582)  THEN LET g_faj.faj582 = 0    END IF
        IF cl_null(g_faj.faj292)  THEN LET g_faj.faj292 = 0    END IF
        IF cl_null(g_faj.faj302)  THEN LET g_faj.faj302 = 0    END IF
        IF cl_null(g_faj.faj332)  THEN LET g_faj.faj332 = 0    END IF
        IF cl_null(g_faj.faj3312) THEN LET g_faj.faj3312= 0    END IF
        IF cl_null(g_faj.faj342)  THEN LET g_faj.faj342 = 0    END IF
        IF cl_null(g_faj.faj352)  THEN LET g_faj.faj352 = 0    END IF
        IF cl_null(g_faj.faj362)  THEN LET g_faj.faj362 = 0    END IF
        IF cl_null(g_faj.faj592)  THEN LET g_faj.faj592 = 0    END IF
        IF cl_null(g_faj.faj602)  THEN LET g_faj.faj602 = 0    END IF
        IF cl_null(g_faj.faj1012) THEN LET g_faj.faj1012 = 0   END IF
        IF cl_null(g_faj.faj1022) THEN LET g_faj.faj1022 = 0   END IF
        IF cl_null(g_faj.faj1062) THEN LET g_faj.faj1062 = 0   END IF
        IF cl_null(g_faj.faj1072) THEN LET g_faj.faj1072 = 0   END IF
        IF cl_null(g_faj.faj1082) THEN LET g_faj.faj1082 = 0   END IF
        #-----No:FUN-AB0088 END-----
 
        IF cl_null(g_faj.faj72) THEN LET g_faj.faj72 = 0   END IF
        IF cl_null(g_faj.faj73) THEN LET g_faj.faj73 = 0   END IF
        IF cl_null(g_faj.faj74) THEN LET g_faj.faj74 = 0   END IF
        IF cl_null(g_faj.faj741) THEN LET g_faj.faj741 = 0   END IF
        IF cl_null(g_faj.faj022) THEN LET g_faj.faj022 = ' ' END IF
       #LET g_faj.faj203 = 0 LET g_faj.faj204  = 0                    #MOD-A90111 mark
       #LET g_faj.faj205 = 0 LET g_faj.faj206  = 0  #No.8852          #MOD-A90111 mark
        
        IF cl_null(g_faj.faj331) THEN LET g_faj.faj331 = 0 END IF
        IF cl_null(g_faj.faj681) THEN LET g_faj.faj681 = 0 END IF
       #存檔前需以財編號碼去資料庫找是否已存在,若是則需再重編財編號碼
        IF g_aza.aza31 = 'Y' THEN
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt FROM faj_file
            WHERE faj02 = g_faj.faj02
              AND faj022 = g_faj.faj022    #TQC-A40059
           IF g_cnt > 0 THEN 
              CALL cl_err(g_faj.faj02,'afa-914',1)
              LET g_faj.faj02 = ''
              LET g_faj.faj06 = ''
             #CALL s_auno(g_faj.faj02,'4','') RETURNING g_faj.faj02,g_faj.faj06  #No.FUN-850100   #No.FUN-CA0082 Mark
              CALL s_auno1(g_faj.faj02,'4','') RETURNING g_faj.faj02,g_faj.faj06 #No.FUN-CA0082   Add
              DISPLAY BY NAME g_faj.faj02,g_faj.faj06
           END IF
        END IF
 
        SELECT COUNT(*) INTO l_count FROM faj_file
         WHERE faj02  = g_faj.faj02 
           AND faj022 = g_faj.faj022
        IF l_count > 0 THEN 
           CALL cl_err('','afa-105',1)
           CONTINUE WHILE 
        END IF           
        INSERT INTO faj_file VALUES(g_faj.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","faj_file",g_faj.faj01,g_faj.faj02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        ELSE
            LET g_faj_t.* = g_faj.*                # 保存上筆資料
            SELECT faj01, faj02, faj022 INTO g_faj.faj01,g_faj.faj02,g_faj.faj022 FROM faj_file
            WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022
        END IF
        #-------- 更新系統參數檔之已用編號 ----------
        IF NOT cl_null(g_faj.faj01) AND g_faa.faa03='Y' THEN
           UPDATE faa_file SET faa031 = g_faj.faj01
            WHERE faa03 = 'Y'                                                      #MOD-CB0243 add
            IF SQLCA.sqlcode THEN               #No.MOD-4A0186
              CALL cl_err3("upd","faa_file",g_faj.faj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
              ROLLBACK WORK                                                        #MOD-C50172 add
            ELSE                                                                   #MOD-C50172 add
              COMMIT WORK                                                          #MOD-C50172 add
           END IF
           IF g_faa.faa03 = 'Y' THEN             #MOD-CB0243 add
              CLOSE faa_cl                                                            #MOD-C50172 add
           END IF                                #MOD-CB0243 add
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i100_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
          l_modify_flag   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_lock_sw       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_exit_sw       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_area,l_beno   LIKE faa_file.faa17,
          l_faj022        LIKE faj_file.faj022,
          l_mxno          LIKE faj_file.faj022,
          l_aza17         LIKE aza_file.aza17,
          l_faj30         LIKE faj_file.faj30,
          l_fbi02         LIKE fbi_file.fbi02,
          l_fbi021        LIKE fbi_file.fbi021,
          l_faj27         LIKE faj_file.faj27,
          l_faj272        LIKE faj_file.faj272,   #No:FUN-AB0088
          l_faj29         LIKE faj_file.faj29,
          l_faa031        LIKE faa_file.faa031,        #No.FUN-680070 DEC(10,0)
          l_faj01         LIKE faj_file.faj01,
          l_n             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          aag02_1         LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
          aag02_2         LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
          aag02_3         LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
          aag02_1a        LIKE aag_file.aag02,    #No.FUN-680028
          aag02_2a        LIKE aag_file.aag02,    #No.FUN-680028
          aag02_3a        LIKE aag_file.aag02,    #No.FUN-680028
          l_faj24         LIKE faj_file.faj24,    #MOD-530231
          l_faj242        LIKE faj_file.faj242,   #No:FUN-AB0088
          l_cnt           LIKE type_file.num5   #MOD-690077
   DEFINE l_str           STRING,   #MOD-690087
          l_len,i         LIKE type_file.num5   #MOD-690087
   DEFINE l_date          LIKE faj_file.faj26
   DEFINE l_date2         LIKE type_file.chr8
   DEFINE l_year          LIKE type_file.chr4
   DEFINE l_month         LIKE type_file.chr2
   DEFINE l_day           LIKE type_file.chr2
   DEFINE l_aag05         LIKE aag_file.aag05                  #No.FUN-B40004
   DEFINE l_case          STRING   #No.FUN-BB0086
   DEFINE l_yy            LIKE type_file.chr4      #MOD-D10167 add
   DEFINE l_mm            LIKE type_file.chr2      #MOD-D10167 add
 
   INPUT BY NAME g_faj.faj01,g_faj.faj021,g_faj.faj02,g_faj.faj022,g_faj.faj03, g_faj.fajoriu,g_faj.fajorig,
                 g_faj.faj04,g_faj.faj05,g_faj.faj09,g_faj.faj93,g_faj.faj10,g_faj.faj11,                        #FUN-9A0036 add faj93
                 g_faj.faj12,g_faj.faj06,g_faj.faj061,g_faj.faj07,g_faj.faj071,
                 g_faj.faj08,g_faj.faj18,g_faj.faj17,g_faj.faj171,g_faj.faj13,
                 g_faj.faj14,g_faj.faj15,g_faj.faj16,g_faj.faj43,g_faj.faj201,g_faj.faj432,   #No:FUN-AB0088
                 g_faj.fajconf,g_faj.faj19,g_faj.faj20,g_faj.faj21,g_faj.faj22,
                 g_faj.fajuser,g_faj.fajgrup,g_faj.fajmodu,g_faj.fajdate,
                 g_faj.faj23,g_faj.faj24,g_faj.faj25,g_faj.faj26,g_faj.faj27,
                 g_faj.faj34,g_faj.faj35,g_faj.faj36,g_faj.faj28,g_faj.faj29,
                 g_faj.faj30,g_faj.faj31,g_faj.faj32,g_faj.faj203,g_faj.faj33,g_faj.faj331, #CHI-970002 add faj331
                 g_faj.faj141,g_faj.faj58,g_faj.faj59,g_faj.faj60,g_faj.faj204,g_faj.faj108,#No.TQC-690099 add faj108
                 #-----No:FUN-AB0088-----
                 #Asset 2
                 g_faj.faj143,g_faj.faj144,g_faj.faj142,g_faj.faj1012,g_faj.faj1022,g_faj.faj1062,g_faj.faj1072,
                 g_faj.faj232,g_faj.faj242,g_faj.faj262,g_faj.faj272,
                 g_faj.faj342,g_faj.faj352,g_faj.faj362,g_faj.faj282,g_faj.faj292,g_faj.faj302,
                 g_faj.faj312,g_faj.faj322,g_faj.faj2032,g_faj.faj332,g_faj.faj3312,g_faj.faj572,g_faj.faj5712,
                 g_faj.faj1412,g_faj.faj582,g_faj.faj592,g_faj.faj602,g_faj.faj2042,g_faj.faj1082,
                 #-----No:FUN-AB0088 END-----
                 g_faj.faj62,g_faj.faj109,g_faj.faj103,g_faj.faj104,g_faj.faj110,g_faj.faj71,g_faj.faj72,g_faj.faj73,g_faj.faj61,g_faj.faj64, #No.FUN-7A0079
                 g_faj.faj65,g_faj.faj66,g_faj.faj67,g_faj.faj205,g_faj.faj68,g_faj.faj681,g_faj.faj74,g_faj.faj741,g_faj.faj63,g_faj.faj69,g_faj.faj70, #CHI-970002 add faj681
                 g_faj.faj206,g_faj.faj111,
                 #g_faj.faj37,g_faj.faj105, #No:FUN-B80081 mark
                 g_faj.faj37, #No:FUN-B80081 add,移除g_faj.faj105
                 g_faj.faj101,g_faj.faj102,g_faj.faj106,g_faj.faj107,
                 g_faj.faj38,g_faj.faj39,g_faj.faj40,g_faj.faj41,
                 g_faj.faj42,g_faj.faj421,g_faj.faj422,g_faj.faj423,g_faj.faj56,
                 g_faj.faj53,g_faj.faj54,g_faj.faj55,g_faj.faj531,g_faj.faj541,g_faj.faj551,g_faj.faj44,g_faj.faj45, #No.FUN-680028
                 g_faj.faj451,g_faj.faj46,g_faj.faj461,g_faj.faj47,g_faj.faj471,
                 g_faj.faj48,g_faj.faj49,g_faj.faj51,g_faj.faj52   #No.FUN-840006 去掉g_faj.faj50
                ,g_faj.fajud01,g_faj.fajud02,g_faj.fajud03,g_faj.fajud04,
                 g_faj.fajud05,g_faj.fajud06,g_faj.fajud07,g_faj.fajud08,
                 g_faj.fajud09,g_faj.fajud10,g_faj.fajud11,g_faj.fajud12,
                 g_faj.fajud13,g_faj.fajud14,g_faj.fajud15 
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL i100_set_required(p_cmd)      #MOD-AB0001
         CALL i100_set_no_required(p_cmd)   #No.MOD-530114
 
         CALL cl_set_docno_format("faj46")
         CALL cl_set_docno_format("faj47")
         #No.FUN-BB0086--add--begin--
         IF p_cmd = 'a' THEN 
            LET g_faj18_t = NULL   
         END IF 
         IF p_cmd = 'u' THEN 
            LET g_faj18_t = g_faj.faj18
         END IF 
         #No.FUN-BB0086--add--end--

      AFTER FIELD faj01
         #-->序號不可空白
         IF p_cmd = 'a' THEN
            IF g_faa.faa04 = 'N' AND g_faa.faa03 = 'N' THEN
               IF cl_null(g_faj.faj01) THEN
                  LET g_faj.faj01 = g_faj_t.faj01
                  DISPLAY BY NAME g_faj.faj01
                  NEXT FIELD faj01
               END IF
 
            END IF
 
            #-----手動輸入的序號不可重複
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM faj_file
              WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022
            IF l_cnt > 0 THEN
               CALL cl_err(g_faj.faj01,'afa-132',0)
               NEXT FIELD faj01
            END IF
 
            IF NOT cl_null(g_faj.faj01) THEN
               LET l_str = g_faj.faj01
               LET l_len = l_str.getlength()
              #序號需為10碼
               IF l_len != 10 THEN
                  CALL cl_err(g_faj.faj01,'afa-210',0)
                  NEXT FIELD faj01
               END IF
               FOR i = 1 TO l_len
                   IF l_str.substring(i,i) NOT MATCHES '[0123456789]' THEN
#                      CALL cl_err(g_faj.faj01,'apy-020',0)   #CHI-B40058
                      CALL cl_err(g_faj.faj01,'afa-205',0)    #CHI-B40058
                      NEXT FIELD faj01
                   END IF
               END FOR
            END IF
 
            #-->財編與序號一致
            IF g_faa.faa06 = 'Y' THEN
               LET g_faj.faj02 = g_faj.faj01
               DISPLAY BY NAME g_faj.faj02
            END IF
            LET g_faj_t.faj01 = g_faj.faj01
            LET g_faj_o.faj01 = g_faj.faj01
         END IF
         IF cl_null (g_faj.faj01) THEN
            LET g_faj.faj01 = ' '
         END IF
          CALL i100_set_required(p_cmd)   #No.MOD-530114
 
      BEFORE FIELD faj02
         #-->財編與序號一致
         IF g_faa.faa06 = 'Y' THEN
            LET g_faj.faj02 = g_faj.faj01
            DISPLAY BY NAME g_faj.faj02
         END IF
 
      AFTER FIELD faj02
        #LET g_faj_o.faj02 = g_faj.faj02                                                #No.MOD-B80285 mark
         CALL i100_set_required(p_cmd)   #No.MOD-530114
        #IF p_cmd = 'a' AND NOT cl_null(g_faj.faj02) AND g_faj.faj022=' ' THEN          #No.MOD-B80285 mark
         IF NOT cl_null(g_faj.faj02) AND g_faj.faj022=' ' THEN                          #No.MOD-B80285 add
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_faj_o.faj02 <> g_faj.faj02) THEN       #No.MOD-B80285 add
               SELECT COUNT(*) INTO g_cnt FROM faj_file
                                         WHERE faj02 = g_faj.faj02
                                           AND faj022 = g_faj.faj022   #MOD-920181
               IF g_cnt > 0 THEN
                  CALL cl_err(g_faj.faj02,'afa-307',0)
                  NEXT FIELD faj02
               END IF
               IF NOT cl_null(g_faj.faj02) THEN   #MOD-730111
                  SELECT COUNT(*) INTO g_cnt FROM fak_file
                                            WHERE fak02 = g_faj.faj02
                  IF g_cnt > 0 THEN
                     CALL cl_err(g_faj.faj02,'afa-301',0)
                     NEXT FIELD faj02
                  END IF
               END IF   #MOD-730111
            END IF                                                                       #No.MOD-B80285 add
         END IF
         IF cl_null(g_faj.faj93) THEN               #FUN-9A0036
            LET g_faj.faj93 = g_faj.faj02           #FUN-9A0036
         END IF                                     #FUN-9A0036
         LET g_faj_o.faj02 = g_faj.faj02                                                 #No.MOD-B80285 add   
    
      AFTER FIELD faj021
         IF NOT cl_null(g_faj.faj021) THEN
            IF g_faj.faj021 NOT MATCHES '[123]' THEN
               LET g_faj.faj021 = g_faj_t.faj021
               DISPLAY BY NAME g_faj.faj021
               NEXT FIELD faj021
            END IF
 
            #-->財編與序號一致不可輸入(23)
            IF g_faa.faa06 = 'Y' AND g_faj.faj021 MATCHES '[23]' THEN
               CALL cl_err(g_faj.faj02,'afa-304',0)
               NEXT FIELD faj022
            END IF
 
            #-->配件或費用其財編一定要存在
            IF g_faj.faj021 MATCHES '[23]' THEN
               SELECT COUNT(*) INTO g_cnt FROM faj_file
                WHERE faj02 = g_faj.faj02
                  AND faj021 = '1'
               IF (p_cmd = 'u' AND g_cnt < 1) OR (p_cmd = 'a' AND g_cnt < 0) THEN
                  CALL cl_err(g_faj.faj02,'afa-300',0)
                  LET g_faj.faj021 = g_faj_t.faj021
                  DISPLAY BY NAME g_faj.faj021
                  NEXT FIELD faj02
               END IF
               CALL cl_set_comp_entry("faj022",TRUE)      #MOD-AB0001
            ELSE                                          #MOD-AB0001
               CALL cl_set_comp_entry("faj022",FALSE)     #MOD-AB0001
            END IF
            IF (p_cmd='u' OR p_cmd='a')AND g_faj.faj021='1' THEN
               LET g_faj.faj022 = ' '
               DISPLAY g_faj.faj022 TO faj022
            END IF
            IF p_cmd='a' AND g_faj.faj021!='1' THEN
               LET g_faj.faj022 = ''
               DISPLAY g_faj.faj022 TO faj022
            END IF
            LET g_faj_o.faj021 = g_faj.faj021
         END IF
 
      BEFORE FIELD faj022
         #-->自動預設附號
         IF g_faj_t.faj021 IS NULL OR g_faj_t.faj021 != g_faj.faj021
            OR g_faj_t.faj022 IS NULL THEN
            IF g_faj.faj021 MATCHES '[23]' THEN
                 CALL s_afamxno(g_faj.faj02,g_faj.faj021) RETURNING l_mxno
                #MOD-A50116---modify---start---
                #LET g_faj.faj022 = l_mxno
                #DISPLAY BY NAME g_faj.faj022
                 IF cl_null(l_mxno) THEN
                    NEXT FIELD faj021
                 ELSE
                    LET g_faj.faj022 = l_mxno
                    DISPLAY BY NAME g_faj.faj022
                 END IF
                #MOD-A50116---modify---end---
              ELSE
                 IF p_cmd = 'a' THEN
                    SELECT COUNT(*) INTO g_cnt FROM faj_file
                                              WHERE faj02 = g_faj.faj02
                                               AND faj022 = g_faj.faj022   #MOD-920181
                    IF g_cnt > 0 THEN
                       CALL cl_err(g_faj.faj02,'afa-307',0)
                       NEXT FIELD faj02
                    END IF
                    IF NOT cl_null(g_faj.faj02) THEN   #MOD-730111
                       SELECT COUNT(*) INTO g_cnt FROM fak_file
                                                 WHERE fak02 = g_faj.faj02
                       IF g_cnt > 0 THEN
                          CALL cl_err(g_faj.faj02,'afa-301',0)
                          NEXT FIELD faj02
                       END IF
                    END IF   #MOD-730111
                    CALL i100_set_no_entry(p_cmd)
                 END IF
              END IF
         END IF
 
      AFTER FIELD faj022
          IF NOT cl_null(g_faj.faj022) THEN
             #-->財編+附號是否重複
             IF g_faj.faj02 != g_faj_t.faj02 OR
                g_faj.faj022 != g_faj_t.faj022 OR
               (g_faj.faj02 IS NOT NULL AND g_faj_t.faj02 IS NULL) OR
               (g_faj.faj022 IS NOT NULL AND g_faj_t.faj022 IS NULL)
             THEN SELECT COUNT(*) INTO l_n FROM faj_file
                    WHERE faj02  = g_faj.faj02
                      AND faj022 = g_faj.faj022
                       IF l_n > 0 THEN
                          CALL cl_err('',-239,0)
                          LET g_faj.faj022 = g_faj_t.faj022
                          NEXT FIELD faj022
                       END IF
                  #-->底稿不可重複
                  IF NOT cl_null(g_faj.faj02) THEN   #MOD-730111
                     SELECT COUNT(*) INTO l_n FROM fak_file
                       WHERE fak02  = g_faj.faj02
                         AND fak022 = g_faj.faj022
                         AND fak91  = 'N'
                          IF l_n > 0 THEN
                             CALL cl_err(g_faj.faj02,'afa-301',0)
                             LET g_faj.faj022 = g_faj_t.faj022
                             NEXT FIELD faj02
                          END IF
                  END IF   #MOD-730111
             END IF
             LET l_modify_flag = 'Y'
             IF (l_lock_sw = 'Y') THEN            #已鎖住
                 LET l_modify_flag = 'N'
             END IF
             IF (l_modify_flag = 'N') THEN
                 LET g_faj.faj022 = g_faj_t.faj022
                 DISPLAY BY NAME g_faj.faj022
                 NEXT FIELD faj022
             END IF
             IF cl_null(g_faj.faj022) THEN LET g_faj.faj022 = ' ' END IF
             LET g_faj_o.faj022 = g_faj.faj022
          END IF
          CALL i100_set_required(p_cmd)   #No.MOD-530114
 
      AFTER FIELD faj03
          IF NOT cl_null(g_faj.faj03) THEN
             IF g_faj.faj03 NOT MATCHES '[1-3]' THEN
                LET g_faj.faj03 = g_faj_t.faj03
                DISPLAY BY NAME g_faj.faj03
                NEXT FIELD faj03
             END IF
             LET g_faj_o.faj03 = g_faj.faj03
          END IF
 
      BEFORE FIELD faj43
          CALL i100_set_entry(p_cmd)
 
      AFTER FIELD faj43
          IF NOT cl_null(g_faj.faj43) THEN
            #IF g_faj.faj43 NOT MATCHES '[0-9X]' THEN   #TQC-630004   #MOD-AB0039 mark
             IF g_faj.faj43 NOT MATCHES '[04]' THEN                   #MOD-AB0039
                CALL cl_err(g_faj.faj43,'afa-127',0)                  #MOD-AB0039
                LET g_faj.faj43 = g_faj_t.faj43
                DISPLAY BY NAME g_faj.faj43
                NEXT FIELD faj43
             END IF
             LET g_faj.faj201 = g_faj.faj43
             DISPLAY BY NAME g_faj.faj201       #MOD-860048 add
             LET g_faj.faj432 = g_faj.faj43   #No:FUN-AB0088
             DISPLAY BY NAME g_faj.faj432     #No:FUN-AB0088
             LET g_faj_o.faj43 = g_faj.faj43
             CALL i100_set_no_entry(p_cmd)
          END IF
     #-----No:FUN-AB0088-----
      BEFORE FIELD faj432
          CALL i100_set_entry(p_cmd)

      AFTER FIELD faj432
          IF NOT cl_null(g_faj.faj432) THEN
             IF g_faj.faj432 NOT MATCHES '[04]' THEN
                CALL cl_err(g_faj.faj432,'afa-127',0)
                LET g_faj.faj432 = g_faj_t.faj432
                DISPLAY BY NAME g_faj.faj432
                NEXT FIELD faj432
             END IF
             LET g_faj_o.faj432 = g_faj.faj432
             CALL i100_set_no_entry(p_cmd)
          END IF
      #-----No:FUN-AB0088 END-----

      AFTER FIELD faj04
          IF NOT cl_null(g_faj.faj04) THEN
             IF g_faj.faj04<>g_faj_t.faj04 OR g_faj_t.faj04 IS NULL THEN
               CALL i100_faj04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_faj.faj04,g_errno,0)
                  LET g_faj.faj04 = g_faj_t.faj04
                  DISPLAY BY NAME g_faj.faj04
                  NEXT FIELD faj04
               END IF
               CALL i100_3133()    #財簽
               CALL i100_31332()      #No:FUN-AB0088
               CALL i100_6668()    #稅簽
             END IF
             SELECT fab13 INTO g_fab13 FROM fab_file
              WHERE fab01 = g_faj.faj04
             LET g_faj_o.faj04 = g_faj.faj04
             CALL i100_set_required(p_cmd)           #MOD-AB0001 
          END IF
 
      AFTER FIELD faj05
          IF NOT cl_null(g_faj.faj05) THEN
             CALL i100_faj05('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_faj.faj05,g_errno,0)
                 LET g_faj.faj05 = g_faj_t.faj05
                 DISPLAY BY NAME g_faj.faj05
                 NEXT FIELD faj05
              END IF
          END IF
          LET g_faj_o.faj05 = g_faj.faj05
 
      AFTER FIELD faj09
          IF NOT cl_null(g_faj.faj09) THEN
             IF g_faj.faj09 NOT MATCHES '[1-5]' THEN
                LET g_faj.faj09 = g_faj_t.faj09
                DISPLAY BY NAME g_faj.faj09
                NEXT FIELD faj09
             END IF
             LET g_faj_o.faj09 = g_faj.faj09
          CALL cl_set_comp_entry("faj110",TRUE)                                 
          IF g_faj.faj09 ='3' THEN                                              
             CALL cl_set_comp_required("faj27,faj272",FALSE)         #No:FUN-AB0088   
           # CALL cl_set_comp_required("faj27",FALSE)                
          END IF                                                                
          END IF
 
      AFTER FIELD faj10
          IF NOT cl_null(g_faj.faj10) THEN
             CALL i100_faj10('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_faj.faj10,g_errno,0)
                LET g_faj.faj10 = g_faj_t.faj10
                DISPLAY BY NAME g_faj.faj10
                NEXT FIELD faj10
             END IF
          END IF
          IF cl_null(g_faj.faj11) THEN
             LET g_faj.faj11 = g_faj.faj10
             DISPLAY BY NAME g_faj.faj11
          END IF

     #-MOD-B30109-add- 
      AFTER FIELD faj11
          #str----mark by guanyao160818
          #IF NOT cl_null(g_faj.faj11) THEN
          #   CALL i100_faj11('a')
          #   IF NOT cl_null(g_errno) THEN
          #      CALL cl_err(g_faj.faj11,g_errno,0)
          #      LET g_faj.faj11 = g_faj_t.faj11
          #      DISPLAY BY NAME g_faj.faj11
          #      NEXT FIELD faj11
          #   END IF
          #END IF
          #end----mark by guanyao160818
     #-MOD-B30109-end- 

      AFTER FIELD faj12                                                                                                             
          IF NOT cl_null(g_faj.faj12) THEN                                                                                          
             CALL i100_faj12('a') 
            #-MOD-B30109-add-                                                                                                  
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_faj.faj12,g_errno,0)
                LET g_faj.faj12 = g_faj_t.faj12
                DISPLAY BY NAME g_faj.faj12
                NEXT FIELD faj12
             END IF
            #-MOD-B30109-end-                                                                                                  
          END IF                                                                                                                    
 
       AFTER FIELD faj103                                                       
          IF NOT cl_null(g_faj.faj103) THEN                                     
             IF g_faj.faj103 < 0 THEN                                           
                CALL cl_err(g_faj.faj103,'anm-249',0)                           
                NEXT FIELD faj103                                               
             END IF                                                             
          END IF                                                                
                                                                                
       AFTER FIELD faj104                                                       
          IF NOT cl_null(g_faj.faj104) THEN                                     
             IF g_faj.faj104 < 0 THEN                                           
                CALL cl_err(g_faj.faj104,'anm-249',0)                           
                NEXT FIELD faj104                                               
             END IF                                                             
          END IF                                                                
 
       AFTER FIELD faj108                                                                                                           
          IF NOT cl_null(g_faj.faj108) THEN                                                                                         
             IF g_faj.faj108 < 0 THEN                                                                                               
                CALL cl_err(g_faj.faj108,'afa-037',0)                                                                               
                NEXT FIELD faj108                                                                                                   
             END IF                                                                                                                 
             IF g_faj.faj108 > g_faj.faj32 THEN                                                                                     
                CALL cl_err(g_faj.faj108,'afa-925',0)                                                                               
                NEXT FIELD faj108                                                                                                   
             END IF                                                                                                                 
             LET g_faj.faj108 = cl_digcut(g_faj.faj108,g_azi04)   #MOD-780116
             DISPLAY BY NAME g_faj.faj108   #MOD-780116
          END IF                                                                                                                    
                                                                                                                                    
       AFTER FIELD faj109                                                                                                           
          IF NOT cl_null(g_faj.faj109) THEN                                                                                         
             IF g_faj.faj109 < 0 THEN                                                                                               
                CALL cl_err(g_faj.faj109,'afa-037',0)                                                                               
                NEXT FIELD faj109                                                                                                   
             END IF                                                                                                                 
             IF g_faj.faj109 > g_faj.faj67 THEN                                                                                     
                CALL cl_err(g_faj.faj109,'afa-926',0)                                                                               
                NEXT FIELD faj109                        
             END IF                                                                                                                 
             LET g_faj.faj109 = cl_digcut(g_faj.faj109,g_azi04)   #MOD-780116
             DISPLAY BY NAME g_faj.faj109   #MOD-780116
          END IF                                                                                                                    
 
      AFTER FIELD faj17
          IF NOT cl_null(g_faj.faj17) THEN
             IF g_faj.faj17 < 0 THEN
                CALL cl_err(g_faj.faj17,'afa-043',0)
                NEXT FIELD faj17
             END IF
             IF g_faj.faj17 <>0 AND
                (g_faj_o.faj17 <> g_faj.faj17 OR g_faj_o.faj17 IS NULL) THEN
#No.FUN-B50035 --begin
                LET g_faj.faj13 = g_faj.faj14 / g_faj.faj17
                CALL cl_digcut(g_faj.faj13,g_azi04) RETURNING g_faj.faj13
             END IF
             DISPLAY BY NAME g_faj.faj13
#                LET g_faj.faj14 = g_faj.faj13 * g_faj.faj17
#                CALL cl_digcut(g_faj.faj14,g_azi04) RETURNING g_faj.faj14
#             END IF
#             DISPLAY BY NAME g_faj.faj14
#No.FUN-B50035 --end
             LET g_faj_o.faj17 = g_faj.faj17
          END IF
     
      AFTER FIELD faj18
         LET l_case = ""   #No.FUN-BB0086
          IF NOT cl_null(g_faj.faj18) THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO  l_cnt FROM gfe_file
              WHERE gfe01 = g_faj.faj18
             IF l_cnt = 0 THEN 
                CALL cl_err(g_faj.faj18,'afa-319',0)
                NEXT FIELD faj18
             END IF 
             #No.FUN-BB0086--add--begin--
             CALL i100_faj106_check()
             CALL i100_faj1062_check()
             IF g_aza.aza26 != '2' OR g_faj.faj61 != '4' THEN
                LET g_faj.faj110 = s_digqty(g_faj.faj110,g_faj.faj18)
                DISPLAY BY NAME g_faj.faj110
             ELSE 
                IF NOT i100_faj110_check() THEN 
                   LET l_case = "faj110"
                END IF 
             END IF 
             #IF NOT i100_faj111_check() THEN     #TQC-C20183
             #   LET l_case = "faj111"            #TQC-C20183
             #END IF                              #TQC-C20183
             CALL i100_faj111_check()             #TQC-C20183
             LET g_faj18_t = g_faj.faj18
             CASE l_case
                WHEN "faj110"
                   NEXT FIELD faj110
             #   WHEN "faj111"                    #TQC-C20183
             #      NEXT FIELD faj111             #TQC-C20183 
                OTHERWISE EXIT CASE 
             END CASE 
            #No.FUN-BB0086--add--end--
          END IF 
 
      AFTER FIELD faj13
          IF NOT cl_null(g_faj.faj13) THEN
             IF g_faj.faj13 < 0 THEN
                CALL cl_err(g_faj.faj13,'anm-249',0)
                NEXT FIELD faj13
             END IF
             IF g_faj.faj13 <>0 AND
                (g_faj_o.faj13<>g_faj.faj13 OR g_faj_o.faj13 IS NULL) THEN
                LET g_faj.faj14 = g_faj.faj13 * g_faj.faj17
                CALL cl_digcut(g_faj.faj14,g_azi04) RETURNING g_faj.faj14
                DISPLAY BY NAME g_faj.faj14
             END IF
             LET g_faj.faj13 = cl_digcut(g_faj.faj13,g_azi03)   #MOD-580279   #MOD-780116
             DISPLAY BY NAME g_faj.faj13   #MOD-580279
             LET g_faj_o.faj13 = g_faj.faj13
          END IF
 
 
      AFTER FIELD faj14
          IF NOT cl_null(g_faj.faj14) THEN
             #TQC-C50117-add--str
             IF NOT cl_null(g_faj.faj15) and NOT cl_null(g_faj.faj16) THEN
                IF g_faj.faj15 = g_aza.aza17 THEN
                   IF g_faj.faj14 != g_faj.faj16 THEN
                      CALL cl_err(' ','afa-420',0)
                      LET g_faj.faj16 = g_faj.faj14
                      DISPLAY BY NAME g_faj.faj16
                   END IF
                END IF
             END IF
             #TQC-C50117-add-end
             IF g_faj.faj14 < 0 THEN
                CALL cl_err(g_faj.faj14,'anm-249',0)
                NEXT FIELD faj14
             END IF
             LET g_faj.faj62 = g_faj.faj14
             LET g_faj.faj62 = cl_numfor(g_faj.faj62,18,g_azi04)   #MOD-580279
#            LET g_faj.faj142 = g_faj.faj14   #No:FUN-AB0088 #TQC-B50091 mark
             LET g_faj.faj142 = g_faj.faj14 / g_faj.faj144   #TQC-B50091
#            LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04)    #No:FUN-AB0088 #TQC-B50091 MARK
#TQC-B50091 --Begin
             SELECT azi04 INTO g_azi04_1 FROM azi_file
              WHERE azi01 = g_faj.faj143
             LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04_1)
#TQC-B50091 --End
            
             DISPLAY BY NAME g_faj.faj62,g_faj.faj142   #No:FUN-AB0088   #MOD-580279
             #新增時,預設未折減額=本幣成本-累計折舊-預留殘值
             IF (g_faj_t.faj14 != g_faj.faj14) OR
                (g_faj.faj14 IS NOT NULL AND g_faj_t.faj14 IS NULL) THEN
                CALL i100_3133()   #財簽
                CALL i100_31332()  #財簽   #No:FUN-AB0088
                CALL i100_6668()   #稅簽   #MOD-8A0008 add
                IF cl_null(g_faj.faj32) THEN LET g_faj.faj32 = 0 END IF
                IF cl_null(g_faj.faj31) THEN LET g_faj.faj31 = 0 END IF
                IF cl_null(g_faj.faj322) THEN LET g_faj.faj322 = 0 END IF   #No:FUN-AB0088
                IF cl_null(g_faj.faj312) THEN LET g_faj.faj312 = 0 END IF   #No:FUN-AB0088
                IF cl_null(g_faj.faj142) THEN LET g_faj.faj142 = 0 END IF   #No:FUN-AB0088
                IF cl_null(g_faj.faj62) THEN LET g_faj.faj62 = 0 END IF
                IF cl_null(g_faj.faj67) THEN LET g_faj.faj67 = 0 END IF
                IF cl_null(g_faj.faj66) THEN LET g_faj.faj66 = 0 END IF
                LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
                LET g_faj.faj68 = cl_numfor(g_faj.faj68,18,g_azi04)   #MOD-580279
                DISPLAY BY NAME g_faj.faj68   #MOD-580279
             END IF
             LET g_faj.faj14 = cl_numfor(g_faj.faj14,18,g_azi04)   #MOD-580279
             DISPLAY BY NAME g_faj.faj14   #MOD-580279
             LET g_faj_o.faj14 = g_faj.faj14
          END IF
      AFTER FIELD faj141                                                        
         IF NOT cl_null(g_faj.faj141) THEN                                      
            IF g_faj.faj141 < 0 THEN                                            
               CALL cl_err(g_faj.faj141,'anm-249',0)                            
               NEXT FIELD faj141                                                
            END IF                                                              
         END IF                                                                 
#TQC-B50091
        AFTER FIELD faj144
            IF cl_null(g_faj_o.faj144) OR g_faj_o.faj144 <> g_faj.faj144 THEN
               LET g_faj.faj144=cl_digcut(g_faj.faj144,g_azi04_1) #CHI-C60010 add
               LET g_faj.faj142 = g_faj.faj14 / g_faj.faj144
               CALL i100_31332()
               SELECT azi04 INTO g_azi04_1 FROM azi_file
                WHERE azi01 = g_faj.faj143
               LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04_1)
               DISPLAY BY NAME g_faj.faj142,g_faj.faj144   #CHI-C60010 add faj144
            END IF
#TQC-B50091
 
 
      AFTER FIELD faj16
          IF g_faj.faj16 < 0 THEN
             CALL cl_err(g_faj.faj16,'anm-249',0)
             NEXT FIELD faj16
          END IF
          #TQC-C50117-add--str
          IF NOT cl_null(g_faj.faj16) THEN
             IF NOT cl_null(g_faj.faj15) and NOT cl_null(g_faj.faj14) THEN
                IF g_faj.faj15 = g_aza.aza17 THEN
                   IF g_faj.faj14 != g_faj.faj16 THEN
                      CALL cl_err(' ','afa-420',1)
                      LET g_faj.faj16 = g_faj.faj14
                      DISPLAY BY NAME g_faj.faj16
                      NEXT FIELD faj16
                   END IF
                END IF
             END IF
          END IF
          #TQC-C50117-add-end
          SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01= g_faj.faj15   #MOD-580279
          LET g_faj.faj16 = cl_numfor(g_faj.faj16,18,t_azi04)   #MOD-580279
          DISPLAY BY NAME g_faj.faj16   #MOD-580279
          LET g_faj_o.faj16 = g_faj.faj16
          IF g_faj.faj15 = g_aza.aza17 AND 
             g_faj.faj14 <> g_faj.faj16 THEN
             CALL cl_err('','afa-420',0)
             NEXT FIELD faj16
          END IF
 
      AFTER FIELD faj15
          IF NOT cl_null(g_faj.faj15) THEN
             IF (g_faj_t.faj15 != g_faj.faj15) OR
                (g_faj.faj15 IS NOT NULL AND g_faj_t.faj15 IS NULL) THEN
                 CALL i100_faj15('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_faj.faj15,g_errno,0)
                    LET g_faj.faj15 = g_faj_t.faj15
                    DISPLAY BY NAME g_faj.faj15
                    NEXT FIELD faj15
                 END IF
                 IF g_faj.faj15 = g_aza.aza17 THEN
                    LET g_faj.faj16 = g_faj.faj14
                    DISPLAY BY NAME g_faj.faj16
                 END IF
                 LET g_faj_o.faj15 = g_faj.faj15
            END IF
          END IF
 
      AFTER FIELD faj19
          IF NOT cl_null(g_faj.faj19) THEN
             IF (g_faj_t.faj19 != g_faj.faj19) OR
                (g_faj.faj19 IS NOT NULL AND g_faj_t.faj19 IS NULL) THEN
                CALL i100_faj19('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_faj.faj19,g_errno,0)
                   LET g_faj.faj19 = g_faj_t.faj19
                   DISPLAY BY NAME g_faj.faj19
                   NEXT FIELD faj19
                END IF
             END IF
          END IF
 
      AFTER FIELD faj20
          IF NOT cl_null(g_faj.faj20) THEN
             IF (g_faj_t.faj20 != g_faj.faj20) OR
                (g_faj.faj20 IS NOT NULL AND g_faj_t.faj20 IS NULL) THEN
                CALL i100_faj20('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_faj.faj20,g_errno,0)
                   LET g_faj.faj20 = g_faj_t.faj20
                   DISPLAY BY NAME g_faj.faj20
                   NEXT FIELD faj20
                END IF
             END IF
          END IF
 
      AFTER FIELD faj21
          IF NOT cl_null(g_faj.faj21) THEN
             IF (g_faj_t.faj21 != g_faj.faj21) OR
                (g_faj.faj21 IS NOT NULL AND g_faj_t.faj21 IS NULL) THEN
                CALL i100_faj21('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_faj.faj21,g_errno,0)
                   LET g_faj.faj21 = g_faj_t.faj21
                   DISPLAY BY NAME g_faj.faj21
                   NEXT FIELD faj21
                END IF
             END IF
          END IF
          LET g_faj_o.faj21 = g_faj.faj21
 
      AFTER FIELD faj22  #存放工廠
         IF NOT cl_null(g_faj.faj22) AND g_faa.faa24 = 'Y'
         THEN CALL i100_faj22('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_faj.faj22,g_errno,0)
                 LET g_faj.faj22 = g_faj_t.faj22
                 DISPLAY BY NAME g_faj.faj22
                 NEXT FIELD faj22
              END IF
         END IF
         LET g_faj_o.faj22 = g_faj.faj22
 
      AFTER FIELD faj23
         IF NOT cl_null(g_faj.faj23) THEN
            IF g_faj.faj23 NOT MATCHES '[1-2]' THEN
               LET g_faj.faj23 = g_faj_t.faj23
               DISPLAY BY NAME g_faj.faj23
               NEXT FIELD faj23
            END IF
            LET g_faj_o.faj23 = g_faj.faj23
         END IF
 
      BEFORE FIELD faj24
         IF cl_null(g_faj.faj24) THEN
            IF g_faj.faj23 = '1' THEN
               CALL cl_err(' ','afa-047',0)
            ELSE
               CALL cl_err(' ','afa-048',0)
            END IF
         END IF
         IF g_faj.faj23 = '1' AND p_cmd = 'a' AND cl_null(g_faj.faj24) THEN
            LET g_faj.faj24 = g_faj.faj20
            DISPLAY BY NAME g_faj.faj24
         END IF
 
 
      AFTER FIELD faj24
          LET l_faj24 = NULL                                                #TQC-950142
           IF g_faj.faj23 = '1' THEN
              IF cl_null(g_faj.faj24) THEN
                 NEXT FIELD faj24
              ELSE
                 CALL i100_faj241('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_faj.faj24,g_errno,0)
                     LET g_faj.faj24 = g_faj_t.faj24
                     DISPLAY BY NAME g_faj.faj24
                     NEXT FIELD faj24
                  END IF
             END IF
             #03/07/17 By Wiky#No:7620 控管要在分攤部門為1的faj24地方控管
             #--->預設部門會計科目
             IF g_faa.faa20 = '2' THEN
                   LET l_fbi02 = ''   #MOD-530231
                  DECLARE i100_fbi
                      CURSOR FOR SELECT fbi02,fbi021 FROM fbi_file         #No.FUN-680028
                                       WHERE fbi01= g_faj.faj24   #NO7620
                                         AND fbi03= g_faj.faj04
                  FOREACH i100_fbi INTO l_fbi02,l_fbi021         #No.FUN-680028
                    IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                    IF not cl_null(l_fbi02) THEN EXIT FOREACH END IF
                    IF not cl_null(l_fbi021) THEN EXIT FOREACH END IF #No.FUN-680028
                  END FOREACH
                     IF l_faj24 IS NULL OR g_faj.faj24 <> l_faj24 THEN
                        LET l_faj24 = g_faj.faj24
                        IF cl_null(l_fbi02) AND g_faj.faj28 NOT MATCHES '[0]' THEN #7566
                           CALL cl_err(g_faj.faj24,'afa-317',1)
                        END IF
                        LET g_faj.faj55 = l_fbi02
                        DISPLAY BY NAME g_faj.faj55
                     #  IF g_aza.aza63 = 'Y' THEN
                        IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
                           IF cl_null(l_fbi021) AND g_faj.faj28 NOT MATCHES '[0]' THEN #7566
                              CALL cl_err(g_faj.faj24,'afa-317',1)
                           END IF
                           LET g_faj.faj551 = l_fbi021
                           DISPLAY BY NAME g_faj.faj551
                        END IF
                     END IF

              ELSE IF cl_null(g_faj.faj55) THEN
                      LET g_faj.faj55 = g_fab13
                  END IF
                  IF cl_null(g_fab13) THEN
                     CALL cl_err(g_faj.faj24,'afa-318',1)
                  END IF
              END IF
           ELSE
              IF cl_null(g_faj.faj24) THEN
              ELSE
                 CALL i100_faj242('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_faj.faj24,g_errno,1)
                     LET g_faj.faj24 = g_faj_t.faj24
                     DISPLAY BY NAME g_faj.faj24
                     NEXT FIELD faj24
                  END IF
             END IF
           END IF
           LET g_faj_o.faj24 = g_faj.faj24
 
        AFTER FIELD faj25
           IF NOT cl_null(g_faj.faj25) THEN
              IF cl_null(g_faj.faj26) THEN         #MOD-C30856 add
                 LET g_faj.faj26 = g_faj.faj25     #MOD-C30856 add
              END IF                               #MOD-C30856 add
              DISPLAY BY NAME g_faj.faj26
              LET g_faj_o.faj25 = g_faj.faj25
           END IF
 
        AFTER FIELD faj26
           IF NOT cl_null(g_faj.faj26) THEN
              IF g_faj.faj26 <= g_faa.faa09 THEN
                 CALL cl_err('','afa-517',1)
              END IF
              LET l_day = DAY(g_faj.faj26)
              CALL s_yp(g_faj.faj26)
                   RETURNING l_year,l_month
              LET l_date2 = l_year USING '&&&&',l_month USING '&&',l_day USING '&&'
              LET l_date  = l_date2
              CALL s_faj27(l_date,g_faa.faa15) RETURNING l_faj27
          

              IF cl_null(g_faj.faj27) THEN        #FUN-C50124  add 
                 IF g_faj.faj09='1'  THEN         #FUN-C50124  add
                    LET g_faj.faj27 = l_faj27    
                 ELSE                             #FUN-C50124  add
                    LET g_faj.faj27 = l_year USING '&&&&',l_month USING '&&'  #FUN-C50124  add
                 END IF                           #FUN-C50124  add
              END IF                              #FUN-C50124  add

              LET g_faj.faj100 = g_faj.faj26
              DISPLAY BY NAME g_faj.faj27
              LET g_faj_o.faj26 = g_faj.faj26

         END IF
 
        #CHI-AA0019 add --start--
        AFTER FIELD faj27
           IF NOT cl_null(g_faj.faj27) THEN
              LET l_str = g_faj.faj27
              LET l_len = l_str.getlength()
              IF l_len != 6 THEN
                 CALL cl_err(g_faj.faj27,'sub-005',1)
                 NEXT FIELD faj27
              END IF
              FOR i = 1 TO l_len
                  IF l_str.substring(i,i) NOT MATCHES '[0123456789]' THEN
                     CALL cl_err(g_faj.faj27,'sub-005',1)
                     NEXT FIELD faj27
                  END IF
              END FOR
              IF NOT cl_chkym(g_faj.faj27) THEN
                 CALL cl_err(g_faj.faj27,'sub-005',1)
                 NEXT FIELD faj27
              END IF
           END IF
        #CHI-AA0019 add --end-- 

        BEFORE FIELD faj28
           CALL i100_set_entry(p_cmd)
 
        AFTER FIELD faj28   #折舊方式
           IF NOT cl_null(g_faj.faj28) THEN
              IF g_faj.faj28 NOT MATCHES '[0-5]' THEN
                 LET g_faj.faj28 = g_faj_t.faj28
                 DISPLAY BY NAME g_faj.faj28
                 NEXT FIELD faj28
              END IF
              IF g_faj.faj28 ='0' THEN   #NO:5153
                  LET g_faj.faj29=0
                  LET g_faj.faj30=0
                  LET g_faj.faj31=0
                  LET g_faj.faj32=0
                  LET g_faj.faj33=g_faj.faj14
                  LET g_faj.faj34='N'
                  LET g_faj.faj35=0
                  LET g_faj.faj36=0
                  LET g_faj.faj71='N'
                  LET g_faj.faj72=0
                  LET g_faj.faj73=0

                  DISPLAY BY NAME g_faj.faj29,g_faj.faj30,
                                  g_faj.faj31,g_faj.faj32,
                                  g_faj.faj33,g_faj.faj34,
                                  g_faj.faj35,g_faj.faj36,
                                  g_faj.faj71,g_faj.faj72,  #No.FUN-7A0079
                                  g_faj.faj73  #No.FUN-7A0079
                  DISPLAY BY NAME g_faj.faj53,g_faj.faj531, #MOD-910119 add
                                  g_faj.faj54,g_faj.faj541  #MOD-910119 add
 
              END IF  
              IF g_faj.faj28 != g_faj_t.faj28 OR g_faj_t.faj28 IS NULL THEN
                 CALL i100_3133()   #財簽
                 CALL i100_31332()  #財簽   #No:FUN-AB0088
                 CALL i100_6668()   #稅簽
              END IF
              LET g_faj_o.faj28 = g_faj.faj28
              CALL i100_set_no_entry(p_cmd)
           END IF
 
        BEFORE FIELD faj29
          #----推出配件/費用之耐用年限
          IF g_faj.faj021 MATCHES '[23]' THEN
             IF (p_cmd = 'a' AND (g_faj_o.faj29 IS NULL OR g_faj_o.faj29 <> g_faj.faj29)) OR 
                (p_cmd = 'u' AND g_faj_o.faj29 <> g_faj.faj29) THEN
                CALL s_afaym(g_faj.faj02,g_faj.faj27,'1') RETURNING g_faj.faj29
                LET g_faj.faj30 = g_faj.faj29
                CALL s_afaym(g_faj.faj02,g_faj.faj27,'2') RETURNING g_faj.faj64
                LET g_faj.faj65 = g_faj.faj64
                DISPLAY BY NAME g_faj.faj29,g_faj.faj30
             END IF
          END IF
 
        AFTER FIELD faj29
           IF NOT cl_null(g_faj.faj29) THEN
              IF g_faj.faj29 <0 THEN                                            
                 CALL cl_err(g_faj.faj29,'anm-249',0)                           
                 NEXT FIELD faj29                                               
              END IF                                                            
              #--->新增時,預設未使用年限為耐用年限
              IF g_faj.faj021 = '1' THEN  
                 IF (p_cmd = 'a' AND (g_faj_o.faj29 IS NULL OR g_faj_o.faj29 <> g_faj.faj29)) OR 
                    (p_cmd = 'u' AND g_faj_o.faj29 <> g_faj.faj29) THEN
                    LET g_faj.faj30 = g_faj.faj29
                    LET g_faj.faj64 = g_faj.faj29
                    LET g_faj.faj65 = g_faj.faj64
                    DISPLAY BY NAME g_faj.faj30
                 END IF   #MOD-750008
              END IF
              IF (p_cmd='a' AND g_faj.faj29<>0) OR
                 (p_cmd = 'u' AND g_faj_o.faj29 != g_faj.faj29) THEN
                 CALL i100_3133()   #財簽
                 CALL i100_31332()  #財簽   #No:FUN-AB0088
                 CALL i100_6668()   #稅簽
              END IF
              LET g_faj_o.faj29 = g_faj.faj29
           END IF
 

        AFTER FIELD faj30
           IF NOT cl_null(g_faj.faj30) THEN
              IF g_faj.faj30 <0 THEN                                            
                 CALL cl_err(g_faj.faj30,'anm-249',0)                           
                 NEXT FIELD faj30                                               
              END IF                                                            
              #新增時,預設稅簽未使用年限
              IF p_cmd = 'a' THEN LET g_faj.faj65 = g_faj.faj30 END IF
              LET g_faj_o.faj30 = g_faj.faj30
              IF g_faj.faj30 > g_faj.faj29 THEN                                                                                     
                 CALL cl_err(g_faj.faj30,'afa-165',0)                                                                               
                 NEXT FIELD faj30                                                                                                   
              END IF                                                                                                                
           END IF
 
        BEFORE FIELD faj31
          IF cl_null(g_faj.faj31) THEN
             LET g_faj.faj31 = 0
             DISPLAY BY NAME g_faj.faj31
          END IF
 
        AFTER FIELD faj31
           IF NOT cl_null(g_faj.faj31) THEN
              IF p_cmd = 'a' THEN LET g_faj.faj66 = g_faj.faj31 END IF
              IF g_faj.faj31 <0 THEN                                            
                 CALL cl_err(g_faj.faj31,'anm-249',0)                           
                 NEXT FIELD faj31                                               
              END IF                                                            
              LET g_faj.faj31 = cl_numfor(g_faj.faj31,18,g_azi04)   #MOD-580279
              DISPLAY BY NAME g_faj.faj31   #MOD-580279
              LET g_faj_o.faj31 = g_faj.faj31
           END IF
 
 
        BEFORE FIELD faj32
          IF cl_null(g_faj.faj32) THEN
             LET g_faj.faj32 = 0
             DISPLAY BY NAME g_faj.faj32
          END IF
 
       AFTER FIELD faj32
          IF (g_faj_o.faj32 != g_faj.faj32 ) OR
             (g_faj.faj32 IS NOT NULL AND g_faj_o.faj32 IS NULL) THEN
              IF g_faj.faj32 <0 THEN                                            
                 CALL cl_err(g_faj.faj32,'anm-249',0)                           
                 NEXT FIELD faj32                                               
              END IF                                                            
             LET g_faj.faj33 = g_faj.faj14 - g_faj.faj32
             LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
             DISPLAY BY NAME g_faj.faj33
          END IF
          LET g_faj.faj32 = cl_numfor(g_faj.faj32,18,g_azi04)   #MOD-580279
          DISPLAY BY NAME g_faj.faj32   #MOD-580279
          LET g_faj_o.faj32 = g_faj.faj32
 
 
        BEFORE FIELD faj33
          IF p_cmd = 'a' OR p_cmd = 'u' THEN
            #LET g_faj.faj33 = g_faj.faj14 - g_faj.faj32                 #No.CHI-B80018 mark
             LET g_faj.faj33 = g_faj.faj141 + g_faj.faj14 - g_faj.faj32  #No.CHI-B80018 add
             LET g_faj.faj68 = g_faj.faj33
          END IF
 
        AFTER FIELD faj33
           IF p_cmd = 'a' THEN
              LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
           END IF
           IF NOT cl_null(g_faj.faj33) THEN                                     
              IF g_faj.faj33 <0 THEN                                            
                 CALL cl_err(g_faj.faj33,'anm-249',0)                           
                 NEXT FIELD faj33                                               
              END IF                                                            
           END IF                                                               
           LET g_faj.faj33 = cl_numfor(g_faj.faj33,18,g_azi04)   #MOD-580279
           DISPLAY BY NAME g_faj.faj33   #MOD-580279
           LET g_faj_o.faj33 = g_faj.faj33
         
        AFTER FIELD faj331                                                                                                          
           IF NOT cl_null(g_faj.faj331) THEN                                                                                        
              IF g_faj.faj331 <0 THEN                                                                                               
                 CALL cl_err(g_faj.faj331,'anm-249',0)                                                                              
                 NEXT FIELD faj331                                                                                                  
              END IF                                                                                                                
           END IF                                                                                                                   
           LET g_faj.faj331 = cl_numfor(g_faj.faj331,18,g_azi04)                                                                    
           DISPLAY BY NAME g_faj.faj33                                                                                              
           LET g_faj_o.faj331 = g_faj.faj331                                                                                        
 
        BEFORE FIELD faj34
            CALL i100_set_entry(p_cmd)
 
        AFTER FIELD faj34
           IF NOT cl_null(g_faj.faj34) THEN
              IF g_faj.faj34 = 'Y' THEN
              ELSE
                 LET g_faj.faj35 = 0
                 LET g_faj.faj36 = 0
                 DISPLAY BY NAME g_faj.faj35,g_faj.faj36
              END IF
              LET g_faj_o.faj34 = g_faj.faj34
           END IF
            CALL i100_set_no_entry(p_cmd)
        AFTER FIELD faj35                                                       
          IF NOT cl_null(g_faj.faj35) THEN                                      
             IF g_faj.faj35 <0 THEN                                             
                CALL cl_err(g_faj.faj35,'anm-249',0)                            
                NEXT FIELD faj35                                                
             END IF                                                             
             LET g_faj.faj35 = cl_digcut(g_faj.faj35,g_azi04)   #MOD-780116
             DISPLAY BY NAME g_faj.faj35   #MOD-780116
          END IF                                                                
                                                                                
        AFTER FIELD faj36                                                       
          IF NOT cl_null(g_faj.faj36) THEN                                      
             IF g_faj.faj36 <0 THEN                                             
                CALL cl_err(g_faj.faj36,'anm-249',0)                            
                NEXT FIELD faj36                                                
             END IF                                                             
          END IF                                                                
 
        BEFORE FIELD faj71
            CALL i100_set_entry(p_cmd)
 
        AFTER FIELD faj71
           IF NOT cl_null(g_faj.faj71) THEN
              IF g_faj.faj71 = 'Y' THEN
              ELSE
                 LET g_faj.faj72 = 0
                 LET g_faj.faj73 = 0
                 DISPLAY BY NAME g_faj.faj72,g_faj.faj73
              END IF
              LET g_faj_o.faj71 = g_faj.faj71
           END IF
            CALL i100_set_no_entry(p_cmd)
 
        AFTER FIELD faj72                                                       
          IF NOT cl_null(g_faj.faj72) THEN                                      
             IF g_faj.faj72 <0 THEN                                             
                CALL cl_err(g_faj.faj72,'anm-249',0)                            
                NEXT FIELD faj72                                                
             END IF                                                             
             LET g_faj.faj72 = cl_digcut(g_faj.faj72,g_azi04)
             DISPLAY BY NAME g_faj.faj72
          END IF                                                                
                                                                                
        AFTER FIELD faj73                                                      
          IF NOT cl_null(g_faj.faj73) THEN                                      
             IF g_faj.faj73 <0 THEN                                             
                CALL cl_err(g_faj.faj73,'anm-249',0)                            
                NEXT FIELD faj73                                                
             END IF                                                             
          END IF                                                                
 
      AFTER FIELD faj44
          IF NOT cl_null(g_faj.faj44) THEN
             CALL i100_faj44('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_faj.faj44,g_errno,0)
                 LET g_faj.faj44 = g_faj_t.faj44
                 DISPLAY BY NAME g_faj.faj44
                 NEXT FIELD faj44
              END IF
         END IF
         IF cl_null(g_faj.faj44) THEN LET g_faj.faj44 = ' ' END IF
         LET g_faj_o.faj44 = g_faj.faj44
 
       BEFORE FIELD faj53
           IF cl_null(g_faj.faj53) THEN
              SELECT fab11 INTO g_faj.faj53
                FROM fab_file
               WHERE fab01 = g_faj.faj04
           END IF
           IF g_faj.faj53<>' ' AND g_faj.faj53 IS NOT NULL THEN
              CALL i100_faj53(g_faj.faj53,g_aza.aza81) RETURNING aag02_1  #No.FUN-740026   #No.TQC-740137
              DISPLAY BY NAME g_faj.faj53
              DISPLAY aag02_1 TO FORMONLY.aag02_1
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_1
           END IF
           IF g_faj.faj54<>' ' AND g_faj.faj54 IS NOT NULL THEN
              CALL i100_faj53(g_faj.faj54,g_aza.aza81) RETURNING aag02_2      #No.FUN-740026 #No.TQC-740137
              DISPLAY BY NAME g_faj.faj54
              DISPLAY aag02_2 TO FORMONLY.aag02_2
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_2
           END IF
           IF g_faj.faj55<>' ' AND g_faj.faj55 IS NOT NULL THEN
              CALL i100_faj53(g_faj.faj55,g_aza.aza81) RETURNING aag02_3     #No.FUN-740026       #No.TQC-740137
              DISPLAY BY NAME g_faj.faj55
              DISPLAY aag02_3 TO FORMONLY.aag02_3
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_3
           END IF
           IF cl_null(g_faj.faj531) THEN
              SELECT fab111 INTO g_faj.faj531
                FROM fab_file
               WHERE fab01 = g_faj.faj04
           END IF
           IF g_faj.faj531<>' ' AND g_faj.faj531 IS NOT NULL THEN
           #  CALL i100_faj531(g_faj.faj531,g_aza.aza82) RETURNING aag02_1a    #No.FUN-740026 #No.TQC-740137
              CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a   #No:FUN-AB0088
              DISPLAY BY NAME g_faj.faj531
              DISPLAY aag02_1a TO FORMONLY.aag02_1a
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_1a
           END IF
           IF g_faj.faj541<>' ' AND g_faj.faj541 IS NOT NULL THEN
           #  CALL i100_faj531(g_faj.faj541,g_aza.aza82) RETURNING aag02_2a    #No.FUN-740026 #No.TQC-740137
           #  CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a   #No:FUN-AB0088 #No:FUN-BA0112 mark 
              CALL i100_faj531(g_faj.faj541,g_faa.faa02c) RETURNING aag02_2a   #No:FUN-BA0112 add   
              DISPLAY BY NAME g_faj.faj541
              DISPLAY aag02_2a TO FORMONLY.aag02_2a
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_2a
           END IF
           IF g_faj.faj551<>' ' AND g_faj.faj551 IS NOT NULL THEN
           #  CALL i100_faj531(g_faj.faj551,g_aza.aza82) RETURNING aag02_3a    #No.FUN-740026  #No.TQC-740137
           #  CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a   #No:FUN-AB0088 #No:FUN-BA0112 mark 
              CALL i100_faj531(g_faj.faj551,g_faa.faa02c) RETURNING aag02_3a   #No:FUN-BA0112 add
              DISPLAY BY NAME g_faj.faj551
              DISPLAY aag02_3a TO FORMONLY.aag02_3a
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_3a
           END IF
 
       AFTER FIELD faj53
           IF NOT cl_null(g_faj.faj53) THEN
              CALL i100_faj53(g_faj.faj53,g_aza.aza81)  RETURNING aag02_1   #No.FUN-740026 #No.TQC-740137
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_faj.faj53,g_errno,1)
                 CALL cl_err(g_faj.faj53,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_faj.faj53
                 LET g_qryparam.arg1 = g_aza.aza81 
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_faj.faj53 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_faj.faj53
                 DISPLAY BY NAME g_faj.faj53 
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_1
                 NEXT FIELD faj53
              END IF
              #No.FUN-B40004  --Begin
              IF g_faj.faj23 = '1' AND NOT cl_null(g_faj.faj24) THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_faj.faj53
                    AND aag00 = g_aza.aza81
                #IF l_aag05 = 'Y' THEN                          #MOD-BB0018 mark
                 IF l_aag05 = 'Y' AND g_faj.faj28 <> '0' THEN   #MOD-BB0018
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 !='Y' THEN
                       LET g_errno = ' '
                       CALL s_chkdept(g_aaz.aaz72,g_faj.faj53,g_faj.faj24,g_aza.aza81)
                            RETURNING g_errno
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_faj.faj53,g_errno,0)
                    DISPLAY BY NAME g_faj.faj53
                    NEXT FIELD faj53
                 END IF
               END IF
               #No.FUN-B40004  --End
           END IF
           IF cl_null(g_faj.faj53) THEN
              DISPLAY ' ' TO FORMONLY.aag02_1
              DISPLAY BY NAME g_faj.faj53
           END IF
 
       AFTER FIELD faj54
           IF NOT cl_null(g_faj.faj54) THEN
              CALL i100_faj53(g_faj.faj54,g_aza.aza81) RETURNING aag02_2      #No.FUN-740026 #No.TQC-740137
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_faj.faj54,g_errno,1)
                 CALL cl_err(g_faj.faj54,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_faj.faj54
                 LET g_qryparam.arg1 = g_aza.aza81 
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_faj.faj54 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_faj.faj54
                 DISPLAY BY NAME g_faj.faj54 
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_2
                 NEXT FIELD faj54
              END IF
              #No.FUN-B40004  --Begin
              IF g_faj.faj23 = '1' AND NOT cl_null(g_faj.faj24) THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_faj.faj54
                    AND aag00 = g_aza.aza81
                #IF l_aag05 = 'Y' THEN                          #MOD-BB0018 mark
                 IF l_aag05 = 'Y' AND g_faj.faj28 <> '0' THEN   #MOD-BB0018
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 !='Y' THEN
                       LET g_errno = ' '
                       CALL s_chkdept(g_aaz.aaz72,g_faj.faj54,g_faj.faj24,g_aza.aza81)
                            RETURNING g_errno
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_faj.faj54,g_errno,0)
                    DISPLAY BY NAME g_faj.faj54
                    NEXT FIELD faj54
                 END IF
               END IF
               #No.FUN-B40004  --End
           END IF
           DISPLAY BY NAME g_faj.faj54
           IF cl_null(g_faj.faj54) THEN
              DISPLAY ' ' TO FORMONLY.aag02_2
           ELSE
              DISPLAY aag02_2 TO FORMONLY.aag02_2
           END IF
 
       AFTER FIELD faj55
           IF NOT cl_null(g_faj.faj55) THEN
              CALL i100_faj53(g_faj.faj55,g_aza.aza81) RETURNING aag02_3      #No.FUN-740026 #No.TQC-740137
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_faj.faj55,g_errno,1)
                 CALL cl_err(g_faj.faj55,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_faj.faj55
                 LET g_qryparam.arg1 = g_aza.aza81 
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_faj.faj55 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_faj.faj55
                 DISPLAY BY NAME g_faj.faj55 
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_3
                 NEXT FIELD faj55
              END IF
             #------------------------MOD-D10167------------------------(S)
              LET l_aag05=''
              SELECT aag05 INTO l_aag05 FROM aag_file
               WHERE aag01 = g_faj.faj55
                 AND aag00 = g_aza.aza81
              IF g_faa.faa20 = '1' AND NOT cl_null(g_faj.faj24) THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) FROM fab_file
                  WHERE fab01 = g_faj.faj04
                    AND fab13 = g_faj.faj55
                 IF l_cnt = 0 THEN
#                   CALL cl_err(g_faj.faj55,'afa-317',0) #MOD-D60243 mark by yuhuabao #此处报错信息有问题,折旧科目依照资产时候，是检查afai010的资产主要类型对应的折旧科目资料存在否，而非afai080部门的
                    CALL cl_err(g_faj.faj55,'afa-318',0)    #MOD-D60243 add by yuhuabao 
                    DISPLAY BY NAME g_faj.faj55
                    NEXT FIELD faj55
                 END IF
                 IF l_aag05 = 'Y' AND g_faj.faj28 <> '0' THEN
                    LET g_errno = ' '
                    CALL s_chkdept(g_aaz.aaz72,g_faj.faj55,g_faj.faj24,g_aza.aza81)
                         RETURNING g_errno
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_faj.faj55,g_errno,0)
                       DISPLAY BY NAME g_faj.faj55
                       NEXT FIELD faj55
                    END IF
                 END IF
              ELSE
                 IF g_faj.faj23 = '1' AND NOT cl_null(g_faj.faj24) THEN
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt FROM fbi_file
                     WHERE fbi01 = g_faj.faj24
                       AND fbi03 = g_faj.faj04
                       AND fbi02 = g_faj.faj55
                    IF l_cnt = 0 THEN
                       CALL cl_err(g_faj.faj55,'afa-317',0)
                       DISPLAY BY NAME g_faj.faj55
                       NEXT FIELD faj55
                    END IF
                #------------------------MOD-D10167------------------------(E)
                 #No.FUN-B40004  --Begin
                   #IF g_faj.faj23 = '1' AND NOT cl_null(g_faj.faj24) THEN          #MOD-D10167 mark
                      #LET l_aag05=''                                               #MOD-D10167 mark
                      #SELECT aag05 INTO l_aag05 FROM aag_file                      #MOD-D10167 mark
                      # WHERE aag01 = g_faj.faj55                                   #MOD-D10167 mark
                      #   AND aag00 = g_aza.aza81                                   #MOD-D10167 mark
                   #IF l_aag05 = 'Y' THEN                          #MOD-BB0018 mark
                    IF l_aag05 = 'Y' AND g_faj.faj28 <> '0' THEN   #MOD-BB0018
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_faj.faj55,g_faj.faj24,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_faj.faj55,g_errno,0)
                       DISPLAY BY NAME g_faj.faj55
                       NEXT FIELD faj55
                    END IF
                 #END IF                                                             #MOD-D10167 mark
                #No.FUN-B40004  --End
             #------------------------MOD-D10167------------------------(S)
                 ELSE
                    IF g_faj.faj23 = '2' AND NOT cl_null(g_faj.faj24) THEN
                       LET l_yy = g_faj.faj27[1,4]
                       LET l_mm = g_faj.faj27[5,6]
                       LET l_cnt = 0
                       SELECT COUNT(*) INTO l_cnt FROM fae_file
                        WHERE fae10 = '1'                 #財簽
                          AND fae01 = l_yy
                          AND fae02 = l_mm
                          AND fae03 = g_faj.faj53
                          AND fae07 = g_faj.faj55
                          AND fae04 = g_faj.faj24
                       IF l_cnt = 0 THEN
                          CALL cl_err(g_faj.faj55,'afa-342',0)
                          DISPLAY BY NAME g_faj.faj55
                          NEXT FIELD faj55
                       END IF
                    END IF
                 END IF
              END IF
             #------------------------MOD-D10167------------------------(E)
           END IF
           DISPLAY BY NAME g_faj.faj55
           IF cl_null(g_faj.faj55) THEN
              DISPLAY ' ' TO FORMONLY.aag02_3
           ELSE
              DISPLAY aag02_3 TO FORMONLY.aag02_3
           END IF
            CALL i100_set_required(p_cmd)   #No.MOD-530114
       AFTER FIELD faj58                                                        
         IF NOT cl_null(g_faj.faj58) THEN                                       
            IF g_faj.faj58 < 0 THEN                                             
               CALL cl_err(g_faj.faj58,'anm-249',0)                             
               NEXT FIELD faj58                                                 
            END IF                                                              
         END IF                                                                 
                                                                                
       AFTER FIELD faj59                                                        
         IF NOT cl_null(g_faj.faj59) THEN                                       
            IF g_faj.faj59 < 0 THEN                                             
               CALL cl_err(g_faj.faj59,'anm-249',0)                             
               NEXT FIELD faj59                                                 
            END IF                                                              
         END IF                                                                 
                                                                                
       AFTER FIELD faj60
         IF NOT cl_null(g_faj.faj60) THEN                                       
            IF g_faj.faj60 < 0 THEN                                             
               CALL cl_err(g_faj.faj60,'anm-249',0)                             
               NEXT FIELD faj60                                                 
            END IF                                                              
         END IF                                                                 
 
       BEFORE FIELD faj531
           IF cl_null(g_faj.faj531) THEN
              SELECT fab111 INTO g_faj.faj531
                FROM fab_file
               WHERE fab01 = g_faj.faj04
           END IF
           IF g_faj.faj531<>' ' AND g_faj.faj531 IS NOT NULL THEN
           #  CALL i100_faj531(g_faj.faj531,g_aza.aza82) RETURNING aag02_1a   #No.FUN-740026 #No.TQC-740137
              CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a   #No:FUN-AB0088
              DISPLAY BY NAME g_faj.faj531
              DISPLAY aag02_1a TO FORMONLY.aag02_1a
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_1a
           END IF
           IF g_faj.faj541<>' ' AND g_faj.faj541 IS NOT NULL THEN
           #  CALL i100_faj531(g_faj.faj541,g_aza.aza82) RETURNING aag02_2a   #No.FUN-740026  #No.TQC-740137
           #  CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a   #No:FUN-AB0088 #No:FUN-BA0112 mark
              CALL i100_faj531(g_faj.faj541,g_faa.faa02c) RETURNING aag02_2a   #No:FUN-BA0112 add
              DISPLAY BY NAME g_faj.faj541
              DISPLAY aag02_2a TO FORMONLY.aag02_2a
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_2a
           END IF
           IF g_faj.faj551<>' ' AND g_faj.faj551 IS NOT NULL THEN
           #  CALL i100_faj531(g_faj.faj551,g_aza.aza82) RETURNING aag02_3a   #No.FUN-740026 #No.TQC-740137
           #  CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a  #No:FUN-AB0088 #No:FUN-BA0112 mark
              CALL i100_faj531(g_faj.faj551,g_faa.faa02c) RETURNING aag02_3a  #No:FUN-BA0112 add 
              DISPLAY BY NAME g_faj.faj551
              DISPLAY aag02_3a TO FORMONLY.aag02_3a
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_3a
           END IF
 
       AFTER FIELD faj531
           IF NOT cl_null(g_faj.faj531) THEN
            # CALL i100_faj531(g_faj.faj531,g_aza.aza82)  RETURNING aag02_1a   #No.FUN740026 #No.TQC-740137
              CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a   #No:FUN-AB0088
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_faj.faj531,g_errno,1)
                 CALL cl_err(g_faj.faj531,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_faj.faj531
                 LET g_qryparam.arg1 = g_aza.aza82 
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_faj.faj531 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_faj.faj531
                 DISPLAY BY NAME g_faj.faj531 
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_1a
                 NEXT FIELD faj531
              END IF
              #No.FUN-B40004  --Begin
              IF g_faj.faj232 = '1' AND NOT cl_null(g_faj.faj242) THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_faj.faj531
                    AND aag00 = g_aza.aza81
                #IF l_aag05 = 'Y' THEN                           #MOD-BB0018 mark
                 IF l_aag05 = 'Y' AND g_faj.faj282 <> '0' THEN   #MOD-BB0018
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 !='Y' THEN
                       LET g_errno = ' '
                       CALL s_chkdept(g_aaz.aaz72,g_faj.faj531,g_faj.faj242,g_aza.aza82)
                            RETURNING g_errno
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_faj.faj531,g_errno,0)
                    DISPLAY BY NAME g_faj.faj531
                    NEXT FIELD faj531
                 END IF
               END IF
               #No.FUN-B40004  --End
           END IF
           IF cl_null(g_faj.faj531) THEN
              DISPLAY ' ' TO FORMONLY.aag02_1a
              DISPLAY BY NAME g_faj.faj531
           END IF
 
       AFTER FIELD faj541
           IF NOT cl_null(g_faj.faj541) THEN
         #    CALL i100_faj531(g_faj.faj541,g_aza.aza82) RETURNING aag02_2a   #No.FUN-740026 #No.TQC-740137
         #    CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a  #No:FUN-AB0088 #No:FUN-BA0112 mark
              CALL i100_faj531(g_faj.faj541,g_faa.faa02c) RETURNING aag02_2a  #No:FUN-BA0112 add
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_faj.faj541,g_errno,1)
                 CALL cl_err(g_faj.faj541,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_faj.faj541
                 LET g_qryparam.arg1 = g_aza.aza82 
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_faj.faj541 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_faj.faj541
                 DISPLAY BY NAME g_faj.faj541 
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_2a
                 NEXT FIELD faj541
              END IF
              #No.FUN-B40004  --Begin
              IF g_faj.faj232 = '1' AND NOT cl_null(g_faj.faj242) THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_faj.faj541
                    AND aag00 = g_aza.aza81
                #IF l_aag05 = 'Y' THEN                           #MOD-BB0018 mark
                 IF l_aag05 = 'Y' AND g_faj.faj282 <> '0' THEN   #MOD-BB0018
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 !='Y' THEN
                       LET g_errno = ' '
                       CALL s_chkdept(g_aaz.aaz72,g_faj.faj541,g_faj.faj242,g_aza.aza82)
                            RETURNING g_errno
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_faj.faj541,g_errno,0)
                    DISPLAY BY NAME g_faj.faj541
                    NEXT FIELD faj541
                 END IF
               END IF
               #No.FUN-B40004  --End
           END IF
           DISPLAY BY NAME g_faj.faj541
           IF cl_null(g_faj.faj541) THEN
              DISPLAY ' ' TO FORMONLY.aag02_2a
           ELSE
              DISPLAY aag02_2a TO FORMONLY.aag02_2a
           END IF
 
       AFTER FIELD faj551
           IF NOT cl_null(g_faj.faj551) THEN
          #   CALL i100_faj531(g_faj.faj551,g_aza.aza82) RETURNING aag02_3a   #No.FUN-740026 #No.TQC-740137
          #   CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a  #No:FUN-AB0088 #No:FUN-BA0112 mark
              CALL i100_faj531(g_faj.faj551,g_faa.faa02c) RETURNING aag02_3a  #No:FUN-BA0112 add 
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_faj.faj551,g_errno,1)
                 CALL cl_err(g_faj.faj551,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_faj.faj551
                 LET g_qryparam.arg1 = g_aza.aza82 
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_faj.faj551 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_faj.faj551
                 DISPLAY BY NAME g_faj.faj551 
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_3a
                 NEXT FIELD faj551
              END IF
              #No.FUN-B40004  --Begin
              IF g_faj.faj232 = '1' AND NOT cl_null(g_faj.faj242) THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_faj.faj551
                    AND aag00 = g_aza.aza81
                #IF l_aag05 = 'Y' THEN                           #MOD-BB0018 mark
                 IF l_aag05 = 'Y' AND g_faj.faj282 <> '0' THEN   #MOD-BB0018
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 !='Y' THEN
                       LET g_errno = ' '
                       CALL s_chkdept(g_aaz.aaz72,g_faj.faj551,g_faj.faj242,g_aza.aza82)
                            RETURNING g_errno
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_faj.faj551,g_errno,0)
                    DISPLAY BY NAME g_faj.faj551
                    NEXT FIELD faj551
                 END IF
               END IF
               #No.FUN-B40004  --End
             #------------------------MOD-D10167------------------------(S)
              IF g_faa.faa22 = '1' AND NOT cl_null(g_faj.faj24) THEN
                 LET g_errno = ' '
                 CALL s_chkdept(g_aaz.aaz72,g_faj.faj551,g_faj.faj24,g_aza.aza81)
                      RETURNING g_errno
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_faj.faj551,g_errno,0)
                    DISPLAY BY NAME g_faj.faj551
                    NEXT FIELD faj551
                 END IF
              ELSE
                 IF g_faj.faj23 = '1' AND NOT cl_null(g_faj.faj24) THEN
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt FROM fbi_file
                     WHERE fbi01 = g_faj.faj24
                       AND fbi03 = g_faj.faj04                   
                       AND fbi02 = g_faj.faj551
                    IF l_cnt = 0 THEN
                       CALL cl_err(g_faj.faj551,'afa-317',0)
                       DISPLAY BY NAME g_faj.faj551
                       NEXT FIELD faj551
                    END IF  
                 ELSE
                    IF g_faj.faj23 = '2' AND NOT cl_null(g_faj.faj24) THEN
                       LET l_yy = g_faj.faj27[1,4]
                       LET l_mm = g_faj.faj27[5,6]
                       LET l_cnt = 0
                       SELECT COUNT(*) INTO l_cnt FROM fae_file
                        WHERE fae10 = '2'                 #財簽二
                          AND fae01 = l_yy
                          AND fae02 = l_mm
                          AND fae03 = g_faj.faj551
                          AND fae04 = g_faj.faj24
                       IF l_cnt = 0 THEN
                          CALL cl_err(g_faj.faj551,'afa-342',0)
                          DISPLAY BY NAME g_faj.faj551
                          NEXT FIELD faj551
                       END IF
                    END IF
                 END IF
              END IF
             #------------------------MOD-D10167------------------------(E)
           END IF
           DISPLAY BY NAME g_faj.faj551
           IF cl_null(g_faj.faj551) THEN
              DISPLAY ' ' TO FORMONLY.aag02_3a
           ELSE
              DISPLAY aag02_3a TO FORMONLY.aag02_3a
           END IF
            CALL i100_set_required(p_cmd)   #No.MOD-530114
 
       AFTER FIELD faj38
         IF NOT cl_null(g_faj.faj55) THEN
           IF g_faj.faj38 NOT MATCHES "[0-1]" THEN
              CALL cl_err(g_faj.faj38,'afa-087',0)
              NEXT FIELD faj38
           END IF
         END IF
 
       AFTER FIELD faj39
         IF NOT cl_null(g_faj.faj55) THEN
           IF g_faj.faj39 NOT MATCHES "[0-2]" THEN
              CALL cl_err(g_faj.faj39,'afa-088',0)
              NEXT FIELD faj39
           END IF
         END IF
 
       AFTER FIELD faj40
         IF NOT cl_null(g_faj.faj55) THEN
           IF g_faj.faj40 NOT MATCHES "[0-5]" THEN
              CALL cl_err(g_faj.faj40,'afa-090',0)
              NEXT FIELD faj40
           END IF
         END IF
 
       AFTER FIELD faj41
         IF NOT cl_null(g_faj.faj55) THEN
           IF g_faj.faj41 NOT MATCHES "[0-4]" THEN
              CALL cl_err(g_faj.faj41,'afa-089',0)
              NEXT FIELD faj41
           END IF
         END IF
 
       AFTER FIELD faj42
         IF NOT cl_null(g_faj.faj55) THEN
           IF g_faj.faj42 NOT MATCHES "[0-6]" THEN       
              CALL cl_err(g_faj.faj42,'afa-090',0)
              NEXT FIELD faj42
           END IF
         END IF
 
       BEFORE FIELD faj61
            CALL i100_set_entry(p_cmd)
 
       AFTER FIELD faj61
         IF NOT cl_null(g_faj.faj61) THEN
            IF g_faj.faj61 NOT MATCHES '[0-5]' THEN NEXT FIELD faj61 END IF
            CALL i100_set_no_entry(p_cmd)
            IF g_faj.faj61 != g_faj_t.faj61 OR g_faj_t.faj61 IS NULL THEN
               CALL i100_6668()   #稅簽
            END IF
         END IF
 
       BEFORE FIELD faj68
           IF g_faj.faj68 IS NULL OR g_faj.faj68 = 0 THEN
              LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
              DISPLAY g_faj.faj68 TO faj68
           END IF
       AFTER FIELD faj68
         IF NOT cl_null(g_faj.faj68) THEN                                       
              IF g_faj.faj68 <0 THEN                                            
                 CALL cl_err(g_faj.faj68,'anm-249',0)                           
                 NEXT FIELD faj68                                               
              END IF                                                            
           LET g_faj.faj68 = cl_numfor(g_faj.faj68,18,g_azi04)
           DISPLAY BY NAME g_faj.faj68
         END IF  #TQC-710112
      
       AFTER FIELD faj681                                                                                                           
         IF NOT cl_null(g_faj.faj681) THEN                                                                                          
              IF g_faj.faj681 <0 THEN                                                                                               
                 CALL cl_err(g_faj.faj681,'anm-249',0)                                                                              
                 NEXT FIELD faj681                                                                                                  
              END IF                                                                                                                
           LET g_faj.faj681 = cl_numfor(g_faj.faj681,18,g_azi04)                                                                    
           DISPLAY BY NAME g_faj.faj681                                                                                             
         END IF                                                                                                                     
 
      AFTER FIELD faj69                                                        
         IF NOT cl_null(g_faj.faj69) THEN                                       
            IF g_faj.faj69 < 0 THEN                                             
               CALL cl_err(g_faj.faj69,'anm-249',0)                             
               NEXT FIELD faj69                                                 
            END IF                                                              
         END IF                                                                 
                                                                                
       AFTER FIELD faj70                                                        
         IF NOT cl_null(g_faj.faj70) THEN                                       
            IF g_faj.faj70 < 0 THEN                                             
               CALL cl_err(g_faj.faj70,'anm-249',0)                             
               NEXT FIELD faj70                                                 
            END IF                                                              
         END IF                                                                 
 
       AFTER FIELD faj62
         IF NOT cl_null(g_faj.faj62) THEN                                       
            IF g_faj.faj62 <0 THEN                                            
               CALL cl_err(g_faj.faj62,'anm-249',0)                           
               NEXT FIELD faj62                                               
            END IF                                                            
            IF (g_faj_t.faj62 != g_faj.faj62) OR
               (g_faj.faj62 IS NOT NULL AND g_faj_t.faj62 IS NULL) THEN
               CALL i100_6668()   #稅簽
            END IF
            LET g_faj.faj62 = cl_numfor(g_faj.faj62,18,g_azi04)
            DISPLAY BY NAME g_faj.faj62
         END IF  #TQC-710112 
 
       AFTER FIELD faj64                                                        
         IF NOT cl_null(g_faj.faj64) THEN                                       
            IF g_faj.faj64 < 0 THEN                                             
               CALL cl_err(g_faj.faj64,'anm-249',0)                             
               NEXT FIELD faj64                                                 
            END IF                                                              
            IF (p_cmd='a' AND g_faj.faj64<>0) OR
               (p_cmd = 'u' AND g_faj_o.faj64 != g_faj.faj64) THEN
               CALL i100_6668()   #稅簽
            END IF
         END IF                                                                 
                                                                                
       AFTER FIELD faj65                                                        
         IF NOT cl_null(g_faj.faj65) THEN                                       
            IF g_faj.faj65 < 0 THEN                                             
               CALL cl_err(g_faj.faj65,'anm-249',0)                             
               NEXT FIELD faj65                                                 
            END IF                                                              
         END IF                                                                 
       AFTER FIELD faj66
          IF NOT cl_null(g_faj.faj66) THEN                                      
              IF g_faj.faj66 <0 THEN                                            
                 CALL cl_err(g_faj.faj66,'anm-249',0)                           
                 NEXT FIELD faj66                                               
              END IF                                                            
           LET g_faj.faj66 = cl_numfor(g_faj.faj66,18,g_azi04)
           DISPLAY BY NAME g_faj.faj66
          END IF  #TQC-710112 
 
       AFTER FIELD faj67
         IF NOT cl_null(g_faj.faj67) THEN                                       
              IF g_faj.faj67 <0 THEN                                            
                 CALL cl_err(g_faj.faj67,'anm-249',0)                           
                 NEXT FIELD faj67                                               
              END IF                                                            
           LET g_faj.faj67 = cl_numfor(g_faj.faj67,18,g_azi04)
           DISPLAY BY NAME g_faj.faj67
         END IF  #TQC-710112
 
       AFTER FIELD faj63
          IF NOT cl_null(g_faj.faj63) THEN                                      
              IF g_faj.faj63 <0 THEN                                            
                 CALL cl_err(g_faj.faj63,'anm-249',0)                           
                 NEXT FIELD faj63                                               
              END IF                                                            
           LET g_faj.faj63 = cl_numfor(g_faj.faj63,18,g_azi04)
           DISPLAY BY NAME g_faj.faj63
          END IF  #TQC-710112
 
       AFTER FIELD faj203
          IF NOT cl_null(g_faj.faj203) THEN                                     
              IF g_faj.faj203 <0 THEN                                           
                 CALL cl_err(g_faj.faj203,'anm-249',0)                          
                 NEXT FIELD faj203                                              
              END IF                                                            
           LET g_faj.faj203 = cl_numfor(g_faj.faj203,18,g_azi04)
           DISPLAY BY NAME g_faj.faj203
          END IF  #TQC-710112
        AFTER FIELD faj204                                                      
         IF NOT cl_null(g_faj.faj204) THEN                                      
            IF g_faj.faj204 < 0 THEN                                            
               CALL cl_err(g_faj.faj204,'anm-249',0)                            
               NEXT FIELD faj204                                                
            END IF                                                              
         END IF                                                                 
                                                                                
        AFTER FIELD faj205                                                      
         IF NOT cl_null(g_faj.faj205) THEN                                      
            IF g_faj.faj205 < 0 THEN                                            
               CALL cl_err(g_faj.faj205,'anm-249',0)                            
               NEXT FIELD faj205                                                
            END IF                                                              
         END IF                                                                 
                                                                                
        AFTER FIELD faj206                                                      
         IF NOT cl_null(g_faj.faj206) THEN
            IF g_faj.faj206 < 0 THEN                                            
               CALL cl_err(g_faj.faj206,'anm-249',0)                            
               NEXT FIELD faj206                                                
            END IF                                                              
         END IF                                                                 
 
        AFTER FIELD faj106
           CALL i100_faj106_check()   #No.FUN-BB0086
            #IF cl_null(g_faj.faj106) THEN LET g_faj.faj106 = 0 END IF   #No.FUN-BB0086 mark
 
        AFTER FIELD faj110
           IF NOT i100_faj110_check() THEN NEXT FIELD faj110 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           # IF NOT cl_null(g_faj.faj110) THEN                                   
           #   IF g_faj.faj110 <0 THEN                                           
           #      CALL cl_err(g_faj.faj110,'anm-249',0)                          
           #      NEXT FIELD faj110                                              
           #   END IF                                                            
           # END IF                                                               
           # IF cl_null(g_faj.faj110) THEN LET g_faj.faj110 = 0 END IF
           #No.FUN-BB0086--mark--end--
           
         AFTER FIELD faj111    
            #IF NOT i100_faj111_check() THEN NEXT FIELD faj111 END IF   #No.FUN-BB0086 #TQC-C20183 mark
            CALL i100_faj111_check()                                                   #TQC-C20183 add
         #TQC-C20183--unmark--str--
            #No.FUN-BB0086--mark--begin--         
            IF NOT cl_null(g_faj.faj111) THEN                                      
               IF g_faj.faj111 < 0 THEN                                            
                  CALL cl_err(g_faj.faj111,'anm-249',0)                            
                  NEXT FIELD faj111                                                
               END IF                                                              
            END IF   
            #No.FUN-BB0086--mark--end--   
         #TQC-C20183--unmark--end--

#CHI-C60010--add--str--
       AFTER FIELD faj1012
          IF NOT cl_null(g_faj.faj1012) THEN
             IF g_faj.faj1012 < 0 THEN
                CALL cl_err(g_faj.faj1012,'afa-037',0)
                NEXT FIELD faj1012
             END IF
             LET g_faj.faj1012 = cl_digcut(g_faj.faj1012,g_azi04_1)
             DISPLAY BY NAME g_faj.faj1012
          END IF

       AFTER FIELD faj1022
          IF NOT cl_null(g_faj.faj1022) THEN
             IF g_faj.faj1022 < 0 THEN
                CALL cl_err(g_faj.faj1022,'afa-037',0)
                NEXT FIELD faj1022
             END IF
             LET g_faj.faj1022 = cl_digcut(g_faj.faj1022,g_azi04_1)
             DISPLAY BY NAME g_faj.faj1022
          END IF
#CHI-C60010--add--end         
      #-----No:FUN-AB0088-----
       AFTER FIELD faj1082
          IF NOT cl_null(g_faj.faj1082) THEN
             IF g_faj.faj1082 < 0 THEN
                CALL cl_err(g_faj.faj1082,'afa-037',0)
                NEXT FIELD faj1082
             END IF
             IF g_faj.faj1082 > g_faj.faj322 THEN
                CALL cl_err(g_faj.faj1082,'afa-925',0)
                NEXT FIELD faj1082
             END IF
            #LET g_faj.faj1082 = cl_digcut(g_faj.faj1082,g_azi04)     #MOD-C50130 mark
             LET g_faj.faj1082 = cl_digcut(g_faj.faj1082,g_azi04_1)   #MOD-C50130 add
             DISPLAY BY NAME g_faj.faj1082
          END IF

       AFTER FIELD faj142
          IF NOT cl_null(g_faj.faj142) THEN
             IF g_faj.faj142 < 0 THEN
                CALL cl_err(g_faj.faj142,'anm-249',0)
                NEXT FIELD faj142
             END IF
          IF (g_faj_t.faj142 != g_faj.faj142) OR
                (g_faj.faj142 IS NOT NULL AND g_faj_t.faj142 IS NULL) THEN
                CALL i100_31332()   
                IF cl_null(g_faj.faj322) THEN LET g_faj.faj322 = 0 END IF
                IF cl_null(g_faj.faj312) THEN LET g_faj.faj312 = 0 END IF
             END IF
            #LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04)      #MOD-C50130 mark
             LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04_1)    #MOD-C50130 add
             DISPLAY BY NAME g_faj.faj142
             LET g_faj_o.faj142 = g_faj.faj142
          END IF

       AFTER FIELD faj1412
          IF NOT cl_null(g_faj.faj1412) THEN
             IF g_faj.faj1412 < 0 THEN
                CALL cl_err(g_faj.faj1412,'anm-249',0)
                NEXT FIELD faj1412
             END IF
             LET g_faj.faj1412= cl_digcut(g_faj.faj1412,g_azi04_1)  #CHI-C60010 add
             DISPLAY BY NAME g_faj.faj1412   #CHI-C60010 add
          END IF

       AFTER FIELD faj232
          IF NOT cl_null(g_faj.faj232) THEN
             IF g_faj.faj232 NOT MATCHES '[1-2]' THEN
                LET g_faj.faj232 = g_faj_t.faj232
                DISPLAY BY NAME g_faj.faj232
                NEXT FIELD faj232
             END IF
             LET g_faj_o.faj232 = g_faj.faj232
          END IF

      BEFORE FIELD faj242
          IF cl_null(g_faj.faj242) THEN
             IF g_faj.faj232 = '1' THEN
                CALL cl_err(' ','afa-047',0)
             ELSE
                CALL cl_err(' ','afa-048',0)
             END IF
          END IF
          IF g_faj.faj232 = '1' AND p_cmd = 'a' AND cl_null(g_faj.faj242) THEN
             LET g_faj.faj242 = g_faj.faj20
             DISPLAY BY NAME g_faj.faj242
          END IF

       AFTER FIELD faj242
          LET l_faj242 = NULL
          IF g_faj.faj232 = '1' THEN
             IF cl_null(g_faj.faj242) THEN
                NEXT FIELD faj242
             ELSE
                CALL i100_faj2412('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_faj.faj242,g_errno,0)
                    LET g_faj.faj242 = g_faj_t.faj242
                    DISPLAY BY NAME g_faj.faj242
                    NEXT FIELD faj242
                 END IF
             END IF
             IF g_faa.faa20 = '2' THEN
                LET l_fbi02 = ''
                DECLARE i100_fbi2
                    CURSOR FOR SELECT fbi02,fbi021 FROM fbi_file
                                     WHERE fbi01= g_faj.faj242
                                       AND fbi03= g_faj.faj04
                FOREACH i100_fbi2 INTO l_fbi02,l_fbi021
                   IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                   IF not cl_null(l_fbi02) THEN EXIT FOREACH END IF
                   IF not cl_null(l_fbi021) THEN EXIT FOREACH END IF
                END FOREACH
                IF l_faj242 IS NULL OR g_faj.faj242 <> l_faj242 THEN
                   LET l_faj242 = g_faj.faj242
                   IF cl_null(l_fbi02) AND g_faj.faj282 NOT MATCHES '[0]' THEN
                      CALL cl_err(g_faj.faj242,'afa-317',1)
                   END IF
                   LET g_faj.faj55 = l_fbi02
                   DISPLAY BY NAME g_faj.faj55
                   IF g_faa.faa31 = 'Y' THEN
                      IF cl_null(l_fbi021) AND g_faj.faj282 NOT MATCHES '[0]' THEN #7566
                         CALL cl_err(g_faj.faj242,'afa-317',1)
                      END IF
                      LET g_faj.faj551 = l_fbi021
                      DISPLAY BY NAME g_faj.faj551
                   END IF
               END IF
             ELSE
                IF cl_null(g_faj.faj55) THEN
                   LET g_faj.faj55 = g_fab13
                END IF
                IF cl_null(g_fab13) THEN
                   CALL cl_err(g_faj.faj242,'afa-318',1)
                END IF
             END IF
          ELSE
             IF cl_null(g_faj.faj242) THEN
             ELSE
                CALL i100_faj2422('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_faj.faj242,g_errno,1)
                   LET g_faj.faj242 = g_faj_t.faj242
                   DISPLAY BY NAME g_faj.faj242
                   NEXT FIELD faj242
                END IF
             END IF
          END IF
          LET g_faj_o.faj242 = g_faj.faj242

       AFTER FIELD faj262
          IF NOT cl_null(g_faj.faj262) THEN
             IF g_faj.faj262 <= g_faa.faa092 THEN   #No:FUN-B60140 将faa09改为faa092
                CALL cl_err('','afa-517',1)
             END IF
             LET l_day = DAY(g_faj.faj262)
             CALL s_yp(g_faj.faj262) RETURNING l_year,l_month
             LET l_date2 = l_year USING '&&&&',l_month USING '&&',l_day USING '&&'
             LET l_date  = l_date2
             CALL s_faj27(l_date,g_faa.faa152) RETURNING l_faj272    #No:FUN-B60140 将faa15改为faa152
             IF cl_null(g_faj.faj272)  THEN           #FUN-C50124
                IF g_faj.faj09='1'  THEN              #FUN-C50124
                   LET g_faj.faj272 = l_faj272
                ELSE                                  #FUN-C50124
                   LET g_faj.faj272 = l_year USING '&&&&',l_month USING '&&'    #FUN-C50124
                END IF                                #FUN-C50124
             END IF 
             LET g_faj.faj100 = g_faj.faj262
             DISPLAY BY NAME g_faj.faj272
             LET g_faj_o.faj262 = g_faj.faj262
          END IF

       AFTER FIELD faj272
          IF NOT cl_null(g_faj.faj272) THEN
             LET l_str = g_faj.faj272
             LET l_len = l_str.getlength()
             IF l_len != 6 THEN
                CALL cl_err(g_faj.faj272,'sub-005',1)
                NEXT FIELD faj272
             END IF
             FOR i = 1 TO l_len
                 IF l_str.substring(i,i) NOT MATCHES '[0123456789]' THEN
                    CALL cl_err(g_faj.faj272,'sub-005',1)
                    NEXT FIELD faj272
                 END IF
             END FOR
             IF NOT cl_chkym(g_faj.faj272) THEN
                CALL cl_err(g_faj.faj272,'sub-005',1)
                NEXT FIELD faj272
             END IF
          END IF

       BEFORE FIELD faj282
          CALL i100_set_entry(p_cmd)

       AFTER FIELD faj282   
          IF NOT cl_null(g_faj.faj282) THEN
             IF g_faj.faj282 NOT MATCHES '[0-5]' THEN
                LET g_faj.faj282 = g_faj_t.faj282
                DISPLAY BY NAME g_faj.faj282
                NEXT FIELD faj282
             END IF
             IF g_faj.faj282 ='0' THEN   #NO:5153
                 LET g_faj.faj292=0
                 LET g_faj.faj302=0
                 LET g_faj.faj312=0
                 LET g_faj.faj322=0
                 LET g_faj.faj332=g_faj.faj142
                 LET g_faj.faj342='N'
                 LET g_faj.faj352=0
                 LET g_faj.faj362=0
                 LET g_faj.faj71='N'
                 LET g_faj.faj72=0
                 LET g_faj.faj73=0
                 DISPLAY BY NAME g_faj.faj292,g_faj.faj302,
                                 g_faj.faj312,g_faj.faj322,
                                 g_faj.faj332,g_faj.faj342,
                                 g_faj.faj352,g_faj.faj362,
                                 g_faj.faj71,g_faj.faj72,
                                 g_faj.faj73
                 DISPLAY BY NAME g_faj.faj53,g_faj.faj531,
                                 g_faj.faj54,g_faj.faj541

             END IF
             IF g_faj.faj282 != g_faj_t.faj282 OR g_faj_t.faj282 IS NULL THEN
                CALL i100_3133()  
                CALL i100_31332()     #No:FUN-AB0088
                CALL i100_6668()   
             END IF
             LET g_faj_o.faj282 = g_faj.faj282
             CALL i100_set_no_entry(p_cmd)
          END IF

       BEFORE FIELD faj292
          IF g_faj.faj021 MATCHES '[23]' THEN
             IF (p_cmd = 'a' AND (g_faj_o.faj292 IS NULL OR g_faj_o.faj292 <> g_faj.faj292)) OR
                (p_cmd = 'u' AND g_faj_o.faj292 <> g_faj.faj292) THEN
                CALL s_afaym(g_faj.faj02,g_faj.faj272,'3') RETURNING g_faj.faj292  
                LET g_faj.faj302 = g_faj.faj292
                CALL s_afaym(g_faj.faj02,g_faj.faj272,'2') RETURNING g_faj.faj64
                LET g_faj.faj65 = g_faj.faj64
                DISPLAY BY NAME g_faj.faj292,g_faj.faj302
             END IF
          END IF

       AFTER FIELD faj292
          IF NOT cl_null(g_faj.faj292) THEN
             IF g_faj.faj292 <0 THEN
                CALL cl_err(g_faj.faj292,'anm-249',0)
                NEXT FIELD faj292
             END IF
             IF g_faj.faj021 = '1' THEN
                IF (p_cmd = 'a' AND (g_faj_o.faj292 IS NULL OR g_faj_o.faj292 <> g_faj.faj292)) OR
                   (p_cmd = 'u' AND g_faj_o.faj292 <> g_faj.faj292) THEN
                   LET g_faj.faj302 = g_faj.faj292
                  LET g_faj.faj64 = g_faj.faj292
                   LET g_faj.faj65 = g_faj.faj64
                   DISPLAY BY NAME g_faj.faj302
                END IF   #MOD-750008
             END IF
             IF (p_cmd='a' AND g_faj.faj292<>0) OR
                (p_cmd = 'u' AND g_faj_o.faj292 != g_faj.faj292) THEN
               CALL i100_31332()     #No:FUN-AB0088
            END IF
            LET g_faj_o.faj292 = g_faj.faj292
          END IF

       AFTER FIELD faj302
          IF NOT cl_null(g_faj.faj302) THEN
             IF g_faj.faj302 <0 THEN
                CALL cl_err(g_faj.faj302,'anm-249',0)
                NEXT FIELD faj302
             END IF
             IF p_cmd = 'a' THEN LET g_faj.faj65 = g_faj.faj302 END IF
             LET g_faj_o.faj302 = g_faj.faj302
             IF g_faj.faj302 > g_faj.faj292 THEN
                CALL cl_err(g_faj.faj302,'afa-165',0)
                NEXT FIELD faj302
             END IF
          END IF

       BEFORE FIELD faj312
          IF cl_null(g_faj.faj312) THEN
             LET g_faj.faj312 = 0
             DISPLAY BY NAME g_faj.faj312
          END IF

       AFTER FIELD faj312
          IF NOT cl_null(g_faj.faj312) THEN
             IF p_cmd = 'a' THEN LET g_faj.faj66 = g_faj.faj312 END IF
             IF g_faj.faj312 <0 THEN
               CALL cl_err(g_faj.faj312,'anm-249',0)
                NEXT FIELD faj312
             END IF
            #LET g_faj.faj312 = cl_numfor(g_faj.faj312,18,g_azi04)      #MOD-C50130 mark
             LET g_faj.faj312 = cl_numfor(g_faj.faj312,18,g_azi04_1)    #MOD-C50130 add
            DISPLAY BY NAME g_faj.faj312
             LET g_faj_o.faj312 = g_faj.faj312
          END IF

       BEFORE FIELD faj322
          IF cl_null(g_faj.faj322) THEN
             LET g_faj.faj322 = 0
             DISPLAY BY NAME g_faj.faj322
          END IF

      AFTER FIELD faj322
          IF (g_faj_o.faj322 != g_faj.faj322 ) OR
             (g_faj.faj322 IS NOT NULL AND g_faj_o.faj322 IS NULL) THEN
             IF g_faj.faj322 <0 THEN
                CALL cl_err(g_faj.faj322,'anm-249',0)
                NEXT FIELD faj322
             END IF
             LET g_faj.faj332 = g_faj.faj142 - g_faj.faj322
             LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
             DISPLAY BY NAME g_faj.faj332
          END IF
         #LET g_faj.faj322 = cl_numfor(g_faj.faj322,18,g_azi04)          #MOD-C50130 mark
          LET g_faj.faj322 = cl_numfor(g_faj.faj322,18,g_azi04_1)        #MOD-C50130 add
          DISPLAY BY NAME g_faj.faj322
          LET g_faj_o.faj322 = g_faj.faj322

       BEFORE FIELD faj332
          IF p_cmd = 'a' OR p_cmd = 'u' THEN
             LET g_faj.faj332 = g_faj.faj142 - g_faj.faj322
            LET g_faj.faj68 = g_faj.faj332
          END IF

       AFTER FIELD faj332
          IF p_cmd = 'a' THEN
             LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
          END IF
          IF NOT cl_null(g_faj.faj332) THEN
             IF g_faj.faj332 <0 THEN
                CALL cl_err(g_faj.faj332,'anm-249',0)
                NEXT FIELD faj332
             END IF
          END IF
         #LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04)    #MOD-C50130 mark
          LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04_1)  #MOD-C50130 add
          DISPLAY BY NAME g_faj.faj332
          LET g_faj_o.faj332 = g_faj.faj332

       AFTER FIELD faj3312
          IF NOT cl_null(g_faj.faj3312) THEN
             IF g_faj.faj3312 <0 THEN
                CALL cl_err(g_faj.faj3312,'anm-249',0)
                NEXT FIELD faj3312
             END IF
          END IF
         #LET g_faj.faj3312 = cl_numfor(g_faj.faj3312,18,g_azi04)     #MOD-C50130 mark
          LET g_faj.faj3312 = cl_numfor(g_faj.faj3312,18,g_azi04_1)   #MOD-C50130 add
         #DISPLAY BY NAME g_faj.faj332                                #MOD-C50130 mark
          DISPLAY BY NAME g_faj.faj3312                               #MOD-C50130 add    
          LET g_faj_o.faj3312 = g_faj.faj3312

       BEFORE FIELD faj342
           CALL i100_set_entry(p_cmd)

       AFTER FIELD faj342
          IF NOT cl_null(g_faj.faj342) THEN
             IF g_faj.faj342 = 'Y' THEN
             ELSE
                LET g_faj.faj352 = 0
                LET g_faj.faj362 = 0
                DISPLAY BY NAME g_faj.faj352,g_faj.faj362
             END IF
             LET g_faj_o.faj342 = g_faj.faj342
          END IF
          CALL i100_set_no_entry(p_cmd)

       AFTER FIELD faj352
          IF NOT cl_null(g_faj.faj352) THEN
             IF g_faj.faj352 <0 THEN
                CALL cl_err(g_faj.faj352,'anm-249',0)
                NEXT FIELD faj352
             END IF
            #LET g_faj.faj352 = cl_digcut(g_faj.faj352,g_azi04)        #MOD-C50130 mark
             LET g_faj.faj352 = cl_digcut(g_faj.faj352,g_azi04_1)      #MOD-C50130 add
             DISPLAY BY NAME g_faj.faj352
          END IF

       AFTER FIELD faj362
         IF NOT cl_null(g_faj.faj362) THEN
            IF g_faj.faj362 <0 THEN
               CALL cl_err(g_faj.faj362,'anm-249',0)
               NEXT FIELD faj362
            END IF
         END IF

      AFTER FIELD faj582
         IF NOT cl_null(g_faj.faj582) THEN
            IF g_faj.faj582 < 0 THEN
               CALL cl_err(g_faj.faj582,'anm-249',0)
                NEXT FIELD faj582
            END IF
         END IF

      AFTER FIELD faj592
         IF NOT cl_null(g_faj.faj592) THEN
            IF g_faj.faj592 < 0 THEN
               CALL cl_err(g_faj.faj592,'anm-249',0)
               NEXT FIELD faj592
            END IF
            LET g_faj.faj592=cl_digcut(g_faj.faj592,g_azi04_1) #CHI-C60010 add
            DISPLAY BY NAME g_faj.faj592  #CHI-C60010 add
         END IF

      AFTER FIELD faj602
         IF NOT cl_null(g_faj.faj602) THEN
            IF g_faj.faj602 < 0 THEN
               CALL cl_err(g_faj.faj602,'anm-249',0)
               NEXT FIELD faj602
            END IF
            LET g_faj.faj602=cl_digcut(g_faj.faj602,g_azi04_1) #CHI-C60010 add
            DISPLAY BY NAME g_faj.faj602  #CHI-C60010 add
         END IF

      AFTER FIELD faj2032
         IF NOT cl_null(g_faj.faj2032) THEN
            IF g_faj.faj2032 <0 THEN
               CALL cl_err(g_faj.faj2032,'anm-249',0)
               NEXT FIELD faj2032
            END IF
           #LET g_faj.faj2032 = cl_numfor(g_faj.faj2032,18,g_azi04)           #MOD-C50130 mark
            LET g_faj.faj2032 = cl_numfor(g_faj.faj2032,18,g_azi04_1)         #MOD-C50130 add
            DISPLAY BY NAME g_faj.faj2032
         END IF

      AFTER FIELD faj2042
         IF NOT cl_null(g_faj.faj2042) THEN
            IF g_faj.faj2042 < 0 THEN
               CALL cl_err(g_faj.faj2042,'anm-249',0)
               NEXT FIELD faj2042
            END IF
            LET g_faj.faj2042=cl_digcut(g_faj.faj2042,g_azi04_1) #CHI-C60010 add
            DISPLAY BY NAME g_faj.faj2042  #CHI-C60010 add
         END IF

      AFTER FIELD faj1062
         CALL i100_faj1062_check()   #No.FUN-BB0086
         #IF cl_null(g_faj.faj1062) THEN LET g_faj.faj1062 = 0 END IF   #No.FUN-BB0086
   #-----No:FUN-AB0088-----

                                                           
 
        AFTER FIELD fajud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fajud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INPUT
         LET g_faj.fajuser = s_get_data_owner("faj_file") #FUN-C10039
         LET g_faj.fajgrup = s_get_data_group("faj_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

         IF p_cmd='u' AND g_faj.faj021='1' THEN
            LET g_faj.faj022= ' '
         END IF
        #IF cl_null(g_faj.faj55) THEN                         #MOD-C10164 mark
         IF cl_null(g_faj.faj55) AND g_faj.faj28 <> '0' THEN  #MOD-C10164 add
            CALL cl_err('','afa-346',0)
         END IF
         IF g_faa.faa20 != '2' THEN #MOD-AC0289 add
            IF cl_null(g_faj.faj55) AND g_faj.faj28<>'0' THEN
               CALL cl_err(g_faj.faj55,'afa-091',0)
               NEXT FIELD faj55
            END IF
         END IF #MOD-AC0289 add
         IF g_faj.faj23=' ' OR g_faj.faj23 IS NULL THEN
            CALL cl_err(g_faj.faj23,'afa-124',0)
            NEXT FIELD faj23
         END IF
         IF g_faj.faj24=' ' OR g_faj.faj24 IS NULL THEN
            CALL cl_err(g_faj.faj24,'afa-083',0)
            NEXT FIELD faj24
         END IF
         #-----No:FUN-AB0088-----
         IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088   #MOD-B40011 mod 'N' -> 'Y'
            IF g_faa.faa20 != '2' THEN #MOD-AC0289 add
               IF cl_null(g_faj.faj551) AND g_faj.faj282<>'0' THEN
                  CALL cl_err(g_faj.faj551,'afa-091',0)
                  NEXT FIELD faj551
               END IF
            END IF #MOD-AC0289 add
            IF g_faj.faj232=' ' OR g_faj.faj232 IS NULL THEN
               CALL cl_err(g_faj.faj232,'afa-124',0)
               NEXT FIELD faj232
            END IF
            IF g_faj.faj242=' ' OR g_faj.faj242 IS NULL THEN
               CALL cl_err(g_faj.faj242,'afa-083',0)
               NEXT FIELD faj242
            END IF
         END IF
         #-----No:FUN-AB0088 END-----
         IF g_faj.faj37=' ' OR g_faj.faj37 IS NULL THEN
            CALL cl_err(g_faj.faj37,'afa-086',0)
            NEXT FIELD faj37
         END IF
         IF g_faj.faj38=' ' OR g_faj.faj38 IS NULL THEN
            CALL cl_err(g_faj.faj38,'afa-087',0)
            NEXT FIELD faj38
         END IF
         IF g_faj.faj39=' ' OR g_faj.faj39 IS NULL THEN
            CALL cl_err(g_faj.faj39,'afa-088',0)
            NEXT FIELD faj39
         END IF
         IF g_faj.faj40=' ' OR g_faj.faj40 IS NULL THEN
            CALL cl_err(g_faj.faj40,'afa-090',0)
            NEXT FIELD faj40
         END IF
         IF g_faj.faj41=' ' OR g_faj.faj41 IS NULL THEN
            CALL cl_err(g_faj.faj41,'afa-089',0)
            NEXT FIELD faj41
         END IF
         IF g_faj.faj42=' ' OR g_faj.faj42 IS NULL THEN
            CALL cl_err(g_faj.faj42,'afa-090',0)
            NEXT FIELD faj42
         END IF
         IF g_faj.faj23 = '1' THEN
            CALL i100_faj241('')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_faj.faj24,g_errno,1)
               LET g_faj.faj24 = g_faj_t.faj24
               DISPLAY BY NAME g_faj.faj24
               NEXT FIELD faj24
            END IF
         ELSE
            CALL i100_faj242('')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_faj.faj24,g_errno,1)
               LET g_faj.faj24 = g_faj_t.faj24
               DISPLAY BY NAME g_faj.faj24
               NEXT FIELD faj24
            END IF
         END IF
         #-----No:FUN-AB0088-----
         IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088    #MOD-B40011 mod 'N' -> 'Y'
            IF g_faj.faj232 = '1' THEN
               CALL i100_faj2412('')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_faj.faj242,g_errno,1)
                  LET g_faj.faj242 = g_faj_t.faj242
                  DISPLAY BY NAME g_faj.faj242
                  NEXT FIELD faj242
               END IF
            ELSE
               CALL i100_faj2422('')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_faj.faj242,g_errno,1)
                  LET g_faj.faj242 = g_faj_t.faj242
                  DISPLAY BY NAME g_faj.faj242
                  NEXT FIELD faj242
               END IF
            END IF
         END IF
         #-----No:FUN-AB0088 END-----
         IF g_faj.faj15 = g_aza.aza17 AND 
            g_faj.faj14 <> g_faj.faj16 THEN
            CALL cl_err('','afa-420',0)
            NEXT FIELD faj16
         END IF
 
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01= g_faj.faj15
         LET g_faj.faj13 = cl_numfor(g_faj.faj13,18,g_azi04)
         LET g_faj.faj14 = cl_numfor(g_faj.faj14,18,g_azi04)
         LET g_faj.faj141 = cl_numfor(g_faj.faj141,18,g_azi04)
         LET g_faj.faj16 = cl_numfor(g_faj.faj16,18,t_azi04)
         LET g_faj.faj31 = cl_numfor(g_faj.faj31,18,g_azi04)
         LET g_faj.faj32 = cl_numfor(g_faj.faj32,18,g_azi04)
         LET g_faj.faj33 = cl_numfor(g_faj.faj33,18,g_azi04)
         LET g_faj.faj331= cl_numfor(g_faj.faj331,18,g_azi04)   #CHI-970002   
         LET g_faj.faj35 = cl_numfor(g_faj.faj35,18,g_azi04)
         LET g_faj.faj59 = cl_numfor(g_faj.faj59,18,g_azi04)
         LET g_faj.faj60 = cl_numfor(g_faj.faj60,18,g_azi04)
         LET g_faj.faj62 = cl_numfor(g_faj.faj62,18,g_azi04)
         LET g_faj.faj63 = cl_numfor(g_faj.faj63,18,g_azi04)
         LET g_faj.faj66 = cl_numfor(g_faj.faj66,18,g_azi04)
         LET g_faj.faj67 = cl_numfor(g_faj.faj67,18,g_azi04)
         LET g_faj.faj68 = cl_numfor(g_faj.faj68,18,g_azi04)
         LET g_faj.faj681= cl_numfor(g_faj.faj681,18,g_azi04)   #CHI-970002    
         LET g_faj.faj69 = cl_numfor(g_faj.faj69,18,g_azi04)
         LET g_faj.faj70 = cl_numfor(g_faj.faj70,18,g_azi04)
         LET g_faj.faj72 = cl_numfor(g_faj.faj72,18,g_azi04)
         LET g_faj.faj81 = cl_numfor(g_faj.faj81,18,g_azi04)
         LET g_faj.faj811 = cl_numfor(g_faj.faj811,18,g_azi04)
         LET g_faj.faj86 = cl_numfor(g_faj.faj86,18,g_azi04)
         LET g_faj.faj87 = cl_numfor(g_faj.faj87,18,g_azi04)
         LET g_faj.faj203 = cl_numfor(g_faj.faj203,18,g_azi04)
         LET g_faj.faj204 = cl_numfor(g_faj.faj204,18,g_azi04)
         LET g_faj.faj205 = cl_numfor(g_faj.faj205,18,g_azi04)
         LET g_faj.faj206 = cl_numfor(g_faj.faj206,18,g_azi04)
         LET g_faj.faj101 = cl_numfor(g_faj.faj101,18,g_azi04)
         LET g_faj.faj102 = cl_numfor(g_faj.faj102,18,g_azi04)
         LET g_faj.faj103 = cl_numfor(g_faj.faj103,18,g_azi04)
         LET g_faj.faj104 = cl_numfor(g_faj.faj104,18,g_azi04)
         LET g_faj.faj108 = cl_numfor(g_faj.faj108,18,g_azi04)
         LET g_faj.faj109 = cl_numfor(g_faj.faj109,18,g_azi04)
         DISPLAY g_faj.faj13,g_faj.faj14,g_faj.faj141,g_faj.faj16,g_faj.faj31,
                 g_faj.faj32,g_faj.faj33,g_faj.faj331,g_faj.faj35,g_faj.faj59,g_faj.faj60, #CHI-970002 add faj331
                 g_faj.faj62,g_faj.faj63,g_faj.faj66,g_faj.faj67,g_faj.faj68,g_faj.faj681, #CHI-970002 add faj681 
                 g_faj.faj69,g_faj.faj70,g_faj.faj72,g_faj.faj81,g_faj.faj811,
                 g_faj.faj86,g_faj.faj87,g_faj.faj203,g_faj.faj204,g_faj.faj205,
                 g_faj.faj206,g_faj.faj101,g_faj.faj102,g_faj.faj103,g_faj.faj104,
                 g_faj.faj108,g_faj.faj109,
                 g_faj.faj71,g_faj.faj72,g_faj.faj73,g_faj.faj74,g_faj.faj741  #No.FUN-7A0079
              TO faj13,faj14,faj141,faj16,faj31,faj32,faj33,faj331,faj35,faj59,faj60, #CHI-970002 add faj331
                 faj62,faj63,faj66,faj67,faj68,faj681,faj69,faj70,faj72,faj81,faj811, #CHI-970002 add faj681
                 faj86,faj87,faj203,faj204,faj205,faj206,faj101,faj102,faj103,
                 faj104,faj108,faj109,faj71,faj72,faj73,faj74,faj741  #No.FUN-7A0079
         
         #-----No:FUN-AB0088-----
        #---------------------------MOD-C50130-------------------------(S)
        #LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04)     #MOD-C50130 mark
        #LET g_faj.faj1412 = cl_numfor(g_faj.faj1412,18,g_azi04)   #MOD-C50130 mark
        #LET g_faj.faj312 = cl_numfor(g_faj.faj312,18,g_azi04)     #MOD-C50130 mark
        #LET g_faj.faj322 = cl_numfor(g_faj.faj322,18,g_azi04)     #MOD-C50130 mark
        #LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04)     #MOD-C50130 mark
        #LET g_faj.faj331= cl_numfor(g_faj.faj3312,18,g_azi04)     #MOD-BB0280 mark
        #LET g_faj.faj3312 = cl_numfor(g_faj.faj3312,18,g_azi04)   #MOD-BB0280 #MOD-C50130 mark
        #LET g_faj.faj352 = cl_numfor(g_faj.faj352,18,g_azi04)     #MOD-C50130 mark
        #LET g_faj.faj592 = cl_numfor(g_faj.faj592,18,g_azi04)     #MOD-C50130 mark
        #LET g_faj.faj602 = cl_numfor(g_faj.faj602,18,g_azi04)     #MOD-C50130 mark
        #LET g_faj.faj2032 = cl_numfor(g_faj.faj2032,18,g_azi04)   #MOD-C50130 mark
        #LET g_faj.faj2042 = cl_numfor(g_faj.faj2042,18,g_azi04)   #MOD-C50130 mark
        #LET g_faj.faj1012 = cl_numfor(g_faj.faj1012,18,g_azi04)   #MOD-C50130 mark
        #LET g_faj.faj1022 = cl_numfor(g_faj.faj1022,18,g_azi04)   #MOD-C50130 mark
        #LET g_faj.faj1082 = cl_numfor(g_faj.faj1082,18,g_azi04)   #MOD-C50130 mark
         LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04_1)
         LET g_faj.faj312 = cl_numfor(g_faj.faj312,18,g_azi04_1)
         LET g_faj.faj322 = cl_numfor(g_faj.faj322,18,g_azi04_1)
         LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04_1)
         LET g_faj.faj352 = cl_numfor(g_faj.faj352,18,g_azi04_1)
         LET g_faj.faj592 = cl_numfor(g_faj.faj592,18,g_azi04_1)
         LET g_faj.faj602 = cl_numfor(g_faj.faj602,18,g_azi04_1)
         LET g_faj.faj1012 = cl_numfor(g_faj.faj1012,18,g_azi04_1)
         LET g_faj.faj1022 = cl_numfor(g_faj.faj1022,18,g_azi04_1)
         LET g_faj.faj1082 = cl_numfor(g_faj.faj1082,18,g_azi04_1)
         LET g_faj.faj1412 = cl_numfor(g_faj.faj1412,18,g_azi04_1)
         LET g_faj.faj2032 = cl_numfor(g_faj.faj2032,18,g_azi04_1)
         LET g_faj.faj2042 = cl_numfor(g_faj.faj2042,18,g_azi04_1)
         LET g_faj.faj3312 = cl_numfor(g_faj.faj3312,18,g_azi04_1)
        #---------------------------MOD-C50130-------------------------(E)
         LET g_faj.faj144 = cl_numfor(g_faj.faj144,18,g_azi04_1) #CHI-C60010 add
         DISPLAY g_faj.faj142,g_faj.faj1412,g_faj.faj312,g_faj.faj322,
                 g_faj.faj332,g_faj.faj3312,g_faj.faj352,g_faj.faj592,
                 g_faj.faj602,g_faj.faj2032,g_faj.faj2042,
                 g_faj.faj1012,g_faj.faj1022,g_faj.faj1082
              TO faj14,faj1412,faj312,faj322,faj332,faj3312,faj352,faj592,
                 faj60,faj2032,faj2042,faj1012,faj1022,faj1082
         #-----No:FUN-AB0088 END-----

      ON ACTION CONTROLP
         CASE
           #Mark No.TQC-B20046
           #WHEN INFIELD(faj022)   #財產編號附號
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form = "q_faj"
           #   LET g_qryparam.default1 = g_faj.faj02
           #   LET g_qryparam.default2 = g_faj.faj22
           #   CALL cl_create_qry() RETURNING g_faj.faj02,g_faj.faj22
           #   DISPLAY BY NAME g_faj.faj02,g_faj.faj022
           #   NEXT FIELD faj022
           #End Mark No.TQC-B20046
            WHEN INFIELD(faj04)   #資產類別
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_fab"
               LET g_qryparam.default1 = g_faj.faj04
               CALL cl_create_qry() RETURNING g_faj.faj04
               DISPLAY BY NAME g_faj.faj04
               NEXT FIELD faj04
            WHEN INFIELD(faj05)   #次要類別
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_fac"
               LET g_qryparam.default1 = g_faj.faj05
               CALL cl_create_qry() RETURNING g_faj.faj05
               DISPLAY BY NAME g_faj.faj05
               NEXT FIELD faj05
            WHEN INFIELD(faj10)   #供應廠商
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc"
               LET g_qryparam.default1 = g_faj.faj10
               CALL cl_create_qry() RETURNING g_faj.faj10
               DISPLAY BY NAME g_faj.faj10
               NEXT FIELD faj10
           #str----mark by guanyao160818
           # WHEN INFIELD(faj11)   #製造廠商
           #    CALL cl_init_qry_var()
           #    LET g_qryparam.form = "q_pmc"
           #    LET g_qryparam.default1 = g_faj.faj11
           #    CALL cl_create_qry() RETURNING g_faj.faj11
           #    DISPLAY BY NAME g_faj.faj11
           #    NEXT FIELD faj11
           #end----mark by guanyao160818
            WHEN INFIELD(faj12)   #原產地
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geb"
               LET g_qryparam.default1 = g_faj.faj12
               CALL cl_create_qry() RETURNING g_faj.faj12
               DISPLAY BY NAME g_faj.faj12
               NEXT FIELD faj12
            WHEN INFIELD(faj18)   #計量單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_faj.faj18
               CALL cl_create_qry() RETURNING g_faj.faj18
               DISPLAY BY NAME g_faj.faj18
               NEXT FIELD faj18
            WHEN INFIELD(faj15)   #原幣幣別
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_faj.faj15
               CALL cl_create_qry() RETURNING g_faj.faj15
               DISPLAY BY NAME g_faj.faj15
               NEXT FIELD faj15
            WHEN INFIELD(faj19)   #保管人
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_faj.faj19
               CALL cl_create_qry() RETURNING g_faj.faj19
               DISPLAY BY NAME g_faj.faj19
               NEXT FIELD faj19
            WHEN INFIELD(faj20)   #保管部門
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_faj.faj20
               CALL cl_create_qry() RETURNING g_faj.faj20
               DISPLAY BY NAME g_faj.faj20
               NEXT FIELD faj20
            WHEN INFIELD(faj21)   #存放位置
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_faf"
               LET g_qryparam.default1 = g_faj.faj21
               CALL cl_create_qry() RETURNING g_faj.faj21
               DISPLAY BY NAME g_faj.faj21
               NEXT FIELD faj21
            WHEN INFIELD(faj22)   #存放工廠
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
               LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add 
               LET g_qryparam.default1 = g_faj.faj22
               CALL cl_create_qry() RETURNING g_faj.faj22
               DISPLAY BY NAME g_faj.faj22
               NEXT FIELD faj22
            WHEN INFIELD(faj24)   #分攤部門
               IF g_faj.faj23='1' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_faj.faj24
                  CALL cl_create_qry() RETURNING g_faj.faj24
                  DISPLAY BY NAME g_faj.faj24
                  NEXT FIELD faj24
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ='q_fad1'                                          #TQC-970139              
                  LET g_qryparam.default1 =g_faj.faj24
                  LET g_qryparam.where = "fad07 = '1'"    #TQC-C50181  add
                  CALL cl_create_qry() RETURNING g_faj.faj24                             #TQC-970139    
                  DISPLAY BY NAME g_faj.faj24
                  DISPLAY BY NAME g_faj.faj53
                  NEXT FIELD faj24
               END IF
             #-----No:FUN-AB0088-----
            WHEN INFIELD(faj242)   #▒▒▒u▒▒▒▒
               IF g_faj.faj232='1' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_faj.faj242
                  CALL cl_create_qry() RETURNING g_faj.faj242
                  DISPLAY BY NAME g_faj.faj242
                  NEXT FIELD faj242
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ='q_fad1'
                  LET g_qryparam.default1 =g_faj.faj242
                  LET g_qryparam.where = "fad07 = '2'"     #TQC-C50181  add
                  CALL cl_create_qry() RETURNING g_faj.faj242
                  DISPLAY BY NAME g_faj.faj242
                  DISPLAY BY NAME g_faj.faj531
                  NEXT FIELD faj242
               END IF
            #-----No:FUN-AB0088 END-----

            WHEN INFIELD(faj44)   #進貨工廠
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
              LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add 
               LET g_qryparam.default1 = g_faj.faj44
               CALL cl_create_qry() RETURNING g_faj.faj44
               DISPLAY BY NAME g_faj.faj44
               NEXT FIELD faj44
            WHEN INFIELD(faj53)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.arg1 = g_aza.aza81   #No.FUN-740026 #No.TQC-740137
               LET g_qryparam.default1 = g_faj.faj53
               CALL cl_create_qry() RETURNING g_faj.faj53
               DISPLAY BY NAME g_faj.faj53
               NEXT FIELD faj53
            WHEN INFIELD(faj54)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.arg1 = g_aza.aza81   #No.FUN-740026 #No.TQC-740137
               LET g_qryparam.default1 = g_faj.faj54
               CALL cl_create_qry() RETURNING g_faj.faj54
               DISPLAY BY NAME g_faj.faj54
               NEXT FIELD faj54
            WHEN INFIELD(faj55)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.arg1 = g_aza.aza81   #No.FUN-740026 #No.TQC-740137
               LET g_qryparam.default1 = g_faj.faj55
               CALL cl_create_qry() RETURNING g_faj.faj55
               DISPLAY BY NAME g_faj.faj55
               NEXT FIELD faj55
            WHEN INFIELD(faj531)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
             # LET g_qryparam.arg1 = g_aza.aza82   #No.FUN-740026 #No.TQC-740137
               LET g_qryparam.arg1 = g_faa.faa02c   #No:FUN-AB0088  #No:FUN-740026 #No.TQC-740137
               LET g_qryparam.default1 = g_faj.faj531
               CALL cl_create_qry() RETURNING g_faj.faj531
               DISPLAY BY NAME g_faj.faj531
               NEXT FIELD faj531
            WHEN INFIELD(faj541)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
              #LET g_qryparam.arg1 = g_aza.aza82   #No.FUN-740026 #No.TQC-740137
               LET g_qryparam.arg1 = g_faa.faa02c   #No:FUN-AB0088  #No:FUN-740026 #No.TQC-740137
               LET g_qryparam.default1 = g_faj.faj541
               CALL cl_create_qry() RETURNING g_faj.faj541
               DISPLAY BY NAME g_faj.faj541
               NEXT FIELD faj541
            WHEN INFIELD(faj551)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
          #    LET g_qryparam.arg1 = g_aza.aza82   #No.FUN-740026 #No.TQC-740137
               LET g_qryparam.arg1 = g_faa.faa02c   #No:FUN-AB0088  #No:FUN-740026 #No.TQC-740137
               LET g_qryparam.default1 = g_faj.faj551
               CALL cl_create_qry() RETURNING g_faj.faj551
               DISPLAY BY NAME g_faj.faj551
               NEXT FIELD faj551
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION fixed_asset
         CALL cl_cmdrun('afai010')
 
      ON ACTION sub_category
         CALL cl_cmdrun('afai020')
 
      ON ACTION exp_apportion
         CALL cl_cmdrun('afai030' CLIPPED)
 
 
      ON ACTION CONTROLZ
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
 
FUNCTION i100_faj03(l_faj03)
DEFINE
      l_faj03    LIKE faj_file.faj03,
      l_c1       LIKE type_file.chr20           #No.FUN-680070 VARCHAR(15)
 
      CASE l_faj03
         WHEN '1'
            CALL cl_getmsg('afa-054',g_lang) RETURNING l_c1
         WHEN '2'
            CALL cl_getmsg('afa-015',g_lang) RETURNING l_c1
         WHEN '3'
            CALL cl_getmsg('afa-055',g_lang) RETURNING l_c1
         OTHERWISE EXIT CASE
      END CASE
     RETURN(l_c1)
END FUNCTION
 
FUNCTION i100_faj43(l_faj43)
DEFINE
      l_faj43   LIKE faj_file.faj43,
      l_bn       LIKE type_file.chr20           #No.FUN-680070 VARCHAR(15)
 
     CASE l_faj43
         WHEN '0'
            CALL cl_getmsg('afa-056',g_lang) RETURNING l_bn
         WHEN '1'
            CALL cl_getmsg('afa-014',g_lang) RETURNING l_bn
         WHEN '2'
            CALL cl_getmsg('afa-057',g_lang) RETURNING l_bn
         WHEN '3'
            CALL cl_getmsg('afa-023',g_lang) RETURNING l_bn
         WHEN '4'
            CALL cl_getmsg('afa-058',g_lang) RETURNING l_bn
         WHEN '5'
            CALL cl_getmsg('afa-017',g_lang) RETURNING l_bn
         WHEN '6'
            CALL cl_getmsg('afa-019',g_lang) RETURNING l_bn
         WHEN '7'
            CALL cl_getmsg('afa-059',g_lang) RETURNING l_bn
         WHEN '8'
            CALL cl_getmsg('afa-020',g_lang) RETURNING l_bn
         WHEN '9'
            CALL cl_getmsg('afa-021',g_lang) RETURNING l_bn
         WHEN 'X'
            CALL cl_getmsg('afa-027',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
#-------- 輸入資產類別後,自動帶出該類別之相關欄位 ---------
FUNCTION i100_faj04(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_faj29      LIKE faj_file.faj29,
       l_faj292     LIKE faj_file.faj292,   #No:FUN-AB0088
       l_fabacti    LIKE fab_file.fabacti
    DEFINE aag02_1         LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(20)
           aag02_2         LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(20)
           aag02_3         LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
    DEFINE aag02_1a        LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(20)
           aag02_2a        LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(20)
           aag02_3a        LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
     LET g_errno = ' '
     IF p_cmd = 'a' THEN
     SELECT fab03,fab04,fab05,fab06,fab07,
            fab08,fab10,fab11,fab12,
            fab13,fab14,fab15,fab16,fab17,
            fab18,fab19,fab20,fab21,fab22,fabacti
       INTO g_faj.faj09,g_faj.faj28,l_faj29,g_faj.faj61,g_faj.faj64,
            g_faj.faj34,g_faj.faj36,g_faj.faj53,g_faj.faj54,
             g_faj.faj55,g_faj.faj37,g_faj.faj38,g_faj.faj39,g_faj.faj40,   #MOD-570148
            g_faj.faj41,g_faj.faj42,g_faj.faj421,g_faj.faj422,g_faj.faj423,
            l_fabacti
       FROM fab_file
      WHERE fab01 = g_faj.faj04
   # IF g_aza.aza63 = 'Y' THEN
     IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
        SELECT fab111,fab121,fab131,fab042,fab052,fab082   #No:FUN-AB0088 
          INTO g_faj.faj531,g_faj.faj541,g_faj.faj551,
               g_faj.faj282,l_faj292,g_faj.faj342   #No:FUN-AB0088
          FROM fab_file
         WHERE fab01 = g_faj.faj04
         CASE
             WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-045'
                LET g_faj.faj531= NULL  
                LET g_faj.faj541= NULL 
                LET g_faj.faj551= NULL
                #-----No:FUN-AB0088-----
                LET g_faj.faj282= NULL
                LET l_faj292= NULL
                LET g_faj.faj342= NULL
                #-----No:FUN-AB0088 END-----
             OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
     END IF
     CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-045'
            LET g_faj.faj09 = NULL
            LET g_faj.faj28 = NULL   LET g_faj.faj37 = NULL
            LET l_faj29     = NULL   LET g_faj.faj38 = NULL
            LET g_faj.faj61 = NULL   LET g_faj.faj39 = NULL
            LET g_faj.faj64 = NULL   LET g_faj.faj40 = NULL
            LET g_faj.faj34 = NULL   LET g_faj.faj41 = NULL
            LET g_faj.faj35 = NULL   LET g_faj.faj42 = NULL
            LET g_faj.faj36 = NULL   LET g_faj.faj421 = NULL
            LET g_faj.faj53 = NULL   LET g_faj.faj422 = NULL
            LET g_faj.faj54 = NULL   LET g_faj.faj423 = NULL
            LET g_faj.faj55 = NULL   LET l_fabacti = NULL
         WHEN l_fabacti = 'N'  LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     END IF
     IF g_faj.faj021 MATCHES '[23]' THEN
        IF cl_null(g_faj.faj29) OR g_faj.faj29 = 0 THEN
           SELECT faj29 INTO g_faj.faj29 FROM faj_file
             WHERE faj02 = g_faj.faj02 AND 
                   faj022 = ' '
           IF cl_null(g_faj.faj29) OR g_faj.faj29 = 0 THEN
              LET g_faj.faj29 = l_faj29
              LET g_faj.faj30 = l_faj29
           ELSE
              LET g_faj.faj30 = g_faj.faj29
           END IF
        END IF
        #-----No:FUN-AB0088-----
        IF cl_null(g_faj.faj292) OR g_faj.faj292 = 0 THEN
           SELECT faj292 INTO g_faj.faj292 FROM faj_file
             WHERE faj02 = g_faj.faj02 AND
                   faj022 = ' '
           IF cl_null(g_faj.faj292) OR g_faj.faj292 = 0 THEN
              LET g_faj.faj292 = l_faj292
              LET g_faj.faj302 = l_faj292
           ELSE
              LET g_faj.faj302 = g_faj.faj292
           END IF
        END IF
        #-----No:FUN-AB0088 END-----
     ELSE
        IF cl_null(g_faj.faj29) OR g_faj.faj29 = 0 THEN
           LET g_faj.faj29 = l_faj29
           LET g_faj.faj30 = l_faj29
        END IF
        #-----No:FUN-AB0088-----
        IF cl_null(g_faj.faj292) OR g_faj.faj292 = 0 THEN
           LET g_faj.faj292 = l_faj292
           LET g_faj.faj302 = l_faj292
        END IF
        #-----No:FUN-AB0088 END-----
     END IF
     LET g_faj.faj65 = g_faj.faj64
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY BY NAME g_faj.faj09,g_faj.faj28,g_faj.faj29,g_faj.faj30,
                        g_faj.faj34,g_faj.faj35,g_faj.faj36,
                         g_faj.faj53,g_faj.faj54,g_faj.faj55   #MOD-570148

        CALL i100_faj53(g_faj.faj53,g_aza.aza81) RETURNING aag02_1 #No.TQC-740137
        #MOD-B30367--add--str--
        IF NOT cl_null(g_errno) THEN
           LET g_errno = 'afa1002'
        END IF
        #MOD-B30367--add--end--
        IF g_faj.faj28 <> '0' THEN    #MOD-7B0246
           CALL i100_faj53(g_faj.faj54,g_aza.aza81) RETURNING aag02_2 #No.TQC-740137
           CALL i100_faj53(g_faj.faj55,g_aza.aza81) RETURNING aag02_3 #No.TQC-740137
        END IF   #MOD-7B0246
        DISPLAY aag02_1 TO FORMONLY.aag02_1
        DISPLAY aag02_2 TO FORMONLY.aag02_2
        DISPLAY aag02_3 TO FORMONLY.aag02_3
       #IF g_aza.aza63 = 'Y' THEN
        IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
           DISPLAY BY NAME g_faj.faj531,g_faj.faj541,g_faj.faj551
           DISPLAY BY NAME g_faj.faj282,g_faj.faj292,g_faj.faj302,g_faj.faj342   #No:FUN-AB0088

         # CALL i100_faj531(g_faj.faj531,g_aza.aza82) RETURNING aag02_1a #No.TQC-740137
           CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a   #No:FUN-AB0088 #No.TQC-740137
           IF g_faj.faj28 <> '0' THEN    #MOD-7B0246
           #  CALL i100_faj531(g_faj.faj541,g_aza.aza82) RETURNING aag02_2a #No.TQC-740137
           #  CALL i100_faj531(g_faj.faj551,g_aza.aza82) RETURNING aag02_3a #No.TQC-740137
              CALL i100_faj531(g_faj.faj541,g_faa.faa02c) RETURNING aag02_2a #No.TQC-740137
              CALL i100_faj531(g_faj.faj551,g_faa.faa02c) RETURNING aag02_3a #No.TQC-740137
           END IF   #MOD-7B0246
           DISPLAY aag02_1a TO FORMONLY.aag02_1a
           DISPLAY aag02_2a TO FORMONLY.aag02_2a
           DISPLAY aag02_3a TO FORMONLY.aag02_3a
        END IF
     END IF
END FUNCTION
 
FUNCTION i100_faj05(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_fac01   LIKE fac_file.fac01,
        l_facacti LIKE fac_file.facacti
 
     LET g_errno = ' '
     SELECT fac01,facacti INTO l_fac01,l_facacti
       FROM fac_file
      WHERE fac01 = g_faj.faj05
     CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-046'
                                  LET l_fac01 = NULL
                                  LET l_facacti = NULL
         WHEN l_facacti = 'N' LET g_errno = '9028'
         OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
END FUNCTION
 
FUNCTION i100_faj10(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
    DEFINE l_pmc03   LIKE pmc_file.pmc03
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
    SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
           FROM pmc_file WHERE pmc01 = g_faj.faj10
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-031'
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_pmc03 TO FORMONLY.pmc03
    END IF
END FUNCTION

#-MOD-B30109-add- 
FUNCTION i100_faj11(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1        
    DEFINE l_pmc03   LIKE pmc_file.pmc03
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
    SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
           FROM pmc_file WHERE pmc01 = g_faj.faj11
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-031'
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
END FUNCTION
#-MOD-B30109-end- 
 
FUNCTION i100_faj12(p_cmd)                                                                                                          
    DEFINE p_cmd   LIKE type_file.chr1                                                                                              
    DEFINE l_geb02 LIKE geb_file.geb02                                                                                              
    DEFINE l_gebacti LIKE geb_file.gebacti  #MOD-B30109
                                                                                                                                    
   #SELECT geb02 INTO l_geb02 FROM geb_file       #MOD-B30109 mark 
    SELECT geb02,gebacti INTO l_geb02,l_gebacti   #MOD-B30109
      FROM geb_file                               #MOD-B30109 
     WHERE geb01=g_faj.faj12                                                                                                        
   #-MOD-B30109-add-
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'axm-060'
         WHEN l_gebacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
   #-MOD-B30109-end-
       DISPLAY l_geb02 TO FORMONLY.geb02
    END IF     #MOD-B30109 
END FUNCTION                                                                                                                        
 
FUNCTION i100_faj15(p_cmd)
DEFINE
      p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_azi01      LIKE azi_file.azi01,
      l_aziacti    LIKE azi_file.aziacti
 
      LET g_errno = ' '
      SELECT azi01,aziacti INTO l_azi01,l_aziacti
        FROM azi_file
       WHERE azi01 = g_faj.faj15
      CASE
          WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-050'
                                   LET l_azi01 = NULL
                                   LET l_aziacti = NULL
          WHEN l_aziacti = 'N' LET g_errno = '9028'
          OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
END FUNCTION
 
FUNCTION i100_faj20(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gem01    LIKE gem_file.gem01,
       l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem01,gemacti INTO l_gem01,l_gemacti
      FROM gem_file
     WHERE gem01 = g_faj.faj20
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i100_faj19(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
      FROM gen_file
     WHERE gen01 = g_faj.faj19
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' THEN
      #darcy:2023/01/11 mark s---
      # 财务需求，保管人不要带出保管部门。
      #  LET g_faj.faj20 = l_gen03
      #  DISPLAY BY NAME g_faj.faj20
      #darcy:2023/01/11 mark e---
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION i100_faj21(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_faf01    LIKE faf_file.faf01,
      l_faf03    LIKE faf_file.faf03,
      l_fafacti  LIKE faf_file.fafacti
 
     LET g_errno = ' '
     SELECT faf01,faf03,fafacti INTO l_faf01,l_faf03,l_fafacti
       FROM faf_file
      WHERE faf01 = g_faj.faj21
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-039'
                                LET l_faf01 = NULL
                                LET l_faf03 = NULL
                                LET l_fafacti = NULL
       WHEN l_fafacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_faj.faj22 = l_faf03
    DISPLAY BY NAME g_faj.faj22
END FUNCTION
 
FUNCTION i100_faj22(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_azp01    LIKE azp_file.azp01
 
     LET g_errno = ' '
     #FUN-990031--mod--str--營運中心要控制在當前法人下 
     SELECT * FROM azw_file                                                                                                          
      WHERE azw01 = g_faj.faj22  AND azw02 = g_legal  
     CASE
       WHEN SQLCA.SQLCODE = 100 #LET g_errno = 'afa-044'   #FUN-990031 mark
                                LET g_errno = 'agl-171'    #FUN-990031 add
                                LET l_azp01 = NULL
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i100_faj241(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti
 
     LET g_errno = ' '
     SELECT gem01,gemacti INTO l_gem01,l_gemacti
       FROM gem_file
      WHERE gem01 = g_faj.faj24
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N' LET g_errno = '9028'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
END FUNCTION
 
FUNCTION i100_faj242(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_cnt        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_faj53      LIKE faj_file.faj53
 
      LET g_errno = ' '
      IF cl_null(g_faj.faj53) THEN
         CALL cl_err(' ',STATUS,0)
      ELSE
         SELECT COUNT(*) INTO l_cnt
           FROM fad_file
          WHERE fad04 = g_faj.faj24
            AND fad03 = g_faj.faj53
            AND fadacti = 'Y'
            AND fad07 = '1'   #TQC-C50181  add
         IF l_cnt = 0 THEN LET g_errno = 'afa-342' END IF
      END IF
END FUNCTION
 
#-----No:FUN-AB0088-----
FUNCTION i100_faj2412(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 CHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti

     LET g_errno = ' '
     SELECT gem01,gemacti INTO l_gem01,l_gemacti
       FROM gem_file
      WHERE gem01 = g_faj.faj242
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N' LET g_errno = '9028'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
END FUNCTION

FUNCTION i100_faj2422(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1,         #No.FUN-680070 CHAR(1)
       l_cnt        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_faj53      LIKE faj_file.faj53

      LET g_errno = ' '
#     IF cl_null(g_faj.faj53) THEN    #MOD-B70018 mark
      IF cl_null(g_faj.faj531) THEN   #MOD-B70018
         CALL cl_err(' ',STATUS,0)
      ELSE
         SELECT COUNT(*) INTO l_cnt
           FROM fad_file
          WHERE fad04 = g_faj.faj242
            AND fad03 = g_faj.faj531
            AND fadacti = 'Y'
            AND fad07 = '2'   #TQC-C50181    add
         IF l_cnt = 0 THEN LET g_errno = 'afa-342' END IF
      END IF
END FUNCTION
#-----No:FUN-AB0088 END-----

FUNCTION i100_faj44(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_azp01    LIKE azp_file.azp01
 
     LET g_errno = ' '
     #FUN-990031--mod--str--營運中心需控制在當前法人下
     SELECT * FROM azw_file                                                                                                         
      WHERE azw01 = g_faj.faj44  AND azw02 = g_legal 
     CASE
       WHEN SQLCA.SQLCODE = 100 #LET g_errno = 'afa-044'     #FUN-990031
                                LET g_errno = 'agl-171'      #FUN-990031
                                LET l_azp01 = NULL
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i100_3133()
 
    IF g_aza.aza26 = '2' THEN
       SELECT fab23 INTO g_fab23 FROM fab_file WHERE fab01 = g_faj.faj04
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","fab_file",g_faj.faj04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
          LET g_success = 'N' RETURN
       END IF
       IF g_faj.faj28 MATCHES '[05]' THEN
          LET g_faj.faj31 = 0
       ELSE
#          LET g_faj.faj31 = (g_faj.faj14-g_faj.faj32)*g_fab23/100  #MOD-A40033 mark
           LET g_faj.faj31 = g_faj.faj14*g_fab23/100  #MOD-A40033 
       END IF
    ELSE
       CASE g_faj.faj28
         WHEN '0'   LET g_faj.faj31 = 0
         WHEN '1'   LET g_faj.faj31 =
                       (g_faj.faj14-g_faj.faj32)/(g_faj.faj29 + 12)*12
         WHEN '2'   LET g_faj.faj31 = 0
         WHEN '3'   LET g_faj.faj31 = (g_faj.faj14-g_faj.faj32)/10
         WHEN '4'   LET g_faj.faj31 = 0
         WHEN '5'   LET g_faj.faj31 = 0
         OTHERWISE EXIT CASE
       END CASE
    END IF
    CALL cl_digcut(g_faj.faj31,g_azi04) RETURNING g_faj.faj31
    DISPLAY BY NAME g_faj.faj31
    LET g_faj.faj33 = g_faj.faj14 - g_faj.faj32 #- g_faj.faj31
    LET g_faj.faj33 = cl_numfor(g_faj.faj33,18,g_azi04)   #MOD-580279
    DISPLAY BY NAME g_faj.faj33   #MOD-580279
END FUNCTION

#-----No:FUN-AB0088-----
FUNCTION i100_31332()   

    #modify 031215 NO.A099
    IF g_aza.aza26 = '2' THEN
       SELECT fab232 INTO g_fab232 FROM fab_file WHERE fab01 = g_faj.faj04
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","fab_file",g_faj.faj04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
          LET g_success = 'N' RETURN
       END IF

       IF g_faj.faj282 MATCHES '[05]' THEN
          LET g_faj.faj312 = 0
       ELSE
           LET g_faj.faj312 = g_faj.faj142*g_fab232/100  #MOD-A40033
       END IF
    ELSE
       CASE g_faj.faj282
         WHEN '0'   LET g_faj.faj312 = 0
         WHEN '1'   LET g_faj.faj312 =
                       (g_faj.faj142-g_faj.faj322)/(g_faj.faj292 + 12)*12
         WHEN '2'   LET g_faj.faj312 = 0
         WHEN '3'   LET g_faj.faj312 = (g_faj.faj142-g_faj.faj322)/10
         WHEN '4'   LET g_faj.faj312 = 0
         WHEN '5'   LET g_faj.faj312 = 0
         OTHERWISE EXIT CASE
       END CASE
    END IF
    #end No:A099
   #CALL cl_digcut(g_faj.faj312,g_azi04) RETURNING g_faj.faj312         #MOD-C50130 mark
    CALL cl_digcut(g_faj.faj312,g_azi04_1) RETURNING g_faj.faj312       #MOD-C50130 add
    DISPLAY BY NAME g_faj.faj312
    LET g_faj.faj332 = g_faj.faj142 - g_faj.faj322
   #LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04)     #MOD-580279 #MOD-C50130 mark
    LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04_1)   #MOD-C50130 add
    DISPLAY BY NAME g_faj.faj332   #MOD-580279
END FUNCTION
#-----No:FUN-AB0088 END-----
 
FUNCTION i100_6668()   #稅簽
    IF g_aza.aza26 = '2' THEN
       SELECT fab23 INTO g_fab23 FROM fab_file WHERE fab01 = g_faj.faj04
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","fab_file",g_faj.faj04,"",SQLCA.sqlcode,"","",1)
          LET g_success = 'N' RETURN
       END IF
       IF g_faj.faj61 MATCHES '[05]' THEN
          LET g_faj.faj66 = 0
       ELSE
#          LET g_faj.faj66 = (g_faj.faj62-g_faj.faj67)*g_fab23/100  #MOD-A40033 mark
           LET g_faj.faj66 = g_faj.faj62*g_fab23/100  #MOD-A40033 
       END IF
    ELSE
       CASE g_faj.faj61
         WHEN '0'   LET g_faj.faj66 = 0
         WHEN '1'   LET g_faj.faj66 =
                       (g_faj.faj62-g_faj.faj67)/(g_faj.faj64 + 12)*12
         WHEN '2'   LET g_faj.faj66 = 0
         WHEN '3'   LET g_faj.faj66 = (g_faj.faj62-g_faj.faj67)/10
         WHEN '4'   LET g_faj.faj66 = 0
         WHEN '5'   LET g_faj.faj66 = 0
         OTHERWISE EXIT CASE
       END CASE
    END IF
    CALL cl_digcut(g_faj.faj66,g_azi04) RETURNING g_faj.faj66
    DISPLAY BY NAME g_faj.faj66
    LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
    LET g_faj.faj68 = cl_numfor(g_faj.faj68,18,g_azi04)
    DISPLAY BY NAME g_faj.faj68
END FUNCTION
 
FUNCTION i100_q()          #查詢
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_faj.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i100_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i100_count
    FETCH i100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faj.faj01,SQLCA.sqlcode,0)
        INITIALIZE g_faj.* TO NULL
    ELSE
       CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
       CALL i100_b_fill()    #No.FUN-CB0080 Add
    END IF
END FUNCTION
 
FUNCTION i100_fetch(p_flfaj)
    DEFINE
        p_flfaj          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_abso          LIKE type_file.num10        #No.FUN-680070 INTEGER
 
    CASE p_flfaj
        WHEN 'N' FETCH NEXT     i100_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
        WHEN 'P' FETCH PREVIOUS i100_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
        WHEN 'F' FETCH FIRST    i100_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
        WHEN 'L' FETCH LAST     i100_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
        WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         FETCH ABSOLUTE g_jump i100_cs INTO g_faj.faj01,g_faj.faj02,g_faj.faj022
         LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faj.faj01,SQLCA.sqlcode,0)
        INITIALIZE g_faj.* TO NULL  #TQC-6B0105
    LET g_faj.faj01 = NULL LET g_faj.faj02 = NULL LET g_faj.faj022 = NULL
        RETURN
    ELSE
       CASE p_flfaj
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_faj.* FROM faj_file        # 重讀DB,因TEMP有不被更新特性
 WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","faj_file",g_faj.faj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        LET g_data_owner = g_faj.fajuser   #FUN-4C0059
        LET g_data_group = g_faj.fajgrup   #FUN-4C0059

        CALL i100_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i100_show()
    DEFINE aag02_1         LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
           aag02_2         LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
           aag02_3         LIKE aag_file.aag02        #No.FUN-680070 VARCHAR(20)
    DEFINE aag02_1a        LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
           aag02_2a        LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
           aag02_3a        LIKE aag_file.aag02        #No.FUN-680070 VARCHAR(20)
 
    LET g_faj_t.* = g_faj.*
    LET g_faj_o.*=g_faj.*
    DISPLAY BY NAME g_faj.fajoriu,g_faj.fajorig,
        g_faj.faj01,g_faj.faj021,g_faj.faj02,g_faj.faj022,g_faj.faj03,
        g_faj.faj04,g_faj.faj05,g_faj.faj09,g_faj.faj93,g_faj.faj10,g_faj.faj11,               #FUN-9A0036 add faj93
        g_faj.faj12,g_faj.faj06,g_faj.faj061,g_faj.faj07,g_faj.faj071,
        g_faj.faj08,g_faj.faj18,g_faj.faj17,g_faj.faj171,g_faj.faj13,
        g_faj.faj14,g_faj.faj15,g_faj.faj16,g_faj.faj43,g_faj.faj201,g_faj.faj432,   #No:FUN-AB0088
        g_faj.fajconf,g_faj.faj19,g_faj.faj20,g_faj.faj21,g_faj.faj22,
        g_faj.fajuser,g_faj.fajgrup,g_faj.fajmodu,g_faj.fajdate,
        g_faj.faj23,g_faj.faj24,g_faj.faj25,g_faj.faj26,g_faj.faj27,
        g_faj.faj34,g_faj.faj35,g_faj.faj36,g_faj.faj28,g_faj.faj29,g_faj.faj30,
        g_faj.faj31,g_faj.faj32,g_faj.faj203,g_faj.faj33,g_faj.faj331,g_faj.faj57,g_faj.faj571,g_faj.faj141,   #TQC-680123 #MOD-990240 add faj331      
        g_faj.faj58,g_faj.faj59,g_faj.faj60,g_faj.faj204,g_faj.faj108,g_faj.faj62,#No.TQC-690099 add faj108
        g_faj.faj61,g_faj.faj64,g_faj.faj65,g_faj.faj109,g_faj.faj66,g_faj.faj67, #No.TQC-690099 add faj109
        g_faj.faj205,g_faj.faj68,g_faj.faj681,g_faj.faj63,g_faj.faj69,g_faj.faj70,g_faj.faj206, #CHI-970002 add faj681
        g_faj.faj103,g_faj.faj104,g_faj.faj110,g_faj.faj111,   #No:A099
        #-----No:FUN-AB0088-----
        #Asset 2
        g_faj.faj143,g_faj.faj144,g_faj.faj142,g_faj.faj1012,g_faj.faj1022,g_faj.faj1062,g_faj.faj1072,
        g_faj.faj232,g_faj.faj242,g_faj.faj262,g_faj.faj272,
        g_faj.faj342,g_faj.faj352,g_faj.faj362,g_faj.faj282,g_faj.faj292,g_faj.faj302,
        g_faj.faj312,g_faj.faj322,g_faj.faj2032,g_faj.faj332,g_faj.faj3312,g_faj.faj572,g_faj.faj5712,
        g_faj.faj1412,g_faj.faj582,g_faj.faj592,g_faj.faj602,g_faj.faj2042,g_faj.faj1082,
        #-----No:FUN-AB0088 END-----
        #g_faj.faj37,g_faj.faj105,g_faj.faj101,g_faj.faj102, #No:FUN-B80081 mark
        g_faj.faj37,g_faj.faj101,g_faj.faj102, #No:FUN-B80081 add,移除g_faj.faj105
        g_faj.faj106,g_faj.faj107,
        g_faj.faj38,g_faj.faj39,g_faj.faj40,g_faj.faj41,
        g_faj.faj42,g_faj.faj421,g_faj.faj422,g_faj.faj423,g_faj.faj56,
        g_faj.faj53,g_faj.faj54,g_faj.faj55,
        g_faj.faj531,g_faj.faj541,g_faj.faj551,  #No.FUN-680028
        g_faj.faj44,g_faj.faj45,g_faj.faj451,g_faj.faj46,g_faj.faj461,
        g_faj.faj47,g_faj.faj471,g_faj.faj48,g_faj.faj49,             #No.FUN-840006 去掉g_faj.faj50  
        g_faj.faj51,g_faj.faj52,
        g_faj.faj71,g_faj.faj72,g_faj.faj73,g_faj.faj74,g_faj.faj741  #No.FUN-7A0079
       ,g_faj.fajud01,g_faj.fajud02,g_faj.fajud03,g_faj.fajud04,
        g_faj.fajud05,g_faj.fajud06,g_faj.fajud07,g_faj.fajud08,
        g_faj.fajud09,g_faj.fajud10,g_faj.fajud11,g_faj.fajud12,
        g_faj.fajud13,g_faj.fajud14,g_faj.fajud15 
 
    CALL i100_faj19('d')
    CALL i100_faj10('d')
    CALL i100_faj12('d')                                              #TQC-950145

    CALL i100_faj53(g_faj.faj53,g_aza.aza81) RETURNING aag02_1 #No.TQC-740137
    CALL i100_faj53(g_faj.faj54,g_aza.aza81) RETURNING aag02_2 #No.TQC-740137
    CALL i100_faj53(g_faj.faj55,g_aza.aza81) RETURNING aag02_3 #No.TQC-740137
    DISPLAY aag02_1 TO FORMONLY.aag02_1
    DISPLAY aag02_2 TO FORMONLY.aag02_2
    DISPLAY aag02_3 TO FORMONLY.aag02_3

   #CALL i100_faj531(g_faj.faj531,g_aza.aza82) RETURNING aag02_1a #No.TQC-740137
   #CALL i100_faj531(g_faj.faj541,g_aza.aza82) RETURNING aag02_2a #No.TQC-740137
   #CALL i100_faj531(g_faj.faj551,g_aza.aza82) RETURNING aag02_3a #No.TQC-740137
    CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a #No.TQC-740137   #No:FUN-AB0088
    CALL i100_faj531(g_faj.faj541,g_faa.faa02c) RETURNING aag02_2a #No.TQC-740137   #No:FUN-AB0088
    CALL i100_faj531(g_faj.faj551,g_faa.faa02c) RETURNING aag02_3a #No.TQC-740137   #No:FUN-AB0088
    DISPLAY aag02_1a TO FORMONLY.aag02_1a
    DISPLAY aag02_2a TO FORMONLY.aag02_2a
    DISPLAY aag02_3a TO FORMONLY.aag02_3a
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_u()          #更改
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_faa.faa04 = 'N' THEN         #no:5423參數faa04可選擇資產序號是否可空白
      IF cl_null(g_faj.faj01) THEN
         CALL cl_err('',-400,0)
         RETURN
      END IF
   END IF
 
   SELECT * INTO g_faj.* FROM faj_file
    WHERE faj02 = g_faj.faj02
      AND faj022 = g_faj.faj022
      AND faj01 = g_faj.faj01       #TQC-B70023
   IF g_faj.fajconf = 'Y' THEN
      CALL cl_err('','afa-096',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_faj_o.* = g_faj.*
 
   BEGIN WORK
 
   OPEN i100_cl USING g_faj.faj01,g_faj.faj02,g_faj.faj022
   IF STATUS THEN
      CALL cl_err("OPEN i100_cl:", STATUS, 1)
      CLOSE i100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i100_cl INTO g_faj.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_faj.faj01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i100_show()                             #顯示最新資料
 
   WHILE TRUE
      LET g_faj.fajmodu = g_user                #修改者
      LET g_faj.fajdate = g_today               #修改日期

  #--------------------MOD-C50130--------------(S)
   SELECT aaa03 INTO g_faj.faj143 FROM aaa_file
    WHERE aaa01 = g_faa.faa02c
   IF NOT cl_null(g_faj.faj143) THEN
      SELECT azi04 INTO g_azi04_1 FROM azi_file
       WHERE azi01 = g_faj.faj143
   END IF
  #--------------------MOD-C50130--------------(E)
 
      CALL i100_i("u")                         # 欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_faj.* = g_faj_t.*
         CALL i100_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE faj_file SET faj_file.* = g_faj.*    # 更新DB
#WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022                  # COLAUTH?  #MOD-A40190 mark
     #WHERE faj01 = g_faj_o.faj01 AND faj02 = g_faj_o.faj02 AND faj022 = g_faj_o.faj022   #MOD-A40190 add
      WHERE faj01 = g_faj_t.faj01 AND faj02 = g_faj_t.faj02 AND faj022 = g_faj_t.faj022   #MOD-A40190 add  #Mod No.TQC-B20040
     #IF SQLCA.sqlcode THEN                               #MOD-A40190 mark  
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN       #MOD-A40190 add 
          CALL cl_err3("upd","faj_file",g_faj_t.faj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
          CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i100_cl
   COMMIT WORK
   CALL i100_show()
 
END FUNCTION
 
FUNCTION i100_r()        #取消
   DEFINE l_chr LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE l_fak90  LIKE fak_file.fak90      #MOD-CA0163 add
   DEFINE l_fak901 LIKE fak_file.fak901     #MOD-CA0163 add
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_faa.faa04='N' THEN #no:5423參數faa04可選擇資產序號是否可空白
      IF cl_null(g_faj.faj01) THEN
         CALL cl_err('',-400,0)
         RETURN
      END IF
   END IF
 
   SELECT * INTO g_faj.* FROM faj_file
    WHERE faj02 = g_faj.faj02
      AND faj022 = g_faj.faj022
      AND faj01 = g_faj.faj01       #TQC-B70023
   IF g_faj.fajconf = 'Y' THEN
      CALL cl_err(' ','afa-096',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i100_cl USING g_faj.faj01,g_faj.faj02,g_faj.faj022
 
   IF STATUS THEN
      CALL cl_err("OPEN i100_cl:", STATUS, 1)
      CLOSE i100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i100_cl INTO g_faj.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_faj.faj01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i100_show()
 
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "faj01"            #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_faj.faj01         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "faj02"            #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_faj.faj02         #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "faj022"           #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_faj.faj022        #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM faj_file
       WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022
         AND faj02 = g_faj.faj02
         AND faj022 = g_faj.faj022
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","faj_file",g_faj.faj01,g_faj.faj02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
      ELSE
        #MOD-BB0267 -- mark begin --
        #SELECT COUNT(*) INTO g_cnt FROM fak_file
        # WHERE fak02 = g_faj.faj02
        #   AND fak022 = g_faj.faj022
        #   AND fak91 = 'Y'
        #IF g_cnt > 0 THEN
        #   UPDATE fak_file SET fak91 = 'N'
        #    WHERE fak02 = g_faj.faj02
        #      AND fak022 = g_faj.faj022
        #    IF SQLCA.SQLCODE THEN            #No.MOD-4A0186
        #      CALL cl_err3("upd","fak_file",g_faj.faj02,g_faj.faj022,SQLCA.sqlcode,"","",1)  #No.FUN-660136
        #   END IF
        #END IF
        #MOD-BB0267 -- mark end --
         LET g_cnt = 0 
         #SELECT COUNT(*) INTO g_cnt FROM fak_file      #MOD-CA0163 mark
         #MOD-BB0267 -- modify begin --
         #WHERE fak90 = g_faj.faj02
         #  AND fak901 = g_faj.faj022
         #WHERE fak02 = g_faj.faj92                    #MOD-CA0163 mark
         #  AND fak022 = g_faj.faj921                  #MOD-CA0163 mark
         SELECT COUNT(*) INTO g_cnt FROM fak_file      #MOD-CA0163 add
          WHERE fak90 = g_faj.faj92                    #MOD-CA0163 add
            AND fak901 = g_faj.faj921                  #MOD-CA0163 add
            AND fak01 = g_faj.faj922                   #No.MOD-C20120
         #MOD-BB0267 -- modify end --
            AND fak91 = 'Y'
         IF g_cnt > 0 THEN
            #MOD-BB0267 -- begin --
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM faj_file
             WHERE faj92 = g_faj.faj92
               AND faj921 = g_faj.faj921
               AND faj922 = g_faj.faj922    #No.MOD-C20120
            IF g_cnt = 0 THEN
            #MOD-BB0267 -- end --
              #UPDATE fak_file SET fak91 = 'N',fak90='',fak901=''   #No.MOD-B40257 #MOD-CA0163 mark
              #MOD-BB0267 -- modify begin --
              #WHERE fak90 = g_faj.faj02
              #  AND fak901 = g_faj.faj022
              # WHERE fak02 = g_faj.faj92                                #MOD-CA0163 mark
              #   AND fak022 = g_faj.faj921                              #MOD-CA0163 mark
               UPDATE fak_file SET fak91 = 'N',fak90 = '',fak901 = ''    #MOD-CA0163 add
                WHERE fak90 = g_faj.faj92                                #MOD-CA0163 add
                  AND fak901 = g_faj.faj921                              #MOD-CA0163 add
                  AND fak01 = g_faj.faj922   #No.MOD-C20120
               #MOD-BB0267 -- modify end --
               IF SQLCA.SQLCODE THEN           
                  CALL cl_err3("upd","fak_file",g_faj.faj02,g_faj.faj022,SQLCA.sqlcode,"","",1)
               END IF
            ENd IF   #MOD-BB0267 add
#No.MOD-C20120 --begin
         ELSE
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM fak_file
             WHERE fak90 = g_faj.faj02
               AND fak901 = g_faj.faj022
               AND fak91 = 'Y'
            IF g_cnt > 0 THEN
                  UPDATE fak_file SET fak91 = 'N',fak90='',fak901=''   #No.MOD-B40257
                   WHERE fak90 = g_faj.faj02
                     AND fak901 = g_faj.faj022
                  IF SQLCA.SQLCODE THEN
                     CALL cl_err3("upd","fak_file",g_faj.faj02,g_faj.faj022,SQLCA.sqlcode,"","",1)
                  END IF
            END IF
#No.MOD-C20120 --end
         END IF
         CLEAR FORM
 
         OPEN i100_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i100_cs
             CLOSE i100_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i100_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i100_cs
             CLOSE i100_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
 
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN i100_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i100_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i100_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE i100_cl
   COMMIT WORK
   CALL i100_b_fill()    #No.FUN-CB0080 Add
END FUNCTION
 
FUNCTION i100_copy()
   DEFINE l_faj             RECORD LIKE faj_file.*,
          l_oldno1,l_newno1 LIKE faj_file.faj01,
          l_oldno2,l_newno2 LIKE faj_file.faj02,
          l_oldno3,l_newno3 LIKE faj_file.faj021,
          l_oldno4,l_newno4 LIKE faj_file.faj022,
          l_faa031          LIKE faj_file.faj01,
          l_mxno            LIKE faj_file.faj022,
          l_str             STRING,
          l_len             LIKE type_file.num5,
          i                 LIKE type_file.num5
   DEFINE l_faj06           LIKE faj_file.faj06     #MOD-8C0184 add 
    
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_faa.faa04 = 'N' THEN #no:5423參數faa04可選擇資產序號是否可空白
      IF cl_null(g_faj.faj01) THEN
         CALL cl_err('',-400,0)
         RETURN
      END IF
   END IF
 
   IF g_faj.faj43 NOT MATCHES '[01]' THEN
       CALL cl_err('',"afa-002",0)    #No.MOD-480005
      RETURN
   END IF
   
   #-----No:FUN-AB0088-----
   IF g_faa.faa31 = 'Y' THEN
      IF g_faj.faj432 NOT MATCHES '[01]' THEN
         CALL cl_err('',"afa-002",0)
         RETURN
      END IF
   END IF
   #-----No:FUN-AB0088 END-----

   IF g_aza.aza31 = 'Y' THEN                                                                                                   
     #CALL s_auno('','4','') RETURNING l_newno2,l_faj06  #No.FUN-C0082   Mark
      CALL s_auno1('','4','') RETURNING l_newno2,l_faj06 #No.FUN-CA0082   Add
   END IF
 
   LET g_before_input_done = FALSE
   CALL i100_set_entry('a')
   LET g_before_input_done = TRUE
 
   INPUT l_newno1,l_newno3,l_newno2,l_newno4 WITHOUT DEFAULTS FROM faj01,faj021,faj02,faj022  #MOD-8C0184
 
      BEFORE FIELD faj01
         IF g_faa.faa03 = 'Y' THEN         #自動編號
            SELECT faa031 INTO g_faa.faa031 FROM faa_file      #No.MOD-8C0184
            IF SQLCA.sqlcode THEN
               LET g_faa.faa031 = 0
            END IF
            LET l_faa031 = g_faa.faa031 + 1
            LET l_newno1 = l_faa031 USING '&&&&&&&&&&'
            DISPLAY l_newno1 TO faj01
         END IF
 
      AFTER FIELD faj01
         IF g_faa.faa04 = 'N' THEN
            IF cl_null(l_newno1) THEN      #不可空白
               NEXT FIELD faj01
            END IF
         END IF
 
         #--->財編是否預設與序號一致
         IF g_faa.faa06 = 'Y' THEN
            LET l_newno2 = l_newno1
            DISPLAY l_newno2 TO faj02
         END IF
 
         SELECT COUNT(*) INTO g_cnt FROM faj_file
          WHERE faj01 = l_newno1
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno1,-239,0)
            NEXT FIELD faj01
         END IF
 
         IF NOT cl_null(l_newno1) THEN
            LET l_str = l_newno1 
            LET l_len = l_str.getlength()
           #序號需為10碼
            IF l_len != 10 THEN
               CALL cl_err(g_faj.faj01,'afa-210',0)
               NEXT FIELD faj01
            END IF
            FOR i = 1 TO l_len
                IF l_str.substring(i,i) NOT MATCHES '[0123456789]' THEN
#                   CALL cl_err(g_faj.faj01,'apy-020',0)  #CHI-B40058
                   CALL cl_err(g_faj.faj01,'afa-205',0)   #CHI-B40058
                   NEXT FIELD faj01
                END IF
            END FOR
         END IF
 
      AFTER FIELD faj02
         IF g_faa.faa05 = 'N' THEN
            IF cl_null(l_newno2) THEN
               NEXT FIELD faj01
            END IF
         END IF
      #  IF cl_null(g_faj.faj93) THEN               #FUN-9A0036 mark 
      #     LET g_faj.faj93 = g_faj.faj02           #FUN-9A0036 mark 
      #  END IF                                     #FUN-9A0036 mark
 
      AFTER FIELD faj021
         IF l_newno3 NOT MATCHES '[123]' THEN
            NEXT FIELD faj021
         END IF
 
         #-->財編與序號一致不可輸入(23)
         IF g_faa.faa06 = 'Y' AND l_newno3 MATCHES '[23]' THEN
            CALL cl_err(l_newno3,'afa-304',0)
            NEXT FIELD faj022
         END IF
 
         #-->配件或費用其財編一定要存在
         IF l_newno3 MATCHES '[23]' THEN
            SELECT COUNT(*) INTO g_cnt FROM faj_file
             WHERE faj02 = l_newno2
               AND faj021 = '1'
            IF  g_cnt < 0 THEN
               CALL cl_err(l_newno2,'afa-300',0)
               NEXT FIELD faj02
            END IF
         END IF
 
 
      BEFORE FIELD faj022
         #-->自動預設附號
         IF l_newno3 MATCHES '[23]' THEN  #為附件
            CALL s_afamxno(l_newno2,l_newno3) RETURNING l_mxno
           #MOD-A50116---modify---start---
           #LET l_newno4 = l_mxno
           #DISPLAY l_newno4 TO faj022
            IF cl_null(l_mxno) THEN
               NEXT FIELD faj021
            ELSE
               LET l_newno4 = l_mxno
               DISPLAY l_newno4 TO faj022
            END IF
           #MOD-A50116---modify---end---
         ELSE
            IF l_newno3 ='1' THEN  #主件新增
               SELECT COUNT(*) INTO g_cnt FROM faj_file
                WHERE faj02 = l_newno2
                  AND faj022 = l_newno4   #MOD-920181
               IF g_cnt > 0 THEN
                  CALL cl_err(l_newno2,'afa-307',0)
                  NEXT FIELD faj02
               END IF
 
               IF NOT cl_null(l_newno2) THEN   #MOD-730111
                  SELECT COUNT(*) INTO g_cnt FROM fak_file
                   WHERE fak02 = l_newno2
                  IF g_cnt > 0 THEN
                     CALL cl_err(l_newno2,'afa-301',0)
                     NEXT FIELD faj02
                  END IF
               END IF   #MOD-730111
            END IF
         END IF
 
      AFTER FIELD faj022
         IF cl_null(l_newno4) THEN
            LET l_newno4 = ' '
         END IF
         SELECT COUNT(*) INTO g_cnt FROM faj_file
          WHERE faj02 = l_newno2
            AND faj022 = l_newno4
         IF g_cnt > 0 THEN
            LET g_msg = l_newno2,l_newno4 CLIPPED
            CALL cl_err(g_msg,-239,0)
            NEXT FIELD faj01
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_faj.faj01,g_faj.faj02
      RETURN
   END IF
 
   IF cl_null(l_newno1) THEN
      LET l_newno1 = ' '
   END IF
 
   IF cl_null(l_newno4) THEN
      LET l_newno4 = ' '
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM faj_file
    WHERE faj02 = l_newno2
      AND faj022= l_newno4
   IF g_cnt > 0 THEN
      LET g_msg = l_newno2,l_newno4 CLIPPED
      CALL cl_err(g_msg,-239,0)
      RETURN
   END IF
 
   LET l_faj.* = g_faj.*
   LET l_faj.faj01 = l_newno1  #資料鍵值
   LET l_faj.faj02 = l_newno2
   LET l_faj.faj021 = l_newno3
   LET l_faj.faj022 = l_newno4
 
   IF g_aza.aza31 = 'Y' THEN                                                                                    
      LET l_faj.faj06 = l_faj06                                                                                
   END IF                  
   
   IF l_faj.faj022 != ' ' THEN
      LET l_faj.faj021 = '2'
   END IF
 
   LET l_faj.faj43 = '0'
   LET l_faj.faj432 = '0'   #No:FUN-AB0088
   LET l_faj.faj201 = '0'
   LET l_faj.faj107 = 0          #No.TQC-7B0056
   LET l_faj.faj1072 = 0   #No:FUN-AB0088
   LET l_faj.fajconf = 'N'
   LET l_faj.fajuser = g_user    #資料所有者
   LET l_faj.fajgrup = g_grup    #資料所有者所屬群
   LET l_faj.fajmodu = NULL      #資料修改日期
   LET l_faj.fajdate = g_today   #資料建立日期
 
 
   IF cl_null(l_faj.faj331) THEN LET l_faj.faj331 = 0 END IF
   IF cl_null(l_faj.faj3312) THEN LET l_faj.faj3312 = 0 END IF   #No:FUN-AB0088
   IF cl_null(l_faj.faj681) THEN LET l_faj.faj681 = 0 END IF
 
   LET l_faj.fajoriu = g_user      #No.FUN-980030 10/01/04
   LET l_faj.fajorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO faj_file VALUES (l_faj.*)
 
   LET g_msg = l_newno1,l_newno2 CLIPPED
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","faj_file",l_faj.faj01,"",SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660136
   ELSE
      MESSAGE 'ROW(',g_msg,') O.K'
      LET l_oldno1 = g_faj.faj01
      LET l_oldno2 = g_faj.faj02
      LET l_oldno3 = g_faj.faj021
      LET l_oldno4 = g_faj.faj022
      LET g_faj.faj01 = l_newno1
      LET g_faj.faj02 = l_newno2
      LET g_faj.faj021 = l_newno3
      LET g_faj.faj022 = l_newno4
 
      SELECT faj_file.* INTO g_faj.* FROM faj_file
       WHERE faj01  = l_newno1
         AND faj02  = l_newno2
         AND faj021 = l_newno3
         AND faj022 = l_newno4
 
      CALL i100_u()
      #FUN-C30027---begin
      #SELECT faj_file.* INTO g_faj.* FROM faj_file
      # WHERE faj01 = l_oldno1
      #   AND faj02 = l_oldno2
      #   AND faj021 = l_oldno3
      #   AND faj022 = l_oldno4
      #FUN-C30027---end
   END IF
 
   #-------- 更新系統參數檔之已用編號 ----------
   UPDATE faa_file SET faa031 = l_newno1
    WHERE faa03 = 'Y'                                                      #MOD-CB0243 add
    IF SQLCA.sqlcode THEN           #No.MOD-4A0186
      CALL cl_err3("upd","faa_file",l_oldno1,l_oldno2,SQLCA.sqlcode,"","",1)  #No.FUN-660136
   END IF
 
   CALL i100_show()
   CALL i100_b_fill()    #No.FUN-CB0080 Add
END FUNCTION
 
FUNCTION i100_y()       # confirm when g_faj.fajconf='N' (Turn to 'Y')
 
    IF cl_null(g_faj.faj02) THEN     #No.MOD-4B0094
      RETURN
   END IF
 
   SELECT * INTO g_faj.* FROM faj_file
    WHERE faj02 = g_faj.faj02
      AND faj022 = g_faj.faj022
 
   IF g_faj.fajconf = 'Y' THEN
      RETURN
   END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT faa09 FROM faa_file WHERE faa00='0'"
   PREPARE faa09_p FROM g_sql
   EXECUTE faa09_p INTO g_faa.faa09
#FUN-B50090 add -end--------------------------
   IF g_faj.faj37 ='Y' THEN  
      IF g_faj.faj26 <= g_faa.faa09 THEN    
         CALL cl_err('','afa-517',1)      
         RETURN            
      END IF 
      #-----No:FUN-AB0088-----
      IF g_faa.faa31 = 'Y' THEN
         IF g_faj.faj262 <= g_faa.faa092 THEN   #No:FUN-B60140 将faa09改为faa092
            CALL cl_err('','afa-517',1)
            RETURN
         END IF
      END IF
      #-----No:FUN-AB0088 END-----              
   END IF               
   IF NOT cl_confirm('axm-108') THEN
      RETURN
   END IF
 
  #-MOD-A70075-add-
   IF g_faj.faj23 = '1' THEN
      CALL i100_chkdept(g_faj.faj53,g_aza.aza81) RETURNING g_errno 
      IF NOT cl_null(g_errno) THEN
         CALL cl_err3(" "," ",g_faj.faj53,g_faj.faj53,g_errno,"","",1)  
         RETURN 
      END IF
      CALL i100_chkdept(g_faj.faj54,g_aza.aza81) RETURNING g_errno
      IF NOT cl_null(g_errno) THEN
         CALL cl_err3(" "," ",g_faj.faj54,g_faj.faj54,g_errno,"","",1)  
         RETURN 
      END IF
      CALL i100_chkdept(g_faj.faj55,g_aza.aza81) RETURNING g_errno
      IF NOT cl_null(g_errno) THEN
         CALL cl_err3(" "," ",g_faj.faj55,g_faj.faj55,g_errno,"","",1)  
         RETURN 
      END IF
    ##-----No:FUN-AB0088 Mark-----
    # CALL i100_chkdept(g_faj.faj531,g_aza.aza82) RETURNING g_errno
    # IF NOT cl_null(g_errno) THEN
    #    CALL cl_err3(" "," ",g_faj.faj531,g_faj.faj531,g_errno,"","",1)
    #    RETURN
    # END IF
    # CALL i100_chkdept(g_faj.faj541,g_aza.aza82) RETURNING g_errno
    # IF NOT cl_null(g_errno) THEN
    #    CALL cl_err3(" "," ",g_faj.faj541,g_faj.faj541,g_errno,"","",1)
    #    RETURN
    # END IF
    # CALL i100_chkdept(g_faj.faj551,g_aza.aza82) RETURNING g_errno
    # IF NOT cl_null(g_errno) THEN
    #    CALL cl_err3(" "," ",g_faj.faj551,g_faj.faj551,g_errno,"","",1)
    #    RETURN
    # END IF
    ##-----No:FUN-AB0088 Mark END-----
   END IF
      #-----No:FUN-AB0088-----
      IF g_faj.faj232 = '1' THEN
         CALL i100_chkdept2(g_faj.faj531,g_faa.faa02c) RETURNING g_errno
         IF NOT cl_null(g_errno) THEN
            CALL cl_err3(" "," ",g_faj.faj531,g_faj.faj531,g_errno,"","",1)
            RETURN
         END IF
         CALL i100_chkdept2(g_faj.faj541,g_faa.faa02c) RETURNING g_errno
         IF NOT cl_null(g_errno) THEN
            CALL cl_err3(" "," ",g_faj.faj541,g_faj.faj541,g_errno,"","",1)
            RETURN
         END IF
         CALL i100_chkdept2(g_faj.faj551,g_faa.faa02c) RETURNING g_errno
         IF NOT cl_null(g_errno) THEN
            CALL cl_err3(" "," ",g_faj.faj551,g_faj.faj551,g_errno,"","",1)
            RETURN
         END IF
      END IF
     #----No:FUN-AB0088 END-----

  #-MOD-A70075-end-
   BEGIN WORK
   LET g_success = 'Y'
 
   UPDATE faj_file SET fajconf = 'Y'
    WHERE faj02 = g_faj.faj02
      AND faj01 = g_faj.faj01
      AND faj022 = g_faj.faj022
    IF STATUS THEN          #No.MOD-4A0186
      CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","upd fajconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
 
   ##資產狀態應為'1'資本化
  IF g_faj.faj37 = 'Y' AND   #FUN-5B0099
    (g_faj.faj43 <> '4' OR g_faj.faj31 <> g_faj.faj33) THEN   #FUN-5B0099
      UPDATE faj_file SET faj43 = '1',
                          faj201 = '1'
       WHERE faj02 = g_faj.faj02
         AND faj01 = g_faj.faj01
         AND faj022 = g_faj.faj022
       IF STATUS THEN    #No.MOD-4A0186
         CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","upd faj43",1)  #No.FUN-660136
         LET g_success = 'N'
      ELSE
         LET g_faj.faj43 = '1'
         LET g_faj.faj201 = '1'
         DISPLAY BY NAME g_faj.faj43,g_faj.faj201   #MOD-860048 add g_faj.faj201

      END IF
   END IF
  #---------------MOD-C90160-----------------(S)
   IF g_faj.faj31 = g_faj.faj33 OR
      (g_faj.faj30 = 0 AND g_faj.faj28 <> '0') THEN
      UPDATE faj_file SET faj43 = '4'
       WHERE faj02 = g_faj.faj02
         AND faj01 = g_faj.faj01
         AND faj022 = g_faj.faj022
      IF STATUS THEN
         CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","upd faj43",1)
         LET g_success = 'N'
      ELSE
         LET g_faj.faj43 = '4'
         DISPLAY BY NAME g_faj.faj43
      END IF
   END IF
   IF g_faj.faj66 = g_faj.faj68 OR
      (g_faj.faj65 = 0 AND g_faj.faj61 <> '0') THEN
      UPDATE faj_file SET faj201 = '4'
       WHERE faj02 = g_faj.faj02
         AND faj01 = g_faj.faj01
         AND faj022 = g_faj.faj022
      IF STATUS THEN
         CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","upd faj201",1)
         LET g_success = 'N'
      ELSE
         LET g_faj.faj201 = '4'
         DISPLAY BY NAME g_faj.faj201
      END IF
   END IF
  #---------------MOD-C90160-----------------(E)
   #-----No:FUN-AB0088-----
   IF g_faa.faa31 = 'Y' THEN
      IF g_faj.faj37 = 'Y' AND
        (g_faj.faj432 <> '4' OR g_faj.faj312 <> g_faj.faj332) THEN
         UPDATE faj_file SET faj432 = '1'
          WHERE faj02 = g_faj.faj02
            AND faj01 = g_faj.faj01
            AND faj022 = g_faj.faj022
         IF STATUS THEN
            CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","upd faj432",1)
            LET g_success = 'N'
         ELSE
            LET g_faj.faj432 = '1'
            DISPLAY BY NAME g_faj.faj432
         END IF
      END IF
     #---------------MOD-C90160-----------------(S)
      IF g_faj.faj312 = g_faj.faj332 OR
        (g_faj.faj302 = 0 AND g_faj.faj282 <> '0') THEN
         UPDATE faj_file SET faj432 = '4'
          WHERE faj02 = g_faj.faj02
            AND faj01 = g_faj.faj01
            AND faj022 = g_faj.faj022
         IF STATUS THEN
            CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","upd faj432",1)
            LET g_success = 'N'
         ELSE
            LET g_faj.faj432 = '4'
            DISPLAY BY NAME g_faj.faj432
         END IF
      END IF
     #---------------MOD-C90160-----------------(E)
   END IF
   #-----No:FUN-AB0088 END-----

   IF g_success = 'Y' THEN
      LET g_faj.fajconf = 'Y'
      COMMIT WORK
      DISPLAY BY NAME g_faj.fajconf
   ELSE
      LET g_faj.fajconf = 'N'
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
#-MOD-A70075-add- 
FUNCTION i100_chkdept(p_accno,p_bookno)
   DEFINE  p_accno      LIKE aag_file.aag01     
   DEFINE  p_bookno     LIKE aza_file.aza81      
   DEFINE  p_errno      LIKE zaa_file.zaa01  
   DEFINE  l_aag05      LIKE aag_file.aag05    
   
   LET l_aag05 = ''   
   LET g_errno = ''   
   SELECT aag05 INTO l_aag05 
     FROM aag_file
    WHERE aag01 = p_accno AND aag00 = p_bookno 
  #IF l_aag05 = 'Y' THEN                          #MOD-BB0018 mark
   IF l_aag05 = 'Y' AND g_faj.faj28 <> '0' THEN   #MOD-BB0018
      CALL s_chkdept(g_aaz.aaz72,p_accno,g_faj.faj24,p_bookno) RETURNING g_errno
      RETURN g_errno
   END IF
   RETURN p_errno    #FUN-9A0036
END FUNCTION
#-MOD-A70075-end- 

#-----No:FUN-AB0088-----
FUNCTION i100_chkdept2(p_accno,p_bookno)
   DEFINE  p_accno      LIKE aag_file.aag01
   DEFINE  p_bookno     LIKE aza_file.aza81
   DEFINE  p_errno      LIKE zaa_file.zaa01
   DEFINE  l_aag05      LIKE aag_file.aag05

   LET p_errno = ' '
   LET l_aag05 = ''
   SELECT aag05 INTO l_aag05
     FROM aag_file
    WHERE aag01 = p_accno AND aag00 = p_bookno
  #IF l_aag05 = 'Y' THEN                           #MOD-BB0018 mark
   IF l_aag05 = 'Y' AND g_faj.faj282 <> '0' THEN   #MOD-BB0018
      CALL s_chkdept(g_aaz.aaz72,p_accno,g_faj.faj242,p_bookno) RETURNING p_errno
   END IF
   RETURN p_errno
END FUNCTION
#-----No:FUN-AB0088 END-----

FUNCTION i100_z()
   DEFINE l_cnt    LIKE type_file.num5   #MOD-8C0190 add
 
   SELECT * INTO g_faj.* FROM faj_file
    WHERE faj02 = g_faj.faj02
      AND faj022 = g_faj.faj022
 
   IF g_faj.fajconf = 'N' THEN
      RETURN
   END IF
 
  #-----------------------MOD-C90160-----------------(S)
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM fan_file
    WHERE fan01 = g_faj.faj02
      AND fan02 = g_faj.faj022
      AND fan03 = g_faj.faj57
      AND fan04 = g_faj.faj571
      AND fan041 IN ('0','1','2')
      AND fan05 = g_faj.faj23
      AND fan06 = g_faj.faj80
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
  #-----------------------MOD-C90160-----------------(E)
   # #-->依資產是否直接資本化NO:7173拿掉  #No.MOD-490010 將 No.7173 mark取消
 
  #IF g_faj.faj37 = 'N' AND g_faj.faj43 != '0' THEN    #MOD-C90160 mark
   IF g_faj.faj37 = 'N' AND g_faj.faj43 != '0' AND     #MOD-C90160 add
      (g_faj.faj43 <> '4' AND l_cnt > 0 ) THEN         #MOD-C90160 add
      CALL cl_err(g_faj.faj02,'afa-315',0)
      RETURN
   END IF
 
  #IF g_faj.faj37 = 'Y' AND g_faj.faj43 NOT MATCHES'[01]' THEN    #MOD-C90160 mark
   IF g_faj.faj37 = 'Y' AND g_faj.faj43 NOT MATCHES'[01]' AND     #MOD-C90160 add
      (g_faj.faj43 <> '4' AND l_cnt > 0 ) THEN                    #MOD-C90160 add
      CALL cl_err(g_faj.faj02,'afa-315',0)
      RETURN
   END IF

   #-----No:FUN-AB0088-----
   IF g_faa.faa31 = 'Y' THEN
     #IF g_faj.faj37 = 'N' AND g_faj.faj432 != '0' THEN     #MOD-C90160 mark
      IF g_faj.faj37 = 'N' AND g_faj.faj432 != '0' AND      #MOD-C90160 add
         (g_faj.faj432 <> '4' AND l_cnt > 0 ) THEN          #MOD-C90160 add
         CALL cl_err(g_faj.faj02,'afa-315',0)
         RETURN
      END IF

     #IF g_faj.faj37 = 'Y' AND g_faj.faj432 NOT MATCHES'[01]' THEN    #MOD-C90160 mark
      IF g_faj.faj37 = 'Y' AND g_faj.faj432 NOT MATCHES'[01]' AND     #MOD-C90160 add
         (g_faj.faj432 <> '4' AND l_cnt > 0 ) THEN                    #MOD-C90160 add
         CALL cl_err(g_faj.faj02,'afa-315',0)
         RETURN
      END IF
   END IF
   #-----No:FUN-AB0088 END-----
 
   IF g_faj.faj42 NOT MATCHES'[01]' THEN
      CALL cl_err(g_faj.faj02,'afa-316',0)
      RETURN
   END IF

#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT faa09 FROM faa_file WHERE faa00='0'"
   PREPARE faa09_p1 FROM g_sql
   EXECUTE faa09_p1 INTO g_faa.faa09
#FUN-B50090 add -end--------------------------
   #-----No:FUN-AB0088-----
   IF g_faa.faa31 = 'Y' THEN
      IF g_faj.faj262 <= g_faa.faa092 THEN     #No:FUN-B60140  将faa09改为faa092
         CALL cl_err('','afa-517',0)
         RETURN
      END IF
   END IF
   #-----No:FUN-AB0088 END-----
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM fap_file
    WHERE fap02 = g_faj.faj02
      AND fap021= g_faj.faj022
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN
      CALL cl_err(g_faj.faj02,'afa-192',0)
      RETURN
   END IF
 
  #-MOD-AA0151-add-
   IF g_faj.faj26 <= g_faa.faa09 THEN
      CALL cl_err('','afa-517',0)
      RETURN
   END IF
  #-MOD-AA0151-end-

  #-MOD-B30625-add-
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt 
     FROM fca_file
    WHERE fca03  = g_faj.faj02
      AND fca031 = g_faj.faj022
      AND fca15  = 'N'
    IF l_cnt > 0 THEN
       CALL cl_err(g_faj.faj02,'afa-097',0)
       RETURN
    END IF
  #-MOD-B30625-end-

   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
  #IF g_faj.faj37 = 'Y' AND g_faj.faj43 MATCHES '[1]' THEN            #MOD-C90160 mark
   IF g_faj.faj37 = 'Y' AND g_faj.faj43 MATCHES '[14]' THEN           #MOD-C90160 add
      UPDATE faj_file SET faj43 = '0',
                          faj201 = '0'
       WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022
         AND faj02 = g_faj.faj02
         AND faj022 = g_faj.faj022
       IF STATUS  THEN              #No.MOD-4A0186
         CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","upd faj",1)  #No.FUN-660136
         LET g_success = 'N'
      ELSE
         LET g_faj.faj43 = '0'
         LET g_faj.faj201 = '0'
         DISPLAY BY NAME g_faj.faj43,g_faj.faj201   #MOD-860048 add g_faj.faj201
      END IF
   END IF

   #-----No:FUN-AB0088-----
   IF g_faa.faa31 = 'Y' THEN
     #IF g_faj.faj37 = 'Y' AND g_faj.faj432 MATCHES '[1]' THEN        #MOD-C90160 mark
      IF g_faj.faj37 = 'Y' AND g_faj.faj432 MATCHES '[14]' THEN       #MOD-C90160 add
         UPDATE faj_file SET faj432 = '0'
          WHERE faj01 = g_faj.faj01
            AND faj02 = g_faj.faj02
            AND faj022 = g_faj.faj022
          IF STATUS  THEN
            CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","upd faj",1)
            LET g_success = 'N'
         ELSE
            LET g_faj.faj432 = '0'
            DISPLAY BY NAME g_faj.faj432
         END IF
      END IF
   END IF
   #-----No:FUN-AB0088 END-----
 
   UPDATE faj_file SET fajconf = 'N'
    WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022
      AND faj02 = g_faj.faj02
      AND faj022 = g_faj.faj022
 
   IF g_success = 'Y' THEN
      LET g_faj.fajconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_faj.fajconf
   ELSE
      LET g_faj.fajconf='Y'
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION i100_4()
   DEFINE l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(80)
 
   IF g_faa.faa04='N' THEN #no:5423參數faa04可選擇資產序號是否可空白
      IF cl_null(g_faj.faj01) THEN
         CALL cl_err('',-400,0)
         RETURN
      END IF
   END IF
 
   LET l_cmd = "afaq100 '",g_faj.faj01,"'"  # 料件編號
   CALL cl_cmdrun(l_cmd)
 
END FUNCTION
 
FUNCTION i100_5()
   DEFINE l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(80)
 
   IF g_faa.faa04='N' THEN #no:5423參數faa04可選擇資產序號是否可空白
      IF cl_null(g_faj.faj01) THEN
         CALL cl_err('',-400,0)
         RETURN
      END IF
   END IF
 
   LET l_cmd = "afaq101 '",g_faj.faj01,"'"  # 料件編號
 
   CALL cl_cmdrun(l_cmd)
 
END FUNCTION
 
FUNCTION i100_out()
   DEFINE l_i       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_name    LIKE type_file.chr20,        # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
          l_za05    LIKE za_file.za05,           #No.FUN-680070 VARCHAR(40)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sr        RECORD LIKE faj_file.*
   DEFINE l_fam05   LIKE fam_file.fam05         #No.MOD-790134
   DEFINE l_fam05_1 LIKE fam_file.fam05         #No.MOD-790134
   DEFINE l_str     LIKE type_file.chr20        #No.MOD-790134
   DEFINE l_fab02   LIKE fab_file.fab02         #No.FUN-850146
   DEFINE l_pmc03   LIKE pmc_file.pmc03         #No.FUN-850146
   DEFINE l_pmc03_1 LIKE pmc_file.pmc03         #No.FUN-850146
   DEFINE l_gem02   LIKE gem_file.gem02         #No.FUN-850146
   DEFINE l_gem02_1 LIKE gem_file.gem02         #No.FUN-850146
   DEFINE l_gen02   LIKE gen_file.gen02         #MOD-890075 add

  #MOD-D30240-start-add
   IF cl_null(g_wc) THEN                                                                             
      LET g_wc = "faj01='",g_faj.faj01,"' AND faj02='",g_faj.faj02,"' AND faj022 ='",g_faj.faj022,"' " 
   END IF                                                                                                      
  #MOD-D30240-end-add 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afai100'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 98 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   CALL cl_del_data(l_table)                                   #No.MOD-790134
   CALL cl_del_data(l_table1)                                                                                                       
   CALL cl_del_data(l_table2)                                                                                                       
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                                                               
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                                                               
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)" #CHI-970002 add ?                                                             
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM                                                                              
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
               " VALUES(?,?,?,?)"                                                                                                   
   PREPARE insert_prep1 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                 
               " VALUES(?,?,?,?)"                                                                                                   
   PREPARE insert_prep2 FROM g_sql                                                                                                  
   IF STATUS THEN
      CALL cl_err('insert_prep2',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_sql="SELECT * FROM faj_file WHERE ",g_wc CLIPPED      # 組合出 SQL 指令
 
   PREPARE i100_p1 FROM g_sql                # RUNTIME 編譯
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,0)
      RETURN
   END IF
 
   DECLARE i100_co CURSOR FOR i100_p1
 
   FOREACH i100_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      CALL i100_faj03(sr.faj03) RETURNING g_c1
 
      CALL i100_faj43(sr.faj43) RETURNING g_m1
      LET l_str = sr.faj02
      LET l_str[11,14]=sr.faj022
 
      DECLARE memo_c CURSOR FOR
        SELECT fam05 FROM fam_file
          WHERE fam00='1' AND fam01=l_str AND fam04='0'
      LET l_fam05=''
      FOREACH memo_c INTO l_fam05
         EXECUTE insert_prep1 USING '1',l_str,'0',l_fam05 #MOD-960275  
      END FOREACH
 
      DECLARE memo_c2 CURSOR FOR
         SELECT fam05 FROM fam_file
           WHERE fam00='1' AND fam01=l_str AND fam04='1'
      LET l_fam05_1=''
      FOREACH memo_c2 INTO l_fam05_1
         EXECUTE insert_prep2 USING '1',l_str,'1',l_fam05_1 #MOD-960275  
      END FOREACH
 
      #清空變數值
      LET l_fab02 = ''     #MOD-890075 add
      LET l_pmc03 = ''     #MOD-890075 add
      LET l_pmc03_1 = ''   #MOD-890075 add
      LET l_gem02 = ''     #MOD-890075 add
      LET l_gem02_1 = ''   #MOD-890075 add
      LET l_gen02 = ''     #MOD-890075 add
 
      SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01 = sr.faj04   #MOD-890075 g_faj->sr
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.faj11   #MOD-890075 g_faj->sr
      SELECT pmc03 INTO l_pmc03_1 FROM pmc_file WHERE pmc01 = sr.faj10 #MOD-890075 g_faj->sr
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.faj24   #MOD-890075 g_faj->sr
      SELECT gem02 INTO l_gem02_1 FROM gem_file WHERE gem01 = sr.faj20 #MOD-890075 g_faj->sr
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.faj19   #MOD-890075 add
 
      EXECUTE insert_prep USING
         sr.faj01,sr.faj02,sr.faj021,sr.faj022,sr.faj03,sr.faj04,
         sr.faj05,sr.faj06,sr.faj061,sr.faj07,sr.faj071,sr.faj08,
         sr.faj09,sr.faj10,sr.faj11,sr.faj12,sr.faj13,sr.faj14,
         sr.faj141,sr.faj15,sr.faj16,sr.faj17,sr.faj18,sr.faj19,
         sr.faj20,sr.faj21,sr.faj22,sr.faj23,sr.faj24,sr.faj25,
         sr.faj26,sr.faj27,sr.faj28,sr.faj29,sr.faj30,sr.faj31,
         sr.faj32,sr.faj33,sr.faj331,sr.faj35,sr.faj36,sr.faj43, #CHI-970002 add faj331
         sr.faj44,sr.faj45,sr.faj451,sr.faj46,sr.faj461,sr.faj47,
         sr.faj471,sr.faj48,sr.faj49,sr.faj51,sr.faj52, #No.FUN-840006 去掉sr.faj50
         sr.faj58,sr.faj59,l_str,             #MOD-960275    
         l_fab02,l_pmc03,l_pmc03_1,l_gem02,l_gem02_1,l_gen02   #No.FUN-850146   #MOD-890075 add l_gen02
   END FOREACH
 
 
   CLOSE i100_co
   ERROR ""
 
    LET g_str = '' #MOD-960275     
   IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'faj01,faj02,faj021,faj022,faj03,faj43,faj04,faj05,faj06,faj061,
                           faj07,faj071,faj08,faj09,faj10,faj11,faj12,faj17,faj171,faj18,faj13,
                           faj14,faj15,faj16,faj19,faj20,faj21,faj22,faj23,faj24,faj25,faj26,
                           faj27,faj28,faj29,faj30,faj31,faj32,faj203,faj33,faj331,faj34,faj35, #CHI-970002 add faj331
                           faj36,faj141,faj58,faj59,faj44,faj45,faj451,faj46,faj461,faj47,
                            faj471,faj48,faj49,faj51,faj52')    #No.FUN-840006 去掉faj50字段
   RETURNING g_str       #MOD-960275                                                                                                              
   END IF                 
   LET g_str = g_str,";",'1',";",'0',";",'1'       
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",                                                            
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                           
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED                                                                
   CALL cl_prt_cs3('afai100','afai100',g_sql,g_str)
 
END FUNCTION

 
FUNCTION i100_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("faj01,faj02",TRUE)   #MOD-580279
       CALL cl_set_comp_entry("fajud04",TRUE)   #darcy:2022/10/10 add
   END IF
 
   #FUN-BB0122----being add
   IF g_action ='1' THEN
      CALL cl_set_comp_entry("faj1012,faj1022,faj103,faj104,faj1412",TRUE) #FUN-BB0131 add faj1412
   END IF 
   #FUN-BB0122----end  add
   IF INFIELD(faj022) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj022",TRUE)
   END IF
 
   IF INFIELD(faj43) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj23,faj24,faj27,faj28,faj29,faj30,faj31,faj32,faj203,faj205,faj33,faj331",TRUE) # MOD-890254 #CHI-970002 add faj331
   END IF
 
   IF INFIELD(faj28) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj29,faj30,faj31,faj32,faj203,faj205,faj33,faj331,faj34,faj71",TRUE)  #No.FUN-7A0079 #MOD-890254 #CHI-970002 add faj331
      CALL cl_set_comp_entry("faj53,faj531,faj54,faj541",TRUE)  #MOD-910119 add
   END IF
 
   IF INFIELD(faj34) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj35,faj36",TRUE)
   END IF

  #-----No:FUN-AB0088-----
   IF INFIELD(faj432) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj232,faj242,faj272,faj282,faj292,faj302,faj312,faj322,faj2032,faj332,faj3312",TRUE)
   END IF

   IF INFIELD(faj282) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj292,faj302,faj312,faj322,faj2032,faj332,faj3312,faj342",TRUE)
      CALL cl_set_comp_entry("faj531,faj541",TRUE)
   END IF

   IF INFIELD(faj342) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj352,faj362",TRUE)
   END IF
   #-----No:FUN-AB0088 END-----
 
   IF INFIELD(faj71) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj72,faj73",TRUE)
   END IF
 
   IF INFIELD(faj61) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj63,faj64,faj65,faj109,faj66,faj67,faj68,faj681",TRUE)#No.TQC-690099 add faj109 #CHI-970002 add faj681
   END IF
 
   IF INFIELD(faj28) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj106",TRUE)
   END IF

   #-----No:FUN-AB0088-----
   IF INFIELD(faj282) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj1062",TRUE)
   END IF
   #-----No:FUN-AB0088 END-----
 
   IF INFIELD(faj61) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("faj110",TRUE)
   END IF
 
  IF p_cmd = 'o' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("faj38,faj39,faj40,faj41,faj42,faj42,faj421,faj422,faj423,faj56",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_cmd = 'a' AND g_faa.faa03 = 'Y' THEN
      CALL cl_set_comp_entry("faj01",FALSE)
   END IF
   IF p_cmd = 'u' AND g_chkey MATCHES'[Nn]' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("faj01,faj02,faj022",FALSE)  #MOD-550059
   END IF
 
   #FUN-BB0122----being add
   IF g_action <> '1' THEN
      CALL cl_set_comp_entry("faj1012,faj1022,faj103,faj104,faj1412",FALSE) #FUN-BB0131 add faj1412
   END IF 
   #FUN-BB0122----end  add
  #-MOD-AB0118-add-
   IF g_faa.faa03 = 'Y' AND g_faa.faa06 = 'Y' THEN                           
       CALL cl_set_comp_entry("faj02,faj022",FALSE)  
   END IF
  #-MOD-AB0118-end-

  #IF INFIELD(faj022) THEN                        #MOD-AB0001 mark
   IF g_faj.faj021 = '1' THEN                     #MOD-AB0001
      CALL cl_set_comp_entry("faj022",FALSE)
   END IF
 
   IF INFIELD(faj43) OR (NOT g_before_input_done) THEN
      IF g_faj.faj43 = '2' AND p_cmd = 'u' THEN
         CALL cl_set_comp_entry("faj23,faj24,faj27,faj28,faj29,faj30,faj31,faj32,faj203,faj205,faj33,faj331",TRUE) #MOD-890254 #CHI-970002 add faj331
      END IF
   END IF
 
   IF INFIELD(faj28) OR (NOT g_before_input_done) THEN
      IF g_faj.faj28 ='0' THEN   #NO:5153
         CALL cl_set_comp_entry("faj29,faj30,faj31,faj32,faj203,faj205,faj33,faj331,faj34,faj71",FALSE)  #No.FUN-7A0079 #MOD-890254 #CHI-970002 add faj331
     #   CALL cl_set_comp_entry("faj53,faj531,faj54,faj541",FALSE)  #MOD-910119 add
        #CALL cl_set_comp_entry("faj53,faj54",FALSE)    #No:FUN-AB0088 #MOD-910119 add  #MOD-D10167 mark
      ELSE                                              #MOD-D10167 add
         CALL cl_set_comp_entry("faj53,faj54",FALSE)    #MOD-D10167 add
      END IF
   END IF
 
   IF INFIELD(faj34) OR (NOT g_before_input_done) THEN
      IF g_faj.faj34 != 'Y' THEN
         CALL cl_set_comp_entry("faj35,faj36",FALSE)
      END IF
   END IF
 
   #-----No:FUN-AB0088-----
   IF INFIELD(faj432) OR (NOT g_before_input_done) THEN
      IF g_faj.faj432 = '2' AND p_cmd = 'u' THEN
         CALL cl_set_comp_entry("faj232,faj242,faj272,faj282,faj292,faj302,faj312,faj322,faj2032,faj332,faj3312",TRUE)
      END IF
   END IF

   IF INFIELD(faj282) OR (NOT g_before_input_done) THEN
      IF g_faj.faj282 ='0' THEN
         CALL cl_set_comp_entry("faj292,faj302,faj312,faj322,faj2032,faj332,faj3312,faj342",FALSE)
        #CALL cl_set_comp_entry("faj531,faj541",FALSE)                             #MOD-D10167  mark
      ELSE                                                                         #MOD-D10167  add
         CALL cl_set_comp_entry("faj531,faj541",FALSE)                             #MOD-D10167  add
      END IF
   END IF

   IF INFIELD(faj342) OR (NOT g_before_input_done) THEN
      IF g_faj.faj342 != 'Y' THEN
         CALL cl_set_comp_entry("faj352,faj362",FALSE)
      END IF
   END IF
   #-----No:FUN-AB0088 END-----

   IF INFIELD(faj71) OR (NOT g_before_input_done) THEN
      IF g_faj.faj71 != 'Y' THEN
         CALL cl_set_comp_entry("faj72,faj73",FALSE)
      END IF
   END IF
 
   IF INFIELD(faj61) OR (NOT g_before_input_done) THEN
      IF g_faj.faj61 = '0' THEN
         CALL cl_set_comp_entry("faj63,faj64,faj65,faj109,faj66,faj67,faj68,faj681",FALSE)#No.TQC-690099 add faj109 #CHI-970002 add faj681
      END IF
   END IF
 
   IF INFIELD(faj28) OR (NOT g_before_input_done) THEN
      IF g_aza.aza26 != '2' OR g_faj.faj28 != '4' THEN
         CALL cl_set_comp_entry("faj106",FALSE)
      END IF
   END IF

   #-----No:FUN-AB0088-----
   IF INFIELD(faj282) OR (NOT g_before_input_done) THEN
      IF g_aza.aza26 != '2' OR g_faj.faj282 != '4' THEN
         CALL cl_set_comp_entry("faj1062",FALSE)
      END IF
   END IF
   #-----No:FUN-AB0088 END-----
 
   IF INFIELD(faj61) OR (NOT g_before_input_done) THEN
      IF g_aza.aza26 != '2' OR g_faj.faj61 != '4' THEN
         CALL cl_set_comp_entry("faj110",FALSE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i100_faj53(p_char,p_bookno1)           #No.FUN-740026 
   DEFINE l_aagacti  LIKE aag_file.aagacti,
          l_aag02    LIKE aag_file.aag02,
          l_aag03    LIKE aag_file.aag03,   #No.FUN-B0053
          l_aag07    LIKE aag_file.aag07,   #No.FUN-B0053
          p_char     LIKE faj_file.faj53,
          p_bookno1  LIKE aag_file.aag00,        #No.FUN-740026
          p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   LET g_errno = " "
   #SELECT aag02,aagacti INTO l_aag02,l_aagacti                             #No.FUN-B10053
   SELECT aag02,aag07,aag03,aagacti INTO l_aag02,l_aag07,l_aag03,l_aagacti  #No.FUN-B10053
     FROM aag_file
    WHERE aag01=p_char
      AND aag00=p_bookno1    #No.FUN-740026 
   CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                 LET l_aag02 = NULL
                                 LET l_aagacti = NULL
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'    #No.FUN-B10053
        WHEN l_aag03 != '2'      LET g_errno = 'agl-201'    #No.FUN-B10053
        WHEN l_aagacti='N'       LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   RETURN(l_aag02)
 

 
END FUNCTION

FUNCTION i100_faj531(p_char,p_bookno2)       #No.FUN-740026
   DEFINE l_aagacti  LIKE aag_file.aagacti,
          l_aag02    LIKE aag_file.aag02,
          p_char     LIKE faj_file.faj53,
          p_bookno2  LIKE aag_file.aag00,    #No.FUN-740026    
          p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   LET g_errno = " "
   SELECT aag02,aagacti INTO l_aag02,l_aagacti
     FROM aag_file
    WHERE aag01=p_char
      AND aag00=p_bookno2        #No.FUN-740026 
 
   CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-996'
                                 LET l_aag02 = NULL
                                 LET l_aagacti = NULL
        WHEN l_aagacti='N'       LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   RETURN(l_aag02)
 
END FUNCTION

FUNCTION i100_set_comb()
   DEFINE comb_value STRING
   DEFINE comb_item  STRING
 
   LET comb_value = '0,1,2,3,4,5'
 
   CALL cl_getmsg('afa-392',g_lang) RETURNING comb_item
 
   CALL cl_set_combo_items('faj28',comb_value,comb_item)
   CALL cl_set_combo_items('faj282',comb_value,comb_item)   #No:FUN-AB0088
 
   CALL cl_set_combo_items('faj61',comb_value,comb_item)
 
END FUNCTION
 
FUNCTION i100_set_comments()
   DEFINE comm_value STRING
 
   CALL cl_getmsg('afa-391',g_lang) RETURNING comm_value
 
   CALL cl_set_comments('faj28',comm_value)
   CALL cl_set_comments('faj282',comm_value)   #No:FUN-AB0088

   CALL cl_set_comments('faj61',comm_value)
 
END FUNCTION
 
FUNCTION i100_set_no_required(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
   CALL cl_set_comp_required("faj01,faj02,faj22,faj55",FALSE)
  #IF g_aza.aza63 = 'Y' THEN
   IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
      CALL cl_set_comp_required("faj551",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i100_set_required(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
  #IF INFIELD(faj01) THEN                   #MOD-AB0001 mark 
      IF cl_null(g_faj.faj01) AND g_faa.faa04='N' THEN
         CALL cl_set_comp_required("faj01",TRUE)
      END IF
  #END IF                                   #MOD-AB0001 mark
 
  #IF INFIELD(faj02) THEN                   #MOD-AB0001 mark 
      IF cl_null(g_faj.faj02) AND g_faa.faa05 = "N" THEN
         CALL cl_set_comp_required("faj02",TRUE)
      END IF
  #END IF                                   #MOD-AB0001 mark
 
   IF INFIELD(faj021) THEN
      IF g_faj.faj021 != '1' AND cl_null(g_faj.faj022) THEN
         CALL cl_set_comp_required("faj021",TRUE)
      END IF
   END IF
 
   IF g_faa.faa20 != '2' THEN #MOD-AC0289 add
      IF INFIELD(faj55) THEN
         IF cl_null(g_faj.faj55) AND g_faj.faj28 <> '0' THEN
            CALL cl_set_comp_required("faj55",TRUE)
            CALL cl_err(g_faj.faj55,'afa-091',0)
         END IF
      END IF
 #    IF g_aza.aza63 = 'Y' THEN
      IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
         IF INFIELD(faj551) THEN
        #  IF cl_null(g_faj.faj551) AND g_faj.faj28 <> '0' THEN
           IF cl_null(g_faj.faj551) AND g_faj.faj282<> '0' THEN   #No:FUN-AB0088
               CALL cl_set_comp_required("faj551",TRUE)
               CALL cl_err(g_faj.faj551,'afa-091',0)
            END IF
         END IF
      END IF
   END IF #MOD-AC0289 add
 
END FUNCTION
 
FUNCTION i100_other()
  DEFINE l_faj01 LIKE faj_file.faj01
 
  IF s_shut(0) THEN RETURN END IF
  IF g_faj.faj01 IS NULL THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
  SELECT * INTO g_faj.* FROM faj_file WHERE faj01 = g_faj.faj01 AND faj02 = g_faj.faj02 AND faj022 = g_faj.faj022
  MESSAGE ""
 
  CALL cl_opmsg('u')
  LET g_success = 'Y'
  BEGIN WORK
 
  OPEN i100_cl USING g_faj.faj01,g_faj.faj02,g_faj.faj022
  IF STATUS THEN
     CALL cl_err("OPEN i100_cl:", STATUS, 1)  
     CLOSE i100_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH i100_cl INTO g_faj.*                #對DB鎖定
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_faj.faj01,STATUS,0)
     RETURN
  END IF
  LET g_faj.fajmodu=g_user                  #修改者
  LET g_faj.fajdate = g_today               #修改日期
  CALL i100_show()                          #顯示最新資料
 
  WHILE TRUE
     INPUT BY NAME g_faj.faj38,g_faj.faj39,g_faj.faj40,g_faj.faj41,g_faj.faj42,
                   g_faj.faj421,g_faj.faj422,g_faj.faj423,g_faj.faj56
           WITHOUT DEFAULTS
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i100_set_entry('o')
           CALL i100_set_no_entry('o')
           LET g_before_input_done = TRUE
 
        AFTER FIELD faj38
           IF NOT cl_null(g_faj.faj55) THEN
             IF g_faj.faj38 NOT MATCHES "[0-1]" THEN
                CALL cl_err(g_faj.faj38,'afa-087',0)
                NEXT FIELD faj38
             END IF
           END IF
 
        AFTER FIELD faj39
           IF NOT cl_null(g_faj.faj55) THEN
             IF g_faj.faj39 NOT MATCHES "[0-2]" THEN
                CALL cl_err(g_faj.faj39,'afa-088',0)
                NEXT FIELD faj39
             END IF
           END IF
 
        AFTER FIELD faj40
           IF NOT cl_null(g_faj.faj55) THEN
              IF g_faj.faj40 NOT MATCHES "[0-5]" THEN
                 CALL cl_err(g_faj.faj40,'afa-090',0)
                 NEXT FIELD faj40
              END IF
           END IF
 
        AFTER FIELD faj41
           IF NOT cl_null(g_faj.faj55) THEN
              IF g_faj.faj41 NOT MATCHES "[0-4]" THEN
                 CALL cl_err(g_faj.faj41,'afa-089',0)
                 NEXT FIELD faj41
              END IF
           END IF
 
        AFTER FIELD faj42
           IF NOT cl_null(g_faj.faj55) THEN
              IF g_faj.faj42 NOT MATCHES "[0-6]" THEN          
                 CALL cl_err(g_faj.faj42,'afa-090',0)
                 NEXT FIELD faj42
              END IF
           END IF
 
        AFTER INPUT
           CALL i100_set_no_entry('o')
 
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
        LET g_success = 'N'
        LET INT_FLAG = 0
        LET g_faj.*=g_faj_t.*
        CALL i100_show()
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
 
     UPDATE faj_file SET faj_file.* = g_faj.*    #更新DB
        WHERE faj01 = g_faj_t.faj01 AND faj02 = g_faj_t.faj02 AND faj022 = g_faj_t.faj022                #COLAUTH?
     IF SQLCA.sqlcode THEN
        LET g_success = 'N'
        CALL cl_err3("upd","faj_file",g_faj.faj01,"",SQLCA.sqlcode,"","i100_other",1)  #No.FUN-660136
        CONTINUE WHILE
     END IF
 
     EXIT WHILE
  END WHILE
 
  CLOSE i100_cl
  IF g_success = 'Y'
     THEN CALL cl_cmmsg(1) COMMIT WORK
     ELSE CALL cl_rbmsg(1) ROLLBACK WORK
  END IF
 
END FUNCTION
#No.FUN-9C0077 程式精簡

#No.FUN-BB0086--add--begin--
FUNCTION i100_faj106_check()
   IF NOT cl_null(g_faj.faj106) AND NOT cl_null(g_faj.faj18) THEN
      IF cl_null(g_faj_t.faj106) OR cl_null(g_faj18_t) OR g_faj_t.faj106 != g_faj.faj106 OR g_faj18_t != g_faj.faj18 THEN
         LET g_faj.faj106=s_digqty(g_faj.faj106,g_faj.faj18)
         DISPLAY BY NAME g_faj.faj106
      END IF
   END IF
   
   IF cl_null(g_faj.faj106) THEN LET g_faj.faj106 = 0 END IF
END FUNCTION 

FUNCTION i100_faj1062_check()
   IF NOT cl_null(g_faj.faj1062) AND NOT cl_null(g_faj.faj18) THEN
      IF cl_null(g_faj_t.faj1062) OR cl_null(g_faj18_t) OR g_faj_t.faj1062 != g_faj.faj1062 OR g_faj18_t != g_faj.faj18 THEN
         LET g_faj.faj1062=s_digqty(g_faj.faj1062,g_faj.faj18)
         DISPLAY BY NAME g_faj.faj1062
      END IF
   END IF
   
   IF cl_null(g_faj.faj1062) THEN LET g_faj.faj1062 = 0 END IF
END FUNCTION 

FUNCTION i100_faj110_check()
   IF NOT cl_null(g_faj.faj110) AND NOT cl_null(g_faj.faj18) THEN
      IF cl_null(g_faj_t.faj110) OR cl_null(g_faj18_t) OR g_faj_t.faj110 != g_faj.faj110 OR g_faj18_t != g_faj.faj18 THEN
         LET g_faj.faj110=s_digqty(g_faj.faj110,g_faj.faj18)
         DISPLAY BY NAME g_faj.faj110
      END IF
   END IF
   
   IF NOT cl_null(g_faj.faj110) THEN                                   
     IF g_faj.faj110 <0 THEN                                           
        CALL cl_err(g_faj.faj110,'anm-249',0)                          
        RETURN FALSE                                               
     END IF                                                            
   END IF                                                               
   IF cl_null(g_faj.faj110) THEN LET g_faj.faj110 = 0 END IF
   RETURN TRUE
END FUNCTION 

FUNCTION i100_faj111_check()
   IF NOT cl_null(g_faj.faj111) AND NOT cl_null(g_faj.faj18) THEN
      IF cl_null(g_faj_t.faj111) OR cl_null(g_faj18_t) OR g_faj_t.faj111 != g_faj.faj111 OR g_faj18_t != g_faj.faj18 THEN
         LET g_faj.faj111=s_digqty(g_faj.faj111,g_faj.faj18)
         DISPLAY BY NAME g_faj.faj111
      END IF
   END IF
   
   #TQC-C20183--mark--str--
   #IF NOT cl_null(g_faj.faj111) THEN                                      
   #   IF g_faj.faj111 < 0 THEN                                            
   #      CALL cl_err(g_faj.faj111,'anm-249',0)                            
   #      RETURN FALSE                                             
   #   END IF                                                              
   #END IF      
   #RETURN TRUE
   #TQC-C20183--mark--end--
END FUNCTION 
#No.FUN-BB0086--add--end--

#FUN-BB0093   ---start

#財簽二基本資料開帳作業
FUNCTION i100_fin_audit2()
   DEFINE p_cmd           LIKE type_file.chr1,
          l_fbi02         LIKE fbi_file.fbi02,
          l_fbi021        LIKE fbi_file.fbi021,
          l_faj27         LIKE faj_file.faj27,
          l_faj272        LIKE faj_file.faj272,
          l_n             LIKE type_file.num5,
          aag02_1         LIKE aag_file.aag02,
          aag02_2         LIKE aag_file.aag02,
          aag02_3         LIKE aag_file.aag02,
          aag02_1a        LIKE aag_file.aag02,   #No:FUN-BB0158
          aag02_2a        LIKE aag_file.aag02,   #No:FUN-BB0158
          aag02_3a        LIKE aag_file.aag02,   #No:FUN-BB0158
          l_faj24         LIKE faj_file.faj24,
          l_faj242        LIKE faj_file.faj242
   DEFINE l_str           STRING,
          l_len,i         LIKE type_file.num5
   DEFINE l_date          LIKE faj_file.faj26
   DEFINE l_date2         LIKE type_file.chr8
   DEFINE l_year          LIKE type_file.chr4
   DEFINE l_month         LIKE type_file.chr2
   DEFINE l_day           LIKE type_file.chr2

   INPUT BY NAME g_faj.faj143,g_faj.faj144,g_faj.faj142,
                 g_faj.faj1012,g_faj.faj1022,g_faj.faj1062,g_faj.faj1072,
                 g_faj.faj232,g_faj.faj242,g_faj.faj262,g_faj.faj272,
                 g_faj.faj342,g_faj.faj352,g_faj.faj362,g_faj.faj282,g_faj.faj292,g_faj.faj302,
                 g_faj.faj312,g_faj.faj322,g_faj.faj2032,g_faj.faj332,g_faj.faj3312,g_faj.faj572,g_faj.faj5712,
                 g_faj.faj1412,g_faj.faj582,g_faj.faj592,g_faj.faj602,g_faj.faj2042,g_faj.faj1082,
                 g_faj.faj531,g_faj.faj541,g_faj.faj551,g_faj.faj432 #No:FUN-BB0158 add faj531,faj541,faj551
                 WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL i100_set_required(p_cmd)
         CALL i100_set_no_required(p_cmd)
        #--------------------MOD-C50130--------------(S)
         SELECT aaa03 INTO g_faj.faj143 FROM aaa_file
         WHERE aaa01 = g_faa.faa02c
         IF NOT cl_null(g_faj.faj143) THEN
            SELECT azi04 INTO g_azi04_1 FROM azi_file
             WHERE azi01 = g_faj.faj143
         END IF
        #--------------------MOD-C50130--------------(E)
     #CHI-C60010--add--str--
      AFTER FIELD faj144
         IF cl_null(g_faj_o.faj144) OR g_faj_o.faj144 <> g_faj.faj144 THEN
            LET g_faj.faj144=cl_digcut(g_faj.faj144,g_azi04_1)
            LET g_faj.faj142 = g_faj.faj14 / g_faj.faj144
            CALL i100_31332()
            LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04_1)
            DISPLAY BY NAME g_faj.faj142,g_faj.faj144
         END IF

       AFTER FIELD faj1012
          IF NOT cl_null(g_faj.faj1012) THEN
             IF g_faj.faj1012 < 0 THEN
                CALL cl_err(g_faj.faj1012,'afa-037',0)
                NEXT FIELD faj1012
             END IF
             LET g_faj.faj1012 = cl_digcut(g_faj.faj1012,g_azi04_1)
             DISPLAY BY NAME g_faj.faj1012
          END IF

       AFTER FIELD faj1022
          IF NOT cl_null(g_faj.faj1022) THEN
             IF g_faj.faj1022 < 0 THEN
                CALL cl_err(g_faj.faj1022,'afa-037',0)
                NEXT FIELD faj1022
             END IF
             LET g_faj.faj1022 = cl_digcut(g_faj.faj1022,g_azi04_1)
             DISPLAY BY NAME g_faj.faj1022
          END IF

       AFTER FIELD faj1082
          IF NOT cl_null(g_faj.faj1082) THEN
             IF g_faj.faj1082 < 0 THEN
                CALL cl_err(g_faj.faj1082,'afa-037',0)
                NEXT FIELD faj1082
             END IF
             IF g_faj.faj1082 > g_faj.faj322 THEN
                CALL cl_err(g_faj.faj1082,'afa-925',0)
                NEXT FIELD faj1082
             END IF
             LET g_faj.faj1082 = cl_digcut(g_faj.faj1082,g_azi04_1)
             DISPLAY BY NAME g_faj.faj1082
          END IF
     #CHI-C60010--add--end

      AFTER FIELD faj432
          IF cl_null(g_faj.faj432) THEN
             IF g_faj.faj432 NOT MATCHES '[01]' THEN
                CALL cl_err(g_faj.faj432,'afa-416',0)
                LET g_faj.faj432 = g_faj_t.faj432
                DISPLAY BY NAME g_faj.faj432
                NEXT FIELD faj432
             END IF
             LET g_faj_o.faj432 = g_faj.faj432
             CALL i100_set_no_entry(p_cmd)
          END IF
     
       AFTER FIELD faj142
          IF NOT cl_null(g_faj.faj142) THEN 
             IF g_faj.faj142 < 0 THEN 
                CALL cl_err(g_faj.faj142,'anm-249',0)
                NEXT FIELD faj142
             END IF
             #新增時,預設未折減額=本幣成本-累計折舊-預留殘值 
             IF (g_faj_t.faj142 != g_faj.faj142) OR
                (g_faj.faj142 IS NOT NULL AND g_faj_t.faj142 IS NULL) THEN 
                CALL i100_31332()    #財簽二
                IF cl_null(g_faj.faj322) THEN LET g_faj.faj322 = 0 END IF
                IF cl_null(g_faj.faj312) THEN LET g_faj.faj312 = 0 END IF
             END IF
            #LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04)      #MOD-C50130 mark
             LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04_1)    #MOD-C50130 add
             DISPLAY BY NAME g_faj.faj142 
             LET g_faj_o.faj142 = g_faj.faj142
          END IF
       
      AFTER FIELD faj1412     
          IF NOT cl_null(g_faj.faj1412) THEN     
             IF g_faj.faj1412 < 0 THEN     
                CALL cl_err(g_faj.faj1412,'anm-249',0)     
                NEXT FIELD faj1412
             END IF
             LET g_faj.faj1412= cl_digcut(g_faj.faj1412,g_azi04_1)  #CHI-C60010 add
             DISPLAY BY NAME g_faj.faj1412   #CHI-C60010 add
          END IF

       AFTER FIELD faj232
          IF NOT cl_null(g_faj.faj232) THEN
             IF g_faj.faj232 NOT MATCHES '[1-2]' THEN
                LET g_faj.faj232 = g_faj_t.faj232
                DISPLAY BY NAME g_faj.faj232
                NEXT FIELD faj232
             END IF
             LET g_faj_o.faj232 = g_faj.faj232
          END IF

       BEFORE FIELD faj242
          IF cl_null(g_faj.faj242) THEN
             IF g_faj.faj232 = '1' THEN
                CALL cl_err(' ','afa-047',0)
             ELSE
                CALL cl_err(' ','afa-048',0)
             END IF
          END IF
          IF g_faj.faj232 = '1' AND p_cmd = 'a' AND cl_null(g_faj.faj242) THEN
             LET g_faj.faj242 = g_faj.faj20
             DISPLAY BY NAME g_faj.faj242
          END IF

      AFTER FIELD faj242
          LET l_faj242 = NULL
          IF g_faj.faj232 = '1' THEN
             IF cl_null(g_faj.faj242) THEN
                NEXT FIELD faj242
             ELSE
                CALL i100_faj2412('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_faj.faj242,g_errno,0)
                    LET g_faj.faj242 = g_faj_t.faj242
                    DISPLAY BY NAME g_faj.faj242
                    NEXT FIELD faj242
                 END IF
             END IF
             IF g_faa.faa20 = '2' THEN
                LET l_fbi02 = ''
                DECLARE i100_fbi22
                    CURSOR FOR SELECT fbi02,fbi021 FROM fbi_file
                                     WHERE fbi01= g_faj.faj242
                                       AND fbi03= g_faj.faj04
                FOREACH i100_fbi22 INTO l_fbi02,l_fbi021
                   IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                   IF not cl_null(l_fbi02) THEN EXIT FOREACH END IF
                   IF not cl_null(l_fbi021) THEN EXIT FOREACH END IF
                END FOREACH
                IF l_faj242 IS NULL OR g_faj.faj242 <> l_faj242 THEN
                   LET l_faj242 = g_faj.faj242
                   IF cl_null(l_fbi02) AND g_faj.faj282 NOT MATCHES '[0]' THEN
                      CALL cl_err(g_faj.faj242,'afa-317',1)
                   END IF
                   LET g_faj.faj55 = l_fbi02
                   DISPLAY BY NAME g_faj.faj55    
                   IF g_faa.faa31 = 'Y' THEN
                      IF cl_null(l_fbi021) AND g_faj.faj282 NOT MATCHES '[0]' THEN
                         CALL cl_err(g_faj.faj242,'afa-317',1)
                      END IF
                      LET g_faj.faj551 = l_fbi021
                      DISPLAY BY NAME g_faj.faj551
                   END IF
                END IF
             ELSE
                IF cl_null(g_faj.faj55) THEN
                   LET g_faj.faj55 = g_fab13
                END IF
                IF cl_null(g_fab13) THEN
                   CALL cl_err(g_faj.faj242,'afa-318',1)
                END IF
             END IF
          ELSE
             IF cl_null(g_faj.faj242) THEN
             ELSE
                CALL i100_faj2422('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_faj.faj242,g_errno,1)
                   LET g_faj.faj242 = g_faj_t.faj242
                   DISPLAY BY NAME g_faj.faj242
                   NEXT FIELD faj242
                END IF
             END IF
          END IF
          LET g_faj_o.faj242 = g_faj.faj242
     
      AFTER FIELD faj262
          IF NOT cl_null(g_faj.faj262) THEN
             IF g_faj.faj262 <= g_faa.faa092 THEN
                CALL cl_err('','afa-517',1)
             END IF
             LET l_day = DAY(g_faj.faj262)
             CALL s_yp(g_faj.faj262) RETURNING l_year,l_month
             LET l_date2 = l_year USING '&&&&',l_month USING '&&',l_day USING '&&'
             LET l_date  = l_date2
             CALL s_faj27(l_date,g_faa.faa152) RETURNING l_faj272
             IF cl_null(g_faj.faj272) THEN              #FUN-C50124
                IF g_faj.faj09='1' THEN                 #FUN-C50124
                   LET g_faj.faj272 = l_faj272
                ELSE                                    #FUN-C50124
                   LET g_faj.faj272 =l_year USING '&&&&',l_month USING '&&'      #FUN-C50124
                END IF                                  #FUN-C50124
             END IF
             LET g_faj.faj100 = g_faj.faj262
             DISPLAY BY NAME g_faj.faj272
             LET g_faj_o.faj262 = g_faj.faj262
          END IF

       AFTER FIELD faj272
          IF NOT cl_null(g_faj.faj272) THEN
             LET l_str = g_faj.faj272
             LET l_len = l_str.getlength()
             IF l_len != 6 THEN
                CALL cl_err(g_faj.faj272,'sub-005',1)
                NEXT FIELD faj272
             END IF
             FOR i = 1 TO l_len
                 IF l_str.substring(i,i) NOT MATCHES '[0123456789]' THEN
                    CALL cl_err(g_faj.faj272,'sub-005',1)
                    NEXT FIELD faj272
                 END IF
             END FOR
             IF NOT cl_chkym(g_faj.faj272) THEN
                CALL cl_err(g_faj.faj272,'sub-005',1)
                NEXT FIELD faj272
             END IF
          END IF

      BEFORE FIELD faj282
          CALL i100_set_entry(p_cmd)

       AFTER FIELD faj282   #折舊方式
          IF NOT cl_null(g_faj.faj282) THEN
             IF g_faj.faj282 NOT MATCHES '[0-5]' THEN
                LET g_faj.faj282 = g_faj_t.faj282
                DISPLAY BY NAME g_faj.faj282
                NEXT FIELD faj282
             END IF
             IF g_faj.faj282 ='0' THEN
                 LET g_faj.faj292=0
                 LET g_faj.faj302=0
                 LET g_faj.faj312=0
                 LET g_faj.faj322=0
                 LET g_faj.faj332=g_faj.faj142
                 LET g_faj.faj342='N'
                 LET g_faj.faj352=0
                 LET g_faj.faj362=0
                 LET g_faj.faj71='N'
                 LET g_faj.faj72=0
                 LET g_faj.faj73=0
                 DISPLAY BY NAME g_faj.faj292,g_faj.faj302,
                                 g_faj.faj312,g_faj.faj322,
                                 g_faj.faj332,g_faj.faj342,
                                 g_faj.faj352,g_faj.faj362,
                                 g_faj.faj71,g_faj.faj72,
                                 g_faj.faj73
                 DISPLAY BY NAME g_faj.faj53,g_faj.faj531,
                                 g_faj.faj54,g_faj.faj541

             END IF
             IF g_faj.faj282 != g_faj_t.faj282 OR g_faj_t.faj282 IS NULL THEN
               #CALL i100_3133()   #財簽   #MOD-C40166 mark
                CALL i100_31332()  #財簽二
               #CALL i100_6668()   #稅簽   #MOD-C40166 mark
             END IF
             LET g_faj_o.faj282 = g_faj.faj282
             CALL i100_set_no_entry(p_cmd)
          END IF

       BEFORE FIELD faj292
          #----推出配件/費用之耐用年限
          IF g_faj.faj021 MATCHES '[23]' THEN
             IF (p_cmd = 'a' AND (g_faj_o.faj292 IS NULL OR g_faj_o.faj292 <> g_faj.faj292)) OR
                (p_cmd = 'u' AND g_faj_o.faj292 <> g_faj.faj292) THEN
                CALL s_afaym(g_faj.faj02,g_faj.faj272,'3') RETURNING g_faj.faj292
                LET g_faj.faj302 = g_faj.faj292
                CALL s_afaym(g_faj.faj02,g_faj.faj272,'2') RETURNING g_faj.faj64
                LET g_faj.faj65 = g_faj.faj64
                DISPLAY BY NAME g_faj.faj292,g_faj.faj302
             END IF
          END IF

       AFTER FIELD faj292
          IF NOT cl_null(g_faj.faj292) THEN
             IF g_faj.faj292 <0 THEN
                CALL cl_err(g_faj.faj292,'anm-249',0)
                NEXT FIELD faj292
             END IF
             #--->新增時,預設未使用年限為耐用年限
             IF g_faj.faj021 = '1' THEN
                IF (p_cmd = 'a' AND (g_faj_o.faj292 IS NULL OR g_faj_o.faj292 <> g_faj.faj292)) OR
                   (p_cmd = 'u' AND g_faj_o.faj292 <> g_faj.faj292) THEN
                   LET g_faj.faj302 = g_faj.faj292
                   LET g_faj.faj64 = g_faj.faj292
                   LET g_faj.faj65 = g_faj.faj64
                   DISPLAY BY NAME g_faj.faj302
                END IF
             END IF
             IF (p_cmd='a' AND g_faj.faj292<>0) OR
                (p_cmd = 'u' AND g_faj_o.faj292 != g_faj.faj292) THEN
                CALL i100_31332()    #財簽二
             END IF
             LET g_faj_o.faj292 = g_faj.faj292
          END IF

       AFTER FIELD faj302
          IF NOT cl_null(g_faj.faj302) THEN
             IF g_faj.faj302 <0 THEN
                CALL cl_err(g_faj.faj302,'anm-249',0)
                NEXT FIELD faj302
             END IF
             #新增時,預設稅簽未使用年限
             IF p_cmd = 'a' THEN LET g_faj.faj65 = g_faj.faj302 END IF
             LET g_faj_o.faj302 = g_faj.faj302
             IF g_faj.faj302 > g_faj.faj292 THEN
                CALL cl_err(g_faj.faj302,'afa-165',0)
                NEXT FIELD faj302
             END IF
          END IF

       BEFORE FIELD faj312
          IF cl_null(g_faj.faj312) THEN
             LET g_faj.faj312 = 0
             DISPLAY BY NAME g_faj.faj312
          END IF

       AFTER FIELD faj312
          IF NOT cl_null(g_faj.faj312) THEN
             IF p_cmd = 'a' THEN LET g_faj.faj66 = g_faj.faj312 END IF
             IF g_faj.faj312 <0 THEN
                CALL cl_err(g_faj.faj312,'anm-249',0)
                NEXT FIELD faj312
             END IF
            #LET g_faj.faj312 = cl_numfor(g_faj.faj312,18,g_azi04)     #MOD-C50130 mark
             LET g_faj.faj312 = cl_numfor(g_faj.faj312,18,g_azi04_1)   #MOD-C50130 add
             DISPLAY BY NAME g_faj.faj312
             LET g_faj_o.faj312 = g_faj.faj312
          END IF

       BEFORE FIELD faj322
          IF cl_null(g_faj.faj322) THEN
             LET g_faj.faj322 = 0
             DISPLAY BY NAME g_faj.faj322
          END IF

       AFTER FIELD faj322
          IF (g_faj_o.faj322 != g_faj.faj322 ) OR
             (g_faj.faj322 IS NOT NULL AND g_faj_o.faj322 IS NULL) THEN
             IF g_faj.faj322 <0 THEN
                CALL cl_err(g_faj.faj322,'anm-249',0)
                NEXT FIELD faj322
             END IF
             LET g_faj.faj332 = g_faj.faj142 - g_faj.faj322
             LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
             LET g_faj.faj332=cl_digcut(g_faj.faj332,g_azi04_1)  #CHI-C60010 add
             DISPLAY BY NAME g_faj.faj332
          END IF
         #LET g_faj.faj322 = cl_numfor(g_faj.faj322,18,g_azi04)      #MOD-C50130 mark
          LET g_faj.faj322 = cl_numfor(g_faj.faj322,18,g_azi04_1)    #MOD-C50130 add
          DISPLAY BY NAME g_faj.faj322
          LET g_faj_o.faj322 = g_faj.faj322

       BEFORE FIELD faj332
          IF p_cmd = 'a' OR p_cmd = 'u' THEN
             LET g_faj.faj332 = g_faj.faj142 - g_faj.faj322
             LET g_faj.faj68 = g_faj.faj332
          END IF

       AFTER FIELD faj332
          IF p_cmd = 'a' THEN
             LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
          END IF
          IF NOT cl_null(g_faj.faj332) THEN
             IF g_faj.faj332 <0 THEN
                CALL cl_err(g_faj.faj332,'anm-249',0)
                NEXT FIELD faj332
             END IF
          END IF
         #LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04)       #MOD-C50130 mark
          LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04_1)     #MOD-C50130 add
          DISPLAY BY NAME g_faj.faj332
          LET g_faj_o.faj332 = g_faj.faj332

       AFTER FIELD faj3312
          IF NOT cl_null(g_faj.faj3312) THEN
             IF g_faj.faj3312 <0 THEN
                CALL cl_err(g_faj.faj3312,'anm-249',0)
                NEXT FIELD faj3312
             END IF
          END IF
         #LET g_faj.faj3312 = cl_numfor(g_faj.faj3312,18,g_azi04)     #MOD-C50130 mark
          LET g_faj.faj3312 = cl_numfor(g_faj.faj3312,18,g_azi04_1)   #MOD-C50130 add
         #DISPLAY BY NAME g_faj.faj332                                #MOD-C50130 mark
          DISPLAY BY NAME g_faj.faj3312                               #MOD-C50130 add
          LET g_faj_o.faj3312 = g_faj.faj3312

       BEFORE FIELD faj342
           CALL i100_set_entry(p_cmd)

       AFTER FIELD faj342
          IF NOT cl_null(g_faj.faj342) THEN
             IF g_faj.faj342 = 'Y' THEN
             ELSE
                LET g_faj.faj352 = 0
                LET g_faj.faj362 = 0
                DISPLAY BY NAME g_faj.faj352,g_faj.faj362
             END IF
             LET g_faj_o.faj342 = g_faj.faj342
          END IF
          CALL i100_set_no_entry(p_cmd)

       AFTER FIELD faj352
          IF NOT cl_null(g_faj.faj352) THEN
             IF g_faj.faj352 <0 THEN
                CALL cl_err(g_faj.faj352,'anm-249',0)
                NEXT FIELD faj352
             END IF
            #LET g_faj.faj352 = cl_digcut(g_faj.faj352,g_azi04)         #MOD-C50130 mark
             LET g_faj.faj352 = cl_digcut(g_faj.faj352,g_azi04_1)       #MOD-C50130 add
             DISPLAY BY NAME g_faj.faj352
          END IF

       AFTER FIELD faj362
         IF NOT cl_null(g_faj.faj362) THEN
            IF g_faj.faj362 <0 THEN
               CALL cl_err(g_faj.faj362,'anm-249',0)
               NEXT FIELD faj362
            END IF
         END IF

      AFTER FIELD faj582
         IF NOT cl_null(g_faj.faj582) THEN
            IF g_faj.faj582 < 0 THEN
               CALL cl_err(g_faj.faj582,'anm-249',0)
               NEXT FIELD faj582
            END IF
         END IF

      AFTER FIELD faj592
         IF NOT cl_null(g_faj.faj592) THEN
            IF g_faj.faj592 < 0 THEN
               CALL cl_err(g_faj.faj592,'anm-249',0)
               NEXT FIELD faj592
            END IF
            LET g_faj.faj592 = cl_digcut(g_faj.faj592,g_azi04_1) #CHI-C60010 add
            DISPLAY BY NAME g_faj.faj592  #CHI-C60010 add
         END IF

      AFTER FIELD faj602
         IF NOT cl_null(g_faj.faj602) THEN
            IF g_faj.faj602 < 0 THEN
               CALL cl_err(g_faj.faj602,'anm-249',0)
               NEXT FIELD faj602
            END IF
            LET g_faj.faj602 = cl_digcut(g_faj.faj602,g_azi04_1) #CHI-C60010 add
            DISPLAY BY NAME g_faj.faj602  #CHI-C60010 add
         END IF

      AFTER FIELD faj2032
         IF NOT cl_null(g_faj.faj2032) THEN
            IF g_faj.faj2032 <0 THEN
               CALL cl_err(g_faj.faj2032,'anm-249',0)
               NEXT FIELD faj2032
            END IF
           #LET g_faj.faj2032 = cl_numfor(g_faj.faj2032,18,g_azi04)     #MOD-C50130 mark
            LET g_faj.faj2032 = cl_numfor(g_faj.faj2032,18,g_azi04_1)   #MOD-C50130 add
            DISPLAY BY NAME g_faj.faj2032
         END IF

      AFTER FIELD faj2042
         IF NOT cl_null(g_faj.faj2042) THEN
            IF g_faj.faj2042 < 0 THEN
               CALL cl_err(g_faj.faj2042,'anm-249',0)
               NEXT FIELD faj2042
            END IF
            LET g_faj.faj2042 = cl_digcut(g_faj.faj2042,g_azi04_1) #CHI-C60010 add
            DISPLAY BY NAME g_faj.faj2042  #CHI-C60010 add
         END IF

      AFTER FIELD faj1062
         IF cl_null(g_faj.faj1062) THEN LET g_faj.faj1062 = 0 END IF
		 
      #-----No:FUN-BB0158-----
       AFTER FIELD faj531
           IF NOT cl_null(g_faj.faj531) THEN
              CALL i100_faj531(g_faj.faj531,g_faa.faa02c) RETURNING aag02_1a 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_faj.faj531,g_errno,1)
                 DISPLAY ' ' TO FORMONLY.aag02_1a
                 NEXT FIELD faj531
              END IF
           END IF
           IF cl_null(g_faj.faj531) THEN
              DISPLAY ' ' TO FORMONLY.aag02_1a
              DISPLAY BY NAME g_faj.faj531
           END IF
 
       AFTER FIELD faj541
           IF NOT cl_null(g_faj.faj541) THEN
              CALL i100_faj531(g_faj.faj541,g_faa.faa02c) RETURNING aag02_2a 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_faj.faj541,g_errno,1)
                 DISPLAY ' ' TO FORMONLY.aag02_2a
                 NEXT FIELD faj541
              END IF
           END IF
           DISPLAY BY NAME g_faj.faj541
           IF cl_null(g_faj.faj541) THEN
              DISPLAY ' ' TO FORMONLY.aag02_2a
           ELSE
              DISPLAY aag02_2a TO FORMONLY.aag02_2a
           END IF

       AFTER FIELD faj551
           IF NOT cl_null(g_faj.faj551) THEN
              CALL i100_faj531(g_faj.faj551,g_faa.faa02c) RETURNING aag02_3a 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_faj.faj551,g_errno,1)
                 DISPLAY ' ' TO FORMONLY.aag02_3a
                 NEXT FIELD faj551
              END IF
           END IF
           DISPLAY BY NAME g_faj.faj551
           IF cl_null(g_faj.faj551) THEN
              DISPLAY ' ' TO FORMONLY.aag02_3a
           ELSE
              DISPLAY aag02_3a TO FORMONLY.aag02_3a
           END IF
      #-----No:FUN-BB0158 END-----

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_faa.faa31 = 'Y' THEN
            IF g_faj.faj232=' ' OR g_faj.faj232 IS NULL THEN 
               CALL cl_err(g_faj.faj232,'afa-124',0)
               NEXT FIELD faj232
            END IF
            IF g_faj.faj242=' ' OR g_faj.faj242 IS NULL THEN 
               CALL cl_err(g_faj.faj242,'afa-083',0)
               NEXT FIELD faj242
            END IF
         END IF 
         IF g_faa.faa31 = 'Y' THEN
            IF g_faj.faj232 = '1' THEN
               CALL i100_faj2412('')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_faj.faj242,g_errno,1)
                  LET g_faj.faj242 = g_faj_t.faj242
                  DISPLAY BY NAME g_faj.faj242
                  NEXT FIELD faj242
               END IF
            ELSE
               CALL i100_faj2422('')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_faj.faj242,g_errno,1)
                  LET g_faj.faj242 = g_faj_t.faj242
                  DISPLAY BY NAME g_faj.faj242
                  NEXT FIELD faj242
               END IF
            END IF
         END IF
		 
        #-------------------------------MOD-C50130----------------------------(S)
        #LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04)         #MOD-C50130 mark
        #LET g_faj.faj1412 = cl_numfor(g_faj.faj1412,18,g_azi04)       #MOD-C50130 mark
        #LET g_faj.faj312 = cl_numfor(g_faj.faj312,18,g_azi04)         #MOD-C50130 mark
        #LET g_faj.faj322 = cl_numfor(g_faj.faj322,18,g_azi04)         #MOD-C50130 mark
        #LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04)         #MOD-C50130 mark
        #LET g_faj.faj331= cl_numfor(g_faj.faj3312,18,g_azi04)         #MOD-C50130 mark
        #LET g_faj.faj352 = cl_numfor(g_faj.faj352,18,g_azi04)         #MOD-C50130 mark
        #LET g_faj.faj592 = cl_numfor(g_faj.faj592,18,g_azi04)         #MOD-C50130 mark
        #LET g_faj.faj602 = cl_numfor(g_faj.faj602,18,g_azi04)         #MOD-C50130 mark
        #LET g_faj.faj2032 = cl_numfor(g_faj.faj2032,18,g_azi04)       #MOD-C50130 mark
        #LET g_faj.faj2042 = cl_numfor(g_faj.faj2042,18,g_azi04)       #MOD-C50130 mark
        #LET g_faj.faj1012 = cl_numfor(g_faj.faj1012,18,g_azi04)       #MOD-C50130 mark
        #LET g_faj.faj1022 = cl_numfor(g_faj.faj1022,18,g_azi04)       #MOD-C50130 mark
        #LET g_faj.faj1082 = cl_numfor(g_faj.faj1082,18,g_azi04)       #MOD-C50130 mark
         LET g_faj.faj142 = cl_numfor(g_faj.faj142,18,g_azi04_1)
         LET g_faj.faj312 = cl_numfor(g_faj.faj312,18,g_azi04_1)
         LET g_faj.faj322 = cl_numfor(g_faj.faj322,18,g_azi04_1)
         LET g_faj.faj332 = cl_numfor(g_faj.faj332,18,g_azi04_1)
         LET g_faj.faj352 = cl_numfor(g_faj.faj352,18,g_azi04_1)
         LET g_faj.faj592 = cl_numfor(g_faj.faj592,18,g_azi04_1)
         LET g_faj.faj602 = cl_numfor(g_faj.faj602,18,g_azi04_1)
         LET g_faj.faj1012 = cl_numfor(g_faj.faj1012,18,g_azi04_1)
         LET g_faj.faj1022 = cl_numfor(g_faj.faj1022,18,g_azi04_1)
         LET g_faj.faj1082 = cl_numfor(g_faj.faj1082,18,g_azi04_1)
         LET g_faj.faj1412 = cl_numfor(g_faj.faj1412,18,g_azi04_1)
         LET g_faj.faj2032 = cl_numfor(g_faj.faj2032,18,g_azi04_1)
         LET g_faj.faj2042 = cl_numfor(g_faj.faj2042,18,g_azi04_1)
         LET g_faj.faj3312 = cl_numfor(g_faj.faj3312,18,g_azi04_1)
        #-------------------------------MOD-C50130----------------------------(E)
         LET g_faj.faj144 = cl_numfor(g_faj.faj144,18,g_azi04_1) #CHI-C60010 add
         DISPLAY g_faj.faj142,g_faj.faj1412,g_faj.faj312,g_faj.faj322,
                 g_faj.faj332,g_faj.faj3312,g_faj.faj352,g_faj.faj592,
                 g_faj.faj602,g_faj.faj2032,g_faj.faj2042,
                 g_faj.faj1012,g_faj.faj1022,g_faj.faj1082
              TO faj14,faj1412,faj312,faj322,faj332,faj3312,faj352,faj592,
                 faj60,faj2032,faj2042,faj1012,faj1022,faj1082

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(faj242)   #分攤部門
               IF g_faj.faj232='1' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_faj.faj242
                  CALL cl_create_qry() RETURNING g_faj.faj242
                  DISPLAY BY NAME g_faj.faj242
                  NEXT FIELD faj242
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ='q_fad1'
                  LET g_qryparam.default1 =g_faj.faj242
                  LET g_qryparam.where = "fad07 = '2'"    #TQC-C50181  add
                  CALL cl_create_qry() RETURNING g_faj.faj242
                  DISPLAY BY NAME g_faj.faj242
                  DISPLAY BY NAME g_faj.faj531
                  NEXT FIELD faj242
               END IF
            #-----No:FUN-BB0158-----
            WHEN INFIELD(faj531)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]'"
               LET g_qryparam.arg1 = g_faa.faa02c 
               LET g_qryparam.default1 = g_faj.faj531
               CALL cl_create_qry() RETURNING g_faj.faj531
               DISPLAY BY NAME g_faj.faj531
               NEXT FIELD faj531
            WHEN INFIELD(faj541)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]'"
               LET g_qryparam.arg1 = g_faa.faa02c  
               LET g_qryparam.default1 = g_faj.faj541
               CALL cl_create_qry() RETURNING g_faj.faj541
               DISPLAY BY NAME g_faj.faj541
               NEXT FIELD faj541
            WHEN INFIELD(faj551)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]'"
               LET g_qryparam.arg1 = g_faa.faa02c 
               LET g_qryparam.default1 = g_faj.faj551
               CALL cl_create_qry() RETURNING g_faj.faj551
               DISPLAY BY NAME g_faj.faj551
               NEXT FIELD faj551
            #-----No:FUN-BB0158 END-----
            OTHERWISE
               EXIT CASE
         END CASE

      ON ACTION fixed_asset
         CALL cl_cmdrun('afai010')

      ON ACTION sub_category
         CALL cl_cmdrun('afai020')

      ON ACTION exp_apportion
         CALL cl_cmdrun('afai030' CLIPPED)

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
   END INPUT

   WHILE TRUE
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_faj.* = g_faj_t.*
         CALL i100_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      UPDATE faj_file SET faj_file.* = g_faj.*    # 更新DB
       WHERE faj01  = g_faj.faj01
         AND faj02  = g_faj.faj02
         AND faj022 = g_faj.faj022
      IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","faj_file",g_faj_t.faj01,"",SQLCA.sqlcode,"","",1)
          CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE      
 
END FUNCTION

#稅簽基本資料開帳作業
FUNCTION i100_mntn_depr_tax()
   DEFINE p_cmd           LIKE type_file.chr1

   INPUT BY NAME g_faj.faj62,g_faj.faj109,g_faj.faj103,g_faj.faj104,g_faj.faj110,
                 g_faj.faj71,g_faj.faj72,g_faj.faj73,g_faj.faj61,g_faj.faj64,g_faj.faj65,
                 g_faj.faj66,g_faj.faj67,g_faj.faj205,g_faj.faj68,g_faj.faj681,g_faj.faj74,g_faj.faj741,
                 g_faj.faj63,g_faj.faj69,g_faj.faj70,g_faj.faj206,g_faj.faj111,g_faj.faj201
                 WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL i100_set_required(p_cmd)
         CALL i100_set_no_required(p_cmd)

      AFTER FIELD faj201
          IF cl_null(g_faj.faj201) THEN
             IF g_faj.faj201 NOT MATCHES '[01]' THEN
                CALL cl_err(g_faj.faj201,'afa-417',0)
                LET g_faj.faj201 = g_faj_t.faj201
                DISPLAY BY NAME g_faj.faj201
                NEXT FIELD faj201
             END IF
             LET g_faj_o.faj201 = g_faj.faj201
          END IF      
                                                          
       AFTER FIELD faj103                                                       
          IF NOT cl_null(g_faj.faj103) THEN                                     
             IF g_faj.faj103 < 0 THEN                                           
                CALL cl_err(g_faj.faj103,'anm-249',0)                           
                NEXT FIELD faj103                                               
             END IF                                                             
          END IF                                                                
                                                                                
       AFTER FIELD faj104                                                       
          IF NOT cl_null(g_faj.faj104) THEN                                     
             IF g_faj.faj104 < 0 THEN                                           
                CALL cl_err(g_faj.faj104,'anm-249',0)                           
                NEXT FIELD faj104                                               
             END IF                                                             
          END IF
                                                                                                                                    
       AFTER FIELD faj109                                                                                                           
          IF NOT cl_null(g_faj.faj109) THEN                                                                                         
             IF g_faj.faj109 < 0 THEN                                                                                               
                CALL cl_err(g_faj.faj109,'afa-037',0)                                                                               
                NEXT FIELD faj109                                                                                                   
             END IF                                                                                                                 
             IF g_faj.faj109 > g_faj.faj67 THEN                                                                                     
                CALL cl_err(g_faj.faj109,'afa-926',0)                                                                               
                NEXT FIELD faj109                        
             END IF                                                                                                                 
             LET g_faj.faj109 = cl_digcut(g_faj.faj109,g_azi04)
             DISPLAY BY NAME g_faj.faj109
          END IF
          
        BEFORE FIELD faj71
            CALL i100_set_entry(p_cmd)

        AFTER FIELD faj71
           IF NOT cl_null(g_faj.faj71) THEN
              IF g_faj.faj71 = 'Y' THEN
              ELSE
                 LET g_faj.faj72 = 0
                 LET g_faj.faj73 = 0
                 DISPLAY BY NAME g_faj.faj72,g_faj.faj73
              END IF
              LET g_faj_o.faj71 = g_faj.faj71
           END IF
            CALL i100_set_no_entry(p_cmd)

        AFTER FIELD faj72                                                       
          IF NOT cl_null(g_faj.faj72) THEN                                      
             IF g_faj.faj72 <0 THEN                                             
                CALL cl_err(g_faj.faj72,'anm-249',0)                            
                NEXT FIELD faj72                                                
             END IF                                                             
             LET g_faj.faj72 = cl_digcut(g_faj.faj72,g_azi04)
             DISPLAY BY NAME g_faj.faj72
          END IF                                                                
                                                                                
        AFTER FIELD faj73                                                      
          IF NOT cl_null(g_faj.faj73) THEN                                      
             IF g_faj.faj73 <0 THEN                                             
                CALL cl_err(g_faj.faj73,'anm-249',0)                            
                NEXT FIELD faj73                                                
             END IF                                                             
          END IF 

       BEFORE FIELD faj61
            CALL i100_set_entry(p_cmd)

       AFTER FIELD faj61
         IF NOT cl_null(g_faj.faj61) THEN
            IF g_faj.faj61 NOT MATCHES '[0-5]' THEN NEXT FIELD faj61 END IF
            CALL i100_set_no_entry(p_cmd)
            IF g_faj.faj61 != g_faj_t.faj61 OR g_faj_t.faj61 IS NULL THEN
               CALL i100_6668()   #稅簽
            END IF
         END IF
 
       BEFORE FIELD faj68
           IF g_faj.faj68 IS NULL OR g_faj.faj68 = 0 THEN
              LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67
              DISPLAY g_faj.faj68 TO faj68
           END IF
       AFTER FIELD faj68                                                           
         IF NOT cl_null(g_faj.faj68) THEN                                       
              IF g_faj.faj68 <0 THEN                                            
                 CALL cl_err(g_faj.faj68,'anm-249',0)                           
                 NEXT FIELD faj68                                               
              END IF
           LET g_faj.faj68 = cl_numfor(g_faj.faj68,18,g_azi04)
           DISPLAY BY NAME g_faj.faj68
         END IF                                                      

       AFTER FIELD faj681
         IF NOT cl_null(g_faj.faj681) THEN                                       
              IF g_faj.faj681 <0 THEN                                            
                 CALL cl_err(g_faj.faj681,'anm-249',0)                           
                 NEXT FIELD faj681                                               
              END IF                                                            
           LET g_faj.faj681 = cl_numfor(g_faj.faj681,18,g_azi04)
           DISPLAY BY NAME g_faj.faj681
         END IF

       AFTER FIELD faj69                                                        
         IF NOT cl_null(g_faj.faj69) THEN                                       
            IF g_faj.faj69 < 0 THEN                                             
               CALL cl_err(g_faj.faj69,'anm-249',0)                             
               NEXT FIELD faj69                                                 
            END IF                                                              
         END IF                                                                 
                                                                                
       AFTER FIELD faj70                                                        
         IF NOT cl_null(g_faj.faj70) THEN                                       
            IF g_faj.faj70 < 0 THEN                                             
               CALL cl_err(g_faj.faj70,'anm-249',0)                             
               NEXT FIELD faj70                                                 
            END IF                                                              
         END IF

       AFTER FIELD faj62                                                          
         IF NOT cl_null(g_faj.faj62) THEN                                       
            IF g_faj.faj62 <0 THEN                                            
               CALL cl_err(g_faj.faj62,'anm-249',0)                           
               NEXT FIELD faj62                                               
            END IF
            IF (g_faj_t.faj62 != g_faj.faj62) OR
               (g_faj.faj62 IS NOT NULL AND g_faj_t.faj62 IS NULL) THEN
               CALL i100_6668()   #稅簽
            END IF
            LET g_faj.faj62 = cl_numfor(g_faj.faj62,18,g_azi04)
            DISPLAY BY NAME g_faj.faj62
         END IF
                                                          
       AFTER FIELD faj64                                                        
         IF NOT cl_null(g_faj.faj64) THEN                                       
            IF g_faj.faj64 < 0 THEN                                             
               CALL cl_err(g_faj.faj64,'anm-249',0)                             
               NEXT FIELD faj64                                                 
            END IF                                                              
            IF (p_cmd='a' AND g_faj.faj64<>0) OR
               (p_cmd = 'u' AND g_faj_o.faj64 != g_faj.faj64) THEN
               CALL i100_6668()   #稅簽
            END IF
         END IF                                                                 
                                                                                
       AFTER FIELD faj65                                                        
         IF NOT cl_null(g_faj.faj65) THEN                                       
            IF g_faj.faj65 < 0 THEN                                             
               CALL cl_err(g_faj.faj65,'anm-249',0)                             
               NEXT FIELD faj65                                                 
            END IF                                                              
         END IF
       AFTER FIELD faj66                                                          
          IF NOT cl_null(g_faj.faj66) THEN                                      
              IF g_faj.faj66 <0 THEN                                            
                 CALL cl_err(g_faj.faj66,'anm-249',0)                           
                 NEXT FIELD faj66                                               
              END IF                                                            
           LET g_faj.faj66 = cl_numfor(g_faj.faj66,18,g_azi04)
           DISPLAY BY NAME g_faj.faj66
          END IF

       AFTER FIELD faj67                                                          
         IF NOT cl_null(g_faj.faj67) THEN                                       
              IF g_faj.faj67 <0 THEN                                            
                 CALL cl_err(g_faj.faj67,'anm-249',0)                           
                 NEXT FIELD faj67                                               
              END IF                                                            
           LET g_faj.faj67 = cl_numfor(g_faj.faj67,18,g_azi04)
           DISPLAY BY NAME g_faj.faj67
         END IF

       AFTER FIELD faj63                                                          
          IF NOT cl_null(g_faj.faj63) THEN                                      
              IF g_faj.faj63 <0 THEN                                            
                 CALL cl_err(g_faj.faj63,'anm-249',0)                           
                 NEXT FIELD faj63                                               
              END IF                                                            
           LET g_faj.faj63 = cl_numfor(g_faj.faj63,18,g_azi04)
           DISPLAY BY NAME g_faj.faj63
          END IF
                                                                                
        AFTER FIELD faj205                                                      
         IF NOT cl_null(g_faj.faj205) THEN                                      
            IF g_faj.faj205 < 0 THEN                                            
               CALL cl_err(g_faj.faj205,'anm-249',0)                            
               NEXT FIELD faj205                                                
            END IF                                                              
         END IF                                                                 
                                                                                
        AFTER FIELD faj206                                                      
         IF NOT cl_null(g_faj.faj206) THEN
            IF g_faj.faj206 < 0 THEN                                            
               CALL cl_err(g_faj.faj206,'anm-249',0)                            
               NEXT FIELD faj206                                                
            END IF                                                              
         END IF

        AFTER FIELD faj110                                                        
            IF NOT cl_null(g_faj.faj110) THEN                                   
              IF g_faj.faj110 <0 THEN                                           
                 CALL cl_err(g_faj.faj110,'anm-249',0)                          
                 NEXT FIELD faj110                                              
              END IF                                                            
            END IF
            IF cl_null(g_faj.faj110) THEN LET g_faj.faj110 = 0 END IF
                                                        
         AFTER FIELD faj111                                                     
         IF NOT cl_null(g_faj.faj111) THEN                                      
            IF g_faj.faj111 < 0 THEN                                            
               CALL cl_err(g_faj.faj111,'anm-249',0)                            
               NEXT FIELD faj111                                                
            END IF                                                              
         END IF
     
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01= g_faj.faj15
         LET g_faj.faj103 = cl_numfor(g_faj.faj103,18,g_azi04)
         LET g_faj.faj104 = cl_numfor(g_faj.faj104,18,g_azi04)
         LET g_faj.faj62 = cl_numfor(g_faj.faj62,18,g_azi04)
         LET g_faj.faj109 = cl_numfor(g_faj.faj109,18,g_azi04)
         LET g_faj.faj63 = cl_numfor(g_faj.faj63,18,g_azi04)
         LET g_faj.faj66 = cl_numfor(g_faj.faj66,18,g_azi04)
         LET g_faj.faj67 = cl_numfor(g_faj.faj67,18,g_azi04)
         LET g_faj.faj68 = cl_numfor(g_faj.faj68,18,g_azi04)
         LET g_faj.faj681= cl_numfor(g_faj.faj681,18,g_azi04)
         LET g_faj.faj69 = cl_numfor(g_faj.faj69,18,g_azi04)
         LET g_faj.faj70 = cl_numfor(g_faj.faj70,18,g_azi04)
         LET g_faj.faj205 = cl_numfor(g_faj.faj205,18,g_azi04)
         LET g_faj.faj206 = cl_numfor(g_faj.faj206,18,g_azi04)
         
         DISPLAY g_faj.faj103,g_faj.faj104,g_faj.faj62,g_faj.faj109,
                 g_faj.faj63,g_faj.faj66,g_faj.faj67,g_faj.faj68,g_faj.faj681,
                 g_faj.faj69,g_faj.faj70,g_faj.faj205,g_faj.faj206
              TO faj103,faj104,faj62,faj109,
                 faj63,g_faj.faj66,faj67,faj68,faj681,
                 faj69,faj70,faj205,faj206

      ON ACTION fixed_asset
         CALL cl_cmdrun('afai010')

      ON ACTION sub_category
         CALL cl_cmdrun('afai020')

      ON ACTION exp_apportion
         CALL cl_cmdrun('afai030' CLIPPED)

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
   END INPUT

   WHILE TRUE
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_faj.* = g_faj_t.*
         CALL i100_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      UPDATE faj_file SET faj_file.* = g_faj.*    # 更新DB
       WHERE faj01  = g_faj.faj01
         AND faj02  = g_faj.faj02
         AND faj022 = g_faj.faj022
      IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","faj_file",g_faj_t.faj01,"",SQLCA.sqlcode,"","",1)
          CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE    
 
END FUNCTION
#FUN-BB0093   ---end

#No.FUN-CA0082   ---start---   Add
FUNCTION i100_allcopy()
   DEFINE l_faj      RECORD LIKE faj_file.*
   DEFINE i,l_count  LIKE type_file.num5
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_str      STRING
   DEFINE l_len      LIKE type_file.num5

   IF cl_null(g_faj.faj01) THEN RETURN END IF

   LET l_count = 0

   OPEN WINDOW w_allcopy WITH FORM "afa/42f/afai100_c"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_locale("afai100_c")

      INPUT l_count WITHOUT DEFAULTS FROM cnt1

         BEFORE INPUT
            DISPLAY l_count TO cnt1

         AFTER FIELD cnt1
            IF NOT cl_null(l_count) THEN
               IF l_count < 1 THEN
                  CALL cl_err('','alm-808','1')
                  NEXT FIELD cnt1
               END IF
            END IF

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW w_allcopy
         RETURN
      END IF

      SELECT * INTO l_faj.* FROM faj_file
       WHERE faj01 = g_faj.faj01
         AND faj02 = g_faj.faj02
         AND faj022= g_faj.faj022

      LET l_faj.fajuser = g_user               #使用者
      LET l_faj.fajoriu = g_user
      LET l_faj.fajorig = g_grup
      LET l_faj.fajmodu = g_user
      LET l_faj.fajgrup = g_grup               #使用者所屬群
      LET l_faj.fajdate = g_today
      LET l_faj.fajconf = 'Y'

      SELECT faa03,faa031 INTO g_faa.faa03,g_faa.faa031 FROM faa_file

      BEGIN WORK
      LET g_success = 'Y'
      CALL s_showmsg_init()
      FOR l_i = 1 TO l_count

         IF g_faa.faa03 = 'Y' THEN
            SELECT faa031 INTO g_faa.faa031 FROM faa_file
            IF NOT cl_null(g_faa.faa031) THEN
               LET l_str = g_faa.faa031
               LET l_len = l_str.getlength()
               FOR i = 1 TO l_len
                  IF l_str.substring(i,i) NOT MATCHES '[0123456789]' THEN
                     CALL s_errmsg(g_faa.faa031,'afa-205','','',1)
                     LET g_success = 'N'
                  END IF
               END FOR
            END IF
            IF cl_null(g_faa.faa031) THEN LET g_faa.faa031 = 0 END IF
            LET g_faa.faa031 = g_faa.faa031 + 1
            LET l_faj.faj01 = g_faa.faa031 USING '&&&&&&&&&&'
         ELSE
            LET l_faj.faj01 = l_faj.faj01 + 1
            LET l_faj.faj01 = l_faj.faj01 USING '&&&&&&&&&&'
         END IF

         CALL s_auno1(g_faj.faj02,'4','') RETURNING l_faj.faj02,l_faj.faj06
            IF NOT cl_null(g_errno) THEN
               CALL s_errmsg(l_faj.faj02,g_errno,'','',1)
               LET g_success = 'N'
            END IF
         INSERT INTO faj_file VALUES(l_faj.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('faj_file','','ins',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
         IF g_faa.faa03 = 'Y' THEN
            UPDATE faa_file SET faa031 = l_faj.faj01
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('faa_file','','upd',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
               END IF
         END IF
      END FOR
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         CALL s_showmsg()
         ROLLBACK WORK
      END IF

   CLOSE WINDOW w_allcopy
END FUNCTION
#NO.FUN-CA0082   ---end  ---   Add

#No.FUN-CB0080 ---start--- Add
FUNCTION i100_b_menu()
   DEFINE l_priv1    LIKE zy_file.zy03,           # 使用者執行權限
          l_priv2    LIKE zy_file.zy04,           # 使用者資料權限
          l_priv3    LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE l_cmd      LIKE type_file.chr1000
   DEFINE l_flowuser LIKE type_file.chr1
   DEFINE l_creator  LIKE type_file.chr1

   LET l_flowuser = "N"

   WHILE TRUE
      CALL i100_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
         SELECT faj_file.*
           INTO g_faj.*
           FROM faj_file
          WHERE faj01 = g_faj_1[l_ac1].faj01
            AND faj02 = g_faj_1[l_ac1].faj02
            AND faj022= g_faj_1[l_ac1].faj022
      END IF
      IF cl_null(g_action_choice) THEN
         CALL cl_set_act_visible("accept,cancel", FALSE)
      END IF
      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i100_fetch('/')
         END IF
         CALL cl_set_comp_visible("item_list", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("item_list", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
       END IF


       
      CASE g_action_choice
         WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i100_a()
           END IF
            
         WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i100_q()
           END IF
            
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i100_r()
               CALL i100_show()  
            END IF
            
         WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i100_u()
           END IF

         WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i100_copy()
           END IF
            
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i100_out()
            END IF

         WHEN "memo"
           IF cl_chk_act_auth() THEN
              CALL s_afa_memo('1',g_faj.faj02,' ',g_faj.faj022)
           END IF

         WHEN "multi_dept_apport"
           IF cl_chk_act_auth() THEN
              CALL cl_cmdrun('afai030' CLIPPED)
           END IF
           
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL i100_y()
           END IF
            
         WHEN "undo_confirm"
           IF cl_chk_act_auth() THEN
              CALL i100_z()
           END IF
            
         WHEN "fin_audit2"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_faj.faj432) THEN
                 LET g_action = '1' 
                 CALL i100_fin_audit2()
                 LET g_action = '0' 
              ELSE
                 IF g_faj.faj432 NOT MATCHES '[01]' THEN
                    CALL cl_err('','afa-415',0)
                    LET g_action = '0'        
                 ELSE
                    LET g_action = '1'           
                    CALL i100_fin_audit2()                    
                    LET g_action = '0'               
                 END IF
              END IF
           END IF

         WHEN "mntn_depr_tax"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_faj.faj201) THEN
                 LET g_action = '1' #FUN-BB0122 add              
                 CALL i100_mntn_depr_tax()
                 LET g_action = '0' #FUN-BB0122 add              
              ELSE
                 IF g_faj.faj201 NOT MATCHES '[01]' THEN
                    CALL cl_err('','afa-415',0)
                    LET g_action = '0' #FUN-BB0122 add                    
                 ELSE
                    LET g_action = '1' #FUN-BB0122 add                 
                    CALL i100_mntn_depr_tax()
                    LET g_action = '0' #FUN-BB0122 add                  
                 END IF
              END IF
           END IF 

         WHEN "tran_log_details"
            IF cl_chk_act_auth() THEN
               CALL i100_4()
            END IF

         WHEN "tran_log"
            IF cl_chk_act_auth() THEN
               CALL i100_5()
            END IF

         WHEN "relating_material"
            IF cl_chk_act_auth() THEN
               IF not cl_null(g_faj.faj02) THEN
                  LET g_cmd = "afaq300 '",g_faj.faj02,"'",
                              " '",g_faj.faj022,"'" CLIPPED
                  CALL cl_cmdrun(g_cmd)
               END IF
            END IF
            
        #add by liyjf181219 str   
         WHEN "modify_fp"
            CALL i100_fp()
        #add by liyjf181219 end 
      
         WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_faj.faj01 IS NOT NULL THEN
                LET g_doc.column1 = "faj01"
                LET g_doc.value1 = g_faj.faj01
                 LET g_doc.column2 = "faj02"    
                 LET g_doc.value2 = g_faj.faj02  
                 LET g_doc.column3 = "faj022"   
                 LET g_doc.value3 = g_faj.faj022  
                CALL cl_doc()
             END IF
          END IF
          
         WHEN "locale"
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          IF g_aza.aza26 = '2' THEN
             CALL i100_set_comb()
             CALL i100_set_comments()
          END IF

        WHEN "exit" 
            EXIT WHILE

        WHEN "g_idle_seconds"
            CALL cl_on_idle()
            
        WHEN "about"      
            CALL cl_about()
          
         WHEN "other"
          IF cl_chk_act_auth() THEN
             CALL i100_other()
          END IF

         WHEN "all_copy"
          IF cl_chk_act_auth() THEN
             CALL i100_allcopy()
          END IF
            
         OTHERWISE 
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

FUNCTION i100_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_faj_1 TO s_faj.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION main
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i100_fetch('/')
         END IF
         CALL cl_set_comp_visible("item_list", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("item_list", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
         EXIT DISPLAY

      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i100_fetch('/')
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("item_list", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("item_list", TRUE)
         EXIT DISPLAY

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 CONTINUE DISPLAY

      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 CONTINUE DISPLAY

      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
   	 CONTINUE DISPLAY

      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 CONTINUE DISPLAY

       ON ACTION output
           LET g_action_choice="output"
           EXIT DISPLAY

       ON ACTION memo
           LET g_action_choice="memo"
           EXIT DISPLAY
 
       ON ACTION multi_dept_apport
           LET g_action_choice="multi_dept_apport"
           EXIT DISPLAY
 
       ON ACTION confirm
           LET g_action_choice="confirm"
           EXIT DISPLAY
 
       ON ACTION undo_confirm
           LET g_action_choice="undo_confirm"
           EXIT DISPLAY

       ON ACTION fin_audit2
           LET g_action_choice="fin_audit2"
           EXIT DISPLAY
           
       ON ACTION mntn_depr_tax
           LET g_action_choice="mntn_depr_tax"
           EXIT DISPLAY
 
       ON ACTION tran_log_details
          LET g_action_choice="tran_log_details"
         EXIT DISPLAY 

       ON ACTION tran_log
          LET g_action_choice="tran_log"
          EXIT DISPLAY
          
       ON ACTION relating_material
          LET g_action_choice="relating_material"
          EXIT DISPLAY
       
       #add by liyjf181219 str
        ON ACTION rmodify_fp
          LET g_action_choice="rmodify_fp"
          EXIT DISPLAY
       #add by liyjf181219 end
       
       ON ACTION help
          LET g_action_choice="help"
          EXIT DISPLAY
          
        ON ACTION related_document
          LET g_action_choice="related_document"
          EXIT DISPLAY
 
       ON ACTION locale
          LET g_action_choice="locale"
          EXIT DISPLAY
          
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT DISPLAY

       ON ACTION controlg
          LET g_action_choice = "controlg"
          EXIT DISPLAY
          
       ON IDLE g_idle_seconds
          LET g_action_choice = "g_idle_seconds"
          EXIT DISPLAY
 
        ON ACTION about
          LET g_action_choice = "about"
          EXIT DISPLAY

       ON ACTION other
          LET g_action_choice = "other"
          EXIT DISPLAY

       ON ACTION close 
           LET INT_FLAG=FALSE 	
           LET g_action_choice = "exit"
           EXIT DISPLAY

       ON ACTION all_copy
          LET g_action_choice="all_copy"
          EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i100_b_fill()
  DEFINE l_i             LIKE type_file.num10

    CALL g_faj_1.clear()
    LET l_i = 1
    FOREACH afai100_list_cur INTO g_faj_1[l_i].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT pmc03 INTO g_faj_1[l_i].pmc03_10 FROM pmc_file
        WHERE pmc01 = g_faj_1[l_i].faj10
       SELECT pmc03 INTO g_faj_1[l_i].pmc03_11 FROM pmc_file
        WHERE pmc01 = g_faj_1[l_i].faj11
       SELECT gen02 INTO g_faj_1[l_i].gen02_19 FROM gen_file
        WHERE gen01 = g_faj_1[l_i].faj19
       SELECT gem02 INTO g_faj_1[l_i].gem02_20 FROM gem_file
        WHERE gem01 = g_faj_1[l_i].faj20
       LET l_i = l_i + 1
    END FOREACH
    CALL g_faj_1.deleteElement(l_i)
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_faj_1 TO s_faj.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION
#No.FUN-CB0080 ---end  --- Add

###add by liyjf181219  str
FUNCTION i100_fp()
    DEFINE l_date      LIKE type_file.num5
    DEFINE l_flag      LIKE type_file.chr1
    DEFINE l_paydate   LIKE type_file.dat
    DEFINE l_oox03     LIKE oox_file.oox03   #MOD-D40110
 
    
    SELECT * INTO g_faj.* FROM faj_file WHERE faj01=g_faj.faj01 AND faj02=g_faj.faj02 AND faj022=g_faj.faj022
 
    CALL cl_set_comp_entry("faj32",FALSE)
    
    BEGIN WORK
    OPEN i100_cl USING g_faj.faj01,g_faj.faj02,g_faj.faj022
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl date:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i100_cl INTO g_faj.*
    IF STATUS THEN
       CALL cl_err('Lock faj:',STATUS,0)
       ROLLBACK WORK
       RETURN
    END IF
 
    LET g_faj_t.*=g_faj.*
    LET g_faj_o.*=g_faj.*
 
   WHILE TRUE
      CALL cl_set_head_visible("","YES")
 
      INPUT BY NAME g_faj.faj51
            WITHOUT DEFAULTS
 
         AFTER FIELD faj51
            DISPLAY BY NAME g_faj.faj51

         AFTER INPUT
            LET l_flag='N'
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET g_faj.*=g_faj_t.*
               DISPLAY BY NAME g_faj.faj51
               CALL cl_err('',9001,0)
               EXIT WHILE
            END IF

           { IF cl_null(g_faj.faj12) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_faj.faj12
            END IF
        
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD faj32
            END IF}
        
            UPDATE faj_file SET faj51=g_faj.faj51, 
                                fajmodu=g_user,
                                fajdate=g_today
             WHERE faj01=g_faj.faj01 AND faj02=g_faj.faj02 AND faj022=g_faj.faj022
 
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","faj_file",g_faj.faj01,"",STATUS,"","upd faj01",1)
               LET g_faj.*=g_faj_t.*
               DISPLAY BY NAME g_faj.faj51
               ROLLBACK WORK
               RETURN
            ELSE
               LET g_faj_o.*=g_faj.*
               LET g_faj_t.*=g_faj.*
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
      END INPUT
 
      EXIT WHILE
   END WHILE
 
   COMMIT WORK
 
END FUNCTION
###add by liyjf181219 end
