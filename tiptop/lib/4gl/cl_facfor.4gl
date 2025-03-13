# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Library name...: cl_facfor
# Descriptions...: 將 INPUT DECLIAM(16,8) 數值轉為 9 位字元的格式.
#                  若值為 12345678 , 將傳回 '^12345678'
#                  若值為 1234567  , 將傳回 '1234567.0'
#                  若值為 123456   , 將傳回 '123456.00'
#                  若值為 12345.67 , 將傳回 '12345.670'
#                  若值為 1.234567 , 將傳回 '1.2345670'
#                  若值為 .1234567 , 將傳回 '.12345670'
# Input parameter: p_fac	數值
# Return code....: l_str  	FORMAT後的數值, 以 CHAR 型態 RETURN
# Usage .........: let a = cl_facfor(p_fac); print a
#                  .or. print cl_facfor(p_fac) 
# Date & Author..: 92/10/11 By LYS
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
#
DATABASE ds
 
FUNCTION cl_facfor(p_fac)
   DEFINE p_fac LIKE pml_file.pml09   #No.FUN-690005  FLOAT
   DEFINE l_str LIKE type_file.chr9   #LIKE cpd_file.cpd11   #No.FUN-690005  VARCHAR(9)   #TQC-B90211
   CASE
     WHEN p_fac >=10000000 LET l_str = p_fac USING '#########'
     WHEN p_fac >= 1000000 LET l_str = p_fac USING '#######.#'
     WHEN p_fac >=  100000 LET l_str = p_fac USING '######.##'
     WHEN p_fac >=   10000 LET l_str = p_fac USING '#####.###'
     WHEN p_fac >=    1000 LET l_str = p_fac USING '####.####'
     WHEN p_fac >=     100 LET l_str = p_fac USING '###.#####'
     WHEN p_fac >=      10 LET l_str = p_fac USING '##.######'
     WHEN p_fac >=       1 LET l_str = p_fac USING '#.#######'
     OTHERWISE             LET l_str = p_fac USING '.########'
   END CASE
   RETURN l_str
END FUNCTION
