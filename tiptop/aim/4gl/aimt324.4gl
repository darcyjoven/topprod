# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimt324.4gl
# Descriptions...: 庫存直接調撥作業
# Date & Author..: 11/12/16 by Jason
# Modify.........: No:FUN-BC0036 by jason 原程式拆至saimt324.src.4gl
# Modify.........: No:FUN-C30140 12/03/13 By Mandy 簽核時,自動確認失敗,原因:參數定義錯誤

DATABASE ds

GLOBALS "../../config/top.global"

MAIN
DEFINE p_argv1 LIKE imm_file.imm01
#FUN-C30140---mod---str----
#DEFINE p_argv2 LIKE type_file.chr1
#DEFINE p_argv3 STRING
 DEFINE p_argv2 STRING              #Action ID
 DEFINE p_argv3 LIKE type_file.chr1 #借出管理flag
#FUN-C30140---mod---end----

   WHENEVER ERROR CALL cl_err_msg_log
   
   IF FGL_GETENV("FGLGUI") <> "0" THEN   
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP   ,                  #輸入的方式: 不打轉
          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730061
      DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   LET p_argv1=ARG_VAL(1)
   LET p_argv2=ARG_VAL(2)   #Action ID
   LET p_argv3=ARG_VAL(3)   #借出管理flag      
  
   

   LET g_prog = "aimt324"   

   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   IF (NOT cl_setup("AIM")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   CALL t324('1',p_argv1,p_argv2,p_argv3)

END MAIN
#FUN-BC0036
