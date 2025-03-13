# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axmp910.4gl
# Descriptions...: 三角貿易出貨通知單拋轉作業(反向)
# Date & Author..: 06/08/10 BY yiting 
# Note...........: 由 axmp910 改寫
# Modify.........: No.FUN-680137 06/09/08 By ice 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710046 07/01/23 By yjkhero 錯誤訊息匯整 
# Modify.........: No.FUN-8A0086 08/10/20 By lutingting 如果是沒有let g_success == 'Y' 就寫給g_success 賦初始值，
#                                                       不然如果一次失敗，以后都無法成功
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60124 10/07/30 By Smapmin 修改訊息匯總
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-620029  --Begin
DEFINE g_argv1        LIKE oga_file.oga01
DEFINE g_argv2        LIKE oga_file.oga09
 
MAIN
   OPTIONS                                 #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
   LET g_success = 'Y'           #No.FUN-8A0086
   #CALL s_showmsg_init()         #NO.FUN-710046    #MOD-A60124
   CALL p910(g_argv1,g_argv2)
   #CALL s_showmsg()              #NO.FUN-710046    #MOD-A60124
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0094
 
END MAIN
#No.FUN-620029  --End
