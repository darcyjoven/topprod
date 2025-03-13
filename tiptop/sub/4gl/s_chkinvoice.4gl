# Prog. Version..: '5.30.06-13.03.18(00002)'     #
#
# Program name...: s_chkinvoice.4gl
# Descriptions...: 計算發票檢查碼
# Date & Author..: 04/05/12 By Nicola
# Usage..........: CALL s_chkinvoice(p_code) 
# Input Parameter: p_code :發票號碼
# RETURN Code....: l_chkcode
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-D30023 13/03/04 By apo 若g_invoice[1],g_invoice[2]為null值，則給"0"
 
DATABASE ds    #FUN-7C0053
 
FUNCTION s_chkinvoice(p_code)
   DEFINE p_code      LIKE cre_file.cre08,        #No.FUN-680147 VARCHAR(10)
          g_invoice   ARRAY[10] OF LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          i           LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          l_invoice   LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          l_chkcode   LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
   FOR i = 1 TO 10
      LET g_invoice[i] = p_code[i,i]
#     DISPLAY g_invoice[i]
   END FOR
 
   LET g_invoice[1] = g_invoice[1] * 0
   LET g_invoice[2] = g_invoice[2] * 0 
   LET g_invoice[3] = g_invoice[3] * 1
   LET g_invoice[4] = (((g_invoice[4] * 9) / 10) + ((g_invoice[4] * 9) MOD 10))
   LET g_invoice[5] = (((g_invoice[5] * 5) / 10) + ((g_invoice[5] * 5) MOD 10))
   LET g_invoice[6] = (((g_invoice[6] * 7) / 10) + ((g_invoice[6] * 7) MOD 10))
   LET g_invoice[7] = g_invoice[7] * 0
   LET g_invoice[8] = (((g_invoice[8] * 4) / 10) + ((g_invoice[8] * 4) MOD 10))
   LET g_invoice[9] = (((g_invoice[9] * 2) / 10) + ((g_invoice[9] * 2) MOD 10))
   LET g_invoice[10] = g_invoice[10] * 1
 
  #MOD-D30023--
   IF cl_null(g_invoice[1]) THEN LET g_invoice[1] = 0 END IF
   IF cl_null(g_invoice[2]) THEN LET g_invoice[2] = 0 END IF
  #MOD-D30023--
   LET l_invoice = g_invoice[1] + g_invoice[2] + g_invoice[3] + g_invoice[4] +
                   g_invoice[5] + g_invoice[6] + g_invoice[7] + g_invoice[8] +
                   g_invoice[9] + g_invoice[10]
 
#  DISPLAY "l_invoice:",l_invoice
 
   LET l_chkcode = 100 - l_invoice
 
#  DISPLAY "l_chkcode:",l_chkcode
 
   RETURN l_chkcode
 
END FUNCTION
