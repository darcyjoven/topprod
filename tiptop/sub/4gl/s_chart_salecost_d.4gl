# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_salecost_d.4gl
# Descriptions...: 查詢單一料件各客戶最近銷售價格
# Date & Author..: No.FUN-BA0095 2011/11/30 By qiaozy
# Input Parameter: p_value1 combo值1 料號
#                  p_value2 combo值2 幣別
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_salecost_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_salecost_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE obk_file.obk01
DEFINE p_value2    LIKE obk_file.obk05
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_sql       STRING
DEFINE l_obk       RECORD
             obk02 LIKE obk_file.obk02,
             obk05 LIKE obk_file.obk05,
             obk08 LIKE obk_file.obk08
                   END RECORD
DEFINE l_xs        STRING
DEFINE l_sub_str   STRING
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_occ02     LIKE occ_file.occ02
DEFINE l_chk_auth  STRING

   IF cl_null(p_value1) OR cl_null(p_value2) THEN RETURN END IF
   CALL cl_chart_init(p_loc)

   
   IF NOT s_chart_auth("s_chart_salecost_d",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN 
   END IF

   LET l_sql = "SELECT obk02,obk05,obk08 ",
               "  FROM obk_file ",
               " WHERE obkacti = 'Y' ",
               "   AND obk08 > 0 "
   IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND obk01 = '",p_value1,"' " END IF
   IF NOT cl_null(p_value2) THEN LET l_sql = l_sql CLIPPED," AND obk05 = '",p_value2,"' " END IF
   LET l_sql = l_sql CLIPPED,"  ORDER BY obk02,obk05 "
   PREPARE sel_pmh_pre FROM l_sql
   DECLARE sel_pmh_cs CURSOR FOR sel_pmh_pre
   FOREACH sel_pmh_cs INTO l_obk.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_obk.obk08) THEN LET l_obk.obk08=0 END IF
      
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=l_obk.obk02
      IF cl_null(l_occ02) THEN
         LET l_xs = l_obk.obk02 CLIPPED
      ELSE
         LET l_xs = l_obk.obk02 CLIPPED,"(",l_occ02,")"
      END IF
      CALL cl_chart_array_data(p_loc,"categories","",l_xs)      
      CALL cl_chart_array_data( p_loc,"dataset"," ",l_obk.obk08)  #欄位值 
     #CALL cl_chart_array_attr( p_loc,l_xs,"displayValue",l_obk.obk05)   #幣別
      LET l_obk.obk08=0
      INITIALIZE l_obk.obk05,l_obk.obk02 TO NULL
   END FOREACH

   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_salecost_d"
   IF NOT cl_null(p_value1) THEN     #料號
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_ima02,")"
   END IF
   IF NOT cl_null(p_value2) THEN
      IF NOT cl_null(l_sub_str) THEN #幣別
         LET l_sub_str = l_sub_str,"(",cl_getmsg(l_gdk03,g_lang),":",p_value2,")"
      ELSE
         LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk03,g_lang),":",p_value2
      END IF
   END IF
   IF NOT cl_null(p_value1) OR NOT cl_null(p_value2) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_salecost_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_salecost_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_salecost_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_sql         STRING
DEFINE l_obk01       LIKE obk_file.obk01
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_obk05       LIKE obk_file.obk05
DEFINE l_azi02       LIKE azi_file.azi02
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_salecost_d"
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
         LET l_sql = "SELECT DISTINCT obk01,ima02 ",
                     "  FROM obk_file,ima_file ",
                     " WHERE obk01 = ima01 ",
                     "   AND obkacti = 'Y' ",
                     "   AND imaacti = 'Y' ",
                     " ORDER BY obk01 "
         PREPARE sel_combo_pre1 FROM l_sql
         DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
         FOREACH sel_combo_cs1 INTO l_obk01,l_ima02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF NOT cl_null(l_combo_value) THEN
               LET l_combo_value = l_combo_value,",",l_obk01
               LET l_combo_item  = l_combo_item,",",l_obk01 CLIPPED,"(",l_ima02 CLIPPED,")"
            ELSE
               LET l_combo_value = l_obk01
               LET l_combo_item = l_obk01 CLIPPED,"(",l_ima02 CLIPPED,")"
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
      LET l_sql = "SELECT DISTINCT obk05,azi02 ",
                  "  FROM obk_file,azi_file ",
                  " WHERE obk05 = azi01 ",
                  "   AND obkacti = 'Y' ",
                  "   AND aziacti = 'Y' "  #TQC-C20485 Add
                 #"   AND aziacti = 'Y' ", #TQC-C20485 Mark
                 #" ORDER BY obk05 "       #TQC-C20485 Mark
     #TQC-C20485 Add Begin ---
      IF NOT cl_null(p_def_filter1) THEN 
         LET l_sql = l_sql CLIPPED," AND obk01 = '",p_def_filter1 CLIPPED,"' "
      END IF
      LET l_sql = l_sql CLIPPED," ORDER BY obk05 "
     #TQC-C20485 Add End -----
      PREPARE sel_combo_pre2 FROM l_sql
      DECLARE sel_combo_cs2 CURSOR FOR sel_combo_pre2
      FOREACH sel_combo_cs2 INTO l_obk05,l_azi02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_obk05 CLIPPED
            LET l_combo_item = l_combo_item,",",l_obk05 CLIPPED,"(",l_azi02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_obk05 CLIPPED
            LET l_combo_item = l_obk05 CLIPPED,"(",l_azi02 CLIPPED,")"
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
