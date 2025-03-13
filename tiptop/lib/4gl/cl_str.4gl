# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: cl_str.4gl
# Descriptions...: 字串函式
# Date & Author..: #No:FUN-A40044 10/04/19 By tsai_yen 
# Modify.........: 

DATABASE ds
GLOBALS "../../config/top.global"

##################################################
# Descriptions...: 依分隔符號分隔字串後的item數量
# Date & Author..: 10/04/19 By tsai_yen   
# Input Parameter: p_str,p_sep
# Return code....: l_cnt
##################################################
FUNCTION cl_str_sepcnt(p_str,p_sep)     #FUN-A40044
   DEFINE p_str    STRING               #原字串
   DEFINE p_sep    STRING               #分隔符號
   DEFINE l_cnt    LIKE type_file.num5  #分隔後的item數量
   DEFINE l_tok    base.StringTokenizer
   DEFINE l_tmp    STRING

   LET l_tok = base.StringTokenizer.createExt(p_str,p_sep,"",TRUE)
   LET l_cnt = 0
   WHILE l_tok.hasMoreTokens()	#依序取得子字串
      LET l_cnt = l_cnt + 1
      LET l_tmp = l_tok.nextToken()
   END WHILE  
   RETURN l_cnt
END FUNCTION


##################################################
# Descriptions...: 依分隔符號分隔字串後，截取指定起點至終點的item
# Date & Author..: 10/04/19 By tsai_yen
# Input Parameter: p_str,p_sep,p_spos,p_epos
# Return code....: l_substr
##################################################
FUNCTION cl_str_sepsub(p_str,p_sep,p_spos,p_epos)   #FUN-A40044
   DEFINE p_str    STRING               #原字串
   DEFINE p_sep    STRING               #分隔符號
   DEFINE p_spos   LIKE type_file.num5  #起點
   DEFINE p_epos   LIKE type_file.num5  #終點   
   DEFINE l_tok    base.StringTokenizer
   DEFINE l_cnt    LIKE type_file.num5  #第幾個item
   DEFINE l_tmp    STRING
   DEFINE l_substr STRING               #子字串

   LET l_tok = base.StringTokenizer.createExt(p_str,p_sep,"",TRUE)
   LET l_cnt = 0
   WHILE l_tok.hasMoreTokens()	#依序取得子字串
      LET l_cnt = l_cnt + 1
      LET l_tmp = l_tok.nextToken()
      IF l_cnt>=p_spos AND l_cnt<=p_epos THEN
         LET l_substr = l_substr CLIPPED,p_sep,l_tmp CLIPPED
      END IF
   END WHILE  
   
   IF NOT cl_null(l_substr) THEN
      LET l_substr = l_substr.substring(p_sep.getlength()+1 ,l_substr.getlength())
   END IF
   RETURN l_substr
END FUNCTION   
