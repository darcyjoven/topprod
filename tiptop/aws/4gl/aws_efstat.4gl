# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: aws_efstat
# Descriptions...: 查詢 EasyFlow 表單 簽核流程及簽核意見
# Input parameter: p_formNum 表單單號
# Return code....: l_url 瀏覽網址
# Usage .........: call aws_efstat(p_formNum)
# Date & Author..: 92/05/14 By Brendan
# Modify.........: No.MOD-4B0222 04/11/23 By Echo 將 XML 中特殊定義的字元( &) 取代為標準規範中的取代字元(&amp;)
# Modify.........: No.FUN-4C0082 04/10/13 By Echo 提供 library function, 使 ERP 憑證輸出時可列印 EasyFlow 簽核人員姓名, 職稱及簽核時間
# Modify.........: No.MOD-530792 05/03/28 by Echo VARCHAR->CHAR
# Modify.........: No.FUN-550075 05/06/11 By Echo 新增EasyFlow站台
# Modify.........: No.FUN-570230 05/07/29 By Echo 將簽核狀況傳遞xml的log資料存至aws_efcli-日期.log
#                                                 將單據簽核流程(GetApproveLog) 記錄在 aws_efsrv-日期.log
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/09/05 By Xufeng 字段類型定義改為LIKE
# Modify.........: No.FUN-710010 07/01/16 By chingyuan TIPTOP與EasyFlow GP整合     
# Modify.........: No.FUN-720042 07/02/27 Genero 2.0
# Modify.........: No.TQC-860022 08/06/10 By Echo 調整程式遺漏 ON IDLE 程式段
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定

IMPORT com
 
DATABASE ds
 
GLOBALS "../4gl/aws_efgw.inc"
GLOBALS "../4gl/aws_efgpgw.inc" #No.FUN-710010
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
 
DEFINE g_type		LIKE type_file.chr1,     #查詢選擇 #No.FUN-680130 VARCHAR(1)   
       g_str		STRING
DEFINE channel base.Channel
DEFINE buf base.StringBuffer
DEFINE l_status	LIKE type_file.num10,       #No.FUN-680130 INTEGER
       l_Result	STRING
DEFINE g_efsoap         STRING

FUNCTION aws_efstat(p_formNum)
    DEFINE p_formNum    STRING,
           l_file       STRING
    DEFINE l_cmd	STRING,
           l_p1         LIKE type_file.num10     #No.FUN-680130 INTEGER
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    CALL aws_efstat_type()             #詢問查詢何種狀態
    IF INT_FLAG THEN   #離開
       LET INT_FLAG = 0
       RETURN
    END IF
 
    LET g_formNum = p_formNum
    CALL aws_efstat_cf()   #組傳入 EasyFlow 的 XML 資料
    IF g_strXMLInput = '' OR g_strXMLInput IS NULL THEN
       RETURN
    END IF
 
    ##No.MOD-4B0222   
 
   ###轉換 & 為 &amp; ###
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_strXMLInput)
    CALL buf.replace( "&", "&amp;", 0)
    LET g_strXMLInput = buf.toString()
 
    ## END No.MOD-4B0222
    #FUN-550075
    #LET EFGateWay_soapServerLocation = g_efsoap                        #指定 Soap server location
    
    #No.FUN-710010 --start--
    IF g_aza.aza72 = 'N' THEN 
        LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    ELSE #指定EasyFlowGP的SOAP網址
        LET EFGPGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    END IF
    #No.FUN-710010 --end--
    
    #LET EFGateWay_soapServerLocation = fgl_getenv('EFSOAP') CLIPPED   #指定 Soap server location
    #END FUN-550075
 
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   #若 60 秒內無回應則放棄
    #CALL EFGateWay_TipTopCoordinator(g_strXMLInput)                   #連接 EasyFlow SOAP server
    #     RETURNING l_status, l_Result
 
    #No.FUN-710010 --start--
    IF g_aza.aza72 = 'N' THEN
        CALL EFGateWay_TipTopCoordinator(g_strXMLInput)                   #連接 EasyFlow SOAP server
          RETURNING l_status, l_Result
    ELSE
        CALL EFGPGateWay_EasyFlowGPGateWay(g_strXMLInput)    #連接 EasyFlowGP SOAP server
          RETURNING l_status, l_Result
    END IF
    #No.FUN-710010 --end--
    
    #紀錄傳入 EasyFlow 的字串
    LET channel = base.Channel.create()
    #FUN-570230
    #CALL channel.openFile("aws_efstat.log", "w")
    LET l_file = "aws_efcli-", TODAY USING 'YYYYMMDD', ".log"
    CALL channel.openFile(l_file, "a")
    #END FUN-570230
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        LET g_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL channel.write(g_str)
        CALL channel.write("")
        LET g_str = "Program: ", g_prog CLIPPED
        CALL channel.write(g_str)
        LET g_str = "Form Number: ", p_formNum CLIPPED
        CALL channel.write(g_str)
        CALL channel.write("")
        CALL channel.write("Request XML:")
        CALL channel.write(g_strXMLInput)
        CALL channel.write("")
    
        #紀錄 EasyFlow 回傳的資料
        CALL channel.write("Response XML:")
        CALL channel.write(l_Result)
        CALL channel.write("#------------------------------------------------------------------------------#")
        CALL channel.close()
        #FUN-570230
        #RUN "chmod 666 aws_efstat.log >/dev/null 2>/dev/null"
         LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null" #MOD-560007
        RUN l_cmd
        #END FUN-570230
 
    ELSE
        DISPLAY "Can't open log file."
    END IF
 
    IF l_status = 0 THEN
       IF (aws_xml_getTag(l_Result, "ReturnStatus") != 'Y') OR
          (aws_xml_getTag(l_Result, "ReturnStatus") IS NULL) THEN
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET g_str = "Get status error:\n\n", 
                         aws_xml_getTag(l_Result, "ReturnDescribe")
          ELSE
             LET g_str = "Get status error: ",
                         aws_xml_getTag(l_Result, "ReturnDescribe")
          END IF
          CALL cl_err(g_str, '!', 1)   #XML 字串有問題
          RETURN
       END IF
 
       LET buf = base.StringBuffer.create()
       CALL buf.append(l_Result)
       CALL buf.replace( "&amp;", "&", 0)
       LET l_Result = buf.toString() 
       LET l_p1 = l_Result.getIndexOf("<URL>", 1)
       IF cl_open_url(aws_xml_getTag(l_Result, "URL")) THEN
       END IF
#      LET l_cmd = "efstat '", aws_xml_getTag(l_Result, "URL") CLIPPED, "'"
#      RUN l_cmd
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET g_str = "Connection failed:\n\n",
                      "  [Code]: ", wserror.code, "\n",
                      "  [Action]: ", wserror.action, "\n",
                      "  [Description]: ", wserror.description
       ELSE
          LET g_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(g_str, '!', 1)   #連接失敗
    END IF
END FUNCTION
 
 
FUNCTION aws_efstat_type()
 
    CASE
       WHEN g_lang = '0'
          LET g_str = "請選擇 1.查看簽核流程 2.查看簽核意見 0.離開: "
       WHEN g_lang = '2'
          LET g_str = "請選擇 1.查看簽核流程 2.查看簽核意見 0.離開: "
       OTHERWISE
          LET g_str = "Select 1.View Form Flow 2.View Approve Opinion 0.Exit:"
    END CASE
 
    WHILE TRUE
        #提示輸入查詢選項
        LET g_type = NULL

        PROMPT g_str CLIPPED FOR CHAR g_type
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        END PROMPT
        #END TQC-860022
    #    CLOSE WINDOW aws_efstat
        IF g_type MATCHES "[012]" OR INT_FLAG THEN
           EXIT WHILE
        ELSE
           CONTINUE WHILE
        END IF
    END WHILE
{
   MENU "" ATTRIBUTE(STYLE="popup")
      ON ACTION view_form_flow
           LET g_type = 1
      ON ACTION view_approve_opinion
           LET g_type = 2
   END MENU
}
END FUNCTION
 
 
FUNCTION aws_efstat_cf()
    DEFINE l_azg	RECORD LIKE azg_file.*
 
    DECLARE stat_cs CURSOR FOR SELECT * FROM azg_file
                                WHERE azg01 = g_formNum
                                ORDER BY azg02 DESC, azg06 DESC
    OPEN stat_cs
    FETCH stat_cs INTO l_azg.*
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
       CALL cl_err('select azg: ', SQLCA.SQLCODE, 0)
       LET g_strXMLInput = ''
       CLOSE stat_cs
       RETURN
    END IF
    CLOSE stat_cs
 
    CASE g_type
         WHEN '1' CALL aws_efstat_XMLHeader("GetFormFlow")         #查詢簽核流程
         WHEN '2' CALL aws_efstat_XMLHeader("GetApproveOpinion")   #查詢簽核意見
    END CASE
 
    LET g_strXMLInput = g_strXMLInput CLIPPED,
        "    <TargetFormID>", l_azg.azg08 CLIPPED, "</TargetFormID>", ASCII 10,
        "    <TargetSheetNo>", l_azg.azg06 CLIPPED, "</TargetSheetNo>", ASCII 10
 
    CALL aws_efstat_XMLTrailer()
END FUNCTION
 
 
FUNCTION aws_efstat_XMLHeader(p_method)
    DEFINE p_method	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20) 
           l_client	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20) 
           l_efsiteip	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20) 
           l_efsitename	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20) 
           l_i		LIKE type_file.num5    #No.FUN-680130 SMALLINT
    DEFINE l_wsj02      LIKE wsj_file.wsj02
    DEFINE l_wsj03      LIKE wsj_file.wsj03
    DEFINE l_wsj04      LIKE wsj_file.wsj04
 
 
    SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04
      FROM wsj_file where wsj01 = 'E' AND wsj06 = g_plant
        AND wsj05 = '*' AND wsj07 = '*'
    IF l_wsj02 IS NULL THEN
      SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04
        FROM wsj_file where wsj01 = 'S' AND wsj06 = '*'
         AND wsj05 = '*' AND wsj07 = '*'
    END IF
 
    LET l_client = cl_getClientIP()       #Client IP
    LET g_efsoap = l_wsj03 CLIPPED       #EasyFlow SOAP
    LET l_efsiteip = l_wsj02 CLIPPED     #EasyFlow server IP
    LET l_efsitename = l_wsj04 CLIPPED   #EasyFlow server name
 
    #LET l_efsiteip = fgl_getenv('EFSITEIP')       #EasyFlow server IP
    #LET l_efsitename = fgl_getenv('EFSITENAME')   #EasyFlow server name
    #END FUN-550075
 
    LET g_strXMLInput =                           #組 XML Header
        "<Request>", ASCII 10,
        " <RequestMethod>", p_method CLIPPED, "</RequestMethod>", ASCII 10,
        " <LogOnInfo>", ASCII 10,
        "  <SenderIP>", l_client CLIPPED, "</SenderIP>", ASCII 10,
        "  <ReceiverIP>", l_efsiteip CLIPPED, "</ReceiverIP>", ASCII 10,
        "  <EFSiteName>", l_efsitename CLIPPED, "</EFSiteName>", ASCII 10,
        "  <EFLogonID>", g_user CLIPPED, "</EFLogonID>", ASCII 10,
#        "  <EFLogonID>512</EFLogonID>", ASCII 10,
        " </LogOnInfo>", ASCII 10,
        " <RequestContent>", ASCII 10,
	"  <ContentText>", ASCII 10,
        "   <Form>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efstat_XMLTrailer()
    LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
        "   </Form>", ASCII 10,
	"  </ContentText>", ASCII 10,
        " </RequestContent>", ASCII 10,
        "</Request>"
END FUNCTION
 
### FUN-4C0082
FUNCTION aws_efstat_approveLog(p_formNum)
    DEFINE p_formNum		  STRING
    DEFINE l_azg	          RECORD LIKE azg_file.*
    DEFINE r                      om.XmlReader
    DEFINE e,xmlname,aws_run      String
    DEFINE ef_approvelog          DYNAMIC ARRAY OF STRING
    DEFINE l_i,i,l_cnt            LIKE type_file.num10      #No.FUN-680130 integer
    DEFINE l_wsc                  RECORD LIKE wsc_file.*
    DEFINE tag                    STRING
    DEFINE l_file                 STRING
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_formNum = p_formNum
    INITIALIZE l_wsc.* TO NULL
    DECLARE approve_cs CURSOR FOR SELECT * FROM azg_file
                                WHERE azg01 = g_formNum
                                ORDER BY azg02 desc, azg03 desc 
    OPEN approve_cs
    FETCH approve_cs INTO l_azg.*
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
 #      CALL cl_err('select azg: ', SQLCA.SQLCODE, 0)
       LET g_strXMLInput = ''
       CLOSE approve_cs
       RETURN
    END IF 
    CLOSE approve_cs
 
    CALL aws_efstat_XMLHeader("GetApproveLog")        
    display l_azg.azg08,l_azg.azg06
    LET g_strXMLInput = g_strXMLInput CLIPPED,
        "    <TargetFormID>", l_azg.azg08 CLIPPED, "</TargetFormID>", ASCII 10,
        "    <TargetSheetNo>", l_azg.azg06 CLIPPED, "</TargetSheetNo>", ASCII 10
 
    CALL aws_efstat_XMLTrailer()
 
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_strXMLInput)
    CALL buf.replace( "&", "&amp;", 0)
    LET g_strXMLInput = buf.toString()
    #FUN-550075
     LET EFGateWay_soapServerLocation = g_efsoap                        #指定 Soap server location
    #LET EFGateWay_soapServerLocation = fgl_getenv('EFSOAP') CLIPPED   #指定 Soap server location
    #END FUN-550075
   
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   #若 60 秒內無回應則放棄
    CALL EFGateWay_TipTopCoordinator(g_strXMLInput)                   #連接 EasyFlow SOAP server
         RETURNING l_status, l_Result
 
    #FUN-570230
    #記錄此次呼叫的 method name
    LET l_file = "aws_efsrv-", TODAY USING 'YYYYMMDD', ".log"
    LET channel = base.Channel.create()
 
    CALL channel.openFile(l_file,  "a")
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        LET g_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL channel.write(g_str)
        CALL channel.write("")
        LET g_str = "Method: GetApproveLog"
        CALL channel.write(g_str)
        LET g_str = "Form Number: ", p_formNum CLIPPED
        CALL channel.write(g_str)
        CALL channel.write("")
 
        #紀錄傳入的 XML 字串
        CALL channel.write("Request XML:")
        CALL channel.write(g_strXMLInput)
 
        #紀錄回傳的 XML 字串
        CALL channel.write("Response XML:")
        CALL channel.write(l_Result)
        CALL channel.write("")
        CALL channel.write("#------------------------------------------------------------------------------#")
        CALL channel.write("")
        CALL channel.write("")
        CALL channel.close()
 
        LET aws_run = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null"
        RUN aws_run
    ELSE
        DISPLAY "Can't open log file."
    END IF
 
    #END FUN-570230
 
    IF l_status = 0 THEN
       IF (aws_xml_getTag(l_Result, "ReturnStatus") != 'Y') OR
          (aws_xml_getTag(l_Result, "ReturnStatus") IS NULL) THEN
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET g_str = "Get status error:\n\n", 
                         aws_xml_getTag(l_Result, "ReturnDescribe")
          ELSE
             LET g_str = "Get status error: ",
                         aws_xml_getTag(l_Result, "ReturnDescribe")
          END IF
          CALL cl_err(g_str, '!', 1)   #XML 字串有問題
          RETURN
       END IF
       LET xmlname = FGL_GETPID() USING '<<<<<<<<<<' 
       LET xmlname = "aws_efstat_aaprove_",xmlname,".xml"
       DISPLAY "xmlname: ",xmlname 
       
       LET buf = base.StringBuffer.create()
       CALL buf.append(l_Result)
       CALL buf.replace( "&amp;", "&", 0)
       LET l_Result = buf.toString() 
       LET aws_run = "rm ",xmlname CLIPPED," 2>/dev/null"       #FUN-570230
       RUN aws_run
 
       LET channel = base.Channel.create()
       CALL channel.openFile(xmlname, "w")
       CALL channel.write(l_Result)
       CALL channel.close()
       LET aws_run = "chmod 777 ",xmlname
       RUN aws_run
 
       SELECT COUNT(*) INTO l_cnt from wsc_file where wsc01 = g_formNum
       IF l_cnt > 0 THEN 
           DELETE FROM wsc_file where wsc01 = g_formNum 
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_formNum,SQLCA.sqlcode,0)   #No.FUN-660155
              CALL cl_err3("del","wsc_file",g_formNum,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
           END IF
       END IF
       
        LET r = om.XmlReader.createFileReader(xmlname)
        LET e = r.read()
        WHILE e IS NOT NULL
            CASE e 
                WHEN "StartElement"
                      IF r.getTagName() = "ContentText" THEN EXIT WHILE END IF
            END CASE
            LET e= r.read()
        END WHILE
        LET e = r.read()
        LET l_i = 1
        LET i = 1  
        WHILE e IS NOT NULL
           CASE e
                WHEN "StartElement"
                      LET tag=""
                      CASE
                         WHEN r.getTagName() = "FlowNo"
                             LET tag = "FlowNo"
                         WHEN r.getTagName() = "BranchNo"
                             LET tag = "BranchNo"
                         WHEN r.getTagName() = "EmpolyeeName"
                             LET tag = "EmpolyeeName"
                         WHEN r.getTagName() = "PositionGradeName"
                             LET tag = "PositionGradeName"
                         WHEN r.getTagName() = "ApprovalResult"
                             LET tag = "ApprovalResult"
                         WHEN r.getTagName() = "ApprovalOpinion"
                             LET tag = "ApprovalOpinion"
                         WHEN r.getTagName() = "Date"
                             LET tag = "Date"
                      END CASE   
                WHEN "Characters"
                      CASE
                         WHEN tag = "FlowNo"
                             LET l_wsc.wsc04 = r.getCharacters()
                         WHEN tag = "BranchNo"
                             LET l_wsc.wsc05 = r.getCharacters()
                         WHEN tag = "EmpolyeeName"
                             LET l_wsc.wsc06 = r.getCharacters()
                         WHEN tag = "PositionGradeName"
                             LET l_wsc.wsc07 = r.getCharacters()
                         WHEN tag = "ApprovalResult"
                             LET l_wsc.wsc08 = r.getCharacters()
                         WHEN tag = "ApprovalOpinion"
                             LET l_wsc.wsc09 = r.getCharacters()
                         WHEN tag = "Date"
                             LET l_wsc.wsc10 = r.getCharacters()
                       END CASE
                WHEN "EndElement"
                      IF r.getTagName() = "ApproveLog" THEN
                         LET l_wsc.wsc01 = g_formNum
                         LET l_wsc.wsc02 = l_azg.azg08
                         LET l_wsc.wsc03 = l_azg.azg06
                         LET l_wsc.wsc11 = TODAY
                         LET l_wsc.wsc12 = TIME
                         INSERT INTO wsc_file VALUES (l_wsc.*)
                          IF SQLCA.sqlcode THEN 
#                                   CALL cl_err(g_formNum,SQLCA.sqlcode,0)   #No.FUN-660155
                                    CALL cl_err3("ins","wsc_file",l_wsc.wsc01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
                          END IF
                        INITIALIZE l_wsc.* TO NULL
                         
                         LET i = i + 1
                      END IF
           END CASE
           LET e= r.read()
        END WHILE
 
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET g_str = "Connection failed:\n\n",
                      "  [Code]: ", wserror.code, "\n",
                      "  [Action]: ", wserror.action, "\n",
                      "  [Description]: ", wserror.description
       ELSE
          LET g_str = "Connection failed: ", wserror.description
       END IF
 #      CALL cl_err(g_str, '!', 1)   #連接失敗
    END IF
 
    LET aws_run = "rm ",xmlname CLIPPED," 2>/dev/null"       #FUN-570230
    RUN aws_run
 
END FUNCTION
###END FUN-4C0082 ###
