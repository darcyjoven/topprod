# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv_lib_xml.4gl
# Descriptions...: 處理 TIPTOP 服務 XML 交換資料的共用 FUNCTION
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-880046 08/08/12 by Echo Genero 2.11 調整
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_domDoc   DYNAMIC ARRAY OF om.DomDocument
 
 
#[
# Description....: 取得 XML 字串的 Root Node, 以利後續作業處理
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_xml - STRING - XML 字串
# Return.........: l_root - DomNode - XML Root Node
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_stringToXml(p_xml)
    DEFINE p_xml       STRING
    DEFINE l_ch        base.Channel,
           l_xmlFile   STRING,
           l_doc       om.DomDocument,
           l_root      om.DomNode
 
    
    WHENEVER ERROR CONTINUE
    
    IF cl_null(p_xml) THEN
       RETURN NULL
    END IF
    
    #--------------------------------------------------------------------------#
    # 產生 XML 暫存檔                                                          #
    #--------------------------------------------------------------------------#
    LET l_ch = base.Channel.create()
    LET l_xmlFile = fgl_getenv("TEMPDIR"), "/", 
                    "aws_ttsrv_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
    CALL l_ch.openFile(l_xmlFile, "w")
    CALL l_ch.setDelimiter("")       #FUN-880046
    CALL l_ch.write(p_xml)
    CALL l_ch.close()
    
    #--------------------------------------------------------------------------#
    # 讀取 XML 文件                                                            #
    #--------------------------------------------------------------------------#
    LET l_doc = om.DomDocument.createFromXmlFile(l_xmlFile)
    RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"
    INITIALIZE l_root TO NULL
    IF l_doc IS NOT NULL THEN
       LET l_root = l_doc.getDocumentElement()
    END IF
    
    RETURN l_root
END FUNCTION
 
 
#[
# Description....: 將 XML 文件轉換成 String 字串
# Date & Author..: 2007/02/14 by Echo
# Parameter......: p_xml - DomNode - XML Root Node
# Return.........: l_str - STRING - XML 字串
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_xmlToString(p_xml)
    DEFINE p_xml       om.DomNode
    DEFINE l_str       STRING,
           l_xmlFile   STRING,
           l_ch        base.Channel,
           l_buf       STRING,
           l_i         LIKE type_file.num10,
           l_sb        base.StringBuffer
 
    
    IF p_xml IS NULL THEN
       RETURN NULL
    END IF
 
    #--------------------------------------------------------------------------#
    # 產生 XML 暫存檔                                                          #
    #--------------------------------------------------------------------------#
    LET l_xmlFile = fgl_getenv("TEMPDIR"), "/", 
                    "aws_ttsrv_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
    CALL p_xml.writeXml(l_xmlFile)
    
    #--------------------------------------------------------------------------#
    # 將 XML 文件以字串方式傳回                                                #
    #--------------------------------------------------------------------------#    
    LET l_sb = base.StringBuffer.create()
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_xmlFile, "r")
    CALL l_ch.setDelimiter(NULL)
    LET l_i = 1
    WHILE l_ch.read(l_buf)
        IF l_i !=1 THEN
          CALL l_sb.append("\n")
        END IF
        CALL l_sb.append(l_buf CLIPPED)
        LET l_i = l_i + 1
    END WHILE
    CALL l_ch.close()
    
    RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"
 
    LET l_str = l_sb.toString()
 
    #LET l_str = aws_ttsrv_replaceValue(l_str)
 
    RETURN l_str
END FUNCTION
 
 
#[
# Description....: 依據傳入 Table Record 資料, 新增 XML DataSet 節點
# Date & Author..: 2007/02/14 by Echo
# Parameter......: p_record - DomNode - Table record XML node
#                : p_xml    - DomNode - <DataSet> XML node
#                : p_table  - STRING - 服務使用的 TABLE 名稱
# Return.........: p_xml    - DomNode - <DataSet> XML node
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_setDataSetRecord(p_record, p_xml, p_table)
    DEFINE p_record   om.DomNode,
           p_xml      om.DomNode,
           p_table    STRING
    DEFINE l_xml      om.DomNode
    DEFINE l_list     om.NodeList
    DEFINE l_list2    om.NodeList
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_k        LIKE type_file.num10
    DEFINE l_node     om.DomNode
    DEFINE l_node2    om.DomNode
    DEFINE l_child    om.DomNode,
           l_child2   om.DomNode
    DEFINE l_name     STRING,
           l_mname    STRING,
           l_value    STRING,
           l_rvalue   STRING
    DEFINE l_ref      LIKE type_file.num10
 
    IF p_record IS NULL OR cl_null(p_table) THEN
       RETURN p_xml
    END IF
       
    IF p_xml IS NULL THEN
       #-----------------------------------------------------------------------#
       # 建立 <DataSet> Node                                                   #
       #-----------------------------------------------------------------------#
       LET l_i = g_domDoc.getLength() + 1
       LET g_domDoc[l_i] = om.DomDocument.create("DataSet")
       LET p_xml = g_domDoc[l_i].getDocumentElement()
    END IF
 
    #--------------------------------------------------------------------------#
    # 依據目前已建立 Recrod 資料，按照順序給予識別碼流水號                     #
    #--------------------------------------------------------------------------# 
    LET l_list = p_xml.selectByTagName("Record")
    LET l_ref = l_list.getLength() + 1
    LET l_child = p_xml.createChild("Record")
    CALL l_child.setAttribute("ref", l_ref)
 
    #--------------------------------------------------------------------------#
    # 解析 Table 欄位 Record XML 資料, 組成回傳的 <DataSet> XML 節點           #
    # 若為單身, 可能為多筆資料, 則有多筆單身 Record 資料需要依序解析           #
    #--------------------------------------------------------------------------#
    LET l_list = p_record.selectByTagName("Record")
    FOR l_k = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_k)
        LET l_child2 = l_child.createChild("Field")
        
        LET l_list2 = l_node.selectByTagName("Field")
        FOR l_i = 1 TO l_list2.getLength()           
            LET l_node2 = l_list2.item(l_i)
           
            INITIALIZE l_name TO NULL
            INITIALIZE l_value TO NULL
            LET l_name = l_node2.getAttribute("name")
            LET l_value = l_node2.getAttribute("value")
           
            #取得服務對應的 TABLE, 其 ERP 欄位名稱相對應的整合系統欄位名稱
            LET l_mname = aws_ttsrv_getServiceErpToSysColumn(p_table, l_name)
            IF NOT cl_null(l_mname) THEN
               LET l_name = l_mname
            END IF
         
            CALL l_child2.setAttribute(l_name CLIPPED, l_value CLIPPED)
        END FOR
 
        #取得服務對應的 TABLE, 其 ERP 欄位的參考欄位值 
        LET l_child2 = aws_ttsrv_getReferenceValue(l_child2,p_table)
    END FOR
 
    RETURN p_xml
END FUNCTION
 
 
#[
# Description....: 由整合系統傳入的 DataSet XML 讀取欄位與欄位值
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: p_xml   - DomNode - XML Node (<DataSet> 中的 <Field> 節點)
#                : p_table - STRING - 服務使用的 TABLE 名稱
# Return.........: 
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_parseDataSetRecrodField(p_xml, p_table)
DEFINE p_xml      om.DomNode,
       p_table    STRING
DEFINE l_i        LIKE type_file.num10,
       l_list     om.NodeList,
       l_node     om.DomNode,
       l_name     STRING,
       l_value    STRING,
       l_mname    STRING
 
    
    IF p_xml IS NULL OR cl_null(p_table) THEN
       RETURN
    END IF
       
    LET l_list = p_xml.selectByTagName("Field")
    LET l_node = l_list.item(1)
    FOR l_i = 1 TO l_node.getAttributesCount()
        LET l_name = l_node.getAttributeName(l_i)
        LET l_value = l_node.getAttributeValue(l_i)
        
        #----------------------------------------------------------------------#
        # 檢查是否有 ERP 欄位 <---> 整合系統欄位的設定關係                     #
        #----------------------------------------------------------------------#
        LET l_mname = aws_ttsrv_getServiceSysToErpColumn(p_table, l_name)
        IF NOT cl_null(l_mname) THEN
           LET l_name = l_mname
        END IF
        
        #----------------------------------------------------------------------#
        # 檢查整合系統傳遞的欄位值長度, 再設定 g_field 欄位值                  #
        #----------------------------------------------------------------------#
        LET l_value = aws_ttsrv_checkDataValue(p_table, l_name, l_value) CLIPPED
        CALL aws_ttsrv_setServiceColumnValue(p_table, l_name, l_value)
        CALL aws_ttsrv_setServiceColumnParsed(p_table, l_name, "1")
     END FOR
END FUNCTION
 
 
#[
# Description....: 取得 <DataSet> XML 中對應某個 "ref" 流水號的 Record Node
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_xml  - DomNode - XML Root Node
#                : p_ref  - STRING - "ref" 屬性值                 
# Return.........: l_node - DomNode - XML Record Node
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getDataSetRefRecord(p_xml, p_ref)
    DEFINE p_xml    om.DomNode,
           p_ref    STRING
    DEFINE l_list   om.NodeList,
           l_node   om.DomNode,
           l_path   STRING
 
 
    IF p_xml IS NULL OR cl_null(p_ref) THEN
       RETURN NULL
    END IF
    
    #--------------------------------------------------------------------------#
    # 尋找 //Record[ref=x] 節點                                                #
    #--------------------------------------------------------------------------#
    INITIALIZE l_node TO NULL
    LET l_path = "//Record[@ref=\"", p_ref CLIPPED, "\"]"
    LET l_list = p_xml.selectByPath(l_path)
    IF l_list.getLength() != 0 THEN
       LET l_node = l_list.item(1)
    END IF
    
    RETURN l_node
END FUNCTION
 
 
#[
# Description....: 建立處理失敗的 <DataSet> 其 <Record> 資料
# Date & Author..: 2007/02/14 by Echo
# Parameter......: p_record - DomNode - 新增(or 更新)失敗的 <DataSet> 的 <Record> 節點
#                : p_xml    - DomNode - 新增(or 更新)失敗的 Record XML
# Return.........: p_xml    - DomNode - 新增(or 更新)失敗的 Record XML
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_setFailedDataSetRecord(p_record, p_xml)
    DEFINE p_record   om.DomNode,
           p_xml      om.DomNode
    DEFINE l_i        LIKE type_file.num10
 
    
    IF p_record IS NULL THEN
       RETURN p_xml
    END IF
    
    IF p_xml IS NULL THEN
       #-----------------------------------------------------------------------#
       # 建立 DataSet Node 主要為存放回傳的資料                                #
       #-----------------------------------------------------------------------#
       LET l_i = g_domDoc.getLength() + 1
       LET g_domDoc[l_i] = om.DomDocument.create("DataSet")
       LET p_xml = g_domDoc[l_i].getDocumentElement()
    END IF
 
    #--------------------------------------------------------------------------#
    # 將新增(or 更新)失敗的 Record 新增至回傳資料的 XML 裡                     #
    #--------------------------------------------------------------------------#
    CALL p_xml.appendChild(g_domDoc[l_i].copy(p_record, 1))
 
    RETURN p_xml
END FUNCTION
