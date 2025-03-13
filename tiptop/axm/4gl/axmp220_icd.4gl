# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmp220.4gl
# Descriptions...: 出貨通知單處批處理作業
# Date & Author..: NO.TQC-730022 07/03/19 By rainy
# Modify.........: No.FUN-7C0017 08/03/04 By bnlent axmp220.4gl-> axmp220.src.4gl 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
   DEFER INTERRUPT
 
   LET g_prog = 'axmp220_icd'   #No.FUN-7C0017
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW p220_w WITH FORM "axm/42f/axmp220" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL p220("1")   
    CLOSE WINDOW p220_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
