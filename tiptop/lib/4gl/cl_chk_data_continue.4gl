# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_chk_data_continue.4gl
# Descriptions...: 檢查資料是否連續.
# Memo...........:                                                          
# Usage..........: CALL cl_chk_data_continue(g_img.adjno[5,10])
# Date & Author..: 2003/09/10 by Hiko
# Modify.........: No.MOD-480282 04/08/11 Wiky 改cl_null()不然(infomix會擋)
# Modify.........: No.FUN-7C0045 07/12/14 alex 修改說明
 
DATABASE ds
 
##########################################################################
# Descriptions...: 檢查資料是否連續.
# Memo...........: 
# Input parameter: ps_source     STRING        來源資料
# Return code....: li_data_cont  (TRUE/FALSE)  是否連續
# Usage..........: IF cl_chk_data_continue(ls_str) THEN
# Date & Author..: 2003/09/10 by Hiko
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明
##########################################################################
 
FUNCTION cl_chk_data_continue(ps_source)
   DEFINE   ps_source   STRING
   DEFINE   li_i        LIKE type_file.num5,         #No.FUN-690005 SMALLINT
            li_data_cont     LIKE type_file.num5     #No.FUN-690005 SMALLINT
 
   
   LET li_data_cont = TRUE
 #  IF (ps_source IS NOT NULL) OR (ps_source != ' ') THEN  #No.MOD-480282
    IF NOT cl_null(ps_source) THEN                         #No.MOD-480282
      LET ps_source = ps_source.trim()
      IF (ps_source.equals("")) THEN
         LET li_data_cont = FALSE
      ELSE
         FOR li_i = 1 TO ps_source.getLength()
            IF (ps_source.getCharAt(li_i) = ' ') THEN
               LET li_data_cont = FALSE
               EXIT FOR
            END IF
         END FOR
      END IF
   END IF
 
   RETURN li_data_cont 
END FUNCTION
 
##########################################################################
# Descriptions...: 檢查字串是否符合0~9,a~z
# Memo...........: 
# Input parameter: ps_source  STRING        來源資料
#                  ps_count   SMALLINT      檢查幾碼, 如果未傳幾碼, 則會以來源字串長度當作ps_count
# Return code....: li_result  (TRUE/FALSE)  回傳結果        #No.FUN-690005
# Usage..........: IF cl_chk_str_correct(ls_str,1,10) THEN
# Date & Author..: 2005/02/17 by saki
# Modify.........: 
##########################################################################
FUNCTION cl_chk_str_correct(ps_source,pi_start,pi_end)
   DEFINE   ps_source   STRING
   DEFINE   pi_start    LIKE type_file.num5          #No.FUN-690005  SMALLINT
   DEFINE   pi_end      LIKE type_file.num5          #No.FUN-690005  SMALLINT
   DEFINE   li_i        LIKE type_file.num5          #No.FUN-690005  SMALLINT
   DEFINE   ls_chk_chr  LIKE type_file.chr1          #No.FUN-690005  VARCHAR(1)
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-690005  SMALLINT
 
 
   IF (ps_source IS NULL) OR (pi_end < pi_start) OR
      (pi_start <= 0) OR (pi_end <= 0) THEN
      RETURN FALSE
   END IF
 
   IF (pi_start IS NULL) OR (pi_end IS NULL) THEN
      LET pi_start = 1
      LET pi_end = ps_source.getLength()
   END IF
 
   LET li_result = TRUE
   FOR li_i = pi_start TO pi_end
       LET ls_chk_chr = ps_source.getCharAt(li_i)
       IF ls_chk_chr NOT MATCHES "[0-9a-zA-Z]" THEN
          LET li_result = FALSE
          EXIT FOR
       END IF
   END FOR
 
   RETURN li_result
END FUNCTION
