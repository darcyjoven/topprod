# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: abat3011
# DESCRIPTIONS...: 雜發條碼出庫作業
# DATE & AUTHOR..: No:DEV-CB0012 2012/11/13 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---

 
DATABASE ds

GLOBALS "../../config/top.global" 
 
DEFINE g_argv1         LIKE box_file.box01
DEFINE p_row,p_col     LIKE type_file.num5
 
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

   LET g_argv1 = ARG_VAL(1)
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
       RETURNING g_time    
   #DEV-CB0012--mark--begin
   #LET p_row = 3 LET p_col = 14
   #OPEN WINDOW t3011_w AT p_row,p_col WITH FORM "aba/42f/abap620"
   #      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   #CALL cl_ui_init()
   #DEV-CB0012--mark--begin

    CALL sabap620('3',g_argv1)
   #CLOSE WINDOW t3011_w                  #結束畫面 #DEV-CB0012--mark
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
       RETURNING g_time    
END MAIN 
#DEV-D30025--add
 

