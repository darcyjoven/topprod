# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv_lib_log.4gl
# Descriptions...: 處理 TIPTOP 服務紀錄檔的共用 FUNCTION
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
 
 
#[
# Description....: 寫入服務傳入參數 log 紀錄
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: p_service - STRING - 服務名稱
#                : p_input - STRING - 服務傳入參數
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_writeInputLog(p_service, p_input)
    DEFINE p_service   STRING,
           p_input     om.DomNode
    DEFINE l_ch        base.Channel,
           l_logFile   STRING,
           l_str       STRING
    
    
    WHENEVER ERROR CONTINUE
    
    IF cl_null(p_service) OR p_input IS NULL THEN
       RETURN
    END IF
    
    #--------------------------------------------------------------------------#
    # 記錄檔為 $TEMPDIR/aws_ttsrv-yyymmdd.log                                  #
    #--------------------------------------------------------------------------#     
    LET l_logFile = fgl_getenv("TEMPDIR"), "/", 
                    "aws_ttsrv-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()
    CALL l_ch.setDelimiter(NULL)
    CALL l_ch.openFile(l_logFile, "a")
    IF STATUS = 0 THEN
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL l_ch.write(l_str) 
       CALL l_ch.write("\n[Service]")
       LET l_str = "'", p_service, "' start at ", CURRENT HOUR TO FRACTION(3)
       CALL l_ch.write(l_str)
       CALL l_ch.write("\n[Input Message]")
       
       #-----------------------------------------------------------------------#
       # 將輸入參數的 XML 文件轉換成紀錄於 log 檔中的字串                      #
       #-----------------------------------------------------------------------# 
       LET l_str = aws_ttsrv_translateParameterXmlToString(p_input)
       CALL l_ch.write(l_str)
    END IF
    CALL l_ch.close()
 
    RUN "chmod 666 " || l_logFile || " >/dev/null 2>&1"
END FUNCTION
 
 
#[
# Description....: 寫入服務回傳參數 log 紀錄
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: p_service
#                : p_output - STRING - 服務回傳參數
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_writeOutputLog(p_service, p_output)
    DEFINE p_service   STRING,
           p_output    om.DomNode
    DEFINE l_ch        base.Channel,
           l_logFile   STRING,
           l_str       STRING
 
    
    IF cl_null(p_service) OR p_output IS NULL THEN
       RETURN
    END IF
      
    #--------------------------------------------------------------------------#
    # 記錄檔為 $TEMPDIR/aws_ttsrv-yyymmdd.log                                  #
    #--------------------------------------------------------------------------# 
    LET l_logFile = fgl_getenv("TEMPDIR"), "/", 
                    "aws_ttsrv-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()
    CALL l_ch.setDelimiter(NULL)
    CALL l_ch.openFile(l_logFile, "a")
    IF STATUS = 0 THEN
       CALL l_ch.write("\n[Service]")
       LET l_str = "'", p_service, "' stop at ", CURRENT HOUR TO FRACTION(3)
       CALL l_ch.write(l_str)
       CALL l_ch.write("\n[Output Message]")
 
       #-----------------------------------------------------------------------#
       # 將回傳參數的 XML 文件轉換成紀錄於 log 檔中的字串                      #
       #-----------------------------------------------------------------------#  
       LET l_str = aws_ttsrv_translateParameterXmlToString(p_output)
       CALL l_ch.write(l_str)
 
       CALL l_ch.write("\n#------------------------------------------------------------------------------#\n\n")
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
    
    #--------------------------------------------------------------------------#
    # 依照 base.TypeInfo 傳進來的參數 XML, 重組為寫入記錄檔中的字串格式        #
    #--------------------------------------------------------------------------#
    LET l_sb = base.StringBuffer.create()
    LET l_list = p_xml.selectByTagName("Record")
    LET l_rec_node = l_list.item(1)
    LET l_node = l_rec_node.getFirstChild()
    WHILE l_node IS NOT NULL
        LET l_tname = l_node.getTagName()
        
        CASE l_tname
             WHEN "Field"                 
                  LET l_name = l_node.getAttribute("name")
                  LET l_str = "<<< Field name=\"", l_name, "\" >>>\n"
                  CALL l_sb.append(l_str CLIPPED)
                  
                  LET l_value = l_node.getAttribute("value")
                  LET l_value = l_value CLIPPED, "\n"
                  CALL l_sb.append(l_value CLIPPED)
             
             WHEN "Array"
                  LET l_name = l_node.getAttribute("name")
                  LET l_str = "<<< Array name=\"", l_name, "\" >>>\n"
                  CALL l_sb.append(l_str CLIPPED)
                  
                  LET l_str = aws_ttsrv_xmlToString(l_node), "\n"
                  CALL l_sb.append(l_str CLIPPED)                  
        END CASE
        
        CALL l_sb.append("\n")
        LET l_node = l_node.getNext()
    END WHILE
    
    LET l_str = l_sb.toString()
    RETURN l_str
END FUNCTION
