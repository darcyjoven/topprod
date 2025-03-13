# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asrt300.4gl
# Descriptions...: 生產報工維護作業
# Date & Author..: 06/06/05 By kim
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6B0014
    DEFINE g_cmd   	LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(10)
    DEFINE g_argv1 	LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
    DEFINE g_argv2 	LIKE srf_file.srf01
    DEFINE g_argv3      STRING                                     
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680130 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_argv2 = ARG_VAL(1)
   LET g_argv3 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6B0014
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW t300_w AT p_row,p_col WITH FORM "asr/42f/asrt300"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
    CALL sasrt300('1',g_argv2,g_argv3)
 
    CLOSE WINDOW t300_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
END MAIN
