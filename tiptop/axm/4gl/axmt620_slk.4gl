# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt620.4gl
# Descriptions...: 出貨單維護作業
# Date & Author..: 95/01/05 By Roger
# Modify.........: No.FUN-4A0081 05/08/09 By saki 指定單據編號、執行功能
# Modify.........: No.TQC-640011 06/03/01 By echo 將單號cahr(10)放大至char(16)
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710016 07/01/19 By kim GP3.6 行業別架構
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
# Modify.........: No.FUN-7C0017 08/02/20 By bnlent axmt620.4gl-> axmt620.src.4gl 
# Modify.........: No.FUN-840012 08/10/08 By kim mBarcode 功能修改
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10080 10/01/10 By destiny 取货机构调整为noentry
# Modify.........: No:CHI-A40068 10/05/26 By Summer 變更"串查button真正對應的程式
# Modify.........: No.FUN-A60035 10/07/09 By hongmei 行业别架构
# Modify.........: No.FUN-B90104 11/10/20 By huangrh GP5.3服飾版本開發
# Modify.........: No.FUN-C20006 12/02/03 By xjll 增加g_azw.azw04='2' 判斷

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt600.global"
 
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF FGL_GETENV("FGLGUI") <> "0" THEN   #No.FUN-840012
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP,
          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
      DEFER INTERRUPT
   END IF

   LET g_prog = 'axmt620_slk'   #No.FUN-A60035
 
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
 
   LET p_row = 2 LET p_col = 3
   
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN #FUN-840012
     IF g_azw.azw04='2' THEN     #FUN-C20006--add
        OPEN WINDOW t610_w AT p_row,p_col WITH FORM "axm/42f/axmt620_slk"  #FUN-B90104---add
           ATTRIBUTE (STYLE = g_win_style CLIPPED)                         #FUN-B90104---add
#FUN-C20006---add--------------
     ELSE
        OPEN WINDOW t620_w AT p_row,p_col WITH FORM "axm/42f/axmt620"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
     END IF
#FUN-C20006--end---------------     
      
      CALL cl_ui_init()

       #CHI-A40068 add --start--
       CASE g_sma.sma124  
          WHEN 'std'
             CALL cl_reset_qry_btn("oga011,oga16,ogb31","axmt610,axmt410,axmt410")
          WHEN 'icd' 
             CALL cl_reset_qry_btn("oga011,oga16,ogb31,b2_31","axmt610_icd,axmt410_icd,axmt410_icd,axmt410_icd")
          WHEN 'slk'
             CALL cl_reset_qry_btn("oga011,oga16,ogb31","axmt610_slk,axmt410_slk,axmt410_slk")
       END CASE
       #CHI-A40068 add --end--
   END IF

   CALL cl_set_comp_entry('oga84',FALSE)  #No.TQC-A10080
   CALL t600(2, g_argv1, g_argv2)   #No.FUN-4A0081
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN #FUN-840012
      CLOSE WINDOW t620_w                 #結束畫面
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
END MAIN
