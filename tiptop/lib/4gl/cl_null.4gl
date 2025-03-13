# Prog. Version..: '5.30.06-13.03.12(00002)'     #
 
# Program name...: cl_null.4gl
# Descriptions...: 檢查字串是否為NULL或是空字串.
# Date & Author..: 03/09/10 by Hiko
# Input Parameter: ps_source   STRING   來源字串
# Return Code....: SMALLINT   是否為NULL或是空字串
# Usgae..........: CALL cl_null(l_char)
# Modify.........: No.FUN-690005 06/09/25 By cheunl 欄位定義類型轉換 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-9B0113 07/12/17 By alex 新增cl_null_cat_to_file()
 
IMPORT os
DATABASE ds
 
FUNCTION cl_null(ps_source)    #FUN-7C0053
   DEFINE   ps_source    STRING
   DEFINE   li_is_null   LIKE type_file.num5     #No.FUN-690005 SMALLINT
 
 
   IF (ps_source IS NULL) THEN
      LET li_is_null = TRUE
   ELSE
      LET ps_source = ps_source.trim()
      IF (ps_source.getLength() = 0) THEN
         LET li_is_null = TRUE
      END IF
   END IF
 
   RETURN li_is_null
END FUNCTION

# Descriptions...: 產生一個空檔案到指定的路徑內
# Input Parameter: ps_path   STRING   目標檔案路徑
# Return Code....: none
# Usgae..........: CALL cl_null_cat_to_file(l_path)

FUNCTION cl_null_cat_to_file(l_path)     #FUN-9B0113

   DEFINE l_path  STRING
   DEFINE l_cmd   STRING

   IF os.Path.separator() = "/" THEN
      LET l_cmd = "cat /dev/null > ",l_path
   ELSE
      LET l_cmd = "cat NUL > ",l_path
   END IF

   RUN l_cmd

END FUNCTION

