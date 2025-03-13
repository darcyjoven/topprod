# Prog. Version..: '5.30.06-13.03.12(00005)'     #
 
# Program name...: cl_ppcli.4gl
# Descriptions...: 代辦事項與鼎新 Product Portal 整合(by Web Services)
# Date & Author..: 07/03/21 by Brendan
# Modify.........: No.FUN-6B0036 07/03/21 by Brendan 新建立
# Modify.........: No.TQC-710067 07/03/21 by Brendan 判斷正式區/測試區, 指定對應的程式呼叫 URL
# Modify.........: No.FUN-780042 07/08/17 by Brendan 新增標準區網址判斷
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-8A0096 08/10/29 by Vicky Production Portal整合-待辦事項
# Modify.........: NO.FUN-980097 09/08/21 By alex 合併wos至單一4gl
# Modify.........: No:FUN-B80118 11/09/26 By Jay TIPTOP 與 CROSS 整合功能: 透過 CROSS 平台串接 Portal 待辦事項  
# Modify.........: No:FUN-B90110 11/09/26 by Jay 修改Portal相關內容
 
IMPORT com
IMPORT os
DATABASE ds
 
#-- No.FUN-6B0036 新建立 -------------------------------------------------------
 
GLOBALS "../../config/top.global"     #FUN-7C0053
GLOBALS "../../aws/4gl/aws_ppgw.inc"
GLOBALS "../../aws/4gl/aws_ppgw2.inc"   #FUN-8A0096  add
GLOBALS "../../aws/4gl/aws_crossgw.inc" #FUN-B80118
 
DEFINE gn_response   om.DomNode
DEFINE g_wap         RECORD LIKE wap_file.*         #FUN-B80118
 
 
# Descriptions...: ERP 代辦事項拋轉至 Product Portal
# Date & Author..: 2006/11/10 by Brendan
# Input Parameter: pr_gah RECORD   代辦事項 data record
# Return code....: void
# Memo...........: 檢查 aoos010 - aza67 是否設定與 Product Portal 整合
 
 
FUNCTION cl_ppcli_createToDoList(pr_gah)
    DEFINE pr_gah                    RECORD LIKE gah_file.*
    DEFINE ls_XMLData                STRING,
           ls_primarykey             STRING,
           ls_priority               STRING,
           ls_assignto               STRING,
           ls_owner                  STRING,
           ls_url                    STRING,
           ls_para                   STRING,
           ls_CreateToDoListResult   STRING,
           li_status                 INTEGER,
           lch_pipe                  base.Channel,
           ls_message                STRING,
           ls_content                STRING
   DEFINE  ls_topdir                 STRING   #TQC-710067
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    #---------------------------------------------------------------------------
    # 檢查整體系統參數是否設定與 Production Portal 整合
    #---------------------------------------------------------------------------
    IF g_aza.aza67 != 'Y' OR cl_null(g_aza.aza67) THEN
       RETURN
    END IF
 
    #--FUN-8A0096--start-----
    #---------------------------------------------------------------------------
    # 檢查整體系統參數設定aza91是否為"D":DSC Portal
    #---------------------------------------------------------------------------
    IF g_aza.aza91 = 'D' THEN
       CALL cl_ppcli_sendMessageToPortal(pr_gah.*)
       RETURN
    END IF
    #--FUN-8A0096--end-----
 
    #---------------------------------------------------------------------------
    # 指定一組 KEY, 提供為 ERP 呼叫 Product Portal 處理結案時依據
    # * 呼叫結案 function 時提供此 KEY
    #---------------------------------------------------------------------------
    LET ls_primarykey = pr_gah.gah01 CLIPPED, "|", g_plant CLIPPED
 
    #---------------------------------------------------------------------------
    # 指定對應至 Production Portal '代辦事項' 的緊急度 (0:高 1:中 2:低)
    #---------------------------------------------------------------------------
    CASE pr_gah.gah04
         WHEN 'A'   LET ls_priority = '0'
         WHEN 'B'   LET ls_priority = '1'
         WHEN 'C'   LET ls_priority = '2'
         OTHERWISE  LET ls_priority = '2'
    END CASE
 
    #---------------------------------------------------------------------------
    # 抓取交辦人 email adress list
    #---------------------------------------------------------------------------
    LET ls_owner = cl_ppcli_getMailAddress(g_user)
 
    #---------------------------------------------------------------------------
    # 抓取指定人 email adress list
    #---------------------------------------------------------------------------
    LET ls_assignto = cl_ppcli_getMailAddress(pr_gah.gah02 CLIPPED)
 
    #---------------------------------------------------------------------------
    # 設定代辦事項訊息內容
    # 除原本 p_flow 設定的訊息內容外, 傳送至 Product Portal 的訊息本文再加上: 建立日期, 處理時限, 單據編號以及工廠代號
    #---------------------------------------------------------------------------
    LET ls_content = pr_gah.gah06 CLIPPED,
                     " [ ", cl_getmsg("aws-095", g_lang) CLIPPED, " ]"    #FUN-8A0096  aws-096改為aws-095
    LET ls_content = SFMT(ls_content, pr_gah.gah05 CLIPPED, g_plant CLIPPED, pr_gah.gah03 USING "YYYYMMDD", pr_gah.gah08 USING "YYYYMMDD")
 
    #---------------------------------------------------------------------------
    # 設定 Product Portal 代辦事項啟動程式時呼叫 URL
    # 格式為: http://server_ip/cgi-bin/fglccgi/wa/r/gdc-tiptop-aws_pprun
    #---------------------------------------------------------------------------
    LET lch_pipe = base.Channel.create()
    CALL lch_pipe.openPipe("grep `hostname` /etc/hosts | cut -f1", "r")
    CALL lch_pipe.read(ls_url) RETURNING li_status
    CALL lch_pipe.close()
    #--No.TQC-710067 begin-------------------------------------------------------
    # 判斷 ERP 正式區/測試區, 以指定正確的執行程式 URL
    #   1.若 $TOP 路徑包含 topprod 則為正式區
    #   2.若 $TOP 路徑包含 toptest 則為測試區
    #   3.若 $TOP 路徑包含 topstd  則為標準區  FUN-780042
    #---------------------------------------------------------------------------
    LET ls_topdir = FGL_GETENV("TOP")
    CASE 
        WHEN ls_topdir.getIndexOf("/topprod/", 1) > 0
             LET ls_url = "http://", ls_url, "/cgi-bin/fglccgi/wa/r/gdc-tiptop-aws_pprun"
        WHEN ls_topdir.getIndexOf("/toptest/", 1) > 0
             LET ls_url = "http://", ls_url, "/cgi-bin/fglccgi/wa/r/gdc-toptest-aws_pprun"
        #-- No.FUN-780042 BEGIN -----------------------------------------------#
        WHEN ls_topdir.getIndexOf("/topstd/", 1) > 0
             LET ls_url = "http://", ls_url, "/cgi-bin/fglccgi/wa/r/gdc-topstd-aws_pprun"
        #-- No.FUN-780042 END -------------------------------------------------#
        OTHERWISE
             LET ls_url = "http://", ls_url, "/cgi-bin/fglccgi/wa/r/gdc-tiptop-aws_pprun"
    END CASE
    #--No.TQC-710067 end--------------------------------------------------------
 
    #---------------------------------------------------------------------------
    # 設定 Product Portal 代辦事項啟動程式時傳入參數
    # Arg1 : ERP 代辦事項編號(更新狀態值使用)
    # Arg2 : 執行程式代號
    # Arg3 : 單據編號 (***目前僅適用於一個 KEY value 的作業程式)
    # Arg4 : 執行動作
    # Arg5 : 工廠別
    # Arg6 : SOK (固定字串, Product Portal 會以真實的 SOK string 取代)
    #---------------------------------------------------------------------------
    LET ls_para = "?Arg=", pr_gah.gah01 CLIPPED,
                  "&Arg=", pr_gah.gah07 CLIPPED, 
                  "&Arg=", pr_gah.gah05 CLIPPED,
                  "&Arg=", pr_gah.gah11 CLIPPED,
                  "&Arg=", g_plant CLIPPED,
                  "&Arg=SOK"
 
    CALL cl_ppcli_log("CALL CreateToDoList()", "Action")
 
    #---------------------------------------------------------------------------
    # "CreateToDoList" XML
    # <Priority>      : 緊急度
    # <AssignTo>      : 指派人員
    # <Owner>         : 交辦人員
    # <Content>       : 內容說明
    # <OpenCaseDate>  : 接案日
    # <CloseCaseDate> : 預計完成日
    # <Time>          : 時數
    # <CaseState>     : 結案狀態
    # <URL>           : 啟動位址
    # <Parameters>    : 參數
    # <URLType>       : 類型
    #---------------------------------------------------------------------------
    LET ls_XMLData = "<ParameterList>\n",
                     "  <PrimaryKey>", ls_primarykey, "</PrimaryKey>\n",
                     "  <Priority>", ls_priority, "</Priority>\n",
                     "  <AssignTo>", ls_assignto, "</AssignTo>\n",
                     "  <Owner>", ls_owner, "</Owner>\n",
                     "  <Content>", ls_content, "</Content>\n",
                     "  <OpenCaseDate>", g_today USING 'YYYYMMDD', "</OpenCaseDate>\n",
                     "  <CloseCaseDate>", pr_gah.gah08 USING 'YYYYMMDD', "</CloseCaseDate>\n",
                     "  <Time></Time>\n",
                     "  <CaseState>0</CaseState>\n",
                     "  <URL>", ls_url, "</URL>\n",
                     "  <Parameters>", ls_para, "</Parameters>\n",
                     "  <URLType>Web</URLType>\n",
                     "</ParameterList>"
 
    #---------------------------------------------------------------------------
    # 寫入 Request XML log(from TIPTOP side)
    #--------------------------------------------------------------------------- 
    CALL cl_ppcli_log(ls_XMLData, "Request")
 
    #---------------------------------------------------------------------------
    # 指定 SOAP URL
    #---------------------------------------------------------------------------
    LET ProductPortal_soapServerLocation = g_aza.aza68
    #---------------------------------------------------------------------------
    # 若 60 秒內無回應則放棄連接
    #---------------------------------------------------------------------------
    CALL fgl_ws_setOption("http_invoketimeout", 60)   #FUN-8A0096 10秒改為60秒
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal CreateToDoList function
    #---------------------------------------------------------------------------
    CALL ProductPortal_CreateToDoList(ls_XMLData)
         RETURNING li_status, ls_CreateToDoListResult
 
    #---------------------------------------------------------------------------
    # 寫入 Response XML log(from Product Portal side)
    #--------------------------------------------------------------------------- 
    CALL cl_ppcli_log(ls_CreateToDoListResult, "Response")
 
    #---------------------------------------------------------------------------
    # 解析 Product Portal 回傳 XML, 取得 root node
    #---------------------------------------------------------------------------
    CALL cl_ppcli_processResponse(ls_CreateToDoListResult)
 
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal 後回覆結果處理
    #---------------------------------------------------------------------------
    CASE
        #-----------------------------------------------------------------------
        # 正確呼叫 Product Portal 且回傳正確 XML
        #-----------------------------------------------------------------------
        WHEN li_status = 0 AND gn_response IS NOT NULL
             IF cl_ppcli_getTagValue("ReturnValue") = "1" THEN
                LET ls_message = "Call CreateToDoList() successfully:\n",
                                 "    returnMsg: ", cl_ppcli_getTagValue("ReturnMsg")
             ELSE
                LET ls_message = "Call CreateToDoList() unsuccessfully:\n",
                                 "    returnMsg: ", cl_ppcli_getTagValue("ReturnMsg")
             END IF
 
        #-----------------------------------------------------------------------
        # 正確呼叫 Product Portal 但回傳 XML 有問題
        #-----------------------------------------------------------------------
        WHEN li_status = 0 AND gn_response IS NULL
             LET ls_message = "Response error:\n",
                              "    returning XML isn't well-formated"
 
        #-----------------------------------------------------------------------
        # 無法呼叫 Product Portal
        #-----------------------------------------------------------------------
        WHEN li_status <> 0 
             LET ls_message = "Connection failed:\n", 
                              "    code       : ", wserror.code, "\n",
                              "    action     : ", wserror.action, "\n",
                              "    description: ", wserror.description
    END CASE
 
    CALL cl_ppcli_log(ls_message, "Status")
END FUNCTION
 
 
 
# Descriptions...: Product Portal 透過 Web 執行程式時, ERP 呼叫檢驗 SOK key 是否合法
# Date & Author..: 2006/11/22 by Brendan
# Input Parameter: ps_sok  STRING   SOK 字串
# Return code....: ls_zx01 STRING   ERP 使用者代號
 
 
FUNCTION cl_ppcli_VerifySOK(ps_sok)
    DEFINE ps_sok               STRING
    DEFINE ls_XMLData           STRING,
           ls_VerifySOKResult   STRING,
           li_status            INTEGER,
           ls_message           STRING,
           ls_zx01              LIKE zx_file.zx01,
           ls_zx09              LIKE zx_file.zx09
 
 
    INITIALIZE ls_zx01 TO NULL
 
    CALL cl_ppcli_log("CALL VerifySOK()", "Action")
 
    #---------------------------------------------------------------------------
    # "VerifySOK" XML
    #---------------------------------------------------------------------------
    LET ls_XMLData = "<ParameterList>\n",
                     "  <SOK>", ps_sok, "</SOK>\n",
                     "</ParameterList>"
 
    #---------------------------------------------------------------------------
    # 寫入 Request XML log(from TIPTOP side)
    #--------------------------------------------------------------------------- 
    CALL cl_ppcli_log(ls_XMLData, "Request")
 
    #---------------------------------------------------------------------------
    # 指定 SOAP URL
    #---------------------------------------------------------------------------
    LET ProductPortal_soapServerLocation = g_aza.aza68
    #---------------------------------------------------------------------------
    # 若 10 秒內無回應則放棄連接
    #---------------------------------------------------------------------------
    CALL fgl_ws_setOption("http_invoketimeout", 10)
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal CreateToDoList function
    #---------------------------------------------------------------------------
    CALL ProductPortal_VerifySOK(ls_XMLData)
         RETURNING li_status, ls_VerifySOKResult
 
    #---------------------------------------------------------------------------
    # 寫入 Response XML log(from Product Portal side)
    #--------------------------------------------------------------------------- 
    CALL cl_ppcli_log(ls_VerifySOKResult, "Response")
 
    #---------------------------------------------------------------------------
    # 解析 Product Portal 回傳 XML, 取得 root node
    #---------------------------------------------------------------------------
    CALL cl_ppcli_processResponse(ls_VerifySOKResult)
 
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal 後回覆結果處理
    #---------------------------------------------------------------------------
    CASE
        #-----------------------------------------------------------------------
        # 正確呼叫 Product Portal 且回傳正確 XML
        #-----------------------------------------------------------------------
        WHEN li_status = 0 AND gn_response IS NOT NULL
             IF cl_ppcli_getTagValue("ReturnValue") = "1" THEN
                #------------------------------------------------------------------
                # 由 Product Portal 回傳 email 取出使用者帳號
                #------------------------------------------------------------------
                LET ls_zx09 = cl_ppcli_getTagValue("UserEmail")
                SELECT zx01 INTO ls_zx01 FROM zx_file WHERE zx09 = ls_zx09
                IF SQLCA.SQLCODE OR cl_null(ls_zx01) THEN
                   LET ls_zx01 = NULL
                END IF
                IF cl_null(ls_zx01) THEN
                   LET ls_message = "Verify ERP account unsuccessfully:\n",
                                    "    SQLCODE  : ", SQLCA.SQLCODE, "\n",
                                    "    userId   : ", ls_zx01, "\n",
                                    "    userEmail: ", ls_zx09
                ELSE
                   LET ls_message = "Call VerifySOK() successfully:\n",
                                    "    returnMsg: ", cl_ppcli_getTagValue("ReturnMsg"), "\n",
                                    "    userId   : ", ls_zx01, "\n",
                                    "    userEmail: ", ls_zx09
                END IF
             ELSE
                LET ls_message = "Call VerifySOK() unsuccessfully:\n",
                                 "    returnMsg: ", cl_ppcli_getTagValue("ReturnMsg")
             END IF
 
        #-----------------------------------------------------------------------
        # 正確呼叫 Product Portal 但回傳 XML 有問題
        #-----------------------------------------------------------------------
        WHEN li_status = 0 AND gn_response IS NULL
             LET ls_message = "Response error:\n",
                              "    returning XML isn't well-formated"
 
        #-----------------------------------------------------------------------
        # 無法呼叫 Product Portal
        #-----------------------------------------------------------------------
        WHEN li_status <> 0 
             LET ls_message = "Connection failed:\n", 
                              "    code       : ", wserror.code, "\n",
                              "    action     : ", wserror.action, "\n",
                              "    description: ", wserror.description
    END CASE
    
    CALL cl_ppcli_log(ls_message, "Status")
 
    RETURN ls_zx01
END FUNCTION
 
 
# Descriptions...: ERP 呼叫 Product Portal 完成代辦事項結案動作
# Date & Author..: 2006/12/04 by Brendan
# Input Parameter: ps_key  STRING   Primary Key
# Return code....: none
 
 
FUNCTION cl_ppcli_CloseToDoList(ps_key)
    DEFINE ps_key                   STRING
    DEFINE ls_XMLData               STRING,
           ls_CloseToDoListResult   STRING,
           ls_primarykey            STRING,
           ls_message               STRING,
           li_status                INTEGER
 
 
    #---------------------------------------------------------------------------
    # 檢查整體系統參數是否設定與 Production Portal 整合
    #---------------------------------------------------------------------------
    IF g_aza.aza67 != 'Y' OR cl_null(g_aza.aza67) THEN
       RETURN
    END IF
 
    #--FUN-8A0096--start-----
    #---------------------------------------------------------------------------
    # 檢查Key值是否為空
    #---------------------------------------------------------------------------
    IF cl_null(ps_key) THEN
       RETURN
    END IF
 
    #---------------------------------------------------------------------------
    # 檢查整體系統參數設定aza91是否為"D":DSC Portal
    #---------------------------------------------------------------------------
    IF g_aza.aza91 = 'D' THEN
       CALL cl_ppcli_SignatureComplete(ps_key)
       RETURN
    END IF
    #--FUN-8A0096--end----
 
    CALL cl_ppcli_log("CALL CloseToDoList()", "Action")
 
    #---------------------------------------------------------------------------
    # 結案所需的 Primary Key
    #---------------------------------------------------------------------------
    LET ls_primarykey = ps_key CLIPPED, "|", g_plant CLIPPED
 
    #---------------------------------------------------------------------------
    # "CloseToDoList" XML
    #---------------------------------------------------------------------------
    LET ls_XMLData = "<ParameterList>\n",
                     "  <PrimaryKey>", ls_primarykey, "</PrimaryKey>\n",
                     "  <FinishedDate>", TODAY USING "YYYYMMDD", "</FinishedDate>\n",
                     "  <FinishedContent>OK</FinishedContent>\n",
                     "</ParameterList>"
 
    #---------------------------------------------------------------------------
    # 寫入 Request XML log(from TIPTOP side)
    #--------------------------------------------------------------------------- 
    CALL cl_ppcli_log(ls_XMLData, "Request")
 
    #---------------------------------------------------------------------------
    # 指定 SOAP URL
    #---------------------------------------------------------------------------
    LET ProductPortal_soapServerLocation = g_aza.aza68
    #---------------------------------------------------------------------------
    # 若 60 秒內無回應則放棄連接
    #---------------------------------------------------------------------------
    CALL fgl_ws_setOption("http_invoketimeout", 60)    #FUN-8A0096 10秒改為60秒
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal CloseToDoList function
    #---------------------------------------------------------------------------
    CALL ProductPortal_CloseToDoList(ls_XMLData)
         RETURNING li_status, ls_CloseToDoListResult
 
    #---------------------------------------------------------------------------
    # 寫入 Response XML log(from Product Portal side)
    #--------------------------------------------------------------------------- 
    CALL cl_ppcli_log(ls_CloseToDoListResult, "Response")
 
    #---------------------------------------------------------------------------
    # 解析 Product Portal 回傳 XML, 取得 root node
    #---------------------------------------------------------------------------
    CALL cl_ppcli_processResponse(ls_CloseToDoListResult)
 
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal 後回覆結果處理
    #---------------------------------------------------------------------------
    CASE
        #-----------------------------------------------------------------------
        # 正確呼叫 Product Portal 且回傳正確 XML
        #-----------------------------------------------------------------------
        WHEN li_status = 0 AND gn_response IS NOT NULL
             IF cl_ppcli_getTagValue("ReturnValue") = "1" THEN
                LET ls_message = "Call CloseToDoList() successfully:\n",
                                 "    returnMsg: ", cl_ppcli_getTagValue("ReturnMsg")
             ELSE
                LET ls_message = "Call CloseToDoList() unsuccessfully:\n",
                                 "    returnMsg: ", cl_ppcli_getTagValue("ReturnMsg")
             END IF
 
        #-----------------------------------------------------------------------
        # 正確呼叫 Product Portal 但回傳 XML 有問題
        #-----------------------------------------------------------------------
        WHEN li_status = 0 AND gn_response IS NULL
             LET ls_message = "Response error:\n",
                              "    returning XML isn't well-formated"
 
        #-----------------------------------------------------------------------
        # 無法呼叫 Product Portal
        #-----------------------------------------------------------------------
        WHEN li_status <> 0 
             LET ls_message = "Connection failed:\n", 
                              "    code       : ", wserror.code, "\n",
                              "    action     : ", wserror.action, "\n",
                              "    description: ", wserror.description
    END CASE
    
    CALL cl_ppcli_log(ls_message, "Status")
END FUNCTION
 
 
# Descriptions...: ERP 呼叫 Product Portal 新增一筆公佈欄訊息
# Date & Author..: 2006/12/11 by Brendan
# Input Parameter: ps_key      STRING   單號
#                : ps_title    STRING   主旨
#                : pd_announce DATE     生效日
#                : pd_expire   DATE     失效日
#                : ps_content  STRING   內容
# Return code....: none
 
 
FUNCTION cl_ppcli_CreateBulletin(ps_key, ps_title, pd_announce, pd_expire, ps_content)
    DEFINE ps_key                    STRING,
           ps_title                  STRING,
           pd_announce               DATE,
           pd_expire                 DATE,
           ps_content                STRING
    DEFINE ls_XMLData                STRING,
           ls_CreateBulletinResult   STRING,
           ls_primarykey             STRING,
           ls_creator                STRING,
           ls_message                STRING,
           li_status                 INTEGER
 
 
    #---------------------------------------------------------------------------
    # 檢查整體系統參數是否設定與 Production Portal 整合
    #---------------------------------------------------------------------------
    IF g_aza.aza67 != 'Y' OR cl_null(g_aza.aza67) THEN
       RETURN
    END IF
 
    CALL cl_ppcli_log("CALL CreateBulletin()", "Action")
 
    #---------------------------------------------------------------------------
    # Product Portal 需要的辨識碼(目前以 '單號' + '工廠別' 帶過去)
    #---------------------------------------------------------------------------
    LET ls_primarykey = ps_key CLIPPED, "|", g_plant CLIPPED
 
    #---------------------------------------------------------------------------
    # 抓取建立者 email adress list(目前預設以 g_user 帶過去)
    #---------------------------------------------------------------------------
    LET ls_creator = cl_ppcli_getMailAddress(g_user)
 
    #---------------------------------------------------------------------------
    # "CreateBulletin" XML
    #---------------------------------------------------------------------------
    LET ls_XMLData = "<ParameterList>\n",
                     "  <PrimaryKey>", ls_primarykey, "</PrimaryKey>\n",
                     "  <BulletinTitle>", ps_title CLIPPED, "</BulletinTitle>\n",
                     "  <Creator>", ls_creator, "</Creator>\n",
                     "  <AnnounceDate>", pd_announce USING "YYYYMMDD", "</AnnounceDate>\n",
                     "  <ExpireDate>", pd_expire USING "YYYYMMDD", "</ExpireDate>\n",
                     "  <Content>", ps_content CLIPPED, "</Content>\n",
                     "</ParameterList>"
 
    #---------------------------------------------------------------------------
    # 寫入 Request XML log(from TIPTOP side)
    #--------------------------------------------------------------------------- 
    CALL cl_ppcli_log(ls_XMLData, "Request")
 
    #---------------------------------------------------------------------------
    # 指定 SOAP URL
    #---------------------------------------------------------------------------
    LET ProductPortal_soapServerLocation = g_aza.aza68
    #---------------------------------------------------------------------------
    # 若 10 秒內無回應則放棄連接
    #---------------------------------------------------------------------------
    CALL fgl_ws_setOption("http_invoketimeout", 10)
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal CloseToDoList function
    #---------------------------------------------------------------------------
    CALL ProductPortal_CreateBulletin(ls_XMLData)
         RETURNING li_status, ls_CreateBulletinResult
 
    #---------------------------------------------------------------------------
    # 寫入 Response XML log(from Product Portal side)
    #--------------------------------------------------------------------------- 
    CALL cl_ppcli_log(ls_CreateBulletinResult, "Response")
 
    #---------------------------------------------------------------------------
    # 解析 Product Portal 回傳 XML, 取得 root node
    #---------------------------------------------------------------------------
    CALL cl_ppcli_processResponse(ls_CreateBulletinResult)
 
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal 後回覆結果處理
    #---------------------------------------------------------------------------
    CASE
        #-----------------------------------------------------------------------
        # 正確呼叫 Product Portal 且回傳正確 XML
        #-----------------------------------------------------------------------
        WHEN li_status = 0 AND gn_response IS NOT NULL
             IF cl_ppcli_getTagValue("ReturnValue") = "1" THEN
                LET ls_message = "Call CreateBulletin() successfully:\n",
                                 "    returnMsg: ", cl_ppcli_getTagValue("ReturnMsg")
             ELSE
                LET ls_message = "Call CreateBulletin() unsuccessfully:\n",
                                 "    returnMsg: ", cl_ppcli_getTagValue("ReturnMsg")
             END IF
 
        #-----------------------------------------------------------------------
        # 正確呼叫 Product Portal 但回傳 XML 有問題
        #-----------------------------------------------------------------------
        WHEN li_status = 0 AND gn_response IS NULL
             LET ls_message = "Response error:\n",
                              "    returning XML isn't well-formated"
 
        #-----------------------------------------------------------------------
        # 無法呼叫 Product Portal
        #-----------------------------------------------------------------------
        WHEN li_status <> 0 
             LET ls_message = "Connection failed:\n", 
                              "    code       : ", wserror.code, "\n",
                              "    action     : ", wserror.action, "\n",
                              "    description: ", wserror.description
    END CASE
    
    CALL cl_ppcli_log(ls_message, "Status")
END FUNCTION
 
 
 
# Descriptions...: 處理 Product Portal 回傳的 XML document, 抓取 Root Node 以利後續 parse XML 時使用
# Date & Author..: 2006/11/21 by Brendan
# Input Parameter: ps_xml STRING   XML string
# Return code....: none
 
 
FUNCTION cl_ppcli_processResponse(ps_xml)
    DEFINE ps_xml     STRING
    DEFINE lch_file   base.Channel,
           ls_file    STRING,
           ln_doc     om.DomDocument
 
 
    #---------------------------------------------------------------------------
    # 產生一 XML temp file
    #---------------------------------------------------------------------------
    LET ls_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
    LET lch_file = base.Channel.create()
    CALL lch_file.setDelimiter(NULL)
    CALL lch_file.openFile(ls_file, "w")
    CALL lch_file.write(ps_xml)
    CALL lch_file.close()
 
    #---------------------------------------------------------------------------
    # 讀取 XML temp file 後判斷是否為合法的 XML document
    #---------------------------------------------------------------------------
    LET ln_doc = om.DomDocument.createFromXmlFile(ls_file)
 
#   RUN "rm -f " || ls_file || " >/dev/null 2>&1"
    IF os.Path.delete(ls_file) THEN         #FUN-980097                
    END IF
 
    IF ln_doc IS NULL THEN
       LET gn_response = NULL
    ELSE
       LET gn_response = ln_doc.getDocumentElement()
    END IF
END FUNCTION
 
 
 
# Descriptions...: 回傳 Response XML document 中, 指定 tag name 所包含的值  
# Date & Author..: 2006/11/21 by Brendan
# Input Parameter: ps_tag   STRING   XML tag name
# Return code....: ls_value STRING   Value of XML tag
 
 
FUNCTION cl_ppcli_getTagValue(ps_tag)
    DEFINE ps_tag     STRING
    DEFINE lst_list   om.NodeList,
           ln_node    om.DomNode
 
 
    LET lst_list = gn_response.selectByTagName(ps_tag)
    LET ln_node = lst_list.item(1)
    IF ln_node IS NULL THEN
       RETURN NULL
    ELSE
       #------------------------------------------------------------------------
       # 若欲抓取 <Tag>text</Tag> 中的文字 --- text, 
       # 則 text 為 <Tag> 的 child node,
       # 故得到 FirstChild 後(text node), 以 "@chars" attribute name 存取真正的文字內容
       #------------------------------------------------------------------------
       LET ln_node = ln_node.getFirstChild()
       IF ln_node IS NULL THEN
          RETURN NULL
       END IF
       RETURN ln_node.getAttribute("@chars")
    END IF
END FUNCTION
 
 
 
# Descriptions...: 由傳入使用者帳號(可多組, 以 ; 區隔), 抓取 email address list
# Date & Author..: 2006/11/13 by Brendan
# Input Parameter: ps_account STRING   使用者帳號
# Return code....: ls_email   STRING   使用者 email address
# Memo...........: First check zx_file(zx09), then check gen_file(gen06)
 
 
FUNCTION cl_ppcli_getMailAddress(ps_account)
    DEFINE ps_account   STRING,
           ls_email     STRING,
           ls_zx01      LIKE zx_file.zx01,
           ls_zx02      LIKE zx_file.zx02,
           ls_zx09      LIKE zx_file.zx09
    DEFINE lst_tok      base.StringTokenizer
 
 
    IF cl_null(ps_account) THEN
       RETURN NULL
    END IF
 
    #---------------------------------------------------------------------------
    # 傳入使用者帳號以 ; 分隔, 逐一解析後取得 email 列表資訊
    #---------------------------------------------------------------------------
    LET lst_tok = base.StringTokenizer.create(ps_account CLIPPED, ";")
    WHILE lst_tok.hasMoreTokens()
        LET ls_zx01 = lst_tok.nextToken()
 
        #-----------------------------------------------------------------------
        # 先抓取 zx_file - zx09, 若無 email 資料, 則續抓取 gen_file - gen06
        #-----------------------------------------------------------------------
        SELECT zx02, zx09 INTO ls_zx02, ls_zx09 FROM zx_file WHERE zx01 = ls_zx01
        IF SQLCA.SQLCODE OR cl_null(ls_zx09) THEN
           SELECT gen06 INTO ls_zx09 FROM gen_file WHERE gen01 = ls_zx01
        END IF
 
        IF cl_null(ls_zx02) THEN
           LET ls_zx02 = ls_zx01
        END IF
 
        #-----------------------------------------------------------------------
        # Production Portal email address 列表格式為: "email, email, ..."
        #-----------------------------------------------------------------------
        IF NOT cl_null(ls_email) THEN
           LET ls_email = ls_email, ","
        END IF
        #LET ls_email = ls_email, ls_zx02 CLIPPED, "(", ls_zx09 CLIPPED, ")"
        LET ls_email = ls_email, ls_zx09 CLIPPED
    END WHILE
 
    RETURN ls_email
END FUNCTION
 
 
# Descriptions...: 紀錄整合溝通交換的 Request / Response XML / 處理狀態
# Date & Author..: 2006/11/15 by Brendan
# Input Parameter: ps_log  STRING   XML 字串
#                : ps_type STRING   傳入型態: Action / Request / Response / Status
# Return code....: none
 
 
FUNCTION cl_ppcli_log(ps_log, ps_type)
    DEFINE ps_log     STRING,
           ps_type    STRING
    DEFINE lch_file   base.Channel,
           ls_file    STRING,
           ls_str     STRING,
           ls_cmd     STRING
 
 
    #---------------------------------------------------------------------------
    # 紀錄 Request / Response XML, Log File 格式為: aws_ppcli-yyyymmdd.log
    #---------------------------------------------------------------------------
    LET lch_file = base.Channel.create()
    CALL lch_file.setDelimiter(NULL)
    LET ls_file = "aws_ppcli-", TODAY USING 'YYYYMMDD', ".log"
    CALL lch_file.openFile(ls_file, "a")
 
    IF STATUS = 0 THEN
       IF ps_type = "Action" THEN
          LET ls_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
          CALL lch_file.write(ls_str)
          CALL lch_file.write("")
          CALL lch_file.write("Product Portal SOAP: " || g_aza.aza68)
          CALL lch_file.write("")
       END IF
 
       CALL lch_file.write("*** [" || ps_type || "] ***")
       CALL lch_file.write(ps_log)
       CALL lch_file.write("")
 
       IF ps_type = "Status" THEN
          CALL lch_file.write("#------------------------------------------------------------------------------#")
          CALL lch_file.write("")
          CALL lch_file.write("")
       END IF
 
#      LET ls_cmd = "chmod 666 ", ls_file, " >/dev/null 2>&1"
#      RUN ls_cmd
       IF os.Path.separator() = "/" THEN             #FUN-980097
          IF os.Path.chrwx(ls_file,438) THEN
          END IF
       END IF
 
    ELSE
       DISPLAY "Can't open log file: " || ls_file || " for writing."
    END IF
 
    CALL lch_file.close()
END FUNCTION
 
#--FUN-8A0096--start-----
# Descriptions...: ERP 待辦事項拋轉至 DSC Portal
# Input Parameter: pr_gah RECORD   待辦事項 data record
# Return code....: void
# Memo...........:
#
FUNCTION cl_ppcli_sendMessageToPortal(pr_gah)
    DEFINE pr_gah                    RECORD LIKE gah_file.*
    DEFINE ls_XMLData                STRING,
           ls_primarykey             STRING,
           ls_priority               STRING,
           ls_assignto               STRING,
           ls_owner                  STRING,
           ls_url                    STRING,
           ls_sendMessageToPortal    STRING,
           li_status                 INTEGER,
           ls_message                STRING,
           ls_content                STRING,
           ls_lang                   STRING
    DEFINE l_cross_status           LIKE type_file.num5    #FUN-B80118
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    #---------------------------------------------------------------------------
    # 指定一組 KEY, 提供為 ERP 呼叫 Product Portal 處理結案時依據
    # * 呼叫結案 function 時提供此 KEY
    #---------------------------------------------------------------------------
    LET ls_primarykey = pr_gah.gah01 CLIPPED, "|", g_plant CLIPPED
 
    #---------------------------------------------------------------------------
    # 指定對應至 Production Portal '待辦事項' 的緊急度 (0:高 1:中 2:低)
    #---------------------------------------------------------------------------
    CASE pr_gah.gah04
         WHEN 'A' OR 'B'  LET ls_priority = '0'
         WHEN 'C'         LET ls_priority = '1'
         WHEN 'D' OR 'E'  LET ls_priority = '2'
         OTHERWISE        LET ls_priority = '2'
    END CASE
 
    #---------------------------------------------------------------------------
    # 抓取交辦人 list (以逗號區隔)
    #---------------------------------------------------------------------------
    LET ls_owner = cl_replace_str(g_user CLIPPED,";",",")
 
    #---------------------------------------------------------------------------
    # 抓取指定人 list (以逗號區隔)
    #---------------------------------------------------------------------------
    LET ls_assignto = cl_replace_str(pr_gah.gah02 CLIPPED,";",",")
 
    #---------------------------------------------------------------------------
    # 設定代辦事項訊息內容
    # 除原本 p_flow 設定的訊息內容外, 傳送至 Product Portal 的訊息本文再加上: 建立日期, 處理時限, 單據編號以及工廠代號
    #---------------------------------------------------------------------------
    LET ls_content = pr_gah.gah06 CLIPPED,
                     " [ ", cl_getmsg("aws-095", g_lang) CLIPPED, " ]"
    LET ls_content = SFMT(ls_content, pr_gah.gah05 CLIPPED, g_plant CLIPPED, pr_gah.gah03 USING "YYYY/MM/DD", pr_gah.gah08 USING "YYYY/MM/DD")
 
    #---------------------------------------------------------------------------
    # 設定 Product Portal 待辦事項啟動程式時呼叫 URL
    # Arg1 : ToDoList (固定字串)
    # Arg2 : Primary Key
    # Arg3 : $SOK (固定字串, Product Portal 會以真實的 SOK string 取代)
    # Arg4 : 工廠別
    # Arg5 : 程式代號
    # Arg6 : 單據編號 (***目前僅適用於一個 KEY value 的作業程式)
    #---------------------------------------------------------------------------
    LET ls_url = "$TIPTOPMenuURL",
                 "?Arg=ToDoList",
                 "&amp;Arg=", pr_gah.gah01 CLIPPED,
                 "&amp;Arg=$SOK",
                 "&amp;Arg=", g_plant CLIPPED,
                 "&amp;Arg=", pr_gah.gah07 CLIPPED,
                 "&amp;Arg=", pr_gah.gah05 CLIPPED
 
    CALL cl_ppcli_log("CALL sendMessageToPortal()", "Action")
 
    #---------------------------------------------------------------------------
    # 訊息語言別轉換
    #---------------------------------------------------------------------------
    CASE g_lang
        WHEN "0"   LET ls_lang = "zh_tw"
        WHEN "1"   LET ls_lang = "en_us"
        WHEN "2"   LET ls_lang = "zh_cn"
        OTHERWISE  LET ls_lang = "en_us"
    END CASE
 
    #---------------------------------------------------------------------------
    # "sendMessageToPortal" XML
    # <Authentication> : user:帳號 ; password:密碼 ; 目前暫時不控管權限
    # <Connection>     : application:呼叫端系統代號 ; source:呼叫端來源IP or Host
    # <Organization>   : 此次呼叫指定存取的 ERP 營運中心代碼
    # <Locale language>: 訊息語系 ; 目前定義 zh_tw(繁體), zh_cn(簡體), en_us(英文)
    # <Key>            : Primary Key ; 提供為 ERP 呼叫 Product Portal 處理結案時依據
    # <Priority>       : 緊急度
    # <Sender>         : 傳送者
    # <Target>         : 接收者
    # <Content>        : 內容說明
    # <OpenCaseDate>   : 接案日
    # <CloseCaseDate>  : 預計完成日
    # <URL>            : 啟動位址
    #---------------------------------------------------------------------------
    LET ls_XMLData = "<Request>\n",
                     "  <Access>\n",
                     "    <Authentication user=\"tiptop\" password=\"\" />\n",
                     "    <Connection application=\"TIPTOP\" source=\"", cl_getClientIP() CLIPPED, "\" />\n",
                     "    <Organization name=\"", g_plant CLIPPED, "\" />\n",
                     "    <Locale language=\"", ls_lang, "\" />\n",
                     "  </Access>\n",
                     "  <RequestContent>\n",
                     "    <Parameter>\n",
                     "      <Record>\n",
                     "        <Field name=\"Key\" value=\"", ls_primarykey, "\" />\n",
                     "        <Field name=\"Priority\" value=\"", ls_priority, "\" />\n",
                     "        <Field name=\"Sender\" value=\"", ls_owner, "\" />\n",
                     "        <Field name=\"Target\" value=\"", ls_assignto, "\" />\n",
                     "        <Field name=\"Content\" value=\"", ls_content, "\" />\n",
                     "        <Field name=\"OpenCaseDate\" value=\"", g_today USING 'YYYY/MM/DD', "\" />\n",
                     "        <Field name=\"CloseCaseDate\" value=\"", pr_gah.gah08 USING 'YYYY/MM/DD', "\" />\n",
                     "        <Field name=\"URL\" value=\"", ls_url, "\" />\n",
                     "      </Record>\n",
                     "    </Parameter>\n",
                     "  </RequestContent>\n",
                     "</Request>"
 
    #---------------------------------------------------------------------------
    # 寫入 Request XML log(from TIPTOP side)
    #---------------------------------------------------------------------------
    CALL cl_ppcli_log(ls_XMLData, "Request")

    #No:FUN-B80118 -- start --
    #-------------------------------------------------------------------------------------#
    # TIPTOP 與 CROSS 整合: 透過 CROSS 平台呼叫 Portal                                       #
    #-------------------------------------------------------------------------------------#
    SELECT wap02 INTO g_wap.wap02 FROM wap_file
    IF g_wap.wap02 = 'Y' THEN  #使用CROSS整合平台
       #呼叫 CROSS 平台發出整合活動請求
       CALL cl_ppcli_sendRequestToCross("PORTAL", "sendMessageToPortal", "sync", ls_XMLData) 
            RETURNING l_cross_status, li_status, ls_sendMessageToPortal
    ELSE
    #No:FUN-B80118 -- end --
       #---------------------------------------------------------------------------
       # 指定 SOAP URL
       #---------------------------------------------------------------------------
       #LET ProductPortal_PortalWSImplService_PortalWSImplPortLocation = g_aza.aza68  #FUN-B90110 mark
       LET ProductPortal_PortalWSServiceSoapService_Portlet_PortalWS_PortalWSServiceLocation = g_aza.aza68  #FUN-B90110
 
       #---------------------------------------------------------------------------
       # 若 60 秒內無回應則放棄連接
       #---------------------------------------------------------------------------
       CALL fgl_ws_setOption("http_invoketimeout", 60)
 
       #---------------------------------------------------------------------------
       # 呼叫 Product Portal sendMessageToPortal Function
       #---------------------------------------------------------------------------
       #LET ProductPortal_sendMessageToPortal.arg0 = ls_XMLData  #FUN-B90110 mark
       LET ProductPortal_sendMessageToPortalRequest.pMessageXML = ls_XMLData  #FUN-B90110
       LET li_status = ProductPortal_sendMessageToPortal_g()
       #LET ls_sendMessageToPortal = ProductPortal_sendMessageToPortalResponse.return  #FUN-B90110 mark
       LET ls_sendMessageToPortal = ProductPortal_sendMessageToPortalResponse.sendMessageToPortalReturn   #FUN-B90110
    END IF   #FUN-B80118
        
    #---------------------------------------------------------------------------
    # 寫入 Response XML log(from Product Portal side)
    #---------------------------------------------------------------------------
    CALL cl_ppcli_log(ls_sendMessageToPortal, "Response")
 
    #---------------------------------------------------------------------------
    # 解析 Product Portal 回傳 XML, 取得 root node
    #---------------------------------------------------------------------------
    CALL cl_ppcli_processResponse(ls_sendMessageToPortal)
 
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal 後回覆結果處理
    #---------------------------------------------------------------------------
    CASE
       #------------------------------------------------------------------------
       # 正確呼叫 Product Portal 且回傳正確 XML
       #------------------------------------------------------------------------
       WHEN li_status = 0 AND gn_response IS NOT NULL
            IF cl_ppcli_getAttributeValue("Status","code") = "0" THEN
               LET ls_message = "Call sendMessageToPortal() successfully !"
            ELSE
               LET ls_message = "Call sendMessageToPortal() unsuccessfully:\n",
                                "    ReturnMsg: ", cl_ppcli_getAttributeValue("Status","description")
            END IF
 
       #-----------------------------------------------------------------------
       # 正確呼叫 Product Portal 但回傳 XML 有問題
       #-----------------------------------------------------------------------
       WHEN li_status = 0 AND gn_response IS NULL
            LET ls_message = "Response error:\n",
                             "    returning XML isn't well-formated"
 
       #-----------------------------------------------------------------------
       # 無法呼叫 Product Portal
       #-----------------------------------------------------------------------
       WHEN li_status <> 0
            LET ls_message = "Connection failed:\n",
                             "    code       : ", wserror.code, "\n",
                             "    action     : ", wserror.action, "\n",
                             "    description: ", wserror.description
    END CASE
 
    CALL cl_ppcli_log(ls_message, "Status")
 
END FUNCTION
 
# Descriptions...: ERP 呼叫 DSC Portal 完成代辦事項結案動作
# Input Parameter: ps_key  STRING   Primary Key
# Return code....: none
#
FUNCTION cl_ppcli_SignatureComplete(ps_key)
    DEFINE ps_key                   STRING
    DEFINE ls_XMLData               STRING,
           ls_SignatureComplete     STRING,
           ls_primarykey            STRING,
           ls_message               STRING,
           ls_lang                  STRING,
           li_status                INTEGER
    DEFINE l_cross_status           LIKE type_file.num5    #FUN-B80118
 
    CALL cl_ppcli_log("CALL SignatureComplete()", "Action")
 
    #---------------------------------------------------------------------------
    # 結案所需的 Primary Key
    #---------------------------------------------------------------------------
    LET ls_primarykey = ps_key CLIPPED, "|", g_plant CLIPPED
 
    #---------------------------------------------------------------------------
    # 訊息語言別轉換
    #---------------------------------------------------------------------------
    CASE g_lang
        WHEN "0"   LET ls_lang = "zh_tw"
        WHEN "1"   LET ls_lang = "en_us"
        WHEN "2"   LET ls_lang = "zh_cn"
        OTHERWISE  LET ls_lang = "en_us"
    END CASE
 
    #---------------------------------------------------------------------------
    # "SignatureComplete" XML
    # <Authentication> : user:帳號 ; password:密碼 ; 目前暫時不控管權限
    # <Connection>     : application:呼叫端系統代號 ; source:呼叫端來源IP or Host
    # <Organization>   : 此次呼叫指定存取的 ERP 營運中心代碼
    # <Locale language>: 訊息語系 ; 目前定義 zh_tw(繁體), zh_cn(簡體), en_us(英文)
    # <Key>            : Primary Key ; 提供為 ERP 呼叫 Product Portal 處理結案時依據
    # <CloseCaseDate>  : 結案完成日
    #---------------------------------------------------------------------------
    LET ls_XMLData = "<Request>\n",
                     "  <Access>\n",
                     "    <Authentication user=\"tiptop\" password=\"\" />\n",
                     "    <Connection application=\"TIPTOP\" source=\"", cl_getClientIP() CLIPPED, "\" />\n",
                     "    <Organization name=\"", g_plant CLIPPED, "\" />\n",
                     "    <Locale language=\"", ls_lang, "\" />\n",
                     "  </Access>\n",
                     "  <RequestContent>\n",
                     "    <Parameter>\n",
                     "      <Record>\n",
                     "        <Field name=\"Key\" value=\"", ls_primarykey, "\" />\n",
                     "        <Field name=\"CloseCaseDate\" value=\"", g_today USING 'YYYY/MM/DD', "\" />\n",
                     "      </Record>\n",
                     "    </Parameter>\n",
                     "  </RequestContent>\n",
                     "</Request>"
 
    #---------------------------------------------------------------------------
    # 寫入 Request XML log(from TIPTOP side)
    #---------------------------------------------------------------------------
    CALL cl_ppcli_log(ls_XMLData, "Request")

    #No:FUN-B80118 -- start --
    #-------------------------------------------------------------------------------------#
    # TIPTOP 與 CROSS 整合: 透過 CROSS 平台呼叫 Portal                                       #
    #-------------------------------------------------------------------------------------#
    SELECT wap02 INTO g_wap.wap02 FROM wap_file
    IF g_wap.wap02 = 'Y' THEN  #使用CROSS整合平台
       #呼叫 CROSS 平台發出整合活動請求
       CALL cl_ppcli_sendRequestToCross("PORTAL", "signatureComplete", "sync", ls_XMLData) 
            RETURNING l_cross_status, li_status, ls_SignatureComplete
    ELSE
    #No:FUN-B80118 -- end -- 
       #---------------------------------------------------------------------------
       # 指定 SOAP URL
       #---------------------------------------------------------------------------
       #LET ProductPortal_PortalWSImplService_PortalWSImplPortLocation = g_aza.aza68  #FUN-B90110 mark
       LET ProductPortal_PortalWSServiceSoapService_Portlet_PortalWS_PortalWSServiceLocation = g_aza.aza68  #FUN-B90110
 
       #---------------------------------------------------------------------------
       # 若 60 秒內無回應則放棄連接
       #---------------------------------------------------------------------------
       CALL fgl_ws_setOption("http_invoketimeout", 60)
 
       #---------------------------------------------------------------------------
       # 呼叫 Product Portal SignatureComplete function
       #---------------------------------------------------------------------------
       #LET ProductPortal_SignatureComplete.arg0 = ls_XMLData  #FUN-B90110 mark
       LET ProductPortal_signatureCompleteRequest.pXML = ls_XMLData  #FUN-B90110
       LET li_status = ProductPortal_SignatureComplete_g()
       #LET ls_SignatureComplete = ProductPortal_SignatureCompleteResponse.return  #FUN-B90110 mark
       LET ls_SignatureComplete = ProductPortal_signatureCompleteResponse.signatureCompleteReturn   #FUN-B90110
    END IF   #No:FUN-B80118
 
    #---------------------------------------------------------------------------
    # 寫入 Response XML log(from Product Portal side)
    #---------------------------------------------------------------------------
    CALL cl_ppcli_log(ls_SignatureComplete, "Response")
 
    #---------------------------------------------------------------------------
    # 解析 Product Portal 回傳 XML, 取得 root node
    #---------------------------------------------------------------------------
    CALL cl_ppcli_processResponse(ls_SignatureComplete)
 
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal 後回覆結果處理
    #---------------------------------------------------------------------------
    CASE
       #------------------------------------------------------------------------
       # 正確呼叫 Product Portal 且回傳正確 XML
       #------------------------------------------------------------------------
       WHEN li_status = 0 AND gn_response IS NOT NULL
            IF cl_ppcli_getAttributeValue("Status","code") = "0" THEN
               LET ls_message = "Call SignatureComplete() successfully !"
            ELSE
               LET ls_message = "Call SignatureComplete() unsuccessfully:\n",
                                "    ReturnMsg: ", cl_ppcli_getAttributeValue("Status","description")
            END IF
 
       #-----------------------------------------------------------------------
       # 正確呼叫 Product Portal 但回傳 XML 有問題
       #-----------------------------------------------------------------------
       WHEN li_status = 0 AND gn_response IS NULL
            LET ls_message = "Response error:\n",
                             "    returning XML isn't well-formated"
  
       #-----------------------------------------------------------------------
       # 無法呼叫 Product Portal
       #-----------------------------------------------------------------------
       WHEN li_status <> 0
            LET ls_message = "Connection failed:\n",
                             "    code       : ", wserror.code, "\n",
                             "    action     : ", wserror.action, "\n",
                             "    description: ", wserror.description
   END CASE
  
   CALL cl_ppcli_log(ls_message, "Status")
 
END FUNCTION
 
# Descriptions...: 回傳 Response XML document 中, 指定 attribute name 所包含的值
# Input Parameter: ps_tag       STRING   XML tag name
#                  ps_attribute STRING   XML attribute name
# Return code....: ls_value     STRING   Value of XML attribute
#
FUNCTION cl_ppcli_getAttributeValue(ps_tag,ps_attribute)
    DEFINE ps_tag       STRING,
           ps_attribute STRING
    DEFINE lst_list     om.NodeList,
           ln_node      om.DomNode
 
   LET lst_list = gn_response.selectByTagName(ps_tag)
   LET ln_node = lst_list.item(1)
   IF ln_node IS NULL THEN
      RETURN NULL
   ELSE
      #------------------------------------------------------------------------
      # 抓取 <Tag name="text" /> 中 name 屬性的值 => text
      #------------------------------------------------------------------------
      RETURN ln_node.getAttribute(ps_attribute)
   END IF
 
END FUNCTION
#--FUN-8A0096--end-----

#--FUN-B80118--start-----
#[
# Description....: 提供透過CROSS平台呼叫Portal待辦事項
# Date & Author..: 2011/08/26 by Jay
# Parameter......: p_prod------------呼叫產品名稱
#                  p_srvname---------呼叫服務名稱
#                  p_type------------同步型態: sync(同步), async(非同步), mdm, etl
#                  p_request---------標準整合 Request XML 字串
# Return.........: l_cross_status----CROSS 處理成功否
#                  l_status----------WebService處理狀況
#                  l_response--------標準整合 Response XML 字串
# Memo...........:
# Modify.........:
#
#]
FUNCTION cl_ppcli_sendRequestToCross(p_prod, p_srvname, p_type, p_request) 
   DEFINE p_prod                    STRING                #呼叫產品名稱
   DEFINE p_srvname                 STRING                #呼叫服務名稱
   DEFINE p_type                    STRING                #同步型態: sync(同步), async(非同步), mdm, etl
   DEFINE p_request                 STRING                #標準整合 Request XML 字串
   DEFINE l_cmd                     STRING                #執行命令
   DEFINE l_file_name               STRING                #寫入之temp檔名
   DEFINE l_request_file_name       STRING                #request xml檔名
   DEFINE l_buf                     STRING                #讀取檔案行文字
   DEFINE l_response                STRING                #回傳response
   DEFINE l_status                  LIKE type_file.num10  #WebService處理狀況
   DEFINE l_cross_status            LIKE type_file.num10  #CROSS 處理成功否
   DEFINE l_i                       LIKE type_file.num10
   DEFINE l_ch                      base.Channel
   DEFINE l_sb                      base.StringBuffer

   #將要送到cross的request xml記錄在檔案中
   LET l_request_file_name = "aws_cross_portal_request", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
   LET l_file_name = fgl_getenv("TEMPDIR"), "/", l_request_file_name
    
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(l_file_name, "w")
   CALL l_ch.setDelimiter("")
    
   CALL l_ch.writeLine(p_request)
   CALL l_ch.close()
    
   #取得寫入tmp檔檔名
   LET l_file_name = "aws_cross_portal_", FGL_GETPID() USING '<<<<<<<<<<', ".tmp"

   LET l_cmd = "aws_cross_portal '", p_prod, "' '", p_srvname, "' '",  
                   p_type, "' '", l_request_file_name, "' '", l_file_name, "'"

   #執行呼叫 CROSS 平台發出整合活動請求
   CALL cl_cmdrun_wait(l_cmd)

   LET l_file_name = fgl_getenv("TEMPDIR"), "/", l_file_name
   LET l_response = ""
       
   #檢查檔案是否存在
   IF os.Path.exists(l_file_name) THEN
      LET l_sb = base.StringBuffer.create()
      LET l_ch = base.Channel.create()

      #開始讀取回傳之Response
      CALL l_ch.openFile(l_file_name, "r")
      CALL l_ch.setDelimiter(NULL)
      LET l_i = 1
      WHILE l_ch.read(l_buf)
         CASE l_i
            WHEN 1
               LET l_cross_status = l_buf.trim()
               
            WHEN 2
               LET l_status = l_buf.trim()

            OTHERWISE
               CALL l_sb.append(l_buf.trim())                   
         END CASE
             
         LET l_i = l_i + 1   
      END WHILE
      CALL l_ch.close()

      #刪掉response檔案
      RUN "rm -f " || l_file_name || " >/dev/null 2>&1"

      #刪掉request檔案
      LET l_file_name = fgl_getenv("TEMPDIR"), "/", l_request_file_name
      RUN "rm -f " || l_file_name || " >/dev/null 2>&1"

      LET l_response = l_sb.toString()
   END IF

   RETURN l_cross_status, l_status, l_response
END FUNCTION
#--FUN-B80118--end-------
