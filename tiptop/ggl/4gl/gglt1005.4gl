# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: gglt1005.4gl
# Descriptions...: 調整作業-损益结转
# Date & Author..: #FUN-B50001 11/05/03 By zhangweib 
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_argv1  LIKE asj_file.asj00,  #帳套 
       g_argv2  LIKE asj_file.asj01   #单号   #FUN-BB0036
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5   

   IF FGL_GETENV("FGLGUI") <> "0" THEN   
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP   ,                  #輸入的方式: 不打轉
          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序) 
   END IF
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 2 LET p_col = 3
   
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      OPEN WINDOW t0019_w AT p_row,p_col WITH FORM "ggl/42f/gglt1005"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
      CALL cl_ui_init()
   END IF
   CALL t001('1','W',g_argv1,g_argv2) 

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      CLOSE WINDOW t0019_w                 #結束畫面
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN
#FUN-B50001
