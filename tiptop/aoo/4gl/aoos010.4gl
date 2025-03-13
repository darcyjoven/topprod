# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aoos010.4gl
# Descriptions...: 整體管理系統基本參數設定
# Date & Author..: 91/06/26 By Lee
#                  91/11/25 By Lin 維護
# Memo...........: 上線後aza02,aza03,aza18不可更改,但程式尚未判斷
# Modify.........: 93/05/26 Lee aza18為重複定義使用之欄位, 因為在 zb02 中已
#                           有該使用者定義方式之欄位, 且在cl_user中, 決定該
#                           方式的值, 亦從zb02中取得, 造成此欄位之虛設, 在
#                           記錄程式使用時間時, 該方式立意甚佳, 但量甚大, 造
#                           成問題, 故若需統計時, 將aza18設為2, 可為統計, 若
#                           不統計時, 將該值設成1, (預設值)便不為統計
# Modify.........: 04/05/27 A112       Carrier add 是否使用集團間銷售預測
# Modify.........: 04/08/10 MOD-480104 Nicola  aza33,aza34,aza37不可小於零
# Modify.........: 04/11/23 MOD-4B0184 alex 增加查詢單身最大筆數 aza38
# Modify.........: 04/11/26 FUN-4B0075 alex 部門規範最大單身筆數均改為 3000
# Modify.........: 04/12/01 MOD-4B0312 saki 增加設定是否隱藏無權限action aza22
# Modify.........: 04/12/01 FUN-4C0064 saki 增加設定是否允許使用者隱藏單身欄位 aza39
# Modify.........: 05/03/17 FUN-530022 alex 增加顏色設定 aoos100 串入功能
# Modify.........: 05/03/25 MOD-530237 alex 移除 aza020 設定 (已移入 sma00)
# Modify.........: 05/04/04 FUN-540002 coco add Setting Report PDF logo
# Modify.........: 05/05/05 MOD-540182 saki 新增單據編號格式設定
# Modify.........: 05/05/23 FUN-550087 Danny  新增是否使用多屬性料件
# Modify.........: 05/05/30 FUN-540051 saki 新增金額格式設定
# Modify.........: 05/06/28 FUN-560245 Carol delete aza46:新增是否使用多屬性料件
# Modify.........: 05/07/27 FUN-570205 saki 單據編號長度更新後詢問zaa是否要更新
# Modify.........: 05/08/10 FUN-580006 ice 使用大陸版功能時,進項、銷項分別管控是否使用防偽稅控接口,有海關合同系統
# Modify.........: 05/08/19 MOD-580216 alex 移除aza03欄位
# Modify.........: 05/10/19 FUN-5A0126 echo 更動單據編號長度後，顯示異動提示訊息，再至p_zaa設定調整，而不直接改變p_zaa中對應屬性的隱藏碼或長度
# Modify.........: 05/10/28 FUN-5A0207 echo 判斷aza23欄位是否勾選, 提示或自動UPDATE cpa120 & cpa121欄位
# Modify.........: 05/11/25 FUN-5B0134 yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: 06/01/05 FUN-610014 vivien 增加新的欄位
# Modify.........: 06/03/27 FUN-630066 Ray 增加新的欄位
# Modify.........: 06/04/04 FUN-630024 Echo 新增設定動態附檔名代號
# Modify.........: 06/04/19 FUN-640207 Alextsar 客戶需要之新功能:(高鼎)
#                                               cl_doc 相關文件功能是否可限制『一張單最多相關資料筆數、每筆夾檔最大容量』
# Modify.........: 06/05/24 FUN-650032 Sarah aza26!='2'中國時, aza27,aza25,aza46,aza47,aza48 清為'N', aza48隱藏
# Modify.........: 06/06/05 FUN-660011 Echo 在aoos010新增一頁籤:報表設定,把相關的報表設定參數都拉進此頁籤
# Modify.........: 06/06/14 FUN-610019 Echo 加班單(cpa121)設定移至apyi070.
# Modify.........: 06/06/20 FUN-620044 alexstar 在 aoos010 加上兩個參數 : A. TIPTOP 主機內部 IP
# Modify.........: 06/06/23 FUN-660048 Echo 增加「報表輸出是否與Express整合」欄位
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
#                                                                         B. TIPTOP 主機外部 IP
# Modify.........: 06/07/14 FUN-670040 cl 新增欄位[使用多帳套功能]
# Modify.........: 06/07/24 FUN-670031 Joe 新增欄位aza60,aza61,aza62三欄位
# Modify.........: 06/07/25 FUN-660132 By rainy remove aza04
# Modify.........: 06/08/09 FUN-680010 By Joe add aza64,aza65
# Modify.........: No.FUN-680102 06/09/13 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0081 06/11/01 By atsea g_time轉g_time
# Modify.........: No.FUN-6B0006 06/11/07 By alexstar 欲列印的資料超過p_zaa裡的設定值時，該欄位的列印方式(全印或是用###替代)
# Modify.........: No.FUN-690090 06/11/22 By Ray 增加集團代收(aza69)和集團代付(aza70)
# Modify.........: No.FUN-6C0040 06/12/29 Jack Lai 新增與GPM整合設定欄位
# Modify.........: No.FUN-710010 07/01/16 By chingyuan TIPTOP與EasyFlowGP整合
# Modify.........: No.FUN-710037 07/01/17 By kim aza50設為Noentry,改從asms290判斷
# Modify.........: No.FUN-720009 07/02/07 By kim 行業別架構變更
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.FUN-730032 07/03/20 By chenl   網絡銀行功能，此程序新增aza73，aza74兩個字段
# Modify.........: No.FUN-6B0036 07/04/03 by Brendan 新增與 Product Portal 整合設定欄位
# Modify.........: No.FUN-740032 07/04/13 By Carrier 會計科目加帳套-主財務帳套和主管理帳套不可相同
# Modify.........: No.TQC-740013 07/06/01 By Echo 有關請假單與EasyFlow串聯的訊息顯示應要檢查[使用功能別]為台灣或大陸,分開顯示訊息
# Modify.........: No.FUN-840077 08/04/21 By saki 使用者執行數限制
# Modify.........: No.FUN-850147 08/06/23 By Echo 新增與 MDM 整合設定欄位
# Modify.........: No.TQC-860038 08/06/24 By claire 加入 cl_used()
# Modify.........: No.FUN-870067 08/07/14 By douzh 新增匯豐銀行接口編碼(aza78)
# Modify.........: No.FUN-870101 08/07/22 By jamie 新增與 MES 整合設定欄位
# Modify.........: No.FUN-8A0130 08/10/29 by duke aza65 與SPC整合參數隱藏並註記 2008暫停使用
# Modify.........: No.FUN-8A0096 08/10/29 by Vicky 新增欄位aza91(Pruduction Portal整合-待辦事項)
# Modify.........: No.FUN-850121 08/12/30 By Sarah 開啟程式時,若aza63='N',aza82無須顯示
# Modify.........: No.FUN-930108 09/03/23 By zhaijie新增aza92使用料鍵承認申請單欄位
# Modify.........: No.FUN-860089 09/05/06 By Echo 新增 CR 報表資料功能
# Modify.........: No.FUN-870007 09/07/20 By Zhangyajun 流通零售功能新增
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-970108 09/09/02 BY Yiting add aza94 總機構彙總報繳
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9A0065 09/10/22 By hongmei add aza95(是否使用電子採購系統)
# Modify.........: No.FUN-A10056 10/01/12 By wuxj 去掉aza52,aza53
# Modify.........: No:FUN-9C0071 10/01/15 By huangrh 精簡程式
# Modify.........: No:FUN-A10109 10/02/08 by TSD.odyliao 單據編碼優化
# Modify.........: NO.TQC-A30088 10/03/17 By Carrier aza73/aza74/aza78 相互关系重整
# Modify.........: NO.TQC-A30089 10/04/08 By wujie   设定为单一帐套时把第二帐套清空
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版---str---
# Modify.........: NO.FUN-A10064 10/01/14 By Mandy add aza107,aza108 HR整合
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版---end---
# Modify.........: No:MOD-AB0118 10/11/12 By Dido 當faa06(財編是否與序號一致)為'Y'時,aza31(固定資產編號自動編碼否)不可為'Y'
# Modify.........: No:FUN-AC0086 10/12/28 By suncx 去掉多角貿易流程代碼自動編碼(aza89)栏位
# Modify.........: No:FUN-AC0084 10/12/29 By Lilan 新增aza123(是否與CRM整合)欄位
# Modify.........: NO.FUN-9A0095 11/03/30 By Abby add aza96 當與MES整合時,退料單是否從MES發起
# Modify.........: NO.FUN-B30202 11/04/01 By huangtao 新增欄位aza109 流通會員代號自動編碼
# Modify.........: NO.MOD-B60068 11/06/07 By Vampire 程式開始執行 當 aza23 = 'N' 時，aza72 不顯示在畫面上
# Modify.........: NO.FUN-A80018 11/06/21 By Abby 1.新增PLM整合欄位:aza121,aza122
# Modify.........:                                2.控卡aza121,aza60 不可同時勾選
# Modify.........: No.FUN-B50039 11/07/11 By xianghui 增加自訂欄位
# Modify.........: No.TQC-B70189 11/07/25 By lixia 隱藏aza74/aza78
# Modify.........: No.FUN-B90056 11/09/07 By yangxf 增加aza110，aza111，aza112，aza113四个栏位
# Modify.........: No.FUN-B80118 11/09/26 By Jay 和CROSS平台整合，待辦事項與Portal整合功能只須打勾
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:FUN-BB0005 11/11/07 BY LeoChang 新增報表TITLE是否呈現營運中心的參數讓user做選擇
# Modify.........: No:FUN-BB0068 11/11/18 By jrg542 原有aoos010設定執行程式紀錄移入 aoos900 (全系統共用，與aoos010每營運中心設定的方式不同)
# Modify.........: No:FUN-BB0049 12/01/12 By Carrier 增加aza125/aza126
# Modify.........: No:FUN-BA0015 12/01/17 By pauline 增加aza105,aza106盤點單邊碼原則欄位 
# Modify.........: No.CHI-C80044 12/08/01 by Belle aoo-082 錯誤檢核需在使用多帳別參數勾選時再check
# Modify.........: No:FUN-CA0121 12/11/19 By fengmy 主賬套、管理賬套和系統本位幣的幣種保持一致,僅大陸版
# Modify.........: No.FUN-C80092 12/12/10 By fengrui  刪除單身最大筆數小於3000的控管
# Modify.........: No:FUN-C50126 12/12/22 By Abby HRM功能改善--新增欄位(新流程:僅拋AP否aza127,整體帳款類別aza128)
# Modify.........: No:MOD-CC0036 12/12/27 By jt_chen 是否與HR整合未勾選時,應付單別aza108需隱藏
# Modify.........: No:FUN-CB0087 12/11/22 By qiull 增加參數，異動單據理由碼是否必輸
# Modify.........: No:FUN-D10093 13/01/20 By Abby 控卡aza121,aza60,aza92 不可同時勾選
# Modify.........: No:CHI-C90040 13/02/21 By Elise (1) aoos010系統參數設定的自動編號方式增加一個「5.依年期」
#                                                  (2) 原本依年月或依年月日都是抓azn04(期別),修正為不再判斷aoos020會計期間設定，直接依系統日期編號
#                                                  (3) 增加「5.依年期」的抓取邏輯
# Modify.........: No.CHI-B80015 13/03/12 By Alberti 已無人事薪資系統，aoo-025訊息mark掉
# Modify.........: No.DEV-D30026 13/03/15 By Nina GP5.3 追版:DEV-CA0001、DEV-CB0002為GP5.25 的單號
# Modify.........: No:FUN-D40074 13/04/19 By Abby HRM整合參數控卡調整(若aapi203未設定，僅需提示訊息，還是可以存檔)

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
        g_aza_t     RECORD LIKE aza_file.*,
        g_aza01_t   LIKE aza_file.aza01,
        g_aza02_t   LIKE aza_file.aza02,
        g_aza05_t   LIKE aza_file.aza05,
        g_aza06_t   LIKE aza_file.aza06,
        g_aza07_t   LIKE aza_file.aza07,
        g_aza09_t   LIKE aza_file.aza09,
        g_aza12_t   LIKE aza_file.aza12,
        g_aza16_t   LIKE aza_file.aza16,
        g_aza25_t   LIKE aza_file.aza25,
        g_aza46_t   LIKE aza_file.aza46,
        g_aza47_t   LIKE aza_file.aza47,
        g_aza51_t   LIKE aza_file.aza51,
        g_aza48_t   LIKE aza_file.aza48, #FUN-630066
        g_aza69_t   LIKE aza_file.aza69,
        g_aza70_t   LIKE aza_file.aza70,
        g_aza26_t   LIKE aza_file.aza26,
        g_aza17_t   LIKE aza_file.aza17,
        #g_aza18_t   LIKE aza_file.aza18,#No:FUN-BB0068 改到aoos900設定
        g_aza19_t   LIKE aza_file.aza19,
        g_aza21_t   LIKE aza_file.aza21,
        g_aza22_t   LIKE aza_file.aza22, #MOD-4B0312
        g_aza23_t   LIKE aza_file.aza23,
        g_aza24_t   LIKE aza_file.aza24,
        g_aza63_t   LIKE aza_file.aza63, #No.FUN-670040
        g_aza81_t   LIKE aza_file.aza81, #No.FUN-730020
        g_aza82_t   LIKE aza_file.aza82, #No.FUN-730020
        g_aza56_t   LIKE aza_file.aza56, #FUN-660011
        g_aza27_t   LIKE aza_file.aza27, #no.A047
        g_aza08_t   LIKE aza_file.aza08, #bugno:7255
        g_aza39_t   LIKE aza_file.aza39, #FUN-4C0064
        g_aza40_t   LIKE aza_file.aza40, #NO.A112
        g_aza50_t   LIKE aza_file.aza50, #FUN-610014
        g_aza44_t   LIKE aza_file.aza44, #NO.A112
        g_aza45_t   LIKE aza_file.aza45, #NO.A112
        g_aza49_t   LIKE aza_file.aza49, #FUN-630024
        g_aza93_t   LIKE aza_file.aza93, #FUN-860089
        g_aza57_t   LIKE aza_file.aza57, #FUN-660048
        g_aza64_t   LIKE aza_file.aza64, #FUN-680010
        g_aza65_t   LIKE aza_file.aza65, #FUN-680010
        g_aza66_t   LIKE aza_file.aza66, #FUN-6B0006
        g_aza71_t   LIKE aza_file.aza71, #FUN-6C0040
        g_aza72_t   LIKE aza_file.aza72, #No.FUN-710010
        g_aza73_t   LIKE aza_file.aza73, #No.FUN-730032
        g_aza74_t   LIKE aza_file.aza74, #No.FUN-730032
        g_aza78_t   LIKE aza_file.aza78, #No.FUN-870067
        g_aza83_t   LIKE aza_file.aza83, #No.FUN-840077
        g_aza85_t   LIKE aza_file.aza85, #FUN-850147
        g_aza86_t   LIKE aza_file.aza86, #FUN-850147
        g_aza90_t   LIKE aza_file.aza90, #FUN-870101 add
        g_aza94_t   LIKE aza_file.aza94, #FUN-970108 add
        g_aza96_t   LIKE aza_file.aza96  #FUN-9A0095 add
DEFINE  g_aza107_t  LIKE aza_file.aza107 #FUN-A10064 add
DEFINE  g_aza108_t  LIKE aza_file.aza108 #FUN-A10064 add
DEFINE  g_aza123_t  LIKE aza_file.aza123 #FUN-AC0084 add
DEFINE  g_aza109_t  LIKE aza_file.aza109 #FUN-B30202 add
DEFINE  g_aza110_t  LIKE aza_file.aza110 #FUN-B90056 add
DEFINE  g_aza111_t  LIKE aza_file.aza110 #FUN-B90056 add
DEFINE  g_aza112_t  LIKE aza_file.aza110 #FUN-B90056 add
DEFINE  g_aza113_t  LIKE aza_file.aza110 #FUN-B90056 add
DEFINE  g_aza121_t  LIKE aza_file.aza121 #FUN-A80018 add
DEFINE  g_aza122_t  LIKE aza_file.aza122 #FUN-A80018 add
DEFINE  g_aza124_t  LIKE aza_file.aza124 #FUN-BB0005 add
DEFINE  g_aza131_t  LIKE aza_file.aza131 #DEV-D30026 ADD
DEFINE  g_aza132_t  LIKE aza_file.aza132 #DEV-D30026 ADD
DEFINE  g_chkflag   LIKE type_file.num5  #FUN-A80018 add
DEFINE  g_chkflag2  LIKE type_file.num5  #FUN-D10093 add
DEFINE  g_forupd_sql STRING
DEFINE  g_before_input_done LIKE type_file.num5    #No.FUN-680102 SMALLINT
DEFINE  g_aza127_t  LIKE aza_file.aza127 #FUN-C50126 add
DEFINE  g_aza128_t  LIKE aza_file.aza128 #FUN-C50126 add

MAIN
    OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF

    #取得有關語言及日期型態的資料
    SELECT * INTO g_aza.* FROM aza_file WHERE aza01 = '0'
    IF SQLCA.sqlcode OR g_aza.aza01 IS NULL OR g_aza.aza01=' 'THEN
        LET g_aza.aza01 = "0"     # 1.
        #LET g_aza.aza18 = "1"    # 2. 使用login user #No:FUN-BB0068 aza18 改到aoos900設定
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW s010_w WITH FORM "aoo/42f/aoos010"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    CALL cl_set_combo_lang("aza45")

    CALL cl_set_comp_visible("aza25,aza46,aza47,aza27",g_aza.aza26 = '2')
    CALL cl_set_comp_visible("aza48",g_aza.aza26 = '2')

    CALL cl_set_comp_visible("aza72",g_aza.aza23 = 'Y')      #MOD-B60068 add
    CALL cl_set_comp_visible("aza74,aza78",FALSE)            #TQC-B70189

    CALL s010_show()

      LET g_action_choice=""
      CALL s010_menu()

    CLOSE WINDOW s010_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION s010_show()
DEFINE l_flag LIKE type_file.chr1

    DEFINE lc_azi02    LIKE azi_file.azi02
    DEFINE l_wap02     LIKE wap_file.wap02   #FUN-B80118

    SELECT * INTO g_aza.* FROM aza_file
     WHERE aza01='0'

    IF SQLCA.sqlcode OR g_aza.aza01 IS NULL THEN

        IF SQLCA.sqlcode=-284 THEN
            CALL cl_err3("sel","aza_file",g_aza.aza01,"",SQLCA.SQLCODE,"","ERROR!",1)   #No.FUN-660131
           DELETE FROM aza_file
        END IF

        LET g_aza.aza01 = "0"  #
        LET g_aza.aza02 = "1"  #會計期間
        LET g_aza.aza05 = "N"  #製造管理
        LET g_aza.aza06 = "N"  #總帳管理
        LET g_aza.aza07 = "N"  #應收帳款
        LET g_aza.aza08 = "N"  #專案管理
        LET g_aza.aza10 = "N"  #售後服務
        LET g_aza.aza11 = "N"  #條碼管理
        LET g_aza.aza12 = "N"  #應付帳款
        LET g_aza.aza13 = "N"  #決策支援
        LET g_aza.aza14 = "N"  #財務規劃
        LET g_aza.aza15 = "N"  #品質管理
        LET g_aza.aza16 = "N"  #製造管理
        LET g_aza.aza25 = "N"
        LET g_aza.aza46 = "N"  #進項防偽稅控 FUN-580006
        LET g_aza.aza47 = "N"  #銷項防偽稅控 FUN-580006
        LET g_aza.aza51 = "N"  #FUN-630039
        LET g_aza.aza48 = "N"  #FUN-630066
        LET g_aza.aza52 = "N"  #FUN-630039
        LET g_aza.aza53 = "N"  #FUN-630039
        LET g_aza.aza69 = "N"  #FUN-690090
        LET g_aza.aza70 = "N"  #FUN-690090
        LET g_aza.aza26 = "0"
        LET g_aza.aza17 = "TWD"#固定資管
        #LET g_aza.aza18 = "1" #login user #No:FUN-BB0068 aza18 改到aoos900設定
        LET g_aza.aza19 = "2"  #每日匯率
        LET g_aza.aza21 = "N"
        LET g_aza.aza94 = "N"  #FUN-970108
        LET g_aza.aza22 = "N"  #MOD-4B0312
        LET g_aza.aza23 = "N"
        LET g_aza.aza24 = "1"  #FUN-540002
        LET g_aza.aza56 = "1"  #FUN-660011
        LET g_aza.aza27 = "N"  #no.A047
        LET g_aza.aza08 = "N"  #bugno:7255
        LET g_aza.aza40 = "N"  #NO.A112
        LET g_aza.aza50 = "N"  #FUN-610014
        LET g_aza.aza28 = "Y"
        LET g_aza.aza29 = "Y"
        LET g_aza.aza30 = "Y"
        LET g_aza.aza31 = "Y"
        LET g_aza.aza109 = 'Y'     #FUN-B30202 add
        LET g_aza.aza110 = 'N'     #FUN-B90056 add
        LET g_aza.aza111 = 'N'     #FUN-B90056 add
        LET g_aza.aza112 = 'N'     #FUN-B90056 add
        LET g_aza.aza113 = 'Y'     #FUN-B90056 add
        LET g_aza.aza60 = "N"
        LET g_aza.aza61 = "N"
        LET g_aza.aza62 = "N"
        LET g_aza.aza92 = "N"      #FUN-930108 add
        LET g_aza.aza125= 'N'      #No.FUN-BB0049
        LET g_aza.aza126= 'N'      #No.FUN-BB0049
        LET g_aza.aza115= 'N'      #No.FUN-CB0087 add
        LET g_aza.aza35 = "Y"     
        LET g_aza.aza33 = 600     
        LET g_aza.aza34 = 500      #FUN-4B0075
        LET g_aza.aza38 = 500      #MOD-4B0184 FUN-4B0075
        LET g_aza.aza39 = "Y"      #FUN-4C0064
        LET g_aza.aza37 = 5       
        LET g_aza.aza41 = "1"      #MOD-540182
        LET g_aza.aza42 = "1"      #MOD-540182
        LET g_aza.aza43 = "Y"      #FUN-540051
        LET g_aza.aza44 = "Y"      #FUN-4C0064
        LET g_aza.aza45 = "0"      #FUN-4C0064
        LET g_aza.aza49 = "1"      #FUN-630024
        LET g_aza.aza93 = "N"      #FUN-860089
        LET g_aza.aza57 = "N"      #FUN-660048
        LET g_aza.aza63 = "N"      #No.FUN-670040
        LET g_aza.aza81 = ""       #No.FUN-730020
        LET g_aza.aza82 = ""       #No.FUN-730020
        LET g_aza.aza64 = "N"      #品質管制系統是否與SPC系統整合
        LET g_aza.aza65 = "N"      #與SPC系統整合時,QC單是否自動確認
        LET g_aza.aza66 = "1"      #FUN-6B0006
        LET g_aza.aza67 = "Y"      #FUN-6B0036
        LET g_aza.aza68 = NULL     #FUN-6B0036
        LET g_aza.aza71 = "N"      #FUN-6C0040
        LET g_aza.aza72 = "N"      #No.FUN-710010
        LET g_aza.aza73 = "N"      #No.FUN-730032
       #LET g_aza.aza74 = "5456"   #No.FUN-730032  #No.TQC-A30088
        LET g_aza.aza74 = NULL     #No.FUN-730032  #No.TQC-A30088
        LET g_aza.aza83 = 10       #No.FUN-840077
        LET g_aza.aza85 = "N"      #FUN-850147
        LET g_aza.aza23 = ""       #FUN-850147
        LET g_aza.aza90 = "N"      #FUN-870101 add
        LET g_aza.aza91 = "D"      #FUN-8A0096 add
        LET g_aza.aza96 = "Y"      #FUN-9A0095 add
        LET g_aza.aza88 = 'N'      #No.FUN-870007
        LET g_aza.aza89 = 'N'      #No.FUN-870007     
        LET g_aza.aza95 = 'N'      #FUN-9A0065 add
        LET g_aza.aza123 = 'N'     #FUN-AC0084 add
        LET g_aza.aza121 = "N"     #FUN-A80018 add
        LET g_aza.aza122 = "1"     #FUN-A80018 add
        LET g_aza.aza124 = "Y"     #FUN-BB0005 add        
        LET g_aza.azadate=g_today
        LET g_aza.azauser=g_user
        LET g_aza.azagrup=g_grup
        LET g_aza.azaoriu = g_user      #No.FUN-980030 10/01/04
        LET g_aza.azaorig = g_grup      #No.FUN-980030 10/01/04
        LET g_aza.aza107 = "N"          #FUN-A10064 add
        LET g_aza.aza127 = "N"          #FUN-C50126 add
        LET g_aza.aza131 = "N"          #DEV-D30026 ADD
        LET g_aza.aza132 = "N"          #DEV-D30026 ADD

        INSERT INTO aza_file VALUES (g_aza.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","aza_file",g_aza.aza01,"",SQLCA.sqlcode,"","I",0)   #No.FUN-660131
           RETURN
        END IF
    END IF

    IF cl_null(g_aza.aza58) THEN    #FUN-620044
        LET g_aza.aza58 = FGL_GETENV('FGLASIP')
    END IF

      IF cl_null(g_aza.aza67) THEN
         LET g_aza.aza67 = "N"
      END IF

     IF cl_null(g_aza.aza91) THEN
       LET g_aza.aza91 = "D"
     END IF

    IF cl_null(g_aza.aza72) THEN
       LET g_aza.aza72 = "N"
    END IF

    IF cl_null(g_aza.aza83) THEN
       LET g_aza.aza83 = 10
    END IF

    #FUN-A80018 --start--
    IF cl_null(g_aza.aza122) THEN
       LET g_aza.aza122 = "N"
    END IF
    #FUN-A80018 --end--

  #-依勾選是否與 Product Portal 整合, 顯示/隱藏 Product Potal和SOAP 欄位
    CALL cl_set_comp_visible("aza91", g_aza.aza67 = 'Y')   #FUN-8A0096
    CALL cl_set_comp_visible("aza82", g_aza.aza63 = 'Y')   #FUN-850121 add
    CALL cl_set_comp_visible("aza68", g_aza.aza67 = 'Y')
    CALL cl_set_comp_required("aza68", g_aza.aza67 = 'Y')

    #---FUN-B80118---start-----
    #判斷是否與CROSS平台整合，如果是透過CROSS平台，就不需要再出現其它待辦事項欄位設定
    SELECT wap02 INTO l_wap02 FROM wap_file WHERE wap01 = '0'

    IF l_wap02 = "Y" THEN
       CALL cl_set_comp_visible("aza91", FALSE)
       CALL cl_set_comp_visible("aza68", FALSE)
       CALL cl_set_comp_required("aza68", FALSE)
    END IF
    #---FUN-B80118---end-----

    CALL cl_set_comp_required("aza82", g_aza.aza63 = 'Y')
    CALL cl_set_comp_visible("aza25,aza46,aza47,aza27",g_aza.aza26 = '2')
    CALL cl_set_comp_visible("aza48",g_aza.aza26='2')

  #-依勾選是否與 MDM 整合, 顯示/隱藏 SOAP 欄位
    CALL cl_set_comp_visible("aza86", g_aza.aza85 = 'Y')
    CALL cl_set_comp_required("aza86", g_aza.aza85 = 'Y')

   #FUN-9A0095 add begin ------
    IF cl_null(g_aza.aza96) THEN
      LET g_aza.aza96 = "Y"          
    END IF

   #依勾選是否與MES整合, 顯示/隱藏 aza96欄位
    CALL cl_set_comp_visible("aza96", g_aza.aza90 = 'Y')
   #FUN-9A0095 add end --------

   #CALL cl_set_comp_visible("aza108", g_aza.aza107 = 'Y')    #FUN-A10064 add #FUN-C50126 mark
    CALL cl_set_comp_visible("aza108,aza127,aza128", g_aza.aza107 = 'Y')      #FUN-C50126 add
   #CALL cl_set_comp_entry("aza127",FALSE)                                    #FUN-C50126 add 不開放此欄位給User 調整

   #依勾選是否與PLM整合, 顯示/隱藏 aza122欄位
    CALL cl_set_comp_visible("aza122", g_aza.aza121 = 'Y')  #FUN-A80018 add

   #DEV-D30026 ADD STR------
   #依勾選是否與M-barcode整合, 顯示/隱藏aza132欄位
    IF cl_null(g_aza.aza132) THEN
       LET g_aza.aza132 = 'N'
    END IF
    CALL cl_set_comp_visible("aza132",g_aza.aza131 = 'Y')
   #DEV-D30026 ADD END------
    DISPLAY BY NAME g_aza.aza02,
                    g_aza.aza05,              #FUN-660132
                    g_aza.aza06,g_aza.aza07,g_aza.aza12,g_aza.aza16,
                    g_aza.aza25,g_aza.aza46,g_aza.aza47,g_aza.aza26,g_aza.aza17,   #No.FUN-580006
                    g_aza.aza51,g_aza.aza48,g_aza.aza63, #g_aza.aza52,g_aza.aza53, #FUN-A10056 mark #FUN-630039 #FUN-630066 #No.FUN-670040
                    g_aza.aza81,g_aza.aza82,   #No.FUN-730020
                    #g_aza.aza69,g_aza.aza70,g_aza.aza45, g_aza.aza18,g_aza.aza19,  #FUN-690090 #No:FUN-BB0068
                    g_aza.aza69,g_aza.aza70,g_aza.aza45, g_aza.aza19,  #FUN-690090  #No:FUN-BB0068 g_aza.aza18 改到aoos900設定
                    g_aza.aza21,g_aza.aza22,
                    g_aza.aza23,g_aza.aza24,g_aza.aza56,g_aza.aza27,g_aza.aza08, #FUN-660011
                    g_aza.aza28,g_aza.aza29,g_aza.aza30,g_aza.aza31,
                    g_aza.aza60,g_aza.aza61,g_aza.aza62,   #FUN-670031
                    g_aza.aza97,g_aza.aza98,g_aza.aza99,g_aza.aza100, #FUN-A10109
                    g_aza.aza41,g_aza.aza42,               #MOD-540182
                    g_aza.aza101,g_aza.aza102,g_aza.aza103,g_aza.aza104, #FUN-A10109
                    g_aza.aza105,g_aza.aza106,                           #FUN-BA0015 add
                    g_aza.aza43,                           #FUN-540051
                    g_aza.aza33,g_aza.aza34,g_aza.aza38,   #MOD-4B0134
                    g_aza.aza54,g_aza.aza55,g_aza.aza58,g_aza.aza59,    #FUN-640207 #FUN-620044
                    g_aza.aza35,g_aza.aza36,g_aza.aza39,   #FUN-4C0064
                    g_aza.aza44,g_aza.aza40,g_aza.aza50,   ##FUN-610014 #A112  No.FUN-550087,FUN-560245
                    g_aza.aza37,g_aza.aza49,g_aza.aza93,   #FUN-860089
                    g_aza.aza57,g_aza.aza67,g_aza.aza68,              #FUN-6B0036
                    g_aza.aza71,                           #FUN-6C0040 GPM
                    g_aza.aza72,                           #No.FUN-710010
                    g_aza.aza73,g_aza.aza74,               #No.FUN-730032
                    g_aza.aza78,                           #No.FUN-870067
                    g_aza.azauser,g_aza.azamodu,           #FUN-630024
                    g_aza.azagrup,g_aza.azadate,
                    g_aza.aza64,g_aza.aza65,g_aza.aza66,   #FUN-6B0006    #NO.FUN-680010
                    g_aza.aza83,g_aza.aza85,g_aza.aza86,   #No.FUN-840077
                    #g_aza.aza88,g_aza.aza89,              #No.FUN-870007  #FUN-AC0086 mark
                    g_aza.aza88,                           #FUN-AC0086 add
                    g_aza.aza90,                           #FUN-870101 add
                    g_aza.aza107,                          #FUN-A10064 add aza107,aza108  #FUN-C50126 mark aza108
                    g_aza.aza127,g_aza.aza128,             #FUN-C50126 add aza127,aza128
                    g_aza.aza108,                          #FUN-A10064 add aza107,aza108  #FUN-C50126 add aza108
                    g_aza.aza123,                          #FUN-AC0084 add
                    g_aza.aza91,                           #FUN-8A0096 add
                    g_aza.aza92,                           #FUN-930108 add
                    g_aza.aza125,g_aza.aza126,             #No.FUN-BB0049
                    g_aza.aza115,                          #No.FUN-CB0087 add
                    g_aza.aza113,                          #FUN-B90056 add
                    g_aza.aza94,                           #FUN-970108 add
                    g_aza.aza95,                           #FUN-9A0065 add
                    g_aza.aza96,                           #FUN-9A0095 add
                    g_aza.aza109,                          #FUN-B30202 add
                    g_aza.aza110,g_aza.aza111,g_aza.aza112, #FUN-B90056 add
                    g_aza.aza121,g_aza.aza122,             #FUN-A80018 add
                    g_aza.aza124,                          #FUN-BB0005 add                    
                    g_aza.aza131,g_aza.aza132,             #DEV-D30026 ADD
                    g_aza.azaud01,g_aza.azaud02,g_aza.azaud03,g_aza.azaud04,g_aza.azaud05,   #FUN-B50039
                    g_aza.azaud06,g_aza.azaud07,g_aza.azaud08,g_aza.azaud09,g_aza.azaud10,   #FUN-B50039
                    g_aza.azaud11,g_aza.azaud12,g_aza.azaud13,g_aza.azaud14,g_aza.azaud15    #FUN-B50039

    SELECT azi02 INTO lc_azi02 FROM azi_file WHERE azi01=g_aza.aza17
    DISPLAY lc_azi02 TO azi02
    CALL s010_chk_result1() RETURNING l_flag   #FUN-A10109
    CALL s010_chk_result2() RETURNING l_flag   #FUN-A10109
    CALL s010_chk_result3() RETURNING l_flag   #FUN-A10109
    CALL s010_chk_result4() RETURNING l_flag   #FUN-BA0015 add

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION s010_menu()

    CALL cl_set_comp_visible("aza65,aza64",FALSE)

    MENU ""
    ON ACTION modify
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
           CALL s010_u()
       END IF

    ON ACTION help
       CALL cl_show_help()

    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       CALL cl_set_combo_lang("aza45")

    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU

    ON ACTION changing_color
       LET g_action_choice="changing_color"
       IF cl_chk_act_auth() THEN
          CALL cl_cmdrun_wait("aoos100")
       END IF

    ON IDLE g_idle_seconds
       CALL cl_on_idle()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

       LET g_action_choice = "exit"
       CONTINUE MENU

        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
END FUNCTION


FUNCTION s010_u()
DEFINE l_gae04    LIKE gae_file.gae04          #FUN-5A0126
DEFINE l_flag     LIKE type_file.chr1          #FUN-A10109

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aza01_t=g_aza.aza01
    LET g_aza02_t=g_aza.aza02
    LET g_aza05_t=g_aza.aza05
    LET g_aza06_t=g_aza.aza06
    LET g_aza07_t=g_aza.aza07
    LET g_aza12_t=g_aza.aza12
    LET g_aza16_t=g_aza.aza16
    LET g_aza25_t=g_aza.aza25
    LET g_aza46_t=g_aza.aza46   #No.FUN-580006
    LET g_aza47_t=g_aza.aza47   #No.FUN-580006
    LET g_aza51_t=g_aza.aza51   #FUN-630039
    LET g_aza48_t=g_aza.aza48   #FUN-630066
    LET g_aza69_t=g_aza.aza69   #FUN-690090
    LET g_aza70_t=g_aza.aza70   #FUN-690090
    LET g_aza26_t=g_aza.aza26
    LET g_aza17_t=g_aza.aza17
    #LET g_aza18_t=g_aza.aza18  #No:FUN-BB0068 aza18 改到aoos900設定
    LET g_aza19_t=g_aza.aza19
    LET g_aza21_t=g_aza.aza21
    LET g_aza94_t=g_aza.aza94   #FUN-970108
    LET g_aza22_t=g_aza.aza22   #MOD-4B0312
    LET g_aza39_t=g_aza.aza39   #FUN-4C0064
    LET g_aza23_t=g_aza.aza23  
    LET g_aza24_t=g_aza.aza24  
    LET g_aza56_t=g_aza.aza56   #FUN-660011
    LET g_aza27_t=g_aza.aza27   #no.A047
    LET g_aza08_t=g_aza.aza08   #bugno:7255
    LET g_aza40_t=g_aza.aza40   #NO.A112
    LET g_aza50_t=g_aza.aza50   #FUN-610014
    LET g_aza44_t=g_aza.aza44   #FUN-4C0064
    LET g_aza45_t=g_aza.aza45   #FUN-4C0064
    LET g_aza49_t=g_aza.aza49   #FUN-630024
    LET g_aza93_t=g_aza.aza93   #FUN-860089
    LET g_aza57_t=g_aza.aza57   #FUN-660048
    LET g_aza63_t=g_aza.aza63   #FUN-670040
    LET g_aza81_t=g_aza.aza81   #No.FUN-730020
    LET g_aza82_t=g_aza.aza82   #No.FUN-730020
    LET g_aza64_t=g_aza.aza64   #FUN-680010
    LET g_aza65_t=g_aza.aza65   #FUN-680010
    LET g_aza66_t=g_aza.aza66   #FUN-6B0006
    LET g_aza72_t=g_aza.aza72   #No.FUN-710010
    LET g_aza73_t=g_aza.aza73   #NO.FUN-730032
    LET g_aza74_t=g_aza.aza74   #NO.FUN-730032
    LET g_aza78_t=g_aza.aza78   #No.FUN-870067
    LET g_aza83_t=g_aza.aza83   #No.FUN-840077
    LET g_aza85_t=g_aza.aza85   #FUN-850147
    LET g_aza86_t=g_aza.aza86   #FUN-850147
    LET g_aza90_t=g_aza.aza90   #FUN-870101 add
    LET g_aza96_t=g_aza.aza96   #FUN-9A0095 add
    LET g_aza107_t=g_aza.aza107 #FUN-A10064 add
    LET g_aza108_t=g_aza.aza108 #FUN-A10064 add
    LET g_aza123_t=g_aza.aza123 #FUN-AC0084 add
    LET g_aza109_t=g_aza.aza109 #FUN-B30202 add
    LET g_aza121_t=g_aza.aza121 #FUN-A80018 add
    LET g_aza122_t=g_aza.aza122 #FUN-A80018 add
    LET g_aza110_t=g_aza.aza110 #FUN-B90056 add
    LET g_aza111_t=g_aza.aza111 #FUN-B90056 add
    LET g_aza112_t=g_aza.aza112 #FUN-B90056 add
    LET g_aza113_t=g_aza.aza113 #FUN-B90056 add
    LET g_aza124_t=g_aza.aza124 #FUN-BB0005 add    
    LET g_aza127_t=g_aza.aza127 #FUN-C50126 add
    LET g_aza128_t=g_aza.aza128 #FUN-C50126 add
    LET g_aza131_t=g_aza.aza131 #DEV-D30026 ADD
    LET g_aza132_t=g_aza.aza132 #DEV-D30026 ADD
    LET g_forupd_sql = "SELECT * FROM aza_file FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aza_cl CURSOR FROM g_forupd_sql

    BEGIN WORK
    OPEN aza_cl
    IF STATUS  THEN CALL cl_err('OPEN aza_curl',STATUS,1) RETURN END IF
    FETCH aza_cl INTO g_aza.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_aza_t.*=g_aza.*
    LET g_aza.azamodu=g_user
    LET g_aza.azadate=g_today
    DISPLAY BY NAME g_aza.aza02,g_aza.aza05,g_aza.aza06,g_aza.aza07,g_aza.aza12,g_aza.aza16,
                    g_aza.aza25,g_aza.aza46,g_aza.aza47,g_aza.aza26,g_aza.aza17,g_aza.aza51,
                    g_aza.aza48,g_aza.aza63,g_aza.aza81,g_aza.aza82,                          #FUN-A10056
                    #g_aza.aza69,g_aza.aza70,g_aza.aza45, g_aza.aza18,g_aza.aza19,g_aza.aza21,#No:FUN-BB0068 
                    g_aza.aza69,g_aza.aza70,g_aza.aza45,g_aza.aza19,g_aza.aza21, #No:FUN-BB0068 aza18 改到aoos900設定
                    g_aza.aza22,g_aza.aza23,g_aza.aza24,g_aza.aza56,g_aza.aza27,g_aza.aza08,
                    g_aza.aza28,g_aza.aza29,g_aza.aza30,g_aza.aza31,g_aza.aza109,g_aza.aza110,        #FUN-B90056   add
                    g_aza.aza111,g_aza.aza112,                                                        #FUN-B90056   add
                    g_aza.aza60,g_aza.aza61,
                    g_aza.aza62,g_aza.aza41,g_aza.aza42,g_aza.aza43,g_aza.aza33,g_aza.aza34,
                    g_aza.aza38,g_aza.aza54,g_aza.aza55,g_aza.aza58,g_aza.aza59,g_aza.aza35,
                    g_aza.aza36,g_aza.aza39,g_aza.aza44,g_aza.aza40,g_aza.aza50,g_aza.aza37,
                    g_aza.aza49,g_aza.aza93,g_aza.aza57,g_aza.aza67,g_aza.aza68,g_aza.aza71,
                    g_aza.aza72,g_aza.aza73,g_aza.aza74,g_aza.aza78,g_aza.azauser,g_aza.azamodu,
                    g_aza.azagrup,g_aza.azadate,g_aza.aza64,g_aza.aza65,g_aza.aza66,g_aza.aza83,
                    #g_aza.aza85,g_aza.aza86,g_aza.aza88,g_aza.aza89,g_aza.aza90,g_aza.aza91,    #FUN-AC0086 mark
                    g_aza.aza85,g_aza.aza86,g_aza.aza88,g_aza.aza90,
                    g_aza.aza123,                        #FUN-AC0084 add
                    g_aza.aza91,                         #FUN-AC0086 add
                    g_aza.aza92,g_aza.aza113,g_aza.aza94,g_aza.aza95, #FUN-9A0065 add aza95  #FUN-B90056 add g_aza.aza113
                    g_aza.aza125,g_aza.aza126,           #No.FUN-BB0049
                    g_aza.aza115,                        #No.FUN-CB0087 add
                    g_aza.aza109,                        #FUN-B30202 add
                    g_aza.aza110,g_aza.aza111,g_aza.aza112, #FUN-B90056 add
                    g_aza.aza121,g_aza.aza122,           #FUN-A80018 add
                    g_aza.aza124,                        #FUN-BB0005 add                    
                    g_aza.aza131,g_aza.aza132,           #DEV-D30026 ADD
                    g_aza.azaud01,g_aza.azaud02,g_aza.azaud03,g_aza.azaud04,g_aza.azaud05,   #FUN-B50039
                    g_aza.azaud06,g_aza.azaud07,g_aza.azaud08,g_aza.azaud09,g_aza.azaud10,   #FUN-B50039
                    g_aza.azaud11,g_aza.azaud12,g_aza.azaud13,g_aza.azaud14,g_aza.azaud15    #FUN-B50039
    WHILE TRUE
        CALL s010_i()
        IF INT_FLAG THEN
            CALL s010_show()
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        CALL s010_chk_result1() RETURNING l_flag
        IF l_flag = 'N' THEN CONTINUE WHILE END IF
        CALL s010_chk_result2() RETURNING l_flag
        IF l_flag = 'N' THEN CONTINUE WHILE END IF
        CALL s010_chk_result3() RETURNING l_flag
        IF l_flag = 'N' THEN CONTINUE WHILE END IF
        CALL s010_chk_result4() RETURNING l_flag        #FUN-BA0015 add
        IF l_flag = 'N' THEN CONTINUE WHILE END IF      #FUN-BA0015 add    
        UPDATE aza_file
           SET aza_file.*=g_aza.*
        IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","aza_file",g_aza.aza01,"",SQLCA.sqlcode,"","",0)   #No.FUn-660131
            CONTINUE WHILE
        ELSE
           IF ((g_aza.aza41 != g_aza_t.aza41) OR (g_aza.aza42 != g_aza_t.aza42) OR
               (cl_null(g_aza_t.aza41)) OR (cl_null(g_aza_t.aza42))) THEN

              SELECT gae04 INTO l_gae04 FROM gae_file where gae01='p_zaa' AND
                 gae02='zaa14_K' AND gae03=g_lang
              CALL cl_err_msg("",'lib-303',l_gae04 CLIPPED || "|" || "K" || "|" || l_gae04 CLIPPED,1)
           END IF
           IF g_aza.aza23 = 'N' THEN
                #-----TQC-B90211---------
                #UPDATE cpa_file set cpa120='N' WHERE cpa00='0'      #FUN-610019
                #IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                #       CALL cl_err3("upd","cpa_file",g_cpa.cpa00,"",STATUS,"","",0)   #No.Fun-660131
                #      CONTINUE WHILE
                #END IF
                #-----END TQC-B90211-----
          #CHI-B80015 --- mark --- start ---      
          #ELSE
          #    IF ((g_aza.aza23 != g_aza_t.aza23) OR
          #       (cl_null(g_aza_t.aza23)))
          #    THEN
          #         IF g_aza.aza26 = '2' THEN
          #            CALL cl_err_msg('','aoo-025','gpys010',10)
          #         ELSE
          #            CALL cl_err_msg('','aoo-025','apys010',10)
          #         END IF
          #    END IF
          #CHI-B80015 --- mark ---  end  ---      
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aza_cl
    COMMIT WORK
END FUNCTION

#FUN-CA0121--start
FUNCTION s010_curr()
DEFINE   l_aaa03    LIKE aaa_file.aaa03,
         l_aaa03t   LIKE aaa_file.aaa03

   LET g_errno = ' '

   IF g_aza.aza26 <> '2' THEN RETURN END IF

   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01= g_aza.aza81
   SELECT aaa03 INTO l_aaa03t FROM aaa_file
    WHERE aaa01=g_aza.aza82

   IF g_aza.aza63 ='Y' AND NOT cl_null(l_aaa03t) AND NOT cl_null(l_aaa03) THEN
      IF l_aaa03 <> l_aaa03t THEN
         LET g_errno = 'aoo-089'
         RETURN
      END IF
   END IF

   IF g_aza.aza63 ='Y' AND NOT cl_null(l_aaa03t) AND NOT cl_null(g_aza.aza17) THEN
      IF g_aza.aza17 <> l_aaa03t THEN
         LET g_errno = 'aoo-089'
         RETURN
      END IF
   END IF

   IF NOT cl_null(l_aaa03) AND NOT cl_null(g_aza.aza17) THEN
      IF g_aza.aza17 <> l_aaa03 THEN
         LET g_errno = 'aoo-089'
         RETURN
      END IF
   END IF
END FUNCTION
#FUN-CA0121--end

FUNCTION s010_i()
   DEFINE   l_n   LIKE type_file.num5    #No.FUN-680102 SMALLINT
   DEFINE   lc_azi02   LIKE azi_file.azi02
   DEFINE   l_aaaacti  LIKE aaa_file.aaaacti        #No.FUN-730020
   DEFINE   l_flag LIKE type_file.chr1 #FUN-A10109
   DEFINE   l_str      LIKE type_file.chr18   #FUN-A10064 add
   DEFINE   l_t1       LIKE oay_file.oayslip  #FUN-A10064 add
   DEFINE   li_result  LIKE type_file.num5    #FUN-A10064 add
   DEFINE   l_wap02    LIKE wap_file.wap02    #FUN-B80118

   INPUT BY NAME
      g_aza.aza02,g_aza.aza26,            #No.FUM-580006
      g_aza.aza05,g_aza.aza06,g_aza.aza07,g_aza.aza09,              #FUN-660132
      g_aza.aza12,g_aza.aza16,g_aza.aza25,g_aza.aza46,g_aza.aza47,g_aza.aza27,g_aza.aza08,  #No.FUN-580006
      g_aza.aza40,g_aza.aza50, #FUN-710037             #FUN-610014 #A112  No.FUN-550087,FUN-560245 #FUN-720009
      g_aza.aza51,g_aza.aza48,g_aza.aza63,g_aza.aza81,g_aza.aza82,  #No.FUN-730020
      g_aza.aza88,g_aza.aza95, #No.FUN-870007  #FUN-9A0065 add aza95
      g_aza.aza69,g_aza.aza70,g_aza.aza17,g_aza.aza45,  #FUN-690090
      #g_aza.aza18,g_aza.aza19, #No:FUN-BB0068
      g_aza.aza19, #No:FUN-BB0068 g_aza.aza18 改到aoos900設定
      g_aza.aza21,g_aza.aza23,g_aza.aza72,g_aza.aza57,  #FUN-660048   #No.FUN-710010
      g_aza.aza64,g_aza.aza65,                          #FUN-6B0006   #FUN-680010
      g_aza.aza71,g_aza.aza73,g_aza.aza74,              #FUN-6C0040 GPM  #No.FUN-730032
      g_aza.aza78,                                      #No.FUN-870067
      g_aza.aza67,g_aza.aza91,g_aza.aza68,g_aza.aza85,g_aza.aza86,  #FUN-6B0036   #FUN-850147 #FUN-8A0096 add aza91
      g_aza.aza90,                                      #FUN-870101 add
      g_aza.aza107,                                     #FUN-A10064 add aza107,aza108  #FUN-C50126 mark aza108
      g_aza.aza127,g_aza.aza128,                        #FUN-C50126 add aza127,aza128
      g_aza.aza108,                                     #FUN-A10064 add aza107,aza108  #FUN-C50126 add aza108
      g_aza.aza123,                                     #FUN-AC0084 add
      g_aza.aza24,g_aza.aza56,g_aza.aza66, g_aza.aza49,g_aza.aza93, #FUN-660011   #FUN-6B0006   #FUN-680010 #FUN-860089
      g_aza.aza28,g_aza.aza29,g_aza.aza30,g_aza.aza31,                            #FUN-B30202  add
      g_aza.aza109,g_aza.aza110,g_aza.aza111,g_aza.aza112,                        #FUN-B90056 add
      #g_aza.aza89,                                     #No.FUN-870007   #FUN-AC0086 mark
      g_aza.aza60,g_aza.aza61,g_aza.aza62,g_aza.aza92,  #FUN-670031 #FUN-930108 add aza92
      g_aza.aza125,g_aza.aza126,                        #No.FUN-BB0049
      g_aza.aza115,                                     #No.FUN-CB0087 add
      g_aza.aza113,                                     #FUN-B90056 add
      g_aza.aza97,g_aza.aza98,g_aza.aza99,g_aza.aza100, #FUN-A10109
      g_aza.aza41,g_aza.aza42,              #MOD-540182
      g_aza.aza101,g_aza.aza102,g_aza.aza103,g_aza.aza104, #FUN-A10109
      g_aza.aza105,g_aza.aza106,                           #FUN-BA0015 add
      g_aza.aza43,              #MOD-540182 #FUN-540051
      g_aza.aza22,                                      #MOD-4B0312
      g_aza.aza39,g_aza.aza44, g_aza.aza83,             #No.FUN-840077
      g_aza.aza34,g_aza.aza38,                          #MOD-4B0134
      g_aza.aza54,g_aza.aza55,g_aza.aza58,g_aza.aza59,  #FUN-640207  #FUN-620044
      g_aza.aza35,g_aza.aza33,g_aza.aza36,g_aza.aza37,
      g_aza.aza94,   #FUN-970108
      g_aza.aza96,   #FUN-9A0095
      g_aza.aza121,g_aza.aza122,       #FUN-A80018 add      
      g_aza.aza124,                    #FUN-BB0005 add
      g_aza.aza131,g_aza.aza132,       #DEV-D30026 ADD
      g_aza.azaud01,g_aza.azaud02,g_aza.azaud03,g_aza.azaud04,g_aza.azaud05,   #FUN-B50039
      g_aza.azaud06,g_aza.azaud07,g_aza.azaud08,g_aza.azaud09,g_aza.azaud10,   #FUN-B50039
      g_aza.azaud11,g_aza.azaud12,g_aza.azaud13,g_aza.azaud14,g_aza.azaud15    #FUN-B50039
      WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL s010_set_entry()
         CALL s010_set_no_entry()
         LET g_before_input_done = TRUE
         IF cl_null(g_aza.aza58) THEN    #FUN-620044
             LET g_aza.aza58 = FGL_GETENV('FGLASIP')
         END IF
         CALL s010_set_entry_aza98('d')  #FUN-A10109
         CALL s010_set_entry_aza100('d') #FUN-A10109

      AFTER FIELD aza17
         IF NOT cl_null(g_aza.aza17) THEN
            SELECT azi01 FROM azi_file WHERE azi01=g_aza.aza17
            IF SQLCA.SQLCODE THEN
                CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.SQLCODE,"","sel azi:",0)   #No.FUN-660131
                NEXT FIELD aza17
            END IF
            #FUN-CA0121--start
            CALL s010_curr()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_aza.aza17,g_errno,1)
               LET g_aza.aza17 = g_aza_t.aza17
               DISPLAY BY NAME g_aza.aza17
               NEXT FIELD aza17
            END IF
            #FUN-CA0121--end
            LET g_aza17_t=g_aza.aza17
            SELECT azi02 INTO lc_azi02 FROM azi_file WHERE azi01=g_aza.aza17
            DISPLAY lc_azi02 TO azi02
         END IF

       AFTER FIELD aza58    #FUN-620044
          IF cl_null(g_aza.aza58) THEN
                LET g_aza.aza58=FGL_GETENV('FGLASIP')
                DISPLAY BY NAME g_aza.aza58
                NEXT FIELD aza58
          END IF

      ON CHANGE aza25
         IF g_aza.aza25 NOT MATCHES '[YN]' THEN
            LET g_aza.aza25=g_aza25_t
            DISPLAY BY NAME g_aza.aza25
            NEXT FIELD aza25
         END IF
         IF g_aza.aza25 = 'N' THEN
            LET g_aza.aza46 = 'N'
            LET g_aza.aza47 = 'N'
         END IF
         DISPLAY g_aza.aza46 TO aza46
         DISPLAY g_aza.aza47 TO aza47
         CALL s010_set_entry()
         CALL s010_set_no_entry()
         LET g_aza25_t=g_aza.aza25

      ON CHANGE aza64
         IF g_aza.aza64 NOT MATCHES '[YN]' THEN
            LET g_aza.aza64=g_aza64_t
            DISPLAY BY NAME g_aza.aza64
            NEXT FIELD aza64
         END IF
         IF g_aza.aza64 = 'N' THEN
            LET g_aza.aza65 = 'N'
         END IF
         DISPLAY g_aza.aza65 TO aza65
         CALL s010_set_entry()
         CALL s010_set_no_entry()
         LET g_aza64_t=g_aza.aza64

      ON CHANGE aza51
         IF g_aza.aza51 NOT MATCHES '[YN]' THEN
            LET g_aza.aza51=g_aza51_t
            DISPLAY BY NAME g_aza.aza51
            NEXT FIELD aza51
         END IF
         IF g_aza.aza51 = 'N' THEN
            LET g_aza.aza69 = 'N'  #FUN-690090
            LET g_aza.aza70 = 'N'  #FUN-690090
         END IF
         DISPLAY g_aza.aza69 TO aza69  #FUN-690090
         DISPLAY g_aza.aza70 TO aza70  #FUN-690090
         CALL s010_set_entry()
         CALL s010_set_no_entry()
         LET g_aza51_t=g_aza.aza51

      ON CHANGE aza26
         IF NOT cl_null(g_aza.aza26) THEN
            IF g_aza.aza26 NOT MATCHES '[012]' THEN
               LET g_aza.aza26=g_aza26_t
               DISPLAY BY NAME g_aza.aza26
               NEXT FIELD aza26
            END IF
            CALL cl_set_comp_visible("aza25,aza46,aza47,aza27",g_aza.aza26 = '2')
            IF g_aza.aza26 != '2' THEN
               LET g_aza.aza25 = 'N'
               LET g_aza.aza27 = 'N'
               LET g_aza.aza46 = 'N'
               LET g_aza.aza47 = 'N'
               LET g_aza.aza48 = 'N'
               DISPLAY BY NAME g_aza.aza25,g_aza.aza27,
                               g_aza.aza46,g_aza.aza47,g_aza.aza48
               CALL cl_set_comp_visible("aza48",FALSE)
            ELSE
               CALL cl_set_comp_visible("aza48",TRUE)
            END IF
         END IF
         LET g_aza26_t=g_aza.aza26

      #-MOD-AB0118-add-
       AFTER FIELD aza31
          SELECT * INTO g_faa.* FROM faa_file WHERE faa00='0'
          IF g_aza.aza31='Y' AND g_faa.faa06='Y' THEN
             LET g_aza.aza31='N'
             DISPLAY BY NAME g_aza.aza31 
             #當財編是否與序號一致(faa06)為Y時,固定資產編碼自動編碼否(aza31)不可為Y!
             CALL cl_err('','aoo-014',1)
             NEXT FIELD aza31 
          END IF
      #-MOD-AB0118-end-

      AFTER FIELD aza33
         IF g_aza.aza33 < 0 OR g_aza.aza33 > 32767 THEN
            CALL cl_err(g_aza.aza33,"aoo-140",1)
            NEXT FIELD aza33
         END IF

      AFTER FIELD aza34    #FUN-4B0075
        #IF g_aza.aza34 < 0 OR g_aza.aza34 >= 3001 THEN   #FUN-C80092 mark
         IF g_aza.aza34 < 1 OR g_aza.aza34 > 10000 THEN   #FUN-C80092 add
           #CALL cl_err(g_aza.aza34,"aoo-141",1)          #FUN-C80092 mark
            CALL cl_err(g_aza.aza34,"aoo-277",1)          #FUN-C80092 add
            NEXT FIELD aza34
         END IF

      AFTER FIELD aza38    #FUN-4B0075
         IF g_aza.aza38 < 0 OR g_aza.aza38 >= 3001 THEN
            CALL cl_err(g_aza.aza38,"aoo-141",1)
            NEXT FIELD aza38
         END IF

      AFTER FIELD aza54    #FUN-640207
         IF g_aza.aza54 < 0  THEN
            CALL cl_err(g_aza.aza54,"anm-249",1)
            NEXT FIELD aza54
         END IF

      AFTER FIELD aza55    #FUN-640207
         IF g_aza.aza55 < 0  THEN
            CALL cl_err(g_aza.aza55,"anm-249",1)
            NEXT FIELD aza55
         END IF

      AFTER FIELD aza37

         IF g_aza.aza37 < 0 OR g_aza.aza37 > 32767 THEN
            CALL cl_err(g_aza.aza37,"aoo-140",1)
            NEXT FIELD aza37
         END IF

      BEFORE FIELD aza35
         CALL s010_set_entry()

      AFTER FIELD aza35
         CALL s010_set_no_entry()
         IF g_aza.aza35 = "N" THEN
            LET g_aza.aza33 = ""
            LET g_aza.aza36 = ""
            LET g_aza.aza37 = ""
         END IF

      BEFORE FIELD aza63
         CALL s010_set_entry()
         CALL cl_set_comp_required("aza82", g_aza.aza63 = 'Y')  #CHI-C80044
        #CALL cl_set_comp_required("aza82",TRUE)                #CHI-C80044 mark

      AFTER FIELD aza63
         CALL s010_set_no_entry()
         IF g_aza.aza63 = "N" THEN
            LET g_aza.aza82 = ""    #No.TQC-A30089 
            CALL cl_set_comp_required("aza82",FALSE)
         END IF

      AFTER FIELD aza81
         IF NOT cl_null(g_aza.aza81) THEN
            SELECT aaaacti INTO l_aaaacti FROM aaa_file
             WHERE aaa01=g_aza.aza81
            IF SQLCA.SQLCODE=100 THEN
               CALL cl_err3("sel","aaa_file",g_aza.aza81,"",100,"","",1)
               NEXT FIELD aza81
            END IF
            IF l_aaaacti='N' THEN
               CALL cl_err(g_aza.aza81,"9028",1)
               NEXT FIELD aza81
            END IF
            #FUN-CA0121--start
            CALL s010_curr()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_aza.aza81,g_errno,1)
               LET g_aza.aza81 = g_aza_t.aza81
               DISPLAY BY NAME g_aza.aza81
               NEXT FIELD aza81
            END IF
            #FUN-CA0121--end
            IF g_aza.aza63 = 'Y' THEN  #CHI-C80044 add
               IF NOT cl_null(g_aza.aza82) AND g_aza.aza81 = g_aza.aza82 THEN
                  CALL cl_err(g_aza.aza81,"aoo-082",1)
                  LET g_aza.aza81 = g_aza_t.aza81
                  DISPLAY BY NAME g_aza.aza81
                  NEXT FIELD aza81
               END IF
            END IF   #CHI-C80044 add
         END IF

      AFTER FIELD aza82
         IF NOT cl_null(g_aza.aza82) THEN
            SELECT aaaacti INTO l_aaaacti FROM aaa_file
             WHERE aaa01=g_aza.aza82
            IF SQLCA.SQLCODE=100 THEN
               CALL cl_err3("sel","aaa_file",g_aza.aza82,"",100,"","",1)
               NEXT FIELD aza82
            END IF
            IF l_aaaacti='N' THEN
               CALL cl_err(g_aza.aza82,"9028",1)
               NEXT FIELD aza82
            END IF
            #FUN-CA0121--start
            CALL s010_curr()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_aza.aza82,g_errno,1)
               LET g_aza.aza82 = g_aza_t.aza82
               DISPLAY BY NAME g_aza.aza82
               NEXT FIELD aza82
            END IF
            #FUN-CA0121--end
            IF g_aza.aza63 = 'Y' THEN  #CHI-C80044 add
               IF NOT cl_null(g_aza.aza81) AND g_aza.aza81 = g_aza.aza82 THEN
                  CALL cl_err(g_aza.aza82,"aoo-082",1)
                  LET g_aza.aza82 = g_aza_t.aza82
                  DISPLAY BY NAME g_aza.aza82
                  NEXT FIELD aza82
               END IF
            END IF   #CHI-C80044 add
         END IF

      #No.TQC-A30088  --Begin
      BEFORE FIELD aza26
        CALL s010_set_entry()

      AFTER FIELD aza26
        CALL s010_set_no_entry()

#TQC-B70189--mark--str--
#      BEFORE FIELD aza73
#        CALL s010_set_entry()
#        CALL s010_set_no_required()
#TQC-B70189--mark--end--

      AFTER FIELD aza73
        IF g_aza.aza73 = 'Y' THEN
           LET g_aza.aza74 = NULL   #TQC-B70189
           LET g_aza.aza78 = NULL   #TQC-B70189
#TQC-B70189--mark--str--
#           IF cl_null(g_aza.aza74) AND cl_null(g_aza.aza78) THEN
#              LET g_aza.aza74="5456"
#              DISPLAY BY NAME g_aza.aza74
#           END IF
#TQC-B70189--mark--end--
        END IF
#TQC-B70189--mark--str--
#        CALL s010_set_no_entry()
#        CALL s010_set_required()
#
#      BEFORE FIELD aza74
#        CALL s010_set_entry()
#        CALL s010_set_no_required()
#
#      AFTER FIELD aza74
#        CALL s010_set_no_entry()
#        CALL s010_set_required()
#
#      BEFORE FIELD aza78
#        CALL s010_set_entry()
#        CALL s010_set_no_required()
#
#      AFTER FIELD aza78
#        CALL s010_set_no_entry()
#        CALL s010_set_required()
#TQC-B70189--mark--end--
      #No.TQC-A30088  --End

    #FUN-A10109  -----------------------------(S)
      AFTER FIELD aza97
        IF cl_null(g_aza.aza97) THEN
           NEXT FIELD CURRENT
        END IF

      ON CHANGE aza97
         CALL s010_set_entry_aza98('a')

      AFTER FIELD aza99
        IF cl_null(g_aza.aza99) THEN
           NEXT FIELD CURRENT
        END IF

      ON CHANGE aza99
         CALL s010_set_entry_aza100('a')

      AFTER FIELD aza101
        IF cl_null(g_aza.aza101) THEN
           NEXT FIELD CURRENT
        ELSE
           IF g_aza.aza101 NOT MATCHES '[12345]' THEN   #CHI-C90040 add 5
              NEXT FIELD CURRENT
           END IF
        END IF

      BEFORE FIELD aza98
        CALL s010_set_entry_aza98('d')

      AFTER FIELD aza98
        IF cl_null(g_aza.aza98) THEN
           NEXT FIELD CURRENT
        ELSE
           IF g_aza_t.aza98 IS NULL OR (g_aza.aza98 <> g_aza_t.aza98) THEN
              IF g_aza.aza97 = 'Y' THEN
             #編碼長度 1~8
                  IF g_aza.aza98 < 1 OR g_aza.aza98 > 8 THEN
                     CALL cl_err('','aoo-500',1) #輸入範圍為 1~8
                     NEXT FIELD CURRENT
                  END IF
               END IF
               CALL s010_chk_result1() RETURNING l_flag
               IF l_flag = 'N' THEN
                  NEXT FIELD CURRENT
               END IF
               #FUN-BA0015 add START
               CALL s010_chk_result4() RETURNING l_flag
               IF l_flag = 'N' THEN
                  NEXT FIELD CURRENT
               END IF
               #FUN-BA0015 add END
           END IF
        END IF
        CALL s010_chk_result1() RETURNING l_flag
        CALL s010_chk_result4() RETURNING l_flag #FUN-BA0015 add

      AFTER FIELD aza41
        CALL s010_chk_result1() RETURNING l_flag
        IF l_flag = 'N' THEN
           NEXT FIELD CURRENT
        END IF
        CALL s010_chk_result2() RETURNING l_flag
        IF l_flag = 'N' THEN
           NEXT FIELD CURRENT
        END IF
        #FUN-BA0015 add START
        CALL s010_chk_result4() RETURNING l_flag
        IF l_flag = 'N' THEN
           NEXT FIELD CURRENT
        END IF
       #FUN-BA0015 add END

      AFTER FIELD aza42
        CALL s010_chk_result1() RETURNING l_flag
        IF l_flag = 'N' THEN
           NEXT FIELD CURRENT
        END IF
        CALL s010_chk_result2() RETURNING l_flag
        IF l_flag = 'N' THEN
           NEXT FIELD CURRENT
        END IF

      BEFORE FIELD aza100
        CALL s010_set_entry_aza100('d')

      AFTER FIELD aza100
        IF cl_null(g_aza.aza100) THEN
           NEXT FIELD CURRENT
        ELSE
           IF g_aza_t.aza100 IS NULL OR (g_aza.aza100 <> g_aza_t.aza100) THEN
              IF g_aza.aza99 = 'Y' THEN
             #編碼長度 1~8
                  IF g_aza.aza100 < 1 OR g_aza.aza100 > 8 THEN
                     CALL cl_err('','aoo-500',1) #輸入範圍為 1~8
                     NEXT FIELD CURRENT
                  END IF
               END IF
               CALL s010_chk_result2() RETURNING l_flag
               IF l_flag = 'N' THEN
                  NEXT FIELD CURRENT
               END IF
               CALL s010_chk_result3() RETURNING l_flag
               IF l_flag = 'N' THEN
                  NEXT FIELD CURRENT
               END IF
           END IF
        END IF
        CALL s010_chk_result2() RETURNING l_flag
        CALL s010_chk_result3() RETURNING l_flag

      AFTER FIELD aza102
        IF cl_null(g_aza.aza102) THEN
           NEXT FIELD CURRENT
        ELSE
           IF g_aza_t.aza102 IS NULL OR (g_aza.aza102 <> g_aza_t.aza102) THEN
              CALL s010_chk_result2() RETURNING l_flag
              IF l_flag = 'N' THEN
                 NEXT FIELD CURRENT
              END IF
              CALL s010_chk_result3() RETURNING l_flag
              IF l_flag = 'N' THEN
                 NEXT FIELD CURRENT
              END IF
           END IF
        END IF
        CALL s010_chk_result2() RETURNING l_flag
        CALL s010_chk_result3() RETURNING l_flag

      AFTER FIELD aza103
        IF cl_null(g_aza.aza103) THEN
           NEXT FIELD CURRENT
        ELSE
           IF g_aza_t.aza103 IS NULL OR (g_aza.aza103 <> g_aza_t.aza103) THEN
              CALL s010_chk_result2() RETURNING l_flag
              IF l_flag = 'N' THEN
                 NEXT FIELD CURRENT
              END IF
              CALL s010_chk_result3() RETURNING l_flag
              IF l_flag = 'N' THEN
                 NEXT FIELD CURRENT
              END IF
           END IF
        END IF
    #FUN-A10109 -----------------------------(E)
  
    #FUN-BA0015 add START
      AFTER FIELD aza105
        CALL s010_chk_result4() RETURNING l_flag
        IF l_flag = 'N' THEN
           NEXT FIELD CURRENT
        END IF

      AFTER FIELD aza106
        IF cl_null(g_aza.aza101) THEN
           NEXT FIELD CURRENT
        ELSE
           IF g_aza.aza101 NOT MATCHES '[12345]' THEN   #CHI-C90040 add 5
              NEXT FIELD CURRENT
           END IF
        END IF
    #FUN-BA0015 add END

    #-依勾選是否與 Product Portal 整合, 顯示/隱藏 Product Portal和SOAP 欄位
      ON CHANGE aza67
          CALL cl_set_comp_visible("aza91", g_aza.aza67 = 'Y')
          IF cl_null(g_aza.aza91) OR g_aza.aza91 = 'd' THEN
             LET g_aza.aza91 = 'D'
             DISPLAY BY NAME g_aza.aza91
          END IF
          CALL cl_set_comp_visible("aza68", g_aza.aza67 = 'Y')
          CALL cl_set_comp_required("aza68", g_aza.aza67 = 'Y')
          #---FUN-B80118---start-----
          #判斷是否與CROSS平台整合，如果是透過CROSS平台，就不需要再出現其它待辦事項欄位設定
          SELECT wap02 INTO l_wap02 FROM wap_file WHERE wap01 = '0'

          IF l_wap02 = "Y" THEN
             CALL cl_set_comp_visible("aza91", FALSE)
             CALL cl_set_comp_visible("aza68", FALSE)
             CALL cl_set_comp_required("aza68", FALSE)
          END IF
          LET g_aza.aza91 = 'D'
          #---FUN-B80118---end-----

      ON CHANGE aza23
          CALL cl_set_comp_visible("aza72", g_aza.aza23 = 'Y')

      ON CHANGE aza63
          CALL cl_set_comp_visible("aza82", g_aza.aza63 = 'Y')

    #-依勾選是否與 MDM 整合, 顯示/隱藏 SOAP 欄位
      ON CHANGE aza85
          CALL cl_set_comp_visible("aza86", g_aza.aza85 = 'Y')
          CALL cl_set_comp_required("aza86", g_aza.aza85 = 'Y')
          
      AFTER FIELD aza85
          IF g_aza.aza85 = 'N' THEN
             LET g_aza.aza86= ""
             DISPLAY g_aza.aza86 TO aza86
          END IF

      #FUN-9A0095 add str ------
      ON CHANGE aza90
        #依勾選是否與MES整合, 顯示/隱藏 aza96欄位
         CALL cl_set_comp_visible("aza96", g_aza.aza90= 'Y')
         IF g_aza.aza90 = 'N' THEN
            LET g_aza.aza96 = 'N'
         ELSE
            LET g_aza.aza96 = 'Y'
         END IF
         DISPLAY g_aza.aza96 TO aza96
      #FUN-9A0095 add end ------

     #FUN-A10064 add str ------
      ON CHANGE aza107
        #依勾選是否與HR整合, 顯示/隱藏 aza108欄位                   
        #FUN-C50126---mark---str---
        #CALL cl_set_comp_visible("aza108", g_aza.aza107= 'Y')
        #IF g_aza.aza107 = 'N' THEN
        #   LET g_aza.aza108 = ''
        #END IF
        #FUN-C50126---mark---end---
        #FUN-C50126---add----str---
         CALL cl_set_comp_visible("aza108,aza127,aza128", g_aza.aza107= 'Y')
         CALL cl_set_comp_required("aza108", g_aza.aza107 = 'Y')   #MOD-CC0036 add
         IF g_aza.aza107 = 'N' THEN
            LET g_aza.aza108 = ''
            LET g_aza.aza127 = 'N'
            LET g_aza.aza128 = ''
         END IF
         DISPLAY g_aza.aza127 TO aza127
         DISPLAY g_aza.aza128 TO aza128
        #FUN-C50126---add----end---
         DISPLAY g_aza.aza108 TO aza108
      AFTER FIELD aza108
         IF NOT cl_null(g_aza.aza108) THEN
             CALL s_check_no("aap",g_aza.aza108,g_aza_t.aza108,"12","apa_file","apa01","")
             RETURNING li_result,l_str
             IF (NOT li_result) THEN
                LET g_aza.aza108 = g_aza_t.aza108
                DISPLAY BY NAME g_aza.aza108
                NEXT FIELD aza108
             END IF
         END IF
     #FUN-9A0064 add end ------

     #FUN-C50126 add str ------
      AFTER FIELD aza128 #整體帳款類別
         IF NOT cl_null(g_aza.aza128) THEN
             CALL s010_aza128()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('aza128:',g_errno,1)
                LET g_aza.aza128 = g_aza_t.aza128
                DISPLAY BY NAME g_aza.aza128
                NEXT FIELD aza128
             END IF
         END IF
      ON CHANGE aza127
         CALL cl_set_comp_required("aza128", g_aza.aza127 = 'Y')
         CALL cl_set_comp_entry("aza128", g_aza.aza127 = 'Y')
         CALL cl_set_comp_required("aza108", g_aza.aza127 = 'N')
         CALL cl_set_comp_entry("aza108", g_aza.aza127 = 'N')
         IF NOT cl_null(g_aza.aza127) AND g_aza.aza127 = 'N' THEN
            LET g_aza.aza128 = ''
         ELSE
            LET g_aza.aza108 = ''
         END IF
         DISPLAY g_aza.aza128 TO aza128
         DISPLAY g_aza.aza108 TO aza108
     #FUN-C50126 add end ------

     #FUN-A80018 --start--
      ON CHANGE aza121
         CALL cl_set_comp_visible("aza122", g_aza.aza121 = 'Y')

      AFTER FIELD aza121
         CALL s010_chkPLM()     #是否同時勾選[與PLM整合],[使用料件申請作業]
        #IF g_chkflag = 1 THEN                    #FUN-D10093 mark
         IF g_chkflag = 1 OR g_chkflag2 = 1 THEN  #FUN-D10093 add
            NEXT FIELD aza60
         END IF

     #DEV-D30026----ADD-----STR----
      ON CHANGE aza131
         #依勾選是否與M-Barcode整合, 顯示/隱藏 aza132欄位
         CALL cl_set_comp_visible("aza132",g_aza.aza131='Y')
         IF g_aza.aza131 = 'N' THEN
            LET g_aza.aza132 = 'N'
         END IF
         DISPLAY g_aza.aza132 TO aza132
     #DEV-D30026----ADD-----END----

      AFTER FIELD aza60
         CALL s010_chkPLM()     #是否同時勾選[與PLM整合],[使用料件申請作業]
         IF g_chkflag = 1 THEN
            NEXT FIELD aza60
         END IF
     #FUN-A80018 --end-
 
      #FUN-D10093--add---str---
      AFTER FIELD aza92
         CALL s010_chkPLM()     #是否同時勾選[與PLM整合],[使用料件承認申請單]
         IF g_chkflag2= 1 THEN
            NEXT FIELD aza92
         END IF
      #FUN-D10093--add---end---
 
      #FUN-B50039-add-str--
      AFTER FIELD azaud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud02 
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azaud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aza17)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_aza.aza17
               CALL cl_create_qry() RETURNING g_aza.aza17
               DISPLAY g_aza.aza17 TO aza17
               NEXT FIELD aza17
            WHEN INFIELD(aza81)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_aza.aza81
               CALL cl_create_qry() RETURNING g_aza.aza81
               DISPLAY BY NAME g_aza.aza81
               NEXT FIELD aza81
            WHEN INFIELD(aza82)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_aza.aza82
               CALL cl_create_qry() RETURNING g_aza.aza82
               DISPLAY BY NAME g_aza.aza82
               NEXT FIELD aza82
            #FUN-A10064---add----str---
            WHEN INFIELD(aza108) #應付單別
               LET l_t1=s_get_doc_no(g_aza.aza108)
               CALL q_apy(FALSE,FALSE,l_t1,'12','AAP') RETURNING l_t1   
               LET g_aza.aza108 =l_t1           
               DISPLAY BY NAME g_aza.aza108
               NEXT FIELD aza108
            #FUN-A10064---add----end---
            #FUN-C50126---add----str---
            WHEN INFIELD(aza128) #整體帳款類別
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_apt_hrm"
               LET g_qryparam.default1 = g_aza.aza128
               CALL cl_create_qry() RETURNING g_aza.aza128
               DISPLAY BY NAME g_aza.aza128
               NEXT FIELD aza128
            #FUN-C50126---add----end---
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121


   END INPUT
END FUNCTION

FUNCTION s010_set_entry()

   IF INFIELD(aza35) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("aza33,aza36,aza37",TRUE)
   END IF
   IF INFIELD(aza63) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("aza82",TRUE)
   END IF
   IF g_aza.aza25 = 'Y' THEN
      CALL cl_set_comp_entry("aza46,aza47",TRUE)
   END IF
   IF g_aza.aza51 = 'Y' THEN
      CALL cl_set_comp_entry("aza69,aza70",TRUE)    #FUN-A10056
   END IF
   IF g_aza.aza64 = 'Y' THEN
      CALL cl_set_comp_entry("aza65",TRUE)
   END IF
   #No.TQC-A30088  --Begin
   IF INFIELD(aza26) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("aza73",TRUE)
   END IF

#TQC-B70189--mark--str--
#   IF INFIELD(aza73) OR (NOT g_before_input_done) THEN
#      CALL cl_set_comp_entry("aza74,aza78",TRUE)
#   END IF
#
#   IF INFIELD(aza74) OR (NOT g_before_input_done) THEN
#      CALL cl_set_comp_entry("aza78",TRUE)
#   END IF
#
#   IF INFIELD(aza78) OR (NOT g_before_input_done) THEN
#      CALL cl_set_comp_entry("aza74",TRUE)
#   END IF
#TQC-B70189--mark--end--
   #No.TQC-A30088  --End

  #FUN-C50126 add str---
   IF g_aza.aza127 = "Y" THEN
      CALL cl_set_comp_entry("aza128",TRUE)
   ELSE
      CALL cl_set_comp_entry("aza108",TRUE)
   END IF
  #FUN-C50126 add end---

END FUNCTION

FUNCTION s010_set_no_entry()

   IF INFIELD(aza35) OR (NOT g_before_input_done) THEN
      IF g_aza.aza35 = "N" THEN
         CALL cl_set_comp_entry("aza33,aza36,aza37",FALSE)
      END IF
   END IF
   IF INFIELD(aza63) OR (NOT g_before_input_done) THEN
      IF g_aza.aza63 = "N" THEN
         CALL cl_set_comp_entry("aza82",FALSE)
      END IF
   END IF
   IF g_aza.aza25 = 'N' THEN
      CALL cl_set_comp_entry("aza46,aza47",FALSE)
   END IF
   IF g_aza.aza51 = 'N' THEN
      CALL cl_set_comp_entry("aza69,aza70",FALSE)   #FUN-A10056
   END IF
   IF g_aza.aza64 = 'N' THEN
      CALL cl_set_comp_entry("aza65",FALSE)
   END IF
   #No.TQC-A30088  --Begin
   IF INFIELD(aza26) OR (NOT g_before_input_done) THEN
      IF g_aza.aza26 = '1' THEN
         LET g_aza.aza73 = 'N'
         LET g_aza.aza74 = NULL
         LET g_aza.aza78 = NULL
         DISPLAY BY NAME g_aza.aza73,g_aza.aza74,g_aza.aza78
         CALL cl_set_comp_entry("aza73,aza74,aza78",FALSE)
      END IF
   END IF

#TQC-B70189--mark--str--
#   IF INFIELD(aza73) OR (NOT g_before_input_done) THEN
#      IF g_aza.aza73 = 'N' THEN
#         LET g_aza.aza74 = NULL
#         LET g_aza.aza78 = NULL
#         DISPLAY BY NAME g_aza.aza74,g_aza.aza78
#         CALL cl_set_comp_entry("aza74,aza78",FALSE)
#      END IF
#   END IF
#
#   IF INFIELD(aza74) OR (NOT g_before_input_done) THEN
#      IF NOT cl_null(g_aza.aza74) THEN
#         LET g_aza.aza78 = NULL
#         DISPLAY BY NAME g_aza.aza78
#         CALL cl_set_comp_entry("aza78",FALSE)
#      END IF
#   END IF
#
#   IF INFIELD(aza78) OR (NOT g_before_input_done) THEN
#      IF NOT cl_null(g_aza.aza78) THEN
#         LET g_aza.aza74 = NULL
#         DISPLAY BY NAME g_aza.aza74
#         CALL cl_set_comp_entry("aza74",FALSE)
#      END IF
#   END IF
#TQC-B70189--mark--end--
   #No.TQC-A30088  --End

  #FUN-C50126 add str---
   IF g_aza.aza127 = "N" THEN
      CALL cl_set_comp_entry("aza128",FALSE)
   ELSE
      CALL cl_set_comp_entry("aza108",FALSE)
   END IF
  #FUN-C50126 add end---

END FUNCTION
#No:FUN-9C0071--------精簡程式-----


#FUN-A10109 by TSD.odyliao -----------------------------(S)
#製造系統編入 Plant Code (aza97)如勾選起來，則 一定要輸入碼長 ( aza98 )，輸入範圍為 1-8；
#如無勾選，則 aza98 Default 為 0

FUNCTION s010_set_entry_aza98(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

  IF g_aza.aza97 = 'Y' THEN
     CALL cl_set_comp_entry("aza98",TRUE)
     CALL cl_set_comp_required("aza98",TRUE)
  ELSE
     CALL cl_set_comp_entry("aza98",FALSE)
     CALL cl_set_comp_required("aza98",FALSE)
     IF p_cmd = 'a' THEN
        LET g_aza.aza98 = 0
        DISPLAY BY NAME g_aza.aza98
     END IF
  END IF

END FUNCTION

#製造系統編入 Plant Code (aza99)如勾選起來，則 一定要輸入碼長 ( aza100 )，輸入範圍為 1-8；
#如無勾選，則 aza100 Default 為 0

FUNCTION s010_set_entry_aza100(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

  IF g_aza.aza99 = 'Y' THEN
     CALL cl_set_comp_entry("aza100",TRUE)
     CALL cl_set_comp_required("aza100",TRUE)
  ELSE
     CALL cl_set_comp_entry("aza100",FALSE)
     CALL cl_set_comp_required("aza100",FALSE)
     IF p_cmd = 'a' THEN
        LET g_aza.aza100 = 0
        DISPLAY BY NAME g_aza.aza100
     END IF
  END IF

END FUNCTION

#檢查碼數 + 預覽
#IF (全系統單別位數(aza41) + 1 + 製造系統Plant Code碼長(aza98) + 全系統單號位數(aza42) ) > 20
#則跳出錯誤訊息，製造系統單據編碼超出範圍(20碼)

FUNCTION s010_chk_result1()
DEFINE i               LIKE type_file.num5
DEFINE l_aza41_length  LIKE type_file.num5
DEFINE l_aza42_length  LIKE type_file.num5
DEFINE l_result        LIKE type_file.chr100

   CASE g_aza.aza41
     WHEN "1" LET l_aza41_length = 3
     WHEN "2" LET l_aza41_length = 4
     WHEN "3" LET l_aza41_length = 5
   END CASE
   CASE g_aza.aza42
     WHEN "1" LET l_aza42_length = 8
     WHEN "2" LET l_aza42_length = 9
     WHEN "3" LET l_aza42_length = 10
   END CASE

   IF l_aza41_length + 1 + l_aza42_length + g_aza.aza98 > 20 THEN
      CALL cl_err('','aoo-501',1) #製造系統單據編碼超出範圍(20碼)
      RETURN 'N'
   END IF

   LET l_result = ''
   FOR i = 1 TO l_aza41_length
       LET l_result = l_result,'X'
   END FOR
   LET l_result = l_result,'-'

   IF g_aza.aza98 > 0 THEN
      FOR i = 1 TO g_aza.aza98
          LET l_result = l_result,'P'
      END FOR
   END IF

   FOR i = 1 TO l_aza42_length
      LET l_result = l_result,'9'
   END FOR

   DISPLAY l_result TO result1
   RETURN 'Y'

END FUNCTION

FUNCTION s010_chk_result2()
DEFINE i               LIKE type_file.num5
DEFINE l_aza41_length  LIKE type_file.num5
DEFINE l_aza42_length  LIKE type_file.num5
DEFINE l_result        LIKE type_file.chr100

   CASE g_aza.aza41
     WHEN "1" LET l_aza41_length = 3
     WHEN "2" LET l_aza41_length = 4
     WHEN "3" LET l_aza41_length = 5
   END CASE
   CASE g_aza.aza42
     WHEN "1" LET l_aza42_length = 8
     WHEN "2" LET l_aza42_length = 9
     WHEN "3" LET l_aza42_length = 10
   END CASE

   IF l_aza41_length + 1 + l_aza42_length + g_aza.aza100 > 20 THEN
      CALL cl_err('','aoo-502',1) #財務系統單據編碼超出範圍(20碼)
      RETURN 'N'
   END IF

   LET l_result = ''
   FOR i = 1 TO l_aza41_length
       LET l_result = l_result,'X'
   END FOR
   LET l_result = l_result,'-'

   IF g_aza.aza100 > 0 THEN
      FOR i = 1 TO g_aza.aza100
          LET l_result = l_result,'P'
      END FOR
   END IF

   FOR i = 1 TO l_aza42_length
      LET l_result = l_result,'9'
   END FOR

   DISPLAY l_result TO result2
   RETURN 'Y'

END FUNCTION

#IF (傳票單別位數(aza102) + 1 + 財務系統Plant Code碼長(aza100) + 傳票單號位數(aza103) ) > 20，
#則跳出錯誤訊息，傳票單據編碼超出範圍(20碼)

FUNCTION s010_chk_result3()
DEFINE i                LIKE type_file.num5
DEFINE l_aza102_length  LIKE type_file.num5
DEFINE l_aza103_length  LIKE type_file.num5
DEFINE l_result         LIKE type_file.chr100

   CASE g_aza.aza102
     WHEN "1" LET l_aza102_length = 3
     WHEN "2" LET l_aza102_length = 4
     WHEN "3" LET l_aza102_length = 5
   END CASE
   CASE g_aza.aza103
     WHEN "1" LET l_aza103_length = 8
     WHEN "2" LET l_aza103_length = 9
     WHEN "3" LET l_aza103_length = 10
   END CASE

   IF l_aza102_length + 1 + l_aza103_length + g_aza.aza100 > 20 THEN
      CALL cl_err('','aoo-502',1) #財務系統單據編碼超出範圍(20碼)
      RETURN 'N'
   END IF

   LET l_result = ''
   FOR i = 1 TO l_aza102_length
       LET l_result = l_result,'X'
   END FOR
   LET l_result = l_result,'-'

   IF g_aza.aza100 > 0 THEN
      FOR i = 1 TO g_aza.aza100
          LET l_result = l_result,'P'
      END FOR
   END IF

   FOR i = 1 TO l_aza103_length
      LET l_result = l_result,'9'
   END FOR

   DISPLAY l_result TO result3
   RETURN 'Y'

END FUNCTION

#FUN-BA0015 add START
FUNCTION s010_chk_result4()
DEFINE i                LIKE type_file.num5
DEFINE l_aza41_length   LIKE type_file.num5
DEFINE l_aza105_length  LIKE type_file.num5
DEFINE l_result         LIKE type_file.chr100

   CASE g_aza.aza41
     WHEN "1" LET l_aza41_length = 3
     WHEN "2" LET l_aza41_length = 4
     WHEN "3" LET l_aza41_length = 5
   END CASE
   CASE g_aza.aza105
     WHEN "1" LET l_aza105_length = 8
     WHEN "2" LET l_aza105_length = 9
     WHEN "3" LET l_aza105_length = 10
   END CASE

   IF l_aza41_length + 1 + l_aza105_length + g_aza.aza98 > 20 THEN
      CALL cl_err('','aoo-501',1) #製造系統單據編碼超出範圍(20碼)
      RETURN 'N'
   END IF

   LET l_result = ''
   FOR i = 1 TO l_aza41_length
       LET l_result = l_result,'X'
   END FOR
   LET l_result = l_result,'-'

   IF l_aza41_length + 1 + l_aza105_length + g_aza.aza98 > 20 THEN
      CALL cl_err('','aoo-501',1) #製造系統單據編碼超出範圍(20碼)
      RETURN 'N'
   END IF

   LET l_result = ''
   FOR i = 1 TO l_aza41_length
       LET l_result = l_result,'X'
   END FOR
   LET l_result = l_result,'-'

   IF g_aza.aza98 > 0 THEN
      FOR i = 1 TO g_aza.aza98
          LET l_result = l_result,'P'
      END FOR
   END IF

   FOR i = 1 TO l_aza105_length
      LET l_result = l_result,'9'
   END FOR

   DISPLAY l_result TO result4
   RETURN 'Y'

END FUNCTION
#FUN-BA0015 add END

#FUN-A10109 by TSD.odyliao -----------------------------(E)

#TQC-B70189--mark--str--
##TQC-A30088  --Begin
#FUNCTION s010_set_no_required()
#
#   IF INFIELD(aza73) OR (NOT g_before_input_done) THEN
#      CALL cl_set_comp_required("aza74,aza78",FALSE)
#   END IF
#
#   IF INFIELD(aza74) OR (NOT g_before_input_done) THEN
#      CALL cl_set_comp_required("aza78",FALSE)
#   END IF
#
#   IF INFIELD(aza78) OR (NOT g_before_input_done) THEN
#      CALL cl_set_comp_required("aza74",FALSE)
#   END IF
#
#END FUNCTION
#
#FUNCTION s010_set_required()
#
#   IF INFIELD(aza73) OR (NOT g_before_input_done) THEN
#      IF g_aza.aza73 = 'Y' THEN
#         IF cl_null(g_aza.aza74) AND cl_null(g_aza.aza78) THEN
#            CALL cl_set_comp_required("aza74",TRUE)
#         END IF
#         IF NOT cl_null(g_aza.aza74) THEN
#            CALL cl_set_comp_required("aza74",TRUE)
#         END IF
#         IF NOT cl_null(g_aza.aza78) THEN
#            CALL cl_set_comp_required("aza78",TRUE)
#         END IF
#      END IF
#   END IF
#
#   IF INFIELD(aza74) OR (NOT g_before_input_done) THEN
#      IF cl_null(g_aza.aza74) THEN
#         CALL cl_set_comp_required("aza78",TRUE)
#      END IF
#   END IF
#
#   IF INFIELD(aza78) OR (NOT g_before_input_done) THEN
#      IF cl_null(g_aza.aza78) THEN
#         CALL cl_set_comp_required("aza74",TRUE)
#      END IF
#   END IF
#END FUNCTION
#TQC-B70189--mark--end--

#FUN-A80018 add str ----
FUNCTION s010_chkPLM()
   LET g_chkflag = 0
   LET g_chkflag2= 0 #FUN-D10093 add

   IF g_aza.aza121 = "Y" AND g_aza.aza60 = "Y"THEN
      CALL cl_err('','aim-460',1)
      LET g_chkflag = 1
      LET g_aza.aza60 = "N"
      DISPLAY BY NAME g_aza.aza60
   END IF

   #FUN-D10093---add----str---
   IF g_aza.aza121 = "Y" AND g_aza.aza92 = "Y" THEN
       CALL cl_err('','aim-461',1)
       LET g_chkflag2= 1
       LET g_aza.aza92 = "N"
       DISPLAY BY NAME g_aza.aza92
   END IF
   #FUN-D10093---add----end---
END FUNCTION
#FUN-A80018 add end ----
#TQC-A30088  --End
#FUN-C50126---add----str----
FUNCTION s010_aza128() #整體帳款類別
   DEFINE l_apt03    LIKE apt_file.apt03
   DEFINE l_apt07    LIKE apt_file.apt07
   DEFINE l_apt08    LIKE apt_file.apt08
   DEFINE l_aptacti  LIKE apt_file.aptacti
   DEFINE l_apydmy3  LIKE apy_file.apydmy3

   LET g_errno=''
   SELECT   apt03,  apt07,  apt08,  aptacti,  apydmy3
     INTO l_apt03,l_apt07,l_apt08,l_aptacti,l_apydmy3
     FROM apt_file,OUTER apy_file
    WHERE apt01 = g_aza.aza128
      AND apt02 = ' '
      AND apt08 = apy_file.apyslip

   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aap-067' #無此帳款類別, 請重新輸入!
                                LET l_apt03=NULL
                                LET l_apt07=NULL
                                LET l_apt08=NULL
                                LET l_aptacti=NULL
       WHEN l_apt03 <> 'MISC'   LET g_errno='aoo-509' #需設定借方科目='MISC'的帳款類別
      #FUN-D40074 mark str---
      #WHEN l_apt07 IS NULL     LET g_errno='aoo-510' #AP對象或AP單別為空,請查核!
      #WHEN l_apt08 IS NULL     LET g_errno='aoo-510' #AP對象或AP單別為空,請查核!
      #FUN-D40074 mark end---
       WHEN l_apydmy3 <> 'Y'    LET g_errno='aoo-511' #需設定AP單別其屬性為"拋轉傳票(apydmy3='Y')"的帳款類別
       WHEN l_aptacti='N'       LET g_errno='9028'    #此筆資料已無效, 不可使用
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE

  #FUN-D40074 add str---
   IF cl_null(l_apt07) OR cl_null(l_apt08) THEN
      CALL cl_err('aza128:','aoo-510',1)   #AP對象或AP單別為必填欄位,請補齊!!
   END IF
  #FUN-D40074 add end---

END FUNCTION
#FUN-C50126---add----end----
#FUN-AA0022
