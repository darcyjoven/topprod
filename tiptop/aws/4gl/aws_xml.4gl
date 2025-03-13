# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Library name...: aws_xml_getTag
# Descriptions...: 從 XML 字串抓取需要的 tag
# Input parameter: p_XMLString XML string
#                  p_XMLTag    XML tag
# Return code....: Tag value
# Usage .........: call aws_xml_getTag(p_XMLString, p_XMLTag)
# Date & Author..: 92/02/25 By Brendan
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-710063 07/05/14 By Echo XML 特殊字元處理功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960057 10/09/15 By Jay aws_xml_getTag增加判斷以避免取子字串時出錯
# Modify.........: No:TQC-970047 10/09/15 By Jay 修改以下函數寫法，增加考慮Tag可能包含屬性，以及避免字串被截斷
#                                                  (1)aws_xml_getTag() , (2)aws_xml_replace()
# Modify.........: No:TQC-980156 10/09/15 By Jay 修改抓取Tag的判斷方式
 
DATABASE ds       #No.FUN-680130
 
FUNCTION aws_xml_getTag(p_XMLString, p_XMLTag)
    DEFINE   p_XMLString   STRING,
             p_XMLTag      STRING,
             l_str         STRING,
             l_tag         STRING,
             l_tag_e       STRING,
             l_p1          LIKE type_file.num5,      #No.FUN-680130 SMALLINT
             l_p2          LIKE type_file.num5,      #No.FUN-680130 SMALLINT
             l_index       LIKE type_file.num5,      #TQC-970047
             l_substr      STRING                    #TQC-970047 
 
#抓如: <XML> 的位置
    #--TQC-970047--start--
    #--TQC-980156--start--
    LET l_tag = "<", p_XMLTag CLIPPED, ">"
    #LET l_tag = "<", p_XMLTag CLIPPED
    LET l_tag_e = "</", p_XMLTag CLIPPED, ">"
    LET l_p1 = p_XMLString.getIndexOf(l_tag, 1)
    IF l_p1 <> 0 THEN
       LET l_p1 = l_p1 + l_tag.getLength()
    ELSE
      LET l_tag = "<", p_XMLTag CLIPPED," "
      LET l_p1 = p_XMLString.getIndexOf(l_tag, 1)
      IF l_p1 <> 0 THEN
         LET l_index = l_p1 + l_tag.getLength()
         LET l_substr = p_XMLString.subString(l_index,p_XMLString.getLength())
         LET l_p1 = l_index + l_substr.getIndexOf(">",1)
      END IF
    END IF
    #--TQC-980156--end--
    #--TQC-970047--end--
    LET l_p2 = p_XMLString.getIndexOf(l_tag_e, 1)
    IF (l_p1 = 0) OR (l_p2 = 0) OR (l_p1 > l_p2) THEN RETURN '' END IF  #FUN-960057 add
    #LET l_str = p_XMLString.subString(l_p1+l_tag.getLength(), l_p2-1)  #TQC-970047
    LET l_str = p_XMLString.subString(l_p1, l_p2-1)                     #TQC-970047
    RETURN l_str

END FUNCTION

#--TQC-970047--start--
# Modify.........: 10/09/15 By Jay 修改寫法避免字串被截斷 
#所以mark以下所有原程式段
#FUN-710063
#[
# Description....: XML 特殊字元處理, 將進行 XML 字串轉換動作
# Date & Author..: 2007/05/15 By Echo
# Parameter......: p_str - STRING - XML字串
# Return.........: l_str - STRING - XML字串 
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_xml_replace(p_str)
#DEFINE p_str     STRING,
#       l_str     STRING,
#       l_str2    STRING
#DEFINE l_tok     base.Stringtokenizer
#DEFINE l_buf     base.StringBuffer,
#       l_buf2    base.StringBuffer
#DEFINE i         LIKE type_file.num10,
#       j         LIKE type_file.num10,
#       l_start   LIKE type_file.num10,
#       l_end     LIKE type_file.num10
#DEFINE l_tag     STRING
# 
# 
#    LET l_buf = base.StringBuffer.create()
#    LET l_tok = base.StringTokenizer.create(p_str, "\n")
#    INITIALIZE p_str to null
#    WHILE l_tok.hasMoreTokens()        
#        LET l_str = l_tok.nextToken()
#        LET l_buf2 = base.StringBuffer.create()
#        CALL l_buf2.append(l_str)
# 
#        LET i = l_buf2.getIndexOf("<", 1)
#        LET j = l_buf2.getIndexOf(">", 1)
#        
#        LET l_tag = "</", l_buf2.subString(i+1, j-1), ">"
#        
#        LET l_start = j + 1
#        LET l_end = l_buf2.getIndexOf(l_tag, 1) - 1
#        
#        LET l_str2 = l_buf2.subString(l_start, l_end)
#        CALL l_buf2.clear()
#        CALL l_buf2.append(l_str2)
#        CALL l_buf2.replace("&", "&amp;", 0)
#        CALL l_buf2.replace("<", "&lt;", 0)
#        LET l_str2 = l_buf2.toString()
#        
#        LET l_str = l_str.subString(1, j), l_str2, l_str.subString(l_end + 1, l_str.getlength())
#        CALL l_buf.append(l_str || "\n")
#    END WHILE
# 
#    LET l_str = l_buf.toString()
#    RETURN l_str

  DEFINE p_str      STRING,
         l_str      STRING,
         l_value    STRING,
         l_endtag   STRING,
         l_name     STRING,
         l_pos      LIKE type_file.num10,
         l_Equal    LIKE type_file.num10,
         l_TagStart LIKE type_file.num10,
         l_TagEnd   LIKE type_file.num10,
         l_endpos   LIKE type_file.num10,
         l_buf      base.StringBuffer
 
  LET p_str = p_str.trim()
  LET l_pos = 1                  #記錄現在要開始處理的位置
  LET l_buf = base.StringBuffer.create()
  WHILE l_pos < p_str.getLength()
    LET l_TagStart = p_str.getIndexOf("<",l_pos)
    IF l_pos = 1 AND l_TagStart > l_pos THEN
       RETURN p_str
    END IF
    LET l_TagEnd = p_str.getIndexOf(">",l_pos)
    IF l_TagStart = 0 OR l_TagEnd = 0 OR l_TagStart > l_TagEnd THEN
       RETURN p_str
    END IF
    LET l_name = p_str.subString(l_TagStart+1,l_TagEnd-1)  #取tag名稱
    LET l_endtag = "</",l_name CLIPPED,">"
    LET l_endpos = p_str.getIndexOf(l_endtag,l_TagEnd+1)
    IF l_endpos <> 0 THEN
       CALL l_buf.append(p_str.subString(l_pos,l_TagEnd))
       IF l_TagEnd+1 < l_endpos THEN                       #<A>..</A>
          LET l_value = p_str.subString(l_TagEnd+1,l_endpos-1)
          IF l_value.getIndexOf("</",1) = 0 AND l_value.getIndexOf("/>",1) = 0 THEN
             #對 tag 的值進行取代特殊字元
             LET l_value = aws_xml_replaceStr(l_value)
             CALL l_buf.append(l_value || l_endtag)
             LET l_pos = l_endpos + l_endtag.getLength()
          ELSE
             LET l_pos = l_TagEnd + 1                     #<A><B>..</B></A>
          END IF
       ELSE
          CALL l_buf.append(l_endtag)                     #<A></A>
          LET l_pos = l_endpos + l_endtag.getLength()
       END IF
    ELSE
       LET l_Equal = l_name.getIndexOf(" ",1)
       IF l_Equal = 0 THEN                                #<A/>
          CALL l_buf.append(p_str.subString(l_pos,l_TagEnd))
          LET l_pos = l_TagEnd + 1
       ELSE
          LET l_name = p_str.subString(l_TagStart+1,l_TagStart+l_Equal-1)
          LET l_endtag = "</",l_name CLIPPED,">"
          LET l_endpos = p_str.getIndexOf(l_endtag,l_TagEnd+1)
          IF l_endpos <> 0 THEN
             CALL l_buf.append(p_str.subString(l_pos,l_TagEnd))
             IF l_TagEnd+1 < l_endpos THEN                #<A x="1">..</A>
                LET l_value = p_str.subString(l_TagEnd+1,l_endpos-1)
                IF l_value.getIndexOf("</",1) = 0 AND l_value.getIndexOf("/>",1) = 0 THEN
                   #對 tag 的值進行取代特殊字元
                   LET l_value = aws_xml_replaceStr(l_value)
                   CALL l_buf.append(l_value || l_endtag)
                   LET l_pos = l_endpos + l_endtag.getLength()
                ELSE
                   LET l_pos = l_TagEnd + 1               #<A x="1"><B>..</B></A>
                END IF
             ELSE
                CALL l_buf.append(l_endtag)               #<A x="1"></A>
                LET l_pos = l_endpos + l_endtag.getLength()
             END IF
          ELSE                                            #<A x="1" />
             CALL l_buf.append(p_str.subString(l_pos,l_TagEnd))
             LET l_pos = l_TagEnd + 1
          END IF
       END IF
    END IF
  END WHILE
 
  LET l_str = l_buf.toString()
  RETURN l_str

END FUNCTION
#--TQC-970047--end--
 
#[
# Description....: XML 特殊字元處理, 將進行 String 字串轉換動作
# Date & Author..: 2007/05/15 By Echo
# Parameter......: p_str - STRING - 字串
# Return.........: l_str - STRING - 字串 
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_xml_replaceStr(p_str)
DEFINE p_str  STRING
DEFINE l_str  STRING
DEFINE l_buf  base.StringBuffer
 
  LET l_buf = base.StringBuffer.create()            
  CALL l_buf.append(p_str)
  CALL l_buf.replace("&","&amp;",0)
  CALL l_buf.replace("'","&apos;",0)
  CALL l_buf.replace("\"","&quot;",0)
  CALL l_buf.replace("<","&lt;",0)
  CALL l_buf.replace(">","&gt;",0)
  
  LET l_str = l_buf.toString()
 
  RETURN l_str
END FUNCTION
#END FUN-710063
