# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmt270.4gl
# Descriptions...: 庫存雜項發料/收料維護作業
# Date & Author..: 06/01/18 By Tracy
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE p_row,p_col     LIKE type_file.num5           #No.FUN-680120 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6B0014
    DEFINE g_cmd   	LIKE type_file.chr8            #No.FUN-680120 VARCHAR(10)
    DEFINE g_argv1 	LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)	
    DEFINE l_chr 	LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    
    CASE WHEN g_argv1 = '1' LET g_cmd ='atmt243'
         WHEN g_argv1 = '3' LET g_cmd ='atmt244'
 
         OTHERWISE 
              PROMPT "This program must follow 1/3 parameter:"
                 FOR CHAR g_argv1 
    END CASE
 
    CASE WHEN g_argv1 = '1' LET g_prog='atmt243'
         WHEN g_argv1 = '3' LET g_prog='atmt244'
 
    END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
 
   OPEN WINDOW t270_w AT p_row,p_col WITH FORM "atm/42f/atmt270"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_set_locale_frm_name("atmt270")    
   CALL cl_ui_init()
   
   CALL t270(g_argv1)
 
   CLOSE WINDOW t270_w                           #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
