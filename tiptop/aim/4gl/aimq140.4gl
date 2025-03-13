# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimq140.4gl
# Descriptions...: 料件請購量明細查詢
# Date & Author..: 96/07/25 By Melody
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE 
        g_ima       RECORD LIKE ima_file.*,
        g_argv1     LIKE ima_file.ima01,      # INPUT ARGUMENT - 1
        g_ima01     LIKE ima_file.ima01,      # 所要查詢的key
        g_sql       string                    #No.FUN-580092 HCN
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL aimq140(g_argv1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
