# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_chart_stock_d.4gl
# Descriptions...: 查詢單一料件在各倉庫儲位的可用量
# Date & Author..: No.FUN-BA0095 2011/10/26 By baogc
# Input Parameter: p_value1 combo值1 料號
#                  p_value2 combo值2 單位
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_stock_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_stock_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE img_file.img01
DEFINE p_value2    LIKE img_file.img09
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_sql       STRING
DEFINE l_img       RECORD
             img02 LIKE img_file.img02,
             img03 LIKE img_file.img03,
             img09 LIKE img_file.img09,
             img10 LIKE img_file.img10
                   END RECORD
DEFINE l_lb        STRING
DEFINE l_sub_str   STRING
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_ima02     LIKE ima_file.ima02

   IF cl_null(p_value1) OR cl_null(p_value2) THEN RETURN END IF
   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_stock_d",g_user) THEN RETURN END IF

   LET l_sql = "SELECT img02,img03,img09,SUM(img10) ",
               "  FROM img_file ",
               " WHERE img10 > 0 "
   IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND img01 = '",p_value1,"' " END IF
   IF NOT cl_null(p_value2) THEN LET l_sql = l_sql CLIPPED," AND img09 = '",p_value2,"' " END IF
   LET l_sql = l_sql CLIPPED," GROUP BY img02,img03,img09 "
   LET l_sql = l_sql CLIPPED," ORDER BY img02,img03,img09 "
   PREPARE sel_img_pre FROM l_sql
   DECLARE sel_img_cs CURSOR FOR sel_img_pre
   FOREACH sel_img_cs INTO l_img.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF NOT cl_null(l_img.img03) THEN
         LET l_lb = l_img.img02,"-",l_img.img03
      ELSE
         LET l_lb = l_img.img02
      END IF
      CALL cl_chart_array_data(p_loc,"categories","",l_lb)
      CALL cl_chart_array_data( p_loc,"dataset"," ",l_img.img10)  #欄位值 
      CALL cl_chart_array_attr( p_loc,l_lb,"displayValue",l_img.img09)   #庫存單位 
   END FOREACH

   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_stock_d"
   IF NOT cl_null(p_value1) THEN     #料號
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_ima02,")"
   END IF
   IF NOT cl_null(p_value2) THEN
      IF NOT cl_null(l_sub_str) THEN #單位
         LET l_sub_str = l_sub_str,"(",cl_getmsg(l_gdk03,g_lang),":",p_value2,")"
      ELSE
         LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk03,g_lang),":",p_value2
      END IF
   END IF
   IF NOT cl_null(p_value1) OR NOT cl_null(p_value2) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_stock_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_stock_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_stock_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_sql         STRING
DEFINE l_img01       LIKE img_file.img01
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_img09       LIKE img_file.img09
DEFINE l_gfe02       LIKE gfe_file.gfe02
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_stock_d"
  #TQC-C20485 Add Begin ---
   #若傳入值第一個Combo項不為空，則不做Combo1的填充操作
   IF NOT cl_null(p_def_filter1) THEN
      LET l_def_filter1 = p_def_filter1
   ELSE
  #TQC-C20485 Add End -----
      IF NOT cl_null(l_gdk02) THEN
         INITIALIZE l_combo_value,l_combo_item TO NULL
         LET l_combo = p_cboloc CLIPPED,"_1"
         CALL cl_set_comp_visible(l_combo,TRUE)
         LET l_sql = "SELECT DISTINCT img01,ima02 ",
                     "  FROM img_file,ima_file ",
                     " WHERE img01 = ima01 ",
                     "   AND img10 > 0 ", #TQC-C20485 Add
                     " ORDER BY img01 "
         PREPARE sel_combo_pre1 FROM l_sql
         DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
         FOREACH sel_combo_cs1 INTO l_img01,l_ima02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF NOT cl_null(l_combo_value) THEN
               LET l_combo_value = l_combo_value,",",l_img01
               LET l_combo_item  = l_combo_item,",",l_img01 CLIPPED,"(",l_ima02 CLIPPED,")"
            ELSE
               LET l_combo_value = l_img01
               LET l_combo_item  = l_img01 CLIPPED,"(",l_ima02 CLIPPED,")"
            END IF
         END FOREACH
         CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
         IF l_combo_value.getIndexof(",",1)=0 THEN
            LET l_def_filter1 = l_combo_value
         ELSE
            LET l_def_filter1 = l_combo_value.subString(1,l_combo_value.getIndexof(",",1)-1)
         END IF
      ELSE
         LET l_combo = p_cboloc CLIPPED,"_1"
         CALL cl_set_comp_visible(l_combo,FALSE)
      END IF
  #TQC-C20485 Add Begin ---
      #根據Combo1中取到的值聯動Combo2中的值
      IF NOT cl_null(l_def_filter1) THEN 
         LET p_def_filter1 = l_def_filter1
      END IF
   END IF
  #TQC-C20485 Add End -----


   IF NOT cl_null(l_gdk03) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT img09,gfe02 ",
                  "  FROM img_file,gfe_file ",
                  " WHERE img09 = gfe01 ",
                  "   AND img10 > 0 " #TQC-C20485 Add
                 #" ORDER BY img09 "  #TQC-C20485 Mark
     #TQC-C20485 Add Begin ---
      #根據Combo1中取到的值聯動Combo2中的值
      IF NOT cl_null(p_def_filter1) THEN
         LET l_sql = l_sql CLIPPED," AND img01 = '",p_def_filter1 CLIPPED,"' "
      END IF
      LET l_sql = l_sql CLIPPED," ORDER BY img09 "
     #TQC-C20485 Add End -----
      PREPARE sel_combo_pre2 FROM l_sql
      DECLARE sel_combo_cs2 CURSOR FOR sel_combo_pre2
      FOREACH sel_combo_cs2 INTO l_img09,l_gfe02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_img09 CLIPPED
            LET l_combo_item  = l_combo_item,",",l_img09 CLIPPED,"(",l_gfe02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_img09 CLIPPED
            LET l_combo_item  = l_img09 CLIPPED,"(",l_gfe02 CLIPPED,")"
         END IF
      END FOREACH
      CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
      IF l_combo_value.getIndexof(",",1)=0 THEN
         LET l_def_filter2 = l_combo_value
      ELSE
         LET l_def_filter2 = l_combo_value.subString(1,l_combo_value.getIndexof(",",1)-1)
      END IF
   ELSE
      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,FALSE)
   END IF

   RETURN l_def_filter1,l_def_filter2
END FUNCTION

#FUN-BA0095
