# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_purcost_d.4gl
# Descriptions...: 查詢單一料件各供應商價格
# Date & Author..: No.FUN-BA0095 2011/11/30 By qiaozy
# Input Parameter: p_value1 combo值1 料號
#                  p_value2 combo值2 幣別
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_purcost_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_purcost_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE pmh_file.pmh01
DEFINE p_value2    LIKE pmh_file.pmh13
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_sql       STRING
DEFINE l_pmh       RECORD
             pmh02 LIKE pmh_file.pmh02, #供應商編號
             pmh12 LIKE pmh_file.pmh12, #最近採購單價
             pmh13 LIKE pmh_file.pmh13  #採購幣別
                   END RECORD
DEFINE l_cg        STRING
DEFINE l_sub_str   STRING
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_pmc03     LIKE pmc_file.pmc03 #廠商名稱
DEFINE l_chk_auth  STRING

   IF cl_null(p_value1) or cl_null(p_value2) THEN RETURN END IF
   CALL cl_chart_init(p_loc)

   
   IF NOT s_chart_auth("s_chart_purcost_d",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN 
   END IF
   
   INITIALIZE l_pmh.pmh02,l_pmh.pmh13 TO NULL
   LET l_pmh.pmh12=0
   LET l_sql = "SELECT pmh02,pmh12,pmh13 ",
               "  FROM pmh_file ",
               " WHERE pmh22 = '1' ",
               "   AND pmh05 = '0' ",
               "   AND pmhacti = 'Y' "
   IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND pmh01 = '",p_value1,"' " END IF
   IF NOT cl_null(p_value2) THEN LET l_sql = l_sql CLIPPED," AND pmh13 = '",p_value2,"' " END IF
   LET l_sql = l_sql CLIPPED,"  ORDER BY pmh02,pmh13 "
   PREPARE sel_pmh_pre FROM l_sql
   DECLARE sel_pmh_cs CURSOR FOR sel_pmh_pre
   FOREACH sel_pmh_cs INTO l_pmh.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_pmh.pmh12) THEN LET l_pmh.pmh12=0 END IF
            
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=l_pmh.pmh02
      IF cl_null(l_pmc03) THEN
         LET l_cg = l_pmh.pmh02 CLIPPED
      ELSE
         LET l_cg = l_pmh.pmh02 CLIPPED,"(",l_pmc03,")"
      END IF
      CALL cl_chart_array_data(p_loc,"categories","",l_cg)      
      CALL cl_chart_array_data( p_loc,"dataset"," ",l_pmh.pmh12)  #欄位值 
#      CALL cl_chart_array_attr( p_loc,l_cg,"displayValue",l_pmh.pmh13)   #幣別 
      INITIALIZE l_pmh.pmh02,l_pmh.pmh13,l_pmc03 TO NULL
      LET l_pmh.pmh12=0
   END FOREACH

   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_purcost_d"
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
   CALL cl_chart_create(p_loc,"s_chart_purcost_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_purcost_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_purcost_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_sql         STRING
DEFINE l_pmh01       LIKE pmh_file.pmh01 #料件編號
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_pmh13       LIKE pmh_file.pmh13
DEFINE l_azi02       LIKE azi_file.azi02
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_purcost_d"
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
         LET l_sql = "SELECT DISTINCT pmh01,ima02 ",
                     "  FROM pmh_file,ima_file ",
                     " WHERE pmh01 = ima01 ",
                     "   AND pmhacti = 'Y' ",
                     "   AND imaacti = 'Y' ",
                     " ORDER BY pmh01 "
         PREPARE sel_combo_pre1 FROM l_sql
         DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
         FOREACH sel_combo_cs1 INTO l_pmh01,l_ima02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF NOT cl_null(l_combo_value) THEN
               LET l_combo_value = l_combo_value,",",l_pmh01
               LET l_combo_item  = l_combo_item,",",l_pmh01 CLIPPED,"(",l_ima02 CLIPPED,")"
            ELSE
               LET l_combo_value = l_pmh01
               LET l_combo_item  = l_pmh01 CLIPPED,"(",l_ima02 CLIPPED,")"
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
      LET l_sql = "SELECT DISTINCT pmh13,azi02 ",
                  "  FROM pmh_file,azi_file ",
                  " WHERE pmh13 = azi01 ",
                  "   AND pmhacti = 'Y' ",
                  "   AND aziacti = 'Y' "  #TQC-C20485 Add
                 #"   AND aziacti = 'Y' ", #TQC-C20485 Mark
                 #" ORDER BY pmh13 "       #TQC-C20485 Mark
     #TQC-C20485 Add Begin ---
      IF NOT cl_null(p_def_filter1) THEN
         LET l_sql = l_sql CLIPPED," AND pmh01 = '",p_def_filter1 CLIPPED,"' "
      END IF
      LET l_sql = l_sql CLIPPED," ORDER BY pmh13 "
     #TQC-C20485 Add End -----
      PREPARE sel_combo_pre2 FROM l_sql
      DECLARE sel_combo_cs2 CURSOR FOR sel_combo_pre2
      FOREACH sel_combo_cs2 INTO l_pmh13,l_azi02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_pmh13 CLIPPED
            LET l_combo_item  = l_combo_item,",",l_pmh13 CLIPPED,"(",l_azi02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_pmh13 CLIPPED
            LET l_combo_item  = l_pmh13 CLIPPED,"(",l_azi02 CLIPPED,")"
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
