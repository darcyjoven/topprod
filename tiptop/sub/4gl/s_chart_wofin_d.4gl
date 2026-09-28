# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_chart_wofin_d.4gl
# Descriptions...: 查詢單一單一工單完成狀況
# Date & Author..: No.FUN-BA0095 2011/11/30 By qiaozy
# Input Parameter: p_value1 combo值1 料號
#                  p_value2 combo值2 null
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_wofin_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_wofin_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE sfb_file.sfb05
DEFINE p_value2    LIKE type_file.num5
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_sql       STRING
DEFINE l_sfb05     LIKE sfb_file.sfb05
DEFINE l_sfb01     LIKE sfb_file.sfb01 
DEFINE l_ima58     LIKE ima_file.ima58
DEFINE l_srg10     LIKE srg_file.srg10
DEFINE l_shb032    LIKE shb_file.shb032
DEFINE l_sfb93     LIKE sfb_file.sfb93
DEFINE l_gd        STRING
DEFINE l_gd1       STRING
DEFINE l_sub_str   STRING
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_chk_auth  STRING

   IF cl_null(p_value1) THEN RETURN END IF
   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_stock_d",g_user) THEN
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN
   END IF

   LET l_sql = "SELECT sfb01 ",
               "  FROM sfb_file ",
               " WHERE sfb04 <> '8' "
   IF NOT cl_null(p_value1) THEN LET l_sql=l_sql CLIPPED," AND sfb05 = '",p_value1,"' " END IF
   LET l_sql = l_sql CLIPPED," ORDER BY sfb01 "
   PREPARE sel_sfb_pre FROM l_sql
   DECLARE sel_sfb_cs CURSOR FOR sel_sfb_pre
   INITIALIZE l_sfb01,l_sfb93 TO NULL
   LET l_ima58 = 0
   LET l_srg10 = 0
   LET l_shb032 = 0
   FOREACH sel_sfb_cs INTO l_sfb01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT (ima58+ima912)*sfb08 INTO l_ima58
        FROM ima_file,sfb_file
       WHERE ima01=sfb05
         AND sfb01=l_sfb01
      IF cl_null(l_ima58) THEN LET l_ima58=0 END IF
      SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=l_sfb01
      IF l_sfb93='N' THEN
         SELECT SUM(srg10+srg19)/60 INTO l_srg10
           FROM srg_file,srf_file
          WHERE srg01=srf01
            AND srg01=l_sfb01
            AND srfconf='Y'
         GROUP BY srg01 
      ELSE
         SELECT SUM(shb032+shb033)/60 INTO l_srg10
           FROM shb_file
          WHERE shb05=l_sfb01
            AND shbconf='Y'
          GROUP BY shb05
      END IF
      IF cl_null(l_srg10) THEN LET l_srg10=0 END IF
      
      LET l_gd = cl_getmsg('azz1142',g_lang) CLIPPED
      LET l_gd1 = cl_getmsg('azz1143',g_lang) CLIPPED
      CALL cl_chart_array_data( p_loc,"categories","",l_sfb01)
      CALL cl_chart_array_data( p_loc,"dataset",l_gd,l_ima58)
      CALL cl_chart_array_data( p_loc,"dataset",l_gd1,l_srg10)  #欄位值 
      LET l_ima58=0
      LET l_srg10=0
      INITIALIZE l_sfb01,l_sfb93 TO NULL
      
   END FOREACH

   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_wofin_d"
   IF NOT cl_null(p_value1) THEN     #料號
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_ima02,")"
   END IF
   IF NOT cl_null(p_value1) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_wofin_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_wofin_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_wofin_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
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
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_wofin_d"
   IF NOT cl_null(l_gdk02) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT sfb05,ima02 ",
                  "  FROM sfb_file,ima_file ",
                  " WHERE sfb05 = ima01 ",
                  "   AND sfb04 <> '8' "
      PREPARE sel_combo_pre1 FROM l_sql
      DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
      FOREACH sel_combo_cs1 INTO l_sfb05,l_ima02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_sfb05
            LET l_combo_item  = l_combo_item,",",l_sfb05 CLIPPED,"(",l_ima02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_sfb05
            LET l_combo_item  = l_sfb05 CLIPPED,"(",l_ima02 CLIPPED,")"
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
