# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asrt320.4gl
# Descriptions...: 重複性生產完工入庫維護作業
# Date & Author..: 06/02/10 By kim
# Modify.........: copy from asft620
# Modify.........: No.TQC-630154 06/03/14 By kim 流程訊息通知功能
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-730075 07/04/02 By kim 行業別架構
# Modify.........: No.FUN-840012 08/10/07 By kim 增加自動確認功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BC0104 12/01/11 By xujing 隱藏sfv46,qcl02,sfv47,QC_determine_storage
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../asf/4gl/sasft620.global"
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6B0014
    DEFINE g_cmd   	LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(10)
    DEFINE g_argv1 	LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
    DEFINE g_argv2 	LIKE sfu_file.sfu01
    DEFINE g_argv3      STRING                       #TQC-630154
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680130 SMALLINT
 
    IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    END IF
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
   #No.TQC-630154 --start--
   LET g_argv2 = ARG_VAL(1)
   LET g_argv3 = ARG_VAL(2)
   #No.TQC-630154 ---end---
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6B0014
 
    LET p_row = 3 LET p_col = 2
  
    IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
       OPEN WINDOW t320_w AT p_row,p_col WITH FORM "asf/42f/asft620"
             ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
       CALL cl_set_locale_frm_name("asft620")
       CALL cl_ui_init()
       CALL cl_set_comp_visible('sfv46,qcl02,sfv47',FALSE)   #FUN-BC0104
       CALL cl_set_act_visible('qc_determine_storage',FALSE) #FUN-BC0104
    END IF
 
    LET g_argv2 = ARG_VAL(1)
    CALL sasft620('3',g_argv2,g_argv3)
 
    IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
       CLOSE WINDOW t320_w                 #結束畫面
    END IF
 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
END MAIN
