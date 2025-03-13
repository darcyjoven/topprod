# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt360.4gl
# Descriptions...: 報價單資料維護作業
# Date & Author..: 00/02/29 By Gina
# Modify.........: No.FUN-560193 05/06/29 By kim 單身 '單位' 右邊增秀'計價單位'
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify.........: No.FUN-640248 06/05/26 By Echo 自動執行確認功能
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-730018 07/03/26 By kim 行業別架構
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt360.global"
 
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_argv1         LIKE oqt_file.oqt01    #No.FUN-630010
DEFINE g_argv2         LIKE type_file.chr1000 # No.FUN-680137     #No.FUN-630010
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0094
 
    #FUN-640248
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730018
    END IF
    #END FUN-640248
 
    DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)        #No.FUN-630010
   LET g_argv2 = ARG_VAL(2)        #No.FUN-630010
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
   #FUN-640248
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
      LET p_row = 2 LET p_col = 2
      OPEN WINDOW t360_w AT p_row,p_col WITH FORM "axm/42f/axmt360"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      
      CALL cl_ui_init()
 
   END IF
   #END FUN-640248
 
   #FUN-560193................begin
   IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
      CALL cl_set_comp_visible("ima908",FALSE)
   END IF
   #FUN-560193................end
       
   CALL t360(g_argv1,g_argv2)          #No.FUN-630010
   CLOSE WINDOW t360_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
