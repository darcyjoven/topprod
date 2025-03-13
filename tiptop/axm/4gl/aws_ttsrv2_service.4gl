# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv2_service.4gl
# Descriptions...: 公開各種 TIPTOP 服務
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-840004
# Modify.........: NO.FUN-860036 08/06/11 By kim 加入MDM的相關服務
# Modify.........: No.FUN-860037 08/06/25 By Kevin 升級到aws_ttsrv2
# Modify.........: No.FUN-850022 08/06/26 By Kevin 回傳檢驗碼(rvb39)
# Modify.........: No.FUN-850147 08/07/06 By Echo 新增"建立BOM資料"服務
# Modify.........: No.FUN-870028 08/07/15 By sherry 增加作業編號,單位,碼別,倉庫,倉儲
# Modify.........: No.FUN-880012 08/08/04 By kevin 取得使用者帳號驗證碼
# Modify.........: No.FUN-840012 08/09/30 By kim 新增mBarcode相關服務 
# Modify.........: No.FUN-8A0112 08/10/27 By David Fluid Lee 新增TIPTOP通用集成接口服務
# Modify.........: No.FUN-8B0113 08/11/27 By Vicky 新增"呼叫 TIPTOP 執行 r.c2、r.f2、r.l2"服務
# Modify.........: No.FUN-860068 08/06/20 By Kevin e-B Online 平台呼叫 TIPTOP Web Service
# Modify.........: No.TQC-910021 09/01/12 By Kevin 讓APS 呼叫 apsp702 以背景的方式執行
# Modify.........: No.FUN-930132 09/04/13 By Vicky 新增 "取得報表資料" 服務
# Modify.........: No.FUN-A40084 10/04/29 By Echo Genero2.21版本需調整 com.WebOperation.CreateDOCStyle
# Modify.........: No.FUN-A50022 10/06/11 By Jay 增加GetReportData服務 
# Modify.........: No.FUN-930139 10/08/13 By Lilan 新增CRM相關服務
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版-------str----
# Modify.........: No:FUN-9A0090 09/10/26 By Mandy 新增--HR整合函式
#                                                        (1)GetAccountTypeData     讀取帳別參數資料
#                                                        (2)GetAccountData         讀取會計科目資料
#                                                        (3)CreateVoucherData      建立傳票資料
#                                                        (4)GetVoucherDocumentData 讀取傳票單別資料
# Modify.........: No:FUN-A10069 10/01/15 By Mandy 新增--HR-功能加強-整合函式
#                                                        (1)GetTransactionCategory 讀取帳款類別資料
#                                                        (2)CreateBillingAP        建立應付請款資料
# Modify.........: No:FUN-A20035 10/02/09 By Mandy 調整--HR-功能加強-整合函式
#                                                        (1)CreateDepartmentData   建立部門基本資料
# Modify.........: No:FUN-A30090 10/03/29 By Mandy 新增--HR整合函式
#                                                        (1)RollbackVoucherData    傳票資料拋轉還原
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版-------end----
# Modify.........: No.FUN-AC0068 10/10/29 By Lilan 新增CRM整合函式
#                                                        (1)GetPaymentTermsData
# Modify.........: No:FUN-B10003 11/01/04 By Jay 新增TIPTOP SSO整合服務--GetSSOKey
# Modify.........: No.FUN-B10004 11/01/06 By Mandy 新增CRM整合函式 #建立無訂單出貨單
#                                                  (1)CreateShippingOrdersWithoutOrders
# Modify.........: No.FUN-B30020 11/03/07 By Lilan 新增[取得料件分群碼]服務:GetItemGroupData
# Modify.........: No.FUN-B30147 11/03/17 By Lilan 新增[取得料件其他分群碼]服務:GetItemOtherGroupData
# Modify.........: No.FUN-B20029 11/03/22 By Echo TIPTOP 與 CROSS 整合,增加服務: invokeSrv, callbackSrv, syncProd, mdmSrv
# Modify.........: No:FUN-B40072 11/04/25 By Henry 新增--TIPTOP 新增功能服務
#                                                        (1)GetProdState     讀取server states
#                                                        (2)GetProdInfo      讀取server information
#                                                        (2)GetOnlineUser    讀取server Online User
# Modify.........: No:FUN-B50032 11/05/11 By Jay 新增呼叫invokeMdm服務,mdmsrv名稱改為invokeMdm
# Modify.........: No:FUN-B10037 11/05/11 By abby 新增--"CreateWOWorkReportData"(建立報工單資料)
# Modify.........: No:FUN-B60003 11/06/01 By Lilan 新增POS用整合函式
#                                                  (1)取得會員基本資料：GetMemberData
#                                                  (2)取得卡明細資料：GetCardDetailData 
# Modify.........: No:FUN-A20026 11/06/20 By Abby 新增"讀取工作站資料服務","讀取機器資料服務"
# Modify.........: No:FUN-A70142 11/06/20 By Abby 新增--"CreateSupplierItemData"(建立料件供應商資料服務)
# Modify.........: No:FUN-A80131 11/06/20 By Abby 新增--"CreateItemApprovalData"(建立料件承認資料)
# Modify.........: No:FUN-A80127 11/06/20 By Abby 新增--"GetBrandData"(取得ERP廠牌資料服務)
# Modify.........: No:FUN-A80017 11/07/05 By Mandy PLM GP5.25 追版---str---
# Modify.........: No:FUN-A10061 10/02/10 By Lilan 字母改大寫:Bom改成BOM
#                  No:FUN-A70147 10/07/30 By Mandy 新增--PLM整合函式
#                                                        (1)CreateRepSubPBOMData
# Modify.........: No:FUN-B20003 11/02/09 By Mandy 新增--PLM整合函式 CreatePLMBOMData（建立PLM P-BOM資料）
# Modify.........: No:FUN-A80017 11/07/05 By Mandy PLM GP5.25 追版---end---
# Modify.........: No:FUN-B80168 11/08/26 By Abby 新增EMS整合Service -- GetCustomerAccAmtData(取得客戶應收帳款資料服務)
# Modify.........: No:FUN-BA0002 11/10/03 By Abby 新增CRM Service --GetCustClassificationData, GetTradeTermData, GetInvoiceTypeList
# Modify.........: No:FUN-B60090 11/11/23 By ka0132 新增--"SyncAccountData"(建立使用者帳號-for portal)
# Modify.........: No:FUN-BB0161 11/11/29 By ka0132 新增--"SyncEncodingState"(更改編碼狀態)
# Modify.........: No:FUN-C50138 12/05/29 By suncx 新增--ModPassWord、PGetMemberCardInfo、CheckGiftNo、WritePoint、DeductMoney
#                                                                 --DeductGiftNO、GetScore、DeductScore、GetCashCardInfo
# Modify.........: No:FUN-B90089 12/08/27 By Abby 新增M-Cloud整合函式
#                                                 (1)GetUserDefOrg:取得使用者預設的營運中心
#                                                 (2)GetSOData:取得訂單資料服務
#                                                 (3)GetShappingData:取得出貨單資料
#                                                 (4)GetQuotationData:取得報價單資料服務
#                                                 (5)GetDataCount:取得資料總筆數
#}
# Modify.........: No:FUN-CA0090 12/05/29 By baogc 新增--GetCardScore
# Modify.........: No:FUN-CB0028 12/11/12 By shiwuying DeductSPayment 服务名称统一
# Modify.........: No:FUN-CB0104 12/11/22 By xumeimei 新增--ReturnOrderBill--GetOrderInfo
# Modify.........: No:FUN-C50126 12/12/22 By Abby 新增HRM功能改善函式：GetAPCategoryAccountCode(讀取帳款類別預設會計科目資料)
# Modify.........: No:FUN-C80078 12/12/22 By Abby 新增HRM功能改善函式：RollbackBillingAP(應付請款資料拋轉還原)
# Modify.........: No:FUN-CC0135 12/12/25 By xumeimei 新增--CheckMemberUpgrade--MemberUpgrade
# Modify.........: No:FUN-D10092 13/01/20 By Abby 新增DigiWin PLM整合函式：
#                                                 (1) CreatePLMTempTableData
#                                                 (2) GetPLMTempTableDataStatus
#                                                 (3) DeletePLMTempTableData

IMPORT com 

DATABASE ds
 
#FUN-840004
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: Dummy Function
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_serviceFunction(p_op_name,p_func)
DEFINE p_op_name   STRING
DEFINE p_func      STRING 
DEFINE l_op        com.WebOperation
   
    WHENEVER ERROR CONTINUE
    
    #FUN-A40084 -- start -- 
    #------------------------------------------------------------------------------------------------------#
    # 請新增每一個 ERP 服務時, 於以下加入發佈 Service Function 段落                                        #
    # 此處定義的 Function Name 必須與設定作業中輸入的一致(否則執行時將報錯)                                #
    # CASE p_func                                                                                          #
    #  WHEN "function_name"                                                                                #
    #       LET l_op = com.WebOperation.CreateDOCStyle("function_name",p_op_name, g_request, g_response)   #
    #                                                                                                      #
    #------------------------------------------------------------------------------------------------------#

    CASE p_func
       WHEN "TIPTOPGateWay"
            LET l_op = com.WebOperation.CreateDOCStyle("TIPTOPGateWay",p_op_name, g_request, g_response)

       WHEN "aws_getItemData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getItemData", p_op_name, g_request, g_response)
      #FUN-BA0002 add str---
       WHEN "aws_getCustClassificationData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCustClassificationData", p_op_name, g_request, g_response)
       WHEN "aws_getTradeTermData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getTradeTermData", p_op_name, g_request, g_response)
       WHEN "aws_getInvoiceTypeList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getInvoiceTypeList", p_op_name, g_request, g_response)
      #FUN-BA0002 add end---

      #add huxy160612-----beg----------
      WHEN "aws_getPlant"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPlant", p_op_name, g_request, g_response)
      WHEN "aws_loginCheck"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_loginCheck", p_op_name, g_request, g_response)
      #add huxy160612-----end----------

      #WHEN "aws_getBomData" #FUN-A10061 mark
       WHEN "aws_getBOMData" #FUN-A10061 add
           #LET l_op = com.WebOperation.CreateDOCStyle("aws_getBomData", p_op_name, g_request, g_response) #FUN-A10061 mark
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getBOMData", p_op_name, g_request, g_response) #FUN-A10061 add

       WHEN "aws_getDocumentNumber"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getDocumentNumber", p_op_name, g_request, g_response)

       WHEN "aws_createCustomerData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createCustomerData", p_op_name, g_request, g_response)

       WHEN "aws_createQuotationData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createQuotationData", p_op_name, g_request, g_response)

       WHEN "aws_createItemMasterData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createItemMasterData", p_op_name, g_request, g_response)

       WHEN "aws_createVendorData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createVendorData", p_op_name, g_request, g_response)

       WHEN "aws_createEmployeeData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createEmployeeData", p_op_name, g_request, g_response)

       WHEN "aws_createAddressData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createAddressData", p_op_name, g_request, g_response)

       WHEN "aws_getInspectionData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getInspectionData", p_op_name, g_request, g_response)

       WHEN "aws_getAreaData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getAreaData", p_op_name, g_request, g_response)

       WHEN "aws_getAccountSubjectData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getAccountSubjectData", p_op_name, g_request, g_response)

       WHEN "aws_getComponentrepsubData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getComponentrepsubData", p_op_name, g_request, g_response)

       WHEN "aws_getAxmDocument"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getAxmDocument", p_op_name, g_request, g_response)

       WHEN "aws_getAreaList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getAreaList", p_op_name, g_request, g_response)

       WHEN "aws_getCostGroupData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCostGroupData", p_op_name, g_request, g_response)

       WHEN "aws_getCountryData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCountryData", p_op_name, g_request, g_response)

       WHEN "aws_getCountryList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCountryList", p_op_name, g_request, g_response)

       WHEN "aws_getCurrencyData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCurrencyData", p_op_name, g_request, g_response)

       WHEN "aws_getCurrencyList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCurrencyList", p_op_name, g_request, g_response)

       WHEN "aws_getCustList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCustList", p_op_name, g_request, g_response)

       WHEN "aws_getCustomerData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCustomerData", p_op_name, g_request, g_response)

       WHEN "aws_getCustomerProductData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCustomerProductData", p_op_name, g_request, g_response)

       WHEN "aws_getDepartmentData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getDepartmentData", p_op_name, g_request, g_response)

       WHEN "aws_getDepartmentList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getDepartmentList", p_op_name, g_request, g_response)

       WHEN "aws_getEmployeeData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getEmployeeData", p_op_name, g_request, g_response)

       WHEN "aws_getEmployeeList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getEmployeeList", p_op_name, g_request, g_response)

       WHEN "aws_getItemList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getItemList", p_op_name, g_request, g_response)

       WHEN "aws_getMonthList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getMonthList", p_op_name, g_request, g_response)

       WHEN "aws_getOrganizationList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getOrganizationList", p_op_name, g_request, g_response)

       WHEN "aws_getOverdueAmtRankingData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getOverdueAmtRankingData", p_op_name, g_request, g_response)

       WHEN "aws_getOverdueAmtDetailData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getOverdueAmtDetailData", p_op_name, g_request, g_response)

       WHEN "aws_getProdClassList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getProdClassList", p_op_name, g_request, g_response)

       WHEN "aws_getSalesDetailData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getSalesDetailData", p_op_name, g_request, g_response)

       WHEN "aws_getSalesStatisticsData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getSalesStatisticsData", p_op_name, g_request, g_response)

       WHEN "aws_getSOInfoData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getSOInfoData", p_op_name, g_request, g_response)

       WHEN "aws_getSOInfoDetailData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getSOInfoDetailData", p_op_name, g_request, g_response)

       WHEN "aws_getSupplierData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getSupplierData", p_op_name, g_request, g_response)

       WHEN "aws_getSupplierItemData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getSupplierItemData", p_op_name, g_request, g_response)

       WHEN "aws_createBOMData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createBOMData", p_op_name, g_request, g_response)

       WHEN "aws_getOperationDataa"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getOperationDataa", p_op_name, g_request, g_response)

       WHEN "aws_getUnitData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getUnitData", p_op_name, g_request, g_response)

       WHEN "aws_getBasicCodeData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getBasicCodeData", p_op_name, g_request, g_response)

       WHEN "aws_getWarehouseData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getWarehouseData", p_op_name, g_request, g_response)

       WHEN "aws_getLocationData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getLocationData", p_op_name, g_request, g_response)

       WHEN "aws_getProductClassData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getProductClassData", p_op_name, g_request, g_response)

       WHEN "aws_createIssueReturnData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createIssueReturnData", p_op_name, g_request, g_response)

       WHEN "aws_createStockInData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createStockInData", p_op_name, g_request, g_response)

       WHEN "aws_getUserToken"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getUserToken", p_op_name, g_request, g_response)

       WHEN "aws_checkUserAuth"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_checkUserAuth", p_op_name, g_request, g_response)

       WHEN "aws_getMenuData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getMenuData", p_op_name, g_request, g_response)

       WHEN "aws_CheckExecAuthorization"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_CheckExecAuthorization", p_op_name, g_request, g_response)

       WHEN "aws_createPOReceivingData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createPOReceivingData", p_op_name, g_request, g_response)

       WHEN "aws_createPurchaseStockIn"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createPurchaseStockIn", p_op_name, g_request, g_response)

       WHEN "aws_createPurchaseStockOut"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createPurchaseStockOut", p_op_name, g_request, g_response)

       WHEN "aws_createWOStockinData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createWOStockinData", p_op_name, g_request, g_response)

       WHEN "aws_getCountingLabelData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCountingLabelData", p_op_name, g_request, g_response)

       WHEN "aws_getFQCData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getFQCData", p_op_name, g_request, g_response)

       WHEN "aws_getItemStockList"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getItemStockList", p_op_name, g_request, g_response)

       WHEN "aws_getLabelTypeData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getLabelTypeData", p_op_name, g_request, g_response)

       WHEN "aws_getMFGDocument"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getMFGDocument", p_op_name, g_request, g_response)

       WHEN "aws_getPOData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPOData", p_op_name, g_request, g_response)

       WHEN "aws_getPOReceivingInData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPOReceivingInData", p_op_name, g_request, g_response)

       WHEN "aws_getPOReceivingOutData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPOReceivingOutData", p_op_name, g_request, g_response)

       WHEN "aws_getPurchaseStockInQty"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPurchaseStockInQty", p_op_name, g_request, g_response)

       WHEN "aws_getPurchaseStockOutQty"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPurchaseStockOutQty", p_op_name, g_request, g_response)

       WHEN "aws_getReasonCode"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getReasonCode", p_op_name, g_request, g_response)

       WHEN "aws_getReceivingQty"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getReceivingQty", p_op_name, g_request, g_response)

       WHEN "aws_getStockData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getStockData", p_op_name, g_request, g_response)

       WHEN "aws_getWOData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getWOData", p_op_name, g_request, g_response)

       WHEN "aws_getWOIssueData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getWOIssueData", p_op_name, g_request, g_response)

       WHEN "aws_getWOStockQty"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getWOStockQty", p_op_name, g_request, g_response)

       WHEN "aws_updateCountingLabelData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_updateCountingLabelData", p_op_name, g_request, g_response)

       WHEN "aws_updateWOIssueData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_updateWOIssueData", p_op_name, g_request, g_response)

       WHEN "aws_createSalesRetur"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createSalesRetur", p_op_name, g_request, g_response)

       WHEN "aws_createShippingOrder"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createShippingOrder", p_op_name, g_request, g_response)

       WHEN "aws_createTransferNote"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createTransferNote", p_op_name, g_request, g_response)

       WHEN "aws_getQtyConversion"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getQtyConversion", p_op_name, g_request, g_response)

       WHEN "aws_getSalesDocument"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getSalesDocument", p_op_name, g_request, g_response)

       WHEN "aws_getShippingNoticeData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getShippingNoticeData", p_op_name, g_request, g_response)

       WHEN "aws_getShippingOrderData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getShippingOrderData", p_op_name, g_request, g_response)

       WHEN "aws_createStockData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createStockData", p_op_name, g_request, g_response)

       WHEN "aws_CreateMISCIssueData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_CreateMISCIssueData", p_op_name, g_request, g_response)

       WHEN "aws_runCommand"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_runCommand", p_op_name, g_request, g_response)

       WHEN "aws_EboGetCustData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_EboGetCustData", p_op_name, g_request, g_response)

       WHEN "aws_EboGetProdData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_EboGetProdData", p_op_name, g_request, g_response)

       WHEN "aws_EboGetOrderData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_EboGetOrderData", p_op_name, g_request, g_response)

       WHEN "aws_CheckApsExecution"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_CheckApsExecution", p_op_name, g_request, g_response)

       WHEN "aws_getReportData"                          #FUN-A50022  新增GetReportData服務
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getReportData", p_op_name, g_request, g_response)

      #FUN-930139 add str----------------
       WHEN "aws_getCustomerContactData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCustomerContactData", p_op_name, g_request, g_response)
       WHEN "aws_getCustomerOtheraddressData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCustomerOtheraddressData", p_op_name, g_request, g_response)
       WHEN "aws_getPackingMethodData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPackingMethodData", p_op_name, g_request, g_response)
       WHEN "aws_getTaxTypeData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getTaxTypeData", p_op_name, g_request, g_response)
       WHEN "aws_getUnitConversionData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getUnitConversionData", p_op_name, g_request, g_response)
       WHEN "aws_getMFGSettingSmaData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getMFGSettingSmaData", p_op_name, g_request, g_response)
       WHEN "aws_createPotentialCustomerData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createPotentialCustomerData", p_op_name, g_request, g_response)
       WHEN "aws_createCustomerContactData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createCustomerContactData", p_op_name, g_request, g_response)
       WHEN "aws_createCustomerOtheraddressData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createCustomerOtheraddressData", p_op_name, g_request, g_response)
       WHEN "aws_CRMgetCustomerData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_CRMgetCustomerData", p_op_name, g_request, g_response)
       WHEN "aws_getPotentialCustomerData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPotentialCustomerData", p_op_name, g_request, g_response)
       WHEN "aws_getTableAmendmentData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getTableAmendmentData", p_op_name, g_request, g_response)
      #FUN-930139 add end----------------
      #FUN-AA0022 add str----------------
       WHEN "aws_getAccountTypeData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getAccountTypeData", p_op_name, g_request, g_response)
       WHEN "aws_getAccountData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getAccountData", p_op_name, g_request, g_response)
       WHEN "aws_createVoucherData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createVoucherData", p_op_name, g_request, g_response)
       WHEN "aws_getVoucherDocumentData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getVoucherDocumentData", p_op_name, g_request, g_response)
       WHEN "aws_getTransactionCategory"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getTransactionCategory", p_op_name, g_request, g_response)
       WHEN "aws_createBillingAP"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createBillingAP", p_op_name, g_request, g_response)
       WHEN "aws_createDepartmentData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createDepartmentData", p_op_name, g_request, g_response)
       WHEN "aws_rollbackVoucherData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_rollbackVoucherData", p_op_name, g_request, g_response)
      #FUN-AA0022 add end----------------
       WHEN "aws_getPaymentTermsData"                                                                                #FUN-Ac0068 add 
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPaymentTermsData", p_op_name, g_request, g_response)  #FUN-AC0068 add
       WHEN "aws_createShippingOrdersWithoutOrders"                                                                                #FUN-B10004 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createShippingOrdersWithoutOrders", p_op_name, g_request, g_response)  #FUN-B10004 add
       WHEN "aws_getSSOKey"                                                                                          #FUN-B10003 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getSSOKey", p_op_name, g_request, g_response)            #FUN-B10003 add           
       WHEN "aws_getItemGroupData"                                                                                   #FUN-B30026 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getItemGroupData", p_op_name, g_request, g_response)     #FUN-B30026 add
       WHEN "aws_getItemOtherGroupData"                                                                                   #FUN-B30147 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getItemOtherGroupData", p_op_name, g_request, g_response)     #FUN-B30147 add

      #FUN-A20026 add begin---------------
       WHEN "aws_getWorkstationData"                                                                                   
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getWorkstationData", p_op_name, g_request, g_response)    
       WHEN "aws_getMachineData"                                                                                  
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getMachineData", p_op_name, g_request, g_response)     
       WHEN "aws_getProdRoutingData"                                                                                   
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getProdRoutingData", p_op_name, g_request, g_response)     
      #FUN-A20026 add end-----------------
             
      #FUN-B40072 add begin----------------             
       WHEN "aws_getProdState"                                                                                      
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getProdState", p_op_name, g_request, g_response)        
       WHEN "aws_getProdInfo"                                                                                       
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getProdInfo", p_op_name, g_request, g_response)         
       WHEN "aws_getOnlineUser"                                                                                     
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getOnlineUser", p_op_name, g_request, g_response)       
      #FUN-B40072 add ending----------------

      #FUN-B10037 add begin-----------------
       WHEN "aws_createWOWorkReportData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createWOWorkReportData", p_op_name, g_request, g_response)
      #FUN-B10037 add ending----------------

      #FUN-B60003 add str-------
       WHEN "aws_getMemberData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getMemberData", p_op_name, g_request, g_response)
       WHEN "aws_getCardDetailData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCardDetailData", p_op_name, g_request, g_response)
      #FUN-B60003 add end------- 

       WHEN "aws_createSupplierItemData"                                                                                #FUN-A70142 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createSupplierItemData", p_op_name, g_request, g_response)  #FUN-A70142 add
       WHEN "aws_createItemApprovalData"                                                                                #FUN-A80131 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createItemApprovalData", p_op_name, g_request, g_response)  #FUN-A80131 add
       WHEN "aws_getBrandData"                                                                                          #FUN-A80127 add 
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getBrandData", p_op_name, g_request, g_response)            #FUN-A80127 add
       WHEN "aws_createRepSubPBOMData"                                                                                  #FUN-A70147 add   
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createRepSubPBOMData", p_op_name, g_request, g_response)    #FUN-A70147 add
       WHEN "aws_createECNData"                                                                                         #FUN-A80017 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createECNData", p_op_name, g_request, g_response)           #FUN-A80017 add
       WHEN "aws_createPLMBOMData"                                                                                      #FUN-B20003 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createPLMBOMData", p_op_name, g_request, g_response)        #FUN-B20003 add
       WHEN "aws_getCustomerAccAmtData"                                                                                 #FUN-B80168 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCustomerAccAmtData", p_op_name, g_request, g_response)   #FUN-B80168 add
       WHEN "aws_syncAccountData"                                                                                       #FUN-B60090 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_syncAccountData", p_op_name, g_request, g_response)         #FUN-B60090 add
       WHEN "aws_syncEncodingState"                                                                                     #FUN-BB0161 add
            LET l_op = com.WebOperation.CreateDOCStyle("aws_syncEncodingState", p_op_name, g_request, g_response)       #FUN-BB0161 add

       #FUN-C50138 add begin----------------
       WHEN "aws_modPassWord"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_modPassWord", p_op_name, g_request, g_response)     
       WHEN "aws_getMemberCardInfo"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getMemberCardInfo", p_op_name, g_request, g_response)     
       WHEN "aws_writePoint"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_writePoint", p_op_name, g_request, g_response)     
       WHEN "aws_getCashCardInfo"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getCashCardInfo", p_op_name, g_request, g_response)     
       WHEN "aws_deductMoney"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_deductMoney", p_op_name, g_request, g_response)
       WHEN "aws_checkGiftNo"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_checkGiftNo", p_op_name, g_request, g_response)
       WHEN "aws_deductGiftNO"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_deductGiftNO", p_op_name, g_request, g_response)
       WHEN "aws_getScore"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getScore", p_op_name, g_request, g_response)
       WHEN "aws_deductScore"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_deductScore", p_op_name, g_request, g_response)
       WHEN "aws_deductPayment"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_deductPayment", p_op_name, g_request, g_response)
       #FUN-C50138 add end------------------

       #FUN-B90089 add str--- 
        WHEN "aws_getDataCount"
           LET l_op = com.WebOperation.CreateDOCStyle("aws_getDataCount", p_op_name, g_request, g_response) 
        WHEN "aws_getUserDefOrg"
           LET l_op = com.WebOperation.CreateDOCStyle("aws_getUserDefOrg", p_op_name, g_request, g_response)
        WHEN "aws_getSOData"
           LET l_op = com.WebOperation.CreateDOCStyle("aws_getSOData", p_op_name, g_request, g_response)
        WHEN "aws_getShappingData"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getShappingData", p_op_name, g_request, g_response)
        WHEN "aws_getQuotationData"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getQuotationData", p_op_name, g_request, g_response)
       #FUN-B90089 add end--- 

       #FUN-CA0090 Add Begin ---
        WHEN "aws_getCardScore" #取會員可扣減積分
           LET l_op = com.WebOperation.CreateDOCStyle("aws_getCardScore", p_op_name, g_request, g_response)
        WHEN "aws_rechargeCard" #取儲值卡充值信息
           LET l_op = com.WebOperation.CreateDOCStyle("aws_rechargeCard", p_op_name, g_request, g_response)
        WHEN "aws_selCardInfo"  #取儲值卡餘額信息
           LET l_op = com.WebOperation.CreateDOCStyle("aws_selCardInfo", p_op_name, g_request, g_response)
        WHEN "aws_checkCard"    #取會員卡金額
           LET l_op = com.WebOperation.CreateDOCStyle("aws_checkCard", p_op_name, g_request, g_response)
        WHEN "aws_changeCard"   #取會員换卡信息
           LET l_op = com.WebOperation.CreateDOCStyle("aws_changeCard", p_op_name, g_request, g_response)
        WHEN "aws_checkCoupon"  #取售券退券信息
           LET l_op = com.WebOperation.CreateDOCStyle("aws_checkCoupon", p_op_name, g_request, g_response)
        WHEN "aws_checkCardType"#取會員卡卡种
           LET l_op = com.WebOperation.CreateDOCStyle("aws_checkCardType", p_op_name, g_request, g_response)
        WHEN "aws_returnCard"   #取退卡金额
           LET l_op = com.WebOperation.CreateDOCStyle("aws_returnCard", p_op_name, g_request, g_response)
       #FUN-CA0090 Add End -----
        WHEN "aws_returnOrderBill" #取訂單是否可退信息                                                           #FUN-CB0104 add
           LET l_op = com.WebOperation.CreateDOCStyle("aws_returnOrderBill", p_op_name, g_request, g_response)   #FUN-CB0104 add
        WHEN "aws_getOrderInfo"    #取訂單信息                                                                   #FUN-CB0104 add
           LET l_op = com.WebOperation.CreateDOCStyle("aws_getOrderInfo", p_op_name, g_request, g_response)      #FUN-CB0104 add
      #FUN-C50126 add str---
       WHEN "aws_getAPCategoryAccountCode"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getAPCategoryAccountCode", p_op_name, g_request, g_response)
      #FUN-C50126 add end---
      #FUN-C80078 add str---
       WHEN "aws_rollbackBillingAP"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_rollbackBillingAP", p_op_name, g_request, g_response)
      #FUN-C80078 add end---
        #FUN-CC0135 add str---
        WHEN "aws_checkMemberUpgrade" #取会员是否可以升等信息
           LET l_op = com.WebOperation.CreateDOCStyle("aws_checkMemberUpgrade", p_op_name, g_request, g_response)
        WHEN "aws_memberUpgrade"      #取会员升等是否成功信息
           LET l_op = com.WebOperation.CreateDOCStyle("aws_memberUpgrade", p_op_name, g_request, g_response)
        #FUN-CC0135 add end---
      #FUN-D10092 add str---
       WHEN "aws_createPLMTempTableData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createPLMTempTableData", p_op_name, g_request, g_response)
       WHEN "aws_getPLMTempTableDataStatus"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getPLMTempTableDataStatus", p_op_name, g_request, g_response)
       WHEN "aws_deletePLMTempTableData"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_deletePLMTempTableData", p_op_name, g_request, g_response)
      #FUN-D10092 add end---

      #str---add-guanyao160603
       WHEN "get_start_works"
            LET l_op = com.WebOperation.CreateDOCStyle("get_start_works", p_op_name, g_request, g_response) 
      #end---add-guanyao160602
      #str---add-guanyao160606
       WHEN "create_work"
            LET l_op = com.WebOperation.CreateDOCStyle("create_work", p_op_name, g_request, g_response) 
       WHEN "get_finish_works"
            LET l_op = com.WebOperation.CreateDOCStyle("get_finish_works", p_op_name, g_request, g_response) 
       WHEN "create_finish_work"
            LET l_op = com.WebOperation.CreateDOCStyle("create_finish_work", p_op_name, g_request, g_response)
      #end---add-guanyao160606
      #str---add by guanyao160607
       WHEN "create_scan"
            LET l_op = com.WebOperation.CreateDOCStyle("create_scan", p_op_name, g_request, g_response)

       WHEN "create_scan_out"
            LET l_op = com.WebOperation.CreateDOCStyle("create_scan_out", p_op_name, g_request, g_response)
      #end---add by guanyao160607
      #str---add by guanyao160718
       WHEN "get_password"
            LET l_op = com.WebOperation.CreateDOCStyle("get_password", p_op_name, g_request, g_response)
      #end---add by guanyao160718
   
       #add huxy160727--------Beg------
       WHEN "aws_GetAppver"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_GetAppver", p_op_name, g_request, g_response)
       #add huxy160727--------End------
       #str-----add by guanyao160805
       WHEN "get_lot"
            LET l_op = com.WebOperation.CreateDOCStyle("get_lot", p_op_name, g_request, g_response)
       #end-----add by guanyao160805
       #add by shenran 2016-08-03 14:15:19 �������� str
   #    WHEN "aws_GetAppver"
   #         LET l_op = com.WebOperation.CreateDOCStyle("aws_GetAppver", p_op_name, g_request, g_response)   
   #    WHEN "aws_loginCheck"
   #         LET l_op = com.WebOperation.CreateDOCStyle("aws_loginCheck", p_op_name, g_request, g_response)  
   #    WHEN "aws_getPlant"
   #         LET l_op = com.WebOperation.CreateDOCStyle("aws_getPlant", p_op_name, g_request, g_response)
       WHEN "aws_getAimt302"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getAimt302", p_op_name, g_request, g_response)
       WHEN "aws_createAimt302"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createAimt302", p_op_name, g_request, g_response)
       WHEN "aws_createAimt301"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createAimt301", p_op_name, g_request, g_response)
       WHEN "aws_getMove"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getMove", p_op_name, g_request, g_response)
       WHEN "aws_createMove"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createMove", p_op_name, g_request, g_response)
       WHEN "aws_getCheckGoodsIn"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getCheckGoodsIn", p_op_name, g_request, g_response)
       WHEN "aws_updateReceipt"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_updateReceipt", p_op_name, g_request, g_response)
       WHEN "aws_getRecieveGoodsIn"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getRecieveGoodsIn", p_op_name, g_request, g_response)
       WHEN "aws_getTlfb100"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getTlfb100", p_op_name, g_request, g_response)
       WHEN "aws_createTlfb100"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createTlfb100", p_op_name, g_request, g_response)
       WHEN "aws_getAsfi301"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getAsfi301", p_op_name, g_request, g_response)
       WHEN "aws_getTlfb510"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getTlfb510", p_op_name, g_request, g_response)
       WHEN "aws_createTlfb510"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createTlfb510", p_op_name, g_request, g_response)
       WHEN "aws_getAllot"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getAllot", p_op_name, g_request, g_response)
       WHEN "aws_getAllotAgain"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getAllotAgain", p_op_name, g_request, g_response)
       WHEN "aws_updateAllot"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_updateAllot", p_op_name, g_request, g_response)
       WHEN "aws_updateAllotAgain"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_updateAllotAgain", p_op_name, g_request, g_response)
       WHEN "aws_getAsft620"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getAsft620", p_op_name, g_request, g_response) 
       WHEN "aws_updateAsft620"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_updateAsft620", p_op_name, g_request, g_response)
       WHEN "aws_getFifo1"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getFifo1", p_op_name, g_request, g_response)
       WHEN "aws_getFifo2"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getFifo2", p_op_name, g_request, g_response)
       WHEN "aws_getFifo3"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getFifo3", p_op_name, g_request, g_response)
       WHEN "aws_getFifo4"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getFifo4", p_op_name, g_request, g_response)
       WHEN "aws_createTlfb520"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createTlfb520", p_op_name, g_request, g_response)
       WHEN "aws_getCxmt620"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getCxmt620", p_op_name, g_request, g_response)
       WHEN "aws_createCxmt620"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createCxmt620", p_op_name, g_request, g_response)
       WHEN "aws_getInventory"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getInventory", p_op_name, g_request, g_response) 
       WHEN "aws_createInventory"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createInventory", p_op_name, g_request, g_response)
       WHEN "aws_getDeliverymei"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getDeliverymei", p_op_name, g_request, g_response)
       WHEN "aws_createApmt110mei"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createApmt110mei", p_op_name, g_request, g_response)
       WHEN "aws_getReceiptmei"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getReceiptmei", p_op_name, g_request, g_response)
       WHEN "aws_createApmt720mei"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createApmt720mei", p_op_name, g_request, g_response)
       WHEN "aws_getTransfermei"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getTransfermei", p_op_name, g_request, g_response)
       WHEN "aws_createAimt324mei"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createAimt324mei", p_op_name, g_request, g_response)
       WHEN "aws_getApmt110"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getApmt110", p_op_name, g_request, g_response)
     #  WHEN "get_start_works"
     #        LET l_op = com.WebOperation.CreateDOCStyle("get_start_works", p_op_name, g_request, g_response) 
     #  WHEN "create_work"
     #        LET l_op = com.WebOperation.CreateDOCStyle("create_work", p_op_name, g_request, g_response)
     #  WHEN "get_finish_works"
     #        LET l_op = com.WebOperation.CreateDOCStyle("get_finish_works", p_op_name, g_request, g_response)
     #  WHEN "create_scan"
     #        LET l_op = com.WebOperation.CreateDOCStyle("create_scan", p_op_name, g_request, g_response)
     #  WHEN "create_scan_out"
     #        LET l_op = com.WebOperation.CreateDOCStyle("create_scan_out", p_op_name, g_request, g_response)
#       WHEN "aws_getIma"
#             LET l_op = com.WebOperation.CreateDOCStyle("aws_getIma", p_op_name, g_request, g_response)
       WHEN "aws_getProcess"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getProcess", p_op_name, g_request, g_response) 
#       WHEN "aws_createAxmt410"
#             LET l_op = com.WebOperation.CreateDOCStyle("aws_createAxmt410", p_op_name, g_request, g_response)
#       WHEN "aws_createShopping"
#             LET l_op = com.WebOperation.CreateDOCStyle("aws_createShopping", p_op_name, g_request, g_response)
#       WHEN "aws_getMessage"
#             LET l_op = com.WebOperation.CreateDOCStyle("aws_getMessage", p_op_name, g_request, g_response)
#       WHEN "aws_createAdd"
#             LET l_op = com.WebOperation.CreateDOCStyle("aws_createAdd", p_op_name, g_request, g_response)
#       WHEN "aws_deleteAxmt410"
#             LET l_op = com.WebOperation.CreateDOCStyle("aws_deleteAxmt410", p_op_name, g_request, g_response)
       WHEN "aws_getImgb03"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getImgb03", p_op_name, g_request, g_response)
       WHEN "aws_createArts"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createArts", p_op_name, g_request, g_response)
       WHEN "aws_createCheck"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createCheck", p_op_name, g_request, g_response)
       WHEN "aws_createAsft620"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createAsft620", p_op_name, g_request, g_response)
       WHEN "aws_createApmt720"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createApmt720", p_op_name, g_request, g_response)
       WHEN "aws_getPicture"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getPicture", p_op_name, g_request, g_response)
#       WHEN "aws_getJob"
#             LET l_op = com.WebOperation.CreateDOCStyle("aws_getJob", p_op_name, g_request, g_response)
       WHEN "aws_getImgb"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getImgb", p_op_name, g_request, g_response)
       WHEN "aws_getImg"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getImg", p_op_name, g_request, g_response)
       WHEN "aws_createApmt110"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createApmt110", p_op_name, g_request, g_response)
       WHEN "aws_createAsfi510"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_createAsfi510", p_op_name, g_request, g_response)
       WHEN "aws_getCheck"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getCheck", p_op_name, g_request, g_response)
       WHEN "aws_getWork"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getWork", p_op_name, g_request, g_response)
#       WHEN "aws_getDelivery"
#             LET l_op = com.WebOperation.CreateDOCStyle("aws_getDelivery", p_op_name, g_request, g_response)
       WHEN "aws_getReason"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getReason", p_op_name, g_request, g_response)
       WHEN "aws_getArts"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_getArts", p_op_name, g_request, g_response)
      WHEN "aws_getAsfi528"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getAsfi528",p_op_name,g_request, g_response)
      #No:160807 add end------
      WHEN "aws_createAsfi528"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createAsfi528",p_op_name,g_request, g_response)      
      WHEN "aws_getApmt722"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getApmt722",p_op_name,g_request, g_response)
      WHEN "aws_createApmt722"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_createApmt722",p_op_name,g_request, g_response)                                             
      #add by shenran 2016-08-03 14:15:19 �������� end 
	  #add by nihuan 20170508-----------start---------------
	  WHEN "aws_gettransferdata"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_gettransferdata",p_op_name,g_request, g_response)
	  WHEN "aws_getitemno"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getitemno",p_op_name,g_request, g_response)
	  WHEN "aws_gettcimnFifo"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_gettcimnFifo",p_op_name,g_request, g_response)
	  WHEN "aws_csft512s"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_csft512s",p_op_name,g_request, g_response)
	  WHEN "aws_asfi511s"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_asfi511s",p_op_name,g_request, g_response)
	  WHEN "aws_asfi511s"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_asfi511s",p_op_name,g_request, g_response)
	  #生产超领查询
       WHEN "cws_query_asfi512"
            LET l_op = com.WebOperation.CreateDOCStyle("cws_query_asfi512", p_op_name, g_request, g_response)
       #生产超领过账
       WHEN "cws_upd_asfi512"
            LET l_op = com.WebOperation.CreateDOCStyle("cws_upd_asfi512", p_op_name, g_request, g_response)
    #一般出货查询 cws_get_axmt620
       WHEN "cws_get_axmt620"
            LET l_op = com.WebOperation.CreateDOCStyle("cws_get_axmt620", p_op_name, g_request, g_response)
       #一般出货过账 cws_upd_asft670
        WHEN "aws_updaxmt620"
             LET l_op = com.WebOperation.CreateDOCStyle("aws_updaxmt620", p_op_name, g_request, g_response)
    #调拨单查询 	cws_get_aimt324
       WHEN "get_aimt324"
            LET l_op = com.WebOperation.CreateDOCStyle("get_aimt324", p_op_name, g_request, g_response)
       #调拨单过账 	cws_post_aimt324
       WHEN "post_aimt324"
            LET l_op = com.WebOperation.CreateDOCStyle("post_aimt324", p_op_name, g_request, g_response)
    #杂发单信息查询 cws_get_aimt301
       WHEN "cws_get_aimt301"
            LET l_op = com.WebOperation.CreateDOCStyle("cws_get_aimt301", p_op_name, g_request, g_response)
       WHEN "cws_upd_aimt301"
            LET l_op = com.WebOperation.CreateDOCStyle("cws_upd_aimt301", p_op_name, g_request, g_response)
    #杂收单查询 	cws_get_aimt302
       WHEN "get_aimt302"
            LET l_op = com.WebOperation.CreateDOCStyle("get_aimt302", p_op_name, g_request, g_response)
       #杂收单过账(有源) 	cws_post_aimt302
       WHEN "post_aimt302"
            LET l_op = com.WebOperation.CreateDOCStyle("post_aimt302", p_op_name, g_request, g_response)
                
	     WHEN "aws_gettransferdatadetail"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_gettransferdatadetail", p_op_name, g_request, g_response)
       WHEN "aws_getaxmt700data"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getaxmt700data", p_op_name, g_request, g_response)
       WHEN "aws_getaxmt700datadetail"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_getaxmt700datadetail", p_op_name, g_request, g_response)
       WHEN "aws_updaxmt700"
            LET l_op = com.WebOperation.CreateDOCStyle("aws_updaxmt700", p_op_name, g_request, g_response)
       
       
	  #add by nihuan 20170508-----------end---------------
	  
       END CASE

    RETURN l_op
    #FUN-A40084 -- end -- 

END FUNCTION
 
#No.FUN-8A0112 BEGIN->
#------------------------------------------------------------------------------#
# TIPTOP通用集成接口是為實現本公司內部產品之間的數據交換和服務調用而設計       #
# 并可作為各產品統一的外部接口與其他多個系統進行集成，而不用每次都撰寫單       #
# 獨的集成程序                                                                 #
#------------------------------------------------------------------------------#
 
#TIPTOP通用集成接口                                              
FUNCTION TIPTOPGateWay()                                                                                                                                                                  
    LET g_service = "TIPTOPGateWay"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱 
    CALL aws_ttsrv2_GateWay()                                                    
                                                                                
END FUNCTION
#No.FUN-8A0112 <-END

#No.FUN-B20029  -- start --
#CROSS整合, 提供服務呼叫
FUNCTION aws_invokeSrv()

   LET g_service = "invokeSrv"
   CALL aws_invoke_srv()

END FUNCTION

#提供 CROSS 平台回覆非同步、ETL等執行結果
FUNCTION aws_callbackSrv()

   LET g_service = "callbackSrv"

END FUNCTION

#提供 CROSS 索取註冊資訊、整合設定同步
FUNCTION aws_syncProd()

   LET g_service = "syncProd"
   CALL aws_sync_prod()

END FUNCTION

#提供 CROSS MDM 系統進行資料同步
FUNCTION aws_invokeMdm()    #FUN-B50032

   LET g_service = "invokeMdm"   #FUN-B50032
   CALL aws_invoke_mdm()         #FUN-B50032
END FUNCTION
#FUN-B30147 add end --------
#No.FUN-B20029  -- end --
 
#------------------------------------------------------------------------------#
# 請新增每一個 ERP 服務時, 於以下加入被指定呼叫的 4GL Service Function 段落    #
# 真正實作的程式邏輯, 可另定義於另外的 4GL source, 並由此處呼叫                #
# 此處定義的 Function Name 必須與設定作業中輸入的一致(否則執行時將報錯)        #
#------------------------------------------------------------------------------#
 
#取得 ERP 料件資料的服務(單檔範例)
FUNCTION aws_getItemData()
 
    
    LET g_service = "GetItemData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_item_data()
 
END FUNCTION
 
#FUN-BA0002 add str---
#取得客戶類別資料的服務
FUNCTION aws_getCustClassificationData()
    
    LET g_service = "GetCustClassificationData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_cust_classification_data()
 
END FUNCTION

#取得銷售價格條件資料的服務
FUNCTION aws_getTradeTermData()
    
    LET g_service = "GetTradeTermData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_trade_term_data()
 
END FUNCTION

#取得發票別清單的服務
FUNCTION aws_getInvoiceTypeList()
    
    LET g_service = "GetInvoiceTypeList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_invoice_type_list()
 
END FUNCTION
#FUN-BA0002 add end---
 
#取得 ERP BOM 資料的服務(雙檔範例)
FUNCTION aws_getBOMData() #FUN-A10061 mod
 
    
   #LET g_service = "GetBomData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱 #FUN-A10061 mark
    LET g_service = "GetBOMData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱 #FUN-A10061 add
    CALL aws_get_bom_data()
 
END FUNCTION
 
 
#自動取單號的服務(參數回傳範例)
FUNCTION aws_getDocumentNumber()
 
    
    LET g_service = "GetDocumentNumber"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_doc_no()
 
END FUNCTION
 
 
#建立客戶資料的服務(單檔建立範例)
FUNCTION aws_createCustomerData()
 
    
    LET g_service = "CreateCustomerData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_create_customer_data()
 
END FUNCTION
 
 
#建立報價單資料的服務(雙檔建立範例)
FUNCTION aws_createQuotationData()
 
    
    LET g_service = "CreateQuotationData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_create_quotation_data()
 
END FUNCTION
 
#建立料件主檔資料的服務 #FUN-860036
FUNCTION aws_createItemMasterData()
   
    LET g_service = "CreateItemMasterData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_create_itemmaster_data()
 
END FUNCTION
 
#建立廠商主檔資料的服務 #FUN-860036
FUNCTION aws_createVendorData()
 
    LET g_service = "CreateVendorData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_create_vendor_data()
 
END FUNCTION
 
#建立員工主檔資料的服務 #FUN-860036
FUNCTION aws_createEmployeeData()
   
    LET g_service = "CreateEmployeeData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_create_employee_data()
 
END FUNCTION
 
#建立客戶其他地址資料的服務 #FUN-860036
FUNCTION aws_createAddressData()
   
    LET g_service = "CreateAddressData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_create_address_data()
 
END FUNCTION
 
#FUN-850022
#回傳檢驗碼(rvb39)
FUNCTION aws_getInspectionData()
 
   LET g_service = "GetInspectionData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_inspection_data()
 
END FUNCTION
 
#FUN-860037 begin
#查詢 ERP 區域別編號
FUNCTION aws_getAreaData()
 
   LET g_service = "GetAreaData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_area_data()
 
END FUNCTION
 
#取得 ERP 會計科目資料服務
FUNCTION aws_getAccountSubjectData()
 
   LET g_service = "GetAccountSubjectData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_account_subject_data()
 
END FUNCTION
 
#取得 ERP 替代料資料服務
FUNCTION aws_getComponentrepsubData()
 
   LET g_service = "GetComponentrepsubData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_componentrepsub_data()
 
END FUNCTION
 
#取得 ERP 銷售系統單別服務
FUNCTION aws_getAxmDocument()
 
   LET g_service = "GetAxmDocument"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_axm_document()
 
END FUNCTION
 
#取得 ERP 區域代碼服務
FUNCTION aws_getAreaList()
 
   LET g_service = "GetAreaList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_area_list()
 
END FUNCTION
 
#取得 ERP 成本分群資料服務
FUNCTION aws_getCostGroupData()
 
   LET g_service = "GetCostGroupData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_cost_group_data()
 
END FUNCTION
 
#取得 ERP 國別資料服務
FUNCTION aws_getCountryData()
 
   LET g_service = "GetCountryData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_country_data()
 
END FUNCTION
 
#取得 ERP 國別代碼服務
FUNCTION aws_getCountryList()
 
   LET g_service = "GetCountryList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_country_list()
 
END FUNCTION
 
#取得 ERP 幣別資料服務
FUNCTION aws_getCurrencyData()
 
   LET g_service = "GetCurrencyData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_currency_data()
 
END FUNCTION
 
#取得 ERP 幣別代碼服務
FUNCTION aws_getCurrencyList()
 
   LET g_service = "GetCurrencyList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_currency_list()
 
END FUNCTION
 
#取得 ERP 客戶編號列表服務
FUNCTION aws_getCustList()
 
   LET g_service = "GetCustList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_cust_list()
 
END FUNCTION
 
#取得 ERP 客戶資料服務
FUNCTION aws_getCustomerData()
 
   LET g_service = "GetCustomerData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_customer_data()
 
END FUNCTION
 
#取得 ERP 產品客戶資料服務
FUNCTION aws_getCustomerProductData()
 
   LET g_service = "GetCustomerProductData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_customer_product_data()
 
END FUNCTION
 
#取得 ERP 部門資料服務
FUNCTION aws_getDepartmentData()
 
   LET g_service = "GetDepartmentData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_department_data()
 
END FUNCTION
 
#取得 ERP 部門編號列表服務
FUNCTION aws_getDepartmentList()
 
   LET g_service = "GetDepartmentList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_department_list()
 
END FUNCTION
 
#取得 ERP 員工資料服務
FUNCTION aws_getEmployeeData()
 
   LET g_service = "GetEmployeeData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_employee_data()
 
END FUNCTION
 
#取得 ERP 員工編號列表服務
FUNCTION aws_getEmployeeList()
 
   LET g_service = "GetEmployeeList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_employee_list()
 
END FUNCTION
 
#取得 ERP 料件編號列表服務
FUNCTION aws_getItemList()
 
   LET g_service = "GetItemList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_item_list()
 
END FUNCTION
 
#取得 ERP 月份列表服務
FUNCTION aws_getMonthList()
 
   LET g_service = "GetMonthList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_month_list()
 
END FUNCTION
 
#取得 ERP 營運中心代碼服務
FUNCTION aws_getOrganizationList()
 
   LET g_service = "GetOrganizationList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   LET g_non_plant = "Y" #880012
   CALL aws_get_organization_list()
 
END FUNCTION
 
#取得 ERP 逾期帳款排行
FUNCTION aws_getOverdueAmtRankingData()
 
   LET g_service = "GetOverdueAmtRankingData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_overdue_amt_ranking_data()
 
END FUNCTION
 
#取得 ERP 逾期帳款排行明細資料服務
FUNCTION aws_getOverdueAmtDetailData()
 
   LET g_service = "GetOverdueAmtDetailData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_overdue_amt_detail_data()
 
END FUNCTION
 
#取得 ERP 產品分類碼列表服務
FUNCTION aws_getProdClassList()
 
   LET g_service = "GetProdClassList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_prod_class_list()
 
END FUNCTION
 
#提供取得 ERP 銷售統計資料服務
FUNCTION aws_getSalesDetailData()
 
   LET g_service = "GetSalesDetailData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_sales_detail_data()
 
END FUNCTION
 
#取得ERP銷售統計資料
FUNCTION aws_getSalesStatisticsData()
 
   LET g_service = "GetSalesStatisticsData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_sales_statistics_data()
 
END FUNCTION
 
#取得ERP訂單資訊資料
FUNCTION aws_getSOInfoData()
 
   LET g_service = "GetSOInfoData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_so_info_data()
 
END FUNCTION
 
#取得ERP訂單資訊明細資料服務
FUNCTION aws_getSOInfoDetailData()
 
   LET g_service = "GetSOInfoDetailData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_so_info_detail_data()
 
END FUNCTION
 
#取得ERP 供應商資料服務
FUNCTION aws_getSupplierData()
 
   LET g_service = "GetSupplierData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  #FUN-AA0022---mod----str---
  #CALL aws_getSupplierData()
   CALL aws_get_supplier_data()
  #FUN-AA0022---mod----end---
 
END FUNCTION
 
#取得ERP 料件/供應商資料服務
FUNCTION aws_getSupplierItemData()
 
   LET g_service = "GetSupplierItemData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_supplier_item_data()
 
END FUNCTION
#FUN-860037 end --
 
#FUN-850147
#取得ERP 料件/供應商資料服務
FUNCTION aws_createBOMData()
 
   LET g_service = "CreateBOMData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_bom_data()
 
END FUNCTION
#END FUN-850147
 
#FUN-870028
FUNCTION aws_getOperationData() #作業編號
 
   LET g_service = "GetOperationData" 
   CALL aws_get_operation_data()
 
END FUNCTION
 
FUNCTION aws_getUnitData() #單位
 
   LET g_service = "GetUnitData" 
   CALL aws_get_unit_data()
 
END FUNCTION
 
FUNCTION aws_getBasicCodeData() #碼別代號
 
   LET g_service = "GetBasicCodeData" 
   CALL aws_get_basic_code_data()
 
END FUNCTION
 
FUNCTION aws_getWarehouseData() #倉庫代號
 
   LET g_service = "GetWarehouseData" 
   CALL aws_get_warehouse_data()
 
END FUNCTION
 
FUNCTION aws_getLocationData() #倉儲代號
 
   LET g_service = "GetLocationData" 
   CALL aws_get_location_data()
 
END FUNCTION
 
FUNCTION aws_getProductClassData() #產品分類
 
   LET g_service = "GetProductClassData" 
   CALL aws_get_product_class_data()
 
END FUNCTION
 
FUNCTION aws_createIssueReturnData() #MES產生退料單
 
   LET g_service = "CreateIssueReturnData" 
   CALL aws_create_issue_return_data()
 
END FUNCTION
 
FUNCTION aws_createStockInData() #MES產生入庫單
 
   LET g_service = "CreateStockInData" 
   CALL aws_create_stock_in_data()
 
END FUNCTION
#--
 
#FUN-880012 --start
FUNCTION aws_getUserToken() #使用者帳號驗證碼
 
   LET g_service = "GetUserToken" 
   LET g_non_plant = "Y"
   CALL aws_get_user_token()
 
END FUNCTION
 
FUNCTION aws_checkUserAuth() #驗證使用者帳號是否正確
 
   LET g_service = "CheckUserAuth" 
   LET g_non_plant = "Y"
   CALL aws_check_user_auth()
 
END FUNCTION
 
FUNCTION aws_getMenuData() #取得Menu清單/樹狀結構
 
   LET g_service = "GetMenuData" 
   LET g_non_plant = "Y"
   CALL aws_get_menu_data()
 
END FUNCTION
#FUN-880012 --end
 
#FUN-840012................begin
FUNCTION aws_CheckExecAuthorization()
 
  LET g_service = "CheckExecAuthorization"  #IMPORTANT! 指定此次呼叫的 function 所代表
  CALL aws_check_exec_authorization()
 
END FUNCTION
 
#建立 ERP 採購收貨單資料的服務  #rva_file - rvb_file
FUNCTION aws_createPOReceivingData()
 
   LET g_service = "CreatePOReceivingData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_poreceiving_data()
 
END FUNCTION
 
#建立 ERP 採購收貨入庫單資料的服務  #rvu_file - rvv_file
FUNCTION aws_createPurchaseStockIn()
 
   LET g_service = "CreatePurchaseStockIn"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_purchase_stock_in()
 
END FUNCTION
 
#建立 ERP 採購收貨入庫單資料的服務  #rvu_file - rvv_file
FUNCTION aws_createPurchaseStockOut()
 
   LET g_service = "CreatePurchaseStockOut"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_purchase_stock_out()
 
END FUNCTION
 
#建立 ERP 工單完工入庫資料的服務  #sfu_file - sfv_file
FUNCTION aws_createWOStockinData()
 
   LET g_service = "CreateWOStockinData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_wo_stock_in_data()
 
END FUNCTION
 
#建立 ERP 盤點標籤相關資料的服務
FUNCTION aws_getCountingLabelData()
 
   LET g_service = "GetCountingLabelData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_counting_label_data()
 
END FUNCTION
 
#取得 ERP 可入庫FQC單相關資料的服務
FUNCTION aws_getFQCData()
 
   LET g_service = "GetFQCData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_fqc_data()
 
END FUNCTION
 
#取得 ERP 料件庫存相關資料的服務
FUNCTION aws_getItemStockList()
 
   LET g_service = "GetItemStockList"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_item_stock_list()
 
END FUNCTION
 
#取得 ERP 盤點標籤別相關資料的服務
FUNCTION aws_getLabelTypeData()
 
   LET g_service = "GetLabelTypeData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_label_type_data()
 
END FUNCTION
 
#提供他系統呼叫以取得 TIPTOP 製造管理系統單據別及會計年月
FUNCTION aws_getMFGDocument()
 
   LET g_service = "GetMFGDocument"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_mfg_document()
 
END FUNCTION
 
#取得 ERP 採購資料的服務  #pmm_file - pmn_file
FUNCTION aws_getPOData()
 
 
   LET g_service = "GetPOData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_po_data()
 
END FUNCTION
 
#取得 ERP 可入庫收貨單相關資料的服務  #rva_file - rvb_file
FUNCTION aws_getPOReceivingInData()
 
 
   LET g_service = "GetPOReceivingInData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_po_receiving_in_data()
 
END FUNCTION
 
#取得 ERP 可入庫收貨單相關資料的服務  #rva_file - rvb_file
FUNCTION aws_getPOReceivingOutData()
 
 
   LET g_service = "GetPOReceivingOutData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_po_receiving_out_data()
 
END FUNCTION
 
#提供已入量、未入量及可入額度、收貨 倉庫/儲位資料
FUNCTION aws_getPurchaseStockInQty()
 
 
   LET g_service = "GetPurchaseStockInQty"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_purchase_stock_in_qty()
 
END FUNCTION
 
#提供已入量、未入量及可入額度、收貨 倉庫/儲位資料
FUNCTION aws_getPurchaseStockOutQty()
 
 
   LET g_service = "GetPurchaseStockOutQty"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_purchase_stock_out_qty()
 
END FUNCTION
 
FUNCTION aws_getReasonCode()
 
 
   LET g_service = "GetReasonCode"  #IMPORTANT! 指定此次呼叫的 function
   CALL aws_get_reason_code()
 
END FUNCTION
 
#提供採購單 已收量、未收量及可收額度、倉庫/儲位資料
FUNCTION aws_getReceivingQty()
 
 
   LET g_service = "GetReceivingQty"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_receiving_qty()
 
END FUNCTION
 
#提供 ERP 倉庫/儲位 資料 的服務 
FUNCTION aws_getStockData()
 
 
   LET g_service = "GetStockData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_stock_data()
 
END FUNCTION
 
#建立 ERP 可入庫工單資料的服務
FUNCTION aws_getWOData()
 
   LET g_service = "GetWOData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_wo_data()
 
END FUNCTION
 
#取得 ERP 未確認領料單相關資料的服務
FUNCTION aws_getWOIssueData()
 
   LET g_service = "GetWOIssueData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_wo_issue_data()
 
END FUNCTION
 
#提供工單之 可入庫量、已入庫量、預設倉庫、預設儲位
FUNCTION aws_getWOStockQty()
 
   LET g_service = "GetWOStockQty"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_wo_stock_qty()
 
END FUNCTION
 
#更新 ERP 盤點標籤資料的服務  #pia_file
FUNCTION aws_updateCountingLabelData()
 
   LET g_service = "UpdateCountingLabelData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_update_counting_label_data()
 
END FUNCTION
 
#更新 ERP 領料單相關資料的服務
FUNCTION aws_updateWOIssueData()
 
   LET g_service = "UpdateWOIssueData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_update_wo_issue_data()
 
END FUNCTION
 
#建立 ERP 銷售退回單資料的服務 
FUNCTION aws_createSalesReturn()
 
 
   LET g_service = "CreateSalesReturn" #IMPORTANT! 指定此次呼叫的 function 
   CALL aws_create_sales_return() 
 
END FUNCTION
 
#建立 ERP 出貨單資料的服務 
FUNCTION aws_createShippingOrder()
 
 
   LET g_service = "CreateShippingOrder" #IMPORTANT! 指定此次呼叫的 function 
   CALL aws_create_shipping_order() 
 
END FUNCTION
 
#建立 ERP 調撥單資料的服務
FUNCTION aws_createTransferNote()
 
 
   LET g_service = "CreateTransferNote" #IMPORTANT! 指定此次呼叫的 function 
   CALL aws_create_transfer_note() 
 
END FUNCTION
 
#提供 ERP 單位換算後之數量的服務 
FUNCTION aws_getQtyConversion() 
 
 
   LET g_service = "GetQtyConversion" #IMPORTANT! 指定此次呼叫的 function
   CALL aws_get_qty_conversion()
 
END FUNCTION 
 
#提供 ERP 銷售系統單據及會計年月的服務
FUNCTION aws_getSalesDocument()
 
 
   LET g_service = "GetSalesDocumentn" #IMPORTANT! 指定此次呼叫的 function 
   CALL aws_get_sales_document() 
 
END FUNCTION 
 
#提供 ERP 出貨通知單單身資料的服務 
FUNCTION aws_getShippingNoticeData() 
 
 
   LET g_service = "GetShippingNoticeData" #IMPORTANT! 指定此次呼叫的 function 
   CALL aws_get_shipping_notice_data() 
 
END FUNCTION 
 
#提供 ERP 出貨單單身資料的服務 
FUNCTION aws_getShippingOrderData() 
 
 
   LET g_service = "GetShippingOrderData" #IMPORTANT! 指定此次呼叫的 function 
   CALL aws_get_shipping_order_data() 
 
END FUNCTION
 
FUNCTION aws_createStockData() #建立新料件倉儲批資料
 
   LET g_service = "CreateStockData" 
   CALL aws_create_stock_data()
 
END FUNCTION
 
FUNCTION aws_CreateMISCIssueData()
 
  LET g_service = "CreateMISCIssueData"  #IMPORTANT! 指定此次呼叫的 function 所代表
  CALL aws_create_misc_issue_data()
 
END FUNCTION
 
#FUN-840012................end
 
#FUN-8B0113--start--
#提供使用者遠端呼叫 TIPTOP 執行 r.c2、r.f2、r.l2 服務
FUNCTION aws_runCommand()
 
   LET g_service = "RunCommand"
   CALL aws_run_command()
 
END FUNCTION
#FUN-8B0113--end--
 
#FUN-860068 start --
#提供EBO取得 ERP 客戶資料服務
FUNCTION aws_EboGetCustData()
 
  LET g_service = "EboGetCustData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_ebo_get_cust_data()
 
END FUNCTION
 
FUNCTION aws_EboGetProdData()
 
  LET g_service = "EboGetProdData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_ebo_get_prod_data()
 
END FUNCTION
 
FUNCTION aws_EboGetOrderData()
 
  LET g_service = "EboGetOrderData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_ebo_get_order_data()
 
END FUNCTION
#FUN-860068 end --
 
#TQC-910021 start --
 
FUNCTION aws_CheckApsExecution()
 
  LET g_service = "CheckApsExecution"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_check_aps_execution()
 
END FUNCTION
#TQC-910021 end --

#--FUN-930132--start--
#取得報表資料服務
FUNCTION aws_getReportData()

  LET g_service = "GetReportData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_get_report_data()

END FUNCTION
#--FUN-930132--end-- 


#FUN-930139 add str ------------------
#取得客戶聯絡人資料的服務
FUNCTION aws_getCustomerContactData()

  LET g_service = "GetCustomerContactData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_get_customer_contact_data()

END FUNCTION

#取得客戶其他地址資料的服務
FUNCTION aws_getCustomerOtheraddressData()

  LET g_service = "GetCustomerOtheraddressData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務>
  CALL aws_get_customer_otheraddress_data()

END FUNCTION

#取得包裝方式資料的服務
FUNCTION aws_getPackingMethodData()

  LET g_service = "GetPackingMethodData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_get_packing_method_data()

END FUNCTION

#取得稅別資料的服務
FUNCTION aws_getTaxTypeData()

  LET g_service = "GetTaxTypeData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_get_tax_type_data()

END FUNCTION

#取得單位換算資料的服務
FUNCTION aws_getUnitConversionData()

  LET g_service = "GetUnitConversionData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_get_unit_conversion_data()

END FUNCTION

#取得製造參數資料的服務
FUNCTION aws_getMFGSettingSmaData()

  LET g_service = "GetMFGSettingSmaData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_get_mfg_setting_sma_data()

END FUNCTION

#建立潛在客戶主檔資料的服務
FUNCTION aws_createPotentialCustomerData()

  LET g_service = "CreatePotentialCustomerData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務>
  CALL aws_create_potential_customer_data()

END FUNCTION

#建立客戶聯絡人資料的服務
FUNCTION aws_createCustomerContactData()

  LET g_service = "CreateCustomerContactData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名>
  CALL aws_create_customer_contact_data()

END FUNCTION

#建立客戶其他地址資料的服務
FUNCTION aws_createCustomerOtheraddressData()

  LET g_service = "CreateCustomerOtheraddressData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服
  CALL aws_create_customer_otheraddress_data()

END FUNCTION

#CRM取得客戶資料
FUNCTION aws_CRMgetCustomerData()

  LET g_service = "CRMGetCustomerData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_crm_get_customer_data()

END FUNCTION

#取得潛在客戶主檔資料的服務
FUNCTION aws_getPotentialCustomerData()

  LET g_service = "GetPotentialCustomerData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_get_potential_customer_data()

END FUNCTION

#取得ERP檔案架構資料的服務
FUNCTION aws_getTableAmendmentData()

  LET g_service = "GetTableAmendmentData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_get_table_amendment_data()

END FUNCTION
#FUN-930139 add end ------------------

#FUN-AA0022---add----str---
#FUN-9A0090---add----str---
#讀取帳別參數資料
FUNCTION aws_getAccountTypeData()

   LET g_service = "GetAccountTypeData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_account_type_data()

END FUNCTION

#讀取會計科目資料
FUNCTION aws_getAccountData()

   LET g_service = "GetAccountData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_account_data()

END FUNCTION

#建立傳票資料
FUNCTION aws_createVoucherData()

   LET g_service = "CreateVoucherData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_voucher_data()

END FUNCTION

#讀取傳票單別資料
FUNCTION aws_getVoucherDocumentData()

   LET g_service = "GetVoucherDocumentData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_voucher_document_data()

END FUNCTION
#FUN-9A0090---add----end---

#FUN-A10069---add----str---
#讀取帳款類別資料
FUNCTION aws_getTransactionCategory()

   LET g_service = "GetTransactionCategory"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_transaction_category()

END FUNCTION

#建立應付請款資料
FUNCTION aws_createBillingAP()

   LET g_service = "CreateBillingAP"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_billing_ap()

END FUNCTION
#FUN-A10069---add----end---

#FUN-A20035---add----str---
#建立部門基本資料的服務
FUNCTION aws_createDepartmentData()

   LET g_service = "CreateDepartmentData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_department_data()

END FUNCTION
#FUN-A20035---add----end---

#FUN-A70142---add----str---
#建立料件供應商資料
FUNCTION aws_createSupplierItemData()

  LET g_service = "CreateSupplierItemData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
  CALL aws_create_supplier_item_data()

END FUNCTION
#FUN-A70142---add----end---

#FUN-A30090---add----str---
#建立傳票資料
FUNCTION aws_rollbackVoucherData()

   LET g_service = "RollbackVoucherData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_rollback_voucher_data()

END FUNCTION
#FUN-A30090---add----end---
#FUN-AA0022---add----end---

#FUN-AC0068 add str --------
#讀取收款條件資料
FUNCTION aws_getPaymentTermsData()

   LET g_service = "GetPaymentTermsData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_payment_terms_data()

END FUNCTION
#FUN-AC0068 add end --------

#FUN-B10003 add str --------                          
#取得TIPTOP SSOKey資料
FUNCTION aws_getSSOKey()                                            

   LET g_service = "GetSSOKey"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_sso_key()
    
END FUNCTION
#FUN-B10003 add end --------

#FUN-B10004 add str --------
#建立無訂單出貨單
FUNCTION aws_createShippingOrdersWithoutOrders()

   LET g_service = "CreateShippingOrdersWithoutOrders"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_shipping_orders_without_orders()

END FUNCTION
#FUN-B10004 add end --------

#FUN-B30020 add str --------
#取得料件分群碼資料
FUNCTION aws_getItemGroupData()

   LET g_service = "GetItemGroupData"
   CALL aws_get_item_group_data()

END FUNCTION
#FUN-B30020 add end --------

#FUN-A20026 add str ---------
#取得工作站資料
FUNCTION aws_getWorkstationData()

LET g_service = "GetWorkstationData"
CALL aws_get_workstation_data()

END FUNCTION

#取得機器資料
FUNCTION aws_getMachineData()

LET g_service = "GetMachineData"
CALL aws_get_machine_data()

END FUNCTION

#取得產品製程資料
FUNCTION aws_getProdRoutingData()

LET g_service = "GetProdRoutingData"
CALL aws_get_prod_routing_data()

END FUNCTION
#FUN-A20026 add end ---------

#FUN-B30147 add str --------
#取得料件分群碼資料
FUNCTION aws_getItemOtherGroupData()

   LET g_service = "GetItemOtherGroupData"
   CALL aws_get_item_other_group_data()

END FUNCTION
#FUN-B30147 add end --------


#FUN-B40072 add str --------                          
# 讀取TIPTOP運行狀態
FUNCTION aws_getProdState()                                            
   LET g_service = "GetProdSate"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   LET g_non_plant = "Y"
   CALL aws_get_prod_state()
END FUNCTION


# 讀取TIPTOP產品資訊
FUNCTION aws_getProdInfo()                                            
   LET g_service = "GetProdInfo"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   LET g_non_plant = "Y"   
   CALL aws_get_prod_Info()
END FUNCTION


# 讀取TIPTOP目前線上人數
FUNCTION aws_getOnlineUser()
   LET g_service = "GetOnlineUser"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   LET g_non_plant = "Y"   
   CALL aws_get_online_user()
END FUNCTION
#FUN-B40072 add end --------

#FUN-B60090 -- start --
#建立使用者帳號資料 
FUNCTION aws_syncAccountData()
   LET g_service = "SyncAccountData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   LET g_non_plant = "Y"   
   CALL aws_sync_account_data()
END FUNCTION
#FUN-B60090 -- end --

#FUN-BB0161 -- start --
#更改編碼狀態(Y/N)
FUNCTION aws_syncEncodingState()
   LET g_service = "SyncEncodingState"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_sync_encoding_state()
END FUNCTION
#FUN-BB0161 -- end --

#FUN-B10037 add str --------
FUNCTION aws_createWOWorkReportData()

   LET g_service = "CreateWOWorkReportData" #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_wo_work_report_data()

END FUNCTION
#FUN-B10037 add end --------

#FUN-B60003 add str --------
#取得會員基本資料
FUNCTION aws_getMemberData()

   LET g_service = "GetMemberData"
   CALL aws_get_member_data()

END FUNCTION

#取得卡明細資料
FUNCTION aws_getCardDetailData()

   LET g_service = "GetCardDetailData"
   CALL aws_get_card_detail_data()

END FUNCTION
#FUN-B60003 add end --------

#FUN-A80131---add----str---
FUNCTION aws_createItemApprovalData()

   LET g_service = "CreateItemApprovalData" #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_item_approval_data()

END FUNCTION
#FUN-A80131---add----end---

#FUN-A80127---add----str---
#取得ERP廠牌資料服務
FUNCTION aws_getBrandData()

   LET g_service = "GetBrandData"   #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_brand_data()

END FUNCTION
#FUN-A80127---add----end---

#FUN-A70147---add----str---
#建立P-BOM取替代件資料
FUNCTION aws_createRepSubPBOMData()

   LET g_service = "CreateRepSubPBOMData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_repsub_pbom_data()

END FUNCTION
#FUN-A70147---add----end---

#FUN-A80017---add----str---
#建立P-BOM取替代件資料
FUNCTION aws_createECNData()

   LET g_service = "CreateECNData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_ecn_data()

END FUNCTION
#FUN-A80017---add----end---

#FUN-B20003---add----str---
FUNCTION aws_createPLMBOMData()

   LET g_service = "CreatePLMBOMData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_plm_bom_data()

END FUNCTION
#FUN-B20003---add----end---

#FUN-B80168---add----str---
FUNCTION aws_getCustomerAccAmtData()

   LET g_service = "GetCustomerAccAmtData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_customer_acc_amt_data()

END FUNCTION
#FUN-B80168---add----end---

#FUN-C50138 add begin--------------
FUNCTION aws_modPassWord()
   LET g_service = "ModPassWord"
   CALL aws_mod_password()
END FUNCTION

FUNCTION aws_getMemberCardInfo()
   LET g_service = "GetMemberCardInfo"
   CALL aws_get_member_card_info()
END FUNCTION

FUNCTION aws_writePoint()
   LET g_service = "WritePoint"
   CALL aws_write_point() 
END FUNCTION

FUNCTION aws_getCashCardInfo()
   LET g_service = "GetCashCardInfo"
   CALL aws_get_cash_card_info() 
END FUNCTION

FUNCTION aws_deductMoney()
   LET g_service = "DeductMoney"
   CALL aws_deduct_money()
END FUNCTION

FUNCTION aws_checkGiftNo()
   LET g_service = "CheckGiftNo"
   CALL aws_check_gift_no()
END FUNCTION

FUNCTION aws_deductGiftNO()
   LET g_service = "DeductGiftNO"
   CALL aws_deduct_gift_no()
END FUNCTION

FUNCTION aws_getScore()
   LET g_service = "GetScore"
   CALL aws_get_score()
END FUNCTION

FUNCTION aws_deductScore()
   LET g_service = "DeductScore"
   CALL aws_deduct_score()
END FUNCTION

FUNCTION aws_deductPayment()
  #LET g_service = "DeductsPayment" #FUN-CA0090
  #LET g_service = "DeductPayment"  #FUN-CA0090
   LET g_service = "DeductSPayment" #FUN-CB0028
   CALL aws_deduct_payment()
END FUNCTION
#FUN-C50138 add end----------------

#FUN-B90089 add str---
#取得 ERP 資料總筆數的服務
FUNCTION aws_getDataCount()

    LET g_service = "GetDataCount"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_data_count()

END FUNCTION

#取得使用者預設的營運中心的服務
FUNCTION aws_getUserDefOrg()

    LET g_service = "GetUserDefOrg"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    LET g_non_plant = "Y" 
    CALL aws_get_user_def_org()

END FUNCTION

#取得訂單資料的服務
FUNCTION aws_getSOData()

    LET g_service = "GetSOData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_so_data()

END FUNCTION

#取得出貨單資料的服務
FUNCTION aws_getShappingData()

    LET g_service = "GetShappingData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_shapping_data()

END FUNCTION

#取得報價單資料的服務
FUNCTION aws_getQuotationData()

    LET g_service = "GetQuotationData"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_quotation_data()

END FUNCTION
#FUN-B90089 add end---

#FUN-CA0090 Add Begin ---
#取當前會員卡可扣減積分的服務
FUNCTION aws_getCardScore()

    LET g_service = "GetCardScore"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_card_score()
END FUNCTION
FUNCTION aws_rechargeCard()

    LET g_service = "RechargeCard"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_recharge_card()
END FUNCTION
FUNCTION aws_selCardInfo()

    LET g_service = "SelCardInfo"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_sel_card_info()
END FUNCTION
FUNCTION aws_checkCard()
    
    LET g_service = "CheckCard"    #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_check_card()
END FUNCTION
FUNCTION aws_changeCard()

    LET g_service = "ChangeCard"    #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_change_card()
END FUNCTION
FUNCTION aws_checkCoupon()
 
    LET g_service = "CheckCoupon"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_check_coupon()
END FUNCTION
FUNCTION aws_checkCardType()

    LET g_service = "CheckCardType"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_check_card_type()
END FUNCTION
FUNCTION aws_returnCard()

    LET g_service = "ReturnCard"     #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_return_card()
END FUNCTION
#FUN-CA0090 Add End -----
#FUN-CB0104 Add Str -----
FUNCTION aws_returnOrderBill()

    LET g_service = "ReturnOrderBill"   #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_return_order_bill()
END FUNCTION
FUNCTION aws_getOrderInfo()

    LET g_service = "GetOrderInfo"   #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_get_order_info()
END FUNCTION
#FUN-CB0104 Add End ----- 

#FUN-C50126 add str --------
FUNCTION aws_getAPCategoryAccountCode()

   LET g_service = "GetAPCategoryAccountCode" #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_ap_category_account_code()

END FUNCTION
#FUN-C50126 add end --------

#FUN-C80078 add str --------
FUNCTION aws_rollbackBillingAP()

   LET g_service = "RollbackBillingAP" #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_rollback_billing_ap()

END FUNCTION
#FUN-C80078 add end --------
#FUN-CC0135 Add Str -----
FUNCTION aws_checkMemberUpgrade()

    LET g_service = "CheckMemberUpgrade"   #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_check_member_upgrade()
END FUNCTION
FUNCTION aws_memberUpgrade()

    LET g_service = "MemberUpgrade"   #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
    CALL aws_member_upgrade()
END FUNCTION
#FUN-CC0135 Add End -----

#FUN-D10092 add str --------
FUNCTION aws_createPLMTempTableData()

   LET g_service = "CreatePLMTempTableData" #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_plm_temptable_data()

END FUNCTION

FUNCTION aws_getPLMTempTableDataStatus()

   LET g_service = "GetPLMTempTableDataStatus" #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_plm_temptable_data_status()

END FUNCTION

FUNCTION aws_deletePLMTempTableData()

   LET g_service = "DeletePLMTempTableData" #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_del_plm_temptable_data()

END FUNCTION
#FUN-D10092 add end --------

#str---add by guanyao 20160603-----Beg----------
FUNCTION get_start_works()

   LET g_service = "cws_get_start_works"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL cws_get_start_works()

END FUNCTION 
#end---add by guanyao 20160603-----End----------

#str---add by guanyao 20160606-----Beg----------
FUNCTION create_work()

   LET g_service = "cws_create_work"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL cws_create_work()

END FUNCTION 
FUNCTION get_finish_works()

   LET g_service = "cws_get_finish_works"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL cws_get_finish_works()

END FUNCTION 

FUNCTION create_finish_work()

   LET g_service = "cws_create_finish_work"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL cws_create_finish_work()

END FUNCTION

#end---add by guanyao 20160606-----End----------
#str---add by guanyao160607
FUNCTION create_scan()

   LET g_service = "cws_create_scan"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL cws_create_scan()

END FUNCTION

FUNCTION create_scan_out()

   LET g_service = "cws_create_scan_out"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL cws_create_scan_out()

END FUNCTION
#end---add by guanyao160607

#抓取营运中心160612 add huxya
FUNCTION aws_getPlant()

   LET g_service = "GetPlant"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_plant()

END FUNCTION

#登录验证160612 add huxya
FUNCTION aws_loginCheck()

   LET g_service = "LoginCheck"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_login_check()

END FUNCTION

#str------add by guanyao160718
FUNCTION get_password()

   LET g_service = "cws_get_password"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL cws_get_password()

END FUNCTION
#end------add by guanyao160718

#add--huxy160727------B--------
FUNCTION aws_GetAppver()

   LET g_service = "GetAppver"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_appver()

END FUNCTION

#add--huxy160727------E--------

#str------add by guanyao160805
FUNCTION get_lot()

   LET g_service = "cws_get_lot"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL cws_get_lot()

END FUNCTION
#end------add by guanyao160805
#add by shenran 2016-08-03 10:23:37 ��������ƽ̨str
#FUNCTION aws_GetAppver()
#
#   LET g_service = "GetAppver"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_get_appver()
#
#END FUNCTION

#FUN-D10092 add end --------

FUNCTION aws_getAimt302()

   LET g_service = "GetAimt302"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_aimt302()

END FUNCTION
	
FUNCTION aws_createAimt302()

   LET g_service = "CreateAimt302"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_aimt302()

END FUNCTION

FUNCTION aws_createAimt301()

   LET g_service = "CreateAimt301"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_aimt301()

END FUNCTION
	
FUNCTION aws_getMove()

   LET g_service = "GetMove"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_move()

END FUNCTION

FUNCTION aws_createMove()

   LET g_service = "CreateMove"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_move()

END FUNCTION

FUNCTION aws_getCheckGoodsIn()

   LET g_service = "GetCheckGoodsIn"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_check_goods_in()

END FUNCTION

FUNCTION aws_updateReceipt()

   LET g_service = "UpdateReceipt"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_update_receipt()

END FUNCTION

FUNCTION aws_getRecieveGoodsIn()

   LET g_service = "GetRecieveGoodsIn"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_recieve_goods_in()

END FUNCTION

FUNCTION aws_getTlfb100()

   LET g_service = "GetTlfb100"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_tlfb100()

END FUNCTION

FUNCTION aws_createTlfb100()

   LET g_service = "CreateTlfb100"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_tlfb100()

END FUNCTION

FUNCTION aws_getAsfi301()

   LET g_service = "GetAsfi301"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_asfi301()

END FUNCTION

FUNCTION aws_getTlfb510()

   LET g_service = "GetTlfb510"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_tlfb510()

END FUNCTION

FUNCTION aws_createTlfb510()

   LET g_service = "CreateTlfb510"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_tlfb510()

END FUNCTION
	
FUNCTION aws_getAllot()

   LET g_service = "GetAllot"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_allot()

END FUNCTION

FUNCTION aws_getAllotAgain()

   LET g_service = "GetAllotAgain"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_allot_again()

END FUNCTION

FUNCTION aws_updateAllot()

   LET g_service = "UpdateAllot"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_update_allot()

END FUNCTION
	
FUNCTION aws_updateAllotAgain()

   LET g_service = "UpdateAllotAgain"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_update_allot_again()

END FUNCTION

FUNCTION aws_getAsft620()

   LET g_service = "GetAsft620"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_asft620()

END FUNCTION

FUNCTION aws_updateAsft620()

   LET g_service = "UpdateAsft620"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_update_asft620()

END FUNCTION

FUNCTION aws_getFifo1()

   LET g_service = "GetFifo1"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_fifo1()

END FUNCTION

FUNCTION aws_getFifo2()

   LET g_service = "GetFifo2"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_fifo2()

END FUNCTION

FUNCTION aws_getFifo3()

   LET g_service = "GetFifo3"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_fifo3()

END FUNCTION

FUNCTION aws_getFifo4()

   LET g_service = "GetFifo4"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_fifo4()

END FUNCTION
	
FUNCTION aws_createTlfb520()

   LET g_service = "CreateTlfb520"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_tlfb520()

END FUNCTION

FUNCTION aws_getCxmt620()

   LET g_service = "GetCxmt620"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_cxmt620()

END FUNCTION

FUNCTION aws_createCxmt620()

   LET g_service = "CreateCxmt620"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_cxmt620()

END FUNCTION

FUNCTION aws_getInventory()

   LET g_service = "GetInventory"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_inventory()

END FUNCTION
	
FUNCTION aws_createInventory()

   LET g_service = "CreateInventory"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_inventory()

END FUNCTION
	
#���ܴ��ջ��ӿ�
#ȡ�û�����Ϣ 07751
FUNCTION aws_getDeliverymei()

  LET g_service = "GetDeliverymei"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
  CALL aws_get_deliverymei()

END FUNCTION

FUNCTION aws_createApmt110mei()

  LET g_service = "CreateApmt110mei"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
  CALL aws_create_apmt110mei()

END FUNCTION

FUNCTION aws_getReceiptmei()
 
   LET g_service = "GetReceiptmei" 
   CALL aws_get_receiptmei()
 
END FUNCTION

FUNCTION aws_createApmt720mei()
 
   LET g_service = "CreateApmt720mei"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_apmt720mei()
 
END FUNCTION

FUNCTION aws_getTransfermei()
 
   LET g_service = "GetTransfermei"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_transfermei()
 
END FUNCTION

FUNCTION aws_createAimt324mei()
 
   LET g_service = "CreateAimt324mei"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_aimt324mei()
 
END FUNCTION
	
FUNCTION aws_getApmt110()
 
   LET g_service = "GetApmt110"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_apmt110()
 
END FUNCTION


       #------------------------huxy160627-----Beg------------------------

#FUNCTION get_start_works()
#   LET g_service = "cws_get_start_works"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_get_start_works()
#END FUNCTION 

#FUNCTION create_work()
#   LET g_service = "cws_create_work"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_create_work()
#END FUNCTION 

#FUNCTION get_finish_works()
#   LET g_service = "cws_get_finish_works"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_get_finish_works()
#END FUNCTION 

#FUNCTION create_finish_work()
#   LET g_service = "cws_create_finish_work"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_create_finish_work()
#END FUNCTION

#FUNCTION create_scan()
#   LET g_service = "cws_create_scan"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_create_scan()
#END FUNCTION

#FUNCTION create_scan_out()
#   LET g_service = "cws_create_scan_out"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_create_scan_out()
#END FUNCTION
 
      
       #------------------------huxy160627-----End------------------------
#FUNCTION aws_getIma()
#   LET g_service = "GetIma"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_get_ima()
#END FUNCTION

FUNCTION aws_getProcess()
   LET g_service = "GetProcess"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_process()
END FUNCTION
	
#FUNCTION aws_createAxmt410()
#   LET g_service = "CreateAxmt410"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_create_axmt410()
#END FUNCTION

#FUNCTION aws_createShopping()
#   LET g_service = "CreateShopping"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_create_shopping()
#END FUNCTION

#FUNCTION aws_getMessage()
#   LET g_service = "GetMessage"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_get_message()
#END FUNCTION

#FUNCTION aws_createAdd()
#   LET g_service = "CreateAdd"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_create_add()
#END FUNCTION

#FUNCTION aws_deleteAxmt410()
#   LET g_service = "DeleteAxmt410"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_delete_axmt410()
#END FUNCTION

FUNCTION aws_getImgb03()
   LET g_service = "GetImgb03"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_imgb03()
END FUNCTION

#add by shenran 2016-03-20 8:27:25 ��ȡ��¼Ӫ������ str
#FUNCTION aws_getPlant()
# 
#   LET g_service = "GetPlant"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_get_plant()
# 
#END FUNCTION
#add by shenran 2016-03-20 8:27:25 ��ȡ��¼Ӫ������ end 
#add by shenran 2016-03-20 8:27:25 �����깤���ⵥ�� str
FUNCTION aws_createArts()
 
   LET g_service = "CreateArts"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_arts()
 
END FUNCTION
#add by shenran 2016-03-20 8:27:25 �����깤���ⵥ�� end
#add by shenran 2016-03-21 6:53:03 ���¼��鵥���� str
FUNCTION aws_createCheck()
 
   LET g_service = "CreateCheck"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_check()
 
END FUNCTION

#add by shenran 2016/4/17 17:15:45 ��¼��֤ str
#FUNCTION aws_loginCheck()
# 
#   LET g_service = "LoginCheck"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_login_check()
# 
#END FUNCTION
#add by shenran 2016/4/17 17:15:47 ��¼��֤ end
#add by shenran 2016-03-20 8:27:25 �����깤���ⵥ�� str
FUNCTION aws_createAsft620()
 
   LET g_service = "CreateAsft620"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_asft620()
 
END FUNCTION
#add by shenran 2016-03-20 8:27:25 �����깤���ⵥ�� end 
#add by shenran 2016-03-20 8:27:25 �������ⵥ�� str
FUNCTION aws_createApmt720()
 
   LET g_service = "CreateApmt720"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_create_apmt720()
 
END FUNCTION
#add by shenran 2016-03-20 8:27:25 �������ⵥ�� end
############################  start add by yanglan
#----------ȡ�� ERP�ϼ�ͼƬ��Ϣ����--------#
FUNCTION aws_getPicture()
 
   LET g_service = "GetPicture"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_picture()
 
END FUNCTION
############################  end  

##----------ȡ�� ERP������Ϣ����--------#
#FUNCTION aws_getJob()
# 
#   LET g_service = "GetJob"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#   CALL aws_get_job()
# 
#END FUNCTION
#############################  end


#----------ȡ�� ERP�������浵��Ϣ����--------#
FUNCTION aws_getImgb()
 
   LET g_service = "GetImgb"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_imgb()
 
END FUNCTION
FUNCTION aws_getImg()
 
   LET g_service = "GetImg"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_img()
 
END FUNCTION

#�����ջ������� 07751
FUNCTION aws_createApmt110()

  LET g_service = "CreateApmt110"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
  CALL aws_create_apmt110()

END FUNCTION

#�������ϵ����� 07751
FUNCTION aws_createAsfi510()

  LET g_service = "CreateAsfi510"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
  CALL aws_create_asfi510()

END FUNCTION

#��ȡ�������� 07751
FUNCTION aws_getCheck()

  LET g_service = "GetCheck"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
  CALL aws_get_check()

END FUNCTION

#��ȡ���ⵥ��Ϣ 07751
FUNCTION aws_getWork()

  LET g_service = "GetWork"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
  CALL aws_get_work()

END FUNCTION

##ȡ�û�����Ϣ 07751
#FUNCTION aws_getDelivery()
#
#  LET g_service = "GetDelivery"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
#  CALL aws_get_delivery()
#
#END FUNCTION

#��ȡ���ԭ�� 07751
FUNCTION aws_getReason()

  LET g_service = "GetReason"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
  CALL aws_get_reason()

END FUNCTION
	
FUNCTION aws_getArts()
 
   LET g_service = "GetArts"  #IMPORTANT! ָ���˴κ��е� function �������ķ������Q
   CALL aws_get_arts()
 
END FUNCTION
############################  end
#add by shenran 2016-08-03 10:23:57  end

#add by nihuan 20170508-----------start---------------

FUNCTION aws_gettransferdata()
 
   LET g_service = "GetTransferData"  
   CALL aws_get_transferdata()
 
END FUNCTION


FUNCTION aws_getitemno()
 
   LET g_service = "GetItemNo"  
   CALL aws_get_item_no()
 
END FUNCTION

FUNCTION aws_gettcimnFifo()
 
   LET g_service = "GetTcimnFifo"  
   CALL aws_get_tc_imn_fifo()
 
END FUNCTION

FUNCTION aws_csft512s()
 
   LET g_service = "Csft512S"  
   CALL aws_csft512_s()
 
END FUNCTION

FUNCTION aws_asfi511s()
 
   LET g_service = "Asfi511S"  
   CALL aws_asfi511_s()
 
END FUNCTION
	
FUNCTION cws_query_asfi512()
   LET g_service = "cws_query_asfi512"
   CALL cws_query_asfi512_g()
END FUNCTION

#生产超领过账 cws_upd_asfi512
FUNCTION cws_upd_asfi512()
   LET g_service = "cws_upd_asfi512"
   CALL cws_upd_asfi512_g()
END FUNCTION

#一般出货查询 cws_get_axmt620
FUNCTION cws_get_axmt620()
   LET g_service = "cws_get_axmt620"
   CALL cws_get_axmt620_g()
END FUNCTION

#一般出货过账 
#FUNCTION aws_updaxmt620()
#   LET g_service = "cws_upd_axmt620"
#   CALL cws_upd_axmt620_g()
#END FUNCTION

#调拨单查询 cws_get_aimt324
FUNCTION get_aimt324()
   LET g_service = "cws_get_aimt324"
   CALL cws_get_aimt324()
END FUNCTION
	
#调拨单过账 cws_post_aimt324
FUNCTION post_aimt324()
   LET g_service = "cws_post_aimt324"
   CALL cws_post_aimt324()
END FUNCTION
	
FUNCTION cws_upd_aimt301()
   LET g_service = "cws_upd_aimt301"
   CALL cws_upd_aimt301_g()
END FUNCTION
FUNCTION cws_get_aimt301()
   LET g_service = "cws_get_aimt301"
   CALL cws_get_aimt301_g()
END FUNCTION

#杂收单查询 cws_get_aimt302
FUNCTION get_aimt302()
   LET g_service = "cws_get_aimt302"
   CALL cws_get_aimt302()
END FUNCTION
	
#有源杂收单过账 cws_post_aimt302
FUNCTION post_aimt302()
   LET g_service = "cws_post_aimt302"
   CALL cws_post_aimt302()
END FUNCTION

FUNCTION aws_getApmt722()
   LET g_service = "GetApmt722"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_get_apmt722()
END FUNCTION

FUNCTION aws_createApmt722()
   LET g_service = "CreateApmt722"  #IMPORTANT! 指定此次呼叫的 function 所代表的服務名稱
   CALL aws_create_apmt722()
END FUNCTION
	
FUNCTION aws_gettransferdatadetail()
   LET g_service = "GetTransferDataDetail"  
   CALL aws_get_transferdata_detail()
END FUNCTION	

FUNCTION aws_getaxmt700data()
   LET g_service = "GetAxmt700Data"  
   CALL aws_get_axmt700_data()
END FUNCTION
	
FUNCTION aws_getaxmt700datadetail()
   LET g_service = "GetAxmt700DataDetail"  
   CALL aws_get_axmt700_data_detail()
END FUNCTION

FUNCTION aws_updaxmt700()
   LET g_service = "UpdAxmt700"  
   CALL aws_update_axmt700()
END FUNCTION									
#add by nihuan 20170508-----------end---------------



