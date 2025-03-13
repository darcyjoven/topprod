# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_reort_data.4gl
# Descriptions...: 提供取得報表資料服務
# Date & Author..: 2009/04/02 by Vicky
# Memo...........:
# Modify.........: No.FUN-930132 新建立
# Modify.........: No:FUN-A50022 10/05/10 By Jay 增加他系統代碼欄位wad06, wae14
# Modify.........: No:FUN-A60057 10/06/18 By Jay 增加GetReport Condition條件參數傳遞
#
#}
 
DATABASE ds
 
#FUN-930132
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供取得報表資料服務(入口 function)
# Date & Author..: 2009/04/02 by Vicky
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_report_data()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 取得報表資料                                                             #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_get_report_data_process()
   END IF
 
   IF FGL_GETENV("CRTYPE") = "URL" OR g_status.code <> "0" THEN
      CALL aws_ttsrv_postprocess()           #呼叫服務後置處理程序
   ELSE
      IF FGL_GETENV("CRTYPE") = "XML" AND g_status.code = "0" THEN
         CALL aws_ttsrv_writeResponseLog()   #記錄 Response XML
      END IF
   END IF
 
END FUNCTION
 
#[
# Description....: 取得報表資料
# Date & Author..: 2009/04/02 by Vicky
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_report_data_process()
   DEFINE l_ReportID     LIKE zaw_file.zaw01,
          l_CRtype       STRING,
          l_sql          STRING,
          l_param        DYNAMIC ARRAY OF RECORD
                         name   STRING,
                         value  STRING
                         END RECORD,
          l_return       RECORD
                         url  STRING
                         END RECORD,
          l_wae02        LIKE wae_file.wae02,
          l_wae03        LIKE wae_file.wae03,
          l_wae12        LIKE wae_file.wae12,
          l_wae13        LIKE wae_file.wae13,
          l_wae14        LIKE wae_file.wae14,     # FUN-A50022 新增wae14欄位
          l_zaw03        LIKE zaw_file.zaw03,
          l_zaw08        LIKE zaw_file.zaw08,
          l_zaw10        LIKE zaw_file.zaw10,
          l_cnt,l_cnt2   LIKE type_file.num5,
          l_cnt3,l_cnt4  LIKE type_file.num5,     # FUN-A50022
          i              LIKE type_file.num5,
          l_tb           base.StringBuffer,
          l_ch           base.channel,
          l_str          STRING,
          l_cmd          STRING,
          l_logFile      STRING,
          l_log          STRING,
          l_hardcode_str STRING,
          l_template     LIKE zaa_file.zaa11,
          l_SystemID     LIKE wae_file.wae14      # FUN-A50022 新增wae14欄位
 
   #取得呼叫端指定的報表名稱
   LET l_ReportID = aws_ttsrv_getParameter("reportid")
   IF cl_null(l_ReportID) THEN
      LET g_status.code = "aws-218"     #缺少ReportID參數
      RETURN
   END IF
 
   #取得呼叫端指定的報表格式，未指定或指定錯誤一律回傳 URL 格式
   LET l_CRtype = aws_ttsrv_getParameter("crtype")
   LET l_CRtype = l_CRtype.toUpperCase()
   IF cl_null(l_CRtype) OR (l_CRtype<>"URL" AND l_CRtype<>"XML") THEN
      LET l_CRtype = "URL"
   END IF
   CALL FGL_SETENV("CRTYPE",l_CRtype)
 
   #檢查指定的報表是否在整合報表維護作業(awsi004)已存在
   LET l_SystemID = g_access.application                      # FUN-A50022 新增wae14欄位
   SELECT COUNT(*) INTO l_cnt FROM wae_file
    WHERE wae01 = l_ReportID AND wae13 = g_user AND 
          wae14 = l_SystemID                                  # FUN-A50022 新增wae14欄位
   IF l_cnt = 0 THEN
      SELECT COUNT(*) INTO l_cnt2 FROM wae_file
       WHERE wae01 = l_ReportID AND wae13 = "default"  AND    # FUN-A50022
             wae14 = l_SystemID                               # FUN-A50022 新增wae14欄位
      IF l_cnt2 = 0 THEN
         #----------FUN-A50022 modify start---------------------------------------------
         SELECT COUNT(*) INTO l_cnt3 FROM wae_file
          WHERE wae01 = l_ReportID AND wae13 = g_user  AND 
                wae14 = "default"                              
         IF l_cnt3 = 0 THEN
            SELECT COUNT(*) INTO l_cnt4 FROM wae_file
             WHERE wae01 = l_ReportID AND wae13 = "default"  AND 
                   wae14 = "default"
            IF l_cnt4 = 0 THEN 
         #----------FUN-A50022 modify end-----------------------------------------------
         
               LET g_status.code = "aws-215"
               RETURN
         #----------FUN-A50022 modify start---------------------------------------------
            ELSE
               LET l_wae13 = "default"
               LET l_wae14 = "default"       
            END IF
         ELSE
            LET l_wae13 = g_user
            LET l_wae14 = "default"     
         END IF
         #----------FUN-A50022 modify end-----------------------------------------------   
      ELSE
         LET l_wae13 = "default"
         LET l_wae14 = g_access.application                   # FUN-A50022 新增wae14欄位
      END IF
   ELSE
      LET l_wae13 = g_user                                  # FUN-A50022
      LET l_wae14 = g_access.application                    # FUN-A50022 新增wae14欄位
   END IF

   LET g_condition = aws_ttsrv_getParameter("condition")    # FUN-A60057
 
   #抓取維護作業所設定的參數
   LET l_template = ""
   LET l_sql = "SELECT wae02,wae03,wae12 FROM wae_file",
               " WHERE wae01 = '",l_ReportID,"'",
                " AND wae13 = '",l_wae13,"'",
                " AND wae14 = '",l_wae14,"' ORDER BY wae02 "   # FUN-A50022 新增wae14欄位
   DECLARE c_wae CURSOR FROM l_sql
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
      RETURN
   END IF
   FOREACH c_wae INTO l_wae02,l_wae03,l_wae12
      LET l_param[l_wae02].name = l_wae03
      #抓取CR樣板名稱
      IF l_wae03 = "g_rpt_name" AND cl_null(l_wae12) THEN
         IF cl_null(l_template) THEN
            LET l_template = l_ReportID
         END IF
         #先判斷是否有客製以及行業別設定的資料
         LET l_zaw03 = "Y"
         LET l_zaw10 = g_sma.sma124
         SELECT COUNT(*) INTO l_cnt FROM zaw_file
          WHERE zaw01 = l_ReportID   AND zaw02 = l_template
            AND zaw03 = l_zaw03      AND zaw06 = g_lang
            AND zaw10 = l_zaw10
            AND ((zaw04='default' AND zaw05='default')
             OR zaw04 = g_clas OR zaw05 = g_user)
         IF l_cnt = 0 THEN
            LET l_zaw03 = "N"
            LET l_zaw10 = g_sma.sma124
            SELECT COUNT(*) INTO l_cnt FROM zaw_file
             WHERE zaw01 = l_ReportID   AND zaw02 = l_template
               AND zaw03 = l_zaw03      AND zaw06 = g_lang
               AND zaw10 = l_zaw10
               AND((zaw04='default' AND zaw05='default')
                    OR zaw04 = g_clas   OR zaw05=g_user)
            IF l_cnt = 0 THEN
               LET l_zaw03 = "Y"
               LET l_zaw10 = "std"
               SELECT COUNT(*) INTO l_cnt FROM zaw_file
                WHERE zaw01 = l_ReportID   AND zaw02 = l_template
                  AND zaw03 = l_zaw03      AND zaw06 = g_lang
                  AND zaw10 = l_zaw10
                  AND ((zaw04='default' AND zaw05='default')
                        OR zaw04 = g_clas   OR zaw05=g_user)
               IF l_cnt = 0 THEN
                  LET l_zaw03 = "N"
                  LET l_zaw10 = "std"
                  SELECT COUNT(*) INTO l_cnt FROM zaw_file
                   WHERE zaw01 = l_ReportID   AND zaw02 = l_template
                     AND zaw03 = l_zaw03      AND zaw06 = g_lang
                     AND zaw10 = l_zaw10
                     AND ((zaw04='default' AND zaw05='default')
                           OR zaw04 = g_clas   OR zaw05=g_user)
               END IF
            END IF
         END IF
         IF l_cnt >= 1 THEN
            SELECT COUNT(*) INTO l_cnt2 FROM zaw_file
             WHERE zaw01 = l_ReportID   AND zaw02 = l_template
               AND zaw03 = l_zaw03      AND zaw06 = g_lang
               AND zaw10 = l_zaw10
               AND zaw05 = g_user
            IF l_cnt2 > 0 THEN    #優先考慮抓g_user資料
               LET l_str = "SELECT zaw08 FROM zaw_file",
                           " WHERE zaw01='",l_ReportID,"' AND zaw02='",l_template,
                            "' AND zaw03='",l_zaw03,"' AND zaw06='",g_lang,
                            "' AND zaw10='",l_zaw10,"' AND zaw05='",g_user,"'"
            ELSE
               SELECT COUNT(*) INTO l_cnt2 FROM zaw_file
                WHERE zaw01 = l_ReportID   AND zaw02 = l_template
                  AND zaw03 = l_zaw03      AND zaw06 = g_lang
                  AND zaw10 = l_zaw10
                  AND zaw04 = g_clas
               IF l_cnt2 > 0 THEN   #否則抓此user所屬權限資料
                  LET l_str = "SELECT zaw08 FROM zaw_file",
                              " WHERE zaw01='",l_ReportID,"' AND zaw02='",l_template,
                               "' AND zaw03='",l_zaw03,"' AND zaw06='",g_lang,
                               "' AND zaw10='",l_zaw10,"' AND zaw04='",g_clas,"'"
               ELSE                 #若無g_user也無該權限資料，一律抓default資料
                  LET l_str = "SELECT zaw08 FROM zaw_file",
                              " WHERE zaw01='",l_ReportID,"' AND zaw02='",l_template,
                               "' AND zaw03='",l_zaw03,"' AND zaw06='",g_lang,
                               "' AND zaw10='",l_zaw10,"' AND zaw04='default",
                               "' AND zaw05='default'"
               END IF
            END IF
         END IF
         DISPLAY "sma124:",g_sma.sma124
         DISPLAY "Get CR:",l_str
         PREPARE pre_zaw08 FROM l_str
         EXECUTE pre_zaw08 INTO l_zaw08
         LET l_param[l_wae02].value = l_zaw08
      ELSE
         LET l_param[l_wae02].value = aws_defaultTranslate(l_wae12)
         IF l_param[l_wae02].name = "g_template" THEN
            LET l_template = l_param[l_wae02].value
         END IF
      END IF
   END FOREACH
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
      RETURN
   END IF
 
   #抓取 hardcode 程式預設值
   CALL aws_get_report_hardcode(l_ReportID) RETURNING l_hardcode_str
   FOR i = 1 TO l_param.getLength()
       LET l_wae12 = aws_xml_getTag(l_hardcode_str,l_param[i].name)
       IF NOT cl_null(l_wae12) THEN
          LET l_param[i].value = l_wae12
       END IF
   END FOR
 
   #配置語言別為client端指定的語言
   UPDATE zx_file SET zx06 = g_lang WHERE zx01 = g_user
 
   #指定 URL 及 XML 要寫入檔案
   LET l_logFile = FGL_GETENV("TEMPDIR"),"/","GetReport-",FGL_GETPID() USING '<<<<<<<<<<',".log"
   CALL FGL_SETENV("XMLFILE",l_logFile)
DISPLAY "l_logFile: ", l_logFile, " || END;" 
   #組 cmdrun 指令
   LET l_cmd = l_ReportID
   FOR i = 1 TO l_param.getLength()
       #LET l_cmd = l_cmd, " '", l_param[i].value, "'"     #FUN-A60057 mark
       LET l_cmd = l_cmd, ' "', l_param[i].value, '"'      #FUN-A60057
   END FOR
   DISPLAY "CRtype:",l_CRtype
   DISPLAY "l_cmd:",l_cmd
   CALL cl_cmdrun_wait(l_cmd)
   CALL aws_ttsrv_cmdrun_checkStatus(l_ReportID)
   IF g_status.code <> '0' THEN
      RETURN
   END IF
 
   LET l_str = ""
   LET l_tb = base.StringBuffer.create()
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(l_logFile,"r")
   CALL l_ch.setDelimiter("")
   WHILE l_ch.read(l_str)
         CALL l_tb.append(l_str CLIPPED)
         CALL l_tb.append(ASCII 10)
   END WHILE
   CALL l_ch.close()
   LET l_log = l_tb.toString()
   RUN "rm -f " || l_logFile || " 2>/dev/null 2>&1"
 
   IF l_CRtype = "URL" THEN
      LET l_return.url = l_log
      CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))  #回傳URL
   ELSE
      LET g_response.response = l_log      #回傳 XML 字串
   END IF
 
END FUNCTION
