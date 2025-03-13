# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asft622.4gl
# Descriptions...: 拆件式工單完工入庫維護作業        
# Date & Author..: 98/06/10 By Star
# Modify.........: copy from aimt370                               
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-730075 07/04/02 By kim 行業別架構
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasft622.global"
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0090
    DEFINE g_cmd   	LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(10)
    DEFINE g_argv1 	LIKE ksc_file.ksc01  #No.FUN-630010
    DEFINE g_argv2      STRING               #No.FUN-630010
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680121 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)     #No.FUN-630010
   LET g_argv2 = ARG_VAL(2)     #No.FUN-630010
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW t622_w AT p_row,p_col WITH FORM "asf/42f/asft622"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL sasft622('1',g_argv1,g_argv2)   #No.FUN-630010
 
   CLOSE WINDOW t622_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
