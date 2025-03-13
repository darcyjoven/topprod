# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt820.4gl
# Descriptions...: 三角貿易出貨單維護作業
# Date & Author..: 98/12/11 By Linda
# Notes..........: copy至axmt820(saxmt600), 修改成三角貿易出貨
# Modify.........: No.FUN-4A0081 05/08/09 By saki 指定單據編號、執行功能
# Modify.........: No.FUN-610064 06/02/20 By jackie 改成多角出貨單
# Modify.........: No.FUN-650108 06/07/03 By wujie  axm,atm出貨單合并
# Modify.........; NO.FUN-670007 06/07/26 BY yiting oaz32->oax01
# Modify.........: No.FUN-680137 06/09/11 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/11/06 By Jackho 本幣取位修改
# Modify.........: No.TQC-6A0079 06/11/06 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-710016 07/01/19 By kim GP3.6 行業別架構
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40068 10/05/26 By Summer 變更"串查button真正對應的程式
# Modify.........: No.FUN-B90012 11/08/19 By xianghui axmt820.4gl-->axmt820.src.4gl
# Modify.........: No.CHI-C10027 13/02/21 By jt_chen 增加修正axmt820串axmt850,icd行業別錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt600.global"
 
MAIN
#    DEFINE l_time	LIKE type_file.chr8    #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
    DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
 
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
    LET g_prog = 'axmt820_icd'       #FUN-B90012 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
 
    LET p_row = 1 LET p_col = 3
   #OPEN WINDOW t820_w AT p_row,p_col WITH FORM "axm/42f/axmt820" #FUN-710016
    OPEN WINDOW t820_w AT p_row,p_col WITH FORM "axm/42f/axmt620" #FUN-710016
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #CHI-A40068 add --start--
    CASE g_sma.sma124  
       WHEN 'std'
          CALL cl_reset_qry_btn("oga011,oga16,ogb31","axmt850,axmt810,axmt810")
       WHEN 'icd' 
          CALL cl_reset_qry_btn("oga011,oga16,ogb31,b2_31","axmt850_icd,axmt810_icd,axmt810_icd,axmt810_icd")   #CHI-C10027 modify axmt850 -> axmt850_icd 
       WHEN 'slk'
          CALL cl_reset_qry_btn("oga011,oga16,ogb31","axmt850,axmt810_slk,axmt810_slk")  
    END CASE
    #CHI-A40068 add --end--

#NO.FUN-670007 start--        
#    IF cl_null(g_oaz.oaz32) THEN       #三角貿易使用匯率
#       LET g_oaz.oaz32='S'
    IF cl_null(g_oax.oax01) THEN       #三角貿易使用匯率
       LET g_oax.oax01='S'
#NO.FUN-670007 end----
    END IF
 
    CALL t600(4,g_argv1,g_argv2)
 
    CLOSE WINDOW t820_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
END MAIN
