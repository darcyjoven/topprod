# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_deposit_d.4gl
# Descriptions...: 銀行存款狀況
# Date & Author..: No.FUN-BA0095 2011/11/29 By baogc
# Input Parameter: p_value1 combo值1 幣別
#                  p_value2 combo值2 存款類別
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_deposit_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_deposit_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE nma_file.nma10
DEFINE p_value2    LIKE nma_file.nma09
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_sql       STRING
DEFINE l_lb        STRING 
DEFINE l_sub_str   STRING
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_azi02     LIKE azi_file.azi02
DEFINE l_nma01     LIKE nma_file.nma01
DEFINE l_nma02     LIKE nma_file.nma02
DEFINE l_nmp01     LIKE nmp_file.nmp01
DEFINE l_nmp06_sum LIKE nmp_file.nmp06
DEFINE l_nme04_1   LIKE nme_file.nme04
DEFINE l_nme04_2   LIKE nme_file.nme04
DEFINE l_money     LIKE nme_file.nme04
DEFINE l_first_day DATE
DEFINE l_nma10     LIKE nma_file.nma10
DEFINE l_nmb02     LIKE nmb_file.nmb02
DEFINE l_chk_auth  STRING
DEFINE l_year      LIKE type_file.num5
DEFINE l_month     LIKE type_file.num5

   
   WHENEVER ERROR CONTINUE
   
   CALL cl_chart_init(p_loc)

   IF cl_null(p_value1) OR cl_null(p_value2) THEN RETURN END IF

   #判斷權限
   IF NOT s_chart_auth("s_chart_deposit_d",g_user) THEN
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc,l_chk_auth)
      RETURN
   END IF

   IF MONTH(TODAY) = 1 THEN
      LET l_year  = YEAR(TODAY) - 1
      LET l_month = 12
   ELSE
      LET l_year  = YEAR(TODAY)
      LET l_month = MONTH(TODAY) - 1
   END IF

   LET l_sql = "SELECT nmp01,SUM(nmp06)",
               "  FROM nmp_file,nma_file",
               " WHERE nmp01 = nma01 ",
               "   AND nmp02 = '",l_year,"' ",
               "   AND nmp03 = '",l_month,"' "
   IF NOT cl_null(p_value1) THEN 
      LET l_sql = l_sql CLIPPED," AND nma10 = '",p_value1,"' " 
   END IF
   IF NOT cl_null(p_value2) THEN 
      LET l_sql = l_sql CLIPPED," AND nma09 = '",p_value2,"' " 
   END IF
   LET l_sql = l_sql CLIPPED," GROUP BY nmp01 "
   PREPARE sel_nmp_pre FROM l_sql
   DECLARE sel_nmp_cs CURSOR FOR sel_nmp_pre
   FOREACH sel_nmp_cs INTO l_nmp01,l_nmp06_sum #銀行編號,上月結存
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_first_day = MDY(month(today),1,year(today))
      #抓取本月收入金額
      LET l_sql = "SELECT SUM(nme04) ",
                  "  FROM nme_file,nmc_file,nma_file ",
                  " WHERE nme01 = nma01 ",
                  "   AND nme03 = nmc01 ",
                  "   AND nmc03 = '1' ",
                  "   AND nme02 BETWEEN '",l_first_day,"' AND '",g_today,"' ",
                  "   AND nme01 = '",l_nmp01,"' "
      PREPARE sel_nme04_pre1 FROM l_sql
      EXECUTE sel_nme04_pre1 INTO l_nme04_1 #收入
      IF cl_null(l_nme04_1) THEN LET l_nme04_1 = 0 END IF

      #抓取本月支出金額
      LET l_sql = "SELECT SUM(nme04) ",
                  "  FROM nme_file,nmc_file,nma_file ",
                  " WHERE nme01 = nma01 ",
                  "   AND nme03 = nmc01 ",
                  "   AND nmc03 = '2' ",
                  "   AND nme02 BETWEEN '",l_first_day,"' AND '",g_today,"' ",
                  "   AND nme01 = '",l_nmp01,"' "
      PREPARE sel_nme04_pre2 FROM l_sql
      EXECUTE sel_nme04_pre2 INTO l_nme04_2 #支出
      IF cl_null(l_nme04_2) THEN LET l_nme04_2 = 0 END IF

      #計算金額 = 上月結存 + 本月收入 - 本月支出
      LET l_money = l_nmp06_sum + l_nme04_1 - l_nme04_2
      #抓取銀行使用的幣別
      SELECT nma02,nma10 INTO l_nma02,l_nma10 FROM nma_file WHERE nma01 = l_nmp01
      LET l_lb = l_nmp01 CLIPPED,"(",l_nma02 CLIPPED,")"
      CALL cl_chart_array_data(p_loc,"categories","",l_lb)
      CALL cl_chart_array_data(p_loc,"dataset"," ",l_money)  
     #CALL cl_chart_array_attr(p_loc,l_lb,"displayValue",l_nma10)
   END FOREACH
   
   INITIALIZE l_sub_str TO NULL #初始化
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_deposit_d"
   IF NOT cl_null(p_value1) THEN 
      SELECT azi02 INTO l_azi02 FROM azi_file WHERE azi01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_azi02,")"
   END IF
   IF NOT cl_null(p_value2) THEN
      SELECT nmb02 INTO l_nmb02 FROM nmb_file WHERE nmb01 = p_value2
      IF NOT cl_null(l_sub_str) THEN 
         LET l_sub_str = l_sub_str," ",cl_getmsg(l_gdk03,g_lang),":",p_value2,"(",l_nmb02,")"
      ELSE
         LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk03,g_lang),":",p_value2,"(",l_nmb02,")"
      END IF
   END IF
   IF NOT cl_null(p_value1) OR NOT cl_null(p_value2) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_deposit_d")
   CALL cl_chart_clear(p_loc)                          

END FUNCTION

#FUNCTION s_chart_deposit_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_deposit_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_sql         STRING
DEFINE l_nma10       LIKE nma_file.nma10
DEFINE l_azi02       LIKE azi_file.azi02
DEFINE l_nma09       LIKE nma_file.nma09
DEFINE l_nmb02       LIKE nmb_file.nmb02
DEFINE l_year        LIKE type_file.num5
DEFINE l_month       LIKE type_file.num5
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   IF MONTH(TODAY) = 1 THEN
      LET l_year  = YEAR(TODAY) - 1
      LET l_month = 12
   ELSE
      LET l_year  = YEAR(TODAY)
      LET l_month = MONTH(TODAY) - 1
   END IF
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_deposit_d"
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
         LET l_sql = "SELECT DISTINCT nma10,azi02 ",
                     "  FROM nmp_file,nma_file,azi_file ",
                     " WHERE nmp01 = nma01 ",
                     "   AND nma10 = azi01 ",
                     "   AND nmp02 = '",l_year,"' ",
                     "   AND nmp03 = '",l_month,"' "
         PREPARE sel_combo_pre1 FROM l_sql
         DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
         FOREACH sel_combo_cs1 INTO l_nma10,l_azi02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF NOT cl_null(l_combo_value) THEN
               LET l_combo_value = l_combo_value,",",l_nma10 CLIPPED
               LET l_combo_item  = l_combo_item,",",l_nma10 CLIPPED,"(",l_azi02 CLIPPED,")"
            ELSE
               LET l_combo_value = l_nma10 CLIPPED
               LET l_combo_item = l_nma10 CLIPPED,"(",l_azi02 CLIPPED,")"
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
      LET l_sql = "SELECT DISTINCT nma09,nmb02 ",
                  "  FROM nmp_file,nma_file,nmb_file ",
                  " WHERE nmp01 = nma01 ",
                  "   AND nma09 = nmb01 ",
                  "   AND nmp02 = '",l_year,"' ",
                  "   AND nmp03 = '",l_month,"' "
     #TQC-C20485 Add Begin ---
      IF NOT cl_null(p_def_filter1) THEN
         LET l_sql = l_sql CLIPPED," AND nma10 = '",p_def_filter1 CLIPPED,"' "
      END IF
      LET l_sql = l_sql CLIPPED," ORDER BY nma09 "
     #TQC-C20485 Add End -----
      PREPARE sel_combo_pre2 FROM l_sql
      DECLARE sel_combo_cs2 CURSOR FOR sel_combo_pre2
      FOREACH sel_combo_cs2 INTO l_nma09,l_nmb02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_nma09 CLIPPED
            LET l_combo_item = l_combo_item,",",l_nma09 CLIPPED,"(",l_nmb02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_nma09 CLIPPED
            LET l_combo_item = l_nma09 CLIPPED,"(",l_nmb02 CLIPPED,")"
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
