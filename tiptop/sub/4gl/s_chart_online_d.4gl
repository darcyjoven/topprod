# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_chart_online_d.4gl
# Descriptions...: 查詢各部門的線上使用者數
# Date & Author..: No.FUN-BA0095 2011/10/27 By baogc
# Input Parameter: p_value1 combo值1（排除部門）
#                  p_value2 combo值2
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_online_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_online_d(p_value1,p_value2,p_loc)
DEFINE p_value1   LIKE gbq_file.gbq05
DEFINE p_value2   LIKE type_file.num5
DEFINE p_loc      LIKE type_file.chr10
DEFINE l_dept     STRING
DEFINE l_gbq      RECORD
           gbq05  LIKE gbq_file.gbq05,
           olnum  LIKE type_file.num5
                  END RECORD
DEFINE l_sub_str  STRING
DEFINE l_sql      STRING
DEFINE l_gem02    LIKE gem_file.gem02
DEFINE l_gdk02    LIKE gdk_file.gdk02
DEFINE l_gdk03    LIKE gdk_file.gdk03

  #IF cl_null(p_value1) THEN RETURN END IF #TQC-C20485 Mark
   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_online_d",g_user) THEN RETURN END IF

   LET l_sql = "SELECT gbq05,COUNT(*) FROM gbq_file "
   IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," WHERE gbq05 <> '",p_value1,"' " END IF
   LET l_sql = l_sql CLIPPED," GROUP BY gbq05"
   PREPARE sel_gbq_pre FROM l_sql
   DECLARE sel_gbq_cs CURSOR FOR sel_gbq_pre
   FOREACH sel_gbq_cs INTO l_gbq.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_gbq.gbq05
      LET l_dept = l_gbq.gbq05 CLIPPED,"(",l_gem02 CLIPPED,")"            #部門編號(部門名稱)
      CALL cl_chart_array_data(p_loc,"categories","",l_dept)
      CALL cl_chart_array_data(p_loc,"dataset"," ",l_gbq.olnum)  #欄位值    
   END FOREACH
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_online_d"
   IF NOT cl_null(p_value1) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_gem02 CLIPPED,")"
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_online_d")
   CALL cl_chart_clear(p_loc)       #清除wc1相關變數資料(釋放記憶體) 

END FUNCTION

# Descriptions...: 設定圖表的Combo選項
# Date & Author..: No.FUN-BA0095 2011/10/26 By baogc
# Input Parameter: p_cboloc  Combo位置

#FUNCTION s_chart_online_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_online_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc       LIKE type_file.chr10
DEFINE l_def_filter1  STRING
DEFINE l_def_filter2  STRING
DEFINE l_gdk02        LIKE gdk_file.gdk02
DEFINE l_gdk03        LIKE gdk_file.gdk03
DEFINE l_gem01        LIKE gem_file.gem01
DEFINE l_gem02        LIKE gem_file.gem02
DEFINE l_combo        LIKE type_file.chr12
DEFINE l_combo_value  STRING
DEFINE l_combo_item   STRING
DEFINE l_sql          STRING
DEFINE p_def_filter1  STRING #TQC-C20485 Add
DEFINE p_def_filter2  STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_online_d"
   IF NOT cl_null(l_gdk02) THEN
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
     #LET l_sql = "SELECT gem01,gem02 FROM gem_file WHERE gemacti = 'Y' ORDER BY gem01 "
      LET l_sql = "SELECT DISTINCT gbq05,gem02 FROM gbq_file JOIN gem_file ON gbq05 = gem01 ORDER BY gbq05"
      PREPARE sel_gem_pre FROM l_sql
      DECLARE sel_gem_cs CURSOR FOR sel_gem_pre
      FOREACH sel_gem_cs INTO l_gem01,l_gem02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_gem01
            LET l_combo_item  = l_combo_item,",",l_gem01 CLIPPED,"(",l_gem02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_gem01
            LET l_combo_item = l_gem01 CLIPPED,"(",l_gem02 CLIPPED,")"
         END IF
      END FOREACH
      CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
   ELSE
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,FALSE)
   END IF

   LET l_combo = p_cboloc CLIPPED,"_2"
   CALL cl_set_comp_visible(l_combo,FALSE)

  #TQC-C20485 Add&Mark Begin ---
  #IF l_combo_value.getIndexof(",",1)=0 THEN
  #   LET l_def_filter1 = l_combo_value
  #ELSE
  #   LET l_def_filter1 = l_combo_value.subString(1,l_combo_value.getIndexof(",",1)-1)
  #END IF

   LET l_def_filter1 = NULL
  #TQC-C20485 Add&Mark End -----
   RETURN l_def_filter1,l_def_filter2

END FUNCTION

#FUN-BA0095
