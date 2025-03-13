# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_chart_vendap_d.4gl
# Descriptions...: 查詢單一廠商應付帳款狀況
# Date & Author..: No.FUN-BA0095 2011/11/30 By linlin
# Input Parameter: p_value1 combo值1  廠商編號
#                  p_value2 combo值2
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_vendap_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_vendap_d(p_value1,p_value2,p_loc)
DEFINE p_value1   LIKE gbq_file.gbq05
DEFINE p_value2   LIKE type_file.num5
DEFINE p_loc      LIKE type_file.chr10
DEFINE l_apa02    LIKE type_file.chr6
DEFINE s1         LIKE apa_file.apa34
DEFINE s2         LIKE apa_file.apa35
DEFINE l_sub_str  STRING
DEFINE l_sql      STRING
DEFINE l_gdk02    LIKE gdk_file.gdk02
DEFINE l_gdk03    LIKE gdk_file.gdk03
DEFINE l_pmc03    LIKE pmc_file.pmc03 
DEFINE l_chk_auth STRING
DEFINE l_str1     STRING
DEFINE l_str2     STRING
DEFINE l_str3     STRING

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_sal_custclass_d",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                       #判斷權限
   IF cl_null(p_value1) THEN RETURN END IF
   LET l_sql = "SELECT ",cl_tp_tochar("apa02",'YYYYMM'),",SUM(apa34),SUM(apa35) ",
               "  FROM apa_file ",
               " WHERE apa06= '",p_value1,"' ",
               "   AND apa34>apa35 ",
               "   AND apa41='Y' ",	
               "   AND apa42='N' ",	
               " GROUP BY ",cl_tp_tochar("apa02",'YYYYMM'),
               " ORDER BY ",cl_tp_tochar("apa02",'YYYYMM')
   PREPARE s_apa_pre FROM l_sql
   DECLARE s_apa_cs CURSOR FOR s_apa_pre
   FOREACH s_apa_cs INTO l_apa02,s1,s2
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #廠商應付帳款狀況
      LET l_str1 = l_apa02 CLIPPED                                     #年月
      LET l_str2 = cl_getmsg('azz1123',g_lang) CLIPPED                 #應付金額
      LET l_str3 = cl_getmsg('azz1124',g_lang) CLIPPED                 #已付金額 
      CALL cl_chart_array_data(  p_loc ,"categories","",l_str1)				
      CALL cl_chart_array_data(  p_loc ,"dataset",l_str2,s1)				
      CALL cl_chart_array_data(  p_loc ,"dataset",l_str3,s2) 				

   END FOREACH
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_vendap_d"
   IF NOT cl_null(p_value1) THEN
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_pmc03 CLIPPED,")"
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_vendap_d")
   CALL cl_chart_clear(p_loc)       #清除wc1相關變數資料(釋放記憶體) 

END FUNCTION

# Descriptions...: 設定圖表的Combo選項
# Date & Author..: No.FUN-BA0095 2011/10/26 By baogc
# Input Parameter: p_cboloc  Combo位置
         
#FUNCTION s_chart_vendap_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_vendap_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc       LIKE type_file.chr10
DEFINE l_def_filter1  STRING
DEFINE l_def_filter2  STRING
DEFINE l_gdk02        LIKE gdk_file.gdk02
DEFINE l_gdk03        LIKE gdk_file.gdk03
DEFINE l_combo        LIKE type_file.chr12
DEFINE l_pmc03        LIKE pmc_file.pmc03
DEFINE l_apa06        LIKE apa_file.apa06
DEFINE l_combo_value  STRING
DEFINE l_combo_item   STRING
DEFINE l_sql          STRING
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_vendap_d"
   IF NOT cl_null(l_gdk02) THEN
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT apa06,pmc03 ",
               "    FROM apa_file,pmc_file ",	
               "   WHERE apa06=pmc01 ",
               "     AND apa34>apa35 ",
               "     AND apa41='Y' ",	
               "     AND apa42='N' ",	
               "   ORDER BY apa06 "
      PREPARE s_pmc_pre FROM l_sql
      DECLARE s_pmc_cs CURSOR FOR s_pmc_pre
      FOREACH s_pmc_cs INTO l_apa06,l_pmc03
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_apa06 CLIPPED
            LET l_combo_item  = l_combo_item,",",l_apa06 CLIPPED,"(",l_pmc03 CLIPPED,")"
         ELSE
            LET l_combo_value = l_apa06 CLIPPED
            LET l_combo_item  = l_apa06 CLIPPED,"(",l_pmc03 CLIPPED,")"
         END IF
      END FOREACH
      CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
   ELSE
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,FALSE)
   END IF

   LET l_combo = p_cboloc CLIPPED,"_2"
   CALL cl_set_comp_visible(l_combo,FALSE)

   IF l_combo_value.getIndexof(",",1)=0 THEN
         LET l_def_filter1 = l_combo_value
      ELSE
         LET l_def_filter1 = l_combo_value.subString(1,l_combo_value.getIndexof(",",1)-1)
    END IF

   RETURN l_def_filter1,l_def_filter2

END FUNCTION

#FUN-BA0095
