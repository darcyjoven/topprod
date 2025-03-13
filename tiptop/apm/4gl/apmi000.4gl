# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi000.4gl
# Descriptions...: 三角貿易流程設定維護作業 (No.7900)
# Date & Author..: 03/08/23 By Kammy
# Note...........: 1.原本apmi000 與 axmi097 結合同一支，並且改雙檔模式
#                  2.所有基本資料皆要檢查指定資料庫及現在使用資料庫的資料
#                  3.請以後維護程式的人先暫時不要將array 放大，仍維持最多
#                    只能打六站的資料
# Modify.........: No.9558 04/05/14 by Ching 倉庫錯誤時僅warning,合理架構應是於單頭新增欄位供逆拋時維護
# Modify.........: NO.MOD-470518 BY wiky add cl_doc()功能
# Modify.........: NO.MOD-480218 BY wiky copy段寫法不正確
# Modify.........: No.MOD-490331 By Kammy 其它資料的單身輸入程式未標準化
# Modify.........: No.MOD-4A0061 By ching 逆拋時,倉庫依前一站別工廠開窗檢查
# Modify.........: No.MOD-4A0248 04/10/19 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0056 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.MOD-4C0073 04/12/13 By pengu
# Note...........: 1.按放棄，不應再進入’其他文件’視窗供使用者維護.
#                  2.單身輸入下游廠商,現'apm-995'錯誤訊息，其檢查客戶資料不應在此欄位，應放在前一欄位(工廠編號)
# Modify.........: No.MOD-530006 05/03/22 By ching add action invalid
# Modify.........: No:BUG-570095 05/08/10 By Rosayu 因為MOD-4C0073 的第一點1.按放棄，不應再進入其他文件視窗供使用者維護修正錯誤
# Modify.........: No.MOD-570095 05/08/10 By Rosayu 導致在輸入單身完第一筆資料時，如未以游標換行至第二行，直接確認，不會開窗讓使用者輸入其他資料，會直接出現錯誤訊息，『未輸入單身資料，刪除單頭』，該筆單頭單身資料均未儲存。
# Modify.........: No.MOD-570363 05/08/11 By Nicola 倉庫別出現mfg4020不可過
# Modify.........: NO.MOD-5A0002 05/10/03 BY yiting 按'查詢' 時, 系統無此筆資料, 但是單身卻會SHOW出上一次查詢出來的貨料
# Modify.........: NO.TQC-5B0031 05/11/07 BY yiting 匯出excel失敗
# Modify.........: No.MOD-5B0312 05/11/29 By Rosayu poz04的開窗資料應要帶出的是axmi221的客戶編號(查詢時和輸入時皆須修正)
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.FUN-610038 06/01/10 BY yiting 刪除單身時, 若存在計價檔(pox_file)應詢問USER是否一併刪除
# Modify.........: NO.FUN-620025 06/20/11 By cl 1.新增欄位(poz17,poy26,poy27,poy28,poy29,poy30,poy31,poy32,poy33),當aza50='Y'時顯示這些欄位，否則不顯示！
#                                               2.如果流程代碼已使用，則該流程代碼不可刪除。且單身不可新增和刪除。
# Modify.........: No.TQC-650108 06/05/26 By cl 1.若"是否計算業績"勾選，則"業績歸屬方"必須輸入。
#                                               2.對理由碼及倉庫資料的抓取，對應單身營運中心。 
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-560041 06/06/23 By kim poz06不檢查目前的資料庫      
# Modify.........: NO.FUN-670079 06/07/28 BY yiting 將axmi090/axmi098/axmi099合併為apmi000
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-690023 06/09/12 By jamie 判斷occacti
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼occ1004
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: NO.FUN-670007 BY yiting
# Modify.........: No.FUN-6B0079 06/12/14 By jamie FUNCTION _fetch() 清空key值
# Modify.........: NO.TQC-740089 07/04/17 BY yiting 1.在詢問apm-037之前先去掃apmi001單身有無資料，如有再詢問
#                                                   2.apmi000(流程代碼) action ""其它資料"" (apmi000_b3)poy32(調撥理由碼) 開窗資料 應查 理由碼(azf02='2') 非檢查碼"
# Modify.........: NO.TQC-740196 07/04/22 by Yiting INPUT先選了正拋之後，再選逆拋，應該要重新開放中斷點欄位
# Modify.........: NO.TQC-740190 07/04/22 by YITING 在DS1中之[其他資料]ACTION中無法輸入調撥理由碼，均會出現apm-800之error message
# Modify.........; NO.TQC-740247 07/04/22 BY yiting 由財務條件進入,發票別顯示為必要欄位,但未檢查,可參考流程代碼ATM
# Modify.........: NO.MOD-740091 07/04/23 BY yiting 單別設定action 之AR單別顯示不用多'-'
# Modify.........: NO.TQC-740188 07/04/23 BY yiting 多營運中心的開窗查詢程式需有CONSTRUCT功能
# Modify.........: NO.TQC-740187 07/04/23 BY yiting action ""財務條件"" (apmi000_b1)未使用利潤中心(aaz90='N',poy46(採購成本中心)/poy45(訂單成本中心) 需隱藏"
# Modify.........: NO.MOD-740153 07/04/23 BY yiting 在抓採購單及訂單單別時，採購單的單別資料應都要抓前一站的DB資料,SO抓本站
# Modify.........: NO.MOD-740417 07/04/24 BY yiting AFTER FIELD 流程poz011之後，判斷為正拋時，set poz19 = 'N'
# Modify.........: NO.TQC-740194 07/04/25 BY yiting 單別設定全不可為空白，錯誤時舊值要蓋回新值，不可以存空白的單別進去
# Modify.........: NO.MOD-740506 07/05/02 BY yiting 當設為代採流程時，第0站設定資料不要卡住全部required
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-750105 07/05/28 By jamie 若參數(aza50)設定不走流通配銷時,Action "流通配銷設定"為隱藏
# Modify.........: No.TQC-760152 07/06/18 By Rayven 單身“廠商編號”不在下一站運營中心的客戶主檔中存在應該要報錯
# Modify.........: NO.MOD-780191 07/08/30 BY yiting 刪除動作控管
# Modify.........: NO.TQC-790028 07/09/21 BY Yiting construct add poz19
# Modify.........: NO.MOD-7A0028 07/10/05 BY Carol 調整poz011,poz18,poz19欄位輸入control
# Modify.........: NO.FUN-7C0004 07/12/03 BY rainy 開放三個欄位 poz12:兩角內部交易否 poz13:來源營運中心  poz14:目的營運中心  07/12/04 Show Only
# Modify.........: NO.TQC-7C0148 07/12/18 BY Yiting 各欄位開窗及資料判斷應check要拋轉的資料庫
# Modify.........: NO.TQC-7C0164 07/12/25 BY rainy poz12判斷時應考慮舊資料null的部份
# Modify.........: No.TQC-810027 08/01/14 By chenl   該單據對程序所做修改全部還原，該單據原先應將程序中，站點所取資料取該站點所在數據庫內的值，因台灣已更改流程，故還原。如有疑問請與台灣sa詢問。
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: NO.MOD-810056 08/01/21 BY claire 單身的第99站只有在待採流程才能設定
# Modify.........: NO.MOD-810172 08/01/24 BY claire poy12要使用當站營運中心別, 非當下營運中心
# Modify.........: NO.MOD-830138 08/03/19 BY Carol 第99站財務條件設定只有AP部門編號(poy19),AP科目類別(poy17)為必要控卡欄位其餘欄位可允許NULL
# Modify.........: NO.TQC-830024 08/03/21 BY Carol 第99站應讀取上一站DB的資料
# Modify.........: NO.FUN-840068 08/04/21 BY TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-870130 08/08/05 By xiaofeizhu 1.單頭中斷營運中心(poz18)設為NOENTRY
#                                                       2.After Field 拋轉中斷(poz19)時判斷，
#                                                         如果找不到第0站資料，顯示訊息"未維護第0站資料！"提示使用者
#                                                       3.離開單身前判斷，
#                                                         如果找不到第0站資料，顯示訊息"未維護第0站資料！"提示使用者并回到單身輸入段  
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.MOD-910090 09/01/09 By claire 99站其它資料不應強迫輸入銷售分類,及其它欄位應可輸入正常
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-930145 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.FUN-930002 09/03/24 By ve007 界面調整
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法  
# Modify.........: No.MOD-950103 09/05/15 By sabrina (1)AFTER FIELD poy06,poy09,poy17,poy19，
#                                                       若有錯誤，錯誤訊息依應上一站工廠的錯誤訊息代碼為主
#                                                    (2)呼叫i000_poy_gem時，應傳入該站的工廠
# Modify.........: No.CHI-960012 09/06/10 By Dido 出貨理由碼應可空白
# Modify.........: No.MOD-960178 09/06/16 By Dido FROM 後面應僅有一格空白,for cl_replace_str 解析之用
# Modify.........: No.FUN-870007 09/07/20 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980025 09/08/05 By dxfwo   集團架構改善
# Modify.........: No.MOD-970287 09/08/13 By Dido 相關採購/AP單別請依流程類別抓取不同營運中心
# Modify.........: No.TQC-980124 09/08/18 By Dido 檢核流程代碼可省略營運中心
# Modify.........: No.FUN-8C0110 09/08/27 By chenmoyan 修改99站幣別時，判斷是否存在在最終站
# Modify.........: No.FUN-8C0125 09/09/09 By chenmoyan 增加INVOICE單別/PACKING單別
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990053 09/09/07 By Dido 系統別調整
# Modify.........: No.TQC-990061 09/09/15 By Dido poy44 檢核系統別調整
# Modify.........: No.TQC-990062 09/09/16 By lilingyu l_dbs_s出現NULL值 
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,qry相關參數
# Modify.........: No.FUN-980017 09/09/23 By destiny 修改qry參 
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.TQC-9A0139 09/10/27 By lilingyu 查詢時無法帶出"中斷營運中心"欄位的值
# Modify.........: No:FUN-9A0092 09/11/05 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:MOD-9B0036 09/11/05 By Dido 簡易輸入系統別調整 
# Modify.........: No:FUN-930145 09/11/19 by destiny 理由码修改           
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No:CHI-9B0006 09/11/25 By Dido poy47 應可空白 
# Modify.........: No:CHI-9B0033 09/11/26 By Dido 相關採購/AP單別應與銷售相同 
# Modify.........: No:MOD-9C0168 09/12/18 By Dido 相關採購單據應抓取上一站 
# Modify.........: No:TQC-970282 09/12/29 By baofei 單身刪除時，刪除pox_file的條件里的項次應該用g_poy_t.poy02
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:FUN-A10099 10/02/23 By Carrier 修正 MOD-9C0168,将l_plant_s变为l_dbs_s
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30042 10/03/09 By Carrier 1.判断是否已经使用过流程代码,改为check 第0站
#                                                    2.若已经有使用过,则单头,除了memo和抛转订单memo资料外,其他不能做修改
# Modify.........: No.TQC-A30041 10/03/16 By Cockroach add ORIU/ORIG
# Modify.........: No:MOD-A50033 10/05/07 By Smapmin 當維護第0站資料時,前一站的營運中心變數(l_dbs_s/l_plant_s)應為NULL
# Modify.........: No:MOD-A50147 10/06/15 By Smapmin 中斷點營運中心要為noentry
# Modify.........: No.FUN-A50102 10/07/20 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A80171 10/09/13 By Smapmin 銷售第0站不需維護收款條件
# Modify.........: No:TQC-AB0041 10/11/26 By lixh1   增加SYBASE可以執行的SQL
# Modify.........: No:FUN-AC0046 10/12/17 By lixia 修改當營運中心為xxx或yyy的跨庫問題
# Modify.........: No:TQC-AC0385 10/12/29 By lixia 畫面輸入單頭資料完畢後移至單身時,畫面出現 error
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80088 11/08/09 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-B80187 11/08/18 By suncx p_key類型定義錯誤
# Modify.........: No.MOD-BB0274 11/12/05 By ck2yuan 當站別輸入為99時,營運中心編號、下游廠商不可維護
# Modify.........: No.MOD-C50166 12/05/23 By Vampire 逆拋的情況下,【其他資料】Action中第0站的poy11倉庫別要必填
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C90015 12/09/20 By jt_chen 調整單身營運中心查詢時的開窗為q_azp
# Modify.........: No.TQC-D40028 13/04/15 By SunLM 調整開窗返回值處理
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40124 13/04/18 By Vampire 控卡 apm-996 要改抓上游營運中心的資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_poz             RECORD LIKE poz_file.*,    #單頭
    g_poz_t           RECORD LIKE poz_file.*,    #單頭(舊值)
    g_poz_o           RECORD LIKE poz_file.*,    #單頭(舊值)
    g_poz01_t         LIKE poz_file.poz01,       #單頭 (舊值)
    g_poy             DYNAMIC ARRAY   of RECORD  #程式變數(Program Variables)
        poy02         LIKE poy_file.poy02,       #站別
        poy04         LIKE poy_file.poy04,       #工廠編號
        poy03         LIKE poy_file.poy03,       #廠商
        pmc03         LIKE pmc_file.pmc03,       #廠商名稱名      #NO.FUN-670079
        poy05         LIKE poy_file.poy05,       #計價幣別
        poy20         LIKE poy_file.poy20,       #營業稅申報方式  #NO.FUN-670079
        poyud01        LIKE poy_file.poyud01,
        poyud02        LIKE poy_file.poyud02,
        poyud03        LIKE poy_file.poyud03,
        poyud04        LIKE poy_file.poyud04,
        poyud05        LIKE poy_file.poyud05,
        poyud06        LIKE poy_file.poyud06,
        poyud07        LIKE poy_file.poyud07,
        poyud08        LIKE poy_file.poyud08,
        poyud09        LIKE poy_file.poyud09,
        poyud10        LIKE poy_file.poyud10,
        poyud11        LIKE poy_file.poyud11,
        poyud12        LIKE poy_file.poyud12,
        poyud13        LIKE poy_file.poyud13,
        poyud14        LIKE poy_file.poyud14,
        poyud15        LIKE poy_file.poyud15
                      END RECORD,
    g_poy_t           RECORD                     #程式變數 (舊值)
        poy02         LIKE poy_file.poy02,       #站別
        poy04         LIKE poy_file.poy04,       #工廠編號
        poy03         LIKE poy_file.poy03,       #下游廠商
        pmc03         LIKE pmc_file.pmc03,       #廠商名稱名      #NO.FUN-670079
        poy05         LIKE poy_file.poy05,       #計價幣別
        poy20         LIKE poy_file.poy20,       #營業稅申報方式  #NO.FUN-670079
        poyud01       LIKE poy_file.poyud01,
        poyud02       LIKE poy_file.poyud02,
        poyud03       LIKE poy_file.poyud03,
        poyud04       LIKE poy_file.poyud04,
        poyud05       LIKE poy_file.poyud05,
        poyud06       LIKE poy_file.poyud06,
        poyud07       LIKE poy_file.poyud07,
        poyud08       LIKE poy_file.poyud08,
        poyud09       LIKE poy_file.poyud09,
        poyud10       LIKE poy_file.poyud10,
        poyud11       LIKE poy_file.poyud11,
        poyud12       LIKE poy_file.poyud12,
        poyud13       LIKE poy_file.poyud13,
        poyud14       LIKE poy_file.poyud14,
        poyud15       LIKE poy_file.poyud15
                      END RECORD,
    g_poy_o           RECORD                     #程式變數 (舊值)
        poy02         LIKE poy_file.poy02,       #站別
        poy04         LIKE poy_file.poy04,       #工廠編號
        poy03         LIKE poy_file.poy03,       #下游廠商
        pmc03         LIKE pmc_file.pmc03,       #廠商名稱名      #NO.FUN-670079
        poy05         LIKE poy_file.poy05,       #計價幣別
        poy20         LIKE poy_file.poy20,       #營業稅申報方式  #NO.FUN-670079
        poyud01       LIKE poy_file.poyud01,
        poyud02       LIKE poy_file.poyud02,
        poyud03       LIKE poy_file.poyud03,
        poyud04       LIKE poy_file.poyud04,
        poyud05       LIKE poy_file.poyud05,
        poyud06       LIKE poy_file.poyud06,
        poyud07       LIKE poy_file.poyud07,
        poyud08       LIKE poy_file.poyud08,
        poyud09       LIKE poy_file.poyud09,
        poyud10       LIKE poy_file.poyud10,
        poyud11       LIKE poy_file.poyud11,
        poyud12       LIKE poy_file.poyud12,
        poyud13       LIKE poy_file.poyud13,
        poyud14       LIKE poy_file.poyud14,
        poyud15       LIKE poy_file.poyud15
                      END RECORD,
    g_poy1            DYNAMIC ARRAY   of RECORD       #程式變數(Program Variables)
         poy02        LIKE poy_file.poy02,
         poy03        LIKE poy_file.poy03,
         pmc03        LIKE pmc_file.pmc03,
         poy18        LIKE poy_file.poy18,
         poy19        LIKE poy_file.poy19,
         poy12        LIKE poy_file.poy12,
         poy07        LIKE poy_file.poy07,       #收款條件
         poy06        LIKE poy_file.poy06,       #付款條件
         poy08        LIKE poy_file.poy08,       # SO 稅別
         poy09        LIKE poy_file.poy09,       # PO 稅別
         poy16        LIKE poy_file.poy16,
         poy17        LIKE poy_file.poy17,
         poy46        LIKE poy_file.poy46,
         poy45        LIKE poy_file.poy45 
                      END RECORD,
    g_poy1_t          RECORD       #程式變數(Program Variables)
         poy02        LIKE poy_file.poy02,
         poy03        LIKE poy_file.poy03,
         pmc03        LIKE pmc_file.pmc03,
         poy18        LIKE poy_file.poy18,
         poy19        LIKE poy_file.poy19,
         poy12        LIKE poy_file.poy12,
         poy07        LIKE poy_file.poy07,       #收款條件
         poy06        LIKE poy_file.poy06,       #付款條件
         poy08        LIKE poy_file.poy08,       # SO 稅別
         poy09        LIKE poy_file.poy09,       # PO 稅別
         poy16        LIKE poy_file.poy16,
         poy17        LIKE poy_file.poy17,
         poy46        LIKE poy_file.poy46,
         poy45        LIKE poy_file.poy45 
                      END RECORD,
    g_poy2            DYNAMIC ARRAY  of RECORD       #程式變數(Program Variables)
        poy02         LIKE poy_file.poy02,       #站別
        poy03         LIKE poy_file.poy03,       #下游廠商
        pmc03         LIKE pmc_file.pmc03,      
        poy34         LIKE poy_file.poy34,       
        poy35         LIKE poy_file.poy35,       
        poy36         LIKE poy_file.poy36,       
        poy47         LIKE poy_file.poy47,
        poy48         LIKE poy_file.poy48,       #No.FUN-8C0125
        poy37         LIKE poy_file.poy37, 
        poy38         LIKE poy_file.poy38,
        poy39         LIKE poy_file.poy39,
        poy40         LIKE poy_file.poy40,
        poy41         LIKE poy_file.poy41,       
        poy42         LIKE poy_file.poy42,       
        poy43         LIKE poy_file.poy43,
        poy44         LIKE poy_file.poy44 
                      END RECORD,
    g_poy2_t          RECORD                     #程式變數 (舊值)
        poy02         LIKE poy_file.poy02,       #站別
        poy03         LIKE poy_file.poy03,       #下游廠商
        pmc03         LIKE pmc_file.pmc03,      
        poy34         LIKE poy_file.poy34,       
        poy35         LIKE poy_file.poy35,       
        poy36         LIKE poy_file.poy36,       
        poy47         LIKE poy_file.poy47,
        poy48         LIKE poy_file.poy48,       #No.FUN-8C0125
        poy37         LIKE poy_file.poy37, 
        poy38         LIKE poy_file.poy38,
        poy39         LIKE poy_file.poy39,
        poy40         LIKE poy_file.poy40,
        poy41         LIKE poy_file.poy41,       
        poy42         LIKE poy_file.poy42,       
        poy43         LIKE poy_file.poy43,
        poy44         LIKE poy_file.poy44 
                      END RECORD,
    g_poy3            DYNAMIC ARRAY  of RECORD       #程式變數(Program Variables)
        poy02         LIKE poy_file.poy02,       #站別
        poy03         LIKE poy_file.poy03,       #下游廠商
        pmc03         LIKE pmc_file.pmc03,      
        poy10         LIKE poy_file.poy10,       
        poy11         LIKE poy_file.poy11,       
        poy28         LIKE poy_file.poy28,      
        poy31         LIKE poy_file.poy31, 
        poy30         LIKE poy_file.poy30,
        poy32         LIKE poy_file.poy32
                      END RECORD,
    g_poy3_t          RECORD                     #程式變數 (舊值)
        poy02         LIKE poy_file.poy02,       #站別
        poy03         LIKE poy_file.poy03,       #下游廠商
        pmc03         LIKE pmc_file.pmc03,      
        poy10         LIKE poy_file.poy10,       
        poy11         LIKE poy_file.poy11,       
        poy28         LIKE poy_file.poy28,      
        poy31         LIKE poy_file.poy31, 
        poy30         LIKE poy_file.poy30,
        poy32         LIKE poy_file.poy32
                      END RECORD,
    g_poy4            DYNAMIC ARRAY  of RECORD       #程式變數(Program Variables)
        poy02         LIKE poy_file.poy02,       #站別
        poy03         LIKE poy_file.poy03,       #下游廠商
        pmc03         LIKE pmc_file.pmc03,      
        poy26         LIKE poy_file.poy26,  
        poy27         LIKE poy_file.poy27, 
        tqb02         LIKE tqb_file.tqb02,
        poy33         LIKE poy_file.poy33,
        poy29         LIKE poy_file.poy29,
        occ02         LIKE occ_file.occ02
                      END RECORD,
    g_poy4_t          RECORD                     #程式變數 (舊值)
        poy02         LIKE poy_file.poy02,       #站別
        poy03         LIKE poy_file.poy03,       #下游廠商
        pmc03         LIKE pmc_file.pmc03,      
        poy26         LIKE poy_file.poy26,  
        poy27         LIKE poy_file.poy27, 
        tqb02         LIKE tqb_file.tqb02,
        poy33         LIKE poy_file.poy33,
        poy29         LIKE poy_file.poy29,
        occ02         LIKE occ_file.occ02
                      END RECORD,
    s_dbs             LIKE type_file.chr21,                #No.FUN-680136 VARCHAR(21)
    g_wc,g_wc2,g_sql  string,  #No.FUN-580092 HCN
    g_rec_b           LIKE type_file.num5,                 #單身筆數  #No.FUN-680136 SMALLINT
    g_rec_b1           LIKE type_file.num5,                #單身筆數  #No.FUN-680136 SMALLINT
    g_rec_b2           LIKE type_file.num5,                #單身筆數  #No.FUN-680136 SMALLINT
    g_rec_b3           LIKE type_file.num5,                #單身筆數  #No.FUN-680136 SMALLINT
    g_rec_b4           LIKE type_file.num5,                #單身筆數  #No.FUN-680136 SMALLINT
    p_row,p_col       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT    #No.FUN-680136 SMALLINT
    l_sl              LIKE type_file.num5,    #No.FUN-680136 SMALLINT #目前處理的ARRAY CNT
    g_used            LIKE type_file.chr1    #No.FUN-680136 VARCHAR(01) #FUN-620025  用于判斷流程代碼是否已被使用
DEFINE  g_t           LIKE aba_file.aba00     #No.FUN-680136 VARCHAR(5)  #NO.FUN-670007
DEFINE  g_db_type     LIKE type_file.chr3     #No.FUN-680136 VARCHAR(3)  #NO.FUN-670007
DEFINE  g_dbname      LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  #NO.FUN-670007
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE   g_cnt1          LIKE type_file.num10     #NO.FUN-670007  #No.FUN-680136 INTEGER
DEFINE   g_cnt2          LIKE type_file.num10     #NO.FUN-670007  #No.FUN-680136 INTEGER
DEFINE   g_cnt3          LIKE type_file.num10     #NO.FUN-670007  #No.FUN-680136 INTEGER
DEFINE   g_cnt4          LIKE type_file.num10     #NO.FUN-670007  #No.FUN-680136 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(72)
 
DEFINE   g_row_count     LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE   g_jump          LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5      #No.FUN-680136 SMALLINT
DEFINE   g_azp03         LIKE azp_file.azp03
DEFINE g_argv1     LIKE poz_file.poz01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
DEFINE   l_plant_g       LIKE type_file.chr10     #FUN-980020 
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
   LET g_forupd_sql = "SELECT * FROM poz_file WHERE poz01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i000_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW i000_w AT p_row,p_col
     WITH FORM "apm/42f/apmi000"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i000_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i000_a()
            END IF
         OTHERWISE        
            CALL i000_q() 
      END CASE
   END IF
 
   IF g_aza.aza50='N' THEN
      CALL cl_set_comp_visible("poz17",FALSE)
      CALL cl_set_comp_visible("poy26,poy27,tqb02,poy28,poy29,poy30,poy31,poy32,poy33,occ02",FALSE)
   END IF
   
   CALL cl_set_comp_visible("poz20,poz21,poz21_desc",g_azw.azw04='2')  #No.FUN-870007
 
   CALL i000_menu()
   CLOSE WINDOW i000_w                    #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i000_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_poy.clear()   #NO.MOD-5A0002
   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
      LET g_wc = " poz01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_poz.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON
        poz01,poz00,poz02,poz011,
        poz09,poz10,poz11,poz17,  
        poz19,poz12,poz20,poz21,poz13,poz14, #No.FUN-870007
        pozuser,pozgrup,pozmodu,pozdate,pozacti,
        pozoriu,pozorig,                     #TQC-A30041 ADD
        pozud01,pozud02,pozud03,pozud04,pozud05,
        pozud06,pozud07,pozud08,pozud09,pozud10,
        pozud11,pozud12,pozud13,pozud14,pozud15
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
                 WHEN INFIELD(poz04) #來源廠商編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_occ"  #MOD-5B0312 add
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO poz04
                      NEXT FIELD poz04
                 WHEN INFIELD(poz05) #來源工廠編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_azp"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO poz05
                      NEXT FIELD poz05
                WHEN INFIELD(poz07) #來源工廠AR/AP部門
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_gem"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO poz07
                      NEXT FIELD poz07
               WHEN INFIELD(poz13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_azp"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO poz13
                  NEXT FIELD poz13
               WHEN INFIELD(poz14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_azp"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO poz14
                  NEXT FIELD poz14
              WHEN INFIELD(poz21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_poz21"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO poz21
                  NEXT FIELD poz21
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
      IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON poy02,poy04,poy03,poy05
                          ,poyud01,poyud02,poyud03,poyud04,poyud05
                          ,poyud06,poyud07,poyud08,poyud09,poyud10
                          ,poyud11,poyud12,poyud13,poyud14,poyud15
                     FROM s_poy[1].poy02,s_poy[1].poy04,
                          s_poy[1].poy03,s_poy[1].poy05
                          ,s_poy[1].poyud01,s_poy[1].poyud02,s_poy[1].poyud03
                          ,s_poy[1].poyud04,s_poy[1].poyud05,s_poy[1].poyud06
                          ,s_poy[1].poyud07,s_poy[1].poyud08,s_poy[1].poyud09
                          ,s_poy[1].poyud10,s_poy[1].poyud11,s_poy[1].poyud12
                          ,s_poy[1].poyud13,s_poy[1].poyud14,s_poy[1].poyud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION CONTROLP
            CASE
                 WHEN INFIELD(poy04) #來源廠商編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_azp"    #MOD-C90015 q_occ -> q_azp 
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO poy04
                      NEXT FIELD poy04
                 WHEN INFIELD(poy03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_pmc3" 
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO poy03
                      NEXT FIELD poy03
                 WHEN INFIELD(poy05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_azi" 
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO poy05
                      NEXT FIELD poy05
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
   END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pozuser', 'pozgrup')
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  poz01 FROM poz_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY poz01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE poz_file. poz01 ",
                  "  FROM poz_file, poy_file ",
                  " WHERE poz01 = poy01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY poz01"
   END IF
 
   PREPARE i000_prepare FROM g_sql
   DECLARE i000_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i000_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM poz_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT poz01) ",
                "  FROM poz_file,poy_file ",
                " WHERE poy01=poz01 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE i000_precount FROM g_sql
   DECLARE i000_count CURSOR FOR i000_precount
 
END FUNCTION
 
FUNCTION i000_menu()
 DEFINE l_cmd  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(100)
 
   WHILE TRUE
      CALL i000_bp("G")
      CASE g_action_choice
           WHEN "insert"
            IF cl_chk_act_auth() THEN
                CALL i000_a()
            END IF
           WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL i000_q()
            END IF
           WHEN "next"
            CALL i000_fetch('N')
           WHEN "previous"
            CALL i000_fetch('P')
           WHEN "modify"
            IF cl_chk_act_auth() THEN
                CALL i000_u()
            END IF
           WHEN "invalid"
            IF cl_chk_act_auth() THEN
                CALL i000_x()
            END IF
           WHEN "delete"
            IF cl_chk_act_auth() THEN
                CALL i000_r()
            END IF
           WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL i000_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
          WHEN "Finance"
            IF cl_chk_act_auth() THEN
               CALL i000_b1()
            END IF
 
          WHEN "Document"
            IF cl_chk_act_auth() THEN
               CALL i000_b2()
            END IF
 
          WHEN "Other"
            IF cl_chk_act_auth() THEN
               CALL i000_b3()
            END IF
 
          WHEN "Delivery"
            IF cl_chk_act_auth() THEN
               CALL i000_b4()
            END IF
 
          WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i000_copy()
            END IF
 
          WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_poz.poz01 IS NOT NULL THEN
                  LET g_doc.column1 = "poz01"
                  LET g_doc.value1 = g_poz.poz01
                  CALL cl_doc()
               END IF
            END IF
 
          WHEN "help"
           CALL cl_show_help()
          WHEN "exit"
           EXIT WHILE
          WHEN "jump"
           CALL i000_fetch('/')
          WHEN "controlg"
           CALL cl_cmdask()
          WHEN "exporttoexcel"   #FUN-4B0025
           IF cl_chk_act_auth() THEN
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_poy),'','')
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i000_a()
   MESSAGE ""
   CLEAR FORM
   IF s_shut(0) THEN RETURN END IF
   INITIALIZE g_poz.* LIKE poz_file.*     #DEFAULT 設定
   CALL g_poy.clear()
 
   LET g_poz01_t = NULL
   LET g_poz_t.* = g_poz.*
   LET g_poz_o.* = g_poz.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_poz.poz09 = 'Y'
      LET g_poz.poz10 = 'N'
      LET g_poz.poz11 = '2'
      LET g_poz.poz17 = 'N'         #FUN-620025
      LET g_poz.poz19 = 'N'         #NO.FUN-670007
      LET g_poz.poz12 = 'N'         #FUN-7C0004
      LET g_poz.poz13 = ' '         #FUN-7C0004
      LET g_poz.poz14 = ' '         #FUN-7C0004
      LET g_poz.poz20 = 'N'         #No.FUN-870007
      LET g_poz.pozuser=g_user
      LET g_poz.pozoriu = g_user #FUN-980030
      LET g_poz.pozorig = g_grup #FUN-980030
      LET g_poz.pozgrup=g_grup
      LET g_poz.pozdate=g_today
      LET g_poz.pozacti='Y'              #資料有效
      BEGIN WORK
      CALL i000_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_poz.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_poz.poz01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO poz_file VALUES (g_poz.*)
      IF SQLCA.sqlcode THEN                      #置入資料庫不成功
         CALL cl_err3("ins","poz_file",g_poz.poz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      COMMIT WORK
      SELECT poz01 INTO g_poz.poz01 FROM poz_file
       WHERE poz01 = g_poz.poz01
      LET g_poz01_t = g_poz.poz01        #保留舊值
      LET g_poz_t.* = g_poz.*
      LET g_poz_o.* = g_poz.*
      CALL g_poy.clear()
      IF NOT cl_null(g_poz.poz21) THEN
         DROP TABLE poy_temp
         SELECT * FROM poy_file WHERE poy01 = g_poz.poz21 INTO TEMP poy_temp
         UPDATE poy_temp SET poy01 = g_poz.poz01
         INSERT INTO poy_file SELECT * FROM poy_temp
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","poy_file","","",SQLCA.sqlcode,"","",1) 
            ROLLBACK WORK
            RETURN
         ELSE
            COMMIT WORK
         END IF
         CALL i000_b_fill(' 1=1')
      END IF
      LET g_rec_b = 0          #TQC-AC0385
      CALL i000_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i000_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_poz.poz01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_poz.* FROM poz_file WHERE poz01=g_poz.poz01
 
   IF g_poz.pozacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_poz.poz01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_poz01_t = g_poz.poz01
   BEGIN WORK
 
   OPEN i000_cl USING g_poz.poz01
   IF STATUS THEN
      CALL cl_err("OPEN i000_cl:", STATUS, 1)
      CLOSE i000_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i000_cl INTO g_poz.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_poz.poz01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i000_cl
      RETURN
   END IF
   CALL i000_show()
   WHILE TRUE
      LET g_poz01_t = g_poz.poz01
      LET g_poz_o.* = g_poz.*
      LET g_poz.pozmodu=g_user
      LET g_poz.pozdate=g_today
      CALL i000_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_poz.*=g_poz_t.*
         CALL i000_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_poz.poz01 != g_poz01_t THEN            # 更改單號
         UPDATE poy_file SET poy01 = g_poz.poz01
          WHERE poy01 = g_poz01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","poy_file",g_poz01_t,"",SQLCA.sqlcode,"","poy",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
      UPDATE poz_file SET poz_file.* = g_poz.*
       WHERE poz01 = g_poz01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","poz_file",g_poz.poz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i000_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i000_i(p_cmd)
DEFINE
   p_cmd     LIKE type_file.chr1,      #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)
   l_plant_s LIKE type_file.chr10,     #No.FUN-980025
   l_plant   LIKE type_file.chr10,     #No.FUN-980025
   l_n,l_i   LIKE type_file.num5,      #No.FUN-680136 SMALLINT
   l_azp02   LIKE azp_file.azp02,      #FUN-670007
   l_azp02_1 LIKE azp_file.azp02,      #FUN-7C0004
   l_azp02_2 LIKE azp_file.azp02,      #FUN-7C0004
   l_poy04   LIKE poy_file.poy04,      #FUN-670007
   l_azw02_1 LIKE azw_file.azw02,      #No.FUN-980025
   l_azw02_2 LIKE azw_file.azw02,      #No.FUN-980025
   l_cnt     LIKE type_file.num5       #FUN-7C0004
DEFINE l_poz01 LIKE poz_file.poz01     #No.FUN-870007
DEFINE l_db_type    STRING         #TQC-AB0041         
 
   IF s_shut(0) THEN RETURN END IF
 
   DISPLAY BY NAME g_poz.poz01,g_poz.poz02,g_poz.poz00,g_poz.poz011,
                   g_poz.poz09,
                   g_poz.poz10,g_poz.poz11,g_poz.poz17,
                   g_poz.poz19,g_poz.poz18,
                   g_poz.poz12,g_poz.poz13,g_poz.poz14,   #FUN-7C0004 add poz12/13/14
                   g_poz.pozuser,g_poz.pozgrup,
                   g_poz.pozoriu,g_poz.pozorig,               #TQC-A30041 ADD
                   g_poz.pozmodu,g_poz.pozdate,g_poz.pozacti,
                   g_poz.pozud01,g_poz.pozud02,g_poz.pozud03,g_poz.pozud04,
                   g_poz.pozud05,g_poz.pozud06,g_poz.pozud07,g_poz.pozud08,
                   g_poz.pozud09,g_poz.pozud10,g_poz.pozud11,g_poz.pozud12,
                   g_poz.pozud13,g_poz.pozud14,g_poz.pozud15 
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT BY NAME g_poz.poz01,g_poz.poz00,g_poz.poz02,g_poz.poz011, g_poz.pozoriu,g_poz.pozorig,
                   g_poz.poz09,
                   g_poz.poz10,g_poz.poz11,g_poz.poz17,
                   g_poz.poz19,g_poz.poz18,     
                   g_poz.poz12,g_poz.poz20,g_poz.poz21,g_poz.poz13,g_poz.poz14,     #FUN-7C0004 add poz12/13/14 #No.FUN-870007-add-poz20,poz21
                   g_poz.pozuser,g_poz.pozgrup,
                   g_poz.pozmodu,g_poz.pozdate,g_poz.pozacti,
                   g_poz.pozud01,g_poz.pozud02,g_poz.pozud03,g_poz.pozud04,
                   g_poz.pozud05,g_poz.pozud06,g_poz.pozud07,g_poz.pozud08,
                   g_poz.pozud09,g_poz.pozud10,g_poz.pozud11,g_poz.pozud12,
                   g_poz.pozud13,g_poz.pozud14,g_poz.pozud15 
         WITHOUT DEFAULTS
 
      BEFORE INPUT
             CALL i000_used() RETURNING g_used   #FUN-620025
         LET g_before_input_done = FALSE
         CALL i000_set_entry(p_cmd)
         CALL i000_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
     BEFORE FIELD poz01
         IF p_cmd = 'a' THEN
            IF g_azw.azw04='2' THEN
               CALL cl_set_comp_entry("poz01",FALSE)
             # SELECT MAX(poz01) INTO l_poz01 FROM poz_file    #TQC-AB0041
             #  WHERE length(translate(poz01,'0123456789'||poz01,'0123456789'))=8     #TQC-AB0041
#TQC-AB0041 --Begin--
         LET l_db_type=cl_db_get_database_type()
         IF l_db_type = 'ASE' THEN 
             SELECT MAX(poz01) INTO l_poz01 FROM poz_file   
              WHERE len(str_replace(poz01,'0123456789'||poz01,'0123456789'))=8             
         ELSE
             SELECT MAX(poz01) INTO l_poz01 FROM poz_file    
              WHERE length(translate(poz01,'0123456789'||poz01,'0123456789'))=8     
         END IF             
#TQC-AB0041 --End----
               IF cl_null(l_poz01) THEN 
                  LET l_poz01 = 0 
               ELSE
                  IF NOT cl_numchk(l_poz01,LENGTH(l_poz01)) THEN
                     LET l_poz01 = 0
                  END IF
               END IF
               LET l_poz01 = l_poz01 + 1
               LET g_poz.poz01 = l_poz01 USING '&&&&&&&&'
               DISPLAY BY NAME g_poz.poz01
             ELSE
               CALL cl_set_comp_entry("poz01",TRUE)
             END IF
          END IF      
 
      AFTER FIELD poz01
         IF NOT cl_null(g_poz.poz01) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_poz.poz01 != g_poz01_t) THEN
               SELECT count(*) INTO l_n FROM poz_file
                WHERE poz01 = g_poz.poz01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_poz.poz01,-239,0)
                  LET g_poz.poz01 = g_poz01_t
                  DISPLAY BY NAME g_poz.poz01
                  NEXT FIELD poz01
               END IF
            END IF
         END IF
 
      AFTER FIELD poz00
         IF NOT cl_null(g_poz.poz00) THEN
            IF g_poz.poz00 NOT MATCHES '[12]' THEN
               NEXT FIELD poz00
            END IF
         END IF
 
      AFTER FIELD poz011
         IF NOT cl_null(g_poz.poz011) THEN
            IF g_poz.poz011 NOT MATCHES '[12]' THEN
               NEXT FIELD poz011
            END IF
            IF (NOT cl_null(g_poz_t.poz011)) AND
               (g_poz.poz011<>g_poz_t.poz011) THEN
               CALL cl_err('','apm-051',1)
            END IF
         END IF
         IF g_poz.poz011 = '1' THEN LET g_poz.poz19 = 'N' END IF
         DISPLAY BY NAME g_poz.poz19
         
         CALL i000_set_entry(p_cmd)
         CALL i000_set_no_entry(p_cmd)
 
      BEFORE FIELD poz12
        IF g_poz.poz011 = '1' THEN
         CALL i000_set_entry(p_cmd)
         CALL i000_set_no_entry(p_cmd)
        END IF
 
      ON CHANGE poz12
         CALL i000_set_entry(p_cmd)
         CALL i000_set_no_entry(p_cmd)
 
      BEFORE FIELD poz19 
         CALL i000_set_entry(p_cmd)
         CALL i000_set_no_entry(p_cmd)
 
      ON CHANGE poz19
 
         CALL i000_set_entry(p_cmd)
         CALL i000_set_no_entry(p_cmd)
     ON CHANGE poz20
        CALL i000_set_entry(p_cmd)
        CALL i000_set_no_entry(p_cmd)
 
     AFTER FIELD poz19                                          #FUN-870130
       IF p_cmd = 'u' THEN   #MOD-A50147
          IF g_poz.poz19 = 'Y' THEN                                #FUN-870130
            SELECT poy04 INTO g_poz.poz18                          #FUN-870130
              FROM poy_file,poz_file                               #FUN-870130     
             WHERE poy01 = poz01                                   #FUN-870130
               AND poy01 = g_poz.poz01                             #FUN-870130 
               AND poy02 = '0'                                     #FUN-870130
            IF cl_null(g_poz.poz18) THEN                           #FUN-870130
               CALL cl_err('','apm-118',1)                         #FUN-870130
               NEXT FIELD poz19   #MOD-A50147
            END IF                                                 #FUN-870130
          #-----MOD-A50147---------
          ELSE
             LET g_poz.poz18 = ''
             DISPLAY BY NAME g_poz.poz18
          #-----END MOD-A50147-----
          END IF                                                   #FUN-870130
       END IF   #MOD-A50147
 
#-----MOD-A50147---------
#     AFTER FIELD poz18 
#        IF g_poz.poz19 = 'Y' THEN
#            IF NOT cl_null(g_poz.poz18) THEN
#                CALL i000_azp(g_poz.poz18) RETURNING g_dbs,l_plant_g  #No.FUN-980025
#                IF NOT cl_null(g_errno) THEN
#                    CALL cl_err(g_poz.poz18,g_errno,0)
#                    LET g_poz.poz18 = g_poz_t.poz18
#                    DISPLAY BY NAME g_poz.poz18
#                    NEXT FIELD poz18
#                END IF
#                SELECT azp02 INTO l_azp02 
#                  FROM azp_file
#                 WHERE azp01 = g_poz.poz18  
#                IF NOT cl_null(l_azp02) THEN 
#                    DISPLAY l_azp02 TO FORMONLY.azp02 
#                END IF
#            ELSE
#                NEXT FIELD poz18 
#            END IF
#        END IF
#-----END MOD-A50147-----
 
      BEFORE FIELD poz13
        LET g_poz.poz13 = g_plant
        DISPLAY BY NAME g_poz.poz13
 
      AFTER FIELD poz13 
        IF NOT cl_null(g_poz.poz13) AND NOT cl_null(g_poz.poz14) THEN 
         SELECT azw02 INTO l_azw02_1 FROM azw_file 
          WHERE azw01 = g_poz.poz13 
         SELECT azw02 INTO l_azw02_2 FROM azw_file 
          WHERE azw01 = g_poz.poz14
           IF  l_azw02_1 = l_azw02_2 THEN 
             CALL cl_err('','azw-002',1) 
             LET g_poz.poz13 = g_poz_t.poz13
             NEXT FIELD poz13  
           END IF 
         END IF 
          CALL i000_azp(g_poz.poz13) RETURNING g_dbs,l_plant_g #No.FUN-9A0092
          IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_poz.poz13,g_errno,0)
              LET g_poz.poz13 = g_poz_t.poz13
              DISPLAY BY NAME g_poz.poz13
              NEXT FIELD poz13
          END IF           
         IF g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12)  THEN   #TQC-7C0164
             IF NOT cl_null(g_poz.poz13) THEN
                 IF NOT cl_null(g_poz.poz14) THEN
                   SELECT COUNT(*) INTO l_cnt FROM poz_file
                    WHERE poz12 = 'Y' 
                      AND poz13 = g_poz.poz13
                      AND poz14 = g_poz.poz14
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_poz.poz14,'apm-970',0)
                      LET g_poz.poz13 = g_poz_t.poz13
                      NEXT FIELD poz13
                   END IF
                 END IF
                 SELECT azp02 INTO l_azp02_1 
                   FROM azp_file
                  WHERE azp01 = g_poz.poz13  
                 IF NOT cl_null(l_azp02_1) THEN 
                     DISPLAY l_azp02_1 TO FORMONLY.azp02_1 
                 END IF                                          
             ELSE
                 NEXT FIELD poz13 
             END IF
         END IF
 
      AFTER FIELD poz14 
        CALL i000_azp(g_poz.poz14) RETURNING g_dbs,l_plant_g  #No.FUN-9A0092
        IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_poz.poz14,g_errno,0)
            LET g_poz.poz14 = g_poz_t.poz14
            DISPLAY BY NAME g_poz.poz14
            NEXT FIELD poz14
        END IF
        IF NOT cl_null(g_poz.poz13) AND NOT cl_null(g_poz.poz14) THEN 
         SELECT azw02 INTO l_azw02_1 FROM azw_file 
          WHERE azw01 = g_poz.poz13 
         SELECT azw02 INTO l_azw02_2 FROM azw_file 
          WHERE azw01 = g_poz.poz14
           IF  l_azw02_2 = l_azw02_1 THEN 
             CALL cl_err('','azw-003',1) 
             LET g_poz.poz14 = g_poz_t.poz14
             NEXT FIELD poz14  
           END IF 
         END IF   

         IF g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12) THEN   #TQC-7C0164
             IF NOT cl_null(g_poz.poz14) THEN
                 IF NOT cl_null(g_poz.poz13) THEN
                   SELECT COUNT(*) INTO l_cnt FROM poz_file
                    WHERE poz12 = 'Y' 
                      AND poz13 = g_poz.poz13
                      AND poz14 = g_poz.poz14
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_poz.poz14,'apm-970',0)
                      LET g_poz.poz14 = g_poz_t.poz14
                      NEXT FIELD poz14
                   END IF
                 END IF
                 SELECT azp02 INTO l_azp02_2 
                   FROM azp_file
                  WHERE azp01 = g_poz.poz14  
                 IF NOT cl_null(l_azp02_2) THEN 
                     DISPLAY l_azp02_2 TO FORMONLY.azp02_2 
                 END IF
             ELSE
                 NEXT FIELD poz14 
             END IF
         END IF
        AFTER FIELD poz21
           IF NOT cl_null(g_poz.poz21) THEN
              CALL i000_poz21('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_poz.poz21=g_poz_t.poz21
                 DISPLAY BY NAME g_poz.poz21
                 NEXT FIELD poz21
              END IF
           END IF
 
        AFTER FIELD pozud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pozud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(poz18)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azp"
                LET g_qryparam.default1 = g_poz.poz18
                CALL cl_create_qry() RETURNING g_poz.poz18
                DISPLAY BY NAME g_poz.poz18
                NEXT FIELD poz18
             WHEN INFIELD(poz13)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azp"
                LET g_qryparam.default1 = g_poz.poz13
                CALL cl_create_qry() RETURNING g_poz.poz13
                DISPLAY BY NAME g_poz.poz13
                NEXT FIELD poz13
             WHEN INFIELD(poz14)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azp"
                LET g_qryparam.default1 = g_poz.poz14
                CALL cl_create_qry() RETURNING g_poz.poz14
                DISPLAY BY NAME g_poz.poz14
                NEXT FIELD poz14
            WHEN INFIELD(poz21)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_poz01"
                LET g_qryparam.where = "poz20='Y'"
                LET g_qryparam.default1 = g_poz.poz21
                CALL cl_create_qry() RETURNING g_poz.poz21
                DISPLAY BY NAME g_poz.poz21
                CALL i000_poz21('d')
                NEXT FIELD poz21
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
 
END FUNCTION
 
FUNCTION i000_poz21(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_pozacti LIKE poz_file.pozacti
DEFINE l_poz20 LIKE poz_file.poz20
DEFINE l_poz21_desc LIKE poz_file.poz02
 
    LET g_errno=''
    SELECT poz02,poz20,pozacti
      INTO l_poz21_desc,l_poz20,l_pozacti
      FROM poz_file
     WHERE poz01 = g_poz.poz21
    CASE
       WHEN SQLCA.sqlcode=100 LET g_errno='tri-006'
       WHEN l_pozacti='N' LET g_errno='tri-009'
       WHEN l_poz20='N' LET g_errno='art-282'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY l_poz21_desc TO poz21_desc
    END IF
END FUNCTION
 
#FUNCTION i000_azi(p_azi01,p_dbs)  #幣別
FUNCTION i000_azi(p_azi01,l_plant)  #幣別  #FUN-A50102
    DEFINE p_azi01   LIKE azi_file.azi01,
           l_azi02   LIKE azi_file.azi02,
           l_aziacti LIKE azi_file.aziacti,
           #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21),
           l_plant   LIKE type_file.chr21,    #FUN-A50102
           l_sql        STRING       #NO.FUN-910082
 
   LET g_errno = ' '
   #LET l_sql = " SELECT azi02,aziacti FROM ",p_dbs CLIPPED,"azi_file ",
   LET l_sql = " SELECT azi02,aziacti FROM ",cl_get_target_table(l_plant,'azi_file'), #FUN-A50102
               "  WHERE azi01 = '",p_azi01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE azi_pre FROM l_sql
   DECLARE azi_cs CURSOR FOR azi_pre
   OPEN azi_cs
   FETCH azi_cs INTO l_azi02,l_aziacti
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_azi02 = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   CLOSE azi_cs
END FUNCTION
 
#FUNCTION i000_pmc(p_code,p_cmd,p_dbs)  #供應廠商
FUNCTION i000_pmc(p_code,p_cmd,l_plant)  #供應廠商  #FUN-A50102
 DEFINE p_code    LIKE pmc_file.pmc01,
        p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
        l_pmc03   LIKE pmc_file.pmc03,
        l_pmc30   LIKE pmc_file.pmc30,
        l_pmcacti LIKE pmc_file.pmcacti,
        l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(300)
        #p_dbs     LIKE type_file.chr21    #No.FUN-680136 VARCHAR(21)
        l_plant   LIKE type_file.chr21    #FUN-A50102
 
#FUN-AC0046--add--str---
     IF l_plant = 'xxx' OR l_plant = 'yyy' THEN
        RETURN  ' '
     END IF
#FUN-AC0046--add--end---
     #IF cl_null(p_dbs) THEN LET p_dbs='' END IF
     IF cl_null(l_plant) THEN LET l_plant='' END IF
     LET g_errno = ' '
     #LET l_sql = " SELECT pmc03,pmc30,pmcacti FROM ",p_dbs CLIPPED,"pmc_file" ,
     LET l_sql = " SELECT pmc03,pmc30,pmcacti FROM ",cl_get_target_table(l_plant,'pmc_file'), #FUN-A50102
                 "  WHERE pmc01 = '",p_code,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE pmc_pre FROM l_sql
     DECLARE pmc_cs CURSOR FOR pmc_pre
     OPEN pmc_cs
     FETCH pmc_cs INTO l_pmc03,l_pmc30,l_pmcacti
     CASE
        WHEN SQLCA.SQLCODE = 100
           IF p_cmd = 's' THEN
              LET g_errno = 'mfg3014'
           ELSE
              LET g_errno = 'apm-996'
           END IF
           LET l_pmc03 = NULL
        WHEN l_pmcacti='N'
           LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'       
           LET g_errno = '9038'         #No.FUN-690024
        WHEN l_pmc30  ='2'
           LET g_errno = 'mfg3227'      #付款商
        OTHERWISE
           LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
 
     IF (cl_null(g_errno) AND p_cmd = 's') OR p_cmd = 'd' THEN
        DISPLAY l_pmc03 TO FORMONLY.pmc03
     END IF
 
     IF p_cmd = 'e' THEN ERROR l_pmc03 END IF
     CLOSE pmc_cs
     RETURN l_pmc03    #NO.FUN-670007 add
END FUNCTION
 
#FUNCTION i000_occ_chk(p_key,p_dbs) #客戶基本資料
FUNCTION i000_occ_chk(p_key,l_plant) #客戶基本資料  #FUN-A50102
 DEFINE p_key     LIKE occ_file.occ01
 DEFINE l_occ06   LIKE occ_file.occ06
 DEFINE l_occ1004 LIKE occ_file.occ1004
 DEFINE l_occacti LIKE occ_file.occacti
 #DEFINE p_dbs     LIKE type_file.chr21
 DEFINE l_plant   LIKE type_file.chr21    #FUN-A50102
 DEFINE l_sql     LIKE type_file.chr1000
 
     #IF cl_null(p_dbs) THEN LET p_dbs='' END IF
     IF cl_null(l_plant) THEN LET l_plant='' END IF     #FUN-A50102
     LET g_errno = ' '
     #LET l_sql = " SELECT occ06,occ1004,occacti FROM ",p_dbs CLIPPED,"occ_file" ,
     LET l_sql = " SELECT occ06,occ1004,occacti FROM ",cl_get_target_table(l_plant,'occ_file'), #FUN-A50102
                 "  WHERE occ01 = '",p_key,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE occ_pre1 FROM l_sql
     DECLARE occ_cs1 CURSOR FOR occ_pre1
     OPEN occ_cs1
     FETCH occ_cs1 INTO l_occ06,l_occ1004,l_occacti
 
     CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'apm-995'
          WHEN l_occacti='N'       LET g_errno = 'apm-063'
          WHEN l_occ06 <> '1'      LET g_errno = 'apm-064'
          WHEN l_occ1004 <> '1'    LET g_errno = 'apm-065'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     CLOSE occ_cs1
END FUNCTION
 
#FUNCTION i000_occ(p_key,p_dbs) #客戶基本資料
FUNCTION i000_occ(p_key,l_plant) #客戶基本資料  #FUN-A50102
 DEFINE p_key     LIKE occ_file.occ01,
        l_occacti LIKE occ_file.occacti,
        #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
        l_plant   LIKE type_file.chr21,    #FUN-A50102
        l_sql     LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(300)
 
     #IF cl_null(p_dbs) THEN LET p_dbs='' END IF
     IF cl_null(l_plant) THEN LET l_plant = '' END IF   #FUN-A50102
     LET g_errno = ' '
     #LET l_sql = " SELECT occacti FROM ",p_dbs CLIPPED,"occ_file" ,
     LET l_sql = " SELECT occacti FROM ",cl_get_target_table(l_plant,'occ_file'), #FUN-A50102
                 "  WHERE occ01 = '",p_key,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE occ_pre FROM l_sql
     DECLARE occ_cs CURSOR FOR occ_pre
     OPEN occ_cs
     FETCH occ_cs INTO l_occacti
 
     CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'apm-995'
          WHEN l_occacti='N' LET g_errno = '9028'
          WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     CLOSE occ_cs
 
END FUNCTION
 
#FUNCTION i000_ool(p_code,p_dbs)  #AR 類別
FUNCTION i000_ool(p_code,l_plant)  #AR 類別  #FUN-A50102
  DEFINE p_code   LIKE ool_file.ool01,
         l_ool02  LIKE ool_file.ool02,
         #p_dbs    LIKE type_file.chr21,  #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
 
     LET g_errno = ''
     #LET l_sql = " SELECT ool02  FROM ",p_dbs,"ool_file ",
     LET l_sql = " SELECT ool02  FROM ",cl_get_target_table(l_plant,'ool_file'), #FUN-A50102
                 "  WHERE ool01 = '",p_code,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE ool_pre FROM l_sql
     DECLARE ool_cs CURSOR FOR ool_pre
     OPEN ool_cs
     FETCH ool_cs INTO l_ool02
 
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9169'
                                    LET l_ool02 = NULL
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     CLOSE ool_cs
 
END FUNCTION
 
#FUNCTION i000_apr(p_code,p_dbs)
FUNCTION i000_apr(p_code,l_plant)   #FUN-A50102
 DEFINE p_code    LIKE apr_file.apr01,
        #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
        l_plant   LIKE type_file.chr21,    #FUN-A50102
        l_apr02   LIKE apr_file.apr02,
        l_apracti LIKE apr_file.apracti,
        l_sql     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
 
     LET g_errno = ' '
     #LET l_sql=" SELECT apr02,apracti FROM ",p_dbs CLIPPED,"apr_file ",
     LET l_sql=" SELECT apr02,apracti FROM ",cl_get_target_table(l_plant,'apr_file'), #FUN-A50102
               "  WHERE apr01 = '",p_code ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE apr_pre FROM l_sql
     DECLARE apr_cs CURSOR FOR apr_pre
     OPEN apr_cs
     FETCH apr_cs INTO l_apr02,l_apracti
 
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9169'
                                    LET l_apr02 = NULL
          WHEN l_apracti='N' LET g_errno = '9028'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     CLOSE apr_cs
 
END FUNCTION
 
#FUNCTION i000_pma(p_pma01,p_dbs)
FUNCTION i000_pma(p_pma01,l_plant)   #FUN-A50102
  DEFINE p_pma01   LIKE pma_file.pma01,
         l_pmaacti LIKE pma_file.pmaacti,
         #p_dbs     LIKE type_file.chr21,  #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
 
   LET g_errno=' '
   #LET l_sql="SELECT pmaacti FROM ",p_dbs CLIPPED,"pma_file",
   LET l_sql="SELECT pmaacti FROM ",cl_get_target_table(l_plant,'pma_file'), #FUN-A50102
             " WHERE pma01 = '",p_pma01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE pma_pre FROM l_sql
   DECLARE pma_cs CURSOR FOR pma_pre
   OPEN pma_cs
   FETCH pma_cs INTO l_pmaacti
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                                  LET l_pmaacti = NULL
        WHEN l_pmaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   CLOSE pma_cs
 
END FUNCTION
 
#FUNCTION i000_oag(p_oag01,p_dbs)
FUNCTION i000_oag(p_oag01,l_plant)   #FUN-A50102
  DEFINE p_oag01   LIKE oag_file.oag01,
         l_oag02   LIKE oag_file.oag02,
         #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(400)
 
   LET g_errno=''
   #LET l_sql="SELECT oag02  FROM ",p_dbs CLIPPED,"oag_file",
   LET l_sql="SELECT oag02  FROM ",cl_get_target_table(l_plant,'oag_file'), #FUN-A50102
             " WHERE oag01 = '",p_oag01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE oag_pre FROM l_sql
   DECLARE oag_cs CURSOR FOR oag_pre
   OPEN oag_cs
   FETCH oag_cs INTO l_oag02
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9357'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   CLOSE oag_cs
END FUNCTION
 
#FUNCTION i000_oab(p_oab01,p_dbs)
FUNCTION i000_oab(p_oab01,l_plant)  #FUN-A50102
  DEFINE p_oab01   LIKE oab_file.oab01,
         l_oab02   LIKE oab_file.oab02,
         #p_dbs     LIKE type_file.chr21,  #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
 
   LET g_errno=''
   #LET l_sql="SELECT oab02  FROM ",p_dbs CLIPPED,"oab_file",
   LET l_sql="SELECT oab02  FROM ",cl_get_target_table(l_plant,'oab_file'), #FUN-A50102
             " WHERE oab01 = '",p_oab01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE oab_pre FROM l_sql
   DECLARE oab_cs CURSOR FOR oab_pre
   OPEN oab_cs
   FETCH oab_cs INTO l_oab02
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4099'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   CLOSE oab_cs
END FUNCTION
 
#FUNCTION i000_imd(p_imd01,p_dbs)
FUNCTION i000_imd(p_imd01,l_plant)   #FUN-A50102
  DEFINE p_imd01   LIKE imd_file.imd01,
         l_imd11   LIKE imd_file.imd11,
         #p_dbs     LIKE type_file.chr21,  #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
 
   LET g_errno=''
   #LET l_sql="SELECT imd11  FROM ",p_dbs CLIPPED,"imd_file",
   LET l_sql="SELECT imd11  FROM ",cl_get_target_table(l_plant,'imd_file'), #FUN-A50102
             " WHERE imd01 = '",p_imd01,"'",
             "   AND imd10 = 'S' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE imd_pre FROM l_sql
   DECLARE imd_cs CURSOR FOR imd_pre
   OPEN imd_cs
   FETCH imd_cs INTO l_imd11
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
        WHEN l_imd11 ='N'         LET g_errno = 'mfg6080'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   CLOSE imd_cs
END FUNCTION
 
#FUNCTION i000_gec(p_gec01,p_type,p_dbs)
FUNCTION i000_gec(p_gec01,p_type,l_plant)  #FUN-A50102
  DEFINE p_gec01   LIKE gec_file.gec01,
         p_type    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_gecacti LIKE gec_file.gecacti
 
  LET g_errno=' '
  #LET l_sql = " SELECT gecacti FROM ",p_dbs CLIPPED,"gec_file ",	#MOD-960178
  LET l_sql = " SELECT gecacti FROM ",cl_get_target_table(l_plant,'gec_file'), #FUN-A50102
              "  WHERE gec01 = '",p_gec01,"'",
              "    AND gec011= '",p_type ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE gec_pre FROM l_sql
  DECLARE gec_cs CURSOR FOR gec_pre
  OPEN gec_cs
  FETCH gec_cs INTO l_gecacti
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                 LET l_gecacti = NULL
       WHEN l_gecacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  CLOSE gec_cs
END FUNCTION
 
#查找當前站符合條件的代送商資料
#FUNCTION i000_ocx(p_occ01,p_dbs)
FUNCTION i000_ocx(p_occ01,l_plant)  #FUN-A50102
  DEFINE p_occ01   LIKE occ_file.occ01,
         #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_occacti LIKE occ_file.occacti,
         l_occ02   LIKE occ_file.occ02
 
#FUN-AC0046--add--str---
     IF l_plant = 'xxx' OR l_plant = 'yyy' THEN
        RETURN  ' '
     END IF
#FUN-AC0046--add--end---
  LET g_errno=' '
  #LET l_sql = " SELECT occ02 FROM ",p_dbs CLIPPED,"occ_file ",	#MOD-960178
  LET l_sql = " SELECT occ02 FROM ",cl_get_target_table(l_plant,'occ_file'), #FUN-A50102
              "  WHERE occ01 = '",p_occ01,"'",
              "    AND occ1004 = '1' ",
              "    AND occacti = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE ocx_pre FROM l_sql
  DECLARE ocx_cs CURSOR FOR ocx_pre
  OPEN ocx_cs
  FETCH ocx_cs INTO l_occ02
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-045'
                                 LET l_occacti = NULL
       WHEN l_occacti='N' LET g_errno = '9028'
       WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  CLOSE ocx_cs
  RETURN l_occ02
END FUNCTION
 
#FUNCTION i000_gem(p_gem01,p_dbs)
FUNCTION i000_gem(p_gem01,l_plant)  #FUN-A50102
  DEFINE p_gem01   LIKE gem_file.gem01,
         #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_gemacti LIKE gem_file.gemacti
 
  LET g_errno=' '
  #LET l_sql = " SELECT gemacti FROM ",p_dbs CLIPPED,"gem_file ",	#MOD-960178
  LET l_sql = " SELECT gemacti FROM ",cl_get_target_table(l_plant,'gem_file'), #FUN-A50102
              "  WHERE gem01 = '",p_gem01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE gem_pre FROM l_sql
  DECLARE gem_cs CURSOR FOR gem_pre
  OPEN gem_cs
  FETCH gem_cs INTO l_gemacti
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4001'
                                 LET l_gemacti = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  CLOSE gem_cs
END FUNCTION
 
#FUNCTION i000_tqa(p_tqa01,p_dbs)
FUNCTION i000_tqa(p_tqa01,l_plant)  #FUN-A50102
  DEFINE p_tqa01   LIKE tqa_file.tqa01,
         #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_tqaacti LIKE tqa_file.tqaacti
 
  LET g_errno=' '
  #LET l_sql = " SELECT tqaacti FROM ",p_dbs CLIPPED,"tqa_file ",	#MOD-960178
  LET l_sql = " SELECT tqaacti FROM ",cl_get_target_table(l_plant,'tqa_file'), #FUN-A50102
              "  WHERE tqa01 = '",p_tqa01,"'",
              "    AND tqa03='20' and tqaacti='Y' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE tqa_pre FROM l_sql
  DECLARE tqa_cs CURSOR FOR tqa_pre
  OPEN tqa_cs
  FETCH tqa_cs INTO l_tqaacti
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-334'
                                 LET l_tqaacti = NULL
       WHEN l_tqaacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  CLOSE tqa_cs
 
END FUNCTION
 
#FUNCTION i000_tqb(p_tqb01,p_dbs)
FUNCTION i000_tqb(p_tqb01,l_plant)  #FUN-A50102
  DEFINE p_tqb01   LIKE tqb_file.tqb01,
         #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_tqb02   LIKE tqb_file.tqb02,
         l_tqbacti LIKE tqb_file.tqbacti
 
  LET g_errno=' '
  #LET l_sql = " SELECT tqb02,tqbacti FROM ",p_dbs CLIPPED,"tqb_file ",	#MOD-960178
  LET l_sql = " SELECT tqb02,tqbacti FROM ",cl_get_target_table(l_plant,'tqb_file'), #FUN-A50102
              "  WHERE tqb01 = '",p_tqb01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE tqb_pre FROM l_sql
  DECLARE tqb_cs CURSOR FOR tqb_pre
  OPEN tqb_cs
  FETCH tqb_cs INTO l_tqb02,l_tqbacti
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-001'
                                 LET l_tqbacti = NULL
       WHEN l_tqbacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  CLOSE tqb_cs
  RETURN l_tqb02
 
END FUNCTION
 
#FUNCTION i000_oay(p_no,p_dbs)
FUNCTION i000_oay(p_no,l_plant)  #FUN-A50102
  DEFINE p_no      LIKE poy_file.poy34,
         #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_oay22   LIKE oay_file.oay22     
 
  LET g_errno=' '
  #LET l_sql = " SELECT oay22 FROM ",p_dbs CLIPPED,"oay_file ",
  LET l_sql = " SELECT oay22 FROM ",cl_get_target_table(l_plant,'oay_file'), #FUN-A50102
              "  WHERE oayslip = '",p_no,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE oay_pre FROM l_sql
  DECLARE oay_cs CURSOR FOR oay_pre
  OPEN oay_cs
  FETCH oay_cs INTO l_oay22
  CLOSE oay_cs
  RETURN l_oay22
 
END FUNCTION
 
#FUNCTION i000_smy(p_no,p_dbs)
FUNCTION i000_smy(p_no,l_plant)  #FUN-A50102
  DEFINE p_no      LIKE poy_file.poy35,
         #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_smy62   LIKE smy_file.smy62 
  LET g_errno=' '
  #LET l_sql = " SELECT smy62 FROM ",p_dbs CLIPPED,"smy_file ",
  LET l_sql = " SELECT smy62 FROM ",cl_get_target_table(l_plant,'smy_file'), #FUN-A50102
              "  WHERE smyslip = '",p_no,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE smy_pre FROM l_sql
  DECLARE smy_cs CURSOR FOR smy_pre
  OPEN smy_cs
  FETCH smy_cs INTO l_smy62
  CLOSE smy_cs
  RETURN l_smy62 
 
END FUNCTION
#FUNCTION i000_poy_gem(p_gem01,p_dbs)
FUNCTION i000_poy_gem(p_gem01,l_plant)  #FUN-A50102
  DEFINE p_gem01   LIKE gem_file.gem01,
         #p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,    #FUN-A50102
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_gemacti LIKE gem_file.gemacti
 
  LET g_errno=' '
  #LET l_sql = " SELECT gemacti FROM ",p_dbs CLIPPED,"gem_file ",	#MOD-960178
  LET l_sql = " SELECT gemacti FROM ",cl_get_target_table(l_plant,'gem_file'), #FUN-A50102
              "  WHERE gem01 = '",p_gem01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE gem_pre2 FROM l_sql
  DECLARE gem_cs2 CURSOR FOR gem_pre2
  OPEN gem_cs2
  FETCH gem_cs2 INTO l_gemacti
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4001'
                                 LET l_gemacti = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  CLOSE gem_cs2
END FUNCTION
 
FUNCTION i000_azp(l_azp01)
  DEFINE l_azp01  LIKE azp_file.azp01,
         l_azp03  LIKE azp_file.azp03,
         l_azp053 LIKE azp_file.azp03
  DEFINE l_dbs    LIKE type_file.chr21   #No.FUN-680136 VARCHAR(21)
  DEFINE l_plant  LIKE type_file.chr10   #No.FUN-980025 VARCHAR(21)  #No.FUN-980025
 
    LET g_errno=' '
    SELECT azp03,azp053 INTO l_azp03,l_azp053 FROM azp_file
      WHERE azp01=l_azp01
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'
          WHEN l_azp053 ='N' LET g_errno = 'mfg8000'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET l_dbs = s_dbstring(l_azp03 CLIPPED) #TQC-940177 
    LET l_plant = l_azp01            #No.FUN-980025
    RETURN l_dbs,l_plant             #No.FUN-980025
END FUNCTION
 
FUNCTION i000_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i000_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_poz.* TO NULL
      RETURN
   END IF
 
   OPEN i000_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_poz.* TO NULL
   ELSE
      OPEN i000_count
      FETCH i000_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i000_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i000_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680136 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i000_cs INTO g_poz.poz01
        WHEN 'P' FETCH PREVIOUS i000_cs INTO g_poz.poz01
        WHEN 'F' FETCH FIRST    i000_cs INTO g_poz.poz01
        WHEN 'L' FETCH LAST     i000_cs INTO g_poz.poz01
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
            FETCH ABSOLUTE g_jump i000_cs INTO g_poz.poz01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_poz.poz01,SQLCA.sqlcode,0)
       INITIALIZE g_poz.* TO NULL            #FUN-6B0079 add
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
    SELECT * INTO g_poz.* FROM poz_file WHERE poz01 = g_poz.poz01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","poz_file",g_poz.poz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       INITIALIZE g_poz.* TO NULL
       RETURN
    END IF
    LET g_data_owner = g_poz.pozuser      #FUN-4C0056 add
    LET g_data_group = g_poz.pozgrup      #FUN-4C0056 add
    CALL i000_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i000_show()
 DEFINE  l_azp02,l_azp02_1,l_azp02_2  LIKE azp_file.azp02      #FUN-7C0004
 DEFINE l_poz02 LIKE poz_file.poz02   #No.FUN-870007
 
    LET l_azp02 = ''
    LET l_azp02_1 = ''
    LET l_azp02_2 = ''
 
    LET g_poz_t.* = g_poz.*                      #保存單頭舊值
    LET g_poz_o.* = g_poz.*                      #保存單頭舊值
    DISPLAY BY NAME g_poz.pozoriu,g_poz.pozorig,
        g_poz.poz01,g_poz.poz02,g_poz.poz00,g_poz.poz011,
         g_poz.poz09,g_poz.poz10,g_poz.poz11,g_poz.poz17,  #FUN-620025
         g_poz.poz19,g_poz.poz18,   #NO.FUN-670007 add
         g_poz.poz12,g_poz.poz13,g_poz.poz14,  #FUN-7C0004 add
        g_poz.poz20,g_poz.poz21,               #No.FUN-870007
        g_poz.pozuser,g_poz.pozgrup,g_poz.pozmodu,g_poz.pozdate,g_poz.pozacti,
         g_poz.pozud01,g_poz.pozud02,g_poz.pozud03,g_poz.pozud04,
         g_poz.pozud05,g_poz.pozud06,g_poz.pozud07,g_poz.pozud08,
         g_poz.pozud09,g_poz.pozud10,g_poz.pozud11,g_poz.pozud12,
         g_poz.pozud13,g_poz.pozud14,g_poz.pozud15 
 
    IF NOT cl_null(g_poz.poz18) THEN
       SELECT azp02 INTO l_azp02 FROM azp_file
        WHERE azp01 = g_poz.poz18 
       IF SQLCA.sqlcode THEN LET l_azp02 = NULL END IF
    END IF
    IF NOT cl_null(g_poz.poz13) THEN
       SELECT azp02 INTO l_azp02_1 FROM azp_file
        WHERE azp01 = g_poz.poz13 
       IF SQLCA.sqlcode THEN LET l_azp02_1 = NULL END IF
    END IF
    IF NOT cl_null(g_poz.poz14) THEN
       SELECT azp02 INTO l_azp02_2 FROM azp_file
        WHERE azp01 = g_poz.poz14 
       IF SQLCA.sqlcode THEN LET l_azp02_2 = NULL END IF
    END IF
    DISPLAY l_azp02 TO FORMONLY.azp02
    DISPLAY l_azp02_1 TO FORMONLY.azp02_1
    DISPLAY l_azp02_2 TO FORMONLY.azp02_2
    IF NOT cl_null(g_poz.poz21) THEN
       SELECT poz02 INTO l_poz02 FROM poz_file
        WHERE poz01 = g_poz.poz21
       DISPLAY l_poz02 TO poz21_desc
    END IF
    CALL cl_set_field_pic('','',"","",'',g_poz.pozacti)  #MOD-530006
    CALL i000_b_fill(g_wc2)                 #單身
    CALL i000_b1_fill(' 1=1') 
    CALL i000_b2_fill(' 1=1') 
    CALL i000_b3_fill(' 1=1') 
    CALL i000_b4_fill(' 1=1') 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i000_x()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_poz.poz01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i000_cl USING g_poz.poz01
   IF STATUS THEN
      CALL cl_err("OPEN i000_cl:", STATUS, 1)
      CLOSE i000_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i000_cl INTO g_poz.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_poz.poz01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i000_show()
 
   IF cl_exp(0,0,g_poz.pozacti) THEN                   #確認一下
      LET g_chr=g_poz.pozacti
      IF g_poz.pozacti='Y' THEN
         LET g_poz.pozacti='N'
      ELSE
         LET g_poz.pozacti='Y'
      END IF
      UPDATE poz_file                    #更改有效碼
         SET pozacti=g_poz.pozacti
       WHERE poz01=g_poz.poz01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","poz_file",g_poz.poz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_poz.pozacti=g_chr
      END IF
      DISPLAY BY NAME g_poz.pozacti
   END IF
   CALL cl_set_field_pic('','',"","",'',g_poz.pozacti)  #MOD-530006
 
   CLOSE i000_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i000_r()
 DEFINE l_i LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_poz.poz01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_poz.pozacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_poz.poz01,'mfg1000',0)
      RETURN
   END IF
 
   #已被使用，則無法刪除！
   CALL i000_used()
       RETURNING g_used
   IF g_used = 'Y' THEN
      CALL cl_err('',"apm-802",1)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i000_cl USING g_poz.poz01
   IF STATUS THEN
      CALL cl_err("OPEN i000_cl:", STATUS, 1)
      CLOSE i000_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i000_cl INTO g_poz.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_poz.poz01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i000_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "poz01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_poz.poz01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM poz_file WHERE poz01 = g_poz.poz01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","poz_file",g_poz.poz01,"",SQLCA.sqlcode,"","delete poz_file",1)  #No.FUN-660129
         ROLLBACK WORK
         #No.FUN-B80088---增加空白行---



      ELSE
         DELETE FROM poy_file WHERE poy01 = g_poz.poz01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","poy_file","g_poz.poz01","",
                          SQLCA.sqlcode,"","delete poy_file",1)  #No.FUN-660129
            ROLLBACK WORK
         ELSE
            COMMIT WORK
            CLEAR FORM
            INITIALIZE g_poz.* TO NULL
            CALL g_poy.clear()
            OPEN i000_count
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i000_cs
               CLOSE i000_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i000_count INTO g_row_count
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i000_cs
               CLOSE i000_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i000_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i000_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i000_fetch('/')
            END IF
         END IF
      END IF
   END IF
   CLOSE i000_cl
 
END FUNCTION
 
FUNCTION i000_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_n1            LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680136 VARCHAR(1)
    t_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)   #上游資料庫
    l_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)   #當站資料庫
    l_plant         LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(21)   #當站資料庫
    l_plant_s       LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(21)   #當站資料庫
    q_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)   #FUN-620025
    t_azp03         LIKE azp_file.azp03,
    l_poy02         LIKE poy_file.poy02,
    l_poy03         LIKE poy_file.poy03,
    l_poy04         LIKE poy_file.poy04,
    l_poy26         LIKE poy_file.poy26,                #是否計算業績(是:Y,否:N) #FUN-620025
    l_occ02         LIKE occ_file.occ02,                #FUN-620025
    l_int_flag      LIKE type_file.chr1,                #按了放棄鍵否(是:Y,否:N) #MOD-570095 add  #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-680136 SMALLINT
    l_pmc03         LIKE pmc_file.pmc03,                 #NO.FUN-670007
    l_pox           LIKE type_file.num5                #NO.TQC-740089
DEFINE l_ac1        LIKE type_file.num5                #No.TQC-760152
DEFINE l_poy02_min  LIKE poy_file.poy02   #No.FUN-870007
DEFINE l_poy02_max  LIKE poy_file.poy02   #No.FUN-870007
DEFINE t_plant      LIKE type_file.chr21  #FUN-A50102
 
    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_poz.poz01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_poz.* FROM poz_file WHERE poz01=g_poz.poz01
    IF g_poz.pozacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_poz.poz01,'mfg1000',0)
       RETURN
    END IF
 
    LET g_success='Y'
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT poy02,poy04,poy03,' ',poy05,poy20,",
                       "       poyud01,poyud02,poyud03,poyud04,poyud05,",
                       "       poyud06,poyud07,poyud08,poyud09,poyud10,",
                       "       poyud11,poyud12,poyud13,poyud14,poyud15", 
                       "  FROM poy_file", 
                       " WHERE poy01=? AND poy02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i000_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_poy WITHOUT DEFAULTS FROM s_poy.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
             LET l_int_flag = 'N' #按了放棄鍵否='N' #MOD-570095 add
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           OPEN i000_cl USING g_poz.poz01
           IF STATUS THEN
              CALL cl_err("OPEN i000_cl:", STATUS, 1)
              CLOSE i000_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i000_cl INTO g_poz.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_poz.poz01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i000_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_poy_t.* = g_poy[l_ac].*  #BACKUP
              LET g_poy_o.* = g_poy[l_ac].*  #BACKUP
              OPEN i000_bcl USING g_poz.poz01,g_poy_t.poy02
              IF STATUS THEN
                 CALL cl_err("OPEN i000_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i000_bcl INTO g_poy[l_ac].*
                 IF SQLCA.sqlcode THEN
                     CALL cl_err(g_poy_t.poy02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                 END IF
                 CALL i000_used() RETURNING g_used
                 CALL i000_azp(g_poy[l_ac].poy04) RETURNING g_dbs,l_plant_g #No.FUN-980025
                 #CALL i000_pmc(g_poy[l_ac].poy03,'d',g_dbs)
                 CALL i000_pmc(g_poy[l_ac].poy03,'d',g_poy[l_ac].poy04)   #FUN-A50102
                   RETURNING g_poy[l_ac].pmc03
                 DISPLAY BY NAME g_poy[l_ac].pmc03
                 LET g_before_input_done = FALSE 
                 CALL i000_set_entry_b(p_cmd)
                 CALL i000_set_no_entry_b(p_cmd)
                 LET g_before_input_done = TRUE
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
           CALL i000_set_entry_b(p_cmd)      #MOD-BB0274 add
           CALL i000_set_no_entry_b(p_cmd)   #MOD-BB0274 add
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           CALL i000_used() RETURNING g_used
           IF g_used='Y' THEN     #如果已被使用，則不允許新增
              CALL cl_err('',"apm-802",1)
              CANCEL INSERT
           END IF
           LET g_before_input_done = FALSE
           CALL i000_set_entry_b(p_cmd)
           CALL i000_set_no_entry_b(p_cmd)
           LET g_before_input_done = TRUE
           INITIALIZE g_poy[l_ac].* TO NULL       #900423
           IF g_azw.azw04='2' THEN
              SELECT COUNT(*) INTO l_n FROM poy_file WHERE poy01=g_poz.poz01
              IF l_n=0 AND g_poz.poz20='Y' THEN
                 LET g_poy[l_ac].poy04='xxx'
                 LET g_poy[l_ac].poy03='xxx'
                 LET g_poy[l_ac].poy05='XXX'
                 LET g_poy[l_ac].poy20=''
                 CALL i000_set_no_entry_b(p_cmd)
              END IF
           END IF
           LET g_poy_t.* = g_poy[l_ac].*          #新輸入資料
           LET g_poy_o.* = g_poy[l_ac].*          #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD poy02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO poy_file(poy01,poy02,poy03,poy04,poy05,poy20,
                                poyud01,poyud02,poyud03,poyud04,poyud05,poyud06,
                                poyud07,poyud08,poyud09,poyud10,poyud11,poyud12,
                                poyud13,poyud14,poyud15)
                VALUES(g_poz.poz01,g_poy[l_ac].poy02,g_poy[l_ac].poy03,
                       g_poy[l_ac].poy04,g_poy[l_ac].poy05,g_poy[l_ac].poy20,
                       g_poy[l_ac].poyud01,g_poy[l_ac].poyud02,
                       g_poy[l_ac].poyud03,g_poy[l_ac].poyud04,
                       g_poy[l_ac].poyud05,g_poy[l_ac].poyud06,
                       g_poy[l_ac].poyud07,g_poy[l_ac].poyud08,
                       g_poy[l_ac].poyud09,g_poy[l_ac].poyud10,
                       g_poy[l_ac].poyud11,g_poy[l_ac].poyud12,
                       g_poy[l_ac].poyud13,g_poy[l_ac].poyud14,
                       g_poy[l_ac].poyud15)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","poy_file",g_poy[l_ac].poy02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              IF g_success='Y' THEN
                 COMMIT WORK
              ELSE
                 CALL cl_rbmsg(1)
                 ROLLBACK WORK
              END IF
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD poy02                        #default 序號
           IF g_poy[l_ac].poy02 IS NULL THEN
               SELECT max(poy02)+1
                 INTO g_poy[l_ac].poy02
                 FROM poy_file
                WHERE poy01 = g_poz.poz01
              IF g_poy[l_ac].poy02 IS NULL THEN
                  LET g_poy[l_ac].poy02 = 0
              END IF
           END IF
           CALL i000_set_entry_b(p_cmd)          #MOD-BB0274 add
 
        AFTER FIELD poy02                        #check 序號是否重複
           IF NOT cl_null(g_poy[l_ac].poy02) THEN
              IF g_poy[l_ac].poy02 != g_poy_t.poy02 OR g_poy_t.poy02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM poy_file
                  WHERE poy01 = g_poz.poz01
                    AND poy02 = g_poy[l_ac].poy02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_poy[l_ac].poy02 = g_poy_t.poy02
                    NEXT FIELD poy02
                 END IF
              END IF
             IF g_poy[l_ac].poy02 = 99 THEN
                IF g_poz.poz00 <> "2" THEN   #若非待採流程
                   CALL cl_err('','apm-899',1)
                   LET g_poy[l_ac].poy02 = g_poy_t.poy02
                   NEXT FIELD poy02
                END IF
             END IF 
           END IF
           CALL i000_set_no_entry_b(p_cmd)     #MOD-BB0274 add
 
        BEFORE FIELD poy04
          IF g_poz.poz12 = 'Y' AND g_poy[l_ac].poy02 = '0' THEN #內部交易時，第0站=poz13,第1站=poz14
             LET g_poy[l_ac].poy04 = g_poz.poz13
          END IF
          IF g_poz.poz12 = 'Y' AND g_poy[l_ac].poy02 = '1' THEN #內部交易時，第0站=poz13,第1站=poz14
             LET g_poy[l_ac].poy04 = g_poz.poz14
          END IF
        AFTER FIELD poy04     #工廠編號
           IF NOT cl_null(g_poy[l_ac].poy04) THEN
              IF g_azw.azw04='2' AND g_poz.poz20='Y' AND 
                 (g_poy[l_ac].poy04='xxx' OR g_poy[l_ac].poy04='yyy') THEN
#TQC-AC0385--add--add--
                 #CONTINUE INPUT
                 IF g_poy[l_ac].poy04='xxx' THEN
                    LET g_poy[l_ac].poy03='xxx'
                    LET g_poy[l_ac].poy05='XXX'
                 END IF
                 IF g_poy[l_ac].poy04='yyy' THEN
                    LET g_poy[l_ac].poy03='yyy'
                    LET g_poy[l_ac].poy05='YYY'
                 END IF
                 CALL i000_set_no_entry_b(p_cmd)
                 NEXT FIELD poy05  
#TQC-AC0385--add--end--
              END IF
              CALL i000_set_entry_b(p_cmd)
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_poy[l_ac].poy04 <> g_poy_t.poy04) THEN  
               SELECT COUNT(azw02)  INTO l_n1  FROM azw_file
                WHERE azw01 = g_poy[l_ac].poy04 
                  AND azw02 IN ( SELECT azw02 FROM azw_file,poy_file WHERE
                      azw01 = poy04 AND poy01 = g_poz.poz01)
               IF l_n1 >=1 THEN 
                 CALL cl_err('','azw-001',0)
                  LET g_poy[l_ac].poy04 = g_poy_t.poy04
                  DISPLAY BY NAME g_poy[l_ac].poy04
                  NEXT FIELD poy04
                END IF
              END IF    
              CALL i000_azp(g_poy[l_ac].poy04) RETURNING g_dbs,l_plant_g #No.FUN-980025
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_poy[l_ac].poy04,g_errno,0)
                  LET g_poy[l_ac].poy04 = g_poy_t.poy04
                  DISPLAY BY NAME g_poy[l_ac].poy04
                  NEXT FIELD poy04
              END IF
              SELECT COUNT(*) INTO g_cnt FROM poy_file
               WHERE poy01 = g_poz.poz01 
                 AND poy02 != g_poy[l_ac].poy02
                 AND poy02 != g_poy_t.poy02   #MOD-A50147
                 AND poy04 = g_poy[l_ac].poy04
              IF g_cnt > 0 THEN
                  CALL cl_err(g_poy[l_ac].poy04,'apm-994',1)
                  NEXT FIELD poy04
              END IF
             IF g_poz.poz12 = 'Y' AND g_poy[l_ac].poy02 = '0' 
                AND g_poy[l_ac].poy04 <> g_poz.poz13 THEN #兩角貿易的第0站要=poz13
                CALL cl_err(g_poy[l_ac].poy04,'apm-971',0)
                NEXT FIELD poy04
             END IF
             IF g_poz.poz12 = 'Y' AND g_poy[l_ac].poy02 = '1' 
                AND g_poy[l_ac].poy04 <> g_poz.poz14 THEN #兩角貿易的第1站要=poz14
                CALL cl_err(g_poy[l_ac].poy04,'apm-972',0)
                NEXT FIELD poy04
             END IF
           END IF
           IF l_ac > 1 AND g_poy[l_ac].poy02 <> 99 THEN  #MOD-810056 modify
              LET l_ac1 = l_ac-1
              IF g_poy[l_ac1].poy03<>'xxx' AND g_poz.poz20='Y' THEN    #No.FUN-870007
              #CALL i000_occ_chk(g_poy[l_ac1].poy03,g_dbs)
              CALL i000_occ_chk(g_poy[l_ac1].poy03,g_poy[l_ac].poy04)    #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_poy[l_ac].poy04,g_errno,0)
                 NEXT FIELD poy04
              END IF
              END IF  #No.FUN-870007
           END IF
 
        AFTER FIELD poy03     #廠商
           IF NOT cl_null(g_poy[l_ac].poy03)  THEN
              IF g_azw.azw04='2' AND g_poz.poz20='Y' AND 
                (g_poy[l_ac].poy03='xxx' OR g_poy[l_ac].poy03='yyy') THEN
                 CONTINUE INPUT
              END IF
             #CALL i000_azp(g_poy[l_ac].poy04) RETURNING g_dbs,l_plant_g #No.FUN-980025 #MOD-D40124 mark
             #CALL i000_pmc(g_poy[l_ac].poy03,'d',g_dbs)
             #MOD-D40124 add start -----
              IF g_poy1[l_ac].poy02 > 0 AND g_poy1[1].poy02 = 0 THEN
                 CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING g_dbs,l_plant_s #前一個營運中心
                 CALL i000_pmc(g_poy[l_ac].poy03,'d',l_plant_s) RETURNING g_poy[l_ac].pmc03 
              ELSE
             #MOD-D40124 add end   -----
                 CALL i000_pmc(g_poy[l_ac].poy03,'d',g_poy[l_ac].poy04)   #FUN-A50102
                     RETURNING g_poy[l_ac].pmc03
              END IF #MOD-D40124 add
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_poy[l_ac].poy03,g_errno,0)
                 LET g_poy[l_ac].poy03 = g_poy_t.poy03
                 DISPLAY BY NAME g_poy[l_ac].poy03
                 NEXT FIELD poy03
              END IF
 
              #取得上游站工廠別
              IF g_poy[l_ac].poy02 > 0 THEN
                  LET l_poy02 = g_poy[l_ac].poy02 - 1
                     SELECT poy04,poy03 INTO l_poy04,l_poy03 FROM poy_file
                      WHERE poy01 = g_poz.poz01 AND poy02 = l_poy02
                     IF l_poy04='xxx' AND g_azw.azw04='2' AND g_poz.poz20='Y' THEN
                        CONTINUE INPUT
                     END IF
                     SELECT azp03 INTO t_azp03 FROM azp_file WHERE azp01=l_poy04
                      LET t_dbs = s_dbstring(t_azp03 CLIPPED)
                      #判斷本廠商是否存在上游商基本資料中
                      #CALL i000_pmc(g_poy[l_ac].poy03,'e',t_dbs) RETURNING l_pmc03
                      CALL i000_pmc(g_poy[l_ac].poy03,'e',l_poy04) RETURNING l_pmc03   #FUN-A50102
                      IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_poy[l_ac].poy03,g_errno,0)
                          LET g_poy[l_ac].poy03 = g_poy_t.poy03
                          NEXT FIELD poy03
                      END IF
                   END IF
               END IF
 
        AFTER FIELD poy05     #幣別
           #指定幣別時不可空白
           IF cl_null(g_poy[l_ac].poy05) AND g_poz.poz09='Y' AND g_poy[l_ac].poy02 <> 99 THEN  #MOD-810056 modify
              CALL cl_err(g_poy[l_ac].poy05,'aom-157',0)
              NEXT FIELD poy05
           END IF
           IF NOT cl_null(g_poy[l_ac].poy05) THEN
              IF g_azw.azw04='2' AND g_poz.poz20='Y' AND 
                (g_poy[l_ac].poy05='XXX' OR g_poy[l_ac].poy05='YYY') THEN
                 CONTINUE INPUT
              END IF
              IF g_poy[l_ac].poy02 = 99  THEN
                 LET l_poy04 = ' '
                 LET t_azp03 = ' '
                 LET t_dbs   = ' '
                 LET t_plant = ' '  #FUN-A50102
                 DECLARE i000_poy04 SCROLL CURSOR FOR
                  SELECT poy04
                    FROM poy_file
                   WHERE poy01 = g_poz.poz01
                     AND poy02 < 99
                 ORDER BY poy02 DESC
                 OPEN i000_poy04
                 FETCH FIRST i000_poy04 INTO l_poy04
                 IF SQLCA.sqlcode = 0 THEN
                    LET t_plant = l_poy04  #FUN-A50102
                    SELECT azp03 INTO t_azp03 FROM azp_file
                     WHERE azp01=l_poy04
                 END IF
                 IF NOT cl_null(t_azp03) THEN
                    LET t_dbs = s_dbstring(t_azp03)
                 END IF
              ELSE
                 LET t_dbs = g_dbs
                 LET t_plant = g_plant  #FUN-A50102
              END IF
              #CALL i000_azi(g_poy[l_ac].poy05,t_dbs)
              CALL i000_azi(g_poy[l_ac].poy05,t_plant)    #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_dbs,g_errno,1)           #FUN-670007 
                 LET g_poy[l_ac].poy05 = g_poy_t.poy05
                 NEXT FIELD poy05
              END IF
           END IF
           IF cl_null(g_poy[l_ac].poy05) THEN
              LET g_poy[l_ac].poy05 = ' '
           END IF
 
      AFTER FIELD poy20
         IF NOT cl_null(g_poy[l_ac].poy20) THEN
            IF g_poy[l_ac].poy20 NOT MATCHES '[123]' THEN
               CALL cl_err(g_poy[l_ac].poy20,'aom-157',0)
               NEXT FIELD poy20
            END IF
         END IF
 
        AFTER FIELD poyud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD poyud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           #如果已經使用，不准刪除
           CALL i000_used() RETURNING g_used
           IF g_used='Y' THEN
              CALL cl_err('',"apm-802",1)
              CANCEL DELETE
           END IF
           IF g_poy_t.poy02 IS NOT NULL THEN   #NO.FUN-670007
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM poy_file
               WHERE poy01 = g_poz.poz01
                 AND poy02 = g_poy_t.poy02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","poy_file",g_poy_t.poy02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           SELECT COUNT(*) INTO l_pox
             FROM pox_file
            WHERE pox01 = g_poz.poz01
           IF l_pox > 0 THEN
               IF cl_confirm('apm-037') THEN        #是否刪除pox_file
                   DELETE FROM pox_file
                    WHERE pox01 = g_poz.poz01
                      AND pox04 = g_poy_t.poy02            #TQC-970282
                   IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","pox_file",g_poz.poz01,g_poy[l_ac].poy02,
                                     SQLCA.sqlcode,"","delete pox_file",1)  #No.FUN-660129
                       ROLLBACK WORK
                       CANCEL DELETE
                   END IF
               END IF
           END IF                          #NO.TQC-740089
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
               LET l_int_flag = 'Y' #按了放棄鍵 #MOD-570095 add
              LET g_poy[l_ac].* = g_poy_t.*
              CLOSE i000_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_poy[l_ac].poy02,-263,1)
              LET g_poy[l_ac].* = g_poy_t.*
           ELSE
              UPDATE poy_file SET poy02 = g_poy[l_ac].poy02,
                                  poy03 = g_poy[l_ac].poy03,
                                  poy04 = g_poy[l_ac].poy04,
                                  poy05 = g_poy[l_ac].poy05,
                                  poy20 = g_poy[l_ac].poy20, #NO.FUN-670007 add
                                  poyud01 = g_poy[l_ac].poyud01,
                                  poyud02 = g_poy[l_ac].poyud02,
                                  poyud03 = g_poy[l_ac].poyud03,
                                  poyud04 = g_poy[l_ac].poyud04,
                                  poyud05 = g_poy[l_ac].poyud05,
                                  poyud06 = g_poy[l_ac].poyud06,
                                  poyud07 = g_poy[l_ac].poyud07,
                                  poyud08 = g_poy[l_ac].poyud08,
                                  poyud09 = g_poy[l_ac].poyud09,
                                  poyud10 = g_poy[l_ac].poyud10,
                                  poyud11 = g_poy[l_ac].poyud11,
                                  poyud12 = g_poy[l_ac].poyud12,
                                  poyud13 = g_poy[l_ac].poyud13,
                                  poyud14 = g_poy[l_ac].poyud14,
                                  poyud15 = g_poy[l_ac].poyud15
               WHERE poy01=g_poz.poz01
                 AND poy02=g_poy_t.poy02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","poy_file",g_poy[l_ac].poy02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_poy[l_ac].* = g_poy_t.*
              ELSE
                 IF g_success='Y' THEN
                    COMMIT WORK
                 ELSE
                    CALL cl_rbmsg(1)
                    ROLLBACK WORK
                 END IF
                 MESSAGE 'UPDATE O.K'
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac                #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
               LET l_int_flag = 'Y' #按了放棄鍵 #MOD-570095 add
              IF p_cmd = 'u' THEN
                 LET g_poy[l_ac].* = g_poy_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_poy.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              CLOSE i000_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac                #FUN-D30034 add
           CLOSE i000_bcl
           COMMIT WORK
           
        AFTER INPUT                                                  #FUN-870130
           IF g_poz.poz19="Y" THEN                                   #FUN-870130
              LET g_poz.poz18 = ''   #MOD-A50147
              SELECT poy04 INTO g_poz.poz18                          #FUN-870130
                FROM poy_file,poz_file                               #FUN-870130
               WHERE poy01 = poz01                                   #FUN-870130
                 AND poy01 = g_poz.poz01                             #FUN-870130 
                 AND poy02 = 0                                       #FUN-870130
              DISPLAY BY NAME g_poz.poz18                            #FUN-870130 
              IF cl_null(g_poz.poz18) THEN                           #FUN-870130
                 CALL cl_err('','apm-118',1)                         #FUN-870130
                 NEXT FIELD poy02                                    #FUN-870130
              END IF                                                 #FUN-870130
              UPDATE poz_file SET poz18 = g_poz.poz18
               WHERE poz01 = g_poz.poz01
           END IF                                                    #FUN-870130                   
           IF g_azw.azw04='2' THEN
              SELECT COUNT(*) INTO l_n FROM poy_file WHERE poy01=g_poz.poz01
              IF l_n<2 THEN
                 CALL cl_err('','apm1001',0)
                 LET g_rec_b = 0
                 CONTINUE INPUT
              END IF
              IF g_poz.poz20='Y' THEN
                 CALL cl_err('','apm1000',1)
                 SELECT MIN(poy02),MAX(poy02) INTO l_poy02_min,l_poy02_max
                   FROM poy_file WHERE poy01=g_poz.poz01
                 SELECT COUNT(*) INTO l_n FROM poy_file
                  WHERE poy01=g_poz.poz01
                    AND poy02=l_poy02_min
                    AND poy04='xxx'
                 IF l_n=0 THEN
                    UPDATE poy_file SET poy04='xxx',poy03='xxx',poy05='xxx',poy20=''
                     WHERE poy01=g_poz.poz01 AND poy02=l_poy02_min
                 END IF
                 SELECT COUNT(*) INTO l_n FROM poy_file
                  WHERE poy01=g_poz.poz01
                    AND poy02=l_poy02_max
                    AND poy04='yyy'
                 IF l_n=0 THEN
                    UPDATE poy_file SET poy04='yyy',poy03='yyy',poy05='yyy',poy20=''
                     WHERE poy01=g_poz.poz01 AND poy02=l_poy02_max
                 END IF
                 COMMIT WORK
                 MESSAGE 'UPDATE O.K'
                 CALL i000_b_fill(' 1=1')
              END IF
           END IF
 
        ON ACTION CONTROLO
           IF INFIELD(poy02) AND l_ac > 1 THEN
              LET g_poy[l_ac].* = g_poy[l_ac-1].*
              LET g_poy[l_ac].poy02 = g_rec_b + 1
              NEXT FIELD poy02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(poy04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azp"
                 LET g_qryparam.default1 = g_poy[l_ac].poy04
                 CALL cl_create_qry() RETURNING g_poy[l_ac].poy04
                 DISPLAY g_poy[l_ac].poy04 TO poy04
                 NEXT FIELD poy04
              WHEN INFIELD(poy03)
                #MOD-D40124 add start -----
                 IF g_poy1[l_ac].poy02 > 0 AND g_poy1[1].poy02 = 0 THEN
                    CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING g_dbs,l_plant_s #前一個營運中心
                    CALL i000_pmc(g_poy[l_ac].poy03,'d',l_plant_s) RETURNING g_poy[l_ac].pmc03 
                 ELSE
                #MOD-D40124 add end   -----
                    CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant   #No.FUN-980025
                 END IF #MOD-D40124 add
                 CALL q_m_pmc3(FALSE,TRUE,g_poy[l_ac].poy03,l_plant)#No.FUN-980025
                 RETURNING g_poy[l_ac].poy03
                 DISPLAY g_poy[l_ac].poy03 TO poy03
                 NEXT FIELD poy03
              WHEN INFIELD(poy05)
                 CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant #No.FUN-980025
                 CALL q_m_azi(FALSE,TRUE,g_poy[l_ac].poy05,l_plant)   #FUN-670007   #NO.TQC-740188  #FUN-990069
                 RETURNING g_poy[l_ac].poy05
                 DISPLAY g_poy[l_ac].poy05 TO poy05
                 NEXT FIELD poy05
               OTHERWISE EXIT CASE
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
 
    LET g_poz.pozmodu = g_user
    LET g_poz.pozdate = g_today
    UPDATE poz_file SET pozmodu = g_poz.pozmodu,pozdate = g_poz.pozdate
     WHERE poz01 = g_poz.poz01
    DISPLAY BY NAME g_poz.pozmodu,g_poz.pozdate
 
    IF i000_checkb() AND g_poy[l_ac].poy02<>99 THEN   #MOD-810056 modify
       CALL cl_err('','tri-005',1)
    END IF
 
    CLOSE i000_bcl
    COMMIT WORK
 
#   CALL i000_delall() #CHI-C30002 mark
    CALL i000_delHeader()     #CHI-C30002 add
    
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i000_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM poz_file WHERE poz01 = g_poz.poz01
         INITIALIZE g_poz.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i000_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM poy_file
#   WHERE poy01 = g_poz.poz01
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM poz_file WHERE poz01 = g_poz.poz01
#     CLEAR FORM
#     INITIALIZE g_poz.* TO NULL
#     CALL g_poy.clear()
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i000_checkb()
DEFINE l_flag,i  LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE l_poy02   LIKE poy_file.poy02
 
   LET l_flag = 0
    LET i = 0
 
   DECLARE checkb_cs CURSOR FOR
    SELECT poy02 FROM poy_file
     WHERE poy01 = g_poz.poz01
     ORDER BY poy02
 
   FOREACH checkb_cs INTO l_poy02
      IF l_poy02 = 99 THEN
         CONTINUE FOREACH
      END IF
      IF i != l_poy02 THEN
         LET l_flag = 1
         EXIT FOREACH
      END IF
      LET i = i + 1
   END FOREACH
   RETURN l_flag
 
END FUNCTION
 
FUNCTION i000_b1()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)
    l_plant         LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(10)
    l_plant_s       LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(10)
    l_dbs2          LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)     #MOD-4A0061
    l_azp01         LIKE azp_file.azp01,                #MOD-4A0061
    t_azp03         LIKE azp_file.azp03,
    l_rec_b         LIKE type_file.num5,                #No.MOD-490331  #No.FUN-680136 SMALLINT
    l_poy02         LIKE poy_file.poy02,
    l_poy03         LIKE poy_file.poy03,
    l_poy04         LIKE poy_file.poy04,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-680136 SMALLINT
    t_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)   #上游資料庫
    l_pmc03         LIKE pmc_file.pmc03,                 #NO.FUN-670007
    l_int_flag      LIKE type_file.chr1                 #按了放棄鍵否(是:Y,否:N) #MOD-570095 add  #No.FUN-680136 VARCHAR(1)
DEFINE     l_dbs_s         LIKE type_file.chr21                #no.TQC-7C0148
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_poz.poz01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_poz.* FROM poz_file WHERE poz01=g_poz.poz01
 
    IF g_poz.pozacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_poz.poz01,'mfg1000',0)
       RETURN
    END IF
 
    LET p_row = 14 LET p_col = 21
    OPEN WINDOW i000_b1_w AT p_row,p_col WITH FORM "apm/42f/apmi000_b1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("apmi000_b1")
    LET g_success='Y'
 
    IF g_aaz.aaz90 MATCHES '[Yy]' THEN 
       CALL cl_set_comp_visible("poy45,poy46",TRUE)
    ELSE
       CALL cl_set_comp_visible("poy45,poy46",FALSE)
    END IF
 
    LET l_ac = 1
    DECLARE i000_b1_cs CURSOR WITH HOLD FOR
        SELECT poy02,poy03,poy12,poy18,poy19,poy12,poy07,poy06,poy08,poy09,  #NO.TQC-7C0148
               poy16,poy17,poy46,poy45
          FROM poy_file
         WHERE poy01=g_poz.poz01
 
    FOREACH i000_b1_cs INTO g_poy1[l_ac].*
       LET g_poy1[l_ac].pmc03 = g_poy[l_ac].pmc03
       LET l_ac = l_ac + 1
    END FOREACH
    CALL g_poy1.deleteElement(l_ac)  #No.MOD-490331
    LET l_rec_b = l_ac - 1          #No.MOD-490331
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_ac=1
 
    INPUT ARRAY g_poy1 WITHOUT DEFAULTS FROM s_poy1.*
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=FALSE,APPEND ROW=FALSE)  #no.MOD-780191
 
        BEFORE INPUT
            IF l_rec_b != 0 THEN           #No.MOD-490331
              CALL fgl_set_arr_curr(l_ac)
            END IF                         #No.MOD-490331
            LET l_int_flag = 'N' #按了放棄鍵否='N' #MOD-570095 add
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           LET g_poy1_t.* = g_poy1[l_ac].*  #BACKUP
           LET l_n  = ARR_COUNT()
           LET g_success='Y'
           BEGIN WORK
           LET l_dbs_s = NULL   #MOD-A50033
           LET l_plant_s = NULL #MOD-A50033
           IF g_poy1[l_ac].poy02 > 0 AND g_poy1[1].poy02 = 0 THEN
               CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs_s,l_plant_s #No.FUN-980025   #前一個營運中心
           END IF
 
           IF g_poy1[l_ac].poy02 = 99 THEN
              CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs,l_plant #No.FUN-980025       #前站營運中心              
           ELSE
              CALL i000_azp(g_poy[l_ac].poy04)   RETURNING l_dbs,l_plant #No.FUN-980025       #本站營運中心
           END IF 
 
           #CALL i000_pmc(g_poy1[l_ac].poy03,'e',l_dbs) RETURNING l_pmc03    #FUN-A50102
           CALL i000_pmc(g_poy1[l_ac].poy03,'e',l_plant) RETURNING l_pmc03     #FUN-A50102
           DISPLAY l_pmc03 TO FORMONLY.pmc03_1
 
        AFTER FIELD poy06   #付款方式
           IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白    #TQC-7C0164
              IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy06) AND g_poy1[l_ac].poy02 <> 0) OR   #no.TQC-7C0148 第0站不需輸入此欄位
                 (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy06)) THEN    #MOD-830138-modify
                  CALL cl_err('','agl-154',0)
                  LET g_poy1[l_ac].poy06 = g_poy1_t.poy06   #no.TQC-7C0148
                  DISPLAY BY NAME g_poy1[l_ac].poy06       #no.TQC-7C0148
                  NEXT FIELD poy06
              END IF
           END IF    #FUN-7C0004
 
           IF NOT cl_null(g_poy1[l_ac].poy06) THEN
              #CALL i000_pma(g_poy1[l_ac].poy06,l_dbs_s)   #no.TQC-7C0148 檢查是否存在上一站資料庫中  
              CALL i000_pma(g_poy1[l_ac].poy06,l_plant_s)    #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy06 = g_poy1_t.poy06
                 DISPLAY BY NAME g_poy1[l_ac].poy06
                 CALL cl_err(l_dbs_s,g_errno,0)  #MOD-950103 add
                 NEXT FIELD poy06
              END IF
           END IF
 
        AFTER FIELD poy07   #收款條件
           #IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy07)) OR    #MOD-A80171
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy07) AND g_poy1[l_ac].poy02 <> 0) OR  #MOD-A80171
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy07)) THEN   #MOD-830138-modify
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy07 = g_poy1_t.poy07    #no.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy07         #no.TQC-7C0148
               NEXT FIELD poy07
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy07) THEN
             #CALL i000_oag(g_poy1[l_ac].poy07,l_dbs)
             CALL i000_oag(g_poy1[l_ac].poy07,l_plant)   #FUN-A50102
             IF NOT cl_null(g_errno) THEN
                LET g_poy1[l_ac].poy07 = g_poy1_t.poy07
                DISPLAY BY NAME g_poy1[l_ac].poy07
                CALL cl_err(l_dbs,g_errno,0)
                NEXT FIELD poy07
             END IF
           END IF
 
        AFTER FIELD poy08   #稅別
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy08) AND g_poy1[l_ac].poy02 <> 0 ) OR   #NO.TQC-7C0148
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy08)) THEN   #MOD-830138-modify
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy08 = g_poy1_t.poy08   #no.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy08        #no.TQC-7C0148
               NEXT FIELD poy08
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy08) THEN
              #CALL i000_gec(g_poy1[l_ac].poy08,'2',l_dbs)
              CALL i000_gec(g_poy1[l_ac].poy08,'2',l_plant)  #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy08 = g_poy1_t.poy08
                 DISPLAY BY NAME g_poy1[l_ac].poy08
                 CALL cl_err(l_dbs,g_errno,0)
                 NEXT FIELD poy08
              END IF
           END IF
 
        AFTER FIELD poy09   #稅別
         IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白   #TQC-7C0164
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy09) AND g_poy1[l_ac].poy02 <> 0) OR    #no.TQC-7C0148 
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy09)) THEN   #MOD-830138-modify
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy09 = g_poy1_t.poy09   #NO.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy09        #NO.TQC-7C0148
               NEXT FIELD poy09
           END IF
         END IF   #FUN-7C0004 add
           IF NOT cl_null(g_poy1[l_ac].poy09) THEN
              #CALL i000_gec(g_poy1[l_ac].poy09,'1',l_dbs_s)   #no.TQC-7C0148 
              CALL i000_gec(g_poy1[l_ac].poy09,'1',l_plant_s)  #FUN-A50102 
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy09 = g_poy1_t.poy09
                 DISPLAY BY NAME g_poy1[l_ac].poy09
                 CALL cl_err(l_dbs_s,g_errno,0)  #MOD-950103 add
                 NEXT FIELD poy09
              END IF
           END IF
 
           BEFORE FIELD poy12
               IF cl_null(g_poy1[l_ac].poy12) THEN
                   LET g_poy1[l_ac].poy12 = '1'
               END IF
 
        AFTER FIELD poy12  #票別
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy12)) OR 
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy12)) THEN   #MOD-830138-modify
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy12 = g_poy1_t.poy12    #NO.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy12         #NO.TQC-7C0148
               NEXT FIELD poy12
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy12) THEN
              #CALL i000_oom(g_poy1[l_ac].poy12,l_dbs)   #NO.MOD-780191 
              CALL i000_oom(g_poy1[l_ac].poy12,l_plant)    #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy12 = g_poy1_t.poy12
                 DISPLAY BY NAME g_poy1[l_ac].poy12
                 CALL cl_err(l_dbs,g_errno,0)
                 NEXT FIELD poy12
              END IF
           END IF
 
        AFTER FIELD poy16   #AR類別
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy16)) OR 
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy16)) THEN   #MOD-830138-modify
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy16 = g_poy1_t.poy16     #NO.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy16          #NO.TQC-7C0148
               NEXT FIELD poy16
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy16) THEN
              #CALL i000_ool(g_poy1[l_ac].poy16,l_dbs)
              CALL i000_ool(g_poy1[l_ac].poy16,l_plant)    #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy16 = g_poy1_t.poy16
                 DISPLAY BY NAME g_poy1[l_ac].poy16
                 CALL cl_err(l_dbs,g_errno,0)
                 NEXT FIELD poy16
              END IF
           END IF
 
        AFTER FIELD poy17   #AP類別
         IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白   #TQC-7C0164
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy17) AND g_poy1[l_ac].poy02 <> 0) OR   #NO.TQC-7C0148
              (g_poz.poz00 = '2' AND g_poy1[l_ac].poy02 > 0 AND cl_null(g_poy1[l_ac].poy17)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy17 = g_poy1_t.poy17    #NO.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy17         #NO.TQC-7C0148
               NEXT FIELD poy17
           END IF
         END IF  #FUN-7C0004
           IF NOT cl_null(g_poy1[l_ac].poy17) THEN
              #CALL i000_apr(g_poy1[l_ac].poy17,l_dbs_s)   #NO.TQC-7C0148  
              CALL i000_apr(g_poy1[l_ac].poy17,l_plant_s)    #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy17 = g_poy1_t.poy17
                 DISPLAY BY NAME g_poy1[l_ac].poy17
                 CALL cl_err(l_dbs_s,g_errno,0)  #MOD-950103 add
                 NEXT FIELD poy17
              END IF
           END IF
 
        AFTER FIELD poy18   #AR部門
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy18)) OR 
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy18)) THEN   #MOD-830138-modify
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy18 = g_poy1_t.poy18  #no.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy18       #no.TQC-7C0148
               NEXT FIELD poy18
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy18) THEN
              #CALL i000_gem(g_poy1[l_ac].poy18,l_dbs)
              CALL i000_gem(g_poy1[l_ac].poy18,l_plant)  #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_dbs,g_errno,0)
                 LET g_poy1[l_ac].poy18 = g_poy1_t.poy18
                 DISPLAY BY NAME g_poy1[l_ac].poy18
                 NEXT FIELD poy18
              END IF
           END IF
 
        AFTER FIELD poy19   #AP部門
         IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白  #TQC-7C0164
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy19) AND g_poy1[l_ac].poy02 <> 0 ) OR   #no.TQC-7C0148第0站不需稽核AP
              (g_poz.poz00 = '2' AND g_poy1[l_ac].poy02 > 0 AND cl_null(g_poy1[l_ac].poy19)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy19 = g_poy1_t.poy19    #NO.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy19         #NO.TQC-7C0148
               NEXT FIELD poy19
           END IF
         END IF   #FUN-7C0004
 
           IF NOT cl_null(g_poy1[l_ac].poy19) THEN
              #CALL i000_gem(g_poy1[l_ac].poy19,l_dbs_s)    #no.TQC-7C0148 ap資料應check上一站資料庫 
             CALL i000_gem(g_poy1[l_ac].poy19,l_plant_s)   #FUN-A50102 
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy19 = g_poy1_t.poy19
                 DISPLAY BY NAME g_poy1[l_ac].poy19
                 CALL cl_err(l_dbs_s,g_errno,0)  #MOD-950103 add
                 NEXT FIELD poy19
              END IF
           END IF
 
        AFTER FIELD poy46  #採購成本中心
         IF NOT cl_null(g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白   #TQC-7C0164
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy46) AND g_poy1[l_ac].poy02 <> 0) OR   #no.TQC-7C0148
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy46)) THEN   #MOD-830138-modify
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy46 = g_poy1_t.poy46        #NO.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy46             #NO.TQC-7C0148
               NEXT FIELD poy46
           END IF
         END IF  #FUN-7C0004
           IF NOT cl_null(g_poy1[l_ac].poy46) THEN
           #  CALL i000_poy_gem(g_poy1[l_ac].poy46,l_plant_s)      #MOD-9C0168  #No.FUN-A10099
              #CALL i000_poy_gem(g_poy1[l_ac].poy46,l_dbs_s)        #MOD-9C0168  #No.FUN-A10099
              CALL i000_poy_gem(g_poy1[l_ac].poy46,l_plant_s)        #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy46 = g_poy1_t.poy46
                 CALL cl_err(l_dbs,g_errno,0)
                 DISPLAY BY NAME g_poy1[l_ac].poy46
                 NEXT FIELD poy46
              END IF
           END IF
 
        AFTER FIELD poy45  #訂單成本中心
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy45) AND g_poy1[l_ac].poy02 <> 0) OR   #NO.TQC-7C0148
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy45)) THEN   #MOD-830138-modify
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy45 = g_poy1_t.poy45    #no.TQC-7C0148
               DISPLAY BY NAME g_poy1[l_ac].poy45         #no.TQC-7C0148
               NEXT FIELD poy45
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy45) THEN
              #CALL i000_poy_gem(g_poy1[l_ac].poy45,l_dbs)  #MOD-950103 取消mark
             CALL i000_poy_gem(g_poy1[l_ac].poy45,l_plant)    #FUN-A50102 
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy45 = g_poy1_t.poy45
                 CALL cl_err(l_dbs,g_errno,0)
                 DISPLAY BY NAME g_poy1[l_ac].poy45
                 NEXT FIELD poy45
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_int_flag = 'Y' #按了放棄鍵 #MOD-570095 add
              LET g_poy1[l_ac].* = g_poy1_t.*
              CLOSE i000_b1_cs
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i000_b1_cs
           COMMIT WORK
           IF NOT cl_null(g_poy1[l_ac].poy02) THEN
              UPDATE poy_file SET poy06= g_poy1[l_ac].poy06,
                                  poy07= g_poy1[l_ac].poy07,
                                  poy08= g_poy1[l_ac].poy08,
                                  poy09= g_poy1[l_ac].poy09,
                                  poy12= g_poy1[l_ac].poy12,
                                  poy16= g_poy1[l_ac].poy16,
                                  poy17= g_poy1[l_ac].poy17,
                                  poy18= g_poy1[l_ac].poy18,
                                  poy19= g_poy1[l_ac].poy19,
                                  poy45= g_poy1[l_ac].poy45,
                                  poy46= g_poy1[l_ac].poy46
               WHERE poy01 = g_poz.poz01
                 AND poy02 = g_poy1[l_ac].poy02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","poy_file",g_poy1[l_ac].poy02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_poy1[l_ac].* = g_poy1_t.*
                 LET g_success = 'N'
              ELSE
                  MESSAGE 'UPDATE O.K'
              END IF
           END IF
           IF g_success='Y' THEN
              COMMIT WORK
           ELSE
              CALL cl_rbmsg(1)
              ROLLBACK WORK
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(poy06)
                 CALL q_m_pma(FALSE,TRUE,g_poy1[l_ac].poy06,l_plant_s)                #No.FUN-980017     #MOD-9C0168
                 RETURNING g_poy1[l_ac].poy06
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy06) THEN 
                    LET g_poy1[l_ac].poy06 = g_poy1_t.poy06
                 END IF    
                 #TQC-D40028 add end
                 DISPLAY g_poy1[l_ac].poy06 TO poy06
                 NEXT FIELD poy06
              WHEN INFIELD(poy07)
                 CALL q_m_oag(FALSE,TRUE,g_poy1[l_ac].poy07,g_poy[l_ac].poy04)        #No.FUN-980017 
                 RETURNING g_poy1[l_ac].poy07
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy07) THEN 
                    LET g_poy1[l_ac].poy07 = g_poy1_t.poy07
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy07 TO poy07
                 NEXT FIELD poy07
              WHEN INFIELD(poy08)
                 CALL q_m_gec(FALSE,TRUE,g_poy1[l_ac].poy08,'2',l_plant)  #NO.TQC-740188 #FUN-990069
                 RETURNING g_poy1[l_ac].poy08
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy08) THEN 
                    LET g_poy1[l_ac].poy08 = g_poy1_t.poy08
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy08 TO poy08
                 NEXT FIELD poy08
              WHEN INFIELD(poy09)
                 CALL q_m_gec(FALSE,TRUE,g_poy1[l_ac].poy09,'1',l_plant_s) #no.TQC-7C0148   #FUN-990069
                 RETURNING g_poy1[l_ac].poy09
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy09) THEN 
                    LET g_poy1[l_ac].poy09 = g_poy1_t.poy09
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy09 TO poy09
                 NEXT FIELD poy09
             WHEN INFIELD(poy12)
                  CALL q_m_oom(FALSE,TRUE,g_poy1[l_ac].poy12,g_poy[l_ac].poy04)   #No.FUN-980017
                  RETURNING g_poy1[l_ac].poy12
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy12) THEN 
                    LET g_poy1[l_ac].poy12 = g_poy1_t.poy12
                 END IF    
                 #TQC-D40028 add end                  
                  DISPLAY BY NAME g_poy1[l_ac].poy12
                  NEXT FIELD poy12
              WHEN INFIELD(poy16)
                 CALL q_m_ool(FALSE,TRUE,g_poy1[l_ac].poy16,g_poy[l_ac].poy04) #No.FUN-980017
                 RETURNING g_poy1[l_ac].poy16
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy16) THEN 
                    LET g_poy1[l_ac].poy16 = g_poy1_t.poy16
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy16 TO poy16
                 NEXT FIELD poy16
              WHEN INFIELD(poy17)
                 CALL q_m_apr(FALSE,TRUE,g_poy1[l_ac].poy17,l_plant_s) #no.TQC-7C0148   #FUN-990069
                 RETURNING g_poy1[l_ac].poy17
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy17) THEN 
                    LET g_poy1[l_ac].poy17 = g_poy1_t.poy17
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy17 TO poy17
                 NEXT FIELD poy17
              WHEN INFIELD(poy18)
                 CALL q_m_gem(FALSE,TRUE,g_poy1[l_ac].poy18,l_plant)  #NO.TQC-740188 #FUN-990069
                 RETURNING g_poy1[l_ac].poy18
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy18) THEN 
                    LET g_poy1[l_ac].poy18 = g_poy1_t.poy18
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy18 TO poy18
                 NEXT FIELD poy18
              WHEN INFIELD(poy19)
                 CALL q_m_gem(FALSE,TRUE,g_poy1[l_ac].poy19,l_plant_s) #no.TQC-7C0148  #FUN-990069
                 RETURNING g_poy1[l_ac].poy19
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy19) THEN 
                    LET g_poy1[l_ac].poy19 = g_poy1_t.poy19
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy19 TO poy19
                 NEXT FIELD poy19
              WHEN INFIELD(poy45)
                 CALL q_m_gem(FALSE,TRUE,g_poy1[l_ac].poy45,l_plant)  #NO.TQC-740188   #FUN-990069
                 RETURNING g_poy1[l_ac].poy45
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy45) THEN 
                    LET g_poy1[l_ac].poy45 = g_poy1_t.poy45
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy45 TO poy45
                 NEXT FIELD poy45
              WHEN INFIELD(poy46)
                 CALL q_m_gem(FALSE,TRUE,g_poy1[l_ac].poy46,l_plant_s) #NO.TQC-740188 #FUN-990069     #MOD-9C0168
                 RETURNING g_poy1[l_ac].poy46
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy46) THEN 
                    LET g_poy1[l_ac].poy46 = g_poy1_t.poy46
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy46 TO poy46
                 NEXT FIELD poy46
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
        
        ON ACTION manual_input     #NO.FUN-930002    
           CALL i100_b1_input(l_ac)    #No.FUN-930002
           
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   CLOSE WINDOW i000_b1_w
END FUNCTION
 
FUNCTION i000_b2()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)
    l_plant         LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(10)
    l_plant_s       LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(10)
    l_dbs_s         LIKE type_file.chr21,               #no.MOD-740153
    l_dbs2          LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)     #MOD-4A0061
    l_azp01         LIKE azp_file.azp01,                #MOD-4A0061
    t_azp03         LIKE azp_file.azp03,
    l_rec_b         LIKE type_file.num5,                #No.MOD-490331  #No.FUN-680136 SMALLINT
    l_poy02         LIKE poy_file.poy02,
    l_poy03         LIKE poy_file.poy03,
    l_poy04         LIKE poy_file.poy04,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-680136 SMALLINT
    l_int_flag      LIKE type_file.chr1,                #按了放棄鍵否(是:Y,否:N) #MOD-570095 add  #No.FUN-680136 VARCHAR(1)
    t_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)   #上游資料庫
    l_pmc03         LIKE pmc_file.pmc03                 #NO.FUN-670007
DEFINE  lg_smy62      LIKE smy_file.smy62
DEFINE  lg_oay22      LIKE oay_file.oay22
DEFINE  li_result   LIKE type_file.num5                 #No.FUN-550070  #No.FUN-680136 SMALLINT
DEFINE  lg_smy621     LIKE smy_file.smy62                                                                                           
DEFINE  lg_smy622     LIKE smy_file.smy62                                                                                           
  
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_poz.poz01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_poz.* FROM poz_file WHERE poz01=g_poz.poz01
 
    IF g_poz.pozacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_poz.poz01,'mfg1000',0)
       RETURN
    END IF
 
    LET p_row = 14 LET p_col = 21
    OPEN WINDOW i000_b2_w AT p_row,p_col WITH FORM "apm/42f/apmi000_b2"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("apmi000_b2")
    LET g_success='Y'
 
    LET l_ac = 1
    DECLARE i000_b2_cs CURSOR WITH HOLD FOR
        SELECT poy02,poy03,'',poy34,poy35,poy36,poy47,poy48,poy37,poy38,poy39,
               poy40,poy41,poy42,poy43,poy44
          FROM poy_file
         WHERE poy01=g_poz.poz01
 
    FOREACH i000_b2_cs INTO g_poy2[l_ac].*
       LET g_poy2[l_ac].pmc03 = g_poy[l_ac].pmc03
       LET l_ac = l_ac + 1
    END FOREACH
    CALL g_poy2.deleteElement(l_ac)  #No.MOD-490331
    LET l_rec_b = l_ac - 1          #No.MOD-490331
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_ac=1
 
    INPUT ARRAY g_poy2 WITHOUT DEFAULTS FROM s_poy2.*
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=FALSE,APPEND ROW=FALSE)  #no.MOD-780191
 
        BEFORE INPUT
            IF l_rec_b != 0 THEN           #No.MOD-490331
              CALL fgl_set_arr_curr(l_ac)
            END IF                         #No.MOD-490331
            LET l_int_flag = 'N' #按了放棄鍵否='N' #MOD-570095 add
            SELECT * INTO g_oax.* FROM oax_file WHERE oax00='0'  #No.FUN-8C0125
            CALL cl_set_comp_entry("poy48",TRUE)
            IF g_oax.oax04 = 'N' OR cl_null(g_oax.oax04) THEN
               CALL cl_set_comp_entry("poy48",FALSE)
            END IF
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           LET g_poy2_t.* = g_poy2[l_ac].*  #BACKUP
           LET l_n  = ARR_COUNT()
           LET g_success='Y'
           BEGIN WORK
          IF g_poy2[l_ac].poy02 = 99 THEN
             CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs,l_plant  #No.FUN-980025       #前站營運
          ELSE
             CALL i000_azp(g_poy[l_ac].poy04)   RETURNING l_dbs,l_plant  #No.FUN-980025
          END IF
 
          IF cl_null(l_dbs) THEN 
             LET l_dbs = s_dbstring(g_dbs CLIPPED)
          END IF 
 
            LET l_dbs_s = NULL   #MOD-A50033
            LET l_plant_s = NULL #MOD-A50033
            IF g_poy2[l_ac].poy02 > 0 AND g_poy2[1].poy02 = 0 THEN
                CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs_s,l_plant_s #No.FUN-980025  #NO.MOD-740153
               IF cl_null(l_dbs_s) THEN 
                  LET l_dbs_s = s_dbstring(g_dbs CLIPPED)
               END IF 
           END IF
           #CALL i000_pmc(g_poy2[l_ac].poy03,'e',l_dbs) RETURNING l_pmc03
           CALL i000_pmc(g_poy2[l_ac].poy03,'e',l_plant) RETURNING l_pmc03   #FUN-A50102
           DISPLAY l_pmc03 TO FORMONLY.pmc03_2
   
       AFTER FIELD poy34 
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy34) AND g_poy2[l_ac].poy02 <>0 ) OR    #NO.TQC-7C0148
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy34) AND g_poy2[l_ac].poy02 <> 99 ) THEN  #MOD-810056 modify
             CALL cl_err('','agl-154',0) 
             LET g_poy2[l_ac].poy34 = g_poy2_t.poy34   #NO.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy34        #NO.TQC-7C0148
             NEXT FIELD poy34
         END IF
         IF NOT cl_null(g_poy2[l_ac].poy34) THEN
            CALL s_check_no("axm",g_poy2[l_ac].poy34,g_poy2_t.poy34,"30","","",l_plant)  #TQC-9B0162
              RETURNING li_result,g_poy2[l_ac].poy34
            CALL s_get_doc_no(g_poy2[l_ac].poy34) RETURNING g_poy2[l_ac].poy34
            DISPLAY BY NAME g_poy2[l_ac].poy34
            IF (NOT li_result) THEN
                LET g_poy2[l_ac].poy34 = g_poy2_t.poy34 
                DISPLAY BY NAME g_poy2[l_ac].poy34
                NEXT FIELD poy34
            END IF
         END IF
         IF NOT cl_null(g_poy2[l_ac].poy34) THEN
            IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN 
               #CALL i000_oay(g_poy2[l_ac].poy34,l_dbs) RETURNING lg_oay22
               CALL i000_oay(g_poy2[l_ac].poy34,l_plant) RETURNING lg_oay22 #FUN-A50102
               IF NOT cl_null(g_poy2[l_ac].poy35) THEN
                  IF g_poy[l_ac].poy02 > 0 AND g_poy[1].poy02 = 0 THEN
                      #CALL i000_smy(g_poy2[l_ac].poy35,l_dbs) RETURNING lg_smy62
                      CALL i000_smy(g_poy2[l_ac].poy35,l_plant) RETURNING lg_smy62  #FUN-A50102
                  ELSE
                      #CALL i000_smy(g_poy2[l_ac].poy35,l_dbs_s) RETURNING lg_smy62  #NO.MOD-740153
                      CALL i000_smy(g_poy2[l_ac].poy35,l_plant_s) RETURNING lg_smy62   #FUN-A50102
　　　　　　　    END IF
                  IF lg_oay22 <> lg_smy62 THEN
                     CALL cl_err(g_poy2[l_ac].poy34,'axm-058',0)
                     IF g_chkey = 'Y' THEN
                        LET g_poy2[l_ac].poy34 = g_poy2_t.poy34
                        DISPLAY BY NAME g_poy2[l_ac].poy34
                        NEXT FIELD poy34
                     ELSE 
                        LET g_poy2[l_ac].poy34 = g_poy2_t.poy34
                        DISPLAY BY NAME g_poy2[l_ac].poy34
                        NEXT FIELD poy35
                     END IF
                  END IF
                  IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR
                     (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN
                     CALL cl_err(g_poy2[l_ac].poy34,'axm-058',0)
                     IF g_chkey = 'Y' THEN
                        LET g_poy2[l_ac].poy34 = g_poy2_t.poy34
                        DISPLAY BY NAME g_poy2[l_ac].poy34
                        NEXT FIELD poy34
                     ELSE
                        LET g_poy2[l_ac].poy34 = g_poy2_t.poy34
                        DISPLAY BY NAME g_poy2[l_ac].poy34
                        NEXT FIELD poy35
                     END IF
                  END IF
               END IF
            ELSE
               LET lg_oay22 = ''
            END IF
         END IF
 
       AFTER FIELD poy35
        IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白   #TQC-7C0164
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy35) AND g_poy2[l_ac].poy02 <> 0) OR    #NO.TQC-7C0148
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy35)) THEN
             CALL cl_err('','agl-154',0)
             LET g_poy2[l_ac].poy35 = g_poy2_t.poy35    #no.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy35         #no.TQC-7C0148
             NEXT FIELD poy35
         END IF
        END IF  #FUN-7C0004
         IF NOT cl_null(g_poy2[l_ac].poy35) THEN
                CALL s_check_no("apm",g_poy2[l_ac].poy35,g_poy2_t.poy35,"2","","",l_plant_s)#NO.MOD-740153  #No.TQC-9B0162
                RETURNING li_result,g_poy2[l_ac].poy35
            CALL s_get_doc_no(g_poy2[l_ac].poy35) RETURNING g_poy2[l_ac].poy35
            DISPLAY BY NAME g_poy2[l_ac].poy35
            IF (NOT li_result) THEN
                LET g_poy2[l_ac].poy35 = g_poy2_t.poy35 
                DISPLAY BY NAME g_poy2[l_ac].poy35
                NEXT FIELD poy35
            END IF
            IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN 
                   #CALL i000_smy(g_poy2[l_ac].poy35,l_dbs_s) RETURNING lg_smy62  #NO.MOD-740153
                   CALL i000_smy(g_poy2[l_ac].poy35,l_plant_s) RETURNING lg_smy62   #FUN-A50102
               IF NOT cl_null(g_poy2[l_ac].poy34) THEN
                  #CALL i000_oay(g_poy2[l_ac].poy34,l_dbs) RETURNING lg_oay22
                  CALL i000_oay(g_poy2[l_ac].poy34,l_plant) RETURNING lg_oay22  #FUN-A50102
                  IF lg_oay22 <> lg_smy62 THEN
                     CALL cl_err(g_poy2[l_ac].poy35,'axm-058',0)
                     LET g_poy2[l_ac].poy35 = g_poy2_t.poy35
                     DISPLAY BY NAME g_poy2[l_ac].poy35
                     NEXT FIELD poy35
                  END IF
                  IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR
                     (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN
                     CALL cl_err(g_poy2[l_ac].poy34,'axm-058',0)
                     LET g_poy2[l_ac].poy35 = g_poy2_t.poy35
                     DISPLAY BY NAME g_poy2[l_ac].poy35
                     NEXT FIELD poy35
                  END IF
               END IF
            ELSE
               LET lg_smy62 = ''
            END IF
         END IF
 
        AFTER FIELD poy36                        #check 編號是否重複
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy36)) OR 
           (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy36) AND g_poy2[l_ac].poy02 <> 99) THEN  #MOD-810056 modify 
             CALL cl_err('','agl-154',0)
             LET g_poy2[l_ac].poy36  = g_poy2_t.poy36    #NO.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy36          #NO.TQC-7C0148
             NEXT FIELD poy36
         END IF
            IF g_poy2[l_ac].poy36 IS NOT NULL THEN
               CALL s_check_no('axm',g_poy2[l_ac].poy36,g_poy2_t.poy36,"50","","",l_plant)  #TQC-9B0162
                 RETURNING li_result,g_poy2[l_ac].poy36
               CALL s_get_doc_no(g_poy2[l_ac].poy36) RETURNING g_poy2[l_ac].poy36
               DISPLAY BY NAME g_poy2[l_ac].poy36
               IF (NOT li_result) THEN
                  LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
                  DISPLAY BY NAME g_poy2[l_ac].poy36
    	          NEXT FIELD poy36
               END IF
               IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                   
                  #CALL i000_oay(g_poy2[l_ac].poy36,l_dbs) RETURNING lg_oay22
                  CALL i000_oay(g_poy2[l_ac].poy36,l_plant) RETURNING lg_oay22  #FUN-A50102
                  IF NOT cl_null(g_poy2[l_ac].poy37) THEN                                                                               #
                     IF g_poy[l_ac].poy02 > 0 AND g_poy[1].poy02 = 0 THEN
                         #CALL i000_smy(g_poy2[l_ac].poy37,l_dbs) RETURNING lg_smy62
                         CALL i000_smy(g_poy2[l_ac].poy37,l_plant) RETURNING lg_smy62  #FUN-A50102
                     ELSE
                         #CALL i000_smy(g_poy2[l_ac].poy37,l_dbs_s) RETURNING lg_smy62  #NO.MOD-740153
                         CALL i000_smy(g_poy2[l_ac].poy37,l_plant_s) RETURNING lg_smy62 #FUN-A50102 
                     END IF
                     IF lg_oay22 <> lg_smy621 THEN                                                                                      
                        CALL cl_err(g_poy2[l_ac].poy36,'axm-046',0)                                                                     
                        IF g_chkey = 'Y' THEN
                           LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
                           DISPLAY BY NAME g_poy2[l_ac].poy36
                           NEXT FIELD poy36 
                        ELSE 
                           LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
                           DISPLAY BY NAME g_poy2[l_ac].poy36
                           NEXT FIELD poy37
                        END IF                                                                                              
                     END IF                                                                                                            
                     IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy621)) OR                                                               
                        (NOT cl_null(lg_oay22) AND cl_null(lg_smy621)) THEN                                                             
                        CALL cl_err(g_poy2[l_ac].poy36,'axm-046',0)                                                                     
                        IF g_chkey = 'Y' THEN
                           LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
                           DISPLAY BY NAME g_poy2[l_ac].poy36
                           NEXT FIELD poy36                                                                                               
                        ELSE
                           LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
                           DISPLAY BY NAME g_poy2[l_ac].poy36
                           NEXT FIELD poy37
                        END IF
                     END IF                                                                                                            
                  END IF                                                                                                               
                  IF NOT cl_null(g_poy2[l_ac].poy38) THEN                                                                               
                     SELECT smy62 INTO lg_smy622 FROM smy_file 
                      WHERE smyslip = g_poy2[l_ac].poy38                                           
                     IF lg_oay22 <> lg_smy622 THEN                                                                                      
                        CALL cl_err(g_poy2[l_ac].poy36,'axm-046',0)                                                                     
                        IF g_chkey = 'Y' THEN
                           LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
                           DISPLAY BY NAME g_poy2[l_ac].poy36
                           NEXT FIELD poy36                                                                                               
                        ELSE 
                           LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
                           DISPLAY BY NAME g_poy2[l_ac].poy36
                           NEXT FIELD poy38
                        END IF
                     END IF                                                                                                            
                     IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy622)) OR                                                               
                        (NOT cl_null(lg_oay22) AND cl_null(lg_smy622)) THEN                                                             
                        CALL cl_err(g_poy2[l_ac].poy36,'axm-046',0)                                                                     
                        IF g_chkey = 'Y' THEN
                           LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
                           DISPLAY BY NAME g_poy2[l_ac].poy36
                           NEXT FIELD poy36                                                                                               
                        ELSE
                           LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
                           DISPLAY BY NAME g_poy2[l_ac].poy36
                           NEXT FIELD poy38
                        END IF
                     END IF                                                                                                            
                  END IF                                                                                                               
               ELSE                                                                                                                    
                  LET lg_oay22 = ''                                                                                                    
               END IF                                                                                                                  
            END IF
 
        AFTER FIELD poy37
        IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12)) THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白   #TQC-7C0164
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy37) AND g_poy2[l_ac].poy02 <> 0) OR   #NO.TQC-7C0148
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy37) AND g_poy2[l_ac].poy02 <> 99) OR  #MOD-810056 modify
            (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy37) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN  #MOD-810056 modify
             CALL cl_err('','agl-154',0)
             LET g_poy2[l_ac].poy37 = g_poy2_t.poy37   #NO.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy37        #no.TQC-7C0148
             NEXT FIELD poy37
         END IF
        END IF   #FUN-7C0004 add
           IF NOT cl_null(g_poy2[l_ac].poy37) THEN
                  CALL s_check_no("apm",g_poy2[l_ac].poy37,g_poy2_t.poy37,"3","","",l_plant_s)   #NO.MOD-740153 #TQC-9B0162
                  RETURNING li_result,g_poy2[l_ac].poy37
              CALL s_get_doc_no(g_poy2[l_ac].poy37) RETURNING g_poy2[l_ac].poy37
              DISPLAY BY NAME g_poy2[l_ac].poy37
              IF (NOT li_result) THEN
                  LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
                  DISPLAY BY NAME g_poy2[l_ac].poy37
    	          NEXT FIELD poy37
              END IF
 
              IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                   
                     #CALL i000_smy(g_poy2[l_ac].poy37,l_dbs_s) RETURNING lg_smy62     #NO.MOD-740153
                     CALL i000_smy(g_poy2[l_ac].poy37,l_plant_s) RETURNING lg_smy62      #FUN-A50102
                 IF NOT cl_null(g_poy2[l_ac].poy36) THEN                                                                               
                    #CALL i000_oay(g_poy2[l_ac].poy36,l_dbs) RETURNING lg_oay22
                    CALL i000_oay(g_poy2[l_ac].poy36,l_plant) RETURNING lg_oay22  #FUN-A50102
                    IF lg_oay22 <> lg_smy621 THEN                                                                                      
                       CALL cl_err(g_poy2[l_ac].poy37,'axm-046',0)                                                                     
                       LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
                       DISPLAY BY NAME g_poy2[l_ac].poy37
                       NEXT FIELD poy37                                                                                               
                    END IF                                                                                                            
                    IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy621)) OR                                                               
                       (NOT cl_null(lg_oay22) AND cl_null(lg_smy621)) THEN                                                             
                       CALL cl_err(g_poy2[l_ac].poy37,'axm-046',0)                                                                     
                       LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
                       DISPLAY BY NAME g_poy2[l_ac].poy37
                       NEXT FIELD poy37                                                                                               
                    END IF                                                                                                            
                 END IF                                                                                                               
                 IF NOT cl_null(g_poy2[l_ac].poy38) THEN                                                                               
                    SELECT smy62 INTO lg_smy622  
                      FROM smy_file WHERE smyslip = g_poy2[l_ac].poy38                                           
                    IF lg_smy621 <> lg_smy622 THEN                                                                                      
                       CALL cl_err(g_poy2[l_ac].poy37,'axm-046',0)                                                                     
                       LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
                       DISPLAY BY NAME g_poy2[l_ac].poy37
                       NEXT FIELD poy37                                                                                               
                    END IF                                                                                                            
                    IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy622)) OR                                                               
                       (NOT cl_null(lg_smy621) AND cl_null(lg_smy622)) THEN                                                             
                       CALL cl_err(g_poy2[l_ac].poy37,'axm-046',0)                                                                     
                       LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
                       DISPLAY BY NAME g_poy2[l_ac].poy37
                       NEXT FIELD poy37                                                                                               
                    END IF                                                                                                            
                 END IF                                                                                                               
              ELSE                                                                                                                    
                 LET lg_smy621 = ''                                                                                                    
              END IF                                                                                                                  
           END IF
 
        AFTER FIELD poy38
        IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白  #TQC-7C0164
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy38) AND g_poy2[l_ac].poy02 <> 0) OR   #no.TQC-7C0148
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy38) AND g_poy2[l_ac].poy02 <> 99) OR  #MOD-810056 modify
            (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy38) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN  #MOD-810056 modify
             CALL cl_err('','agl-154',0)
             LET g_poy2[l_ac].poy38  = g_poy2_t.poy38      #no.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy38            #no.TQC-7C0148
             NEXT FIELD poy38
         END IF
        END IF  #FUN-7C0004
           IF NOT cl_null(g_poy2[l_ac].poy38) THEN
                  CALL s_check_no("apm",g_poy2[l_ac].poy38,g_poy2_t.poy38,"7","","",l_plant_s) #NO.MOD-740153 #TQC-9B0162
                  RETURNING li_result,g_poy2[l_ac].poy38
              CALL s_get_doc_no(g_poy2[l_ac].poy38) RETURNING g_poy2[l_ac].poy38
              DISPLAY BY NAME g_poy2[l_ac].poy38
              IF (NOT li_result) THEN
                 LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
                 DISPLAY BY NAME g_poy2[l_ac].poy38
    	         NEXT FIELD poy38
              END IF
 
              IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                   
                     #CALL i000_smy(g_poy2[l_ac].poy38,l_dbs_s) RETURNING lg_smy62   #NO.MOD-740153
                     CALL i000_smy(g_poy2[l_ac].poy38,l_plant_s) RETURNING lg_smy62    #FUN-A50102
                 IF NOT cl_null(g_poy2[l_ac].poy36) THEN                                                                               
                    #CALL i000_oay(g_poy2[l_ac].poy36,l_dbs) RETURNING lg_oay22
                    CALL i000_oay(g_poy2[l_ac].poy36,l_plant) RETURNING lg_oay22 #FUN-A50102
                    IF lg_oay22 <> lg_smy622 THEN                                                                                      
                       CALL cl_err(g_poy2[l_ac].poy38,'axm-046',0)                                                                     
                       LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
                       DISPLAY BY NAME g_poy2[l_ac].poy38
                       NEXT FIELD poy38                                                                                               
                    END IF                                                                                                            
                    IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy622)) OR                                                               
                       (NOT cl_null(lg_oay22) AND cl_null(lg_smy622)) THEN                                                             
                       CALL cl_err(g_poy2[l_ac].poy38,'axm-046',0)                                                                     
                       LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
                       DISPLAY BY NAME g_poy2[l_ac].poy38
                       NEXT FIELD poy38                                                                                               
                    END IF                                                                                                            
                 END IF                                                                                                               
                 IF NOT cl_null(g_poy2[l_ac].poy37) THEN                                                                               
                    SELECT smy62 INTO lg_smy621 
                      FROM smy_file WHERE smyslip = g_poy2[l_ac].poy37                                           
                    IF lg_smy621 <> lg_smy622 THEN                                                                                      
                       CALL cl_err(g_poy2[l_ac].poy38,'axm-046',0)                                                                     
                       LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
                       DISPLAY BY NAME g_poy2[l_ac].poy38
                       NEXT FIELD poy38                                                                                               
                    END IF                                                                                                            
                    IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy622)) OR                                                               
                       (NOT cl_null(lg_smy621) AND cl_null(lg_smy622)) THEN                                                             
                       CALL cl_err(g_poy2[l_ac].poy38,'axm-046',0)                                                                     
                       LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
                       DISPLAY BY NAME g_poy2[l_ac].poy38
                       NEXT FIELD poy38                                                                                               
                    END IF                                                                                                            
                 END IF                                                                                                               
              ELSE                                                                                                                    
                 LET lg_smy622 = ''                                                                                                    
              END IF                                                                                                                  
            END IF
 
        AFTER FIELD poy39
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy39)) OR 
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy39) AND g_poy2[l_ac].poy02 <> 99) THEN  #MOD-810056 modify
             CALL cl_err('','agl-154',0)
             LET g_poy2[l_ac].poy39 = g_poy2_t.poy39       #no.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy39            #no.TQC-7C0148
             NEXT FIELD poy39
         END IF
           IF NOT cl_null(g_poy2[l_ac].poy39) THEN  #NO.MOD-740091
               CALL  s_check_no("axr",g_poy2[l_ac].poy39,g_poy2_t.poy39,"12","","",l_plant) #TQC-9B0162 
                     RETURNING li_result,g_poy2[l_ac].poy39
               CALL s_get_doc_no(g_poy2[l_ac].poy39) RETURNING g_poy2[l_ac].poy39
               DISPLAY BY NAME g_poy2[l_ac].poy39
               IF (NOT li_result) THEN
                  CALL cl_err3("sel","ooy_file",g_poy2[l_ac].poy39,"",'mfg3045',"","",1)  #No.FUN-660167
                  LET g_poy2[l_ac].poy39 = g_poy2_t.poy39
                  DISPLAY BY NAME g_poy2[l_ac].poy39     #NO.TQC-7C0148
                  NEXT FIELD poy39
               END IF
           END IF
 
        AFTER FIELD poy40
        IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白   #TQC-7C0164
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy40) AND g_poy2[l_ac].poy02 <> 0) OR   #NO.TQC-7C0148
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy40) AND g_poy2[l_ac].poy02 <> 99) OR  #MOD-810056 modify
            (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy40) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN  #MOD-810056 modify
             CALL cl_err('','agl-154',0)
             LET g_poy2[l_ac].poy40  = g_poy2_t.poy40   #no.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy40         #no.TQC-7C0148
             NEXT FIELD poy40
         END IF
        END IF   #FUN-7C0004
         IF NOT cl_null(g_poy2[l_ac].poy40) THEN
               CALL s_check_no("aap",g_poy2[l_ac].poy40,g_poy2_t.poy40,"11","","",l_plant_s) #NO.TQC-7C0148 #MOD-990053 #TQC-9B0162
               RETURNING li_result,g_poy2[l_ac].poy40
            CALL s_get_doc_no(g_poy2[l_ac].poy40) RETURNING g_poy2[l_ac].poy40
            DISPLAY BY NAME g_poy2[l_ac].poy40
            IF (NOT li_result) THEN
               LET g_poy2[l_ac].poy40 = g_poy2_t.poy40 
               DISPLAY BY NAME g_poy2[l_ac].poy40
    	       NEXT FIELD poy40
            END IF
         END IF
 
        AFTER FIELD poy41                        #check 編號是否重複
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy41)) OR 
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy41) AND g_poy2[l_ac].poy02 <> 99) THEN  #MOD-810056 modify
             CALL cl_err('','agl-154',0)
             LET g_poy2[l_ac].poy41=g_poy2_t.poy41   #no.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy41      #no.TQC-7C0148
             NEXT FIELD poy41
         END IF
          IF g_poy2[l_ac].poy41 IS NOT NULL THEN
            CALL s_check_no("axm",g_poy2[l_ac].poy41,g_poy2_t.poy41,"60","","",l_plant)  #TQC-9B0162
              RETURNING li_result,g_poy2[l_ac].poy41
            CALL s_get_doc_no(g_poy2[l_ac].poy41) RETURNING g_poy2[l_ac].poy41
            DISPLAY BY NAME g_poy2[l_ac].poy41
            IF (NOT li_result) THEN
                LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
                DISPLAY BY NAME g_poy2[l_ac].poy41
                NEXT FIELD poy41
            END IF
 
            IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                      
               #CALL i000_oay(g_poy2[l_ac].poy41,l_dbs) RETURNING lg_oay22
               CALL i000_oay(g_poy2[l_ac].poy41,l_plant) RETURNING lg_oay22 #FUN-A50102
               IF NOT cl_null(g_poy2[l_ac].poy42) THEN                                                                                  
               # CALL i000_smy(g_poy2[l_ac].poy42,l_plant_s) RETURNING lg_smy62   #MOD-9C0168   #No.FUN-A10099
                 #CALL i000_smy(g_poy2[l_ac].poy42,l_dbs_s)   RETURNING lg_smy62   #MOD-9C0168   #No.FUN-A10099
                 CALL i000_smy(g_poy2[l_ac].poy42,l_plant_s)   RETURNING lg_smy62    #FUN-A50102
                  IF lg_oay22 <> lg_smy62 THEN                                                                                         
                     CALL cl_err(g_poy2[l_ac].poy41,'axm-059',0)                                                                        
                     IF g_chkey = 'Y' THEN
                        LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
                        DISPLAY BY NAME g_poy2[l_ac].poy41
                        NEXT FIELD poy41                                                                                                  
                     ELSE
                        LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
                        DISPLAY BY NAME g_poy2[l_ac].poy41
                        NEXT FIELD poy42
                     END IF
                  END IF                                                                                                               
                  IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR                                                                  
                     (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN                                                                
                     CALL cl_err(g_poy2[l_ac].poy41,'axm-059',0)                                                                        
                     IF g_chkey = 'Y' THEN
                        LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
                        DISPLAY BY NAME g_poy2[l_ac].poy41
                        NEXT FIELD poy41     
                     ELSE
                        LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
                        DISPLAY BY NAME g_poy2[l_ac].poy41
                        NEXT FIELD poy42
                     END IF                                                                                             
                  END IF                                                                                                               
               END IF                                                                                                                  
            ELSE                                                                                                                       
               LET lg_oay22 = ''                                                                                                       
            END IF                                                                                                                     
          END IF
 
        AFTER FIELD poy42
        IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12)) THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白   #TQC-7C0164
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy42) AND g_poy2[l_ac].poy02 <> 0) OR   #NO.TQC-7C0148
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy42) AND g_poy2[l_ac].poy02 <> 99) OR  #MOD-810056 modify
            (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy42) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN  #MOD-810056 modify
             CALL cl_err('','agl-154',0)
             LET g_poy2[l_ac].poy42 = g_poy2_t.poy42   #no.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy42        #no.TQC-7C0148
             NEXT FIELD poy42
         END IF
        END IF #FUN-7C0004 add
         IF NOT cl_null(g_poy2[l_ac].poy42) THEN
               CALL s_check_no("apm",g_poy2[l_ac].poy42,g_poy2_t.poy42,"4","","",l_plant_s) #NO.TQC-7C0148 #TQC-9B0162
               RETURNING li_result,g_poy2[l_ac].poy42
            CALL s_get_doc_no(g_poy2[l_ac].poy42) RETURNING g_poy2[l_ac].poy42
           DISPLAY BY NAME g_poy2[l_ac].poy42
           IF (NOT li_result) THEN
               LET g_poy2[l_ac].poy42 = g_poy2_t.poy42 
               DISPLAY BY NAME g_poy2[l_ac].poy42
       	       NEXT FIELD poy42
           END IF
          END IF
          IF NOT cl_null(g_poy2[l_ac].poy42) THEN
             IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                      
                #CALL i000_smy(g_poy2[l_ac].poy42,l_dbs_s) RETURNING lg_smy62   #NO.TQC-7C0148
               CALL i000_smy(g_poy2[l_ac].poy42,l_plant_s) RETURNING lg_smy62     #FUN-A50102 
                IF NOT cl_null(g_poy2[l_ac].poy41) THEN                                                                                  
                   #CALL i000_oay(g_poy2[l_ac].poy41,l_dbs) RETURNING lg_oay22
                   CALL i000_oay(g_poy2[l_ac].poy41,l_plant) RETURNING lg_oay22 #FUN-A50102
                   IF lg_oay22 <> lg_smy62 THEN                                                                                         
                      CALL cl_err(g_poy2[l_ac].poy42,'axm-059',0)                                                                        
                      LET g_poy2[l_ac].poy42 = g_poy2_t.poy42 
                      DISPLAY BY NAME g_poy2[l_ac].poy42
                      NEXT FIELD poy42                                                                                                  
                   END IF                                                                                                               
                   IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR                                                                  
                      (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN                                                                
                      CALL cl_err(g_poy2[l_ac].poy42,'axm-058',0)                                                                        
                      LET g_poy2[l_ac].poy42 = g_poy2_t.poy42 
                      DISPLAY BY NAME g_poy2[l_ac].poy42
                      NEXT FIELD poy42                                                                                                  
                   END IF                                                                                                               
                END IF                                                                                                                  
             ELSE                                                                                                                       
                LET lg_smy62 = ''                                                                                                       
             END IF                                                                                                                     
          END IF
 
        AFTER FIELD poy43
         IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy43)) OR 
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy43) AND g_poy2[l_ac].poy02 <> 99 )  THEN  #MOD-810056 modify
             CALL cl_err('','agl-154',0)
             LET g_poy2[l_ac].poy43 = g_poy2_t.poy43  #no.TQC-7C0148
             DISPLAY BY NAME g_poy2[l_ac].poy43       #no.TQC-7C0148            
             NEXT FIELD poy43
         END IF
           IF NOT cl_null(g_poy2[l_ac].poy43) THEN
               CALL s_check_no("axr",g_poy2[l_ac].poy43,g_poy2_t.poy43,"21","","",l_plant) #TQC-9B0162
                     RETURNING li_result,g_poy2[l_ac].poy43
               CALL s_get_doc_no(g_poy2[l_ac].poy43) RETURNING g_poy2[l_ac].poy43
               DISPLAY BY NAME g_poy2[l_ac].poy43
               IF (NOT li_result) THEN
                  CALL cl_err3("sel","smy_file",g_poy2[l_ac].poy43,"",'mfg3045',"","",1)  #No.FUN-660167
                  LET g_poy2[l_ac].poy43 = g_poy2_t.poy43
                  DISPLAY BY NAME g_poy2[l_ac].poy43       #no.TQC-7C0148
                  NEXT FIELD poy43
               END IF
           END IF
 
        AFTER FIELD poy44
        IF g_poz.poz12 <> 'Y' THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白 
          IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy44) AND g_poy2[l_ac].poy02 <>0 ) OR   #NO.TQC-7C0148
             (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy44) AND g_poy2[l_ac].poy02 <> 99) OR  #MOD-810056 modify
             (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy44) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN  #MOD-810056 modify
              CALL cl_err('','agl-154',0)
              LET g_poy2[l_ac].poy44 = g_poy2_t.poy44   #no.TQC-7C0148
              DISPLAY BY NAME g_poy2[l_ac].poy44        #no.TQC-7C0148
              NEXT FIELD poy44
          END IF
        END IF  #FUN-7C0004 add
         IF NOT cl_null(g_poy2[l_ac].poy44) THEN
               CALL s_check_no("aap",g_poy2[l_ac].poy44,g_poy2_t.poy44,"21","","",l_plant_s) #NO.TQC-7C0148 #TQC-990061 #TQC-9B0162
               RETURNING li_result,g_poy2[l_ac].poy44
            CALL s_get_doc_no(g_poy2[l_ac].poy44) RETURNING g_poy2[l_ac].poy44
            DISPLAY BY NAME g_poy2[l_ac].poy44
            IF (NOT li_result) THEN
               LET g_poy2[l_ac].poy44 = g_poy2_t.poy44 
               DISPLAY BY NAME g_poy2[l_ac].poy44
               NEXT FIELD poy44
            END IF
         END IF
 
        AFTER FIELD poy47                        #check 編號是否重複
            IF g_poy2[l_ac].poy47 IS NOT NULL THEN
               CALL s_check_no('axm',g_poy2[l_ac].poy47,g_poy2_t.poy47,"40","","",l_plant) #TQC-9B0162
                 RETURNING li_result,g_poy2[l_ac].poy47
               CALL s_get_doc_no(g_poy2[l_ac].poy47) RETURNING g_poy2[l_ac].poy47
               DISPLAY BY NAME g_poy2[l_ac].poy47
               IF (NOT li_result) THEN
                  LET g_poy2[l_ac].poy47 = g_poy2_t.poy47
                  DISPLAY BY NAME g_poy2[l_ac].poy47
    	          NEXT FIELD poy47
               END IF
            END IF
        AFTER FIELD poy48                        #check 編號是否重複
            IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy48)) OR 
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy48) AND g_poy2[l_ac].poy02 <> 99) THEN
                CALL cl_err('','agl-154',0)
                LET g_poy2[l_ac].poy48 = g_poy2_t.poy48
                DISPLAY BY NAME g_poy2[l_ac].poy48
                NEXT FIELD poy48
            END IF
            IF g_poy2[l_ac].poy48 IS NOT NULL THEN
               CALL s_check_no('axm',g_poy2[l_ac].poy48,g_poy2_t.poy48,"55","","",l_plant) #TQC-9B0162
                 RETURNING li_result,g_poy2[l_ac].poy48
               CALL s_get_doc_no(g_poy2[l_ac].poy48) RETURNING g_poy2[l_ac].poy48
               DISPLAY BY NAME g_poy2[l_ac].poy48
               IF (NOT li_result) THEN
                  LET g_poy2[l_ac].poy48 = g_poy2_t.poy48
                  DISPLAY BY NAME g_poy2[l_ac].poy48
    	          NEXT FIELD poy48
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_int_flag = 'Y' #按了放棄鍵 #MOD-570095 add
              LET g_poy2[l_ac].* = g_poy2_t.*
              CLOSE i000_b2_cs
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i000_b2_cs
           COMMIT WORK
           IF NOT cl_null(g_poy2[l_ac].poy02) THEN
              UPDATE poy_file SET poy34= g_poy2[l_ac].poy34,
                                  poy35= g_poy2[l_ac].poy35,
                                  poy36= g_poy2[l_ac].poy36,
                                  poy47= g_poy2[l_ac].poy47,
                                  poy48= g_poy2[l_ac].poy48,  #No.FUN-8C0125
                                  poy37= g_poy2[l_ac].poy37,
                                  poy38= g_poy2[l_ac].poy38,
                                  poy39= g_poy2[l_ac].poy39,
                                  poy40= g_poy2[l_ac].poy40,
                                  poy41= g_poy2[l_ac].poy41,
                                  poy42= g_poy2[l_ac].poy42,
                                  poy43= g_poy2[l_ac].poy43,
                                  poy44= g_poy2[l_ac].poy44
               WHERE poy01 = g_poz.poz01
                 AND poy02 = g_poy2[l_ac].poy02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","poy_file",g_poy2[l_ac].poy02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_poy2[l_ac].* = g_poy2_t.*
                 LET g_success = 'N'
              ELSE
                  MESSAGE 'UPDATE O.K'
              END IF
           END IF
           IF g_success='Y' THEN
              COMMIT WORK
           ELSE
              CALL cl_rbmsg(1)
              ROLLBACK WORK
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(poy34)     #查詢訂單單別                              
                CALL q_m_oay(FALSE,TRUE,g_t,'30','AXM',g_poy[l_ac].poy04) RETURNING g_t        #No.FUN-980017 
                LET g_poy2[l_ac].poy34=g_t
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy34) THEN 
                   LET g_poy2[l_ac].poy34 = g_poy2_t.poy34 
                END IF    
                #TQC-D40028 add end
                DISPLAY BY NAME g_poy2[l_ac].poy34
                NEXT FIELD poy34
             WHEN INFIELD(poy35)     #查詢采購單別
                CALL q_m_smy(FALSE,TRUE,g_t,'APM','2',l_plant_s) RETURNING g_t                 #No.FUN-980017 #MOD-9C0168
                LET g_poy2[l_ac].poy35=g_t
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy35) THEN 
                   LET g_poy2[l_ac].poy35 = g_poy2_t.poy35 
                END IF    
                #TQC-D40028 add end                
                DISPLAY BY NAME g_poy2[l_ac].poy35
                NEXT FIELD poy35
             WHEN INFIELD(poy36)
                CALL q_m_oay(FALSE,TRUE,g_poy2[l_ac].poy36,'50','AXM',g_poy[l_ac].poy04)   #No.FUN-980017
                RETURNING g_poy2[l_ac].poy36
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy36) THEN 
                   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36 
                END IF    
                #TQC-D40028 add end                
                DISPLAY g_poy2[l_ac].poy36  TO poy36
                NEXT FIELD poy36
             WHEN INFIELD(poy47)
                CALL q_m_oay(FALSE,TRUE,g_poy2[l_ac].poy36,'40','AXM',g_poy[l_ac].poy04)   #NO.TQC-740188
                RETURNING g_poy2[l_ac].poy47
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy47) THEN 
                   LET g_poy2[l_ac].poy47 = g_poy2_t.poy47 
                END IF    
                #TQC-D40028 add end                
                DISPLAY g_poy2[l_ac].poy47  TO poy47
                NEXT FIELD poy47
             WHEN INFIELD(poy48)
                CALL q_m_oay(FALSE,TRUE,g_poy2[l_ac].poy48,'55','AXM',g_poy[l_ac].poy04)    #NO.TQC-740188 
                RETURNING g_poy2[l_ac].poy48
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy48) THEN 
                   LET g_poy2[l_ac].poy48 = g_poy2_t.poy48 
                END IF    
                #TQC-D40028 add end                
                DISPLAY g_poy2[l_ac].poy48  TO poy48
                NEXT FIELD poy48
             WHEN INFIELD(poy37)
                    CALL q_m_smy(FALSE,TRUE,g_poy2[l_ac].poy37,'APM','3',l_plant_s)                #No.FUN-980017     #MOD-9C0168
                    RETURNING g_poy2[l_ac].poy37
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy37) THEN 
                   LET g_poy2[l_ac].poy37 = g_poy2_t.poy37 
                END IF    
                #TQC-D40028 add end                    
                DISPLAY g_poy2[l_ac].poy37  TO poy37
                NEXT FIELD poy37
             WHEN INFIELD(poy38)
                    CALL q_m_smy(FALSE,TRUE,g_poy2[l_ac].poy38,'APM','7',l_plant_s)                 #No.FUN-980017          #MOD-9C0168
                    RETURNING g_poy2[l_ac].poy38
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy38) THEN 
                   LET g_poy2[l_ac].poy38 = g_poy2_t.poy38 
                END IF    
                #TQC-D40028 add end                    
                DISPLAY g_poy2[l_ac].poy38  TO poy38
                NEXT FIELD poy38
             WHEN INFIELD(poy39)                                              
                CALL q_m_ooy(FALSE,FALSE,g_poy2[l_ac].poy39,'12','AXR',g_poy[l_ac].poy04)              #No.FUN-980017
                     RETURNING g_poy2[l_ac].poy39   
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy39) THEN 
                   LET g_poy2[l_ac].poy39 = g_poy2_t.poy39 
                END IF    
                #TQC-D40028 add end                                              
                DISPLAY g_poy2[l_ac].poy39  TO poy39
                NEXT FIELD poy39                                            
             WHEN INFIELD(poy40)                                              
                   CALL q_m_apy(FALSE,TRUE,g_poy2[l_ac].poy40,'11','AAP',l_plant_s)   #NO.TQC-7C0148  #FUN-990069  #MOD-9B0036
                   RETURNING g_poy2[l_ac].poy40   
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy40) THEN 
                   LET g_poy2[l_ac].poy40 = g_poy2_t.poy40 
                END IF    
                #TQC-D40028 add end                                            
                DISPLAY g_poy2[l_ac].poy40  TO poy40
                NEXT FIELD poy40  
             WHEN INFIELD(poy41)
                CALL q_m_oay(FALSE,TRUE,g_poy2[l_ac].poy41,'60','AXM',g_poy[l_ac].poy04)       #No.FUN-980017
                     RETURNING g_poy2[l_ac].poy41
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy41) THEN 
                   LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
                END IF    
                #TQC-D40028 add end                     
                DISPLAY g_poy2[l_ac].poy41  TO poy41
                NEXT FIELD poy41
             WHEN INFIELD(poy42)
                   CALL q_m_smy(FALSE,TRUE,g_poy2[l_ac].poy42,'APM','4',l_plant_s)               #No.FUN-980017     #MOD-9C0168
                   RETURNING g_poy2[l_ac].poy42
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy42) THEN 
                   LET g_poy2[l_ac].poy42 = g_poy2_t.poy42 
                END IF    
                #TQC-D40028 add end                   
                DISPLAY g_poy2[l_ac].poy42  TO poy42
                NEXT FIELD poy42
             WHEN INFIELD(poy43)
                CALL q_m_ooy(FALSE,TRUE,g_poy2[l_ac].poy43,'21','AXR',g_poy[l_ac].poy04)     #No.FUN-980017
                     RETURNING g_poy2[l_ac].poy43
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy43) THEN 
                   LET g_poy2[l_ac].poy43 = g_poy2_t.poy43 
                END IF    
                #TQC-D40028 add end                     
                DISPLAY g_poy2[l_ac].poy43  TO poy43
                NEXT FIELD poy43
             WHEN INFIELD(poy44)
                   CALL q_m_apy(FALSE,TRUE,g_poy2[l_ac].poy44,'21','AAP',l_plant_s)  #no.TQC-7C0148    #FUN-990069
                   RETURNING g_poy2[l_ac].poy44
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy44) THEN 
                   LET g_poy2[l_ac].poy44 = g_poy2_t.poy44 
                END IF    
                #TQC-D40028 add end                   
                DISPLAY g_poy2[l_ac].poy44  TO poy44
                NEXT FIELD poy44
             OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        
        ON ACTION manual_input     #NO.FUN-930002    
           CALL i100_b2_input(l_ac)    #No.FUN-930002
           
        ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
   CLOSE WINDOW i000_b2_w
END FUNCTION
 
FUNCTION i000_b3()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)
    l_plant         LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(21)
    l_plant_s       LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(21)
    l_dbs2          LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)     #MOD-4A0061
    l_azp01         LIKE azp_file.azp01,                #MOD-4A0061
    t_azp03         LIKE azp_file.azp03,
    l_rec_b         LIKE type_file.num5,                #No.MOD-490331  #No.FUN-680136 SMALLINT
    l_poy02         LIKE poy_file.poy02,
    l_poy03         LIKE poy_file.poy03,
    l_poy04         LIKE poy_file.poy04,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-680136 SMALLINT
    l_int_flag      LIKE type_file.chr1,                #按了放棄鍵否(是:Y,否:N) #MOD-570095 add  #No.FUN-680136 VARCHAR(1)
    t_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)     #上游資料庫
    l_pmc03         LIKE pmc_file.pmc03                 #NO.FUN-670007
DEFINE l_dbs_s      LIKE type_file.chr21                #NO.TQC-7C0148
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_poz.poz01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_poz.* FROM poz_file WHERE poz01=g_poz.poz01
 
    IF g_poz.pozacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_poz.poz01,'mfg1000',0)
       RETURN
    END IF
 
    LET p_row = 14 LET p_col = 21
    OPEN WINDOW i000_b3_w AT p_row,p_col WITH FORM "apm/42f/apmi000_b3"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("apmi000_b3")
    LET g_success='Y'
 
    LET l_ac = 1
    DECLARE i000_b3_cs CURSOR WITH HOLD FOR
        SELECT poy02,poy03,'',poy10,poy11,poy28,poy31,poy30,poy32
          FROM poy_file
         WHERE poy01=g_poz.poz01
 
    FOREACH i000_b3_cs INTO g_poy3[l_ac].*
       LET g_poy3[l_ac].pmc03 = g_poy[l_ac].pmc03
       LET l_ac = l_ac + 1
    END FOREACH
    CALL g_poy4.deleteElement(l_ac)  #No.MOD-490331
    LET l_rec_b = l_ac - 1          #No.MOD-490331
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_ac=1
 
    INPUT ARRAY g_poy3 WITHOUT DEFAULTS FROM s_poy3.*
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=FALSE,APPEND ROW=FALSE)  #no.MOD-780191
 
        BEFORE INPUT
            IF l_rec_b != 0 THEN           #No.MOD-490331
              CALL fgl_set_arr_curr(l_ac)
            END IF                         #No.MOD-490331
            LET l_int_flag = 'N' #按了放棄鍵否='N' #MOD-570095 add
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           LET g_poy3_t.* = g_poy3[l_ac].*  #BACKUP
           LET l_n  = ARR_COUNT()
           LET g_success='Y'
           BEGIN WORK
           LET l_dbs_s = NULL   #MOD-A50033
           LET l_plant_s = NULL #MOD-A50033
           IF g_poy3[l_ac].poy02 > 0 AND g_poy3[1].poy02 = 0 THEN 
               CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs_s,l_plant_s  #No.FUN-980025  #前一個營運中心
           END IF
 
          IF g_poy3[l_ac].poy02 = 99 THEN
             CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs,l_plant      #No.FUN-980025  #前站營運
          ELSE
             CALL i000_azp(g_poy[l_ac].poy04)   RETURNING l_dbs,l_plant      #No.FUN-980025 
          END IF
 
           #CALL i000_pmc(g_poy3[l_ac].poy03,'e',l_dbs) RETURNING l_pmc03
           CALL i000_pmc(g_poy3[l_ac].poy03,'e',l_plant) RETURNING l_pmc03   #FUN-A50102
           DISPLAY l_pmc03 TO FORMONLY.pmc03_3
   
        AFTER FIELD poy10     #銷售分類
           IF (g_poz.poz00 = '1' AND cl_null(g_poy3[l_ac].poy10) AND g_poy3[l_ac].poy02 <> 0) OR    #NO.TQC-7C0148
              (g_poz.poz00 = '2' AND g_poy3[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 AND cl_null(g_poy3[l_ac].poy10)) THEN  #MOD-910090 
               CALL cl_err('','agl-154',0)
               NEXT FIELD poy10
           END IF
           IF NOT cl_null(g_poy3[l_ac].poy10) THEN
              #CALL i000_oab(g_poy3[l_ac].poy10,l_dbs)
              CALL i000_oab(g_poy3[l_ac].poy10,l_plant)   #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_dbs,g_errno,1)
                 LET g_poy3[l_ac].poy10 = g_poy3_t.poy10
                 DISPLAY BY NAME g_poy3[l_ac].poy10         #no.TQC-7C0148
                 NEXT FIELD poy10
              END IF
           END IF
 
        AFTER FIELD poy11   #倉庫別
          IF (g_poz.poz00 = '1' AND cl_null(g_poy3[l_ac].poy11)) OR 
             (g_poz.poz011 = '2' AND g_poy3[l_ac].poy02 = '0' AND cl_null(g_poy3[l_ac].poy11)) OR #MOD-C50166 add
             (g_poz.poz00 = '2' AND g_poy3[l_ac].poy02 > 0 AND cl_null(g_poy3[l_ac].poy11)) THEN 
               CALL cl_err('','agl-154',0) 
               LET g_poy3[l_ac].poy11 = g_poy3_t.poy11   #no.TQC-7C0148
               DISPLAY BY NAME g_poy3[l_ac].poy11        #no.TQC-7C0148
               NEXT FIELD poy11
           END IF
           IF NOT cl_null(g_poy3[l_ac].poy11) THEN
              #CALL i000_imd(g_poy3[l_ac].poy11,l_dbs)
              CALL i000_imd(g_poy3[l_ac].poy11,l_plant)  #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_dbs,g_errno,0)
                 LET g_poy3[l_ac].poy11 = g_poy3_t.poy11   #No.MOD-570363 Unmark
                 DISPLAY BY NAME g_poy3[l_ac].poy11
                 NEXT FIELD poy11
               END IF
           END IF
 
        AFTER FIELD poy28
           IF NOT cl_null(g_poy3[l_ac].poy28) THEN
               #CALL i000_azf(l_dbs,g_poy3[l_ac].poy28,'2','1')   #No.FUN-930145 
  CALL i000_azf(l_plant,g_poy3[l_ac].poy28,'2','1')   #FUN-A50102             
                   RETURNING l_n
               IF l_n=0 THEN
                   CALL cl_err('',"apm-800",0)
                   LET g_poy3[l_ac].poy28 = g_poy3_t.poy28 
                   DISPLAY BY NAME g_poy3[l_ac].poy28      #no.TQC-7C0148
                   NEXT FIELD poy28
               END IF
           END IF
 
        AFTER FIELD poy31
           IF (g_poz.poz00 = '1' AND cl_null(g_poy3[l_ac].poy31)) OR 
              (g_poz.poz00 = '2' AND g_poy3[l_ac].poy02 > 0 AND cl_null(g_poy3[l_ac].poy31)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy3[l_ac].poy31=g_poy3_t.poy31    #no.TQC-7C0148 
               DISPLAY BY NAME g_poy3[l_ac].poy31       #no.TQC-7C0148
               NEXT FIELD poy31
           END IF
           IF NOT cl_null(g_poy3[l_ac].poy31) THEN
               #CALL i000_azf(l_dbs,g_poy3[l_ac].poy31,'2','2')  #No.FUN-930145
               CALL i000_azf(l_plant,g_poy3[l_ac].poy31,'2','2')   #FUN-A50102
                   RETURNING l_n
               IF l_n=0 THEN
                   CALL cl_err('',"apm-800",0)
                   LET g_poy3[l_ac].poy31 = g_poy3_t.poy31 
                   DISPLAY BY NAME g_poy3[l_ac].poy31
                   NEXT FIELD poy31
               END IF
           END IF
 
        AFTER FIELD poy30
         IF g_poz.poz12 <> 'Y' THEN  #FUN-7C0004 兩角內部交易不判斷此欄位空白 
           IF (g_poz.poz00 = '1' AND cl_null(g_poy3[l_ac].poy30) AND g_poy3[l_ac].poy02 <> 0) OR   #NO.TQC-7C0148
              (g_poz.poz00 = '2' AND g_poy3[l_ac].poy02 > 0 AND cl_null(g_poy3[l_ac].poy30)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy3[l_ac].poy30 = g_poy3_t.poy30   #no.TQC-7C0148
               DISPLAY BY NAME g_poy3[l_ac].poy30        #no.TQC-7C0148
               NEXT FIELD poy30
           END IF
         END IF   #FUN-7C0004 add
           IF NOT cl_null(g_poy3[l_ac].poy30) THEN
               #CALL i000_azf(l_dbs_s,g_poy3[l_ac].poy30,'2','5')  #No.FUN-930145
               CALL i000_azf(l_plant_s,g_poy3[l_ac].poy30,'2','5')   #FUN-A50102
                   RETURNING l_n
               IF l_n=0 THEN
                   CALL cl_err('',"apm-800",0)
                   LET g_poy3[l_ac].poy30 = g_poy3_t.poy30 
                   DISPLAY BY NAME g_poy3[l_ac].poy30   #no.TQC-7C0148
                   NEXT FIELD poy30
                END IF
           END IF
 
        AFTER FIELD poy32
           IF (g_poz.poz00 = '1' AND cl_null(g_poy3[l_ac].poy32)) OR 
              (g_poz.poz00 = '2' AND g_poy3[l_ac].poy02 > 0 AND cl_null(g_poy3[l_ac].poy32)) THEN
               CALL cl_err('','agl-154',0)   
               LET g_poy3[l_ac].poy32 = g_poy3_t.poy32   #no.TQC-7C0148
               DISPLAY BY NAME g_poy3[l_ac].poy32        #no.TQC-7C0148
               NEXT FIELD poy32
           END IF
           IF NOT cl_null(g_poy3[l_ac].poy32) THEN
               #CALL i000_azf(l_dbs,g_poy3[l_ac].poy32,'2','6')     #No.FUN-930145
               CALL i000_azf(l_plant,g_poy3[l_ac].poy32,'2','6')      #FUN-A50102
                   RETURNING l_n
               IF l_n=0 THEN
                   CALL cl_err('',"apm-800",0)
                   LET g_poy3[l_ac].poy32 = g_poy3_t.poy32 
                   DISPLAY BY NAME g_poy3[l_ac].poy32        #no.TQC-7C0148
                   NEXT FIELD poy32
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_int_flag = 'Y' #按了放棄鍵 #MOD-570095 add
              LET g_poy3[l_ac].* = g_poy3_t.*
              CLOSE i000_b2_cs
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i000_b2_cs
           COMMIT WORK
           IF NOT cl_null(g_poy3[l_ac].poy02) THEN
              UPDATE poy_file SET poy10= g_poy3[l_ac].poy10,
                                  poy11= g_poy3[l_ac].poy11,
                                  poy28= g_poy3[l_ac].poy28,
                                  poy31= g_poy3[l_ac].poy31,
                                  poy30= g_poy3[l_ac].poy30,
                                  poy32= g_poy3[l_ac].poy32
               WHERE poy01 = g_poz.poz01
                 AND poy02 = g_poy3[l_ac].poy02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","poy_file",g_poy3[l_ac].poy02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_poy3[l_ac].* = g_poy3_t.*
                 LET g_success = 'N'
              ELSE
                  MESSAGE 'UPDATE O.K'
              END IF
           END IF
           IF g_success='Y' THEN
              COMMIT WORK
           ELSE
              CALL cl_rbmsg(1)
              ROLLBACK WORK
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(poy10)
                 CALL q_m_oab(FALSE,TRUE,g_poy3[l_ac].poy10,g_poy[l_ac].poy04)     #NO.TQC-740188
                 RETURNING g_poy3[l_ac].poy10
                 #TQC-D40028 add begin
                 IF cl_null(g_poy3[l_ac].poy10) THEN 
                    LET g_poy3[l_ac].poy10 = g_poy3_t.poy10
                 END IF 
                 #TQC-D40028 add end   
                 DISPLAY g_poy3[l_ac].poy10 TO poy10
                 NEXT FIELD poy10
              WHEN INFIELD(poy11)
                 CALL q_m_imd(FALSE,TRUE,g_poy3[l_ac].poy11,'S',l_plant)#No.FUN-980025
                 RETURNING g_poy3[l_ac].poy11
                 #TQC-D40028 add begin
                 IF cl_null(g_poy3[l_ac].poy11) THEN  
                    LET g_poy3[l_ac].poy11 = g_poy3_t.poy11
                 END IF 
                 #TQC-D40028 add end                 
                 DISPLAY g_poy3[l_ac].poy11 TO poy11
                 NEXT FIELD poy11
              WHEN INFIELD(poy28)
                 CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant #No.FUN-980025
                 CALL q_m_azf(FALSE,TRUE,g_poy3[l_ac].poy28,'2','1',l_plant)   #No.FUN-930145   #FUN-990069
                      RETURNING g_poy3[l_ac].poy28 
                 #TQC-D40028 add begin
                 IF cl_null(g_poy3[l_ac].poy28) THEN 
                    LET g_poy3[l_ac].poy28 = g_poy3_t.poy28
                 END IF 
                 #TQC-D40028 add end                                                 
                 DISPLAY g_poy3[l_ac].poy28 TO poy28
                 NEXT FIELD poy28                                            
              WHEN INFIELD(poy31)
                 CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant    #No.FUN-980025
                  CALL q_m_azf(FALSE,TRUE,g_poy3[l_ac].poy31,'2','2',l_plant)   #No.FUN-930145       #FUN-990069
                      RETURNING g_poy3[l_ac].poy31
                 #TQC-D40028 add begin
                 IF cl_null(g_poy3[l_ac].poy31) THEN 
                    LET g_poy3[l_ac].poy31 = g_poy3_t.poy31
                 END IF 
                 #TQC-D40028 add end                                                  
                 DISPLAY g_poy3[l_ac].poy31 TO poy31
                 NEXT FIELD poy31                                            
              WHEN INFIELD(poy30)
                 CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant    #No.FUN-980025
                 CALL q_m_azf(FALSE,TRUE,g_poy3[l_ac].poy30,'2','5',l_plant_s)   #No.FUN-930145    #FUN-990069
                      RETURNING g_poy3[l_ac].poy30
                 #TQC-D40028 add begin
                 IF cl_null(g_poy3[l_ac].poy30) THEN 
                    LET g_poy3[l_ac].poy30 = g_poy3_t.poy30
                 END IF 
                 #TQC-D40028 add end                            
                 DISPLAY g_poy3[l_ac].poy30 TO poy30
                 NEXT FIELD poy30                                            
               WHEN INFIELD(poy32)
                 CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant   #No.FUN-980025
                 CALL q_m_azf(FALSE,TRUE,g_poy3[l_ac].poy32,'2','6',l_plant)    #No.FUN-930145  #FUN-990069
                      RETURNING g_poy3[l_ac].poy32  
                 #TQC-D40028 add begin
                 IF cl_null(g_poy3[l_ac].poy32) THEN 
                    LET g_poy3[l_ac].poy32 = g_poy3_t.poy32
                 END IF 
                 #TQC-D40028 add end                                                
                 DISPLAY g_poy3[l_ac].poy32 TO poy32
                 NEXT FIELD poy32                                            
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   CLOSE WINDOW i000_b3_w
END FUNCTION
 
FUNCTION i000_b4()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)
    l_plant         LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(10)
    l_plant_s       LIKE type_file.chr10,               #No.FUN-980025 VARCHAR(10)
    l_dbs2          LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)     #MOD-4A0061
    l_azp01         LIKE azp_file.azp01,                #MOD-4A0061
    t_azp03         LIKE azp_file.azp03,
    l_rec_b         LIKE type_file.num5,                #No.MOD-490331  #No.FUN-680136 SMALLINT
    l_poy02         LIKE poy_file.poy02,
    l_poy03         LIKE poy_file.poy03,
    l_poy04         LIKE poy_file.poy04,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-680136 SMALLINT
    t_dbs           LIKE type_file.chr21,               #No.FUN-680136 VARCHAR(21)   #上游資料庫
    l_int_flag      LIKE type_file.chr1,                #按了放棄鍵否(是:Y,否:N) #MOD-570095 add  #No.FUN-680136 VARCHAR(1)
    l_pmc03         LIKE pmc_file.pmc03,                 #NO.FUN-670007
    l_occ02         LIKE occ_file.occ02                  #FUN-670007 
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_poz.poz01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_poz.* FROM poz_file WHERE poz01=g_poz.poz01
 
    IF g_poz.pozacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_poz.poz01,'mfg1000',0)
       RETURN
    END IF
    LET p_row = 14 LET p_col = 21
    OPEN WINDOW i000_b4_w AT p_row,p_col WITH FORM "apm/42f/apmi000_b4"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("apmi000_b4")
    LET g_success='Y'
 
    LET l_ac = 1
    DECLARE i000_b4_cs CURSOR WITH HOLD FOR
        SELECT poy02,poy03,'',poy26,poy27,'',poy33,poy29,''
          FROM poy_file
         WHERE poy01=g_poz.poz01
 
    FOREACH i000_b4_cs INTO g_poy4[l_ac].*
       LET g_poy4[l_ac].pmc03 = g_poy[l_ac].pmc03
       CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant #No.FUN-980025
       #CALL i000_ocx(g_poy4[l_ac].poy29,l_dbs)
       CALL i000_ocx(g_poy4[l_ac].poy29,l_plant)  #FUN-A50102
          RETURNING l_occ02
       LET g_poy4[l_ac].occ02 = l_occ02
       #CALL i000_tqb(g_poy4[l_ac].poy27,l_dbs) 
       CALL i000_tqb(g_poy4[l_ac].poy27,l_plant)   #FUN-A50102
          RETURNING g_poy4[l_ac].tqb02
       LET l_ac = l_ac + 1
    END FOREACH
    CALL g_poy4.deleteElement(l_ac)  #No.MOD-490331
    LET l_rec_b = l_ac - 1           #No.MOD-490331
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_ac=1
 
    INPUT ARRAY g_poy4 WITHOUT DEFAULTS FROM s_poy4.*
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=FALSE,APPEND ROW=FALSE)  #no.MOD-780191
 
        BEFORE INPUT
            IF l_rec_b != 0 THEN           #No.MOD-490331
              CALL fgl_set_arr_curr(l_ac)
            END IF                         #No.MOD-490331
            LET l_int_flag = 'N' #按了放棄鍵否='N' #MOD-570095 add
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           LET g_poy4_t.* = g_poy4[l_ac].*  #BACKUP
           LET l_n  = ARR_COUNT()
           LET g_success='Y'
           BEGIN WORK
           CALL i000_used() RETURNING g_used   
           LET g_before_input_done = FALSE
           CALL i000_set_entry_b4()
           CALL i000_set_no_entry_b4(g_poy4[l_ac].poy26)
           LET g_before_input_done = TRUE
           CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant #No.FUN-980025
           #CALL i000_tqb(g_poy4[l_ac].poy27,l_dbs) 
           CALL i000_tqb(g_poy4[l_ac].poy27,l_plant)   #FUN-A50102
              RETURNING g_poy4[l_ac].tqb02
           #CALL i000_ocx(g_poy4[l_ac].poy29,l_dbs)
           CALL i000_ocx(g_poy4[l_ac].poy29,l_plant)  #FUN-A50102
              RETURNING l_occ02
           LET g_poy4[l_ac].occ02 = l_occ02
           #CALL i000_pmc(g_poy4[l_ac].poy03,'e',l_dbs) RETURNING l_pmc03
           CALL i000_pmc(g_poy4[l_ac].poy03,'e',l_plant) RETURNING l_pmc03  #FUN-A50102
           DISPLAY l_pmc03 TO FORMONLY.pmc03_4
   
        AFTER FIELD poy26
           IF (g_poz.poz00 = '1' AND cl_null(g_poy4[l_ac].poy26)) OR 
              (g_poz.poz00 = '2' AND g_poy4[l_ac].poy02 > 0 AND cl_null(g_poy4[l_ac].poy26)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy4[l_ac].poy26 = g_poy4_t.poy26   #no.TQC-7C0148
               DISPLAY BY NAME g_poy4[l_ac].poy26        #no.TQC-7C0148
               NEXT FIELD poy26
           END IF
           CALL i000_set_entry_b4()
           CALL i000_set_no_entry_b4(g_poy4[l_ac].poy26)
 
        AFTER FIELD poy27  #業績歸屬方
           IF (g_poz.poz00 = '1' AND cl_null(g_poy4[l_ac].poy27)) OR 
              (g_poz.poz00 = '2' AND g_poy4[l_ac].poy02 > 0 AND cl_null(g_poy4[l_ac].poy27)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy4[l_ac].poy27 =g_poy4_t.poy27   #no.TQC-7C0148
               DISPLAY BY NAME g_poy4[l_ac].poy27       #no.TQC-7C0148
               NEXT FIELD poy27
           END IF
           IF g_poy4[l_ac].poy26='Y' AND cl_null(g_poy4[l_ac].poy27) THEN
              NEXT FIELD poy27
           END IF
           IF (NOT cl_null(g_poy4[l_ac].poy27)) AND (g_poy4[l_ac].poy26 = 'Y') THEN
               CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant   #No.FUN-980025
               #CALL i000_tqb(g_poy4[l_ac].poy27,l_dbs) RETURNING g_poy4[l_ac].tqb02
               CALL i000_tqb(g_poy4[l_ac].poy27,l_plant) RETURNING g_poy4[l_ac].tqb02  #FUN-A50102
               IF NOT cl_null(g_errno) THEN
                  LET g_poy4[l_ac].poy27 = g_poy4_t.poy27
                  CALL cl_err(l_dbs,g_errno,0)
                  DISPLAY BY NAME g_poy4[l_ac].poy27
                  NEXT FIELD poy27
               END IF
               DISPLAY g_poy4[l_ac].tqb02 TO tqb02
           END IF
           IF cl_null(g_poy4[l_ac].poy27) AND (g_poy4[l_ac].poy26 = 'Y') THEN
              INITIALIZE g_poy4[l_ac].poy27 TO NULL
              LET g_poy4[l_ac].tqb02= ' '
              DISPLAY g_poy4[l_ac].tqb02 TO tqb02
              DISPLAY BY NAME g_poy4[l_ac].poy27
           END IF
 
        BEFORE FIELD poy33
           IF ((g_poy4[l_ac].poy26='N') AND (NOT cl_null(g_poy4[l_ac].poy27))) THEN
              INITIALIZE g_poy4[l_ac].poy27 TO NULL
              LET g_poy4[l_ac].tqb02= ' '
              DISPLAY g_poy4[l_ac].tqb02 TO tqb02
              DISPLAY BY NAME g_poy4[l_ac].poy27
           END IF
 
        AFTER FIELD poy33
           IF (g_poz.poz00 = '1' AND cl_null(g_poy4[l_ac].poy33)) OR 
              (g_poz.poz00 = '2' AND g_poy4[l_ac].poy02 > 0 AND cl_null(g_poy4[l_ac].poy33)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy4[l_ac].poy33 = g_poy4_t.poy33   #no.TQC-7C0148
               DISPLAY BY NAME g_poy4[l_ac].poy33        #no.TQC-7C0148
               NEXT FIELD poy33
           END IF
           IF NOT cl_null(g_poy4[l_ac].poy33) THEN
               CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant #No.FUN-980025
               #CALL i000_tqa(g_poy4[l_ac].poy33,l_dbs) 
               CALL i000_tqa(g_poy4[l_ac].poy33,l_plant)   #FUN-A50102
               IF NOT cl_null(g_errno) THEN
                  LET g_poy4[l_ac].poy33 = g_poy4_t.poy33
                  CALL cl_err(l_dbs,g_errno,0)
                  DISPLAY BY NAME g_poy4[l_ac].poy33
                  NEXT FIELD poy33
               END IF
           END IF
 
        BEFORE FIELD poy29
           CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant  #No.FUN-980025
 
        AFTER FIELD poy29
           IF (g_poz.poz00 = '1' AND cl_null(g_poy4[l_ac].poy29)) OR 
              (g_poz.poz00 = '2' AND g_poy4[l_ac].poy02 > 0 AND cl_null(g_poy4[l_ac].poy29)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy4[l_ac].poy29 = g_poy4_t.poy29   #no.TQC-7C0148
               DISPLAY BY NAME g_poy4[l_ac].poy29        #no.TQC-7C0148
               NEXT FIELD poy29
           END IF
           IF NOT cl_null(g_poy4[l_ac].poy29) THEN
              #CALL i000_ocx(g_poy4[l_ac].poy29,l_dbs)
              CALL i000_ocx(g_poy4[l_ac].poy29,l_plant)   #FUN-A50102
                 RETURNING g_poy4[l_ac].occ02
              IF NOT cl_null(g_errno) THEN
                 LET g_poy4[l_ac].poy29 = g_poy4_t.poy29
                 CALL cl_err(g_poy4[l_ac].poy29,g_errno,0)
                 NEXT FIELD poy29
              ELSE
                 DISPLAY g_poy4[l_ac].occ02 TO occ02
              END IF
           ELSE
              LET g_poy4[l_ac].occ02=' '
              DISPLAY g_poy4[l_ac].occ02 TO occ02
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_int_flag = 'Y' #按了放棄鍵 #MOD-570095 add
              LET g_poy4[l_ac].* = g_poy4_t.*
              CLOSE i000_b4_cs
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i000_b4_cs
           COMMIT WORK
           IF NOT cl_null(g_poy4[l_ac].poy02) THEN
              UPDATE poy_file SET poy26= g_poy4[l_ac].poy26,
                                  poy27= g_poy4[l_ac].poy27,
                                  poy33= g_poy4[l_ac].poy33,
                                  poy29= g_poy4[l_ac].poy29
               WHERE poy01 = g_poz.poz01
                 AND poy02 = g_poy4[l_ac].poy02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","poy_file",g_poy4[l_ac].poy02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_poy4[l_ac].* = g_poy4_t.*
                 LET g_success = 'N'
              ELSE
                  MESSAGE 'UPDATE O.K'
              END IF
           END IF
           IF g_success='Y' THEN
              COMMIT WORK
           ELSE
              CALL cl_rbmsg(1)
              ROLLBACK WORK
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(poy27)
                 CALL i000_azp(g_poy[l_ac].poy04) RETURNING l_dbs,l_plant #No.FUN-980025
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_m_tqb" 
                 LET g_qryparam.arg1 = g_poy[l_ac].poy04
                 LET g_qryparam.default1 = g_poy4[l_ac].poy27
                 CALL cl_create_qry() RETURNING g_poy4[l_ac].poy27
                 DISPLAY BY NAME g_poy4[l_ac].poy27
                 NEXT FIELD poy27
              WHEN INFIELD(poy33)
                 CALL q_m_tqa(FALSE,TRUE,g_poy4[l_ac].poy33,g_poy[l_ac].poy04)    #No.FUN-980017
                 RETURNING g_poy4[l_ac].poy33
                 DISPLAY g_poy4[l_ac].poy33 TO poy33
                 NEXT FIELD poy33
               WHEN INFIELD(poy29)
                 CALL q_m_occ(FALSE,TRUE,g_poy4[l_ac].poy29,g_poy[l_ac].poy04)     #No.FUN-980017
                 RETURNING g_poy4[l_ac].poy29
                 DISPLAY g_poy4[l_ac].poy29 TO poy29
                 NEXT FIELD poy29
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   CLOSE WINDOW i000_b4_w
END FUNCTION
 
FUNCTION i000_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON poy02,poy04,poy03,poy05,          #螢幕上取單身條件
                       poy20                             #NO.FUN-670007 add
                       ,poyud01,poyud02,poyud03,poyud04,poyud05
                       ,poyud06,poyud07,poyud08,poyud09,poyud10
                       ,poyud11,poyud12,poyud13,poyud14,poyud15
           FROM s_poy[1].poy02,s_poy[1].poy04,s_poy[1].poy03,
                s_poy[1].poy05,
                s_poy[1].poy20                           #NO.FUN-670007 add
                ,s_poy[1].poyud01,s_poy[1].poyud02,s_poy[1].poyud03
                ,s_poy[1].poyud04,s_poy[1].poyud05,s_poy[1].poyud06
                ,s_poy[1].poyud07,s_poy[1].poyud08,s_poy[1].poyud09
                ,s_poy[1].poyud10,s_poy[1].poyud11,s_poy[1].poyud12
                ,s_poy[1].poyud13,s_poy[1].poyud14,s_poy[1].poyud15
 
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i000_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i000_b_fill(p_wc2)                #BODY FILL UP
DEFINE  p_wc2       LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
DEFINE l_occ02      LIKE occ_file.occ02    #FUN-620025
DEFINE l_dbs        LIKE type_file.chr1000 #No.FUN-680136  VARCHAR(31)            #FUN-620025
DEFINE l_plant      LIKE type_file.chr10   #No.FUN-980025  VARCHAR(10)            #FUN-620025
DEFINE l_plant_s    LIKE type_file.chr10   #No.FUN-980025  VARCHAR(10)            #FUN-620025
 
   LET g_sql = "SELECT poy02,poy04,poy03,' ',poy05,poy20,",
               "       poyud01,poyud02,poyud03,poyud04,poyud05,",
               "       poyud06,poyud07,poyud08,poyud09,poyud10,",
               "       poyud11,poyud12,poyud13,poyud14,poyud15", 
               "  FROM poy_file ",
               " WHERE poy01 ='",g_poz.poz01,"' "  #單頭
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
   END IF 
   LET g_sql=g_sql CLIPPED," ORDER BY poy02 " 
   DISPLAY g_sql
 
   PREPARE i000_pb FROM g_sql
   DECLARE poy_cs                       #SCROLL CURSOR
       CURSOR FOR i000_pb
 
   CALL g_poy.clear()
   LET g_cnt = 1
   FOREACH poy_cs INTO g_poy[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i000_azp(g_poy[g_cnt].poy04) RETURNING g_dbs,l_plant_g   #No.FUN-980025
      #CALL i000_pmc(g_poy[g_cnt].poy03,'e',g_dbs)  RETURNING g_poy[g_cnt].pmc03  #NO.FUN-670007
      CALL i000_pmc(g_poy[g_cnt].poy03,'e',g_poy[g_cnt].poy04)  RETURNING g_poy[g_cnt].pmc03   #FUN-A50102
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_poy.deleteElement(g_cnt)
   LET g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i000_b1_fill(p_wc2)              #BODY FILL UP
DEFINE  p_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
 
   LET g_sql = "SELECT poy02,poy03,'',poy18,poy19,poy12,poy07,poy06,",
               "       poy08,poy09,poy16,poy17,poy46,poy45 ",
               "  FROM poy_file ",
               " WHERE poy01 ='",g_poz.poz01,"' ",  #單頭
               "   AND ", p_wc2 CLIPPED, #單身
               " ORDER BY poy02"
   PREPARE i000_pb1 FROM g_sql
   DECLARE poy_cs1                       #SCROLL CURSOR
       CURSOR FOR i000_pb1
   CALL g_poy1.clear()
   LET g_cnt1 = 1
   FOREACH poy_cs1 INTO g_poy1[g_cnt1].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_poy1[g_cnt1].pmc03 = g_poy[g_cnt1].pmc03
      LET g_cnt1 = g_cnt1 + 1
   END FOREACH
   CALL g_poy1.deleteElement(g_cnt1)
   LET g_rec_b1 = g_cnt1 -1
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i000_b2_fill(p_wc2)               #BODY FILL UP
DEFINE  p_wc2       LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
DEFINE l_occ02      LIKE occ_file.occ02    #FUN-620025
DEFINE l_dbs        LIKE type_file.chr1000 #No.FUN-680136  VARCHAR(31)            #FUN-620025
 
   LET g_sql = "SELECT poy02,poy03,'',poy34,poy35,poy36,poy47,poy48,poy37,poy38,",
               "       poy39,poy40,poy41,poy42,poy43,poy44",
               "  FROM poy_file ",
               " WHERE poy01 ='",g_poz.poz01,"' ",  #單頭
               "   AND ", p_wc2 CLIPPED, #單身
               " ORDER BY poy02"
   PREPARE i000_pb2 FROM g_sql
   DECLARE poy_cs2                       #SCROLL CURSOR
       CURSOR FOR i000_pb2
 
   CALL g_poy2.clear()
   LET g_cnt2 = 1
   FOREACH poy_cs2 INTO g_poy2[g_cnt2].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_poy2[g_cnt2].pmc03 = g_poy[g_cnt2].pmc03
      LET g_cnt2 = g_cnt2 + 1
   END FOREACH
   CALL g_poy2.deleteElement(g_cnt2)
   LET g_rec_b2 = g_cnt2 -1
   LET g_cnt2 = 0
 
END FUNCTION
FUNCTION i000_b3_fill(p_wc2)              #BODY FILL UP
DEFINE  p_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
 
   LET g_sql = "SELECT poy02,poy03,'',poy10,poy11,poy28,poy31,poy30,poy32",
               "  FROM poy_file ",
               " WHERE poy01 ='",g_poz.poz01,"' ",  #單頭
               "   AND ", p_wc2 CLIPPED, #單身
               " ORDER BY poy02"
   PREPARE i000_pb3 FROM g_sql
   DECLARE poy_cs3                       #SCROLL CURSOR
       CURSOR FOR i000_pb3
 
   CALL g_poy3.clear()
   LET g_cnt3 = 1
   FOREACH poy_cs3 INTO g_poy3[g_cnt3].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_poy3[g_cnt3].pmc03 = g_poy[g_cnt3].pmc03
      LET g_cnt3 = g_cnt3 + 1
   END FOREACH
   CALL g_poy3.deleteElement(g_cnt3)
   LET g_rec_b3 = g_cnt3 -1
   LET g_cnt3 = 0
 
 
END FUNCTION
FUNCTION i000_b4_fill(p_wc2)             #BODY FILL UP
DEFINE p_wc2    LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(200)
DEFINE l_occ02  LIKE occ_file.occ02      #FUN-620025
DEFINE l_dbs    LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(31),            #FUN-620025
       l_plant  LIKE type_file.chr10,    #No.FUN-980025 VARCHAR(10),            #FUN-620025
       l_plant_s LIKE type_file.chr10,    #No.FUN-980025 VARCHAR(10),            #FUN-620025
       t_azp03  LIKE azp_file.azp03,
       l_poy02  LIKE poy_file.poy02,
       l_poy04  LIKE poy_file.poy04
 
   LET g_sql = "SELECT poy02,poy03,'',poy26,poy27,'',poy33,poy29,''",
               "  FROM poy_file ",
               " WHERE poy01 ='",g_poz.poz01,"' ",  #單頭
               "   AND ", p_wc2 CLIPPED, #單身
               " ORDER BY poy02"
   PREPARE i000_pb4 FROM g_sql
   DECLARE poy_cs4                       #SCROLL CURSOR
       CURSOR FOR i000_pb4
 
   CALL g_poy4.clear()
   LET g_cnt4 = 1
   FOREACH poy_cs4 INTO g_poy4[g_cnt4].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #IF NOT cl_null(g_poy4[g_cnt4].poy27) THEN
      IF NOT cl_null(g_poy4[g_cnt4].poy27) AND (l_plant <> 'xxx' AND l_plant <> 'yyy') THEN  #FUN-AC0046
         LET g_sql = " SELECT tqb02 ",   		#MOD-960178
                     #"  FROM ",l_dbs CLIPPED,"tqb_file ",
                     "  FROM ",cl_get_target_table(l_plant,'tqb_file'), #FUN-A50102
                     " WHERE tqb01= '",g_poy4[g_cnt4].poy27,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
         PREPARE tqb_p1 FROM g_sql
         IF SQLCA.SQLCODE THEN CALL cl_err('tqb_p1',SQLCA.SQLCODE,1) END IF
         DECLARE tqb_c1 CURSOR FOR tqb_p1
         OPEN tqb_c1
         FETCH tqb_c1 INTO g_poy4[g_cnt4].tqb02 
      END IF
      CALL i000_azp(g_poy[g_cnt4].poy04) RETURNING l_dbs,l_plant   #No.FUN-980025
      #CALL i000_ocx(g_poy4[g_cnt4].poy29,l_dbs)
      CALL i000_ocx(g_poy4[g_cnt4].poy29,l_plant)  #FUN-A50102
         RETURNING l_occ02
      LET g_poy4[g_cnt4].occ02 = l_occ02
      LET g_poy4[g_cnt4].pmc03 = g_poy[g_cnt4].pmc03
      LET g_cnt4 = g_cnt4 + 1
   END FOREACH
   CALL g_poy4.deleteElement(g_cnt4)
   LET g_rec_b4 = g_cnt4 -1
   LET g_cnt4 = 0
 
 
END FUNCTION
 
FUNCTION i000_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_poy TO s_poy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
          IF g_aza.aza50 = 'N' THEN
              CALL cl_set_act_visible("Delivery",FALSE)
          END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
 
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
         CALL i000_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL i000_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i000_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i000_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i000_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION Finance
         LET g_action_choice="Finance"
         EXIT DISPLAY
      ON ACTION Document
         LET g_action_choice="Document"
         EXIT DISPLAY
      ON ACTION Other
         LET g_action_choice="Other"
         EXIT DISPLAY
      ON ACTION Delivery
         LET g_action_choice="Delivery"
         EXIT DISPLAY
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      ON ACTION exporttoexcel     #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #NO.TQC-5B0031
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
         EXIT DISPLAY
 
      &include "qry_string.4gl"
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i000_copy()
DEFINE
    l_n             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    l_newno         LIKE poz_file.poz01,
    l_newno2        LIKE poz_file.poz04,
    l_oldno         LIKE poz_file.poz01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_poz.poz01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
     LET g_before_input_done = FALSE  #No.MOD-480218
     CALL i000_set_entry('a')       #No.MOD-480218
     LET g_before_input_done = TRUE   #No.MOD-480218
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno FROM poz01
 
       AFTER FIELD poz01
          IF cl_null(l_newno) THEN
             NEXT FIELD poz01
          END IF
          SELECT count(*) INTO g_cnt FROM poz_file WHERE poz01 = l_newno
          IF g_cnt > 0 THEN
             CALL cl_err(l_newno,-239,0)
             NEXT FIELD poz01
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
       DISPLAY BY NAME g_poz.poz01
       RETURN
    END IF
 
    DROP TABLE y
 
    SELECT * FROM poz_file WHERE poz01=g_poz.poz01 INTO TEMP y
 
    UPDATE y SET poz01=l_newno,    #新的鍵值
                 pozuser=g_user,   #資料所有者
                 pozgrup=g_grup,   #資料所有者所屬群
                 pozoriu=g_user,    #TQC-A30041 ADD
                 pozorig=g_grup,    #TQC-A30041 add
                 pozmodu=NULL,     #資料修改日期
                 pozdate=g_today,  #資料建立日期
                 pozacti='Y'       #有效資料
 
    INSERT INTO poz_file SELECT * FROM y
 
    DROP TABLE x
 
    SELECT * FROM poy_file WHERE poy01=g_poz.poz01 INTO TEMP x
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x",g_poz.poz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN
    END IF
 
    UPDATE x SET poy01=l_newno
 
    INSERT INTO poy_file SELECT * FROM x
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","poy_file",g_poz.poz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_poz.poz01
    SELECT poz_file.* INTO g_poz.* FROM poz_file
     WHERE poz01 = l_newno
 
    CALL i000_u()
    CALL i000_b()
 
    #SELECT poz_file.* INTO g_poz.* FROM poz_file #FUN-C80046
    # WHERE poz01 = l_oldno                       #FUN-C80046
 
    #CALL i000_show()                             #FUN-C80046
 
END FUNCTION
 
FUNCTION i000_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    #No.TQC-A30046  --Begin
    #IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    #  CALL cl_set_comp_entry("poz01",TRUE)
    #  CALL cl_set_comp_entry("poz00,poz011,poz11",TRUE) #FUN-560041  #FUN-670007
    #END IF
    #IF g_used<>'Y' THEN
    #   CALL cl_set_comp_entry("poz00,poz011,poz11",TRUE)  #NO.FUN-670007
    #END IF
    #CALL cl_set_comp_entry("poz19",TRUE)                            #FUN-870130 Add
    #CALL cl_set_comp_required("poz19",TRUE)                         #FUN-870130 Add
 
    #CALL cl_set_comp_entry("poz12,poz13,poz14",TRUE)
    #CALL cl_set_comp_required("poz13,poz14",TRUE) 
    IF g_azw.azw04 = '2' THEN 
       IF g_poz.poz20='N' THEN
          CALL cl_set_comp_entry("poz20,poz21",TRUE)
          CALL cl_set_comp_required("poz21",FALSE)
       END IF
    END IF
    CALL cl_set_comp_entry("poz01,poz00,poz011,poz12,poz09",TRUE)               
    CALL cl_set_comp_entry("poz11,poz13,poz19,poz14 ",TRUE)   #MOD-A50147 del poz18
    CALL cl_set_comp_required("poz19",TRUE)                         #FUN-870130 Add
    CALL cl_set_comp_required("poz13,poz14",TRUE) 
    #No.TQC-A30046  --End
END FUNCTION
 
FUNCTION i000_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    #No.TQC-A30046  --Begin
    #IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("poz01",FALSE)
    END IF
    #IF g_used='Y'THEN
    #   CALL cl_set_comp_entry("poz00,poz011,poz11",FALSE)  #NO.FUN-670007
    #END IF
    IF g_used='Y'THEN                                                           
       CALL cl_set_comp_entry("poz01,poz00,poz011,poz12,poz09",FALSE)           
       CALL cl_set_comp_entry("poz11,poz13,poz19,poz14 ",FALSE)   #MOD-A50147 del poz18
       CALL cl_set_comp_entry("poz20,poz21",FALSE)           
    END IF
    #No.TQC-A30046  --End  
 
    IF g_poz.poz011 = '1' THEN
        CALL cl_set_comp_entry("poz19",FALSE)   #MOD-A50147 del poz18
        CALL cl_set_comp_required("poz19",FALSE)   #MOD-A50147 del poz18
        LET g_poz.poz19 = ' '
        LET g_poz.poz18 = ' '
        DISPLAY g_poz.poz19 TO poz19
        DISPLAY g_poz.poz18 TO poz18
    END IF
    IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12)) THEN  #TQC-7C0164
        CALL cl_set_comp_entry("poz13,poz14",FALSE)
        CALL cl_set_comp_required("poz13,poz14",FALSE)
        LET g_poz.poz13 = ' '
        LET g_poz.poz14 = ' '
        DISPLAY g_poz.poz13 TO poz13
        DISPLAY g_poz.poz14 TO poz14
    END IF
 
    IF g_poz.poz011 = '2' THEN
       CALL cl_set_comp_required("poz19",TRUE)                 #FUN-870130
       CALL cl_set_comp_entry("poz12,poz13,poz14",FALSE)
       LET g_poz.poz12 = 'N'
       LET g_poz.poz13 = ' '
       LET g_poz.poz14 = ' '
       DISPLAY BY NAME g_poz.poz12,g_poz.poz13,g_poz.poz14
    END IF 
    IF g_azw.azw04 = '2' THEN
       IF g_poz.poz20='Y' THEN
          CALL cl_set_comp_entry("poz21",FALSE)
          CALL cl_set_comp_required("poz21",FALSE)
          LET g_poz.poz21 = ''
          DISPLAY g_poz.poz21 TO poz21
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i000_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF INFIELD(poy04) OR (NOT g_before_input_done) THEN
     IF g_poy[l_ac].poy02 = 99 THEN    
        RETURN
     END IF          
   END IF
   CALL cl_set_comp_entry("poy02,poy04,poy03,poy05,poy20",TRUE)
   CALL cl_set_comp_entry("poz03,poz04",TRUE)     #MOD-BB0274 add
END FUNCTION
 
FUNCTION i000_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF g_used='Y' THEN 
       CALL cl_set_comp_entry("poy02,poy03,poy04",FALSE)  #NO.FUN-670007
    END IF
#TQC-AC0385--add--str--
    IF g_poy[l_ac].poy04 = 'xxx' OR g_poy[l_ac].poy04 = 'yyy' THEN
       CALL cl_set_comp_entry("poy03,poy05",FALSE)
    END IF
#TQC-AC0385--add--end--
    IF g_poy[l_ac].poy02 = 99 THEN                  #MOD-BB0274 add
        CALL cl_set_comp_entry("poy03,poy04",FALSE) #MOD-BB0274 add
    END IF                                          #MOD-BB0274 add
END FUNCTION
 
FUNCTION i000_set_entry_b4()
       CALL cl_set_comp_entry("poy26,poy27,poy33,poy29",TRUE)
END FUNCTION
 
FUNCTION i000_set_no_entry_b4(p_poy26)
DEFINE p_poy26  LIKE poy_file.poy26
 
    IF p_poy26='N' THEN
       CALL cl_set_comp_entry("poy27",FALSE)
    END IF
 
    IF g_used='Y' THEN 
       CALL cl_set_comp_entry("poy29",FALSE)
    END IF
END FUNCTION
 
FUNCTION i000_used()  #判斷流程代碼是否已被使用
DEFINE p_poz00        LIKE poz_file.poz00,
       p_azp   RECORD LIKE azp_file.* 
DEFINE
       l_n     LIKE type_file.num5,     #No.FUN-680136 SMALLINT
       l_used  LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
       l_dbs   LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
       l_sql   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(800)
DEFINE l_poy04 LIKE poy_file.poy04   #FUN-670007
DEFINE l_poy02 LIKE poy_file.poy02   #FUN-670007
DEFINE l_azp03 LIKE azp_file.azp03     #No.TQC-A30042
DEFINE l_tdbs  LIKE type_file.chr21    #No.TQC-A30042
 
   SELECT poz00 INTO p_poz00 FROM poz_file 
      WHERE poz01=g_poz.poz01 

   #No.TQC-A30042  --Begin                                                      
   SELECT poy04 INTO l_poy04 FROM poy_file,poz_file                             
    WHERE poy01 = poz01                                                         
      AND poy01 = g_poz.poz01                                                   
      AND poy02 = (SELECT MIN(poy02) FROM poy_file                              
    WHERE poy01 = g_poz.poz01)                                                  
   IF cl_null(l_poy04) THEN LET l_poy04 = g_plant END IF                        
#FUN-AC0046--add--str---
   IF l_poy04 = 'xxx' OR l_poy04 = 'yyy' THEN
      RETURN  'N '
   END IF
#FUN-AC0046--add--end---
   LET g_plant_new = l_poy04
   CALL s_getdbs()
   LET l_dbs = g_dbs_new
   CALL s_gettrandbs()
   LET l_tdbs= g_dbs_tra
   #No.TQC-A30042  --End       

   IF p_poz00='1' THEN    #銷售
      LET l_sql = " SELECT COUNT(*) ",
                  #"   FROM ",l_tdbs CLIPPED,"oea_file",	#TQC-980124  #No.TQC-A30046
                  "   FROM ",cl_get_target_table(l_poy04,'oea_file'), #FUN-A50102
                  " WHERE oea904 = '",g_poz.poz01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #No.TQC-A30046
      CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql #FUN-A50102
      PREPARE oea_p1 FROM l_sql
      IF SQLCA.SQLCODE THEN CALL cl_err('oea_p1',SQLCA.SQLCODE,1) END IF
      DECLARE oea_c1 CURSOR FOR oea_p1
      OPEN oea_c1
      FETCH oea_c1 INTO l_n
      CLOSE oea_c1 
      IF l_n>0 THEN
         LET l_used = 'Y'
      ELSE
         LET l_used = 'N'
      END IF
   END IF
   IF p_poz00='2' THEN     #采購
      LET l_sql = " SELECT COUNT(*) ",
                  #" FROM ",l_tdbs CLIPPED,"pmm_file",	#TQC-980124  #No.TQC-A30046
                  " FROM ",cl_get_target_table(l_poy04,'pmm_file'), #FUN-A50102
                  " WHERE pmm904 = '",g_poz.poz01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #No.TQC-A30046
      CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql #FUN-A50102
      PREPARE pmm_p1 FROM l_sql
      IF SQLCA.SQLCODE THEN CALL cl_err('pmm_p1',SQLCA.SQLCODE,1) END IF
      DECLARE pmm_c1 CURSOR FOR pmm_p1
      OPEN pmm_c1
      FETCH pmm_c1 INTO l_n
      CLOSE pmm_c1 
      IF l_n>0 THEN
         LET l_used = 'Y'
      ELSE
         LET l_used = 'N'
      END IF
   END IF
   IF p_poz00<>'1' AND p_poz00<>'2' THEN LET l_used = 'N' END IF
   
   RETURN l_used
 
END FUNCTION
 
#FUNCTION i000_azf(p_dbs,p_azf01,p_arg,p_arg1)
FUNCTION i000_azf(l_plant,p_azf01,p_arg,p_arg1)  #FUN-A50102
  DEFINE p_azf01         LIKE azf_file.azf01,     #No.FUN-6B0065
         p_arg           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
         p_arg1          LIKE type_file.chr1,    #No.FUN-930145
         #p_dbs           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(31)
         l_plant         LIKE type_file.chr21,  #FUN-A50102
         l_sql           STRING,
         l_n             LIKE type_file.num5    #No.FUN-680136 SMALLINT
  
  LET l_n =0
 
  #LET l_sql=" SELECT COUNT(*) FROM ",p_dbs CLIPPED,"azf_file ",
LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'azf_file'), #FUN-A50102  
            "  WHERE azf01='",p_azf01,"' AND azf02='",p_arg,"' AND azf09 ='",p_arg1,"' ",#No.FUN-930145
            "    AND azfacti='Y' AND azf10='N'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
  PREPARE i000_prepare_azf FROM l_sql
  DECLARE i000_cs_azf CURSOR FOR i000_prepare_azf
 
  OPEN i000_cs_azf
  FETCH i000_cs_azf INTO l_n
  IF STATUS THEN
     LET l_n=0
     CALL cl_err('',STATUS,0)
  END IF
  CLOSE i000_cs_azf     #No.FUN-6B0065
  RETURN l_n
   
 
END FUNCTION
#FUNCTION i000_oom(p_key,p_dbs)  #發票別
FUNCTION i000_oom(p_key,l_plant)  #發票別  #FUN-A50102
    DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           #p_key      LIKE nmo_file.nmo01,   #MOD-B80187 mark
           p_key      LIKE oom_file.oom03,    #MOD-B80187 add
           #p_dbs      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(31)
           l_plant         LIKE type_file.chr21,  #FUN-A50102
           l_sql           STRING,
           l_oom_cnt       LIKE type_file.num5
 
    LET g_errno = ' '
    #LET l_sql=" SELECT COUNT(*) FROM ",p_dbs CLIPPED,"oom_file ", 
   LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'oom_file'), #FUN-A50102
              "  WHERE oom03 = '",p_key,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
    PREPARE i000_prepare_oom FROM l_sql
    DECLARE i000_cs_oom CURSOR FOR i000_prepare_oom
    OPEN i000_cs_oom
    FETCH i000_cs_oom INTO l_oom_cnt
    CASE WHEN l_oom_cnt= 0 LET g_errno = 'apm1012'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#FUNCTION i000_nmo(p_key,p_dbs)  #票別
FUNCTION i000_nmo(p_key,l_plant)  #票別  #FUN-A50102
    DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           p_key      LIKE nmo_file.nmo01,
           #p_dbs      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(31)
           l_plant         LIKE type_file.chr21,  #FUN-A50102
           l_sql           STRING,
           l_nmoacti  LIKE nmo_file.nmoacti
 
    LET g_errno = ' '
    #LET l_sql=" SELECT nmoacti FROM ",p_dbs CLIPPED,"nmo_file ", 
   LET l_sql=" SELECT nmoacti FROM ",cl_get_target_table(l_plant,'nmo_file'), #FUN-A50102 
              "  WHERE nmo01 = '",p_key,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
    PREPARE i000_prepare_nmo FROM l_sql
    DECLARE i000_cs_nmo CURSOR FOR i000_prepare_nmo
    OPEN i000_cs_nmo
    FETCH i000_cs_nmo INTO l_nmoacti
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-086'
         WHEN l_nmoacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i100_b1_input(l_ac)
DEFINE l_poy02_3    LIKE poy_file.poy04,
       l_poy02_4    LIKE poy_file.poy04,
       l_ac         LIKE type_file.num5,
       l_dbs        LIKE type_file.chr21,              
       l_plant      LIKE type_file.chr10,  #No.FUN-980025
       l_plant_s    LIKE type_file.chr10,  #No.FUN-980025
       l_dbs_s      LIKE type_file.chr21,              
       l_dbs2       LIKE type_file.chr21,
       li_result    LIKE type_file.num5
DEFINE  lg_smy62    LIKE smy_file.smy62
DEFINE  lg_oay22    LIKE oay_file.oay22
DEFINE  lg_smy621     LIKE smy_file.smy62                                                                                           
DEFINE  lg_smy622     LIKE smy_file.smy62        
 
    LET p_row = 14 LET p_col = 21
    OPEN WINDOW i000_b1_1_w AT p_row,p_col WITH FORM "apm/42f/apmi000_b1_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("apmi000_b1_1")
    LET g_success='Y'
    
    IF g_poy2[l_ac].poy02 = 99 THEN	
          CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs,l_plant #No.FUN-980025      
    ELSE
          CALL i000_azp(g_poy[l_ac].poy04)   RETURNING l_dbs,l_plant #No.FUN-980025
    END IF
    LET l_dbs_s = NULL   #MOD-A50033
    LET l_plant_s = NULL #MOD-A50033
    IF g_poy2[l_ac].poy02 > 0 AND g_poy2[1].poy02 = 0 THEN
          CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs_s,l_plant_s #No.FUN-980025 
    END IF
    
    IF g_poy[l_ac].poy02 = 0 THEN 
       LET l_poy02_3 = ' '
       LET l_poy02_4 = g_poy[l_ac].poy04
    ELSE 
    	 LET l_poy02_3 = g_poy[l_ac-1].poy04
       LET l_poy02_4 = g_poy[l_ac].poy04 
    END IF 
         
    DISPLAY g_poy1[l_ac].poy02,g_poy1[l_ac].poy03,g_poy1[l_ac].pmc03,
            l_poy02_3,l_poy02_4,
            g_poy1[l_ac].poy18,g_poy1[l_ac].poy19,g_poy1[l_ac].poy12,
            g_poy1[l_ac].poy07,g_poy1[l_ac].poy06,g_poy1[l_ac].poy08,
            g_poy1[l_ac].poy09,g_poy1[l_ac].poy16,g_poy1[l_ac].poy17,
            g_poy1[l_ac].poy46,g_poy1[l_ac].poy45 
            TO poy02_2,poy03_2,pmc03_2,poy02_3,poy02_4,poy18,poy19,poy12,poy07,poy06,
            poy08,poy09,poy16,poy17,poy46,poy45
            
    INPUT BY NAME g_poy1[l_ac].poy18,g_poy1[l_ac].poy19,g_poy1[l_ac].poy12,
          g_poy1[l_ac].poy07,g_poy1[l_ac].poy06,g_poy1[l_ac].poy08,
          g_poy1[l_ac].poy09,g_poy1[l_ac].poy16,g_poy1[l_ac].poy17,
          g_poy1[l_ac].poy46,g_poy1[l_ac].poy45
          WITHOUT DEFAULTS 
       
     
        AFTER FIELD poy06   #付款方式
           IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  
              IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy06) AND g_poy1[l_ac].poy02 <> 0) OR  
                 (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy06)) THEN    
                  CALL cl_err('','agl-154',0)
                  LET g_poy1[l_ac].poy06 = g_poy1_t.poy06   
                  DISPLAY BY NAME g_poy1[l_ac].poy06      
                  NEXT FIELD poy06
              END IF
           END IF   
 
           IF NOT cl_null(g_poy1[l_ac].poy06) THEN 
              #CALL i000_pma(g_poy1[l_ac].poy06,l_dbs_s)
              CALL i000_pma(g_poy1[l_ac].poy06,l_plant_s)     #FUN-A50102  
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy06 = g_poy1_t.poy06
                 DISPLAY BY NAME g_poy1[l_ac].poy06
                 CALL cl_err(l_dbs_s,g_errno,0)   #MOD-950103 add
                 NEXT FIELD poy06
              END IF
           END IF
 
        AFTER FIELD poy07   #收款條件
           #IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy07)) OR    #MOD-A80171
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy07) AND g_poy1[l_ac].poy02 <> 0) OR  #MOD-A80171
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy07)) THEN  
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy07 = g_poy1_t.poy07    
               DISPLAY BY NAME g_poy1[l_ac].poy07         
               NEXT FIELD poy07
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy07) THEN
             #CALL i000_oag(g_poy1[l_ac].poy07,l_dbs)
             CALL i000_oag(g_poy1[l_ac].poy07,l_plant)   #FUN-A50102
             IF NOT cl_null(g_errno) THEN
                LET g_poy1[l_ac].poy07 = g_poy1_t.poy07
                DISPLAY BY NAME g_poy1[l_ac].poy07
                CALL cl_err(l_dbs,g_errno,0)
                NEXT FIELD poy07
             END IF
           END IF
 
        AFTER FIELD poy08   #稅別
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy08) AND g_poy1[l_ac].poy02 <> 0 ) OR   
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy08)) THEN   
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy08 = g_poy1_t.poy08   
               DISPLAY BY NAME g_poy1[l_ac].poy08        
               NEXT FIELD poy08
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy08) THEN
              #CALL i000_gec(g_poy1[l_ac].poy08,'2',l_dbs)
              CALL i000_gec(g_poy1[l_ac].poy08,'2',l_plant) #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy08 = g_poy1_t.poy08
                 DISPLAY BY NAME g_poy1[l_ac].poy08
                 CALL cl_err(l_dbs,g_errno,0)
                 NEXT FIELD poy08
              END IF
           END IF
 
        AFTER FIELD poy09   #稅別                                  
         IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy09) AND g_poy1[l_ac].poy02 <> 0) OR  
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy09)) THEN 
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy09 = g_poy1_t.poy09  
               DISPLAY BY NAME g_poy1[l_ac].poy09       
               NEXT FIELD poy09
           END IF
         END IF 
           IF NOT cl_null(g_poy1[l_ac].poy09) THEN   
              #CALL i000_gec(g_poy1[l_ac].poy09,'1',l_dbs_s)
             CALL i000_gec(g_poy1[l_ac].poy09,'1',l_plant_s)  #FUN-A50102 
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy09 = g_poy1_t.poy09
                 DISPLAY BY NAME g_poy1[l_ac].poy09
                 CALL cl_err(l_dbs_s,g_errno,0) #MOD-950103 add
                 NEXT FIELD poy09
              END IF
           END IF
 
           BEFORE FIELD poy12
               IF cl_null(g_poy1[l_ac].poy12) THEN
                   LET g_poy1[l_ac].poy12 = '1'
               END IF
 
        AFTER FIELD poy12  #票別
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy12)) OR 
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy12)) THEN   
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy12 = g_poy1_t.poy12  
               DISPLAY BY NAME g_poy1[l_ac].poy12         
               NEXT FIELD poy12
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy12) THEN
              #CALL i000_oom(g_poy1[l_ac].poy12,l_dbs)
           CALL i000_oom(g_poy1[l_ac].poy12,l_plant)  #FUN-A50102   
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy12 = g_poy1_t.poy12
                 DISPLAY BY NAME g_poy1[l_ac].poy12
                 CALL cl_err(l_dbs,g_errno,0)
                 NEXT FIELD poy12
              END IF
           END IF
 
        AFTER FIELD poy16   #AR類別
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy16)) OR 
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy16)) THEN   
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy16 = g_poy1_t.poy16   
               DISPLAY BY NAME g_poy1[l_ac].poy16        
               NEXT FIELD poy16
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy16) THEN
              #CALL i000_ool(g_poy1[l_ac].poy16,l_dbs)
              CALL i000_ool(g_poy1[l_ac].poy16,l_plant)   #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy16 = g_poy1_t.poy16
                 DISPLAY BY NAME g_poy1[l_ac].poy16
                 CALL cl_err(l_dbs,g_errno,0)
                 NEXT FIELD poy16
              END IF
           END IF
 
        AFTER FIELD poy17   #AP類別                                
         IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy17) AND g_poy1[l_ac].poy02 <> 0) OR  
              (g_poz.poz00 = '2' AND g_poy1[l_ac].poy02 > 0 AND cl_null(g_poy1[l_ac].poy17)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy17 = g_poy1_t.poy17    
               DISPLAY BY NAME g_poy1[l_ac].poy17        
               NEXT FIELD poy17
           END IF
         END IF 
           IF NOT cl_null(g_poy1[l_ac].poy17) THEN  
              #CALL i000_apr(g_poy1[l_ac].poy17,l_dbs_s)
              CALL i000_apr(g_poy1[l_ac].poy17,l_plant_s)   #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy17 = g_poy1_t.poy17
                 DISPLAY BY NAME g_poy1[l_ac].poy17
                 CALL cl_err(l_dbs_s,g_errno,0) #MOD-950103 add
                 NEXT FIELD poy17
              END IF
           END IF
 
        AFTER FIELD poy18   #AR部門
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy18)) OR 
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy18)) THEN   
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy18 = g_poy1_t.poy18 
               DISPLAY BY NAME g_poy1[l_ac].poy18      
               NEXT FIELD poy18
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy18) THEN
              #CALL i000_gem(g_poy1[l_ac].poy18,l_dbs)
              CALL i000_gem(g_poy1[l_ac].poy18,l_plant)  #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_dbs,g_errno,0)
                 LET g_poy1[l_ac].poy18 = g_poy1_t.poy18
                 DISPLAY BY NAME g_poy1[l_ac].poy18
                 NEXT FIELD poy18
              END IF
           END IF
 
        AFTER FIELD poy19   #AP部門
         IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy19) AND g_poy1[l_ac].poy02 <> 0 ) OR   
              (g_poz.poz00 = '2' AND g_poy1[l_ac].poy02 > 0 AND cl_null(g_poy1[l_ac].poy19)) THEN
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy19 = g_poy1_t.poy19   
               DISPLAY BY NAME g_poy1[l_ac].poy19         
               NEXT FIELD poy19
           END IF
         END IF   
 
           IF NOT cl_null(g_poy1[l_ac].poy19) THEN    
              #CALL i000_gem(g_poy1[l_ac].poy19,l_dbs_s)
              CALL i000_gem(g_poy1[l_ac].poy19,l_plant_s)    #FUN-A50102   
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy19 = g_poy1_t.poy19
                 DISPLAY BY NAME g_poy1[l_ac].poy19
                 CALL cl_err(l_dbs_s,g_errno,0)  #MOD-950103 add
                 NEXT FIELD poy19
              END IF
           END IF
 
        AFTER FIELD poy46  #採購成本中心                                        
         IF NOT cl_null(g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN 
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy46) AND g_poy1[l_ac].poy02 <> 0) OR   
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy46)) THEN  
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy46 = g_poy1_t.poy46       
               DISPLAY BY NAME g_poy1[l_ac].poy46             
               NEXT FIELD poy46
           END IF
         END IF 
           IF NOT cl_null(g_poy1[l_ac].poy46) THEN
           #  CALL i000_poy_gem(g_poy1[l_ac].poy46,l_plant_s)    #MOD-9C0168  #No.FUN-A10099
              #CALL i000_poy_gem(g_poy1[l_ac].poy46,l_dbs_s)      #MOD-9C0168  #No.FUN-A10099
              CALL i000_poy_gem(g_poy1[l_ac].poy46,l_plant_s)      #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy46 = g_poy1_t.poy46
                 CALL cl_err(l_dbs,g_errno,0)
                 DISPLAY BY NAME g_poy1[l_ac].poy46
                 NEXT FIELD poy46
              END IF
           END IF
 
        AFTER FIELD poy45  #訂單成本中心
           IF (g_poz.poz00 = '1' AND cl_null(g_poy1[l_ac].poy45) AND g_poy1[l_ac].poy02 <> 0) OR 
              (g_poz.poz00 = '2' AND ( g_poy1[l_ac].poy02 > 0 AND g_poy1[l_ac].poy02 <> 99 ) AND cl_null(g_poy1[l_ac].poy45)) THEN  
               CALL cl_err('','agl-154',0)
               LET g_poy1[l_ac].poy45 = g_poy1_t.poy45    
               DISPLAY BY NAME g_poy1[l_ac].poy45        
               NEXT FIELD poy45
           END IF
           IF NOT cl_null(g_poy1[l_ac].poy45) THEN  
              #CALL i000_poy_gem(g_poy1[l_ac].poy45,l_dbs)     #MOD-950103 add 
              CALL i000_poy_gem(g_poy1[l_ac].poy45,l_plant)      #FUN-A50102
              IF NOT cl_null(g_errno) THEN
                 LET g_poy1[l_ac].poy45 = g_poy1_t.poy45
                 CALL cl_err(l_dbs,g_errno,0)
                 DISPLAY BY NAME g_poy1[l_ac].poy45
                 NEXT FIELD poy45
              END IF
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(poy06)
                 CALL q_m_pma(FALSE,TRUE,g_poy1[l_ac].poy06,l_plant_s)            #No.FUN-980017      #MOD-9C0168
                 RETURNING g_poy1[l_ac].poy06
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy06) THEN 
                    LET g_poy1[l_ac].poy06 = g_poy1_t.poy06
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy06 TO poy06
                 NEXT FIELD poy06
              WHEN INFIELD(poy07)
                 CALL q_m_oag(FALSE,TRUE,g_poy1[l_ac].poy07,g_poy[l_ac].poy04)  #No.FUN-980017  
                 RETURNING g_poy1[l_ac].poy07
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy07) THEN 
                    LET g_poy1[l_ac].poy07 = g_poy1_t.poy07
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy07 TO poy07
                 NEXT FIELD poy07
              WHEN INFIELD(poy08)
                 CALL q_m_gec(FALSE,TRUE,g_poy1[l_ac].poy08,'2',l_plant)    #FUN-990069
                 RETURNING g_poy1[l_ac].poy08
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy08) THEN 
                    LET g_poy1[l_ac].poy08 = g_poy1_t.poy08
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy08 TO poy08
                 NEXT FIELD poy08
              WHEN INFIELD(poy09)
                 CALL q_m_gec(FALSE,TRUE,g_poy1[l_ac].poy09,'1',l_plant_s) #FUN-990069
                 RETURNING g_poy1[l_ac].poy09
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy09) THEN 
                    LET g_poy1[l_ac].poy09 = g_poy1_t.poy09
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy09 TO poy09
                 NEXT FIELD poy09
             WHEN INFIELD(poy12)
                  CALL q_m_oom(FALSE,TRUE,g_poy1[l_ac].poy12,g_poy[l_ac].poy04)   #No.FUN-980017
                  RETURNING g_poy1[l_ac].poy12
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy12) THEN 
                    LET g_poy1[l_ac].poy12 = g_poy1_t.poy12
                 END IF    
                 #TQC-D40028 add end                  
                  DISPLAY BY NAME g_poy1[l_ac].poy12
                  NEXT FIELD poy12
              WHEN INFIELD(poy16)   
                 CALL q_m_ool(FALSE,TRUE,g_poy1[l_ac].poy16,g_poy[l_ac].poy04)    #No.FUN-980017
                 RETURNING g_poy1[l_ac].poy16
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy16) THEN 
                    LET g_poy1[l_ac].poy16 = g_poy1_t.poy16
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy16 TO poy16
                 NEXT FIELD poy16
              WHEN INFIELD(poy17)
                 CALL q_m_apr(FALSE,TRUE,g_poy1[l_ac].poy17,l_plant_s)  #FUN-990069
                 RETURNING g_poy1[l_ac].poy17
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy17) THEN 
                    LET g_poy1[l_ac].poy17 = g_poy1_t.poy17
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy17 TO poy17
                 NEXT FIELD poy17
              WHEN INFIELD(poy18)
                 CALL q_m_gem(FALSE,TRUE,g_poy1[l_ac].poy18,l_plant) #FUN-990069
                 RETURNING g_poy1[l_ac].poy18
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy18) THEN 
                    LET g_poy1[l_ac].poy18 = g_poy1_t.poy18
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy18 TO poy18
                 NEXT FIELD poy18
              WHEN INFIELD(poy19)
                 CALL q_m_gem(FALSE,TRUE,g_poy1[l_ac].poy19,l_plant_s) #FUN-990069
                 RETURNING g_poy1[l_ac].poy19
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy19) THEN 
                    LET g_poy1[l_ac].poy19 = g_poy1_t.poy19
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy19 TO poy19
                 NEXT FIELD poy19
              WHEN INFIELD(poy45)
                 CALL q_m_gem(FALSE,TRUE,g_poy1[l_ac].poy45,l_plant)     #FUN-990069
                 RETURNING g_poy1[l_ac].poy45
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy45) THEN 
                    LET g_poy1[l_ac].poy45 = g_poy1_t.poy45
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy45 TO poy45
                 NEXT FIELD poy45
              WHEN INFIELD(poy46)
                 CALL q_m_gem(FALSE,TRUE,g_poy1[l_ac].poy46,l_plant_s)   #FUN-990069     #MOD-9C0168
                 RETURNING g_poy1[l_ac].poy46
                 #TQC-D40028 add begin
                 IF cl_null(g_poy1[l_ac].poy46) THEN 
                    LET g_poy1[l_ac].poy46 = g_poy1_t.poy46
                 END IF    
                 #TQC-D40028 add end                 
                 DISPLAY g_poy1[l_ac].poy46 TO poy46
                 NEXT FIELD poy46
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON ACTION about        
          CALL cl_about()    
 
        ON ACTION help        
          CALL cl_show_help()
 
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
      CLOSE WINDOW i000_b1_1_w    
END FUNCTION 
 
	FUNCTION i100_b2_input(l_ac)
	DEFINE l_poy02_3    LIKE poy_file.poy04,
	       l_poy02_4    LIKE poy_file.poy04,
	       l_ac         LIKE type_file.num5,
	       l_dbs        LIKE type_file.chr21,              
	       l_plant      LIKE type_file.chr10,  #No.FUN-980025
	       l_plant_s    LIKE type_file.chr10,  #No.FUN-980025
	       l_dbs_s      LIKE type_file.chr21,              
	       l_dbs2       LIKE type_file.chr21,
	       li_result    LIKE type_file.num5
	DEFINE  lg_smy62    LIKE smy_file.smy62
	DEFINE  lg_oay22    LIKE oay_file.oay22
	DEFINE  lg_smy621     LIKE smy_file.smy62                                                                                           
	DEFINE  lg_smy622     LIKE smy_file.smy62        
 
	    LET p_row = 14 LET p_col = 21
	    OPEN WINDOW i000_b2_1_w AT p_row,p_col WITH FORM "apm/42f/apmi000_b2_1"
	       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
	    CALL cl_ui_locale("apmi000_b2_1")
	    LET g_success='Y'
	    
	    IF g_poy2[l_ac].poy02 = 99 THEN	
		  CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs,l_plant #No.FUN-980025
	    ELSE
		  CALL i000_azp(g_poy[l_ac].poy04)   RETURNING l_dbs,l_plant #No.FUN-980025
	    END IF
            LET l_dbs_s = NULL   #MOD-A50033
            LET l_plant_s = NULL #MOD-A50033
	    IF g_poy2[l_ac].poy02 > 0 AND g_poy2[1].poy02 = 0 THEN
		  CALL i000_azp(g_poy[l_ac-1].poy04) RETURNING l_dbs_s,l_plant_s #No.FUN-980025
	    END IF
	    
	    IF g_poy[l_ac].poy02 = 0 THEN 
	       LET l_poy02_3 = ' '
	       LET l_poy02_4 = g_poy[l_ac].poy04
	    ELSE 
		 LET l_poy02_3 = g_poy[l_ac-1].poy04
	       LET l_poy02_4 = g_poy[l_ac].poy04 
	    END IF 
		 
	    DISPLAY g_poy2[l_ac].poy02,g_poy2[l_ac].poy03,g_poy2[l_ac].pmc03,
		    l_poy02_3,l_poy02_4 ,
		    g_poy2[l_ac].poy35,g_poy2[l_ac].poy34,g_poy2[l_ac].poy37,
		    g_poy2[l_ac].poy36,g_poy2[l_ac].poy38,g_poy2[l_ac].poy47,
		    g_poy2[l_ac].poy48,                                     #No.FUN-8C0125
		    g_poy2[l_ac].poy40,g_poy2[l_ac].poy39,g_poy2[l_ac].poy42,
		    g_poy2[l_ac].poy41,g_poy2[l_ac].poy44,g_poy2[l_ac].poy43
		    TO poy02_2,poy03_2,pmc03_2,poy02_3,poy02_4,poy35,poy34,
		    poy37,poy36,poy38,poy47,poy48,poy40,poy39,poy42,poy41,poy44,poy43
 
		    
	    INPUT BY NAME g_poy2[l_ac].poy35,g_poy2[l_ac].poy34,g_poy2[l_ac].poy37,
		  g_poy2[l_ac].poy36,g_poy2[l_ac].poy38,g_poy2[l_ac].poy47,
		  g_poy2[l_ac].poy48,                                     #No.FUN-8C0125
		  g_poy2[l_ac].poy40,g_poy2[l_ac].poy39,g_poy2[l_ac].poy42,
		  g_poy2[l_ac].poy41,g_poy2[l_ac].poy44,g_poy2[l_ac].poy43
		  WITHOUT DEFAULTS 
            BEFORE INPUT
                  SELECT * INTO g_oax.* FROM oax_file WHERE oax00='0'  #No.FUN-8C0125
                  CALL cl_set_comp_entry("poy48",TRUE)
                  IF g_oax.oax04 = 'N' OR cl_null(g_oax.oax04) THEN
                     CALL cl_set_comp_entry("poy48",FALSE)
                  END IF
	     
	     AFTER FIELD poy34 
	      IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy34) AND g_poy2[l_ac].poy02 <>0 ) OR   
		 (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy34) AND g_poy2[l_ac].poy02 <> 99 ) THEN  
		 CALL cl_err('','agl-154',0) 
		 LET g_poy2[l_ac].poy34 = g_poy2_t.poy34   
		 DISPLAY BY NAME g_poy2[l_ac].poy34        
		 NEXT FIELD poy34
	      END IF
	      IF NOT cl_null(g_poy2[l_ac].poy34) THEN
                 CALL s_check_no("axm",g_poy2[l_ac].poy34,g_poy2_t.poy34,"30","","",l_plant) #TQC-9B0162
		   RETURNING li_result,g_poy2[l_ac].poy34
		 CALL s_get_doc_no(g_poy2[l_ac].poy34) RETURNING g_poy2[l_ac].poy34
		 DISPLAY BY NAME g_poy2[l_ac].poy34
		 IF (NOT li_result) THEN
		    LET g_poy2[l_ac].poy34 = g_poy2_t.poy34 
		 DISPLAY BY NAME g_poy2[l_ac].poy34
		 NEXT FIELD poy34
		 END IF
	      END IF
	      IF NOT cl_null(g_poy2[l_ac].poy34) THEN
		 IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN 
		    #CALL i000_oay(g_poy2[l_ac].poy34,l_dbs) RETURNING lg_oay22
            CALL i000_oay(g_poy2[l_ac].poy34,l_plant) RETURNING lg_oay22  #FUN-A50102
		    IF NOT cl_null(g_poy2[l_ac].poy35) THEN
		       IF g_poy[l_ac].poy02 > 0 AND g_poy[1].poy02 = 0 THEN
			  #CALL i000_smy(g_poy2[l_ac].poy35,l_dbs) RETURNING lg_smy62
              CALL i000_smy(g_poy2[l_ac].poy35,l_plant) RETURNING lg_smy62  #FUN-A50102
		       ELSE
			  #CALL i000_smy(g_poy2[l_ac].poy35,l_dbs_s) RETURNING lg_smy62  
              CALL i000_smy(g_poy2[l_ac].poy35,l_plant_s) RETURNING lg_smy62    #FUN-A50102
	　　　　　　　  END IF
		       IF lg_oay22 <> lg_smy62 THEN
			  CALL cl_err(g_poy2[l_ac].poy34,'axm-058',0)
			  IF g_chkey = 'Y' THEN
			     LET g_poy2[l_ac].poy34 = g_poy2_t.poy34
			     DISPLAY BY NAME g_poy2[l_ac].poy34
			     NEXT FIELD poy34
			  ELSE 
			     LET g_poy2[l_ac].poy34 = g_poy2_t.poy34
			     DISPLAY BY NAME g_poy2[l_ac].poy34
			     NEXT FIELD poy35
			  END IF
			END IF
			IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR
			   (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN
			   CALL cl_err(g_poy2[l_ac].poy34,'axm-058',0)
			   IF g_chkey = 'Y' THEN
			      LET g_poy2[l_ac].poy34 = g_poy2_t.poy34
			      DISPLAY BY NAME g_poy2[l_ac].poy34
			      NEXT FIELD poy34
			   ELSE
			      LET g_poy2[l_ac].poy34 = g_poy2_t.poy34
			      DISPLAY BY NAME g_poy2[l_ac].poy34
			      NEXT FIELD poy35
			   END IF
		       END IF
		    END IF
		  ELSE
		       LET lg_oay22 = ''
		  END IF
		 END IF
 
	       AFTER FIELD poy35                                
		IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  
		 IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy35) AND g_poy2[l_ac].poy02 <> 0) OR    
		    (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy35)) THEN
		     CALL cl_err('','agl-154',0)
		     LET g_poy2[l_ac].poy35 = g_poy2_t.poy35    
		     DISPLAY BY NAME g_poy2[l_ac].poy35        
		     NEXT FIELD poy35
		 END IF
		END IF  
 
		 IF NOT cl_null(g_poy2[l_ac].poy35) THEN
		      #採購單資料要檢查是否存在上一站資料庫
		       CALL s_check_no("apm",g_poy2[l_ac].poy35,g_poy2_t.poy35,"2","","",l_plant_s) #TQC-9B0162  
		       RETURNING li_result,g_poy2[l_ac].poy35
		    CALL s_get_doc_no(g_poy2[l_ac].poy35) RETURNING g_poy2[l_ac].poy35
		    DISPLAY BY NAME g_poy2[l_ac].poy35
		    IF (NOT li_result) THEN
			LET g_poy2[l_ac].poy35 = g_poy2_t.poy35 
			DISPLAY BY NAME g_poy2[l_ac].poy35
			NEXT FIELD poy35
		    END IF
		    IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN 
			   #CALL i000_smy(g_poy2[l_ac].poy35,l_dbs_s) RETURNING lg_smy62 
               CALL i000_smy(g_poy2[l_ac].poy35,l_plant_s) RETURNING lg_smy62  #FUN-A50102
		       IF NOT cl_null(g_poy2[l_ac].poy34) THEN
			  #CALL i000_oay(g_poy2[l_ac].poy34,l_dbs) RETURNING lg_oay22
              CALL i000_oay(g_poy2[l_ac].poy34,l_plant) RETURNING lg_oay22  #FUN-A50102
			  IF lg_oay22 <> lg_smy62 THEN
			     CALL cl_err(g_poy2[l_ac].poy35,'axm-058',0)
			     LET g_poy2[l_ac].poy35 = g_poy2_t.poy35
			     DISPLAY BY NAME g_poy2[l_ac].poy35
			     NEXT FIELD poy35
			  END IF
			  IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR
			     (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN
			     CALL cl_err(g_poy2[l_ac].poy34,'axm-058',0)
			     LET g_poy2[l_ac].poy35 = g_poy2_t.poy35
			     DISPLAY BY NAME g_poy2[l_ac].poy35
			     NEXT FIELD poy35
			  END IF
		       END IF
		    ELSE
		       LET lg_smy62 = ''
		    END IF
		 END IF
 
		AFTER FIELD poy36                        
		 IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy36)) OR 
		    (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy36) AND g_poy2[l_ac].poy02 <> 99) THEN  #MOD-810056 modify
		     CALL cl_err('','agl-154',0)
		     LET g_poy2[l_ac].poy36  = g_poy2_t.poy36    
		     DISPLAY BY NAME g_poy2[l_ac].poy36         
		     NEXT FIELD poy36
		 END IF
		    IF g_poy2[l_ac].poy36 IS NOT NULL THEN
		       CALL s_check_no('axm',g_poy2[l_ac].poy36,g_poy2_t.poy36,"50","","",l_plant) #TQC-9B0162
			 RETURNING li_result,g_poy2[l_ac].poy36
		       CALL s_get_doc_no(g_poy2[l_ac].poy36) RETURNING g_poy2[l_ac].poy36
		       DISPLAY BY NAME g_poy2[l_ac].poy36
		       IF (NOT li_result) THEN
			  LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
			  DISPLAY BY NAME g_poy2[l_ac].poy36
			  NEXT FIELD poy36
		       END IF
		       IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                   
			  #CALL i000_oay(g_poy2[l_ac].poy36,l_dbs) RETURNING lg_oay22
              CALL i000_oay(g_poy2[l_ac].poy36,l_plant) RETURNING lg_oay22  #FUN-A50102
			  IF NOT cl_null(g_poy2[l_ac].poy37) THEN                                                                               
			     IF g_poy[l_ac].poy02 > 0 AND g_poy[1].poy02 = 0 THEN
				 #CALL i000_smy(g_poy2[l_ac].poy37,l_dbs) RETURNING lg_smy62
                 CALL i000_smy(g_poy2[l_ac].poy37,l_plant) RETURNING lg_smy62  #FUN-A50102
			     ELSE
				 #CALL i000_smy(g_poy2[l_ac].poy37,l_dbs_s) RETURNING lg_smy62 
                CALL i000_smy(g_poy2[l_ac].poy37,l_plant_s) RETURNING lg_smy62    #FUN-A50102 
			     END IF
			     IF lg_oay22 <> lg_smy621 THEN                                                                                      
				CALL cl_err(g_poy2[l_ac].poy36,'axm-046',0)                                                                     
				IF g_chkey = 'Y' THEN
				   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
				   DISPLAY BY NAME g_poy2[l_ac].poy36
				   NEXT FIELD poy36 
				ELSE 
				   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
				   DISPLAY BY NAME g_poy2[l_ac].poy36
				   NEXT FIELD poy37
				END IF                                                                                              
			     END IF                                                                                                            
			     IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy621)) OR                                                               
				(NOT cl_null(lg_oay22) AND cl_null(lg_smy621)) THEN                                                             
				CALL cl_err(g_poy2[l_ac].poy36,'axm-046',0)                                                                     
				IF g_chkey = 'Y' THEN
				   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
				   DISPLAY BY NAME g_poy2[l_ac].poy36
				   NEXT FIELD poy36                                                                                               
				ELSE
				   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
				   DISPLAY BY NAME g_poy2[l_ac].poy36
				   NEXT FIELD poy37
				END IF
			     END IF                                                                                                            
			  END IF                                                                                                               
			  IF NOT cl_null(g_poy2[l_ac].poy38) THEN                                                                               
			     SELECT smy62 INTO lg_smy622 FROM smy_file 
			      WHERE smyslip = g_poy2[l_ac].poy38                                           
			     IF lg_oay22 <> lg_smy622 THEN                                                                                      
				CALL cl_err(g_poy2[l_ac].poy36,'axm-046',0)                                                                     
				IF g_chkey = 'Y' THEN
				   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
				   DISPLAY BY NAME g_poy2[l_ac].poy36
				   NEXT FIELD poy36                                                                                               
				ELSE 
				   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
				   DISPLAY BY NAME g_poy2[l_ac].poy36
				   NEXT FIELD poy38
				END IF
			     END IF                                                                                                            
			     IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy622)) OR                                                               
				(NOT cl_null(lg_oay22) AND cl_null(lg_smy622)) THEN                                                             
				CALL cl_err(g_poy2[l_ac].poy36,'axm-046',0)                                                                     
				IF g_chkey = 'Y' THEN
				   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
				   DISPLAY BY NAME g_poy2[l_ac].poy36
				   NEXT FIELD poy36                                                                                               
				ELSE
				   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36
				   DISPLAY BY NAME g_poy2[l_ac].poy36
				   NEXT FIELD poy38
				END IF
			     END IF                                                                                                            
			  END IF                                                                                                               
		       ELSE                                                                                                                    
			  LET lg_oay22 = ''                                                                                                    
		       END IF                                                                                                                  
		    END IF
 
		AFTER FIELD poy37                                 
		IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12)) THEN 
		 IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy37) AND g_poy2[l_ac].poy02 <> 0) OR  
		    (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy37) AND g_poy2[l_ac].poy02 <> 99) OR 
		    (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy37) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN 
		     CALL cl_err('','agl-154',0)
		     LET g_poy2[l_ac].poy37 = g_poy2_t.poy37  
		     DISPLAY BY NAME g_poy2[l_ac].poy37        
		     NEXT FIELD poy37
		 END IF
		END IF  
		   IF NOT cl_null(g_poy2[l_ac].poy37) THEN
                         CALL s_check_no("apm",g_poy2[l_ac].poy37,g_poy2_t.poy37,"3","","",l_plant_s)#TQC-9B0162  
			 RETURNING li_result,g_poy2[l_ac].poy37
		      CALL s_get_doc_no(g_poy2[l_ac].poy37) RETURNING g_poy2[l_ac].poy37
		      DISPLAY BY NAME g_poy2[l_ac].poy37
		      IF (NOT li_result) THEN
			  LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
			  DISPLAY BY NAME g_poy2[l_ac].poy37
			  NEXT FIELD poy37
		      END IF                                                                                          
		      IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                   
			     #CALL i000_smy(g_poy2[l_ac].poy37,l_dbs_s) RETURNING lg_smy62  
               CALL i000_smy(g_poy2[l_ac].poy37,l_plant_s) RETURNING lg_smy62    #FUN-A50102  
			 IF NOT cl_null(g_poy2[l_ac].poy36) THEN                                                                               
			    #CALL i000_oay(g_poy2[l_ac].poy36,l_dbs) RETURNING lg_oay22
                CALL i000_oay(g_poy2[l_ac].poy36,l_plant) RETURNING lg_oay22  #FUN-A50102
			    IF lg_oay22 <> lg_smy621 THEN                                                                                      
			       CALL cl_err(g_poy2[l_ac].poy37,'axm-046',0)                                                                     
			       LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
			       DISPLAY BY NAME g_poy2[l_ac].poy37
			       NEXT FIELD poy37                                                                                               
			    END IF                                                                                                            
			    IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy621)) OR                                                               
			       (NOT cl_null(lg_oay22) AND cl_null(lg_smy621)) THEN                                                             
			       CALL cl_err(g_poy2[l_ac].poy37,'axm-046',0)                                                                     
			       LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
			       DISPLAY BY NAME g_poy2[l_ac].poy37
			       NEXT FIELD poy37                                                                                               
			    END IF                                                                                                            
			 END IF                                                                                                               
			 IF NOT cl_null(g_poy2[l_ac].poy38) THEN                                                                               
			    SELECT smy62 INTO lg_smy622  
			      FROM smy_file WHERE smyslip = g_poy2[l_ac].poy38                                           
			    IF lg_smy621 <> lg_smy622 THEN                                                                                      
			       CALL cl_err(g_poy2[l_ac].poy37,'axm-046',0)                                                                     
			       LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
			       DISPLAY BY NAME g_poy2[l_ac].poy37
			       NEXT FIELD poy37                                                                                               
			    END IF                                                                                                            
			    IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy622)) OR                                                               
			       (NOT cl_null(lg_smy621) AND cl_null(lg_smy622)) THEN                                                             
			       CALL cl_err(g_poy2[l_ac].poy37,'axm-046',0)                                                                     
			       LET g_poy2[l_ac].poy37 = g_poy2_t.poy37
			       DISPLAY BY NAME g_poy2[l_ac].poy37
			       NEXT FIELD poy37                                                                                               
			    END IF                                                                                                            
			 END IF                                                                                                               
		      ELSE                                                                                                                    
			 LET lg_smy621 = ''                                                                                                    
		      END IF
		   END IF
 
		AFTER FIELD poy38                                
		IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  
		 IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy38) AND g_poy2[l_ac].poy02 <> 0) OR   
		    (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy38) AND g_poy2[l_ac].poy02 <> 99) OR  
		    (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy38) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN  
		     CALL cl_err('','agl-154',0)
		     LET g_poy2[l_ac].poy38  = g_poy2_t.poy38     
		     DISPLAY BY NAME g_poy2[l_ac].poy38            
		     NEXT FIELD poy38
		 END IF
		END IF  
		   IF NOT cl_null(g_poy2[l_ac].poy38) THEN
                         CALL s_check_no("apm",g_poy2[l_ac].poy38,g_poy2_t.poy38,"7","","",l_plant_s)   #TQC-9B0162
			 RETURNING li_result,g_poy2[l_ac].poy38
		      CALL s_get_doc_no(g_poy2[l_ac].poy38) RETURNING g_poy2[l_ac].poy38
		      DISPLAY BY NAME g_poy2[l_ac].poy38
		      IF (NOT li_result) THEN
			 LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
			 DISPLAY BY NAME g_poy2[l_ac].poy38
			 NEXT FIELD poy38
		      END IF                                                                                            
		      IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                   
			     #CALL i000_smy(g_poy2[l_ac].poy38,l_dbs_s) RETURNING lg_smy62 
                 CALL i000_smy(g_poy2[l_ac].poy38,l_plant_s) RETURNING lg_smy62  #FUN-A50102
			 IF NOT cl_null(g_poy2[l_ac].poy36) THEN                                                                               
			    #CALL i000_oay(g_poy2[l_ac].poy36,l_dbs) RETURNING lg_oay22
                CALL i000_oay(g_poy2[l_ac].poy36,l_plant) RETURNING lg_oay22 #FUN-A50102
			    IF lg_oay22 <> lg_smy622 THEN                                                                                      
			       CALL cl_err(g_poy2[l_ac].poy38,'axm-046',0)                                                                     
			       LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
			       DISPLAY BY NAME g_poy2[l_ac].poy38
			       NEXT FIELD poy38                                                                                               
			    END IF                                                                                                            
			    IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy622)) OR                                                               
			       (NOT cl_null(lg_oay22) AND cl_null(lg_smy622)) THEN                                                             
			       CALL cl_err(g_poy2[l_ac].poy38,'axm-046',0)                                                                     
			       LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
			       DISPLAY BY NAME g_poy2[l_ac].poy38
			       NEXT FIELD poy38                                                                                               
			    END IF                                                                                                            
			 END IF                                                                                                               
			 IF NOT cl_null(g_poy2[l_ac].poy37) THEN                                                                               
			    SELECT smy62 INTO lg_smy621 
			      FROM smy_file WHERE smyslip = g_poy2[l_ac].poy37                                           
			    IF lg_smy621 <> lg_smy622 THEN                                                                                      
			       CALL cl_err(g_poy2[l_ac].poy38,'axm-046',0)                                                                     
			       LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
			       DISPLAY BY NAME g_poy2[l_ac].poy38
			       NEXT FIELD poy38                                                                                               
			    END IF                                                                                                            
			    IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy622)) OR                                                               
			       (NOT cl_null(lg_smy621) AND cl_null(lg_smy622)) THEN                                                             
			       CALL cl_err(g_poy2[l_ac].poy38,'axm-046',0)                                                                     
			       LET g_poy2[l_ac].poy38 = g_poy2_t.poy38
			       DISPLAY BY NAME g_poy2[l_ac].poy38
			       NEXT FIELD poy38                                                                                               
			    END IF                                                                                                            
			 END IF                                                                                                               
		      ELSE                                                                                                                    
			 LET lg_smy622 = ''                                                                                                    
		      END IF
		    END IF
 
		AFTER FIELD poy39
		 IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy39)) OR 
		    (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy39) AND g_poy2[l_ac].poy02 <> 99) THEN  
		     CALL cl_err('','agl-154',0)
		     LET g_poy2[l_ac].poy39 = g_poy2_t.poy39       
		     DISPLAY BY NAME g_poy2[l_ac].poy39           
		     NEXT FIELD poy39
		 END IF
		   IF NOT cl_null(g_poy2[l_ac].poy39) THEN  
                       CALL  s_check_no("axr",g_poy2[l_ac].poy39,g_poy2_t.poy39,"12","","",l_plant)  #TQC-9B0162
			     RETURNING li_result,g_poy2[l_ac].poy39
		       CALL s_get_doc_no(g_poy2[l_ac].poy39) RETURNING g_poy2[l_ac].poy39
		       DISPLAY BY NAME g_poy2[l_ac].poy39
		       IF (NOT li_result) THEN
			  CALL cl_err3("sel","ooy_file",g_poy2[l_ac].poy39,"",'mfg3045',"","",1) 
			  LET g_poy2[l_ac].poy39 = g_poy2_t.poy39
			  DISPLAY BY NAME g_poy2[l_ac].poy39    
			  NEXT FIELD poy39
		       END IF
		   END IF
 
		AFTER FIELD poy40
		IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12))  THEN  
		 IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy40) AND g_poy2[l_ac].poy02 <> 0) OR  
		    (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy40) AND g_poy2[l_ac].poy02 <> 99) OR 
		    (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy40) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN  
		     CALL cl_err('','agl-154',0)
		     LET g_poy2[l_ac].poy40  = g_poy2_t.poy40   
		     DISPLAY BY NAME g_poy2[l_ac].poy40         
		     NEXT FIELD poy40
		 END IF
		END IF  
		 IF NOT cl_null(g_poy2[l_ac].poy40) THEN  
                       CALL s_check_no("aap",g_poy2[l_ac].poy40,g_poy2_t.poy40,"11","","",l_plant_s)    #TQC-9B0162        #MOD-9B0036
		       RETURNING li_result,g_poy2[l_ac].poy40
		    CALL s_get_doc_no(g_poy2[l_ac].poy40) RETURNING g_poy2[l_ac].poy40
		    DISPLAY BY NAME g_poy2[l_ac].poy40
		    IF (NOT li_result) THEN
		       LET g_poy2[l_ac].poy40 = g_poy2_t.poy40 
		       DISPLAY BY NAME g_poy2[l_ac].poy40
		       NEXT FIELD poy40
		    END IF
		 END IF
 
		AFTER FIELD poy41                       
		 IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy41)) OR 
		    (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy41) AND g_poy2[l_ac].poy02 <> 99) THEN  
		     CALL cl_err('','agl-154',0)
		     LET g_poy2[l_ac].poy41=g_poy2_t.poy41  
		     DISPLAY BY NAME g_poy2[l_ac].poy41      
		     NEXT FIELD poy41
		 END IF
		  IF g_poy2[l_ac].poy41 IS NOT NULL THEN
                    CALL s_check_no("axm",g_poy2[l_ac].poy41,g_poy2_t.poy41,"60","","",l_plant)       #TQC-9B0162
		      RETURNING li_result,g_poy2[l_ac].poy41
		    CALL s_get_doc_no(g_poy2[l_ac].poy41) RETURNING g_poy2[l_ac].poy41
		    DISPLAY BY NAME g_poy2[l_ac].poy41
		    IF (NOT li_result) THEN
			LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
			DISPLAY BY NAME g_poy2[l_ac].poy41
			NEXT FIELD poy41
		    END IF                                                                                   
		    IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                      
		       #CALL i000_oay(g_poy2[l_ac].poy41,l_dbs) RETURNING lg_oay22
               CALL i000_oay(g_poy2[l_ac].poy41,l_plant) RETURNING lg_oay22 #FUN-A50102
		       IF NOT cl_null(g_poy2[l_ac].poy42) THEN                                                                                  
		#	 CALL i000_smy(g_poy2[l_ac].poy42,l_plant_s) RETURNING lg_smy62   #MOD-9C0168  #No.FUN-A10099
			 #CALL i000_smy(g_poy2[l_ac].poy42,l_dbs_s)   RETURNING lg_smy62   #MOD-9C0168  #No.FUN-A10099
             CALL i000_smy(g_poy2[l_ac].poy42,l_plant_s)   RETURNING lg_smy62    #FUN-A50102
			  IF lg_oay22 <> lg_smy62 THEN                                                                                         
			     CALL cl_err(g_poy2[l_ac].poy41,'axm-059',0)                                                                        
			     IF g_chkey = 'Y' THEN
				LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
				DISPLAY BY NAME g_poy2[l_ac].poy41
				NEXT FIELD poy41                                                                                                  
			     ELSE
				LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
				DISPLAY BY NAME g_poy2[l_ac].poy41
				NEXT FIELD poy42
			     END IF
			  END IF                                                                                                               
			  IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR                                                                  
			     (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN                                                                
			     CALL cl_err(g_poy2[l_ac].poy41,'axm-059',0)                                                                        
			     IF g_chkey = 'Y' THEN
				LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
				DISPLAY BY NAME g_poy2[l_ac].poy41
				NEXT FIELD poy41     
			     ELSE
				LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
				DISPLAY BY NAME g_poy2[l_ac].poy41
				NEXT FIELD poy42
			     END IF                                                                                             
			  END IF                                                                                                               
		       END IF                                                                                                                  
		    ELSE                                                                                                                       
		       LET lg_oay22 = ''                                                                                                       
		    END IF 
		  END IF
 
		AFTER FIELD poy42                               
		IF NOT (g_poz.poz12 = 'Y' AND NOT cl_null(g_poz.poz12)) THEN 
		 IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy42) AND g_poy2[l_ac].poy02 <> 0) OR   
		    (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy42) AND g_poy2[l_ac].poy02 <> 99) OR  
		    (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy42) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN 
		     CALL cl_err('','agl-154',0)
		     LET g_poy2[l_ac].poy42 = g_poy2_t.poy42   
		     DISPLAY BY NAME g_poy2[l_ac].poy42        
		     NEXT FIELD poy42
		 END IF
		END IF 
		 IF NOT cl_null(g_poy2[l_ac].poy42) THEN
                      CALL s_check_no("apm",g_poy2[l_ac].poy42,g_poy2_t.poy42,"4","","",l_plant_s)  #TQC-9B0162
		      RETURNING li_result,g_poy2[l_ac].poy42
		    CALL s_get_doc_no(g_poy2[l_ac].poy42) RETURNING g_poy2[l_ac].poy42
		   DISPLAY BY NAME g_poy2[l_ac].poy42
		   IF (NOT li_result) THEN
		       LET g_poy2[l_ac].poy42 = g_poy2_t.poy42 
		       DISPLAY BY NAME g_poy2[l_ac].poy42
		       NEXT FIELD poy42
		   END IF
		  END IF                                                                                                
		  IF NOT cl_null(g_poy2[l_ac].poy42) THEN
		     IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN 
			#CALL i000_smy(g_poy2[l_ac].poy42,l_dbs_s) RETURNING lg_smy62  
            CALL i000_smy(g_poy2[l_ac].poy42,l_plant_s) RETURNING lg_smy62  #FUN-A50102
			IF NOT cl_null(g_poy2[l_ac].poy41) THEN                                                                                  
			   #CALL i000_oay(g_poy2[l_ac].poy41,l_dbs) RETURNING lg_oay22
               CALL i000_oay(g_poy2[l_ac].poy41,l_plant) RETURNING lg_oay22  #FUN-A50102
			   IF lg_oay22 <> lg_smy62 THEN                                                                                         
			      CALL cl_err(g_poy2[l_ac].poy42,'axm-059',0)                                                                        
			      LET g_poy2[l_ac].poy42 = g_poy2_t.poy42 
			      DISPLAY BY NAME g_poy2[l_ac].poy42
			      NEXT FIELD poy42                                                                                                  
			   END IF                                                                                                               
			   IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR                                                                  
			      (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN                                                                
			      CALL cl_err(g_poy2[l_ac].poy42,'axm-058',0)                                                                        
			      LET g_poy2[l_ac].poy42 = g_poy2_t.poy42 
			      DISPLAY BY NAME g_poy2[l_ac].poy42
			      NEXT FIELD poy42                                                                                                  
			   END IF                                                                                                               
			END IF                                                                                                                  
		     ELSE                                                                                                                       
			LET lg_smy62 = ''                                                                                                       
		     END IF                                                                                                                     
		  END IF
 
		AFTER FIELD poy43
		 IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy43)) OR 
		    (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy43) AND g_poy2[l_ac].poy02 <> 99 )  THEN  
		     CALL cl_err('','agl-154',0)
		     LET g_poy2[l_ac].poy43 = g_poy2_t.poy43  
		     DISPLAY BY NAME g_poy2[l_ac].poy43                  
		     NEXT FIELD poy43
		 END IF
		   IF NOT cl_null(g_poy2[l_ac].poy43) THEN
                       CALL s_check_no("axr",g_poy2[l_ac].poy43,g_poy2_t.poy43,"21","","",l_plant)  #TQC-9B0162
			     RETURNING li_result,g_poy2[l_ac].poy43
		       CALL s_get_doc_no(g_poy2[l_ac].poy43) RETURNING g_poy2[l_ac].poy43
		       DISPLAY BY NAME g_poy2[l_ac].poy43
		       IF (NOT li_result) THEN
			  CALL cl_err3("sel","smy_file",g_poy2[l_ac].poy43,"",'mfg3045',"","",1)  
			  LET g_poy2[l_ac].poy43 = g_poy2_t.poy43
			  DISPLAY BY NAME g_poy2[l_ac].poy43      
			  NEXT FIELD poy43
		       END IF
		   END IF
 
		AFTER FIELD poy44
		IF g_poz.poz12 <> 'Y' THEN 
		  IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy44) AND g_poy2[l_ac].poy02 <>0 ) OR  
		     (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy44) AND g_poy2[l_ac].poy02 <> 99) OR  
		     (g_poz.poz00 = '2' AND cl_null(g_poy2[l_ac].poy44) AND g_poy2[l_ac].poy02 = 99 AND g_poz.poz011='1') THEN  
		      CALL cl_err('','agl-154',0)
		      LET g_poy2[l_ac].poy44 = g_poy2_t.poy44  
		      DISPLAY BY NAME g_poy2[l_ac].poy44        
		      NEXT FIELD poy44
		  END IF
		END IF  
		 IF NOT cl_null(g_poy2[l_ac].poy44) THEN  
                       CALL s_check_no("aap",g_poy2[l_ac].poy44,g_poy2_t.poy44,"21","","",l_plant_s)#TQC-9B0162         #MOD-9B0036
		       RETURNING li_result,g_poy2[l_ac].poy44
		    CALL s_get_doc_no(g_poy2[l_ac].poy44) RETURNING g_poy2[l_ac].poy44
		    DISPLAY BY NAME g_poy2[l_ac].poy44
		    IF (NOT li_result) THEN
		       LET g_poy2[l_ac].poy44 = g_poy2_t.poy44 
		       DISPLAY BY NAME g_poy2[l_ac].poy44
		       NEXT FIELD poy44
		    END IF
		 END IF
 
		AFTER FIELD poy47                       
                    IF g_poy2[l_ac].poy47 IS NOT NULL THEN
                       CALL s_check_no('axm',g_poy2[l_ac].poy47,g_poy2_t.poy47,"40","","",l_plant)    #TQC-9B0162
                         RETURNING li_result,g_poy2[l_ac].poy47
                       CALL s_get_doc_no(g_poy2[l_ac].poy47) RETURNING g_poy2[l_ac].poy47
                       DISPLAY BY NAME g_poy2[l_ac].poy47
                       IF (NOT li_result) THEN
                          LET g_poy2[l_ac].poy47 = g_poy2_t.poy47
                          DISPLAY BY NAME g_poy2[l_ac].poy47
    	                  NEXT FIELD poy47
                       END IF
                    END IF
        AFTER FIELD poy48                        #check 編號是否重複
            IF (g_poz.poz00 = '1' AND cl_null(g_poy2[l_ac].poy48)) OR 
            (g_poz.poz00 = '2' AND g_poy2[l_ac].poy02 > 0 AND cl_null(g_poy2[l_ac].poy48) AND g_poy2[l_ac].poy02 <> 99) THEN
                CALL cl_err('','agl-154',0)
                LET g_poy2[l_ac].poy48 = g_poy2_t.poy48
                DISPLAY BY NAME g_poy2[l_ac].poy48
                NEXT FIELD poy48
            END IF
            IF g_poy2[l_ac].poy48 IS NOT NULL THEN
               CALL s_check_no('axm',g_poy2[l_ac].poy48,g_poy2_t.poy48,"55","","",l_plant)   #TQC-9B0162
                 RETURNING li_result,g_poy2[l_ac].poy48
               CALL s_get_doc_no(g_poy2[l_ac].poy48) RETURNING g_poy2[l_ac].poy48
               DISPLAY BY NAME g_poy2[l_ac].poy48
               IF (NOT li_result) THEN
                  LET g_poy2[l_ac].poy48 = g_poy2_t.poy48
                  DISPLAY BY NAME g_poy2[l_ac].poy48
    	          NEXT FIELD poy48
               END IF
            END IF
          ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(poy34)      
                CALL q_m_oay(FALSE,TRUE,g_t,'30','AXM',g_poy[l_ac].poy04) RETURNING g_t  #No.FUN-980017 
                LET g_poy2[l_ac].poy34=g_t
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy34) THEN 
                   LET g_poy2[l_ac].poy34 = g_poy2_t.poy34 
                END IF    
                #TQC-D40028 add end                
                DISPLAY BY NAME g_poy2[l_ac].poy34
                NEXT FIELD poy34
             WHEN INFIELD(poy35)    
                   CALL q_m_smy(FALSE,TRUE,g_t,'APM','2',l_plant_s) RETURNING g_t                 #No.FUN-980017          #MOD-9C0168
                LET g_poy2[l_ac].poy35=g_t
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy35) THEN 
                   LET g_poy2[l_ac].poy35 = g_poy2_t.poy35 
                END IF    
                #TQC-D40028 add end                 
                DISPLAY BY NAME g_poy2[l_ac].poy35
                NEXT FIELD poy35
             WHEN INFIELD(poy36)
                CALL q_m_oay(FALSE,TRUE,g_poy2[l_ac].poy36,'50','AXM',g_poy[l_ac].poy04)   #No.FUN-980017
                RETURNING g_poy2[l_ac].poy36
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy36) THEN 
                   LET g_poy2[l_ac].poy36 = g_poy2_t.poy36 
                END IF    
                #TQC-D40028 add end                 
                DISPLAY g_poy2[l_ac].poy36  TO poy36
                NEXT FIELD poy36
             WHEN INFIELD(poy47)
                CALL q_m_oay(FALSE,TRUE,g_poy2[l_ac].poy36,'40','AXM',g_poy[l_ac].poy04) #No.FUN-980017
                RETURNING g_poy2[l_ac].poy47
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy47) THEN 
                   LET g_poy2[l_ac].poy47 = g_poy2_t.poy47 
                END IF    
                #TQC-D40028 add end                 
                DISPLAY g_poy2[l_ac].poy47  TO poy47
                NEXT FIELD poy47
             WHEN INFIELD(poy48)
                CALL q_m_oay(FALSE,TRUE,g_poy2[l_ac].poy48,'55','AXM',g_poy[l_ac].poy04) #No.FUN-980017
                RETURNING g_poy2[l_ac].poy48
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy48) THEN 
                   LET g_poy2[l_ac].poy48 = g_poy2_t.poy48 
                END IF    
                #TQC-D40028 add end                 
                DISPLAY g_poy2[l_ac].poy48  TO poy48
                NEXT FIELD poy48
             WHEN INFIELD(poy37)
                   CALL q_m_smy(FALSE,TRUE,g_poy2[l_ac].poy37,'APM','3',l_plant_s)                 #No.FUN-980017     #MOD-9C0168
                   RETURNING g_poy2[l_ac].poy37
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy37) THEN 
                   LET g_poy2[l_ac].poy37 = g_poy2_t.poy37 
                END IF    
                #TQC-D40028 add end                    
                DISPLAY g_poy2[l_ac].poy37  TO poy37
                NEXT FIELD poy37
             WHEN INFIELD(poy38)
                   CALL q_m_smy(FALSE,TRUE,g_poy2[l_ac].poy38,'APM','7',l_plant_s)                #No.FUN-980017      #MOD-9C0168
                   RETURNING g_poy2[l_ac].poy38
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy38) THEN 
                   LET g_poy2[l_ac].poy38 = g_poy2_t.poy38 
                END IF    
                #TQC-D40028 add end                    
                DISPLAY g_poy2[l_ac].poy38  TO poy38
                NEXT FIELD poy38
             WHEN INFIELD(poy39)                                                    
                CALL q_m_ooy(FALSE,FALSE,g_poy2[l_ac].poy39,'12','AXR',g_poy[l_ac].poy04)   #No.FUN-980017       
                     RETURNING g_poy2[l_ac].poy39  
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy39) THEN 
                   LET g_poy2[l_ac].poy39 = g_poy2_t.poy39 
                END IF    
                #TQC-D40028 add end                                                
                DISPLAY g_poy2[l_ac].poy39  TO poy39
                NEXT FIELD poy39                                            
             WHEN INFIELD(poy40)                                              
                   CALL q_m_apy(FALSE,TRUE,g_poy2[l_ac].poy40,'11','AAP',l_plant_s)   #NO.TQC-7C0148  #FUN-990069    #MOD-9B0036
                   RETURNING g_poy2[l_ac].poy40    
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy40) THEN 
                   LET g_poy2[l_ac].poy40 = g_poy2_t.poy40 
                END IF    
                #TQC-D40028 add end                                            
                DISPLAY g_poy2[l_ac].poy40  TO poy40
                NEXT FIELD poy40  
             WHEN INFIELD(poy41)
                CALL q_m_oay(FALSE,TRUE,g_poy2[l_ac].poy41,'60','AXM',g_poy[l_ac].poy04) #No.FUN-980017
                     RETURNING g_poy2[l_ac].poy41
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy41) THEN 
                   LET g_poy2[l_ac].poy41 = g_poy2_t.poy41 
                END IF    
                #TQC-D40028 add end                      
                DISPLAY g_poy2[l_ac].poy41  TO poy41
                NEXT FIELD poy41
             WHEN INFIELD(poy42)
                   CALL q_m_smy(FALSE,TRUE,g_poy2[l_ac].poy42,'APM','4',l_plant_s)               #No.FUN-980017     #MOD-9C0168
                   RETURNING g_poy2[l_ac].poy42
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy42) THEN 
                   LET g_poy2[l_ac].poy42 = g_poy2_t.poy42 
                END IF    
                #TQC-D40028 add end                    
                DISPLAY g_poy2[l_ac].poy42  TO poy42
                NEXT FIELD poy42
             WHEN INFIELD(poy43)
                CALL q_m_ooy(FALSE,TRUE,g_poy2[l_ac].poy43,'21','AXR',g_poy[l_ac].poy04)      #No.FUN-980017
                     RETURNING g_poy2[l_ac].poy43
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy43) THEN 
                   LET g_poy2[l_ac].poy43 = g_poy2_t.poy43 
                END IF    
                #TQC-D40028 add end                      
                DISPLAY g_poy2[l_ac].poy43  TO poy43
                NEXT FIELD poy43
             WHEN INFIELD(poy44)  
                   CALL q_m_apy(FALSE,TRUE,g_poy2[l_ac].poy44,'21','AAP',l_plant_s)  #no.TQC-7C0148  #FUN-990069
                   RETURNING g_poy2[l_ac].poy44
                #TQC-D40028 add begin
                IF cl_null(g_poy2[l_ac].poy44) THEN 
                   LET g_poy2[l_ac].poy44 = g_poy2_t.poy44 
                END IF    
                #TQC-D40028 add end                    
                DISPLAY g_poy2[l_ac].poy44  TO poy44
                NEXT FIELD poy44
             OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
        
        ON ACTION manual_input         
           CALL i100_b2_input(l_ac) 
           
        ON ACTION about         
          CALL cl_about()     
 
        ON ACTION help        
          CALL cl_show_help() 
        
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT  
         
      END INPUT 
      CLOSE WINDOW i000_b2_1_w    
END FUNCTION 
#No:FUN-9C0071--------精簡程式-----

