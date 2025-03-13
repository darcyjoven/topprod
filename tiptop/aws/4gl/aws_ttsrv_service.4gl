# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv_service.4gl
# Descriptions...: 公開各種 TIPTOP 服務
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
#
#}
# Modify.........: No.FUN-760069 07/06/25 By Mandy 新增Portal專案銷售統計Porlet會用到的Service
# Modify.........: No.FUN-770051 07/07/13 By Mandy 新增Portal專案訂逾期帳款/訂單資訊Porlet會用到的Service
# Modify.........: No.FUN-820029 08/02/20 By Kevin 新增CRM整合TITPOP客戶資訊service
# Modify.........: No.FUN-850022 08/06/26 By Kevin 新增e-Bonline整合回傳檢驗碼(rvb39)service
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 建立並公開各種 TIPTOP 服務
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
 
FUNCTION aws_ttsrv_publishService()
    
    WHENEVER ERROR CONTINUE
 
    #--------------------------------------------------------------------------#
    # 以下建立新的 TIPTOP 服務                                                 #
    #--------------------------------------------------------------------------#
    CALL fgl_ws_server_publishfunction(
        "CreateCustomerData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_createCustomerData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_createCustomerData_out",
        "aws_createCustomerData"
    )
    
    CALL fgl_ws_server_publishfunction(
        "GetAXMDocument",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getAXMDocument_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getAXMDocument_out",
        "aws_getAXMDocument"
    )
    
    CALL fgl_ws_server_publishfunction(
        "CreateQuotationData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_createQuotationData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_createQuotationData_out",
        "aws_createQuotationData"
    )
 
    CALL fgl_ws_server_publishfunction(
        "GetOrganizationList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getOrganizationList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getOrganizationList_out",
        "aws_getOrganizationList"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetCurrencyList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCurrencyList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCurrencyList_out",
        "aws_getCurrencyList"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetCurrencyData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCurrencyData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCurrencyData_out",
        "aws_getCurrencyData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetAreaList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getAreaList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getAreaList_out",
        "aws_getAreaList"
    )    
  
    CALL fgl_ws_server_publishfunction(
        "GetAreaData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getAreaData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getAreaData_out",
        "aws_getAreaData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetCountryList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCountryList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCountryList_out",
        "aws_getCountryList"
    )
    
    CALL fgl_ws_server_publishfunction(
        "GetCountryData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCountryData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCountryData_out",
        "aws_getCountryData"
    )
    
    CALL fgl_ws_server_publishfunction(
        "GetEmployeeList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getEmployeeList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getEmployeeList_out",
        "aws_getEmployeeList"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetItemList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getItemList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getItemList_out",
        "aws_getItemList"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetEmployeeData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getEmployeeData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getEmployeeData_out",
        "aws_getEmployeeData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetItemData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getItemData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getItemData_out",
        "aws_getItemData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetDepartmentList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getDepartmentList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getDepartmentList_out",
        "aws_getDepartmentList"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetDepartmentData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getDepartmentData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getDepartmentData_out",
        "aws_getDepartmentData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetSupplierData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSupplierData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSupplierData_out",
        "aws_getSupplierData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetSupplierItemData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSupplierItemData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSupplierItemData_out",
        "aws_getSupplierItemData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetCustomerData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCustomerData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCustomerData_out",
        "aws_getCustomerData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetCustomerProductData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCustomerProductData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCustomerProductData_out",
        "aws_getCustomerProductData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetComponentRepSubData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getComponentRepSubData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getComponentRepSubData_out",
        "aws_getComponentRepSubData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetBOMData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getBOMData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getBOMData_out",
        "aws_getBOMData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetCostGroupData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCostGroupData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCostGroupData_out",
        "aws_getCostGroupData"
    )    
 
    CALL fgl_ws_server_publishfunction(
        "GetAccountSubjectData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getAccountSubjectData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getAccountSubjectData_out",
        "aws_getAccountSubjectData"
    )    
    #FUN-760069 add-----------------------str-------
    CALL fgl_ws_server_publishfunction(
        "GetCustList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCustList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getCustList_out",
        "aws_getCustList"
    )    
    CALL fgl_ws_server_publishfunction(
        "GetProdClassList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getProdClassList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getProdClassList_out",
        "aws_getProdClassList"
    )    
    CALL fgl_ws_server_publishfunction(
        "GetMonthList",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getMonthList_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getMonthList_out",
        "aws_getMonthList"
    )    
    CALL fgl_ws_server_publishfunction(
        "GetSalesStatisticsData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSalesStatisticsData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSalesStatisticsData_out",
        "aws_getSalesStatisticsData"
    )    
    CALL fgl_ws_server_publishfunction(
        "GetSalesDetailData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSalesDetailData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSalesDetailData_out",
        "aws_getSalesDetailData"
    )    
    #FUN-760069 add-----------------------end-------
    #FUN-770051 add-----------------------str-------
    #訂單資訊
    CALL fgl_ws_server_publishfunction(
        "GetSOInfoData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSOInfoData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSOInfoData_out",
        "aws_getSOInfoData"
    )    
    #訂單資訊明細
    CALL fgl_ws_server_publishfunction(
        "GetSOInfoDetailData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSOInfoDetailData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getSOInfoDetailData_out",
        "aws_getSOInfoDetailData"
    )    
    #逾期帳款排行
    CALL fgl_ws_server_publishfunction(
        "GetOverdueAmtRankingData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getOverdueAmtRankingData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getOverdueAmtRankingData_out",
        "aws_getOverdueAmtRankingData"
    )    
 
    #逾期帳款排行明細
    CALL fgl_ws_server_publishfunction(
        "GetOverdueAmtDetailData",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getOverdueAmtDetailData_in",
        "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getOverdueAmtDetailData_out",
        "aws_getOverdueAmtDetailData"
    )    
    #FUN-770051 add-----------------------end-------
    
    #FUN-820029 --start--
    #CRM整合TITPOP客戶資訊
    CALL fgl_ws_server_publishfunction(
       "CRMGetCustomerData",
       "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_CRMGetCustomerData_in",
       "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_CRMGetCustomerData_out",
       "aws_CRMGetCustomerData"
    )
    #FUN-820029 --end--
    
    #FUN-850022 --start--
    #e-B Online整合回傳檢驗碼
    CALL fgl_ws_server_publishfunction(
      "GetInspectionData",
      "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getInspectionData_in",
      "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay", "g_getInspectionData_out",
      "aws_getInspectionData"
    )
    #FUN-850022 --end--
 
 
END FUNCTION
 
FUNCTION aws_getAXMDocument()
 
    LET g_service = "GetAXMDocument"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getAXMDocument_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 銷售系統單別                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getAXMDocument_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getAXMDocument_out))    
 
END FUNCTION
 
FUNCTION aws_createQuotationData()
 
 
    LET g_service = "CreateQuotationData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_createQuotationData_in))
 
    #--------------------------------------------------------------------------#
    # 建立報價單資料                                                           #
    #--------------------------------------------------------------------------#        
    CALL aws_createQuotationData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_createQuotationData_out))    
 
END FUNCTION
 
FUNCTION aws_getCountryList()
 
    LET g_service = "GetCountryList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getCountryList_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 國別代碼                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_getCountryList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getCountryList_out))    
 
END FUNCTION
 
FUNCTION aws_getCountryData()
 
    LET g_service = "GetCountryData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getCountryData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 國別資料                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_getCountryData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getCountryData_out))    
 
END FUNCTION
 
FUNCTION aws_getAreaList()
 
    LET g_service = "GetAreaList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getAreaList_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 區域代碼                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_getAreaList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getAreaList_out))    
 
END FUNCTION
 
FUNCTION aws_getAreaData()
 
    LET g_service = "GetAreaData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getAreaData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 區域資料                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_getAreaData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getAreaData_out))    
 
END FUNCTION
 
FUNCTION aws_getCurrencyList()
 
    LET g_service = "GetCurrencyList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getCurrencyList_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 區域代碼                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_getCurrencyList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getCurrencyList_out))    
 
END FUNCTION
 
FUNCTION aws_getCurrencyData()
 
    LET g_service = "GetCurrencyData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getCurrencyData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 幣別資料                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_getCurrencyData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getCurrencyData_out))    
 
END FUNCTION
 
FUNCTION aws_getEmployeeData()
 
    LET g_service = "GetEmployeeData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getEmployeeData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 員工資料                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_getEmployeeData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getEmployeeData_out))    
 
END FUNCTION
 
FUNCTION aws_getEmployeeList()
 
    LET g_service = "GetEmployeeList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getEmployeeList_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 員工編號列表                                                    #
    #--------------------------------------------------------------------------#        
     CALL aws_getEmployeeList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getEmployeeList_out))    
 
END FUNCTION
 
FUNCTION aws_getItemData()
 
    LET g_service = "GetItemData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getItemData_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 料件資料                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_getItemData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getItemData_out))
 
END FUNCTION
 
FUNCTION aws_getItemList() 
 
    LET g_service = "GetItemList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getItemList_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 料件編號列表                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getItemList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getItemList_out))
 
END FUNCTION
 
FUNCTION aws_getOrganizationList()
 
    LET g_service = "GetOrganizationList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getOrganizationList_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 營運中心代碼                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getOrganizationList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getOrganizationList_out))
 
END FUNCTION
 
FUNCTION aws_createCustomerData() 
 
    LET g_service = "CreateCustomerData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_createCustomerData_in))
 
    #--------------------------------------------------------------------------#
    # 建立客戶基本資料                                                         #
    #--------------------------------------------------------------------------#        
     CALL aws_createCustomerData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_createCustomerData_out))
 
END FUNCTION 
 
FUNCTION aws_getDepartmentList()
 
    LET g_service = "GetDepartmentList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getDepartmentList_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 部門編號列表                                                    #
    #--------------------------------------------------------------------------#        
     CALL aws_getDepartmentList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getDepartmentList_out))    
 
END FUNCTION
 
FUNCTION aws_getDepartmentData()
 
    LET g_service = "GetDepartmentData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getDepartmentData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 部門資料                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_getDepartmentData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getDepartmentData_out))    
 
END FUNCTION
 
FUNCTION aws_getSupplierData()
 
    LET g_service = "GetSupplierData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getSupplierData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 供應商基本資料                                                  #
    #--------------------------------------------------------------------------#        
    CALL aws_getSupplierData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getSupplierData_out))    
 
END FUNCTION
 
FUNCTION aws_getSupplierItemData()
 
    LET g_service = "GetSupplierItemData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getSupplierItemData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 供應商料件基本資料                                              #
    #--------------------------------------------------------------------------#        
    CALL aws_getSupplierItemData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getSupplierItemData_out))    
 
END FUNCTION
 
FUNCTION aws_getCustomerData()
 
    LET g_service = "GetCustomerData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getCustomerData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 供應商料件基本資料                                              #
    #--------------------------------------------------------------------------#        
    CALL aws_getCustomerData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getCustomerData_out))    
 
END FUNCTION
 
FUNCTION aws_getCustomerProductData()
 
    LET g_service = "GetCustomerProductData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getCustomerProductData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 供應商料件基本資料                                              #
    #--------------------------------------------------------------------------#        
    CALL aws_getCustomerProductData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getCustomerProductData_out))    
 
END FUNCTION
 
FUNCTION aws_getComponentRepSubData()
 
    LET g_service = "GetComponentRepSubData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getComponentRepSubData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 供應商料件基本資料                                              #
    #--------------------------------------------------------------------------#        
    CALL aws_getComponentRepSubData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getComponentRepSubData_out))    
 
END FUNCTION
 
FUNCTION aws_getBOMData() 
    LET g_service = "GetBOMData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getBOMData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 供應商料件基本資料                                              #
    #--------------------------------------------------------------------------#        
    CALL aws_getBOMData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getBOMData_out))    
 
END FUNCTION
 
FUNCTION aws_getCostGroupData() 
    LET g_service = "GetCostGroupData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getCostGroupData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 成本分群資料                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getCostGroupData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getCostGroupData_out))    
 
END FUNCTION
 
FUNCTION aws_getAccountSubjectData() 
    LET g_service = "GetAccountSubjectData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getAccountSubjectData_in))
    
    #--------------------------------------------------------------------------#
    # 取得 ERP 會計科目資料                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getAccountSubjectData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getAccountSubjectData_out))    
 
END FUNCTION
 
#FUN-760069------------add-----------------str-------------------
FUNCTION aws_getCustList() 
 
    LET g_service = "GetCustList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getCustList_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 客戶編號(occ01)列表                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getCustList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getCustList_out))
 
END FUNCTION
 
FUNCTION aws_getProdClassList() 
 
    LET g_service = "GetProdClassList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getProdClassList_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 產品分類碼(oba01)列表                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getProdClassList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getProdClassList_out))
 
END FUNCTION
 
FUNCTION aws_getMonthList() 
 
    LET g_service = "GetMonthList"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getMonthList_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 月份(1~12)列表                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getMonthList_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getMonthList_out))
 
END FUNCTION
 
FUNCTION aws_getSalesStatisticsData() 
 
    LET g_service = "GetSalesStatisticsData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getSalesStatisticsData_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 銷售統計資料                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getSalesStatisticsData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getSalesStatisticsData_out))
 
END FUNCTION
 
FUNCTION aws_getSalesDetailData() 
 
    LET g_service = "GetSalesDetailData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getSalesDetailData_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 銷售統計資料                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getSalesDetailData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getSalesDetailData_out))
 
END FUNCTION
#FUN-760069------------add-----------------end-------------------
 
#FUN-770051------------add-----------------str-------------------
#訂單資訊
FUNCTION aws_getSOInfoData() 
 
    LET g_service = "GetSOInfoData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getSOInfoData_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 訂單資訊明細資料                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getSOInfoData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getSOInfoData_out))
 
END FUNCTION
 
#訂單資訊明細
FUNCTION aws_getSOInfoDetailData() 
 
    LET g_service = "GetSOInfoDetailData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getSOInfoDetailData_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 訂單資訊明細資料                                                    #
    #--------------------------------------------------------------------------#        
    CALL aws_getSOInfoDetailData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getSOInfoDetailData_out))
 
END FUNCTION
 
#逾期帳款排行
FUNCTION aws_getOverdueAmtRankingData() 
 
    LET g_service = "GetOverdueAmtRankingData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getOverdueAmtRankingData_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 逾期帳款排行
    #--------------------------------------------------------------------------#        
    CALL aws_getOverdueAmtRankingData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getOverdueAmtRankingData_out))
 
END FUNCTION
 
#逾期帳款排行明細
FUNCTION aws_getOverdueAmtDetailData() 
 
    LET g_service = "GetOverdueAmtDetailData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getOverdueAmtDetailData_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 逾期帳款排行明細
    #--------------------------------------------------------------------------#        
    CALL aws_getOverdueAmtDetailData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getOverdueAmtDetailData_out))
 
END FUNCTION
#FUN-770051------------add-----------------end-------------------
 
#FUN-820029 --start--
FUNCTION aws_CRMGetCustomerData()
 
    LET g_service = "CRMGetCustomerData"
    
    #--------------------------------------------------------------------------#
    # 寫入傳入參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_CRMGetCustomerData_in))
 
    #--------------------------------------------------------------------------#
    # 取得 ERP 客戶資訊                                                        #
    #--------------------------------------------------------------------------#        
    CALL aws_CRMGetCustomerData_g()
 
    #--------------------------------------------------------------------------#
    # 寫入回傳參數字串至記錄檔中                                               #
    #--------------------------------------------------------------------------#        
    CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_CRMGetCustomerData_out))    
 
END FUNCTION
#FUN-820029 --end--
 
#FUN-850022 --start--
FUNCTION aws_getInspectionData()
 
   LET g_service = "GetInspectionData"
 
   #--------------------------------------------------------------------------#
   # 寫入傳入參數字串至記錄檔中                                               #
   #--------------------------------------------------------------------------#
   CALL aws_ttsrv_writeInputLog(g_service, base.TypeInfo.create(g_getInspectionData_in))
 
   #--------------------------------------------------------------------------#
   # 取得 ERP 客戶資訊                                                        #
   #--------------------------------------------------------------------------#
   CALL aws_getInspectionData_g()
 
   #--------------------------------------------------------------------------#
   # 寫入回傳參數字串至記錄檔中                                               #
   #--------------------------------------------------------------------------#
   CALL aws_ttsrv_writeOutputLog(g_service, base.TypeInfo.create(g_getInspectionData_out))
END FUNCTION
#FUN-850022 --end--
 
