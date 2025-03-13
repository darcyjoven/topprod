# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Library name...: cl_chart
# Descriptions...: 動態圖表
# Usage .........: 
# Date & Author..: 11/04/14 By tommas
# Modify.........: No.FUN-BA0079 11/11/02 By tommas 將SUB的function使用include方式載入

DATABASE ds

GLOBALS "../../config/top.global"

TYPE t_attribute  RECORD
         attr_name  STRING, #屬性名稱
         attr_value STRING  #屬性值
         END RECORD
TYPE t_dataset  RECORD
        series_name     STRING,                     #<dataset seriesName=... (key)
        series_attrs  DYNAMIC ARRAY OF t_attribute, #<dataset color=...  屬性值
        data_values   DYNAMIC ARRAY OF STRING,      #<dataset><set value=...
        data_attr     DYNAMIC ARRAY OF STRING       #<dataset><set color=...  #set的屬性
        END RECORD
        
GLOBALS DEFINE 
   g_chartxml_h    DYNAMIC ARRAY OF RECORD          #存放WebComponent的資料
      chart_name   STRING,                          # webComponent name (key)
      gfn02        LIKE gfn_file.gfn01,             # Chart名稱, Ex. MSLine3, Col3D2…
      chart_attr   DYNAMIC ARRAY OF t_attribute     # Chart屬性, Ex. caption + subcaption 
                   END RECORD,
   # 這裡將資料分開成一筆筆存放
   g_chartxml_d         DYNAMIC ARRAY OF RECORD       #存放各個WebComponent的數列及屬性
      chart_name        STRING,                       # webComponent name (key)
      chart_categories  DYNAMIC ARRAY OF STRING,
      categories_attrs  DYNAMIC ARRAY OF t_attribute, #<categories fontColor=...
      category_attrs    DYNAMIC ARRAY OF STRING,      #<category label=...,showLabel=...
      dataset           DYNAMIC ARRAY OF t_dataset    # 資料屬性 
      END RECORD,
   g_chartxml_e    DYNAMIC ARRAY OF RECORD
      chart_name   STRING,     # webComponent name (key)
      ex_attname   STRING,     # 額外設定屬性, Ex. CaptionFontSize,… (key)
      ex_attvalue  STRING      # 額外設定屬性值, Ex. 15, #000000
                   END RECORD,
   g_chart_trendlines DYNAMIC ARRAY OF RECORD  #存放各個WebComponent的趨勢線
      tr_lines           DYNAMIC ARRAY OF RECORD
         other             STRING,
         attrs             DYNAMIC ARRAY OF t_attribute
                         END RECORD
                   END RECORD,
   g_chart_styles  DYNAMIC ARRAY OF RECORD   #存放各個WebComponent的風格
      styles          DYNAMIC ARRAY OF t_attribute
                   END RECORD,
   g_gauge         RECORD                    #用來存放燈號及儀表板資料
                   label  STRING,            #標題
                   value  INTEGER,           #值
                   low    INTEGER,           #低值(33:0~33)
                   medium INTEGER,           #中值(66:33~66)
                   high   INTEGER,           #高值(100:66~100)
                   start  INTEGER,           #起始值(0)
                   end    INTEGER            #最終值(100)
                   END RECORD 
END GLOBALS

#No.FUN-BA0079
&include "cl_chart_marco_when.4gl"

FUNCTION cl_chart_init(ps_comp)
   DEFINE ps_comp    STRING
   CALL cl_chart_init_comp(ps_comp)
END FUNCTION
FUNCTION cl_chart_init_comp(ps_comp)
   DEFINE ps_comp        STRING
   DEFINE li_chart_idx   INTEGER

   LET li_chart_idx = cl_chart_find_wc(ps_comp)
   # 沒有資料就新設一筆
   IF li_chart_idx = 0 THEN
      LET li_chart_idx = g_chartxml_h.getLength() + 1
      LET g_chartxml_h[li_chart_idx].chart_name = ps_comp
   ELSE
      CALL g_chartxml_h[li_chart_idx].chart_attr.clear()
      LET g_chartxml_h[li_chart_idx].gfn02 = ""
      CALL g_chartxml_d[li_chart_idx].chart_categories.clear()
      CALL g_chartxml_d[li_chart_idx].categories_attrs.clear()
      CALL g_chartxml_d[li_chart_idx].category_attrs.clear()
      CALL g_chartxml_d[li_chart_idx].dataset.clear()
   END IF
END FUNCTION

FUNCTION cl_initChart()
   # 清除所有共用變數值
   CALL g_chartxml_h.clear()
   CALL g_chartxml_d.clear()
END FUNCTION

################################################## 
# Descriptions...: 指定圖表的屬性
# Date & Author..: 2011/04/14 by tommas
# Input Parameter: ps_attrName      屬性名稱
#                  ps_attrValue     屬性值
# Return code....: none
# Usage..........: cl_chart_attr("caption", "料件庫存計劃狀況")
##################################################
#屬性設定已經由另一支程式取代
FUNCTION cl_chart_attr(ps_comp,ps_attrName, ps_attrValue)
   DEFINE ps_attrName      STRING,
          ps_attrValue     STRING,
          ps_comp          STRING
   CALL cl_chart_attr_comp(ps_comp,ps_attrName, ps_attrValue)
END FUNCTION
FUNCTION cl_chart_attr_comp(ps_comp, ps_attrName, ps_attrValue)
   DEFINE ps_comp      STRING,
          ps_attrName      STRING,
          ps_attrValue STRING
   DEFINE li_i         INTEGER
   DEFINE li_chart_idx INTEGER,
          li_exatt_idx INTEGER,
          li_attr_idx  INTEGER
# 傳入的屬性最後要產生在<chart> tag內的xml
   # 判斷是否已經有欲設定圖表的資料存在

   LET ps_attrName = ps_attrName.toLowerCase()

  LET ps_attrValue = cl_chart_replace_char(ps_attrValue)
  LET li_chart_idx = cl_chart_find_wc(ps_comp)
   # 沒有資料就新設一筆
   IF li_chart_idx = 0 THEN
      LET li_chart_idx = g_chartxml_h.getLength() + 1
      LET g_chartxml_h[li_chart_idx].chart_name = ps_comp
   END IF
   # 依照所要設定的property，放在g_chartxml_h應屬的變數內

         LET li_attr_idx = 0
         FOR li_i = 1 TO g_chartxml_h[li_chart_idx].chart_attr.getLength()
            IF g_chartxml_h[li_chart_idx].chart_attr[li_i].attr_name == ps_attrName THEN
               LET li_attr_idx = li_i
               EXIT FOR
            END IF
         END FOR
         IF li_attr_idx == 0 THEN
            LET li_attr_idx = g_chartxml_h[li_chart_idx].chart_attr.getLength() + 1
         END IF         
         LET g_chartxml_h[li_chart_idx].chart_attr[li_attr_idx].attr_name = ps_attrName
         LET g_chartxml_h[li_chart_idx].chart_attr[li_attr_idx].attr_value = ps_attrValue

END FUNCTION

#轉換會造成javascript錯誤的特殊字元如' " < > &
FUNCTION cl_chart_replace_char(ps_str)
   DEFINE ps_str  STRING
   DEFINE l_sb    base.StringBuffer
   LET l_sb = base.StringBuffer.create()
   CALL l_sb.append(ps_str)
   CALL l_sb.replace("&", "&amp;", 0)
   CALL l_sb.replace(">", "&gt;", 0)
   CALL l_sb.replace("<", "&lt;", 0)
   CALL l_sb.replace("'", "&apos;", 0)
   CALL l_sb.replace("\"", "&quot;", 0)
   RETURN l_sb.toString()
END FUNCTION

################################################## 
# Descriptions...: 指定數列的屬性
# Date & Author..: 2011/04/14 by tommas
# Input Parameter: ps_data_serial  該數列的名稱
#                  ps_attname      屬性名稱
#                  ps_attvalue     屬性值
# Return code....: none
# Usage..........: cl_chart_array_attr("安全庫存量","parentYAxis","P")
##################################################
#屬性設定已經由另一支程式取代
FUNCTION cl_chart_array_attr(ps_comp, ps_data_serial, ps_attname, ps_attvalue)
   DEFINE ps_data_serial  STRING, #dataset series name
          ps_comp         STRING,
          ps_attname  STRING, #dataset attribute name
          ps_attvalue STRING  #dataset attribute value
   CALL cl_chart_array_attr_comp(ps_comp, ps_data_serial, ps_attname, ps_attvalue)
END FUNCTION
FUNCTION cl_chart_array_attr_comp(ps_comp, ps_data_serial, ps_attname, ps_attvalue)
   DEFINE ps_comp     STRING, #WebComponent
          ps_data_serial  STRING, #dataset series name
          ps_attname  STRING, #dataset attribute name
          ps_attvalue STRING  #dataset attribute value
   DEFINE li,len,lk    INTEGER

   LET ps_data_serial = ps_data_serial.toLowerCase()
   LET ps_attname = ps_attname.toLowerCase()

   LET ps_attvalue = cl_chart_replace_char(ps_attvalue)
   LET li = cl_chart_find_wc(ps_comp)
   
   IF li == 0 THEN
      ERROR "找不到指定的WebComponent名稱"
      RETURN
   END IF
   CASE 
      #設定categories的屬性值
      WHEN ps_data_serial == "categories"
         CALL g_chartxml_d[li].categories_attrs.appendElement()
         LET len = g_chartxml_d[li].categories_attrs.getLength()
         LET g_chartxml_d[li].categories_attrs[len].attr_name = ps_attname
         LET g_chartxml_d[li].categories_attrs[len].attr_value = ps_attvalue
         
      #設定dataset的屬性值
      OTHERWISE            
         FOR lk = 1 TO g_chartxml_d[li].dataset.getLength()
            IF g_chartxml_d[li].dataset[lk].series_name.toUpperCase() == ps_data_serial.toUpperCase() THEN
               LET len = g_chartxml_d[li].dataset[lk].series_attrs.getLength() + 1
               LET g_chartxml_d[li].dataset[lk].series_attrs[len].attr_name = ps_attname
               LET g_chartxml_d[li].dataset[lk].series_attrs[len].attr_value = ps_attvalue
               EXIT FOR
            END IF
         END FOR
   END CASE
   
END FUNCTION

#g_chartxml_d.datas 的變數存放方式為：
#   series_name:'現有庫存量' , data_value:[10,20,30,40]
#   series_name:'安全庫存量' , data_value:[15,25,35,45]

################################################## 
# Descriptions...: 清除指定的WebComponent的所有相關資料
# Date & Author..: 2011/04/14 by tommas
# Input Parameter: ps_data_type    資料類型 categories, dataset
#                  ps_data_serial  該數列的名稱
#                  ps_data_value   數列的值
#                  ps_dataatt      該數列的屬性                     
# Return code....: none
# Usage..........: cl_chart_array_data("dataset","最高存量",100,"color=00ff00")
##################################################
FUNCTION cl_chart_array_data(ps_comp,ps_data_type, ps_data_serial, ps_data_value)
   DEFINE ps_data_type STRING,
          ps_comp         STRING,
          ps_data_serial  STRING,
          ps_data_value  STRING
   CALL cl_chart_array_data_comp(ps_comp, ps_data_type, ps_data_serial, ps_data_value)
END FUNCTION
FUNCTION cl_chart_array_data_comp(ps_comp, ps_data_type, ps_data_serial, ps_data_value)
   DEFINE ps_comp        STRING,
          ps_data_type STRING,
          ps_data_serial  STRING,
          ps_data_value  STRING
          #ps_dataatt STRING
   DEFINE idx,li_idx, len     INTEGER,
          l_sidx     INTEGER, #seriesName
          li_len     INTEGER  #dataset

   LET ps_data_type = ps_data_type.toLowerCase()
   LET ps_data_value = cl_chart_replace_char(ps_data_value)
   #LET ps_data_serial = ps_data_serial.toLowerCase()
   #LET ps_dataatt = ps_dataatt.toLowerCase()
   
   #找出所屬的WebComponent
   LET li_idx = cl_chart_find_wc(ps_comp)
   
   IF li_idx == 0 THEN
      LET li_idx = g_chartxml_d.getLength() + 1
      LET g_chartxml_d[li_idx].chart_name = ps_comp
   END IF

   CASE ps_data_type
      WHEN "categories"  #加到categories陣列中 
         LET len = 0
         FOR idx = 1 TO g_chartxml_d[li_idx].chart_categories.getLength()
             IF g_chartxml_d[li_idx].chart_categories[idx] == ps_data_value THEN
                LET len = idx
                EXIT FOR
             END IF
         END FOR
         IF len == 0 THEN
            CALL g_chartxml_d[li_idx].chart_categories.appendElement()
            LET len = g_chartxml_d[li_idx].chart_categories.getLength()
         END IF
         LET g_chartxml_d[li_idx].chart_categories[len] = ps_data_value
      WHEN "dataset"  #依給定的series name來存放
         #找出所屬的series name是否已存在
         FOR idx = 1 TO g_chartxml_d[li_idx].dataset.getLength()
            IF g_chartxml_d[li_idx].dataset[idx].series_name == ps_data_serial THEN
               LET l_sidx = idx
               EXIT FOR
            END IF
         END FOR
         IF l_sidx == 0 THEN
            CALL g_chartxml_d[li_idx].dataset.appendElement()
            LET l_sidx = g_chartxml_d[li_idx].dataset.getLength()
            LET g_chartxml_d[li_idx].dataset[l_sidx].series_name = ps_data_serial
         END IF

         #將value新增到所屬series的陣列中
         CALL g_chartxml_d[li_idx].dataset[l_sidx].data_values.appendElement()
         LET li_len = g_chartxml_d[li_idx].dataset[l_sidx].data_values.getLength()
         LET g_chartxml_d[li_idx].dataset[l_sidx].data_values[li_len] = ps_data_value
         #LET g_chartxml_d[li_idx].dataset[l_sidx].data_attr[li_len] = ps_dataatt

         
   END CASE

END FUNCTION

################################################## 
# Descriptions...: 清除指定的WebComponent的所有相關資料
# Date & Author..: 2011/04/14 by tommas
# Input Parameter: none
# Return code....: none
# Usage..........: cl_chart_clear()
##################################################
FUNCTION cl_chart_clear(ps_comp)
   DEFINE ps_comp   STRING
   CALL cl_chart_clear_comp(ps_comp)
END FUNCTION
FUNCTION cl_chart_clear_comp(ps_comp)
   DEFINE ps_comp       STRING
   DEFINE l_idx         INTEGER
   LET l_idx = cl_chart_find_wc(ps_comp)
   IF l_idx > 0 THEN
      CALL g_chartxml_h.deleteElement(l_idx)
      CALL g_chartxml_d.deleteElement(l_idx)
      CALL g_chart_trendlines.deleteElement(l_idx)
      CALL g_chart_styles.deleteElement(l_idx)
   END IF   
END FUNCTION

################################################## 
# Descriptions...: 建立完整的FusionChart的XML資料格式
# Date & Author..: 2011/04/14 by tommas
# Input Parameter: ps_gfn01 程式代碼(如果直接輸入圖表代碼Column3D / Line，則只會載入預設值。
# Return code....: none
# Usage..........: cl_chart_create("axmt410")
##################################################
FUNCTION cl_chart_create(ps_comp,ps_gfn01)
   DEFINE ps_comp       STRING
   DEFINE ps_gfn01      LIKE gfn_file.gfn01
   CALL cl_chart_create_comp(ps_comp,ps_gfn01)
END FUNCTION
FUNCTION cl_chart_create_comp(ps_comp,ps_gfn01)
   DEFINE ps_comp       STRING,
          ps_gfn01      LIKE gfn_file.gfn01
   DEFINE l_only_gfm    BOOLEAN
   DEFINE l_gfm02       LIKE gfm_file.gfm02, #數列類型
          l_gfn02       LIKE gfn_file.gfn02, #圖表類型
          l_gfn05       LIKE gfn_file.gfn05  #屬性值
   DEFINE sb            base.StringBuffer,
          st            base.StringTokenizer,
          idx           INTEGER,
          l_wc_idx      INTEGER,
          l_i, l_j, l_k INTEGER,
          l_att_name    STRING,
          l_att_value   STRING,
          l_sty_to      STRING,
          l_sty_type    STRING,
          l_sty_attr    STRING,
          l_dataset     STRING,
          l_find_set    BOOLEAN
   DEFINE l_data        STRING
   DEFINE l_tmp         STRING
   LET sb = base.StringBuffer.create()

   #找出WebComponent
   LET l_wc_idx = cl_chart_find_wc(ps_comp)
   LET l_only_gfm = FALSE
   IF l_wc_idx == 0 THEN
      ERROR "找不到指定的WebComponent:", ps_comp
      RETURN
   ELSE
      SELECT MAX(gfn02) INTO l_gfn02 FROM gfn_file WHERE gfn01 = ps_gfn01
      IF l_gfn02 IS NULL THEN         
         SELECT MAX(gfm01) INTO l_gfn02 FROM gfm_file WHERE gfm01 = ps_gfn01
         IF l_gfn02 IS NULL THEN         
            ERROR "找不到此代碼：" || ps_gfn01
            RETURN
         ELSE
            LET l_only_gfm = TRUE
         END IF
      END IF
      LET g_chartxml_h[l_wc_idx].gfn02 = l_gfn02
      CALL cl_set_property_comp(ps_comp, "charttype", l_gfn02)
   END IF

   CASE l_gfn02
      WHEN "BulbGauge"
         IF cl_null(g_gauge.label) THEN
            SELECT gfp04 FROM gfp_file WHERE gfp01 = ps_gfn01 AND gfp03 = g_lang AND gfp02 = 'caption'
            LET g_gauge.label = l_gfn05
         END IF
         LET l_data = g_gauge.label, "|", g_gauge.value, "|", g_gauge.low, "|", g_gauge.medium, "|", g_gauge.high
         CALL cl_set_property_comp(ps_comp, "data", l_data)
         RETURN
      WHEN "AngularGauge"
         IF cl_null(g_gauge.label) THEN
            SELECT gfp04 FROM gfp_file WHERE gfp01 = ps_gfn01 AND gfp03 = g_lang AND gfp02 = 'caption'
            LET g_gauge.label = l_gfn05
         END IF
         LET l_data = g_gauge.label, "|", g_gauge.value, "|", g_gauge.start, "|", g_gauge.end
         CALL cl_set_property_comp(ps_comp, "data", l_data)
         RETURN
      WHEN "Pie3D"  #將Pie3D加上可使用滑鼠轉動的功能
         LET idx = g_chartxml_h[l_wc_idx].chart_attr.getLength()+1
         LET g_chartxml_h[l_wc_idx].chart_attr[idx].attr_name = "enableRotation"
         LET g_chartxml_h[l_wc_idx].chart_attr[idx].attr_value = "1"
   END CASE   

   #產生chart節點
   CALL sb.append("<chart exportHandler='fcExporter1' exportEnabled='1' exportAtClient='1' showAboutMenuItem='0' showExportDataMenuItem='1' ")
   
   #先組合p_chart中程式自設屬性
   IF NOT l_only_gfm THEN 
      CALL cl_chart_def_attr(ps_gfn01, l_wc_idx)
   END IF
   
   #再組合p_chart中共用預設屬性
   #CALL cl_chart_def_attr("", l_wc_idx)

   #產生chart節點的屬性
   FOR idx = 1 TO g_chartxml_h[l_wc_idx].chart_attr.getLength()
      CALL sb.append(" " || g_chartxml_h[l_wc_idx].chart_attr[idx].attr_name || "='")
      CALL sb.append(g_chartxml_h[l_wc_idx].chart_attr[idx].attr_value || "'")
   END FOR
   CALL sb.append(">")

   LET l_j = cl_chart_find_wc(ps_comp)
   IF l_j == 0 THEN ERROR "can't find current categories" RETURN END IF

   #依照gfm08 選擇要設定categories或是label或是多組dataset
   IF l_only_gfm THEN
      SELECT MAX(gfm02) INTO l_gfm02 FROM gfm_file WHERE gfm01 = ps_gfn01
   ELSE
      SELECT MAX(gfm02) INTO l_gfm02 FROM gfn_file INNER JOIN gfm_file 
                        ON gfm01 = gfn02 and gfn01 = ps_gfn01
   END IF
   CASE l_gfm02
      WHEN "1" #單數列 
         LET l_find_set = FALSE
         FOR idx = 1 TO g_chartxml_d[l_j].dataset.getLength()
            #<set label=... value=...
            #CALL sb.append("<set label='" || g_chartxml_d[l_j].dataset[idx].series_name || "'") #set label and value
            CALL sb.append("<set") #因為多語言，所以label就拿出來到p_chart設定了
            IF g_chartxml_d[l_j].dataset[idx].data_values.getLength() > 0 THEN
               CALL sb.append(" value='" || g_chartxml_d[l_j].dataset[idx].data_values[1] || "'")
               FOR l_k = 1 TO g_chartxml_d[l_j].dataset[idx].series_attrs.getLength()
                  CALL sb.append(" " || g_chartxml_d[l_j].dataset[idx].series_attrs[l_k].attr_name || "='")
                  CALL sb.append(g_chartxml_d[l_j].dataset[idx].series_attrs[l_k].attr_value || "'")
                  IF g_chartxml_d[l_j].dataset[idx].series_attrs[l_k].attr_name == "set" THEN
                    LET l_find_set = TRUE
                  END IF
               END FOR
            ELSE
               CALL sb.append(" value='0'")
            END IF
            IF NOT l_find_set THEN
               CALL sb.append(" label='"|| g_chartxml_d[l_j].dataset[idx].series_name ||"'")
            END IF
            CALL sb.append(" link='j-chartClick-" || g_chartxml_d[l_j].dataset[idx].series_name ||"' ")
            CALL sb.append(" />")
         END FOR
      WHEN "2"   #多數列 tommas …
         #找出categories
         FOR idx = 1 TO g_chartxml_d.getLength()
            IF g_chartxml_d[idx].chart_name == ps_comp THEN
               LET l_j = idx
               EXIT FOR
            END IF
         END FOR
         IF l_j == 0 THEN ERROR "can't find current categories" RETURN END IF

         #<categories ...
         CALL sb.append("<categories")  
         
         FOR idx = 1 TO g_chartxml_d[l_j].categories_attrs.getLength()  #categories attributes
            CALL sb.append(" " || g_chartxml_d[l_j].categories_attrs[idx].attr_name || "='")
            CALL sb.append(g_chartxml_d[l_j].categories_attrs[idx].attr_value || "'")
         END FOR

         CALL sb.append(">")

         #<category label=...
         FOR idx = 1 TO g_chartxml_d[l_j].chart_categories.getLength() #categiries children nodes
            LET l_tmp = "<category label='", g_chartxml_d[l_j].chart_categories[idx], "'"
            CALL sb.append(l_tmp)
            IF idx <= g_chartxml_d[l_j].category_attrs.getLength() THEN
               CALL sb.append(" ")
               CALL sb.append(cl_chart_parse_attr(g_chartxml_d[l_j].category_attrs[idx]))
            END IF
            CALL sb.append(" />")            
         END FOR 
         CALL sb.append("</categories>")  

         #find current datas
         FOR idx = 1 TO g_chartxml_d[l_j].dataset.getLength()
            #<dataset seriesName=...
            IF cl_null(g_chartxml_d[l_j].dataset[idx].series_name) THEN
               LET l_dataset = "<dataset"
               #CALL sb.append("<dataset")
            ELSE
               LET l_dataset = "<dataset seriesname='" || g_chartxml_d[l_j].dataset[idx].series_name || "'"
               #CALL sb.append("<dataset seriesname='" || g_chartxml_d[l_j].dataset[idx].series_name || "'") #dataset start tag
            END IF

            #當dataset只有1組時，顏色設定為綠色,若p_chart有設定dataset_color，則以設定的為主
            IF g_chartxml_d[l_j].dataset.getLength() == 1 AND idx == 1 THEN
               LET l_tmp = "0"
               FOR l_k = 1 TO g_chartxml_d[l_j].dataset[idx].series_attrs.getLength()  #找p_chart是否已經有設定dataset的color
                  IF g_chartxml_d[l_j].dataset[idx].series_attrs[l_k].attr_name == "color" THEN
                     LET l_tmp = "1"
                     EXIT FOR
                  END IF
               END FOR
               IF l_tmp == "0" THEN
                  LET l_dataset = l_dataset, " color='4cc417'"
               END IF
            END IF
            CALL sb.append(l_dataset)
            
            FOR l_k = 1 TO g_chartxml_d[l_j].dataset[idx].series_attrs.getLength()  
               #<dataset attributes=...
               CALL sb.append(" " || g_chartxml_d[l_j].dataset[idx].series_attrs[l_k].attr_name || "='")
               CALL sb.append(g_chartxml_d[l_j].dataset[idx].series_attrs[l_k].attr_value || "'")
            END FOR

            CALL sb.append(">")
            FOR l_k = 1 TO g_chartxml_d[l_j].dataset[idx].data_values.getLength()
               #<set value=...
               CALL sb.append("<set value='")
               IF cl_null(g_chartxml_d[l_j].dataset[idx].data_values[l_k]) THEN LET g_chartxml_d[l_j].dataset[idx].data_values[l_k]="0" END IF
               CALL sb.append(g_chartxml_d[l_j].dataset[idx].data_values[l_k])
               CALL sb.append("' ") 
               CALL sb.append(cl_chart_parse_attr(g_chartxml_d[l_j].dataset[idx].data_attr[l_k]) )
               CALL sb.append(" link='j-chartClick-" || g_chartxml_d[l_j].chart_categories[l_k] || "' />")
            END FOR
            CALL sb.append("</dataset>") 
         END FOR
   END CASE

   #trendlines
   IF g_chart_trendlines[l_wc_idx].tr_lines.getLength() > 0 THEN   
      CALL sb.append("<trendLines>")
      FOR l_i = 1 TO g_chart_trendlines[l_wc_idx].tr_lines.getLength()
         CALL sb.append("<line")
         FOR l_j = 1 TO g_chart_trendlines[l_wc_idx].tr_lines[l_i].attrs.getLength()   
            LET l_att_name = g_chart_trendlines[l_wc_idx].tr_lines[l_i].attrs[l_j].attr_name
            LET l_att_value = g_chart_trendlines[l_wc_idx].tr_lines[l_i].attrs[l_j].attr_value
            CASE l_att_name
               WHEN "startValue"
                  CALL sb.append(" startValue='"   || l_att_value || "'")
               WHEN "endValue"
                  CALL sb.append(" endValue='"     || l_att_value || "'")
               WHEN "color"
                  CALL sb.append(" color='"        || l_att_value || "'")
               WHEN "displayValue"
                  CALL sb.append(" displayValue='" || l_att_value || "'")
            END CASE         
         END FOR
         CALL sb.append(" " || cl_chart_parse_attr(g_chart_trendlines[l_wc_idx].tr_lines[l_i].other))
         CALL sb.append("/>")
      END FOR
      CALL sb.append("</trendLines>")
   END IF

   #styles
   IF g_chart_styles[l_wc_idx].styles.getLength() > 0 THEN
      CALL sb.append("<styles>")
      #definition
      CALL sb.append("<definition>")
      FOR l_i = 1 TO g_chart_styles[l_wc_idx].styles.getLength()
         LET st = base.StringTokenizer.create(g_chart_styles[l_wc_idx].styles[l_i].attr_name,"_")
         LET l_att_name = g_chart_styles[l_wc_idx].styles[l_i].attr_name
         LET l_att_value = g_chart_styles[l_wc_idx].styles[l_i].attr_value
         IF st.countTokens() == 3 THEN
            LET l_sty_to = st.nextToken()
            LET l_sty_type = st.nextToken()
            LET l_sty_attr = st.nextToken()
            CALL sb.append("<style name='" || l_att_name || "'")
            CALL sb.append(" type='" || l_sty_type || "'")
            CALL sb.append(" " || l_sty_attr || "='" || l_att_value || "'")
            CALL sb.append("/>")
         END IF
      END FOR
      CALL sb.append("</definition>")
      
      #application
      CALL sb.append("<application>")
      FOR l_i = 1 TO g_chart_styles[l_wc_idx].styles.getLength()
         LET st = base.StringTokenizer.create(g_chart_styles[l_wc_idx].styles[l_i].attr_name,"_")
         LET l_sty_to = st.nextToken()
         LET l_att_name = g_chart_styles[l_wc_idx].styles[l_i].attr_name            
         CALL sb.append("<apply toObject='" || l_sty_to || "'")
         CALL sb.append(" styles='" || l_att_name || "'")
         CALL sb.append("/>")      
      END FOR
      CALL sb.append("</application>")
      CALL sb.append("</styles>")
   END if
   CALL sb.append("</chart>")
#display "test: ", ps_gfn01, " data:",sb.toString()
   CALL cl_set_property_comp(ps_comp,"data" ,sb.toString())
   CALL cl_set_property_comp(ps_comp,"generatedemodata", ps_comp)
   CALL cl_set_property_comp(ps_comp,"msg", "")
END FUNCTION

#將color=FF00CC,alpha=60...轉成color='FF00CC' alpha='60' ...
PRIVATE FUNCTION cl_chart_parse_attr(ps_dataattr)
   DEFINE ps_dataattr  STRING
   DEFINE sb   base.StringBuffer
   IF ps_dataattr IS NULL THEN RETURN " " END IF
   LET sb = base.StringBuffer.create()
   CALL sb.append(ps_dataattr)
   CALL sb.replace(" ","",0)
   CALL sb.replace("=", "='", 0)
   CALL sb.replace(",", "' ", 0)
   CALL sb.append("'")
   RETURN sb.toString()
END FUNCTION 

################################################## 
# Descriptions...: 找出p_chart中設定的屬性，放至相關變數中
# Date & Author..: 2011/04/14 by tommas
# Input Parameter: p_gfm01  屬性代碼
#                  p_idx    WebComponent所存放的陣列索引
# Return code....: none
##################################################
PRIVATE FUNCTION cl_chart_def_attr(p_gfn01, p_idx)
   DEFINE p_idx     INTEGER,   #WebComponent所存放的陣列索引
          p_gfn01   LIKE gfn_file.gfn01
   DEFINE l_sql    STRING
   DEFINE st1, st2  base.StringTokenizer
   DEFINE l_i   INTEGER,
          l_len     INTEGER,
          l_find    BOOLEAN,
          l_attn    STRING,
          l_tag     STRING
   DEFINE l_gfm03   LIKE gfm_file.gfm03, #屬性代碼
          l_gfn04   LIKE gfn_file.gfn04, #序號
          l_gfm05   LIKE gfm_file.gfm05, #屬性類型 1.基本 2.陣列 3.特殊
          l_gfm06   LIKE gfm_file.gfm06, #屬性值
          l_gfm02   LIKE gfm_file.gfm02, #單一數列 / 多數列
          l_gfm01   LIKE gfm_file.gfm01 #圖表代碼
   DEFINE l_tmp     STRING
   DEFINE l_gfp02   LIKE gfp_file.gfp02
   
   IF g_lang IS NULL THEN LET g_lang = '0' END IF
   #如果p_gfn01是空值，表示使用預設值設定
   IF p_gfn01 IS NULL THEN
      #撈gfm_file, gfm07 = 1, gfm05 != 2, gfm01 = g_chartxml_h[p_idx].gfn02
      LET l_sql = "SELECT gfm03,1,gfm05,gfm06,gfm02,gfm01,0 FROM gfm_file ",
                  "WHERE gfm01 ='", g_chartxml_h[p_idx].gfn02 CLIPPED , "' ",
                  " AND gfm05 != '1'"
   ELSE 
      LET l_sql = "SELECT gfn03,gfn04,gfm05,gfn05,gfm02,gfm01 ",
                  "FROM gfn_file inner join gfm_file on gfm01 = gfn02 ",
                  "WHERE gfn01 = '",p_gfn01 CLIPPED,"' and gfn03 = gfm03"
   END IF

   PREPARE cl_chart_p1 FROM l_sql
   DECLARE cl_chart_c1 CURSOR FOR cl_chart_p1

   FOREACH cl_chart_c1 INTO l_gfm03,l_gfn04,l_gfm05,l_gfm06,l_gfm02,l_gfm01
      LET l_tmp = l_gfn04
      LET l_gfp02 = l_gfm03, "|", l_tmp.trim()
      SELECT gfp04 INTO l_gfm06 FROM gfp_file WHERE gfp01 = p_gfn01 AND gfp02 = l_gfp02 AND gfp03 = g_lang
      CASE l_gfm05
         WHEN 1    #基本屬性
            LET l_find = FALSE
                  FOR l_i = 1 TO g_chartxml_h[p_idx].chart_attr.getLength()
                     IF g_chartxml_h[p_idx].chart_attr[l_i].attr_name == l_gfm03 THEN
                        LET l_find = TRUE
                        EXIT FOR
                     END IF
                  END FOR
                  IF NOT l_find THEN 
                     CALL g_chartxml_h[p_idx].chart_attr.appendElement()
                     LET l_len = g_chartxml_h[p_idx].chart_attr.getLength()
                     LET g_chartxml_h[p_idx].chart_attr[l_len].attr_name = l_gfm03
                     LET g_chartxml_h[p_idx].chart_attr[l_len].attr_value = l_gfm06
                  END IF
         WHEN 2 #陣列資料
            LET st1 = base.StringTokenizer.create(l_gfm03, "_")
            LET l_tag = st1.nextToken()
            LET l_attn = st1.nextToken()
            LET l_tag = l_tag.toLowerCase()            
            CASE l_tag
               WHEN "category"
                  #值:category_label
                  #   <category label=...
                  #值：category_showLabel
                  #   <category showLabel=xxx
                  IF l_gfn04 <= g_chartxml_d[p_idx].dataset.getLength() THEN
                     CALL g_chartxml_d[p_idx].category_attrs.appendElement()
                     LET l_len = g_chartxml_d[p_idx].category_attrs.getLength()
                     LET g_chartxml_d[p_idx].category_attrs[l_len] = l_attn,"=",l_gfm06
                  END IF
               WHEN "dataset"
                  IF l_gfn04 <= g_chartxml_d[p_idx].dataset.getLength() THEN
                     IF (l_attn IS NOT NULL) AND (l_gfm06 IS NOT NULL) THEN
                        CASE 
                           WHEN l_attn.toLowerCase() == "seriesname"
                              LET g_chartxml_d[p_idx].dataset[l_gfn04].series_name = l_gfm06
                           OTHERWISE
                              CALL g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs.appendElement()
                              LET l_len = g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs.getLength()
                              LET g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs[l_len].attr_name = l_attn
                              LET g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs[l_len].attr_value = l_gfm06
                        END CASE
                     END IF
                  END IF
               WHEN "set"
                 IF l_gfm02 == 1 THEN

                    IF l_gfn04 <= g_chartxml_d[p_idx].dataset.getLength() THEN
                        FOR l_i = 1 TO g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs.getLength()
                           IF g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs[l_i].attr_name == l_gfm06 THEN
                              LET l_find = TRUE
                              EXIT FOR
                           END IF
                        END FOR
                        IF NOT l_find THEN                       
                              IF (l_attn IS NOT NULL) AND (l_gfm06 IS NOT NULL) THEN
                                 CALL g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs.appendElement()
                                 LET l_len = g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs.getLength()
                                 LET g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs[l_len].attr_name = l_attn
                                 LET g_chartxml_d[p_idx].dataset[l_gfn04].series_attrs[l_len].attr_value = l_gfm06
                              END IF 
                           
                        END IF
                     END IF
                  END IF
            END CASE
         WHEN 3 #特殊屬性
            #
            #值:caption_font_size=18,以_為分隔符號
            #組成<style name='caption_font_size' type='font' size='18'...>
            #   <apply toObject='caption' styles='caption_font_size' />
            #caption:<
            #font:
            #size:
            FOR l_i = 1 TO g_chart_styles[p_idx].styles.getLength()
               IF g_chart_styles[p_idx].styles[l_i].attr_name == l_gfm03 THEN
                  LET l_find = TRUE
                  EXIT FOR
               END IF
            END FOR
            IF NOT l_find THEN
               CALL g_chart_styles[p_idx].styles.appendElement()
               LET l_len = g_chart_styles[p_idx].styles.getLength()
               LET g_chart_styles[p_idx].styles[l_len].attr_name = l_gfm03
               LET g_chart_styles[p_idx].styles[l_len].attr_value = l_gfm06
            END IF
      END CASE
   END FOREACH   
END FUNCTION

################################################## 
# Descriptions...: 設定WebComponent的trendline
# Date & Author..: 2011/04/14 by tommas
# Input Parameter: ps_start  啟始位置的值
#                  ps_end    終止位置的值
#                  ps_color  線條顏色
#                  ps_label  顯示名稱
#                  ps_other  其它屬性valueOnRight=0,thickness=3
# Return code....: none
# Usage..........: l_chart_add_trend_line(100,100, "#FF0000", "基準線", "valueOnRight=0,thickness=3")
##################################################
FUNCTION cl_chart_add_trend_line(ps_comp,ps_start, ps_end, ps_color, ps_label, ps_other)
   DEFINE ps_comp    STRING
   DEFINE ps_start   STRING,  #啟始位置的值
          ps_end     STRING,  #終止位置的值
          ps_color   STRING,   #線條顏色
          ps_label   STRING,   #顯示名稱
          ps_other   STRING    #其它屬性valueOnRight=0,thickness=3
   CALL cl_chart_add_trend_line_comp(ps_comp, ps_start, ps_end, ps_color, ps_label, ps_other)
END FUNCTION
FUNCTION cl_chart_add_trend_line_comp(ps_comp, ps_start, ps_end, ps_color, ps_label, ps_other)
   DEFINE ps_comp    STRING,   #WebComponent名稱
          ps_start   STRING,  #啟始位置的值
          ps_end     STRING,  #終止位置的值
          ps_color   STRING,   #線條顏色
          ps_label   STRING,   #顯示名稱
          ps_other   STRING    #其它屬性valueOnRight=0,thickness=3
   DEFINE l_l        INTEGER,
          l_idx        INTEGER,
          l_len      INTEGER
   #找出WebComponent
   LET l_idx = cl_chart_find_wc(ps_comp)
   IF l_idx > 0 THEN
      CALL g_chart_trendlines[l_idx].tr_lines.appendElement()
      LET l_l = g_chart_trendlines[l_idx].tr_lines.getLength()
      IF ps_other IS NOT NULL THEN  #其他屬性
         LET g_chart_trendlines[l_idx].tr_lines[l_l].other = ps_other
      END IF
      IF ps_start IS NOT NULL THEN  #開始值
         CALL g_chart_trendlines[l_idx].tr_lines[l_l].attrs.appendElement()
         LET l_len = g_chart_trendlines[l_idx].tr_lines[l_l].attrs.getLength()
         LET g_chart_trendlines[l_idx].tr_lines[l_l].attrs[l_len].attr_name = "startValue"
         LET g_chart_trendlines[l_idx].tr_lines[l_l].attrs[l_len].attr_value = ps_start
      END IF
      IF ps_end IS NOT NULL THEN   #結束值
         CALL g_chart_trendlines[l_idx].tr_lines[l_l].attrs.appendElement()
         LET l_len = g_chart_trendlines[l_idx].tr_lines[l_l].attrs.getLength()
         LET g_chart_trendlines[l_idx].tr_lines[l_l].attrs[l_len].attr_name = "endValue"
         LET g_chart_trendlines[l_idx].tr_lines[l_l].attrs[l_len].attr_value = ps_end
      END IF
      IF ps_color IS NOT NULL THEN   #線條顏色
         CALL g_chart_trendlines[l_idx].tr_lines[l_l].attrs.appendElement()
         LET l_len = g_chart_trendlines[l_idx].tr_lines[l_l].attrs.getLength()
         LET g_chart_trendlines[l_idx].tr_lines[l_l].attrs[l_len].attr_name = "color"
         LET g_chart_trendlines[l_idx].tr_lines[l_l].attrs[l_len].attr_value = ps_color
      END IF
      IF ps_label IS NOT NULL THEN   #標籤
         CALL g_chart_trendlines[l_idx].tr_lines[l_l].attrs.appendElement()
         LET l_len = g_chart_trendlines[l_idx].tr_lines[l_l].attrs.getLength()
         LET g_chart_trendlines[l_idx].tr_lines[l_l].attrs[l_len].attr_name = "displayValue"
         LET g_chart_trendlines[l_idx].tr_lines[l_l].attrs[l_len].attr_value = ps_label
      END IF
   END IF
   
END FUNCTION

################################################## 
# Descriptions...: 清除trend line資料
# Date & Author..: 2011/04/14 by tommas
# Input Parameter: none
# Return code....: none
# Usage..........: cl_chart_del_trend_line()
##################################################
FUNCTION cl_chart_del_trend_line(ps_comp)
   DEFINE ps_comp  STRING
   CALL cl_chart_del_trend_line_comp(ps_comp)
END FUNCTION
FUNCTION cl_chart_del_trend_line_comp(ps_comp)
   DEFINE ps_comp     STRING
   DEFINE l_idx       INTEGER
   
   LET l_idx = cl_chart_find_wc(ps_comp)
   
   IF l_idx > 0 THEN
      INITIALIZE g_chart_trendlines[l_idx].tr_lines TO NULL
   ELSE
      
   END IF
END FUNCTION


################################################## 
# Descriptions...: 找webcomponent在g_chartxml_h所在陣列的索引值
# Date & Author..: 2011/04/14 by tommas
# Input Parameter: ps_comp  WebComponent名稱
# Return code....: l_i
##################################################
PRIVATE FUNCTION cl_chart_find_wc(ps_comp)
   DEFINE ps_comp     STRING
   DEFINE l_i         INTEGER          

   FOR l_i = 1 TO g_chartxml_h.getLength()
      IF g_chartxml_h[l_i].chart_name == ps_comp THEN
         RETURN l_i
      END IF
   END FOR
   RETURN 0
END FUNCTION

##################################################
# Descriptions...: 建立燈號圖
# Date & Author..: 2011/08/02 by tommas
# Input Parameter: ps_label   標籤
#                  ps_value   值
#                  ps_low     低值  (若0則為預設值33)
#                  ps_medium  中值  (若0則為預設值66)
#                  ps_high    高值  (若0則為預設值100)
# Return code....: l_i
# Usage..........: cl_chart_bulb("企業各模組的關帳狀況", 78, 33, 66, 100)
##################################################
FUNCTION cl_chart_bulb(ps_comp,ps_label, ps_value, ps_low, ps_medium, ps_high)
  DEFINE ps_comp      STRING
  DEFINE ps_label     STRING,
         ps_value     INTEGER,
         ps_low       INTEGER,
         ps_medium    INTEGER,
         ps_high      INTEGER
  CALL cl_chart_bulb_comp(ps_comp, ps_label, ps_value, ps_low, ps_medium, ps_high)
END FUNCTION
FUNCTION cl_chart_bulb_comp(ps_comp, ps_label, ps_value, ps_low, ps_medium, ps_high)
  DEFINE ps_comp      STRING,
         ps_label     STRING,
         ps_value     INTEGER,
         ps_low       INTEGER,
         ps_medium    INTEGER,
         ps_high      INTEGER
  
  IF ps_low == 0 THEN LET ps_low = 33 END IF
  IF ps_medium == 0 THEN LET ps_medium = 66 END IF
  IF ps_high == 0 THEN LET ps_high = 100 END IF

  LET g_gauge.label = ps_label
  LET g_gauge.value = ps_value
  LET g_gauge.low = ps_low
  LET g_gauge.medium = ps_medium
  LET g_gauge.high = ps_high
END FUNCTION

##################################################
# Descriptions...: 建立儀表板
# Date & Author..: 2011/08/02 by tommas
# Input Parameter: ps_label   標籤
#                  ps_value   值
#                  ps_start   起始值
#                  ps_end     最終值
# Return code....: l_i
# Usage..........: cl_chart_ag("客戶信用額度狀況", 78330)
##################################################
FUNCTION cl_chart_ag(ps_comp,ps_label, ps_value, ps_start, ps_end)
  DEFINE ps_comp      STRING
  DEFINE ps_label     STRING,
         ps_value     INTEGER,
         ps_start     INTEGER,
         ps_end       INTEGER
  CALL cl_chart_ag_comp(ps_comp, ps_label, ps_value, ps_start, ps_end)
END FUNCTION
FUNCTION cl_chart_ag_comp(ps_comp, ps_label, ps_value, ps_start, ps_end)
  DEFINE ps_comp      STRING,
         ps_label     STRING,
         ps_value     INTEGER,
         ps_start     INTEGER,
         ps_end       INTEGER
 
  LET g_gauge.label = ps_label
  LET g_gauge.value = ps_value
  LET g_gauge.start = ps_start
  LET g_gauge.end   = ps_end

END FUNCTION

FUNCTION cl_set_property(ps_comp,prop_name, prop_value)
  DEFINE ps_comp       STRING
  DEFINE prop_name     STRING,
         prop_value    STRING
  CALL cl_set_property_comp(ps_comp, prop_name, prop_value)
END FUNCTION

##################################################
# Descriptions...: 當圖表無資料時，設定訊息
# Date & Author..: 2011/11/23 by tommas
# Input Parameter: ps_comp    WebComponent元件名稱
#                  ps_msg     提示訊息
# Return code....: none
# Usage..........: cl_chart_set_empty("wc_1", "無此圖表權限")
##################################################
FUNCTION cl_chart_set_empty(ps_comp,ps_msg)
   DEFINE ps_comp   STRING   #WebComponent元件名稱
   DEFINE ps_msg    STRING   #訊息

   CALL cl_set_property_comp(ps_comp, 'msg', ps_msg)
END FUNCTION

FUNCTION cl_set_property_comp(ps_comp, prop_name, prop_value)
   DEFINE ps_comp STRING
   DEFINE prop_name STRING
   DEFINE prop_value STRING
   DEFINE win ui.Window
   DEFINE l_ff    om.DomNode
   DEFINE win_node      om.DomNode
   DEFINE l_nl   om.NodeList
   DEFINE l_wc  om.DomNode
   DEFINE l_dict    om.DomNode
   DEFINE l_prop    om.DomNode
   
   LET win = ui.Window.getCurrent()
   LET win_node = win.getNode()

   LET l_nl = win_node.selectByPath("//FormField[@name=\"formonly."|| ps_comp ||"\"]")

   IF l_nl.getLength() > 0 THEN
      LET l_ff = l_nl.item(1)
      LET l_wc = l_ff.getFirstChild()
      LET l_dict = l_wc.getFirstChild()
      IF l_dict IS NULL THEN
        LET l_dict = l_wc.createChild("PropertyDict")
        CALL l_dict.setAttribute("name", "properties")
      END IF
      LET l_nl = l_dict.selectByPath("//Property[@name=\"" || prop_name || "\"]")
      LET l_prop = l_nl.item(1)
      IF l_prop IS NULL THEN
         LET l_prop = l_dict.createChild("Property")
         CALL l_prop.setAttribute("name", prop_name)
      END IF
      CALL l_prop.setAttribute("value", prop_value)
   END IF
END FUNCTION

FUNCTION cl_show_fc(p_form_name)
  DEFINE l_gdj02     DYNAMIC ARRAY OF RECORD
           gdj02     LIKE gdj_file.gdj02,
           gdj02_n   STRING,
           chart     STRING     #圖表類型(Column2D,Pie3D...)
                     END RECORD
  DEFINE p_form_name STRING                  
  DEFINE ps_key      STRING
  DEFINE l_sql       STRING
  DEFINE l_idx       INTEGER
  DEFINE l_i         INTEGER
  DEFINE l_win       ui.Window
  DEFINE l_n         om.DomNode
  DEFINE l_btnl      om.NodeList
  DEFINE l_btn       om.DomNode
  DEFINE l_lb        om.DomNode
  DEFINE l_lbl       om.NodeList
  DEFINE l_emp_lb    om.DomNode
  DEFINE l_emp_lbl   om.NodeList
  DEFINE l_btn_size  INTEGER    #畫面預埋的Button數量
  DEFINE l_btn_name  STRING
  
  LET l_btn_size = 20
  OPEN WINDOW cl_show_fc_w1 WITH FORM "lib/42f/" || p_form_name
  CALL cl_ui_init()
  LET l_win = ui.Window.getCurrent()
  LET l_n = l_win.getNode()
  
  LET l_sql = "SELECT gdj02 FROM gdj_file WHERE gdj01 = ? "
  DECLARE cl_show_fc_d1 CURSOR FROM l_sql

  LET l_idx = 1
  FOREACH cl_show_fc_d1 USING g_prog INTO l_gdj02[l_idx].gdj02
    CASE l_gdj02[l_idx].gdj02 
      WHEN "s_char_stock"       LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "料件現有庫存資料 "
      WHEN "s_char_wotype"      LET l_gdj02[l_idx].chart = "Pie2D"            LET l_gdj02[l_idx].gdj02_n = "工單完工狀況 "
      WHEN "s_char_cuscredit"   LET l_gdj02[l_idx].chart = "AngularGauge"     LET l_gdj02[l_idx].gdj02_n = "客戶信用額度狀況 "
      WHEN "s_char_salecost"    LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "料件銷售價格 "
      WHEN "s_char_cusorder"    LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "客戶訂單狀況 "
      WHEN "s_char_cusar"       LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "客戶應收狀況 "
      WHEN "s_char_borroworder" LET l_gdj02[l_idx].chart = "Pie2D"            LET l_gdj02[l_idx].gdj02_n = "借貨訂單狀況 "
      WHEN "s_char_salereturn"  LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "銷貨退回金額比率 "
      WHEN "s_char_verreceipt"  LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "廠商採購收貨狀況 "
      WHEN "s_cahr_verap"       LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "廠商應付帳款狀況 "
      WHEN "s_char_purreturn"   LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "採購退貨金額比率 "
      WHEN "s_char_stocktype"   LET l_gdj02[l_idx].chart = "AngularGauge"     LET l_gdj02[l_idx].gdj02_n = "料件庫存計劃狀況 "
      WHEN "s_char_budget"      LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "部門科目預算 "
      WHEN "s_char_purcost"     LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "料件採購價格 "
      WHEN "s_char_deposit"     LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "銀行存款狀況 "
      WHEN "s_char_close"       LET l_gdj02[l_idx].chart = "BulbGauge"        LET l_gdj02[l_idx].gdj02_n = "模組關帳狀況 "
      WHEN "s_char_corclose"    LET l_gdj02[l_idx].chart = "BulbGauge"        LET l_gdj02[l_idx].gdj02_n = "法人總帳關帳狀況 "
      WHEN "s_char_online"      LET l_gdj02[l_idx].chart = "ScrollCombiDY2D"  LET l_gdj02[l_idx].gdj02_n = "部門上線人數上線人數 "
    END CASE
    LET l_idx = l_idx + 1
  END FOREACH
  CALL l_gdj02.deleteElement(l_idx)
  
  LET l_btnl = l_n.selectByPath("//Button[@style=\"chart\"]")
  LET l_lbl = l_n.selectByPath("//Label[@style=\"chart\"]")
  LET l_emp_lbl = l_n.selectByPath("//Label[@style=\"empty\"]")
  FOR l_idx = 1 TO l_btnl.getLength()
    IF l_lbl.item(l_idx) IS NOT NULL THEN
       LET l_btn = l_btnl.item(l_idx)
       LET l_lb = l_lbl.item(l_idx)
       IF l_idx <= l_gdj02.getLength() THEN
         CALL l_btn.setAttribute("image", l_gdj02[l_idx].gdj02)
         CALL l_btn.setAttribute("text", "")
         CALL l_btn.setAttribute("hidden", "0")
         CALL l_lb.setAttribute("text", l_gdj02[l_idx].gdj02_n)
         CALL l_lb.setAttribute("hidden", "0")
       ELSE
         CALL l_btn.setAttribute("image", "")
         CALL l_btn.setAttribute("text", "")
         CALL l_btn.setAttribute("hidden", "1")
         CALL l_lb.setAttribute("text", "")
         CALL l_lb.setAttribute("hidden", "1")
       END IF
    END IF
  END FOR
  LET l_i = 0
  CASE p_form_name
    WHEN "cl_fc_dummy_3c"
      LET l_i = l_gdj02.getLength() / 3
      IF (l_gdj02.getLength() MOD 3) == 0 THEN LET l_i = l_i - 1 END IF
    WHEN "cl_fc_dummy_4c"
      LET l_i = l_gdj02.getLength() / 4
      IF (l_gdj02.getLength() MOD 4) == 0 THEN LET l_i = l_i - 1 END IF
  END CASE
  
  FOR l_idx = 1 TO l_emp_lbl.getLength()
    LET l_emp_lb = l_emp_lbl.item(l_idx)
    IF l_emp_lb IS NOT NULL THEN
      IF l_idx <= l_i THEN
         CALL l_emp_lb.setAttribute("hidden","0")
      ELSE
         CALL l_emp_lb.setAttribute("hidden","1") 
      END IF
    END IF
  END FOR
  CALL ui.Interface.refresh()
  LET l_idx = 0
  MENU
    ON ACTION fc_btn_1      LET l_idx = 1   EXIT MENU
    ON ACTION fc_btn_2      LET l_idx = 2   EXIT MENU
    ON ACTION fc_btn_3      LET l_idx = 3   EXIT MENU
    ON ACTION fc_btn_4      LET l_idx = 4   EXIT MENU
    ON ACTION fc_btn_5      LET l_idx = 5   EXIT MENU
    ON ACTION fc_btn_6      LET l_idx = 6   EXIT MENU
    ON ACTION fc_btn_7      LET l_idx = 7   EXIT MENU
    ON ACTION fc_btn_8      LET l_idx = 8   EXIT MENU
    ON ACTION fc_btn_9      LET l_idx = 9   EXIT MENU
    ON ACTION fc_btn_10     LET l_idx = 10  EXIT MENU
    ON ACTION fc_btn_11     LET l_idx = 11  EXIT MENU
    ON ACTION fc_btn_12     LET l_idx = 12  EXIT MENU
    ON ACTION fc_btn_13     LET l_idx = 13  EXIT MENU
    ON ACTION fc_btn_14     LET l_idx = 14  EXIT MENU
    ON ACTION fc_btn_15     LET l_idx = 15  EXIT MENU
    ON ACTION fc_btn_16     LET l_idx = 16  EXIT MENU
    ON ACTION fc_btn_17     LET l_idx = 17  EXIT MENU
    ON ACTION fc_btn_18     LET l_idx = 18  EXIT MENU
    ON ACTION fc_btn_19     LET l_idx = 19  EXIT MENU
    ON ACTION fc_btn_20     LET l_idx = 20  EXIT MENU
    ON ACTION fc_btn_21     LET l_idx = 21  EXIT MENU
    ON ACTION fc_btn_22     LET l_idx = 22  EXIT MENU
    ON ACTION fc_btn_23     LET l_idx = 23  EXIT MENU
    ON ACTION fc_btn_24     LET l_idx = 24  EXIT MENU
    ON ACTION fc_btn_25     LET l_idx = 25  EXIT MENU
    ON ACTION fc_btn_26     LET l_idx = 26  EXIT MENU
    ON ACTION fc_btn_27     LET l_idx = 27  EXIT MENU
    ON ACTION fc_btn_28     LET l_idx = 28  EXIT MENU
    ON ACTION fc_btn_29     LET l_idx = 29  EXIT MENU
    ON ACTION fc_btn_30     LET l_idx = 30  EXIT MENU
    ON ACTION fc_btn_31     LET l_idx = 31  EXIT MENU
    ON ACTION fc_btn_32     LET l_idx = 32  EXIT MENU
    ON ACTION fc_btn_33     LET l_idx = 33  EXIT MENU
    ON ACTION fc_btn_34     LET l_idx = 34  EXIT MENU
    ON ACTION fc_btn_35     LET l_idx = 35  EXIT MENU
    ON ACTION fc_btn_36     LET l_idx = 36  EXIT MENU
    ON ACTION fc_btn_37     LET l_idx = 37  EXIT MENU
    ON ACTION fc_btn_38     LET l_idx = 38  EXIT MENU
    ON ACTION fc_btn_39     LET l_idx = 39  EXIT MENU
    ON ACTION fc_btn_40     LET l_idx = 40  EXIT MENU
    ON ACTION exit          LET l_idx = 0  EXIT MENU
    ON ACTION close         LET l_idx = 0  EXIT MENU
  END MENU
  
  IF INT_FLAG THEN LET l_idx = 0 END IF
  
  CLOSE WINDOW cl_show_fc_w1
  
  IF l_idx > 0 THEN
    DISPLAY g_prog, " / " , l_gdj02[l_idx].gdj02, " / " ,l_gdj02[l_idx].chart
    #CALL s_dynamic_chart(g_prog, l_gdj02[l_idx].gdj02, )
  END IF
END FUNCTION

