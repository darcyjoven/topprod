# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmp811.4gl
# Descriptions...: 多角訂單結案
# Date & Author..: FUN-690089 06/10/05 by yiting 
# Modify.........: No.FUN-6A0094 06/11/07 By yjkhero l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
   CALL p811(1)  
   CLOSE WINDOW p811_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
