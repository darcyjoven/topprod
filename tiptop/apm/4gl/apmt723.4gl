# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt720.4gl
# Descriptions...: 入庫資料維護作業
# Date & Author..: 2011/04/19 By shiwuying FUN-B40031

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt720.global"
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP,
          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730068
      DEFER INTERRUPT
   END IF
 
   LET g_argv5 = ARG_VAL(1)               #異動單號(rvu01)
   LET g_argv4 = ARG_VAL(2)               #執行功能(Action ID)
   LET g_argv2 = ARG_VAL(3)               #驗收單號(rvu02)
   LET g_argv1 = ARG_VAL(4)               #異動狀態[狀況碼]

   LET g_argv3 = ' '                      #參數-3(性質)          
   LET g_argv1 = 'A'
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL t720(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5)

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-B40031
