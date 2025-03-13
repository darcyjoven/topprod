# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_prod_class_list.4gl
# Descriptions...: 提供取得 ERP 產品分類碼列表服務
# Date & Author..: 2007/06/25 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-760069
# Modify.........: No.FUN-860037 08/06/20 By Kevin 升級到aws_ttsrv2
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-760069
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 產品分類碼列表服務(入口 function)
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_prod_class_list()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 產品分類碼                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_prod_class_list_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 產品分類碼
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_prod_class_list_process()
    DEFINE l_i     LIKE type_file.num10,
           l_oba   RECORD 
                      oba01   LIKE oba_file.oba01,
                      oba02   LIKE oba_file.oba02
                   END RECORD
    DEFINE l_node  om.DomNode
    
    DECLARE oba_cur CURSOR FOR 
         SELECT oba01, oba02 
           FROM oba_file 
          ORDER BY oba01
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF    
    
    FOREACH oba_cur INTO l_oba.*
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           RETURN
        END IF
    
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_oba), "oba_file")   #加入此筆單檔資料至 Response 中
    END FOREACH
    
    
END FUNCTION
