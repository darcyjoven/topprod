# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_user_token.4gl
# Descriptions...: 提供取得使用者帳號驗證碼
# Date & Author..: 2008/08/04 by kevin
# Memo...........:
# Modify.........: 新建立    #FUN-880012
#
#}
 
DATABASE ds
#FUN-880012
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得使用者帳號驗證碼(入口 function)
# Date & Author..: 2008/08/04 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_user_token()
 
    WHENEVER ERROR CONTINUE    
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 使用者帳號驗證碼                                                #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_user_token_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
 
#[
# Description....: 查詢使用者帳號驗證碼
# Date & Author..: 2008/08/04 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_user_token_process()    
    DEFINE l_node      om.DomNode    
    DEFINE l_userid    LIKE zx_file.zx01  
    
    DEFINE l_return    RECORD            #回傳值必須宣告為一個 RECORD 變數
                         tokenkey   STRING #回傳的欄位名稱
                       END RECORD
 
    LET l_userid = aws_ttsrv_getParameter("userid")
    
    CALL cl_tokenkey(l_userid) RETURNING l_return.tokenkey   
    IF  g_status.code<> 0 THEN
    	  RETURN
    END IF
    
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
   
   
END FUNCTION
