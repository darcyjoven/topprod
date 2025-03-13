# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmq631.4gl
# Descriptions...: Qry Product S/N Raw Mat. Detail
# Date & Author..: 99/05/27 By Carol
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_argv1     LIKE she_file.she02   #產品序號
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW q631_w WITH FORM "axm/42f/axmq631"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL axmq631(g_argv1)
 
   CLOSE WINDOW q631_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
