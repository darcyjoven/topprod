# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt850.4gl
# Descriptions...: 三角貿易出貨通知單維護作業
# Date & Author..: 00/05/22 By Kammy
# Notes..........: copy至axmt850(saxmt600), 修改成三角貿易出貨
# Modify.........: No.FUN-4A0081 05/08/09 By saki 指定單據編號、執行功能
# Modify.........: No.FUN-610064 06/02/20 By jackie 改成多角出貨單
# Modify.........: No.FUN-650108 06/07/03 By wujie  axm,atm出貨單合并
# Modify.........: NO.FUN-670007 06/07/27 BY yiting oaz32->oax01
# Modify.........: No.FUN-680137 06/09/08 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0079 06/11/06 By king 改正被誤定義為apm08類型的
# Modify.........: No.CHI-6A0004 06/11/06 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-710016 07/01/19 By kim GP3.6 行業別架構
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-970017 10/04/02 By Lilan EasyFlow 自動執行確認功能
# Modify.........: No:CHI-A40068 10/05/26 By Summer 變更"串查button真正對應的程式
# Modify.........: No.FUN-B90012 11/08/19 By fengrui axmt850.4gl-> axmt850.src.4gl 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt600.global"
 
MAIN
#    DEFINE l_time	LIKE type_file.chr8    #No.FUN-680137 VARCHAR(8)       #NO.FUN-6A0094
    DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
   #FUN-970017 add if,判斷當不是背景執行程式，才定義系統畫面預設值。
    IF FGL_GETENV("FGLGUI") <> "0" THEN      #FUN-970017 add
      OPTIONS                                #改變一些系統預設值
         INPUT NO WRAP,
         FIELD ORDER FORM                    #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
    END IF                                   #FUN-970017 add
 
    DEFER INTERRUPT

   LET g_prog = 'axmt850_icd'              #No.FUN-B90012
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("AXM")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818         #NO.FUN-6A0094

   #判斷當 g_bgjob = 'N' OR cl_null(g_bgjob) 時, 才 OPEN WINDOW 及 CALL cl_ui_init()
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN                         #FUN-970017 add 
       LET p_row = 1 LET p_col = 3
      #OPEN WINDOW t850_w AT p_row,p_col WITH FORM "axm/42f/axmt850" #FUN-710016
       OPEN WINDOW t850_w AT p_row,p_col WITH FORM "axm/42f/axmt620" #FUN-710016
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
           
       CALL cl_ui_init()
      #-----CHI-A40068---------
      CASE g_sma.sma124  
         WHEN 'std'
            CALL cl_reset_qry_btn("oga011,oga16,ogb31","axmt820,axmt810,axmt810")
         WHEN 'icd' 
            CALL cl_reset_qry_btn("oga011,oga16,ogb31,b2_31","axmt820,axmt810_icd,axmt810_icd,axmt810_icd")  
         WHEN 'slk'
            CALL cl_reset_qry_btn("oga011,oga16,ogb31","axmt820,axmt810_slk,axmt810_slk")  
      END CASE
      #-----END CHI-A40068-----
    END IF                                                          #FUN-970017 add

#NO.FUN-670007 start--
#    IF cl_null(g_oaz.oaz32) THEN       #三角貿易使用匯率
#       LET g_oaz.oaz32='S'
    IF cl_null(g_oax.oax01) THEN       #三角貿易使用匯率
       LET g_oax.oax01='S'
#NO.FUN-670007 end---
    END IF
 
    CALL t600(5,g_argv1,g_argv2)
 
    CLOSE WINDOW t850_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
END MAIN
