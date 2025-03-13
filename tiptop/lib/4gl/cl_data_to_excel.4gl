# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name...: cl_data_to_excel.4gl
# Descriptions...: 將資料匯出至 MS Excel
# Date & Author..: 2009/04/17
# Usage..........: CALL cl_data_to_excel(p_sql)
# Modify.........: No.FUN-980097 09/08/21 By alex 合併wos回4gl
# Modify.........: No.FUN-A90047 10/09/15 By Echo 改善效能，指定 <tr> 高度值可減少開啟excel時間
# Modify.........: No.FUN-AA0074 11/02/14 By Jay 列印轉excel格式會無法顯示千分位
# Modify.........: No.FUN-AC0011 11/03/04 By Jay 調整截取欄位名稱方式
# Modify.........: No.MOD-BB0322 11/11/29 By suncx 修改對於field_name的判斷
# Modify.........: No.MOD-C90045 12/10/04 By LeoChang 修正使用別名會無法判斷造成欄位無資料的問題
 
IMPORT os          #FUN-980097
DATABASE ds 
 
GLOBALS "../../config/top.global"
 
GLOBALS
   DEFINE ms_codeset      STRING    
   DEFINE ms_locale       STRING    
   DEFINE g_query_prog    LIKE gcy_file.gcy01    #查詢單ID 
   DEFINE g_query_cust    LIKE gcy_file.gcy02    #客製否   
   DEFINE g_query_grup    LIKE gcy_file.gcy03    #群組
   DEFINE g_query_user    LIKE gcy_file.gcy04    #使用者
   DEFINE ga_table_data   DYNAMIC ARRAY OF RECORD
          field001, field002, field003, field004, field005, field006, field007,
          field008, field009, field010, field011, field012, field013, field014,
          field015, field016, field017, field018, field019, field020, field021,
          field022, field023, field024, field025, field026, field027, field028,
          field029, field030, field031, field032, field033, field034, field035,
          field036, field037, field038, field039, field040, field041, field042,
          field043, field044, field045, field046, field047, field048, field049,
          field050, field051, field052, field053, field054, field055, field056,
          field057, field058, field059, field060, field061, field062, field063,
          field064, field065, field066, field067, field068, field069, field070,
          field071, field072, field073, field074, field075, field076, field077,
          field078, field079, field080, field081, field082, field083, field084,
          field085, field086, field087, field088, field089, field090, field091,
          field092, field093, field094, field095, field096, field097, field098,
          field099, field100 STRING
                  END RECORD
   DEFINE g_feld_id       DYNAMIC ARRAY OF LIKE type_file.chr1000           
   DEFINE g_gcz    DYNAMIC ARRAY OF RECORD
                      gcz05   LIKE gcz_file.gcz05,
                      gcz07   LIKE gcz_file.gcz07,
                      gcz08   LIKE gcz_file.gcz08,
                      gcz10   LIKE gcz_file.gcz10,
                      gcz11   LIKE gcz_file.gcz11,
                      gcz12   LIKE gcz_file.gcz12
                   END RECORD
END GLOBALS
   DEFINE  g_hidden        DYNAMIC ARRAY OF LIKE type_file.chr1,     #No.FUN-690005 VARCHAR(1),  ### MOD-580022 ### 
           g_ifchar        DYNAMIC ARRAY OF LIKE type_file.chr1,     #No.FUN-690005 VARCHAR(1),  ### FUN-570128 ### 
           g_quote         STRING     ### FUN-570128 ### 
   DEFINE  tsconv_cmd      STRING     ### TQC-5C0124 ###
 
   DEFINE  l_channel       base.Channel,
           l_str           STRING,
           l_cmd,xls_name  STRING,
           cnt_header      LIKE type_file.num10    ### TQC-690088 ### 
 
FUNCTION cl_data_to_excel(p_sql)
 DEFINE  p_sql                     STRING
 DEFINE  t,n1_text,n3_text         om.DomNode,
         n,n2,n_child                    om.DomNode,
         n1,n_table,n3                   om.NodeList,
         #i,cnt_header,res,p,q,k         LIKE type_file.num10,    #No.FUN-690005 integer,    ### MOD-580022 ### ### TQC-690088 ### 
         i,res,p,q,k                     LIKE type_file.num10,    #No.FUN-690005 integer,    ### MOD-580022 ### ### TQC-690088 ###
         h,cnt_cell,tmp_cnt              LIKE type_file.num10,    #No.FUN-690005 integer,    ### FUN-570216 ###
         cnt_combo_data,cnt_combo_tot    LIKE type_file.num10,    #No.FUN-690005 integer, 
         cells,values,j,l,sheet,cc       STRING, 
         table_name,field_name,l_length  STRING,     ### FUN-570128 ###
         l_table_name                    LIKE gac_file.gac05,      ### FUN-570128 ###        ### TQC-690088 ###
         l_field_name                    LIKE gac_file.gac06,      ### TQC-690088 ###
         l_datatype                      LIKE type_file.chr20,    #No.FUN-690005 VARCHAR(15),   ### FUN-570128 ###
         l_bufstr                        base.StringBuffer,
         lwin_curr                       ui.Window,
         l_show                          LIKE type_file.chr1,     #No.FUN-690005 VARCHAR(1),
         l_time                          LIKE type_file.chr8,     #No.FUN-690005 VARCHAR(8)
         l_sql                           STRING
 DEFINE  l_seq            DYNAMIC ARRAY OF LIKE type_file.num10  #TQC-690124
 
 DEFINE  customize_table  LIKE type_file.chr1      #No.FUN-690005 VARCHAR(1)             ### TQC-610020 ###
 DEFINE  l_str            STRING                   ### TQC-610020 ###
 DEFINE  l_i              LIKE type_file.num5      ### TQC-610020 ###    #No.FUN-690005 SMALLINT
 DEFINE  buf              base.StringBuffer        ### FUN-660011 ###
 DEFINE  l_dec_point      STRING,                  ### FUN-670054 ###
         l_qry_name       LIKE gab_file.gab01,     ### TQC-690088 ###
         l_cust           LIKE gab_file.gab11      ### TQC-690088 ###
 DEFINE  l_tabIndex       LIKE type_file.num10                   #TQC-690124
 DEFINE  l_j              LIKE type_file.num5      #TQC-790109
 DEFINE  bFound           LIKE type_file.num5      #TQC-790109
 DEFINE  l_dbname         STRING                   #No.FUN-810062
 DEFINE  l_num1           LIKE type_file.num5   #MOD-C90045 add
 DEFINE  l_num2           LIKE type_file.num5   #MOD-C90045 add
 DEFINE  l_str1           STRING                #MOD-C90045 add
 
   WHENEVER ERROR CALL cl_err_msg_log             #No.FUN-860089
 
   #產生 CR 報表資料, N: show Field Name, 2: 以 p_crview_set 設定的欄位名稱
   CALL cl_query_dbqry_sel(p_sql,"N","2")  
 
   LET g_quote = """"    
 
   LET t = base.TypeInfo.create(ga_table_data)
 
   LET l_bufstr = base.StringBuffer.create()
 
   LET l_channel = base.Channel.create()
   LET l_time = TIME(CURRENT)
   LET xls_name = g_prog CLIPPED,l_time CLIPPED,".xls"
 
   LET buf = base.StringBuffer.create()
   CALL buf.append(xls_name)
   CALL buf.replace( ":","-", 0)
   LET xls_name = buf.toString()
 
#  LET l_cmd = "rm ",xls_name CLIPPED," 2>/dev/null"
#  RUN l_cmd
   IF os.Path.delete(xls_name CLIPPED) THEN    #FUN-980097
   END IF
 
   CALL l_channel.openFile( xls_name CLIPPED, "a" )
   CALL l_channel.setDelimiter("")
 
   IF ms_codeset.getIndexOf("BIG5", 1) OR
      ( ms_codeset.getIndexOf("GB2312", 1) OR ms_codeset.getIndexOf("GBK", 1) OR ms_codeset.getIndexOf("GB18030", 1) ) THEN
      IF ms_locale = "ZH_TW" AND g_lang = '2' THEN
         LET tsconv_cmd = "big5_to_gb2312"
         LET ms_codeset = "GB2312"
      END IF
      IF ms_locale = "ZH_CN" AND g_lang = '0' THEN
         LET tsconv_cmd = "gb2312_to_big5"
         LET ms_codeset = "BIG5"
      END IF
   END IF
 
   LET l_str = "<html xmlns:o=",g_quote,"urn:schemas-microsoft-com:office:office",g_quote
   CALL l_channel.write(l_str CLIPPED)
   LET l_str = "<meta http-equiv=Content-Type content=",g_quote,"text/html; charset=",ms_codeset,g_quote,">"
   CALL l_channel.write(l_str CLIPPED)
   LET l_str = "xmlns:x=",g_quote,"urn:schemas-microsoft-com:office:excel",g_quote
   CALL l_channel.write(l_str CLIPPED)
   LET l_str = "xmlns=",g_quote,"http://www.w3.org/TR/REC-html40",g_quote,">"
   CALL l_channel.write(l_str CLIPPED)
   CALL l_channel.write("<head><style><!--")
   #CALL l_channel.write("td  {font-family:新細明體, serif;}")  #TQC-810089 mark
   ### TQC-810089 START ###
   IF not ms_codeset.getIndexOf("UTF-8", 1) THEN
      IF g_lang = "0" THEN  #繁體中文
         CALL l_channel.write("td  {font-family:細明體, serif;}")
      ELSE
         IF g_lang = "2" THEN  #簡體中文
            CALL l_channel.write("td  {font-family:新宋体, serif;}")
         ELSE
            CALL l_channel.write("td  {font-family:細明體, serif;}")
         END IF
      END IF
   ELSE
      CALL l_channel.write("td  {font-family:Courier New, serif;}")
   END IF
 
   LET l_str = ".xl24  {mso-number-format:",g_quote,"\@",g_quote,";}",
               ".xl30 {mso-style-parent:style0; mso-number-format:\"0_ \";} ",
               ".xl31 {mso-style-parent:style0; mso-number-format:\"0\.0_ \";} ",
               ".xl32 {mso-style-parent:style0; mso-number-format:\"0\.00_ \";} ",
               ".xl33 {mso-style-parent:style0; mso-number-format:\"0\.000_ \";} ",
               ".xl34 {mso-style-parent:style0; mso-number-format:\"0\.0000_ \";} ",
               ".xl35 {mso-style-parent:style0; mso-number-format:\"0\.00000_ \";} ",
               ".xl36 {mso-style-parent:style0; mso-number-format:\"0\.000000_ \";} ",
               ".xl37 {mso-style-parent:style0; mso-number-format:\"0\.0000000_ \";} ",
               ".xl38 {mso-style-parent:style0; mso-number-format:\"0\.00000000_ \";} ",
               ".xl39 {mso-style-parent:style0; mso-number-format:\"0\.000000000_ \";} ",
               ".xl40 {mso-style-parent:style0; mso-number-format:\"0\.0000000000_ \";} ",
               #FUN-AA0074 -- start --
               ".xl50 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0_ \";} ",
               ".xl51 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.0_ \";} ",
               ".xl52 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.00_ \";} ",
               ".xl53 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.000_ \";} ",
               ".xl54 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.0000_ \";} ",
               ".xl55 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.00000_ \";} ",
               ".xl56 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.000000_ \";} ",
               ".xl57 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.0000000_ \";} ",
               ".xl58 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.00000000_ \";} ",
               ".xl59 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.000000000_ \";} ",
               ".xl60 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.0000000000_ \";} "
               #FUN-AA0074 -- start --

   CALL l_channel.write(l_str CLIPPED)
   CALL l_channel.write("--></style>")
   CALL l_channel.write("<!--[if gte mso 9]><xml>")
   CALL l_channel.write("<x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>")
   CALL l_channel.write("<x:DefaultRowHeight>330</x:DefaultRowHeight>")
   CALL l_channel.write("</xml><![endif]--></head>")
   CALL l_channel.write("<body><table border=1 cellpadding=0 cellspacing=0 width=432 style='border-collapse: collapse;table-layout:fixed;width:324pt'>")
   CALL l_channel.write("<tr height=22>")        #No.FUN-A90047
 
   CALL g_hidden.clear()     ### MOD-580022 ###   
   CALL g_ifchar.clear()     ### FUN-570128 ###   
 
   LET l = h
   LET sheet="Sheet" CLIPPED,l
   LET cnt_combo_data = 0       ###該comboBox資料的個數
   LET cnt_combo_tot = 0   ###總comboBox資料的個數
   LET k = 0                       ### MOD-580022 ### 
 
   #SELECT COUNT(*) INTO cnt_header FROM gcz_file
   #  AND gcz01 = g_query_prog AND gcz02 = g_query_cust
   #  AND gcz03 = g_query_grup AND gcz04 = g_query_user
   #  AND gcz06 = g_rlang
   #IF cnt_header > 0 THEN
   #   LET l_sql = "SELECT gcz05,gcz07,gcz08,gcz10,gcz11,gcz12 FROM gcz_file",
   #               " WHERE gcz01 = '",g_query_prog CLIPPED,"'",
   #               "   AND gcz03 = '",g_query_grup CLIPPED,"'",
   #               "   AND gcz04 = '",g_query_user CLIPPED,"'",
   #               "   AND gcz06 = '",g_rlang CLIPPED,"'",
   #   DECLARE gcz_cs CURSOR FROM l_sql
   #   FOREACH gcz_cs INTO l_gcz[l_i].gcz05,l_gcz[l_i].gcz07,l_gcz[l_i].gcz08,
   #                       l_gcz[l_i].gcz10,l_gcz[l_i].gcz11,l_gcz[l_i].gcz12
   #       FOR l_j = 1 TO g_feld_id.getLength()
   #           IF l_gcz[l_i].gcz07 = g_feld_id[l_j] THEN
   #              LET l_seq[l_i] = l_j
   #           END IF
   #       END FOR
   #       LET l_i = l_i + 1
   #   END FOREACH
   #   CALL l_gcz.deleteElement(l_i)
   #
   #END IF
   LET cnt_header = g_gcz.getLength()
   FOR i=1 to cnt_header
      LET k = k + 1                
      LET n3 = "" 
      LET field_name = g_gcz[i].gcz07 CLIPPED   #FUN-AC0011
 
      #欄位順序
      FOR l_j = 1 TO g_feld_id.getLength()
          LET l_str1 = g_feld_id[l_j]   #MOD-C90045 add
          LET l_num1 = l_str1.getIndexOf(field_name,1) + field_name.getlength()   #MOD-C90045 add
          LET l_num2 = ORD(l_str1.getCharAt(l_num1))   #MOD-C90045 add
          #IF g_gcz[i].gcz07 = g_feld_id[l_j] THEN   #FUN-AC0011 mark 因為在p_crdate_set的gcz設定欄位代號可能有帶table名稱,如:nni_file.nni01
          #IF field_name.getIndexOf(g_feld_id[l_j], 1) > 0 THEN   #FUN-AC0011  #MOD-BB0322 mark
          #IF field_name.equals(g_feld_id[l_j]) THEN  #MOD-BB0322 add #MOD-C90045 mark
          IF l_str1.getIndexOf(field_name,1) > 0 AND (cl_null(l_num2) OR NOT (l_num2 >47 AND l_num2 <58)) THEN #MOD-C90045 add
             LET l_seq[i] = l_j
             EXIT FOR
          END IF
      END FOR
      IF g_gcz[i].gcz12 = 'N' OR g_gcz[i].gcz12 IS NULL THEN 
         LET values = g_gcz[i].gcz08
         #---FUN-AC0011---start-----
         #因為在p_crdate_set的gcz設定欄位代號可能有帶table名稱,如:nni_file.nni01,就會造成field名稱和table名稱
         #LET field_name = g_gcz[i].gcz07 CLIPPED   #已移到前面做過了
         IF field_name.getIndexOf('_file.', 1) > 0 THEN
            LET field_name = field_name.subString(field_name.getIndexOf('_file.', 1)+6, field_name.getLength())
         END IF
         #---FUN-AC0011---end-------
         LET l_table_name = cl_get_table_name(field_name)
         CASE
          WHEN  g_gcz[i].gcz11 MATCHES "[JKLMNOPQRST]" 
              LET g_ifchar[i] = "1"
          WHEN  g_gcz[i].gcz11 MATCHES "[ABCDEF]"
              LET g_ifchar[i] = "A"
          OTHERWISE
              LET g_ifchar[i] = NULL
         END CASE
         IF g_ifchar[i] IS NULL THEN 
            CASE cl_db_get_database_type()
              WHEN "MSV"
                 LET l_dbname =  FGL_GETENV('MSSQLAREA'),'_ds'
              OTHERWISE
                 LET l_dbname = 'ds'
            END CASE
            CALL cl_get_column_info(l_dbname,l_table_name,field_name) 
                 RETURNING l_datatype,l_length
            IF l_datatype = "varchar2" OR l_datatype = "char" OR 
               l_datatype = "date" OR l_datatype="datetime"       #No.FUN-810062
            THEN
               LET g_ifchar[i] = "1"
            ELSE  
               IF l_datatype = "number" OR l_datatype = "decimal" THEN
                  LET l_dec_point = l_length.substring(l_length.getIndexOf(",",1)+1,l_length.getlength())                     
                  IF l_dec_point = "1" THEN ## 1被字串用了,用A取代 ##
                     LET g_ifchar[i] = "A"
                  ELSE
                     IF l_dec_point = "10" THEN ##最多只會有10位小數 ##
                        LET g_ifchar[i] = "B"
                     ELSE
                        LET g_ifchar[i] = l_dec_point 
                     END IF
                  END IF
               END IF
            ### FUN-670054 END ###
            END IF
         END IF
         CALL l_bufstr.clear()
         CALL l_bufstr.append(values)
         CALL l_bufstr.replace("+","'+",0)
         CALL l_bufstr.replace("-","'-",0)
         CALL l_bufstr.replace("=","'=",0)
         LET values = l_bufstr.tostring()
         LET l_str = "<td>",values,"</td>"
         CALL l_channel.write(l_str CLIPPED)
         LET g_hidden[i] = "0"
      ELSE    
         LET g_hidden[i] = "1"
         LET k = k -1  
      END IF
 
   END FOR
   CALL cl_data_get_body(cnt_header,t,l_seq) 
 
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...:
# Memo...........:
# Input parameter: 
# Return code....:            
FUNCTION cl_data_get_body(p_cnt_header,s,p_seq) 
 DEFINE  p_seq            DYNAMIC ARRAY OF LIKE type_file.num10  #TQC-690124
 DEFINE  s,n1_text                          om.DomNode,
         n1                                 om.NodeList,
         i,m,k,cnt_body,res,p               LIKE type_file.num10,    #No.FUN-690005 integer,
         l_hidden_cnt,n,l_last_hidden       LIKE type_file.num10,    #No.FUN-690005 integer,  ### MOD-580022 ###
         p_cnt_header,arr_len           LIKE type_file.num10,    #No.FUN-690005 integer,
         p_null                             LIKE type_file.num10,    ### TQC-690088 ###
         cells,values,j,l,sheet             STRING,
         l_bufstr                           base.StringBuffer
 
 DEFINE  l_item         LIKE type_file.num10     #TQC-690124     #FUN-6B0098
 
 DEFINE  unix_path      STRING,                  #FUN-660011
         window_path    STRING                   #FUN-660011
 DEFINE  l_dom_doc      om.DomDocument,          ### TQC-690088 ###
         r,n_node       om.DomNode               ### TQC-690088 ###  
 DEFINE  nl_record      om.NodeList
 DEFINE  n_record       om.DomNode
 DEFINE  l_status       LIKE type_file.num5      #No.FUN-860089
 DEFINE  l_dec          LIKE type_file.num5      #FUN-AA0074
 
   LET l_hidden_cnt = 0  
   LET sheet="Sheet1"
   LET l_bufstr = base.StringBuffer.create()
 
   LET nl_record = s.selectByTagName("Record")
 
   FOR k = 1 TO nl_record.getLength()
       LET n_record = nl_record.item(k)
       LET n1 = n_record.selectByTagName("Field")
       LET m = 0
       FOR i= 1 to cnt_header
          IF g_hidden[i] = '1' THEN 
             CONTINUE FOR 
          END IF
          LET n1_text = n1.item(p_seq[i])
          
          LET values = n1_text.getAttribute("value")
          IF cl_null(values) then
             LET values=" "
          ELSE    ###combo一定有值
             CALL l_bufstr.clear()
             CALL l_bufstr.append(values)
             CALL l_bufstr.replace("\n",",",0)
             LET values = l_bufstr.tostring()
          END IF
          IF m = 0 THEN
             LET m = 1
             CALL l_channel.write("</tr><tr height=22>")     #No.FUN-A90047
          END IF    
          IF g_ifchar[i] is null THEN
             LET l_str = "<td>",values,"</td>"
          ELSE
             IF g_ifchar[i] = "1" THEN
                LET l_str = "<td class=xl24>",values,"</td>"
             ELSE
                #FUN-AA0074 -- start --
                IF values.getIndexOf(".", 1) > 0 THEN
                   LET l_dec = values.getlength() - values.getIndexOf(".", 1)
                ELSE
                   LET l_dec = 0
                END IF

                CASE
                   WHEN g_gcz[i].gcz11 MATCHES "[ABDEF]"
                      IF l_dec = "10" THEN ##最多只會有10位小數 ##
                         LET l_str = "<td class=xl60>",values,"</td>"
                      ELSE
                         LET l_str = "<td class=xl5",l_dec USING '<<<<<<<<<<',">",values,"</td>"
                      END IF

                   WHEN g_gcz[i].gcz11 MATCHES "[C]"
                      IF l_dec = "10" THEN ##最多只會有10位小數 ##
                         LET l_str = "<td class=xl40>",values,"</td>"
                      ELSE
                         LET l_str = "<td class=xl3",l_dec USING '<<<<<<<<<<',">",values,"</td>"
                      END IF
                   OTHERWISE
                   #FUN-AA0074 -- end ---- 
                      IF g_ifchar[i] = "A" THEN ## 1被字串用了,用A取代 ##
                         LET l_str = "<td class=xl31>",values,"</td>"
                      ELSE
                         IF g_ifchar[i] = "10" THEN ##最多只會有10位小數 ##
                            LET l_str = "<td class=xl40>",values,"</td>"
                         ELSE
                            LET l_str = "<td class=xl3",g_ifchar[i] USING '<<<<<<<<<<',">",values,"</td>"
                         END IF
                      END IF
                END CASE   #FUN-AA0074
             END IF
          END IF
          CALL l_channel.write(l_str CLIPPED)
          IF i = cnt_header THEN 
             EXIT FOR
          END IF  
       END FOR
   END FOR
   CALL l_channel.write("</tr></table></body></html>")
   CALL l_channel.close()
   CALL cl_prt_convert(xls_name)  ### TQC-5C0124 ###
   IF cl_null(g_aza.aza56) THEN
     UPDATE aza_file set aza56='1'
     IF SQLCA.sqlcode THEN
             #CALL cl_err('U',SQLCA.sqlcode,0)
             CALL cl_err3("upd","aza_file","1","",SQLCA.sqlcode,"","",0)   #No.FUN-640161
             RETURN
     END IF
     LET g_aza.aza56 = '1'
   END IF
 
   IF g_aza.aza56 = '2' THEN
        LET unix_path = "$TEMPDIR/",xls_name CLIPPED
 
        LET window_path = "c:\\tiptop\\",xls_name CLIPPED
        LET status = cl_download_file(unix_path, window_path)
        IF status then
           DISPLAY "Download OK!!"
        ELSE
           DISPLAY "Download fail!!"
        END IF
 
        LET status = cl_open_prog("excel",window_path)
        IF status then
           DISPLAY "Open OK!!"
        ELSE
           DISPLAY "Open fail!!"
        END IF
   ELSE
        LET l_str = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", xls_name CLIPPED
        CALL ui.Interface.frontCall("standard",
                                 "shellexec",
                                 ["EXPLORER \"" || l_str || "\""],
                                 [res])
        IF STATUS THEN
           CALL cl_err("Front End Call failed.", STATUS, 1)
           RETURN
        END IF
   END IF
END FUNCTION
