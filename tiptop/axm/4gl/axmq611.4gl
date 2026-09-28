# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axmq611.4gl
# Descriptions...: 訂單備置明細查詢
# Date & Author..: FUN_AC0074 11/04/29 By shenyang
# Modify.........: No.FUN-AC0074 11/04/29 By shenyang

DATABASE ds
 
GLOBALS "../../config/top.global"

MAIN
    DEFINE p_argv1      LIKE type_file.chr1            
    DEFINE p_argv2      LIKE ima_file.ima01           
    DEFINE p_row,p_col  LIKE type_file.num5             
    
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  
    DEFER INTERRUPT
 
     LET p_argv1 = ARG_VAL(1)
     LET p_argv2 = ARG_VAL(2) 
     CASE WHEN p_argv1='1' LET g_prog='asfq610'
          WHEN p_argv1='2' LET g_prog='axmq611'    
          WHEN p_argv1='3' LET g_prog='aimq611'  
          WHEN p_argv1='4' LET g_prog='asfq612'  
          OTHERWISE        LET p_argv2=ARG_VAL(2)
                     
     END CASE
    IF g_prog = 'asfq610' THEN
       LET p_argv1='1'
    END IF 
    IF g_prog = 'axmq611' THEN
       LET p_argv1='2'
    END IF 
    IF g_prog = 'aimq611' THEN
       LET p_argv1='3'
    END IF 
    IF g_prog = 'asfq612' THEN
       LET p_argv1='4'
    END IF     
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
     LET p_row = 4 LET p_col = 3
  
     OPEN WINDOW q610_w AT p_row,p_col
         WITH FORM "asf/42f/asfq610"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 

   CALL cl_set_locale_frm_name("asfq610")
   CALL cl_ui_init()
 
    CALL q610('2',p_argv2)      
    CLOSE WINDOW q610_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
#FUN-AC0074
