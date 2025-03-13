# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_stockABC_d.4gl
# Descriptions...: 查詢單一料件庫存ABC狀況
# Date & Author..: No.FUN-BA0095 2011/11/28 By qiaozy
# Input Parameter: p_value1 combo值1 
#                  p_value2 combo值2 
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_stockABC_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_stockABC_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE type_file.chr10
DEFINE p_value2    LIKE type_file.chr10
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_sql       STRING
DEFINE l_sql1      STRING
DEFINE l_ima07     LIKE ima_file.ima07
DEFINE l_ima01     LIKE ima_file.ima01
DEFINE l_ccc23     LIKE ccc_file.ccc23
DEFINE l_lb        STRING
DEFINE l_sub_str   STRING
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_img01     LIKE img_file.img01 #料件編號
DEFINE l_img09     LIKE img_file.img09 #庫存單位
DEFINE l_img10     LIKE img_file.img10 #庫存數量
DEFINE l_sel_ima   LIKE ccc_file.ccc23
DEFINE l_sel_sum   LIKE ccc_file.ccc23
DEFINE l_chk_auth  STRING

   CALL cl_chart_init(p_loc)

   
   IF NOT s_chart_auth("s_chart_stockABC_d",g_user) THEN 
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN
   END IF
   
   LET l_sql = "SELECT UNIQUE ima07 ",
               "  FROM ima_file ",
               " WHERE ima07 IS NOT NULL"
   PREPARE sel_ima_pre FROM l_sql
   DECLARE sel_ima_cs CURSOR FOR sel_ima_pre
   
   #ABC分類
   INITIALIZE l_ima07 TO NULL
   FOREACH sel_ima_cs INTO l_ima07
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #抓取ABC分類對應的料號
      LET l_ima01=0
      LET l_img10=0
      LET l_sel_ima=0
      LET l_sel_sum=0
      LET l_sql1 = "SELECT DISTINCT ima01 ",
                   "  FROM ima_file ",
                   " WHERE ima07= '",l_ima07,"' "
      PREPARE sel_ima_pre1 FROM l_sql1
      DECLARE sel_ima_cs1 CURSOR FOR sel_ima_pre1

      FOREACH sel_ima_cs1 INTO l_ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         #抓取月加權成本
         SELECT ccc23 INTO l_ccc23
           FROM ccc_file
          WHERE ccc01 = l_ima01
            AND ccc02 = YEAR(TODAY)
            AND ccc03 = MONTH(TODAY)
            AND ccc07 = '1'
         IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF

         #抓取數量
         SELECT img01,SUM(img10*img21) INTO l_img01,l_img10
           FROM img_file
          WHERE img10 > 0
            AND img01 = l_ima01
          GROUP BY img01
         IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
         LET l_sel_ima = l_ccc23*l_img10
         IF cl_null(l_sel_ima) THEN LET l_sel_ima=0 END IF
         LET l_sel_sum = l_sel_sum + l_sel_ima
         IF cl_null(l_sel_sum) THEN LET l_sel_sum=0 END IF
      END FOREACH
      CALL cl_chart_array_data(p_loc,"dataset",l_ima07,l_sel_sum)
      INITIALIZE l_ima07,l_ima01 TO NULL
      LET l_sel_sum=0
   END FOREACH
   CALL cl_chart_create(p_loc,"s_chart_stockABC_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_stockABC_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_stockABC_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   LET l_combo = p_cboloc CLIPPED,"_1"
   CALL cl_set_comp_visible(l_combo,FALSE)
   LET l_combo = p_cboloc CLIPPED,"_2"
   CALL cl_set_comp_visible(l_combo,FALSE)

   RETURN l_def_filter1,l_def_filter2
END FUNCTION

#FUN-BA0095
