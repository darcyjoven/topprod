# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aemt200.4gl
# Descriptions...: 設備保修工單庫存發料/退料作業
# Date & Author..: 04/07/19 By Carrier
# Modify.........: No.TQC-620123 06/02/24 By Claire aemt200不可執行,僅可執行aemt201/aemt202
# Modify.........: No.FUN-680072 06/08/25 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-770034 07/07/31 By kim Unicode版編譯錯誤,重新過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
    DEFINE g_cmd        LIKE type_file.chr20         #No.FUN-680072CHAR(10)
    DEFINE g_argv1      LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
    DEFINE l_chr 	LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
 
    CASE WHEN g_argv1 = '1' LET g_cmd ='aemt201'  LET g_prog='aemt201'
         WHEN g_argv1 = '2' LET g_cmd ='aemt202'  LET g_prog='aemt202'
         OTHERWISE 
              EXIT PROGRAM
    END CASE
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_cmd,g_time,1) RETURNING g_time    #No.FUN-6A0068
 
    OPEN WINDOW t200_w WITH FORM "aem/42f/aemt200"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    # 2004/02/06 by Hiko : 共用畫面時呼叫.
    CALL cl_set_locale_frm_name("aemt200")    
    CALL cl_ui_init()
 
    CALL t200(g_argv1)
    CLOSE WINDOW t200_w                 #結束畫面
    CALL cl_used(g_cmd,g_time,2) RETURNING g_time    #No.FUN-6A0068
 
END MAIN
#CHI-770034
