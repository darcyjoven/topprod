# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: aws_efsrv
# Descriptions...: TIPTOP 串接 Easyflow 的 GateWay Server
# Usage .........: fglrun aws_efsrv
# Date & Author..: 92/02/25 By Brendan
# Modify.........: No.MOD-4A0206 04/10/13 By Echo 調整客製、gaz_file程式
# Modify.........: No.FUN-4C0082 04/10/13 By Echo 提供 library function, 使 ERP 憑證輸出時可列印 EasyFlow 簽核人員姓名, 職稱及簽核時間
# Modify.........: No.FUN-520008 04/10/13 By Echo 新增TP與EF副件夾檔功能
# Modify.........: No.MOD-530792 05/03/28 by Echo VARCHAR->CHAR
# Modify.........: No.FUN-550075 05/06/11 By Echo 新增EasyFlow站台
# Modify.........: No.FUN-560076 05/08/01 By Echo 工廠別應為ef傳送的資料為主
# Modify.........: No.MOD-590183 05/09/12 By Echo 定義單別為char(3)放大為char(5)
# Modify.........: No.FUN-680130 06/09/04 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-720042 07/02/27 Genero 2.0
# Modify.........: No.TQC-940184 09/05/13 By mike 跨庫SQL語句一律使用s_dbstring()寫法 
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
IMPORT com
IMPORT os   #No.FUN-9C0009 
DATABASE ds

GLOBALS "../../config/top.global"     #FUN-B80064   ADD 
DEFINE g_input	RECORD
       				strXMLInput	STRING
       			END RECORD,
       g_output	RECORD
       				strXMLOutput	STRING
       			END RECORD
 
DEFINE g_server		STRING,
       g_efsiteip	STRING,
       g_sql		STRING,
       g_wsa		RECORD LIKE wsa_file.*
 
DEFINE g_form	RECORD
		       PlantID            LIKE azp_file.azp01,  #No.FUN-680130 VARCHAR(10),
		       ProgramID          LIKE wsa_file.wsa01,  #No.FUN-680130 VARCHAR(10),
		       SourceFormID       LIKE wsk_file.wsk04,  #No.FUN-680130 VARCHAR(5),        #MOD-590183
		       SourceFormNum      LIKE wsk_file.wsk05,  #No.FUN-680130 VARCHAR(100),
		       Date               STRING,
		       Time               STRING,
		       Status             STRING,
		       FormCreatorID      STRING,
		       FormOwnerID        STRING,
		       TargetFormID       STRING,
		       TargetSheetNo      STRING,
		       Description        STRING
      		END RECORD
DEFINE channel base.Channel
 
MAIN
    OPTIONS
       ON CLOSE APPLICATION STOP,   #Time out 時程式可自動 kill self-process
       INPUT NO WRAP
    DEFER INTERRUPT
    WHENEVER ERROR CONTINUE

    CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80064   ADD
 
    CALL fgl_ws_server_setNamespace("http://tempuri.org/aws_efsrv")   #指定 NameSpace
    CALL fgl_ws_server_publishfunction( 
           "TIPTOPGateWay",
           "http://tempuri.org/aws_efsrv", "g_input",
           "http://tempuri.org/aws_efsrv", "g_output",
           "aws_efsrv"
         )                                                #pubilish function
 
    IF ARG_VAL(1) = '-h' THEN
       CALL aws_efsrv_Help()                              #Call HELP
    END IF
    IF NUM_ARGS() = 0 THEN
       CALL aws_efsrv_startServer("0")                    #Application Server 模式
    ELSE
       CASE ARG_VAL(1) CLIPPED
           WHEN "-W"
                CALL aws_efsrv_generateWSDL(ARG_VAL(2))   #產生 WSDL 檔
           WHEN "-S"
                CALL aws_efsrv_startServer(ARG_VAL(2))    #Standalone Server 模式
           OTHERWISE
                CALL aws_efsrv_Help()                     #Call HELP
       END CASE
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
END MAIN
 
 
FUNCTION aws_efsrv_Help()
    #顯示參數訊息
    DISPLAY "Usage:"
    DISPLAY "  r.r2 aws_efsrv -W serverURL  (Generate WSDL file)"
    DISPLAY "  r.r2 aws_efsrv -S serverPort (Start service)"
    DISPLAY "Example:"
    DISPLAY "  r.r2 aws_efsrv -W http://localhost:8090"
    DISPLAY "  r.r2 aws_efsrv -S 8090"
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
    EXIT PROGRAM
END FUNCTION
 
 
FUNCTION aws_efsrv_generateWSDL(p_serverURL)
    DEFINE p_serverURL   STRING,
           l_ret	LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    #Simple string type
    CALL fgl_ws_setoption("wsdl_stringsize", 0)
 
    #產生 WSDL 檔, 顯示執行訊息
    LET l_ret = fgl_ws_server_generateWSDL(
                 "TIPTOPGateWay",
                 p_serverURL CLIPPED,
                 "TIPTOPGateWay.wsdl"
                )
    IF l_ret = 0 THEN
       DISPLAY "'TIPTOPGateWay.wsdl' has been successfully generated ..."
    ELSE
       DISPLAY "Generation of WSDL failed!"
    END IF
END FUNCTION
 
 
FUNCTION aws_efsrv_startServer(p_serverPort)
    DEFINE p_serverPort	STRING,
           l_ret	LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    
    CALL fgl_ws_server_start(p_serverPort)      #Start server
    DISPLAY "Starting service ..."
    WHILE TRUE
        LET l_ret = fgl_ws_server_process(-1)   #Infinite wait for requests
        IF INT_FLAG THEN                        #當按中斷鍵時
           DISPLAY ""
           DISPLAY "Shutdown service ..."
           CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
           EXIT PROGRAM 
        END IF
 
        #Request 處理後狀態值, '0' 表正常處理
        CASE l_ret
            WHEN 0                              #正常處理 
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                          "Request processed."
            WHEN -1                             #無 request(time out)
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "No request."
            WHEN -2
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "The application server ask the runner to shutdown."
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
                 EXIT PROGRAM
            WHEN -3
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Unexpected client connection broken."
            WHEN -4
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Server process has been interrupted."
            WHEN -5
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Malformed or bad HTTP request received."
            WHEN -6
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Malformed or bad SOAP envelope received."
            WHEN -7
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Malformed or bad XML document received."
 
        END CASE
    END WHILE
END FUNCTION
 
 
FUNCTION aws_efsrv()
    DEFINE l_str	STRING,
           l_file	STRING,
           l_s		STRING,
           l_cmd	STRING
    DEFINE l_pipe       base.Channel
    DEFINE l_wsj02      LIKE wsj_file.wsj02
    
    LET l_pipe = base.Channel.create()
    CALL l_pipe.openPipe("hostname", "r")
    WHILE l_pipe.read(g_server) 
    END WHILE
    CALL l_pipe.close()
 
 
    LET l_str = aws_xml_getTag(g_input.strXMLInput, "RequestMethod")   #Request method
 
    #抓出 EasyFlow 簽核過程中各項資訊
    LET g_form.PlantID = aws_xml_getTag(g_input.strXMLInput, "PlantID")
    LET g_form.ProgramID = aws_xml_getTag(g_input.strXMLInput, "ProgramID")
    LET g_form.SourceFormID = aws_xml_getTag(g_input.strXMLInput, "SourceFormID")
    LET g_form.SourceFormNum = aws_xml_getTag(g_input.strXMLInput, "SourceFormNum")
    LET g_form.Date = aws_xml_getTag(g_input.strXMLInput, "Date")
    LET g_form.Time = aws_xml_getTag(g_input.strXMLInput, "Time")
    LET g_form.Status = aws_xml_getTag(g_input.strXMLInput, "Status")
    LET g_form.FormCreatorID = aws_xml_getTag(g_input.strXMLInput, "FormCreatorID")
    LET g_form.FormOwnerID = aws_xml_getTag(g_input.strXMLInput, "FormOwnerID")
    LET g_form.TargetFormID = aws_xml_getTag(g_input.strXMLInput, "TargetFormID")
    LET g_form.TargetSheetNo = aws_xml_getTag(g_input.strXMLInput, "TargetSheetNo")
    LET g_form.Description = aws_xml_getTag(g_input.strXMLInput, "Description")
 
    #FUN-560076
    #FUN-550075
    #SELECT wsj02 INTO l_wsj02
    #  FROM wsj_file where wsj01 = 'E' AND wsj06 = g_plant
    #    AND wsj05 = '*' AND wsj07 = '*'
    SELECT wsj02 INTO l_wsj02
      FROM wsj_file where wsj01 = 'E' AND wsj06 = g_form.PlantID
        AND wsj05 = '*' AND wsj07 = '*'
    IF l_wsj02 IS NULL THEN
      SELECT wsj02 INTO l_wsj02
        FROM wsj_file where wsj01 = 'S' AND wsj06 = '*'
         AND wsj05 = '*' AND wsj07 = '*'
    END IF
 
    #LET g_efsiteip = fgl_getenv('EFSITEIP')   #EasyFlow site IP
    LET g_efsiteip = l_wsj02 CLIPPED     #EasyFlow site IP
    #END FUN-550075
    #END FUN-560076
 
    DISPLAY ""
    #依 request method 呼叫對應的 function
    CASE l_str CLIPPED
        #回寫狀態值
        WHEN "SetStatus"
             DISPLAY "SetStatus: ", 
                     g_form.ProgramID, " / ", g_form.SourceFormNum
             CALL aws_efsrv_SetStatus()
        #測試連結狀態
        WHEN "CheckConnection"
             DISPLAY "CheckConnection: ", 
                     g_form.ProgramID, " / ", g_form.SourceFormNum
             CALL aws_efsrv_CheckConnection()
        #串 EasyFlow 的程式, 工廠及單別資訊
        WHEN "GetProgramID"
             DISPLAY "GetProgramID: "
             CALL aws_efsrv_GetProgramID()
 
        ## No.FUN-520008 ##
        #文件列表
        WHEN "GetDocumentList"
              DISPLAY "GetDocumentList: ",
                     g_form.ProgramID, " / ", g_form.SourceFormNum
              CALL aws_efsrv_GetDocumentList()   
              
        WHEN "OpenDocument"
              DISPLAY "OpenDocument: ",
                     g_form.ProgramID, " / ", g_form.SourceFormNum
              CALL aws_efsrv_OpenDocument()         
        ## END No.FUN-520008 ##
                       
        #未知的 method name
        OTHERWISE
             DISPLAY "Unsupport services."
             LET g_output.strXMLOutput = "<Response>Unknown Operation</Response>"
    END CASE
 
    #記錄此次呼叫的 method name
    LET l_file = "aws_efsrv-", TODAY USING 'YYYYMMDD', ".log"
    LET channel = base.Channel.create()
 
    CALL channel.openFile(l_file,  "a")
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        LET l_s = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL channel.write(l_s)
        CALL channel.write("")
        LET l_str = "Method: ", l_str CLIPPED
        CALL channel.write(l_str)
        CALL channel.write("")
    
        #紀錄傳入的 XML 字串
        CALL channel.write("Request XML:")
        CALL channel.write(g_input.strXMLInput)
    
        #紀錄回傳的 XML 字串
        CALL channel.write("Response XML:")
        CALL channel.write(g_output.strXMLOutput)
        CALL channel.write("")
        CALL channel.write("#------------------------------------------------------------------------------#")
        CALL channel.write("")
        CALL channel.write("")
        CALL channel.close()
 
#       LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null" #No.FUN-9C0009
#       RUN l_cmd                                          #No.FUN-9C0009 
        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009  
    ELSE
        DISPLAY "Can't open log file."
    END IF
END FUNCTION
 
 
FUNCTION aws_efsrv_XMLHeader(p_method)
    DEFINE p_method	STRING
 
 
    #組 XML Header
    LET g_output.strXMLOutput =   
        "<Response>", ASCII 10,
        " <ResponseType>", p_method CLIPPED, "</ResponseType>", ASCII 10,
        " <ResponseInfo>", ASCII 10,
        "  <SenderIP>", g_server CLIPPED, "</SenderIP>", ASCII 10,
        "  <ReceiverIP>", g_efsiteip CLIPPED, "</ReceiverIP>", ASCII 10,
        " </ResponseInfo>", ASCII 10,
        " <ResponseContent>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efsrv_XMLTrailer()
    #組 XML Trailer
    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
        " </ResponseContent>", ASCII 10,
        "</Response>"
END FUNCTION
 
 
FUNCTION aws_efsrv_returnStatus(p_status, p_desc)
    DEFINE p_status	LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1)
           p_desc	STRING
 
 
    #設定回傳狀態值的 XML 字串
    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
        "  <ReturnInfo>", ASCII 10,
        "   <ReturnStatus>", p_status CLIPPED, "</ReturnStatus>", ASCII 10,
        "   <ReturnDescribe>", p_desc CLIPPED, "</ReturnDescribe>", ASCII 10,
        "  </ReturnInfo>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efsrv_changePlant()
    DEFINE l_db	LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
  
 
    #抓出對應工廠的資料庫名稱
    SELECT azp03 INTO l_db FROM azp_file WHERE azp01 = g_form.PlantID
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN 
       DISPLAY "Select azp_file failed: ", SQLCA.SQLCODE
       RETURN 0
    END IF
 
    #切換資料庫
    DATABASE l_db
#    CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
    CALL cl_ins_del_sid(1,g_form.PlantID) #FUN-980030   #FUN-990069
    IF SQLCA.SQLCODE THEN
       DISPLAY "Switch database failed: ", SQLCA.SQLCODE
       RETURN 0
    END IF
    RETURN 1
END FUNCTION
 
 
FUNCTION aws_efsrv_SetStatus()
    DEFINE l_status	LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
    DEFINE l_i		LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_tag        STRING,
           l_p1         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_p2         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_g_formNum  STRING,
           l_pos	LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_meet	LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_wc		STRING
    DEFINE l_formNum	LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
 
    
    CALL aws_efsrv_XMLHeader("SetStatus")   #組 XML Header 字串
 
    LET l_status = '-'
    
    #判斷是否程式代號有在維護作業中設定
    SELECT * INTO g_wsa.* FROM wsa_file WHERE wsa01 = g_form.ProgramID
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
       CALL aws_efsrv_returnStatus('N', "Program hasn't been defined.")     #程式未於設定檔中指定
    ELSE
       IF NOT aws_efsrv_changePlant() THEN
          CALL aws_efsrv_returnStatus('N', "Database connection failed.")   #資料庫連接有問題
       ELSE
          CASE g_form.Status
               WHEN '2'                     #抽單, 撤簽
                    LET l_status = 'W'
               WHEN '3'                     #同意
                    LET l_status = '1'
               WHEN '4'                     #不同意
                    LET l_status = 'R'
          END CASE
          
          #若單號(g_form.SourceFormNum) 包含其他條件則擷取出來(以{+} 為區隔)
    
          LET l_wc = "" 
          LET l_i = 1
          LET l_tag = "{+}"
          LET l_g_formNum = g_form.SourceFormNum
          LET l_p1 = l_g_formNum.getIndexOf(l_tag,1)
          IF l_p1 != 0 THEN
            WHILE l_i <= l_g_formNum.getLength()
             LET l_p1 = l_g_formNum.getIndexOf(l_tag,l_i)
             LET l_p2 = l_g_formNum.getIndexOf(l_tag,l_p1+3)
             IF l_p2 = 0 THEN
                LET l_wc = l_wc CLIPPED," AND ", l_g_formNum.subString(l_p1+l_tag.getLength(),l_g_formNum.getLength())
                EXIT WHILE
             ELSE
                LET l_wc = l_wc CLIPPED," AND ", l_g_formNum.subString(l_p1+l_tag.getLength(),l_p2-1)
             END IF
 
             LET l_i = l_p2 - 1
 
            END WHILE
          END IF
 
          #取真正單號
          IF LENGTH(l_wc) != 0 THEN
             LET l_p1 = l_g_formNum.getIndexOf(l_tag,1)
             LEt l_formNum = l_g_formNum.subString(1, l_p1-1)
          ELSE
             LET l_formNum = g_form.SourceFormNum
          END IF
 
          BEGIN WORK
          
          #更新單頭檔狀態碼
          LET g_sql = "UPDATE ", g_wsa.wsa02 CLIPPED, " SET ",
                      g_wsa.wsa04 CLIPPED, " = '", l_status CLIPPED, "'",
                      " WHERE ",  g_wsa.wsa03 CLIPPED, " = '", l_formNum CLIPPED, "'"
          IF LENGTH(l_wc) != 0 THEN
             LET g_sql = g_sql CLIPPED, l_wc
          END IF
          EXECUTE IMMEDIATE g_sql
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
             DISPLAY "Update ", g_wsa.wsa04 CLIPPED, " failed: ", SQLCA.SQLCODE
             LET l_status = '-'
          END IF
 
          #更新單身檔狀態碼
          IF (g_wsa.wsa05 CLIPPED IS NOT NULL) AND 
             (g_wsa.wsa06 CLIPPED IS NOT NULL) AND
             (g_wsa.wsa07 CLIPPED IS NOT NULL) THEN
             LET g_sql = "UPDATE ", g_wsa.wsa05 CLIPPED, " SET ",
                         g_wsa.wsa07 CLIPPED, " = '", l_status CLIPPED, "'",
                         " WHERE ",  g_wsa.wsa06 CLIPPED, " = '", l_formNum CLIPPED, "'"
             IF LENGTH(l_wc) != 0 THEN
                LET g_sql = g_sql CLIPPED, l_wc
             END IF
             EXECUTE IMMEDIATE g_sql
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
                DISPLAY "Update ", g_wsa.wsa07 CLIPPED, " failed: ", SQLCA.SQLCODE
                LET l_status = '-'
             END IF
          END IF
          IF l_status = '-' THEN
             ROLLBACK WORK
             CALL aws_efsrv_returnStatus('N', "Status update failed.")   #狀態值更新失敗
          ELSE
            #darcy:2023/04/06 add s---
            if cl_null(g_plant) then
               let g_plant = g_azz.azz03
               select azw02 into g_legal from azw_file where azw01=g_plant
            end if
            #自动审核程序
            if g_wsa.wsa01 = 'cxmt520' then
               if not cws_auto_confirm(g_wsa.wsa01,l_formNum) then
                  #错误处理
                  CALL aws_efsrv_returnStatus('N', "自动审核失败。") 
               end if
            end if
            #darcy:2023/04/06 add e---
             COMMIT WORK
             CALL aws_efsrv_returnStatus('Y', "No error.")               #狀態值更新成功
             CALL aws_eflog(g_input.strXMLInput)                         #寫入 log 
             CALL aws_efstat_approveLog(l_g_formNum)       ##FUN-4C0082 
          END IF
       END IF
    END IF
 
    #指定表單資訊
    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
        "  <ContentText>", ASCII 10,
        "   <Form>", ASCII 10,
        "    <Status>", l_status CLIPPED, "</Status>", ASCII 10,
        "    <PlantID>", g_form.PlantID CLIPPED, "</PlantID>", ASCII 10,
        "    <ProgramID>", g_form.ProgramID CLIPPED, "</ProgramID>", ASCII 10,
        "    <SourceFormID>", g_form.SourceFormID CLIPPED, "</SourceFormID>", ASCII 10,
        "    <SourceFormNum>", g_form.SourceFormNum CLIPPED, "</SourceFormNum>", ASCII 10,
        "    <FormCreatorID>", g_form.FormCreatorID CLIPPED, "</FormCreatorID>", ASCII 10,
        "    <FormOwnerID>", g_form.FormOwnerID CLIPPED, "</FormOwnerID>", ASCII 10,
        "    <TargetFormID>", g_form.TargetFormID CLIPPED, "</TargetFormID>", ASCII 10,
        "    <TargetSheetNo>", g_form.TargetSheetNo CLIPPED, "</TargetSheetNo>", ASCII 10,
        "   </Form>", ASCII 10,
        "  </ContentText>", ASCII 10
   
    CALL aws_efsrv_XMLTrailer()             #組 XML Trailer 字串
END FUNCTION
 
 
FUNCTION aws_efsrv_CheckConnection()
    CALL aws_efsrv_XMLHeader("CheckConnection")                          #組 XML Header 字串
 
    IF NOT aws_efsrv_changePlant() THEN
       CALL aws_efsrv_returnStatus('N', "Database connection failed.")   #連接資料失敗
    ELSE
       CALL aws_efsrv_returnStatus('Y', "No error.")                     #連接資料庫成功
       CALL aws_eflog(g_input.strXMLInput)                               #寫入 log
    END IF
 
    CALL aws_efsrv_XMLTrailer()                                          #組 XML Trailer 字串
END FUNCTION
 
 
FUNCTION aws_efsrv_GetProgramID()
    DEFINE l_azp	RECORD LIKE azp_file.*,
           l_gaz        RECORD LIKE gaz_file.*,
           l_gaz03      LIKE gaz_file.gaz03,
           l_form	RECORD 
           	           slip LIKE azp_file.azp01,   #No.FUN-680130 VARCHAR(10)
           		   desc LIKE azp_file.azp02    #No.FUN-680130 VARCHAR(80)
           		END RECORD,
           l_str	LIKE type_file.chr1000,        #No.FUN-680130 VARCHAR(80)
           l_lang	LIKE type_file.chr20,          #No.FUN-680130 VARCHAR(10)
           l_str_lang   LIKE gaz_file.gaz02,           #No.FUN-680130 VARCHAR(10)
           l_cnt        LIKE type_file.num10           #No.FUN-680130 INTEGER
           
 
 
    LET l_lang = aws_xml_getTag(g_input.strXMLInput, "Language")   #語言別
    CALL aws_efsrv_XMLHeader("GetProgramID")                       #組 XML Header
 
    SELECT COUNT(*) FROM azp_file
    IF SQLCA.SQLCODE THEN
       CALL aws_efsrv_returnStatus('N', "Database connection failed.")   #連接資
    ELSE
       CALL aws_efsrv_returnStatus('Y', "No error.")
    END IF
 
    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
        "  <ContentText>", ASCII 10,
        "   <Language>", l_lang CLIPPED, "</Language>", ASCII 10
 
    DECLARE wsa_cs CURSOR FOR SELECT * FROM wsa_file ORDER BY wsa01 
    FOREACH wsa_cs INTO g_wsa.*   #傳遞程式資料
        IF STATUS THEN
           DISPLAY "Fetch wsa_file failed: ", STATUS
           EXIT FOREACH
        END IF
 
        CASE l_lang CLIPPED
             WHEN "Big5" LET l_str_lang = 0
             WHEN "ISO8859" LET l_str_lang = 1
             WHEN "GB" LET l_str_lang = 2
             OTHERWISE LET l_str_lang = 1
        END CASE
 ## No.MOD-4A0206
        SELECT * INTO l_gaz.* FROM gaz_file 
               WHERE gaz01 = g_wsa.wsa01 AND gaz02 = l_str_lang AND gaz05='Y'
        IF SQLCA.SQLCODE THEN
          SELECT * INTO l_gaz.* FROM gaz_file 
               WHERE gaz01 = g_wsa.wsa01 AND gaz02 = l_str_lang AND (gaz05='N' OR gaz05 IS NULL) 
        END IF
 ## END No.MOD-4A0206 ##
        IF SQLCA.SQLCODE THEN
           LET l_str = g_wsa.wsa01
        ELSE
           LET l_str = l_gaz.gaz03
        END IF
        LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
            "   <Program ",
                "name=\"", g_wsa.wsa01 CLIPPED, "\" ",
                "desc=\"", l_str CLIPPED, "\" ",
                "/>", ASCII 10
    END FOREACH
 
    DECLARE azp_cur CURSOR FOR SELECT * FROM azp_file ORDER BY azp01
    FOREACH azp_cur INTO l_azp.*   #傳遞工廠資料
        IF STATUS THEN
           DISPLAY "Fetch azp_file failed: ", STATUS
           EXIT FOREACH
        END IF
        LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
            "   <Plant ",
                "name=\"", l_azp.azp01 CLIPPED, "\" ",
                "desc=\"", l_azp.azp02 CLIPPED, "\" ",
                "/>", ASCII 10
    END FOREACH
 
    FOREACH wsa_cs INTO g_wsa.*
        IF STATUS THEN
           DISPLAY "Fetch wsa_file failed: ", STATUS
           EXIT FOREACH
        END IF
        FOREACH azp_cur INTO l_azp.*
            IF STATUS THEN
               DISPLAY "Fetch azp_file failed: ", STATUS
               EXIT FOREACH
            END IF
{
            DATABASE l_azp.azp03
            CALL cl_ins_del_sid(1) #FUN-980030
            IF SQLCA.SQLCODE THEN
               DISPLAY "Switch database failed: ", SQLCA.SQLCODE
               CONTINUE FOREACH
            END IF
}
#TQC-940184   ---start   
           #CASE cl_db_get_database_type()
           #   WHEN "ORA" 
           #     LET g_sql = "SELECT ",
           #            g_wsa.wsa09 CLIPPED, ", ", g_wsa.wsa10 CLIPPED,
           #            " FROM ", l_azp.azp03 CLIPPED, ".", g_wsa.wsa08 CLIPPED,
           #            " WHERE"
           #
           #   WHEN "IFX" 
           # 
           #         LET g_sql = "SELECT ",
           #            g_wsa.wsa09 CLIPPED, ", ", g_wsa.wsa10 CLIPPED,
           #            " FROM ", l_azp.azp03 CLIPPED, ".", g_wsa.wsa08 CLIPPED,
           #            " WHERE"
           #END CASE
            LET g_sql = "SELECT ",   
                        g_wsa.wsa09 CLIPPED, ", ", g_wsa.wsa10 CLIPPED, 
                        " FROM ", s_dbstring(l_azp.azp03 CLIPPED),g_wsa.wsa08 CLIPPED,
                        " WHERE"  
#TQC-940184   ---end   
            IF g_wsa.wsa11 IS NOT NULL THEN
               LET g_sql = g_sql CLIPPED, " ",
                            #MOD-490275
                           #g_wsa.wsa11 CLIPPED, " = '", g_wsa.wsa01[1,3], "'",
                           g_wsa.wsa11 CLIPPED, " = '", DOWNSHIFT(g_wsa.wsa15 CLIPPED), "'",
                           #--
                           " AND"
            END IF
            LET g_sql = g_sql CLIPPED, " ",
                        g_wsa.wsa12 CLIPPED, " = '", g_wsa.wsa13 CLIPPED, "'",
                        " AND ", g_wsa.wsa14 CLIPPED, " = 'Y'",
                        " ORDER BY ", g_wsa.wsa09 CLIPPED
            PREPARE form_pre FROM g_sql
            DECLARE form_cur CURSOR FOR form_pre
            FOREACH form_cur INTO l_form.*   #傳遞單別資料
                IF STATUS THEN
                   DISPLAY "Fetch ", l_azp.azp03 CLIPPED, ".", g_wsa.wsa08 CLIPPED, " failed: ", STATUS
                   EXIT FOREACH
                END IF
                LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
                    "   <SourceForm ",
                        "name=\"", l_form.slip, "\" ",
                        "desc=\"", l_form.desc CLIPPED, "\" ",
                        "prog=\"", g_wsa.wsa01 CLIPPED, "\" ",
                        "plant=\"", l_azp.azp01 CLIPPED, "\" ",
                        "/>", ASCII 10
            END FOREACH
        END FOREACH
    END FOREACH
 
    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,   #組 XML Trailer
        "  </ContentText>", ASCII 10
    CALL aws_efsrv_XMLTrailer()
END FUNCTION
 
### No.FUN-520008 ###
FUNCTION aws_efsrv_GetDocumentList()
DEFINE l_key     STRING
DEFINE l_wsa03   LIKE wsa_file.wsa03
    CALL aws_efsrv_XMLHeader("GetDocumentList")                          #組 XML Header 字串
    IF NOT aws_efsrv_changePlant() THEN
       CALL aws_efsrv_returnStatus('N', "Database connection failed.")   #連接資料失敗
    ELSE
       SELECT wsa03 INTO l_wsa03 FROM wsa_file WHERE wsa01 = g_form.ProgramID
       LET l_key = l_wsa03 CLIPPED , "=" , g_form.SourceFormNum 
       display "l_key:",l_key
       LET g_output.strXMLOutput = cl_doc_efGetDocument(l_key,g_output.strXMLOutput)                  
    END IF
    CALL aws_efsrv_XMLTrailer()
 
END FUNCTION
 
FUNCTION aws_efsrv_OpenDocument()
DEFINE l_key     STRING
DEFINE l_wsa03   LIKE wsa_file.wsa03
    CALL aws_efsrv_XMLHeader("OpenDocument")                          #組 XML Header 字串
    IF NOT aws_efsrv_changePlant() THEN
       CALL aws_efsrv_returnStatus('N', "Database connection failed.")   #連接資料失敗
    ELSE
       LET l_key = aws_xml_getTag(g_input.strXMLInput, "Document")
       LET g_output.strXMLOutput = cl_doc_efOpenDocument(l_key,g_output.strXMLOutput)
    END IF
    CALL aws_efsrv_XMLTrailer()
 
END FUNCTION

###END No.FUN-520008 ###
