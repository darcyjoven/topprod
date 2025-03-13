# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asrt300.4gl
# Descriptions...: 工單生產報工維護作業
# Date & Author..: 06/06/05 By kim
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-730075 07/03/30 By kim 行業別架構
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../asr/4gl/sasrt300.global" #FUN-730075
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0090
    DEFINE g_cmd   	LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(10)
    DEFINE g_argv1 	LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
    DEFINE g_argv2 	LIKE srf_file.srf01
    DEFINE g_argv3      STRING
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680121 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
 
    DEFER INTERRUPT
 
   LET g_argv2 = ARG_VAL(1)
   LET g_argv3 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0090
 
   LET p_row = 3 LET p_col = 2
 
   OPEN WINDOW t300_w AT p_row,p_col WITH FORM "asr/42f/asrt300"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   CALL sasrt300('2',g_argv2,g_argv3)
 
   CLOSE WINDOW t300_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0090
END MAIN
