# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#{
# Program name...: aws_ttsrv2_lib.4gl
# Descriptions...: 處理 TIPTOP 服務的共用 FUNCTION
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-840004,FUN-870167
# Modify.........: No.FUN-930132 09/06/29 By Vicky 增加抓取sma_file資料，以取得行業別
# Modify.........: No.FUN-A90024 11/01/11 By Jay 增加create temptable
# Modify.........: No:FUN-C60080 12/06/25 By Kevin 連線 Database ds  
# Modify.........: No:FUN-C70031 12/07/10 By Kevin 檢查是否已連線 ds
# Modify.........: No:FUN-CB0024 12/11/06 By Abby 重要ERP全域變數初始化
# Modify.........: No:FUN-CB0142 12/11/30 By Kevin 補上 close database
# Modify.........: No:FUN-D10121 13/01/28 By zack  設定初始 ERP 全域變數
# Modify.........: No.FUN-I20005 18/02/08 By yc.chao 修正aws_ttsrv_conn_ds()關閉資料庫連線失敗後無法再重新連線問題 #add by zhangsba190926
#}
 
DATABASE ds
 
#FUN-840004 FUN-870167
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
GLOBALS
DEFINE g_conn_ds          STRING         #FUN-C70031

END GLOBALS
 
#[
# Description....: 處理服務前置設定 --- e.x. 預設值給予
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: none
# Return.........: none 
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_preprocess()
 
    
    WHENEVER ERROR CONTINUE
 
    #FUN-C60080 start
    CALL aws_ttsrv_conn_ds()   #FUN-C70031
    #FUN-C60080 end

    #--------------------------------------------------------------------------#
    # 初始 g_status 變數                                                       #
    #--------------------------------------------------------------------------#
    LET g_status.code = "0"
    LET g_status.sqlcode = "0"
    LET g_status.description = ""
 
    #FUN-CB0024 add str---
    #--------------------------------------------------------------------------#
    # 初始 ERP 全域變數                                                        #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'
    LET g_totsuccess = 'Y'
    LET g_errno = NULL
    #FUN-D10121 add str---
    LET g_lang = 0
    LET g_today = TODAY
    LET g_showmsg = ""
    CALL g_err_msg.clear()
    INITIALIZE g_xml TO NULL
    #FUN-D10121 add end---

    #FUN-CB0024 add end---
   
    #--------------------------------------------------------------------------#
    # 建立 Response XML Root                                                   #
    #--------------------------------------------------------------------------#
    LET g_response.response = NULL
    LET g_response_root = NULL   
    CALL aws_ttsrv_createResponse()
 
    CALL aws_ttsrv_writeRequestLog()   #紀錄 Request XML
 
    #--------------------------------------------------------------------------#
    # 轉換 Request XML String 為 Request Dom Document                          #
    # 檢查是否為合法的 XML                                                     #
    #--------------------------------------------------------------------------#
    LET g_request_root = aws_ttsrv_stringToXml(g_request.request)
    IF g_request_root IS NULL THEN
       DISPLAY "Request isn't valid XML document!"
       LET g_status.code = "-1"
       LET g_status.description = "Request isn't valid XML document!"
       RETURN
    END IF
  
    #--------------------------------------------------------------------------#
    # 檢查是否有指定 g_service 變數                                            #
    #--------------------------------------------------------------------------#    
    IF cl_null(g_service) THEN                       
       DISPLAY "No Service Name specified!"
       LET g_status.code = "-1"
       LET g_status.description = "No Service Name specified!"
       RETURN
    END IF
 
    #--------------------------------------------------------------------------#
    # 檢查存取資訊                                                             #
    #--------------------------------------------------------------------------#   
    IF NOT aws_ttsrv_checkAccess() THEN
       DISPLAY "Access validate fail!"
       LET g_status.code = "-1"
       LET g_status.description = "Access validate fail!"
       RETURN
    END IF
 
    #----------------------------------------------------------------------#
    # 由傳入的 XML 資料中讀取他系統欄位與欄位值                            #
    #----------------------------------------------------------------------#
    LET g_request_root = aws_ttsrv_parseDataSetRecrodField(g_request_root)
      
    
    #--------------------------------------------------------------------------#
    # 抓取對應資料庫 aza.* 資料, 單據編號格式設定(for 自動取號功能)            #
    #--------------------------------------------------------------------------#
    SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
    IF SQLCA.SQLCODE THEN
       DISPLAY "Select Parameter file of aza_file Error!"
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET g_status.description = "Select Parameter file of aza_file Error!"
       RETURN
    END IF
    CASE g_aza.aza41
       WHEN "1"   LET g_doc_len = 3
                  LET g_no_sp = 3 + 2
       WHEN "2"   LET g_doc_len = 4
                  LET g_no_sp = 4 + 2
       WHEN "3"   LET g_doc_len = 5
                  LET g_no_sp = 5 + 2
    END CASE
    CASE g_aza.aza42
       WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
       WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
       WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
    END CASE
 
 
    #--------------------------------------------------------------------------#
    # 需指定 TPGateWay 環境變數.                                               #
    # 當 cl_cmdrun() 執行另一程式時，才能相同資料庫、背景執行,及取得錯誤訊息   #
    #--------------------------------------------------------------------------#
    CALL FGL_SETENV("TPGateWay","1")
    CALL FGL_SETENV("DB",g_dbs)
    LET mi_tpgateway_trigger = "1"
 
    #--FUN-930132--start--
    #--------------------------------------------------------------------------#
    # 抓取對應資料庫 sma.* 資料, for取得行業別設定                             #
    #--------------------------------------------------------------------------#
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00 = '0'
    IF SQLCA.SQLCODE THEN
       DISPLAY "Select Parameter file of sma_file Error!"
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET g_status.description = "Select Parameter file of sma_file Error!"
       RETURN
    END IF
    #--FUN-930132--end--

    #FUN-A90024 ---start
    #因為後續services 中會call cl_query_prt_getlength()
    #所以需先在這裡create temptable
    CALL cl_query_prt_temptable() 
    #FUN-A90024 ---end 
END FUNCTION
 
 
#[
# Description....: 處理服務後置設定
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: none
# Return.........: none 
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_postprocess()
 
             
    CALL aws_ttsrv_setStatus()                                         #依據 g_status RECORD 內容設定狀態值
    
    LET g_response.response = aws_ttsrv_xmlToString(g_response_root)   #轉換 Response Dom Document 為 XML String
 
    CALL aws_ttsrv_writeResponseLog()                                  #紀錄 Response XML

END FUNCTION
 
#FUN-C70031 start
#[
# Description....: 處理服務前連線 database
# Date & Author..: 2012/07/03 by Kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_conn_ds()

    WHENEVER ERROR CONTINUE

    #IF g_conn_ds="Y" THEN           #FUN-CB0142
    #   RETURN
    #ELSE
       TRY
          CALL cl_ins_del_sid(2,'')  #FUN-CB0142
          CLOSE DATABASE             #FUN-CB0142

          DATABASE ds
          CALL cl_ins_del_sid(1,'')
          LET g_conn_ds="Y"
       CATCH
          DISPLAY "Connect to ds failed,",SQLERRMESSAGE  #FUN-I20005 
          #FUN-I20005 add start
          DATABASE ds 
          CALL cl_ins_del_sid(1,'')
          IF SQLCA.SQLCODE THEN
             DISPLAY "ReConnect to ds failed,",SQLERRMESSAGE
          ELSE
             DISPLAY "ReConnect to ds Success"
             LET g_conn_ds="Y" 
          END IF
          #FUN-I20005 add end
       END TRY
    #END IF                          #FUN-CB0142
END FUNCTION
#FUN-C70031 end
