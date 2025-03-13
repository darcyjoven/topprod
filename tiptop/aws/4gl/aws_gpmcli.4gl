# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Library name...: aws_gpmcli
# Descriptions...: GPM Web Service Client 
# Input parameter: 
# Return code....: 
# Usage .........: 
# Date & Author..: 06/12/29 By Jack Lai
# Modify.........: No.FUN-6C0040 06/12/21 By Jack Lai Call GPM Web Service Client
# Modify.........: No.TQC-710068 07/01/17 By Jack Lai 以背景執行程式時, aws_gpmcli_toolbar()應直接RETURN
# Modify.........: No.FUN-720042 07/02/27 By Brendan Genero 2.0 調整
# Modify.........: No.TQC-760018 07/06/04 By Jack Lai 增加記錄 SOAP error 錯誤訊息
# Modify.........: No.FUN-870091 08/07/15 By kevin 修改帳號及密碼固定值
# Modify.........: NO.FUN-880016 08/08/05 BY Yiting 增加 FUNCTION
# Modify.........: NO.FUN-890009 08/09/02 BY kevin 將 l_service 改成 g_service
# Modify.........: No.FUN-880013 08/09/04 By kevin 不再使用zx10
# Modify.........: No.TQC-910050 09/01/22 By sabrina (1)GPM連線密碼的帳號密碼錯誤，正確的帳號密碼為tiptop/TOP12345
#                                                    (2)錯誤訊息視窗新增〝項次〞欄位
# Modify.........: No.TQC-970134 09/07/16 By sherry  采購單審核時會異常退出
IMPORT com   #FUN-720042
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#FUN-720042
 
GLOBALS "../4gl/aws_gpmgw.inc"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
 
#No.FUN-6C0040 --start--
DEFINE g_result_xml     om.DomNode
DEFINE g_request        om.DomNode
DEFINE g_snode          om.DomNode
DEFINE g_dnode          om.DomNode
DEFINE g_rnode          om.DomNode
DEFINE g_tnode          om.DomNode
DEFINE g_rownode        om.DomNode
DEFINE g_req_doc        om.DomDocument
DEFINE g_passwd         STRING          #user password
DEFINE g_status         LIKE type_file.num10         #aws_gpmcli() return status
DEFINE g_gpmsoap        STRING          #GPM SOAP URL
DEFINE g_gpmhttp        STRING          #GPM HTTP URL
DEFINE g_client         STRING          #GPM Client IP (TIPTOP Host)
DEFINE g_gpmsiteip      STRING          #GPM Server IP
DEFINE g_result         STRING          #GPM result XML document
DEFINE g_result_value   STRING          #GPM result value in XML
DEFINE g_result_desc    STRING          #GPM result describe in XML
DEFINE g_ws_status      LIKE type_file.num10 #ws_status     #No.TQC-760018 
DEFINE g_sql            STRING          #NO.FUN-880016
DEFINE g_cnt            LIKE type_file.num5         #NO.FUN-880016
DEFINE g_i              LIKE type_file.num5         #NO.FUN-880016
DEFINE p_type           LIKE type_file.chr1         #NO.FUN-880016 #判斷來源為何種單據
                                                    #1.採購單 2.無交期性採購單 3.採購變更單價維護  4.料件/製造商承認資料維護
                                                    #5.請購單 6.採購料件詢價 7.採購收貨 8.採購庫存異動
DEFINE g_service        STRING #FUN-890009                                                    
 
               
#------------------------------------------------------------------------------
# Library name...: aws_gpmcli
# Descriptions...: GPM web service client
# Input Parameter: p_partnum    
#                  p_supplierid
# Return code....: -2   Client error
#                  -1   GPM return except
#                   0   GPM return false
#                   1   GPM return true
# Usage .........: call aws_gpmcli(p_partnum,p_supplierid) returing l_status
#------------------------------------------------------------------------------
FUNCTION aws_gpmcli(p_partnum,p_supplierid)
    DEFINE p_partnum       STRING
    DEFINE p_supplierid    STRING
    DEFINE l_status        LIKE type_file.num10
    
    IF g_aza.aza71 matches '[ Nn]' OR g_aza.aza71 IS NULL THEN #check GPM integration 
        CALL cl_err('','mfg3560',1)
        LET g_status = -2
        RETURN g_status
    END IF
    
    LET g_service = 'GetPartGreenBySupplierParts' #FUN-890009
    
    IF p_partnum IS NOT NULL THEN
       IF p_supplierid IS NOT NULL THEN
          IF g_action_choice = "gpm_show" THEN
             CALL aws_gpmcli_fn(p_partnum,p_supplierid,0)
                 RETURNING l_status
             IF l_status != -1 THEN 
                CALL aws_gpmcli_openurl(p_partnum,p_supplierid)
                  RETURNING l_status
             END IF 
          ELSE   
             CALL aws_gpmcli_fn(p_partnum,p_supplierid,1)
                 RETURNING l_status
          END IF 
       ELSE
          IF g_action_choice = "gpm_show" THEN
             CALL aws_gpmcli_openurl(p_partnum,p_supplierid)
                 RETURNING l_status
          ELSE
             CALL aws_gpmcli_fn(p_partnum,p_supplierid,1)
               RETURNING l_status
             #CALL cl_err('','!',1)
          END IF
       END IF
    ELSE
       CALL aws_gpmcli_fn(p_partnum,p_supplierid,1)
         RETURNING l_status
       #CALL cl_err('','!',1)
    END IF
      
    RETURN l_status
END FUNCTION
 
 
FUNCTION aws_gpmcli_fn(p_partnum,p_supplierid,p_showmsg)
    DEFINE p_partnum       STRING
    DEFINE p_supplierid    STRING
    DEFINE p_showmsg       LIKE type_file.num5
    DEFINE buf             base.StringBuffer
    DEFINE l_str           STRING
    DEFINE l_status        LIKE type_file.num10
    DEFINE l_cnt           LIKE type_file.num10
    
    LET g_strXMLInput = NULL
    LET g_result_value = NULL 
    LET g_result_desc = NULL
    LET g_status = 1
        
    CALL aws_gpmcli_prepareRequest(g_service,'') #FUN-890009
    IF g_status <= 0 THEN
        RETURN g_status
    END IF
    
    CALL aws_gpmcli_QrySuppPartStat(p_partnum,p_supplierid)
    
    CALL aws_gpmcli_processRequest()
    
    #.. & . &amp; 
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_strXMLInput)
    CALL buf.replace( "&","&amp;", 0)
    LET g_strXMLInput = buf.toString()
 
    LET gpmService_CtrlGreenStatus_CtrlGreenStatusSoapLocation = g_gpmsoap
    #LET gpmService_soapServerLocation = g_gpmsoap   #set Soap server location   #no.FUN-880016  
    CALL fgl_ws_setOption("http_invoketimeout", 60) #set web service timeout
    CALL gpmService_QrySupplierPartStatus(g_strXMLInput)
          RETURNING l_status, g_result
 
    LET g_ws_status = l_status  #let aws_gpmcli_logfile() know l_status #No.TQC-760018
    
   #CALL aws_gpmcli_logfile()
 
    IF l_status = 0 THEN        
        CALL aws_gpmcli_processResult(p_showmsg)
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
        RETURN g_status
    END IF
 
    RETURN g_status
 
END FUNCTION
 
#------------------------------------------------------------------------------
# write xml to log
#------------------------------------------------------------------------------
FUNCTION aws_gpmcli_logfile()
    DEFINE l_str    STRING
    DEFINE l_file   STRING
    DEFINE l_cmd    STRING
    DEFINE l_ch     base.Channel
    
    LET l_file = fgl_getenv("TEMPDIR"), "/aws_gpmcli-", TODAY USING 'YYYYMMDD', ".log"
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
        #No.TQC-760018 --start--
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
        #CALL l_ch.write(g_result)
        #CALL l_ch.write("")
        #No.TQC-760018 --end--
        CALL l_ch.write("#------------------------------------------------------------------------------#")
        CALL l_ch.write("")
        CALL l_ch.write("")
        CALL l_ch.close()
        
        LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>&1"
        RUN l_cmd
    ELSE
        DISPLAY "Can't open log file."
    END IF
END FUNCTION
 
#------------------------------------------------------------------------------
# Generate XML Request Header
#------------------------------------------------------------------------------
FUNCTION aws_gpmcli_prepareRequest(p_method,p_action)
    DEFINE p_method STRING
    DEFINE p_action STRING
    DEFINE l_code   LIKE type_file.num5     
    #DEFINE l_service STRING   #FUN-880016 #FUN-890009
    
    #LET l_service = 'GetPartGreenBySupplierParts'   #NO.FUN-880016  #FUN-890009  
    CALL aws_gpmcli_siteinfo(p_method) RETURNING l_code #FUN-890009
    
    IF l_code = 0 THEN
        LET g_status = -2
        RETURN
    END IF
    
    LET g_req_doc = om.DomDocument.create('Request')
    LET g_rnode = g_req_doc.getDocumentElement()
    CALL g_rnode.setAttribute('name', p_method CLIPPED)
    IF NOT cl_null(p_action) THEN
        CALL g_rnode.setAttribute('action', p_action CLIPPED)
    END IF
    CALL g_rnode.setAttribute('version', '1.0')
    
    LET g_snode = g_rnode.createChild('SenderIP')
    LET g_tnode = g_req_doc.createChars(g_client CLIPPED)
    CALL g_snode.appendChild(g_tnode)
    
    LET g_snode = g_rnode.createChild('ReceiverIP')
    LET g_tnode = g_req_doc.createChars(g_gpmsiteip CLIPPED)
    CALL g_snode.appendChild(g_tnode)
    
    LET g_snode = g_rnode.createChild('ID')
    #LET g_tnode = g_req_doc.createChars(g_user CLIPPED)
    LET g_tnode = g_req_doc.createChars("tiptop" CLIPPED) #FUN-870091
    CALL g_snode.appendChild(g_tnode)
    
    LET g_snode = g_rnode.createChild('PWD')
    #LET g_tnode = g_req_doc.createChars(g_passwd CLIPPED)
    LET g_tnode = g_req_doc.createChars("TOP12345" CLIPPED) #FUN-870091
    CALL g_snode.appendChild(g_tnode)
     
END FUNCTION
 
#------------------------------------------------------------------------------
# Generate XML Request Body (QrySuppPartStat)
#------------------------------------------------------------------------------
FUNCTION aws_gpmcli_QrySuppPartStat(p_partnum,p_supplierid)
 
    DEFINE p_partnum     STRING
    DEFINE p_supplierid  STRING
 
    
    LET g_snode = g_rnode.createChild('Mode')
    LET g_tnode = g_req_doc.createChars('2')
    CALL g_snode.appendChild(g_tnode)
    
    LET g_snode = g_rnode.createChild('Data')
    LET g_snode = g_snode.createChild("Row")
    CALL g_snode.setAttribute("CompanyKey", g_plant CLIPPED)
    CALL g_snode.setAttribute("PartNum", p_partnum CLIPPED)
    CALL g_snode.setAttribute("SupplierId", p_supplierid CLIPPED)
END FUNCTION
 
#------------------------------------------------------------------------------
# DOM to xml string
#------------------------------------------------------------------------------
FUNCTION aws_gpmcli_processRequest()
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
    CALL g_rnode.write(l_handle)
    #CALL g_rnode.writeXml(l_file)
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
    RUN "rm -f " || l_file
 
END FUNCTION
 
#------------------------------------------------------------------------------
# get response xml string and parsing xml content
#------------------------------------------------------------------------------
FUNCTION aws_gpmcli_processResult(p_showmsg)
    DEFINE p_showmsg    LIKE type_file.num5
    DEFINE l_ch         base.Channel
    DEFINE l_file       STRING
    DEFINE l_doc        om.DomDocument
    DEFINE l_node_list  om.NodeList
    DEFINE l_snode      om.DomNode
    DEFINE l_str        STRING
 
    #--------------------------------------------------------------------------
    # generate temp xml file
    #--------------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "w")
    CALL l_ch.setDelimiter(NULL)
    CALL l_ch.write(g_result)
    CALL l_ch.close()
 
    LET l_doc = om.DomDocument.createFromXmlFile(l_file)
    RUN "rm -f " || l_file
    IF l_doc IS NULL THEN
          CALL cl_err(l_doc, 'IS NULL', 1)   #....
    END IF
    
    LET g_result_xml = l_doc.getDocumentElement()
    LET l_node_list = g_result_xml.selectByTagName("Status")
    LET l_snode = l_node_list.item(1)
    LET g_result_value = l_snode.getAttribute("result")
    LET g_result_value = g_result_value.trim()
    LET g_result_desc = l_snode.getAttribute("desc")
    LET g_result_desc = g_result_desc.trim()
    
    CASE g_result_value
        WHEN 'true'
            LET g_status = 1
        WHEN 'false'
            LET g_status = 0
        OTHERWISE
            LET g_status = -1
    END CASE
    
    IF p_showmsg != 1 THEN
        LET p_showmsg = 0
    END IF
         
    IF g_status = -1 THEN
        IF fgl_getenv('FGLGUI') = '1' THEN
            LET l_str = "GPM return error:\n\n", g_result_desc
        ELSE
            LET l_str = "GPM return error: ", g_result_desc
        END IF
        CALL cl_err(l_str, '!', 1)   #GPM Server return except
    ELSE
        LET l_str = g_result_desc
        # ...........
        
        CALL cl_err(l_str, '!', p_showmsg)
        #CALL FGL_WINMESSAGE(g_result_value, g_result_desc, "ok")
        
    END IF
END FUNCTION
 
#------------------------------------------------------------------------------
# Add GPM TOOLBAR
#------------------------------------------------------------------------------
FUNCTION aws_gpmcli_toolbar()
    DEFINE l_root          om.DomNode
    DEFINE l_nl            om.NodeList
    DEFINE l_toolbar       om.DomNode
    DEFINE l_child         om.DomNode
    DEFINE l_node          om.DomNode
    DEFINE l_items         DYNAMIC ARRAY OF STRING
    DEFINE l_i             LIKE type_file.num10
    DEFINE l_actionlist    om.DomNode
    DEFINE l_action_child  om.DomNode
    DEFINE l_name          STRING
    DEFINE l_image         STRING
    DEFINE l_text          STRING
    
    #clear dynamic array
    CALL l_items.clear()
    
    #No.TQC-710068 --start--
    #背景執行時, 直接結束程式
    IF g_bgjob MATCHES '[Yy]' THEN
        RETURN
    END IF
    #No.TQC-710068 --end--
    
    #Add GPM action
    LET l_items[1] = 'gpm_show'
    LET l_items[2] = 'gpm_query'
 
    LET l_root = ui.Interface.getRootNode()
    LET l_nl = l_root.selectByPath("/UserInterface/ToolBar")
    LET l_toolbar = l_nl.item(1)
    LET l_child = l_toolbar.getLastChild()
    
    LET l_node = l_toolbar.createChild("ToolBarSeparator")
    CALL l_toolbar.appendChild(l_node)
    LET l_child = l_node
 
    LET l_nl = l_root.selectByPath("/UserInterface/ActionDefaultList")
    LET l_actionlist = l_nl.item(1)
 
    FOR l_i = 1 TO l_items.getLength()
        LET l_node = l_toolbar.createChild("ToolBarItem")
        CALL l_node.setAttribute("name", l_items[l_i])
        LET l_action_child = l_actionlist.getLastChild()
        
        # Get GPM actions from Action Defaults and add they to toolbar
        WHILE l_action_child IS NOT NULL
            LET l_name  = l_action_child.getAttribute("name")
            IF l_items[l_i] = l_name THEN
                LET l_image = l_action_child.getAttribute("image")
                LET l_text = l_action_child.getAttribute("text")
                CALL l_node.setAttribute("image", l_image)
                CALL l_node.setAttribute("text", l_text)
                EXIT WHILE
            END IF
            LET l_action_child = l_action_child.getNext()
        END WHILE
        CALL l_toolbar.appendChild(l_node)
        LET l_child = l_node
    END FOR
 
    CALL ui.Interface.refresh()
                
END FUNCTION
 
#------------------------------------------------------------------------------
# Open GPM URL by IE web browser
#------------------------------------------------------------------------------
FUNCTION aws_gpmcli_openurl(p_partnum,p_supplierid)
    DEFINE p_partnum    STRING
    DEFINE p_supplierid STRING
    DEFINE l_url        STRING
    DEFINE l_status     LIKE type_file.num10
    DEFINE l_code       LIKE type_file.num5
    #DEFINE l_service    STRING    #NO.FUN-880016 #FUN-890009
 
    LET l_status = 0
    
    #LET g_service = 'GetPartGreenBySupplierParts'  #FUN-880016  #FUN-890009
    CALL aws_gpmcli_siteinfo(g_service) RETURNING l_code #FUN-890009
    IF l_code = 0 THEN
        LET g_status = -2
        RETURN g_status
    END IF
    
    
    LET l_url = g_gpmhttp CLIPPED,
                #"?ID=",g_user CLIPPED,
                #"&PWD=",g_passwd CLIPPED,
                "?ID=tiptop",     #FUN-870091
                "&PWD=TOP12345",  #FUN-870091
                "&CompanyKey=",g_plant CLIPPED,
                "&SupplierId=",p_supplierid CLIPPED,
                "&PartNum=",p_partnum CLIPPED,"&Mode=1"
                    
    CALL cl_open_url(l_url) RETURNING l_status
 
    RETURN  l_status
END FUNCTION
 
FUNCTION aws_gpmcli_siteinfo(p_service)
    DEFINE l_code  LIKE type_file.num5
    DEFINE l_wge02 LIKE wge_file.wge02
    DEFINE l_wge03 LIKE wge_file.wge03    
    DEFINE l_wge08 LIKE wge_file.wge08
    #DEFINE l_zx10  LIKE zx_file.zx10 #FUN-880013
DEFINE l_wge09     LIKE wge_file.wge09  #no.FUN-880016 add
DEFINE l_wgf02     LIKE wgf_file.wgf02  #no.FUN-880016 add 
DEFINE l_wgf03     LIKE wgf_file.wgf03  #no.FUN-880016 add
DEFINE p_service   STRING               #NO.FUN-880016 ADD
 
    LET l_code = 1
    
    #-------------------NO.FUN-880016 mark---------------------------------
    #SELECT wge02,wge03,wge08 INTO l_wge02,l_wge03,l_wge08
    #  FROM wge_file WHERE wge01 = 'E' AND wge06 = g_plant
    #    AND wge05 = '*' AND wge07 = '*'
    #IF l_wge02 IS NULL THEN
    #    CALL cl_err3('sel','wge_file',g_plant,'',100,'','',1)
    #    LET l_code = 0
    #    RETURN l_code
    #ELSE
    #    LET g_gpmsoap = l_wge03 CLIPPED       #GPM SOAP URL
    #    LET g_gpmsiteip = l_wge02 CLIPPED     #GPM Server IP
    #    LET g_gpmhttp = l_wge08 CLIPPED       #GPM HTTP URL
    #END IF
    #-------------------NO.FUN-880016 mark----------------------------------
 
 
    #-----NO.FUN-880016 start-----
    SELECT wge02,wge09 INTO l_wge02,l_wge09
      FROM wge_file WHERE wge01 = 'E' AND wge06 = g_plant
        AND wge05 = '*' AND wge07 = '*'
    IF l_wge02 IS NULL THEN
        CALL cl_err3('sel','wge_file',g_plant,'',100,'','',1)
        LET l_code = 0
        RETURN l_code
    END IF
 
    LET g_sql = "SELECT wgf02,wgf03 ",
                "  FROM wgf_file",
                " WHERE wgf01 = '",p_service,"'" 
    PREPARE wgf_p FROM g_sql
    DECLARE wgf_c
        SCROLL CURSOR FOR wgf_p
    OPEN wgf_c
    FETCH wgf_c INTO l_wgf02,l_wgf03 
         
    IF l_wgf02 IS NULL THEN
        CALL cl_err3('sel','wgf_file',g_plant,'',100,'','',1)
        LET l_code = 0
        RETURN l_code
    END IF
    LET g_gpmsoap = "http://",l_wge02,":",l_wge09,"/",l_wgf02
    LET g_gpmhttp = "http://",l_wge02,":",l_wge09,"/",l_wgf03
    LET g_gpmsiteip = l_wge02 CLIPPED     #GPM Server IP
    #----NO.FUN-880016 end---------
 
    #FUN-880013 --start--
    #SELECT zx10 INTO l_zx10 FROM zx_file WHERE zx01 = g_user
    #IF l_zx10 IS NULL THEN
    #    CALL cl_err3('sel','zx_file',g_user,'',100,'','',1)
    #    LET l_code = 0
    #    RETURN l_code
    #ELSE
    #    LET g_passwd = l_zx10 CLIPPED #User Password
    #END IF
    #FUN-880013 --end--
    
    LET g_client = cl_getClientIP()       #Client IP
    RETURN l_code
END FUNCTION
 
#NO.FUN-880016 start----------------
FUNCTION aws_gpmcli_part(p_no,p_supplierid,p_serial_no,p_type)
DEFINE p_no            STRING
DEFINE p_supplierid    STRING
DEFINE p_showmsg       LIKE type_file.num5
DEFINE buf             base.StringBuffer
DEFINE l_str           STRING
DEFINE l_status        LIKE type_file.num10
DEFINE l_cnt           LIKE type_file.num10
DEFINE l_code          LIKE type_file.num5     
DEFINE l_cmd           STRING
DEFINE p_serial_no     LIKE type_file.num5
DEFINE p_type          LIKE type_file.chr1         #NO.FUN-880016 #判斷來源為何種單據
                                                   #1.採購單 2.無交期性採購單 3.採購變更單價維護  4.料件/製造商承認資料維護
                                                    #5.請購單 6.採購料件詢價 7.採購收貨 8.採購庫存異動
DEFINE l_service       STRING 
    
    LET g_status = 0
    LET g_strXMLInput = NULL
    LET g_result_value = NULL 
    LET g_result_desc = NULL
 
    IF g_aza.aza71 matches '[ Nn]' OR g_aza.aza71 IS NULL THEN #check GPM integration 
        CALL cl_err('','mfg3560',1)
        LET g_status = 1
        RETURN g_status
    END IF
 
    #LET l_service = 'QrySupplierPartStatus'      #FUN-890009    
    LET g_service = 'QrySupplierPartStatus' #FUN-890009
    
    CALL aws_gpmcli_siteinfo(g_service) RETURNING l_code  #FUN-890009
    
    IF l_code = 0 THEN
        LET g_status = 1
        #RETURN            #TQC-970134 
        RETURN g_status    #TQC-970134      
    END IF
 
    CALL aws_gpmcli_genGPMRequest(p_no,p_supplierid,p_serial_no,p_type)    #組輸入XML
    
    IF g_i <> 0 THEN
        #.. & . &amp; 
        LET buf = base.StringBuffer.create()
        CALL buf.append(g_strXMLInput)
        CALL buf.replace( "&", "&amp;", 0)
        LET g_strXMLInput = buf.toString()
 
        LET gpmService_CtrlGreenStatus_CtrlGreenStatusSoapLocation = g_gpmsoap
        CALL fgl_ws_setOption("http_invoketimeout", 60) #set web service timeout
        CALL gpmService_GetPartGreenBySupplierParts(g_strXMLInput)  #呼叫SERVICE 記得名稱要一致 
              RETURNING l_status, g_result
 
        LET g_ws_status = l_status  #let aws_gpmcli_logfile() know l_status #No.TQC-760018
        
        CALL aws_gpmcli_logfile()    #將產生的xml寫入log
 
        IF l_status = 0 THEN   
            CALL aws_gpmcli_PartGpmResult(p_no,p_type)   #解析回傳的XML
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
            LET g_status = 1  
            RETURN g_status
        END IF
 
        RETURN g_status
    ELSE
        LET g_status = 0
        RETURN g_status
    END IF
END FUNCTION
 
FUNCTION aws_gpmcli_genGPMRequest(p_no,p_supplierid,p_serial_no,p_type)   
DEFINE p_no            STRING
DEFINE p_supplierid    STRING
DEFINE p_creator       STRING,
       p_owner          STRING,
       l_client         STRING,
       l_i              LIKE type_file.num5 
DEFINE l_userid         LIKE type_file.chr10
DEFINE l_passwd         LIKE type_file.chr10
DEFINE l_pmn04          LIKE pmn_file.pmn04
DEFINE l_xmlbody        STRING
DEFINE l_cnt            LIKE type_file.num5
DEFINE l_pon04          LIKE pon_file.pon04
DEFINE l_pnb04a         LIKE pnb_file.pnb04a
DEFINE l_pml04          LIKE pml_file.pml04
DEFINE l_pmj03          LIKE pmj_file.pmj03
DEFINE l_rvb05          LIKE rvb_file.rvb05
DEFINE l_rvv31          LIKE rvv_file.rvv31
DEFINE p_type           LIKE type_file.chr1
DEFINE p_serial_no      LIKE type_file.num5
 
   #LET l_userid = "TIPTOP"           #TQC-910050 錯誤的帳號
   #LET l_passwd = "top12345"         #TQC-910050 錯誤的密碼
    LET l_userid = "tiptop"           #TQC-910050 正確的帳號
    LET l_passwd = "TOP12345"         #TQC-910050 正確的密碼
 
    LET g_strXMLInput =                           #組 XML Header
        "<GPMRequest_PartGreenStatus>", ASCII 10,
        " <Authorization>", ASCII 10,
        "   <CompanyKey></CompanyKey>", ASCII 10,
        "   <UserId>", l_userid CLIPPED, "</UserId>", ASCII 10,
        "   <PWD>", l_passwd CLIPPED, "</PWD>", ASCII 10,
        " </Authorization>", ASCII 10,
        " <RequestContent>", ASCII 10,
        "   <RequestTime>", g_today CLIPPED, "</RequestTime>", ASCII 10
 
   LET g_i = 0
   CASE 
     WHEN p_type = '1'   #採購單
         LET g_sql = "SELECT COUNT(*)", 
                     "  FROM pmn_file ",
                     " WHERE pmn01 = '",p_no,"'"
         PREPARE xml_pmmcnt_p FROM g_sql
         DECLARE xml_pmmcnt_c
             SCROLL CURSOR FOR xml_pmmcnt_p
         OPEN xml_pmmcnt_c
         FETCH xml_pmmcnt_c INTO l_cnt 
         
         LET g_sql = " SELECT pmn04 FROM pmn_file ",
                     "  WHERE pmn01 = '",p_no,"'" 
         PREPARE xml_pmn_pb FROM g_sql
         LET l_i = 0
         DECLARE xml_pmn_curs
             CURSOR WITH HOLD FOR xml_pmn_pb
         FOREACH xml_pmn_curs INTO l_pmn04
         IF cl_null(l_pmn04) THEN
             CONTINUE FOREACH
         ELSE
             LET g_i = g_i + 1
             LET l_xmlbody = l_xmlbody CLIPPED, 
                  "   <SupplierPart>", ASCII 10,
                  "     <SupplierId>", p_supplierid CLIPPED, "</SupplierId>", ASCII 10,
                  "     <PartNum>", l_pmn04 CLIPPED, "</PartNum>", ASCII 10,
                  "   </SupplierPart>", ASCII 10
         END IF
         END FOREACH
     WHEN p_type = '2'  #無交期性採購單
         LET g_sql = " SELECT pon04 FROM pon_file ",
                     "  WHERE pon01 = '",p_no,"'" 
         PREPARE xml_pon_pb FROM g_sql
         LET l_i = 0
         DECLARE xml_pon_curs
             CURSOR WITH HOLD FOR xml_pon_pb
         FOREACH xml_pon_curs INTO l_pon04
         IF cl_null(l_pon04) THEN
             CONTINUE FOREACH
         ELSE
             LET g_i = g_i +1 
             LET l_xmlbody = l_xmlbody CLIPPED, 
                  "   <SupplierPart>", ASCII 10,
                  "     <SupplierId>", p_supplierid CLIPPED, "</SupplierId>", ASCII 10,
                  "     <PartNum>", l_pon04 CLIPPED, "</PartNum>", ASCII 10,
                  "   </SupplierPart>", ASCII 10
         END IF
         END FOREACH
     WHEN p_type = '3'  #採購變更單價
         LET g_sql = " SELECT pnb04a FROM pnb_file ",
                     "  WHERE pnb01 = '",p_no,"'",
                     "    AND pnb02 = '",p_serial_no,"'" 
         PREPARE xml_pnb_pb FROM g_sql
         LET l_i = 0
         DECLARE xml_pnb_curs
             CURSOR WITH HOLD FOR xml_pnb_pb
         FOREACH xml_pnb_curs INTO l_pnb04a
           IF cl_null(l_pnb04a) THEN 
               CONTINUE FOREACH 
           ELSE
               LET g_i = g_i +1 
               LET l_xmlbody = l_xmlbody CLIPPED, 
                    "   <SupplierPart>", ASCII 10,
                    "     <SupplierId>", p_supplierid CLIPPED, "</SupplierId>", ASCII 10,
                    "     <PartNum>", l_pnb04a CLIPPED, "</PartNum>", ASCII 10,
                    "   </SupplierPart>", ASCII 10
           END IF
         END FOREACH
     WHEN p_type = '5'  #請購單
         LET g_sql = " SELECT pml04 FROM pml_file ",
                     "  WHERE pml01 = '",p_no,"'" 
         PREPARE xml_pml_pb FROM g_sql
         LET l_i = 0
         DECLARE xml_pml_curs
             CURSOR WITH HOLD FOR xml_pml_pb
         FOREACH xml_pml_curs INTO l_pml04
         IF cl_null(l_pml04) THEN 
             CONTINUE FOREACH
         ELSE
             LET g_i = g_i + 1
             LET l_xmlbody = l_xmlbody CLIPPED, 
                  "   <SupplierPart>", ASCII 10,
                  "     <SupplierId>", p_supplierid CLIPPED, "</SupplierId>", ASCII 10,
                  "     <PartNum>", l_pml04 CLIPPED, "</PartNum>", ASCII 10,
                  "   </SupplierPart>", ASCII 10
         END IF
         END FOREACH
     WHEN p_type = '6'  #採購料件詢價
         LET g_sql = " SELECT pmj03 FROM pmj_file ",
                     "  WHERE pmj01 = '",p_no,"'" 
         PREPARE xml_pmj_pb FROM g_sql
         LET l_i = 0
         DECLARE xml_pmj_curs
             CURSOR WITH HOLD FOR xml_pmj_pb
         FOREACH xml_pmj_curs INTO l_pmj03
         IF cl_null(l_pmj03) THEN
             CONTINUE FOREACH
         ELSE
             LET g_i = g_i + 1
             LET l_xmlbody = l_xmlbody CLIPPED, 
                  "   <SupplierPart>", ASCII 10,
                  "     <SupplierId>", p_supplierid CLIPPED, "</SupplierId>", ASCII 10,
                  "     <PartNum>", l_pmj03 CLIPPED, "</PartNum>", ASCII 10,
                  "   </SupplierPart>", ASCII 10
         END IF
         END FOREACH
     WHEN p_type = '7'  #採購收貨
         LET g_sql = " SELECT rvb05 FROM rvb_file ",
                     "  WHERE rvb01 = '",p_no,"'" 
         PREPARE xml_rvb_pb FROM g_sql
         LET l_i = 0
         DECLARE xml_rvb_curs
             CURSOR WITH HOLD FOR xml_rvb_pb
         FOREACH xml_rvb_curs INTO l_rvb05
         IF cl_null(l_rvb05) THEN
             CONTINUE FOREACH
         ELSE
             LET g_i = g_i + 1
             LET l_xmlbody = l_xmlbody CLIPPED, 
                  "   <SupplierPart>", ASCII 10,
                  "     <SupplierId>", p_supplierid CLIPPED, "</SupplierId>", ASCII 10,
                  "     <PartNum>", l_rvb05 CLIPPED, "</PartNum>", ASCII 10,
                  "   </SupplierPart>", ASCII 10
         END IF
         END FOREACH
     WHEN p_type = '8'  #採購庫存異動
         LET g_sql = " SELECT rvv31 FROM rvv_file ",
                     "  WHERE rvv01 = '",p_no,"'" 
         PREPARE xml_rvv_pb FROM g_sql
         LET l_i = 0
         DECLARE xml_rvv_curs
             CURSOR WITH HOLD FOR xml_rvv_pb
         FOREACH xml_rvv_curs INTO l_rvv31
         IF cl_null(l_rvv31) THEN
             CONTINUE FOREACH
         ELSE
             LET g_i = g_i + 1
             LET l_xmlbody = l_xmlbody CLIPPED, 
                  "   <SupplierPart>", ASCII 10,
                  "     <SupplierId>", p_supplierid CLIPPED, "</SupplierId>", ASCII 10,
                  "     <PartNum>", l_rvv31 CLIPPED, "</PartNum>", ASCII 10,
                  "   </SupplierPart>", ASCII 10
         END IF
         END FOREACH
   END CASE
 
   IF g_i <> 0 THEN
       LET g_strXMLInput = g_strXMLInput CLIPPED, l_xmlbody CLIPPED, 
                         " </RequestContent>", ASCII 10,
                         "</GPMRequest_PartGreenStatus>", ASCII 10
   END IF
END FUNCTION
 
FUNCTION aws_gpmcli_PartGpmResult(p_no,p_type)   #解析回傳的XML
DEFINE p_no         LIKE pmn_file.pmn01
DEFINE l_node_list  om.NodeList
DEFINE l_snode      om.DomNode
DEFINE ln_node      om.DomNode
DEFINE l_node       om.DomNode
DEFINE l_faultreason STRING
DEFINE l_time       STRING
DEFINE l_result     LIKE type_file.chr1
DEFINE l_responsetime STRING
DEFINE l_i          LIKE type_file.num5
DEFINE nl_record    om.NodeList
DEFINE l_supplier   LIKE pmm_file.pmm09
DEFINE l_partnum    LIKE pmn_file.pmn04
DEFINE l_fitstatus  STRING
DEFINE l_fitdesc    STRING
DEFINE l_file       STRING
DEFINE l_file1      STRING
DEFINE l_doc        om.DomDocument
DEFINE l_str        STRING
DEFINE l_ch         base.Channel
DEFINE ms_codeset   STRING
DEFINE l_cmd        STRING
DEFINE p_type       LIKE type_file.chr1
DEFINE l_lineno     LIKE pml_file.pml02     #項次     #TQC-910050 add
##########
#單頭解析
##########
 
   LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(l_file, "w")
   CALL l_ch.setDelimiter(NULL)
   CALL l_ch.write(g_result)
   CALL l_ch.close()
   #LET l_file1 = fgl_getenv("TEMPDIR"), "/gpm_log.xml"
    
   #LET l_cmd = "cat ",l_file," |b5tou8 >",l_file1
   #RUN l_cmd
   LET l_doc = om.DomDocument.createFromXmlFile(l_file)
   RUN "rm -f " || l_file
   #RUN "rm -f " || l_file1
   IF l_doc IS NULL THEN
         CALL cl_err(l_doc, 'IS NULL', 1)   #....
   END IF
    
   LET g_result_xml = l_doc.getDocumentElement()
 
   LET l_node_list = g_result_xml.selectByTagName("Result")
   LET l_snode = l_node_list.item(1)
   LET ln_node = l_snode.getFirstChild()
   LET l_result = ln_node.getAttribute("@chars")
 
   IF l_result = '1' THEN   #失敗時才抓出失敗原因
       LET l_node_list = g_result_xml.selectByTagName("FaultReason")
       LET l_snode = l_node_list.item(1)
       LET ln_node = l_snode.getFirstChild()
       LET l_faultreason = ln_node.getAttribute("@chars")
   END IF
 
   LET l_node_list = g_result_xml.selectByTagName("ResponseTime")
   LET l_snode = l_node_list.item(1)
   LET ln_node = l_snode.getFirstChild()
   LET l_responsetime = ln_node.getAttribute("@chars")
 
##############
#單身for迴圈
##############
   IF l_result = '0' THEN
       LET nl_record =  g_result_xml.selectByPath("//Detail/SupplierPart")
       LET g_cnt = nl_record.getLength()
       FOR l_i = 1 to g_cnt
 
           LET l_snode = nl_record.item(l_i)
 
           LET l_node = l_snode.getChildByIndex(1) #Supplier
           LET ln_node = l_node.getFirstChild()
           LET l_supplier = ln_node.getAttribute("@chars")
 
           LET l_lineno = l_i             #TQC-910050 add
 
           LET l_node = l_snode.getChildByIndex(2) #partnum     
           LET ln_node = l_node.getFirstChild()
           LET l_partnum = ln_node.getAttribute("@chars")
            
           LET l_node = l_snode.getChildByIndex(3) #FitStatus  
           LET ln_node = l_node.getFirstChild()
           LET l_fitstatus = ln_node.getAttribute("@chars")
 
           LET l_node = l_snode.getChildByIndex(4) #FitDesc   
           LET ln_node = l_node.getFirstChild()                 
           LET l_fitdesc  = ln_node.getAttribute("@chars")     
 
           LET g_showmsg = p_no,'/',l_supplier,'/',l_lineno,'/',l_partnum,'/',l_fitdesc    #TQC-910050 add l_lineno
           CASE
               WHEN p_type = '1'
                 CALL s_errmsg("pmn01,pmm09,pmn02,pmn04,status",g_showmsg,g_showmsg,"",1)    #TQC-910050 add pnm02
               WHEN p_type = '2'
                 CALL s_errmsg("pom01,pom09,pon02,pon04,status",g_showmsg,g_showmsg,"",1)    #TQC-910050 add pon02
               WHEN p_type = '3'
                 CALL s_errmsg("pna01,pmm09,pnb03,pnb04a,status",g_showmsg,g_showmsg,"",1)   #TQC-910050 add pnb03
               WHEN p_type = '4'
                #CALL s_errmsg("pmn01,pmm09,pmn04,status",g_showmsg,g_showmsg,"",1)          #TQC-910050 mark 已沒有"4"這個選項了
               WHEN p_type = '5'
                 CALL s_errmsg("pmk01,pmk09,pml02,pml04,status",g_showmsg,g_showmsg,"",1)    #TQC-910050 add pml02
               WHEN p_type = '6'
                 CALL s_errmsg("pmi01,pmi03,pmj02,pmj03,status",g_showmsg,g_showmsg,"",1)    #TQC-910050 add pmj02
               WHEN p_type = '7'
                 CALL s_errmsg("rva01,rva05,rvb02,rvb05,status",g_showmsg,g_showmsg,"",1)    #TQC-910050 add rvb02
               WHEN p_type = '8'
                 CALL s_errmsg("rvu01,rvu04,rvv02,rvv31,status",g_showmsg,g_showmsg,"",1)    #TQC-910050 add rvv02
           END CASE
           IF l_fitstatus <> '0' THEN
               LET g_status = 1
           END IF
       END FOR   
   ELSE
       LET g_status = 1   #失敗
   END IF 
END FUNCTION
#NO.FUN-880016 end----------------
 
