# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_verreceipt_d.4gl
# Descriptions...: 廠商採購收貨狀況
# Date & Author..: No.FUN-BA0095 2011/11/30 By qiaozy
# Input Parameter: p_value1 combo值1 廠商編號
#                  p_value2 combo值2 null
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_verreceipt_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_verreceipt_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE pmm_file.pmm09
DEFINE p_value2    LIKE type_file.num5
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_sql       STRING
DEFINE l_pmn       RECORD
        pmn04      LIKE pmn_file.pmn04, #料件編號
        pmn07      LIKE pmn_file.pmn07,  #採購單位
        pur_qty    LIKE pmn_file.pmn20,
        rec_qty    LIKE pmn_file.pmn50
                   END RECORD
DEFINE l_cs        STRING
DEFINE l_cs1       STRING
DEFINE l_cs2       STRING
DEFINE l_cs3       STRING
DEFINE l_sub_str   STRING
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_pmc03     LIKE pmc_file.pmc03
DEFINE l_chk_auth  STRING

   IF cl_null(p_value1) THEN RETURN END IF
   CALL cl_chart_init(p_loc)

   
   IF NOT s_chart_auth("s_chart_verreceipt_d",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN 
   END IF
   INITIALIZE l_pmn.pmn04,l_pmn.pmn07 TO NULL
   LET l_pmn.pur_qty=0
   LET l_pmn.rec_qty=0
   LET l_sql = "SELECT pmn04,pmn07,SUM(pmn20),SUM(pmn50-pmn55-pmn58) ",
               "  FROM pmn_file,pmm_file ",
               " WHERE pmm01 = pmn01 ",
               "   AND pmm25 = '2' ",
               "   AND pmn16 = '2' ",
               "   AND pmn20-pmn50+pmn55+pmn58 > 0 "
   IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND pmm09 = '",p_value1,"' " END IF
   LET l_sql = l_sql CLIPPED," GROUP BY pmn04,pmn07 "
   PREPARE sel_pmn_pre FROM l_sql
   DECLARE sel_pmn_cs CURSOR FOR sel_pmn_pre
   FOREACH sel_pmn_cs INTO l_pmn.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=l_pmn.pmn04
      IF cl_null(l_ima02) THEN
         LET l_cs = l_pmn.pmn04 CLIPPED
      ELSE
         LET l_cs = l_pmn.pmn04 CLIPPED,"(",l_ima02,")"
      END IF
      LET l_cs1=cl_getmsg('azz1139',g_lang) CLIPPED
      LET l_cs2=cl_getmsg('azz1140',g_lang) CLIPPED
      LET l_cs3=cl_getmsg('azz1141',g_lang) CLIPPED
      CALL cl_chart_array_data( p_loc,"categories","",l_cs)
      CALL cl_chart_array_data( p_loc,"dataset",l_cs1,l_pmn.pur_qty)  #採購數量
      CALL cl_chart_array_data( p_loc,"dataset",l_cs2,l_pmn.rec_qty)   #已收貨數量
      CALL cl_chart_array_attr( p_loc,l_cs3,"displayValue",l_pmn.pmn07)   #採購單位
      INITIALIZE l_pmn.pmn04,l_pmn.pmn07 TO NULL
      LET l_pmn.pur_qty=0
      LET l_pmn.rec_qty=0 
   END FOREACH

   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_verreceipt_d"
   IF NOT cl_null(p_value1) THEN     #料號
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_pmc03,")"
   END IF

   IF NOT cl_null(p_value1) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_verreceipt_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_verreceipt_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_verreceipt_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_sql         STRING
DEFINE l_pmm09       LIKE pmm_file.pmm09
DEFINE l_pmc02       LIKE pmc_file.pmc03
DEFINE l_pmh13       LIKE pmh_file.pmh13
DEFINE l_azi02       LIKE azi_file.azi02
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_verreceipt_d"
   IF NOT cl_null(l_gdk02) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT pmm09,pmc03 ",
                  "  FROM pmm_file,pmn_file,pmc_file ",
                  " WHERE pmm01 = pmn01 ",
                  "   AND pmm09 = pmc01 ",
                  "   AND pmm25 = '2' ",
                  "   AND pmn16 = '2' ",
                  "   AND pmn20-pmn50+pmn55+pmn58>0",
                  "   AND pmmacti = 'Y' ",
                  " ORDER BY pmm09 "
      PREPARE sel_combo_pre1 FROM l_sql
      DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
      FOREACH sel_combo_cs1 INTO l_pmm09,l_pmc02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_pmm09 CLIPPED
            LET l_combo_item  = l_combo_item,",",l_pmm09 CLIPPED,"(",l_pmc02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_pmm09 CLIPPED
            LET l_combo_item  = l_pmm09 CLIPPED,"(",l_pmc02 CLIPPED,")"
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
