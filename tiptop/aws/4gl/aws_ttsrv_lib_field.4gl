# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv_lib_field.4gl
# Descriptions...: 處理 TIPTOP 服務 TABLE 欄位的共用 FUNCTION
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_map   DYNAMIC ARRAY OF RECORD  #為加速欄位對應關係的尋找
                  table     STRING,
                  erpName   STRING,
                  sysName   STRING
               END RECORD
 
 
#[
# Description....: 取得服務對應的 TABLE, 其欄位名稱與設定的預設值
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_wsn01 - CHAR - 服務名稱
# Return.........: TRUE / FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getServiceColumn(p_wsn01)
    DEFINE p_wsn01      LIKE wsn_file.wsn01
    DEFINE l_wsn02      LIKE wsn_file.wsn02
    DEFINE l_col        RECORD
                           wsn03 LIKE wsn_file.wsn03,
                           wsn04 LIKE wsn_file.wsn04,
                           wso05 LIKE wso_file.wso05,
                           wsp05 LIKE wsp_file.wsp05
                        END RECORD,
           l_doc        om.DomDocument,
           l_table      om.DomNode,
           l_field      om.DomNode,
           l_wso03      LIKE wso_file.wso03,
           l_i          LIKE type_file.num10
    
    
    WHENEVER ERROR CONTINUE
 
    IF cl_null(p_wsn01) THEN
       RETURN FALSE
    END IF      
           
    #--------------------------------------------------------------------------#
    # 建立 g_field 服務欄位 XML 節點                                           #
    #--------------------------------------------------------------------------#
    LET l_doc = om.DomDocument.create("Service")
    LET g_field = l_doc.getDocumentElement()
    CALL g_field.setAttribute("name", p_wsn01 CLIPPED)
 
    DECLARE t_curs CURSOR FOR SELECT UNIQUE wsn02 FROM wsn_file WHERE wsn01 = p_wsn01
    IF SQLCA.SQLCODE THEN
        LET g_status.sqlcode = SQLCA.SQLCODE
        RETURN FALSE
    END IF
 
    LET l_wso03 = g_signIn.systemId
    DECLARE f_curs CURSOR FOR
      SELECT wsn03, wsn04, wso05, wsp05 FROM wsn_file, OUTER wso_file, OUTER wsp_file 
       WHERE wsn01 = ? AND wsn02 = ? AND 
             wsn01 = wso_file.wso01 AND wsn02 = wso_file.wso02 AND wso_file.wso03 = ? AND wsn03 = wso_file.wso04 AND
             wsn01 = wsp_file.wsp01 AND wsn02 = wsp_file.wsp02 AND wsp_file.wsp03 = ? AND wsn03 = wsp_file.wsp04
 
    IF SQLCA.SQLCODE THEN
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN FALSE
    END IF
    
    LET l_i = 1
    CALL g_map.clear()
    FOREACH t_curs INTO l_wsn02
        LET l_table = g_field.createChild("Table")
        CALL l_table.setAttribute("name", l_wsn02 CLIPPED)
        
        FOREACH f_curs USING p_wsn01, l_wsn02, l_wso03, l_wso03 INTO l_col.*
            LET l_field = l_table.createChild("Column")
            CALL l_field.setAttribute("name", l_col.wsn03 CLIPPED)
            CALL l_field.setAttribute("value", "")
            CALL l_field.setAttribute("default", l_col.wsn04 CLIPPED)
            CALL l_field.setAttribute("mapName", l_col.wso05 CLIPPED)
            CALL l_field.setAttribute("refSQL", l_col.wsp05 CLIPPED)
            CALL l_field.setAttribute("parsed", "0")
 
            IF NOT cl_null(l_col.wso05) THEN
               LET g_map[l_i].table = l_wsn02 CLIPPED
               LET g_map[l_i].erpName = l_col.wsn03 CLIPPED
               LET g_map[l_i].sysName = l_col.wso05 CLIPPED
               LET l_i = l_i + 1
            END IF
                
            CASE l_col.wsn04 CLIPPED
                 #-----------------------------------------------------------------#
                 # 當預設值指定為 $USER 時, 欄位值自動帶入服務登入使用者           #
                 #-----------------------------------------------------------------#
                 WHEN "$USER"
                      CALL l_field.setAttribute("default", g_signIn.userId CLIPPED)
                  
                 #-----------------------------------------------------------------#
                 # 當預設值指定為 $TODAY 時, 欄位值自動帶入系統今日日期            #
                 #-----------------------------------------------------------------#
                 WHEN "$TODAY"
                      CALL l_field.setAttribute("default", TODAY USING 'YYYY/MM/DD')
            END CASE
        END FOREACH
    END FOREACH
    
    RETURN TRUE
END FUNCTION
 
 
#[
# Description....: 取得服務對應的 TABLE, 其 ERP 欄位名稱相對應的整合系統欄位名稱
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_table   - STRING - 服務所使用的 TABLE 名稱
#                : p_field   - STRING - ERP 欄位名稱
# Return.........: l_mapName - STRING - 對應欄位名稱
# Memo...........: 
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getServiceErpToSysColumn(p_table, p_field)
    DEFINE p_table     STRING,
           p_field     STRING
    DEFINE l_mapName   STRING,
           l_path      STRING, 
           l_list      om.NodeList,
           l_node      om.DomNode,
           l_i         LIKE type_file.num10
 
    
    IF cl_null(p_table) OR cl_null(p_field) OR g_field IS NULL OR g_map.getLength() = 0 THEN
       RETURN NULL
    END IF
    
    INITIALIZE l_mapName TO NULL
 
    #--------------------------------------------------------------------------#
    # 尋找 XML 節點: TABLE[name=xxx]/Column[name=xxx]                          #
    #--------------------------------------------------------------------------#
    FOR l_i = 1 TO g_map.getLength()
        IF g_map[l_i].table = p_table CLIPPED AND g_map[l_i].erpName = p_field CLIPPED THEN
           LET l_mapName = g_map[l_i].sysName
           EXIT FOR
        END IF
    END FOR 
#    LET l_path = "//Table[@name=\"", p_table CLIPPED, "\"]/Column[@name=\"", p_field CLIPPED, "\"]"
#    LET l_list = g_field.selectByPath(l_path)
#    IF l_list.getLength() != 0 THEN
#       LET l_node = l_list.item(1)
#       IF l_node IS NOT NULL THEN
#          LET l_mapName = l_node.getAttribute("mapName")
#       END IF
#    END IF
    RETURN l_mapName
END FUNCTION
 
 
#[
# Description....: 取得服務對應的 TABLE, 其 ERP 欄位的參考欄位值
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_xml   - DomNode - <Field> XML Node
#                : p_table - STRING - 服務所使用的 TABLE 名稱
# Return.........: l_xml   - DomNode - <Field> XML Node
# Memo...........:  
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getReferenceValue(p_xml,p_table)
    DEFINE p_xml       om.DomNode,
           p_table     STRING
    DEFINE l_xml       om.DomNode,
           l_field     STRING,
           l_value     STRING,
           l_refValue  LIKE type_file.chr1000, 
           l_refSQL    STRING,
           l_path      STRING, 
           l_list      om.NodeList,
           l_node      om.DomNode,
           l_i         LIKE type_file.num10,
           l_k         LIKE type_file.num10
    DEFINE l_p1        LIKE type_file.num10,
           l_p2        LIKE type_file.num10,
           l_str       STRING
    
    
    INITIALIZE l_refSQL TO NULL
    INITIALIZE l_refValue TO NULL
 
    LET l_xml =  p_xml
 
    FOR l_i = 1 TO p_xml.getAttributesCount()
        LET l_field = p_xml.getAttributeName(l_i)
        LET l_value = p_xml.getAttributeValue(l_i)
 
        #--------------------------------------------------------------------------#
        # 尋找 XML 節點: TABLE[name=xxx]/Column[name=xxx]                          #
        #--------------------------------------------------------------------------#
        LET l_path = "//Table[@name=\"", p_table CLIPPED, "\"]/Column[@name=\"", l_field CLIPPED, "\"]"
        LET l_list = g_field.selectByPath(l_path)
        IF l_list.getLength() != 0 THEN
           LET l_node = l_list.item(1)
           IF l_node IS NOT NULL THEN
              LET l_refSQL = l_node.getAttribute("refSQL")
              IF NOT cl_null(l_refSQL) THEN
                 #-----------------------------------------------------------------#
                 # 尋找 ${xxxx} 字串，並將此字串轉換成欄位值                       #
                 #-----------------------------------------------------------------#
                 LET l_k = 1
                 LET l_p1 = l_refSQL.getIndexOf('${',1)
                 IF l_p1 > 0 THEN
                    WHILE l_k <= l_refSQL.getLength()
                        LET l_p1 = l_refSQL.getIndexOf('${',l_k)
                        IF l_p1 = 0 THEN
                           EXIT WHILE
                        END IF
                        LET l_p2 = l_refSQL.getIndexOf('}',l_k+2)
                        IF l_p2 = 0 THEN
                           RETURN NULL
                        END IF
                        LET l_str = p_xml.getAttribute(l_refSQL.subString(l_p1+2,l_p2-1))
                        LET l_str = "'",l_str,"'"
                        LET l_refSQL = cl_replace_str(l_refSQL, l_refSQL.subString(l_p1,l_p2), l_str)
                        LET l_k = l_p2 + 1
                    END WHILE
                    PREPARE ref_prepare FROM l_refSQL
                    IF SQLCA.sqlcode THEN
                       RETURN NULL
                    END IF
        
                    DECLARE ref_cs CURSOR FOR ref_prepare
                    OPEN ref_cs
                    FETCH ref_cs INTO l_refValue
                    IF SQLCA.sqlcode THEN
                       RETURN NULL
                    END IF   
                    CLOSE ref_cs
                    LET l_value = l_value,"|",l_refValue CLIPPED             
                 END IF
              END IF
           END IF
        END IF
        IF NOT cl_null(l_value) THEN
           CALL l_xml.setAttribute(l_field CLIPPED, l_value CLIPPED)
        END IF
    END FOR
    
    RETURN l_xml
END FUNCTION
 
#[
# Description....: 取得服務對應的 TABLE, 其整合系統欄位名稱相對應的 ERP 欄位名稱
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_table   - STRING - 服務所使用的 TABLE 名稱
#                : p_field   - STRING - 整合系統欄位名稱
# Return.........: l_mapName - STRING - 對應欄位名稱
# Memo...........: 
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getServiceSysToErpColumn(p_table, p_field)
    DEFINE p_table   STRING,
           p_field   STRING
    DEFINE l_name    STRING,
           l_path    STRING, 
           l_list    om.NodeList,
           l_node    om.DomNode,
           l_i       LIKE type_file.num10
 
    
    IF cl_null(p_table) OR cl_null(p_field) OR g_field IS NULL OR g_map.getLength() = 0 THEN
       RETURN NULL
    END IF
    
    INITIALIZE l_name TO NULL
 
    #--------------------------------------------------------------------------#
    # 尋找 XML 節點: TABLE[name=xxx]/Column[mapName=xxx]                       #
    #--------------------------------------------------------------------------#
    FOR l_i = 1 TO g_map.getLength()
        IF g_map[l_i].table = p_table CLIPPED AND g_map[l_i].sysName = p_field CLIPPED THEN
           LET l_name = g_map[l_i].erpName
           EXIT FOR
        END IF
    END FOR
#    LET l_path = "//Table[@name=\"", p_table CLIPPED, "\"]/Column[@mapName=\"", p_field CLIPPED, "\"]"
#    LET l_list = g_field.selectByPath(l_path)
#    IF l_list.getLength() != 0 THEN
#       LET l_node = l_list.item(1)
#       IF l_node IS NOT NULL THEN
#          LET l_name = l_node.getAttribute("name")
#       END IF
#    END IF
    
    RETURN l_name
END FUNCTION
 
 
#[
# Description....: 取得服務對應的 TABLE 其欄位值
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_table - STRING - 服務所使用的 TABLE 名稱
#                : p_field - STRING - ERP 欄位名稱
# Return.........: l_value - STRING - 回傳欄位值 
# Memo...........: 
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getServiceColumnValue(p_table, p_field)
    DEFINE p_table   STRING,
           p_field   STRING
    DEFINE l_value   STRING,
           l_path    STRING, 
           l_list    om.NodeList,
           l_node    om.DomNode
 
    
    IF cl_null(p_table) OR cl_null(p_field) OR g_field IS NULL THEN
       RETURN NULL
    END IF
    
    INITIALIZE l_value TO NULL
 
    #--------------------------------------------------------------------------#
    # 尋找 XML 節點: TABLE[name=xxx]/Column[name=xxx]                          #
    #--------------------------------------------------------------------------# 
    LET l_path = "//Table[@name=\"", p_table CLIPPED, "\"]/Column[@name=\"", p_field CLIPPED, "\"]"
    LET l_list = g_field.selectByPath(l_path)
    IF l_list.getLength() != 0 THEN
       LET l_node = l_list.item(1)
       IF l_node IS NOT NULL THEN
          LET l_value = l_node.getAttribute("value")
       END IF
    END IF
    RETURN l_value
END FUNCTION
 
 
#[
# Description....: 設定服務對應的 TABLE 其欄位值
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_table - STRING - 服務所使用的 TABLE 名稱
#                : p_field - STRING - ERP 欄位名稱
#                : p_value - STRING - 欄位值
# Return.........: none 
# Memo...........: 
# Modify.........:
#
#]
FUNCTION aws_ttsrv_setServiceColumnValue(p_table, p_field, p_value)
    DEFINE p_table   STRING,
           p_field   STRING,
           p_value   STRING
    DEFINE l_path    STRING, 
           l_list    om.NodeList,
           l_node    om.DomNode
 
    
    IF cl_null(p_table) OR cl_null(p_field) OR g_field IS NULL THEN
       RETURN
    END IF
    
    #--------------------------------------------------------------------------#
    # 尋找 XML 節點: TABLE[name=xxx]/Column[name=xxx]                          #
    #--------------------------------------------------------------------------#
    LET l_path = "//Table[@name=\"", p_table CLIPPED, "\"]/Column[@name=\"", p_field CLIPPED, "\"]"
    LET l_list = g_field.selectByPath(l_path)
    IF l_list.getLength() != 0 THEN
       LET l_node = l_list.item(1)
       IF l_node IS NOT NULL THEN
          CALL l_node.setAttribute("value", p_value CLIPPED)
       END IF
    END IF
END FUNCTION
 
 
#[
# Description....: 設定服務對應的 TABLE 其欄位是否被處理過
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_table - STRING - 服務所使用的 TABLE 名稱
#                : p_field - STRING - ERP 欄位名稱
#                : p_value - STRING - 欄位值
# Return.........: none 
# Memo...........: 
# Modify.........:
#
#]
FUNCTION aws_ttsrv_setServiceColumnParsed(p_table, p_field, p_value)
    DEFINE p_table   STRING,
           p_field   STRING,
           p_value   STRING
    DEFINE l_path    STRING, 
           l_list    om.NodeList,
           l_node    om.DomNode
 
    
    IF cl_null(p_table) OR cl_null(p_field) OR g_field IS NULL THEN
       RETURN
    END IF
    
    #--------------------------------------------------------------------------#
    # 尋找 XML 節點: TABLE[name=xxx]/Column[name=xxx]                          #
    #--------------------------------------------------------------------------#
    LET l_path = "//Table[@name=\"", p_table CLIPPED, "\"]/Column[@name=\"", p_field CLIPPED, "\"]"
    LET l_list = g_field.selectByPath(l_path)
    IF l_list.getLength() != 0 THEN
       LET l_node = l_list.item(1)
       IF l_node IS NOT NULL THEN
          CALL l_node.setAttribute("parsed", p_value CLIPPED)
       END IF
    END IF
END FUNCTION
