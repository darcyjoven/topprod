# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_num_value.4gl
# Descriptions...: 設定數值小數位數(可以四捨五入)
# Date & Author..: 2004/05/04 by saki
# Input Parameter: ps_value       STRING     傳入數值
#                  ps_digit       INTEGER    小數位數
# Memo...........: 擷取正確的小數位數後四捨五入傳回程式
# Usage..........: CALL cl_set_num_value(23.12345,4) RETURNING ls_value
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds                 #No.FUN-690005  #FUN-7C0053
 
FUNCTION cl_set_num_value(ps_value,ps_digit)
   DEFINE   ps_value        STRING
   DEFINE   ps_digit        LIKE type_file.num10            #No.FUN-690005  INTEGER
   DEFINE   ls_value        STRING
   DEFINE   li_digcut       LIKE type_file.num10            #No.FUN-690005  INTEGER
   DEFINE   ls_head_str     STRING
   DEFINE   ls_tail_str     STRING
   DEFINE   li_i            LIKE type_file.num10            #No.FUN-690005  INTEGER
   DEFINE   li_tmp          LIKE type_file.num10            #No.FUN-690005  INTEGER
   DEFINE   li_tail_value   LIKE type_file.num10            #No.FUN-690005  INTEGER
 
   LET li_digcut = ps_value.getIndexOf(".",1)
   IF li_digcut = 0 THEN
      LET ls_value = ps_value || "."
      FOR li_i = 1 TO ps_digit
          LET ls_value = ls_value || 0
      END FOR
      RETURN ls_value
   END IF
 
   LET ls_head_str = ps_value.subString(1,li_digcut - 1)
   LET ls_tail_str = ps_value.subString(li_digcut + 1,ps_value.getLength())
   IF (ls_tail_str.getLength() < ps_digit) THEN
      FOR li_i = 1 TO ps_digit - ls_tail_str.getLength()
          LET ls_value = ps_value || 0
      END FOR
   ELSE
      LET li_tmp = ls_tail_str.getCharAt(ps_digit + 1)
      IF li_tmp >= 5 THEN
         LET li_tail_value = ls_tail_str.subString(1,ps_digit)
         LET ls_tail_str = li_tail_value + 1
      ELSE
         LET ls_tail_str = ls_tail_str.subString(1,ps_digit)
      END IF
      LET ls_value = ls_head_str || "." || ls_tail_str
   END IF
   
   RETURN ls_value
END FUNCTION
