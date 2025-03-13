# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#{
# Program name...: aws_invoke_srv.4gl
# Descriptions...: CROSS整合, 提供服務呼叫
# Date & Author..: 2011/04/01 by Echo
# Memo...........:
# Modify.........: 新建立  #FUN-B20029
#
#}
# Modify.........: No.FUN-B90032 11/09/05 By minpp 程序撰写规范修改
# Modify.........: No:FUN-B60090 11/11/23 By ka0132 新增--"SyncAccountData"(建立使用者帳號-for portal)
# Modify.........: No.FUN-B90065 11/12/29 By ka0132 重新指定service為invokeSrv
# Modify.........: No.FUN-BB0161 11/11/29 By ka0132 提供更新編碼狀態服務
# Modify.........: No.FUN-C20087 12/03/06 By Abby CROSS GP5.3追版以下單號----
# Modify.........: No.FUN-B70110 11/07/28 By Abby 新增HRM服務函式
# Modify.........: No.FUN-B70116 11/07/28 By Abby 新增CRM服務函式
# Modify.........: No.FUN-C20087 12/03/06 By Abby CROSS GP5.3追版以上單號----
# Modify.........: No.FUN-B60123 12/05/07 By Abby 新增POS服務函式--GetMemberData
# Modify.........: No.FUN-C40065 12/05/16 By Abby 新增CRM服務函式--GetCustClassificationData、GetTradeTermData、GetInvoiceTypeList
# Modify.........: No.FUN-C50138 12/05/31 By suncx 新增POS服務函式--ModPassWord、GetMemberCardInfo、CheckGiftNo、WritePoint、DeductMoney
#                                                                 --DeductGiftNO、GetScore、DeductScore、GetCashCardInfo
# Modify.........: No:FUN-C60080 12/06/26 By Kevin 重新連線 database ds
# Modify.........: No:FUN-C70031 12/07/10 By Kevin 當 srvcode = "100" 回傳 "Service not executed successfully"
# Modify.........: No:FUN-B90089 12/08/27 By Abby  新增M-Cloud服務函式
# Modify.........: No.FUN-CA0090 12/10/12 By baogc 新增POS服務函式--GetCardScore
# Modify.........: No:FUN-CB0104 12/11/22 By xumeimei 新增--ReturnOrderBill--GetOrderInfo
# Modify.........: No:FUN-CB0142 12/12/03 By Kevin 取得 TIPTOP 產品版本
# Modify.........: No.DEV-C80002 12/12/22 By Abby 新增HRM服務函式--GetAPCategoryAccountCode、RollbackBillingAP
# Modify.........: No:FUN-CC0135 12/12/25 By xumeimei 新增--CheckMemberUpgrade--MemberUpgrade

IMPORT xml
IMPORT com
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
GLOBALS
DEFINE g_method_name          STRING   
END GLOBALS

DEFINE g_srvcode               STRING
           
#FUN-B20029 
#[
# Description....: 提供服務呼叫  function)
# Date & Author..: 2011/04/01 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_invoke_srv()
DEFINE l_service     STRING
 
    WHENEVER ERROR CONTINUE
 
    LET g_srvcode = "000"      #預設服務按照正常流程

    #FUN-C60080 start
    CALL aws_ttsrv_conn_ds()   #FUN-C70031
    #FUN-C60080 end

    #紀錄 Request XML
    CALL aws_ttsrv_writeRequestLog()   

    LET g_request.request = cl_coding_de(g_request.request)      #FUN-BB0161 解碼

    CALL aws_invoke_srv_req_process() RETURNING l_service
    
    #呼叫服務 Function 處理
    CALL aws_invoke_srv_callFunction(l_service)

    IF cl_null(g_response.response) THEN
       LET g_srvcode = "100"       #服務未按照正常流程執行
       LET g_response.response  = "Service not executed successfully"  #FUN-C70031
    END IF

    CALL aws_invoke_srv_res_process()

    LET g_response.response = cl_coding_en(g_response.response)   #FUN-BB0161 編碼

    #紀錄 Request XML
    LET g_service = "invokeSrv"   #FUN-B90065  重新指定service為invokeSrv
    CALL aws_ttsrv_writeResponseLog()   
END FUNCTION

#[
# Description....: 取得各產品的 XML 資料
# Date & Author..: 2011/04/01 by Echo
# Parameter......: none
# Return.........: l_service  - STRING -    服務名稱
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_invoke_srv_req_process()
DEFINE lx_reqdoc         xml.DomDocument
DEFINE lx_node_list      xml.DomNodeList
DEFINE lx_tnode          xml.DomNode
DEFINE lx_pnode          xml.DomNode
DEFINE l_service         STRING
DEFINE l_i               LIKE type_file.num10

    IF cl_null(g_request.request) THEN
       LET g_response.response = "Request isn't valid XML document."
       RETURN ""
    END IF

    #尋找對應名稱的 payload  CDATA section 包覆的 XML 資料
    LET lx_reqdoc = xml.DomDocument.Create()
    CALL lx_reqdoc.loadFromString(g_request.request)
    IF lx_reqdoc.getErrorsCount() > 0 THEN
       LET g_response.response = "Request isn't valid XML document. "
       FOR l_i = 1 TO lx_reqdoc.getErrorsCount()
           LET g_response.response = g_response.response, lx_reqdoc.getErrorDescription(l_i)
       END FOR
       RETURN ""        
    END IF
#   LET g_response.response = lx_reqdoc.saveToString()   #FUN-C70031

    LET lx_node_list = lx_reqdoc.getElementsByTagName("service")
    IF lx_node_list.getCount() > 0 THEN
       LET lx_pnode = lx_node_list.getitem(1)
       LET l_service = lx_pnode.getAttribute("name")
    END IF
    IF lx_node_list.getCount() > 0 THEN
       LET lx_node_list = lx_reqdoc.getElementsByTagName("payload")
       LET lx_pnode = lx_node_list.getitem(1)
       LET lx_tnode = lx_pnode.getFirstChild()
       LET g_request.request = lx_tnode.getNodeValue() 
    END IF
    
    RETURN l_service
   
END FUNCTION

#[
# Description....: 產生回傳的 XML 字串
# Date & Author..: 2011/04/01 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_invoke_srv_res_process()
DEFINE lx_resdoc         xml.DomDocument
DEFINE lx_node_list      xml.DomNodeList
DEFINE lx_res_root       xml.DomNode
DEFINE lx_tnode          xml.DomNode
DEFINE lx_pnode          xml.DomNode
DEFINE l_cmd             base.Channel
DEFINE l_tp_version      STRING
DEFINE ls_each           STRING



    #取得 TIPTOP 產品版本, 讀取4gl的第一行程式版本資訊，如: 5.25
    #LET l_cmd = base.Channel.create()
    #CALL l_cmd.openPipe("cat $AZZ/4gl/p_zx.4gl | grep 'Prog.'", "r")
    #WHILE l_cmd.read(ls_each)
    #   LET l_tp_version= ls_each.subString(ls_each.getIndexOf("'",1)+1,ls_each.getIndexOf("-",1))
    #   LET l_tp_version = l_tp_version.subString(1,l_tp_version.getIndexOf(".",l_tp_version.getIndexOf(".",1)+1)-1)
    #   EXIT WHILE
    #END WHILE
    #CALL l_cmd.close()   #No:FUN-B90032
    LET l_tp_version = cl_get_tp_version()    #FUN-CB0142
   
    #產生 response xml.DomDocument
    LET lx_resdoc = xml.DomDocument.CreateDocument("response")
    LET lx_res_root = lx_resdoc.getDocumentElement()

    LET lx_pnode = lx_resdoc.createElement("srvver")    #建立 <srvver> 
    CALL lx_res_root.appendChild(lx_pnode)
    LET lx_tnode = lx_resdoc.createTextNode(l_tp_version)
    CALL lx_pnode.appendChild(lx_tnode)
    
    LET lx_pnode = lx_resdoc.createElement("srvcode")    #建立 <srvcode> 
    CALL lx_res_root.appendChild(lx_pnode)
    LET lx_tnode = lx_resdoc.createTextNode(g_srvcode)
    CALL lx_pnode.appendChild(lx_tnode)

    LET lx_pnode = lx_resdoc.createElement("payload")    #建立 <payload> 
    CALL lx_res_root.appendChild(lx_pnode)
    IF NOT cl_null(g_response.response) THEN
       LET lx_tnode = lx_resdoc.createCDATASection(g_response.response)
       CALL lx_pnode.appendChild(lx_tnode)
    END IF


    LET g_response.response = lx_resdoc.saveToString()
   
END FUNCTION

#[
# Description....: CALL Function
# Date & Author..: 2011/04/01 by Echo
# Parameter......: p_name   -  STRING -   服務名稱
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_invoke_srv_callFunction(p_name)
DEFINE p_name   STRING
   
    LET g_method_name  = p_name

    #------------------------------------------------------------------------------------------------------#
    # 請新增每一個 ERP 服務時, 於以下新增call Service Function 段落                                        #
    # 此處定義的 Service Name 必須與設定作業中輸入的一致                                                   #
    # CASE p_name                                                                                          #
    #  WHEN "GetItemData"                                                                                  #
    #       CALL aws_get_item_data()                                                                       #
    #                                                                                                      #
    #------------------------------------------------------------------------------------------------------#

    CASE p_name
       WHEN "CheckConnection" 
            LET g_response.response = aws_efsrv_sub(g_request.request)

       WHEN "GetDocumentList" 
            LET g_response.response = aws_efsrv_sub(g_request.request)

       WHEN "GetProgramID" 
            LET g_response.response = aws_efsrv_sub(g_request.request)

       WHEN "OpenDocument" 
            LET g_response.response = aws_efsrv_sub(g_request.request)

       WHEN "SetStatus" 
            LET g_response.response = aws_efsrv_sub(g_request.request)

       WHEN "TIPTOPGateWay"
            CALL TIPTOPGateWay()

       WHEN "GetItemData"
            CALL aws_GetItemData()

       WHEN "GetBomData"
            CALL aws_GetBomData()

       WHEN "GetDocumentNumber"
            CALL aws_GetDocumentNumber()

       WHEN "CreateCustomerData"
            CALL aws_CreateCustomerData()

       WHEN "CreateQuotationData"
            CALL aws_CreateQuotationData()

       WHEN "CreateItemMasterData"
            CALL aws_CreateItemMasterData()

       WHEN "CreateVendorData"
            CALL aws_CreateVendorData()

       WHEN "CreateEmployeeData"
            CALL aws_CreateEmployeeData()

       WHEN "CreateAddressData"
            CALL aws_CreateAddressData()

       WHEN "GetInspectionData"
            CALL aws_GetInspectionData()

       WHEN "GetAreaData"
            CALL aws_GetAreaData()

       WHEN "GetAccountSubjectData"
            CALL aws_GetAccountSubjectData()

       WHEN "GetComponentrepsubData"
            CALL aws_GetComponentrepsubData()

       WHEN "GetAxmDocument"
            CALL aws_GetAxmDocument()

       WHEN "GetAreaList"
            CALL aws_GetAreaList()

       WHEN "GetCostGroupData"
            CALL aws_GetCostGroupData()

       WHEN "GetCountryData"
            CALL aws_GetCountryData()

       WHEN "GetCountryList"
            CALL aws_GetCountryList()

       WHEN "GetCurrencyData"
            CALL aws_GetCurrencyData()

       WHEN "GetCurrencyList"
            CALL aws_GetCurrencyList()

       WHEN "GetCustList"
            CALL aws_GetCustList()

       WHEN "GetCustomerData"
            CALL aws_GetCustomerData()

       WHEN "GetCustomerProductData"
            CALL aws_GetCustomerProductData()

       WHEN "GetDepartmentData"
            CALL aws_GetDepartmentData()

       WHEN "GetDepartmentList"
            CALL aws_GetDepartmentList()

       WHEN "GetEmployeeData"
            CALL aws_GetEmployeeData()

       WHEN "GetEmployeeList"
            CALL aws_GetEmployeeList()

       WHEN "GetItemList"
            CALL aws_GetItemList()

       WHEN "GetMonthList"
            CALL aws_GetMonthList()

       WHEN "GetOrganizationList"
            CALL aws_GetOrganizationList()

       WHEN "GetOverdueAmtRankingData"
            CALL aws_GetOverdueAmtRankingData()

       WHEN "GetOverdueAmtDetailData"
            CALL aws_GetOverdueAmtDetailData()

       WHEN "GetProdClassList"
            CALL aws_GetProdClassList()

       WHEN "GetSalesDetailData"
            CALL aws_GetSalesDetailData()

       WHEN "GetSalesStatisticsData"
            CALL aws_GetSalesStatisticsData()

       WHEN "GetSOInfoData"
            CALL aws_GetSOInfoData()

       WHEN "GetSOInfoDetailData"
            CALL aws_GetSOInfoDetailData()

       WHEN "GetSupplierData"
            CALL aws_GetSupplierData()

       WHEN "GetSupplierItemData"
            CALL aws_GetSupplierItemData()

       WHEN "CreateBOMData"
            CALL aws_CreateBOMData()

       WHEN "GetOperationData"
            CALL aws_GetOperationData()

       WHEN "GetUnitData"
            CALL aws_GetUnitData()

       WHEN "GetBasicCodeData"
            CALL aws_GetBasicCodeData()

       WHEN "GetWarehouseData"
            CALL aws_GetWarehouseData()

       WHEN "GetLocationData"
            CALL aws_GetLocationData()

       WHEN "GetProductClassData"
            CALL aws_GetProductClassData()

       WHEN "CreateIssueReturnData"
            CALL aws_CreateIssueReturnData()

       WHEN "CreateStockInData"
            CALL aws_CreateStockInData()

       WHEN "GetUserToken"
            CALL aws_GetUserToken()

       WHEN "CheckUserAuth"
            CALL aws_CheckUserAuth()

       WHEN "GetMenuData"
            CALL aws_GetMenuData()

       WHEN "CheckExecAuthorization"
            CALL aws_CheckExecAuthorization()

       WHEN "CreatePOReceivingData"
            CALL aws_CreatePOReceivingData()

       WHEN "CreatePurchaseStockIn"
            CALL aws_CreatePurchaseStockIn()

       WHEN "CreatePurchaseStockOut"
            CALL aws_CreatePurchaseStockOut()

       WHEN "CreateWOStockinData"
            CALL aws_CreateWOStockinData()

       WHEN "GetCountingLabelData"
            CALL aws_GetCountingLabelData()

       WHEN "GetFQCData"
            CALL aws_GetFQCData()

       WHEN "GetItemStockList"
            CALL aws_GetItemStockList()

       WHEN "GetLabelTypeData"
            CALL aws_GetLabelTypeData()

       WHEN "GetMFGDocument"
            CALL aws_GetMFGDocument()

       WHEN "GetPOData"
            CALL aws_GetPOData()

       WHEN "GetPOReceivingInData"
            CALL aws_GetPOReceivingInData()

       WHEN "GetPOReceivingOutData"
            CALL aws_GetPOReceivingOutData()

       WHEN "GetPurchaseStockInQty"
            CALL aws_GetPurchaseStockInQty()

       WHEN "GetPurchaseStockOutQty"
            CALL aws_GetPurchaseStockOutQty()

       WHEN "GetReasonCode"
            CALL aws_GetReasonCode()

       WHEN "GetReceivingQty"
            CALL aws_GetReceivingQty()

       WHEN "GetStockData"
            CALL aws_GetStockData()

       WHEN "GetWOData"
            CALL aws_GetWOData()

       WHEN "GetWOIssueData"
            CALL aws_GetWOIssueData()

       WHEN "GetWOStockQty"
            CALL aws_GetWOStockQty()

       WHEN "UpdateCountingLabelData"
            CALL aws_UpdateCountingLabelData()

       WHEN "UpdateWOIssueData"
            CALL aws_UpdateWOIssueData()

       WHEN "CreateSalesReturn"
            CALL aws_CreateSalesReturn()

       WHEN "CreateShippingOrder"
            CALL aws_CreateShippingOrder()

       WHEN "CreateTransferNote"
            CALL aws_CreateTransferNote()

       WHEN "GetQtyConversion"
            CALL aws_GetQtyConversion()

       WHEN "GetSalesDocument"
            CALL aws_GetSalesDocument()

       WHEN "GetShippingNoticeData"
            CALL aws_GetShippingNoticeData()

       WHEN "GetShippingOrderData"
            CALL aws_GetShippingOrderData()

       WHEN "CreateStockData"
            CALL aws_CreateStockData()

       WHEN "CreateMISCIssueData"
            CALL aws_CreateMISCIssueData()

       WHEN "RunCommand"
            CALL aws_RunCommand()

       WHEN "EboGetCustData"
            CALL aws_EboGetCustData()

       WHEN "EboGetProdData"
            CALL aws_EboGetProdData()

       WHEN "EboGetOrderData"
            CALL aws_EboGetOrderData()

       WHEN "CheckApsExecution"
            CALL aws_CheckApsExecution()

       WHEN "GetReportData"                        
            CALL aws_GetReportData()

       WHEN "GetCustomerContactData"
            CALL aws_GetCustomerContactData()

       WHEN "GetCustomerOtheraddressData"
            CALL aws_GetCustomerOtheraddressData()

       WHEN "GetPackingMethodData"
            CALL aws_GetPackingMethodData()

       WHEN "GetTaxTypeData"
            CALL aws_GetTaxTypeData()

       WHEN "GetUnitConversionData"
            CALL aws_GetUnitConversionData()

       WHEN "GetMFGSettingSmaData"
            CALL aws_GetMFGSettingSmaData()

       WHEN "CreatePotentialCustomerData"
            CALL aws_CreatePotentialCustomerData()

       WHEN "CreateCustomerContactData"
            CALL aws_CreateCustomerContactData()

       WHEN "CreateCustomerOtheraddressData"
            CALL aws_CreateCustomerOtheraddressData()

       WHEN "aws_CRMgetCustomerData"
            CALL aws_CRMgetCustomerData()

       WHEN "GetPotentialCustomerData"
            CALL aws_GetPotentialCustomerData()

       WHEN "GetTableAmendmentData"
            CALL aws_GetTableAmendmentData()

      #FUN-930139 add end----------------
      #FUN-AA0022 add str----------------

       WHEN "GetAccountTypeData"
            CALL aws_GetAccountTypeData()

       WHEN "GetAccountData"
            CALL aws_GetAccountData()

       WHEN "CreateVoucherData"
            CALL aws_CreateVoucherData()

       WHEN "GetVoucherDocumentData"
            CALL aws_GetVoucherDocumentData()

       WHEN "GetTransactionCategory"
            CALL aws_GetTransactionCategory()

       WHEN "CreateBillingAP"
            CALL aws_CreateBillingAP()

       WHEN "CreateDepartmentData"
            CALL aws_CreateDepartmentData()

       WHEN "aws_rollbackVoucherData"
            CALL aws_rollbackVoucherData()

      #FUN-AA0022 add end----------------
       WHEN "GetPaymentTermsData"                                                                                #FUN-Ac0068 add 
            CALL aws_GetPaymentTermsData()  #FUN-AC0068 add

       WHEN "CreateShippingOrdersWithoutOrders"                                                                                #FUN-B10004 add
            CALL aws_CreateShippingOrdersWithoutOrders()  #FUN-B10004 add

       WHEN "GetSSOKey"                                                                                          #FUN-B10003 add
            CALL aws_GetSSOKey()            #FUN-B10003 add           

       WHEN "GetItemGroupData"                                                                                   #FUN-B30026 add
            CALL aws_GetItemGroupData()     #FUN-B30026 add

       WHEN "GetItemOtherGroupData"                                                                                   #FUN-B30147 add
            CALL aws_GetItemOtherGroupData()     #FUN-B30147 add

       WHEN "aws_getProdState"
            CALL aws_get_prod_state()

       WHEN "aws_getProdInfo"
            CALL aws_get_prod_Info()

       WHEN "aws_getOnlineUser"
            CALL aws_get_online_user()

       WHEN "aws_createWOWorkReportData"
            CALL aws_create_wo_work_report_data()
     
      #FUN-B70110 add str----------------
       WHEN "GetOrganizationList"
            CALL aws_getOrganizationList()
           
       WHEN "GetAccountTypeData"
            CALL aws_getAccountTypeData()
           
       WHEN "GetAccountData"
            CALL aws_getAccountData()
           
       WHEN "GetVoucherDocumentData"
            CALL aws_getVoucherDocumentData()
           
       WHEN "GetTransactionCategory"
            CALL aws_getTransactionCategory()
           
       WHEN "GetSupplierData"
            CALL aws_getSupplierData()
           
       WHEN "GetCurrencyData"
            CALL aws_getCurrencyData()
           
       WHEN "CreateVoucherData"
            CALL aws_createVoucherData()
           
       WHEN "CreateBillingAP"
            CALL aws_createBillingAP()
           
       WHEN "CreateDepartmentData"
            CALL aws_createDepartmentData()
           
       WHEN "CreateEmployeeData"
            CALL aws_createEmployeeData()
           
       WHEN "RollbackVoucherData"
            CALL aws_rollbackVoucherData()
      #FUN-B70110 add end----------------

      #FUN-B70116 add str----------------
       WHEN "GetMFGDocument"
            CALL aws_getMFGDocument()
           
       WHEN "CreateMISCIssueData"
            CALL aws_CreateMISCIssueData()
           
       WHEN "GetReasonCode"
            CALL aws_getReasonCode()
           
       WHEN "GetStockData"
            CALL aws_getStockData()
           
       WHEN "GetWarehouseData"
            CALL aws_getWarehouseData()
           
       WHEN "GetAxmDocument"
            CALL aws_getAxmDocument()
           
       WHEN "GetPaymentTermsData"
            CALL aws_getPaymentTermsData()
           
       WHEN "GetOrganizationList"
            CALL aws_getOrganizationList()
           
       WHEN "GetItemStockList"
            CALL aws_getItemStockList()
           
       WHEN "CreateShippingOrdersWithoutOrders"
            CALL aws_createShippingOrdersWithoutOrders()
           
       WHEN "GetItemGroupData"
            CALL aws_getItemGroupData()
           
       WHEN "GetItemOtherGroupData"
            CALL aws_getItemOtherGroupData()
      #FUN-B70116 add end----------------

      WHEN "SyncAccountData"                #FUN-B60090 add
            CALL aws_syncAccountData()      #FUN-B60090 add 
 
      WHEN "GetMemberData"                  #FUN-B60123 add
            CALL aws_getMemberData()        #FUN-B60123 add 

      #FUN-C40065 add str----------------
       WHEN "GetCustClassificationData"
            CALL aws_getCustClassificationData()

       WHEN "GetTradeTermData"
            CALL aws_getTradeTermData()

       WHEN "GetInvoiceTypeList"
            CALL aws_getInvoiceTypeList()
      #FUN-C40065 add end----------------

      #FUN-C50138 add str----------------
       WHEN "ModPassWord"
           CALL aws_modPassWord()

       WHEN "GetMemberCardInfo"
           CALL aws_getMemberCardInfo()

       WHEN "WritePoint"
           CALL aws_writePoint()

       WHEN "GetCashCardInfo"
           CALL aws_getCashCardInfo() 

       WHEN "DeductMoney"
           CALL aws_deductMoney()

       WHEN "CheckGiftNo"
           CALL aws_checkGiftNo()

       WHEN "DeductGiftNO"
           CALL aws_deductGiftNO()

       WHEN "GetScore"
           CALL aws_getScore()

       WHEN "DeductScore"
           CALL aws_deductScore()

       WHEN "DeductSPayment"
           CALL aws_deductPayment()

      #FUN-C50138 add end----------------     

      #FUN-B90089 add str------------------
       WHEN "GetDataCount"
            CALL aws_getDataCount()

       WHEN "GetUserDefOrg"
            CALL aws_getUserDefOrg()

       WHEN "GetSOData"
            CALL aws_getSOData()

       WHEN "GetShappingData"
            CALL aws_getShappingData()

       WHEN "GetCustomerAccAmtData"
            CALL aws_getCustomerAccAmtData()

       WHEN "GetQuotationData"
            CALL aws_getQuotationData()
      #FUN-B90089 add end------------------   

      #FUN-CA0090 Add Begin ---
       WHEN "GetCardScore"    #取會員可扣減積分
          CALL aws_getCardScore()
       WHEN "RechargeCard"    #取儲值卡充值信息
          CALL aws_recharge_card()
       WHEN "SelCardInfo"     #取儲值卡餘額
          CALL aws_sel_card_info()
       WHEN "CheckCard"       #取會員卡金額
          CALL aws_check_card()
       WHEN "ChangeCard"      #取會員卡换卡信息
          CALL aws_change_card()
       WHEN "CheckCoupon"     #取售券退券信息
          CALL aws_check_coupon()
       WHEN "CheckCardType"   #取會員卡卡种
          CALL aws_check_card_type()
       WHEN "ReturnCard"      #退卡金额
          CALL aws_return_card()
      #FUN-CA0090 Add End -----
       WHEN "ReturnOrderBill" #取訂單是否可退信息   #FUN-CB0104 add
          CALL aws_return_order_bill()              #FUN-CB0104 add
       WHEN "GetOrderInfo"    #取訂單信息           #FUN-CB0104 add
          CALL aws_get_order_info()                 #FUN-CB0104 add
      #DEV-C80002 add str---
       WHEN "GetAPCategoryAccountCode"
            CALL aws_getAPCategoryAccountCode()

       WHEN "RollbackBillingAP"
            CALL aws_rollbackBillingAP()
      #DEV-C80002 add end---
       #FUN-CC0135 ADD STR----
       WHEN "CheckMemberUpgrade" #取会员是否可以升等信息
          CALL aws_check_member_upgrade()
       WHEN "MemberUpgrade"      #取会员升等是否成功信息
          CALL aws_member_upgrade()
       #FUN-CC0135 ADD END----
       OTHERWISE
            LET g_srvcode = "100"       #服務未按照正常流程執行
    END CASE

END FUNCTION
#FUN-C20087
