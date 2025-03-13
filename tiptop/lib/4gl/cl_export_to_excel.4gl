# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_export_to_excel.4gl
# Descriptions...: 將單身資料匯出至 MS Excel
# Date & Author..: 2004/05/11 by CoCo
# Modify.........: No.MOD-530888 05/06/29 By coco The data title must in active window
# Modify.........: No.MOD-560298 05/06/29 By coco some tables have no hidden attribute 
# Modify.........: No.MOD-580022 05/08/02 By coco hidden title can't be print in excel 
# Modify.........: No.FUN-570216 05/08/05 By coco only one single data->html->open in excel 
#                                                      more than one single DDE to excel 
# Modify.........: No.FUN-570128 05/08/23 By coco add data type tag  
# Modify.........: No.TQC-5C0124 05/12/28 By coco 單身轉excel簡繁轉換  
# Modify.........: No.TQC-610020 06/01/05 By coco 客制欄位(ta_,tc_)的datatype  
# Modify.........: No.FUN-640001 06/04/03 By qazzaq cl_get_column_info預設資料庫為ds
# Modify.........: No.FUN-660011 06/06/12 By Echo 報表輸出到excel分為2種開啟的方式
# Modify.........: No.FUN-670054 06/07/14 By CoCo 數字太長時會變為科學符號
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.TQC-690088 06/09/21 By CoCo p_qry開窗的資料匯出到Excel需By欄位去判斷Format的格式
# Modify.........: No.TQC-6A0067 06/10/27 By Echo 因此若資料長度超過255,就不要指定儲存格的格式
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-690124 07/01/08 By Echo 單身轉Excel時,應依照畫面所顯示的欄位順序來呈現
# Modify.........: NO.FUN-640161 07/01/16 BY yiting cl_err->cl_err3
# Modify.........: NO.FUN-6B0098 07/06/11 by Echo p_qry資料設定為非hardcode程式時，匯出至Excel才需By欄位去判斷Format的格式
# Modify.........: No.TQC-790109 07/09/20 By lumxa  防止tabIndex重復導致在匯出excel時 程式down出 修改相應的算法
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810062 08/02/25 By Echo 調整 LIB 可以在 Windows 版執行
# Modify.........: No.TQC-810089 08/08/08 By tsai_yen 非CR報表簡體資料，繁體UI匯出excel亂碼，必須加字型判斷
# Modify.........: No.FUN-870086 08/09/01 By claire 欄位說明要透過傳過來的form(active form:主程式要個別處理)來取得
#                                                   MOD-530888所調整的部分要改成由主程式把active form傳給lib  
# Modify.........: No.FUN-860089 08/12/12 By Echo 新增 CR Viewer 預覽查詢功能 & table 動態排序功能
# Modify.........: No.FUN-980097 09/09/09 By alex 調整wos進入4gl
# Modify.........: No.FUN-9B0156 09/11/30 By alex 調整 FOR MSV功能
# Modify.........: No.CHI-9C0051 10/01/05 By tommas 調整隱藏資料匯出 excel  
# Modify.........: No.FUN-A10042 10/01/11 By Echo 將temptable欄位放大至2千
# Modify.........: No.FUN-A10046 10/01/11 By tommas 匯出excel時，以畫面檔的isPassword為隱藏條件
# Modify.........: No.CHI-A10019 10/02/03 By Echo 資料排序後，欄位內容有單引號時會出現sql錯誤
# Modify.........: No.CHI-A40060 10/04/28 By Alan   匯出excel時，日期格式與其他日期格式有落差
# Modify.........: No.FUN-A90047 10/09/15 By Echo 改善效能，指定 <tr> 高度值可減少開啟excel時間
# Modify.........: No.MOD-AA0168 10/11/03 By CoCo Table動態排序透過實體檔案(table)來完成
# Modify.........: No.FUN-A20036 11/05/10 By Henry 在輸出字串前後加上<span> parameter 以保持字串空格原狀
# Modify.........: No.FUN-B50137 11/06/08 By CaryHsu 增加函數說明註解
# Modify.........: No:FUN-B70007 11/07/05 By jrg542 在EXIT PROGRAM前加上CALL cl_used(2)
# Modify.........: No:FUN-BA0009 11/10/03 By kevin 資安專案
# Modify.........: No:FUN-C80070 12/08/28 By LeoChang 調整excel活頁簿名稱改為抓取系統預設的方式
# Modify.........: No:FUN-D10008 13/01/09 By joyce 個資會記錄使用者的行為模式，需說明excel的檔名及匯出excel的方式
# Modify.........: No:FUN-B40009 12/12/26 By Henry 將xls_name由模組變數改成全域變數,方便抓取檔案名稱
# Modify.........: No:CHI-D60031 13/06/21 By Cynthia 修改HTML標籤，使其符合嚴格定義，讓單身匯出Excle時，在Open Office能正確顯示匯出資料

IMPORT os          #FUN-980097
DATABASE ds        #FUN-6C0017   #FUN-7C0045  #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
GLOBALS
   DEFINE ms_codeset      STRING            ### FUN-570128 ###
   DEFINE ms_locale       STRING            ### FUN-5C0124 ###
   DEFINE g_query_prog    LIKE gcy_file.gcy01    #查詢單ID  #No.FUN-860089
   DEFINE g_query_cust    LIKE gcy_file.gcy05    #客製否    #No.FUN-860089
   DEFINE xls_name        STRING                 #No.FUN-B40009
END GLOBALS
   #DEFINE  xls_name        STRING#No.FUN-B40009    
   DEFINE  g_hidden        DYNAMIC ARRAY OF LIKE type_file.chr1,     #No.FUN-690005 VARCHAR(1),  ### MOD-580022 ### 
           g_ifchar        DYNAMIC ARRAY OF LIKE type_file.chr1,     #No.FUN-690005 VARCHAR(1),  ### FUN-570128 ### 
           g_mask          DYNAMIC ARRAY OF LIKE type_file.chr1,     #No.CHI-9C0051
           g_quote         STRING     ### FUN-570128 ### 
   DEFINE  tsconv_cmd      STRING     ### TQC-5C0124 ###
 
### FUN-570216 ### 
   DEFINE  l_channel       base.Channel,
           l_str           STRING,
           l_cmd           STRING,
           cnt_table       LIKE type_file.num10    #No.FUN-690005 integer
### FUN-570216 ### 
   DEFINE  l_win_name      STRING,                 ### TQC-690088 ###
           cnt_header      LIKE type_file.num10    ### TQC-690088 ### 
   DEFINE  g_gab07         LIKE gab_file.gab07     #FUN-6B0098
#No.FUN-860089 -- start --
   DEFINE  g_sort          RECORD
            column         LIKE type_file.num10,    #sortColumn  
            type           STRING,                 #sortType:排序方式:asc/desc
            name           STRING                  #欄位代號
                           END RECORD
#No.FUN-860089 -- end --
   DEFINE  g_sheet          STRING                   #FUN-C80070
 
# Descriptions...: 將單身資料匯出至 MS Excel
# Usage..........: CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gem),'','')

FUNCTION cl_export_to_excel(n,t,t1,t2)
 
 DEFINE  t,t1,t2,n1_text,n3_text         om.DomNode,
         n,n2,n_child                    om.DomNode,
         n1,n_table,n3                   om.NodeList,
         #i,cnt_header,res,p,q,k         LIKE type_file.num10,    #No.FUN-690005 integer,    ### MOD-580022 ### ### TQC-690088 ### 
         i,res,p,q,k                     LIKE type_file.num10,    #No.FUN-690005 integer,    ### MOD-580022 ### ### TQC-690088 ###
#         h,cnt_table,cnt_cell,tmp_cnt   LIKE type_file.num10,    #No.FUN-690005 integer,    ### FUN-570216 ###
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
### FUN-570216 ### 
         l_time                          LIKE type_file.chr8      #No.FUN-690005 VARCHAR(8)
 
### FUN-570216 ### 
 DEFINE  combo_arr        DYNAMIC ARRAY OF RECORD 
           sheet          LIKE type_file.num10,    #No.FUN-690005 integer,            #sheet
           seq            LIKE type_file.num10,    #No.FUN-690005 integer,            #項次
           name           LIKE type_file.chr2,     #No.FUN-690005 VARCHAR(2),            #代號
           text           LIKE type_file.chr50     #No.FUN-690005 VARCHAR(30)            #說明
                          END RECORD
 DEFINE  customize_table  LIKE type_file.chr1      #No.FUN-690005 VARCHAR(1)             ### TQC-610020 ###
 DEFINE  l_str            STRING                   ### TQC-610020 ###
 DEFINE  l_i              LIKE type_file.num10     ### TQC-610020 ###    #No.FUN-690005 SMALLINT
 DEFINE  buf              base.StringBuffer        ### FUN-660011 ###
 DEFINE  l_dec_point      STRING,                  ### FUN-670054 ###
         l_qry_name       LIKE gab_file.gab01,     ### TQC-690088 ###
         l_cust           LIKE gab_file.gab11      ### TQC-690088 ###
 DEFINE  l_tabIndex       LIKE type_file.num10                   #TQC-690124
 DEFINE  l_seq            DYNAMIC ARRAY OF LIKE type_file.num10  #TQC-690124
 DEFINE  l_seq2           DYNAMIC ARRAY OF LIKE type_file.num10  #TQC-690124
 DEFINE  l_j              LIKE type_file.num10      #TQC-790109
 DEFINE  bFound           LIKE type_file.num5      #TQC-790109
 DEFINE  l_dbname         STRING                   #No.FUN-810062
 DEFINE  l_zal09          LIKE zal_file.zal09      #No.FUN-860089
 DEFINE  l_desc           STRING                   #No:FUN-D10008
 
   WHENEVER ERROR CALL cl_err_msg_log             #No.FUN-860089

   IF g_prog!="p_thousand" THEN
      IF NOT cl_confirm("lib-522") THEN     #FUN-BA0009
         RETURN
      END IF
   END IF

   LET cnt_table = 1  
   LET g_quote = """"    ### FUN-570128 ###
   ### count number of data ###
   CALL cl_get_cell_cnt(t) RETURNING tmp_cnt
   LET cnt_cell = tmp_cnt 
 
   IF t1 IS NOT NULL then
      LET cnt_table = 2 
      CALL cl_get_cell_cnt(t1) RETURNING tmp_cnt
      LET cnt_cell = cnt_cell + tmp_cnt 
   END IF   
 
   IF t2 IS NOT NULL then
      LET cnt_table = 3 
      CALL cl_get_cell_cnt(t2) RETURNING tmp_cnt
      LET cnt_cell = cnt_cell + tmp_cnt 
   END IF 
 
#   display 'cnt_cell: ',cnt_cell 
   LET l_bufstr = base.StringBuffer.create()
   WHENEVER ERROR CALL cl_err_msg_log 
   LET lwin_curr = ui.window.getCurrent()   ###MOD-530888
 
### FUN-570216 ### 
   IF cnt_table = 1 THEN
      LET l_channel = base.Channel.create()
      LET l_time = TIME(CURRENT)
      LET xls_name = g_prog CLIPPED,l_time CLIPPED,".xls"

      #FUN-660011
      LET buf = base.StringBuffer.create()
      CALL buf.append(xls_name)
      CALL buf.replace( ":","-", 0)
      LET xls_name = buf.toString()
      #FUN-660011
 
      # No:FUN-D10008 ---start---
      # 個資會記錄使用者的行為模式，在此說明excel的檔名及匯出excel的方式
      LET l_desc = xls_name CLIPPED," Using HTML to export the Table to excel."
      # No:FUN-D10008 --- end ---

     #LET l_cmd = "rm ",xls_name CLIPPED," 2>/dev/null"
     #RUN l_cmd
      IF os.Path.delete(xls_name CLIPPED) THEN END IF      #FUN-980097
      CALL l_channel.openFile( xls_name CLIPPED, "a" )
      CALL l_channel.setDelimiter("")
 
      ###  TQC-5C0124 START  ###
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
      ###  TQC-5C0124 END  ###
 
      ### FUN-570128 ###
      LET l_str = "<html xmlns:o=",g_quote,"urn:schemas-microsoft-com:office:office",g_quote
      CALL l_channel.write(l_str CLIPPED)
      #LET l_str = "<meta http-equiv=Content-Type content=",g_quote,"text/html; charset=",ms_codeset,g_quote,">" #CHI-D60031 mark
      #CALL l_channel.write(l_str CLIPPED) #CHI-D60031 mark
      LET l_str = "xmlns:x=",g_quote,"urn:schemas-microsoft-com:office:excel",g_quote
      CALL l_channel.write(l_str CLIPPED)
      LET l_str = "xmlns=",g_quote,"http://www.w3.org/TR/REC-html40",g_quote,">"
      CALL l_channel.write(l_str CLIPPED)
      #CALL l_channel.write("<head><style><!--") #CHI-D60031 mark

      ###CHI-D60031 start ###
      CALL l_channel.write("<head>")
      LET l_str = "<meta http-equiv=Content-Type content=",g_quote,"text/html; charset=",ms_codeset,g_quote,">"
      CALL l_channel.write(l_str CLIPPED)
      CALL l_channel.write("<style><!--")
      ###CHI-D60031 end ###

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
      ### TQC-810089 END ###
 
      ### FUN-670054 START ###
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
                  ".xl40 {mso-style-parent:style0; mso-number-format:\"0\.0000000000_ \";} "
      ### FUN-670054 END ###
      CALL l_channel.write(l_str CLIPPED)
      CALL l_channel.write("--></style>")
      CALL l_channel.write("<!--[if gte mso 9]><xml>")
      #CALL l_channel.write("<x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>") #CHI-D60031 mark
      CALL l_channel.write("<x:ExcelWorkbook>") #CHI-D60031 add
      CALL l_channel.write("<x:DefaultRowHeight>330</x:DefaultRowHeight>")
      CALL l_channel.write("</x:ExcelWorkbook>") #CHI-D60031 add
      CALL l_channel.write("</xml><![endif]--></head>")
      ### FUN-570128 ###
      CALL l_channel.write("<body><table border=1 cellpadding=0 cellspacing=0 width=432 style='border-collapse: collapse;table-layout:fixed;width:324pt'>")
      CALL l_channel.write("<tr height=22>")          #FUN-A90047
   ELSE 
      #################
      ## start EXCEL ##
      #################
      CALL ui.Interface.frontCall("standard","shellexec",["excel"] ,res)
      CALL checkError(res)
      SLEEP 2 
      CALL cl_progress_bar(cnt_cell+1)
      CALL cl_progressing("Export data to excel....")
      SLEEP 3 
      CALL cl_getsheetname() RETURNING g_sheet  #FUN-C80070

      # No:FUN-D10008 ---start---
      # 個資會記錄使用者的行為模式，
      # 但是因為以DDE的方式無法取得excel檔的檔名，因此僅記錄匯出excel的方式
      LET l_desc = "Using DDE to export the Table to excel."
      # No:FUN-D10008 --- edn ---
   END IF 
   ### FUN-570216 ### 
 
   ### MOD-530888 ###
   #LET n = ui.Interface.getRootNode()    ##取欄位說明
   #LET n = lwin_curr.getNode()   ### FUN-870086 mark ###
   ### MOD-530888 ###
  
   ### TQC-690088 START ###
   LET l_win_name = NULL  
   LET l_win_name = n.getAttribute("name")
   IF l_win_name = "w_qry" THEN
      LET n_table = n.selectByTagName("Form")
      LET n2 = n_table.item(1)
      LET l_qry_name = n2.getAttribute("name")
      SELECT gab07,gab11 INTO g_gab07,l_cust          #FUN-6B0098
        FROM gab_file where gab01 = l_qry_name 
      IF l_cust = "" OR l_cust IS NULL THEN
         LET l_win_name = ""
      END If
      #IF STATUS THEN RETURN END IF
   END IF
   ### TQC-690088 END   ###
 
   LET n_table = n.selectByTagName("Table")
   CALL combo_arr.clear()
   FOR h=1 to cnt_table
      CALL g_hidden.clear()     ### MOD-580022 ###   
      CALL g_ifchar.clear()     ### FUN-570128 ###   
      CALL g_mask.clear()       #No.CHI-9C0051
      LET n2 = n_table.item(h)
 
      #No.FUN-860089 -- start --
      IF l_win_name = "p_dbqry_table" THEN
         LET n1 = n2.selectByPath("//TableColumn[@hidden=\"0\"]")
      ELSE
         LET n1 = n2.selectByTagName("TableColumn")
      END IF
 
      #抓取 table 是否有進行欄位排序
      INITIALIZE g_sort.* TO NULL
      LET g_sort.column = n2.getAttribute("sortColumn") 
      LET g_sort.column = -1      
      IF g_sort.column >=0 AND g_sort.column IS NOT NULL  THEN
         LET g_sort.column = g_sort.column + 1    #屬性 sortColumn 為 0 開始
         LET g_sort.type = n2.getAttribute("sortType")            
      END IF
 
      ### TQC-690088 START ###
      #IF l_win_name = "w_qry" AND g_gab07 = "N" THEN         #FUN-6B0098
      CASE
         WHEN l_win_name = "w_qry" AND g_gab07 = "N"          #FUN-6B0098
              SELECT count(*) into cnt_header FROM gac_file 
               WHERE gac01=l_qry_name AND gac12=l_cust 
              LET cnt_header = cnt_header + 1
         OTHERWISE
            LET cnt_header = n1.getLength()
      END CASE 
      #No.FUN-860089 -- end --
      ### TQC-690088 END ###
      LET l = h
      #LET sheet="Sheet" CLIPPED,l  #FUN-C80070 mark
      LET sheet=g_sheet  CLIPPED,l  #FUN-C80070
      LET cnt_combo_data = 0       ###該comboBox資料的個數
      LET cnt_combo_tot = 0   ###總comboBox資料的個數
      ### FUN-570216 START ### 
      IF cnt_table <> 1 THEN
         CALL ui.Interface.frontCall("WINDDE","DDEConnect", ["EXCEL",Sheet], res)
         CALL checkError(res)
         DISPLAY res
      END IF
      ### FUN-570216 END ### 
      LET k = 0                       ### MOD-580022 ### 
 
      #TQC-690124
      #FOR i=1 to cnt_header
      #   LET n1_text = n1.item(i)
      CALL l_seq.clear()                       
      CALL l_seq2.clear() 
#TQC-790109---start-----
{                      
      FOR i=1 to cnt_header
          LET n1_text = n1.item(i)
          LET l_tabIndex = n1_text.getAttribute("tabIndex")
          LET l_seq[l_tabIndex] = i
      END FOR
      LET p = 0
      FOR i = 1 TO l_seq.getLength()
          IF NOT cl_null(l_seq[i]) THEN
             LET p = p + 1
             LET l_seq2[l_seq[i]] = p
          END IF
      END FOR
      FOR i = 1 TO l_seq2.getLength()
          LET l_seq[l_seq2[i]] = i
      END FOR
}
     #循環Table中的每一個列       
     FOR i=1 TO cnt_header
       #得到對應的DomNode節點
       LET n1_text = n1.item(i)
       #得到該列的TabIndex屬性                                                                                                  
       LET l_tabIndex = n1_text.getAttribute("tabIndex")  
       
       #如果TabIndex屬性不為空
       IF NOT cl_null(l_tabIndex) THEN                  
          #初始化一個標志變量（表明是否在數組中找到比當前TabIndex更大的節點）
          LET bFound = FALSE
          #開始在已有的數組中定位比當前tabIndex大的成員
          FOR l_j=1 TO l_seq2.getLength()
              #如果有找到
              IF l_seq2[l_j] > l_tabIndex THEN
                 #設置標志變量
                 LET bFound = TRUE
                 #退出搜尋過程（此時下標j保存的該成員變量的位置）
                 EXIT FOR
              END IF
          END FOR
          #如果始終沒有找到（比如數組根本就是空的）那麼j里面保存的就是當前數組最大下標+1
          #判斷有沒有找到
          IF bFound THEN
             #如果找到則向該數組中插入一個元素（在這個tabIndex比它大的元素前面插入)
             CALL l_seq2.InsertElement(l_j)
             CALL l_seq.InsertElement(l_j)
          END IF
          #把當前的下標（列的位置）和tabIndex填充到這個位置上
          #如果沒有找到，則填充的位置會是整個數組的末尾
          LET l_seq[l_j] = i
          LET l_seq2[l_j] = l_tabIndex
       END IF                                                                                                 
     END FOR
#TQC-790109---end-----                  
      FOR i=1 to cnt_header
         LET n1_text = n1.item(l_seq[i])
      #END TQC-690124
         #LET j = i                   ### MOD-580022 ###
         LET k = k + 1                ### MOD-580022 ###
         LET j = k                    ### MOD-580022 ###
         LET cells = "R1C" CLIPPED,j
         #################### 
         ### Get comboBox ###
         ####################
         LET n3 = "" 
         LET n3 = n1_text.selectByPath("/TableColumn/ComboBox/Item")
         IF n3 is not NULL THEN
            LET cnt_combo_data = n3.getLength()
            FOR p = 1 to cnt_combo_data
               LET combo_arr[p+cnt_combo_tot].sheet = h 
               LET combo_arr[p+cnt_combo_tot].seq = i
               LET n3_text=n3.item(p)          
               LET combo_arr[p+cnt_combo_tot].name=n3_text.getAttribute("name")
               LET combo_arr[p+cnt_combo_tot].text=n3_text.getAttribute("text")
            END FOR
            LET cnt_combo_tot=cnt_combo_tot+p
         END IF
         
         #### MOD-530888 ####
         LET l_show = n1_text.getAttribute("hidden")
         IF l_show = "0" OR l_show IS NULL THEN  ###MOD-560298
            LET values = n1_text.getAttribute("text")
            #LET field_name = n1_text.getAttribute("name")  #No.CHI-9C0051  #FUN-A10046 mask by tommas
         #### FUN-570128 ####
            IF cnt_table = 1 THEN
               IF (l_win_name <> "w_qry") OR (l_win_name IS NULL) OR  ### TQC-690088 ###
                  (l_win_name = "w_qry" AND g_gab07 != "N" )       #FUN-6B0098
               THEN
                  LET customize_table = 0      ### TQC-610020 ### 
                  LET field_name = n1_text.getAttribute("name")
                  #display "field_name :",field_name
                  IF field_name.getIndexOf(".",1) <> 0 THEN
                     LET tmp_cnt = field_name.getIndexOf(".",1) 
                     LET field_name = field_name.subString(tmp_cnt+1, LENGTH(field_name))    
                     ### TQC-610020 START ###
                     IF field_name.getIndexOf("ta_",1) <> 0 THEN
                        IF field_name.getIndexOf("_",4) <> 0 THEN
                           LET tmp_cnt = field_name.getIndexOf("_",4)
                           LET field_name = field_name.subString(1, tmp_cnt-1)    
                        END IF
                     END IF 
                     IF field_name.getIndexOf("tc_",1) <> 0 THEN
                        LET customize_table = 1
                        IF field_name.getIndexOf("_",4) <> 0 THEN
                           LET tmp_cnt = field_name.getIndexOf("_",4)
                           LET field_name = field_name.subString(1, tmp_cnt-1)    
                        END IF
                     ELSE 
                        IF (field_name.getIndexOf("_",1) <> 0) and (field_name.getIndexOf("ta_",1) = 0) THEN
                           LET tmp_cnt = field_name.getIndexOf("_",1)
                           LET field_name = field_name.subString(1, tmp_cnt-1)    
                        END IF
                     END IF
                  END IF 
                  LET l_str =  field_name.subString(LENGTH(field_name)-3,LENGTH(field_name))
                  IF (l_str = "acti") or (l_str = "date") or (l_str = "grup") or 
                     (l_str = "modu") or (l_str = "user") or (l_str = "slip") or
                     #(l_str = "mksg")                              #TQC-690124           
                     (l_str = "mksg") or (l_str.subString(1,2) = "ud")   #CHI-A40060 
                  THEN
                     LET table_name = field_name.subString(1,LENGTH(field_name)-4),"_file"
                  ELSE
                     FOR l_i = 1 TO LENGTH(field_name) 
                        IF field_name.subString(l_i,l_i) MATCHES "[0123456789]" THEN
                           EXIT FOR
                        END IF
                     END FOR
                     LET table_name = field_name.subString(1,l_i-1),"_file"
                  END IF
                  IF table_name.getIndexOf("ta_",1) <> 0 THEN
                     LET table_name = table_name.subString(4, LENGTH(table_name))    
                  END IF
                  ### TQC-610020 END ###
                  LET l_table_name = table_name
                  LET l_field_name = field_name

               ### TQC-690088 START ###
               ELSE  
                  IF i <> 1 THEN 
                     SELECT gac05,gac06 into l_table_name,l_field_name FROM gac_file 
                      WHERE gac01=l_qry_name AND gac12=l_cust AND gac02=i-1
                  END IF
               END IF
               ### TQC-690088 END ###
               #No.FUN-810062
               CASE cl_db_get_database_type()
                 WHEN "MSV"
                    LET l_dbname =  FGL_GETENV('MSSQLAREA'),'_ds'
                 OTHERWISE
                    LET l_dbname = 'ds'
               END CASE
               CALL cl_get_column_info(l_dbname,l_table_name,l_field_name) RETURNING l_datatype,l_length
               #END No.FUN-810062
               #display "table:",l_table_name,"field:",l_field_name,"type:",
               #                 l_datatype,"length:",l_length
               IF l_datatype = "varchar2" OR l_datatype = "char" OR 
                  l_datatype = "date" OR l_datatype="datetime"       #No.FUN-810062
               THEN
                  LET g_ifchar[i] = "1"
               ### FUN-670054 START ###
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
            #### FUN-570128 ####
            CALL l_bufstr.clear()
            CALL l_bufstr.append(values)
            CALL l_bufstr.replace("+","'+",0)
            CALL l_bufstr.replace("-","'-",0)
            CALL l_bufstr.replace("=","'=",0)
            LET values = l_bufstr.tostring()
            #DISPLAY sheet,cells,values

          #### CHI-9C0051 START ####
#            IF chk_mask(field_name) THEN   #FUN-A10046  mask by tommas
            IF chk_mask(n1_text) THEN       #FUN-A10046  add by tommas
               LET g_mask[i] = "1"
            END IF
          #### CHI-9C0051 END   ###

            ### FUN-570216 ###
            IF cnt_table = 1 THEN
               LET l_str = "<td>",cl_add_span(values),"</td>"    #FUN-A20036
               CALL l_channel.write(l_str CLIPPED)
            ELSE
               CALL ui.Interface.frontCall("WINDDE","DDEPoke", ["EXCEL",sheet,cells,values], [res]);
               CALL checkError(res)
            END IF
         ### FUN-570216 ###
         ELSE    ### MOD-580022 ###
            LET g_hidden[i] = "1"
            LET k = k -1  
         END IF
      ### MOD-530888 ###
      END FOR
      ##TQC-690124
      IF h=1 THEN CALL cl_get_body(h,cnt_header,t,combo_arr,l_seq) END IF
      IF h=2 THEN CALL cl_get_body(h,cnt_header,t1,combo_arr,l_seq) END IF
      IF h=3 THEN CALL cl_get_body(h,cnt_header,t2,combo_arr,l_seq) END IF
      ##END TQC-690124
 
   END FOR

   # No:FUN-D10008 --- modify start---
   # 使用者的行為模式改到前面判斷，在此僅將前面判斷的結果說明傳至syslog中做紀錄
#  IF cl_syslog("A","G",xls_name||" has been exported.") THEN     #FUN-BA0009
   IF cl_syslog("A","G",l_desc) THEN     #FUN-BA0009
   END IF
   # No:FUN-D10008 --- modify end ---

END FUNCTION

#No:FUN-B50137
##################################################
# Private Func...: TRUE
# Descriptions...: 匯出excel時，以畫面檔的isPassword為隱藏條件
# Date & Author..: 10/01/11 By Tommas
# Input parameter: n1_text  DomNode節點
# Return code....: Boolean
# Modify ........: 
##################################################
FUNCTION chk_mask(n1_text)   #No.FUN-A10046
   DEFINE n1_text        om.DomNode
   DEFINE n1             om.DomNode
   
   LET n1 = n1_text.getFirstChild()
   IF n1.getAttribute("isPassword") = "1" THEN
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION

# Private Func...: TRUE
# Descriptions...:
# Memo...........:
# Input parameter: s
# Return code....: cnt           
 
FUNCTION cl_get_cell_cnt(s)
 DEFINE  s           om.DomNode,
         n1          om.NodeList,
         cnt         LIKE type_file.num10     #No.FUN-690005 integer
 
   LET n1 = s.selectByTagName("Field")
   LET cnt = n1.getLength()
   RETURN cnt
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...:
# Memo...........:
# Input parameter: 
# Return code....:            
FUNCTION cl_get_body(p_h,p_cnt_header,s,s_combo_arr,p_seq)  ##TQC-690124
 DEFINE  s,n1_text                          om.DomNode,
         n1                                 om.NodeList,
         i,m,k,cnt_body,res,p               LIKE type_file.num10,    #No.FUN-690005 integer,
         l_hidden_cnt,n,l_last_hidden       LIKE type_file.num10,    #No.FUN-690005 integer,  ### MOD-580022 ###
         p_h,p_cnt_header,arr_len           LIKE type_file.num10,    #No.FUN-690005 integer,
         p_null                             LIKE type_file.num10,    ### TQC-690088 ###
         cells,values,j,l,sheet             STRING,
         l_bufstr                           base.StringBuffer
 
 DEFINE  s_combo_arr    DYNAMIC ARRAY OF RECORD
          sheet         LIKE type_file.num10,    #No.FUN-690005 integer,       #sheet
          seq           LIKE type_file.num10,    #No.FUN-690005 integer,       #項次
          name          LIKE type_file.chr2,     #No.FUN-690005 VARCHAR(2),       #代號
          text          LIKE type_file.chr50     #No.FUN-690005 VARCHAR(30)       #說明
                        END RECORD
 DEFINE  p_seq          DYNAMIC ARRAY OF LIKE type_file.num10 #TQC-690124    #FUN-6B0098
 DEFINE  l_item         LIKE type_file.num10     #TQC-690124     #FUN-6B0098
 
 DEFINE  unix_path      STRING,                  #FUN-660011
         window_path    STRING                   #FUN-660011
 DEFINE  l_dom_doc      om.DomDocument,          ### TQC-690088 ###
         r,n_node       om.DomNode               ### TQC-690088 ###  
 DEFINE  l_status       LIKE type_file.num5      #No.FUN-860089
 
   #No.FUN-860089 -- start --   
   #使用 Table 動態排序功能，則資料需要重新排序
   IF NOT cl_null(g_sort.column) AND g_sort.column >=0 THEN 
      display "sort start:",time
      CALL cl_body_set_sort(p_cnt_header,s) RETURNING l_status,s
      display "sort end:",time
      IF l_status THEN 
         RETURN 
      END IF
   END IF
   #No.FUN-860089 -- end --   
 
   LET l_hidden_cnt = 0  ### MOD-580022 ###      
   LET l = p_h
   #LET sheet="Sheet" CLIPPED,l   #FUN-C80070   
   LET sheet=g_sheet CLIPPED,l   #FUN-C80070   
   LET l_bufstr = base.StringBuffer.create()
   ### TQC-690088 START ###
   #IF l_win_name = "w_qry" AND g_gab07 = "N" THEN          #FUN-6B0098
   IF (l_win_name = "w_qry" AND g_gab07 = "N" ) OR
      (l_win_name = "p_dbqry_table") OR 
      (l_win_name <> "query_w" AND NOT cl_null(g_sort.column) AND g_sort.column >=0 )   #No.FUN-860089 
   THEN      
      LET n1 = s.selectByTagName("Record")
      LET n1_text = n1.item(1)
      LET n1=n1_text.selectByTagName("Field")
      LET m = n1.getLength()
      LET n1 = s.selectByTagName("Field")
 
      LET l_dom_doc = om.DomDocument.create("qrydata")
      LET r = l_dom_doc.getDocumentElement()
      FOR i=1 to n1.getLength()
         LET n1_text = n1.item(i)
         #IF n1_text.getAttributeString("value","")<>"def" THEN
         LET k = i mod m 
         IF (k <= cnt_header) AND (k<>0) THEN 
            LET n_node = r.createChild("Field")
            CALL n_node.setAttribute("value",n1_text.getAttribute("value"))
         END IF
      END FOR
      CALL r.writeXML("test.xml")
      LET n1 = r.selectByTagName("Field")
   ELSE
      LET n1 = s.selectByTagName("Field")
   END IF
   LET l = 0
   LET i = 0 
   LET m = 0
   ### TQC-690088 END ###
 
   FOR i=1 to n1.getLength()
      ### FUN-570216 ### 
      IF cnt_table > 1 THEN
         CALL cl_progressing("Export data to excel....")    ### MOD-580022 ###
      END IF
      ### FUN-570216 ### 
 
      #LET n1_text = n1.item(i) #TQC-690124
 
      LET k = i MOD p_cnt_header
      LET m = i / p_cnt_header + 2  ##還有header
      IF k = 0 then
         LET k = p_cnt_header
         LET m = m - 1
      END IF
 
      #TQC-690124
      LET p = i / p_cnt_header
      IF k = p_cnt_header THEN 
         LET p = p - 1
      END IF
      LET l_item = p * p_cnt_header + p_seq[k]
      LET n1_text = n1.item(l_item)
      #END TQC-690124
 
      ### MOD-580022 ###
      IF g_hidden.getLength() > 0 THEN
         LET l_hidden_cnt=0
         FOR n=1 TO k
            IF g_hidden[n]=1 THEN
               LET l_hidden_cnt = l_hidden_cnt + 1    
               LET l_last_hidden = n
            END IF 
         END FOR
         IF (l_hidden_cnt > 0) AND (l_last_hidden = k) THEN 
            CONTINUE FOR 
         END IF
      END IF 
      LET l = k - l_hidden_cnt 
 ### MOD-580022 ###      
      LET j = m
      LET cells = "R",j,"C",l
 
      LET values = n1_text.getAttribute("value")

      IF cl_null(values) then
         LET values=" "
      ELSE    ###combo一定有值
         CALL l_bufstr.clear()
         CALL l_bufstr.append(values)
         CALL l_bufstr.replace("\n",",",0)
         LET values = l_bufstr.tostring()
         LET arr_len = s_combo_arr.getLength()
         #LET l = arr_len
         #display "s_combo_arr len= ",l         
         IF arr_len<>0 THEN
            FOR p = 1 to arr_len
               IF (s_combo_arr[p].sheet = p_h) AND (s_combo_arr[p].seq=k) AND (s_combo_arr[p].name=values) THEN
                  LET values = s_combo_arr[p].text
               END IF        
            END FOR 
         END IF 
      END IF

      ####  CHI-9C0051  START ####
      IF g_mask[k] IS NOT NULL THEN
         LET values = "●●●"
      END IF
      ####  CHI-9C0051  END   ####

### FUN-570216 ###
      IF cnt_table = 1 THEN
         IF l = "1" THEN
            CALL l_channel.write("</tr><tr height=22>")    #FUN-A90047
         END IF    
     ### FUN-570128 ###
         ### FUN-670054 START ### 
         IF g_ifchar[k] is null THEN
            LET l_str = "<td>",cl_add_span(values),"</td>"    #FUN-A20036
         ELSE
            IF g_ifchar[k] = "1" THEN
               #TQC-6A0067
               IF FGL_WIDTH(values) > 255 THEN
                    LET l_str = "<td>",cl_add_span(values),"</td>"    #FUN-A20036
               ELSE
                    LET l_str = "<td class=xl24>",cl_add_span(values),"</td>"     #FUN-A20036
               END IF
               #END TQC-6A0067
            ELSE 
               IF g_ifchar[k] = "A" THEN ## 1被字串用了,用A取代 ##
                  LET l_str = "<td class=xl31>",values,"</td>"
               ELSE
                  IF g_ifchar[k] = "10" THEN ##最多只會有10位小數 ##
                     LET l_str = "<td class=xl40>",values,"</td>"
                  ELSE
                     LET l_str = "<td class=xl3",g_ifchar[k] USING '<<<<<<<<<<',">",values,"</td>"
                  END IF
               END IF
            END IF
         ### FUN-670054 END ### 
         END IF
     ### FUN-570128 ###
         CALL l_channel.write(l_str CLIPPED)
      ELSE 
        CALL ui.Interface.frontCall("WINDDE","DDEPoke", ["EXCEL",Sheet,cells,values], [res])
        CALL checkError(res)
      END IF
### FUN-570216 ###
   END FOR
### FUN-570216 ###
   IF cnt_table = 1 THEN
      CALL l_channel.write("</tr></table></body></html>")
      CALL l_channel.close()
    ###  TQC-5C0124 START  ###
      CALL cl_prt_convert(xls_name)  ### TQC-5C0124 ###
      #IF tsconv_cmd IS NULL THEN
      #   LET l_str = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", xls_name CLIPPED,".ts"
      #ELSE
#FUN-660011
      #  LET l_str = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", xls_name CLIPPED
      #END IF
    ###  TQC-5C0124 END  ###
 
      #CALL ui.Interface.frontCall("standard",
      #                         "shellexec",
      #                         ["EXPLORER \"" || l_str || "\""],
      #                         [res])
      #IF STATUS THEN
      #   CALL cl_err("Front End Call failed.", STATUS, 1)
      #   RETURN
      #END IF
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
           #LET unix_path = "$TEMPDIR/",xls_name CLIPPED
            LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)   #FUN-980097
 
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
            #FUN-980097 此處為組出 URL Address,不需代換
            LET l_str = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", xls_name CLIPPED
            IF g_prog!="p_thousand" THEN
               CALL ui.Interface.frontCall("standard",
                                        "shellexec",
                                        ["EXPLORER \"" || l_str || "\""],
                                        [res])
            END IF
            IF STATUS THEN
               CALL cl_err("Front End Call failed.", STATUS, 1)
               RETURN
            END IF
       END IF
#END FUN-660011
   ELSE
      CALL ui.Interface.frontCall("WINDDE","DDEFinish", ["EXCEL",Sheet], [res] )
      CALL checkError(res)
   END IF
### FUN-570216 ###
END FUNCTION

### MOD-AA0168 mark START ###                                                                
#NO.FUN-860089 -- start -- 
# Private Func...: TRUE
# Descriptions...: 使用 Table 動態排序功能，則資料需要重新排序
# Memo...........:
# Input parameter: 
# Return code....:            

#FUNCTION cl_body_set_sort(p_cnt_header,s)
#   DEFINE s                    om.DomNode               #報表資料
#   DEFINE p_cnt_header         LIKE type_file.num10     #欄位個數
#   DEFINE n_field              om.DomNode,
#          n_record             om.DomNode,
#          nl_record            om.NodeList,
#          nl_field             om.NodeList
#   DEFINE l_i                  LIKE type_file.num10    
#   DEFINE l_j                  LIKE type_file.num10    
#   DEFINE l_value              STRING
#   DEFINE l_sql                STRING
#   DEFINE l_table_data DYNAMIC ARRAY OF RECORD
#      field001, field002, field003, field004, field005, field006, field007,
#      field008, field009, field010, field011, field012, field013, field014,
#      field015, field016, field017, field018, field019, field020, field021,
#      field022, field023, field024, field025, field026, field027, field028,
#      field029, field030, field031, field032, field033, field034, field035,
#      field036, field037, field038, field039, field040, field041, field042,
#      field043, field044, field045, field046, field047, field048, field049,
#      field050, field051, field052, field053, field054, field055, field056,
#      field057, field058, field059, field060, field061, field062, field063,
#      field064, field065, field066, field067, field068, field069, field070,
#      field071, field072, field073, field074, field075, field076, field077,
#      field078, field079, field080, field081, field082, field083, field084,
#      field085, field086, field087, field088, field089, field090, field091,
#      field092, field093, field094, field095, field096, field097, field098,
#      field099, field100  LIKE gaq_file.gaq05    #FUN-A10042
#                               END RECORD
#   DEFINE l_bufstr                        base.StringBuffer   #No.CHI-A10019
#
#   #建立 TempTable
#   DROP TABLE temp_sort
#   LET l_sql = "CREATE TEMP TABLE temp_sort("
#
#   CASE cl_db_get_database_type()   #FUN-9B0156
#      WHEN "MSV"
#         FOR l_i = 1 TO p_cnt_header 
#            IF l_i = p_cnt_header THEN    
#               LET l_sql = l_sql, "feild",l_i USING "&&&"," NVARCHAR(2000))"  #FUN-A10042
#            ELSE
#               LET l_sql = l_sql, "feild",l_i USING "&&&"," NVARCHAR(2000),"  #FUN-A10042
#            END IF
#         END FOR
#
#      OTHERWISE
#         FOR l_i = 1 TO p_cnt_header 
#            IF l_i = p_cnt_header THEN    
#               LET l_sql = l_sql, "feild",l_i USING "&&&"," VARCHAR(2000))"  #FUN-A10042
#            ELSE
#               LET l_sql = l_sql, "feild",l_i USING "&&&"," VARCHAR(2000),"  #FUN-A10042
#            END IF
#         END FOR
#   END CASE
#
#   PREPARE temp_sort_1 FROM l_sql
#   IF SQLCA.sqlcode != 0 THEN
#      CALL cl_err('create temp_sort:',SQLCA.sqlcode,1)
#      RETURN 1,s
#   END IF
#   EXECUTE temp_sort_1
#    
#   LET l_bufstr = base.StringBuffer.create()   #No.CHI-A10019
#
#   #抓取資料並將資料存至 temptable
#   LET nl_record = s.selectByTagName("Record")
#   FOR l_i=1 to nl_record.getLength()
#       LET l_sql = "INSERT INTO temp_sort VALUES(" 
#       LET n_record = nl_record.item(l_i)
#       LET nl_field=n_record.selectByTagName("Field")
#       FOR l_j = 1 TO p_cnt_header
#           LET n_field = nl_field.item(l_j)
#           LET l_value = n_field.getAttribute("value")
#
#           #No.CHI-A10019 -- start --
#           CALL l_bufstr.clear()
#           CALL l_bufstr.append(l_value)
#           CALL l_bufstr.replace("\n",",",0)
#           CALL l_bufstr.replace('\'','\'\'',0)
#           LET l_value = l_bufstr.tostring()
#           #No.CHI-A10019 -- end --
#
#           IF l_j = p_cnt_header THEN
#              LET l_sql = l_sql,"'",l_value CLIPPED,"')"
#           ELSE
#              LET l_sql = l_sql,"'",l_value CLIPPED,"',"
#           END IF
#       END FOR
#       #display l_sql
#       EXECUTE IMMEDIATE l_sql
#       IF SQLCA.SQLCODE THEN
#          CALL cl_err("insert temp_sort:",SQLCA.SQLCODE,1)
#          RETURN 1,s
#       END IF       
#   END FOR
# 
#   #重新讀取排序後的資料
#   CALL l_table_data.clear()
#   LET l_sql = "SELECT * FROM temp_sort ",
#               " ORDER BY ",g_sort.column CLIPPED," ",g_sort.type CLIPPED
#   #display l_sql
#   PREPARE table_pre FROM l_sql
#   DECLARE table_cur CURSOR FOR table_pre
#   IF SQLCA.SQLCODE THEN
#      CALL cl_err('table_cur',sqlca.sqlcode,1)
#      RETURN 1,s
#   END IF
#   LET l_i = 1
#   FOREACH table_cur INTO l_table_data[l_i].*
#       LET l_i = l_i + 1
#   END FOREACH         
#   CALL l_table_data.deleteElement(l_i)
#   
#   RETURN 0,base.TypeInfo.create(l_table_data)
#END FUNCTION
#NO.FUN-860089 -- end  -- 
### MOD-AA0168 mark END ###                                                                     
                                                                                                
### MOD-AA0168 START ###                                                                        
# Private Func...: TRUE                                                                         
# Descriptions...: 使用 Table 動態排序功能，則資料需要重新排序                                  
# Memo...........:                                                                              
# Input parameter:                                                                              
# Return code....:                                                                              
FUNCTION cl_body_set_sort(p_cnt_header,s)                                                       
   DEFINE s                    om.DomNode               #報表資料                               
   DEFINE p_cnt_header         LIKE type_file.num10     #欄位個數                               
   DEFINE n_field              om.DomNode,                                                      
          n_record             om.DomNode,                                                      
          nl_record            om.NodeList,                                                     
          nl_field             om.NodeList                                                      
   DEFINE l_i                  LIKE type_file.num10                                             
   DEFINE l_j                  LIKE type_file.num10                                             
   DEFINE l_value              STRING                                                           
   DEFINE l_sql                STRING                                                           
   DEFINE l_pid                LIKE gdn_file.gdn01                                 
   DEFINE l_gdn         RECORD LIKE gdn_file.*                                   
   DEFINE l_gdn1        RECORD LIKE gdn_file.*                                    
   DEFINE sr            DYNAMIC ARRAY OF RECORD                                                
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
      field099, field100  LIKE gaq_file.gaq05                                        
                               END RECORD                                                       
   DEFINE l_bufstr             base.StringBuffer                                  
                                                                                                
   LET l_pid = FGL_GETPID()                                                     
   LET l_bufstr = base.StringBuffer.create()                                     
                                                                                                
   #抓取資料並將資料存至 table   
   display "save table:",time                                                               
   LET nl_record = s.selectByTagName("Record")                                                  
   display "select by tag table:",time                                                               

   FOR l_i=1 to nl_record.getLength()                                                           
       LET n_record = nl_record.item(l_i)                                                       
       LET nl_field=n_record.selectByTagName("Field")                                           
       FOR l_j = 1 TO p_cnt_header                                                              
           LET l_sql = "INSERT INTO gdn_file VALUES("                           
           LET n_field = nl_field.item(l_j)                                                     
           LET l_value = n_field.getAttribute("value")                                          
                                                                                                
           CALL l_bufstr.clear()                                                                
           CALL l_bufstr.append(l_value)                                                        
           CALL l_bufstr.replace("\n",",",0)                                                    
           CALL l_bufstr.replace('\'','\'\'',0)                                                 
           LET l_value = l_bufstr.tostring()                                                    
                                                                                                
           LET l_sql = l_sql,l_pid,",",l_i,",",l_j,",'",l_value CLIPPED,"')"                    
           EXECUTE IMMEDIATE l_sql                                                              
           IF SQLCA.SQLCODE THEN                                                                
              CALL cl_err("insert gdn_file:",SQLCA.SQLCODE,1)                    
              RETURN 1,s                                                                        
           END IF                                                                               
       END FOR                                                                                  
   END FOR                                                                                      
                                                                                                
   #重新讀取排序後的資料    
   #display "order table:",time                                                               
   CALL sr.clear()                                                                              
   #EX:select gdn04 from gdn_file where gdn03=2 order by gdn04;                                 
   LET l_sql = "SELECT gdn01,gdn02,gdn03,gdn04 FROM gdn_file WHERE gdn01=",l_pid,               
               " AND gdn03=",g_sort.column CLIPPED,                                             
               " ORDER BY gdn04 ",g_sort.type CLIPPED                                           
   #display l_sql                                                                                
   PREPARE table_pre FROM l_sql                                                                 
   DECLARE table_cur CURSOR FOR table_pre                                                       
   IF SQLCA.SQLCODE THEN                                                                        
      CALL cl_err('table_cur',sqlca.sqlcode,1)                                                  
      RETURN 1,s                                                                                
   END IF                                                                                       
   LET l_i = 1                                                                                  
   FOREACH table_cur INTO l_gdn.*                                                               
      #display "l_gdn.gdn04:",l_gdn.gdn04                                                        
      LET l_sql = "SELECT gdn03,gdn04 FROM gdn_file WHERE gdn01=",l_gdn.gdn01,                  
                  " AND gdn02=",l_gdn.gdn02," ORDER BY gdn03"                                   
      PREPARE gdn_pre FROM l_sql                                                                
      DECLARE gdn_cur CURSOR FOR gdn_pre                                                        
      IF SQLCA.SQLCODE THEN                                                                     
         CALL cl_err('gdn_cur',sqlca.sqlcode,1)                                                 
         RETURN 1,s                                                                             
      END IF                                                                                    
      FOREACH gdn_cur INTO l_gdn1.gdn03,l_gdn1.gdn04                                            
         CASE l_gdn1.gdn03                                                                      
            WHEN   1 LET sr[l_i].field001 = l_gdn1.gdn04                                        
            WHEN   2 LET sr[l_i].field002 = l_gdn1.gdn04                                        
            WHEN   3 LET sr[l_i].field003 = l_gdn1.gdn04                                        
            WHEN   4 LET sr[l_i].field004 = l_gdn1.gdn04                                        
            WHEN   5 LET sr[l_i].field005 = l_gdn1.gdn04                                        
            WHEN   6 LET sr[l_i].field006 = l_gdn1.gdn04                                        
            WHEN   7 LET sr[l_i].field007 = l_gdn1.gdn04                                        
            WHEN   8 LET sr[l_i].field008 = l_gdn1.gdn04                                        
            WHEN   9 LET sr[l_i].field009 = l_gdn1.gdn04                                        
            WHEN  10 LET sr[l_i].field010 = l_gdn1.gdn04                                        
            WHEN  11 LET sr[l_i].field011 = l_gdn1.gdn04                                        
            WHEN  12 LET sr[l_i].field012 = l_gdn1.gdn04                                        
            WHEN  13 LET sr[l_i].field013 = l_gdn1.gdn04                                        
            WHEN  14 LET sr[l_i].field014 = l_gdn1.gdn04                                        
            WHEN  15 LET sr[l_i].field015 = l_gdn1.gdn04                                        
            WHEN  16 LET sr[l_i].field016 = l_gdn1.gdn04                                        
            WHEN  17 LET sr[l_i].field017 = l_gdn1.gdn04                                        
            WHEN  18 LET sr[l_i].field018 = l_gdn1.gdn04                                        
            WHEN  19 LET sr[l_i].field019 = l_gdn1.gdn04                                        
            WHEN  20 LET sr[l_i].field020 = l_gdn1.gdn04                                        
            WHEN  21 LET sr[l_i].field021 = l_gdn1.gdn04                                        
            WHEN  22 LET sr[l_i].field022 = l_gdn1.gdn04                                        
            WHEN  23 LET sr[l_i].field023 = l_gdn1.gdn04                                        
            WHEN  24 LET sr[l_i].field024 = l_gdn1.gdn04                                        
            WHEN  25 LET sr[l_i].field025 = l_gdn1.gdn04                                        
            WHEN  26 LET sr[l_i].field026 = l_gdn1.gdn04                                        
            WHEN  27 LET sr[l_i].field027 = l_gdn1.gdn04                                        
            WHEN  28 LET sr[l_i].field028 = l_gdn1.gdn04                                        
            WHEN  29 LET sr[l_i].field029 = l_gdn1.gdn04                                        
            WHEN  30 LET sr[l_i].field030 = l_gdn1.gdn04                                        
            WHEN  31 LET sr[l_i].field031 = l_gdn1.gdn04                                        
            WHEN  32 LET sr[l_i].field032 = l_gdn1.gdn04                                        
            WHEN  33 LET sr[l_i].field033 = l_gdn1.gdn04                                        
            WHEN  34 LET sr[l_i].field034 = l_gdn1.gdn04                                        
            WHEN  35 LET sr[l_i].field035 = l_gdn1.gdn04                                        
            WHEN  36 LET sr[l_i].field036 = l_gdn1.gdn04                                        
            WHEN  37 LET sr[l_i].field037 = l_gdn1.gdn04                                        
            WHEN  38 LET sr[l_i].field038 = l_gdn1.gdn04                                        
            WHEN  39 LET sr[l_i].field039 = l_gdn1.gdn04                                        
            WHEN  40 LET sr[l_i].field040 = l_gdn1.gdn04                                        
            WHEN  41 LET sr[l_i].field041 = l_gdn1.gdn04                                        
            WHEN  42 LET sr[l_i].field042 = l_gdn1.gdn04                                        
            WHEN  43 LET sr[l_i].field043 = l_gdn1.gdn04                                        
            WHEN  44 LET sr[l_i].field044 = l_gdn1.gdn04                                        
            WHEN  45 LET sr[l_i].field045 = l_gdn1.gdn04                                        
            WHEN  46 LET sr[l_i].field046 = l_gdn1.gdn04                                        
            WHEN  47 LET sr[l_i].field047 = l_gdn1.gdn04                                        
            WHEN  48 LET sr[l_i].field048 = l_gdn1.gdn04                                        
            WHEN  49 LET sr[l_i].field049 = l_gdn1.gdn04                                        
            WHEN  50 LET sr[l_i].field050 = l_gdn1.gdn04                                        
            WHEN  51 LET sr[l_i].field051 = l_gdn1.gdn04                                        
            WHEN  52 LET sr[l_i].field052 = l_gdn1.gdn04                                        
            WHEN  53 LET sr[l_i].field053 = l_gdn1.gdn04                                        
            WHEN  54 LET sr[l_i].field054 = l_gdn1.gdn04                                        
            WHEN  55 LET sr[l_i].field055 = l_gdn1.gdn04                                        
            WHEN  56 LET sr[l_i].field056 = l_gdn1.gdn04                                        
            WHEN  57 LET sr[l_i].field057 = l_gdn1.gdn04                                        
            WHEN  58 LET sr[l_i].field058 = l_gdn1.gdn04                                        
            WHEN  59 LET sr[l_i].field059 = l_gdn1.gdn04                                        
            WHEN  60 LET sr[l_i].field060 = l_gdn1.gdn04                                        
            WHEN  61 LET sr[l_i].field061 = l_gdn1.gdn04                                        
            WHEN  62 LET sr[l_i].field062 = l_gdn1.gdn04                                        
            WHEN  63 LET sr[l_i].field063 = l_gdn1.gdn04                                        
            WHEN  64 LET sr[l_i].field064 = l_gdn1.gdn04                                        
            WHEN  65 LET sr[l_i].field065 = l_gdn1.gdn04                                        
            WHEN  66 LET sr[l_i].field066 = l_gdn1.gdn04                                        
            WHEN  67 LET sr[l_i].field067 = l_gdn1.gdn04                                        
            WHEN  68 LET sr[l_i].field068 = l_gdn1.gdn04                                        
            WHEN  69 LET sr[l_i].field069 = l_gdn1.gdn04                                        
            WHEN  70 LET sr[l_i].field070 = l_gdn1.gdn04                                        
            WHEN  71 LET sr[l_i].field071 = l_gdn1.gdn04                                        
            WHEN  72 LET sr[l_i].field072 = l_gdn1.gdn04                                        
            WHEN  73 LET sr[l_i].field073 = l_gdn1.gdn04                                        
            WHEN  74 LET sr[l_i].field074 = l_gdn1.gdn04                                        
            WHEN  75 LET sr[l_i].field075 = l_gdn1.gdn04                                        
            WHEN  76 LET sr[l_i].field076 = l_gdn1.gdn04                                        
            WHEN  77 LET sr[l_i].field077 = l_gdn1.gdn04                                        
            WHEN  78 LET sr[l_i].field078 = l_gdn1.gdn04                                        
            WHEN  79 LET sr[l_i].field079 = l_gdn1.gdn04                                        
            WHEN  80 LET sr[l_i].field080 = l_gdn1.gdn04                                        
            WHEN  81 LET sr[l_i].field081 = l_gdn1.gdn04                                        
            WHEN  82 LET sr[l_i].field082 = l_gdn1.gdn04                                        
            WHEN  83 LET sr[l_i].field083 = l_gdn1.gdn04                                        
            WHEN  84 LET sr[l_i].field084 = l_gdn1.gdn04                                        
            WHEN  85 LET sr[l_i].field085 = l_gdn1.gdn04                                        
            WHEN  86 LET sr[l_i].field086 = l_gdn1.gdn04                                        
            WHEN  87 LET sr[l_i].field087 = l_gdn1.gdn04                                        
            WHEN  88 LET sr[l_i].field088 = l_gdn1.gdn04                                        
            WHEN  89 LET sr[l_i].field089 = l_gdn1.gdn04                                        
            WHEN  90 LET sr[l_i].field090 = l_gdn1.gdn04                                        
            WHEN  91 LET sr[l_i].field091 = l_gdn1.gdn04                                        
            WHEN  92 LET sr[l_i].field092 = l_gdn1.gdn04                                        
            WHEN  93 LET sr[l_i].field093 = l_gdn1.gdn04                                        
            WHEN  94 LET sr[l_i].field094 = l_gdn1.gdn04                                        
            WHEN  95 LET sr[l_i].field095 = l_gdn1.gdn04                                        
            WHEN  96 LET sr[l_i].field096 = l_gdn1.gdn04                                        
            WHEN  97 LET sr[l_i].field097 = l_gdn1.gdn04                                        
            WHEN  98 LET sr[l_i].field098 = l_gdn1.gdn04                                        
            WHEN  99 LET sr[l_i].field099 = l_gdn1.gdn04                                        
            WHEN 100 LET sr[l_i].field100 = l_gdn1.gdn04                                        
         END CASE                                                                               
      END FOREACH                                                                               
      LET l_i = l_i + 1                                                                         
   END FOREACH  
                                                                                   
   #display "finish order table:",time                                                               
   CALL sr.deleteElement(l_i)                                                                   
                                                                                                
   DELETE FROM gdn_file WHERE gdn01 = l_pid                                                     
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN                                                  
      CALL cl_err3("del","gdn_file",l_pid,"",SQLCA.sqlcode,"","",0)                             
   END IF                                                                                       
                                                                                                
   RETURN 0,base.TypeInfo.create(sr)                                                            
END FUNCTION                                                                                    
### MOD-AA0168 END ###                                                                          

# Private Func...: TRUE
# Descriptions...:
# Memo...........:
# Input parameter: 
# Return code....:            
FUNCTION checkError(res)
   DEFINE res  LIKE type_file.num10    #No.FUN-690005 INTEGER
   DEFINE mess STRING
   IF res THEN RETURN END IF
   DISPLAY "DDE Error:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[mess]);
   DISPLAY mess
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll", [], [res] );
   DISPLAY "Exit with DDE Error."
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B70007
   EXIT PROGRAM (-1)
END FUNCTION

###FUN-C80070 add start
FUNCTION cl_getsheetname()
   DEFINE   l_rval  STRING                       
   DEFINE   l_val   STRING                       
   DEFINE   l_val1  STRING                       
   DEFINE   l_str1  STRING 
   DEFINE   res     LIKE type_file.num10
   DEFINE   l_i              LIKE type_file.num10
   DEFINE   l_sheet STRING
   
      CALL ui.Interface.frontCall("WINDDE","DDEConnect", ["excel", "system"], res )
      CALL checkError(res)
      CALL ui.Interface.frontCall("WINDDE","DDEPeek", ["excel","system","topics"], [res,l_rval] );
      IF l_rval IS NOT NULL THEN 
         LET l_val=l_rval.getIndexOf("]",1)
         LET l_rval=l_rval.subString(l_val+1,length(l_rval))
         LET l_val=l_rval.getIndexOf("]",1)
         LET l_rval=l_rval.subString(l_val+1,length(l_rval))
         LET l_val1=l_rval.getIndexOf("[",1)
         LET l_sheet=l_rval.subString(1,l_val1-1) 
      END IF 
      CALL checkError(res)
      FOR l_i=1 TO l_sheet.getlength()
         LET l_str1=l_sheet.getCharAt(l_i)
         IF ORD(l_str1) > 47 AND ORD(l_str1) < 58 THEN 
            LET l_sheet=l_sheet.subString(1,l_i-1)
            EXIT FOR 
         END IF 
      END FOR
      CALL ui.Interface.frontCall("WINDDE","DDEFinish", ["EXCEL","system"], [res] );
      RETURN l_sheet
END FUNCTION
###FUN-C80070 add end  
