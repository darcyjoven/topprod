# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt810.4gl
# Descriptions...: 三角貿易一般訂單維護作業
# Date & Author..: 95/01/05 By Roger
# Modify.........: NO.FUN-610055 06/02/20 By elva 新增使用分銷功能參數判斷  
# Modify.........: No.FUN-630010 06/03/10 By saki 流程訊息通知功能
# Modify.........: No.FUN-640024 06/04/07 By Echo satmt230()新增流程訊息通知功能
# Modify.........: No.FUN-640248 06/05/26 By Echo 自動執行確認功能
# Modify.........: No.FUN-650108 06/06/26 By Rayven 訂單合并，以后都調用saxmt400
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6C0006 07/01/10 By kim GP3.6產業別程式模組化
# Modify.........: No.FUN-710037 07/01/17 By kim GP3.6產業別程式模組化
# Modify.........: No.FUN-720009 07/02/09 By kim 行業別架構變更
# Modify.........: No.FUN-730018 07/03/08 By kim 行業別使用p_per設定
# Modify.........: No.FUN-7C0017 08/03/04 By bnlent axmt810.4gl-> axmt810.src.4gl 
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B90101 12/01/30 By lixiang 服飾二維的開發
# Modify.........: No:TQC-C30114 12/03/07 By lixiang 服飾流通三角貿易一般訂單
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt400.global"
 
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680137 SMALLINT

    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面會依照p_per設定的欄位順序做輸入，忽略INPUT寫的順序 #FUN-730018
       DEFER INTERRUPT
    END IF
 
   LET g_argv2 = ARG_VAL(1)                #No.FUN-630010
   LET g_argv3 = ARG_VAL(2)                #No.FUN-630010
 
 
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
        #OPEN WINDOW t810_w AT p_row,p_col WITH FORM "axm/42f/axmt810" #FUN-710037
#FUN-B90101--add--begin--
#FUN-B90101--add--end--
         OPEN WINDOW t810_w AT p_row,p_col WITH FORM "axm/42f/axmt410" #FUN-710037
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#FUN-B90101 add  &endif
       CALL cl_ui_init()   
   END IF
   #END FUN-640248
 
    CALL t400(1,'Y',g_argv2,g_argv3)    #No.7946 call axmt400 加傳多角否 #No.FUN-630010
 
    CLOSE WINDOW t810_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
#TQC-C30114
