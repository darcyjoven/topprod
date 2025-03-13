# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_month_list.4gl
# Descriptions...: 提供取得 ERP 月份列表服務
# Date & Author..: 2007/06/25 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-760069
# Modify.........: No.FUN-840004 08/06/17 By Echo 新架構的 Services 與舊架構必須進行區別，
#                                                 因此需調整舊 Services 的程式名稱
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-760069 #FUN-840004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 月份列表服務(入口 function)
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getMonthList_g()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
    
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getMonthList_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 月份                                                        #
    #--------------------------------------------------------------------------#
    CALL g_getMonthList_out.mon.clear()   #清空回覆參數的 ARRAY
    IF g_status.code = "0" THEN
       CALL aws_getMonthList_get()
    END IF
    
    LET g_getMonthList_out.status = aws_ttsrv_getStatus()
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 月份
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getMonthList_get()
        LET g_getMonthList_out.mon[ 1].mon01 =  1
        LET g_getMonthList_out.mon[ 2].mon01 =  2
        LET g_getMonthList_out.mon[ 3].mon01 =  3
        LET g_getMonthList_out.mon[ 4].mon01 =  4
        LET g_getMonthList_out.mon[ 5].mon01 =  5
        LET g_getMonthList_out.mon[ 6].mon01 =  6
        LET g_getMonthList_out.mon[ 7].mon01 =  7
        LET g_getMonthList_out.mon[ 8].mon01 =  8
        LET g_getMonthList_out.mon[ 9].mon01 =  9
        LET g_getMonthList_out.mon[10].mon01 = 10
        LET g_getMonthList_out.mon[11].mon01 = 11
        LET g_getMonthList_out.mon[12].mon01 = 12
END FUNCTION
