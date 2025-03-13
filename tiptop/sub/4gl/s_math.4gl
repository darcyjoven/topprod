# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_math.4gl
# Descriptions...: 數學計算式
# Date & Author..: 2005/07/20 by saki
# Modify.........: No.FUN-660138 06/08/25 By kim 加入無條件捨去和絕對值
# Modify.........: No.FUN-770029 07/07/10 By saki 新增無條件進位
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
# Modify.........: No.MOD-880109 08/08/15 By claire 調整無條件捨去功能
# Modify.........: No.CHI-970021 09/08/21 By jan 變量定義調整
# Modify.........: No.TQC-980206 09/08/26 By Dido 給予變數預設值
# Modify.........: No.FUN-980031 09/11/11 By jan 變量定義調整
# Modify.........: No.MOD-A30232 10/03/30 By liuxqa 变量定义调整
# Modify.........: No:MOD-A70210 10/07/29 By Sarah 將s_trunc裡的l_resint定義為INTEGER
# Modify.........: No:CHI-AB0016 10/11/17 By Summer 改寫FUNCTION s_trunc()
 
IMPORT util
DATABASE ds      #FUN-850069 FUN-680147 FUN-7C0053
 
# Descriptions...: 數字的n次方
# Input Parameter: p_num     DEC(20,10)  因數
#                  p_ex      DEC(20,10)  指數
# Return code....: li_result DEC(20,10)  結果
# Usage..........: CALL s_power(3,3) RETURNING li_result
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
 
FUNCTION s_power(p_num,p_ex)
   DEFINE   p_num       LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
   DEFINE   p_ex        LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
 
   RETURN util.Math.pow(p_num, p_ex) 

END FUNCTION
 
# Descriptions...: 開n次方根
# Date & Author..: 2005/07/20 by saki
# Input Parameter: p_num     DEC(20,10)  數
#                  p_root    DEC(20,10)  次方根
# Return Code....: li_result DEC(20,10)  結果
# Usage..........: CALL s_root(27,3) RETURNING li_result
 
FUNCTION s_root(p_num,p_root)
   DEFINE   p_num       LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
   DEFINE   p_root      LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
 
   RETURN util.Math.pow(p_num, (1.0 / p_root ) )

END FUNCTION
 
# Descriptions...: SIN(X) 返回X的正弦值。
# Date & Author..: 2005/07/20 by saki
# Input Parameter: p_num     DEC(20,10)  數
# Return Code....: li_result DEC(20,10)  結果
# Usage..........: CALL s_sin(30) RETURNING li_result
 
FUNCTION s_sin(p_num)
   DEFINE   p_num       LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
 
   RETURN util.Math.sin(p_num) 

END FUNCTION
 
# Descriptions...: COS(X) 返回X的餘弦
# Date & Author..: 2005/07/20 by saki
# Input Parameter: p_num     DEC(20,10)  數
# Return Code....: li_result DEC(20,10)  結果
# Usage..........: CALL s_cos(60) RETURNING li_result
 
FUNCTION s_cos(p_num)
   DEFINE   p_num       LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
 
   RETURN util.Math.cos(p_num) 

END FUNCTION
 
 
# Descriptions...: TAN(X) 返回X的正切值
# Date & Author..: 2005/07/20 by saki
# Input Parameter: p_num     DEC(20,10)  數
# Return Code....: li_result DEC(20,10)  結果
# Usage..........: CALL s_tan(45) RETURNING li_result
 
FUNCTION s_tan(p_num)
   DEFINE   p_num       LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
 
   RETURN util.Math.tan(p_num) 

END FUNCTION
 
 
# Descriptions...: ASIN(X) 返回X的反正弦值
# Date & Author..: 2005/07/20 by saki
# Input Parameter: p_num     DEC(20,10)  數
# Return Code....: li_result DEC(20,10)  結果
# Usage..........: CALL s_asin(30) RETURNING li_result
 
FUNCTION s_asin(p_num)
   DEFINE   p_num       LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
   DEFINE   g_db_type   LIKE type_file.chr3           #No.FUN-680147 VARCHAR(3)
   DEFINE   ls_sql      STRING
   DEFINE   li_result   LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
 
   RETURN util.Math.asin(p_num) 
 
END FUNCTION
 
 
# Descriptions...: ACOS(X) 返回X的反餘弦
# Date & Author..: 2005/07/20 by saki
# Input Parameter: p_num     DEC(20,10)  數
# Return Code....: li_result DEC(20,10)  結果
# Usage..........: CALL s_acos(60) RETURNING li_result
 
FUNCTION s_acos(p_num)
   DEFINE   p_num       LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
   DEFINE   g_db_type   LIKE type_file.chr3           #No.FUN-680147 VARCHAR(3)
   DEFINE   ls_sql      STRING
   DEFINE   li_result   LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
 
   RETURN util.Math.acos(p_num) 
 
END FUNCTION
 
 
# Descriptions...: ATAN(X) 返回X的反正切值
# Date & Author..: 2005/07/20 by saki
# Input Parameter: p_num     DEC(20,10)  數
# Return Code....: li_result DEC(20,10)  結果
# Usage..........: CALL s_atan(45) RETURNING li_result
 
FUNCTION s_atan(p_num)
   DEFINE   p_num       LIKE abb_file.abb25           #No.FUN-680147 DEC(20,10)
 
   RETURN util.Math.atan(p_num) 
 
END FUNCTION
 
#FUN-680085...............begin
 
# Descriptions...: 無條件捨去小數點以後第n位
# Date & Author..: 2006/08/25 by kim 
# Input Parameter: p_value,p_int  DEC(20,10) ;SMALLINT
# Return Code....: li_result DEC(20,10)  結果
# Memo...........: Ex:  a=123.456   ,要無條件捨去小數點以後第2位
#                  LET a=s_trunc(a,2)=123.45
 
FUNCTION s_trunc(p_value,p_int) 
#CHI-AB0016 add --start--
DEFINE p_value       LIKE abb_file.abb25,   #DEC(20,10)
       p_int         LIKE type_file.num5,   #SMALLINT
       l_value       STRING,
       l_cnt         LIKE type_file.num5,
       l_res	     LIKE abb_file.abb25

  LET l_value=p_value
  LET l_cnt = l_value.getIndexOf('.',1)
  LET l_value = l_value.subString(1,l_cnt+p_int)
  LET l_res =l_value 

  RETURN l_res
#CHI-AB0016 add --end--

#CHI-AB0016 mark --start--
#DEFINE p_value,l_res LIKE abb_file.abb25,       #No.FUN-680147 DEC(20,10)	
#       p_int         LIKE type_file.num5,       #No.FUN-680147 SMALLINT
#       l_resint      LIKE type_file.num10,      #FUN-980031 #MOD-A30232 mod   #MOD-A70210 mod num20->num10
#      #l_resint      LIKE type_file.num26_10,   #FUN-980031 #MOD-A30232 mark
#       l_i           LIKE type_file.num10,      #No.FUN-680147 INTEGER        #TQC-980206
#       l_value       LIKE type_file.num26_10 	      			      #TQC-980206
# 
#   IF p_value=0 THEN RETURN p_value END IF #FUN-980031 
#
#   LET l_value=1
#   FOR l_i=1 TO p_int
#      LET l_value=l_value*10
#   END FOR
# 
#   #MOD-880109-begin-add
#   #LET l_res=p_value*l_value    
#   #LET l_res=l_res/l_value
#   LET l_resint=p_value*l_value    
#   LET l_res=l_resint/l_value
#   #MOD-880109-end-add
# 
#   RETURN l_res
#CHI-AB0016 mark --end--
END FUNCTION   
 
 
# Descriptions...: 取絕對值
# Date & Author..: 2006/08/25 by kim 
# Input Parameter: p_value  DEC(20,10)
# Return Code....: li_result DEC(20,10)  結果
# Memo...........: also can : SELECT ABS(a) FROM DUAL (For ORA)
# Usage..........: a=-123.456 
#                  LET a=s_abs(a)=123.45
 
FUNCTION s_abs(p_value) 
DEFINE p_value LIKE abb_file.abb25          #No.FUN-680147 DEC(20,10)
 
   IF p_value<0 THEN
      RETURN p_value*-1
   ELSE
      RETURN p_value
   END IF
END FUNCTION   
 
 
# Descriptions...: 設定小數點以後第n位, 無條件進位
# Date & Author..: 2007/07/11 by saki
# Input parameter: p_value   DEC(20,10)
#                : p_int     SMALLINT
# Return code....: li_result DEC(20,10)  結果
# Usage..........: LET a = s_roundup(234.333,-2)  得到a=234.34
 
FUNCTION s_roundup(p_value,p_int) 
   DEFINE p_value,l_res LIKE abb_file.abb25,
          l_tmp         LIKE abb_file.abb25,
          l_tmp2        LIKE type_file.num10,
          p_int         LIKE type_file.num5,
          l_i,l_value   LIKE type_file.num10
 
   LET l_value=1
   FOR l_i=1 TO p_int+1
      LET l_value=l_value*10
   END FOR
   LET l_tmp=1/l_value
   LET l_tmp=l_tmp*9
   LET p_value= p_value + l_tmp
 
   LET l_tmp2 = p_value*l_value/10
   LET l_res=l_tmp2/l_value*10
 
 
   RETURN l_res
END FUNCTION   


