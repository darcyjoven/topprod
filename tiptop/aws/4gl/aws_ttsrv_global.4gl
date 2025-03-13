# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv_global.4gl
# Descriptions...: TIPTOP Services 服務全域變數檔
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
#
#}
# Modify.........: No.FUN-760069 07/06/25 By Mandy 新增Portal專案銷售統計Porlet會用到的Service
# Modify.........: No.FUN-770051 07/07/13 By Mandy 新增Portal專案訂逾期帳款/訂單資訊Porlet會用到的Service
# Modify.........: No.FUN-820029 08/02/20 By Kevin 新增CRM整合TITPOP客戶資訊service
# Modify.........: No.FUN-850022 08/06/26 By Kevin 新增e-Bonline整合回傳檢驗碼(rvb39)service
# Modify.........: No.MOD-860146 08/07/15 By Smapmin e-Bonline整合回傳檢驗碼(rvb39)service多一rvb03參數 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
GLOBALS
   
    #--------------------------------------------------------------------------#
    # 執行狀態(所有服務通用)                                                   #
    #--------------------------------------------------------------------------#
    DEFINE g_status RECORD
              code          STRING,    #訊息代碼
              sqlcode       STRING,    #SQL ERROR CODE
              description   STRING     #訊息說明
           END RECORD 
   
    
    #--------------------------------------------------------------------------#
    # 登入資訊(所有服務通用)                                                   #
    #--------------------------------------------------------------------------#
    DEFINE g_signIn RECORD
              userId         STRING,   #使用者帳號
              password       STRING,   #使用者密碼
              from           STRING,   #來源位址(IP or Host)
              organization   STRING,   #ERP 營運中心名稱,
              systemId       STRING    #系統別
           END RECORD
   
           
    #--------------------------------------------------------------------------#
    # ERP TABLE 欄位名稱及欄位值(所有服務通用)                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_field    om.DomNode       #以 XML 方式處理欄位名稱/欄位值等資訊
 
    
    #--------------------------------------------------------------------------#
    # 其他變數 (所有服務通用)                                                  #
    #--------------------------------------------------------------------------#
    DEFINE g_service   STRING          #TIPTOP 服務名稱
 
        
    #--------------------------------------------------------------------------#
    # CreateCustomerData 服務所使用 input/output 參數                          #
    #--------------------------------------------------------------------------#
    DEFINE g_createCustomerData_in RECORD
              signIn     STRING,       #登入資訊 
              occ        STRING        #客戶資料
           END RECORD
    DEFINE g_createCustomerData_out RECORD
              status     STRING        #執行狀態 
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetAXMDocument 服務所使用 input/output 參數                              #
    #--------------------------------------------------------------------------#
    DEFINE g_getAXMDocument_in RECORD
              signIn    STRING,        #登入資訊 
              oaysys    STRING,        #系統別, 固定為 'AXM'
              oaytype   STRING         #單據性質
           END RECORD
    DEFINE g_getAXMDocument_out RECORD
              status    STRING,        #執行狀態
              oay       DYNAMIC ARRAY OF RECORD
                 oayslip   STRING,     #單別
                 oaydesc   STRING      #單別說明
              END RECORD 
           END RECORD
 
    #--------------------------------------------------------------------------#
    # CreateQuotationData 服務所使用 input/output 參數                         #
    #--------------------------------------------------------------------------#
    DEFINE g_createQuotationData_in RECORD
              signIn    STRING,        #登入資訊
              oayslip   STRING,        #報價單單別 
              oqt       STRING,        #報價單單頭
              oqu       STRING         #報價單單身
           END RECORD
    DEFINE g_createQuotationData_out RECORD
              status    STRING,        #執行狀態
              oqt01     STRING         #ERP 報價單單號
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetOrganizationList 服務所使用 input/output 參數                         #
    #--------------------------------------------------------------------------#
    DEFINE g_getOrganizationList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getOrganizationList_out RECORD
              status    STRING,        #執行狀態
              azp       DYNAMIC ARRAY OF RECORD
                 azp01   STRING,       #營運中心代碼
                 azp02   STRING        #營運中心說明
              END RECORD
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetCurrencyList 服務所使用 input/output 參數                             #
    #--------------------------------------------------------------------------#
    DEFINE g_getCurrencyList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getCurrencyList_out RECORD
              status    STRING,        #執行狀態
              azi       DYNAMIC ARRAY OF RECORD
                 azi01   STRING,       #幣別代碼
                 azi02   STRING        #幣別說明
              END RECORD
           END RECORD
              
    #--------------------------------------------------------------------------#
    # GetCurrencyData 服務所使用 input/output 參數                             #
    #--------------------------------------------------------------------------#
    DEFINE g_getCurrencyData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getCurrencyData_out RECORD
              status    STRING,        #執行狀態
              azi       STRING         #幣別資料
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetAreaList 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getAreaList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getAreaList_out RECORD
              status    STRING,        #執行狀態
              gea       DYNAMIC ARRAY OF RECORD
                 gea01   STRING,       #區域代碼
                 gea02   STRING        #區域說明
              END RECORD
           END RECORD
              
    #--------------------------------------------------------------------------#
    # GetAreaData 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getAreaData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getAreaData_out RECORD
              status    STRING,        #執行狀態
              gea       STRING         #區域資料
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetCountryList 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getCountryList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getCountryList_out RECORD
              status    STRING,        #執行狀態
              geb       DYNAMIC ARRAY OF RECORD
                 geb01   STRING,       #國別代碼
                 geb02   STRING        #國別說明
              END RECORD
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetCountryData 服務所使用 input/output 參數                              #
    #--------------------------------------------------------------------------#
    DEFINE g_getCountryData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getCountryData_out RECORD
              status    STRING,        #執行狀態
              geb       STRING         #國別資料
           END RECORD
              
    #--------------------------------------------------------------------------#
    # GetEmployeeList 服務所使用 input/output 參數                             #
    #--------------------------------------------------------------------------#
    DEFINE g_getEmployeeList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getEmployeeList_out RECORD
              status    STRING,        #執行狀態
              gen       DYNAMIC ARRAY OF RECORD
                 gen01   STRING,       #員工編號
                 gen02   STRING        #員工姓名
              END RECORD
           END RECORD
              
    #--------------------------------------------------------------------------#
    # GetItemList 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getItemList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getItemList_out RECORD
              status    STRING,        #執行狀態
              ima       DYNAMIC ARRAY OF RECORD
                 ima01   STRING,       #料件編號
                 ima02   STRING        #料件說明
              END RECORD
           END RECORD
              
    #--------------------------------------------------------------------------#
    # GetEmployeeData 服務所使用 input/output 參數                             #
    #--------------------------------------------------------------------------#
    DEFINE g_getEmployeeData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getEmployeeData_out RECORD
              status    STRING,        #執行狀態
              gen       STRING         #員工資料
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetItemData 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getItemData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getItemData_out RECORD
              status    STRING,        #執行狀態
              ima       STRING         #料件資料
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetDepartmentList 服務所使用 input/output 參數                             #
    #--------------------------------------------------------------------------#
    DEFINE g_getDepartmentList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getDepartmentList_out RECORD
              status    STRING,        #執行狀態
              gem       DYNAMIC ARRAY OF RECORD
                 gem01   STRING,       #部門編號
                 gem02   STRING        #部門簡稱
              END RECORD
           END RECORD
              
    #--------------------------------------------------------------------------#
    # GetDepartmentData 服務所使用 input/output 參數                             #
    #--------------------------------------------------------------------------#
    DEFINE g_getDepartmentData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getDepartmentData_out RECORD
              status    STRING,        #執行狀態
              gem       STRING         #部門資料
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetSupplierData 服務所使用 input/output 參數                             #
    #--------------------------------------------------------------------------#
    DEFINE g_getSupplierData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getSupplierData_out RECORD
              status    STRING,        #執行狀態
              pmc       STRING         #供應商資料
           END RECORD
           	
    #--------------------------------------------------------------------------#
    # GetSupplierItemData 服務所使用 input/output 參數                         #
    #--------------------------------------------------------------------------#
    DEFINE g_getSupplierItemData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getSupplierItemData_out RECORD
              status    STRING,        #執行狀態
              pmh       STRING         #供應商料件資料
           END RECORD
           	
    #--------------------------------------------------------------------------#
    # GetCustomerData 服務所使用 input/output 參數                             #
    #--------------------------------------------------------------------------#
    DEFINE g_getCustomerData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getCustomerData_out RECORD
              status    STRING,        #執行狀態
              occ       STRING         #客戶資料
           END RECORD
           
    #--------------------------------------------------------------------------#
    # GetCustomerProductData 服務所使用 input/output 參數                      #
    #--------------------------------------------------------------------------#
    DEFINE g_getCustomerProductData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getCustomerProductData_out RECORD
              status    STRING,        #執行狀態
              obk       STRING         #客戶產品資料
           END RECORD
              
    #--------------------------------------------------------------------------#
    # GetBOMData 服務所使用 input/output 參數                                  #
    #--------------------------------------------------------------------------#
    DEFINE g_getBOMData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getBOMData_out RECORD
              status    STRING,        #執行狀態
              bma       STRING,        #BOM單頭資料
              bmb       STRING         #BOM單身資料
           END RECORD
                    
    #--------------------------------------------------------------------------#
    # GetComponentRepSubData 服務所使用 input/output 參數                      #
    #--------------------------------------------------------------------------#
    DEFINE g_getComponentRepSubData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getComponentRepSubData_out RECORD
              status    STRING,        #執行狀態
              bmd       STRING         #替代料資料
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetCostGroupData 服務所使用 input/output 參數                            #
    #--------------------------------------------------------------------------#
    DEFINE g_getCostGroupData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getCostGroupData_out RECORD
              status    STRING,        #執行狀態
              azf       STRING         #成本分群
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetAccountSubjectData 服務所使用 input/output 參數                       #
    #--------------------------------------------------------------------------#
    DEFINE g_getAccountSubjectData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件
           END RECORD
    DEFINE g_getAccountSubjectData_out RECORD
              status    STRING,        #執行狀態
              aag       STRING         #會計科目
           END RECORD
 
    #FUN-760069------------add------------------------------str-----------------
    #--------------------------------------------------------------------------#
    # GetCustList 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getCustList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getCustList_out RECORD
              status    STRING,        #執行狀態
              occ       DYNAMIC ARRAY OF RECORD
                 occ01   STRING,       #客戶編號
                 occ02   STRING        #客戶簡稱
              END RECORD
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetProdClassList 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getProdClassList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getProdClassList_out RECORD
              status    STRING,        #執行狀態
              oba       DYNAMIC ARRAY OF RECORD
                 oba01   STRING,       #產品分類碼
                 oba02   STRING        #產品分類碼名稱
              END RECORD
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetMonthList 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getMonthList_in RECORD
              signIn    STRING         #登入資訊
           END RECORD
    DEFINE g_getMonthList_out RECORD
              status    STRING,        #執行狀態
              mon       DYNAMIC ARRAY OF RECORD
                 mon01   STRING        #月份碼(1~12)
              END RECORD
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetSalesStatisticsData 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getSalesStatisticsData_in RECORD
              signIn    STRING,        #登入資訊 
              year      STRING         #系統參數現行年
           END RECORD
    DEFINE g_getSalesStatisticsData_out RECORD
              status    STRING,        #執行狀態
              recd      STRING
           END RECORD
 
    #--------------------------------------------------------------------------#
    # GetSalesDetailData 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getSalesDetailData_in RECORD
              signIn    STRING,        #登入資訊 
              year      STRING,        #系統參數現行年
              month     STRING,        #期間(1~12)
              oga03     STRING,        #客戶別
              occ20     STRING,        #地區別
              ima131    STRING,        #產品別
              oga14     STRING         #業務員
           END RECORD
    DEFINE g_getSalesDetailData_out RECORD
              status    STRING,        #執行狀態
              recd      STRING
           END RECORD
    #FUN-760069------------add------------------------------end-----------------
 
    #FUN-770051------------add------------------------------str-----------------
    #訂單資訊
    #--------------------------------------------------------------------------#
    # GetSOInfoData 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getSOInfoData_in RECORD
              signIn    STRING         #登入資訊 
           END RECORD
    DEFINE g_getSOInfoData_out RECORD
              status    STRING,        #執行狀態
              recd      STRING
           END RECORD
 
    #訂單資訊明細
    #--------------------------------------------------------------------------#
    # GetSOInfoDetailData 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getSOInfoDetailData_in RECORD
              signIn    STRING,        #登入資訊 
              condition STRING         #資料條件(oea01,oea02,oea03,oeb04四欄位所轉成SQL所可以接受的語法)
           END RECORD
    DEFINE g_getSOInfoDetailData_out RECORD
              status    STRING,        #執行狀態
              recd      STRING
           END RECORD
 
    #逾期帳款排行
    #--------------------------------------------------------------------------#
    # GetOverdueAmtRankingData 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getOverdueAmtRankingData_in RECORD
              signIn    STRING,        #登入資訊 
              ranking   STRING         #顯示逾期排行名次 
           END RECORD
    DEFINE g_getOverdueAmtRankingData_out RECORD
              status    STRING,        #執行狀態
              recd      STRING
           END RECORD
 
    #逾期帳款排行明細
    #--------------------------------------------------------------------------#
    # GetOverdueAmtDetailData 服務所使用 input/output 參數                                 #
    #--------------------------------------------------------------------------#
    DEFINE g_getOverdueAmtDetailData_in RECORD
              signIn    STRING,        #登入資訊 
              oma03     STRING,        #客戶別
              d1        STRING,        #逾期帳款區間D1
              d2        STRING,        #逾期帳款區間D2
              d3        STRING,        #逾期帳款區間D3
              d4        STRING,        #逾期帳款區間D4
              d5        STRING,        #逾期帳款區間D5
              d6        STRING,        #逾期帳款區間D6
              d7        STRING,        #逾期帳款區間D7
              d8        STRING,        #逾期帳款區間D8
              d9        STRING,        #逾期帳款區間D9
              d10       STRING         #逾期帳款區間D10
           END RECORD
    DEFINE g_getOverdueAmtDetailData_out RECORD
              status    STRING,        #執行狀態
              recd      STRING
           END RECORD
 
    #FUN-770051------------add------------------------------end-----------------
 
    #FUN-820029 --start--
    #--------------------------------------------------------------------------#
    # CRMGetCustomerData 服務所使用 input/output 參數                          #
    #--------------------------------------------------------------------------#
    DEFINE g_CRMGetCustomerData_in RECORD
             signIn    STRING,        #登入資訊
             occ01     STRING         #客戶編號
          END RECORD
    DEFINE g_CRMGetCustomerData_out RECORD
             status    STRING,        #執行狀態
             occ       STRING         #客戶資料
          END RECORD
    #FUN-820029 --end--
    
    #FUN-850022 --start--
    DEFINE g_getInspectionData_in RECORD
            signIn    STRING,        #登入資訊
            rvb03     STRING,        #採購單項次   #MOD-860146
            rvb04     STRING,        #採購單號
            rvb05     STRING,        #料件編號
            rvb19     STRING,        #收貨性質
            rva05     STRING         #供應廠商
         END RECORD
    DEFINE g_getInspectionData_out RECORD
            status    STRING,      #執行狀態
            rvb39     STRING
         END RECORD
    #FUN-850022 --end--
 
END GLOBALS
