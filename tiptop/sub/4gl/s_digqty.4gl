# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_digqty.4gl
# Descriptions...: 數量欄位小數取位(設定小數點以後第n位, 無條件進位)
# Date & Author..: NO.FUN-BB0087 11/10/13 By fengrui 
# Modify.........: No.TQC-C70024 12/07/03 By fengrui 調整l_tmp、l_tmp2長度

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_digqty(p_qty, p_unit)
DEFINE l_gfe03 LIKE gfe_file.gfe03
DEFINE p_unit  LIKE ima_file.ima25
# DEFINE p_qty   LIKE oeb_file.oeb12 #darcy:2023/05/18 mark
# DEFINE l_qty   LIKE oeb_file.oeb12 #darcy:2023/05/18 mark 
DEFINE p_qty   LIKE type_file.num20_6 #darcy:2023/05/18 add
DEFINE l_qty   LIKE type_file.num20_6 #darcy:2023/05/18 add

   IF cl_null(p_unit) THEN
      RETURN p_qty
   END IF
   IF cl_null(p_qty) OR p_qty=0 THEN
      RETURN p_qty
   END IF
   SELECT gfe03 INTO l_gfe03 FROM gfe_file
                            WHERE gfe01= p_unit
   IF cl_null(l_gfe03) THEN  #單位無設位數,不取位
      RETURN p_qty
   END IF
   #LET l_qty=cl_digcut(p_qty, l_gfe03)
   LET l_qty=s_digqty_roundup(p_qty, l_gfe03)

   
   RETURN l_qty

END FUNCTION


FUNCTION s_digqty_roundup(p_value,p_int)
   #TQC-C70024--modify--str--
   #DEFINE p_value,l_res LIKE abb_file.abb25,   
   #      l_tmp         LIKE abb_file.abb25,    
   #      l_tmp2        LIKE type_file.num10,   
   DEFINE p_value,l_res LIKE type_file.num20_6,  #oeb_file.oeb12,     #darcy:2023/05/18 mod
          l_tmp         LIKE type_file.num26_10, 
          l_tmp2        LIKE type_file.num20,  
   #TQC-C70024--modify--end--
          p_int         LIKE type_file.num5,
          l_i,l_value   LIKE type_file.num10,
          l_sign        LIKE type_file.num5     #1:為正值或零 ； 2：為負值

   LET l_value=1
   LET l_sign =1
   IF p_value < 0 THEN 
      LET l_sign = 2
      LET p_value = p_value * (-1)
   END IF 
   FOR l_i=1 TO p_int
      LET l_value=l_value*10
   END FOR
   LET l_tmp= p_value*l_value
   LET l_tmp2 = l_tmp
   IF l_tmp > l_tmp2 THEN 
      LET l_tmp2 = l_tmp2 + 1
   END IF 

   LET l_res=l_tmp2/l_value
   IF l_sign = 2 THEN 
      LET l_res = l_res * (-1)
   END IF 
   RETURN l_res
END FUNCTION
#FUN-BB0087
