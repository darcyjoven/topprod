# Prog. Version..: '5.30.06-13.03.12(00008)'     #
# Memo...........: 該支程序GP5.2已不使用
#
# Library name...: aws_ebosrv
# Descriptions...: TIPTOP 串接 e-B Online 的 GateWay Server
# Usage .........: fglrun aws_ebosrv
# Date & Author..: 95/02/07 By Echo  FUN-620004
# Modify.........: No.FUN-760077 07/06/27 By Echo 重覆切換資料庫時出現異常...
# Modify.........: No.FUN-7C0055 07/12/19 By Echo 調整Request處理後狀態值說明
# Modify.........: No.CHI-920065 09/02/19 By Vicky 調整當發生"Internal server error"時 EXIT PROGRAM
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:FUN-960169 09/10/22 By Echo Genero 2.11新增web service錯誤代碼-12到-17
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-A10109 10/03/15 by rainy g_no_ep及 g_no_sp 算法改 call sub
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/16 By fengrui  調整時間函數問題

IMPORT os   #No.FUN-9C0009 
IMPORT com   
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE gi_err_code  STRING
  DEFINE gi_err_msg   STRING
END GLOBALS
 
DEFINE g_input	RECORD
    				strXMLInput	STRING
       			END RECORD,
       g_output	RECORD
       				strXMLOutput	STRING
       			END RECORD
 
DEFINE g_form	RECORD
                       sys          LIKE type_file.chr10,
                       slip         STRING,
                       date         LIKE type_file.dat,
                       type         STRING,
                       tab          STRING,
                       fld          STRING,
                       dbs          STRING,
                       runcard      LIKE type_file.chr1,
                       ps_smy       STRING, 
                       lang         LIKE type_file.chr1
      		END RECORD
DEFINE channel         base.Channel
DEFINE g_status        LIKE type_file.num5                 #FUN-5C0030
 
MAIN
    OPTIONS
        ON CLOSE APPLICATION STOP,  #Time out 時程式可自動 kill self-process
        INPUT NO WRAP
    DEFER INTERRUPT
    WHENEVER ERROR CONTINUE
   
    CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B80064   ADD  #No.FUN-BB0047
 
    CALL fgl_ws_server_setNamespace("http://tempuri.org/aws_ebosrv")   #指定 NameSpace
    CALL fgl_ws_server_publishfunction( 
           "TIPTOPGateWayEBO",
           "http://tempuri.org/aws_ebosrv", "g_input",
           "http://tempuri.org/aws_ebosrv", "g_output",
           "aws_ebosrv"
         )                                                #pubilish function
 
    IF ARG_VAL(1) = '-h' THEN
       CALL aws_ebosrv_Help()                              #Call HELP
    END IF
    IF NUM_ARGS() = 0 THEN
       CALL aws_ebosrv_startServer("0")                    #Application Server 模式
    ELSE
       CASE ARG_VAL(1) CLIPPED
           WHEN "-W"
                CALL aws_ebosrv_generateWSDL(ARG_VAL(2))   #產生 WSDL 檔
           WHEN "-S"
                CALL aws_ebosrv_startServer(ARG_VAL(2))    #Standalone Server 模式
           OTHERWISE
                CALL aws_ebosrv_Help()                     #Call HELP
       END CASE
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
END MAIN
 
 
FUNCTION aws_ebosrv_Help()
    #顯示參數訊息
    DISPLAY "Usage:"
    DISPLAY "  r.r2 aws_ebosrv -W serverURL  (Generate WSDL file)"
    DISPLAY "  r.r2 aws_ebosrv -S serverPort (Start service)"
    DISPLAY "Example:"
    DISPLAY "  r.r2 aws_ebosrv -W http://localhost:8090"
    DISPLAY "  r.r2 aws_ebosrv -S 8090"
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
    EXIT PROGRAM
END FUNCTION
 
 
FUNCTION aws_ebosrv_generateWSDL(p_serverURL)
    DEFINE p_serverURL   STRING,
           l_ret	LIKE type_file.num10
 
    #Simple string type
    CALL fgl_ws_setoption("wsdl_stringsize", 0)
 
    #產生 WSDL 檔, 顯示執行訊息
    LET l_ret = fgl_ws_server_generateWSDL(
                 "TIPTOPGateWayEBO",
                 p_serverURL CLIPPED,
                 "TIPTOPGateWayEBO.wsdl"
                )
    IF l_ret = 0 THEN
       DISPLAY "'TIPTOPGateWayEBO.wsdl' has been successfully generated ..."
    ELSE
       DISPLAY "Generation of WSDL failed!"
    END IF
END FUNCTION
 
 
FUNCTION aws_ebosrv_startServer(p_serverPort)
    DEFINE p_serverPort	STRING,
           l_ret	LIKE type_file.num10
 
    
    CALL fgl_ws_server_start(p_serverPort)      #Start server
    DISPLAY "Starting service ..."
    WHILE TRUE
        LET l_ret = fgl_ws_server_process(-1)   #Infinite wait for requests
        DISPLAY "l_ret:",l_ret                  #FUN-960169
        IF INT_FLAG THEN                        #當按中斷鍵時
           DISPLAY ""
           DISPLAY "Shutdown service ..."
           CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
           EXIT PROGRAM 
        END IF
 
        #No.FUN-7C0055
        #Request 處理後狀態值, '0' 表正常處理
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
                 #EXIT PROGRAM            #FUN-960169 
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
 
 
FUNCTION aws_ebosrv()
    DEFINE l_str	STRING,
           l_file	STRING,
           l_s		STRING,
           l_cmd	STRING,
           l_result     LIKE type_file.num5,
           l_code       STRING,
           l_status     LIKE type_file.chr1
 
    LET g_bgjob = 'Y'                  #背景執行
    LET g_gui_type = 0
    LET g_prog = 'aws_ebosrv'
    LET g_user = 'tiptop'
    LET l_status = "Y"
 
    #抓出 EBO 傳遞的各項資訊
    LET g_form.sys     = aws_xml_getTag(g_input.strXMLInput,"sys")     
    LET g_form.slip    = aws_xml_getTag(g_input.strXMLInput,"slip")    
    LET g_form.date    = aws_xml_getTag(g_input.strXMLInput,"date")    
    LET g_form.type    = aws_xml_getTag(g_input.strXMLInput,"type")    
    LET g_form.tab     = aws_xml_getTag(g_input.strXMLInput,"tab")     
    LET g_form.fld     = aws_xml_getTag(g_input.strXMLInput,"fld")     
    LET g_form.dbs     = aws_xml_getTag(g_input.strXMLInput,"dbs")     
    LET g_form.runcard = aws_xml_getTag(g_input.strXMLInput,"runcard") 
    LET g_form.ps_smy  = aws_xml_getTag(g_input.strXMLInput,"ps_smy")     
    LET g_form.lang    = aws_xml_getTag(g_input.strXMLInput,"lang")     
 
    
    #記錄此次呼叫的 method name
    LET l_file = "aws_ebosrv-", TODAY USING 'YYYYMMDD', ".log"
    LET channel = base.Channel.create()
 
    CALL channel.openFile(l_file,  "a")
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        LET l_s = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL channel.write(l_s)
        CALL channel.write("")
        LET l_s = "Method: ", l_str CLIPPED
        CALL channel.write(l_s)
        CALL channel.write("")
 
        #紀錄傳入的 XML 字串
        CALL channel.write("Request XML:")
        CALL channel.write(g_input.strXMLInput)
        CALL channel.write("")
        CALL channel.close()
 
#       LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null"  #No.FUN-9C0009 
#       RUN l_cmd                                          #No.FUN-9C0009  
        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    ELSE
        DISPLAY "Can't open log file."
    END IF
 
 
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
    CALL s_doc_global_setting(g_form.sys,g_plant)
  ##FUN-A10109 modify end
 
    LET g_lang = g_form.lang
 
 
    IF aws_ebosrv_changePlant() THEN       #切換資料庫
 
       BEGIN WORK
 
       #單據編號檢查
       CALL s_check_no(g_form.sys,g_form.slip,g_form.slip,g_form.type,g_form.tab,g_form.fld,g_form.dbs) 
            RETURNING l_result,g_form.slip
   
       IF l_result THEN
          #依照系統別、單別自動編號
          CALL s_auto_assign_no(g_form.sys,g_form.slip,g_form.date,g_form.type,g_form.tab,g_form.fld,g_form.dbs,g_form.runcard,g_form.ps_smy)
               RETURNING l_result,g_form.slip 
          
          IF l_result THEN
               LET l_status = "Y"
               COMMIT WORK
          ELSE
               ROLLBACK WORK
               LET l_status = "N"
               LET l_code = gi_err_code
               LET g_form.slip = gi_err_msg
          END IF
       ELSE
          ROLLBACK WORK
          LET l_status = "N"
          LET l_code = gi_err_code
          LET g_form.slip = gi_err_msg
       END IF
    ELSE
       LET l_status = "N"
       LET l_code = ""
       LET g_form.slip = "Switch database failed"
    END IF
 
    LET g_output.strXMLOutput =
        "<Results>", ASCII 10,
        "  <status>",l_status,"</status>", ASCII 10,
        "  <rtn_code>",l_code,"</rtn_code>", ASCII 10,
        "  <msg>",g_form.slip CLIPPED,"</msg>", ASCII 10,
        "</Results>"
 
    
    #記錄此次呼叫的 method name
    LET l_file = "aws_ebosrv-", TODAY USING 'YYYYMMDD', ".log"
    LET channel = base.Channel.create()
 
    CALL channel.openFile(l_file,  "a")
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        #紀錄回傳的 XML 字串
        CALL channel.write("Response XML:")
        CALL channel.write(g_output.strXMLOutput)
        CALL channel.write("")
 
        CALL channel.write("#------------------------------------------------------------------------------#")
        CALL channel.write("")
        CALL channel.write("")
        CALL channel.close()
 
#       LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null"  #No.FUN-9C0009 
#       RUN l_cmd                                          #No.FUN-9C0009  
        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    ELSE
        DISPLAY "Can't open log file."
    END IF
 
END FUNCTION
 
FUNCTION aws_ebosrv_changePlant()       #切換資料庫
   DEFINE l_db LIKE type_file.chr20
 
   LET l_db = g_form.dbs CLIPPED
 
#   CALL cl_ins_del_sid(2) #FUN-980030   #FUN-990069 
   CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069 
   CLOSE DATABASE        #此行為解決 4js bug       #FUN-760077
   DATABASE l_db
#   CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069 
   CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069 
   IF SQLCA.SQLCODE THEN
      RETURN 0
   END IF
 
   RETURN 1
END FUNCTION
