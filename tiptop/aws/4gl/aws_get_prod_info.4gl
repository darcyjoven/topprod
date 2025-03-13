# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_prod_info.4gl
# Descriptions...: 讀取TIPTOP產品資訊
# Date & Author..: 2011/04/25 by Henry
# Memo...........:
# Modify.........: 新建立  #FUN-B40072
#
#}

DATABASE ds
 
#FUN-B40072
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 讀取TIPTOP產品資訊（入口 function）
# Date & Author..: 2011/04/25 by Henry  #FUN-B40072
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_prod_info()
  
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 讀取TIPTOP產品資訊                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_prod_info_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 讀取TIPTOP產品資訊
# Date & Author..: 2011/04/25 by Henry
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_prod_info_process()
    DEFINE l_return    RECORD             #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                          prod_name      STRING,   #回傳的Product server name
                          licence_unit   STRING,   #回傳的Product server 授權人數
                          buy_module     STRING,   #回傳的Product server 購買模組
                          prod_version   STRING    #回傳TIPTOP產品版號
                       END RECORD

   #Setting number to field
    LET  l_return.prod_name = "TIPTOP"
    CALL cl_system_allow_users()  RETURNING l_return.licence_unit
    LET  l_return.buy_module = "ALL"
    CALL cl_get_tp_version() RETURNING l_return.prod_version
  
    IF g_status.code = "0" THEN
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳結果
    END IF
END FUNCTION
