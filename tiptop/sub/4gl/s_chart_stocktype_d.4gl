# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_stocktype_d.4gl
# Descriptions...: 查詢單一料件庫存計劃狀況
# Date & Author..: No.FUN-BA0095 2011/11/29 By qiaozy
# Input Parameter: p_value1 combo值1 產品分類
#                  p_value2 combo值2 
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_stocktype_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_stocktype_d(p_value1,p_value2,p_loc)
DEFINE p_value1      LIKE ima_file.ima01
DEFINE p_value2      LIKE type_file.num5
DEFINE p_loc         LIKE type_file.chr10
DEFINE l_sql         STRING
DEFINE l_ima         RECORD
             ima01   LIKE ima_file.ima01,
             ima27   LIKE ima_file.ima27,
             ima271  LIKE ima_file.ima271
                     END RECORD
DEFINE l_ima26       LIKE ima_file.ima26
DEFINE l_ima261      LIKE ima_file.ima261
DEFINE l_ima262      LIKE ima_file.ima262
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_oba02       LIKE oba_file.oba02
DEFINE l_lj1         STRING
DEFINE l_lj2         STRING
DEFINE l_lj3         STRING
DEFINE l_lj4         STRING
DEFINE l_sub_str     STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_chk_auth       STRING
DEFINE l_n           LIKE type_file.num10

   IF cl_null(p_value1) THEN RETURN END IF
   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_stocktype_d",g_user) THEN 
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc,l_chk_auth)
      RETURN 
   END IF

   LET l_sql = "SELECT DISTINCT ima01,ima27,ima271 ",
               "  FROM ima_file ",
               " WHERE imaacti='Y'  "
   IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND ima131 = '",p_value1,"' " END IF
   LET l_sql = l_sql CLIPPED," ORDER BY ima01"
   
   PREPARE sel_ima_pre FROM l_sql
   DECLARE sel_ima_cs CURSOR FOR sel_ima_pre
   FOREACH sel_ima_cs INTO l_ima.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL s_getstock(l_ima.ima01,g_plant) RETURNING l_ima26,l_ima261,l_ima262
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=l_ima.ima01
      IF NOT cl_null(l_ima02) THEN
         LET l_lj1 = l_ima.ima01,"(",l_ima02 CLIPPED,")"
      ELSE
         LET l_lj1 = l_ima.ima01
      END IF
      LET l_lj2=cl_getmsg('azz1136',g_lang) CLIPPED
      LET l_lj3=cl_getmsg('azz1137',g_lang) CLIPPED
      LET l_lj4=cl_getmsg('azz1138',g_lang) CLIPPED
      CALL cl_chart_array_data( p_loc,"categories","",l_lj1)
      CALL cl_chart_array_data( p_loc,"dataset",l_lj2,l_ima262)
      CALL cl_chart_array_data( p_loc,"dataset",l_lj3,l_ima.ima27)
      CALL cl_chart_array_data( p_loc,"dataset",l_lj4,l_ima.ima271) 
   END FOREACH

   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_stocktype_d"
   IF NOT cl_null(p_value1) THEN     #產品分類
      SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_oba02,")"
   END IF
   IF NOT cl_null(p_value1) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_stocktype_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_stocktype_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_stocktype_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_sql         STRING
DEFINE l_oba01       LIKE oba_file.oba01
DEFINE l_oba02       LIKE oba_file.oba02
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_stocktype_d"
   IF NOT cl_null(l_gdk02) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT oba01,oba02 ",
                  "  FROM ima_file,oba_file ",
                  " WHERE ima131 = oba01 ",
                  "   AND imaacti = 'Y' ",
                  " ORDER BY oba01 "
      PREPARE sel_combo_pre1 FROM l_sql
      DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
      FOREACH sel_combo_cs1 INTO l_oba01,l_oba02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_oba01
            LET l_combo_item  = l_combo_item,",",l_oba01 CLIPPED,"(",l_oba02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_oba01
            LET l_combo_item = l_oba01 CLIPPED,"(",l_oba02 CLIPPED,")"
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

   LET l_combo = p_cboloc CLIPPED,"_2"
   CALL cl_set_comp_visible(l_combo,FALSE)

   RETURN l_def_filter1,l_def_filter2
END FUNCTION

#FUN-BA0095
