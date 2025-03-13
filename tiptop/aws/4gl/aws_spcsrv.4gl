# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Library name...: aws_spcsrv
# Descriptions...: TIPTOP & SPC 整合 Services
# Usage .........: $FGLRUN aws_spcsrv
# Date & Author..: 2006/08/17 
# Modify.........: No.FUN-680130 06/09/15 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-720042 07/02/27 Genero 2.0
# Modify.........: No.FUN-7C0055 07/12/19 By Echo 調整Request處理後狀態值說明
# Modify.........: No.CHI-920065 09/02/19 By Vicky 調整當發生"Internal server error"時 EXIT PROGRAM
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:FUN-960169 09/10/22 By Echo Genero 2.11新增web service錯誤代碼-12到-17
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正

IMPORT os   #No.FUN-9C0009  
IMPORT com
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
DEFINE  mi_spc_trigger   LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE  mi_spc_status    LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE  mi_spc_xml       om.DomNode
END GLOBALS
 
#------------------------------------------------------------------------------
# Global 變數定義 
#   g_input : SPC request XML string
#   g_output: TIPTOP response XML string
#------------------------------------------------------------------------------
DEFINE g_input	RECORD
                   strXMLInput STRING
                END RECORD,
       g_output	RECORD
                   strXMLOutput STRING
                END RECORD
 
DEFINE g_spc_doc      om.DomDocument
DEFINE g_request      om.DomNode
DEFINE g_response     om.DomNode,
       g_snode        om.DomNode,
       g_dnode        om.DomNode
DEFINE g_method       STRING
DEFINE g_status       STRING
DEFINE g_action       STRING
DEFINE g_spc_version  STRING
DEFINE g_qc_prog      STRING
#DEFINE g_database     STRING     #FUN-B80064   MARK
DEFINE g_data_base     STRING      #FUN-B80064   ADD
DEFINE g_default      om.DomNode
DEFINE g_tabfile      DYNAMIC ARRAY OF STRING     #Table個數
DEFINE g_err_str      STRING 
 
MAIN
    OPTIONS
       ON CLOSE APPLICATION STOP,  #Time out 時程式可自動 kill self-process
       INPUT NO WRAP
    DEFER INTERRUPT
    WHENEVER ERROR CONTINUE

    CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80064   ADD
 
    #--------------------------------------------------------------------------
    # .指定 services name space
    # .Publish service function
    #--------------------------------------------------------------------------
    CALL fgl_ws_server_setNamespace("http://tempuri.org/aws_spcsrv")
    CALL fgl_ws_server_publishfunction( 
           "TIPTOPGateWay",
           "http://tempuri.org/aws_spcsrv", "g_input",
           "http://tempuri.org/aws_spcsrv", "g_output",
           "aws_spcsrv"
         )
 
    #--------------------------------------------------------------------------
    # .若 $FGLAPPSERVER 有自動設定時, 則為 application server mode(for deployment)
    # .若為一般執行狀態(r.r2 / exe2....), 可加上參數
    #    -W: 產生 WSDL file
    #    -S: 以 standalone mode 方式執行(for development) 
    #--------------------------------------------------------------------------
    IF fgl_getenv("FGLAPPSERVER") IS NOT NULL THEN
       CALL aws_spcsrv_startServer("0")
    ELSE
       IF NUM_ARGS() = 0 THEN
          CALL aws_spcsrv_Help()
       ELSE
          CASE ARG_VAL(1) CLIPPED
              WHEN "-W"
                   CALL aws_spcsrv_generateWSDL(ARG_VAL(2))
              WHEN "-S"
                   CALL aws_spcsrv_startServer(ARG_VAL(2))
              OTHERWISE
                   CALL aws_spcsrv_Help()
          END CASE
       END IF
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
END MAIN
 
 
#------------------------------------------------------------------------------
# 顯示 HELP 說明訊息
#------------------------------------------------------------------------------
FUNCTION aws_spcsrv_Help()
    DISPLAY "Usage:"
    DISPLAY "  r.r2 aws_spcsrv -W serverURL  (Generate WSDL file)"
    DISPLAY "  r.r2 aws_spcsrv -S serverPort (Start service)"
    DISPLAY "Example:"
    DISPLAY "  r.r2 aws_spcsrv -W http://localhost:8090"
    DISPLAY "  r.r2 aws_spcsrv -S 8090"
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 產生 WSDL 檔, 可供 SPC 端撰寫呼叫程式(通常第一次產生即可)
#------------------------------------------------------------------------------
FUNCTION aws_spcsrv_generateWSDL(p_serverURL)
    DEFINE p_serverURL   STRING,
           l_ret	 LIKE type_file.num10   #No.FUN-680130 INTEGER
 
 
    CALL fgl_ws_setoption("wsdl_stringsize", 0)
    LET l_ret = fgl_ws_server_generateWSDL(
                 "TIPTOPGateWay",
                 p_serverURL CLIPPED,
                 fgl_getenv("TEMPDIR") || "/spc.wsdl"
                )
    IF l_ret = 0 THEN
       DISPLAY "'" || fgl_getenv("TEMPDIR") || "/spc.wsdl' has been successfully generated ..."
    ELSE
       DISPLAY "Generation of WSDL failed!"
    END IF
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 啟動 service, 處理連線的 request 需求
#------------------------------------------------------------------------------
FUNCTION aws_spcsrv_startServer(p_serverPort)
    DEFINE p_serverPort	STRING,
           l_ret	LIKE type_file.num10   #No.FUN-680130 INTEGER
    
 
    CALL fgl_ws_server_start(p_serverPort)      #Start service
    DISPLAY "Starting service ..."
    WHILE TRUE
        LET l_ret = fgl_ws_server_process(-1)   #'-1' 代表一直等待 request 直到中斷
        DISPLAY "l_ret:",l_ret                  #FUN-960169
        IF INT_FLAG THEN                        #當按中斷鍵時
           DISPLAY ""
           DISPLAY "Shutdown service ..."
           CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
           EXIT PROGRAM 
        END IF
 
        #----------------------------------------------------------------------
        # 處理後狀態值, '0' 表正常處理, 其餘回傳值表各種 error 狀態
        #----------------------------------------------------------------------
        #No.FUN-7C0055
        CASE l_ret
            WHEN 0                         
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                          "Request processed successfully."
            WHEN -1                                    #無 request(time out)
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Time out reached."
            WHEN -2
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Disconnected from application server."
                 #EXIT PROGRAM            #FUN-960169 mark
            WHEN -3
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Lost connection with the client."
            WHEN -4
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Server process has been interrupted with Ctrl-C"
            WHEN -5
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Bad HTTP request received."
            WHEN -6
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Malformed or bad SOAP envelope received."
            WHEN -7
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Malformed or bad XML document received."
            WHEN -8
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "HTTP error."
            WHEN -9
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Unsupported operation."
            WHEN -10
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Internal server error."
                 #EXIT PROGRAM         #CHI-920065 add #FUN-960169 mark
            WHEN -11
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "WSDL Generation failed."
        #--FUN-960169--start--
            WHEN -12
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "WSDL Service not found."
            WHEN -13
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Reserved."
            WHEN -14
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Incoming request overflow."
            WHEN -15
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Server was not started."
            WHEN -16
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Request still in progress."
            WHEN -17
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Stax response error."
        END CASE
        IF l_ret <> 0 THEN
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD 
          EXIT PROGRAM
        END IF
        #--FUN-960169--end--
        #END No.FUN-7C0055
    END WHILE
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 透過 SOAP 被呼叫時實際執行的 4GL function(PUBLISHED!)
#------------------------------------------------------------------------------
FUNCTION aws_spcsrv()
    DEFINE l_str	STRING,
           l_file	STRING,
           l_cmd	STRING
    DEFINE l_ch         base.Channel
    DEFINE l_start      DATETIME HOUR TO FRACTION(5),
           l_end        DATETIME HOUR TO FRACTION(5),
           l_duration   INTERVAL SECOND TO FRACTION(5)
 
 
    INITIALIZE g_output.strXMLOutput TO NULL
    INITIALIZE g_spc_doc TO NULL
    INITIALIZE g_request TO NULL
    INITIALIZE g_response TO NULL
    INITIALIZE g_method TO NULL
    INITIALIZE g_action TO NULL
    INITIALIZE g_spc_version TO NULL
   #INITIALIZE g_database TO NULL      #FUN-B80064   MARK
    INITIALIZE g_data_base TO NULL     #FUN-B80064   ADD
    LET g_status = "0"
    LET g_err_str = NULL
    LET g_bgjob = 'Y'
    LET g_prog = 'aws_spcsrv'
    LET g_user = 'tiptop'
 
    LET l_start = CURRENT HOUR TO FRACTION(5)   #紀錄開始時間
 
    #-----------------------------------------------------------------------
    # 記錄此次呼叫的 <Request> xml
    #-----------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/aws_spcsrv-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "a")
    CALL l_ch.setDelimiter("")
    IF STATUS = 0 THEN
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL l_ch.write(l_str)
       CALL l_ch.write("")
 
       LET l_str = "Method: ", g_method
       CALL l_ch.write(l_str)
       CALL l_ch.write("")
    
       CALL l_ch.write("Request XML:")
       CALL l_ch.write(g_input.strXMLInput)
       CALL l_ch.write("")
       CALL l_ch.close()
 
#      LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>&1" #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009 
    END IF
 
 
    CALL aws_spcsrv_processRequest()
 
    CALL aws_spcsrv_prepareResponse()
 
    IF g_status = "0" THEN
       CALL aws_spcsrv_switchDatabase()
    END IF
 
    #--------------------------------------------------------------------------
    # 依據 method name 呼叫對應 function 處理需求
    #--------------------------------------------------------------------------
    IF g_status = "0" THEN
       CASE g_method CLIPPED
            WHEN "SetQCForm"
                 CALL aws_spcsrv_SetQCForm()
            OTHERWISE
                 LET g_method = "unknown"
       END CASE
 
       IF g_method != "unknown" THEN
          DISPLAY ""
          DISPLAY "Calling method name: ", g_method
       END IF
    END IF
 
    CALL aws_spcsrv_processResponse()
 
    #--------------------------------------------------------------------------
    # 紀錄此次呼叫的 <Response> xml
    #--------------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/aws_spcsrv-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "a")
    CALL l_ch.setDelimiter("")
    IF STATUS = 0 THEN
       CALL l_ch.write("Response XML:")
       CALL l_ch.write(g_output.strXMLOutput)
       CALL l_ch.write("")
       
       LET l_end = CURRENT HOUR TO FRACTION(5)   #紀錄結束時間
       LET l_duration = l_end - l_start          #紀錄處理花費時間
       LET l_str = "Duration: ", l_duration ," seconds."
       CALL l_ch.write(l_str)
       CALL l_ch.write("")
       CALL l_ch.write("#------------------------------------------------------------------------------#")
       CALL l_ch.write("")
       CALL l_ch.write("")
       CALL l_ch.close()
 
#      LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>&1"  #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009  
    END IF
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 處理 request xml string, 讀取內容以為後續解析 xml content
#------------------------------------------------------------------------------
FUNCTION aws_spcsrv_processRequest()
    DEFINE l_ch   base.Channel
    DEFINE l_file STRING
    DEFINE l_doc  om.DomDocument
 
 
    #--------------------------------------------------------------------------
    # 產生一 temp xml file, 讀取後判斷是否為合法的 xml document,
    # 若非合法的 xml document, 應回傳錯誤
    #--------------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "w")
    CALL l_ch.setDelimiter(NULL)
    CALL l_ch.write(g_input.strXMLInput)
    CALL l_ch.close()
 
    LET l_doc = om.DomDocument.createFromXmlFile(l_file)
    RUN "rm -f " || l_file
    IF l_doc IS NULL THEN
       LET g_status = "invaild"
    ELSE
       LET g_request = l_doc.getDocumentElement()
       LET g_method = g_request.getAttribute("name")
       LET g_spc_version = g_request.getAttribute("version")
       LET g_qc_prog = aws_xml_getTagAttribute(g_request,"ProgramID", "name")
       IF g_method CLIPPED != "GetDatabaseID" THEN
          LET g_action = g_request.getAttribute("action")
         #LET g_database = aws_xml_getTagAttribute(g_request,"Database", "name")         #FUN-B80064    MARK 
          LET g_data_base = aws_xml_getTagAttribute(g_request,"Database", "name")        #FUN-B80064    ADD
       END IF
    END IF
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 處理 回傳 SPC client Respons string
#------------------------------------------------------------------------------
FUNCTION aws_spcsrv_prepareResponse()
    LET g_spc_doc = om.DomDocument.create("Response")
    LET g_response = g_spc_doc.getDocumentElement()
    CALL g_response.setAttribute("name", g_method CLIPPED)
    CALL g_response.setAttribute("action", g_action CLIPPED)
    CALL g_response.setAttribute("version", g_spc_version CLIPPED)
    LET g_snode = g_response.createChild("Status")
    CALL g_snode.setAttribute("result", "1")
    CALL g_snode.setAttribute("desc", "Process successfully.")
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 處理 response xml string, 回傳 SPC client
#------------------------------------------------------------------------------
FUNCTION aws_spcsrv_processResponse()
    DEFINE l_msg      STRING
    DEFINE l_status   STRING
    DEFINE l_ch       base.Channel
    DEFINE l_buf      STRING
    DEFINE l_i        LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE l_file     STRING
 
 
    #--------------------------------------------------------------------------
    # 依最後狀態值變數指定對應的狀態說明
    #--------------------------------------------------------------------------
    INITIALIZE l_msg TO NULL
    CASE g_status CLIPPED
         WHEN "invalid"
              LET l_status = "0"
              LET l_msg = "Invalid request xml content."
         WHEN "unknown"
              LET l_status = "0"
              LET l_msg = "Unknown/Unsupported request method name."
         WHEN "0"
              LET l_status = "1"
              LET l_msg = "Process successfully."
         WHEN "qc-ins-failed"
              LET l_status = "0"
              LET l_msg = "Process QC insertion failed."
         WHEN "qc-upd-failed"
              LET l_status = "0"
              LET l_msg = "Process QC insertion failed."
         OTHERWISE
              LET l_status = "0"
              LET l_msg = cl_getmsg(g_status CLIPPED, "0")
              IF cl_null(l_msg) THEN
                 LET l_ch = base.Channel.create()
                 CALL l_ch.openPipe("finderr " || g_status || " 0", "r")
                 CALL l_ch.setDelimiter("")
                 WHILE l_ch.read(l_buf)
                     IF cl_null(l_buf) THEN
                        EXIT WHILE
                     END IF
                     LET l_msg = l_msg CLIPPED, " ", l_buf CLIPPED
                 END WHILE
                 CALL l_ch.close()
                 IF l_msg.getIndexOf("無此錯誤訊息", 1) THEN
                    LET l_msg = g_status
                 END IF
              END IF
    END CASE
 
    IF NOT cl_null(g_err_str) THEN
         LET l_msg = g_err_str
    END IF
 
    CALL g_snode.setAttribute("result", l_status)
    CALL g_snode.setAttribute("desc", l_msg)
 
    #--------------------------------------------------------------------------
    # 將 Response Xml 文件以字串方式傳回
    #--------------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
    CALL g_response.writeXml(l_file)
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "r")
    CALL l_ch.setDelimiter(NULL)
    LET l_i = 1
    WHILE l_ch.read(l_buf)
        IF l_i != 1 THEN
           LET g_output.strXMLOutput = g_output.strXMLOutput, '\n'
        END IF
        LET g_output.strXMLOutput = g_output.strXMLOutput, l_buf CLIPPED
        LET l_i = l_i + 1
    END WHILE
    CALL l_ch.close()
    RUN "rm -f " || l_file
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 切換為 request 指定工廠
#------------------------------------------------------------------------------
FUNCTION aws_spcsrv_switchDatabase()
    DEFINE l_db   LIKE azp_file.azp03   #No.FUN-680130 VARCHAR(10)
 
     #LET l_db = g_database       #FUN-B80064   MARK
     LET l_db = g_data_base        #FUN-B80064   ADD 
#    CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
     CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
     CLOSE DATABASE
     DATABASE l_db
#     CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
     CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069
     IF SQLCA.SQLCODE THEN
        LET g_status = SQLCA.SQLCODE
     END IF
     LET g_dbs = l_db
 
END FUNCTION
 
 
FUNCTION aws_spcsrv_processRecordSet(p_recordset)
     DEFINE p_recordset   om.DomNode
     DEFINE l_list        om.NodeList
     DEFINE l_i           LIKE type_file.num10   #No.FUN-680130 INTEGER
     DEFINE l_node        om.DomNode
     DEFINE l_name        STRING,
            l_value       STRING
     DEFINE l_child       om.DomNode
 
     
     #-------------------------------------------------------------------------
     # 解析 RecordSet, 回傳於 SPC Table 欄位
     #-------------------------------------------------------------------------
     LET l_child = g_spc_doc.createElement("Row")
     LET l_list = p_recordset.selectByTagName("Field")
     FOR l_i = 1 TO l_list.getLength()
         INITIALIZE l_name TO NULL
         INITIALIZE l_value TO NULL
         LET l_node = l_list.item(l_i)
         LET l_name = l_node.getAttribute("name")
         LET l_value = l_node.getAttribute("value")
         CALL l_child.setAttribute(l_name CLIPPED, l_value CLIPPED)
     END FOR
     RETURN l_child
END FUNCTION
 
#------------------------------------------------------------------------------
# 呼叫 ERP , 進行 SPC -> ERP 更新 QC 資料或新增 QC 單(分批檢驗)
#------------------------------------------------------------------------------
FUNCTION aws_spcsrv_SetQCForm()
    DEFINE l_list    om.NodeList,
           l_list1   om.NodeList
    DEFINE l_i       LIKE type_file.num10,  #No.FUN-680130 INTEGER 
           l_j       LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE l_child   om.DomNode
    DEFINE l_status  LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    CASE g_action CLIPPED
         WHEN "insert"
              #----------------------------------------------------------------
              # 依據 SPC 傳入的 QC 資料進行 Insert 至資料庫動作
              #----------------------------------------------------------------
              LET l_list = g_request.selectByTagName("Row")
              FOR l_i = 1 TO l_list.getLength()
                  LET l_child = l_list.item(l_i)
                  BEGIN WORK
                  #------------------------------------------------------------
                  # Insert 動作若失敗, 則使狀態碼變數為錯誤代碼
                  #------------------------------------------------------------
                  IF aws_spcsrv_updateRecordSet(l_child,'ins') THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                     LET g_status = "qc-ins-failed"
                  END IF
              END FOR 
              #----------------------------------------------------------------
              # 如找不到任何 <Row> 資料, 則視為不合法的 XML 文件
              #----------------------------------------------------------------
              IF l_list.getLength() = 0 THEN
                 LET g_status = "invalid"
              END IF
         WHEN "update"
              #----------------------------------------------------------------
              # 依據 SPC 傳入的 QC 資料進行 update 至資料庫動作
              #----------------------------------------------------------------
              LET l_list = g_request.selectByTagName("Row")
              FOR l_i = 1 TO l_list.getLength()
                  LET l_child = l_list.item(l_i)
                  BEGIN WORK
                  #------------------------------------------------------------
                  # Update 動作若失敗, 則使狀態碼變數為錯誤代碼
                  #------------------------------------------------------------
                  IF aws_spcsrv_updateRecordSet(l_child,'upd') THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                     LET g_status = "qc-ins-failed"
                  END IF
              END FOR 
              #----------------------------------------------------------------
              # 如找不到任何 <Row> 資料, 則視為不合法的 XML 文件
              #----------------------------------------------------------------
              IF l_list.getLength() = 0 THEN
                 LET g_status = "invalid"
              END IF
 
         OTHERWISE
              LET g_status = "unknown"
    END CASE
END FUNCTION
 
FUNCTION aws_spcsrv_updateRecordSet(p_recordset,p_action)
    DEFINE p_recordset     om.DomNode
    DEFINE p_action        STRING
    DEFINE l_parent        om.DomNode
    DEFINE l_table         STRING
    DEFINE l_sql           STRING,
           l_cols          STRING,
           l_vals          STRING,
           l_keys          STRING,
           l_value         STRING
    DEFINE l_i             LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE l_j             LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE l_cmd           STRING
    DEFINE l_cmd2          STRING
    DEFINE l_wcb           RECORD LIKE wcb_file.*
    DEFINE l_wcc02         LIKE wcc_file.wcc02
    DEFINE l_wcc03         LIKE wcc_file.wcc03
    DEFINE l_aza65         LIKE aza_file.aza65
    DEFINE l_sma115        LIKE sma_file.sma115
    DEFINE l_key1          STRING
    DEFINE l_key2          STRING
    DEFINE l_key3          STRING
    DEFINE l_key4          STRING
    DEFINE l_key5          STRING
    DEFINE l_cnt           LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE ls_context_file STRING
    DEFINE ls_xml_file     STRING
    DEFINE ls_temp_path    STRING
    DEFINE l_channel       base.Channel
    DEFINE l_status        LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
    DEFINE l_str           STRING
    DEFINE l_ze03          LIKE ze_file.ze03
    DEFINE ls_server       STRING
    DEFINE ls_status       STRING
    DEFINE l_tag           LIKE type_file.num5    #No.FUN-680130 SMALLINT
    DEFINE l_value2        STRING
 
    LET l_parent = p_recordset.getParent()
    LET l_table = l_parent.getAttribute("name")
 
    LET l_wcb.wcb01 = g_qc_prog
    SELECT * INTO l_wcb.* FROM wcb_file WHERE wcb01 = l_wcb.wcb01 
    SELECT aza65 INTO l_aza65 FROM aza_file
    SELECT sma115 INTO l_sma115 FROM sma_file
 
    IF NOT cl_null(l_wcb.wcb03) THEN
       LET l_key1 = aws_xml_getTagAttribute(p_recordset,"Row", l_wcb.wcb03 CLIPPED)
    END IF
    IF NOT cl_null(l_wcb.wcb04) THEN
       LET l_key2 = aws_xml_getTagAttribute(p_recordset,"Row", l_wcb.wcb04 CLIPPED)
    END IF
    IF NOT cl_null(l_wcb.wcb05) THEN
       LET l_key3 = aws_xml_getTagAttribute(p_recordset,"Row", l_wcb.wcb05 CLIPPED)
    END IF
    IF NOT cl_null(l_wcb.wcb06) THEN
       LET l_key4 = aws_xml_getTagAttribute(p_recordset,"Row", l_wcb.wcb06 CLIPPED)
    END IF
    IF NOT cl_null(l_wcb.wcb07) THEN
       LET l_key5 = aws_xml_getTagAttribute(p_recordset,"Row", l_wcb.wcb07 CLIPPED)
    END IF
 
    LET ls_temp_path = FGL_GETENV("TEMPDIR")
    LET ls_server = fgl_getenv("FGLAPPSERVER")
    IF cl_null(ls_server) THEN
       LET ls_server = fgl_getenv("FGLSERVER")
    END IF
 
    LET ls_context_file = ls_temp_path,"/aws_spcsrv_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || g_qc_prog CLIPPED || ".txt"
    RUN "rm -f " || ls_context_file ||" 2>/dev/null"
 
    LET ls_xml_file = ls_temp_path,"/aws_spcsrv_xml_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || g_qc_prog CLIPPED || ".txt"
    RUN "rm -f " || ls_xml_file ||" 2>/dev/null"
    CALL p_recordset.writeXML(ls_xml_file)
    IF p_action = 'ins' THEN
       IF NOT cl_null(l_wcb.wcb03) THEN
          LET l_keys = l_wcb.wcb03 CLIPPED ,"='",l_key1,"'"
       END IF
       IF NOT cl_null(l_wcb.wcb04) THEN
          LET l_keys = l_keys," AND ", l_wcb.wcb04 CLIPPED ,"='",l_key2,"'"
       END IF
       IF NOT cl_null(l_wcb.wcb05) THEN
          LET l_keys = l_keys," AND ", l_wcb.wcb05 CLIPPED ,"='",l_key3,"'"
       END IF
       IF NOT cl_null(l_wcb.wcb06) THEN
          LET l_keys = l_keys," AND ", l_wcb.wcb06 CLIPPED ,"='",l_key4,"'"
       END IF
       IF NOT cl_null(l_wcb.wcb07) THEN
          LET l_keys = l_keys," AND ", l_wcb.wcb07 CLIPPED ,"='",l_key5,"'"
       END IF
       LET l_sql = "SELECT count(*) FROM ", l_wcb.wcb02 CLIPPED," WHERE ", l_keys
       display l_sql
       PREPARE conf_pre FROM l_sql
       DECLARE conf_cur CURSOR FOR conf_pre
       FOREACH conf_cur INTO l_cnt 
       END FOREACH
       IF l_cnt > 0 THEN
          LET p_action = 'upd'
          LET g_action = 'update'
          CALL g_response.setAttribute("action", g_action CLIPPED)
       END IF
    END IF
    #若是批次檢驗，需新增一張 QC 單 
    IF p_action = "ins" OR l_aza65='Y' OR l_sma115 = "Y" THEN
       LET l_cmd = g_qc_prog CLIPPED
       IF NOT cl_null(l_wcb.wcb03) THEN
          LET l_cmd = l_cmd ," '",l_key1 ,"'"
       END IF
       IF NOT cl_null(l_wcb.wcb04) THEN
          LET l_cmd = l_cmd ," '",l_key2 ,"'"
       END IF
       IF NOT cl_null(l_wcb.wcb05) THEN
          LET l_cmd = l_cmd ," '",l_key3 ,"'"
       END IF
       IF NOT cl_null(l_wcb.wcb06) THEN
          LET l_cmd = l_cmd ," '",l_key4 ,"'"
       END IF
       IF NOT cl_null(l_wcb.wcb07) THEN
          LET l_cmd = l_cmd ," '",l_key5 ,"'"
       END IF
    END IF
    IF p_action = "ins" THEN
       LET l_cmd2 = l_cmd , " 'SPC_ins'"
         
       LET mi_spc_trigger = TRUE
 
       CALL cl_cmdrun_wait(l_cmd2)
 
       LET mi_spc_trigger = FALSE
       IF mi_spc_status > 0 THEN
          LET l_status = '-'
          SELECT ze03 INTO l_ze03 FROM ze_file
             WHERE ze01 = 'aws-086' AND ze02 = l_lang
          LET l_str =  g_qc_prog ," ",l_ze03
          RUN "rm -f " || ls_context_file ||" 2>/dev/null"
          RUN "rm -f " || ls_xml_file ||" 2>/dev/null"
          RETURN FALSE
       ELSE
          LET l_channel = base.Channel.create()
          CALL l_channel.openFile(ls_context_file, "r")
          WHILE l_channel.read(l_str)
                 IF NOT cl_null(l_str) THEN
                    LET ls_status = '-'
                    LET g_err_str = l_str
                    EXIT WHILE
                 END IF
          END WHILE
          CALL l_channel.close()
       END IF
    ELSE
       #更新確認碼 OR 雙單位 
       IF l_aza65 = 'Y' OR l_sma115 = "Y" THEN
          LET l_cmd2 = l_cmd , " 'SPC_upd'"
          LET mi_spc_trigger = TRUE
          LET mi_spc_xml = p_recordset
       
          CALL cl_cmdrun_wait(l_cmd2)
       
          LET mi_spc_xml = ""
          LET mi_spc_trigger = FALSE
          IF mi_spc_status > 0 THEN
             LET l_status = '-'
             SELECT ze03 INTO l_ze03 FROM ze_file
                WHERE ze01 = 'aws-086' AND ze02 = l_lang
             LET l_str =  g_qc_prog ," ",l_ze03
             LET ls_status = '-'
          ELSE
             LET l_channel = base.Channel.create()
             CALL l_channel.openFile(ls_context_file, "r")
             WHILE l_channel.read(l_str)
                 IF NOT cl_null(l_str) THEN
                    LET ls_status = '-'
                    LET g_err_str = l_str
                    EXIT WHILE
                 END IF
             END WHILE
             CALL l_channel.close()
          END IF
       ELSE
          CALL aws_spcfld(g_qc_prog,l_table,'','') 
          RETURNING l_tag,l_value,l_value2 
          IF l_tag = 0 THEN
                LET ls_status = '-'
          END IF
       END IF
    END IF
    RUN "rm -f " || ls_context_file ||" 2>/dev/null"
    RUN "rm -f " || ls_xml_file ||" 2>/dev/null"
    IF ls_status = '-' THEN
         RETURN FALSE
    ELSE
         RETURN TRUE
    END IF
END FUNCTION
