# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmt321.4gl
# Descriptions...: 配送單維護作業
# Date & Author..: 06/04/03 By Sarah
# Modify.........: No.FUN-680120 06/09/01 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-710016 07/01/19 By kim GP3.6 行業別架構
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../axm/4gl/saxmt600.global" #FUN-730018
 
DEFINE g_argv1	LIKE oea_file.oea01           #No.FUN-680120 VARCHAR(16)
DEFINE g_argv2  STRING  
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6B0014
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
 
 
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW t321_w AT p_row,p_col WITH FORM "atm/42f/atmt321"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
        
   CALL t600(' ', g_argv1, g_argv2)
   CLOSE WINDOW t321_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
