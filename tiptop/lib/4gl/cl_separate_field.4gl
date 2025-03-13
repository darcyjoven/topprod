# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_separate_field.4gl
# Descriptions...: use ";" to separate the field in order to export 
#                  the report to excel
# Date & Author..: 04/06/16 by CoCo
# Usage..........: CALL cl_separate_field(p_name)
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_separate_field(rep_name)
 
 DEFINE  rep_name,l_str       string,
         l_param                    string,
         prog_name                  LIKE zzw_file.zzw01,             #No.FUN-690005  VARCHAR(10)  
         l_str_param                LIKE zzw_file.zzw01,           #No.FUN-690005  VARCHAR(60)  
         space_pos,i,l_str_length   LIKE type_file.num10,            #No.FUN-690005  integer
         field_pos                  DYNAMIC ARRAY OF LIKE type_file.num10   #No.FUN-690005 INTEGER
 
  LET prog_name = rep_name.substring(1,rep_name.getlength()-4)
 
  SELECT zzw01 INTO l_str_param FROM zzw_file WHERE zzw01=prog_name
  LET l_str = l_str_param 
  LET l_str_length = l_str.getLength()
  FOR i=1 to l_str_length 
     LET space_pos = l_str.getIndexOf(" ",1)
     LET l_param = l_str.substring(1,space_pos-1)
     display l_param
     LET l_str = l_str.substring(space_pos+1,l_str.getLength())
  END FOR 
 
END FUNCTION
 
