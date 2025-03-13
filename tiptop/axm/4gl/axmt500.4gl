# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmt500.4gl
# Descriptions...: INVOICE維護作業
# Date & Author..: 96/04/05 By Rofer
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 transaction 中
#                                         才會達到lock 的功能
# Modify.........: No:7898 03/08/27 Carol 若是三角貿易的INVOICE, 透過本支作業
#                                         維護完畢後, 按'4.包裝單'時,無法串到
#                                         三角貿易包裝單維護作業(axmt632)
#                                         --> modify MENU cmdrun
# Modify.........: No:7966 03/08/28 Carol for No:7898 改oga909 check
# Modify.........: No.7995 03/09/02 Kammy 加 show ofa99
# Modify.........: No.8797 03/12/04 ching 'X.作廢','Z.取消確認' 考慮是否有出貨單
# Modify.........: No.8606 03/10/30 Melody INVOICE若由出貨通知單產生時,INVOICE單
# Modify.........: No.MOD-480183 04/08/06 Wiky 列印 ON ACTION部份無法轉英文
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4A0065 04/10/08 By Carol Controlp add call q_ofa()
# Modify.........: No.MOD-4A0287 04/10/21 By Mandy 合計金額欄位部份都沒加總!
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0076 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-510101 05/01/14 By ching transaction 錯誤修改
# Modify.........: NO.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550018 05/05/09 By ice 發票號碼加大到16位
# Modify.........: No.FUN-540049 05/04/12 By Carrier 雙單位內容修改
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: No.MOD-570311 05/08/10 By Nicola 單身刪除時金額合計無重算
# Modify.........: No.MOD-590122 05/09/09 By Carrier set_origin_field修改
# Modify.........: No.MOD-590197 05/09/11 By kevin 常用說明編號預設空白
# Modify.........: No.MOD-570240 05/07/19 By Nicola 將t5003_w的ofa46移至主畫面
# Modify.........: No.MOD-590086 05/10/19 By Nicola 加入參數oaz67的控管
# Modify.........: No.TQC-5C0014 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: NO.TQC-630066 06/03/07 By Kevin 流程訊息通知功能修改
# Modify.........: NO.FUN-640251 06/04/25 BY yiting 針對 oaz67 的設定來改變 欄位說明
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-660003 06/06/01 By sam_lin 單身有值時, 應該不能變更單頭出通單號, 否則會造成單頭單身資料不一致
# Modify.........: NO.TQC-660088 06/06/21 By Claire 流程訊息通知功能修改
# Modify.........: No.FUN-660167 06/06/26 By wujie  cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690044 06/10/07 By rainy  拿掉BU間銷售
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.CHI-690069 06/12/04 By rainy 取消確認時，出貨單不可為"已轉應收"(oga10!=null)才可取消確認
# Modify.........: No.MOD-6C0004 06/12/06 By Claire 依出貨單/出通單參數設定,提示相關訊息
# Modify.........: No.MOD-690130 06/12/07 By Claire 新增時可輸入出通單號
# Modify.........: No.MOD-6A0084 06/12/07 By Claire g_buf在新增時都為null,故此段無作用  
# Modify.........: No.MOD-710074 07/01/31 By Claire 嘜頭串送貨客戶而非帳款客戶
# Modify.........: No.FUN-720014 07/03/02 By rainy 客戶地址擴充為5欄255
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
# Modify.........: No.TQC-740303 07/04/25 By Sarah 串報表axmr550,axmr552少傳參數
# Modify.........: NO.TQC-740339 07/04/27 BY yiting  AFTER FIELD ofa011之後，判斷參數抓取出貨單資料時
#                                                    漏抓了oga09 = '6'(代採出貨單)
# Modify.........: No.MOD-750012 07/05/03 By Claire 考慮不使用計價單位,否則更改數量(g_change='Y')重計時會取錯轉換率
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750126 07/05/23 By rainy 新增時,單頭欄位,出通單號和訂單單號,無法先用複製axmt610的出通單號,再貼在此欄位上
# Modify.........: No.MOD-770159 07/08/02 By Claire 需輸入已確認的出通(貨)單號,check方法同q_oga4的條件
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.MOD-7C0190 07/12/25 By Claire 多角貿易單據不可以取消確認避免不小心刪除造成單據各站無法對應
# Modify.........: No.MOD-7C0210 07/12/28 By Claire 取匯率時應考慮oea18參數設定
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-820097 08/02/20 By Claire 單價做手動調整時也需取位
# Modify.........: No.FUN-840042 08/04/11 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-850097 08/05/20 By Claire 輸入出通/貨單後確認是否為多角單據,若是匯率參數應參考oax01
# Modify.........: No.CHI-840050 08/05/29 by xiaofeizhu 若價格條件,收款條件無值,抓單身第一筆訂單資料給值!
# Modify.........: No.MOD-880227 08/08/29 By wujie  axmt500對于數量沒有管控，同一張出貨單，可以開多張Invoice，即使開立的Invoice數量已超過出貨單數量，程式也沒有管控。
# Modify.........: No.MOD-890024 08/09/02 By wujie  續MOD-880227，單身訂單項次帶出數量也要修改
# Modify.........: No.FUN-890098 08/09/23 By Smapmin 按下列印時,增加品名規格額外說明類別的輸入
# Modify.........: No.MOD-890228 08/09/24 By Smapmin 由出通單自動帶出時出現錯誤
# Modify.........: No.MOD-8A0160 08/10/17 By wujie   修正MOD-890024的錯誤
# Modify.........: No.MOD-8A0152 08/10/17 By liuxqa 取稅種時,若此稅種包含進銷存兩項,此時抓出來的值就會有兩筆,此時系統不知取哪一筆,導致報錯
# Modify.........: No.MOD-8A0195 08/10/24 By Smapmin 修改判斷料號是否存在的邏輯
# Modify.........: No.TQC-8B0030 08/11/13 By wujie   訂單出貨單帶出數據時漏了ofb917
# Modify.........: No.MOD-8C0153 08/12/16 By Smapmin 一張訂單對應多張出通/出貨單,在抓取出通/出貨數量時,要用SUM的方式
# Modify.........: No.MOD-8C0156 08/12/16 By Smapmin 單頭輸入出通/出貨單號,於抓取出通/出貨單數量時未依單號抓取.
# Modify.........: No.MOD-910164 09/01/15 By Smapmin 抓取已產生過invoice的數量,除了by訂單單號加項次外,還得加上出通或出貨單號
# Mosify.........: No.MOD-920291 09/02/24 By chenyu 只修改單身中的數量，金額不會重新算
# Modify.........: No.MOD-930198 09/03/27 By Smapmin 交運方式開放修改  
# Modify.........: No.MOD-960294 09/06/30 By Smapmin 增加維護ofa62
# Modify.........: No.MOD-970215 09/07/23 By lilingyu目前系統中金額=計價數量*單價,但是沒有減去已經開立invoice的數量
# Modify.........: No.MOD-970241 09/07/27 By lilingyu 單據審核后,點擊文件地址,收款條件、價格條件不可隨意更改
# Modify.........: No.CHI-970022 09/07/28 By Dido 計算未稅金額與含稅金額,應不用判斷料件是否為MISC料
# Modify.........: No.FUN-980010 09/08/24 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980205 09/08/24 By sherry 單頭幣別匯率欄位“匯率”輸入負值沒有控管       
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No:MOD-9B0028 09/11/05 By Smapmin 修正MOD-890024/MOD-970215
# Modify.........: No:MOD-9C0422 09/12/29 By Smapmin 修改金額計算方式
#                                                    增加含稅金額欄位
# Modify.........: No:FUN-9C0071 10/01/12 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A40038 10/04/07 by houlia  更改狀態下沒有更新default值  
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXM
# Modify.........: No:MOD-A40138 10/04/22 By Smapmin axm-128-->axm-246
# Modify.........: No:MOD-A80092 10/08/12 By Smapmin INVOICE等同於發票,故應該在開立INVOICE時,也同時update oga54
# Modify.........: No:MOD-A80226 10/08/31 By Smapmin 打完單身訂單項次,預設數量的地方有錯
# Modify.........: No:MOD-A90169 10/09/28 By Smapmin 修改單頭出貨單號,沒有重帶訂單單號等欄位
# Modify.........: No.FUN-AA0059 10/10/25 By chenying 料號開窗控管
# Modify.........: No:TQC-AB0259 10/11/29 By wangxin BUG修改
# Modify.........: No:CHI-AB0029 10/11/30 By Summer INVOICE,PACKING增加直式列印的選項
# Modify.........: No:MOD-AC0062 10/12/08 By lilingyu 1.審核時,增加控管如果數量為0,則不可以審核  2.user自行維護單身資料時,如果數量為0,則不可以存檔
# Modify.........: No:TQC-AC0119 10/12/10 By lilingyu 出貨單號不為空時,單身數量控管不正確
# Modify.........: No:MOD-B10142 11/01/19 By lilingyu  計算發票數量時,應加上出貨單號,因為一張訂單可能會分多次出貨;否則會抓出該訂單的所有開票的數量
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B60252 11/06/29 By suncx 取消審核BUG修正              
# Modify.........: No.MOD-B70010 11/07/01 By suncx 錄入時已有INVOICE單的出貨單開窗不需顯示
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.TQC-B80167 11/08/23 By guoch 查询时资料建立部门和资料建立者无法下条件
# Modify.........: No.FUN-B80006 11/09/13 By pauline 無訂單出貨也可輸入invoice
# Modify.........: No.MOD-B90239 11/09/27 By suncx 自動產生單身帶出參考數量和異動數量錯誤
# Modify.........: No.CHI-B90048 11/11/23 By Vampire INVOICE只能由出貨/出通單帶出,故拿掉axmt500中所有有關訂單帶出
# Modify.........: No.FUN-910088 11/11/24 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-C20068 12/02/13 By chenjing 對小數欄位取位的調整 
# Modify.........: No.MOD-C10018 12/02/16 By Elise 在AFTER FIELD ofa011增加 CALL t500 ofa0351(),CALL t500_ofa0451()
# Modify.........: No.TQC-C20183 12/02/17 By chenjing 對小數欄位取位的調整
# Modify.........: No.TQC-C40140 12/04/17 By zhuhao 無訂單出貨條件判斷
# Modify.........: No.CHI-C40017 12/05/08 By Sakura 無訂單出貨單身多筆時也需一併帶出
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:CHI-B50046 12/06/06 By Summer 於回寫oga27的同時,依據出貨單上的帳款編號回寫oma67
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/07/04 By nanbing CR改串GR
# Modify.........: No.MOD-C60193 12/07/19 By Vampire 判斷如果存在axrt210時不可取消確認(axr-039)
# Modify.........: No.TQC-C70185 12/07/26 By dongsz 更改時，關閉內外銷欄位
# Modify.........: No.FUN-C50136 12/09/13 By xianghui 相關查詢時判斷oaz96是否為Y，則run axmq274來顯示信息
# Modify.........: No.MOD-C80214 12/08/28 By SunLM  Invoice維護作業都是外銷,沒有內銷,故ofa08初始化為外銷
# Modify.........: No.FUN-C10048 12/09/21 By pauline 新增帳款客戶、送貨客戶地址4跟5
# Modify.........: No.FUN-C60023 12/09/21 By pauline 出貨通知單與出貨單的備註帶入Invoice的備註
# Modify.........: No:FUN-CB0014 12/11/12 By lixh1 增加資料清單
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No.CHI-C20027 12/12/07 By Lori 只要axrt300有存在,oga54就以axrt300資料為主,沒有axrt300的資料才用axmt500回寫
# Modify.........: No.FUN-C90100 12/12/07 By xianghui 增加ACTION INVOICE列印,串axmr558
# Modify.........: No.TQC-D10084 13/01/28 By xianghui 資料清單頁簽下隱藏一部分ACTION
# Modify.........: No.MOD-D10223 13/02/05 By jt_chen (1) CHI-C40017修改錯誤導致,出貨單沒有第一個項次,無法自動轉單身
#                                                    (2) 須達到FUN-C80006原無訂單可轉INVOICE的需求
# Modify.........: No:FUN-D20025 13/02/21 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:CHI-B60094 13/03/22 By Elise s_cusqry加傳參數
# Modify.........: No:FUN-C80055 13/04/09 By Sakura  調整ofa011的開窗，不論oaz67選哪一個，oga09條件都需加上無訂單出貨單(oga09=’3’)
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-DC0040 13/12/06 By SunLM 应该初始化INITIALIZE b_ofb.* TO NULL

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
    g_occ   RECORD LIKE occ_file.*,
    g_ola   RECORD LIKE ola_file.*,
    g_ofa   RECORD LIKE ofa_file.*,
    g_ofa_t RECORD LIKE ofa_file.*,
    g_ofa_o RECORD LIKE ofa_file.*,
    b_ofb   RECORD LIKE ofb_file.*,
    g_ofb           DYNAMIC ARRAY OF RECORD    #程式變數(Profram Variables)
                    ofb03     LIKE ofb_file.ofb03,
                    ofb31     LIKE ofb_file.ofb31,
                    ofb32     LIKE ofb_file.ofb32,
                    ofb04     LIKE ofb_file.ofb04,
                    ofb06     LIKE ofb_file.ofb06,
                    ima021    LIKE ima_file.ima021,
                    ofb05     LIKE ofb_file.ofb05,
                    ofb12     LIKE ofb_file.ofb12,
                    ofb913    LIKE ofb_file.ofb913,
                    ofb914    LIKE ofb_file.ofb914,
                    ofb915    LIKE ofb_file.ofb915,
                    ofb910    LIKE ofb_file.ofb910,
                    ofb911    LIKE ofb_file.ofb911,
                    ofb912    LIKE ofb_file.ofb912,
                    ofb916    LIKE ofb_file.ofb916,
                    ofb917    LIKE ofb_file.ofb917,
                    ofb13     LIKE ofb_file.ofb13,
                    ofb14     LIKE ofb_file.ofb14,
                    ofb14t    LIKE ofb_file.ofb14t,   #MOD-9C0422
                    ofb11     LIKE ofb_file.ofb11,
                    ofb33     LIKE ofb_file.ofb33, 
                           ofbud01 LIKE ofb_file.ofbud01,
                           ofbud02 LIKE ofb_file.ofbud02,
                           ofbud03 LIKE ofb_file.ofbud03,
                           ofbud04 LIKE ofb_file.ofbud04,
                           ofbud05 LIKE ofb_file.ofbud05,
                           ofbud06 LIKE ofb_file.ofbud06,
                           ofbud07 LIKE ofb_file.ofbud07,
                           ofbud08 LIKE ofb_file.ofbud08,
                           ofbud09 LIKE ofb_file.ofbud09,
                           ofbud10 LIKE ofb_file.ofbud10,
                           ofbud11 LIKE ofb_file.ofbud11,
                           ofbud12 LIKE ofb_file.ofbud12,
                           ofbud13 LIKE ofb_file.ofbud13,
                           ofbud14 LIKE ofb_file.ofbud14,
                           ofbud15 LIKE ofb_file.ofbud15
                    END RECORD,
    g_ofb_t         RECORD
                    ofb03     LIKE ofb_file.ofb03,
                    ofb31     LIKE ofb_file.ofb31,
                    ofb32     LIKE ofb_file.ofb32,
                    ofb04     LIKE ofb_file.ofb04,
                    ofb06     LIKE ofb_file.ofb06,
                    ima021    LIKE ima_file.ima021,
                    ofb05     LIKE ofb_file.ofb05,
                    ofb12     LIKE ofb_file.ofb12,
                    ofb913    LIKE ofb_file.ofb913,
                    ofb914    LIKE ofb_file.ofb914,
                    ofb915    LIKE ofb_file.ofb915,
                    ofb910    LIKE ofb_file.ofb910,
                    ofb911    LIKE ofb_file.ofb911,
                    ofb912    LIKE ofb_file.ofb912,
                    ofb916    LIKE ofb_file.ofb916,
                    ofb917    LIKE ofb_file.ofb917,
                    ofb13     LIKE ofb_file.ofb13,
                    ofb14     LIKE ofb_file.ofb14,
                    ofb14t    LIKE ofb_file.ofb14t,   #MOD-9C0422
                    ofb11     LIKE ofb_file.ofb11,
                    ofb33     LIKE ofb_file.ofb33, 
                           ofbud01 LIKE ofb_file.ofbud01,
                           ofbud02 LIKE ofb_file.ofbud02,
                           ofbud03 LIKE ofb_file.ofbud03,
                           ofbud04 LIKE ofb_file.ofbud04,
                           ofbud05 LIKE ofb_file.ofbud05,
                           ofbud06 LIKE ofb_file.ofbud06,
                           ofbud07 LIKE ofb_file.ofbud07,
                           ofbud08 LIKE ofb_file.ofbud08,
                           ofbud09 LIKE ofb_file.ofbud09,
                           ofbud10 LIKE ofb_file.ofbud10,
                           ofbud11 LIKE ofb_file.ofbud11,
                           ofbud12 LIKE ofb_file.ofbud12,
                           ofbud13 LIKE ofb_file.ofbud13,
                           ofbud14 LIKE ofb_file.ofbud14,
                           ofbud15 LIKE ofb_file.ofbud15
                    END RECORD,
    g_change        LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
    g_ima25         LIKE ima_file.ima25,
    g_ima31         LIKE ima_file.ima31,
    g_ima906        LIKE ima_file.ima906,
    g_ima907        LIKE ima_file.ima907,
    g_ima908        LIKE ima_file.ima908,
    g_sw            LIKE type_file.num5,        # No.FUN-680137 SMALLINT
    g_factor        LIKE img_file.img21,
    g_tot           LIKE img_file.img10,
    g_flag          LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
    g_oga909 LIKE   oga_file.oga909,     #No:7898,7966
    g_oga   RECORD LIKE oga_file.*,
    g_ogb   RECORD LIKE ogb_file.*,
    g_oea   RECORD LIKE oea_file.*,
    g_oeb   RECORD LIKE oeb_file.*,
    l_oap	RECORD LIKE oap_file.*,
     g_wc,g_wc2,g_sql   STRING,  #No.FUN-580092 HCN
    g_t1                LIKE oay_file.oayslip,           #No.FUN-550070        #No.FUN-680137 VARCHAR(5)
    g_buf,g_buf1    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(30)
    exT             LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql  STRING  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_argv1        LIKE oea_file.oea01      # No.FUN-680137  VARCHAR(16)    #No.TQC-630066
DEFINE   g_argv2        STRING        #No.TQC-630066
DEFINE   g_oea18_yn      LIKE type_file.chr1          #MOD-7C0210 add
#FUN-910088--add--start--
DEFINE   g_ofb05_t    LIKE ofb_file.ofb05,
         g_ofb910_t   LIKE ofb_file.ofb910,
         g_ofb913_t   LIKE ofb_file.ofb913,
         g_ofb916_t   LIKE ofb_file.ofb916
#FUN-910088--add--end--



#FUN-CB0014 --------------Begin------------
DEFINE   w    ui.Window      
DEFINE   f    ui.Form       
DEFINE   page om.DomNode 
DEFINE   g_action_flag  STRING
DEFINE   g_rec_b1       LIKE type_file.num10
DEFINE   l_ac1          LIKE type_file.num10
DEFINE   g_ofa_1    DYNAMIC ARRAY OF RECORD    #程式變數(Profram Variables)
                    ofa00_11      LIKE ofa_file.ofa00,
                    ofa08_11      LIKE ofa_file.ofa08,
                    ofa01_1       LIKE ofa_file.ofa01,
                    oaydesc_1     LIKE oay_file.oaydesc,
                    ofa02_1       LIKE ofa_file.ofa02,
                    ofa011_1      LIKE ofa_file.ofa011,
                    ofa16_1       LIKE ofa_file.ofa16,
                    ofa03_1       LIKE ofa_file.ofa03,
                    ofa032_1      LIKE ofa_file.ofa032,
                    ofa04_1       LIKE ofa_file.ofa04,
                    occ02_1       LIKE occ_file.occ02,
                    ofa10_1       LIKE ofa_file.ofa10,
                    ofa31_1       LIKE ofa_file.ofa31,
                    oah02_1       LIKE oah_file.oah02,
                    ofa32_1       LIKE ofa_file.ofa32,  
                    oag02_1       LIKE oag_file.oag02,
                    ofaconf_1     LIKE ofa_file.ofaconf
                    END RECORD
#FUN-CB0014 --------------End--------------
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
 
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)           #No.TQC-630066
   LET g_argv2=ARG_VAL(2)           #No.TQC-630066
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
 
   LET p_row = 1 LET p_col = 4
 
   OPEN WINDOW t500_w AT p_row,p_col WITH FORM "axm/42f/axmt500"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL t500_def_form()
   CALL t500_show0()       #NO.FUN-640251
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t500_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t500_a()
            END IF
         OTHERWISE               #TQC-660088
               CALL t500_q()     #TQC-660088
      END CASE
   END IF
 
   CALL t500()
 
   CLOSE WINDOW t500_w                    #結束畫面
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
 
END MAIN
 
FUNCTION t500()
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM ofa_file WHERE ofa01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t500_cl CURSOR FROM g_forupd_sql
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    CALL t500_menu()
 
END FUNCTION
 
FUNCTION t500_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_ofb.clear()
 
    IF cl_null(g_argv1) THEN #No.TQC-630066
    WHILE TRUE
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_ofa.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        ofa00,ofa08,ofa01,ofa02,ofa011,ofa16,
        ofa03,ofa032,ofa04,
        ofa44,ofa45,ofa46,     #No.MOD-570240
        ofa10,ofa61,ofa62,   #MOD-960294
        ofa23,ofa24,
        ofa21,ofa211,ofa212,ofa213,
        ofa31,ofa32,
        ofa99,ofaconf,
        ofa50,
        ofauser,ofagrup,ofamodu,ofadate,ofaoriu,ofaorig,  #TQC-B80167 add ofaoriu,ofaorig 
        ofaud01,ofaud02,ofaud03,ofaud04,ofaud05,
        ofaud06,ofaud07,ofaud08,ofaud09,ofaud10,
        ofaud11,ofaud12,ofaud13,ofaud14,ofaud15
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ofa01) #查詢單据
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ofa"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ofa01
                 NEXT FIELD ofa01
              WHEN INFIELD(ofa16)
                   CALL q_oea( TRUE,TRUE,g_ofa.ofa16,'','3')
                        RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofa16
                   NEXT FIELD ofa16
              WHEN INFIELD(ofa011)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oga"
                   IF g_oaz.oaz67 = '1'  THEN
                     #LET g_qryparam.where = " ( oga09='1' OR oga09='5') "              #FUN-C80055 mark
                      LET g_qryparam.where = " ( oga09='1' OR oga09='5' OR oga09='3') " #FUN-C80055 add
                   ELSE
                    #  LET g_qryparam.where = " ( oga09='2' OR oga09='4' OR oga09='8' OR oga09 = '6') "  #No.FUN-610079  #NO.TQC-740339  ##FUN-B80006 mark
                      LET g_qryparam.where = " ( oga09='2' OR oga09='4' OR oga09='8' OR oga09 = '6' OR oga09 = '3') "  #No.FUN-610079  #NO.TQC-740339  #FUN-B80006
                   END IF
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofa011
              WHEN INFIELD(ofa03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofa03
                   NEXT FIELD ofa03
              WHEN INFIELD(ofa04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofa04
                   NEXT FIELD ofa04
              WHEN INFIELD(ofa21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gec"
                   LET g_qryparam.arg1 = '2'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofa21
                   NEXT FIELD ofa21
              WHEN INFIELD(ofa23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azi"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofa23
                   NEXT FIELD ofa23
              WHEN INFIELD(ofa31)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oah"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofa31
                   NEXT FIELD ofa31
              WHEN INFIELD(ofa32)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofa32
                   NEXT FIELD ofa32
              WHEN INFIELD(ofa44)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ocf"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofa44
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
      IF INT_FLAG THEN RETURN END IF
 
      EXIT WHILE
 
    END WHILE
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ofauser', 'ofagrup')
 
    CONSTRUCT g_wc2 ON ofb03,ofb31,ofb32,ofb04,ofb06,ofb05,
                       ofb12,ofb913,ofb914,ofb915,ofb910,
                       ofb911,ofb912,ofb916,ofb917,
                       ofb13,ofb14,ofb14t,ofb11,ofb33,    #MOD-9C0422 add ofb14t
                       ofbud01,ofbud02,ofbud03,ofbud04,ofbud05,
                       ofbud06,ofbud07,ofbud08,ofbud09,ofbud10,
                       ofbud11,ofbud12,ofbud13,ofbud14,ofbud15
                  FROM s_ofb[1].ofb03, s_ofb[1].ofb31, s_ofb[1].ofb32,
                       s_ofb[1].ofb04, s_ofb[1].ofb06,
                       s_ofb[1].ofb05, s_ofb[1].ofb12,
                       s_ofb[1].ofb913,s_ofb[1].ofb914,
                       s_ofb[1].ofb915,s_ofb[1].ofb910,
                       s_ofb[1].ofb911,s_ofb[1].ofb912,
                       s_ofb[1].ofb916,s_ofb[1].ofb917,
                       s_ofb[1].ofb13, s_ofb[1].ofb14,s_ofb[1].ofb14t,   #MOD-9C0422 add ofb14t
                       s_ofb[1].ofb11, s_ofb[1].ofb33,
                       s_ofb[1].ofbud01,s_ofb[1].ofbud02,s_ofb[1].ofbud03,s_ofb[1].ofbud04,s_ofb[1].ofbud05,
                       s_ofb[1].ofbud06,s_ofb[1].ofbud07,s_ofb[1].ofbud08,s_ofb[1].ofbud09,s_ofb[1].ofbud10,
                       s_ofb[1].ofbud11,s_ofb[1].ofbud12,s_ofb[1].ofbud13,s_ofb[1].ofbud14,s_ofb[1].ofbud15
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(ofb31)
                   CALL q_oea(TRUE,TRUE,g_ofb[1].ofb31,g_ofa.ofa03,'3')
                        RETURNING g_ofb[1].ofb31
                   DISPLAY BY NAME g_ofb[1].ofb31
                   NEXT FIELD ofb31
              WHEN INFIELD(ofb04)
#FUN-AA0059---------mod------------str-----------------              
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_ima"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY g_qryparam.multiret TO ofb04
                   NEXT FIELD ofb04
              WHEN INFIELD(ofb913)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ofb[1].ofb913
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofb913
                   NEXT FIELD ofb913
              WHEN INFIELD(ofb910)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ofb[1].ofb910
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofb910
                   NEXT FIELD ofb910
              WHEN INFIELD(ofb916)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ofb[1].ofb916
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofb916
                   NEXT FIELD ofb916
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
 
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    ELSE
       LET g_wc =" ofa01 = '",g_argv1,"'"    
       LET g_wc2=" 1=1"
    END IF
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ofa01 FROM ofa_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ofa01 ",
                   "  FROM ofa_file, ofb_file",
                   " WHERE ofa01 = ofb01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t500_prepare FROM g_sql
    DECLARE t500_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t500_prepare
    DECLARE t500_fill_cs CURSOR WITH HOLD FOR t500_prepare     #FUN-CB0014
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ofa_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT ofa01) FROM ofa_file,ofb_file WHERE ",
                  "ofb01=ofa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t500_precount FROM g_sql
    DECLARE t500_count CURSOR FOR t500_precount
 
END FUNCTION
 
FUNCTION t500_menu()
DEFINE l_wc   LIKE type_file.chr1000     #No.TQC-610089 add        #No.FUN-680137  VARCHAR(200) 
DEFINE l_imc02 LIKE imc_file.imc02        #FUN-890098
 
   WHILE TRUE
   #  CALL t500_bp("G")     #FUN-CB0014
   #FUN-CB0014 --------Begin----------
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "main")
            CALL t500_bp("G")
         WHEN (g_action_flag = "info_list")
            CALL t500_list_fill()
            CALL t500_bp1("G")
            IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT ofa_file.* INTO g_ofa.* FROM ofa_file
                WHERE ofa01=g_ofa_1[l_ac1].ofa01_1
            END IF
            IF g_action_choice!= "" THEN
               LET g_action_flag = 'main'
               LET l_ac1 = ARR_CURR()
               LET g_jump = l_ac1
               LET mi_no_ask = TRUE
               IF g_rec_b1 >0 THEN
                   CALL t500_fetch('/')
               END IF
               CALL cl_set_comp_visible("page1", FALSE)
               CALL cl_set_comp_visible("page2", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               CALL cl_set_comp_visible("page2", TRUE)
             END IF
      END CASE
   #FUN-CB0014 --------End----------
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t500_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t500_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t500_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t500_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t500_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF NOT cl_null(g_ofa.ofa01) AND cl_chk_act_auth() THEN
               MENU "" ATTRIBUTE(STYLE="popup")
                  ON ACTION invoice_r550 #CHI-AB0029 mod invoice->invoice_r550
                     WHILE TRUE
                       CALL cl_getmsg('axm-505',g_lang) RETURNING g_msg
                       LET INT_FLAG = 0  
                       PROMPT g_msg CLIPPED FOR l_imc02
 
                          ON IDLE g_idle_seconds
                             CALL cl_on_idle()
                          ON ACTION about         
                             CALL cl_about()      
                          ON ACTION help          
                             CALL cl_show_help()  
                          ON ACTION controlg      
                             CALL cl_cmdask()     
 
                       END PROMPT
                       EXIT WHILE
                     END WHILE
                     LET l_wc='ofa01="',g_ofa.ofa01,'"'
                    # LET g_msg = "axmr550", #FUN-C30085 mark
                     LET g_msg = "axmg550", #FUN-C30085 add 
                                  " '",g_today CLIPPED,"' ''",
                                  " '",g_lang CLIPPED,"' 'Y' '' '1'",
                                  " '",l_wc CLIPPED,"' "
                                 ," '",l_imc02 CLIPPED,"' 'Y' 'Y'"   #TQC-740303 add   #FUN-890098
                     CALL cl_cmdrun(g_msg)
 
                  #CHI-AB0029 add --start--------------------
                  ON ACTION invoice_r551
                     LET l_wc='ofa01="',g_ofa.ofa01,'"'
                    # LET g_msg = "axmr551",  #FUN-C30085 mark
                     LET g_msg = "axmg551",   #FUN-C30085 add
                                 " '",g_today CLIPPED,"' ''",
                                 " '",g_lang CLIPPED,"' 'Y' '' '1'",
                                 " '",l_wc CLIPPED,"' ",
                                 " 'Y' 'Y' 'Y' 'N'"
                     CALL cl_cmdrun(g_msg)
                  #CHI-AB0029 add --end----------------------

                  ON ACTION packing_list_r552 #CHI-AB0029 mod packing_list->packing_list_r552
                     WHILE TRUE
                       CALL cl_getmsg('axm-505',g_lang) RETURNING g_msg
                       LET INT_FLAG = 0  
                       PROMPT g_msg CLIPPED FOR l_imc02
 
                          ON IDLE g_idle_seconds
                             CALL cl_on_idle()
                          ON ACTION about         
                             CALL cl_about()      
                          ON ACTION help          
                             CALL cl_show_help()  
                          ON ACTION controlg      
                             CALL cl_cmdask()     
 
                       END PROMPT
                       EXIT WHILE
                     END WHILE
                     LET l_wc='ofa01="',g_ofa.ofa01,'"'
                    # LET g_msg = "axmr552",  #FUN-C30085 mark
                     LET g_msg = "axmg552",   #FUN-C30085 add
                                  " '",g_today CLIPPED,"' ''",
                                  " '",g_lang CLIPPED,"' 'Y' '' '1'",
                                  " '",l_wc CLIPPED,"' "
                                 ," '",l_imc02 CLIPPED,"' '1' 'N' 'Y' 'Y'"   #TQC-740303 add   #FUN-890098
                     CALL cl_cmdrun(g_msg)

                  #CHI-AB0029 add --start--------------------
                  ON ACTION packing_list_r553
                     LET l_wc='ofa01="',g_ofa.ofa01,'"'
                   #  LET g_msg = "axmr553",  #FUN-C30085 mark
                     LET g_msg = "axmg553",   #FUN-C30085 add
                                  " '",g_today CLIPPED,"' ''",
                                  " '",g_lang CLIPPED,"' 'Y' '' '1'",
                                  " '",l_wc CLIPPED,"' ",
                                  " 'N' 'Y' 'Y' 'N'"
                     CALL cl_cmdrun(g_msg)
                  #CHI-AB0029 add --end----------------------

               END MENU
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "address"
            CALL t500_1()
         WHEN "prtg_condition"
            CALL t500_2()
         WHEN "maintain_mark"
            LET g_msg='axmi230 ',g_ofa.ofa04,' ',g_ofa.ofa44   #MOD-710074
            CALL cl_cmdrun(g_msg)
         WHEN "packing_list"
            IF g_oga909 = 'N' THEN
               LET g_msg="axmt630 '",g_ofa.ofa011,"'"
            ELSE
               LET g_msg="axmt632 '",g_ofa.ofa011,"'"
            END IF
            CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
         WHEN "order_query"
            CALL s_ordqry(g_ofa.ofa16)
         WHEN "query_customer"
      #    IF g_oaz.oaz96 = 'Y' THEN                         #FUN-C50136
      #       LET g_msg = 'axmq274 ',g_ofa.ofa03             #FUN-C50136
      #       CALL cl_cmdrun(g_msg)                          #FUN-C50136
      #    ELSE                                              #FUN-C50136
             CALL s_cusqry(g_ofa.ofa03,'')  #CHI-B60094 add ''
      #    END IF                                            #FUN-C50136
         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t500_m()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t500_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t500_z()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t500_x()
               CALL t500_x(1)   #FUN-D20025
            END IF
         #FUN-D20025--add--str--
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t500_x(2)
            END IF
         #FUN-D20025--add--end--
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
            #  CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ofb),'','')  #FUN-CB0014 mark
         #FUN-CB0014 --------Begin----------
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE g_action_flag
                  WHEN 'main'
                     LET page = f.FindNode("Page","page1")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_ofb),'','')
                  WHEN 'info_list'
                     LET page = f.FindNode("Page","page2")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_ofa_1),'','')
               END CASE
               LET g_action_choice = NULL
         #FUN-CB0014 --------End-----------
            END IF

         #FUN-C90100--add--str---
         WHEN "invoice_558"
            LET l_wc='ofa01="',g_ofa.ofa01,'"'
            LET g_msg = "axmr558",
                        " '",g_today CLIPPED,"' ''",
                        " '",g_lang CLIPPED,"' 'Y' '' '1'",
                        " '",l_wc CLIPPED,"' "
            CALL cl_cmdrun(g_msg)
         #FUN-C90100--add--end--- 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ofa.ofa01 IS NOT NULL THEN
                 LET g_doc.column1 = "ofa01"
                 LET g_doc.value1 = g_ofa.ofa01
                 CALL cl_doc()
               END IF
         END IF
 
         OTHERWISE
            EXIT CASE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t500_a()
DEFINE li_result LIKE type_file.num5                #No.FUN-550070        #No.FUN-680137 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_ofb.clear()
    INITIALIZE g_ofa.* TO NULL
 
    LET g_ofa_o.* = g_ofa.*
    LET g_ofa_t.* = g_ofa.*                #保存單頭舊值  #FUN-B50026 add
    CALL cl_opmsg('a')
 
    WHILE TRUE
        LET g_ofa.ofa00  ='1'
        LET g_ofa.ofa08  ='2' #MOD-C80214 "1"--->"2"        
        #LET g_ofa.ofa08  ='1' #MOD-C80214
        LET g_ofa.ofa02  =g_today
        LET g_ofa.ofa211 =0
        LET g_ofa.ofa50  =0
        LET g_ofa.ofa71  ='1'
        LET g_ofa.ofa72  ='N'
        LET g_ofa.ofa73  ='N'
        LET g_ofa.ofa75  ='1'
        LET g_ofa.ofaconf='N'
        LET g_ofa.ofaprsw=0
        LET g_ofa.ofauser=g_user
        LET g_ofa.ofaoriu = g_user #FUN-980030
        LET g_ofa.ofaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_ofa.ofagrup=g_grup
        LET g_ofa.ofadate=g_today
 
        LET g_ofa.ofaplant = g_plant
        LET g_ofa.ofalegal = g_legal 
 
        CALL t500_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_ofa.* TO NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
 
        IF g_ofa.ofa01 IS NULL THEN CONTINUE WHILE END IF
 
        BEGIN WORK            #No:7829
#       CALL s_auto_assign_no(g_sys,g_ofa.ofa01,g_ofa.ofa02,"55","ofa_file","ofa01","","","")
        CALL s_auto_assign_no("axm",g_ofa.ofa01,g_ofa.ofa02,"55","ofa_file","ofa01","","","")   #No.FUN-A40041
          RETURNING li_result,g_ofa.ofa01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_ofa.ofa01
 
        CALL t500_ofa0351()
        CALL t500_ofa0451()
        INSERT INTO ofa_file VALUES (g_ofa.*)
        IF STATUS OR SQLCA.SQLCODE THEN
           CALL cl_err3("ins","ofa_file",g_ofa.ofa01,"",SQLCA.SQLCODE,"","",1)  #No.FUN-660167
           ROLLBACK WORK      #No:7829
           CONTINUE WHILE
        END IF

       #FUN-C60023 add START
        CALL t500_ins_oao(g_ofa.ofa011)

        IF g_success = 'N' THEN
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
       #FUN-C60023 add END
 
        COMMIT WORK           #No:7829
        CALL cl_flow_notify(g_ofa.ofa01,'I')
 
        SELECT ofa01 INTO g_ofa.ofa01 FROM ofa_file WHERE ofa01 = g_ofa.ofa01
 
        LET g_ofa_t.* = g_ofa.*
        CALL g_ofb.clear()
        LET g_rec_b = 0
 
        CALL t500_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t500_ofa0351()
        IF g_ofa.ofa0351 IS NULL THEN
           INITIALIZE g_occ.* TO NULL
           SELECT * INTO g_occ.* FROM occ_file WHERE occ01=g_ofa.ofa03
           LET g_ofa.ofa0351=g_occ.occ18
           LET g_ofa.ofa0352=g_occ.occ19
           LET g_ofa.ofa0353=g_occ.occ231
           LET g_ofa.ofa0354=g_occ.occ232
           LET g_ofa.ofa0355=g_occ.occ233
           LET g_ofa.ofa0356=g_occ.occ234    #FUN-C10048 add
           LET g_ofa.ofa0357=g_occ.occ235    #FUN-C10048 add
        END IF
END FUNCTION
 
FUNCTION t500_ofa0451()
        IF g_ofa.ofa0451 IS NULL THEN
           INITIALIZE g_occ.* TO NULL
           SELECT * INTO g_occ.* FROM occ_file WHERE occ01=g_ofa.ofa04
           CALL s_addr(g_ofa.ofa011,g_ofa.ofa04,g_ofa.ofa044)
                RETURNING l_oap.oap041,l_oap.oap042,l_oap.oap043,l_oap.oap044,l_oap.oap045   #FUN-720014 add oap044/045
           LET g_ofa.ofa0451=g_occ.occ18
           LET g_ofa.ofa0452=g_occ.occ19
           LET g_ofa.ofa0453=l_oap.oap041
           LET g_ofa.ofa0454=l_oap.oap042
           LET g_ofa.ofa0455=l_oap.oap043
           LET g_ofa.ofa0456=l_oap.oap044    #FUN-C10048 add
           LET g_ofa.ofa0457=l_oap.oap045    #FUN-C10048 add
        END IF
END FUNCTION
 
FUNCTION t500_g_b()                 	#由出貨通知單/訂單自動產生單身
   SELECT COUNT(*) INTO g_cnt FROM ofb_file WHERE ofb01=g_ofa.ofa01
   IF g_cnt = 0 THEN
      IF NOT cl_null(g_ofa.ofa011) THEN CALL t500_g_b1() END IF
   END IF
   #CHI-B90048 ----- mark -----
   #SELECT COUNT(*) INTO g_cnt FROM ofb_file WHERE ofb01=g_ofa.ofa01
   #IF g_cnt = 0 THEN
   #   IF NOT cl_null(g_ofa.ofa16) THEN CALL t500_g_b2() END IF
   #END IF
   #CHI-B90048 ----- mark -----
   CALL t500_b_fill(' 1=1')
END FUNCTION
 
FUNCTION t500_g_b1()                 	#由出貨通知單產生單身
DEFINE l_ofb12     LIKE ofb_file.ofb12                                          
DEFINE l_ofb14     LIKE ofb_file.ofb14                                          
DEFINE l_ofb14t    LIKE ofb_file.ofb14t                                         
DEFINE l_ofb912    LIKE ofb_file.ofb912                                         
DEFINE l_ofb915    LIKE ofb_file.ofb915                                         
DEFINE l_ogb12     LIKE ogb_file.ogb12                                          
DEFINE l_ogb14     LIKE ogb_file.ogb14                                          
DEFINE l_ogb14t    LIKE ogb_file.ogb14t                                         
DEFINE l_ogb912    LIKE ogb_file.ogb912                                         
DEFINE l_ogb915    LIKE ogb_file.ogb915                                         
DEFINE l_ofb917    LIKE ofb_file.ofb917
DEFINE l_ogb917    LIKE ogb_file.ogb917
DEFINE l_ofb12_2   LIKE ofb_file.ofb12
DEFINE l_ofb14_2   LIKE ofb_file.ofb14
DEFINE l_ofb14t_2  LIKE ofb_file.ofb14t
DEFINE l_ofb912_2  LIKE ofb_file.ofb912
DEFINE l_ofb915_2  LIKE ofb_file.ofb915
DEFINE l_ofb917_2  LIKE ofb_file.ofb917
#DEFINE i           LIKE type_file.num5 #CHI-C40017 add   #MOD-D10223 mark
 
  IF g_oaz.oaz67 = '1'  THEN   
   IF NOT cl_confirm('axm-295') THEN RETURN END IF
  ELSE 
   IF NOT cl_confirm('axm-395') THEN RETURN END IF
  END IF 
   IF STATUS THEN CALL cl_err('upd ofa011',STATUS,1) LET g_success='N' END IF
   DECLARE t500_g_b_c1 CURSOR FOR
     SELECT * FROM ogb_file WHERE ogb01=g_ofa.ofa011 
    #MOD-D10223 mark start -----
    #SELECT max(ofb03)+1 INTO i FROM ofb_file WHERE ofb01 = g_ofa.ofa01 #CHI-C40017 add
    #IF cl_null(i) THEN LET i = 1 END IF #CHI-C40017 add
    #MOD-D10223 mark end   -----
   FOREACH t500_g_b_c1 INTO g_ogb.*
     IF STATUS THEN EXIT FOREACH END IF
     INITIALIZE b_ofb.* TO NULL
     LET b_ofb.ofb01 = g_ofa.ofa01
     LET b_ofb.ofb03 = g_ogb.ogb03
     LET b_ofb.ofb31 = g_ogb.ogb31
     LET b_ofb.ofb32 = g_ogb.ogb32
     LET b_ofb.ofb04 = g_ogb.ogb04
     LET b_ofb.ofb05 = g_ogb.ogb05
     LET b_ofb.ofb06 = g_ogb.ogb06
     LET b_ofb.ofb11 = g_ogb.ogb11
     LET b_ofb.ofb13 = g_ogb.ogb13
     IF g_oaz.oaz67 = '1'  THEN
       #MOD-D10223 mark start -----
       #SELECT SUM(ofb12),SUM(ofb14),SUM(ofb14t),SUM(ofb912),SUM(ofb915),SUM(ofb917)    
       #  INTO l_ofb12,l_ofb14,l_ofb14t,l_ofb912,l_ofb915,l_ofb917                      
       #  FROM ofb_file,ofa_file,oga_file
       # WHERE ofb31 =g_ogb.ogb31
       #   AND ofb32 =g_ogb.ogb32
       #   AND ofb01 =ofa01
       #   AND ofaconf !='X'
       #   AND (oga09 = '1' OR oga09 = '5')
       #   AND oga01 =g_ofa.ofa011   
       #   AND oga01 =ofa011
       #MOD-D10223 mark end    -----
       #MOD-D10223 add start -----
        LET g_sql = "SELECT SUM(ofb12),SUM(ofb14),SUM(ofb14t),SUM(ofb912),SUM(ofb915),SUM(ofb917) ",
                    "  FROM ofb_file,ofa_file,oga_file ",
                    " WHERE ofb01 =ofa01 ",
                    "   AND ofaconf !='X' ",
                   #"   AND (oga09 = '1' OR oga09 = '5') ",                #FUN-C80055 mark
                    "   AND (oga09 = '1' OR oga09 = '5' OR oga09 = '3') ", #FUN-C80055 add
                    "   AND oga01 = '", g_ofa.ofa011 ,"' ",
                    "   AND oga01 =ofa011 "

        IF NOT cl_null(g_ogb.ogb31) AND NOT cl_null(g_ogb.ogb32) THEN
           LET g_sql = g_sql, " AND ogb31 = '", g_ogb.ogb31 ,"' AND ogb32 = '", g_ogb.ogb32 ,"'"
        END IF
       #MOD-D10223 add end   -----
     ELSE
      #MOD-D10223 mark start -----
      # SELECT SUM(ofb12),SUM(ofb14),SUM(ofb14t),SUM(ofb912),SUM(ofb915),SUM(ofb917)    
      #   INTO l_ofb12,l_ofb14,l_ofb14t,l_ofb912,l_ofb915,l_ofb917                      
      #   FROM ofb_file,ofa_file,oga_file
      ##TQC-C40140 -- mark -- begin
      ## WHERE ofb31 =g_ogb.ogb31
      ##   AND ofb32 =g_ogb.ogb32
      ##   AND ofb01 =ofa01
      ##   AND ofaconf !='X'
      ## #  AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')  #FUN-B80006   mark
      ##   AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6' OR oga09 = '3') #FUN-B80006  
      ##TQC-C40140 -- mark -- end
      ##TQC-C40140 -- add -- begin
      #  WHERE ofb01 =ofa01
      #    AND ofaconf !='X'
      #    AND (((oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6') 
      #         AND ofb31 =g_ogb.ogb31 AND ofb32 =g_ogb.ogb32) OR oga09 = '3')
      ##TQC-C40140 -- add -- end
      #    AND oga01 =g_ofa.ofa011  
      #    AND oga01 =ofa011
      #    AND ofb03 = i #CHI-C40017 add
      #MOD-D10223 mark end   -----
      #MOD-D10223 add start -----
        LET g_sql = "SELECT SUM(ofb12),SUM(ofb14),SUM(ofb14t),SUM(ofb912),SUM(ofb915),SUM(ofb917) ",
                    "  FROM ofb_file,ofa_file,oga_file ",
                    " WHERE ofb01 = ofa01  ",
                    "   AND oga01 = ofa011 ",
                    "   AND oga01 = ogb01 ",
                    "   AND ofaconf !='X'  ",
                    "   AND oga01 = '", g_ofa.ofa011 ,"' ",
                    "   AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4' OR oga09='8' OR oga09 = '6') ",
                    "   AND ofb03 = '", g_ogb.ogb03 ,"' "
      #MOD-D10223 add end   -----
     END IF

     #MOD-D10223 add start -----
     DECLARE t500_g_b1_cl_1 CURSOR FROM g_sql
     OPEN t500_g_b1_cl_1
     FETCH t500_g_b1_cl_1 INTO l_ofb12,l_ofb14,l_ofb14t,l_ofb912,l_ofb915,l_ofb917
     #MOD-D10223 add end   -----

     IF cl_null(l_ofb12) THEN                                                   
        LET l_ofb12 =0                                                          
     END IF                                                                     
     IF cl_null(l_ofb14) THEN                                                   
        LET l_ofb14 =0                                                          
     END IF                                                                     
     IF cl_null(l_ofb14t) THEN                                                  
        LET l_ofb14t=0                                                          
     END IF                                                                     
#MOD-B90239 mod begin--------------------
#    IF cl_null(l_ogb912) THEN
#       LET l_ofb912 =0
#    END IF
#    IF cl_null(l_ogb915) THEN
#       LET l_ofb915 =0
#    END IF
     IF cl_null(l_ofb912) THEN
        LET l_ofb912 =0
     END IF
     IF cl_null(l_ofb915) THEN
        LET l_ofb915 =0
     END IF
#MOD-B90239 mod end---------------------
     IF cl_null(l_ofb917) THEN
        LET l_ofb917 =0
     END IF
    #MOD-D10223 mark start -----
    #SELECT SUM(ofb12),SUM(ofb14),SUM(ofb14t),SUM(ofb912),SUM(ofb915),SUM(ofb917)    
    #  INTO l_ofb12_2,l_ofb14_2,l_ofb14t_2,l_ofb912_2,l_ofb915_2,l_ofb917_2                 
    #  FROM ofb_file,ofa_file 
    # WHERE ofb31 =g_ogb.ogb31 
    #   AND ofb32 =g_ogb.ogb32
    #   AND ofb01 =ofa01
    #   AND ofaconf !='X'
    #   AND ofa011 IS NULL
    #MOD-D10223 mark end   -----
    #MOD-D10223 add start -----
     IF NOT cl_null(g_ogb.ogb31) AND NOT cl_null(g_ogb.ogb32) THEN
        LET g_sql = " SELECT SUM(ofb12),SUM(ofb14),SUM(ofb14t),SUM(ofb912),SUM(ofb915),SUM(ofb917) ",
                    "   FROM ofb_file,ofa_file ",
                    "  WHERE ofb01 = ofa01 ",
                    "    AND ofaconf !='X' ",
                    "    AND ofa011 IS NULL ",
                    " AND ofb31 = '", g_ogb.ogb31 ,"' AND ofb32 = '", g_ogb.ogb32 ,"'"

        DECLARE t500_g_b1_cl_2 CURSOR FROM g_sql
        OPEN t500_g_b1_cl_2
        FETCH t500_g_b1_cl_2 INTO l_ofb12_2,l_ofb14_2,l_ofb14t_2,l_ofb912_2,l_ofb915_2,l_ofb917_2
     END IF
    #MOD-D10223 add end   -----
     IF cl_null(l_ofb12_2) THEN
        LET l_ofb12_2 =0
     END IF
     IF cl_null(l_ofb14_2) THEN
        LET l_ofb14_2 =0
     END IF
     IF cl_null(l_ofb14t_2) THEN
        LET l_ofb14t_2=0
     END IF
     IF cl_null(l_ofb912_2) THEN
        LET l_ofb912_2 =0
     END IF
     IF cl_null(l_ofb915_2) THEN
        LET l_ofb915_2 =0
     END IF
     IF cl_null(l_ofb917_2) THEN
        LET l_ofb917_2 =0
     END IF
     LET l_ofb12  = l_ofb12  + l_ofb12_2
     LET l_ofb14  = l_ofb14  + l_ofb14_2
     LET l_ofb14t = l_ofb14t + l_ofb14t_2
     LET l_ofb912 = l_ofb912 + l_ofb912_2
     LET l_ofb915 = l_ofb915 + l_ofb915_2
     LET l_ofb917 = l_ofb917 + l_ofb917_2
     IF g_oaz.oaz67 = '1'  THEN                                                 
       #MOD-D10223 mark start -----
       #SELECT SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(ogb912),SUM(ogb915),SUM(ogb917)    #No.MOD-890024
       #  INTO l_ogb12,l_ogb14,l_ogb14t,l_ogb912,l_ogb915,l_ogb917                       #No.MOD-890024
       #  FROM oga_file,ogb_file                                                
       # WHERE oga01 = ogb01                                                    
       #   AND (oga09 = '1' OR oga09 = '5')                                     
       #   AND ogb31 =g_ogb.ogb31                                               
       #   AND ogb32 =g_ogb.ogb32                                               
       #   AND oga01 =g_ofa.ofa011   #MOD-8C0156
       #MOD-D10223 mark end   -----
       #MOD-D10223 add start -----
        LET g_sql = "SELECT SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(ogb912),SUM(ogb915),SUM(ogb917) ",
                    "  FROM oga_file,ogb_file ",
                    " WHERE oga01 = ogb01 ",
                    "   AND oga01 = '", g_ofa.ofa011 ,"' ",
                   #"   AND (oga09 = '1' OR oga09 = '5') ",                #FUN-C80055 mark
                    "   AND (oga09 = '1' OR oga09 = '5' OR oga09 = '3') ", #FUN-C80055 add
                    "   AND ogb03 = '", g_ogb.ogb03 ,"' "

        DECLARE t500_g_b1_cl_3 CURSOR FROM g_sql
        OPEN t500_g_b1_cl_3
        FETCH t500_g_b1_cl_3 INTO l_ogb12,l_ogb14,l_ogb14t,l_ogb912,l_ogb915,l_ogb917
       #MOD-D10223 add end   -----
        IF cl_null(l_ogb12) THEN                                                
           LET l_ogb12 =0                                                       
        END IF                                                                  
        IF cl_null(l_ogb14) THEN                                                
           LET l_ogb14 =0                                                       
        END IF                                                                  
        IF cl_null(l_ogb14t) THEN                                               
           LET l_ogb14t =0                                                      
        END IF                                                                  
        IF cl_null(l_ogb912) THEN                                               
           LET l_ogb912 =0                                                      
        END IF                                                                  
        IF cl_null(l_ogb915) THEN                                               
           LET l_ogb915 =0                                                      
        END IF   
        IF cl_null(l_ogb917) THEN
           LET l_ogb917 =0
        END IF
        IF l_ofb12 <l_ogb12 THEN                                                
           LET b_ofb.ofb12 =l_ogb12 -l_ofb12                                    
           LET b_ofb.ofb14 =l_ogb14 -l_ofb14                                    
           LET b_ofb.ofb14t=l_ogb14t-l_ofb14t                                   
           LET b_ofb.ofb912 =l_ogb912 -l_ofb912                                 
           LET b_ofb.ofb915 =l_ogb915 -l_ofb915                                 
           LET b_ofb.ofb917 =l_ogb917 -l_ofb917       #No.TQC-8B0030            
        ELSE                                                                    
           CONTINUE FOREACH                                                     
        END IF                                                                  
     ELSE                                                                       
       #MOD-D10223 mark start -----
       #SELECT SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(ogb912),SUM(ogb915),SUM(ogb917)   #No.MOD-890024
       #  INTO l_ogb12,l_ogb14,l_ogb14t,l_ogb912,l_ogb915,l_ogb917                      #No.MOD-890024
       #  FROM oga_file,ogb_file                                                
       # WHERE oga01 = ogb01                                                    
       # #  AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')  #FUN-B80006  mark       
       # #TQC-C40140 -- mark -- begin
       # # AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6' OR oga09 = '3' )  #FUN-B80006  
       # # AND ogb31 =g_ogb.ogb31                                               
       # # AND ogb32 =g_ogb.ogb32                                               
       # #TQC-C40140 -- mark -- end
       # #TQC-C40140 -- add -- begin
       #   AND (((oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')
       #         AND ogb31 =g_ogb.ogb31 AND ogb32 =g_ogb.ogb32) OR oga09 = '3')
       # #TQC-C40140 -- add -- end
       #   AND oga01 =g_ofa.ofa011   #MOD-8C0156
       #   AND ogb03 = i #CHI-C40017 add
       #MOD-D10223 mark end   -----
       #MOD-D10223 add start -----
        LET g_sql = " SELECT SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(ogb912),SUM(ogb915),SUM(ogb917) ",
                    "   FROM oga_file,ogb_file ",
                    "  WHERE oga01 = ogb01 ",
                    "    AND oga01 = '", g_ofa.ofa011 ,"' ",
                    "    AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4' OR oga09='8' OR oga09 = '6') ",
                    "    AND ogb03 = '", g_ogb.ogb03 ,"' "

        DECLARE t500_g_b1_cl_4 CURSOR FROM g_sql
        OPEN t500_g_b1_cl_4
        FETCH t500_g_b1_cl_4 INTO l_ogb12,l_ogb14,l_ogb14t,l_ogb912,l_ogb915,l_ogb917
       #MOD-D10223 add end   -----
        IF cl_null(l_ogb12) THEN                                                
           LET l_ogb12 =0                                                       
        END IF                                                                  
        IF cl_null(l_ogb14) THEN                                                
           LET l_ogb14 =0                                                       
        END IF  
        IF cl_null(l_ogb14t) THEN                                               
           LET l_ogb14t =0                                                      
        END IF                                                                  
        IF cl_null(l_ogb912) THEN                                               
           LET l_ogb912 =0                                                      
        END IF                                                                  
        IF cl_null(l_ogb915) THEN                                               
           LET l_ogb915 =0                                                      
        END IF                                                                  
        IF cl_null(l_ogb917) THEN
           LET l_ogb917 =0
        END IF
        IF l_ofb12 <l_ogb12 THEN                                                
           LET b_ofb.ofb12 =l_ogb12 -l_ofb12                                    
           LET b_ofb.ofb14 =l_ogb14 -l_ofb14                                    
           LET b_ofb.ofb14t=l_ogb14t-l_ofb14t                                   
           LET b_ofb.ofb912 =l_ogb912 -l_ofb912                                 
           LET b_ofb.ofb915 =l_ogb915 -l_ofb915                                 
           LET b_ofb.ofb917 =l_ogb917 -l_ofb917     #No.TQC-8B0030              
        ELSE                                                                    
           CONTINUE FOREACH                                                     
        END IF                                                                  
     END IF                                                                     
     LET b_ofb.ofb34 = g_ogb.ogb01  #No:8606
     LET b_ofb.ofb35 = g_ogb.ogb03  #No:8606
     LET b_ofb.ofb910= g_ogb.ogb910
     LET b_ofb.ofb911= g_ogb.ogb911
     LET b_ofb.ofb913= g_ogb.ogb913
     LET b_ofb.ofb914= g_ogb.ogb914
     LET b_ofb.ofb916= g_ogb.ogb916
     CALL t500_b_else()
 
     LET b_ofb.ofbplant = g_plant
     LET b_ofb.ofblegal = g_legal 
 
     MESSAGE b_ofb.ofb03,' ',b_ofb.ofb04,' ',b_ofb.ofb12
     INSERT INTO ofb_file VALUES(b_ofb.*)
     IF STATUS OR SQLCA.SQLCODE THEN
        CALL cl_err3("ins","ofb_file",b_ofb.ofb01,"",SQLCA.SQLCODE,"","ins ofb",1)   #No.FUn-660167
     END IF
    #LET i = i + 1 #CHI-C40017 add   #MOD-D10223 mark
   END FOREACH
    CALL t500_bu() #MOD-4A0287
END FUNCTION
 
#CHI-B90048 ----- mark -----
#FUNCTION t500_g_b2()                 	#由訂單產生單身
#   DEFINE l_ima35,l_ima36,l_ima25	LIKE faj_file.faj02      # No.FUN-680137 VARCHAR(10)
#DEFINE l_ofb12     LIKE ofb_file.ofb12                                          
#DEFINE l_ofb14     LIKE ofb_file.ofb14                                          
#DEFINE l_ofb14t    LIKE ofb_file.ofb14t                                         
#DEFINE l_ofb912    LIKE ofb_file.ofb912                                         
#DEFINE l_ofb915    LIKE ofb_file.ofb915                                         
#DEFINE l_ofb917    LIKE ofb_file.ofb917    #No.TQC-8B0030 
#DEFINE l_ogb12     LIKE ogb_file.ogb12                                          
#DEFINE l_ogb14     LIKE ogb_file.ogb14                                          
#DEFINE l_ogb14t    LIKE ogb_file.ogb14t                                         
#DEFINE l_ogb912    LIKE ogb_file.ogb912                                         
#DEFINE l_ogb915    LIKE ogb_file.ogb915                                         
# 
#   IF NOT cl_confirm('axm-132') THEN RETURN END IF
#   DECLARE t500_g_b_c2 CURSOR FOR
#         SELECT oeb_file.*,ima35,ima36,ima25
#            FROM oeb_file LEFT OUTER JOIN ima_file ON oeb_file.oeb04=ima_file.ima01
#           WHERE oeb01=g_ofa.ofa16
#             AND (oeb12-oeb24+oeb25)>0 AND oeb70='N'
#           ORDER BY oeb03
#   FOREACH t500_g_b_c2 INTO g_oeb.*,l_ima35,l_ima36,l_ima25
#     IF STATUS THEN EXIT FOREACH END IF
#     INITIALIZE b_ofb.* TO NULL
#     LET b_ofb.ofb01 = g_ofa.ofa01
#     LET b_ofb.ofb03 = g_oeb.oeb03
#     LET b_ofb.ofb31 = g_oeb.oeb01
#     LET b_ofb.ofb32 = g_oeb.oeb03
#     LET b_ofb.ofb04 = g_oeb.oeb04
#     LET b_ofb.ofb05 = g_oeb.oeb05
#     LET b_ofb.ofb06 = g_oeb.oeb06
#     LET b_ofb.ofb13 = g_oeb.oeb13
#     lET b_ofb.ofb11 = g_oeb.oeb11
#     SELECT SUM(ofb12),SUM(ofb14),SUM(ofb14t),SUM(ofb912),SUM(ofb915),SUM(ofb917)   #No.TQC-8B0030           
#       INTO l_ofb12,l_ofb14,l_ofb14t,l_ofb912,l_ofb915,l_ofb917    #No.TQC-8B0030                          
#       FROM ofb_file,ofa_file                                                   
#      WHERE ofb31 =g_oeb.oeb01                                                  
#        AND ofb32 =g_oeb.oeb03                                                  
#        AND ofb01 =ofa01                                                        
#        AND ofaconf !='X'                                                       
#     IF cl_null(l_ofb12) THEN                                                   
#        LET l_ofb12 =0                                                          
#     END IF                                                                     
#     IF cl_null(l_ofb14) THEN                                                   
#        LET l_ofb14 =0                                                          
#     END IF                                                                     
#     IF cl_null(l_ofb14t) THEN                                                  
#        LET l_ofb14t =0                                                         
#     END IF                                                                     
#     IF cl_null(l_ofb912) THEN                                                  
#        LET l_ofb912 =0                                                         
#     END IF                                                                     
#     IF cl_null(l_ofb915) THEN                                                  
#        LET l_ofb915 =0                                                         
#     END IF    
#     IF cl_null(l_ofb917) THEN                                                  
#        LET l_ofb917 =0                                                         
#     END IF    
#     IF l_ofb12 <g_oeb.oeb12 THEN                                               
#        LET b_ofb.ofb12 =g_oeb.oeb12 -l_ofb12                                   
#        LET b_ofb.ofb14 =g_oeb.oeb14 -l_ofb14                                   
#        LET b_ofb.ofb14t=g_oeb.oeb14t-l_ofb14t                                  
#        LET b_ofb.ofb912 =g_oeb.oeb912 -l_ofb912                                
#        LET b_ofb.ofb915 =g_oeb.oeb915 -l_ofb915                                
#        LET b_ofb.ofb917 =g_oeb.oeb917 -l_ofb917            #No.TQC-8B0030                    
#     ELSE                                                                       
#        CONTINUE FOREACH                                                        
#     END IF                                                                     
#     LET b_ofb.ofb910= g_oeb.oeb910
#     LET b_ofb.ofb911= g_oeb.oeb911
#     LET b_ofb.ofb913= g_oeb.oeb913
#     LET b_ofb.ofb914= g_oeb.oeb914
#     LET b_ofb.ofb916= g_oeb.oeb916
#     CALL t500_b_else()
#     MESSAGE b_ofb.ofb03,' ',b_ofb.ofb04,' ',b_ofb.ofb12
# 
#     LET b_ofb.ofbplant = g_plant
#     LET b_ofb.ofblegal = g_legal 
# 
#     INSERT INTO ofb_file VALUES(b_ofb.*)
#     IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err3("ins","ofb_file",b_ofb.ofb01,"",SQLCA.SQLCODE,"","ins ofb",1)   #No.FUn-660167
#     END IF
#   END FOREACH
#   CALL t500_bu()
#END FUNCTION
#CHI-B90048 ----- mark -----
 
FUNCTION t500_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_ofa.* FROM ofa_file WHERE ofa01 = g_ofa.ofa01
    IF g_ofa.ofa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ofa.ofaconf = 'Y' THEN CALL t500_u2() RETURN END IF
    IF g_ofa.ofaconf = 'X' THEN CALL cl_err(g_ofa.ofa01,'9024',0) RETURN END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ofa_o.* = g_ofa.*
 
    BEGIN WORK
 
    OPEN t500_cl USING g_ofa.ofa01
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t500_cl INTO g_ofa.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofa.ofa01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
    CALL t500_show0()      #NO.FUN-640251
    CALL t500_show()
    WHILE TRUE
        LET g_ofa.ofamodu=g_user
        LET g_ofa.ofadate=g_today
        CALL t500_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ofa.*=g_ofa_t.*
            CALL t500_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE ofa_file SET * = g_ofa.* WHERE ofa01 = g_ofa.ofa01
        IF STATUS OR SQLCA.SQLCODE THEN
           CALL cl_err3("upd","ofa_file",g_ofa_o.ofa01,"",SQLCA.SQLCODE,"","",1)   #No.FUn-660167
           CONTINUE WHILE
        END IF
        IF g_ofa.ofa01 != g_ofa_t.ofa01 THEN CALL t500_chkkey() END IF
        EXIT WHILE
    END WHILE
    CLOSE t500_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ofa.ofa01,'U')
 
END FUNCTION
 
FUNCTION t500_u2()
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT BY NAME g_ofa.ofa31
                 WITHOUT DEFAULTS
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   UPDATE ofa_file SET(ofa31) = (g_ofa.ofa31)
    WHERE ofa01=g_ofa.ofa01
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("upd","ofa_file",g_ofa.ofa01,"",SQLCA.SQLCODE,"","upd ofa",1)    #No.FUN-660167
   END IF
 
END FUNCTION
 
FUNCTION t500_chkkey()
           UPDATE ofb_file SET ofb01=g_ofa.ofa01 WHERE ofb01=g_ofa_t.ofa01
           IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("upd","ofb_file",g_ofa_t.ofa01,"",SQLCA.SQLCODE,"","upd ofb01",1)  #No.FUN-660167
               LET g_ofa.*=g_ofa_t.* CALL t500_show() ROLLBACK WORK RETURN
           END IF
           UPDATE oao_file SET oao01=g_ofa.ofa01 WHERE oao01=g_ofa_t.ofa01
           IF STATUS OR SQLCA.SQLCODE THEN
              CALL cl_err3("upd","oao_file",g_ofa_t.ofa01,"",SQLCA.SQLCODE,"","upd oao01",1)  #No.FUN-660167
              LET g_ofa.*=g_ofa_t.* CALL t500_show() ROLLBACK WORK RETURN
           END IF
           UPDATE oap_file SET oap01=g_ofa.ofa01 WHERE oap01=g_ofa_t.ofa01
           IF STATUS OR SQLCA.SQLCODE THEN
              CALL cl_err3("upd","oap_file",g_ofa_t.ofa01,"",SQLCA.SQLCODE,"","upd oap01",1)  #No.FUN-660167
              LET g_ofa.*=g_ofa_t.* CALL t500_show() ROLLBACK WORK RETURN
           END IF
END FUNCTION
 
#處理INPUT
FUNCTION t500_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                 #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
  DEFINE l_n1            LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE l_occ           RECORD LIKE occ_file.*
  DEFINE l_oap           RECORD LIKE oap_file.*
  DEFINE li_result       LIKE type_file.num5                #No.FUN-550070        #No.FUN-680137 SMALLINT
  DEFINE l_ogb31         LIKE ogb_file.ogb31                  #CHI-840050
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_ofa.ofaoriu,g_ofa.ofaorig,
        g_ofa.ofa00,g_ofa.ofa08,g_ofa.ofa01,g_ofa.ofa02,
        g_ofa.ofa011,g_ofa.ofa16,
        g_ofa.ofa03,g_ofa.ofa032,g_ofa.ofa04,
        g_ofa.ofa44,g_ofa.ofa45,g_ofa.ofa46,   #No.MOD-570240
        g_ofa.ofa10,g_ofa.ofa61,g_ofa.ofa62,   #MOD-960294
        g_ofa.ofa23,g_ofa.ofa24,
        g_ofa.ofa21,g_ofa.ofa211,g_ofa.ofa212,g_ofa.ofa213,
        g_ofa.ofa31,g_ofa.ofa32,
        g_ofa.ofa99,
        g_ofa.ofaconf,g_ofa.ofauser,g_ofa.ofagrup,g_ofa.ofamodu,g_ofa.ofadate,
        g_ofa.ofa50, 
        g_ofa.ofaud01,g_ofa.ofaud02,g_ofa.ofaud03,g_ofa.ofaud04,
        g_ofa.ofaud05,g_ofa.ofaud06,g_ofa.ofaud07,g_ofa.ofaud08,
        g_ofa.ofaud09,g_ofa.ofaud10,g_ofa.ofaud11,g_ofa.ofaud12,
        g_ofa.ofaud13,g_ofa.ofaud14,g_ofa.ofaud15 
 
           WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t500_set_entry(p_cmd)
           CALL t500_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("ofa01")
 
        AFTER FIELD ofa00
           IF NOT cl_null(g_ofa.ofa00) THEN
              IF g_ofa.ofa00 NOT MATCHES '[1234]' THEN    #FUN-690044
                 NEXT FIELD ofa00
              END IF
           END IF
 
        AFTER FIELD ofa08
           IF NOT cl_null(g_ofa.ofa08) THEN
              IF g_ofa.ofa08 NOT MATCHES '[12]' THEN
                 NEXT FIELD ofa08
              END IF
           END IF
 
        AFTER FIELD ofa01
           IF NOT cl_null(g_ofa.ofa01) THEN
#              CALL s_check_no(g_sys,g_ofa.ofa01,g_ofa_t.ofa01,"55","ofa_file","ofa01","")
               CALL s_check_no("axm",g_ofa.ofa01,g_ofa_t.ofa01,"55","ofa_file","ofa01","")   #No.FUN-A40041
                 RETURNING li_result,g_ofa.ofa01
               DISPLAY BY NAME g_ofa.ofa01
               IF (NOT li_result) THEN
    	           NEXT FIELD ofa01
               END IF
            END IF
 
        BEFORE FIELD ofa011
            CALL t500_set_entry(p_cmd)
 
        AFTER FIELD ofa011
            IF NOT cl_null(g_ofa.ofa011) THEN
               IF g_oaz.oaz67 = '1'  THEN
                  SELECT * INTO g_oga.* FROM oga_file
                   WHERE oga01 = g_ofa.ofa011
                    #AND (oga09 = '1' OR oga09 = '5')                #FUN-C80055 mark
                     AND (oga09 = '1' OR oga09 = '5' OR oga09 = '3') #FUN-C80055 add
               ELSE
                  SELECT * INTO g_oga.* FROM oga_file
                   WHERE oga01 = g_ofa.ofa011
                   #  AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')  #No.FUN-610079  #NO.TQC-740339  #FUN-B80006  mark
                     AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6' OR oga09 = '3' )  #No.FUN-610079  #NO.TQC-740339  #FUN-B80006  
               END IF
               IF STATUS THEN
                  CALL cl_err3("sel","oga_file",g_ofa.ofa011,"",STATUS,"","select oga",1)    #No.FUN-660167
                  NEXT FIELD ofa011
               END IF
 
               IF g_oga.ogaconf = 'N' THEN   #未確認
                  CALL cl_err('sel oga','axm-184',1)  #MOD-770159 0->1
                  NEXT FIELD ofa011          #MOD-770159 add
               END IF
 
               #IF p_cmd='a' OR g_ofa.ofa0351 IS NULL THEN #出貨通知轉INVOICE   #MOD-A90169
               IF p_cmd='a' OR 
                 (p_cmd='u' AND 
                  (g_ofa.ofa011<>g_ofa_t.ofa011 OR cl_null(g_ofa_t.ofa011))) THEN  #MOD-A90169
 
                  LET g_ofa.ofa00 = g_oga.oga00
                  LET g_ofa.ofa08 = g_oga.oga08
                  LET g_ofa.ofa03 = g_oga.oga03
                  LET g_ofa.ofa032= g_oga.oga032
                  LET g_ofa.ofa033= g_oga.oga033
                  LET g_ofa.ofa04 = g_oga.oga04
                  LET g_ofa.ofa044= g_oga.oga044
                  LET g_ofa.ofa16 = g_oga.oga16
                  SELECT oea10,oea24 INTO g_ofa.ofa10,g_oea.oea24 FROM oea_file #MOD-7C0210
                     WHERE oea01 = g_ofa.ofa16
                  LET g_ofa.ofa21 = g_oga.oga21
                  LET g_ofa.ofa211= g_oga.oga211
                  LET g_ofa.ofa212= g_oga.oga212
                  LET g_ofa.ofa213= g_oga.oga213
                  LET g_ofa.ofa23 = g_oga.oga23
                  CALL t500_oea18_get() RETURNING g_oea18_yn 
                  IF g_oea18_yn = 'Y' THEN
                     LET g_ofa.ofa24 = g_oea.oea24       #採用訂單立帳匯率
                  ELSE
                  IF g_ofa.ofa08='1' THEN
                     LET exT=g_oaz.oaz52
                  ELSE
                     LET exT=g_oaz.oaz70
                  END IF
                  IF g_oga.oga909='Y' THEN
                     LET exT=g_oax.oax01
                  END IF
                  CALL s_curr3(g_ofa.ofa23,g_ofa.ofa02,exT)
                       RETURNING g_ofa.ofa24
                  END IF   #MOD-7C0210 add
                  LET g_ofa.ofa31 = g_oga.oga31
                  LET g_ofa.ofa32 = g_oga.oga32
                  LET g_ofa.ofa41 = g_oga.oga41
                  LET g_ofa.ofa42 = g_oga.oga42
                  LET g_ofa.ofa43 = g_oga.oga43
                  LET g_ofa.ofa44 = g_oga.oga44
                  LET g_ofa.ofa47 = g_oga.oga47
                  LET g_ofa.ofa48 = g_oga.oga48
 
                  #MOD-C10018 ---add---str--- 
                  LET g_ofa.ofa0351 = NULL
                  LET g_ofa.ofa0451 = NULL
                  CALL t500_ofa0351()
                  CALL t500_ofa0451()
                  #MOD-C10018 ---add---end---
 
                  SELECT UNIQUE ogb31 INTO l_ogb31 FROM ogb_file,ofa_file                                                                         
                   WHERE ogb01 = g_ofa.ofa011 
                     AND ogb03 = (SELECT MIN(ogb03) FROM ogb_file,ofa_file 
                                   WHERE ogb01 = g_ofa.ofa011)                   
                                                                                                                                    
                  IF cl_null(g_ofa.ofa31) THEN                                                                                                    
                     SELECT UNIQUE oea31 INTO g_ofa.ofa31 
                       FROM oea_file,ogb_file 
                      WHERE oea01 = l_ogb31                                               
                  END IF                                                                                                                          
                                                                                                                                    
                  IF cl_null(g_ofa.ofa32) THEN                                                                                                    
                     SELECT UNIQUE oea32 INTO g_ofa.ofa32 
                       FROM oea_file,ogb_file 
                      WHERE oea01 = l_ogb31                                               
                  END IF                                                                                                                          
 
                  DISPLAY BY NAME g_ofa.ofa00, g_ofa.ofa08, g_ofa.ofa16,
                                  g_ofa.ofa03, g_ofa.ofa032, g_ofa.ofa04,
                                  g_ofa.ofa23, g_ofa.ofa24, g_ofa.ofa10,
                                  g_ofa.ofa31, g_ofa.ofa32,
                                  g_ofa.ofa21,
                                  g_ofa.ofa211, g_ofa.ofa212, g_ofa.ofa213
                  CALL t500_show2()
               END IF
            END IF
            CALL t500_set_no_entry(p_cmd)
 
        BEFORE FIELD ofa16
            CALL t500_set_entry(p_cmd)
 
        AFTER FIELD ofa16
              IF NOT cl_null(g_ofa.ofa16) THEN
                 SELECT * INTO g_oea.* FROM oea_file
                        WHERE oea01=g_ofa.ofa16 AND oea00 <>'0'
                 IF STATUS THEN
                    CALL cl_err3("sel","oea_file",g_ofa.ofa16,"",STATUS,"","select oea",1)  #No.FUN-660167
                    NEXT FIELD ofa16
                 END IF
                 IF g_oea.oeaconf != 'Y' THEN	#未確認 01/08/16 mandy
                    CALL cl_err('sel oea','axm-184',0) NEXT FIELD ofa16
                 END IF
        #        IF p_cmd='a' AND cl_null(g_ofa.ofa011) THEN#由訂單轉出貨單
                 IF (p_cmd='a' OR (p_cmd='u' and g_ofa.ofa16!= g_ofa_t.ofa16)) AND cl_null(g_ofa.ofa011) THEN#由訂單轉出貨單#TQC-A40038
                    LET g_ofa.ofa00 = g_oea.oea00
                    LET g_ofa.ofa08 = g_oea.oea08
                    LET g_ofa.ofa03 = g_oea.oea03
                    LET g_ofa.ofa032= g_oea.oea032
                    LET g_ofa.ofa033= g_oea.oea033
                    LET g_ofa.ofa04 = g_oea.oea04
                    LET g_ofa.ofa044= g_oea.oea044
                    LET g_ofa.ofa10 = g_oea.oea10
                    LET g_ofa.ofa21 = g_oea.oea21
                    LET g_ofa.ofa211= g_oea.oea211
                    LET g_ofa.ofa212= g_oea.oea212
                    LET g_ofa.ofa213= g_oea.oea213
                    LET g_ofa.ofa23 = g_oea.oea23
                    CALL t500_oea18_get() RETURNING g_oea18_yn 
                    IF g_oea18_yn = 'Y' THEN
                       LET g_ofa.ofa24 = g_oea.oea24       #採用訂單立帳匯率
                    ELSE
                    IF g_ofa.ofa08='1' THEN
                       LET exT=g_oaz.oaz52
                    ELSE
                       LET exT=g_oaz.oaz70
                    END IF
                    CALL s_curr3(g_ofa.ofa23,g_ofa.ofa02,exT)
                         RETURNING g_ofa.ofa24
                    END IF   #MOD-7C0210 add 
                    LET g_ofa.ofa31 = g_oea.oea31
                    LET g_ofa.ofa32 = g_oea.oea32
                    LET g_ofa.ofa41 = g_oea.oea41
                    LET g_ofa.ofa42 = g_oea.oea42
                    LET g_ofa.ofa43 = g_oea.oea43
                    LET g_ofa.ofa44 = g_oea.oea44
                    DISPLAY BY NAME g_ofa.ofa00,g_ofa.ofa08,
                                    g_ofa.ofa03, g_ofa.ofa032, g_ofa.ofa04,
                                    g_ofa.ofa23, g_ofa.ofa24,
                                    g_ofa.ofa31, g_ofa.ofa32,
                                    g_ofa.ofa21,
                                    g_ofa.ofa211, g_ofa.ofa212, g_ofa.ofa213
                    CALL t500_show2()
                 END IF
              END IF
              CALL t500_set_no_entry(p_cmd)
 
           AFTER FIELD ofa61
              IF NOT cl_null(g_ofa.ofa61) THEN
                 SELECT * FROM ola_file
                     WHERE ola04=g_ofa.ofa61 AND olaconf='Y'
                 IF STATUS THEN
                    CALL cl_err3("sel","ola_file",g_ofa.ofa61,"",STATUS,"","select ola",1)  #No.FUN-660167
                    NEXT FIELD ofa61
                 END IF
              END IF
 
           BEFORE FIELD ofa03
              CALL t500_set_entry(p_cmd)
 
           AFTER FIELD ofa03
              IF NOT cl_null(g_ofa.ofa03) THEN
                 SELECT * INTO l_occ.* FROM occ_file
                  WHERE occ01=g_ofa.ofa03
                    AND occacti='Y'
                 IF STATUS THEN
                    CALL cl_err3("sel","occ_file",g_ofa.ofa03,"",STATUS,"","select occ",1)  #No.FUN-660167
                    NEXT FIELD ofa03
                 END IF
                 IF g_ofa.ofa03[1,4] != 'MISC' THEN
                    LET g_ofa.ofa032 = l_occ.occ02 DISPLAY BY NAME g_ofa.ofa032
                 END IF
                 IF cl_null(g_ofa.ofa04) THEN
                    LET g_ofa.ofa04 = l_occ.occ09
                    DISPLAY BY NAME g_ofa.ofa04
                 END IF
                 IF cl_null(g_ofa.ofa18) THEN
                    LET g_ofa.ofa18 = l_occ.occ07
                 END IF
              END IF
              CALL t500_set_no_entry(p_cmd)
 
           AFTER FIELD ofa04
              IF NOT cl_null(g_ofa.ofa04) THEN
                 SELECT occ02 INTO g_buf FROM occ_file
                  WHERE occ01=g_ofa.ofa04
                    AND occacti='Y'
                 IF STATUS THEN
                    CALL cl_err3("sel","occ_file",g_ofa.ofa04,"",STATUS,"","select occ",1) NEXT FIELD ofa04  #No.FUN-660167
                 END IF
                 DISPLAY g_buf TO occ02
              END IF
 
           BEFORE FIELD ofa23
              CALL t500_set_entry(p_cmd)
 
           AFTER FIELD ofa23
              IF NOT cl_null(g_ofa.ofa23) THEN
                 SELECT azi02,azi03,azi04 INTO g_buf,t_azi03,t_azi04  #No.CHI-6A0004
                   FROM azi_file WHERE azi01=g_ofa.ofa23
                 IF STATUS THEN
                    CALL cl_err3("sel","azi_file",g_ofa.ofa23,"",STATUS,"","select azi",1)  #No.FUN-660167
                    NEXT FIELD ofa23
                 END IF
                 IF g_ofa.ofa24=0 OR cl_null(g_ofa.ofa24) THEN
                    CALL t500_oea18_get() RETURNING g_oea18_yn 
                    IF g_oea18_yn = 'Y' THEN
                       LET g_ofa.ofa24 = g_oea.oea24       #採用訂單立帳匯率
                    ELSE
                    IF g_ofa.ofa08='1' THEN
                       LET exT=g_oaz.oaz52
                    ELSE
                       LET exT=g_oaz.oaz70
                    END IF
                    CALL s_curr3(g_ofa.ofa23,g_ofa.ofa02,exT) RETURNING g_ofa.ofa24
                    END IF #MOD-7C0210
                 END IF
                 IF cl_null(g_ofa.ofa24) THEN LET g_ofa.ofa24=0 END IF
                 DISPLAY BY NAME g_ofa.ofa24
              END IF
              CALL t500_set_no_entry(p_cmd)
 
           AFTER FIELD ofa24                                                                                                        
              IF g_ofa.ofa24 <= 0 THEN                 
                 CALL cl_err(g_ofa.ofa24,'axm-987',0)                                                                               
                 NEXT FIELD ofa24                                                                                                   
              END IF                                                                                                                
 
           AFTER FIELD ofa21
              IF NOT cl_null(g_ofa.ofa21) THEN
                 SELECT gec04,gec05,gec07
                   INTO g_ofa.ofa211,g_ofa.ofa212,g_ofa.ofa213
                    FROM gec_file WHERE gec01=g_ofa.ofa21 AND gec011='2' #No.MOD-8A0152 add by liuxqa
                 IF STATUS THEN
                    CALL cl_err3("sel","gec_file",g_ofa.ofa21,"",STATUS,"","select gec",1)  #No.FUN-660167
                    NEXT FIELD ofa21
                 END IF
                 DISPLAY BY NAME g_ofa.ofa211, g_ofa.ofa212, g_ofa.ofa213
              END IF
 
           AFTER FIELD ofa31
              IF NOT cl_null(g_ofa.ofa31) THEN
                 SELECT oah02 INTO g_buf FROM oah_file
                  WHERE oah01=g_ofa.ofa31
                 IF STATUS THEN
                    CALL cl_err3("sel","oah_file",g_ofa.ofa31,"",STATUS,"","select oah",1)  #No.FUN-660167
                    NEXT FIELD ofa31
                 END IF
                 DISPLAY g_buf TO oah02
              END IF
 
           AFTER FIELD ofa32
              IF NOT cl_null(g_ofa.ofa32) THEN
                 SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_ofa.ofa32
                 IF STATUS THEN
                    CALL cl_err3("sel","oag_file",g_ofa.ofa32,"",STATUS,"","select oag",1)  #No.FUN-660167
                    NEXT FIELD ofa32
                 END IF
                 DISPLAY g_buf TO oag02
              END IF
 
           AFTER FIELD ofa44
              IF NOT cl_null(g_ofa.ofa44) THEN
                 SELECT ocf02 INTO g_buf FROM ocf_file
                        WHERE ocf01=g_ofa.ofa04 AND ocf02=g_ofa.ofa44
                 IF STATUS THEN
                    CALL cl_err3("sel","ocf_file",g_ofa.ofa04,g_ofa.ofa44,STATUS,"","sel ocf",1)  #No.FUN-660167
                    NEXT FIELD ofa44
                 END IF
              END IF
 
           BEFORE FIELD ofa45
              LET g_ofa_o.ofa45=g_ofa.ofa45
 
           AFTER FIELD ofa45
              LET g_ofa.ofa45[11,20]=g_ofa_o.ofa45[11,20]
           BEFORE FIELD ofa46
              LET g_ofa_o.ofa46=g_ofa.ofa46
           AFTER FIELD ofaud01
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud02
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud03
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud04
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud05
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud06
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud07
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud08
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud09
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud10
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud11
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud12
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud13
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud14
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           AFTER FIELD ofaud15
              IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON KEY(F1) NEXT FIELD ofa00
        ON KEY(F2) NEXT FIELD ofa03
 
        ON ACTION maintain_mark
                    IF cl_null(g_ofa.ofa44) THEN
                       LET g_cnt=0
                       SELECT MAX(ocf02) INTO g_cnt FROM ocf_file
                              WHERE ocf01=g_ofa.ofa04
                       IF g_cnt IS NULL THEN LET g_cnt=0 END IF
                       LET g_ofa.ofa44=(g_cnt+1) USING '&&&&'
                       DISPLAY BY NAME g_ofa.ofa44
                       INSERT INTO ocf_file(ocf01,ocf02)
                              VALUES(g_ofa.ofa04,g_ofa.ofa44)
                    END IF
                    LET g_msg='axmi230 ',g_ofa.ofa04,' ',g_ofa.ofa44
                    CALL cl_cmdrun(g_msg)
                    NEXT FIELD ofa44
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ofa01) #查詢單据
                   CALL q_oay( FALSE,TRUE,g_t1,'55','AXM') RETURNING g_t1   #TQC-670008
                   LET g_ofa.ofa01=g_t1               #No.FUN-550070
                   DISPLAY BY NAME g_ofa.ofa01
                   NEXT FIELD ofa01
              WHEN INFIELD(ofa16)
                   CALL q_oea( FALSE,TRUE,g_ofa.ofa16,'','3') RETURNING g_ofa.ofa16
                   DISPLAY BY NAME g_ofa.ofa16
                   NEXT FIELD ofa16
              WHEN INFIELD(ofa011)
                   CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_oga"
                   LET g_qryparam.form ="q_oga001"              #MOD-B70010
                   LET g_qryparam.default1 = g_ofa.ofa011
                   IF g_oaz.oaz67 = '1'  THEN
                     #LET g_qryparam.where = " ( oga09='1' OR oga09='5') "                #FUN-C80055 mark
                      LET g_qryparam.where = " ( oga09='1' OR oga09='5' OR oga09 = '3') " #FUN-C80055 add
                   ELSE
                    #  LET g_qryparam.where = " ( oga09='2' OR oga09='4' OR oga09='8' OR oga09 ='6') "  #No.FUN-610079  #NO.TQC-740339 #FUN-B80006  mark
                      LET g_qryparam.where = " ( oga09='2' OR oga09='4' OR oga09='8' OR oga09 ='6' OR oga09 ='3') "  #No.FUN-610079  #NO.TQC-740339  #FUN-B80006   
                   END IF
                   CALL cl_create_qry() RETURNING g_ofa.ofa011
                   DISPLAY BY NAME g_ofa.ofa011 NEXT FIELD ofa011
              WHEN INFIELD(ofa03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.default1 = g_ofa.ofa03
                   CALL cl_create_qry() RETURNING g_ofa.ofa03
                   DISPLAY BY NAME g_ofa.ofa03
                   NEXT FIELD ofa03
              WHEN INFIELD(ofa04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.default1 = g_ofa.ofa04
                   CALL cl_create_qry() RETURNING g_ofa.ofa04
                   DISPLAY BY NAME g_ofa.ofa04
                   NEXT FIELD ofa04
              WHEN INFIELD(ofa21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gec"
                   LET g_qryparam.default1 = g_ofa.ofa21
                   LET g_qryparam.arg1 = '2'
                   CALL cl_create_qry() RETURNING g_ofa.ofa21
                   DISPLAY BY NAME g_ofa.ofa21
                   NEXT FIELD ofa21
              WHEN INFIELD(ofa23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azi"
                   LET g_qryparam.default1 = g_ofa.ofa23
                   CALL cl_create_qry() RETURNING g_ofa.ofa23
                   DISPLAY BY NAME g_ofa.ofa23
                   NEXT FIELD ofa23
              WHEN INFIELD(ofa31)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oah"
                   LET g_qryparam.default1 = g_ofa.ofa31
                   CALL cl_create_qry() RETURNING g_ofa.ofa31
                   DISPLAY BY NAME g_ofa.ofa31
                   NEXT FIELD ofa31
              WHEN INFIELD(ofa32)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oag"
                   LET g_qryparam.default1 = g_ofa.ofa32
                   CALL cl_create_qry() RETURNING g_ofa.ofa32
                   DISPLAY BY NAME g_ofa.ofa32
                   NEXT FIELD ofa32
              WHEN INFIELD(ofa44)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ocf"
                   LET g_qryparam.arg1 = g_ofa.ofa04
                   CALL cl_create_qry() RETURNING g_ofa.ofa44
                   DISPLAY BY NAME g_ofa.ofa44 NEXT FIELD ofa44
              WHEN INFIELD(ofa24)
                   CALL s_rate(g_ofa.ofa23,g_ofa.ofa24) RETURNING g_ofa.ofa24
                   DISPLAY BY NAME g_ofa.ofa24
                   NEXT FIELD ofa24
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
 
FUNCTION t500_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ofa01",TRUE)
       CALL cl_set_comp_entry("ofa011",TRUE)  #MOD-690130 add
    END IF

    IF INFIELD(ofa08) OR ( NOT g_before_input_done ) THEN                       #TQC-C70185 add
       CALL cl_set_comp_entry("ofa08",TRUE)                                     #TQC-C70185 add
    END IF                                                                      #TQC-C70185 add
 
    IF INFIELD(ofa03) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ofa032",TRUE)
    END IF
 
    IF INFIELD(ofa011) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ofa16,ofa03,ofa04,ofa21,
                               ofa23,ofa24,ofa31,ofa32,ofa032"
                              ,TRUE)
    END IF
 
    IF INFIELD(ofa16) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ofa03,ofa04,ofa21,ofa23,ofa24,
                               ofa31,ofa32,ofa032",TRUE)
    END IF
 
    IF INFIELD(ofa23) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ofa24",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t500_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN     #TQC-C70185 add
       CALL cl_set_comp_entry("ofa08",FALSE)                                  #TQC-C70185 add
    END IF                                                                    #TQC-C70185 add
    
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ofa01",FALSE)
    END IF
 
    IF (g_rec_b >0) AND p_cmd='u' THEN   #MOD-690130 modify p_cmd='u'
       CALL cl_set_comp_entry("ofa011",FALSE)
    END IF
 
   IF INFIELD(ofa03) OR ( NOT g_before_input_done ) THEN
       IF g_ofa.ofa03[1,4] != 'MISC' THEN
          CALL cl_set_comp_entry("ofa032",FALSE)
       END IF
    END IF
 
    IF INFIELD(ofa011) OR ( NOT g_before_input_done ) THEN
       IF NOT cl_null(g_ofa.ofa011) THEN
          CALL cl_set_comp_entry("ofa16,ofa03,ofa04,ofa21,ofa31,ofa32,ofa032",
                                  FALSE)
          CALL cl_set_comp_entry("ofa23,ofa24",FALSE)
       END IF
    END IF
 
    IF INFIELD(ofa16) OR ( NOT g_before_input_done ) THEN
       IF NOT cl_null(g_ofa.ofa16) THEN
          CALL cl_set_comp_entry("ofa03,ofa04,ofa21,ofa31,ofa32,oga032",FALSE)
          CALL cl_set_comp_entry("ofa23,ofa24",FALSE)
       END IF
    END IF
 
    IF INFIELD(ofa23) OR ( NOT g_before_input_done ) THEN
       IF g_ofa.ofa23 = g_aza.aza17 THEN
          LET g_ofa.ofa24 = 1
          DISPLAY BY NAME g_ofa.ofa24                  #FUN-4C0076
          CALL cl_set_comp_entry("ofa24",FALSE)
       END IF
    END IF
    CALL cl_set_comp_entry("ofa08",FALSE)  #MOD-C80214 add
 
END FUNCTION
 
FUNCTION t500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ofa.* TO NULL               #No.FUN-6A0020
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t500_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_ofa.* TO NULL
       RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
 
    OPEN t500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ofa.* TO NULL
    ELSE
        OPEN t500_count
        FETCH t500_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t500_fetch('F')                  # 讀出TEMP第一筆並顯示
        CALL t500_list_fill()                 #FUN-CB0014
    END IF
 
END FUNCTION
 
FUNCTION t500_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
#   g_jump          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680137 INTEGER   #FUN-CB0014 mark
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t500_cs INTO g_ofa.ofa01
        WHEN 'P' FETCH PREVIOUS t500_cs INTO g_ofa.ofa01
        WHEN 'F' FETCH FIRST    t500_cs INTO g_ofa.ofa01
        WHEN 'L' FETCH LAST     t500_cs INTO g_ofa.ofa01
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump t500_cs INTO g_ofa.ofa01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofa.ofa01,SQLCA.sqlcode,0)
        INITIALIZE g_ofa.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_ofa.* FROM ofa_file WHERE ofa01 = g_ofa.ofa01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ofa_file",g_ofa.ofa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_ofa.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_ofa.ofauser      #FUN-4C0057 add
    LET g_data_group = g_ofa.ofagrup      #FUN-4C0057 add
    LET g_data_plant = g_ofa.ofaplant #FUN-980030
 
    CALL t500_show()
 
END FUNCTION
 
FUNCTION t500_show0()
   DEFINE   ls_msg   LIKE type_file.chr1000       # No.FUN-680137 VARCHAR(50)
 
   IF g_lang='1' THEN RETURN END IF
   CASE g_oaz.oaz67
      WHEN '1'
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'axm-705' AND ze02 = g_lang
         CALL cl_set_comp_att_text("ofa011",ls_msg CLIPPED || "," || ls_msg CLIPPED)
      WHEN '2'
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'axr-501' AND ze02 = g_lang
         CALL cl_set_comp_att_text("ofa011",ls_msg CLIPPED || "," || ls_msg CLIPPED)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   END CASE
END FUNCTION
 
FUNCTION t500_show()
    DEFINE l_oap RECORD LIKE oap_file.*
    LET g_ofa_t.* = g_ofa.*                #保存單頭舊值
    DISPLAY BY NAME g_ofa.ofaoriu,g_ofa.ofaorig,
        g_ofa.ofa00,g_ofa.ofa08,g_ofa.ofa01,g_ofa.ofa02,
        g_ofa.ofa011,g_ofa.ofa16,g_ofa.ofa61,g_ofa.ofa62,g_ofa.ofa99,  #No.7995   #MOD-960294
        g_ofa.ofa03,g_ofa.ofa032,g_ofa.ofa04,g_ofa.ofa23,g_ofa.ofa24,
        g_ofa.ofa21,g_ofa.ofa211,g_ofa.ofa212,g_ofa.ofa213,
        g_ofa.ofa31,g_ofa.ofa32,g_ofa.ofa44,g_ofa.ofa45,g_ofa.ofa46,   #No.MOD-570240
        g_ofa.ofa10,g_ofa.ofa50,
        g_ofa.ofaconf,g_ofa.ofauser,g_ofa.ofagrup,g_ofa.ofamodu,g_ofa.ofadate,
        g_ofa.ofaud01,g_ofa.ofaud02,g_ofa.ofaud03,g_ofa.ofaud04,
        g_ofa.ofaud05,g_ofa.ofaud06,g_ofa.ofaud07,g_ofa.ofaud08,
        g_ofa.ofaud09,g_ofa.ofaud10,g_ofa.ofaud11,g_ofa.ofaud12,
        g_ofa.ofaud13,g_ofa.ofaud14,g_ofa.ofaud15 
 
    #CKP
    IF g_ofa.ofaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_ofa.ofaconf,"","","",g_chr,"")
    LET g_buf = s_get_doc_no(g_ofa.ofa01)     #No.FUN-550070
    SELECT oaydesc INTO g_buf FROM oay_file WHERE oayslip=g_buf
                 DISPLAY g_buf TO oaydesc LET g_buf = NULL
    CALL t500_show2()
    CALL t500_show_oao()
    CALL t500_b_fill(g_wc2)
    CALL t500_list_fill()                     #FUN-CB0014   
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t500_show_oao()
    DEFINE i,j LIKE type_file.num5          #No.FUN-680137 SMALLINT
    DEFINE l_oao06	LIKE type_file.chr1000     # No.FUN-680137 VARCHAR(60)
    DECLARE t500_show_c CURSOR FOR
        SELECT oao03,oao04,oao06 FROM oao_file
          WHERE oao01=g_ofa.ofa01 ORDER BY 1,2
    LET g_msg=''
    FOREACH t500_show_c INTO i,j,l_oao06
       IF STATUS THEN EXIT FOREACH END IF
       LET g_msg=g_msg CLIPPED,' ',l_oao06
    END FOREACH
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t500_show2()
  DEFINE l_order_no LIKE oea_file.oea01
    SELECT azi03,azi04 INTO t_azi03,t_azi04  #No.CHI-6A0004
                     FROM azi_file WHERE azi01=g_ofa.ofa23
    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_ofa.ofa04
                 DISPLAY g_buf TO occ02 LET g_buf = NULL
    SELECT oah02 INTO g_buf FROM oah_file WHERE oah01=g_ofa.ofa31
                 DISPLAY g_buf TO oah02 LET g_buf=NULL
    SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_ofa.ofa32
                 DISPLAY g_buf TO oag02 LET g_buf=NULL
    #判斷是否為多角貿易單據
    SELECT oga909 INTO g_oga909 FROM oga_file
     WHERE oga01 = g_ofa.ofa011
    IF cl_null(g_oga909) THEN
       LET g_oga909 = 'N'
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    END IF
END FUNCTION
 
FUNCTION t500_r()
    DEFINE l_chr,l_sure  LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
    DEFINE l_ogb31       LIKE ogb_file.ogb31        #CHI-840050
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_ofa.* FROM ofa_file WHERE ofa01 = g_ofa.ofa01
    IF g_ofa.ofa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ofa.ofaconf = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_ofa.ofaconf = 'X' THEN CALL cl_err(g_ofa.ofa01,'9024',0) RETURN END IF
 
    BEGIN WORK
 
    OPEN t500_cl USING g_ofa.ofa01
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t500_cl INTO g_ofa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ofa.ofa01,SQLCA.sqlcode,0)
       CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t500_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ofa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ofa.ofa01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete ofa,ofb,oao,oap!"
        DELETE FROM ofa_file WHERE ofa01 = g_ofa.ofa01
        IF SQLCA.SQLERRD[3]=0
             THEN CALL cl_err3("del","ofa_file",g_ofa.ofa01,"",'',"","No ofa deleted",1)  #No.FUN-660167
                ROLLBACK WORK RETURN
        END IF
        DELETE FROM ofb_file WHERE ofb01 = g_ofa.ofa01
        DELETE FROM oao_file WHERE oao01 = g_ofa.ofa01
        DELETE FROM oap_file WHERE oap01 = g_ofa.ofa01
        UPDATE ofa_file SET ofa01=NULL WHERE ofa01=g_ofa.ofa01
 
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980010 add plant & legal 
           VALUES ('axmt500',g_user,g_today,g_msg,g_ofa.ofa01,'delete',g_plant,g_legal)
        CLEAR FORM
        CALL g_ofb.clear()
    	INITIALIZE g_ofa.* TO NULL
        OPEN t500_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE t500_cs
           CLOSE t500_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        FETCH t500_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t500_cs
           CLOSE t500_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t500_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t500_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t500_fetch('/')
        END IF
        MESSAGE ""
 
    END IF
 
    CLOSE t500_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ofa.ofa01,'D')
 
END FUNCTION
 
FUNCTION t500_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_row,l_col     LIKE type_file.num5,        # No.FUN-680137 SMALLINT  # 分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_b2      	    LIKE occ_file.occ02,        # No.FUN-680137  VARCHAR(30)
    l_ima35,l_ima36 LIKE faj_file.faj02,        # No.FUN-680137  VARCHAR(10)
    l_qty           LIKE ogb_file.ogb12,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
DEFINE l_ofb12     LIKE ofb_file.ofb12
DEFINE l_ofb14     LIKE ofb_file.ofb14
DEFINE l_ofb14t    LIKE ofb_file.ofb14t
DEFINE l_ofb912    LIKE ofb_file.ofb912
DEFINE l_ofb915    LIKE ofb_file.ofb915
DEFINE l_ofb917    LIKE ofb_file.ofb917
DEFINE l_ogb12     LIKE ogb_file.ogb12
DEFINE l_ogb14     LIKE ogb_file.ogb14
DEFINE l_ogb14t    LIKE ogb_file.ogb14t
DEFINE l_ogb912    LIKE ogb_file.ogb912
DEFINE l_ogb915    LIKE ogb_file.ogb915
DEFINE l_ogb917    LIKE ogb_file.ogb917
DEFINE l_qty1      LIKE ogb_file.ogb12
 
 
    LET g_action_choice = ""
    SELECT * INTO g_ofa.* FROM ofa_file WHERE ofa01 = g_ofa.ofa01
    IF g_ofa.ofa01 IS NULL THEN RETURN END IF
    IF g_ofa.ofaconf = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_ofa.ofaconf = 'X' THEN CALL cl_err(g_ofa.ofa01,'9024',0) RETURN END IF
 
    CALL t500_g_b()                 		#由出貨通知單/訂單自動產生單身
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM ofb_file ",
                       " WHERE ofb01= ? AND ofb03= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t500_bcl CURSOR FROM g_forupd_sql   # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ofb WITHOUT DEFAULTS FROM s_ofb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_docno_format("ofb31")     #No.FUN-550070
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t500_cl USING g_ofa.ofa01
            IF STATUS THEN
               CALL cl_err("OPEN t500_cl:", STATUS, 1)
               CLOSE t500_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t500_cl INTO g_ofa.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ofa.ofa01,SQLCA.sqlcode,0)
               CLOSE t500_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
 
                LET p_cmd='u'
                LET g_ofb_t.* = g_ofb[l_ac].*  #BACKUP
             #FUN-910088--add--start--
                LET g_ofb05_t = g_ofb[l_ac].ofb05
                LET g_ofb910_t = g_ofb[l_ac].ofb910
                LET g_ofb913_t = g_ofb[l_ac].ofb913
                LET g_ofb916_t = g_ofb[l_ac].ofb916
             #FUN-910088--add--end-- 

                OPEN t500_bcl USING g_ofa.ofa01,g_ofb_t.ofb03
                IF STATUS THEN
                   CALL cl_err("OPEN t500_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t500_bcl INTO b_ofb.*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock ofb',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       CALL t500_b_move_to()
                   END IF
                END IF
                LET g_change='N' #No.FUN-540049
                LET g_before_input_done = FALSE
                CALL t500_set_entry_b(p_cmd)
                CALL t500_set_no_entry_b(p_cmd)
                LET g_before_input_done = TRUE
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ofb[l_ac].* TO NULL      #900423
            INITIALIZE b_ofb.* TO NULL #MOD-DC0040
            LET b_ofb.ofb01=g_ofa.ofa01
            LET g_ofb[l_ac].ofb12=0
            LET g_ofb[l_ac].ofb13=0
            LET g_ofb[l_ac].ofb14=0
            LET g_ofb[l_ac].ofb14t=0   #MOD-9C0422
            LET g_change='Y'
            LET g_ofb[l_ac].ofb911 = 1
            LET g_ofb[l_ac].ofb912 = 0
            LET g_ofb[l_ac].ofb914 = 1
            LET g_ofb[l_ac].ofb915 = 0
            LET g_ofb_t.* = g_ofb[l_ac].*             #新輸入資料
         #FUN-910088--add--start--
            LET g_ofb05_t = NULL
            LET g_ofb910_t = NULL
            LET g_ofb913_t = NULL
            LET g_ofb916_t = NULL
         #FUN-910088--add--end--
            LET g_before_input_done = FALSE
            CALL t500_set_entry_b(p_cmd)
            CALL t500_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ofb03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            
            IF NOT cl_null(g_ofb[l_ac].ofb31) AND
               g_ofb[l_ac].ofb31[1,4] !='MISC' AND
               cl_null(g_ofb[l_ac].ofb32) THEN NEXT FIELD ofb32
            END IF
 
            IF g_sma.sma115 = 'Y' THEN
               IF NOT cl_null(g_ofb[l_ac].ofb04) THEN
                  SELECT ima25,ima31 INTO g_ima25,g_ima31
                    FROM ima_file WHERE ima01=g_ofb[l_ac].ofb04
               END IF
 
               CALL s_chk_va_setting(g_ofb[l_ac].ofb04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD ofb04
               END IF
 
               CALL s_chk_va_setting1(g_ofb[l_ac].ofb04)
                    RETURNING g_flag,g_ima908
               IF g_flag=1 THEN
                  NEXT FIELD ofb04
               END IF
 
               CALL t500_du_data_to_correct()
 
               CALL t500_set_origin_field()
            END IF
 
            CALL t500_b_move_back()
            CALL t500_b_else()
 
            LET b_ofb.ofbplant = g_plant
            LET b_ofb.ofblegal = g_legal 
 
            INSERT INTO ofb_file VALUES(b_ofb.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ofb_file",b_ofb.ofb01,"",SQLCA.sqlcode,"","ins ofb",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               CALL t500_bu()
            END IF
 
        BEFORE FIELD ofb03                            #default 序號
            IF g_ofb[l_ac].ofb03 IS NULL OR g_ofb[l_ac].ofb03 = 0 THEN
                SELECT max(ofb03)+1 INTO g_ofb[l_ac].ofb03 FROM ofb_file
                 WHERE ofb01 = g_ofa.ofa01
                IF g_ofb[l_ac].ofb03 IS NULL THEN
                    LET g_ofb[l_ac].ofb03 = 1
                END IF
            END IF
 
        AFTER FIELD ofb03                        #check 序號是否重複
            IF NOT cl_null(g_ofb[l_ac].ofb03) THEN
               IF g_ofb[l_ac].ofb03 != g_ofb_t.ofb03 OR
                  g_ofb_t.ofb03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM ofb_file
                    WHERE ofb01 = g_ofa.ofa01
                      AND ofb03 = g_ofb[l_ac].ofb03
                   IF l_n > 0 THEN
                      LET g_ofb[l_ac].ofb03 = g_ofb_t.ofb03
                      CALL cl_err('',-239,0) NEXT FIELD ofb03
                   END IF
               END IF
            END IF
 
        BEFORE FIELD ofb31
           CALL t500_set_entry_b(p_cmd)
 
        AFTER FIELD ofb31
           IF NOT cl_null(g_ofb[l_ac].ofb31) THEN
              IF g_ofb[l_ac].ofb31[1,4] !='MISC' THEN
                 SELECT * INTO g_oea.* FROM oea_file
                  WHERE oea01=g_ofb[l_ac].ofb31
                 IF STATUS THEN
                    CALL cl_err3("sel","oea_file",g_ofb[l_ac].ofb31,"",STATUS,"","sel oea",1)  #No.FUN-660167
                    NEXT FIELD ofb31
                 END IF
                 IF g_oea.oeaconf != 'Y' THEN	#未確認 01/08/16 mandy
                    CALL cl_err('sel oea','axm-184',0) NEXT FIELD ofb31
                 END IF
                 IF NOT cl_null(g_oea.oeahold) THEN
                    CALL cl_err('oeahold','axm-151',0) NEXT FIELD ofb31
                 END IF
                 IF g_oea.oea08 != g_ofa.ofa08 THEN	#國內外不符
                    CALL cl_err('sel oea','axm-125',0) NEXT FIELD ofb31
                 END IF
                 IF g_oea.oea03 != g_ofa.ofa03 THEN	#客戶不符
                    CALL cl_err('sel oea','axm-138',0) NEXT FIELD ofb31
                 END IF
                 IF g_oea.oea21 != g_ofa.ofa21 THEN	#稅別不符
                    CALL cl_err('sel oea','axm-142',0) NEXT FIELD ofb31
                 END IF
                 IF g_oea.oea23 != g_ofa.ofa23 THEN	#幣別不符
                    CALL cl_err('sel oea','axm-144',0) NEXT FIELD ofb31
                 END IF
              END IF
           END IF
           CALL t500_set_no_entry_b(p_cmd)
 
        AFTER FIELD ofb32
           IF NOT cl_null(g_ofb[l_ac].ofb31) AND
              cl_null(g_ofb[l_ac].ofb32) AND
              g_ofb[l_ac].ofb31[1,4] !='MISC' THEN
              NEXT FIELD ofb32
           END IF
           IF NOT cl_null(g_ofb[l_ac].ofb32) THEN
              IF NOT cl_null(g_ofb[l_ac].ofb32) AND
                 g_ofb[l_ac].ofb31[1,4] !='MISC' THEN
                 IF NOT cl_null(g_ofa.ofa011) THEN
                   IF g_oaz.oaz67 = '1'  THEN
                    SELECT COUNT(*) INTO g_cnt FROM oga_file,ogb_file
                     WHERE oga01=g_ofa.ofa011 AND oga01=ogb01
                      #AND ( oga09='1' OR oga09='5')                #FUN-C80055 mark
                       AND ( oga09='1' OR oga09='5' OR oga09 = '3') #FUN-C80055 add
                       AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
                    IF g_cnt=0 THEN 	#本訂單號不存在出貨通知單內
                       CALL cl_err('sel ogb(1):','axm-224',0) NEXT FIELD ofb32
                    END IF
                   ELSE
                    SELECT COUNT(*) INTO g_cnt FROM oga_file,ogb_file
                     WHERE oga01=g_ofa.ofa011 AND oga01=ogb01
                      #TQC-C40140 -- mark -- begin
                      #AND ( oga09='2' OR oga09='4' OR oga09 = '6' OR oga09 = '3')   #NO.TQC-740339            #FUN-B80006 add oga03 = '3'
                      #AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
                      #TQC-C40140 -- mark -- end
                      #TQC-C40140 -- add -- begin
                       AND (((oga09='2' OR oga09='4' OR oga09 = '6')
                             AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32) OR oga09 = '3')
                      #TQC-C40140 -- add -- end
                   END IF
                    IF g_cnt=0 THEN 	#本訂單號不存在出貨單內
                       CALL cl_err('sel ogb(1):','axm-324',0) NEXT FIELD ofb32
                    END IF
                 END IF
                 SELECT * INTO g_oeb.* FROM oeb_file
                  WHERE oeb01=g_ofb[l_ac].ofb31 AND oeb03=g_ofb[l_ac].ofb32
                 IF STATUS THEN
                    CALL cl_err3("sel","oeb_file",g_ofb[l_ac].ofb31,g_ofb[l_ac].ofb32,STATUS,"","sel oeb",1)  #No.FUN-660167
                    NEXT FIELD ofb32
                 END IF
                 IF p_cmd='a' OR g_ofb[l_ac].ofb31!=g_ofb_t.ofb31
                              OR g_ofb[l_ac].ofb32!=g_ofb_t.ofb32 THEN
                    LET g_ofb[l_ac].ofb04 = g_oeb.oeb04
                    LET g_ofb[l_ac].ofb05 = g_oeb.oeb05
                    LET g_ofb[l_ac].ofb06 = g_oeb.oeb06
                    LET g_ofb[l_ac].ofb13 = g_oeb.oeb13
                    LET g_ofb[l_ac].ofb11 = g_oeb.oeb11
                    #-----MOD-A80226---------
                    IF NOT cl_null(g_ofa.ofa011) THEN  
                       SELECT SUM(ofb12),SUM(ofb14),SUM(ofb14t),SUM(ofb912),SUM(ofb915),SUM(ofb917)
                         INTO l_ofb12,l_ofb14,l_ofb14t,l_ofb912,l_ofb915,l_ofb917 
                         FROM ofb_file,ofa_file 
                        WHERE ofb31 =g_ofb[l_ac].ofb31 
                          AND ofb32 =g_ofb[l_ac].ofb32
                          AND ofb01 =ofa01
                          AND ofaconf !='X'
                          AND ofa011 = g_ofa.ofa011
                    ELSE
                    #-----END MOD-A80226-----
                       SELECT SUM(ofb12),SUM(ofb14),SUM(ofb14t),SUM(ofb912),SUM(ofb915),SUM(ofb917)
                         INTO l_ofb12,l_ofb14,l_ofb14t,l_ofb912,l_ofb915,l_ofb917 
                         FROM ofb_file,ofa_file 
                        WHERE ofb31 =g_ofb[l_ac].ofb31 
                          AND ofb32 =g_ofb[l_ac].ofb32
                          AND ofb01 =ofa01
                          AND ofaconf !='X'
                    END IF   #MOD-A80226
                    IF cl_null(l_ofb12) THEN
                       LET l_ofb12 =0
                    END IF
                    IF cl_null(l_ofb14) THEN
                       LET l_ofb14 =0
                    END IF
                    IF cl_null(l_ofb14t) THEN
                       LET l_ofb14t=0
                    END IF
                    IF cl_null(l_ofb912) THEN
                       LET l_ofb912 =0
                    END IF
                    IF cl_null(l_ofb915) THEN
                       LET l_ofb915 =0
                    END IF
                    IF cl_null(l_ofb917) THEN
                       LET l_ofb917 =0
                    END IF
                    IF NOT cl_null(g_ofa.ofa011) THEN   #MOD-9B0028
                       IF g_oaz.oaz67 = '1'  THEN
                          SELECT SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(ogb912),SUM(ogb915),SUM(ogb917)
                            INTO l_ogb12,l_ogb14,l_ogb14t,l_ogb912,l_ogb915,l_ogb917 
                            FROM oga_file,ogb_file
                           WHERE oga01 = ogb01
                            #AND (oga09 = '1' OR oga09 = '5')                #FUN-C80055 mark
                             AND (oga09 = '1' OR oga09 = '5' OR oga09 = '3') #FUN-C80055 add
                             #-----MOD-A80226---------
                             #AND ogb31 =g_ogb.ogb31
                             #AND ogb32 =g_ogb.ogb32
                             AND ogb31 = g_ofb[l_ac].ofb31
                             AND ogb32 = g_ofb[l_ac].ofb32
                             AND ogb01 = g_ofa.ofa011
                             #-----END MOD-A80226-----
                          IF cl_null(l_ogb12) THEN
                             LET l_ogb12 =0
                          END IF
                          IF cl_null(l_ogb14) THEN
                             LET l_ogb14 =0
                          END IF
                          IF cl_null(l_ogb14t) THEN
                             LET l_ogb14t =0
                          END IF
                          IF cl_null(l_ogb912) THEN
                             LET l_ogb912 =0
                          END IF
                          IF cl_null(l_ogb915) THEN
                             LET l_ogb915 =0
                          END IF
                          IF cl_null(l_ogb917) THEN
                             LET l_ogb917 =0
                          END IF
                          IF l_ofb12 <=l_ogb12 THEN
                             LET g_ofb[l_ac].ofb12 =l_ogb12 -l_ofb12
                             LET g_ofb[l_ac].ofb14 =l_ogb14 -l_ofb14
                             LET g_ofb[l_ac].ofb14t=l_ogb14t-l_ofb14t   #MOD-9C0422
                             LET g_ofb[l_ac].ofb912 =l_ogb912 -l_ofb912
                             LET g_ofb[l_ac].ofb915 =l_ogb915 -l_ofb915
                             LET g_ofb[l_ac].ofb917 =l_ogb917 -l_ofb917
                          ELSE
                             CALL cl_err('','axm-246',0)   #MOD-A40138 axm-128-->axm-246
                             NEXT FIELD ofb32
                          END IF
                       ELSE
                          SELECT SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(ogb912),SUM(ogb915),SUM(ogb917)
                            INTO l_ogb12,l_ogb14,l_ogb14t,l_ogb912,l_ogb915,l_ogb917 
                            FROM oga_file,ogb_file
                           WHERE oga01 = ogb01
                     #TQC-C40140 -- mark -- begin
                     #     #  AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')   #FUN-B80006  mark
                     #       AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6' OR oga09 = '3')  #FUN-B80006   
                     #       #-----MOD-A80226---------
                     #       #AND ogb31 =g_ogb.ogb31
                     #       #AND ogb32 =g_ogb.ogb32
                     #       AND ogb31 = g_ofb[l_ac].ofb31
                     #       AND ogb32 = g_ofb[l_ac].ofb32
                     #TQC-C40140 -- mark -- end
                     #TQC-C40140 -- add -- begin
                             AND (((oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')
                                   AND ogb31 = g_ofb[l_ac].ofb31 AND ogb32 = g_ofb[l_ac].ofb32) OR oga09 = '3')
                     #TQC-C40140 -- add -- end
                             AND ogb01 = g_ofa.ofa011
                             #-----END MOD-A80226-----
                          IF cl_null(l_ogb12) THEN
                             LET l_ogb12 =0
                          END IF
                          IF cl_null(l_ogb14) THEN
                             LET l_ogb14 =0
                          END IF
                          IF cl_null(l_ogb14t) THEN
                             LET l_ogb14t =0
                          END IF
                          IF cl_null(l_ogb912) THEN
                             LET l_ogb912 =0
                          END IF
                          IF cl_null(l_ogb915) THEN
                             LET l_ogb915 =0
                          END IF
                          IF cl_null(l_ogb917) THEN
                             LET l_ogb917 =0
                          END IF
                          IF l_ofb12 <=l_ogb12 THEN
                             LET g_ofb[l_ac].ofb12 =l_ogb12 -l_ofb12
                             LET g_ofb[l_ac].ofb14 =l_ogb14 -l_ofb14
                             LET g_ofb[l_ac].ofb14t=l_ogb14t-l_ofb14t   #MOD-9C0422
                             LET g_ofb[l_ac].ofb912 =l_ogb912 -l_ofb912
                             LET g_ofb[l_ac].ofb915 =l_ogb915 -l_ofb915
                             LET g_ofb[l_ac].ofb917 =l_ogb917 -l_ofb917
                          ELSE
                             CALL cl_err('','axm-246',0)   #MOD-A40138 axm-128-->axm-246
                             NEXT FIELD ofb32
                          END IF
                       END IF
                    #CHI-B90048 ----- mark -----
                    #ELSE
                    #   LET g_ofb[l_ac].ofb12 =g_oeb.oeb12 -l_ofb12
                    #   LET g_ofb[l_ac].ofb14 =g_oeb.oeb14 -l_ofb14
                    #   LET g_ofb[l_ac].ofb14t=g_oeb.oeb14t-l_ofb14t   #MOD-9C0422
                    #   LET g_ofb[l_ac].ofb912 =g_oeb.oeb912 -l_ofb912
                    #   LET g_ofb[l_ac].ofb915 =g_oeb.oeb915 -l_ofb915
                    #   LET g_ofb[l_ac].ofb917 =g_oeb.oeb917 -l_ofb917
                    #CHI-B90048 ----- mark -----
                    END IF
                    LET g_ofb[l_ac].ofb910= g_oeb.oeb910
                    LET g_ofb[l_ac].ofb911= g_oeb.oeb911
                    LET g_ofb[l_ac].ofb913= g_oeb.oeb913
                    LET g_ofb[l_ac].ofb914= g_oeb.oeb914
                    LET g_ofb[l_ac].ofb916= g_oeb.oeb916
                    SELECT ima021 INTO g_ofb[l_ac].ima021
                      FROM ima_file WHERE ima01=g_ofb[l_ac].ofb04
                 END IF
              END IF
           END IF
           SELECT ima25,ima31,ima906,ima907,ima908
             INTO g_ima25,g_ima31,g_ima906,g_ima907,g_ima908
             FROM ima_file
            WHERE ima01=g_ofb[l_ac].ofb04
           CALL t500_set_no_entry_b(p_cmd)
 
        AFTER FIELD ofb04
           IF NOT cl_null(g_ofb[l_ac].ofb04) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_ofb[l_ac].ofb04,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_ofb[l_ac].ofb04= g_ofb_t.ofb04
                 NEXT FIELD ofb04
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              IF g_ofb_t.ofb04 IS NULL OR g_ofb_t.ofb04 <> g_ofb[l_ac].ofb04 THEN
                 LET g_change = 'Y'
              END IF
              IF g_ofb[l_ac].ofb31[1,4] ='MISC' AND g_ofb[l_ac].ofb04[1,4]!='MISC' THEN
                 CALL cl_err('part=MISC:','axm-232',0) NEXT FIELD ofb04
              END IF
 
              IF g_ofb[l_ac].ofb04 MATCHES 'MISC*' THEN
                 SELECT ima02,ima021,ima25 INTO g_buf,g_buf1,l_b2
                   FROM ima_file WHERE ima01='MISC'
              ELSE
                 SELECT ima02,ima021,ima25 INTO g_buf,g_buf1,l_b2
                   FROM ima_file WHERE ima01=g_ofb[l_ac].ofb04
              END IF   #MOD-8A0195
              IF STATUS THEN
                 CALL cl_err3("sel","ima_file",g_ofb[l_ac].ofb04,"",STATUS,"","sel ima",1)  #No.FUN-660167
                 NEXT FIELD ofb04
              END IF
 
              IF g_ofb[l_ac].ofb04 MATCHES 'MISC*' THEN
                 SELECT ima31 INTO g_ima31
                   FROM ima_file WHERE ima01='MISC'
              ELSE
                 SELECT ima31 INTO g_ima31
                   FROM ima_file WHERE ima01=g_ofb[l_ac].ofb04
              END IF   #MOD-8A0195
              IF STATUS THEN
                 CALL cl_err3("sel","ima_file",g_ofb[l_ac].ofb04,"",STATUS,"","sel ima",1)  #No.FUN-660167
                 NEXT FIELD ofb04
              END IF
              IF cl_null(g_ofb[l_ac].ofb05) THEN
                 LET g_ofb[l_ac].ofb05=l_b2
		 DISPLAY BY NAME g_ofb[l_ac].ofb05
              END IF
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_ofb[l_ac].ofb04)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD ofb04
                 END IF
                 IF g_ima906 = '3' THEN
                    LET g_ofb[l_ac].ofb913=g_ima907
		    DISPLAY BY NAME g_ofb[l_ac].ofb913
                 END IF
              END IF
              IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
                 CALL s_chk_va_setting1(g_ofb[l_ac].ofb04)
                      RETURNING g_flag,g_ima908
                 IF g_flag=1 THEN
                    NEXT FIELD ofb04
                 END IF
                 LET g_ofb[l_ac].ofb916=g_ima908
		 DISPLAY BY NAME g_ofb[l_ac].ofb916
              END IF
              IF g_sma.sma115 = 'Y' THEN
                 LET g_ima25 = l_b2
                 CALL t500_du_default(p_cmd)
              END IF
 
              IF g_ofb[l_ac].ofb04[1,4]!='MISC' OR g_ofb[l_ac].ofb06 IS NULL THEN
                 LET g_ofb[l_ac].ofb06 = g_buf
                 LET g_ofb[l_ac].ima021= g_buf1
                 DISPLAY BY NAME g_ofb[l_ac].ofb06
                 DISPLAY BY NAME g_ofb[l_ac].ima021
              END IF
              LET g_buf = NULL
              LET g_buf1 = NULL
              SELECT obk03 INTO g_buf FROM obk_file
                     WHERE obk01 = g_ofb[l_ac].ofb04 AND obk02 = g_ofa.ofa03
              IF cl_null(b_ofb.ofb11) THEN LET b_ofb.ofb11 = g_buf END IF
           END IF
 
        AFTER FIELD ofb05
           IF g_ofb_t.ofb05 IS NULL AND g_ofb[l_ac].ofb05 IS NOT NULL OR
              g_ofb_t.ofb05 IS NOT NULL AND g_ofb[l_ac].ofb05 IS NULL OR
              g_ofb_t.ofb05 <> g_ofb[l_ac].ofb05 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ofb[l_ac].ofb05) THEN
              SELECT COUNT(*) INTO g_cnt FROM gfe_file
                     WHERE gfe01=g_ofb[l_ac].ofb05
              IF g_cnt = 0 THEN
                 CALL cl_err(g_ofb[l_ac].ofb05,'mfg3377',0)
                 NEXT FIELD ofb05
              END IF
           END IF
    #FUN-910088--add--start--
         #TQC-C20183--mark--start--
         # IF g_sma.sma115 != 'N' THEN                                                     #FUN-C20068--add
         #    LET g_ofb[l_ac].ofb12 = s_digqty(g_ofb[l_ac].ofb12,g_ofb[l_ac].ofb05)        #FUN-C20068--add
         #    DISPLAY BY NAME g_ofb[l_ac].ofb12
         # ELSE
         #TQC-C20183--mark--end--
         IF NOT cl_null(g_ofb[l_ac].ofb12) AND g_ofb[l_ac].ofb12 <> 0 THEN
            IF NOT t500_ofb12_check(p_cmd,l_qty,l_qty1) THEN
               LET g_ofb05_t = g_ofb[l_ac].ofb05
               NEXT FIELD ofb12
            END IF
            LET g_ofb05_t = g_ofb[l_ac].ofb05
         END IF
        #  END IF                                          #TQC-C20183                     #FUN-C20068--add
    #FUN-910088--add--end--
 
        AFTER FIELD ofb12
           IF NOT t500_ofb12_check(p_cmd,l_qty,l_qty1) THEN NEXT FIELD ofb12 END IF       #FUN-910088--add--
    #FUN-910088--mark--start--
    #      IF g_ofb_t.ofb12 IS NULL AND g_ofb[l_ac].ofb12 IS NOT NULL OR
    #         g_ofb_t.ofb12 IS NOT NULL AND g_ofb[l_ac].ofb12 IS NULL OR
    #         g_ofb_t.ofb12 <> g_ofb[l_ac].ofb12 THEN
    #         LET g_change='Y'
    #      END IF
    #      IF NOT cl_null(g_ofb[l_ac].ofb12) THEN
    #         IF NOT cl_null(g_ofa.ofa011) AND NOT cl_null(g_ofb[l_ac].ofb31) THEN
    #            SELECT SUM(ogb12) INTO l_qty FROM ogb_file   #MOD-8C0153
    #             WHERE ogb01=g_ofa.ofa011
    #               AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
    #            IF STATUS THEN
    #               CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb12",1)  #No.FUN-660167
    #               NEXT FIELD ofb12
    #            END IF
    #            IF g_ofb[l_ac].ofb12 > l_qty THEN #出貨數量大於出貨通知量
    #               CALL cl_err('sel ofb(1):','axm-246',0) NEXT FIELD ofb12   #MOD-A40138 axm-128-->axm-246
    #            END IF
    #         END IF
    #         IF cl_null(g_ofb[l_ac].ofb916) THEN
    #            LET g_ofb[l_ac].ofb916 = g_ofb[l_ac].ofb05
    #            LET g_ofb[l_ac].ofb917 = g_ofb[l_ac].ofb12
    #   	 DISPLAY BY NAME g_ofb[l_ac].ofb916
    #   	 DISPLAY BY NAME g_ofb[l_ac].ofb917
    #         END IF
    #         IF g_change = 'Y' THEN
    #            CALL t500_set_ofb917()
    #         END IF
    #         IF NOT cl_null(g_ofb[l_ac].ofb31) AND NOT cl_null(g_ofb[l_ac].ofb32)     #No.MOD-8A0160
    #            AND (p_cmd ='a' OR g_ofb_t.ofb12<>g_ofb[l_ac].ofb12) THEN
    #            LET l_qty = 0
    #            LET l_qty1= 0
    #            IF NOT cl_null(g_ofa.ofa011) THEN   #MOD-9B0028 
    #               IF g_oaz.oaz67 = '1'  THEN
    #                  SELECT SUM(ogb12) INTO l_qty FROM ogb_file,oga_file   #MOD-8C0153
    #                   WHERE ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
    #                     AND oga01=ogb01
    #                     AND oga01 = g_ofa.ofa011    #TQC-AC0119 
    #                     AND (oga09 = '1' OR oga09 = '5')
    #               ELSE
    #                  SELECT SUM(ogb12) INTO l_qty FROM ogb_file,oga_file    #MOD-8C0153             	   
    #                   WHERE oga01 = ogb01
    #                     AND oga01 = g_ofa.ofa011    #TQC-AC0119
    #                   #  AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')  #FUN-B80006   mark
    #                     AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6' OR oga09 = '3')   #FUN-B80006  
    #                     AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
    #               END IF 
    #            #CHI-B90048 ----- mark start -----
    #            #ELSE
    #            #   SELECT oeb12 INTO l_qty FROM oeb_file
    #            #    WHERE oeb01 = g_ofb[l_ac].ofb31 AND oeb03 = g_ofb[l_ac].ofb32 
    #            #CHI-B90048 ----- mark  end  -----
    #            END IF
    #            IF cl_null(l_qty) THEN 
    #               LET l_qty =0
    #            END IF                  
    #            SELECT SUM(ofb12) INTO l_qty1 FROM ofb_file,ofa_file 
    #             WHERE ofb31=g_ofb[l_ac].ofb31 AND ofb32=g_ofb[l_ac].ofb32
    #               AND ofb01 =ofa01
    #               AND ofaconf !='X'
    #               AND ofa011 = g_ofa.ofa011   #MOD-B10142
    #            IF cl_null(l_qty1) THEN 
    #               LET l_qty1 =0
    #            END IF 
    #            IF p_cmd ='a' THEN
    #               LET l_qty =l_qty-l_qty1
    #            ELSE
    #               LET l_qty =l_qty-l_qty1+g_ofb_t.ofb12
    #            END IF 
    #            
    #            IF STATUS THEN
    #               CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb12",1)  
    #               NEXT FIELD ofb12
    #            END IF
    #            IF g_ofb[l_ac].ofb12 > l_qty THEN 
    #               CALL cl_err('','axm-246',0)  NEXT FIELD ofb12     #MOD-A40138 axm-128-->axm-246
    #            END IF
    #         END IF
    #         IF g_ofa.ofa213 = 'N' THEN
    #            LET g_ofb[l_ac].ofb14 =g_ofb[l_ac].ofb917*g_ofb[l_ac].ofb13                
    #            LET g_ofb[l_ac].ofb14t=g_ofb[l_ac].ofb14*(1+g_ofa.ofa211/100)
    #         ELSE
    #            LET g_ofb[l_ac].ofb14t =g_ofb[l_ac].ofb917*g_ofb[l_ac].ofb13                
    #            LET g_ofb[l_ac].ofb14=g_ofb[l_ac].ofb14t/(1+g_ofa.ofa211/100)
    #         END IF
    #         CALL cl_digcut(g_ofb[l_ac].ofb14,t_azi04) RETURNING g_ofb[l_ac].ofb14  
    #         CALL cl_digcut(g_ofb[l_ac].ofb14t,t_azi04)RETURNING g_ofb[l_ac].ofb14t 
    #         DISPLAY BY NAME g_ofb[l_ac].ofb14,g_ofb[l_ac].ofb14t
    #      END IF
    #FUN-910088--mark--end--
 
        BEFORE FIELD ofb913
           IF NOT cl_null(g_ofb[l_ac].ofb04) THEN
              SELECT ima25,ima31 INTO g_ima25,g_ima31
                FROM ima_file WHERE ima01=g_ofb[l_ac].ofb04
           END IF
           CALL t500_set_no_required()
 
        AFTER FIELD ofb913  #第二單位
           IF cl_null(g_ofb[l_ac].ofb04) THEN NEXT FIELD ofb04 END IF
           IF g_ofb_t.ofb913 IS NULL AND g_ofb[l_ac].ofb913 IS NOT NULL OR
              g_ofb_t.ofb913 IS NOT NULL AND g_ofb[l_ac].ofb913 IS NULL OR
              g_ofb_t.ofb913 <> g_ofb[l_ac].ofb913 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ofb[l_ac].ofb913) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ofb[l_ac].ofb913
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ofb[l_ac].ofb913,"",STATUS,"","gfe",1)  #No.FUN-660167
                 NEXT FIELD ofb913
              END IF
              CALL s_du_umfchk(g_ofb[l_ac].ofb04,'','','',
                               g_ima31,g_ofb[l_ac].ofb913,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ofb[l_ac].ofb913,g_errno,0)
                 NEXT FIELD ofb913
              END IF
              LET g_ofb[l_ac].ofb914 = g_factor
	      DISPLAY BY NAME g_ofb[l_ac].ofb914
	      #------MOD-5A0095 END------------
           END IF
           CALL t500_set_required()
           CALL cl_show_fld_cont()     #FUN-550037(smin)
      #FUN-910088--add--start--
           IF NOT cl_null(g_ofb[l_ac].ofb915) AND g_ofb[l_ac].ofb915 <> 0 THEN
              IF NOT t500_ofb915_check(p_cmd,l_qty,l_qty1) THEN
                 LET g_ofb913_t = g_ofb[l_ac].ofb913
                 NEXT FIELD ofb915
              END IF
              LET g_ofb913_t = g_ofb[l_ac].ofb913
           END IF
      #FUN-910088--add--end--
 
        AFTER FIELD ofb914  #第二轉換率
           IF g_ofb_t.ofb914 IS NULL AND g_ofb[l_ac].ofb914 IS NOT NULL OR
              g_ofb_t.ofb914 IS NOT NULL AND g_ofb[l_ac].ofb914 IS NULL OR
              g_ofb_t.ofb914 <> g_ofb[l_ac].ofb914 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ofb[l_ac].ofb914) THEN
              IF g_ofb[l_ac].ofb914=0 THEN
                 NEXT FIELD ofb914
              END IF
           END IF
 
        AFTER FIELD ofb915  #第二數量
       IF NOT t500_ofb915_check(p_cmd,l_qty,l_qty1) THEN NEXT FIELD ofb915  END IF  #FUN-910088--add--
       #FUN-910088--mark--start--
       #   IF g_ofb_t.ofb915 IS NULL AND g_ofb[l_ac].ofb915 IS NOT NULL OR
       #      g_ofb_t.ofb915 IS NOT NULL AND g_ofb[l_ac].ofb915 IS NULL OR
       #      g_ofb_t.ofb915 <> g_ofb[l_ac].ofb915 THEN
       #      LET g_change='Y'
       #   END IF
       #   IF NOT cl_null(g_ofb[l_ac].ofb915) THEN
       #      IF g_ofb[l_ac].ofb915 < 0 THEN
       #         CALL cl_err('','aim-391',0)  #
       #         NEXT FIELD ofb915
       #      END IF
       #      IF NOT cl_null(g_ofa.ofa011) AND NOT cl_null(g_ofb[l_ac].ofb31) THEN
       #         LET l_qty = 0
       #         SELECT SUM(ogb915) INTO l_qty FROM ogb_file   #MOD-8C0153
       #          WHERE ogb01=g_ofa.ofa011
       #            AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
       #         IF STATUS THEN
       #            CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb915",1)  #No.FUN-660167
       #            NEXT FIELD ofb915
       #         END IF
       #         IF g_ofb[l_ac].ofb915 > l_qty THEN #出貨數量大於出貨通知量
       #            CALL cl_err('sel ofb(1):','axm-246',0) NEXT FIELD ofb915   #MOD-A40138 axm-128-->axm-246
       #         END IF
       #      END IF
       #      IF p_cmd = 'a' THEN
       #         IF g_ima906='3' THEN
       #            LET g_tot=g_ofb[l_ac].ofb915*g_ofb[l_ac].ofb914
       #            IF cl_null(g_ofb[l_ac].ofb912) OR g_ofb[l_ac].ofb912=0 THEN #CHI-960022
       #               LET g_ofb[l_ac].ofb912=g_tot*g_ofb[l_ac].ofb911
       #               DISPLAY BY NAME g_ofb[l_ac].ofb912
       #            END IF                                                      #CHI-960022
       #         END IF
       #      END IF
       #   END IF
       #   IF g_change = 'Y' THEN
       #      CALL t500_set_ofb917()
       #   END IF
       #   CALL cl_show_fld_cont()     #FUN-550037(smin)
       #FUN-910088--mark--end--
 
        BEFORE FIELD ofb910
           IF NOT cl_null(g_ofb[l_ac].ofb04) THEN
              SELECT ima25,ima31 INTO g_ima25,g_ima31
                FROM ima_file WHERE ima01=g_ofb[l_ac].ofb04
           END IF
           CALL t500_set_no_required()
 
        AFTER FIELD ofb910  #第一單位
           IF cl_null(g_ofb[l_ac].ofb04) THEN NEXT FIELD ofb04 END IF
           IF g_ofb_t.ofb910 IS NULL AND g_ofb[l_ac].ofb910 IS NOT NULL OR
              g_ofb_t.ofb910 IS NOT NULL AND g_ofb[l_ac].ofb910 IS NULL OR
              g_ofb_t.ofb910 <> g_ofb[l_ac].ofb910 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ofb[l_ac].ofb910) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ofb[l_ac].ofb910
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ofb[l_ac].ofb910,"",STATUS,"","gfe",1)  #No.FUN-660167
                 NEXT FIELD ofb910
              END IF
              CALL s_du_umfchk(g_ofb[l_ac].ofb04,'','','',
                               g_ofb[l_ac].ofb05,g_ofb[l_ac].ofb910,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ofb[l_ac].ofb910,g_errno,0)
                 NEXT FIELD ofb910
              END IF
              LET g_ofb[l_ac].ofb911 = g_factor
	      DISPLAY BY NAME g_ofb[l_ac].ofb911
           END IF
           CALL t500_set_required()
           CALL cl_show_fld_cont()     #FUN-550037(smin)
       #FUN-910088--add--start--
           IF NOT cl_null(g_ofb[l_ac].ofb912) AND NOT g_ofb[l_ac].ofb912 <> 0 THEN
              IF NOT t500_ofb912_check(p_cmd,l_qty,l_qty1) THEN
                 LET g_ofb910_t =g_ofb[l_ac].ofb910
                 NEXT FIELD ofb912
              END IF
              LET g_ofb910_t =g_ofb[l_ac].ofb910
           END IF
       #FUN-910088--add--end--
 
        AFTER FIELD ofb911  #第一轉換率
           IF g_ofb_t.ofb911 IS NULL AND g_ofb[l_ac].ofb911 IS NOT NULL OR
              g_ofb_t.ofb911 IS NOT NULL AND g_ofb[l_ac].ofb911 IS NULL OR
              g_ofb_t.ofb911 <> g_ofb[l_ac].ofb911 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ofb[l_ac].ofb911) THEN
              IF g_ofb[l_ac].ofb911=0 THEN
                 NEXT FIELD ofb911
              END IF
           END IF
 
        AFTER FIELD ofb912  #第一數量
           IF NOT t500_ofb912_check(p_cmd,l_qty,l_qty1) THEN NEXT FIELD ofb912 END IF   #FUN-910088--add--
    #FUN-910088--mark--start--
    #      IF g_ofb_t.ofb912 IS NULL AND g_ofb[l_ac].ofb912 IS NOT NULL OR
    #         g_ofb_t.ofb912 IS NOT NULL AND g_ofb[l_ac].ofb912 IS NULL OR
    #         g_ofb_t.ofb912 <> g_ofb[l_ac].ofb912 THEN
    #         LET g_change='Y'
    #      END IF
    #      IF NOT cl_null(g_ofb[l_ac].ofb912) THEN
    #         IF g_ofb[l_ac].ofb912 < 0 THEN
    #            CALL cl_err('','aim-391',0)  #
    #            NEXT FIELD ofb912
    #         END IF
    #         IF NOT cl_null(g_ofb[l_ac].ofb31) AND NOT cl_null(g_ofb[l_ac].ofb32)    #MOD-9B0028 
    #            AND (p_cmd ='a' OR g_ofb_t.ofb912<>g_ofb[l_ac].ofb912) THEN   #MOD-9B0028
    #            LET l_qty = 0
    #            LET l_qty1 = 0
    #            IF NOT cl_null(g_ofa.ofa011) THEN   #MOD-9B0028
    #                IF g_oaz.oaz67 = '1'  THEN
    #                   SELECT SUM(ogb912) INTO l_qty FROM ogb_file,oga_file   #MOD-8C0153
    #                    WHERE ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
    #                      AND oga01=ogb01
    #                      AND (oga09 = '1' OR oga09 = '5')
    #                ELSE
    #                   SELECT SUM(ogb912) INTO l_qty FROM ogb_file,oga_file    #MOD-8C0153             	  
    #                    WHERE oga01 = ogb01
    #                    # AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6') #FUN-B80006 mark
    #                      AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6' OR oga09 = '3') #FUN-B80006
    #                      AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
    #                END IF 
    #            #CHI-B90048 ----- mark start -----
    #            #ELSE
    #            #   SELECT oeb912 INTO l_qty FROM oeb_file
    #            #    WHERE oeb01 = g_ofb[l_ac].ofb31 AND oeb03 = g_ofb[l_ac].ofb32 
    #            #CHI-B90048 ----- mark  end  -----
    #            END IF
    #            IF cl_null(l_qty) THEN 
    #               LET l_qty =0
    #            END IF   
    #            SELECT SUM(ofb912) INTO l_qty1 FROM ofb_file,ofa_file 
    #             WHERE ofb31=g_ofb[l_ac].ofb31 AND ofb32=g_ofb[l_ac].ofb32
    #               AND ofb01 =ofa01
    #               AND ofaconf !='X'
    #            IF cl_null(l_qty1) THEN 
    #               LET l_qty1 =0
    #            END IF
    #            IF p_cmd ='a' THEN
    #               LET l_qty =l_qty-l_qty1
    #            ELSE
    #               LET l_qty =l_qty-l_qty1+g_ofb_t.ofb912
    #            END IF 
    #            IF STATUS THEN
    #               CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb912",1)  #No.FUN-660167
    #               NEXT FIELD ofb912
    #            END IF
    #            IF g_ofb[l_ac].ofb912 > l_qty THEN #出貨數量大於出貨通知量
    #               CALL cl_err('sel ofb(1):','axm-246',0) NEXT FIELD ofb912   #MOD-A40138 axm-128-->axm-246
    #            END IF
    #         END IF
    #      END IF
    #      IF g_change = 'Y' THEN
    #         CALL t500_set_ofb917()
    #      END IF
    #      CALL cl_show_fld_cont()     #FUN-550037(smin)
    #FUN-910088--mark--end--
 
        BEFORE FIELD ofb916
           IF NOT cl_null(g_ofb[l_ac].ofb04) THEN
              SELECT ima25,ima31 INTO g_ima25,g_ima31
                FROM ima_file WHERE ima01=g_ofb[l_ac].ofb04
           END IF
           CALL t500_set_no_required()
 
        AFTER FIELD ofb916  #計價單位
           IF cl_null(g_ofb[l_ac].ofb04) THEN NEXT FIELD ofb04 END IF
           IF g_ofb_t.ofb916 IS NULL AND g_ofb[l_ac].ofb916 IS NOT NULL OR
              g_ofb_t.ofb916 IS NOT NULL AND g_ofb[l_ac].ofb916 IS NULL OR
              g_ofb_t.ofb916 <> g_ofb[l_ac].ofb916 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ofb[l_ac].ofb916) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ofb[l_ac].ofb916
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ofb[l_ac].ofb916,"",STATUS,"","gfe",1)  #No.FUN-660167
                 NEXT FIELD ofb916
              END IF
              CALL s_du_umfchk(g_ofb[l_ac].ofb04,'','','',
                               g_ima31,g_ofb[l_ac].ofb916,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ofb[l_ac].ofb916,g_errno,0)
                 NEXT FIELD ofb916
              END IF
           END IF
           CALL t500_set_required()
           #FUN-910088--add--start
           IF NOT cl_null(g_ofb[l_ac].ofb917) AND g_ofb[l_ac].ofb917 <> 0 THEN
              IF NOT t500_ofb917_check(p_cmd,l_qty,l_qty1) THEN
                 LET g_ofb916_t = g_ofb[l_ac].ofb916
                 NEXT FIELD ofb917
              END IF
              LET g_ofb916_t = g_ofb[l_ac].ofb916
           END IF
           #FUN-910088--add--end--

        BEFORE FIELD ofb917
           IF g_change='Y' THEN
              CALL t500_set_ofb917()
           END IF
 
        AFTER FIELD ofb917  #第二數量
           IF NOT t500_ofb917_check(p_cmd,l_qty,l_qty1) THEN NEXT FIELD ofb917 END IF  #FUN-910088--add--
       #FUN-910088--mark--start--
       #   IF NOT cl_null(g_ofb[l_ac].ofb917) THEN
       #      IF g_ofb[l_ac].ofb917 < 0 THEN
       #         CALL cl_err('','aim-391',0)  #
       #         NEXT FIELD ofb917
       #      END IF
       #      IF NOT cl_null(g_ofb[l_ac].ofb31) AND NOT cl_null(g_ofb[l_ac].ofb32)    #MOD-9B0028 
       #         AND (p_cmd ='a' OR g_ofb_t.ofb917<>g_ofb[l_ac].ofb917) THEN   #MOD-9B0028
       #         LET l_qty = 0
       #         LET l_qty1 = 0
       #         IF NOT cl_null(g_ofa.ofa011) THEN   #MOD-9B0028
       #            IF g_oaz.oaz67 = '1'  THEN
       #               SELECT SUM(ogb917) INTO l_qty FROM ogb_file,oga_file   #MOD-8C0153
       #                WHERE ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
       #                  AND oga01=ogb01
       #                  AND (oga09 = '1' OR oga09 = '5')
       #            ELSE
       #               SELECT SUM(ogb917) INTO l_qty FROM ogb_file,oga_file    #MOD-8C0153             	
       #                WHERE oga01 = ogb01
       #                #  AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')  #FUN-B80006 mark
       #                  AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6'  OR oga09 = '3')  #FUN-B80006 
       #                  AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
       #            END IF 
       #         #CHI-B90048 ----- mark start -----
       #         #ELSE
       #         #   SELECT oeb917 INTO l_qty FROM oeb_file
       #         #    WHERE oeb01 = g_ofb[l_ac].ofb31 AND oeb03 = g_ofb[l_ac].ofb32 
       #         #CHI-B90048 ----- mark  end  -----
       #         END IF
       #         IF cl_null(l_qty) THEN 
       #            LET l_qty =0
       #         END IF   
       #         SELECT SUM(ofb917) INTO l_qty1 FROM ofb_file,ofa_file 
       #          WHERE ofb31=g_ofb[l_ac].ofb31 AND ofb32=g_ofb[l_ac].ofb32
       #            AND ofb01 =ofa01
       #            AND ofaconf !='X'
       #         IF cl_null(l_qty1) THEN 
       #            LET l_qty1 =0
       #         END IF
       #         IF p_cmd ='a' THEN
       #            LET l_qty =l_qty-l_qty1
       #         ELSE
       #            LET l_qty =l_qty-l_qty1+g_ofb_t.ofb917
       #         END IF 
       #         IF STATUS THEN
       #            CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb917",1)  #No.FUN-660167
       #            NEXT FIELD ofb917
       #         END IF
       #         IF g_ofb[l_ac].ofb917 > l_qty THEN #出貨數量大於出貨通知量
       #            CALL cl_err('sel ofb(1):','axm-246',0) NEXT FIELD ofb917   #MOD-A40138 axm-128-->axm-246
       #         END IF
       #      END IF
       #   END IF
       #FUN-910088--mark--end--
 
        BEFORE FIELD ofb13
           CALL cl_digcut(g_ofb[l_ac].ofb13,t_azi03) RETURNING g_ofb[l_ac].ofb13
           DISPLAY BY NAME g_ofb[l_ac].ofb13                          
           IF g_sma.sma115 = 'Y' THEN
              CALL t500_set_origin_field()
           END IF
           IF cl_null(g_ofb[l_ac].ofb917) THEN
              LET g_ofb[l_ac].ofb916=g_ofb[l_ac].ofb05
              LET g_ofb[l_ac].ofb917=g_ofb[l_ac].ofb12
	      DISPLAY BY NAME g_ofb[l_ac].ofb916
	      DISPLAY BY NAME g_ofb[l_ac].ofb917
           END IF
 
        AFTER FIELD ofb13
           IF g_ofa.ofa213 = 'N' THEN
              LET g_ofb[l_ac].ofb14 =g_ofb[l_ac].ofb917*g_ofb[l_ac].ofb13                
              LET g_ofb[l_ac].ofb14t=g_ofb[l_ac].ofb14*(1+g_ofa.ofa211/100)
           ELSE
              LET g_ofb[l_ac].ofb14t =g_ofb[l_ac].ofb917*g_ofb[l_ac].ofb13                
              LET g_ofb[l_ac].ofb14=g_ofb[l_ac].ofb14t/(1+g_ofa.ofa211/100)
           END IF
           CALL cl_digcut(g_ofb[l_ac].ofb14,t_azi04) RETURNING g_ofb[l_ac].ofb14  
           CALL cl_digcut(g_ofb[l_ac].ofb14t,t_azi04)RETURNING g_ofb[l_ac].ofb14t 
           DISPLAY BY NAME g_ofb[l_ac].ofb14,g_ofb[l_ac].ofb14t
 
        AFTER FIELD ofbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ofb14
          IF (g_ofb[l_ac].ofb14!=g_ofb_t.ofb14 OR g_ofb_t.ofb14 IS NULL) THEN 
           CALL cl_digcut(g_ofb[l_ac].ofb14,t_azi04) RETURNING g_ofb[l_ac].ofb14
           DISPLAY BY NAME g_ofb[l_ac].ofb14                          
          END IF 

        AFTER FIELD ofb14t
          IF (g_ofb[l_ac].ofb14t!=g_ofb_t.ofb14t OR g_ofb_t.ofb14t IS NULL) THEN 
           CALL cl_digcut(g_ofb[l_ac].ofb14t,t_azi04) RETURNING g_ofb[l_ac].ofb14t
           DISPLAY BY NAME g_ofb[l_ac].ofb14t                          
          END IF 
 
        BEFORE DELETE                            #是否取消單身
            IF g_ofb_t.ofb03 > 0 AND g_ofb_t.ofb03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM ofb_file
                 WHERE ofb01 = g_ofa.ofa01 AND ofb03 = g_ofb_t.ofb03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ofb_file",g_ofa.ofa01,g_ofb_t.ofb03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                 CALL t500_bu() #No.MOD-570311
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ofb[l_ac].* = g_ofb_t.*
               CLOSE t500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF NOT cl_null(g_ofb[l_ac].ofb31) AND
               g_ofb[l_ac].ofb31[1,4] !='MISC' AND
               cl_null(g_ofb[l_ac].ofb32) THEN NEXT FIELD ofb32
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ofb[l_ac].ofb03,-263,1)
               LET g_ofb[l_ac].* = g_ofb_t.*
            ELSE
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_ofb[l_ac].ofb04) THEN
                     SELECT ima25,ima31 INTO g_ima25,g_ima31
                       FROM ima_file WHERE ima01=g_ofb[l_ac].ofb04
                  END IF
 
                  CALL s_chk_va_setting(g_ofb[l_ac].ofb04)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD ofb04
                  END IF
                  CALL s_chk_va_setting1(g_ofb[l_ac].ofb04)
                       RETURNING g_flag,g_ima908
                  IF g_flag=1 THEN
                     NEXT FIELD ofb04
                  END IF
 
                  CALL t500_du_data_to_correct()
 
                  CALL t500_set_origin_field()
               END IF
               IF cl_null(g_ofb[l_ac].ofb917) THEN
                 LET g_ofb[l_ac].ofb916=g_ofb[l_ac].ofb05
                 LET g_ofb[l_ac].ofb917=g_ofb[l_ac].ofb12
               END IF
 
               CALL t500_b_move_back()
               CALL t500_b_else()
               UPDATE ofb_file SET * = b_ofb.*
                WHERE ofb01=g_ofa.ofa01
                  AND ofb03=g_ofb_t.ofb03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ofb_file",g_ofa.ofa01,g_ofb_t.ofb03,SQLCA.sqlcode,"","upd ofb",1)  #No.FUN-660167
                  LET g_ofb[l_ac].* = g_ofb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CALL t500_bu()
	          COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ofb[l_ac].* = g_ofb_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_ofb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add
            CLOSE t500_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ofb03) AND l_ac > 1 THEN
               LET g_ofb[l_ac].* = g_ofb[l_ac-1].*
               LET g_ofb[l_ac].ofb03 = NULL
               NEXT FIELD ofb03
           END IF
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ofb31)
                   CALL q_oea(FALSE,TRUE,g_ofb[l_ac].ofb31,g_ofa.ofa03,'3')
                        RETURNING g_ofb[l_ac].ofb31
                    DISPLAY BY NAME g_ofb[l_ac].ofb31      #No.MOD-490371
                   NEXT FIELD ofb31
              WHEN INFIELD(ofb04)
#FUN-AA0059---------mod------------str-----------------              
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_ima"
#                   LET g_qryparam.default1 = g_ofb[l_ac].ofb04
#                   CALL cl_create_qry() RETURNING g_ofb[l_ac].ofb04
                    CALL q_sel_ima(FALSE, "q_ima","",g_ofb[l_ac].ofb04,"","","","","",'' ) 
                 RETURNING  g_ofb[l_ac].ofb04

#FUN-AA0059---------mod------------end-----------------
                    DISPLAY BY NAME g_ofb[l_ac].ofb04      #No.MOD-490371
                   NEXT FIELD ofb04
              WHEN INFIELD(ofb910) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ofb[l_ac].ofb910
                   CALL cl_create_qry() RETURNING g_ofb[l_ac].ofb910
                   DISPLAY BY NAME g_ofb[l_ac].ofb910
                   NEXT FIELD ofb910
 
              WHEN INFIELD(ofb913) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ofb[l_ac].ofb913
                   CALL cl_create_qry() RETURNING g_ofb[l_ac].ofb913
                   DISPLAY BY NAME g_ofb[l_ac].ofb913
                   NEXT FIELD ofb913
 
              WHEN INFIELD(ofb916) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ofb[l_ac].ofb916
                   CALL cl_create_qry() RETURNING g_ofb[l_ac].ofb916
                   DISPLAY BY NAME g_ofb[l_ac].ofb916
                   NEXT FIELD ofb916
              OTHERWISE
                   LET g_msg='axmq450 ',g_ofb[l_ac].ofb04
                   CALL cl_cmdrun(g_msg)
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
 
 
      END INPUT
 
      UPDATE ofa_file SET ofamodu = g_user,ofadate = g_today
       WHERE ofa01 = g_ofa.ofa01
 
      CLOSE t500_bcl
      COMMIT WORK
      CALL t500_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t500_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
     CALL s_get_doc_no(g_ofa.ofa01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ofa_file ",
                  "  WHERE ofa01 LIKE '",l_slip,"%' ",
                  "    AND ofa01 > '",g_ofa.ofa01,"'"
      PREPARE t500_pb1 FROM l_sql 
      EXECUTE t500_pb1 INTO l_cnt
      
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
        #CALL t500_x()   #FUN-D20025
         CALL t500_x(1)  #FUN-D20025
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ofa_file WHERE ofa01 = g_ofa.ofa01
         DELETE FROM oao_file WHERE oao01 = g_ofa.ofa01     #FUN-C60023 add
         INITIALIZE g_ofa.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION t500_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF INFIELD(ofb31)  OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ofb04,ofb05",TRUE)
       CALL cl_set_comp_entry("ofb913,ofb910,ofb916",TRUE)
    END IF
 
    CALL cl_set_comp_entry("ofb913,ofb915,ofb916,ofb917",TRUE)
 
END FUNCTION
 
FUNCTION t500_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF INFIELD(ofb31)  OR ( NOT g_before_input_done ) THEN
       IF NOT cl_null(g_ofb[l_ac].ofb31) AND g_ofb[l_ac].ofb31[1,4] !='MISC' THEN
          CALL cl_set_comp_entry("ofb04,ofb05",FALSE)
          CALL cl_set_comp_entry("ofb913,ofb910,ofb916",FALSE)
       END IF
    END IF
 
    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("ofb913,ofb914,ofb915",FALSE)
    END IF
    IF g_ima906 = '2' THEN
       CALL cl_set_comp_entry("ofb911,ofb914",FALSE)
    END IF
    #參考單位，每個料件只有一個，所以不開放讓用戶輸入
    IF g_ima906 = '3' THEN
       CALL cl_set_comp_entry("ofb913",FALSE)
    END IF
    IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
       CALL cl_set_comp_entry("ofb916,ofb917",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t500_set_required()
 
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("ofb913,ofb915,ofb910,ofb912",TRUE)
  END IF
  #單位不同,轉換率,數量必KEY
  IF NOT cl_null(g_ofb[l_ac].ofb910) THEN
     CALL cl_set_comp_required("ofb912",TRUE)
  END IF
  IF NOT cl_null(g_ofb[l_ac].ofb913) THEN
     CALL cl_set_comp_required("ofb915",TRUE)
  END IF
  IF NOT cl_null(g_ofb[l_ac].ofb916) THEN
     CALL cl_set_comp_required("ofb917",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t500_set_no_required()
 
  CALL cl_set_comp_required("ofb913,ofb914,ofb915,ofb910,ofb911,ofb912,ofb916,ofb917",FALSE)
 
END FUNCTION
 
FUNCTION t500_b_move_to()
   LET g_ofb[l_ac].ofb03 = b_ofb.ofb03
   LET g_ofb[l_ac].ofb31 = b_ofb.ofb31
   LET g_ofb[l_ac].ofb32 = b_ofb.ofb32
   LET g_ofb[l_ac].ofb04 = b_ofb.ofb04
   LET g_ofb[l_ac].ofb06 = b_ofb.ofb06
   LET g_ofb[l_ac].ofb05 = b_ofb.ofb05
   LET g_ofb[l_ac].ofb12 = b_ofb.ofb12
   LET g_ofb[l_ac].ofb13 = b_ofb.ofb13
   LET g_ofb[l_ac].ofb14 = b_ofb.ofb14
   LET g_ofb[l_ac].ofb14t= b_ofb.ofb14t   #MOD-9C0422
   LET g_ofb[l_ac].ofb11 = b_ofb.ofb11
   LET g_ofb[l_ac].ofb33 = b_ofb.ofb33
   LET g_ofb[l_ac].ofb910= b_ofb.ofb910
   LET g_ofb[l_ac].ofb911= b_ofb.ofb911
   LET g_ofb[l_ac].ofb912= b_ofb.ofb912
   LET g_ofb[l_ac].ofb913= b_ofb.ofb913
   LET g_ofb[l_ac].ofb914= b_ofb.ofb914
   LET g_ofb[l_ac].ofb915= b_ofb.ofb915
   LET g_ofb[l_ac].ofb916= b_ofb.ofb916
   LET g_ofb[l_ac].ofb917= b_ofb.ofb917
   LET g_ofb[l_ac].ofbud01 = b_ofb.ofbud01
   LET g_ofb[l_ac].ofbud02 = b_ofb.ofbud02
   LET g_ofb[l_ac].ofbud03 = b_ofb.ofbud03
   LET g_ofb[l_ac].ofbud04 = b_ofb.ofbud04
   LET g_ofb[l_ac].ofbud05 = b_ofb.ofbud05
   LET g_ofb[l_ac].ofbud06 = b_ofb.ofbud06
   LET g_ofb[l_ac].ofbud07 = b_ofb.ofbud07
   LET g_ofb[l_ac].ofbud08 = b_ofb.ofbud08
   LET g_ofb[l_ac].ofbud09 = b_ofb.ofbud09
   LET g_ofb[l_ac].ofbud10 = b_ofb.ofbud10
   LET g_ofb[l_ac].ofbud11 = b_ofb.ofbud11
   LET g_ofb[l_ac].ofbud12 = b_ofb.ofbud12
   LET g_ofb[l_ac].ofbud13 = b_ofb.ofbud13
   LET g_ofb[l_ac].ofbud14 = b_ofb.ofbud14
   LET g_ofb[l_ac].ofbud15 = b_ofb.ofbud15
END FUNCTION
 
FUNCTION t500_b_move_back()
   LET b_ofb.ofb03 = g_ofb[l_ac].ofb03
   LET b_ofb.ofb31 = g_ofb[l_ac].ofb31
   LET b_ofb.ofb32 = g_ofb[l_ac].ofb32
   LET b_ofb.ofb04 = g_ofb[l_ac].ofb04
   LET b_ofb.ofb06 = g_ofb[l_ac].ofb06
   LET b_ofb.ofb05 = g_ofb[l_ac].ofb05
   LET b_ofb.ofb12 = g_ofb[l_ac].ofb12
   LET b_ofb.ofb13 = g_ofb[l_ac].ofb13
   LET b_ofb.ofb14 = g_ofb[l_ac].ofb14
   LET b_ofb.ofb14t= g_ofb[l_ac].ofb14t   #MOD-9C0422
   LET b_ofb.ofb11 = g_ofb[l_ac].ofb11
   LET b_ofb.ofb33 = g_ofb[l_ac].ofb33
   LET b_ofb.ofb910= g_ofb[l_ac].ofb910
   LET b_ofb.ofb911= g_ofb[l_ac].ofb911
   LET b_ofb.ofb912= g_ofb[l_ac].ofb912
   LET b_ofb.ofb913= g_ofb[l_ac].ofb913
   LET b_ofb.ofb914= g_ofb[l_ac].ofb914
   LET b_ofb.ofb915= g_ofb[l_ac].ofb915
   LET b_ofb.ofb916= g_ofb[l_ac].ofb916
   LET b_ofb.ofb917= g_ofb[l_ac].ofb917
   LET b_ofb.ofbud01 = g_ofb[l_ac].ofbud01
   LET b_ofb.ofbud02 = g_ofb[l_ac].ofbud02
   LET b_ofb.ofbud03 = g_ofb[l_ac].ofbud03
   LET b_ofb.ofbud04 = g_ofb[l_ac].ofbud04
   LET b_ofb.ofbud05 = g_ofb[l_ac].ofbud05
   LET b_ofb.ofbud06 = g_ofb[l_ac].ofbud06
   LET b_ofb.ofbud07 = g_ofb[l_ac].ofbud07
   LET b_ofb.ofbud08 = g_ofb[l_ac].ofbud08
   LET b_ofb.ofbud09 = g_ofb[l_ac].ofbud09
   LET b_ofb.ofbud10 = g_ofb[l_ac].ofbud10
   LET b_ofb.ofbud11 = g_ofb[l_ac].ofbud11
   LET b_ofb.ofbud12 = g_ofb[l_ac].ofbud12
   LET b_ofb.ofbud13 = g_ofb[l_ac].ofbud13
   LET b_ofb.ofbud14 = g_ofb[l_ac].ofbud14
   LET b_ofb.ofbud15 = g_ofb[l_ac].ofbud15
END FUNCTION
 
FUNCTION t500_b_else()
 
   #No.FUN-540049  用計價數量計算
      IF g_ofa.ofa213 = 'N' THEN
          LET b_ofb.ofb14 =b_ofb.ofb917*b_ofb.ofb13                    #MOD-970215   #MOD-9B0028 取消mark
         LET b_ofb.ofb14t=b_ofb.ofb14*(1+g_ofa.ofa211/100)
      ELSE
          LET b_ofb.ofb14t=b_ofb.ofb917*b_ofb.ofb13                    #MOD-970215   #MOD-9B0028 取消mark
         LET b_ofb.ofb14 =b_ofb.ofb14t/(1+g_ofa.ofa211/100)
      END IF
 
   CALL cl_digcut(b_ofb.ofb14,t_azi04) RETURNING b_ofb.ofb14  #No.CHI-6A0004
   CALL cl_digcut(b_ofb.ofb14t,t_azi04)RETURNING b_ofb.ofb14t #No.CHI-6A0004
 
END FUNCTION
 
FUNCTION t500_bu()
 
    LET g_ofa.ofa50 = NULL
 
    SELECT SUM(ofb14) INTO g_ofa.ofa50 FROM ofb_file WHERE ofb01 = g_ofa.ofa01
    IF cl_null(g_ofa.ofa50) THEN LET g_ofa.ofa50 = 0 END IF
 
    UPDATE ofa_file SET (ofa50)=(g_ofa.ofa50)
     WHERE ofa01 = g_ofa.ofa01
    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err3("upd","ofa_file",g_ofa.ofa01,"",SQLCA.SQLCODE,"","_bu()upd ofa",1)  #No.FUN-660167
    END IF
    DISPLAY BY NAME g_ofa.ofa50
 
END FUNCTION
 
FUNCTION t500_delall()
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM ofa_file WHERE ofa01 = g_ofa.ofa01
    END IF
END FUNCTION
 
FUNCTION t500_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON ofb03,ofb31,ofb32,ofb04,ofb06,ofb05,
                       ofb913,ofb910,ofb916
            FROM s_ofb[1].ofb03, s_ofb[1].ofb31, s_ofb[1].ofb32,
                 s_ofb[1].ofb04, s_ofb[1].ofb06, s_ofb[1].ofb05,
                 s_ofb[1].ofb913,s_ofb[1].ofb910,s_ofb[1].ofb916
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(ofb913)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ofb[1].ofb913
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofb913
                   NEXT FIELD ofb913
              WHEN INFIELD(ofb910)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ofb[1].ofb910
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofb910
                   NEXT FIELD ofb910
              WHEN INFIELD(ofb916)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ofb[1].ofb916
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ofb916
                   NEXT FIELD ofb916
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t500_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t500_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql =
        "SELECT ofb03,ofb31,ofb32,ofb04,ofb06,ima021,ofb05,",
        "       ofb12,ofb913,ofb914,ofb915,ofb910,ofb911,ofb912,",
        "       ofb916,ofb917,ofb13,ofb14,ofb14t,ofb11,ofb33, ",   #MOD-9C0422 add ofb14t
        "       ofbud01,ofbud02,ofbud03,ofbud04,ofbud05,",
        "       ofbud06,ofbud07,ofbud08,ofbud09,ofbud10,",
        "       ofbud11,ofbud12,ofbud13,ofbud14,ofbud15", 
        " FROM ofb_file LEFT OUTER JOIN ima_file ON ofb_file.ofb04=ima_file.ima01 ",
        " WHERE ofb01 ='",g_ofa.ofa01,"'",  #單頭
        " AND ",p_wc2 CLIPPED,              #單身
        " ORDER BY 1"
 
    PREPARE t500_pb FROM g_sql
    DECLARE ofb_curs                        #CURSOR
        CURSOR FOR t500_pb
 
    CALL g_ofb.clear()
 
    LET g_cnt = 1
    FOREACH ofb_curs INTO g_ofb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_ofb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ofb TO s_ofb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION info_list                 #FUN-CB0014
         LET g_action_flag="info_list"    #FUN-CB0014
         EXIT DISPLAY                     #FUN-CB0014

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
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        CALL t500_def_form()   #FUN-610006
         #CKP
         IF g_ofa.ofaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_ofa.ofaconf,"","","",g_chr,"")
         EXIT DISPLAY
 
      ON ACTION first
         CALL t500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t500_fetch('L')
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
#@    ON ACTION 文件地址
      ON ACTION address
         LET g_action_choice="address"
         EXIT DISPLAY
#@    ON ACTION 列印條件
      ON ACTION prtg_condition
         LET g_action_choice="prtg_condition"
         EXIT DISPLAY
#@    ON ACTION 嘜頭維護
      ON ACTION maintain_mark
         LET g_action_choice="maintain_mark"
         EXIT DISPLAY
#@    ON ACTION 包裝單
      ON ACTION packing_list
         LET g_action_choice="packing_list"
         EXIT DISPLAY
#@    ON ACTION 訂單相關查詢
      ON ACTION order_query
         LET g_action_choice="order_query"
         EXIT DISPLAY
#@    ON ACTION 客戶相關查詢
      ON ACTION query_customer
         LET g_action_choice="query_customer"
         EXIT DISPLAY
#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025-add--str--
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20025-add--end--
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      #FUN-C90100--add--str--
      ON ACTION invoice_558
         LET g_action_choice="invoice_558"
         EXIT DISPLAY
      #FUN-C90100--add--end--
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
#FUN-CB0014 -------------------Begin-------------------
FUNCTION t500_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ofa_1 TO s_ofa_1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL fgl_set_arr_curr(g_curs_index)
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         LET g_curs_index = l_ac1
         CALL cl_show_fld_cont()                 
 
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
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   
        CALL t500_def_form()   
         #CKP
        IF g_ofa.ofaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        CALL cl_set_field_pic(g_ofa.ofaconf,"","","",g_chr,"")
        EXIT DISPLAY

      ON ACTION main
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL t500_fetch('/')
         END IF
         CALL cl_set_comp_visible("page1", FALSE)
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1", TRUE)
         CALL cl_set_comp_visible("page2", TRUE)
         EXIT DISPLAY
         
      ON ACTION accept
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         CALL t500_fetch('/')
         CALL cl_set_comp_visible("page2", FALSE)
         CALL cl_set_comp_visible("page2", TRUE)
         CALL cl_set_comp_visible("page1", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1", TRUE)
         EXIT DISPLAY        
 
     ON ACTION first
         CALL t500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
           ACCEPT DISPLAY                   
 
 
      ON ACTION previous
         CALL t500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION jump
         CALL t500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION next
         CALL t500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index) 
         END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION last
         CALL t500_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	ACCEPT DISPLAY                   
 
      #TQC-D10084--mark--str--
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
      #TQC-D10084--mark--end--
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             
         CALL cl_set_head_visible("","AUTO")           
 
#@    ON ACTION 文件地址
      ON ACTION address
         LET g_action_choice="address"
         EXIT DISPLAY
#@    ON ACTION 列印條件
      ON ACTION prtg_condition
         LET g_action_choice="prtg_condition"
         EXIT DISPLAY
#@    ON ACTION 嘜頭維護
      ON ACTION maintain_mark
         LET g_action_choice="maintain_mark"
         EXIT DISPLAY
#@    ON ACTION 包裝單
      ON ACTION packing_list
         LET g_action_choice="packing_list"
         EXIT DISPLAY
#@    ON ACTION 訂單相關查詢
      ON ACTION order_query
         LET g_action_choice="order_query"
         EXIT DISPLAY
#@    ON ACTION 客戶相關查詢
      ON ACTION query_customer
         LET g_action_choice="query_customer"
         EXIT DISPLAY
#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025-add--str--
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20025-add--end--
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION t500_list_fill()
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_ofa01        LIKE ofa_file.ofa01
DEFINE l_buf          LIKE type_file.chr1000
   CALL g_ofa_1.clear()

   LET l_cnt = 1
   FOREACH t500_fill_cs INTO l_ofa01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      SELECT ofa00,ofa08,ofa01,'',ofa02,ofa011,ofa16,ofa03,ofa032,ofa04,occ02,ofa10,
             ofa31,oah02,ofa32,oag02,ofaconf
        INTO g_ofa_1[l_cnt].*
        FROM ofa_file LEFT OUTER JOIN occ_file ON ofa04 = occ01
                      LEFT OUTER JOIN oah_file ON ofa31 = oah01 
                      LEFT OUTER JOIN oag_file ON ofa32 = oag01
       WHERE ofa01 = l_ofa01
       LET l_buf = s_get_doc_no(l_ofa01)  
       SELECT oaydesc INTO g_ofa_1[l_cnt].oaydesc_1 FROM oay_file WHERE oayslip=l_buf
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
          IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_cnt - 1

    DISPLAY ARRAY g_ofa_1 TO s_ofa_1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION
#FUN-CB0014 -------------------End---------------------

#CHI-AB0029 mark 因No.MOD-480183 把t500_out()內容提到menu段,故此FUNCTION可mark --start--
#FUNCTION t500_out()
#    DEFINE l_wc     LIKE type_file.chr1000      #No.TQC-610089 add        #No.FUN-680137 VARCHAR(200)
# 
#   DEFINE l_no     LIKE oea_file.oea01        # No.FUN-680137 VARCHAR(16)      #No.FUN-550018
# 
#    IF g_ofa.ofa01 IS NULL THEN RETURN END IF
#    LET l_no=g_ofa.ofa01
# 
#    OPEN WINDOW t600_out_w1 AT 10,9
#         WITH 2 ROWS, 60 COLUMNS
#    CALL cl_set_win_title("t600_out_w1")
#    MENU ""
#       ON ACTION invoice
#          LET l_wc='ofa01="',l_no,'"'
#          LET g_msg = "axmr550",
#                       " '",g_today CLIPPED,"' ''",
#                       " '",g_lang CLIPPED,"' 'Y' '' '1'",
#                       " '",l_wc CLIPPED,"' "
#          CALL cl_cmdrun(g_msg)
# 
#       ON ACTION packing_list
#          LET l_wc='ofa01="',l_no,'"'
#          LET g_msg = "axmr552",
#                       " '",g_today CLIPPED,"' ''",
#                       " '",g_lang CLIPPED,"' 'Y' '' '1'",
#                       " '",l_wc CLIPPED,"' "
#          CALL cl_cmdrun(g_msg)
# 
# 
#       ON ACTION exit
#          EXIT MENU
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE MENU
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
# 
#        -- for Windows close event trapped
#        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
#             LET INT_FLAG=FALSE 		#MOD-570244	mars
#            LET g_action_choice = "exit"
#            EXIT MENU
# 
#    END MENU
# 
#    CLOSE WINDOW t600_out_w1
# 
#END FUNCTION
#CHI-AB0029 mark 因No.MOD-480183 把t500_out()內容提到menu段,故此FUNCTION可mark --end--
 
FUNCTION t500_1()
 
    BEGIN WORK
 
    OPEN t500_cl USING g_ofa.ofa01
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t500_cl INTO g_ofa.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofa.ofa01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
 
    IF g_ofa.ofa01 IS NULL THEN RETURN END IF
 
    LET p_row = 1 LET p_col = 11
    OPEN WINDOW t5001_w AT p_row,p_col WITH FORM "axm/42f/axmt5001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt5001")
 
    LET g_buf=NULL
    SELECT oac02 INTO g_buf FROM oac_file WHERE oac01=g_ofa.ofa41
                            DISPLAY g_buf TO oac02 LET g_buf=NULL
    SELECT oac02 INTO g_buf FROM oac_file WHERE oac01=g_ofa.ofa42
                            DISPLAY g_buf TO oac02_2 LET g_buf=NULL
    SELECT oah02 INTO g_buf FROM oah_file WHERE oah01=g_ofa.ofa31
                            DISPLAY g_buf TO oah02 LET g_buf=NULL
    SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_ofa.ofa32
                            DISPLAY g_buf TO oag02 LET g_buf=NULL
 
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       DISPLAY BY NAME
                  g_ofa.ofa0351,g_ofa.ofa0352,g_ofa.ofa0353,
                  g_ofa.ofa0354,g_ofa.ofa0355,
                  g_ofa.ofa0356,g_ofa.ofa0357,       #FUN-C10048 add
                  g_ofa.ofa0451,g_ofa.ofa0452,
                  g_ofa.ofa0453,g_ofa.ofa0454,g_ofa.ofa0455,
                  g_ofa.ofa0456,g_ofa.ofa0457,       #FUN-C10048 add
                  g_ofa.ofa41,g_ofa.ofa42,g_ofa.ofa43,
                  g_ofa.ofa47,g_ofa.ofa48,g_ofa.ofa49,
                  g_ofa.ofa31,g_ofa.ofa32,g_ofa.ofa33,
                  g_ofa.ofa63
            LET INT_FLAG = 0  ######add for prompt bug
       PROMPT ">" FOR CHAR g_chr
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END PROMPT
       CLOSE WINDOW t5001_w
       RETURN
    END IF
 
    INPUT BY NAME g_ofa.ofa0351,g_ofa.ofa0352,g_ofa.ofa0353,
                  g_ofa.ofa0354,g_ofa.ofa0355,
                  g_ofa.ofa0356,g_ofa.ofa0357,       #FUN-C10048 add
                  g_ofa.ofa0451,g_ofa.ofa0452,
                  g_ofa.ofa0453,g_ofa.ofa0454,g_ofa.ofa0455,
                  g_ofa.ofa0456,g_ofa.ofa0457,       #FUN-C10048 add
                  g_ofa.ofa41,g_ofa.ofa42,g_ofa.ofa43,
                  g_ofa.ofa47,g_ofa.ofa48,g_ofa.ofa49,
                  g_ofa.ofa31,g_ofa.ofa32,g_ofa.ofa33,
                  g_ofa.ofa63
          WITHOUT DEFAULTS
 
     BEFORE INPUT 
       IF g_ofa.ofaconf = 'Y' THEN 
          CALL cl_set_comp_entry("ofa31,ofa32,ofa33,ofa63",FALSE)
       END IF  
 
      BEFORE FIELD ofa0351
         IF g_ofa.ofa0351 IS NULL THEN
            CALL t500_ofa0351()
            DISPLAY BY NAME g_ofa.ofa0351,g_ofa.ofa0352,g_ofa.ofa0353,
                            g_ofa.ofa0354,g_ofa.ofa0355,
                            g_ofa.ofa0356,g_ofa.ofa0357        #FUN-C10048 add
         END IF
 
      BEFORE FIELD ofa0451
         IF g_ofa.ofa0451 IS NULL THEN
            CALL t500_ofa0451()
            DISPLAY BY NAME g_ofa.ofa0451,g_ofa.ofa0452,g_ofa.ofa0453,
                            g_ofa.ofa0454,g_ofa.ofa0455,
                            g_ofa.ofa0456,g_ofa.ofa0457        #FUN-C10048 add
         END IF
 
      AFTER FIELD ofa41
         IF NOT cl_null(g_ofa.ofa41) THEN
            SELECT oac02 INTO g_buf FROM oac_file
             WHERE oac01=g_ofa.ofa41
            IF STATUS THEN
               CALL cl_err3("sel","oac_file",g_ofa.ofa41,"",STATUS,"","sel oac",1)  #No.FUN-660167
               NEXT FIELD ofa41
            END IF
            DISPLAY g_buf TO oac02
         END IF
 
      AFTER FIELD ofa42
         IF NOT cl_null(g_ofa.ofa42) THEN
            SELECT oac02 INTO g_buf FROM oac_file
             WHERE oac01=g_ofa.ofa42
            IF STATUS THEN
               CALL cl_err3("sel","oac_file",g_ofa.ofa42,"",STATUS,"","sel oac",1)  #No.FUN-660167
               NEXT FIELD ofa42
            END IF
            DISPLAY g_buf TO oac02_2
         END IF
 
      AFTER FIELD ofa43
         IF NOT cl_null(g_ofa.ofa43) THEN
            SELECT * FROM ged_file WHERE ged01 = g_ofa.ofa43
            IF STATUS THEN
               CALL cl_err3("sel","ged_file",g_ofa.ofa43,"",SQLCA.sqlcode,"","",1)  
               NEXT FIELD ofa43
            END IF
         END IF
 
      AFTER FIELD ofa31
         IF NOT cl_null(g_ofa.ofa31) THEN
            SELECT oah02 INTO g_buf FROM oah_file
             WHERE oah01=g_ofa.ofa31
            IF STATUS THEN
               CALL cl_err3("sel","oah_file",g_ofa.ofa31,"",STATUS,"","sel oah",1)  #No.FUN-660167
               NEXT FIELD ofa31
            END IF
            DISPLAY g_buf TO oah02
         END IF
 
      AFTER FIELD ofa32
         IF NOT cl_null(g_ofa.ofa32) THEN
            SELECT oag02 INTO g_buf FROM oag_file
             WHERE oag01=g_ofa.ofa32
            IF STATUS THEN
               CALL cl_err3("sel","oag_file",g_ofa.ofa32,"",STATUS,"","sel oag",1)  #No.FUN-660167
               NEXT FIELD ofa32
            END IF
            DISPLAY g_buf TO oag02
         END IF
 
      ON KEY(F1) NEXT FIELD ofa0351
      ON KEY(F2) NEXT FIELD ofa41
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ofa41)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.default1 = g_ofa.ofa41
                 CALL cl_create_qry() RETURNING g_ofa.ofa41
                 DISPLAY BY NAME g_ofa.ofa41 NEXT FIELD ofa41
            WHEN INFIELD(ofa42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.default1 = g_ofa.ofa42
                 CALL cl_create_qry() RETURNING g_ofa.ofa42
                 DISPLAY BY NAME g_ofa.ofa42 NEXT FIELD ofa42
            WHEN INFIELD(ofa43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ged"
                 LET g_qryparam.default1 = g_ofa.ofa43
                 CALL cl_create_qry() RETURNING g_ofa.ofa43
                 DISPLAY BY NAME g_ofa.ofa43 
                 NEXT FIELD ofa43
            WHEN INFIELD(ofa31)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oah"
                 LET g_qryparam.default1 = g_ofa.ofa31
                 CALL cl_create_qry() RETURNING g_ofa.ofa31
                 DISPLAY BY NAME g_ofa.ofa31 NEXT FIELD ofa31
            WHEN INFIELD(ofa32)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oag"
                 LET g_qryparam.default1 = g_ofa.ofa32
                 CALL cl_create_qry() RETURNING g_ofa.ofa32
                 DISPLAY BY NAME g_ofa.ofa32 NEXT FIELD ofa32
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
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW t5001_w
       RETURN
    END IF
    CLOSE WINDOW t5001_w
 
    UPDATE ofa_file SET * = g_ofa.* WHERE ofa01 = g_ofa.ofa01
    IF SQLCA.SQLCODE THEN
        CALL cl_err3("upd","ofa_file",g_ofa.ofa01,"",SQLCA.SQLCODE,"","update ofa",1)  #No.FUN-660167
         ROLLBACK WORK      #MOD-510101
    ELSE
        COMMIT WORK
    END IF
 
END FUNCTION
 
FUNCTION t500_2()
 
    IF g_ofa.ofa01 IS NULL THEN RETURN END IF
 
    LET p_row = 2 LET p_col = 11
    OPEN WINDOW t5002_w AT p_row,p_col WITH FORM "axm/42f/axmt5002"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt5002")
 
 
    INPUT BY NAME g_ofa.ofa71,g_ofa.ofa72,g_ofa.ofa73,
                  g_ofa.ofa741,g_ofa.ofa742,g_ofa.ofa743,g_ofa.ofa75
          WITHOUT DEFAULTS
 
      AFTER FIELD ofa741
          IF NOT cl_null(g_ofa.ofa741) THEN
             SELECT oae02 FROM oae_file WHERE oae01=g_ofa.ofa741
             IF STATUS THEN
                CALL cl_err3("sel","oae_file",g_ofa.ofa741,"",STATUS,"","sel oae",1)  #No.FUN-660167
                NEXT FIELD ofa741
             END IF
          END IF
 
      AFTER FIELD ofa742
          IF NOT cl_null(g_ofa.ofa742) THEN
             SELECT oae02 FROM oae_file WHERE oae01=g_ofa.ofa742
             IF STATUS THEN
                CALL cl_err3("sel","oae_file",g_ofa.ofa742,"",STATUS,"","sel oae",1)  #No.FUN-660167
                NEXT FIELD ofa742
             END IF
          END IF
 
      AFTER FIELD ofa743
          IF NOT cl_null(g_ofa.ofa743) THEN
             SELECT oae02 FROM oae_file WHERE oae01=g_ofa.ofa743
             IF STATUS THEN
                CALL cl_err3("sel","oae_file",g_ofa.ofa743,"",STATUS,"","sel oae",1)  #No.FUN-660167
                NEXT FIELD ofa743
             END IF
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
       LET INT_FLAG=0
       CLOSE WINDOW t5002_w
       RETURN
    END IF
 
    CLOSE WINDOW t5002_w
 
    UPDATE ofa_file SET * = g_ofa.* WHERE ofa01 = g_ofa.ofa01
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("upd","ofa_file",g_ofa.ofa01,"",SQLCA.SQLCODE,"","update ofa",1)  #No.FUN-660167
    END IF
 
END FUNCTION
 
FUNCTION t500_m()
   IF g_ofa.ofa01 IS NULL THEN RETURN END IF
 
   LET g_action_choice="modify"
   IF NOT cl_chk_act_auth() THEN
      LET g_chr='d'
   ELSE
      LET g_chr='u'
   END IF
 
   CALL s_axm_memo(g_ofa.ofa01,0,g_chr)
 
END FUNCTION
 
FUNCTION t500_y() 			# when g_ofa.ofaconf='N' (Turn to 'Y')
   DEFINE g_start,g_end		LIKE faj_file.faj02        # No.FUN-680137 VARCHAR(10)
   DEFINE l_cnt           LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_ofb12         LIKE ofb_file.ofb12        #MOD-AC0062 
   
#CHI-C30107 -------------- add -------------- begin
   IF g_ofa.ofaconf='Y' THEN RETURN END IF
   IF g_ofa.ofaconf = 'X' THEN CALL cl_err(g_ofa.ofa01,'9024',0) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------------- add -------------- end
   SELECT * INTO g_ofa.* FROM ofa_file WHERE ofa01 = g_ofa.ofa01
   IF g_ofa.ofaconf='Y' THEN RETURN END IF
   IF g_ofa.ofaconf = 'X' THEN CALL cl_err(g_ofa.ofa01,'9024',0) RETURN END IF
 
#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM ofb_file
    WHERE ofb01=g_ofa.ofa01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

#MOD-AC0062 --begin--
  DECLARE t500_curs CURSOR FOR 
   SELECT ofb12 FROM ofb_file
    WHERE ofb01 = g_ofa.ofa01
  FOREACH t500_curs INTO l_ofb12 
    IF l_ofb12 = 0 THEN 
       CALL cl_err('','axm-329',0)
       RETURN 
    END IF  
  END FOREACH  
#MOD-AC0062 --end--
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
 
   BEGIN WORK
 
   OPEN t500_cl USING g_ofa.ofa01
   IF STATUS THEN
      CALL cl_err("OPEN t500_cl:", STATUS, 1)
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t500_cl INTO g_ofa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ofa.ofa01,SQLCA.sqlcode,0)
      CLOSE t500_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t500_y1()
   IF g_success = 'Y' THEN
      LET g_ofa.ofaconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_ofa.ofa01,'Y')
      DISPLAY BY NAME g_ofa.ofaconf
   ELSE
      LET g_ofa.ofaconf='N'
      ROLLBACK WORK
   END IF
    #CKP
    IF g_ofa.ofaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_ofa.ofaconf,"","","",g_chr,"")
 
END FUNCTION
 
FUNCTION t500_z() 			# when g_ofa.ofaconf='Y' (Turn to 'N')
   DEFINE l_n LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   SELECT * INTO g_ofa.* FROM ofa_file WHERE ofa01 = g_ofa.ofa01
   IF g_ofa.ofaconf='N' THEN RETURN END IF
   IF g_ofa.ofaconf = 'X' THEN CALL cl_err(g_ofa.ofa01,'9024',0) RETURN END IF
   IF NOT cl_null(g_ofa.ofa99) THEN CALL cl_err(g_ofa.ofa01,'axm-316',1) RETURN END IF #MOD-7C0190 add
  
   SELECT COUNT(*) INTO l_n FROM oga_file
       WHERE oga27    = g_ofa.ofa01
       #  AND (oga09='2' OR oga09='4' OR oga09='6' OR  oga09='8')  #No.8797  #No.FUN-610079  #FUN-B80006  mark
         AND (oga09='2' OR oga09='4' OR oga09='6' OR  oga09='8' OR  oga09='3')  #No.8797  #No.FUN-610079  #FUN-B80006  
     #   AND (oga10 IS NOT NULL OR oga10 <>'')  #CHI-690069
         AND (oga10 IS NOT NULL AND oga10 <>' ')  #MOD-B60252
         AND ogaconf != 'X'
   IF l_n >0 THEN
       CALL cl_err(g_ofa.ofa01,'axm-048',0)    #CHI-690069
       RETURN
   END IF
 
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF

   #MOD-C60193 add start ----
   SELECT COUNT(*) INTO l_n FROM olc_file WHERE olc01 = g_ofa.ofa01
   IF l_n > 0 THEN
       CALL cl_err(g_ofa.ofa01,'axr-039',0)
       RETURN
   END IF
   #MOD-C60193 add end  ----
 
   BEGIN WORK
 
   OPEN t500_cl USING g_ofa.ofa01
   IF STATUS THEN
      CALL cl_err("OPEN t500_cl:", STATUS, 1)
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t500_cl INTO g_ofa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ofa.ofa01,SQLCA.sqlcode,0)
      CLOSE t500_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success = 'Y'
   CALL t500_z1()
   IF g_success = 'Y' THEN
      LET g_ofa.ofaconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_ofa.ofaconf
   ELSE
      LET g_ofa.ofaconf='Y'
      ROLLBACK WORK
   END IF
    #CKP
    IF g_ofa.ofaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_ofa.ofaconf,"","","",g_chr,"")
 
END FUNCTION
 
FUNCTION t500_y1()
   DEFINE l_oga10 LIKE oga_file.oga10   #CHI-B50046 add
   DEFINE l_cnt   LIKE type_file.num5   #CHI-C20027 add

   UPDATE ofa_file SET ofaconf = 'Y' WHERE ofa01 = g_ofa.ofa01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ofa_file",g_ofa.ofa01 ,"",SQLCA.SQLCODE,"","upd ofaconf",1)  #No.FUN-660167
      LET g_success = 'N' RETURN
   END IF
   IF NOT cl_null(g_ofa.ofa011) THEN
      #CHI-C20027 add begin---
      SELECT COUNT(*) INTO l_cnt 
        FROM oma_file
       WHERE oma16 = g_ofa.ofa011
         AND omaconf='Y' AND omavoid='N'

      IF l_cnt > 0 THEN
         UPDATE oga_file SET oga27 = g_ofa.ofa01
          WHERE oga01 = g_ofa.ofa011
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   # NO.MOD-660003
            CALL cl_err3("upd","oga_file",g_ofa.ofa011,"",STATUS,"","upd oga27",1)  #No.FUN-660167
            LET g_success = 'N' RETURN
         END IF
      ELSE
      #CHI-C20027 add end-----
         UPDATE oga_file SET oga27 = g_ofa.ofa01,
                             oga54 = oga54 + g_ofa.ofa50   #MOD-A80092     
          WHERE oga01 = g_ofa.ofa011
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   # NO.MOD-660003
            CALL cl_err3("upd","oga_file",g_ofa.ofa011,"",STATUS,"","upd oga27",1)  #No.FUN-660167
            LET g_success = 'N' RETURN
         END IF
      END IF    #CHI-C20027 add

      #CHI-B50046 add --start--
      SELECT oga10 INTO l_oga10 FROM oga_file
       WHERE oga01 = g_ofa.ofa011
      IF NOT cl_null(l_oga10) THEN
         UPDATE oma_file SET oma67 = g_ofa.ofa01 
          WHERE oma01 = l_oga10
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("upd","oma_file",l_oga10,"",STATUS,"","upd oma67",1)
            LET g_success = 'N' RETURN
         END IF
      END IF
      #CHI-B50046 add --end--
   END IF
   #TQC-AB0259 add --------begin---------
   SELECT * INTO g_oea.* FROM oea_file
    WHERE oea01=g_ofb[l_ac].ofb31
   IF g_oea.oea08 != g_ofa.ofa08 THEN	#國內外不符
      CALL cl_err('sel oea','axm-125',0) 
      LET g_success = 'N' RETURN
   END IF
   #TQC-AB0259 add ---------end----------
END FUNCTION
 
FUNCTION t500_z1()
   DEFINE l_oga27 LIKE oga_file.oga27   #MOD-A80092
   DEFINE l_cnt   LIKE type_file.num5   #CHI-C20027 add

   UPDATE ofa_file SET ofaconf = 'N' WHERE ofa01 = g_ofa.ofa01
   IF NOT cl_null(g_ofa.ofa011) THEN
      #-----MOD-A80092---------
      #UPDATE oga_file SET oga27 = null 
      # WHERE oga01 = g_ofa.ofa011
      LET l_oga27 = ''
      SELECT MAX(ofa01) INTO l_oga27 FROM ofa_file
        WHERE ofa011 = g_ofa.ofa011
          AND ofaconf = 'Y'
      #CHI-C20027 add begin---
      SELECT COUNT(*) INTO l_cnt 
        FROM oma_file
       WHERE oma16 = g_ofa.ofa011
         AND omaconf='Y' AND omavoid='N'

      IF l_cnt > 0 THEN
         UPDATE oga_file SET oga27 = l_oga27 
          WHERE oga01 = g_ofa.ofa011
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   # NO.MOD-660003
            CALL cl_err3("upd","oga_file",g_ofa.ofa011,"",STATUS,"","upd oga27",1)  #No.FUN-660167
            LET g_success = 'N' RETURN
         END IF
      ELSE
      #CHI-C20027 add end-----
         UPDATE oga_file SET oga27 = l_oga27,
                             oga54 = oga54 - g_ofa.ofa50    
          WHERE oga01 = g_ofa.ofa011
         #-----END MOD-A80092-----
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   # NO.MOD-660003
            CALL cl_err3("upd","oga_file",g_ofa.ofa011,"",STATUS,"","upd oga27",1)  #No.FUN-660167
            LET g_success='N' RETURN
         END IF
      END IF   #CHI-C20027 add 
   END IF
END FUNCTION
 
#01/08/06 mandy 新增作廢/作廢還原功能
#FUNCTION t500_x()        #FUN-D20025
FUNCTION t500_x(p_type)   #FUN-D20025
   DEFINE l_n LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE p_type    LIKE type_file.num5     #FUN-D20025
   DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_ofa.* FROM ofa_file WHERE ofa01=g_ofa.ofa01
   IF g_ofa.ofa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_ofa.ofaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
 
   #此INVOICE 在"三角貿易出貨單維護作業"有記錄不可作廢!
   SELECT COUNT(*) INTO l_n FROM oga_file
       WHERE oga27    = g_ofa.ofa01
         AND ogaconf != 'X'
       #  AND (oga09='2' OR oga09='4' OR oga09='6' OR oga09='8')  #No.8797  #No.FUN-610079  #FUN-B80006  mark
        AND (oga09='2' OR oga09='4' OR oga09='6' OR oga09='8' OR oga09='3')  #No.8797  #No.FUN-610079  #FUN-B80006  
   IF l_n >0 THEN
       #此INVOICE 在"三角貿易出貨單維護作業"有記錄不可作廢!
       CALL cl_err(g_ofa.ofa01,'axm-011',0)
       RETURN
   END IF
   
   #FUN-D20025--add--str--
   IF p_type = 1 THEN 
      IF g_ofa.ofaconf='X' THEN RETURN END IF
   ELSE
      IF g_ofa.ofaconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20025--add--end--
   BEGIN WORK
 
   OPEN t500_cl USING g_ofa.ofa01
   IF STATUS THEN
      CALL cl_err("OPEN t500_cl:", STATUS, 1)
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t500_cl INTO g_ofa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ofa.ofa01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
   END IF
 
  #IF cl_void(0,0,g_ofa.ofaconf) THEN   #FUN-D20032
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
   IF cl_void(0,0,l_flag) THEN         #FUN-D20025
       LET g_chr = g_ofa.ofaconf
      #IF g_ofa.ofaconf = 'N' THEN     #FUN-D20025
       IF p_type = 1 THEN              #FUN-D20025
           LET g_ofa.ofaconf = 'X'
       ELSE
           LET g_ofa.ofaconf = 'N'
       END IF
 
       UPDATE ofa_file SET ofaconf= g_ofa.ofaconf,
                           ofamodu=g_user,
                           ofadate=g_today
        WHERE ofa01 = g_ofa.ofa01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err3("upd","ofa_file",g_ofa.ofa01,"",SQLCA.sqlcode,"","up ofaconf",1)  #No.FUN-660167
           LET g_ofa.ofaconf = g_chr
       END IF
       DISPLAY BY NAME g_ofa.ofaconf
   END IF
 
   CLOSE t500_cl
   COMMIT WORK
 
    #CKP
    IF g_ofa.ofaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_ofa.ofaconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ofa.ofa01,'V')
 
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t500_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE ofb_file.ofb914,
            l_qty2   LIKE ofb_file.ofb915,
            l_fac1   LIKE ofb_file.ofb911,
            l_qty1   LIKE ofb_file.ofb912,
            l_factor LIKE pml_file.pml09        # No.FUN-680137 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    SELECT ima25,ima31 INTO g_ima25,g_ima31 FROM ima_file
     WHERE ima01=g_ofb[l_ac].ofb04
    IF SQLCA.sqlcode = 100 THEN
       IF g_ofb[l_ac].ofb04 MATCHES 'MISC*' THEN
          SELECT ima25,ima31 INTO g_ima25,g_ima31
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(g_ima31) THEN LET g_ima31=g_ima25 END IF
 
    LET l_fac2=g_ofb[l_ac].ofb914
    LET l_qty2=g_ofb[l_ac].ofb915
    LET l_fac1=g_ofb[l_ac].ofb911
    LET l_qty1=g_ofb[l_ac].ofb912
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_ofb[l_ac].ofb05=g_ofb[l_ac].ofb910
                   LET g_ofb[l_ac].ofb12=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_ofb[l_ac].ofb05=g_ima31
                   LET g_ofb[l_ac].ofb12=l_tot
                   LET g_ofb[l_ac].ofb12 = s_digqty(g_ofb[l_ac].ofb12,g_ofb[l_ac].ofb05)   #FUN-910088--add--
          WHEN '3' LET g_ofb[l_ac].ofb05=g_ofb[l_ac].ofb910
                   LET g_ofb[l_ac].ofb12=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_ofb[l_ac].ofb914 = l_qty1 / l_qty2
                   ELSE
                      LET g_ofb[l_ac].ofb914 = 0
                   END IF
       END CASE
    END IF
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t500_du_data_to_correct()
 
   IF cl_null(g_ofb[l_ac].ofb910) THEN
      LET g_ofb[l_ac].ofb911 = NULL
      LET g_ofb[l_ac].ofb912 = NULL
   END IF
 
   IF cl_null(g_ofb[l_ac].ofb913) THEN
      LET g_ofb[l_ac].ofb914 = NULL
      LET g_ofb[l_ac].ofb915 = NULL
   END IF
 
   IF cl_null(g_ofb[l_ac].ofb916) THEN
      LET g_ofb[l_ac].ofb917 = NULL
   END IF
 
   DISPLAY BY NAME g_ofb[l_ac].ofb911
   DISPLAY BY NAME g_ofb[l_ac].ofb912
   DISPLAY BY NAME g_ofb[l_ac].ofb914
   DISPLAY BY NAME g_ofb[l_ac].ofb915
   DISPLAY BY NAME g_ofb[l_ac].ofb916
   DISPLAY BY NAME g_ofb[l_ac].ofb917
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t500_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima31  LIKE ima_file.ima31,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima908 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_unit3  LIKE img_file.img09,     #計價單位
            l_qty3   LIKE img_file.img10,     #計價數量
            p_cmd    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
            l_factor LIKE pml_file.pml09        # No.FUN-680137 DECIMAL(16,8)
 
    LET l_item = g_ofb[l_ac].ofb04
 
    SELECT ima25,ima31,ima906,ima907,ima908
      INTO l_ima25,l_ima31,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_item
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_ima31,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = l_ima31
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
       LET l_unit3 = NULL
       LET l_qty3  = NULL
    ELSE
       LET l_unit3 = l_ima908
       LET l_qty3  = 0
    END IF
 
    IF p_cmd = 'a' THEN
       LET g_ofb[l_ac].ofb913=l_unit2
       LET g_ofb[l_ac].ofb914=l_fac2
       LET g_ofb[l_ac].ofb915=l_qty2
       LET g_ofb[l_ac].ofb915 = s_digqty(g_ofb[l_ac].ofb915,g_ofb[l_ac].ofb913)   #FUN-910088--add--
       LET g_ofb[l_ac].ofb910=l_unit1
       LET g_ofb[l_ac].ofb911=l_fac1
       LET g_ofb[l_ac].ofb912=l_qty1
       LET g_ofb[l_ac].ofb912 = s_digqty(g_ofb[l_ac].ofb912,g_ofb[l_ac].ofb910)   #FUN-910088--add--
       LET g_ofb[l_ac].ofb916=l_unit3
       LET g_ofb[l_ac].ofb917=l_qty3
       LET g_ofb[l_ac].ofb917 = s_digqty(g_ofb[l_ac].ofb917,g_ofb[l_ac].ofb916)   #FUN-910088--add--
    END IF
END FUNCTION
 
FUNCTION t500_set_ofb917()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima31  LIKE ima_file.ima31,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_unit   LIKE ima_file.ima25,     #MOD-750012
            l_unit1  LIKE ima_file.ima25,     #MOD-750012
            l_factor LIKE pml_file.pml09        # No.FUN-680137 DECIMAL(16,8)
 
    SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906
      FROM ima_file WHERE ima01=g_ofb[l_ac].ofb04
    IF SQLCA.sqlcode = 100 THEN
       IF g_ofb[l_ac].ofb04 MATCHES 'MISC*' THEN
          SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima31) THEN LET l_ima31=l_ima25 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_ofb[l_ac].ofb911
       LET l_qty1=g_ofb[l_ac].ofb912
       LET l_unit1 = g_ofb[l_ac].ofb05    #MOD-750012
    ELSE
       LET l_fac1=1
       LET l_qty1=g_ofb[l_ac].ofb12
       CALL s_umfchk(g_ofb[l_ac].ofb04,g_ofb[l_ac].ofb05,l_ima31)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
       LET l_unit1 = g_ofb[l_ac].ofb05    #MOD-750012
    END IF
 
    LET l_fac2=g_ofb[l_ac].ofb914
    LET l_qty2=g_ofb[l_ac].ofb915
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
   
    IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
       IF g_sma.sma115 = 'Y' THEN
          CASE l_ima906
               WHEN '1' LET l_unit=l_unit1
               WHEN '2' LET l_unit=l_ima31
               WHEN '3' LET l_unit=l_unit1
          END CASE
       ELSE  #不使用雙單位
               LET l_unit=l_unit1
       END IF
       LET g_ofb[l_ac].ofb916=l_unit
    END IF
 
    LET l_factor = 1
    IF g_sma.sma115='Y' THEN
       CALL s_umfchk(g_ofb[l_ac].ofb04,g_ofb[l_ac].ofb05,g_ofb[l_ac].ofb916)
             RETURNING g_cnt,l_factor
    ELSE
    CALL s_umfchk(g_ofb[l_ac].ofb04,l_ima31,g_ofb[l_ac].ofb916)
          RETURNING g_cnt,l_factor
    END IF                 #No.CHI-960052 --End
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET g_ofb[l_ac].ofb917 = l_tot
    LET g_ofb[l_ac].ofb917 = s_digqty(g_ofb[l_ac].ofb917,g_ofb[l_ac].ofb916)   #FUN-910088--add--
END FUNCTION
 
FUNCTION t500_def_form()
    CALL cl_set_comp_visible("ofb914,ofb911",FALSE)
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("ofb913,ofb914,ofb915",FALSE)
       CALL cl_set_comp_visible("ofb910,ofb911,ofb912",FALSE)
    ELSE
       CALL cl_set_comp_visible("ofb05,ofb12",FALSE)
    END IF
    IF g_aza.aza26 MATCHES '[01]' THEN                 #FUN-C90100
       CALL cl_set_act_visible("invoice_558", FALSE)   #FUN-C90100
    END IF                                             #FUN-C90100
    IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
       CALL cl_set_comp_visible("ofb916,ofb917",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ofb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ofb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ofb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ofb912",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ofb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ofb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ofb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ofb912",g_msg CLIPPED)
    END IF
END FUNCTION
 
FUNCTION t500_oea18_get()
   DEFINE l_oea18   LIKE oea_file.oea18
   DEFINE l_n       LIKE type_file.num5
 
     IF cl_null(g_ofa.ofa01) THEN RETURN 'N' END IF
     IF cl_null(g_ofa.ofa16) THEN
         SELECT COUNT(*) INTO l_n
           FROM oga_file
          WHERE oga01=g_ofa.ofa011
         
         IF l_n >=1 THEN
             DECLARE oea18_get CURSOR FOR
                 SELECT oea18,oea24
                   FROM oea_file,ogb_file
                  WHERE oea01=ogb31
                    AND ogb01=g_ofa.ofa011
              
              FOREACH oea18_get INTO l_oea18,g_oea.oea24
                  EXIT FOREACH
              END FOREACH
         END IF
     ELSE
         SELECT oea18 INTO l_oea18
           FROM oea_file
          WHERE oea01=g_ofa.ofa16
     END IF
     IF cl_null(l_oea18) THEN LET l_oea18 = 'N' END IF
     RETURN l_oea18
END FUNCTION
#No:FUN-9C0071--------精簡程式----- 
#FUN-910088--add--start--
FUNCTION t500_ofb12_check(p_cmd,l_qty,l_qty1)
   DEFINE p_cmd  LIKE type_file.chr1, 
          l_qty  LIKE ogb_file.ogb12,
          l_qty1 LIKE ogb_file.ogb12
   IF NOT cl_null(g_ofb[l_ac].ofb05) AND NOT cl_null(g_ofb[l_ac].ofb12) THEN
      IF cl_null(g_ofb05_t) OR cl_null(g_ofb_t.ofb12) OR g_ofb05_t != g_ofb[l_ac].ofb05 OR g_ofb_t.ofb12 != g_ofb[l_ac].ofb12 THEN
         LET g_ofb[l_ac].ofb12 = s_digqty(g_ofb[l_ac].ofb12,g_ofb[l_ac].ofb05)
         DISPLAY BY NAME g_ofb[l_ac].ofb12
      END IF
   END IF
   IF g_ofb_t.ofb12 IS NULL AND g_ofb[l_ac].ofb12 IS NOT NULL OR
      g_ofb_t.ofb12 IS NOT NULL AND g_ofb[l_ac].ofb12 IS NULL OR
      g_ofb_t.ofb12 <> g_ofb[l_ac].ofb12 THEN
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_ofb[l_ac].ofb12) THEN
      IF NOT cl_null(g_ofa.ofa011) AND NOT cl_null(g_ofb[l_ac].ofb31) THEN
         SELECT SUM(ogb12) INTO l_qty FROM ogb_file   
          WHERE ogb01=g_ofa.ofa011
            AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
         IF STATUS THEN
            CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb12",1) 
            RETURN FALSE
         END IF
         IF g_ofb[l_ac].ofb12 > l_qty THEN #出貨數量大於出貨通知量
            CALL cl_err('sel ofb(1):','axm-246',0) 
            RETURN FALSE
         END IF
      END IF
      IF cl_null(g_ofb[l_ac].ofb916) THEN
         LET g_ofb[l_ac].ofb916 = g_ofb[l_ac].ofb05
         LET g_ofb[l_ac].ofb917 = g_ofb[l_ac].ofb12
         DISPLAY BY NAME g_ofb[l_ac].ofb916
         DISPLAY BY NAME g_ofb[l_ac].ofb917
      END IF
      IF g_change = 'Y' THEN
         CALL t500_set_ofb917()
      END IF
      IF NOT cl_null(g_ofb[l_ac].ofb31) AND NOT cl_null(g_ofb[l_ac].ofb32)     
         AND (p_cmd ='a' OR g_ofb_t.ofb12<>g_ofb[l_ac].ofb12) THEN
         LET l_qty = 0
         LET l_qty1= 0
         IF NOT cl_null(g_ofa.ofa011) THEN   
            IF g_oaz.oaz67 = '1'  THEN
               SELECT SUM(ogb12) INTO l_qty FROM ogb_file,oga_file   
                WHERE ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
                  AND oga01=ogb01
                  AND oga01 = g_ofa.ofa011    
                 #AND (oga09 = '1' OR oga09 = '5')                #FUN-C80055 mark
                  AND (oga09 = '1' OR oga09 = '5' OR oga09 = '3') #FUN-C80055 add
            ELSE
               SELECT SUM(ogb12) INTO l_qty FROM ogb_file,oga_file              	   
                WHERE oga01 = ogb01
                  AND oga01 = g_ofa.ofa011    
                 #TQC-C40140 -- mark -- begin
                 #AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6' OR oga09 = '3')     
                 #AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
                 #TQC-C40140 -- mark -- end
                 #TQC-C40140 -- add -- begin
                  AND (((oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')
                        AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32) OR oga09 = '3')
                 #TQC-C40140 -- add -- end
            END IF 
         END IF
         IF cl_null(l_qty) THEN 
            LET l_qty =0
         END IF                  
         SELECT SUM(ofb12) INTO l_qty1 FROM ofb_file,ofa_file 
          WHERE ofb31=g_ofb[l_ac].ofb31 AND ofb32=g_ofb[l_ac].ofb32
            AND ofb01 =ofa01
            AND ofaconf !='X'
            AND ofa011 = g_ofa.ofa011   #MOD-B10142
         IF cl_null(l_qty1) THEN 
            LET l_qty1 =0
         END IF 
         IF p_cmd ='a' THEN
            LET l_qty =l_qty-l_qty1
         ELSE
            LET l_qty =l_qty-l_qty1+g_ofb_t.ofb12
         END IF 
         
         IF STATUS THEN
            CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb12",1)  
            RETURN FALSE
         END IF
         IF g_ofb[l_ac].ofb12 > l_qty THEN 
            CALL cl_err('','axm-246',0)      
            RETURN FALSE
         END IF
      END IF
      IF g_ofa.ofa213 = 'N' THEN
         LET g_ofb[l_ac].ofb14 =g_ofb[l_ac].ofb917*g_ofb[l_ac].ofb13                
         LET g_ofb[l_ac].ofb14t=g_ofb[l_ac].ofb14*(1+g_ofa.ofa211/100)
      ELSE
         LET g_ofb[l_ac].ofb14t =g_ofb[l_ac].ofb917*g_ofb[l_ac].ofb13                
         LET g_ofb[l_ac].ofb14=g_ofb[l_ac].ofb14t/(1+g_ofa.ofa211/100)
      END IF
      CALL cl_digcut(g_ofb[l_ac].ofb14,t_azi04) RETURNING g_ofb[l_ac].ofb14  
      CALL cl_digcut(g_ofb[l_ac].ofb14t,t_azi04)RETURNING g_ofb[l_ac].ofb14t 
      DISPLAY BY NAME g_ofb[l_ac].ofb14,g_ofb[l_ac].ofb14t
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t500_ofb912_check(p_cmd,l_qty,l_qty1)
   DEFINE p_cmd LIKE type_file.chr1,
          l_qty  LIKE ogb_file.ogb12,
          l_qty1 LIKE ogb_file.ogb12
   IF NOT cl_null(g_ofb[l_ac].ofb910) AND NOT cl_null(g_ofb[l_ac].ofb912) THEN
      IF cl_null(g_ofb910_t) OR cl_null(g_ofb_t.ofb912) OR g_ofb910_t != g_ofb[l_ac].ofb910 OR g_ofb_t.ofb912 != g_ofb[l_ac].ofb912 THEN
         LET g_ofb[l_ac].ofb912 = s_digqty(g_ofb[l_ac].ofb912,g_ofb[l_ac].ofb910)
         DISPLAY BY NAME g_ofb[l_ac].ofb912
      END IF
   END IF   
   IF g_ofb_t.ofb912 IS NULL AND g_ofb[l_ac].ofb912 IS NOT NULL OR
      g_ofb_t.ofb912 IS NOT NULL AND g_ofb[l_ac].ofb912 IS NULL OR
      g_ofb_t.ofb912 <> g_ofb[l_ac].ofb912 THEN
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_ofb[l_ac].ofb912) THEN
      IF g_ofb[l_ac].ofb912 < 0 THEN
         CALL cl_err('','aim-391',0)  
         RETURN FALSE
      END IF
      IF NOT cl_null(g_ofb[l_ac].ofb31) AND NOT cl_null(g_ofb[l_ac].ofb32)     
         AND (p_cmd ='a' OR g_ofb_t.ofb912<>g_ofb[l_ac].ofb912) THEN   
         LET l_qty = 0
         LET l_qty1 = 0
         IF NOT cl_null(g_ofa.ofa011) THEN   
             IF g_oaz.oaz67 = '1'  THEN
                SELECT SUM(ogb912) INTO l_qty FROM ogb_file,oga_file   
                 WHERE ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
                   AND oga01=ogb01
                  #AND (oga09 = '1' OR oga09 = '5')                #FUN-C80055 mark
                   AND (oga09 = '1' OR oga09 = '5' OR oga09 = '3') #FUN-C80055 add
             ELSE
                SELECT SUM(ogb912) INTO l_qty FROM ogb_file,oga_file                	  
                 WHERE oga01 = ogb01
                  #TQC-C40140 -- mark -- begin
                  #AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6' OR oga09 = '3') 
                  #AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
                  #TQC-C40140 -- mark -- end
                  #TQC-C40140 -- add -- begin
                   AND (((oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')
                        AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32) OR oga09 = '3')
                  #TQC-C40140 -- add -- end
             END IF 
         END IF
         IF cl_null(l_qty) THEN 
            LET l_qty =0
         END IF   
         SELECT SUM(ofb912) INTO l_qty1 FROM ofb_file,ofa_file 
          WHERE ofb31=g_ofb[l_ac].ofb31 AND ofb32=g_ofb[l_ac].ofb32
            AND ofb01 =ofa01
            AND ofaconf !='X'
         IF cl_null(l_qty1) THEN 
            LET l_qty1 =0
         END IF
         IF p_cmd ='a' THEN
            LET l_qty =l_qty-l_qty1
         ELSE
            LET l_qty =l_qty-l_qty1+g_ofb_t.ofb912
         END IF 
         IF STATUS THEN
            CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb912",1)  
            RETURN FALSE
         END IF
         IF g_ofb[l_ac].ofb912 > l_qty THEN #出貨數量大於出貨通知量
            CALL cl_err('sel ofb(1):','axm-246',0) 
            RETURN FALSE
         END IF
      END IF
   END IF
   IF g_change = 'Y' THEN
      CALL t500_set_ofb917()
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION     

FUNCTION t500_ofb915_check(p_cmd,l_qty,l_qty1)
   DEFINE p_cmd LIKE type_file.chr1,
          l_qty  LIKE ogb_file.ogb12,
          l_qty1 LIKE ogb_file.ogb12
   IF NOT cl_null(g_ofb[l_ac].ofb913) AND NOT cl_null(g_ofb[l_ac].ofb915) THEN
      IF cl_null(g_ofb913_t) OR cl_null(g_ofb_t.ofb915) OR g_ofb913_t != g_ofb[l_ac].ofb913 OR g_ofb_t.ofb915 != g_ofb[l_ac].ofb915 THEN
         LET g_ofb[l_ac].ofb915 = s_digqty(g_ofb[l_ac].ofb915,g_ofb[l_ac].ofb913)
         DISPLAY BY NAME g_ofb[l_ac].ofb915
      END IF
   END IF   
   IF g_ofb_t.ofb915 IS NULL AND g_ofb[l_ac].ofb915 IS NOT NULL OR
      g_ofb_t.ofb915 IS NOT NULL AND g_ofb[l_ac].ofb915 IS NULL OR
      g_ofb_t.ofb915 <> g_ofb[l_ac].ofb915 THEN
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_ofb[l_ac].ofb915) THEN
      IF g_ofb[l_ac].ofb915 < 0 THEN
         CALL cl_err('','aim-391',0) 
         RETURN FALSE
      END IF
      IF NOT cl_null(g_ofa.ofa011) AND NOT cl_null(g_ofb[l_ac].ofb31) THEN
         LET l_qty = 0
         SELECT SUM(ogb915) INTO l_qty FROM ogb_file   
          WHERE ogb01=g_ofa.ofa011
            AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
         IF STATUS THEN
            CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb915",1)  
            RETURN FALSE 
         END IF
         IF g_ofb[l_ac].ofb915 > l_qty THEN #出貨數量大於出貨通知量
            CALL cl_err('sel ofb(1):','axm-246',0) 
            RETURN FALSE
         END IF
      END IF
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
            LET g_tot=g_ofb[l_ac].ofb915*g_ofb[l_ac].ofb914
            IF cl_null(g_ofb[l_ac].ofb912) OR g_ofb[l_ac].ofb912=0 THEN 
               LET g_ofb[l_ac].ofb912=g_tot*g_ofb[l_ac].ofb911
               LET g_ofb[l_ac].ofb912 = s_digqty(g_ofb[l_ac].ofb912,g_ofb[l_ac].ofb910)   
               DISPLAY BY NAME g_ofb[l_ac].ofb912
            END IF                                                      
         END IF
      END IF
   END IF
   IF g_change = 'Y' THEN
      CALL t500_set_ofb917()
   END IF
   CALL cl_show_fld_cont()    
   RETURN TRUE
END FUNCTION

FUNCTION t500_ofb917_check(p_cmd,l_qty,l_qty1)
   DEFINE p_cmd  LIKE type_file.chr1,
          l_qty  LIKE ogb_file.ogb12,
          l_qty1 LIKE ogb_file.ogb12
   IF NOT cl_null(g_ofb[l_ac].ofb916) AND NOT cl_null(g_ofb[l_ac].ofb917) THEN
      IF cl_null(g_ofb916_t) OR cl_null(g_ofb_t.ofb917) OR g_ofb916_t != g_ofb[l_ac].ofb916 OR g_ofb_t.ofb917 != g_ofb[l_ac].ofb917 THEN
         LET g_ofb[l_ac].ofb917 = s_digqty(g_ofb[l_ac].ofb917,g_ofb[l_ac].ofb916)
         DISPLAY BY NAME g_ofb[l_ac].ofb917
      END IF
   END IF
   IF NOT cl_null(g_ofb[l_ac].ofb917) THEN
      IF g_ofb[l_ac].ofb917 < 0 THEN
         CALL cl_err('','aim-391',0)  
         RETURN FALSE
      END IF
      IF NOT cl_null(g_ofb[l_ac].ofb31) AND NOT cl_null(g_ofb[l_ac].ofb32)     
         AND (p_cmd ='a' OR g_ofb_t.ofb917<>g_ofb[l_ac].ofb917) THEN   
         LET l_qty = 0
         LET l_qty1 = 0
         IF NOT cl_null(g_ofa.ofa011) THEN   
            IF g_oaz.oaz67 = '1'  THEN
               SELECT SUM(ogb917) INTO l_qty FROM ogb_file,oga_file   
                WHERE ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
                  AND oga01=ogb01
                 #AND (oga09 = '1' OR oga09 = '5')                #FUN-C80055 mark
                  AND (oga09 = '1' OR oga09 = '5' OR oga09 = '3') #FUN-C80055 add
            ELSE 
               SELECT SUM(ogb917) INTO l_qty FROM ogb_file,oga_file             	
                WHERE oga01 = ogb01
                 #TQC-C40140 -- mark -- begin
                 #AND (oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6'  OR oga09 = '3')  
                 #AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32
                 #TQC-C40140 -- mark -- end
                 #TQC-C40140 -- add -- begin
                  AND (((oga09 = '2' OR oga09 = '4' OR oga09='8' OR oga09 = '6')
                        AND ogb31=g_ofb[l_ac].ofb31 AND ogb32=g_ofb[l_ac].ofb32) OR oga09 = '3')
                 #TQC-C40140 -- add -- end
            END IF 
         END IF
         IF cl_null(l_qty) THEN 
            LET l_qty =0
         END IF   
         SELECT SUM(ofb917) INTO l_qty1 FROM ofb_file,ofa_file 
          WHERE ofb31=g_ofb[l_ac].ofb31 AND ofb32=g_ofb[l_ac].ofb32
            AND ofb01 =ofa01
            AND ofaconf !='X'
         IF cl_null(l_qty1) THEN 
            LET l_qty1 =0
         END IF
         IF p_cmd ='a' THEN
            LET l_qty =l_qty-l_qty1
         ELSE
            LET l_qty =l_qty-l_qty1+g_ofb_t.ofb917
         END IF 
         IF STATUS THEN
            CALL cl_err3("sel","ogb_file",g_ofa.ofa011,"",STATUS,"","sel ogb917",1)  
            RETURN FALSE
         END IF
         IF g_ofb[l_ac].ofb917 > l_qty THEN #出貨數量大於出貨通知量
            CALL cl_err('sel ofb(1):','axm-246',0)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--

#FUN-C60023 add START
#將出通/出貨單的備註全部都帶到Invoide備註
FUNCTION t500_ins_oao(p_no)
DEFINE p_no       LIKE oao_file.oao01
DEFINE l_n        LIKE type_file.num5

   LET g_success = 'Y'
   SELECT COUNT(*) INTO l_n FROM oao_file
      WHERE oao01 = p_no

   #原單據沒有備註直接return
   IF l_n = 0 OR cl_null(l_n) THEN
      RETURN
   END IF

   DROP TABLE x

   SELECT * FROM oao_file
      WHERE oao01 = p_no
    INTO TEMP x
   IF SQLCA.sqlcode THEN
       CALL cl_err("ins oao_file ",SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF

   UPDATE x SET oao01 = g_ofa.ofa01

   INSERT INTO oao_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
       CALL cl_err('ins oao_file ',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF

END FUNCTION
#FUN-C60023 add END

