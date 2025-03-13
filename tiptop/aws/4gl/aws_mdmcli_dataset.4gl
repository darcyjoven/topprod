# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: aws_mdmcli_dataset
# Descriptions...: 定義 MDM 各 Serivce 的flowname及 抓取設定檔的 Service 名稱
# Parameter......: 
# Return code....: 
# Date & Author..: 08/06/05 By Echo FUN-850147
# Modify.........: NO.FUN-860036 08/06/11 By kim 加入MDM的相關服務
#
 
IMPORT com
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#No.FUN-850147
 
GLOBALS "../4gl/aws_mdmgw.inc"
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_service       STRING
END GLOBALS
 
 
FUNCTION aws_mdmcli_dataset()
 
  CASE ns2invokeMDMFlow.in0.mddTableName
    WHEN "customer" 
         #定義要執行的流程名稱
         LET ns2invokeMDMFlow.in0.flowName = "MDM01"
         
         #指定抓取設定檔的 Service
         LET g_service = "CreateCustomerData"
    WHEN "itemmaster" #FUN-860036
         #定義要執行的流程名稱
         LET ns2invokeMDMFlow.in0.flowName = "MDM02"
         
         #指定抓取設定檔的 Service
         LET g_service = "CreateItemMasterData"
   
    WHEN "employee" #FUN-860036
         #定義要執行的流程名稱
         LET ns2invokeMDMFlow.in0.flowName = "MDM03"
         
         #指定抓取設定檔的 Service
         LET g_service = "CreateEmployeeData"
    WHEN "vendor" #FUN-860036
         #定義要執行的流程名稱
         LET ns2invokeMDMFlow.in0.flowName = "MDM04"
         
         #指定抓取設定檔的 Service
         LET g_service = "CreateVendorData"
    WHEN "address" #FUN-860036
         #定義要執行的流程名稱
         LET ns2invokeMDMFlow.in0.flowName = "MDM05"
         
         #指定抓取設定檔的 Service
         LET g_service = "CreateAddressData"
    WHEN "bom" 
         #定義要執行的流程名稱
         LET ns2invokeMDMFlow.in0.flowName = "MDM06"
         
         #指定抓取設定檔的 Service
         LET g_service = "CreateBOMData"
 
  END CASE 
END FUNCTION
