# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt628.4gl
# Descriptions...: 客戶驗收單維護作業
# Date & Author..: 06/01/11 By Carrier 
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710016 07/01/19 By kim GP3.6 行業別架構
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
# Modify.........: No.CHI-740014 07/04/17 By kim 行業別架構
# Modify.........: No.FUN-7C0017 08/02/20 By bnlent axmt628.4gl-> axmt628.src.4gl 
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-970017 10/04/02 By Lilan EasyFlow 自動執行確認功能
# Modify.........: No.FUN-A60035 10/07/09 By hongmei 行业别架构
# Modify.........: No:FUN-B90104 12/01/30 By huangrh 服飾打開服飾專用（二維）畫面檔
# Modify.........: No:TQC-C30114 12/03/07 By lixiang 服飾流通客戶驗收單
# Modify.........: No:FUN-C50097 12/06/20 By SunLM   調整畫面錄入順序,不依照FIELD ORDER
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt600.global" #FUN-730018
 
DEFINE g_argv1	LIKE oea_file.oea01      # No.FUN-680137   VARCHAR(16)
DEFINE g_argv2  STRING    #No.FUN-4A0081
 
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680137 SMALLINT

   #判斷當不是背景執行程式，才定義系統畫面預設值。
    IF FGL_GETENV("FGLGUI") <> "0" THEN    #FUN-970017 add
       OPTIONS                             #改變一些系統預設值
           INPUT NO WRAP
          # FIELD ORDER FORM                #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #CHI-740014 #FUN-C50097
    END IF                                 #FUN-970017 add

    DEFER INTERRUPT
                                     
   LET g_prog = 'axmt628_slk'   #No.FUN-A60035
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
    END IF
 
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094

   #判斷當 g_bgjob = 'N' OR cl_null(g_bgjob) 時, 才 OPEN WINDOW 及 CALL cl_ui_init()
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN                          #FUN-970017 add 
      LET p_row = 2 LET p_col = 3
      OPEN WINDOW t628_w AT p_row,p_col WITH FORM "axm/42f/axmt628"  #FUN-710016
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      CALL cl_ui_init()
    END IF                                                           #FUN-970017 add
 
    CALL t600(8, g_argv1, g_argv2)   #No.FUN-4A0081
 
    CLOSE WINDOW t628_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
#TQC-C30114
