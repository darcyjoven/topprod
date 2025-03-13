# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt640.4gl
# Descriptions...: 借貨出貨單維護作業
# Date & Author..: No.FUN-740016 07/04/18 By Nicola 
# Modify.........: No.FUN-850128 08/05/26 by sherry  重新過單
# Modify.........: No.FUN-920207 09/03/02 by jan axmt640.4gl-->axmt640.src.4gl
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-970017 10/04/02 By Lilan EasyFlow 自動執行確認功能
# Modify.........: No.FUN-A60035 10/07/09 By hongmei 行业别架构
# Modify.........: No:FUN-B90104 12/01/30 By huangrh 服飾打開服飾專用（二維）畫面檔
# Modify.........: No:FUN-C20006 12/02/06 By xjll     增加g_azw.azw04='2' 服飾判斷 
# Modify.........: No:TQC-C30114 12/03/07 By lixiang 服飾流通借貨出貨單

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt600.global"
 
MAIN   #No.FUN-740016
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
  #判斷當不是背景執行程式，才定義系統畫面預設值。
   IF FGL_GETENV("FGLGUI") <> "0" THEN      #FUN-970017 add
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP,
         FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
   END IF                                   #FUN-970017 add

   DEFER INTERRUPT
 
   LET g_prog = 'axmt640_slk'   #FUN-A60035
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

  #判斷當 g_bgjob = 'N' OR cl_null(g_bgjob) 時, 才 OPEN WINDOW 及 CALL cl_ui_init()
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN      #FUN-970017 add 
     LET p_row = 2 LET p_col = 3
      IF g_azw.azw04='2' THEN                                            #FUN-C20006---add
         OPEN WINDOW t640_w AT p_row,p_col WITH FORM "axm/42f/axmt620_slk"  #FUN-B90104---add
            ATTRIBUTE (STYLE = g_win_style CLIPPED)                         #FUN-B90104---add
#FUN-C20006--begin-------------------
      ELSE
         OPEN WINDOW t640_w AT p_row,p_col WITH FORM "axm/42f/axmt620"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
     END IF
#FUN-C20006---end--------------------------
   
     CALL cl_ui_init()
   END IF                                       #FUN-970017 add

   CALL t600('A', g_argv1, g_argv2)
 
   CLOSE WINDOW t640_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
#No.FUN-850128  重新過單
#TQC-C30114
