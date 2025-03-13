# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: cl_report_xml.4gl
# Descriptions...: 將報表資料組成 XML 格式
# Usage..........: call cl_report_xml(p_prog,p_temptable)
# Input parameter: p_prog       報表名稱
#                : p_temptable  TempTable名稱
# Return code....: none
# Date & Author..: 09/04/01 by Vicky
# Modify.........: No.FUN-930132 09/04/01 by Vicky 新建立
 
DATABASE ds
 
#FUN-930132
 
GLOBALS "../../config/top.global"
 
DEFINE g_reportID     LIKE gcz_file.gcz01,
       g_tablename    STRING,
       g_gcz02        LIKE gcz_file.gcz02,
       g_data_string  STRING
 
##################################################
# Descriptions...: 將報表資料組成為 XML 格式
# Date & Author..: 2009/04/01 By Vicky
# Input parameter: p_prog       報表名稱
#                : p_temptable  TempTable名稱
# Return code....: none
##################################################
FUNCTION cl_report_xml(p_prog,p_temptable)
   DEFINE p_prog      LIKE gcz_file.gcz01,
          p_temptable STRING,
          l_cnt       LIKE type_file.num5,
          l_logFile   STRING,
          l_ch        base.Channel
 
   LET g_reportID = p_prog
   LET g_tablename = p_temptable
 
   #--------------------------------------------------------------------------#
   # 判斷是否有客製                                                           #
   #--------------------------------------------------------------------------#
   SELECT COUNT(*) INTO l_cnt FROM gcz_file
    WHERE gcz01 = g_reportID
      AND gcz02 = 'Y'
   IF l_cnt <> '0' THEN
      LET g_gcz02 = "Y"
   ELSE
      LET g_gcz02 = "N"
   END IF
 
   #--------------------------------------------------------------------------#
   # 依據不同服務組成不同格式的 XML 字串                                                           #
   #--------------------------------------------------------------------------#
   IF FGL_GETENV("TPGateWay") = '1' THEN
      CALL cl_GetReportData_xml()
   ELSE
      CALL cl_TIPTOPGateWay_xml()
   END IF
 
   #--------------------------------------------------------------------------#
   # 將組好的 XML 字串寫入服務指定的 "GetReport-" + "PID".log 中              #
   #--------------------------------------------------------------------------#
   LET l_logFile = FGL_GETENV("XMLFILE")
   LET l_ch = base.Channel.create()
   CALL l_ch.setDelimiter("")
   CALL l_ch.openFile(l_logFile, "a")
   CALL l_ch.write(g_data_string)
   CALL l_ch.close()
 
END FUNCTION
 
 
##################################################
# Descriptions...: 報表資料組成符合[TIPTOPGateWay]服務的 XML 格式
# Date & Author..: 2009/04/01 By Vicky
# Input Parameter:
# Return code....:
##################################################
FUNCTION cl_TIPTOPGateWay_xml()
   DEFINE l_gcz07     LIKE gcz_file.gcz07,
          l_gcz08     LIKE gcz_file.gcz08,
          l_sql       STRING,
          l_temp_sql  STRING,
          l_dataset   STRING,                 #<DataSet>字串
          l_field     STRING,                 #<DataSet>的 Field 屬性
          l_name      STRING,                 #<DataSet>的 Name  屬性
          l_type      STRING,                 #<DataSet>的 Type  屬性
          l_get_type  LIKE type_file.chr20,
          l_get_len   STRING,
          l_data      LIKE type_file.chr1000, #<Row>的 Data 屬性值
          l_len       LIKE type_file.num10
 
   DISPLAY "Service:TIPTOPGateWay_GetReport"
   #--------------------------------------------------------------------------#
   # 取得欄位代號、欄位名稱、欄位型態                                         #
   #--------------------------------------------------------------------------#
   LET l_sql = "SELECT gcz07,gcz08 FROM gcz_file",
               " WHERE gcz01='", g_reportID, "'",
               " AND gcz02='", g_gcz02, "'",
               " AND gcz03='default'",
               " AND gcz04='default'",
               " AND gcz06='", g_lang, "'"
   PREPARE gcz_pre FROM l_sql
   DECLARE gcz_curs CURSOR FOR gcz_pre
   FOREACH gcz_curs INTO l_gcz07,l_gcz08
      LET l_temp_sql = l_temp_sql CLIPPED, l_gcz07 CLIPPED, "||", "'^*^'", "||"
      LET l_field = l_field CLIPPED, l_gcz07 CLIPPED, "^*^"
      LET l_name = l_name CLIPPED, l_gcz08 CLIPPED, "^*^"
      CALL cl_get_column_info("ds_report",g_tablename,l_gcz07 CLIPPED) RETURNING l_get_type,l_get_len
      LET l_type = l_type CLIPPED, cl_change_col_type(l_get_type), "^*^"
   END FOREACH
 
   #-- 刪除多餘的符號 --#
   LET l_len = l_field.getLength()
   LET l_field = l_field.subString(1,l_len-3)
   LET l_field = "Field=\"", l_field, "\""
 
   LET l_len = l_name.getLength()
   LET l_name = l_name.subString(1,l_len-3)
   LET l_name = "Name=\"", l_name, "\""
 
   LET l_len = l_type.getLength()
   LET l_type = l_type.subString(1,l_len-3)
   LET l_type = "Type=\"", l_type, "\""
 
   #-- 組 <DataSet> 字串 --#
   LET l_dataset = "<DataSet ",l_field," ",l_name, " ",l_type,">\n"
 
   #--------------------------------------------------------------------------#
   # 抓取 Temptable 資料，並組成 XML 字串                                     #
   #--------------------------------------------------------------------------#
   LET l_len = l_temp_sql.getLength()
   LET l_temp_sql = l_temp_sql.subString(1,l_len-9)
   LET l_temp_sql = "SELECT ", l_temp_sql, " FROM ", g_cr_db_str, g_tablename
   DISPLAY l_temp_sql
   PREPARE tempdata_pre FROM l_temp_sql
   DECLARE tempdata_curs CURSOR FOR tempdata_pre
   FOREACH tempdata_curs INTO l_data
      LET l_dataset = l_dataset CLIPPED, "<Row Data=\"", l_data,"\"/>\n"
   END FOREACH
 
   LET l_dataset = l_dataset CLIPPED, "</DataSet>\n"
 
   LET g_data_string = l_dataset
END FUNCTION
 
##################################################
# Descriptions...: 報表資料組成符合[aws_GetReportData]服務的 XML 格式
# Date & Author..: 2009/04/01 By Vicky
# Input Parameter:
# Return code....:
##################################################
FUNCTION cl_GetReportData_xml()
   DEFINE l_response     STRING,               #Response 字串
          l_record_set   STRING,               #<RecordSet> 字串
          l_field        STRING,               #<Field> 字串列
          l_value        STRING,
          l_sql          STRING,
          l_temp_sql     STRING,
          l_field_arr    DYNAMIC ARRAY OF RECORD
            name         LIKE gcz_file.gcz07,
            desc         LIKE gcz_file.gcz08,
            type         LIKE type_file.chr1
          END RECORD,    
          l_data         LIKE type_file.chr1000,
          l_len          LIKE type_file.num10,
          l_get_type     LIKE type_file.chr20,
          l_get_len      STRING,
          l_str          STRING,
          l_gcz07        LIKE gcz_file.gcz07,
          l_gcz08        LIKE gcz_file.gcz08,
          l_count,l_i    LIKe type_file.num10,
          l_start,l_pos  LIKE type_file.num10
 
   DISPLAY "Service:aws_GetReportData"
   #--------------------------------------------------------------------------#
   # 取得欄位代號、欄位名稱、欄位型態                                         #
   #--------------------------------------------------------------------------#
   LET l_sql = "SELECT gcz07,gcz08 FROM gcz_file",
               " WHERE gcz01='", g_reportID, "'",
               " AND gcz02='", g_gcz02, "'",
               " AND gcz03='default'",
               " AND gcz04='default'",
               " AND gcz06='", g_lang, "'"
   PREPARE gcz_pre2 FROM l_sql
   DECLARE gcz_curs2 CURSOR FOR gcz_pre2
   LET l_i = 1
   FOREACH gcz_curs2 INTO l_gcz07,l_gcz08
      LET l_temp_sql = l_temp_sql CLIPPED, l_gcz07 CLIPPED, "||", "'^*^'", "||"
      LET l_field_arr[l_i].name = l_gcz07 CLIPPED
      LET l_field_arr[l_i].desc = l_gcz08 CLIPPED
      CALL cl_get_column_info("ds_report",g_tablename,l_gcz07 CLIPPED) RETURNING l_get_type,l_get_len
      LET l_field_arr[l_i].type = cl_change_col_type(l_get_type)
      LET l_i = l_i + 1
   END FOREACH
   CALL l_field_arr.deleteElement(l_i)
 
   #--------------------------------------------------------------------------#
   # 抓取 Temptable 資料，並組成 XML 字串                                     #
   #--------------------------------------------------------------------------#
   LET l_len = l_temp_sql.getLength()
   LET l_temp_sql = l_temp_sql.subString(1,l_len-2)
   LET l_temp_sql = "SELECT ", l_temp_sql, " FROM ", g_cr_db_str, g_tablename
   DISPLAY l_temp_sql
   PREPARE tempdata_pre2 FROM l_temp_sql
   DECLARE tempdata_curs2 CURSOR FOR tempdata_pre2
   LET l_count = 1
   FOREACH tempdata_curs2 INTO l_data
      LET l_str = l_data CLIPPED
      LET l_field = ""
      LET l_i = 1
      LET l_start = 1
      LET l_pos = l_str.getIndexOf("^*^",1)
      WHILE l_pos > 0
         LET l_value = l_str.subString(l_start,l_pos-1)
         IF l_count = 1 THEN
            LET l_field = l_field CLIPPED,
                          "      <Field name=\"", l_field_arr[l_i].name CLIPPED, "\" ",
                          "desc=\"", l_field_arr[l_i].desc CLIPPED, "\" ",
                          "type=\"", l_field_arr[l_i].type CLIPPED, "\" ",
                          "value=\"", l_value CLIPPED, "\"/>\n"
         ELSE
            LET l_field = l_field CLIPPED,
                         "      <Field name=\"", l_field_arr[l_i].name CLIPPED, "\" ",
                         "value=\"", l_value CLIPPED, "\"/>\n"
         END IF
         LET l_start = l_pos + 3
         LET l_pos = l_str.getIndexOf("^*^",l_start)
         LET l_i = l_i +1
      END WHILE
      LET l_record_set = l_record_set CLIPPED,
                         "   <ResordSet id=\"", l_count USING '<<<<<', "\">\n",
                         "    <Master name=\"", g_tablename, "\">\n",
                         "     <Record>\n",
                         l_field,
                         "     </Record>\n",
                         "    </Master>\n",
                         "   </RecordSet>\n"
      LET l_count = l_count + 1
   END FOREACH
 
   LET l_response = "<Response>\n",
                   " <Execution>\n",
                   "  <Status code=\"0\" sqlcode=\"0\" description=\"\"/>\n",
                   " </Execution>\n",
                   " <ResponseContent>\n",
                   "  <Parameter/>\n",
                   "  <Document>\n",
                   l_record_set,
                   "  </Document>\n",
                   " </ResponseContent>\n",
                   "</Response>"
 
   LET g_data_string = l_response
 
END FUNCTION
 
##################################################
# Descriptions...: 將欄位型態轉換為以數字表示
# Date & Author..: 2009/04/01 By Vicky
# Input Parameter: p_type   String  #欄位型態
# Return code....: l_type   String  #數字表示的欄位型態
##################################################
FUNCTION cl_change_col_type(p_type)
   DEFINE p_type  LIKE type_file.chr20,
          l_type  LIKE type_file.chr1
   CASE
      #1:String
      WHEN p_type="varchar2" OR p_type="char"
           LET l_type = "1"
      #2:Number
      WHEN p_type="number" OR p_type="smallint"
        OR p_type="integer" OR p_type="decimal"
           LET l_type = "2"
      #3:Date
      WHEN p_type="date" OR p_type="datetime"
           LET l_type = "3"
      OTHERWISE
           LET l_type = "0"
   END CASE
 
   RETURN l_type
END FUNCTION
