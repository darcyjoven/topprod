# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: aws_efsrv2
# Descriptions...: TIPTOP 串接 Easyflow 的 GateWay Server
# Input parameter: none
# Return code....: none
# Usage .........: fglrun aws_efsrv2
# Date & Author..: 92/02/25 By Brendan
# Modify.........: No:FUN-B20029 11/04/08 by Echo 因 CROSS 整合功能，將 aws_efsrv2.4gl 拆為 aws_efsrv2.4gl 及 aws_efsrv2_sub.4gl
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B80090 11/12/30 by ka0132  補aws_efsrv_file WebService呼叫功能
# Modify.........: No:FUN-C40005 12/04/03 By Kevin 清空變數 g_method_name
# Modify.........: No:FUN-C60080 12/06/25 By Kevin 當sevice 完成後,關閉 datatbase
# Modify.........: No:FUN-C70031 12/07/10 By Kevin 檢查是否已連線 ds
# Modify.........: No:FUN-C80108 12/08/29 By Kevin 使用 cl_cmdrun() 會導致 FGLLDPATH 增長，產生效能問題


#FUN-B20029 -- start --

IMPORT com 
IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global" 
GLOBALS "../4gl/awsef.4gl"                #FUN-960057
GLOBALS "../4gl/aws_crossgw.inc"
GLOBALS
DEFINE g_form   RECORD
                       PlantID            LIKE azp_file.azp01,   #No.FUN-680130 VARCHAR(10)
                       ProgramID          LIKE wse_file.wse01,   #No.FUN-680130 VARCHAR(10)
                       SourceFormID       LIKE oay_file.oayslip, #No.FUN-680130 VARCHAR(5)     #MOD-590183
                       SourceFormNum      LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(100)
                       Date               STRING,
                       Time               STRING,
                       Status             STRING,
                       FormCreatorID      STRING,
                       FormOwnerID        STRING,
                       TargetFormID       STRING,
                       TargetSheetNo      STRING,
                       Description        STRING,    
                       SenderIP           STRING  #No.FUN-680130  VARCHAR(10)      #FUN-560076  #FUN-710063
                END RECORD
DEFINE g_method_name   STRING                 #MOD-6A0030
DEFINE g_conn_ds       STRING                 #FUN-C70031
END GLOBALS 

DEFINE g_input	RECORD
       				strXMLInput	STRING
       			END RECORD,
       g_output	RECORD
       				strXMLOutput	STRING
       			END RECORD,
       g_file   RECORD                               
       				strXMLInput	STRING,
                                inputfile   BYTE ATTRIBUTE(XSDBase64binary)
       			END RECORD,
       g_serv   com.WebService
 
 
MAIN
    DEFINE l_op       com.weboperation  #FUN-920153
    DEFINE l_port     STRING            #FUN-920153
    OPTIONS
        ON CLOSE APPLICATION STOP   #Time out 時程式可自動 kill self-process
        #INPUT NO WRAP              #FUN-C40005
    DEFER INTERRUPT
    WHENEVER ERROR CONTINUE

    CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80064   ADD
 
    LOCATE g_file.inputfile IN MEMORY
    
    LET g_serv = com.WebService.CreateWebService("TIPTOPGateWay", 
                                                 "http://tempuri.org/aws_efsrv")
    
    # the operation in RPC Style    
    LET l_op = com.weboperation.createRPCStyle("aws_efsrv","TIPTOPGateWay",g_input,g_output)
    CALL l_op.setinputencoded(TRUE)    
    CALL g_serv.publishOperation(l_op, NULL)
    
    LET l_op = com.weboperation.createRPCStyle("aws_efsrv_file","TIPTOPGateWay_File",g_file,g_output)
    CALL l_op.setinputencoded(TRUE)    
    CALL g_serv.publishOperation(l_op, NULL)  
    
    LET l_port = NULL  
 
    IF ARG_VAL(1) = '-h' THEN
       CALL aws_efsrv2_Help()                              #Call HELP
    END IF
    IF NUM_ARGS() = 0 THEN
       CALL aws_efsrv2_startServer(l_port)                 #Application Server 模式 #FUN-920153
    ELSE
       CASE ARG_VAL(1) CLIPPED
           WHEN "-W"
                CALL aws_efsrv2_generateWSDL(ARG_VAL(2))   #產生 WSDL 檔
           WHEN "-S"
                CALL aws_efsrv2_startServer(ARG_VAL(2))    #Standalone Server 模式
           OTHERWISE
                CALL aws_efsrv2_Help()                     #Call HELP
       END CASE
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
END MAIN
 
 
FUNCTION aws_efsrv2_Help()
    #顯示參數訊息
    DISPLAY "Usage:"
    DISPLAY "  r.r2 aws_efsrv2 -W serverURL  (Generate WSDL file)"
    DISPLAY "  r.r2 aws_efsrv2 -S serverPort (Start service)"
    DISPLAY "Example:"
    DISPLAY "  r.r2 aws_efsrv2 -W http://localhost:8090"
    DISPLAY "  r.r2 aws_efsrv2 -S 8090"
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
    EXIT PROGRAM
END FUNCTION
 
 
FUNCTION aws_efsrv2_generateWSDL(p_serverURL)
    DEFINE p_serverURL   STRING,
           l_ret	LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    #Simple string type
    CALL com.WebServiceEngine.SetOption("wsdl_stringsize", FALSE)
 
    #產生 WSDL 檔, 顯示執行訊息
    LET l_ret = g_serv.saveWSDL(p_serverURL)
    
    IF l_ret = 0 THEN
       DISPLAY "'TIPTOPGateWay.wsdl' has been successfully generated ..."
    ELSE
       DISPLAY "Generation of WSDL failed!"
    END IF
END FUNCTION
 
 
FUNCTION aws_efsrv2_startServer(p_serverPort)
    DEFINE p_serverPort	STRING,
           l_ret	LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE l_fglldpath  STRING                 #FUN-C80108
 
    # 若模式為 standalone 模式, 則需手動指定 listen port
    IF p_serverPort IS NOT NULL THEN
        CALL fgl_setenv("FGLAPPSERVER", p_serverPort)
    END IF
    CALL com.WebServiceEngine.RegisterService(g_serv)
    CALL com.WebServiceEngine.Start()
    
    #FUN-C80108 start
    LET l_fglldpath = FGL_GETENV("FGLLDPATH")
    DISPLAY "Starting service ..." , "[", TODAY, " ", TIME, "] "
    #FUN-C80108 end

    WHILE TRUE

        LET g_method_name = ""    #FUN-C40005
        LET g_conn_ds     = ""    #FUN-C70031
        #----------------------------------------------------------------------#
        #因為使用 cl_cmdrun()/cl_cmdrun_wait() 執行其他程式時會改變 FGLLDPATH 值(增加路徑)
        #為避免 FGLLDPATH 龐大影響程式執行速度, 因此需要還原 FGLLDPATH 環變變數值
        #----------------------------------------------------------------------#
        CALL FGL_SETENV("FGLLDPATH", l_fglldpath)                   #FUN-C80108                

        LET l_ret = com.WebServiceEngine.ProcessServices(-1) # 處理呼叫的服務
        DISPLAY "l_ret:",l_ret                  #FUN-960169 
        IF INT_FLAG THEN                        #當按中斷鍵時
           DISPLAY ""
           DISPLAY "Shutdown service ..."
           CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
           EXIT PROGRAM 
        END IF
 
        #Request 處理後狀態? '0' 表正常處理
        CASE l_ret
            WHEN 0                              #正常處理 
                 #FUN-B20029 -- start --
                 #IF g_method_name =  "SetStatus" THEN
                 #   SELECT aza72 INTO g_aza.aza72 
                 #     FROM aza_file WHERE aza01='0' #No.TQC-740114 #FUN-780070
                 #   DISPLAY "aza72: ", g_aza.aza72 #No.TQC-740114
                 #     LET g_progID = g_form.ProgramID   #FUN-960057
                 #     SLEEP 5    #CHI-A50019 add
                 #     CALL aws_efstat2_approveLog(g_form.SourceFormNum)
                 #END IF
                 CALL aws_ttsrv2_bgjob(g_method_name) 
                 #FUN-B20029 -- end --
 
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                          "Request processed successfully."
            WHEN -1                             #無 request(time out)
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Time out reached."
            WHEN -2
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Disconnected from application server."
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
            WHEN -11
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "WSDL Generation failed."
 
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
       
       IF g_conn_ds = "Y" THEN       #FUN-C70031
          CALL cl_ins_del_sid(2,'')  #FUN-C60080
          CLOSE DATABASE             #FUN-C60080
       END IF                        #FUN-C70031

       #IF l_ret <> 0 THEN                                             #FUN-C40005
       IF INT_FLAG OR l_ret = -2 OR l_ret = -10 OR l_ret = -15 OR l_ret = -8 THEN    #FUN-C40005
          #CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-C60080 因close database ,所以移除cl_used
          DISPLAY "[", TODAY, " ", TIME, "] STOP aws_efsrv2 (By return code)" #FUN-C80108 顯示錯誤代碼的離開時間
          EXIT WHILE                                         #FUN-C60080
       END IF

    END WHILE
END FUNCTION
 
FUNCTION aws_efsrv()
    
    LET g_output.strXMLOutput = aws_efsrv_sub(g_input.strXMLInput)
 
END FUNCTION

#---FUN-B80090---start-----
FUNCTION aws_efsrv_file()
    
    LET g_output.strXMLOutput = aws_efsrv_file_sub(g_file.strXMLInput, g_file.inputfile)
 
END FUNCTION
#---FUN-B80090---end------- 

#FUN-B20029 -- end -- 
