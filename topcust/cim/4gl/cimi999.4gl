# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cimi200.4gl
# Descriptions...: 料件计划维护
# Date & Author..:darcy:2023/04/20 add

import xml
import com

# json
IMPORT util
IMPORT JAVA com.alibaba.fastjson.JSON
IMPORT JAVA com.alibaba.fastjson.JSONArray
IMPORT JAVA com.alibaba.fastjson.JSONObject

# record
IMPORT JAVA com.fourjs.fgl.lang.FglRecord
IMPORT JAVA java.lang.Object
IMPORT JAVA java.lang.StringBuffer

# test
IMPORT JAVA java.lang.Class
IMPORT JAVA java.lang.reflect.Method


# web
IMPORT FGL WSHelper
# IMPORT xml

#  gva start
# DEFINE gvaReceive tgvaReceive ATTRIBUTE(XMLName="departmentReceive",XMLNamespace="http://service.ws.rs.com/")
# DEFINE gvaResponse tgvaResponse ATTRIBUTE(XMLName="departmentReceiveResponse",XMLNamespace="http://service.ws.rs.com/")
#  gva end

database ds
 
globals "../../../tiptop/config/top.global"

define  ProcessId,FormOID,UserId,OrgUnitId,FormFieldValue,
        Subject,ProcessInstanceSerialNo,AbortComment,ProcessInstanceOID,
        PostPSActDefsAsXML,WorkItmeOID,ReexecuteActivityId,
        ProcessInitialStartTime,ProcessInitialEndTime,ProcInstanceState,
        ProcInstanceClosedState,rocInstanceClosedState string

main
    define soapStatus integer
    define response string
    options                               #改變一些系統預設值
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("CIM")) then
        exit program
    end if


    call cs_restful_example()
    return

    # call fetchOrgUnitOfUserId("52948") 
    #     returning soapStatus,response

    # call findFormOIDsOfProcess("PKG16402198090401")
    #     returning soapStatus,response
    # response = "71465960f0761004824f9ef69d6dfbb3"

    # call getFormFieldTemplate("71465960f0761004824f9ef69d6dfbb3")
    #     returning soapStatus,response
    # <rjxtsqd>
    #     <tbr id="tbr" dataType="java.lang.String" perDataProId=""> </tbr>
    #     <sqr id="sqr" dataType="java.lang.String" hidden=""> </sqr>
    #     <sqbm id="sqbm" dataType="java.lang.String" hidden=""> </sqbm>
    #     <sqrq id="sqrq" dataType="java.lang.String" perDataProId=""> </sqrq>
    #     <lxfj id="lxfj" dataType="java.lang.String" perDataProId=""> </lxfj>
    #     <xtgs id="xtgs" dataType="java.lang.String" xtgs_txt=""></xtgs>
    #     <jqry id="jqry" dataType="java.lang.String" hidden=""> </jqry>
    #     <yxjb id="yxjb" dataType="java.lang.String"></yxjb>
    #     <xqsx id="xqsx" dataType="java.lang.String"></xqsx>
    #     <sfyyxgfzrygt id="sfyyxgfzrygt" dataType="java.lang.String"></sfyyxgfzrygt>
    #     <xgfzry id="xgfzry" dataType="java.lang.String" perDataProId=""> </xgfzry>
    #     <xqsm id="xqsm" dataType="java.lang.String" perDataProId=""> </xqsm>
    # </rjxtsqd>

    # 需要流程序号
    call fetchFullProcInstanceWithOID("71465960f0761004824f9ef69d6dfbb3")
        returning soapStatus,response
    call fetchFullProcInstanceWithOID("PKG1640219809040100000744")
        returning soapStatus,response

    # # 输出表单的实际内容，有填入值得
    # call fetchFullProcInstanceWithSerialNo("PKG1640219809040100000744")
    #     returning soapStatus,response

    call fetchFormInstanceWithProcOID("71465960f0761004824f9ef69d6dfbb3")
         returning soapStatus,response
end main


function gva()
    

end function
