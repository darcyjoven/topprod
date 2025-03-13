# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Library name...: aws_crmcli
# Descriptions...: CRM Web Service Client 
# Input parameter: 
# Return code....: 
# Usage .........: 
# Date & Author..: No.FUN-AC0068 10/12/31 By Lilan 
# Modify.........: No.FUN-BC0065 12/01/05 By Abby 當系統有與CRM整合時,客戶做留置/取消留置/停止交易/恢復交易動作時，需同步通知CRM
# Modify.........: No.FUN-C20087 12/03/06 By Abby  新增CROSS平台整合

IMPORT com  

IMPORT os     
DATABASE ds

GLOBALS "../4gl/aws_crmgw.inc"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_crossgw.inc"   #FUN-C20087

#FUN-AC0068

DEFINE g_result_xml     om.DomNode
DEFINE g_request        om.DomNode
DEFINE g_snode          om.DomNode
DEFINE g_dnode          om.DomNode
DEFINE g_rnode          om.DomNode
DEFINE g_tnode          om.DomNode
DEFINE g_unode          om.DomNode
DEFINE g_vnode          om.DomNode
DEFINE g_wnode          om.DomNode
DEFINE g_xnode          om.DomNode
DEFINE g_req_doc        om.DomDocument
DEFINE g_passwd         STRING                  #user password
DEFINE g_status         LIKE type_file.num10    #aws_crmcli() return status
DEFINE g_crmsoap        STRING                  #CRM SOAP URL
DEFINE g_crmhttp        STRING                  #CRM HTTP URL
DEFINE g_client         STRING                  #CRM Client IP (TIPTOP Host)
DEFINE g_crmsiteip      STRING                  #CRM Server IP
DEFINE g_result         STRING                  #CRM result XML document
DEFINE g_result_status  STRING                  #CRM result status in XML
DEFINE g_result_desc    STRING                  #CRM result Description in XML
DEFINE g_ws_status      LIKE type_file.num10    #ws_status     
DEFINE g_switch         LIKE type_file.num5
DEFINE g_action         STRING
DEFINE g_showmsg        LIKE type_file.num5
DEFINE g_key1,
       g_key2,
       g_key3           STRING
DEFINE g_sql            STRING    
DEFINE g_wap            RECORD LIKE wap_file.*  #FUN-C20087
 
#------------------------------------------------------------------------------
# Library name...: aws_crmcli
# Descriptions...: CRM web service client
# Input Parameter: 
# Return code....: -2   Client error
#                  -1   CRM return except
#                   0   CRM return false
#                   1   CRM return true
# Usage .........: call aws_crmcli(p_prog,p_action,p_key1,p_key2,p_key3) returing l_status
#------------------------------------------------------------------------------
FUNCTION aws_crmcli(p_prog,p_action,p_key1,p_key2,p_key3)
    DEFINE p_prog          STRING
    DEFINE p_action        STRING
    DEFINE p_key1          STRING        #狀態(1.刪除 2.作廢)
    DEFINE p_key2          STRING        #key值(單號/客戶編號)
    DEFINE p_key3          STRING        #單據種類(1.雜收發單 2.出貨單)
    DEFINE l_status        LIKE type_file.num10
    DEFINE l_description   STRING
    
    IF cl_null(g_aza.aza123) OR (g_aza.aza123<>'Y') THEN 
       CALL cl_err('','mfg3565',1)
       LET g_status = -2
       RETURN g_status
    END IF

    IF cl_null(g_user) THEN LET g_user = 'TP' END IF    

    CASE WHEN (p_prog='aimt370' AND p_action='chkdel' ) LET g_switch = 1
         WHEN (p_prog='x' AND p_action='restatus' ) LET g_switch = 2
         WHEN (p_prog='axmi221' AND (p_action='hang' OR p_action='untransaction')) LET g_switch = 3  #FUN-BC0065
         WHEN (p_prog='axmi221' AND (p_action='unhang' OR p_action='transaction')) LET g_switch = 4  #FUN-BC0065
         OTHERWISE LET g_switch=0
    END CASE 

    IF g_switch=0 THEN RETURN FALSE END IF
 
    LET g_action = p_action
    LET g_key1 = p_key1
    LET g_key2 = p_key2
    LET g_key3 = p_key3
    LET g_showmsg= 1

    CALL aws_crmcli_1() RETURNING l_status, l_description
      
    RETURN l_status, l_description
END FUNCTION
 
 
FUNCTION aws_crmcli_1()
    DEFINE buf             base.StringBuffer
    DEFINE l_str           STRING
    DEFINE l_status        LIKE type_file.num10
    DEFINE l_cnt           LIKE type_file.num10
    DEFINE l_str2          STRING                #FUN-C20087
    DEFINE l_cross_status  LIKE type_file.num5   #FUN-C20087
    
    LET g_strXMLInput = NULL
    LET g_result_status = NULL 
    LET g_result_desc = NULL
    LET g_status = 1
    
    CALL aws_crmcli_prepareRequest()

    IF g_status <= 0 THEN RETURN g_status END IF
 
    CASE 
     WHEN g_switch=1 CALL aws_crmcli_CheckDeleteOrVoidMISCIssueData()
     WHEN g_switch=2 CALL aws_crmcli_DeleteOrVoidSuccessForRepair()
     WHEN g_switch=3 CALL aws_crmcli_UpdateStopTransactionDate()  #FUN-BC0065
     WHEN g_switch=4 CALL aws_crmcli_RemoveStopTransactionDate()  #FUN-BC0065
    END CASE
    
    CALL aws_crmcli_processRequest()
    
    #.. & . &amp; 
 
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)
   #FUN-C20087 add str----
    SELECT wap02 INTO g_wap.wap02 FROM wap_file
    IF g_wap.wap02 = 'Y' THEN  #使用CROSS整合平台
       LET l_str = "CRM"
       CASE
        WHEN g_switch=1 LET l_str2 = "CheckDeleteOrVoidMISCIssueData"
        WHEN g_switch=2 LET l_str2 = "DeleteOrVoidSuccessForRepair"
       END CASE
       #呼叫 CROSS 平台發出整合活動請求
       CALL aws_cross_invokeSrv(l_str,l_str2,"sync",g_strXMLInput)
            RETURNING l_cross_status, l_status, g_result
       IF NOT l_cross_status  THEN
          LET g_result_desc = "拋轉失敗"
          RETURN -2,g_result_desc
       END IF
    ELSE
   #FUN-C20087 add end----
       LET crmService_ICRMForTIPTOPWS_ICRMForTIPTOPWSSoapLocation = g_crmsoap  #set Soap server location  
       CALL fgl_ws_setOption("http_invoketimeout", 60)     #set web service timeout
       CASE 
         WHEN g_switch=1 CALL crmService_CheckDeleteOrVoidMISCIssueData(g_strXMLInput) RETURNING l_status, g_result
         WHEN g_switch=2 CALL crmService_DeleteOrVoidSuccessForRepair(g_strXMLInput) RETURNING l_status, g_result                         
            WHEN g_switch=3 CALL crmService_UpdateStopTransactionDate(g_strXMLInput) RETURNING l_status, g_result  #FUN-BC0065
            WHEN g_switch=4 CALL crmService_RemoveStopTransactionDate(g_strXMLInput) RETURNING l_status, g_result  #FUN-BC0065
       END CASE
    END IF  #FUN-C20087

    LET g_ws_status = l_status

    CALL aws_crmcli_logfile()

    IF l_status = 0 THEN
        CALL aws_crmcli_processResult()
    ELSE 
        IF fgl_getenv('FGLGUI') = '1' THEN
            LET l_str = "Connection failed:\n\n", 
                        "  [Code]: ", wsError.code, "\n",
                        "  [Action]: ", wsError.action, "\n",
                        "  [Description]: ", wsError.description
        ELSE
            LET l_str = "Connection failed: ", wsError.description
        END IF
        CALL cl_err(l_str, '!', 1)   #connection failed
        LET g_status = -2
        LET g_result_desc = ' '
        RETURN g_status,g_result_desc
    END IF

    RETURN g_status,g_result_desc
 
END FUNCTION
 
#------------------------------------------------------------------------------
# Generate XML Request Header
#------------------------------------------------------------------------------
FUNCTION aws_crmcli_prepareRequest()
    DEFINE l_code      LIKE type_file.num5     
    DEFINE l_sendtime  LIKE type_file.chr30      
    DEFINE l_transid   LIKE type_file.chr30      
    DEFINE l_today     LIKE type_file.chr30      
    DEFINE l_time      LIKE type_file.chr30      
    DEFINE l_tpip      STRING,  
           l_tpenv     STRING,
           l_lang      STRING   
    
    CALL aws_crmcli_siteinfo() RETURNING l_code
    
    IF l_code = 0 THEN
        LET g_status = -2
        RETURN
    END IF
    
    IF cl_null(g_user) THEN LET g_user ='TP' END IF 
 
    LET l_sendtime = TODAY USING 'yyyy/mm/dd',' ',TIME   
 
    LET l_transid  = CURRENT HOUR TO FRACTION(2)
    LET l_transid  = cl_replace_str(l_transid,':','')   
    LET l_transid  = cl_replace_str(l_transid,'.','')   
    LET l_transid  = TODAY USING 'yyyymmdd',cl_replace_str(l_transid,':','')   
    LET l_tpip = cl_get_tpserver_ip()    #TIPTOP IP 

    CASE 
       WHEN g_lang='0' LET l_lang = 'zh_tw'
       WHEN g_lang='1' LET l_lang = 'en_us'
       WHEN g_lang='2' LET l_lang = 'zh_cn'
    END CASE

    LET g_strXMLInput =                           #組 XML Header
               "<Request>", ASCII 10,								
               "<Access>", ASCII 10, 							
               "  <Authentication user='CRMDS' password='' />", ASCII 10,								
               "  <Connection application='TIPTOP' source='",l_tpip CLIPPED,"' />", ASCII 10,														
               "  <Organization name='", g_plant CLIPPED,"' />", ASCII 10,											
               "  <Locale language='",l_lang CLIPPED,"' />", ASCII 10,								
               "</Access>", ASCII 10								
   
END FUNCTION
 
 
#------------------------------------------------------------------------------
# Generate XML Request Body 
#------------------------------------------------------------------------------
#若有與CRM整合,需先取得是否可刪除/作廢單據
FUNCTION aws_crmcli_CheckDeleteOrVoidMISCIssueData()

   LET g_strXMLInput = g_strXMLInput CLIPPED, 
                      "<RequestContent>", ASCII 10,								
                      "  <Parameter>", ASCII 10, 							
                      "    <Master>", ASCII 10,       														
                      "       <Field name='Status' value='",g_key1 CLIPPED,"' />", ASCII 10,     								         								
                      "       <Field name='TypeNo' value='",g_key2 CLIPPED,"' />", ASCII 10,   								
                      "    </Master>", ASCII 10, 								
                      "  </Parameter>", ASCII 10,								
                      "</RequestContent>", ASCII 10,								
                      "</Request>", ASCII 10
 
END FUNCTION

#若有與CRM整合,需回饋CRM單據狀態,表CRM可再重發單 
FUNCTION aws_crmcli_DeleteOrVoidSuccessForRepair()
 
   LET g_strXMLInput = g_strXMLInput CLIPPED, 
                      "<RequestContent>", ASCII 10,
                      "  <Parameter>", ASCII 10,
                      "    <Master>", ASCII 10,
                      "       <Field name='Status' value='",g_key1 CLIPPED,"' />", ASCII 10,
                      "       <Field name='TypeProperty' value='",g_key3 CLIPPED,"' />", ASCII 10,
                      "       <Field name='TypeNo' value='",g_key2 CLIPPED,"' />", ASCII 10,
                      "    </Master>", ASCII 10, 
                      "  </Parameter>", ASCII 10, 
                      "</RequestContent>", ASCII 10,
                      "</Request>", ASCII 10
END FUNCTION 

#FUN-BC0065 add str--- 
#當系統有與CRM整合時，客戶主檔(axmi221)執行『留置』、『停止交易』動作時，需即時通知CRM系統
FUNCTION aws_crmcli_UpdateStopTransactionDate()
 
   LET g_strXMLInput = g_strXMLInput CLIPPED, 
                      "<RequestContent>", ASCII 10,
                      "  <Parameter>", ASCII 10,
                      "    <Master>", ASCII 10,
                      "       <Field name='CustomerID' value='",g_key2 CLIPPED,"' />", ASCII 10,
                      "       <Field name='StopDate' value='",TODAY USING 'yyyymmdd',"' />", ASCII 10,
                      "    </Master>", ASCII 10, 
                      "  </Parameter>", ASCII 10, 
                      "</RequestContent>", ASCII 10,
                      "</Request>", ASCII 10
END FUNCTION 

#當系統有與CRM整合時，客戶主檔(axmi221)執行『取消留置』、『恢復交易』動作時，需即時通知CRM系統
FUNCTION aws_crmcli_RemoveStopTransactionDate()
 
   LET g_strXMLInput = g_strXMLInput CLIPPED, 
                      "<RequestContent>", ASCII 10,
                      "  <Parameter>", ASCII 10,
                      "    <Master>", ASCII 10,
                      "       <Field name='CustomerID' value='",g_key2 CLIPPED,"' />", ASCII 10,
                      "       <Field name='StopDate' value='",TODAY USING 'yyyymmdd',"' />", ASCII 10,
                      "    </Master>", ASCII 10, 
                      "  </Parameter>", ASCII 10, 
                      "</RequestContent>", ASCII 10,
                      "</Request>", ASCII 10
END FUNCTION 
#FUN-BC0065 add end
 
#------------------------------------------------------------------------------
# DOM to xml string
#------------------------------------------------------------------------------
FUNCTION aws_crmcli_processRequest()
    DEFINE l_msg      STRING
    DEFINE l_status   STRING
    DEFINE l_ch       base.Channel
    DEFINE l_buf      STRING
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_file     STRING
    DEFINE l_handle   om.SaxDocumentHandler
 
    LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
    LET l_handle = om.XmlWriter.createFileWriter(l_file)
    CALL l_handle.setIndent(FALSE)
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "r")
    CALL l_ch.setDelimiter(NULL)
    LET l_i = 1
    WHILE l_ch.read(l_buf)
        IF l_i != 1 THEN
            LET g_strXMLInput = g_strXMLInput, '\n'
        END IF
        LET g_strXMLInput = g_strXMLInput, l_buf CLIPPED
        LET l_i = l_i + 1
    END WHILE
    CALL l_ch.close()
    RUN "rm -f " || l_file || " >/dev/null 2>&1"
END FUNCTION
 
#------------------------------------------------------------------------------
# get response xml string and parsing xml content
#------------------------------------------------------------------------------
FUNCTION aws_crmcli_processResult()
 
    LET g_result_status = aws_xml_getTag(g_result,"Code")
    LET g_result_desc = aws_xml_getTag(g_result,"Description") CLIPPED
    LET g_status = g_result_status

END FUNCTION
 
FUNCTION aws_crmcli_siteinfo()
    DEFINE l_code  LIKE type_file.num5
    DEFINE l_wge02 LIKE wge_file.wge02
    DEFINE l_wge03 LIKE wge_file.wge03    
    DEFINE l_wge08 LIKE wge_file.wge08
    
    LET l_code = 1
    
    SELECT wge02,wge03,wge08 INTO l_wge02,l_wge03,l_wge08
      FROM wge_file 
     WHERE wge01 = 'C' 
       AND wge06 = g_plant
       AND wge05 = '*' 
       AND wge07 = '*'
    IF l_wge02 IS NULL THEN
        CALL cl_err3('sel','wge_file',g_plant,'',100,'','',1)
        LET l_code = 0
        RETURN l_code
    ELSE
        LET g_crmsoap = l_wge03 CLIPPED       #CRM SOAP URL
        LET g_crmsiteip = l_wge02 CLIPPED     #CRM Server IP
        LET g_crmhttp = l_wge08 CLIPPED       #CRM HTTP URL
    END IF
    
    LET g_client = cl_getClientIP()           #Client IP
    RETURN l_code
END FUNCTION
 
#------------------------------------------------------------------------------
# write xml to log
#------------------------------------------------------------------------------
FUNCTION aws_crmcli_logfile()
    DEFINE l_str    STRING
    DEFINE l_str2   STRING
    DEFINE l_status STRING
    DEFINE l_file   STRING
    DEFINE l_cmd    STRING
    DEFINE l_ch     base.Channel


    LET l_file = fgl_getenv("TEMPDIR"), "/aws_crmcli-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()

    CALL l_ch.openFile(l_file, "a")
    CALL l_ch.setDelimiter("")

    IF STATUS = 0 THEN
        LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL l_ch.write(l_str)
        CALL l_ch.write("")
        LET l_str = "Program: ", g_prog CLIPPED
        CALL l_ch.write(l_str)
        
        CALL l_ch.write("Request XML:")
        CALL l_ch.write(g_strXMLInput)
        CALL l_ch.write("")
        
        CALL l_ch.write("Response XML:")
        IF g_ws_status = 0 THEN
            CALL l_ch.write(g_result)
            CALL l_ch.write("")
        ELSE
            CALL l_ch.write("")
            IF fgl_getenv('FGLGUI') = '1' THEN
                LET l_str = "   Connection failed:\n\n",
                            "     [Code]: ", wserror.code, "\n",
                            "     [Action]: ", wserror.action, "\n",
                            "     [Description]: ", wserror.description
            ELSE
                LET l_str = "   Connection failed: ", wserror.description
            END IF
            CALL l_ch.write(l_str)
            CALL l_ch.write("")
        END IF
        CALL l_ch.write("#------------------------------------------------------------------------------#")
        CALL l_ch.write("")
        CALL l_ch.write("")
        CALL l_ch.close()
        
        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF      
    ELSE
        DISPLAY "Can't open log file."
    END IF
END FUNCTION

