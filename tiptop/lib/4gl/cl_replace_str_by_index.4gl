# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_replace_str_by_index.4gl
# Descriptions...: 依據索引位置取代字串.
# Date & Author..: 2003/07/09 by Hiko
# Memo...........: 1. 如果起始索引位置<1,則起始索引位置=1.
#                  2. 如果起始索引位置>來源字串的長度,則起始索引位置=來源字串的長度.
#                  3. 如果結束索引位置<起始索引位置,則結束索引位置=起始索引位置.
#                  4. 如果結束索引位置>來源字串的長度,則結束索引位置=來源字串的長度.
# Usage..........: CALL cl_replace_str_by_index("abcdefg", 3, 5, "WXYZ") RETURNING ls_new
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:FUN-A10002 10/01/04 By Hiko 改用StringBuffer處理.
 
DATABASE ds       #No.FUN-690005    #FUN-7C0053
 
# Descriptions...: 依據索引位置取代字串.
# Date & Author..: 2003/07/09 by Hiko
# Input Parameter: ps_source STRING 來源字串
#                  pi_from SMALLINT 起始索引位置
#                  pi_end SMALLINT 結束索引位置
#                  ps_new STRING 新字串
# Return Code....: STRING 取代後的新字串
# Modify.........: No:FUN-A10002 10/01/04 By Hiko 改用StringBuffer處理. 
FUNCTION cl_replace_str_by_index(ps_source, pi_from, pi_end, ps_new)
  DEFINE ps_source,ps_new STRING,
         pi_from,pi_end   LIKE type_file.num5             #No.FUN-690005  SMALLINT
  DEFINE li_source_length LIKE type_file.num5             #No.FUN-690005  SMALLINT
  #DEFINE ls_source_left,ls_source_right,ls_result STRING #FUN-A10002
  DEFINE buf base.StringBuffer #FUN-A10002
 
  LET ps_source = ps_source.trimRight()
  LET li_source_length = ps_source.getLength()
 
  IF (pi_from < 1) THEN
     LET pi_from = 1
  ELSE
     IF (pi_from > li_source_length) THEN
        LET pi_from = li_source_length
     END IF
  END IF
 
  IF (pi_end < pi_from) THEN
     LET pi_end = pi_from
  ELSE
     IF (pi_end > li_source_length) THEN
        LET pi_end = li_source_length
     END IF
  END IF

  #Begin:FUN-A10002
  LET buf = base.StringBuffer.create()
  CALL buf.append(ps_source)
  LET pi_end = pi_end - pi_from + 1
  CALL buf.replaceAt(pi_from, pi_end, ps_new)
  RETURN buf.toString()
  #End:FUN-A10002

  #Begin:FUN-A10002 Mark 
  #IF (pi_from = 1) THEN
  #   LET ls_source_left = ""
  #ELSE
  #   LET ls_source_left = ps_source.subString(1, pi_from-1)
  #END IF
  #
  #IF (pi_end = li_source_length) THEN
  #   LET ls_source_right = ""
  #ELSE
  #   LET ls_source_right = ps_source.subString(pi_end+1, li_source_length)
  #END IF
  #
  #LET ls_result = ls_source_left,ps_new,ls_source_right
  #
  #RETURN ls_result
  #End:FUN-A10002 Mark 
END FUNCTION
