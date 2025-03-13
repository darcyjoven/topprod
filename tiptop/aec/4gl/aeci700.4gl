 # Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci700.4gl
# Descriptions...: 工單製程維護作業
# Date & Author..: 99/04/30 By Iceman FOR TIPTOP 4.00
# Modify.........: No.MOD-490091 04/09/14 By Smapmin補上遺漏抓取的
#                                                ecm57,ecm58,ecm59
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-490091 04/10/13 By Smapmin 修正單位轉換率
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530807 05/03/31 By pengu  g_x 工單狀態資料未抓,編p_zaa, copy asfi301 之 p_zaa
# Modify.........: No.MOD-530892 05/03/31 By Carol 筆數計算SQL加上單身條件
# Modify.........: No.FUN-560014 05/06/07 By day   單據編號修改
# Modify.........: No.MOD-610024 06/01/09 By pengu 單身製程自行維護時沒有預設工單生產料號,造成ecm03_par=''
# Modify.........: No.FUN-650074 06/05/30 By kim 單身輸入前檢查sfb93='Y'才可輸入
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0065 06/10/27 By Ray  產品制程修改工作站時應同時更改sgd_file中的sgd04
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-710004 07/03/06 By pengu 新增一筆製程資料時，則ecmacti"資料有效碼"欄位會被塞null值
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740145 07/04/24 By hongmei 單身工時不可為負數，完工日期不能小于開工日期
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790064 07/09/13 By sherry  點擊"相關時間資料"按鈕，程序自動退出
# Modify.........: NO.FUN-7C0002 08/01/17 by Yiting 新增串接apsi311.4gl/apsi312.4gl
# Modify.........: No.FUN-810014 08/01/24 By arman  修改為服飾版
# Modify.........: No.FUN-830114 08/03/28 By jan 若為服飾版，單元明細action開啟的應是aeci710_slk
# Modify.........: No.FUN-850115 08/05/14 By Duke add action APS鎖定製程時間,APS鎖定製程設備,APS製程外包
# Modify.........: No.FUN-870012 08/06/24 BY DUKE  change vng02=sfb01
# Modify.........: No.FUN-870092 08/08/13 By Mandy 平行加工
# Modify.........: No.FUN-890013 08/09/03 BY DUKE 呼叫apsi312時,增加傳遞參數是否委外 ecm52
# Modify.........: No.TQC-890030 08/09/11 By Mandy 將單身action"APS途程製程(apsi312)","鎖定製程時間(apsi311)","APS鎖定製程設備(apsi315)","APS製程外包(apsi324)"四個action
#                                                  在單身和menu段均可被執行.並且控制單工單狀態為sfb04 = '8',sfb87 = 'X',sfb87 = 'Y'時,不可做修改
# Modify.........: No.FUN-890096 08/09/26 BY DUKE add APS途程製程指定模具
# Modify.........: No.TQC-8A0013 08/10/08 By Mandy 新增和刪除平行加工資料時,亦需同步新增和刪除vne_file
# Modify.........: No.FUN-8A0136 08/10/30 By arman
# Modify.........: No.FUN-8C0028 08/12/03 BY DUKE 串連apsi312時,增加 vmn19 預設值0
# Modify.........: No.TQC-8C0016 08/12/09 BY Mandy (1)當系統參數設定有與APS整合時,單身畫面加show資源群組編號(機器)(vmn08)及資源群組編號(工作站)(vmn081)供使用者維護，維護時需判斷系統參數檔的資源型態,當資源型態為機器時,機器跟資源群組編號(機器)至少要有一個欄位有值.
#                                                  (2)維護資源群組編號(機器)及資源群組編號(工作站)時,需判斷vmn_file是否存在,若無存在則需insert,若有存在則需update
# Modify.........: No.TQC-8C0066 08/12/24 By Mandy (1)ecm61平行加工否打勾的話,若資源型態設機器,機器編號NOT NULL,required
#                                                  (2若機器編號為空白串"APS鎖定使用設備"和"APS鎖定製程時間維護",應改show "機器編號為空白,無法鎖定使用設備!"
# Modify.........: No.FUN-930120 09/04/08 By sabrina (1)送簽中不可執行單身action
#                                                    (2)簽核完後，若有更改單身資料，要將sfb43的值更改為〝0：開立〞
# Modify.........: No.FUN-980002 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9B0193 09/12/01 By lilingyu 在aeci700中打開一筆未審核的資料,這時去工單中審核這筆資料,此時在aeci700中的這筆資料仍然可以修改單身,應不可才對
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.FUN-A10044 10/03/08 By wuxj   新增列印功能
# Modify.........: No.FUN-A60011 10/06/02 By Carrier 平行工艺 单身增加 ecm011/ecm012/ecu014/ecm62/ecm63/ecm321/ecm65/ecm12/ecm34/ecm64
#                                                             单身去除 ecm57/ecm59
# Modify.........: No.FUN-A60095 10/07/28 By jan 平行製程調整
# Modify.........: No:CHI-A70026 10/08/03 By Summer 在明細的第二行增加顯示製程數量狀況(aecq700的WIP量~盤點量等十四個數量欄位),數量為0的請顯示空白
# Modify.........: No:TQC-A80017 10/08/04 By lilingyu FUN-680073定義l_ecm03處類型錯誤
# Modify.........: No.FUN-A80102 10/08/26 By kim GP5.25號機管理
# Modify.........: No.FUN-A80150 10/09/06 By sabrina 單頭新增計劃批號(sfb919)欄位，單身新增報工點否(ecm66)、委外廠商(ecm67)欄位 
# Modify.........: No.TQC-AC0374 10/12/30 By jan 從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取
# Modify.........: NO.FUN-B10056 11/02/15 By liweie 修改制程段號的管控,新增'檢查制程段’action
# Modify.........: No.FUN-B20078 11/03/02 By lixh1  製程段資料的捞取和控管直接對基本檔ecr_file操作
# Modify.........: No.FUN-B20070 11/03/07 By jan 手動新增or更改資料時,重新計算標準產出量
# Modify.........: No.MOD-B30427 11/03/14 By lixh1  拿掉不必要的報錯信息
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-B40026 11/04/07 By destiny orig,oriu未显示
# Modify.........: No.TQC-B40122 11/04/21 By destiny 原有逻辑为只要单身资料有委外可用量即调用asfp700,现改为每笔单身都要检查委外可用量是否大于0
# Modify.........: No.FUN-B50046 11/05/10 By abby GP5.25 APS追版 str----------
# Modify.........: No:FUN-960054 09/06/04 By Duke APS整合製程外包維護按鈕移除,製程屬外包時鎖定設備按鈕不允許執行
#                  No:FUN-960054 09/06/18 By Duke 調整call apsi311 之vnd資料欄位控制
# Modify.........: No:FUN-960102 09/06/24 By Duke 多機台鎖定功能調整
# Modify.........: No:FUN-980080 09/08/19 By Mandy 從aeci700帶至apsi315時,過來的第一筆資料,預計開工日及預計完工日要預設aeci700的預計開工/完工日,且不允許空白
# Modify.........: No:FUN-9A0047 09/10/20 By Mandy (1)當製程為委外時,不需要控管機器編號和資源群組編號(機器),至少要有一個欄位有值的限制
#                                                  (2)外包商代號紀錄在APS途程製程維護(apsi312)的外包商編號欄位(vmn18)
# Modify.........: No:FUN-9A0048 09/11/09 By Mandy (1)當有與APS整合時,單身加show 單一標準工時(放在ecm14前面)及單一標準機時(放在ecm16前面)
# Modify.........: No:FUN-9C0019 09/12/08 By Mandy 執行aeci700時,若單身無資料時,按APS相關的Action,程式當出
# Modify.........: No:FUN-A70036 10/08/11 By Mandy (1)aeci700/apsi315點選"APS鎖定製程時間"按鈕時,若鎖定碼(vnd06)沒有設定(vnd06=0),則不insert資料至vnd_file
#                                                  (2)aeci700點選"APS鎖定使用設備"按鈕時,若資源編號(vne05)沒有輸入,則不insert資料至vne_file
# Modify.........: No.FUN-B50046 11/05/10 By abby GP5.25 APS追版 end----------
# Modify.........: No.FUN-B50101 11/05/24 By Mandy GP5.25 平行製程 影響APS程式調整
# Modify.........: No.TQC-B60028 11/06/07 By yinhy 刪除單身中間某筆資料時,會出現異常錯誤 "無此筆資料,或任何上下筆資料,或其他相關主檔資料 !"
# Modify.......... No.FUN-B90141 11/11/09 By jason 檢查'單位轉換分子/單位轉換分母'需等於單位轉換率
# Modify.......... No.FUN-BB0084 11/12/19 By lixh1 增加數量欄位小數取位
# Modify.......... No.TQC-BC0166 11/12/29 By yuhuabao 添加裁片管理否欄位ecmslk01
# Modify.......... No.TQC-C20083 12/02/08 By destiny b_fill sql个数不对
# Modify.......... No.MOD-C30283 12/03/10 By chenjing 相關時間回寫問題
# Modify.......... No.FUN-C50065 12/07/12 By bart 作業名稱不可修改
# Modify.........: No:TQC-D10099 13/01/29 By Lori 訊息顯示抓取zaa的部份,改抓ze
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_sfb   RECORD LIKE sfb_file.*,
    g_sfb_t RECORD LIKE sfb_file.*,
    g_sfb_o RECORD LIKE sfb_file.*,
    g_sfb01_t LIKE sfb_file.sfb01,
    g_sfb02_t LIKE sfb_file.sfb02,
    g_ima   RECORD LIKE ima_file.*,
    g_wc,g_wc2,g_sql    STRING,                #No.FUN-580092 HCN
    g_cott              LIKE type_file.num5,   #No.FUN-680073   SMALLINT,
    g_ecm          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ecm03		LIKE ecm_file.ecm03,  #製程序
        #No.FUN-A60011 --Begin
        ecm011          LIKE ecm_file.ecm011, #上制程段
        ecm012          LIKE ecm_file.ecm012, #制程序
    #   ecu014          LIKE ecu_file.ecu014, #制程序名称   #FUN-B10056 mark
        ecm014          LIKE ecm_file.ecm014,             #FUN-B10056 add
        ecm015          LIKE ecm_file.ecm015,             #FUN-B10056 add
        ecr02           LIKE ecr_file.ecr02,              #FUN-B20078 add     
        #No.FUN-A60011 --End
        ecm04		LIKE ecm_file.ecm04,  #作業編號
        ecm45		LIKE ecm_file.ecm45,  #作業名稱
        ecm61		LIKE ecm_file.ecm61,  #平行加工否 #FUN-870092 add
        ecm06		LIKE ecm_file.ecm06,  #生產站別
        eca02		LIKE eca_file.eca02,  #站別說明
        vmn081          LIKE vmn_file.vmn081, #資源群組編號(工作站) #TQC-8C0016 add
        vmn20           LIKE vmn_file.vmn20,  #單一標準工時 #FUN-9A0048 add
        ecm14		LIKE ecm_file.ecm14,  #標準工時
        ecm13		LIKE ecm_file.ecm13,  #固定工時
        vmn21           LIKE vmn_file.vmn21,  #單一標準機時 #FUN-9A0048 add
        ecm16		LIKE ecm_file.ecm16,  #標準機時
        ecm15		LIKE ecm_file.ecm15,  #固定機時
        ecmslk04       LIKE ecm_file.ecmslk04,#現實工價      #No.FUN-810014
        ecmslk03       LIKE ecm_file.ecmslk03,#標准工價      #No.FUN-810014
        ecmslk02       LIKE ecm_file.ecmslk02,#現實工時      #No.FUN-810014
        ecmslk01       LIKE ecm_file.ecmslk01,#裁片管理否    #No.TQC-BC0166
        ecm49		LIKE ecm_file.ecm49,  #製程人力
        ecm50		LIKE ecm_file.ecm50,  #開工日
        ecm51		LIKE ecm_file.ecm51,  #完工日
        ecm05		LIKE ecm_file.ecm05,  #機械編號
        vmn08           LIKE vmn_file.vmn08,  #資源群組編號(機器)    #TQC-8C0016 add
        ecm66		LIKE ecm_file.ecm66,  #報工點否      #FUN-A80150 add
        ecm52		LIKE ecm_file.ecm52,  #委外否
        ecm67		LIKE ecm_file.ecm67,  #委外廠商      #FUN-A80150 add
        ecm321          LIKE ecm_file.ecm321, #委外加工量            #No.FUN-A60011
        ecm53		LIKE ecm_file.ecm53,  #PQC否
        ecm54		LIKE ecm_file.ecm54,  #check in
        ecm55           LIKE ecm_file.ecm55,  #Hold for check in
        ecm56           LIKE ecm_file.ecm56,  #Hold for check out(報工)
        #No.FUN-A60011 --Begin
        vmn18           LIKE vmn_file.vmn18,  #FUN-9A0047 add
       #ecm57           LIKE ecm_file.ecm57,
        ecm58           LIKE ecm_file.ecm58,
       #ecm59           LIKE ecm_file.ecm59,
        ecm62           LIKE ecm_file.ecm62,  #组成用量
        ecm63           LIKE ecm_file.ecm63,  #底数
        ecm65           LIKE ecm_file.ecm65,  #标准产出量
        ecm12           LIKE ecm_file.ecm12,  #固定损耗量
        ecm34           LIKE ecm_file.ecm34,  #变动损耗率
        ecm64           LIKE ecm_file.ecm64,  #损耗批量
        #No.FUN-A60011 --End
        #str—add by huanglf 160713
        ta_ecm01        LIKE ecm_file.ta_ecm01,
        ta_ecm02        LIKE ecm_file.ta_ecm02,
        ta_ecm03        LIKE ecm_file.ta_ecm03
        #end—add by huanglf 160713
                    END RECORD,
    g_ecm_t         RECORD                 #程式變數 (舊值)
        ecm03		LIKE ecm_file.ecm03,  #製程序
        #No.FUN-A60011 --Begin
        ecm011          LIKE ecm_file.ecm011, #上制程段
        ecm012          LIKE ecm_file.ecm012, #制程序
    #   ecu014          LIKE ecu_file.ecu014, #制程序名称   #FUN-B10056 mark
        ecm014          LIKE ecm_file.ecm014,             #FUN-B10056 add
        ecm015          LIKE ecm_file.ecm015,             #FUN-B10056 add
        ecr02           LIKE ecr_file.ecr02,              #FUN-B20078 add         
        #No.FUN-A60011 --End
        ecm04		LIKE ecm_file.ecm04,  #作業編號
        ecm45		LIKE ecm_file.ecm45,  #作業名稱
        ecm61		LIKE ecm_file.ecm61,  #平行加工否 #FUN-870092 add
        ecm06		LIKE ecm_file.ecm06,  #生產站別
        eca02		LIKE eca_file.eca02,  #站別說明
        vmn081          LIKE vmn_file.vmn081, #資源群組編號(工作站) #TQC-8C0016 add
        vmn20           LIKE vmn_file.vmn20,  #單一標準工時 #FUN-9A0048 add
        ecm14		LIKE ecm_file.ecm14,  #標準工時
        ecm13		LIKE ecm_file.ecm13,  #固定工時
        vmn21           LIKE vmn_file.vmn21,  #單一標準機時 #FUN-9A0048 add
        ecm16		LIKE ecm_file.ecm16,  #標準機時
        ecm15		LIKE ecm_file.ecm15,  #固定機時
        ecmslk04       LIKE ecm_file.ecmslk04,#現實工價      #No.FUN-810014
        ecmslk03       LIKE ecm_file.ecmslk03,#標准工價      #No.FUN-810014
        ecmslk02       LIKE ecm_file.ecmslk02,#現實工時      #No.FUN-810014
        ecmslk01       LIKE ecm_file.ecmslk01,#裁片管理否    #No.TQC-BC0166
        ecm49		LIKE ecm_file.ecm49,  #製程人力
        ecm50		LIKE ecm_file.ecm50,  #開工日
        ecm51		LIKE ecm_file.ecm51,  #完工日
        ecm05		LIKE ecm_file.ecm05,  #機械編號
        vmn08           LIKE vmn_file.vmn08,  #資源群組編號(機器)    #TQC-8C0016 add
        ecm66		LIKE ecm_file.ecm66,  #報工點否      #FUN-A80150 add
        ecm52		LIKE ecm_file.ecm52,  #委外否
        ecm67		LIKE ecm_file.ecm67,  #委外廠商      #FUN-A80150 add
        ecm321          LIKE ecm_file.ecm321, #委外加工量            #No.FUN-A60011
        ecm53		LIKE ecm_file.ecm53,  #PQC否
        ecm54		LIKE ecm_file.ecm54,  #check in
        ecm55           LIKE ecm_file.ecm55,  #Hold for check in
        ecm56           LIKE ecm_file.ecm56,  #Hold for check out(報工)
        #No.FUN-A60011 --Begin
        vmn18           LIKE vmn_file.vmn18,  #FUN-9A0047 add
       #ecm57           LIKE ecm_file.ecm57,
        ecm58           LIKE ecm_file.ecm58,
       #ecm59           LIKE ecm_file.ecm59,
        ecm62           LIKE ecm_file.ecm62,  #组成用量
        ecm63           LIKE ecm_file.ecm63,  #底数
        ecm65           LIKE ecm_file.ecm65,  #标准产出量
        ecm12           LIKE ecm_file.ecm12,  #固定损耗量
        ecm34           LIKE ecm_file.ecm34,  #变动损耗率
        ecm64           LIKE ecm_file.ecm64,  #损耗批量
        #str—add by huanglf 160713
        ta_ecm01        LIKE ecm_file.ta_ecm01,
        ta_ecm02        LIKE ecm_file.ta_ecm02,
        ta_ecm03        LIKE ecm_file.ta_ecm03
        #end—add by huanglf 160713
                    END RECORD,
    l_ecm03             LIKE ecm_file.ecm03,
    l_ecm45             LIKE ecm_file.ecm45,
    l_ecm14a            LIKE ecm_file.ecm14,
    l_ecm14             LIKE ecm_file.ecm14,
    l_ecm49a            LIKE ecm_file.ecm49,
    l_ecm49             LIKE ecm_file.ecm49,
    l_ecm06             LIKE ecm_file.ecm06,
    l_ecm16             LIKE ecm_file.ecm16,
    l_ecm16a            LIKE ecm_file.ecm16,
    l_ecm311            LIKE ecm_file.ecm311,  #FUN-960102 ADD
    g_ima55         LIKE ima_file.ima55,
    g_ecm57         LIKE ecm_file.ecm57,
    g_ecm58         LIKE ecm_file.ecm58,
    g_ecm59         LIKE ecm_file.ecm59,
    g_ecm07,g_ecm08,g_ecm09,g_ecm10,g_ecm20,g_ecm21,g_ecm22,g_ecm23 LIKE ecm_file.ecm23,     #No.FUN-680073 DEC(8,2),
    g_ecm24,g_ecm17,g_ecm18,g_ecm19,g_ecm37,g_ecm38,g_ecm39 LIKE ecm_file.ecm24,             #No.FUN-680073 DEC(8,2),
    g_sw            LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(01),
    g_buf           LIKE type_file.chr1000,       #No.FUN-680073
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680073 SMALLINT
    p_row,p_col     LIKE type_file.num5,          #No.FUN-680073 SMALLINT SMALLINT
    l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680073
    g_success       LIKE type_file.chr1          #FUN-960102 ADD
DEFINE   g_argv1 LIKE ecm_file.ecm01             # 工單編號
DEFINE   g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done  LIKE type_file.num5          #No.FUN-680073 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680073 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680073
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
DEFINE   g_confirm       LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
DEFINE   g_approve       LIKE type_file.chr1          #No.FUN-680073 VARCHAR(01),
DEFINE   g_post          LIKE type_file.chr1          #No.FUN-680073 VARCHAR(01),
DEFINE   g_close         LIKE type_file.chr1          #No.FUN-680073 VARCHAR(01),
DEFINE   g_void          LIKE type_file.chr1          #No.FUN-680073 VARCHAR(01),
DEFINE   g_vaild         LIKE type_file.chr1          #No.FUN-680073 VARCHAR(01),
DEFINE   g_vzz60         LIKE vzz_file.vzz60          #No.FUN-850115
DEFINE   l_table         STRING                       #No.FUN-A10044
DEFINE   g_str           STRING                       #No.FUN-A10044
DEFINE   g_ecr02         LIKE ecr_file.ecr02          #FUN-B20078
DEFINE   g_ecm58_t       LIKE ecm_file.ecm58          #FUN-BB0084

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT



   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF

#FUN-A10044  ---begin---
   LET g_sql = "sfb01.sfb_file.sfb01,smydesc.smy_file.smydesc,sfb05.sfb_file.sfb05,",
               "ima02.ima_file.ima02,ima021.ima_file.ima021,sfb06.sfb_file.sfb06,",
               "ima55.ima_file.ima55,sfb02.sfb_file.sfb02,sfb02_d.type_file.chr1000,",
               "sfb81.sfb_file.sfb81,sfb82.sfb_file.sfb82,pmc03.pmc_file.pmc03,",
               "sfb22.sfb_file.sfb22,sfb221.sfb_file.sfb221,sfb13.sfb_file.sfb13,",
               "sfb15.sfb_file.sfb15,a.ecm_file.ecm03,b.ecm_file.ecm03,sfb99.sfb_file.sfb99,",
               "sfb87.sfb_file.sfb87,ecm03.ecm_file.ecm03,ecm04.ecm_file.ecm04,",
               "ecm45.ecm_file.ecm45,ecm06.ecm_file.ecm06,eca02.eca_file.eca02,",
               "vmn081.vmn_file.vmn081,ecm14.ecm_file.ecm14,",
               "ecm13.ecm_file.ecm13,ecm16.ecm_file.ecm16,ecm15.ecm_file.ecm15,",
               "ecm49.ecm_file.ecm49,ecm50.ecm_file.ecm50,ecm51.ecm_file.ecm51,",
               "ecm05.ecm_file.ecm05,vmn08.vmn_file.vmn08,ecm52.ecm_file.ecm52,ecm53.ecm_file.ecm53,",
               "ecm54.ecm_file.ecm54,",
   #No.FUN-A60011  --Begin
               "ecm011.ecm_file.ecm011,",
               "ecm012.ecm_file.ecm012,",
            #  "ecu014.ecu_file.ecu014,",   #FUN-B10056 mark
               "ecm014.ecm_file.ecm014,",   #FUN-B10056 ADD
               "ecm015.ecm_file.ecm015,",   #FUN-B10056 ADD
               "ecm321.ecm_file.ecm321,",
               "ecm62.ecm_file.ecm62,",
               "ecm63.ecm_file.ecm63,",
               "ecm65.ecm_file.ecm65,",
               "ecm12.ecm_file.ecm12,",
               "ecm34.ecm_file.ecm34,",
               "ecm64.ecm_file.ecm64,", #CHI-A70026 mod
   #No.FUN-A60011  --End
               "wipqty.ecm_file.ecm315,ecm301.ecm_file.ecm301,ecm302.ecm_file.ecm302,",  #CHI-A70026 add
               "ecm303.ecm_file.ecm303,ecm311.ecm_file.ecm311,ecm312.ecm_file.ecm312,",  #CHI-A70026 add
               "ecm316.ecm_file.ecm316,ecm313.ecm_file.ecm313,ecm314.ecm_file.ecm314,",  #CHI-A70026 add
               "ecm315.ecm_file.ecm315,ecm322.ecm_file.ecm322,",                         #CHI-A70026 add
               "ecm291.ecm_file.ecm291,ecm292.ecm_file.ecm292"                           #CHI-A70026 add
   LET l_table = cl_prt_temptable('aeci700',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#FUN-A10044 ---end ---

     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
   LET p_row = 2 LET p_col = 3

   OPEN WINDOW i700_w AT p_row,p_col
        WITH FORM "aec/42f/aeci700"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
       CALL cl_set_comp_visible("ecmslk04,ecmslk03,ecmslk02,ecmslk01",FALSE)   #No.TQC-BC0166 add ecmslk01
    #No.FUN-A60011  --Begin
#FUN-B10056 --------------------------Begin------------------------------------
  # CALL cl_set_comp_visible("ecm011,ecm012,ecu014",g_sma.sma541='Y')  
  # CALL cl_set_comp_visible("ecm011,ecm012,ecm014,ecm015",g_sma.sma541='Y')        #FUN-B20078 
    CALL cl_set_comp_visible("ecm011,ecm012,ecm014,ecm015,ecr02",g_sma.sma541='Y')  #FUN-B20078 
   IF g_sma.sma541 = 'Y' THEN
      CALL cl_set_act_visible("chkbom",TRUE)
   ELSE
      CALL cl_set_act_visible("chkbom",FALSE)
   END IF
#FUN-B10056 ---------------------------End-------------------------------------
   #FUN-A80150---add---start---
    CALL cl_set_comp_visible("sfb919",g_sma.sma1421='Y')
    CALL cl_set_comp_visible("ecm66",g_sma.sma1431='Y')
   #FUN-A80150---add---end---
    #No.FUN-A60011  --End
    #不串APS時,平行加工否欄位隱藏
    IF cl_null(g_sma.sma901) OR g_sma.sma901 = 'N' THEN
        CALL cl_set_comp_visible("ecm61",FALSE)
        #當系統參數設定有與APS整合時,
        #單身畫面加show資源群組編號(機器)(vmn08)及資源群組編號(工作站)(vmn081)
        CALL cl_set_comp_visible("vmn081,vmn08",FALSE)
        CALL cl_set_comp_visible("vmn081,vmn08,vmn18,vmn20,vmn21",FALSE)  #FUN-9A0047 add vmn18 #FUN-9A0048 add vmn20,vmn21
    END IF
    CALL cl_set_comp_entry("ecm45",FALSE)  #FUN-C50065
    CALL i700()

    CLOSE WINDOW i700_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100

END MAIN

FUNCTION i700()
    DEFINE
           l_zaa08    LIKE zaa_file.zaa08        #No.FUN-680073  VARCHAR(40)
    DECLARE r700_zaa_cur CURSOR FOR
             SELECT zaa02,zaa08 FROM zaa_file
              WHERE zaa01 = "aeci700" AND zaa03 = g_lang
     FOREACH r700_zaa_cur INTO g_i,l_zaa08
        LET g_x[g_i] = l_zaa08
     END FOREACH

     #TQC-D10099 add begin---
     CALL cl_getmsg('mfg3510',g_lang) RETURNING g_x[1]
     CALL cl_getmsg('asf-842',g_lang) RETURNING g_x[2]
     CALL cl_getmsg('mfg3232',g_lang) RETURNING g_x[3]
     CALL cl_getmsg('asf-856',g_lang) RETURNING g_x[4]
     CALL cl_getmsg('asf-853',g_lang) RETURNING g_x[5]
     CALL cl_getmsg('asf-844',g_lang) RETURNING g_x[6]
     CALL cl_getmsg('asf-855',g_lang) RETURNING g_x[7]
     #TQC-D10099 add end-----

    INITIALIZE g_sfb.* TO NULL
    INITIALIZE g_sfb_t.* TO NULL
    INITIALIZE g_sfb_o.* TO NULL

    IF cl_null(ARG_VAL(1)) THEN
       LET g_argv1 = ' '
    ELSE
       LET g_argv1 = ARG_VAL(1)
       CALL  i700_q()  # 若工單維護作業call本作業時直接顯示相關資料
       LET g_argv1 = ' ' # 還原為正常的型態
    END IF

    LET g_forupd_sql = "SELECT * FROM sfb_file WHERE sfb01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i700_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

    CALL i700_menu()

END FUNCTION

FUNCTION i700_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    LET  g_wc2=' 1=1'
    CLEAR FORM
    CALL g_ecm.clear()
    IF cl_null(g_argv1) THEN
       CALL cl_set_head_visible("","YES")         #No.FUN-6B0029

       INITIALIZE g_sfb.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
                 sfb01,sfb05,sfb06,sfb02,sfb81,sfb98,sfb103,sfb07,sfb071,sfb82,  #No.FUN-A60011
                 sfb22,sfb221,sfb13,sfb15,sfb24,sfb99,sfb87,
                 sfb919,                                                          #FUN-A80150 add
                 sfb08,sfb081,sfb09,sfb12,  #No.FUN-810014 add sfb103
                 sfbuser,sfbgrup,sfboriu,sfborig,sfbmodu, sfbdate, sfbacti       #No.FUN-A60011

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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT

       IF INT_FLAG THEN RETURN END IF

       #No.FUN-A60011 --Begin
       CONSTRUCT g_wc2 ON ecm03,ecm011,ecm012,
                          ecm014,ecm015,           #FUN-B10056 ADD
                          ecm04,ecm45,ecm61,ecm06,
                          ecm14,ecm13,ecm16,ecm15, #FUN-870092 add
                          ecm49,ecm50,ecm51,ecm05,ecm66,ecm52,ecm67,ecm321,ecm53,ecm54,ecm55,    #FUN-A80150 add ecm66,ecm67
                        # ecm56,ecm57,ecm58,ecm59,
                          ecm56,ecm58,
                          ecm62,ecm63,ecm65,ecm12,ecm34,ecm64,ta_ecm01,ta_ecm02,ta_ecm03  #str—add by huanglf 160713
               FROM s_ecm[1].ecm03,s_ecm[1].ecm011,s_ecm[1].ecm012,
                    s_ecm[1].ecm014,s_ecm[1].ecm015,              #FUN-B10056 add
                    s_ecm[1].ecm04,s_ecm[1].ecm45,s_ecm[1].ecm61, #FUN-870092 add
                    s_ecm[1].ecm06,s_ecm[1].ecm14,s_ecm[1].ecm13,
                    s_ecm[1].ecm16,s_ecm[1].ecm15,
                    s_ecm[1].ecm49,
                    s_ecm[1].ecm50,s_ecm[1].ecm51,s_ecm[1].ecm05,s_ecm[1].ecm66,s_ecm[1].ecm52,s_ecm[1].ecm67,s_ecm[1].ecm321,    #FUN-A80150 add ecm66,ecm67
                    s_ecm[1].ecm53,s_ecm[1].ecm54,s_ecm[1].ecm55,s_ecm[1].ecm56,
                   #s_ecm[1].ecm57,s_ecm[1].ecm58,s_ecm[1].ecm59,
                    s_ecm[1].ecm58,
                    s_ecm[1].ecm62,s_ecm[1].ecm63,s_ecm[1].ecm65,
                    s_ecm[1].ecm12,s_ecm[1].ecm34,s_ecm[1].ecm64,
                    s_ecm[1].ta_ecm01,s_ecm[1].ta_ecm02,s_ecm[1].ta_ecm03#str—add by huanglf 160713
       #No.FUN-A60011 --End

		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)

           ON ACTION controlp
              CASE
                 #No.FUN-A60011  --Begin
                 WHEN INFIELD(ecm011)                #上工艺段号
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                   #   LET g_qryparam.form     = "q_ecu012_1"    #FUN-B10056
                      LET g_qryparam.form     = "q_ecb012_1"     #FUN-B10056
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ecm011
                 WHEN INFIELD(ecm012)                #工艺段号
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                   #   LET g_qryparam.form     = "q_ecu012_1"    #FUN-B10056
                   #   LET g_qryparam.form     = "q_ecb012_1"    #FUN-B10056   #FUN-B20078
                      LET g_qryparam.form     = "q_ecr"          #FUN-B20078
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ecm012
                 #No.FUN-A60011  --End
#FUN-B20078 ----------------------------Begin-------------------------------
                 WHEN INFIELD(ecm015)              
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_ecr"  
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ecm015
#FUN-B20078 ----------------------------End---------------------------------
                 WHEN INFIELD(ecm05)                 #機械編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_eci"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ecm05
                      NEXT FIELD ecm05
               #FUN-A80150---add---start---
                WHEN INFIELD(ecm67) #廠商編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_pmc"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO ecm67 
                   NEXT FIELD ecm67
               #FUN-A80150---add---end---
                 WHEN INFIELD(ecm06)                 #生產站別
                      CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ecm06
                      NEXT FIELD ecm06
                 WHEN INFIELD(ecm04)                 #作業編號
                      CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ecm04
                      NEXT FIELD ecm04
                 WHEN INFIELD(ecm55)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form = "q_sgg"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ecm55
                      NEXT FIELD ecm55
                 WHEN INFIELD(ecm56)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form = "q_sgg"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ecm56
                      NEXT FIELD ecm56
                 #No.FUN-A60011  --Begin
                 #WHEN INFIELD(ecm57)
                 #     CALL cl_init_qry_var()
                 #     LET g_qryparam.state = "c"
                 #     LET g_qryparam.form = "q_gfe"
                 #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                 #     DISPLAY g_qryparam.multiret TO ecm57
                 #     NEXT FIELD ecm57
                 #No.FUN-A60011  --End
                 WHEN INFIELD(ecm58)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_gfe"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ecm58
                      NEXT FIELD ecm58
                 WHEN INFIELD(vmn08)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form  ="q_vme01"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO vmn08
                      NEXT FIELD vmn08
                 WHEN INFIELD(vmn081)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_vmp01"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO vmn081
                      NEXT FIELD vmn081
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

       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc=" sfb01='",g_argv1,"'"
    END IF


    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')


    #No.FUN-A60011  --Begin
    #IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
    #   LET g_sql="SELECT sfb01 FROM sfb_file ",
    #             " WHERE sfb87!='X' AND ",g_wc CLIPPED, " ORDER BY sfb01"
    #ELSE
    LET g_sql="SELECT DISTINCT sfb01",
              "  FROM sfb_file,ecm_file ",
              " WHERE sfb01=ecm01 ",
              "   AND sfb87!='X' AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY sfb01"
    #END IF
    #No.FUN-A60011  --End

    PREPARE i700_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i700_cs SCROLL CURSOR WITH HOLD FOR i700_prepare
    #No.FUN-A60011  --Begin
    #IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
    #   LET g_sql= "SELECT COUNT(*) FROM sfb_file WHERE ",g_wc CLIPPED
    #ELSE
    LET g_sql= "SELECT COUNT(sfb01) FROM sfb_file ",
               " WHERE sfb87 !='X' AND ",g_wc CLIPPED,
               "   AND sfb01 IN ( SELECT DISTINCT ecm01 FROM ecm_file ",
               "   WHERE ",g_wc2 CLIPPED,") "
    #END IF
    #No.FUN-A60011  --End
    PREPARE i700_precount FROM g_sql
    DECLARE i700_count CURSOR FOR i700_precount

END FUNCTION

FUNCTION i700_menu()

   WHILE TRUE
      CALL i700_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i700_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                SELECT * INTO g_sfb.* FROM sfb_file
                 WHERE sfb01 = g_sfb.sfb01
                CALL  i700_show()
               CALL i700_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF

      #FUN-B10056 ----Begin----
         WHEN "chkbom"
            IF cl_chk_act_auth() THEN
               CALL i700_chkbom()
            END IF
      #FUN-B10056 ---End----
            
      #FUN-A10044  ---BENGIN---
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i700_out()
            END IF
      #FUN-A10044  ---END---
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "wo_routing_qt_status"
            IF cl_chk_act_auth() THEN
               LET g_cmd = "aecq700 '",g_sfb.sfb01,"'"
               CALL cl_cmdrun(g_cmd)
            END IF
         WHEN "wo_cell_details"
            IF NOT cl_null(g_sfb.sfb01) AND NOT cl_null(g_sfb.sfb05) THEN
               LET g_cmd = "aeci710 '",g_sfb.sfb01,"' '",g_sfb.sfb05 clipped,"'"
               CALL cl_cmdrun(g_cmd)
            END IF
         WHEN "related_time"
            CALL i700_more('d')
            CLOSE WINDOW i700_w4        #No.TQC-790064
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecm),'','')
            END IF
         #apsi312
         WHEN "aps_related_data_aps_ecm"
            IF cl_chk_act_auth() THEN
                CALL i700_aps_ecm('Y')  #TQC-8C0016 mod
            END IF
         #apsi311
         WHEN "aps_lock_route_time"
            IF g_rec_b >=1 THEN #FUN-9C0019 add if 判斷
               IF cl_chk_act_auth() THEN
                  #FUN-960102 MOD --STR---------------------
                  #CALL i700_aps_lrt()
                   IF g_ecm[l_ac].ecm61 = 'Y' THEN
                      CALL cl_err('','aps-765',1)
                   ELSE
                      CALL i700_aps_lrt()
                   END IF
                  #FUN-960102 MOD --END---------------------
            END IF
            #FUN-9C0019 --add---str---
            ELSE
                CALL cl_err('','arm-034',1)
            END IF
            #FUN-9C0019 --add---end---

         #apsi315
         WHEN "aps_lock_used_machine"
            #FUN-960102 MARK --STR---------------------------
            #IF cl_chk_act_auth() THEN
            #   CALL i700_aps_lum('Y') #TQC-8A0013 多傳'Y'
            #END IF
            #FUN-960102 MARK --END---------------------------
            IF g_rec_b >=1 THEN #FUN-9C0019 add if 判斷
               #FUN-960102 ADD --STR----------------------------
                IF cl_chk_act_auth() THEN
                   IF g_ecm[l_ac].ecm61 = 'N' THEN
                      CALL cl_err('','aps-764',1)
                   ELSE
                      CALL i700_aps_lum('Y')
                   END IF
                END IF
               #FUN-960102 ADD --END----------------------------
            #FUN-9C0019 --add---str---
            ELSE
                CALL cl_err('','arm-034',1)
            END IF
            #FUN-9C0019 --add---end---

         #FUN-960102 MARK --STR--------------------------------------------
         ##apsi324
         #WHEN "aps_routes_subc_data"
         #   IF cl_chk_act_auth() THEN
         #       CALL i700_aps_rsd()
         #   END IF
         ##平行加工
         #WHEN "aps_processing"
         #   IF cl_chk_act_auth() THEN
         #       IF l_ac >= 1 THEN
         #           IF g_ecm[l_ac].ecm61 = 'Y' THEN
         #               CALL i700_aps_vlj()                   #平行加工
         #               CALL i700_show()                      #重新顯示
         #           ELSE
         #               CALL cl_err('','aps-015',1) #平行加工的資料才需維護
         #           END IF
         #       ELSE
         #           CALL cl_err('','100',1) #無此筆資料,或任何上下筆資料,或其他相關主檔資料 !
         #       END IF
         #   END IF
         #FUN-960102 MARK END-----------------------------------------------

         #apsi331  FUN-890096
         WHEN "aps_route_tools"
               #FUN-9C0019--mark---str--
               #IF l_ac >0 THEN
               #   CALL i700_aps_vnm()
               #END IF
               #FUN-9C0019--mark---end--
               #FUN-9C0019--add----str--
               IF g_rec_b >=1 THEN
                   IF cl_chk_act_auth() THEN
                       CALL i700_aps_vnm()
                   END IF
               ELSE
                   CALL cl_err('','arm-034',1)
               END IF
               #FUN-9C0019--add----end--

         #No.FUN-A60011  --Begin
         WHEN "subcontract"
               CALL i700_subcontract()
         #No.FUN-A60011  --End
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_sfb.sfb01 IS NOT NULL THEN
                 LET g_doc.column1 = "sfb01"
                 LET g_doc.value1 = g_sfb.sfb01
                 CALL cl_doc()
               END IF
           END IF

         #FUN-960102 ADD --STR------------------
         WHEN "aps_resourceno_change"
            LET g_success = 'N'
            IF g_sfb.sfb04 ='1' OR g_sfb.sfb04='8' THEN
               CALL cl_err('','aps-766',1)
               LET g_success = 'Y'
            ELSE                              #FUN-9C0019 add else
               IF g_rec_b >=1 THEN            #FUN-9C0019 add if 判斷
                   IF cl_chk_act_auth() THEN  #FUN-9C0019 add if 判斷
                       IF g_ecm[l_ac].ecm61='Y' THEN
                          CALL cl_err('','aps-767',1)
                          LET g_success='Y'
                       END IF
                       #==>已有生產日報資料,不可做變更!
                       SELECT ecm311 INTO l_ecm311
                         FROM ecm_file
                        WHERE ecm01 = g_sfb.sfb01
                          AND ecm03 = g_ecm[l_ac].ecm03
                       IF l_ecm311 >= 1 THEN
                          #已有生產日報資料,不可變更!
                          CALL cl_err('','aps-768',1)
                          LET g_success='Y'
                       END IF
                       IF g_success = 'N' AND g_sma.sma901='Y' THEN
                          CALL i700_ecm_resource_change()
                       END IF
               #FUN-9C0019 --add---str---
                   END IF
               ELSE
                   CALL cl_err('','arm-034',1)
               END IF
               #FUN-9C0019 --add---end---
            END IF
         #FUN-960102 ADD --END------------------

      END CASE
   END WHILE
   CLOSE i700_cs
END FUNCTION

FUNCTION i700_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sfb.* TO NULL              #No.FUN-6A0039
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt

    CALL i700_cs()                          # 宣告 SCROLL CURSOR

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_ecm.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "

    OPEN i700_count
    FETCH i700_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i700_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
       INITIALIZE g_sfb.* TO NULL
    ELSE
       CALL i700_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF

    MESSAGE ""

END FUNCTION

FUNCTION i700_fetch(p_flsfb)
    DEFINE
        p_flsfb         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER

    CASE p_flsfb
        WHEN 'N' FETCH NEXT     i700_cs INTO g_sfb.sfb01
        WHEN 'P' FETCH PREVIOUS i700_cs INTO g_sfb.sfb01
        WHEN 'F' FETCH FIRST    i700_cs INTO g_sfb.sfb01
        WHEN 'L' FETCH LAST     i700_cs INTO g_sfb.sfb01
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
            FETCH ABSOLUTE g_jump i700_cs INTO g_sfb.sfb01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsfb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_sfb.* FROM sfb_file       # 重讀DB,因TEMP有不被更新特性
       WHERE sfb01 = g_sfb.sfb01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","",1) #FUN-660091
       INITIALIZE g_sfb.* TO NULL
    ELSE
       LET g_data_owner = g_sfb.sfbuser      #FUN-4C0034
       LET g_data_group = g_sfb.sfbgrup      #FUN-4C0034
       LET g_data_plant = g_sfb.sfbplant #FUN-980030
       CALL i700_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i700_show()
 DEFINE l_smydesc    LIKE smy_file.smydesc,
        l_smyslip    LIKE smy_file.smyslip

    LET g_sfb_t.* = g_sfb.*
    DISPLAY BY NAME
        g_sfb.sfb01, g_sfb.sfb05, g_sfb.sfb24,g_sfb.sfb81, g_sfb.sfb98,
        g_sfb.sfb99, g_sfb.sfb02, g_sfb.sfb13, g_sfb.sfb15, g_sfb.sfb06,
        g_sfb.sfb07, g_sfb.sfb08, g_sfb.sfb09, g_sfb.sfb071, g_sfb.sfb081,
        g_sfb.sfb12, g_sfb.sfb82, g_sfb.sfb22, g_sfb.sfb221, g_sfb.sfb87,
        g_sfb.sfb919,                                                      #FUN-A80150 add
        g_sfb.sfb103,                                                     #No.FUN-810014
        g_sfb.sfborig,g_sfb.sfboriu,                                      #No.TQC-B40026
        g_sfb.sfbuser,g_sfb.sfbgrup,g_sfb.sfbmodu,g_sfb.sfbdate,g_sfb.sfbacti
    INITIALIZE g_ima.* TO NULL

    CALL i700_sfb02(g_sfb.sfb02) RETURNING g_buf
    DISPLAY g_buf TO sfb02_d

    CALL s_get_doc_no(g_sfb.sfb01) RETURNING l_smyslip    #No.FUN-560014
    LET l_smydesc = ''
    SELECT smydesc INTO l_smydesc FROM smy_file
     WHERE smyslip = l_smyslip
    DISPLAY l_smydesc TO smydesc
    CALL i700_sfb05()
    CALL i700_sfb82()
    CALL i700_b_tot()
    CALL i700_b_fill(g_wc2)

    CASE g_sfb.sfb87
         WHEN 'Y'   LET g_confirm = 'Y'
                    LET g_void = ''
         WHEN 'N'   LET g_confirm = 'N'
                    LET g_void = ''
         WHEN 'X'   LET g_confirm = ''
                    LET g_void = 'Y'
      OTHERWISE     LET g_confirm = ''
                    LET g_void = ''
    END CASE
    IF NOT cl_null(g_sfb.sfb28) THEN
       LET g_close = 'Y'
    ELSE
       LET g_close = 'N'
    END IF
    #圖形顯示
    CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION i700_sfb02(p_sfb02)
    DEFINE	
           p_sfb02      LIKE sfb_file.sfb02       #No.FUN-680073 SMALLINT
    DEFINE
           l_str        LIKE cre_file.cre08        # No.FUN-680073 VARCHAR(10)
     CASE WHEN p_sfb02 = 1 LET l_str=g_x[1] CLIPPED
          WHEN p_sfb02 = 5 LET l_str=g_x[2] CLIPPED
          WHEN p_sfb02 = 7 LET l_str=g_x[3] CLIPPED
          WHEN p_sfb02 = 8 LET l_str=g_x[4] CLIPPED
          WHEN p_sfb02 =11 LET l_str=g_x[5] CLIPPED
          WHEN p_sfb02 =13 LET l_str=g_x[6] CLIPPED
          WHEN p_sfb02 =15 LET l_str=g_x[7] CLIPPED
     END CASE
    RETURN l_str
END FUNCTION

FUNCTION i700_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,     #No.FUN-680073   VARCHAR(1), #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680073 SMALLINT
    l_sw            LIKE type_file.num5,     #No.FUN-680073 SMALLINT,
    l_sw_aps        LIKE type_file.num5,     #No.FUN-9A0047 add
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否    #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態      #No.FUN-680073 VARCHAR(1)
   #l_ecm03         LIKE type_file.chr18,    #No.FUN-680073 INTEGER,  #TQC-A80017
    l_ecm03         LIKE type_file.num10,    #TQC-A80017
    l_ecmacti       LIKE ecm_file.ecmacti,   #No.TQC-710004 add
    l_allow_insert  LIKE type_file.num5,     #可新增否      #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否       #No.FUN-680073 SMALLINT
    l_cnt           LIKE type_file.num5,    #FUN-870092 add
    l_sfb43         LIKE sfb_file.sfb43     #FUN-930120 add
DEFINE l_cnt1       LIKE type_file.num5     #FUN-B20078 add    

    LET g_action_choice = ""
    LET l_sfb43 = g_sfb.sfb43     #FUN-930120 add
    IF g_sfb.sfb01 IS NULL THEN RETURN END IF
    IF g_sfb.sfb04 = '8' THEN CALL cl_err('','aap-730',0) RETURN END IF
    IF g_sfb.sfb87='Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
    IF g_sfb.sfb87='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF s_shut(0) THEN RETURN END IF
    IF (g_sfb.sfb93<>'Y') OR (cl_null(g_sfb.sfb93)) THEN
       CALL cl_err('','asf-088',1)
       RETURN
    END IF

    IF g_sfb.sfb43 MATCHES '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql =
       #"SELECT ecm03,ecm011,ecm012,'',ecm04,ecm45,ecm61,ecm06,'','',ecm14,ecm13,ecm16,ecm15,", #FUN-870092 add ecm61  #No.FUN-A60011   #FUN-B10056 mark
       #"SELECT ecm03,ecm011,ecm012,ecm014,ecm015,ecm04,ecm45,ecm61,ecm06,'','',ecm14,ecm13,ecm16,ecm15,",    #FUN-B10056 add ecm014,ecm015  #FUN-B20078 mark
       #"SELECT ecm03,ecm011,ecm012,ecm014,ecm015,'',ecm04,ecm45,ecm61,ecm06,'','',ecm14,ecm13,ecm16,ecm15,",  #FUN-B20078  #FUN-9A0048 mark
        "SELECT ecm03,ecm011,ecm012,ecm014,ecm015,'',ecm04,ecm45,ecm61,ecm06,'','','',ecm14,ecm13,'',ecm16,ecm15,",  #FUN-B20078  #FUN-9A0048 add
        "       '','','','',",                      #No.FUN-810014 #No.TQC-BC0166 add ''
        "       ecm49,ecm50,ecm51,ecm05,'',ecm66,ecm52,ecm67,ecm321,ecm53,ecm54,ecm55,", #TQC-8C0016 add ''  #FUN-A80150 add ecm66,ecm67
       #"       ecm56,ecm58,ecm62,ecm63,ecm65,ecm12,ecm34,ecm64 FROM ecm_file ",  #MOD-490091                   #No.FUN-A60011  #FUN-9A0048 mark
        "       ecm56,'',ecm58,ecm62,ecm63,ecm65,ecm12,ecm34,ecm64,ta_ecm01,ta_ecm02,ta_ecm03 FROM ecm_file ",  #MOD-490091                   #No.FUN-A60011  #FUN-9A0048 add
        " WHERE ecm01= ? AND ecm03= ?  AND ecm012 = ? FOR UPDATE"       #No.FUN-A60011
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_ecm WITHOUT DEFAULTS FROM s_ecm.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF


        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()

            BEGIN WORK

            OPEN i700_cl USING g_sfb.sfb01
            IF STATUS THEN
               CALL cl_err("OPEN i700_cl:", STATUS, 1)
               CLOSE i700_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i700_cl INTO g_sfb.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE i700_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN

               LET p_cmd='u'
               LET g_ecm_t.* = g_ecm[l_ac].*  #BACKUP
               LET g_ecm58_t = g_ecm[l_ac].ecm58       #FUN-BB0084
               OPEN i700_bcl USING g_sfb.sfb01,g_ecm_t.ecm03,g_ecm_t.ecm012   #No.FUN-A60011
               IF STATUS THEN
                  CALL cl_err("OPEN i700_bcl:", STATUS, 1)
                  CLOSE i700_bcl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  FETCH i700_bcl INTO g_ecm[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ecm_t.ecm03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL i700_ecm06('d')
                     CALL i700_ecm014(g_ecm[l_ac].ecm015) RETURNING g_ecm[l_ac].ecr02   #FUN-B20078
                   # CALL i700_ecm012('d')   #No.FUN-A60011   #FUN-B10056 mark                    
                  END IF
               END IF
               SELECT vmn08,vmn081,vmn18                                      #FUN-9A0047 add vmn18
                     ,vmn20,vmn21                                             #FUN-9A0048 add
                 INTO g_ecm[l_ac].vmn08,g_ecm[l_ac].vmn081,g_ecm[l_ac].vmn18  #FUN-9A0047 add vmn18
                     ,g_ecm[l_ac].vmn20,g_ecm[l_ac].vmn21                     #FUN-9A0048 add
                 FROM vmn_file
                WHERE vmn01 = g_sfb.sfb05
                  AND vmn02 = g_sfb.sfb01
                  AND vmn03 = g_ecm[l_ac].ecm03
                  AND vmn04 = g_ecm[l_ac].ecm04
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF g_sma.sma901 = 'Y' THEN
                CALL i700_set_entry_b(p_cmd)
                CALL i700_set_no_entry_b(p_cmd)
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ecm[l_ac].* TO NULL      #900423
            LET g_ecm[l_ac].ecm14 = 0
            LET g_ecm[l_ac].ecm13 = 0
            LET g_ecm[l_ac].ecm49 = 0
            LET g_ecm[l_ac].ecm66 = 'Y'    #FUN-A80150 add
            LET g_ecm[l_ac].ecm52 = 'N'
            LET g_ecm[l_ac].ecm53 = 'N'
            LET g_ecm[l_ac].ecm54 = 'N'
           #No.FUN-A60011  --Begin
            LET g_ecm[l_ac].ecm62 = 1
            LET g_ecm[l_ac].ecm63 = 1
            LET g_ecm[l_ac].ecm321= 0
            LET g_ecm[l_ac].ecm65 = 0
            LET g_ecm[l_ac].ecm12 = 0
            LET g_ecm[l_ac].ecm34 = 0
            LET g_ecm[l_ac].ecm64 = 1
           #DISPLAY g_ecm[l_ac].ecm57
           #LET g_ecm[l_ac].ecm57=g_ima55
            LET g_ecm[l_ac].ecm58=g_ima55   #MOD-490091
           #LET g_ecm[l_ac].ecm59=1         #MOD-490091
           #DISPLAY g_ecm[l_ac].ecm57
           #No.FUN-A60011  --End
            LET g_ecm[l_ac].ecm61 = 'N' #FUN-870092 add
            LET g_ecm[l_ac].ecmslk01 = 'N' #No.TQC-BC0166 add
            LET g_ecm_t.* = g_ecm[l_ac].*         #新輸入資料
            LET g_ecm58_t = NULL        #FUN-BB0084 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ecm03

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           #FUN-9A0047---mark---str---
           #IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
           #    IF cl_null(g_ecm[l_ac].ecm05) AND cl_null(g_ecm[l_ac].vmn08) THEN
           #        #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
           #        CALL cl_err('','aps-033',1)
           #        LET g_ecm[l_ac].* = g_ecm_t.*
           #        CANCEL INSERT
           #    END IF
           #END IF
           #FUN-9A0047---mark---end---

           #No.FUN-A60011  --Begin
           #IF NOT cl_null(g_ecm[l_ac].ecm04) THEN
           #   CALL i700_ecm59()  #No.B282 010503 by plum add
           #END IF
           #No.FUN-A60011  --End

           #FUN-A80150---add---start---
            IF cl_null(g_ecm[l_ac].ecm66) THEN
               LET g_ecm[l_ac].ecm66 = 'Y'
            END IF
            IF cl_null(g_ecm[l_ac].ecm012) THEN
               LET g_ecm[l_ac].ecm012 = ' '
            END IF
           #FUN-A80150---add---end---
            IF cl_null(g_ecm[l_ac].ecm52) THEN
               LET g_ecm[l_ac].ecm52 = 'N'
            END IF
            IF cl_null(g_ecm[l_ac].ecm53) THEN
               LET g_ecm[l_ac].ecm53 = 'N'
            END IF
            IF cl_null(g_ecm[l_ac].ecm54) THEN
               LET g_ecm[l_ac].ecm54 = 'N'
            END IF
           #No.FUN-A60011  --Begin
           #DISPLAY "g_ecm[l_ac].ecm57=",g_ecm[l_ac].ecm57
            DISPLAY "g_ecm[l_ac].ecm58=",g_ecm[l_ac].ecm58
           #DISPLAY "g_ecm[l_ac].ecm59=",g_ecm[l_ac].ecm59
           #No.FUN-A60011  --EnD
            LET l_ecmacti = 'Y'            #No.TQC-710004 add
 #FUN-B10056 -----------Begin-ADD---------------------             
            IF g_ecm[l_ac].ecm015 IS NULL THEN
               LET g_ecm[l_ac].ecm015 = ' '
            END IF
 #FUN-B10056 -----------End-ADD-----------------------
           #FUN-B20070--begin--add----
            IF cl_null(g_ecm[l_ac].ecm65) OR g_ecm[l_ac].ecm65=0 THEN
               CALL cralc_eck_rate(g_sfb.sfb01,g_ecm[l_ac].ecm03,g_ecm[l_ac].ecm012,g_sfb.sfb08,g_ecm[l_ac].ecm12,g_ecm[l_ac].ecm34,
                                   g_ecm[l_ac].ecm64,g_ecm[l_ac].ecm62/g_ecm[l_ac].ecm63,1)
               RETURNING g_ecm[l_ac].ecm65
               LET g_ecm[l_ac].ecm65 = s_digqty(g_ecm[l_ac].ecm65,g_ecm[l_ac].ecm58)   #FUN-BB0084
               DISPLAY BY NAME g_ecm[l_ac].ecm65     #FUN-BB0084 
            END IF
           #FUN-B20070--end--add-----
           #No.FUN-A60011  --Begin
            INSERT INTO ecm_file(ecm01,ecm03_par,ecm03,ecm04,ecm45,ecm61,ecm06,ecm14,ecm13,    # No.MOD-610024 add ecm03_par #FUN-870092 add ecm61
                                 ecm16,ecm15,
                                 ecm49,ecm50,ecm51,ecm05,ecm66,ecm52,ecm67,                  #No.FUN-810014  #FUN-A80150 add ecm66,ecm67
                                 ecm53,ecm54,ecm55,ecm56,ecm301,ecm302,ecm311,
                                 ecm312,ecm313,ecm314,ecm315,ecm322,
                                 ecm291,ecm292,ecm303,ecm316,ecm11,ecm57,
                                 ecm58,ecm59,ecm07,ecm08,ecm09,ecm10,ecm20,
                                 ecm21,ecm22,ecm23,ecm24,ecm17,ecm18,ecm19,
                                 ecm37,ecm38,ecm39,ecmacti,
                                 ecm35,               #No.FUN-8A0136
                                 ecmplant,ecmlegal,  #FUN-980002
                                 ecm014,ecm015,      #FUN-B10056  add
                                 ecm011,ecm012,ecm62,ecm63,ecm321,ecm65,ecm12,ecm34,ecm64,
                                 ta_ecm01,ta_ecm02,ta_ecm03)
                          VALUES(g_sfb.sfb01,g_sfb.sfb05,g_ecm[l_ac].ecm03,   # No.MOD-610024 add sfb05
                                 g_ecm[l_ac].ecm04,g_ecm[l_ac].ecm45,g_ecm[l_ac].ecm61, #FUN-870092 add ecm61
                                 g_ecm[l_ac].ecm06,g_ecm[l_ac].ecm14,
                                 g_ecm[l_ac].ecm13,g_ecm[l_ac].ecm16,
                                 g_ecm[l_ac].ecm15,
                                 g_ecm[l_ac].ecm49,g_ecm[l_ac].ecm50,
                                 g_ecm[l_ac].ecm51,g_ecm[l_ac].ecm05,
                                 g_ecm[l_ac].ecm66,                        #FUN-A80150 add
                                 g_ecm[l_ac].ecm52,g_ecm[l_ac].ecm67,g_ecm[l_ac].ecm53,  #FUN-A80150 add ecm67
                                 g_ecm[l_ac].ecm54,g_ecm[l_ac].ecm55,
                                 g_ecm[l_ac].ecm56,0,0,0,0,0,0,0,0,0,0,0,0,
                                 g_sfb.sfb06,g_ecm[l_ac].ecm58,                        #ecm57=ecm58 FUN-A60011
                                 g_ecm[l_ac].ecm58,1,
                                 g_ecm07,g_ecm08,g_ecm09,g_ecm10,g_ecm20,
                                 g_ecm21,g_ecm22,g_ecm23,g_ecm24,
                                 g_ecm17,g_ecm18,g_ecm19,g_ecm37,
                                 g_ecm38,g_ecm39,l_ecmacti,
                                 0,         #No.FUN-8A0136
                                 g_plant,g_legal, #FUN-980002
                                 g_ecm[l_ac].ecm014,g_ecm[l_ac].ecm015,   #FUN-B10056  add
                                 g_ecm[l_ac].ecm011, g_ecm[l_ac].ecm012, #g_ecm[l_ac].ecm62,  #FUN-A60095
                                 g_ecm[l_ac].ecm62, g_ecm[l_ac].ecm63, g_ecm[l_ac].ecm321,
                                 g_ecm[l_ac].ecm65, g_ecm[l_ac].ecm12, g_ecm[l_ac].ecm34,
                                 g_ecm[l_ac].ecm64, g_ecm[l_ac].ta_ecm01, g_ecm[l_ac].ta_ecm02, g_ecm[l_ac].ta_ecm03)
           #No.FUN-A60011  --End
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ecm_file",g_sfb.sfb01,g_ecm[l_ac].ecm03,SQLCA.sqlcode,"","ins ecm:",1) #FUN-660091
               CANCEL INSERT
            ELSE

               LET l_sfb43 = '0'    #FUN-930120 add
               MESSAGE 'INSERT O.K'
               CALL i700_b_tot()
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               CALL i700_chk_ecm011()      #FUN-B10056 add
            END IF
            IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                IF g_ecm[l_ac].ecm61 = 'Y' THEN
                   #CALL i700_aps_vlj()     #FUN-960102 MARK
                    CALL i700_aps_lum('Y')  #FUN-960102 ADD
                END IF
                CALL i700_aps_ecm('N')  #TQC-8C0016 add
            END IF

        BEFORE FIELD ecm03                        #default 序號
            IF g_ecm[l_ac].ecm03 IS NULL OR
               g_ecm[l_ac].ecm03 = 0 THEN
               SELECT max(ecm03)+1 INTO g_ecm[l_ac].ecm03 FROM ecm_file
                WHERE ecm01 = g_sfb.sfb01
                IF g_ecm[l_ac].ecm03 IS NULL THEN
                   LET g_ecm[l_ac].ecm03 = 1
                END IF
            END IF
	
        AFTER FIELD ecm03
            IF NOT cl_null(g_ecm[l_ac].ecm03) THEN
               #No.FUN-A60011  --Begin
               IF g_ecm[l_ac].ecm03 != g_ecm_t.ecm03  OR g_ecm_t.ecm03  IS NULL OR
                  g_ecm[l_ac].ecm012!= g_ecm_t.ecm012 OR g_ecm_t.ecm012 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM ecm_file
                    WHERE ecm03 = g_ecm[l_ac].ecm03
                      AND ecm012= g_ecm[l_ac].ecm012
                      AND ecm01 = g_sfb.sfb01
               #No.FUN-A60011  --End
                   IF l_n > 0 THEN CALL cl_err('','aec-013',0)
                      NEXT FIELD ecm03
                   END IF
                   #No.FUN-A60011  --Begin
                   SELECT ecm58
                     INTO g_ecm[l_ac].ecm58
                     FROM ecm_file
                    WHERE ecm01=g_sfb.sfb01 AND ecm03=g_ecm[l_ac].ecm03
                   #IF cl_null(g_ecm[l_ac].ecm57) THEN
                   #   LET g_ecm[l_ac].ecm57=g_ima55
                   #END IF
                   #No.FUN-A60011  --End
                   IF cl_null(g_ecm[l_ac].ecm58) THEN
                      LET g_ecm[l_ac].ecm58=g_ima55
                   END IF
                   #FUN-BB0084 -------Begin-------    
                   IF NOT t700_ecm12_chk() THEN
                      LET g_ecm58_t = g_ecm[l_ac].ecm58
                      NEXT FIELD ecm12
                   END IF   
                   LET g_ecm58_t = g_ecm[l_ac].ecm58
                   #FUN-BB0084 -------End---------  
               END IF
            END IF

        #No.FUN-A60011  --Begin
        AFTER FIELD ecm012
            IF NOT cl_null(g_ecm[l_ac].ecm012) THEN
               IF g_ecm[l_ac].ecm03 != g_ecm_t.ecm03  OR g_ecm_t.ecm03  IS NULL OR
                  g_ecm[l_ac].ecm012!= g_ecm_t.ecm012 OR g_ecm_t.ecm012 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM ecm_file
                    WHERE ecm03 = g_ecm[l_ac].ecm03
                      AND ecm012= g_ecm[l_ac].ecm012
                      AND ecm01 = g_sfb.sfb01
                   IF l_n > 0 THEN CALL cl_err('','aec-313',0)
                      NEXT FIELD ecm012
                   END IF
               END IF
            #  CALL i700_ecm012('a')   #FUN-B10056 mark
#FUN-B20078 ------------------Begin-------------------------
               IF g_ecm[l_ac].ecm012!= g_ecm_t.ecm012 OR g_ecm_t.ecm012 IS NULL THEN
                  SELECT COUNT(*) INTO l_cnt1 FROM ecr_file
                   WHERE ecr01 = g_ecm[l_ac].ecm012 
                     AND ecracti = 'Y'
                  IF l_cnt1 < = 0 THEN
                     CALL cl_err(g_ecm[l_ac].ecm012,'aec-050',0)
                     NEXT FIELD ecm012
                  END IF
                  CALL i700_ecm014(g_ecm[l_ac].ecm012) RETURNING g_ecm[l_ac].ecm014
               END IF
               DISPLAY g_ecm[l_ac].ecm014 TO ecm014
#FUN-B20078 ------------------End---------------------------
#FUN-B10056 -------------Begin-add--------------------------
              SELECT ecm014,ecm015 INTO g_ecm[l_ac].ecm014,g_ecm[l_ac].ecm015 FROM ecm_file             
               WHERE ecm01 = g_sfb.sfb01
                 AND ecm03 = g_ecm[l_ac].ecm03
                 AND ecm012 = g_ecm[l_ac].ecm012
               IF g_ecm[l_ac].ecm015 IS NULL THEN
                 LET g_ecm[l_ac].ecm015 = ' '
               END IF  
#FUN-B10056 -------------End-add----------------------------                
               IF NOT cl_null(g_errno) THEN
                  LET g_ecm[l_ac].ecm012 = g_ecm_t.ecm012
                  NEXT FIELD ecm012
               END IF
            END IF

#FUN-B10056 --------Begin-add--------------------------------
        AFTER FIELD ecm015    
           IF NOT cl_null(g_ecm[l_ac].ecm015) THEN
#FUN-B20078 ------------------Begin-------------------------
              SELECT COUNT(*) INTO l_cnt1 FROM ecr_file
               WHERE ecr01 = g_ecm[l_ac].ecm015
                 AND ecracti = 'Y'
              IF l_cnt1 < = 0 THEN
                 CALL cl_err(g_ecm[l_ac].ecm015,'aec-050',0)
                 NEXT FIELD ecm015
              END IF
              CALL i700_ecm014(g_ecm[l_ac].ecm015) RETURNING g_ecm[l_ac].ecr02
              DISPLAY g_ecm[l_ac].ecr02 TO ecr02
#              IF NOT s_schdat_ecm012(g_sfb.sfb01,g_ecm[l_ac].ecm015) THEN    
#                 NEXT FIELD ecm015
#              END IF
#FUN-B20078 ------------------End---------------------------
            END IF           
#FUN-B10056 --------End--add---------------------------------            
        AFTER FIELD ecm62
            IF NOT cl_null(g_ecm[l_ac].ecm62) THEN
               IF g_ecm[l_ac].ecm62 <= 0 THEN
                  CALL cl_err(g_ecm[l_ac].ecm62,'axr-034',1)
                  NEXT FIELD ecm62
               END IF
               #FUN-B90141 --START--
               IF NOT i700_chk_ecm63() THEN               
                  NEXT FIELD ecm62
               END IF 
               #FUN-B90141 --END--  
            END IF

        AFTER FIELD ecm63
            IF NOT cl_null(g_ecm[l_ac].ecm63) THEN
               IF g_ecm[l_ac].ecm63 <= 0 THEN
                  CALL cl_err(g_ecm[l_ac].ecm63,'axr-034',1)
                  NEXT FIELD ecm63
               END IF
               #FUN-B90141 --START--
               IF NOT i700_chk_ecm63() THEN               
                  NEXT FIELD ecm63
               END IF 
               #FUN-B90141 --END-- 
            END IF

        AFTER FIELD ecm64
            IF NOT cl_null(g_ecm[l_ac].ecm64) THEN
               IF g_ecm[l_ac].ecm64 <= 0 THEN
                  CALL cl_err(g_ecm[l_ac].ecm64,'axr-034',1)
                  NEXT FIELD ecm64
               END IF
            END IF

        AFTER FIELD ecm12
#FUN-BB0084 -------------Begin----------
           IF NOT t700_ecm12_chk() THEN
              NEXT FIELD ecm12
           END IF 
#FUN-BB0084 -------------End------------
#FUN-BB0084 ----------------Begin-----------------
#           IF NOT cl_null(g_ecm[l_ac].ecm12) THEN
#              IF g_ecm[l_ac].ecm12 < 0 THEN
#                 CALL cl_err(g_ecm[l_ac].ecm12,'axm-179',1)
#                 NEXT FIELD ecm12
#              END IF
#           END IF
#FUN-BB0084 ----------------End-------------------

        AFTER FIELD ecm34
            IF NOT cl_null(g_ecm[l_ac].ecm34) THEN
               IF g_ecm[l_ac].ecm34 < 0 THEN
                  CALL cl_err(g_ecm[l_ac].ecm34,'axm-179',1)
                  NEXT FIELD ecm34
               END IF
            END IF

        #No.FUN-A60011  --End

        AFTER FIELD ecm04
            IF NOT cl_null(g_ecm[l_ac].ecm04) THEN
               CALL i700_ecm04('a')
            END IF

        #FUN-960102 ADD --STR----------------------------------------------
        ON CHANGE ecm61
           IF g_ecm[l_ac].ecm61='Y' AND g_ecm[l_ac].ecm52='Y' THEN
              CALL cl_err('','aps-769',1)
              LET g_ecm[l_ac].ecm61='N'
              NEXT FIELD ecm61
           END IF
           IF g_ecm[l_ac].ecm61='N' THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt
                FROM vne_file
               WHERE vne01 = g_sfb.sfb01
                 AND vne02 = g_sfb.sfb01
                 AND vne03 = g_ecm[l_ac].ecm03
                 AND vne04 = g_ecm[l_ac].ecm04
              IF l_cnt >= 1 THEN
                 IF NOT cl_confirm('aps-770') THEN #已有鎖定設備資料,確定是否刪除
                    LET g_ecm[l_ac].ecm61 = 'Y'
                    DISPLAY BY NAME g_ecm[l_ac].ecm61
                    NEXT FIELD ecm61
                 ELSE
                    DELETE FROM vne_file
                     WHERE vne01 = g_sfb.sfb01
                       AND vne02 = g_sfb.sfb01
                       AND vne03 = g_ecm_t.ecm03
                       AND vne04 = g_ecm_t.ecm04
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","vne_file",g_sfb.sfb01,g_ecm_t.ecm03,SQLCA.sqlcode,"","",1)
                       LET g_ecm[l_ac].ecm61 = 'Y'
                       DISPLAY BY NAME g_ecm[l_ac].ecm61
                       NEXT FIELD ecm61
                    END IF
                    DELETE FROM vnd_file
                     WHERE vnd01 = g_sfb.sfb01
                       AND vnd03 = g_ecm_t.ecm03
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","vnd_file",g_sfb.sfb01,g_ecm_t.ecm03,SQLCA.sqlcode,"","",1)
                       LET g_ecm[l_ac].ecm61 = 'Y'
                       DISPLAY BY NAME g_ecm[l_ac].ecm61
                       NEXT FIELD ecm61
                    END IF
                 END IF
              END IF
           #FUN-980080 add--str---
           ELSE
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt
                FROM vnd_file
               WHERE vnd01 = g_sfb.sfb01
                 AND vnd03 = g_ecm_t.ecm03
              IF l_cnt >= 1 THEN
                 #已有APS鎖定製程時間資料,將會刪除,是否確定變更?
                 IF NOT cl_confirm('aps-802') THEN
                    LET g_ecm[l_ac].ecm61 = 'N'
                    DISPLAY BY NAME g_ecm[l_ac].ecm61
                    NEXT FIELD ecm61
                 ELSE
                    DELETE FROM vnd_file
                     WHERE vnd01 = g_sfb.sfb01
                       AND vnd03 = g_ecm_t.ecm03
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","vnd_file",g_sfb.sfb01,g_ecm_t.ecm03,SQLCA.sqlcode,"","",1)
                       LET g_ecm[l_ac].ecm61 = 'N'
                       DISPLAY BY NAME g_ecm[l_ac].ecm61
                       NEXT FIELD ecm61
                    END IF
                 END IF
              END IF
           #FUN-980080 add--end---
           END IF


        ON CHANGE ecm52
           IF g_ecm[l_ac].ecm52='Y' AND g_ecm[l_ac].ecm61='Y' THEN
              CALL cl_err('','aps-769',1)
              LET g_ecm[l_ac].ecm52='N'
              NEXT FIELD ecm52
           END IF
        #FUN-960102 ADD --END-----------------------------------------------

        #FUN-9A0048 add---str----
        ON CHANGE vmn20
           IF NOT cl_null(g_ecm[l_ac].vmn20) THEN
               LET g_ecm[l_ac].ecm14 = g_ecm[l_ac].vmn20 * g_sfb.sfb08
           END IF
        ON CHANGE vmn21
           IF NOT cl_null(g_ecm[l_ac].vmn21) THEN
               LET g_ecm[l_ac].ecm16 = g_ecm[l_ac].vmn21 * g_sfb.sfb08
           END IF
        #FUN-9A0048 add---end----

        #FUN-960102 MARK --STR---------------------------------------------
        #AFTER FIELD ecm61
        #   CALL cl_set_comp_required("ecm05",FALSE) #TQC-8C0066
        #   IF g_ecm[l_ac].ecm61 != g_ecm_t.ecm61 OR cl_null(g_ecm_t.ecm61) THEN
        #       IF g_ecm[l_ac].ecm61 = 'Y' THEN
        #          #有串APS時,且平行加工否為'Y'
        #          #整體參數資源型態設機器時,機器編號NOT NULL,REQUIRED
        #          IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
        #              IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
        #                  CALL cl_set_comp_required("ecm05",TRUE)
        #                  CALL cl_err('','aps-035',0) #因為資源型態設機器,若要做平行加工,機器編號不可空白!
        #              END IF
        #          END IF
        #       ELSE
        #          CALL cl_set_comp_required("ecm05",FALSE)
        #       END IF
        #       IF g_ecm[l_ac].ecm61 = 'N' THEN
        #           SELECT COUNT(*) INTO l_cnt
        #             FROM vlj_file
        #            WHERE vlj01 = g_sfb.sfb01
        #              AND vlj02 = g_sma.sma917
        #              AND vlj03 = g_ecm[l_ac].ecm03
        #              AND vlj05 <> 0
        #           IF l_cnt >= 1 THEN
        #               IF NOT cl_confirm('aps-016') THEN #已有平行加工資料,確定變更?
        #                   LET g_ecm[l_ac].ecm61 = 'Y'
        #                   DISPLAY BY NAME g_ecm[l_ac].ecm61
        #                   NEXT FIELD ecm61
        #               END IF
        #           END IF
        #           DELETE FROM vlj_file
        #            WHERE vlj01 = g_sfb.sfb01
        #              AND vlj02 = g_sma.sma917
        #              AND vlj03 = g_ecm[l_ac].ecm03
        #           DELETE FROM vne_file
        #             WHERE vne01 = g_sfb.sfb01
        #               AND vne02 = g_sfb.sfb01
        #               AND vne03 = g_ecm[l_ac].ecm03
        #       END IF
        #   END IF
        #   CALL i700_set_entry_b(p_cmd)
        #   CALL i700_set_no_entry_b(p_cmd)
        #FUN-960102 MARK --END--------------------------------------------

        AFTER FIELD ecm06                  #check 序號是否重複
            IF NOT cl_null(g_ecm[l_ac].ecm06) THEN
               CALL i700_ecm06('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_ecm[l_ac].ecm06 = g_ecm_t.ecm06
                  NEXT FIELD ecm06
                  DISPLAY BY NAME g_ecm[l_ac].ecm06
               END IF

              #FUN-960102 MARK --STR----------------------------------------
              #IF g_sma.sma901 = 'Y' AND g_ecm[l_ac].ecm61 = 'Y' THEN #有串APS且平行加工為'Y'
              #    IF g_ecm[l_ac].ecm06 != g_ecm_t.ecm06 OR cl_null(g_ecm_t.ecm06) THEN
              #        SELECT count(*) INTO l_n FROM vlj_file
              #         WHERE vlj01 = g_sfb.sfb01
              #           AND vlj02 = g_sma.sma917
              #           AND vlj03 = g_ecm[l_ac].ecm03
              #           AND vlj06 = g_ecm[l_ac].ecm06
              #        IF l_n > 0 THEN
              #            #APS平行加工內資源代號重覆!
              #            CALL cl_err(g_ecm[l_ac].ecm06,'aps-022',1)
              #            LET g_ecm[l_ac].ecm06 = g_ecm_t.ecm06
              #            NEXT FIELD ecm06
              #        END IF
              #    END IF
              #END IF
              #FUN-960102 MARK --END-----------------------------------------
            END IF
        #有串APS時:
        #整體參數資源型態設機器時,機器編號ecm05和資源群組編號(機器)vmn08至少要有一個欄位有值
        AFTER FIELD vmn08
            IF NOT cl_null(g_ecm[l_ac].vmn08) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vme_file
                 WHERE vme01 = g_ecm[l_ac].vmn08
                IF l_cnt = 0 THEN
                    CALL cl_err('','aps-404',1)
                    LET g_ecm[l_ac].vmn08 = g_ecm_t.vmn08
                    DISPLAY BY NAME g_ecm[l_ac].vmn08
                    NEXT FIELD vmn08
                END IF
            END IF
           #FUN-9A0047---mark---str----
           #IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
           #   #FUN-960102 MARK --STR----------------------------
           #   #IF g_ecm[l_ac].ecm61 = 'Y' THEN
           #   #    IF cl_null(g_ecm[l_ac].ecm05) THEN
           #   #        CALL cl_err('','aps-035',1)
           #   #    END IF
           #   #ELSE
           #   #FUN-960102 MARK --END----------------------------
           #        IF cl_null(g_ecm[l_ac].ecm05) AND cl_null(g_ecm[l_ac].vmn08) THEN
           #            #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
           #            CALL cl_err('','aps-033',1)
           #            NEXT FIELD ecm05
           #        END IF
           #   #END IF   #FUN-960102 MARK
           #END IF
           #FUN-9A0047---mark---end----
        AFTER FIELD vmn081
            IF NOT cl_null(g_ecm[l_ac].vmn081) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vmp_file
                 WHERE vmp01 = g_ecm[l_ac].vmn081
                IF l_cnt = 0 THEN
                    CALL cl_err('','aps-405',1)
                    LET g_ecm[l_ac].vmn081 = g_ecm_t.vmn081
                    DISPLAY BY NAME g_ecm[l_ac].vmn081
                    NEXT FIELD vmn081
                END IF
            END IF

        #FUN-9A0047 add---str----
        AFTER FIELD vmn18
            IF NOT cl_null(g_ecm[l_ac].vmn18) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM pmc_file
                 WHERE pmc01   = g_ecm[l_ac].vmn18
                   AND pmcacti = 'Y'
                IF l_cnt = 0 THEN
                    CALL cl_err('','aom-061',1)
                    NEXT FIELD vmn18
                END IF
            END IF
        #FUN-9A0047 add---end----

        AFTER FIELD ecm14
            IF g_ecm[l_ac].ecm14<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD ecm14
            END IF

        AFTER FIELD ecm13
            IF g_ecm[l_ac].ecm13<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD ecm13
            END IF

        AFTER FIELD ecm16
            IF g_ecm[l_ac].ecm16<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD ecm16
            END IF

        AFTER FIELD ecm15
            IF g_ecm[l_ac].ecm15<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD ecm15
            END IF
        AFTER FIELD ecm49
            IF g_ecm[l_ac].ecm49<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD ecm49
            END IF

        BEFORE FIELD ecm50
            IF g_sma.sma901 = 'Y' THEN
                CALL i700_set_entry_b(p_cmd)
                CALL i700_set_no_entry_b(p_cmd)
            END IF
        BEFORE FIELD ecm51
            IF g_sma.sma901 = 'Y' THEN
                CALL i700_set_entry_b(p_cmd)
                CALL i700_set_no_entry_b(p_cmd)
            END IF

        AFTER FIELD ecm51
            IF g_ecm[l_ac].ecm51<g_ecm[l_ac].ecm50 THEN
                   CALL cl_err('','aec-993',0)
                   NEXT FIELD ecm51
            END IF
        AFTER FIELD ecm05
            #FUN-960102 MARK --STR------------------------------------------
            #IF cl_null(g_ecm[l_ac].ecm05) AND g_ecm[l_ac].ecm61 = 'Y' THEN
            #    #有串APS時,且平行加工否為'Y'
            #    #整體參數資源型態設機器時,機器編號NOT NULL,REQUIRED
            #    IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
            #        IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
            #            CALL cl_err('','aps-035',1) #因為資源型態設機器,若要做平行加工,機器編號不可空白!
            #            LET g_ecm[l_ac].ecm05 = g_ecm_t.ecm05
            #            DISPLAY BY NAME g_ecm[l_ac].ecm05
            #        END IF
            #    END IF
            #END IF
            #IF NOT cl_null(g_ecm[l_ac].ecm05) THEN
            #   SELECT COUNT(*) INTO g_cott FROM eci_file
            #    WHERE eci01 = g_ecm[l_ac].ecm05
            #   IF g_cott IS NULL OR g_cott = 0  THEN
            #      CALL cl_err('','aec-011',0)
            #      LET g_ecm[l_ac].ecm05 = g_ecm_t.ecm05
            #      NEXT FIELD ecm05
            #      DISPLAY BY NAME g_ecm[l_ac].ecm05
            #   END IF
            #   IF g_sma.sma901 = 'Y' AND g_ecm[l_ac].ecm61 = 'Y' THEN #有串APS且平行加工為'Y'
            #       IF g_ecm[l_ac].ecm05 != g_ecm_t.ecm05 OR cl_null(g_ecm_t.ecm05) THEN
            #           SELECT count(*) INTO l_n FROM vlj_file
            #            WHERE vlj01 = g_sfb.sfb01
            #              AND vlj02 = g_sma.sma917
            #              AND vlj03 = g_ecm[l_ac].ecm03
            #              AND vlj06 = g_ecm[l_ac].ecm05
            #           IF l_n > 0 THEN
            #               #APS平行加工內資源代號重覆!
            #               CALL cl_err(g_ecm[l_ac].ecm05,'aps-022',1)
            #               LET g_ecm[l_ac].ecm05 = g_ecm_t.ecm05
            #               NEXT FIELD ecm05
            #           END IF
            #       END IF
            #  END IF
            #END IF
            #FUN-960102 MARK --END---------------------------------------

            #FUN-960102 ADD --STR----------------------------------------
            IF NOT cl_null(g_ecm[l_ac].ecm05) THEN
               SELECT COUNT(*) INTO g_cott FROM eci_file
                WHERE eci01 = g_ecm[l_ac].ecm05
               IF g_cott IS NULL OR g_cott = 0  THEN
                  CALL cl_err('','aec-011',0)
                  LET g_ecm[l_ac].ecm05 = g_ecm_t.ecm05
                  NEXT FIELD ecm05
                  DISPLAY BY NAME g_ecm[l_ac].ecm05
               END IF
            END IF
            #FUN-960102 ADD --END----------------------------------------
    
       #FUN-A80150---add---start---
        AFTER FIELD ecm66
            IF NOT cl_null(g_ecm[l_ac].ecm66) THEN
               IF g_ecm[l_ac].ecm66 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD ecm66
               END IF
            END IF
       #FUN-A80150---add---end---

        AFTER FIELD ecm52
            IF NOT cl_null(g_ecm[l_ac].ecm52) THEN
               IF g_ecm[l_ac].ecm52 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD ecm52
               END IF
            END IF

       #FUN-A80150---add---start---
        AFTER FIELD ecm67 
            IF NOT cl_null(g_ecm[l_ac].ecm67) THEN
               CALL i700_ecm67()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ecm[l_ac].ecm67,g_errno,0)
                  NEXT FIELD ecm67
               END IF
            END IF
       #FUN-A80150---add---end---

        AFTER FIELD ecm53
            IF NOT cl_null(g_ecm[l_ac].ecm53) THEN
               IF g_ecm[l_ac].ecm53 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD ecm53
               END IF
            END IF

        BEFORE FIELD ecm54
            CALL i700_set_entry_b(p_cmd)

        AFTER FIELD ecm54
            IF NOT cl_null(g_ecm[l_ac].ecm54) THEN
               IF g_ecm[l_ac].ecm54 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD ecm54
               END IF

               IF g_ecm[l_ac].ecm54 ='N' THEN
                  LET g_ecm[l_ac].ecm55 = ' '
                  DISPLAY BY NAME g_ecm[l_ac].ecm55
               END IF

               CALL i700_set_no_entry_b(p_cmd)

            END IF

        AFTER FIELD ecm55
            IF NOT cl_null(g_ecm[l_ac].ecm55) THEN
               CALL i700_sgg(g_ecm[l_ac].ecm55)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ecm[l_ac].ecm55=g_ecm_t.ecm55
                  NEXT FIELD ecm55
                  DISPLAY BY NAME g_ecm[l_ac].ecm55
               END IF
            END IF

        AFTER FIELD ecm56
            IF NOT cl_null(g_ecm[l_ac].ecm56) THEN
               CALL i700_sgg(g_ecm[l_ac].ecm56)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ecm[l_ac].ecm56=g_ecm_t.ecm56
                  NEXT FIELD ecm56
                  DISPLAY BY NAME g_ecm[l_ac].ecm56
               END IF
            END IF

        #No.FUN-A60011  --Begin
        #AFTER FIELD ecm57
        #    IF NOT cl_null(g_ecm[l_ac].ecm57) THEN
        #       SELECT COUNT(*) INTO g_cnt FROM gfe_file
        #        WHERE gfe01=g_ecm[l_ac].ecm57
        #       IF g_cnt=0 THEN
        #          CALL cl_err(g_ecm[l_ac].ecm57,'mfg2605',0)
        #          NEXT FIELD g_ecm[l_ac].ecm57
        #       END IF
        #       CALL i700_ecm59()
        #       IF g_sw = '1' THEN
        #          NEXT FIELD ecm57
        #       END IF
        #    END IF
        #No.FUN-A60011  --End

        AFTER FIELD ecm58
            IF NOT cl_null(g_ecm[l_ac].ecm58) THEN
               SELECT COUNT(*) INTO g_cnt FROM gfe_file
                WHERE gfe01=g_ecm[l_ac].ecm58
               IF g_cnt=0 THEN
                  CALL cl_err(g_ecm58,'mfg2605',0)
                  NEXT FIELD g_ecm58
               END IF
               #No.FUN-A60011  --Begin
               #CALL i700_ecm59()
               #IF g_sw = '1' THEN
               #   NEXT FIELD ecm57
               #END IF
               #No.FUN-A60011  --End
            END IF
        #FUN-BB0084 -------Begin-------    
            IF NOT t700_ecm12_chk() THEN
               LET g_ecm58_t = g_ecm[l_ac].ecm58
               NEXT FIELD ecm12
            END IF   
            LET g_ecm58_t = g_ecm[l_ac].ecm58
        #FUN-BB0084 -------End---------  

        BEFORE DELETE                            #是否取消單身
            IF g_ecm_t.ecm03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF

               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               DELETE FROM ecm_file
                WHERE ecm01 = g_sfb.sfb01
                  AND ecm03 = g_ecm_t.ecm03
                  AND ecm012= g_ecm_t.ecm012   #No.FUN-A60011

               DELETE FROM vne_file
                WHERE vne01 = g_sfb.sfb01
                  AND vne03 = g_ecm_t.ecm03

               DELETE FROM vnd_file
                WHERE vnd01 = g_sfb.sfb01
                  AND vnd03 = g_ecm_t.ecm03

               DELETE FROM vng_file
                WHERE vng01 = g_sfb.sfb01
                  AND vng03 = g_ecm_t.ecm03

               DELETE FROM vmn_file
                WHERE vmn02 = g_sfb.sfb01
                  AND vmn03 = g_ecm_t.ecm03

               DELETE FROM vnm_file
                WHERE vnm00 = g_sfb.sfb05
                  AND vnm01 = g_sfb.sfb01
                  AND vnm02 = g_ecm[l_ac].ecm03
                  AND vnm03 = g_ecm[l_ac].ecm04
               IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                  #FUN-960102 MOD --STR--------------------------------
                  # IF g_ecm[l_ac].ecm61 = 'Y' THEN
                  #     DELETE FROM vlj_file
                  #      WHERE vlj01 = g_sfb.sfb01
                  #        AND vlj02 = g_sma.sma917
                  #        AND vlj03 = g_ecm[l_ac].ecm03
                  # END IF
                  # DELETE FROM vne_file
                  #   WHERE vne01 = g_sfb.sfb01
                  #     AND vne02 = g_sfb.sfb01
                  #     AND vne03 = g_ecm[l_ac].ecm03
                   IF g_ecm[l_ac].ecm61 = 'Y' THEN
                      DELETE FROM vne_file
                       WHERE vne01 = g_sfb.sfb01
                         AND vne02 = g_sfb.sfb01
                         AND vne03 = g_ecm[l_ac].ecm03
                   END IF
                  #FUN-960102 MOD --END---------------------------------
               END IF

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ecm_file",g_sfb.sfb01,g_ecm_t.ecm03,SQLCA.sqlcode,"","",1) #FUN-660091
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE
                  DELETE FROM sgd_file
                   WHERE sgd01=g_sfb.sfb05 AND sgd02=g_sfb.sfb06
                     AND sgd00 = g_sfb.sfb01
                     AND sgd03 = g_ecm_t.ecm03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","sgd_file",g_sfb.sfb01,g_ecm_t.ecm03,SQLCA.sqlcode,"","",1) #FUN-660091
                     ROLLBACK WORK
                     CANCEL DELETE
                  ELSE
                     LET l_sfb43 = '0'    #FUN-930120 add
                     LET g_rec_b=g_rec_b-1
                     DISPLAY g_rec_b TO FORMONLY.cn2
                     COMMIT WORK
                  END IF
                  #CALL i700_chk_ecm011()  #FUN-B10056 add #No.TQC-B60028
                  CALL i700sub_ecm011(g_sfb.sfb01)         #No.TQC-B60028
               END IF
               CALL i700_b_tot()
            END IF


        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ecm[l_ac].* = g_ecm_t.*
               CLOSE i700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
               #FUN-9A0047---mark---str---
               #IF cl_null(g_ecm[l_ac].ecm05) AND cl_null(g_ecm[l_ac].vmn08) THEN
               #    #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
               #    CALL cl_err('','aps-033',1)
               #    LET g_ecm[l_ac].* = g_ecm_t.*
               #    CLOSE i700_bcl
               #    ROLLBACK WORK
               #    EXIT INPUT
               #END IF
               #FUN-9A0047---mark---end---

                #FUN-960054 ADD --STR-----------------------------
                 IF g_ecm[l_ac].ecm52 <> g_ecm_t.ecm52 AND
                    g_ecm[l_ac].ecm52='N'  THEN
                    SELECT * FROM vnd_file
                     WHERE vnd01  = g_sfb.sfb01
                       AND vnd02  = g_sfb.sfb01
                       AND vnd03  = g_ecm[l_ac].ecm03
                       AND vnd04  = g_ecm[l_ac].ecm04
                    IF SQLCA.SQLCODE != 100 THEN
                      IF (cl_confirm("aps-762")) THEN
                         DELETE FROM vnd_file
                          WHERE vnd01  = g_sfb.sfb01
                            AND vnd02  = g_sfb.sfb01
                            AND vnd03  = g_ecm[l_ac].ecm03
                            AND vnd04  = g_ecm[l_ac].ecm04
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            LET g_ecm[l_ac].* = g_ecm_t.*
                            EXIT INPUT
                         END IF
                      ELSE
                         LET g_ecm[l_ac].* = g_ecm_t.*
                         EXIT INPUT
                      END IF
                    END IF
                 END IF
                #FUN-960054 ADD --END-----------------------------
            END IF

            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ecm[l_ac].ecm03,-263,1)
               LET g_ecm[l_ac].* = g_ecm_t.*
            ELSE
               #No.FUN-A60011  --Begin
               #IF NOT cl_null(g_ecm[l_ac].ecm04) THEN
               #   IF g_sw = '1' THEN
               #      NEXT FIELD ecm57
               #   END IF
               #END IF
               #No.FUN-A60011  --End

              #FUN-A80150---add---start---
               IF cl_null(g_ecm[l_ac].ecm66) THEN
                  LET g_ecm[l_ac].ecm66 = 'Y'
               END IF
              #FUN-A80150---add---end---
               IF cl_null(g_ecm[l_ac].ecm52) THEN
                  LET g_ecm[l_ac].ecm52 = 'N'
               END IF
               IF cl_null(g_ecm[l_ac].ecm53) THEN
                  LET g_ecm[l_ac].ecm53 = 'N'
               END IF
               IF cl_null(g_ecm[l_ac].ecm54) THEN
                  LET g_ecm[l_ac].ecm54 = 'N'
               END IF

            #FUN-B20070--begin--add----
            IF g_ecm[l_ac].ecm12 <> g_ecm_t.ecm12 OR g_ecm[l_ac].ecm34<>g_ecm_t.ecm34 OR
               g_ecm[l_ac].ecm64 <> g_ecm_t.ecm64 OR g_ecm[l_ac].ecm62<>g_ecm_t.ecm62 OR
               g_ecm[l_ac].ecm63 <> g_ecm_t.ecm63 THEN
               CALL cralc_eck_rate(g_sfb.sfb01,g_ecm[l_ac].ecm03,g_ecm[l_ac].ecm012,g_sfb.sfb08,g_ecm[l_ac].ecm12,g_ecm[l_ac].ecm34,
                                   g_ecm[l_ac].ecm64,g_ecm[l_ac].ecm62/g_ecm[l_ac].ecm63,1)
               RETURNING g_ecm[l_ac].ecm65
               LET g_ecm[l_ac].ecm65 = s_digqty(g_ecm[l_ac].ecm65,g_ecm[l_ac].ecm58)      #FUN-BB0084
               DISPLAY BY NAME g_ecm[l_ac].ecm65     #FUN-BB0084 
            END IF
            #FUN-B20070--end--add-----
               IF g_ecm[l_ac].ecm015 IS NULL THEN LET g_ecm[l_ac].ecm015=' ' END IF  #FUN-B10056
               UPDATE ecm_file SET ecm03=g_ecm[l_ac].ecm03,
                                   ecm04=g_ecm[l_ac].ecm04,
                                   ecm45=g_ecm[l_ac].ecm45,
                                   ecm61=g_ecm[l_ac].ecm61, #FUN-870092 add ecm61
                                   ecm06=g_ecm[l_ac].ecm06,
                                   ecm14=g_ecm[l_ac].ecm14,
                                   ecm13=g_ecm[l_ac].ecm13,
                                   ecm16=g_ecm[l_ac].ecm16,
                                   ecm15=g_ecm[l_ac].ecm15,
                                   ecm49=g_ecm[l_ac].ecm49,
                                   ecm50=g_ecm[l_ac].ecm50,
                                   ecm51=g_ecm[l_ac].ecm51,
                                   ecm05=g_ecm[l_ac].ecm05,
                                   ecm66=g_ecm[l_ac].ecm66,       #FUN-A80150 add
                                   ecm52=g_ecm[l_ac].ecm52,
                                   ecm67=g_ecm[l_ac].ecm67,       #FUN-A80150 add
                                   ecm53=g_ecm[l_ac].ecm53,
                                   ecm54=g_ecm[l_ac].ecm54,
                                   ecm55=g_ecm[l_ac].ecm55,
                                   ecm56=g_ecm[l_ac].ecm56,
                                   ecm11=g_sfb.sfb06,
                                   #ecm57=g_ecm[l_ac].ecm57,  #No.FUN-A60011
                                   ecm58=g_ecm[l_ac].ecm58,
                                   #ecm59=g_ecm[l_ac].ecm59,  #No.FUN-A60011
                                   ecm07=g_ecm07,
                                   ecm08=g_ecm08,
                                   ecm09=g_ecm09,
                                   ecm10=g_ecm10,
                                   ecm20=g_ecm20,
                                   ecm21=g_ecm21,
                                   ecm22=g_ecm22,
                                   ecm23=g_ecm23,
                                   ecm24=g_ecm24,
                                   ecm17=g_ecm17,
                                   ecm18=g_ecm18,
                                   ecm19=g_ecm19,
                                   ecm37=g_ecm37,
                                   ecm38=g_ecm38,
                                   ecm39=g_ecm39,
                                   #No.FUN-A60011  --Begin
                                   ecm011=g_ecm[l_ac].ecm011,
                                   ecm012=g_ecm[l_ac].ecm012,
                                   ecm62 =g_ecm[l_ac].ecm62,
                                   ecm63 =g_ecm[l_ac].ecm63,
                                   ecm321=g_ecm[l_ac].ecm321,
                                   ecm65 =g_ecm[l_ac].ecm65,
                                   ecm12 =g_ecm[l_ac].ecm12,
                                   ecm34 =g_ecm[l_ac].ecm34,
                                   ecm64 =g_ecm[l_ac].ecm64,
                                   #No.FUN-A60011  --End
                                   #str—add by huanglf 160713
                                   ta_ecm01=g_ecm[l_ac].ta_ecm01,
                                   ta_ecm02=g_ecm[l_ac].ta_ecm02,
                                   ta_ecm03=g_ecm[l_ac].ta_ecm03 ,
                                   #end—add by huanglf 160713
                                   ecm014 = g_ecm[l_ac].ecm014,  #FUN-B10056 add
                                   ecm015 = g_ecm[l_ac].ecm015   #FUN-B10056 add
                WHERE ecm01=g_sfb.sfb01
                  AND ecm03=g_ecm_t.ecm03
                  AND ecm012=g_ecm_t.ecm012    #No.FUN-A60011

               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","ecm_file",g_sfb.sfb01,g_ecm_t.ecm03,SQLCA.sqlcode,"","",1) #FUN-660091
                  LET g_ecm[l_ac].* = g_ecm_t.*
               ELSE
                  LET g_ecm_t.* = g_ecm[l_ac].*   #FUN-960102 ADD
                  UPDATE sgd_file SET sgd03 = g_ecm[l_ac].ecm03
                   WHERE sgd01=g_sfb.sfb05 AND sgd02=g_sfb.sfb06
                     AND sgd00 = g_sfb.sfb01
                     AND sgd03 = g_ecm_t.ecm03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","sgd_file",g_sfb.sfb01,g_ecm_t.ecm03,SQLCA.sqlcode,"","",1) #FUN-660091
                     LET g_ecm[l_ac].* = g_ecm_t.*
                  ELSE
                     LET l_sfb43 = '0'    #FUN-930120 add
                     MESSAGE 'UPDATE O.K'
                     CALL i700_b_tot()
                     IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                         UPDATE vmn_file
                            SET vmn08  = g_ecm[l_ac].vmn08,
                                vmn081 = g_ecm[l_ac].vmn081,
                                vmn18  = g_ecm[l_ac].vmn18,  #FUN-9A0047 add
                                vmn20  = g_ecm[l_ac].vmn20,  #FUN-9A0048 add
                                vmn21  = g_ecm[l_ac].vmn21   #FUN-9A0048 add
                          WHERE vmn01 = g_sfb.sfb05
                            AND vmn02 = g_sfb.sfb01
                            AND vmn03 = g_ecm[l_ac].ecm03
                            AND vmn04 = g_ecm[l_ac].ecm04
                         IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","vmn_file",g_sfb.sfb05,g_sfb.sfb01,SQLCA.sqlcode,"","",1)
                             LET g_ecm[l_ac].* = g_ecm_t.*
                         END IF
                     END IF
                     COMMIT WORK
                  END IF
#FUN-B10056 ---------------------------Begin------------------------------
                  IF (g_ecm[l_ac].ecm012 <> g_ecm_t.ecm012) OR
                     (g_ecm[l_ac].ecm015 <> g_ecm_t.ecm015) OR 
                     (cl_null(g_ecm[l_ac].ecm015) AND NOT cl_null(g_ecm[l_ac].ecm015)) OR
                     (NOT cl_null(g_ecm[l_ac].ecm015) AND cl_null(g_ecm[l_ac].ecm015)) THEN 
                     CALL i700_chk_ecm011()    
                  END IF
#FUN-B10056 ---------------------------End--------------------------------
                  SELECT COUNT(*) INTO l_n FROM sgd_file
                   WHERE sgd01 = g_sfb.sfb05
                     AND sgd02 = g_sfb.sfb06
                     AND sgd00 = g_sfb.sfb01
                     AND sgd03 = g_ecm_t.ecm03
                  IF l_n > 0 THEN
                     UPDATE sgd_file SET sgd04 = g_ecm[l_ac].ecm06
                      WHERE sgd01 = g_sfb.sfb05
                        AND sgd02 = g_sfb.sfb06
                        AND sgd00 = g_sfb.sfb01
                        AND sgd03 = g_ecm[l_ac].ecm03
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","sgc_file","","",SQLCA.sqlcode,"","",1)
                     END IF
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                IF g_ecm[l_ac].ecm61 = 'Y' THEN
                   #CALL i700_aps_vlj()     #FUN-960102 MARK
                    CALL i700_aps_lum('Y')  #FUN-960102 ADD
                END IF
            END IF

        #FUN-9A0047 add---str---
        AFTER INPUT
        IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
            CALL i700_chk_aps() RETURNING l_sw_aps
            IF l_sw_aps THEN
                CONTINUE INPUT
            END IF
        END IF
        #FUN-9A0047 add---end---

        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_ecm[l_ac].* = g_ecm_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ecm.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i700_bcl
               ROLLBACK WORK
               #FUN-9A0047 add---str---
               #IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN                              #FUN-D40030 mark
               IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' AND cl_null(g_action_choice) THEN  #FUN-D40030 add
                   CONTINUE INPUT
               END IF
               #FUN-9A0047 add---end---
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i700_bcl
            COMMIT WORK


        ON ACTION related_time
           CALL i700_more('u')
           CLOSE WINDOW i700_w4     #No.TQC-790064

       #FUN-960102 MARK --STR----------------------
       ##串apsi312
       #ON ACTION aps_related_data_aps_ecm
       #   CALL i700_aps_ecm('Y') #TQC-8C0016 mod
       #FUN-960102 MARK --END----------------------

       #FUN-960054 MARK --STR-------------
       ##apsi311
       #ON ACTION aps_lock_route_time
       #   CALL i700_aps_lrt()
       #FUN-960054 MARK --END-------------

       #FUN-960102 MARK --STR-----------------------------
       ##apsi315
       #ON ACTION aps_lock_used_machine
       #   #FUN-960054 MOD --STR---------------------------
       #   #CALL i700_aps_lum('Y') #TQC-8A0013 多傳'Y'
       #    IF g_ecm[l_ac].ecm52 = 'Y' THEN
       #       CALL cl_err('','aps-759',1)
       #    ELSE
       #       CALL i700_aps_lum('Y')
       #    END IF
       #   #FUN-960054 MOD --END---------------------------
       #FUN-960102 MARK --END------------------------------

       #apsi324
       #FUN-960054 MARK --STR---------------
       #ON ACTION aps_routes_subc_data
       #   CALL i700_aps_rsd()
       #FUN-960054 MARK --END---------------

        ON ACTION controlp
           CASE
              #No.FUN-A60011  --Begin
              WHEN INFIELD(ecm012)                #工艺段号
                   CALL cl_init_qry_var()
                #   LET g_qryparam.form = 'q_ecu012_1'    #FUN-B10056 mark
                #   LET g_qryparam.form = 'q_ecb012_1'    #FUN-B10056     #FUN-B20078 mark
                   LET g_qryparam.form = 'q_ecr'          #FUN-B20078
               #   LET g_qryparam.arg1 = g_sfb.sfb05      #FUN-B10056 mark
               #   LET g_qryparam.arg1 = g_sfb.sfb01      #FUN-B10056     #FUN-B20078 mark
               #   LET g_qryparam.arg2 = g_sfb.sfb06      #FUN-B10056 mark
                   LET g_qryparam.default1 = g_ecm[l_ac].ecm012
                   CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm012
                   NEXT FIELD ecm012
              #No.FUN-A60011  --End
#FUN-B20078 ------------------------Begin--------------------------
              WHEN INFIELD(ecm015)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecr"
                   LET g_qryparam.default1 = g_ecm[l_ac].ecm015
                   CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm015
                   DISPLAY BY NAME g_ecm[l_ac].ecm015
                   NEXT FIELD ecm015
#FUN-B20078 ------------------------End----------------------------
              WHEN INFIELD(ecm05)                 #機械編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_eci"
                   LET g_qryparam.default1 = g_ecm[l_ac].ecm05
                   CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm05
                    DISPLAY BY NAME g_ecm[l_ac].ecm05     #No.MOD-490371
                   NEXT FIELD ecm05
             #FUN-A80150---add---start---
              WHEN INFIELD(ecm67) #廠商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_ecm[l_ac].ecm67
                 CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm67
                 DISPLAY g_ecm[l_ac].ecm67 TO s_ecm[l_ac].ecm67
                 NEXT FIELD ecm67 
             #FUN-A80150---add---end---
              WHEN INFIELD(ecm06)                 #生產站別
                   CALL q_eca(FALSE,TRUE,g_ecm[l_ac].ecm06) RETURNING g_ecm[l_ac].ecm06
                    DISPLAY BY NAME g_ecm[l_ac].ecm06     #No.MOD-490371
                   NEXT FIELD ecm06
              WHEN INFIELD(ecm04)                 #作業編號
                   CALL q_ecd(FALSE,TRUE,g_ecm[l_ac].ecm04) RETURNING g_ecm[l_ac].ecm04
                    DISPLAY BY NAME g_ecm[l_ac].ecm04     #No.MOD-490371
                   NEXT FIELD ecm04
              WHEN INFIELD(ecm55)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_ecm[l_ac].ecm55
                   CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm55
                    DISPLAY BY NAME g_ecm[l_ac].ecm55       #No.MOD-490371
                   NEXT FIELD ecm55
              WHEN INFIELD(ecm56)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_ecm[l_ac].ecm56
                   CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm56
                    DISPLAY BY NAME g_ecm[l_ac].ecm56         #No.MOD-490371
                   NEXT FIELD ecm56
              #FUN-9A0047--add----str----
              WHEN INFIELD(vmn18)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc2"
                   LET g_qryparam.default1 = g_ecm[l_ac].vmn18
                   CALL cl_create_qry() RETURNING g_ecm[l_ac].vmn18
#                   CALL FGL_DIALOG_SETBUFFER( g_ecm[l_ac].vmn18 )
                    DISPLAY BY NAME g_ecm[l_ac].vmn18
                   NEXT FIELD vmn18
              #FUN-9A0047--add----end----
              #No.FUN-A60011  --Begin
              #WHEN INFIELD(ecm57)
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_gfe"
              #     LET g_qryparam.default1 = g_ecm[l_ac].ecm57
              #     CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm57
              #     DISPLAY BY NAME g_ecm[l_ac].ecm57
              #     NEXT FIELD ecm57
              #No.FUN-A60011  --End
              WHEN INFIELD(ecm58)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_ecm[l_ac].ecm58
                   CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm58
                   DISPLAY BY NAME g_ecm[l_ac].ecm58
                   NEXT FIELD ecm58
              WHEN INFIELD(vmn08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_vme01"
                   CALL cl_create_qry() RETURNING g_ecm[l_ac].vmn08
                   DISPLAY BY NAME g_ecm[l_ac].vmn08
                   NEXT FIELD vmn08
              WHEN  INFIELD(vmn081)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_vmp01"
                    CALL cl_create_qry() RETURNING g_ecm[l_ac].vmn081
                    DISPLAY BY NAME g_ecm[l_ac].vmn081
                    NEXT FIELD vmn081
           END CASE

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ecm03) AND l_ac > 1 THEN
                LET g_ecm[l_ac].* = g_ecm[l_ac-1].*
                NEXT FIELD ecm03
            END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()


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
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

    END INPUT

    UPDATE sfb_file SET sfbmodu=g_user,
                        sfbdate=TODAY,
                        sfb43 = l_sfb43     #FUN-930120 add
           WHERE sfb01=g_sfb.sfb01

   #CALL i700_check_ecm301()  #FUN-A60095

    CLOSE i700_bcl
    COMMIT WORK

    CALL  i700_chk_unit() RETURNING l_sw

END FUNCTION

#FUN-BB0084 --------------------Begin-----------------------
FUNCTION t700_ecm12_chk()
   IF NOT cl_null(g_ecm[l_ac].ecm12) THEN
      IF g_ecm[l_ac].ecm12 < 0 THEN
         CALL cl_err(g_ecm[l_ac].ecm12,'axm-179',1)
         RETURN FALSE 
      END IF
      IF NOT cl_null(g_ecm[l_ac].ecm58) THEN
         IF cl_null(g_ecm58_t) OR cl_null(g_ecm_t.ecm12) OR g_ecm58_t! = g_ecm[l_ac].ecm58
            OR g_ecm_t.ecm12! = g_ecm[l_ac].ecm12 THEN
            LET g_ecm[l_ac].ecm12 = s_digqty(g_ecm[l_ac].ecm12,g_ecm[l_ac].ecm58)
            DISPLAY BY NAME g_ecm[l_ac].ecm12 
         END IF
      END IF   
   END IF   
   RETURN TRUE   
END FUNCTION             
#FUN-BB0084 --------------------End------------------------- 

#FUN-B20078 ------------------------------Begin-------------------------------
FUNCTION i700_ecm014(p_ecr01)
DEFINE   p_ecr01     LIKE ecr_file.ecr01
DEFINE   l_ecr02     LIKE ecr_file.ecr02
   DECLARE i700_ecm014_curs CURSOR FOR 
    SELECT DISTINCT ecm014 FROM ecm_file
     WHERE ecm01 = g_sfb.sfb01
       AND ecm012 = p_ecr01
   FOREACH i700_ecm014_curs INTO l_ecr02 
      IF NOT cl_null(l_ecr02) THEN
         EXIT FOREACH
      ELSE 
         CONTINUE FOREACH
      END IF
   END FOREACH
   IF cl_null(l_ecr02) THEN 
      SELECT ecr02 INTO l_ecr02 FROM ecr_file
       WHERE ecr01 = p_ecr01
         AND ecracti = 'Y'
#MOD-B30427 -----------------Begin---------------------
#       IF SQLCA.sqlcode THEN
#          CALL cl_err(p_ecr01,SQLCA.sqlcode,0)
#       END IF
#MOD-B30427 -----------------End-----------------------
   END IF
   RETURN l_ecr02
END FUNCTION
#FUN-B20078 ------------------------------End---------------------------------

FUNCTION i700_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)

    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("ecm55",TRUE)
    END IF

    IF INFIELD(ecm54) THEN
       CALL cl_set_comp_entry("ecm55",TRUE)
    END IF
    IF g_sma.sma901 = 'Y' THEN
        CALL cl_set_comp_entry("ecm50,ecm51",TRUE)
    END IF
END FUNCTION

FUNCTION i700_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
  DEFINE l_cnt   LIKE type_file.num5          #FUN-870092 add

    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       IF g_ecm[l_ac].ecm54 ='N' THEN
          CALL cl_set_comp_entry("ecm55",FALSE)
       END IF
    END IF

    IF INFIELD(ecm54) THEN
       IF g_ecm[l_ac].ecm54 ='N' THEN
          CALL cl_set_comp_entry("ecm55",FALSE)
       END IF
    END IF

    CALL cl_set_comp_entry("ecm45",FALSE)  #FUN-C50065
    #FUN-960102 MARK --STR---------------------------------
    #IF g_sma.sma901 = 'Y' AND g_ecm[l_ac].ecm61 = 'Y' THEN
    #    SELECT COUNT(*) INTO l_cnt
    #      FROM vlj_file
    #     WHERE vlj01 = g_sfb.sfb01
    #       AND vlj02 = g_sma.sma917
    #       AND vlj03 = g_ecm[l_ac].ecm03
    #    IF l_cnt >= 1 THEN
    #        CALL cl_set_comp_entry("ecm50,ecm51",FALSE)
    #    END IF
    #END IF
    #FUN-960102 MARK --END----------------------------------

END FUNCTION
# bugno:3915 第一站投入量ecm301=sfb08
FUNCTION i700_check_ecm301()
  DEFINE l_ecm012  LIKE ecm_file.ecm012         #No.FUN-A60011
  DEFINE l_ecm03   LIKE ecm_file.ecm03,
         l_ecm301  LIKE ecm_file.ecm301,
         l_cnt     LIKE type_file.num5          #No.FUN-680073 SMALLINT

 #-->單身無筆數不檢查了
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM ecm_file WHERE ecm01 = g_sfb.sfb01
    IF l_cnt = 0 THEN RETURN END IF

 #No.FUN-A60011  --Begin
 ##-->讀取工單之起始製程序號
 #   SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file WHERE ecm01=g_sfb.sfb01
 #   IF NOT STATUS THEN
 ##-->輸入為第一站時default ecm301=sfb08
 #      UPDATE ecm_file SET ecm301 = g_sfb.sfb08
 #       WHERE ecm01 = g_sfb.sfb01
 #         AND ecm03 = l_ecm03
 #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
 #         CALL cl_err3("upd","ecm_file",g_sfb.sfb01,l_ecm03,SQLCA.sqlcode,"","upd_ecm_ecm301",1) #FUN-660091
 #      END IF
 #   END IF
     DECLARE i700_ecm301_curs CURSOR FOR
      SELECT ecm012,MIN(ecm03) FROM ecm_file
       WHERE ecm01 = g_sfb.sfb01
       GROUP BY ecm012
     FOREACH i700_ecm301_curs INTO l_ecm012,l_ecm03
        IF SQLCA.sqlcode THEN
           CALL cl_err('forech i700_ecm301_curs',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        UPDATE ecm_file SET ecm301 = g_sfb.sfb08
         WHERE ecm01 = g_sfb.sfb01
           AND ecm03 = l_ecm03
           AND ecm012= l_ecm012
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","ecm_file",g_sfb.sfb01,l_ecm03,SQLCA.sqlcode,"","upd_ecm_ecm301",1) #FUN-660091
        END IF
     END FOREACH
 #No.FUN-A60011  --End
END FUNCTION

FUNCTION i700_b_tot()
    DEFINE
           ttnum1 LIKE type_file.num10         #No.FUN-680073 INTEGER
    DEFINE
           ttnum2 LIKE type_file.num10         #No.FUN-680073 INTEGER
    SELECT MIN(ecm03),MAX(ecm03) INTO ttnum1,ttnum2
            FROM ecm_file
           WHERE ecm01=g_sfb.sfb01
    IF ttnum1 IS NULL THEN LET ttnum1 = 0 END IF
    IF ttnum2 IS NULL THEN LET ttnum2 = 0 END IF
    DISPLAY  ttnum1,ttnum2 TO FORMONLY.a ,FORMONLY.b
END FUNCTION

FUNCTION i700_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680073 VARCHAR(200)
   # CONSTRUCT g_wc2 ON ecm03,ecm04,ecm45,ecm61,ecm06,ecm14,ecm13,ecm16,ecm15, #FUN-870092 add ecm61   #FUN-B10056
     CONSTRUCT g_wc2 ON ecm03,ecm011,ecm012,ecm014,ecm015,ecm04,ecm45,ecm61,ecm06,ecm14,ecm13,ecm16,ecm15, #FUN-B10056 add ecm011,ecm012,ecm014,ecm015
                       ecm49,ecm50,ecm51,ecm05,ecm66,ecm52,ecm67,ecm53,ecm54,ecm55,    #FUN-A80150 add ecm66,ecm67
                       ecm56
            FROM s_ecm[1].ecm03,s_ecm[1].ecm011,s_ecm[1].ecm012,s_ecm[1].ecm014,s_ecm[1].ecm015,  #FUN-B10056 add ecm011,ecm012,ecm014,ecm015
                 s_ecm[1].ecm04,s_ecm[1].ecm45,
                 s_ecm[1].ecm61,s_ecm[1].ecm06, #FUN-870092 add ecm61
                 s_ecm[1].ecm14,s_ecm[1].ecm13,s_ecm[1].ecm16,
                 s_ecm[1].ecm15,
                 s_ecm[1].ecm49,
                 s_ecm[1].ecm50,s_ecm[1].ecm51,s_ecm[1].ecm05,s_ecm[1].ecm66,s_ecm[1].ecm52,s_ecm[1].ecm67,         #FUN-A80150 add  ecm66,ecm67
                 s_ecm[1].ecm53,s_ecm[1].ecm54,s_ecm[1].ecm55,s_ecm[1].ecm56

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
    CALL i700_b_fill(g_wc2)
END FUNCTION

FUNCTION i700_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000   #No.FUN-680073 VARCHAR(200)

    LET g_sql =
 #      "SELECT ecm03,ecm011,ecm012,'',ecm04,ecm45,ecm61,ecm06,eca02,'',", #FUN-870092 add ecm61    #TQC-8C0016 add ''  #No.FUN-A60011   #FUN-B10056 mark
 #      "SELECT ecm03,ecm011,ecm012,ecm014,ecm015,ecm04,ecm45,ecm61,ecm06,eca02,'',",   #FUN-B10056 add ecm014,ecm015   #FUN-B20078
        "SELECT ecm03,ecm011,ecm012,ecm014,ecm015,'',ecm04,ecm45,ecm61,ecm06,eca02,'',",  #FUN-B20078
       #"       ecm14,ecm13,ecm16,ecm15,'','',",            #No:FUN-810014 #FUN-9A0048 mark
        "       '',ecm14,ecm13,'',ecm16,ecm15,'','',",      #No:FUN-810014 #FUN-9A0048 add
        "       '','',ecm49,ecm50,ecm51,ecm05,'',",                #No.FUN-810014     #TQC-8C0016 add '' #No.TQC-BC0166 add '' #TQC-C20083 add ''
        "       ecm66,",                                     #FUN-A80150 add
        "       ecm52,ecm67,ecm321,ecm53,ecm54,ecm55,ecm56,'',ecm58,",         #No.FUN-A60011   #FUN-A80150 add ecm67  #FUN-B50046 add ''
        "       ecm62,ecm63,ecm65,ecm12,ecm34,ecm64,ta_ecm01,ta_ecm02,ta_ecm03      ",     #str—add by huanglf 160713            #No.FUN-A60011
        " FROM ecm_file LEFT OUTER JOIN eca_file ON ecm_file.ecm06 = eca_file.eca01",
        " WHERE ecm01 ='",g_sfb.sfb01,"' ",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY ecm012,ecm03"          #No.FUN-A60011
    PREPARE i700_pb FROM g_sql
    DECLARE ecm_curs CURSOR FOR i700_pb

    CALL g_ecm.clear()

    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH ecm_curs INTO g_ecm[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #No.FUN-A60011  --Begin
       #TQC-AC0374--begin--modify-------
       #SELECT ecu014 INTO g_ecm[g_cnt].ecu014 FROM ecu_file
       # WHERE ecu01 = g_sfb.sfb05
       #   AND ecu02 = g_sfb.sfb06
       #   AND ecu012= g_ecm[g_cnt].ecm012
    #   CALL s_schdat_ecu014(g_sfb.sfb01,g_ecm[g_cnt].ecm012) RETURNING g_ecm[g_cnt].ecu014 #TQC-AC0374  #FUN-B10056 mark
       #TQC-AC0374--end--modify-------
        #No.FUN-A60011  --End
        SELECT vmn08,vmn081,vmn18                                        #FUN-9A0047 add
              ,vmn20,vmn21                                               #FUN-9A0048 add
          INTO g_ecm[g_cnt].vmn08,g_ecm[g_cnt].vmn081,g_ecm[g_cnt].vmn18 #FUN-9A0047 add
              ,g_ecm[g_cnt].vmn20,g_ecm[g_cnt].vmn21                     #FUN-9A0048 add
          FROM vmn_file
         WHERE vmn01 = g_sfb.sfb05
           AND vmn02 = g_sfb.sfb01
           AND vmn03 = g_ecm[g_cnt].ecm03
           AND vmn04 = g_ecm[g_cnt].ecm04
           CALL i700_ecm014(g_ecm[g_cnt].ecm015) RETURNING g_ecm[g_cnt].ecr02  #FUN-B20078 

        LET g_cnt = g_cnt + 1


      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF

    END FOREACH
    CALL g_ecm.deleteElement(g_cnt)
    LET g_rec_b= g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION i700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_sma.sma901 != 'Y' THEN
             CALL cl_set_act_visible("aps_related_data_aps_ecm",FALSE)
             CALL cl_set_act_visible("aps_lock_route_time",FALSE)
             CALL cl_set_act_visible("aps_routes_subc_data",FALSE)
             CALL cl_set_act_visible("aps_lock_used_machine",FALSE)
             CALL cl_set_act_visible("aps_route_tools",FALSE)
             CALL cl_set_act_visible("aps_processing",FALSE) #FUN-870092 add
             CALL cl_set_act_visible("aps_resourceno_change",FALSE)  #FUN-960102 ADD
        END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

    #FUN-B10056 ---Begin-------
      ON ACTION chkbom
         LET g_action_choice = "chkbom"
         EXIT DISPLAY
    #FUN-B10056 ----End-------
         
    #FUN-A10044  ---begin---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
    #FUN-A10044  ---end ---
      ON ACTION first
         CALL i700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION previous
         CALL i700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION jump
         CALL i700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION next
         CALL i700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION last
         CALL i700_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CASE g_sfb.sfb87
              WHEN 'Y'   LET g_confirm = 'Y'
                         LET g_void = ''
              WHEN 'N'   LET g_confirm = 'N'
                         LET g_void = ''
              WHEN 'X'   LET g_confirm = ''
                         LET g_void = 'Y'
           OTHERWISE     LET g_confirm = ''
                         LET g_void = ''
         END CASE
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 工單製程數量狀態查詢
      ON ACTION wo_routing_qt_status
         LET g_action_choice="wo_routing_qt_status"
         EXIT DISPLAY
#@    ON ACTION 工單單元明細查詢
      ON ACTION wo_cell_details
         LET g_action_choice="wo_cell_details"
         EXIT DISPLAY
      #apsi312
      ON ACTION aps_related_data_aps_ecm
         LET g_action_choice="aps_related_data_aps_ecm"
         EXIT DISPLAY
      #apsi311
      ON ACTION aps_lock_route_time
         LET g_action_choice="aps_lock_route_time"
         EXIT DISPLAY
      #apsi315
      ON ACTION aps_lock_used_machine
         LET g_action_choice="aps_lock_used_machine"
         EXIT DISPLAY

     #FUN-960054 MARK --STR------------------------
     # #apsi324
     # ON ACTION aps_routes_subc_data
     #    LET g_action_choice="aps_routes_subc_data"
     #    EXIT DISPLAY
     #FUN-960054 MARK --END------------------------

     #FUN-960102 MARK --STR------------------------
     # ON ACTION aps_processing
     #    LET g_action_choice="aps_processing"
     #    EXIT DISPLAY
     #FUN-960102 MAKR --END------------------------

     #FUN-960102 ADD --STR-------------------------
     ON ACTION aps_resourceno_change
        LET g_action_choice="aps_resourceno_change"
        EXIT DISPLAY
     #FUN-960102 ADD --END-------------------------

     #apsi331  FUN-890096
     ON ACTION aps_route_tools
        LET g_action_choice="aps_route_tools"
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


      ON ACTION related_time
         LET g_action_choice="related_time"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      #No.FUN-A60011  --Begin
      ON ACTION subcontract
         LET g_action_choice="subcontract"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      #No.FUN-A60011  --End

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document                #No.FUN-6A0039  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
  
#FUN-B20078 -----------Begin-------------   
      &include "qry_string.4gl"   
#FUN-B20078 -----------End---------------
   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i700_sfb82()
DEFINE
    l_gemacti       LIKE gem_file.gemacti,
    ttpmc03         LIKE pmc_file.pmc03,
    ttima55         LIKE ima_file.ima55

    LET g_errno = ' '
    SELECT gem03,gemacti INTO ttpmc03,l_gemacti FROM  gem_file
    WHERE gem01 = g_sfb.sfb82

    CASE WHEN SQLCA.SQLCODE = 100
              SELECT pmc03 INTO ttpmc03 FROM  pmc_file
               WHERE pmc01 = g_sfb.sfb82
              IF STATUS THEN
                 LET g_errno = 'x'
              END IF
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF cl_null(g_errno)  THEN
       DISPLAY BY NAME g_sfb.sfb82
       DISPLAY ttpmc03 TO FORMONLY.pmc03
    END IF

END FUNCTION

#FUN-B10056-----------------------Begin--add----------------------
FUNCTION i700_chkbom()
   CALL i700sub_chkbom(g_sfb.sfb01,'0') 
   IF g_success='N' THEN
      RETURN  
   END IF
END FUNCTION

FUNCTION i700_chk_ecm011()
   CALL i700sub_ecm011(g_sfb.sfb01)
   CALL i700_b_fill(' 1=1') 
END FUNCTION
#FUN-B10056-----------------------End----add----------------------
#No.FUN-A60011  --Begin
#FUN-B10056----------Begin--mark----------------------
#FUNCTION i700_ecm012(p_cmd)
#DEFINE p_cmd           LIKE type_file.chr1
#DEFINE l_ecuacti       LIKE ecu_file.ecuacti
#DEFINE l_ecu10         LIKE ecu_file.ecu10
#DEFINE l_ecu014        LIKE ecu_file.ecu014 
#DEFINE l_ecu015        LIKE ecu_file.ecu015 
#DEFINE l_ecm011        LIKE ecm_file.ecm011  #FUN-B10056
#DEFINE l_ecm014        LIKE ecm_file.ecm014  #FUN-B10056
#DEFINE l_ecm015        LIKE ecm_file.ecm015  #FUN-B10056
#DEFINE l_ecmacti       LIKE ecm_file.ecmacti #FUN-B10056
#DEFINE l_flag          LIKE type_file.num5   #TQC-AC0374
#DEFINE l_sfb05         LIKE sfb_file.sfb05   #TQC-AC0374

#   LET g_errno = ' '
#   CALL s_schdat_sel_ima571(g_sfb.sfb01) RETURNING l_flag,l_sfb05  #TQC-AC0374

#  SELECT ecu014,ecu10,ecuacti INTO l_ecu014,l_ecu10,l_ecuacti
#    FROM ecu_file
#    WHERE ecu01 = l_sfb05   #TQC-AC0374
#      AND ecu02 = g_sfb.sfb06
#      AND ecu012= g_ecm[l_ac].ecm012

#   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-214'
#                                  LET l_ecu014 = NULL
#                                  LET l_ecu015 = NULL
#        WHEN l_ecuacti='N'        LET g_errno = '9028'
#        WHEN l_ecu10 <> 'Y'       LET g_errno = '9029'
#        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
#   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      #找上工艺段号
#      SELECT ecu012 INTO l_ecu015 FROM ecu_file
#       WHERE ecu01 = l_sfb05  #TQC-AC0374
#         AND ecu02 = g_sfb.sfb06
#         AND ecu015= g_ecm[l_ac].ecm012
#      IF SQLCA.sqlcode THEN
#         LET l_ecu015 = ' '
#      END IF
#      IF p_cmd <> 'd' THEN
#         LET g_ecm[l_ac].ecm011 = l_ecu015
#      END IF
#      LET g_ecm[l_ac].ecu014 = l_ecu014
#   END IF
#FUN-B10056---------End--mark--------------------
#No.FUN-A60011  --End

FUNCTION i700_ecm06(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    l_ecaacti       LIKE eca_file.ecaacti

    LET g_errno = ' '
    SELECT eca02,ecaacti INTO g_ecm[l_ac].eca02,l_ecaacti FROM eca_file
     WHERE eca01 = g_ecm[l_ac].ecm06

         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-676'
                   LET g_ecm[l_ac].eca02 = ' ' LET l_ecaacti = ' '
              WHEN l_ecaacti='N' LET g_errno = '9028'
              OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         DISPLAY BY NAME g_ecm[l_ac].eca02

END FUNCTION

FUNCTION i700_ecm04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)

    SELECT ecd01,ecd02 INTO g_ecm[l_ac].ecm04,g_ecm[l_ac].ecm45 FROM ecd_file
     WHERE ecd01 = g_ecm[l_ac].ecm04

    CASE WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'aec-015'
         LET g_ecm[l_ac].ecm04 = ' '
         LET g_ecm[l_ac].ecm45 = ' '
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY BY NAME g_ecm[l_ac].ecm04
    DISPLAY BY NAME g_ecm[l_ac].ecm45

END FUNCTION

FUNCTION i700_sfb05()         #i700中品名規格
DEFINE
    l_imaacti       LIKE ima_file.imaacti,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021

    LET g_errno = ' '
    SELECT ima02,ima55,ima021,imaacti
      INTO l_ima02,g_ima55,l_ima021,l_imaacti FROM  ima_file
     WHERE ima01 = g_sfb.sfb05

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-003'
                            LET g_sfb.sfb05 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF cl_null(g_errno)  THEN
       DISPLAY BY NAME g_sfb.sfb05
       DISPLAY l_ima02 TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY g_ima55 TO FORMONLY.ima55
    END IF

END FUNCTION

FUNCTION i700_sgg(p_key)
DEFINE
    p_key          LIKE sgg_file.sgg01,
    l_sgg01        LIKE sgg_file.sgg01,
    l_sggacti      LIKE sgg_file.sggacti

    LET g_errno = ' '
    SELECT sgg01,sggacti INTO l_sgg01,l_sggacti FROM sgg_file
     WHERE sgg01 = p_key

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-003'
                                   LET l_sggacti = NULL
         WHEN l_sggacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

END FUNCTION

FUNCTION i700_ecm03()

   #No.FUN-A60011  --Begin
   SELECT ecm58
     INTO g_ecm[l_ac].ecm58 FROM ecm_file
    WHERE ecm01=g_sfb.sfb01 AND ecm03=g_ecm[l_ac].ecm03 AND ecm012=g_ecm[l_ac].ecm012  #No.FUN-A60011
   #IF cl_null(g_ecm[l_ac].ecm57) THEN LET g_ecm[l_ac].ecm57=g_ima55 END IF
   IF cl_null(g_ecm[l_ac].ecm58) THEN LET g_ecm[l_ac].ecm58=g_ima55 END IF
   #No.FUN-A60011  --End
END FUNCTION

#No.FUN-A60011  --Begin
#FUNCTION i700_ecm59()
#
#   IF g_ecm[l_ac].ecm57 = g_ecm[l_ac].ecm58 THEN
#       LET g_ecm[l_ac].ecm59=1          #MOD-490091
#   ELSE
#      CALL s_umfchk(g_sfb.sfb05,g_ecm[l_ac].ecm58,g_ecm[l_ac].ecm57)
#           RETURNING g_sw,g_ecm[l_ac].ecm59
#      IF g_sw = '1' THEN
#         CALL cl_err(g_ecm[l_ac].ecm58,'mfg1206',1)
#          LET g_ecm[l_ac].ecm59 = 1   #MOD-490091
#          LET g_sw = '0'   #MOD-490091  還原g_sw之判斷值
#      END IF
#   END IF
#
#   DISPLAY g_ecm[l_ac].ecm59 TO ecm59
#
#END FUNCTION
#No.FUN-A60011  --End

#No.+230 010629 add by linda check 最後一站轉出單位必須同sfb05之生產單位
FUNCTION i700_chk_unit()
  DEFINE l_ecm012 LIKE ecm_file.ecm012   #No.FUN-A60011
  DEFINE l_cnt    LIKE type_file.num5    #No.FUN-A60011
  DEFINE l_ecm03  LIKE ecm_file.ecm03,
         l_ecm58  LIKE ecm_file.ecm58,
         l_ima55  LIKE ima_file.ima55

   #No.FUN-A60011  --Begin
   #LET l_ecm03=''
   #LET l_ecm58=''
   #DECLARE ecm_chk CURSOR FOR
   #   SELECT ecm03,ecm58
   #     FROM ecm_file
   #    WHERE ecm01 = g_sfb.sfb01
   #     ORDER BY ecm03 DESC

   #FOREACH ecm_chk INTO l_ecm03,l_ecm58
   #  IF SQLCA.SQLCODE THEN
   #     CALL cl_err('ecm chk:',SQLCA.SQLCODE,0)
   #     EXIT FOREACH
   #  END IF
   #  EXIT FOREACH
   #END FOREACH

   ##讀取生產料號之生產單位
   #SELECT ima55 INTO l_ima55 FROM sfb_file,ima_file
   # WHERE sfb05=ima01
   #   AND sfb01=g_sfb.sfb01
   #IF l_ecm58 <> l_ima55 THEN
   #   CALL cl_err(l_ecm03,'mfg-054',0)
   #   RETURN 1
   #END IF

   #RETURN 0

 #-->單身無筆數不檢查了
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM ecm_file WHERE ecm01 = g_sfb.sfb01
    IF l_cnt = 0 THEN RETURN 0 END IF

    #讀取生產料號之生產單位
    SELECT ima55 INTO l_ima55 FROM sfb_file,ima_file
     WHERE sfb05=ima01
       AND sfb01=g_sfb.sfb01

    CALL s_showmsg_init()
    DECLARE i700_ecm58_curs CURSOR FOR
     SELECT ecm012,MAX(ecm03) FROM ecm_file
      WHERE ecm01 = g_sfb.sfb01
      GROUP BY ecm012
    FOREACH i700_ecm58_curs INTO l_ecm012,l_ecm03
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('ecm01',g_sfb.sfb01,'foreach i700_ecm58_curs',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ecm58 INTO l_ecm58 FROM ecm_file
        WHERE ecm01 = g_sfb.sfb01
          AND ecm03 = l_ecm03
          AND ecm012= l_ecm012
       IF SQLCA.sqlcode THEN
          LET g_showmsg = g_sfb.sfb01,'/',l_ecm03,'/',l_ecm012
          CALL s_errmsg('ecm01,ecm03,ecm012',g_showmsg,'SELECT ecm58',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       IF l_ecm58 <> l_ima55 THEN
          LET g_showmsg = l_ecm58,'/',l_ima55
          CALL s_errmsg('ecm58,ima55',g_showmsg,'ecm58<>ima55','mfg-054',1)
          CONTINUE FOREACH
       END IF

    END FOREACH

    CALL s_showmsg()
    RETURN 0
    #No.FUN-A60011  --End

END FUNCTION

#FUN-9A0047---add----str----
FUNCTION i700_chk_aps()
  DEFINE l_aps_err LIKE type_file.chr1
  DEFINE l_vmn08   LIKE vmn_file.vmn08
  DEFINE l_ecm     RECORD LIKE ecm_file.*

   CALL s_showmsg_init()
   DECLARE i700_chk_aps CURSOR FOR
      SELECT *
        FROM ecm_file
       WHERE ecm01 = g_sfb.sfb01

   LET l_aps_err = 'N'
   FOREACH i700_chk_aps INTO l_ecm.*
     IF SQLCA.SQLCODE THEN
        CALL cl_err('aps chk:',SQLCA.SQLCODE,0)
        EXIT FOREACH
     END IF
     IF g_sma.sma917 = 1 THEN #機器編號
         SELECT vmn08 INTO l_vmn08
           FROM vmn_file
          WHERE vmn01  = l_ecm.ecm03_par #料號*/
            AND vmn02  = l_ecm.ecm01     #途程編號*/
            AND vmn03  = l_ecm.ecm03     #加工序號*/
            AND vmn04  = l_ecm.ecm04     #作業編號*/
         IF l_ecm.ecm52 = 'N' THEN
             IF cl_null(l_ecm.ecm05) AND cl_null(l_vmn08) THEN
                 #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
                 CALL cl_getmsg('aps-033',g_lang) RETURNING g_showmsg
                 LET g_showmsg = l_ecm.ecm03,'==>',g_showmsg
                 CALL s_errmsg('ecm03',g_showmsg,l_ecm.ecm01,STATUS,1)
                 LET l_aps_err = 'Y'
             END IF
         END IF
     END IF
   END FOREACH
   IF l_aps_err = 'Y' THEN
       CALL s_showmsg()
       RETURN 1
   ELSE
       RETURN 0
   END IF

END FUNCTION
#FUN-9A0047---add----end----

FUNCTION i700_more(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
        l_code     LIKE type_file.chr1           #No.FUN-680073 VARCHAR(01)

   OPEN WINDOW i700_w4 AT 3,3 WITH FORM "aec/42f/aeci7001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_locale("aeci7001")

   IF l_ac = 0 THEN RETURN END IF

   SELECT ecm07,ecm08,ecm09,ecm10,ecm20,ecm21,ecm22,ecm23,ecm24,
          ecm17,ecm18,ecm19,ecm37,ecm38,ecm39
     INTO g_ecm07,g_ecm08,g_ecm09,g_ecm10,g_ecm20,g_ecm21,g_ecm22,g_ecm23,g_ecm24,
          g_ecm17,g_ecm18,g_ecm19,g_ecm37,g_ecm38,g_ecm39
     FROM ecm_file
    WHERE ecm01=g_sfb.sfb01 AND ecm03=g_ecm[l_ac].ecm03
      AND ecm012=g_ecm[l_ac].ecm012   #No.FUN-A60011

   DISPLAY g_ecm07,g_ecm08,g_ecm09,g_ecm10,g_ecm20,g_ecm21,g_ecm22,g_ecm23,g_ecm24,
           g_ecm17,g_ecm18,g_ecm19,g_ecm37,g_ecm38,g_ecm39
        TO FORMONLY.g_ecm07,FORMONLY.g_ecm08,FORMONLY.g_ecm09,FORMONLY.g_ecm10,FORMONLY.g_ecm20,
           FORMONLY.g_ecm21,FORMONLY.g_ecm22,FORMONLY.g_ecm23,FORMONLY.g_ecm24,
           FORMONLY.g_ecm17,FORMONLY.g_ecm18,FORMONLY.g_ecm19,FORMONLY.g_ecm37,
           FORMONLY.g_ecm38,FORMONLY.g_ecm39

   IF p_cmd != 'd' THEN
      INPUT BY NAME
           g_ecm07,g_ecm08,g_ecm09,g_ecm10,g_ecm20,g_ecm21,g_ecm22,g_ecm23,
           g_ecm24,g_ecm17,g_ecm18,g_ecm19,g_ecm37,g_ecm38,g_ecm39
           WITHOUT DEFAULTS

           AFTER INPUT
              IF INT_FLAG THEN                         # 若按了DEL鍵
                 EXIT INPUT
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

      IF INT_FLAG THEN  LET INT_FLAG = 0 END IF
   ELSE
      CALL cl_getmsg('lib-038',g_lang) RETURNING g_msg
      LET INT_FLAG = 0  ######add for prompt bug
      PROMPT g_msg CLIPPED,': ' FOR l_code
          ON IDLE g_idle_seconds
             CALL cl_on_idle()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      END PROMPT
   END IF
#MOD-C30283--add--start--
   UPDATE ecm_file set ecm07 = g_ecm07,
                       ecm08 = g_ecm08,
                       ecm09 = g_ecm09,
                       ecm10 = g_ecm10,
                       ecm20 = g_ecm20,
                       ecm21 = g_ecm21,
                       ecm22 = g_ecm22,
                       ecm23 = g_ecm23,
                       ecm24 = g_ecm24,
                       ecm17 = g_ecm17,
                       ecm18 = g_ecm18,
                       ecm19 = g_ecm19,
                       ecm37 = g_ecm37,
                       ecm38 = g_ecm38,
                       ecm39 = g_ecm39
    WHERE ecm01=g_sfb.sfb01 AND ecm03=g_ecm[l_ac].ecm03
      AND ecm012=g_ecm[l_ac].ecm012
#MOD-C30283--add--end--


END FUNCTION


FUNCTION i700_aps_ecm(p_cmd) #TQC-8C0016 加入參數p_cmd
  DEFINE  l_vmn       RECORD LIKE vmn_file.*
  DEFINE  p_cmd       LIKE type_file.chr1      #No.TQC-8C0016 add

        IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
        IF cl_null(g_ecm[l_ac].ecm03) OR
           cl_null(g_ecm[l_ac].ecm06) THEN
            CALL cl_err('','arm-034',1)
            RETURN
        END IF

        LET l_vmn.vmn01  = g_sfb.sfb05
        LET l_vmn.vmn02  = g_sfb.sfb01
        LET l_vmn.vmn03  = g_ecm[l_ac].ecm03
        LET l_vmn.vmn04  = g_ecm[l_ac].ecm04
        LET l_vmn.vmn012 = g_ecm[l_ac].ecm012 #FUN-B50101 add

        SELECT * FROM vmn_file
         WHERE vmn01 = l_vmn.vmn01
           AND vmn02 = l_vmn.vmn02
           AND vmn03 = l_vmn.vmn03  #FUN-850115
           AND vmn04 = l_vmn.vmn04
           AND vmn012 = l_vmn.vmn012 #FUN-B50101 add
        IF SQLCA.SQLCODE=100 THEN
           LET l_vmn.vmn08  = g_ecm[l_ac].vmn08
           LET l_vmn.vmn081 = g_ecm[l_ac].vmn081
           LET l_vmn.vmn18  = g_ecm[l_ac].vmn18 #FUN-9A0047 add
           LET l_vmn.vmn20  = g_ecm[l_ac].vmn20 #FUN-9A0048 add
           LET l_vmn.vmn21  = g_ecm[l_ac].vmn21 #FUN-9A0048 add
           LET l_vmn.vmn09 = 0
           LET l_vmn.vmn12 = 0
           LET l_vmn.vmn13 = 1
           LET l_vmn.vmn15 = 0
           LET l_vmn.vmn16 = 9999
           LET l_vmn.vmn17 = 1
           LET l_vmn.vmn19 = 0 #FUN-8C0028
           #FUN-B50101 ---add---str--
           LET l_vmn.vmnlegal = g_legal
           LET l_vmn.vmnplant = g_plant
           #FUN-B50101 ---add---end--
           INSERT INTO vmn_file VALUES(l_vmn.*)
              IF STATUS THEN
                 CALL cl_err3("ins","vmn_file",l_vmn.vmn01,l_vmn.vmn02,SQLCA.sqlcode,
                              "","",1)
                 ROLLBACK WORK
                 RETURN
              ELSE
                 COMMIT WORK
              END IF
        END IF
        LET g_cmd = "apsi312 '",l_vmn.vmn01,"' '",l_vmn.vmn02,"' '",l_vmn.vmn03,"' '",l_vmn.vmn04,"' '",g_ecm[l_ac].ecm52,"' '",l_vmn.vmn012,"'" #FUN-B50101 add vmn012
        IF p_cmd = 'Y' THEN #TQC-8C0016 add if 判斷
            CALL cl_cmdrun(g_cmd)
        END IF
END FUNCTION

#APS鎖定製程時間維護  apsi311
FUNCTION i700_aps_lrt()
DEFINE  l_vnd RECORD LIKE vnd_file.*
DEFINE  l_vme02      LIKE vme_file.vme02  #FUN-960054 ADD
DEFINE  l_vmp02      LIKE vmp_file.vmp02  #FUN-960054 ADD

  IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
  IF cl_null(g_ecm[l_ac].ecm03) OR
     cl_null(g_ecm[l_ac].ecm06) THEN
     CALL cl_err('','arm-034',1)
     RETURN
  END IF

  #FUN-960102 ADD --STR---------------------------------
   IF g_sma.sma901 = 'Y' AND g_sma.sma917 = 1  AND
      g_sfb.sfb02='1' AND
     #(cl_null(g_ecm[l_ac].ecm05) AND cl_null(g_ecm[l_ac].vmn08)) THEN                             #FUN-9A0047 mark
      (cl_null(g_ecm[l_ac].ecm05) AND cl_null(g_ecm[l_ac].vmn08) AND g_ecm[l_ac].ecm52 = 'N') THEN #FUN-9A0047 add
      CALL cl_err('','aps-033',1)
      RETURN
   END IF
   IF g_sma.sma901 = 'Y' AND g_sma.sma917 = 0  AND
      g_sfb.sfb02='1' AND
      (cl_null(g_ecm[l_ac].ecm06) AND cl_null(g_ecm[l_ac].vmn081)) THEN
      CALL cl_err('','aps-775',1)
      RETURN
   END IF
  #FUN-960102 ADD --END----------------------------------

  SELECT vzz60 into g_vzz60  from vzz_file

  LET l_vnd.vnd01  = g_sfb.sfb01
  LET l_vnd.vnd02  = g_sfb.sfb01
  LET l_vnd.vnd03  = g_ecm[l_ac].ecm03
  LET l_vnd.vnd04  = g_ecm[l_ac].ecm04
  LET l_vnd.vnd012 = g_ecm[l_ac].ecm012 #FUN-B50101 add
  #FUN-960054 MARK --STR------------------------------
  #IF  g_vzz60 = 0 THEN
  #    IF cl_null(g_ecm[l_ac].ecm06) THEN
  #       CALL cl_err('','aps-405',1)
  #       RETURN
  #    END IF
  #    LET l_vnd.vnd05 = g_ecm[l_ac].ecm06
  #ELSE
  #    IF cl_null(g_ecm[l_ac].ecm05) THEN
  #       CALL cl_err('','aps-034',1) #TQC-8C0066 mod
  #       RETURN
  #    END IF
  #    LET l_vnd.vnd05 = g_ecm[l_ac].ecm05
  #END IF
  #FUN-960054 MARK --END--------------------------------

  #FUN-960054 ADD --STR---------------------------------
   IF g_sma.sma901 = 'Y' AND g_sma.sma917 = 0  THEN
      IF NOT cl_null(g_ecm[l_ac].ecm06) THEN
         LET l_vnd.vnd05 = g_ecm[l_ac].ecm06
      ELSE
         SELECT vmp02 INTO l_vmp02
           FROM vmp_file
          WHERE vmp01 = g_ecm[l_ac].vmn081
         LET l_vnd.vnd05 = l_vmp02
      END IF
   ELSE
      IF g_sma.sma901 = 'Y' AND g_sma.sma917 = 1  THEN
         IF NOT cl_null(g_ecm[l_ac].ecm05) THEN
            LET l_vnd.vnd05 = g_ecm[l_ac].ecm05
         ELSE
            SELECT vme02 INTO l_vme02
              FROM vme_file
             WHERE vme01 = g_ecm[l_ac].vmn08
            LET l_vnd.vnd05 = l_vme02
         END IF
      END IF
   END IF
   ##外包時 ecm52='Y'時, vnd05 塞一個空白
   IF g_ecm[l_ac].ecm52 = 'Y' THEN
      LET l_vnd.vnd05 =' '
   END IF
  #FUN-960054 ADD --END---------------------------------

  SELECT  * FROM vnd_file
  WHERE vnd01 = l_vnd.vnd01
    AND vnd02 = l_vnd.vnd02
    AND vnd03 = l_vnd.vnd03
    AND vnd04 = l_vnd.vnd04
    AND vnd012 = l_vnd.vnd012 #FUN-B50101 add
   #and vnd05 = l_vnd.vnd05 #FUN-960054 MARK

    #FUN-A70036 mark---str---
    #IF SQLCA.SQLCODE=100 THEN
    #   LET l_vnd.vnd06 = 0
    #   LET l_vnd.vnd07 = NULL
    #   LET l_vnd.vnd08 = NULL
    #   LET l_vnd.vnd09 = 0
    #   LET l_vnd.vnd10 = 0
    #   LET l_vnd.vnd11 = 0  #FUN-960054 ADD
    #   INSERT INTO vnd_file VALUES(l_vnd.*)
    #      IF STATUS THEN
    #         CALL cl_err3("ins","vnd_file",l_vnd.vnd01,l_vnd.vnd02,SQLCA.sqlcode,
    #                      "","",1)
    #         ROLLBACK WORK
    #         RETURN
    #      ELSE
    #         COMMIT WORK
    #      END IF
    #END IF
    #FUN-A70036 mark---end---

    #FUN-960054 MOD --STR------------------------------------------------
    #LET g_cmd = "apsi311 '",l_vnd.vnd01,"' '",l_vnd.vnd02,"' '",l_vnd.vnd03,"' '",l_vnd.vnd04,"' '",l_vnd.vnd05,"'"
     LET g_cmd = "apsi311 '",l_vnd.vnd01,"' '",l_vnd.vnd02,"' '",l_vnd.vnd03,"' '",l_vnd.vnd04,"' '",l_vnd.vnd05,"' '",g_prog,"' '",l_vnd.vnd012,"'" #FUN-B50101 add vnd012
    #FUN-960054 MOD --END------------------------------------------------
     CALL cl_cmdrun(g_cmd)

END FUNCTION

#APS鎖定使用設備維護 apsi315
FUNCTION i700_aps_lum(p_open)      #TQC-8A0013 多傳p_open
DEFINE  l_vne RECORD LIKE vne_file.*
DEFINE  p_open LIKE type_file.chr1 #TQC-8A0013 add

  IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
  IF cl_null(g_ecm[l_ac].ecm03) OR
     cl_null(g_ecm[l_ac].ecm06) THEN
     CALL cl_err('','arm-034',1)
     RETURN
  END IF

  SELECT vzz60 into g_vzz60  from vzz_file

  LET l_vne.vne01  = g_sfb.sfb01
  LET l_vne.vne02  = g_sfb.sfb01
  LET l_vne.vne03  = g_ecm[l_ac].ecm03
  LET l_vne.vne04  = g_ecm[l_ac].ecm04
  LET l_vne.vne012 = g_ecm[l_ac].ecm012 #FUN-B50101 add
  IF  g_sma.sma917 = 0 THEN #FUN-870092 mod
      IF cl_null(g_ecm[l_ac].ecm06) THEN
         CALL cl_err('','aps-405',1)
         RETURN
      END IF
      LET l_vne.vne05 = g_ecm[l_ac].ecm06
      #FUN-960102 ADD --STR----------------
      IF cl_null(g_ecm[l_ac].ecm06) THEN
         LET l_vne.vne05 = ' '
      END IF
      #FUN-960102 ADD --END----------------
  ELSE
      #FUN-960102 MARK --STR-------------------------
      #IF cl_null(g_ecm[l_ac].ecm05) THEN
      #   CALL cl_err('','aps-034',1) #TQC-8C0066 mod
      #   RETURN
      #END IF
      #FUN-960102 MARK --END-------------------------
      LET l_vne.vne05 = g_ecm[l_ac].ecm05
      #FUN-960102 ADD --STR---------------
      IF cl_null(g_ecm[l_ac].ecm05) THEN
         LET l_vne.vne05 = ' '
      END IF
      #FUN-960102 ADD --END---------------
  END IF

 #FUN-960102 ADD ---STR--------------------
 DELETE FROM vne_file
  WHERE vne01 = l_vne.vne01
    AND vne02 = l_vne.vne02
    AND vne03 = l_vne.vne03
    AND vne04 = l_vne.vne04
    AND vne05 = ' '
    AND vne012 = l_vne.vne012 #FUN-B50101 add
 #FUN-960102 ADD ---END-------------------

 SELECT  * FROM vne_file
 WHERE vne01 = l_vne.vne01
   and vne02 = l_vne.vne02
   and vne03 = l_vne.vne03
   and vne04 = l_vne.vne04
   and vne05 = l_vne.vne05
   AND vne012 = l_vne.vne012 #FUN-B50101 add
  #and vne05 = l_vne.vne05   #FUN-960102 MARK

   #FUN-A70036--mark---str---
   #IF SQLCA.SQLCODE=100 THEN
   #   LET l_vne.vne06 = g_sfb.sfb08 #未完成量 #FUN-870092 mod
   #   LET l_vne.vne07 = 0
   #  #FUN-960102 MOD --STR--------------------------------------------
   #  #INSERT INTO vne_file VALUES(l_vne.*)
   #   INSERT INTO vne_file(vne01,vne02,vne03,vne04,vne05,vne06,vne07,vne311,vne312,vne313,vne314,vne315,vne316,vne50,vne51)             #FUN-980080 add vne50,vne51
   #     VALUES(l_vne.vne01,l_vne.vne02,l_vne.vne03,l_vne.vne04,l_vne.vne05,l_vne.vne06,l_vne.vne07,0,0,0,0,0,0,l_vne.vne50,l_vne.vne51) #FUN-980080 add vne50,vne51
   #  #FUN-960102 MOD --END--------------------------------------------
   #      IF STATUS THEN
   #         CALL cl_err3("ins","vne_file",l_vne.vne01,l_vne.vne02,SQLCA.sqlcode,
   #                      "","",1)
   #         ROLLBACK WORK
   #         RETURN
   #      ELSE
   #         COMMIT WORK
   #      END IF
   #END IF
   #FUN-A70036--mark---end---

    IF p_open = 'Y' THEN #TQC-8A0013 add if 判斷
        LET g_cmd = "apsi315 '",l_vne.vne01,"' '",l_vne.vne02,"' '",l_vne.vne03,"' '",l_vne.vne04,"' '",l_vne.vne012,"'"  #FUN-870092 #FUN-B50101 add vne012
        CALL cl_cmdrun(g_cmd)
    END IF

END FUNCTION

FUNCTION i700_aps_vne()
DEFINE  l_vne RECORD LIKE vne_file.*

  IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
  IF cl_null(g_ecm[l_ac].ecm03) OR
     cl_null(g_ecm[l_ac].ecm06) THEN
     CALL cl_err('','arm-034',1)
     RETURN
  END IF

  LET l_vne.vne01  = g_sfb.sfb01
  LET l_vne.vne02  = g_sfb.sfb01
  LET l_vne.vne03  = g_ecm[l_ac].ecm03
  LET l_vne.vne04  = g_ecm[l_ac].ecm04
  IF  g_sma.sma917 = 0 THEN
      IF cl_null(g_ecm[l_ac].ecm06) THEN
         CALL cl_err('','aps-405',1)
         RETURN
      END IF
      LET l_vne.vne05 = g_ecm[l_ac].ecm06
  ELSE
      IF cl_null(g_ecm[l_ac].ecm05) THEN
         CALL cl_err('','aps-404444',1)
         RETURN
      END IF
      LET l_vne.vne05 = g_ecm[l_ac].ecm05
  END IF

 SELECT  * FROM vne_file
 WHERE vne01 = l_vne.vne01
   and vne02 = l_vne.vne02
   and vne03 = l_vne.vne03
   and vne04 = l_vne.vne04
   and vne05 = l_vne.vne05

    IF SQLCA.SQLCODE=100 THEN
       LET l_vne.vne06 = g_sfb.sfb08 #未完成量 #FUN-870092 mod
       LET l_vne.vne07 = 0
       INSERT INTO vne_file VALUES(l_vne.*)
          IF STATUS THEN
             CALL cl_err3("ins","vne_file",l_vne.vne01,l_vne.vne02,SQLCA.sqlcode,
                          "","",1)
             ROLLBACK WORK
             RETURN
          ELSE
             COMMIT WORK
          END IF
    END IF
END FUNCTION

#APS製程外包   apsi324
FUNCTION i700_aps_rsd()
DEFINE  l_vng RECORD LIKE vng_file.*

  IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
  IF cl_null(g_ecm[l_ac].ecm03) OR
     cl_null(g_ecm[l_ac].ecm06) THEN
             CALL cl_err('','arm-034',1)
             RETURN
  END IF

  LET l_vng.vng01  = g_sfb.sfb01
  LET l_vng.vng02  = g_sfb.sfb01  #FUN-870012
  LET l_vng.vng03  = g_ecm[l_ac].ecm03
  LET l_vng.vng04  = g_ecm[l_ac].ecm04

  SELECT * FROM vng_file
    WHERE  vng01 = l_vng.vng01
      and  vng02 = l_vng.vng02
      and  vng03 = l_vng.vng03
      and  vng04 = l_vng.vng04

     IF SQLCA.SQLCODE=100 THEN
        LET l_vng.vng06 = 1
        LET l_vng.vng07 = NULL
        LET l_vng.vng08 = NULL
        LET l_vng.vng10 = 0
        LET l_vng.vng11 = 1
        INSERT INTO vng_file VALUES(l_vng.*)
           IF STATUS THEN
              CALL cl_err3("ins","vng_file",l_vng.vng01,l_vng.vng02,SQLCA.sqlcode,
                           "","",1)
              ROLLBACK WORK
              RETURN
           ELSE
              COMMIT WORK
           END IF
     END IF
     LET g_cmd = "apsi324 '",l_vng.vng01,"' '",l_vng.vng02,"' '",l_vng.vng03,"' '",l_vng.vng04,"' '",l_vng.vng11,"'"
     CALL cl_cmdrun(g_cmd)

END FUNCTION

FUNCTION i700_aps_vnm()
 LET g_cmd = "apsi331 '",g_sfb.sfb05,"' '",g_sfb.sfb01,"' '",g_ecm[l_ac].ecm03,"' '",g_ecm[l_ac].ecm04,"' '",g_ecm[l_ac].ecm012,"'" #FUN-B50101 add ecm012
 CALL cl_cmdrun(g_cmd)
END FUNCTION

#FUN-960102 MARK --STR-----------------------------------------------------
#FUNCTION i700_aps_vlj() #平行加工
#    DEFINE l_cnt     LIKE type_file.num5
#    DEFINE l_vlj06   LIKE vlj_file.vlj06
#
#    SELECT COUNT(*) INTO l_cnt
#      FROM vlj_file
#     WHERE vlj01 = g_sfb.sfb01
#       AND vlj02 = g_sma.sma917
#       AND vlj03 = g_ecm[l_ac].ecm03
#       AND vlj05 = 0
#    IF g_sma.sma917 = 0 THEN
#        LET l_vlj06 = g_ecm[l_ac].ecm06
#        IF cl_null(l_vlj06) THEN
#            #APS的資源型態為"工作站",工單製程追蹤的工作站不可空白!
#            CALL cl_err(l_vlj06,'aps-024',1)
#            RETURN
#        END IF
#    ELSE
#        LET l_vlj06 = g_ecm[l_ac].ecm05
#        IF cl_null(l_vlj06) THEN
#            #APS的資源型態為"機器編號",工單製程追蹤的機器編號不可空白!
#            CALL cl_err(l_vlj06,'aps-021',1)
#            RETURN
#        END IF
#    END IF
#    IF cl_null(g_ecm[l_ac].ecm04) THEN
#        CALL cl_err('','asf-431',1)
#        RETURN
#    END IF
#    IF l_cnt <= 0 THEN
#       INSERT INTO vlj_file(vlj01,vlj02,vlj03,vlj05,vlj06,vlj13,vlj14,vlj15,vlj16,vlj49,vlj50,vlj51,
#                            vlj301,vlj302,vlj303,vlj311,vlj312,vlj313,vlj314,vlj315,vlj316,vljoriu,vljorig)
#                      VALUES(g_sfb.sfb01,g_sma.sma917,g_ecm[l_ac].ecm03,
#                             0,l_vlj06,
#                             g_sfb.sfb08,g_ecm[l_ac].ecm14,
#                             g_ecm[l_ac].ecm15,g_ecm[l_ac].ecm16,
#                             g_ecm[l_ac].ecm49,g_ecm[l_ac].ecm50,
#                             g_ecm[l_ac].ecm51,
#                             0,0,0,0,0,0,0,0,0, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#        IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins","vlj_file",g_sfb.sfb01,g_sma.sma917,SQLCA.sqlcode,"","",1)
#            ROLLBACK WORK
#        ELSE
#            COMMIT WORK
#        END IF
#    ELSE
#        UPDATE vlj_file
#           SET vlj06 = l_vlj06
#        WHERE vlj01 = g_sfb.sfb01
#          AND vlj02 = g_sma.sma917
#          AND vlj03 = g_ecm[l_ac].ecm03
#          AND vlj05 = 0
#        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
#            CALL cl_err3("upd","vlj_file",g_sfb.sfb01,g_sma.sma917,SQLCA.sqlcode,"","",1)
#            ROLLBACK WORK
#        ELSE
#            COMMIT WORK
#        END IF
#    END IF
#    LET g_cmd = "apsi327 '",g_sfb.sfb01,"' ",g_sma.sma917," ",g_ecm[l_ac].ecm03
#    CALL cl_cmdrun(g_cmd) #TQC-8A0013 mod
#    CALL i700_show()
#    CALL i700_aps_lum('N')   #TQC-8A0013 add
#END FUNCTION
#FUN-960102 MARK --END---------------------------------------------------

#FUN-960102 ADD --STR------------------------------
FUNCTION i700_ecm_resource_change()
DEFINE l_ecm05_2   LIKE ecm_file.ecm05
DEFINE l_ecm06_2   LIKE ecm_file.ecm06


  OPEN WINDOW i700_w2 AT 15,20 WITH FORM "aec/42f/aeci700_2"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("aeci700_2")
  CALL cl_set_head_visible("","YES")

  DISPLAY g_sfb.sfb01 TO FORMONLY.sfb01_2
  DISPLAY g_sfb.sfb06 TO FORMONLY.sfb06_2
  DISPLAY g_ecm[l_ac].ecm03 TO FORMONLY.ecm03_2
  DISPLAY g_ecm[l_ac].ecm04 TO FORMONLY.ecm04_2
  DISPLAY g_ecm[l_ac].ecm05 TO FORMONLY.ecm05_2
  DISPLAY g_ecm[l_ac].ecm06 TO FORMONLY.ecm06_2
  DISPLAY g_ecm[l_ac].ecm012 TO FORMONLY.ecm012_2 #FUN-B50101 add

  LET l_ecm05_2 = g_ecm[l_ac].ecm05
  LET l_ecm06_2 = g_ecm[l_ac].ecm06



  INPUT l_ecm05_2, l_ecm06_2 WITHOUT DEFAULTS
        FROM FORMONLY.ecm05_2, FORMONLY.ecm06_2

     BEFORE INPUT
          IF g_sma.sma917 = '0' THEN
             CALL cl_set_comp_entry("ecm06_2",TRUE)
             CALL cl_set_comp_entry("ecm05_2",FALSE)
             CALL cl_set_comp_required("ecm06_2",TRUE)
             CALL cl_set_comp_required("ecm05_2",FALSE)
          ELSE
            CALL cl_set_comp_entry("ecm05_2",TRUE)
            CALL cl_set_comp_entry("ecm06_2",FALSE)
            CALL cl_set_comp_required("ecm05_2",TRUE)
            CALL cl_set_comp_required("ecm06_2",FALSE)
          END IF

     AFTER FIELD ecm05_2
        LET l_ecm05_2 = get_fldbuf(ecm05_2)
        IF NOT cl_null(l_ecm05_2) THEN
           SELECT * FROM eci_file
            WHERE eci01 = l_ecm05_2
           IF STATUS  THEN
              CALL cl_err('','aec-011',1)
              NEXT FIELD ecm05_2
           END IF
        ELSE
           IF g_sma.sma917 = '1' THEN    #FUN-960102 ADD
              CALL cl_err('','mfg5103',1)
           END IF                        #FUN-960102 ADD
        END IF

     AFTER FIELD ecm06_2
        LET l_ecm06_2 = get_fldbuf(ecm06_2)
        SELECT * FROM eca_file
         WHERE eca01 = l_ecm06_2
        IF STATUS  THEN
           CALL cl_err('','asf-676',1)
           NEXT FIELD ecm06_2
        ELSE
           IF g_sma.sma917 = '0' THEN       #FUN-960102 ADD
              CALL cl_err('','mfg5103',1)
           END IF                           #FUN-960102 ADD
        END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(ecm05_2)                 #機械編號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_eci"
                LET g_qryparam.default1 = l_ecm05_2
                CALL cl_create_qry() RETURNING l_ecm05_2
                DISPLAY l_ecm05_2 TO FORMONLY.ecm05_2
                NEXT FIELD ecm05_2
           WHEN INFIELD(ecm06_2)                 #生產站別
                CALL q_eca(FALSE,TRUE,l_ecm06_2) RETURNING l_ecm06_2
                DISPLAY l_ecm06_2 TO FORMONLY.ecm06_2
                NEXT FIELD ecm06_2
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

     ON ACTION accept
        IF g_sma.sma917 = '1' THEN
           LET l_ecm05_2 = get_fldbuf(ecm05_2)
           IF NOT cl_null(l_ecm05_2) THEN
              SELECT * FROM eci_file
               WHERE eci01 = l_ecm05_2
              IF STATUS  THEN
                 CALL cl_err('','aec-011',1)
                 NEXT FIELD ecm05_2
              END IF

              LET g_ecm[l_ac].ecm05 = l_ecm05_2

              UPDATE ecm_file set ecm05 = l_ecm05_2
               WHERE ecm01 = g_sfb.sfb01
                 AND ecm03 = g_ecm[l_ac].ecm03
                 AND ecm012 = g_ecm[l_ac].ecm012 #FUN-B50101 add
                 AND ecm04 = g_ecm[l_ac].ecm04

              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ecm_file",g_sfb.sfb01,g_ecm_t.ecm03,SQLCA.sqlcode,"","",1)
                 LET g_ecm[l_ac].ecm05 = g_ecm_t.ecm05
                 ROLLBACK WORK
              ELSE
                 CALL cl_err('','9062',1)
                 EXIT INPUT
              END IF
           ELSE
              CALL cl_err('','mfg5103',1)
           END IF
        ELSE
           LET l_ecm06_2 = get_fldbuf(ecm06_2)
           IF NOT cl_null(l_ecm06_2) THEN
              SELECT * FROM eca_file
               WHERE eca01 = l_ecm06_2
              IF STATUS  THEN
                 CALL cl_err('','asf-676',1)
                 NEXT FIELD ecm06_2
              END IF
              LET g_ecm[l_ac].ecm06 = l_ecm06_2

              UPDATE ecm_file set ecm06 = l_ecm06_2
               WHERE ecm01 = g_sfb.sfb01
                 AND ecm03 = g_ecm[l_ac].ecm03
                 AND ecm012 = g_ecm[l_ac].ecm012 #FUN-B50101 add
                 AND ecm04 = g_ecm[l_ac].ecm04

              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ecm_file",g_sfb.sfb01,g_ecm_t.ecm03,SQLCA.sqlcode,"","",1)
                 LET g_ecm[l_ac].ecm06 = g_ecm_t.ecm06
                 ROLLBACK WORK
              ELSE
                 CALL cl_err('','9062',1)
                 EXIT INPUT
              END IF
           ELSE
              CALL cl_err('','mfg5103',1)
           END IF
        END IF

  END INPUT
  IF INT_FLAG THEN
     CLOSE WINDOW i700_w2
     LET INT_FLAG = 0
     RETURN
  END IF

  CLOSE WINDOW i700_w2

END FUNCTION
#FUN-960102 ADD --END------------------------------

#FUN-A10044 ---begin---
FUNCTION i700_out()
  DEFINE l_name     STRING                 #No.FUN-A60011
  DEFINE l_sfb02_d  STRING
  DEFINE l_smyslip  LIKE smy_file.smyslip
  DEFINE l_pmc03    LIKE pmc_file.pmc03
  DEFINE l_gemacti  LIKE gem_file.gemacti
  DEFINE sr         RECORD
           sfb01    LIKE sfb_file.sfb01,
           smydesc  LIKE smy_file.smydesc,
           sfb05    LIKE sfb_file.sfb05,
           ima02    LIKE ima_file.ima02,
           ima021   LIKE ima_file.ima021,
           sfb06    LIKE sfb_file.sfb06,
           ima55    LIKE ima_file.ima55,
           sfb02    LIKE sfb_file.sfb02,
           sfb02_d  LIKE type_file.chr1000,
           sfb81    LIKE sfb_file.sfb81,
           sfb82    LIKE sfb_file.sfb82,
           pmc03    LIKE pmc_file.pmc03,
           sfb22    LIKE sfb_file.sfb22,
           sfb221   LIKE sfb_file.sfb221,
           sfb13    LIKE sfb_file.sfb13,
           sfb15    LIKE sfb_file.sfb15,
           a        LIKE ecm_file.ecm03,
           b        LIKE ecm_file.ecm03,
           sfb99    LIKE sfb_file.sfb99,
           sfb87    LIKE sfb_file.sfb87,
           ecm03    LIKE ecm_file.ecm03,
           ecm04    LIKE ecm_file.ecm04,
           ecm45    LIKE ecm_file.ecm45,
           ecm06    LIKE ecm_file.ecm06,
           eca02    LIKE eca_file.eca02,
           vmn081   LIKE vmn_file.vmn081,
           ecm14    LIKE ecm_file.ecm14,
           ecm13    LIKE ecm_file.ecm13,
           ecm16    LIKE ecm_file.ecm16,
           ecm15    LIKE ecm_file.ecm15,
           ecm49    LIKE ecm_file.ecm49,
           ecm50    LIKE ecm_file.ecm50,
           ecm51    LIKE ecm_file.ecm51,
           ecm05    LIKE ecm_file.ecm05,
           vmn08    LIKE vmn_file.vmn08,
           ecm52    LIKE ecm_file.ecm52,
           ecm53    LIKE ecm_file.ecm53,
           ecm54    LIKE ecm_file.ecm54,
           #No.FUN-A60011  --Begin
           ecm011   LIKE ecm_file.ecm011,
           ecm012   LIKE ecm_file.ecm012,
        #   ecu014   LIKE ecu_file.ecu014,  #FUN-B10056  mark
           ecm014   LIKE ecm_file.ecm014,   #FUN-B10056 
           ecm015   LIKE ecm_file.ecm015,   #FUN-B10056
           ecm321   LIKE ecm_file.ecm321,
           ecm62    LIKE ecm_file.ecm62,
           ecm63    LIKE ecm_file.ecm63,
           ecm65    LIKE ecm_file.ecm65,
           ecm12    LIKE ecm_file.ecm12,
           ecm34    LIKE ecm_file.ecm34,
           ecm64    LIKE ecm_file.ecm64,  #CHI-A70026 add ,
           #No.FUN-A60011  --End
           wipqty   LIKE ecm_file.ecm315, #CHI-A70026 add
           ecm301   LIKE ecm_file.ecm301, #CHI-A70026 add
           ecm302   LIKE ecm_file.ecm302, #CHI-A70026 add
           ecm303   LIKE ecm_file.ecm303, #CHI-A70026 add
           ecm311   LIKE ecm_file.ecm311, #CHI-A70026 add
           ecm312   LIKE ecm_file.ecm312, #CHI-A70026 add
           ecm316   LIKE ecm_file.ecm316, #CHI-A70026 add
           ecm313   LIKE ecm_file.ecm313, #CHI-A70026 add
           ecm314   LIKE ecm_file.ecm314, #CHI-A70026 add
           ecm315   LIKE ecm_file.ecm315, #CHI-A70026 add
           ecm322   LIKE ecm_file.ecm322, #CHI-A70026 add
           ecm291   LIKE ecm_file.ecm291, #CHI-A70026 add
           ecm292   LIKE ecm_file.ecm292  #CHI-A70026 add
                    END RECORD
  DEFINE l_ecm59    LIKE ecm_file.ecm59 #CHI-A70026 add

    IF cl_null(g_sfb.sfb01) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc=" sfb01 = '",g_sfb.sfb01,"'"
       LET g_wc=" 1=1 "
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

    CALL cl_del_data(l_table)

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES",
                "(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ",
                " ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ",
                " ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ",
    #            " ? )"     #FUN-B10056 mark
                " ?,? )"    #FUN-B10056 add ?
    #CHI-A70026 mod --end--
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep",STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
   LET g_sql = "SELECT sfb01,'',sfb05,ima02,ima021,sfb06,ima55,sfb02,'',sfb81,sfb82,'',sfb22,",
               "sfb221,sfb13,sfb15,'','',sfb99,sfb87,ecm03,ecm04,ecm45,ecm06,eca02,'',",
               "ecm14,ecm13,ecm16,ecm15,ecm49,ecm50,ecm51,ecm05,'',ecm52,ecm53,ecm54,",
               #No.FUN-A60011  --Begin
               #"ecm011, ecm012, ''    , ecm321, ecm62 ,",  #FUN-B10056 mark
               "ecm011, ecm012, ecm014, ecm015, ecm321, ecm62 ,", #FUN-B10056 add ecm014,ecm015
               "ecm63 , ecm65 , ecm12 , ecm34 , ecm64  ",
               #No.FUN-A60011  --End
               ",'',ecm301,ecm302,ecm303,ecm311,ecm312,ecm316,ecm313,ecm314,ecm315,ecm322,ecm291,ecm292,ecm59", #CHI-A70026 add
               " FROM sfb_file LEFT OUTER JOIN ima_file ON sfb05 = ima01,",
               " ecm_file LEFT OUTER JOIN eca_file ON ecm06 = eca01",
               " WHERE sfb01 = ecm01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED

   LET g_sql = g_sql CLIPPED," ORDER BY sfb01,ecm012,ecm03 "  #No.FUN-A60011
   PREPARE i700_pl FROM g_sql
   IF STATUS THEN
      CALL cl_err("i700_pl",STATUS,1)
   END IF
   DECLARE i700_curs CURSOR FOR i700_pl

  #FOREACH i700_curs INTO sr.*          #CHI-A70026 mark
   FOREACH i700_curs INTO sr.*,l_ecm59  #CHI-A70026
      CALL i700_sfb02(sr.sfb02) RETURNING l_sfb02_d
      LET sr.sfb02_d = l_sfb02_d

      CALL s_get_doc_no(sr.sfb01) RETURNING l_smyslip
      LET sr.smydesc = ''
      SELECT smydesc INTO sr.smydesc FROM smy_file
       WHERE smyslip = l_smyslip

      #No.FUN-A60011  --Begin
      #TQC-AC0374--begin--modify----
      #SELECT ecu014 INTO sr.ecu014
      #  FROM ecu_file
      # WHERE ecu01 = sr.sfb05
      #   AND ecu02 = sr.sfb06
      #   AND ecu012= sr.ecm012
    #  CALL s_schdat_ecu014(sr.sfb01,sr.ecm012) RETURNING sr.ecu014  #TQC-AC0374   #FUN-B10056 mark
      #TQC-AC0374--end--modify------
      #No.FUN-A60011  --End

      LET g_errno = ' '
      SELECT gem03,gemacti INTO l_pmc03,l_gemacti FROM  gem_file
       WHERE gem01 = sr.sfb82
      CASE WHEN SQLCA.SQLCODE = 100
              SELECT pmc03 INTO l_pmc03 FROM  pmc_file
               WHERE pmc01 = sr.sfb82
              IF STATUS THEN
                 LET g_errno = 'x'
               END IF
           WHEN l_gemacti='N' LET g_errno = '9028'
           OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE

       IF cl_null(g_errno)  THEN
          LET sr.pmc03= l_pmc03
       END IF

      SELECT MIN(ecm03),MAX(ecm03) INTO sr.a,sr.b
            FROM ecm_file
           WHERE ecm01=sr.sfb01
      IF sr.a IS NULL THEN LET sr.a = 0 END IF
      IF sr.b IS NULL THEN LET sr.b = 0 END IF

      SELECT vmn08,vmn081 INTO sr.vmn08,sr.vmn081 FROM vmn_file
         WHERE vmn01 = sr.sfb05
           AND vmn02 = sr.sfb01
           AND vmn03 = sr.ecm03
           AND vmn04 = sr.ecm04

      #CHI-A70026 add --start--
      #get WIP QTY
      #某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
      #若要做Check-In則可報工數=c-f-g-d-e-h+i。
       IF sr.ecm54='Y' THEN   #check in 否
          LET sr.wipqty
               =  sr.ecm291                  #check in
                - sr.ecm311*l_ecm59          #良品轉出
                - sr.ecm312*l_ecm59          #重工轉出
                - sr.ecm313*l_ecm59          #當站報廢
                - sr.ecm314*l_ecm59          #當站下線
                - sr.ecm316*l_ecm59
       ELSE
          LET sr.wipqty
              =  sr.ecm301                  #良品轉入量
               + sr.ecm302                  #重工轉入量
               + sr.ecm303
               - sr.ecm311*l_ecm59          #良品轉出
               - sr.ecm312*l_ecm59          #重工轉出
               - sr.ecm313*l_ecm59          #當站報廢
               - sr.ecm314*l_ecm59          #當站下線
               - sr.ecm316*l_ecm59
       END IF
       IF cl_null(sr.wipqty) THEN LET sr.wipqty=0 END IF
      #CHI-A70026 add --end--

      EXECUTE insert_prep USING sr.*
   END FOREACH
   CALL  cl_wcchp(g_wc,'sfb01,sfb05,sfbuser,sfbgrup,sfbmodu,sfbdate,sfbacti')
         RETURNING g_wc
   LET g_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED

   LET g_str = g_wc
   #No.FUN-A60011  --Begin
   IF g_sma.sma541 = 'N' THEN
      LET l_name = 'aeci700'
   ELSE
      LET l_name = 'aeci700_1'
   END IF

   CALL cl_prt_cs3('aeci700',l_name,g_sql,g_str)
   #No.FUN-A60011  --End
   CLOSE i700_cs
END FUNCTION
#FUN-A10044 ----end ---
#No.FUN-9C0077 程式精簡

#No.FUN-A60011  --Begin
FUNCTION i700_subcontract()
   DEFINE l_str       STRING
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_sw        LIKE type_file.num5
   DEFINE l_wip       LIKE ecm_file.ecm321
   DEFINE l_sfb04     LIKE sfb_file.sfb04
   DEFINE l_sfb87     LIKE sfb_file.sfb87

   IF g_rec_b <= 0 THEN RETURN END IF
   IF l_ac <= 0 THEN RETURN END IF

   IF cl_null(g_sfb.sfb01) OR cl_null(g_ecm[l_ac].ecm03) THEN   #FUN-A80102
      RETURN
   END IF

   SELECT sfb04,sfb87 INTO l_sfb04,l_sfb87 FROM sfb_file
    WHERE sfb01 = g_sfb.sfb01
   IF l_sfb04 = '8' THEN
      CALL cl_err(g_sfb.sfb01,'axr-369',0)
      RETURN
   END IF
   IF l_sfb87 <> 'Y' THEN
      CALL cl_err(g_sfb.sfb01,'axm-445',0)
      RETURN
   END IF
   #TQC-B40122--mark--begin
   #check是否可以有委外量调用asfp700处理
   #LET l_flag = FALSE
   #FOR l_i = 1 TO g_rec_b
   #    IF cl_null(g_ecm[l_ac].ecm03) THEN  #FUN-A80102
   #       CONTINUE FOR
   #    END IF
   #    IF g_ecm[l_i].ecm012 IS NULL THEN LET g_ecm[l_i].ecm012 = ' ' END IF  #FUN-A80102
   #    CALL s_sub_available_qty(g_sfb.sfb01,g_ecm[l_i].ecm012,g_ecm[l_i].ecm03)
   #         RETURNING l_sw,l_wip
   #    IF l_sw = FALSE OR l_wip <= 0 THEN
   #       CONTINUE FOR
   #    END IF
   #    LET l_flag = TRUE
   #    EXIT FOR
   #END FOR
   #
   #IF l_flag = FALSE THEN
   #   CALL ui.Interface.refresh()
   #   CALL cl_err(g_sfb.sfb01,'aec-700',0)
   #   RETURN
   #END IF
   #TQC-B40122--mark--end
   #TQC-B40122--add--begin
   IF cl_null(g_ecm[l_ac].ecm03) THEN  
      RETURN 
   END IF
   IF g_ecm[l_ac].ecm012 IS NULL THEN LET g_ecm[l_ac].ecm012 = ' ' END IF  
   CALL s_sub_available_qty(g_sfb.sfb01,g_ecm[l_ac].ecm012,g_ecm[l_ac].ecm03)
        RETURNING l_sw,l_wip     
   IF l_sw = FALSE OR l_wip <= 0 THEN
      CALL cl_err('','aec-700',1)
      RETURN 
   END IF       
   #TQC-B40122--end
  
   LET l_str = 'ecm01 = "',g_sfb.sfb01,'" AND ecm012 = "',g_ecm[l_ac].ecm012,'" AND ecm03 = ',g_ecm[l_ac].ecm03
   LET g_cmd = "asfp700 'N' '",l_str CLIPPED,"'"
   CALL cl_cmdrun_wait(g_cmd)

   SELECT ecm321,ecm52 INTO g_ecm[l_ac].ecm321,g_ecm[l_ac].ecm52 FROM ecm_file
    WHERE ecm01 = g_sfb.sfb01
      AND ecm012= g_ecm[l_ac].ecm012
      AND ecm03 = g_ecm[l_ac].ecm03
   CALL i700_refresh()

END FUNCTION

FUNCTION i700_refresh()

   DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

END FUNCTION
#No.FUN-A60011  --End
#FUN-A80150---add---start---
FUNCTION i700_ecm67()   #供應商check
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti,
          l_pmc05     LIKE pmc_file.pmc05 
 
   LET g_errno=' '
   SELECT pmcacti,pmc05
     INTO l_pmcacti,l_pmc05
     FROM pmc_file
    WHERE pmc01=g_ecm[l_ac].ecm67
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='mfg3014'
        WHEN l_pmcacti='N'      LET g_errno='9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        WHEN l_pmc05='0'        LET g_errno='aap-032'
        WHEN l_pmc05='3'        LET g_errno='aap-033'
   END CASE
END FUNCTION
#FUN-A80150---add---end---
#FUN-B90141 --START--            
FUNCTION i700_chk_ecm63()
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_fac    LIKE type_file.num26_10
DEFINE l_fac2   LIKE type_file.num26_10
DEFINE l_ima55  LIKE ima_file.ima55

   IF cl_null(g_ecm[l_ac].ecm62) OR cl_null(g_ecm[l_ac].ecm63) THEN
      RETURN TRUE 
   END IF  

   SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=g_sfb.sfb05
   
   CALL s_umfchk(g_sfb.sfb05,g_ecm[l_ac].ecm58,l_ima55)
                            RETURNING l_flag,l_fac
   IF l_flag THEN
      CALL cl_err('','abm-731',1)
      RETURN 
   END IF
   LET l_fac2 = g_ecm[l_ac].ecm63 / g_ecm[l_ac].ecm62
   IF l_fac != l_fac2 THEN 
      CALL cl_err('','aec-069',1)
      RETURN FALSE    
   END IF    
   RETURN TRUE                     
END FUNCTION 
#FUN-B90141 --END-- 
#FUN-B50046
