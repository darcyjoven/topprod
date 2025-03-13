# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_prod_class_list.4gl
# Descriptions...: 提供取得 ERP 產品分類碼列表服務
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
# Description....: 提供取得 ERP 產品分類碼列表服務(入口 function)
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getProdClassList_g()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
    
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getProdClassList_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 產品分類碼                                                        #
    #--------------------------------------------------------------------------#
    CALL g_getProdClassList_out.oba.clear()   #清空回覆參數的 ARRAY
    IF g_status.code = "0" THEN
       CALL aws_getProdClassList_get()
    END IF
    
    LET g_getProdClassList_out.status = aws_ttsrv_getStatus()
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
FUNCTION aws_getProdClassList_get()
    DEFINE l_i     LIKE type_file.num10,
           l_oba   RECORD 
                      oba01   LIKE oba_file.oba01,
                      oba02   LIKE oba_file.oba02
                   END RECORD
 
    
    DECLARE oba_cur CURSOR FOR 
         SELECT oba01, oba02 
           FROM oba_file 
          ORDER BY oba01
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    LET l_i = 1
    FOREACH oba_cur INTO l_oba.*
        LET g_getProdClassList_out.oba[l_i].oba01 = l_oba.oba01 CLIPPED
        LET g_getProdClassList_out.oba[l_i].oba02 = l_oba.oba02 CLIPPED
        LET l_i = l_i + 1
    END FOREACH
END FUNCTION
