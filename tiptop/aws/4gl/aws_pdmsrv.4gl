# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: aws_pdmsrv
# Descriptions...: TIPTOP & PDM 整合 Services
# Usage .........: $FGLRUN aws_pdmsrv
# Date & Author..: 2006/02/17 by Brendan FUN-5A0211
# Modify.........: No.FUN-760068 07/06/25 By Echo ERP 調整新增 ECN 單功能, 加入判斷是否有尚未確認的 ECN 單並回覆.
# Modify.........: No.FUN-7C0055 07/12/19 By Echo 調整Request處理後狀態值說明
# Modify.........: No.MOD-890235 08/09/24 By Smapmin 新增ima915/ima916/ima150/ima151/ima152
# Modify.........: No.CHI-920065 09/02/19 By Vicky 調整當發生"Internal server error"時 EXIT PROGRAM
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:FUN-960169 09/10/22 By Echo Genero 2.11新增web service錯誤代碼-12到-17
# Modify.........: NO.FUN-9B0068 09/11/10 BY lilingyu 臨時表字段改成LIKE的形式
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-A10109 10/03/15 by rainy  g_no_ep,g_no_sp 抓法改 call sub
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A90024 10/11/15 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-C40006 13/01/10 By Nina 只要程式有UPDATE bma_file 的任何一個欄位時,多加bmadate=g_today
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today

IMPORT os   #No.FUN-9C0009 
IMPORT com
 
DATABASE ds  #FUN-5A0211
 
GLOBALS "../../config/top.global"
 
#------------------------------------------------------------------------------
# Global 變數定義 
#   g_input : PDM request XML string
#   g_output: TIPTOP response XML string
#------------------------------------------------------------------------------
DEFINE g_input	RECORD
                   strXMLInput STRING
                END RECORD,
       g_output	RECORD
                   strXMLOutput STRING
                END RECORD
 
DEFINE g_pdm_doc          om.DomDocument
DEFINE g_request      om.DomNode
DEFINE g_response     om.DomNode,
       g_snode        om.DomNode,
       g_dnode        om.DomNode
DEFINE g_method       STRING
DEFINE g_status       STRING
DEFINE g_action       STRING
DEFINE g_pdm_version      STRING
#DEFINE g_database     STRING    #FUN-B80064   MARK
DEFINE g_data_base     STRING    #FUN-B80064   ADD
DEFINE g_slip         STRING
DEFINE g_default      om.DomNode
DEFINE g_tabfile      DYNAMIC ARRAY OF STRING     #Table個數
DEFINE g_ima          RECORD LIKE ima_file.*
 
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
    CALL fgl_ws_server_setNamespace("http://tempuri.org/aws_pdmsrv")
    CALL fgl_ws_server_publishfunction( 
           "TIPTOPGateWay",
           "http://tempuri.org/aws_pdmsrv", "g_input",
           "http://tempuri.org/aws_pdmsrv", "g_output",
           "aws_pdmsrv"
         )
 
    #--------------------------------------------------------------------------
    # .若 $FGLAPPSERVER 有自動設定時, 則為 application server mode(for deployment)
    # .若為一般執行狀態(r.r2 / exe2....), 可加上參數
    #    -W: 產生 WSDL file
    #    -S: 以 standalone mode 方式執行(for development) 
    #--------------------------------------------------------------------------
    IF fgl_getenv("FGLAPPSERVER") IS NOT NULL THEN
       CALL aws_pdmsrv_startServer("0")
    ELSE
       IF NUM_ARGS() = 0 THEN
          CALL aws_pdmsrv_Help()
       ELSE
          CASE ARG_VAL(1) CLIPPED
              WHEN "-W"
                   CALL aws_pdmsrv_generateWSDL(ARG_VAL(2))
              WHEN "-S"
                   CALL aws_pdmsrv_startServer(ARG_VAL(2))
              OTHERWISE
                   CALL aws_pdmsrv_Help()
          END CASE
       END IF
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
END MAIN
 
 
#------------------------------------------------------------------------------
# 顯示 HELP 說明訊息
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_Help()
    DISPLAY "Usage:"
    DISPLAY "  r.r2 aws_pdmsrv -W serverURL  (Generate WSDL file)"
    DISPLAY "  r.r2 aws_pdmsrv -S serverPort (Start service)"
    DISPLAY "Example:"
    DISPLAY "  r.r2 aws_pdmsrv -W http://localhost:8090"
    DISPLAY "  r.r2 aws_pdmsrv -S 8090"
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 產生 WSDL 檔, 可供 PDM 端撰寫呼叫程式(通常第一次產生即可)
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_generateWSDL(p_serverURL)
    DEFINE p_serverURL   STRING,
           l_ret	LIKE type_file.num10
 
 
    CALL fgl_ws_setoption("wsdl_stringsize", 0)
    LET l_ret = fgl_ws_server_generateWSDL(
                 "TIPTOPGateWay",
                 p_serverURL CLIPPED,
                 fgl_getenv("TEMPDIR") || "/pdm.wsdl"
                )
    IF l_ret = 0 THEN
       DISPLAY "'" || fgl_getenv("TEMPDIR") || "/pdm.wsdl' has been successfully generated ..."
    ELSE
       DISPLAY "Generation of WSDL failed!"
    END IF
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 啟動 service, 處理連線的 request 需求
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_startServer(p_serverPort)
    DEFINE p_serverPort	STRING,
           l_ret	LIKE type_file.num10
    
 
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
FUNCTION aws_pdmsrv()
    DEFINE l_str	STRING,
           l_file	STRING,
           l_cmd	STRING
    DEFINE l_ch         base.Channel
    DEFINE l_start      DATETIME HOUR TO FRACTION(5),
           l_end        DATETIME HOUR TO FRACTION(5),
           l_duration   INTERVAL SECOND TO FRACTION(5)
 
 
    INITIALIZE g_output.strXMLOutput TO NULL
    INITIALIZE g_pdm_doc TO NULL
    INITIALIZE g_request TO NULL
    INITIALIZE g_response TO NULL
    INITIALIZE g_method TO NULL
    INITIALIZE g_action TO NULL
    INITIALIZE g_pdm_version TO NULL
    INITIALIZE g_data_base TO NULL
    INITIALIZE g_slip TO NULL
    LET g_status = "0"
 
    LET g_bgjob = 'Y'
    LET g_prog = 'aws_pdmsrv'
    LET g_user = 'tiptop'
 
    LET l_start = CURRENT HOUR TO FRACTION(5)   #紀錄開始時間
    #-----------------------------------------------------------------------
    # 記錄此次呼叫的 <Request> xml
    #-----------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/aws_pdmsrv-", TODAY USING 'YYYYMMDD', ".log"
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
 
#      LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>&1"
#      RUN l_cmd
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    END IF
 
    CALL aws_pdmsrv_processRequest()
 
    CALL aws_pdmsrv_prepareResponse()
 
    IF g_status = "0" THEN
       CALL aws_pdmsrv_switchDatabase()
    END IF
 
    #--------------------------------------------------------------------------
    # 依據 method name 呼叫對應 function 處理需求
    #--------------------------------------------------------------------------
    IF g_status = "0" THEN
       CASE g_method CLIPPED
            WHEN "GetDatabaseID"
                 CALL aws_pdmsrv_GetDatabaseID()
            WHEN "GetItemList"
                 CALL aws_pdmsrv_GetItemList() 
            WHEN "GetSlipList"
                 CALL aws_pdmsrv_GetSlipList() 
            WHEN "GetRecordSet"
                 CALL aws_pdmsrv_GetRecordSet() 
            WHEN "SetRecordSet"
#                 CALL aws_pdmsrv_prepareDefault()
                 CALL aws_pdmsrv_SetRecordSet() 
#                 DROP TABLE default_tmp
            WHEN "GetSchemaList"
                 CALL aws_pdmsrv_prepareDefault()
                 CALL aws_pdmsrv_GetSchemaList() 
                 DROP TABLE default_tmp
            OTHERWISE
                 LET g_method = "unknown"
       END CASE
 
       IF g_method != "unknown" THEN
          DISPLAY ""
          DISPLAY "Calling method name: ", g_method
       END IF
    END IF
 
    CALL aws_pdmsrv_processResponse()
 
    #--------------------------------------------------------------------------
    # 紀錄此次呼叫的 <Response> xml
    #--------------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/aws_pdmsrv-", TODAY USING 'YYYYMMDD', ".log"
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
 
#      LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>&1"
#      RUN l_cmd
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    END IF
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 抓取 request xml content 中某 tag name 中的 attribute 值
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_getTagAttribute(p_tag, p_attr)
    DEFINE p_tag    STRING,
           p_attr   STRING
    DEFINE l_list   om.NodeList
    DEFINE l_node   om.DomNode
 
 
    LET l_list = g_request.selectByTagName(p_tag)
    LET l_node = l_list.item(1)
    RETURN l_node.getAttribute(p_attr)
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 處理 request xml string, 讀取內容以為後續解析 xml content
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_processRequest()
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
       LET g_pdm_version = g_request.getAttribute("version")
       IF g_method CLIPPED != "GetDatabaseID" THEN
          LET g_action = g_request.getAttribute("action")
         #LET g_database = aws_pdmsrv_getTagAttribute("Database", "name")         #FUN-B80064    MARK
          LET g_data_base = aws_pdmsrv_getTagAttribute("Database", "name")        #FUN-B80064    ADD
       END IF
    END IF
END FUNCTION
 
 
FUNCTION aws_pdmsrv_prepareResponse()
    LET g_pdm_doc = om.DomDocument.create("Response")
    LET g_response = g_pdm_doc.getDocumentElement()
    CALL g_response.setAttribute("name", g_method CLIPPED)
    IF g_method CLIPPED != "GetDatabaseID" THEN
       CALL g_response.setAttribute("action", g_action CLIPPED)
    END IF
    CALL g_response.setAttribute("version", g_pdm_version CLIPPED)
    LET g_snode = g_response.createChild("Status")
    CALL g_snode.setAttribute("result", "1")
    CALL g_snode.setAttribute("desc", "Process successfully.")
    IF g_method CLIPPED != "GetDatabaseID" THEN
       LET g_dnode = g_response.createChild("Database")
       CALL g_dnode.setAttribute("name", g_data_base CLIPPED)
    END IF
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 處理 response xml string, 回傳 PDM client
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_processResponse()
    DEFINE l_msg      STRING
    DEFINE l_status   STRING
    DEFINE l_ch       base.Channel
    DEFINE l_buf      STRING
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_file     STRING
    DEFINE buf        base.StringBuffer
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
              IF g_method CLIPPED = "SetRecordSet" AND g_action CLIPPED = "ECN" THEN
                 LET l_msg = g_slip CLIPPED
              ELSE
                 LET l_msg = "Process successfully."
              END IF
         WHEN "item-failed"
              LET l_status = "0"
              LET l_msg = "Process Item insertion failed."
         WHEN "mbom-failed"
              LET l_status = "0"
              LET l_msg = "Process MBOM insertion failed."
         WHEN "ebom-failed"
              LET l_status = "0"
              LET l_msg = "Process EBOM insertion failed."
         WHEN "ecn-failed"
              LET l_status = "0"
              LET l_msg = "Process ECN creation failed."
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
    LET buf = base.StringBuffer.create()
    WHILE l_ch.read(l_buf)
       #IF l_i != 1 THEN
       #   LET g_output.strXMLOutput = g_output.strXMLOutput, '\n'
       #END IF
       #LET g_output.strXMLOutput = g_output.strXMLOutput, l_buf CLIPPED
 
        IF l_i !=1 THEN
          CALL buf.append('\n')
        END IF
        CALL buf.append(l_buf CLIPPED)
        LET l_i = l_i + 1
 
    END WHILE
    CALL l_ch.close()
    RUN "rm -f " || l_file
 
    LET g_output.strXMLOutput = buf.toString()
 
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 切換為 request 指定工廠
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_switchDatabase()
    DEFINE l_db   LIKE type_file.chr10
 
   
    IF g_method CLIPPED != "GetDatabaseID" THEN
      # LET l_db = g_database    #FUN-B80064   MARK
        LET l_db = g_data_base   #FUN-B80064   ADD
#       CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
       CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
       CLOSE DATABASE
       DATABASE l_db
#       CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
       CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069
       IF SQLCA.SQLCODE THEN
          LET g_status = SQLCA.SQLCODE
       END IF
    END IF
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 提供 ERP 目前所有工廠(資料庫) 資訊
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_GetDatabaseID()
    DEFINE l_azp   RECORD
                      azp01   LIKE azp_file.azp01,
                      azp03   LIKE azp_file.azp03
                   END RECORD
    DEFINE l_node  om.DomNode
 
 
    #--------------------------------------------------------------------------
    # 提供 ERP 目前設定工廠/說明予 PDM
    #--------------------------------------------------------------------------
    DECLARE azp_curs CURSOR FOR SELECT azp01, azp03 FROM azp_file WHERE azp053 = 'Y'
    IF SQLCA.SQLCODE THEN
       LET g_status = SQLCA.SQLCODE
       RETURN
    END IF
 
    FOREACH azp_curs INTO l_azp.*
         LET l_node = g_pdm_doc.createElement("Database")
         CALL l_node.setAttribute("name", l_azp.azp03 CLIPPED)
         CALL l_node.setAttribute("desc", l_azp.azp01 CLIPPED)
         CALL g_response.appendChild(l_node)
    END FOREACH
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 提供 ERP 指定資料庫中 '料件/BOM' 資訊
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_GetItemList()
    DEFINE l_ima     RECORD 
                        ima01   LIKE ima_file.ima01,
                        ima02   LIKE ima_file.ima02
                     END RECORD
    DEFINE l_bmq     RECORD 
                        bmq01   LIKE bmq_file.bmq01,
                        bmq02   LIKE bmq_file.bmq02
                     END RECORD
    DEFINE l_bma     RECORD 
                        bma01   LIKE bma_file.bma01,
                        ima02   LIKE ima_file.ima02,
                        bma06   LIKE bma_file.bma06
                     END RECORD
    DEFINE l_bmo     RECORD 
                        bmo01   LIKE bmo_file.bmo01,
                        ima02   LIKE ima_file.ima02,
                        bmo011  LIKE bmo_file.bmo011,
                        bmo06   LIKE bmo_file.bmo06
                     END RECORD
    DEFINE l_sma118  LIKE sma_file.sma118
    DEFINE l_node    om.DomNode,
           l_child   om.DomNode
 
 
    LET l_node = g_dnode.createChild("Data")
    CASE g_action CLIPPED
         #---------------------------------------------------------------------
         # 提供料件編號及料號說明予 PDM
         #---------------------------------------------------------------------
         WHEN "MItem"
              DECLARE ima_curs CURSOR FOR SELECT ima01, ima02 FROM ima_file ORDER BY ima01
              IF SQLCA.SQLCODE THEN
                 LET g_status = SQLCA.SQLCODE
                 RETURN
              END IF
              FOREACH ima_curs INTO l_ima.*
                  LET l_child = l_node.createChild("Item")
                  CALL l_child.setAttribute("ima01", l_ima.ima01 CLIPPED)
                  CALL l_child.setAttribute("ima02", l_ima.ima02 CLIPPED)
              END FOREACH
         WHEN "EItem"
              DECLARE bmq_curs CURSOR FOR SELECT bmq01, bmq02 FROM bmq_file ORDER BY bmq01
              IF SQLCA.SQLCODE THEN
                 LET g_status = SQLCA.SQLCODE
                 RETURN
              END IF
              FOREACH bmq_curs INTO l_bmq.*
                  LET l_child = l_node.createChild("Item")
                  CALL l_child.setAttribute("bmq01", l_bmq.bmq01 CLIPPED)
                  CALL l_child.setAttribute("bmq02", l_bmq.bmq02 CLIPPED)
              END FOREACH
         #---------------------------------------------------------------------
         # 提供 BOM 主件編號及料號說明予 PDM
         #---------------------------------------------------------------------
         WHEN "MBOM"
              SELECT sma118 INTO l_sma118 FROM sma_file WHERE sma00='0'
              DECLARE bma_curs CURSOR FOR 
                SELECT bma01, ima02, bma06 FROM bma_file, OUTER ima_file 
                WHERE bma01 = ima_file.ima01 ORDER BY bma01,bma06
              IF SQLCA.SQLCODE THEN
                 LET g_status = SQLCA.SQLCODE
                 RETURN
              END IF
              FOREACH bma_curs INTO l_bma.*
                  LET l_child = l_node.createChild("Item")
                  CALL l_child.setAttribute("bma01", l_bma.bma01 CLIPPED)
                  CALL l_child.setAttribute("ima02", l_bma.ima02 CLIPPED)
                  IF l_sma118 = 'Y' THEN
                     CALL l_child.setAttribute("bma06", l_bma.bma06 CLIPPED)
                  END IF
              END FOREACH
         WHEN "EBOM"
              SELECT sma118 INTO l_sma118 FROM sma_file WHERE sma00='0'
              DECLARE bmo_curs CURSOR FOR 
                SELECT bmo01, bmq02, bmo011, bmo06 FROM bmo_file, OUTER bmq_file 
                WHERE bmo01 = bmq_file.bmq01 ORDER BY bmo01,bmo011,bmo06
              IF SQLCA.SQLCODE THEN
                 LET g_status = SQLCA.SQLCODE
                 RETURN
              END IF
              FOREACH bmo_curs INTO l_bmo.*
                  LET l_child = l_node.createChild("Item")
                  CALL l_child.setAttribute("bmo01", l_bmo.bmo01 CLIPPED)
                  CALL l_child.setAttribute("ima02", l_bmo.ima02 CLIPPED)
                  CALL l_child.setAttribute("bmo011", l_bmo.bmo011 CLIPPED)
                  IF l_sma118 = 'Y' THEN
                     CALL l_child.setAttribute("bmo06", l_bmo.bmo06 CLIPPED)
                  END IF
              END FOREACH
         OTHERWISE
              LET g_status = "unknown"
    END CASE
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 提供 ERP 指定資料庫中 'ECN' 單別資訊
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_GetSlipList()
    DEFINE l_smy     RECORD 
                        smyslip   LIKE smy_file.smyslip,
                        smydesc   LIKE smy_file.smydesc
                     END RECORD
    DEFINE l_node    om.DomNode,
           l_child   om.DomNode
 
 
    LET l_node = g_dnode.createChild("Data")
    CASE g_action CLIPPED
         #---------------------------------------------------------------------
         # 提供 ERP 設定 ECN 單別予 PDM
         #---------------------------------------------------------------------
         WHEN "ECN"
              DECLARE smy_curs CURSOR FOR SELECT smyslip, smydesc FROM smy_file WHERE smysys = 'abm' AND smykind = '1' AND smyacti = 'Y' ORDER BY smyslip
              IF SQLCA.SQLCODE THEN
                 LET g_status = SQLCA.SQLCODE
                 RETURN
              END IF
              FOREACH smy_curs INTO l_smy.*
                  IF SQLCA.SQLCODE THEN
                     CONTINUE FOREACH
                  END IF
                  LET l_child = l_node.createChild("Slip")
                  CALL l_child.setAttribute("smyslip", l_smy.smyslip CLIPPED)
                  CALL l_child.setAttribute("smydesc", l_smy.smydesc CLIPPED)
              END FOREACH
         OTHERWISE
              LET g_status = "unknown"
    END CASE
END FUNCTION
 
 
FUNCTION aws_pdmsrv_processRecordSet(p_recordset)
     DEFINE p_recordset   om.DomNode
     DEFINE l_list        om.NodeList
     DEFINE l_i           LIKE type_file.num10
     DEFINE l_node        om.DomNode
     DEFINE l_name        STRING,
            l_value       STRING
     DEFINE l_child       om.DomNode
 
     
     #-------------------------------------------------------------------------
     # 解析 RecordSet, 回傳於 PDM Table 欄位
     #-------------------------------------------------------------------------
     LET l_child = g_pdm_doc.createElement("Row")
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
# 提供 ERP 指定資料庫中指定 '料號/BOM 主件(單筆 or 多筆)' table 欄位資訊
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_GetRecordSet()
    DEFINE l_ima     RECORD LIKE ima_file.*,
           l_ima01   LIKE ima_file.ima01
    DEFINE l_bmq     RECORD LIKE bmq_file.*,
           l_bmq01   LIKE bmq_file.bmq01
    DEFINE l_bma     RECORD LIKE bma_file.*,
           l_bmb     RECORD LIKE bmb_file.*,
           l_bma01   LIKE bma_file.bma01,
           l_bma06   LIKE bma_file.bma06
    DEFINE l_bmo     RECORD LIKE bmo_file.*,
           l_bmp     RECORD LIKE bmp_file.*,
           l_bmo01   LIKE bmo_file.bmo01,
           l_bmo011  LIKE bmo_file.bmo011,
           l_bmo06   LIKE bmo_file.bmo06
    DEFINE l_node    om.DomNode,
           l_inode   om.DomNode,
           l_node1   om.DomNode,
           l_node2   om.DomNode,
           l_child   om.DomNode
    DEFINE l_list    om.NodeList
    DEFINE l_i       LIKE type_file.num10
 
 
    LET l_list = g_request.selectByTagName("Item")
    LET l_node = g_dnode.createChild("Data")
    CASE g_action CLIPPED
         #---------------------------------------------------------------------
         # 提供料件 Table 欄位給 PDM
         #---------------------------------------------------------------------
         WHEN "MItem"
              LET l_node = l_node.createChild("Record")
              LET l_node = l_node.createChild("Table")
              CALL l_node.setAttribute("name", "ima_file")
              #----------------------------------------------------------------
              # 依 PDM 傳入料號, SELECT 料件 Table 欄位
              #----------------------------------------------------------------
              FOR l_i = 1 TO l_list.getLength()
                  LET l_inode = l_list.item(l_i)
                  LET l_ima01 = l_inode.getAttribute("ima01")
                  SELECT * INTO l_ima.* FROM ima_file WHERE ima01 = l_ima01 ORDER BY ima01
                  IF SQLCA.SQLCODE THEN
                     CONTINUE FOR
                  END IF
                  LET l_child = aws_pdmsrv_processRecordSet(base.TypeInfo.create(l_ima))
                  CALL l_node.appendChild(l_child)
              END FOR
         WHEN "EItem"
              LET l_node = l_node.createChild("Record")
              LET l_node = l_node.createChild("Table")
              CALL l_node.setAttribute("name", "bmq_file")
              #----------------------------------------------------------------
              # 依 PDM 傳入料號, SELECT 料件 Table 欄位
              #----------------------------------------------------------------
              FOR l_i = 1 TO l_list.getLength()
                  LET l_inode = l_list.item(l_i)
                  LET l_bmq01 = l_inode.getAttribute("bmq01")
                  SELECT * INTO l_bmq.* FROM bmq_file WHERE bmq01 = l_bmq01 ORDER BY bmq01
                  IF SQLCA.SQLCODE THEN
                     CONTINUE FOR
                  END IF
                  LET l_child = aws_pdmsrv_processRecordSet(base.TypeInfo.create(l_bmq))
                  CALL l_node.appendChild(l_child)
              END FOR
         #---------------------------------------------------------------------
         # 提供 BOM Table 欄位給 PDM
         #---------------------------------------------------------------------
         WHEN "MBOM"
              FOR l_i = 1 TO l_list.getLength()
                  LET l_inode = l_list.item(l_i)
                  LET l_node2 = l_node.createChild("Record")
                  LET l_node1 = l_node2.createChild("Table")
                  CALL l_node1.setAttribute("name", "bma_file")
                  #------------------------------------------------------------
                  # 依 PDM 傳入的 BOM 主件編號 SELECT BOM 單頭檔欄位
                  #------------------------------------------------------------
                  LET l_bma01 = l_inode.getAttribute("bma01")
                  LET l_bma06 = l_inode.getAttribute("bma06")
                  IF cl_null(l_bma06) THEN
                     LET l_bma06 = " " 
                  END IF
                  SELECT * INTO l_bma.* FROM bma_file 
                     WHERE bma01 = l_bma01 AND bma06 = l_bma06 ORDER BY bma01
                  IF SQLCA.SQLCODE THEN
                     CONTINUE FOR
                  END IF
                  LET l_child = aws_pdmsrv_processRecordSet(base.TypeInfo.create(l_bma))
                  CALL l_node1.appendChild(l_child)
                  LET l_node1 = l_node2.createChild("Table")
                  CALL l_node1.setAttribute("name", "bmb_file")
                  #------------------------------------------------------------
                  # 依 PDM 傳入的 BOM 主件編號 SELECT BOM 單身檔欄位
                  #------------------------------------------------------------
                  DECLARE bmb_curs CURSOR FOR SELECT * FROM bmb_file 
                     WHERE bmb01 = l_bma01 AND bmb29 = l_bma06 ORDER BY bmb02
                  IF SQLCA.SQLCODE THEN
                     CONTINUE FOR
                  END IF
                  FOREACH bmb_curs INTO l_bmb.*
                      IF SQLCA.SQLCODE THEN
                         CONTINUE FOREACH
                      END IF
                      LET l_child = aws_pdmsrv_processRecordSet(base.TypeInfo.create(l_bmb))
                      CALL l_node1.appendChild(l_child)
                  END FOREACH
              END FOR
         WHEN "EBOM"
              FOR l_i = 1 TO l_list.getLength()
                  LET l_inode = l_list.item(l_i)
                  LET l_node2 = l_node.createChild("Record")
                  LET l_node1 = l_node2.createChild("Table")
                  CALL l_node1.setAttribute("name", "bmo_file")
                  #------------------------------------------------------------
                  # 依 PDM 傳入的 BOM 主件編號 SELECT BOM 單頭檔欄位
                  #------------------------------------------------------------
                  LET l_bmo01 = l_inode.getAttribute("bmo01")
                  LET l_bmo011 = l_inode.getAttribute("bmo011")
                  LET l_bmo06 = l_inode.getAttribute("bmo06")
                  IF cl_null(l_bmo06) THEN
                     LET l_bmo06 = " " 
                  END IF
                  SELECT * INTO l_bmo.* FROM bmo_file 
                     WHERE bmo01 = l_bmo01 AND bmo011 = l_bmo011
                       AND bmo06 = l_bmo06 ORDER BY bmo01
                  IF SQLCA.SQLCODE THEN
                     CONTINUE FOR
                  END IF
                  LET l_child = aws_pdmsrv_processRecordSet(base.TypeInfo.create(l_bmo))
                  CALL l_node1.appendChild(l_child)
                  LET l_node1 = l_node2.createChild("Table")
                  CALL l_node1.setAttribute("name", "bmp_file")
                  #------------------------------------------------------------
                  # 依 PDM 傳入的 BOM 主件編號 SELECT BOM 單身檔欄位
                  #------------------------------------------------------------
                  DECLARE bmp_curs CURSOR FOR SELECT * FROM bmp_file 
                     WHERE bmp01 = l_bmo01 AND bmp011 = l_bmo011
                       AND bmp28 = l_bmo06 ORDER BY bmp02
                  IF SQLCA.SQLCODE THEN
                     CONTINUE FOR
                  END IF
                  FOREACH bmp_curs INTO l_bmp.*
                      IF SQLCA.SQLCODE THEN
                         CONTINUE FOREACH
                      END IF
                      LET l_child = aws_pdmsrv_processRecordSet(base.TypeInfo.create(l_bmp))
                      CALL l_node1.appendChild(l_child)
                  END FOREACH
              END FOR
         OTHERWISE
              LET g_status = "unknown"
    END CASE
END FUNCTION
 
 
FUNCTION aws_pdmsrv_prepareDefault()
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    DROP TABLE default_tmp
#FUN-9B0068 --BEGIN--    
#    CREATE TEMP TABLE default_tmp
#    (
#      name  VARCHAR(10),
#      value VARCHAR(20)
#    );

    CREATE TEMP TABLE default_tmp(
      name  LIKE type_file.chr14,
      value LIKE type_file.chr20);
#FUN-9B0068 --end-- 
    CREATE UNIQUE INDEX default_tmp01 ON defaul_tmp (name)
    
    INSERT INTO default_tmp VALUES ('ima07', 'A')
    INSERT INTO default_tmp VALUES ('ima08', 'P')
    INSERT INTO default_tmp VALUES ('ima108', 'N')
    INSERT INTO default_tmp VALUES ('ima14', 'N')
    INSERT INTO default_tmp VALUES ('ima903', 'N')
    INSERT INTO default_tmp VALUES ('ima905', 'N')
    INSERT INTO default_tmp VALUES ('ima15', 'N')
    INSERT INTO default_tmp VALUES ('ima16', '99')
    INSERT INTO default_tmp VALUES ('ima18', '0')
    INSERT INTO default_tmp VALUES ('ima09', ' ')
    INSERT INTO default_tmp VALUES ('ima10', ' ')
    INSERT INTO default_tmp VALUES ('ima11', ' ')
    INSERT INTO default_tmp VALUES ('ima12', ' ')
    INSERT INTO default_tmp VALUES ('ima23', ' ')
    INSERT INTO default_tmp VALUES ('ima24', 'N')
    INSERT INTO default_tmp VALUES ('ima911', 'N') #3X
  ##NO.FUN-A20044   --begin
#   INSERT INTO default_tmp VALUES ('ima26', '0')
#   INSERT INTO default_tmp VALUES ('ima261', '0')
#   INSERT INTO default_tmp VALUES ('ima262', '0')
  ##NO.FUN-A20044   --end
    INSERT INTO default_tmp VALUES ('ima27', '0')
    INSERT INTO default_tmp VALUES ('ima271', '0')
    INSERT INTO default_tmp VALUES ('ima28', '0')
    INSERT INTO default_tmp VALUES ('ima30', TODAY)
    INSERT INTO default_tmp VALUES ('ima31_fac', '1')
    INSERT INTO default_tmp VALUES ('ima32', '0')
    INSERT INTO default_tmp VALUES ('ima33', '0')
    INSERT INTO default_tmp VALUES ('ima37', '0')
    INSERT INTO default_tmp VALUES ('ima38', '0')
    INSERT INTO default_tmp VALUES ('ima40', '0')
    INSERT INTO default_tmp VALUES ('ima41', '0')
    INSERT INTO default_tmp VALUES ('ima42', '0')
    INSERT INTO default_tmp VALUES ('ima44_fac', '1')
    INSERT INTO default_tmp VALUES ('ima45', '0')
    INSERT INTO default_tmp VALUES ('ima46', '0')
    INSERT INTO default_tmp VALUES ('ima47', '0')
    INSERT INTO default_tmp VALUES ('ima48', '0')
    INSERT INTO default_tmp VALUES ('ima49', '0')
    INSERT INTO default_tmp VALUES ('ima491', '0')
    INSERT INTO default_tmp VALUES ('ima50', '0')
    INSERT INTO default_tmp VALUES ('ima51', '1')
    INSERT INTO default_tmp VALUES ('ima52', '1')
    INSERT INTO default_tmp VALUES ('ima140', 'N')
    INSERT INTO default_tmp VALUES ('ima53', '0')
    INSERT INTO default_tmp VALUES ('ima531', '0')
    INSERT INTO default_tmp VALUES ('ima55_fac', '1')
    INSERT INTO default_tmp VALUES ('ima56', '1')
    INSERT INTO default_tmp VALUES ('ima561', '1')
    INSERT INTO default_tmp VALUES ('ima562', '0')
    INSERT INTO default_tmp VALUES ('ima57', '0')
    INSERT INTO default_tmp VALUES ('ima58', '0')
    INSERT INTO default_tmp VALUES ('ima59', '0')
    INSERT INTO default_tmp VALUES ('ima60', '0')
    INSERT INTO default_tmp VALUES ('ima61', '0')
    INSERT INTO default_tmp VALUES ('ima62', '0')
    INSERT INTO default_tmp VALUES ('ima63_fac', '1')
    INSERT INTO default_tmp VALUES ('ima64', '1')
    INSERT INTO default_tmp VALUES ('ima641', '1')
    INSERT INTO default_tmp VALUES ('ima65', '0')
    INSERT INTO default_tmp VALUES ('ima66', '0')
    INSERT INTO default_tmp VALUES ('ima68', '0')
    INSERT INTO default_tmp VALUES ('ima69', '0')
    INSERT INTO default_tmp VALUES ('ima70', 'N')
    INSERT INTO default_tmp VALUES ('ima107', 'N')
    INSERT INTO default_tmp VALUES ('ima147', 'N')
    INSERT INTO default_tmp VALUES ('ima71', '0')
    INSERT INTO default_tmp VALUES ('ima72', '0')
    INSERT INTO default_tmp VALUES ('ima77', '0')
    INSERT INTO default_tmp VALUES ('ima78', '0')
   #INSERT INTO default_tmp VALUES ('ima79', '0')
    INSERT INTO default_tmp VALUES ('ima80', '0')
    INSERT INTO default_tmp VALUES ('ima81', '0')
    INSERT INTO default_tmp VALUES ('ima82', '0')
    INSERT INTO default_tmp VALUES ('ima83', '0')
    INSERT INTO default_tmp VALUES ('ima84', '0')
    INSERT INTO default_tmp VALUES ('ima85', '0')
    INSERT INTO default_tmp VALUES ('ima852', 'N')
    INSERT INTO default_tmp VALUES ('ima853', 'N')
    INSERT INTO default_tmp VALUES ('ima86_fac', '1')
    INSERT INTO default_tmp VALUES ('ima871', '0')
    INSERT INTO default_tmp VALUES ('ima873', '0')
    INSERT INTO default_tmp VALUES ('ima88', '1')
    INSERT INTO default_tmp VALUES ('ima91', '0')
    INSERT INTO default_tmp VALUES ('ima92', 'N')
    INSERT INTO default_tmp VALUES ('ima93', 'NNNNNNNN')
    INSERT INTO default_tmp VALUES ('ima95', '0')
    INSERT INTO default_tmp VALUES ('ima96', '0')
    INSERT INTO default_tmp VALUES ('ima97', '0')
    INSERT INTO default_tmp VALUES ('ima98', '0')
    INSERT INTO default_tmp VALUES ('ima99', '0')
    INSERT INTO default_tmp VALUES ('ima100', 'N')
    INSERT INTO default_tmp VALUES ('ima101', '1')
    INSERT INTO default_tmp VALUES ('ima102', '1')
    INSERT INTO default_tmp VALUES ('ima103', '0')
    INSERT INTO default_tmp VALUES ('ima104', '0')
    INSERT INTO default_tmp VALUES ('ima105', 'N')
    INSERT INTO default_tmp VALUES ('ima110', '1')
    INSERT INTO default_tmp VALUES ('ima139', 'N')
    INSERT INTO default_tmp VALUES ('imaacti', 'P')  #3.5X
    INSERT INTO default_tmp VALUES ('imauser', 'tiptop')
#    INSERT INTO default_tmp VALUES ('imagrup', '')
    INSERT INTO default_tmp VALUES ('imadate', TODAY)
    INSERT INTO default_tmp VALUES ('ima901', TODAY)
    INSERT INTO default_tmp VALUES ('ima912', '0') #3X
    INSERT INTO default_tmp VALUES ('ima130', '1')
    INSERT INTO default_tmp VALUES ('ima121', '0')
    INSERT INTO default_tmp VALUES ('ima122', '0')
    INSERT INTO default_tmp VALUES ('ima123', '0')
    INSERT INTO default_tmp VALUES ('ima124', '0')
    INSERT INTO default_tmp VALUES ('ima125', '0')
    INSERT INTO default_tmp VALUES ('ima126', '0')
    INSERT INTO default_tmp VALUES ('ima127', '0')
    INSERT INTO default_tmp VALUES ('ima128', '0')
    INSERT INTO default_tmp VALUES ('ima129', '0')
    INSERT INTO default_tmp VALUES ('ima141', '0')
    INSERT INTO default_tmp VALUES ('ima1010', '0') #3.5x
    INSERT INTO default_tmp VALUES ('ima1001', '')  #3x
    INSERT INTO default_tmp VALUES ('ima1002', '')  #3x
    INSERT INTO default_tmp VALUES ('ima1014', '1') #3x
    INSERT INTO default_tmp VALUES ('ima909', '0')  #3x
    INSERT INTO default_tmp VALUES ('ima909', '0')  #3x
    INSERT INTO default_tmp VALUES ('ima910', ' ')  #3x
    INSERT INTO default_tmp VALUES ('ima913', 'N')  #3x
    INSERT INTO default_tmp VALUES ('ima915', '0')  #MOD-890235
    INSERT INTO default_tmp VALUES ('ima916', ' ')  #MOD-890235
    INSERT INTO default_tmp VALUES ('ima150', ' ')  #MOD-890235
    INSERT INTO default_tmp VALUES ('ima151', ' ')  #MOD-890235
    INSERT INTO default_tmp VALUES ('ima152', ' ')  #MOD-890235
 
    IF g_sma.sma115 = 'Y' THEN
       IF g_sma.sma122 MATCHES '[13]' THEN
          INSERT INTO default_tmp VALUES ('ima906', '2')  #3x
       ELSE
          INSERT INTO default_tmp VALUES ('ima906', '3')  #3x
       END IF
    ELSE
       INSERT INTO default_tmp VALUES ('ima906', '1')     #3x
    END IF
 
    INSERT INTO default_tmp VALUES ('bmauser', 'tiptop')
#    INSERT INTO default_tmp VALUES ('bmagrup', '')
    INSERT INTO default_tmp VALUES ('bmadate', TODAY)
    INSERT INTO default_tmp VALUES ('bmaacti', 'Y')
    INSERT INTO default_tmp VALUES ('bma06', ' ')  #3x
 
    INSERT INTO default_tmp VALUES ('bmb15', 'N')
    INSERT INTO default_tmp VALUES ('bmb23', '100')
    INSERT INTO default_tmp VALUES ('bmb18', '0')
    INSERT INTO default_tmp VALUES ('bmb17', 'N')
    INSERT INTO default_tmp VALUES ('bmb28', '0')
    INSERT INTO default_tmp VALUES ('bmb10_fac', '1')
    INSERT INTO default_tmp VALUES ('bmb10_fac2', '1')
    INSERT INTO default_tmp VALUES ('bmb16', '0')
    INSERT INTO default_tmp VALUES ('bmb14', '0')
    INSERT INTO default_tmp VALUES ('bmb04', TODAY)
    INSERT INTO default_tmp VALUES ('bmb06', '1')
    INSERT INTO default_tmp VALUES ('bmb07', '1')
    INSERT INTO default_tmp VALUES ('bmb08', '0')
    INSERT INTO default_tmp VALUES ('bmb19', '1')
    INSERT INTO default_tmp VALUES ('bmbmodu', 'tiptop')
    INSERT INTO default_tmp VALUES ('bmbdate', TODAY)
    INSERT INTO default_tmp VALUES ('bmbcomm', 'abmi600')
    INSERT INTO default_tmp VALUES ('bmb29', ' ') #3x
    IF g_sma.sma118 != 'Y' THEN
        INSERT INTO default_tmp VALUES ('bmb30', ' ') #3x
    ELSE
        INSERT INTO default_tmp VALUES ('bmb30', '1') #3x
    END IF
 
    INSERT INTO default_tmp VALUES ('bmb27', 'N') 
 
    INSERT INTO default_tmp VALUES ('bmx02', TODAY)
    INSERT INTO default_tmp VALUES ('bmx07', TODAY)
    INSERT INTO default_tmp VALUES ('bmx04', 'N')
    INSERT INTO default_tmp VALUES ('bmx06', '1')
    INSERT INTO default_tmp VALUES ('bmxuser', 'tiptop')
#   INSERT INTO default_tmp VALUES ('bmxgrup', '')
    INSERT INTO default_tmp VALUES ('bmxdate', TODAY)
    INSERT INTO default_tmp VALUES ('bmxacti', 'Y')
    INSERT INTO default_tmp VALUES ('bmx09', '0')
    INSERT INTO default_tmp VALUES ('bmx10', 'tiptop')   #3x
 
 
    INSERT INTO default_tmp VALUES ('bmy16', '0')
    INSERT INTO default_tmp VALUES ('bmy06', '0')
    INSERT INTO default_tmp VALUES ('bmy07', '1')
    INSERT INTO default_tmp VALUES ('bmy29', ' ')        #3x
    IF g_sma.sma118 != 'Y' THEN
        INSERT INTO default_tmp VALUES ('bmy30', ' ')        #3x
    ELSE
        INSERT INTO default_tmp VALUES ('bmy30', '1')        #3x
    END IF
 
    INSERT INTO default_tmp VALUES ('bmz05', ' ')        #3x
 
    INSERT INTO default_tmp VALUES ('bmouser', 'tiptop')
#   INSERT INTO default_tmp VALUES ('bmogrup', '')
    INSERT INTO default_tmp VALUES ('bmodate', TODAY)
    INSERT INTO default_tmp VALUES ('bmoacti', 'Y')
    INSERT INTO default_tmp VALUES ('bmo06', ' ')       #3x
 
    INSERT INTO default_tmp VALUES ('bmp15', 'N')
    INSERT INTO default_tmp VALUES ('bmp21', 'Y')
    INSERT INTO default_tmp VALUES ('bmp22', 'Y')
    INSERT INTO default_tmp VALUES ('bmp23', '100')
    INSERT INTO default_tmp VALUES ('bmp18', '0')
    INSERT INTO default_tmp VALUES ('bmp17', 'N')
    INSERT INTO default_tmp VALUES ('bmp10_fac', '1')
    INSERT INTO default_tmp VALUES ('bmp10_fac2', '1')
    INSERT INTO default_tmp VALUES ('bmp09', '')
    INSERT INTO default_tmp VALUES ('bmp16', '0')
    INSERT INTO default_tmp VALUES ('bmp14', '0')
    INSERT INTO default_tmp VALUES ('bmp04', TODAY)
    INSERT INTO default_tmp VALUES ('bmp06', '1')
    INSERT INTO default_tmp VALUES ('bmp07', '1')
    INSERT INTO default_tmp VALUES ('bmp08', '0')
    INSERT INTO default_tmp VALUES ('bmp19', '1')
    INSERT INTO default_tmp VALUES ('bmpmodu', 'tiptop')
    INSERT INTO default_tmp VALUES ('bmpdate', TODAY)
    INSERT INTO default_tmp VALUES ('bmpcomm', 'abmi100')
    INSERT INTO default_tmp VALUES ('bmp28', ' ')   #3x
    IF g_sma.sma118 != 'Y' THEN
        INSERT INTO default_tmp VALUES ('bmp29', ' ')   #3x
    ELSE
        INSERT INTO default_tmp VALUES ('bmp29', '1')   #3x
    END IF
 
    INSERT INTO default_tmp VALUES ('bmq15', 'N')
    INSERT INTO default_tmp VALUES ('bmq105', 'N')
    INSERT INTO default_tmp VALUES ('bmq903', 'N')
    INSERT INTO default_tmp VALUES ('bmq107', 'N')
    INSERT INTO default_tmp VALUES ('bmq147', 'N')
    INSERT INTO default_tmp VALUES ('bmq37', '2')
    INSERT INTO default_tmp VALUES ('bmq53', '0')
    INSERT INTO default_tmp VALUES ('bmq531','0')
    INSERT INTO default_tmp VALUES ('bmq91', '0')
    INSERT INTO default_tmp VALUES ('bmq103', '0')
    INSERT INTO default_tmp VALUES ('bmqacti','Y')
    INSERT INTO default_tmp VALUES ('bmquser', 'tiptop')
#    INSERT INTO default_tmp VALUES ('bmqgrup', '')
    INSERT INTO default_tmp VALUES ('bmqdate', TODAY)
    INSERT INTO default_tmp VALUES ('bmq910', ' ')
 
END FUNCTION
 
 
FUNCTION aws_pdmsrv_defaultValue(p_name, p_val)
    DEFINE p_name   LIKE type_file.chr10,
           p_val    STRING
    DEFINE l_val    LIKE type_file.chr20
 
    DEFINE l_cnt   LIKE type_file.num10
 
    SELECT COUNT(*) INTO l_cnt FROM default_tmp where name= p_name
    
    SELECT value INTO l_val FROM default_tmp WHERE name = p_name
    IF SQLCA.SQLCODE = 0 THEN
       IF cl_null(p_val) THEN
          LET p_val = l_val 
       END IF
    END IF
    RETURN p_val
END FUNCTION
 
 
FUNCTION aws_pdmsrv_updateRecordSet(p_recordset)
    DEFINE p_recordset   om.DomNode
    DEFINE l_parent      om.DomNode
    DEFINE l_table       STRING
    DEFINE l_sql         STRING,
           l_cols        STRING,
           l_vals        STRING
    DEFINE l_i           LIKE type_file.num10
    DEFINE l_ima06       LIKE ima_file.ima06
    DEFINE l_bmq06       LIKE bmq_file.bmq06
    DEFINE l_tag         LIKE type_file.num5
 
    LET l_parent = p_recordset.getParent()
    LET l_table = l_parent.getAttribute("name")
 
#    CASE l_table CLIPPED
#         WHEN "ima_file"
#              LET l_ima01 = p_recordset.getAttribute("ima01")
#              DELETE FROM ima_file WHERE ima01 = l_ima01
#         WHEN "bma_file"
#              LET l_bma01 = p_recordset.getAttribute("bma01")
#              DELETE FROM bma_file WHERE bma01 = l_bma01
#         WHEN "bmb_file"
#              LET l_bmb01 = p_recordset.getAttribute("bmb01")
#              DELETE FROM bmb_file WHERE bmb01 = l_bmb01
#    END CASE
    LET l_tag = 0
    CASE l_table CLIPPED
          WHEN "ima_file" 
               LET l_ima06 = p_recordset.getAttribute("ima06")
               LET l_tag = aws_pdmsrv_ima06_default(l_ima06)
               INITIALIZE g_ima.* TO NULL
          WHEN "bmq_file" 
               LET l_bmq06 = p_recordset.getAttribute("bmq06")
               LET l_tag = aws_pdmsrv_bmq06_default(l_bmq06)
    END CASE
    #--------------------------------------------------------------------------
    # 依據 PDM 傳遞欄位, 組合 Insert 動作的 SQL syntax
    #--------------------------------------------------------------------------
    FOR l_i = 1 TO p_recordset.getAttributesCount()
        IF l_i = 1 THEN
           LET l_cols = "("
           LET l_vals = "("
        END IF
        IF l_i != 1 THEN
           LET l_cols = l_cols, ", "
           LET l_vals = l_vals, ", "
        END IF
        LET l_cols = l_cols, p_recordset.getAttributeName(l_i)
        CASE l_table 
          WHEN "ima_file"  
            LET l_vals = l_vals, "'", aws_pdmsrv_ima_defaultValue(p_recordset.getAttributeName(l_i), p_recordset.getAttributeValue(l_i),l_tag), "'"
          WHEN "bmq_file"
            LET l_vals = l_vals, "'", aws_pdmsrv_bmq_defaultValue(p_recordset.getAttributeName(l_i), p_recordset.getAttributeValue(l_i),l_tag), "'"
          OTHERWISE
            LET l_vals = l_vals, "'", p_recordset.getAttributeValue(l_i), "'"
        END CASE 
        IF l_i = p_recordset.getAttributesCount() THEN
           LET l_cols = l_cols, ")"
           LET l_vals = l_vals, ")"
        END IF
    END FOR
    LET l_sql = "INSERT INTO ", l_table CLIPPED, " ", l_cols, " VALUES ", l_vals
    EXECUTE IMMEDIATE l_sql
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       #------------------------------------------------------------------------
       # 紀錄若 INSERT 失敗時的 SQLCA.SQLCODE, SQLERRMESSAGE & SQLCA.SQLERRD[2/3] 狀態值
       #------------------------------------------------------------------------
       CALL l_parent.setAttribute("sqlcode", SQLCA.SQLCODE)
       CALL l_parent.setAttribute("sqlerrmessage", SQLERRMESSAGE)
       CALL l_parent.setAttribute("sqlerrd2", SQLCA.SQLERRD[2])
       CALL l_parent.setAttribute("sqlerrd3", SQLCA.SQLERRD[3])
       RETURN FALSE
    ELSE
       RETURN TRUE
    END IF
END FUNCTION
 
 
#------------------------------------------------------------------------------
# 根據 PDM 指定之 '料件/BOM/ECN' table 欄位資料進行 ERP 更新動作
#------------------------------------------------------------------------------
FUNCTION aws_pdmsrv_SetRecordSet()
    DEFINE l_list    om.NodeList,
           l_list1   om.NodeList
    DEFINE l_i       LIKE type_file.num10,
           l_j       LIKE type_file.num10
    DEFINE l_node    om.DomNode,
           l_rnode   om.DomNode
    DEFINE l_child   om.DomNode
    DEFINE l_slip    LIKE smy_file.smyslip,
           l_bmx01   LIKE bmx_file.bmx01,
           l_bmx02   LIKE bmx_file.bmx02
    DEFINE l_status  LIKE type_file.num10
    DEFINE l_ima01   LIKE ima_file.ima01
    DEFINE l_bmq01   LIKE bmq_file.bmq01
    DEFINE l_bma01   LIKE bma_file.bma01,
           l_bma05   LIKE bma_file.bma05,
           l_bma06   LIKE bma_file.bma06
    DEFINE l_bmb01   LIKE bmb_file.bmb01,
           l_bmb29   LIKE bmb_file.bmb29
    DEFINE l_bmo01   LIKE bmo_file.bmo01,
           l_bmo011  LIKE bmo_file.bmo011,
           l_bmo06   LIKE bmo_file.bmo06
    DEFINE l_bmp01   LIKE bmp_file.bmp01,
           l_bmp28   LIKE bmp_file.bmp28,
           l_bmp011  LIKE bmp_file.bmp011
    DEFINE l_cnt     LIKE type_file.num5                   
 
    LET l_node = g_dnode.createChild("Data")
    CASE g_action CLIPPED
         #---------------------------------------------------------------------
         # PDM 匯入料件資料至 ERP
         #---------------------------------------------------------------------
         WHEN "MItem"
              LET l_node = l_node.createChild("Record")
              LET l_node = l_node.createChild("Table")
              CALL l_node.setAttribute("name", "ima_file")
              #----------------------------------------------------------------
              # 依據 PDM 傳入的每筆料件資料進行 Insert 至資料庫動作
              #----------------------------------------------------------------
              LET l_list = g_request.selectByTagName("Row")
              FOR l_i = 1 TO l_list.getLength()
                  LET l_child = l_list.item(l_i)
                  BEGIN WORK
                  LET l_ima01 = l_child.getAttribute("ima01")
                 #DELETE FROM ima_file WHERE ima01 = l_ima01
                  SELECT COUNT(*) INTO l_cnt FROM ima_file where ima01=l_ima01
                  IF l_cnt = 0 THEN
                     #------------------------------------------------------------
                     # Insert 動作若失敗(任一筆), 則使狀態碼變數為錯誤代碼
                     #------------------------------------------------------------
                     IF aws_pdmsrv_updateRecordSet(l_child) THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                        CALL l_node.appendChild(l_child)
                        LET g_status = "item-failed"
                     END IF
                  END IF
              END FOR 
              #----------------------------------------------------------------
              # 如找不到任何 <Row> 資料, 則視為不合法的 XML 文件
              #----------------------------------------------------------------
              IF l_list.getLength() = 0 THEN
                 LET g_status = "invalid"
              END IF
         WHEN "EItem"
              LET l_node = l_node.createChild("Record")
              LET l_node = l_node.createChild("Table")
              CALL l_node.setAttribute("name", "bmq_file")
              #----------------------------------------------------------------
              # 依據 PDM 傳入的每筆料件資料進行 Insert 至資料庫動作
              #----------------------------------------------------------------
              LET l_list = g_request.selectByTagName("Row")
              FOR l_i = 1 TO l_list.getLength()
                  LET l_child = l_list.item(l_i)
                  BEGIN WORK
                  LET l_bmq01 = l_child.getAttribute("bmq01")
                 #DELETE FROM bmq_file WHERE bmq01 = l_bmq01
                  SELECT COUNT(*) INTO l_cnt FROM bmq_file where bmq01=l_bmq01
                  IF l_cnt = 0 THEN
                     #------------------------------------------------------------
                     # Insert 動作若失敗(任一筆), 則使狀態碼變數為錯誤代碼
                     #------------------------------------------------------------
                     IF aws_pdmsrv_updateRecordSet(l_child) THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                        CALL l_node.appendChild(l_child)
                        LET g_status = "item-failed"
                     END IF
                  END IF
              END FOR 
              #----------------------------------------------------------------
              # 如找不到任何 <Row> 資料, 則視為不合法的 XML 文件
              #----------------------------------------------------------------
              IF l_list.getLength() = 0 THEN
                 LET g_status = "invalid"
              END IF
         #---------------------------------------------------------------------
         # PDM 匯入 BOM 資料至 ERP
         #---------------------------------------------------------------------
         WHEN "MBOM"
              #----------------------------------------------------------------
              # 依據 PDM 傳入的每筆 BOM 資料(包含單頭 bma_file, 單身 bmb_file) 進行 Insert 至資料庫動作
              #----------------------------------------------------------------
              LET l_list = g_request.selectByTagName("Record")
              FOR l_i = 1 TO l_list.getLength()
                  #------------------------------------------------------------
                  # 單頭檔(bma_file) Insert 動作
                  #------------------------------------------------------------
                  LET l_rnode = l_list.item(l_i)
                  BEGIN WORK
                  LET l_list1 = l_rnode.selectByPath("//Table[@name=\"bma_file\"]/Row")
                  LET l_child = l_list1.item(1)
                  LET l_bma01 = l_child.getAttribute("bma01")
                  LET l_bma05 = l_child.getAttribute("bma05")
                  LET l_bma06 = l_child.getAttribute("bma06")
                  IF cl_null(l_bma06) THEN
                     LET l_bma06 =" "
                  END IF
                  #DELETE FROM bma_file WHERE bma01 = l_bma01
                  SELECT COUNT(*) INTO l_cnt FROM bma_file 
                    WHERE bma01 = l_bma01 AND bma06 = l_bma06
                  IF l_cnt = 0 THEN
                     LET l_status = aws_pdmsrv_updateRecordSet(l_child)
                     IF l_status THEN
                        #---------------------------------------------------------
                        # 單身檔(bmb_file) Insert 動作
                        #---------------------------------------------------------
                        LET l_list1 = l_rnode.selectByPath("//Table[@name=\"bmb_file\"]/Row")
                        FOR l_j = 1 TO l_list1.getLength()
                            LET l_child = l_list1.item(l_j)
                            IF l_j = 1 THEN
                               LET l_bmb01 = l_child.getAttribute("bmb01")
                               LET l_bmb29 = l_child.getAttribute("bmb29")
                               IF cl_null(l_bmb29) THEN
                                  LET l_bmb29 =" "
                               END IF
                               DELETE FROM bmb_file 
                                 WHERE bmb01 = l_bmb01 AND bmb29 = l_bmb29
                            END IF
                            IF NOT aws_pdmsrv_updateRecordSet(l_list1.item(l_j)) THEN
                               LET l_status = FALSE
                               EXIT FOR
                            END IF
                        END FOR
                     END IF
                     #------------------------------------------------------------
                     # Insert 動作若失敗(任一筆), 則使狀態碼變數為錯誤代碼
                     #------------------------------------------------------------
 
                     IF l_status THEN
                        IF NOT bom_release(l_bma01,l_bma05,l_bma06) THEN
                           CALL l_rnode.setAttribute("bom_release","false")
                           LET l_status = FALSE
                        END IF
                     END IF
                     IF l_status THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                        CALL l_node.appendChild(l_rnode)
                        LET g_status = "mbom-failed"
                     END IF
                  END IF
              END FOR
              #----------------------------------------------------------------
              # 如找不到任何 <Record> 資料, 則視為不合法的 XML 文件
              #----------------------------------------------------------------
              IF l_list.getLength() = 0 THEN
                 LET g_status = "invalid"
              END IF
         WHEN "EBOM"
              #----------------------------------------------------------------
              # 依據 PDM 傳入的每筆 BOM 資料(包含單頭 bmo_file, 單身 bmp_file) 進行 Insert 至資料庫動作
              #----------------------------------------------------------------
              LET l_list = g_request.selectByTagName("Record")
              FOR l_i = 1 TO l_list.getLength()
                  #------------------------------------------------------------
                  # 單頭檔(bmo_file) Insert 動作
                  #------------------------------------------------------------
                  LET l_rnode = l_list.item(l_i)
                  BEGIN WORK
                  LET l_list1 = l_rnode.selectByPath("//Table[@name=\"bmo_file\"]/Row")
                  LET l_child = l_list1.item(1)
                  LET l_bmo01 = l_child.getAttribute("bmo01")
                  LET l_bmo011 = l_child.getAttribute("bmo011")
                  LET l_bmo06 = l_child.getAttribute("bmo06")
                  IF cl_null(l_bmo06) THEN
                      LET l_bmo06 = " "
                  END IF
                  #DELETE FROM bmo_file WHERE bmo01 = l_bmo01 AND bmo011 = l_bmo011
                  SELECT COUNT(*) INTO l_cnt FROM bmo_file 
                     WHERE bmo01 = l_bmo01 AND bmo011 = l_bmo011
                       AND bmo06 = l_bmo06
                  IF l_cnt = 0 THEN
                     LET l_status = aws_pdmsrv_updateRecordSet(l_child)
                     IF l_status THEN
                        #---------------------------------------------------------
                        # 單身檔(bmp_file) Insert 動作
                        #---------------------------------------------------------
                        LET l_list1 = l_rnode.selectByPath("//Table[@name=\"bmp_file\"]/Row")
                        FOR l_j = 1 TO l_list1.getLength()
                            LET l_child = l_list1.item(l_j)
                            IF l_j = 1 THEN
                               LET l_bmp01 = l_child.getAttribute("bmp01")
                               LET l_bmp011 = l_child.getAttribute("bmp011")
                               LET l_bmp28 = l_child.getAttribute("bmp28")
                               IF cl_null(l_bmp28) THEN
                                  LET l_bmp28 = " "
                               END IF
                               DELETE FROM bmp_file WHERE bmp01=l_bmp01 
                                  AND bmp011=l_bmp011 AND bmo06=l_bmp28
                            END IF
                            IF NOT aws_pdmsrv_updateRecordSet(l_list1.item(l_j)) THEN
                               LET l_status = FALSE
                               EXIT FOR
                            END IF
                        END FOR
                     END IF
                     #------------------------------------------------------------
                     # Insert 動作若失敗(任一筆), 則使狀態碼變數為錯誤代碼
                     #------------------------------------------------------------
                     IF l_status THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                       #CALL l_rnode.setAttribute("release", "false")
                        CALL l_node.appendChild(l_rnode)
                        LET g_status = "ebom-failed"
                     END IF
                  END IF
              END FOR
              #----------------------------------------------------------------
              # 如找不到任何 <Record> 資料, 則視為不合法的 XML 文件
              #----------------------------------------------------------------
              IF l_list.getLength() = 0 THEN
                 LET g_status = "invalid"
              END IF
         #---------------------------------------------------------------------
         # PDM 匯入 ECN 資料至 ERP
         #---------------------------------------------------------------------
         WHEN "ECN"
              #----------------------------------------------------------------
              # 檢查單別是否存在
              #----------------------------------------------------------------
              LET l_slip = aws_pdmsrv_getTagAttribute("Slip", "name")
              LET l_bmx01 = l_slip
             #CALL s_mfgslip(l_slip CLIPPED, 'abm', '1')
            ##FUN-A10109 modify begin
              #SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
              #CASE g_aza.aza41
              #   WHEN "1"   LET g_doc_len = 3
              #              LET g_no_sp = 3 + 2
              #   WHEN "2"   LET g_doc_len = 4
              #              LET g_no_sp = 4 + 2
              #   WHEN "3"   LET g_doc_len = 5
              #              LET g_no_sp = 5 + 2
              #END CASE
              #CASE g_aza.aza42
              #   WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
              #   WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
              #   WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
              #END CASE
              CALL s_doc_global_setting('ABM',g_plant)
             ##FUN-A10109 modify end 
 
              CALL s_check_no("abm",l_bmx01,"","1","bmx_file","bmx01","")
                 RETURNING l_status,l_bmx01
              IF (NOT l_status) THEN
                 LET g_status = "ecn-failed"
                 RETURN
              END IF
 
              #----------------------------------------------------------------
              # 依據 PDM 傳入的 ECN 資料(包含單頭 bmx_file, 單身 bmy_file, 多主件 bmz_file) 進行 Insert 至資料庫動作
              #----------------------------------------------------------------
              LET l_list = g_request.selectByTagName("Record")
 
              #FUN-760068
              #----------------------------------------------------------------
              # 判斷新增的 [主件/元件] 是否有尚未確認的變更單
              #----------------------------------------------------------------
              IF NOT aws_pdmsrv_ecn_check(l_list) THEN
                 LET g_status = "abm-210"      #主件/元件有尚未確認的變更單
                 RETURN
              END IF
              #END FUN-760068
 
              BEGIN WORK
              #----------------------------------------------------------------
              # 單頭檔(bmx_file) Insert 動作
              #----------------------------------------------------------------
              LET l_rnode = l_list.item(1)
              LET l_list1 = l_rnode.selectByPath("//Table[@name=\"bmx_file\"]/Row")
              LET l_child = l_list1.item(1)
              LET l_bmx01 = l_slip
              LET l_bmx02 = l_child.getAttribute("bmx02")
              #----------------------------------------------------------------
              # 依單別自動取號
              #----------------------------------------------------------------
              #CALL s_smyauno(l_bmx01, l_bmx02) RETURNING l_status, l_bmx01
              CALL s_auto_assign_no("abm",l_bmx01,l_bmx02,"1","bmx_file","bmx01","","","") RETURNING l_status,l_bmx01
 
              IF l_status THEN
                 CALL l_child.setAttribute("bmx01", l_bmx01 CLIPPED)
                 LET l_status = aws_pdmsrv_updateRecordSet(l_child)
              ELSE 
                 LET l_status = FALSE
              END IF
              IF l_status THEN
                  #------------------------------------------------------------
                  # 單身檔(bmy_file) Insert 動作
                  #------------------------------------------------------------
                  LET l_list1 = l_rnode.selectByPath("//Table[@name=\"bmy_file\"]/Row")
                  FOR l_j = 1 TO l_list1.getLength()
                      LET l_child = l_list1.item(l_j)
                      CALL l_child.setAttribute("bmy01", l_bmx01 CLIPPED)
                      IF NOT aws_pdmsrv_updateRecordSet(l_child) THEN
                         LET l_status = FALSE
                         EXIT FOR
                      END IF
                  END FOR
                  IF l_status THEN
                      #------------------------------------------------------------
                      # 多主件單身檔(bmz_file) Insert 動作
                      #------------------------------------------------------------
                      LET l_list1 = l_rnode.selectByPath("//Table[@name=\"bmz_file\"]/Row")
                      FOR l_j = 1 TO l_list1.getLength()
                          LET l_child = l_list1.item(l_j)
                          CALL l_child.setAttribute("bmz01", l_bmx01 CLIPPED)
                          IF NOT aws_pdmsrv_updateRecordSet(l_child) THEN
                             LET l_status = FALSE
                             EXIT FOR
                          END IF
                      END FOR
                  END IF
              END IF
              #------------------------------------------------------------
              # Insert 成功, 回覆 ECN 單號
              # Insert 失敗(任一筆), 則使狀態碼變數為錯誤代碼
              #------------------------------------------------------------
              IF l_status THEN
                 LET g_slip = l_bmx01
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
                 LET g_status = "ecn-failed"
              END IF
              #----------------------------------------------------------------
              # 如找不到任何 <Record> 資料, 則視為不合法的 XML 文件
              #----------------------------------------------------------------
              IF l_list.getLength() = 0 THEN
                 LET g_status = "invalid"
              END IF
         OTHERWISE
              LET g_status = "unknown"
    END CASE
END FUNCTION
 
FUNCTION aws_pdmsrv_GetSchemaList() 
    DEFINE l_node        om.DomNode,
           l_rnode       om.DomNode,
           l_node1       om.DomNode
    DEFINE l_child       om.DomNode
    DEFINE l_colname     LIKE type_file.chr20 
    DEFINE l_gaq03       LIKE gaq_file.gaq03
    DEFINE l_i           LIKE type_file.num10
    DEFINE l_sql         STRING
    DEFINE l_colname_str STRING
    DEFINe l_default     STRING
 
    LET l_node = g_dnode.createChild("Data")
 
    CALL aws_pdmsrv_tabfile()
 
    FOR l_i = 1 TO g_tabfile.getLength()
        LET l_node1 = l_node.createChild("Table")
        
        CALL l_node1.setAttribute("name", g_tabfile[l_i])

        #---FUN-A90024---start-----
        #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
        #目前統一用sch_file紀錄TIPTOP資料結構 
        #CASE cl_db_get_database_type()
        #    WHEN "ORA" 
        #         LET l_sql= "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = UPPER('",g_tabfile[l_i],"') AND OWNER = UPPER('",g_database ,"') ORDER BY COLUMN_ID"
        #    WHEN "IFX" 
        #         LET l_sql = "SELECT colname FROM ",g_database,":syscolumns col, systables tab WHERE tab.tabname = '",g_tabfile[l_i] ,"' AND tab.tabid = col.tabid ORDER BY colno"
        #END CASE
        LET l_sql= "SELECT sch02 FROM sch_file WHERE sch01 = '",g_tabfile[l_i],"' ORDER BY sch05"    
        #---FUN-A90024---end-------
       
        DECLARE pdmsrv_cur CURSOR FROM l_sql
        FOREACH pdmsrv_cur INTO l_colname
            LET l_colname_str = l_colname
            LET l_colname_str = l_colname_str.toLowerCase()
            LET l_colname = l_colname_str
            LET l_child = l_node1.createChild("Item")
            SELECT gaq03 INTO l_gaq03 FROM gaq_file
                        WHERE gaq01=l_colname AND gaq02='0'
            LET l_default = aws_pdmsrv_defaultValue(l_colname CLIPPED,"")
            CALL l_child.setAttribute("fieldid", l_colname CLIPPED)
            CALL l_child.setAttribute("name", l_gaq03 CLIPPED)
            CALL l_child.setAttribute("default", l_default)
            CALL l_node1.appendChild(l_child)
        END FOREACH
    END FOR
 
END FUNCTION
 
FUNCTION aws_pdmsrv_tabfile()
 
  LET g_tabfile[1] = "ima_file"
  LET g_tabfile[2] = "bma_file"
  LET g_tabfile[3] = "bmb_file"
  LET g_tabfile[4] = "bmx_file"
  LET g_tabfile[5] = "bmy_file"
  LET g_tabfile[6] = "bmz_file"
  LET g_tabfile[7] = "bmq_file"
  LET g_tabfile[8] = "bmo_file"
  LET g_tabfile[9] = "bmp_file"
 
END FUNCTION
 
FUNCTION aws_pdmsrv_ima06_default(p_ima06)
DEFINE p_ima06     LIKE ima_file.ima06
DEFINE l_ima       RECORD LIKE ima_file.*
DEFINE l_imzacti   LIKE imz_file.imzacti
DEFINE l_imz02     LIKE imz_file.imz02,
       l_imaacti   LIKE ima_file.imaacti,
       l_imauser   LIKE ima_file.imauser,
       l_imagrup   LIKE ima_file.imagrup,
       l_imamodu   LIKE ima_file.imamodu,
       l_imadate   LIKE ima_file.imadate
 
 
  SELECT imzacti INTO l_imzacti FROM imz_file WHERE imz01 = p_ima06
  IF NOT l_imzacti MATCHES "[Yy]" OR l_imzacti IS NULL THEN
      RETURN 0
  END IF
 
  SELECT * INTO l_ima.ima06,l_imz02,l_ima.ima03,l_ima.ima04,
            l_ima.ima07,l_ima.ima08,l_ima.ima09,l_ima.ima10,
            l_ima.ima11,l_ima.ima12,l_ima.ima14,l_ima.ima15,
            l_ima.ima17,l_ima.ima19,l_ima.ima21,
            l_ima.ima23,l_ima.ima24,l_ima.ima25,l_ima.ima27,
            l_ima.ima28,l_ima.ima31,l_ima.ima31_fac,l_ima.ima34,
            l_ima.ima35,l_ima.ima36,l_ima.ima37,l_ima.ima38,
            l_ima.ima39,l_ima.ima42,l_ima.ima43,l_ima.ima44,
            l_ima.ima44_fac,l_ima.ima45,l_ima.ima46,l_ima.ima47,
            l_ima.ima48,l_ima.ima49,l_ima.ima491,l_ima.ima50,
            l_ima.ima51,l_ima.ima52,l_ima.ima54,l_ima.ima55,
            l_ima.ima55_fac,l_ima.ima56,l_ima.ima561,l_ima.ima562,
            l_ima.ima571,
            l_ima.ima59, l_ima.ima60,l_ima.ima61,l_ima.ima62,
            l_ima.ima63, l_ima.ima63_fac,l_ima.ima64,l_ima.ima641,
            l_ima.ima65, l_ima.ima66,l_ima.ima67,l_ima.ima68,
            l_ima.ima69, l_ima.ima70,l_ima.ima71,l_ima.ima86,
            l_ima.ima86_fac, l_ima.ima87,l_ima.ima871,l_ima.ima872,
            l_ima.ima873, l_ima.ima874,l_ima.ima88,l_ima.ima89,
            l_ima.ima90,l_ima.ima94,l_ima.ima99,l_ima.ima100,
            l_ima.ima101,l_ima.ima102,l_ima.ima103,l_ima.ima105,
            l_ima.ima106,l_ima.ima107,l_ima.ima108,l_ima.ima109,
            l_ima.ima110,l_ima.ima130,l_ima.ima131,l_ima.ima132, 
            l_ima.ima133,l_ima.ima134,                            
            l_ima.ima147,l_ima.ima148,l_ima.ima903,
            l_imaacti,l_imauser,l_imagrup,l_imamodu,l_imadate,
            l_ima.ima906,l_ima.ima907,l_ima.ima908,l_ima.ima909, 
            l_ima.ima911,  
            l_ima.ima136,l_ima.ima137,l_ima.ima391,l_ima.ima1321    
         FROM  imz_file
         WHERE imz01 = p_ima06
  IF l_ima.ima99  IS NULL THEN LET l_ima.ima99 = 0            END IF
  IF l_ima.ima133 IS NULL THEN LET l_ima.ima133 = l_ima.ima01 END IF
  IF l_ima.ima01[1,4]='MISC' THEN
     LET l_ima.ima08='Z'
  END IF
 
  DROP TABLE default_tmp
#FUN-9B0068 --BEGIN--  
#  CREATE TEMP TABLE default_tmp
#  (
#    name  VARCHAR(10),
#    value VARCHAR(20)
#  );

  CREATE TEMP TABLE default_tmp(
    name  LIKE type_file.chr14,
    value LIKE type_file.chr20);
#FUN-9B0068 --end-- 
  CREATE UNIQUE INDEX default_tmp01 ON defaul_tmp (name)
  
  INSERT INTO default_tmp VALUES ('ima06',  l_ima.ima06)
  INSERT INTO default_tmp VALUES ('ima03',  l_ima.ima03)
  INSERT INTO default_tmp VALUES ('ima04',  l_ima.ima04)
  INSERT INTO default_tmp VALUES ('ima07',  l_ima.ima07)
  INSERT INTO default_tmp VALUES ('ima08',  l_ima.ima08)
  INSERT INTO default_tmp VALUES ('ima09',  l_ima.ima09)
  INSERT INTO default_tmp VALUES ('ima10',  l_ima.ima10)
  INSERT INTO default_tmp VALUES ('ima11',  l_ima.ima11)
  INSERT INTO default_tmp VALUES ('ima12',  l_ima.ima12)
  INSERT INTO default_tmp VALUES ('ima14',  l_ima.ima14)
  INSERT INTO default_tmp VALUES ('ima15',  l_ima.ima15)
  INSERT INTO default_tmp VALUES ('ima17',  l_ima.ima17)
  INSERT INTO default_tmp VALUES ('ima19',  l_ima.ima19)
  INSERT INTO default_tmp VALUES ('ima21',  l_ima.ima21)
  INSERT INTO default_tmp VALUES ('ima23',  l_ima.ima23)
  INSERT INTO default_tmp VALUES ('ima24',  l_ima.ima24)
  INSERT INTO default_tmp VALUES ('ima25',  l_ima.ima25)
  INSERT INTO default_tmp VALUES ('ima27',  l_ima.ima27)
  INSERT INTO default_tmp VALUES ('ima28',  l_ima.ima28)
  INSERT INTO default_tmp VALUES ('ima31',  l_ima.ima31)
  INSERT INTO default_tmp VALUES ('ima31_fac', l_ima.ima31_fac)
  INSERT INTO default_tmp VALUES ('ima34',  l_ima.ima34)
  INSERT INTO default_tmp VALUES ('ima35',  l_ima.ima35)
  INSERT INTO default_tmp VALUES ('ima36',  l_ima.ima36)
  INSERT INTO default_tmp VALUES ('ima37',  l_ima.ima37)
  INSERT INTO default_tmp VALUES ('ima38',  l_ima.ima38)
  INSERT INTO default_tmp VALUES ('ima39',  l_ima.ima39)
  INSERT INTO default_tmp VALUES ('ima42',  l_ima.ima42)
  INSERT INTO default_tmp VALUES ('ima43',  l_ima.ima43)
  INSERT INTO default_tmp VALUES ('ima44',  l_ima.ima44)
  INSERT INTO default_tmp VALUES ('ima44_fac',  l_ima.ima44_fac)
  INSERT INTO default_tmp VALUES ('ima45',  l_ima.ima45)
  INSERT INTO default_tmp VALUES ('ima46',  l_ima.ima46)
  INSERT INTO default_tmp VALUES ('ima47',  l_ima.ima47)
  INSERT INTO default_tmp VALUES ('ima48',  l_ima.ima48)
  INSERT INTO default_tmp VALUES ('ima49',  l_ima.ima49)
  INSERT INTO default_tmp VALUES ('ima491', l_ima.ima491)
  INSERT INTO default_tmp VALUES ('ima50',  l_ima.ima50)
  INSERT INTO default_tmp VALUES ('ima51',  l_ima.ima51)
  INSERT INTO default_tmp VALUES ('ima52',  l_ima.ima52)
  INSERT INTO default_tmp VALUES ('ima54',  l_ima.ima54)
  INSERT INTO default_tmp VALUES ('ima55',  l_ima.ima55)
  INSERT INTO default_tmp VALUES ('ima55_fac', l_ima.ima55_fac)
  INSERT INTO default_tmp VALUES ('ima56',  l_ima.ima56)
  INSERT INTO default_tmp VALUES ('ima561', l_ima.ima561)
  INSERT INTO default_tmp VALUES ('ima562', l_ima.ima562)
  INSERT INTO default_tmp VALUES ('ima571', l_ima.ima571)
  INSERT INTO default_tmp VALUES ('ima59',  l_ima.ima59)
  INSERT INTO default_tmp VALUES ('ima60',  l_ima.ima60)
  INSERT INTO default_tmp VALUES ('ima61',  l_ima.ima61)
  INSERT INTO default_tmp VALUES ('ima62',  l_ima.ima62)
  INSERT INTO default_tmp VALUES ('ima63',  l_ima.ima63)
  INSERT INTO default_tmp VALUES ('ima63_fac', l_ima63_fac)
  INSERT INTO default_tmp VALUES ('ima64',  l_ima.ima64)
  INSERT INTO default_tmp VALUES ('ima641', l_ima.ima64)
  INSERT INTO default_tmp VALUES ('ima65',  l_ima.ima65)
  INSERT INTO default_tmp VALUES ('ima66',  l_ima.ima66)
  INSERT INTO default_tmp VALUES ('ima67',  l_ima.ima67)
  INSERT INTO default_tmp VALUES ('ima68',  l_ima.ima68)
  INSERT INTO default_tmp VALUES ('ima69',  l_ima.ima69)
  INSERT INTO default_tmp VALUES ('ima70',  l_ima.ima70)
  INSERT INTO default_tmp VALUES ('ima71',  l_ima.ima71)
  INSERT INTO default_tmp VALUES ('ima86',  l_ima.ima86)
  INSERT INTO default_tmp VALUES ('ima86_fac', l_ima.ima86_fac)
  INSERT INTO default_tmp VALUES ('ima87',  l_ima.ima87)
  INSERT INTO default_tmp VALUES ('ima871', l_ima.ima871)
  INSERT INTO default_tmp VALUES ('ima872', l_ima.ima872)
  INSERT INTO default_tmp VALUES ('ima873', l_ima.ima873)
  INSERT INTO default_tmp VALUES ('ima874', l_ima.ima874)
  INSERT INTO default_tmp VALUES ('ima88',  l_ima.ima88)
  INSERT INTO default_tmp VALUES ('ima89',  l_ima.ima89)
  INSERT INTO default_tmp VALUES ('ima90',  l_ima.ima90)
  INSERT INTO default_tmp VALUES ('ima94',  l_ima.ima94)
  INSERT INTO default_tmp VALUES ('ima99',  l_ima.ima99)
  INSERT INTO default_tmp VALUES ('ima100', l_ima.ima100)
  INSERT INTO default_tmp VALUES ('ima101', l_ima.ima101)
  INSERT INTO default_tmp VALUES ('ima102', l_ima.ima102)
  INSERT INTO default_tmp VALUES ('ima103', l_ima.ima103)
  INSERT INTO default_tmp VALUES ('ima105', l_ima.ima105)
  INSERT INTO default_tmp VALUES ('ima106', l_ima.ima106)
  INSERT INTO default_tmp VALUES ('ima107', l_ima.ima107)
  INSERT INTO default_tmp VALUES ('ima108', l_ima.ima108)
  INSERT INTO default_tmp VALUES ('ima109', l_ima.ima109)
  INSERT INTO default_tmp VALUES ('ima110', l_ima.ima110)
  INSERT INTO default_tmp VALUES ('ima130', l_ima.ima130)
  INSERT INTO default_tmp VALUES ('ima131', l_ima.ima131)
  INSERT INTO default_tmp VALUES ('ima132', l_ima.ima132)
  INSERT INTO default_tmp VALUES ('ima133', l_ima.ima133)
  INSERT INTO default_tmp VALUES ('ima134', l_ima.ima134)
  INSERT INTO default_tmp VALUES ('ima147', l_ima.ima147)
  INSERT INTO default_tmp VALUES ('ima148', l_ima.ima148)
  INSERT INTO default_tmp VALUES ('ima903', l_ima.ima903)
  INSERT INTO default_tmp VALUES ('ima906', l_ima.ima906)
  INSERT INTO default_tmp VALUES ('ima907', l_ima.ima907)
  INSERT INTO default_tmp VALUES ('ima908', l_ima.ima908)
  INSERT INTO default_tmp VALUES ('ima909', l_ima.ima909)
  INSERT INTO default_tmp VALUES ('ima911', l_ima.ima911)
  INSERT INTO default_tmp VALUES ('ima136', l_ima.ima136)
  INSERT INTO default_tmp VALUES ('ima137', l_ima.ima137)
  INSERT INTO default_tmp VALUES ('ima391', l_ima.ima391)
  INSERT INTO default_tmp VALUES ('ima1321',l_ima.ima1321)
 
  RETURN 1 
END FUNCTION
 
FUNCTION aws_pdmsrv_bmq06_default(p_bmq06)
DEFINE p_bmq06     LIKE bmq_file.bmq06
DEFINE l_bmq       RECORD LIKE bmq_file.*,
       l_imz02     LIKE imz_file.imz02,
       l_imzacti   LIKE imz_file.imzacti,
       l_bmqacti   LIKE bmq_file.bmqacti,
       l_bmquser   LIKE bmq_file.bmquser,
       l_bmqgrup   LIKE bmq_file.bmqgrup,
       l_bmqmodu   LIKE bmq_file.bmqmodu,
       l_bmqdate   LIKE bmq_file.bmqdate
 
  SELECT imzacti INTO l_imzacti FROM imz_file WHERE imz01 = p_bmq06
  IF NOT l_imzacti MATCHES "[Yy]" OR l_imzacti IS NULL THEN
      RETURN 0
  END IF
 
  SELECT imz01,imz08,imz09,imz10,imz11,imz12,imz15,imz25,
         imz31,imz31_fac,imz37,imz44,imz44_fac,imz55,imz55_fac,
         imz63,imz63_fac,imz103,imz105,imz107,imz147,imz903,
         imzacti,imzuser,imzgrup,imzmodu,imzdate
  INTO   l_bmq.bmq06,l_bmq.bmq08,l_bmq.bmq09,l_bmq.bmq10,
              l_bmq.bmq11,l_bmq.bmq12,l_bmq.bmq15,l_bmq.bmq25,
              l_bmq.bmq31,l_bmq.bmq31_fac,l_bmq.bmq37,l_bmq.bmq44,
              l_bmq.bmq44_fac,l_bmq.bmq55,l_bmq.bmq55_fac,
              l_bmq.bmq63, l_bmq.bmq63_fac,l_bmq.bmq103,l_bmq.bmq105,
              l_bmq.bmq107,l_bmq.bmq147,l_bmq.bmq903,
              l_bmqacti,l_bmquser,l_bmqgrup,l_bmqmodu,l_bmqdate
         FROM  imz_file
         WHERE imz01 = p_bmq06
 
  DROP TABLE default_tmp
#FUN-9B0068 --BEGIN--  
#  CREATE TEMP TABLE default_tmp
#  (
#    name  VARCHAR(10),
#    value VARCHAR(20)
#  );

  CREATE TEMP TABLE default_tmp(
    name  LIKE type_file.chr14,
    value LIKE type_file.chr20);
#FUN-9B0068 --end-- 
 
  CREATE UNIQUE INDEX default_tmp01 ON defaul_tmp (name)
  
  INSERT INTO default_tmp VALUES ('bmq06',  l_bmq.bmq06)
  INSERT INTO default_tmp VALUES ('bmq08',  l_bmq.bmq08)
  INSERT INTO default_tmp VALUES ('bmq09',  l_bmq.bmq09)
  INSERT INTO default_tmp VALUES ('bmq10',  l_bmq.bmq10)
  INSERT INTO default_tmp VALUES ('bmq11',  l_bmq.bmq11)
  INSERT INTO default_tmp VALUES ('bmq12',  l_bmq.bmq12)
  INSERT INTO default_tmp VALUES ('bmq15',  l_bmq.bmq15)
  INSERT INTO default_tmp VALUES ('bmq25',  l_bmq.bmq25)
  INSERT INTO default_tmp VALUES ('bmq31',  l_bmq.bmq31)
  INSERT INTO default_tmp VALUES ('bmq31_fac', l_bmq.bmq31_fac)
  INSERT INTO default_tmp VALUES ('bmq37',  l_bmq.bmq37)
  INSERT INTO default_tmp VALUES ('bmq44',  l_bmq.bmq44)
  INSERT INTO default_tmp VALUES ('bmq44_fac',  l_bmq.bmq44_fac)
  INSERT INTO default_tmp VALUES ('bmq55',  l_bmq.bmq55)
  INSERT INTO default_tmp VALUES ('bmq55_fac', l_bmq.bmq55_fac)
  INSERT INTO default_tmp VALUES ('bmq63',  l_bmq.bmq63)
  INSERT INTO default_tmp VALUES ('bmq63_fac', l_bmq63_fac)
  INSERT INTO default_tmp VALUES ('bmq103', l_bmq.bmq103)
  INSERT INTO default_tmp VALUES ('bmq105', l_bmq.bmq105)
  INSERT INTO default_tmp VALUES ('bmq107', l_bmq.bmq107)
  INSERT INTO default_tmp VALUES ('bmq147', l_bmq.bmq147)
  INSERT INTO default_tmp VALUES ('bmq903', l_bmq.bmq903)
 
  RETURN 1 
END FUNCTION
 
FUNCTION aws_pdmsrv_ima_defaultValue(p_name, p_val, p_tag)
    DEFINE p_name   VARCHAR(10),
           p_val    STRING
    DEFINE p_tag    LIKE type_file.num5
    DEFINE l_val    VARCHAR(20)
 
    DEFINE l_cnt   LIKE type_file.num10
 
    IF p_tag = 1 THEN
       SELECT COUNT(*) INTO l_cnt FROM default_tmp where name= p_name
       
       SELECT value INTO l_val FROM default_tmp WHERE name = p_name
       IF SQLCA.SQLCODE = 0 THEN
          #---------------------------------------------------------------------
          # 若 PDM 未給于值, 才以分群碼設定預設值帶入
          #---------------------------------------------------------------------
          IF l_cnt > 0 AND cl_null(p_val) THEN
             LET p_val = l_val
          END IF 
       END IF
    END IF
 
    CASE p_name
       WHEN "ima01"
           LET g_ima.ima01 = p_val
 
       WHEN "ima25"
           LET g_ima.ima25 = p_val
 
       WHEN "ima31" 
           IF cl_null(p_val CLIPPED) THEN
              LET p_val=g_ima.ima25
              LET g_ima.ima31_fac=1
           END IF
   
       WHEN "ima31_fac" 
           IF g_ima.ima31 IS NOT NULL THEN
              LET p_val = g_ima.ima31_fac
           END IF
 
       WHEN "ima133" 
           IF cl_null(p_val CLIPPED) THEN
              LET p_val = g_ima.ima01
           END IF
           
       WHEN "ima571" 
           IF cl_null(p_val CLIPPED) THEN
              LET p_val = g_ima.ima01
           END IF
           
       WHEN "ima44" 
           IF cl_null(p_val CLIPPED) THEN
              LET p_val=g_ima.ima25   #採購單位
              LET g_ima.ima44_fac=1
           END IF
 
       WHEN "ima44_fac" 
           IF g_ima.ima44_fac IS NOT NULL THEN
              LET p_val = g_ima.ima44_fac
           END IF
           
       WHEN "ima55" 
           IF cl_null(p_val CLIPPED) THEN
              LET p_val = g_ima.ima25   #生產單位
              LET g_ima.ima55_fac=1
           END IF
      
       WHEN "ima55_fac" 
           IF g_ima.ima55 IS NOT NULL THEN
              LET p_val= g_ima.ima55_fac
           END IF
           
       WHEN "ima63" 
           IF cl_null(p_val CLIPPED) THEN
              LET p_val=g_ima.ima25   #發料單位
              LET g_ima.ima63_fac=1
           END IF
 
       WHEN "ima63_fac" 
           IF g_ima.ima63 IS NOT NULL THEN
              LET p_val = g_ima.ima63_fac
           END IF
           
       WHEN "ima86" 
           LET p_val=g_ima.ima25   #庫存單位=成本單位
 
       WHEN "ima86_fac" 
           LET p_val=1
           
       WHEN "ima35" 
           IF cl_null(p_val CLIPPED) THEN
              LET p_val=' ' #No:7726
           END IF
           
       WHEN "ima36" 
           IF cl_null(p_val CLIPPED) THEN
              LET p_val=' ' #No:7726
           END IF
           
       WHEN "ima910"
           IF cl_null(p_val CLIPPED) THEN
              LET p_val=' ' #No:7726
           END IF
           
       WHEN "ima02" 
           IF g_aza.aza44 = "Y" THEN  #FUN-550077
              CALL cl_itemname_switch(1,"ima_file","ima02",g_ima.ima01,p_val) RETURNING p_val 
           END IF
 
       WHEN "ima021"
           IF g_aza.aza44 = "Y" THEN  #FUN-550077
              CALL cl_itemname_switch(1,"ima_file","ima021",g_ima.ima01,p_val) RETURNING p_val
           END IF
           
       WHEN "ima913" 
           LET p_val = "N"   #No.MOD-640061
    END CASE
 
    RETURN p_val
END FUNCTION
 
FUNCTION aws_pdmsrv_bmq_defaultValue(p_name, p_val, p_tag)
    DEFINE p_name   VARCHAR(10),
           p_val    STRING
    DEFINE p_tag    LIKE type_file.num5
    DEFINE l_val    VARCHAR(20)
 
    DEFINE l_cnt   LIKE type_file.num10
 
    IF p_tag = 1 THEN
       SELECT COUNT(*) INTO l_cnt FROM default_tmp where name= p_name
       
       SELECT value INTO l_val FROM default_tmp WHERE name = p_name
       IF SQLCA.SQLCODE = 0 THEN
          #---------------------------------------------------------------------
          # 若 PDM 未給于值, 才以分群碼設定預設值帶入
          #---------------------------------------------------------------------
          IF l_cnt > 0 AND cl_null(p_val) THEN
             LET p_val = l_val
          END IF 
       END IF
    END IF
 
    CASE p_name
       WHEN "bmq910"
           IF cl_null(p_val CLIPPED) THEN
              LET p_val=' ' #No:7726
           END IF
    END CASE
 
    RETURN p_val
END FUNCTION
 
FUNCTION bom_release(p_bma01,p_bma05,p_bma06)
   DEFINE p_bma01  LIKE bma_file.bma01 
   DEFINE p_bma05  LIKE bma_file.bma05 
   DEFINE p_bma06  LIKE bma_file.bma06 
   DEFINE l_bmb01  LIKE bmb_file.bmb01 
   DEFINE l_bmb02  LIKE bmb_file.bmb02 
   DEFINE l_bmb03  LIKE bmb_file.bmb03 
   DEFINE l_bmb04  LIKE bmb_file.bmb04 
   DEFINE l_cnt    LIKE type_file.num10
   DEFINE l_status LIKE type_file.num10
 
    IF NOT cl_null(p_bma05) THEN
       RETURN FALSE
    END IF
    SELECT COUNT(*) INTO l_cnt FROM bmb_file
         WHERE bmb01 = p_bma01 AND bmb29 = p_bma06  #FUN-550014 add
    IF l_cnt=0 THEN
       RETURN FALSE
    END IF
    
    LET p_bma05= TODAY
 
   #UPDATE bma_file SET bma05= p_bma05 WHERE bma01 = p_bma01   #FUN-C40006 mark
    UPDATE bma_file SET bma05= p_bma05,bmadate=g_today WHERE bma01 = p_bma01  #FUN-C40006 add
                                         AND bma06 = p_bma06 #FUN-550014
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗 
       RETURN FALSE
    END IF
 
    LET l_status = TRUE
 
    DECLARE i600_up_cs CURSOR FOR
     SELECT bmb01,bmb02,bmb03,bmb04
       FROM bmb_file
      WHERE bmb01 = p_bma01
        AND bmb29 = p_bma06  #FUN-550014 add
        AND (bmb05 > p_bma05 OR bmb05 IS NULL )
    LET g_success = 'Y'
    FOREACH i600_up_cs INTO l_bmb01,l_bmb02,l_bmb03,l_bmb04
        UPDATE bmb_file
           SET bmb04 = p_bma05,
               bmbdate = g_today     #FUN-C40007 add
         WHERE bmb01 = l_bmb01
           AND bmb02 = l_bmb02
           AND bmb03 = l_bmb03
           AND bmb04 = l_bmb04
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗 
           LET l_status = FALSE
           EXIT FOREACH
        END IF
        UPDATE bmc_file
           SET bmc03 = p_bma05
         WHERE bmc01 = l_bmb01
           AND bmc02 = l_bmb02
           AND bmc021= l_bmb03
           AND bmc03 = l_bmb04
        IF SQLCA.sqlcode THEN
           LET l_status = FALSE
           EXIT FOREACH
        END IF
        UPDATE bmt_file
           SET bmt04 = p_bma05
         WHERE bmt01 = l_bmb01
           AND bmt02 = l_bmb02
           AND bmt03 = l_bmb03
           AND bmt04 = l_bmb04
        IF SQLCA.sqlcode THEN
           LET l_status = FALSE
           EXIT FOREACH
        END IF
    END FOREACH
    RETURN l_status
END FUNCTION
 
#FUN-760068
#[
# Description....: 取得 Record 資料， 檢查主件/元件是否尚有未確認的變更單
# Date & Author..: 2007/06/25 by Echo
# Parameter......: p_list - DomNode - Record XML Node
# Return.........: TRUE/FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_pdmsrv_ecn_check(p_list) 
    DEFINE p_list    om.NodeList
    DEFINE l_list    om.NodeList
    DEFINE l_list2   om.NodeList
    DEFINE l_child   om.DomNode,
           l_child2  om.DomNode,
           l_rnode   om.DomNode
    DEFINE l_bmy05   LIKE bmy_file.bmy05,
           l_bmy14   LIKE bmy_file.bmy14,
           l_bmz02   LIKE bmz_file.bmz02
    DEFINE l_i       LIKE type_file.num10,
           l_j       LIKE type_file.num10
    DEFINE l_cnt     LIKE type_file.num10
 
    LET l_cnt = 0
 
    LET l_rnode = p_list.item(1)
    LET l_list  = l_rnode.selectByPath("//Table[@name=\"bmy_file\"]/Row")
    LET l_list2 = l_rnode.selectByPath("//Table[@name=\"bmz_file\"]/Row")
    IF l_list2.getLength() = 0 THEN     
         #單一主件
         FOR l_j = 1 TO l_list.getLength()
             LET l_child = l_list.item(l_j)
             LET l_bmy05 = l_child.getAttribute("bmy05")
             LET l_bmy14 = l_child.getAttribute("bmy14")
             SELECT COUNT(*) INTO l_cnt FROM bmx_file,bmy_file
              WHERE bmx01 = bmy01   AND bmx04 = "N"
                AND bmy05 = l_bmy05 AND bmy14 = l_bmy14
             IF l_cnt > 0 THEN
                RETURN FALSE
             END IF
         END FOR
    ELSE  
         #多主件
         FOR l_j = 1 TO l_list.getLength()
             LET l_child = l_list.item(l_j)
             LET l_bmy05 = l_child.getAttribute("bmy05")
             FOR l_j = 1 TO l_list2.getLength()
                 LET l_child = l_list2.item(l_j)
                 LET l_bmz02 = l_child.getAttribute("bmz02")
                 SELECT COUNT(*) INTO l_cnt FROM bmx_file,bmy_file,bmz_file
                  WHERE bmx01 = bmy01   AND bmx01 = bmz01   AND bmx04 = "N"
                    AND bmy05 = l_bmy05 AND bmz02 = l_bmz02
                 IF l_cnt > 0 THEN
                    RETURN FALSE
                 END IF
             END FOR
         END FOR
    END IF
 
    RETURN TRUE
 
END FUNCTION
#FUN-760068
