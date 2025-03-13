# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat110.4gl
# Descriptions...: 資產出售作業
# Date & Author..: 96/05/28 By Melody
# Modify.........: No:7645 03/07/24 By Wiky 設定抵押的資產應不可出售或報廢或銷帳
# Date & Modify..: 03/08/12 By Wiky #No:7735 單頭的fbe08原幣金額未按照幣別取位
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-480081 04/08/04 By Kitty 稅簽還原出現-217 upd faj
# Modify.........: No.MOD-480332 04/08/23 By Nicola 更改時會當機
# Modify.........: No.MOD-480076 04/08/23 By Nicola 單身第一個序號key完再到第二個序號時,必須按放棄才可以離開
# Modify.........: No.MOD-480083 04/08/26 By Nicola 1.發票資料查詢功能無效
#                                                   2.執行產生帳款功能,也有成功,但畫面上帳款編號沒有顯示,必須重查才會顯示
# Modify.........: No.MOD-490235 04/09/13 By Yuna 自動生成改成用confirm的方式
# Modify.........: No.MOD-490164 04/09/16 By Kitty 增加判斷,若稅簽已過帳,不可取消確認
# Modify.........: No.MOD-490195 04/09/17 By Kitty 原幣金額key完後即算出處份損益,目前是要按到未折減後才會計算
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4B0073 04/11/26 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0008 04/12/02 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0032 04/12/09 By pengu  匯率幣別欄位修改，與aoos010的azi17做判斷，
                                                   #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-510142 05/02/18 By kitty 原因碼使用g_chr判斷,確認pic也用g_chr判斷,造成原因碼查詢及輸入時會判斷錯誤
# Modify.........: No.MOD-530824 05/05/04 By Smapmin 未過帳不可拋AR
#
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: No.MOD-4A0114 05/08/25 By Smapmin 新增申請人與申請部門
# Modify.........: No.MOD-590230 05/09/29 By Smapmin 含稅出售金額計算
# Modify.........: No.FUN-580109 05/10/24 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.FUN-5B0018 05/11/04 By Sarah 出售日期沒有判斷關帳日
# Modify.........: No.FUN-5B0100 05/11/23 By Smapmin 產生帳款後要能顯示出帳款編號
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-5C0138 05/12/23 By Smapmin 重選財編,附號.中文沒有重帶
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.TQC-630073 06/03/07 By Mandy 流程訊息通知功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-640243 06/05/16 By Echo 自動執行確認功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改報表列印所傳遞的參數
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/07 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680028 06/08/22 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION t110_q() 一開始應清空g_fbe.*值
# Modify.........: No.CHI-690083 06/10/13 By rainy 報廢/銷帳/出售作業只要是有主件資料的, 狀態更改時,一律update其相關附件的資產狀態
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-690081 06/12/06 By Smapmin 已確認的單子不可再重新產生分錄
# Modify.........: No.MOD-6C0060 06/12/11 By Smapmin 刪除也要UPDATE單身合計的部份
# Modify.........: No.FUN-710028 07/02/02 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740222 07/04/24 By Echo 從ERP簽核時，「拋轉傳票」、「傳票拋轉還原」action應隱藏
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760182 07/06/27 By chenl   自動產生QBE不可為空。
# Modify.........: No.MOD-760135 07/07/04 By Smapmin 單頭稅別為內含者,單身【本幣出售金額】換算為未稅金額後 再計算處分損益,處分損益公式不變
# Modify.........: No.TQC-770108 07/07/24 By Rayven 單身錄入數量是負數未控管
# Modify.........: No.TQC-780089 07/09/21 By Smapmin 自動產生或單身輸入資產編號時,當月有折舊不可輸入
#                                                    已有折舊資料不可過帳還原或確認
#                                                    判斷是否執行重新計算帳值/產生分錄
# Modify.........; No.MOD-7B0082 07/11/08 By Smapmin 幣別不應再重取出來顯示
# Modify.........; No.TQC-7B0093 07/11/15 By Rayven 參數”資產處份轉入清理科目”勾選,”處分損益”無論正負,審核時都報錯:afa-154
#                                                   參數”資產處份轉入清理科目”未勾選, ”處分損益”為負數時,審核時報錯:afa-154
# Modify.........; No.TQC-7B0155 07/11/29 By xufeng 會計期間的明細日期應該抓取帳套會計期間檔(azmm_file),而不是去抓取會計期間檔(azm_file)
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.MOD-810219 08/01/31 By Smapmin 幣別位數取位
# Modify.........: No.FUN-840111 08/04/23 By lilingyu 預設申請人員登入帳號
# Modify.........: No.MOD-840375 08/04/24 By lilingyu 單據日期應與afat105固定資產改良作業相同,
#                                                    當日期不在現行期別範圍內時,show警告
#                                                    『日期應在該年度期別之起始截止日期範圍內』                      
# Modify.........: No.FUN-840127 08/04/25 By bnlent 產生帳款時自動帶出出售單號
# Modify.........: No.CHI-840068 08/04/25 By Sarah 1.當參數勾選當月處份應提列折舊,應卡當月份是否有提列折舊,若沒有則不可確認
#                                                  2.稅簽過帳還原會出現錯誤訊息,且afai100稅簽的未折減額/銷帳成本/銷帳累折未重算回寫
# Modify.........: No.FUN-850068 08/05/14 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-860284 08/07/04 By Sarah 使用afap302拋轉程式,原先傳g_user改為fbeuser
# Modify.........: No.CHI-870008 08/07/24 By Sarah 計算單身明細稅額與單身稅額有差異時,調整在金額最大筆的處分損益上
# Modify.........: No.CHI-860025 08/07/23 By Smapmin 根據TQC-780089的修改,需區分財簽與稅簽
# Modify.........: No.TQC-870051 08/07/31 By Sarah 處分損益的計算公式請改成LET g_fbf[l_ac].fbf09=g_fbf07+l_dis-l_fbf09
# Modify.........: No.MOD-880125 08/08/18 By Sarah t110_y_chk(),檢查afa-154訊息段,在計算l_totcost時需加上fbf09>0的部分
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-8B0025 08/11/07 By Sarah 1.新增時,帶出fbf04的default值,需扣除待出售數量,檢核時,也以"輸入數量"與"未銷帳數量-待出售數量"相比
#                                                  2.新增時,表尾的fbe08x,fbe09x無須開放輸入
# Modify.........: No.MOD-8B0243 08/11/24 By Sarah 當要修改單身數量時,判斷允不允許輸入應將l_fbf04_1-舊值
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值
# Modify.........: No.MOD-940066 09/03/07 By lilingyu 如處分損溢總計>0,而單身有<0者,無法確認  
# Modify.........: No.FUN-910117 09/05/12 By jan 新增fbe031/fbe041欄位
# Modify.........: No.MOD-950166 09/05/18 By xiaofeizhu 增加對單身的管控
# Modify.........: No.MOD-970231 09/07/24 By Sarah 計算未折減額時,應抓faj33+faj331
# Modify.........: No.CHI-970053 09/08/10 By Sarah 報表串afar110有問題
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990043 09/09/07 By Sarah 當資產狀態為4.折畢時,不需檢核afa-526
# Modify.........: No.MOD-990191 09/09/21 By Sarah 當出售"費用"固定資產時,計算處分損益時不需將faj14成本計入
# Modify.........: No.MOD-990202 09/09/23 By Sarah 當出售"費用"固定資產時,確認時判斷afa-154時不需將l_totcost成本計入
# Modify.........: No:MOD-9A0096 09/10/14 By mike FUNCTION t110_y_chk()段,请先判断faj28<>'0'才做检核afa-526讯息                     
# Modify.........: No:MOD-9B0039 09/11/09 By Sarah 若屬於附件出售時,不可把主件狀態一起變成出售
# Modify.........: No:MOD-9B0156 09/11/24 By Sarah 執行[自動產生]功能後離開前沒將畫面關閉
# Modify.........: No:TQC-9B0211 09/11/25 By Carrier SQL STANDARDIZE
# Modify.........: No:MOD-9C0027 09/12/07 By Smapmin 重新計算帳值後需再做一次稅額的處理
# Modify.........: No:MOD-9C0385 09/12/24 By Sarah 1.重新計算帳值完後稅額差異的處理,參考CHI-870008修改段
#                                                  2.當單身沒有做任何異動時,不做稅額差異的處理
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-A30001 10/03/05 By Dido 含稅時才需要計算處份損益 
# Modify.........: No:MOD-A30159 10/03/23 By sabrina 不應卡當月要有折舊提列才可以賣出
# Modify.........: No:MOD-A40011 10/04/07 By Summer 於同一作業中不允許有相同的財產編號+附號存在此作業中
# Modify.........: No:MOD-A40148 10/04/26 By sabrina l_dis應包含銷售累折與銷售數量
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# Modify.........: No:CHI-A70032 10/07/19 By Summer 單身輸入財產編號時,若此狀態為'6'且存在於afat108(abh03)應可允許輸入,不需控管
# Modify.........: No:MOD-A80097 10/08/12 By wujie  单身原/本币金额控管改为必须大于0
# ModIFy.........: No:MOD-A80137 10/08/19 By Dido 過帳與取消過帳應檢核關帳日 
# Modify.........: No:MOD-AA0001 10/10/01 By Dido 確認檢核當月處分應折舊問題 
# Modify.........: No:CHI-9C0008 10/10/13 By Summer 若已提至異動單據月份且單身未折減額/減值準備均與折舊後月份相等
#                                                   則不需重新計算帳值即可確認 
# Modify.........: No:TQC-AB0198 10/11/29 By suncx  未對單身欄位fbf03“財產編號”做控管
# Modify.........: No:TQC-AC0380 10/12/29 By chenying AFTER FIELD fbf031未對空值做控管，導致抓取的數量都為0，而進一步導致輸入任何數量都報afa-109錯誤訊息
# Modify.........: No:MOD-B30602 11/03/17 By lixia fbe03 fbe04 fbe16 fbe17增加管控
# Modify.........: No:MOD-B30593 11/03/17 By Dido 增加抵押資產檢核 
# Modify.........: No:FUN-AB0088 11/04/01 By chenying 所有多帳別功能(aza63)判斷改為使用財簽二功能(faa31)
# Modify.........: No:MOD-B40044 11/04/12 By Dido fbe03 為空不可產生應收
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/06/01 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50118 11/06/13 By belle 在自動產生鍵,中增加QBE條件-族群編號
# Modify.........: No:TQC-B80010 11/08/01 By Sarah FUNCTION t110_y_chk(),l_fbf11需跟l_fbf08一樣做數量的計算
# Modify.........: No:FUN-B60140 11/09/08 By minpp "財簽二二次改善" 追單
# Modify.........: No.MOD-BA0165 11/10/21 By Polly 調整afa-526 條件檢核
# Modify.........: No:FUN-BA0112 11/11/08 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: NO:FUN-B90096 11/11/08 By Sakura 將UPDATE faj_file拆分出財一、財二;加入財簽二功能
# Modify.........: No:MOD-BB0041 11/11/12 By johung 控卡fbf08不可大於faj33+faj331
# Modify.........: No:CHI-B80007 11/11/12 By johung 增加afa-309控卡 
# Modify.........: NO:FUN-B90004 11/11/17 By Belle 自動拋轉傳票單別一欄有值，即可進行傳票拋轉/傳票拋轉還原
# Modify.........: No:FUN-BC0004 11/12/01 By xuxz 處理相關財簽二無法存檔問題
# Modify.........: No:MOD-BC0025 11/12/10 By johung 調整afa-092控卡的判斷
# Modify.........: No:MOD-BC0114 12/01/16 By Sakura 程式中，所有s_get_bookno下，皆增加判斷
# Modify.........: No:MOD-BC0129 12/01/16 By Sakura 本幣出售金額(財簽二)，在主畫面該筆資料寫入時，預設為幣別換算後的本幣出售金額
# Modify.........: No:TQC-C10107 12/01/30 By wujie  not null栏位不能为null
# Modify.........: No:TQC-C10113 12/01/30 By wujie 查询时增加oriu，orig栏位 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-C20035 12/02/06 By Polly 單身處份損益小於0時，不需納入l_totcost中
# Modify.........: No:MOD-C20096 12/02/13 By Dido 檢核分錄問題調整 
# Modify.........: No:FUN-C30140 12/03/12 By Mandy (1)TIPTOP端簽核時,以下ACTION應隱藏"分錄底稿二","財簽二資料"
# Modify.........:                                 (2)送簽中,應不可執行ACTION[自動產生,重新計算帳值,分錄底稿,分錄底稿二,分錄底稿二,財簽二資料,稅簽修改]
# Modify.........: No:MOD-C30722 12/03/16 By xuxz 還原 MOD-C20096
# Modify.........: No:MOD-C30758 12/04/05 By wujie 增加还原帐款功能，对应删除产生帐款功能的资料
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3判斷的程式，將財二部份拆分出來使用fahdmy32處理
# Modify.........: No:MOD-C50044 12/05/09 By Elise 按下確認時，會出現afai900內當月份有做調整的單被當成是已提列折舊的單
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:MOD-C50212 12/05/27 By suncx 錄入完成時，詢問是否產生分錄底稿
# Modify.........: No:TQC-C50162 12/05/30 By xuxz fbf082取值修改
# Modify.........: No:FUN-C30102 12/05/15 By Lori 新增Action"應收帳款查詢"
# Modify.........: No.MOD-C50244 12/06/04 By Polly 調整l_fbf092/g_fbf072 給值
# Modify.........: No.MOD-C50255 12/06/05 By Polly 增加控卡維護拋轉總帳單別
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:TQC-C60120 12/06/13 By lujh 單頭客戶編號更改后，審核時要提醒與分錄底稿中的不一致
# Modify.........: No:MOD-C60137 12/06/15 By Polly 修正幣取位抓取
# Modify.........: No:CHI-C60010 12/06/15 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.MOD-C60018 12/06/21 By Elise 帳款還原時，單頭的帳款編號未清除
# Modify.........: No.TQC-C60213 12/06/26 By lujh 新增資料輸入完單身或者點擊單身進入後離開，重新產生分錄底稿後,單頭日期、客戶、幣種等資料會全部亂掉，顯示其他內容
# Modify.........: No.TQC-C60214 12/06/26 By lujh TQC-C60213問題沒有處理完,還有一處沒有修改
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:MOD-C70059 12/07/06 By Polly 增加控卡單頭幣別需和單身出售財產幣別相同
# Modify.........: No:CHI-C70037 12/07/27 By Belle 修正單據確認時的判斷
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,顯示訊息 afa-134
# Modify.........: No:MOD-C80118 12/09/11 By Polly 當月取得折舊要按日計算，需依比例提列折舊
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No:MOD-CA0101 12/10/16 By Polly 資產狀態的更新，針對財編+附號的方式進行更新
# Modify.........: No:MOD-CA0237 12/11/01 By Polly 調整處份損益計算
# Modify.........: No:MOD-CA0239 12/11/01 By Polly 1.增加控卡，出售數量不能為零 2.同一張異動單據不可有相同之財產編號資料
#                                                  3.調整數量控卡，資產數量-銷帳數量不為零，即可異動
# Modify.........: No:MOD-CB0007 12/11/01 By suncx 錄入或修改fbe03為空，則給出提示"如需生成賬款，則此欄位不能為空"
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:MOD-D10011 13/01/04 By Polly 稅簽過帳及稅簽過帳還原重新更新faj66稅簽預留殘值欄位
# Modify.........: No:MOD-D10051 13/01/08 By Polly 作廢時需同時刪除npp_file/npq_file
# Modify.........: No:MOD-D10198 13/01/22 By suncx 賬款已審核，則不能進行賬款還原
# Modify.........: No.MOD-D10260 13/01/29 By Polly 調整自動產生單身sql語法 
# Modify.........: No.FUN-D10098 13/02/04 By lujh 大陸版本用gfag110
# Modify.........: No.MOD-D20017 13/02/04 By Polly 稅簽過帳時，應抓資產稅簽的現行年度/期別判斷
# Modify.........: No.CHI-D10032 13/01/31 By Polly 開放單頭可以和單身幣別不同控卡；增加單身多筆時，幣別需相同控卡
#                                                  單身增加幣別欄位顯示；自動產生畫面增加幣別欄位，預設帶單頭幣別
# Modify.........: No.MOD-D20086 13/02/19 By Polly 以feb10的出售損益判斷損益小於0時，不需要納入l_totcost因分錄的出售金額+處份損益=未折減額
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:MOD-D30031 13/03/06 By suncx 修改资料将此税额栏位关闭不可修改，带抛转应收生成axrt300资料后可对税额进行修改
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-CB0108 13/04/10 By apo 增加控卡，同一個財產編號不可有多張異動單據資料！
# Modify.........: No:FUN-D80046 13/08/15 By wangrr 審核檢查時,當參數勾選"當月處置應提列折舊",無需檢查無形資產和費用(faj09=2/5)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fbe         RECORD LIKE fbe_file.*,
       g_fbe_t       RECORD LIKE fbe_file.*,
       g_fbe_o       RECORD LIKE fbe_file.*,
       g_fahprt      LIKE fah_file.fahprt,
       g_fahconf     LIKE fah_file.fahconf,
       g_fahpost     LIKE fah_file.fahpost,
       g_fahapr      LIKE fah_file.fahapr,             #FUN-640243
       g_fbf         DYNAMIC ARRAY OF RECORD   #程式變數(Prinram Variables)
                      fbf02     LIKE fbf_file.fbf02,
                      fbf03     LIKE fbf_file.fbf03,
                      fbf031    LIKE fbf_file.fbf031,
                      faj06     LIKE faj_file.faj06,
                      faj18     LIKE faj_file.faj18,
                      fbf04     LIKE fbf_file.fbf04,
                      fbf05     LIKE fbf_file.fbf05,
                      faj15     LIKE faj_file.faj15,      #CHI-D10032 add
                      fbf06     LIKE fbf_file.fbf06,
                      fbf07     LIKE fbf_file.fbf07,
                      fbf08     LIKE fbf_file.fbf08,
                      fbf11     LIKE fbf_file.fbf11,      #No:A099
                      fbf09     LIKE fbf_file.fbf09,
                      fbfud01   LIKE fbf_file.fbfud01,
                      fbfud02   LIKE fbf_file.fbfud02,
                      fbfud03   LIKE fbf_file.fbfud03,
                      fbfud04   LIKE fbf_file.fbfud04,
                      fbfud05   LIKE fbf_file.fbfud05,
                      fbfud06   LIKE fbf_file.fbfud06,
                      fbfud07   LIKE fbf_file.fbfud07,
                      fbfud08   LIKE fbf_file.fbfud08,
                      fbfud09   LIKE fbf_file.fbfud09,
                      fbfud10   LIKE fbf_file.fbfud10,
                      fbfud11   LIKE fbf_file.fbfud11,
                      fbfud12   LIKE fbf_file.fbfud12,
                      fbfud13   LIKE fbf_file.fbfud13,
                      fbfud14   LIKE fbf_file.fbfud14,
                      fbfud15   LIKE fbf_file.fbfud15
                     END RECORD,
       g_fbf_e       DYNAMIC ARRAY OF RECORD             #No:A099
                      fbf10     LIKE fbf_file.fbf10,
                      fbf12     LIKE fbf_file.fbf12
                     END RECORD,                         #end #No:A099
       g_fbf_t       RECORD
                      fbf02     LIKE fbf_file.fbf02,
                      fbf03     LIKE fbf_file.fbf03,
                      fbf031    LIKE fbf_file.fbf031,
                      faj06     LIKE faj_file.faj06,
                      faj18     LIKE faj_file.faj18,
                      fbf04     LIKE fbf_file.fbf04,
                      fbf05     LIKE fbf_file.fbf05,
                      faj15     LIKE faj_file.faj15,      #CHI-D10032 add
                      fbf06     LIKE fbf_file.fbf06,
                      fbf07     LIKE fbf_file.fbf07,
                      fbf08     LIKE fbf_file.fbf08,
                      fbf11     LIKE fbf_file.fbf11,      #No:A099
                      fbf09     LIKE fbf_file.fbf09,
                      fbfud01   LIKE fbf_file.fbfud01,
                      fbfud02   LIKE fbf_file.fbfud02,
                      fbfud03   LIKE fbf_file.fbfud03,
                      fbfud04   LIKE fbf_file.fbfud04,
                      fbfud05   LIKE fbf_file.fbfud05,
                      fbfud06   LIKE fbf_file.fbfud06,
                      fbfud07   LIKE fbf_file.fbfud07,
                      fbfud08   LIKE fbf_file.fbfud08,
                      fbfud09   LIKE fbf_file.fbfud09,
                      fbfud10   LIKE fbf_file.fbfud10,
                      fbfud11   LIKE fbf_file.fbfud11,
                      fbfud12   LIKE fbf_file.fbfud12,
                      fbfud13   LIKE fbf_file.fbfud13,
                      fbfud14   LIKE fbf_file.fbfud14,
                      fbfud15   LIKE fbf_file.fbfud15
                     END RECORD,
       g_fbf082      LIKE fbf_file.fbf082,   #TQC-C50162 add
       g_fbf092      LIKE fbf_file.fbf092,   #TQC-C50162 add
       g_fbf08       LIKE fbf_file.fbf08,
       g_fbf10       LIKE fbf_file.fbf10,
       g_fbf11       LIKE fbf_file.fbf11,
       g_fbf112      LIKE fbf_file.fbf112, #NO:FUN-B90096 add
       g_fbf12       LIKE fbf_file.fbf12,
       g_fah         RECORD LIKE fah_file.*,
       t_azi         RECORD LIKE azi_file.*,          #No.CHI-6A0004 l_azi-->t_azi 
       g_faj40       LIKE faj_file.faj40,
       g_faj42       LIKE faj_file.faj42,
       g_faj26       LIKE faj_file.faj26,
       g_occ02       LIKE occ_file.occ02,      #Genero add
       g_occ02_1     LIKE occ_file.occ02,      #Genero add
       g_argv1       LIKE fbe_file.fbe01,      #No.FUN-680070 VARCHAR(16)
       g_argv2       STRING,                   # 指定執行功能:query or inser  #TQC-630073
       g_wc,g_wc2    STRING,                   #No.FUN-580092 HCN
       g_sql         STRING,                   #No.FUN-580092 HCN
       g_cmd         LIKE type_file.chr1000,   #No.FUN-680070 VARCHAR(200)
       g_t1          LIKE type_file.chr5,      #No.FUN-550034               #No.FUN-680070 VARCHAR(5)
       g_rec_b       LIKE type_file.num5,      #單身筆數                    #No.FUN-680070 SMALLINT
       l_ac          LIKE type_file.num5,      #目前處理的ARRAY CNT         #No.FUN-680070 SMALLINT
       l_modify_flag LIKE type_file.chr1,      #No.FUN-680070 VARCHAR(1)
       l_fbf04       LIKE fbf_file.fbf04,
       l_fbf04_1     LIKE fbf_file.fbf04       #MOD-8B0025 add
DEFINE g_bookno1     LIKE aza_file.aza81       #No.FUN-740033
DEFINE g_bookno2     LIKE aza_file.aza82       #No.FUN-740033
DEFINE g_flag        LIKE type_file.chr1       #No.FUN-740033
DEFINE g_laststage   LIKE type_file.chr1       #FUN-580109                  #No.FUN-680070 VARCHAR(1)
DEFINE p_row,p_col   LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql  STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5 #No.FUN-680070 SMALLINT
DEFINE l_fbe00       LIKE fbe_file.fbeconf     #No.MOD-510142 add           #No.FUN-680070 VARCHAR(1)
DEFINE g_chr         LIKE type_file.chr1       #No.FUN-680070 VARCHAR(1)
DEFINE g_chr2        LIKE type_file.chr1       #FUN-580109                  #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt         LIKE type_file.num10      #No.FUN-680070 INTEGER
DEFINE g_i           LIKE type_file.num5       #count/index for any purpose #No.FUN-680070 SMALLINT
DEFINE g_msg         LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(72)
DEFINE g_str         STRING                    #No.FUN-670060
DEFINE g_wc_gl       STRING                    #No.FUN-670060
DEFINE g_dbs_gl      LIKE type_file.chr21      #No.FUN-670060             #No.FUN-680070 VARCHAR(21)
DEFINE g_row_count   LIKE type_file.num10      #No.FUN-680070 INTEGER
DEFINE g_curs_index  LIKE type_file.num10      #No.FUN-680070 INTEGER
DEFINE g_jump        LIKE type_file.num10      #No.FUN-680070 INTEGER
DEFINE mi_no_ask     LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE g_fbf07       LIKE fbf_file.fbf07       #MOD-760135
DEFINE g_fbf072       LIKE fbf_file.fbf072     #NO:FUN-B90096 add
#-----NO:FUN-B90096 start--
DEFINE g_fbf2         DYNAMIC ARRAY OF RECORD 
                      fbf02     LIKE fbf_file.fbf02,
                      fbf03     LIKE fbf_file.fbf03,
                      fbf031    LIKE fbf_file.fbf031,
                      faj06     LIKE faj_file.faj06,
                      faj18     LIKE faj_file.faj18,
                      fbf04     LIKE fbf_file.fbf04,
                      fbf06    LIKE fbf_file.fbf06,
                      fbf072    LIKE fbf_file.fbf072,
                      fbf082    LIKE fbf_file.fbf082,
                      fbf112    LIKE fbf_file.fbf112,
                      fbf092    LIKE fbf_file.fbf092
                      END RECORD,
       g_fbf2_t       RECORD
                      fbf02     LIKE fbf_file.fbf02,
                      fbf03     LIKE fbf_file.fbf03,
                      fbf031    LIKE fbf_file.fbf031,
                      faj06     LIKE faj_file.faj06,
                      faj18     LIKE faj_file.faj18,
                      fbf04     LIKE fbf_file.fbf04,
                      fbf06    LIKE fbf_file.fbf06,
                      fbf072    LIKE fbf_file.fbf072,
                      fbf082    LIKE fbf_file.fbf082,
                      fbf112    LIKE fbf_file.fbf112,
                      fbf092    LIKE fbf_file.fbf092
                      END RECORD
#-----NO:FUN-B90096 end----
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
 
MAIN
 
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS
           INPUT NO WRAP
    END IF
 
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("AFA")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = " SELECT * FROM fbe_file WHERE fbe01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2) #TQC-630073
    LET l_fbe00='4'                          #出售 #No.MOD-510142

   #CHI-C60010--add--str--
    SELECT aaa03 INTO g_faj143 FROM aaa_file
     WHERE aaa01 = g_faa.faa02c
    IF NOT cl_null(g_faj143) THEN
       SELECT azi04 INTO g_azi04_1 FROM azi_file
        WHERE azi01 = g_faj143
    END IF
   #CHI-C60010--add—end---
 
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
       LET p_row = 3 LET p_col = 6
       OPEN WINDOW t110_w AT p_row,p_col
            WITH FORM "afa/42f/afat110"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       
       CALL cl_ui_init()
       #-----No:FUN-B60140-----
       IF g_faa.faa31 = 'Y' THEN
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",TRUE)  #NO:FUN-B90096 add  
          CALL cl_set_comp_visible("fbe142,fbe152",TRUE)
       ELSE
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",FALSE) #NO:FUN-B90096 add
          CALL cl_set_comp_visible("fbe142,fbe152",FALSE)
       END IF
       #-----No:FUN-B60140 END-----
    END IF
 
    IF fgl_getenv('EASYFLOW') = "1" THEN
       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
    END IF
 
    #建立簽核模式時的 toolbar icon
    CALL aws_efapp_toolbar()

   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t110_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t110_a()
            END IF
         WHEN "efconfirm"
            CALL t110_q()
            CALL t110_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t110_y_upd()       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t110_q()
      END CASE
   END IF
 
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm,   #FUN-D20035 add--undo_void
                               easyflow_approval, auto_generate, recount, entry_sheet, gen_entry, post, undo_post, 
                               entry_sheet2,fin_audit2, 
                               amend_depr_tax, post_depr_tax, undo_post_depr_tax, gen_acct, account_post, carry_voucher, undo_carry_voucher") #TQC-740222 #FUN-C30140 
         RETURNING g_laststage
 
    CALL t110_menu()
    CLOSE WINDOW t110_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
END MAIN
 
FUNCTION t110_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  CLEAR FORM                                    #清除畫面
  CALL g_fbf.clear()
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " fbe01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
    CALL cl_set_head_visible("","YES")            #No.FUN-6B0029 
 
   INITIALIZE g_fbe.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
       fbe01,fbe02,fbe03,fbe04,fbe05,fbe06,fbe07,fbe071,fbe072,fbe073,
       fbe11,fbe14,fbe15,fbe142,fbe152,fbe16,fbe17,fbeconf,fbepost,fbeuser,fbegrup,fbeoriu,fbeorig,fbemodu,   #MOD-4A0114 #No:FUN-B60140  #No.TQC-C10113 add oriu,orig
       fbedate,fbe08,fbe08x,fbe08t,fbe09,fbe09x,fbe09t,fbe10
      ,fbemksg,fbe18,    #FUN-580109
       fbeud01,fbeud02,fbeud03,fbeud04,fbeud05,
       fbeud06,fbeud07,fbeud08,fbeud09,fbeud10,
       fbeud11,fbeud12,fbeud13,fbeud14,fbeud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
       ON ACTION controlp
          CASE
             WHEN INFIELD(fbe01) #查詢單据

                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_fbe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbe01
                  NEXT FIELD fbe01
             WHEN INFIELD(fbe03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbe03
                  NEXT FIELD fbe03
             WHEN INFIELD(fbe04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbe04
                  NEXT FIELD fbe04
             WHEN INFIELD(fbe05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbe05
                  NEXT FIELD fbe05
             WHEN INFIELD(fbe07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gec"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = '2'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbe07
                  NEXT FIELD fbe07
             WHEN INFIELD(fbe16)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbe16
                  NEXT FIELD fbe16
             WHEN INFIELD(fbe17)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbe17
                  NEXT FIELD fbe17
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON fbf02,fbf03,fbf031,faj06,faj18,fbf04,fbf05,faj15,fbf06,          #CHI-D10032 add faj15
                       fbf07,fbf08,fbf11,fbf09           #No:A099
                       ,fbfud01,fbfud02,fbfud03,fbfud04,fbfud05
                       ,fbfud06,fbfud07,fbfud08,fbfud09,fbfud10
                       ,fbfud11,fbfud12,fbfud13,fbfud14,fbfud15
                  FROM s_fbf[1].fbf02, s_fbf[1].fbf03,
                       s_fbf[1].fbf031,s_fbf[1].faj06,s_fbf[1].faj18,
                       s_fbf[1].fbf04, s_fbf[1].fbf05,s_fbf[1].faj15, s_fbf[1].fbf06,   #CHI-D10032 add faj15
                       s_fbf[1].fbf07, s_fbf[1].fbf08, s_fbf[1].fbf11,  #No:A099
                       s_fbf[1].fbf09
                       ,s_fbf[1].fbfud01,s_fbf[1].fbfud02,s_fbf[1].fbfud03
                       ,s_fbf[1].fbfud04,s_fbf[1].fbfud05,s_fbf[1].fbfud06
                       ,s_fbf[1].fbfud07,s_fbf[1].fbfud08,s_fbf[1].fbfud09
                       ,s_fbf[1].fbfud10,s_fbf[1].fbfud11,s_fbf[1].fbfud12
                       ,s_fbf[1].fbfud13,s_fbf[1].fbfud14,s_fbf[1].fbfud15
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(fbf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_faj"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbf03
                  NEXT FIELD fbf03
             WHEN INFIELD(fbf031)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_faj"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbf031
                  NEXT FIELD fbf031
             WHEN INFIELD(fbf05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fag"
                  LET g_qryparam.state = "c"
                   LET g_qryparam.arg1 = l_fbe00 CLIPPED     #No.MOD-510142
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbf05
                  NEXT FIELD fbf05
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
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

  END IF
 
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fbeuser', 'fbegrup')
 
 
  IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
     LET g_sql = "SELECT fbe01, fbe01 FROM fbe_file",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY 2"
  ELSE					# 若單身有輸入條件
     LET g_sql = "SELECT UNIQUE fbe_file.fbe01, fbe01 ",
                 "  FROM fbe_file, fbf_file",
                 " WHERE fbe01 = fbf01",
                 "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 " ORDER BY 2"
  END IF
  PREPARE t110_prepare FROM g_sql
  DECLARE t110_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t110_prepare
 
  IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM fbe_file WHERE ",g_wc CLIPPED
  ELSE
      LET g_sql="SELECT COUNT(DISTINCT fbe01) FROM fbe_file,fbf_file WHERE ",
                "fbf01=fbe01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
  END IF
  PREPARE t110_prcount FROM g_sql
  DECLARE t110_count CURSOR WITH HOLD FOR t110_prcount
END FUNCTION
 
FUNCTION t110_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人 #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員      #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINE l_cmd        LIKE type_file.chr1000        # FUN-C30102
   DEFINE l_npq21      LIKE npq_file.npq21   #TQC-C60120  add
 
   LET l_flowuser = "N"   #FUN-580109
 
   WHILE TRUE
      CALL t110_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t110_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t110_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t110_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t110_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t110_out()
            END IF
         #NO:7382 add 發票查詢
         WHEN "invoice_qry"
             IF cl_chk_act_auth() THEN
                CALL t110_9()
             END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_generate" #自動產生
            IF cl_chk_act_auth() THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbe.fbe18) AND g_fbe.fbe18 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                    CALL t110_g()
                    CALL t110_b()
                END IF #FUN-C30140 add
            END IF
         WHEN "recount"       #重新計算帳值
            IF cl_chk_act_auth() THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbe.fbe18) AND g_fbe.fbe18 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                    CALL t110_m()
                    CALL t110_show()
                END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet"   #分錄底稿
            IF cl_chk_act_auth() AND not cl_null(g_fbe.fbe01) THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbe.fbe18) AND g_fbe.fbe18 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                    CALL s_fsgl('FA',4,g_fbe.fbe01,0,g_faa.faa02b,1,g_fbe.fbeconf,'0',g_faa.faa02p)     #No.FUN-680028
                END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() AND not cl_null(g_fbe.fbe01) THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbe.fbe18) AND g_fbe.fbe18 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                    CALL s_fsgl('FA',4,g_fbe.fbe01,0,g_faa.faa02c,1,g_fbe.fbeconf,'1',g_faa.faa02p)     #No.FUN-680028
                END IF #FUN-C30140 add
            END IF
         WHEN "gen_entry"     #分錄底稿產生
            IF cl_chk_act_auth() AND g_fbe.fbeconf <> 'X' THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbe.fbe18) AND g_fbe.fbe18 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                    SELECT fbepost INTO g_fbe.fbepost FROM fbe_file
                    WHERE fbe01 = g_fbe.fbe01
                    IF not cl_null(g_fbe.fbe14) THEN
                       CALL cl_err(g_fbe.fbe01,'afa-303',0)
                    ELSE
                       IF g_fbe.fbeconf = 'N' THEN   #MOD-690081
                          LET g_success='Y' #no.5573
                          BEGIN WORK #no.5573
                          CALL s_showmsg_init()    #No.FUN-710028
                          CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'0')
                         #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN     #FUN-AB0088 mark
                          IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND cl_null(g_fbe.fbe142) THEN     #FUN-AB0088 add     #No:FUN-B60140
                             CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'1')
                          END IF
                          CALL s_showmsg() #No.FUN-710028
                          IF g_success='Y' THEN
                             COMMIT WORK
                          ELSE
                             ROLLBACK WORK
                          END IF #no.5573
                       ELSE   #MOD-690081
                          CALL cl_err(g_fbe.fbe01,'afa-350',0)   #MOD-690081
                       END IF
                    END IF
                END IF #FUN-C30140 add
            END IF
         #-----NO:FUN-B90096 start--
         WHEN "fin_audit2"
            IF cl_chk_act_auth() THEN
               CALL t110_fin_audit2()
            END IF         
         #-----NO:FUN-B90096 end----
         WHEN "void"           #作廢
            IF cl_chk_act_auth() THEN
              #CALL t110_x()           #FUN-D20035
               CALL t110_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t110_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"        #確認
            IF cl_chk_act_auth() THEN
               #TQC-C60120--add--str--
               IF g_faa.faa31 = 'Y' AND cl_null(g_fbe.fbe142) THEN
                  SELECT DISTINCT(npq21) INTO l_npq21 FROM npq_file WHERE npq01 = g_fbe.fbe01 AND npqtype='1'
               ELSE
                  SELECT DISTINCT(npq21) INTO l_npq21 FROM npq_file WHERE npq01 = g_fbe.fbe01 AND npqtype='0'
               END IF
               IF l_npq21 != g_fbe.fbe03 THEN
                  IF cl_confirm('aap-944') THEN
                     CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'0')
                     IF g_faa.faa31 = 'Y' AND cl_null(g_fbe.fbe142) THEN
                        CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'1') 
                     END IF   
                  END IF
               END IF
               #TQC-C60120--add--end--  

               CALL t110_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t110_y_upd()       #CALL 原確認的 update 段
               END IF
            END IF
         WHEN "undo_confirm"   #取消確認
            IF cl_chk_act_auth() THEN
               CALL t110_z()
            END IF
         WHEN "carry_voucher"  #拋轉傳票
            IF cl_chk_act_auth() THEN
               IF g_fbe.fbepost = 'Y' THEN     #No.FUN-680028
                 CALL t110_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-557',1)
               END IF
            END IF
         WHEN "undo_carry_voucher"   #傳票拋轉還原
            IF cl_chk_act_auth() THEN
               IF g_fbe.fbepost = 'Y' THEN     #No.FUN-680028
                  CALL t110_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-558',1)     #No.FUN-680028
               END IF
            END IF
         WHEN "post"           #過帳
            IF cl_chk_act_auth() THEN
               CALL t110_s('S')
            END IF
         WHEN "account_post"   #會計過帳
            IF cl_chk_act_auth() THEN
               CALL t110_s('T')
            END IF
         WHEN "undo_post"      #過帳還原
            IF cl_chk_act_auth() THEN
               CALL t110_w()
            END IF
         WHEN "amend_depr_tax" #稅簽修改
            IF cl_chk_act_auth() THEN
               CALL t110_k()
            END IF
         WHEN "post_depr_tax"  #稅簽過帳
            IF cl_chk_act_auth() THEN
               CALL t110_6()
            END IF
         WHEN "undo_post_depr_tax"   #稅簽還原
            IF cl_chk_act_auth() THEN
               CALL t110_7()
            END IF
         WHEN "gen_acct"       #產生帳款
            IF cl_chk_act_auth() THEN
                IF cl_null(g_fbe.fbe11) THEN   #MOD-530824
                   IF NOT cl_null(g_fbe.fbe01) AND g_fbe.fbepost = 'Y' THEN   #MOD-530824
                     #-MOD-B40044-add-
                      IF cl_null(g_fbe.fbe03) THEN
                         CALL cl_err(g_fbe.fbe01,'axm-267',0)
                      ELSE
                     #-MOD-B40044-end-
                         LET g_cmd = "afap130  '' '",g_fbe.fbe01,"' "  
                         CALL cl_cmdrun_wait(g_cmd)
                         SELECT fbe11 INTO g_fbe.fbe11 FROM fbe_file WHERE fbe01 = g_fbe.fbe01   #FUN-5B0100
                         DISPLAY BY NAME g_fbe.fbe11
                      END IF    #MOD-B40044 
                   ELSE   #MOD-530824
                      CALL cl_err(g_fbe.fbe01,'aim-206',0)   #MOD-530824
                   END IF
                ELSE    #MOD-530824
                   CALL cl_err(g_fbe.fbe01,'axm-502',0)   #MOD-530824
                END IF   #MOD-530824
            END IF
#No.MOD-C30758 --begin
          WHEN "undo_acct"
             IF cl_chk_act_auth() THEN
                IF NOT cl_null(g_fbe.fbe11) THEN
                         CALL t110_undo_acct()
                         DISPLAY BY NAME g_fbe.fbe11
                END IF
             END IF
#No.MOD-C30758 --end
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fbe.fbe01 IS NOT NULL THEN
                  LET g_doc.column1 = "fbe01"
                  LET g_doc.value1 = g_fbe.fbe01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fbf),'','')
            END IF
        #@WHEN "簽核狀況"
        WHEN "approval_status"
             IF cl_chk_act_auth() THEN  #DISPLAY ONLY
                IF aws_condition2() THEN
                   CALL aws_efstat2()
                END IF
             END IF
 
        ##EasyFlow送簽
        WHEN "easyflow_approval"
             IF cl_chk_act_auth() THEN
               #FUN-C20012 add str---
                SELECT * INTO g_fbe.* FROM fbe_file
                 WHERE fbe01 = g_fbe.fbe01
                CALL t110_show()
                CALL t110_b_fill(' 1=1')
               #FUN-C20012 add end---
                CALL t110_ef()
                CALL t110_show()  #FUN-C20012 add
             END IF
 
        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有>
                CALL t110_y_upd()      #CALL 原確認的 update 段
             ELSE
                LET g_success = "Y"
                IF NOT aws_efapp_formapproval() THEN
                   LET g_success = "N"
                END IF
             END IF
             IF g_success = 'Y' THEN
                IF cl_confirm('aws-081') THEN
                   IF aws_efapp_getnextforminfo() THEN
                      LET l_flowuser = 'N'
                      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                      IF NOT cl_null(g_argv1) THEN
                         CALL t110_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                         CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,confirm, undo_confirm,  #FUN-D20035 add--undo_void
                                                    easyflow_approval, auto_generate, recount, entry_sheet, gen_entry, post, undo_post, 
                                                    entry_sheet2,fin_audit2, 
                                                    amend_depr_tax, post_depr_tax, undo_post_depr_tax, gen_acct, account_post, carry_voucher, undo_carry_voucher") #TQC-740222 #FUN-C30140 
                              RETURNING g_laststage
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                ELSE
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "不准"
        WHEN "deny"
            IF ( l_creator := aws_efapp_backflow()) IS NOT NULL THEN
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_fbe.fbe18 = 'R'
                     DISPLAY BY NAME g_fbe.fbe18
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t110_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行>
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,confirm, undo_confirm,   #FUN-D20035 add--undo_void
                                                      easyflow_approval, auto_generate, recount, entry_sheet, gen_entry, post, undo_post, 
                                                      entry_sheet2,fin_audit2, 
                                                      amend_depr_tax, post_depr_tax, undo_post_depr_tax, gen_acct, account_post, carry_voucher, undo_carry_voucher") #TQC-740222 #FUN-C30140
                                RETURNING g_laststage
                        ELSE
                           EXIT WHILE
                        END IF
                     ELSE
                        EXIT WHILE
                     END IF
                  ELSE
                     EXIT WHILE
                  END IF
               END IF
             END IF
 
        #@WHEN "加簽"
        WHEN "modify_flow"
             IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                LET l_flowuser = 'Y'
             ELSE
                LET l_flowuser = 'N'
             END IF
 
        #@WHEN "撤簽"
        WHEN "withdraw"
             IF cl_confirm("aws-080") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "抽單"
        WHEN "org_withdraw"
             IF cl_confirm("aws-079") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "簽核意見"
        WHEN "phrase"
             CALL aws_efapp_phrase()
 
        #FUN-C30102-Add Begin---
        WHEN "qry_oma"
            IF cl_chk_act_auth() AND NOT cl_null(g_fbe.fbe11) THEN
               LET l_cmd = "axrt300", " '",g_fbe.fbe11,"' '' ''"
               DISPLAY l_cmd
               CALL cl_cmdrun_wait(l_cmd)
            END IF
        #FUN-C30102 Add End----- 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t110_a()
    DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    DEFINE ll_gen02    LIKE  gen_file.gen02        #NO.FUN-840111
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fbf.clear()
    INITIALIZE g_fbe.* TO NULL
    LET g_fbe_o.* = g_fbe.*
    LET g_fbe_t.* = g_fbe.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fbe.fbe12  ='N'
        LET g_fbe.fbe02  =g_today
        LET g_fbe.fbepost='N' LET g_fbe.fbepost2='N'
        LET g_fbe.fbeconf='N'
        LET g_fbe.fbeuser=g_user
        LET g_fbe.fbeoriu = g_user #FUN-980030
        LET g_fbe.fbeorig = g_grup #FUN-980030
        LET g_fbe.fbegrup=g_grup
        LET g_fbe.fbedate=g_today
        LET g_fbe.fbemksg = "N"   #FUN-580109
        LET g_fbe.fbe18 = "0"     #FUN-580109
        LET g_fbe.fbelegal= g_legal    #FUN-980003 add
 
        LET g_fbe.fbe16 = g_user
        SELECT gen02 INTO ll_gen02 FROM gen_file
         WHERE gen01 = g_fbe.fbe16
        DISPLAY ll_gen02 TO FORMONLY.gen02
        SELECT gen03 INTO g_fbe.fbe17 FROM gen_file
        WHERE gen01 = g_fbe.fbe16
        DISPLAY BY NAME g_fbe.fbe17
        
        CALL t110_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_fbe.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_fbe.fbe01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK  #No:7837
        CALL s_auto_assign_no("afa",g_fbe.fbe01,g_fbe.fbe02,"4","fbe_file","fbe01","","","")
             RETURNING li_result,g_fbe.fbe01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fbe.fbe01

        IF g_fbe.fbe08 IS NULL THEN LET g_fbe.fbe08=0 END IF
        IF g_fbe.fbe08x IS NULL THEN LET g_fbe.fbe08x=0 END IF
        IF g_fbe.fbe08t IS NULL THEN LET g_fbe.fbe08t=0 END IF
        IF g_fbe.fbe09 IS NULL THEN LET g_fbe.fbe09=0 END IF
        IF g_fbe.fbe09x IS NULL THEN LET g_fbe.fbe09x=0 END IF
        IF g_fbe.fbe09t IS NULL THEN LET g_fbe.fbe09t=0 END IF
        IF g_fbe.fbe10 IS NULL THEN LET g_fbe.fbe10=0 END IF
        INSERT INTO fbe_file VALUES (g_fbe.*)
        IF STATUS THEN
           CALL cl_err3("ins","fbe_file",g_fbe.fbe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           ROLLBACK WORK  #No:7837
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No:7837
           CALL cl_flow_notify(g_fbe.fbe01,'I')
        END IF
        SELECT fbe01 INTO g_fbe.fbe01 FROM fbe_file WHERE fbe01 = g_fbe.fbe01
        LET g_fbe_t.* = g_fbe.*
        CALL g_fbf.clear()
        LET g_rec_b = 0
        CALL t110_g()                      #輸入單身
        CALL t110_b()                      #輸入單身
        CALL t110_upd('a')                 #update 單頭資料
        #---判斷是否直接列印,確認,過帳---------
         LET g_t1 = s_get_doc_no(g_fbe.fbe01)  #No.FUN-550034
        SELECT fahprt,fahconf,fahpost,fahapr 
             INTO g_fahprt,g_fahconf,g_fahpost,g_fahapr
        FROM fah_file
        WHERE fahslip = g_t1
        IF g_fahprt  = 'Y' THEN
           IF NOT cl_confirm('afa-128') THEN RETURN END IF
           CALL t110_out()
        END IF
        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
           CALL t110_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t110_y_upd()       #CALL 原確認的 update 段
           END IF
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t110_s('S')
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t110_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
    IF g_fbe.fbeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbe.fbeconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbe.fbepost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbe.fbe18 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fbe_o.* = g_fbe.*
    BEGIN WORK
 
    OPEN t110_cl USING g_fbe.fbe01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
    CALL t110_show()
    WHILE TRUE
        LET g_fbe.fbemodu=g_user
        LET g_fbe.fbedate=g_today
        CALL t110_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fbe.*=g_fbe_t.*
            CALL t110_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_fbe.fbe18 = '0'   #FUN-580109
        UPDATE fbe_file SET * = g_fbe.* WHERE fbe01 = g_fbe.fbe01
        IF STATUS THEN 
           CALL cl_err3("upd","fbe_file",g_fbe_t.fbe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE 
        END IF
        CALL t110_upd('u')                 #update 單頭資料
        DISPLAY BY NAME g_fbe.fbe18
        IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fbe.fbe18 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fbe.fbeconf,g_chr2,g_fbe.fbepost,"",g_chr,"")
        EXIT WHILE
    END WHILE
    CLOSE t110_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbe.fbe01,'U')
END FUNCTION
 
FUNCTION t110_i(p_cmd)
  DEFINE p_cmd        LIKE type_file.chr1   #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
  DEFINE l_flag       LIKE type_file.chr1   #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
  DEFINE l_yy,l_mm    LIKE type_file.num5   #No.FUN-680070 SMALLINT
  DEFINE l_fbe06      LIKE fbe_file.fbe06
  DEFINE li_result    LIKE type_file.num5   #No.FUN-680070 SMALLINT
  DEFINE l_gen02      LIKE gen_file.gen02   #MOD-4A0114
  DEFINE l_gem02      LIKE gem_file.gem02   #MOD-4A0114
  DEFINE l_bdate,l_edate LIKE type_file.dat      #No.MOD-840375  DATE
 
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0029 
 
    INPUT BY NAME g_fbe.fbeoriu,g_fbe.fbeorig,
        g_fbe.fbe01,g_fbe.fbe02,g_fbe.fbe03,g_fbe.fbe031,g_fbe.fbe04,g_fbe.fbe041,g_fbe.fbe05,#FUN-910117 add fbe031,fbe041
        g_fbe.fbe06,g_fbe.fbe07,g_fbe.fbe071,g_fbe.fbe072,g_fbe.fbe073,
        g_fbe.fbe11,g_fbe.fbe14,g_fbe.fbe15,g_fbe.fbe142,g_fbe.fbe152,  #No:FUN-B60140
        g_fbe.fbe16,g_fbe.fbe17,g_fbe.fbeconf,g_fbe.fbepost,   #MOD-4A0114
        g_fbe.fbepost2,
        g_fbe.fbemksg,g_fbe.fbe18,   #FUN-580109
        g_fbe.fbeuser,g_fbe.fbegrup,g_fbe.fbemodu,
        g_fbe.fbedate,g_fbe.fbe08x,g_fbe.fbe09x,
        g_fbe.fbeud01,g_fbe.fbeud02,g_fbe.fbeud03,g_fbe.fbeud04,
        g_fbe.fbeud05,g_fbe.fbeud06,g_fbe.fbeud07,g_fbe.fbeud08,
        g_fbe.fbeud09,g_fbe.fbeud10,g_fbe.fbeud11,g_fbe.fbeud12,
        g_fbe.fbeud13,g_fbe.fbeud14,g_fbe.fbeud15 
           WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t110_set_entry(p_cmd)
           CALL t110_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
         CALL cl_set_docno_format("fbe01")
 
        AFTER FIELD fbe01
            IF NOT cl_null(g_fbe.fbe01) AND (g_fbe.fbe01 != g_fbe_t.fbe01 OR g_fbe_t.fbe01 IS NULL) THEN  #No.MOD-480332
    CALL s_check_no("afa",g_fbe.fbe01,"","4","fbe_file","fbe01","")
         RETURNING li_result,g_fbe.fbe01
    DISPLAY BY NAME g_fbe.fbe01
       IF (NOT li_result) THEN
          NEXT FIELD fbe01
       END IF

              LET g_t1 = s_get_doc_no(g_fbe.fbe01)    #No.FUN-550034
              SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1

           END IF
          #start FUN-580109 帶出單據別設定的"簽核否"值,狀況碼預設為0
           SELECT fahapr,'0' INTO g_fbe.fbemksg,g_fbe.fbe18
             FROM fah_file
            WHERE fahslip = g_t1
           IF cl_null(g_fbe.fbemksg) THEN            #FUN-640243
                LET g_fbe.fbemksg = 'N'
           END IF
           DISPLAY BY NAME g_fbe.fbemksg,g_fbe.fbe18
           LET g_fbe_o.fbe01 = g_fbe.fbe01
 
        AFTER FIELD fbe02
            IF NOT cl_null(g_fbe.fbe02) THEN
              CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate                                                       
             IF g_fbe.fbe02 < l_bdate THEN                                                                                         
                CALL cl_err(g_fbe.fbe02,'afa-130',0)                                                                               
                NEXT FIELD fbe02                                                                                                   
             END IF 
               IF g_fbe.fbe02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD fbe02
               END IF
               #-----No:FUN-B60140-----
               IF g_faa.faa31 = "Y" THEN
                  CALL s_azn01(g_faa.faa072,g_faa.faa082) RETURNING l_bdate,l_edate
                  IF g_fbe.fbe02 < l_bdate THEN
                     CALL cl_err(g_fbe.fbe02,'afa-130',0)
                     NEXT FIELD fbe02
                  END IF
                  IF g_fbe.fbe02 <= g_faa.faa092 THEN
                     CALL cl_err('','mfg9999',1)
                     NEXT FIELD fbe02
                  END IF
               END IF
               #-----No:FUN-B60140 END-----
               CALL s_get_bookno(YEAR(g_fbe.fbe02))    #TQC-740042
                    RETURNING g_flag,g_bookno1,g_bookno2
               IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF #MOD-BC0114
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_fbe.fbe02,'aoo-081',1)
                  NEXT FIELD fbe02 
               END IF
            END IF
 
        BEFORE FIELD fbe03
            CALL cl_set_comp_entry("fbe031",TRUE)
 
        AFTER FIELD fbe03
           #IF NOT cl_null(g_fbe.fbe03) AND p_cmd='a' THEN #MOD-B30602 mark
            IF NOT cl_null(g_fbe.fbe03) THEN               #MOD-B30602
               SELECT occ02,occ42,occ41 INTO g_occ02,g_fbe.fbe05,g_fbe.fbe07 FROM occ_file
                  WHERE occ01=g_fbe.fbe03
               IF STATUS=100 THEN 
                  LET g_fbe.fbe05='' 
                  LET g_fbe.fbe06=''
                  LET g_occ02=''
                  CALL cl_err(g_fbe.fbe03,'atm-381',0)  #MOD-B30602 add
                  NEXT FIELD fbe03                      #MOD-B30602 add
               END IF
               CALL s_curr3(g_fbe.fbe05,g_fbe.fbe02,g_faa.faa28) RETURNING g_fbe.fbe06
               DISPLAY g_fbe.fbe06 TO fbe06
               CALL t110_fbe07()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbe.fbe03,'afa-351',0)
               END IF
               LET g_fbe.fbe04=g_fbe.fbe03
            END IF
            DISPLAY g_fbe.fbe04 TO fbe04
            DISPLAY g_fbe.fbe05 TO fbe05
            DISPLAY g_fbe.fbe07 TO fbe07
            IF g_fbe.fbe03 != 'MISC' OR cl_null(g_fbe.fbe03) THEN
               CALL cl_set_comp_entry("fbe031",FALSE)
               IF NOT cl_null(g_fbe.fbe03) THEN
                  SELECT occ02 INTO g_fbe.fbe031 FROM occ_file
                   WHERE occ01=g_fbe.fbe03
                  DISPLAY g_fbe.fbe031 TO fbe031
                  IF p_cmd = 'a' THEN
                     LET g_fbe.fbe041  =g_occ02            
                     DISPLAY g_fbe.fbe041 TO fbe041     
                  END IF
               ELSE
                  LET g_fbe.fbe031 = ''
                  DISPLAY g_fbe.fbe031 TO fbe031
               END IF
            END IF
            #TQC-C60120--add--str--
            IF g_fbe_t.fbe03 != g_fbe.fbe03 THEN
               LET g_fbe_t.fbe03 = g_fbe.fbe03
               UPDATE fbe_file SET fbe03 = g_fbe.fbe03,fbe031 = g_fbe.fbe031 WHERE fbe01 = g_fbe.fbe01
               IF cl_confirm('aap-944') THEN
                  CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'0')
                  IF g_faa.faa31 = 'Y' AND cl_null(g_fbe.fbe142) THEN
                     CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'1')
                  END IF
               END IF
            END IF
            #TQC-C60120--add--end--     
            #MOD-CB0007 add begin-------------
            IF cl_null(g_fbe.fbe03) THEN
               CALL cl_err(g_fbe.fbe03,'afa1005',0)
            END IF
            #MOD-CB0007 add end---------------
 
        BEFORE FIELD fbe04
           CALL cl_set_comp_entry("fbe041",TRUE)
 
        AFTER FIELD fbe04
            IF g_fbe.fbe04 != 'MISC' OR cl_null(g_fbe.fbe04)THEN   #FUN-910117
                CALL cl_set_comp_entry("fbe041",FALSE)
               IF NOT cl_null(g_fbe.fbe04) THEN   #FUN-910117
                  SELECT occ02 INTO g_fbe.fbe041 FROM occ_file #FUN-910117
                   WHERE occ01=g_fbe.fbe04
                  IF STATUS=100 THEN 
                     LET g_occ02_1='' 
                     CALL cl_err(g_fbe.fbe04,'atm-381',0)  #MOD-B30602 add
                     NEXT FIELD fbe04                      #MOD-B30602 add
                  END IF
                  DISPLAY g_fbe.fbe041 TO fbe041     #FUN-910117
               ELSE  #FUN-910117
                  LET g_fbe.fbe041 = ''    #FUN-910117
                  DISPLAY g_fbe.fbe041 TO fbe041 #FUN-910117
               END IF
            END IF    #FUN-910117
 
        AFTER FIELD fbe05
            IF NOT cl_null(g_fbe.fbe05) THEN
               SELECT * INTO t_azi.* FROM azi_file WHERE azi01=g_fbe.fbe05        #No.CHI-6A0004 l_azi-->t_azi
               IF STATUS=100 THEN
                  CALL cl_err3("sel","azi_file",g_fbe.fbe05,"","afa-111","","",1)  #No.FUN-660136
                  NEXT FIELD fbe05
               ELSE
                  CALL s_curr3(g_fbe.fbe05,g_fbe.fbe02,g_faa.faa28) RETURNING g_fbe.fbe06
                  DISPLAY g_fbe.fbe06 TO fbe06 #
               END IF
            END IF
 
         AFTER FIELD fbe06                       #FUN-4C0032
             IF g_fbe.fbe05=g_aza.aza17 THEN
                LET g_fbe.fbe06=1
                DISPLAY g_fbe.fbe06 TO fbe06
             END IF
 
        AFTER FIELD fbe07
            IF NOT cl_null(g_fbe.fbe07) THEN
               CALL t110_fbe07()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbe.fbe07,'afa-112',0)
                  NEXT FIELD fbe07
               END IF
               CALL t110_upd('s')
            END IF
 
        AFTER FIELD fbe08x
            LET g_fbe.fbe08t=g_fbe.fbe08+g_fbe.fbe08x
            DISPLAY g_fbe.fbe08t TO fbe08t #
 
        AFTER FIELD fbe09x
            LET g_fbe.fbe09t=g_fbe.fbe09+g_fbe.fbe09x
            DISPLAY g_fbe.fbe09t TO fbe09t #
        AFTER FIELD fbe16
            SELECT gen02 INTO l_gen02 FROM gen_file
               WHERE gen01 = g_fbe.fbe16
            #MOD-B30602--add--str--
            IF SQLCA.sqlcode = 100 THEN
               CALL cl_err(g_fbe.fbe16,'aoo-070',0)
               NEXT FIELD fbe16
            END IF
            #MOD-B30602--add--end--
            DISPLAY l_gen02 TO FORMONLY.gen02
            SELECT gen03 INTO g_fbe.fbe17 FROM gen_file
               WHERE gen01 = g_fbe.fbe16
            DISPLAY BY NAME g_fbe.fbe17
 
        AFTER FIELD fbe17
            SELECT gem02 INTO l_gem02 FROM gem_file
               WHERE gem01 = g_fbe.fbe17
            #MOD-B30602--add--str--
            IF SQLCA.sqlcode = 100 THEN
               CALL cl_err(g_fbe.fbe17,'aoo-005',0)
               NEXT FIELD fbe17
            END IF
            #MOD-B30602--add--end--
            DISPLAY l_gem02 TO FORMONLY.gem02
 
        AFTER FIELD fbeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT   #97/05/22 modify
           LET g_fbe.fbeuser = s_get_data_owner("fbe_file") #FUN-C10039
           LET g_fbe.fbegrup = s_get_data_group("fbe_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fbe01) #查詢單据
                 LET g_t1 = s_get_doc_no(g_fbe.fbe01)    #No.FUN-550034
                  CALL q_fah( FALSE, TRUE,g_t1,'4','AFA')                      #TQC-670008            
                      RETURNING g_t1
                 LET g_fbe.fbe01= g_t1  #No.FUN-550034
                 DISPLAY BY NAME g_fbe.fbe01
                 NEXT FIELD fbe01
              WHEN INFIELD(fbe03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_fbe.fbe03
                 CALL cl_create_qry() RETURNING g_fbe.fbe03
                 DISPLAY BY NAME g_fbe.fbe03
                 NEXT FIELD fbe03
              WHEN INFIELD(fbe04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_fbe.fbe04
                 CALL cl_create_qry() RETURNING g_fbe.fbe04
                 DISPLAY BY NAME g_fbe.fbe04
                 NEXT FIELD fbe04
              WHEN INFIELD(fbe05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_fbe.fbe05
                 CALL cl_create_qry() RETURNING g_fbe.fbe05
                 DISPLAY BY NAME g_fbe.fbe05
                 NEXT FIELD fbe05
              WHEN INFIELD(fbe07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gec"
                 LET g_qryparam.default1 = g_fbe.fbe07
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_fbe.fbe07
                 DISPLAY BY NAME g_fbe.fbe07
                 NEXT FIELD fbe07
              WHEN INFIELD(fbe06)
                   CALL s_rate(g_fbe.fbe05,g_fbe.fbe06) RETURNING g_fbe.fbe06
                   DISPLAY BY NAME g_fbe.fbe06
                   NEXT FIELD fbe06
              WHEN INFIELD(fbe16)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_fbe.fbe16
                   CALL cl_create_qry() RETURNING g_fbe.fbe16
                   DISPLAY BY NAME g_fbe.fbe16
                   NEXT FIELD fbe16
              WHEN INFIELD(fbe17)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.default1 = g_fbe.fbe17
                   CALL cl_create_qry() RETURNING g_fbe.fbe17
                   DISPLAY BY NAME g_fbe.fbe17
                   NEXT FIELD fbe17
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION t110_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fbe01",TRUE)
   END IF
   CALL cl_set_comp_entry("fbe08x,fbe09x",TRUE)   #MOD-8B0025 add
   IF g_fbe.fbe03 = 'MISC' AND NOT cl_null(g_fbe.fbe03) THEN
      CALL cl_set_comp_entry("fbe031",TRUE)
   END IF
   IF g_fbe.fbe04 = 'MISC' AND NOT cl_null(g_fbe.fbe04) THEN
      CALL cl_set_comp_entry("fbe041",TRUE)
   END IF
 
END FUNCTION
FUNCTION t110_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
   CALL cl_set_comp_entry("fbe01",FALSE)
   END IF
  #新增時,表尾的fbe08x,fbe09x無須開放輸入
  #IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                   #MOD-D30031 mark
   IF (p_cmd = 'a' OR p_cmd = 'u') AND ( NOT g_before_input_done ) THEN  #MOD-D30031 add p_cmd = 'u'
      CALL cl_set_comp_entry("fbe08x,fbe09x",FALSE)
   END IF
   IF g_fbe.fbe03 != 'MISC' OR cl_null(g_fbe.fbe03) THEN
      CALL cl_set_comp_entry("fbe031",FALSE)
   END IF
   IF g_fbe.fbe04 != 'MISC' OR cl_null(g_fbe.fbe04) THEN
      CALL cl_set_comp_entry("fbe041",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION t110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fbe.* TO NULL             #No.FUN-6A0001   
    CALL cl_msg("")                              #FUN-640243
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t110_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_fbe.* TO NULL RETURN END IF
    CALL cl_msg(" SEARCHING ! ")                 #FUN-640243
    OPEN t110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fbe.* TO NULL
    ELSE
        OPEN t110_count
        FETCH t110_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t110_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640243
 
END FUNCTION
 
FUNCTION t110_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t110_cs INTO g_fbe.fbe01
        WHEN 'P' FETCH PREVIOUS t110_cs INTO g_fbe.fbe01
        WHEN 'F' FETCH FIRST    t110_cs INTO g_fbe.fbe01
        WHEN 'L' FETCH LAST     t110_cs INTO g_fbe.fbe01
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
            FETCH ABSOLUTE  g_jump t110_cs INTO g_fbe.fbe01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)
        INITIALIZE g_fbe.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fbe_file",g_fbe.fbe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fbe.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fbe.fbeuser   #FUN-4C0059
    LET g_data_group = g_fbe.fbegrup   #FUN-4C0059
    CALL s_get_bookno(YEAR(g_fbe.fbe02)) #TQC-740042
         RETURNING g_flag,g_bookno1,g_bookno2
    IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF #MOD-BC0114
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_fbe.fbe02,'aoo-081',1)
    END IF
    CALL t110_show()
END FUNCTION
 
FUNCTION t110_show()
     DEFINE l_gen02   LIKE gen_file.gen02,   #MOD-4A0114
            l_gem02   LIKE gem_file.gem02    #MOD-4A0114
 
    LET g_fbe_t.* = g_fbe.*                #保存單頭舊值
    DISPLAY BY NAME g_fbe.fbeoriu,g_fbe.fbeorig,
        g_fbe.fbe01,g_fbe.fbe02,g_fbe.fbe03,g_fbe.fbe04,g_fbe.fbe05,
        g_fbe.fbe06,g_fbe.fbe07,g_fbe.fbe08x,g_fbe.fbe09x,g_fbe.fbe11,
        g_fbe.fbe031,g_fbe.fbe041,     #FUN-910117
        g_fbe.fbe14,g_fbe.fbe15,g_fbe.fbe142,g_fbe.fbe152,g_fbe.fbe16,g_fbe.fbe17,   #MOD-4A0114 #No:FUN-B60140
        g_fbe.fbeconf,g_fbe.fbepost,g_fbe.fbepost2,
        g_fbe.fbemksg,g_fbe.fbe18,   #FUN-580109 增加簽核,狀況碼
        g_fbe.fbeuser,g_fbe.fbegrup,g_fbe.fbemodu,g_fbe.fbedate,
        g_fbe.fbeud01,g_fbe.fbeud02,g_fbe.fbeud03,g_fbe.fbeud04,
        g_fbe.fbeud05,g_fbe.fbeud06,g_fbe.fbeud07,g_fbe.fbeud08,
        g_fbe.fbeud09,g_fbe.fbeud10,g_fbe.fbeud11,g_fbe.fbeud12,
        g_fbe.fbeud13,g_fbe.fbeud14,g_fbe.fbeud15 
    SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01 = g_fbe.fbe16
    SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01 = g_fbe.fbe17
    DISPLAY l_gen02 TO FORMONLY.gen02
    DISPLAY l_gem02 TO FORMONLY.gem02
 
    IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fbe.fbe18 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fbe.fbeconf,g_chr2,g_fbe.fbepost,"",g_chr,"")
     LET g_t1 = s_get_doc_no(g_fbe.fbe01)   #No.FUN-550034
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    SELECT occ02 INTO g_occ02 FROM occ_file WHERE occ01=g_fbe.fbe03
    IF status THEN LET g_occ02='' END IF
    DISPLAY g_occ02 TO occ02
    SELECT occ02 INTO g_occ02_1 FROM occ_file WHERE occ01=g_fbe.fbe04
    IF status THEN LET g_occ02_1='' END IF
    DISPLAY g_occ02_1 TO occ02_1
    CALL t110_fbe07()
    CALL t110_show1()
    CALL t110_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t110_show1()
   DISPLAY BY NAME g_fbe.fbe08,g_fbe.fbe08x,g_fbe.fbe08t,
                   g_fbe.fbe09,g_fbe.fbe09x,g_fbe.fbe09t,
                   g_fbe.fbe10
END FUNCTION
 
#---- 取稅別稅率
FUNCTION t110_fbe07()
 DEFINE  l_gecacti  LIKE gec_file.gecacti
 
    LET g_errno=' '
    SELECT gec04,gec05,gec07,gecacti
      INTO g_fbe.fbe071,g_fbe.fbe072,g_fbe.fbe073,l_gecacti
      FROM gec_file WHERE gec01=g_fbe.fbe07 AND gec011 = '2'
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'
         WHEN l_gecacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    DISPLAY g_fbe.fbe071 TO fbe071
    DISPLAY g_fbe.fbe072 TO fbe072
    DISPLAY g_fbe.fbe073 TO fbe073
END FUNCTION
 
FUNCTION t110_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
    #-->已拋轉票不可刪除
    IF not cl_null(g_fbe.fbe14) THEN
       CALL cl_err('','afa-311',0) RETURN
    END IF
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       #-->已拋轉票不可刪除
       IF not cl_null(g_fbe.fbe142) THEN
          CALL cl_err('','afa-311',0) RETURN
       END IF
    END IF
    #-----No:FUN-B60140 END-----
    IF g_fbe.fbeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbe.fbeconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbe.fbepost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbe.fbe18 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t110_cl USING g_fbe.fbe01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_fbe.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)
       CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
    CALL t110_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fbe01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fbe.fbe01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fbe_file,fbf_file!"
        DELETE FROM fbe_file WHERE fbe01 = g_fbe.fbe01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","fbe_file",g_fbe.fbe01,"",SQLCA.sqlcode,"","del fbe",1)  #No.FUN-660136
           ROLLBACK WORK
           RETURN
        END IF
        DELETE FROM fbf_file WHERE fbf01 = g_fbe.fbe01
        DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 4
                               AND npp01 = g_fbe.fbe01
                               AND npp011= 1
        DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 4
                               AND npq01 = g_fbe.fbe01
                               AND npq011= 1
        #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_fbe.fbe01
        #FUN-B40056--add--end--
        LET g_msg=TIME
        CLEAR FORM
        CALL g_fbf.clear()
    	INITIALIZE g_fbe.* TO NULL
        MESSAGE ""
        OPEN t110_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t110_cl
           CLOSE t110_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        FETCH t110_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t110_cl
           CLOSE t110_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t110_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t110_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t110_fetch('/')
        END IF
 
    END IF
    CLOSE t110_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbe.fbe01,'D')
END FUNCTION
 
FUNCTION t110_b()
DEFINE l_ac_t           LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-680070 SMALLINT
       l_row,l_col      LIKE type_file.num5,  	  #分段輸入之行,列數  #No.FUN-680070 SMALLINT
       l_n,l_cnt        LIKE type_file.num5,      #檢查重複用         #No.FUN-680070 SMALLINT
       l_lock_sw        LIKE type_file.chr1,      #單身鎖住否         #No.FUN-680070 VARCHAR(1)
       p_cmd            LIKE type_file.chr1,      #處理狀態           #No.FUN-680070 VARCHAR(1)
       l_edate          LIKE type_file.dat,       #No.FUN-680070 DATE
       l_flag           LIKE type_file.num10,     #No.FUN-680070 INTEGER
       l_faj14          LIKE faj_file.faj14,
       l_faj141         LIKE faj_file.faj141,
       l_faj17          LIKE faj_file.faj17,
       l_faj32          LIKE faj_file.faj32,
       l_faj60          LIKE faj_file.faj60,      #MOD-A40148 add
       l_faj58          LIKE faj_file.faj58,
       l_faj59          LIKE faj_file.faj59,
       l_faj09          LIKE faj_file.faj09,      #MOD-990191 add
       l_fbf08          LIKE fbf_file.fbf08,      #No.FUN-4C0008
       l_fbf10          LIKE fbf_file.fbf10,
       l_fbf11          LIKE fbf_file.fbf11,      #No:A099
       l_fbf12          LIKE fbf_file.fbf12,      #No:A099
       l_fbf09          LIKE fbf_file.fbf09,      #No.FUN-4C0008
       l_dis            LIKE type_file.num20_6,   #No.FUN-4C0008  #No.FUN-680070 DEC(20,6)
       l_allow_insert   LIKE type_file.num5,      #可新增否       #No.FUN-680070 SMALLINT
       l_allow_delete   LIKE type_file.num5,      #可刪除否       #No.FUN-680070 SMALLINT
       l_fbe18          LIKE fbe_file.fbe18,      #FUN-580109
       l_fbf            RECORD LIKE fbf_file.*,   #CHI-870008 add
       l_fbf02          LIKE fbf_file.fbf02,      #CHI-870008 add
       l_fbf07          LIKE fbf_file.fbf07,      #CHI-870008 add
       l_tax,l_sumtax   LIKE fbe_file.fbe09x,     #CHI-870008 add
       l_chg            LIKE type_file.chr1       #MOD-9C0385 add
   #MOD-BB0041 -- begin --
   DEFINE l_faj33          LIKE faj_file.faj33,
          l_faj331         LIKE faj_file.faj331
   #MOD-BB0041 -- end --
   #TQC-C50162--add--str
   DEFINE l_fbf112         LIKE fbf_file.fbf112
   DEFINE l_fbf082         LIKE fbf_file.fbf082
   DEFINE l_fbf092         LIKE fbf_file.fbf092
   #TQC-C50162--add--end
   DEFINE l_aaa03          LIKE faj_file.faj143, #MOD-BC0129 add
          l_rate           LIKE faj_file.faj144  #MOD-BC0129 add
 
    # Hiko : 這是一定要的啦.
    LET g_action_choice = NULL
    LET l_fbe18 = g_fbe.fbe18   #FUN-580109
    LET l_chg = 'N'   #MOD-9C0385 add
 
    IF g_fbe.fbe01 IS NULL THEN RETURN END IF
    IF g_fbe.fbeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbe.fbeconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbe.fbepost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbe.fbe18 matches '[Ss]' THEN CALL cl_err('','apm-030',0) RETURN END IF   #FUN-580109
 
    CALL cl_opmsg('b')
 

    SELECT * INTO t_azi.* FROM azi_file WHERE azi01=g_fbe.fbe05
    IF SQLCA.SQLCODE THEN
       LET t_azi.azi04=g_azi04
    END IF
 
    LET g_forupd_sql = " SELECT fbf02,fbf03,fbf031,'','',fbf04,fbf05,'',fbf06,",       #CHI-D10032 add ''
                       "        fbf07,fbf08,fbf11,fbf09, ",                            #end No:A099
                       "        fbfud01,fbfud02,fbfud03,fbfud04,fbfud05,",
                       "        fbfud06,fbfud07,fbfud08,fbfud09,fbfud10,",
                       "        fbfud11,fbfud12,fbfud13,fbfud14,fbfud15 ", 
                       "   FROM fbf_file  ",
                       "  WHERE fbf01=? AND fbf02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_fbf.clear() END IF
 
    INPUT ARRAY g_fbf WITHOUT DEFAULTS FROM s_fbf.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'                   #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           OPEN t110_cl USING g_fbe.fbe01
           IF STATUS THEN
              CALL cl_err("OPEN t110_cl:", STATUS, 1)
              CLOSE t110_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
              CLOSE t110_cl ROLLBACK WORK RETURN
           END IF
           IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_fbf_t.* = g_fbf[l_ac].*  #BACKUP
               LET l_modify_flag='Y'
 
               OPEN t110_bcl USING g_fbe.fbe01,g_fbf_t.fbf02
               IF STATUS THEN
                  CALL cl_err("OPEN t110_bcl:", STATUS, 1)
                  CLOSE t110_bcl
                  ROLLBACK WORK
                  LET l_lock_sw = "Y"
                  RETURN
               ELSE
                  FETCH t110_bcl INTO g_fbf[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('lock fbf',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
               END IF
 
               SELECT faj06,faj18,faj15                                                     #CHI-D10032 add faj15
                 INTO g_fbf[l_ac].faj06,g_fbf[l_ac].faj18,g_fbf[l_ac].faj15                 #CHI-D10032 add faj15
                 FROM faj_file
                WHERE faj02=g_fbf[l_ac].fbf03
                LET g_fbf_t.faj06 = g_fbf[l_ac].faj06
                LET g_fbf_t.faj15 = g_fbf[l_ac].faj15                                        #CHI-D10032 add
                LET g_fbf_t.faj18 = g_fbf[l_ac].faj18
                CALL cl_show_fld_cont()     #FUN-550037(smin)
           ELSE
               LET l_modify_flag='N'
               CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF

       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0

              CANCEL INSERT
           END IF

         IF cl_null(g_fbf[l_ac].fbf031) THEN
            LET g_fbf[l_ac].fbf031 = ' '
         END IF
          #CHI-C60010---str---
           CALL cl_digcut(g_fbf072,g_azi04_1) RETURNING g_fbf072
           CALL cl_digcut(g_fbf082,g_azi04_1) RETURNING g_fbf082
           CALL cl_digcut(g_fbf092,g_azi04_1) RETURNING g_fbf092
           CALL cl_digcut(g_fbf112,g_azi04_1) RETURNING g_fbf112
          #CHI-C60010---end---
           INSERT INTO fbf_file(fbf01,fbf02,fbf03,fbf031,fbf04,fbf05,
                                fbf06,fbf07,fbf08,fbf09,fbf10,fbf11,
                                fbf12,
								fbf072,fbf082,fbf112,fbf092, #NO:FUN-B90096 add
                                fbfud01,fbfud02,fbfud03,
                                fbfud04,fbfud05,fbfud06,
                                fbfud07,fbfud08,fbfud09,
                                fbfud10,fbfud11,fbfud12,
                                fbfud13,fbfud14,fbfud15,
                                fbflegal) #FUN-980003 add
                         VALUES(g_fbe.fbe01,g_fbf[l_ac].fbf02,
                                g_fbf[l_ac].fbf03,g_fbf[l_ac].fbf031,
                                g_fbf[l_ac].fbf04,g_fbf[l_ac].fbf05,
                                g_fbf[l_ac].fbf06,g_fbf[l_ac].fbf07,
                                g_fbf[l_ac].fbf08,g_fbf[l_ac].fbf09,
                                g_fbf_e[l_ac].fbf10,g_fbf[l_ac].fbf11,
                                g_fbf_e[l_ac].fbf12,
								g_fbf072,0,0,0, #NO:FUN-B90096 add #MOD-BC0129 0-->fbf072
                                g_fbf[l_ac].fbfud01,g_fbf[l_ac].fbfud02,
                                g_fbf[l_ac].fbfud03,g_fbf[l_ac].fbfud04,
                                g_fbf[l_ac].fbfud05,g_fbf[l_ac].fbfud06,
                                g_fbf[l_ac].fbfud07,g_fbf[l_ac].fbfud08,
                                g_fbf[l_ac].fbfud09,g_fbf[l_ac].fbfud10,
                                g_fbf[l_ac].fbfud11,g_fbf[l_ac].fbfud12,
                                g_fbf[l_ac].fbfud13,g_fbf[l_ac].fbfud14,
                                g_fbf[l_ac].fbfud15,
                                g_legal) #FUN-980003 add
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","fbf_file",g_fbe.fbe01,g_fbf[l_ac].fbf02,SQLCA.sqlcode,"","ins fbf",1)  #No.FUN-660136
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET l_fbe18 = '0'   #FUN-580109
              LET g_rec_b=g_rec_b+1
              LET l_chg = 'Y'   #MOD-9C0385 add
              CALL t110_upd('a')                 #update 單頭資料
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
            END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_fbf[l_ac].* TO NULL
           LET g_fbf_t.*=g_fbf[l_ac].*
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD fbf02                  #跳下一ROW
 
       BEFORE FIELD fbf02                            #default 序號
           IF g_fbf[l_ac].fbf02 IS NULL OR g_fbf[l_ac].fbf02 = 0 THEN
               SELECT max(fbf02)+1 INTO g_fbf[l_ac].fbf02
                  FROM fbf_file WHERE fbf01 = g_fbe.fbe01
               IF g_fbf[l_ac].fbf02 IS NULL THEN
                   LET g_fbf[l_ac].fbf02 = 1
               END IF
           END IF
 
       AFTER FIELD fbf02                        #check 序號是否重複
           IF NOT cl_null(g_fbf[l_ac].fbf02) THEN
              IF g_fbf[l_ac].fbf02 != g_fbf_t.fbf02 OR g_fbf_t.fbf02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM fbf_file
                    WHERE fbf01 = g_fbe.fbe01 AND fbf02 = g_fbf[l_ac].fbf02
                 IF l_n > 0 THEN
                    LET g_fbf[l_ac].fbf02 = g_fbf_t.fbf02
                    CALL cl_err('',-239,0)
                    NEXT FIELD fbf02
                 END IF
              END IF
           END IF

      #FUN-BC0004--mark--str
      ##modify TQC-AB0198----begin-------------------
      #AFTER FIELD fbf03
      #    IF g_fbf[l_ac].fbf03 != g_fbf_t.fbf03 OR
      #       g_fbf_t.fbf03 IS NULL THEN
      #       SELECT COUNT(*) INTO l_n FROM faj_file
      #        WHERE fajconf='Y'
      #          AND faj02 = g_fbf[l_ac].fbf03
      #       IF l_n <= 0 THEN
      #          LET g_fbf[l_ac].fbf03 = g_fbf_t.fbf03
      #          CALL cl_err('','afa-911',0)
      #          NEXT FIELD fbf03
      #       END IF
      #    END IF
      ##modify TQC-AB0198-----end--------------------
      #FUN-BC0004---mark--end
 
       #FUN-BC0004--add--str
       AFTER FIELD fbf03
          IF g_fbf[l_ac].fbf031 IS NULL THEN LET g_fbf[l_ac].fbf031=' ' END IF
          IF NOT cl_null(g_fbf[l_ac].fbf03) AND g_fbf[l_ac].fbf031 IS NOT NULL THEN
             SELECT COUNT(*) INTO l_n FROM faj_file
              WHERE faj02 = g_fbf[l_ac].fbf03
             IF l_n > 0 THEN 
                CALL t110_fbf031(p_cmd)
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err(g_fbf[l_ac].fbf031,g_errno,0)
                   LET g_fbf[l_ac].fbf03 = g_fbf_t.fbf03             
                   LET g_fbf[l_ac].fbf031 = g_fbf_t.fbf031          
                   NEXT FIELD fbf03
                ELSE
                   IF g_faa.faa23 = 'N' THEN
                      SELECT COUNT(*) INTO l_cnt FROM fan_file
                       WHERE fan01 = g_fbf[l_ac].fbf03
                         AND fan02 = g_fbf[l_ac].fbf031
                         AND ((fan03 = YEAR(g_fbe.fbe02) AND fan04 >= MONTH(g_fbe.fbe02))
                             OR fan03 > YEAR(g_fbe.fbe02))
                         AND fan041 = '1'   #MOD-BC0025 add
                      IF l_cnt > 0 THEN
                         CALL cl_err(g_fbf[l_ac].fbf03,'afa-092',0)
                         NEXT FIELD fbf03
                      END IF
                   END IF
                   IF g_faa.faa31 = "Y" THEN
                      IF g_faa.faa232 = 'N' THEN
                         SELECT COUNT(*) INTO l_cnt FROM fan_file
                          WHERE fab01 = g_fbf[l_ac].fbf03
                            AND fab02 = g_fbf[l_ac].fbf031
                            AND ((fbn03 = YEAR(g_fbe.fbe02) AND fbn04 >= MONTH(g_fbe.fbe02))
                             OR fbn03 > YEAR(g_fbe.fbe02))
                            AND fbn041 = '1'   #MOD-BC0025 add
                         IF l_cnt > 0 THEN
                            CALL cl_err(g_fbf[l_ac].fbf03,'afa-092',0)
                            NEXT FIELD fbf03
                         END IF
                      END IF
                   END IF
                   #-->免稅資料
                   IF g_faj40 = '3' THEN
                      LET g_errno = 'afa-305'
                      CALL cl_err(g_fbf[l_ac].fbf03,g_errno,1)
                   END IF
                   #-->投減三年內不可出售
                   IF g_faj42 = '3' THEN
                      LET l_edate = MDY(MONTH(g_faj26),DAY(g_faj26),YEAR(g_faj26)+3)
                      IF g_fbe.fbe02 < l_edate
                       THEN LET g_errno = 'afa-306'
                            CALL cl_err(g_fbf[l_ac].fbf03,g_errno,1)
                       END IF
                   END IF

                   SELECT faj06 INTO g_fbf[l_ac].faj06 FROM faj_file
                    WHERE faj02  = g_fbf[l_ac].fbf03 AND
                         (faj022 = g_fbf[l_ac].fbf031 OR faj022 IS NULL)
                    DISPLAY BY NAME g_fbf[l_ac].faj06
                END IF
             ELSE
                CALL cl_err(g_fbf[l_ac].fbf03,'',0)
                LET g_fbf[l_ac].fbf03 = g_fbf_t.fbf03
                NEXT FIELD fbf03
             END IF
          END IF 
       #FUN-BC0004--add--end
       AFTER FIELD fbf031
           #TQC-AC0380------add--------str-----------
           IF g_fbf[l_ac].fbf031 IS NULL THEN   LET g_fbf[l_ac].fbf031=' '    END IF
           #TQC-AC0380------add--------end----------- 
           #MOD-A40011 start---
          #----------------MOD-CA0239------------------(S)
          #--MOD-CA0239--mark
          #LET l_cnt = 0
          #SELECT COUNT(*) INTO l_cnt FROM fbe_file,fbf_file
          #  WHERE  fbe01=fbf01 AND fbf03=g_fbf[l_ac].fbf03 AND fbf031=g_fbf[l_ac].fbf031
          #     AND fbeconf<>'X'
          #     AND fbe01<>g_fbe.fbe01
          #IF l_cnt > 0 THEN
          #--MOD-CA0239--mark
           SELECT faj17,faj58 INTO l_faj17,l_faj58
             FROM faj_file
            WHERE faj02 = g_fbf[l_ac].fbf03
              AND faj022 = g_fbf[l_ac].fbf031
           IF l_faj17 - l_faj58 = 0 THEN
          #----------------MOD-CA0239------------------(E)
              CALL cl_err(g_fbf[l_ac].fbf03,'aec-010',0)
              LET g_fbf[l_ac].fbf03 =g_fbf_t.fbf03
              LET g_fbf[l_ac].fbf031=g_fbf_t.fbf031
              NEXT FIELD fbf03
           END IF
           #MOD-A40011 end---
           #--------------------MOD-CB0108--------------------(S)
            IF l_faj17 = 1 THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt 
                 FROM fbg_file,fbh_file 
                WHERE fbg01 = fbh01 
                  AND fbh03 = g_fbf[l_ac].fbf03 
                  AND fbh031 = g_fbf[l_ac].fbf031
                  AND fbgconf<>'X'
               IF l_cnt > 0 THEN
                  CALL cl_err(g_fbf[l_ac].fbf03,'afa-207',0)
                  LET g_fbf[l_ac].fbf03 = g_fbf_t.fbf03
                  LET g_fbf[l_ac].fbf031 = g_fbf_t.fbf031
                  NEXT FIELD fbf03
               END IF            
            END IF
           #--------------------MOD-CB0108--------------------(E)
           CALL t110_fbf031(p_cmd)            #MOD-950166 Add 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_fbf[l_ac].fbf031,g_errno,0)
              LET g_fbf[l_ac].fbf03 = g_fbf_t.fbf03                #MOD-950166 
              LET g_fbf[l_ac].fbf031 = g_fbf_t.fbf031              #MOD-950166              
              NEXT FIELD fbf03
           END IF
          #--------------------MOD-CA0239--------------------(S)
           IF p_cmd='a' OR (p_cmd='u' AND g_fbf[l_ac].fbf03 <> g_fbf_t.fbf03)                   #CHI-D10032 add
                        OR (p_cmd='u' AND g_fbf[l_ac].fbf031 <> g_fbf_t.fbf031)  THEN           #CHI-D10032 add
              IF l_ac > 1 THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM fbf_file
                  WHERE fbf01 = g_fbe.fbe01
                    AND fbf03 = g_fbf[l_ac].fbf03
                    AND fbf031 = g_fbf[l_ac].fbf031
                 IF l_cnt > 0 THEN
                    CALL cl_err(g_fbf[l_ac].fbf03,'afa-053',0)
                    LET g_fbf[l_ac].fbf03 = g_fbf_t.fbf03
                    LET g_fbf[l_ac].fbf031 = g_fbf_t.fbf031
                    NEXT FIELD fbf03
                 END IF
              END IF
           END IF                                                                                #CHI-D10032 add
          #--------------------MOD-CA0239--------------------(E)
           IF g_faa.faa23 = 'N' THEN
              SELECT COUNT(*) INTO l_cnt FROM fan_file
               WHERE fan01 = g_fbf[l_ac].fbf03
                 AND fan02 = g_fbf[l_ac].fbf031
                 AND ((fan03 = YEAR(g_fbe.fbe02) AND fan04 >= MONTH(g_fbe.fbe02))
                  OR fan03 > YEAR(g_fbe.fbe02))
                 AND fan041 = '1'   #MOD-BC0025 add
              IF l_cnt > 0 THEN
                 CALL cl_err(g_fbf[l_ac].fbf03,'afa-092',0)
                 NEXT FIELD fbf03
              END IF
           END IF
           #-----No:FUN-B60140-----
           IF g_faa.faa31 = "Y" THEN
              IF g_faa.faa232 = 'N' THEN
                #MOD-BC0025 -- mark begin --
                #SELECT COUNT(*) INTO l_cnt FROM fan_file
                # WHERE fab01 = g_fbf[l_ac].fbf03
                #   AND fab02 = g_fbf[l_ac].fbf031
                #MOD-BC0025 -- mark end --
                #MOD-BC0025 -- begin --
                 SELECT COUNT(*) INTO l_cnt FROM fbn_file
                  WHERE fbn01 = g_fbf[l_ac].fbf03
                    AND fbn02 = g_fbf[l_ac].fbf031
                #MOD-BC0025 -- end --
                    AND ((fbn03 = YEAR(g_fbe.fbe02) AND fbn04 >= MONTH(g_fbe.fbe02))
                     OR fbn03 > YEAR(g_fbe.fbe02))
                    AND fbn041 = '1'   #MOD-BC0025 add
                 IF l_cnt > 0 THEN
                    CALL cl_err(g_fbf[l_ac].fbf03,'afa-092',0)
                    NEXT FIELD fbf03
                 END IF
              END IF
           END IF
           #-----No:FUN-B60140 END-----
           #-->免稅資料
           IF g_faj40 = '3' THEN
              LET g_errno = 'afa-305'
              CALL cl_err(g_fbf[l_ac].fbf03,g_errno,1)
           END IF
           #-->投減三年內不可出售
           IF g_faj42 = '3' THEN
              LET l_edate = MDY(MONTH(g_faj26),DAY(g_faj26),YEAR(g_faj26)+3)
              IF g_fbe.fbe02 < l_edate
              THEN LET g_errno = 'afa-306'
                   CALL cl_err(g_fbf[l_ac].fbf03,g_errno,1)
              END IF
           END IF
          #-------------------------CHI-D10032-------------(S)
           IF l_ac > 1 THEN                                 #控卡單身要相同幣別
              IF g_fbf[l_ac].faj15 <> g_fbf[1].faj15 THEN
                 CALL cl_err(g_fbf[l_ac].fbf03,'axr-144',1)
                 NEXT FIELD fbf03
              END IF
           END IF
          #-------------------------CHI-D10032-------------(E)
          SELECT faj06 INTO g_fbf[l_ac].faj06 FROM faj_file
            WHERE faj02  = g_fbf[l_ac].fbf03 AND
                  (faj022 = g_fbf[l_ac].fbf031 OR faj022 IS NULL)
          DISPLAY BY NAME g_fbf[l_ac].faj06
          DISPLAY BY NAME g_fbf[l_ac].faj15                           #CHI-D10032 add

       BEFORE FIELD fbf04
           #數量-銷帳數量
           SELECT faj17-faj58 INTO l_fbf04 FROM faj_file
            WHERE faj02 = g_fbf[l_ac].fbf03
              AND faj022= g_fbf[l_ac].fbf031
          #待出售數量(已打單未確認未作廢)
           LET l_fbf04_1 = 0
           SELECT SUM(fbf04) INTO l_fbf04_1 FROM fbf_file,fbe_file
            WHERE fbf03 = g_fbf[l_ac].fbf03
              AND fbf031= g_fbf[l_ac].fbf031
              AND fbf01 = fbe01
              AND fbeconf='N'
          #減去舊值
           IF p_cmd = 'u' THEN
              LET l_fbf04_1=l_fbf04_1-g_fbf_t.fbf04
           END IF
           IF cl_null(l_fbf04_1) THEN LET l_fbf04_1=0 END IF
           LET l_fbf04 = l_fbf04 - l_fbf04_1
 
       AFTER FIELD fbf04
          IF NOT cl_null(g_fbf[l_ac].fbf04) THEN
             IF p_cmd = 'u' THEN
                CALL t110_fbf031('d')
             END IF
              #IF g_fbf[l_ac].fbf04 < 0 THEN                     #MOD-CA0239 mark
              #   CALL cl_err('','mfg4012',0)                    #MOD-CA0239 mark
               IF g_fbf[l_ac].fbf04 <= 0 THEN                    #MOD-CA0239 add
                  CALL cl_err(g_fbf[l_ac].fbf03,'asf-230',0)     #MOD-CA0239 add
                  NEXT FIELD fbf04
               END IF
               IF g_fbf[l_ac].fbf04 > l_fbf04 THEN
                  CALL cl_err(g_fbf[l_ac].fbf04,'afa-109',0)
                  NEXT FIELD fbf04
               END IF
               #(faj未折減額/faj 數量) * 銷售量
               IF g_fbf[l_ac].fbf04 > 0 THEN
                  SELECT faj33+faj331 INTO g_fbf[l_ac].fbf08 FROM faj_file  #MOD-970231
                   WHERE faj02 = g_fbf[l_ac].fbf03
                     AND faj022= g_fbf[l_ac].fbf031
                  LET l_fbf08=(g_fbf08/l_fbf04)*g_fbf[l_ac].fbf04
                  LET l_fbf08 = cl_digcut(l_fbf08,g_azi04)   #MOD-810219
                  LET g_fbf[l_ac].fbf08=l_fbf08
                  LET l_fbf10=(g_fbf10/l_fbf04)*g_fbf[l_ac].fbf04
                  #no.A010依幣別取位
                  LET l_fbf10 = cl_digcut(l_fbf10,g_azi04)
                  LET g_fbf_e[l_ac].fbf10=l_fbf10  #No:A099
                  LET l_fbf11=(g_fbf11/l_fbf04)*g_fbf[l_ac].fbf04
                  LET l_fbf11 = cl_digcut(l_fbf11,g_azi04)
                  LET g_fbf[l_ac].fbf11=l_fbf11
                  LET l_fbf12=(g_fbf12/l_fbf04)*g_fbf[l_ac].fbf04
                  LET l_fbf12 = cl_digcut(l_fbf12,g_azi04)
                  LET g_fbf_e[l_ac].fbf12=l_fbf12
                  LET l_fbf082 = 0#TQC-C50162 add
                  #TQC-C50162--add-str
                  SELECT faj332+faj3312 INTO g_fbf082 FROM faj_file
                   WHERE faj02 = g_fbf[l_ac].fbf03
                     AND faj022= g_fbf[l_ac].fbf031
                  IF g_faa.faa31 = 'Y' THEN
                     LET l_fbf112 = (g_fbf112/l_fbf04) * g_fbf[l_ac].fbf04
                     #LET l_fbf112 = cl_digcut(l_fbf112,g_azi04)        #CHI-C60010 mark
                     LET l_fbf112 = cl_digcut(l_fbf112,g_azi04_1)          #CHI-C60010
                     LET l_fbf082 = (g_fbf082/l_fbf04) * g_fbf[l_ac].fbf04
                     #LET l_fbf082 = cl_digcut(l_fbf082,g_azi04)        #CHI-C60010 mark
                     #LET l_fbf092 = cl_digcut(l_fbf092,g_azi04)        #CHI-C60010 mark
                     LET l_fbf082 = cl_digcut(l_fbf082,g_azi04_1)           #CHI-C60010
                     LET l_fbf092 = cl_digcut(l_fbf092,g_azi04_1)           #CHI-C60010
                  END IF
                  #TQC-C50162--add--end
               END IF
          END IF
          DISPLAY g_fbf[l_ac].fbf08 TO fbf08
          DISPLAY BY NAME g_fbf_e[l_ac].fbf10
          DISPLAY BY NAME g_fbf_e[l_ac].fbf10
          DISPLAY BY NAME g_fbf[l_ac].fbf11
          DISPLAY BY NAME g_fbf_e[l_ac].fbf12
 
       BEFORE FIELD fbf05
           IF p_cmd = 'a' AND l_ac > 1 THEN
              LET g_fbf[l_ac].fbf05 = g_fbf[l_ac-1].fbf05
              DISPLAY g_fbf[l_ac].fbf05 TO fbf05
           END IF
 
       AFTER FIELD fbf05
           IF NOT cl_null(g_fbf[l_ac].fbf05) THEN
              SELECT * FROM fag_file WHERE fag01=g_fbf[l_ac].fbf05
                                        AND fag02=l_fbe00           #No.MOD-510142
              IF STATUS=100 THEN
                 CALL cl_err3("sel","fag_file",g_fbf[l_ac].fbf05,l_fbe00,"afa-099","","",1)  #No.FUN-660136
                 NEXT FIELD fbf05
              END IF
           END IF
 
       AFTER FIELD fbf06
           IF NOT cl_null(g_fbf[l_ac].fbf06) THEN
              IF g_fbf[l_ac].fbf06 < 0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD fbf06
              END IF
#No.MOD-A80097 --begin                                                          
              IF g_fbf[l_ac].fbf06 <= 0 THEN                                    
                 CALL cl_err('','afa-359',0)                                    
                 NEXT FIELD fbf06                                               
              END IF                                                            
#No.MOD-A80097 --end  
              IF g_fbe.fbe05 = g_aza.aza17 THEN
                 LET g_fbf[l_ac].fbf07=g_fbf[l_ac].fbf06
              ELSE
                 LET g_fbf[l_ac].fbf07 = g_fbf[l_ac].fbf06 * g_fbe.fbe06
              END IF
              SELECT faj14,faj141,faj59,faj17,faj58,faj32,faj09,faj60  #MOD-990191 add faj09 #MOD-A40148 add faj60
                INTO l_faj14,l_faj141,l_faj59,l_faj17,l_faj58,l_faj32,l_faj09,l_faj60  #MOD-990191 add l_faj09 #MOD-A40148 add l_faj60
                FROM faj_file
               WHERE faj02 = g_fbf[l_ac].fbf03
                 AND faj022= g_fbf[l_ac].fbf031
             #LET l_dis = (l_faj32 / l_faj17) * g_fbf[l_ac].fbf04  #累折                     #MOD-A40148 mark
              LET l_dis = ((l_faj32-l_faj60) / (l_faj17-l_faj58)) * g_fbf[l_ac].fbf04  #累折 #MOD-A40148 add
              IF l_faj09!='5' THEN   #MOD-990191 add
                 LET l_fbf09=(l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)
                             * g_fbf[l_ac].fbf04
              ELSE   #費用類計算時不抓本幣成本
                 LET l_fbf09=(l_faj141-l_faj59)/(l_faj17-l_faj58)
                             * g_fbf[l_ac].fbf04
              END IF
              CALL cl_digcut(l_dis,g_azi04) RETURNING l_dis
              CALL cl_digcut(l_fbf09,g_azi04) RETURNING l_fbf09
              IF g_fbe.fbe073 = 'Y' THEN   #含稅否
                 LET g_fbf07 = g_fbf[l_ac].fbf07/(1+g_fbe.fbe071/100)
              ELSE
                 LET g_fbf07 = g_fbf[l_ac].fbf07
              END IF
              LET g_fbf[l_ac].fbf09=g_fbf07+l_dis-l_fbf09   #CHI-870008 mod l_fbf09->l_fbf08   #TQC-870051 mod
              IF cl_null(g_fbf[l_ac].fbf11) THEN LET g_fbf[l_ac].fbf11 = 0 END IF
              LET g_fbf[l_ac].fbf09 = g_fbf[l_ac].fbf09 + g_fbf[l_ac].fbf11
              LET g_fbf[l_ac].fbf09 = cl_digcut(g_fbf[l_ac].fbf09,g_azi04)   #MOD-760135
              DISPLAY g_fbf[l_ac].fbf09 TO fbf09 #
           ELSE
#             LET g_fbf[l_ac].fbf07 =0                                          
              NEXT FIELD fbf06    #No.MOD-A80097  
           END IF
           IF cl_null(t_azi.azi01) THEN                      #No.CHI-6A0004 l_azi-->t_azi
              SELECT * INTO t_azi.* FROM azi_file WHERE azi01=g_fbe.fbe05   #No.CHI-6A0004 l_azi-->t_azi
              IF SQLCA.SQLCODE THEN
                 LET t_azi.azi04=g_azi04                     #No.CHI-6A0004 l_azi-->t_azi
              END IF
           END IF
           CALL cl_digcut(g_fbf[l_ac].fbf06,t_azi.azi04)     #No.CHI-6A0004 l_azi-->t_azi
                RETURNING g_fbf[l_ac].fbf06
           IF cl_null(g_fbf[l_ac].fbf06) OR g_fbf[l_ac].fbf06=0 THEN
              LET g_fbf[l_ac].fbf06=1
           END IF
           DISPLAY g_fbf[l_ac].fbf06 TO fbf06
           CALL cl_digcut(g_fbf[l_ac].fbf07,g_azi04)  #010810增
                RETURNING g_fbf[l_ac].fbf07
           DISPLAY g_fbf[l_ac].fbf07 TO fbf07 #
 
       AFTER FIELD fbf07
          IF NOT cl_null(g_fbf[l_ac].fbf07) THEN
             IF g_fbf[l_ac].fbf07 < 0 THEN
                CALL cl_err('','mfg4012',0)
                NEXT FIELD fbf07
             END IF
#No.MOD-A80097 --begin                                                          
             IF g_fbf[l_ac].fbf07 <= 0 THEN                                     
                CALL cl_err('','afa-359',0)                                     
                NEXT FIELD fbf07                                                
             END IF                                                             
          ELSE                                                                  
             NEXT FIELD fbf07                                                   
#No.MOD-A80097 --end 
          END IF
          #MOD-BC0129---begin add
          IF g_fbf[l_ac].fbf07 <> g_fbf_t.fbf07 OR cl_null(g_fbf_t.fbf07) THEN
             #依帳別取幣別
             SELECT aaa03 INTO l_aaa03 FROM aaa_file
              WHERE aaa01 = g_faa.faa02c
             #取當日幣別
             CALL s_curr(l_aaa03,g_fbe.fbe02) RETURNING l_rate
             IF cl_null(l_rate) OR l_rate=0 THEN
                LET l_rate=1
             END IF
             #取金額四捨五入
             SELECT * INTO t_azi.* FROM azi_file WHERE azi01 = l_aaa03
             IF SQLCA.SQLCODE THEN
                LET t_azi.azi04=g_azi04
             END IF
             #LET g_fbf072 = cl_digcut(g_fbf[l_ac].fbf07/l_rate,g_azi04)     #CHI-C60010 mark
             LET g_fbf072 = cl_digcut(g_fbf[l_ac].fbf07/l_rate,g_azi04_1)      #CHI-C60010
          END IF
          #MOD-BC0129---end add
 
       AFTER FIELD fbf08
           IF g_fbf[l_ac].fbf08 < 0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbf08
           END IF
##No.2975 modify 1998/12/28 出售損益=成本-出售金額
          #MOD-BB0041 -- mark begin --
          #SELECT faj14,faj141,faj59,faj17,faj58,faj32,faj09,faj60  #MOD-990191 add faj09 #MOD-A40148 add faj60
          #  INTO l_faj14,l_faj141,l_faj59,l_faj17,l_faj58,l_faj32,l_faj09,l_faj60  #MOD-990191 add l_faj09 #MOD-A40148 add l
          #MOD-BB0041 -- mark end --
          #MOD-BB0041 -- begin --
           SELECT faj14,faj141,faj59,faj17,faj58,faj32,faj09,faj60,faj33,faj331
             INTO l_faj14,l_faj141,l_faj59,l_faj17,l_faj58,l_faj32,l_faj09,l_faj60,l_faj33,l_faj331
          #MOD-BB0041 -- end --
             FROM faj_file
            WHERE faj02 = g_fbf[l_ac].fbf03
              AND faj022= g_fbf[l_ac].fbf031

          #MOD-BB0041 -- begin --
          IF g_fbf[l_ac].fbf08 > (l_faj33+l_faj331) THEN
             CALL cl_err('','afa-164',0)
             NEXT FIELD fbf08
          END IF
          #MOD-BB0041 -- end --
          #LET l_dis = (l_faj32 / l_faj17) * g_fbf[l_ac].fbf04  #累折                     #MOD-A40148 mark
           LET l_dis = ((l_faj32-l_faj60) / (l_faj17-l_faj58)) * g_fbf[l_ac].fbf04  #累折 #MOD-A40148 add
           IF l_faj09!='5' THEN   #MOD-990191 add
              LET l_fbf09=(l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)
                          * g_fbf[l_ac].fbf04
           ELSE   #費用類計算時不抓本幣成本
              LET l_fbf09=(l_faj141-l_faj59)/(l_faj17-l_faj58)
                          * g_fbf[l_ac].fbf04
           END IF
           CALL cl_digcut(l_dis,g_azi04) RETURNING l_dis
           CALL cl_digcut(l_fbf09,g_azi04) RETURNING l_fbf09
           IF g_fbe.fbe073 = 'Y' THEN
              LET g_fbf07 = g_fbf[l_ac].fbf07/(1+g_fbe.fbe071/100)
           ELSE
              LET g_fbf07 = g_fbf[l_ac].fbf07
           END IF
           LET g_fbf[l_ac].fbf09=g_fbf07+l_dis-l_fbf09   #CHI-870008 mod l_fbf09->l_fbf08   #TQC-870051 mod
           IF cl_null(g_fbf[l_ac].fbf11) THEN LET g_fbf[l_ac].fbf11 = 0 END IF
           LET g_fbf[l_ac].fbf09 = g_fbf[l_ac].fbf09 + g_fbf[l_ac].fbf11
           LET g_fbf[l_ac].fbf09 = cl_digcut(g_fbf[l_ac].fbf09,g_azi04)   #MOD-760135
           DISPLAY g_fbf[l_ac].fbf09 TO fbf09 #
 
       AFTER FIELD fbfud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fbfud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       BEFORE DELETE                            #是否取消單身
           IF g_fbf_t.fbf02 > 0 AND g_fbf_t.fbf02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                    ROLLBACK WORK
                    CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM fbf_file
                  WHERE fbf01 = g_fbe.fbe01 AND fbf02 = g_fbf_t.fbf02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","fbf_file",g_fbf_t.fbf02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE   #MOD-6C0060
                  CALL t110_upd('u')            #MOD-6C0060
               END IF
       	COMMIT WORK
               LET l_fbe18 = '0'   #FUN-580109
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_fbf[l_ac].* = g_fbf_t.*
              CLOSE t110_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_fbf[l_ac].fbf02,-263,1)
              LET g_fbf[l_ac].* = g_fbf_t.*
           ELSE
              IF g_fbf[l_ac].fbf03 IS NULL THEN
                 INITIALIZE g_fbf[l_ac].* TO NULL  #重要欄位空白,無效
              END IF
             #TQC-C50162--add--str
              IF NOT cl_null(l_fbf082) THEN
                 LET g_fbf082 = l_fbf082
              END IF
              #TQC-C50162--add--end
             #----------MOD-C50244----------(S)
              IF cl_null(g_fbf072) THEN
                 LET g_fbf072 = 0
              END IF
              IF cl_null(g_fbf092) THEN
                 LET g_fbf092 = 0
              END IF
             #----------MOD-C50244----------(E)
              UPDATE fbf_file SET
                     fbf02 = g_fbf[l_ac].fbf02,fbf03 = g_fbf[l_ac].fbf03,
                     fbf031 = g_fbf[l_ac].fbf031,fbf04 = g_fbf[l_ac].fbf04,
                     fbf05 = g_fbf[l_ac].fbf05,fbf06 = g_fbf[l_ac].fbf06,
                     fbf07 = g_fbf[l_ac].fbf07,fbf08 = g_fbf[l_ac].fbf08,
                     fbf09 = g_fbf[l_ac].fbf09,fbf10 = g_fbf_e[l_ac].fbf10,
                     fbf11 = g_fbf[l_ac].fbf11,fbf12 = g_fbf_e[l_ac].fbf12,
                     fbf082 = g_fbf082,fbf092 = g_fbf092,fbf072 = g_fbf072,       #TQC-C50162 add #MOD-C50244 add abf092,abf072
                     fbfud01 = g_fbf[l_ac].fbfud01,fbfud02 = g_fbf[l_ac].fbfud02,
                     fbfud03 = g_fbf[l_ac].fbfud03,fbfud04 = g_fbf[l_ac].fbfud04,
                     fbfud05 = g_fbf[l_ac].fbfud05,fbfud06 = g_fbf[l_ac].fbfud06,
                     fbfud07 = g_fbf[l_ac].fbfud07,fbfud08 = g_fbf[l_ac].fbfud08,
                     fbfud09 = g_fbf[l_ac].fbfud09,fbfud10 = g_fbf[l_ac].fbfud10,
                     fbfud11 = g_fbf[l_ac].fbfud11,fbfud12 = g_fbf[l_ac].fbfud12,
                     fbfud13 = g_fbf[l_ac].fbfud13,fbfud14 = g_fbf[l_ac].fbfud14,
                     fbfud15 = g_fbf[l_ac].fbfud15
               WHERE fbf01 = g_fbe.fbe01 AND fbf02 = g_fbf[l_ac].fbf02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","fbf_file",g_fbe.fbe01,g_fbf[l_ac].fbf02,SQLCA.sqlcode,"","upd fbf",1)  #No.FUN-660136
                 LET g_fbf[l_ac].* = g_fbf_t.*
              ELSE
                 LET l_chg = 'Y'   #MOD-9C0385 add
                 CALL t110_upd('u')                 #update 單頭資料
                 MESSAGE 'UPDATE O.K'
                 LET l_fbe18 = '0'   #FUN-580109
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_fbf[l_ac].* = g_fbf_t.*
             #FUN-D30032--add--begin--
             ELSE
                CALL g_fbf.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end----
             END IF
             CLOSE t110_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30032 add 
         #-------------------------CHI-D10032-------------(S)
          IF l_ac > 1 THEN                                 #控卡單身要相同幣別
             IF g_fbf[l_ac].faj15 <> g_fbf[1].faj15 THEN
                CALL cl_err(g_fbf[l_ac].fbf03,'axr-144',1)
                NEXT FIELD fbf03
             END IF
          END IF
         #-------------------------CHI-D10032-------------(E)
          CLOSE t110_bcl
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(fbf02) AND l_ac > 1 THEN
              LET g_fbf[l_ac].* = g_fbf[l_ac-1].*
              LET g_fbf[l_ac].fbf02 = NULL
              NEXT FIELD fbf02
          END IF
 
       ON ACTION mntn_depr_tax
          CALL t110_w1(p_cmd)
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(fbf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_faj"
                  LET g_qryparam.default1 = g_fbf[l_ac].fbf03
                  LET g_qryparam.default2 = g_fbf[l_ac].fbf031
                  CALL cl_create_qry()
                       RETURNING g_fbf[l_ac].fbf03,g_fbf[l_ac].fbf031
                  DISPLAY g_fbf[l_ac].fbf03 TO fbf03
                  DISPLAY g_fbf[l_ac].fbf031 TO fbf031
                  NEXT FIELD fbf03
             WHEN INFIELD(fbf031)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_faj"
                  LET g_qryparam.default1 = g_fbf[l_ac].fbf03
                  LET g_qryparam.default2 = g_fbf[l_ac].fbf031
                  CALL cl_create_qry()
                       RETURNING g_fbf[l_ac].fbf03,g_fbf[l_ac].fbf031
                  DISPLAY g_fbf[l_ac].fbf03 TO fbf03
                  DISPLAY g_fbf[l_ac].fbf031 TO fbf031
                  NEXT FIELD fbf031
             WHEN INFIELD(fbf05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fag"
                   LET g_qryparam.arg1 = l_fbe00 CLIPPED          #No.MOD-510142
                  LET g_qryparam.default1 = g_fbf[l_ac].fbf05
                  CALL cl_create_qry() RETURNING g_fbf[l_ac].fbf05
                  DISPLAY g_fbf[l_ac].fbf05 TO fbf05
          END CASE
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    
    END INPUT
 
   #IF l_chg = 'Y' THEN   #MOD-9C0385 add        #CHI-A30001 mark      
    IF l_chg = 'Y' AND g_fbe.fbe073 = 'Y' THEN   #CHI-A30001
       LET l_tax = 0   LET l_sumtax = 0
       LET l_fbf02 = ''
       LET l_fbf07 = 0
       INITIALIZE l_fbf.* TO NULL
 
       #單身各筆各自算出稅額後再加總起來
       DECLARE fbf_curs_t CURSOR FOR
          SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
       FOREACH fbf_curs_t INTO l_fbf.*
          IF g_fbe.fbe073 = 'Y' THEN   #含稅否
             LET l_fbf07 = l_fbf.fbf07/(1+g_fbe.fbe071/100)
          ELSE
             LET l_fbf07 = l_fbf.fbf07
          END IF
 
          LET l_tax = l_fbf07*g_fbe.fbe071/100
          CALL cl_digcut(l_tax,t_azi.azi04) RETURNING l_tax
          LET l_sumtax = l_sumtax+l_tax
       END FOREACH
 
       #當整張單據的本幣出售稅額 不等於 單身各自計算稅額後加總
       #將差異調在單身金額最大那筆的處分損益上
       IF g_fbe.fbe09x-l_sumtax!=0 THEN
          #抓單身本幣出售金額最大那筆的項次
          DECLARE fbf_curs_t1 CURSOR FOR
             SELECT fbf02 FROM fbf_file
              WHERE fbf01=g_fbe.fbe01
              ORDER BY fbf07 DESC
          OPEN fbf_curs_t1
          FETCH fbf_curs_t1 INTO l_fbf02
          CLOSE fbf_curs_t1
 
          UPDATE fbf_file SET fbf09 = fbf09-(g_fbe.fbe09x-l_sumtax)
           WHERE fbf01=g_fbe.fbe01 AND fbf02=l_fbf02
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","fbf_file",g_fbe.fbe01,l_fbf02,SQLCA.sqlcode,"","upd fbf",1)
          ELSE
             CALL t110_upd('u')                 #update 單頭資料
          END IF
       END IF
    END IF    #MOD-9C0385 add
 
    LET g_fbe.fbemodu = g_user
    LET g_fbe.fbedate = g_today
    LET g_fbe.fbe18 = l_fbe18   #FUN-580109
    UPDATE fbe_file SET fbemodu = g_fbe.fbemodu,fbedate = g_fbe.fbedate
                       ,fbe18   = g_fbe.fbe18   #FUN-580109
     WHERE fbe01 = g_fbe.fbe01
    DISPLAY BY NAME g_fbe.fbemodu,g_fbe.fbedate,g_fbe.fbe18   #FUN-580109 mod
 
    IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fbe.fbe18 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fbe.fbeconf,g_chr2,g_fbe.fbepost,"",g_chr,"")
 
    CALL t110_show()   #CHI-870008 add
 
    SELECT COUNT(*) INTO g_cnt FROM fbf_file WHERE fbf01=g_fbe.fbe01
    CLOSE t110_bcl
    COMMIT WORK
    CALL t110_delHeader()     #CHI-C30002 add
    #MOD-C50212 add begin---------------------
    #SELECT * INTO g_fbe.* FROM fbf_file WHERE fbf01=g_fbe.fbe01     #TQC-C60214   mark
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01=g_fbe.fbe01      #TQC-C60214   add
    CALL s_get_doc_no(g_fbe.fbe01) RETURNING g_t1
    IF g_t1 IS NOT NULL THEN
       SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
       IF g_fah.fahdmy3 = 'Y' THEN
          IF cl_confirm('axr-309') THEN
             SELECT fbepost INTO g_fbe.fbepost FROM fbe_file
              WHERE fbe01 = g_fbe.fbe01
             IF NOT cl_null(g_fbe.fbe14) THEN
                CALL cl_err(g_fbe.fbe01,'afa-303',0)
             ELSE
                IF g_fbe.fbeconf = 'N' THEN
                   LET g_success='Y'
                   BEGIN WORK
                   CALL s_showmsg_init()
                   CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'0')
                   IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND cl_null(g_fbe.fbe142) THEN
                      CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'1')
                   END IF
                   CALL s_showmsg()
                   IF g_success='Y' THEN
                      COMMIT WORK
                   ELSE
                      ROLLBACK WORK
                   END IF
                ELSE
                   CALL cl_err(g_fbe.fbe01,'afa-350',0)
                END IF
             END IF
          END IF
       END IF
    END IF
    #SELECT * INTO g_fbe.* FROM fbf_file WHERE fbf01=g_fbe.fbe01       #TQC-C60213   mark
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01=g_fbe.fbe01       #TQC-C60213    add
    CALL t110_show()
    #MOD-C50212 add end-----------------------
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t110_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fbe.fbe01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fbe_file ",
                  "  WHERE fbe01 LIKE '",l_slip,"%' ",
                  "    AND fbe01 > '",g_fbe.fbe01,"'"
      PREPARE t110_pb1 FROM l_sql 
      EXECUTE t110_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t110_x()         #FUN-D20035
         CALL t110_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 4
                                AND npp01 = g_fbe.fbe01
                                AND npp011= 1
         DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 4
                                AND npq01 = g_fbe.fbe01
                                AND npq011= 1
         DELETE FROM tic_file WHERE tic04 = g_fbe.fbe01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fbe_file WHERE fbe01 = g_fbe.fbe01
         INITIALIZE g_fbe.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t110_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON fbf02,fbf03,fbf031,fbf04,fbf05,fbf06,fbf07,fbf08,
                       fbf11,fbf09,faj06,faj18
                       ,fbfud01,fbfud02,fbfud03,fbfud04,fbfud05
                       ,fbfud06,fbfud07,fbfud08,fbfud09,fbfud10
                       ,fbfud11,fbfud12,fbfud13,fbfud14,fbfud15
                  FROM s_fbf[1].fbf02, s_fbf[1].fbf03, s_fbf[1].fbf031,
                       s_fbf[1].fbf04, s_fbf[1].fbf05, s_fbf[1].fbf06,
                       s_fbf[1].fbf07, s_fbf[1].fbf08,
                       s_fbf[1].fbf11, s_fbf[1].fbf09,
                       s_fbf[1].faj06, s_fbf[1].faj18
                       ,s_fbf[1].fbfud01,s_fbf[1].fbfud02,s_fbf[1].fbfud03
                       ,s_fbf[1].fbfud04,s_fbf[1].fbfud05,s_fbf[1].fbfud06
                       ,s_fbf[1].fbfud07,s_fbf[1].fbfud08,s_fbf[1].fbfud09
                       ,s_fbf[1].fbfud10,s_fbf[1].fbfud11,s_fbf[1].fbfud12
                       ,s_fbf[1].fbfud13,s_fbf[1].fbfud14,s_fbf[1].fbfud15
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t110_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t110_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fbf02,fbf03,fbf031,faj06,faj18,fbf04,fbf05,",
        "       faj15,fbf06,fbf07,fbf08,fbf11,fbf09, ",                  #No:A099 #CHI-D10032 add faj15
        "       fbfud01,fbfud02,fbfud03,fbfud04,fbfud05,",
        "       fbfud06,fbfud07,fbfud08,fbfud09,fbfud10,",
        "       fbfud11,fbfud12,fbfud13,fbfud14,fbfud15 ", 
        " FROM fbf_file LEFT OUTER JOIN faj_file ON fbf03=faj_file.faj02 AND fbf031=faj_file.faj022  ",
        " WHERE fbf01 ='",g_fbe.fbe01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,            #單身
        " ORDER BY 1"
 
    PREPARE t110_pb FROM g_sql
    DECLARE fbf_curs CURSOR FOR t110_pb
    CALL g_fbf.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fbf_curs INTO g_fbf[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fbf.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fbf TO s_fbf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
       #FUN-B30140--mark---str---
       ##IF g_aza.aza63 = 'Y' THEN     #FUN-AB0088 mark
       # IF g_faa.faa31 = 'Y' THEN     #FUN-AB0088 add    
       #    CALL cl_set_act_visible("entry_sheet2",TRUE)
       # ELSE
       #    CALL cl_set_act_visible("entry_sheet2",FALSE)
       # END IF
       #FUN-B30140--mark---end---
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL t110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t110_fetch('L')
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
         IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fbe.fbe18 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fbe.fbeconf,g_chr2,g_fbe.fbepost,"",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 自動產生
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
         EXIT DISPLAY
      #@ON ACTION 重新計算帳值
      ON ACTION recount
         LET g_action_choice="recount"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿2
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
      #-----NO:FUN-B90096 start--
      #@ON ACTION 財簽二
      ON ACTION fin_audit2 
         LET g_action_choice="fin_audit2"
         EXIT DISPLAY      
      #-----NO:FUN-B90096 end----         
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      #@ON ACTION 會計過帳
      ON ACTION account_post
         LET g_action_choice="account_post"
         EXIT DISPLAY
      #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
      #@ON ACTION 稅簽修改
      ON ACTION amend_depr_tax
         LET g_action_choice="amend_depr_tax"
         EXIT DISPLAY
      #@ON ACTION 稅簽過帳
      ON ACTION post_depr_tax
         LET g_action_choice="post_depr_tax"
         EXIT DISPLAY
      #@ON ACTION 稅簽還原
      ON ACTION undo_post_depr_tax
         LET g_action_choice="undo_post_depr_tax"
         EXIT DISPLAY
      #@ON ACTION 產生帳款
      ON ACTION gen_acct
         LET g_action_choice="gen_acct"
         EXIT DISPLAY
      #NO:7382 add 發票查詢
      ON ACTION invoice_qry
         LET g_action_choice="invoice_qry"
         EXIT DISPLAY
 
#No.MOD-C30758 --begin
      #@ON ACTION 还原帳款
      ON ACTION undo_acct
         LET g_action_choice="undo_acct"
         EXIT DISPLAY
#No.MOD-C30758 --end

#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION easyflow_approval
        LET g_action_choice = 'easyflow_approval'
        EXIT DISPLAY
 
     ON ACTION approval_status
        LET g_action_choice="approval_status"
        EXIT DISPLAY
 
     ON ACTION agree
        LET g_action_choice = 'agree'
        EXIT DISPLAY
 
     ON ACTION deny
        LET g_action_choice = 'deny'
        EXIT DISPLAY
 
     ON ACTION modify_flow
        LET g_action_choice = 'modify_flow'
        EXIT DISPLAY
 
     ON ACTION withdraw
        LET g_action_choice = 'withdraw'
        EXIT DISPLAY
 
     ON ACTION org_withdraw
        LET g_action_choice = 'org_withdraw'
        EXIT DISPLAY
 
     ON ACTION phrase
        LET g_action_choice = 'phrase'
        EXIT DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      &include "qry_string.4gl"

      #FUN-C30102-Add Begin---
       ON ACTION qry_oma
          LET g_action_choice="qry_oma"
          EXIT DISPLAY
      #FUN-C30102-Add End----- 

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t110_k()
   DEFINE g_fbf     DYNAMIC ARRAY OF RECORD
                    fbf02	LIKE fbf_file.fbf02,
                    fbf03	LIKE fbf_file.fbf03,
                    faj06	LIKE faj_file.faj06,
                    fbf031	LIKE fbf_file.fbf031,
                    faj18	LIKE faj_file.faj18,
                    fbf07	LIKE fbf_file.fbf07,
                    fbf04	LIKE fbf_file.fbf04,
                    fbf05	LIKE fbf_file.fbf05,
                    fbf11	LIKE fbf_file.fbf11,          #No:A099
                    fbf08	LIKE fbf_file.fbf08,
                    fbf09	LIKE fbf_file.fbf09,
                    fbf12	LIKE fbf_file.fbf12,          #No:A099
                    fbf10	LIKE fbf_file.fbf10
                    END RECORD
   DEFINE g_fbf_t   RECORD
                    fbf02	LIKE fbf_file.fbf02,
                    fbf03	LIKE fbf_file.fbf03,
                    faj06	LIKE faj_file.faj06,
                    fbf031	LIKE fbf_file.fbf031,
                    faj18	LIKE faj_file.faj18,
                    fbf07	LIKE fbf_file.fbf07,
                    fbf04	LIKE fbf_file.fbf04,
                    fbf05	LIKE fbf_file.fbf05,
                    fbf11	LIKE fbf_file.fbf11,          #No:A099
                    fbf08	LIKE fbf_file.fbf08,
                    fbf09	LIKE fbf_file.fbf09,
                    fbf12	LIKE fbf_file.fbf12,          #No:A099
                    fbf10	LIKE fbf_file.fbf10
                    END RECORD
   DEFINE l_lock_sw       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_modify_flag   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE p_cmd           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE i,j,k           LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE ls_tmp STRING
   DEFINE l_allow_insert  LIKE type_file.num5                  #可新增否       #No.FUN-680070 SMALLINT
   DEFINE l_allow_delete  LIKE type_file.num5                  #可刪除否       #No.FUN-680070 SMALLINT
   DEFINE l_cnt           LIKE type_file.num5   #CHI-860025
 
   IF g_fbe.fbe01 IS NULL THEN RETURN END IF
   IF g_fbe.fbeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    #FUN-C30140---add---str---
    IF NOT cl_null(g_fbe.fbe18) AND g_fbe.fbe18 matches '[Ss]' THEN     
        CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
        RETURN
    END IF
    #FUN-C30140---add---end---
   LET p_row = 13  LET p_col = 7
   OPEN WINDOW t110_w5 AT p_row,p_col WITH FORM "afa/42f/afat1102"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat1102")
 
   DECLARE t110_kkk_c CURSOR FOR
         SELECT fbf02,fbf03,faj06,fbf031,faj18,fbf07,fbf04,faj15,fbf05,             #CHI-D10032 add faj15
                fbf11,fbf08,fbf09,fbf12,fbf10             #end No:A099
           FROM fbf_file LEFT OUTER JOIN faj_file ON fbf03 = faj_file.faj02 AND fbf031 = faj_file.faj022
            WHERE fbf01 = g_fbe.fbe01
          ORDER BY 1
 
   CALL g_fbf.clear()
   LET k = 1
   FOREACH t110_kkk_c INTO g_fbf[k].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t110_kkk_c',SQLCA.sqlcode,0)  
         EXIT FOREACH
      END IF
      IF g_faa.faa23 = 'N' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM fao_file
          WHERE fao01 = g_fbf[k].fbf03
            AND fao02 = g_fbf[k].fbf031
            AND ((fao03 = YEAR(g_fbe.fbe02) AND fao04 >= MONTH(g_fbe.fbe02))
             OR fao03 > YEAR(g_fbe.fbe02))
            AND fao041 = '1'   #MOD-BC0025 add
         IF l_cnt > 0 THEN
            CALL cl_err(g_fbf[k].fbf03,'afa-092',0)
            CONTINUE FOREACH
         END IF
      END IF
      LET k = k + 1
      IF k > g_max_rec THEN EXIT FOREACH END IF
   END FOREACH
   CALL g_fbf.deleteElement(k)
   Let k = k - 1   #CHI-860025
   CALL SET_COUNT(k)   #CHI-860025
 
   IF g_fbe.fbepost2= 'Y' THEN
      DISPLAY ARRAY g_fbf TO s_fbf.* ATTRIBUTE(COUNT=k-1,UNBUFFERED)
      CLOSE WINDOW t110_w5
      RETURN
   END IF
 
   DISPLAY BY NAME g_fbe.fbeconf, g_fbe.fbepost, g_fbe.fbepost2,
                   g_fbe.fbeuser, g_fbe.fbegrup, g_fbe.fbemodu,g_fbe.fbedate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_fbf WITHOUT DEFAULTS FROM s_fbf.*
         ATTRIBUTE(COUNT=k,MAXCOUNT=g_max_rec,UNBUFFERED,   #CHI-860025
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INSERT
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET p_cmd='a'
         INITIALIZE g_fbf[i].* TO NULL
         LET g_fbf_t.* = g_fbf[i].*
 
      BEFORE INPUT
          CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET g_fbf_t.* = g_fbf[i].*
         LET l_lock_sw = 'N'
         IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_success = 'Y'
         ELSE
              LET g_success = 'Y'
              LET p_cmd='a'
              INITIALIZE g_fbf[i].* TO NULL
         END IF
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fbf[i].* = g_fbf_t.*
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fbf[i].fbf02,-263,1)
             LET g_fbf[i].* = g_fbf_t.*
          ELSE
             IF g_fbf[i].fbf03 IS NULL THEN
                INITIALIZE g_fbf[i].* TO NULL
                DISPLAY g_fbf[i].* TO s_fbf[j].*
             END IF
             UPDATE fbf_file SET fbf10 = g_fbf[i].fbf10,
                                 fbf12 = g_fbf[i].fbf12
              WHERE fbf01 = g_fbe.fbe01 AND fbf02 = g_fbf_t.fbf02
             IF STATUS THEN
                  CALL cl_err3("upd","fbf_file",g_fbe.fbe01,g_fbf_t.fbf02,SQLCA.sqlcode,"","upd fbf:",1)  #No.FUN-660136
                  LET g_success = 'N'
                  LET g_fbf[i].* = g_fbf_t.*
                  DISPLAY g_fbf[i].* TO s_fbf[j].*
             ELSE MESSAGE "update ok"
             END IF
          END IF
 
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
   IF INT_FLAG THEN LET g_success='N' LET INT_FLAG = 0 END IF
   CLOSE WINDOW t110_w5
END FUNCTION
 
FUNCTION t110_y()
DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
   IF s_shut(0) THEN RETURN END IF
   IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
   IF g_fbe.fbeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_fbe.fbeconf='Y' THEN RETURN END IF
   IF (cl_null(g_fbe.fbe12) OR g_fbe.fbe12='N')
      AND  g_faa.faa23='Y'
   THEN  CALL cl_err('','afa-923',0)RETURN END IF
   SELECT COUNT(*) INTO l_cnt FROM fbf_file
    WHERE fbf01= g_fbe.fbe01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期小於關帳日期
   IF g_fbe.fbe02 < g_faa.faa09 THEN
      CALL cl_err(g_fbe.fbe01,'aap-176',1) RETURN
   END IF
    #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_fbe.fbe02 < g_faa.faa092 THEN
         CALL cl_err(g_fbe.fbe01,'aap-176',1) RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----
    #----------------------------------- 檢查分錄底稿平衡正確否
#FUN-C30313---mark---START
#   IF g_fah.fahdmy3 = 'Y' THEN
#      CALL s_chknpq(g_fbe.fbe01,'FA',1,'0',g_bookno1)  #No.FUN-740033
#     #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN     #FUN-AB0088 mark
#      IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN     #FUN-AB0088 add    
#         CALL s_chknpq(g_fbe.fbe01,'FA',1,'1',g_bookno2)  #No.FUN-740033
#      END IF
#   END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
    IF g_fah.fahdmy3 = 'Y' THEN
       CALL s_chknpq(g_fbe.fbe01,'FA',1,'0',g_bookno1)  #No.FUN-740033
    END IF
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN     #FUN-AB0088 add
       IF g_fah.fahdmy32 = 'Y' THEN
          CALL s_chknpq(g_fbe.fbe01,'FA',1,'1',g_bookno2)  #No.FUN-740033
       END IF
    END IF
#FUN-C30313---add---END-------
   IF g_success = 'N' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
    OPEN t110_cl USING g_fbe.fbe01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
   #-->更新異動單據過帳碼
   UPDATE fbe_file SET fbeconf = 'Y' WHERE fbe01 = g_fbe.fbe01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fbe_file",g_fbe.fbe01,"",SQLCA.sqlcode,"","upd fbeconf",1)  #No.FUN-660136
      LET g_success = 'N'
      ROLLBACK WORK
   ELSE
      LET g_fbe.fbeconf='Y'
      DISPLAY BY NAME g_fbe.fbeconf #
      COMMIT WORK
      CALL cl_flow_notify(g_fbe.fbe01,'Y')
   END IF
   IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbe.fbe18 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbe.fbeconf,g_chr2,g_fbe.fbepost,"",g_chr,"")
END FUNCTION
 
FUNCTION t110_y_chk()
  DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_cnt2 LIKE type_file.num5,
         l_fan07 LIKE fan_file.fan07,
         l_yy,l_mm   LIKE type_file.num5,
         l_last      LIKE type_file.num5,
         l_rate      LIKE azx_file.azx04, 
         l_curr      LIKE fbf_file.fbf06,
         l_amt       LIKE fan_file.fan07,
         l_qty       LIKE fbh_file.fbh04,
         l_fbf08     LIKE fbf_file.fbf08,
         l_fbf11     LIKE fbf_file.fbf11, #CHI-9C0008 add
         l_npq07f_d,l_npq07f_c    LIKE npq_file.npq07f,
         l_npq07_d,l_npq07_c      LIKE npq_file.npq07,
         l_cost,l_totcost         LIKE faj_file.faj14,
         l_fbf       RECORD LIKE fbf_file.*,
         l_t1        LIKE fah_file.fahslip,
         l_fahdmy3   LIKE fah_file.fahdmy3,
         l_fahdmy32  LIKE fah_file.fahdmy32, #FUN-C30313 add
         l_faj43     LIKE faj_file.faj43,  #MOD-990043 add
         l_faj09     LIKE faj_file.faj09   #MOD-990202 add
#-----NO:FUN-B90096 add start--
  DEFINE l_fbf072    LIKE fbf_file.fbf072
  DEFINE l_fbf082    LIKE fbf_file.fbf082
  DEFINE l_fbf112    LIKE fbf_file.fbf112
  DEFINE l_fbf092    LIKE fbf_file.fbf092,
         l_curr2      LIKE fbf_file.fbf06,
         l_qty2       LIKE fbf_file.fbf04
#-----NO:FUN-B90096 add end----         
  DEFINE l_faj28     LIKE faj_file.faj28   #MOD-9A0096    
  DEFINE l_flag1     LIKE type_file.chr1   #MOD-A30159 add

  LET g_success = 'Y'              #FUN-580109
 
  IF s_shut(0) THEN
     LET g_success = 'N'           #FUN-580109
     RETURN
  END IF
  IF g_fbe.fbe01 IS NULL THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('',-400,0)
     RETURN
  END IF
#CHI-C30107 ------------ add -------------- begin
  IF g_fbe.fbeconf='Y' THEN
     LET g_success = 'N'       
     CALL cl_err('','9023',0)    
     RETURN
  END IF
  IF (cl_null(g_fbe.fbe12) OR g_fbe.fbe12='N')
     AND  g_faa.faa23='Y' THEN
     LET g_success = 'N'           
     CALL cl_err('','afa-923',0)
     RETURN
  END IF
  IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
     g_action_choice CLIPPED = "insert"    
  THEN
     IF NOT cl_confirm('axm-108') THEN   LET g_success = 'N' RETURN END IF 
  END IF
#CHI-C30107 ------------ add -------------- end
  SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
  IF g_fbe.fbeconf = 'X' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','9024',0)
     RETURN
  END IF
  IF g_fbe.fbeconf='Y' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','9023',0)      #FUN-580109
     RETURN
  END IF
  IF (cl_null(g_fbe.fbe12) OR g_fbe.fbe12='N')
     AND  g_faa.faa23='Y' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','afa-923',0)
     RETURN
  END IF
  SELECT COUNT(*) INTO l_cnt FROM fbf_file
   WHERE fbf01= g_fbe.fbe01
  IF l_cnt = 0 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','mfg-009',0)
     RETURN
  END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-->立帳日期小於關帳日期
  IF g_fbe.fbe02 < g_faa.faa09 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(g_fbe.fbe01,'aap-176',1)
     RETURN
  END IF
  #-----No:FUN-B60140-----
  IF g_faa.faa31 = "Y" THEN
     #-->立帳日期小於關帳日期
     IF g_fbe.fbe02 < g_faa.faa092 THEN
        LET g_success = 'N'
        CALL cl_err(g_fbe.fbe01,'aap-176',1)
        RETURN
     END IF
  END IF
  #-----No:FUN-B60140 END-----
 
  IF g_faa.faa23 = 'Y' THEN 
     LET l_cnt2 = 1
     DECLARE fbf_curs2 CURSOR FOR 
         SELECT fbf02,fbf03,fbf031,faj06,faj18,fbf04,fbf05,
                faj15,fbf06,fbf07,fbf08,fbf11,fbf09                                    #CHI-D10032 add faj15
          FROM fbf_file LEFT OUTER JOIN faj_file ON fbf03=faj02 AND fbf031=faj022
             WHERE fbf01 =g_fbe.fbe01
          ORDER BY 1
     FOREACH fbf_curs2 INTO g_fbf[l_cnt2].*  
       #SELECT (faj17-faj58),(faj33+faj331),faj43,faj28 INTO l_qty,l_curr,l_faj43,l_faj28   #MOD-970231  #MOD-990043 add faj43 #MOD-9A0096 add faj28 #CHI-9C0008 mark
        SELECT (faj17-faj58),(faj33+faj331),faj43,faj28,(faj101-faj102) #CHI-9C0008 
          INTO l_qty,l_curr,l_faj43,l_faj28,l_fbf11   #CHI-9C0008
          FROM faj_file WHERE faj02=g_fbf[l_cnt2].fbf03 AND faj022=g_fbf[l_cnt2].fbf031
       #MOD-A30159---modify---start---
       #IF l_faj43 != '4' THEN   #資產狀態<>4.折畢   #MOD-990043 add        
         SELECT faj26 INTO g_faj26 
         FROM faj_file 
        WHERE faj02=g_fbf[l_cnt2].fbf03
          AND (faj022=g_fbf[l_cnt2].fbf031 OR faj022 is null)
          AND faj43 NOT IN ('0','5','6','X')
          AND fajconf='Y'
        LET l_flag1 = 'N' 
       #FUN-D80046--add--str--
       SELECT faj09 INTO l_faj09 FROM faj_file
         WHERE faj02=g_fbf[l_cnt2].fbf03 AND faj022=g_fbf[l_cnt2].fbf031
       IF l_faj09!='2' AND l_faj09!='5' THEN
       #FUN-D80046--add--end

       #-MOD-AA0001-add-
       #IF (YEAR(g_faj26) = YEAR(g_fbe.fbe02)) AND (MONTH(g_faj26) = MONTH(g_fbe.fbe02)) AND g_faa.faa15 = '3' THEN 
       #   LET l_flag1 = 'Y'                                                                                    
       #END IF                                                                                              
       #IF (g_faa.faa15 = '2' OR g_faa.faa15 = '4' OR l_flag1 = 'Y') AND l_faj43 != '4' THEN  
           #當參數勾選當月處份應提列折舊,應卡當月份是否有提列折舊,若沒有則不可確認
           IF (YEAR(g_faj26) = YEAR(g_fbe.fbe02)) AND (MONTH(g_faj26) = MONTH(g_fbe.fbe02)) THEN
              IF g_faa.faa15 = '3' AND DAY(g_fbe.fbe02) <= 15 AND l_faj43 <> '4' THEN
                 LET l_flag1 = 'Y'
              END IF
              IF (g_faa.faa15 = '2' OR g_faa.faa15 = '4') AND l_faj43 <> '4' THEN
                 LET l_flag1 = 'Y'
              END IF
           ELSE
              IF l_faj43 <> '4' THEN
                 LET l_flag1 = 'Y'
              END IF
           END IF
           IF l_flag1 = 'Y' THEN  
       #-MOD-AA0001-end-
       #MOD-A30159---modify---end--- 
           SELECT fan07 INTO l_fan07 FROM fan_file
            WHERE fan01 = g_fbf[l_cnt2].fbf03  AND fan02 = g_fbf[l_cnt2].fbf031
              AND fan03 = YEAR(g_fbe.fbe02)
              AND fan04 = MONTH(g_fbe.fbe02)
                 AND fan041= '1'
              IF cl_null(l_fan07) THEN
                #IF l_faj28<>'0' THEN                    #MOD-9A0096     #MOD-BA0165 mark
                 IF l_faj28<>'0' AND l_curr > 0 THEN     #MOD-BA0165 add
                    CALL cl_err('','afa-526',0)   #CHI-840068
                    LET g_success='N'
                    RETURN
                 END IF #MOD-9A0096    
              END IF
           END IF   #MOD-990043 add
        END IF #FUN-D80046
        IF g_faa.faa15='4' THEN
           LET l_yy = YEAR(g_fbe.fbe02) USING '&&&&'
           LET l_mm = MONTH(g_fbe.fbe02)
           IF l_mm = 12 THEN
              LET l_mm = 1 LET l_yy = l_yy + 1
           ELSE
              LET l_mm = l_mm + 1
           END IF
           LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
           LET l_rate = DAY(g_fbe.fbe02) / l_last
           LET l_amt = l_fan07 * l_rate
           LET l_curr = l_curr +l_fan07 - l_amt    #未折減額      
           LET l_curr = cl_digcut(l_curr,g_azi04)
        END IF
        IF l_qty = 0 OR cl_null(l_qty) THEN
           LET l_fbf08=l_curr   #未折減額
        ELSE 
           LET l_fbf08=l_curr *(g_fbf[l_cnt2].fbf04/l_qty)  #未折減額
           LET l_fbf08=cl_digcut(l_fbf08,g_azi04)   #MOD-810219
           LET l_fbf11=l_fbf11*(g_fbf[l_cnt2].fbf04/l_qty)  #TQC-B80010 add
           LET l_fbf11=cl_digcut(l_fbf11,g_azi04)           #TQC-B80010 add
        END IF
 
        IF l_faj43 <> '4' THEN #CHI-9C0008 add
           LET l_fbf08=cl_digcut(l_fbf08,g_azi04) #CHI-9C0008 add
           IF l_fbf08 <> g_fbf[l_cnt2].fbf08 THEN 
              LET g_success = 'N'
              CALL cl_err(g_fbf[l_cnt2].fbf03,'afa-153',1)
              RETURN
           END IF
           #CHI-9C0008 add --start--
           LET l_fbf11=cl_digcut(l_fbf11,g_azi04)
           IF l_fbf11 <> g_fbf[l_cnt2].fbf11 THEN 
              LET g_success = 'N'
              CALL cl_err(g_fbf[l_cnt2].fbf03,'afa-153',1)
              RETURN
           END IF
           #CHI-9C0008 add --end--
        END IF #CHI-9C0008 add
        LET l_cnt2 = l_cnt2 + 1
     END FOREACH  

     #-----NO:FUN-B90096 add start--
     IF g_faa.faa31 = 'Y' THEN     
        IF g_faa.faa232 = 'Y' THEN 
           LET l_cnt2 = 1
           DECLARE fbf_curs22 CURSOR FOR 
              SELECT fbf02,fbf03,fbf031,faj06,faj18,fbf04,fbf06,
                     faj15,fbf072,fbf082,fbf112,fbf092                  #CHI-D10032 add faj15
                FROM fbf_file, OUTER faj_file
              WHERE fbf03=faj02 AND fbf031=faj022
                AND fbf01 =g_fbe.fbe01
              ORDER BY 1
           FOREACH fbf_curs22 INTO g_fbf2[l_cnt2].*
              SELECT (faj17-faj582),(faj332+faj3312) INTO l_qty2,l_curr2
                FROM faj_file
              WHERE faj02=g_fbf2[l_cnt2].fbf03 AND faj022=g_fbf2[l_cnt2].fbf031

              IF g_faa.faa15='4' THEN
                 SELECT fan07 INTO l_fan07 FROM fan_file
                 WHERE fan01 = g_fbf2[l_cnt2].fbf03  AND fan02 = g_fbf2[l_cnt2].fbf031
                   AND fan03 = YEAR(g_fbe.fbe02)
                   AND fan04 = MONTH(g_fbe.fbe02)
                   AND fan041= '1'
                 IF cl_null(l_fan07) THEN
                    CALL cl_err('','afa-376',0)
                    LET g_success='N'
                    RETURN
                 END IF
                 LET l_yy = YEAR(g_fbe.fbe02) USING '&&&&'
                 LET l_mm = MONTH(g_fbe.fbe02)
                 IF l_mm = 12 THEN
                    LET l_mm = 1 LET l_yy = l_yy + 1
                 ELSE
                    LET l_mm = l_mm + 1
                 END IF
                 LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
                 LET l_rate = DAY(g_fbe.fbe02) / l_last
                 LET l_amt = l_fan07 * l_rate
                 LET l_curr2 = l_curr2 +l_fan07 - l_amt    #未折減額      
                 LET l_curr2 = cl_digcut(l_curr2,g_azi04)
              END IF
              IF l_qty2 = 0 OR cl_null(l_qty2) THEN
                 LET l_fbf082=l_curr2   #未折減額
              ELSE 
                 LET l_fbf082=l_curr2 *(g_fbf2[l_cnt2].fbf04/l_qty2)  #未折減額
                 #LET l_fbf082=cl_digcut(l_fbf082,g_azi04) #CHI-C60010 mark
                 LET l_fbf082=cl_digcut(l_fbf082,g_azi04_1)  #CHI-C60010
              END IF
              IF l_fbf082 <> g_fbf2[l_cnt2].fbf082 THEN 
                 LET g_success = 'N'
                 CALL cl_err(g_fbf2[l_cnt2].fbf03,'afa-153',1)
                 RETURN
              END IF
              LET l_cnt2 = l_cnt2 + 1
           END FOREACH
        END IF         
     END IF
     CALL g_fbf2.deleteElement(l_cnt2)         
     #-----NO:FUN-B90096 add end----      
     CALL g_fbf.deleteElement(l_cnt2)
  END IF
  #判斷分錄是否有重新產生
  LET l_t1 = s_get_doc_no(g_fbe.fbe01)      
  LET l_fahdmy3 = ''
  SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1
  IF l_fahdmy3='Y' THEN
     LET l_npq07f_d = 0
     LET l_npq07_d = 0
     LET l_npq07f_c = 0
     LET l_npq07_c = 0
     SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
       WHERE npq01 = g_fbe.fbe01
         AND npq011 = 1
         AND npqsys = 'FA'
         AND npq00 = 4
         AND npq06 = '1'
         AND npqtype='0'
     SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
       WHERE npq01 = g_fbe.fbe01
         AND npq011 = 1
         AND npqsys = 'FA'
         AND npq00 = 4
         AND npq06 = '2'
         AND npqtype='0'
     IF cl_null(l_npq07f_d) THEN LET l_npq07f_d = 0 END IF
     IF cl_null(l_npq07_d) THEN LET l_npq07_d = 0 END IF
     IF cl_null(l_npq07f_c) THEN LET l_npq07f_c = 0 END IF
     IF cl_null(l_npq07_c) THEN LET l_npq07_c = 0 END IF
     LET l_cnt2 = 1
     LET l_totcost = 0
     DECLARE fbf_curs3 CURSOR FOR 
         SELECT fbf02,fbf03,fbf031,faj06,faj18,fbf04,fbf05,
                faj15,fbf06,fbf07,fbf08,fbf11,fbf09                                    #CHI-D10032 add faj15
          FROM fbf_file LEFT OUTER JOIN faj_file ON fbf03=faj02 AND fbf031=faj022
             WHERE fbf01 =g_fbe.fbe01
          ORDER BY 1
     FOREACH fbf_curs3 INTO g_fbf[l_cnt2].*  
        LET l_cost = 0
        SELECT faj09 INTO l_faj09 FROM faj_file
         WHERE faj02=g_fbf[l_cnt2].fbf03 AND faj022=g_fbf[l_cnt2].fbf031
        IF l_faj09!='5' THEN
           SELECT (faj14+faj141-faj59)/(faj17-faj58) INTO l_cost
             FROM faj_file WHERE faj02=g_fbf[l_cnt2].fbf03 AND 
                                 faj022=g_fbf[l_cnt2].fbf031
        ELSE
           SELECT (faj141-faj59)/(faj17-faj58) INTO l_cost
             FROM faj_file WHERE faj02=g_fbf[l_cnt2].fbf03 AND 
                                 faj022=g_fbf[l_cnt2].fbf031
        END IF
        LET l_cost = l_cost * g_fbf[l_cnt2].fbf04
        LET l_cost = cl_digcut(l_cost,g_azi04)   #MOD-810219
        LET l_totcost = l_totcost + l_cost
       #---------------------------------MOD-C20035---------------------start
       #IF g_fbe.fbe10 < 0 AND g_fbf[l_cnt2].fbf09 > 0 THEN
       #   LET l_totcost = l_totcost + g_fbf[l_cnt2].fbf09
       #END IF
 
       #IF g_fbe.fbe10 > 0 AND g_fbf[l_cnt2].fbf09 < 0 THEN                                                                        
       #   LET l_totcost = l_totcost - g_fbf[l_cnt2].fbf09                                                                         
       #END IF                                                                                                                     
        IF l_faj09!='5' THEN    #CHI-C70037
          #IF g_faa.faa29 = 'N' AND g_aza.aza26 <> '2' THEN   #CHI-C70037 mark
           IF g_faa.faa29 = 'N' OR g_aza.aza26 <> '2' THEN    #CHI-C70037
             #IF g_fbe.fbe10 <> 0 AND g_fbf[l_cnt2].fbf09 > 0 THEN      #MOD-D20086 mark
              IF g_fbe.fbe10 > 0 THEN                                   #MOD-D20086 add
                 LET l_totcost = l_totcost + g_fbf[l_cnt2].fbf09
              END IF
           END If
        ELSE                                                            #MOD-CA0237 add
           LET l_totcost = l_totcost + g_fbf[l_cnt2].fbf09              #MOD-CA0237 add
        END If                  #CHI-C70037
       #---------------------------------MOD-C20035-----------------------end 

        LET l_cnt2 = l_cnt2 + 1
     END FOREACH
     CALL g_fbf.deleteElement(l_cnt2)
     IF g_faa.faa29 = 'Y' THEN
        IF l_totcost <> l_npq07_d OR
           l_totcost <> l_npq07_c THEN
           LET g_success = 'N'
           CALL cl_err('','afa-154',1)
           RETURN
        END IF
     ELSE
      #-MOD-C20096-mark-  MOD-C30722 rollback
      #CHI-C70037---mark---
      #IF g_fbe.fbe10 >= 0 THEN                      #CHI-C70037
      #   IF l_totcost + g_fbe.fbe10 + g_fbe.fbe09x <> l_npq07_d OR 
      #      l_totcost + g_fbe.fbe10 + g_fbe.fbe09x <> l_npq07_c THEN
      #       LET g_success = 'N'
      #      CALL cl_err('','afa-154',1)
      #       RETURN
      #   END IF
      #ELSE
      #CHI-C70037---mark---
       #-MOD-C20096-end-MOD-C30722 rollback
           IF l_totcost + g_fbe.fbe09x <> l_npq07_d OR 
              l_totcost + g_fbe.fbe09x <> l_npq07_c THEN
               LET g_success = 'N'
               CALL cl_err('','afa-154',1)
               RETURN
           END IF
     #END IF   #CHI-C70037 mark #MOD-C20096 mark---MOD-C30722 rollback
     END IF
#FUN-C30313---mark---START
#   #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088  mark
#    IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088  add 
#       LET l_npq07f_d = 0
#       LET l_npq07_d = 0
#       LET l_npq07f_c = 0
#       LET l_npq07_c = 0
#       SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
#         WHERE npq01 = g_fbe.fbe01
#           AND npq011 = 1
#           AND npqsys = 'FA'
#           AND npq00 = 4
#           AND npq06 = '1'
#           AND npqtype='1'
#       SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
#         WHERE npq01 = g_fbe.fbe01
#           AND npq011 = 1
#           AND npqsys = 'FA'
#           AND npq00 = 4
#           AND npq06 = '2'
#           AND npqtype='1'
#       IF cl_null(l_npq07f_d) THEN LET l_npq07f_d = 0 END IF
#       IF cl_null(l_npq07_d) THEN LET l_npq07_d = 0 END IF
#       IF cl_null(l_npq07f_c) THEN LET l_npq07f_c = 0 END IF
#       IF cl_null(l_npq07_c) THEN LET l_npq07_c = 0 END IF
#       LET l_cnt2 = 1
#       LET l_totcost = 0
#       DECLARE fbf_curs4 CURSOR FOR 
#           SELECT fbf02,fbf03,fbf031,faj06,faj18,fbf04,fbf05,
#                  fbf06,fbf07,fbf08,fbf11,fbf09
#            FROM fbf_file LEFT OUTER JOIN faj_file ON fbf03 = faj_file.faj02 AND fbf031 = faj_file.faj022
#               WHERE fbf01 =g_fbe.fbe01
#            ORDER BY 1
#       FOREACH fbf_curs4 INTO g_fbf[l_cnt2].*  
#          LET l_cost = 0
#          SELECT faj09 INTO l_faj09 FROM faj_file
#           WHERE faj02=g_fbf[l_cnt2].fbf03 AND faj022=g_fbf[l_cnt2].fbf031
#          IF l_faj09!='5' THEN
#            #SELECT (faj14+faj141-faj59)/(faj17-faj58) INTO l_cost      #FUN-AB0088 mark
#             SELECT (faj142+faj1412-faj592)/(faj17-faj582) INTO l_cost  #FUN-AB0088 add
#               FROM faj_file WHERE faj02=g_fbf[l_cnt2].fbf03 AND 
#                                   faj022=g_fbf[l_cnt2].fbf031
#          ELSE
#            #SELECT (faj141-faj59)/(faj17-faj58) INTO l_cost      #FUN-AB0088 mark
#             SELECT (faj1412-faj592)/(faj17-faj582) INTO l_cost   #FUN-AB0088 add
#               FROM faj_file WHERE faj02=g_fbf[l_cnt2].fbf03 AND 
#                                   faj022=g_fbf[l_cnt2].fbf031
#          END IF
#          LET l_cost = l_cost * g_fbf[l_cnt2].fbf04
#          LET l_cost = cl_digcut(l_cost,g_azi04)   #MOD-810219
#          LET l_totcost = l_totcost + l_cost
#         #---------------------------------MOD-C20035---------------------start
#         #IF g_fbe.fbe10 < 0 AND g_fbf[l_cnt2].fbf09 > 0 THEN
#         #   LET l_totcost = l_totcost + g_fbf[l_cnt2].fbf09
#         #END IF
#         #IF g_fbe.fbe10 > 0 AND g_fbf[l_cnt2].fbf09 < 0 THEN                                                                        
#         #   LET l_totcost = l_totcost - g_fbf[l_cnt2].fbf09                                                                         
#         #END IF
#          IF g_faa.faa29 = 'N' AND g_aza.aza26 <> '2' THEN
#             IF g_fbe.fbe10 <> 0 AND g_fbf[l_cnt2].fbf09 > 0 THEN
#                LET l_totcost = l_totcost + g_fbf[l_cnt2].fbf09
#             END IF
#          END If
#         #---------------------------------MOD-C20035-----------------------end
#                                                                                                                    
#          LET l_cnt2 = l_cnt2 + 1
#       END FOREACH
#       CALL g_fbf.deleteElement(l_cnt2)
#       IF g_faa.faa29 = 'Y' THEN
#          IF l_totcost <> l_npq07_d OR
#             l_totcost <> l_npq07_c THEN
#             LET g_success = 'N'
#             CALL cl_err('','afa-154',1)
#             RETURN
#          END IF
#       ELSE
#          IF g_fbe.fbe10 >= 0 THEN
#             IF l_totcost + g_fbe.fbe10 + g_fbe.fbe09x <> l_npq07_d OR 
#                l_totcost + g_fbe.fbe10 + g_fbe.fbe09x <> l_npq07_c THEN
#                 LET g_success = 'N'
#                 CALL cl_err('','afa-154',1)
#                 RETURN
#             END IF
#          ELSE
#             IF l_totcost + g_fbe.fbe09x <> l_npq07_d OR 
#                l_totcost + g_fbe.fbe09x <> l_npq07_c THEN
#                 LET g_success = 'N'
#                 CALL cl_err('','afa-154',1)
#                 RETURN
#             END IF
#          END IF
#       END IF
#    END IF
#FUN-C30313---mark---END
  END IF

#FUN-C30313---add---START-----
  IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088  add 
     LET l_fahdmy32 = ''
     SELECT fahdmy32 INTO l_fahdmy32 FROM fah_file WHERE fahslip = l_t1
     IF l_fahdmy32='Y' THEN     
        LET l_npq07f_d = 0
        LET l_npq07_d = 0
        LET l_npq07f_c = 0
        LET l_npq07_c = 0
        SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
          WHERE npq01 = g_fbe.fbe01
            AND npq011 = 1
            AND npqsys = 'FA'
            AND npq00 = 4
            AND npq06 = '1'
            AND npqtype='1'
        SELECT SUM(npq07f),SUM(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
          WHERE npq01 = g_fbe.fbe01
            AND npq011 = 1
            AND npqsys = 'FA'
            AND npq00 = 4
            AND npq06 = '2'
            AND npqtype='1'
        IF cl_null(l_npq07f_d) THEN LET l_npq07f_d = 0 END IF
        IF cl_null(l_npq07_d) THEN LET l_npq07_d = 0 END IF
        IF cl_null(l_npq07f_c) THEN LET l_npq07f_c = 0 END IF
        IF cl_null(l_npq07_c) THEN LET l_npq07_c = 0 END IF
        LET l_cnt2 = 1
        LET l_totcost = 0
        DECLARE fbf_curs4 CURSOR FOR 
            SELECT fbf02,fbf03,fbf031,faj06,faj18,fbf04,fbf05,
                   faj15,fbf06,fbf07,fbf08,fbf11,fbf09                                    #CHI-D10032 add faj15
             FROM fbf_file LEFT OUTER JOIN faj_file ON fbf03 = faj_file.faj02 AND fbf031 = faj_file.faj022
                WHERE fbf01 =g_fbe.fbe01
             ORDER BY 1
        FOREACH fbf_curs4 INTO g_fbf[l_cnt2].*  
           LET l_cost = 0
           SELECT faj09 INTO l_faj09 FROM faj_file
            WHERE faj02=g_fbf[l_cnt2].fbf03 AND faj022=g_fbf[l_cnt2].fbf031
           IF l_faj09!='5' THEN
             #SELECT (faj14+faj141-faj59)/(faj17-faj58) INTO l_cost      #FUN-AB0088 mark
              SELECT (faj142+faj1412-faj592)/(faj17-faj582) INTO l_cost  #FUN-AB0088 add
                FROM faj_file WHERE faj02=g_fbf[l_cnt2].fbf03 AND 
                                    faj022=g_fbf[l_cnt2].fbf031
           ELSE
             #SELECT (faj141-faj59)/(faj17-faj58) INTO l_cost      #FUN-AB0088 mark
              SELECT (faj1412-faj592)/(faj17-faj582) INTO l_cost   #FUN-AB0088 add
                FROM faj_file WHERE faj02=g_fbf[l_cnt2].fbf03 AND 
                                    faj022=g_fbf[l_cnt2].fbf031
           END IF
           LET l_cost = l_cost * g_fbf[l_cnt2].fbf04
           LET l_cost = cl_digcut(l_cost,g_azi04)   #MOD-810219
           LET l_totcost = l_totcost + l_cost
          #------------------------MOD-D20086-----------------(S)
           IF g_faa.faa29 = 'N' AND g_aza.aza26 <> '2' THEN
              IF g_fbe.fbe10 > 0 THEN                                   
                 LET l_totcost = l_totcost + g_fbf[l_cnt2].fbf09
              END IF
           END If
          #------------------------MOD-D20086-----------------(S)
           LET l_cnt2 = l_cnt2 + 1
        END FOREACH
        CALL g_fbf.deleteElement(l_cnt2)
        IF g_faa.faa29 = 'Y' THEN
           IF l_totcost <> l_npq07_d OR
              l_totcost <> l_npq07_c THEN
              LET g_success = 'N'
              CALL cl_err('','afa-154',1)
              RETURN
           END IF
        ELSE
           IF g_fbe.fbe10 >= 0 THEN
              IF l_totcost + g_fbe.fbe10 + g_fbe.fbe09x <> l_npq07_d OR 
                 l_totcost + g_fbe.fbe10 + g_fbe.fbe09x <> l_npq07_c THEN
                  LET g_success = 'N'
                  CALL cl_err('','afa-154',1)
                  RETURN
              END IF
           ELSE
              IF l_totcost + g_fbe.fbe09x <> l_npq07_d OR 
                 l_totcost + g_fbe.fbe09x <> l_npq07_c THEN
                  LET g_success = 'N'
                  CALL cl_err('','afa-154',1)
                  RETURN
              END IF
           END IF
        END IF
     END IF
  END IF
#FUN-C30313---add---END-------
 
  DECLARE t110_cur6 CURSOR FOR
     SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
  FOREACH t110_cur6 INTO l_fbf.*
     LET l_cnt = 0
     IF g_faa.faa23 = 'Y' THEN
        SELECT COUNT(*) INTO l_cnt FROM fan_file
         WHERE fan01 = l_fbf.fbf03
           AND fan02 = l_fbf.fbf031
           AND ((fan03 = YEAR(g_fbe.fbe02) AND fan04 > MONTH(g_fbe.fbe02))
            OR fan03 > YEAR(g_fbe.fbe02)) 
           AND fan041 = '1'   #MOD-C50044 add
     ELSE
        SELECT COUNT(*) INTO l_cnt FROM fan_file
         WHERE fan01 = l_fbf.fbf03
           AND fan02 = l_fbf.fbf031
           AND ((fan03 = YEAR(g_fbe.fbe02) AND fan04 >= MONTH(g_fbe.fbe02))
            OR fan03 > YEAR(g_fbe.fbe02)) 
           AND fan041 = '1'   #MOD-C50044 add
     END IF
     IF l_cnt > 0 THEN
        LET g_success='N'
        CALL cl_err(l_fbf.fbf03,'afa-348',0)
        RETURN
     END IF
     LET l_cnt = 0
     IF g_faa.faa23 = 'Y' THEN
        SELECT COUNT(*) INTO l_cnt FROM fao_file
         WHERE fao01 = l_fbf.fbf03
           AND fao02 = l_fbf.fbf031
           AND ((fao03 = YEAR(g_fbe.fbe02) AND fao04 > MONTH(g_fbe.fbe02))
            OR fao03 > YEAR(g_fbe.fbe02)) 
           AND fao041 = '1'   #MOD-C50044 add 
     ELSE
        SELECT COUNT(*) INTO l_cnt FROM fao_file
         WHERE fao01 = l_fbf.fbf03
           AND fao02 = l_fbf.fbf031
           AND ((fao03 = YEAR(g_fbe.fbe02) AND fao04 >= MONTH(g_fbe.fbe02))
            OR fao03 > YEAR(g_fbe.fbe02)) 
           AND fao041 = '1'   #MOD-C50044 add
     END IF
     IF l_cnt > 0 THEN
        LET g_success='N'
        CALL cl_err(l_fbf.fbf03,'afa-348',0)
        RETURN
     END IF
     #-----No:FUN-B60140-----
     IF g_faa.faa31 = "Y" THEN
        LET l_cnt = 0
        IF g_faa.faa232 = 'Y' THEN
           SELECT COUNT(*) INTO l_cnt FROM fbn_file
            WHERE fbn01 = l_fbf.fbf03
              AND fbn02 = l_fbf.fbf031
              AND ((fbn03 = YEAR(g_fbe.fbe02) AND fbn04 > MONTH(g_fbe.fbe02))
               OR fbn03 > YEAR(g_fbe.fbe02))
              AND fbn041 = '1'   #MOD-C50044 add
        ELSE
           SELECT COUNT(*) INTO l_cnt FROM fbn_file
            WHERE fbn01 = l_fbf.fbf03
              AND fbn02 = l_fbf.fbf031
              AND ((fbn03 = YEAR(g_fbe.fbe02) AND fbn04 >= MONTH(g_fbe.fbe02))
               OR fbn03 > YEAR(g_fbe.fbe02)) 
              AND fbn041 = '1'   #MOD-C50044 add
        END IF
        IF l_cnt > 0 THEN
           LET g_success='N'
           CALL cl_err(l_fbf.fbf03,'afa-348',0)
           RETURN
        END IF
     END IF
     #-----No:FUN-B60140 END-----
  END FOREACH

  #----------------------------------- 檢查分錄底稿平衡正確否
  LET g_t1 = s_get_doc_no(g_fbe.fbe01)  #No.FUN-670060                                                                           
  SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1  #No.FUN-670060
#FUN-C30313---mark---START
# IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
#    CALL s_chknpq(g_fbe.fbe01,'FA',1,'0',g_bookno1)  #No.FUN-740033
#   #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
#    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 add
#       CALL s_chknpq(g_fbe.fbe01,'FA',1,'1',g_bookno2)  #No.FUN-740033
#    END IF
# END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
     CALL s_chknpq(g_fbe.fbe01,'FA',1,'0',g_bookno1)  #No.FUN-740033
  END IF
  IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 add
     IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'N' THEN
        CALL s_chknpq(g_fbe.fbe01,'FA',1,'1',g_bookno2)  #No.FUN-740033
     END IF
  END IF
#FUN-C30313---add---END-------
 
  IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t110_y_upd()
   DEFINE l_n    LIKE type_file.num10      #No.FUN-670060       #No.FUN-680070 INTEGER
   #CHI-B80007 -- begin --
   DEFINE l_fbf     RECORD LIKE fbf_file.*
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_cnt     LIKE type_file.num5
   #CHI-B80007 -- begin --
 
   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"     #FUN-640243
   THEN
      IF g_fbe.fbemksg='Y'   THEN
          IF g_fbe.fbe18 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF
  
   BEGIN WORK
  
   OPEN t110_cl USING g_fbe.fbe01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t110_cl ROLLBACK WORK RETURN
   END IF

   #CHI-B80007 -- begin --
   DECLARE t110_fbf_cur CURSOR FOR
      SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
   FOREACH t110_fbf_cur INTO l_fbf.*
      SELECT count(*) INTO l_cnt FROM fbf_file,fbe_file
       WHERE fbf01 = fbe01
         AND fbf03 = l_fbf.fbf03
         AND fbf031= l_fbf.fbf031 AND fbe02 <= g_fbe.fbe02
         AND fbepost = 'N'
         AND fbe01 != g_fbe.fbe01
         AND fbeconf <> 'X'
      IF l_cnt  > 0 THEN
         LET l_msg = l_fbf.fbf01,' ',l_fbf.fbf02,' ',
                     l_fbf.fbf03,' ',l_fbf.fbf031
         CALL s_errmsg('','',l_msg,'afa-309',1)
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF
   #CHI-B80007 -- end --

#FUN-C30313---mark---START
#  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
#     SELECT count(*) INTO l_n FROM npq_file
#      WHERE npq01 = g_fbe.fbe01
#        AND npq011 = 1
#        AND npqsys = 'FA'
#        AND npq00 = 4
#     IF l_n = 0 THEN
#        CALL t110_gen_glcr(g_fbe.*,g_fah.*)
#     END IF
#     IF g_success = 'Y' THEN 
#        CALL s_chknpq(g_fbe.fbe01,'FA',1,'0',g_bookno1)  #No.FUN-740033
#       #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
#        IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 add
#           CALL s_chknpq(g_fbe.fbe01,'FA',1,'1',g_bookno2)  #No.FUN-740033
#        END IF
#     END IF
#     IF g_success = 'N' THEN RETURN END IF  #No.FUN-680028
#  END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_fbe.fbe01
         AND npq011 = 1
         AND npqsys = 'FA'
         AND npq00 = 4
     #IF l_n = 0 THEN                                                                     #MOD-C50255 mark
      IF l_n = 0 AND                                                                      #MOD-C50255 add
         ((g_fah.fahdmy3 = 'Y') OR (g_faa.faa31 = 'Y' AND g_fah.fahdmy32 = 'Y' )) THEN    #MOD-C50255 add
         CALL t110_gen_glcr(g_fbe.*,g_fah.*)
      END IF
      IF g_success = 'Y' THEN
         IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
            CALL s_chknpq(g_fbe.fbe01,'FA',1,'0',g_bookno1)  #No.FUN-740033
         END IF
         IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 add
            IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
               CALL s_chknpq(g_fbe.fbe01,'FA',1,'1',g_bookno2)  #No.FUN-740033
            END IF
         END IF
      END IF
      IF g_success = 'N' THEN RETURN END IF  #No.FUN-680028
#FUN-C30313---add---END-------
   #-->更新異動單據過帳碼
   UPDATE fbe_file SET fbeconf = 'Y' WHERE fbe01 = g_fbe.fbe01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fbe01',g_fbe.fbe01,'upd fbeconf',STATUS,1)    #No.FUN-710028
      LET g_success = 'N'
  
   END IF
  
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      IF g_fbe.fbemksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET g_fbe.fbeconf="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET g_fbe.fbeconf="N"
                  ROLLBACK WORK
                  RETURN
         END CASE
      END IF
      CLOSE t110_cl
      IF g_success = 'Y' THEN
         LET g_fbe.fbe18='1'             #執行成功, 狀態值顯示為 '1' 已核准
         UPDATE fbe_file SET fbe18 = g_fbe.fbe18 WHERE fbe01=g_fbe.fbe01
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
         LET g_fbe.fbeconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
         DISPLAY BY NAME g_fbe.fbeconf
         DISPLAY BY NAME g_fbe.fbe18
         COMMIT WORK
      ELSE
         LET g_fbe.fbeconf='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_fbe.fbeconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
  
   IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbe.fbe18 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbe.fbeconf,g_chr2,g_fbe.fbepost,"",g_chr,"")
  
END FUNCTION
 
FUNCTION t110_ef()
 
  CALL t110_y_chk()      #CALL 原確認的 check 段
  IF g_success = "N" THEN
     RETURN
  END IF
 
  CALL aws_condition()   #判斷送簽資料
  IF g_success = 'N' THEN
     RETURN
  END IF
 
######################################
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
######################################
 
  IF aws_efcli2(base.TypeInfo.create(g_fbe),base.TypeInfo.create(g_fbf),'','','','')
  THEN
     LET g_success='Y'
     LET g_fbe.fbe18='S'
     DISPLAY BY NAME g_fbe.fbe18
  ELSE
     LET g_success='N'
  END IF
END FUNCTION
 
FUNCTION t110_z()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
   IF g_fbe.fbe18  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF   #FUN-580109
   IF g_fbe.fbeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_fbe.fbeconf='N' THEN RETURN END IF
   IF g_fbe.fbepost='Y' THEN
      CALL cl_err(g_fbe.fbepost,'afa-106',0)
      RETURN
   END IF
   IF g_fbe.fbepost2='Y' THEN
      CALL cl_err(g_fbe.fbepost2,'afa-106',0)
      RETURN
   END IF
   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fbe.fbe14) THEN
      CALL cl_err(g_fbe.fbe14,'aap-145',1)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_fbe.fbe02 < g_faa.faa09 THEN
      CALL cl_err(g_fbe.fbe01,'aap-176',1) RETURN
   END IF

   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      #-->已拋轉總帳, 不可取消確認
      IF NOT cl_null(g_fbe.fbe142) THEN
         CALL cl_err(g_fbe.fbe142,'aap-145',1)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbe.fbe02 < g_faa.faa092 THEN
         CALL cl_err(g_fbe.fbe01,'aap-176',1) RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t110_cl USING g_fbe.fbe01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
 
   UPDATE fbe_file SET fbeconf = 'N',fbe18 = '0'  #FUN-580109
    WHERE fbe01 = g_fbe.fbe01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fbe_file",g_fbe.fbe01,"",SQLCA.sqlcode,"","upd fbeconf",1)  #No.FUN-660136
      LET g_fbe.fbeconf='Y'
      CLOSE t110_cl ROLLBACK WORK
   ELSE
      LET g_fbe.fbeconf='N'
      LET g_fbe.fbe18='0'   #FUN-580109
      CLOSE t110_cl
      COMMIT WORK
      DISPLAY BY NAME g_fbe.fbeconf #
      DISPLAY BY NAME g_fbe.fbe18    #FUN-580109
   END IF

   IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbe.fbe18 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbe.fbeconf,g_chr2,g_fbe.fbepost,"",g_chr,"")
END FUNCTION
 
FUNCTION t110_fbf031(p_cmd)
    DEFINE l_cnt    LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           m_faj06  LIKE faj_file.faj06,
           m_faj15  LIKE faj_file.faj15,         #CHI-D10032 add
           m_faj18  LIKE faj_file.faj18,
           m_fbf08  LIKE fbf_file.fbf08,
           m_fbf04  LIKE fbf_file.fbf04,
           m_fbf10  LIKE fbf_file.fbf10,
           m_faj100 LIKE faj_file.faj100,
           p_cmd    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
    DEFINE l_faj41  LIKE faj_file.faj41         #MOD-B30593
    DEFINE l_faj43  LIKE faj_file.faj43         #CHI-A70032 add
    DEFINE l_fbh03  LIKE fbh_file.fbh03         #CHI-A70032 add
    DEFINE l_faj15   LIKE faj_file.faj15        #MOD-C70059 add
 
    LET g_errno=' '

    #CHI-B80007 -- begin --
    SELECT count(*) INTO l_cnt FROM fbf_file,fbe_file
      WHERE fbf01 = fbe01
       AND fbf03  = g_fbf[l_ac].fbf03
       AND fbf031 = g_fbf[l_ac].fbf031
       AND fbe02 <= g_fbe.fbe02
       AND fbepost = 'N'
       AND fbe01 != g_fbe.fbe01
       AND fbeconf <> 'X'
    IF l_cnt > 0 THEN
       LET g_errno = 'afa-309'
       RETURN
    END IF
    #CHI-B80007 -- end --
    SELECT faj06,faj15,faj18,faj33+faj331,faj17-faj58,faj100,faj68,                 #MOD-970231 #CHI-D10032 add faj15
           faj40,faj42,faj26,faj68,(faj101-faj102),(faj103-faj104),faj43,faj41,  #CHI-840068 add faj68 #CHI-A70032 add faj43 #MOD-B30593 add faj41
           (faj1012-faj1022),                                                    #NO:FUN-B90096 add
           (faj332+faj3312),                                                     #TQC-C50162 add
           faj15                                                                 #MOD-C70059 add
      INTO m_faj06,m_faj15,m_faj18,g_fbf08,m_fbf04,m_faj100,m_fbf10,                #CHI-D10032 add faj15
           g_faj40,g_faj42,g_faj26,g_fbf10,g_fbf11,g_fbf12,l_faj43,l_faj41,      #CHI-840068 add g_fbf10 #CHI-A70032 add l_faj43 #MOD-B30593 add faj41
	   g_fbf112,                                                             #NO:FUN-B90096 add g_fbf112
           g_fbf082,                                                             #TQC-C50162 add
           l_faj15                                                               #MOD-C70059 add

      FROM faj_file WHERE faj02=g_fbf[l_ac].fbf03
       AND (faj022=g_fbf[l_ac].fbf031 OR faj022 is null)
      #AND faj43 NOT IN ('0','5','6','X') #CHI-A70032 mark
       AND fajconf='Y'
       #CHI-A70032 mod --start--
       #IF SQLCA.sqlcode
       #THEN LET g_errno='afa-093'
      IF SQLCA.sqlcode THEN LET g_errno='afa-134' END IF                              #MOD-C70265 add

   #-MOD-C50244-add-
    LET g_fbf072 = 0
    SELECT fbf072 INTO g_fbf072
      FROM fbf_file
     WHERE fbf01 = g_fbe.fbe01
       AND fbf02 = g_fbf[l_ac].fbf02
    IF cl_null(g_fbf072) THEN LET g_fbf072 = 0 END IF
    LET m_fbf04 = g_fbf[l_ac].fbf04
   #-MOD-C50244-end-

   #-----------------------MOD-C70059--------------------(S)
   #IF g_fbe.fbe05 != l_faj15 THEN           #CHI-D10032 mark
   #   LET g_errno = 'aap-020'               #CHI-D10032 mark
   #END IF                                   #CHI-D10032 mark
   #-----------------------MOD-C70059--------------------(E)

   #-MOD-B30593-add-
    IF l_faj41 MATCHES '[234]' THEN
       LET g_errno = 'afa-951'
    END IF
   #-MOD-B30593-end-

    IF l_faj43 MATCHES '[05X]' THEN
       LET g_errno='afa-093'
    #CHI-A70032 mod --end--
    ELSE
       #CHI-A70032 add --start--
       IF l_faj43='6' THEN
          SELECT fbh03 INTO l_fbh03
            FROM fbh_file
           WHERE fbh03=g_fbf[l_ac].fbf03
          IF SQLCA.sqlcode THEN
             LET g_errno='afa-093'
          END IF
       END IF
       #CHI-A70032 add --end--

       #-->最近異動日 > 出售日期
       IF m_faj100>=g_fbe.fbe02 THEN LET g_errno='afa-113' END IF
       #-->尚在盤點中不可出售
       SELECT COUNT(*) INTO l_cnt FROM fca_file
        WHERE fca03=g_fbf[l_ac].fbf03
          AND fca031=g_fbf[l_ac].fbf031 AND fca15='N'
       IF l_cnt>0 THEN
          LET g_errno='afa-097'
       ELSE
         #待出售數量(已打單未確認未作廢)
          IF p_cmd='a' THEN   #MOD-8B0243 add
             LET l_fbf04_1 = 0
             SELECT SUM(fbf04) INTO l_fbf04_1 FROM fbf_file,fbe_file
              WHERE fbf03 = g_fbf[l_ac].fbf03
                AND fbf031= g_fbf[l_ac].fbf031
                AND fbf01 = fbe01
                AND fbeconf='N'
             IF cl_null(l_fbf04_1) THEN LET l_fbf04_1=0 END IF
             LET m_fbf04 = m_fbf04 - l_fbf04_1
          END IF              #MOD-8B0243 add
          IF p_cmd='a' AND cl_null(g_errno) THEN             #MOD-950166                
             LET g_fbf[l_ac].fbf04=m_fbf04
             LET g_fbf[l_ac].fbf08=g_fbf08      #No:A099
             LET g_fbf[l_ac].faj06=m_faj06
             LET g_fbf[l_ac].faj15=m_faj15                   #CHI-D10032 add
             LET g_fbf[l_ac].faj18=m_faj18
             LET g_fbf[l_ac].fbf11=g_fbf11
             LET g_fbf2[l_ac].fbf112=g_fbf112 #NO:FUN-B90096 add
             LET g_fbf_e[l_ac].fbf10=g_fbf10
             LET g_fbf_e[l_ac].fbf12=g_fbf12
             DISPLAY g_fbf[l_ac].fbf11 TO fbf11
             DISPLAY g_fbf[l_ac].fbf04 TO fbf04
             DISPLAY g_fbf[l_ac].faj15 TO faj15     #CHI-D10032 add
             DISPLAY g_fbf[l_ac].fbf08 TO fbf08
             DISPLAY g_fbf[l_ac].faj06 TO faj06
             DISPLAY g_fbf[l_ac].faj18 TO faj18
             DISPLAY g_fbf[l_ac].fbf11 TO fbf11     #CHI-840068 add
          END IF
       END IF
    END IF
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        LET g_fbf[l_ac].faj06=m_faj06
        LET g_fbf[l_ac].faj15=m_faj15               #CHI-D10032 add
        LET g_fbf[l_ac].faj18=m_faj18
        DISPLAY BY NAME g_fbf[l_ac].faj06
        DISPLAY BY NAME g_fbf[l_ac].faj15           #CHI-D10032 add
        DISPLAY BY NAME g_fbf[l_ac].faj18
     END IF
END FUNCTION
 
FUNCTION t110_w1(p_cmd)
   DEFINE ls_tmp STRING
   DEFINE p_cmd  LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   LET p_row = 10 LET p_col = 20
   OPEN WINDOW t110_w1 AT p_row,p_col WITH FORM "afa/42f/afat1101"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat1101")
 
   IF p_cmd='u' THEN   ##------------ 若為更改狀態則須從檔案重新 select 出來
      SELECT fbf10,fbf12 INTO g_fbf_e[l_ac].fbf10,g_fbf_e[l_ac].fbf12
        FROM fbf_file
       WHERE fbf01=g_fbe.fbe01 AND fbf02=g_fbf[l_ac].fbf02
      IF STATUS=100 THEN
         LET g_fbf_e[l_ac].fbf10=0
         LET g_fbf_e[l_ac].fbf12=0
      END IF
   END IF
   DISPLAY g_fbf_e[l_ac].fbf10 TO fbf10
   DISPLAY g_fbf_e[l_ac].fbf12 TO fbf12
   INPUT g_fbf_e[l_ac].fbf12,g_fbf_e[l_ac].fbf10
         WITHOUT DEFAULTS FROM fbf12,fbf10
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t110_w1 RETURN END IF
   IF p_cmd='u' THEN
      UPDATE fbf_file SET fbf10=g_fbf_e[l_ac].fbf10,
                          fbf12=g_fbf_e[l_ac].fbf12
       WHERE fbf01=g_fbe.fbe01 AND fbf02=g_fbf[l_ac].fbf02
   END IF
   CLOSE WINDOW t110_w1
END FUNCTION
 
FUNCTION t110_g()
 DEFINE ls_tmp STRING
 DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
         chr         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
         m_no        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_cnt       LIKE type_file.num5,         #CHI-B80007 add
         l_fbf       RECORD
                     faj02     LIKE faj_file.faj02,
                     faj022    LIKE faj_file.faj022,
                     faj06     LIKE faj_file.faj06,
                     faj18     LIKE faj_file.faj18,
                     fbf08     LIKE fbf_file.fbf08,
                     fbf04     LIKE fbf_file.fbf04,
                     fbf10     LIKE fbf_file.fbf10,
                     fbf11     LIKE fbf_file.fbf11,        #No:A099
                     fbf12     LIKE fbf_file.fbf12,         #No:A099
                     fbf082     LIKE fbf_file.fbf082,      #FUN-B90096 add 
                     fbf112     LIKE fbf_file.fbf112,      #FUN-B90096 add
                     faj17     LIKE faj_file.faj17         #MOD-CB0108 add
                     END RECORD
 
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbe.fbeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_fbe.fbeconf='Y' THEN CALL cl_err(g_fbe.fbe01,'afa-107',0) RETURN END IF
    IF NOT cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-490235
      LET INT_FLAG = 0

      LET p_row = 8 LET p_col = 15
     #OPEN WINDOW t110_w2 AT p_row,p_col WITH FORM "afa/42f/afat1032"               #CHI-D10032 mark
      OPEN WINDOW t110_w2 AT p_row,p_col WITH FORM "afa/42f/afat1104"               #CHI-D10032增加幣別選項
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
     #CALL cl_ui_locale("afat1032")                 #CHI-D10032 mark
      CALL cl_ui_locale("afat1104")                 #CHI-D10032 add
 
                                ## per 與 afat1032 同
     #CONSTRUCT l_wc ON faj01,faj02,faj022,faj53,faj19,faj20,faj21,faj33            #No.FUN-B50118 mark
     #             FROM faj01,faj02,faj022,faj53,faj19,faj20,faj21,faj33            #No.FUN-B50118 mark
     #CONSTRUCT l_wc ON faj01,faj93,faj02,faj022,faj53,faj19,faj20,faj21,faj33      #No.FUN-B50118 add #CHI-D10032 mark
     #             FROM faj01,faj93,faj02,faj022,faj53,faj19,faj20,faj21,faj33      #No.FUN-B50118 add #CHI-D10032 mark
      CONSTRUCT l_wc ON faj01,faj93,faj02,faj022,faj15,                             #CHI-D10032 add
                        faj53,faj19,faj20,faj21,faj33                               #CHI-D10032 add
                   FROM faj01,faj93,faj02,faj022,faj15,                             #CHI-D10032 add
                        faj53,faj19,faj20,faj21,faj33                               #CHI-D10032 add
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            DISPLAY g_fbe.fbe05 TO faj15                                            #CHI-D10032 add

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
      IF l_wc = " 1=1" THEN
         CALL cl_err('','abm-997',1) 
         LET INT_FLAG = 1
      END IF
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t110_w2 RETURN END IF
      BEGIN WORK
      LET l_sql ="SELECT faj02,faj022,faj06,faj18,faj33+faj331,faj17-faj58,faj68,",   #MOD-970231
                 "       (faj101-faj102),(faj103-faj104), ",                          #No:A099 #MOD-D10260 add ,
                 "       faj332+faj3312,(faj1012-faj1022),faj17 ",                          #FUN-B90096 add	 #MOD-CB0108 add faj17
                 "  FROM faj_file ",
                 " WHERE faj43 NOT IN ('0','5','6','X') AND fajconf='Y' ",
                 "   AND faj100<'",g_fbe.fbe02,"'",
                 "   AND faj02 NOT IN (SELECT fca03 FROM fca_file",
                 "       WHERE fca03=faj02 AND fca031=faj022 AND fca15='N')",
                 "   AND faj02 NOT IN (SELECT fbf03 FROM fbf_file",
                 "       WHERE fbf03=faj02 AND fbf031=faj022",                       #No.TQC-9B0211
                 "         AND fbf01='",g_fbe.fbe01,"') ",
                #"   AND faj15 = '",g_fbe.fbe05,"' ",                                    #MOD-C70059 add #CHI-D10032 mark
                 "   AND ",l_wc CLIPPED,
                 "   ORDER BY 1"
     PREPARE t110_pre1 FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('pre1:',SQLCA.sqlcode,0)
        ROLLBACK WORK
        CLOSE WINDOW t110_w2   #MOD-9B0156 add
        RETURN
     END IF
     DECLARE t110_cur1 CURSOR FOR t110_pre1
 
     SELECT MAX(fbf02)+1 INTO m_no FROM fbf_file WHERE fbf01=g_fbe.fbe01
     IF m_no IS NULL THEN LET m_no=1 END IF
     LET g_success = 'Y'      #No.FUN-8A0086
     CALL s_showmsg_init()    #No.FUN-710028
     FOREACH t110_cur1 INTO l_fbf.*
        IF g_success='N' THEN                                                                                                         
           LET g_totsuccess='N'                                                                                                       
           LET g_success="Y"                                                                                                          
        END IF                                                                                                                        
 
        IF SQLCA.sqlcode != 0 THEN
           CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
           EXIT FOREACH
        END IF
        #no:4532檢查資產盤點期間應不可做異動
        SELECT COUNT(*) INTO g_cnt FROM fca_file
         WHERE fca03  = l_fbf.faj02
           AND fca031 = l_fbf.faj022
           AND fca15  = 'N'
            IF g_cnt > 0 THEN
               CONTINUE FOREACH
            END IF
        IF g_faa.faa23 = 'N' THEN
           SELECT COUNT(*) INTO g_cnt FROM fan_file
            WHERE fan01 = l_fbf.faj02
              AND fan02 = l_fbf.faj022
              AND ((fan03 = YEAR(g_fbe.fbe02) AND fan04 >= MONTH(g_fbe.fbe02))
               OR fan03 > YEAR(g_fbe.fbe02))
              AND fan041 = '1'   #MOD-BC0025 add
           IF g_cnt > 0 THEN
              CALL cl_err(l_fbf.faj02,'afa-092',0)
              CONTINUE FOREACH
           END IF
        END IF
       #-----No:FUN-B60140-----
        IF g_faa.faa31 = "Y" THEN
           IF g_faa.faa232 = 'N' THEN
              SELECT COUNT(*) INTO g_cnt FROM fbn_file
               WHERE fbn01 = l_fbf.faj02
                 AND fbn02 = l_fbf.faj022
                 AND ((fbn03 = YEAR(g_fbe.fbe02) AND fbn04 >= MONTH(g_fbe.fbe02))
                 #OR fan03 > YEAR(g_fbe.fbe02))   #MOD-BC0025 mark
                  OR fbn03 > YEAR(g_fbe.fbe02))   #MOD-BC0025
                 AND fbn041 = '1'                 #MOD-BC0025 add
              IF g_cnt > 0 THEN
                 CALL cl_err(l_fbf.faj02,'afa-092',0)
                 CONTINUE FOREACH
              END IF
           END IF
        END IF
        #-----No:FUN-B60140 END----- 
        #CHI-B80007 -- begin --
        SELECT count(*) INTO l_cnt FROM fbf_file,fbe_file
          WHERE fbf01 = fbe01
           AND fbf03  = l_fbf.faj02
           AND fbf031 = l_fbf.faj022
           AND fbe02 <= g_fbe.fbe02
           AND fbepost = 'N'
           AND fbe01 != g_fbe.fbe01
           AND fbeconf <> 'X'
        IF l_cnt > 0 THEN
           CONTINUE FOREACH
        END IF
        #CHI-B80007 -- end --
       #--------------------MOD-CB0108--------------------(S)
        IF l_fbf.faj17 = 1 THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM fbg_file,fbh_file
            WHERE fbg01 = fbh01
              AND fbh03 = l_fbf.faj02 
              AND fbh031 = l_fbf.faj022 
              AND fbgconf <> 'X'
           IF l_cnt > 0 THEN
              CONTINUE FOREACH
           END IF
        END IF
       #--------------------MOD-CB0108--------------------(E)
        IF cl_null(l_fbf.faj022) THEN
           LET l_fbf.faj022 = ' '
        END IF
#No.TQC-C10107 --begin
       IF cl_null(l_fbf.fbf082) THEN LET l_fbf.fbf082 =0 END IF 
       IF cl_null(l_fbf.fbf112) THEN LET l_fbf.fbf112 =0 END IF 
#No.TQC-C10107 --end
      #CHI-C60010---str---
       CALL cl_digcut(l_fbf.fbf082,g_azi04_1) RETURNING l_fbf.fbf082
       CALL cl_digcut(l_fbf.fbf112,g_azi04_1) RETURNING l_fbf.fbf112
      #CHI-C60010---end---
        INSERT INTO fbf_file(fbf01,fbf02,fbf03,fbf031,fbf04,fbf05,fbf06,fbf07,
                             fbf08,fbf09,fbf10,fbf11,fbf12,fbflegal, #FUN-980003 add
         						fbf072,fbf082,fbf112,fbf092) #FUN-B90096 add
                      VALUES(g_fbe.fbe01,m_no,l_fbf.faj02,l_fbf.faj022,
                             l_fbf.fbf04,'',0,0,l_fbf.fbf08,0,l_fbf.fbf10,
                             l_fbf.fbf11,l_fbf.fbf12,g_legal, #FUN-980003 add
         						0,l_fbf.fbf082,l_fbf.fbf112,0)#FUN-B90096 add
        IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
           LET g_showmsg = g_fbe.fbe01,"/",m_no                        #No.FUN-710028
           CALL s_errmsg('fbf01,fbf02',g_showmsg,'ins fbf',STATUS,1)   #No.FUN-710028
           LET g_success = 'N' #No.FUN-710028
           CONTINUE FOREACH    #No.FUN-710028
        END IF
        LET m_no=m_no+1
     END FOREACH
     IF g_totsuccess="N" THEN                                                                                                        
        LET g_success="N"                                                                                                            
     END IF                                                                                                                          
     CALL s_showmsg()   #No.FUN-710028
     IF g_success = 'Y' THEN  #No.FUN-710028
        COMMIT WORK        
     ELSE                     #No.FUN-710028
        ROLLBACK WORK         #No.FUN-710028
     END IF                   #No.FUN-710028
     CLOSE WINDOW t110_w2
     CALL t110_b_fill(l_wc)
END FUNCTION
 
FUNCTION t110_m()
 DEFINE  l_sql       LIKE type_file.chr1000,   #No.FUN-680070 VARCHAR(400)
         l_fbf       RECORD LIKE fbf_file.*,   #No.FUN-680070 INT # saki 20070821 rowid chr18 -> num10 
         l_fbf03     LIKE fbf_file.fbf03,
         l_fbf031    LIKE fbf_file.fbf031,
         l_fbf04     LIKE fbf_file.fbf04,
         l_fbf07     LIKE fbf_file.fbf07,
         l_fbf08     LIKE fbf_file.fbf08,
         l_fbf09     LIKE fbf_file.fbf09,
         l_fbf11     LIKE fbf_file.fbf11,      #No:A099
         l_fbe10     LIKE fbe_file.fbe10,
         l_qty       LIKE fbf_file.fbf04,
         l_fan07     LIKE fan_file.fan07,
         l_yy,l_mm   LIKE type_file.num5,      #No.FUN-680070 SMALLINT
         l_last      LIKE type_file.num5,      #No.FUN-680070 SMALLINT
         l_rate      LIKE azx_file.azx04,      #No.FUN-680070 DEC(5,3)
         l_amt       LIKE type_file.num20_6,   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
         l_cost      LIKE fbf_file.fbf06, 
         l_curr      LIKE fbf_file.fbf06, 
         l_faj43     LIKE faj_file.faj43,      #MOD-990043 add
         l_fbf02     LIKE fbf_file.fbf02,      #MOD-9C0385 add
         l_tax       LIKE fbe_file.fbe09x,     #MOD-9C0385 add
         l_sumtax    LIKE fbe_file.fbe09x      #MOD-9C0385 add
 #-----NO:FUN-B90096 start--
 DEFINE  l_fbf072     LIKE fbf_file.fbf072,
         l_fbf082     LIKE fbf_file.fbf082,
         l_fbf092     LIKE fbf_file.fbf092,
         l_fbf112     LIKE fbf_file.fbf112,
         l_qty2       LIKE fbf_file.fbf04,
         l_curr2      LIKE fbf_file.fbf06         
 #-----NO:FUN-B90096 end----          
 
    IF cl_null(g_fbe.fbe01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_faa.faa23 !='Y' THEN CALL cl_err('','afa-344',0) RETURN END IF
    IF g_fbe.fbeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbe.fbeconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    LET g_fbe.fbe12='N'
    LET l_sql = "SELECT fbf01,fbf02,fbf03,fbf031,fbf04,fbf07,fbf11 ",
                "       fbf072,fbf082,fbf112,fbf092 ", ##NO:FUN-B90096 add
                "  FROM fbf_file",                      #end No:A099
                " WHERE fbf01 = '",g_fbe.fbe01,"'"
    PREPARE t110_prcm FROM l_sql
    DECLARE t110_cm CURSOR WITH HOLD FOR t110_prcm
 
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t110_cl USING g_fbe.fbe01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
    LET l_fbe10 = 0
    CALL s_showmsg_init()    #No.FUN-710028
    FOREACH t110_cm  INTO l_fbf.fbf01,l_fbf.fbf02,l_fbf03,l_fbf031,l_fbf04,l_fbf07,
                          l_fbf11 #No:A099
						  ,l_fbf072,l_fbf082,l_fbf112,l_fbf092 #NO:FUN-B90096 add
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
 
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('fbf01',g_fbe.fbe01,'foreach:',STATUS,1) EXIT FOREACH  #No.FUN-710028
       END IF
       message l_fbf03,' ',l_fbf031
       SELECT (faj17-faj58),(faj33+faj331),faj43 INTO l_qty,l_curr,l_faj43   #MOD-970231  #MOD-990043 add l_faj43
         FROM faj_file WHERE faj02=l_fbf03 AND faj022=l_fbf031
         IF SQLCA.sqlcode THEN
            LET g_showmsg = l_fbf03,"/",l_fbf031                             #No.FUN-710028 
            CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj_file:',STATUS,1) #No.FUN-710028
            LET g_success = 'N'
            CONTINUE FOREACH   #No.FUN-710028
         END IF
##No.2824 modify 1998/11/20 for泰國法律用當月處分其折舊*DAY(處分日期)/當月總天數
         IF g_faa.faa23 = 'Y' AND g_faa.faa15 = '4' THEN
            IF l_faj43 != '4' THEN   #資產狀態<>4.折畢   #MOD-990043 add
               SELECT fan07 INTO l_fan07 FROM fan_file
                WHERE fan01 = l_fbf03  AND fan02 = l_fbf031
                  AND fan03 = YEAR(g_fbe.fbe02)
                  AND fan04 = MONTH(g_fbe.fbe02)
                  AND fan041= '1'
               IF cl_null(l_fan07) THEN
                  LET g_showmsg = l_fbf03,"/",l_fbf031,"/",'1'   #No.FUN-710028
                  CALL s_errmsg('fan01,fan02,fan041',g_showmsg,'','afa-376',1) #No.FUN-710028
                  CONTINUE FOREACH   #No.FUN-710028
               END IF
            END IF   #MOD-990043 add
            LET l_yy = YEAR(g_fbe.fbe02) USING '&&&&'
            LET l_mm = MONTH(g_fbe.fbe02)
            IF l_mm = 12 THEN
               LET l_mm = 1 LET l_yy = l_yy + 1
            ELSE
               LET l_mm = l_mm + 1
            END IF
            LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
            LET l_rate = DAY(g_fbe.fbe02) / l_last
            LET l_amt = l_fan07 * l_rate
            LET l_curr = l_curr +l_fan07 - l_amt    #未折減額      #TQC-780089
            LET l_curr = cl_digcut(l_curr,g_azi04)   #TQC-780089
         END IF
         IF g_fbe.fbe073 = 'Y' THEN
            LET g_fbf07 = l_fbf07/(1+g_fbe.fbe071/100)
         ELSE
            LET g_fbf07 = l_fbf07
         END IF
         IF l_qty = 0 OR cl_null(l_qty)
         THEN LET l_fbf08=l_curr   #未折減額
              LET l_fbf09=g_fbf07 - l_fbf08        #處份損益 #No.8852   #MOD-760135
         ELSE LET l_fbf08=l_curr *(l_fbf04/l_qty)  #未折減額
              LET l_fbf08 = cl_digcut(l_fbf08,g_azi04)   #MOD-810219
              LET l_fbf09=g_fbf07 - l_fbf08        #處份損益   #MOD-760135
         END IF
         LET l_fbf09 = l_fbf09 + l_fbf11
         LET l_fbf09 = cl_digcut(l_fbf09,g_azi04)   #MOD-760135
         UPDATE fbf_file SET fbf08 = l_fbf08,     #未折減額
                             fbf09 = l_fbf09      #累積折舊
                         WHERE fbf01 = l_fbf.fbf01 AND fbf02 = l_fbf.fbf02
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('fbf01,fbf02',l_fbf.fbf01,'upd fbf_file:',STATUS,1)     #No.FUN-710028
            LET g_success = 'N'
            CONTINUE FOREACH  #No.FUN-710028
         END IF
         LET l_fbe10 = l_fbe10 + l_fbf09
    #-----NO:FUN-B90096 add start--
       IF g_faa.faa31 = 'Y' THEN
          SELECT (faj17-faj582),(faj332+faj3312) INTO l_qty2,l_curr2
            FROM faj_file WHERE faj02=l_fbf03 AND faj022=l_fbf031
          IF SQLCA.sqlcode THEN
             LET g_showmsg = l_fbf03,"/",l_fbf031
             CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj_file:',STATUS,1)
             LET g_success = 'N'
             CONTINUE FOREACH
          END IF
          IF g_fbe.fbe073 = 'Y' THEN
             LET g_fbf072 = l_fbf072/(1+g_fbe.fbe071/100)
          ELSE
             LET g_fbf072 = l_fbf072
          END IF
          IF l_qty2 = 0 OR cl_null(l_qty2) THEN 
             LET l_fbf082=l_curr2   #未折減額
             LET l_fbf092=g_fbf072 - l_fbf082        #處份損益
          ELSE 
             LET l_fbf082=l_curr2 *(l_fbf04/l_qty2)  #未折減額
             #LET l_fbf082 = cl_digcut(l_fbf082,g_azi04)  #CHI-C60010 mark
             LET l_fbf082=cl_digcut(l_fbf082,g_azi04_1)    #CHI-C60010
             LET l_fbf092=g_fbf072 - l_fbf082        #處份損益
          END IF
          LET l_fbf092 = l_fbf092 + l_fbf112
          #LET l_fbf092 = cl_digcut(l_fbf092,g_azi04)  #CHI-C60010 mark
          LET l_fbf092 = cl_digcut(l_fbf092,g_azi04_1)    #CHI-C60010
          LET l_fbf082=cl_digcut(l_fbf082,g_azi04_1)    #CHI-C60010
          UPDATE fbf_file SET fbf082 = l_fbf082,     #未折減額
                              fbf092 = l_fbf092      #累積折舊
                          WHERE fbf01 = l_fbf.fbf01 AND fbf02 = l_fbf.fbf02
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('fbf01,fbf02',l_fbf.fbf01,'upd fbf_file:',STATUS,1)
             LET g_success = 'N'
             CONTINUE FOREACH
          END IF          
       END IF     
    #-----NO:FUN-B90096 add end----
    END FOREACH
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
 
    LET g_fbe.fbe12='Y'
    UPDATE fbe_file SET fbe10 = l_fbe10 ,fbe12=g_fbe.fbe12
        WHERE fbe01 = g_fbe.fbe01
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('fbe01',g_fbe.fbe01,'upd fbe_file:',STATUS,1)    #No.FUN-710028
       LET g_success = 'N' 
    END IF
    LET g_fbe.fbe10 = l_fbe10
    CLOSE t110_cl
    CALL s_showmsg()   #No.FUN-710028

    LET l_tax = 0   LET l_sumtax = 0
    LET l_fbf02 = ''
    LET l_fbf07 = 0
    INITIALIZE l_fbf.* TO NULL

    #單身各筆各自算出稅額後再加總起來
    DECLARE fbf_curs_tm CURSOR FOR
       SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
    FOREACH fbf_curs_tm INTO l_fbf.*
       IF g_fbe.fbe073 = 'Y' THEN   #含稅否
          LET l_fbf07 = l_fbf.fbf07/(1+g_fbe.fbe071/100)
       ELSE
          LET l_fbf07 = l_fbf.fbf07
       END IF

       LET l_tax = l_fbf07*g_fbe.fbe071/100
      #CALL cl_digcut(l_tax,t_azi.azi04) RETURNING l_tax  #MOD-C60137 mark
       CALL cl_digcut(l_tax,g_azi04) RETURNING l_tax  #MOD-C60137 add
       LET l_sumtax = l_sumtax+l_tax
    END FOREACH

    #當整張單據的本幣出售稅額 不等於 單身各自計算稅額後加總
    #將差異調在單身金額最大那筆的處分損益上
    IF g_fbe.fbe09x-l_sumtax!=0 THEN
       #抓單身本幣出售金額最大那筆的項次
       DECLARE fbf_curs_t2 CURSOR FOR
          SELECT fbf02 FROM fbf_file
           WHERE fbf01=g_fbe.fbe01
           ORDER BY fbf07 DESC
       OPEN fbf_curs_t2
       FETCH fbf_curs_t2 INTO l_fbf02
       CLOSE fbf_curs_t2

       UPDATE fbf_file SET fbf09 = fbf09-(g_fbe.fbe09x-l_sumtax)
        WHERE fbf01=g_fbe.fbe01 AND fbf02=l_fbf02
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","fbf_file",g_fbe.fbe01,l_fbf02,SQLCA.sqlcode,"","upd fbf",1)
       ELSE
          CALL t110_upd('u')                 #update 單頭資料
       END IF
    END IF

    IF g_success = 'Y' THEN 
       COMMIT WORK 
    ELSE 
       ROLLBACK WORK 
    END IF
END FUNCTION
 
FUNCTION t110_s(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_fbf   RECORD LIKE fbf_file.*
   DEFINE l_faj   RECORD LIKE faj_file.*
   DEFINE sql     LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(400)
   DEFINE m_chr,l_flag   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE l_bdate,l_edate  LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_msg   LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(40)
   DEFINE l_yy,l_mm    LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE l_c          LIKE type_file.num20_6,  #No.FUN-4C0008       #No.FUN-680070 DECIMAL(20,6)
          l_fbf08      LIKE fbf_file.fbf08          #No.FUN-4C0008
   DEFINE l_qty        LIKE fap_file.fap20
   DEFINE m_fap56 LIKE fap_file.fap56,
          m_fap57 LIKE fap_file.fap57,
          l_chr   LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
   DEFINE m_fap562  LIKE fap_file.fap562     #NO:FUN-B90096 add
   DEFINE m_fap572  LIKE fap_file.fap572     #NO:FUN-B90096 add
   DEFINE m_fap45 LIKE fap_file.fap45     #No:A099
   DEFINE m_fap452   LIKE fap_file.fap45     #NO:FUN-B90096 add
   DEFINE l_cnt   LIKE type_file.num5  #No:FUN-B60140
   DEFINE m_chr2    LIKE type_file.chr1      #NO:FUN-B90096 add
   DEFINE l_c2      LIKE type_file.num20_6   #NO:FUN-B90096 add
   DEFINE l_qty2    LIKE fap_file.fap20      #NO:FUN-B90096 add
   DEFINE l_fbf082  LIKE fbf_file.fbf082     #NO:FUN-B90096 add
   DEFINE l_edate2  LIKE type_file.dat       #NO:FUN-B90096 add
   DEFINE l_last     LIKE type_file.num5     #MOD-C80118 add
   DEFINE l_rate     LIKE azx_file.azx04     #MOD-C80118 add
   DEFINE l_fan07    LIKE fan_file.fan07     #MOD-C80118 add
   DEFINE l_fbn07    LIKE fan_file.fan07     #MOD-C80118 add
   DEFINE l_diffamt  LIKE fan_file.fan07     #MOD-C80118 add
   DEFINE l_diffamt2 LIKE fan_file.fan07     #MOD-C80118 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
   IF g_fbe.fbeconf != 'Y' OR g_fbe.fbepost != 'N' THEN
      CALL cl_err(g_fbe.fbe01,'afa-100',0)   #FUN-580109
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbe.fbe02 < g_faa.faa09 THEN
      CALL cl_err(g_fbe.fbe01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
  #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_fbe.fbe02 < g_faa.faa092 THEN
         CALL cl_err(g_fbe.fbe01,'aap-176',1)
         RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END----- 
  LET g_t1 = s_get_doc_no(g_fbe.fbe01)     #No.FUN-680028
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1     #No.FUN-680028
  
      CALL s_get_bookno(g_faa.faa07)   
          RETURNING g_flag,g_bookno1,g_bookno2
      IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF #MOD-BC0114
      #FUN-AB0088---add---str---
      #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
      #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套       
      IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF        
      #FUN-AB0088---add---end---
      #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
      #CHI-A60036 add --start--
     #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
      #-----No:FUN-B60140 Mark-----
      #IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add 
      #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
      #ELSE
      #   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
      #END IF
      #-----No:FUN-B60140 Mark END-----
      #CHI-A60036 add --end--
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate     #FUN-B60140   Add
      IF g_fbe.fbe02 < l_bdate OR g_fbe.fbe02 > l_edate THEN
         CALL cl_err(g_fbe.fbe02,'afa-308',0)
         RETURN
      END IF
      #-----No:FUN-B60140-----
      IF g_faa.faa31 = "Y" THEN
         CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
         IF g_fbe.fbe02 < l_bdate OR g_fbe.fbe02 > l_edate THEN
            CALL cl_err(g_fbe.fbe02,'afa-308',0)
            RETURN
         END IF
      END IF
      #-----No:FUN-B60140 END-----
      IF NOT cl_sure(18,20) THEN RETURN END IF
   LET g_success = 'Y'
   BEGIN WORK
 
    OPEN t110_cl USING g_fbe.fbe01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
 
   #--------- 過帳(1)insert fap_file
    DECLARE t110_cur2 CURSOR FOR
     SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
    CALL s_showmsg_init()   #No.FUN-710028
    FOREACH t110_cur2 INTO l_fbf.*
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
 
       IF SQLCA.sqlcode != 0 THEN
          CALL s_errmsg('fbf01',g_fbe.fbe01,'foreach:',SQLCA.sqlcode,1)   #No.FUN-710028
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbf.fbf03
                                             AND faj022=l_fbf.fbf031
 
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,1)
          LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031               #No.FUN-710028
          CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1) #No.FUN-710028
          LET g_success = 'N'
          CONTINUE FOREACH    #No.FUN-710028
       END IF
       #-->免稅資料
       IF l_faj.faj40 = '3' AND p_cmd = 'S' THEN
          LET l_msg = l_faj.faj02,' ',l_faj.faj022 CLIPPED
          CALL s_errmsg('','',l_msg,'afa-305',1)  #No.FUN-710028
          LET g_success = 'N'
          CONTINUE FOREACH    #No.FUN-710028
       END IF
       #-->抵押資料No:7645
       IF l_faj.faj41 MATCHES '[234]' AND p_cmd = 'S' THEN
          LET l_msg = l_faj.faj02,' ',l_faj.faj022 CLIPPED
          CALL s_errmsg('','',l_msg,'afa-951',1)  #No.FUN-710028
          LET g_success = 'N'
          CONTINUE FOREACH    #No.FUN-710028
       END IF
       IF cl_null(l_faj.faj101) THEN LET l_faj.faj101 = 0 END IF
       IF cl_null(l_faj.faj102) THEN LET l_faj.faj102 = 0 END IF
       #-->投減三年內不可出售
       IF l_faj.faj42 = '3' AND p_cmd = 'S' THEN
          LET l_edate = l_faj.faj26 + (365 * 3)
          LET l_msg = l_faj.faj02,' ',l_faj.faj022 clipped
          IF g_fbe.fbe02 < l_edate THEN
             CALL s_errmsg('','',l_msg,'afa-306',1)  #No.FUN-710028
             LET g_success = 'N'
             CONTINUE FOREACH    #No.FUN-710028
          END IF
          #-----NO:FUN-B90096 start--
          IF g_faa.faa31 = 'Y' THEN
             LET l_edate2 = l_faj.faj262 + (365 * 3)
             LET l_msg = l_faj.faj02,' ',l_faj.faj022 CLIPPED
             IF g_fbe.fbe02 < l_edate2 THEN
                CALL s_errmsg('','',l_msg,'afa-306',1)
                LET g_success = 'N'
                CONTINUE FOREACH
             END IF
          END IF
          #-----NO:FUN-B90096 end----          
       END IF
      #-----------------------MOD-C80118---------------------(S)
       LET l_rate = 1
       LET l_diffamt = 0
       LET l_diffamt2 = 0
       LET l_fan07 = 0
       LET l_fbn07 = 0
       IF g_faa.faa15 = '4' THEN
          LET l_yy = YEAR(g_fbe.fbe02) USING '&&&&'
          LET l_mm = MONTH(g_fbe.fbe02)
          SELECT fan07 INTO l_fan07
            FROM fan_file
           WHERE fan01 = l_fbf.fbf03
             AND fan02 = l_fbf.fbf031
             AND fan03 = l_yy
             AND fan04 = l_mm
          IF cl_null(l_fan07) THEN LET l_fan07 = 0 END IF
          IF g_faa.faa31 = 'Y' THEN
             SELECT fbn07 INTO l_fbn07
               FROM fbn_file
              WHERE fbn01 = l_fbf.fbf03
                AND fbn02 = l_fbf.fbf031
                AND fbn03 = l_yy
                AND fbn04 = l_mm
             IF cl_null(l_fbn07) THEN LET l_fbn07 = 0 END IF
          END IF
          IF l_mm = 12 THEN
             LET l_mm = 1 LET l_yy = l_yy + 1
          ELSE
             LET l_mm = l_mm + 1
          END IF
          LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
          LET l_rate = DAY(g_fbe.fbe02) / l_last
          LET l_diffamt = l_fan07 * l_rate
          LET l_diffamt2 = l_fbn07 * l_rate
          CALL cl_digcut(l_diffamt,g_azi04) RETURNING l_diffamt
          CALL cl_digcut(l_diffamt2,g_azi04_1) RETURNING l_diffamt2
          LET l_diffamt = l_fan07 - l_diffamt
          LET l_diffamt2 = l_fbn07 - l_diffamt2
       END IF
      #-----------------------MOD-C80118---------------------(E)
       #-------- fap56、fap57、fap73 給值
       IF l_faj.faj17 = 0 THEN
          LET m_fap56=l_faj.faj14 + l_faj.faj141 - l_faj.faj59
          LET m_fap57=l_faj.faj32 - l_faj.faj60
          LET m_fap45=l_faj.faj101 - l_faj.faj102  #No:A099
       ELSE
          #-->異動值銷帳成本
          #    (本幣成本 + 調整成本 -銷帳成本)
          #    /(數量-銷帳數量) * 單據出售量
          LET m_fap56=(l_faj.faj14+l_faj.faj141-l_faj.faj59)/
                      (l_faj.faj17-l_faj.faj58) * l_fbf.fbf04
          #-->異動值銷帳累折
          #   (累折 - 銷帳累折) / (數量-銷帳數量) * 單據出售量
          LET m_fap57=(l_faj.faj32-l_faj.faj60)/
                      (l_faj.faj17-l_faj.faj58) * l_fbf.fbf04
          #-->異動值銷帳減值準備
          #   (已提列減值準備 - 銷帳減值準備) / (數量-銷帳數量) * 單據出售量
          LET m_fap45=(l_faj.faj101-l_faj.faj102)/
                      (l_faj.faj17-l_faj.faj58) * l_fbf.fbf04
       END IF
       LET l_faj.faj141 = l_faj.faj203                           #MOD-C80118
       LET m_fap57 = m_fap57 - l_diffamt                         #MOD-C80118
      #-----NO:FUN-B90096 start--
      IF g_faa.faa31 = 'Y' THEN
         IF l_faj.faj17 = 0 THEN
            LET m_fap562=l_faj.faj142 + l_faj.faj1412 - l_faj.faj592
            LET m_fap572=l_faj.faj322 - l_faj.faj602
            LET m_fap452=l_faj.faj1012 - l_faj.faj1022
         ELSE
            #-->異動值銷帳成本
            #    (本幣成本 + 調整成本 -銷帳成本)
            #    /(數量-銷帳數量) * 單據出售量
            LET m_fap562=(l_faj.faj142+l_faj.faj1412-l_faj.faj592)/
                        (l_faj.faj17-l_faj.faj582) * l_fbf.fbf04
            #-->異動值銷帳累折
            #   (累折 - 銷帳累折) / (數量-銷帳數量) * 單據出售量
            LET m_fap572=(l_faj.faj322-l_faj.faj602)/
                        (l_faj.faj17-l_faj.faj582) * l_fbf.fbf04
            #-->異動值銷帳減值準備
            #   (已提列減值準備 - 銷帳減值準備) / (數量-銷帳數量) * 單據出售量
            LET m_fap452=(l_faj.faj1012-l_faj.faj1022)/
                        (l_faj.faj17-l_faj.faj582) * l_fbf.fbf04
         END IF
         LET l_faj.faj1412 = l_faj.faj2032          #MOD-C80118
         LET m_fap572 = m_fap572 - l_diffamt2       #MOD-C80118
      END IF 
      #-----NO:FUN-B90096 end----       
       #--------- 過帳(2)update faj_file
       IF l_fbf.fbf04=l_faj.faj17-l_faj.faj58
       THEN LET m_chr='5'     ## 出售
       ELSE
            LET m_chr=l_faj.faj43
       END IF

      #-----NO:FUN-B90096 start--
      IF g_faa.faa31 = 'Y' THEN
         IF l_fbf.fbf04=l_faj.faj17-l_faj.faj582 THEN
            LET m_chr2='5'     ## 出售
         ELSE
            LET m_chr2=l_faj.faj432
         END IF
      ELSE
         LET m_chr2 = m_chr
      END IF
      #-----NO:FUN-B90096 end----
      
       #--->本期銷帳折舊=(本期累折-本期銷帳折舊)/(數量-銷帳數量)*處份量
       LET l_qty = l_faj.faj17 - l_faj.faj58
       IF l_qty > 0 THEN
          LET l_c = (l_faj.faj203 - l_faj.faj204) / l_qty * l_fbf.fbf04
          LET l_c = l_c - l_diffamt                                          #MOD-C80118 add
       ELSE  LET l_c = 0
       END IF
       IF l_c IS NULL THEN LET l_c=0 END IF #No.8851
       #-----NO:FUN-B90096 start--
      IF g_faa.faa31 = 'Y' THEN
         LET l_qty2 = l_faj.faj17 - l_faj.faj582
         IF l_qty2 > 0 THEN
            LET l_c2 = (l_faj.faj2032 - l_faj.faj2042) / l_qty2 * l_fbf.fbf04
            LET l_c2 = l_c2 - l_diffamt2                      #MOD-C80118 add
         ELSE
            LET l_c2 = 0
         END IF
        #IF l_c2 IS NULL THEN LET l_c2 = 0 END IF   #MOD-C80118 mark
      END IF 
      IF l_c2 IS NULL THEN LET l_c2 = 0 END IF      #MOD-C80118 add
      #-----NO:FUN-B90096 end----
       IF cl_null(l_fbf.fbf031) THEN
          LET l_fbf.fbf031 = ' '
       END IF
       
       #--FUN-AB0088---add---start---                                                                                                        
       IF cl_null(l_faj.faj432) THEN LET l_faj.faj432 = ' ' END IF                                                                  
       IF cl_null(l_faj.faj282) THEN LET l_faj.faj282 = ' ' END IF                                                                  
       IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF                                                                    
       IF cl_null(l_faj.faj142) THEN LET l_faj.faj142 = 0 END IF                                                                    
       IF cl_null(l_faj.faj1412) THEN LET l_faj.faj1412 = 0 END IF                                                                  
       IF cl_null(l_faj.faj332) THEN LET l_faj.faj332 = 0 END IF                                                                    
       IF cl_null(l_faj.faj3312) THEN LET l_faj.faj3312 = 0 END IF                                                                  
       IF cl_null(l_faj.faj322) THEN LET l_faj.faj322 = 0 END IF                                                                    
       IF cl_null(l_faj.faj232) THEN LET l_faj.faj232 = ' ' END IF                                                                  
       IF cl_null(l_faj.faj592) THEN LET l_faj.faj592 = 0 END IF                                                                    
       IF cl_null(l_faj.faj602) THEN LET l_faj.faj602 = 0 END IF                                                                    
       IF cl_null(l_faj.faj342) THEN LET l_faj.faj342 =' ' END IF                                                                   
       IF cl_null(l_faj.faj352) THEN LET l_faj.faj352 = 0 END IF                                                                    
       IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF                                                                    
       #---FUN-AB0088---add---end---
       IF cl_null(m_fap562) THEN LET m_fap562 = 0 END IF #No:FUN-BA0112 add
       IF cl_null(m_fap572) THEN LET m_fap572 = 0 END IF #No:FUN-BA0112 add
       IF cl_null(m_fap452) THEN LET m_fap452 = 0 END IF #No:FUN-BA0112 add
     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(m_fap562,g_azi04_1) RETURNING m_fap562
      CALL cl_digcut(m_fap572,g_azi04_1) RETURNING m_fap572
      CALL cl_digcut(m_fap452,g_azi04_1) RETURNING m_fap452
     #CHI-C60010---end---      
       #-----No:FUN-B60140-----
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM fap_file
        WHERE fap50 = l_fbf.fbf01
          AND fap501= l_fbf.fbf02
          AND fap03 = '4'
       IF l_cnt = 0 THEN   #無fap_file資料

       INSERT INTO fap_file (fap01,fap02,fap021,fap03,
                             fap04,fap05,fap06,fap07,
                             fap08,fap09,fap10,fap101,
                             fap11,fap12,fap13,fap14,
                             fap15,fap16,fap17,fap18,
                             fap19,fap20,fap201,fap21,
                             fap22,fap23,fap24,fap25,
                             fap26,fap30,fap31,fap32,
                             fap33,fap34,fap341,fap35,
                             fap36,fap37,fap38,fap39,
                             fap40,fap41,fap42,fap55,              #增fap42稅簽的資產狀態no:5366 #MOD-C80118 add fap55
                             fap50,fap501,fap54,fap56,fap57,
                             fap67,fap73,fap74,fap77,fap45,    #No:A099
                             fap121,fap131,fap141,
                            #FUN-AB0088---add---str---
                             fap052,fap062,fap072,fap082,
                             fap092,fap103,fap1012,fap112,
                             fap152,fap162,fap212,fap222,
                             fap232,fap242,fap252,fap262,fap772,
                            #FUN-AB0088---add---end--- 
                             faplegal,                                   #No.FUN-680028 #FUN-980003 add
                             fap562,fap572,fap542,fap552)                #NO:FUN-B90096 add fap562,fap572 #MOD-C80118 add fap542,fap552
       VALUES (l_faj.faj01,l_fbf.fbf03,l_fbf.fbf031,'4',
               g_fbe.fbe02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
               l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,  #MOD-970231
               l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
               l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
               l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
               l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
               l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
               l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
               l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
               l_faj.faj73,l_faj.faj100,l_faj.faj201,l_faj.faj32-l_diffamt,    #MOD-C80118 add for fap55
               l_fbf.fbf01,l_fbf.fbf02,l_c,m_fap56,m_fap57,
               l_fbf.fbf04,0,0,m_chr,m_fap45,      #No:A099
               l_faj.faj531,l_faj.faj541,l_faj.faj551,
               #---FUN-AB0088---str--
               l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
               l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
               l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
               l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
              #m_chr, #NO:FUN-B90096 mark
               m_chr2, #NO:FUN-B90096 add
              #---FUN-AB0088---end---- 
               g_legal,     #No.FUN-680028 #FUN-980003 add
               m_fap562,m_fap572,l_c2,l_faj.faj322-l_diffamt2)            #NO:FUN-B90096 add m_fap562,m_fap572 #MOD-C80118 add for fap542/fap552
       ELSE
          UPDATE fap_file SET fap05 = l_faj.faj43,
                              fap06 = l_faj.faj28,
                              fap07 = l_faj.faj30,
                              fap08 = l_faj.faj31,
                              fap09 = l_faj.faj14,
                              fap10 = l_faj.faj141,
                              fap101= l_faj.faj33+l_faj.faj331,
                              fap11 = l_faj.faj32,
                              fap15 = l_faj.faj23,
                              fap16 = l_faj.faj24,
                              fap21 = l_faj.faj58,
                              fap22 = l_faj.faj59,
                              fap23 = l_faj.faj60,
                              fap24 = l_faj.faj34,
                              fap25 = l_faj.faj35,
                              fap26 = l_faj.faj36,
                              fap54 = l_c,                       #MOD-C80118 add
                              fap55 = l_faj.faj32 - l_diffamt,   #MOD-C80118 add
                              fap57 = m_fap57,                   #MOD-C80118 add
                              fap77 = m_chr,
                              fap052 = l_faj.faj432,
                              fap062 = l_faj.faj282,
                              fap072 = l_faj.faj302,
                              fap082 = l_faj.faj312,
                              fap092 = l_faj.faj142,
                              fap103 = l_faj.faj1412,
                              fap1012= l_faj.faj332+l_faj.faj3312,
                              fap112 = l_faj.faj322,
                              fap152 = l_faj.faj232,
                              fap162 = l_faj.faj242,
                              fap212 = l_faj.faj582,
                              fap222 = l_faj.faj592,
                              fap232 = l_faj.faj602,
                              fap242 = l_faj.faj342,
                              fap252 = l_faj.faj352,
                              fap262 = l_faj.faj362,
                              fap542 = l_c2,                         #MOD-C80118 add
                              fap552 = l_faj.faj322 - l_diffamt2,    #MOD-C80118 add
                              fap572 = m_fap572,                     #MOD-C80118 add
                             #fap772 = m_chr #NO:FUN-B90096 mark
                              fap772 = m_chr2 #NO:FUN-B90096 add
           WHERE fap50 = l_fbf.fbf01
             AND fap501= l_fbf.fbf02
             AND fap03 = '4'
       END IF
       #-----No:FUN-B60140 END-----

       IF SQLCA.sqlcode THEN
          LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031,"/",'4',"/",g_fbe.fbe02   #No.FUN-710028           
          CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1) #No.FUN-710028
          LET g_success = 'N'
          CONTINUE FOREACH  #No.FUN-710028
       END IF
       LET l_fbf08 = l_fbf.fbf08
       LET l_fbf082 = l_fbf.fbf082 #NO:FUN-B90096 add
      #------------------------MOD-C80118-------------------(S)
      #當月處置應提列折舊且提列方式為4:本月(入帳日至月底比率)
       IF g_faa.faa15 = '4' THEN
          LET l_yy = YEAR(g_fbe.fbe02) USING '&&&&'
          LET l_mm = MONTH(g_fbe.fbe02)
          UPDATE faj_file SET faj32 = faj32 - l_diffamt,
                              faj203 = faj203 - l_diffamt
           WHERE faj02 = l_fbf.fbf03
             AND faj022 = l_fbf.fbf031
          UPDATE fan_file SET fan07 = fan07 - l_diffamt,
                              fan08 = fan08 - l_diffamt,
                              fan15 = fan15 - l_diffamt
           WHERE fan01 = l_fbf.fbf03
             AND fan02 = l_fbf.fbf031
             AND fan03 = l_yy
             AND fan04 = l_mm
          IF g_faa.faa31 = 'Y' THEN
             UPDATE fbn_file SET fbn07 = fbn07 - l_diffamt2,
                                 fbn08 = fbn08 - l_diffamt2,
                                 fbn15 = fbn15 - l_diffamt2
              WHERE fbn01 = l_fbf.fbf03
                AND fbn02 = l_fbf.fbf031
                AND fbn03 = l_yy
                AND fbn04 = l_mm
          END IF
       END IF
       LET l_fbf08  = l_faj.faj33 + l_faj.faj331 - l_fbf08 + l_diffamt
       LET l_fbf082 = l_faj.faj332 + l_faj.faj3312 - l_fbf082 + l_diffamt
      #------------------------MOD-C80118-------------------(E)
       #CHI-A70032 add --start--
       IF l_faj.faj43 ='6' THEN
          UPDATE faj_file SET faj43=m_chr,                    #狀態
                              faj58 =faj58+l_fbf.fbf04,        #銷帳數量
                              faj59 =faj59+m_fap56,            #銷帳成本
                              faj60 =faj60+m_fap57,            #銷帳累折
                              faj102 =faj102+m_fap45,          #銷帳減值準備  #No:A099
                              faj204 =faj204+l_c,              #本期銷帳累折
                             #faj33 = faj33 - l_fbf08,            #未折減額 #MOD-C80118 mark
                              faj33 = l_fbf08,                    #未折減額 #MOD-C80118 add
                              faj100 =g_fbe.fbe02              #異動日期
            WHERE faj02=l_fbf.fbf03 AND faj022=l_fbf.fbf031
       ELSE
       #CHI-A70032 add --end--
          UPDATE faj_file SET faj43=m_chr,              #狀態
                              faj58=faj58+l_fbf.fbf04,  #銷帳數量
                              faj59=faj59+m_fap56,      #銷帳成本
                              faj60=faj60+m_fap57,      #銷帳累折
                              faj102=faj102+m_fap45,    #銷帳減值準備  #No:A099
                              faj204=faj204+l_c,        #本期銷帳累折
                             #faj33 = faj33 - l_fbf08,            #未折減額 #MOD-C80118 mark
                              faj33 = l_fbf08,                    #未折減額 #MOD-C80118 add
                              faj100=g_fbe.fbe02,       #異動日期
                              faj31=(faj31/(faj17-faj58)) *   #預留殘值
                                    (faj17-(faj58+l_fbf.fbf04))
            WHERE faj02=l_fbf.fbf03 AND faj022=l_fbf.fbf031
       END IF #CHI-A70032 add
       IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
          LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031                 #No.FUN-710028
          CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
          LET g_success = 'N'
          CONTINUE FOREACH     #No.FUN-710028
       END IF
	 #-----NO:FUN-B90096 start--
     IF g_faa.faa31 = 'Y' THEN
        UPDATE faj_file SET
               faj432 =m_chr2,                            #狀態
               faj582 =faj582+l_fbf.fbf04,                #銷帳數量
               faj592 =faj592+m_fap562,                   #銷帳成本
               faj602 =faj602+m_fap572,                   #銷帳累折
               faj1022=faj1022+m_fap452,                  #銷帳減值準備
              #faj2042= faj2042 + l_c,                          #本期銷帳累折 #MOD-C80118 mark
               faj2042= faj2042 + l_c2,                         #本期銷帳累折 #MOD-C80118 add
               faj322 = faj322 - l_diffamt2,                    #MOD-C80118 add
               faj2032 = faj2032 - l_diffamt2,                  #MOD-C80118 add
              #faj332 =faj332-l_fbf082,                         #未折減額   #MOD-C80118 mark
               faj332 = l_fbf082,                               #未折減額   #MOD-C80118 add
               faj312 =(faj312/(faj17-faj582)) *   #預留殘值
                       (faj17-(faj582+l_fbf.fbf04))
        WHERE faj02=l_fbf.fbf03 AND faj022=l_fbf.fbf031
        IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
           LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
        END IF
     END IF     
	 #-----NO:FUN-B90096 end----  
   #-------------------------MOD-CA0101------------------mark
   # IF cl_null(l_fbf.fbf031) THEN      #MOD-9B0039 add
   #    UPDATE faj_file SET faj43=m_chr              #狀態
   #     WHERE faj02=l_fbf.fbf03 AND faj022<>l_fbf.fbf031
   #    IF SQLCA.sqlcode THEN
   #       LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031  #No.FUN-710028
   #       CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj:',SQLCA.sqlcode,1) #No.FUN-710028
   #    END IF
   # END IF   #MOD-9B0039 add
   ##-----NO:FUN-B90096 start--
   # IF g_faa.faa31 = 'Y' THEN
   #    IF cl_null(l_fbf.fbf031) THEN
   #       UPDATE faj_file SET faj432=m_chr2       #狀態
   #        WHERE faj02=l_fbf.fbf03 AND faj022<>l_fbf.fbf031
   #       IF SQLCA.sqlcode THEN
   #          LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031
   #          CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj:',SQLCA.sqlcode,1)
   #       END IF
   #    END IF
   # END IF 
   ##-----NO:FUN-B90096 end----
   #-------------------------MOD-CA0101------------------mark
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   CLOSE t110_cl
   IF g_success = 'Y' THEN
      #--------- 過帳(5)update fbepost
      UPDATE fbe_file SET fbepost = 'Y' WHERE fbe01 = g_fbe.fbe01
          IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
             CALL s_errmsg('fbe01',g_fbe.fbe01,'upd fbepost',STATUS,1)   #No.FUN-710028
             LET g_success = 'N'
             ROLLBACK WORK
          ELSE
             LET g_fbe.fbepost='Y'
             DISPLAY BY NAME g_fbe.fbepost,g_fbe.fbepost2 #
             COMMIT WORK
             CALL cl_flow_notify(g_fbe.fbe01,'S')
          END IF
   ELSE ROLLBACK WORK
   END IF
   CALL s_showmsg()   #No.FUN-710028
   IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
     LET g_wc_gl = 'npp01 = "',g_fbe.fbe01,'" AND npp011 = 1'
     LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fbe.fbeuser,"' '",g_fbe.fbeuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fbe.fbe02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284#FUN-860040
     CALL cl_cmdrun_wait(g_str)
     #-----No:FUN-B60140-----
     IF g_faa.faa31 = "Y" THEN
        LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fbe.fbeuser,"' '",g_fbe.fbeuser,"' '",g_faa.faa02p,"' 
                  '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fbe.fbe02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
        CALL cl_cmdrun_wait(g_str)
     END IF
     #-----No:FUN-B60140 END-----
     SELECT fbe14,fbe15,fbe142,fbe152  #No:FUN-B60140 
       INTO g_fbe.fbe14,g_fbe.fbe15,g_fbe.fbe142,g_fbe.fbe152  #No:FUN-B60140 
       FROM fbe_file
      WHERE fbe01 = g_fbe.fbe01
     DISPLAY BY NAME g_fbe.fbe14
     DISPLAY BY NAME g_fbe.fbe15
     DISPLAY BY NAME g_fbe.fbe142  #No:FUN-B60140
     DISPLAY BY NAME g_fbe.fbe152  #No:FUN-B60140
   END IF
   IF g_fbe.fbe18 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbe.fbeconf,g_chr2,g_fbe.fbepost,"",g_chr,"")
END FUNCTION
 
#-----------------稅簽過帳------------------------------
FUNCTION t110_6()
   DEFINE l_fbf   RECORD LIKE fbf_file.*,
          l_faj   RECORD LIKE faj_file.*,
          m_fap73 LIKE fap_file.fap73,
          m_fap74 LIKE fap_file.fap74,
          m_fap79 LIKE fap_file.fap79,     #No:A099
#         m_fap56 LIKE fap_file.fap56,     #FUN-B60140   Add #No:FUN-BA0112 mark
#         m_fap57 LIKE fap_file.fap57,     #FUN-B60140   Add #No:FUN-BA0112 mark
#         m_fap45 LIKE fap_file.fap45,     #FUN-B60140   Add #No:FUN-BA0112 mark
#         m_chr   LIKE fap_file.fap73,     #FUN-B60140   Add #No:FUN-BA0112 mark
          l_qty   LIKE fap_file.fap20,
          l_fap20 LIKE fap_file.fap20,
          l_fap21 LIKE fap_file.fap21,
          l_fbf10 LIKE fbf_file.fbf10,           #No.FUN-4C0008
          l_msg             LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_c               LIKE type_file.num20_6,  #No.FUN-4C0008       #No.FUN-680070 DECIMAL(20,6)
          l_bdate,l_edate   LIKE type_file.dat,          #No.FUN-680070 DATE
          l_flag            LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_yy,l_mm         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_mm1             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_chr             LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
     DEFINE l_cnt   LIKE type_file.num5  #No:FUN-B60140   
   DEFINE l_last            LIKE type_file.num5          #MOD-C80118 add
   DEFINE l_rate            LIKE azx_file.azx04          #MOD-C80118 add
   DEFINE l_fao07           LIKE fao_file.fao07          #MOD-C80118 add
   DEFINE l_diffamt         LIKE fao_file.fao07          #MOD-C80118 add
   DEFINE l_faj66           LIKE faj_file.faj66          #MOD-D10011 add

   IF s_shut(0) THEN RETURN END IF
   IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
 #  IF g_fbe.fbeconf != 'Y' OR g_fbe.fbepost != 'Y'
    IF g_fbe.fbeconf != 'Y'   #No:FUN-B60140
    THEN CALL cl_err(g_fbe.fbe01,'afa-320',0)
        RETURN
   END IF
   IF g_fbe.fbepost2 != 'N' THEN
      CALL cl_err(g_fbe.fbe01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbe.fbe02 < g_faa.faa13 THEN
      CALL cl_err(g_fbe.fbe01,'afa-308',0) 
      RETURN
   END IF
  #-MOD-A80137-end-

     #CALL s_get_bookno(g_faa.faa07)                                #MOD-D20017 mark
      CALL s_get_bookno(g_faa.faa11)                                #MOD-D20017 add   
          RETURNING g_flag,g_bookno1,g_bookno2
      IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF #MOD-BC0114
      #FUN-AB0088---add---str---
      #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
      #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套       
      IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF        
      #FUN-AB0088---add---end---
      #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
      #CHI-A60036 add --start--
     #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
     #-----No:FUN-B60140 Mark----- 
     #IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add 
     #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
     #ELSE
     #   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
     #END IF
     ##-----No:FUN-B60140 Mark END-----
      #CHI-A60036 add --end--
  #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate     #FUN-B60140 Add #MOD-D20017 mark
   CALL s_azm(g_faa.faa11,g_faa.faa12) RETURNING l_flag,l_bdate,l_edate     #MOD-D20017 add
   IF g_fbe.fbe02 < l_bdate OR g_fbe.fbe02 > l_edate THEN
      LET l_chr = YEAR(g_faa.faa13) using '####','-',
                  MONTH(g_faa.faa13) using '##'
      CALL cl_err(l_chr,'afa-308',0)
      RETURN
   END IF
   #-----No:FUN-B60140-----
   IF g_faa.faa31= "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
      IF g_fbe.fbe02 < l_bdate OR g_fbe.fbe02 > l_edate THEN
         LET l_chr = YEAR(g_faa.faa13) using '####','-',
                     MONTH(g_faa.faa13) using '##'
         CALL cl_err(l_chr,'afa-308',0)
         RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----
   IF NOT cl_sure(18,20) THEN RETURN END IF
   LET g_success = 'Y'
   BEGIN WORK
 
    OPEN t110_cl USING g_fbe.fbe01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
 
      DECLARE t110_cur21 CURSOR WITH HOLD FOR
         SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
      CALL s_showmsg_init()    #No.FUN-710028
      FOREACH t110_cur21 INTO l_fbf.*
         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        
 
         IF SQLCA.sqlcode != 0 THEN
            CALL s_errmsg('fbf01',g_fbe.fbe01,'foreach:',SQLCA.sqlcode,1)  #No.FUN-710028
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbf.fbf03
                                             AND faj022=l_fbf.fbf031
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,1)
            LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031                 #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
            LET g_success = 'N'
            CONTINUE FOREACH   #No.FUN-710028
         END IF
         IF cl_null(l_faj.faj103) THEN LET l_faj.faj103 = 0 END IF
         IF cl_null(l_faj.faj104) THEN LET l_faj.faj104 = 0 END IF
        #-----------------------MOD-C80118---------------------(S)
         LET l_rate = 1
         LET l_diffamt = 0
         IF g_faa.faa15 = '4' THEN
            LET l_yy = YEAR(g_fbe.fbe02) USING '&&&&'
            LET l_mm = MONTH(g_fbe.fbe02)
            LET l_fao07 = 0
            SELECT fao07 INTO l_fao07
              FROM fao_file
             WHERE fao01 = l_fbf.fbf03
               AND fao02 = l_fbf.fbf031
               AND fao03 = l_yy
               AND fao04 = l_mm
            IF cl_null(l_fao07) THEN LET l_fao07 = 0 END IF
            IF l_mm = 12 THEN
               LET l_mm = 1 LET l_yy = l_yy + 1
            ELSE
               LET l_mm = l_mm + 1
            END IF
            LET l_last = DAY(MDY(l_mm,1,l_yy)-1)
            LET l_rate = DAY(g_fbe.fbe02) / l_last
            LET l_diffamt = l_fao07 * l_rate
            CALL cl_digcut(l_diffamt,g_azi04) RETURNING l_diffamt
            LET l_diffamt = l_fao07 - l_diffamt
         END IF
        #-----------------------MOD-C80118---------------------(E)
 
         #--->稅簽銷帳成本
         #   (本幣成本 + 調整成本 -銷帳成本)
         #　　/(數量-銷帳數量) * 單據出售量
         LET m_fap73=(l_faj.faj62+l_faj.faj63-l_faj.faj69)/
                     (l_faj.faj17-l_faj.faj58+l_fbf.fbf04)*l_fbf.fbf04
 
         #--->稅簽銷帳累折
         LET m_fap74=(l_faj.faj67-l_faj.faj70)/
                     (l_faj.faj17-l_faj.faj58+l_fbf.fbf04) * l_fbf.fbf04
 
         #-->稅簽帳減值準備
         #   (已提列減值準備 - 銷帳減值準備) / (數量-銷帳數量) * 單據出售量
         LET m_fap79=(l_faj.faj103-l_faj.faj104)/
                     (l_faj.faj17-l_faj.faj58+l_fbf.fbf04) * l_fbf.fbf04
         LET l_faj.faj63 = l_faj.faj205          #MOD-C80118
         LET m_fap74 = m_fap74 - l_diffamt       #MOD-C80118
##-----No:FUN-BA0112 Mark----- 
#FUN-B60140   ---start   Add
#       #-------- fap56、fap57、fap73 給值
#       IF l_faj.faj17 = 0 THEN
#          LET m_fap56=l_faj.faj14 + l_faj.faj141 - l_faj.faj59
#          LET m_fap57=l_faj.faj32 - l_faj.faj60
#          LET m_fap45=l_faj.faj101 - l_faj.faj102  #No:A099
#       ELSE
#          #-->異動值銷帳成本
#          #    (本幣成本 + 調整成本 -銷帳成本)
#          #    /(數量-銷帳數量) * 單據出售量
#          LET m_fap56=(l_faj.faj14+l_faj.faj141-l_faj.faj59)/
#                      (l_faj.faj17-l_faj.faj58) * l_fbf.fbf04
#          #-->異動值銷帳累折
#          #   (累折 - 銷帳累折) / (數量-銷帳數量) * 單據出售量
#          LET m_fap57=(l_faj.faj32-l_faj.faj60)/
#                      (l_faj.faj17-l_faj.faj58) * l_fbf.fbf04
#          #-->異動值銷帳減值準備
#          #   (已提列減值準備 - 銷帳減值準備) / (數量-銷帳數量) * 單據出售量
#          LET m_fap45=(l_faj.faj101-l_faj.faj102)/
#                      (l_faj.faj17-l_faj.faj58) * l_fbf.fbf04
#       END IF
#       #--------- 過帳(2)update faj_file
#       IF l_fbf.fbf04=l_faj.faj17-l_faj.faj58 THEN
#          LET m_chr='5'     ## 出售
#       ELSE
#          LET m_chr=l_faj.faj43
#       END IF
##FUN-B60140   ---end     Add
##-----No:FUN-BA0112 Mark END-----

         #--->本期銷帳折舊=(本期累折-本期銷帳折舊)/(數量-銷帳數量)*處份量
         SELECT fap20,fap21 INTO l_fap20,l_fap21 FROM fap_file
                            WHERE fap50 = l_fbf.fbf01
                              AND fap501= l_fbf.fbf02
                             AND fap03 = '4'
         IF STATUS THEN #No.7926
            #FUN-B60140   ---start   Mark
           # CALL cl_err3("sel","fap_file",l_fbf.fbf01,l_fbf.fbf02,SQLCA.sqlcode,"","sel faj",1)  #No.FUN-660136
           # LET g_showmsg = l_fbf.fbf01,"/",l_fbf.fbf02,"/",'4'               #No.FUN-710028
           # CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)  #No.FUN-710028
           # LET g_success = 'N' #No.FUN-710028
           # CONTINUE FOREACH    #No.FUN-710028
            #FUN-B60140   ---end     Mark
           LET l_fap20 = l_faj.faj17       #FUN-B60140   Add
           LET l_fap21 = l_faj.faj58       #FUN-B60140   Add
         END IF
         LET l_qty = l_fap20 - l_fap21
         IF l_qty > 0 THEN
            LET l_c = (l_faj.faj205 - l_faj.faj206) / l_qty * l_fbf.fbf04
            LET l_c = l_c - l_diffamt                                       #MOD-C80118 add
         ELSE LET l_c = 0
         END IF
         IF l_c IS NULL THEN LET l_c=0 END IF #No.8851
        #CHI-C60010---str---
         CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
         CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
         CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
         CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
         CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
         CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
         CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
         CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
         CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
        #CHI-C60010---end---
         #--->(1.1)更新稅簽異動檔
         #-----No:FUN-B60140-----
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM fap_file
          WHERE fap50 = l_fbf.fbf01
            AND fap501= l_fbf.fbf02
            AND fap03 = '4'
         IF l_cnt = 0 THEN   #無fap_file資料
            INSERT INTO fap_file (fap01,fap02,fap021,fap03,
                                  fap04,fap05,fap06,fap07,
                                  fap08,fap09,fap10,fap101,
                                  fap11,fap12,fap13,fap14,
                                  fap15,fap16,fap17,fap18,
                                  fap19,fap20,fap201,fap21,
                                  fap22,fap23,fap24,fap25,
                                  fap26,fap30,fap31,fap32,
                                  fap33,fap34,fap341,fap35,
                                  fap36,fap37,fap38,fap39,
                                  fap40,fap41,fap42,fap72,           #MOD-C80118 add fap72
                                  fap50,fap501,fap54,fap56,fap57,
                                  #fap67,fap73,fap74,fap77,fap45, #No:FUN-BA0112 mark
                                  fap67,fap73,fap74,fap45, #No:FUN-BA0112 add
                                  fap121,fap131,fap141,
                                  fap052,fap062,fap072,fap082,
                                  fap092,fap103,fap1012,fap112,
                                  fap152,fap162,fap212,fap222,
                                  fap232,fap242,fap252,fap262,
                                  #fap772,fap71,fap79,faplegal) #FUN-B60140 Add faplegal #No:FUN-BA0112 mark
                                  fap71,fap79,faplegal) #No:FUN-BA0112 add 
            VALUES (l_faj.faj01,l_fbf.fbf03,l_fbf.fbf031,'4',
                    g_fbe.fbe02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
                    l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,
                    l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
                    l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                    l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                    l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
                    l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
                   #l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,              #MOD-C80118 mark
                    l_faj.faj62,l_faj.faj63,l_faj.faj68+l_faj.faj681,l_faj.faj67, #MOD-C80118 add
                    l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                    l_faj.faj73,l_faj.faj100,l_faj.faj201,l_faj.faj67-l_diffamt,  #MOD-C80118 add for fap72
                    #l_fbf.fbf01,l_fbf.fbf02,l_c,m_fap56,m_fap57, #No:FUN-BA0112 mark
                    l_fbf.fbf01,l_fbf.fbf02,l_c,0,0, #No:FUN-BA0112 add m_fap56,m_fap57-->0
                    #l_fbf.fbf04,m_fap73,m_fap74,m_chr,m_fap45, #No:FUN-BA0112 mark 
                    l_fbf.fbf04,m_fap73,m_fap74,0, #No:FUN-BA0112 add m_fap45-->0
                    l_faj.faj531,l_faj.faj541,l_faj.faj551,
                    l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                    l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
                    l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                    l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
                    #m_chr,l_c,m_fap79,g_legal) #No:FUN-BA0112 mark 
                     l_c,m_fap79,g_legal) #No:FUN-BA0112 add
         ELSE
            UPDATE fap_file SET fap73 =m_fap73,           #稅簽銷帳成本
                             fap74 =m_fap74,           #    銷帳累折
                             fap71 =l_c,               #    銷帳累折
                             fap79 =m_fap79,           #    銷帳減值  #No:A099
                             fap341 =l_faj.faj68 + l_faj.faj681,   #未折減額     #MOD-C80118 add
                             fap35 =l_faj.faj67,                   #累計折舊(前) #MOD-C80118 add
                             fap72 =l_faj.faj67 - l_diffamt,       #累計折舊(後) #MOD-C80118 add
                             fap37 =l_faj.faj70                    #銷帳累折(前)  #MOD-C80118 add
                         WHERE fap50 = l_fbf.fbf01
                           AND fap501= l_fbf.fbf02
                           AND fap03 = '4'
         END IF
         #-----No:FUN-B60140 END-----

            IF STATUS  THEN
               LET g_showmsg = l_fbf.fbf01,"/",l_fbf.fbf02,"/",'4'               #No.FUN-710028
               CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'upd fap',STATUS,1)  #No.FUN-710028
               LET g_success = 'N'
               CONTINUE FOREACH    #No.FUN-710028
            END IF
        #------------------------MOD-C80118-------------------(S)
        #當月處置應提列折舊且提列方式為4:本月(入帳日至月底比率)
         LET l_fbf10 = l_fbf.fbf10
         IF g_faa.faa15 = '4' THEN
            LET l_yy = YEAR(g_fbe.fbe02) USING '&&&&'
            LET l_mm = MONTH(g_fbe.fbe02)
            UPDATE faj_file SET faj67 = faj67 - l_diffamt,
                                faj205 = faj205 - l_diffamt
             WHERE faj02 = l_fbf.fbf03
               AND faj022 = l_fbf.fbf031
            UPDATE fao_file SET fao07 = fao07 - l_diffamt,
                                fao08 = fao08 - l_diffamt,
                                fao15 = fao15 - l_diffamt
             WHERE fao01 = l_fbf.fbf03
               AND fao02 = l_fbf.fbf031
               AND fao03 = l_yy
               AND fao04 = l_mm
         END IF
         LET l_fbf10 = l_faj.faj68 - l_fbf10 + l_diffamt      #稅簽未折減額
        #------------------------MOD-C80118-------------------(E)
        #-----------------------MOD-D10011-------------------(S)
         LET l_faj66 = 0
         IF (l_faj.faj17-l_faj.faj58)=0 THEN
            LET l_faj66 = 0
         ELSE
            LET l_faj66 = (l_faj.faj66/(l_faj.faj17-l_faj.faj58))*(l_faj.faj17-(l_faj.faj58+l_fbf.fbf04))
         END IF
        #-----------------------MOD-D10011-------------------(E)
         #--->(1.2)更新資產主檔
        #LET l_fbf10 = l_fbf.fbf10                            #MOD-C80118 mark
         UPDATE faj_file 
           #SET faj68 = faj68 - l_fbf10,      #稅簽未折減額   #MOD-C80118 mark
            SET faj68 = l_fbf10,              #稅簽未折減額   #MOD-C80118 add
                faj69 =faj69+m_fap73,         #銷帳成本
                faj70 =faj70+m_fap74,         #銷帳累折
                faj104=faj104+m_fap79,        #銷帳減值  #No:A099
                faj206=faj206+l_c,            #本期銷帳累折
                faj201='5',                   #faj201稅簽的資產狀態no:5366
                faj66  = l_faj66              #稅簽預留殘值         #MOD-D10011 add
          WHERE faj02=l_fbf.fbf03 AND faj022=l_fbf.fbf031
            IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
               LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031                  #No.FUN-710028
               CALL s_errmsg('faj02,fajj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
               LET g_success = 'N'
               CONTINUE FOREACH    #No.FUN-710028
            END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   CLOSE t110_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      #-->(2.1)更新異動單據過帳碼
      UPDATE fbe_file SET fbepost2 = 'Y' WHERE fbe01 = g_fbe.fbe01
          IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","fbe_file",g_fbe.fbe01,"",SQLCA.sqlcode,"","upd fbepost2",1)  #No.FUN-660136
             LET g_success = 'N'
             ROLLBACK WORK
          ELSE
             LET g_fbe.fbepost2='Y'
             DISPLAY BY NAME g_fbe.fbepost2 #
             COMMIT WORK
          END IF
   ELSE ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t110_w()
   DEFINE l_fbf    RECORD LIKE fbf_file.*
   DEFINE l_faj    RECORD LIKE faj_file.*
   DEFINE l_fap    RECORD LIKE fap_file.*
   DEFINE l_bdate,l_edate LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_flag          LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_c             LIKE type_file.num20_6  #No.FUN-4C0008       #No.FUN-680070 DECIMAL(20,6)
   DEFINE l_yy,l_mm       LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE l_chr           LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
   DEFINE m_fap05  LIKE fap_file.fap05,
          m_fap54  LIKE fap_file.fap54,
          m_fap56  LIKE fap_file.fap56,
          m_fap57  LIKE fap_file.fap57,
          m_fap41  LIKE fap_file.fap41,
          m_fap08  LIKE fap_file.fap08,    #NO:8463
          m_fap32  LIKE fap_file.fap32,    #NO:8463
          m_fap45  LIKE fap_file.fap45,    #No:A099
          l_fbf08  LIKE fbf_file.fbf08,          #No.FUN-4C0008
          l_cnt    LIKE type_file.num5     #TQC-780089
   DEFINE l_aba19     LIKE aba_file.aba19     #No.FUN-680028
   DEFINE l_sql       LIKE type_file.chr1000             #No.FUN-680028       #No.FUN-680070 VARCHAR(1000)
   DEFINE l_dbs       STRING                  #No.FUN-680028
#-----NO:FUN-B90096 add start--
   DEFINE l_fbf082 LIKE fbf_file.fbf082,
          m_fap052  LIKE fap_file.fap052,
          m_fap10   LIKE fap_file.fap10,      #MOD-C80118 add
          m_fap103  LIKE fap_file.fap103,     #MOD-C80118 add
          m_fap542  LIKE fap_file.fap542,
          m_fap562  LIKE fap_file.fap562,
          m_fap572  LIKE fap_file.fap572,
          m_fap082  LIKE fap_file.fap082,
          m_fap1012  LIKE fap_file.fap1012
#-----NO:FUN-B90096 add end----
   DEFINE l_diffamt  LIKE fan_file.fan07      #MOD-C80118 add
   DEFINE l_diffamt2 LIKE fan_file.fan07      #MOD-C80118 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
    IF NOT cl_null(g_fbe.fbe11) THEN CALL cl_err('',"afa-035",0) RETURN END IF    #No.MOD-4A0297
   IF g_fbe.fbepost != 'Y' THEN
      CALL cl_err(g_fbe.fbe01,'afa-108',0)
      RETURN
   END IF
   #-->已拋轉總帳, 不可取消還原
   IF NOT cl_null(g_fbe.fbe14) AND g_fah.fahglcr = 'N' THEN     #No.FUN-680028
      CALL cl_err(g_fbe.fbe14,'aap-145',1)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbe.fbe02 < g_faa.faa09 THEN
      CALL cl_err(g_fbe.fbe01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
  #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      #-->已拋轉總帳, 不可取消還原
      IF NOT cl_null(g_fbe.fbe142) AND g_fah.fahglcr = 'N' THEN
         CALL cl_err(g_fbe.fbe142,'aap-145',1)
         RETURN
      END IF
      #-->立帳日期小於關帳日期
      IF g_fbe.fbe02 < g_faa.faa092 THEN
         CALL cl_err(g_fbe.fbe01,'aap-176',1) RETURN
      END IF
   END IF
   #-----No:FUN-B60140-----
      
     CALL s_get_bookno(g_faa.faa07)   
          RETURNING g_flag,g_bookno1,g_bookno2
      IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF #MOD-BC0114
      #FUN-AB0088---add---str---
      #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
      #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套       
      IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF        
      #FUN-AB0088---add---end---
      #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
      #CHI-A60036 add --start--
     #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
     #-----No:FUN-B60140 Mark-----
     # IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add 
     #    CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
     # ELSE
     #    CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
     # END IF
      #CHI-A60036 add --end--
      #-----No:FUN-B60140 Mark END-----
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate          #FUN-B60140   Add
      IF g_fbe.fbe02 < l_bdate OR g_fbe.fbe02 > l_edate THEN
         CALL cl_err(g_fbe.fbe02,'afa-308',0)
         RETURN
      END IF
      #-----No:FUN-B60140-----
      IF g_faa.faa31 = "Y" THEN
         CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
         IF g_fbe.fbe02 < l_bdate OR g_fbe.fbe02 > l_edate THEN
            CALL cl_err(g_fbe.fbe02,'afa-308',0)
            RETURN
         END IF
      END IF
      #-----No:FUN-B60140 END-----
   IF g_faa.faa23 = 'N' THEN
      DECLARE t110_cur4 CURSOR FOR
         SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
      FOREACH t110_cur4 INTO l_fbf.*
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM fan_file
          WHERE fan01 = l_fbf.fbf03
            AND fan02 = l_fbf.fbf031
            AND ((fan03 = YEAR(g_fbe.fbe02) AND fan04 >= MONTH(g_fbe.fbe02))
             OR fan03 > YEAR(g_fbe.fbe02))
            AND fan041 = '1'   #MOD-C50044 add
         IF l_cnt > 0 THEN
            CALL cl_err(l_fbf.fbf03,'afa-348',0)
            RETURN
         END IF
      END FOREACH
   END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fbe.fbe01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   IF NOT cl_null(g_fbe.fbe14) THEN
      IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_fbe.fbe01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
     #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102 
                  "  WHERE aba00 = '",g_faa.faa02b,"'",
                  "    AND aba01 = '",g_fbe.fbe14,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fbe.fbe14,'axr-071',1)
         RETURN
      END IF
 
   END IF
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      IF g_faa.faa232 = 'N' THEN
         DECLARE t110_cur42 CURSOR FOR
            SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
         FOREACH t110_cur42 INTO l_fbf.*
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM fbn_file
             WHERE fbn01 = l_fbf.fbf03
               AND fbn02 = l_fbf.fbf031
               AND ((fbn03 = YEAR(g_fbe.fbe02) AND fbn04 >= MONTH(g_fbe.fbe02))
                OR fbn03 > YEAR(g_fbe.fbe02))
               AND fbn041 = '1'   #MOD-C50044 add
            IF l_cnt > 0 THEN
               CALL cl_err(l_fbf.fbf03,'afa-348',0)
               RETURN
            END IF
         END FOREACH
      END IF
      #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
      CALL s_get_doc_no(g_fbe.fbe01) RETURNING g_t1
      SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
      IF NOT cl_null(g_fbe.fbe142) THEN
         IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
            CALL cl_err(g_fbe.fbe01,'axr-370',0) RETURN
         END IF
      END IF
      IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
         LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
         LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                     "  WHERE aba00 = '",g_faa.faa02c,"'",
                     "    AND aba01 = '",g_fbe.fbe142,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE aba_pre12 FROM l_sql
         DECLARE aba_cs12 CURSOR FOR aba_pre12
         OPEN aba_cs12
         FETCH aba_cs12 INTO l_aba19
         IF l_aba19 = 'Y' THEN
            CALL cl_err(g_fbe.fbe142,'axr-071',1)
            RETURN
         END IF
      END IF
   END IF
   #-----No:FUN-B60140 END-----
   IF NOT cl_sure(18,20) THEN RETURN END IF
  #--------------------------------------CHI-C90051--------------------------(S)
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbe.fbe14,"' '4' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fbe14,fbe15
        INTO g_fbe.fbe14,g_fbe.fbe15
        FROM fbe_file
       WHERE fbe01 = g_fbe.fbe01
      DISPLAY BY NAME g_fbe.fbe14
      DISPLAY BY NAME g_fbe.fbe15
      IF NOT cl_null(g_fbe.fbe14) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
      IF g_faa.faa31 = "Y" THEN
         LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbe.fbe142,"' '4' 'Y'"
         CALL cl_cmdrun_wait(g_str)
         SELECT fbe142,fbe152
           INTO g_fbe.fbe142,g_fbe.fbe152
           FROM fbe_file
          WHERE fbe01 = g_fbe.fbe01
         DISPLAY BY NAME g_fbe.fbe142
         DISPLAY BY NAME g_fbe.fbe152
         IF NOT cl_null(g_fbe.fbe142) THEN
            CALL cl_err('','aap-929',0)
            RETURN
         END IF
      END IF
   END IF
  #--------------------------------------CHI-C90051--------------------------(E)
   BEGIN WORK
 
    OPEN t110_cl USING g_fbe.fbe01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
   #--------- 還原過帳(1)update faj_file
   DECLARE t110_cur3 CURSOR FOR
      SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
   LET g_success = 'Y'      #No.FUN-8A0086
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t110_cur3 INTO l_fbf.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbf01',g_fbe.fbe01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         EXIT FOREACH
      END IF
      #----- 找出 fap_file 之值以便 update faj_file
      SELECT fap05,fap54,fap56,fap57,fap41,
             fap08,fap32,fap45,fap10,fap103,                                     #MOD-C80118 add fap10、fap103
             fap052,fap542,fap562,fap572,fap082,fap1012                         #NO:FUN-B90096 add
        INTO m_fap05,m_fap54,m_fap56,m_fap57,m_fap41,
             m_fap08,m_fap32,m_fap45,m_fap10,m_fap103,                           #MOD-C80118 add fap10、fap103
             m_fap052,m_fap542,m_fap562,m_fap572,m_fap082,m_fap1012 #NO:FUN-B90096 add
        FROM fap_file
        WHERE fap50=l_fbf.fbf01 AND fap501=l_fbf.fbf02 AND fap03='4'
      IF STATUS THEN #No.7926
         LET g_showmsg = l_fbf.fbf01,"/",l_fbf.fbf02,"/",'4'                #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'  #No.FUN-710028
         CONTINUE FOREACH     #No.FUN-710028
      END IF
      SELECT * INTO l_faj.* FROM faj_file
            WHERE faj02=l_fbf.fbf03 AND faj022=l_fbf.fbf031
      LET l_fbf08 = l_fbf.fbf08
      LET l_fbf082 = l_fbf.fbf082 #NO:FUN-B90096 add
     #-----------------------------MOD-C80118------------------------(S)
      LET l_diffamt = 0
      LET l_diffamt2 = 0
     #當月處置應提列折舊且提列方式為4:本月(入帳日至月底比率)
      IF g_faa.faa15 = '4' THEN
         LET l_diffamt = m_fap10 - m_fap54
         LET l_diffamt2 = m_fap103 - m_fap542
         LET l_yy = YEAR(g_fbe.fbe02) USING '&&&&'
         LET l_mm = MONTH(g_fbe.fbe02)
         UPDATE fan_file SET fan07 = fan07 + l_diffamt,
                             fan08 = fan08 + l_diffamt,
                             fan15 = fan15 + l_diffamt
          WHERE fan01 = l_fbf.fbf03
            AND fan02 = l_fbf.fbf031
            AND fan03 = l_yy
            AND fan04 = l_mm
         IF g_faa.faa31 = 'Y' THEN
           UPDATE fbn_file SET fbn07 = fbn07 + l_diffamt2,
                               fbn08 = fbn08 + l_diffamt2,
                               fbn15 = fbn15 + l_diffamt2
            WHERE fbn01 = l_fbf.fbf03
              AND fbn02 = l_fbf.fbf031
              AND fbn03 = l_yy
              AND fbn04 = l_mm
         END IF
      END IF
      LET l_fbf08 = l_faj.faj33 + l_faj.faj331 + l_fbf08 - l_diffamt
      LET l_fbf082 = l_faj.faj332 + l_faj.faj3312 + l_fbf082 - l_diffamt2
     #-----------------------------MOD-C80118------------------------(E)
      UPDATE faj_file set faj43 =m_fap05,#資產狀態
             faj58 =faj58-l_fbf.fbf04,  #銷帳數量
             faj59 =faj59-m_fap56,      #銷帳成本
             faj60 =faj60-m_fap57,      #銷帳累折
             faj102=faj102-m_fap45,     #銷帳減值準備    #No:A099
             faj204=faj204-m_fap54,     #本期銷帳累折
             faj32 = faj32 + l_diffamt,     #累計折舊        #MOD-C80118 add
             faj203 = faj203 + l_diffamt,   #本期累折        #MOD-C80118 add
            #faj33 = faj33 + l_fbf08,       #未折減額        #MOD-C80118 mark
             faj33 = l_fbf08,               #未折減額        #MOD-C80118 add
             faj100=m_fap41,#異動日期
             faj31 = m_fap08
       WHERE faj02=l_fbf.fbf03 AND faj022=l_fbf.fbf031
      IF STATUS  THEN
         LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031                #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'  #No.FUN-710028
         CONTINUE FOREACH     #No.FUN-710028
      END IF
      #-----NO:FUN-B90096 start--
      IF g_faa.faa31 = 'Y' THEN
        #CHI-C60010---str---
         CALL cl_digcut(m_fap562,g_azi04_1) RETURNING m_fap562
         CALL cl_digcut(m_fap572,g_azi04_1) RETURNING m_fap572
         CALL cl_digcut(m_fap542,g_azi04_1) RETURNING m_fap542
         CALL cl_digcut(m_fap45,g_azi04_1) RETURNING m_fap45
         CALL cl_digcut(m_fap1012,g_azi04_1) RETURNING m_fap1012
         CALL cl_digcut(m_fap082,g_azi04_1) RETURNING m_fap082
        #CHI-C60010---end---
         UPDATE faj_file SET
                faj432 =m_fap052,                   #資產狀態
                faj582 =faj582-l_fbf.fbf04,         #銷帳數量
                faj592 =faj592-m_fap562,            #銷帳成本
               #faj602 = faj602 - m_fap572,                #銷帳累折 #MOD-C80118 mark
                faj602 = faj602 - m_fap572 + l_diffamt2,   #銷帳累折 #MOD-C80118 add
                faj1022=faj1022-m_fap45,                   #銷帳減值準備
               #faj2042= faj2042 - m_fap542,               #本期銷帳累折  #MOD-C80118 mark
                faj2042= faj2042 - m_fap542 + l_diffamt2,  #本期銷帳累折  #MOD-C80118 add
                faj322 = faj322 + l_diffamt2,              #累計折舊      #MOD-C80118 add
                faj2032= faj2032 + l_diffamt2,             #本期累折      #MOD-C80118 add
               #faj332 = m_fap1012,                        #未折減額      #MOD-C80118 mark
                faj332 = l_fbf082,                         #未折減額      #MOD-C80118 add
                faj312 = m_fap082
          WHERE faj02=l_fbf.fbf03 AND faj022=l_fbf.fbf031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      END IF 
     #-----NO:FUN-B90096 end----      
    #-------------------------MOD-CA0101------------------mark 
    # IF cl_null(l_fbf.fbf031) THEN      #MOD-9B0039 add
    #    UPDATE faj_file set faj43 =m_fap05 #資產狀態
    #     WHERE faj02=l_fbf.fbf03 AND faj022<>l_fbf.fbf031
    #    IF SQLCA.sqlcode THEN
    #       CALL s_errmsg('faj02',l_fbf.fbf03,'upd faj',STATUS,0)   #No.FUN-710028
    #    END IF
    # END IF   #MOD-9B0039 add
    ##-----NO:FUN-B90096 start--
    # IF g_faa.faa31 = 'Y' THEN
    #    IF cl_null(l_fbf.fbf031) THEN
    #       UPDATE faj_file set faj432 =m_fap052 #資產狀態
    #        WHERE faj02=l_fbf.fbf03 AND faj022<>l_fbf.fbf031
    #       IF SQLCA.sqlcode THEN
    #          CALL s_errmsg('faj02',l_fbf.fbf03,'upd faj',STATUS,0)
    #       END IF
    #    END IF
    # END IF 
    ##-----NO:FUN-B90096 end----
    #-------------------------MOD-CA0101------------------mark 
      #--------- 還原過帳(2)delete fap_file
      IF g_fbe.fbepost2<>'Y' THEN   #No:FUN-B60140
         DELETE FROM fap_file
                WHERE fap50=l_fbf.fbf01 AND fap501=l_fbf.fbf02 AND fap03='4'
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbf.fbf01,"/",l_fbf.fbf02,"/",'4'                #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)   #No.FUN-710028
         CLOSE t110_cl ROLLBACK WORK
         LET g_success = 'N'  #No.FUN-710028
         CONTINUE FOREACH     #No.FUN-710028
      END IF
     END IF  #No:FUN-B60140
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   CLOSE t110_cl
   #--------- 還原過帳(3)update fbe_file
   UPDATE fbe_file SET fbepost = 'N' WHERE fbe01 = g_fbe.fbe01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fbe01',g_fbe.fbe01,'upd fbepost',STATUS,1)   #No.FUN-710028
      LET g_fbe.fbepost='Y'
   ELSE
      LET g_fbe.fbepost='N'
      DISPLAY BY NAME g_fbe.fbepost #
   END IF
   CALL s_showmsg()         #No.FUN-710028
   IF g_success = 'N' THEN  #No.FUN-710028
      ROLLBACK WORK         #No.FUN-710028
   ELSE                     #No.FUN-710028 
      COMMIT WORK           #No.FUN-710028
   END IF
  #--------------------------------------CHI-C90051--------------------------mark
  #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbe.fbe14,"' '4' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   #-----No:FUN-B60140-----
  #   IF g_faa.faa31 = "Y" THEN
  #      LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbe.fbe142,"' '4' 'Y'"
  #      CALL cl_cmdrun_wait(g_str)
  #   END IF
  #   #-----No:FUN-B60140 END-----
  #   SELECT fbe14,fbe15,fbe142,fbe152  #No:FUN-B60140 
  #     INTO g_fbe.fbe14,g_fbe.fbe15,g_fbe.fbe142,g_fbe.fbe152  #No:FUN-B60140 
  #     FROM fbe_file
  #    WHERE fbe01 = g_fbe.fbe01
  #   DISPLAY BY NAME g_fbe.fbe14
  #   DISPLAY BY NAME g_fbe.fbe15
  #   DISPLAY BY NAME g_fbe.fbe142  #No:FUN-B60140
  #   DISPLAY BY NAME g_fbe.fbe152  #No:FUN-B60140
  #END IF
  #--------------------------------------CHI-C90051--------------------------mark
   IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_fbe.fbeconf,"",g_fbe.fbepost,"",g_chr,"")
END FUNCTION
 
#-----------------稅簽過帳還原------------------------------
FUNCTION t110_7()
   DEFINE l_fbf    RECORD LIKE fbf_file.*,
          m_fap71  LIKE fap_file.fap71,
          m_fap73  LIKE fap_file.fap73,
          m_fap74  LIKE fap_file.fap74,
          m_fap79  LIKE fap_file.fap79,      #No:A099
          m_fap04  LIKE fap_file.fap04,
          m_fap34  LIKE fap_file.fap34,                #MOD-C80118 add
          m_fap42  LIKE fap_file.fap42,      #No.MOD-480081
          m_fap32  LIKE fap_file.fap32,                #MOD-D10011 add
          l_fap04  LIKE fap_file.fap04,
          l_fbf10  LIKE fbf_file.fbf10,          #No.FUN-4C0008
          l_bdate,l_edate   LIKE type_file.dat,          #No.FUN-680070 DATE
          l_yy,l_mm         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_mm1             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_chr             LIKE type_file.chr8,         #No.FUN-680070 VARCHAR(08)
          l_flag            LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_cnt             LIKE type_file.num5          #TQC-780089
   DEFINE l_faj      RECORD LIKE faj_file.*            #MOD-C80118 add
   DEFINE l_diffamt  LIKE fan_file.fan07               #MOD-C80118 add
  
   IF s_shut(0) THEN RETURN END IF
   IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
   IF g_fbe.fbepost2 != 'Y' THEN      #No:A099
      CALL cl_err(g_fbe.fbe01,'afa-108',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbe.fbe02 < g_faa.faa13 THEN
      CALL cl_err(g_fbe.fbe01,'afa-308',0) 
      RETURN
   END IF
  #-MOD-A80137-end-

     #CALL s_get_bookno(g_faa.faa07)                                #MOD-D20017 mark
      CALL s_get_bookno(g_faa.faa11)                                #MOD-D20017 add
          RETURNING g_flag,g_bookno1,g_bookno2
      IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF #MOD-BC0114
      #FUN-AB0088---add---str---
      #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
      #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套       
      IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF        
      #FUN-AB0088---add---end---
      #CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
      #CHI-A60036 add --start--
     #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
     #--MOD-D20017--mark
     #IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add                                 
     #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate 
     #ELSE                                                                       
     #   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate   
     #END IF
     #--MOD-D20017--mark
      CALL s_azm(g_faa.faa11,g_faa.faa12) RETURNING l_flag,l_bdate,l_edate         #MOD-D20017 add
     #CHI-A60036 add --end--
   IF g_fbe.fbe02 < l_bdate OR g_fbe.fbe02 > l_edate THEN
      LET l_chr = YEAR(g_faa.faa13) using '####','-',
                  MONTH(g_faa.faa13) using '##'
      CALL cl_err(l_chr,'afa-347',0)
      RETURN
   END IF
   IF g_faa.faa23 = 'N' THEN
      DECLARE t110_cur5 CURSOR FOR
         SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
      FOREACH t110_cur5 INTO l_fbf.*
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM fao_file
          WHERE fao01 = l_fbf.fbf03
            AND fao02 = l_fbf.fbf031
            AND ((fao03 = YEAR(g_fbe.fbe02) AND fao04 >= MONTH(g_fbe.fbe02))
             OR fao03 > YEAR(g_fbe.fbe02))
            AND fao041 = '1'   #MOD-C50044 add
         IF l_cnt > 0 THEN
            CALL cl_err(l_fbf.fbf03,'afa-348',0)
            RETURN
         END IF
      END FOREACH
   END IF
 
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t110_cl USING g_fbe.fbe01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_fbe.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
   #--------- 還原過帳(1)update faj_file
   DECLARE t110_cur31 CURSOR FOR
      SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
   LET g_success = 'Y'      #No.FUN-8A0086
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t110_cur31 INTO l_fbf.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbf01',g_fbe.fbe01,'foreach:',SQLCA.sqlcode,0) #No.FUN-710028
         EXIT FOREACH
      END IF
         #----- 找出 fap_file 之值以便 update faj_file
      SELECT fap71,fap73,fap74,fap79,fap42,                 #No.MOD-480081 add fap42
             fap34,fap32                                       #MOD-C80118 add fap34 #MOD-D10011 add fap32
        INTO m_fap71,m_fap73,m_fap74,m_fap79,m_fap42,       #end No:A099 MOD-480081
             m_fap34,m_fap32                                   #MOD-C80118 add fap34 #MOD-D10011 add fap32
        FROM fap_file
       WHERE fap50=l_fbf.fbf01 AND fap501=l_fbf.fbf02 AND fap03='4'
         IF STATUS THEN #No.7926
          LET g_showmsg = l_fbf.fbf01,"/",l_fbf.fbf02,"/",'4'                #No.FUN-710028
          CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)   #No.FUN-710028
          LET g_success ='N'   #No.FUN-710028
          CONTINUE FOREACH     #No.FUN-710028   
         END IF
        #--------------------MOD-C80118--------------------------mark
        ##-----No:FUN-B60140-----
        ##財簽皆未過帳時，才可刪fap_file
        #IF g_fbe.fbepost <>'Y' THEN   #No:FUN-B60140
        #   DELETE FROM fap_file
        #    WHERE fap50=l_fbf.fbf01 AND fap501=l_fbf.fbf02 AND fap03='4'
        #    IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
        #       CLOSE t110_cl ROLLBACK WORK
        #    END IF
        #ELSE
        #   UPDATE fap_file SET fap73 =0  ,           #稅簽銷帳成本
        #                       fap74 =0  ,           #銷帳累折
        #                       fap71 =0  ,           #銷帳累折
        #                       fap79 =0              #銷帳減值  #No:A099
        #                 WHERE fap50 = l_fbf.fbf01
        #                  AND fap501= l_fbf.fbf02
        #                  AND fap03 = '4'
        # END IF
        ##-----No:FUN-B60140 END-----
        #IF STATUS  THEN
        #   CALL cl_err3("upd","fap_file",l_fbf.fbf01,l_fbf.fbf02,SQLCA.sqlcode,"","upd fap",1)  #No.FUN-660136
        #   LET g_showmsg = l_fbf.fbf01,"/",l_fbf.fbf02,"/",'4'                #No.FUN-710028
        #   CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'upd fap',STATUS,1)   #No.FUN-710028
        #   LET g_success = 'N'
        #   CONTINUE FOREACH     #No.FUN-710028   
        #END IF
        #--------------------MOD-C80118--------------------------mark
         #--->(1.1)更新資產主檔
         LET l_fbf10 = l_fbf.fbf10
        #-----------------------------MOD-C80118------------------------(S)
         SELECT * INTO l_faj.*
           FROM faj_file
          WHERE faj02 = l_fbf.fbf03
            AND faj022 = l_fbf.fbf031
         LET l_diffamt = 0
        #當月處置應提列折舊且提列方式為4:本月(入帳日至月底比率)
         IF g_faa.faa15 = '4' THEN
            LET l_diffamt = m_fap34 - m_fap71
            LET l_yy = YEAR(g_fbe.fbe02) USING '&&&&'
            LET l_mm = MONTH(g_fbe.fbe02)
            UPDATE fao_file SET fao07 = fao07 + l_diffamt,
                                fao08 = fao08 + l_diffamt,
                                fao15 = fao15 + l_diffamt
             WHERE fao01 = l_fbf.fbf03
               AND fao02 = l_fbf.fbf031
               AND fao03 = l_yy
               AND fao04 = l_mm
         END IF
         LET l_fbf10 = l_faj.faj68 + l_faj.faj681 + l_fbf10 - l_diffamt
        #-----------------------------MOD-C80118------------------------(E)
         UPDATE faj_file 
           #SET faj68 = faj68 + l_fbf10,      #稅簽未折減額 #MOD-C80118 mark
            SET faj68 = l_fbf10,              #稅簽未折減額 #MOD-C80118 add
                faj69=faj69-m_fap73,          #稅簽銷帳成本
                faj70=faj70-m_fap74,          #稅簽銷帳累折
                faj104=faj104-m_fap79,        #稅簽銷帳減值  #No:A099
                faj206=faj206-m_fap71,        #本期銷帳累折
                faj67 = faj67 + l_diffamt,    #累計折舊 #MOD-C80118 add
                faj205 = faj205 + l_diffamt,  #本期累折 #MOD-C80118 add
                faj201 = m_fap42,             #No.8851
                faj66  = m_fap32              #稅簽預留殘值 #MOD-D10011 add
          WHERE faj02=l_fbf.fbf03 AND faj022=l_fbf.fbf031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fbf.fbf03,"/",l_fbf.fbf031                 #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
            LET g_success = 'N'          #No.FUN-710028
            CONTINUE FOREACH             #No.FUN-710028
         END IF
        #-------------------MOD-C80118----------------------(S)
         #財簽皆未過帳時，才可刪fap_file
         IF g_fbe.fbepost <>'Y' THEN
            DELETE FROM fap_file
             WHERE fap50 = l_fbf.fbf01
               AND fap501 = l_fbf.fbf02
               AND fap03 = '4'
            IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
               CLOSE t110_cl
               ROLLBACK WORK
            END IF
         ELSE
            UPDATE fap_file
               SET fap73 =0,             #稅簽銷帳成本
                   fap74 =0,             #銷帳累折
                   fap71 =0,             #銷帳累折
                   fap79 =0              #銷帳減值
             WHERE fap50 = l_fbf.fbf01
               AND fap501= l_fbf.fbf02
               AND fap03 = '4'
         END IF
         IF STATUS  THEN
            CALL cl_err3("upd","fap_file",l_fbf.fbf01,l_fbf.fbf02,SQLCA.sqlcode,"","upd fap",1)
            LET g_showmsg = l_fbf.fbf01,"/",l_fbf.fbf02,"/",'4'
            CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'upd fap',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH     #No.FUN-710028
         END IF
        #-------------------MOD-C80118----------------------(E)

   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   CLOSE t110_cl
   #--------- 還原過帳(3)update fbe_file
   CALL s_showmsg()   #No.FUN-710028
   UPDATE fbe_file SET fbepost2 = 'N' WHERE fbe01 = g_fbe.fbe01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fbe_file",g_fbe.fbe01,"",SQLCA.sqlcode,"","upd fbepost2",1)  #No.FUN-660136
      LET g_fbe.fbepost2='Y'
      ROLLBACK WORK
   ELSE
      LET g_fbe.fbepost2='N'
      COMMIT WORK
      DISPLAY BY NAME g_fbe.fbepost2 #
   END IF
END FUNCTION
 
FUNCTION t110_upd(p_cmd)
  DEFINE p_cmd    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_fbf    RECORD LIKE fbf_file.*
   IF cl_null(t_azi.azi01) THEN                #No.CHI-6A0004 l_azi-->t_azi 
      SELECT * INTO t_azi.* FROM azi_file WHERE azi01=g_fbe.fbe05   #No.CHI-6A0004 l_azi-->t_azi
      IF SQLCA.SQLCODE THEN
         LET t_azi.azi04=g_azi04               #No.CHI-6A0004 l_azi-->t_azi
      END IF
   END IF
   LET g_fbe.fbe08=0 LET g_fbe.fbe09=0
   #合計未稅金額/處分損益
   SELECT SUM(fbf06),SUM(fbf07),SUM(fbf09)
          INTO g_fbe.fbe08,g_fbe.fbe09,g_fbe.fbe10
          FROM fbf_file WHERE fbf01=g_fbe.fbe01
   IF g_fbe.fbe08 IS NULL THEN LET g_fbe.fbe08=0 END IF
   IF g_fbe.fbe09 IS NULL THEN LET g_fbe.fbe09=0 END IF
   IF g_fbe.fbe10 IS NULL THEN LET g_fbe.fbe10=0 END IF
   CALL cl_digcut(g_fbe.fbe08,t_azi.azi04) RETURNING g_fbe.fbe08     #No.CHI-6A0004 l_azi-->t_azi
   CALL cl_digcut(g_fbe.fbe09,g_azi04) RETURNING g_fbe.fbe09
  IF g_fbe.fbe073='N' THEN  #不含稅   #MOD-590230將mark拿掉
 
   #合計原幣稅額/含稅金額
   LET g_fbe.fbe08x=g_fbe.fbe08*g_fbe.fbe071/100
   IF cl_null(g_fbe.fbe08x) THEN LET g_fbe.fbe08x = 0 END IF
   CALL cl_digcut(g_fbe.fbe08x,t_azi.azi04) RETURNING g_fbe.fbe08x   #No.CHI-6A0004 l_azi-->t_azi
   LET g_fbe.fbe08t=g_fbe.fbe08+g_fbe.fbe08x
 
   #合計本幣稅額/含稅金額
   LET g_fbe.fbe09x=g_fbe.fbe09*g_fbe.fbe071/100
   CALL cl_digcut(g_fbe.fbe09x,g_azi04) RETURNING g_fbe.fbe09x
   LET g_fbe.fbe09t=g_fbe.fbe09+g_fbe.fbe09x
   ELSE   # 含稅
      LET g_fbe.fbe08t=g_fbe.fbe08
      IF g_fbe.fbe071 = 0 THEN   #零稅率,應設不含稅
        LET g_fbe.fbe08x=g_fbe.fbe08*g_fbe.fbe071/100
        CALL cl_digcut(g_fbe.fbe08x,t_azi.azi04) RETURNING g_fbe.fbe08x    #No.CHI-6A0004 l_azi-->t_azi
        LET g_fbe.fbe08t=g_fbe.fbe08+g_fbe.fbe08x
        LET g_fbe.fbe09x=g_fbe.fbe09*g_fbe.fbe071/100
        CALL cl_digcut(g_fbe.fbe09x,g_azi04) RETURNING g_fbe.fbe09x
        LET g_fbe.fbe09t=g_fbe.fbe09+g_fbe.fbe09x
      ELSE
        LET g_fbe.fbe08x=g_fbe.fbe08 * (1-(1/((100+g_fbe.fbe071)/100)))
        CALL cl_digcut(g_fbe.fbe08x,t_azi.azi04) RETURNING g_fbe.fbe08x    #No.CHI-6A0004 l_azi-->t_azi   
        LET g_fbe.fbe08=g_fbe.fbe08t-g_fbe.fbe08x
        LET g_fbe.fbe09t=g_fbe.fbe09
        LET g_fbe.fbe09x=g_fbe.fbe09 * (1-(1/((100+g_fbe.fbe071)/100)))
        CALL cl_digcut(g_fbe.fbe09x,g_azi04) RETURNING g_fbe.fbe09x
        LET g_fbe.fbe09=g_fbe.fbe09t-g_fbe.fbe09x
      END IF
   END IF
   BEGIN WORK
   LET g_success = 'Y'

  IF p_cmd !='s' THEN
      UPDATE fbe_file SET
                   fbe08=g_fbe.fbe08,      fbe08x=g_fbe.fbe08x,
                   fbe08t=g_fbe.fbe08t,    fbe09=g_fbe.fbe09,
                   fbe09x=g_fbe.fbe09x,    fbe09t=g_fbe.fbe09t,
                   fbe10=g_fbe.fbe10
      WHERE fbe01=g_fbe.fbe01
     IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
        CALL cl_err3("upd","fbe_file",g_fbe.fbe01,"",SQLCA.sqlcode,"","upd fbe",1)  #No.FUN-660136
        ROLLBACK WORK
        RETURN
      END IF
  END IF
  CALL t110_show1()
  COMMIT WORK
 
END FUNCTION
 
FUNCTION t110_out()
   DEFINE l_cmd        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
          l_wc,l_wc2    LIKE type_file.chr50,        #No.FUN-680070 VARCHAR(50)
          l_prtway    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   CALL cl_wait()
   LET l_wc='fbe01="',g_fbe.fbe01,'"'
  # SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afar110' #FUN-C30085 mark
   #FUN-D10098--add--str--
   IF g_aza.aza26 = '2' THEN
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'gfag110'
   ELSE
   #FUN-D10098--add--end--
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afag110' #FUN-C30085 add
   END IF   #FUN-D10098 add
   IF SQLCA.sqlcode OR cl_null(l_wc2) THEN  #CHI-970053 
      LET l_wc2 = " '3' '1' "       #TQC-610055  #CHI-970053
   END IF
  # LET l_cmd = "afar110",  #FUN-C30085 mark
   #FUN-D10098--add--str--
   IF g_aza.aza26 = '2' THEN
      LET l_cmd = "gfag110",   
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                  " '",l_wc CLIPPED,"' ",l_wc2
   ELSE
   #FUN-D10098--add--end--
   LET l_cmd = "afag110",   #FUN-C30085 add
                " '",g_today CLIPPED,"' ''",
                " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                " '",l_wc CLIPPED,"' ",l_wc2
   END IF   #FUN-D10098 add
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
#FUNCTION t110_x()                    #FUN-D20035
FUNCTION t110_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01=g_fbe.fbe01
   IF g_fbe.fbe18 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
   IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbe.fbeconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   #作废操作
   IF p_type = 1 THEN
      IF g_fbe.fbeconf ='X' THEN RETURN END IF
   ELSE
   #取消作废
      IF g_fbe.fbeconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t110_cl USING g_fbe.fbe01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110_cl INTO g_fbe.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbe.fbe01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl ROLLBACK WORK RETURN
   END IF
   #-->作廢轉換01/08/01
  #IF cl_void(0,0,g_fbe.fbeconf)   THEN       #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF     #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
      LET l_fbe00=g_fbe.fbeconf               #No.MOD-510142
     #IF g_fbe.fbeconf ='N' THEN                                         #FUN-D20035
      IF p_type = 1 THEN                                                 #FUN-D20035
         LET g_fbe.fbeconf='X'
         LET g_fbe.fbe18='9'   #FUN-580109
      ELSE
         LET g_fbe.fbeconf='N'
         LET g_fbe.fbe18='0'   #FUN-580109
      END IF
 
      UPDATE fbe_file SET fbeconf =g_fbe.fbeconf,
                          fbe18   =g_fbe.fbe18,   #FUN-580109
                          fbemodu =g_user,
                          fbedate =TODAY
                    WHERE fbe01 = g_fbe.fbe01
      IF STATUS THEN CALL cl_err('upd fbeconf:',STATUS,1) LET g_success='N' END IF
     #---------------------------MOD-D10051---------------------(S)
      IF g_success='Y' THEN
        DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 4
                               AND npp01 = g_fbe.fbe01
                               AND npp011 = 1
        IF STATUS THEN
           CALL cl_err('del npp_file:',STATUS,1)
           LET g_success='N'
        END IF
      END IF
      IF g_success='Y' THEN
        DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 4
                               AND npq01 = g_fbe.fbe01
                               AND npq011 = 1
        IF STATUS THEN
           CALL cl_err('del npq_file:',STATUS,1)
           LET g_success='N'
        END IF
      END IF
     #---------------------------MOD-D10051---------------------(E)
      IF g_success='Y' THEN
         COMMIT WORK
         IF g_fbe.fbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fbe.fbe18 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fbe.fbeconf,g_chr2,g_fbe.fbepost,"",g_chr,"")
         CALL cl_flow_notify(g_fbe.fbe01,'V')
      ELSE
         ROLLBACK WORK
      END IF
      SELECT fbeconf,fbe18 INTO g_fbe.fbeconf,g_fbe.fbe18   #FUN-580109
        FROM fbe_file
       WHERE fbe01 = g_fbe.fbe01
      DISPLAY BY NAME g_fbe.fbeconf
      DISPLAY BY NAME g_fbe.fbe18   #FUN-580109
   END IF
END FUNCTION
 
FUNCTION t110_9()
  DEFINE  p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          p_key         LIKE fbe_file.fbe01,
          l_begin_key   LIKE fbe_file.fbe01,
          l_ome    DYNAMIC ARRAY OF RECORD   #程式變數(Prinram Variables)
                   ome01     LIKE ome_file.ome01,
                   ome02     LIKE ome_file.ome02,
                   occ02     LIKE occ_file.occ02,
                   ome211    LIKE ome_file.ome211,
                   ome59     LIKE ome_file.ome59,
                   ome59x    LIKE ome_file.ome59x,
                   ome59t    LIKE ome_file.ome59t
                END RECORD,
                l_maxac         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
                l_n,l_ac        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
                l_exit_sw       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                l_wc            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
                l_sql           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(800)
                l_priv          LIKE type_file.chr20,           #No.FUN-680070 VARCHAR(10)
                l_time          LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8)
 
   IF cl_null(g_fbe.fbe01) THEN RETURN END IF
   LET p_row = 2 LET p_col = 2
 
    OPEN WINDOW t110_ome AT p_row,p_col
        WITH FORM "afa/42f/afat1103"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("afat1103")
 
   WHILE TRUE
     LET l_exit_sw = "y"
     CALL cl_opmsg('w')
     LET l_sql =
        "SELECT ome01,ome02,occ02,ome211,ome59,ome59x,ome59t",
        " FROM ome_file,occ_file ",
        " WHERE ome16 ='",g_fbe.fbe11,"'",   #單頭
        "   AND omevoid = 'N'",
        "   AND ome04 = occ01 ",
        " ORDER BY 1,2 "
 
 
     PREPARE t110_j_prepare FROM l_sql
     DECLARE t110ome_curs CURSOR FOR t110_j_prepare
     LET l_ac = 1
     FOREACH t110ome_curs INTO l_ome[l_ac].*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        LET l_ac = l_ac + 1

     END FOREACH
     LET l_maxac = l_ac - 1
      DISPLAY g_fbe.fbe01 TO fbe01    #No.MOD-480083
      DISPLAY g_fbe.fbe11 TO fbe11    #No.MOD-480083
     CALL cl_set_act_visible("accept",FALSE)
      CALL cl_set_act_visible("cancel",FALSE)    #No.MOD-480083
     DISPLAY ARRAY l_ome TO s_ome.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
         ON ACTION exit      #No.MOD-480083
           EXIT DISPLAY
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        
        ON ACTION controlg      
           CALL cl_cmdask()     
     END DISPLAY
     CALL cl_set_act_visible("accept",TRUE)
      CALL cl_set_act_visible("cancel",TRUE)      #No.MOD-480083
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     IF l_exit_sw = "y" THEN EXIT WHILE  END IF
   END WHILE
   CLOSE WINDOW t110_ome
END FUNCTION
 
FUNCTION t110_gen_glcr(p_fbe,p_fah)
  DEFINE p_fbe     RECORD LIKE fbe_file.*
  DEFINE p_fah     RECORD LIKE fah_file.*
 
    IF cl_null(p_fah.fahgslp) THEN
       CALL cl_err(p_fbe.fbe01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_showmsg_init()    #No.FUN-710028
    IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
       CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'0')
    END IF #FUN-C30313 add
   #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 add
       IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
          CALL t110_gl(g_fbe.fbe01,g_fbe.fbe02,'1')
       END IF #FUN-C30313 add
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t110_carry_voucher()
  DEFINE l_fahgslp    LIKE fah_file.fahgslp
  DEFINE li_result    LIKE type_file.num5          #No.FUN-680070 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF NOT cl_null(g_fbe.fbe14)  THEN
       CALL cl_err(g_fbe.fbe14,'aap-618',1)
       RETURN
    END IF
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          IF NOT cl_null(g_fbe.fbe142)  THEN
             CALL cl_err(g_fbe.fbe142,'aap-618',1)
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF
   #FUN-B90004---End---

 
    CALL s_get_doc_no(g_fbe.fbe01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    IF g_fah.fahdmy3 = 'N' THEN RETURN END IF
   #IF g_fah.fahglcr = 'Y' THEN                    #FUN-B90004
    IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp)) THEN   #FUN-B90004
       LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",   #FUN-A50102
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                   "  WHERE aba00 = '",g_faa.faa02b,"'",
                   "    AND aba01 = '",g_fbe.fbe14,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_fbe.fbe14,'aap-991',1)
          RETURN
       END IF
      #FUN-B90004--Begin--
      ##-----No:FUN-B60140-----
      #IF g_faa.faa31 = "Y" THEN
      #   LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #   LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
      #               "  WHERE aba00 = '",g_faa.faa02c,"'",
      #               "    AND aba01 = '",g_fbe.fbe142,"'"
      #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      #   PREPARE aba_pre22 FROM l_sql
      #   DECLARE aba_cs22 CURSOR FOR aba_pre22
      #   OPEN aba_cs22
      #   FETCH aba_cs22 INTO l_n
      #   IF l_n > 0 THEN
      #      CALL cl_err(g_fbe.fbe142,'aap-991',1)
      #      RETURN
      #   END IF
      #END IF
      ##-----No:FUN-B60140 END----- 
      #FUN-B90004---End---
       LET l_fahgslp = g_fah.fahgslp
    ELSE
      #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
       CALL cl_err('','aap-936',1)   #FUN-B90004
       RETURN
    END IF
   #FUN-B90004--Begin--
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp1)) THEN
          LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
          LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
                      "  WHERE aba00 = '",g_faa.faa02c,"'",
                      "    AND aba01 = '",g_fbe.fbe142,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          PREPARE aba_pre22 FROM l_sql
          DECLARE aba_cs22 CURSOR FOR aba_pre22
          OPEN aba_cs22
          FETCH aba_cs22 INTO l_n
          IF l_n > 0 THEN
             CALL cl_err(g_fbe.fbe142,'aap-991',1)
             RETURN
          END IF
       ELSE
          CALL cl_err('','aap-936',1)
          RETURN
       END IF
    END IF
   #FUN-B90004---End---
    IF cl_null(l_fahgslp) THEN
       CALL cl_err(g_fbe.fbe01,'axr-070',1)
       RETURN
    END IF
   #IF g_aza.aza63 = 'Y' THEN    #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' THEN    #FUN-AB0088 add
       IF cl_null(g_fah.fahgslp1) THEN
          CALL cl_err(g_fbe.fbe01,'axr-070',1)
          RETURN
       END IF
    END IF
    LET g_wc_gl = 'npp01 = "',g_fbe.fbe01,'" AND npp011 = 1'
    LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fbe.fbeuser,"' '",g_fbe.fbeuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbe.fbe02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"  #No.FUN-680028   #MOD-860284#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = 'Y' THEN #FUN-C30313 add
          LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fbe.fbeuser,"' '",g_fbe.fbeuser,"' 
                    '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbe.fbe02,"' 
                     'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
          CALL cl_cmdrun_wait(g_str)
       END IF #FUN-C30313 add
    END IF
    #-----No:FUN-B60140 END-----
    SELECT fbe14,fbe15,fbe142,fbe152  #No:FUN-B60140 
      INTO g_fbe.fbe14,g_fbe.fbe15,g_fbe.fbe142,g_fbe.fbe152  #No:FUN-B60140 
      FROM fbe_file
     WHERE fbe01 = g_fbe.fbe01
    DISPLAY BY NAME g_fbe.fbe14
    DISPLAY BY NAME g_fbe.fbe15
    DISPLAY BY NAME g_fbe.fbe142  #No:FUN-B60140
    DISPLAY BY NAME g_fbe.fbe152  #No:FUN-B60140

END FUNCTION
 
FUNCTION t110_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_fbe.fbe14)  THEN
       CALL cl_err(g_fbe.fbe14,'aap-619',1)
       RETURN
    END IF
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          IF cl_null(g_fbe.fbe142)  THEN
             CALL cl_err(g_fbe.fbe142,'aap-619',1)
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF
   #FUN-B90004---End---  

    CALL s_get_doc_no(g_fbe.fbe01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   #IF g_fah.fahglcr = 'N' THEN        #FUN-B90004 mark
   #   CALL cl_err('','aap-990',1)     #FUN-B90004 mark
    IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp) THEN    #FUN-B90004
       CALL cl_err('','aap-936',1)  #FUN-B90004
       RETURN
    END IF
   #FUN-B90004--Begin--
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp1) THEN
          CALL cl_err('','aap-936',1)
          RETURN
       END IF
    END IF
   #FUN-B90004---End---
    LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",  #FUN-A50102 
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                "  WHERE aba00 = '",g_faa.faa02b,"'",
                "    AND aba01 = '",g_fbe.fbe14,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_fbe.fbe14,'axr-071',1)
       RETURN
    END IF
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
          LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                      "  WHERE aba00 = '",g_faa.faa02c,"'",
                      "    AND aba01 = '",g_fbe.fbe142,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          PREPARE aba_pre23 FROM l_sql
          DECLARE aba_cs23 CURSOR FOR aba_pre23
          OPEN aba_cs23
          FETCH aba_cs23 INTO l_aba19
          IF l_aba19 = 'Y' THEN
             CALL cl_err(g_fbe.fbe142,'axr-071',1)
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF
    #-----No:FUN-B60140 END----- 
    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbe.fbe14,"' '4' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbe.fbe142,"' '4' 'Y'"
          CALL cl_cmdrun_wait(g_str)
       END IF #FUN-C30313 add
    END IF
    #-----No:FUN-B60140 END-----
    SELECT fbe14,fbe15,fbe142,fbe152  #No:FUN-B60140 
      INTO g_fbe.fbe14,g_fbe.fbe15,g_fbe.fbe142,g_fbe.fbe152  #No:FUN-B60140 
      FROM fbe_file
     WHERE fbe01 = g_fbe.fbe01
    DISPLAY BY NAME g_fbe.fbe14
    DISPLAY BY NAME g_fbe.fbe15
    DISPLAY BY NAME g_fbe.fbe142  #No:FUN-B60140
    DISPLAY BY NAME g_fbe.fbe152  #No:FUN-B60140
END FUNCTION
#No.FUN-9C0077 程式精簡
#-----NO:FUN-B90096 start--
FUNCTION t110_fin_audit2()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rec_b2   LIKE type_file.num5
   DEFINE l_fbf04    LIKE fbf_file.fbf04
   DEFINE l_fbf072   LIKE fbf_file.fbf072
   DEFINE l_fbf082   LIKE fbf_file.fbf082
   DEFINE l_fbf092   LIKE fbf_file.fbf092
   DEFINE l_fbf112   LIKE fbf_file.fbf112
   DEFINE l_dis      LIKE type_file.num20_6,
          l_faj142          LIKE faj_file.faj142,
          l_faj1412         LIKE faj_file.faj1412,
          l_faj17          LIKE faj_file.faj17,
          l_faj322          LIKE faj_file.faj322,
          l_faj602          LIKE faj_file.faj602,
          l_faj582          LIKE faj_file.faj582,
          l_faj592          LIKE faj_file.faj592,
          l_faj09          LIKE faj_file.faj09

    #FUN-C30140---add---str---
    IF g_fbe.fbe01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01
    IF g_fbe.fbeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbe.fbeconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbe.fbepost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF NOT cl_null(g_fbe.fbe18) AND g_fbe.fbe18 matches '[Ss]' THEN     
        CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
        RETURN
    END IF
    #FUN-C30140---add---end---

   OPEN WINDOW t1109_w2 WITH FORM "afa/42f/afat1109"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("afat1109")

   #FUN-BC0004--mark--str
   #LET g_sql =
   #    " SELECT fbf02,fbf03,fbf031,faj06,faj18,fbf04,fbf06,",
   #    "        fbf072,fbf082,fbf112,fbf092 ",
   #    " FROM fbf_file, OUTER faj_file ",
   #    " WHERE fbf03=faj02 AND fbf031=faj022 ",
   #    "    AND fbf01 ='",g_fbe.fbe01,"'",
   #    " ORDER BY fbf02"
   #FUN-BC0004--mark--end
   #FUN-BC0004--add--str
   LET g_sql =
        " SELECT fbf02,fbf03,fbf031,'','',fbf04,fbf06,",
        "        '',fbf072,fbf082,fbf112,fbf092 ",             #CHI-D10032 add ''
        " FROM fbf_file ",
        " WHERE fbf01 ='",g_fbe.fbe01,"'",
        " ORDER BY fbf02"
   #FUN-BC0004--add--end

   PREPARE afat110_2_pre FROM g_sql

   DECLARE afat110_2_c CURSOR FOR afat110_2_pre

   CALL g_fbf2.clear()

   LET l_cnt = 1

   FOREACH afat110_2_c INTO g_fbf2[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach fbf2',STATUS,0)
         EXIT FOREACH
      END IF

      SELECT faj06,faj18 INTO g_fbf2[l_cnt].faj06,g_fbf2[l_cnt].faj18 #FUN-BC0004 add faj18
        FROM faj_file
       WHERE faj02 = g_fbf2[l_cnt].fbf03
 
      LET l_cnt = l_cnt + 1

   END FOREACH

   CALL g_fbf2.deleteElement(l_cnt)

   LET l_rec_b2 = l_cnt - 1

   LET l_ac = 1

   CALL cl_set_act_visible("cancel", FALSE)

   IF g_fbe.fbeconf !="N" THEN #已確認或作廢單據只能查詢
      DISPLAY ARRAY g_fbf2 TO s_fbf2.* ATTRIBUTE(COUNT=l_rec_b2,UNBUFFERED)

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

      END DISPLAY
   ELSE
    LET g_forupd_sql = " SELECT fbf02,fbf03,fbf031,'','',fbf04,fbf06,",
                       "        '',fbf072,fbf082,fbf112,fbf092 ",                    #CHI-D10032 add ''
                       " FROM fbf_file ",
                       " WHERE fbf01 ='",g_fbe.fbe01,"'",
                       "   AND fbf02= ? ",
                       " FOR UPDATE "

      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE t110_2_bcl CURSOR FROM g_forupd_sql

      INPUT ARRAY g_fbf2 WITHOUT DEFAULTS FROM s_fbf2.*
            ATTRIBUTE(COUNT=l_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

         BEFORE INPUT
            IF l_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

         BEFORE ROW
            LET l_ac = ARR_CURR()
            BEGIN WORK
            IF l_rec_b2 >= l_ac THEN
               LET g_fbf2_t.* = g_fbf2[l_ac].*
               OPEN t110_2_bcl USING g_fbf2_t.fbf02
               IF STATUS THEN
                  CALL cl_err("OPEN t110_2_bcl:", STATUS, 1)
               ELSE
                  FETCH t110_2_bcl INTO g_fbf2[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fbf2_t.fbf02,SQLCA.sqlcode,1)
                  END IF
                  SELECT faj06,faj18 INTO g_fbf2[l_ac].faj06,g_fbf2[l_ac].faj18
                    FROM faj_file
                   WHERE faj02 = g_fbf2[l_ac].fbf03
                     AND faj022= g_fbf2[l_ac].fbf031                  
               END IF
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbf2[l_ac].* = g_fbf2_t.*
               CLOSE t110_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF



           #CHI-C60010---str---
            CALL cl_digcut(g_fbf2[l_ac].fbf072,g_azi04_1) RETURNING g_fbf2[l_ac].fbf072
            CALL cl_digcut(g_fbf2[l_ac].fbf082,g_azi04_1) RETURNING g_fbf2[l_ac].fbf082
            CALL cl_digcut(g_fbf2[l_ac].fbf092,g_azi04_1) RETURNING g_fbf2[l_ac].fbf092
            CALL cl_digcut(g_fbf2[l_ac].fbf112,g_azi04_1) RETURNING g_fbf2[l_ac].fbf112
           #CHI-C60010---end---
            UPDATE fbf_file SET fbf072 = g_fbf2[l_ac].fbf072,
                                fbf082 = g_fbf2[l_ac].fbf082,
                                fbf112 = g_fbf2[l_ac].fbf112,
                                fbf092 = g_fbf2[l_ac].fbf092
             WHERE fbf01 = g_fbe.fbe01
               AND fbf02 = g_fbf2_t.fbf02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","fbf_file",g_fbe.fbe01,g_fbf2_t.fbf02,SQLCA.sqlcode,"","",1)
               LET g_fbf2[l_ac].* = g_fbf2_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF

         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbf2[l_ac].* = g_fbf2_t.*
               CLOSE t110_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t110_2_bcl
            COMMIT WORK
        #FUN-BC0004--add-str
        BEFORE FIELD fbf072
           SELECT faj06,faj18 INTO g_fbf2[l_ac].faj06,g_fbf2[l_ac].faj18
             FROM faj_file
            WHERE faj02 = g_fbf2[l_ac].fbf03
               AND faj022= g_fbf2[l_ac].fbf031  
           DISPLAY BY NAME g_fbf2[l_ac].faj06
           DISPLAY BY NAME g_fbf2[l_ac].faj18
        #FUN-BC0004--add-end
        AFTER FIELD fbf072
          IF NOT cl_null(g_fbf2[l_ac].fbf072) THEN
             IF g_fbf2[l_ac].fbf072 < 0 THEN
                CALL cl_err('','mfg4012',0)
                NEXT FIELD fbf072
             END IF
            CALL cl_digcut(g_fbf2[l_ac].fbf072,g_azi04_1) RETURNING g_fbf2[l_ac].fbf072 #CHI-C60010 add
          END IF           

        AFTER FIELD fbf082
           IF g_fbf2[l_ac].fbf082<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbf082
           END IF
            CALL cl_digcut(g_fbf2[l_ac].fbf082,g_azi04_1) RETURNING g_fbf2[l_ac].fbf082  #CHI-C60010 add
           #出售損益=成本-出售金額
           SELECT faj142,faj1412,faj592,faj17,faj582,faj322,faj09,faj602
             INTO l_faj142,l_faj1412,l_faj592,l_faj17,l_faj582,l_faj322,l_faj09,l_faj602
             FROM faj_file
            WHERE faj02 = g_fbf2[l_ac].fbf03
              AND faj022= g_fbf2[l_ac].fbf031
              
           LET l_dis = ((l_faj322-l_faj602) / (l_faj17-l_faj582)) * g_fbf2[l_ac].fbf04
           IF cl_null(l_dis) THEN LET l_dis = 0 END IF
           IF l_faj09!='5' THEN
              LET l_fbf092=(l_faj142+l_faj1412-l_faj592)/(l_faj17-l_faj582)
                          * g_fbf2[l_ac].fbf04
           ELSE   #費用類計算時不抓本幣成本
              LET l_fbf092=(l_faj1412-l_faj592)/(l_faj17-l_faj582)
                          * g_fbf2[l_ac].fbf04
           END IF
           IF cl_null(l_fbf092) THEN LET l_fbf092 = 0 END IF 
           CALL cl_digcut(l_dis,g_azi04) RETURNING l_dis
           #CALL cl_digcut(l_fbf092,g_azi04) RETURNING l_fbf092  #CHI-C60010 mark
           CALL cl_digcut(l_fbf092,g_azi04_1) RETURNING l_fbf092   #CHI-C60010
           
           IF g_fbe.fbe073 = 'Y' THEN #是否含稅
              LET l_fbf072 = g_fbf2[l_ac].fbf072/(1+g_fbe.fbe071/100)
           ELSE
              LET l_fbf072 = g_fbf2[l_ac].fbf072
           END IF
           LET g_fbf2[l_ac].fbf092=l_fbf072+l_dis-l_fbf092

           IF cl_null(g_fbf2[l_ac].fbf112) THEN LET g_fbf2[l_ac].fbf112 = 0 END IF
           LET g_fbf2[l_ac].fbf092 = g_fbf2[l_ac].fbf092 + g_fbf2[l_ac].fbf112
           #LET g_fbf2[l_ac].fbf092 = cl_digcut(g_fbf2[l_ac].fbf092,g_azi04)#CHI-C60010 mark
           LET g_fbf2[l_ac].fbf092 = cl_digcut(g_fbf2[l_ac].fbf092,g_azi04_1)   #CHI-C60010

           LET g_fbf2[l_ac].fbf112=(g_fbf2[l_ac].fbf112/l_fbf04)*g_fbf2[l_ac].fbf04
           #LET g_fbf2[l_ac].fbf112=cl_digcut(g_fbf2[l_ac].fbf112,g_azi04)  #CHI-C60010 mark
           LET g_fbf2[l_ac].fbf112=cl_digcut(g_fbf2[l_ac].fbf112,g_azi04_1)   #CHI-C60010
           
           DISPLAY g_fbf2[l_ac].fbf092 TO fbf092
           DISPLAY g_fbf2[l_ac].fbf112 TO fbf112          

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION exit
            EXIT INPUT

      END INPUT

   END IF

   CLOSE WINDOW t1109_w2

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION
#-----NO:FUN-B90096 end---- 
#No.MOD-C30758 --begin
FUNCTION t110_undo_acct()
DEFINE l_n     LIKE type_file.num5
DEFINE l_oma01 LIKE oma_file.oma01
DEFINE l_oma33 LIKE oma_file.oma33
DEFINE l_oma51 LIKE oma_file.oma51
DEFINE l_oma57 LIKE oma_file.oma57
DEFINE l_omaconf LIKE oma_file.omaconf    #MOD-D10198 add

    SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01 = g_fbe.fbe01  #MOD-D10198 add
   #SELECT oma01,oma33,oma51,oma57 INTO l_oma01,l_oma33,l_oma51,l_oma57 FROM oma_file WHERE oma16 = g_fbe.fbe01                   #MOD-D10198 mark
    SELECT oma01,oma33,oma51,oma57,omaconf INTO l_oma01,l_oma33,l_oma51,l_oma57,l_omaconf FROM oma_file WHERE oma16 = g_fbe.fbe01 #MOD-D10198 add omaconf
    IF SQLCA.sqlcode = 100 THEN RETURN END IF
    IF cl_null(l_oma51) THEN LET l_oma51 =0 END IF
    IF cl_null(l_oma57) THEN LET l_oma57 =0 END IF
#MOD-D10198 add begin-------------------
    IF l_omaconf = 'Y' THEN
       CALL cl_err(g_fbe.fbe01,'cxr-325',0)
       RETURN
    END IF
#MOD-D10198 add end---------------------
    IF l_oma51 > 0 OR l_oma57 > 0 THEN
         CALL cl_err(l_oma01,'afa-206',1)
         RETURN
    ELSE
       DELETE FROM oma_file WHERE oma01 = l_oma01
       IF STATUS OR SQLCA.SQLERRD[3] = 0  THEN
          CALL cl_err3("del","oma_file","","",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
       DELETE FROM omb_file WHERE omb01 = l_oma01
       IF STATUS OR SQLCA.SQLERRD[3] = 0  THEN
          CALL cl_err3("del","omb_file","","",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
       DELETE FROM omc_file WHERE omc01 = l_oma01
       IF STATUS OR SQLCA.SQLERRD[3] = 0  THEN
          CALL cl_err3("del","omc_file","","",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
    END IF
    LET g_fbe.fbe11 =''
    UPDATE fbe_file SET fbe11 = g_fbe.fbe11 WHERE fbe01 = g_fbe.fbe01  #MOD-C60018
    DISPLAY BY NAME g_fbe.fbe11
END FUNCTION
#No.MOD-C30758 --end

