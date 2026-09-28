# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_wo_qtydiff_d.4gl
# Descriptions...: 查詢元件各工單用量
# Date & Author..: No.FUN-BA0095 2011/11/30 By qiaozy
# Input Parameter: p_value1 combo值1 主件編號
#                  p_value2 combo值2 元件編號
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_wo_qtydiff_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_wo_qtydiff_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE sfb_file.sfb05
DEFINE p_value2    LIKE sfa_file.sfa27
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_sql       STRING
DEFINE l_sfb01     LIKE sfb_file.sfb01
DEFINE l_sfa06     LIKE sfa_file.sfa06
DEFINE l_sfb08     LIKE sfb_file.sfb08
DEFINE l_sfa161    LIKE sfa_file.sfa161
DEFINE l_count     like sfa_file.sfa06
DEFINE l_max       LIKE sfa_file.sfa161
DEFINE l_min       LIKE sfa_file.sfa161
DEFINE l_avg       LIKE sfa_file.sfa161
DEFINE l_sum       LIKE type_file.num20 
DEFINE l_n         LIKE type_file.num5      
DEFINE l_gd        STRING
DEFINE l_gd1       STRING
DEFINE l_gd2       STRING
DEFINE l_gd3       STRING
DEFINE l_gd4       STRING
DEFINE l_sub_str   STRING
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_chk_auth  STRING


   IF cl_null(p_value1) OR cl_null(p_value2) THEN RETURN END IF
   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_wo_qtydiff_d",g_user) THEN
      LET l_chk_auth = cl_getmsg('azz1135',g_lang)
      CALL cl_chart_set_empty(p_loc,l_chk_auth)
      RETURN
   END IF
   LET l_sfa06=0
   LET l_sfb08=1
   LET l_sfa161=0
   LET l_count=0
   LET l_sum=0
   LET l_n=0
   INITIALIZE l_sfb01,l_max,l_min TO NULL

  #baogc -- 調整
   LET l_sql = "SELECT DISTINCT sfb01,SUM(sfa06),SUM(sfb08),SUM(sfa161) ",
               "  FROM sfa_file,sfb_file ",
               " WHERE sfa01 = sfb01 ",
               "   AND sfb04 = '8' "
   IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND sfb05 = '",p_value1,"' " END IF
   IF NOT cl_null(p_value2) THEN LET l_sql = l_sql CLIPPED," AND sfa27 = '",p_value2,"' " END IF
   LET l_sql = l_sql CLIPPED," GROUP BY sfb01"
   PREPARE sel_sfa_pre FROM l_sql
   DECLARE sel_sfa_cs CURSOR FOR sel_sfa_pre
   FOREACH sel_sfa_cs INTO l_sfb01,l_sfa06,l_sfb08,l_sfa161
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     #SELECT SUM(sfa06) INTO l_sfa06 FROM sfa_file WHERE sfa01=l_sfb01 GROUP BY sfa01
     #SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01=l_sfb01
     #SELECT SUM(sfa161) INTO l_sfa161 FROM sfa_file WHERE sfa01=l_sfb01 GROUP BY sfa01
      IF cl_null(l_sfa161) THEN LET l_sfa161=0 END IF #實際QPA
      IF cl_null(l_min) THEN
         LET l_min=l_sfa161
      ELSE
         IF l_min > l_sfa161 THEN
            LET l_min=l_sfa161
         END IF
      END IF
      IF cl_null(l_max) THEN
         LET l_max=l_sfa161
      ELSE
         IF l_max < l_sfa161 THEN
            LET l_max=l_sfa161
         END IF
      END IF
      LET l_sum = l_sum+l_sfa161
      LET l_n=l_n+1
      IF cl_null(l_sfa06) THEN LET l_sfa06=0 END IF
      IF l_sfb08=0 THEN LET l_sfb08=1 END IF
      LET l_count = l_sfa06/l_sfb08    #工單QPA
      LET l_gd = cl_getmsg('azz1145',g_lang) CLIPPED
      LET l_gd1 = cl_getmsg('azz1146',g_lang) CLIPPED
      CALL cl_chart_array_data( p_loc,"categories","",l_sfb01)
      CALL cl_chart_array_data( p_loc,"dataset",l_gd,l_count)  #工單QPA
      CALL cl_chart_array_data( p_loc,"dataset",l_gd1,l_sfa161) #實際QPA
      INITIALIZE l_sfb01 TO NULL
      LET l_sfa06=0
      LET l_sfb08=0
      LET l_sfa161=0
      LET l_count=0
   END FOREACH
   LET l_avg=l_sum/l_n
   LET l_gd2 = cl_getmsg('azz1147',g_lang) CLIPPED
   LET l_gd3 = cl_getmsg('azz1148',g_lang) CLIPPED
   LET l_gd4 = cl_getmsg('azz1149',g_lang) CLIPPED
   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_wo_qtydiff_d"
   IF NOT cl_null(p_value1) THEN     #主件編號
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_ima02,")"
   END IF
   IF NOT cl_null(p_value2) THEN     #元件編號
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = p_value2
      IF NOT cl_null(l_sub_str) THEN 
         LET l_sub_str = l_sub_str,"/",cl_getmsg(l_gdk03,g_lang),":",p_value2,"(",l_ima02,")"
      ELSE
         LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk03,g_lang),":",p_value2,"(",l_ima02,")"
      END IF
   END IF
   CALL cl_chart_del_trend_line( p_loc  )  #先清空標準線 
   CALL cl_chart_add_trend_line( p_loc , l_max, l_max, "FF0000", l_gd2,"valueOnRight=1,thickness=3")  #最高-紅線 
   CALL cl_chart_add_trend_line( p_loc , l_avg, l_avg, "009900", l_gd3,"valueOnRight=1,thickness=3")      #平均-綠線 
   CALL cl_chart_add_trend_line( p_loc , l_min, l_min, "0000FF", l_gd4,"valueOnRight=1,thickness=3")       #最低-藍線
   IF NOT cl_null(p_value1) OR NOT cl_null(p_value2) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_wo_qtydiff_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_wo_qtydiff_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_wo_qtydiff_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_sql         STRING
DEFINE l_sfb05       LIKE sfb_file.sfb05
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_sfa27       LIKE sfa_file.sfa27
DEFINE l_ima021      LIKE ima_file.ima02
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_wo_qtydiff_d"
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
         LET l_sql = "SELECT DISTINCT sfb05,ima02 ",
                     "  FROM sfb_file,ima_file ",
                     " WHERE sfb05 = ima01 ",
                     "   AND sfb04 = '8' ",
                     " ORDER BY sfb05 "
         PREPARE sel_combo_pre1 FROM l_sql
         DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
         FOREACH sel_combo_cs1 INTO l_sfb05,l_ima02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF NOT cl_null(l_combo_value) THEN
               LET l_combo_value = l_combo_value,",",l_sfb05
               LET l_combo_item  = l_combo_item,",",l_sfb05,"(",l_ima02,")"
            ELSE
               LET l_combo_value = l_sfb05
               LET l_combo_item = l_sfb05,"(",l_ima02,")"
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
      INITIALIZE l_combo_value,l_combo_item,l_sfa27,l_ima021 TO NULL
      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT sfa27,ima02 ",
                  "  FROM ima_file,sfa_file,sfb_file ",
                  " WHERE sfb01 = sfa01 ",
                  "   AND sfa27 = ima01 ",
                  "   AND sfb04 = '8' "
     #TQC-C20485 Add Begin ---
      IF NOT cl_null(p_def_filter1) THEN
         LET l_sql = l_sql CLIPPED," AND sfb05 = '",p_def_filter1 CLIPPED,"' "
      END IF
      LET l_sql = l_sql CLIPPED," ORDER BY sfa27 "
     #TQC-C20485 Add End -----
      PREPARE sel_combo_pre2 FROM l_sql
      DECLARE sel_combo_cs2 CURSOR FOR sel_combo_pre2
      FOREACH sel_combo_cs2 INTO l_sfa27,l_ima021
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_sfa27 CLIPPED
            LET l_combo_item = l_combo_item,",",l_sfa27 CLIPPED,"(",l_ima021 CLIPPED,")"
         ELSE
            LET l_combo_value = l_sfa27 CLIPPED
            LET l_combo_item = l_sfa27 CLIPPED,"(",l_ima021 CLIPPED,")"
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
