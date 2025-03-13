# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aict044.4gl (copy from apmt723.4gl)
# Descriptions...: WAFER倉退資料維護作業
# Date & Author..: 08/02/12 By kim (FUN-810038)
# Modify.........: No.FUN-840012 08/10/03 By kim mBarcode整合
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AB0023 11/03/17 By Lilan EF整合功能(EasyFlow) 

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../apm/4gl/sapmt720.global"
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP,
          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)
      DEFER INTERRUPT
   END IF
 
   LET g_argv1 = '3'                  #參數-1(異動狀況)
   LET g_argv2 = ARG_VAL(1)           #驗收單號
   LET g_argv3 = ' '                  #參數-2(驗收單號)
   LET g_argv4 = ARG_VAL(2)           #執行功能


   LET g_argv1 = '3'                  #參數-1(異動狀況) 
  #FUN-AB0023 mark str -----
  #LET g_argv2 = ARG_VAL(1)           #驗收單號
  #LET g_argv3 = ' '                  #參數-2(驗收單號)
  #LET g_argv4 = ARG_VAL(2)           #執行功能 
  #FUN-AB0023 mark end -----
  #FUN-AB0023 add str ------
   LET g_argv5 = ARG_VAL(1)           #異動單號(rvu01)
   LET g_argv4 = ARG_VAL(2)           #執行功能(Action ID)
   LET g_argv2 = ARG_VAL(3)           #驗收單號(rvu02)
  #FUN-AB0023 add end ------
   LET g_argv3 = 'ICD'                #參數-3(性質)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL t720(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5)  #FUN-AB0023 mod:增加g_argv5

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-810038
