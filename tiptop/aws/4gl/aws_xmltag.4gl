# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: aws_xmltag
# Descriptions...: 從 XML 字串抓取某 tag name 中的 attribute 值
# Input parameter: p_XMLString XML string
#                  p_XMLTag    XML tag
# Return code....: Tag value
# Usage .........: call aws_xml_getTag(p_result,p_tag,p_attr)
# Date & Author..: 
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds        #FUN-6C0017
 
FUNCTION aws_xml_getTagAttribute(p_result,p_tag, p_attr)
    DEFINE p_result om.DomNode
    DEFINE p_tag    STRING,
           p_attr   STRING
    DEFINE l_list   om.NodeList
    DEFINE l_node   om.DomNode
 
    LET l_list = p_result.selectByTagName(p_tag)
    LET l_node = l_list.item(1)
    RETURN l_node.getAttribute(p_attr)
 
END FUNCTION
