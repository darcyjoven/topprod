# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# PATTERN NAME...: abat171.4gl
# DESCRIPTIONS...: 採購入庫-批序號條碼掃瞄作業
# DATE & AUTHOR..: No:DEV-D40001 2013/04/08 By TSD.JIE


DATABASE ds

GLOBALS "../../config/top.global"

MAIN
DEFINE p_row,p_col     LIKE type_file.num5

   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP
      DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
      RETURNING g_time

   CALL sabat021()

   CALL cl_used(g_prog,g_time,2)        #計算使用時間 (退出使間)
      RETURNING g_time
END MAIN
#DEV-D40001--add

