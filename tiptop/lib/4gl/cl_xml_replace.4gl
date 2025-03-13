# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_xml_replace
# Descriptions...: XML 特殊字元處理, 將進行 XML 字串轉換動作
# Input parameter: p_str - STRING - XML字串
# Return code....: l_str - STRING - XML字串 
# Usage..........: call cl_xml_replace(p_prog)   
#                       RETURNING l_str
# Date & Author..: 07/05/15 By Echo
# Modify.........: No.MOD-780006 07/08/06 By Smapmin 將aws_xml.4gl複製為cl_xml_replace.4gl
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7C0067 07/12/20 By Echo 調整 LIB function 說明
 
DATABASE ds         #FUN-7C0053
 
#FUN-7C0067
FUNCTION cl_xml_replace(p_str)
DEFINE p_str     STRING,
       l_str     STRING,
       l_str2    STRING
DEFINE l_tok     base.Stringtokenizer
DEFINE l_buf     base.StringBuffer,
       l_buf2    base.StringBuffer
DEFINE i         LIKE type_file.num10,
       j         LIKE type_file.num10,
       l_start   LIKE type_file.num10,
       l_end     LIKE type_file.num10 
DEFINE l_tag     STRING
 
 
    LET l_buf = base.StringBuffer.create()
    LET l_tok = base.StringTokenizer.create(p_str, "\n")
    INITIALIZE p_str to null
    WHILE l_tok.hasMoreTokens()        
        LET l_str = l_tok.nextToken()
        LET l_buf2 = base.StringBuffer.create()
        CALL l_buf2.append(l_str)
 
        LET i = l_buf2.getIndexOf("<", 1)
        LET j = l_buf2.getIndexOf(">", 1)
        
        LET l_tag = "</", l_buf2.subString(i+1, j-1), ">"
        
        LET l_start = j + 1
        LET l_end = l_buf2.getIndexOf(l_tag, 1) - 1
        
        LET l_str2 = l_buf2.subString(l_start, l_end)
        CALL l_buf2.clear()
        CALL l_buf2.append(l_str2)
        CALL l_buf2.replace("&", "&amp;", 0)
        CALL l_buf2.replace("<", "&lt;", 0)
        LET l_str2 = l_buf2.toString()
        
        LET l_str = l_str.subString(1, j), l_str2, l_str.subString(l_end + 1, l_str.getlength())
        CALL l_buf.append(l_str || "\n")
    END WHILE
 
    LET l_str = l_buf.toString()
    RETURN l_str
END FUNCTION 
 
 
##################################################
# Descriptions...: XML 特殊字元處理, 將進行 String 字串轉換動作
# Date & Author..: 07/05/15 By Echo
# Input Parameter: p_str - STRING - 字串
# Return code....: l_str - STRING - 字串 
# Usage..........: call cl_xml_replaceStr(p_str)   
#                       RETURNING l_str
# Modify.........: 
##################################################
FUNCTION cl_xml_replaceStr(p_str)
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
#MOD-780006
