# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_tw_tax_addr.4gl
# Descriptions...: 轉換台灣地區應納稅人地址資料(半形轉全形)
# Date & Author..: 08/01/02 By alex   #FUN-810025
# Modify.........: No.MOD-8C0135 08/12/15 By alex 改用multi-str變更函式
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS        #FUN-810025
   DEFINE g_arr      ARRAY[39] OF LIKE type_file.chr10
   DEFINE g_init     LIKE type_file.chr1
END GLOBALS
 
# Private Func...: TRUE
# Descriptions...: 轉換台灣地區應納稅人地址資料(半形轉全形)
 
FUNCTION s_tw_tax_addr_init()
 
   DEFINE l_target   STRING 
   DEFINE l_i,l_pos  SMALLINT
   DEFINE tok1       base.StringTokenizer
   DEFINE tok2       base.StringTokenizer
   DEFINE tok3       base.StringTokenizer
 
   LET l_target = cl_getmsg("sub-163",g_lang)
   LET tok1 = base.StringTokenizer.create(l_target,",")
   LET l_i = 1
   WHILE tok1.hasMoreTokens()
     LET g_arr[l_i] = tok1.nextToken()
     LET l_i = l_i + 1
   END WHILE
 
   LET l_target = cl_getmsg("sub-164",g_lang)
   LET tok2 = base.StringTokenizer.create(l_target,",")
   WHILE tok2.hasMoreTokens()
     LET g_arr[l_i] = tok2.nextToken()
     LET l_i = l_i + 1
   END WHILE
 
   LET l_target = cl_getmsg("sub-165",g_lang)
   LET tok3 = base.StringTokenizer.create(l_target,",")
   WHILE tok3.hasMoreTokens()
     LET g_arr[l_i] = tok3.nextToken()
     LET l_i = l_i + 1
   END WHILE
 
   LET g_init = "N"
 
END FUNCTION
 
# Descriptions...: 轉換台灣地區應納稅人地址資料(半形轉全形)
# Usage..........: LET l_str=s_tw_tax_addr(l_str)
# Input Parameter: l_str 轉換前的地址
# Return Code....: l_str 轉換後的地址
 
FUNCTION s_tw_tax_addr(l_str)
 
   DEFINE l_str      STRING 
   DEFINE l_i,l_pos  SMALLINT
 
   IF NOT g_init = "N" OR g_init IS NULL OR g_init = "" THEN
      CALL s_tw_tax_addr_init()
   END IF
 
   LET l_str = UPSHIFT(l_str.trim())
 
   #MOD-8C0135 OLD:cl_replace_str()
   LET l_str = cl_replace_multistr(l_str,"1",g_arr[1] CLIPPED) 
   LET l_str = cl_replace_multistr(l_str,"2",g_arr[2] CLIPPED) 
   LET l_str = cl_replace_multistr(l_str,"3",g_arr[3] CLIPPED) 
   LET l_str = cl_replace_multistr(l_str,"4",g_arr[4] CLIPPED) 
   LET l_str = cl_replace_multistr(l_str,"5",g_arr[5] CLIPPED) 
   LET l_str = cl_replace_multistr(l_str,"6",g_arr[6] CLIPPED) 
   LET l_str = cl_replace_multistr(l_str,"7",g_arr[7] CLIPPED) 
   LET l_str = cl_replace_multistr(l_str,"8",g_arr[8] CLIPPED) 
   LET l_str = cl_replace_multistr(l_str,"9",g_arr[9] CLIPPED) 
   LET l_str = cl_replace_multistr(l_str,"0",g_arr[10] CLIPPED)
   LET l_str = cl_replace_multistr(l_str," ",g_arr[11] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"-",g_arr[12] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"~",g_arr[13] CLIPPED)
   
   LET l_str = cl_replace_multistr(l_str,"A",g_arr[14] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"B",g_arr[15] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"C",g_arr[16] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"D",g_arr[17] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"E",g_arr[18] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"F",g_arr[19] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"G",g_arr[20] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"H",g_arr[21] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"I",g_arr[22] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"J",g_arr[23] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"K",g_arr[24] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"L",g_arr[25] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"M",g_arr[26] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"N",g_arr[27] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"O",g_arr[28] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"P",g_arr[29] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"Q",g_arr[30] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"R",g_arr[31] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"S",g_arr[32] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"T",g_arr[33] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"U",g_arr[34] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"V",g_arr[35] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"W",g_arr[36] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"X",g_arr[37] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"Y",g_arr[38] CLIPPED)
   LET l_str = cl_replace_multistr(l_str,"Z",g_arr[39] CLIPPED)
 
#  #MOD-8C0135 以下原意是要改 "漢" 不會出亂碼 (第2碼為 ~ ) 新法即可避開
#  LET l_i = 0
#  WHILE TRUE
#     LET l_pos = l_str.getIndexOf("~",l_i+1)
#     IF l_pos = 0 THEN
#        EXIT WHILE
#     ELSE
#        IF l_pos MOD 2 = 0 THEN
#           LET l_i = l_pos+1 CONTINUE WHILE
#        ELSE
#           #假設地址首字,尾字決不可能是水波紋
#           LET l_str = l_str.subString(1,l_pos-1),g_arr[13] CLIPPED,
#                       l_str.subString(l_pos+1,l_str.getLength())
#        END IF   
#     END IF   
#  END WHILE
 
   RETURN l_str
 
END FUNCTION
 
