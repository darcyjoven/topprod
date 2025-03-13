# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_get_inspection_data.4gl
# Descriptions...: 回傳檢驗碼(rvb39)
# Date & Author..: 2008/05/05 by kevin 
# Modify.........: No.FUN-850022 08/06/10 By kevin 新建立
# Modify.........: No.MOD-860146 08/07/15 By Smapmin e-Bonline整合回傳檢驗碼(rvb39)service多一rvb03參數 
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#FUN-850022
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 回傳檢驗碼服務(入口 function)
# Date & Author..: 2008/05/05 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
 
FUNCTION aws_get_inspection_data()
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 檢驗碼資料                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_inspection_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
FUNCTION aws_get_inspection_data_process()     
    DEFINE l_rvb03     LIKE rvb_file.rvb03   #MOD-860146
    DEFINE l_rvb04     LIKE rvb_file.rvb04
    DEFINE l_rvb05     LIKE rvb_file.rvb05
    DEFINE l_rvb19     LIKE rvb_file.rvb19
    DEFINE l_rva05     LIKE rva_file.rva05
    DEFINE l_sma886    LIKE sma_file.sma886    
    DEFINE l_return    RECORD                          
                       rvb39   LIKE rvb_file.rvb39   #回傳的欄位名稱
                       END RECORD
    
    LET l_rvb03  = aws_ttsrv_getParameter("rvb03")   #MOD-860146
    LET l_rvb04  = aws_ttsrv_getParameter("rvb04")
    LET l_rvb05  = aws_ttsrv_getParameter("rvb05")
    LET l_rvb19  = aws_ttsrv_getParameter("rvb19")
    LET l_rva05  = aws_ttsrv_getParameter("rva05")
    
    SELECT sma886 INTO l_sma886 FROM sma_file WHERE sma00='0'
    
    #CALL t110_get_rvb39(l_rvb04,l_rvb05,l_rvb19,l_rva05,l_sma886) RETURNING l_return.rvb39        #MOD-860146
    CALL t110_get_rvb39(l_rvb03,l_rvb04,l_rvb05,l_rvb19,l_rva05,l_sma886) RETURNING l_return.rvb39        #MOD-860146
                        
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
    
END FUNCTION
