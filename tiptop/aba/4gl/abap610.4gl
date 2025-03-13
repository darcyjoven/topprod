# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: abap610
# DESCRIPTIONS...: 出貨配貨單產生作業
# DATE & AUTHOR..: No:DEV-CB0001 2012/11/05 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"
    
DEFINE p_row,p_col     LIKE type_file.num5    
DEFINE g_argv1         LIKE ogb_file.ogb01
DEFINE g_argv2         LIKE ogb_file.ogb03
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
   WHENEVER ERROR CONTINUE 
  
   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)RETURNING g_time   
       
   LET g_argv1  = ARG_VAL(1)
   LET g_argv2  = ARG_VAL(2)

   CALL sabap600(g_argv1,g_argv2,'axmt610')
   
   CALL cl_used(g_prog,g_time,2)RETURNING g_time   

END MAIN 
#DEV-CB0001--add
#DEV-D30025--add
