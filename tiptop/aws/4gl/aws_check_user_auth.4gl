# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_check_user_auth.4gl
# Descriptions...: 驗證使用者帳號是否正確
# Date & Author..: 2008/08/04 by kevin
# Memo...........:
# Modify.........: 新建立    #FUN-880012
#
#}
 
DATABASE ds
#FUN-880012
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 驗證使用者帳號是否正確(入口 function)
# Date & Author..: 2008/08/04 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_check_user_auth()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 驗證使用者帳號是否正確                                                   #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_check_user_auth_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
 
#[
# Description....: 驗證使用者帳號是否正確
# Date & Author..: 2008/08/04 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_check_user_auth_process()    
    DEFINE l_node      om.DomNode    
    DEFINE l_hashkey   STRING  
    DEFINE l_datetime  STRING  
    DEFINE l_userid    LIKE zx_file.zx01  
    DEFINE l_cnt       LIKE type_file.num5
    DEFINE l_return    RECORD            #回傳值必須宣告為一個 RECORD 變數
                         status   STRING #回傳的欄位名稱
                       END RECORD
 
    LET l_hashkey = aws_ttsrv_getParameter("hashkey") 
    
    CALL cl_timekey(l_hashkey) RETURNING l_return.status
    IF g_status.code<> 0 THEN
    	 RETURN
    END IF
    
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
   
   
END FUNCTION
