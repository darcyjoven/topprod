# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci100.4gl
# Descriptions...: 產品製程資料維護作業
# Date & Author..: 99/04/29 By Iceman
# Modify.........: No:8023 03/10/31 Sophia 單身輸入第一筆後, 系統自動跳至第二筆的製程序, 無法按 OK 存起來離開,
#                                          系統會再跳至轉入單位要求輸入, 不符合單身輸入的標準規則 -
#                                          改用 per not null,required control
# Modify.........: No:8567 03/10/28 Apple LET g_ecb_sarrno = 3,在文字模式應下更正為 g_ecb_sarrno = 2
#                                          --> genero 不用改
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-520098 05/02/22 By ching copy錯誤修改
# Modify.........: No.MOD-530047 05/03/09 By ching 作業編號無效不可輸入
# Modify.........: No.MOD-530167 05/04/04 By pengu 輸入無效的作業編號後勿default作業名稱及工作中心等資料
# Modify.........: No.FUN-580024 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-660193 06/07/01 By Joe APS版更,修正相關程式
# Modify.........: No.FUN-670069 06/08/03 By Joe aps_ecb add route_sequ
# Modify.........: No.FUN-680048 06/08/16 By Joe (1)aps_ecb.route_id 欄位放大為varchar2(50),欄位值改為"料號+製程編號"
#                                                (2)若與APS整合時,異動資料時,一併異動APS相關資料
# Modify.........: No.FUN-680073 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0065 06/10/27 By Ray  產品制程修改工作站時應同時更改sgc_file中的sgc04
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0188 06/12/27 By Ray  單身完工比率，工時欄位輸入不合理數據報錯
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-720043 07/03/07 By Mandy APS整合調整
# Modify.........: No.TQC-740077 07/04/13 By wujie 修改時，作業編號沒有檢查
# Modify.........: No.TQC-750013 07/05/04 By Mandy 1.一進入程式,不查詢直接按Action "APS相關資料"時的控管
#                                                  2.參數設不串APS時,Action "APS相關資料"不要出現
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.FUN-7C0002 08/01/10 by Yiting apsi202->apsi311.4gl,apsi212.4gl->apsi312.4gl
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810017 08/01/22 By jan 新增服飾作業
# Modify.........: No.FUN-840036 08/04/11 By jan 修改服飾作業
# Modify.........: No.FUN-840068 08/04/21 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-870012 08/06/26 BY DUKE  add apsi326
# Modify.........: No.FUN-870124 08/07/23 By jan 復制資料后，不能取消審核
# Modify.........: No.FUN-890013 08/09/03 BY DUKE 呼叫apsi312時,加傳參數是否委外ecb39
# Modify.........: No.FUN-890096 08/09/26 BY DUKE add apsi331 APS途程製程指定工具維護作業
# Modify.........: No.FUN-890096 08/09/26 BY DUKE add apsi331 APS途程製程指定工具維護作業
# Modify.........: No.TQC-890064 08/09/30 By Mandy 有串APS時,整體參數資源型態設機器時,機器編號NOT NULL,REQUIRED
# Modify.........: No.FUN-7A0072 08/10/07 By jamie 1.新增樣板,順序與欄位與維護程式(aeci100)一致。
#                                                  2.per檔增加 Input"維護說明資料"勾選，增加列印"製程說明資料"功能。
# Modify.........: No.FUN-8A0088 08/10/17 by duke 與APS連結時,複製需同時複製APS相關資料
# Modify.........: No.TQC-8A0069 08/10/28 by duke 修正aps取替代以及aps指定工具在無單身資料時顯示無資料訊息
# Modify.........: No.TQC-8A0076 08/10/29 by duke 未與aps整合時,aps 相關資料不複製
# Modify.........: No.FUN-8C0028 08/12/03 BY DUKE  串連apsi312時,增加 vmn19 預設值0
# Modify.........: No.TQC-8C0016 08/12/09 BY Mandy (1)當系統參數設定有與APS整合時,單身畫面加show資源群組編號(機器)(vmn08)及資源群組編號(工作站)(vmn081)供使用者維護，維護時需判斷系統參數檔的資源型態,當資源型態為機器時,機器跟資源群組編號(機器)至少要有一個欄位有值.
#                                                  (2)維護資源群組編號(機器)及資源群組編號(工作站)時,需判斷vmn_file是否存在,若無存在則需insert,若有存在則需update
#                                                  (3)aeci100單身變更時,需同步update ecbdate
# Modify.........: No.MOD-8C0171 08/12/17 By claire 維護說明資料無法設權限控管
# Modify.........: No.TQC-910003 09/01/03 BY DUKE MOVE OLD APS TABLE
# Modify.........: No.TQC-920031 09/03/31 By chenyu copy()后面的ROLLBACK WORK去掉
# Modify.........: No.MOD-920375 09/03/31 By chenyu 點擊"維護說明資料"之前要判斷是否有資料
# Modify.........: No.MOD-940256 09/05/21 By Pengu ecu01應default " "(一個空白字元)
# Modify.........: No.FUN-960056 09/06/26 By jan 單身新增ecb48/ecb49欄位
# Modify.........: No.TQC-970231 09/07/23 By lilingyu 單身進入轉入單位就報錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960063 09/10/13 By jan 修改單身 ECB03 DEFAULT值的給予方式
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A40053 10/04/12 By Sarah i100_cs()段計算資料筆數有問題
# Modify.........: No.TQC-A50072 10/05/19 By destiny ecu01查询开窗开本表资料
# Modify.........: No.FUN-A50081 10/05/21 By lilingyu 平行工藝功能改善
# Modify.........: No.FUN-A50100 10/05/31 By lilingyu 平行工藝功能調整
# Modify.........: No.FUN-A60028 10/06/09 By lilingyu 平行工藝功能調整
# Modify.........: No.FUN-A80150 10/09/02 By sabrina 單身新增報工點否欄位
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.TQC-AB0411 10/11/30 By chenying 當asms280 sma541勾選時，ecu012必須輸入
# Modify.........: No.TQC-AC0231 10/11/17 By vealxu aeci100的複製功能，不走"平行工藝"時，不應該出現"製程段"
# Modify.........: No.TQC-AC0245 10/12/18 By lixh1  增加aeci100新增時的列印功能
# Modify.........: No.FUN-AC0076 10/12/27 By wangxin 加action串查aeci621
# Modify.........: No.TQC-B10209 11/01/20 By destiny orig,oriu新增时未付值
# Modify.........: No.FUN-B20078 11/03/01 By lixh1  製程段資料的捞取和控管直接對基本檔ecr_file操作
# Modify.........: No.MOD-B30427 11/03/14 By lixh1  拿掉不必要的報錯信息
# Modify.........: No.MOD-B30520 11/03/15 By lixh1 (BUG)處理打第二筆的製程段號後，製程段說明未帶出
# Modify.........: No.TQC-B40078 11/04/14 By lixia 下工藝段號/說明欄位值去除後欄位說明未清空
# Modify.........: No.MOD-B40227 11/04/25 By destiny 不使用平行工艺功能工艺段号为空就不能使用明细工艺维护按钮
# Modify.........: No.FUN-B50046 11/05/10 By abby GP5.25 APS追版 str-------------------------------
# Modify.........: No:TQC-940179 09/04/29 By Duke aeci100 作業編號異動時，刪除原作業編號之維護檔 vmn_file,vms_file, vnm_file 資料
# Modify.........: No:FUN-A40060 10/04/23 By Mandy TQC-940179 調整不正確,重新調整:製程序或作業編號異動時,需連動更新vmn_file,vms_file,vnm_file
# Modify.........: No:FUN-9A0047 09/10/20 當製程為委外時,不需要控管機器編號和資源群組編號(機器),至少要有一個欄位有值的限制
# Modify.........: No.FUN-B50046 11/05/10 By abby GP5.25 APS追版 end--------------------------------
# Modify.........: No.TQC-B50100 11/05/20 By zhangll 複製時清空該清空的欄位
# Modify.........: No.TQC-B50106 11/05/20 By zhangll 補充欄位顯示
# Modify.........: No.FUN-B50101 11/05/24 By Mandy GP5.25 平行製程 影響APS程式調整
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60169 11/06/17 By xianghui BUG修改，處理ecu014沒有由ecu012帶出
# Modify.........: No.TQC-B60171 11/06/17 By jan 程式出現多個btn-**的多餘按鈕
# Modify.......... No.FUN-B60152 11/06/29 By Mandy 異動vmn_file後,也需更新ecudate,如此apsp500在拋APS-途程製程資料時,才會抓出有異動的資料
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改
# Modify.......... No.FUN-B90117 11/09/26 By lilingyu 增加TREE控件連動顯示
# Modify.......... No.FUN-B90141 11/11/09 By jason 檢查'單位轉換分子/單位轉換分母'需等於單位轉換率
# Modify.........: No:FUN-BB0083 11/12/12 By xujing 增加數量欄位小數取位
# Modify.........: No:TQC-BC0166 11/12/29 By yuhuabao 添加裁片管理否欄位(ecbslk01)
# Modify.......... No.TQC-BC0168 11/12/29 By destiny 跳下一笔时会报此笔资料已审核
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0062 12/03/06 By lilingyu accept被重複定義
# Modify.........: No:MOD-C20166 12/03/06 By ck2yuan 將i100_chk_ecu51改到AFTER ROW檢查,除了ecb51為null,其他錯誤都next field到ecb46
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No.MOD-C30195 12/03/10 By xujing 修改MOD-C20166增加在AFTER ROW的程式段造成的問題
# Modify.........: No.MOD-C30386 12/03/10 By bart 若行業別為ICD, 維護產品製程資料(aeci100)時,不要控卡單位轉換率。
# Modify.........: No.MOD-C30539 12/03/12 By xianghui 修改MOD-C20166增加在AFTER ROW的程式段造成的問題
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C90071 12/09/20 By Elise 進入menu前會判斷是否走平行製程
# Modify.........: No.CHI-C70033 12/10/25 By bart ecb49改成ecb25
# Modify.........: No.CHI-C90006 12/11/13 By bart 增加失效功能
# Modify.........: No.MOD-D10062 13/01/06 By suncx tree_fill查詢sql語句錯誤修正
# Modify.........: No.MOD-D10047 13/01/07 By suncx 匯出excel問題處理
# Modify.........: No.FUN-D10063 13/01/17 By Nina UPDATE ecu_file 的任何一個欄位時,多加ecudate=g_today
# Modify.........: No.MOD-D20118 13/03/13 By Alberti ecb46應依照轉換率預帶出來
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.MOD-D40052 13/04/09 By suncx 函數i100_chk_ecu51()中IF l_fac != l_fac2 THEN應該改為IF l_fac <= l_fac2 THEN

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../../aec/4gl/aecp110.global"   #FUN-A50100

DEFINE
    g_sfb      RECORD LIKE sfb_file.*,
#   g_ecu      RECORD LIKE ecu_file.*,    #FUN-A50100 移至aecp110.global
    g_ecu_t    RECORD LIKE ecu_file.*,
    g_ecu_o    RECORD LIKE ecu_file.*,
    g_ecu01_t  LIKE ecu_file.ecu01,
    g_ecb03_t  LIKE ecb_file.ecb03,
    l_ecu19    LIKE ecb_file.ecb19,
    l_ecu18    LIKE ecb_file.ecb18,
    l_ecu21    LIKE ecb_file.ecb21,
    l_ecu20    LIKE ecb_file.ecb20,
    l_ecu38    LIKE ecb_file.ecb38,
    l_ecb03    LIKE ecb_file.ecb03,
    l_ecb08    LIKE ecb_file.ecb08,
    g_ecu02_t  LIKE ecu_file.ecu02,
    g_ecu012_t LIKE ecu_file.ecu012,       #FUN-A50081
    l_eci01    LIKE eci_file.eci01,
    b_ecb      RECORD LIKE ecb_file.*,
    g_ima      RECORD LIKE ima_file.*,
    g_wc,g_wc2,g_sql   string,                     #No.FUN-580092 HCN
    m_ecb      RECORD  LIKE ecb_file.*,
    g_ecb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ecb03           LIKE ecb_file.ecb03,      #製程序號
        ecb06           LIKE ecb_file.ecb06,      #作業編號
        ecb17           LIKE ecb_file.ecb17,      #說明
        ecb08           LIKE ecb_file.ecb08,      #工作站編號
        eca02           LIKE eca_file.eca02,      #說明
        vmn081          LIKE vmn_file.vmn081,     #資源群組編號(工作站) #TQC-8C0016 add
        ecb07           LIKE ecb_file.ecb07,      #機械編號
        vmn08           LIKE vmn_file.vmn08,      #資源群組編號(機器)    #TQC-8C0016 add
        ecb38           LIKE ecb_file.ecb38,      #單位人力
        ecb04           LIKE ecb_file.ecb04,      #完工比率
        ecb19           LIKE ecb_file.ecb19,      #標準人工生產時間
        ecb18           LIKE ecb_file.ecb18,      #標準人工設置時間
        ecb21           LIKE ecb_file.ecb21,      #標準機械生產時間
        ecb20           LIKE ecb_file.ecb20,      #標準機械設置時間
        ecbslk05        LIKE ecb_file.ecbslk05,   #現實工價          #No.FUN-810017
        ecbslk04        LIKE ecb_file.ecbslk04,   #標准工價          #No.FUN-810017
        ecbslk02        LIKE ecb_file.ecbslk02,   #現實工時          #No.FUN-810017
        ecbslk01        LIKE ecb_file.ecbslk01,   #裁片管理否        #NO.TQC-BC0166 add
        ecb66           LIKE ecb_file.ecb66,      #報工點            #FUN-A80150 add
        ecb39           LIKE ecb_file.ecb39,      #委外否
        ecb25           LIKE ecb_file.ecb25,      #CHI-C70033
        ecb40           LIKE ecb_file.ecb40,      #PQC否
        ecb41           LIKE ecb_file.ecb41,      #check in 否
        ecb42           LIKE ecb_file.ecb42,      #check in hold
        ecb43           LIKE ecb_file.ecb43,      #check out hold
#       ecb44           LIKE ecb_file.ecb44,      #FUN-A50081
        ecb45           LIKE ecb_file.ecb45,
        ecb46           LIKE ecb_file.ecb46,
        ecb51           LIKE ecb_file.ecb51,      #FUN-A50081
        ecb14           LIKE ecb_file.ecb14,      #FUN-A50081
        ecb52           LIKE ecb_file.ecb52,      #FUN-A50081
        ecb53           LIKE ecb_file.ecb53,      #FUN-A50081
        ecb48           LIKE ecb_file.ecb48,      #FUN-960056
        #ecb49           LIKE ecb_file.ecb49,     #FUN-960056 #CHI-C70033
        ecbud01         LIKE ecb_file.ecbud01,
        ecbud02         LIKE ecb_file.ecbud02,
        ecbud03         LIKE ecb_file.ecbud03,
        ecbud04         LIKE ecb_file.ecbud04,
        ecbud05         LIKE ecb_file.ecbud05,
        ecbud06         LIKE ecb_file.ecbud06,
        ecbud07         LIKE ecb_file.ecbud07,
        ecbud08         LIKE ecb_file.ecbud08,
        ecbud09         LIKE ecb_file.ecbud09,
        ecbud10         LIKE ecb_file.ecbud10,
        ecbud11         LIKE ecb_file.ecbud11,
        ecbud12         LIKE ecb_file.ecbud12,
        ecbud13         LIKE ecb_file.ecbud13,
        ecbud14         LIKE ecb_file.ecbud14,
        ecbud15         LIKE ecb_file.ecbud15
                    END RECORD,
    g_ecb_t         RECORD                 #程式變數 (舊值)
        ecb03           LIKE ecb_file.ecb03,      #製程序號
        ecb06           LIKE ecb_file.ecb06,      #作業編號
        ecb17           LIKE ecb_file.ecb17,      #說明
        ecb08           LIKE ecb_file.ecb08,      #工作站編號
        eca02           LIKE eca_file.eca02,      #說明
        vmn081          LIKE vmn_file.vmn081,     #資源群組編號(工作站) #TQC-8C0016 add
        ecb07           LIKE ecb_file.ecb07,      #機械編號
        vmn08           LIKE vmn_file.vmn08,      #資源群組編號(機器)    #TQC-8C0016 add
        ecb38           LIKE ecb_file.ecb38,      #單位人力
        ecb04           LIKE ecb_file.ecb04,      #完工比率
        ecb19           LIKE ecb_file.ecb19,      #標準人工生產時間
        ecb18           LIKE ecb_file.ecb18,      #標準人工設置時間
        ecb21           LIKE ecb_file.ecb21,      #標準機械生產時間
        ecb20           LIKE ecb_file.ecb20,      #標準機械設置時間
        ecbslk05        LIKE ecb_file.ecbslk05,   #現實工價          #No.FUN-810017
        ecbslk04        LIKE ecb_file.ecbslk04,   #標准工價          #No.FUN-810017
        ecbslk02        LIKE ecb_file.ecbslk02,   #現實工時          #No.FUN-810017
        ecbslk01        LIKE ecb_file.ecbslk01,   #裁片管理否        #NO.TQC-BC0166 add
        ecb66           LIKE ecb_file.ecb66,      #報工點            #FUN-A80150 add
        ecb39           LIKE ecb_file.ecb39,      #委外否
        ecb25           LIKE ecb_file.ecb25,      #CHI-C70033
        ecb40           LIKE ecb_file.ecb40,      #PQC否
        ecb41           LIKE ecb_file.ecb41,      #check in 否
        ecb42           LIKE ecb_file.ecb42,      #check in hold
        ecb43           LIKE ecb_file.ecb43,      #check out hold
#       ecb44           LIKE ecb_file.ecb44,     #FUN-A50081
        ecb45           LIKE ecb_file.ecb45,
        ecb46           LIKE ecb_file.ecb46,
        ecb51           LIKE ecb_file.ecb51,      #FUN-A50081
        ecb14           LIKE ecb_file.ecb14,      #FUN-A50081
        ecb52           LIKE ecb_file.ecb52,      #FUN-A50081
        ecb53           LIKE ecb_file.ecb53,      #FUN-A50081
        ecb48           LIKE ecb_file.ecb48,      #FUN-960056
        #ecb49           LIKE ecb_file.ecb49,     #FUN-960056 #CHI-C70033
        ecbud01         LIKE ecb_file.ecbud01,
        ecbud02         LIKE ecb_file.ecbud02,
        ecbud03         LIKE ecb_file.ecbud03,
        ecbud04         LIKE ecb_file.ecbud04,
        ecbud05         LIKE ecb_file.ecbud05,
        ecbud06         LIKE ecb_file.ecbud06,
        ecbud07         LIKE ecb_file.ecbud07,
        ecbud08         LIKE ecb_file.ecbud08,
        ecbud09         LIKE ecb_file.ecbud09,
        ecbud10         LIKE ecb_file.ecbud10,
        ecbud11         LIKE ecb_file.ecbud11,
        ecbud12         LIKE ecb_file.ecbud12,
        ecbud13         LIKE ecb_file.ecbud13,
        ecbud14         LIKE ecb_file.ecbud14,
        ecbud15         LIKE ecb_file.ecbud15
                    END RECORD,

    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    g_ima55         LIKE ima_file.ima55,
    g_sw            LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(01)
    g_buf           LIKE type_file.chr1000,      #No.FUN-680073 VARCHAR(78)
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680073 VARCHAR(100)
    p_row,p_col     LIKE type_file.num5,         #No.FUN-680073 SMALLINT
    g_rec_b         LIKE type_file.num5,         #單身筆數 #No.FUN-680073 SMALLINT
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT #No.FUN-680073 SMALLINT

DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         #No.FUN-680073 SMALLINT
DEFINE g_cnt                 LIKE type_file.num10        #No.FUN-680073 INTEGER
DEFINE g_msg                 LIKE type_file.chr1000      #No.FUN-680073 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10        #No.FUN-680073 INTEGER
DEFINE g_curs_index          LIKE type_file.num10        #No.FUN-680073 INTEGER
DEFINE g_jump                LIKE type_file.num10        #No.FUN-680073 INTEGER
DEFINE mi_no_ask             LIKE type_file.num10        #No.FUN-680073 INTEGER
DEFINE g_count               LIKE type_file.num10        #FUN-A50081
DEFINE g_ecr02               LIKE ecr_file.ecr02         #FUN-B20078
#FUN-B90117--BEGIN--
DEFINE l_tree_ac       LIKE type_file.num5
DEFINE g_i             LIKE type_file.num5
DEFINE g_str           STRING
DEFINE g_idx           LIKE type_file.num5
DEFINE g_tree DYNAMIC ARRAY OF RECORD
             name           STRING,                 #节点名称
             pid            LIKE ima_file.ima01,    #父节点id
             id             LIKE ima_file.ima01,    #节点id
             has_children   BOOLEAN,                #1:有子节点, null:无子节点
             expanded       BOOLEAN,                #0:不展开, 1展开
             level          LIKE type_file.num5,    #层级
             desc           LIKE type_file.chr100,
             chk            LIKE type_file.chr1     #是否序号
        END RECORD
DEFINE g_tree_focus_idx     STRING                  #当前节点数
DEFINE g_tree_reload        LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_curr_idx           INTEGER
DEFINE g_ecb45_t            LIKE ecb_file.ecb45     #FUN-BB0083
#FUN-B90117--END--

MAIN
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-A80150 add
    DEFER INTERRUPT

   LET g_prog = "aeci100_slk"    #No.FUN-810017

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF

     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
   LET p_row = 1 LET p_col = 3

   OPEN WINDOW i100_w AT p_row,p_col WITH FORM "aec/42f/aeci100"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()

   #當系統參數設定有與APS整合時,
   #單身畫面加show資源群組編號(機器)(vmn08)及資源群組編號(工作站)(vmn081)
   IF cl_null(g_sma.sma901) OR g_sma.sma901 = 'N' THEN
       CALL cl_set_comp_visible("vmn081,vmn08",FALSE)
   END IF

  #FUN-A80150---add---start---
   IF g_sma.sma1431 = 'Y' THEN
      CALL cl_set_comp_visible("ecb66",TRUE)
   ELSE
      CALL cl_set_comp_visible("ecb66",FALSE)
   END IF
  #FUN-A80150---add---end---
#FUN-A50081 --begin--
   IF g_sma.sma541 = 'Y' THEN
   #  CALL cl_set_comp_visible("ecu012,ecu014,ecu015",TRUE)         #FUN-B20078
      CALL cl_set_comp_visible("ecu012,ecu014,ecu015,ecr02",TRUE)   #FUN-B20078
      CALL cl_set_act_visible("chkbom",TRUE)
      CALL cl_set_comp_visible("tree",TRUE)                         #FUN-B90117
   ELSE
   #  CALL cl_set_comp_visible("ecu012,ecu014,ecu015",FALSE)        #FUN-B20078
      CALL cl_set_comp_visible("ecu012,ecu014,ecu015,ecr02",FALSE)  #FUN-B20078
      CALL cl_set_act_visible("chkbom",FALSE)
      CALL cl_set_comp_visible("tree",FALSE)                        #FUN-B90117
   END IF
#FUN-A50081 --end--

#FUN-B90117--begin--
   LET g_tree_reload = "Y"                             #tree是否要重新整理 Y/N
   LET g_tree_focus_idx = 0                            #focus节点index
   CALL i100_tree_fill_1(g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012)      #填充树结构
#FUN-B90117--END--

   CALL i100()

   CLOSE WINDOW i100_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100

END MAIN

FUNCTION i100()

   INITIALIZE g_ecu.* TO NULL
   INITIALIZE g_ecu_t.* TO NULL
   INITIALIZE g_ecu_o.* TO NULL

#  LET g_forupd_sql = "SELECT * FROM ecu_file WHERE ecu01 = ? AND ecu02 =? FOR UPDATE"  #FUN-A50081
   LET g_forupd_sql = "SELECT * FROM ecu_file WHERE ecu01 = ? AND ecu02 =? and ecu012 = ? FOR UPDATE"  #FUN-A50081
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_cl CURSOR FROM g_forupd_sql

   CALL i100_menu()

END FUNCTION

FUNCTION i100_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_ecb.clear()
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
   INITIALIZE g_ecu.* TO NULL    #No.FUN-750051
   INITIALIZE g_tree TO NULL             #FUN-B90117
   INITIALIZE g_ecu.ecu01 TO NULL        #FUN-B90117

   CONSTRUCT BY NAME g_wc ON
       ecu01, ecu02, ecu03,ecu012,ecu015,ecu10,ecu11,ecuuser, ecugrup, ecumodu, ecudate, ecuacti  #No.FUN-810017  #FUN-A50081 add ecu012,ecu015
      ,ecuoriu,ecuorig    #TQC-B50106 add
      ,ecuud01,ecuud02,ecuud03,ecuud04,ecuud05,
       ecuud06,ecuud07,ecuud08,ecuud09,ecuud10,
       ecuud11,ecuud12,ecuud13,ecuud14,ecuud15

               BEFORE CONSTRUCT
                  CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(ecu01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                  #LET g_qryparam.form = "q_ima"             #No.TQC-A50072
                   LET g_qryparam.form = "q_ecu01"           #No.TQC-A50072
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecu01
                   NEXT FIELD ecu01
#FUN-B20078 ---------------------Begin-------------------------
              WHEN INFIELD(ecu012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_ecr"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecu012
                   NEXT FIELD ecu012
#FUN-B20078 ---------------------End---------------------------
#FUN-A60028 --begin--
              WHEN INFIELD(ecu015)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                  #LET g_qryparam.form  = "q_ecu015"  #FUN-B20078
                   LET g_qryparam.form  = "q_ecr"     #FUN-B20078
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecu015
                   NEXT FIELD ecu015
#FUN-A60028 --end--
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT

   IF INT_FLAG THEN RETURN END IF

   CONSTRUCT g_wc2 ON ecb03,ecb06,ecb17,ecb08,ecb07,ecb38,ecb04,ecb19,ecb18,
#                     ecb21,ecb20,ecb39,ecb40,ecb41,ecb42,ecb43,ecb44,ecb45,   #FUN-A50081
                      ecb21,ecb20,ecb39,ecb40,ecb41,ecb42,ecb43,      ecb45,   #FUN-A50081
                      #ecb46,ecb51,ecb14,ecb52,ecb53,ecb48,ecb49,ecb66        #FUN-960056 add ecb48,ecb49  #FUN-A80150 add ecb66 #FUN-A50081 add ecb51,ecb14,ecb52,ecb53 #CHI-C70033
                      ecb46,ecb51,ecb14,ecb52,ecb53,ecb48,ecb25,ecb66 #CHI-C70033
                      ,ecbslk05,ecbslk04,ecbslk02,ecbslk01    #NO.TQC-BC0166 add ecbslk01  #No.FUN-810017
                     ,ecbud01,ecbud02,ecbud03,ecbud04,ecbud05,
                      ecbud06,ecbud07,ecbud08,ecbud09,ecbud10,
                      ecbud11,ecbud12,ecbud13,ecbud14,ecbud15

           FROM s_ecb[1].ecb03,s_ecb[1].ecb06,s_ecb[1].ecb17,
                s_ecb[1].ecb08,s_ecb[1].ecb07,s_ecb[1].ecb38,s_ecb[1].ecb04,
                s_ecb[1].ecb19,s_ecb[1].ecb18,s_ecb[1].ecb21,
                s_ecb[1].ecb20,s_ecb[1].ecb39,s_ecb[1].ecb40,
                s_ecb[1].ecb41,s_ecb[1].ecb42,s_ecb[1].ecb43,
#               s_ecb[1].ecb44,s_ecb[1].ecb45,s_ecb[1].ecb46,   #FUN-A50081
                               s_ecb[1].ecb45,s_ecb[1].ecb46,   #FUN-A50081
                s_ecb[1].ecb51,s_ecb[1].ecb14,s_ecb[1].ecb52,s_ecb[1].ecb53,  #FUN-A50081 add
                #s_ecb[1].ecb48,s_ecb[1].ecb49,s_ecb[1].ecb66                  #FUN-960056  #FUN-A80150 add ecb66 #CHI-C70033
                s_ecb[1].ecb48,s_ecb[1].ecb25,s_ecb[1].ecb66  #CHI-C70033
                ,s_ecb[1].ecbslk05,s_ecb[1].ecbslk04,s_ecb[1].ecbslk02     #No.FUN-810017
                ,s_ecb[1].ecbslk01                                         #NO.TQC-BC0166 add ecbslk01
               ,s_ecb[1].ecbud01,s_ecb[1].ecbud02,s_ecb[1].ecbud03,
                s_ecb[1].ecbud04,s_ecb[1].ecbud05,s_ecb[1].ecbud06,
                s_ecb[1].ecbud07,s_ecb[1].ecbud08,s_ecb[1].ecbud09,
                s_ecb[1].ecbud10,s_ecb[1].ecbud11,s_ecb[1].ecbud12,
                s_ecb[1].ecbud13,s_ecb[1].ecbud14,s_ecb[1].ecbud15

		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)

        ON ACTION controlp                        #
           CASE
              WHEN INFIELD(ecb07)                 #機械編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_eci"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecb07
                   NEXT FIELD ecb07
              WHEN INFIELD(ecb08)
                   CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecb08
                   NEXT FIELD ecb08
              WHEN INFIELD(ecb06)
                   CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecb06
                   NEXT FIELD ecb06
              WHEN INFIELD(ecb42)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_sgg"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecb42
                   NEXT FIELD ecb42
              WHEN INFIELD(ecb43)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_sgg"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecb43
                   NEXT FIELD ecb43
#FUN-A50081 --begin--
#              WHEN INFIELD(ecb44)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c"
#                   LET g_qryparam.form = "q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO ecb44
#                   NEXT FIELD ecb44
#FUN-A50081 --end--
              WHEN INFIELD(ecb45)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecb45
                   NEXT FIELD ecb45
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
              #WHEN INFIELD(ecb49) #查詢廠商檔  #CHI-C70033
              WHEN INFIELD(ecb25) #CHI-C70033
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    #DISPLAY g_qryparam.multiret TO ecb49  #CHI-C70033
                    #NEXT FIELD ecb49  #CHI-C70033
                    DISPLAY g_qryparam.multiret TO ecb25  #CHI-C70033
                    NEXT FIELD ecb25  #CHI-C70033
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


   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecuuser', 'ecugrup')

   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT ecu01,ecu02,ecu012 FROM ecu_file ",             #FUN-A50081 add ecu012
                " WHERE ",g_wc CLIPPED, " ORDER BY ecu01,ecu02,ecu012"  #FUN-A50081 add ecu012
   ELSE
     #LET g_sql="SELECT ecu01,ecu02",         #MOD-A40053 mark
      LET g_sql="SELECT UNIQUE ecu01,ecu02,ecu012",  #MOD-A40053   #FUN-A50081 add ecu012
                "  FROM ecu_file,ecb_file ",
                " WHERE ecu01=ecb01 AND ecu02=ecb02",
                "   AND ecu012 = ecb012",                  #FUN-A50081 add
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY ecu01,ecu02,ecu012"             #FUN-A50081 add ecu012
   END IF
   PREPARE i100_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE i100_cs SCROLL CURSOR WITH HOLD FOR i100_prepare
   IF g_wc2 = ' 1=1' THEN
     #LET g_sql= "SELECT COUNT(*) ",            #MOD-A40053 mark
      LET g_sql= "SELECT UNIQUE ecu01,ecu02,ecu012 ",  #MOD-A40053  #FUN-A50081 add ecu012
                 "FROM ecu_file ",
                 "WHERE ",g_wc CLIPPED,
                 " INTO TEMP x"    #MOD-A40053 add
   ELSE
     #LET g_sql= "SELECT COUNT(ecu01)",         #MOD-A40053 mark
      LET g_sql= "SELECT UNIQUE ecu01,ecu02,ecu012 ",  #MOD-A40053  #FUN-A50081 add ecu012
                 "FROM ecu_file,ecb_file ",
                 "WHERE ecu01=ecb01 AND ecu02=ecb02",
                 "  AND ecu012 = ecb012",               #FUN-A50081
                 "  AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " INTO TEMP x"    #MOD-A40053 add
   END IF
  #str MOD-A40053 add
   DROP TABLE x
   PREPARE i100_precount_x FROM g_sql
   EXECUTE i100_precount_x
   IF SQLCA.sqlcode THEN
      CALL cl_err('i100_precount_x',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_sql="SELECT COUNT(*) FROM x"
  #end MOD-A40053 add
   PREPARE i100_precount FROM g_sql
   DECLARE i100_count CURSOR FOR i100_precount

END FUNCTION

FUNCTION i100_menu()
DEFINE  l_msg          STRING    #FUN-A50100
#MOD-D10047 add begin-------------------------
DEFINE  l_node         om.DomNode,
        win            ui.Window,
        f              ui.Form
#MOD-D10047 add end---------------------------
   WHILE TRUE
      CALL i100_bp("G")

      LET g_count = 0           #FUN-A50081

      CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i100_a()
#FUN-B90117--Begin--
               IF NOT cl_null(g_ecu.ecu01) THEN
                  CALL i100_tree_fill_1(g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012)
               END IF
#FUN-B90117--END--
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i100_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i100_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i100_copy()                 #No.TQC-920031 add
#FUN-B90117--Begin--
               IF NOT cl_null(g_ecu.ecu01) THEN
                  CALL i100_tree_fill_1(g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012)
               END IF
#FUN-B90117--END--
            END IF
         WHEN "detail"
            IF g_sfb.sfb87 =  'N' OR cl_null(g_sfb.sfb87) THEN
               IF cl_chk_act_auth() THEN
                  CALL i100_b()
#FUN-B90117--Begin--
               IF NOT cl_null(g_ecu.ecu01) THEN
                  CALL i100_tree_fill_1(g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012)
               END IF
#FUN-B90117--END--
               END IF
            ELSE
               CALL cl_err('','aap-005',0)
            END IF
            #LET g_action_choice = ""  #FUN-D40030 mark
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "routing_details"
            IF NOT cl_null(g_ecu.ecu01) AND NOT cl_null(g_ecu.ecu02)
              #AND NOT cl_null(g_ecu.ecu012)                            #FUN-A50081 add  #MOD-B40227
               AND g_ecu.ecu012 IS NOT NULL                             #MOD-B40227
            THEN
               LET g_cmd = "aeci102_slk '",g_ecu.ecu01,"' '",g_ecu.ecu02,"' '",g_ecu.ecu012 clipped,"'"   #FUN-A50081 add ecu012
               CALL cl_cmdrun(g_cmd)
            END IF
         WHEN "resource_fm"
            LET g_cmd = "aeci110 '",g_ecu.ecu01,"' '",g_ecu.ecu02,"' '",g_ecu.ecu012 clipped,"'"  #FUN-A50081 add ecu012
            CALL cl_cmdrun(g_cmd)

#FUN-A50081 --begin--
        WHEN "chkbom"
          IF cl_chk_act_auth() THEN
              LET l_msg = "aecp110 '",g_ecu.ecu01,"' '",g_ecu.ecu02,"'"
              CALL cl_cmdrun_wait(l_msg)
          END IF
#FUN-A50081 --end--

         #FUN-AC0076 add --------------begin---------------
         #@WHEN "資源耗損"
         WHEN "haosun"
            IF cl_chk_act_auth() THEN
                LET l_msg = "aeci621 '1' '",g_ecu.ecu01,"'"
                CALL cl_cmdrun_wait(l_msg)
            END IF
         #FUN-AC0076 add ---------------end----------------

         #串apsi312
         WHEN "aps_related_data_aps_ecb"
            IF cl_chk_act_auth() THEN
                CALL i100_aps_ecb('Y') #TQC-8C0016 mod
            END IF

         #串apsi326   FUN-870012
         WHEN "aps_displace_vms"
              IF l_ac>0 THEN        #TQC-8A0069
                CALL i100_aps_vms()
              ELSE                  #TQC-8A0069
                CALL cl_err('',-400,0)  #TQC-8A0069
              END IF                    #TQC-8A0069
         #串apsi331  FUN-80096
         WHEN "aps_route_tools"
               IF l_ac>0 THEN
                  CALL i100_aps_vnm()
               ELSE                     #TQC-8A0069
                  CALL cl_err('',-400,0)#TQC-8A0069
               END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              #MOD-D10047 modify begin-------------------------------
              #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecb),'','')
              LET win = ui.Window.getCurrent()
              LET f = win.getForm()
              LET l_node = f.findNode("Table","s_ecb")
              CALL cl_export_to_excel(l_node,base.TypeInfo.create(g_ecb),'','')
              #MOD-D10047 modify end---------------------------------
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ecu.ecu01 IS NOT NULL THEN
                LET g_doc.column1 = "ecu01"
                LET g_doc.column2 = "ecu02"
                LET g_doc.column3 = "ecu012"        #FUN-A50081 add
                LET g_doc.value1 = g_ecu.ecu01
                LET g_doc.value2 = g_ecu.ecu02
                LET g_doc.value3 = g_ecu.ecu012     #FUN-A50081 add
                CALL cl_doc()
             END IF
          END IF

        WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL i100_confirm()
              CALL i100_show()
           END IF

        WHEN " notconfirm"
           IF cl_chk_act_auth() THEN
              CALL i100_notconfirm()
              CALL i100_show()
           END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i100_out()
            END IF

         WHEN "mntn_desc"
           #MOD-C90071---S---
            IF g_sma.sma541 = 'N' THEN
               LET g_ecu.ecu012 = ' '
            END IF
           #MOD-C90071---E---
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_ecu.ecu01) AND NOT cl_null(g_ecu.ecu02) AND g_ecu.ecu012 IS NOT NULL AND l_ac>0 THEN  #MOD-C90071
                 #AND NOT cl_null(g_ecu.ecu012)                      #FUN-A50081  #MOD-C90071 mark
                 #AND l_ac>0 THEN   #No.MOD-920375 add               #MOD-C90071 mark
                  LET g_cmd = "aeci101 '",g_ecu.ecu01,"' '",g_ecu.ecu02,"' '",g_ecb[l_ac].ecb03,"' '",g_ecu.ecu012 CLIPPED,"'"  #FUN-A50081 add ecu012
                      CALL cl_cmdrun(g_cmd)
               END IF    #No.MOD-920375 add
            END IF
         #CHI-C90006---begin
         WHEN "invalid"   
            IF cl_chk_act_auth() THEN
               CALL i100_x()
            END IF
         #CHI-C90006---end
      END CASE
   END WHILE
   CLOSE i100_cs
END FUNCTION

#FUN-A50081 --begin--
#FUNCTION i100_chkbom()
#DEFINE l_count       LIKE type_file.num5
#DEFINE l_cnt         LIKE type_file.num5
#DEFINE l_sql         STRING
#DEFINE l_ecu         RECORD LIKE ecu_file.*
#
#  LET l_count = 0
#
#  LET g_success = 'Y'
#
#  LET l_sql = "SELECT * FROM ecu_file WHERE ecu01 = '",g_ecu.ecu01,"'",
#              " AND ecu02 = '",g_ecu.ecu02,"'"
#  PREPARE i100_chkbom_pb FROM l_sql
#  DECLARE chkbom_curs CURSOR FOR i100_chkbom_pb
#
####no1.
#  FOREACH chkbom_curs INTO l_ecu.*
#     LET l_cnt = 0
#     SELECT COUNT(*) INTO l_cnt FROM ecu_file
#      WHERE ecu01  = l_ecu.ecu01
#        AND ecu02  = l_ecu.ecu02
#        AND ecu015 = l_ecu.ecu012
#        AND ecu015 IS NOT NULL
#
#     IF l_cnt > 1 THEN
#        CALL cl_err(l_ecu.ecu012,'aec-044',1)
#        LET g_success = 'N'
#        EXIT FOREACH
#     ELSE
#     	  IF l_cnt = 0 THEN
#     	     LET l_count = l_count + 1
#     	     IF l_count > 1 THEN
#     	        CALL cl_err('','aec-045',1)
#     	        LET g_success = 'N'
#     	        EXIT FOREACH
#     	     ELSE
#     	    	  CONTINUE FOREACH
#     	     END IF
#     	  END IF
#     END IF
#
#  END FOREACH
#
#IF g_success = 'Y' THEN
#  LET g_count = l_count
#  IF g_count = 0 THEN
#     LET g_success = 'N'
#     CALL cl_err(l_ecu.ecu012,'aec-047',1)
##    RETURN
#  END IF
#END IF
#
#END FUNCTION
#FUN-A50081 --end--

FUNCTION i100_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_ecb.clear()
    INITIALIZE g_ecu.* LIKE ecu_file.*
    LET g_ecu01_t = NULL
    LET g_ecu012_t = NULL      #FUN-A50081 add
    LET g_ecu.ecu01 = ' '      #No.MOD-940256 add
    IF g_sma.sma541 = 'N' OR cl_null(g_sma.sma541) THEN #TQC-AB0411
       LET g_ecu.ecu012 = ' '     #FUN-A50081 add
    END IF  #TQC-AB0411
    LET g_ecu.ecu04 = 0
    LET g_ecu.ecu05 = 0
    LET g_ecu.ecuacti = 'Y'
    LET g_ecu.ecu10 = 'N'                        #No.FUN-810017
    LET g_ecu.ecuuser = g_user
    LET g_ecu.ecugrup = g_grup
    LET g_ecu.ecuorig = g_grup  #TQC-B10209
    LET g_ecu.ecuoriu = g_user  #TQC-B10209
    LET g_ecu.ecudate = TODAY
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i100_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_ecb.clear()
            EXIT WHILE
        END IF
        IF cl_null(g_ecu.ecu01) THEN LET g_ecu.ecu01=' ' END IF
        IF cl_null(g_ecu.ecu012) THEN LET g_ecu.ecu012 = ' ' END IF    #FUN-A50081
        LET g_ecu.ecuoriu = g_user      #No.FUN-980030 10/01/04
        LET g_ecu.ecuorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO ecu_file VALUES(g_ecu.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","ecu_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1) #FUN-660091
           CONTINUE WHILE
        ELSE
           LET g_ecu_t.* = g_ecu.*               # 保存上筆資料
           SELECT ecu01,ecu02,ecu12 INTO g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012 FROM ecu_file  #FUN-A50081 add ecu012
                  WHERE ecu01 = g_ecu.ecu01 AND ecu02 = g_ecu.ecu02
                    AND ecu012 = g_ecu.ecu012           #FUN-A50081
        END IF

        CALL g_ecb.clear()
        LET g_rec_b = 0

        CALL i100_b()

        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i100_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入 #No.FUN-680073 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680073 SMALLINT
    DEFINE  l_cnt1      LIKE type_file.num5          #FUN-B20078
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    DISPLAY g_ecu.ecu10 TO FORMONLY.ecu10 #No.FUN-810017
    DISPLAY BY NAME g_ecu.ecuorig,g_ecu.ecuoriu  #TQC-B10209
    INPUT BY NAME
        g_ecu.ecu01, g_ecu.ecu02, g_ecu.ecu03,
        g_ecu.ecu012,g_ecu.ecu014,g_ecu.ecu015,  #FUN-A50081 add
        g_ecu.ecuuser,g_ecu.ecugrup,g_ecu.ecumodu,g_ecu.ecudate,g_ecu.ecuacti,
        g_ecu.ecuud01,g_ecu.ecuud02,g_ecu.ecuud03,g_ecu.ecuud04,
        g_ecu.ecuud05,g_ecu.ecuud06,g_ecu.ecuud07,g_ecu.ecuud08,
        g_ecu.ecuud09,g_ecu.ecuud10,g_ecu.ecuud11,g_ecu.ecuud12,
        g_ecu.ecuud13,g_ecu.ecuud14,g_ecu.ecuud15

        WITHOUT DEFAULTS

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i100_set_entry(p_cmd)
            CALL i100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE

        AFTER FIELD ecu01
           IF NOT cl_null(g_ecu.ecu01) THEN
            #FUN-AA0059 --------------------add start-------------
            IF NOT s_chk_item_no(g_ecu.ecu01,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ecu01
            END IF
            #FUN-AA0059 -------------------add end--------------
            IF p_cmd = 'a' THEN  #FUN-A50100
               CALL i100_ecu01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ecu.ecu01,g_errno,0)
                  NEXT FIELD ecu01
               END IF
           END IF    #FUN-A50100
#FUN-A50081 --begin--
            ELSE
               NEXT FIELD ecu01
#FUN-A50081 --end--
            END IF

        AFTER FIELD ecu02
#FUN-A50081 --begin--
#            IF NOT cl_null(g_ecu.ecu02) THEN
#               IF (g_ecu.ecu01 != g_ecu01_t) OR (g_ecu01_t IS NULL) THEN
#                   SELECT count(*) INTO g_cnt FROM ecu_file
#                    WHERE ecu01 = g_ecu.ecu01 AND ecu02 = g_ecu.ecu02
#                   IF g_cnt > 0 THEN                             # 資料重複
#                      CALL cl_err('','aec-009',0)
#                      LET g_ecu.ecu01 = g_ecu01_t
#                      DISPLAY BY NAME g_ecu.ecu01
#                      NEXT FIELD ecu01
#                   END IF
#               END IF
#            END IF
             IF cl_null(g_ecu.ecu02) THEN
                NEXT FIELD CURRENT
             END IF
#FUN-A50081 --end--

#FUN-A50081 --begin--
        AFTER FIELD ecu012
           #TQC-AB0411--begin--add--------
           #IF cl_null(g_ecu.ecu012) THEN
           #   LET g_ecu.ecu012 = ' '
           #END IF
            IF NOT cl_null(g_ecu.ecu012) THEN
           #TQC-AB0411--end--add-------
              IF (g_ecu.ecu01 != g_ecu01_t) OR (g_ecu.ecu012 != g_ecu012_t)
                 OR (g_ecu.ecu02 != g_ecu_t.ecu012) OR (g_ecu01_t IS NULL)
                 OR (g_ecu_t.ecu02 IS NULL) THEN
#FUN-B20078 ------------------Begin-------------------------
              #  IF (g_ecu.ecu012 != g_ecu012_t) OR (g_ecu_t.ecu02 IS NULL) THEN        #MOD-B30520
                 IF (g_ecu.ecu012 != g_ecu012_t) OR (g_ecu012_t IS NULL) THEN           #MOD-B30520
                    SELECT COUNT(*) INTO l_cnt1 FROM ecr_file
                     WHERE ecr01 = g_ecu.ecu012
                       AND ecracti = 'Y'
                    IF l_cnt1 < = 0 THEN
                       CALL cl_err(g_ecu.ecu012,'aec-050',0)
                       NEXT FIELD ecu012
                    END IF
                    CALL i100_ecu014(g_ecu.ecu012) RETURNING g_ecu.ecu014
                 END IF
                 DISPLAY g_ecu.ecu014 TO ecu014
#FUN-B20078 ------------------End---------------------------
                 SELECT COUNT(*) INTO g_cnt FROM ecu_file
                  WHERE ecu01  = g_ecu.ecu01
                    AND ecu02  = g_ecu.ecu02
                    AND ecu012 = g_ecu.ecu012
                 IF g_cnt > 0 THEN
                    CALL cl_err('','aec-009',0)
                    NEXT FIELD ecu012
                 END IF
              END IF
           END IF #TQC-AB0411

        AFTER FIELD ecu015
          IF NOT cl_null(g_ecu.ecu015) THEN
             LET g_cnt = 0
#FUN-B20078 ----------------------Begin-----------------------
#             SELECT COUNT(*) INTO g_cnt FROM ecu_file
#              WHERE ecu01   = g_ecu.ecu01
#                AND ecu02   = g_ecu.ecu02
#                AND ecu012  = g_ecu.ecu015
#                AND ecu012 != g_ecu.ecu012
             SELECT COUNT(*) INTO g_cnt FROM ecr_file
              WHERE ecr01 = g_ecu.ecu015
                AND ecracti = 'Y'
#FUN-B20078 ----------------------End--------------------------
             IF g_cnt = 0 THEN
             #  CALL cl_err('','aec-043',0)             #FUN-B20078
                CALL cl_err(g_ecu.ecu015,'aec-050',0)   #FUN-B20078
                NEXT FIELD CURRENT
             END IF
             CALL i100_ecu014(g_ecu.ecu015) RETURNING g_ecr02   #FUN-B20078
             DISPLAY g_ecr02 TO ecr02                           #FUN-B20078
          #TQC-B40078--add--str--
          ELSE
             LET g_ecr02 = ''
             DISPLAY g_ecr02 TO ecr02
          #TQC-B40078--add--end--
          END IF
#FUN-A50081 --end--

        AFTER FIELD ecuud01
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud02
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud03
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud04
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud05
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud06
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud07
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud08
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud09
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud10
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud11
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud12
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud13
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud14
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecuud15
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_ecu.ecuuser = s_get_data_owner("ecu_file") #FUN-C10039
           LET g_ecu.ecugrup = s_get_data_group("ecu_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
#FUN-A50081 --begin--
#FUN-B20078 ---------------------Begin----------------------
#           IF NOT cl_null(g_ecu.ecu015) THEN
#             LET g_cnt = 0
#             SELECT COUNT(*) INTO g_cnt FROM ecu_file
#              WHERE ecu01   = g_ecu.ecu01
#                AND ecu02   = g_ecu.ecu02
#                AND ecu012  = g_ecu.ecu015
#                AND ecu012 != g_ecu.ecu012
#             IF g_cnt = 0 THEN
#                CALL cl_err('','aec-043',0)
#                NEXT FIELD ecu015
#             END IF
#           END IF
#FUN-B20078 ---------------------End-------------------------
#FUN-A50081 --end--

        ON KEY(F1) NEXT FIELD ecu01
        ON KEY(F2) NEXT FIELD ecu04


        ON ACTION controlp
           CASE
              WHEN INFIELD(ecu01)
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form = "q_ima"
                #   LET g_qryparam.default1 = g_ecu.ecu01
                #   CALL cl_create_qry() RETURNING g_ecu.ecu01
                     CALL q_sel_ima(FALSE, "q_ima", "", g_ecu.ecu01, "", "", "", "" ,"",'' )  RETURNING g_ecu.ecu01
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_ecu.ecu01       #No.MOD-490371
                   NEXT FIELD ecu01
#FUN-B20078 ------------------------Begin--------------------------
              WHEN INFIELD(ecu012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecr"
                   LET g_qryparam.default1 = g_ecu.ecu012
                   CALL cl_create_qry() RETURNING g_ecu.ecu012
                   DISPLAY BY NAME g_ecu.ecu012
                   NEXT FIELD ecu012
#FUN-B20078 ------------------------End----------------------------
#FUN-A60028 --begin--
              WHEN INFIELD(ecu015)
                   CALL cl_init_qry_var()
              #    LET g_qryparam.form = "q_ecu015_1"        #FUN-B20078
                   LET g_qryparam.form = "q_ecr"             #FUN-B20078
                   LET g_qryparam.default1 = g_ecu.ecu015
              #    LET g_qryparam.arg1     = g_ecu.ecu01     #FUN-B20078
              #    LET g_qryparam.arg2     = g_ecu.ecu02     #FUN-B20078
                   CALL cl_create_qry() RETURNING g_ecu.ecu015
                   DISPLAY BY NAME g_ecu.ecu015
                   NEXT FIELD ecu015
#FUN-A60028 --end--
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

FUNCTION i100_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680073 VARCHAR(01)

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ecu01,ecu02,ecu012",TRUE)   #FUN-A50081 add ecu012
    END IF

END FUNCTION

FUNCTION i100_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680073 VARCHAR(01)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ecu01,ecu02,ecu012",FALSE)       #FUN-A50081 add ecu012
    END IF

END FUNCTION
#FUN-B20078 ------------------------------Begin-------------------------------
FUNCTION i100_ecu014(p_ecr01)
DEFINE   p_ecr01     LIKE ecr_file.ecr01
DEFINE   l_ecr02     LIKE ecr_file.ecr02
   DECLARE i100_ecu014_curs CURSOR FOR
    SELECT DISTINCT ecu014 INTO l_ecr02 FROM ecu_file
     WHERE ecu01 = g_ecu.ecu01
       AND ecu012 = p_ecr01
   FOREACH i100_ecu014_curs INTO l_ecr02
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
#MOD-B30427 -------------------Begin-------------------
#       IF SQLCA.sqlcode THEN
#          CALL cl_err(p_ecr01,SQLCA.sqlcode,0)
#       END IF
#MOD-B30427 -------------------End---------------------
    END IF
    RETURN l_ecr02
END FUNCTION
#FUN-B20078 ------------------------------End---------------------------------

FUNCTION i100_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ecu.* TO NULL              #FUN-6A0039
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i100_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_ecb.clear()
        RETURN
    END IF

    MESSAGE " SEARCHING ! "
    OPEN i100_count
    FETCH i100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt

    OPEN i100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecu.ecu01,SQLCA.sqlcode,0)
        INITIALIZE g_ecu.* TO NULL
    ELSE
        CALL i100_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION i100_copy()
    DEFINE new_no,old_no   LIKE ecu_file.ecu01,
           oecu02,necu02   LIKE ecu_file.ecu02,
           oecu012,necu012 LIKE ecu_file.ecu012,        #FUN-A50081 add
           ef_date         LIKE type_file.dat,          #No.FUN-680073 DATE
           ans_1           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
           ans_2,l_sdate   LIKE type_file.dat,          #No.FUN-680073 DATE
           l_cnt           LIKE ecu_file.ecu02,         #No.FUN-680073 DECIMAL(4,0)
           l_dir           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
           l_sql           LIKE type_file.chr1000,       #No.FUN-680073 VARCHAR(400)
           l_ecu014        LIKE ecu_file.ecu014         #TQC-B60169


   IF s_shut(0) THEN RETURN END IF
   OPEN WINDOW i100_c_w AT 06,15 WITH FORM "aec/42f/aeci100_c"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_locale("aeci100_c")
  #TQC-AC0231 --------add start---------
   IF g_sma.sma541 = 'N' THEN
      CALL cl_set_comp_visible("oecu012,necu012",FALSE)
   END IF
  #TQC-AC0207 --------add end-------------

   LET old_no = g_ecu.ecu01   #LET ans_2  = g_ecu.ecu04
   LET new_no = NULL          #LET ans_1  = '1'
   LET oecu02 = g_ecu.ecu02
   LET necu02 = NULL          #LET ef_date= NULL
   LET oecu012 = g_ecu.ecu012  #FUN-A50081
   LET necu012 = NULL          #FUN-A50081
   LET g_before_input_done = FALSE   #FUN-580024
   CALL i100_set_entry('a')          #FUN-580024
   LET g_before_input_done = TRUE    #FUN-580024
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
   INPUT BY NAME  old_no,oecu02,oecu012,new_no,necu02,necu012       #FUN-A50081 add oecu012 necu012
               WITHOUT DEFAULTS
      AFTER FIELD old_no
        IF old_no IS NULL THEN NEXT FIELD old_no END IF
      AFTER FIELD oecu02
        IF oecu02 IS NULL THEN NEXT FIELD oecu02 END IF
#FUN-A50081 --begin--
      AFTER FIELD oecu012
        IF oecu012 IS NULL THEN LET oecu012 = ' ' END IF
#FUN-A50081 --end--
        SELECT count(*) INTO l_cnt FROM ecu_file
               WHERE ecu01  = old_no
                 AND ecu02  = oecu02
                 AND ecu012 = oecu012   #FUN-A50081 add
        IF l_cnt=0 THEN CALL cl_err('','aec-018',0) NEXT FIELD old_no  #FUN-A50081 aec-014->aec-018
        END IF
      AFTER FIELD new_no
        IF new_no IS NULL THEN NEXT FIELD new_no END IF
           CALL i100_newno(new_no)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(new_no,g_errno,0) NEXT FIELD new_no
           END IF

      BEFORE FIELD necu02
        LET necu02 = "   "

      AFTER FIELD necu02
        IF necu02 IS NULL THEN NEXT FIELD necu02 END IF
#FUN-A50081 --begin--
     AFTER FIELD necu012
        IF necu012 IS NULL THEN LET necu012 = ' ' END IF
#FUN-A50081 --end--
        SELECT COUNT(*) INTO l_cnt FROM ecu_file
               WHERE ecu01 = new_no
                 AND ecu02 = necu02
                 AND ecu012 = necu012   #FUN-A50081
        IF l_cnt>0 THEN
           CALL cl_err('','aec-009',0) NEXT FIELD new_no END IF  #FUN-A50081 aec-014->aec-009
        SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = new_no
        IF l_cnt=0 THEN
           CALL cl_err('','asf-399',0) NEXT FIELD new_no END IF
        #TQC-B60169-add-str--
        IF NOT cl_null(necu012) THEN
           LET l_cnt =0
           SELECT COUNT(*) INTO l_cnt FROM ecr_file
              WHERE ecr01 = necu012  AND ecracti='Y'
           IF l_cnt<1 THEN
              CALL cl_err('','aec-050',0)
              NEXT FIELD necu012
           ELSE
              SELECT ecr02 INTO l_ecu014 FROM ecr_file WHERE ecr01=necu012
           END IF
        END IF
        #TQC-B60169-add-end--



       AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          IF new_no IS NULL THEN NEXT FIELD new_no END IF
#FUN-A50081 --begin--
    #     IF necu02 IS NULL THEN NEXT FIELD necu02 END IF
          IF cl_null(necu02) THEN NEXT FIELD necu02 END IF
          IF necu012 IS NULL THEN NEXT FIELD necu012 END IF
          SELECT COUNT(*) INTO l_cnt FROM ecu_file
           WHERE ecu01 = new_no
             AND ecu02 = necu02
             AND ecu012 = necu012
          IF l_cnt>0 THEN
             CALL cl_err('','aec-009',0)
             NEXT FIELD necu012
          END IF
#FUN-A50081

        ON ACTION controlp
           CASE
              WHEN INFIELD(new_no)
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form = "q_ima"
                #   LET g_qryparam.default1 = new_no
                #   CALL cl_create_qry() RETURNING new_no
                    CALL q_sel_ima(FALSE, "q_ima", "",new_no, "", "", "", "" ,"",'' )  RETURNING new_no
#FUN-AA0059 --End--
                   DISPLAY BY NAME new_no
                   NEXT FIELD new_no
              OTHERWISE EXIT CASE
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
   CLOSE WINDOW i100_c_w

   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF

   MESSAGE ' COPY.... '

   BEGIN WORK

   OPEN i100_cl USING g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012   #FUN-A50081 add ecu012
   IF STATUS THEN
      CALL cl_err("OPEN i100_cl:", STATUS, 1)
      CLOSE i100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i100_cl INTO g_ecu.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err('lock ecu:',SQLCA.sqlcode,0)
       CLOSE i100_cl ROLLBACK WORK RETURN
   END IF
   DROP TABLE ecu_tmp
   SELECT * FROM ecu_file WHERE ecu01 = old_no
                            AND ecu02 = oecu02
                            AND ecu012 = oecu012         #FUN-A50081 add
     INTO TEMP ecu_tmp
   UPDATE ecu_tmp
       SET ecu01=new_no,       #新產品料號
           ecu02=necu02,       #新產品製程編號
           ecu012 = necu012,   #FUN-A50081 add
          #ecu014=NULL,        #工艺段说明 TQC-B50100 add   #TQC-B60169 mark
           ecu014=l_ecu014,    #TQC-B60169
           ecu015=NULL,        #下工艺段 TQC-B50100 add
           ecu10='N',          #No.FUN-870124
           ecu11=NULL,         #No.FUN-870124
           ecuacti="Y",        #資料有效碼
           ecuuser=g_user,     #資料所有者
           ecugrup=g_grup,     #資料所有者所屬群
           ecuoriu=g_user,     #TQC-B50106 add
           ecuorig=g_grup,     #TQC-B50106 add
           ecumodu=NULL,       #資料修改者
           ecudate=g_today     #資料修改日期
   INSERT INTO ecu_file SELECT * FROM ecu_tmp
   IF STATUS THEN
   CALL cl_err3("ins","ecu_file",new_no,necu02,STATUS,"","ins ecu",1) #FUN-660091
   RETURN END IF
   DROP TABLE ecb_tmp
   LET l_sql = " SELECT * FROM ecb_file ",
               " WHERE ecb01= '",old_no,"' ",
               "   AND ecb02='",oecu02,"'"
               ,"   and ecb012 = '",oecu012,"'"      #FUN-A50081
   LET l_sql = l_sql clipped," INTO TEMP ecb_tmp "
   PREPARE i300_pecb FROM l_sql
   EXECUTE i300_pecb
   IF STATUS THEN CALL cl_err('sel ecb',STATUS,0) RETURN END IF

   UPDATE ecb_tmp  SET ecb01=new_no,
                       ecb02=necu02
                      ,ecb012 =necu012  #FUN-A50081
   INSERT INTO ecb_file SELECT * FROM ecb_tmp
   IF STATUS THEN
   CALL cl_err3("ins","ecb_file",new_no,necu02,STATUS,"","ins ecb",1) #FUN-660091
   RETURN END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
   DROP TABLE sgc_tmp
   LET l_sql = " SELECT * FROM sgc_file ",
               " WHERE sgc01= '",old_no,"' ",
               "   AND sgc02='",oecu02,"'"
              ,"   AND sgc012 = '",oecu012,"'"   #FUN-A50081
   LET l_sql = l_sql clipped," INTO TEMP sgc_tmp "
   PREPARE i300_psgc FROM l_sql
   EXECUTE i300_psgc
   IF STATUS THEN CALL cl_err('sel sgc',STATUS,0) RETURN END IF

   UPDATE sgc_tmp  SET sgc01=new_no,
                       sgc02=necu02
                      ,sgc012 = necu012   #FUN-A50081
   INSERT INTO sgc_file SELECT * FROM sgc_tmp
   IF STATUS THEN
   CALL cl_err3("ins","sgc_file",new_no,necu02,STATUS,"","ins sgc",1) #FUN-660091
   RETURN END IF
   #FUN-C30027---begin
   SELECT * 
     INTO g_ecu.*
     FROM ecu_file 
    WHERE ecu01 = new_no
      AND ecu02 = necu02
      AND ecu012 = necu012
   CALL i100_show()
   #FUN-C30027---end
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'

   COMMIT WORK

   #FUN-8A0088 與APS連結時,需同時複製APS相關資料
   IF NOT cl_null(g_sma.sma901) AND (g_sma.sma901='Y')  THEN   #TQC-8A0076

      #複製APS途程製程
      INSERT INTO vmn_file(vmn01,vmn02,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,vmn19)
         SELECT new_no,necu02,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,vmn19
           FROM vmn_file
           WHERE vmn01 = old_no AND vmn02=oecu02

      #複製APS途程製程指定工模具
      INSERT INTO vnm_file(vnm00,vnm01,vnm02,vnm03,vnm04,vnm05,vnm06)
         SELECT new_no,necu02,vnm02,vnm03,vnm04,vnm05,vnm06
           FROM vnm_file
           WHERE vnm00=old_no AND vnm01=oecu02

      #複製APS替代作業
      INSERT INTO vms_file(vms01,vms02,vms03,vms04,vms05,vms06,vms07,vms08,vms09,vms10,vms11,vms12,vms13)
         SELECT new_no,necu02,vms03,vms04,vms05,vms06,vms07,vms08,vms09,vms10,vms11,vms12,vms13
           FROM vms_file
           WHERE vms01=old_no AND vms02=oecu02
   END IF



END FUNCTION

FUNCTION i100_newno(p_newno)  #料件編號
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_imaacti LIKE ima_file.imaacti,
           p_newno   LIKE ima_file.ima01

  LET g_errno = " "
  SELECT ima02,ima021,imaacti,ima55
         INTO l_ima02,l_ima021,l_imaacti,g_ima55 FROM ima_file
         WHERE ima01 = p_newno

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL  LET l_imaacti = NULL
                                 LET l_ima021=NULl
       WHEN l_imaacti='N'        LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION

FUNCTION i100_fetch(p_flecu)
    DEFINE
        p_flecu         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)

    CASE p_flecu
        WHEN 'N' FETCH NEXT     i100_cs INTO g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012     #FUN-A50081 add ecu012
        WHEN 'P' FETCH PREVIOUS i100_cs INTO g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012     #FUN-A50081 add ecu012
        WHEN 'F' FETCH FIRST    i100_cs INTO g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012     #FUN-A50081 add ecu012
        WHEN 'L' FETCH LAST     i100_cs INTO g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012     #FUN-A50081 add ecu012
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
            FETCH ABSOLUTE g_jump i100_cs INTO g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012     #FUN-A50081 add ecu012
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecu.ecu01,SQLCA.sqlcode,0)
        INITIALIZE g_ecu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flecu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_ecu.* FROM ecu_file       # 重讀DB,因TEMP有不被更新特性
       WHERE ecu01 = g_ecu.ecu01
         AND ecu02 = g_ecu.ecu02
         AND ecu012 = g_ecu.ecu012        #FUN-A50081
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ecu_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1) #FUN-660091
    ELSE
        LET g_data_owner = g_ecu.ecuuser      #FUN-4C0034
        LET g_data_group = g_ecu.ecugrup      #FUN-4C0034
        CALL i100_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i100_show()
    LET g_ecu_t.* = g_ecu.*
    DISPLAY BY NAME
        g_ecu.ecu01, g_ecu.ecu02, g_ecu.ecu03, g_ecu.ecu04, g_ecu.ecu05,g_ecu.ecu11, #No.FUN-810017
        g_ecu.ecu012,g_ecu.ecu014,g_ecu.ecu015,           #FUN-A50081
        g_ecu.ecuoriu,g_ecu.ecuorig,        #TQC-B50106 add
        g_ecu.ecuuser,g_ecu.ecugrup,g_ecu.ecumodu,g_ecu.ecudate,g_ecu.ecuacti
       ,g_ecu.ecuud01,g_ecu.ecuud02,g_ecu.ecuud03,g_ecu.ecuud04,
        g_ecu.ecuud05,g_ecu.ecuud06,g_ecu.ecuud07,g_ecu.ecuud08,
        g_ecu.ecuud09,g_ecu.ecuud10,g_ecu.ecuud11,g_ecu.ecuud12,
        g_ecu.ecuud13,g_ecu.ecuud14,g_ecu.ecuud15

    DISPLAY g_ecu.ecu10 TO FORMONLY.ecu10                  #No.FUN-810017
    CALL i100_ecu014(g_ecu.ecu015) RETURNING g_ecr02       #FUN-B20078
    DISPLAY g_ecr02 TO ecr02                               #FUN-B20078
    INITIALIZE g_ima.* TO NULL
    SELECT ima02,ima021 INTO l_ima02,l_ima021
     FROM ima_file
     WHERE ima01 = g_ecu.ecu01
     DISPLAY l_ima02 TO FORMONLY.ima02
     DISPLAY l_ima021 TO FORMONLY.ima021

#FUN-B90117-Begin
    IF cl_null(g_wc2) THEN
      LET g_wc2 = " 1=1"
    END IF
#FUN-B90117--end

    CALL i100_b_fill(g_wc2)
    CALL i100_b_total('d')

    CALL i100_tree_fill_1(g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012)       #FUN-B90117

    CALL i100_show_pic()                      #No.FUN-810017
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION i100_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ecu.ecu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ecu.ecu10 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    #CHI-C90006---begin
    IF g_ecu.ecuacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    #CHI-C90006---end
    MESSAGE ""
    CALL cl_opmsg('u')

    BEGIN WORK

    OPEN i100_cl USING g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012    #FUN-A50081 add ecu012
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i100_cl INTO g_ecu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock ecu:',SQLCA.sqlcode,0)
        CLOSE i100_cl ROLLBACK WORK RETURN
    END IF

    LET g_ecu01_t = g_ecu.ecu01
    LET g_ecu02_t = g_ecu.ecu02
    LET g_ecu012_t = g_ecu.ecu012   #FUN-A50081 add
    LET g_ecu_o.*=g_ecu.*
    LET g_ecu.ecumodu = g_user
    LET g_ecu.ecudate = g_today               #修改日期
    CALL i100_show()                          # 顯示最新資料

    WHILE TRUE
        CALL i100_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ecu.*=g_ecu_t.*
            CALL i100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ecu.ecu01 IS NULL OR g_ecu.ecu02 IS NULL THEN
           LET g_ecu.ecu01 = ' '
        END IF
        IF g_ecu.ecu012 IS NULL THEN LET g_ecu.ecu012 = ' ' END IF   #FUN-A50081
        UPDATE ecu_file SET ecu_file.* = g_ecu.*    # 更新DB
            WHERE ecu01 = g_ecu01_t AND ecu02 = g_ecu02_t             # COLAUTH?
              AND ecu012 = g_ecu012_t     #FUN-A50081
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ecu_file",g_ecu01_t,g_ecu02_t,SQLCA.sqlcode,"","",1) #FUN-660091
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION

FUNCTION i100_r()
    DEFINE l_chr      LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
           l_cnt      LIKE type_file.num5         #No.FUN-680073 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ecu.ecu01) AND cl_null(g_ecu.ecu02) AND cl_null(g_ecu.ecu012) THEN #FUN-A50081 add ecu012
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_ecu.ecu10 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    #CHI-C90006---begin
    IF g_ecu.ecuacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    #CHI-C90006---end
    
    BEGIN WORK

    OPEN i100_cl USING g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012   #FUN-A50081
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i100_cl INTO g_ecu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ecu:',SQLCA.sqlcode,0)
       CLOSE i100_cl ROLLBACK WORK RETURN
    END IF

    CALL i100_show()

    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ecu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ecu02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "ecu012"        #FUN-A50081
        LET g_doc.value1 = g_ecu.ecu01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ecu.ecu02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_ecu.ecu012     #FUN-A50081
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24

        IF cl_null(g_ecu.ecu02) THEN LET g_ecu.ecu02 = ' ' END IF       #FUN-A50081

        DELETE FROM ecu_file WHERE ecu01 = g_ecu.ecu01 AND ecu02 = g_ecu.ecu02
   #FUN-A50081 --begin--
                               AND ecu012 = g_ecu.ecu012
       #DELETE FROM x WHERE ecu01  = g_ecu.ecu01    #TQC-AC0245
       #                AND ecu02  = g_ecu.ecu02    #TQC-AC0245
       #                AND ecu012 = g_ecu.ecu012   #TQC-AC0245
    #FUN-A50081  --end--
        IF STATUS THEN
        CALL cl_err3("del","ecu_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","del ecu:",1) #FUN-660091
        RETURN END IF

        DELETE FROM ecb_file WHERE ecb01 = g_ecu.ecu01 AND ecb02 = g_ecu.ecu02
                               AND ecb012 = g_ecu.ecu012       #FUN-A50081
        IF STATUS THEN
        CALL cl_err3("del","ecb_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","del ecb:",1) #FUN-660091
        RETURN END IF

         DELETE FROM vms_file WHERE vms01 = g_ecu.ecu01 AND vms02 = g_ecu.ecu02
            IF STATUS THEN
            CALL cl_err3("del","vms_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","del vms:",1)
            RETURN END IF
         DELETE FROM vmn_file WHERE vmn01 = g_ecu.ecu01 AND vmn02 = g_ecu.ecu02
            IF STATUS THEN
            CALL cl_err3("del","vmn_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","del vmn:",1)
            RETURN END IF
         DELETE FROM vnm_file WHERE vnm00 = g_ecu.ecu01 AND vnm01 = g_ecu.ecu02
            IF STATUS THEN
            CALL cl_err3("del","vmn_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","del ecb:",1)
            RETURN END IF


        DELETE FROM sgc_file WHERE sgc01 = g_ecu.ecu01 AND sgc02 = g_ecu.ecu02
                               AND sgc012 = g_ecu.ecu012  #FUN-A50081
        IF STATUS THEN
        CALL cl_err3("del","sgc_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","del sgc:",1) #FUN-660091
        RETURN END IF

        DELETE FROM eco_file WHERE eco01 = g_ecu.ecu01 AND eco02 = g_ecu.ecu02
                               AND eco012 = g_ecu.ecu012        #FUN-A50081
        IF STATUS THEN
        CALL cl_err3("del","eco_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","del eco:",1) #FUN-660091
        RETURN END IF

        DELETE FROM ecbb_file WHERE ecbb01 = g_ecu.ecu01 AND ecbb02 = g_ecu.ecu02 #NO:4736
                                AND ecbb012 = g_ecu.ecu012           #FUN-A50081
        IF STATUS THEN
        CALL cl_err3("del","ecbb_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","del eco:",1) #FUN-660091
        RETURN END IF


        INITIALIZE g_ecu.* TO NULL
        CLEAR FORM
        CALL g_ecb.clear()
        DROP TABLE x       #MOD-B30520 add
        OPEN i100_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE i100_cl
           CLOSE i100_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH i100_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i100_cl
           CLOSE i100_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        IF g_row_count > 0 THEN  #TQC-AC0245
           LET g_row_count = g_row_count - 1 #TQC-AC0245
        END IF #TQC-AC0245
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
    CLOSE i100_cl
    COMMIT WORK

END FUNCTION

FUNCTION i100_confirm()
DEFINE l_msg              STRING #FUN-A50100
 
    LET g_action_choice=NULL  #TQC-BC0168
    IF cl_null(g_ecu.ecu01) OR g_ecu.ecu02 IS NULL OR g_ecu.ecu012 IS NULL THEN    #FUN-A50081 add ecu012
       CALL cl_err('',-400,0)
       RETURN
    END IF
#CHI-C30107 --------- add --------- begin
    IF g_ecu.ecu10="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_ecu.ecuacti="N" THEN
       CALL cl_err("",'aim-153',1)
       RETURN                        #No.FUN-840036
    ELSE
        IF NOT cl_confirm('aap-222') THEN 
           RETURN 
        END IF
    END IF
#CHI-C30107 --------- add --------- end
    IF g_ecu.ecu10="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF

 IF g_sma.sma541 = 'Y' THEN       #FUN-A60028
#FUN-A50081 --begin--
    LET g_confirm_p110 = 'Y'
    CALL p110_sub()
    LET g_confirm_p110 = 'N'
    IF g_success = 'N' THEN
       RETURN
#    ELSE                               #FUN-A50100
#    	 CALL cl_err('','aec-046',1)    #FUN-A50100
    END IF
#FUN-A50081 --end--
 END IF                           #FUN-A60028

    IF g_ecu.ecuacti="N" THEN
       CALL cl_err("",'aim-153',1)
       RETURN                        #No.FUN-840036
    ELSE
#       IF cl_confirm('aap-222') THEN  #CHI-C30107 mark
            BEGIN WORK
            UPDATE ecu_file
            SET ecu10="Y",ecudate = g_today     #FUN-D10063 add ecudate = g_today
            WHERE ecu01=g_ecu.ecu01
              AND ecu02=g_ecu.ecu02
               AND ecu012 = g_ecu.ecu012   #FUN-A50081
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ecu_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","ecu10",1)
            ROLLBACK WORK
        ELSE
            COMMIT WORK
            LET g_ecu.ecu10="Y"
            DISPLAY g_ecu.ecu10 TO FORMONLY.ecu10
        END IF
#       END IF  #CHI-C30107 mark
    END IF
END FUNCTION

FUNCTION i100_notconfirm()
    IF cl_null(g_ecu.ecu01) OR g_ecu.ecu02 IS NULL AND g_ecu.ecu012 IS NULL THEN  #FUN-A50081 add ecu012
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_ecu.ecu11 >= 1 THEN
       CALL cl_err('','aec-128',0)
       RETURN
    END IF
    IF g_ecu.ecu10="N" OR g_ecu.ecuacti="N" THEN
        CALL cl_err("",'atm-365',1)
        RETURN
    ELSE
        IF cl_confirm('aap-224') THEN
         BEGIN WORK
         UPDATE ecu_file
           SET ecu10="N",ecudate = g_today     #FUN-D10063 add ecudate = g_today
         WHERE ecu01=g_ecu.ecu01
           AND ecu02=g_ecu.ecu02
           AND ecu012 = g_ecu.ecu012   #FUN-A50081 add
        IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","ecu_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","ecu10",1)
          ROLLBACK WORK
        ELSE
          COMMIT WORK
          LET g_ecu.ecu10="N"
          DISPLAY g_ecu.ecu10 TO FORMONLY.ecu10
        END IF
        END IF
    END IF
END FUNCTION

FUNCTION i100_show_pic()
      CALL cl_set_field_pic1(g_ecu.ecu10,"","","","",g_ecu.ecuacti,"","")
END FUNCTION

FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY #No.FUN-680073 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重復用    #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否    #No.FUN-680073 VARCHAR(1)
    l_sw_aps        LIKE type_file.num5,         #No.FUN-9A0047 add
    p_cmd           LIKE type_file.chr1,         #處理狀態      #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否      #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5         #可刪除否      #No.FUN-680073 SMALLINT

DEFINE  l_cnt       LIKE type_file.num5          #No.TQC-8C0016
DEFINE  l_ecb06      LIKE ecb_file.ecb06         #TQC-940179 ADD
DEFINE  l_ecb03      LIKE ecb_file.ecb03         #TQC-940179 ADD
DEFINE  l_ecu01      LIKE ecu_file.ecu01         #TQC-940179 ADD
DEFINE  l_ecu02      LIKE ecu_file.ecu02         #TQC-940179 ADD
DEFINE  l_cnt_vmn    LIKE type_file.num5         #FUN-A40060 add
DEFINE  l_cnt_vms    LIKE type_file.num5         #FUN-A40060 add
DEFINE  l_cnt_vnm    LIKE type_file.num5         #FUN-A40060 add
DEFINE  l_fac        LIKE type_file.num26_10     #MOD-D20118
DEFINE  l_ima55      LIKE ima_file.ima55         #MOD-D20118

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_ecu.ecu01 IS NULL THEN RETURN END IF
    IF cl_null(g_ecu.ecu02) THEN RETURN END IF
    IF g_ecu.ecu012 IS NULL THEN RETURN END IF   #FUN-A50081 add
    IF g_ecu.ecu10='Y' THEN RETURN END IF   #No.FUN-810017
    IF g_ecu.ecuacti='N' THEN RETURN END IF  #CHI-C90006

    CALL cl_opmsg('b')

    LET g_forupd_sql =
        "SELECT ecb03,ecb06,ecb17,ecb08,' ','',ecb07,'',ecb38,ecb04,ecb19,ecb18,",
        "       ecb21,ecb20,ecbslk05,ecbslk04,ecbslk02,ecbslk01,ecb66,ecb39,ecb25,ecb40,ecb41,",      #No.FUN-810017  #FUN-A80150 add ecb66 #NO.TQC-BC0166 add ecbslk01 #CHI-C70033 acb25
#       "       ecb42,ecb43,ecb44,ecb45,ecb46,ecb48,ecb49",                      #No.FUN-810017 #FUN-960056  #FUN-A50081
        #"       ecb42,ecb43,ecb45,ecb46,ecb51,ecb14,ecb52,ecb53,ecb48,ecb49",                      #FUN-A50081 #CHI-C70033
        "       ecb42,ecb43,ecb45,ecb46,ecb51,ecb14,ecb52,ecb53,ecb48",  #CHI-C70033
        " FROM ecb_file ",
        "WHERE ecb01= ? AND ecb02= ? AND ecb03= ? and ecb012 = ? FOR UPDATE"   #FUN-A50081 add ecb012

    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_ecb WITHOUT DEFAULTS FROM s_ecb.*
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

            OPEN i100_cl USING g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012   #FUN-A50081 add ecu012
            IF STATUS THEN
               CALL cl_err("OPEN i100_cl_b:", STATUS, 1)
               CLOSE i100_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i100_cl INTO g_ecu.*               # 對DB鎖定
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock ecu:',SQLCA.sqlcode,0)
                  CLOSE i100_cl ROLLBACK WORK RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN

                LET p_cmd='u'
                LET g_ecb_t.* = g_ecb[l_ac].*  #BACKUP
                LET g_ecb45_t = g_ecb[l_ac].ecb45   #FUN-BB0083

                OPEN i100_bcl USING g_ecu.ecu01,g_ecu.ecu02,g_ecb_t.ecb03,g_ecu.ecu012  #FUN-A50081 add ecu012
                IF STATUS THEN
                   CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i100_bcl INTO g_ecb[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ecb_t.ecb03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL i100_ecb08('d')
                END IF
                SELECT vmn08,vmn081
                  INTO g_ecb[l_ac].vmn08,g_ecb[l_ac].vmn081
                  FROM vmn_file
                 WHERE vmn01 = g_ecu.ecu01
                   AND vmn02 = g_ecu.ecu02
                   AND vmn03 = g_ecb[l_ac].ecb03
                   AND vmn04 = g_ecb[l_ac].ecb06
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ecb[l_ac].* TO NULL      #900423
            LET g_ecb[l_ac].ecb18 = 0
            LET g_ecb[l_ac].ecb19 = 0
            LET g_ecb[l_ac].ecb20 = 0
            LET g_ecb[l_ac].ecb21 = 0
            LET g_ecb[l_ac].ecb38 = 0
            LET g_ecb[l_ac].ecbslk02 = 0  #No.FUN-870124
            LET g_ecb[l_ac].ecbslk01 = 'N' #NO.TQC-BC0166 add
            LET g_ecb[l_ac].ecb04 = 0
            LET g_ecb[l_ac].ecb66 = 'Y'   #FUN-A80150 add
            LET g_ecb[l_ac].ecb39 = 'N'#BugNo:6420
            LET g_ecb[l_ac].ecb40 = 'N'
            LET g_ecb[l_ac].ecb41 = 'N'
#           LET g_ecb[l_ac].ecb44 = g_ima55  #FUN-A50081
            LET g_ecb[l_ac].ecb45 = g_ima55
            LET g_ecb[l_ac].ecb46 = 1
#FUN-A50081 --begin--
            LET g_ecb[l_ac].ecb51 = 1
            LET g_ecb[l_ac].ecb14 = 0
            LET g_ecb[l_ac].ecb52 = 0
            LET g_ecb[l_ac].ecb53 = 1
#FUN-A50081 --end--
            LET g_ecb45_t = NULL        #FUN-BB0083
            LET g_ecb_t.* = g_ecb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ecb03

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           #FUN-9A0047---mark---str---
           #IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
           #    IF cl_null(g_ecb[l_ac].ecb07) AND cl_null(g_ecb[l_ac].vmn08) THEN
           #        #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
           #        CALL cl_err('','aps-033',1)
           #        LET g_ecb[l_ac].* = g_ecb_t.*
           #        CANCEL INSERT
           #    END IF
           #END IF
           #FUN-9A0047---mark---end---
            INSERT INTO ecb_file(ecb01,ecb02,ecb03,ecb06,ecb17,
                                 ecbslk05,ecbslk04,ecbslk02,                 #No.FUN-810017
                                 ecbslk01,                                   #NO.TQC-BC0166 add ecbslk01
                                 ecb66,ecb39,ecb40,ecb41,ecb07,ecb08,ecb18,     #FUN-A80150 add ecb66
                                 ecb19,ecb38,ecb04,ecb21,ecb20,ecb42,ecb43,
#                                ecb44,ecb45,ecb46,  #FUN-A50081
                                       ecb45,ecb46,  #FUN-A50081
                                 ecb14,ecb51,ecb52,ecb53,       #FUN-A50081
                                 #ecb48,ecb49,       #FUN-960056 #CHI-C70033
                                 ecb48,ecb25,  #CHI-C70033
                                 ecbacti,ecbdate,   #TQC-8C0016 add ecbdate
                                 ecbud01,ecbud02,ecbud03,
                                 ecbud04,ecbud05,ecbud06,
                                 ecbud07,ecbud08,ecbud09,
                                 ecbud10,ecbud11,ecbud12,
                                 ecbud13,ecbud14,ecbud15,ecb012)   #FUN-A50081 add ecb012
                          VALUES(g_ecu.ecu01,g_ecu.ecu02,g_ecb[l_ac].ecb03,
                                 g_ecb[l_ac].ecb06,g_ecb[l_ac].ecb17,
                                 g_ecb[l_ac].ecbslk05,g_ecb[l_ac].ecbslk04, #No.FUN-810017
                                 g_ecb[l_ac].ecbslk02,                      #No.FUN-810017
                                 g_ecb[l_ac].ecbslk01,                      #NO.TQC-BC0166 add 
                                 g_ecb[l_ac].ecb66,g_ecb[l_ac].ecb39,g_ecb[l_ac].ecb40,   #FUN-A80150 add ecb66
                                 g_ecb[l_ac].ecb41,
                                 g_ecb[l_ac].ecb07,g_ecb[l_ac].ecb08,
                                 g_ecb[l_ac].ecb18,g_ecb[l_ac].ecb19,
                                 g_ecb[l_ac].ecb38,g_ecb[l_ac].ecb04,
                                 g_ecb[l_ac].ecb21,g_ecb[l_ac].ecb20,
                                 g_ecb[l_ac].ecb42,g_ecb[l_ac].ecb43,
#                                g_ecb[l_ac].ecb44,g_ecb[l_ac].ecb45,  #FUN-A50081
                                                   g_ecb[l_ac].ecb45,  #FUN-A50081
                                 g_ecb[l_ac].ecb46,
                                 g_ecb[l_ac].ecb14,g_ecb[l_ac].ecb51,g_ecb[l_ac].ecb52,g_ecb[l_ac].ecb53,  #FUN-A50081
                                 #g_ecb[l_ac].ecb48,g_ecb[l_ac].ecb49,   #FUN-960056 #CHI-C70033
                                 g_ecb[l_ac].ecb48,g_ecb[l_ac].ecb25,  #CHI-C70033
                                 'Y',g_today, #TQC-8C0016 add g_today
                                 g_ecb[l_ac].ecbud01,
                                 g_ecb[l_ac].ecbud02,
                                 g_ecb[l_ac].ecbud03,
                                 g_ecb[l_ac].ecbud04,
                                 g_ecb[l_ac].ecbud05,
                                 g_ecb[l_ac].ecbud06,
                                 g_ecb[l_ac].ecbud07,
                                 g_ecb[l_ac].ecbud08,
                                 g_ecb[l_ac].ecbud09,
                                 g_ecb[l_ac].ecbud10,
                                 g_ecb[l_ac].ecbud11,
                                 g_ecb[l_ac].ecbud12,
                                 g_ecb[l_ac].ecbud13,
                                 g_ecb[l_ac].ecbud14,
                                 g_ecb[l_ac].ecbud15,
                                 g_ecu.ecu012)           #FUN-A50081 add ecu012

            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ecb_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","ins ecb:",1) #FUN-660091
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               CALL i100_b_total('u')
            END IF
            IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                CALL i100_aps_ecb('N')
            END IF

          BEFORE FIELD ecb03
            IF cl_null(g_ecb[l_ac].ecb03) OR g_ecb[l_ac].ecb03 = 0 THEN
               SELECT max(ecb03) INTO g_ecb[l_ac].ecb03 FROM ecb_file   #FUN-960063
                WHERE ecb01 = g_ecu.ecu01
                  AND ecb02 = g_ecu.ecu02
                  AND ecb012 = g_ecu.ecu012   #FUN-A50081
               IF cl_null(g_ecb[l_ac].ecb03) THEN
                  LET g_ecb[l_ac].ecb03 = 0   #FUN-960063
               END IF
               LET g_ecb[l_ac].ecb03 = g_ecb[l_ac].ecb03 + g_sma.sma849 #FUN-960063
            END IF

          AFTER FIELD ecb03
            IF NOT cl_null(g_ecb[l_ac].ecb03) THEN
               IF g_ecb[l_ac].ecb03 != g_ecb_t.ecb03
                  OR g_ecb_t.ecb03 IS NULL THEN
                  SELECT count(*) INTO l_n FROM ecb_file
                   WHERE ecb01 = g_ecu.ecu01
                     AND ecb02 = g_ecu.ecu02
                     AND ecb03 = g_ecb[l_ac].ecb03
                     AND ecb012 = g_ecu.ecu012     #FUN-A50081
                  IF l_n > 0 THEN
                     CALL cl_err('','aec-010',0)
                     LET g_ecb[l_ac].ecb03 = g_ecb_t.ecb03
                     NEXT FIELD ecb03
                  END IF
                 #FUN-A40060--add---str---
                  IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                      IF NOT cl_null(g_ecb_t.ecb03) THEN
                          #==>APS途程製程
                          LET l_cnt_vmn = 0
                          SELECT COUNT(*) INTO l_cnt_vmn
                            FROM vmn_file
                           WHERE vmn01 = g_ecu.ecu01
                             AND vmn02 = g_ecu.ecu02
                             AND vmn03 = g_ecb_t.ecb03
                          IF l_cnt_vmn >=1 THEN
                              UPDATE vmn_file
                                 SET vmn03 = g_ecb[l_ac].ecb03
                               WHERE vmn01 = g_ecu.ecu01
                                 AND vmn02 = g_ecu.ecu02
                                 AND vmn03 = g_ecb_t.ecb03
                              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                                  CALL cl_err3("upd","vmn_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1)
                                  LET g_ecb[l_ac].ecb03 = g_ecb_t.ecb03
                                  NEXT FIELD ecb03
                              END IF
                          END IF
                          #==>APS替代作業
                          LET l_cnt_vms = 0
                          SELECT COUNT(*) INTO l_cnt_vms
                            FROM vms_file
                           WHERE vms01 = g_ecu.ecu01
                             AND vms02 = g_ecu.ecu02
                             AND vms03 = g_ecb_t.ecb03
                          IF l_cnt_vms >=1 THEN
                              UPDATE vms_file
                                 SET vms03 = g_ecb[l_ac].ecb03
                               WHERE vms01 = g_ecu.ecu01
                                 AND vms02 = g_ecu.ecu02
                                 AND vms03 = g_ecb_t.ecb03
                              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                                  CALL cl_err3("upd","vms_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1)
                                  LET g_ecb[l_ac].ecb03 = g_ecb_t.ecb03
                                  NEXT FIELD ecb03
                              END IF
                          END IF
                          #==>APS指定工具
                          LET l_cnt_vnm = 0
                          SELECT COUNT(*) INTO l_cnt_vnm
                            FROM vnm_file
                           WHERE vnm00 = g_ecu.ecu01
                             AND vnm01 = g_ecu.ecu02
                             AND vnm02 = g_ecb_t.ecb03
                          IF l_cnt_vnm >=1 THEN
                              UPDATE vnm_file
                                 SET vnm02 = g_ecb[l_ac].ecb03
                               WHERE vnm00 = g_ecu.ecu01
                                 AND vnm01 = g_ecu.ecu02
                                 AND vnm02 = g_ecb_t.ecb03
                              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                                  CALL cl_err3("upd","vnm_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1)
                                  LET g_ecb[l_ac].ecb03 = g_ecb_t.ecb03
                                  NEXT FIELD ecb03
                              END IF
                          END IF
                      END IF
                  END IF
                 #FUN-A40060--add---end---
               END IF
            END IF

        AFTER FIELD ecb06
            IF NOT cl_null(g_ecb[l_ac].ecb06) THEN
               CALL i100_ecb06(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ecb[l_ac].ecb06 = g_ecb_t.ecb06
                  DISPLAY BY NAME g_ecb[l_ac].ecb06
                  NEXT FIELD ecb06
               END IF
              #FUN-A40060--add---str---
               IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                   IF NOT cl_null(g_ecb_t.ecb06) AND
                      g_ecb[l_ac].ecb06 != g_ecb_t.ecb06 THEN
                       #==>APS途程製程
                       LET l_cnt_vmn = 0
                       SELECT COUNT(*) INTO l_cnt_vmn
                         FROM vmn_file
                        WHERE vmn01 = g_ecu.ecu01
                          AND vmn02 = g_ecu.ecu02
                          AND vmn04 = g_ecb_t.ecb06
                       IF l_cnt_vmn >=1 THEN
                           UPDATE vmn_file
                              SET vmn04 = g_ecb[l_ac].ecb06
                            WHERE vmn01 = g_ecu.ecu01
                              AND vmn02 = g_ecu.ecu02
                              AND vmn04 = g_ecb_t.ecb06
                           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                               CALL cl_err3("upd","vmn_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1)
                               LET g_ecb[l_ac].ecb06 = g_ecb_t.ecb06
                               NEXT FIELD ecb06
                           END IF
                       END IF
                       #==>APS指定工具
                       LET l_cnt_vnm = 0
                       SELECT COUNT(*) INTO l_cnt_vnm
                         FROM vnm_file
                        WHERE vnm00 = g_ecu.ecu01
                          AND vnm01 = g_ecu.ecu02
                          AND vnm03 = g_ecb_t.ecb06
                       IF l_cnt_vnm >=1 THEN
                           UPDATE vnm_file
                              SET vnm03 = g_ecb[l_ac].ecb06
                            WHERE vnm00 = g_ecu.ecu01
                              AND vnm01 = g_ecu.ecu02
                              AND vnm03 = g_ecb_t.ecb06
                           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                               CALL cl_err3("upd","vnm_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1)
                               LET g_ecb[l_ac].ecb06 = g_ecb_t.ecb06
                               NEXT FIELD ecb06
                           END IF
                       END IF
                   END IF
               END IF
              #FUN-A40060--add---end---
            END IF

        AFTER FIELD ecb08
            IF NOT cl_null(g_ecb[l_ac].ecb08)  THEN
               CALL i100_ecb08('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_ecb[l_ac].ecb08 = g_ecb_t.ecb08
                  DISPLAY BY NAME g_ecb[l_ac].ecb08
                  NEXT FIELD ecb08
               END IF
            END IF

        AFTER FIELD ecb07
            IF NOT cl_null(g_ecb[l_ac].ecb07) THEN
               SELECT eci01 INTO l_eci01 FROM eci_file
                WHERE eci01 =  g_ecb[l_ac].ecb07
               IF STATUS THEN
                  CALL cl_err3("sel","eci_file",g_ecb[l_ac].ecb07,"","aec-011","","",1) #FUN-660091
                  NEXT FIELD ecb07
               END IF
            END IF
        #有串APS時:
        #整體參數資源型態設機器時,機器編號ecb07和資源群組編號(機器)vmn08至少要有一個欄位有值
        AFTER FIELD vmn08
            IF NOT cl_null(g_ecb[l_ac].vmn08) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vme_file
                 WHERE vme01 = g_ecb[l_ac].vmn08
                IF l_cnt = 0 THEN
                    CALL cl_err('','aps-404',1)
                    LET g_ecb[l_ac].vmn08 = g_ecb_t.vmn08
                    DISPLAY BY NAME g_ecb[l_ac].vmn08
                    NEXT FIELD vmn08
                END IF
            END IF
           #FUN-9A0047 mark---str---
           #IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
           #    IF cl_null(g_ecb[l_ac].ecb07) AND cl_null(g_ecb[l_ac].vmn08) THEN
           #        #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
           #        CALL cl_err('','aps-033',1)
           #        NEXT FIELD ecb07
           #    END IF
           #END IF
           #FUN-9A0047 mark---end---

        AFTER FIELD vmn081
            IF NOT cl_null(g_ecb[l_ac].vmn081) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vmp_file
                 WHERE vmp01 = g_ecb[l_ac].vmn081
                IF l_cnt = 0 THEN
                    CALL cl_err('','aps-405',1)
                    LET g_ecb[l_ac].vmn081 = g_ecb_t.vmn081
                    DISPLAY BY NAME g_ecb[l_ac].vmn081
                    NEXT FIELD vmn081
                END IF
            END IF

        AFTER FIELD ecb04
            IF NOT cl_null(g_ecb[l_ac].ecb04) THEN
               IF g_ecb[l_ac].ecb04 < 0 THEN
                  CALL cl_err(g_ecb[l_ac].ecb04,'aec-991',0)     #No.TQC-6C0188
                  NEXT FIELD ecb04
               END IF
            END IF

        AFTER FIELD ecb18
            IF NOT cl_null(g_ecb[l_ac].ecb18) THEN
               IF g_ecb[l_ac].ecb18 < 0 THEN
                  CALL cl_err(g_ecb[l_ac].ecb18,'anm-249',0)
                  NEXT FIELD ecb18
               END IF
            END IF

        AFTER FIELD ecb19
            IF NOT cl_null(g_ecb[l_ac].ecb19) THEN
               IF g_ecb[l_ac].ecb19 < 0 THEN
                  CALL cl_err(g_ecb[l_ac].ecb19,'anm-249',0)
                  NEXT FIELD ecb19
               END IF
            END IF

        AFTER FIELD ecb20
            IF NOT cl_null(g_ecb[l_ac].ecb20) THEN
               IF g_ecb[l_ac].ecb20 < 0 THEN
                  CALL cl_err(g_ecb[l_ac].ecb20,'anm-249',0)
                  NEXT FIELD ecb20
               END IF
            END IF

        AFTER FIELD ecb21
            IF NOT cl_null(g_ecb[l_ac].ecb21) THEN
               IF g_ecb[l_ac].ecb21 < 0 THEN
                  CALL cl_err(g_ecb[l_ac].ecb21,'anm-249',0)
                  NEXT FIELD ecb21
               END IF
            END IF

        AFTER FIELD ecb38
            IF NOT cl_null(g_ecb[l_ac].ecb38) THEN
               IF g_ecb[l_ac].ecb38 < 0 THEN
                  CALL cl_err(g_ecb[l_ac].ecb38,'anm-249',0)
                  NEXT FIELD ecb38
               END IF
            END IF

       #FUN-A80150---add---start---
        AFTER FIELD ecb66
           IF NOT cl_null(g_ecb[l_ac].ecb66) THEN
              IF g_ecb[l_ac].ecb66 NOT MATCHES '[YN]' THEN
                 CALL cl_err('','aec-079',0)
                 NEXT FIELD ecb66
              END IF
           END IF
       #FUN-A80150---add---end---

        AFTER FIELD ecb39
            IF NOT cl_null(g_ecb[l_ac].ecb39) THEN
               IF g_ecb[l_ac].ecb39 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD ecb39
               END IF
            END IF

        AFTER FIELD ecb40
            IF NOT cl_null(g_ecb[l_ac].ecb40) THEN
               IF g_ecb[l_ac].ecb40 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD ecb40
               END IF
            END IF

        AFTER FIELD ecbslk05
            IF NOT cl_null(g_ecb[l_ac].ecbslk05) THEN
               IF g_ecb[l_ac].ecbslk05 < 0 THEN
                  CALL cl_err(g_ecb[l_ac].ecbslk05,'anm-249',0)
                  NEXT FIELD ecbslk05
               END IF
            END IF

       AFTER FIELD ecbslk04
             IF NOT cl_null(g_ecb[l_ac].ecbslk04) THEN
                IF g_ecb[l_ac].ecbslk04 < 0 THEN
                   CALL cl_err(g_ecb[l_ac].ecbslk04,'anm-249',0)
                   NEXT FIELD ecbslk04
                END IF
             END IF

       AFTER FIELD ecbslk02
            IF NOT cl_null(g_ecb[l_ac].ecbslk02) THEN
               IF g_ecb[l_ac].ecbslk02 < 0 THEN
                  CALL cl_err(g_ecb[l_ac].ecbslk02,'anm-249',0)
                  NEXT FIELD ecbslk02
               END IF
            END IF

        BEFORE FIELD ecb41
            CALL i100_set_entry_b(p_cmd)

        AFTER FIELD ecb41
            IF NOT cl_null(g_ecb[l_ac].ecb41) THEN
               IF g_ecb[l_ac].ecb41 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD ecb41
               END IF
               IF g_ecb[l_ac].ecb41 ='N' THEN
                  LET g_ecb[l_ac].ecb42 = ' '
                  DISPLAY BY NAME g_ecb[l_ac].ecb42
               END IF

               CALL i100_set_no_entry_b(p_cmd)

            END IF

        AFTER FIELD ecb42
            IF NOT cl_null(g_ecb[l_ac].ecb42) THEN
               CALL i100_sgg(g_ecb[l_ac].ecb42)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ecb[l_ac].ecb42=g_ecb_t.ecb42
                  DISPLAY BY NAME g_ecb[l_ac].ecb42
                  NEXT FIELD ecb42
               END IF
            END IF

        AFTER FIELD ecb43
            IF NOT cl_null(g_ecb[l_ac].ecb43) THEN
               CALL i100_sgg(g_ecb[l_ac].ecb43)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ecb[l_ac].ecb43=g_ecb_t.ecb43
                  DISPLAY BY NAME g_ecb[l_ac].ecb43
                  NEXT FIELD ecb43
               END IF
            END IF

#FUN-A50081 --begin--
#        AFTER FIELD ecb44
#             IF NOT cl_null(g_ecb[l_ac].ecb44) THEN       #TQC-970231
#               SELECT COUNT(*) INTO g_cnt FROM gfe_file
#                WHERE gfe01=g_ecb[l_ac].ecb44
#               IF g_cnt=0 THEN
#                  CALL cl_err(g_ecb[l_ac].ecb44,'mfg2605',0)
#                  NEXT FIELD ecb44
#               END IF
#               IF NOT cl_null(g_ecb[l_ac].ecb45) THEN
#                  IF g_ecb[l_ac].ecb44 = g_ecb[l_ac].ecb45 THEN
#                     LET g_ecb[l_ac].ecb46=1
#                  ELSE
#                     CALL s_umfchk(g_ecu.ecu01,g_ecb[l_ac].ecb45,g_ecb[l_ac].ecb44)
#                          RETURNING g_sw,g_ecb[l_ac].ecb46
#                     IF g_sw = '1' THEN
#                        CALL cl_err(g_ecb[l_ac].ecb45,'mfg1206',0)
#                        NEXT FIELD ecb45
#                     END IF
#                  END IF
#               END IF
#               DISPLAY BY NAME g_ecb[l_ac].ecb46
#            END IF
#FUN-A50081 --end--

        AFTER FIELD ecb45
            IF NOT cl_null(g_ecb[l_ac].ecb45) THEN
               SELECT COUNT(*) INTO g_cnt FROM gfe_file
                WHERE gfe01=g_ecb[l_ac].ecb45
               IF g_cnt=0 THEN
                  CALL cl_err(g_ecb[l_ac].ecb45,'mfg2605',0)
                  NEXT FIELD ecb45
               END IF
               #MOD-D20118---begin
               SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=g_ecu.ecu01
               CALL s_umfchk(g_ecu.ecu01,l_ima55,g_ecb[l_ac].ecb45)
                    RETURNING l_cnt,l_fac    #單位換算
               IF l_cnt = '1'  THEN 
                  LET l_fac = 1
               END IF
               LET g_ecb[l_ac].ecb46 = l_fac
               #MOD-D20118---end
#FUN-A50081 --begin--
#               IF g_ecb[l_ac].ecb44 = g_ecb[l_ac].ecb45 THEN
#                  LET g_ecb[l_ac].ecb46=1
#               ELSE
#                  CALL s_umfchk(g_ecu.ecu01,g_ecb[l_ac].ecb45,g_ecb[l_ac].ecb44)
#                       RETURNING g_sw,g_ecb[l_ac].ecb46
#                  IF g_sw = '1' THEN
#                     CALL cl_err(g_ecb[l_ac].ecb45,'mfg1206',0)
#                     NEXT FIELD ecb45
#                  END IF
#               END IF
#               DISPLAY BY NAME g_ecb[l_ac].ecb46
#FUN-A50081 --end--
               #FUN-BB0083---add---str
               IF NOT cl_null(g_ecb[l_ac].ecb52) THEN
                  IF NOT i100_ecb52_check() THEN 
                     LET g_ecb45_t = g_ecb[l_ac].ecb45
                     NEXT FIELD ecb52
                  END IF
               END IF
               LET g_ecb45_t = g_ecb[l_ac].ecb45
               #FUN-BB0083---add---end
            END IF

#FUN-A50081 --begin--
       AFTER FIELD ecb14
         IF cl_null(g_ecb[l_ac].ecb14) THEN
            NEXT FIELD CURRENT
         ELSE
         	  IF g_ecb[l_ac].ecb14 < 0 THEN
         	     CALL cl_err('','aim-223',0)
         	     NEXT FIELD CURRENT
         	  END IF
         END IF

       AFTER FIELD ecb46
         IF NOT cl_null(g_ecb[l_ac].ecb46) THEN
            IF g_ecb[l_ac].ecb46 <= 0 THEN
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT
            END IF
           #MOD-C20166 mark add
           ##FUN-B90141 --START--
           #IF NOT i100_chk_ecu51() THEN               
           #   NEXT FIELD CURRENT
           #END IF 
           ##FUN-B90141 --END--
           #MOD-C20166 mark add
         ELSE
            #NEXT FIELD CURRENT   #FUN-B90141 mark
         END IF

       AFTER FIELD ecb51
         IF NOT cl_null(g_ecb[l_ac].ecb51) THEN
            IF g_ecb[l_ac].ecb51 <= 0 THEN
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT
            END IF
           #MOD-C20166 mark add
           ##FUN-B90141 --START--
           #IF NOT i100_chk_ecu51() THEN               
           #   NEXT FIELD CURRENT
           #END IF 
           ##FUN-B90141 --END--
           #MOD-C20166 mark add  
         ELSE
            #NEXT FIELD CURRENT   #FUN-B90141 mark
         END IF
       AFTER FIELD ecb52
          #FUN-BB0083---add---str
          IF NOT i100_ecb52_check() THEN
             NEXT FIELD ecb52
          END IF
          #FUN-BB0083---add---end
          #FUN-BB0083---mark---str
          #IF cl_null(g_ecb[l_ac].ecb52) THEN
          #   NEXT FIELD CURRENT
          #ELSE
          #	  IF g_ecb[l_ac].ecb52 < 0 THEN
          #	     CALL cl_err('','aim-223',0)
          #	     NEXT FIELD CURRENT
          #	  END IF
          #END IF
          #FUN-BB0083---mark---end
          
       AFTER FIELD ecb53
         IF NOT cl_null(g_ecb[l_ac].ecb53) THEN
            IF g_ecb[l_ac].ecb53 <= 0 THEN
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT
            END IF
         ELSE
            NEXT FIELD CURRENT
         END IF
#FUN-A50081 --end--

       AFTER FIELD ecb48
         IF NOT cl_null(g_ecb[l_ac].ecb48) THEN
            IF g_ecb[l_ac].ecb48 < 0 THEN
               CALL cl_err('','aec-020',0)
               NEXT FIELD ecb48
            END IF
         END IF

       #AFTER FIELD ecb49  #CHI-C70033
       AFTER FIELD ecb25  #CHI-C70033
         #IF NOT cl_null(g_ecb[l_ac].ecb49) THEN  #CHI-C70033
         IF NOT cl_null(g_ecb[l_ac].ecb25) THEN  #CHI-C70033
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM pmc_file
             WHERE pmcacti = 'Y'
               #AND pmc01 =g_ecb[l_ac].ecb49  #CHI-C70033
               AND pmc01 =g_ecb[l_ac].ecb25  #CHI-C70033
               AND pmc30 IN ('1','3')
            IF g_cnt = 0 THEN
               CALL cl_err('','aic-050',0)
               #NEXT FIELD ecb49  #CHI-C70033
               NEXT FIELD ecb25  #CHI-C70033
            END IF
          END IF
        AFTER FIELD ecbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER FIELD ecbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        BEFORE DELETE                            #是否取消單身
            IF g_ecb_t.ecb03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM ecb_file
                 WHERE ecb01 = g_ecu.ecu01 AND ecb02 = g_ecu.ecu02
                   AND ecb03 = g_ecb_t.ecb03
                   AND ecb012 = g_ecu.ecu012    #FUN-A50081
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ecb_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1) #FUN-660091
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE

                  DELETE FROM vms_file
                      WHERE vms01 = g_ecu.ecu01 AND vms02 = g_ecu.ecu02
                        AND vms03 = g_ecb_t.ecb03

                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","vms_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF

                   DELETE FROM vmn_file
                      WHERE vmn01 = g_ecu.ecu01 AND vmn02 = g_ecu.ecu02
                        AND vmn03 = g_ecb_t.ecb03

                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","vmn_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF

                     DELETE FROM vnm_file
                      WHERE vnm00 = g_ecu.ecu01 AND vnm01 = g_ecu.ecu02
                        AND vnm02 = g_ecb_t.ecb03 AND vnm03=g_ecb_t.ecb06

                    IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","vnm_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF


                   LET g_success = 'Y'

                   DELETE FROM  sgc_file
                    WHERE sgc01=g_ecu.ecu01 AND sgc02=g_ecu.ecu02
                      AND sgc03=g_ecb_t.ecb03
                      AND sgc012 = g_ecu.ecu012     #FUN-A50081
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","sgc_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1) #FUN-660091
                       LET g_success = 'N'
                    END IF

                    DELETE FROM  eco_file
                     WHERE eco01=g_ecu.ecu01 AND eco02=g_ecu.ecu02
                       AND eco03=g_ecb_t.ecb03
                       AND eco012 = g_ecu.ecu012    #FUN-A50081 add
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","eco_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1) #FUN-660091
                       LET g_success = 'N'
                    END IF

                    DELETE FROM ecbb_file  #NO:4736
                     WHERE ecbb01=g_ecu.ecu01 AND ecbb02=g_ecu.ecu02
                       AND ecbb03=g_ecb[l_ac].ecb03
                       AND ecbb012 = g_ecu.ecu012  #FUN-A50081
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","ecbb_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1) #FUN-660091
                       LET g_success = 'N'
                    END IF

                    IF g_success = 'N' THEN
                       ROLLBACK WORK
                       CANCEL DELETE
                    ELSE
                       LET g_rec_b=g_rec_b-1
                       DISPLAY g_rec_b TO FORMONLY.cn2
                       COMMIT WORK
                       CALL i100_b_total('u')
                    END IF

                END IF
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ecb[l_ac].* = g_ecb_t.*
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #FUN-9A0047 mark---str----
           #IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
           #    IF cl_null(g_ecb[l_ac].ecb07) AND cl_null(g_ecb[l_ac].vmn08) THEN
           #        #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
           #        CALL cl_err('','aps-033',1)
           #        LET g_ecb[l_ac].* = g_ecb_t.*
           #        CLOSE i100_bcl
           #        ROLLBACK WORK
           #        EXIT INPUT
           #    END IF
           #END IF
           #FUN-9A0047 mark---end----
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ecb[l_ac].ecb03,-263,1)
               LET g_ecb[l_ac].* = g_ecb_t.*
            ELSE
               UPDATE ecb_file SET ecb03=g_ecb[l_ac].ecb03,
                                   ecb06=g_ecb[l_ac].ecb06,
                                   ecb17=g_ecb[l_ac].ecb17,
                                   ecb66=g_ecb[l_ac].ecb66,    #FUN-A80150 add
                                   ecb39=g_ecb[l_ac].ecb39,
                                   ecb40=g_ecb[l_ac].ecb40,
                                   ecb41=g_ecb[l_ac].ecb41,
                                   ecb18=g_ecb[l_ac].ecb18,
                                   ecb07=g_ecb[l_ac].ecb07,
                                   ecb08=g_ecb[l_ac].ecb08,
                                   ecb19=g_ecb[l_ac].ecb19,
                                   ecb38=g_ecb[l_ac].ecb38,
                                   ecb04=g_ecb[l_ac].ecb04,
                                   ecb21=g_ecb[l_ac].ecb21,
                                   ecb20=g_ecb[l_ac].ecb20,
                                   ecb42=g_ecb[l_ac].ecb42,
                                   ecb43=g_ecb[l_ac].ecb43,
#                                  ecb44=g_ecb[l_ac].ecb44,  #FUN-A50081
                                   ecb45=g_ecb[l_ac].ecb45,
                                   ecb46=g_ecb[l_ac].ecb46,
                    #FUN-A50081 --begin--
                                   ecb14=g_ecb[l_ac].ecb14,
                                   ecb51=g_ecb[l_ac].ecb51,
                                   ecb52=g_ecb[l_ac].ecb52,
                                   ecb53=g_ecb[l_ac].ecb53,
                    #FUN-A50081 --end--
                                   ecb48=g_ecb[l_ac].ecb48,  #FUN-960056
                                   #ecb49=g_ecb[l_ac].ecb49, #FUN-960056 #CHI-C70033
                                   ecb25=g_ecb[l_ac].ecb25,  #CHI-C70033
                                   ecbslk05=g_ecb[l_ac].ecbslk05,   #No.FUN-810017
                                   ecbslk04=g_ecb[l_ac].ecbslk04,   #No.FUN-810017
                                   ecbslk02=g_ecb[l_ac].ecbslk02,   #No.FUN-810017
                                   ecbslk01=g_ecb[l_ac].ecbslk01,   #NO.TQC-BC0166 add
                                   ecbacti='Y',
                                   ecbdate=g_today, #TQC-8C0016 add
                                   ecbud01 = g_ecb[l_ac].ecbud01,
                                   ecbud02 = g_ecb[l_ac].ecbud02,
                                   ecbud03 = g_ecb[l_ac].ecbud03,
                                   ecbud04 = g_ecb[l_ac].ecbud04,
                                   ecbud05 = g_ecb[l_ac].ecbud05,
                                   ecbud06 = g_ecb[l_ac].ecbud06,
                                   ecbud07 = g_ecb[l_ac].ecbud07,
                                   ecbud08 = g_ecb[l_ac].ecbud08,
                                   ecbud09 = g_ecb[l_ac].ecbud09,
                                   ecbud10 = g_ecb[l_ac].ecbud10,
                                   ecbud11 = g_ecb[l_ac].ecbud11,
                                   ecbud12 = g_ecb[l_ac].ecbud12,
                                   ecbud13 = g_ecb[l_ac].ecbud13,
                                   ecbud14 = g_ecb[l_ac].ecbud14,
                                   ecbud15 = g_ecb[l_ac].ecbud15

                WHERE ecb01=g_ecu.ecu01
                  AND ecb02=g_ecu.ecu02
                  AND ecb03=g_ecb_t.ecb03
                  AND ecb012 = g_ecu.ecu012   #FUN-A50081
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ecb_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1) #FUN-660091
                  LET g_ecb[l_ac].* = g_ecb_t.*
                  ROLLBACK WORK
               ELSE
                  IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                      #FUN-A40060--add---str--
                       LET l_cnt_vmn = 0
                       SELECT COUNT(*) INTO l_cnt_vmn
                         FROM vmn_file
                        WHERE vmn01 = g_ecu.ecu01
                          AND vmn02 = g_ecu.ecu02
                          AND vmn03 = g_ecb[l_ac].ecb03
                          AND vmn04 = g_ecb[l_ac].ecb06
                       IF l_cnt_vmn >=1 THEN
                        #FUN-A40060--add---end--
                         UPDATE vmn_file
                            SET vmn08  = g_ecb[l_ac].vmn08,
                                vmn081 = g_ecb[l_ac].vmn081
                            WHERE vmn01 = g_ecu.ecu01
                              AND vmn02 = g_ecu.ecu02
                              AND vmn03 = g_ecb[l_ac].ecb03
                              AND vmn04 = g_ecb[l_ac].ecb06
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","vmn_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1)
                            LET g_ecb[l_ac].* = g_ecb_t.*
                            ROLLBACK WORK
                         END IF
                        #FUN-A40060--add---str--
                       ELSE
                         CALL i100_aps_ecb('N')
                       END IF
                      #FUN-A40060--add---end--
                  END IF

                  SELECT COUNT(*) INTO l_n FROM sgc_file
                   WHERE sgc01=g_ecu.ecu01
                     AND sgc02=g_ecu.ecu02
                     AND sgc03=g_ecb_t.ecb03
                     AND sgc012 = g_ecu.ecu012   #FUN-A50081
                  IF l_n > 0 THEN
                     UPDATE sgc_file SET sgc04 = g_ecb[l_ac].ecb08
                      WHERE sgc01=g_ecu.ecu01
                        AND sgc02=g_ecu.ecu02
                        AND sgc03=g_ecb_t.ecb03
                        AND sgc012 = g_ecu.ecu012   #FU-A50081 add
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","sgc_file","","",SQLCA.sqlcode,"","",1)
                     END IF
                  END IF
               END IF
            END IF

        #FUN-9A0047 add---str---
        AFTER INPUT
        IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
            CALL i100_chk_aps() RETURNING l_sw_aps
            IF l_sw_aps THEN
                CONTINUE INPUT
            END IF
        END IF
        #FUN-9A0047 add---end---

        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF l_ac <= g_ecb.getLength() THEN       #MOD-C30195   
            #MOD-C20166 str add-----
               IF NOT INT_FLAG THEN                 #MOD-C30539
                  IF NOT i100_chk_ecu51() THEN
                     IF cl_null(g_ecb[l_ac].ecb51) THEN
                        NEXT FIELD ecb51
                     END IF
                     NEXT FIELD ecb46
                  END IF
               END IF                               #MOD-C30539
            #MOD-C20166 end add-----
            END IF                                  #MOD-C30195
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_ecb[l_ac].* = g_ecb_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ecb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               ROLLBACK WORK
               CLOSE i100_bcl
               #FUN-9A0047 add---str---
               IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                   CONTINUE INPUT
               END IF
               #FUN-9A0047 add---end---
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i100_bcl
            COMMIT WORK

        ON ACTION controlp                        #
           CASE
              WHEN INFIELD(ecb07)                 #機械編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_eci"
                   LET g_qryparam.default1 = g_ecb[l_ac].ecb07
                   CALL cl_create_qry() RETURNING g_ecb[l_ac].ecb07
                    DISPLAY BY NAME g_ecb[l_ac].ecb07     #No.MOD-490371
                   NEXT FIELD ecb07
              WHEN INFIELD(ecb08)
                   CALL q_eca(FALSE,FALSE,g_ecb[l_ac].ecb08)
                        RETURNING g_ecb[l_ac].ecb08
                    DISPLAY BY NAME  g_ecb[l_ac].ecb08     #No.MOD-490371
                   NEXT FIELD ecb08
              WHEN INFIELD(ecb06)
                   CALL q_ecd(FALSE,TRUE,g_ecb[l_ac].ecb06)
                        RETURNING g_ecb[l_ac].ecb06
                    DISPLAY BY NAME g_ecb[l_ac].ecb06      #No.MOD-490371
                   NEXT FIELD ecb06
              WHEN INFIELD(ecb42)
                   IF g_ecb[l_ac].ecb41='Y' THEN
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_sgg"
                      LET g_qryparam.default1 = g_ecb[l_ac].ecb42
                      CALL cl_create_qry() RETURNING g_ecb[l_ac].ecb42
                   ELSE
                      LET g_ecb[l_ac].ecb42=''
                   END IF
                    DISPLAY BY NAME g_ecb[l_ac].ecb42      #No.MOD-490371
                   NEXT FIELD ecb42
              WHEN INFIELD(ecb43)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_ecb[l_ac].ecb43
                   CALL cl_create_qry() RETURNING g_ecb[l_ac].ecb43
                    DISPLAY BY NAME g_ecb[l_ac].ecb43      #No.MOD-490371
                   NEXT FIELD ecb43
#FUN-A50081 --begin--
#              WHEN INFIELD(ecb44)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_gfe"
#                   LET g_qryparam.default1 = g_ecb[l_ac].ecb44
#                   CALL cl_create_qry() RETURNING g_ecb[l_ac].ecb44
#                    DISPLAY BY NAME g_ecb[l_ac].ecb44        #No.MOD-490371
#                   NEXT FIELD ecb44
#FUN-A50081 --end--
              WHEN INFIELD(ecb45)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_ecb[l_ac].ecb45
                   CALL cl_create_qry() RETURNING g_ecb[l_ac].ecb45
                    DISPLAY BY NAME  g_ecb[l_ac].ecb45       #No.MOD-490371
                   NEXT FIELD ecb45
              WHEN INFIELD(vmn08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_vme01"
                   CALL cl_create_qry() RETURNING g_ecb[l_ac].vmn08
                   DISPLAY BY NAME g_ecb[l_ac].vmn08
                   NEXT FIELD vmn08
              WHEN  INFIELD(vmn081)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_vmp01"
                    CALL cl_create_qry() RETURNING g_ecb[l_ac].vmn081
                    DISPLAY BY NAME g_ecb[l_ac].vmn081
                    NEXT FIELD vmn081
              #WHEN INFIELD(ecb49) #查詢廠商檔
              WHEN INFIELD(ecb25)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc1"
                   #LET g_qryparam.default1 = g_ecb[l_ac].ecb49  #CHI-C70033
                   #CALL cl_create_qry() RETURNING g_ecb[l_ac].ecb49  #CHI-C70033
                   #DISPLAY BY NAME g_ecb[l_ac].ecb49  #CHI-C70033
                   #NEXT FIELD ecb49  #CHI-C70033
                   LET g_qryparam.default1 = g_ecb[l_ac].ecb25  #CHI-C70033
                   CALL cl_create_qry() RETURNING g_ecb[l_ac].ecb25  #CHI-C70033
                   DISPLAY BY NAME g_ecb[l_ac].ecb25  #CHI-C70033
                   NEXT FIELD ecb25  #CHI-C70033
           END CASE


        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ecb03) AND l_ac > 1 THEN
               LET g_ecb[l_ac].* = g_ecb[l_ac-1].*
               NEXT FIELD ecb03
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
    CALL i100_b_total('u')

    UPDATE ecu_file SET ecumodu=g_user,
                        ecudate=TODAY
     WHERE ecu01=g_ecu.ecu01 AND ecu02=g_ecu.ecu02
       AND ecu012 = g_ecu.ecu012  #FUN-A50081 add

    CLOSE i100_bcl
    COMMIT WORK
    CALL i100_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i100_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM ecu_file WHERE ecu01=g_ecu.ecu01
                                AND ecu02=g_ecu.ecu02
                                AND ecu012 = g_ecu.ecu012
         INITIALIZE g_ecu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i100_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680073 VARCHAR(01)

    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("ecb26",TRUE)
    END IF

    IF INFIELD(ecb41) THEN
       CALL cl_set_comp_entry("ecb42",TRUE)
    END IF

END FUNCTION

FUNCTION i100_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680073 VARCHAR(01)

    IF INFIELD(ecb41) THEN
       IF g_ecb[l_ac].ecb41 ='N' THEN
          CALL cl_set_comp_entry("ecb42",FALSE)
       END IF
    END IF

END FUNCTION

FUNCTION  i100_sgg(p_key)
DEFINE
    p_key          LIKE sgg_file.sgg01,
    l_sgg01        LIKE sgg_file.sgg01,
    l_sggacti      LIKE sgg_file.sggacti

    LET g_errno = ' '
    SELECT sgg01,sggacti INTO l_sgg01,l_sggacti FROM sgg_file
     WHERE sgg01 = p_key

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-003'
                                   LET l_sggacti = NULL
         WHEN l_sggacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

END FUNCTION

FUNCTION i100_b_total(p_cmd)
  DEFINE  p_cmd    LIKE type_file.chr1           #No.FUN-680073 VARCHAR(01)
    SELECT MIN(ecb03),MAX(ecb03) INTO g_ecu.ecu04,g_ecu.ecu05 FROM ecb_file
     WHERE ecb01=g_ecu.ecu01 AND ecb02=g_ecu.ecu02
      AND ecb012 = g_ecu.ecu012   #FUN-A50081
    IF g_ecu.ecu04 IS NULL THEN LET g_ecu.ecu04 = 0 END IF
    IF g_ecu.ecu05 IS NULL THEN LET g_ecu.ecu05 = 0 END IF

    SELECT SUM(ecb19),SUM(ecb18),SUM(ecb21),SUM(ecb20),SUM(ecb38)
      INTO l_ecu19,l_ecu18,l_ecu21,l_ecu20,l_ecu38
      FROM ecb_file
     WHERE ecb01=g_ecu.ecu01
       AND ecb02=g_ecu.ecu02
       AND ecb012 = g_ecu.ecu012  #FUN-A50081

    IF p_cmd ='u' THEN
       UPDATE ecu_file SET ecu04=g_ecu.ecu04,
                           ecu05=g_ecu.ecu05,
                           ecudate = g_today     #FUN-D10063 add
        WHERE ecu01=g_ecu.ecu01
          AND ecu02=g_ecu.ecu02
          AND ecu012 = g_ecu.ecu012 #FUN-A50081
    END IF

    DISPLAY BY NAME g_ecu.ecu04,g_ecu.ecu05
    DISPLAY l_ecu19,l_ecu18,l_ecu21,l_ecu20,l_ecu38
         TO FORMONLY.ecu19s,FORMONLY.ecu18s,FORMONLY.ecu21s,
            FORMONLY.ecu20s,FORMONLY.ecu38s

END FUNCTION

#FUN-B90117 --MARK
#FUNCTION i100_b_askkey()
#DEFINE
#    l_wc2           LIKE type_file.chr1000      #No.FUN-680073 VARCHAR(200)
#
#    CONSTRUCT g_wc2 ON ecb03,ecb06,ecb17,ecb08,ecb07,ecb38,ecb04,ecb19,ecb18,
#                       ecb21,ecb20,
#&ifdef SLK
#                       ecbslk05,ecbslk04,ecbslk02,                             #No.FUN-810017
#&endif
#                       ecb66,ecb39,ecb40,                                      #FUN-A80150 add ecb66
##                      ecb41,ecb42,ecb43,ecb44,ecb45,                          #No.FUN-810017  #FUN-A50081
#                       ecb41,ecb42,ecb43,      ecb45,                          #FUN-A50081
#                       ecb46,ecb48,ecb49,                          #FUN-960056 add ecb48,ecb49
#                       ecbud01,ecbud02,ecbud03,ecbud04,ecbud05,
#                       ecbud06,ecbud07,ecbud08,ecbud09,ecbud10,
#                       ecbud11,ecbud12,ecbud13,ecbud14,ecbud15
#
#            FROM s_ecb[1].ecb03,s_ecb[1].ecb06,s_ecb[1].ecb17,
#                 s_ecb[1].ecb08,s_ecb[1].ecb07,s_ecb[1].ecb38,s_ecb[1].ecb04,
#                 s_ecb[1].ecb19,s_ecb[1].ecb18,s_ecb[1].ecb21,
#                 s_ecb[1].ecb20,
#&ifdef SLK
#                 s_ecb[1].ecbslk05,s_ecb[1].ecbslk04,            #No.FUN-810017
#                 s_ecb[1].ecbslk02,                              #No.FUN-810017
#&endif
#                 s_ecb[1].ecb66,s_ecb[1].ecb39,s_ecb[1].ecb40,  #FUN-A80150 add ecb66
#                 s_ecb[1].ecb41,s_ecb[1].ecb42,s_ecb[1].ecb43,
##                s_ecb[1].ecb44,s_ecb[1].ecb45,s_ecb[1].ecb46,  #FUN-A50081
#                                s_ecb[1].ecb45,s_ecb[1].ecb46,  #FUN-A50081
#                 s_ecb[1].ecb48,s_ecb[1].ecb49,                  #FUN-960056
#                 s_ecb[1].ecbud01,s_ecb[1].ecbud02,s_ecb[1].ecbud03,
#                 s_ecb[1].ecbud04,s_ecb[1].ecbud05,
#                 s_ecb[1].ecbud06,s_ecb[1].ecbud07,s_ecb[1].ecbud08,
#                 s_ecb[1].ecbud09,s_ecb[1].ecbud10,
#                 s_ecb[1].ecbud11,s_ecb[1].ecbud12,s_ecb[1].ecbud13,
#                 s_ecb[1].ecbud14,s_ecb[1].ecbud15
#
#              BEFORE CONSTRUCT
#                 CALL cl_qbe_init()
#
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
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
#                 ON ACTION qbe_select
#         	   CALL cl_qbe_select()
#                 ON ACTION qbe_save
#		   CALL cl_qbe_save()
#    END CONSTRUCT
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
#    CALL i100_b_fill(l_wc2)
#END FUNCTION
#FUN-B90117--end

FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000      #No.FUN-680073 VARCHAR(200)

IF cl_null(g_wc2) THEN LET g_wc2=' 1=1' END IF  #No.FUN-810017
    LET g_sql =
        "SELECT ecb03,ecb06,ecb17,ecb08,' ','',ecb07,'',ecb38,ecb04,ecb19,ecb18,",
        " ecb21,ecb20,ecbslk05,ecbslk04,ecbslk02,ecbslk01,ecb66,ecb39,ecb25,ecb40,ecb41,",  #No.FUN-810017   #FUN-A80150 add ecb66 #NO.TQC-BC0166 add ecbslk01 #CHI-C70033 ecb25
#       " ecb42,ecb43,ecb44,ecb45,ecb46,ecb48,ecb49,",                 #No.FUN-810017 #FUN-960056 add ecb48,ecb49  #FUN-A50081
        #" ecb42,ecb43,ecb45,ecb46,ecb51,ecb14,ecb52,ecb53,ecb48,ecb49,",                 #FUN-A50081  #CHI-C70033
        " ecb42,ecb43,ecb45,ecb46,ecb51,ecb14,ecb52,ecb53,ecb48,",  #CHI-C70033
        " ecbud01,ecbud02,ecbud03,ecbud04,ecbud05,",
        " ecbud06,ecbud07,ecbud08,ecbud09,ecbud10,",
        " ecbud11,ecbud12,ecbud13,ecbud14,ecbud15",
        " FROM ecb_file",
        " WHERE ecb01 ='",g_ecu.ecu01,"'",
        "   AND ecb02 ='",g_ecu.ecu02,"'",
        "   AND ecb012 = '",g_ecu.ecu012,"'",   #FUN-A50081
        "   AND ",g_wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE i100_pb FROM g_sql
    DECLARE ecb_curs CURSOR FOR i100_pb

    CALL g_ecb.clear()

    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH ecb_curs INTO g_ecb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT eca02 INTO g_ecb[g_cnt].eca02 FROM eca_file
       WHERE eca01 = g_ecb[g_cnt].ecb08
      IF SQLCA.sqlcode THEN LET g_ecb[g_cnt].eca02 = ' ' END IF
      SELECT vmn08,vmn081
        INTO g_ecb[g_cnt].vmn08,g_ecb[g_cnt].vmn081
        FROM vmn_file
       WHERE vmn01 = g_ecu.ecu01
         AND vmn02 = g_ecu.ecu02
         AND vmn03 = g_ecb[g_cnt].ecb03
         AND vmn04 = g_ecb[g_cnt].ecb06
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_ecb.deleteElement(g_cnt)

    LET g_rec_b=g_cnt -1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

#FUN-B90117--add Begin--
#填充树
FUNCTION i100_tree_fill_1(p_ecu01,p_ecu02,p_ecu012)
DEFINE p_level      LIKE type_file.num5,
       l_child      INTEGER
DEFINE p_ecu01        LIKE ecu_file.ecu01
DEFINE p_ecu02        LIKE ecu_file.ecu02
DEFINE p_ecu012       LIKE ecu_file.ecu012

   INITIALIZE g_tree TO NULL
    LET p_level = 0
    LET g_idx = 0

   CALL i100_tree_fill_2(NULL,p_level,p_ecu01,p_ecu02,p_ecu012)
END FUNCTION

#填充树的父亲节点
FUNCTION i100_tree_fill_2(p_pid,p_level,p_ima01,p_ecu02,p_ecu012)
DEFINE p_level           LIKE type_file.num5,
       p_pid             STRING,
       l_child           INTEGER
DEFINE p_ima01           LIKE ima_file.ima01
DEFINE p_ecu02           LIKE ecu_file.ecu02
DEFINE p_ecu012          LIKE ecu_file.ecu012
DEFINE l_loop            INTEGER
DEFINE l_ecu          DYNAMIC ARRAY OF RECORD
            ecu012      LIKE ecu_file.ecu012,
            ecu014      LIKE ecu_file.ecu014
            END RECORD
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_ecb03         LIKE ecb_file.ecb03
DEFINE l_ecb06         LIKE ecb_file.ecb06
DEFINE l_ecb17         LIKE ecb_file.ecb17
DEFINE l_n             LIKE type_file.num10
DEFINE l_n1            LIKE type_file.num10

   LET g_sql = "SELECT ecu012,ecu014 FROM ecu_file LEFT OUTER JOIN ecr_file",
               "    ON ecu012 = ecr01 ",
              #" WHERE ecu015 IS NULL AND ecu012='",p_ecu012,"' ",  #MOD-D10062 mark
               " WHERE ecu015 IS NULL ",                            #MOD-D10062 add
               " AND ecu01 ='",p_ima01,"' AND ecu02='",p_ecu02,"' ORDER BY ecu012 "
   PREPARE i100_tree_pre1 FROM g_sql
   DECLARE i100_tree_cs1 CURSOR FOR i100_tree_pre1
   LET l_loop = 1
   LET l_cnt = 1
   LET p_level = p_level + 1
   CALL l_ecu.clear()

   FOREACH i100_tree_cs1 INTO l_ecu[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH

   FREE i100_tree_cs1
   CALL l_ecu.deleteelement(l_cnt)
   LET l_cnt = l_cnt - 1
   IF l_cnt >0 THEN
      FOR l_loop=1 TO l_cnt
          LET g_idx = g_idx + 1
          LET g_tree[g_idx].expanded = 1          #0:不展, 1:展
          LET g_tree[g_idx].name = l_ecu[l_loop].ecu012,':',l_ecu[l_loop].ecu014
          LET g_tree[g_idx].id = l_ecu[l_loop].ecu012
          LET g_tree[g_idx].pid = p_pid
          LET g_tree[g_idx].has_children = FALSE
          LET g_tree[g_idx].level = p_level
          LET g_tree[g_idx].desc = p_ima01
          LET g_tree[g_idx].chk = 'N'

          ###填充单身的内容到树结构###
          LET g_sql = "SELECT ecb03,ecb06,ecb17 FROM ecb_file WHERE ecb01='",p_ima01,"' ",
                      " AND ecb02='",p_ecu02,"' ",
                      " AND ecb012='",l_ecu[l_loop].ecu012,"'"
          PREPARE ecb_pb1 FROM g_sql
          DECLARE ecb03_inrt CURSOR FOR ecb_pb1

          LET l_ecb03=''
          LET l_n=p_level+1
          LET l_n1=g_idx
          FOREACH ecb03_inrt INTO l_ecb03,l_ecb06,l_ecb17
             LET l_n1=l_n1+1
             LET g_tree[l_n1].expanded = 1          #0:不展, 1:展
             LET g_tree[l_n1].name = l_ecb03,"--",l_ecb06,"--",l_ecb17
             LET g_tree[l_n1].id = l_ecb03
             LET g_tree[l_n1].pid = l_ecu[l_loop].ecu012
             LET g_tree[l_n1].has_children = FALSE
             LET g_tree[l_n1].level = l_n
             LET g_tree[l_n1].desc = p_ima01
             LET g_tree[l_n1].chk = 'Y'

          END FOREACH

          ###填充单身的内容到树结构###

          SELECT COUNT(*) INTO l_child FROM ecu_file
                 WHERE ecu015 = l_ecu[l_loop].ecu012
                   AND ecu01 = p_ima01
                   AND ecu02 = p_ecu02
          #存在子节点的情况
          IF l_child > 0  THEN
             LET g_tree[g_idx].has_children = TRUE
             LET g_idx=l_n1
             CALL i100_tree_fill(l_ecu[l_loop].ecu012,g_tree[g_idx].desc,p_level,g_idx,p_ecu02)
          ELSE
             IF l_n1>g_idx THEN
                LET g_tree[g_idx].has_children = TRUE
             END IF
             LET g_idx=l_n1
          END IF


       END FOR
    END IF
END FUNCTION

#填充子节点
FUNCTION i100_tree_fill(p_pid,p_tex,p_level,p_idx,p_ecu02)
DEFINE p_pid           LIKE ima_file.ima01              #父id
DEFINE p_tex           LIKE ima_file.ima01
DEFINE p_level         LIKE type_file.num5               #階層
DEFINE p_idx           LIKE type_file.num5              #父的数组下标
DEFINE p_ecu02         LIKE ecu_file.ecu02
DEFINE l_child         INTEGER
DEFINE l_ecu          DYNAMIC ARRAY OF RECORD
            ecu012     LIKE ecu_file.ecu012 ,
            ecu014     LIKE ecu_file.ecu014
                      END RECORD
DEFINE l_str           STRING
DEFINE max_level       LIKE type_file.num5               #最大階層數,可避免無窮迴圈.
DEFINE l_i             LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_ecb03         LIKE ecb_file.ecb03
DEFINE l_ecb06         LIKE ecb_file.ecb06
DEFINE l_ecb17         LIKE ecb_file.ecb17
DEFINE l_n             LIKE type_file.num10
DEFINE l_n1            LIKE type_file.num10

   LET max_level = 20          #設定最大階層數為20(和abmp611相同設定,之後改為傳參數)
   LET p_level = p_level + 1   #下一階層
   IF p_level > max_level THEN
      CALL cl_err_msg("","agl1001",max_level,0)
      RETURN
   END IF
   LET g_sql = "SELECT ecu012,ecu014 ",
               "  FROM ecu_file ",
               " WHERE ecu015 = '",p_pid,"' ",
               "   AND ecu01 ='",p_tex,"' ",
               "   AND ecu02 ='",p_ecu02,"'"

   PREPARE i100_tree_pre2 FROM g_sql
   DECLARE i100_tree_cs2 CURSOR FOR i100_tree_pre2

   LET l_cnt = 1
   CALL l_ecu.clear()
   FOREACH i100_tree_cs2 INTO l_ecu[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH

   FREE i100_tree_cs2
   CALL l_ecu.deleteelement(l_cnt)
   LET l_cnt = l_cnt - 1
      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid
            LET g_tree[g_idx].id = l_ecu[l_i].ecu012
            LET g_tree[g_idx].expanded = 1      #0:不展開, 1:展開
            LET g_tree[g_idx].name =l_ecu[l_i].ecu012,':',l_ecu[l_i].ecu014
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].desc = p_tex
            LET g_tree[g_idx].chk = 'N'
          ###填充单身的内容到树结构###
          LET g_sql = "SELECT ecb03,ecb06,ecb17 FROM ecb_file WHERE ecb01='",p_tex,"' ",
                      " AND ecb02='",p_ecu02,"' ",
                      " AND ecb012='",l_ecu[l_i].ecu012,"'"
          PREPARE ecb_pb2 FROM g_sql
          DECLARE ecb03_inrt2 CURSOR FOR ecb_pb2

          LET l_ecb03=''
          LET l_n=p_level+1
          LET l_n1=g_idx
          FOREACH ecb03_inrt2 INTO l_ecb03,l_ecb06,l_ecb17
             LET l_n1=l_n1+1
             LET g_tree[l_n1].expanded = 1          #0:不展, 1:展
             LET g_tree[l_n1].name = l_ecb03,"--",l_ecb06,"--",l_ecb17
             LET g_tree[l_n1].id = l_ecb03
             LET g_tree[l_n1].pid = l_ecu[l_i].ecu012
             LET g_tree[l_n1].has_children = FALSE
             LET g_tree[l_n1].level = l_n
             LET g_tree[l_n1].desc = p_tex
             LET g_tree[l_n1].chk = 'Y'

          END FOREACH

          ###填充单身的内容到树结构###


            SELECT COUNT(*) INTO l_child FROM ecu_file
             WHERE ecu015 = l_ecu[l_i].ecu012
               AND ecu01 = p_tex
               AND ecu02 = p_ecu02

            LET g_tree[g_idx].has_children = FALSE
            IF l_child > 0 THEN
               LET g_tree[g_idx].has_children = TRUE
               LET g_idx=l_n1
               CALL i100_tree_fill(g_tree[g_idx].id,g_tree[g_idx].desc,p_level,g_idx,p_ecu02)
            ELSE
               IF l_n1>g_idx THEN
                  LET g_tree[g_idx].has_children = TRUE
               END IF
               LET g_idx=l_n1
            END IF
          END FOR
      END IF
END FUNCTION
#FUN-B90117--add END--

FUNCTION i100_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680073 VARCHAR(1)
  DEFINE   l_wc   LIKE type_file.chr1000      #FUN-B90117

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

#FUN-B90117--Begin--
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_tree TO tree.*
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_tree_ac = ARR_CURR()
            LET g_curr_idx = ARR_CURR()
           # CALL i100_b_init()
           IF g_tree[g_curr_idx].chk='N' THEN
              LET g_ecu.ecu012= g_tree[g_curr_idx].id
              SELECT * INTO g_ecu.* FROM ecu_file
               WHERE ecu01=g_ecu.ecu01
                 AND ecu02=g_ecu.ecu02
                 AND ecu012=g_ecu.ecu012
              CALL i100_show()
              CALL i100_show_head()
              CALL i100_b_fill('1=1')
           ELSE
              LET g_ecu.ecu012= g_tree[g_curr_idx].pid
              SELECT * INTO g_ecu.* FROM ecu_file
               WHERE ecu01=g_ecu.ecu01
                 AND ecu02=g_ecu.ecu02
                 AND ecu012=g_ecu.ecu012
              CALL i100_show()
              CALL i100_show_head()
              LET l_wc=" ecb03=",g_tree[g_curr_idx].id
              CALL i100_b_fill(l_wc)
           END IF

         #TQC-C30136--mark--str--
         ####双击进单身 ####
         #ON ACTION accept
         #   LET g_action_choice="detail"
         #   LET l_ac = 1
         #   EXIT DIALOG
         #TQC-C30136--mark--end-- 

      END DISPLAY
#FUN-B90117--END--

#  DISPLAY ARRAY g_ecb TO s_ecb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #FUN-B90117
   DISPLAY ARRAY g_ecb TO s_ecb.* ATTRIBUTE(COUNT=g_rec_b)              #FUN-B90117
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()  #TQC-B60171
         IF g_sma.sma901!='Y' THEN
            CALL cl_set_act_visible("aps_related_data_aps_ecu",FALSE) #TQC-750013 add
            CALL cl_set_act_visible("aps_related_data_aps_ecb",FALSE) #TQC-750013 add
            CALL cl_set_act_visible("aps_displace_vms",FALSE) #FUN-870012
            CALL cl_set_act_visible("aps_route_tools",FALSE) #FUN-890096
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

#FUN-B90117--Begin--
      AFTER DISPLAY
         CONTINUE DIALOG

       #TQC-C30136--mark--str--
       #ON ACTION accept
       #  LET g_action_choice="detail"
       #  LET l_ac = ARR_CURR()
       #  EXIT DIALOG
       #TQC-C30136--mark--end--
   END DISPLAY

    BEFORE DIALOG
        LET l_tree_ac = 1
        LET l_ac = 1
#FUN-B90117--END--


      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
#        EXIT DISPLAY                    #FUN-B90117
         EXIT DIALOG                     #FUN-B90117
      ON ACTION query
         LET g_action_choice="query"
#        EXIT DISPLAY                    #FUN-B90117
         EXIT DIALOG                     #FUN-B90117
      ON ACTION delete
         LET g_action_choice="delete"
#        EXIT DISPLAY                    #FUN-B90117
         EXIT DIALOG                     #FUN-B90117
      ON ACTION modify
         LET g_action_choice="modify"
#        EXIT DISPLAY                    #FUN-B90117
         EXIT DIALOG                     #FUN-B90117
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST    #FUN-B90117
         ACCEPT DIALOG                                               #FUN-B90117


      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST    #FUN-B90117
         ACCEPT DIALOG                                               #FUN-B90117


      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST    #FUN-B90117
         ACCEPT DIALOG                                               #FUN-B90117


      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST    #FUN-B90117
         ACCEPT DIALOG                                               #FUN-B90117


      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST    #FUN-B90117
         ACCEPT DIALOG                                               #FUN-B90117


      ON ACTION reproduce
         LET g_action_choice="reproduce"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
      ON ACTION help
         LET g_action_choice="help"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CALL i100_show_pic()                      #No.FUN-810017
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117

      ON ACTION exit
         LET g_action_choice="exit"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117

#FUN-A50081 --begin--
      ON ACTION chkbom
         LET g_action_choice = "chkbom"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
#FUN-A50081 --end--

      #FUN-AC0076 add --------------begin---------------
      #ON ACTION 資源耗損
      ON ACTION haosun
         LET g_action_choice="haosun"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
      #FUN-AC0076 add ---------------end----------------

#@    ON ACTION 明細製程維護
      ON ACTION routing_details
         LET g_action_choice="routing_details"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
#@    ON ACTION 資源項目維護
      ON ACTION resource_fm
         LET g_action_choice="resource_fm"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
#@    ON ACTION APS相關資料
      ON ACTION aps_related_data_aps_ecb
         LET g_action_choice="aps_related_data_aps_ecb"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
      ON ACTION aps_displace_vms
         LET g_action_choice="aps_displace_vms"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
      ON ACTION aps_route_tools
         LET g_action_choice="aps_route_tools"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117

      ON ACTION mntn_desc
         LET g_action_choice="mntn_desc"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117

#FUN-BC0062 --begin--  #TQC-C30136--unmark--str--
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
#FUN-BC0062 --end--    #TQC-C30136--unmark--end--

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
#        CONTINUE DISPLAY            #FUN-B90117
         CONTINUE DIALOG             #FUN-B90117

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117
      ON ACTION related_document                #No.FUN-6A0039  相關文件
         LET g_action_choice="related_document"
#        EXIT DISPLAY                #FUN-B90117
         EXIT DIALOG                 #FUN-B90117

        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
              CALL i100_confirm()
              CALL i100_show()
           END IF

        ON ACTION notconfirm
           LET g_action_choice="notconfirm"
           IF cl_chk_act_auth() THEN
              CALL i100_notconfirm()

              CALL i100_show()
           END IF

        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth()
              THEN CALL i100_out()
           END IF
        #CHI-C90006---begin
        ON ACTION invalid
           LET g_action_choice="invalid"
           IF cl_chk_act_auth() THEN
              CALL i100_x()
           END IF 
        #CHI-C90006---end
#FUN-B90117--mark--
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#FUN-B90117--mark--

      &include "qry_string.4gl"

#  END DISPLAY    #FUN-B90117
   END DIALOG     #FUN-B90117
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

#FUN-B90117--add--BEGIN--
FUNCTION i100_show_head()
  DEFINE l_ecr02 LIKE ecr_file.ecr02

  SELECT ecr02 INTO g_ecu.ecu014 FROM ecr_file WHERE ecr01=g_ecu.ecu012

  DISPLAY BY NAME g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu03,g_ecu.ecu04,g_ecu.ecu05,g_ecu.ecu012,g_ecu.ecu014,
                  g_ecu.ecu015,g_ecu.ecu10,g_ecu.ecu11,g_ecu.ecuud07

  LET l_ecr02=''
  SELECT ecr02 INTO l_ecr02 FROM ecr_file WHERE ecr01=g_ecu.ecu015
  DISPLAY l_ecr02 TO ecr02
  CALL i100_show_pic()
END FUNCTION
#FUN-B90117--add-end--

FUNCTION i100_ecb06(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1,         #No.TQC-6A0065
    l_ecdacti       LIKE ecd_file.ecdacti

    LET g_errno = ' '
       SELECT ecd01,ecd02,ecd07,ecdacti INTO
              g_ecb[l_ac].ecb06,g_ecb[l_ac].ecb17,g_ecb[l_ac].ecb08,l_ecdacti
         FROM ecd_file
        WHERE ecd01 = g_ecb[l_ac].ecb06
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aec-015'
                                      LET g_ecb[l_ac].ecb06 = NULL
                                      LET g_ecb[l_ac].ecb17 = NULL
                                      #------No.MOD-530167-------------
                                      LET g_ecb[l_ac].ecb08 = NULL
                                      LET g_ecb[l_ac].eca02 = NULL
                                      #-----No.MOD-530167 END--------
            WHEN l_ecdacti='N' LET g_errno = '9028'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       DISPLAY BY NAME g_ecb[l_ac].ecb06
       DISPLAY BY NAME g_ecb[l_ac].ecb17
       DISPLAY BY NAME g_ecb[l_ac].ecb08

END FUNCTION

FUNCTION i100_ecb08(p_cmd)
DEFINE p_cmd          LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(01)
       l_ecaacti      LIKE eca_file.ecaacti

    LET g_errno = ''
    SELECT eca02,ecaacti INTO g_ecb[l_ac].eca02,l_ecaacti
      FROM eca_file
     WHERE eca01 = g_ecb[l_ac].ecb08
      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aec-054'
                                     LET g_ecb[l_ac].ecb08 = NULL
           WHEN l_ecaacti='N'        LET g_errno = '9028'
          OTHERWISE                  LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      DISPLAY BY NAME g_ecb[l_ac].eca02
END FUNCTION

FUNCTION i100_ecu01(p_cmd)  #料件編號
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_imaacti LIKE ima_file.imaacti,
           p_cmd     LIKE type_file.chr1         #No.FUN-680073 VARCHAR(1)

  LET g_errno = " "
  SELECT ima02,ima021,imaacti,ima55
         INTO l_ima02,l_ima021,l_imaacti,g_ima55 FROM ima_file
         WHERE ima01 = g_ecu.ecu01

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL  LET l_imaacti = NULL
                                 LET l_ima021=NULl
       WHEN l_imaacti='N'        LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_ima02 TO FORMONLY.ima02
     DISPLAY l_ima021 TO FORMONLY.ima021
  END IF
END FUNCTION


FUNCTION i100_aps_ecb(p_cmd) #TQC-8C0016 加入參數p_cmd
    DEFINE  l_vmn       RECORD LIKE vmn_file.*   #NO.FUN-7C0002 #No;FUN-810017 MARK
    DEFINE  p_cmd       LIKE type_file.chr1      #No.TQC-8C0016 add

         IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
         IF cl_null(g_ecu.ecu02) THEN
             CALL cl_err('',-400,1)
             RETURN
         END IF
         IF cl_null(g_ecb[l_ac].ecb03) OR
            cl_null(g_ecb[l_ac].ecb06) THEN
             CALL cl_err('','arm-034',1)
             RETURN
         END IF
         LET l_vmn.vmn01  = g_ecu.ecu01
         LET l_vmn.vmn02  = g_ecu.ecu02
         LET l_vmn.vmn03  = g_ecb[l_ac].ecb03
         LET l_vmn.vmn04  = g_ecb[l_ac].ecb06
         #FUN-B50101 add---str---
         IF cl_null(g_ecu.ecu012) THEN
             LET g_ecu.ecu012 = ' '
         END IF
         LET l_vmn.vmn012 = g_ecu.ecu012
         #FUN-B50101 add---end---
         SELECT * FROM vmn_file
          WHERE vmn01 = l_vmn.vmn01
            AND vmn02 = l_vmn.vmn02
            AND vmn03 = l_vmn.vmn03
            AND vmn04 = l_vmn.vmn04
            AND vmn012 = l_vmn.vmn012 #FUN-B50101 add
         IF SQLCA.SQLCODE=100 THEN
            LET l_vmn.vmn01 = g_ecu.ecu01
            LET l_vmn.vmn02 = g_ecu.ecu02
            LET l_vmn.vmn03  = g_ecb[l_ac].ecb03
            LET l_vmn.vmn04  = g_ecb[l_ac].ecb06
            LET l_vmn.vmn08  = g_ecb[l_ac].vmn08
            LET l_vmn.vmn081 = g_ecb[l_ac].vmn081
            LET l_vmn.vmn09 = 0
            LET l_vmn.vmn12 = 0
            LET l_vmn.vmn13 = 1
            LET l_vmn.vmn15 = 0
            LET l_vmn.vmn16 = 9999
            LET l_vmn.vmn17 = 1
            LET l_vmn.vmn19 = 0 #FUN-8C0028 ADD
            LET l_vmn.vmn012 = g_ecu.ecu012       #FUN-B50101 add
            LET l_vmn.vmnlegal = g_legal          #FUN-B50101 add
            LET l_vmn.vmnplant = g_plant          #FUN-B50101 add
            INSERT INTO vmn_file VALUES(l_vmn.*)
               IF STATUS THEN
                 CALL cl_err3("ins","vmn_file",l_vmn.vmn01,l_vmn.vmn02,SQLCA.sqlcode,
                               "","",1)
               ELSE
                    #FUN-B60152---add----str---
                    UPDATE ecu_file
                       SET ecudate = g_today
                     WHERE ecu01 = l_vmn.vmn01
                       AND ecu02 = l_vmn.vmn02
                    #FUN-B60152---add----end---
               END IF
         END IF
         LET g_cmd = "apsi312 '",l_vmn.vmn01,"' '",l_vmn.vmn02,"' '",l_vmn.vmn03,"' '",l_vmn.vmn04,"' '",g_ecb[l_ac].ecb39,"' '",l_vmn.vmn012,"'" #FUN-B50101 add vmn012
         IF p_cmd = 'Y' THEN #TQC-8C0016 add if 判斷
             CALL cl_cmdrun(g_cmd)
         END IF
END FUNCTION

FUNCTION i100_aps_vms()
   LET g_cmd = "apsi326 '",g_ecu.ecu01,"' '",g_ecu.ecu02,"' '",g_ecb[l_ac].ecb03,"' '",g_ecu.ecu012,"'"  #FUN-A50081 add ecu012
   CALL cl_cmdrun(g_cmd)
END FUNCTION

FUNCTION i100_aps_vnm()
  LET g_cmd = "apsi331 '",g_ecu.ecu01,"' '",g_ecu.ecu02,"' '",g_ecb[l_ac].ecb03,"' '",g_ecb[l_ac].ecb06,"' '",g_ecu.ecu012,"'"  #FUN-A50081 add ecu012
  CALL cl_cmdrun(g_cmd)
END FUNCTION

FUNCTION i100_out()
  DEFINE l_cmd     LIKE type_file.chr1000

     IF g_ecu.ecu01 IS NOT NULL AND g_ecu.ecu01 != ' ' THEN
#TQC-AC0245 ---------------------------Begin---------------------------------------
        IF cl_null(g_wc) THEN
           LET g_wc = "ecu01 = '",g_ecu.ecu01,"'"
        END IF
#TQC-AC0245 ---------------------------End-----------------------------------------
       #LET l_cmd = 'aecr620 ','"',g_today,'"',    #FUN-C30085 mark
        LET l_cmd = 'aecg620 ','"',g_today,'"',    #FUN-C30085 add
                    ' "" "',g_lang,'" "Y" "" "" ',
                    '"',g_wc CLIPPED,'"',' "N" "Y" "Y" "Y" "" "" "" "aeci100" "Y"' CLIPPED
        CALL cl_cmdrun(l_cmd)
     END IF
END FUNCTION

#FUN-9A0047---add----str----
FUNCTION i100_chk_aps()
 DEFINE l_aps_err LIKE type_file.chr1
 DEFINE l_vmn08   LIKE vmn_file.vmn08
 DEFINE l_ecb     RECORD LIKE ecb_file.*

  CALL s_showmsg_init()
  DECLARE i100_chk_aps CURSOR FOR
     SELECT *
       FROM ecb_file
      WHERE ecb01 = g_ecu.ecu01
        AND ecb02 = g_ecu.ecu02

  LET l_aps_err = 'N'
  FOREACH i100_chk_aps INTO l_ecb.*
    IF SQLCA.SQLCODE THEN
       CALL cl_err('aps chk:',SQLCA.SQLCODE,0)
       EXIT FOREACH
    END IF
    IF g_sma.sma917 = 1 THEN #機器編號
        LET l_vmn08 = NULL #FUN-A40060 add
        SELECT vmn08 INTO l_vmn08
          FROM vmn_file
         WHERE vmn01 = g_ecu.ecu01     #料號
           AND vmn02 = g_ecu.ecu02     #製程
           AND vmn03 = l_ecb.ecb03     #加工序號
           AND vmn04 = l_ecb.ecb06     #作業編號
        IF l_ecb.ecb39 = 'N' THEN
            IF cl_null(l_ecb.ecb07) AND cl_null(l_vmn08) THEN
                #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
                CALL cl_getmsg('aps-033',g_lang) RETURNING g_showmsg
                LET g_showmsg = l_ecb.ecb03,'==>',g_showmsg
                CALL s_errmsg('ecb03',g_showmsg,l_ecb.ecb01,STATUS,1)
                LET l_aps_err = 'Y'
            END IF
        END IF
    END IF
    INITIALIZE l_ecb.* TO NULL #FUN-A40060 add
  END FOREACH
  IF l_aps_err = 'Y' THEN
      CALL s_showmsg()
      RETURN 1
  ELSE
      RETURN 0
  END IF

END FUNCTION
#FUN-9A0047---add----end----
#FUN-B90141 --START--            
FUNCTION i100_chk_ecu51()
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_fac    LIKE type_file.num26_10
DEFINE l_fac2   LIKE type_file.num26_10
DEFINE l_ima55  LIKE ima_file.ima55

   IF cl_null(g_ecb[l_ac].ecb46) OR cl_null(g_ecb[l_ac].ecb51) THEN
     #RETURN TRUE 
      RETURN FALSE        #MOD-C20166 add
   END IF  

   SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=g_ecu.ecu01
   
   CALL s_umfchk(g_ecu.ecu01,g_ecb[l_ac].ecb45,l_ima55)
                            RETURNING l_flag,l_fac
   IF l_flag THEN
      CALL cl_err('','abm-731',1)
      RETURN 
      FALSE        #MOD-C20166 add
   END IF       
   LET l_fac2 = g_ecb[l_ac].ecb51 / g_ecb[l_ac].ecb46  
   
   IF NOT s_industry('icd') THEN  #MOD-C30386
     #IF l_fac != l_fac2 THEN   #MOD-D40052 mark
      IF l_fac < l_fac2 THEN   #MOD-D40052 add
         CALL cl_err('','aec-069',1)
         RETURN FALSE    
      END IF    
   END IF #MOD-C30386
   
   RETURN TRUE                     
END FUNCTION 
#FUN-B90141 --END--  
#No.FUN-9C0077 程式精簡
#FUN-B50046
#FUN-B80046
#FUN-BB0083---add---str
FUNCTION i100_ecb52_check()
#ecb52 的單位 ecb45   
   IF NOT cl_null(g_ecb[l_ac].ecb45) AND NOT cl_null(g_ecb[l_ac].ecb52) THEN
      IF cl_null(g_ecb_t.ecb52) OR cl_null(g_ecb45_t) OR g_ecb_t.ecb52 != g_ecb[l_ac].ecb52 OR g_ecb45_t != g_ecb[l_ac].ecb45 THEN 
         LET g_ecb[l_ac].ecb52=s_digqty(g_ecb[l_ac].ecb52,g_ecb[l_ac].ecb45)
         DISPLAY BY NAME g_ecb[l_ac].ecb52  
      END IF  
   END IF
   IF cl_null(g_ecb[l_ac].ecb52) THEN
      RETURN FALSE
   ELSE
      IF g_ecb[l_ac].ecb52 < 0 THEN
         CALL cl_err('','aim-223',0)
         RETURN FALSE
      END IF
   END IF
RETURN TRUE

END FUNCTION
#FUN-BB0083---add---end
#CHI-C90006---begin
FUNCTION i100_x()
DEFINE l_chr LIKE type_file.chr1

    IF g_ecu.ecu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ecu.ecu10 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    BEGIN WORK
    
    OPEN i100_cl USING g_ecu.ecu01,g_ecu.ecu02,g_ecu.ecu012 
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i100_cl INTO g_ecu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock ecu:',SQLCA.sqlcode,0)
        CLOSE i100_cl ROLLBACK WORK RETURN
    END IF
    CALL i100_show()

    IF cl_exp(0,0,g_ecu.ecuacti) THEN
        LET l_chr = g_ecu.ecuacti
        IF g_ecu.ecuacti='Y' THEN
            LET g_ecu.ecuacti='N'
        ELSE
            LET g_ecu.ecuacti='Y'
        END IF
        UPDATE ecu_file
            SET ecuacti=g_ecu.ecuacti,ecudate = g_today     #FUN-D10063 add ecudate = g_today
            WHERE ecu01=g_ecu.ecu01
              AND ecu02=g_ecu.ecu02
              AND ecu012=g_ecu.ecu012
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_ecu.ecu01,SQLCA.sqlcode,0)
            LET g_ecu.ecuacti = l_chr
        END IF
        DISPLAY BY NAME g_ecu.ecuacti
        CALL i100_show_pic()
    END IF

    CLOSE i100_cl
    COMMIT WORK
END FUNCTION 
#CHI-C90006---end

