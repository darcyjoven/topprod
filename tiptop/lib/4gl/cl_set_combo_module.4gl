# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_combo_module.4gl
# Descriptions...: 動態設定有選擇模組資料的ComboBox語言選項
# Date & Author..: 03/07/02 by Hiko
# Usage..........: CALL cl_set_combo_module("oea08",0)
# Modify.........: No.MOD-660015 06/06/07 By Smapmin 將模組名稱排序
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
# Descriptions...: 動態設定有選擇模組資料的ComboBox語言選項
# Input Parameter: ps_field_name
#                  pi_type = 1 時輸出大寫
# Return Code....:
 
FUNCTION cl_set_combo_module(ps_field_name,pi_type)
 
   DEFINE ps_values,ps_items  STRING
   DEFINE ps_field_name       STRING
   #DEFINE pc_gaz01            LIKE gaz_file.gaz01
   #DEFINE pc_gaz03            LIKE gaz_file.gaz03
   DEFINE pc_gao01            LIKE gao_file.gao01
   DEFINE pi_i                LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE pi_type             LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE ps_sql              STRING
 
#  LET ps_sql = " SELECT gaz01,gaz03 FROM gaz_file ",
#                " WHERE gaz02='",g_lang CLIPPED,"'",
#                  " AND ( gaz01 LIKE 'a__' OR gaz01 LIKE 'g__' ",
#                     " OR gaz01 LIKE 'c__' OR gaz01 LIKE 'c___' ",
#                     " OR gaz01 LIKE 'lib' OR gaz01 LIKE 'qry' ",
#                     " OR gaz01 LIKE 'sub' ) "
#
   #LET ps_sql = " SELECT gao01 FROM gao_file "   #MOD-660015
   LET ps_sql = " SELECT gao01 FROM gao_file ORDER BY gao01"   #MOD-660015
 
   DECLARE p_module_item_cs CURSOR FROM ps_sql
 
   LET ps_values='' LET ps_items=''
 
   #FOREACH p_module_item_cs INTO pc_gaz01,pc_gaz03
   FOREACH p_module_item_cs INTO pc_gao01
      IF pi_type = 1 THEN 
         #LET ps_values=ps_values,UPSHIFT(pc_gaz01) CLIPPED,','
         LET ps_values=ps_values,UPSHIFT(pc_gao01) CLIPPED,','
      ELSE
         #LET ps_values=ps_values,pc_gaz01 CLIPPED,','
         LET ps_values=ps_values,pc_gao01 CLIPPED,','
      END IF
      #LET ps_items=ps_items,pc_gaz01 CLIPPED,' ',pc_gaz03 CLIPPED,','
      LET ps_items=ps_items,pc_gao01 CLIPPED,','
   END FOREACH
   LET pi_i = ps_values.getLength()
   LET ps_values = ps_values.subString(1,pi_i-1)
   LET pi_i = ps_items.getLength()
   LET ps_items = ps_items.subString(1,pi_i-1)
   CALL cl_set_combo_items(ps_field_name, ps_values, ps_items)
   RETURN
END FUNCTION
 
