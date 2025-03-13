# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: aws_ttsrv2.4gl
# Descriptions...: TIPTOP Services 服務入口
# Date & Author..: 2007/02/06 by Brendan
# Modify.........: 新建立 FUN-840004
# Modify.........: FUN-8A0112 By David Fluid Lee 新增"-F"功能參數，整合TIPTOP通用集成接口
# Modify.........: No.CHI-920065 09/02/19 By Vicky 調整當發生"Internal server error"時 EXIT PROGRAM
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960169 09/10/22 By Echo Genero 2.11新增web service錯誤代碼-12到-17
# Modify.........: No.FUN-A40084 10/04/29 By Echo Genero2.21版本需調整 com.WebOperation.CreateDOCStyle
# Modify.........: No.FUN-B20029 11/03/22 By Echo TIPTOP 與 CROSS 整合,增加 Operation: invokeSrv, callbackSrv, syncProd, mdmSrv
# Modify.........: No.FUN-B50032 11/05/12 By Jay  mdmsrv名稱改為invokeMdm
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B90052 12/01/11 By Mandy 給g_lastdat 預設值
# Modify.........: No:FUN-C40005 12/05/03 By Kevin 調整 l_ret 錯誤代碼
# Modify.........: No:FUN-C60080 12/06/26 By Kevin 因service 完成會關閉database ,移除cl_used
# Modify.........: No:FUN-C70031 12/07/10 By Kevin 檢查是否已連線 ds
# Modify.........: No:FUN-C80108 12/08/29 By Kevin 使用 cl_cmdrun() 會導致 FGLLDPATH 增長，產生效能問題
# Modify.........: No:FUN-CB0142 12/11/30 By Kevin 取消 close database
 
IMPORT com
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

#FUN-B20029  -- start --
GLOBALS
DEFINE g_method_name      STRING                 
DEFINE g_conn_ds          STRING      #FUN-C70031
END GLOBALS
#FUN-B20029  -- end --
 
DEFINE g_serv     com.WebService
 
MAIN
    DEFINE l_action   LIKE type_file.num10,
           l_port     STRING,
           l_url      STRING
 
    DEFINE l_temp        STRING,         	#No.FUN-8A0112
  	   l_ch          base.Channel, 		#No.FUN-8A0112  
           l_strbuf      base.StringBuffer	#No.FUN-8A0112
           
    OPTIONS
        ON CLOSE APPLICATION STOP   #服務結束時自動結束程式
        #INPUT NO WRAP              #FUN-C40005
    DEFER INTERRUPT
    WHENEVER ERROR CONTINUE
  
#    CALL cl_used(g_prog,g_time,1) RETURNING g_time        #FUN-C40005  #FUN-B80064   ADD

    LET g_prog = "aws_ttsrv2"
    LET g_user = "tiptop"
    LET g_bgjob = "Y"
    LET g_gui_type = 0
    LET g_lang = 0
    LET g_today = TODAY
    LET g_lastdat = MDY(12,31,9999) #FUN-B90052 add
    SELECT zx03 INTO g_grup FROM zx_file WHERE zx01=g_user

    CALL cl_used(g_prog,g_time,1) RETURNING g_time          #FUN-C40005 #FUN-B80064   ADD
 
    LET l_action = -1 
    LET l_port = NULL
    CASE NUM_ARGS()
         WHEN 0
              #----------------------------------------------------------------#
              # 透過 Application Server(gasd) 模式啟動 4GL Web Services 程式   #
              #----------------------------------------------------------------#
              IF fgl_getenv("FGLAPPSERVER") IS NOT NULL THEN
                 LET l_action = 2         
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
                   #No.FUN-8A0112 BEGIN-> 
		   #-----------------------------------------------------------#
                   # 啟動TIPTOP通用集成接口Debug模式                                            #
                   #-----------------------------------------------------------#
                   WHEN "-F"  
                       	LET l_ch = base.Channel.create()                                              
    			CALL l_ch.openFile(ARG_VAL(2),'r')
    			WHILE l_ch.read(l_temp)                                                              
      				LET g_request.request = g_request.request.trim(),l_temp.trim()                
    			END WHILE                      
    			DISPLAY g_request.request 
			LET l_strbuf = base.StringBuffer.create()                                 
    			CALL l_strbuf.append(g_request.request)                                     
    			CALL l_strbuf.replace('\\','\\\\',0) 
 			LET g_request.request = l_strbuf.toString() 
                       	IF NOT cl_null(g_request.request) THEN                                        
       			    LET l_action = 3                                                     
    			END IF          
                   #No.FUN-8A0112 <-END
              END CASE
    END CASE
 
    #--------------------------------------------------------------------------#
    # 若沒有指定正確的參數                                                     #
    #--------------------------------------------------------------------------#
    IF l_action = -1 THEN
       CALL aws_ttsrv_help()
       EXIT PROGRAM
    END IF
    
    #--------------------------------------------------------------------------#
    # 建立 Web Services 服務                                                   #
    #--------------------------------------------------------------------------#
    CALL aws_ttsrv_createService()
 
    CASE l_action
         WHEN 1            
              CALL aws_ttsrv_generateWSDL(l_url)
         WHEN 2
              CALL aws_ttsrv_startServer(l_port)
 	 WHEN 3                                          #No.FUN-8A0112                       
              CALL aws_ttsrv2_GateWay()                  #No.FUN-8A0112
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
    DISPLAY "  r.r2 aws_ttsrv2 -W serverURL  (Generate WSDL file)"
    DISPLAY "  r.r2 aws_ttsrv2 -S serverPort (Start service)"
    DISPLAY "  r.r2 aws_ttsrv2 -F logfile    (Start TIPTOPGateWay Debug)" #No.FUN-8A0112 
    DISPLAY "  r.r2 aws_ttsrv2 -h            (Display This Help)"
    DISPLAY "Example:"
    DISPLAY "  r.r2 aws_ttsrv2 -W http://localhost:8090"
    DISPLAY "  r.r2 aws_ttsrv2 -S 8090"
    DISPLAY "  r.r2 aws_ttsrv2 -F $TEMPDIR/g_request_20081022-14:24:35.xml" #No.FUN-8A0112 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
    EXIT PROGRAM
END FUNCTION
 
 
#[
# Description....: 建立 Web Service 
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_createService()
    DEFINE p_action    LIKE type_file.num10
    DEFINE l_op        com.WebOperation
    DEFINE l_ns        STRING
    DEFINE l_func      STRING,
           l_op_name   STRING
    DEFINE l_wsr01     LIKE wsr_file.wsr01
    DEFINE l_wsr04     LIKE wsr_file.wsr04
    DEFINE l_sql       STRING
 
    LET l_ns = "http://www.dsc.com.tw/tiptop/TIPTOPServiceGateWay"   #指定 Namespace
    
    LET g_serv = com.WebService.CreateWebService("TIPTOPServiceGateWay", l_ns)
 
    #--------------------------------------------------------------------------#
    # Publish ERP Service function                                             #
    #--------------------------------------------------------------------------#
    
    #FUN-A40084 -- start --
    #CALL aws_ttsrv_serviceFunction()

    LET l_sql = "SELECT wsr01,wsr04 FROM wsr_file WHERE wsr02='S'"
    PREPARE ttcfg2_prepare FROM l_sql
    DECLARE ttcfg2_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR ttcfg2_prepare
    FOREACH ttcfg2_cs INTO l_wsr01,l_wsr04
        #--- 範 例 ------------------------#
        #LET l_op_name = "GetItemData"
        #LET l_func = "aws_getItemData"
        #----------------------------------#
        #LET l_op_name = l_wsr01 CLIPPED
        #LET l_func = l_wsr04 CLIPPED
        #LET l_op = com.WebOperation.CreateDOCStyle(l_func, l_op_name, g_request, g_response)

        LET l_op = aws_ttsrv_serviceFunction(l_wsr01 CLIPPED,l_wsr04 CLIPPED)
        CALL g_serv.publishOperation(l_op, NULL)

    END FOREACH
    #FUN-A40084 -- end --
    
    #No.FUN-B20029  -- start --
    #---------------------------------------------------------------------------------------#
    # TIPTOP 與 CROSS 整合,增加 Operation: invokeSrv, callbackSrv, syncProd, mdmSrv         #
    # 因 java 解析 Web Service的參數必須為 string 型態，因此使用 RPC 格式                   # 
    #---------------------------------------------------------------------------------------#
    LET l_op = com.WebOperation.CreateRPCStyle("aws_invokeSrv","invokeSrv", g_request, g_response)
    CALL g_serv.publishOperation(l_op, NULL) 

    LET l_op = com.WebOperation.CreateRPCStyle("aws_callbackSrv","callbackSrv", g_request, g_response)
    CALL g_serv.publishOperation(l_op, NULL) 
   
    LET l_op = com.WebOperation.CreateRPCStyle("aws_syncProd","syncProd", g_request, g_response)
    CALL g_serv.publishOperation(l_op, NULL) 

    LET l_op = com.WebOperation.CreateRPCStyle("aws_invokeMdm","invokeMdm", g_request, g_response)   #FUN-B50032  mdmsrv名稱改為invokeMdm
    CALL g_serv.publishOperation(l_op, NULL) 

    #No.FUN-B20029  -- end --


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
    # 當變數為 CHAR/VARCHAR, 視為 STRING 不特別再指定 size                     #
    #--------------------------------------------------------------------------#
    CALL com.WebServiceEngine.SetOption("wsdl_stringsize", FALSE) 
 
    #--------------------------------------------------------------------------#
    # 產生 WSDL 檔, 並顯示執行訊息                                             #
    #--------------------------------------------------------------------------#
    LET l_ret = g_serv.saveWSDL(p_url)
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
    DEFINE p_port     STRING,
           l_ret      LIKE type_file.num10,
           l_msg      STRING,
           l_serial   STRING
    DEFINE l_fglldpath  STRING                 #FUN-C80108
 
    #--------------------------------------------------------------------------#
    # 若模式為 standalone(r.r2) 模式, 則需手動指定 listen port                 #
    #--------------------------------------------------------------------------#
    IF NOT cl_null(p_port) THEN
       CALL fgl_setenv("FGLAPPSERVER", p_port)
    END IF
    
    #--------------------------------------------------------------------------#
    # 啟動服務                                                                 #
    #--------------------------------------------------------------------------#    
    LET l_serial = FGL_GETPID() USING '<<<<<<<<<<'
    CALL com.WebServiceEngine.RegisterService(g_serv)  
    CALL com.WebServiceEngine.Start()
    
    LET l_fglldpath = FGL_GETENV("FGLLDPATH")          #FUN-C80108
    DISPLAY "[", TODAY USING 'YYYY/MM/DD', " ", TIME, " #", l_serial ,"] START TIPTOP Service Gateway  ..."
    DISPLAY ""
 
    WHILE TRUE

        LET g_conn_ds     = NULL                               #FUN-C70031
        LET g_method_name = NULL                               #FUN-B20029
        LET g_service     = NULL                               #FUN-B20029

        #----------------------------------------------------------------------#
        #因為使用 cl_cmdrun()/cl_cmdrun_wait() 執行其他程式時會改變 FGLLDPATH 值(增加路徑)
        #為避免 FGLLDPATH 龐大影響程式執行速度, 因此需要還原 FGLLDPATH 環變變數值
        #----------------------------------------------------------------------#
        CALL FGL_SETENV("FGLLDPATH", l_fglldpath)                   #FUN-C80108

        #----------------------------------------------------------------------#
        # 處理呼叫的服務                                                       #
        #----------------------------------------------------------------------#
        LET l_ret = com.WebServiceEngine.ProcessServices(-1)
        DISPLAY "l_ret:",l_ret                  #FUN-960169
 
        #----------------------------------------------------------------------#
        # 服務處理後狀態值顯示, '0' 表正常處理, 其餘回傳值表各種 error 狀態    #
        #----------------------------------------------------------------------#
        CASE l_ret
            WHEN 0         
                 #FUN-B20029 -- start --
                 #回傳 Response 後，若有需要背景執行功能可以加在此funcation裡
                 IF cl_null(g_method_name) THEN    #如果沒有透過 invokeSrv功能
                    LET g_method_name = g_service
                 END IF
                 CALL aws_ttsrv2_bgjob(g_method_name)         
                 #FUN-B20029 -- end --
                 LET l_msg = "Rquest processed successfully."
            WHEN -1
                 LET l_msg = "Time out reached."
            WHEN -2
                 LET l_msg = "Disconnected from application server."
            WHEN -3
                 LET l_msg = "Lost connection with the client."
            WHEN -4
                 LET l_msg = "Server process has been interrupted with Ctrl-C."
            WHEN -5
                 LET l_msg = "Bad HTTP request received."
            WHEN -6
                 LET l_msg = "Malformed or bad SOAP envelope received."
            WHEN -7
                 LET l_msg = "Malformed or bad XML document received."
            WHEN -8
                 LET l_msg = "HTTP error."
            WHEN -9
                 LET l_msg = "Unsupported operation."
            WHEN -10
                 LET l_msg = "Internal server error."
            WHEN -11
                 LET l_msg = "WSDL Generation failed."
            #--FUN-960169--start--
            WHEN -12
                 LET l_msg = "WSDL Service not found."
            WHEN -13
                 LET l_msg = "Reserved."
            WHEN -14
                 LET l_msg = "Incoming request overflow."
            WHEN -15
                 LET l_msg = "Server was not started."
            WHEN -16
                 LET l_msg = "Request still in progress."
            WHEN -17
                 LET l_msg = "Stax response error."
            #--FUN-960169--end--
        END CASE
        
        DISPLAY "  (", TODAY USING 'YYYY/MM/DD', " ", TIME, " #", l_serial, ") ", l_msg
        DISPLAY ""
        #FUN-CB0142 start
        #IF g_conn_ds = "Y" THEN       #FUN-C70031 start
        #   CALL cl_ins_del_sid(2,'')  #FUN-C60080
        #   CLOSE DATABASE             #FUN-C60080
        #END IF                        #FUN-C70031 end
        #FUN-CB0142 end

        #IF INT_FLAG OR l_ret = -2 OR l_ret = -10 THEN  #CHI-920065 add #FUN-960169
        #IF INT_FLAG OR l_ret <> 0 THEN      #FUN-960169                #FUN-C40005
        IF INT_FLAG OR l_ret = -2 OR l_ret = -10 OR l_ret = -15 OR l_ret = -8 THEN  #FUN-C40005
           DISPLAY "[", TODAY USING 'YYYY/MM/DD', " ", TIME, " #", l_serial, "] STOP TIPTOP Service Gateway  ..."
           #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B80064  #FUN-C60080 因close database ,所以移除cl_used
           EXIT WHILE                                     #FUN-C60080
        END IF
    END WHILE
END FUNCTION
