# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asfi610.4gl
# Descriptions...: 工單備置/退備置維護作業
# Date & Author..: 10/02/25 By Liuxqa
# Modify.........: No.FUN-A20048 10/02/25 By liuxqa  
# Modify.........: No.MOD-B30105 11/03/18 By lixh1
# Modify.........: No.FUN-AC0074 11/04/13 By lixh1 新增訂單備置(axmi611)雜發備置(aimi611)
# Modify.........: No.TQC-C60206 12/06/26 By lixh1 修改g_prog的賦值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasfi610.global"
 
MAIN
    DEFINE p_argv1      LIKE type_file.chr1           #傳備置/退備置 No.FUN-A20048 
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
    
    CASE WHEN p_argv1='1' LET g_prog='asfi611'
         OTHERWISE        LET g_prog='asfi610'
    #    OTHERWISE        LET g_prog='asfi611'  #FUN-AC0074  #TQC-C60206
 
                          LET p_argv2=ARG_VAL(2)
                          LET p_argv3=ARG_VAL(3)
                     
    END CASE

#TQC-C60206 ------Begin-------
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
#TQC-C60206 ------End---------

    #IF g_prog = 'asfi611' OR g_prog = 'asfi610' THEN
    IF g_prog = 'asfi611' THEN
       LET p_argv1='1'
    END IF  
 
#TQC-C70141 -----Begin--------
#  IF (NOT cl_user()) THEN
#     EXIT PROGRAM
#  END IF
#TQC-C70141 -----End----------
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
#MOD-B30105 --------------------Begin--------------------------
   IF g_prog='asfi610' THEN
      CALL cl_err('','asf-172',1)                               
      EXIT PROGRAM                       
   END IF  
#MOD-B30105 --------------------End----------------------------
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
    
   LET p_row = 2 LET p_col = 2
 
   OPEN WINDOW i610_w AT p_row,p_col WITH FORM "asf/42f/asfi610"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_set_locale_frm_name("asfi610")
   CALL cl_ui_init()
 
  #CALL i610(p_argv1,p_argv2,p_argv3)   #FUN-AC0074
   CALL i610('1',p_argv2,p_argv3)       #FUN-AC0074    
    CLOSE WINDOW i610_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
