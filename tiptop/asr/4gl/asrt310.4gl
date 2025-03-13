# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asrt310.4gl
# Descriptions...: FQC維護作業
# Date & Author..: 06/02/09 By kim
# Modify.........: No.FUN-680011 06/08/08 by Echo SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-680130 06/09/15 By Xufeng 字段類型定義改為LIKE     
 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6B0014
    DEFINE p_argv1      LIKE qcs_file.qcs01
    DEFINE p_argv2      LIKE qcs_file.qcs02         #FUN-680011
    DEFINE p_argv3      LIKE qcs_file.qcs05         #FUN-680011
    DEFINE p_argv4      STRING                      #FUN-680011
    DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680130 SMALLINT 
 
    #FUN-680011
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP
       DEFER INTERRUPT
    END IF
    #END FUN-680011
 
 
   LET p_argv1=ARG_VAL(1)                                        #來源單號
   LET p_argv2=ARG_VAL(2)                            #FUN-680011 #來源項次
   LET p_argv3=ARG_VAL(3)                            #FUN-680011 #分批順序
   LET p_argv4=ARG_VAL(4)                            #FUN-680011 #功能
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6B0014
 
   #FUN-680011
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
      LET p_row = 3 LET p_col = 20
   
      OPEN WINDOW t110_w AT p_row,p_col WITH FORM "aqc/42f/aqct110"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
      CALL cl_set_locale_frm_name("aqct110")
      CALL cl_ui_init()
   END IF
   #FUN-680011
 
   CALL t110('4',p_argv1,p_argv2,p_argv3,p_argv4,'')
   CLOSE WINDOW t110_w                #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
END MAIN
