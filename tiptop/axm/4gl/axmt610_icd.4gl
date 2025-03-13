# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt610.4gl
# Descriptions...: 出貨通知單維護作業
# Date & Author..: 95/01/05 By Roger
# Modify.........: No.FUN-4A0081 05/08/09 By saki 指定單據編號、執行功能
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710016 07/01/19 By kim GP3.6 行業別架構
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
# Modify.........: No.FUN-7C0017 08/02/20 By bnlent axmt610.4gl-> axmt610.src.4gl 
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970017 10/04/01 By Lilan EasyFlow 自動執行確認功能 
# Modify.........: No:CHI-A40068 10/05/26 By Summer 變更"串查button真正對應的程式
# Modify.........: No.FUN-A60035 10/07/09 By hongmei 行业别架构
# Modify.........: No.FUN-B90104 11/10/20 By huangrh GP5.3服飾版本開發
# Modify.........: No.FUN-C20006 12/02/03 By xjll 增加g_azw.azw04='2' 判斷
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt600.global"
 
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680137 SMALLINT

   #判斷當不是背景執行程式，才定義系統畫面預設值。
   IF FGL_GETENV("FGLGUI") <> "0" THEN      #FUN-970017 add  
     OPTIONS                                #改變一些系統預設值
         INPUT NO WRAP,
         FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
   END IF                                   #FUN-970017 add

   DEFER INTERRUPT

   LET g_prog = 'axmt610_icd'   #No.FUN-7C0017

 
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
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-970017 add
      LET p_row = 2 LET p_col = 3
     #OPEN WINDOW t610_w AT p_row,p_col WITH FORM "axm/42f/axmt610" #FUN-710016
      OPEN WINDOW t610_w AT p_row,p_col WITH FORM "axm/42f/axmt620" #FUN-710016
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_init()
       #CHI-A40068 add --start--
       CASE g_sma.sma124  
          WHEN 'std'
             CALL cl_reset_qry_btn("oga011,oga16,ogb31","axmt620,axmt410,axmt410")
          WHEN 'icd' 
             CALL cl_reset_qry_btn("oga011,oga16,ogb31,b2_31","axmt620_icd,axmt410_icd,axmt410_icd,axmt410_icd")
          WHEN 'slk'
             CALL cl_reset_qry_btn("oga011,oga16,ogb31","axmt620_slk,axmt410_slk,axmt410_slk")
       END CASE
       #CHI-A40068 add --end--
    END IF                              #FUN-970017 add 

    CALL t600(1, g_argv1, g_argv2)      #No.FUN-4A0081
    CLOSE WINDOW t610_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
