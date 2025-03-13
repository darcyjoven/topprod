# Prog. Version..: '5.30.09-13.09.06(00000)'     #
#
# Pattern name...: aapt140.4gl
# Descriptions...: 客戶費用報銷
# Date & Author..: 13/07/04 By zhangweib   FUN-D70028

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   g_argv1         LIKE type_file.chr20       # 單號   FUN-D70028
DEFINE   g_argv2         LIKE type_file.chr1000     # 執行功能
DEFINE   g_argv3         STRING
DEFINE   g_argv4         STRING
MAIN

   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS
      INPUT NO WRAP
   END IF

   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time

   CALL t110('14',g_argv1,g_argv2,g_argv3,g_argv4)
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN
