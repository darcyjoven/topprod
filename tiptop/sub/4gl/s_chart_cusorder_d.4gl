# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_cusorder_d.4gl
# Descriptions...: 查詢單一客戶的所有未完全出貨的訂單vs已出貨量
# Date & Author..: No.FUN-BA0095 2011/10/30 By linlin
# Input Parameter: p_value1 combo值1  客戶編號
#                  p_value2 combo值2
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_cusorder_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_cusorder_d(p_value1,p_value2,p_loc)
DEFINE p_value1   LIKE gbq_file.gbq05
DEFINE p_value2   LIKE type_file.num5
DEFINE p_loc      LIKE type_file.chr10
DEFINE l_oeb04    LIKE oeb_file.oeb04
DEFINE l_oeb05    LIKE oeb_file.oeb05
DEFINE s1         LIKE oeb_file.oeb12
DEFINE s2         LIKE oeb_file.oeb24
DEFINE l_sub_str  STRING
DEFINE l_sql      STRING
DEFINE l_ima02    LIKE ima_file.ima02
DEFINE l_gdk02    LIKE gdk_file.gdk02
DEFINE l_gdk03    LIKE gdk_file.gdk03
DEFINE l_occ02    LIKE occ_file.occ02
DEFINE l_chk_auth STRING
DEFINE l_item     STRING
DEFINE l_str1     STRING
DEFINE l_str2     STRING

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_sal_custclass_d",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                       #判斷權限
   IF cl_null(p_value1) THEN RETURN END IF 
   LET l_sql = "SELECT oeb04,oeb05,SUM(oeb12),SUM(oeb24) ",
               "  FROM oea_file,oeb_file ",	
               " WHERE oea01=oeb01    ",
               "   AND oea03='",p_value1,"' ",
               "   AND oeb12 > oeb24  ",	
               "   AND oeb70='N'      ",	
               "   AND oeaconf='Y'    ",
               " GROUP BY oeb04,oeb05 ",
               " ORDER BY oeb04,oeb05 "
               
   PREPARE s_oeb_pre FROM l_sql
   DECLARE s_oeb_cs CURSOR FOR s_oeb_pre
   FOREACH s_oeb_cs INTO l_oeb04,l_oeb05,s1,s2
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #客戶訂單出貨狀況
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_oeb04
      LET l_item = l_oeb04 CLIPPED,"(", l_ima02 CLIPPED, ")" 
      LET l_str1 = cl_getmsg('atm-506',g_lang) CLIPPED                 #訂單數量 
      LET l_str2 = cl_getmsg('azz1144',g_lang) CLIPPED                 #已出貨量 
      CALL cl_chart_array_data(  p_loc ,"categories","",l_item)				
      CALL cl_chart_array_data(  p_loc ,"dataset",l_str1,s1)				
      CALL cl_chart_array_data(  p_loc ,"dataset",l_str2,s2) 				
      CALL cl_chart_array_attr(  p_loc ,"l_str1","displayValue", l_oeb05) 	#訂單數量			

   END FOREACH
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_cusorder_d"
   IF NOT cl_null(p_value1) THEN
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_occ02 CLIPPED,")"
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_cusorder_d")
   CALL cl_chart_clear(p_loc)       #清除wc1相關變數資料(釋放記憶體) 

END FUNCTION

# Descriptions...: 設定圖表的Combo選項
# Date & Author..: No.FUN-BA0095 2011/10/26 By baogc
# Input Parameter: p_cboloc  Combo位置

#FUNCTION s_chart_cusorder_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_cusorder_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc       LIKE type_file.chr10
DEFINE l_def_filter1  STRING
DEFINE l_def_filter2  STRING
DEFINE l_gdk02        LIKE gdk_file.gdk02
DEFINE l_gdk03        LIKE gdk_file.gdk03
DEFINE l_combo        LIKE type_file.chr12
DEFINE l_occ02        LIKE occ_file.occ02
DEFINE l_oea03        LIKE oea_file.oea03
DEFINE l_combo_value  STRING
DEFINE l_combo_item   STRING
DEFINE l_sql          STRING
DEFINE p_def_filter1  STRING #TQC-C20485 Add
DEFINE p_def_filter2  STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_cusorder_d"
   IF NOT cl_null(l_gdk02) THEN
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT oea03,occ02 ",
                  "  FROM oea_file,oeb_file,occ_file ",	
                  " WHERE oea01=oeb01	 ",
                  "   AND oea03=occ01    ",
                  "   AND oeb12 > oeb24  ",	
                  "   AND oeb70='N'      ",	
                  "   AND oeaconf='Y'	 ",
                  " ORDER BY oea03      "
               
      PREPARE s_oea_pre FROM l_sql
      DECLARE s_oea_cs CURSOR FOR s_oea_pre
      FOREACH s_oea_cs INTO l_oea03,l_occ02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_oea03 CLIPPED
            LET l_combo_item = l_combo_item, ",",l_oea03 CLIPPED,"(",l_occ02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_oea03 CLIPPED
            LET l_combo_item = l_oea03 CLIPPED,"(",l_occ02 CLIPPED,")"
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
