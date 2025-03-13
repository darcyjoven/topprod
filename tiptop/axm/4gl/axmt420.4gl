# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt420.4gl
# Descriptions...: 借貨訂單維護作業
# Date & Author..: No.FUN-740016 07/04/16 By Nicola 借出管理
# Modify.........: No.FUN-7C0017 08/03/04 By bnlent axmt420.4gl-> axmt420.src.4gl 
# Modify.........: No.FUN-850128 08/05/26 By sherry 重新過單
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-BC0035 11/12/07 By destiny 栏位录入顺序不对
# Modify.........: No:FUN-B90101 12/01/31 By lixiang 服飾打開服飾專用（二維）畫面檔
# Modify.........: No:TQC-C30114 12/03/07 By lixiang 服飾流通借貨訂單
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt400.global"
 
MAIN      #No.FUN-740016
 
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
         INPUT NO WRAP 
         #FIELD ORDER FORM                   #整個畫面會依照p_per設定的欄位順序做輸入，忽略INPUT寫的順序 #FUN-730018 #TQC-BC0035
      DEFER INTERRUPT
   END IF
 
   LET g_argv2 = ARG_VAL(1)
   LET g_argv3 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      LET p_row = 2 LET p_col = 2

      OPEN WINDOW t420_w AT p_row,p_col WITH FORM "axm/42f/axmt410"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
 
   END IF
       
   CALL t400(2,'N',g_argv2,g_argv3)
 
   CLOSE WINDOW t420_w 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
#No.FUN-850128  重新過單
#TQC-C30114
