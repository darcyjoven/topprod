# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: aws_mdmsrv.4gl
# Descriptions...: TIPTOP & MDM 整合: TIPTOP Services 服務
# Date & Author..: 08/06/05 By Echo FUN-850147
# Modify.........: 08/09/24 By kevin FUN-890113 多筆傳送
# Modify.........: No.CHI-920065 09/02/19 By Vicky 調整當發生"Internal server error"時 EXIT PROGRAM
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960169 09/10/22 By Echo Genero 2.11新增web service錯誤代碼-12到-17
# Modify.........: No.FUN-A10080 10/01/15 By Echo 重新過單
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
IMPORT com
 
DATABASE ds
 
#FUN-A10080  
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"
GLOBALS "../4gl/aws_mdmsrv_global.4gl"
 
DEFINE serv         com.WebService        # WebService
DEFINE op           com.WebOperation     # Operation of a WebService
 
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
 
    LET g_prog = "aws_mdmsrv"
    LET g_user = "MDM"
    LET g_bgjob = "Y"
    LET g_gui_type = 0
    LET g_today = TODAY
    SELECT zx03 INTO g_grup FROM zx_file WHERE zx01=g_user
 
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
 
                        CALL FGL_SETENV("FGLAPPSERVER",l_port)
                        
                        DISPLAY FGL_GETENV("FGLAPPSERVER")
 
              END CASE
    END CASE
 
    IF l_action = -1 THEN
       CALL aws_mdmsrv_help()
       EXIT PROGRAM
    END IF
 
    #--------------------------------------------------------------------------#
    # 建立 WebServices                                                         #
    #--------------------------------------------------------------------------#
    LET serv = com.WebService.CreateWebService("ITPWebService","http://www.dsc.com.tw/tiptop/ITPMDMWebService")
 
    #--------------------------------------------------------------------------#
    # 建立 Create Document Style Operations                                    #
    #--------------------------------------------------------------------------#
    #FUN-890113 start
    LET op = com.WebOperation.CreateDocStyle("aws_mdmsrv","syncMasterData",syncMasterData_in,syncMasterData_out)
    CALL serv.createHeader(mule,true)
    #FUN-890113 end
    CALL serv.publishOperation(op,NULL)
 
 
    CASE l_action
         WHEN 1            
              CALL aws_mdmsrv_generateWSDL(l_url)
         WHEN 2
              CALL aws_mdmsrv_startServer()
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
FUNCTION aws_mdmsrv_help()
    DISPLAY "Usage:"
    DISPLAY "  r.r2 aws_mdmsrv -W serverURL  (Generate WSDL file)"
    DISPLAY "  r.r2 aws_mdmsrv -S serverPort (Start service)"
    DISPLAY "  r.r2 aws_mdmsrv -h            (Display This Help)"
    DISPLAY "Example:"
    DISPLAY "  r.r2 aws_mdmsrv -W http://localhost:8090"
    DISPLAY "  r.r2 aws_mdmsrv -S 8090"
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
FUNCTION aws_mdmsrv_generateWSDL(p_url)
    DEFINE p_url   STRING,
           l_ret   LIKE type_file.num10
 
    #--------------------------------------------------------------------------#
    # 產生 WSDL 檔, 並顯示執行訊息                                             #
    #--------------------------------------------------------------------------#
    LET l_ret = serv.savewsdl(p_url CLIPPED)
    IF l_ret = 0 THEN
       DISPLAY "'ITPWebService.wsdl' generated successfully."
    ELSE
       DISPLAY "'ITPWebService.wsdl' generated failed."
    END IF
END FUNCTION
 
 
#[
# Description....: 啟動 TIPTOP Service 程序進行服務
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_mdmsrv_startServer()
    DEFINE l_ret    LIKE type_file.num10,
           l_time   STRING
 
    #--------------------------------------------------------------------------#
    # Register service                                                         #
    #--------------------------------------------------------------------------#
    CALL com.WebServiceEngine.RegisterService(serv)
    
    #--------------------------------------------------------------------------#
    # 啟動服務                                                                 #
    #--------------------------------------------------------------------------#
    CALL com.WebServiceEngine.Start()
    LET l_time = "(@ ", TODAY, " ", TIME, ")"
    DISPLAY "Start TIPTOP Service ", l_time, " ..."
 
    WHILE TRUE
        #----------------------------------------------------------------------#
        # 處理進行呼叫的服務                                                   #
        #----------------------------------------------------------------------#
        LET l_ret = com.WebServiceEngine.ProcessServices(-1)
        DISPLAY "l_ret:",l_ret                  #FUN-960169 
        IF INT_FLAG THEN
           DISPLAY ""
           DISPLAY "Shutdown TIPTOP Service ", l_time, " ..."
           CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
           EXIT PROGRAM 
        END IF
 
        #----------------------------------------------------------------------#
        # 服務處理後狀態顯示                                                   #
        #----------------------------------------------------------------------#
        CASE l_ret
            WHEN 0                
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                          "Request processed."
            WHEN -1
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Timeout reached."
            WHEN -2
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Disconnected from application server."
                 #EXIT PROGRAM            #FUN-960169 mark
            WHEN -3
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Lost connection with the client."
            WHEN -4
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Server has been interrupted with Ctrl-C."
            WHEN -5
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Bad HTTP request."
            WHEN -6
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Malformed SOAP envelope."
            WHEN -7
                 DISPLAY "[", TODAY, " ", TIME, "] ",
                         "Malformed XML document."
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
    END WHILE
END FUNCTION
 
FUNCTION aws_mdmsrv()
 
   #--------------------------------------------------------------------------#
   # 寫入傳入參數字串至記錄檔中                                               #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_file("in")
 
   #--------------------------------------------------------------------------#
   # 依 Request mddTableName 呼叫對應的功能                                   #
   #--------------------------------------------------------------------------#
   CALL aws_mdmsrv_service()
 
   #--------------------------------------------------------------------------#
   # 處理回傳參數                                                             #
   #--------------------------------------------------------------------------#
    CALL aws_mdmsrv_processResponse()
 
 
   #--------------------------------------------------------------------------#
   # 寫入回傳參數字串至記錄檔中                                               #
   #--------------------------------------------------------------------------#
   CALL aws_mdmsrv_file("out")
 
END FUNCTION
