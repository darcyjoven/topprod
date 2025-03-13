# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: goldtaxlib.4gl
# Descriptions...: GoldTax Interface
# Date & Author..: 2009/12/08 David Lee  #No.FUN-A70006
# Modify.........:
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-D10136 13/04/22 By zhangweib 增加發票種類

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE GoldTax_Handle INTEGER                  #GoldTax_Handle is an integer variable receiving the status

############################### Standard TIPTOP Component Object Model Interface David Lee 2009/12/08 david_fluid@msn.com #################################################

TYPE Method_Argv DYNAMIC ARRAY OF RECORD
  argv_string   STRING
  ,argv_integer INTEGER
  ,argv_float   FLOAT
  ,argv_date    DATE
END RECORD

DEFINE  Arg Method_Argv                       #Arg are the arguments to pass to the GoldTax method call. 
 
##################################################
# Descriptions...: show error message 
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: p_msg is a description of  error which occurred
# Return code....:
# Modify.........:
##################################################
FUNCTION __ShowMessage(p_msg)
DEFINE p_msg STRING
  MENU "ERROR MESSAGE"
    ATTRIBUTES ( STYLE="dialog", COMMENT=p_msg)
    BEFORE MENU
    COMMAND "OK"
      DISPLAY "MESSAGE: I see!"
    ON IDLE 10
      DISPLAY "MESSAGE: Auto close!"
      EXIT MENU
  END MENU
END FUNCTION

##################################################
# Descriptions...: Gets a description of the last error which occurred 
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
#                  p_result: p_result is either a handle or a value of a predefined type.
#                  p_line: p_line is the description of COM error for call at line
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __CheckErrorInteger(p_result, p_line)
DEFINE p_result	 INTEGER
DEFINE p_line	 INTEGER
  DEFINE ls_result		STRING
  
  IF -1=p_result THEN
    DISPLAY "ERROR: COM Error for call at line:", p_line
    CALL ui.Interface.frontCall("WinCOM","GetError",[],[ls_result])
    LET ls_result="ERROR: ",ls_result
    CALL __ShowMessage(ls_result)
    RETURN -1  #Fail
  END IF
RETURN 0  #Succeed
END FUNCTION

##################################################
# Descriptions...: Gets a description of the last error which occurred 
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
#                  p_result: p_result is either a handle or a value of a predefined type.
#                  p_line: p_line is the description of COM error for call at line
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __CheckErrorString(p_result, p_line)
DEFINE p_result	 STRING
DEFINE p_line	 INTEGER
  DEFINE ls_result		STRING
  
  IF -1=p_result THEN
    DISPLAY "ERROR: COM Error for call at line:", p_line
    CALL ui.Interface.frontCall("WinCOM","GetError",[],[ls_result])
    LET ls_result="ERROR: ",ls_result
    CALL __ShowMessage(ls_result)
    RETURN -1  #Fail
  END IF
RETURN 0  #Succeed
END FUNCTION

##################################################
# Descriptions...: Gets a description of the last error which occurred 
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
#                  p_result: p_result is either a handle or a value of a predefined type.
#                  p_line: p_line is the description of COM error for call at line
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __CheckErrorDate(p_result, p_line)
DEFINE p_result	 DATE
DEFINE p_line	 INTEGER
  DEFINE ls_result		STRING
  
  IF -1=p_result THEN
    DISPLAY "ERROR: COM Error for call at line:", p_line
    CALL ui.Interface.frontCall("WinCOM","GetError",[],[ls_result])
    LET ls_result="ERROR: ",ls_result
    CALL __ShowMessage(ls_result)
    RETURN -1  #Fail
  END IF
RETURN 0  #Succeed
END FUNCTION

##################################################
# Descriptions...: Gets a description of the last error which occurred 
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
#                  p_result: p_result is either a handle or a value of a predefined type.
#                  p_line: p_line is the description of COM error for call at line
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __CheckErrorFloat(p_result, p_line)
DEFINE p_result	 FLOAT
DEFINE p_line	 INTEGER
  DEFINE ls_result		STRING
  
  IF -1=p_result THEN
    DISPLAY "ERROR: COM Error for call at line:", p_line
    CALL ui.Interface.frontCall("WinCOM","GetError",[],[ls_result])
    LET ls_result="ERROR: ",ls_result
    CALL __ShowMessage(ls_result)
    RETURN -1  #Fail
  END IF
RETURN 0  #Succeed
END FUNCTION

##################################################
# Descriptions...: Releases an Instance  
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty). 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __ReleaseInstance(p_handle)
DEFINE p_handle INTEGER
  DEFINE li_result  	INTEGER
  DEFINE ls_result      STRING
  IF p_handle != -1 THEN
    CALL ui.Interface.frontCall("WinCOM","ReleaseInstance", [p_handle],[li_result] )   
    IF -1=li_result THEN
      CALL ui.Interface.frontCall("WinCOM","GetError",[],[ls_result])
      LET ls_result="ERROR: ",ls_result
      CALL __ShowMessage(ls_result)      
      RETURN -1
    END IF
    RETURN 0
  END IF   
RETURN -1
END FUNCTION

##################################################
# Descriptions...: Creates an instance of a registered object 
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: p_classname is the classname of the registered COM object. 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __CreateInstance(p_classname)
DEFINE p_classname STRING
  DEFINE li_handle INTEGER
  DEFINE li_status INTEGER
  LET li_handle=-1
  CALL ui.Interface.frontCall("WinCOM","CreateInstance",[p_classname], [li_handle] )
  LET li_status=-1
  CALL __CheckErrorInteger(li_handle, __LINE__) RETURNING li_status
  IF 0=li_status THEN
    RETURN li_handle  #Succeed 
  END IF 
RETURN -1  #Fail
END FUNCTION


##################################################
# Descriptions...: Sets a property of the p_handle.
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
#                  p_handle: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty).  
#                  p_member: p_member is the member property name to set. 
#                  p_value: p_value is the value to which the property will be set. 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __SetPropertyString(p_handle,p_member,p_value)
DEFINE p_handle INTEGER
DEFINE p_member STRING
DEFINE p_value STRING
   DEFINE li_result INTEGER
   LET li_result=-1
   CALL ui.Interface.frontCall("WinCOM","SetProperty",[p_handle,p_member,p_value], [li_result] )
   RETURN __CheckErrorInteger(li_result, __LINE__)
END FUNCTION

##################################################
# Descriptions...: Sets a property of the p_handle.
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
#                  p_handle: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty).  
#                  p_member: p_member is the member property name to set. 
#                  p_value: p_value is the value to which the property will be set. 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __SetPropertyDate(p_handle,p_member,p_value)
DEFINE p_handle INTEGER
DEFINE p_member STRING
DEFINE p_value DATE
   DEFINE li_result INTEGER
   LET li_result=-1
   CALL ui.Interface.frontCall("WinCOM","SetProperty",[p_handle,p_member,p_value], [li_result] )
   RETURN __CheckErrorInteger(li_result, __LINE__)
END FUNCTION

##################################################
# Descriptions...: Sets a property of the p_handle.
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
#                  p_handle: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty).  
#                  p_member: p_member is the member property name to set. 
#                  p_value: p_value is the value to which the property will be set. 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __SetPropertyInteger(p_handle,p_member,p_value)
DEFINE p_handle INTEGER
DEFINE p_member STRING
DEFINE p_value INTEGER
   DEFINE li_result INTEGER
   LET li_result=-1
   CALL ui.Interface.frontCall("WinCOM","SetProperty",[p_handle,p_member,p_value], [li_result] )
   RETURN __CheckErrorInteger(li_result, __LINE__)
END FUNCTION

##################################################
# Descriptions...: Sets a property of the p_handle.
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
#                  p_handle: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty).  
#                  p_member: p_member is the member property name to set. 
#                  p_value: p_value is the value to which the property will be set. 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION __SetPropertyFloat(p_handle,p_member,p_value)
DEFINE p_handle INTEGER
DEFINE p_member STRING
#DEFINE p_value FLOAT
DEFINE p_value STRING
   DEFINE li_result INTEGER
   LET li_result=-1
   CALL ui.Interface.frontCall("WinCOM","SetProperty",[p_handle,p_member,p_value], [li_result] )
   RETURN __CheckErrorInteger(li_result, __LINE__)
END FUNCTION

##################################################
# Descriptions...: Gets a property of the p_handle.
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter:
#                  p_handle: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty).   
#                  p_member: p_member is the member property name to get. 
# Return code....:  first result:  -1 fail,0 succeed; last result is either a handle or a value of string. 
# Modify.........:
##################################################
FUNCTION __GetPropertyString(p_handle,p_memeber)
DEFINE p_handle INTEGER
DEFINE p_memeber STRING
  DEFINE l_result STRING

  LET l_result=-1
  CALL ui.Interface.frontCall("WinCOM","GetProperty",[p_handle,p_memeber], [l_result] )

RETURN __CheckErrorString(l_result, __LINE__),l_result 
END FUNCTION

##################################################
# Descriptions...: Gets a property of the p_handle.
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter:
#                  p_handle: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty).   
#                  p_member: p_member is the member property name to get. 
# Return code....: first result: -1 fail,0 succeed; last result is either a handle or a value of date. 
# Modify.........:
##################################################
FUNCTION __GetPropertyDate(p_handle,p_memeber)
DEFINE p_handle INTEGER
DEFINE p_memeber STRING
  DEFINE l_result DATE

  LET l_result=-1
  CALL ui.Interface.frontCall("WinCOM","GetProperty",[p_handle,p_memeber], [l_result] )

RETURN __CheckErrorDate(l_result, __LINE__),l_result
END FUNCTION

##################################################
# Descriptions...: Gets a property of the p_handle.
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter:
#                  p_handle: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty).   
#                  p_member: p_member is the member property name to get. 
# Return code....: first result: -1 fail,0 succeed; last result is either a handle or a value of integer. 
# Modify.........:
##################################################
FUNCTION __GetPropertyInteger(p_handle,p_memeber)
DEFINE p_handle INTEGER
DEFINE p_memeber STRING
  DEFINE l_result INTEGER

  LET l_result=-1
  CALL ui.Interface.frontCall("WinCOM","GetProperty",[p_handle,p_memeber], [l_result] )

RETURN __CheckErrorInteger(l_result, __LINE__),l_result 
END FUNCTION

##################################################
# Descriptions...: Gets a property of the p_handle.
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter:
#                  p_handle: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty).   
#                  p_member: p_member is the member property name to get. 
# Return code....: first result: -1 fail,0 succeed; last result is either a handle or a value of float. 
# Modify.........:
##################################################
FUNCTION __GetPropertyFloat(p_handle,p_memeber)
DEFINE p_handle INTEGER
DEFINE p_memeber STRING
  DEFINE l_result FLOAT

  LET l_result=-1
  CALL ui.Interface.frontCall("WinCOM","GetProperty",[p_handle,p_memeber], [l_result] )

RETURN __CheckErrorFloat(l_result, __LINE__),l_result
END FUNCTION

##################################################
# Descriptions...: calls a method on a specified object.
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
#                  p_handle: p_handle is the handle returned by another frontcall (CreateInstance, CallMethod, GetProperty).   
#                  p_method: p_method is the member name to call. 
#                  p_argv:   p_argv are the arguments to pass to the method call. 
# Return code....:
# Modify.........:
##################################################
FUNCTION __CallMethod(p_handle,p_method,p_argv)
DEFINE p_handle INTEGER
DEFINE p_method STRING
DEFINE p_argv Method_Argv
  DEFINE li_result  INTEGER 
  DEFINE ls_result  STRING

  LET li_result=-1
  
  CASE p_argv.getLength()
    WHEN 0
      CALL ui.interface.frontCall("WinCOM", "CallMethod", [p_handle, p_method], [li_result])
    WHEN 1
      CASE
        WHEN p_argv[1].argv_string IS NOT NULL
          CALL ui.interface.frontCall("WinCOM", "CallMethod", [p_handle, p_method,p_argv[1].argv_string], [li_result])
        WHEN p_argv[1].argv_integer IS NOT NULL
          CALL ui.interface.frontCall("WinCOM", "CallMethod", [p_handle, p_method,p_argv[1].argv_integer], [li_result])
        WHEN p_argv[1].argv_float IS NOT NULL
          CALL ui.interface.frontCall("WinCOM", "CallMethod", [p_handle, p_method,p_argv[1].argv_float], [li_result])
        WHEN p_argv[1].argv_date IS NOT NULL
          CALL ui.interface.frontCall("WinCOM", "CallMethod", [p_handle, p_method,p_argv[1].argv_date], [li_result])
        OTHERWISE
          CALL ui.interface.frontCall("WinCOM", "CallMethod", [p_handle, p_method,NULL], [li_result])
      END CASE

    #... ...
    #... ...
    #... ...
    #... ...

    OTHERWISE
      LET ls_result="ERROR: CALL ",p_method," fail!"
      CALL __ShowMessage(ls_result)
      RETURN -1
  END CASE
  RETURN __CheckErrorInteger(li_result, __LINE__) 
END FUNCTION

###########################################################################################################################################################################



######################################################## Standard TIPTOP GoldTax Interface David Lee 2009/12/10 david_fluid@msn.com #######################################

##################################################
# Descriptions...: 开启金税卡
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION OpenCard()

  LET GoldTax_Handle=-1
  LET GoldTax_Handle= __CreateInstance("TaxCardX.GoldTax")
  IF -1=GoldTax_Handle THEN
    RETURN -1
  END IF

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"OpenCard",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 关闭金税卡
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION CloseCard()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"CloseCard",Arg) THEN
    RETURN -1
  END IF

  IF -1=__ReleaseInstance(GoldTax_Handle) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 获取金税卡信息
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION GetInfo()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"GetInfo",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 开具发票
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION Invoice()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"Invoice",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 作废发票
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION CancelInv()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"CancelInv",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 打印发票或清单
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION PrintInv()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"PrintInv",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 增加发票一行明细信息
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION AddInvList()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"AddInvList",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 清除全部发票明细信息
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION ClearInvList()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"ClearInvList",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 初始化发票整体信息
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION InvInfoInit()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"InvInfoInit",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 初始化发票明细信息
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION InvListInit()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"InvListInit",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION MakeInv()

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"MakeInv",Arg) THEN
    RETURN -1
  END IF

RETURN 0
END FUNCTION

##################################################
# Descriptions...: 获取纳税人识别号(只读)
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,0,TaxCode ;fail return -1,unknown 
# Modify.........:
##################################################
FUNCTION GetTaxCode()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
  CALL __GetPropertyString(GoldTax_Handle,"TaxCode") RETURNING li_result,l_result
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 获取销货清单生成标志，0：无清单，1：有清单
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,0,GoodsListFlag;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetGoodsListFlag()
  DEFINE li_result INTEGER
  DEFINE l_result INTEGER
  CALL __GetPropertyInteger(GoldTax_Handle,"GoodsListFlag") RETURNING li_result,l_result
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置销货清单生成标志，0：无清单，1：有清单
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetGoodsListFlag(p_value)
DEFINE p_value INTEGER
RETURN __SetPropertyInteger(GoldTax_Handle,"GoodsListFlag",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票合计不含税金额(只读) 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoAmount;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoAmount()
  DEFINE li_result INTEGER
  DEFINE l_result FLOAT
 
  CALL __GetPropertyFloat(GoldTax_Handle,"InfoAmount") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 获取发票对应销售单据号码 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoBillNumber;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoBillNumber()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoBillNumber") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票对应销售单据号码
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoBillNumber(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoBillNumber",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票收款人 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoCashier;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoCashier()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoCashier") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票收款人
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoCashier(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoCashier",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票复核人 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoChecker;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoChecker()
  DEFINE li_result INTEGER
  DEFINE l_result  STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoChecker") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票复核人
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoChecker(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoChecker",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票购方地址电话 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoClientAddressPhone ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoClientAddressPhone()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoClientAddressPhone") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票购方地址电话
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoClientAddressPhone(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoClientAddressPhone",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票购方银行账号 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoClientBankAccount;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoClientBankAccount()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoClientBankAccount") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票购方银行账号
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoClientBankAccount(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoClientBankAccount",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票客户名称 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoClientName;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoClientName()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoClientName") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票客户名称
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoClientName(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoClientName",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票购方税号 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoClientTaxCode ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoClientTaxCode()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoClientTaxCode") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票购方税号
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoClientTaxCode(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoClientTaxCode",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取开票日期 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoDate;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoDate()
  DEFINE li_result INTEGER
  DEFINE l_result  DATE
 
  CALL __GetPropertyDATE(GoldTax_Handle,"InfoDate") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置开票日期
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoDate(p_value)
DEFINE p_value DATE
RETURN __SetPropertyDate(GoldTax_Handle,"InfoDate",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票开票人 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoInvoicer;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoInvoicer()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoInvoicer") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票开票人
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoInvoicer(p_value)
DEFINE p_value STRING 
RETURN __SetPropertyString(GoldTax_Handle,"InfoInvoicer",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票清单行商品名称
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoListName;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoListName()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoListName") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票清单行商品名称
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoListName(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoListName",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票所属月份 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoMonth ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoMonth()
  DEFINE li_result INTEGER
  DEFINE l_result  INTEGER
 
  CALL __GetPropertyInteger(GoldTax_Handle,"InfoMonth") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票所属月份
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoMonth(p_value)
DEFINE p_value INTEGER
RETURN __SetPropertyInteger(GoldTax_Handle,"InfoMonth",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票备注 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoNotes;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoNotes()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoNotes") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票备注
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoNotes(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoNotes",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票号码 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoNumber;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoNumber()
  DEFINE li_result INTEGER
  DEFINE l_result  INTEGER
 
  CALL __GetPropertyInteger(GoldTax_Handle,"InfoNumber") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票号码
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoNumber(p_value)
DEFINE p_value INTEGER
RETURN __SetPropertyInteger(GoldTax_Handle,"InfoNumber",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票销方地址电话
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoSellerAddressPhone ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoSellerAddressPhone()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoSellerAddressPhone") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票销方地址电话
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoSellerAddressPhone(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoSellerAddressPhone",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票销方银行账号 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoSellerBankAccount ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoSellerBankAccount()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoSellerBankAccount") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票销方银行账号
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoSellerBankAccount(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoSellerBankAccount",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票合计税额 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoTaxAmount;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoTaxAmount()
  DEFINE li_result INTEGER
  DEFINE l_result  FLOAT
 
  CALL __GetPropertyFloat(GoldTax_Handle,"InfoTaxAmount") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票合计税额
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoTaxAmount(p_value)
DEFINE p_value FLOAT
RETURN __SetPropertyFloat(GoldTax_Handle,"InfoTaxAmount",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取发票税率
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoTaxRate;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoTaxRate()
  DEFINE li_result INTEGER
  DEFINE l_result STRING 
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoTaxRate") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票税率
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoTaxRate(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoTaxRate",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取10位发票代码 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InfoTypeCode;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoTypeCode()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"InfoTypeCode") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置10位发票代码
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoTypeCode(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoTypeCode",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取不含税金额开票限额(只读) 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InvLimit;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInvLimit()
  DEFINE li_result INTEGER
  DEFINE l_result FLOAT
 
  CALL __GetPropertyFloat(GoldTax_Handle,"InvLimit") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 获取金税卡发票库存卷数(只读) 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,InvStock;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInvStock()
  DEFINE li_result INTEGER
  DEFINE l_result INTEGER 
 
  CALL __GetPropertyInteger(GoldTax_Handle,"InvStock") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 获取金税卡发票已空标志(只读)
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,IsInvEmpty;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetIsInvEmpty()
  DEFINE li_result INTEGER
  DEFINE l_result INTEGER
 
  CALL __GetPropertyInteger(GoldTax_Handle,"IsInvEmpty") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 获取金税卡已到锁死期标志(只读) 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,IsLockReached;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetIsLockReached()
  DEFINE li_result INTEGER
  DEFINE l_result  INTEGER
 
  CALL __GetPropertyInteger(GoldTax_Handle,"IsLockReached") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 获取金税卡已到抄税期标志(只读) 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,IsRepReached;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetIsRepReached()
  DEFINE li_result INTEGER
  DEFINE l_result  INTEGER
 
  CALL __GetPropertyInteger(GoldTax_Handle,"IsRepReached") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 获取商品行不含税金额 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,ListAmount ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetListAmount()
  DEFINE li_result INTEGER
  DEFINE l_result FLOAT
 
  CALL __GetPropertyFloat(GoldTax_Handle,"ListAmount") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置商品行不含税金额
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetListAmount(p_value)
DEFINE p_value FLOAT
RETURN __SetPropertyFloat(GoldTax_Handle,"ListAmount",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取商品行货物名称 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,ListGoodsName;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetListGoodsName()
  DEFINE li_result INTEGER
  DEFINE l_result  STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"ListGoodsName") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置商品行货物名称
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetListGoodsName(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"ListGoodsName",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取商品行数量 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,ListNumber;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetListNumber()
  DEFINE li_result INTEGER
  DEFINE l_result FlOAT
 
  CALL __GetPropertyFloat(GoldTax_Handle,"ListNumber") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置商品行数量
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetListNumber(p_value)
DEFINE p_value FLOAT
RETURN __SetPropertyFloat(GoldTax_Handle,"ListNumber",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取商品行单价 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,ListPrice ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetListPrice()
  DEFINE li_result INTEGER
  DEFINE l_result  FLOAT
 
  CALL __GetPropertyFloat(GoldTax_Handle,"ListPrice") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置商品行单价
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetListPrice(p_value)
DEFINE p_value FLOAT
RETURN __SetPropertyFloat(GoldTax_Handle,"ListPrice",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取商品行单价种类，0：不含税，1：含税
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,ListPriceKind;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetListPriceKind()
  DEFINE li_result INTEGER
  DEFINE l_result  INTEGER
 
  CALL __GetPropertyInteger(GoldTax_Handle,"ListPriceKind") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置商品行单价种类，0：不含税，1：含税
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetListPriceKind(p_value)
DEFINE p_value INTEGER
RETURN __SetPropertyInteger(GoldTax_Handle,"ListPriceKind",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取商品行规格型号 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,ListStandard ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetListStandard()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"ListStandard") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置商品行规格型号
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetListStandard(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"ListStandard",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取商品行税额 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetListTaxAmount()
  DEFINE li_result INTEGER
  DEFINE l_result FLOAT
 
  CALL __GetPropertyFloat(GoldTax_Handle,"ListTaxAmount") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置商品行税额
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetListTaxAmount(p_value)
DEFINE p_value FLOAT
RETURN __SetPropertyFloat(GoldTax_Handle,"ListTaxAmount",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取商品行4位税目代码 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,ListTaxItem;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetListTaxItem()
  DEFINE li_result INTEGER
  DEFINE l_result STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"ListTaxItem") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置商品行4位税目代码
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetListTaxItem(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"ListTaxItem",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取商品行计量单位 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,ListUnit ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetListUnit()
  DEFINE li_result INTEGER
  DEFINE l_result  STRING
 
  CALL __GetPropertyString(GoldTax_Handle,"ListUnit") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置商品行计量单位
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetListUnit(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"ListUnit",p_value)
END FUNCTION

##################################################
# Descriptions...: 获取开票机号码(只读) 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,MachineNo ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetMachineNo()
  DEFINE li_result INTEGER
  DEFINE l_result  INTEGER
 
  CALL __GetPropertyInteger(GoldTax_Handle,"MachineNo") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 获取返回状态码(只读) 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,RetCode;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetRetCode()
  DEFINE li_result INTEGER
  DEFINE l_result  INTEGER
 
  CALL __GetPropertyInteger(GoldTax_Handle,"RetCode") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 获取金税卡时钟(只读) 
# Date & Author..: 2009/12/10 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....: succeed return 0,TaxClock ;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetTaxClock()
  DEFINE li_result INTEGER
  DEFINE l_result  DATE
 
  CALL __GetPropertyDate(GoldTax_Handle,"TaxClock") RETURNING li_result,l_result
  
RETURN li_result,l_result
END FUNCTION

###########################################################################################################################################################################


##################################################
# Descriptions...: Unit Test 
# Date & Author..: 2009/12/08 David Lee david_fluid@msn.com
# Input Parameter: 
# Return code....:
# Modify.........:
##################################################
FUNCTION UnitTest()

  DEFINE Arg Method_Argv
  DEFINE li_result INTEGER
  DEFINE lf_ListAmount FLOAT
  
  ##### Unit Test Standard TIPTOP Component Object Model Interface David Lee 2009/12/08 david_fluid@msn.com #########

  LET GoldTax_Handle= __CreateInstance("TaxCardX.GoldTax")
  IF -1=GoldTax_Handle THEN
    DISPLAY "__CreateInstance Fail!"
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
    EXIT PROGRAM
  ELSE 
    DISPLAY "__CreateInstance Succeed!"
  END IF

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"OpenCard",Arg) THEN
    DISPLAY "__CallMethod Fail!"
  ELSE 
    DISPLAY "__CallMethod Succeed!" 
  END IF

  #... ...
  #... ...
  #... ...
  
  LET lf_ListAmount=1.00
  IF -1=__SetPropertyInteger(GoldTax_Handle,"ListAmount",lf_ListAmount) THEN
    DISPLAY "__SetPropertyInteger Fail!"
  ELSE
    DISPLAY "__SetPropertyIneter Succeed!"
  END IF

  CALL __GetPropertyFloat(GoldTax_Handle,"ListAmount") RETURNING li_result,lf_ListAmount
  IF -1=li_result THEN
    DISPLAY "__GetPropertyFloat Fail!"
  ELSE 
    IF 1.00=lf_ListAmount THEN
      DISPLAY "__GetPropertyFloat Succeed!"
    END IF
  END IF

  INITIALIZE Arg TO NULL
  IF -1=__CallMethod(GoldTax_Handle,"CloseCard",Arg) THEN
    DISPLAY "__CallMethod CloseCard Fail!"
  END IF
   
  IF -1=__ReleaseInstance(GoldTax_Handle) THEN
    DISPLAY "__ReleaseInstance Fail!"
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
    EXIT PROGRAM
  ELSE
    DISPLAY "__ReleaseInstance Succeed!"
  END IF


  ###### Unit Test Standard TIPTOP GoldTax Interface David Lee 2009/12/10 david_fluid@msn.com #########

  IF -1=OpenCard() THEN
    DISPLAY "OpenCard Fail!"
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
    EXIT PROGRAM
  ELSE
    DISPLAY "OpenCard Succeed!"
  END IF


  LET lf_ListAmount=2.00
  IF -1= SetListAmount(lf_ListAmount) THEN
    DISPLAY "SetListAmount Fail!"
  ELSE 
    DISPLAY "SetListAmount Succeed!"
  END IF 

  CALL GetListAmount() RETURNING li_result,lf_ListAmount
  IF 0=li_result THEN
    IF 2.00=lf_ListAmount THEN
      DISPLAY "GetListAmount Succeed!" 
    END IF
  ELSE
    DISPLAY "CALL GetListAmount  Fail!"
  END IF

  #... ...
  #... ...
  #... ...

  IF -1=CloseCard() THEN
    DISPLAY "CALL CloseCard Fail!"
  ELSE
    DISPLAY "CloseCard Succeed!"
  END IF

END FUNCTION

#No.FUN-A70006

#No.FUN-D10136 ---start--- Add
##################################################
# Descriptions...: 获取发票種類
# Date & Author..: 2013/01/21 luttb
# Input Parameter:
# Return code....: succeed return 0,InfoListName;fail return -1,unknown
# Modify.........:
##################################################
FUNCTION GetInfoKind()
  DEFINE li_result INTEGER
  DEFINE l_result STRING

  CALL __GetPropertyString(GoldTax_Handle,"InfoKind") RETURNING li_result,l_result

RETURN li_result,l_result
END FUNCTION

##################################################
# Descriptions...: 设置发票種類 0:專用發票，1:廢舊物資發票 2:普通發票
# Date & Author..: 2013/01/23 luttb
# Input Parameter:
# Return code....: -1 fail;0 succeed
# Modify.........:
##################################################
FUNCTION SetInfoKind(p_value)
DEFINE p_value STRING
RETURN __SetPropertyString(GoldTax_Handle,"InfoKind",p_value)
END FUNCTION
#No.FUN-D10136 ---end  --- Add
