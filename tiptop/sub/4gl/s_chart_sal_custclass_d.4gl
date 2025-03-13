# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_sal_custclass_d.4gl
# Descriptions...: 查詢各客戶分類的銷售比率
# Date & Author..: No.FUN-BA0095 2011/11/29 By linlin
# Input Parameter: p_value1 combo值1 年度
#                  p_value2 combo值2 月份
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_sal_custclass_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_sal_custclass_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE type_file.chr20
DEFINE p_value2    LIKE type_file.chr6
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_sql       STRING
DEFINE l_img       RECORD
             img02 LIKE img_file.img02,
             img03 LIKE img_file.img03,
             img09 LIKE img_file.img09,
             img10 LIKE img_file.img10
                   END RECORD
DEFINE l_lb        STRING
DEFINE l_sub_str   STRING
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_chk_auth  STRING
DEFINE s1          LIKE ogb_file.ogb14t
DEFINE s2          LIKE ogb_file.ogb14t
DEFINE l_str1      STRING 
DEFINE l_oca02     LIKE oca_file.oca02
DEFINE l_occ03     LIKE occ_file.occ03
DEFINE l_ogb14t    LIKE ogb_file.ogb14t
DEFINE l_ohb14t    LIKE ohb_file.ohb14t

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc)
   IF NOT s_chart_auth("s_chart_sal_custclass_d",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                       #判斷權限
   IF cl_null(p_value1) OR cl_null(p_value2) THEN RETURN END IF
   #定義臨時表 
   DROP TABLE s_temp1
   CREATE TEMP TABLE s_temp1(
   occ03  LIKE occ_file.occ03,
   s1     LIKE ogb_file.ogb14t)
   #客戶分類及金額
   LET l_sql = " SELECT occ03,SUM(ogb14t) ",
               "   FROM ogb_file,oga_file,occ_file ",						
               "  WHERE ogb01=oga01 ",
               "    AND oga03 = occ01 ",							
               "    AND oga09 IN ('2','3','4','6')",							
               "    AND ogapost = 'Y' "
   IF NOT cl_null(p_value1) AND p_value1<>'*' THEN
      LET l_sql = l_sql CLIPPED," AND YEAR(oga02) = '",p_value1,"' "
   END IF
   IF NOT cl_null(p_value2) AND p_value2<>'*' THEN
      LET l_sql = l_sql CLIPPED," AND MONTH(oga02)= '",p_value2,"' "
   END IF                            
   LET l_sql = l_sql CLIPPED," GROUP BY occ03 "      
   #
   LET l_sql = l_sql CLIPPED, " UNION ALL " ,
               " SELECT occ03,SUM(ohb14t)*(-1)",
               "   FROM ohb_file,oha_file,occ_file ",						
               "  WHERE ohb01=oha01 ",
               "    AND oha03 = occ01 ",							
               "    AND oha05 IN ('1','2')  ",							
               "    AND ohapost = 'Y' "
   IF NOT cl_null(p_value1) AND p_value1<>'*' THEN
      LET l_sql = l_sql CLIPPED," AND YEAR(oha02) = '",p_value1,"' "
   END IF
   IF NOT cl_null(p_value2) AND p_value2<>'*' THEN
      LET l_sql = l_sql CLIPPED," AND MONTH(oha02)= '",p_value2,"' "
   END IF                            
   LET l_sql = l_sql CLIPPED," GROUP BY occ03 " 
   PREPARE sel_ogb_pre FROM l_sql
   DECLARE sel_ogb_cs CURSOR FOR sel_ogb_pre
   FOREACH sel_ogb_cs INTO l_occ03,s1 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(s1) THEN LET s1 = 0 END IF
      INSERT INTO s_temp1 VALUES(l_occ03,s1)
   END FOREACH
   #
   LET l_sql = "SELECT occ03,SUM(s1) FROM s_temp1 ",
               " GROUP BY occ03 " ,
               "HAVING SUM(s1) > 0 "
   PREPARE s_ima_pre FROM l_sql
   DECLARE s_ima_cs CURSOR FOR s_ima_pre
   FOREACH s_ima_cs  INTO l_occ03,s2
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT oca02 INTO l_oca02 FROM oca_file WHERE oca01 =l_occ03
      LET l_str1 = l_occ03 CLIPPED,"(",l_oca02 CLIPPED,")"  #客戶分類(說明)
      CALL cl_chart_array_data( p_loc,"dataset",l_str1,s2)  #客戶分類, 金額 
   END FOREACH
   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_sal_custclass_d"
   IF NOT cl_null(p_value1) THEN     #年度
      IF p_value1 = '*' THEN 
         LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":ALL"
      ELSE
         LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1
      END IF
   END IF
   IF NOT cl_null(p_value2) THEN
      IF NOT cl_null(l_sub_str) THEN #月份
         IF p_value2 = '*' THEN
            LET l_sub_str = l_sub_str,"(",cl_getmsg(l_gdk03,g_lang),":ALL)"
         ELSE
            LET l_sub_str = l_sub_str,"(",cl_getmsg(l_gdk03,g_lang),":",p_value2,")"
         END IF
      ELSE
         IF p_value2 = '*' THEN
            LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk03,g_lang),":ALL)"
         ELSE
            LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk03,g_lang),":",p_value2
         END IF
      END IF
   END IF
   IF NOT cl_null(p_value1) OR NOT cl_null(p_value2) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_sal_custclass_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)
 
END FUNCTION

#FUNCTION s_chart_sal_custclass_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_sal_custclass_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_sql         STRING
DEFINE l_img01       LIKE img_file.img01
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_img09       LIKE img_file.img09
DEFINE l_gfe02       LIKE gfe_file.gfe02
DEFINE l_i           LIKE type_file.num5
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_sal_custclass_d"
   IF NOT cl_null(l_gdk02) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_combo_value = "*"  #空白
      LET l_combo_item = "ALL"  #全部
      FOR l_i = 1 TO 5
         LET l_combo_value = l_combo_value,",",YEAR(TODAY)-l_i+1 CLIPPED
         LET l_combo_item = l_combo_item, ",", YEAR(TODAY)-l_i+1 ," ",cl_getmsg('anm-156',g_lang)  CLIPPED
      END FOR
      CALL cl_set_combo_items( l_combo,l_combo_value,l_combo_item)
   ELSE
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,FALSE)
   END IF 


   IF NOT cl_null(l_gdk03) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_combo_value = "*"  #空白												
      LET l_combo_item = "ALL"  #全部												
      FOR l_i = 1 TO 12												
         LET l_combo_value = l_combo_value, "," , l_i CLIPPED												
         LET l_combo_item = l_combo_item, ",", l_i ," ",cl_getmsg('anm-157',g_lang)  CLIPPED											#ex:  10 月	
      END FOR												
      CALL cl_set_combo_items( l_combo,l_combo_value,l_combo_item)												
   ELSE												
      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,FALSE)											
   END IF 												
   LET  l_def_filter1 =  "*"		
   LET  l_def_filter2 =  "*"		

   RETURN l_def_filter1,l_def_filter2
END FUNCTION

#FUN-BA0095
