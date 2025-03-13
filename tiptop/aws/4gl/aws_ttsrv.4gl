# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: aws_ttsrv.4gl
# Descriptions...: TIPTOP Services 服務入口
# Date & Author..: 2007/02/06 by Brendan
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-7C0055 07/12/19 By Echo 調整Request處理後狀態值說明
# Modify.........: No.CHI-920065 09/02/19 By Vicky 調整當發生"Internal server error"時 EXIT PROGRAM
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960169 09/10/22 By Echo Genero 2.11新增web service錯誤代碼-12到-17
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
IMPORT com
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
    DEFINE l_action   LIKE type_file.num10,
           l_port     STRING,
           l_url      STRING
 
    OPTIONS
       ON CLOSE APPLICATION STOP,  #服務結束時自動結束程式
       INPUT NO WRAP
    DEFER INTERRUPT
    WHENEVER ERROR CONTINUE
  
    CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80064   ADD
 
    LET g_prog = "aws_ttsrv"
    LET g_user = "tiptop"
    LET g_bgjob = "Y"
    LET g_gui_type = 0
 
    LET l_action = -1 
    CASE NUM_ARGS()
         WHEN 0
              #----------------------------------------------------------------#
              # 透過 application server(gasd) 模式啟動 4GL Web Services 程式   #
              #----------------------------------------------------------------#
              IF fgl_getenv("FGLAPPSERVER") IS NOT NULL THEN
                 LET l_action = 2
                 LET l_port = "0"           
              END IF
         WHEN 2
              CASE ARG_VAL(1) CLIPPED
                   #-----------------------------------------------------------#
                   # 指定參數產生 WSDL 檔案                                    #
                   #-----------------------------------------------------------#
                   WHEN "-W"
                        LET l_action = 1
                        LET l_url = ARG_VAL(2)
                   #-----------------------------------------------------------#
                   # 透過 standalone(r.r2) 模式啟動 4GL Web Services 程式      #
                   #-----------------------------------------------------------#
                   WHEN "-S"
                        LET l_action = 2
                        LET l_port = ARG_VAL(2)
              END CASE
    END CASE
 
    IF l_action = -1 THEN
       CALL aws_ttsrv_help()
       EXIT PROGRAM
    END IF
 
    #--------------------------------------------------------------------------#
    # 指定服務 NameSpace                                                       #
    #--------------------------------------------------------------------------#
    CALL fgl_ws_server_setNamespace("http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay")  
 
    CALL aws_ttsrv_publishService()
 
    CASE l_action
         WHEN 1            
              CALL aws_ttsrv_generateWSDL(l_url)
         WHEN 2
              CALL aws_ttsrv_startServer(l_port)
    END CASE  
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD   
END MAIN
 
#[
# Description....: 顯示執行時參數說明
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_help()
    DISPLAY "Usage:"
    DISPLAY "  r.r2 aws_ttsrv -W serverURL  (Generate WSDL file)"
    DISPLAY "  r.r2 aws_ttsrv -S serverPort (Start service)"
    DISPLAY "  r.r2 aws_ttsrv -h            (Display This Help)"
    DISPLAY "Example:"
    DISPLAY "  r.r2 aws_ttsrv -W http://localhost:8090"
    DISPLAY "  r.r2 aws_ttsrv -S 8090"
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
    EXIT PROGRAM
END FUNCTION
 
 
#[
# Description....: 產生 TIPTOP Web Services WSDL 檔案
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: p_url - STRING - 服務網址
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_generateWSDL(p_url)
    DEFINE p_url   STRING,
           l_ret   LIKE type_file.num10
 
           
    #--------------------------------------------------------------------------#
    # Simple string type                                                       #
    #--------------------------------------------------------------------------#
    CALL fgl_ws_setoption("wsdl_stringsize", 0)
 
    #--------------------------------------------------------------------------#
    # 產生 WSDL 檔, 並顯示執行訊息                                             #
    #--------------------------------------------------------------------------#
    LET l_ret = fgl_ws_server_generateWSDL(
                 "TIPTOPServiceGateWay",
                 p_url CLIPPED,
                 "TIPTOPServiceGateWay.wsdl"
                )
    IF l_ret = 0 THEN
       DISPLAY "'TIPTOPServiceGateWay.wsdl' generated successfully."
    ELSE
       DISPLAY "'TIPTOPServiceGateWay.wsdl' generated failed."
    END IF
END FUNCTION
 
 
#[
# Description....: 啟動 TIPTOP Service 程序進行服務
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: p_port - STRING - 服務 listen port
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_startServer(p_port)
    DEFINE p_port   STRING,
           l_ret    LIKE type_file.num10,
           l_time   STRING
 
    
    #--------------------------------------------------------------------------#
    # 啟動服務                                                                 #
    #--------------------------------------------------------------------------#
    CALL fgl_ws_server_start(p_port)
    LET l_time = "(@ ", TODAY, " ", TIME, ")"
    DISPLAY "Start TIPTOP Service Gateway ", l_time, " ..."
 
    WHILE TRUE
        #----------------------------------------------------------------------#
        # 處理進行呼叫的服務                                                   #
        #----------------------------------------------------------------------#
        LET l_ret = fgl_ws_server_process(-1)
        DISPLAY "l_ret:",l_ret                  #FUN-960169
        IF INT_FLAG THEN
           DISPLAY ""
           DISPLAY "Shutdown TIPTOP Service Gateway ", l_time, " ..."
           CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
           EXIT PROGRAM 
        END IF
 
        #----------------------------------------------------------------------#
        # 服務處理後狀態值顯示, '0' 表正常處理, 其餘回傳值表各種 error 狀態    #
        #----------------------------------------------------------------------#
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
                 #EXIT PROGRAM       #FUN-960169 mark
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
                 #EXIT PROGRAM         #CHI-920065 add  #FUN-960169 mark
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
