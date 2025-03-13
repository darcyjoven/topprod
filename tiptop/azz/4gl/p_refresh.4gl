# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_refresh.4gl
# Descriptions...: Refresh Screen
# Date & Author..: 00/10/02 By Raymon
# Modify.........: No.MOD-540140 05/04/20 By alex 取消 hlp 檔案
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0096
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW p_refresh_w WITH FORM "azz/42f/p_refresh"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CLOSE WINDOW p_refresh_w
END MAIN
 
