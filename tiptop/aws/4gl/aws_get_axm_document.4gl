# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_axm_document.4gl
# Descriptions...: 提供取得 ERP 銷售系統單別服務
# Date & Author..: 2007/02/09 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-860037 08/06/20 By Kevin 升級到aws_ttsrv2
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#FUN-720021
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#------------------------------------------------------------------------------#
# 將 $QRY/4gl/q_oay.4gl 中關於最後輸出結果的 ARRAY 包含進來, 再額外封裝為此服  #
# 務所需的輸出值                                                               #
#------------------------------------------------------------------------------#
GLOBALS
    DEFINE ma_qry   DYNAMIC ARRAY OF RECORD
              check     LIKE type_file.chr1,
              oayslip   LIKE oay_file.oayslip,
              oaydesc   LIKE oay_file.oaydesc,
              oayauno   LIKE oay_file.oayauno,
              oaytype   LIKE oay_file.oaytype,
              oay11     LIKE oay_file.oay11
           END RECORD
END GLOBALS
#[
# Description....: 提供取得 ERP 銷售系統單別服務(入口 function)
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_axm_document()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 區域別編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_axm_document_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
    
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 銷售系統單別
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_axm_document_process()
    DEFINE l_i   LIKE type_file.num10
    DEFINE l_node      om.DomNode
    DEFINE l_oaysys    STRING,        #系統別, 固定為 'AXM'
           l_oaytype   STRING         #單據性質           
    DEFINE l_oay DYNAMIC ARRAY OF RECORD
                 oayslip   STRING,     #單別
                 oaydesc   STRING      #單別說明           
           END RECORD
    #--------------------------------------------------------------------------#
    # 呼叫 $QRY/4gl/q_oay.4gl 單別查詢 function                                #
    # 原 q_oay.4gl 應需做調整以能被正確以服務型態存取                          #
    #--------------------------------------------------------------------------#
 
    #最大動態開窗查詢筆數 
    SELECT aza38 INTO g_aza.aza38 FROM aza_file WHERE aza01='0'
 
    LET l_oaytype = aws_ttsrv_getParameter("oaytype")
    LET l_oaysys = aws_ttsrv_getParameter("oaysys")
    CALL q_oay(FALSE, FALSE, '', l_oaytype, l_oaysys)
 
    #--------------------------------------------------------------------------#
    # 重新封裝查詢陣列結果為最後輸出陣列形式                                   #
    #--------------------------------------------------------------------------#
    FOR l_i = 1 TO ma_qry.getLength()
        LET l_oay[l_i].oayslip = ma_qry[l_i].oayslip CLIPPED
        LET l_oay[l_i].oaydesc = ma_qry[l_i].oaydesc CLIPPED
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_oay[l_i]), "oay_file")   #加入此筆單檔資料至 Response 中
    END FOR
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF    
END FUNCTION
