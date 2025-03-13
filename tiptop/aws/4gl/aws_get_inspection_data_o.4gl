# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_get_inspection_data_o.4gl
# Descriptions...: 回傳檢驗碼(rvb39)
# Date & Author..: 2008/05/05 by kevin 
# Modify.........: No.FUN-850022 08/05/05 By kevin 新建立
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
FUNCTION aws_getInspectionData_g()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
 
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getInspectionData_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 查詢 檢驗碼                                                              #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_getInspectionData_get()
    END IF
    
    LET g_getInspectionData_out.status = aws_ttsrv_getStatus()
 
END FUNCTION
 
 
#[
# Description....: 查詢 檢驗碼
# Date & Author..: 2008/05/05 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getInspectionData_get()    
    DEFINE l_rvb39     LIKE rvb_file.rvb39
    DEFINE l_rvb03     LIKE rvb_file.rvb03   #MOD-860146
    DEFINE l_rvb04     LIKE rvb_file.rvb04
    DEFINE l_rvb05     LIKE rvb_file.rvb05
    DEFINE l_rvb19     LIKE rvb_file.rvb19
    DEFINE l_rva05     LIKE rva_file.rva05
    DEFINE l_sma886    LIKE sma_file.sma886
    
    LET l_rvb03  = g_getInspectionData_in.rvb03   #MOD-860146
    LET l_rvb04  = g_getInspectionData_in.rvb04
    LET l_rvb05  = g_getInspectionData_in.rvb05
    LET l_rvb19  = g_getInspectionData_in.rvb19
    LET l_rva05  = g_getInspectionData_in.rva05
    SELECT sma886 INTO l_sma886 FROM sma_file WHERE sma00='0'
    
    #CALL t110_get_rvb39(l_rvb04,l_rvb05,l_rvb19,l_rva05,l_sma886) RETURNING l_rvb39        #MOD-860146
    CALL t110_get_rvb39(l_rvb03,l_rvb04,l_rvb05,l_rvb19,l_rva05,l_sma886) RETURNING l_rvb39        #MOD-860146
                        
    LET g_getInspectionData_out.rvb39 = l_rvb39
   
END FUNCTION
