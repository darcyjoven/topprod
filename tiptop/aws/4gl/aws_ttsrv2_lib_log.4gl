# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv2_lib_log.4gl
# Descriptions...: 處理 TIPTOP 服務紀錄檔的共用 FUNCTION
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-840004
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-840004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE g_serial       STRING
DEFINE g_space_str    STRING     
 
#[
# Description....: 寫入服務傳入參數 log 紀錄
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_writeRequestLog()
    DEFINE l_ch        base.Channel,
           l_logFile   STRING,
           l_str       STRING
    DEFINE l_sb        base.StringBuffer
    
    
    WHENEVER ERROR CONTINUE
        
    #--------------------------------------------------------------------------#
    # 記錄檔為 $TEMPDIR/aws_ttsrv-yyymmdd.log                                  #
    #--------------------------------------------------------------------------#     
    LET l_logFile = fgl_getenv("TEMPDIR"), "/", "aws_ttsrv2-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()
    CALL l_ch.setDelimiter(NULL)
    CALL l_ch.openFile(l_logFile, "a")
    IF STATUS = 0 THEN
       LET g_serial = CURRENT HOUR TO FRACTION(3)
       LET l_sb = base.StringBuffer.create()
       CALL l_sb.append(g_serial)
       CALL l_sb.replace(":", "", 0)
       CALL l_sb.replace(".", "", 0)
       LET g_serial = l_sb.toString()
 
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#",
                   "\n[Request Service #", g_serial, "]", 
                   "\n    '", g_service, "' begin at ", CURRENT HOUR TO FRACTION(3), "\n",
                   "\n[Request Message #", g_serial, "]",
                   "\n", g_request.request, "\n"                         
       CALL l_ch.write(l_str)
    END IF
    CALL l_ch.close()
 
    RUN "chmod 666 " || l_logFile || " >/dev/null 2>&1"
END FUNCTION
 
 
#[
# Description....: 寫入服務回傳參數 log 紀錄
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_writeResponseLog()
    DEFINE l_ch        base.Channel,
           l_logFile   STRING,
           l_str       STRING
 
    
    
    
    #--------------------------------------------------------------------------#
    # 記錄檔為 $TEMPDIR/aws_ttsrv-yyymmdd.log                                  #
    #--------------------------------------------------------------------------# 
    LET l_logFile = fgl_getenv("TEMPDIR"), "/", "aws_ttsrv2-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()
    CALL l_ch.setDelimiter(NULL)
    CALL l_ch.openFile(l_logFile, "a")
    IF STATUS = 0 THEN
       LET l_str = "[Response Service #", g_serial, "]", 
                   "\n    '", g_service, "' end at ", CURRENT HOUR TO FRACTION(3), "\n",
                   "\n[Response Message #", g_serial, "]",
                   "\n", g_response.response, "\n",
                   "#------------------------------------------------------------------------------#\n\n"                         
       CALL l_ch.write(l_str)
    END IF
    CALL l_ch.close()
    
    RUN "chmod 666 " || l_logFile || " >/dev/null 2>&1"
END FUNCTION
 
#[
# Description....: 將輸入/回傳參數 XML 轉換成紀錄於 Log 檔中的字串
# Date & Author..: 2007/02/14 by Echo
# Parameter......: p_xml - DomNode - XML Root Node
# Return.........: l_str - STRING - XML 字串
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_translateParameterXmlToString(p_xml)
    DEFINE p_xml        om.DomNode
    DEFINE l_str        STRING,
           l_list       om.NodeList,
           l_rec_node   om.DomNode,
           l_node       om.DomNode,
           l_name       STRING,
           l_value      STRING,
           l_tname      STRING,
           l_sb         base.StringBuffer
           
    
    IF p_xml IS NULL THEN
       RETURN NULL
    END IF
 
    LET g_space_str = ""                                #07/08/30 by Echo
    
    #--------------------------------------------------------------------------#
    # 依照 base.TypeInfo 傳進來的參數 XML, 重組為寫入記錄檔中的字串格式        #
    #--------------------------------------------------------------------------#
    LET l_sb = base.StringBuffer.create()
    LET l_list = p_xml.selectByTagName("Record")
    LET l_rec_node = l_list.item(1)
    LET l_node = l_rec_node.getFirstChild()
    WHILE l_node IS NOT NULL
  
        LET l_sb = aws_ttsrv_xmlType(l_node,l_sb)      
 
        LET l_tname = l_node.getTagName()
        
        CALL l_sb.append("\n")
        LET l_node = l_node.getNext()
    END WHILE
    
    LET l_str = l_sb.toString()
    RETURN l_str
END FUNCTION
 
#[
# Description....: 判斷參數格式
# Date & Author..: 2007/02/14 by Echo
# Parameter......: mNode - XML Root Node
# Return.........: l_str - STRING - XML 字串
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_xmlType(p_node,p_sb)
DEFINE p_node       om.DomNode
DEFINE p_sb         base.StringBuffer
DEFINE l_node       om.DomNode
DEFINE l_child_node om.DomNode
DEFINE l_str        STRING,
      l_list       om.NodeList,
      l_rec_node   om.DomNode,
      l_name       STRING,
      l_value      STRING,
      l_tname      STRING,
      l_sb         base.StringBuffer
 
       LET l_node = p_node
       LET l_sb = p_sb
 
       LET l_tname = l_node.getTagName()
       CASE l_tname
            WHEN "Field"
                 LET l_name = l_node.getAttribute("name")
                 LET l_str = g_space_str,
                             "<<< Field name=\"", l_name, "\" >>>\n"
                 CALL l_sb.append(l_str CLIPPED)
 
                 LET l_value = l_node.getAttribute("value")
                 LET l_value = g_space_str,l_value CLIPPED, "\n"
                 CALL l_sb.append(l_value CLIPPED)
 
            WHEN "Array"
                 LET l_name = l_node.getAttribute("name")
                 LET l_str = g_space_str,
                             "<<< Array name=\"", l_name, "\" >>>\n"
                 CALL l_sb.append(l_str CLIPPED)
 
                 LET l_str = aws_ttsrv_xmlToString(l_node), "\n"
                 CALL l_sb.append(l_str CLIPPED)
 
            WHEN "Record"
                 LET l_name = l_node.getAttribute("name")
                 LET l_str = g_space_str,
                             "<<< Array name=\"", l_name, "\" >>>\n"
                 CALL l_sb.append(l_str CLIPPED)
 
                 LET l_child_node = l_node.getFirstChild()
 
                 LET g_space_str = "   "
 
                 WHILE l_child_node IS NOT NULL
                     LET l_sb =  aws_ttsrv_xmlType(l_child_node,l_sb)
                     LET l_child_node = l_child_node.getNext()
                     CALL l_sb.append("\n")
                 END WHILE
       END CASE
 
       RETURN l_sb
END FUNCTION
 
