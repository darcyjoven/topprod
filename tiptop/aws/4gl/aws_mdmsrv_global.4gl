# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_mdmsrv_global.4gl
# Descriptions...: TIPTOP & MDM 整合- TIPTOP Services 服務全域變數檔
# Date & Author..: 08/06/05 By Echo FUN-850147
# Modify.........: 08/10/03 By kevin FUN-890113 多筆傳送
# Memo...........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-850147
 
GLOBALS
 
#
#-------------------------------------------------------------------------------
# XML Type definitions 
#-------------------------------------------------------------------------------
#
 
#
# TYPE : tns1Field
#
TYPE tns1Field RECORD ATTRIBUTE(XSTypeName="Field",XSTypeNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
  name STRING ATTRIBUTE(XMLName="name"),
  value STRING ATTRIBUTE(XMLName="value")
END RECORD
#-------------------------------------------------------------------------------
 
#
# TYPE : tns1ArrayOfField
#
TYPE tns1ArrayOfField RECORD ATTRIBUTE(XSTypeName="ArrayOfField",XSTypeNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
  Field DYNAMIC ARRAY ATTRIBUTE(XMLList) OF tns1Field ATTRIBUTE(XMLName="Field")
END RECORD
#-------------------------------------------------------------------------------
 
#
# TYPE : tns1Record
#
TYPE tns1Record RECORD ATTRIBUTE(XSTypeName="Record",XSTypeNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
  action STRING ATTRIBUTE(XMLName="action"), #FUN-890113
  fields tns1ArrayOfField ATTRIBUTE(XMLName="fields"),
  id STRING ATTRIBUTE(XMLName="id"),
  refId STRING ATTRIBUTE(XMLName="refId")
END RECORD
#-------------------------------------------------------------------------------
 
#
# TYPE : tns1ArrayOfRecord
#
TYPE tns1ArrayOfRecord RECORD ATTRIBUTE(XSTypeName="ArrayOfRecord",XSTypeNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
  Record DYNAMIC ARRAY ATTRIBUTE(XMLList) OF tns1Record ATTRIBUTE(XMLName="Record")
END RECORD
#-------------------------------------------------------------------------------
 
#
# TYPE : tns1MasterData
#
TYPE tns1MasterData RECORD ATTRIBUTE(XSTypeName="MasterData",XSTypeNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
  action STRING ATTRIBUTE(XMLName="action"),
  applicationNameFrom STRING ATTRIBUTE(XMLName="applicationNameFrom"),
  applicationNameTo STRING ATTRIBUTE(XMLName="applicationNameTo"),
  flowName STRING ATTRIBUTE(XMLName="flowName"),
  loginUser STRING ATTRIBUTE(XMLName="loginUser"),
  mddTableName STRING ATTRIBUTE(XMLName="mddTableName"),
  records tns1ArrayOfRecord ATTRIBUTE(XMLName="records"),
  username STRING ATTRIBUTE(XMLName="username")
END RECORD
#-------------------------------------------------------------------------------
 
#
# TYPE : tns1SyncRecord
#
TYPE tns1SyncRecord RECORD ATTRIBUTE(XSTypeName="SyncRecord",XSTypeNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
  description STRING ATTRIBUTE(XMLName="description"),
  id DECIMAL(19,0) ATTRIBUTE(XSDlong,XMLName="id"),
  record tns1Record ATTRIBUTE(XMLName="record"),
  status INTEGER ATTRIBUTE(XMLName="status")
END RECORD
#-------------------------------------------------------------------------------
 
#
# TYPE : tns1ArrayOfSyncRecord
#
TYPE tns1ArrayOfSyncRecord RECORD ATTRIBUTE(XSTypeName="ArrayOfSyncRecord",XSTypeNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
  SyncRecord DYNAMIC ARRAY ATTRIBUTE(XMLList) OF tns1SyncRecord ATTRIBUTE(XMLName="SyncRecord")
END RECORD
#-------------------------------------------------------------------------------
 
#
# TYPE : tns1SyncLog
#
TYPE tns1SyncLog RECORD ATTRIBUTE(XSTypeName="SyncLog",XSTypeNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
  action STRING ATTRIBUTE(XMLName="action"),
  applicationNameFrom STRING ATTRIBUTE(XMLName="applicationNameFrom"),
  applicationNameTo STRING ATTRIBUTE(XMLName="applicationNameTo"),
  createDate DATETIME YEAR TO FRACTION(5) ATTRIBUTE(XMLName="createDate"),
  errorMessage STRING ATTRIBUTE(XMLName="errorMessage"),
  flowName STRING ATTRIBUTE(XMLName="flowName"),
  id DECIMAL(19,0) ATTRIBUTE(XSDlong,XMLName="id"),
  mddTableName STRING ATTRIBUTE(XMLName="mddTableName"),
  loginUser STRING ATTRIBUTE(XMLName="loginUser"), 
  serviceName STRING ATTRIBUTE(XMLName="serviceName"),
  status INTEGER ATTRIBUTE(XMLName="status"),
  syncRecords tns1ArrayOfSyncRecord ATTRIBUTE(XMLName="syncRecords"),
  username STRING ATTRIBUTE(XMLName="username")
END RECORD
#-------------------------------------------------------------------------------
 
 
# VARIABLE : syncMasterData
DEFINE syncMasterData_in RECORD ATTRIBUTE(XMLName="syncMasterData",XMLNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
         in0 tns1MasterData ATTRIBUTE(XMLName="in0")
       END RECORD
 
 
#-------------------------------------------------------------------------------
 
# VARIABLE : syncMasterDataResponse
DEFINE syncMasterData_out RECORD ATTRIBUTE(XMLName="syncMasterDataResponse",XMLNamespace="http://www.dsc.com.tw/tiptop/ITPMDMWebService")
         out tns1SyncLog ATTRIBUTE(XMLName="out")
       END RECORD
 
 
#-------------------------------------------------------------------------------
DEFINE mule RECORD ATTRIBUTE(XMLName="mule",XMLNamespace="http://www.muleumo.org/providers/soap/1.0")
         MULE_CORRELATION_ID STRING ATTRIBUTE(XMLName="MULE_CORRELATION_ID"),
         MULE_CORRELATION_GROUP_SIZE STRING ATTRIBUTE(XMLName="MULE_CORRELATION_GROUP_SIZE"),
         MULE_CORRELATION_SEQUENCE STRING ATTRIBUTE(XMLName="MULE_CORRELATION_SEQUENCE")
       END RECORD
END GLOBALS
