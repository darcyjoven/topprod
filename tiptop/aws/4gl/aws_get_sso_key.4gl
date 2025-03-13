# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#{
# Program name...: aws_get_sso_key.4gl
# Descriptions...: 提供取得TIPTOP SSOKey
# Date & Author..: 2011/01/04 by Jay
# Memo...........:
# Modify.........: 新建立    #FUN-B10003
# Modify.........: FUN-C80054 12/08/15 By Kevin 如果是POS 回傳 wpc_url
# Modify.........: FUN-C80081 12/08/22 By Kevin 修改規則 FGL_GETENV("WPC_URL”) + "/wa/r/"+ FGL_GETENV("WEBAREA") + "-wpc/" 
# Modify.........: FUN-D10095 13/02/18 By baogc XML格式調整
#
#}
 
DATABASE ds
#FUN-B10003
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得TIPTOP SSOKey(入口 function)
# Date & Author..: 2011/01/04 by Jay
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_sso_key()
    DEFINE l_area      STRING
    
    WHENEVER ERROR CONTINUE    
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 使用者帳號驗證碼                                                #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN        
       #FUN-C80054 start
       IF g_access.application = "POS" AND NOT cl_null(FGL_GETENV("WEBAREA")) THEN           
          CALL aws_get_pos_key_process()     # POS & WPC 系統使用 
       ELSE
          CALL aws_get_sso_key_process() 
       END IF      
       #FUN-C80054 end
       
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
 
#[
# Description....: 取得TIPTOP SSOKey
# Date & Author..: 2011/01/04 by Jay
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_sso_key_process()    
    DEFINE l_node      om.DomNode
    DEFINE l_hashkey   STRING            #XML tag裡hashkey內容
    DEFINE l_str       STRING            #XML tag裡 [產品],"|",[IP],"|",[帳號]
    DEFINE l_return    RECORD            #回傳值必須宣告為一個 RECORD 變數
                         ssokey   STRING #回傳的欄位名稱
                       END RECORD

    #產品別|呼叫端來源 IP or Host|登入帳號
    LET l_str = g_access.application, "|", g_access.source, "|", g_access.user
   #FUN-D10095 Mark&Add Begin ---
   #LET l_hashkey = aws_ttsrv_getParameter("hashkey")
    LET l_node    = aws_ttsrv_getTreeMasterRecord(1,"GetSSOKey")
    LET l_hashkey = aws_ttsrv_getRecordField(l_node,"hashkey")
   #FUN-D10095 Mark&Add End -----
    
    CALL cl_get_ssokey(l_str, l_hashkey) RETURNING l_return.ssokey   
    IF g_status.code <> 0 THEN
    	RETURN
    END IF
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))                          #FUN-D10095 Mark
    CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(l_return), "GetSSOKey") RETURNING l_node #FUN-D10095 Add
    
END FUNCTION

#FUN-C80054 start
#[
# Description....: 取得TIPTOP SSOKey & wpc_url
# Date & Author..: 2012/08/15 by Kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_pos_key_process()    
    DEFINE l_node      om.DomNode
    DEFINE l_hashkey   STRING            #XML tag裡hashkey內容
    DEFINE l_str       STRING            #XML tag裡 [產品],"|",[IP],"|",[帳號]    
    DEFINE l_pos       RECORD            #回傳值必須宣告為一個 RECORD 變數
                         ssokey   STRING,
                         wpc_url  STRING
                       END RECORD

    #產品別|呼叫端來源 IP or Host|登入帳號
    LET l_str = g_access.application, "|", g_access.source, "|", g_access.user
   #FUN-D10095 Mark&Add Begin ---
   #LET l_hashkey = aws_ttsrv_getParameter("hashkey")
    LET l_node    = aws_ttsrv_getTreeMasterRecord(1,"GetSSOKey")
    LET l_hashkey = aws_ttsrv_getRecordField(l_node,"hashkey")
   #FUN-D10095 Mark&Add End -----
    
    CALL cl_get_ssokey(l_str, l_hashkey) RETURNING l_pos.ssokey   
    IF g_status.code <> 0 THEN
    	RETURN
    END IF
    LET l_pos.wpc_url = FGL_GETENV("WPC_URL") , "/wa/r/" , FGL_GETENV("WEBAREA") , "-wpc/"    #FUN-C80081
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_pos))                          #FUN-D10095 Mark
    CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(l_pos), "GetSSOKey") RETURNING l_node #FUN-D10095 Add
    
END FUNCTION
#FUN-C80054 end
