# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: aws_efsrv2_sub
# Descriptions...: TIPTOP 串接 Easyflow 的 GateWay Serve sub 程式
# Input parameter: none
# Return code....: none
# Usage .........: fglrun aws_efsrv2
# Date & Author..: 92/02/25 By Brendan
# Modify.........: No.FUN-550075 05/05/18 By Echo 新增EasyFlow站台設定
# Modify.........: No.MOD-560007 05/06/02 By Echo 重新定義FUN名稱
# Modify.........: No.FUN-560076 05/06/17 By Echo 新增請假單、加班單整合
# Modify.........: No.MOD-590183 05/09/12 By Echo 定義單別為char(3)放大為char(5)
# Modify.........: No.FUN-5A0207 05/10/31 By Echo GetProgramID() 加入判斷 wsg07,wsg08,wsg09 是否不為 NULL 值才加入 SQL 條件中,以正確傳回請假/加班單的資訊
# Modify.........: No.FUN-5C0030 05/12/14 By Echo 1.記錄EasyFlow呼叫TIPTOP時TIPTOP處理的總時間至log檔
#                                                 2.記錄EasyFlow回寫狀態值(SetStatus)時update失敗的相關資訊至log檔。
#                                                 3.更改log記錄方式: 先儲存EasyFlow傳送的XML資訊。
#                                                 4.更改回寫狀態值(SetStatus)的錯誤訊息說明。
# Modify.........: No.TQC-630101 06/03/09 By Echo 由TIPTOP發起的請假/加班單，更新狀況碼的處理方式應與其他的單據相同
# Modify.........: No.FUN-640184 06/04/12 By Echo 自動執行確認功能
# Modify.........: No.TQC-680113 06/08/23 By Echo 傳送的XML字串，保留字需做轉換
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.MOD-690128 06/11/10 By Echo 調整{+}分隔符號時的程式段落，修正組where的條件。
# Modify.........: No.MOD-6A0030 06/12/25 By Echo 更改執行呼叫 GetApproveLog 流程
# Modify.........: No.FUN-710010 07/01/16 By jacklai TIPTOP與EasyFlowGP整合
# Modify.........: No.FUN-680132 06/08/30 By Echo 取得工廠資料(GetProgramID)時，只回傳有勾選與EasyFlow整合(aza23)的工廠資料
# Modify.........: No.FUN-720042 07/02/27 By Brendan Genero 2.0 調整
# Modify.........: No.TQC-740114 07/04/18 By jacklai 修正呼叫GetApproveLog時, g_aza.aza72為NULL
# Modify.........: No.TQC-740286 07/04/25 By Echo 由TIPTOP發起的請假/加班單，相關文件的處理方式應與其他的單據相同
# Modify.........: No.FUN-710063 07/05/14 By Echo XML 特殊字元處理功能
# Modify.........: No.FUN-760077 07/06/27 By Echo 重覆切換資料庫時出現異常...
# Modify.........: No.FUN-780070 07/08/27 By Echo wsk_file 調整 index :增加 wsk05(TIPTOP 表單單號) 
# Modify.........: No.TQC-7B0029 07/11/06 By Echo 調整 wsk_file 存取方式, 增加 SourceFormNum 環境變數
# Modify.........: No.TQC-7B0157 07/11/29 By Echo 接收TIPTOP的xml內容,單據名稱太長會被截
# Modify.........: No.TQC-7C0008 07/12/04 By Smapmin EF 整合程式取得各營運中心及單別資料速度過慢,故改以變數接收資料庫型態
# Modify.........: No.FUN-7C0026 07/12/07 By Echo 在 EasyFlow 端進行簽核後，請假/加班單應執行自動確認功能.
# Modify.........: No.FUN-7C0055 07/12/19 By Echo 調整Request處理後狀態值說明
# Modify.........: No.FUN-7C0033 07/12/26 By Echo 取得單別資料~增加 CLIPPED
# Modify.........: No.CHI-920065 09/02/19 By Vicky 調整當發生"Internal server error"時 EXIT PROGRAM
# Modify.........: No.FUN-920153 09/02/20 By Kevin 1.新增Method CreateUserPic 將user上傳檔案儲存
#                                                  2.改寫成呼叫com 元件
# Modify.........: No.FUN-930133 09/03/20 By Vicky 增加取得 EasyFlow GP 簽核結果(GetApproveLog)
# Modify.........: No.TQC-940184 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:FUN-960169 09/10/22 By Echo Genero 2.11新增web service錯誤代碼-12到-17
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-9C0073 10/01/11 By chenls  程序精簡
# Modify.........: No:CHI-A50019 10/05/14 By sabrina 在呼叫aws_efstat2_approveLog前先sleep 5秒。
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A80087 10/08/31 By Lilan 新增環境變數:EF核准人欄位值(EFLogonID)
# Modify.........: No:FUN-940120 10/09/15 By Jay 增加狀態碼不一致的控管
# Modify.........: No:FUN-960057 10/09/15 By Jay 狀態碼不一致第2階段 - 增加2個service：
#                                                  (1)CheckStatusList - 取得 EF 未結案清單中各單據在TIPTOP的狀態碼比對結果
#                                                  (2)GetStatusList - 取得TP未結案的清單讓EasyFlow端比對EF單據是否已結案
# Modify.........: No:TQC-970270 10/09/15 By Jay 還原MOD-970224調整的段落，並修改為較精簡的寫法
# Modify.........: No:TQC-970270 10/09/15 By Jay 還原MOD-970224調整的段落，並修改為較精簡的寫法
# Modify.........: No:FUN-B20029 11/04/08 By Echo 因 CROSS 整合功能，將 aws_efsrv2.4gl 拆為 aws_efsrv2.4gl 及 aws_efsrv2_sub.4gl 
# Modify.........: No:MOD-B50181 11/05/23 By Echo GP 5.2 新增抓取 legal
# Modify.........: No:FUN-B50136 11/06/03 By Lilan 取得工廠資料(GetProgramID)時，過濾有使用的ERP資料庫才納入
# Modify.........: No:MOD-B30610 11/07/17 By JoHung 在aws_efsrv()裡一開始就預設g_success = 'Y'
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B90063 11/10/21 By Lilan 取消與APY模組的整合
# Modify.........: No:FUN-B70095 11/12/29 By ka0132 在回傳訊息時,增加錯誤代碼
# Modify.........: No:FUN-B80090 11/12/30 by ka0132  aws_efsrv_file命名變更成aws_efsrv_file_sub副程式,並增加參數傳遞
# Modify.........: No:TQC-C10005 12/01/04 by ka0132  修正getProgramID當欲取得的營運中心不存在時導致程式中斷
# Modify.........: No:FUN-C20013 12/02/23 by kevin  補強 WHENEVER ERROR CONTINUE
# Modify.........: No:FUN-C40005 12/04/09 By Kevin 切換資料庫需Database ds
# Modify.........: No:FUN-C60080 12/06/25 By Kevin 連線 Database ds
# Modify.........: No:FUN-C70031 12/07/10 By Kevin 檢查是否已連線 ds
# Modify.........: No:FUN-CC0076 12/12/22 By Kevin 在B2B環境,執行 cl_wpc_execute
# Modify.........: No:FUN-D10121 13/01/28 By zack  設定初始 ERP 全域變數

IMPORT com 
IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global" 
GLOBALS "../4gl/awsef.4gl"                 #FUN-960057
GLOBALS "../4gl/aws_crossgw.inc"
 
#FUN-B20029 -- start --
GLOBALS
DEFINE mi_easyflow_trigger   LIKE type_file.num10,  #No.FUN-680130 INTEGER                
       mi_easyflow_status    LIKE type_file.num10,  #No.FUN-680130 INTEGER                 
       g_ef_sql              STRING,
       g_ef_sqlcode          LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE g_form  RECORD
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
DEFINE g_method_name         STRING                 #MOD-6A0030
DEFINE g_conn_ds             STRING                 #FUN-C70031
END GLOBALS
 
DEFINE g_input  RECORD
               strXMLInput  STRING
             END RECORD,
       g_output  RECORD
               strXMLOutput  STRING
             END RECORD,
       g_file   RECORD                               
               strXMLInput  STRING,
                    inputfile   BYTE ATTRIBUTE(XSDBase64binary)
             END RECORD,
       g_serv   com.WebService
 
DEFINE g_server    STRING,
       g_efsiteip  STRING,
       g_sql    STRING,
       g_sql2    STRING,         #FUN-640184
       g_wsd    RECORD LIKE wsd_file.*,
       g_wse    RECORD LIKE wse_file.*,
       g_wsf    RECORD LIKE wsf_file.*,
       g_wsg    RECORD LIKE wsg_file.*
 
DEFINE channel         base.Channel
DEFINE g_status        LIKE type_file.num5    #No.FUN-680130 SMALLINT                #FUN-5C0030
 
FUNCTION aws_efsrv_sub(p_input)
    DEFINE p_input      STRING
    DEFINE l_str  STRING,
           l_file  STRING,
           l_s    STRING,
           l_cmd  STRING
    DEFINE l_pipe       base.Channel
    DEFINE l_wsj02      LIKE wsj_file.wsj02
    DEFINE l_start        DATETIME HOUR TO FRACTION(5),
           l_end          DATETIME HOUR TO FRACTION(5)
    DEFINE l_interval     INTERVAL SECOND TO FRACTION(5)
    DEFINE l_str2       STRING               ##TQC-630101
    DEFINE l_EFLogonID  STRING               #FUN-A80087 add 
    
    WHENEVER ERROR CONTINUE                  #FUN-C20013

    LET g_input.strXMLInput = p_input

    LET g_status = FALSE                     #FUN-5C0030

    LET g_success = 'Y'   #MOD-B30610 add
    #-FUN-D10121--start--
    LET g_totsuccess = 'Y'
    LET g_errno = NULL
    LET g_lang = 0
    LET g_today = TODAY
    LET g_showmsg = ""
    CALL g_err_msg.clear()
    INITIALIZE g_form TO NULL
    INITIALIZE g_xml TO NULL
    #-FUN-D10121--end--  
 
    LET l_pipe = base.Channel.create()
    CALL l_pipe.openPipe("hostname", "r")
    WHILE l_pipe.read(g_server) 
    END WHILE
    CALL l_pipe.close()
 
    #抓出 EasyFlow 簽核過程中各項資訊
    LET g_form.ProgramID = aws_xml_getTag(g_input.strXMLInput, "ProgramID")
 
    LET g_bgjob = 'Y'
    LET g_prog = 'aws_efsrv2'
    LET g_user = 'tiptop'
    LET l_EFLogonID = aws_xml_getTag(g_input.strXMLInput, "EFLogonID")   #FUN-A80087 add
    CALL FGL_SETENV("EFLogonID",l_EFLogonID CLIPPED)                     #FUN-A80087 add
 
    LET l_str = aws_xml_getTag(g_input.strXMLInput, "RequestMethod")     #Request method
    LET g_form.SourceFormNum = aws_xml_getTag(g_input.strXMLInput, "SourceFormNum")
    LET g_method_name = l_str
 
    #FUN-C60080 start   
    CALL aws_efsrv2_conn_ds()    #FUN-C70031
    #FUN-C60080 end   
    #---FUN-B70095---start-----
    #因為下面有SELECT語法,要先在這裡切換營運中心 
    LET g_form.PlantID = aws_xml_getTag(g_input.strXMLInput, "PlantID")
    IF NOT cl_null(g_form.PlantID) THEN #TQC-C10005
        IF NOT aws_efsrv2_changePlant() THEN
           DISPLAY "Database connection failed." 
        END IF 
    END IF #TQC-C10005
    #---FUN-B70095---end------
 
   #FUN-B90063 mark str--------------- 
   #GP5.25已無與APY模組整合(一律走HR)
   #CASE g_form.ProgramID
   #  WHEN 'apyt104'   #請假單
   #      LET l_str2 = aws_xml_getTag(g_input.strXMLInput, "cqg01")   #員工代號
   #      IF NOT (cl_null(l_str2) AND 
   #         (l_str CLIPPED="SetStatus") OR (l_str CLIPPED="GetDocumentList") OR
   #         (l_str CLIPPED="OpenDocument"))
   #      THEN
   #         LET g_output.strXMLOutput = aws_efsrv_apyt104(g_input.strXMLInput)
   #         RETURN g_output.strXMLOutput
   #      END IF
   #  WHEN 'apyt103'   #加班單
   #      LET l_str2  = aws_xml_getTag(g_input.strXMLInput, "cza011")   #員工代號
   #      IF NOT (cl_null(l_str2) AND 
   #         (l_str CLIPPED="SetStatus") OR (l_str CLIPPED="GetDocumentList") OR
   #         (l_str CLIPPED="OpenDocument"))
   #      THEN
   #         LET g_output.strXMLOutput = aws_efsrv_apyt103(g_input.strXMLInput)
   #         RETURN g_output.strXMLOutput
   #      END IF
   #END CASE
   #FUN-B90063 mark end ----------------
 
 
    #抓出 EasyFlow 簽核過程中各項資訊
    #LET g_form.PlantID = aws_xml_getTag(g_input.strXMLInput, "PlantID")   #FUN-B70095 mark 移到上面了
    LET g_form.SourceFormID = aws_xml_getTag(g_input.strXMLInput, "SourceFormID")
    LET g_form.Date = aws_xml_getTag(g_input.strXMLInput, "Date")
    LET g_form.Time = aws_xml_getTag(g_input.strXMLInput, "Time")
    LET g_form.Status = aws_xml_getTag(g_input.strXMLInput, "Status")
    LET g_form.FormCreatorID = aws_xml_getTag(g_input.strXMLInput, "FormCreatorID")
    LET g_form.FormOwnerID = aws_xml_getTag(g_input.strXMLInput, "FormOwnerID")
    LET g_form.TargetFormID = aws_xml_getTag(g_input.strXMLInput, "TargetFormID")
    LET g_form.TargetSheetNo = aws_xml_getTag(g_input.strXMLInput, "TargetSheetNo")
    LET g_form.Description = aws_xml_getTag(g_input.strXMLInput, "Description")
    LET g_form.SenderIP = aws_xml_getTag(g_input.strXMLInput, "SenderIP")
 
    LET l_start = CURRENT HOUR TO FRACTION(5)
    CALL aws_efsrv2_logfile(l_str,g_input.strXMLInput,0)
 
    DISPLAY ""
    #依 request method 呼叫對應的 function
    CASE l_str CLIPPED
        #回寫狀態值
        WHEN "SetStatus"
             DISPLAY "SetStatus: ", 
                     g_form.ProgramID, " / ", g_form.SourceFormNum
             CALL aws_efsrv2_SetStatus()
        #測試連結狀態
        WHEN "CheckConnection"
             DISPLAY "CheckConnection: ", 
                     g_form.ProgramID, " / ", g_form.SourceFormNum
             CALL aws_efsrv2_CheckConnection()
        #串 EasyFlow 的程式, 工廠及單別資訊
        WHEN "GetProgramID"
             DISPLAY "GetProgramID: "
             CALL aws_efsrv2_GetProgramID()
 
        #文件列表
        WHEN "GetDocumentList"
              DISPLAY "GetDocumentList: ",
                     g_form.ProgramID, " / ", g_form.SourceFormNum
              CALL aws_efsrv2_GetDocumentList()   
              
        WHEN "OpenDocument"
              DISPLAY "OpenDocument: ",
                     g_form.ProgramID, " / ", g_form.SourceFormNum
              CALL aws_efsrv2_OpenDocument()         
                       
        #-FUN-960057--start--
        #取得 EF 未結案清單中各單據在TIPTOP的狀態碼比對結果
        WHEN "CheckStatusList"
              DISPLAY "CheckStatusList: "
              CALL aws_efsrv2_CheckStatusList()
 
        #取得 TP 未結案的清單，讓 EasyFlow 端比對 EF 單據是否已結案
        WHEN "GetStatusList"
              DISPLAY "GetStatusList: "
              CALL aws_efsrv2_GetStatusList()
        #-FUN-960057--end--

        #未知的 method name
        OTHERWISE
             DISPLAY "Unsupport services."
             LET g_output.strXMLOutput = "<Response>Unknown Operation</Response>"
    END CASE
    #記錄此次呼叫的 method name
 
 
    #記錄TIPTOP處理的總時間
    LET l_end = CURRENT HOUR TO FRACTION(5)
    LET l_interval = l_end - l_start
    CALL aws_efsrv2_logfile(l_str,g_output.strXMLOutput,l_interval)
 
    RETURN g_output.strXMLOutput
 
END FUNCTION
 
 
FUNCTION aws_efsrv2_XMLHeader(p_method)
    DEFINE p_method  STRING
 
 
    #組 XML Header
    LET g_output.strXMLOutput =   
        "<Response>", ASCII 10,
        " <ResponseType>", p_method CLIPPED, "</ResponseType>", ASCII 10,
        " <ResponseInfo>", ASCII 10,
        "  <SenderIP>", g_server CLIPPED, "</SenderIP>", ASCII 10,
        "  <ReceiverIP>", g_form.SenderIP CLIPPED, "</ReceiverIP>", ASCII 10, #FUN-560076
        " </ResponseInfo>", ASCII 10,
        " <ResponseContent>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efsrv2_XMLTrailer()
    #組 XML Trailer
    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
        " </ResponseContent>", ASCII 10,
        "</Response>"
END FUNCTION
 
 
FUNCTION aws_efsrv2_returnStatus(p_status, p_desc)
    DEFINE p_status  LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1)
           p_desc  STRING
 
 
    #設定回傳狀態值的 XML 字串
    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
        "  <ReturnInfo>", ASCII 10,
        "   <ReturnStatus>", p_status CLIPPED, "</ReturnStatus>", ASCII 10,
        "   <ReturnDescribe>", p_desc CLIPPED, "</ReturnDescribe>", ASCII 10,
        "  </ReturnInfo>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efsrv2_changePlant()
    DEFINE l_db  LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
  
    CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069
    CLOSE DATABASE        #此行為解決 4js bug       #FUN-760077
    DATABASE ds                                     #FUN-760077
    CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069
 
    #抓出對應工廠的資料庫名稱
    SELECT azp03 INTO l_db FROM azp_file WHERE azp01 = g_form.PlantID
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN 
       DISPLAY "Select azp_file failed: ", SQLCA.SQLCODE
       RETURN 0
    END IF
 
    #切換資料庫
    CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
    CLOSE DATABASE        #此行為解決 4js bug       #FUN-760077
    DATABASE l_db
    CALL cl_ins_del_sid(1,g_form.PlantID) #FUN-980030  #FUN-990069
    IF SQLCA.SQLCODE THEN
       DISPLAY "Switch database failed: ", SQLCA.SQLCODE
       CALL cl_ins_del_sid(2,'') #FUN-C40005 --start--
       CLOSE DATABASE
       DATABASE ds
       CALL cl_ins_del_sid(1,'') #FUN-C40005 --end--
       RETURN 0
    END IF
    LET g_dbs = l_db                             #FUN-640184
    LET g_plant = g_form.PlantID                 #No.FUN-710010
    SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant     #MOD-B50181

    RETURN 1
END FUNCTION
 
 
FUNCTION aws_efsrv2_SetStatus()
    DEFINE l_status  LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
    DEFINE l_i    LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_tag        STRING,
           l_p1         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_p2         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_g_formNum  STRING,
           l_pos  LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_meet  LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_wc    STRING,
           l_cnt        LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE l_formNum  LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
    DEFINE l_str        STRING,
           l_ze03       LIKE ze_file.ze03,
           l_lang       LIKE ze_file.ze02,
           l_file       STRING,
           l_s          STRING,
           l_cmd        STRING
    DEFINE ls_server        STRING
    DEFINE l_argv           LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(80)
    DEFINE l_conf           LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
    DEFINE l_status2        LIKE type_file.num10,  #No.FUN-680130 INTEGER 
           l_channel        base.Channel
    DEFINE ls_context       STRING             
    DEFINE ls_temp_path     STRING             
    DEFINE ls_context_file  STRING             
#FUN-940120-start-
    DEFINE l_FormStatus     LIKE type_file.chr1,
           l_FormConf       LIKE type_file.chr1,
           l_sql            STRING,
           l_sql2           STRING
    DEFINE l_ze01           LIKE ze_file.ze01     #TQC-970270
#FUN-940120-end- 
   #darcy:2023/05/22 add s---
   define l_oea   record
         gem02    like gem_file.gem02,
         gen02    like gen_file.gen02,
         oaydesc  like oay_file.oaydesc,
         occ02    like occ_file.occ02,
         oea01    like oea_file.oea01,
         oea02    like oea_file.oea02,
         oea03    like oea_file.oea03,
         oea04    like oea_file.oea04,
         oea14    like oea_file.oea14,
         oea15    like oea_file.oea15,
         oea17    like oea_file.oea17,
         oea17_ds like occ_file.occ02,
         oea23    like oea_file.oea23,
         oea24    like oea_file.oea24,
         oeaud03  like oea_file.oeaud03
      end record
   define l_oeb   dynamic array of record like oeb_file.*
   define l_prog  string
   #darcy:2023/05/22 add e---
 
    
    CALL aws_efsrv2_XMLHeader("SetStatus")   #組 XML Header 字串

    LET l_status = '-'
    LET l_lang = 0                #FUN-5C0030    
    #判斷是否程式代號有在維護作業中設定
    SELECT * INTO g_wse.* FROM wse_file WHERE wse01 = g_form.ProgramID
    SELECT * INTO g_wsg.* FROM wsg_file WHERE wsg01 = g_form.ProgramID #FUN-640184
 
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
       SELECT ze03 INTO l_ze03 FROM ze_file
          WHERE ze01 = 'aws-082' AND ze02 = l_lang
       LET l_str = g_form.ProgramID CLIPPED," ","aws-082"," ",l_ze03   #FUN-B70095 增加aws-082錯誤代碼
       CALL aws_efsrv2_returnStatus('N', l_str)     #程式未於設定檔中指定
    ELSE
       IF NOT aws_efsrv2_changePlant() THEN
          SELECT ze03 INTO l_ze03 FROM ze_file
             WHERE ze01 = 'aws-083' AND ze02 = l_lang
          LET l_str = g_form.PlantID CLIPPED," ","aws-083"," ",l_ze03   #FUN-B70095 增加aws-083錯誤代碼
          CALL aws_efsrv2_returnStatus('N', l_str)        #資料庫連接有問題
       ELSE
 
         CALL aws_efapp_wc_key(g_form.SourceFormNum) RETURNING l_wc
         #取真正單號
         IF LENGTH(l_wc) != 0 THEN
            LET l_formNum = aws_efapp_key(g_form.SourceFormNum,1)
         ELSE
            LET l_formNum = g_form.SourceFormNum
         END IF
         display "l_formNum:",l_formNum
 
         CASE g_form.Status
             WHEN '2'                     #抽單, 撤簽
                  LET l_status = 'W'
             WHEN '3'                    #同意
                  LET l_status = '1'
             WHEN '4'                    #不同意
                  LET l_status = 'R'
         END CASE

         LET l_conf = 'N'
         IF NOT cl_null(g_wsg.wsg10 CLIPPED) THEN
             LET g_sql = "SELECT ", g_wsg.wsg10 CLIPPED, 
                 " FROM ", g_wsg.wsg02 CLIPPED,
                 " WHERE ",g_wsg.wsg03 CLIPPED,"='",g_form.SourceFormID CLIPPED,"'"
            PREPARE conf_pre FROM g_sql
            DECLARE conf_cur CURSOR FOR conf_pre
            FOREACH conf_cur INTO l_conf 
            END FOREACH
         END IF 
         display "Auto confirm: ",l_conf
         display "l_status: ",l_status
         
         #--FUN-940120--start--
         #--TQC-970270--start--
         IF cl_null(g_wse.wse09) THEN
            LET l_sql = "SELECT '',",g_wse.wse10 CLIPPED,
                         " FROM ",g_wse.wse02 CLIPPED,
                        " WHERE ",g_wse.wse03 CLIPPED,"= ?"
         ELSE
            LET l_sql = "SELECT ",g_wse.wse09 CLIPPED,",",g_wse.wse10 CLIPPED,
                         " FROM ",g_wse.wse02 CLIPPED,
                        " WHERE ",g_wse.wse03 CLIPPED,"= ?"
         END IF
         #--TQC-970270--end--
         IF LENGTH(l_wc) != 0 THEN
            LET l_sql = l_sql CLIPPED, l_wc
         END IF
         LET l_sql = l_sql CLIPPED, " FOR UPDATE"
         LET l_sql = cl_forupd_sql(l_sql)
         DECLARE conf_status_cl CURSOR FROM l_sql
         LET l_FormConf = ""
         LET l_FormStatus = ""
         #--FUN-940120--end--
 
         IF (g_form.ProgramID='apyt103' OR g_form.ProgramID='apyt104' OR
             l_conf = 'Y') AND  l_status = '1' 
         THEN          
             LET ls_server = fgl_getenv("FGLAPPSERVER")
             IF cl_null(ls_server) THEN
                LET ls_server = fgl_getenv("FGLSERVER")
             END IF
 
             LET g_sql = "DELETE FROM wsk_file ",
                         " WHERE wsk01='",ls_server CLIPPED,"'",
                         "   AND wsk02='",g_user CLIPPED,"'",
                         "   AND wsk03='",g_wse.wse01 CLIPPED,"'",
                         "   AND wsk05='",g_form.SourceFormNum CLIPPED,"'"
             display g_sql
 
             EXECUTE IMMEDIATE g_sql 
 
             LET g_sql2 = "INSERT INTO wsk_file",
                         "(wsk01,wsk02,wsk03,wsk04,wsk05,wsk06,wsk07,wsk08,wsk09,wsk15) VALUES('",
                         ls_server CLIPPED,"','", g_user CLIPPED,"','", g_wse.wse01 CLIPPED,"','",
                         g_form.SourceFormID CLIPPED,"','", g_form.SourceFormNum CLIPPED,"','",
                         g_form.FormCreatorID CLIPPED,"','", g_form.FormOwnerID CLIPPED,"','",
                         g_form.TargetFormID CLIPPED,"','", g_form.TargetSheetNo,"','",g_form.Status,"')"
             display g_sql2
             PREPARE insert_prep FROM g_sql2
             EXECUTE insert_prep
             IF STATUS THEN
                LET l_status = '-' 
                LET l_str =  "INSERT wsk_file failed:",STATUS 
             ELSE
                LET ls_temp_path = FGL_GETENV("TEMPDIR")
                LET ls_context_file = ls_temp_path,"/aws_efsrv2_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || g_wse.wse01 CLIPPED || ".txt"
                RUN "rm -f " || ls_context_file ||" 2>/dev/null"
                LET l_cmd = g_wse.wse01 CLIPPED

                IF LENGTH(l_wc) != 0 THEN
                   FOR l_p1 = 1 TO 5
                      LET l_argv = aws_efapp_key_value(g_form.SourceFormNum,l_p1)
                      IF NOT cl_null(l_argv) OR l_argv != "" THEN
                         LET l_cmd = l_cmd ," '",l_argv CLIPPED,"'"
                      ELSE
                         EXIT FOR
                      END IF
                   END FOR
                ELSE
                   LET l_cmd = l_cmd," '",l_formNum CLIPPED,"'"
                END IF
 
                LET l_cmd = l_cmd ," 'efconfirm'"         
                display "l_cmd:",l_cmd
 
                CALL FGL_SETENV("SourceFormNum",g_form.SourceFormNum CLIPPED) #TQC-7B0029
 
                LET mi_easyflow_trigger = TRUE
 
                IF cl_null(FGL_GETENV("WEBAREA")) THEN  #FUN-CC0076 start
                   CALL cl_cmdrun_wait(l_cmd)
                ELSE
                   CALL cl_wpc_execute(l_cmd)
                END IF                                  #FUN-CC0076 end
 
                LET mi_easyflow_trigger = FALSE
 
                EXECUTE IMMEDIATE g_sql 
                
                #--FUN-940120--start--
                #檢查SetStatus後，單據的狀況碼及確認碼是否正確
                BEGIN WORK
                OPEN conf_status_cl USING l_formNum
                IF STATUS THEN
                   DISPLAY "OPEN conf_status_cl:", STATUS
                   CLOSE conf_status_cl
                   ROLLBACK WORK
                ELSE
                   FETCH conf_status_cl INTO l_FormConf,l_FormStatus
                   IF SQLCA.sqlcode THEN
                      DISPLAY "FETCH conf_status_cl:", SQLCA.sqlcode
                      CLOSE conf_status_cl
                      ROLLBACK WORK
                   END IF

                END IF
                DISPLAY "AfterSetStatus_FormConfirmValue:", l_FormConf
                DISPLAY "AfterSetStatus_FormStatusValue:", l_FormStatus
             
                IF l_FormConf = "Y" AND l_FormStatus <> "1" THEN
                   LET l_sql2 = "UPDATE ",g_wse.wse02 CLIPPED, " SET ",
                                g_wse.wse10 CLIPPED, " = '1'",
                                " WHERE ", g_wse.wse03 CLIPPED, "= '",l_formNum CLIPPED,"'"
                   EXECUTE IMMEDIATE l_sql2
                   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
                      DISPLAY " Update ", g_wse.wse10 CLIPPED, " faile: ", SQLCA.SQLCODE,"."
                      CLOSE conf_status_cl
                      ROLLBACK WORK
                   END IF
                   LET mi_easyflow_status = 0
                END IF
                CLOSE conf_status_cl
                #COMMIT WORK                                         #FUN-B20029
                #IF l_FormConf = "N" OR mi_easyflow_status > 0 THEN  #TQC-970270
                IF l_FormConf = "N" OR cl_null(l_FormConf) THEN      #TQC-970270
                   LET l_status = '-'
                   IF mi_easyflow_status > 0 THEN
                      SELECT ze03 INTO l_ze03 FROM ze_file
                      WHERE ze01 = 'aws-086' AND ze02 = l_lang
                      LET l_str = g_wse.wse01 CLIPPED," ","aws-086"," ",l_ze03   #FUN-B70095 增加aws-086錯誤代碼
                      LET g_sql = g_ef_sql
                   ELSE
                      LET l_channel = base.Channel.create()
                      CALL l_channel.openFile(ls_context_file, "r")
                      WHILE l_channel.read(l_str)
                      END WHILE
                      CALL l_channel.close()
                      IF NOT cl_null(l_str) THEN
                         LET g_sql = g_ef_sql
                         RUN "rm -f " || ls_context_file ||" 2>/dev/null"
                      ELSE
                         SELECT ze03 INTO l_ze03 FROM ze_file
                          WHERE ze01 = 'aws-086' AND ze02 = l_lang
                         LET l_str = g_wse.wse01 CLIPPED," ","aws-086"," ",l_ze03   #FUN-B70095 增加aws-086錯誤代碼
                         LET g_sql = g_ef_sql
                      END IF
                   END IF
                END IF
                #--FUN-940120--end--
             END IF
         ELSE
            #--FUN-940120--start--
            #更新狀態碼之前，先lock資料並檢查單據的狀況碼及確認碼是否正確
            BEGIN WORK
            OPEN conf_status_cl USING l_formNum
            IF STATUS THEN
               LET l_status = '-'
               #--TQC-970270--start--
               LET l_ze01 = STATUS
               SELECT ze03 INTO l_ze03 FROM ze_file
                WHERE ze01 = l_ze01 AND ze02 = l_lang
               LET l_str = "OPEN conf_status_cl:",l_ze01," ",l_ze03   #FUN-B70095 增加l_ze01錯誤代碼
               LET g_ef_sqlcode = l_ze01
            ELSE
               FETCH conf_status_cl INTO l_FormConf,l_FormStatus
               IF SQLCA.sqlcode THEN
                  LET l_status = '-'
                  LET l_ze01 = SQLCA.sqlcode
                  SELECT ze03 INTO l_ze03 FROM ze_file
                   WHERE ze01 = l_ze01 AND ze02 = l_lang
                  LET l_str = l_formNum," ",l_ze01," ",l_ze03   #FUN-B70095 增加l_ze01錯誤代碼
                  LET g_ef_sqlcode = l_ze01
               #--TQC-970270--end--
               ELSE
                  DISPLAY "BeforeSetStatus_FormConfirmValue:", l_FormConf
                  DISPLAY "BeforeSetStatus_FormStatusValue:", l_FormStatus

                  IF l_FormConf="Y" AND (l_status = "R" OR l_status = "W" ) THEN
                     LET l_status = '-'
                     SELECT ze03 INTO l_ze03 FROM ze_file
                      WHERE ze01 = 'aws-365' AND ze02 = l_lang
                     #aws-365:此單據已確認，無法再抽單或不同意！
                     LET l_str = "aws-365:",l_ze03 CLIPPED
                  ELSE
                     CALL aws_efapp_status(l_status,g_form.SourceFormNum,g_form.ProgramID)
                          RETURNING l_status2,l_str 
                     IF l_status2 = 0 THEN
                        LET l_status = '-'
                        LET g_sql = g_ef_sql
                     END IF
                  END IF
               END IF
            END IF
            CLOSE conf_status_cl  #TQC-970270
            #--FUN-940120--end--
         END IF
          IF l_status = '-' THEN
             ROLLBACK WORK
             CALL aws_efsrv2_returnStatus('N', l_str)   #狀態值更新失敗 #FUN-5C0
 
             #記錄Error Log
             LET l_file = "aws_efsrv2-", TODAY USING 'YYYYMMDD', ".log"
             LET channel = base.Channel.create()
 
             CALL channel.openFile(l_file,  "a")
             IF STATUS = 0 THEN
                 CALL channel.setDelimiter("")
                 CALL channel.write("")
                 #紀錄傳入的 XML 字串
                 CALL channel.write("Error Log:")
                 LET l_s = "     ProgramID:",g_form.ProgramID
                 CALL channel.write(l_s)
                 LET l_s = "       PlantID:",g_form.PlantID
                 CALL channel.write(l_s)
                 LET l_s = " SourceFormNum:",g_form.SourceFormNum
                 CALL channel.write(l_s)
                 LET l_s = " SQL Statement:",g_sql
                 CALL channel.write(l_s)
                 LET l_s = " SQLCA.SQLCODE: ",g_ef_sqlcode  #FUN-640184
                 CALL channel.write(l_s)
 
                 CALL channel.write("")
                 CALL channel.close()
 
                 IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009 
             ELSE
                 DISPLAY "Can't open log file."
             END IF
 
          ELSE 
              #darcy:2023/04/06 add s---
               if cl_null(g_plant) then
                  let g_plant = g_azz.azz03
                  select azw02 into g_legal from azw_file where azw01=g_plant
               end if
               #自动审核程序
               if l_status = '1' then  #darcy:2023/06/20 add
                  case g_wse.wse01
                     when 'axmt400'
                        # 再次送签 为新表单
                        # run " echo '"||l_formNum||"' >> /u1/out/darcy.log"
                     otherwise
                        if not cws_auto_confirm(g_wse.wse01,l_formNum) then
                           let g_success = 'N'
                        end if
                  end case
               end if #darcy:2023/06/20 add 
               if g_success ='N' then
                  #错误处理
                  ROLLBACK WORK
                  CALL aws_efsrv2_returnStatus('N', "自动审核失败")   #狀態值更新失敗 #FUN-5C0
      
                  #記錄Error Log
                  LET l_file = "aws_efsrv2-", TODAY USING 'YYYYMMDD', ".log"
                  LET channel = base.Channel.create()
      
                  CALL channel.openFile(l_file,  "a")
                  IF STATUS = 0 THEN
                     CALL channel.setDelimiter("")
                     CALL channel.write("")
                     #紀錄傳入的 XML 字串
                     CALL channel.write("Error Log:")
                     LET l_s = "     ProgramID:",g_form.ProgramID
                     CALL channel.write(l_s)
                     LET l_s = "       PlantID:",g_form.PlantID
                     CALL channel.write(l_s)
                     LET l_s = " SourceFormNum:",g_form.SourceFormNum
                     CALL channel.write(l_s)
                     LET l_s = " SQL Statement:",g_sql
                     CALL channel.write(l_s)
                     LET l_s = " SQLCA.SQLCODE: ",g_ef_sqlcode  #FUN-640184
                     CALL channel.write(l_s)
      
                     CALL channel.write("")
                     CALL channel.close()
      
                     IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009 
                  ELSE
                     DISPLAY "Can't open log file."
                  END IF
               else
               #darcy:2023/04/06 add e--- 
                  COMMIT WORK
                  CALL aws_efsrv2_returnStatus('Y', "No error.")               #狀態值更新成功
                  CALL aws_eflog(g_input.strXMLInput)                         #寫入 log 
                  LET g_status = TRUE                             #FUN-5C0030
              end if #darcy:2023/05/22 add
              #darcy:2023/05/22 add s---
               #   axmt400 二次送签，先不要
               # case g_wse.wse01
               #    when 'axmt400'
               #       if l_formNum[1,3]!='TE1' then
               #          exit case
               #       end if
               #       update oea_file set oeaud04 = 'N',oeaud05='0',oeaud06='tiptop' where oea01 = l_formNum
               #       initialize l_oea.* to null
               #       select   gem02,gen02,oaydesc,occ02,oea01,oea02,
               #                oea03,oea04,oea14,oea15,oea17,occ02 oea17_ds,
               #                oea23,oea24,oeaud03from oea_file
               #         into l_oea.* from oea_file
               #         left join gem_file on gem01 = oea15
               #         left join gen_file on gen01 = oea14
               #         left join oay_file on oayslip = substr(oea01,1,3)
               #         left join occ_file on occ01 = oea17
               #        where oea01=l_formNum
               #       # select * into l_oea.* from oea_file where oea01 = l_formNum
               #       declare get_axmt400 cursor for select * from oeb_file where oeb01 = l_oea.oea01
               #       call l_oeb.clear()
               #       let l_cnt = 1
               #       foreach get_axmt400 into l_oeb[l_cnt].*
               #          if sqlca.sqlcode then
               #             let g_success = 'N'
               #             exit case
               #          end if
               #          let l_cnt = l_cnt + 1
               #       end foreach
               #       call l_oeb.deleteElement(l_cnt)
               #       let l_prog = g_prog
               #       let g_prog = 'axmt403'
               #       let g_bgjob = 'Y'
               #       let g_success = 'Y'
               #       let g_formNum = l_formNum
               #       let g_success = aws_efcli2(base.TypeInfo.create(l_oea),base.TypeInfo.create(l_oeb),'','','','')
               #       run " echo '"||l_formNum||" success is "|| g_success ||"' >> /u1/out/darcy.log"
               #       let g_prog = l_prog
               # end case
              #darcy:2023/05/22 add e---
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
   
    CALL aws_efsrv2_XMLTrailer()             #組 XML Trailer 字串
END FUNCTION
 
 
FUNCTION aws_efsrv2_CheckConnection()
    CALL aws_efsrv2_XMLHeader("CheckConnection")                          #組 XML Header 字串
 
    IF NOT aws_efsrv2_changePlant() THEN
       CALL aws_efsrv2_returnStatus('N', "Database connection failed.")   #連接資料失敗
    ELSE
       CALL aws_efsrv2_returnStatus('Y', "No error.")                     #連接資料庫成功
       CALL aws_eflog(g_input.strXMLInput)                               #寫入 log
    END IF
 
    CALL aws_efsrv2_XMLTrailer()                                          #組 XML Trailer 字串
END FUNCTION
 
 
FUNCTION aws_efsrv2_GetProgramID()
    DEFINE l_azp  RECORD LIKE azp_file.*,
           l_gaz        RECORD LIKE gaz_file.*,
           l_gaz03      LIKE gaz_file.gaz03,
           l_form  RECORD 
                 slip LIKE type_file.chr10,   #No.FUN-680130 VARCHAR(10)  #No.TQC-7B0157
                 desc LIKE type_file.chr50    #No.FUN-680130 VARCHAR(80)  #No.TQC-7B0157
               END RECORD,
           l_str  LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(80)
           l_lang  LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(10)
           l_str_lang   LIKE gaz_file.gaz02,   #No.FUN-680130 VARCHAR(10)
           l_cnt        LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE l_i    LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_tag        STRING,
           l_p1         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_p2         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_wsg08      STRING
    DEFINE buf          base.StringBuffer      #TQC-680113
    DEFINE l_aza23      LIKE aza_file.aza23    #FUN-680132

    LET l_lang = aws_xml_getTag(g_input.strXMLInput, "Language")   #語言別
    CALL aws_efsrv2_XMLHeader("GetProgramID")                       #組 XML Header
 
    SELECT COUNT(*) FROM azp_file
    IF SQLCA.SQLCODE THEN
       CALL aws_efsrv2_returnStatus('N', "Database connection failed.")   #連接資
    ELSE
       CALL aws_efsrv2_returnStatus('Y', "No error.")
    END IF
 
    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
        "  <ContentText>", ASCII 10,
        "   <Language>", l_lang CLIPPED, "</Language>", ASCII 10
 
    DECLARE wsg_cs CURSOR FOR SELECT * FROM wsg_file ORDER BY wsg01 
    FOREACH wsg_cs INTO g_wsg.*   #傳遞程式資料
        IF STATUS THEN
           DISPLAY "Fetch wsg_file failed: ", STATUS
           EXIT FOREACH
        END IF
        TRY #TQC-C10005 避免程式強制中斷
            CASE l_lang CLIPPED
                 WHEN "Big5" LET l_str_lang = 0
                 WHEN "ISO8859" LET l_str_lang = 1
                 WHEN "GB" LET l_str_lang = 2
                 OTHERWISE LET l_str_lang = 1
            END CASE
            SELECT * INTO l_gaz.* FROM gaz_file 
                   WHERE gaz01 = g_wsg.wsg01 AND gaz02 = l_str_lang AND gaz05='Y'
            IF SQLCA.SQLCODE THEN
              SELECT * INTO l_gaz.* FROM gaz_file 
                   WHERE gaz01 = g_wsg.wsg01 AND gaz02 = l_str_lang AND (gaz05='N' OR gaz05 IS NULL) 
            END IF
            IF SQLCA.SQLCODE THEN
               LET l_str = g_wsg.wsg01
            ELSE
               LET l_str = l_gaz.gaz03
            END IF

            LET l_str = aws_xml_replaceStr(l_str)
     
            LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
                "   <Program ",
                    "name=\"", g_wsg.wsg01 CLIPPED, "\" ",
                    "desc=\"", l_str CLIPPED, "\" ",
                    "/>", ASCII 10
        #TQC-C10005 - Start - 避免程式強制中斷
        CATCH
            #CALL aws_efsrv2_returnStatus('N', "Database connection failed.")   #連接資料庫時發生錯誤
            CONTINUE FOREACH
        END TRY
        #TQC-C10005 -  End  - 
    END FOREACH
 
    #DECLARE azp_cur CURSOR FOR SELECT * FROM azp_file ORDER BY azp01
    DECLARE azp_cur CURSOR FOR SELECT * FROM azp_file 
                                WHERE azp01 IN (SELECT azw01 FROM azw_file 
                                                  WHERE  azwacti = 'Y')
                                  AND azp053 = 'Y'                     #FUN-B50136 add
                                 ORDER BY azp01    #FUN-A50102
    FOREACH azp_cur INTO l_azp.*   #傳遞工廠資料
        IF STATUS THEN
           DISPLAY "Fetch azp_file failed: ", STATUS
           EXIT FOREACH
        END IF
        TRY #TQC-C10005 避免程式強制中斷
 
            LET l_str = aws_xml_replaceStr(l_azp.azp02)
     
            #LET g_sql="SELECT aza23 FROM ",s_dbstring(l_azp.azp03 CLIPPED),"aza_file"
            LET g_sql="SELECT aza23 FROM ",cl_get_target_table(l_azp.azp01,'aza_file') #FUN-A50102
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102                  
            CALL cl_parse_qry_sql(g_sql,l_azp.azp01) RETURNING g_sql  #FUN-A50102    
            PREPARE aza_pre FROM g_sql
            DECLARE aza_cur CURSOR FOR aza_pre
            OPEN aza_cur
            LET l_aza23 = ''   #TQC-7C0008
            FETCH aza_cur INTO l_aza23
            IF STATUS THEN
               CONTINUE FOREACH
            END IF
            CLOSE aza_cur
            IF l_aza23 MATCHES "[ Nn]" THEN
                 CONTINUE FOREACH
            END IF
     
            LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
                "   <Plant ",
                    "name=\"", l_azp.azp01 CLIPPED, "\" ",
                    "desc=\"", l_str CLIPPED, "\" ",           #FUN-710063
                    "/>", ASCII 10
        #TQC-C10005 - Start - 避免程式強制中斷
        CATCH
            #CALL aws_efsrv2_returnStatus('N', "Database connection failed.")   #連接資料庫時發生錯誤
            CONTINUE FOREACH
        END TRY
        #TQC-C10005 -  End  - 
    END FOREACH
 
    FOREACH azp_cur INTO l_azp.*
        IF STATUS THEN
           DISPLAY "Fetch azp_file failed: ", STATUS
           EXIT FOREACH
        END IF
        TRY #TQC-C10005 避免程式強制中斷
            #LET g_sql="SELECT aza23 FROM ",s_dbstring(l_azp.azp03 CLIPPED),"aza_file"  
            LET g_sql="SELECT aza23 FROM ",cl_get_target_table(l_azp.azp01,'aza_file') #FUN-A50102 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102                  
            CALL cl_parse_qry_sql(g_sql,l_azp.azp01) RETURNING g_sql  #FUN-A50102   
            PREPARE aza2_pre FROM g_sql
            DECLARE aza2_cur CURSOR FOR aza2_pre
            OPEN aza2_cur
            LET l_aza23 = ''   #TQC-7C0008
            FETCH aza2_cur INTO l_aza23
            IF STATUS THEN
               CONTINUE FOREACH
            END IF
            CLOSE aza2_cur
            IF l_aza23 MATCHES "[ Nn]" THEN
                 CONTINUE FOREACH
            END IF
            FOREACH wsg_cs INTO g_wsg.*
                IF STATUS THEN
                   DISPLAY "Fetch wsg_file failed: ", STATUS
                   EXIT FOREACH
                END IF
                 LET g_sql = "SELECT ",   
                           g_wsg.wsg03 CLIPPED, ", ", g_wsg.wsg04 CLIPPED,     
                           #" FROM ", s_dbstring(l_azp.azp03 CLIPPED),g_wsg.wsg02 CLIPPED,
                           " FROM ", cl_get_target_table(l_azp.azp01,g_wsg.wsg02), #FUN-A50102 
                           " WHERE"  
                IF g_wsg.wsg05 IS NOT NULL THEN
                   LET g_sql = g_sql CLIPPED, " ",
                               g_wsg.wsg05 CLIPPED, " = '", DOWNSHIFT(g_wsg.wsg06 CLIPPED), "'",
                               " AND "
                END IF
     
                IF g_wsg.wsg07 IS NOT NULL THEN 
                    LET g_sql = g_sql CLIPPED, " ( "
                    LET l_i = 1
                    LET l_tag = ","
                    LET l_wsg08 = g_wsg.wsg08
                    LET l_p1 = l_wsg08.getIndexOf(l_tag,1)
                    IF l_p1 != 0 THEN
                       LET g_sql = g_sql CLIPPED," ", g_wsg.wsg07 CLIPPED, " = '",
                                     l_wsg08.subString(1,l_p1-1),"' OR"
                       WHILE l_i <= l_wsg08.getLength()
                         LET l_p1 = l_wsg08.getIndexOf(l_tag,l_i)
                         LET l_p2 = l_wsg08.getIndexOf(l_tag,l_p1+1)
                         IF l_p2 = 0 THEN
                            LET g_sql = g_sql CLIPPED," ", g_wsg.wsg07 CLIPPED, " = '",
                                     l_wsg08.subString(l_p1+l_tag.getLength(),l_wsg08.getLength()),"'"
                            EXIT WHILE
                         ELSE
                            LET g_sql = g_sql CLIPPED," ", g_wsg.wsg07 CLIPPED, " = '",
                                     l_wsg08.subString(l_p1+l_tag.getLength(),l_p2-1),"' OR"
                         END IF
                         LET l_i = l_p2 - 1
                   
                       END WHILE
                    ELSE
                       LET g_sql = g_sql CLIPPED, " ",
                                  g_wsg.wsg07 CLIPPED, " = '", g_wsg.wsg08 CLIPPED, "'"
                    END IF
                    LET g_sql = g_sql CLIPPED, " )" 
     
                ELSE
                    LET g_sql = g_sql CLIPPED ," 1=1 ";
                END IF   
     
                IF g_wsg.wsg09 IS NOT NULL THEN
                   LET g_sql = g_sql CLIPPED ," AND ", g_wsg.wsg09 CLIPPED, " = 'Y'"
                END IF
     
                LET g_sql = g_sql CLIPPED, " ORDER BY ", g_wsg.wsg03 CLIPPED
                CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102                  
                CALL cl_parse_qry_sql(g_sql,l_azp.azp01) RETURNING g_sql  #FUN-A50102  
                PREPARE form_pre FROM g_sql
                DECLARE form_cur CURSOR FOR form_pre
                FOREACH form_cur INTO l_form.*   #傳遞單別資料
                    IF STATUS THEN
                       DISPLAY "Fetch ", l_azp.azp03 CLIPPED, ":", g_wsg.wsg02 CLIPPED, " failed: ", STATUS
                       EXIT FOREACH
                    END IF
     
                    LET l_str = aws_xml_replaceStr(l_form.desc)
     
                    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
                        "   <SourceForm ",
                            "name=\"", l_form.slip CLIPPED, "\" ",   #FUN-7C0033
                            "desc=\"", l_str CLIPPED, "\" ",         #FUN-710063
                            "prog=\"", g_wsg.wsg01 CLIPPED, "\" ",
                            "plant=\"", l_azp.azp01 CLIPPED, "\" ",
                            "/>", ASCII 10
                END FOREACH
            END FOREACH
        #TQC-C10005 - Start - 避免程式強制中斷
        CATCH
            #CALL aws_efsrv2_returnStatus('N', "Database connection failed.")   #連接資料庫時發生錯誤
            CONTINUE FOREACH
        END TRY
        #TQC-C10005 -  End  - 
    END FOREACH
 
    LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,   #組 XML Trailer
        "  </ContentText>", ASCII 10
    CALL aws_efsrv2_XMLTrailer()
END FUNCTION
 
FUNCTION aws_efsrv2_GetDocumentList()
DEFINE l_key     STRING
DEFINE l_wse03   LIKE wse_file.wse03
    CALL aws_efsrv2_XMLHeader("GetDocumentList")                          #組 XML Header 字串
    IF NOT aws_efsrv2_changePlant() THEN
       CALL aws_efsrv2_returnStatus('N', "Database connection failed.")   #連接資料失敗
    ELSE
       SELECT aza34 INTO g_max_rec FROM aza_file WHERE aza01='0'  #MOD-690128
       SELECT wse03 INTO l_wse03 FROM wse_file WHERE wse01 = g_form.ProgramID
       LET l_key = l_wse03 CLIPPED , "=" , g_form.SourceFormNum 
       LET g_output.strXMLOutput = cl_doc_efGetDocument(l_key,g_output.strXMLOutput)                  
    END IF
    CALL aws_efsrv2_XMLTrailer()
 
END FUNCTION
 
FUNCTION aws_efsrv2_OpenDocument()
DEFINE l_key     STRING
DEFINE l_wse03   LIKE wse_file.wse03
    CALL aws_efsrv2_XMLHeader("OpenDocument")                          #組 XML Header 字串
    IF NOT aws_efsrv2_changePlant() THEN
       CALL aws_efsrv2_returnStatus('N', "Database connection failed.")   #連接資料失敗
    ELSE
       LET l_key = aws_xml_getTag(g_input.strXMLInput, "Document")
       LET g_output.strXMLOutput = cl_doc_efOpenDocument(l_key,g_output.strXMLOutput)
    END IF
    CALL aws_efsrv2_XMLTrailer()
 
END FUNCTION
 
#將user上傳的base64binary 資料存檔
#---FUN-B80090---start-----
#因為將 aws_efsrv2.4gl 拆為 aws_efsrv2.4gl 及 aws_efsrv2_sub.4gl
#所以也需要將Web Service呼叫函式拆開,這裡就變成副程式的FUNCTION,且多增加參數傳遞及response xml回傳
#FUNCTION aws_efsrv_file()
FUNCTION aws_efsrv_file_sub(p_XMLInput, p_inputfile)
    DEFINE p_XMLInput     STRING
    DEFINE p_inputfile    BYTE ATTRIBUTE(XSDBase64binary)
#---FUN-B80090---end------- 
    DEFINE l_str  STRING
          
    DEFINE l_pipe       base.Channel    
    DEFINE l_start        DATETIME HOUR TO FRACTION(5),
           l_end          DATETIME HOUR TO FRACTION(5)
    DEFINE l_interval     INTERVAL SECOND TO FRACTION(5)
 
    WHENEVER ERROR CONTINUE                  #FUN-C20013

    LET l_start = CURRENT HOUR TO FRACTION(5)  

    #FUN-C60080 start   
    CALL aws_efsrv2_conn_ds()    #FUN-C70031
    #FUN-C60080 end   
 
    LET g_file.strXMLInput = p_XMLInput   #FUN-B80090
    LET g_file.inputfile = p_inputfile    #FUN-B80090
 
    LET l_pipe = base.Channel.create()
    CALL l_pipe.openPipe("hostname", "r")
    WHILE l_pipe.read(g_server) 
    END WHILE
    CALL l_pipe.close()
    
    LET g_bgjob = 'Y'
    LET g_prog = 'aws_efsrv2'
    LET g_user = 'tiptop'
    
    LET l_str = aws_xml_getTag(g_file.strXMLInput, "RequestMethod")      #Request method
    LET g_form.SenderIP = aws_xml_getTag(g_file.strXMLInput, "SenderIP") #Sender IP
    CALL aws_efsrv2_logfile(l_str,g_file.strXMLInput,0)
    
    DISPLAY ""
    #依 request method 呼叫對應的 function
    CASE l_str CLIPPED
        #寫入使用者上傳檔案
        WHEN "CreateUserPic"
             CALL aws_efsrv2_setFile()
        #未知的 method name
        OTHERWISE
             DISPLAY "Unsupport services."
             LET g_output.strXMLOutput = "<Response>Unknown Operation</Response>"
    END CASE
    #記錄TIPTOP處理的總時間
    LET l_end = CURRENT HOUR TO FRACTION(5)
    LET l_interval = l_end - l_start    
    CALL aws_efsrv2_logfile(l_str,g_output.strXMLOutput,l_interval)
    RETURN g_output.strXMLOutput   #FUN-B80090
END FUNCTION
 
FUNCTION aws_efsrv2_setFile()
DEFINE    l_file STRING,
          l_cmd  STRING
 
   LET l_file = aws_xml_getTag(g_file.strXMLInput, "PicName")
   IF cl_null(l_file) THEN
      CALL aws_efsrv2_setResponse("CreateUserPic", "PicName not found","N")
      Return
   END IF
   
   LET l_file = fgl_getenv("TOP"), "/doc/pic/easyflow/Personal/",l_file CLIPPED #設定存檔路徑
   DISPLAY l_file
   
   CALL g_file.inputfile.writeFile(l_file) 
   IF STATUS = 0 THEN      
      IF os.Path.chrwx(l_file CLIPPED,511) THEN END IF   #No.FUN-9C0009
      CALL aws_efsrv2_setResponse("CreateUserPic", "Write file successful","Y")
   ELSE
      CALL aws_efsrv2_setResponse("CreateUserPic", "Write file failed","N")
   END IF
   
END FUNCTION
 
#設定回傳狀態值的 XML 字串
FUNCTION aws_efsrv2_setResponse(p_method,p_desc,p_status)
DEFINE   p_method STRING,
         p_desc   STRING,
         p_status LIKE type_file.chr1
         
      CALL aws_efsrv2_XMLHeader(p_method)   #組 XML Header 字串      
      CALL aws_efsrv2_returnStatus(p_status, p_desc)
      CALL aws_efsrv2_XMLTrailer()
      
END FUNCTION 
 
FUNCTION aws_efsrv2_logfile(l_str,p_xml,p_interval)
DEFINE     l_str  STRING,
           l_file  STRING,
           l_s    STRING,
           l_cmd  STRING,
           p_xml    STRING
DEFINE     p_interval     INTERVAL SECOND TO FRACTION(5)
    
    
    #記錄此次呼叫的 method name
    LET l_file = "aws_efsrv2-", TODAY USING 'YYYYMMDD', ".log"
    LET channel = base.Channel.create()
 
    CALL channel.openFile(l_file,  "a")
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        
        #紀錄傳入的 XML 字串
        IF p_interval IS NULL THEN
           LET l_s = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
           CALL channel.write(l_s)
           CALL channel.write("")
           LET l_s = "Method: ", l_str CLIPPED
           CALL channel.write(l_s)
           CALL channel.write("")
           CALL channel.write("Request XML:")
        ELSE
           CALL channel.write("")
           CALL channel.write("Response XML:")
        END IF
        CALL channel.write(p_xml)
        CALL channel.write("")
        
        IF p_interval IS NOT NULL THEN
            LET l_s = "Process Duration: ", p_interval ," seconds."
           CALL channel.write(l_s)
           CALL channel.write("")
           CALL channel.write("#------------------------------------------------------------------------------#")
           CALL channel.write("")
        END IF
        CALL channel.close()
 
        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009  
    ELSE
        DISPLAY "Can't open log file."
    END IF
END FUNCTION
#No.FUN-9C0073 -------------By chenls  10/01/11

#-FUN-960057--start--
#[
# Description....: 傳入 EF 未結案單據清單，TIPTOP 回傳清單中各單據的狀態碼比對結果
# Date & Author..: 2010/09/15 by Jay
# Parameter......:
# Return.........:
#]
FUNCTION aws_efsrv2_CheckStatusList()
  DEFINE l_Content        STRING,
         l_FormNode       om.DomNode,
         l_RecordList     om.NodeList,
         l_node           om.DomNode,
         l_i              LIKE type_file.num5,
         l_formNum        LIKE type_file.chr20,
         l_sql            STRING,
         l_sql2           STRING,
         l_wc             STRING,
         l_output         STRING,
         l_get_lang       STRING,
         l_lang           LIKE ze_file.ze02,
         l_ze03           LIKE ze_file.ze03,
         l_azg04          LIKE azg_file.azg04,
         #l_plant          LIKE azp_file.azp03,
         l_plant          LIKE azp_file.azp01,  #FUN-A50102
         l_dbs            LIKE azp_file.azp03,  #FUN-A50102
         l_form_status    LIKE type_file.chr1,
         l_Action         RECORD
           Status         LIKE type_file.chr1,
           Desc           STRING
           END RECORD,
         l_record         RECORD                 #記錄清單資訊
           plantID        LIKE azp_file.azp01,
           sourceFormID   LIKE oay_file.oayslip,
           sourceFormNum  LIKE type_file.chr1000,
           programID      LIKE wse_file.wse01,
           targetFormID   STRING,
           targetSheetNo  LIKE type_file.chr1000
           END RECORD

  CALL aws_efsrv2_XMLHeader("CheckStatusList")   #組 XML header 字串

  #取得語言別
  LET l_get_lang = aws_xml_getTag(g_input.strXMLInput,"Language")
  CASE l_get_lang CLIPPED
     WHEN "Big5"    LET l_lang = 0
     WHEN "ISO8859" LET l_lang = 1
     WHEN "GB"      LET l_lang = 2
     OTHERWISE      LET l_lang = 1
  END CASE

  #定義抓取 azp03 的 SQL
  LET l_sql = "SELECT azp03 FROM azp_file where azp01 = ? "
  PREPARE azp03_pre FROM l_sql

  #取得<Form>...</Form>字串
  LET l_FormNode = aws_efsrv2_stringToXml(g_input.strXMLInput)
  IF l_FormNode IS NULL THEN
     CALL aws_efsrv2_returnStatus('N', "Request isn't valid XML document!")  #XML格式錯誤
  ELSE
     LET l_RecordList = l_FormNode.selectByPath("/Request/RequestContent/ContentText/Form/Record")
     IF l_RecordList.getLength() = 0 THEN
        CALL aws_efsrv2_returnStatus('N', "No record list information.")  #無清單資訊
     ELSE
        LET l_output = ""
        #依照EF傳入的清單，一一比對TIPTOP端各單據是否已結案
        FOR l_i = 1 TO l_RecordList.getLength()
            #初始化單據資訊和狀態值
            INITIALIZE l_record.* TO NULL
            INITIALIZE l_Action.* TO NULL
            INITIALIZE l_form_status TO NULL
            INITIALIZE l_azg04 TO NULL
            #取得單據資訊
            LET l_node = l_RecordList.item(l_i)
            LET l_record.plantID = l_node.getAttribute("plantID")
            LET l_record.sourceFormID = l_node.getAttribute("sourceFormID")
            LET l_record.sourceFormNum = l_node.getAttribute("sourceFormNum")
            LET l_record.programID = l_node.getAttribute("programID")
            LET l_record.targetFormID = l_node.getAttribute("targetFormID")
            LET l_record.targetSheetNo = l_node.getAttribute("targetSheetNo")
 
            #EXECUTE azp03_pre INTO l_plant USING l_record.plantID
            #DISPLAY "[",l_plant,"-",l_record.programID,":",l_record.sourceFormNum,"]"
            EXECUTE azp03_pre INTO l_dbs USING l_record.plantID                     #FUN-A50102
            DISPLAY "[",l_dbs,"-",l_record.programID,":",l_record.sourceFormNum,"]" #FUN-A50102
            LET l_plant = l_record.plantID                                          #FUN-A50102
            IF SQLCA.sqlcode THEN
               LET l_Action.Status = "N"
               SELECT ze03 INTO l_ze03 FROM ze_file
                WHERE ze01 = 'axm-274' AND ze02 = l_lang   #無此營運中心!
               LET l_Action.Desc = l_ze03
            ELSE
               SELECT * INTO g_wse.* FROM wse_file WHERE wse01 = l_record.programID
               IF SQLCA.SQLCODE THEN
                  LET l_Action.Status = "N"
                  SELECT ze03 INTO l_ze03 FROM ze_file
                     WHERE ze01 = 'aws-082' AND ze02 = l_lang  #程式未於設定檔中指定
                  LET l_Action.Desc = l_ze03
               ELSE
                  CALL aws_efapp_wc_key(l_record.sourceFormNum) RETURNING l_wc
                  #取真正單號
                  IF LENGTH(l_wc) != 0 THEN
                     LET l_formNum = aws_efapp_key(l_record.sourceFormNum,1)
                  ELSE
                     LET l_formNum = l_record.sourceFormNum
                  END IF
 
                  #抓取單據狀態碼
                  LET l_sql = "SELECT ",g_wse.wse10 CLIPPED,
                              # " FROM ",s_dbstring(l_plant CLIPPED),g_wse.wse02 CLIPPED,
                               " FROM ",cl_get_target_table(l_plant,g_wse.wse02), #FUN-A50102
                              " WHERE ",g_wse.wse03 CLIPPED," = '",l_formNum CLIPPED,"'"
                  IF LENGTH(l_wc) != 0 THEN
                     LET l_sql = l_sql CLIPPED,l_wc CLIPPED
                  END IF
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102              
                  CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql      #FUN-A50102      
                  PREPARE status_pre FROM l_sql
                  EXECUTE status_pre INTO l_form_status
                  DISPLAY "Original Status:",l_form_status
 
                  #抓狀態碼錯誤或狀態碼不為1、R、S、W，則改抓azg_file簽核記錄檔
                  IF SQLCA.sqlcode OR
                     (l_form_status <> "1" AND l_form_status <> "R" AND
                      l_form_status <> "S" AND l_form_status <> "W")  THEN
                     #LET l_sql  = "SELECT azg04 FROM ",s_dbstring(l_plant CLIPPED),"azg_file",
                     LET l_sql  = "SELECT azg04 FROM ",cl_get_target_table(l_plant,'azg_file'), #FUN-A50102
                                  " WHERE azg01 = '",l_record.sourceFormNum CLIPPED,
                                   "' AND azg06 = '",l_record.targetSheetNo CLIPPED,
                                   "' AND azg09 = ? ORDER BY azg02 DESC,azg03 DESC"
                     #LET l_sql2 = "SELECT azg04 FROM ",s_dbstring(l_plant CLIPPED),"azg_file",
                     LET l_sql2 = "SELECT azg04 FROM ",cl_get_target_table(l_plant,'azg_file'), #FUN-A50102
                                  " WHERE azg01 = '",l_record.sourceFormNum CLIPPED,
                                   "' AND azg06 = '",l_record.targetSheetNo CLIPPED,
                                   "' ORDER BY azg02 DESC,azg03 DESC"
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102              
                     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql      #FUN-A50102                 
                     PREPARE azg04_pre FROM l_sql
                     DECLARE azg04_curs CURSOR FOR azg04_pre
                     
                     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2              #FUN-A50102              
                     CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2      #FUN-A50102   
                     PREPARE azg04_pre2 FROM l_sql2
                     DECLARE azg04_curs2 CURSOR FOR azg04_pre2
                     OPEN azg04_curs USING l_record.programID
                     FETCH azg04_curs INTO l_azg04
                     IF SQLCA.sqlcode THEN
                        OPEN azg04_curs2
                        FETCH azg04_curs2 INTO l_azg04
                        IF SQLCA.sqlcode THEN
                           IF cl_null(l_form_status) OR l_form_status="0" OR l_form_status="9" THEN
                              LET l_Action.Status = "N"     #抓不到簽核記錄，給錯誤訊息
                              SELECT ze03 INTO l_ze03 FROM ze_file
                               WHERE ze01 = 'aws-370' AND ze02 = l_lang
                              LET l_Action.Desc = l_ze03
                              LET l_form_status = ""
                           ELSE
                              #狀態碼不為0,1,9,R,S,W時，通常都是已核准後才有的狀態
                              LET l_form_status = "1"
                              LET l_Action.Status = "Y"
                           END IF
                        ELSE
                           LET l_form_status = l_azg04
                           LET l_Action.Status = "Y"
                        END IF
                        CLOSE azg04_curs2
                     ELSE
                        LET l_form_status = l_azg04
                        LET l_Action.Status = "Y"
                     END IF
                     CLOSE azg04_curs
                     DISPLAY "Status in azg_file:",l_azg04
                  ELSE
                     LET l_Action.Status = "Y"
                  END IF
               END IF
            END IF
 
            IF l_Action.Status = "Y" THEN
               LET l_Action.Desc = "Success"
            END IF
  
            #轉換狀態碼
            IF cl_null(l_azg04) THEN
               CASE l_form_status
                 WHEN 'S'                    #送簽中
                      LET l_form_status = '1'
                 WHEN 'W'                    #抽單, 撤簽
                      LET l_form_status = '2'
                 WHEN '1'                    #同意
                      LET l_form_status = '3'
                 WHEN 'R'                    #不同意
                      LET l_form_status = '4'
               END CASE
            END IF
  
            #組單據資訊
            LET l_output = l_output CLIPPED,
                           "    <Record plantID =\"",l_record.plantID CLIPPED,"\" ",
                           "sourceFormID=\"",l_record.sourceFormID CLIPPED,"\" ",
                           "sourceFormNum=\"",l_record.sourceFormNum CLIPPED,"\" ",
                           "programID=\"",l_record.programID CLIPPED,"\" ",
                           "targetFormID=\"",l_record.targetFormID CLIPPED,"\" ",
                           "targetSheetNo=\"",l_record.targetSheetNo CLIPPED,"\" ",
                           "status=\"",l_form_status CLIPPED,"\" ",
                           "ActionStatus=\"",l_Action.Status CLIPPED,"\" ",
                           "ActionDescription=\"",l_Action.Desc CLIPPED,"\" />",ASCII 10
  
        END FOR
  
        CALL aws_efsrv2_returnStatus('Y', "No Error.")
 
        LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
                                    "  <ContentText>", ASCII 10,
                                    "   <Form>", ASCII 10,
                                    l_output,
                                    "   </Form>", ASCII 10,
                                    "  </ContentText>", ASCII 10
     END IF
  END IF

  CALL aws_efsrv2_XMLTrailer()                   #組 XML Trailer 字串

END FUNCTION

#[
# Description....: 取得 TP 未結案的清單，讓 EasyFlow 端比對 EF 單據是否已結案
# Date & Author..: 2010/09/15 by Jay
# Parameter......:
# Return.........:
#]
FUNCTION aws_efsrv2_GetStatusList()
  DEFINE l_sql       STRING,
         l_str       STRING,
         l_get_lang  STRING,
         l_output    STRING,
         l_process   LIKE type_file.chr1,
         l_status    LIKE type_file.chr1,
         l_cnt       LIKE type_file.num5,
         #l_plant     LIKE azp_file.azp03,
         l_plant     LIKE azp_file.azp01,
         l_lang      LIKE ze_file.ze02,
         l_ze03      LIKE ze_file.ze03,
         #l_azp03     LIKE azp_file.azp03,
         l_azp01     LIKE azp_file.azp01,   #FUN-A50102
         l_aza23     LIKE aza_file.aza23
 
  CALL aws_efsrv2_XMLHeader("GetStatusList")     #組 XML header 字串

  #取得語言別
  LET l_get_lang = aws_xml_getTag(g_input.strXMLInput,"Language")
  CASE l_get_lang CLIPPED
     WHEN "Big5"    LET l_lang = 0
     WHEN "ISO8859" LET l_lang = 1
     WHEN "GB"      LET l_lang = 2
     OTHERWISE      LET l_lang = 1
  END CASE
 
  LET l_process = "Y"   #處理狀態，預設為 "Y"
  LET l_output = ""

  CASE g_form.Status
      WHEN '1'                    #送簽中
           LET l_status = 'S'
      WHEN '2'                    #抽單, 撤簽
           LET l_status = 'W'
      WHEN '3'                    #同意
           LET l_status = '1'
      WHEN '4'                    #不同意
           LET l_status = 'R'
      OTHERWISE
           SELECT ze03 INTO l_ze03 FROM ze_file
            WHERE ze01 = 'aws-371' AND ze02 = l_lang   #指定查詢的狀態碼錯誤
           LET l_str = "Status:",g_form.Status, " ","aws-371"," ",l_ze03   #FUN-B70095 增加aws-371錯誤代碼
           LET l_process = "N"
           CALL aws_efsrv2_returnStatus('N', l_str)
  END CASE
 
  DISPLAY "Status:",l_status

  #抓取設定作業中所有程式單據資訊的 SQL 和 CURSOR
  LET l_sql = "SELECT * FROM wse_file WHERE wse01 = ? ORDER BY wse01"
  PREPARE wse_pre FROM l_sql
  DECLARE wseall_cs CURSOR FOR SELECT * FROM wse_file ORDER BY wse01

  #當有指定營運中心時，只抓取該營運中心單據資料
  IF NOT cl_null(g_form.PlantID) AND g_form.PlantID <> "all" AND l_process = "Y" THEN
     #SELECT azp03 INTO l_plant FROM azp_file WHERE azp01 = g_form.PlantID
     LET l_plant = g_form.PlantID #FUN-A50102
     IF SQLCA.sqlcode THEN
        SELECT ze03 INTO l_ze03 FROM ze_file
         WHERE ze01 = 'axm-274' AND ze02 = l_lang   #無此營運中心!
        LET l_str = g_form.PlantID, " ","axm-274"," ",l_ze03   #FUN-B70095 增加axm-274錯誤代碼
        LET l_process = "N"
        CALL aws_efsrv2_returnStatus('N', l_str)
     ELSE
        #當有指定程式代號時，抓取該程式所有符合指定狀態的單據
        IF NOT cl_null(g_form.ProgramID) AND g_form.ProgramID <> "all" THEN
           EXECUTE wse_pre INTO g_wse.* USING g_form.ProgramID
           IF SQLCA.SQLCODE THEN
              SELECT ze03 INTO l_ze03 FROM ze_file
               WHERE ze01 = 'aws-082' AND ze02 = l_lang  #程式未於設定檔中指定
              LET l_str = g_form.ProgramID, " ","aws-082"," ",l_ze03   #FUN-B70095 增加aws-082錯誤代碼
              LET l_process = "N"
              CALL aws_efsrv2_returnStatus('N', l_str)
           ELSE
              LET l_output = l_output CLIPPED,
                             aws_efsrv2_getData(l_plant,g_form.ProgramID,l_status)           
           END IF
        END IF
        #當沒有指定程式代號或為"all"時，一一輪詢設定作業中各程式所有符合指定狀態的單據
        IF cl_null(g_form.ProgramID) OR g_form.ProgramID = "all" THEN
           FOREACH wseall_cs INTO g_wse.*
              IF STATUS THEN
                 LET l_str = "Fetch wse_file failed: ", STATUS
                 DISPLAY l_str
                 LET l_process = "N"
                 CALL aws_efsrv2_returnStatus('N', l_str)
                 EXIT FOREACH
              END IF
              LET l_output = l_output CLIPPED,
                             aws_efsrv2_getData(l_plant,g_wse.wse01,l_status)
           END FOREACH
        END IF
     END IF
  END IF

  #當不指定營運中心時，依照有勾選與EF整合的營運中心來抓取單據資料
  IF (cl_null(g_form.PlantID) OR g_form.PlantID = "all") AND l_process = "Y" THEN
     #DECLARE azp03_curs CURSOR FOR SELECT azp03 FROM azp_file ORDER BY azp01    #FUN-A50102
     #FOREACH azp03_curs INTO l_azp03                                            #FUN-A50102
     #DECLARE azp01_curs CURSOR FOR SELECT azp01 FROM azp_file ORDER BY azp01
     DECLARE azp01_curs CURSOR FOR SELECT  azp01 FROM azp_file
                                    WHERE  azp01 IN (SELECT azw01 FROM azw_file 
                                                  WHERE  azwacti = 'Y')
                                    ORDER BY azp01    #FUN-A50102
     FOREACH azp01_curs INTO l_azp01
        IF STATUS THEN
           LET l_str = "Fetch azp_file failed: ", STATUS
           DISPLAY l_str
           LET l_process = "N"
           CALL aws_efsrv2_returnStatus('N', l_str)
           EXIT FOREACH
        END IF
        #判斷此營運中心是否有勾選與EF整合
        #LET l_sql = "SELECT aza23 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file",
        LET l_sql = "SELECT aza23 FROM ",cl_get_target_table(l_azp01,'aza_file'), #FUN-A50102
                    " WHERE aza01 = '0'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102              
      CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql #FUN-A50102            
        PREPARE aza23_pre FROM l_sql
        LET l_aza23 = ''
        EXECUTE aza23_pre INTO l_aza23
        IF STATUS THEN
           CONTINUE FOREACH
        END IF
        IF l_aza23 MATCHES "[ Nn]" THEN
            CONTINUE FOREACH
        END IF
        #當有指定程式代號時，抓取該程式所有符合指定狀態的單據
        IF NOT cl_null(g_form.ProgramID) AND g_form.ProgramID <> "all" THEN
           EXECUTE wse_pre INTO g_wse.* USING g_form.ProgramID
           IF SQLCA.SQLCODE THEN
              SELECT ze03 INTO l_ze03 FROM ze_file
               WHERE ze01 = 'aws-082' AND ze02 = l_lang  #程式未於設定檔中指定
              LET l_str = g_form.ProgramID, " ","aws-082"," ",l_ze03   #FUN-B70095 增加aws-082錯誤代碼
              LET l_process = "N"
              CALL aws_efsrv2_returnStatus('N', l_str)
              EXIT FOREACH
           ELSE
              LET l_output = l_output CLIPPED,
              #               aws_efsrv2_getData(l_azp03,g_form.ProgramID,l_status)
                             aws_efsrv2_getData(l_azp01,g_form.ProgramID,l_status)   #FUN-A50102
           END IF
        END IF
        #當沒有指定程式代號或為"all"時，一一輪詢設定作業中各程式所有符合指定狀態的單據
        IF cl_null(g_form.ProgramID) OR g_form.ProgramID = "all" THEN
           FOREACH wseall_cs INTO g_wse.*
              IF STATUS THEN
                 LET l_str = "Fetch wse_file failed: ", STATUS
                 DISPLAY l_str
                 LET l_process = "N"
                 CALL aws_efsrv2_returnStatus('N', l_str)
                 EXIT FOREACH
              END IF
              LET l_output = l_output CLIPPED,
              #               aws_efsrv2_getData(l_azp03,g_wse.wse01,l_status)
                             aws_efsrv2_getData(l_azp01,g_wse.wse01,l_status)   #FUN-A50102
           END FOREACH
        END IF
        IF l_process = "N" THEN
           EXIT FOREACH
        END IF
     END FOREACH
  END IF

  IF l_process = "Y" THEN
     CALL aws_efsrv2_returnStatus('Y', "No Error.")
     IF NOT cl_null(l_output) THEN
        LET g_output.strXMLOutput = g_output.strXMLOutput CLIPPED,
                                    "  <ContentText>", ASCII 10,
                                    "   <Form>", ASCII 10,
                                    l_output,
                                    "   </Form>", ASCII 10,
                                    "  </ContentText>", ASCII 10
     END IF
  END IF
 
  CALL aws_efsrv2_XMLTrailer()                   #組 XML Trailer 字串

END FUNCTION

#[
# Description....: 抓取指定工廠別、程式代號、狀態碼的所有單據資料
# Date & Author..: 2010/09/15 by Jay
# Parameter......: p_plant       string  #工廠別
# ...............: p_prog        string  #程式代號
# ...............: p_status      string  #狀態碼
# Return.........: l_record_str  string  #回傳<Record .../>字串
#]
FUNCTION aws_efsrv2_getData(p_plant,p_prog,p_status)
  DEFINE #p_plant          LIKE azp_file.azp03,
         p_plant          LIKE azp_file.azp01,  #FUN-A50102
         p_prog           LIKE wse_file.wse01,
         p_status         LIKE type_file.chr1,
         l_key            LIKE type_file.chr200,
         l_index          LIKE type_file.num5,
         l_i              LIKE type_file.num5,
         l_azp01          LIKE azp_file.azp01,
         l_sql            STRING,
         l_sql2           STRING,
         l_str            STRING,
         l_str2           STRING,
         l_record_str     STRING,
         l_tok            base.Stringtokenizer,
         l_record         RECORD
           sourceFormID   LIKE oay_file.oayslip,
           sourceFormNum  LIKE type_file.chr1000,
           targetFormID   LIKE type_file.chr100,
           targetSheetNo  LIKE type_file.chr1000
           END RECORD

  LET l_record_str = ""

  #取得EasyFlow單別、單號的CURSOR
  LET l_sql  = "SELECT azg06,azg08",
               # " FROM ",s_dbstring(p_plant CLIPPED),"azg_file",
                " FROM ",cl_get_target_table(p_plant,'azg_file'), #FUN-A50102
               " WHERE azg01 = ? AND azg09 = ?",
               " ORDER BY azg02 DESC,azg03 DESC"
  LET l_sql2 = "SELECT azg06,azg08",
               # " FROM ",s_dbstring(p_plant CLIPPED),"azg_file",
                " FROM ",cl_get_target_table(p_plant,'azg_file'), #FUN-A50102
               " WHERE azg01 = ?",
               " ORDER BY azg02 DESC,azg03 DESC"
               
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102              
  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102                
  PREPARE getazg_pre FROM l_sql
  DECLARE getazg_curs CURSOR FOR getazg_pre

  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2              #FUN-A50102              
  CALL cl_parse_qry_sql(l_sql2,p_plant) RETURNING l_sql2 #FUN-A50102  
  PREPARE getazg_pre2 FROM l_sql2
  DECLARE getazg_curs2 CURSOR FOR getazg_pre2

  #轉換營運中心名稱回傳給 EasyFlow 的 SQL
  #LET l_sql = "SELECT azp01 FROM azp_file where azp03 = '",p_plant,"'"  #FUN-A50102
  #PREPARE azp01_pre FROM l_sql  #FUN-A50102
  LET l_azp01 = p_plant   #FUN-A50102

  #依設定作業指定要抓取的key值欄位
  LET l_str = g_wse.wse03 CLIPPED
  IF NOT cl_null(g_wse.wse04) THEN
     LET l_str = l_str CLIPPED,"||'|'||", g_wse.wse04 CLIPPED
  END IF
  IF NOT cl_null(g_wse.wse05) THEN
     LET l_str = l_str CLIPPED,"||'|'||", g_wse.wse05 CLIPPED
  END IF
  IF NOT cl_null(g_wse.wse06) THEN
     LET l_str = l_str CLIPPED,"||'|'||", g_wse.wse06 CLIPPED
  END IF
  IF NOT cl_null(g_wse.wse07) THEN
     LET l_str = l_str CLIPPED,"||'|'||", g_wse.wse07 CLIPPED
  END IF
 
  LET l_sql = "SELECT ",l_str CLIPPED,
              # " FROM ",s_dbstring(p_plant CLIPPED),g_wse.wse02 CLIPPED,
               " FROM ",cl_get_target_table(p_plant,g_wse.wse02), #FUN-A50102
              " WHERE ",g_wse.wse08 CLIPPED,"='Y'",
                " AND ",g_wse.wse10 CLIPPED,"='",p_status,
             "' ORDER BY ",g_wse.wse03 CLIPPED
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102              
  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102             
  PREPARE getdata_pre FROM l_sql
  DECLARE getdata_curs CURSOR FOR getdata_pre
  FOREACH getdata_curs INTO l_key
     IF SQLCA.sqlcode THEN
        DISPLAY "FETCH ",p_plant CLIPPED,":",g_wse.wse02 CLIPPED," failed:",SQLCA.sqlcode
        EXIT FOREACH
     END IF
     INITIALIZE l_record.* TO NULL
     LET l_str = l_key
     #取得單別
     LET l_index = l_str.getIndexOf("-",1)
     IF l_index <> 0 THEN
        LET l_record.sourceFormID = l_str.subString(1,l_index-1)
     END IF
     #取得單號
     LET l_index = l_str.getIndexOf("|",1)
     IF l_index = 0 THEN    #只有 1 個 key
        LET l_record.sourceFormNum = l_str CLIPPED
     ELSE                   #有多個 key
        LET l_tok = base.StringTokenizer.create(l_str, "|")
        LET l_i = 0
        WHILE l_tok.hasMoreTokens()
           LET l_str2 = l_tok.nextToken()
           LET l_i = l_i + 1
           CASE l_i
             WHEN 1
               LET l_record.sourceFormNum = l_str2 CLIPPED
             WHEN 2
               LET l_record.sourceFormNum = l_record.sourceFormNum CLIPPED,
                                            "{+}",g_wse.wse04 CLIPPED,"=",l_str2 CLIPPED
             WHEN 3
               LET l_record.sourceFormNum = l_record.sourceFormNum CLIPPED,
                                            "{+}",g_wse.wse05 CLIPPED,"=",l_str2 CLIPPED
             WHEN 4
               LET l_record.sourceFormNum = l_record.sourceFormNum CLIPPED,
                                            "{+}",g_wse.wse06 CLIPPED,"=",l_str2 CLIPPED
             WHEN 5
               LET l_record.sourceFormNum = l_record.sourceFormNum CLIPPED,
                                            "{+}",g_wse.wse07 CLIPPED,"=",l_str2 CLIPPED
           END CASE
        END WHILE
     END IF
     OPEN getazg_curs USING l_record.sourceFormNum,p_prog
     FETCH getazg_curs INTO l_record.targetSheetNo,l_record.targetFormID
     IF SQLCA.sqlcode THEN
        OPEN getazg_curs2 USING l_record.sourceFormNum
        FETCH getazg_curs2 INTO l_record.targetSheetNo,l_record.targetFormID
        IF SQLCA.sqlcode THEN
           DISPLAY "FETCH azg_file failed : ",p_plant,"-",p_prog,":",l_record.sourceFormNum
           CLOSE getazg_curs
           CLOSE getazg_curs2
           CONTINUE FOREACH
        END IF
        CLOSE getazg_curs2
     END IF
     CLOSE getazg_curs
 
     #EXECUTE azp01_pre INTO l_azp01   #FUN-A50102
      
     #組Record字串
     LET l_record_str = l_record_str CLIPPED,
                        "    <Record plantID =\"",l_azp01 CLIPPED,"\" ",
                        "sourceFormID=\"",l_record.sourceFormID CLIPPED,"\" ",
                        "sourceFormNum=\"",l_record.sourceFormNum CLIPPED,"\" ",
                        "programID=\"",p_prog CLIPPED,"\" ",
                        "targetFormID=\"",l_record.targetFormID CLIPPED,"\" ",
                        "targetSheetNo=\"",l_record.targetSheetNo CLIPPED,"\" />",ASCII 10
  END FOREACH
 
  RETURN l_record_str
END FUNCTION

#[
# Description....: 將 XML 字串轉換為 DomNode
# Date & Author..: 2010/09/15 by Jay
# Parameter......: p_xml   string    #欲轉換 XML 字串
# Return.........: l_node  DomNode   #轉換後的 DomNode
#]
FUNCTION aws_efsrv2_stringToXml(p_xml)
  DEFINE p_xml       STRING
  DEFINE l_ch        base.Channel,
         l_xmlFile   STRING,
         l_doc       om.DomDocument,
         l_node      om.DomNode
 
  IF cl_null(p_xml) THEN
     RETURN NULL
  END IF
 
  #--------------------------------------------------------------------------#
  # String to XML 暫存檔                                                     #
  #--------------------------------------------------------------------------#
  LET l_ch = base.Channel.create()
  LET l_xmlFile = fgl_getenv("TEMPDIR"),"/","aws_efsrv2_xml_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
  CALL l_ch.openFile(l_xmlFile, "w")
  CALL l_ch.setDelimiter("")
  CALL l_ch.write(p_xml)
  CALL l_ch.close()

  #--------------------------------------------------------------------------#
  # 讀取 XML File 建立 Dom Node                                              #
  #--------------------------------------------------------------------------#
  LET l_doc = om.DomDocument.createFromXmlFile(l_xmlFile)
  RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"
  INITIALIZE l_node TO NULL
  IF l_doc IS NOT NULL THEN
     LET l_node = l_doc.getDocumentElement()
  END IF
 
  RETURN l_node
END FUNCTION
#-FUN-960057--end--
#FUN-B20029 -- end --
#FUN-B80064

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
FUNCTION aws_efsrv2_conn_ds()

    WHENEVER ERROR CONTINUE

    TRY
       CALL cl_ins_del_sid(2,'')  #FUN-CB0142
       CLOSE DATABASE             #FUN-CB0142

       DATABASE ds
       CALL cl_ins_del_sid(1,'')
       LET g_conn_ds="Y"
    CATCH
       DISPLAY "Connect to ds failed"
    END TRY
END FUNCTION
#FUN-C70031 end
