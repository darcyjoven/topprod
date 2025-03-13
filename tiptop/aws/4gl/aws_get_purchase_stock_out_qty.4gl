# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_purchase_stock_out_qty.4gl
# Descriptions...: 提供取得 ERP po 已退量、未退量及允收數量、倉庫/儲位資料
# Date & Author..: 2008/04/08 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP po 已退量、未退量及允收數量、倉庫/儲位資料服務(入口 function)
# Date & Author..: 2008/04/08 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_purchase_stock_out_qty()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP po 資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_purchase_stock_out_qty_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
FUNCTION aws_get_purchase_stock_out_qty_process()
    CALL aws_get_purchase_stock_qty_process('2')
END FUNCTION
