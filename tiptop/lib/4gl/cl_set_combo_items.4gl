# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_combo_items.4gl
# Descriptions...: 動態設定ComboBox的Item.
# Date & Author..: 03/07/02 by Hiko
# Usage..........: CALL cl_set_combo_items("oea08", "1,2", "Local Order,Export Order")
# Modify.........: No.FUN-640240 06/05/17 Echo 自動執行確認功能
# Modify...... ..: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-740146 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-C20210 12/02/15 By tommas 若將值trim掉，料號前面空白會有問題
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
# Descriptions...: 設定ComboBox的Item.
# Date & Author..: 2003/07/02 by Hiko
# Input Parameter: ps_field_name STRING ComboBox所對應的欄位名稱
#                  ps_values STRING Item所對應的儲存值字串(中間以逗點分隔)
#                  ps_items SMALLINT Item字串(中間以逗點分隔)
# Return Code....: void
# Modify.........: MOD-520002 alex 刪除傳入值的空白尾碼
# Modify.........: MOD-540134 alex 同上
 
 
FUNCTION cl_set_combo_items(ps_field_name, ps_values, ps_items)
  DEFINE ps_field_name,ps_values,ps_items STRING
  DEFINE lcbo_target ui.ComboBox
  DEFINE lst_values,lst_items base.StringTokenizer
  DEFINE ls_msg     LIKE ze_file.ze03          #No.FUN-690005   VARCHAR(100)
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  #FUN-640240
  #IF g_bgjob = 'Y' THEN
  IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
 
     RETURN
  END IF
  #END FUN-640240
 
   #MOD-540134
  LET ps_field_name=ps_field_name.trim()
   #MOD-520002
  #LET ps_values=ps_values.trim()  #No.TQC-C20210
  #LET ps_items=ps_items.trim()    #No.TQC-C20210
 
  LET lcbo_target = ui.ComboBox.forName(ps_field_name)
 
  IF lcbo_target IS NULL THEN
    SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-031' AND ze02 = g_lang
    CALL cl_err(ps_field_name, "lib-031", 1)
    RETURN
  ELSE
    CALL lcbo_target.clear()
  END IF
 
  LET lst_values = base.StringTokenizer.create(ps_values, ",")
  LET lst_items = base.StringTokenizer.create(ps_items, ",")
 
  WHILE lst_values.hasMoreTokens()
    CALL lcbo_target.addItem(lst_values.nextToken(), lst_items.nextToken())
  END WHILE
END FUNCTION
