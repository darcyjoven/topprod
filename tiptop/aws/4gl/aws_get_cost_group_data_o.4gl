# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_cost_group_data.4gl
# Descriptions...: 提供取得 ERP 成本分群資料服務
# Date & Author..: 2007/04/12 by Joe
# Memo...........:
# Modify.........: 新建立  #FUN-720021
# Modify.........: No.FUN-840004 08/06/17 By Echo 新架構的 Services 與舊架構必須進行區別，
#                                                 因此需調整舊 Services 的程式名稱
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-840004
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_table     STRING
 
#[
# Description....: 提供取得 ERP 成本分群資料服務(入口 function)
# Date & Author..: 2007/04/12 by Joe  #FUN-720021
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getCostGroupData_g()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
 
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getCostGroupData_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 成本分群編號                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_getCostGroupData_get()
    END IF
    
    LET g_getCostGroupData_out.status = aws_ttsrv_getStatus()
 
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 成本分群編號
# Date & Author..: 2007/04/12 by Joe
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getCostGroupData_get()
    DEFINE l_azf       RECORD LIKE azf_file.*
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
 
 
    LET g_table = "azf_file"
 
    #--------------------------------------------------------------------------#
    # 填充服務所使用 TABLE, 其欄位名稱及相對應他系統欄位名稱                   #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_getServiceColumn(g_service) THEN
       LET g_status.code = "aws-102"   #讀取服務設定錯誤
       RETURN
    END IF
 
    #--------------------------------------------------------------------------#
    #依據資料條件(condition),抓取料件資料                                      #
    #--------------------------------------------------------------------------#
    IF cl_null(g_getCostGroupData_in.condition) THEN
       LET g_getCostGroupData_in.condition = " 1=1" 
    END IF
    LET l_sql = "SELECT * FROM azf_file WHERE azfacti = 'Y' AND ",
                 g_getCostGroupData_in.condition," ORDER BY azf01 "
                 
    DECLARE azf_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH azf_curs INTO l_azf.*
        #------------------------------------------------------------------#
        # 解析 RecordSet, 回傳於 Table 欄位                                #
        #------------------------------------------------------------------#
        LET l_node = aws_ttsrv_setDataSetRecord(base.TypeInfo.create(l_azf), l_node, g_table)
    END FOREACH
 
    #--------------------------------------------------------------------------#
    # Response Xml 文件改成字串                                                #
    #--------------------------------------------------------------------------#
    LET g_getCostGroupData_out.azf = aws_ttsrv_xmlToString(l_node)
END FUNCTION
