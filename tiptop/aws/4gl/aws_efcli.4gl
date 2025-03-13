# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Library name...: aws_efcli
# Descriptions...: 透過 Web Services 將 TIPTOP 表單與 EasyFlow 整合
# Input parameter: p_title   報表名稱
#                  p_formID  表單單別
#                  p_formNum 表單單號
#                  p_key1    SQL用key-1
#                  p_key2    SQL用key-2
#                  p_key3    SQL用key-3
#                  p_key4    SQL用key-4
#                  p_key5    SQL用key-5
# Return code....: '0' 表單開立不成功
#                  '1' 表單開立成功
# Usage .........: call aws_efcli(p_title, p_formID, p_formNum, p_key1, p_key2, p_key3, p_key4, p_key5)
# Date & Author..: 92/02/25 By Brendan
# Modify.........: No.MOD-4B0222 04/11/23 By Echo 將 XML 中特殊定義的字元( &) 取代為標準規範中的取代字元(&amp;)
# Modify.........: No.FUN-520020 05/02/22 By Echo 更改LOG檔記錄方式，aws_efcli.log改成aws_efcli-yyyymmdd.log (加上時間)
# Modify.........: No.FUN-550075 05/06/11 By Echo 新增EasyFlow站台
# Modify.........: No.MOD-560007 05/06/11 By Echo 重新定義FUN名稱
# Modify.........: No.FUN-570230 05/07/29 By Echo 將開單的pid存至aws_efcli-日期.log
# Modify.........: No.MOD-590183 05/09/12 By Echo 定義單別為char(3)放大為char(5)
# Modify.........: No.TQC-5A0129 05/10/31 By Echo CHAR改為STRING
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.TQC-660062 06/06/29 By Pengu 程式段有用到azu_file的地方全部delete掉
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE
# Modify.........: No.FUN-710010 07/01/16 By chingyuan TIPTOP與EasyFlow GP整合
# Modify.........: No.FUN-720042 07/02/27 Genero 2.0
# Modify.........: No.FUN-B90032 11/09/05 By minpp 程序撰写规范修改
IMPORT com
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令

IMPORT os   #No.FUN-9C0009 
DATABASE ds
#No.FUN-720042
 
GLOBALS "../4gl/aws_efgw.inc"
GLOBALS "../4gl/aws_efgpgw.inc" #No.FUN-710010
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
 
DEFINE g_wsa	RECORD LIKE wsa_file.*
DEFINE channel base.Channel
DEFINE g_efsoap     STRING           #FUN-550075
 
FUNCTION aws_efcli(p_title, p_formID, p_formNum, p_key1, p_key2, p_key3, p_key4, p_key5)
    DEFINE p_title	STRING,
           p_formID	LIKE oay_file.oayslip, #MOD-590183
           p_formNum	LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(100)
           p_key1	LIKE wse_file.wse03,   #No.FUN-680130 VARCHAR(20)
           p_key2	LIKE wse_file.wse04,   #No.FUN-680130 VARCHAR(20)
           p_key3	LIKE wse_file.wse05,   #No.FUN-680130 VARCHAR(20)
           p_key4	LIKE wse_file.wse06,   #No.FUN-680130 VARCHAR(20)
           p_key5	LIKE wse_file.wse07    #No.FUN-680130 VARCHAR(20)
    DEFINE l_status	LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_str	STRING,
	   l_sql	STRING,
           l_Result	STRING
    DEFINE l_i		LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_tag        STRING,
           l_p1         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_p2         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_wc		STRING,
           l_formNum    STRING
    DEFINE buf          base.StringBuffer            
    DEFINE l_file       STRING,                #FUN-520020
           l_pid        STRING,
           l_cmd        STRING,
           lch_cmd      base.Channel,
           ls_result    STRING
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_title = p_title
    LET g_formID = p_formID
    LET g_formNum = p_formNum
    LET g_key1 = p_key1
    LET g_key2 = p_key2
    LET g_key3 = p_key3
    LET g_key4 = p_key4
    LET g_key5 = p_key5
 
    CALL aws_efcli_cf()   #組傳入 EasyFlow 的 XML 資料
    IF g_strXMLInput = '' OR g_strXMLInput IS NULL THEN
       RETURN 0
    END IF
 
    SELECT * INTO g_wsa.* FROM wsa_file WHERE wsa01 = g_prog
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
#      CALL cl_err("select wsa failed: ", SQLCA.SQLCODE, 0)   #No.FUN-660155
       CALL cl_err3("sel","wsa_file",g_prog,"",SQLCA.sqlcode,"","select wsa failed:", 0)   #No.FUN-660155)   #No.FUN-660155
       RETURN 0
    END IF
    
    #若單號(g_formNum) 包含其他條件則擷取出來(以{+} 為區隔)
    LET l_wc = ""
    LET l_i = 1
    LET l_tag = "{+}"
    LET l_formNum = g_formNum
    DISPLAY "l_formNum:",l_formNum;
    LET l_p1 = l_formNum.getIndexOf(l_tag,1)
    IF l_p1 != 0 THEN  
      WHILE l_i <= LENGTH(l_formNum)
       LET l_p1 = l_formNum.getIndexOf(l_tag,l_i)
       LET l_p2 = l_formNum.getIndexOf(l_tag,l_p1+3)
       
       IF l_p2 = 0 THEN
          LET l_wc = l_wc CLIPPED," AND ", l_formNum.subString(l_p1+l_tag.getLength(),l_formNum.getLength())
          EXIT WHILE
       ELSE
          LET l_wc = l_wc CLIPPED," AND ", l_formNum.subString(l_p1+l_tag.getLength(),l_p2-1)
       END IF
 
       LET l_i = l_p2 - 1
 
      END WHILE
    END IF
#以下標記段落移至 EF 開單完成後處理
{
    #更新單頭檔狀態碼為 'S' = '送簽中'
    LET l_sql = "UPDATE ", g_wsa.wsa02 CLIPPED, " SET ",
                g_wsa.wsa04 CLIPPED, " = 'S'",
                " WHERE ",  g_wsa.wsa03 CLIPPED, " = '", p_formNum CLIPPED, "'"
    IF LENGTH(l_wc) != 0 THEN
       LET l_sql = l_sql CLIPPED, l_wc
    END IF
    LET l_str = "update ", g_wsa.wsa04 CLIPPED, " failed: "
    EXECUTE IMMEDIATE l_sql
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
       CALL cl_err(l_str, SQLCA.SQLCODE, 0)
       RETURN 0
    END IF
 
    #更新單身檔狀態碼為 'S' = '送簽中'
    IF (g_wsa.wsa05 CLIPPED IS NOT NULL) AND 
       (g_wsa.wsa06 CLIPPED IS NOT NULL) AND
       (g_wsa.wsa07 CLIPPED IS NOT NULL) THEN
       LET l_sql = "UPDATE ", g_wsa.wsa05 CLIPPED, " SET ",
                   g_wsa.wsa07 CLIPPED, " = 'S'",
                   " WHERE ",  g_wsa.wsa06 CLIPPED, " = '", p_formNum CLIPPED, "'"
       IF LENGTH(l_wc) != 0 THEN
          LET l_sql = l_sql CLIPPED, l_wc
       END IF
       LET l_str = "update ", g_wsa.wsa07 CLIPPED, " failed: "
       EXECUTE IMMEDIATE l_sql
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
          CALL cl_err(l_str, SQLCA.SQLCODE, 0)
          RETURN 0
       END IF
    END IF
}   
   ### No.MOD-4B0222
  ###轉換 & 為 &amp; 
 
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_strXMLInput)
    CALL buf.replace( "&","&amp;", 0)
    LET g_strXMLInput = buf.toString()
  
   ### END No.MOD-4B0222
    #FUN-550075
    #LET EFGateWay_soapServerLocation = g_efsoap                       #指定 Soapaserver location
     
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
        CALL EFGateWay_TipTopCoordinator(g_strXMLInput)             #連接 EasyFlow SOAP server
          RETURNING l_status, l_Result
    ELSE
        CALL EFGPGateWay_EasyFlowGPGateWay(g_strXMLInput)           #連接 EasyFlowGP SOAP server
          RETURNING l_status, l_Result
    END IF
    #No.FUN-710010 --end--
 
    #紀錄傳入 EasyFlow 的字串
    LET channel = base.Channel.create()
    LET l_file = "aws_efcli-", TODAY USING 'YYYYMMDD', ".log"
    display l_file
    CALL channel.openFile(l_file, "a")
    #CALL channel.openFile("aws_efcli.log", "w")
 
    IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
       CALL channel.write("")
       LET l_str = "Program: ", g_prog CLIPPED
       CALL channel.write(l_str)
       LET l_str = "Form Number: ", p_formNum CLIPPED
       CALL channel.write(l_str)
       CALL channel.write("")
 #FUN-570230
       LET l_str = "GETPID: "
       CALL channel.write(l_str)
       LET l_pid = FGL_GETPID() USING '<<<<<<<<<<'
       LET l_cmd = "export COLUMNS=132; ps -ef | grep ",l_pid," | grep -v 'grep'"
       LET lch_cmd = base.Channel.create()
       CALL lch_cmd.openPipe(l_cmd, "r")
       WHILE lch_cmd.read(ls_result)
              CALL channel.write(ls_result)
       END WHILE
       CALL lch_cmd.close()   #No:FUN-B90032
       CALL channel.write("")
 #END FUN-570230
       CALL channel.write("Request XML:")
       CALL channel.write(g_strXMLInput)
       CALL channel.write("")
 
       #紀錄 EasyFlow 回傳的資料
       CALL channel.write("Response XML:")
       CALL channel.write(l_Result)
       CALL channel.write("#------------------------------------------------------------------------------#")
       CALL channel.close()
       # RUN "chmod 666 l_file CLIPPED >/dev/null 2>/dev/null"     #NO.FUN-520020
#       LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null" #MOD-560007 #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    ELSE
       DISPLAY "Can't open log file."
    END IF
 
 ## END No.FUN-520020  
  
    IF l_status = 0 THEN
       IF (aws_xml_getTag(l_Result, "ReturnStatus") != 'Y') OR
          (aws_xml_getTag(l_Result, "ReturnStatus") IS NULL) THEN
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "XML parser error:\n\n", 
                         aws_xml_getTag(l_Result, "ReturnDescribe")
          ELSE
             LET l_str = "XML parser error: ",
                         aws_xml_getTag(l_Result, "ReturnDescribe")
          END IF
          CALL cl_err(l_str, '!', 1)   #XML 字串有問題
          RETURN 0
       END IF
       #No.FUN-710010 --start--
       #若與EasyFlowGP整合, 則無須處理 ActionStatus
       IF g_aza.aza72 = 'N' THEN
          IF (aws_xml_getTag(l_Result, "ActionStatus") != 'Y') OR 
             (aws_xml_getTag(l_Result, "ActionStatus") IS NULL) THEN
             IF fgl_getenv('FGLGUI') = '1' THEN
                LET l_str = "Form creation error:\n\n", 
                            aws_xml_getTag(l_Result, "ActionDescribe")
             ELSE
                LET l_str = "Form creation error: ",
                            aws_xml_getTag(l_Result, "ActionDescribe")
             END IF
             CALL cl_err(l_str, '!', 1)   #開單失敗
             RETURN 0
          END IF
       END IF
       #No.FUN-710010 --end--
       CALL aws_eflog(l_Result)        #記錄 log
       CALL cl_err(NULL, 'aws-066', 1)   #開單成功
 
#No:9026
       CASE aws_xml_getTag(l_Result, "Status")
            WHEN '1' LET g_chr = 'S'   #開單成功, 等待簽核
            WHEN '3' LET g_chr = '1'   #開單成功且簽核完成(流程設為 '通知')
       END CASE
 
       #更新單頭檔狀態碼
       LET l_sql = "UPDATE ", g_wsa.wsa02 CLIPPED, " SET ",
                   g_wsa.wsa04 CLIPPED, " = '", g_chr, "'",
                   " WHERE ",  g_wsa.wsa03 CLIPPED, " = '", p_formNum CLIPPED, "'"
       IF LENGTH(l_wc) != 0 THEN
          LET l_sql = l_sql CLIPPED, l_wc
       END IF
       LET l_str = "update ", g_wsa.wsa04 CLIPPED, " failed: "
       EXECUTE IMMEDIATE l_sql
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
          CALL cl_err(l_str, SQLCA.SQLCODE, 1)
#         RETURN 0
       END IF
  
       #更新單身檔狀態碼
       IF (g_wsa.wsa05 CLIPPED IS NOT NULL) AND 
          (g_wsa.wsa06 CLIPPED IS NOT NULL) AND
          (g_wsa.wsa07 CLIPPED IS NOT NULL) THEN
          LET l_sql = "UPDATE ", g_wsa.wsa05 CLIPPED, " SET ",
                      g_wsa.wsa07 CLIPPED, " = '", g_chr, "'",
                      " WHERE ",  g_wsa.wsa06 CLIPPED, " = '", p_formNum CLIPPED, "'"
          IF LENGTH(l_wc) != 0 THEN
             LET l_sql = l_sql CLIPPED, l_wc
          END IF
          LET l_str = "update ", g_wsa.wsa07 CLIPPED, " failed: "
          EXECUTE IMMEDIATE l_sql
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
             CALL cl_err(l_str, SQLCA.SQLCODE, 1)
#            RETURN 0
          END IF
       END IF
##
       RETURN 1
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n", 
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n",
                   "  [Description]: ", wserror.description
       ELSE
          LET l_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(l_str, '!', 1)   #連接失敗
       RETURN 0
    END IF
END FUNCTION
 
 
FUNCTION aws_efcli_XMLHeader(p_creator, p_owner)
#TQC-5A0129
DEFINE p_creator       STRING,
      p_owner          STRING,
      l_client         STRING,
      l_efsiteip       STRING,
      l_efsitename     STRING,
      l_i              LIKE type_file.num5          #No.FUN-680130 SMALLINT
#END TQC-5A0129
DEFINE l_wsj02       LIKE wsj_file.wsj02
DEFINE l_wsj03       LIKE wsj_file.wsj03
DEFINE l_wsj04       LIKE wsj_file.wsj04
 
    #FUN-550075
    SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04
      FROM wsj_file where wsj01 = 'E' AND wsj06 = g_plant
        AND wsj05 = '*' AND wsj07 = '*'
    IF l_wsj02 IS NULL THEN
      SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04
        FROM wsj_file where wsj01 = 'S' AND wsj06 = '*'
         AND wsj05 = '*' AND wsj07 = '*'
    END IF
 
    #LET l_client = cl_getClientIP()       #Client IP
    #LET l_efsiteip = fgl_getenv('EFSITEIP')       #EasyFlow server IP
    #LET l_efsitename = fgl_getenv('EFSITENAME')   #EasyFlow server name
 
    LET l_client = cl_getClientIP()       #Client IP
    LET g_efsoap = l_wsj03 CLIPPED       #EasyFlow SOAP
    LET l_efsiteip = l_wsj02 CLIPPED     #EasyFlow server IP
    LET l_efsitename = l_wsj04 CLIPPED   #EasyFlow server name
    #END FUN-550075
 
    LET g_strXMLInput =                           #組 XML Header
        "<Request>", ASCII 10,
        " <RequestMethod>CreateForm</RequestMethod>", ASCII 10,
        " <LogOnInfo>", ASCII 10,
        "  <SenderIP>", l_client CLIPPED, "</SenderIP>", ASCII 10,
        "  <ReceiverIP>", l_efsiteip CLIPPED, "</ReceiverIP>", ASCII 10,
        "  <EFSiteName>", l_efsitename CLIPPED, "</EFSiteName>", ASCII 10,
        "  <EFLogonID>", g_user CLIPPED, "</EFLogonID>", ASCII 10,
#        "  <EFLogonID>512</EFLogonID>", ASCII 10,
        " </LogOnInfo>", ASCII 10,
        " <RequestContent>", ASCII 10,
        "  <Form>", ASCII 10,
        "   <PlantID>", g_plant CLIPPED, "</PlantID>", ASCII 10,
        "   <ProgramID>", g_prog CLIPPED, "</ProgramID>", ASCII 10,
        "   <SourceFormID>", g_formID CLIPPED, "</SourceFormID>", ASCII 10,
        "   <SourceFormNum>", g_formNum CLIPPED, "</SourceFormNum>", ASCII 10,
        "   <FormCreatorID>", p_creator CLIPPED, "</FormCreatorID>", ASCII 10,
        "   <FormOwnerID>", p_owner CLIPPED, "</FormOwnerID>", ASCII 10,
#        "   <FormCreatorID>512</FormCreatorID>", ASCII 10,
#        "   <FormOwnerID>512</FormOwnerID>", ASCII 10,
        "   <ContentText>", ASCII 10,
        "    <title>", g_title CLIPPED, "</title>", ASCII 10,
        "    <head>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efcli_XMLTrailer()
    LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
        "    </body>", ASCII 10
 
 
    LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
        "   </ContentText>", ASCII 10,
        "  </Form>", ASCII 10,
        " </RequestContent>", ASCII 10,
        "</Request>"
END FUNCTION
 
 
 
