# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aws_cross_portal.4gl
# Descriptions...: cl_ppcli待辦事項整合CROSS呼叫FUNCTION使用
# Date & Author..: NO.FUN-B80118 11/09/26 By Jay 新增程式

DATABASE ds

#FUN-B80118 
GLOBALS "../../config/top.global"

MAIN
    DEFINE l_prod                    STRING                #呼叫產品名稱
    DEFINE l_srvname                 STRING                #呼叫服務名稱
    DEFINE l_type                    STRING                #同步型態: sync(同步), async(非同步), mdm, etl
    DEFINE l_request_file_name       STRING                #準備傳送之標準整合 Request XML 字串的檔案名稱
    DEFINE l_request                 STRING                #標準整合 Request XML 字串 
    DEFINE l_file_name               STRING                #寫入之temp檔名
    DEFINE ls_sendMessageToPortal    STRING                #標準整合 Response XML 字串
    DEFINE l_cross_status            LIKE type_file.num10  #CROSS 處理成功否
    DEFINE li_status                 LIKE type_file.num10  #WebService處理狀況
    DEFINE l_ch                      base.Channel
    DEFINE l_t_doc                   om.DomDocument        #For String to Xml
    DEFINE l_root                    om.DomNode
     
    
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

    WHENEVER ERROR CALL cl_err_msg_log
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_prog = "aws_cross_portal"
    LET g_user = "tiptop"
    LET g_bgjob = "Y"
    LET g_gui_type = 0
    LET g_lang = 0
    LET g_today = TODAY
    SELECT zx03 INTO g_grup FROM zx_file WHERE zx01=g_user
    
    LET l_prod = ARG_VAL(1)
    LET l_srvname = ARG_VAL(2)
    LET l_type = ARG_VAL(3)
    LET l_request_file_name = ARG_VAL(4)
    LET l_file_name = ARG_VAL(5)
    
    IF cl_null(l_prod) THEN
       DISPLAY "This program can not be executed independently."
       RETURN
    END IF

    LET l_file_name = fgl_getenv("TEMPDIR"), "/", l_file_name
    #檢查準備寫入之response檔案是否存在
    IF cl_null(l_file_name) THEN
       RETURN 
    END IF

    LET l_request_file_name = fgl_getenv("TEMPDIR"), "/", l_request_file_name
    #檢查準備送出之request檔案是否存在
    IF cl_null(l_request_file_name) THEN
       RETURN 
    END IF
    LET l_t_doc = om.DomDocument.createFromXmlFile(l_request_file_name)

    #將request xml變成字串
    IF l_t_doc IS NOT NULL THEN
       INITIALIZE l_root TO NULL
       LET l_root = l_t_doc.getDocumentElement()
    END IF
    LET l_request = l_root.toString()
      
    CALL aws_cross_invokeSrv(l_prod, l_srvname, l_type, l_request) 
         RETURNING l_cross_status, li_status, ls_sendMessageToPortal
    
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file_name, "w")
    CALL l_ch.setDelimiter("")
    
    CALL l_ch.writeLine(l_cross_status)
    CALL l_ch.writeLine(li_status)
    CALL l_ch.writeLine(ls_sendMessageToPortal.trim())
    CALL l_ch.close()
    
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            
END MAIN
