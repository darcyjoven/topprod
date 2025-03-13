# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_combo_lang.4gl
# Descriptions...: 動態設定有選擇語言別資料的ComboBox語言選項
# Date & Author..: 03/07/02 by Hiko
# Usage..........: CALL cl_set_combo_lang("oea08")
# Modify.........: No.TQC-6A0008 06/10/31 alexstar 對搜尋資料做排序的動作
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-830021 08/03/05 By alex 取消 gay02 使用
# Modify.........: No:CHI-A80022 10/08/12 By jay 修改慣用語言別內容值呈現方式
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
# Descriptions...: 動態設定有選擇語言別資料的ComboBox語言選項
# Input Parameter: ps_field_name
# Return Code....:
 
FUNCTION cl_set_combo_lang(ps_field_name)
   DEFINE ps_values,ps_items  STRING
   DEFINE ps_field_name       STRING
   DEFINE pc_gay01            LIKE gay_file.gay01
   DEFINE pc_gay03            LIKE gay_file.gay03
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   DECLARE p_lang_item_cs CURSOR FOR SELECT gay01, gay03 FROM gay_file
                                      WHERE gayacti = "Y"
                                      ORDER BY gay01   #TQC-6A0008
#                                   # WHERE gay02 = g_lang   #FUN-830021
   IF SQLCA.SQLCODE THEN
      CALL cl_err("gay_file", "lib-044", 1)
      RETURN
   END IF
 
   LET ps_values = '' 
   LET ps_items = ''
 
   FOREACH p_lang_item_cs INTO pc_gay01, pc_gay03
      LET ps_values = ps_values, pc_gay01, ','
      LET ps_items = ps_items, pc_gay01, ':', pc_gay03 CLIPPED, ','    #CHI-A80022 在gay01和gay03原本空白處加入冒號(:)
   END FOREACH
   LET ps_values = ps_values.subString(1, ps_values.getLength() - 1)
   LET ps_items = ps_items.subString(1, ps_items.getLength() - 1)
   CALL cl_set_combo_items(ps_field_name, ps_values, ps_items)
END FUNCTION
 
