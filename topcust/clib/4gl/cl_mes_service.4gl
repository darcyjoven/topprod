# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_mes_service.4gl
# Descriptions...: mes 接口
# Date & Author..: darcy:2024/02/23

import fgl WSHelper
import com
import xml
import libgjson #json解析库 

globals "./cl_mes_service.inc"
globals "../../../tiptop/config/top.global"

# 客退原因接口
define GetMesktReasonHTTPReq     com.HTTPRequest
define GetMesktReasonHTTPResp    com.HTTPResponse

# darcy:2024/04/25 add s---
# 删除mes杂发单领料记录
define DelMesUseNoHTTPReq     com.HTTPRequest
define DelMesUseNoHTTPResp    com.HTTPResponse
# darcy:2024/04/25 add e---

#-------------------------------------------------------------------------------
define GetWaitScrapHTTPReq     com.HTTPRequest
define GetWaitScrapHTTPResp    com.HTTPResponse
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
define DelMESLotNoHTTPReq     com.HTTPRequest
define DelMESLotNoHTTPResp    com.HTTPResponse
#-------------------------------------------------------------------------------


# define over

# 客退原因接口
function getMesktReason(p_sfb01)
    define p_sfb01  varchar(40)
    define	soapStatus		integer

    let getMesktReasonRequest.wo_no = p_sfb01

    let soapStatus = getMesktReason_g()
    
    return soapStatus,getMesktReasonResponse.getMesktReasonReturn
end function

# mes获得客退单据原因
# p_link clib/cl_mes_service  
# call getMesktReasonR(p_sfb01) returns ok,kt_no,kt_reason 
# ok  Y/N 是否成功 
# kt_no  客退单号
# kt_reson 客退原因,如果客退原因获得失败,是失败原因
function getMesktReasonR(p_sfb01)
    define p_sfb01  varchar(40)
    define soapStatus   integer
    define response     string
    define kt_no,kt_reason,temp_str  string
    define l_ok varchar(1)
    define tok base.StringTokenizer

    call getMesktReason(p_sfb01) returning soapStatus,response
    if soapStatus <0 then
        return 'N','',''
    end if
    
    let response = cl_replace_str(response,"{","")
    let response = cl_replace_str(response,"}","")
    let response = cl_replace_str(response,"[","")
    let response = cl_replace_str(response,"]","")
    let response = cl_replace_str(response,'"',"")

    let l_ok = ''

    let tok = base.StringTokenizer.create(response,":")
    let temp_str = tok.nextToken()
    if cl_null(temp_str) then
        return 'N','',''
    end if
    if temp_str == "fail" then
        let l_ok = 'N'
        let kt_reason = tok.nextToken()
        return l_ok,'',kt_reason
    end if
    if temp_str == "success" then
        let l_ok = 'Y'
        # kt_no
        let temp_str = tok.nextToken()
        let temp_str = tok.nextToken()
        let kt_no = cl_replace_str(temp_str,',kt_reason','')
        # kt_reason
        let kt_reason = tok.nextToken()
        return l_ok,kt_no,kt_reason
    end if
end function

function getMesktReason_g()
    define wsstatus   integer
    define retryAuth  integer
    define retryProxy integer
    define retry      integer
    define nb         integer
    define uri        string
    define setcookie  string
    define mustUnderstand integer
    define request    com.HTTPRequest
    define response   com.HTTPResponse
    define writer     xml.DomDocument
    define reader     xml.DomDocument
    define envelope   xml.DomNode
    define header     xml.DomNode
    define body       xml.DomNode
    define node       xml.DomNode

    #
    # INIT VARIABLES
    #
    LET wsstatus = -1
    LET retryAuth = FALSE
    LET retryProxy = FALSE
    LET retry = TRUE
    LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")

    IF ForewinWipToErpService.Address.Uri IS NULL THEN
        LET ForewinWipToErpService.Address.Uri = "http://192.168.1.247:8080/WebService/ForewinWipToErp.asmx"
    END IF

    #
    # CREATE REQUEST
    #
    TRY
        LET request = com.HTTPRequest.Create(ForewinWipToErpService.Address.Uri)
        CALL request.setMethod("POST")
        CALL request.setCharset("UTF-8")
        CALL request.setHeader("SOAPAction","http://tempuri.org/Get_Mes_kt_reason")
        IF ForewinWipToErpService.Binding.Version IS NOT NULL THEN
            CALL request.setVersion(ForewinWipToErpService.Binding.Version)
        END IF
        IF ForewinWipToErpService.Binding.Cookie IS NOT NULL THEN
            CALL request.setHeader("Cookie",ForewinWipToErpService.Binding.Cookie)
        END IF
        IF ForewinWipToErpService.Binding.ConnectionTimeout <> 0 THEN
            CALL request.setConnectionTimeout(ForewinWipToErpService.Binding.ConnectionTimeout)
        END IF
        IF ForewinWipToErpService.Binding.ReadWriteTimeout <> 0 THEN
            CALL request.setTimeout(ForewinWipToErpService.Binding.ReadWriteTimeout)
        END IF
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
        RETURN wsstatus
    END TRY

    # START LOOP
    WHILE retry
        LET retry = FALSE

        #
        # DOM Request
        #

        TRY
            # Building SOAP1.1 envelope
            LET writer = xml.DomDocument.Create()
            LET envelope = WSHelper_BuildSOAP11Envelope(writer)
            CALL writer.appendDocumentNode(envelope)
            LET body = WSHelper_BuildSOAP11Body(writer)
            CALL envelope.appendChild(body)
            #
            # DOM SOAP REQUEST SERIALIZE
            #
            CALL xml.Serializer.VariableToSoapSection5(getMesktReasonRequest,body)

            # Send SOAP envelope
            # 
            # run "echo  '"||body.toString()||"' >> /u1/out/darcy.txt" 
            CALL request.doXmlRequest(writer)
        CATCH
            LET wsstatus = STATUS
            CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
            RETURN wsstatus
        END TRY

        #
        # PROCESS RESPONSE
        #
        TRY
            LET response = request.getResponse()

            #
            # RETRIEVE SERVICE SESSION COOKIE
            #
            LET setcookie = response.getHeader("Set-Cookie")
            IF setcookie IS NOT NULL THEN
                LET ForewinWipToErpService.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,ForewinWipToErpService.Address.Uri)
            END IF

            CASE response.getStatusCode()

                WHEN 500 # SOAP Fault
                #
                # DOM SOAP FAULT
                #
                LET reader = response.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_CheckSOAP11Header(envelope)
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                IF body IS NULL THEN
                    EXIT CASE
                END IF
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    WHILE (node IS NOT NULL)
                        IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                            LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                            IF mustUnderstand = -1 THEN
                            CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                            EXIT CASE
                            END IF
                            IF mustUnderstand THEN
                            CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                            EXIT CASE
                            ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not mandatory
                            END IF
                        ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not intended to us
                        END IF
                    END WHILE
                END IF
                CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

                WHEN 200 # SOAP Result
                    #
                    # DOM SOAP RESPONSE
                    #
                    LET reader = response.getXmlResponse()
                    LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                    IF envelope IS NULL THEN
                        EXIT CASE
                    END IF
                    LET header = WSHelper_RetrieveSOAP11Header(envelope)
                    # Retrieve body
                    LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                    # Handle SOAP headers
                    IF header IS NOT NULL THEN
                        LET node = header.getFirstChildElement()
                        LET nb = 0
                        WHILE (node IS NOT NULL)
                        IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                            LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                            IF mustUnderstand = -1 THEN
                            CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                            EXIT CASE
                            END IF
                            #
                            # DOM SOAP RESPONSE HEADER DESERIALIZE
                            #
                            IF mustUnderstand THEN
                            CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                            EXIT CASE
                            ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not mandatory
                            END IF
                        ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not intended to us
                        END IF
                        END WHILE
                        IF nb != 0 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
                        EXIT CASE
                        END IF
                    END IF
                    IF body IS NOT NULL THEN
                        # Check message
                        LET node = WSHelper_RetrieveSOAP11Message(body)
                        IF node IS NOT NULL THEN
                        #
                        # DOM SOAP RESPONSE DESERIALIZE
                        #
                        CALL Xml.Serializer.SoapSection5ToVariable(node,getMesktReasonResponse)
                        LET wsstatus = 0
                        END IF
                    END IF

                WHEN 401 # HTTP Authentication
                    IF retryAuth THEN
                        CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 401 ("||response.getStatusDescription()||")")
                    ELSE
                        LET retryAuth = TRUE
                        LET retry = TRUE
                    END IF

                    WHEN 407 # Proxy Authentication
                    IF retryProxy THEN
                        CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 407 ("||response.getStatusDescription()||")")
                    ELSE
                        LET retryProxy = TRUE
                        LET retry = TRUE
                    END IF

                OTHERWISE
                    CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||response.getStatusCode()||" ("||response.getStatusDescription()||")")

            END CASE
        CATCH
            LET wsstatus = status
            CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
            RETURN wsstatus
        END TRY

    # END LOOP
    END WHILE

    RETURN wsstatus

end function

function getMesktReasonRequest_g()
    define wsstatus   INTEGER
    define writer     xml.DomDocument
    define envelope   xml.DomNode
    define header     xml.DomNode
    define body       xml.DomNode
    define node       xml.DomNode

    #
    # CHECK PREVIOUS CALL  
    #
    IF GetMesktReasonHTTPReq IS NOT NULL AND GetMesktReasonHTTPResp IS NULL THEN
        # Request was sent but there was no response yet
        CALL WSHelper_FillSOAP11WSError("Client","Cannot issue a new request until previous response was received")
        RETURN -2 # waiting for the response
    ELSE
        IF ForewinWipToErpService.Address.Uri IS NULL THEN
        LET ForewinWipToErpService.Address.Uri = "http://192.168.1.45:8086/NaNaWeb/services/PLMIntegrationEFGP"
        END IF
    END IF

    #
    # CREATE REQUEST
    #
    TRY
        LET GetMesktReasonHTTPReq = com.HTTPRequest.Create(ForewinWipToErpService.Address.Uri)
        CALL GetMesktReasonHTTPReq.setMethod("POST")
        CALL GetMesktReasonHTTPReq.setCharset("UTF-8")
        CALL GetMesktReasonHTTPReq.setHeader("SOAPAction","application/soap+xml;charset=utf-8")
        IF ForewinWipToErpService.Binding.Version IS NOT NULL THEN
            CALL GetMesktReasonHTTPReq.setVersion(ForewinWipToErpService.Binding.Version)
        END IF
        IF ForewinWipToErpService.Binding.Cookie IS NOT NULL THEN
            CALL GetMesktReasonHTTPReq.setHeader("Cookie",ForewinWipToErpService.Binding.Cookie)
        END IF
        IF ForewinWipToErpService.Binding.ConnectionTimeout <> 0 THEN
            CALL GetMesktReasonHTTPReq.setConnectionTimeout(ForewinWipToErpService.Binding.ConnectionTimeout)
        END IF
        IF ForewinWipToErpService.Binding.ReadWriteTimeout <> 0 THEN
            CALL GetMesktReasonHTTPReq.setTimeout(ForewinWipToErpService.Binding.ReadWriteTimeout)
        END IF
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
        LET GetMesktReasonHTTPReq = NULL
        RETURN wsstatus
    END TRY

        #
        # DOM Request
        #

    TRY
        # Building SOAP1.1 envelope
        LET writer = xml.DomDocument.Create()
        LET envelope = WSHelper_BuildSOAP11Envelope(writer)
        CALL writer.appendDocumentNode(envelope)
        LET body = WSHelper_BuildSOAP11Body(writer)
        CALL envelope.appendChild(body)
        #
        # DOM SOAP REQUEST SERIALIZE
        #
        CALL xml.Serializer.VariableToSoapSection5(getMesktReasonRequest,body)

        # Send SOAP envelope
        CALL GetMesktReasonHTTPReq.doXmlRequest(writer)
    CATCH
      LET wsstatus = STATUS
      CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
      LET GetMesktReasonHTTPReq = NULL
      RETURN wsstatus
    END TRY

    #
    # PROCESS RESPONSE
    #
    TRY
        LET GetMesktReasonHTTPResp = GetMesktReasonHTTPReq.getAsyncResponse()
        RETURN 0 # SUCCESS
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
        LET GetMesktReasonHTTPReq = NULL
        RETURN wsstatus
    END TRY
end function

function getMesktReasonResponse_g()
    DEFINE wsstatus        INTEGER
    DEFINE nb              INTEGER
    DEFINE uri             STRING
    DEFINE setcookie       STRING
    DEFINE mustUnderstand  INTEGER
    DEFINE reader          xml.DomDocument
    DEFINE envelope        xml.DomNode
    DEFINE header          xml.DomNode
    DEFINE body            xml.DomNode
    DEFINE node            xml.DomNode

    LET wsstatus = -1

    LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")
    #
    # CHECK PREVIOUS CALL  
    #
    IF GetMesktReasonHTTPReq IS NULL THEN
        # No request was sent
        CALL WSHelper_FillSOAP11WSError("Client","No request has been sent")
        RETURN -1
    END IF

    TRY
        #
        # PROCESS RESPONSE
        #
        IF GetMesktReasonHTTPResp IS NULL THEN
        # Still no response, try again
        LET GetMesktReasonHTTPResp = GetMesktReasonHTTPReq.getAsyncResponse()
        END IF

        IF GetMesktReasonHTTPResp IS NULL THEN
        # We got no response, still waiting for
        CALL WSHelper_FillSOAP11WSError("Client","Response was not yet received")
        RETURN -2
        END IF

        #
        # RETRIEVE SERVICE SESSION COOKIE
        #
        LET setcookie = GetMesktReasonHTTPResp.getHeader("Set-Cookie")
        IF setcookie IS NOT NULL THEN
            LET ForewinWipToErpService.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,ForewinWipToErpService.Address.Uri)
        END IF

        CASE GetMesktReasonHTTPResp.getStatusCode()

            WHEN 500 # SOAP Fault
                #
                # DOM SOAP FAULT
                #
                LET reader = GetMesktReasonHTTPResp.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_CheckSOAP11Header(envelope)
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                IF body IS NULL THEN
                    EXIT CASE
                END IF
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    WHILE (node IS NOT NULL)
                    IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                        LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                        IF mustUnderstand = -1 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                        EXIT CASE
                        END IF
                        IF mustUnderstand THEN
                        CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                        EXIT CASE
                        ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not mandatory
                        END IF
                    ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not intended to us
                    END IF
                    END WHILE
                END IF
                CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

            WHEN 200 # SOAP Result
                #
                # DOM SOAP RESPONSE
                #
                LET reader = GetMesktReasonHTTPResp.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_RetrieveSOAP11Header(envelope)
                # Retrieve body
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    LET nb = 0
                    WHILE (node IS NOT NULL)
                    IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                        LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                        IF mustUnderstand = -1 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                        EXIT CASE
                        END IF
                        #
                        # DOM SOAP RESPONSE HEADER DESERIALIZE
                        #
                        IF mustUnderstand THEN
                        CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                        EXIT CASE
                        ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not mandatory
                        END IF
                    ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not intended to us
                    END IF
                    END WHILE
                    IF nb != 0 THEN
                    CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
                    EXIT CASE
                    END IF
                END IF
                IF body IS NOT NULL THEN
                    # Check message
                    LET node = WSHelper_RetrieveSOAP11Message(body)
                    IF node IS NOT NULL THEN
                    #
                    # DOM SOAP RESPONSE DESERIALIZE
                    #
                    CALL Xml.Serializer.SoapSection5ToVariable(node,getMesktReasonResponse)
                    LET wsstatus = 0
                    END IF
                END IF

            OTHERWISE
                CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||GetMesktReasonHTTPResp.getStatusCode()||" ("||GetMesktReasonHTTPResp.getStatusDescription()||")")

        END CASE
        CATCH
        LET wsstatus = status
        CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
        END TRY

    #
    # RESET VARIABLES
    #
    LET GetMesktReasonHTTPReq = NULL
    LET GetMesktReasonHTTPResp = NULL
    RETURN wsstatus
end function


# 删除mes杂发单领料记录
# p_no 为杂项发料的单号,在过账还原时调用
# returning l_ok true/false  l_res 失败原因
function DelMesUseNoR(p_no)
    define p_no  varchar(40)
    define l_ok  boolean,
           l_res string
      
    define soapStatus   integer
    define response     string
    define kt_no,kt_reason,temp_str  string
    define tok base.StringTokenizer

    call DelMesUseNo(p_no) returning soapStatus,response
    if soapStatus <0 then
        return false,soapStatus
    end if
    
    # {"success":"删除成功"}
    let response = cl_replace_str(response,"{","")
    let response = cl_replace_str(response,"}","")
    let response = cl_replace_str(response,"[","")
    let response = cl_replace_str(response,"]","")
    let response = cl_replace_str(response,'"',"")

    let tok = base.StringTokenizer.create(response,":")
    
    let temp_str = tok.nextToken()
    if temp_str == "success" then
        return true,tok.nextToken()
    else
        return false,tok.nextToken()
    end if
end function

function DelMesUseNo(p_no)
    define p_no  varchar(40)
    define	soapStatus		integer

    let getDelMesUseNoRequest.use_no = p_no

    let soapStatus = DelMesUseNo_g()
    
    return soapStatus,getDelMesUseNoResponse.getDelMesUseNoReturn
end function

function DelMesUseNo_g() 
    define wsstatus   integer
    define retryAuth  integer
    define retryProxy integer
    define retry      integer
    define nb         integer
    define uri        string
    define setcookie  string
    define mustUnderstand integer
    define request    com.HTTPRequest
    define response   com.HTTPResponse
    define writer     xml.DomDocument
    define reader     xml.DomDocument
    define envelope   xml.DomNode
    define header     xml.DomNode
    define body       xml.DomNode
    define node,node1       xml.DomNode

    #
    # INIT VARIABLES
    #
    LET wsstatus = -1
    LET retryAuth = FALSE
    LET retryProxy = FALSE
    LET retry = TRUE
    LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")

    IF ForewinWipToErpService.Address.Uri IS NULL THEN
        LET ForewinWipToErpService.Address.Uri = "http://192.168.1.247:8080/WebService/ForewinWipToErp.asmx"
    END IF

    #
    # CREATE REQUEST
    #
    TRY
        LET request = com.HTTPRequest.Create(ForewinWipToErpService.Address.Uri)
        CALL request.setMethod("POST")
        CALL request.setCharset("UTF-8")
        CALL request.setHeader("SOAPAction","http://tempuri.org/Del_Mes_Use_no")
        IF ForewinWipToErpService.Binding.Version IS NOT NULL THEN
            CALL request.setVersion(ForewinWipToErpService.Binding.Version)
        END IF
        IF ForewinWipToErpService.Binding.Cookie IS NOT NULL THEN
            CALL request.setHeader("Cookie",ForewinWipToErpService.Binding.Cookie)
        END IF
        IF ForewinWipToErpService.Binding.ConnectionTimeout <> 0 THEN
            CALL request.setConnectionTimeout(ForewinWipToErpService.Binding.ConnectionTimeout)
        END IF
        IF ForewinWipToErpService.Binding.ReadWriteTimeout <> 0 THEN
            CALL request.setTimeout(ForewinWipToErpService.Binding.ReadWriteTimeout)
        END IF
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
        RETURN wsstatus
    END TRY

    # START LOOP
    WHILE retry
        LET retry = FALSE

        #
        # DOM Request
        #

        TRY
            # Building SOAP1.1 envelope
            LET writer = xml.DomDocument.Create()
            LET envelope = WSHelper_BuildSOAP11Envelope(writer)
            CALL writer.appendDocumentNode(envelope)
            LET body = WSHelper_BuildSOAP11Body(writer)
            CALL envelope.appendChild(body)
            #
            # DOM SOAP REQUEST SERIALIZE
            #
            CALL xml.Serializer.VariableToSoapSection5(getDelMesUseNoRequest,body)

            # Send SOAP envelope
            # 
            # run "echo  '"||body.toString()||"' >> /u1/out/darcy.txt" 
            CALL request.doXmlRequest(writer)
        CATCH
            LET wsstatus = STATUS
            CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
            RETURN wsstatus
        END TRY

        #
        # PROCESS RESPONSE
        #
        TRY
            LET response = request.getResponse()

            #
            # RETRIEVE SERVICE SESSION COOKIE
            #
            LET setcookie = response.getHeader("Set-Cookie")
            IF setcookie IS NOT NULL THEN
                LET ForewinWipToErpService.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,ForewinWipToErpService.Address.Uri)
            END IF

            CASE response.getStatusCode()

                WHEN 500 # SOAP Fault
                #
                # DOM SOAP FAULT
                #
                LET reader = response.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_CheckSOAP11Header(envelope)
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                IF body IS NULL THEN
                    EXIT CASE
                END IF
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    WHILE (node IS NOT NULL)
                        IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                            LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                            IF mustUnderstand = -1 THEN
                            CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                            EXIT CASE
                            END IF
                            IF mustUnderstand THEN
                            CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                            EXIT CASE
                            ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not mandatory
                            END IF
                        ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not intended to us
                        END IF
                    END WHILE
                END IF
                CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

                WHEN 200 # SOAP Result
                    #
                    # DOM SOAP RESPONSE
                    #
                    LET reader = response.getXmlResponse()
                    LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                    IF envelope IS NULL THEN
                        EXIT CASE
                    END IF
                    LET header = WSHelper_RetrieveSOAP11Header(envelope)
                    # Retrieve body
                    LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                    # Handle SOAP headers
                    IF header IS NOT NULL THEN
                        LET node = header.getFirstChildElement()
                        LET nb = 0
                        WHILE (node IS NOT NULL)
                        IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                            LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                            IF mustUnderstand = -1 THEN
                            CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                            EXIT CASE
                            END IF
                            #
                            # DOM SOAP RESPONSE HEADER DESERIALIZE
                            #
                            IF mustUnderstand THEN
                            CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                            EXIT CASE
                            ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not mandatory
                            END IF
                        ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not intended to us
                        END IF
                        END WHILE
                        IF nb != 0 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
                        EXIT CASE
                        END IF
                    END IF
                    IF body IS NOT NULL THEN
                        # Check message
                        LET node = WSHelper_RetrieveSOAP11Message(body)
                        IF node IS NOT NULL THEN
                        #
                        # DOM SOAP RESPONSE DESERIALIZE
                        #
                        # display node.toString()
                        let node1 = node.getFirstChild()
                        # display "\nnode1: "||node1.toString()
                        let node1 = node1.getFirstChild()
                        # display "\nnode2: "||node1.toString()
                        # CALL Xml.Serializer.SoapSection5ToVariable(node,getDelMesUseNoResponse)
                        let getDelMesUseNoResponse.getDelMesUseNoReturn = node1.toString()
                        LET wsstatus = 0
                        END IF
                    END IF

                WHEN 401 # HTTP Authentication
                    IF retryAuth THEN
                        CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 401 ("||response.getStatusDescription()||")")
                    ELSE
                        LET retryAuth = TRUE
                        LET retry = TRUE
                    END IF

                    WHEN 407 # Proxy Authentication
                    IF retryProxy THEN
                        CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 407 ("||response.getStatusDescription()||")")
                    ELSE
                        LET retryProxy = TRUE
                        LET retry = TRUE
                    END IF

                OTHERWISE
                    CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||response.getStatusCode()||" ("||response.getStatusDescription()||")")

            END CASE
        CATCH
            LET wsstatus = status
            CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
            RETURN wsstatus
        END TRY

    # END LOOP
    END WHILE

    RETURN wsstatus
end function

function DelMesUseNoRequest_g() 
    define wsstatus   INTEGER
    define writer     xml.DomDocument
    define envelope   xml.DomNode
    define header     xml.DomNode
    define body       xml.DomNode
    define node       xml.DomNode

    #
    # CHECK PREVIOUS CALL  
    #
    IF DelMesUseNoHTTPReq IS NOT NULL AND DelMesUseNoHTTPResp IS NULL THEN
        # Request was sent but there was no response yet
        CALL WSHelper_FillSOAP11WSError("Client","Cannot issue a new request until previous response was received")
        RETURN -2 # waiting for the response
    ELSE
        IF ForewinWipToErpService.Address.Uri IS NULL THEN
        LET ForewinWipToErpService.Address.Uri = "http://192.168.1.45:8086/NaNaWeb/services/PLMIntegrationEFGP"
        END IF
    END IF

    #
    # CREATE REQUEST
    #
    TRY
        LET DelMesUseNoHTTPReq = com.HTTPRequest.Create(ForewinWipToErpService.Address.Uri)
        CALL DelMesUseNoHTTPReq.setMethod("POST")
        CALL DelMesUseNoHTTPReq.setCharset("UTF-8")
        CALL DelMesUseNoHTTPReq.setHeader("SOAPAction","application/soap+xml;charset=utf-8")
        IF ForewinWipToErpService.Binding.Version IS NOT NULL THEN
            CALL DelMesUseNoHTTPReq.setVersion(ForewinWipToErpService.Binding.Version)
        END IF
        IF ForewinWipToErpService.Binding.Cookie IS NOT NULL THEN
            CALL DelMesUseNoHTTPReq.setHeader("Cookie",ForewinWipToErpService.Binding.Cookie)
        END IF
        IF ForewinWipToErpService.Binding.ConnectionTimeout <> 0 THEN
            CALL DelMesUseNoHTTPReq.setConnectionTimeout(ForewinWipToErpService.Binding.ConnectionTimeout)
        END IF
        IF ForewinWipToErpService.Binding.ReadWriteTimeout <> 0 THEN
            CALL DelMesUseNoHTTPReq.setTimeout(ForewinWipToErpService.Binding.ReadWriteTimeout)
        END IF
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
        LET DelMesUseNoHTTPReq = NULL
        RETURN wsstatus
    END TRY

        #
        # DOM Request
        #

    TRY
        # Building SOAP1.1 envelope
        LET writer = xml.DomDocument.Create()
        LET envelope = WSHelper_BuildSOAP11Envelope(writer)
        CALL writer.appendDocumentNode(envelope)
        LET body = WSHelper_BuildSOAP11Body(writer)
        CALL envelope.appendChild(body)
        #
        # DOM SOAP REQUEST SERIALIZE
        #
        CALL xml.Serializer.VariableToSoapSection5(getDelMesUseNoRequest,body)

        # Send SOAP envelope
        CALL DelMesUseNoHTTPReq.doXmlRequest(writer)
    CATCH
      LET wsstatus = STATUS
      CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
      LET DelMesUseNoHTTPReq = NULL
      RETURN wsstatus
    END TRY

    #
    # PROCESS RESPONSE
    #
    TRY
        LET DelMesUseNoHTTPResp = DelMesUseNoHTTPReq.getAsyncResponse()
        RETURN 0 # SUCCESS
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
        LET DelMesUseNoHTTPReq = NULL
        RETURN wsstatus
    END TRY
end function

function DelMesUseNoResponse_g() 
    DEFINE wsstatus        INTEGER
    DEFINE nb              INTEGER
    DEFINE uri             STRING
    DEFINE setcookie       STRING
    DEFINE mustUnderstand  INTEGER
    DEFINE reader          xml.DomDocument
    DEFINE envelope        xml.DomNode
    DEFINE header          xml.DomNode
    DEFINE body            xml.DomNode
    DEFINE node            xml.DomNode

    LET wsstatus = -1

    LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")
    #
    # CHECK PREVIOUS CALL  
    #
    IF DelMesUseNoHTTPReq IS NULL THEN
        # No request was sent
        CALL WSHelper_FillSOAP11WSError("Client","No request has been sent")
        RETURN -1
    END IF

    TRY
        #
        # PROCESS RESPONSE
        #
        IF DelMesUseNoHTTPResp IS NULL THEN
        # Still no response, try again
        LET DelMesUseNoHTTPResp = DelMesUseNoHTTPReq.getAsyncResponse()
        END IF

        IF DelMesUseNoHTTPResp IS NULL THEN
        # We got no response, still waiting for
        CALL WSHelper_FillSOAP11WSError("Client","Response was not yet received")
        RETURN -2
        END IF

        #
        # RETRIEVE SERVICE SESSION COOKIE
        #
        LET setcookie = DelMesUseNoHTTPResp.getHeader("Set-Cookie")
        IF setcookie IS NOT NULL THEN
            LET ForewinWipToErpService.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,ForewinWipToErpService.Address.Uri)
        END IF

        CASE DelMesUseNoHTTPResp.getStatusCode()

            WHEN 500 # SOAP Fault
                #
                # DOM SOAP FAULT
                #
                LET reader = DelMesUseNoHTTPResp.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_CheckSOAP11Header(envelope)
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                IF body IS NULL THEN
                    EXIT CASE
                END IF
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    WHILE (node IS NOT NULL)
                    IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                        LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                        IF mustUnderstand = -1 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                        EXIT CASE
                        END IF
                        IF mustUnderstand THEN
                        CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                        EXIT CASE
                        ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not mandatory
                        END IF
                    ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not intended to us
                    END IF
                    END WHILE
                END IF
                CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

            WHEN 200 # SOAP Result
                #
                # DOM SOAP RESPONSE
                #
                LET reader = DelMesUseNoHTTPResp.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_RetrieveSOAP11Header(envelope)
                # Retrieve body
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    LET nb = 0
                    WHILE (node IS NOT NULL)
                    IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                        LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                        IF mustUnderstand = -1 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                        EXIT CASE
                        END IF
                        #
                        # DOM SOAP RESPONSE HEADER DESERIALIZE
                        #
                        IF mustUnderstand THEN
                        CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                        EXIT CASE
                        ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not mandatory
                        END IF
                    ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not intended to us
                    END IF
                    END WHILE
                    IF nb != 0 THEN
                    CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
                    EXIT CASE
                    END IF
                END IF
                IF body IS NOT NULL THEN
                    # Check message
                    LET node = WSHelper_RetrieveSOAP11Message(body)
                    IF node IS NOT NULL THEN
                    #
                    # DOM SOAP RESPONSE DESERIALIZE
                    #
                    CALL Xml.Serializer.SoapSection5ToVariable(node,getDelMesUseNoResponse)
                    LET wsstatus = 0
                    END IF
                END IF

            OTHERWISE
                CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||DelMesUseNoHTTPResp.getStatusCode()||" ("||DelMesUseNoHTTPResp.getStatusDescription()||")")

        END CASE
        CATCH
        LET wsstatus = status
        CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
        END TRY

    #
    # RESET VARIABLES
    #
    LET DelMesUseNoHTTPReq = NULL
    LET DelMesUseNoHTTPResp = NULL
    RETURN wsstatus
end function
#-------------------------------------------------------------------------------
# GetWaitScrapR
# 入口函数 
{
    define p_wo_nos    varchar(200)

}
function GetWaitScrapR(p_wo_nos)
    define p_wo_nos    string
      
    define soapStatus   integer
    define response     string

    define l_cnt,l_i integer
    define l_ret dynamic array of record
        sfb01   like sfb_file.sfb01,
        sfb12   like sfb_file.sfb12
    end record

    call GetWaitScrap(p_wo_nos) returning soapStatus,response
    if soapStatus < 0 then
        return false,l_ret 
    end if

    let l_cnt = gLength(response,"success.#")
     
    call l_ret.clear()
    for l_i = 1 to l_cnt 
        let l_ret[l_i].sfb01 = gString(response,sfmt("success.%1.wo_no",l_i))
        let l_ret[l_i].sfb12 = gFloat(response,sfmt("success.%1.wait_scrap",l_i))
    end for
    return true,l_ret

end function

# GetWaitScrap
function GetWaitScrap(p_wo_nos)
    define p_wo_nos    string

    define	soapStatus		integer
    let getGetWaitScrapRequest.wo_nos = p_wo_nos
    let soapStatus = GetWaitScrap_g()
    
    return soapStatus,getGetWaitScrapResponse.getGetWaitScrapReturn
end function
# GetWaitScrap_g
function GetWaitScrap_g() 
    define wsstatus   integer
    define retryAuth  integer
    define retryProxy integer
    define retry      integer
    define nb         integer
    define uri        string
    define setcookie  string
    define mustUnderstand integer
    define request    com.HTTPRequest
    define response   com.HTTPResponse
    define writer     xml.DomDocument
    define reader     xml.DomDocument
    define envelope   xml.DomNode
    define header     xml.DomNode
    define body       xml.DomNode
    define node,node1       xml.DomNode

    #
    # INIT VARIABLES
    #
    LET wsstatus = -1
    LET retryAuth = FALSE
    LET retryProxy = FALSE
    LET retry = TRUE
    LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")

    IF ForewinWipToErpService.Address.Uri IS NULL THEN
        LET ForewinWipToErpService.Address.Uri = "http://192.168.1.247:8080/WebService/ForewinWipToErp.asmx"
    END IF

    #
    # CREATE REQUEST
    #
    TRY
        LET request = com.HTTPRequest.Create(ForewinWipToErpService.Address.Uri)
        CALL request.setMethod("POST")
        CALL request.setCharset("UTF-8")
        CALL request.setHeader("SOAPAction","http://tempuri.org/Get_Wait_scrap")
        IF ForewinWipToErpService.Binding.Version IS NOT NULL THEN
            CALL request.setVersion(ForewinWipToErpService.Binding.Version)
        END IF
        IF ForewinWipToErpService.Binding.Cookie IS NOT NULL THEN
            CALL request.setHeader("Cookie",ForewinWipToErpService.Binding.Cookie)
        END IF
        IF ForewinWipToErpService.Binding.ConnectionTimeout <> 0 THEN
            CALL request.setConnectionTimeout(ForewinWipToErpService.Binding.ConnectionTimeout)
        END IF
        IF ForewinWipToErpService.Binding.ReadWriteTimeout <> 0 THEN
            CALL request.setTimeout(ForewinWipToErpService.Binding.ReadWriteTimeout)
        END IF
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
        RETURN wsstatus
    END TRY

    # START LOOP
    WHILE retry
        LET retry = FALSE

        #
        # DOM Request
        #

        TRY
            # Building SOAP1.1 envelope
            LET writer = xml.DomDocument.Create()
            LET envelope = WSHelper_BuildSOAP11Envelope(writer)
            CALL writer.appendDocumentNode(envelope)
            LET body = WSHelper_BuildSOAP11Body(writer)
            CALL envelope.appendChild(body)
            #
            # DOM SOAP REQUEST SERIALIZE
            #
            CALL xml.Serializer.VariableToSoapSection5(getGetWaitScrapRequest,body)

            # Send SOAP envelope
            # 
            # run "echo  '"||body.toString()||"' >> /u1/out/darcy.txt" 
            CALL request.doXmlRequest(writer)
        CATCH
            LET wsstatus = STATUS
            CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
            RETURN wsstatus
        END TRY

        #
        # PROCESS RESPONSE
        #
        TRY
            LET response = request.getResponse()

            #
            # RETRIEVE SERVICE SESSION COOKIE
            #
            LET setcookie = response.getHeader("Set-Cookie")
            IF setcookie IS NOT NULL THEN
                LET ForewinWipToErpService.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,ForewinWipToErpService.Address.Uri)
            END IF

            CASE response.getStatusCode()

                WHEN 500 # SOAP Fault
                #
                # DOM SOAP FAULT
                #
                LET reader = response.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_CheckSOAP11Header(envelope)
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                IF body IS NULL THEN
                    EXIT CASE
                END IF
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    WHILE (node IS NOT NULL)
                        IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                            LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                            IF mustUnderstand = -1 THEN
                            CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                            EXIT CASE
                            END IF
                            IF mustUnderstand THEN
                            CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                            EXIT CASE
                            ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not mandatory
                            END IF
                        ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not intended to us
                        END IF
                    END WHILE
                END IF
                CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

                WHEN 200 # SOAP Result
                    #
                    # DOM SOAP RESPONSE
                    #
                    LET reader = response.getXmlResponse()
                    LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                    IF envelope IS NULL THEN
                        EXIT CASE
                    END IF
                    LET header = WSHelper_RetrieveSOAP11Header(envelope)
                    # Retrieve body
                    LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                    # Handle SOAP headers
                    IF header IS NOT NULL THEN
                        LET node = header.getFirstChildElement()
                        LET nb = 0
                        WHILE (node IS NOT NULL)
                        IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                            LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                            IF mustUnderstand = -1 THEN
                            CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                            EXIT CASE
                            END IF
                            #
                            # DOM SOAP RESPONSE HEADER DESERIALIZE
                            #
                            IF mustUnderstand THEN
                            CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                            EXIT CASE
                            ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not mandatory
                            END IF
                        ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not intended to us
                        END IF
                        END WHILE
                        IF nb != 0 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
                        EXIT CASE
                        END IF
                    END IF
                    IF body IS NOT NULL THEN
                        # Check message
                        LET node = WSHelper_RetrieveSOAP11Message(body)
                        IF node IS NOT NULL THEN
                        #
                        # DOM SOAP RESPONSE DESERIALIZE
                        #
                        # display node.toString()
                        let node1 = node.getFirstChild()
                        # display "\nnode1: "||node1.toString()
                        let node1 = node1.getFirstChild()
                        # display "\nnode2: "||node1.toString()
                        # CALL Xml.Serializer.SoapSection5ToVariable(node,getGetWaitScrapResponse)
                        let getGetWaitScrapResponse.getGetWaitScrapReturn = node1.toString()
                        LET wsstatus = 0
                        END IF
                    END IF

                WHEN 401 # HTTP Authentication
                    IF retryAuth THEN
                        CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 401 ("||response.getStatusDescription()||")")
                    ELSE
                        LET retryAuth = TRUE
                        LET retry = TRUE
                    END IF

                    WHEN 407 # Proxy Authentication
                    IF retryProxy THEN
                        CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 407 ("||response.getStatusDescription()||")")
                    ELSE
                        LET retryProxy = TRUE
                        LET retry = TRUE
                    END IF

                OTHERWISE
                    CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||response.getStatusCode()||" ("||response.getStatusDescription()||")")

            END CASE
        CATCH
            LET wsstatus = status
            CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
            RETURN wsstatus
        END TRY

    # END LOOP
    END WHILE

    RETURN wsstatus
end function
# GetWaitScrapRequest_g
function GetWaitScrapRequest_g() 
    define wsstatus   INTEGER
    define writer     xml.DomDocument
    define envelope   xml.DomNode
    define header     xml.DomNode
    define body       xml.DomNode
    define node       xml.DomNode

    #
    # CHECK PREVIOUS CALL  
    #
    IF GetWaitScrapHTTPReq IS NOT NULL AND GetWaitScrapHTTPResp IS NULL THEN
        # Request was sent but there was no response yet
        CALL WSHelper_FillSOAP11WSError("Client","Cannot issue a new request until previous response was received")
        RETURN -2 # waiting for the response
    ELSE
        IF ForewinWipToErpService.Address.Uri IS NULL THEN
        LET ForewinWipToErpService.Address.Uri = "http://192.168.1.45:8086/NaNaWeb/services/PLMIntegrationEFGP"
        END IF
    END IF

    #
    # CREATE REQUEST
    #
    TRY
        LET GetWaitScrapHTTPReq = com.HTTPRequest.Create(ForewinWipToErpService.Address.Uri)
        CALL GetWaitScrapHTTPReq.setMethod("POST")
        CALL GetWaitScrapHTTPReq.setCharset("UTF-8")
        CALL GetWaitScrapHTTPReq.setHeader("SOAPAction","application/soap+xml;charset=utf-8")
        IF ForewinWipToErpService.Binding.Version IS NOT NULL THEN
            CALL GetWaitScrapHTTPReq.setVersion(ForewinWipToErpService.Binding.Version)
        END IF
        IF ForewinWipToErpService.Binding.Cookie IS NOT NULL THEN
            CALL GetWaitScrapHTTPReq.setHeader("Cookie",ForewinWipToErpService.Binding.Cookie)
        END IF
        IF ForewinWipToErpService.Binding.ConnectionTimeout <> 0 THEN
            CALL GetWaitScrapHTTPReq.setConnectionTimeout(ForewinWipToErpService.Binding.ConnectionTimeout)
        END IF
        IF ForewinWipToErpService.Binding.ReadWriteTimeout <> 0 THEN
            CALL GetWaitScrapHTTPReq.setTimeout(ForewinWipToErpService.Binding.ReadWriteTimeout)
        END IF
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
        LET GetWaitScrapHTTPReq = NULL
        RETURN wsstatus
    END TRY

        #
        # DOM Request
        #

    TRY
        # Building SOAP1.1 envelope
        LET writer = xml.DomDocument.Create()
        LET envelope = WSHelper_BuildSOAP11Envelope(writer)
        CALL writer.appendDocumentNode(envelope)
        LET body = WSHelper_BuildSOAP11Body(writer)
        CALL envelope.appendChild(body)
        #
        # DOM SOAP REQUEST SERIALIZE
        #
        CALL xml.Serializer.VariableToSoapSection5(getGetWaitScrapRequest,body)

        # Send SOAP envelope
        CALL GetWaitScrapHTTPReq.doXmlRequest(writer)
    CATCH
      LET wsstatus = STATUS
      CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
      LET GetWaitScrapHTTPReq = NULL
      RETURN wsstatus
    END TRY

    #
    # PROCESS RESPONSE
    #
    TRY
        LET GetWaitScrapHTTPResp = GetWaitScrapHTTPReq.getAsyncResponse()
        RETURN 0 # SUCCESS
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
        LET GetWaitScrapHTTPReq = NULL
        RETURN wsstatus
    END TRY
end function
# GetWaitScrapResponse_g
function GetWaitScrapResponse_g() 
    DEFINE wsstatus        INTEGER
    DEFINE nb              INTEGER
    DEFINE uri             STRING
    DEFINE setcookie       STRING
    DEFINE mustUnderstand  INTEGER
    DEFINE reader          xml.DomDocument
    DEFINE envelope        xml.DomNode
    DEFINE header          xml.DomNode
    DEFINE body            xml.DomNode
    DEFINE node            xml.DomNode

    LET wsstatus = -1

    LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")
    #
    # CHECK PREVIOUS CALL  
    #
    IF GetWaitScrapHTTPReq IS NULL THEN
        # No request was sent
        CALL WSHelper_FillSOAP11WSError("Client","No request has been sent")
        RETURN -1
    END IF

    TRY
        #
        # PROCESS RESPONSE
        #
        IF GetWaitScrapHTTPResp IS NULL THEN
        # Still no response, try again
        LET GetWaitScrapHTTPResp = GetWaitScrapHTTPReq.getAsyncResponse()
        END IF

        IF GetWaitScrapHTTPResp IS NULL THEN
        # We got no response, still waiting for
        CALL WSHelper_FillSOAP11WSError("Client","Response was not yet received")
        RETURN -2
        END IF

        #
        # RETRIEVE SERVICE SESSION COOKIE
        #
        LET setcookie = GetWaitScrapHTTPResp.getHeader("Set-Cookie")
        IF setcookie IS NOT NULL THEN
            LET ForewinWipToErpService.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,ForewinWipToErpService.Address.Uri)
        END IF

        CASE GetWaitScrapHTTPResp.getStatusCode()

            WHEN 500 # SOAP Fault
                #
                # DOM SOAP FAULT
                #
                LET reader = GetWaitScrapHTTPResp.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_CheckSOAP11Header(envelope)
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                IF body IS NULL THEN
                    EXIT CASE
                END IF
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    WHILE (node IS NOT NULL)
                    IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                        LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                        IF mustUnderstand = -1 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                        EXIT CASE
                        END IF
                        IF mustUnderstand THEN
                        CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                        EXIT CASE
                        ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not mandatory
                        END IF
                    ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not intended to us
                    END IF
                    END WHILE
                END IF
                CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

            WHEN 200 # SOAP Result
                #
                # DOM SOAP RESPONSE
                #
                LET reader = GetWaitScrapHTTPResp.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_RetrieveSOAP11Header(envelope)
                # Retrieve body
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    LET nb = 0
                    WHILE (node IS NOT NULL)
                    IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                        LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                        IF mustUnderstand = -1 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                        EXIT CASE
                        END IF
                        #
                        # DOM SOAP RESPONSE HEADER DESERIALIZE
                        #
                        IF mustUnderstand THEN
                        CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                        EXIT CASE
                        ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not mandatory
                        END IF
                    ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not intended to us
                    END IF
                    END WHILE
                    IF nb != 0 THEN
                    CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
                    EXIT CASE
                    END IF
                END IF
                IF body IS NOT NULL THEN
                    # Check message
                    LET node = WSHelper_RetrieveSOAP11Message(body)
                    IF node IS NOT NULL THEN
                    #
                    # DOM SOAP RESPONSE DESERIALIZE
                    #
                    CALL Xml.Serializer.SoapSection5ToVariable(node,getGetWaitScrapResponse)
                    LET wsstatus = 0
                    END IF
                END IF

            OTHERWISE
                CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||GetWaitScrapHTTPResp.getStatusCode()||" ("||GetWaitScrapHTTPResp.getStatusDescription()||")")

        END CASE
        CATCH
        LET wsstatus = status
        CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
        END TRY

    #
    # RESET VARIABLES
    #
    LET GetWaitScrapHTTPReq = NULL
    LET GetWaitScrapHTTPResp = NULL
    RETURN wsstatus
end function

#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# DelMESLotNoR
# 入口函数 
{
    define p_wo_nos    varchar(200)

}
function DelMESLotNoR(p_wo_nos)
    define p_wo_nos    string
      
    define soapStatus   integer
    define response     string

    define l_cnt,l_i integer
    define l_ret dynamic array of record
        sfb01   like sfb_file.sfb01,
        sfb12   like sfb_file.sfb12
    end record

    call DelMESLotNo(p_wo_nos) returning soapStatus,response
    if soapStatus < 0 then
        return false,'' 
    end if

    return soapStatus,response

end function

# DelMESLotNo
function DelMESLotNo(p_wo_nos)
    define p_wo_nos    string

    define	soapStatus		integer
    let getDelMESLotNoRequest.wo_nos = p_wo_nos
    let soapStatus = DelMESLotNo_g()
    
    return soapStatus,getDelMESLotNoResponse.getDelMESLotNoReturn
end function
# DelMESLotNo_g
function DelMESLotNo_g() 
    define wsstatus   integer
    define retryAuth  integer
    define retryProxy integer
    define retry      integer
    define nb         integer
    define uri        string
    define setcookie  string
    define mustUnderstand integer
    define request    com.HTTPRequest
    define response   com.HTTPResponse
    define writer     xml.DomDocument
    define reader     xml.DomDocument
    define envelope   xml.DomNode
    define header     xml.DomNode
    define body       xml.DomNode
    define node,node1       xml.DomNode

    #
    # INIT VARIABLES
    #
    LET wsstatus = -1
    LET retryAuth = FALSE
    LET retryProxy = FALSE
    LET retry = TRUE
    LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")

    IF ForewinWipToErpService.Address.Uri IS NULL THEN
        LET ForewinWipToErpService.Address.Uri = "http://192.168.1.247:8080/WebService/ForewinWipToErp.asmx"
    END IF

    #
    # CREATE REQUEST
    #
    TRY
        LET request = com.HTTPRequest.Create(ForewinWipToErpService.Address.Uri)
        CALL request.setMethod("POST")
        CALL request.setCharset("UTF-8")
        CALL request.setHeader("SOAPAction","http://tempuri.org/Del_mes_lot_no")
        IF ForewinWipToErpService.Binding.Version IS NOT NULL THEN
            CALL request.setVersion(ForewinWipToErpService.Binding.Version)
        END IF
        IF ForewinWipToErpService.Binding.Cookie IS NOT NULL THEN
            CALL request.setHeader("Cookie",ForewinWipToErpService.Binding.Cookie)
        END IF
        IF ForewinWipToErpService.Binding.ConnectionTimeout <> 0 THEN
            CALL request.setConnectionTimeout(ForewinWipToErpService.Binding.ConnectionTimeout)
        END IF
        IF ForewinWipToErpService.Binding.ReadWriteTimeout <> 0 THEN
            CALL request.setTimeout(ForewinWipToErpService.Binding.ReadWriteTimeout)
        END IF
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
        RETURN wsstatus
    END TRY

    # START LOOP
    WHILE retry
        LET retry = FALSE

        #
        # DOM Request
        #

        TRY
            # Building SOAP1.1 envelope
            LET writer = xml.DomDocument.Create()
            LET envelope = WSHelper_BuildSOAP11Envelope(writer)
            CALL writer.appendDocumentNode(envelope)
            LET body = WSHelper_BuildSOAP11Body(writer)
            CALL envelope.appendChild(body)
            #
            # DOM SOAP REQUEST SERIALIZE
            #
            CALL xml.Serializer.VariableToSoapSection5(getDelMESLotNoRequest,body)

            # Send SOAP envelope
            # 
            # run "echo  '"||body.toString()||"' >> /u1/out/darcy.txt" 
            CALL request.doXmlRequest(writer)
            -- run "echo  '"||writer.saveToString()||"' >> /u1/out/darcy.txt" 
        CATCH
            LET wsstatus = STATUS
            CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
            RETURN wsstatus
        END TRY

        #
        # PROCESS RESPONSE
        #
        TRY
            LET response = request.getResponse()

            #
            # RETRIEVE SERVICE SESSION COOKIE
            #
            LET setcookie = response.getHeader("Set-Cookie")
            IF setcookie IS NOT NULL THEN
                LET ForewinWipToErpService.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,ForewinWipToErpService.Address.Uri)
            END IF

            CASE response.getStatusCode()

                WHEN 500 # SOAP Fault
                #
                # DOM SOAP FAULT
                #
                LET reader = response.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_CheckSOAP11Header(envelope)
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                IF body IS NULL THEN
                    EXIT CASE
                END IF
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    WHILE (node IS NOT NULL)
                        IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                            LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                            IF mustUnderstand = -1 THEN
                            CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                            EXIT CASE
                            END IF
                            IF mustUnderstand THEN
                            CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                            EXIT CASE
                            ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not mandatory
                            END IF
                        ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not intended to us
                        END IF
                    END WHILE
                END IF
                CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

                WHEN 200 # SOAP Result
                    #
                    # DOM SOAP RESPONSE
                    #
                    LET reader = response.getXmlResponse()
                    LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                    IF envelope IS NULL THEN
                        EXIT CASE
                    END IF
                    LET header = WSHelper_RetrieveSOAP11Header(envelope)
                    # Retrieve body
                    LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                    # Handle SOAP headers
                    IF header IS NOT NULL THEN
                        LET node = header.getFirstChildElement()
                        LET nb = 0
                        WHILE (node IS NOT NULL)
                        IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                            LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                            IF mustUnderstand = -1 THEN
                            CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                            EXIT CASE
                            END IF
                            #
                            # DOM SOAP RESPONSE HEADER DESERIALIZE
                            #
                            IF mustUnderstand THEN
                            CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                            EXIT CASE
                            ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not mandatory
                            END IF
                        ELSE
                            LET node = node.getNextSiblingElement() # Skip header, not intended to us
                        END IF
                        END WHILE
                        IF nb != 0 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
                        EXIT CASE
                        END IF
                    END IF
                    IF body IS NOT NULL THEN
                        # Check message
                        LET node = WSHelper_RetrieveSOAP11Message(body)
                        IF node IS NOT NULL THEN
                        #
                        # DOM SOAP RESPONSE DESERIALIZE
                        #
                        # display node.toString()
                        let node1 = node.getFirstChild()
                        # display "\nnode1: "||node1.toString()
                        let node1 = node1.getFirstChild()
                        # display "\nnode2: "||node1.toString()
                        # CALL Xml.Serializer.SoapSection5ToVariable(node,getDelMESLotNoResponse)
                        let getDelMESLotNoResponse.getDelMESLotNoReturn = node1.toString()
                        LET wsstatus = 0
                        END IF
                    END IF

                WHEN 401 # HTTP Authentication
                    IF retryAuth THEN
                        CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 401 ("||response.getStatusDescription()||")")
                    ELSE
                        LET retryAuth = TRUE
                        LET retry = TRUE
                    END IF

                    WHEN 407 # Proxy Authentication
                    IF retryProxy THEN
                        CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 407 ("||response.getStatusDescription()||")")
                    ELSE
                        LET retryProxy = TRUE
                        LET retry = TRUE
                    END IF

                OTHERWISE
                    CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||response.getStatusCode()||" ("||response.getStatusDescription()||")")

            END CASE
        CATCH
            LET wsstatus = status
            CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
            RETURN wsstatus
        END TRY

    # END LOOP
    END WHILE

    RETURN wsstatus
end function
# DelMESLotNoRequest_g
function DelMESLotNoRequest_g() 
    define wsstatus   INTEGER
    define writer     xml.DomDocument
    define envelope   xml.DomNode
    define header     xml.DomNode
    define body       xml.DomNode
    define node       xml.DomNode

    #
    # CHECK PREVIOUS CALL  
    #
    IF DelMESLotNoHTTPReq IS NOT NULL AND DelMESLotNoHTTPResp IS NULL THEN
        # Request was sent but there was no response yet
        CALL WSHelper_FillSOAP11WSError("Client","Cannot issue a new request until previous response was received")
        RETURN -2 # waiting for the response
    ELSE
        IF ForewinWipToErpService.Address.Uri IS NULL THEN
        LET ForewinWipToErpService.Address.Uri = "http://192.168.1.45:8086/NaNaWeb/services/PLMIntegrationEFGP"
        END IF
    END IF

    #
    # CREATE REQUEST
    #
    TRY
        LET DelMESLotNoHTTPReq = com.HTTPRequest.Create(ForewinWipToErpService.Address.Uri)
        CALL DelMESLotNoHTTPReq.setMethod("POST")
        CALL DelMESLotNoHTTPReq.setCharset("UTF-8")
        CALL DelMESLotNoHTTPReq.setHeader("SOAPAction","application/soap+xml;charset=utf-8")
        IF ForewinWipToErpService.Binding.Version IS NOT NULL THEN
            CALL DelMESLotNoHTTPReq.setVersion(ForewinWipToErpService.Binding.Version)
        END IF
        IF ForewinWipToErpService.Binding.Cookie IS NOT NULL THEN
            CALL DelMESLotNoHTTPReq.setHeader("Cookie",ForewinWipToErpService.Binding.Cookie)
        END IF
        IF ForewinWipToErpService.Binding.ConnectionTimeout <> 0 THEN
            CALL DelMESLotNoHTTPReq.setConnectionTimeout(ForewinWipToErpService.Binding.ConnectionTimeout)
        END IF
        IF ForewinWipToErpService.Binding.ReadWriteTimeout <> 0 THEN
            CALL DelMESLotNoHTTPReq.setTimeout(ForewinWipToErpService.Binding.ReadWriteTimeout)
        END IF
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
        LET DelMESLotNoHTTPReq = NULL
        RETURN wsstatus
    END TRY

        #
        # DOM Request
        #

    TRY
        # Building SOAP1.1 envelope
        LET writer = xml.DomDocument.Create()
        LET envelope = WSHelper_BuildSOAP11Envelope(writer)
        CALL writer.appendDocumentNode(envelope)
        LET body = WSHelper_BuildSOAP11Body(writer)
        CALL envelope.appendChild(body)
        #
        # DOM SOAP REQUEST SERIALIZE
        #
        CALL xml.Serializer.VariableToSoapSection5(getDelMESLotNoRequest,body)

        # Send SOAP envelope
        CALL DelMESLotNoHTTPReq.doXmlRequest(writer)
        display writer.saveToString()
    CATCH
      LET wsstatus = STATUS
      CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
      LET DelMESLotNoHTTPReq = NULL
      RETURN wsstatus
    END TRY

    #
    # PROCESS RESPONSE
    #
    TRY
        LET DelMESLotNoHTTPResp = DelMESLotNoHTTPReq.getAsyncResponse()
        RETURN 0 # SUCCESS
    CATCH
        LET wsstatus = STATUS
        CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
        LET DelMESLotNoHTTPReq = NULL
        RETURN wsstatus
    END TRY
end function
# DelMESLotNoResponse_g
function DelMESLotNoResponse_g() 
    DEFINE wsstatus        INTEGER
    DEFINE nb              INTEGER
    DEFINE uri             STRING
    DEFINE setcookie       STRING
    DEFINE mustUnderstand  INTEGER
    DEFINE reader          xml.DomDocument
    DEFINE envelope        xml.DomNode
    DEFINE header          xml.DomNode
    DEFINE body            xml.DomNode
    DEFINE node            xml.DomNode

    LET wsstatus = -1

    LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")
    #
    # CHECK PREVIOUS CALL  
    #
    IF DelMESLotNoHTTPReq IS NULL THEN
        # No request was sent
        CALL WSHelper_FillSOAP11WSError("Client","No request has been sent")
        RETURN -1
    END IF

    TRY
        #
        # PROCESS RESPONSE
        #
        IF DelMESLotNoHTTPResp IS NULL THEN
        # Still no response, try again
        LET DelMESLotNoHTTPResp = DelMESLotNoHTTPReq.getAsyncResponse()
        END IF

        IF DelMESLotNoHTTPResp IS NULL THEN
        # We got no response, still waiting for
        CALL WSHelper_FillSOAP11WSError("Client","Response was not yet received")
        RETURN -2
        END IF

        #
        # RETRIEVE SERVICE SESSION COOKIE
        #
        LET setcookie = DelMESLotNoHTTPResp.getHeader("Set-Cookie")
        IF setcookie IS NOT NULL THEN
            LET ForewinWipToErpService.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,ForewinWipToErpService.Address.Uri)
        END IF

        CASE DelMESLotNoHTTPResp.getStatusCode()

            WHEN 500 # SOAP Fault
                #
                # DOM SOAP FAULT
                #
                LET reader = DelMESLotNoHTTPResp.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_CheckSOAP11Header(envelope)
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                IF body IS NULL THEN
                    EXIT CASE
                END IF
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    WHILE (node IS NOT NULL)
                    IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                        LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                        IF mustUnderstand = -1 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                        EXIT CASE
                        END IF
                        IF mustUnderstand THEN
                        CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                        EXIT CASE
                        ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not mandatory
                        END IF
                    ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not intended to us
                    END IF
                    END WHILE
                END IF
                CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

            WHEN 200 # SOAP Result
                #
                # DOM SOAP RESPONSE
                #
                LET reader = DelMESLotNoHTTPResp.getXmlResponse()
                LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
                IF envelope IS NULL THEN
                    EXIT CASE
                END IF
                LET header = WSHelper_RetrieveSOAP11Header(envelope)
                # Retrieve body
                LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
                # Handle SOAP headers
                IF header IS NOT NULL THEN
                    LET node = header.getFirstChildElement()
                    LET nb = 0
                    WHILE (node IS NOT NULL)
                    IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                        LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                        IF mustUnderstand = -1 THEN
                        CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                        EXIT CASE
                        END IF
                        #
                        # DOM SOAP RESPONSE HEADER DESERIALIZE
                        #
                        IF mustUnderstand THEN
                        CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                        EXIT CASE
                        ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not mandatory
                        END IF
                    ELSE
                        LET node = node.getNextSiblingElement() # Skip header, not intended to us
                    END IF
                    END WHILE
                    IF nb != 0 THEN
                    CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
                    EXIT CASE
                    END IF
                END IF
                IF body IS NOT NULL THEN
                    # Check message
                    LET node = WSHelper_RetrieveSOAP11Message(body)
                    IF node IS NOT NULL THEN
                    #
                    # DOM SOAP RESPONSE DESERIALIZE
                    #
                    CALL Xml.Serializer.SoapSection5ToVariable(node,getDelMESLotNoResponse)
                    LET wsstatus = 0
                    END IF
                END IF

            OTHERWISE
                CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||DelMESLotNoHTTPResp.getStatusCode()||" ("||DelMESLotNoHTTPResp.getStatusDescription()||")")

        END CASE
        CATCH
        LET wsstatus = status
        CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
        END TRY

    #
    # RESET VARIABLES
    #
    LET DelMESLotNoHTTPReq = NULL
    LET DelMESLotNoHTTPResp = NULL
    RETURN wsstatus
end function

#-------------------------------------------------------------------------------
