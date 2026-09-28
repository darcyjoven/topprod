# auther :darcy
# date :2022/09/01
# describe: bpm抛转公共函数

import xml
database ds

globals "../../../tiptop/config/top.global"
#  content为报文内容
#  回传response 字符串
#  request和response自动保存到TEMPDIR文件下
function cws_bpm_invoke_by_go(content)
    define content string
    
    define url  string
    define doc  xml.DomDocument
    define file base.Channel 

    define req,res string
    define response string
    define cmd string

    #  设置URL
    if cl_null(url) then
        let url = "http://192.168.1.45:8086/NaNaWeb/services/PLMIntegrationEFGP"
    end if

    # 获取xml文件名
    let req = current year to fraction(3)
    let req = cl_replace_str(req," ","")
    let req = cl_replace_str(req,":","")
    let req = cl_replace_str(req,".","")
    let res = "response_",req,".xml"
    let req = "request_",req,".xml"
    let res =  fgl_getenv("TEMPDIR"),"/",res
    let req =  fgl_getenv("TEMPDIR"),"/",req
    # 保存request文件
    try
        let doc = xml.DomDocument.create()
        call doc.loadFromString(content)
        call doc.save(req)
    catch
        return ""
    end try

    # 运行invokProcess
    try
        let cmd = "/u1/usr/tiptop/bpm/invokProcess '",url,"' ",req
        RUN cmd
    catch
        return ""
    end try
    # res
    try 
        let file = base.Channel.create()
        call file.openFile(res,"r")
        let response = file.readLine()
    catch
        return ""
    end try
    return response
end function

# 获取员工信息
# OID,id,name,orgUnitType,orgName,isMain
function cws_bpm_getOrg(p_user)
    define p_user  string

    define l_status     like type_file.num10
    define l_response   string
    define responseXml  xml.DomDocument 
    define l1           xml.DomNodeList
    define n1,n2,n3     xml.DomNode
    define filename string
    define index        like type_file.num5

    define OID string
    define id string
    define name string
    define orgUnitType string
    define orgName string
    define isMain varchar(10)

    call fetchOrgUnitOfUserId(p_user)
        returning l_status,l_response
    
    if l_status!=0 then
        return "","","","","",""
    else
        #call cimi999_save(l_response,"fetchOrgUnitOfUserId")
        #    returning filename 
        let responseXml = xml.DomDocument.Create()
        call responseXml.loadFromString(l_response)
        
        if responseXml.getErrorsCount() > 0 then
            return
        end if

        let OID = cws_bpm_getRecordfield(responseXml,"OID")
        let id = cws_bpm_getRecordfield(responseXml,"id")
        let name = cws_bpm_getRecordfield(responseXml,"name")
        
        let orgUnitType = cws_bpm_selectByXPath(responseXml,"//orgUnitType/value","value")
        #cws_bpm_getRecordfield(responseXml,"orgUnitType")

        let orgName = cws_bpm_getRecordfield(responseXml,"orgName")
        let isMain = cws_bpm_getRecordfield(responseXml,"isMain")

        return OID,id,name,orgUnitType,orgName,isMain
    end if
end function

# 获取BPM部门编号
function cws_bpm_getGem(p_user)
    define p_user  string

    define OID string
    define id string
    define name string
    define orgUnitType string
    define orgName string
    define isMain varchar(10)

    call cws_bpm_getOrg(p_user) 
        returning OID,id,name,orgUnitType,orgName,isMain

    return id
end function

# 获取节点值
function cws_bpm_getRecordfield(content,fieldname)
    define content          xml.DomDocument
    define fieldname        string

    define values string

    define l        xml.DomNodeList
    define n1,n2    xml.domnode

    let l = content.getElementsByTagName(fieldname)
    if l.getCount() > 0 then
        let n1 = l.getItem(1)
        let values = n1.toString()
        let values = cl_replace_str(values,"<"||fieldname||">","")
        let values = cl_replace_str(values,"</"||fieldname||">","")
    else
        return ""
    end if

    return values
end function

# 遍历获取子节点的值
# expr "//div/a"
# 需要测试
function cws_bpm_selectByXPath(content,expr,fieldname)
    define content          xml.DomDocument
    define expr,fieldname   string

    define values string

    define l        xml.DomNodeList
    define n1,n2    xml.domnode

    let l = content.selectByXPath(expr,NULL)
    if l.getCount() > 0 then
        let n1 = l.getItem(1)
        let values = n1.toString()
        let values = cl_replace_str(values,"<"||fieldname||">","")
        let values = cl_replace_str(values,"</"||fieldname||">","")
    else
        return ""
    end if

    return values
end function

#去除前后两端的<></>
function cws_bpm_replace_item(content)
    define content string
    define i       integer

    let i = content.getIndexOf(">",1)
    let content = content.subString(i+1,content.getLength())
    let i = content.getIndexOf("</",1)
    let content = content.subString(1,i-1)

    return content
end function

# 设置invokcontent内容
# 需要表单ID，主旨，formfieldvalue
# 回传请求报文
function cws_bpm_set_invoke_request(
    pProcessPackageId ,
    pSubject ,
    pFormFieldValue 
)
    define invokeProcessReturn string
    define l_FormDefOID string

    define pProcessPackageId string
    define pSubject string
    define pFormFieldValue string

    define l_status     like type_file.num10
    define l_response   string
    define l_request   string

    define OID string
    define id string
    define name string
    define orgUnitType string
    define orgName string
    define isMain varchar(10)
 

    # 获取表单OID
    #findFormOIDsOfProcess(p_pProcessPackageId)
    call findFormOIDsOfProcess(pProcessPackageId) 
        returning l_status,l_response
    
    if status !=0 then
        return
    else
        let l_FormDefOID = l_response
    end if

    # 获取组织信息
    #fetchOrgUnitOfUserId(p_pUserId)
    call cws_bpm_getOrg(g_user)
        returning OID,id,name,orgUnitType,orgName,isMain

    # 送签
    let l_request =
       '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.nana.dsc.com/">
           <soapenv:Header/>
           <soapenv:Body>
               <web:invokeProcess soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                   <pProcessPackageId xsi:type="xsd:string">',pProcessPackageId,'</pProcessPackageId>
                   <pRequesterId xsi:type="xsd:string">',g_user,'</pRequesterId>
                   <pOrgUnitId xsi:type="xsd:string">',id,'</pOrgUnitId>
                   <pFormDefOID xsi:type="xsd:string">',l_FormDefOID,'</pFormDefOID>
                   <pFormFieldValue xsi:type="xsd:string">',pFormFieldValue,'</pFormFieldValue>
                   <pSubject xsi:type="xsd:string">',pSubject,'</pSubject>
               </web:invokeProcess>
           </soapenv:Body>
       </soapenv:Envelope>'
    # let l_response = cimi999_invok_by_golang(l_request) 
    
    return l_request
end function

# 撤销流程，需要传入单号和bpm单号。
function cws_bpm_unsign(erp_no,bpm_no)
    define bpm_no string
    define erp_no string

    define success like type_file.chr1

    define comment  string
    define l_gen02  like gen_file.gen02
    define l_status integer 
    select gen02 into l_gen02 from gen_file where gen01 = g_user

    let comment = g_user," ",l_gen02,"撤销了单据 by ERP",erp_no

    call abortProcessForSerialNo(bpm_no,comment)
        returning l_status
    
    if l_status ==0 then
        return true
    else
        return false
    end if
end function
