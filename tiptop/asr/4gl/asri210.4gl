# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asri210.4gl
# Descriptions...: ISSUE Note.
# Date & Author..: 06/01/17 By kim
# Modify.........: No.FUN-660166 06/06/26 By saki 流程訊息功能,調整參數數目
# Modify.........: No.TQC-660132 06/06/29 By Carol:TQC-660132 未改到,補上相關處理
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-730075 07/03/30 By kim 行業別架構
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AB0001 11/04/25 By Lilan 新增EF(EasyFlow)整合功能 

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../asf/4gl/sasfi501.global" #FUN-730075
 
MAIN
#  DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6B0014
   DEFINE p_argv2      LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
   DEFINE p_argv3	LIKE sfp_file.sfp01          #傳單號
   DEFINE p_argv4      STRING                       #No.TQC-660132   
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680130 SMALLINT 

   #判斷當不是背景執行程式，才定義系統畫面預設值。  #FUN-AB0001 add
   IF FGL_GETENV("FGLGUI") <> "0" THEN              #FUN-AB0001 add if 判斷 
      OPTIONS                            #改變一些系統預設值
          INPUT NO WRAP,                 #輸入的方式: 不打轉
          FIELD ORDER FORM               #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
      DEFER INTERRUPT
   END IF                                           #FUN-AB0001 add

   LET p_argv2=ARG_VAL(1)
   LET p_argv3=ARG_VAL(2)
   LET p_argv4=ARG_VAL(3)                #No.TQC-660132
 
   CASE WHEN p_argv2='A' LET g_prog='asri210'
        WHEN p_argv2='C' LET g_prog='asri230'
        OTHERWISE        LET g_prog='asri210'   #No.TQC-660132
                         LET p_argv4=p_argv3    #No.TQC-660132 因為asri210進來沒有第一參數
                         LET p_argv3=p_argv2    #No.TQC-660132
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6B0014
 
   LET p_row = 2 LET p_col = 2
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN          #FUN-AB0001 add if判斷 
      OPEN WINDOW i510_w AT p_row,p_col WITH FORM "asf/42f/asfi510"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
      #2004/06/02共用程式時呼叫
      CALL cl_set_locale_frm_name("asfi510")
      CALL cl_ui_init()
   END IF                                           #FUN-AB0001 add

   CALL i501('1', p_argv2,p_argv3,p_argv4)          #No.TQC-660132
   CLOSE WINDOW i510_w                              #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
END MAIN
