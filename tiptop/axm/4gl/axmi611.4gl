# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axmi611.4gl
# Descriptions...: 訂單備置/退備置維護作業
# Date & Author..: 11/04/29 By lixh1
# Modify.........: No.FUN-AC0074 11/04/29 By lixh1 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../asf/4gl/sasfi610.global"
 
MAIN
    DEFINE p_argv1      LIKE type_file.chr1           #傳備置/退備置 
    DEFINE p_argv2      LIKE sia_file.sia01           #備置單號 
    DEFINE p_argv3      STRING 
    DEFINE p_row,p_col  LIKE type_file.num5             
    
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT
 
   LET p_argv1=ARG_VAL(1)
   LET p_argv2=ARG_VAL(2)
   LET p_argv3=ARG_VAL(3)
    
    CASE WHEN p_argv1='2' LET g_prog='axmi611'
         OTHERWISE        LET g_prog='axmi611'
                          LET p_argv2=ARG_VAL(2)
                          LET p_argv3=ARG_VAL(3)
                     
    END CASE

    IF g_prog = 'axmi611' THEN
       LET p_argv1='2'
    END IF  


 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
    
   LET p_row = 2 LET p_col = 2
 
   OPEN WINDOW i610_w AT p_row,p_col WITH FORM "asf/42f/asfi610"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_set_locale_frm_name("asfi610")
   CALL cl_ui_init()
 
   #CALL i610(p_argv1,p_argv2,p_argv3)  #FUN-AC0074
    CALL i610('2',p_argv2,p_argv3)      #FUN-AC0074    
    CLOSE WINDOW i610_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
