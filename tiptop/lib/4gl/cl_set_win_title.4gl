# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_win_title.4gl
# Descriptions...: 專門用於 OPEN WINDOW 但沒有 FORM 的 title 語言轉換
# Date & Author..: 04/02/28 by alex
# Usage..........: CALL cl_set_win_title(lc_frm_name)
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
##################################################
# Descriptions...: 專門用於 OPEN WINDOW 但沒有 FORM 的 title 語言轉換
# Input Parameter: lc_frm_name 畫面檔檔名
# Return code....: void
# Memo...........: 此名稱必需先設定於 p_perlang
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
##################################################
 
FUNCTION cl_set_win_title(lc_frm_name)
 
  DEFINE lw_window    ui.Window
  DEFINE lc_frm_name  LIKE gae_file.gae01
  DEFINE lc_title     LIKE gae_file.gae04
  DEFINE ls_sql       STRING
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  # 2004/02/17 by hjwang: 開子畫面時應選擇 Current Window Node
  LET lw_window = ui.Window.getCurrent()
 
  # 2003/02/27 by alex : 選出 window title
  LET ls_sql = " SELECT gae04 FROM gae_file ",
                " WHERE gae01 = ? AND gae02 = 'wintitle' AND gae03 = ? "
 
  PREPARE lcurs_wintitle_pre FROM ls_sql
  EXECUTE lcurs_wintitle_pre USING lc_frm_name, g_lang
     INTO lc_title
 
  IF NOT cl_null(lc_title) THEN
     CALL lw_window.setText(lc_title CLIPPED)
  END IF
 
  RETURN
 
END FUNCTION
