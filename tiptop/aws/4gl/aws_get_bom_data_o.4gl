# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_bom_data.4gl
# Descriptions...: 提供取得 ERP BOM 資料服務
# Date & Author..: 2007/03/26 by Joe
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
 
DEFINE g_table     STRING,
       g_table2    STRING
           
 
#[
# Description....: 提供取得 ERP BOM 資料服務(入口 function)
# Date & Author..: 2007/03/26 by Joe  #FUN-720021
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getBOMData_g()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
 
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getBOMData_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP BOM 資料                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_getBOMData_get()
    END IF
    
    LET g_getBOMData_out.status = aws_ttsrv_getStatus()
 
END FUNCTION
 
 
#[
# Description....: 查詢 ERP BOM 
# Date & Author..: 2007/03/26 by Joe
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getBOMData_get()
    DEFINE l_bma       RECORD LIKE bma_file.*
    DEFINE l_bmb       DYNAMIC ARRAY OF RECORD LIKE bmb_file.*
    DEFINE l_node      om.DomNode,
           l_node2     om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_i         LIKE type_file.num10
 
    
    LET g_table = "bma_file"
    LET g_table2 = "bmb_file"
 
    #--------------------------------------------------------------------------#
    # 填充服務所使用 TABLE, 其欄位名稱及相對應他系統欄位名稱                   #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_getServiceColumn(g_service) THEN
       LET g_status.code = "aws-102"   #讀取服務設定錯誤
       RETURN
    END IF
      
    #--------------------------------------------------------------------------#
    # 依據資料條件(condition),抓取 BOM 資料                                    #
    #--------------------------------------------------------------------------#
    IF cl_null(g_getBOMData_in.condition) THEN
       LET g_getBOMData_in.condition = " 1=1" 
    END IF
    LET l_sql = "SELECT UNIQUE bma_file.* FROM bma_file,bmb_file ",
                " WHERE bma01 = bmb01 AND bmaacti = 'Y' AND ",
                 g_getBOMData_in.condition," ORDER BY bma01 "
                 
    #--------------------------------------------------------------------------#
    # 查詢 ERP BOM 單頭資料                                                    #
    #--------------------------------------------------------------------------# 
    DECLARE bma_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
    #-----------------------------------------------------------------------#
    # 查詢 ERP BOM 單身資料                                                 #
    #-----------------------------------------------------------------------#
    LET l_sql = "SELECT * FROM bmb_file WHERE ",
                "bmb01 = ? ORDER BY bmb02" 
    DECLARE bmb_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
    END IF
   
    FOREACH bma_curs INTO l_bma.*
       #-----------------------------------------------------------------------#
       # 建立回傳的單頭 DataSet                                                #
       #-----------------------------------------------------------------------#
       LET l_node = aws_ttsrv_setDataSetRecord(base.TypeInfo.create(l_bma), l_node, g_table)
      
       LET l_i = 1   #處理這筆單頭對應的單身
       FOREACH bmb_curs USING l_bma.bma01 INTO l_bmb[l_i].*
          LET l_i = l_i + 1
       END FOREACH
       CALL l_bmb.deleteElement(l_i)
    
       #-----------------------------------------------------------------------#
       # 建立回傳的單身 DataSet                                                #
       #-----------------------------------------------------------------------#
       LET l_node2 = aws_ttsrv_setDataSetRecord(base.TypeInfo.create(l_bmb), l_node2, g_table2)
    END FOREACH
 
    #--------------------------------------------------------------------------#
    # Response Xml 文件改成字串回傳                                            #
    #--------------------------------------------------------------------------#
    LET g_getBOMData_out.bma = aws_ttsrv_xmlToString(l_node)
    LET g_getBOMData_out.bmb = aws_ttsrv_xmlToString(l_node2)    
END FUNCTION
