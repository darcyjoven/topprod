# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Program name...: cl_trans_xml.4gl
# Descriptions...: report data ->xml->add delimiter
#                 output_type ->1:excel , 2:html , 3:callViewer
#                 output_type ->4:txt   , 5:html2pdf , 6:word
# Date & Author..: 04/07/07 by CoCo
# Usage..........: CALL cl_trans_xml("aimr100.23r.xml","1")      
# Modify.........: 04/10/15 add html2doc(output_type=6) by coco 
# Modify.........: No.MOD-530309 05/03/25 By echo 不應指定 IE 之 Explorer 之路徑。(ui.Interface.frontCall)
# Modify.........: No.MOD-530271 05/05/03 By echo cl_trans_xml.4gl將XML檔權限更改為777
# Modify.........: No.FUN-550001 05/05/03 By coco report to html encoding by $TOPLOCALE and g_rlang
# Modify.........: No.MOD-550021 05/05/05 By coco report to html encoding by ms_codeset
# Modify.........: No.FUN-570052 05/06/26 By echo 依據工作單號:FUN-560079 ，修改cl_trans_xml.4gl(增加zaa17),改善報表執行效率  
# Modify.........: No.FUN-570141 05/07/14 By echo 調整 Declare 寫法!  
# Modify.........: No.MOD-570371 05/07/27 By echo 報表g_dash1產生錯誤
# Modify.........: No.FUN-570203 05/07/22 By echo 在html中加上script.讓報表的欄位位置能夠動態拖拉來調換  
# Modify.........: No.FUN-570264 05/07/28 By CoCo background job don't pop q_zaa window
# Modify.........: No.FUN-560048 05/08/01 By Echo 增加錯誤判斷
# Modify.........: No.MOD-580053 05/08/04 By Echo 將cl_trans_script.tpl 移至 $TOP/ds4gl2/bin
# Modify.........: No.FUN-580019 05/08/08 By Echo 1.HTML的隔線顏色變淡
#                                                  2.兩行以上的單頭可選擇拉成一行呈現
#                                                  3.兩行以上的單頭選擇動態html輸出時,直接把報表拉成一行(若p_zaa沒設定一行時的順序,直接把第二行加在第一行之後) 
#                                                  4.單頭不在page header,而在before group or on every row,須在列印單頭時加上name,如:PRINTX name= H1  
# Modify.........: No.MOD-580150 05/08/15 By CoCo 資料多&nbsp造成轉excel時數值轉文字型態
# Modify.........: No.MOD-580299 05/09/08 By Echo 多行報表轉單行報表時，選擇多格式輸出Excel時會當掉...
# Modify.........: No.MOD-580063 05/09/13 By Echo 報表轉excel檔後,轉出來的數據類型錯誤,比如人員編號為00003,可是轉到excel後,就成3了
# Modify.........: No.MOD-590325 05/10/04 By Echo 報表轉excel合併表格的資料皆靠左
# Modify.........: No.FUN-570208 05/10/07 By Echo 將 DOM 改成 SAX 寫法, 定義zaa08 VARCHAR(800) 改成 STRING
# Modify.........: No.MOD-5A0152 05/10/14 By Echo p_zaa設定「欄位調換否」為「N」時，已經修改單身欄位屬性了,轉出的excel資料還是靠左...
# Modify.........: No.MOD-5A0251 05/10/18 By CoCo because sed so 製表日期的日期斜線要加反斜線
# Modify.........: No.TQC-5A0120 05/10/31 By CoCo varchar->char
# Modify.........: No.TQC-5A0082 05/10/26 By Echo 列印時,如果單身資料有g_dash1,會造成換頁有問題
# Modify.........: No.TQC-5B0007 05/11/02 By Echo 多行式報表g_dash1計算錯誤
# Modify.........: No.TQC-5B0066 05/11/08 By Echo 修正單行文字檔如果單身列印g_dash1則造成以下資料無隱藏或順序調換的錯誤。
# Modify.........: No.TQC-5B0055 05/11/08 By Echo 多格式輸出選擇「轉動態 HTML (分頁)」，呈現的資料不正確...
# Modify.........: No.TQC-5B0077 05/11/09 By CoCo encoding判斷由TOPLOCALE改為ms_codeset
# Modify.........: No.TQC-5B0170 05/11/21 By Echo 新增cl_prt_pos_dyn()存放g_zaa_dyn陣列
# Modify.........: No.TQC-5C0055 05/12/12 By Echo 在unicode區RUN報表時,表頭顯示日期及時間都擠在一起了..
# Modify.........: No.FUN-5A0135 05/12/15 By Echo TOP MARGIN g_top_margin 的多行式報表轉HTML時會當掉...
# Modify.........: No.FUN-5C0113 05/12/30 By Echo TIPTOP GP 報表資料連查~報表預覽功能
# Modify.........: No.TQC-640051 06/04/07 By Echo CALL l_channel.write(l_str) 改為 CALL l_channel.write(l_str.trimRight())
# Modify.........: No.TQC-5C0007 06/04/14 By Echo xml作簡繁的轉換
# Modify.........: No.TQC-650109 06/05/24 By Echo voucher樣版的報表轉excel、html時，若資料含有「<」時，之後的資料就會被截斷。
# Modify.........: No.FUN-660011 06/06/05 By Echo 報表輸出到excel分為2種開啟的方式
# Modify.........: No.FUN-650017 06/06/15 By Echo 新增抓取報表左邊界(zaa19)的值
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.TQC-6A0067 06/10/27 By Echo 因此若資料長度超過255,就不要指定儲存格的格式
# Modify.........: No.FUN-6B0006 06/11/07 By alexstar 欲列印的資料超過p_zaa裡的設定值時，該欄位的列印方式(全印或是用###替代)
# Modify.........: No.TQC-6B0006 06/12/12 By Echo 報表程式，若 PRINT COLUMN g_c[40],XXX 但在p_zaa卻未建立40序號資料時,
#                                                 則會造成程式無窮迴圈，導至 resource 整個被吃掉...
# Modify.........: No.FUN-670044 06/12/12 By Echo 報表轉excel時.數字欄位太長時會轉為科學符號..
# Modify.........: No.FUN-690088 06/12/12 By Echo 轉多格式輸出時，只刪除g_dash,及g_dash1,g_dash2 的線，其他皆保留。
# Modify.........: No.TQC-6A0113 06/12/12 By Echo 有些產生的報表..(結束)位置不正確
# Modify.........: No.FUN-660179 07/01/04 By Echo 報表輸出新增callviewer功能
# Modify.........: No.FUN-6A0159 07/01/03 By ching-yuan 將欄位屬性:A.B.C.D.E.F.Q.置中對齊顯示
# Modify.........: No.TQC-6C0088 07/06/04 By Echo 轉 Excel 時，將單身抬頭指定為"文字格式"
# Modify.........: No.TQC-710026 07/06/05 By Echo 多格式輸出時，前三行資料應置中...
# Modify.........: No.CHI-760015 07/06/13 By Echo 多行式報表，應該 g_body_title_pos 判斷拿掉
# Modify.........: No.MOD-770068 07/07/16 By alex 加入WOS執行方式
# Modify.........: No.TQC-770102 07/07/20 By Claire g_pdate傳入值為null時會誤判
# Modify.........: No.FUN-780064 07/09/03 By Echo zaa設定屬於為文字類的，左邊空白需轉換為"&nbsp;"
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810047 08/03/10 By Echo 改善報表效能
# Modify.........: No.FUN-710036 08/08/07 By tsai_yen Unicode字型設Courier New
# Modify.........: No.FUN-930058 09/03/10 By alex 調整double quot.
# Modify.........: No.FUN-950066 09/05/19 By Echo 報表轉 Excel 時如 66.100 小數位顯示不正確，
# Modify.........: No.TQC-950138 09/05/22 By Kevin 使用g_item_sort_1[j+1] 會導致 For Loop 產生無窮迴圈
# Modify.........: No.CHI-960073 09/06/22 By Echo 轉 Excel 後，若是有空白的資料透過搜尋的方式會找不到
# Modify.........: No.FUN-960155 09/06/23 By Echo 調整 MSV 舊報表問題
# Modify.........: No.FUN-9B0062 09/11/09 By Echo OS不同，awk語法需調整
# Modify.........: No.FUN-A90047 10/09/15 By Echo 改善效能，指定 <tr> 高度值可減少開啟excel時間
# Modify.........: No.FUN-A90058 10/10/22 By Echo 列印轉excel格式會無法顯示千分位
# Modify.........: No.CHI-B30026 11/03/14 By Echo 改善效能，拿掉 <PRE> tag, 資料有空白時加上<span> tag 並且將空白轉換為 &nbsp; 
# Modify.........: No.FUN-A20036 11/05/10 By Henry 在輸出字串前後加上<span> parameter 以保持字串空格原狀
# Modify.........: No.FUN-B50137 11/06/08 By CaryHsu 增加函數說明註解
# Modify.........: No.FUN-B80109 11/08/11 By Ernest 調整21區及31區的 cl_trans_xml.4gl, 將有 Attrib 指令的地方加上 OS 形式判斷
# Modify.........: No.FUN-CB0136 12/12/25 By LeoChang 補上HTML缺少的標籤，並將<HEAD><META>等標籤移到<SCRIPT>標籤之前 
# Modify.........: No.CHI-CA0069 12/12/28 By LeoChang p_query之報表, 多格式輸出至excel時, 若欄位值內容有<test>等XML標籤時，會無法顯示
# Modify.........: No.CHI-D20019 13/02/23 By jacklai 多格式輸出Excel時,文件尾端會多無TR、TD內容的TABLE標籤，會造成多印一頁，需去除

IMPORT os                                 #MOD-770068
 
DATABASE ds                               #TQC-6A0113  #FUN-7C0053
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11   #FUN-570052
  DEFINE g_zaa13_value  LIKE zaa_file.zaa13   #FUN-570052
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-570052
  DEFINE ms_codeset     STRING
  DEFINE g_seq_item     LIKE type_file.num5        #No.FUN-690005 SMALLINT #FUN-570052 
  DEFINE g_header     DYNAMIC ARRAY WITH DIMENSION 2 OF STRING
  DEFINE g_body       DYNAMIC ARRAY WITH DIMENSION 3 OF STRING
  DEFINE g_trailer    DYNAMIC ARRAY WITH DIMENSION 2 OF STRING
  DEFINE g_body_title DYNAMIC ARRAY WITH DIMENSION 2 OF RECORD         
                        zaa02  LIKE zaa_file.zaa02,   #序號
                        zaa05  LIKE zaa_file.zaa05,   #寬度
                        zaa08  LIKE zaa_file.zaa08,   #欄位內容
                        contview  LIKE type_file.chr1        #No.FUN-690005 VARCHAR(1) #連查否
                      END RECORD
END GLOBALS
 
DEFINE dom_doc                   om.DomDocument
DEFINE n,n_print_next            om.DomNode
DEFINE g_quote                   STRING            
DEFINE g_pagelen                 LIKE type_file.num10       #No.FUN-690005 INTEGER          #報表列印行數
DEFINE g_bottom                  LIKE type_file.num10       #No.FUN-690005 INTEGER          #報表表尾空白行數
DEFINE g_top                     LIKE type_file.num10       #No.FUN-690005 INTEGER          #報表表頭空白行數
DEFINE g_left                    LIKE type_file.num10       #No.FUN-690005 INTEGER          #報表左邊界        #FUN-650017
DEFINE g_left_str                STRING                              #FUN-650017
DEFINE g_xml_value               LIKE zaa_file.zaa02  #STRING ITEM的value
DEFINE g_xml_name                LIKE type_file.chr50 #No.FUN-690005 VARCHAR(24)
DEFINE g_xml_name_s              STRING
DEFINE g_print_name              STRING           #PRINTX TAG NAME
DEFINE g_print_cnt               LIKE type_file.num10       #No.FUN-690005 INTEGER
DEFINE output_name               STRING
DEFINE g_view_cnt                LIKE type_file.num10       #No.FUN-690005 INTEGER          #報表顯示欄位總數
DEFINE g_body_title_pos          LIKE type_file.num10       #No.FUN-690005 INTEGER          #報表欄數位於pageheader第幾行
DEFINE g_total_len               LIKE type_file.num10       #No.FUN-690005 INTEGER          #報表列印長度
DEFINE g_dash_num                LIKE type_file.num10       #No.FUN-690005 INTEGER         
DEFINE g_print_end,g_sort        LIKE type_file.chr1        #No.FUN-690005 VARCHAR(1)         
DEFINE g_print_num               LIKE type_file.num10      #No.FUN-690005 INTEGER         
DEFINE g_next_num                LIKE type_file.num10       #No.FUN-690005 INTEGER         
DEFINE g_next_name               STRING
DEFINE g_print_start             LIKE type_file.num10       #No.FUN-690005 INTEGER         
DEFINE g_next_int                STRING
DEFINE g_print_int               STRING
DEFINE g_sql                     LIKE type_file.chr1000     #No.FUN-690005 VARCHAR(900)
DEFINE g_dash_cnt                LIKE type_file.num10       #No.FUN-690005 INTEGER              #計算g_dash總數
DEFINE g_print_dash              LIKE type_file.num10       #No.FUN-690005 INTEGER              #計算g_dash總數
DEFINE g_report_cnt   DYNAMIC ARRAY OF LIKE type_file.num10       #No.FUN-690005 INTEGER        #抬頭欄位個數
DEFINE g_report_size  DYNAMIC ARRAY OF LIKE type_file.num10       #No.FUN-690005 INTEGER        #抬頭欄位長度
DEFINE g_item         DYNAMIC ARRAY OF RECORD         
                        zaa05  LIKE zaa_file.zaa05,   #寬度
                        zaa06  LIKE zaa_file.zaa06,   #隱藏否
                        zaa07  LIKE zaa_file.zaa07,   #欄位順序
                        zaa08  STRING,                #內容        #FUN-570208
                        zaa15  LIKE zaa_file.zaa15,   #行序
                        column LIKE type_file.num10,       #No.FUN-690005 INTEGER  #定位點
                        sure   LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
                        zaa14  LIKE zaa_file.zaa14    #欄位順序  #MOD-580063
 
                      END RECORD    
 
DEFINE g_item2        DYNAMIC ARRAY OF RECORD         # XML裡ITEM資訊
                        zaa08  STRING,                #內容        #FUN-570208
                        column LIKE type_file.num10   #No.FUN-690005 INTEGER  #定位點
                      END RECORD
DEFINE g_value        DYNAMIC ARRAY OF RECORD         #報表欄位TITLE
                        zaa02  LIKE zaa_file.zaa02,   #序號
                        zaa07  LIKE zaa_file.zaa07,   #欄位順序
                        zaa08  STRING,                #內容        #FUN-570208
                        zaa15  LIKE zaa_file.zaa15,   #行序
                        zaa14  LIKE zaa_file.zaa14    #欄位順序   #MOD-580063
 
                      END RECORD
DEFINE g_item_sort    DYNAMIC ARRAY WITH DIMENSION 2 OF RECORD
                        zaa05  LIKE zaa_file.zaa05,   #寬度
                        zaa06  LIKE zaa_file.zaa06,   #隱藏否
                        zaa08  STRING,                #內容        #FUN-570208
                        column LIKE type_file.num10,       #No.FUN-690005 INTEGER,               #定位點
                        sure   LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
                        zaa14  LIKE zaa_file.zaa14    #欄位順序  #MOD-580063
 
                      END RECORD    
DEFINE g_item_sort_1  DYNAMIC ARRAY  OF RECORD
                        zaa05  LIKE zaa_file.zaa05,   #寬度
                        zaa06  LIKE zaa_file.zaa06,   #隱藏否
                        zaa08  STRING,                #內容        #FUN-570208
                        column LIKE type_file.num10,       #No.FUN-690005 INTEGER,               #定位點
                        sure   LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
                        zaa14  LIKE zaa_file.zaa14    #欄位順序 #MOD-580063
 
                      END RECORD    
DEFINE   g_output_type         LIKE type_file.chr1        #No.FUN-690005 VARCHAR(1)                         #FUN-570203 
#FUN-570208
DEFINE g_total_page            LIKE type_file.num10       #No.FUN-690005 INTEGER
DEFINE r                       om.XmlReader
DEFINE e                       String
DEFINE lsax_attrib             om.SaxAttributes,
       n_id_name               STRING
#END FUN-570208
DEFINE n_id_dash1              LIKE type_file.num5        #No.FUN-690005 SMALLINT            #TQC-5B0066               
DEFINE g_page_cnt              LIKE type_file.num10       #No.FUN-690005 INTEGER             #TQC-5B0170
DEFINE g_dash_out              STRING              #TQC-6A0113
DEFINE g_dash2_out             STRING              #TQC-6A0113
DEFINE g_zaa02                 DYNAMIC ARRAY OF LIKE  zaa_file.zaa02  #No.FUN-810047
DEFINE g_cnt                   LIKE type_file.num10       #TQC-950138
DEFINE g_column_cnt            STRING                     #CHI-B30026
DEFINE g_bufstr                base.StringBuffer          #CHI-B30026
 
 
##################################################
# Descriptions..: report data ->xml->add delimiter
#                 output_type ->1:excel , 2:html , 3:callViewer
#                 output_type ->4:txt   , 5:html2pdf , 6:word
# Input Parameter: xml_name
#                  output_type
# Return code....: void
##################################################
FUNCTION cl_trans_xml(xml_name,output_type)
DEFINE xml_name                            LIKE type_file.chr50,  #No.FUN-690005 VARCHAR(24),
       output_type                         LIKE type_file.chr1,   #No.FUN-690005 VARCHAR(1),
       l_channel                           base.Channel,
       l_str,value,l_cmd,l_str2,l_url      string,
       unix_path,window_path               string,
       i,j,k,l_len,l_status                LIKE type_file.num10,  #No.FUN-690005 integer,
       l_total_len,column_cnt              LIKE type_file.num10,  #No.FUN-690005 INTEGER,             
       l_name                              LIKE type_file.num5,   #No.FUN-690005 SMALLINT,  #FUN-570052
       l_print_name                        STRING,                #FUN-570208
       g_end_pos                           LIKE type_file.num10,  #No.FUN-690005 INTEGER,
       l_buf_str                           base.StringBuffer      #MOD-5A0251
DEFINE l_zaa02                             LIKE zaa_file.zaa02    #No.FUN-810047
 
   LET g_output_type = output_type                #FUN-570203
   LET g_quote = """"
   LET g_xml_name = xml_name CLIPPED
   LET g_total_len = 0
   LET g_body_title_pos = 0
   CALL g_item.clear()
   CALL g_item2.clear()
   CALL g_value.clear()
   CALL g_report_size.clear()
   CALL g_report_cnt.clear()
   LET g_dash_out  = g_dash   CLIPPED            #TQC-6A0113
   LET g_dash2_out = g_dash2  CLIPPED            #TQC-6A0113
 
###將Skip 取代為"<Print></Print>"
   display "g_xml_name:",g_xml_name
 
  IF output_type = "T"   THEN     
      LET l_str2 = g_xml_name CLIPPED,"1.xml"
      #No.FUN-960155 -- start -- 

      #No.FUN-9B0062 -- start --
      IF os.Path.separator() = "/" THEN    #MOD-770068
         LET l_cmd = "awk ' { sub(/<Skip\\\/>/, \"<Print/>\"); sub(/pageno_total/,\"page_total\"); sub(/pageno/, \"",g_pageno USING '<<<<<',"\") ; print $0  } ' $TEMPDIR/",
                      g_xml_name CLIPPED," > ",l_str2 CLIPPED
         RUN l_cmd
         LET l_cmd = "cp ",os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED)," ",os.Path.join(FGL_GETENV("TEMPDIR"),g_xml_name CLIPPED) 
         RUN l_cmd
         LET l_cmd = "chmod 777 ",g_xml_name CLIPPED," 2>/dev/null" #MOD-530271 
         RUN l_cmd
      ELSE
         LET l_cmd = "%FGLRUN% ",os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin" ),"rsed.42m"),
                     ' "<Skip/>" "<Print/>" ',
                      g_xml_name CLIPPED," ",l_str2 CLIPPED
         RUN l_cmd
         IF os.Path.copy( os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED),     #FUN-930058
                          os.Path.join(FGL_GETENV("TEMPDIR"),g_xml_name CLIPPED ) ) THEN END IF
         LET l_cmd = "%FGLRUN% ",os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin" ),"rsed.42m"),
                      ' "pageno" "',g_pageno USING '<<<<<','" ',
                      g_xml_name CLIPPED," ",l_str2 CLIPPED
         RUN l_cmd
         IF os.Path.copy( os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED),     #FUN-930058
                          os.Path.join(FGL_GETENV("TEMPDIR"),g_xml_name CLIPPED ) ) THEN END IF
         LET l_cmd = "attrib -r ",os.Path.join(FGL_GETENV("TEMPDIR"),g_xml_name CLIPPED)," >nul 2>nul" #MOD-530271
         RUN l_cmd
      END IF                                #MOD-770068
      IF os.Path.delete(l_str2 CLIPPED) THEN
      END IF
      #No.FUN-9B0062 -- end --
  END IF
 
   LET g_xml_name_s = g_xml_name CLIPPED
   ##讀取報表資料
   LET g_total_page = 0
   LET l_cmd = "grep -c \"pageNo=*\" ",g_xml_name CLIPPED
   LET l_channel = base.Channel.create()
   CALL l_channel.openPipe(l_cmd, "r")
   WHILE l_channel.read(l_str)
       LET g_total_page = l_str
   END WHILE
   CALL l_channel.close()
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN         ### FUN-570264 ###
      #FUN-570141
      CALL cl_progress_bar(g_total_page)
      #END FUN-570141
   END IF                   ### FUN-570264 ###
   #END FUN-570208
 
#### 將報表欄位名稱存至l_value陣列
   #FUN-570052
   FOR k = 1 to g_line_seq
       LET g_report_size[k]= 0
       LET g_report_cnt[k] = 0
   END FOR
 
#FUN-570208
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
 
   #抓取報表長度
   WHILE e IS NOT NULL
       CASE e
           WHEN "StartElement"
                 LET g_pagelen = lsax_attrib.getValue("pageLength")
                 LET g_bottom  = lsax_attrib.getValue("bottomMargin")
                 LET g_top     = lsax_attrib.getValue("topMargin")
                 LET g_left    = lsax_attrib.getValue("leftMargin") #FUN-650017
                 LET g_left_str = ""
                 #FUN-810047
                 #FOR k = 1 TO g_left
                 #    LET g_left_str = g_left_str ," "
                 #END FOR
                 LET g_left_str = g_left_str , g_left SPACES
                 #END FUN-810047
                 EXIT WHILE
       END CASE
       LET e = r.read()
   END WHILE
 
   LET g_pagelen = g_pagelen - g_bottom - 1
 
   LET e = r.read()
   #找尋g_dash1
   LET l_name = FALSE
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
           CASE
             WHEN r.getTagName() = "Item"
                LET value = lsax_attrib.getValue("value")
                IF value.equals(g_dash1) THEN
                       LET l_name = TRUE
                       EXIT WHILE
                END IF
             WHEN r.getTagName() = "Print"
                LET l_print_name = lsax_attrib.getValue("name")
                LET i = i + 1
                IF (l_print_name.subString(1,1)="h" AND g_body_title_pos = 0) THEN   
                       LET g_print_name = "h" 
                       LET g_body_title_pos = i
                END IF
           END CASE
      END CASE
      LET e= r.read()
   END WHILE
   IF l_name = FALSE THEN
      CALL cl_err(g_xml_value,'lib-283',1)
      LET INT_FLAG = 1
      RETURN
   END IF
 
 
   #尋找單身TITLE
   IF g_print_name = "h" THEN
       LET g_end_pos =i
   ELSE
       LET g_body_title_pos = i - g_line_seq
       LET g_end_pos = i
   END IF
 
   LET i = 0
   LET g_view_cnt = 0
 
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
          CASE
            WHEN r.getTagName() = "Item"
               IF (g_body_title_pos <= i) AND (g_end_pos > i ) THEN
                   LET g_view_cnt = g_view_cnt + 1
                   LET g_xml_value = lsax_attrib.getValue("value")
                   #FUN-570052
                   IF g_zaa.getLength() < g_xml_value OR cl_null(g_xml_value)
                     OR NOT(g_xml_value > 0)  #FUN-570203
                   THEN
                      CALL cl_err(g_xml_value,'azz-090',1)
                      CALL cl_close_progress_bar()              #TQC-6B0006
                      LET INT_FLAG = 1
                      RETURN   
                   END IF 
 
                   LET g_value[ g_view_cnt ].zaa02= g_xml_value 
                   LET g_value[ g_view_cnt ].zaa07= g_zaa[g_xml_value].zaa07 CLIPPED 
                   LET g_value[ g_view_cnt ].zaa08= g_zaa[g_xml_value].zaa08 CLIPPED
                   LET g_value[ g_view_cnt ].zaa15= g_zaa[g_xml_value].zaa15 CLIPPED 
                   LET g_value[ g_view_cnt ].zaa14= g_zaa[g_xml_value].zaa14 CLIPPED  #MOD-580063
                    
                   IF g_zaa[g_xml_value].zaa06 = 'N' THEN    #是否隱藏
                      LET g_report_size[g_zaa[g_xml_value].zaa15] = 
                          g_report_size[g_zaa[g_xml_value].zaa15] +
                          g_zaa[g_xml_value].zaa05 + 1
                      LET g_report_cnt[g_zaa[g_xml_value].zaa15] = 
                          g_report_cnt[g_zaa[g_xml_value].zaa15] + 1
                   END IF
                END IF
            WHEN r.getTagName() = "Print"
                LET i = i + 1
          END CASE
 
        WHEN "EndElement"
          IF r.getTagName() = "Print" AND ((g_end_pos - 1 ) = i)THEN
                EXIT WHILE
          END IF
 
      END CASE
      LET e= r.read()
   END WHILE
   LET g_view_cnt = 0 
   FOR j = 1 to g_report_cnt.getLength()        #判斷報表欄位
      IF g_view_cnt < g_report_cnt[j] THEN
         LET g_view_cnt = g_report_cnt[j]
      END IF
   END FOR
   FOR j = 1 to g_report_size.getLength()       #判斷報表長度
      IF g_total_len < g_report_size[j] THEN
          LET g_total_len = g_report_size[j]
          LET g_dash_num = j                   #TQC-5A0082   #TQC-5B0007
      END IF
   END FOR
   LET g_total_len = g_total_len - 1
#END FUN-570208
   LET g_page_cnt = 1         #TQC-5B0170
 
   #FUN-580019
   IF output_type = "T"   THEN     
       IF g_towhom IS NULL OR g_towhom = ' '
          THEN LET g_head = ''
          ELSE LET g_head = 'TO:',g_towhom CLIPPED,'  '
       END IF
  
       LET l_len = g_head.getLength()    ### FUN-570264 ###
  
       IF (g_pdate = 0 ) OR cl_null(g_pdate) THEN   #TQC-770102 modify cl_null(g_pdate)
           LET g_pdate = g_today
       END IF
       #LET g_head = g_head ,g_x[2] CLIPPED,g_pdate ,COLUMN 19+l_len,TIME,COLUMN (g_len-FGL_WIDTH(g_user)-20),'FROM:',
       LET g_head = g_head ,g_x[2] CLIPPED,g_pdate ,' ',TIME,COLUMN (g_len-FGL_WIDTH(g_user)-20),'FROM:',   #TQC-5C0055
                    g_user CLIPPED,COLUMN (g_len-13),g_x[3] CLIPPED   ### FUN-570264 ###
      ### MOD-5A0251 start ###
       LET l_buf_str = base.StringBuffer.create()
       CALL l_buf_str.append(g_head)
       CALL l_buf_str.replace("\\","\\\\",0)
       CALL l_buf_str.replace("/","\\/",0)
       LET g_head = l_buf_str.toString()
      ### MOD-5A0251 end ###
 
       LET l_str2 = g_xml_name CLIPPED,"1.xml"
      ### MOD-5A0251 start ###
       #LET l_cmd = "awk ' { sub(/g_head/,\"",g_head CLIPPED,"\") ; print $0  } ' %TEMPDIR%/",
       #             g_xml_name CLIPPED," > ",l_str2 CLIPPED
       #sed 's/g_head/$g_head/' $1>${1}.new
 
       #No.FUN-960155 -- end -- 
       #No.FUN-9B0062 -- start --
       IF os.Path.separator() = "/" THEN      #MOD-770068
          LET l_cmd = "sed 's/g_head/",g_head CLIPPED,"/' $TEMPDIR/",
                      g_xml_name CLIPPED," > ",l_str2 CLIPPED    #FUN-9B0062
          RUN l_cmd
          LET l_cmd = "cp ",os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED)," ",os.Path.join(FGL_GETENV("TEMPDIR"),g_xml_name CLIPPED)  #FUN-9B0062
          RUN l_cmd
          LET l_cmd = "chmod 777 ",g_xml_name CLIPPED," 2>/dev/null" #MOD-530271
          RUN l_cmd
       ELSE
          LET l_cmd = "%FGLRUN% ",os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin" ),"rsed.42m"),   #FUN-930058
                      ' "g_head" "',g_head CLIPPED,'" ',
                       g_xml_name CLIPPED," ",l_str2 CLIPPED
          RUN l_cmd
          IF os.Path.copy( os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED),     #FUN-930058
                           os.Path.join(FGL_GETENV("TEMPDIR"),g_xml_name CLIPPED ) ) THEN END IF
      ### MOD-5A0251 end ###
       #No.FUN-960155 -- end -- 
          LET l_cmd = "attrib -r ",os.Path.join(FGL_GETENV("TEMPDIR"),g_xml_name CLIPPED)," >nul 2>nul" #MOD-530271
          RUN l_cmd
       END IF                                 #MOD-770068
       IF os.Path.delete(l_str2 CLIPPED) THEN
       END IF
       #No.FUN-9B0062 -- end --

   END IF
 
   CALL g_zaa02.clear()
   LET g_sql = "SELECT zaa02 FROM zaa_file ",
               " where zaa01= '", g_prog ,"' AND zaa09='1' AND zaa04 = '",g_zaa04_value,
               "' AND zaa10 = '",g_zaa10_value,"' AND zaa11='",g_zaa11_value,
               "' AND zaa17 = '",g_zaa17_value,"'"
   PREPARE cl_trans_prepare FROM g_sql           #預備一下
   DECLARE cl_trans_curs CURSOR FOR cl_trans_prepare
   LET j = 0
   FOREACH cl_trans_curs INTO l_zaa02
        LET j = j + 1
        LET g_zaa02[j] = l_zaa02
   END FOREACH
   #END No.FUN-810047
 
   LET g_column_cnt =  g_view_cnt USING '<<<<<<<<<<'     #CHI-B30026

   LET l_str = g_xml_name CLIPPED
   CASE
       WHEN output_type = "1"     ##excel()=>1行報表, excel2()=>多行報表
            LET output_name = l_str.substring(1,l_str.getlength()-3),"xls"
            IF g_line_seq > 1 OR g_print_name = "h" THEN  #FUN-580019
               CALL cl_trans_excel2()        #MOD-580063
            ELSE 
               CALL cl_trans_excel()         #MOD-580063
            END IF
       WHEN output_type = "2"     ##html
            LET output_name = l_str.substring(1,l_str.getlength()-3),"htm"
            IF g_line_seq > 1 OR g_print_name = "h" THEN  #FUN-580019
               CALL cl_trans_html2()
            ELSE 
               CALL cl_trans_html()
            END IF
       WHEN (output_type = "T")   ##txt()=>1行報表，txt2()=>多行報表
            IF g_line_seq > 1 OR g_print_name = "h" THEN  #FUN-580019
               CALL cl_trans_txt2()
            ELSE 
               CALL cl_trans_txt()
            END IF
            LET output_name = l_str.substring(1,l_str.getlength()-3),"txt"
       WHEN (output_type = "5") OR (output_type = "6")
            LET output_name = l_str.substring(1,l_str.getlength()-3),"doc"
            IF g_line_seq > 1 OR g_print_name = "h" THEN  #FUN-580019
               CALL cl_trans_word2()         #MOD-580063
            ELSE 
               CALL cl_trans_word()          #MOD-580063
            END IF
        
       #FUN-570203
       WHEN output_type = "7"     ##html+script(merge)       
            LET output_name = l_str.substring(1,l_str.getlength()-4),"1.htm"
            IF g_line_seq > 1 OR g_print_name = "h" THEN  #FUN-580019
               CALL cl_trans_html2()
               IF INT_FLAG THEN 
                      LET INT_FLAG = 0
                      RETURN
               END IF
            ELSE
               CALL cl_trans_html_script()
            END IF
       WHEN output_type = "8"     ##html+script(pages)        
            LET output_name = l_str.substring(1,l_str.getlength()-4),"2.htm"
            IF g_line_seq > 1 OR g_print_name = "h" THEN  #FUN-580019
               CALL cl_trans_html2()
               IF INT_FLAG THEN
                      LET INT_FLAG = 0
                      RETURN 
               END IF
            ELSE
               CALL cl_trans_html_script2()
            END IF
 
       #END FUN-570203
         
       #FUN-5C0113
       WHEN output_type = "9"
            IF g_line_seq > 1 OR g_print_name = "h" THEN  
               CALL cl_trans_contview2()      
            ELSE
               CALL cl_trans_contview()
            END IF 
       #END FUN-5C0113
 
       #FUN-660179
       #OTHERWISE                  ##callviewer
       #     CALL cl_trans_callview()
       WHEN output_type = "3"     ##callviewer           
            IF g_line_seq > 1 OR g_print_name = "h" THEN  #FUN-580019
               CALL cl_trans_callview2()
               IF INT_FLAG THEN
                      LET INT_FLAG = 0
                      RETURN
               END IF
            ELSE
               CALL cl_trans_callview()
            END IF
            LET output_name = l_str.substring(1,l_str.getlength()-8),l_str.substring(l_str.getlength()-6,l_str.getlength()-4),".txt"
       #END FUN-660179
   END CASE
 
   #FUN-B80109 begin
   IF os.Path.separator() = "/" THEN    
     LET l_cmd = "chmod 777 ",output_name CLIPPED," 2>/dev/null" 
     RUN l_cmd
   ELSE
     LET l_cmd = "attrib -r ",output_name CLIPPED," >nul 2>nul" #MOD-580063 
     RUN l_cmd
   END IF  
   #FUN-B80109 end

   #TQC-6B0006
   IF INT_FLAG THEN
        CALL cl_close_progress_bar()
        RETURN
   END IF
   #END TQC-6B0006
 
 ###   DOWNLOAD FILE AND EXE APPLICATION   ####
 IF (output_type NOT MATCHES "[T9]") THEN  #FUN-5C0113
   IF (output_type <> "V")
   THEN
     IF output_type MATCHES "[3]" THEN
        LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),output_name CLIPPED) 
 
        #LET status = cl_download_file(unix_path, "C:/tiptop")
        LET window_path = "c:\\tiptop\\",output_name          #FUN-660179
        LET status = cl_download_file(unix_path, window_path) #FUN-660179
        IF status then
           DISPLAY "Download OK!!"
        ELSE
           DISPLAY "Download fail!!"
        END IF
 
       #LET window_path = "c:\\tiptop\\",output_name          #FUN-660179
 
        LET window_path = "CallViewer"," ",output_name.substring(5,10)," Tiptop ",output_name.substring(1,4)," TIPTOPDATA"
        LET status = cl_open_prog("",window_path)
        IF status then
           DISPLAY "Open OK!!"
        ELSE
           DISPLAY "Open fail!!"
        END IF 
     ELSE
       CALL cl_prt_convert(output_name)    ### TQC-5C0007 ###
       #FUN-660011
       #LET l_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", output_name
       # ## No.MOD-530309
       #CALL ui.Interface.frontCall("standard",                    
       #                            "shellexec", 
       #                            ["EXPLORER \"" || l_url || "\""],
       #                            [l_status])
       # ## end No.MOD-530309
       #IF STATUS THEN
       #   CALL cl_err("Front End Call failed.", STATUS, 1)
       #   RETURN
       #END IF
       #IF NOT l_status THEN
       #   CALL cl_err("Application execution failed.", '!', 1)
       #   RETURN
       #END IF
       IF cl_null(g_aza.aza56) THEN
         UPDATE aza_file set aza56='1'
         IF SQLCA.sqlcode THEN
                 CALL cl_err('U',SQLCA.sqlcode,0)
                 RETURN
         END IF
         LET g_aza.aza56 = '1'
       END IF
 
       IF (output_type = "1" AND g_aza.aza56 = '2')
       THEN
            LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),output_name CLIPPED)
 
            LET window_path = "c:\\tiptop\\",output_name
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
           LET l_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", output_name
            ## No.MOD-530309
           CALL ui.Interface.frontCall("standard",
                                       "shellexec",
                                       ["EXPLORER \"" || l_url || "\""],
                                       [l_status])
            ## end No.MOD-530309
           IF STATUS THEN
              CALL cl_err("Front End Call failed.", STATUS, 1)
              RETURN
           END IF
          IF NOT l_status THEN
             CALL cl_err("Application execution failed.", '!', 1)
             RETURN
          END IF
       END IF
       #END FUN-660011
 
     END IF
   END IF
 END IF
END FUNCTION
 
#MOD-580063
##################################################
# Descriptions...: html格式(一行)
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_html()
DEFINE  output_type,l_pageheader,l_tr           LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        str_center                              LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        l_channel                               base.Channel,
        cnt_print,i,j,h,cnt_noskip              LIKE type_file.num10,       #No.FUN-690005 integer,
        k,column_cnt,tag,tag2                   LIKE type_file.num10,       #No.FUN-690005 integer,
        cnt,str_cnt,cnt_column,l_i              LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        l_str,value,l_cmd,n_name,l_skip_tag     string
DEFINE  l_bufstr                                base.StringBuffer  #TQC-650109
 
DEFINE l_td_attr STRING #No.FUN-6A0159
 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
 
 
   #FUN-570052
   #計算g_dash個數
   LET g_dash_cnt = 0
  #LET l_cmd = "grep -c \"",g_dash CLIPPED,"*\" ",g_xml_name CLIPPED
   LET l_cmd = "grep -c \"",g_dash_out ,"*\" ",g_xml_name CLIPPED  #TQC-6A0113
   LET l_channel = base.Channel.create()
   CALL l_channel.openPipe(l_cmd, "r")
   WHILE l_channel.read(l_str)
       LET g_dash_cnt = l_str
   END WHILE
   CALL l_channel.close()
   #END FUN-570052
   #FUN-6B0006---start---
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' AND g_aza.aza66 = 2 THEN
      LET g_dash_cnt = g_dash_cnt - 1
   END IF
   #FUN-6B0006---end---
       
   LET cnt = 0
   LET l_str = ""

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --

   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(output_name,"a" )
   CALL l_channel.setDelimiter("")
 
   #No.FUN-810047
   ##FUN-570141
   #LET g_sql = "SELECT zaa02 FROM zaa_file ",
   #            " where zaa01= '", g_prog ,"' AND zaa09='1' AND zaa04 = '",g_zaa04_value,
   #            "' AND zaa10 = '",g_zaa10_value,"' AND zaa11='",g_zaa11_value,
   #            "' AND zaa17 = '",g_zaa17_value,"'"
   #PREPARE cl_trans_prepare FROM g_sql           #預備一下
   #DECLARE cl_trans_curs CURSOR FOR cl_trans_prepare
   ##END FUN-570141
   #END No.FUN-810047
 
 
   CALL cl_trans_column(column_cnt) RETURNING l_str
   CALL l_channel.write(l_str)
 
   LET l_str = ""
   LET g_print_dash = 0
   LET l_i = 0                                 #g_item2陣列數
   LET column_cnt = 1
   LET l_tr = "N"  
   LET g_sort = "N"
   LET l_pageheader = "Y"                      #pageheader的tag #FUN-5A0135
 
 ## 讀取報表資料
   #FUN-570208
   LET n_id_name = "xml"
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
          CASE
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "PageTrailer"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "PageHeader"
 
            WHEN r.getTagName() = "Print"
                LET n_name = r.getTagName()
                LET g_print_name = lsax_attrib.getValue("name")   #TQC-710026
                LET cnt_noskip = 0
                IF g_print_dash >= g_dash_cnt THEN
                   LET n_id_name = "PageTrailer"
                END IF
                #LET l_pageheader = "N"         #FUN-5A0135
 
            WHEN r.getTagName() = "Item"
                LET value = lsax_attrib.getValue("value")
                #TQC-650109
                CALL l_bufstr.clear()
                CALL l_bufstr.append(value)
                IF NOT cl_null(value) THEN
                   CALL l_bufstr.replace("<","&lt;",0)
                END IF
                LET value = l_bufstr.tostring()
                #END TQC-650109
 
                ### 公司名稱 合併
                IF value = g_company AND n_id_name == "PageHeader" THEN   #FUN-690088
                    LET l_str = "<TR height=22><TD bgcolor=#FFCC99 colspan=",g_column_cnt," align=center >",cl_add_span(value),"</TD></TR>"  #No.FUN-A90047  #CHI-B30026
                    LET l_tr = "Y"
                    LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                
                #TQC-710026
                #動態報表名稱
                IF g_print_name = "rep_name" THEN
                    LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>", cl_add_span(value),"</TD></TR>"   #No.FUN-A90047  #CHI-B30026
                    LET l_tr = "Y"
                    LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                #TQC-710026
 
                ### 虛線不列印
                #TQC-6A0113
                #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED))
                # OR (value.equals(g_dash2 CLIPPED))THEN
                #   IF value.equals(g_dash CLIPPED) THEN
                IF (value = g_dash1) OR (value = g_dash_out) OR
                   (value = g_dash2_out)
                THEN
                   IF value = g_dash_out THEN
                #END TQC-6A0113
 
                       LET g_print_dash = g_print_dash + 1
                   END IF   
                   LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;</TD></TR>"   #No.FUN-A90047  #CHI-B30026
                    LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                   EXIT CASE
                END IF
                 
                ### 欄位虛線不列印
                #FUN-690088
                #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
                #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
                #THEN
                #   LET value = g_dash CLIPPED
                #   LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;</TD></TR>"
                #   LET l_tr = "Y"
                #   LET l_pageheader= "Y"     
                #   EXIT CASE
                #END IF
                #END FUN-690088
               
                IF (g_body_title_pos - 1 = cnt) THEN   #是否為單身抬頭
                   LET j = l_i + 1
                   LET g_xml_value = value 
                   #FUN-570052  
                   LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                   LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                   LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                   #TQC-5B0170
                   IF g_zaa_dyn.getLength() > 0 THEN
                      LET g_item[j].zaa08 = g_zaa_dyn[g_page_cnt,g_xml_value]
                   ELSE
                      LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                   END IF
                   #END TQC-5B0170
                   LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                   LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                   LET g_item[j].column = g_c[g_xml_value]
                   #END FUN-570052  
                   LET l_i = l_i + 1
                   LET l_pageheader= "N"              #FUN-5A0135
                ELSE
                   IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                      IF (cnt < 3+g_top ) THEN                #TQC-710026
                           IF l_str.trim() = " " THEN
                                LET l_str = value
                           ELSE
                                LET l_str = l_str,value
                           END IF
                       ELSE
                           LET l_str = l_str,value
                           IF i = 1 AND (cnt_column != 0 )THEN
                              LET l_str = l_str," "
                           END IF
                      END IF
                      LET l_pageheader= "Y"     
                   ELSE
                        IF l_i = 0 THEN  
                          LET l_i = l_i + 1
                        ELSE
                          IF g_item2[l_i].zaa08 IS NOT NULL THEN
                               LET value = g_item2[l_i].zaa08 CLIPPED,value
                          END IF
                        END IF
                        LET g_item2[l_i].zaa08 = value CLIPPED               ### item value
                        LET g_item2[l_i].column = column_cnt         ### item value
                        LET l_pageheader= "N"
                   END IF
                END IF
 
            WHEN r.getTagName() = "Column"
                LET value = lsax_attrib.getValue("value")
                LET column_cnt = value
                IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                    LET str_cnt = FGL_WIDTH(l_str)
                    LET column_cnt = column_cnt - str_cnt - 1
                    #FUN-810047
                    #FOR j = 1 to column_cnt
                    #      LET l_str = l_str," "
                    #END FOR
                    LET l_str = l_str, column_cnt SPACES
                    #END FUN-810047
 
                ELSE
                    LET l_i = l_i + 1               #
                END IF
 
            WHEN r.getTagName() = "NoSkip"
                 LET cnt_noskip = 1
 
          END CASE
 
        WHEN "EndElement"
          CASE
            WHEN r.getTagName() = "Print"
               IF (cnt_noskip = 0) THEN  #判斷print是否有「;」(noskip)連接
                ###表頭、表尾資料合併，除了表頭欄位內容(l_tr=> [Y]:合併，[N]:切割)
                IF l_tr = "N" THEN  
                  IF (g_body_title_pos - 1 <> cnt) AND (n_id_name == "PageHeader") 
                    OR (n_id_name == "PageTrailer") THEN
                    LET str_center = "N"
                    IF n_id_name == "PageHeader" THEN
                      IF (cnt < 3+g_top) AND (NOT l_str.equals(g_company)) THEN  #TQC-710026
                         #No.FUN-810047
                         #OPEN cl_trans_curs                       #FUN-570052
                         #FOREACH cl_trans_curs INTO g_xml_value
                         #     IF l_str.equals(g_x[g_xml_value]) THEN
                         #        LET str_center = "Y"
                         #        EXIT FOREACH
                         #     END IF
                         #END FOREACH
                         FOR j = 1 TO g_zaa02.getLength()
                             IF l_str.equals(g_x[g_zaa02[j]]) THEN
                                LET str_center = "Y"
                                EXIT FOR
                             END IF
                         END FOR
                         #END No.FUN-810047
 
                       END IF
                     END IF
                     IF str_center = "Y" THEN
                        LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(l_str),"&nbsp;"    #FUN-580019  #No.FUN-A90047   #CHI-B30026
                     ELSE 
                        LET l_str = "<TR height=22><TD colspan=",g_column_cnt,">",cl_add_span(l_str),"&nbsp;"               #FUN-580019  #No.FUN-A90047  #CHI-B30026
                     END IF
                  ELSE
                    LET l_str = "<TR height=22>",l_str   #No.FUN-A90047
                  END IF
                END IF
                #TQC-6A0113
                #IF (l_pageheader = "Y") OR (l_str.equals(g_dash CLIPPED)) OR 
                #   (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED)) 
                #THEN
                IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                    (l_str = g_dash1) OR (l_str = g_dash2_out)
                THEN
                #END TQC-6A0113
             
                   IF (l_pageheader = "Y") THEN
                         LET l_str = l_str ,"</TD></TR>"           #CHI-B30026
                   END IF
             
                ELSE
                   IF (g_body_title_pos - 1 <> cnt) THEN      #FUN-5A0135
                     IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                        FOR j = 1 to g_value.getLength()   
                          LET g_xml_value = g_value[j].zaa02    
                       #FUN-570052 
                          LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                          LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                          LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                          LET g_item[j].zaa08 = ""
                          LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                          LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                          LET g_item[j].column = g_c[g_xml_value]
                        END FOR
                      
                       #END FUN-570052 
             
                        FOR k = 1 to g_item.getLength()
                            IF g_item[k].zaa05 IS NOT NULL THEN
                               LET j = g_item[k].zaa07
                               LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                               LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                               LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item_sort_1[j].column=g_item[k].column
                               LET g_item_sort_1[j].sure=g_item[k].sure
                            END IF
                        END FOR
             
                        FOR k = 1 to g_item_sort_1.getLength()
                            IF g_item_sort_1[k].zaa05 IS NULL THEN
                                  CALL g_item_sort_1.deleteElement(k)                   
                                  LET k = k - 1
                            END IF
                        END FOR
                        LET tag = 0
                        LEt tag2 = 0
                        FOR k = 1 TO g_item2.getLength()
                           #TQC-6B0006
                           IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                             CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                             LET INT_FLAG = 1
                             RETURN
                           END IF
                           #END TQC-6B0006
                           LET g_cnt = g_item_sort_1.getLength() #TQC-950138
                           FOR j = 1 to g_cnt                    #TQC-950138
                             IF (g_item_sort_1[j].zaa05 IS NOT NULL) OR (g_item_sort_1[j].zaa05 <> 0 ) THEN
                                IF (j = g_item_sort_1.getLength()) AND (g_item2[k].column > g_item_sort_1[j].column-1) THEN
                                   LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                   EXIT FOR
                                ELSE
                                   IF (g_item2[k].column > g_item_sort_1[j].column-1) AND 
                                      (g_item2[k].column < g_item_sort_1[j+1].column) THEN
                                      IF (g_item_sort_1[j].sure IS NULL) OR (g_item_sort_1[j].sure = "") THEN
                                          LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item_sort_1[j].sure="Y"
                                          LET tag = j
                                      ELSE
                                          LET tag = tag + 1
                                          LET g_item_sort_1[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item_sort_1[tag].sure="Y"
                                       END IF
                             
                                     EXIT FOR
                                   END IF
                                END IF
                             END IF
                           END FOR
                        END FOR 
                        LET l_pageheader = "N"
                        LET g_sort="Y"
                      END IF
                   END IF
                  IF l_pageheader == "N" THEN
                     IF g_sort = "N" THEN
                          FOR k = 1 to g_item.getLength()
                            LET j = g_item[k].zaa07
                            LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                            LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                            LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                            LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                            LET g_item_sort_1[j].column=g_item[k].column
                            LET g_item_sort_1[j].sure=g_item[k].sure
                          END FOR
                     END IF
                     FOR k = 1 to g_item_sort_1.getLength()
                        IF g_item_sort_1[k].zaa06 = 'N' THEN
                          IF (g_zaa13_value = "N" ) OR
                             (g_body_title_pos - 1 = cnt)          #TQC-5B0055
                          THEN
                             LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                             ## MOD-580150 ###
                             LET column_cnt = g_item_sort_1[k].zaa05 - str_cnt 
                             ## MOD-580150 ###
                             #No.FUN-6A0159 --start--
                             IF NOT ((g_body_title_pos - 1 = cnt) AND
                                 (g_item_sort_1[k].zaa14 MATCHES '[ABCDEFQ]'))
                             THEN
                                FOR j = 1 to column_cnt
                                   LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 CLIPPED, "&nbsp;"  #echo 
                                END FOR
                             END IF
                             #No.FUN-6A0159 --end--
                          END IF
                          #FUN-6B0006---start--- 
                          IF g_aza.aza66 = 2 AND (g_body_title_pos - 1 != cnt) THEN 
                             LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                             IF str_cnt > g_item_sort_1[k].zaa05 THEN
                                   LET g_item_sort_1[k].zaa08 = ""
                                   FOR j = 1 to g_item_sort_1[k].zaa05
                                       LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08, "#"
                                   END FOR
                             END IF
                          END IF
                          #FUN-6B0006---end--- 
                          IF (g_item_sort_1[k].zaa08 IS NULL) OR (g_item_sort_1[k].zaa08 CLIPPED = " ") THEN
                             LET g_item_sort_1[k].zaa08 = "&nbsp;"
                          END IF
                          #No.FUN-6A0159 --start--
                          IF (g_body_title_pos - 1 = cnt) AND
                              (g_item_sort_1[k].zaa14 MATCHES '[ABCDEFQ]')
                          THEN   #是否為單身抬頭
                             LET l_str = l_str CLIPPED,"<TD align=center>", cl_add_span(g_item_sort_1[k].zaa08),"</TD>"  #CHI-B30026
                          ELSE
                             LET l_str = l_str CLIPPED,"<TD>",  cl_add_span(g_item_sort_1[k].zaa08),"</TD>"     #FUN-580019   #CHI-B30026
                          END IF
                          #No.FUN-6A0159 --end--
                        END IF
                     END FOR
                     LET l_str = l_str CLIPPED,"</TR>"
                  END IF
                END IF
                IF (l_str = "<TR height=22></TD></TR>") THEN   #No.FUN-A90047   #CHI-B30026
                   LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;</TD></TR>" #No.FUN-A90047  #CHI-B30026
                END IF
                   CALL l_channel.write(l_str)
                   LET cnt=cnt+1
                   IF ( cnt > g_pagelen) THEN
                        FOR k = 1 to g_bottom 
                            LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;</TD></TR>" #No.FUN-A90047  #CHI-B30026
                            CALL l_channel.write(l_str)
                        END FOR
                        #### 分頁格線 ####
                        LET l_str="</TABLE></div>",
                                  "<p></p>",
                                  "<div align=center>",
                                  "<TABLE border=1 cellSpacing=0 cellPadding=1 STYLE=",g_quote,"font-size: 8pt",g_quote,"  BORDERCOLOR=\"#DFDFDF\">"        #FUN-580019
                        CALL l_channel.write(l_str)
             
                        LET cnt= 0
                        IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                           CALL cl_progressing("process: xml")            #FUN-570141
                        END IF                   ### FUN-570264 ###
                        LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170 
                   END IF
                   LET l_str = ""
                   LET l_i = 0                                 #g_item2陣列數
                   LET column_cnt = 1
                   LET l_tr = "N"  
                   LET g_sort = "N"
                   CALL g_item.clear()
                   CALL g_item2.clear()
                   CALL g_item_sort_1.clear()
                   LET l_pageheader = "Y"
                 END IF  
 
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
 
          END CASE
 
      END CASE
      LET e= r.read()
   END WHILE
   #END FUN-570208
 
   CLOSE cl_trans_curs                           #FUN-570141
   CALL l_channel.write("</TABLE></div></body></html>")    ##FUN-A90047
   CALL l_channel.close()
END FUNCTION
 
##################################################
# Descriptions...: Excel格式(一行)
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_excel()
DEFINE  output_type,l_pageheader,l_tr           LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        str_center                              LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        l_channel                               base.Channel,
        cnt_print,i,j,h,cnt_noskip              LIKE type_file.num10,       #No.FUN-690005 integer,
        k,column_cnt,tag,tag2                   LIKE type_file.num10,       #No.FUN-690005 integer,
        cnt,str_cnt,cnt_column,l_i              LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        l_str,value,l_cmd,n_name,l_skip_tag     string
DEFINE  l_bufstr                                base.StringBuffer  #TQC-650109
#FUN-670044
DEFINE  l_value_len                             LIKE type_file.num10,
        l_dec                                   LIKE type_file.num10,
        l_dec_point                             LIKE type_file.num10,
        l_zaa08_value                           STRING
#END FUN-670044
DEFINE l_td_attr                                STRING   #No.FUN-6A0159
DEFINE l_class_id                               STRING   #FUN-A900

 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
 
   #FUN-570052
   #計算g_dash個數
   LET g_dash_cnt = 0
  #LET l_cmd = "grep -c \"",g_dash CLIPPED,"*\" ",g_xml_name CLIPPED
   LET l_cmd = "grep -c \"",g_dash_out ,"*\" ",g_xml_name CLIPPED  #TQC-6A0113
 
   LET l_channel = base.Channel.create()
   CALL l_channel.openPipe(l_cmd, "r")
   WHILE l_channel.read(l_str)
       LET g_dash_cnt = l_str
   END WHILE
   CALL l_channel.close()
   #END FUN-570052
   #FUN-6B0006---start---
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' AND g_aza.aza66 = 2 THEN
      LET g_dash_cnt = g_dash_cnt - 1
   END IF
   #FUN-6B0006---end---
       
   LET cnt = 0
   LET l_str = ""

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --

   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(output_name,"a" )
   CALL l_channel.setDelimiter("")
 
    #FUN-570141
    LET g_sql = "SELECT zaa02 FROM zaa_file ",
                " where zaa01= '", g_prog ,"' AND zaa09='1' AND zaa04 = '",g_zaa04_value,
                "' AND zaa10 = '",g_zaa10_value,"' AND zaa11='",g_zaa11_value,
                "' AND zaa17 = '",g_zaa17_value,"'"
    PREPARE cl_trans2_prepare FROM g_sql           #預備一下
    DECLARE cl_trans2_curs CURSOR FOR cl_trans2_prepare
    #END FUN-570141
 
   CALL cl_excel_column() RETURNING l_str    #MOD-580063
   CALL l_channel.write(l_str)
 
   LET l_str = ""
   LET g_print_dash = 0
   LET l_i = 0                                 #g_item2陣列數
   LET column_cnt = 1
   LET l_tr = "N"  
   LET g_sort = "N"
   LET l_pageheader = "Y"                      #pageheader的tag #FUN-5A0135
 
 ## 讀取報表資料
   #FUN-570208
   LET n_id_name = "xml"
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
          CASE
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "PageTrailer"
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "PageHeader"
 
            WHEN r.getTagName() = "Print"
                LET n_name = r.getTagName()
                LET g_print_name = lsax_attrib.getValue("name")   #TQC-710026
                LET cnt_noskip = 0
                IF g_print_dash >= g_dash_cnt THEN
                   LET n_id_name = "PageTrailer"
                END IF
                #LET l_pageheader = "N"                     #FUN-5A0135
 
            WHEN r.getTagName() = "Item"
                LET value = lsax_attrib.getValue("value")
                #TQC-650109
                CALL l_bufstr.clear()
                CALL l_bufstr.append(value)
                IF NOT cl_null(value) THEN
                   CALL l_bufstr.replace("<","&lt;",0)
                END IF
                LET value = l_bufstr.tostring()
                #END TQC-650109
 
                ### 公司名稱 合併
                IF value = g_company AND n_id_name == "PageHeader" THEN   #FUN-690088
                    LET l_str = "<TR height=22><TD bgcolor=#FFCC99 colspan=",g_column_cnt," align=center >",cl_add_span(value),"</TD></TR>"  #No.FUN-A90047   #CHI-B30026
                    LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                
                #TQC-710026
                #動態報表名稱
                IF g_print_name = "rep_name" THEN
                    LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(value),"</TD></TR>"  #No.FUN-A90047  #CHI-B30026
                    LET l_tr = "Y"
                    LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                #TQC-710026
 
                ### 虛線不列印
                #TQC-6A0113
                #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED))
                # OR (value.equals(g_dash2 CLIPPED))THEN
                #   IF value.equals(g_dash CLIPPED) THEN
                IF (value = g_dash1) OR (value = g_dash_out) OR
                   (value = g_dash2_out)
                THEN
                   IF value = g_dash_out THEN
                #END TQC-6A0113
 
                       LET g_print_dash = g_print_dash + 1
                   END IF   
                   LET l_str = "<TR height=22><TD colspan=",g_column_cnt ,"> &nbsp;</TD></TR>"   #No.FUN-A90047  #CHI-B30026
                   LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                   EXIT CASE
                END IF
                 
                ### 欄位虛線不列印
                #FUN-690088
                #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
                #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
                #THEN
                #   LET value = g_dash CLIPPED
                #   LET l_str = "<TR height=22><TD colspan=",g_view_cnt ,"> &nbsp;</TD></TR>"   #No.FUN-A90047
                #   LET l_tr = "Y"
                #   LET l_pageheader= "Y"     
                #   EXIT CASE
                #END IF
                #END FUN-690088
          
                IF (g_body_title_pos - 1 = cnt) THEN   #是否為單身抬頭
                   LET j = l_i + 1
                   LET g_xml_value = value 
                   #FUN-570052  
                   LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                   LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                   LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                   #TQC-5B0170
                   IF g_zaa_dyn.getLength() > 0 THEN
                      LET g_item[j].zaa08 = g_zaa_dyn[g_page_cnt,g_xml_value]
                   ELSE
                      LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                   END IF
                   #END TQC-5B0170
                   LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                   LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #MOD-580063
                   LET g_item[j].column = g_c[g_xml_value]
                   #END FUN-570052  
                   LET l_i = l_i + 1
                   LET l_pageheader = "N"                #FUN-5A0135
                ELSE
                   IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                      IF (cnt < 3+g_top )THEN               ##TQC-710026
                           IF l_str.trim() = " " THEN
                                LET l_str = value
                           ELSE
                                LET l_str = l_str,value
                           END IF
                       ELSE
                           LET l_str = l_str,value
                           IF i = 1 AND (cnt_column != 0 )THEN
                              LET l_str = l_str," "
                           END IF
                      END IF
                      LET l_pageheader= "Y"     
                   ELSE
                        IF l_i = 0 THEN  
                          LET l_i = l_i + 1
                        ELSE
                          IF g_item2[l_i].zaa08 IS NOT NULL THEN
                               LET value = g_item2[l_i].zaa08 CLIPPED,value
                          END IF
                        END IF
                        LET g_item2[l_i].zaa08 = value CLIPPED               ### item value
                        LET g_item2[l_i].column = column_cnt         ### item value
                        LET l_pageheader= "N"
                   END IF
                END IF
            WHEN r.getTagName() = "Column"
                LET value = lsax_attrib.getValue("value")
                LET column_cnt = value
                IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                    LET str_cnt = FGL_WIDTH(l_str)
                    LET column_cnt = column_cnt - str_cnt - 1
                    #FUN-810047
                    #FOR j = 1 to column_cnt
                    #      LET l_str = l_str," "
                    #END FOR
                    LET l_str = l_str, column_cnt SPACES
                    #END FUN-810047
                ELSE
                    LET l_i = l_i + 1               #
                END IF
 
            WHEN r.getTagName() = "NoSkip"
                 LET cnt_noskip = 1
 
          END CASE
 
        WHEN "EndElement"
          CASE
            WHEN r.getTagName() = "Print"
              IF (cnt_noskip = 0) THEN  #判斷print是否有「;」(noskip)連接
               ###表頭、表尾資料合併，除了表頭欄位內容(l_tr=> [Y]:合併，[N]:切割)
               IF l_tr = "N" THEN  
                 IF (g_body_title_pos - 1 <> cnt) AND (n_id_name == "PageHeader") 
                   OR (n_id_name == "PageTrailer") THEN
                   LET str_center = "N"
                   IF n_id_name == "PageHeader" THEN
                     IF (cnt < 3+g_top) AND (NOT l_str.equals(g_company)) THEN  #TQC-710026
                        #No.FUN-810047
                        #OPEN cl_trans2_curs                       #FUN-570052
                        #FOREACH cl_trans2_curs INTO g_xml_value
                        #     IF l_str.equals(g_x[g_xml_value]) THEN
                        #        LET str_center = "Y"
                        #        EXIT FOREACH
                        #     END IF
                        #END FOREACH
                        FOR j = 1 TO g_zaa02.getLength()
                            IF l_str.equals(g_x[g_zaa02[j]]) THEN
                               LET str_center = "Y"
                               EXIT FOR
                            END IF
                        END FOR
                        #END No.FUN-810047
                      END IF
                    END IF
                    IF str_center = "Y" THEN
                       LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",l_str CLIPPED,"&nbsp;"    #FUN-580019  #No.FUN-A90047   #CHI-B30026
                    ELSE 
                       LET l_str = "<TR height=22><TD colspan=",g_column_cnt,">",cl_add_span(l_str),"&nbsp;"      #FUN-580019 ##MOD-590325  #No.FUN-A90047  #CHI-B30026
                    END IF
                 ELSE
                   LET l_str = "<TR height=22>",l_str   #No.FUN-A90047
                 END IF
               END IF
               #TQC-6A0113
               #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR 
               #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED)) THEN
               IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                   (l_str = g_dash1) OR (l_str = g_dash2_out) THEN
               #END TQC-6A0113
            
                  IF (l_pageheader = "Y") THEN
                        LET l_str = l_str ,"</TD></TR>"
                  END IF
            
               ELSE
                  IF (g_body_title_pos - 1 <> cnt) THEN      #FUN-5A0135
                    IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                       FOR j = 1 to g_value.getLength()   
                         LET g_xml_value = g_value[j].zaa02    
                      #FUN-570052 
                         LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                         LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                         LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                         LET g_item[j].zaa08 = ""
                         LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED 
                         LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #MOD-580063
                         LET g_item[j].column = g_c[g_xml_value]
                       END FOR
                      #END FUN-570052 
            
                       FOR k = 1 to g_item.getLength()
                           IF g_item[k].zaa05 IS NOT NULL THEN
                              LET j = g_item[k].zaa07
                              LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                              LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                              LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                              LET g_item_sort_1[j].column=g_item[k].column
                              LET g_item_sort_1[j].sure=g_item[k].sure
                              LET g_item_sort_1[j].zaa14=g_item[k].zaa14 #MOD-580063
                           END IF
                       END FOR
            
                       FOR k = 1 to g_item_sort_1.getLength()
                           IF g_item_sort_1[k].zaa05 IS NULL THEN
                                 CALL g_item_sort_1.deleteElement(k)                   
                                 LET k = k - 1
                           END IF
                       END FOR
                       LET tag = 0
                       LEt tag2 = 0
                       FOR k = 1 TO g_item2.getLength()
                          #TQC-6B0006
                          IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                            CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                            LET INT_FLAG = 1
                            RETURN
                          END IF
                          #END TQC-6B0006
                          LET g_cnt = g_item_sort_1.getLength() #TQC-950138
                          FOR j = 1 to g_cnt                    #TQC-950138
                            IF (g_item_sort_1[j].zaa05 IS NOT NULL) OR (g_item_sort_1[j].zaa05 <> 0 ) THEN
                               IF (j = g_item_sort_1.getLength()) AND (g_item2[k].column > g_item_sort_1[j].column-1) THEN
                                  LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                  EXIT FOR
                               ELSE
                                  IF (g_item2[k].column > g_item_sort_1[j].column-1) AND 
                                     (g_item2[k].column < g_item_sort_1[j+1].column) THEN
                                     IF (g_item_sort_1[j].sure IS NULL) OR (g_item_sort_1[j].sure = "") THEN
                                         LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                         LET g_item_sort_1[j].sure="Y"
                                         LET tag = j
                                     ELSE
                                         LET tag = tag + 1
                                         LET g_item_sort_1[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                         LET g_item_sort_1[tag].sure="Y"
                                      END IF
                            
                                    EXIT FOR
                                  END IF
                               END IF
                            END IF
                          END FOR
                       END FOR 
                       LET l_pageheader = "N"
                       LET g_sort="Y"
                     END IF
                  END IF
                 IF l_pageheader == "N" THEN
                    IF g_sort = "N" THEN
                         FOR k = 1 to g_item.getLength()
                           LET j = g_item[k].zaa07
                           LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                           LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                           LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                           LET g_item_sort_1[j].column=g_item[k].column
                           LET g_item_sort_1[j].sure=g_item[k].sure
                           LET g_item_sort_1[j].zaa14=g_item[k].zaa14 #MOD-580063
                         END FOR
                    END IF
                    FOR k = 1 to g_item_sort_1.getLength()
                       IF g_item_sort_1[k].zaa06 = 'N' THEN
                          #TQC-6C0088
                          #IF g_zaa13_value = "N" THEN
                          #   LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                          #   ### MOD-580150 ###
                          #   LET column_cnt = g_item_sort_1[k].zaa05 - str_cnt 
                          #   ### MOD-580150 ###
                          #   FOR j = 1 to column_cnt
                          #      #LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 CLIPPED, "&nbsp;"  #echo 
                          #      LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 CLIPPED                   ##MOD-5A0152
                          #   END FOR
                          #END IF
                          #END TQC-6C0088
                          #FUN-660179
                          #FUN-6B0006---start--- 
                          #IF g_aza.aza66 = 2 AND (g_body_title_pos - 1 != cnt) THEN 
                          #   LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                          #   IF str_cnt > g_item_sort_1[k].zaa05 THEN
                          #         LET g_item_sort_1[k].zaa08 = ""
                          #         FOR j = 1 to g_item_sort_1[k].zaa05
                          #             LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08, "#"
                          #         END FOR
                          #   END IF
                          #END IF
                          #FUN-6B0006---end--- 
                          #END FUN-660179
                         IF (g_item_sort_1[k].zaa08 IS NULL) OR (g_item_sort_1[k].zaa08 CLIPPED = " ") THEN
                            LET g_item_sort_1[k].zaa08 = "&nbsp;"
                         END IF
                        #FUN-670044
                        #IF g_item_sort_1[k].zaa14 MATCHES "[JKNOPQR]"  THEN
                        #      #TQC-6A0067 
                        #      IF FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED) > 255 THEN
                        #         LET l_str = l_str CLIPPED,"<TD>",  g_item_sort_1[k].zaa08 CLIPPED,"</TD>"     #FUN-580019
                        #      ELSE
                        #         LET l_str = l_str CLIPPED,"<TD class=xl24>",  g_item_sort_1[k].zaa08 CLIPPED,"</TD>"     #FUN-580019
                        #      END IF
                        #      #END TQC-6A0067 
                        #ELSE
                        #      LET l_str = l_str CLIPPED,"<TD>",  g_item_sort_1[k].zaa08 CLIPPED,"</TD>"     #FUN-580019
                        #END IF
                         #No.FUN-6A0159 -- start --
                         IF (g_body_title_pos - 1 = cnt) THEN   #是否為單身抬頭
                            #TQC-6C0088
                            #CASE 
                            #    WHEN g_item_sort_1[k].zaa14 MATCHES '[JKNOPQR]'
                            #        IF FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED) <= 255 THEN
                            #            LET l_td_attr = " class=124"
                            #        END IF
                            #    WHEN g_item_sort_1[k].zaa14 MATCHES '[EF]'
                            #        LET l_td_attr = " class=130"
                            #    OTHERWISE
                            #        LET l_td_attr = ""
                            #END CASE
                            LET l_td_attr = " class=xl24"
                            IF g_item_sort_1[k].zaa14 MATCHES '[ABCDEFQ]' THEN
                                LET l_td_attr = l_td_attr," align=center"
                            ELSE
                                LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08)
                                LET column_cnt = g_item_sort_1[k].zaa05 - str_cnt + 1
                                FOR j = 1 to column_cnt
                                    LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 CLIPPED , "&nbsp;"
                                END FOR
                            END IF
                            LET l_str = l_str CLIPPED,"<TD",l_td_attr,">",  cl_add_span(g_item_sort_1[k].zaa08) ,"</TD>"  #TQC-6C0088  #CHI-B30026
                         ELSE
                            CASE 
                             WHEN g_item_sort_1[k].zaa14 = 'J' OR g_item_sort_1[k].zaa14 = 'K' OR
                                  g_item_sort_1[k].zaa14 = 'N' OR g_item_sort_1[k].zaa14 = 'O' OR
                                  g_item_sort_1[k].zaa14 = 'P' OR g_item_sort_1[k].zaa14 = 'Q' OR
                                  g_item_sort_1[k].zaa14 = 'R'
                                  #No.CHI-960073 -- start --
                                  #FUN-780064 
                                  #CALL l_bufstr.clear()
                                  #CALL l_bufstr.append(g_item_sort_1[k].zaa08 CLIPPED)
                                  #CALL l_bufstr.replace(" ","&nbsp;",0)
                                  #LET g_item_sort_1[k].zaa08 = l_bufstr.tostring()
                                  #END FUN-780064 
                                  #TQC-6A0067
                                  IF FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED) > 255 THEN
                                     LET l_str = l_str CLIPPED,"<TD>",  cl_add_span(g_item_sort_1[k].zaa08),"</TD>"    #CHI-B30026
                                  ELSE
                                     LET l_str = l_str CLIPPED,"<TD class=xl24>",  cl_add_span(g_item_sort_1[k].zaa08),"</TD>"    #CHI-B30026
                                  END IF
                                  #END TQC-6A0067
                                  #No.CHI-960073 -- end --

                             #FUN-A90058 -- start --
                             #FUN-950066 -- start --
                             WHEN g_item_sort_1[k].zaa14 MATCHES '[ABCDEF]'
                                  LET l_value_len = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                                  LET l_zaa08_value = g_item_sort_1[k].zaa08 CLIPPED
                                  LET l_dec_point = l_zaa08_value.getIndexOf(".",1)
                                  LET l_zaa08_value = g_item_sort_1[k].zaa08 CLIPPED
                                  LET l_dec_point = l_zaa08_value.getIndexOf(".",1)

                                  IF l_dec_point > 0 THEN
                                     LET l_dec = l_value_len - l_dec_point
                                     IF l_dec >= 10 THEN
                                        IF g_item_sort_1[k].zaa14 MATCHES '[ABDEF]' THEN #單價、金額、總計
                                           LET l_class_id = "xl60"
                                        ELSE
                                           LET l_class_id = "xl40"
                                        END IF
                                     ELSE
                                        IF g_item_sort_1[k].zaa14 MATCHES '[ABDEF]' THEN  #單價、金額、總計
                                           LET l_class_id = "xl5", l_dec USING '<<<<<<<<<<'
                                        ELSE
                                           LET l_class_id = "xl3", l_dec USING '<<<<<<<<<<'
                                        END IF
                                     END IF
                                  ELSE
                                     IF g_item_sort_1[k].zaa14 MATCHES '[ABDEF]' THEN  #單價、金額、總計
                                        LET l_class_id = "xl50"
                                     ELSE
                                        LET l_class_id = "xl30"
                                     END IF
                                  END IF
                                  LET l_str = l_str CLIPPED,"<TD class=",l_class_id,">",  l_zaa08_value.trim(),"</TD>"     #CHI-B30026
                             #FUN-950066 -- end --
                             #FUN-A90058 -- end --

                             OTHERWISE
                                  LET l_str = l_str CLIPPED,"<TD>",  cl_add_span(g_item_sort_1[k].zaa08),"</TD>" #No.CHI-960073   #CHI-B30026
                            END CASE
                            #END FUN-670044
                         END IF
                         #No.FUN-6A0159 --end-- 
                       END IF
                    END FOR
                    LET l_str = l_str CLIPPED,"</TR>"
                 END IF
               END IF
               IF (l_str = "<TR height=22></TD></TR>") THEN   #No.FUN-A90047
                  LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;</TD></TR>"   #No.FUN-A9004  #CHI-B30026
               END IF
                  CALL l_channel.write(l_str)
                  LET cnt=cnt+1
                  IF ( cnt > g_pagelen) THEN
                       FOR k = 1 to g_bottom 
                            LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;</TD></TR>"   #No.FUN-A90047   #CHI-B30026
                           CALL l_channel.write(l_str)
                       END FOR
                       #### 分頁格線 ####
                       LET l_str="</TABLE></div><p></p>",
                                 "<div align=center>",
                                 "<TABLE border=1 cellSpacing=0 cellPadding=1 STYLE=",g_quote,"font-size: 8pt",g_quote,"  BORDERCOLOR=\"#DFDFDF\">"        #FUN-580019
                       CALL l_channel.write(l_str)
                       LET cnt= 0
                       IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                          CALL cl_progressing("process: xml")            #FUN-570141
                       END IF                   ### FUN-570264 ###
                       LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                  END IF
                  LET l_str = ""
                  LET l_i = 0                                 #g_item2陣列數
                  LET column_cnt = 1
                  LET l_tr = "N"  
                  LET g_sort = "N"
                  CALL g_item.clear()
                  CALL g_item2.clear()
                  CALL g_item_sort_1.clear()
                  LET l_pageheader = "Y"
                END IF  
 
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
 
          END CASE
 
      END CASE
      LET e= r.read()
   END WHILE
   #END FUN-570208
 
   CLOSE cl_trans2_curs                           #FUN-570141
   CALL l_channel.write("</TABLE></div></body></html>")    ##FUN-A90047
   CALL l_channel.close()

   CALL cl_trans_excel_replace_tags(output_name)  #CHI-D20019
END FUNCTION
#END MOD-580063
 
##################################################
# Descriptions...: Word格式(一行)
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_word()      #MOD-480063
DEFINE  output_type,l_pageheader,l_tr           LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        str_center                              LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        l_channel                               base.Channel,
        cnt_print,cnt_item,i,j,h,cnt_noskip     LIKE type_file.num10,       #No.FUN-690005 integer,
        k,column_cnt,tag,tag2                   LIKE type_file.num10,       #No.FUN-690005 integer,
        cnt,str_cnt,cnt_column,l_i              LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        l_str,value,l_cmd,n_name,l_skip_tag     string
DEFINE  l_bufstr                                base.StringBuffer  #TQC-650109
 
DEFINE l_td_attr STRING #No.FUN-6A0159
 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
 
   #FUN-570052
   #計算g_dash個數
   LET g_dash_cnt = 0
  #LET l_cmd = "grep -c \"",g_dash CLIPPED,"*\" ",g_xml_name CLIPPED
   LET l_cmd = "grep -c \"",g_dash_out ,"*\" ",g_xml_name CLIPPED  #TQC-6A0113
 
   LET l_channel = base.Channel.create()
   CALL l_channel.openPipe(l_cmd, "r")
   WHILE l_channel.read(l_str)
       LET g_dash_cnt = l_str
   END WHILE
   CALL l_channel.close()
   #END FUN-570052
   #FUN-6B0006---start---
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' AND g_aza.aza66 = 2 THEN
      LET g_dash_cnt = g_dash_cnt - 1
   END IF
   #FUN-6B0006---end---
       
   LET cnt = 0
   LET l_str = ""

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --

   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(output_name,"a" )
   CALL l_channel.setDelimiter("")
 
    #FUN-570141
    LET g_sql = "SELECT zaa02 FROM zaa_file ",
                " where zaa01= '", g_prog ,"' AND zaa09='1' AND zaa04 = '",g_zaa04_value,
                "' AND zaa10 = '",g_zaa10_value,"' AND zaa11='",g_zaa11_value,
                "' AND zaa17 = '",g_zaa17_value,"'"
    PREPARE cl_trans3_prepare FROM g_sql           #預備一下
    DECLARE cl_trans3_curs CURSOR FOR cl_trans3_prepare
    #END FUN-570141
 
 
   CALL cl_trans_column(column_cnt) RETURNING l_str
   CALL l_channel.write(l_str)
 
   LET l_str = ""
   LET g_print_dash = 0
   LET l_i = 0                                 #g_item2陣列數
   LET column_cnt = 1
   LET l_tr = "N"  
   LET g_sort = "N"
   LET l_pageheader = "Y"                      #pageheader的tag #FUN-5A0135
 
 ## 讀取報表資料
   #FUN-570208
   LET n_id_name = "xml"
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
          CASE
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "PageTrailer"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "PageHeader"
 
            WHEN r.getTagName() = "Print"
                LET n_name = r.getTagName()
                LET g_print_name = lsax_attrib.getValue("name")   #TQC-710026
                LET cnt_noskip = 0
                IF g_print_dash >= g_dash_cnt THEN
                   LET n_id_name = "PageTrailer"
                END IF
                #LET l_pageheader = "N"                           #FUN-5A0135
 
            WHEN r.getTagName() = "Item"
                LET value = lsax_attrib.getValue("value")
                #TQC-650109
                CALL l_bufstr.clear()
                CALL l_bufstr.append(value)
                IF NOT cl_null(value) THEN
                   CALL l_bufstr.replace("<","&lt;",0)
                END IF
                LET value = l_bufstr.tostring()
                #END TQC-650109
 
                ### 公司名稱 合併
                IF value = g_company AND n_id_name == "PageHeader" THEN   #FUN-690088
                    LET l_str = "<TR height=22><TD NOWRAP bgcolor=#FFCC99 colspan=",g_column_cnt," align=center >",cl_add_span(value),"</TD></TR>"   #No.FUN-A90047 #CHI-B30026 
                    LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                
                #TQC-710026
                #動態報表名稱
                IF g_print_name = "rep_name" THEN
                    LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(value),"</TD></TR>"   #No.FUN-A90047 #CHI-B30026 
                    LET l_tr = "Y"
                    LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                #TQC-710026
 
                ### 虛線不列印
                #TQC-6A0113
                #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED))
                #OR (value.equals(g_dash2 CLIPPED))THEN
                #   IF value.equals(g_dash CLIPPED) THEN
                IF (value = g_dash1) OR (value = g_dash_out)
                OR (value = g_dash2_out)
                THEN
                   IF value = g_dash_out THEN
                #END TQC-6A0113
 
                       LET g_print_dash = g_print_dash + 1
                   END IF   
                   LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt,">&nbsp;</TD></TR>"   #No.FUN-A90047  #CHI-B30026 
                    LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                   EXIT CASE
                END IF
                 
                ### 欄位虛線不列印
                #FUN-690088
                #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
                #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
                #THEN
                #   LET value = g_dash CLIPPED
                #   LET l_str = "<TR height=22><TD NOWRAP colspan=",g_view_cnt ,"> &nbsp;</TD></TR>"
                #   LET l_tr = "Y"
                #   LET l_pageheader= "Y"     
                #   EXIT CASE
                #END IF
                #END FUN-690088
               
                IF (g_body_title_pos - 1 = cnt) THEN   #是否為單身抬頭
                   LET j = l_i + 1
                   LET g_xml_value = value 
                   #FUN-570052  
                   LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                   LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                   LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                   #TQC-5B0170
                   IF g_zaa_dyn.getLength() > 0 THEN
                      LET g_item[j].zaa08 = g_zaa_dyn[g_page_cnt,g_xml_value]
                   ELSE
                      LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                   END IF
                   #END TQC-5B0170
                   LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                   LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                   LET g_item[j].column = g_c[g_xml_value]
                   #END FUN-570052  
                   LET l_i = l_i + 1
                   LET l_pageheader = "N"                #FUN-5A0135
                ELSE
                   IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                      IF (cnt < 3+g_top )THEN              #TQC-710026
                           IF l_str.trim() = " " THEN
                                LET l_str = value
                           ELSE
                                LET l_str = l_str,value
                           END IF
                       ELSE
                           LET l_str = l_str,value
                           IF i = 1 AND (cnt_column != 0 )THEN
                              LET l_str = l_str," "
                           END IF
                      END IF
                      LET l_pageheader= "Y"     
                   ELSE
                        IF l_i = 0 THEN  
                          LET l_i = l_i + 1
                        ELSE
                          IF g_item2[l_i].zaa08 IS NOT NULL THEN
                               LET value = g_item2[l_i].zaa08 CLIPPED,value
                          END IF
                        END IF
                        LET g_item2[l_i].zaa08 = value CLIPPED               ### item value
                        LET g_item2[l_i].column = column_cnt         ### item value
                        LET l_pageheader= "N"
                   END IF
                END IF
 
            WHEN r.getTagName() = "Column"
                LET value = lsax_attrib.getValue("value")
                LET column_cnt = value
                IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                    LET str_cnt = FGL_WIDTH(l_str)
                    LET column_cnt = column_cnt - str_cnt - 1
                    #FUN-810047
                    #FOR j = 1 to column_cnt
                    #      LET l_str = l_str," "
                    #END FOR
                    LET l_str = l_str, column_cnt SPACES
                    #END FUN-810047
                ELSE
                    LET l_i = l_i + 1               #
                END IF
 
            WHEN r.getTagName() = "NoSkip"
                 LET cnt_noskip = 1
 
          END CASE
 
        WHEN "EndElement"
          CASE
            WHEN r.getTagName() = "Print"
               IF (cnt_noskip = 0) THEN  #判斷print是否有「;」(noskip)連接
                ###表頭、表尾資料合併，除了表頭欄位內容(l_tr=> [Y]:合併，[N]:切割)
                IF l_tr = "N" THEN  
                  IF (g_body_title_pos - 1 <> cnt) AND (n_id_name == "PageHeader") 
                    OR (n_id_name == "PageTrailer") THEN
                    LET str_center = "N"
                    IF n_id_name == "PageHeader" THEN
                      IF (cnt < 3+g_top) AND (NOT l_str.equals(g_company)) THEN  #TQC-710026
                         #No.FUN-810047
                         #OPEN cl_trans3_curs                       #FUN-570052
                         #FOREACH cl_trans3_curs INTO g_xml_value
                         #     IF l_str.equals(g_x[g_xml_value]) THEN
                         #        LET str_center = "Y"
                         #        EXIT FOREACH
                         #     END IF
                         #END FOREACH
                         FOR j = 1 TO g_zaa02.getLength()
                             IF l_str.equals(g_x[g_zaa02[j]]) THEN
                                LET str_center = "Y"
                                EXIT FOR
                             END IF
                         END FOR
                         #END No.FUN-810047
                       END IF
                     END IF
                     IF str_center = "Y" THEN
                        LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt," align=center>",cl_add_span(l_str),"&nbsp;"    #FUN-580019  #No.FUN-A90047 #CHI-B30026 
                     ELSE 
                        LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt,">",cl_add_span(l_str),"&nbsp;"               #FUN-580019  #No.FUN-A90047 #CHI-B30026 
                     END IF
                  ELSE
                    LET l_str = "<TR height=22>",l_str   #No.FUN-A90047
                  END IF
                END IF
                #TQC-6A0113
                #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR 
                #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED)) THEN
                 IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                     (l_str = g_dash1) OR (l_str = g_dash2_out) THEN
                #END TQC-6A0113
             
                   IF (l_pageheader = "Y") THEN
                         LET l_str = l_str ,"</TD></TR>"      #CHI-B30026 
                   END IF
             
                ELSE
                   IF (g_body_title_pos - 1 <> cnt) THEN   #FUN-5A0135
                     IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                        FOR j = 1 to g_value.getLength()   
                          LET g_xml_value = g_value[j].zaa02    
                       #FUN-570052 
                          LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                          LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                          LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                          LET g_item[j].zaa08 = ""
                          LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                          LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                          LET g_item[j].column = g_c[g_xml_value]
                        END FOR
                      
                       #END FUN-570052 
             
                        FOR k = 1 to g_item.getLength()
                            IF g_item[k].zaa05 IS NOT NULL THEN
                               LET j = g_item[k].zaa07
                               LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                               LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                               LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item_sort_1[j].column=g_item[k].column
                               LET g_item_sort_1[j].sure=g_item[k].sure
                            END IF
                        END FOR
             
                        FOR k = 1 to g_item_sort_1.getLength()
                            IF g_item_sort_1[k].zaa05 IS NULL THEN
                                  CALL g_item_sort_1.deleteElement(k)                   
                                  LET k = k - 1
                            END IF
                        END FOR
                        LET tag = 0
                        LEt tag2 = 0
                        FOR k = 1 TO g_item2.getLength()
                           #TQC-6B0006
                           IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                             CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                             LET INT_FLAG = 1
                             RETURN
                           END IF
                           #END TQC-6B0006
                           LET g_cnt = g_item_sort_1.getLength() #TQC-950138                          
                           FOR j = 1 to g_cnt                    #TQC-950138
                             IF (g_item_sort_1[j].zaa05 IS NOT NULL) OR (g_item_sort_1[j].zaa05 <> 0 ) THEN
                                IF (j = g_item_sort_1.getLength()) AND (g_item2[k].column > g_item_sort_1[j].column-1) THEN
                                   LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                   EXIT FOR
                                ELSE
                                   IF (g_item2[k].column > g_item_sort_1[j].column-1) AND 
                                      (g_item2[k].column < g_item_sort_1[j+1].column) THEN
                                      IF (g_item_sort_1[j].sure IS NULL) OR (g_item_sort_1[j].sure = "") THEN
                                          LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item_sort_1[j].sure="Y"
                                          LET tag = j
                                      ELSE
                                          LET tag = tag + 1
                                          LET g_item_sort_1[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item_sort_1[tag].sure="Y"
                                       END IF
                             
                                     EXIT FOR
                                   END IF
                                END IF
                             END IF
                           END FOR
                        END FOR 
                        LET l_pageheader = "N"
                        LET g_sort="Y"
                      END IF
                   END IF
                  IF l_pageheader == "N" THEN
                     IF g_sort = "N" THEN
                          FOR k = 1 to g_item.getLength()
                            LET j = g_item[k].zaa07
                            LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                            LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                            LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                            LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                            LET g_item_sort_1[j].column=g_item[k].column
                            LET g_item_sort_1[j].sure=g_item[k].sure
                          END FOR
                     END IF
                     FOR k = 1 to g_item_sort_1.getLength()
                        IF g_item_sort_1[k].zaa06 = 'N' THEN
                          IF (g_zaa13_value = "N" ) OR
                             (g_body_title_pos - 1 = cnt)          #TQC-5B0055
                          THEN
                             LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                             ## MOD-580150 ###
                             LET column_cnt = g_item_sort_1[k].zaa05 - str_cnt 
                             ## END MOD-580150 ###
                             LET g_item_sort_1[k].zaa08=g_item_sort_1[k].zaa08 CLIPPED    #TQC-5B0055
                             #No.FUN-6A0159 --start--
                             IF NOT ((g_body_title_pos - 1 = cnt) AND
                                (g_item_sort_1[k].zaa14 MATCHES '[ABCDEFQ]'))
                             THEN
                                #No.FUN-810047
                                #FOR j = 1 to column_cnt
                                #   LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 ," "  #TQC-5B0055
                                #END FOR
                                LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 , column_cnt SPACES  #TQC-5B0055
                                #END No.FUN-810047
                             END IF
                             #No.FUN-6A0159 --end--
                          END IF
                          #FUN-660179
                          #FUN-6B0006---start--- 
                          #IF g_aza.aza66 = 2 AND (g_body_title_pos - 1 != cnt) THEN 
                          #   LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                          #   IF str_cnt > g_item_sort_1[k].zaa05 THEN
                          #         LET g_item_sort_1[k].zaa08 = ""
                          #         FOR j = 1 to g_item_sort_1[k].zaa05
                          #             LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08, "#"
                          #         END FOR
                          #   END IF
                          #END IF
                          #FUN-6B0006---end--- 
                          #END FUN-660179
                          IF (g_item_sort_1[k].zaa08 IS NULL) OR (g_item_sort_1[k].zaa08 CLIPPED = " ")
                             AND (g_body_title_pos - 1 <> cnt)   ##TQC-5B0170                             
                          THEN
                             LET g_item_sort_1[k].zaa08 = " "      #TQC-5B0055
                          END IF
                          #No.FUN-6A0159 --start--
                          IF (g_body_title_pos - 1 = cnt) AND
                             (g_item_sort_1[k].zaa14 MATCHES '[ABCDEFQ]')
                          THEN   #是否為單身抬頭
                            LET l_str = l_str CLIPPED,"<TD NOWRAP align=center>",  cl_add_span(g_item_sort_1[k].zaa08) ,"</TD>"        #CHI-B30026 
                          ELSE
                            LET l_str = l_str CLIPPED,"<TD NOWRAP>", cl_add_span(g_item_sort_1[k].zaa08) ,"</TD>"     #FUN-580019 #TQC-5B0055 #CHI-B30026 
                          END IF
                          #No.FUN-6A0159 --end--
                        END IF
                     END FOR
                     LET l_str = l_str CLIPPED,"</TR>"
                  END IF
                END IF
                IF (l_str = "<TR height=22></TD></TR>") THEN   #No.FUN-A90047  #CHI-B30026 
                   LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt,"> &nbsp;</TD></TR>"   #No.FUN-A90047  #CHI-B30026 
                END IF
                   CALL l_channel.write(l_str)
                   LET cnt=cnt+1
                   IF ( cnt > g_pagelen) THEN
                        for k = 1 to g_bottom 
                            #LET l_str= "<tr><td><p class=MsoNormal style='line-height:9.0pt;mso-line-height-rule:exactly'> &nbsp; </P></td></tr>"
                             LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt,">&nbsp;</TD></TR>"   #No.FUN-A90047  #CHI-B30026 
                            CALL l_channel.write(l_str)
                        end for
                        #### 分頁格線 ####
                        LET l_str="</TABLE></div>",
                                   "<p class=MsoNormal align=center style='text-align:center;line-height:9.0pt;",
                                   "mso-line-height-rule:exactly'><span lang=EN-US style='font-size:8.0pt;",
                                   "mso-bidi-font-size:12.0pt;display:none;mso-hide:all'><![if !supportEmptyParas]>&nbsp;<![endif]><o:p></o:p></span></p>",
                                   "<span lang=EN-US style='font-size:8.0pt;mso-bidi-font-size:12.0pt;font-family:新細明體;mso-bidi-font-family:",
                                   g_quote,"Times New Roman",g_quote,";mso-ansi-language:EN-US;mso-fareast-language:ZH-TW;",
                                   "mso-bidi-language:AR-SA'><br clear=all style='mso-special-character:line-break;",
                                   "page-break-before:always'>",
                                   "</span>",
                                   "<p class=MsoNormal style='line-height:9.0pt;",
                                   "mso-line-height-rule:exactly'><![if !supportEmptyParas]>&nbsp;<![endif]><span ",
                                   "lang=EN-US style='font-size:8.0pt;mso-bidi-font-size:12.0pt'><o:p></o:p></span></p> "
                        LET l_str=l_str,"<div align=center>",
                                  #"<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 STYLE=",g_quote,"font-size: 8pt",g_quote," >"
                                  "<TABLE border=1 cellSpacing=0 cellPadding=1 STYLE=",g_quote,"font-size: 8pt",g_quote,"  BORDERCOLOR=\"#DFDFDF\">"        #FUN-580019
                        CALL l_channel.write(l_str)
             
                        LET cnt= 0
                        IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                           CALL cl_progressing("process: xml")            #FUN-570141
                        END IF                   ### FUN-570264 ###
                        LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                   END IF
                   LET l_str = ""
                   LET l_i = 0                                 #g_item2陣列數
                   LET column_cnt = 1
                   LET l_tr = "N"  
                   LET g_sort = "N"
                   CALL g_item.clear()
                   CALL g_item2.clear()
                   CALL g_item_sort_1.clear()
                   LET l_pageheader = "Y"
                 END IF  
 
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
 
          END CASE
 
      END CASE
      LET e= r.read()
   END WHILE
   #END FUN-570208
 
   CLOSE cl_trans3_curs                           #FUN-570141
   CALL l_channel.write("</TABLE></div></body></html>")    ##FUN-A90047
   CALL l_channel.close()
END FUNCTION
 
#FUN-660179
##################################################
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_callview()
DEFINE xml_name                           LIKE type_file.chr50,
       l_channel                          base.Channel,
       i,j,k,h,l_cnt,l_zero_cnt           LIKE type_file.num10,
       l_value,cnt_item,l_cnt_j           LIKE type_file.num10,
       l_str,l_line1,l_line2,value,l_j    string,
       l_cmd,n_name,col_w,col_i           string,
       output_name,item_name              string,
       field_cnt,l_cnt2,cnt_noskip        LIKE type_file.num10
DEFINE g_hd                               DYNAMIC ARRAY OF STRING
DEFINE l_pageheader,l_tr                  LIKE type_file.chr1,
       l_first_header,l_first_trailer     LIKE type_file.chr1,
       column_cnt,tag,tag2,l_p1           LIKE type_file.num10,
       cnt,str_cnt,cnt_column,l_i         LIKE type_file.num10,
       l_skip_tag                         string
DEFINE l_bufstr                           base.StringBuffer  #TQC-650109
DEFINE l_tag                              LIKE type_file.num5
DEFINE l_tag2                             LIKE type_file.num5
 
DEFINE l_pre_spaces LIKE type_file.num10 #No.FUN-6A0159
 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
 
   #計算g_dash個數
   LET g_dash_cnt = 0
  #LET l_cmd = "grep -c \"",g_dash CLIPPED,"*\" ",g_xml_name CLIPPED
   LET l_cmd = "grep -c \"",g_dash_out ,"*\" ",g_xml_name CLIPPED  #TQC-6A0113
 
   LET l_channel = base.Channel.create()
   CALL l_channel.openPipe(l_cmd, "r")
   WHILE l_channel.read(l_str)
       LET g_dash_cnt = l_str
   END WHILE
   CALL l_channel.close()
 
   IF g_zz05 = 'Y' THEN
      LET g_dash_cnt = g_dash_cnt - 1
   END IF
 
   LET l_str = g_xml_name CLIPPED
   LET output_name = l_str.substring(1,l_str.getlength()-8),l_str.substring(l_str.getlength()-6,l_str.getlength()-4),".txt"

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --

   LET l_str = ""
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(output_name,"a" )
   CALL l_channel.setDelimiter("")
   LET dom_doc = om.DomDocument.createFromXmlFile(g_xml_name_s)
   LET n = dom_doc.getDocumentElement()
 
   LET l_cnt_j = 0
   LET e = r.read()
 
   LET l_str = ""
   LET g_print_dash = 0
   LET l_i = 0                                 #g_item2陣列數
   LET column_cnt = 1
   LET l_tr = "N"  
   LET g_sort = "N"
   LET l_cnt2 = 0
   LET l_first_header = "N"
   LET l_first_trailer = ""
   LET n_id_name = "xml"
   LET l_tag  = 0
   LET l_tag2 = 0
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
          CASE
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "PageTrailer"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "PageHeader"
 
            WHEN r.getTagName() = "Print"
                LET i = 0
                LET cnt_noskip = 0
                LET n_name = r.getTagName()
                LET g_print_name = lsax_attrib.getValue("name")   #TQC-710026
                LET cnt_noskip = 0
                IF g_print_dash >= g_dash_cnt THEN
                   LET n_id_name = "PageTrailer"
                   LET l_first_trailer = "Y"
                END IF
                LET l_pageheader = "N"
                LET cnt_item = 0
 
            WHEN r.getTagName() = "Item"
                LET cnt_item = cnt_item + 1        #TQC-5B0055
                LET value = lsax_attrib.getValue("value")
                #TQC-650109
                CALL l_bufstr.clear()
                CALL l_bufstr.append(value)
                IF NOT cl_null(value) THEN
                   CALL l_bufstr.replace("<","&lt;",0)
                END IF
                LET value = l_bufstr.tostring()
                #END TQC-650109
 
                ### 公司名稱 合併
                IF value = g_company AND n_id_name == "PageHeader" THEN          #FUN-660179
                    LET l_tr = "Y"
                    LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                
                ### 虛線不列印
               #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED)) OR (value.equals(g_dash2 CLIPPED))THEN     
                IF (value = g_dash1) OR (value = g_dash_out) OR (value = g_dash2_out) THEN  #TQC-6A0113
                  #IF value.equals(g_dash CLIPPED) THEN
                   IF value = g_dash_out THEN    #TQC-6A0113
                       LET g_print_dash = g_print_dash + 1
                   END IF   
                   LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                   EXIT CASE
                END IF
            
                IF (g_body_title_pos - 1 = cnt) THEN
                   LET l_tr = "Y"
                   LET j = l_i + 1
                   LET g_xml_value = value
                   LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                   LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                   LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                   LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                   LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                   LET g_item[j].column = g_c[g_xml_value]
                   #No.FUN-6A0159 --start--
                   LET g_item[j].zaa14= g_zaa[g_xml_value].zaa14 CLIPPED
                   IF g_item[j].zaa14 MATCHES '[ABCDEFQ]' THEN
                      LET l_pre_spaces = (g_item[j].zaa05 - FGL_WIDTH(g_item[j].zaa08 CLIPPED)) / 2
                      IF l_pre_spaces > 0 then
                         LET g_item[j].zaa08 = l_pre_spaces SPACES || g_item[j].zaa08 CLIPPED
                      END IF
                   END IF
                   #No.FUN-6A0159 --end--
                
                   LET l_i = l_i + 1
                ELSE
                   IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                      IF (cnt_item = 1) AND (cnt < 3+g_top )THEN
                           IF l_str.trim() = " " THEN
                                LET l_str = value
                           ELSE
                                LET l_str = l_str,value
                           END IF
                       ELSE
                           IF value CLIPPED = g_x[6] CLIPPED OR value = g_x[7] CLIPPED OR 
                             (value CLIPPED = g_x[4] CLIPPED AND l_first_trailer = "Y" AND l_tag = 1)
                           THEN 
                               LET str_cnt = FGL_WIDTH(value)
                               #FUN-810047
                               #LET value = ""
                               #FOR j = 1 to str_cnt
                               #      LET value = value," "
                               #END FOR
                               LET value = str_cnt SPACES
                               #END FUN-810047
 
                           END IF
                           LET l_str = l_str,value
                           IF i = 1 AND (cnt_column != 0 )THEN
                              LET l_str = l_str," "
                           END IF
                      END IF
                      LET l_pageheader= "Y"     
                   ELSE
                        IF l_i = 0 THEN  
                          LET l_i = l_i + 1
                        ELSE
                          IF g_item2[l_i].zaa08 IS NOT NULL THEN
                               LET value = g_item2[l_i].zaa08 CLIPPED,value
                          END IF
                        END IF
                        LET g_item2[l_i].zaa08 = value CLIPPED               ### item value
                        LET g_item2[l_i].column = column_cnt         ### item value
                        LET l_pageheader= "N"
                   END IF
                END IF
 
            WHEN r.getTagName() = "Column"
                LET value = lsax_attrib.getValue("value")
                LET column_cnt = value
                IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                    LET str_cnt = FGL_WIDTH(l_str)
                    LET column_cnt = column_cnt - str_cnt - 1
                    #FUN-810047
                    #FOR j = 1 to column_cnt
                    #      LET l_str = l_str," "
                    #END FOR
                    LET l_str = l_str, column_cnt SPACES
                    #END FUN-810047
                ELSE
                    LET l_i = l_i + 1               #
                END IF
 
            WHEN r.getTagName() = "NoSkip"
                 LET cnt_noskip = 1
 
          END CASE
 
        WHEN "EndElement"
          CASE
            WHEN r.getTagName() = "Print"
              IF (cnt_noskip = 0) THEN
                 IF ((n_id_name == "PageHeader") AND (l_first_header="N") AND g_body_title_pos - 1 <> cnt)  
                  OR ((n_id_name == "PageTrailer") AND (l_first_trailer="Y" AND l_tag =1 )) 
                  OR (cnt_item = 0 )                             #FUN-570203
                 THEN
                    IF (cnt_item) = 1 AND (value.trim() != g_company) 
                    AND (value.trim() != g_dash_out)  AND(value.trim() != g_dash2_out)   ##TQC-6A0113
                    AND (value.trim() != g_dash1) #AND (value.trim() != " ") 
                    AND (cnt < 3+g_top OR g_print_name = "rep_name") #TQC-710026 
                    THEN
                        LET l_line1= "\"",g_company,"\",\"",value.trim(),"\"<<End>>"
                    ELSE
                       IF l_first_trailer = "Y" THEN
                          IF l_str.trim() <> "" OR NOT cl_null(l_str) THEN
                            IF ( g_memo_pagetrailer = 0 OR l_tag = 0 ) AND g_pageno > 1  THEN
                               LET value = l_str
                               LET l_str = ""
                               LET l_cnt2 = l_cnt2 + 1
                               LET l_j = l_cnt2  
                               LET l_zero_cnt = 8 - l_j.getLength()
                               FOR k=1 to l_zero_cnt
                                 LET l_str = l_str,"0"
                               END FOR
                               LET l_str="\"",l_str,l_j,"FT\","
                               FOR k=1 to field_cnt
                                  LET l_str=l_str,"\"\","
                               END FOR         
                               LET l_str= l_str,"\"1\",\"",value,"\",\"\"<<End>>"
                               CALL l_channel.write( l_str)
                            END IF
                          END IF
                       ELSE
                           IF value.trim() != g_company AND value.trim() != g_dash_out CLIPPED   ##TQC-6A0113
                           THEN
                              LET l_cnt_j = l_cnt_j + 1
                              IF n_id_name = "PageTrailer" AND (cnt_item = 0) THEN
                                 LET l_str = ""
                              ELSE
                                 LET l_p1 = l_str.getIndexOf(g_x[3],1)        
                                 IF l_p1 > 1 THEN
                                      LET l_str = l_str.subString(1,l_p1-1)
                                 END IF
                              END IF
                              LET g_hd[l_cnt_j] = l_str
                           END IF
                       END IF
                    END IF
                 ELSE
                    IF (g_body_title_pos - 1 = cnt) AND (l_first_header="N") THEN
                         LET l_first_header = "Y"
                         CALL l_channel.write( l_line1)
                         FOR k = 1 to g_item.getLength()
                           LET j = g_item[k].zaa07
                           LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                           LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                           LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                           LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                           LET g_item_sort_1[j].column=g_item[k].column
                           LET g_item_sort_1[j].sure=g_item[k].sure
                         END FOR
                         LET field_cnt = 0
                         #報表欄位大小 ##
                         FOR i= 1 to g_item_sort_1.getLength() 
                            IF g_item_sort_1[i].zaa06 = 'N' THEN 
                             LET col_i = i
                             LET col_w = g_item_sort_1[i].zaa05
                             LET l_line2 = l_line2 CLIPPED,"\"F",col_i.trimLeft() ,";C;",col_w.trimLeft(),"\","
                             LET field_cnt = field_cnt + 1
                            END IF
                         END FOR
                         
                         LET l_line1="\"FirstKey;C;20\",",l_line2 CLIPPED,"\"DrillNum;I\",\"DsRemark;C;255\",\"RemarKey;C;255\"<<End>>"
                         CALL l_channel.write( l_line1)
                         
                         FOR i = 1 to g_hd.getLength() 
                              LET l_j = i 
                              LET l_zero_cnt = 8 - l_j.getLength()
                              FOR k=1 to l_zero_cnt
                                LET l_str = l_str,"0"
                              END FOR
                              LET l_str="\"",l_str,l_j,"HD\","
                              FOR k=1 to field_cnt
                                 LET l_str=l_str,"\"\","
                              END FOR         
                              LET l_str= l_str,"\"1\",\"",g_hd[i],"\",\"\"<<End>>"
                              CALL l_channel.write( l_str)
                              LET l_str = ""
                         END FOR
                         #### 欄位名稱
                         FOR j= 1 to g_item_sort_1.getLength() 
                            IF g_item_sort_1[j].zaa06 = 'N' THEN 
                              LET l_j = j  
                              LET l_zero_cnt = 8 - l_j.getLength()
                              FOR k=1 to l_zero_cnt
                                LET l_str = l_str,"0"
                              END FOR
                              LET l_str="\"",l_str,l_j,"RH\","
                              FOR k=1 to field_cnt
                                 LET l_str=l_str,"\"\","
                              END FOR         
                              LET l_str= l_str,"\"",l_j,"\",\"",g_item_sort_1[j].zaa08 CLIPPED,"\",\"\"<<End>>"
                              CALL l_channel.write( l_str)
                              LET l_str=""
                            END IF
                         END FOR
                    END IF 
                    #FUN-5C0113
                    IF (cnt_item = 1) AND cl_null(value) THEN
                       LET l_cnt2 = l_cnt2 + 1
                       LET l_j = l_cnt2  
                       LET l_zero_cnt = 8 - l_j.getLength()
                       LET l_str = l_str.trim()
                       FOR k=1 to l_zero_cnt
                         LET l_str = l_str,"0"
                       END FOR
                       LET l_str="\"",l_str,l_j,"DT\","
                       FOR k=1 to field_cnt
                          LET l_str=l_str,"\"\","
                       END FOR         
                       LET l_str= l_str,"\"0\",\"\",\"\"<<End>>"
                       CALL l_channel.write( l_str)
                       LET l_str=""
                       LET l_tr = "Y"
                       LET l_pageheader= "Y"     
                    END IF
                    #END FUN-5C0113
                    #TQC-6A0113
                    #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR 
                    #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED))
                    #    OR (l_first_trailer='Y' AND l_tag=0)
                     IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                        (l_str = g_dash1) OR (l_str = g_dash2_out) OR
                        (l_first_trailer='Y' AND l_tag=0)
                    #END TQC-6A0113
                    THEN
                        IF n_id_name = "PageTrailer" AND (l_first_trailer = "" OR cl_null(l_first_trailer)) 
                        OR (l_first_trailer='Y' AND l_tag=0)
                        THEN
                            LET value = l_str
                            LET l_str = ""
                            LET l_cnt2 = l_cnt2 + 1
                            LET l_j = l_cnt2  
                            LET l_zero_cnt = 8 - l_j.getLength()
                            FOR k=1 to l_zero_cnt
                              LET l_str = l_str,"0"
                            END FOR
                            LET l_str="\"",l_str,l_j,"PF\","
                            FOR k=1 to field_cnt
                               LET l_str=l_str,"\"\","
                            END FOR         
                            LET l_str= l_str,"\"1\",\"",value,"\",\"\"<<End>>"
                            CALL l_channel.write( l_str)
                            LET l_tag2 = 1
                        END IF
                    ELSE
                       ###表頭、表尾資料合併，除了單身欄位內容
                       IF l_tr = "N" THEN
                          LET l_cnt2 = l_cnt2 + 1
                          LET l_j = l_cnt2  
                          LET l_zero_cnt = 8 - l_j.getLength()
                          LET l_str= l_str.trim()
                          FOR k=1 to l_zero_cnt
                                  LET l_str = l_str,"0"
                          END FOR
                          LET l_str="\"",l_str,l_j,"DT\""
                       END IF
		       IF (g_body_title_pos - 1 = cnt) THEN
                           LET l_pageheader = ""
                       ELSE 
                         IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                            FOR j = 1 to g_value.getLength()   
                              LET g_xml_value = g_value[j].zaa02    
                              LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                              LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                              LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                              LET g_item[j].zaa08 = ""
                              LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                              LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                              LET g_item[j].column = g_c[g_xml_value]
                            END FOR
                          
                            FOR k = 1 to g_item.getLength()
                                IF g_item[k].zaa05 IS NOT NULL THEN
                                   LET j = g_item[k].zaa07
                                   LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                                   LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                                   LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                                   LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                                   LET g_item_sort_1[j].column=g_item[k].column
                                   LET g_item_sort_1[j].sure=g_item[k].sure
                                END IF
                            END FOR
                    
                            FOR k = 1 to g_item_sort_1.getLength()
                                IF g_item_sort_1[k].zaa05 IS NULL THEN
                                      CALL g_item_sort_1.deleteElement(k)                   
                                      LET k = k - 1
                                END IF
                            END FOR
                            LET tag = 0
                            LEt tag2 = 0
                            FOR k = 1 TO g_item2.getLength()
                               #TQC-6B0006
                               IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                                 CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                                 LET INT_FLAG = 1
                                 RETURN
                               END IF
                               #END TQC-6B0006
                               LET g_cnt = g_item_sort_1.getLength() #TQC-950138                          
                               FOR j = 1 to g_cnt                    #TQC-950138
                                 IF (g_item_sort_1[j].zaa05 IS NOT NULL) OR (g_item_sort_1[j].zaa05 <> 0 ) THEN
                                    IF (j = g_item_sort_1.getLength()) AND (g_item2[k].column > g_item_sort_1[j].column-1) THEN
                                       LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                       EXIT FOR
                                    ELSE
                                       IF (g_item2[k].column > g_item_sort_1[j].column-1) AND 
                                          (g_item2[k].column < g_item_sort_1[j+1].column) THEN
                                          IF (g_item_sort_1[j].sure IS NULL) OR (g_item_sort_1[j].sure = "") THEN
                                              LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                              LET g_item_sort_1[j].sure="Y"
                                              LET tag = j
                                          ELSE
                                              LET tag = tag + 1
                                              LET g_item_sort_1[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                              LET g_item_sort_1[tag].sure="Y"
                                          END IF
                                 
                                          EXIT FOR
                                       END IF
                                    END IF
                                 END IF
                               END FOR
                            END FOR 
                            LET l_pageheader = "N"
                            LET g_sort="Y"
                         END IF
                       END IF
                      IF l_pageheader == "N" THEN
                         FOR k = 1 to g_item_sort_1.getLength()
                            IF g_item_sort_1[k].zaa06 = 'N' THEN
                              IF (g_zaa13_value = "N") OR
                                 (g_body_title_pos - 1 = cnt)           #TQC-5B0055
                              THEN
                                 LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                                 ## MOD-580150 ###
                                 LET column_cnt = g_item_sort_1[k].zaa05 - str_cnt 
                                 ## MOD-580150 ###
                                 #FUN-810047 
                                 #FOR j = 1 to column_cnt
                                 #   LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 CLIPPED, " "  #echo 
                                 #END FOR
                                 LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 CLIPPED, column_cnt SPACES 
                                 #END FUN-810047 
                              END IF
                              IF (g_item_sort_1[k].zaa08 IS NULL) OR (g_item_sort_1[k].zaa08 CLIPPED = " ") THEN
                                 LET g_item_sort_1[k].zaa08 = " "
                              END IF
                              LET l_str = l_str CLIPPED,",\"",  g_item_sort_1[k].zaa08 CLIPPED,"\""
                            END IF
                         END FOR
                         LET l_str = l_str CLIPPED,",\"0\",\"\",\"\"<<End>>"
                         IF NOT cl_null(l_str) THEN
                            CALL l_channel.write(l_str)
                         END IF
                      END IF
                    END IF
                  END IF
                  LET cnt=cnt+1
                  IF ( cnt > g_pagelen) THEN
                    LET cnt= 0
                    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                       CALL cl_progressing("process: xml")            #FUN-570141
                    END IF                   ### FUN-570264 ###
                    LET l_str = ""
                    LET l_cnt2 = l_cnt2 + 1
                    LET l_j = l_cnt2  
                    LET l_zero_cnt = 8 - l_j.getLength()
                    FOR k=1 to l_zero_cnt
                            LET l_str = l_str,"0"
                    END FOR
                    IF l_first_trailer ='N' OR l_first_trailer IS NULL THEN
                       LET l_str="\"",l_str,l_j,"JP\"<<End>>"
                       CALL l_channel.write(l_str)
                    END IF
                    LET g_page_cnt = g_page_cnt + 1    ##TQC-6B0006
                  END IF
                  LET l_str = ""
                  LET l_i = 0                                 #g_item2陣列數
                  LET column_cnt = 1
                  LET l_tr = "N"  
                  LET g_sort = "N"
                  CALL g_item.clear()
                  CALL g_item2.clear()
                  CALL g_item_sort_1.clear()
                  LET l_pageheader = "Y"
                END IF  
         
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
                IF l_first_trailer = "" OR cl_null(l_first_trailer) THEN
                     LET l_first_trailer = 'N'
                END IF
                LET l_tag = l_tag2
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
 
          END CASE
 
      END CASE
      LET e= r.read()
   END WHILE
   #END FUN-570208
     CALL l_channel.close()
END FUNCTION
 
##################################################
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_callview2()
DEFINE xml_name                           LIKE type_file.chr50,
       l_channel                          base.Channel,
       i,j,k,h,l_cnt,l_zero_cnt           LIKE type_file.num10,
       l_value,cnt_item,l_cnt_j           LIKE type_file.num10,
       l_str,l_line1,l_line2,value,l_j    string,
       l_cmd,n_name,col_w,col_i           string,
       output_name,item_name              string,
       field_cnt,l_cnt2                   LIKE type_file.num10
DEFINE g_hd                               DYNAMIC ARRAY OF STRING
DEFINE output_type,l_pageheader,l_tr      LIKE type_file.chr1,
       l_first_header,l_first_trailer     LIKE type_file.chr1,
       column_cnt,tag,tag2                LIKE type_file.num10,
       cnt,str_cnt,cnt_column,l_i         LIKE type_file.num10,
       l_skip_tag                         string
DEFINE l_bufstr                           base.StringBuffer  #TQC-650109
DEFINE a,b,noskip_old                     LIKE type_file.num10,
       l_print_cnt                        LIKE type_file.num5,   #FUN-570052
       page_cnt,l_p1                      LIKE type_file.num10,        
       page_end                           LIKE type_file.num5,
       l_str2                             STRING,
       l_start_i                          LIKE type_file.num10,
       l_detail,cnt_noskip                LIKE type_file.num10
DEFINE l_tag                              LIKE type_file.num5
DEFINE l_tag2                             LIKE type_file.num5
 
DEFINE l_pre_spaces LIKE type_file.num10 #No.FUN-6A0159
 
    #計算g_dash總數
    LET g_dash_cnt = 0
    #LET l_cmd = "grep -c \"",g_dash CLIPPED,"*\" ",g_xml_name CLIPPED
    LET l_cmd = "grep -c \"",g_dash_out,"*\" ",g_xml_name CLIPPED #TQC-6A0113
    LET l_channel = base.Channel.create()
    CALL l_channel.openPipe(l_cmd, "r")
    WHILE l_channel.read(l_str)
        LET g_dash_cnt = l_str
    END WHILE
    CALL l_channel.close()
    IF g_zz05 = 'Y' THEN
       LET g_dash_cnt = g_dash_cnt - 1 
    END IF
 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
 
   LET l_str = g_xml_name CLIPPED
   LET output_name = l_str.substring(1,l_str.getlength()-8),l_str.substring(l_str.getlength()-6,l_str.getlength()-4),".txt"

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --

   LET l_str = ""
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(output_name,"a" )
   CALL l_channel.setDelimiter("")
   LET dom_doc = om.DomDocument.createFromXmlFile(g_xml_name_s)
   LET n = dom_doc.getDocumentElement()
 
   LET l_cnt_j = 0
   LET e = r.read()
 
 
   LET page_cnt = 1
   LET page_end = FALSE
   LET l_str = ""
   LET g_print_dash = 0
   LET l_i = 0                                 #g_item2陣列數
   LET column_cnt = 1
   LET l_tr = "N"  
   LET g_sort = "N"
   LET l_cnt2 = 0
   LET l_first_header = "N"
   LET l_first_trailer = ""
   LET n_id_name = "xml"
   LET l_tag  = 0
   LET l_tag2 = 0
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
          CASE
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "PageTrailer"
                LET l_detail = 0
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "PageHeader"
 
            WHEN r.getTagName() = "Print"
                LET cnt_noskip = 0
                LET n_name = r.getTagName()
                LET g_print_name = lsax_attrib.getValue("name")
                IF g_print_dash >= g_dash_cnt THEN
                   LET n_id_name = "PageTrailer"
                   LET l_first_trailer = "Y"
                END IF
               #IF l_tag = 0 AND page_cnt = g_total_page AND g_print_name IS NULL AND n_id_name="xml" THEN 
               #   LET n_id_name = "PageHeader"
               #END IF
                IF (g_print_cnt = 0) AND (g_print_name IS NOT NULL)THEN
                   IF noskip_old = 0 THEN          
                       LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                       LET g_print_num = g_print_int
                       #MOD-580299
                       IF g_line_seq > 1 THEN
                          FOR k = 1 to g_print_num-1
                              LET l_i = l_i + g_report_cnt[k]
                          END FOR
                       END IF
                       #END MOD-580299
                       LET l_start_i = l_i + 1
                   END IF
                END IF
                LET cnt_item = 0
 
            WHEN r.getTagName() = "Item"
                LET cnt_item = cnt_item + 1        #TQC-5B0055
                LET value = lsax_attrib.getValue("value")
                #TQC-650109
                CALL l_bufstr.clear()
                CALL l_bufstr.append(value)
                IF NOT cl_null(value) THEN
                   CALL l_bufstr.replace("<","&lt;",0)
                END IF
                LET value = l_bufstr.tostring()
                #END TQC-650109
 
                ### 公司名稱 合併
                IF value = g_company AND n_id_name == "PageHeader" THEN          
                    LET l_tr = "Y"
                    LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                
                ### 虛線不列印
                #TQC-6A0113
                #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED))
                #OR (value.equals(g_dash2 CLIPPED))THEN
                #   IF value.equals(g_dash CLIPPED) THEN
                IF (value = g_dash1) OR (value = g_dash_out)
                OR (value = g_dash2_out)
                THEN
                   IF value = g_dash_out THEN
                #END TQC-6A0113
                       LET g_print_dash = g_print_dash + 1
                   END IF
                   LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                   EXIT CASE
                END IF
                IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱
                  LET j = l_i + 1
                  LET g_xml_value = value
                  #FUN-570052
                  LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                  LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                  LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                  #TQC-5B0170
                  IF g_zaa_dyn.getLength() > 0 THEN
                     LET g_item[j].zaa08= g_zaa_dyn[g_page_cnt,g_xml_value]
                  ELSE
                     LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                  END IF
                  #END TQC-5B0170
                  #No.FUN-6A0159 --start--
                  LET g_item[j].zaa14= g_zaa[value].zaa14 CLIPPED
                  IF g_item[j].zaa14 MATCHES '[ABCDEFQ]' THEN
                     LET l_pre_spaces = (g_item[j].zaa05 - FGL_WIDTH(g_item[j].zaa08 CLIPPED)) / 2
                     IF l_pre_spaces > 0 then
                        LET g_item[j].zaa08 = l_pre_spaces SPACES || g_item[j].zaa08 CLIPPED
                     END IF
                  END IF
                  #No.FUN-6A0159 --end--
                
                  LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                  LET g_item[j].column = g_c[g_xml_value]
                  #END FUN-570052
                  
                  LET l_i = l_i + 1
                  LET l_pageheader = "N"
               ELSE
                  IF (g_print_name IS NULL ) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                     IF (cnt < 3+g_top) THEN
                          IF l_str.trim() = " " THEN
                               LET l_str = value
                          ELSE
                               LET l_str = l_str,value
                          END IF
                     ELSE 
                          IF value CLIPPED = g_x[6] CLIPPED OR value CLIPPED = g_x[7] CLIPPED OR 
                            (value CLIPPED = g_x[4] CLIPPED AND l_first_trailer = "Y" AND l_tag=1)
                          THEN
                              LET str_cnt = FGL_WIDTH(value)
                              #FUN-810047
                              #LET value = ""
                              #FOR j = 1 to str_cnt
                              #      LET value = value," "
                              #END FOR
                              LET value = str_cnt SPACES
                              #END FUN-810047
                          END IF
                          LET l_str = l_str,value
                     END IF
                     LET l_pageheader= "Y"     
                    #IF page_cnt = g_total_page AND n_id_name = "xml" THEN 
                    #        LET l_first_trailer="Y"
                    #        LET n_id_name = "PageTrailer"
                    #END IF
                  ELSE
                      IF l_i = 0 THEN  
                        LET l_i = l_i + 1
                      ELSE
                        IF g_item2[l_i].zaa08 IS NULL THEN
                             LET value = g_item2[l_i].zaa08 CLIPPED,value
                        END IF
                      END IF
                      LET g_item2[l_i].zaa08 = value CLIPPED              ### item value
                      LET g_item2[l_i].column = column_cnt
                      LET l_pageheader= "N"
                  END IF
               END IF
 
            WHEN r.getTagName() = "Column"
                LET value = lsax_attrib.getValue("value")
                LET column_cnt = value
                IF (g_print_name IS NULL) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                    LET str_cnt = FGL_WIDTH(l_str)
                    LET column_cnt = column_cnt - str_cnt - 1
                    #FUN-810047
                    #FOR j = 1 to column_cnt
                    #      LET l_str = l_str," "
                    #END FOR
                    LET l_str = l_str, column_cnt SPACES
                    #END FUN-810047
                ELSE
                    LET l_i = l_i + 1               #
                END IF
 
            WHEN r.getTagName() = "NoSkip"
                 LET cnt_noskip = 1
 
          END CASE
 
        WHEN "EndElement"
          CASE
            WHEN r.getTagName() = "Print"
              IF ( cnt_noskip = 0 ) THEN
                 IF (g_print_name IS NOT NULL) THEN
                    LET lsax_attrib = r.getAttributes()
                    LET e = r.read()
                    LET g_print_end = "Y"
                    LET g_next_name = lsax_attrib.getValue("name")
                    LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                    LET g_print_num = g_print_int
                    LET g_print_cnt = g_print_cnt + 1 
                    IF (g_print_name.subString(1,1)=g_next_name.subString(1,1)) THEN
                          LET g_next_int = g_next_name.subString(2,g_next_name.getLength())
                          LET g_next_num = g_next_int
                          IF g_next_num = g_print_num + 1 THEN
                             IF g_print_cnt = 1 THEN
                                 #MOD-580299
                                 IF g_line_seq = 1 AND g_print_num > 1 THEN
                                     LET g_print_start = 1
                                     LET g_print_int = 1
                                 ELSE
                                     LET g_print_start = g_print_num
                                 END IF
                                 #END MOD-580299
                             END IF
                             LET g_print_end = "N"
                          ELSE
                              IF g_print_cnt = 1 THEN
                                 #MOD-580299
                                 IF g_line_seq = 1 AND g_print_num > 1 THEN
                                     LET g_print_start = 1
                                     LET g_print_int = 1
                                 ELSE
                                     LET g_print_start = g_print_num
                                 END IF
                                 #END MOD-580299
                              END IF
                          END IF
                    ELSE
                          IF g_print_cnt = 1 THEN
                              #MOD-580299
                              IF g_line_seq = 1 AND g_print_num > 1 THEN
                                  LET g_print_start = 1
                                  LET g_print_int = 1
                              ELSE
                                  LET g_print_start = g_print_num
                              END IF
                              #END MOD-580299
                          END IF
                    END IF
                END IF
                IF ( g_print_end ="Y" ) OR g_print_name IS NULL THEN
                   IF ((n_id_name == "PageHeader") AND (l_first_header="N") AND (g_print_name IS NULL OR g_print_name="rep_name")) 
                    OR ((n_id_name == "PageTrailer") AND (l_first_trailer="Y" AND l_tag =1 )) 
                   #OR ((n_id_name = "xml") AND (g_body_title_pos > cnt) AND g_print_name IS NULL)
                    OR (cnt_item = 0 )                             #FUN-570203
                   THEN
                      LET cnt=cnt+1
                      IF (cnt_item) < 2 AND (value.trim() != g_company) 
                      AND (value.trim() != g_dash_out)  AND(value.trim() != g_dash2_out) #TQC-6A0113
                      AND (value.trim() != g_dash1) #AND (value.trim() != " ") 
                      AND (cnt < 3+g_top OR g_print_name='rep_name')  #TQC-710026
                      AND ( l_first_trailer="N" OR l_first_trailer IS NULL )
                      THEN
                          LET l_line1= "\"",g_company,"\",\"",value.trim(),"\"<<End>>"
                      ELSE
                         IF l_first_trailer = "Y" THEN
                            IF l_str.trim() <> "" OR NOT cl_null(l_str) THEN
                              IF ( g_memo_pagetrailer = 0 OR l_tag = 0 ) AND g_pageno > 1  THEN
                                 LET value = l_str
                                 LET l_str = ""
                                 LET l_cnt2 = l_cnt2 + 1
                                 LET l_j = l_cnt2  
                                 LET l_zero_cnt = 8 - l_j.getLength()
                                 FOR k=1 to l_zero_cnt
                                   LET l_str = l_str,"0"
                                 END FOR
                                 LET l_str="\"",l_str,l_j,"FT\","
                                 FOR k=1 to field_cnt
                                    LET l_str=l_str,"\"\","
                                 END FOR         
                                 LET l_str= l_str,"\"1\",\"",value,"\",\"\"<<End>>"
                                 CALL l_channel.write( l_str)
                              END IF
                            END IF
                         ELSE
                             IF value.trim() != g_company AND value.trim() != g_dash_out CLIPPED  ##TQC-6A0113
                             THEN
                                LET l_cnt_j = l_cnt_j + 1
                                IF n_id_name = "PageTrailer" AND (cnt_item = 0) THEN
                                   LET l_str = ""
                                ELSE
                                   LET l_p1 = l_str.getIndexOf(g_x[3],1)        
                                   IF l_p1 > 1 THEN
                                        LET l_str = l_str.subString(1,l_p1-1)
                                   END IF
                                END IF
                                LET g_hd[l_cnt_j] = l_str
                             END IF
                         END IF
                      END IF
                   ELSE
                      IF (l_first_header="N") AND (g_print_name IS NOT NULL) THEN   
                           LET l_first_header = "Y"
                           CALL l_channel.write( l_line1)
                           LET field_cnt = 0
                           FOR k = 1 to g_item.getLength()
                             IF g_item[k].zaa05 IS NOT NULL THEN
                               LET a = g_item[k].zaa15
                               LET b = g_item[k].zaa07
                               LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                               LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                               LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort[a,b].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item_sort[a,b].column=g_item[k].column-g_item_sort[k,1].column
                               LET g_item_sort[a,b].sure=g_item[k].sure
                             END IF
                           END FOR
                           FOR a = 1 to g_line_seq
                              FOR b = 1 to g_item_sort[a].getLength()
                                IF g_item_sort[a,b].zaa05 IS NULL THEN
                                     CALL g_item_sort[a].deleteElement(b)
                                END IF
                              END FOR
                           END FOR
                           ## 判斷一行小計，不能上下移動，只能左右 
                           IF (g_print_name.subString(1,1)="s") AND (g_print_start=g_print_int) THEN
                              FOR a = 1 to g_line_seq
                                 IF g_print_start <> a THEN
                                    FOR b = 1 to g_item_sort[a].getLength()
                                        IF g_item_sort[a,b].zaa08 IS NOT NULL THEN
                                           LET g_item_sort[g_print_start,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED
                                           LET g_item_sort[g_print_start,b].zaa05 = g_item_sort[a,b].zaa05
                                        END IF
                                    END FOR
                                 END IF
                              END FOR
                           END IF
                           ## 組l_str 
                           FOR a = g_print_start to g_print_int
                             #FUN-580019
                             LET l_print_cnt = 0                         #FUN-570052
                             FOR b = 1 to g_item_sort[a].getLength()
                                IF g_item_sort[a,b].zaa06 = 'N' THEN
                                   LET field_cnt = field_cnt + 1
                                   LET col_i = field_cnt
                                   LET col_w = g_item_sort[a,b].zaa05
                                   LET l_line2 = l_line2 CLIPPED,"\"F",col_i.trimLeft() ,";C;",col_w.trimLeft(),"\","
                                END IF
                             END FOR
                           END FOR
                           
                           LET l_line1="\"FirstKey;C;20\",",l_line2 CLIPPED,"\"DrillNum;I\",\"DsRemark;C;255\",\"RemarKey;C;255\"<<End>>"
                           CALL l_channel.write( l_line1)
                           
                           FOR i = 1 to g_hd.getLength() 
                                LET l_j = i 
                                LET l_zero_cnt = 8 - l_j.getLength()
                                FOR k=1 to l_zero_cnt
                                  LET l_str = l_str,"0"
                                END FOR
                                LET l_str="\"",l_str,l_j,"HD\","
                                FOR k=1 to field_cnt
                                   LET l_str=l_str,"\"\","
                                END FOR         
                                LET l_str= l_str,"\"1\",\"",g_hd[i],"\",\"\"<<End>>"
                                CALL l_channel.write( l_str)
                                LET l_str = ""
                           END FOR
                           LET j = 0 
                           FOR a = g_print_start to g_print_int
                             #FUN-580019
                             LET l_print_cnt = 0                         #FUN-570052
                             FOR b = 1 to g_item_sort[a].getLength()
                                IF g_item_sort[a,b].zaa06 = 'N' THEN
                                     LET j = j + 1
                                     LET l_j = j  
                                     LET l_zero_cnt = 8 - l_j.getLength()
                                     FOR k=1 to l_zero_cnt
                                       LET l_str = l_str,"0"
                                     END FOR
                                     LET l_str="\"",l_str,l_j,"RH\","
                                     FOR k=1 to field_cnt
                                        LET l_str=l_str,"\"\","
                                     END FOR         
                                     LET l_str= l_str,"\"",l_j,"\",\"",g_item_sort[a,b].zaa08 CLIPPED,"\",\"\"<<End>>"
                                     CALL l_channel.write( l_str)
                                     LET l_str=""
                                END IF
                             END FOR
                             LET l_detail = 1                          #FUN-580019
                           END FOR
                      END IF 
                      IF ( g_print_end ="Y" ) OR g_print_name IS NULL THEN
                        IF ((n_id_name = "PageHeader") AND (l_first_header="Y"))
                         OR (n_id_name = "PageTrailer" AND (l_first_trailer = "" OR cl_null(l_first_trailer)))
                         OR (cnt_item = 0 ) 
                         #TQC-6A0113                           
                         #OR (value.equals(g_dash CLIPPED))  
                         #OR (value.equals(g_dash1)) 
                         #OR (value.equals(g_dash2 CLIPPED))
                         OR (value = g_dash_out)  
                         OR (value = g_dash1) 
                         OR (value = g_dash2_out)
                         #END TQC-6A0113                           
                         OR (l_first_trailer='Y' AND l_tag=0)
                        THEN
                           LET cnt = cnt + 1
                           IF l_pageheader = 'N' AND (g_print_start < g_print_int) THEN
                                FOR a = g_print_start to g_print_int
                                          LET cnt=cnt+1
                                END FOR
                           END IF
                           IF n_id_name = "PageTrailer" AND (l_first_trailer = "" OR cl_null(l_first_trailer))
                           OR (l_first_trailer='Y' AND l_tag=0)
                           THEN
                               LET value = l_str
                               LET l_str = ""
                               LET l_cnt2 = l_cnt2 + 1
                               LET l_j = l_cnt2  
                               LET l_zero_cnt = 8 - l_j.getLength()
                               FOR k=1 to l_zero_cnt
                                 LET l_str = l_str,"0"
                               END FOR
                               LET l_str="\"",l_str,l_j,"PF\","
                               FOR k=1 to field_cnt
                                  LET l_str=l_str,"\"\","
                               END FOR         
                               LET l_str= l_str,"\"1\",\"",value,"\",\"\"<<End>>"
                               CALL l_channel.write( l_str)
                               LET l_tag2 = 1
                           END IF
                        ELSE
                         #TQC-6A0113
                         #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR
                         #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED))
                          IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                              (l_str = g_dash1) OR (l_str = g_dash2_out) THEN
                         #END TQC-6A0113
                              LET cnt = cnt + 1
                              IF l_detail = 1     #FUN-580019
                              THEN
                                   CALL cl_err_msg("","lib-286",g_page_cnt || "|" || cnt,10)
                                   CALL cl_close_progress_bar()  
                                   LET INT_FLAG = 1
                                   RETURN   
                              END IF
                          ELSE
                             IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱   #CHI-760015
                                 LET l_pageheader = ""
                                 LET l_first_header = "Y"
                                 LET l_detail = 1                          #FUN-580019
                                 LET l_str2 = ""
                                 LET cnt = cnt + 1
                             ELSE 
                               IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                                  FOR j = 1 to g_value.getLength()   
                                    LET g_xml_value = g_value[j].zaa02    
                                 #FUN-570052
                                    LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                                    LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                                    LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                                    LET g_item[j].zaa08 = ""
                                    LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                                    LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                                    LET g_item[j].column = g_c[g_xml_value]
                      
                                  END FOR
                                 #END FUN-570052
                      
                                  CALL g_item_sort.clear()
                                  FOR k = 1 to g_item.getLength()#資料排序
                                    IF g_item[k].zaa05 IS NOT NULL THEN
                                      LET a = g_item[k].zaa15
                                      LET b = g_item[k].zaa07
                                      LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                                      LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                                      LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                                      LET g_item_sort[a,b].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                                      LET g_item_sort[a,b].column=g_item[k].column
                                      LET g_item_sort[a,b].sure=g_item[k].sure
                                    END IF
                                  END FOR
                                  CALL g_item.clear()
                                  LET k = 0
                                  FOR a = 1 to g_line_seq
                                    FOR b = 1 to g_item_sort[a].getLength()
                                     IF g_item_sort[a,b].zaa05 IS NOT NULL THEN
                                       LET k = k + 1
                                       LET g_item[k].zaa05 =g_item_sort[a,b].zaa05
                                       LET g_item[k].zaa06 =g_item_sort[a,b].zaa06
                                       LET g_item[k].zaa08 =g_item_sort[a,b].zaa08 CLIPPED
                                       LET g_item[k].zaa14 =g_item_sort[a,b].zaa14 CLIPPED #No.FUN-6A0159
                                       LET g_item[k].zaa07 = b
                                       LET g_item[k].zaa15 = a
                                       LET g_item[k].column=g_item_sort[a,b].column
                                       LET g_item[k].sure  =g_item_sort[a,b].sure
                                     END IF
                                    END FOR
                                  END FOR
                                  LET tag = 0
                                  LEt tag2 = 0
                                  FOR k = l_start_i TO g_item2.getLength()
                                     #TQC-6B0006
                                     IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                                       CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                                       LET INT_FLAG = 1
                                       RETURN
                                     END IF
                                     #END TQC-6B0006
                                     LET g_cnt = g_item.getLength() #TQC-950138
                                     FOR j = 1 to g_cnt             #TQC-950138
                                       IF (j = g_item.getLength()) AND (g_item2[k].column > g_item[j].column-1) THEN
                                          LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                          EXIT FOR
                                
                                       ELSE
                                          IF (g_item2[k].column > g_item[j].column-1) AND 
                                             (g_item2[k].column < g_item[j+1].column) THEN
                                             IF (g_item[j].sure IS NULL) OR (g_item[j].sure = "") THEN
                                                 LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                                 LET g_item[j].sure="Y"
                                                 LET tag = j
                                             ELSE
                                                 LET tag = tag + 1
                                                 LET g_item[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                                 LET g_item[tag].sure="Y"
                                              END IF
                                
                                            EXIT FOR
                                          END IF
                                       END IF
                                     END FOR
                                  END FOR 
                                  LET l_pageheader = "N"
                                END IF
                              END IF
                            END IF
                            IF l_pageheader == "N" THEN
                               FOR k = 1 to g_item.getLength()
                                 IF g_item[k].zaa05 IS NOT NULL THEN
                                   LET a = g_item[k].zaa15
                                   LET b = g_item[k].zaa07
                                   LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                                   LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                                   LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                                   LET g_item_sort[a,b].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                                   LET g_item_sort[a,b].column=g_item[k].column-g_item_sort[k,1].column
                                   LET g_item_sort[a,b].sure=g_item[k].sure
                                 END IF
                               END FOR
                               FOR a = 1 to g_line_seq
                                  FOR b = 1 to g_item_sort[a].getLength()
                                    IF g_item_sort[a,b].zaa05 IS NULL THEN
                                         CALL g_item_sort[a].deleteElement(b)
                                    END IF
                                  END FOR
                               END FOR
                               ## 判斷一行小計，不能上下移動，只能左右 
                               IF (g_print_name.subString(1,1)="s") AND (g_print_start=g_print_int) THEN
                                  FOR a = 1 to g_line_seq
                                     IF g_print_start <> a THEN
                                        FOR b = 1 to g_item_sort[a].getLength()
                                            IF g_item_sort[a,b].zaa08 IS NOT NULL THEN
                                               LET g_item_sort[g_print_start,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED
                                               LET g_item_sort[g_print_start,b].zaa05 = g_item_sort[a,b].zaa05
                                            END IF
                                        END FOR
                                     END IF
                                  END FOR
                               END IF
                               ## 組l_str 
                               FOR a = g_print_start to g_print_int
                                 LET l_cnt2 = l_cnt2 + 1
                                 LET l_j = l_cnt2
                                 LET l_zero_cnt = 8 - l_j.getLength()
                                 LET l_str = l_str.trim()
                                 FOR k=1 to l_zero_cnt
                                         LET l_str = l_str,"0"
                                 END FOR
                                 LET l_str="\"",l_str,l_j,"DT\""
                                 #FUN-580019
                                 LET l_print_cnt = 0                         #FUN-570052
                                 FOR b = 1 to g_item_sort[a].getLength()
                                    IF g_item_sort[a,b].zaa06 = 'N' THEN
                                       IF (g_zaa13_value = "N" ) OR
                                          (g_print_name.subString(1,1)="h")  #TQC-5B0055
                                       THEN
                                          LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08)
                                          ### MOD-580150 ###
                                          LET column_cnt = g_item_sort[a,b].zaa05 - str_cnt 
                                          ### MOD-580150 ###
                                          #FUN-810047
                                          #FOR j = 1 to column_cnt
                                          #   LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED, " "  #echo 
                                          #END FOR
                                          LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED, column_cnt SPACES  #echo 
                                          #END FUN-810047
                                       END IF
                                       IF (g_item_sort[a,b].zaa08 IS NULL) OR (g_item_sort[a,b].zaa08 = " ") THEN
                                         LET g_item_sort[a,b].zaa08 = " "
                                       END IF
                                       LET l_str = l_str CLIPPED,",\"", g_item_sort[a,b].zaa08 CLIPPED,"\"" #FUN-580019
                                       LET l_print_cnt = l_print_cnt + 1             #FUN-570052
                                    END IF
                                 END FOR
                                 FOR k = 1 to g_view_cnt-l_print_cnt              #FUN-570052
                                         LET l_str = l_str CLIPPED,",\"\""   #FUN-580019
                                 END FOR
                                 LET l_str = l_str CLIPPED,",\"0\",\"\",\"\"<<End>>"
                                 CALL l_channel.write(l_str)
                                 LET cnt=cnt+1
                                 LET l_str = ""
                               END FOR
                        
                            END IF
                        END IF
                        IF (l_str = "") THEN
                           IF l_detail = 1 
                           THEN
                                CALL cl_err_msg("","lib-286",g_page_cnt || "|" || cnt,10)
                                CALL cl_close_progress_bar()  
                                LET INT_FLAG = 1
                                RETURN   
                           END IF
                        END IF
                      END IF
                    END IF
                    IF ( cnt > g_pagelen) THEN
                       LET page_cnt = page_cnt + 1
                       IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                          CALL cl_progressing("process: xml")            #FUN-570141
                       END IF                   ### FUN-570264 ###
                       LET cnt= 0
                       LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                   
                       LET l_str = ""
                       LET l_cnt2 = l_cnt2 + 1
                       LET l_j = l_cnt2  
                       LET l_zero_cnt = 8 - l_j.getLength()
                       FOR k=1 to l_zero_cnt
                               LET l_str = l_str,"0"
                       END FOR
                       IF l_first_trailer ='N' OR l_first_trailer IS NULL THEN
                          LET l_str="\"",l_str,l_j,"JP\"<<End>>"
                          CALL l_channel.write(l_str)
                       END IF
                       LET l_detail = 0                        #FUN-580019
                    END IF
                    LET l_str = ""
                    LET l_i = 0 
                    LET column_cnt = 1
                    LET cnt_item = 0
                    LET l_tr = "N"  
                    LET value = " "
                    CALL g_item.clear()
                    CALL g_item2.clear()
                    CALl g_item_sort.clear()
                    LET l_pageheader = "Y"
                    LET g_print_cnt = 0
                 END IF
              END IF      
              LET noskip_old = cnt_noskip
           
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
                IF l_first_trailer = "" OR cl_null(l_first_trailer) THEN
                     LET l_first_trailer = 'N'
                END IF
                LET l_tag = l_tag2
        
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
        
          END CASE
      END CASE
      IF g_print_end IS NULL  THEN
         LET e= r.read()
      END IF
      LET g_print_end = NULL
   END WHILE
   #END FUN-570208
     CALL l_channel.close()
END FUNCTION
#END FUN-660179
 
 
##################################################
# Descriptions...: xml轉成 txt 
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_txt()
DEFINE l_channel                             base.Channel,
       l_str,output_name,l_cmd,n_name        STRING,
       cnt_print,value,l_dash,l_dash2        STRING,
       i,j,k,column_cnt                      LIKE type_file.num10,       #No.FUN-690005 INTEGER,
       tag,tag2,cnt_noskip                   LIKE type_file.num10,       #No.FUN-690005 INTEGER,
       cnt,str_cnt,cnt_column,l_i            LIKE type_file.num10,       #No.FUN-690005 INTEGER,
       l_pageheader                          LIKE type_file.chr1         #No.FUN-690005 VARCHAR(1)
 
DEFINE l_pre_spaces LIKE type_file.num10 #No.FUN-6A0159
 
   #FUN-570052
   #計算g_dash總數
   LET g_dash_cnt = 0
  #LET l_cmd = "grep -c \"",g_dash CLIPPED,"*\" ",g_xml_name CLIPPED
   LET l_cmd = "grep -c \"",g_dash_out ,"*\" ",g_xml_name CLIPPED  #TQC-6A0113
 
   LET l_channel = base.Channel.create()
   CALL l_channel.openPipe(l_cmd, "r")
   WHILE l_channel.read(l_str)
       LET g_dash_cnt = l_str
   END WHILE
   CALL l_channel.close()
   #END FUN-570052
   #FUN-6B0006---start---
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' AND g_aza.aza66 = 2 THEN
      LET g_dash_cnt = g_dash_cnt - 1
   END IF
   #FUN-6B0006---end---
   LET cnt = 0
   LET l_str = g_xml_name CLIPPED
   LET output_name = l_str.substring(1,l_str.getlength()-4)

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --

   LET l_str = ""
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(output_name,"a" )
   CALL l_channel.setDelimiter("")
 
 
## 讀取報表資料
#FUN-570208
   #LET nl_print = n.selectByTagName("Print")
   #LET cnt_print = nl_print.getLength()
   LET l_i = 0                                 #g_item2陣列數
   LET column_cnt = 1
   LET l_pageheader = "Y"                      #pageheader的tag #FUN-5A0135
   LET g_print_dash = 0
   LET g_sort = "N"
 
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
    CASE e
      WHEN "StartElement"
       CASE
         WHEN r.getTagName() = "PageTrailer"
             LET n_id_name = "PageTrailer"
 
         WHEN r.getTagName() = "PageHeader"
             LET n_id_name = "PageHeader"
 
         WHEN r.getTagName() = "Print"
             LET n_name = r.getTagName()
             LET cnt_noskip = 0
             IF g_print_dash >= g_dash_cnt THEN
                LET n_id_name = "PageTrailer"
             END IF
 
         WHEN r.getTagName() = "Item"
             LET value = lsax_attrib.getValue("value")
             IF (g_body_title_pos - 1 = cnt) THEN
                LET j = l_i + 1
                #FUN-570052
                LET g_item[j].zaa05= g_zaa[value].zaa05 CLIPPED 
                LET g_item[j].zaa06= g_zaa[value].zaa06 CLIPPED 
                LET g_item[j].zaa07= g_zaa[value].zaa07 CLIPPED 
                #TQC-5B0170
                IF g_zaa_dyn.getLength() > 0 THEN
                   LET g_item[j].zaa08= g_zaa_dyn[g_page_cnt,value]
                ELSE
                   LET g_item[j].zaa08= g_zaa[value].zaa08 CLIPPED
                END IF
                #END TQC-5B0170
                #No.FUN-6A0159 --start--
                LET g_item[j].zaa14= g_zaa[value].zaa14 CLIPPED
                IF g_item[j].zaa14 MATCHES '[ABCDEFQ]' THEN
                   LET l_pre_spaces = (g_item[j].zaa05 - FGL_WIDTH(g_item[j].zaa08 CLIPPED)) / 2
                   IF l_pre_spaces > 0 then
                      LET g_item[j].zaa08 = l_pre_spaces SPACES || g_item[j].zaa08 CLIPPED
                   END IF
                END IF
                #No.FUN-6A0159 --end--
                LET g_item[j].zaa15= g_zaa[value].zaa15 CLIPPED 
                LET g_item[j].column = g_c[value]
                #END FUN-570052
                LET l_i = l_i + 1
             ELSE
                IF value.equals(g_dash1) THEN       #重新計算g_dash1
 
                   #FUN-570052
                    #MOD-570371
                   FOR j = 1 TO g_value.getLength()
                       LET g_xml_value = g_value[j].zaa02
                       LET g_item[j].zaa05= g_zaa[g_xml_value].zaa05 CLIPPED
                       LET g_item[j].zaa06= g_zaa[g_xml_value].zaa06 CLIPPED
                       LET g_item[j].zaa07= g_zaa[g_xml_value].zaa07 CLIPPED
                       LET g_item[j].zaa08= g_dash2[1,g_item[j].zaa05] CLIPPED
                       LET g_item[j].zaa15= g_zaa[g_xml_value].zaa15 CLIPPED
                       LET g_item[j].zaa14= g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                   END FOR
                   #LET n_id_name = "PageHeader"   
                   LET n_id_dash1 = TRUE       #TQC-5B0066
                   LET l_pageheader= "N"
                    #END MOD-570371
                   #END FUN-570052
 
                ELSE
                  IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                        LET l_str = l_str,value
                        IF i = 1 AND (cnt_column != 0 )THEN
                           LET l_str = l_str," "
                        END IF
                        LET l_pageheader= "Y"     
                        #IF value.equals(g_dash CLIPPED) THEN
                        IF value = g_dash_out THEN   #TQC-6A0113
                            LET g_print_dash = g_print_dash + 1
                        END IF
                       
                  ELSE
                    #TQC-6A0113
                    #IF value.equals(g_dash CLIPPED) OR value.equals(g_dash2 CLIPPED) THEN
                    #   IF value.equals(g_dash CLIPPED) THEN
                     IF (value = g_dash_out)  OR (value = g_dash2_out) THEN
                        IF value = g_dash_out THEN
                    #END TQC-6A0113
 
                            LET g_print_dash = g_print_dash + 1
                        END IF
                        LET l_str = l_str,value
                        EXIT CASE
                     ELSE
                        IF l_i = 0 THEN  
                          LET l_i = l_i + 1
                        ELSE
                          IF g_item2[l_i].zaa08 IS NOT NULL THEN
                               LET value = g_item2[l_i].zaa08 CLIPPED,value
                          END IF
                        END IF
                        LET g_item2[l_i].zaa08 = value CLIPPED       ### item value
                        LET g_item2[l_i].column = column_cnt         ### item value
                        LET l_pageheader= "N"
                    END IF
                  END IF
                END IF
             END IF
 
         WHEN r.getTagName() = "Column"
             LET value = lsax_attrib.getValue("value")
             LET column_cnt = value
             IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                 LET str_cnt = FGL_WIDTH(l_str)
                 LET column_cnt = column_cnt - str_cnt - 1
                 #FUN-810047
                 #FOR j = 1 to column_cnt
                 #      LET l_str = l_str," "
                 #END FOR
                 LET l_str = l_str, column_cnt SPACES
                 #END FUN-810047
 
             ELSE
                 LET l_i = l_i + 1               #
             END IF
 
            WHEN r.getTagName() = "NoSkip"
                LET cnt_noskip = 1
 
          END CASE
 
        WHEN "EndElement"
          CASE
            WHEN r.getTagName() = "Print"
                IF (cnt_noskip = 0) THEN
                   #TQC-6A0113
                   IF (l_str = g_dash_out) OR (l_str = g_dash2_out) THEN
                      IF (l_str = g_dash_out) THEN
                         LET l_str = g_dash_out
                      ELSE
                         LET l_str = g_dash2_out
                      END IF
                   #END TQC-6A0113
                   ELSE
                      IF (g_body_title_pos - 1 = cnt) THEN
                          LET l_pageheader = "N"
                      ELSE 
                        IF ((n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer"))  
                           AND (n_id_dash1 <> TRUE )       #TQC-5B0066
                        THEN  
                           FOR j = 1 to g_value.getLength()   
                             LET g_xml_value = g_value[j].zaa02    
                        #FUN-570052     
                             LET g_item[j].zaa05= g_zaa[g_xml_value].zaa05 CLIPPED 
                             LET g_item[j].zaa06= g_zaa[g_xml_value].zaa06 CLIPPED 
                             LET g_item[j].zaa07= g_zaa[g_xml_value].zaa07 CLIPPED 
                             LET g_item[j].zaa08 = ""
                             LET g_item[j].zaa15= g_zaa[g_xml_value].zaa15 CLIPPED
                             LET g_item[j].zaa14= g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159 
                             LET g_item[j].column = g_c[g_xml_value]
                           END FOR
                        #END FUN-570052
             
                           FOR k = 1 to g_item.getLength()
                             IF g_item[k].zaa05 IS NOT NULL THEN
                               LET j = g_item[k].zaa07
                               LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                               LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                               LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item_sort_1[j].column=g_item[k].column
                               LET g_item_sort_1[j].sure=g_item[k].sure
                             END IF
                           END FOR
                           FOR k = 1 to g_item_sort_1.getLength()
                               IF g_item_sort_1[k].zaa05 IS NULL THEN
                                     CALL g_item_sort_1.deleteElement(k)     
                                     LET k = k - 1              
                               END IF
                           END FOR
                           LET tag = 0
                           LET tag2 = 0
                           FOR k = 1 TO g_item2.getLength()
                              #TQC-6B0006
                              IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                                CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                                LET INT_FLAG = 1
                                RETURN
                              END IF
                              #END TQC-6B0006
                              LET g_cnt = g_item_sort_1.getLength() #TQC-950138                          
                              FOR j = 1 to g_cnt                    #TQC-950138
                                IF (g_item_sort_1[j].zaa05 IS NOT NULL) OR (g_item_sort_1[j].zaa05 <> 0 ) THEN
                                    
                                 IF (j = g_item_sort_1.getLength()) AND (g_item2[k].column > g_item_sort_1[j].column-1) THEN
                                   LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                   EXIT FOR
                                 ELSE
                                   IF (g_item2[k].column > g_item_sort_1[j].column-1) AND 
                                      (g_item2[k].column < g_item_sort_1[j+1].column) THEN
                                      IF (g_item_sort_1[j].sure IS NULL) OR (g_item_sort_1[j].sure = "") THEN
                                          LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item_sort_1[j].sure="Y"
                                          LET tag = j
                                      ELSE
                                          LET tag = tag + 1
                                          LET g_item_sort_1[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item_sort_1[tag].sure="Y"
                                       END IF
                         
                                     EXIT FOR
                                   END IF
                                 END IF
                                END IF
                              END FOR
                           END FOR 
                           LET l_pageheader = "N"
                           LET g_sort = "Y"
                         END IF
                      END IF
                     IF l_pageheader == "N" THEN
                        IF g_sort = "N" THEN
                             FOR k = 1 to g_item.getLength()
                                 LET j = g_item[k].zaa07
                                 LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                                 LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                                 LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                                 LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                                 LET g_item_sort_1[j].column=g_item[k].column
                                 LET g_item_sort_1[j].sure=g_item[k].sure
                             END FOR
                        END IF
                        FOR k = 1 to g_item_sort_1.getLength()
                           IF g_item_sort_1[k].zaa06 = 'N' THEN
                             #FUN-6B0006---start--- 
                             IF g_aza.aza66 = 2 AND (g_body_title_pos - 1 != cnt) THEN 
                                LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                                IF str_cnt > g_item_sort_1[k].zaa05 THEN
                                      LET g_item_sort_1[k].zaa08 = ""
                                      FOR j = 1 to g_item_sort_1[k].zaa05
                                          LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08, "#"
                                      END FOR
                                      LET l_str = l_str, g_item_sort_1[k].zaa08 CLIPPED
                                      LET l_str = l_str," "
                                ELSE
                                      LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED) 
                                      IF str_cnt > 0 THEN
                                         LET l_str = l_str, g_item_sort_1[k].zaa08 CLIPPED
                                      END IF
                                      LET column_cnt = g_item_sort_1[k].zaa05 - str_cnt + 1
                                      #FUN-810047
                                      #FOR j = 1 to column_cnt
                                      #      LET l_str = l_str," "
                                      #END FOR
                                      LET l_str = l_str, column_cnt SPACES
                                      #END FUN-810047
                                      LET str_cnt = FGL_WIDTH(l_str)
                                END IF
                             ELSE
                             #FUN-6B0006---end--- 
                                LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED) 
                                IF str_cnt > 0 THEN
                                   LET l_str = l_str, g_item_sort_1[k].zaa08 CLIPPED
                                END IF
                                LET column_cnt = g_item_sort_1[k].zaa05 - str_cnt + 1
                                #FUN-810047
                                #FOR j = 1 to column_cnt
                                #   LET l_str = l_str," "
                                #END FOR
                                LET l_str = l_str, column_cnt SPACES
                                #END FUN-810047
                                LET str_cnt = FGL_WIDTH(l_str)
                             END IF
                           END IF
                        END FOR
                     END IF
                   END IF
                   LET l_str = g_left_str,l_str             #FUN-650017
                   CALL l_channel.write(l_str.trimRight())  #TQC-640051
                   LET cnt=cnt+1
                   IF ( cnt > g_pagelen) THEN
                      FOR k = 1 to g_bottom
                          LET l_str= ""," "
                          CALL l_channel.write(l_str)
                      END FOR
                      LET cnt= 0
                      IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                         CALL cl_progressing("process: xml")            #FUN-570141
                      END IF                   ### FUN-570264 ###
                      LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                   END IF
                   LET l_i = 0                                 #g_item2陣列數
                   LET column_cnt = 1
                   LET l_pageheader = "N"                      #pageheader的tag
                   LET l_str = ""
                   LET g_sort = "N"
                   CALL g_item.clear()
                   CALL g_item2.clear()
                   CALL g_item_sort_1.clear()
                   LET l_pageheader = "Y"
                   LET n_id_dash1 = FALSE                     #TQC-5B0066
                 END IF     
             
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
 
          END CASE
 
      END CASE
      LET e= r.read()
   END WHILE
   #END FUN-570208
   CALL l_channel.close()
 
END FUNCTION
 
#MOD-580063
##################################################
# Descriptions...: 多行抬頭 html2格式
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_html2()
DEFINE  output_type,l_pageheader,l_tr           LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        l_channel                               base.Channel,
        cnt_print,cnt_item,i,j,a,b,noskip_old   LIKE type_file.num10,       #No.FUN-690005 integer,
        l_str,value,value_trim,l_cmd            string,
        n_name,l_skip_tag                       string,
        k,column_cnt,cnt_noskip,l_start_i       LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        tag,tag2,cnt,str_cnt,l_i                LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        str_center                              LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        l_print_cnt                             LIKE type_file.num5         #No.FUN-690005 SMALLINT   #FUN-570052
DEFINE  l_first_header,l_first_trailer          LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1), 
        page_cnt,l_p1                           LIKE type_file.num10,       #No.FUN-690005 INTEGER,        
        page_end                                LIKE type_file.num5,        #No.FUN-690005 SMALLINT,
        l_str2                                  STRING,
        l_detail                                LIKE type_file.num10       #No.FUN-690005 INTEGER
#END FUN-580019
DEFINE  l_bufstr                                base.StringBuffer  #TQC-650109
 
DEFINE l_td_attr STRING #No.FUN-6A0159
 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
   LET l_str = ""

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --
 
   #FUN-580019
   IF g_output_type MATCHES "[78]"   THEN
     LET cnt = 0
     LET l_str = ""

     #No.FUN-9B0062 -- start --
     IF os.Path.delete(output_name CLIPPED) THEN
     END IF
     #No.FUN-9B0062 -- end --

     LET l_cmd = "cat ",FGL_GETENV("DS4GL") CLIPPED,"/bin/cl_trans_script.tpl >> ",output_name CLIPPED  #
     RUN l_cmd
     LET l_detail = 0                            #目前行數是否在單身
   END IF
 
     LET l_channel = base.Channel.create()
     CALL l_channel.openFile(output_name,"a" )
     CALL l_channel.setDelimiter("")
  
   #FUN-580019
   IF g_output_type MATCHES "[78]"   THEN
     CALL cl_trans_button() RETURNING l_str    #BUTTON內容
     CALL l_channel.write(l_str)
     LET l_str = ""
     LET page_end = FALSE
     LET l_first_header="N"
     LET l_first_trailer = "N"
     LET page_cnt = 1
   END IF
   #END FUN-580019
  
 
   #FUN-570141
    LET g_sql = "SELECT zaa02 FROM zaa_file ",
   " where zaa01= '", g_prog ,"' AND zaa09='1'", 
   " AND zaa04 = '",g_zaa04_value,"' AND zaa10 = '",
     g_zaa10_value,"' AND zaa11='",g_zaa11_value,"'",
   " AND zaa17 = '",g_zaa17_value,"'"
    PREPARE cl_trans_prepare2 FROM g_sql           #預備一下
    DECLARE cl_trans_curs2 CURSOR FOR cl_trans_prepare2
   #END FUN-570141
 
 ## 讀取報表資料
   CALL cl_trans_column(column_cnt) RETURNING l_str
   CALL l_channel.write(l_str)
   LET l_str = ""
 
  #FUN-570208
   LET column_cnt = 1
   LET l_tr = "N"  
   LET l_pageheader = "Y"                 #FUN-5A0135
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
    CASE e
      WHEN "StartElement"
        CASE
          WHEN r.getTagName() = "PageTrailer"
             LET n_id_name = "PageTrailer"
 
          WHEN r.getTagName() = "PageHeader"
             LET n_id_name = "PageHeader"
 
          WHEN r.getTagName() = "Print"
             LET n_name = r.getTagName()
             LET cnt_item = 0
             LET cnt_noskip = 0
             LET g_print_name = lsax_attrib.getValue("name")
             IF (g_print_cnt = 0) AND (g_print_name IS NOT NULL)THEN
                IF noskip_old = 0 THEN          
                    LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                    LET g_print_num = g_print_int
                    #MOD-580299
                    IF g_line_seq > 1 THEN
                       FOR k = 1 to g_print_num-1
                           LET l_i = l_i + g_report_cnt[k]
                       END FOR
                    END IF
                    #END MOD-580299
                    LET l_start_i = l_i + 1
                END IF
             END IF
 
          WHEN r.getTagName() = "Item"
             LET cnt_item = cnt_item + 1
             LET value = lsax_attrib.getValue("value")
             #TQC-650109
             CALL l_bufstr.clear()
             CALL l_bufstr.append(value)
             IF NOT cl_null(value) THEN
                CALL l_bufstr.replace("<","&lt;",0)
             END IF
             LET value = l_bufstr.tostring()
             #END TQC-650109
 
             ### 公司名稱 合併
             IF value = g_company AND n_id_name == "PageHeader" THEN   #FUN-690088
                 #FUN-580019       
                 IF g_output_type MATCHES "[78]"   THEN
                   LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center >",cl_add_span(value)   #No.FUN-A90047  #CHI-B30026 
                 ELSE
                   LET l_str = "<TR height=22><TD bgcolor=#FFCC99 colspan=",g_column_cnt," align=center >",cl_add_span(value) #No.FUN-A90047  #CHI-B30026 
                 END IF 
                 LET l_tr = "Y"
                 LET l_pageheader= "Y"     
                 EXIT CASE
             END IF
             
             #TQC-710026
             #動態報表名稱
             IF g_print_name = "rep_name" THEN
                 LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(value),"</TD></TR>"   #No.FUN-A90047  #CHI-B30026 
                 LET l_tr = "Y"
                 LET l_pageheader= "Y"     
                 EXIT CASE
             END IF
             #TQC-710026
 
             #### 空白行 
             #LET value_trim = value.trim()
             #IF (g_print_name IS NULL) AND (cnt_item = 1) AND (value_trim.equals("") ) THEN       
             #   LET l_str = "<TR height=22><TD colspan=",g_view_cnt,"> &nbsp;"
             #    LET l_tr = "Y"
             #   LET l_pageheader= "Y"     
             #   IF g_output_type MATCHES "[78]" THEN #FUN-580019
             #           LET value = g_dash CLIPPED
             #   END IF
             #   EXIT CASE
             #END IF
             ### 虛線不列印
             #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED)) OR (value.equals(g_dash2 CLIPPED))THEN       
             IF (value = g_dash1) OR (value = g_dash_out) OR (value = g_dash2_out) THEN       #TQC-6A0113
                LET l_str = "<TR height=22><TD colspan=",g_column_cnt ,"> &nbsp;"   #No.FUN-A90047  #CHI-B30026 
                 LET l_tr = "Y"
                LET l_pageheader= "Y"     
                EXIT CASE
             END IF
             #FUN-690088
             #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
             #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
             #THEN
             #   LET value = g_dash CLIPPED
             #   LET l_str = "<TR height=22><TD colspan=",g_view_cnt ,"> &nbsp;"
             #   LET l_tr = "Y"
             #   LET l_pageheader= "Y"     
             #   EXIT CASE
             #END IF
             #END FUN-690088
 
              IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱
                
                IF g_output_type MATCHES "[78]" AND page_cnt = g_total_page THEN #FUN-580019
                        LET page_end = TRUE
                END IF
                LET j = l_i + 1
                LET g_xml_value = value
                #FUN-570052
                LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                #TQC-5B0170
                IF g_zaa_dyn.getLength() > 0 THEN
                   LET g_item[j].zaa08= g_zaa_dyn[g_page_cnt,g_xml_value]
                ELSE
                   LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                END IF
                #END TQC-5B0170
 
                LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                LET g_item[j].column = g_c[g_xml_value]
                #END FUN-570052
 
                LET l_i = l_i + 1
                LET l_pageheader = "N"
             ELSE
                IF (g_print_name IS NULL ) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                   IF (cnt < 3+g_top) THEN                     #TQC-710026
                        IF l_str.trim() = " " THEN
                             LET l_str = value
                        ELSE
                             LET l_str = l_str,value
                        END IF
                   ELSE 
                        LET l_str = l_str,value
                   END IF
                   LET l_pageheader= "Y"     
                ELSE
                    IF l_i = 0 THEN  
                      LET l_i = l_i + 1
                    ELSE
                      IF g_item2[l_i].zaa08 IS NULL THEN
                           LET value = g_item2[l_i].zaa08 CLIPPED,value
                      END IF
                    END IF
                    LET g_item2[l_i].zaa08 = value CLIPPED              ### item value
                    LET g_item2[l_i].column = column_cnt
                    LET l_pageheader= "N"
                END IF
             END IF
 
          WHEN r.getTagName() = "Column"
             LET value = lsax_attrib.getValue("value")
             LET column_cnt = value
             IF (g_print_name IS NULL) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                 LET str_cnt = FGL_WIDTH(l_str)
                 LET column_cnt = column_cnt - str_cnt - 1
                 #FUN-810047
                 #FOR j = 1 to column_cnt
                 #      LET l_str = l_str," "
                 #END FOR
                 LET l_str = l_str, column_cnt SPACES
                 #END FUN-810047
             ELSE
                 LET l_i = l_i + 1               #
             END IF
 
          WHEN r.getTagName() = "NoSkip"
               LET cnt_noskip = 1
 
        END CASE
 
      WHEN "EndElement"
        CASE
          WHEN r.getTagName() = "Print"
            IF ( cnt_noskip = 0 ) THEN
               IF (g_print_name IS NOT NULL) THEN
                  LET lsax_attrib = r.getAttributes()
                  LET e = r.read()
                  LET g_print_end = "Y"
                  LET g_next_name = lsax_attrib.getValue("name")
                  LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                  LET g_print_num = g_print_int
                  LET g_print_cnt = g_print_cnt + 1 
                  IF (g_print_name.subString(1,1)=g_next_name.subString(1,1)) THEN
                        LET g_next_int = g_next_name.subString(2,g_next_name.getLength())
                        LET g_next_num = g_next_int
                        IF g_next_num = g_print_num + 1 THEN
                           IF g_print_cnt = 1 THEN
                               #MOD-580299
                               IF g_line_seq = 1 AND g_print_num > 1 THEN
                                   LET g_print_start = 1
                                   LET g_print_int = 1
                               ELSE
                                   LET g_print_start = g_print_num
                               END IF
                               #END MOD-580299
                           END IF
                           LET g_print_end = "N"
                        ELSE
                            IF g_print_cnt = 1 THEN
                               #MOD-580299
                               IF g_line_seq = 1 AND g_print_num > 1 THEN
                                   LET g_print_start = 1
                                   LET g_print_int = 1
                               ELSE
                                   LET g_print_start = g_print_num
                               END IF
                               #END MOD-580299
                            END IF
                        END IF
                  ELSE
                        IF g_print_cnt = 1 THEN
                            #MOD-580299
                            IF g_line_seq = 1 AND g_print_num > 1 THEN
                                LET g_print_start = 1
                                LET g_print_int = 1
                            ELSE
                                LET g_print_start = g_print_num
                            END IF
                            #END MOD-580299
                        END IF
                  END IF
              END IF
              IF ( g_print_end ="Y" ) OR g_print_name IS NULL THEN
                IF ((g_output_type = "7")          #FUN-580019
                 AND (((n_id_name == "PageHeader") AND (l_first_header="Y"))
                 OR ((n_id_name == "PageTrailer") AND (l_first_trailer="N"))
                 OR (cnt_item = 0 )                            
                #TQC-6A0113
                #OR (value.equals(g_dash CLIPPED))
                #OR (value.equals(g_dash1)) OR (value.equals(g_dash2 CLIPPED))))
                #OR (g_output_type = "8"
                #AND ((cnt_item = 0 )
                #OR (value.equals(g_dash CLIPPED))
                #OR (value.equals(g_dash1)) OR (value.equals(g_dash2 CLIPPED))))
                 OR (value = g_dash_out)
                 OR (value = g_dash1) OR (value = g_dash2_out)))
                 OR (g_output_type = "8"
                 AND ((cnt_item = 0 )
                 OR (value = g_dash_out)
                 OR (value = g_dash1) OR (value = g_dash2_out)))
                #END TQC-6A0113
 
                THEN
                         LET cnt=cnt+1
                         IF l_pageheader = 'N' AND (g_print_start < g_print_int) THEN
                              FOR a = g_print_start to g_print_int
                                        LET cnt=cnt+1
                              END FOR
                         END IF
                ELSE
                  ###表頭、表尾資料合併，除了表頭欄位內容
                  IF l_tr = "N" THEN
                    IF (g_print_name IS NULL) # OR (g_body_title_pos - 1 <> cnt) AND (n_id_name == "PageHeader") 
                      OR (n_id_name == "PageTrailer") THEN
         
                      IF (g_output_type MATCHES "[78]" AND (page_end = TRUE))    #FUN-580019
                       OR (g_output_type = "8" AND l_first_trailer= "N" AND n_id_name == "PageTrailer")
                      THEN
                           LET l_str2="</TABLE><TABLE border=1 cellSpacing=0 cellPadding=2 BORDERCOLOR=\"#DFDFDF\">"  #FUN-580019  #TQC-5B0055
                           LET l_detail = 0                                       #FUN-580019
                           CALL l_channel.write(l_str2)
                           LET l_str2 = ""
                           LET l_first_trailer="Y"
                      ELSE
                           IF (g_output_type MATCHES "[78]" AND l_detail = 1 )    #FUN-580019
                           THEN
                                CALL cl_err(g_xml_value,'lib-285',1)
                                CALL cl_close_progress_bar()  
                                LET INT_FLAG = 1
                                RETURN   
                           END IF
                      END IF 
                      LET str_center = "N"
                      IF n_id_name == "PageHeader" THEN
                        IF (NOT l_str.equals(g_company)) THEN
                          #No.FUN-810047
                          #OPEN cl_trans_curs2                         #FUN-570141
                          #FOREACH cl_trans_curs2 INTO g_xml_value 
                          #     IF (cnt < 3+g_top ) AND l_str.equals(g_x[g_xml_value]) THEN  #TQC-710026
                          #        LET str_center = "Y" 
                          #        EXIT FOREACH
                          #     END IF
                          #END FOREACH
                          FOR j = 1 TO g_zaa02.getLength()
                              IF (cnt < 3+g_top ) AND l_str.equals(g_x[g_zaa02[j]]) THEN  #TQC-710026
                                 LET str_center = "Y" 
                                 EXIT FOR
                              END IF
                          END FOR
                          #END No.FUN-810047
                        END IF
                      END IF
                      IF str_center = "Y" THEN
                          LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(l_str),"&nbsp;"       #FUN-580019  #No.FUN-A90047 #CHI-B30026 
                      ELSE 
                          LET l_str = "<TR height=22><TD colspan=",g_column_cnt," >",cl_add_span(l_str),"&nbsp;"                   #No.FUN-A90047 #CHI-B30026 
                          IF g_output_type MATCHES "[7]"     #FUN-580019
                          THEN
                             LET l_p1 = l_str.getIndexOf(g_x[3],1)
                             IF l_p1 > 1 THEN
                                LET l_str = l_str.subString(1,l_p1-1)
                             END IF
                          END IF
                      END IF
                    ELSE
                      IF g_output_type MATCHES "[78]" AND g_print_name.subString(1,1)="h" THEN    #FUN-580019
                             LET l_str = "<TR bgcolor=#FFCC99 >",l_str
                      ELSE
                             LET l_str = "<TR height=22>",l_str    #No.FUN-A90047
                      END IF
                    END IF
                  END IF
                  #TQC-6A0113
                  #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR
                  #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED)) THEN
                  IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                      (l_str = g_dash1) OR (l_str=g_dash2_out) THEN
                  #END TQC-6A0113
 
                      IF (g_output_type MATCHES "[78]" AND l_detail = 1 )    #FUN-580019
                      THEN
                           CALL cl_err(g_xml_value,'lib-285',1)
                           CALL cl_close_progress_bar()  
                           LET INT_FLAG = 1
                           RETURN   
                      END IF
                
                     IF (l_pageheader = "Y") THEN
                           LET l_str = l_str ,"</TD></TR>"          #CHI-B30026 
                     END IF
                
                  ELSE
                     IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱   #CHI-760015
                         LET l_pageheader = "N"
                         IF g_output_type MATCHES "[78]"   THEN       #FUN-580019
                            LET l_first_header = "Y"
                            IF g_output_type = "7" THEN
                               LET l_str2="</TABLE><TABLE border=1 cellSpacing=0 cellPadding=2 id=PowerTable1 BORDERCOLOR=\"#DFDFDF\" >" #FUN-580019  #TQC-5B0055
                            ELSE
                               LET l_str2="</TABLE><TABLE border=1 cellSpacing=0 cellPadding=2 id=PowerTable",page_cnt USING '<<<<<<<<<<'," BORDERCOLOR=\"#DFDFDF\" >"  #FUN-580019  #TQC-5B0055
                            END IF
                            LET l_detail = 1                          #FUN-580019
                            CALL l_channel.write(l_str2)
                            LET l_str2 = ""
                         END IF
                     ELSE 
                       IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                          FOR j = 1 to g_value.getLength()   
                            LET g_xml_value = g_value[j].zaa02    
                         #FUN-570052
                            LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                            LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                            LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                            LET g_item[j].zaa08 = ""
                            LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                            LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                            LET g_item[j].column = g_c[g_xml_value]
         
                          END FOR
                         #END FUN-570052
         
                          CALL g_item_sort.clear()
                          FOR k = 1 to g_item.getLength()#資料排序
                            IF g_item[k].zaa05 IS NOT NULL THEN
                              LET a = g_item[k].zaa15
                              LET b = g_item[k].zaa07
                              LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                              LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                              LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                              LET g_item_sort[a,b].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                              LET g_item_sort[a,b].column=g_item[k].column
                              LET g_item_sort[a,b].sure=g_item[k].sure
                            END IF
                          END FOR
                          CALL g_item.clear()
                          LET k = 0
                          FOR a = 1 to g_line_seq
                            FOR b = 1 to g_item_sort[a].getLength()
                             IF g_item_sort[a,b].zaa05 IS NOT NULL THEN
                               LET k = k + 1
                               LET g_item[k].zaa05 =g_item_sort[a,b].zaa05
                               LET g_item[k].zaa06 =g_item_sort[a,b].zaa06
                               LET g_item[k].zaa08 =g_item_sort[a,b].zaa08 CLIPPED
                               LET g_item[k].zaa14 =g_item_sort[a,b].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item[k].zaa07 = b
                               LET g_item[k].zaa15 = a
                               LET g_item[k].column=g_item_sort[a,b].column
                               LET g_item[k].sure  =g_item_sort[a,b].sure
                             END IF
                            END FOR
                          END FOR
                          LET tag = 0
                          LEt tag2 = 0
                          FOR k = l_start_i TO g_item2.getLength()
                             #TQC-6B0006
                             IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                               CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                               LET INT_FLAG = 1
                               RETURN
                             END IF
                             #END TQC-6B0006
                             LET g_cnt = g_item.getLength() #TQC-950138
                             FOR j = 1 to g_cnt             #TQC-950138
                               IF (j = g_item.getLength()) AND (g_item2[k].column > g_item[j].column-1) THEN
                                  LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                  EXIT FOR
                        
                               ELSE
                                  IF (g_item2[k].column > g_item[j].column-1) AND 
                                     (g_item2[k].column < g_item[j+1].column) THEN
                                     IF (g_item[j].sure IS NULL) OR (g_item[j].sure = "") THEN
                                         LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                         LET g_item[j].sure="Y"
                                         LET tag = j
                                     ELSE
                                         LET tag = tag + 1
                                         LET g_item[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                         LET g_item[tag].sure="Y"
                                      END IF
                        
                                    EXIT FOR
                                  END IF
                               END IF
                             END FOR
                          END FOR 
                          LET l_pageheader = "N"
                        END IF
                    END IF
                    IF l_pageheader == "N" THEN
                       FOR k = 1 to g_item.getLength()
                         IF g_item[k].zaa05 IS NOT NULL THEN
                           LET a = g_item[k].zaa15
                           LET b = g_item[k].zaa07
                           LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                           LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                           LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                           LET g_item_sort[a,b].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                           LET g_item_sort[a,b].column=g_item[k].column-g_item_sort[k,1].column
                           LET g_item_sort[a,b].sure=g_item[k].sure
                         END IF
                       END FOR
                       FOR a = 1 to g_line_seq
                          FOR b = 1 to g_item_sort[a].getLength()
                            IF g_item_sort[a,b].zaa05 IS NULL THEN
                                 CALL g_item_sort[a].deleteElement(b)
                            END IF
                          END FOR
                       END FOR
                       ## 判斷一行小計，不能上下移動，只能左右 
                       IF (g_print_name.subString(1,1)="s") AND (g_print_start=g_print_int) THEN
                          FOR a = 1 to g_line_seq
                             IF g_print_start <> a THEN
                                FOR b = 1 to g_item_sort[a].getLength()
                                    IF g_item_sort[a,b].zaa08 IS NOT NULL THEN
                                       LET g_item_sort[g_print_start,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED
                                       LET g_item_sort[g_print_start,b].zaa05 = g_item_sort[a,b].zaa05
                                    END IF
                                END FOR
                             END IF
                          END FOR
                       END IF
                       ## 組l_str 
                       FOR a = g_print_start to g_print_int
                         #FUN-580019
                         IF g_output_type MATCHES "[78]" AND a <> g_print_start  
                            AND g_print_name.subString(1,1)="h" 
                         THEN 
                                LET l_str = "<TR bgcolor=#FFCC99 >",l_str
                         ELSE IF a <> g_print_start THEN
                                LET l_str = "<TR height=22>",l_str   #No.FUN-A90047
                         END IF
                         END IF
                         #FUN-580019
                         LET l_print_cnt = 0                         #FUN-570052
                         FOR b = 1 to g_item_sort[a].getLength()
                            IF g_item_sort[a,b].zaa06 = 'N' THEN
                               IF (g_zaa13_value = "N" ) OR
                                  (g_print_name.subString(1,1)="h")  #TQC-5B0055
                               THEN
                                  LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08)
                                  ### MOD-580150 ###
                                  LET column_cnt = g_item_sort[a,b].zaa05 - str_cnt 
                                  ### MOD-580150 ###
                                  #No.FUN-6A0159 --start--
                                  IF NOT ((g_print_name.subString(1,1) = "h") AND
                                    (g_item_sort[a,b].zaa14 MATCHES '[ABCDEFQ]'))
                                  THEN
                                     FOR j = 1 to column_cnt
                                        LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED, "&nbsp;"  #echo 
                                     END FOR
                                  END IF
                                  #No.FUN-6A0159 --end--
                               END IF
                               #FUN-6B0006---start--- 
                               IF g_aza.aza66 = 2 AND (g_print_name.subString(1,1) != "h") THEN 
                                  LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08)
                                  IF str_cnt > g_item_sort[a,b].zaa05 THEN
                                        LET g_item_sort[a,b].zaa08 = ""
                                        FOR j = 1 to g_item_sort[a,b].zaa05
                                            LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08, "#"
                                        END FOR
                                  END IF
                               END IF
                               #FUN-6B0006---end--- 
                               IF (g_item_sort[a,b].zaa08 IS NULL) OR (g_item_sort[a,b].zaa08 = " ") THEN
                                 LET g_item_sort[a,b].zaa08 = "&nbsp;"
                               END IF
                               #No.FUN-6A0159 --start--
                               IF (g_print_name.subString(1,1)="h") AND
                                  (g_item_sort[a,b].zaa14 MATCHES '[ABCDEFQ]')
                               THEN   #是否為單身抬頭
                                 LET l_str = l_str CLIPPED,"<TD align=center>",  cl_add_span(g_item_sort[a,b].zaa08),"</TD>"      #CHI-B30026 
                               ELSE
                                 LET l_str = l_str CLIPPED,"<TD>",  cl_add_span(g_item_sort[a,b].zaa08),"</TD>" #FUN-580019  #CHI-B30026 
                               END IF
                               #No.FUN-6A0159 --end--
                               LET l_print_cnt = l_print_cnt + 1             #FUN-570052
                            END IF
                         END FOR
                         FOR k = 1 to g_view_cnt-l_print_cnt              #FUN-570052
                                 LET l_str = l_str CLIPPED,"<TD>&nbsp;</TD>"   #FUN-580019
                         END FOR
                         LET l_str = l_str CLIPPED,"</TR>"
                         CALL l_channel.write(l_str)
                         LET cnt=cnt+1
                         LET l_str = ""
                       END FOR
                
                    END IF
                END IF
                IF (l_str = "<TR height=22>") THEN   #No.FUN-A90047
                   LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;</TD></TR>"  #No.FUN-A90047  #CHI-B30026 
                   IF (g_output_type MATCHES "[78]" AND l_detail = 1 )    #FUN-580019
                   THEN
                        CALL cl_err(g_xml_value,'lib-285',1)
                        CALL cl_close_progress_bar()  
                        LET INT_FLAG = 1
                        RETURN   
                   END IF
                END IF
                IF l_pageheader == "Y" THEN
                   CALL l_channel.write(l_str)
                   LET cnt=cnt+1
                END IF
               END IF       #FUN-580019
                IF ( cnt > g_pagelen) THEN
                  IF g_output_type MATCHES "[7]"   THEN         #FUN-580019
                     LET page_cnt = page_cnt + 1
                  ELSE
                     #TQC-5B0055
                     IF g_output_type = "8" THEN                #FUN-580019
                          LET page_cnt = page_cnt + 1
                     ELSE
                          for k = 1 to g_bottom 
                               LET l_str = "<TR height=22><TD colspan=",g_column_cnt,">&nbsp;</TD></TR>"   #No.FUN-A90047 #CHI-B30026 
                              CALL l_channel.write(l_str)
                          end for
                     END IF
                     #END TQC-5B0055
                     #### 分頁格線 ####
                     LET l_str="</TABLE></div>",
                               "<p></p>"
                     #FUN-580019
                     IF g_output_type = "8" THEN            
                        LET l_str=l_str,
                                  "<TABLE border=0 cellSpacing=0 cellPadding=1 BORDERCOLOR=\"#DFDFDF\" >"  #FUN-580019 #TQC-5B0055
                        LET l_detail = 0
                        LET l_first_trailer= "N"
                     ELSE
                        LET l_str=l_str,"<div align=center>",
                                 "<TABLE border=1 cellSpacing=0 cellPadding=1 STYLE=",g_quote,"font-size: 8pt",g_quote,"  BORDERCOLOR=\"#DFDFDF\">"        #FUN-580019
                     END IF
                     #END FUN-580019
                     CALL l_channel.write(l_str)
                   END IF
                   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                      CALL cl_progressing("process: xml")            #FUN-570141
                   END IF                   ### FUN-570264 ###
                   LET cnt= 0
                   LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                END IF
                LET l_str = ""
                LET l_i = 0 
                LET column_cnt = 1
                LET cnt_item = 0
                LET l_tr = "N"  
                CALL g_item.clear()
                CALL g_item2.clear()
                CALl g_item_sort.clear()
                LET l_pageheader = "Y"
                LET g_print_cnt = 0
              END IF
            END IF      
            LET noskip_old = cnt_noskip
         
          WHEN r.getTagName() = "PageTrailer"
              LET n_id_name = "xml"
 
          WHEN r.getTagName() = "PageHeader"
              LET n_id_name = "xml"
 
        END CASE
 
      END CASE
      IF g_print_end IS NULL  THEN
         LET e= r.read()
      END IF
      LET g_print_end = NULL
   END WHILE
 
   CLOSE cl_trans_curs2                     #FUN-570141
   CALL l_channel.write("</TABLE></div></body></html>")    ##FUN-A90047
   CALL l_channel.close()
 
   #FUN-580019
   IF g_output_type = "8"   THEN
      LET page_cnt = page_cnt - 1
      LET l_str2 = output_name.subString(1,output_name.getLength()-4),"1.htm"
      LET l_str = "for (var i=1; i<=",page_cnt USING '<<<<<<<<<<',";i++) {" 
      #No.FUN-960155 -- start -- 

      #No.FUN-9B0062 -- start --
      IF os.Path.separator() = "/" THEN 
         LET l_cmd = "awk ' { sub(/\\/\\/{@}#1/, \"",l_str CLIPPED,"\"); sub(/\\/\\/{@}#2/, \"\") ; print $0  } ' $TEMPDIR/",
                      output_name CLIPPED," > ",l_str2 CLIPPED
         RUN l_cmd
         
         LET l_cmd = "cp ",os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED)," ",os.Path.join(FGL_GETENV("TEMPDIR"),output_name CLIPPED) #FUN-9B0062
         RUN l_cmd
         LET l_cmd = "chmod 777 ",output_name CLIPPED," 2>/dev/null" #MOD-530271
         RUN l_cmd
      ELSE
         LET l_cmd = "%FGLRUN% ",os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin" ),"rsed.42m"),
                     ' "//{@}#1" "',l_str,'" ',
                     output_name CLIPPED," ",l_str2 CLIPPED
         RUN l_cmd
         IF os.Path.copy( os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED),     #FUN-930058
                          os.Path.join(FGL_GETENV("TEMPDIR"),output_name CLIPPED ) ) THEN END IF
          
         LET l_cmd = "%FGLRUN% ",os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin" ),"rsed.42m"),
                     ' "//{@}#2" "',l_str,'" ',
                     output_name CLIPPED," ",l_str2 CLIPPED
         RUN l_cmd
         IF os.Path.copy( os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED),     #FUN-930058
                          os.Path.join(FGL_GETENV("TEMPDIR"),output_name CLIPPED ) ) THEN END IF
         LET l_cmd = "attrib -r ",output_name CLIPPED," >nul 2>nul" #MOD-530271
         RUN l_cmd
      END IF
      IF os.Path.delete(l_str2 CLIPPED) THEN
      END IF
      #No.FUN-9B0062 -- end --
   END IF
   #END FUN-580019
END FUNCTION
 
##################################################
# Descriptions...: 多行抬頭 excel2格式
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_excel2()
DEFINE  output_type,l_pageheader,l_tr           LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        l_channel                               base.Channel,
        cnt_print,cnt_item,i,j,a,b,noskip_old   LIKE type_file.num10,       #No.FUN-690005 integer,
        l_str,value,value_trim,l_cmd            string,
        n_name,l_skip_tag                       string,
        k,column_cnt,cnt_noskip,l_start_i       LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        tag,tag2,cnt,str_cnt,l_i                LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        str_center                              LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        l_print_cnt                             LIKE type_file.num5        #No.FUN-690005 SMALLINT   #FUN-570052
DEFINE  l_bufstr                                base.StringBuffer  #TQC-650109
#FUN-670044
DEFINE  l_value_len                             LIKE type_file.num10,
        l_dec                                   LIKE type_file.num10,
        l_dec_point                             LIKE type_file.num10,
        l_zaa08_value                           STRING
#END FUN-670044
DEFINE l_td_attr                                STRING   #No.FUN-6A0159
DEFINE l_class_id                               STRING   #FUN-A90058

 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
   LET l_str = ""

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --
 
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(output_name,"a" )
   CALL l_channel.setDelimiter("")
  
   #FUN-570141
    LET g_sql = "SELECT zaa02 FROM zaa_file ",
                " WHERE zaa01= '", g_prog ,"' AND zaa09='1'", 
                  " AND zaa04 = '",g_zaa04_value,"' AND zaa10 = '",g_zaa10_value,"' ",
                  " AND zaa11 = '",g_zaa11_value,"' AND zaa17 = '",g_zaa17_value,"'"
    PREPARE cl_trans2_prepare2 FROM g_sql           #預備一下
    DECLARE cl_trans2_curs2 CURSOR FOR cl_trans2_prepare2
   #END FUN-570141
 
 ## 讀取報表資料
   CALL cl_excel_column() RETURNING l_str    #MOD-580063
   CALL l_channel.write(l_str)
 
   #FUN-570208
   LET l_str = ""
   LET g_pageno = cnt_print/g_pagelen
   LET column_cnt = 1
   LET l_tr = "N"  
   LET l_pageheader = "Y"                 #FUN-5A0135
 
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
    CASE e
      WHEN "StartElement"
        CASE
          WHEN r.getTagName() = "PageTrailer"
             LET n_id_name = "PageTrailer"
 
          WHEN r.getTagName() = "PageHeader"
             LET n_id_name = "PageHeader"
 
          WHEN r.getTagName() = "Print"
             LET n_name = r.getTagName()
             LET cnt_noskip = 0
             LET g_print_name = lsax_attrib.getValue("name")
             IF (g_print_cnt = 0) AND (g_print_name IS NOT NULL)THEN
                IF noskip_old = 0 THEN          
                    LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                    LET g_print_num = g_print_int
                    #MOD-580299
                    IF g_line_seq > 1 THEN
                       FOR k = 1 to g_print_num-1
                           LET l_i = l_i + g_report_cnt[k]
                       END FOR
                    END IF
                    #END MOD-580299
                    LET l_start_i = l_i + 1
                END IF
             END IF
 
          WHEN r.getTagName() = "Item"
             LET value = lsax_attrib.getValue("value")
             #TQC-650109
             CALL l_bufstr.clear()
             CALL l_bufstr.append(value)
             IF NOT cl_null(value) THEN
                CALL l_bufstr.replace("<","&lt;",0)
             END IF
             LET value = l_bufstr.tostring()
             #END TQC-650109
 
             ### 公司名稱 合併
             IF value = g_company AND n_id_name == "PageHeader" THEN   #FUN-690088
                 LET l_str = "<TR height=22><TD bgcolor=#FFCC99 colspan=",g_column_cnt," align=center >",cl_add_span(value)   #No.FUN-A90047   #CHI-B30026 
                 LET l_tr = "Y"
                 LET l_pageheader= "Y"     
                 EXIT CASE
             END IF
             
             #TQC-710026
             #動態報表名稱
             IF g_print_name = "rep_name" THEN
                 LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>", cl_add_span(value),"</TD></TR>"  #No.FUN-A90047  #CHI-B30026 
                 LET l_tr = "Y"
                 LET l_pageheader= "Y"     
                 EXIT CASE
             END IF
             #TQC-710026
 
             #### 空白行 
             #LET value_trim = value.trim()
             #IF (g_print_name IS NULL) AND (cnt_item = 1) AND (value_trim.equals("") ) THEN       
             #   LET l_str = "<TR height=22><TD colspan=",g_view_cnt,"> &nbsp;"
             #    LET l_tr = "Y"
             #   LET l_pageheader= "Y"     
             #   EXIT CASE
             #END IF
             ### 虛線不列印
             #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED)) OR (value.equals(g_dash2 CLIPPED))THEN       
             IF (value = g_dash1) OR (value = g_dash_out) OR (value = g_dash2_out)THEN #TQC-6A0113
                LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;"   #No.FUN-A90047  #CHI-B30026 
                 LET l_tr = "Y"
                LET l_pageheader= "Y"     
                EXIT CASE
             END IF
        
             #FUN-690088
             #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
             #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
             #THEN
             #   LET value = g_dash CLIPPED
             #   LET l_str = "<TR height=22><TD colspan=",g_view_cnt ,"> &nbsp;"
             #   LET l_tr = "Y"
             #   LET l_pageheader= "Y"     
             #   EXIT CASE
             #END IF
             #END FUN-690088
 
              IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱
                
                LET j = l_i + 1
                LET g_xml_value = value
                #FUN-570052
                LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                #TQC-5B0170
                IF g_zaa_dyn.getLength() > 0 THEN
                   LET g_item[j].zaa08 = g_zaa_dyn[g_page_cnt,g_xml_value]
                ELSE
                   LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                END IF
                #END TQC-5B0170
 
                LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #MOD-580063
                LET g_item[j].column = g_c[g_xml_value]
                #END FUN-570052
 
                LET l_i = l_i + 1
                LET l_pageheader = "N"
             ELSE
                IF (g_print_name IS NULL ) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                   IF (cnt < 3+g_top) THEN                  #TQC-710026
                        IF l_str.trim() = " " THEN
                             LET l_str = value
                        ELSE
                             LET l_str = l_str,value
                        END IF
                   ELSE 
                        LET l_str = l_str,value
                   END IF
                   LET l_pageheader= "Y"     
                ELSE
                    IF l_i = 0 THEN  
                      LET l_i = l_i + 1
                    ELSE
                      IF g_item2[l_i].zaa08 IS NOT NULL THEN
                           LET value = g_item2[l_i].zaa08 CLIPPED,value
                      END IF
                    END IF
                    LET g_item2[l_i].zaa08 = value CLIPPED              ### item value
                    LET g_item2[l_i].column = column_cnt
                    LET l_pageheader= "N"
                END IF
             END IF
          WHEN r.getTagName() = "Column"
             LET value = lsax_attrib.getValue("value")
             LET column_cnt = value
             IF (g_print_name IS NULL) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                 LET str_cnt = FGL_WIDTH(l_str)
                 LET column_cnt = column_cnt - str_cnt - 1
                 #FUN-810047
                 #FOR j = 1 to column_cnt
                 #      LET l_str = l_str," "
                 #END FOR
                 LET l_str = l_str, column_cnt SPACES
                 #END FUN-810047
             ELSE
                 LET l_i = l_i + 1               #
             END IF
 
          WHEN r.getTagName() = "NoSkip"
               LET cnt_noskip = 1
 
        END CASE
 
      WHEN "EndElement"
        CASE
          WHEN r.getTagName() = "Print"
             IF ( cnt_noskip = 0 ) THEN
                IF (g_print_name IS NOT NULL) THEN
                   LET lsax_attrib = r.getAttributes()
                   LET e = r.read()
                   LET g_print_end = "Y"
                   LET g_next_name = lsax_attrib.getValue("name")
                   LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                   LET g_print_num = g_print_int
                   LET g_print_cnt = g_print_cnt + 1 
                   IF (g_print_name.subString(1,1)=g_next_name.subString(1,1)) THEN
                         LET g_next_int = g_next_name.subString(2,g_next_name.getLength())
                         LET g_next_num = g_next_int
                         IF g_next_num = g_print_num + 1 THEN
                            IF g_print_cnt = 1 THEN
                                #MOD-580299
                                IF g_line_seq = 1 AND g_print_num > 1 THEN
                                    LET g_print_start = 1
                                    LET g_print_int = 1
                                ELSE
                                    LET g_print_start = g_print_num
                                END IF
                                #END MOD-580299
                            END IF
                            LET g_print_end = "N"
                         ELSE
                             IF g_print_cnt = 1 THEN
                                #MOD-580299
                                IF g_line_seq = 1 AND g_print_num > 1 THEN
                                    LET g_print_start = 1
                                    LET g_print_int = 1
                                ELSE
                                    LET g_print_start = g_print_num
                                END IF
                                #END MOD-580299
                             END IF
                         END IF
                   ELSE
                         IF g_print_cnt = 1 THEN
                             #MOD-580299
                             IF g_line_seq = 1 AND g_print_num > 1 THEN
                                 LET g_print_start = 1
                                 LET g_print_int = 1
                             ELSE
                                 LET g_print_start = g_print_num
                             END IF
                             #END MOD-580299
                         END IF
                   END IF
               END IF
               IF ( g_print_end ="Y" ) OR g_print_name IS NULL THEN
                   ###表頭、表尾資料合併，除了表頭欄位內容
                   IF l_tr = "N" THEN
                     IF (g_print_name IS NULL) # OR (g_body_title_pos - 1 <> cnt) AND (n_id_name == "PageHeader") 
                       OR (n_id_name == "PageTrailer") THEN
           
                       LET str_center = "N"
                       IF n_id_name == "PageHeader" THEN
                         IF (cnt < 3+g_top) AND (NOT l_str.equals(g_company)) THEN    #TQC-710026
                           ##No.FUN-810047
                           #OPEN cl_trans2_curs2                         #FUN-570141
                           #FOREACH cl_trans2_curs2 INTO g_xml_value
                           #     IF l_str.equals(g_x[g_xml_value]) THEN
                           #        LET str_center = "Y"
                           #        EXIT FOREACH
                           #     END IF
                           #END FOREACH
                           FOR j = 1 TO g_zaa02.getLength()
                               IF l_str.equals(g_x[g_zaa02[j]]) THEN
                                  LET str_center = "Y"
                                  EXIT FOR
                               END IF
                           END FOR
                           #END No.FUN-810047
                         END IF
                       END IF
                       IF str_center = "Y" THEN
                           LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",l_str CLIPPED,"&nbsp;"       #FUN-580019   #No.FUN-A90047  #CHI-B30026 
                       ELSE 
                           LET l_str = "<TR height=22><TD colspan=",g_column_cnt,">",cl_add_span(l_str)  ##MOD-590325 #No.FUN-A90047 #CHI-B30026 
                       END IF
                     ELSE
                       LET l_str = "<TR height=22>",l_str    #No.FUN-A90047
                     END IF
                   END IF
                   #TQC-6A0113
                   #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR
                   #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED)) THEN
                   IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                       (l_str = g_dash1) OR (l_str = g_dash2_out) THEN
                   #END TQC-6A0113
 
                      IF (l_pageheader = "Y") THEN
                            LET l_str = l_str ,"</TD></TR>"
                      END IF
                 
                   ELSE
                      IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱   #CHI-760015
                          LET l_pageheader = "N"
                      ELSE 
                        IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                           FOR j = 1 to g_value.getLength()   
                             LET g_xml_value = g_value[j].zaa02    
                          #FUN-570052
                             LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                             LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                             LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                             LET g_item[j].zaa08 = ""
                             LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                             LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #FUN-580063
                             LET g_item[j].column = g_c[g_xml_value]
           
                           END FOR
                          #END FUN-570052
           
                           CALL g_item_sort.clear()
                           FOR k = 1 to g_item.getLength()#資料排序
                             IF g_item[k].zaa05 IS NOT NULL THEN
                               LET a = g_item[k].zaa15
                               LET b = g_item[k].zaa07
                               LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                               LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                               LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort[a,b].column=g_item[k].column
                               LET g_item_sort[a,b].sure=g_item[k].sure
                               LET g_item_sort[a,b].zaa14 = g_item[k].zaa14 #MOD-580063
                             END IF
                           END FOR
                           CALL g_item.clear()
                           LET k = 0
                           FOR a = 1 to g_line_seq
                             FOR b = 1 to g_item_sort[a].getLength()
                              IF g_item_sort[a,b].zaa05 IS NOT NULL THEN
                                LET k = k + 1
                                LET g_item[k].zaa05 =g_item_sort[a,b].zaa05
                                LET g_item[k].zaa06 =g_item_sort[a,b].zaa06
                                LET g_item[k].zaa08 =g_item_sort[a,b].zaa08 CLIPPED
                                LET g_item[k].zaa07 = b
                                LET g_item[k].zaa15 = a
                                LET g_item[k].column=g_item_sort[a,b].column
                                LET g_item[k].sure  =g_item_sort[a,b].sure
                                LET g_item[k].zaa14 = g_item_sort[a,b].zaa14 #MOD-580063
                              END IF
                             END FOR
                           END FOR
                           LET tag = 0
                           LEt tag2 = 0
                           FOR k = l_start_i TO g_item2.getLength()
                              #TQC-6B0006
                              IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                                CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                                LET INT_FLAG = 1
                                RETURN
                              END IF
                              #END TQC-6B0006
                              LET g_cnt = g_item.getLength() #TQC-950138
                              FOR j = 1 to g_cnt             #TQC-950138
                                IF (j = g_item.getLength()) AND (g_item2[k].column > g_item[j].column-1) THEN
                                   LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                   EXIT FOR
                         
                                ELSE
                                   IF (g_item2[k].column > g_item[j].column-1) AND 
                                      (g_item2[k].column < g_item[j+1].column) THEN
                                      IF (g_item[j].sure IS NULL) OR (g_item[j].sure = "") THEN
                                          LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item[j].sure="Y"
                                          LET tag = j
                                      ELSE
                                          LET tag = tag + 1
                                          LET g_item[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item[tag].sure="Y"
                                       END IF
                         
                                     EXIT FOR
                                   END IF
                                END IF
                              END FOR
                           END FOR 
                           LET l_pageheader = "N"
                         END IF
                     END IF
                     IF l_pageheader == "N" THEN
                        FOR k = 1 to g_item.getLength()
                          IF g_item[k].zaa05 IS NOT NULL THEN
                            LET a = g_item[k].zaa15
                            LET b = g_item[k].zaa07
                            LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                            LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                            LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                            LET g_item_sort[a,b].column=g_item[k].column-g_item_sort[k,1].column
                            LET g_item_sort[a,b].sure=g_item[k].sure
                            LET g_item_sort[a,b].zaa14 = g_item[k].zaa14 #MOD-580063
                          END IF
                        END FOR
                        FOR a = 1 to g_line_seq
                           FOR b = 1 to g_item_sort[a].getLength()
                             IF g_item_sort[a,b].zaa05 IS NULL THEN
                                  CALL g_item_sort[a].deleteElement(b)
                             END IF
                           END FOR
                        END FOR
                        ## 判斷一行小計，不能上下移動，只能左右 
                        IF (g_print_name.subString(1,1)="s") AND (g_print_start=g_print_int) THEN
                           FOR a = 1 to g_line_seq
                              IF g_print_start <> a THEN
                                 FOR b = 1 to g_item_sort[a].getLength()
                                     IF g_item_sort[a,b].zaa08 IS NOT NULL THEN
                                        LET g_item_sort[g_print_start,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED
                                        LET g_item_sort[g_print_start,b].zaa05 = g_item_sort[a,b].zaa05
                                     END IF
                                 END FOR
                              END IF
                           END FOR
                        END IF
                        ## 組l_str 
                        FOR a = g_print_start to g_print_int
                          IF a <> g_print_start THEN
                                 LET l_str = "<TR height=22>",l_str   #No.FUN-A90047
                          END IF
                          LET l_print_cnt = 0                         #FUN-570052
                          FOR b = 1 to g_item_sort[a].getLength()
                             IF g_item_sort[a,b].zaa06 = 'N' THEN
                                #TQC-6C0088
                                #IF g_zaa13_value = "N" THEN
                                #   LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08)
                                #   ### MOD-580150 ###
                                #   LET column_cnt = g_item_sort[a,b].zaa05 - str_cnt 
                                #   ### MOD-580150 ###
                                #   FOR j = 1 to column_cnt
                                #      #LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED, "&nbsp;"  #echo 
                                #       LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED                   ##MOD-5A0152
                                #   END FOR
                                #END IF
                                #END TQC-6C0088
                                #FUN-660179
                                #FUN-6B0006---start--- 
                                #IF g_aza.aza66 = 2 AND (g_print_name.subString(1,1) != "h") THEN 
                                #   LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08)
                                #   IF str_cnt > g_item_sort[a,b].zaa05 THEN
                                #         LET g_item_sort[a,b].zaa08 = ""
                                #         FOR j = 1 to g_item_sort[a,b].zaa05
                                #             LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08, "#"
                                #         END FOR
                                #   END IF
                                #END IF
                                #FUN-6B0006---end--- 
                                #END FUN-660179
                                IF (g_item_sort[a,b].zaa08 IS NULL) OR (g_item_sort[a,b].zaa08 = " ") THEN
                                  LET g_item_sort[a,b].zaa08 = "&nbsp;"
                                END IF
                                #FUN-670044
                                #IF g_item_sort[a,b].zaa14 MATCHES "[JKNOPQR]" THEN
                                #      #TQC-6A0067 
                                #      IF FGL_WIDTH(g_item_sort[a,b].zaa08 CLIPPED) > 255 THEN
                                #         LET l_str = l_str CLIPPED,"<TD>", g_item_sort[a,b].zaa08 CLIPPED,"</TD>"     #FUN-580019
                                #      ELSE
                                #         LET l_str = l_str CLIPPED,"<TD class=xl24>",  g_item_sort[a,b].zaa08 CLIPPED,"</TD>" #FUN-580019
                                #      END IF
                                #      #END TQC-6A0067 
                                #ELSE
                                #      LET l_str = l_str CLIPPED,"<TD>",  g_item_sort[a,b].zaa08 CLIPPED,"</TD>" #FUN-580019
                                #END IF
                                #No.FUN-6A0159 --start--
                                IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱
                                   #TQC-6C0088
                                   #CASE 
                                   #    WHEN g_item_sort[a,b].zaa14 MATCHES '[JKNOPQR]'
                                   #        IF FGL_WIDTH(g_item_sort[a,b].zaa08 CLIPPED) <= 255 THEN
                                   #            LET l_td_attr = " class=124"
                                   #        END IF
                                   #    WHEN g_item_sort[a,b].zaa14 MATCHES '[EF]'
                                   #        LET l_td_attr = " class=130"
                                   #    OTHERWISE
                                   #        LET l_td_attr = ""
                                   #END CASE
                                   LET l_td_attr = " class=xl24"
                                   IF g_item_sort[a,b].zaa14 MATCHES '[ABCDEFQ]' THEN
                                       LET l_td_attr = l_td_attr," align=center"
                                   ELSE
                                       LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08)
                                       LET column_cnt = g_item_sort[a,b].zaa05 - str_cnt + 1 
                                       FOR j = 1 to column_cnt
                                          LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED,"&nbsp;"   #MOD-5A0152 
                                       END FOR
                                   END IF
                                   LET l_str = l_str CLIPPED,"<TD",l_td_attr,">",  cl_add_span(g_item_sort[a,b].zaa08) ,"</TD>"  #CHI-B30026 
                                   #END TQC-6C0088
                                ELSE
                                   CASE 
                                    WHEN g_item_sort[a,b].zaa14 = 'J' OR g_item_sort[a,b].zaa14 = 'K' OR
                                         g_item_sort[a,b].zaa14 = 'N' OR g_item_sort[a,b].zaa14 = 'O' OR
                                         g_item_sort[a,b].zaa14 = 'P' OR g_item_sort[a,b].zaa14 = 'Q' OR
                                         g_item_sort[a,b].zaa14 = 'R'
                                        #No.CHI-960073 -- start --
                                        #FUN-780064 
                                        #CALL l_bufstr.clear()
                                        #CALL l_bufstr.append(g_item_sort[a,b].zaa08 CLIPPED)
                                        #CALL l_bufstr.replace(" ","&nbsp;",0)
                                        #LET g_item_sort[a,b].zaa08 = l_bufstr.tostring()
                                        #END FUN-780064 
                                        #TQC-6A0067
                                        IF FGL_WIDTH(g_item_sort[a,b].zaa08 CLIPPED) > 255 THEN
                                           LET l_str = l_str CLIPPED,"<TD>", cl_add_span(g_item_sort[a,b].zaa08),"</TD>" #CHI-B30026 
                                        ELSE
                                           LET l_str = l_str CLIPPED,"<TD class=xl24>", cl_add_span(g_item_sort[a,b].zaa08),"</TD>"    #CHI-B30026 
                                        END IF
                                        #END TQC-6A0067
                                        #No.CHI-960073 -- end --

                                   #FUN-A90058 -- start --
                                   #FUN-950066 -- start --
                                   WHEN g_item_sort[a,b].zaa14 MATCHES '[ABCDEF]'
                                        LET l_value_len = FGL_WIDTH(g_item_sort[a,b].zaa08 CLIPPED)
                                        LET l_zaa08_value = g_item_sort[a,b].zaa08 CLIPPED
                                        LET l_dec_point = l_zaa08_value.getIndexOf(".",1)

                                        IF l_dec_point > 0 THEN
                                           LET l_dec = l_value_len - l_dec_point
                                           IF l_dec >= 10 THEN
                                              IF g_item_sort[a,b].zaa14 MATCHES '[ABDEF]' THEN   #單價、金額、總計
                                                 LET l_class_id = "xl60"
                                              ELSE
                                                 LET l_class_id = "xl40"
                                              END IF
                                           ELSE
                                              IF g_item_sort[a,b].zaa14 MATCHES '[ABDEF]' THEN   #單價、金額、總計
                                                 LET l_class_id = "xl5", l_dec USING '<<<<<<<<<<'
                                              ELSE
                                                 LET l_class_id = "xl3", l_dec USING '<<<<<<<<<<'
                                              END IF
                                           END IF
                                        ELSE
                                           IF g_item_sort[a,b].zaa14 MATCHES '[ABDEF]' THEN   #單價、金額、總計
                                              LET l_class_id = "xl50"
                                           ELSE
                                              LET l_class_id = "xl30"
                                           END IF
                                        END IF
                                        LET l_str = l_str CLIPPED,"<TD class=",l_class_id,">",  l_zaa08_value.trim(), "</TD>"   #CHI-B30026 
                                   #FUN-950066 -- end --
                                   #FUN-A90058 -- end --

                                    OTHERWISE
                                         LET l_str = l_str CLIPPED,"<TD>", cl_add_span(g_item_sort[a,b].zaa08),"</TD>"  #CHI-960073  #CHI-B30026 
                                   END CASE
                                END IF
                                #No.FUN-6A0159 --end--
                                #END FUN-670044
                                LET l_print_cnt = l_print_cnt + 1             #FUN-570052
                             END IF
                          END FOR
                          FOR k = 1 to g_view_cnt-l_print_cnt              #FUN-570052
                                  LET l_str = l_str CLIPPED,"<TD>&nbsp;</TD>"   #FUN-580019
                          END FOR
                          LET l_str = l_str CLIPPED,"</TR>"
                          CALL l_channel.write(l_str)
                          LET cnt=cnt+1
                          LET l_str = ""
                        END FOR
                 
                     END IF
                 END IF
                 IF (l_str = "<TR height=22>") THEN    #No.FUN-A90047
                    LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;</TD></TR>"   #No.FUN-A90047  #CHI-B30026 
                 END IF
                 IF l_pageheader == "Y" THEN
                    CALL l_channel.write(l_str)
                    LET cnt=cnt+1
                 END IF
                 IF ( cnt > g_pagelen) THEN
                    for k = 1 to g_bottom 
                         LET l_str = "<TR height=22><TD colspan=",g_column_cnt,"> &nbsp;</TD></TR>"   #No.FUN-A90047  #CHI-B30026 
                        CALL l_channel.write(l_str)
                    end for
                    #### 分頁格線 ####
                    LET l_str="</TABLE></div>",
                              "<p></p>"
                    LET l_str=l_str,"<div align=center>",
                             # "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 STYLE=",g_quote,"font-size: 8pt",g_quote," >"
                             "<TABLE border=1 cellSpacing=0 cellPadding=1 STYLE=",g_quote,"font-size: 8pt",g_quote,"  BORDERCOLOR=\"#DFDFDF\">"        #FUN-580019
                    CALL l_channel.write(l_str)
                    LET cnt= 0
                    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                       CALL cl_progressing("process: xml")            #FUN-570141
                    END IF                   ### FUN-570264 ###
                    LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                 END IF
                 LET l_str = ""
                 LET l_i = 0 
                 LET column_cnt = 1
                 LET l_tr = "N"  
                 CALL g_item.clear()
                 CALL g_item2.clear()
                 CALl g_item_sort.clear()
                 LET l_pageheader = "Y"
                 LET g_print_cnt = 0
               END IF
             END IF      
             LET noskip_old = cnt_noskip
           
          WHEN r.getTagName() = "PageTrailer"
            LET n_id_name = "xml"
 
          WHEN r.getTagName() = "PageHeader"
            LET n_id_name = "xml"
 
        END CASE
 
      END CASE
      IF g_print_end IS NULL  THEN
         LET e= r.read()
      END IF
      LET g_print_end = NULL
   END WHILE
#END FUN-570208
 
   CLOSE cl_trans2_curs2                     #FUN-570141
   CALL l_channel.write("</TABLE></div></body></html>")    ##FUN-A90047
   CALL l_channel.close()

   CALL cl_trans_excel_replace_tags(output_name)  #CHI-D20019
END FUNCTION
#END MOD-580063
 
##################################################
# Descriptions...: 多行抬頭 word2格式
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_word2()   #MOD-580063
DEFINE  output_type,l_pageheader,l_tr           LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        l_channel                               base.Channel,
        cnt_print,cnt_item,i,j,a,b,noskip_old   LIKE type_file.num10,       #No.FUN-690005 integer,
        l_str,value,value_trim,l_cmd            string,
        n_name,l_skip_tag                       string,
        k,column_cnt,cnt_noskip,l_start_i       LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        tag,tag2,cnt,str_cnt,l_i                LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        str_center                              LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        l_print_cnt                             LIKE type_file.num5        #No.FUN-690005 SMALLINT   #FUN-570052
DEFINE  l_bufstr                                base.StringBuffer  #TQC-650109
 
DEFINE l_td_attr STRING #No.FUN-6A0159
 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
   LET l_str = ""

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --
 
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(output_name,"a" )
   CALL l_channel.setDelimiter("")
  
   #FUN-570141
    LET g_sql = "SELECT zaa02 FROM zaa_file ",
   " where zaa01= '", g_prog ,"' AND zaa09='1'", 
   " AND zaa04 = '",g_zaa04_value,"' AND zaa10 = '",
     g_zaa10_value,"' AND zaa11='",g_zaa11_value,"'",
   " AND zaa17 = '",g_zaa17_value,"'"
    PREPARE cl_trans3_prepare2 FROM g_sql           #預備一下
    DECLARE cl_trans3_curs2 CURSOR FOR cl_trans3_prepare2
   #END FUN-570141
 
 ## 讀取報表資料
   CALL cl_trans_column(column_cnt) RETURNING l_str
   CALL l_channel.write(l_str)
   LET l_str = ""
  #FUN-570208
   LET column_cnt = 1
   LET l_tr = "N"  
   LET l_pageheader = "Y"                 #FUN-5A0135
 
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
    CASE e
      WHEN "StartElement"
        CASE
          WHEN r.getTagName() = "PageTrailer"
             LET n_id_name = "PageTrailer"
 
          WHEN r.getTagName() = "PageHeader"
             LET n_id_name = "PageHeader"
 
          WHEN r.getTagName() = "Print"
             LET n_name = r.getTagName()
             LET cnt_noskip = 0
             LET g_print_name = lsax_attrib.getValue("name")
             IF (g_print_cnt = 0) AND (g_print_name IS NOT NULL)THEN
                IF noskip_old = 0 THEN          
                      LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                      LET g_print_num = g_print_int
                      #MOD-580299
                      IF g_line_seq > 1 THEN
                         FOR k = 1 to g_print_num-1
                             LET l_i = l_i + g_report_cnt[k]
                         END FOR
                      END IF
                      #END MOD-580299
                      LET l_start_i = l_i + 1
                END IF
             END IF
 
          WHEN r.getTagName() = "Item"
             LET value = lsax_attrib.getValue("value")
             #TQC-650109
             CALL l_bufstr.clear()
             CALL l_bufstr.append(value)
             IF NOT cl_null(value) THEN
                CALL l_bufstr.replace("<","&lt;",0)
             END IF
             LET value = l_bufstr.tostring()
             #END TQC-650109
 
             ### 公司名稱 合併
             IF value = g_company AND n_id_name == "PageHeader" THEN   #FUN-690088
                 LET l_str = "<TR height=22><TD NOWRAP bgcolor=#FFCC99 colspan=",g_column_cnt," align=center >",cl_add_span(value)   #No.FUN-A90047  #CHI-B30026 
                 LET l_tr = "Y"
                 LET l_pageheader= "Y"     
                 EXIT CASE
             END IF
             
             #TQC-710026
             #動態報表名稱
             IF g_print_name = "rep_name" THEN
                 LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(value),"</TD></TR>"   #No.FUN-A90047  #CHI-B30026 
                 LET l_tr = "Y"
                 LET l_pageheader= "Y"     
                 EXIT CASE
             END IF
             #TQC-710026
 
             ### 空白行 
             #LET value_trim = value.trim()
             #IF (g_print_name IS NULL) AND (cnt_item = 1) AND (value_trim.equals("") ) THEN       
             #   LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt,">&nbsp;"    #CHI-B30026 
             #    LET l_tr = "Y"
             #   LET l_pageheader= "Y"     
             #   EXIT CASE
             #END IF
             ### 虛線不列印
             #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED)) OR (value.equals(g_dash2 CLIPPED))THEN       
             IF (value = g_dash1) OR (value = g_dash_out) OR (value = g_dash2_out)THEN   #TQC-6A0113
                LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt,">&nbsp;"   #No.FUN-A90047  #CHI-B30026 
                 LET l_tr = "Y"
                LET l_pageheader= "Y"     
                EXIT CASE
             END IF
 
             #FUN-690088
             #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
             #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
             #THEN
             #   LET value = g_dash CLIPPED
             #   LET l_str = "<TR height=22><TD NOWRAP colspan=",g_view_cnt ,"><PRE style=",g_quote,"line-height:9.0pt;mso-line-height-rule:exactly",g_quote,"><span style='font-size:8.0pt'> &nbsp;"
             #   LET l_tr = "Y"
             #   LET l_pageheader= "Y"     
             #   EXIT CASE
             #END IF
             #END FUN-690088
 
              IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱
                LET j = l_i + 1
                LET g_xml_value = value
                #FUN-570052
                LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                #TQC-5B0170
                IF g_zaa_dyn.getLength() > 0 THEN
                   LET g_item[j].zaa08 = g_zaa_dyn[g_page_cnt,g_xml_value]
                ELSE
                   LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                END IF
                #END TQC-5B0170
 
                LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                LET g_item[j].column = g_c[g_xml_value]
                #END FUN-570052
 
                LET l_i = l_i + 1
                LET l_pageheader = "N"
             ELSE
                IF (g_print_name IS NULL ) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                   IF (cnt < 3+g_top) THEN               #TQC-710026
                        IF l_str.trim() = " " THEN
                             LET l_str = value
                        ELSE
                             LET l_str = l_str,value
                        END IF
                   ELSE 
                        LET l_str = l_str,value
                   END IF
                   LET l_pageheader= "Y"     
                ELSE
                    IF l_i = 0 THEN  
                      LET l_i = l_i + 1
                    ELSE
                      IF g_item2[l_i].zaa08 IS NOT NULL THEN
                           LET value = g_item2[l_i].zaa08 CLIPPED,value
                      END IF
                    END IF
                    LET g_item2[l_i].zaa08 = value CLIPPED              ### item value
                    LET g_item2[l_i].column = column_cnt
                    LET l_pageheader= "N"
                END IF
             END IF
 
          WHEN r.getTagName() = "Column"
             LET value = lsax_attrib.getValue("value")
             LET column_cnt = value
             IF (g_print_name IS NULL) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                 LET str_cnt = FGL_WIDTH(l_str)
                 LET column_cnt = column_cnt - str_cnt - 1
                 #FUN-810047
                 #FOR j = 1 to column_cnt
                 #      LET l_str = l_str," "
                 #END FOR
                 LET l_str = l_str, column_cnt SPACES
                 #END FUN-810047
             ELSE
                 LET l_i = l_i + 1               #
             END IF
 
          WHEN r.getTagName() = "NoSkip"
             LET cnt_noskip = 1
 
        END CASE
 
      WHEN "EndElement"
        CASE
          WHEN r.getTagName() = "Print"
             IF ( cnt_noskip = 0 ) THEN
                IF (g_print_name IS NOT NULL) THEN
                   LET lsax_attrib = r.getAttributes()
                   LET e = r.read()
                   LET g_print_end = "Y"
                   LET g_next_name = lsax_attrib.getValue("name")
                   LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                   LET g_print_num = g_print_int
                   LET g_print_cnt = g_print_cnt + 1 
                   IF (g_print_name.subString(1,1)=g_next_name.subString(1,1)) THEN
                         LET g_next_int = g_next_name.subString(2,g_next_name.getLength())
                         LET g_next_num = g_next_int
                         IF g_next_num = g_print_num + 1 THEN
                            IF g_print_cnt = 1 THEN
                                #MOD-580299
                                IF g_line_seq = 1 AND g_print_num > 1 THEN
                                    LET g_print_start = 1
                                    LET g_print_int = 1
                                ELSE
                                    LET g_print_start = g_print_num
                                END IF
                                #END MOD-580299
                            END IF
                            LET g_print_end = "N"
                         ELSE
                             IF g_print_cnt = 1 THEN
                                #MOD-580299
                                IF g_line_seq = 1 AND g_print_num > 1 THEN
                                    LET g_print_start = 1
                                    LET g_print_int = 1
                                ELSE
                                    LET g_print_start = g_print_num
                                END IF
                                #END MOD-580299
                             END IF
                         END IF
                   ELSE
                         IF g_print_cnt = 1 THEN
                             #MOD-580299
                             IF g_line_seq = 1 AND g_print_num > 1 THEN
                                 LET g_print_start = 1
                                 LET g_print_int = 1
                             ELSE
                                 LET g_print_start = g_print_num
                             END IF
                             #END MOD-580299
                         END IF
                   END IF
               END IF
               IF ( g_print_end ="Y" ) OR g_print_name IS NULL THEN
                   ###表頭、表尾資料合併，除了表頭欄位內容
                   IF l_tr = "N" THEN
                     IF (g_print_name IS NULL) # OR (g_body_title_pos - 1 <> cnt) AND (n_id_name == "PageHeader") 
                       OR (n_id_name == "PageTrailer") THEN
           
                       LET str_center = "N"
                       IF n_id_name == "PageHeader" THEN
                         IF (cnt < 3+g_top) AND (NOT l_str.equals(g_company)) THEN    #TQC-710026
                           #No.FUN-810047
                           #OPEN cl_trans3_curs2                         #FUN-57
                           #FOREACH cl_trans3_curs2 INTO g_xml_value
                           #     IF l_str.equals(g_x[g_xml_value]) THEN
                           #        LET str_center = "Y"
                           #        EXIT FOREACH
                           #     END IF
                           #END FOREACH
                           FOR j = 1 TO g_zaa02.getLength()
                               IF l_str.equals(g_x[g_zaa02[j]]) THEN
                                  LET str_center = "Y"
                                  EXIT FOR
                               END IF
                           END FOR
                           #END No.FUN-810047
                         END IF
                       END IF
                       IF str_center = "Y" THEN
                           LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt," align=center>",cl_add_span(l_str),"&nbsp;"       #FUN-580019  #No.FUN-A90047 #CHI-B30026 
                       ELSE 
                           LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt," >",cl_add_span(l_str),"&nbsp;"   #No.FUN-A90047  #CHI-B30026 
                       END IF
                     ELSE
                       LET l_str = "<TR height=22>",l_str    #No.FUN-A90047
                     END IF
                   END IF
                   #TQC-6A0113
                   #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR
                   #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED)) THEN
                   IF (l_pageheader = "Y" ) OR (l_str=g_dash_out) OR
                      (l_str = g_dash1) OR (l_str = g_dash2_out) THEN
                   #END TQC-6A0113
 
                      IF (l_pageheader = "Y") THEN
                            LET l_str = l_str ,"</TD></TR>"  #CHI-B30026 
                      END IF
                 
                   ELSE
                      IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱   #CHI-760015
                          LET l_pageheader = "N"
                      ELSE 
                        IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                           FOR j = 1 to g_value.getLength()   
                             LET g_xml_value = g_value[j].zaa02    
                          #FUN-570052
                             LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                             LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                             LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                             LET g_item[j].zaa08 = ""
                             LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                             LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                             LET g_item[j].column = g_c[g_xml_value]
                           END FOR
                          #END FUN-570052
           
                           CALL g_item_sort.clear()
                           FOR k = 1 to g_item.getLength()#資料排序
                             IF g_item[k].zaa05 IS NOT NULL THEN
                               LET a = g_item[k].zaa15
                               LET b = g_item[k].zaa07
                               LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                               LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                               LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort[a,b].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item_sort[a,b].column=g_item[k].column
                               LET g_item_sort[a,b].sure=g_item[k].sure
                             END IF
                           END FOR
                           CALL g_item.clear()
                           LET k = 0
                           FOR a = 1 to g_line_seq
                             FOR b = 1 to g_item_sort[a].getLength()
                              IF g_item_sort[a,b].zaa05 IS NOT NULL THEN
                                LET k = k + 1
                                LET g_item[k].zaa05 =g_item_sort[a,b].zaa05
                                LET g_item[k].zaa06 =g_item_sort[a,b].zaa06
                                LET g_item[k].zaa08 =g_item_sort[a,b].zaa08 CLIPPED
                                LET g_item[k].zaa14 =g_item_sort[a,b].zaa14 CLIPPED #No.FUN-6A0159
                                LET g_item[k].zaa07 = b
                                LET g_item[k].zaa15 = a
                                LET g_item[k].column=g_item_sort[a,b].column
                                LET g_item[k].sure  =g_item_sort[a,b].sure
                              END IF
                             END FOR
                           END FOR
                           LET tag = 0
                           LEt tag2 = 0
                           FOR k = l_start_i TO g_item2.getLength()
                              #TQC-6B0006
                              IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                                CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                                LET INT_FLAG = 1
                                RETURN
                              END IF
                              #END TQC-6B0006
                              LET g_cnt = g_item.getLength() #TQC-950138
                              FOR j = 1 to g_cnt             #TQC-950138                              
                                IF (j = g_item.getLength()) AND (g_item2[k].column > g_item[j].column-1) THEN
                                   LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                   EXIT FOR
                         
                                ELSE
                                   IF (g_item2[k].column > g_item[j].column-1) AND 
                                      (g_item2[k].column < g_item[j+1].column) THEN
                                      IF (g_item[j].sure IS NULL) OR (g_item[j].sure = "") THEN
                                          LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item[j].sure="Y"
                                          LET tag = j
                                      ELSE
                                          LET tag = tag + 1
                                          LET g_item[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item[tag].sure="Y"
                                       END IF
                         
                                     EXIT FOR
                                   END IF
                                END IF
                              END FOR
                           END FOR 
                           LET l_pageheader = "N"
                         END IF
                     END IF
                     IF l_pageheader == "N" THEN
                        FOR k = 1 to g_item.getLength()
                          IF g_item[k].zaa05 IS NOT NULL THEN
                            LET a = g_item[k].zaa15
                            LET b = g_item[k].zaa07
                            LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                            LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                            LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                            LET g_item_sort[a,b].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                            LET g_item_sort[a,b].column=g_item[k].column-g_item_sort[k,1].column
                            LET g_item_sort[a,b].sure=g_item[k].sure
                          END IF
                        END FOR
                        FOR a = 1 to g_line_seq
                           FOR b = 1 to g_item_sort[a].getLength()
                             IF g_item_sort[a,b].zaa05 IS NULL THEN
                                  CALL g_item_sort[a].deleteElement(b)
                             END IF
                           END FOR
                        END FOR
                        ## 判斷一行小計，不能上下移動，只能左右 
                        IF (g_print_name.subString(1,1)="s") AND (g_print_start=g_print_int) THEN
                           FOR a = 1 to g_line_seq
                              IF g_print_start <> a THEN
                                 FOR b = 1 to g_item_sort[a].getLength()
                                     IF g_item_sort[a,b].zaa08 IS NOT NULL THEN
                                        LET g_item_sort[g_print_start,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED
                                        LET g_item_sort[g_print_start,b].zaa05 = g_item_sort[a,b].zaa05
                                     END IF
                                 END FOR
                              END IF
                           END FOR
                        END IF
                        ## 組l_str 
                        FOR a = g_print_start to g_print_int
                          IF a <> g_print_start THEN
                                 LET l_str = "<TR height=22>",l_str   #No.FUN-A90047
                          END IF
                          LET l_print_cnt = 0                         #FUN-570052
                          FOR b = 1 to g_item_sort[a].getLength()
                             IF g_item_sort[a,b].zaa06 = 'N' THEN
                                IF (g_zaa13_value = "N" ) OR
                                   (g_print_name.subString(1,1)="h")  #TQC-5B0055
                                THEN
                                   LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08)
                                   ### MOD-580150 ###
                                   LET column_cnt = g_item_sort[a,b].zaa05 - str_cnt 
                                   ### MOD-580150 ###
                                   LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED      #TQC-5B0055
                                    #No.FUN-6A0159 --start--
                                   IF NOT ((g_print_name.subString(1,1)="h") AND
                                    (g_item_sort[a,b].zaa14 MATCHES '[ABCDEFQ]'))
                                   THEN
                                      ##FUN-810047
                                      #FOR j = 1 to column_cnt
                                      #   #LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED, "&nbsp;"  #echo 
                                      #   LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 , " "   #TQC-5B0055
                                      #END FOR
                                      LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08 , column_cnt SPACES   #TQC-5B0055
                                      #END FUN-810047
                                   END IF
                                   #No.FUN-6A0159 --end--
                                END IF
                                #FUN-660179 
                                ##FUN-6B0006---start--- 
                                #IF g_aza.aza66 = 2 AND (g_print_name.subString(1,1) != "h") THEN 
                                #   LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08)
                                #   IF str_cnt > g_item_sort[a,b].zaa05 THEN
                                #         LET g_item_sort[a,b].zaa08 = ""
                                #         FOR j = 1 to g_item_sort[a,b].zaa05
                                #             LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08, "#"
                                #         END FOR
                                #   END IF
                                #END IF
                                ##FUN-6B0006---end--- 
                                #END FUN-660179 
                                IF (g_item_sort[a,b].zaa08 IS NULL) OR (g_item_sort[a,b].zaa08 = " ") 
                                   AND (g_print_name.subString(1,1)="h")  ##TQC-5B0170 
                                THEN
                                  #LET g_item_sort[a,b].zaa08 = "&nbsp;"
                                  LET g_item_sort[a,b].zaa08 = " "   #TQC-5B0055    
                                END IF
                                #LET l_str = l_str CLIPPED,"<TD NOWRAP STYLE=",g_quote,"border:none;border-bottom:solid windowtext 1.0pt; padding:.75pt .75pt .75pt .75pt; border-bottom-width: 1",g_quote," >",  cl_add_span(g_item_sort[a,b].zaa08),"</TD>"  #CHI-B30026 
                                #No.FUN-6A0159 --start--
                                IF (g_print_name.subString(1,1)="h") AND
                                   (g_item_sort[a,b].zaa14 MATCHES '[ABCDEFQ]')
                                THEN       # 報表欄位名稱
                                    LET l_str = l_str CLIPPED,"<TD NOWRAP align=center>",  cl_add_span(g_item_sort[a,b].zaa08) ,"</TD>"   #FUN-580019   #TQC-5B0055 #CHI-B30026 
                                ELSE
                                    LET l_str = l_str CLIPPED,"<TD NOWRAP >",  cl_add_span(g_item_sort[a,b].zaa08) ,"</TD>" #FUN-580019   #TQC-5B0055 #CHI-B30026 
                                END IF
                                #No.FUN-6A0159 --end--
                                LET l_print_cnt = l_print_cnt + 1             #FUN-570052
                             END IF
                          END FOR
                          FOR k = 1 to g_view_cnt-l_print_cnt              #FUN-570052
                                  LET l_str = l_str CLIPPED,"<TD NOWRAP >&nbsp;</TD>"   #FUN-580019  #CHI-B30026 
                          END FOR
                          LET l_str = l_str CLIPPED,"</TR>"
                          CALL l_channel.write(l_str)
                          LET cnt=cnt+1
                          LET l_str = ""
                        END FOR
                 
                     END IF
                 END IF
                 IF (l_str = "<TR height=22>") THEN   #No.FUN-A90047
                    LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt,"> &nbsp;</TD></TR>"  #No.FUN-A90047  #CHI-B30026 
                 END IF
                 IF l_pageheader == "Y" THEN
                    CALL l_channel.write(l_str)
                    LET cnt=cnt+1
                 END IF
                 IF ( cnt > g_pagelen) THEN
                    for k = 1 to g_bottom 
                         LET l_str = "<TR height=22><TD NOWRAP colspan=",g_column_cnt,"> &nbsp;</TD></TR>"   #No.FUN-A90047  #CHI-B30026 
                        CALL l_channel.write(l_str)
                    end for
                    #### 分頁格線 ####
                    LET l_str="</TABLE></div>",
                               "<p class=MsoNormal align=center style='text-align:center;line-height:9.0pt;",
                               "mso-line-height-rule:exactly'><span lang=EN-US style='font-size:8.0pt;",
                               "mso-bidi-font-size:12.0pt;display:none;mso-hide:all'><![if !supportEmptyParas]>&nbsp;<![endif]><o:p></o:p></span></p>",
                               "<span lang=EN-US style='font-size:8.0pt;mso-bidi-font-size:12.0pt;font-family:新細明體;mso-bidi-font-family:",
                               g_quote,"Times New Roman",g_quote,";mso-ansi-language:EN-US;mso-fareast-language:ZH-TW;",
                               "mso-bidi-language:AR-SA'><br clear=all style='mso-special-character:line-break;",
                               "page-break-before:always'>",
                               "</span>",
                               "<p class=MsoNormal style='line-height:9.0pt;",
                               "mso-line-height-rule:exactly'><![if !supportEmptyParas]>&nbsp;<![endif]><span ",
                               "lang=EN-US style='font-size:8.0pt;mso-bidi-font-size:12.0pt'><o:p></o:p></span></p> "
                    LET l_str=l_str,"<div align=center>",
                             # "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 STYLE=",g_quote,"font-size: 8pt",g_quote," >"
                             "<TABLE border=1 cellSpacing=0 cellPadding=1 STYLE=",g_quote,"font-size: 8pt",g_quote,"  BORDERCOLOR=\"#DFDFDF\">"        #FUN-580019
                    CALL l_channel.write(l_str)
                    LET cnt= 0
                    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                       CALL cl_progressing("process: xml")            #FUN-570141
                    END IF                   ### FUN-570264 ###
                    LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170                    
                 END IF
                 LET l_str = ""
                 LET l_i = 0 
                 LET column_cnt = 1
                 LET l_tr = "N"  
                 CALL g_item.clear()
                 CALL g_item2.clear()
                 CALl g_item_sort.clear()
                 LET l_pageheader = "Y"
                 LET g_print_cnt = 0
               END IF
             END IF      
             LET noskip_old = cnt_noskip
           
          WHEN r.getTagName() = "PageTrailer"
            LET n_id_name = "xml"
 
          WHEN r.getTagName() = "PageHeader"
            LET n_id_name = "xml"
 
        END CASE
 
      END CASE
      IF g_print_end IS NULL  THEN
         LET e= r.read()
      END IF
      LET g_print_end = NULL
   END WHILE
   #END FUN-570208
 
   CLOSE cl_trans3_curs2                     #FUN-570141
   CALL l_channel.write("</TABLE></div></body></html>")    ##FUN-A90047
   CALL l_channel.close()
 
END FUNCTION
 
##################################################
# Descriptions...: 多行表格 xml轉成 txt
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_txt2()
DEFINE l_channel                             base.Channel,
       l_str,output_name,l_cmd,n_name        STRING,
       cnt_print,value,column,l_dash         STRING,
       i,j,k,b,a,column_cnt,l_start_i        LIKE type_file.num10,       #No.FUN-690005 INTEGER,
       cnt_item,tag,tag2,cnt_noskip          LIKE type_file.num10,       #No.FUN-690005 INTEGER,
       l_str1,l_dash2                        STRING,
       cnt,str_cnt,l_pos,l_i                 LIKE type_file.num10,       #No.FUN-690005 INTEGER,
       noskip_old                            LIKE type_file.num10,       #No.FUN-690005 INTEGER,
       l_pageheader                          LIKE type_file.chr1        #No.FUN-690005  VARCHAR(1)
 
DEFINE l_pre_spaces LIKE type_file.num10 #No.FUN-6A0159
 
   LET cnt = 0
   LET l_str = g_xml_name CLIPPED
   LET output_name = l_str.substring(1,l_str.getlength()-4)

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --

   LET l_str = ""
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(output_name,"a" )
   CALL l_channel.setDelimiter("")
 
 ## 讀取報表資料
   #FUN-570208
   LET column_cnt = 1
   LET l_pageheader = "Y"                      #pageheader的tag
 
   #FUN-570208
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
    CASE e
      WHEN "StartElement"
        CASE
          WHEN r.getTagName() = "PageTrailer"
             LET n_id_name = "PageTrailer"
 
          WHEN r.getTagName() = "PageHeader"
             LET n_id_name = "PageHeader"
 
          WHEN r.getTagName() = "Print"
             LET n_name = r.getTagName()
             LET cnt_noskip = 0
             LET g_print_name = lsax_attrib.getValue("name")
             IF (g_print_cnt = 0) AND (g_print_name IS NOT NULL)THEN
                IF noskip_old = 0 THEN
                  LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                  LET g_print_num = g_print_int
                  #MOD-580299
                  IF g_line_seq > 1 THEN
                     FOR k = 1 to g_print_num-1
                         LET l_i = l_i + g_report_cnt[k]
                     END FOR
                  END IF
                  #END MOD-580299
                  LET l_start_i = l_i + 1
                END IF
             END IF
 
          WHEN r.getTagName() = "Item"
             LET value = lsax_attrib.getValue("value")
             IF (g_print_name.subString(1,1)="h") THEN
               LET j = l_i + 1
               #FUN-570052
               LET g_item[j].zaa05= g_zaa[value].zaa05 CLIPPED 
               LET g_item[j].zaa06= g_zaa[value].zaa06 CLIPPED 
               LET g_item[j].zaa07= g_zaa[value].zaa07 CLIPPED 
               #TQC-5B0170
               IF g_zaa_dyn.getLength() > 0 THEN
                  LET g_item[j].zaa08 = g_zaa_dyn[g_page_cnt,value]
               ELSE
                  LET g_item[j].zaa08= g_zaa[value].zaa08 CLIPPED
               END IF
               #END TQC-5B0170
               
               #No.FUN-6A0159 --start--
               LET g_item[j].zaa14= g_zaa[value].zaa14 CLIPPED
               IF g_item[j].zaa14 MATCHES '[ABCDEFQ]' THEN
                  LET l_pre_spaces = (g_item[j].zaa05 - FGL_WIDTH(g_item[j].zaa08 CLIPPED)) / 2
                  IF l_pre_spaces > 0 then
                     LET g_item[j].zaa08 = l_pre_spaces SPACES || g_item[j].zaa08 CLIPPED
                  END IF
               END IF
               #No.FUN-6A0159 --end--
 
               LET g_item[j].zaa15= g_zaa[value].zaa15 CLIPPED 
               LET g_item[j].column = g_c[value]
               #END FUN-570052
 
               LET l_i = l_i + 1
             ELSE
                #IF value.equals(g_dash1) THEN       #重新計算g_dash1
                IF value = g_dash1 THEN       #重新計算g_dash1 #TQC-6A0113
                    #MOD-570371
                   FOR j = 1 TO g_value.getLength()
                       LET g_xml_value = g_value[j].zaa02
                       LET g_item[j].zaa05= g_zaa[g_xml_value].zaa05 CLIPPED
                       LET g_item[j].zaa06= g_zaa[g_xml_value].zaa06 CLIPPED
                       LET g_item[j].zaa07= g_zaa[g_xml_value].zaa07 CLIPPED
                       LET g_item[j].zaa08= g_dash2[1,g_item[j].zaa05] CLIPPED
                       LET g_item[j].zaa15= g_zaa[g_xml_value].zaa15 CLIPPED
                       LET g_item[j].zaa14= g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                   END FOR
                   LET l_pageheader= "N"
                   LET g_print_start = g_dash_num         #TQC-5A0082 #TQC-5B0007 
                   LET g_print_int = g_dash_num           #TQC-5A0082 #TQC-5B0007
 
                    #END MOD-570371
                ELSE
                   IF (g_print_name IS NULL) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                        LET l_str = l_str,value
                        LET l_pageheader= "Y"     
                   ELSE
                     #IF value.equals(g_dash CLIPPED) OR value.equals(g_dash2 CLIPPED) THEN
                     IF (value = g_dash_out) OR (value = g_dash2_out) THEN #TQC-6A0113
                        LET l_str = l_str,value
                        EXIT CASE
                     ELSE
                        IF l_i = 0 THEN  
                          LET l_i = l_i + 1
                        ELSE
                          IF g_item2[l_i].zaa08 IS NOT NULL THEN
                               LET value = g_item2[l_i].zaa08 CLIPPED,value
                          END IF
                        END IF
                        LET g_item2[l_i].zaa08 = value CLIPPED              ### item value
                        LET g_item2[l_i].column = column_cnt         ### item value
                        LET l_pageheader= "N"
                     END IF
                   END IF
                END IF
             END IF
 
          WHEN r.getTagName() = "Column"
             LET value = lsax_attrib.getValue("value")
             LET column_cnt = value
             IF (g_print_name IS NULL) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                 LET str_cnt = FGL_WIDTH(l_str)
                 LET column_cnt = column_cnt - str_cnt - 1
                 #FUN-810047
                 #FOR j = 1 to column_cnt
                 #      LET l_str = l_str," "
                 #END FOR
                 LET l_str = l_str, column_cnt SPACES
                 #END FUN-810047
             ELSE
                 LET l_i = l_i + 1               #
             END IF
 
          WHEN r.getTagName() = "NoSkip"
               LET cnt_noskip = 1
 
        END CASE
 
      WHEN "EndElement"
        CASE
          WHEN r.getTagName() = "Print"
            IF cnt_noskip = 0 THEN
               IF (g_print_name IS NOT NULL) THEN
                  LET lsax_attrib = r.getAttributes()
                  LET e = r.read()
                  LET g_print_end = "Y"
                  LET g_next_name = lsax_attrib.getValue("name")
                  LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                  LET g_print_num = g_print_int
                  LET g_print_cnt = g_print_cnt + 1
                  IF (g_print_name.subString(1,1)=g_next_name.subString(1,1)) THEN
                        LET g_next_int = g_next_name.subString(2,g_next_name.getLength())
                        LET g_next_num = g_next_int
                        IF g_next_num = g_print_num + 1 THEN
                           IF g_print_cnt = 1 THEN
                               #MOD-580299
                               IF g_line_seq = 1 AND g_print_num > 1 THEN
                                   LET g_print_start = 1
                                   LET g_print_int = 1
                               ELSE
                                   LET g_print_start = g_print_num
                               END IF
                               #END MOD-580299
                           END IF
                           LET g_print_end = "N"
                        ELSE
                            IF g_print_cnt = 1 THEN
                                #MOD-580299
                                IF g_line_seq = 1 AND g_print_num > 1 THEN
                                    LET g_print_start = 1
                                    LET g_print_int = 1
                                ELSE
                                    LET g_print_start = g_print_num
                                END IF
                                #END MOD-580299
                            END IF
                       END IF
                  ELSE
                        IF g_print_cnt = 1 THEN
                            #MOD-580299
                            IF g_line_seq = 1 AND g_print_num > 1 THEN
                                LET g_print_start = 1
                                LET g_print_int = 1
                            ELSE
                                LET g_print_start = g_print_num
                            END IF
                            #END MOD-580299
                        END IF
                  END IF
               END IF
               IF ( g_print_end ="Y" ) OR g_print_name IS NULL THEN
                   #TQC-6A0113
                   IF (l_str = g_dash_out) OR (l_str = g_dash2_out) THEN
                      IF (l_str = g_dash_out) THEN
                         LET l_str = g_dash_out
                      ELSE
                         LET l_str = g_dash2_out
                      END IF
                   #END TQC-6A0113
                     LET l_pageheader = "Y"
                  ELSE
                     IF (g_print_name.subString(1,1)="h") THEN
                         LET l_pageheader = "N"
                     ELSE 
                       IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") AND (g_print_name IS NOT NULL) THEN
                          FOR j = 1 to g_value.getLength()   
                            LET g_xml_value = g_value[j].zaa02    
                        #FUN-570052
                            LET g_item[j].zaa05= g_zaa[g_xml_value].zaa05 CLIPPED 
                            LET g_item[j].zaa06= g_zaa[g_xml_value].zaa06 CLIPPED 
                            LET g_item[j].zaa07= g_zaa[g_xml_value].zaa07 CLIPPED 
                            LET g_item[k].zaa08 = ""
                            LET g_item[j].zaa15= g_zaa[g_xml_value].zaa15 CLIPPED
                            LET g_item[j].zaa14= g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159 
                            LET g_item[j].column = g_c[g_xml_value]
                          END FOR
                        #END FUN-570052
         
                          CALL g_item_sort.clear() 
                          FOR k = 1 to g_item.getLength()       #資料排序
                            IF g_item[k].zaa05 IS NOT NULL THEN
                               LET a = g_item[k].zaa15
                               LET b = g_item[k].zaa07
                               LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                               LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                               LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort[a,b].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item_sort[a,b].column=g_item[k].column
                               LET g_item_sort[a,b].sure=g_item[k].sure
                            END IF
                          END FOR
                          CALL g_item.clear()
                          LET k = 0
                          FOR a = 1 to g_line_seq
                            FOR b = 1 to g_item_sort[a].getLength()
                               IF g_item_sort[a,b].zaa05 IS NOT NULL THEN
                                 LET k = k + 1
                                 LET g_item[k].zaa05 =g_item_sort[a,b].zaa05
                                 LET g_item[k].zaa06 =g_item_sort[a,b].zaa06
                                 LET g_item[k].zaa08 =g_item_sort[a,b].zaa08 CLIPPED
                                 LET g_item[k].zaa14 =g_item_sort[a,b].zaa14 CLIPPED #No.FUN-6A0159
                                 LET g_item[k].zaa07 = b
                                 LET g_item[k].zaa15 = a
                                 LET g_item[k].column=g_item_sort[a,b].column
                                 LET g_item[k].sure  =g_item_sort[a,b].sure
                               END IF
                            END FOR
                          END FOR
                          LET tag = 0
                          LEt tag2 = 0
                          FOR k = l_start_i TO g_item2.getLength()
                             #TQC-6B0006
                             IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                               CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                               LET INT_FLAG = 1
                               RETURN
                             END IF
                             #END TQC-6B0006
                             LET g_cnt = g_item.getLength() #TQC-950138
                             FOR j = 1 to g_cnt             #TQC-950138
                               IF (j = g_item.getLength()) AND (g_item2[k].column > g_item[j].column-1) THEN
                                  LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                  EXIT FOR
                               ELSE
                                  IF (g_item2[k].column > g_item[j].column-1) AND 
                                     (g_item2[k].column < g_item[j+1].column) THEN
                                     IF (g_item[j].sure IS NULL) OR (g_item[j].sure = "") THEN
                                         LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                         LET g_item[j].sure="Y"
                                         LET tag = j
                                     ELSE
                                         LET tag = tag + 1
                                         LET g_item[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                         LET g_item[tag].sure="Y"
                                     END IF
                                     EXIT FOR
                                  END IF
                               END IF
                             END FOR
                          END FOR 
                          LET l_pageheader = "N"
                        END IF
                     END IF
                    IF l_pageheader == "N" THEN
                          FOR k = 1 to g_item.getLength()       #資料排序
                            IF g_item[k].zaa15 IS NOT NULL  THEN
                               LET a = g_item[k].zaa15
                               LET b = g_item[k].zaa07
                               LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                               LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                               LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort[a,b].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item_sort[a,b].column=g_item[k].column-g_item_sort[k,1].column + 1
                               LET g_item_sort[a,b].sure=g_item[k].sure
                            END IF
                          END FOR
                          FOR a = 1 to g_line_seq
                             FOR b = 1 to g_item_sort[a].getLength()
                               IF g_item_sort[a,b].zaa05 IS NULL THEN
                                    CALL g_item_sort[a].deleteElement(b)
                               END IF
                             END FOR
                          END FOR
                       ## 判斷一行小計，不能上下移動，只能左右 
                       IF (g_print_name.subString(1,1)="s") AND (g_print_start=g_print_int) THEN
                          FOR a = 1 to g_line_seq
                             IF g_print_start <> a THEN
                                FOR b = 1 to g_item_sort[a].getLength()
                                    IF g_item_sort[a,b].zaa08 IS NOT NULL THEN
                                       LET g_item_sort[g_print_start,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED
                                       LET g_item_sort[g_print_start,b].zaa05 = g_item_sort[a,b].zaa05
                                    END IF
                                END FOR
                             END IF
                          END FOR
                       END IF
                       ## 組l_str 
                       FOR a = g_print_start to g_print_int
                       #FOR a = g_print_start to g_line_seq           #FUN-580019
                         FOR b = 1 to g_item_sort[a].getLength()
                            IF g_item_sort[a,b].zaa06 = 'N' THEN
                               #FUN-6B0006---start--- 
                               IF g_aza.aza66 = 2 AND (g_print_name.subString(1,1) != "h") THEN 
                                  LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08 CLIPPED)
                                  IF str_cnt > g_item_sort[a,b].zaa05 THEN
                                        LET g_item_sort[a,b].zaa08 = ""
                                        FOR j = 1 to g_item_sort[a,b].zaa05
                                            LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08, "#"
                                        END FOR
                                        LET l_str = l_str, g_item_sort[a,b].zaa08 CLIPPED
                                        LET l_str = l_str," "
                                  ELSE
                                        LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08 CLIPPED) 
                                        IF str_cnt > 0 THEN
                                           LET l_str = l_str, g_item_sort[a,b].zaa08 CLIPPED
                                        END IF
                                        LET column_cnt = g_item_sort[a,b].zaa05 - str_cnt + 1
                                        #FUN-810047
                                        #FOR j = 1 to column_cnt
                                        #   LET l_str = l_str," "
                                        #END FOR
                                        LET l_str = l_str, column_cnt SPACES
                                        #END FUN-810047
                                        LET str_cnt = FGL_WIDTH(l_str)
                                  END IF
                               ELSE
                               #FUN-6B0006---end--- 
                                  LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08 CLIPPED)
                                  IF str_cnt > 0 THEN
                                     LET l_str = l_str, g_item_sort[a,b].zaa08  CLIPPED
                                  END IF
                                  LET column_cnt = g_item_sort[a,b].zaa05 - str_cnt + 1
                                  #FUN-810047
                                  #FOR j = 1 to column_cnt
                                  #      LET l_str = l_str," "
                                  #END FOR
                                  LET l_str = l_str, column_cnt SPACES
                                  #END FUN-810047
                                  LET str_cnt = FGL_WIDTH(l_str)
                               END IF
                            END IF
                         END FOR
                         #TQC-5A0082
                         #IF value.equals(g_dash1) THEN
                         #   IF (a = g_dash_num )THEN
                         #     CALL l_channel.write(l_str)
                         #     LET cnt=cnt+1
                         #     EXIT FOR
                         #   END IF
                         #ELSE
                             LET l_str = g_left_str,l_str             #FUN-650017
                             CALL l_channel.write(l_str.trimRight()) #TQC-640051
                             LET cnt=cnt+1
                         #END IF
                         #END TQC-5A0082
                         LET l_str = ""         
                       END FOR
                    END IF
                  END IF
                  IF l_pageheader == "Y" THEN
                     LET l_str = g_left_str,l_str             #FUN-650017
                     CALL l_channel.write(l_str.trimRight()) #TQC-640051
                     LET cnt=cnt+1
                  END IF
                  IF ( cnt > g_pagelen) THEN
                     for k = 1 to g_bottom
                         LET l_str= ""," "
                         CALL l_channel.write(l_str)
                     end for
                     LET cnt= 0
                     IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                        CALL cl_progressing("process: xml")            #FUN-570141
                     END IF                   ### FUN-570264 ###
                     LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                  END IF
                  LET l_str = ""
                  LET l_i = 0                                 #g_item2陣列數
                  LET column_cnt = 1
                  LET l_pageheader = "Y"                      #pageheader的tag
                  CALL g_item.clear()
                  CALL g_item2.clear()
                  CALL g_item_sort.clear()
                  LET l_pageheader = "Y"
                  LET g_print_cnt = 0
               END IF    
            END IF
            LET noskip_old = cnt_noskip
 
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
 
          END CASE
 
      END CASE
      IF g_print_end IS NULL  THEN
         LET e= r.read()
      END IF
      LET g_print_end = NULL
   END WHILE
 #END FUN-570208
 
 CALL l_channel.close()
 
END FUNCTION
 
##################################################
# Descriptions...: 計算報表寬度
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_column(column_cnt)
    DEFINE i                LIKE type_file.num10,       #No.FUN-690005 INTEGER,
           column_cnt       LIKE type_file.num10,       #No.FUN-690005 INTEGER,
           column_size     STRING,
           l_str,gb_code   STRING
    DEFINE l_channel        base.Channel                #FUN-CB0136
    DEFINE l_str1          STRING                       #FUN-CB0136
    DEFINE l_cmd           STRING                       #FUN-CB0136
 
    LET g_total_len = g_total_len + g_view_cnt
    CASE
        WHEN g_total_len <=155
             LET column_size = "21.0"
        WHEN g_total_len > 155             # AND l_column <= 290
             LET column_size = "38.0"
    END CASE
 
    #FUN-A90047  -- start --
    LET l_str ="<html xmlns:o=\"urn:schemas-microsoft-com:office:office\"",
               "xmlns:x=\"urn:schemas-microsoft-com:office:excel\"",
               "xmlns=\"http://www.w3.org/TR/REC-html40\">"
    #FUN-A90047  -- end --    
 
#    IF FGL_GETENV("TOPLOCALE") <> "1" THEN    ##  FUN-550001  ####mark by TQC-5B0077 ##
    IF not ms_codeset.getIndexOf("UTF-8", 1) THEN    ## TQC-5B0077 ##
       IF g_lang = "0" THEN
          #LET l_str="<HEAD>",                 #FUN-CB0136 mark
          LET l_str=l_str CLIPPED ,"<HEAD>",   #FUN-CB0136
                    "<META http-equiv=Content-Type content=\"text/html; charset=big5\">",
                    "<style>",
                    "<!--",
                    " /* Style Definitions */",
                    "p.MsoNormal, li.MsoNormal, div.MsoNormal",
                    " {mso-style-parent:",g_quote,g_quote,";",
	            " margin:0cm;",
	            " margin-bottom:.0001pt;",
	            " mso-pagination:widow-orphan;",
 	            " mso-bidi-font-family:",g_quote,"Times New Roman",g_quote,";}",
                    " pre ",
	            "{margin:0cm; ",
 	            " margin-bottom:.0001pt; ",
                    " font-size:8.0pt;      ",         ##MOD-580063
                    " font-family:細明體;    "
       ELSE 
          IF g_lang = "2" THEN  
             IF ms_codeset.getIndexOf("GB2312", 1) THEN     
                LET gb_code = "GB2312"
             ELSE
                IF ms_codeset.getIndexOf("GBK", 1) THEN     
                   LET gb_code = "GBK"
                ELSE
                   IF ms_codeset.getIndexOf("GB18030", 1) THEN     
                      LET gb_code = "GB18030"
                   END IF
                END IF 
             END IF
             #LET l_str="<HEAD>",                 #FUN-CB0136 mark
             LET l_str=l_str CLIPPED ,"<HEAD>",   #FUN-CB0136
                       "<META http-equiv=Content-Type content=\"text/htmli;charset=",gb_code CLIPPED,"\">",
                       "<style>",
                       "<!--",
                       " /* Style Definitions */",
                       "p.MsoNormal, li.MsoNormal, div.MsoNormal",
                       " {mso-style-parent:",g_quote,g_quote,";",
                       " margin:0cm;",
                       " margin-bottom:.0001pt;",
                       " mso-pagination:widow-orphan;",
                       " mso-bidi-font-family:",g_quote,"Times New Roman",g_quote,";}",
                       " pre ",
                       "{margin:0cm; ",
                       " margin-bottom:.0001pt; ",
                       " font-size:8.0pt;      ",         ##MOD-580063
                       " font-family:新宋体;    "
          ELSE
             #LET l_str="<HEAD>",                 #FUN-CB0136 mark
             LET l_str=l_str CLIPPED ,"<HEAD>",   #FUN-CB0136
                       "<META http-equiv=Content-Type content=\"text/html; charset=utf-8\">",
                       "<style>",
                       "<!--",
                       " /* Style Definitions */",
                       "p.MsoNormal, li.MsoNormal, div.MsoNormal",
                       " {mso-style-parent:",g_quote,g_quote,";",
	               " margin:0cm;",
	               " margin-bottom:.0001pt;",
	               " mso-pagination:widow-orphan;",
 	               " mso-bidi-font-family:",g_quote,"Times New Roman",g_quote,";}",
                       " pre ",
	               "{margin:0cm; ",
 	               " margin-bottom:.0001pt; ",
                       " font-size:8.0pt;      ",         ##MOD-580063
                       " font-family:細明體;    "
          END IF
       END IF
    ELSE
       #LET l_str="<HEAD>",                 #FUN-CB0136 mark
       LET l_str=l_str CLIPPED ,"<HEAD>",   #FUN-CB0136
                 "<META http-equiv=Content-Type content=\"text/html; charset=utf-8\">",
                 "<style>",
                 "<!--",
                 " /* Style Definitions */",
                 "p.MsoNormal, li.MsoNormal, div.MsoNormal",
                 " {mso-style-parent:",g_quote,g_quote,";",
                 " margin:0cm;",
                 " margin-bottom:.0001pt;",
                 " mso-pagination:widow-orphan;",
                 " mso-bidi-font-family:",g_quote,"Times New Roman",g_quote,";}",
                 " pre ",
                 "{margin:0cm; ",
                 " margin-bottom:.0001pt; ",
                 " font-size:8.0pt;      ",         ##MOD-580063
                 #" font-family:細明體;    "        #FUN-710036 mark
                 " font-family:Courier New;    "    #FUN-710036
    END IF 
 
    LET l_str = l_str CLIPPED, 
                " mso-bidi-font-family:",g_quote,"Courier New",g_quote,";} ",
                "/* Page Definitions */",
                " @page Section1",
  	        "{size:",column_size CLIPPED,"cm 841.9pt;",
    	        " margin:14.2pt 2.85pt 14.2pt 2.85pt;",
                " mso-header-margin:14.2pt;",
	        " mso-footer-margin:14.2pt;",
	        " mso-paper-source:0;}",
                "div.Section1",
     	        "{page:Section1;}",
                "-->",
                "</style>",
#FUN-580019
                "<style>  ",
                "table{    ",
                "   font-size: 8pt;                  ",
                "   word-break:break-all;            ",
                "   cursor: default;                 ",
                "   BORDER: BLACK 0px solid;         ",
                "   background-color:#FFFFFF;        ",
                "   border-collapse:collapse;        ",
                "   border-Color:#DFDFDF;            ",
                "   align:center;                    ",
                "}                                   ",
                "</style>                            "
 
#END FUN-580019
     #FUN-CB0136 -start-
     IF g_output_type MATCHES "[78]" THEN 
        IF g_line_seq > 1 OR g_print_name = "h"  THEN  
        ELSE
           LET l_cmd = FGL_GETENV("DS4GL"),"/bin/cl_trans_script.tpl"  
           LET l_channel = base.Channel.create()
           CALL l_channel.openfile(l_cmd, "r")
           WHILE NOT l_channel.iseof()
               LET l_str1 = l_channel.readline()
               LET l_str = l_str CLIPPED ,l_str1,"\n"
           END WHILE
           CALL l_channel.close()
        END IF 
     END IF
                #"</HEAD>",
     LET l_str = l_str CLIPPED ,"</HEAD>",
     #FUN-CB0136 --end--
                "<body lang=ZH-TW style='tab-interval:24.0pt'>",
                " <div class=Section1>"
     #FUN-570203
     IF g_output_type MATCHES "[78]"   THEN       
         LET l_str = l_str CLIPPED, #"<TABLE width=100% BORDER=0 CELLSPACING=0 CELLPADDING=0 STYLE=",g_quote,"font-size: 8pt",g_quote," >"
                    # "<TABLE width=100% border=1 cellSpacing=0 cellPadding=2 STYLE=",g_quote,"font-size: 8pt",g_quote," >"        #FUN-580019
                     "<TABLE border=0 cellSpacing=0 cellPadding=2 STYLE=",g_quote,"font-size: 8pt",g_quote," BORDERCOLOR=\"#DFDFDF\" >"        #FUN-580019 #TQC-5B0055
     ELSE
         LET l_str = l_str CLIPPED,
                "<div align=center>",
               #"<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 STYLE=",g_quote,"font-size: 8pt",g_quote," >"
                "<TABLE border=1 cellSpacing=0 cellPadding=1 STYLE=",g_quote,"font-size: 8pt",g_quote," BORDERCOLOR=\"#DFDFDF\" >"        #FUN-580019
     END IF
     #END FUN-570203
     RETURN l_str
END FUNCTION
 
##MOD-580063
##################################################
# Descriptions...: 計算報表寬度
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_excel_column()  # 計算報表寬度
   DEFINE l_str            STRING
   DEFINE l_cnt            LIKE type_file.num10              #FUN-670044
 
   LET l_str ="<html xmlns:o=\"urn:schemas-microsoft-com:office:office\"",
              "xmlns:x=\"urn:schemas-microsoft-com:office:excel\"",
              "xmlns=\"http://www.w3.org/TR/REC-html40\">",
              "<head>",
              "<meta http-equiv=Content-Type content=\"text/html; charset=",ms_codeset,"\">"
 
   LET l_str = l_str,"<style><!--"
   #IF FGL_GETENV("TOPLOCALE") <> "1" THEN   mark by TQC-5B0077 ##
   IF not ms_codeset.getIndexOf("UTF-8", 1) THEN    ## TQC-5B0077 ##
       CASE g_lang
   #MOD-590325
          WHEN "0"
              LET l_str = l_str,"td  {font-family:細明體, serif;}",
                         " pre ",
	                 "{margin:0cm; ",
 	                 " margin-bottom:.0001pt; ",
                         " font-size:8.0pt;      ",         ##MOD-580063
                         " font-family:細明體;    ",
                         " mso-bidi-font-family:",g_quote,"Courier New",g_quote,";} "
          WHEN "2"
              LET l_str = l_str,"td  {font-family:新宋体, serif;}",
                         " pre ",
	                 "{margin:0cm; ",
 	                 " margin-bottom:.0001pt; ",
                         " font-size:8.0pt;      ",         ##MOD-580063
                         " font-family:新宋体;    ",
                         " mso-bidi-font-family:",g_quote,"Courier New",g_quote,";} "
          OTHERWISE
              LET l_str = l_str,"td  {font-family:細明體, serif;}",
                         " pre ",
	                 "{margin:0cm; ",
 	                 " margin-bottom:.0001pt; ",
                         " font-size:8.0pt;      ",         ##MOD-580063
                         " font-family:細明體;    ",
                         " mso-bidi-font-family:",g_quote,"Courier New",g_quote,";} "
       END CASE
   ELSE
         #LET l_str = l_str,"td  {font-family:細明體, serif;}",     #FUN-710036 mark
         LET l_str = l_str,"td  {font-family:Courier New, serif;}", #FUN-710036
                     " pre ",
	             "{margin:0cm; ",
 	             " margin-bottom:.0001pt; ",
                     " font-size:8.0pt;      ",         ##MOD-580063
                     #" font-family:細明體;    ",       #FUN-710036 mark
                     " font-family:Courier New;    ",   #FUN-710036
                     " mso-bidi-font-family:",g_quote,"Courier New",g_quote,";} "
   END IF
   #END MOD-590325
 
   #FUN-670044
   SELECT COUNT(*) INTO l_cnt FROM zaa_file
     where zaa01= g_prog AND zaa09='2' AND zaa04 = g_zaa04_value
       AND zaa10 = g_zaa10_value AND zaa11=g_zaa11_value
       AND zaa17 = g_zaa17_value AND zaa14 in ('A','B','C','D','E','F') #No.FUN-950066
   IF l_cnt > 0 THEN
       LET l_str = l_str,
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
           #FUN-A90058 -- start --  #FUN-950066
           ".xl40 {mso-style-parent:style0; mso-number-format:\"0\.0000000000_ \";} ",
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
           #FUN-A90058 -- end -- #FUN-950066
   END IF
   #END FUN-670044
 
   LET l_str = l_str,".xl24  { mso-number-format:\"@\";}",
              "--></style>",
              "<!--[if gte mso 9]><xml>",
              "<x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>",
              "<x:Name>Sheet1</x:Name><x:WorksheetOptions>",
              "<x:DefaultRowHeight>330</x:DefaultRowHeight>",
              "<x:Selected/><x:DoDisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorkbook>",
              "</xml><![endif]--></head>"
 
   LET l_str = l_str,
              "<body>",                                   #FUN-A90047
              "<div align=center>",
              "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 STYLE=",g_quote,"font-size: 8pt",g_quote," >"
       RETURN l_str
 
END FUNCTION
 ##END MOD-580063
 
#FUN-570203
##################################################
# Descriptions...: html格式+script(合併)
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_html_script()
DEFINE  output_type,l_pageheader,l_tr              LIKE type_file.chr1,        #No.FUN-690005  VARCHAR(1),
        str_center,l_first_header,l_first_trailer  LIKE type_file.chr1,        #No.FUN-690005    VARCHAR(1),
        l_channel                               base.Channel,
        cnt_print,cnt_item,i,j,h,cnt_noskip        LIKE type_file.num10,       #No.FUN-690005 integer,
        k,column_cnt,tag,tag2,l_p1                 LIKE type_file.num10,       #No.FUN-690005 integer,
        cnt,str_cnt,cnt_column,l_i                 LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        l_str,value,l_cmd,n_name,l_skip_tag     string
DEFINE  l_bufstr                                base.StringBuffer  #TQC-650109
 
DEFINE l_td_attr STRING #No.FUN-6A0159
 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
 
   #計算g_dash總數
   LET g_dash_cnt = 0
  #LET l_cmd = "grep -c \"",g_dash CLIPPED,"*\" ",g_xml_name CLIPPED
   LET l_cmd = "grep -c \"",g_dash_out,"*\" ",g_xml_name CLIPPED #TQC-6A0113
 
   LET l_channel = base.Channel.create()
   CALL l_channel.openPipe(l_cmd, "r")
   WHILE l_channel.read(l_str)
       LET g_dash_cnt = l_str
   END WHILE
   CALL l_channel.close()
   #FUN-6B0006---start---
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' AND g_aza.aza66 = 2 THEN
      LET g_dash_cnt = g_dash_cnt - 1
   END IF
   #FUN-6B0006---end---
          
     LET cnt = 0
     LET l_str = ""

     #No.FUN-9B0062 -- start --
     IF os.Path.delete(output_name CLIPPED) THEN
     END IF
     #No.FUN-9B0062 -- end --

     #FUN-CB0136 mark -start-
     #LET l_cmd = "cat ",FGL_GETENV("DS4GL") CLIPPED,"/bin/cl_trans_script.tpl >> ",output_name CLIPPED  #MOD-580053
     #RUN l_cmd
     #FUN-CB0136 mark --end--
     LET l_channel = base.Channel.create()
     CALL l_channel.openFile(output_name,"a" )
     CALL l_channel.setDelimiter("")
 
 
    LET g_sql = "SELECT zaa02 FROM zaa_file ",
                " WHERE zaa01= '", g_prog ,"' AND zaa09='1' AND zaa04 = '",g_zaa04_value,
                "' AND zaa10 = '",g_zaa10_value,"' AND zaa11='",g_zaa11_value,
                "' AND zaa17 = '",g_zaa17_value,"'"
    PREPARE cl_trans_prepare3 FROM g_sql           #預備一下
    DECLARE cl_trans_curs3 CURSOR FOR cl_trans_prepare3
 
 ## 讀取報表資料
 
   #FUN-CB0136 -start- mark
   #CALL cl_trans_button() RETURNING l_str    #BUTTON內容
   #CALL l_channel.write(l_str)
   #LET l_str = ""
   #FUN-CB0136 --end--
   CALL l_channel.close()        #FUN-CB0136
   CALL cl_trans_column(column_cnt) RETURNING l_str
   CALL l_channel.openFile(output_name,"a" )   #FUN-CB0136
   CALL l_channel.setDelimiter("")             #FUN-CB0136
   CALL l_channel.write(l_str)
   LET l_str = ""
   #FUN-CB0136 -start-
   CALL cl_trans_button() RETURNING l_str    #BUTTON內容
   CALL l_channel.write(l_str)
   LET l_str = ""
   #FUN-CB0136 --end--
   LET g_print_dash = 0
   LET l_i = 0                                 #g_item2陣列數
   LET column_cnt = 1
   LET l_tr = "N"  
   LET g_sort = "N"
 
   #FUN-570208
   #LET nl_print = n.selectByTagName("Print")
   #LET cnt_print = nl_print.getLength()
   LET l_first_header = "N"
   LET l_first_trailer = "N"
   LET n_id_name = "xml"
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
          CASE
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "PageTrailer"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "PageHeader"
 
            WHEN r.getTagName() = "Print"
                LET n_name = r.getTagName()
                LET g_print_name = lsax_attrib.getValue("name")   #TQC-710026
                LET cnt_noskip = 0
                IF g_print_dash >= g_dash_cnt THEN
                   LET n_id_name = "PageTrailer"
                   IF l_first_trailer = "N" THEN
                      LET l_first_trailer = "Y"
                      LET l_str="</TABLE><TABLE border=1 cellSpacing=0 cellPadding=2 BORDERCOLOR=\"#DFDFDF\" >"  #FUN-580019  #TQC-5B0055
                      CALL l_channel.write(l_str)
                      LET l_str = ""
                   END IF
                END IF
                LET l_pageheader = "N"
                LET cnt_item = 0
 
            WHEN r.getTagName() = "Item"
                LET cnt_item = cnt_item + 1        #TQC-5B0055
                LET value = lsax_attrib.getValue("value")
                #TQC-650109
                CALL l_bufstr.clear()
                CALL l_bufstr.append(value)
                IF NOT cl_null(value) THEN
                   CALL l_bufstr.replace("<","&lt;",0)
                END IF
                LET value = l_bufstr.tostring()
                #END TQC-650109
 
                ### 公司名稱 合併
                IF value = g_company AND n_id_name == "PageHeader" THEN   #FUN-690088
                    LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center >",cl_add_span(value),"</TD></TR>"  #No.FUN-A90047  #CHI-B30026 
                    LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                
                #TQC-710026
                #動態報表名稱
                IF g_print_name = "rep_name" THEN
                    LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(value),"</TD></TR>"   #No.FUN-A90047  #CHI-B30026 
                    LET l_tr = "Y"
                    LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                #TQC-710026
 
                ### 虛線不列印
                #TQC-6A0113
                #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED))
                # OR (value.equals(g_dash2 CLIPPED))THEN
                #   IF value.equals(g_dash CLIPPED) THEN
                IF (value = g_dash1) OR (value = g_dash_out) OR
                   (value = g_dash2_out)
                THEN
                   IF value = g_dash_out THEN
                #END TQC-6A0113
 
                       LET g_print_dash = g_print_dash + 1
                   END IF   
                    LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                   EXIT CASE
                END IF
               
                #FUN-690088
                #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
                #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
                #THEN
                #   LET value = g_dash CLIPPED
                #   LET l_tr = "Y"
                #   LET l_pageheader= "Y"     
                #   EXIT CASE
                #END IF
                #END FUN-690088
            
                 IF (g_body_title_pos - 1 = cnt) THEN
                   LET j = l_i + 1
                   LET g_xml_value = value
                   LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                   LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                   LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                   LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                   LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                   LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                   LET g_item[j].column = g_c[g_xml_value]
                   LET l_i = l_i + 1
                ELSE
                   IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                      IF (cnt_item = 1) AND (cnt < 3+g_top )THEN     #TQC-710026
                           IF l_str.trim() = " " THEN
                                LET l_str = value
                           ELSE
                                LET l_str = l_str,value
                           END IF
                       ELSE
                           LET l_str = l_str,value
                           IF i = 1 AND (cnt_column != 0 )THEN
                              LET l_str = l_str," "
                           END IF
                      END IF
                      LET l_pageheader= "Y"     
                   ELSE
                        #FUN-5C0113
                        #IF (cnt_item = 1) AND cl_null(value) THEN
                        #   LET l_tr = "Y"
                        #   LET l_pageheader= "Y"     
                        #   EXIT CASE
                        #END IF
                        #END FUN-5C0113
            
                        IF l_i = 0 THEN  
                          LET l_i = l_i + 1
                        ELSE
                          IF g_item2[l_i].zaa08 IS NOT NULL THEN
                               LET value = g_item2[l_i].zaa08 CLIPPED,value
                          END IF
                        END IF
                        LET g_item2[l_i].zaa08 = value CLIPPED               ### item value
                        LET g_item2[l_i].column = column_cnt         ### item value
                        LET l_pageheader= "N"
                   END IF
                END IF
 
            WHEN r.getTagName() = "Column"
                LET value = lsax_attrib.getValue("value")
                LET column_cnt = value
                IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                    LET str_cnt = FGL_WIDTH(l_str)
                    LET column_cnt = column_cnt - str_cnt - 1
                    #FUN-810047
                    #FOR j = 1 to column_cnt
                    #      LET l_str = l_str," "
                    #END FOR
                    LET l_str = l_str, column_cnt SPACES
                    #END FUN-810047
                ELSE
                    LET l_i = l_i + 1               #
                END IF
 
            WHEN r.getTagName() = "NoSkip"
                 LET cnt_noskip = 1
 
          END CASE
 
        WHEN "EndElement"
          CASE
            WHEN r.getTagName() = "Print"
              IF (cnt_noskip = 0) THEN
                 IF ((n_id_name == "PageHeader") AND (l_first_header="Y"))  
                  OR ((n_id_name == "PageTrailer") AND (l_first_trailer="N")) 
                  OR (cnt_item = 0 )                             #FUN-570203
                 THEN
                      #  LET cnt=cnt+1
                 ELSE
                    IF (g_body_title_pos - 1 = cnt) AND (l_first_header="N") THEN
                         LET l_first_header = "Y"
                         #LET l_str="</TABLE><TABLE width=100% border=1 cellSpacing=0 cellPadding=2 id=PowerTable1>"
                         LET l_str="</TABLE><TABLE border=1 cellSpacing=0 cellPadding=2 id=PowerTable1 BORDERCOLOR=\"#DFDFDF\">"   #FUN-580019  #TQC-5B0055
                         CALL l_channel.write(l_str)
                         LET l_str = ""
                    END IF 
                    #FUN-5C0113
                    IF (cnt_item = 1) AND cl_null(value) THEN
                       LET l_tr = "Y"
                       LET l_pageheader= "Y"     
                    END IF
                    #END FUN-5C0113
                    ###表頭、表尾資料合併，除了表頭欄位內容
                    IF l_tr = "N" THEN
                      IF (g_body_title_pos - 1 <> cnt) AND (n_id_name == "PageHeader") 
                        OR (n_id_name == "PageTrailer") THEN
                        LET str_center = "N"
                        IF n_id_name == "PageHeader" THEN
                          IF (cnt < 3+g_top) AND (NOT l_str.equals(g_company)) THEN   #TQC-710026
                             #No.FUN-810047
                             #OPEN cl_trans_curs3
                             #FOREACH cl_trans_curs3 INTO g_xml_value
                             #     IF l_str.equals(g_x[g_xml_value]) THEN
                             #        LET str_center = "Y"
                             #        EXIT FOREACH
                             #     END IF
                             #END FOREACH
                             FOR j = 1 TO g_zaa02.getLength()
                                 IF l_str.equals(g_x[g_zaa02[j]]) THEN
                                    LET str_center = "Y"
                                    EXIT FOR
                                 END IF
                             END FOR
                             #END No.FUN-810047
                           END IF
                         END IF
                         IF n_id_name = "PageTrailer" AND (cnt_item = 0) THEN
                            LET l_str = ""
                         ELSE
                            IF str_center = "Y" THEN
                               LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(l_str)    #No.FUN-A90047  #CHI-B30026 
                            ELSE 
                               LET l_str = "<TR height=22><TD colspan=",g_column_cnt,">",cl_add_span(l_str)   #No.FUN-A90047  #CHI-B30026 
                            END IF
                            LET l_p1 = l_str.getIndexOf(g_x[3],1)        
                            IF l_p1 > 1 THEN
                                 LET l_str = l_str.subString(1,l_p1-1)
                            END IF
                         END IF
                      ELSE
                         IF (g_body_title_pos - 1 = cnt) AND (n_id_name == "PageHeader") THEN
                             LET l_str = "<TR bgcolor=#FFCC99 >",l_str
                         ELSE
                             LET l_str = "<TR height=22>",l_str    #No.FUN-A90047
                         END IF
                      END IF
                    END IF
                    #TQC-6A0113
                    #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR
                    #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED)) THEN
                    IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                        (l_str = g_dash1) OR (l_str = g_dash2_out) THEN
                    #END TQC-6A0113
 
                    ELSE
                       IF (g_body_title_pos - 1 = cnt) THEN
                           LET l_pageheader = "N"
                       ELSE 
                         IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                            FOR j = 1 to g_value.getLength()   
                              LET g_xml_value = g_value[j].zaa02    
                              LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                              LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                              LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                              LET g_item[j].zaa08 = ""
                              LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                              LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                              LET g_item[j].column = g_c[g_xml_value]
                            END FOR
                          
                            FOR k = 1 to g_item.getLength()
                                IF g_item[k].zaa05 IS NOT NULL THEN
                                   LET j = g_item[k].zaa07
                                   LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                                   LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                                   LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                                   LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                                   LET g_item_sort_1[j].column=g_item[k].column
                                   LET g_item_sort_1[j].sure=g_item[k].sure
                                END IF
                            END FOR
                    
                            FOR k = 1 to g_item_sort_1.getLength()
                                IF g_item_sort_1[k].zaa05 IS NULL THEN
                                      CALL g_item_sort_1.deleteElement(k)                   
                                      LET k = k - 1
                                END IF
                            END FOR
                            LET tag = 0
                            LEt tag2 = 0
                            FOR k = 1 TO g_item2.getLength()
                               #TQC-6B0006
                               IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                                 CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                                 LET INT_FLAG = 1
                                 RETURN
                               END IF
                               #END TQC-6B0006
                               LET g_cnt = g_item_sort_1.getLength() #TQC-950138
                               FOR j = 1 to g_cnt                    #TQC-950138                               
                                 IF (g_item_sort_1[j].zaa05 IS NOT NULL) OR (g_item_sort_1[j].zaa05 <> 0 ) THEN
                                    IF (j = g_item_sort_1.getLength()) AND (g_item2[k].column > g_item_sort_1[j].column-1) THEN
                                       LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                       EXIT FOR
                                    ELSE
                                       IF (g_item2[k].column > g_item_sort_1[j].column-1) AND 
                                          (g_item2[k].column < g_item_sort_1[j+1].column) THEN
                                          IF (g_item_sort_1[j].sure IS NULL) OR (g_item_sort_1[j].sure = "") THEN
                                              LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                              LET g_item_sort_1[j].sure="Y"
                                              LET tag = j
                                          ELSE
                                              LET tag = tag + 1
                                              LET g_item_sort_1[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                              LET g_item_sort_1[tag].sure="Y"
                                           END IF
                                 
                                         EXIT FOR
                                       END IF
                                    END IF
                                 END IF
                               END FOR
                            END FOR 
                            LET l_pageheader = "N"
                            LET g_sort="Y"
                          END IF
                       END IF
                      IF l_pageheader == "N" THEN
                         IF g_sort = "N" THEN
                              FOR k = 1 to g_item.getLength()
                                LET j = g_item[k].zaa07
                                LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                                LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                                LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                                LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                                LET g_item_sort_1[j].column=g_item[k].column
                                LET g_item_sort_1[j].sure=g_item[k].sure
                              END FOR
                         END IF
                         FOR k = 1 to g_item_sort_1.getLength()
                            IF g_item_sort_1[k].zaa06 = 'N' THEN
                              IF (g_zaa13_value = "N") OR
                                 (g_body_title_pos - 1 = cnt)           #TQC-5B0055
                              THEN
                                 LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                                 ## MOD-580150 ###
                                 LET column_cnt = g_item_sort_1[k].zaa05 - str_cnt 
                                 ## MOD-580150 ###
                                 #No.FUN-6A0159 --start--
                                 IF NOT ((g_body_title_pos - 1 = cnt) AND
                                    (g_item_sort_1[k].zaa14 MATCHES '[ABCDEFQ]'))
                                 THEN
                                    FOR j = 1 to column_cnt
                                       LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 CLIPPED, "&nbsp;"  #echo 
                                    END FOR
                                 END IF
                                 #No.FUN-6A0159 --end--
                              END IF
                              #FUN-6B0006---start--- 
                              IF g_aza.aza66 = 2 AND (g_body_title_pos - 1 != cnt) THEN 
                                 LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                                 IF str_cnt > g_item_sort_1[k].zaa05 THEN
                                       LET g_item_sort_1[k].zaa08 = ""
                                       FOR j = 1 to g_item_sort_1[k].zaa05
                                           LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08, "#"
                                       END FOR
                                 END IF
                              END IF
                              #FUN-6B0006---end--- 
                              IF (g_item_sort_1[k].zaa08 IS NULL) OR (g_item_sort_1[k].zaa08 CLIPPED = " ") THEN
                                 LET g_item_sort_1[k].zaa08 = "&nbsp;"
                              END IF
                              #No.FUN-6A0159 --start--
                              IF (g_body_title_pos - 1 = cnt)  AND
                                 (g_item_sort_1[k].zaa14 MATCHES '[ABCDEFQ]')
                              THEN   #是否為單身抬頭
                                LET l_str = l_str CLIPPED,"<TD align=center>",  cl_add_span(g_item_sort_1[k].zaa08),"</TD>"  #CHI-B30026 
                              ELSE
                                LET l_str = l_str CLIPPED,"<TD>",  cl_add_span(g_item_sort_1[k].zaa08 CLIPPED),"</TD>"   #CHI-B30026 
                              END IF
                              #No.FUN-6A0159 --end--
                            END IF
                         END FOR
                         LET l_str = l_str CLIPPED,"</TR>"
                      END IF
                    END IF
                    IF NOT cl_null(l_str) THEN
                       CALL l_channel.write(l_str)
                    END IF
                  END IF
                  LET cnt=cnt+1
                  IF ( cnt > g_pagelen) THEN
                       LET cnt= 0
                       IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                          CALL cl_progressing("process: xml")            #FUN-570141
                       END IF                   ### FUN-570264 ###
                        LET g_page_cnt = g_page_cnt + 1       #TQC-6B0006
                  END IF
                  LET l_str = ""
                  LET l_i = 0                                 #g_item2陣列數
                  LET column_cnt = 1
                  LET l_tr = "N"  
                  LET g_sort = "N"
                  CALL g_item.clear()
                  CALL g_item2.clear()
                  CALL g_item_sort_1.clear()
                  LET l_pageheader = "Y"
                END IF  
         
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
 
          END CASE
 
      END CASE
      LET e= r.read()
   END WHILE
   #END FUN-570208
 
     CLOSE cl_trans_curs3
     CALL l_channel.write("</TABLE></div></body></html>")    ##FUN-A90047
     CALL l_channel.close()
END FUNCTION
 
##################################################
# Descriptions...: html格式+script(pages)
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_html_script2()
DEFINE  output_type,l_pageheader,l_tr           LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
        str_center,l_first_header,l_first_trailer     LIKE type_file.chr1,        #No.FUN-690005  VARCHAR(1),
        l_channel                               base.Channel,
        cnt_print,cnt_item,i,j,h,cnt_noskip     LIKE type_file.num10,       #No.FUN-690005 integer,
        k,column_cnt,tag,tag2,l_p1              LIKE type_file.num10,       #No.FUN-690005 integer,
        cnt,str_cnt,cnt_column,l_i              LIKE type_file.num10,       #No.FUN-690005 INTEGER,
        l_str,value,l_cmd,n_name,l_skip_tag     string,
        n_id_name,l_str2                        string,
        page_cnt                                LIKE type_file.num10       #No.FUN-690005  integer
DEFINE  l_bufstr                                base.StringBuffer  #TQC-650109
 
DEFINE l_td_attr STRING #No.FUN-6A0159
 
   LET l_bufstr = base.StringBuffer.create()                       #TQC-650109
 
     #計算g_dash總數
     LET g_dash_cnt = 0
    #LET l_cmd = "grep -c \"",g_dash CLIPPED,"*\" ",g_xml_name CLIPPED
     LET l_cmd = "grep -c \"",g_dash_out,"*\" ",g_xml_name CLIPPED #TQC-6A0113
 
     LET l_channel = base.Channel.create()
     CALL l_channel.openPipe(l_cmd, "r")
     WHILE l_channel.read(l_str)
         LET g_dash_cnt = l_str
     END WHILE
     CALL l_channel.close()
     #FUN-6B0006---start---
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' AND g_aza.aza66 = 2 THEN
        LET g_dash_cnt = g_dash_cnt - 1
     END IF
     #FUN-6B0006---end---
          
     LET cnt = 0
     LET l_str = ""

     #No.FUN-9B0062 -- start --
     IF os.Path.delete(output_name CLIPPED) THEN
     END IF
     #No.FUN-9B0062 -- end --
     #FUN-CB0136 mark -start-
     #LET l_cmd = "cat ",FGL_GETENV("DS4GL") CLIPPED,"/bin/cl_trans_script.tpl >> ",output_name CLIPPED  #MOD-580053
     #RUN l_cmd
     #FUN-CB0136 mark --end--
     LET l_channel = base.Channel.create()
     CALL l_channel.openFile(output_name,"a" )
     CALL l_channel.setDelimiter("")
 
 
    LET g_sql = "SELECT zaa02 FROM zaa_file ",
                " where zaa01= '", g_prog ,"' AND zaa09='1' AND zaa04 = '",g_zaa04_value,
                "' AND zaa10 = '",g_zaa10_value,"' AND zaa11='",g_zaa11_value,
                "' AND zaa17 = '",g_zaa17_value,"'"
    PREPARE cl_trans_prepare4 FROM g_sql           #預備一下
    DECLARE cl_trans_curs4 CURSOR FOR cl_trans_prepare4
 
 ## 讀取報表資料
   #FUN-CB0136 -start- mark
   #CALL cl_trans_button() RETURNING l_str    #BUTTON內容
   #CALL l_channel.write(l_str)
   #LET l_str = ""
   #FUN-CB0136 --end--
   CALL l_channel.close()        #FUN-CB0136
   CALL cl_trans_column(column_cnt) RETURNING l_str
   CALL l_channel.openFile(output_name,"a" )   #FUN-CB0136
   CALL l_channel.setDelimiter("")             #FUN-CB0136
   CALL l_channel.write(l_str)
   LET l_str = ""
   #FUN-CB0136 -start- 
   CALL cl_trans_button() RETURNING l_str    #BUTTON內容
   CALL l_channel.write(l_str)
   LET l_str = ""
   #FUN-CB0136 --end--
   LET g_print_dash = 0
   LET l_i = 0                                 #g_item2陣列數
   LET column_cnt = 1
   LET l_tr = "N"  
   LET g_sort = "N"
 
   #FUN-570208
   #LET nl_print = n.selectByTagName("Print")
   #LET cnt_print = nl_print.getLength()
   LET page_cnt = 1
   LET l_first_trailer = "N"
 
   LET n_id_name = "xml"
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
          CASE
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "PageTrailer"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "PageHeader"
 
            WHEN r.getTagName() = "Print"
                LET n_name = r.getTagName()
                LET g_print_name = lsax_attrib.getValue("name")   #TQC-710026
                LET cnt_noskip = 0
                IF g_print_dash >= g_dash_cnt THEN
                   LET n_id_name = "PageTrailer"
                END IF
                LET l_pageheader = "N"
                IF n_id_name = "PageTrailer" AND l_first_trailer="N" THEN
                   #LET l_str="</TABLE><TABLE width=100% border=1 cellSpacing=0 cellPadding=2 >"
                   LET l_str="</TABLE><TABLE border=1 cellSpacing=0 cellPadding=2 BORDERCOLOR=\"#DFDFDF\" >" #FUN-580019  #TQC-5B0055
                   CALL l_channel.write(l_str)
                   LET l_str = ""
                   LET l_first_trailer="Y"
                END IF
                LET cnt_item = 0
 
            WHEN r.getTagName() = "Item"
                LET cnt_item = cnt_item + 1               #TQC-5B0055
                LET value = lsax_attrib.getValue("value")
                #TQC-650109
                CALL l_bufstr.clear()
                CALL l_bufstr.append(value)
                IF NOT cl_null(value) THEN
                   CALL l_bufstr.replace("<","&lt;",0)
                END IF
                LET value = l_bufstr.tostring()
                #END TQC-650109
 
                ### 公司名稱 合併
                IF value = g_company AND n_id_name == "PageHeader" THEN   #FUN-690088
                    LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center >",cl_add_span(value),"</TD></TR>" #MOD-580063 #No.FUN-A90047  #CHI-B30026 
                    LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                
                #TQC-710026
                #動態報表名稱
                IF g_print_name = "rep_name" THEN
                    LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(value),"</TD></TR>"  #No.FUN-A90047 #CHI-B30026 
                    LET l_tr = "Y"
                    LET l_pageheader= "Y"     
                    EXIT CASE
                END IF
                #TQC-710026
 
                ### 虛線不列印
                #TQC-6A0113
                #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED)) OR
                #   (value.equals(g_dash2 CLIPPED))THEN
                #   IF value.equals(g_dash CLIPPED) THEN
                IF (value = g_dash1) OR (value = g_dash_out) OR
                   (value = g_dash2_out)
                THEN
                   IF value = g_dash_out THEN
                #END TQC-6A0113
 
                       LET g_print_dash = g_print_dash + 1
                   END IF   
                    LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                   EXIT CASE
                END IF
                #FUN-690088
                #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
                #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
                #THEN
                #   LET value = g_dash CLIPPED
                #   LET l_tr = "Y"
                #   LET l_pageheader= "Y"     
                #   EXIT CASE
                #END IF
                #END FUN-690088
                
                 IF (g_body_title_pos - 1 = cnt) THEN
                   LET j = l_i + 1
                   LET g_xml_value = value
                   LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                   LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                   LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                   #TQC-5B0170
                   IF g_zaa_dyn.getLength() > 0 THEN
                      LET g_item[j].zaa08 = g_zaa_dyn[g_page_cnt,g_xml_value]
                   ELSE
                      LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                   END IF
                   #END TQC-5B0170
                   LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                   LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                   LET g_item[j].column = g_c[g_xml_value]
                   LET l_i = l_i + 1
                ELSE
                   IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                      IF (cnt < 3+g_top )THEN                 #TQC-710026
                           IF l_str.trim() = " " THEN
                                LET l_str = value
                           ELSE
                                LET l_str = l_str,value
                           END IF
                       ELSE
                           LET l_str = l_str,value
                           IF i = 1 AND (cnt_column != 0 )THEN
                              LET l_str = l_str," "
                           END IF
                      END IF
                      LET l_pageheader= "Y"     
                   ELSE
                        #FUN-5C0113 
                        #IF (cnt_item = 1) AND cl_null(value) THEN
                        #   LET l_tr = "Y"
                        #   LET l_pageheader= "Y"     
                        #   EXIT CASE
                        #END IF
                        #END FUN-5C0113
                        IF l_i = 0 THEN  
                          LET l_i = l_i + 1
                        ELSE
                          IF g_item2[l_i].zaa08 IS NOT NULL THEN
                               LET value = g_item2[l_i].zaa08 CLIPPED,value
                          END IF
                        END IF
                        LET g_item2[l_i].zaa08 = value CLIPPED               ### item value
                        LET g_item2[l_i].column = column_cnt         ### item value
                        LET l_pageheader= "N"
                   END IF
                END IF
 
            WHEN r.getTagName() = "Column"
                LET value = lsax_attrib.getValue("value")
                LET column_cnt = value
                IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                    LET str_cnt = FGL_WIDTH(l_str)
                    LET column_cnt = column_cnt - str_cnt - 1
                    #FUN-810047
                    #FOR j = 1 to column_cnt
                    #      LET l_str = l_str," "
                    #END FOR
                    LET l_str = l_str, column_cnt SPACES
                    #END FUN-810047
                ELSE
                    LET l_i = l_i + 1               #
                END IF
 
            WHEN r.getTagName() = "NoSkip"
                 LET cnt_noskip = 1
 
          END CASE
 
        WHEN "EndElement"
          CASE
            WHEN r.getTagName() = "Print"
               IF (cnt_noskip = 0) THEN
                   IF (g_body_title_pos - 1 = cnt) THEN
                        LET l_first_header = "Y"
                        LET l_str="</TABLE><TABLE border=1 cellSpacing=0 cellPadding=2 id=PowerTable",page_cnt USING '<<<<<<<<<<'," BORDERCOLOR=\"#DFDFDF\" >"  #FUN-580019 #TQC-5B0055
                        CALL l_channel.write(l_str)
                        LET l_str = ""
                   END IF 
                   #FUN-5C0113 
                   IF (cnt_item = 1) AND cl_null(value) THEN
                      LET l_tr = "Y"
                      LET l_pageheader= "Y"     
                   END IF
                   #END FUN-5C0113
                   ###表頭、表尾資料合併，除了表頭欄位內容
                   IF (l_tr = "N") AND (cnt_item > 0)THEN   #FUN-570203
                     IF (g_body_title_pos - 1 <> cnt) AND (n_id_name == "PageHeader") 
                       OR (n_id_name == "PageTrailer") THEN
                       LET str_center = "N"
                       IF n_id_name == "PageHeader" THEN
                         IF (cnt < 3+g_top) AND (NOT l_str.equals(g_company)) THEN   #TQC-710026
                            #No.FUN-810047
                            #OPEN cl_trans_curs4
                            #FOREACH cl_trans_curs4 INTO g_xml_value
                            #     IF l_str.equals(g_x[g_xml_value]) THEN
                            #        LET str_center = "Y"
                            #        EXIT FOREACH
                            #     END IF
                            #END FOREACH
                             FOR j = 1 TO g_zaa02.getLength()
                                 IF l_str.equals(g_x[g_zaa02[j]]) THEN
                                    LET str_center = "Y"
                                    EXIT FOR
                                 END IF
                             END FOR
                             #END No.FUN-810047
                          END IF
                        END IF
                        IF n_id_name = "PageTrailer" AND (cnt_item = 0) THEN
                           LET l_str = ""
                        ELSE
                           IF str_center = "Y" THEN
                              LET l_str = "<TR height=22><TD colspan=",g_column_cnt," align=center>",cl_add_span(l_str) #MOD-580063  #No.FUN-A90047 #CHI-B30026 
                           ELSE 
                              LET l_str = "<TR height=22><TD colspan=",g_column_cnt,">",cl_add_span(l_str) #MOD-580063  #No.FUN-A90047  #CHI-B30026 
                           END IF
                        END IF
                     ELSE
                        IF (g_body_title_pos - 1 = cnt) AND (n_id_name == "PageHeader") THEN
                            LET l_str = "<TR bgcolor=#FFCC99 >",l_str
                        ELSE
                            LET l_str = "<TR height=22>",l_str   #No.FUN-A90047
                        END IF
                     END IF
                   END IF
                   #TQC-6A0113
                   #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR
                   #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED)) OR
                   IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                       (l_str = g_dash1) OR (l_str = g_dash2_out) OR
                       (cnt_item = 0 )                             #FUN-570203
                   #END TQC-6A0113
                   THEN
                      IF (l_pageheader = "Y") THEN                  #TQC-5B0055
                          LET l_str = l_str ,"</TD></TR>"           #CHI-B30026
                      END IF
 
                   ELSE
                      IF (g_body_title_pos - 1 = cnt) THEN
                          LET l_pageheader = "N"
                      ELSE 
                        IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                           FOR j = 1 to g_value.getLength()   
                             LET g_xml_value = g_value[j].zaa02    
                             LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                             LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                             LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                             LET g_item[j].zaa08 = ""
                             LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                             LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                             LET g_item[j].column = g_c[g_xml_value]
                           END FOR
                         
                           FOR k = 1 to g_item.getLength()
                               IF g_item[k].zaa05 IS NOT NULL THEN
                                  LET j = g_item[k].zaa07
                                  LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                                  LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                                  LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                                  LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                                  LET g_item_sort_1[j].column=g_item[k].column
                                  LET g_item_sort_1[j].sure=g_item[k].sure
                               END IF
                           END FOR
                   
                           FOR k = 1 to g_item_sort_1.getLength()
                               IF g_item_sort_1[k].zaa05 IS NULL THEN
                                     CALL g_item_sort_1.deleteElement(k)                   
                                     LET k = k - 1
                               END IF
                           END FOR
                           LET tag = 0
                           LEt tag2 = 0
                           FOR k = 1 TO g_item2.getLength()
                              #TQC-6B0006
                              IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                                CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                                LET INT_FLAG = 1
                                RETURN
                              END IF
                              #END TQC-6B0006
                              LET g_cnt = g_item_sort_1.getLength() #TQC-950138
                              FOR j = 1 to g_cnt                    #TQC-950138                              
                                IF (g_item_sort_1[j].zaa05 IS NOT NULL) OR (g_item_sort_1[j].zaa05 <> 0 ) THEN
                                   IF (j = g_item_sort_1.getLength()) AND (g_item2[k].column > g_item_sort_1[j].column-1) THEN
                                      LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                      EXIT FOR
                                   ELSE
                                      IF (g_item2[k].column > g_item_sort_1[j].column-1) AND 
                                         (g_item2[k].column < g_item_sort_1[j+1].column) THEN
                                         IF (g_item_sort_1[j].sure IS NULL) OR (g_item_sort_1[j].sure = "") THEN
                                             LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                             LET g_item_sort_1[j].sure="Y"
                                             LET tag = j
                                         ELSE
                                             LET tag = tag + 1
                                             LET g_item_sort_1[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                             LET g_item_sort_1[tag].sure="Y"
                                          END IF
                                
                                        EXIT FOR
                                      END IF
                                   END IF
                                END IF
                              END FOR
                           END FOR 
                           LET l_pageheader = "N"
                           LET g_sort="Y"
                         END IF
                      END IF
                     IF l_pageheader == "N" THEN
                        IF g_sort = "N" THEN
                             FOR k = 1 to g_item.getLength()
                               LET j = g_item[k].zaa07
                               LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                               LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                               LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item_sort_1[j].column=g_item[k].column
                               LET g_item_sort_1[j].sure=g_item[k].sure
                             END FOR
                        END IF
                        FOR k = 1 to g_item_sort_1.getLength()
                           IF g_item_sort_1[k].zaa06 = 'N' THEN
                             IF (g_zaa13_value = "N") OR
                                (g_body_title_pos - 1 = cnt)           #TQC-5B0055
                             THEN
 
                                LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                                ### MOD-580150 ###
                                LET column_cnt = g_item_sort_1[k].zaa05 - str_cnt 
                                ### MOD-580150 ###
                                #No.FUN-6A0159 --start--
                                IF NOT ((g_body_title_pos - 1 = cnt) AND 
                                    (g_item_sort_1[k].zaa14 MATCHES '[ABCDEFQ]'))
                                THEN
                                   FOR j = 1 to column_cnt
                                      LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08 CLIPPED, "&nbsp;"  #echo 
                                   END FOR
                                END IF
                                #No.FUN-6A0159 --end--
                             END IF
                             #FUN-6B0006---start--- 
                             IF g_aza.aza66 = 2 AND (g_body_title_pos - 1 != cnt) THEN 
                                LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                                IF str_cnt > g_item_sort_1[k].zaa05 THEN
                                      LET g_item_sort_1[k].zaa08 = ""
                                      FOR j = 1 to g_item_sort_1[k].zaa05
                                          LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08, "#"
                                      END FOR
                                END IF
                             END IF
                             #FUN-6B0006---end--- 
                             IF (g_item_sort_1[k].zaa08 IS NULL) OR (g_item_sort_1[k].zaa08 CLIPPED = " ") THEN
                                LET g_item_sort_1[k].zaa08 = "&nbsp;"
                             END IF
                             #No.FUN-6A0159 --start--
                             IF (g_body_title_pos - 1 = cnt) AND 
                                (g_item_sort_1[k].zaa14 MATCHES '[ABCDEFQ]')
                             THEN   #是否為單身抬頭
                                LET l_str = l_str CLIPPED,"<TD align=center>",  cl_add_span(g_item_sort_1[k].zaa08),"</TD>"    #CHI-B30026 
                             ELSE
                                LET l_str = l_str CLIPPED,"<TD>",  cl_add_span(g_item_sort_1[k].zaa08),"</TD>" #MOD-580063
                             END IF
                             #No.FUN-6A0159 --end--
                           END IF
                        END FOR
                        LET l_str = l_str CLIPPED,"</TR>"
                     END IF
                   END IF
                   IF NOT cl_null(l_str) THEN
                      CALL l_channel.write(l_str)
                   END IF
                   LET cnt=cnt+1          #FUN-570208
                 END IF
                 IF ( cnt > g_pagelen) THEN
                     LET page_cnt = page_cnt + 1
                     #### 分頁格線 ####
                     LET l_str="</TABLE></div>",          #MOD-580063
                               "<p></p>",
                               #"<div align=center>",     #TQC-5B0085
                               "<TABLE border=0 cellSpacing=0 cellPadding=2 BORDERCOLOR=\"#DFDFDF\" >"  #FUN-580019 # FUN-570208 #TQC-5B0055  
                     CALL l_channel.write(l_str)
                     LET cnt= 0
                     LET l_first_trailer="N"
                     IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                          CALL cl_progressing("process: xml")            #FUN-570141
                     END IF                   ### FUN-570264 ###
                     LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                 END IF
                 IF (cnt_noskip = 0) THEN         #FUN-570208   #TQC-5B0055
                    LET l_str = ""
                    LET l_i = 0                                 #g_item2陣列數
                    LET column_cnt = 1
                    LET l_tr = "N"  
                    LET g_sort = "N"
                    CALL g_item.clear()
                    CALL g_item2.clear()
                    CALL g_item_sort_1.clear()
                    LET l_pageheader = "Y"
                 END IF
 
 
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
 
          END CASE
 
      END CASE
      LET e= r.read()
   END WHILE
   #END FUN-570208
 
   CLOSE cl_trans_curs4
   CALL l_channel.write("</TABLE></div></body></html>")    ##FUN-A90047
   CALL l_channel.close()
   LET page_cnt = page_cnt - 1
   LET l_str2 = output_name.subString(1,output_name.getLength()-4),"1.htm"
   LET l_str = "for (var i=1; i<=",page_cnt USING '<<<<<<<<<<',";i++) {" 
   #No.FUN-960155 -- satart -- 
   IF os.Path.separator() = "/" THEN
      LET l_cmd = "awk ' { sub(/\\/\\/{@}#1/, \"",l_str CLIPPED,"\"); sub(/\\/\\/{@}#2/, \"\") ; print $0  } ' $TEMPDIR/",
       	          output_name CLIPPED," > ",l_str2 CLIPPED
      RUN l_cmd
      LET l_cmd = "cp ",os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED)," ",os.Path.join(FGL_GETENV("TEMPDIR"),output_name CLIPPED) #FUN-9B0062
      RUN l_cmd
   ELSE
      LET l_cmd = "%FGLRUN% ",os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin" ),"rsed.42m"),
                  ' "//{@}#1" "',l_str,'" ',
                  output_name CLIPPED," ",l_str2 CLIPPED
      RUN l_cmd
      IF os.Path.copy( os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED),     #FUN-930058
                       os.Path.join(FGL_GETENV("TEMPDIR"),output_name CLIPPED ) ) THEN END IF
        
      LET l_cmd = "%FGLRUN% ",os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin" ),"rsed.42m"),
                  ' "//{@}#2" "',l_str,'" ',
                  output_name CLIPPED," ",l_str2 CLIPPED
      RUN l_cmd
      IF os.Path.copy( os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED),     #FUN-930058
                       os.Path.join(FGL_GETENV("TEMPDIR"),output_name CLIPPED ) ) THEN END IF
   END IF
   #No.FUN-960155 -- end -- 

   #FUN-B80109 begin
   IF os.Path.separator() = "/" THEN    
     LET l_cmd = "chmod 777 ",output_name CLIPPED," 2>/dev/null" 
     RUN l_cmd
   ELSE
     LET l_cmd = "attrib -r ",output_name CLIPPED," >nul 2>nul" #MOD-530271 
     RUN l_cmd
   END IF  
   #FUN-B80109 end

   #No.FUN-9B0062 -- start --
   IF os.Path.delete(l_str2 CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --

END FUNCTION
 
##################################################
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_button()
DEFINE l_str                  STRING
DEFINE l_ze03                 LIKE ze_file.ze03
 
LET l_str = "<TABLE class=\"Noprint\"><TR height=22><TD>"  #No.FUN-A90047
  #刪除欄
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'lib-271' AND ze02 = g_lang
  LET l_str = l_str,
    "<input type=button value=",l_ze03 CLIPPED," onclick=del_col(Main_Tab)>"
 
  #還原
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'lib-272' AND ze02 = g_lang
  LET l_str = l_str,
    "<input type=button value=",l_ze03 CLIPPED," onclick=location.reload()>"
 
  #輸出
  #SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'lib-273' AND ze02 = g_lang
  #LET l_str = l_str,
  #  "<input type=button value=",l_ze03 CLIPPED," onclick=exp_tab(Main_Tab)>"
 
  #移動
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'lib-276' AND ze02 = g_lang
  LET l_str = l_str, " ( ",l_ze03 CLIPPED,": "
 
  #向左
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'lib-274' AND ze02 = g_lang
  LET l_str = l_str,
    "<input type=button id=move value=",l_ze03 CLIPPED," onclick=Move_left(Main_Tab)>"
 
  #向右
  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'lib-275' AND ze02 = g_lang
  LET l_str = l_str,
    "<input type=button id=move value=",l_ze03 CLIPPED," onclick=Move_right(Main_Tab)> )"
  LET l_str = l_str,"</TD></TR></TABLE>"
  
  RETURN l_str
END FUNCTION
#END FUN-570203
 
#FUN-5C0113
##################################################
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_contview()
DEFINE     l_pageheader,l_tr                       LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
           l_channel                               base.Channel,
           cnt_print,cnt_item,i,j,h,cnt_noskip     LIKE type_file.num10,       #No.FUN-690005 integer,
           k,column_cnt,tag                        LIKE type_file.num10,       #No.FUN-690005 integer,
           cnt,str_cnt,cnt_column,l_i              LIKE type_file.num10,       #No.FUN-690005 INTEGER,
           l_str,value,l_cmd,n_name,l_skip_tag     string,
           n_id_name,l_str2                        string,
           page_cnt                                LIKE type_file.num10,       #No.FUN-690005 integer,
           l_row,l_cnt                             LIKE type_file.num10       #No.FUN-690005 INTEGER
 
DEFINE l_zaa02 DYNAMIC ARRAY  OF LIKE type_file.num10       #No.FUN-690005 INTEGER
 
DEFINE l_pre_spaces LIKE type_file.num10 #No.FUN-6A0159       
 
    #計算g_dash總數
    LET g_dash_cnt = 0
   #LET l_cmd = "grep -c \"",g_dash CLIPPED,"*\" ",g_xml_name CLIPPED
    LET l_cmd = "grep -c \"",g_dash_out ,"*\" ",g_xml_name CLIPPED  #TQC-6A0113
 
    LET l_channel = base.Channel.create()
    CALL l_channel.openPipe(l_cmd, "r")
    WHILE l_channel.read(l_str)
        LET g_dash_cnt = l_str
    END WHILE
    CALL l_channel.close()
    #FUN-6B0006---start---
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' AND g_aza.aza66 = 2 THEN
       LET g_dash_cnt = g_dash_cnt - 1
    END IF
    #FUN-6B0006---end---
        
    LET cnt = 0
 
 ## 讀取報表資料
 
   LET l_str = ""
   LET g_print_dash = 0
   LET l_i = 0                                 #g_item2陣列數
   LET column_cnt = 1
   LET l_tr = "N"  
   LET g_sort = "N"
   LET l_row = 0
   LET page_cnt = 1
 
   CALL g_body_title.clear()
   CALL g_header.clear()
   CALL g_body.clear()
   CALL g_trailer.clear()
 
   LET n_id_name = "xml"
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
      CASE e
        WHEN "StartElement"
          CASE
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "PageTrailer"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "PageHeader"
 
            WHEN r.getTagName() = "Print"
                LET n_name = r.getTagName()
                LET cnt_noskip = 0
                IF g_print_dash >= g_dash_cnt THEN
                   LET n_id_name = "PageTrailer"
                END IF
                LET l_pageheader = "N"
                LET cnt_item = 0
 
            WHEN r.getTagName() = "Item"
                LET cnt_item = cnt_item + 1               #TQC-5B0055
                LET value = lsax_attrib.getValue("value")
                
                ### 虛線不列印
                #TQC-6A0113
                #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED)) OR
                #   (value.equals(g_dash2 CLIPPED))THEN
                #   IF value.equals(g_dash CLIPPED) THEN
                IF (value = g_dash1) OR (value = g_dash_out) OR
                   (value = g_dash2_out)
                THEN
                   IF value = g_dash_out THEN
                #END TQC-6A0113
 
                       LET g_print_dash = g_print_dash + 1
                   END IF   
                   LET l_tr = "Y"
                   LET l_pageheader= "Y"     
                   EXIT CASE
                END IF
 
                #FUN-690088 
                #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
                #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
                #THEN
                #   LET value = g_dash CLIPPED
                #   LET l_tr = "Y"
                #   LET l_pageheader= "Y"     
                #   EXIT CASE
                #END IF
                #END FUN-690088 
                
                 IF (g_body_title_pos - 1 = cnt) THEN
                   LET j = l_i + 1
                   LET g_xml_value = value
                   LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                   LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                   LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                   #TQC-5B0170
                   IF g_zaa_dyn.getLength() > 0 THEN
                      LET g_item[j].zaa08 = g_zaa_dyn[g_page_cnt,g_xml_value]
                   ELSE
                      LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                   END IF
                   #END TQC-5B0170
                   #No.FUN-6A0159 --start--
                   LET g_item[j].zaa14= g_zaa[g_xml_value].zaa14 CLIPPED
                   IF g_item[j].zaa14 MATCHES '[ABCDEFQ]' THEN
                      LET l_pre_spaces = (g_item[j].zaa05 - FGL_WIDTH(g_item[j].zaa08 CLIPPED)) / 2
                      IF l_pre_spaces > 0 then
                         LET g_item[j].zaa08 = l_pre_spaces SPACES || g_item[j].zaa08 CLIPPED
                      END IF
                   END IF
                   #No.FUN-6A0159 --end--
                   LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                   LET g_item[j].column = g_c[g_xml_value]
 
                   LET l_zaa02[g_item[j].zaa07] = g_xml_value
                   LET l_i = l_i + 1
                    
                ELSE
                   IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                       IF (cnt < 3+g_top )THEN                 #TQC-710026
                           LET l_str = l_str,value
                       ELSE
                           LET l_str = l_str,value
                           IF i = 1 AND (cnt_column != 0 )THEN
                              LET l_str = l_str," "
                           END IF
                      END IF
                      LET l_pageheader= "Y"     
                   ELSE
                        IF l_i = 0 THEN  
                          LET l_i = l_i + 1
                        ELSE
                          IF g_item2[l_i].zaa08 IS NOT NULL THEN
                               LET value = g_item2[l_i].zaa08 CLIPPED,value
                          END IF
                        END IF
                        LET g_item2[l_i].zaa08 = value CLIPPED               ### item value
                        LET g_item2[l_i].column = column_cnt         ### item value
                        LET l_pageheader= "N"
                   END IF
                END IF
 
            WHEN r.getTagName() = "Column"
                LET value = lsax_attrib.getValue("value")
                LET column_cnt = value
                IF (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                    LET str_cnt = FGL_WIDTH(l_str)
                    LET column_cnt = column_cnt - str_cnt - 1
                    #FUN-810047
                    #FOR j = 1 to column_cnt
                    #      LET l_str = l_str," "
                    #END FOR
                    LET l_str = l_str, column_cnt SPACES
                    #END FUN-810047
                ELSE
                    LET l_i = l_i + 1               #
                END IF
 
            WHEN r.getTagName() = "NoSkip"
                 LET cnt_noskip = 1
 
          END CASE
 
        WHEN "EndElement"
          CASE
            WHEN r.getTagName() = "Print"
               IF (cnt_noskip = 0) THEN
                   IF (g_body_title_pos - 1 = cnt) THEN
                        LET l_str = ""
                   END IF 
                   IF (cnt_item = 1) AND cl_null(value) THEN
                      LET l_tr = "Y"
                      LET l_pageheader= "Y"     
                   END IF
                   ###表頭、表尾資料合併，除了表頭欄位內容
                  #TQC-6A0113
                  #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR
                  #    (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED))
                  IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                      (l_str = g_dash1) OR (l_str = g_dash2_out)  OR
                      (cnt_item = 0 )                             #FUN-570203
                  #END TQC-6A0113
 
                   THEN
                        IF cnt_item = 0 AND (g_body_title[page_cnt].getLength() > 0)
                           AND (n_id_name <> "PageHeader") 
                           AND (n_id_name <> "PageTrailer") 
                        THEN
                                LET l_pageheader ="Y"
                        END IF
 
                   ELSE
                      IF (g_body_title_pos - 1 = cnt) THEN
                          LET l_pageheader = "N"
                      ELSE 
                        IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                           FOR j = 1 to g_value.getLength()   
                             LET g_xml_value = g_value[j].zaa02    
                             LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                             LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                             LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                             LET g_item[j].zaa08 = ""
                             LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                             LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #No.FUN-6A0159
                             LET g_item[j].column = g_c[g_xml_value]
                           END FOR
                         
                           FOR k = 1 to g_item.getLength()
                               IF g_item[k].zaa05 IS NOT NULL THEN
                                  LET j = g_item[k].zaa07
                                  LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                                  LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                                  LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                                  LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                                  LET g_item_sort_1[j].column=g_item[k].column
                                  LET g_item_sort_1[j].sure=g_item[k].sure
                               END IF
                           END FOR
                   
                           FOR k = 1 to g_item_sort_1.getLength()
                               IF g_item_sort_1[k].zaa05 IS NULL THEN
                                     CALL g_item_sort_1.deleteElement(k)                   
                                     LET k = k - 1
                               END IF
                           END FOR
                           LET tag = 0
                           FOR k = 1 TO g_item2.getLength()
                              #TQC-6B0006
                              IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                                CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                                LET INT_FLAG = 1
                                RETURN
                              END IF
                              #END TQC-6B0006
                              LET g_cnt = g_item_sort_1.getLength() #TQC-950138
                              FOR j = 1 to g_cnt                    #TQC-950138
                                IF (g_item_sort_1[j].zaa05 IS NOT NULL) OR (g_item_sort_1[j].zaa05 <> 0 ) THEN
                                   IF (j = g_item_sort_1.getLength()) AND (g_item2[k].column > g_item_sort_1[j].column-1) THEN
                                      LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                      EXIT FOR
                                   ELSE
                                      IF (g_item2[k].column > g_item_sort_1[j].column-1) AND 
                                         (g_item2[k].column < g_item_sort_1[j+1].column) THEN
                                         IF (g_item_sort_1[j].sure IS NULL) OR (g_item_sort_1[j].sure = "") THEN
                                             LET g_item_sort_1[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                             LET g_item_sort_1[j].sure="Y"
                                             LET tag = j
                                         ELSE
                                             LET tag = tag + 1
                                             LET g_item_sort_1[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                             LET g_item_sort_1[tag].sure="Y"
                                          END IF
                                
                                        EXIT FOR
                                      END IF
                                   END IF
                                END IF
                              END FOR
                           END FOR 
                           LET l_pageheader = "N"
                           LET g_sort="Y"
                         END IF
                      END IF
                     IF l_pageheader == "N" THEN
                        IF g_sort = "N" THEN
                             FOR k = 1 to g_item.getLength()
                               LET j = g_item[k].zaa07
                               LET g_item_sort_1[j].zaa05=g_item[k].zaa05
                               LET g_item_sort_1[j].zaa06=g_item[k].zaa06
                               LET g_item_sort_1[j].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort_1[j].zaa14=g_item[k].zaa14 CLIPPED #No.FUN-6A0159
                               LET g_item_sort_1[j].column=g_item[k].column
                               LET g_item_sort_1[j].sure=g_item[k].sure
                             END FOR
                        END IF
                        IF g_body_title_pos - 1 <> cnt THEN 
                             LET l_row = l_row + 1
                        END IF
                        FOR k = 1 to g_item_sort_1.getLength()
                          IF g_item_sort_1[k].zaa06 = 'N' THEN
                             IF (g_body_title_pos - 1 = cnt) THEN
                                  LET i = g_body_title[page_cnt].getLength()
                                  SELECT COUNT(*) INTO l_cnt FROM zad_file
                                  WHERE zad01 = g_prog  AND  zad02 = l_zaa02[k]
                                    AND zad03 = g_rlang AND  zad04 = g_zaa04_value
                                    AND zad05 = g_zaa10_value
                                    AND zad06 = g_zaa11_value AND zad07 = g_zaa17_value
                                  IF l_cnt > 0 THEN
                                      LET g_body_title[page_cnt,i+1].contview = 'Y'
                                      LET g_item_sort_1[k].zaa08 = "*", g_item_sort_1[k].zaa08  CLIPPED
                                  END IF
                                  LET g_body_title[page_cnt,i+1].zaa08 = g_item_sort_1[k].zaa08 CLIPPED
                                  LET g_body_title[page_cnt,i+1].zaa05 = g_item_sort_1[k].zaa05
                                  LET g_body_title[page_cnt,i+1].zaa02 = l_zaa02[k]
                             ELSE
                                 #FUN-660179 
                                 ##FUN-6B0006---start--- 
                                 #IF g_aza.aza66 = 2 THEN 
                                 #   LET i = g_body[page_cnt,l_row].getLength()
                                 #   LET str_cnt = FGL_WIDTH(g_item_sort_1[k].zaa08 CLIPPED)
                                 #   IF str_cnt > g_item_sort_1[k].zaa05 THEN
                                 #         LET g_item_sort_1[k].zaa08 = ""
                                 #         FOR j = 1 to g_item_sort_1[k].zaa05
                                 #             LET g_item_sort_1[k].zaa08 = g_item_sort_1[k].zaa08, "#"
                                 #         END FOR
                                 #   END IF
                                 #   LET g_body[page_cnt,l_row,i+1]= g_item_sort_1[k].zaa08 CLIPPED
                                 #ELSE
                                  #FUN-6B0006---end--- 
                                     LET i = g_body[page_cnt,l_row].getLength()
                                     LET g_body[page_cnt,l_row,i+1]= g_item_sort_1[k].zaa08 CLIPPED
                                 #END IF
                                 #FUN-660179 
                             END IF
                          END IF
                        END FOR
                     END IF
                   END IF
                   #IF NOT cl_null(l_str) THEN
                      CASE n_id_name
                        WHEN "PageHeader" 
                           IF (g_body_title_pos - 1 > cnt)  THEN
                              LET i = g_header[page_cnt].getLength()
                              LET g_header[page_cnt,i+1]= l_str CLIPPED
                           END IF
                        WHEN "PageTrailer"
                           LET i = g_trailer[page_cnt].getLength()
                           LET g_trailer[page_cnt,i+1]= l_str CLIPPED
                        OTHERWISE                 
                           IF (g_body_title_pos - 1 > cnt)  THEN
                              LET i = g_header[page_cnt].getLength()
                              LET g_header[page_cnt,i+1]= l_str CLIPPED
                           ELSE
                               IF l_pageheader= "Y"      THEN
                                  LET l_row = l_row + 1
                                  LET i = g_body[page_cnt,l_row].getLength()
                                  LET g_body[page_cnt,l_row,i+1]= ' '
                               END IF
                           END IF
                      END CASE
                      
                   #END IF
                   LET cnt=cnt+1          #FUN-570208
                 END IF
                 IF ( cnt > g_pagelen) THEN
                     LET page_cnt = page_cnt + 1
                     LET cnt= 0
                     IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                          CALL cl_progressing("process: xml")            #FUN-570141
                     END IF                   ### FUN-570264 ###
                     LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                     LET l_row = 0 
                 END IF
                 IF (cnt_noskip = 0) THEN         #FUN-570208   #TQC-5B0055
                    LET l_str = ""
                    LET l_i = 0                                 #g_item2陣列數
                    LET column_cnt = 1
                    LET l_tr = "N"  
                    LET g_sort = "N"
                    CALL g_item.clear()
                    CALL g_item2.clear()
                    CALL g_item_sort_1.clear()
                    LET l_pageheader = "Y"
                 END IF
 
 
            WHEN r.getTagName() = "PageTrailer"
                LET n_id_name = "xml"
 
            WHEN r.getTagName() = "PageHeader"
                LET n_id_name = "xml"
 
          END CASE
 
      END CASE
      LET e= r.read()
   END WHILE
   #END FUN-570208
 
END FUNCTION
 
##################################################
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_trans_contview2()
DEFINE     l_pageheader,l_tr                       LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(1),
           cnt_print,cnt_item,i,j,a,b,noskip_old   LIKE type_file.num10,       #No.FUN-690005 integer,
           l_str,value,l_cmd                       string,
           n_name,l_skip_tag                       string,
           k,column_cnt,cnt_noskip,l_start_i       LIKE type_file.num10,       #No.FUN-690005 INTEGER,
           tag,cnt,str_cnt,l_i                     LIKE type_file.num10,       #No.FUN-690005 INTEGER,
           page_cnt                                LIKE type_file.num10,       #No.FUN-690005 integer,
           l_row,l_cnt                             LIKE type_file.num10        #No.FUN-690005 INTEGER
 
DEFINE l_zaa02 DYNAMIC ARRAY WITH DIMENSION 2 OF LIKE type_file.num10          #No.FUN-690005 INTEGER
 
DEFINE l_pre_spaces LIKE type_file.num10 #No.FUN-6A0159
 
   LET l_str = ""
   #No.FUN-9B0062 -- start --
   IF os.Path.delete(output_name CLIPPED) THEN
   END IF
   #No.FUN-9B0062 -- end --
 
   #FUN-570208
   LET l_str = ""
   LET column_cnt = 1
   LET l_tr = "N"  
   LET l_pageheader = "Y"                 #FUN-5A0135
   LET page_cnt = 1
   LET l_row = 0
 
   CALL g_body_title.clear()
   CALL g_header.clear()
   CALL g_body.clear()
   CALL g_trailer.clear()
 
   LET r = om.XmlReader.createFileReader(g_xml_name_s)
   LET lsax_attrib = r.getAttributes()
   LET e = r.read()
   WHILE e IS NOT NULL
    CASE e
      WHEN "StartElement"
        CASE
          WHEN r.getTagName() = "PageTrailer"
             LET n_id_name = "PageTrailer"
 
          WHEN r.getTagName() = "PageHeader"
             LET n_id_name = "PageHeader"
 
          WHEN r.getTagName() = "Print"
             LET n_name = r.getTagName()
             LET cnt_noskip = 0
             LET g_print_name = lsax_attrib.getValue("name")
             IF (g_print_cnt = 0) AND (g_print_name IS NOT NULL)THEN
                IF noskip_old = 0 THEN          
                    LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                    LET g_print_num = g_print_int
                    #MOD-580299
                    IF g_line_seq > 1 THEN
                       FOR k = 1 to g_print_num-1
                           LET l_i = l_i + g_report_cnt[k]
                       END FOR
                    END IF
                    #END MOD-580299
                    LET l_start_i = l_i + 1
                END IF
             END IF
          WHEN r.getTagName() = "Item"
             LET value = lsax_attrib.getValue("value")
             ### 虛線不列印
             #TQC-6A0113
             #IF (value.equals(g_dash1)) OR (value.equals(g_dash CLIPPED)) OR (value.equals(g_dash2 CLIPPED))THEN       
             IF (value = g_dash1) OR (value = g_dash_out) OR (value = g_dash2_out)
             THEN
             #END TQC-6A0113
 
                 LET l_tr = "Y"
                 LET l_pageheader= "Y"     
                 LET l_str = " "
                 EXIT CASE
             END IF
             
             #FUN-690088
             #IF (value.substring(1,2) = "--") OR (value.substring(1,2) = "==")
             #   OR (value.substring(1,3) = " --") OR (value.substring(1,3)= '- -')
             #THEN
             #   LET value = g_dash CLIPPED
             #   LET l_tr = "Y"
             #   LET l_pageheader= "Y"     
             #    LET l_str = " "
             #   EXIT CASE
             #END IF
             #END FUN-690088
 
              IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱
                
                LET j = l_i + 1
                LET g_xml_value = value
                #FUN-570052
                LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                #TQC-5B0170
                IF g_zaa_dyn.getLength() > 0 THEN
                   LET g_item[j].zaa08 = g_zaa_dyn[g_page_cnt,g_xml_value]
                ELSE
                   LET g_item[j].zaa08 = g_zaa[g_xml_value].zaa08 CLIPPED
                END IF
                #END TQC-5B0170
 
                LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #MOD-580063
                LET g_item[j].column = g_c[g_xml_value]
                #END FUN-570052
                #No.FUN-6A0159 --start--
                IF g_item[j].zaa14 MATCHES '[ABCDEFQ]' THEN
                   LET l_pre_spaces = (g_item[j].zaa05 - FGL_WIDTH(g_item[j].zaa08 CLIPPED)) / 2
                   IF l_pre_spaces > 0 then
                      LET g_item[j].zaa08 = l_pre_spaces SPACES || g_item[j].zaa08 CLIPPED
                   END IF
                END IF
                #No.FUN-6A0159 --end--
                LET l_zaa02[g_item[j].zaa15,g_item[j].zaa07]=g_xml_value
                LET l_i = l_i + 1
                LET l_pageheader = "N"
             ELSE
                IF (g_print_name IS NULL ) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                   LET l_str = l_str,value
                   LET l_pageheader= "Y"     
                ELSE
                    IF l_i = 0 THEN  
                      LET l_i = l_i + 1
                    ELSE
                      IF g_item2[l_i].zaa08 IS NOT NULL THEN
                           LET value = g_item2[l_i].zaa08 CLIPPED,value
                      END IF
                    END IF
                    LET g_item2[l_i].zaa08 = value CLIPPED              ### item value
                    LET g_item2[l_i].column = column_cnt
                    LET l_pageheader= "N"
                END IF
             END IF
          WHEN r.getTagName() = "Column"
             LET value = lsax_attrib.getValue("value")
             LET column_cnt = value
             IF (g_print_name IS NULL) OR (n_id_name == "PageHeader") OR (n_id_name == "PageTrailer") THEN
                 LET str_cnt = FGL_WIDTH(l_str)
                 LET column_cnt = column_cnt - str_cnt - 1
                 #FUN-810047
                 #FOR j = 1 to column_cnt
                 #      LET l_str = l_str," "
                 #END FOR
                 LET l_str = l_str, column_cnt SPACES
                 #END FUN-810047
             ELSE
                 LET l_i = l_i + 1               #
             END IF
 
          WHEN r.getTagName() = "NoSkip"
               LET cnt_noskip = 1
 
        END CASE
 
      WHEN "EndElement"
        CASE
          WHEN r.getTagName() = "Print"
             IF ( cnt_noskip = 0 ) THEN
                IF (g_print_name IS NOT NULL) THEN
                   LET lsax_attrib = r.getAttributes()
                   LET e = r.read()
                   LET g_print_end = "Y"
                   LET g_next_name = lsax_attrib.getValue("name")
                   LET g_print_int = g_print_name.subString(2,g_print_name.getLength())
                   LET g_print_num = g_print_int
                   LET g_print_cnt = g_print_cnt + 1 
                   IF (g_print_name.subString(1,1)=g_next_name.subString(1,1)) THEN
                         LET g_next_int = g_next_name.subString(2,g_next_name.getLength())
                         LET g_next_num = g_next_int
                         IF g_next_num = g_print_num + 1 THEN
                            IF g_print_cnt = 1 THEN
                                #MOD-580299
                                IF g_line_seq = 1 AND g_print_num > 1 THEN
                                    LET g_print_start = 1
                                    LET g_print_int = 1
                                ELSE
                                    LET g_print_start = g_print_num
                                END IF
                                #END MOD-580299
                            END IF
                            LET g_print_end = "N"
                         ELSE
                             IF g_print_cnt = 1 THEN
                                #MOD-580299
                                IF g_line_seq = 1 AND g_print_num > 1 THEN
                                    LET g_print_start = 1
                                    LET g_print_int = 1
                                ELSE
                                    LET g_print_start = g_print_num
                                END IF
                                #END MOD-580299
                             END IF
                         END IF
                   ELSE
                         IF g_print_cnt = 1 THEN
                             #MOD-580299
                             IF g_line_seq = 1 AND g_print_num > 1 THEN
                                 LET g_print_start = 1
                                 LET g_print_int = 1
                             ELSE
                                 LET g_print_start = g_print_num
                             END IF
                             #END MOD-580299
                         END IF
                   END IF
               END IF
               IF ( g_print_end ="Y" ) OR g_print_name IS NULL THEN
                   #TQC-6A0113
                   #IF (l_pageheader = "Y" ) OR (l_str.equals(g_dash CLIPPED)) OR
                   #   (l_str.equals(g_dash1)) OR (l_str.equals(g_dash2 CLIPPED))
                   IF (l_pageheader = "Y" ) OR (l_str = g_dash_out) OR
                       (l_str = g_dash1) OR (l_str = g_dash2_out) THEN
                   #END TQC-6A0113
 
                   ELSE
                      IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱   #CHI-760015
                          LET l_pageheader = "N"
                      ELSE 
                        IF (n_id_name <> "PageHeader") AND (n_id_name <> "PageTrailer") THEN
                           FOR j = 1 to g_value.getLength()   
                             LET g_xml_value = g_value[j].zaa02    
                          #FUN-570052
                             LET g_item[j].zaa05 = g_zaa[g_xml_value].zaa05 CLIPPED
                             LET g_item[j].zaa06 = g_zaa[g_xml_value].zaa06 CLIPPED
                             LET g_item[j].zaa07 = g_zaa[g_xml_value].zaa07 CLIPPED
                             LET g_item[j].zaa08 = ""
                             LET g_item[j].zaa15 = g_zaa[g_xml_value].zaa15 CLIPPED
                             LET g_item[j].zaa14 = g_zaa[g_xml_value].zaa14 CLIPPED #FUN-580063
                             LET g_item[j].column = g_c[g_xml_value]
           
                           END FOR
                          #END FUN-570052
           
                           CALL g_item_sort.clear()
                           FOR k = 1 to g_item.getLength()#資料排序
                             IF g_item[k].zaa05 IS NOT NULL THEN
                               LET a = g_item[k].zaa15
                               LET b = g_item[k].zaa07
                               LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                               LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                               LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                               LET g_item_sort[a,b].column=g_item[k].column
                               LET g_item_sort[a,b].sure=g_item[k].sure
                               LET g_item_sort[a,b].zaa14 = g_item[k].zaa14 #MOD-580063
                             END IF
                           END FOR
                           CALL g_item.clear()
                           LET k = 0
                           FOR a = 1 to g_line_seq
                             FOR b = 1 to g_item_sort[a].getLength()
                              IF g_item_sort[a,b].zaa05 IS NOT NULL THEN
                                LET k = k + 1
                                LET g_item[k].zaa05 =g_item_sort[a,b].zaa05
                                LET g_item[k].zaa06 =g_item_sort[a,b].zaa06
                                LET g_item[k].zaa08 =g_item_sort[a,b].zaa08 CLIPPED
                                LET g_item[k].zaa07 = b
                                LET g_item[k].zaa15 = a
                                LET g_item[k].column=g_item_sort[a,b].column
                                LET g_item[k].sure  =g_item_sort[a,b].sure
                                LET g_item[k].zaa14 = g_item_sort[a,b].zaa14 #MOD-580063
                              END IF
                             END FOR
                           END FOR
                           LET tag = 0
                           FOR k = l_start_i TO g_item2.getLength()
                              #TQC-6B0006
                              IF  g_item2[k].column IS NULL OR g_item2[k].column <= 0 THEN
                                CALL cl_err_msg(g_item2[k].zaa08 CLIPPED,"azz-137",g_page_cnt || "|" || cnt+1,10)
                                LET INT_FLAG = 1
                                RETURN
                              END IF
                              #END TQC-6B0006
                              LET g_cnt = g_item.getLength() #TQC-950138
                              FOR j = 1 to g_cnt             #TQC-950138
                                IF (j = g_item.getLength()) AND (g_item2[k].column > g_item[j].column-1) THEN
                                   LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                   EXIT FOR
                         
                                ELSE
                                   IF (g_item2[k].column > g_item[j].column-1) AND 
                                      (g_item2[k].column < g_item[j+1].column) THEN
                                      IF (g_item[j].sure IS NULL) OR (g_item[j].sure = "") THEN
                                          LET g_item[j].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item[j].sure="Y"
                                          LET tag = j
                                      ELSE
                                          LET tag = tag + 1
                                          LET g_item[tag].zaa08 = g_item2[k].zaa08 CLIPPED
                                          LET g_item[tag].sure="Y"
                                       END IF
                         
                                     EXIT FOR
                                   END IF
                                END IF
                              END FOR
                           END FOR 
                           LET l_pageheader = "N"
                         END IF
                     END IF
                     IF l_pageheader == "N" THEN
                        FOR k = 1 to g_item.getLength()
                          IF g_item[k].zaa05 IS NOT NULL THEN
                            LET a = g_item[k].zaa15
                            LET b = g_item[k].zaa07
                            LET g_item_sort[a,b].zaa05=g_item[k].zaa05
                            LET g_item_sort[a,b].zaa06=g_item[k].zaa06
                            LET g_item_sort[a,b].zaa08=g_item[k].zaa08 CLIPPED
                            LET g_item_sort[a,b].column=g_item[k].column-g_item_sort[k,1].column
                            LET g_item_sort[a,b].sure=g_item[k].sure
                            LET g_item_sort[a,b].zaa14 = g_item[k].zaa14 #MOD-580063
                          END IF
                        END FOR
                        FOR a = 1 to g_line_seq
                           FOR b = 1 to g_item_sort[a].getLength()
                             IF g_item_sort[a,b].zaa05 IS NULL THEN
                                  CALL g_item_sort[a].deleteElement(b)
                             END IF
                           END FOR
                        END FOR
                        ## 判斷一行小計，不能上下移動，只能左右 
                        IF (g_print_name.subString(1,1)="s") AND (g_print_start=g_print_int) THEN
                           FOR a = 1 to g_line_seq
                              IF g_print_start <> a THEN
                                 FOR b = 1 to g_item_sort[a].getLength()
                                     IF g_item_sort[a,b].zaa08 IS NOT NULL THEN
                                        LET g_item_sort[g_print_start,b].zaa08 = g_item_sort[a,b].zaa08 CLIPPED
                                        LET g_item_sort[g_print_start,b].zaa05 = g_item_sort[a,b].zaa05
                                     END IF
                                 END FOR
                              END IF
                           END FOR
                        END IF
                        ## 組l_str 
                        FOR a = g_print_start to g_print_int
                          IF g_print_name.subString(1,1) <> "h" THEN
                               LET l_row = l_row + 1
                          END IF
                          FOR b = 1 to g_item_sort[a].getLength()
                             IF g_item_sort[a,b].zaa06 = 'N' THEN
                                IF (g_print_name.subString(1,1)="h") THEN       # 報表欄位名稱
                                     LET i = g_body_title[page_cnt].getLength()
                                     SELECT COUNT(*) INTO l_cnt FROM zad_file
                                     WHERE zad01 = g_prog  AND  zad02 = l_zaa02[a,b]
                                       AND zad03 = g_rlang AND  zad04 = g_zaa04_value
                                       AND zad05 = g_zaa10_value
                                       AND zad06 = g_zaa11_value AND zad07 = g_zaa17_value
                                     IF l_cnt > 0 THEN
                                         LET g_body_title[page_cnt,i+1].contview ='Y'
                                         LET g_item_sort[a,b].zaa08 = "*", g_item_sort[a,b].zaa08  CLIPPED
                                     END IF
                                     LET g_body_title[page_cnt,i+1].zaa08 = g_item_sort[a,b].zaa08 CLIPPED
                                     LET g_body_title[page_cnt,i+1].zaa05 = g_item_sort[a,b].zaa05
                                     LET g_body_title[page_cnt,i+1].zaa02 = l_zaa02[a,b]
                                ELSE
                                    #FUN-660179 
                                    ##FUN-6B0006---start--- 
                                    #IF g_aza.aza66 = 2 THEN 
                                    #   LET i = g_body[page_cnt,l_row].getLength()
                                    #   LET str_cnt = FGL_WIDTH(g_item_sort[a,b].zaa08 CLIPPED)
                                    #   IF str_cnt > g_item_sort[a,b].zaa05 THEN
                                    #         LET g_item_sort[a,b].zaa08 = ""
                                    #         FOR j = 1 to g_item_sort[a,b].zaa05
                                    #             LET g_item_sort[a,b].zaa08 = g_item_sort[a,b].zaa08, "#"
                                    #         END FOR
                                    #   END IF
                                    #   LET g_body[page_cnt,l_row,i+1]= g_item_sort[a,b].zaa08 CLIPPED
                                    #ELSE
                                    ##FUN-6B0006---end--- 
                                        LET i = g_body[page_cnt,l_row].getLength()
                                        LET g_body[page_cnt,l_row,i+1]= g_item_sort[a,b].zaa08 CLIPPED
                                    #END IF
                                    #END FUN-660179 
                                END IF
                             END IF
                          END FOR
                          LET cnt=cnt+1
                          LET l_str = ""
                        END FOR
                     END IF
                 END IF
                 CASE n_id_name
                   WHEN "PageHeader"
                      IF (g_body_title_pos - 1 > cnt)  THEN
                         LET i = g_header[page_cnt].getLength()
                         LET g_header[page_cnt,i+1]= l_str CLIPPED
                      END IF
                   WHEN "PageTrailer"
                      LET i = g_trailer[page_cnt].getLength()
                      LET g_trailer[page_cnt,i+1]= l_str CLIPPED
                   OTHERWISE
                      IF (g_body_title_pos - 1 > cnt)  THEN
                         LET i = g_header[page_cnt].getLength()
                         LET g_header[page_cnt,i+1]= l_str CLIPPED
                      ELSE
                         IF l_pageheader= "Y"      THEN
                            LET l_row = l_row + 1
                            LET i = g_body[page_cnt,l_row].getLength()
                            LET g_body[page_cnt,l_row,i+1]= l_str
                         END IF
                      END IF
                 END CASE
                 IF l_pageheader == "Y" THEN
                    LET cnt=cnt+1
                 END IF
                 IF ( cnt > g_pagelen) THEN
                    LET page_cnt = page_cnt + 1
                    LET cnt= 0
                    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   ### FUN-570264 ###
                       CALL cl_progressing("process: xml")            #FUN-570141
                    END IF                   ### FUN-570264 ###
                    LET g_page_cnt = g_page_cnt + 1         #TQC-5B0170
                    LET l_row = 0 
                 END IF
                 LET l_str = ""
                 LET l_i = 0 
                 LET column_cnt = 1
                 LET l_tr = "N"  
                 CALL g_item.clear()
                 CALL g_item2.clear()
                 CALl g_item_sort.clear()
                 LET l_pageheader = "Y"
                 LET g_print_cnt = 0
               END IF
             END IF      
             LET noskip_old = cnt_noskip
           
          WHEN r.getTagName() = "PageTrailer"
            LET n_id_name = "xml"
 
          WHEN r.getTagName() = "PageHeader"
            LET n_id_name = "xml"
 
        END CASE
 
      END CASE
      IF g_print_end IS NULL  THEN
         LET e= r.read()
      END IF
      LET g_print_end = NULL
   END WHILE
#END FUN-570208
 
END FUNCTION
#END FUN-5C0113

#No.CHI-B30026 --start--
#No:FUN-B50137
##################################################
# Descriptions...: 針對 Excel 格式報表的效能改善及保持字串空格原狀，欄位內容有空白就必須轉換為 &nbsp; 並加上 <span> 屬性。 
# Date & Author..: 11/03/14 By Echo
# Input Parameter: p_str    欲格式化的文字
# Return code....: STRING   格式化後的文字
# Usage..........: CALL cl_add_span(l_str)
# Memo...........: 
# Modify.........: 
##################################################
FUNCTION cl_add_span(p_str) 
DEFINE p_str    STRING
DEFINe l_str    STRING
                   
                   
   LET p_str = p_str.trimRight()
                   
   #若字串有空白就必須加上 <span> 屬性，並將空白轉換為 &nbsp;
   IF p_str.getIndexOf(" ",1) > 0 THEN
      LET g_bufstr = base.StringBuffer.create()             #CHI-B30026    #FUN-A20036
      CALL g_bufstr.clear()
      CALL g_bufstr.append(p_str)
      CALL g_bufstr.replace(" ","&nbsp;",0)
      CALL g_bufstr.replace("<","&lt;",0)   #CHI-CA0069
      LET l_str = g_bufstr.tostring()
      LET l_str = "<span style='mso-spacerun:yes'>", l_str, "</span>"
   ELSE
      #CHI-CA0069 -start- add 
      LET g_bufstr = base.StringBuffer.create()        
      CALL g_bufstr.clear()
      CALL g_bufstr.append(p_str)
      CALL g_bufstr.replace("<","&lt;",0)   
      LET l_str = g_bufstr.tostring()
      #LET l_str = p_str   #CHI-CA0069
      #CHI-CA0069 --end-- 
   END IF

   RETURN l_str

END FUNCTION
#No.CHI-B30026 --end--

#CHI-D20019 --start--
FUNCTION cl_trans_excel_replace_tags(p_filePath)
   DEFINE p_filePath    STRING
   DEFINE l_dstpath     STRING
   DEFINE l_arr         DYNAMIC ARRAY OF STRING
   DEFINE l_cnt         INTEGER
   DEFINE l_ch          base.Channel   
   DEFINE l_linenum1    INTEGER
   DEFINE l_linenum2    INTEGER
   DEFINE l_pos1        INTEGER
   DEFINE l_pos2        INTEGER
   DEFINE l_pos11       INTEGER
   DEFINE l_strbuf      base.StringBuffer
   DEFINE l_tempstr     STRING
   DEFINE l_i           INTEGER
   DEFINE l_findstr1    STRING
   DEFINE l_findstr2    STRING

   #讀取產生的xls檔案
   LET l_findstr1 = "<div align=center><TABLE"
   LET l_findstr2 = "</TABLE></div>"
   
   CALL l_arr.clear()
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(p_filePath,"r")
   CALL l_ch.setDelimiter("")

   LET l_cnt = 1
   LET l_pos1 = 0
   LET l_pos2 = 0
   LET l_pos11 = 0

   #找出最後一筆TABLE標籤的行數
   WHILE l_ch.isEof() = FALSE
      LET l_arr[l_cnt] = l_ch.readLine()
      LET l_pos1 = l_arr[l_cnt].getIndexOf(l_findstr1,1)
      
      IF l_pos1 >= 1 THEN
         LET l_pos2 = l_arr[l_cnt].getIndexOf(">",l_pos1 + l_findstr1.getLength())
         IF l_pos2 > l_pos1 THEN
            LET l_linenum1 = l_cnt
            LET l_tempstr = l_arr[l_cnt].subString(l_pos1,l_pos2)
         END IF
      END IF

      LET l_pos11 = l_arr[l_cnt].getIndexOf(l_findstr2,1)
      IF l_pos11 >= 1 THEN
         LET l_linenum2 = l_cnt
      END IF
      LET l_cnt = l_cnt + 1
   END WHILE
   CALL l_arr.deleteElement(l_cnt)
   CALL l_ch.close()
   
   #比對最後一筆TABLE標籤是否不含任何內容，符合的話移除這筆TABLE標籤
   LET l_strbuf = base.StringBuffer.create()
   IF l_linenum1 >= 1 AND l_linenum2 = l_linenum1 + 1 THEN
      CALL l_strbuf.append(l_arr[l_linenum1])
      CALL l_strbuf.replace(l_tempstr,"",0)
      LET l_arr[l_linenum1] = l_strbuf.toString()

      CALL l_strbuf.clear()
      CALL l_strbuf.append(l_arr[l_linenum2])
      CALL l_strbuf.replace(l_findstr2,"",0)
      LET l_arr[l_linenum2] = l_strbuf.toString()
   END IF
   
   LET l_ch = base.Channel.create()
   LET l_dstpath = p_filePath CLIPPED,".tmp"
   CALL l_ch.openFile(l_dstpath,"w")
   CALL l_ch.setDelimiter("")

   FOR l_i = 1 TO l_arr.getLength()
      CALL l_ch.writeLine(l_arr[l_i])
   END FOR
   
   CALL l_ch.close()

   IF os.Path.chrwx(l_dstpath, 511) THEN END IF
   IF os.Path.delete(p_filepath) THEN END IF
   IF os.Path.copy(l_dstpath, p_filepath) THEN END IF
END FUNCTION
#CHI-D20019 --end--
