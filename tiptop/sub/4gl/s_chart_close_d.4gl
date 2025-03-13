# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_chart_close_d.4gl
# Descriptions...: 查詢企業各模組的關帳狀況
# Date & Author..: No.FUN-BA0095 2011/10/26 By baogc
# Input Parameter: p_modu 模組別
#                  p_ym   關帳年月
#                  p_loc  圖表位置
# Usage..........: CALL s_chart_close_d(p_modu,p_ym,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_close_d(p_modu,p_ym,p_loc)
DEFINE p_modu     LIKE type_file.chr10
DEFINE p_ym       LIKE type_file.chr6
DEFINE p_loc      LIKE type_file.chr10
DEFINE l_month    LIKE type_file.num5
DEFINE l_year     LIKE type_file.num5
DEFINE l_value    LIKE type_file.num5
DEFINE l_ym_str   LIKE type_file.chr6
DEFINE l_sub_str  STRING
DEFINE l_modu_str STRING
DEFINE l_sql      STRING

   IF cl_null(p_modu) THEN LET p_modu = '01' END IF
   IF cl_null(p_ym) THEN 
      IF MONTH(TODAY) = 1 THEN
         LET l_year  = YEAR(TODAY) - 1
         LET p_ym = MDY(12,1,l_year) USING "YYYYMM"
      ELSE
         LET l_month = MONTH(TODAY) - 1
         LET l_year  = YEAR(TODAY)
         LET p_ym = MDY(l_month,1,l_year) USING "YYYYMM"
      END IF
   END IF

   CALL cl_chart_init(p_loc) #

   IF NOT s_chart_auth("s_chart_close_d",g_user) THEN RETURN END IF

   CASE p_modu
      WHEN '01'
         LET l_modu_str = cl_getmsg('azz-170',g_lang) #總帳系統
         LET l_sql = "SELECT ",cl_tp_tochar("aaa07",'YYYYMM'),
                     "  FROM aaa_file",
                     " WHERE aaa01 = '",g_aaz.aaz64,"' "
         PREPARE sel_aaa_pre FROM l_sql
         EXECUTE sel_aaa_pre INTO l_ym_str
      WHEN '02'
         LET l_modu_str = cl_getmsg('azz-171',g_lang) #庫存系統
         LET l_sql = "SELECT ",cl_tp_tochar("sma53",'YYYYMM'),
                     "  FROM sma_file ",
                     " WHERE sma00 = '0' "
         PREPARE sel_sma_pre FROM l_sql
         EXECUTE sel_sma_pre INTO l_ym_str
      WHEN '03'
         LET l_modu_str = cl_getmsg('azz-172',g_lang) #應付系統
         LET l_sql = "SELECT ",cl_tp_tochar("apz57",'YYYYMM'),
                     "  FROM apz_file ",
                     " WHERE apz00 = '0' "
         PREPARE sel_apz_pre FROM l_sql
         EXECUTE sel_apz_pre INTO l_ym_str
      WHEN '04'
         LET l_modu_str = cl_getmsg('azz-173',g_lang) #應收系統
         LET l_sql = "SELECT ",cl_tp_tochar("ooz09",'YYYYMM'),
                     "  FROM ooz_file ",
                     " WHERE ooz00 = '0' "
         PREPARE sel_ooz_pre FROM l_sql
         EXECUTE sel_ooz_pre INTO l_ym_str
      WHEN '05'
         LET l_modu_str = cl_getmsg('azz-174',g_lang) #票據系統
         LET l_sql = "SELECT ",cl_tp_tochar("nmz10",'YYYYMM'),
                     "  FROM nmz_file ",
                     " WHERE nmz00 = '0' "
         PREPARE sel_nmz_pre FROM l_sql
         EXECUTE sel_nmz_pre INTO l_ym_str
      WHEN '06'
         LET l_modu_str = cl_getmsg('azz-175',g_lang) #固資財簽
         LET l_sql = "SELECT ",cl_tp_tochar("faa09",'YYYYMM'),
                     "  FROM faa_file ",
                     " WHERE faa00 = '0' "
         PREPARE sel_faa_pre FROM l_sql
         EXECUTE sel_faa_pre INTO l_ym_str
      WHEN '07'
         LET l_modu_str = cl_getmsg('azz-177',g_lang) #固資稅簽
         LET l_sql = "SELECT ",cl_tp_tochar("faa13",'YYYYMM'),
                     "  FROM faa_file ",
                     " WHERE faa00 = '0' "
         PREPARE sel_faa_pre2 FROM l_sql
         EXECUTE sel_faa_pre2 INTO l_ym_str
      WHEN '08'
         LET l_modu_str = cl_getmsg('azz-178',g_lang) #銷售系統
         LET l_sql = "SELECT ",cl_tp_tochar("oaz09",'YYYYMM'),
                     "  FROM oaz_file ",
                     " WHERE oaz00 = '0' "
         PREPARE sel_oaz_pre FROM l_sql
         EXECUTE sel_oaz_pre INTO l_ym_str
      WHEN '09'
         LET l_modu_str = cl_getmsg('azz-179',g_lang) #保稅系統
         LET l_sql = "SELECT ",cl_tp_tochar("bxz09",'YYYYMM'),
                     "  FROM bxz_file ",
                     " WHERE bxz00 = '0' "
         PREPARE sel_bxz_pre FROM l_sql
         EXECUTE sel_bxz_pre INTO l_ym_str
      WHEN '10'
         LET l_modu_str = cl_getmsg('azz-180',g_lang) #百貨專櫃核算
         LET l_sql = "SELECT ",cl_tp_tochar("rcj01",'YYYYMM'),
                     "  FROM rcj_file ",
                     " WHERE rcj00 = '0' "
         PREPARE sel_rcj_pre FROM l_sql
         EXECUTE sel_rcj_pre INTO l_ym_str
   END CASE

   IF l_ym_str >= p_ym THEN
      LET l_value = 5
      LET l_sub_str = l_modu_str CLIPPED," - ",p_ym CLIPPED," - ",cl_getmsg('azz-183',g_lang) #已關帳
   ELSE
      LET l_value = 1
      LET l_sub_str = l_modu_str CLIPPED," - ",p_ym CLIPPED," - ",cl_getmsg('azz-184',g_lang) #未關帳
   END IF

   CALL cl_chart_bulb_comp(p_loc,l_sub_str,l_value,2,4,6)
   CALL cl_chart_attr(p_loc,"subcaption",l_sub_str)   #設定子標題
   CALL cl_chart_create_comp(p_loc,"s_chart_close_d") 
   CALL cl_chart_clear(p_loc)                         #清除相關變數資料(釋放記憶體) 

END FUNCTION

# Descriptions...: 設定圖表的Combo選項
# Date & Author..: No.FUN-BA0095 2011/10/26 By baogc
# Input Parameter: p_cboloc  Combo位置

#FUNCTION s_chart_close_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_close_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc       LIKE type_file.chr10
DEFINE l_def_filter1  STRING
DEFINE l_def_filter2  STRING
DEFINE l_gdk02        LIKE gdk_file.gdk02
DEFINE l_gdk03        LIKE gdk_file.gdk03
DEFINE l_year         LIKE type_file.num5
DEFINE l_month        LIKE type_file.num5
DEFINE l_date         DATE
DEFINE l_combo        LIKE type_file.chr12
DEFINE l_combo_value  STRING
DEFINE l_combo_item   STRING
DEFINE l_rtz03        LIKE rtz_file.rtz03
DEFINE l_i            LIKE type_file.num5
DEFINE l_ym           LIKE type_file.chr6
DEFINE p_def_filter1  STRING #TQC-C20485 Add
DEFINE p_def_filter2  STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL

   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_close_d"

   IF NOT cl_null(l_gdk02) THEN
      INITIALIZE l_combo_item,l_combo_value TO NULL
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_combo_value = "01,02,03,04,05,06,07,08,09"
      LET l_combo_item = cl_getmsg('azz-170',g_lang),",",cl_getmsg('azz-171',g_lang),",",cl_getmsg('azz-172',g_lang),",",
                         cl_getmsg('azz-173',g_lang),",",cl_getmsg('azz-174',g_lang),",",cl_getmsg('azz-175',g_lang),",",
                         cl_getmsg('azz-177',g_lang),",",cl_getmsg('azz-178',g_lang),",",cl_getmsg('azz-179',g_lang)
      SELECT rtz03 INTO l_rtz03 FROM rtz_file WHERE rtz01 = g_plant
      IF l_rtz03 = '3' THEN
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value CLIPPED,",10"
            LET l_combo_item = l_combo_item CLIPPED,",",cl_getmsg('azz-180',g_lang) #百貨專櫃核算
         ELSE
            LET l_combo_value = "10"
            LET l_combo_item = cl_getmsg('azz-180',g_lang)
         END IF
      END IF
      CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
   ELSE
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,FALSE)
   END IF
   
   IF NOT cl_null(l_gdk03) THEN
      INITIALIZE l_combo_item,l_combo_value TO NULL
      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,TRUE)
      FOR l_i = 1 TO 12
         IF MONTH(TODAY) - l_i < 1 THEN
            LET l_year = YEAR(TODAY) - 1
            LET l_month = MONTH(TODAY) + 12 - l_i
            LET l_date = MDY(l_month,1,l_year)
            LET l_ym   = l_date USING "YYYYMM"
         ELSE
            LET l_month = MONTH(TODAY) - l_i
            LET l_year  = YEAR(TODAY)
            LET l_date  = MDY(l_month,1,l_year)
            LET l_ym    = l_date USING "YYYYMM"
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_ym
         ELSE
            LET l_combo_value = l_ym
         END IF
      END FOR
      LET l_combo_item = l_combo_value
      CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
   ELSE
      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,FALSE)
   END IF

   LET l_def_filter1 = '01'
   IF MONTH(TODAY) = 1 THEN
      LET l_year  = YEAR(TODAY) - 1
      LET l_def_filter2 = MDY(12,1,l_year) USING "YYYYMM"
   ELSE
      LET l_month = MONTH(TODAY) - 1
      LET l_year  = YEAR(TODAY)
      LET l_def_filter2 = MDY(l_month,1,l_year) USING "YYYYMM"
   END IF

   RETURN l_def_filter1,l_def_filter2

END FUNCTION

#FUN-BA0095
