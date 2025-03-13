# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmp911.4gl
# Descriptions...: 三角貿易出貨通知單拋轉還原作業(逆拋時使用)
# Date & Author..: 06/08/10 BY yiting 
# Modify.........: No.FUN-680137 06/09/11 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710046 07/01/24 By yjkhero 錯誤訊息匯整 
# Modify.........: No.MOD-870278 08/07/25 By claire 出通單拋轉還原參數傳遞錯誤
# Modify.........: No.FUN-8A0086 08/10/20 By lutinting 如果是沒有let g_success == 'Y' 就寫給g_success 賦初始值，
#                                                      不然如果一次失敗，以后都無法成功
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-620029  --Begin
DEFINE g_argv1     LIKE oga_file.oga01
DEFINE g_argv2     LIKE oga_file.oga09
DEFINE g_change_lang   LIKE type_file.chr1   #No.FUN-680137  VARCHAR(1)       #FUN-570155
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    LET g_argv1 = ARG_VAL(1)      #MOD-870278 add
    LET g_argv2 = ARG_VAL(2)      #MOD-870278 add
 
    IF (NOT cl_setup("AXM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET g_success = 'Y'                 #No.FUN-8A0086
    CALL s_showmsg_init()               #NO.FUN-710046 
    CALL p911(g_argv1,g_argv2)
    CALL s_showmsg()                    #NO.FUN-710046 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
#No.FUN-620029  --End
 
