# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: sapcq300_xml_sub.4gl
# Descriptions...: Webservice xml解析
# Date & Author..: No.FUN-C70116 12/07/31 By suncx
# Modify.........: No.FUN-C70116 12/07/31 By suncx 新增程序
# Modify.........: No.FUN-D10095 13/01/29 By baogc XML格式调整
# Modify.........: No.FUN-D40052 13/04/15 By xumm 防止程序当掉

IMPORT XML
DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION sapcq300_xml_process(p_request)
DEFINE p_request         STRING 
DEFINE lx_reqdoc         xml.DomDocument
DEFINE lx_node_list      xml.DomNodeList
DEFINE lx_tnode          xml.DomNode
DEFINE lx_pnode          xml.DomNode
DEFINE l_xml             STRING
DEFINE l_i               LIKE type_file.num10

    WHENEVER ERROR CONTINUE   #FUN-D40052  Add

    IF cl_null(p_request) THEN
       RETURN NULL 
    END IF

    #尋找對應名稱的 payload  CDATA section 包覆的 XML 資料
    LET lx_reqdoc = xml.DomDocument.Create()
    CALL lx_reqdoc.loadFromString(p_request)
    IF lx_reqdoc.getErrorsCount() > 0 THEN
       RETURN NULL
    END IF

    LET lx_node_list = lx_reqdoc.getElementsByTagName("service")
    IF lx_node_list.getCount() > 0 THEN
       LET lx_node_list = lx_reqdoc.getElementsByTagName("payload")
       LET lx_pnode = lx_node_list.getitem(1)
       LET lx_tnode = lx_pnode.getFirstChild()
       LET l_xml = lx_tnode.getNodeValue()
    END IF

    RETURN l_xml

END FUNCTION
#[
# Description....: 取得 Request XML <Parameter> 節點中指定的欄位
# Parameter......: p_name  - STRING - 欄位名稱
# Return.........: l_value - STRING - 欄位值
#
#]
FUNCTION sapcq300_xml_getParameter(p_request_root,p_name)
    DEFINE p_request_root om.DomNode,
           p_name         STRING
    DEFINE l_list         om.NodeList
    DEFINE l_node         om.DomNode
    DEFINE l_value        STRING
    
    
    INITIALIZE l_value TO NULL
    
    IF cl_null(p_name) THEN
       RETURN NULL
    END IF
    
    #--------------------------------------------------------------------------#
    # 搜尋 <Parameter> 是否有指定名稱的欄位                                    #
    #--------------------------------------------------------------------------#
    LET l_list = p_request_root.selectByPath("//Parameter/Record/Field[@name=\"" || p_name CLIPPED || "\"]")
    IF l_list.getLength() != 0 THEN
       LET l_node = l_list.item(1)
       LET l_value = l_node.getAttribute("value")
    END IF
    
    #--------------------------------------------------------------------------#
    # Special Case : 若是找 SQL Where Condition 則 Request 無指定時需給預設值  #
    #--------------------------------------------------------------------------#
    IF p_name CLIPPED = "condition" AND cl_null(l_value) THEN
       LET l_value = " 1=1 "
    END IF
    
    RETURN l_value
END FUNCTION
 
 
#[
# Description....: 取得 Request XML <Document> 節點中的單檔筆數個數
# Parameter......: p_name - STRING  - 單檔名稱
# Return.........: l_cnt  - INTEGER - 單檔筆數
#]
FUNCTION sapcq300_xml_getMasterRecordLength(p_request_root,p_name)
    DEFINE p_request_root om.DomNode,
           p_name         STRING
    DEFINE l_list         om.NodeList
    DEFINE l_cnt          INTEGER
    
    
    #--------------------------------------------------------------------------#
    # 搜尋 <Document> 有多少筆對應的 <Master> 節點                             #
    #--------------------------------------------------------------------------#
    IF cl_null(p_name) THEN
       LET l_list = p_request_root.selectByPath("//Document/RecordSet/Master")     
    ELSE
       LET l_list = p_request_root.selectByPath("//Document/RecordSet/Master[@name=\"" || p_name || "\"]")    
    END IF
    
    LET l_cnt = l_list.getLength()
    RETURN l_cnt
END FUNCTION
 
#FUN-C70116 
 
#[
# Description....: 取得 Request XML <Document> 節點中的單身筆數個數
# Parameter......: p_node - om.DomNode - 目前處理的單頭節點
#                : p_name - STRING     - 單身名稱
# Return.........: l_cnt  - INTEGER    - 單身筆數
#]
FUNCTION sapcq300_xml_getDetailRecordLength(p_node)
    DEFINE p_node    om.DomNode,
           p_name    STRING
    DEFINE l_list    om.NodeList
    DEFINE l_node    om.DomNode
    DEFINE l_cnt     INTEGER
    
    
    IF p_node IS NULL THEN
       RETURN 0
    END IF
    
    LET l_node = p_node.getParent()   #從 <Record> 取 <Master> 父節點
    LET l_node = l_node.getParent()   #再從 <Master> 取 <RecordSet> 父節點
    
    #--------------------------------------------------------------------------#
    # 搜尋 <RecordSet> 有對應的 <Detail> 節點                                  #
    #--------------------------------------------------------------------------#
    LET l_list = l_node.selectByPath("//Detail")     
    
    LET l_cnt = l_list.getLength()
    RETURN l_cnt
END FUNCTION
 
 
#[
# Description....: 取得 Request XML 中指定的單檔節點 Dom Node
# Date & Author..: 2008/03/04 by Brendan
# Parameter......: p_i    - INTEGER    - 第 N 筆單檔
#                : p_name - STRING     - 單檔名稱
# Return.........: l_node - om.DomNode - 第 N 筆單檔的 Dom Node
#]
FUNCTION sapcq300_xml_getMasterRecord(p_request_root,p_i, p_name)
    DEFINE p_request_root om.DomNode,
           p_i            INTEGER,
           p_name         STRING
    DEFINE l_list         om.NodeList
    DEFINE l_i            INTEGER
    DEFINE l_node         om.DomNode
    
    
    IF cl_null(p_i) OR p_i = 0 THEN
       RETURN NULL
    END IF
    
    IF cl_null(p_name) THEN
       LET l_list = p_request_root.selectByPath("//Document/RecordSet/Master")     
    ELSE
       LET l_list = p_request_root.selectByPath("//Document/RecordSet/Master[@name=\"" || p_name || "\"]")    
    END IF
    FOR l_i = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_i)
        
        #----------------------------------------------------------------------#
        # 若搜尋的 <Master> 節點順序與呼叫時傳入的值相同時                     #
        #----------------------------------------------------------------------#
        IF l_i = p_i THEN
           LET l_node = l_node.getFirstChild()     #往下取得 <Record> 節點回傳
           IF l_node.getTagName() = "@chars" THEN  #需要特別判斷抓到的第一個子節點是否為 Text Node
              LET l_node = l_node.getNext()
           END IF
           EXIT FOR
        END IF
    END FOR
 
    RETURN l_node
END FUNCTION
 
 
#[
# Description....: 取得 Request XML 中指定的單身節點 Dom Node
# Parameter......: p_node - om.DomNode - 目前單檔資料節點
#                : p_i    - INTEGER    - 第 N 筆單身
#                : p_name - STRING     - 單身名稱
# Return.........: l_node - om.DomNode - 第 N 筆單身的 Dom Node
#]
FUNCTION sapcq300_xml_getDetail(p_node, p_i)
    DEFINE p_node    om.DomNode,
           p_i       INTEGER,
           p_name    STRING
    DEFINE l_node1   om.DomNode,
           l_node2   om.DomNode
    DEFINE l_list    om.NodeList
    DEFINE l_i       INTEGER
    
    
    IF p_node IS NULL OR ( cl_null(p_i) OR p_i = 0 ) THEN
       RETURN NULL
    END IF
 
    LET l_node1 = p_node.getParent()    #取 <Master> 父節點
    LET l_node1 = l_node1.getParent()   #取 <RecordSet> 父節點
    
    LET l_list = l_node1.selectByPath("//Detail")     
    FOR l_i = 1 TO l_list.getLength()
        LET l_node2 = l_list.item(l_i)
        
        #----------------------------------------------------------------------#
        # 若搜尋的單身 <Record> 節點順序與呼叫時傳入的值相同時                 #
        #----------------------------------------------------------------------#
        IF l_i = p_i THEN
           EXIT FOR
        END IF
    END FOR
 
    RETURN l_node2
END FUNCTION

FUNCTION sapcq300_xml_getDetailRecordField(p_node,p_name)
    DEFINE p_node    om.DomNode,
           p_name    STRING
    DEFINE l_node    om.DomNode
    DEFINE l_list    om.NodeList
    DEFINE l_value   STRING

    IF p_node IS NULL OR cl_null(p_name) THEN
       RETURN NULL
    END IF
    
    LET l_list = p_node.selectByPath("//Record")
    IF l_list.getLength() != 0 THEN   #找的到節點才取值
        LET l_node = l_list.item(1)
        LET l_value = sapcq300_xml_getRecordField(l_node,p_name)
    END IF
    
    RETURN l_value
END FUNCTION 
 
#[
# Description....: 取得指定的 單頭 / 單身 節點中的欄位值
# Parameter......: p_node  - om.DomNode - 單頭 / 單身 節點
#                : p_name  - STRING     - 欄位名稱
# Return.........: l_value - STRING     - 欄位值
#]
FUNCTION sapcq300_xml_getRecordField(p_node, p_name)
    DEFINE p_node    om.DomNode,
           p_name    STRING
    DEFINE l_value   STRING
    DEFINE l_list    om.NodeList
    DEFINE l_node    om.DomNode
        
    
    IF p_node IS NULL OR cl_null(p_name) THEN
       RETURN NULL
    END IF
    
    #--------------------------------------------------------------------------#
    # 接著尋找是否為對應名稱的 <Field> 欄位                                    #
    #--------------------------------------------------------------------------#
    LET l_list = p_node.selectByPath("//Field[@name=\"" || p_name || "\"]")
    IF l_list.getLength() != 0 THEN   #找的到節點才取值
       LET l_node = l_list.item(1)
       LET l_value = l_node.getAttribute("value")
    END IF
    
    RETURN l_value
END FUNCTION
 
#[
# Description....: 取得 XML 字串的 Root Node, 提供後續作業處理
# Parameter......: p_xml  - STRING  - XML 字串
# Return.........: l_root - DomNode - XML Root Node
#]
FUNCTION sapcq300_xml_stringToXml(p_xml)
    DEFINE p_xml       STRING
    DEFINE l_ch        base.Channel,
           l_xmlFile   STRING,
           l_root      om.DomNode
    DEFINE g_t_doc     om.DomDocument
    
    IF cl_null(p_xml) THEN
       RETURN NULL
    END IF
 
    #--------------------------------------------------------------------------#
    # String to XML 暫存檔                                                     #
    #--------------------------------------------------------------------------#
    LET l_ch = base.Channel.create()
    LET l_xmlFile = fgl_getenv("TEMPDIR"), "/", "sapcq300_xml_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
    CALL l_ch.openFile(l_xmlFile, "w")
    CALL l_ch.setDelimiter("")     
    CALL l_ch.write(p_xml)
    CALL l_ch.close()
    
    #--------------------------------------------------------------------------#
    # 讀取 XML File 建立 Dom Node                                              #
    #--------------------------------------------------------------------------#
    LET g_t_doc = om.DomDocument.createFromXmlFile(l_xmlFile)   #用 module variable 才可以後續建立節點( createChild() ...)
    RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"
    INITIALIZE l_root TO NULL
    IF g_t_doc IS NOT NULL THEN
       LET l_root = g_t_doc.getDocumentElement()
    END IF
    
    RETURN l_root
END FUNCTION

#獲取Connection下資訊
FUNCTION sapcq300_xml_get_ConnectionMsg(p_xml,p_name)
    DEFINE p_xml     om.DomNode,
           p_name    STRING 
    DEFINE l_list    om.NodeList,
           l_node    om.DomNode
    DEFINE l_return  STRING                #返回值
    #--------------------------------------------------------------------------#
    # 讀取 Access下Guid資訊                               #
    #--------------------------------------------------------------------------#
    LET l_list = p_xml.selectByPath("//Access/Connection")
    IF l_list.getLength() != 0 THEN          
       LET l_node = l_list.item(1)
       LET l_return = l_node.getAttribute(p_name)
    END IF
    RETURN l_return 
END FUNCTION 

#FUN-D10095 Add Begin ---
FUNCTION sapcq300_xml_getTreeMasterRecordLength(p_request_root,p_name)
    DEFINE p_request_root om.DomNode
    DEFINE p_name         STRING
    DEFINE l_list         om.NodeList
    DEFINE l_cnt          INTEGER
    
    #--------------------------------------------------------------------------#
    # 搜尋 <Document> 有多少筆對應的 <Master> 節點                             #
    #--------------------------------------------------------------------------#
    IF cl_null(p_name) THEN
       LET l_list = p_request_root.selectByPath("//Document/Master/Record")
    ELSE
       LET l_list = p_request_root.selectByPath("//Document/Master[@name=\"" || p_name || "\"]/Record")
    END IF

    LET l_cnt = l_list.getLength()
    RETURN l_cnt
END FUNCTION

FUNCTION sapcq300_xml_getTreeMasterRecord(p_request_root,p_i, p_name)
    DEFINE p_request_root om.DomNode
    DEFINE p_i            INTEGER,
           p_name         STRING
    DEFINE l_list         om.NodeList
    DEFINE l_i            INTEGER
    DEFINE l_node         om.DomNode


    IF cl_null(p_i) OR p_i = 0 THEN
       RETURN NULL
    END IF

    IF cl_null(p_name) THEN
       LET l_list = p_request_root.selectByPath("//Document/Master")
    ELSE
       LET l_list = p_request_root.selectByPath("//Document/Master[@name=\"" || p_name || "\"]/Record")
    END IF
    FOR l_i = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_i)

        #----------------------------------------------------------------------#
        # 若搜尋的 <Master> 節點順序與呼叫時傳入的值相同時                     #
        #----------------------------------------------------------------------#
        IF l_i = p_i THEN
           LET l_node = l_node.getFirstChild()     #往下取得 <Record> 節點回傳
           IF l_node.getTagName() = "@chars" THEN  #需要特別判斷抓到的第一個子節點是否為 Text Node
              LET l_node = l_node.getNext()
           END IF
           EXIT FOR
        END IF
    END FOR
    
    LET l_node = l_node.getParent()
    RETURN l_node
END FUNCTION

FUNCTION sapcq300_xml_getTreeRecordLength(p_node, p_name)
    DEFINE p_node    om.DomNode,
           p_name    STRING
    DEFINE l_list    om.NodeList
    DEFINE l_cnt     INTEGER

    IF p_node IS NULL THEN
       RETURN 0
    END IF

    #--------------------------------------------------------------------------#
    # 搜尋 <Detail> 節點                                                       #
    #--------------------------------------------------------------------------#
    IF cl_null(p_name) THEN
       LET l_list = p_node.selectByPath("//Detail/Record")
    ELSE
       LET l_list = p_node.selectByPath("//Detail[@name=\"" || p_name || "\"]/Record")
    END IF
          
    LET l_cnt = l_list.getLength()
    RETURN l_cnt
END FUNCTION

FUNCTION sapcq300_xml_getTreeRecord(p_node, p_i, p_name)
    DEFINE p_node    om.DomNode,
           p_i       INTEGER,
           p_name    STRING
    DEFINE l_node1   om.DomNode,
           l_node2   om.DomNode
    DEFINE l_list    om.NodeList
    DEFINE l_i       INTEGER

    
    IF p_node IS NULL OR ( cl_null(p_i) OR p_i = 0 ) THEN
       RETURN NULL
    END IF
    
    IF cl_null(p_name) THEN
       LET l_list = p_node.selectByPath("//Detail/Record")
    ELSE
       LET l_list = p_node.selectByPath("//Detail[@name=\"" || p_name || "\"]/Record")
    END IF
    
    FOR l_i = 1 TO l_list.getLength()
        LET l_node2 = l_list.item(l_i)
        
        #----------------------------------------------------------------------#
        # 若搜尋的單身 <Record> 節點順序與呼叫時傳入的值相同時                 #
        #----------------------------------------------------------------------#
        IF l_i = p_i THEN
           EXIT FOR
        END IF
    END FOR
    
    RETURN l_node2

END FUNCTION
#FUN-D10095 Add End -----

