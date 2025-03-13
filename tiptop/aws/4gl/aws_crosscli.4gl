# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#{
# Program name...: aws_crosscli.4gl
# Descriptions...: 透過 Web Services  TIPTOP 與 CROSS 整合
# Date & Author..: 2011/03/18 by Echo
# Memo...........:
# Modify.........: 新建立 FUN-B20029
# Modify.........: FUN-B80090 11/12/30 By ka0132 增加參數傳遞功能
# Modify.........: No:FUN-BB0161 11/11/29 By ka0132 新增--"SyncEncodingState"(更改編碼狀態)
#}
 
IMPORT xml
IMPORT com
IMPORT os
DATABASE ds
 
#FUN-B20029
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_crossgw.inc"

DEFINE g_tp_version      STRING
DEFINE g_reqdoc          om.DomDocument
DEFINE g_wap             RECORD LIKE  wap_file.* 
DEFINE g_war             RECORD LIKE  war_file.* 
DEFINE g_request_root    om.DomNode                #Request XML Dom Node
DEFINE g_response_root   om.DomNode                #Response XML Dom Node
DEFINE g_code            STRING                    #互動代碼
DEFINE g_message         STRING                    #互動訊息
 

#[
# Description....: 呼叫 CROSS 平台發出整合活動請求
# Date & Author..: 2010/03/25 by Echo
# Parameter......: p_prod        - STRING     - 呼叫產品名稱 
#                : p_srvname     - STRING     - 呼叫服務名稱
#                : p_type        - STRING     - 同步型態: sync(同步), async(非同步), mdm, etl
#                : p_Request     - STRING     - 標準整合 Request XML 字串
# Return.........: TRUE/FALSE    - INTEGER    - CROSS 處理成功否
#                : l_status      - INTEGER    - WebService處理狀況
#                : l_Result      - STRING     - 標準整合 Response XML 字串
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_cross_invokeSrv(p_prod,p_srvname,p_type,p_Request)   
DEFINE p_prod            STRING
DEFINE p_srvname         STRING
DEFINE p_location        STRING
DEFINE p_type            STRING
DEFINE p_Request         STRING
DEFINE l_Request         STRING
DEFINE l_Result          STRING
DEFINE l_host_att        STRING
DEFINE l_request_att     STRING
DEFINE l_status          LIKE type_file.num10
DEFINE l_i               LIKE type_file.num10
DEFINE l_node_list       om.NodeList
DEFINE l_node            om.DomNode   
DEFINE l_snode           om.DomNode   
DEFINE l_tnode           om.DomNode
DEFINE l_pnode           om.DomNode
DEFINE lx_reqdoc         xml.DomDocument
DEFINE lx_resdoc         xml.DomDocument
DEFINE lx_node_list      xml.DomNodeList
DEFINE lx_tnode          xml.DomNode
DEFINE lx_pnode          xml.DomNode
DEFINE l_str             STRING
DEFINE l_key             STRING
DEFINE l_xml_str         STRING
DEFINE l_host_str        STRING
DEFINE l_srv_str         STRING
DEFINE l_payload         STRING
DEFINE l_sb              base.StringBuffer
DEFINE l_start           LIKE type_file.num10
DEFINE l_end             LIKE type_file.num10
#---#FUN-B80090---start-----
DEFINE lx_p_reqnode      om.DomNode             #判斷傳入參數是否為xml格式字串
DEFINE l_tok             base.StringTokenizer   #
DEFINE l_name            STRING
DEFINE l_value           STRING
DEFINE l_p               LIKE type_file.num5
#---#FUN-B80090---end-----


    #取得 CROSS 整合參數資料
    CALL aws_cross_wap()   

    #建立 Request XML Documene
    LET g_request_root = aws_cross_createRequest("", "timezone,timestamp,acct")
  
    # service 資訊
    IF NOT aws_cross_war(p_prod) THEN
       LET l_status = "-1"
       RETURN FALSE, 0,""
    END IF
    LET l_snode = g_request_root.createChild("service")            #建立 <service>
    CALL l_snode.setAttribute("prod", p_prod.trim())               #產品名稱 
    CALL l_snode.setAttribute("name", p_srvname.trim())            #服務名稱
    CALL l_snode.setAttribute("ip", g_war.war05 CLIPPED)           #IP 位址
    CALL l_snode.setAttribute("id", g_war.war06 CLIPPED)           #識別碼

    #取得 host 及 service 字串 <host prod=.../><service prod=.../>
    LET l_Request = g_request_root.toString()
    LET l_start = l_Request.getIndexOf("<host",1)
    LET l_end = l_Request.getIndexOf("/>",l_Request.getIndexOf("<service",l_start))
    LET l_xml_str =  l_Request.subString(l_start,l_end+1)

    #指定 request 屬性值, 屬性間用逗號(,)區隔, 屬性名稱與內容值用 | 區隔
    LET l_key = cl_generate_crosskey(l_xml_str)
    CALL g_request_root.setAttribute("type", p_type.trim())        #同步類型
    CALL g_request_root.setAttribute("key", l_key.trim())          #檢核編碼

    # payload 資訊
    LET l_pnode = g_request_root.createChild("payload")            #建立 <payload>

    #---FUN-B80090---start-----
    #檢查request是否為xml格式,如果不是:就以傳參數方式來組<payload>
    LET lx_p_reqnode = aws_cross_stringToXml(p_Request)
    IF lx_p_reqnode IS NULL AND p_Request.getIndexOf("|", 1) > 0 THEN
       #spilt參數個數--參數個數的區隔用","--name與value值用"|"區隔
       LET l_tok = base.StringTokenizer.createExt(p_Request, ",", "", TRUE)
       WHILE l_tok.hasMoreTokens()
             LET l_str = l_tok.nextToken()
             LET l_p  = l_str.getIndexOf("|", 1)
             IF l_p > 0 THEN
                LET l_name = l_str.subString(1, l_p-1)
                LET l_value = l_str.subString(l_p+1, l_str.getLength())
             ELSE    
                LET l_name = l_str
                LET l_value = ""
             END IF
             LET l_pnode = aws_crosscli_param(l_pnode, l_name, "string", l_value)
       END WHILE
       LET l_Request = g_request_root.toString()
       LET lx_reqdoc = xml.DomDocument.Create()
       CALL lx_reqdoc.loadFromString(l_Request)
    ELSE
    #---FUN-B80090---end-----

    #指定 payload 為 CDATA 型態
    LET l_Request = g_request_root.toString()
    LET lx_reqdoc = xml.DomDocument.Create()
    CALL lx_reqdoc.loadFromString(l_Request)
    LET lx_node_list = lx_reqdoc.getElementsByTagName("payload")
    LET lx_pnode = lx_node_list.getitem(1)
    LET lx_tnode = lx_reqdoc.createCDATASection(p_Request.trim())
    CALL lx_pnode.appendChild(lx_tnode) 
    END IF   #FUN-B80090

    #將 XML 文件轉換成 String 字串
    LET l_Request = lx_reqdoc.saveToString()

    #若 60 秒內無回應則放棄
    CALL fgl_ws_setOption("http_invoketimeout", 60)   

    LET l_Request = cl_coding_en(l_Request) #No.FUN-BB0161 加密傳出的XML

    #呼叫 CRSOOS 服務
    CALL cross_invokeSrv(l_Request)  RETURNING l_status, l_Result

    #紀錄傳遞 CROSS XML 字串
    CALL aws_crosscli_logfile("invokeSrv",l_status,l_Request,l_Result)

    IF l_status != 0 THEN
       RETURN TRUE, l_status,""
    END IF

    LET l_Result = cl_coding_de(l_Result) #No.FUN-BB0161 解密傳入的XML

    #取得 XML 字串的 Root Node
    LET lx_resdoc = xml.DomDocument.Create()
    CALL lx_resdoc.loadFromString(l_Result)
    IF lx_resdoc IS NULL THEN
       CALL cl_err("Response isn't valid XML document","!",1)
       RETURN FALSE, 0,""
    END IF

    # 尋找 <code>, <message> tag  資料                                       
    LET lx_node_list = lx_resdoc.getElementsByTagName("code")
    IF lx_node_list.getCount() != 0 THEN
       LET lx_pnode = lx_node_list.getitem(1)
       LET lx_tnode = lx_pnode.getFirstChild()
       LET g_code = lx_tnode.getNodeValue()
    END IF

    LET lx_node_list = lx_resdoc.getElementsByTagName("message")
    IF lx_node_list.getCount() != 0 THEN
       LET lx_pnode = lx_node_list.getitem(1)
       LET lx_tnode = lx_pnode.getFirstChild()
       LET g_message = lx_tnode.getNodeValue()
    END IF

    IF g_code = "019" THEN  #產品資訊
        # 尋找對應名稱的 payload  CDATA section 包覆的 XML 資料                                       
       LET lx_node_list = lx_resdoc.getElementsByTagName("payload")
       LET lx_pnode = lx_node_list.getitem(1)
       LET lx_tnode = lx_pnode.getFirstChild()
       LET l_payload = lx_tnode.getNodeValue()
    ELSE
       LET l_str = "XML parser :\n\n",
                     g_code.trim() ," ", g_message.trim() 
        CALL cl_err(l_str, '!', 1) 
       RETURN FALSE, 0,""
    END IF

    RETURN TRUE,l_status, l_payload

END FUNCTION

#[
# Description....: 呼叫 CROSS 註冊產品主機資訊
# Date & Author..: 2010/03/18 by Echo
# Parameter......: none
# Return.........: TRUE/FALSE    - INTEGER    - CROSS 註冊成功否
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_cross_regProdAP()   
DEFINE l_Request         STRING
DEFINE l_Result          STRING
DEFINE l_prod_list       DYNAMIC ARRAY OF RECORD     #產品清單
       name              LIKE type_file.chr30,       #產品名稱
       ver               LIKE type_file.chr20,       #產品版本
       ip                LIKE type_file.chr20,       #IP位置
       id                LIKE type_file.chr20,       #識別碼
       wsdl              LIKE wap_file.wap03,        #wsdl 
       timezone          LIKE azp_file.azp052,       #時區 
       retrytimes        LIKE wap_file.wap05,        #服務連線失敗重試次數 
       retryinterval     LIKE wap_file.wap06,        #服務連線失敗重次間隔 
       concurrence       LIKE wap_file.wap07         #允許同時處理數 
       END RECORD
DEFINE l_status          LIKE type_file.num10
DEFINE l_i               LIKE type_file.num10
DEFINE l_node_list       om.NodeList
DEFINE l_snode           om.DomNode
DEFINE l_pnode           om.DomNode
DEFINE ln_node           om.DomNode
DEFINE l_node            om.DomNode   
DEFINE l_action          STRING
DEFINE l_str             STRING


    #取得 CROSS 整合參數資料
    CALL aws_cross_wap()   

    # 查詢 TIPTOP 註冊資訊                                                                    
    IF NOT aws_cross_getProd("TIPTOP",g_tp_version,cl_get_tpserver_ip(),cl_get_env(),l_prod_list) THEN
       IF (g_code NOT MATCHES "0??" AND g_code != "806" ) OR cl_null(g_code) THEN
          RETURN FALSE
       END IF
    END IF

    LET l_action = "reg"
    FOR l_i = 1 TO l_prod_list.getLength()
        #若有相同資訊，則為"修改主機資訊"
        IF l_prod_list[l_i].ver = g_tp_version AND
           l_prod_list[l_i].ip = cl_get_tpserver_ip() AND 
           l_prod_list[l_i].id = cl_get_env() THEN
           LET l_action = "update"
           EXIT FOR
        END IF
    END FOR  
  
    #若設定不與 CROSS 整合，則不需要進行註冊
    IF g_wap.wap02 = "N" AND l_action = "reg" THEN
       RETURN FALSE
    END IF

    #若設定不與 CROSS 整合，並且CROSS 上已有註冊 TIPTOP 產品資訊時，且進行刪除產品主機資訊
    IF g_wap.wap02 = "N" AND l_action = "update" THEN
       LET l_action = "unreg"
    END IF

    #-----------------------------------------------------------------------------------------#
    # 註冊產品主機資訊                                                                        #
    #-----------------------------------------------------------------------------------------#
    #建立 Request XML Documene
    LET g_request_root = aws_cross_createRequest("action|"|| l_action ,"")

    # payload 資訊
    LET l_pnode = g_request_root.createChild("payload")            #建立 <payload>

    IF l_action = "reg" OR l_action = "update" THEN
       LET l_pnode = aws_crosscli_param(l_pnode,"wsdl","string",g_wap.wap03)           #TIPTOP WSDL
       LET l_pnode = aws_crosscli_param(l_pnode,"retrytimes","integer",g_wap.wap05)    #服務連線失敗重試次數
       LET l_pnode = aws_crosscli_param(l_pnode,"retryinterval","integer",g_wap.wap06) #服務連線失敗重試間隔
       LET l_pnode = aws_crosscli_param(l_pnode,"concurrence","integer",g_wap.wap07)   #同時連線人數
    END IF

    #將 XML 文件轉換成 String 字串
    LET l_Request = g_request_root.toString()

    #若 60 秒內無回應則放棄
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   

    #呼叫 CRSOOS, 查詢 TIPTOP 產品的詳細資訊
    CALL cross_regProdAP(l_Request)  RETURNING l_status, l_Result

    #紀錄傳遞 CROSS XML 字串
    CALL aws_crosscli_logfile("regProdAP",l_status, l_Request,l_Result)

    IF l_status != 0 THEN
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n",
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n", 
                   "  [Description]: ", wserror.description
       ELSE        
          LET l_str = "Connection failed: ", wserror.description
       END IF 
       CALL cl_err(l_str, '!', 1)   #連接失敗
       RETURN FALSE
    END IF


    #取得 XML 字串的 Root Node
    LET g_response_root = aws_cross_stringToXml(l_Result)
    IF g_response_root IS NULL THEN
       CALL cl_err("Response isn't valid XML document","!",1)
       RETURN FALSE
    END IF

    # 尋找對應名稱的 tag  資料                                       
    LET g_code = aws_cross_getTagValue(g_response_root,"code","@chars")
    LET g_message = aws_cross_getTagValue(g_response_root,"message","@chars")
    LET l_str = ""
    IF g_code NOT MATCHES "0??" THEN
        LET l_str = "XML parser :\n\n"
    END IF 
    LET l_str = l_str, g_code.trim() ," ", g_message.trim() 
    display l_str
    CALL cl_err(l_str, '!', 1) 
    RETURN TRUE

END FUNCTION

#[
# Description....: 呼叫 CROSS 註冊產品主機服務清單
# Date & Author..: 2010/03/25 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_cross_regSrv()   
DEFINE l_Request         STRING
DEFINE l_Result          STRING
DEFINE l_srv_list        DYNAMIC ARRAY OF RECORD     #產品服務清單
       name              LIKE type_file.chr50        #服務名稱
       END RECORD
DEFINE l_status          LIKE type_file.num10
DEFINE l_i               LIKE type_file.num10
DEFINE l_node_list       om.NodeList
DEFINE l_snode           om.DomNode
DEFINE l_pnode           om.DomNode
DEFINE ln_node           om.DomNode
DEFINE l_node            om.DomNode   
DEFINE l_action          STRING
DEFINE l_str             STRING
DEFINE l_sql             STRING
DEFINE l_waq02           LIKE waq_file.waq02   
DEFINE l_srv_reg         DYNAMIC ARRAY OF LIKE waq_file.waq02    #新增服務清單
DEFINE l_srv_unreg       DYNAMIC ARRAY OF LIKE waq_file.waq02    #刪除服務清單
DEFINE l_cnt             LIKE type_file.num10
DEFINE l_reg_cnt         LIKE type_file.num10
DEFINE l_waq_cnt         LIKE type_file.num10
DEFINE l_payload         STRING

    #取得 CROSS 整合參數資料
    CALL aws_cross_wap()   


    # 查詢 TIPTOP 註冊資訊                                                                    
    IF NOT aws_cross_getSrv("TIPTOP",g_tp_version,cl_get_tpserver_ip(),cl_get_env(),l_srv_list) THEN
       IF g_code NOT MATCHES "0??" OR cl_null(g_code) THEN
          RETURN
       END IF
    END IF

    #服務註冊只有新增及刪除，不需要修改動作。
    LET l_cnt = 0
    DECLARE waq_cs CURSOR FOR SELECT waq02 FROM waq_file
    FOREACH waq_cs INTO l_waq02
       LET l_action = "reg"
       FOR l_i = 1 TO l_srv_list.getLength()
           IF l_waq02 = l_srv_list[l_i].name THEN
              LET l_action = "update"
              EXIT FOR
           END IF
       END FOR
       IF l_action = "reg"  THEN
          LET l_cnt = l_cnt + 1
          LET l_srv_reg[l_cnt] = l_waq02 CLIPPED
       END IF
    END FOREACH


    LET l_cnt = 0
    LET l_sql = "SELECT count(*) FROM waq_file WHERE waq02 = ? "
    PREPARE waq_cnt_pre FROM l_sql
    DECLARE waq_cnt_cs CURSOR FOR waq_cnt_pre

    FOR l_i = 1 TO l_srv_list.getLength()
       OPEN waq_cnt_cs USING l_srv_list[l_i].name
       FETCH waq_cnt_cs INTO l_waq_cnt
       IF l_waq_cnt = 0  THEN
          LET l_cnt = l_cnt + 1
          LET l_srv_unreg[l_cnt] = l_srv_list[l_i].name CLIPPED
       END IF
    END FOR


    LET l_str = ""
    FOR l_reg_cnt  =  1 TO 2
 
        IF l_reg_cnt = 1 THEN
           IF l_srv_reg.getLength() = 0 THEN
              CONTINUE FOR
           END IF
           LET l_action = "reg"      #新增服務
        ELSE
           IF l_srv_unreg.getLength() = 0 THEN
              CONTINUE FOR
           END IF
           LET l_action = "unreg"    #刪除服務
        END IF 

        #-----------------------------------------------------------------------------------------#
        # 註冊服務名稱資訊                                                                        #
        #-----------------------------------------------------------------------------------------#
        #建立 Request XML Documene
        LET g_request_root = aws_cross_createRequest("action|"|| l_action ,"")

        # payload 資訊
        LET l_pnode = g_request_root.createChild("payload")            #建立 <payload>

        IF l_action = "reg" THEN  #新增服務
           FOR l_i = 1 TO l_srv_reg.getLength()
               LET l_pnode = aws_crosscli_param(l_pnode,"srvname","string",l_srv_reg[l_i])   #服務名稱     
           END FOR 
        ELSE                      #刪除服務
           FOR l_i = 1 TO l_srv_unreg.getLength()
               LET l_pnode = aws_crosscli_param(l_pnode,"srvname","string",l_srv_unreg[l_i]) #服務名稱  
           END FOR 
        END IF

        #將 XML 文件轉換成 String 字串
        LET l_Request = g_request_root.toString()

        #若 60 秒內無回應則放棄
        CALL fgl_ws_setOption("http_invoketimeout", 60)                   

        #呼叫 CRSOOS, 註冊 TIPTOP 服務
        CALL cross_regSrv(l_Request)  RETURNING l_status, l_Result

        #紀錄傳遞 CROSS XML 字串
        CALL aws_crosscli_logfile("regSrv",l_status, l_Request,l_Result)

        IF l_status != 0 THEN
           IF fgl_getenv('FGLGUI') = '1' THEN
              LET l_str = "Connection failed:\n\n",
                       "  [Code]: ", wserror.code, "\n",
                       "  [Action]: ", wserror.action, "\n", 
                       "  [Description]: ", wserror.description
           ELSE        
              LET l_str = "Connection failed: ", wserror.description
           END IF 
           CALL cl_err(l_str, '!', 1)   #連接失敗
           RETURN 
        END IF


        #取得 XML 字串的 Root Node
        LET g_response_root = aws_cross_stringToXml(l_Result)
        IF g_response_root IS NULL THEN
           CALL cl_err("Response isn't valid XML document","!",1)
           RETURN
        END IF

        # 尋找對應名稱的 tag  資料                                       
        LET g_code = aws_cross_getTagValue(g_response_root,"code","@chars")
        LET g_message = aws_cross_getTagValue(g_response_root,"message","@chars")
        LET l_payload = aws_cross_getTagValue(g_response_root,"payload","@chars")

        IF NOT cl_null(l_str) THEN
           LET l_str = l_str ,"\n"
        END IF
        LET l_str = l_str, g_code.trim() ," ", g_message.trim() ," ", l_payload.trim()
    END FOR
    IF NOT cl_null(l_str) THEN
       CALL cl_err(l_str, '!', 1) 
    END IF

END FUNCTION

#[
# Description....: 查詢已註冊產品清單
# Date & Author..: 2010/03/18 by Echo
# Parameter......: p_prod_list  -    ARRAY     - 已註冊產品清單(可能查詢出多筆資料)
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_cross_getProdList(p_prod_list)
DEFINE p_prod_list       DYNAMIC ARRAY OF RECORD
       name              LIKE type_file.chr30,       #產品名稱
       ver               LIKE type_file.chr20,       #產品版本
       ip                LIKE type_file.chr20,       #IP位置
       id                LIKE type_file.chr20,       #識別碼
       wsdl              LIKE wap_file.wap03         #wsdl 
       END RECORD
DEFINE l_Request         STRING
DEFINE l_Result          STRING
DEFINE l_host_att        STRING
DEFINE l_status          LIKE type_file.num10
DEFINE l_i               LIKE type_file.num10
DEFINE l_node_list       om.NodeList
DEFINE l_node            om.DomNode   
DEFINE l_str             STRING
DEFINE g_code            STRING
DEFINE g_message         STRING


    #取得 CROSS 整合參數資料
    CALL aws_cross_wap()   

    #若 60 秒內無回應則放棄
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   

    #呼叫 CRSOOS, 查詢已註冊的產品資訊
    CALL cross_getProdList()  RETURNING l_status, l_Result

    #紀錄傳遞 CROSS XML 字串
    CALL aws_crosscli_logfile("getProdList",l_status,l_Request,l_Result)

    IF l_status != 0 THEN
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n",
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n", 
                   "  [Description]: ", wserror.description
       ELSE        
          LET l_str = "Connection failed: ", wserror.description
       END IF 
       CALL cl_err(l_str, '!', 1)   #連接失敗
       RETURN 
    END IF

    #取得 XML 字串的 Root Node
    LET g_response_root = aws_cross_stringToXml(l_Result)
    IF g_response_root IS NULL THEN
       CALL cl_err("Response isn't valid XML document","!",1)
       RETURN 
    END IF

    # 尋找對應名稱的 tag  資料                                       
    LET g_code = aws_cross_getTagValue(g_response_root,"code","@chars")
    LET g_message = aws_cross_getTagValue(g_response_root,"message","@chars")

    CALL p_prod_list.clear()
    IF g_code = "091" THEN  #已註冊產品資訊
       LET l_node_list = g_response_root.selectByPath("//payload/prod")
       FOR l_i = 1 TO l_node_list.getLength()
           LET l_node = l_node_list.item(l_i)
           LET p_prod_list[l_i].name = l_node.getAttribute("name")
           LET p_prod_list[l_i].ver = l_node.getAttribute("ver")
           LET p_prod_list[l_i].ip = l_node.getAttribute("ip")
           LET p_prod_list[l_i].id = l_node.getAttribute("id")
           LET p_prod_list[l_i].wsdl = l_node.getAttribute("wsdl")
       END FOR  
    ELSE
      LET l_str = "XML parser :\n\n",
                    g_code.trim() ," ", g_message.trim() 
       CALL cl_err(l_str, '!', 1) 
       RETURN 
    END IF


END FUNCTION

#[
# Description....: 查詢特定產品的詳細資訊
# Date & Author..: 2010/03/18 by Echo
# Parameter......: p_prod       -    STRING    - 產品名稱
#                : p_ver        -    STRING    - 版本
#                : p_ip         -    STRING    - IP
#                : p_id         -    STRING    - 識別碼
#                : p_prod_list  -    ARRAY     - 產品資訊(可能查詢出多筆資料)
# Return.........: TRUE/FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_cross_getProd(p_prod,p_ver,p_ip,p_id,p_prod_list)
DEFINE p_prod            STRING
DEFINE p_ver             STRING
DEFINE p_ip              STRING
DEFINE p_id              STRING
DEFINE p_prod_list       DYNAMIC ARRAY OF RECORD
       name              LIKE type_file.chr30,       #產品名稱
       ver               LIKE type_file.chr20,       #產品版本
       ip                LIKE type_file.chr20,       #IP位置
       id                LIKE type_file.chr20,       #識別碼
       wsdl              LIKE wap_file.wap03,        #wsdl 
       timezone          LIKE azp_file.azp052,       #時區 
       retrytimes        LIKE wap_file.wap05,        #服務連線失敗重試次數 
       retryinterval     LIKE wap_file.wap06,        #服務連線失敗重次間隔 
       concurrence       LIKE wap_file.wap07         #允許同時處理數 
       END RECORD
DEFINE l_Request         STRING
DEFINE l_Result          STRING
DEFINE l_host_att        STRING
DEFINE l_status          LIKE type_file.num10
DEFINE l_i               LIKE type_file.num10
DEFINE l_node_list       om.NodeList
DEFINE l_node            om.DomNode   
DEFINE l_str             STRING



    #取得 CROSS 整合參數資料
    CALL aws_cross_wap()   

    #指定 pord 屬性值, 屬性間用逗號(,)區隔, 屬性名稱與內容值用 | 區隔
    LET l_host_att = "prod|", p_prod.trim(),",",
                     "ver|", p_ver.trim(),",",
                     "ip|", p_ip.trim(),",",
                     "id|", p_id.trim()

    #建立 Request XML Documene
    LET g_request_root = aws_cross_createRequest("", l_host_att)
  
    #將 XML 文件轉換成 String 字串
    LET l_Request = g_request_root.toString()

    #若 60 秒內無回應則放棄
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   

    #呼叫 CRSOOS, 查詢已註冊產品的詳細資訊
    CALL cross_getProd(l_Request)  RETURNING l_status, l_Result

    #紀錄傳遞 CROSS XML 字串
    CALL aws_crosscli_logfile("getProd",l_status,l_Request,l_Result)

    IF l_status != 0 THEN
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n",
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n", 
                   "  [Description]: ", wserror.description
       ELSE        
          LET l_str = "Connection failed: ", wserror.description
       END IF 
       CALL cl_err(l_str, '!', 1)   #連接失敗
       RETURN  FALSE
    END IF


    #取得 XML 字串的 Root Node
    LET g_response_root = aws_cross_stringToXml(l_Result)
    IF g_response_root IS NULL THEN
       CALL cl_err("Response isn't valid XML document","!",1)
       RETURN FALSE
    END IF

    # 尋找對應名稱的 tag  資料                                       
    LET g_code = aws_cross_getTagValue(g_response_root,"code","@chars")
    LET g_message = aws_cross_getTagValue(g_response_root,"message","@chars")

    CALL p_prod_list.clear()
    IF g_code = "092" THEN  #產品資訊
       LET l_node_list = g_response_root.selectByPath("//payload/prod[@name=\"" || p_prod.trim() || "\"]")
       FOR l_i = 1 TO l_node_list.getLength()
           LET l_node = l_node_list.item(l_i)
           LET p_prod_list[l_i].name = l_node.getAttribute("name")
           LET p_prod_list[l_i].ver = l_node.getAttribute("ver")
           LET p_prod_list[l_i].ip = l_node.getAttribute("ip")
           LET p_prod_list[l_i].id = l_node.getAttribute("id")
           LET p_prod_list[l_i].wsdl = l_node.getAttribute("wsdl")
           LET p_prod_list[l_i].timezone = l_node.getAttribute("timezone")
           LET p_prod_list[l_i].retrytimes = l_node.getAttribute("retrytimes")
           LET p_prod_list[l_i].retryinterval = l_node.getAttribute("retryinterval")
           LET p_prod_list[l_i].concurrence = l_node.getAttribute("concurrence")
       END FOR  
    ELSE
       RETURN FALSE
    END IF

    RETURN TRUE

END FUNCTION

#[
# Description....: 查詢特定產品的服務清單
# Date & Author..: 2010/03/25 by Echo
# Parameter......: p_prod      -    STRING    - 產品名稱
#                : p_ver       -    STRING    - 版本
#                : p_ip        -    STRING    - IP
#                : p_id        -    STRING    - 識別碼
#                : p_srv_list  -    ARRAY     - 服務清單
# Return.........: TRUE/FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_cross_getSrv(p_prod,p_ver,p_ip,p_id,p_srv_list)
DEFINE p_prod            STRING
DEFINE p_ver             STRING
DEFINE p_ip              STRING
DEFINE p_id              STRING
DEFINE p_srv_list       DYNAMIC ARRAY OF RECORD
       name              LIKE type_file.chr50       #服務名稱
       END RECORD
DEFINE l_Request         STRING
DEFINE l_Result          STRING
DEFINE l_host_att        STRING
DEFINE l_status          LIKE type_file.num10
DEFINE l_i               LIKE type_file.num10
DEFINE l_node_list       om.NodeList
DEFINE l_node            om.DomNode   
DEFINE l_str             STRING



    #取得 CROSS 整合參數資料
    CALL aws_cross_wap()   

    #指定 pord 屬性值, 屬性間用逗號(,)區隔, 屬性名稱與內容值用 | 區隔
    LET l_host_att = "prod|", p_prod.trim(),",",
                     "ver|", p_ver.trim(),",",
                     "ip|", p_ip.trim(),",",
                     "id|", p_id.trim()

    #建立 Request XML Documene
    LET g_request_root = aws_cross_createRequest("", l_host_att)
  
    #將 XML 文件轉換成 String 字串
    LET l_Request = g_request_root.toString()

    #若 60 秒內無回應則放棄
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   

    #呼叫 CRSOOS, 查詢已註冊產品的服務清單
    CALL cross_getSrv(l_Request)  RETURNING l_status, l_Result

    #紀錄傳遞 CROSS XML 字串
    CALL aws_crosscli_logfile("getSrv",l_status,l_Request,l_Result)

    IF l_status != 0 THEN
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n",
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n", 
                   "  [Description]: ", wserror.description
       ELSE        
          LET l_str = "Connection failed: ", wserror.description
       END IF 
       CALL cl_err(l_str, '!', 1)   #連接失敗
       RETURN  FALSE
    END IF


    #取得 XML 字串的 Root Node
    LET g_response_root = aws_cross_stringToXml(l_Result)
    IF g_response_root IS NULL THEN
       CALL cl_err("Response isn't valid XML document","!",1)
       RETURN FALSE
    END IF

    # 尋找對應名稱的 tag  資料                                       
    LET g_code = aws_cross_getTagValue(g_response_root,"code","@chars")
    LET g_message = aws_cross_getTagValue(g_response_root,"message","@chars")

    CALL p_srv_list.clear()
    IF g_code = "093" THEN  #產品服務清單
       LET l_node_list = g_response_root.selectByTagName("srv")
       FOR l_i = 1 TO l_node_list.getLength()
           LET l_node = l_node_list.item(l_i)
           LET p_srv_list[l_i].name = l_node.getAttribute("name")
       END FOR  
    ELSE
       RETURN FALSE
    END IF

    RETURN TRUE

END FUNCTION


#[
# Description....: CROSS 整合參數資料
# Date & Author..: 2010/03/18 by Echo
# Parameter......: p_prod        - STRING     - 呼叫產品名稱 
# Return.........: TRUE/FALSE
# Memo...........: 
# Modify.........:
#
#]
FUNCTION aws_cross_war(p_prod)  
DEFINE p_prod            LIKE war_file.war03
DEFINE l_str             STRING

    INITIALIZE g_war TO NULL

    SELECT * INTO g_war.* FROM war_file 
     WHERE war01='E' AND war02= g_plant AND war03 = p_prod
    IF cl_null(g_war.war03) THEN 
       SELECT * INTO g_war.* FROM war_file 
        WHERE war01='S' AND war03 = p_prod
    END IF
    IF cl_null(g_war.war03) THEN
       CALL cl_err_msg("","aws-801",p_prod CLIPPED,10)
       RETURN FALSE
    END IF
    RETURN TRUE
END FUNCTION

#[
# Description....: CROSS 整合註冊產品站台資料
# Date & Author..: 2010/03/18 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_cross_wap()   
DEFINE l_str      STRING

    LET g_code = ""
    LET g_message = ""
    INITIALIZE g_wap TO NULL

    SELECT * INTO g_wap.* FROM wap_file

    LET l_str = g_wap.wap04 CLIPPED
    LET cross_IntegrationEntry_IntegrationEntryLocation  = l_str.subString(1,l_str.getIndexOf("?",1)-1)  #指定 Soap server location

    #取得 TIPTOP 版本
    LET g_tp_version =  cl_get_tp_version()

END FUNCTION


#[
# Description....: 建立 payload 的 param 資料
# Date & Author..: 2010/03/18 by Echo
# Parameter......: p_node   -    DomNode   - XML Dom 
#                : p_key    -    STRING    - 參數名稱
#                : p_type   -    STRING    - 參數型態
#                : p_text   -    STRING    - 內容值
# Return.........: p_pnode
# Memo...........:
# Modify.........:
#
#]
FUNCTION  aws_crosscli_param(p_node,p_key,p_type,p_text)
DEFINE p_node       om.DomNode
DEFINE p_key        STRING
DEFINE p_type       STRING
DEFINE p_text       STRING
DEFINE l_tnode      om.DomNode
DEFINE l_pnode      om.DomNode
      
       LET l_pnode = p_node.createChild("param")                     #建立 <parm>
       LET l_tnode = g_reqdoc.createChars(p_text.trim())
       CALL l_pnode.appendChild(l_tnode) 
       CALL l_pnode.setAttribute("key", p_key.trim())                
       CALL l_pnode.setAttribute("type", p_type.trim())

       RETURN p_node
END FUNCTION 

#[
# Description....: 建立 Request XML  Document
# Date & Author..: 2010/03/18 by Echo
# Parameter......: p_request_att  - STRING      - 增加 reqeust 的屬性, 利用 ","區分屬性， name與value值用"|"區隔
#                : p_host_att     - STRING      - 增加 host 屬性, 利用 ","區分屬性， name與value值用"|"區隔
# Return.........: l_request_root - DomNode     - Request XML Documene
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_cross_createRequest(p_request_att,p_host_att)   
DEFINE p_request_att          STRING
DEFINE p_host_att             STRING
DEFINE l_request_root         om.DomNode        #Request XML Dom Node
DEFINE l_node                 om.DomNode
DEFINE l_azp052               LIKE azp_file.azp052
DEFINE l_tok                  base.StringTokenizer
DEFINE l_str                  STRING
DEFINE l_name                 STRING
DEFINE l_value                STRING
DEFINE l_p                    LIKE type_file.num5
DEFINE l_sb                   base.StringBuffer
   


    LET g_reqdoc = om.DomDocument.create("request")     
    LET l_request_root = g_reqdoc.getDocumentElement()  
     
    IF NOT cl_null(p_request_att) THEN
       LET l_tok = base.StringTokenizer.createExt(p_request_att,",","",TRUE)
       WHILE l_tok.hasMoreTokens()
              LET l_str = l_tok.nextToken()
              LET l_p  = l_str.getIndexOf("|",1)
              IF l_p > 0 THEN
                 LET l_name = l_str.subString(1,l_p-1)
                 LET l_value = l_str.subString(l_p+1,l_str.getLength())
              ELSE    
                 LET l_name = l_str
              END IF
              CALL l_request_root.setAttribute(l_name,l_value)
        END WHILE
    END IF  

    #取得 TIPTOP 版本
    IF cl_null(g_tp_version) THEN
       LET g_tp_version =  cl_get_tp_version()
    END IF

    LET l_node = l_request_root.createChild("host")               #建立 <host>
    CALL l_node.setAttribute("prod", "TIPTOP")                    #產品名稱
    CALL l_node.setAttribute("ver", g_tp_version)                 #版本
    CALL l_node.setAttribute("ip", cl_get_tpserver_ip())          #IP位置
    CALL l_node.setAttribute("id", cl_get_env())                  #產品識別碼
    IF NOT cl_null(g_lang) THEN
       CALL l_node.setAttribute("lang", aws_cross_setLanguage())     #語系別
    END IF

    IF NOT cl_null(p_host_att) THEN
       LET l_tok = base.StringTokenizer.createExt(p_host_att,",","",TRUE)
       WHILE l_tok.hasMoreTokens()
              LET l_str = l_tok.nextToken()
              LET l_p  = l_str.getIndexOf("|",1)
              IF l_p > 0 THEN
                 LET l_name = l_str.subString(1,l_p-1)
                 LET l_value = l_str.subString(l_p+1,l_str.getLength())
              ELSE    
                 LET l_name = l_str
                 CASE l_name 
                   WHEN "timezone"
                        #抓取時區資料, 如 GMT+8 只取得 +8
                        SELECT azp052 INTO l_azp052  FROM azp_file WHERE azp01=g_plant
                        LET l_value = l_azp052 CLIPPED
                        LET l_value = l_value.subString(4,l_value.getLength())   
                   WHEN "acct"
                        LET l_value = g_user                       #登入使用者
                   WHEN "timestamp"
                        LET l_value = CURRENT YEAR TO FRACTION(3)  #時間截記
                        LET l_sb = base.StringBuffer.create()
                        CALL l_sb.append(l_value)
                        CALL l_sb.replace(":","",0)
                        CALL l_sb.replace(" ","",0)
                        CALL l_sb.replace("-","",0)
                        CALL l_sb.replace(".","",0)
                        LET l_value = l_sb.toString()
                        
                   OTHERWISE
                        LET l_value = ""
                 END CASE
              END IF
              CALL l_node.setAttribute(l_name,l_value)
        END WHILE
    END IF  

  
    #IF NOT cl_null(p_service_prod) THEN
    #   LET l_node = l_request_root.createChild("service")         #建立 <service>  
    #   CALL l_node.setAttribute("prod", p_service_prod CLIPPED)   #呼叫產品名稱
    #   CALL l_node.setAttribute("name", p_service_name CLIPPED)   #呼叫服務名稱
    #END IF

    RETURN l_request_root
END FUNCTION
 
#[
# Description....: 取得 XML 字串的 Root Node, 提供後續作業處理
# Date & Author..: 2011/03/21 by Echo
# Parameter......: p_xml  - STRING  - XML 字串
# Return.........: l_root - DomNode - XML Root Node
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_cross_stringToXml(p_xml)
DEFINE p_xml       STRING
DEFINE l_t_doc     om.DomDocument    #For String to Xml
DEFINE l_ch        base.Channel,
       l_xmlFile   STRING,
       l_root      om.DomNode
    
    
    IF cl_null(p_xml) THEN
       RETURN NULL
    END IF
 
    #--------------------------------------------------------------------------#
    # 建立 Dom Node                                                            #
    #--------------------------------------------------------------------------#
    LET l_t_doc = om.DomDocument.createFromString(p_xml.trim())  

    IF l_t_doc IS NOT NULL THEN
       INITIALIZE l_root TO NULL
       LET l_root = l_t_doc.getDocumentElement()
    END IF
    
    RETURN l_root
END FUNCTION

#[
# Description....: 依據 ERP 語言別代碼 mapping 轉換成 Request XML 指定的語言別
# Date & Author..: 2011/03/18 by Echo
# Parameter......: none
# Return.........: l_lang
# Memo...........:
# Modify.........:
#   
#]  
FUNCTION aws_cross_setLanguage()
DEFINE l_lang   STRING
          
    #目前定義 zh_TW(繁體), zh_CN(簡體), en(英文), vi(越南)
    CASE g_lang   
         WHEN "0"   LET l_lang = "zh_TW"   
         WHEN "1"   LET l_lang = "en"
         WHEN "2"   LET l_lang = "zh_CN"
         WHEN "4"   LET l_lang = "vi"
         #---------------------------------------------------------------------#
         # 有新語系需要對應時請擴充                                            #
         # 語系可參考 UNIX 'locale -a' 指令結果, e.x. 'zh_tw.big5' 則取 zh_tw  #
         #---------------------------------------------------------------------#
         
         OTHERWISE      LET l_lang = "en"   #當沒有任何對應時預設為英文
    END CASE
 
    RETURN l_lang

END FUNCTION

#[
# Description....: 取得 xml tag value值
# Date & Author..: 2011/03/18 by Echo
# Parameter......: p_xml       - DomNode    - XML Root Node 
#                : p_tag       - STRING     - Tag Name
#                : p_att_name  - STRING     - Attribute Name
# Return.........: l_lang
# Memo...........:
# Modify.........:
#   
#]  
FUNCTION aws_cross_getTagValue(p_xml,p_tag,p_att_name)
DEFINE p_xml             om.DomNode
DEFINE p_tag             STRING
DEFINE p_att_name        STRING
DEFINE l_value           STRING
DEFINE l_node_list       om.NodeList
DEFINE l_snode           om.DomNode
DEFINE ln_node           om.DomNode
DEFINE l_node            om.DomNode

    LET l_value = NULL

    LET p_tag = p_tag.trim()
    LET p_att_name = p_att_name.trim()

    LET l_node_list = p_xml.selectByTagName(p_tag)
    IF l_node_list.getLength() != 0 THEN
       LET l_snode = l_node_list.item(1)
       IF p_att_name = "@chars" THEN
          LET ln_node = l_snode.getFirstChild()
          IF ln_node IS NOT NULL THEN
             LET l_value = ln_node.getAttribute(p_att_name)
          END IF
       ELSE
          LET l_value = l_snode.getAttribute(p_att_name)
       END IF
    END IF
 
    RETURN l_value 
END FUNCTION


#[
# Description....: 記錄 XML 字串
# Date & Author..: 2011/03/18 by Echo
# Parameter......: p_method    - STRING     - Operation 名稱
#                : p_status    - STRING     - WebService 呼叫狀況
#                : p_request   - STRING     - Reqeust XML 字串
#                : p_response  - STRING     - Response XML 字串
# Return.........: none 
# Memo...........:
# Modify.........:
#   
#]  
FUNCTION aws_crosscli_logfile(p_method,p_status,p_request,p_response)
DEFINE p_method     STRING,
       p_status     STRING,
       p_request    STRING,
       p_response   STRING,
       l_file       STRING,
       l_pid        STRING,
       l_str        STRING,
       channel      base.Channel
    
    #記錄此次呼叫的 method name
    LET l_file = "aws_crosscli-", TODAY USING 'YYYYMMDD', ".log"
    LET channel = base.Channel.create()
 
    CALL channel.openFile(l_file,  "a")
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        
        #紀錄傳遞的 XML 字串
        LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL channel.write(l_str)
        CALL channel.write("")

        LET l_str = "Method: ", p_method CLIPPED
        CALL channel.write(l_str)
        CALL channel.write("")

        LET l_str = "Program: ", g_prog CLIPPED
        CALL channel.write(l_str)
        CALL channel.write("")

        CALL channel.write("Request XML:")
        CALL channel.write(p_request)
        CALL channel.write("")
        CALL channel.write("Response XML:")

        IF p_status = 0 THEN
           CALL channel.write(p_response)
        ELSE
           CALL channel.write("")
           IF fgl_getenv('FGLGUI') = '1' THEN
              LET l_str = "   Connection failed:\n\n",
                       "     [Code]: ", wserror.code, "\n",
                       "     [Action]: ", wserror.action, "\n",
                       "     [Description]: ", wserror.description
           ELSE
              LET l_str = "   Connection failed: ", wserror.description
           END IF
           CALL channel.write(l_str)
        END IF
        CALL channel.write("")
        
        CALL channel.write("#------------------------------------------------------------------------------#")
        CALL channel.write("")
        CALL channel.close()
 
        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009  
    ELSE
        DISPLAY "Can't open log file."
    END IF
END FUNCTION
