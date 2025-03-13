# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqct110.4gl
# Descriptions...: IQC 品質記錄維護作業
# Note...........: 原aqct110已改為saqct110
# Date & Author..: 06/02/09 By kim
# Modify.........: No.TQC-630027 06/03/06 視窗標題為FQC倉庫品質管理記錄,而非IQC aqct110品質管理記錄
# Modify.........: No.FUN-680011 06/08/08 by Echo SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-680104 06/09/18 By Czl  類型轉換,改為LIKE
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-830131 08/03/28 By mike 新增行業別架構
# Modify.........: No.TQC-8C0052 09/01/15 By kim icd欄位放大 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0085
    DEFINE p_argv1	LIKE type_file.chr1         #No.FUN-680104 VARCHAR(01)
    DEFINE p_argv2	LIKE qcs_file.qcs01            #FUN-680011
    DEFINE p_argv3	LIKE qcs_file.qcs02            #FUN-680011
    DEFINE p_argv4	LIKE qcs_file.qcs05            #FUN-680011
    DEFINE p_argv5	STRING                         #FUN-680011
    DEFINE p_argv6	LIKE qcs_file.qcs00            #FUN-680011
    DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680104 SMALLINT
 
    #FUN-680011
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP
    END IF
    #END FUN-680011
 
    DEFER INTERRUPT
 
   LET p_argv1=ARG_VAL(1)
   #FUN-680011
   LET p_argv2=ARG_VAL(2)                       #來源單號
   LET p_argv3=ARG_VAL(3)                       #來源項次
   LET p_argv4=ARG_VAL(4)                       #分批順序
   LET p_argv5=ARG_VAL(5)                       #功能選項(SPC)
   LET p_argv6=ARG_VAL(6)                       #資料來源
   #END FUN-680011
 
#No.FUN-830131  --BEGIN  
#------------No.TQC-630027 add
#    CASE WHEN p_argv1='1' LET g_prog='aqct110'
#         WHEN p_argv1='2' LET g_prog='aqct700'
#         WHEN p_argv1='3' LET g_prog='aqct800'
#    END CASE
#------------No.TQC-630027 end
   CASE p_argv1
        WHEN p_argv1='1' LET g_prog='aqct110_icd'                                                                                      
        WHEN p_argv1='2' LET g_prog='aqct700_icd'                                                                                      
        WHEN p_argv1='3' LET g_prog='aqct800_icd'                                                                                      
   END CASE     
#No.FUN-830131  --end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0085
 
   #FUN-680011
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
      LET p_row = 3 LET p_col = 20
      
      OPEN WINDOW t110_w AT p_row,p_col WITH FORM "aqc/42f/aqct110"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      #END FUN-680011
       
      CALL cl_set_locale_frm_name("aqct110")
      CALL cl_ui_init()
   END IF
   #FUN-680011
 
   CALL t110(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6) #FUN-5C0114       #FUN-680011
   CLOSE WINDOW t110_w                #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0085
END MAIN
#TQC-8C0052
