# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_purchase_stock_out.4gl
# Descriptions...: 提供建立收貨驗退單資料的服務
# Date & Author..: 2008/04/09 by kim (FUN-840012)
# Memo...........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供建立收貨驗退單資料的服務(入口 function)
# Date & Author..: 2008/04/09 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_purchase_stock_out()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
    #--------------------------------------------------------------------------#
    # 新增收貨驗退單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_purchase_stock_out_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
FUNCTION aws_create_purchase_stock_out_process()
    CALL aws_create_purchase_stock_process('2')   #函數定義在aws_create_purchase_stock_in.4gl中
END FUNCTION
