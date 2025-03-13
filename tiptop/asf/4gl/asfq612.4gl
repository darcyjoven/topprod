# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: asfq612.4gl
# Descriptions...: 備置明細查詢
# Date & Author..:FUN_AC0074 11/04/29 By shenyang
# Modify.........: No.FUN-AC0074 11/04/29 By shenyang
# Modify.........: No.TQC-CB0039 12/11/14 By xuxz 檔sma541 = N時，asfq612的三個頁簽的單身中應將“工藝短號”，“工藝段說明”欄位進行隱藏

DATABASE ds
 
GLOBALS "../../config/top.global"

MAIN
    DEFINE p_argv1      LIKE type_file.chr1           
    DEFINE p_argv2      LIKE ima_file.ima01            
    DEFINE p_row,p_col  LIKE type_file.num5             
    
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  
    DEFER INTERRUPT
 
     LET p_argv1 = ARG_VAL(1)
     LET p_argv2 = ARG_VAL(2) 
     CASE WHEN p_argv1='1' LET g_prog='asfq610'
          WHEN p_argv1='2' LET g_prog='axmq611'    
          WHEN p_argv1='3' LET g_prog='aimq611'  
          WHEN p_argv1='4' LET g_prog='asfq612'  
          OTHERWISE        LET p_argv2=ARG_VAL(2)
                     
     END CASE
    IF g_prog = 'asfq610' THEN
       LET p_argv1='1'
    END IF 
    IF g_prog = 'axmq611' THEN
       LET p_argv1='2'
    END IF 
    IF g_prog = 'aimq611' THEN
       LET p_argv1='3'
    END IF 
    IF g_prog = 'asfq612' THEN
       LET p_argv1='4'
    END IF     
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
     LET p_row = 4 LET p_col = 3
  
     OPEN WINDOW q610_w AT p_row,p_col
         WITH FORM "asf/42f/asfq610"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_set_locale_frm_name("asfq610")
   CALL cl_ui_init()
   #TQC-CB0039--add--str
   CALL cl_set_comp_visible('sie012,sie012_1,sie012_2,ecm014,ecm014_1,ecm014_2',(g_sma.sma541 = 'Y' AND g_prog = 'asfq612'))
   #TQC-CB0039--add--end
 
    CALL q610('4',p_argv2)      
    CLOSE WINDOW q610_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
#FUN-AC0074
