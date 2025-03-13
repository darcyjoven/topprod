# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_empachi_d.4gl
# Descriptions...: 查詢營運中心該年度的員工業績
# Date & Author..: No.FUN-BA0095 2011/11/29 By linlin
# Input Parameter: p_value1 combo值1 年度
#                  p_value2 combo值2 月份
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_empachi_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20118 12/02/06 By linlin 修改抓取的最外層員工資料
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_empachi_d(p_value1,p_value2,p_loc)
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
DEFINE s3          LIKE ogb_file.ogb14t
DEFINE s4          LIKE ogb_file.ogb14t
DEFINE s5          LIKE ogb_file.ogb14t
DEFINE l_str1      STRING 
DEFINE l_gen02     LIKE gen_file.gen02
DEFINE l_occ03     LIKE occ_file.occ03
DEFINE l_ogb14t    LIKE ogb_file.ogb14t
DEFINE l_ohb14t    LIKE ohb_file.ohb14t
DEFINE l_gen01     LIKE gen_file.gen01

   WHENEVER ERROR CONTINUE #容錯機制

   CALL cl_chart_init(p_loc) #初始化

   #權限Check
   IF NOT s_chart_auth("s_chart_empachi_d",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF    

   #若傳入參數為空，則退出圖表邏輯 
   IF cl_null(p_value1) OR cl_null(p_value2) THEN RETURN END IF

   #建立所需的臨時表
   DROP TABLE s_temp2
   CREATE TEMP TABLE s_temp2(
   s3     LIKE ogb_file.ogb14t)  

   #抓取當前Plant下的員工編號
  #TQC-C20118 Mark&Add Begin ---
  #LET l_sql = "SELECT gen01 FROM gen_file ",
  #            " WHERE gen07 = '",g_plant,"'",
  #            "   AND genacti = 'Y' "

   LET l_sql = "SELECT UNIQUE oga14 FROM oga_file,gen_file ",
               " WHERE oga14 = gen01 "
   IF NOT cl_null(p_value1) AND p_value1 <> '*' THEN
      LET l_sql = l_sql CLIPPED,
               "   AND YEAR(oga02) = '",p_value1,"' "
   END IF
   IF NOT cl_null(p_value2) AND p_value2 <> '*' THEN
      LET l_sql = l_sql CLIPPED,
               "   AND MONTH(oga02) = '",p_value2,"' "
   END IF
   LET l_sql = l_sql CLIPPED,
               " UNION ALL ",
               "SELECT UNIQUE oha14 FROM oha_file,gen_file ",
               " WHERE oha14 = gen01 "
   IF NOT cl_null(p_value1) AND p_value1 <> '*' THEN
      LET l_sql = l_sql CLIPPED,
               "   AND YEAR(oha02) = '",p_value1,"' "
   END IF
   IF NOT cl_null(p_value2) AND p_value2 <> '*' THEN
      LET l_sql = l_sql CLIPPED,
               "   AND MONTH(oha02) = '",p_value2,"' "
   END IF
  #TQC-C20118 Mark&Add End -----
   PREPARE s_gen_pre FROM l_sql
   DECLARE s_gen_cs CURSOR FOR s_gen_pre
   FOREACH s_gen_cs INTO l_gen01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #各人員銷售金額
      LET l_sql = " SELECT SUM(ogb14t) ",
                  "   FROM ogb_file,oga_file ",						
                  "  WHERE ogb01=oga01 ",
                  "    AND oga14 =  '",l_gen01,"'" ,     
                  "    AND oga09 IN ('2','3','4','6') ",							
                  "    AND ogapost = 'Y' "
      IF NOT cl_null(p_value1) AND p_value1<>'*' THEN
         LET l_sql = l_sql CLIPPED," AND YEAR(oga02) = '",p_value1,"' "
      END IF
      IF NOT cl_null(p_value2) AND p_value2<>'*' THEN
         LET l_sql = l_sql CLIPPED," AND MONTH(oga02)= '",p_value2,"' "
      END IF                            
      #
      LET l_sql = l_sql CLIPPED, " UNION ALL " ,
                  " SELECT SUM(ohb14t)*(-1) ",
                  "   FROM ohb_file,oha_file ",						
                  "  WHERE ohb01=oha01 ",		
                  "    AND oha14 = '",l_gen01,"'" ,    
                  "    AND oha05 IN ('1','2') ",							
                  "    AND ohapost = 'Y' "
      IF NOT cl_null(p_value1) AND p_value1<>'*' THEN
         LET l_sql = l_sql CLIPPED," AND YEAR(oha02) = '",p_value1,"' "
      END IF
      IF NOT cl_null(p_value2) AND p_value2<>'*' THEN
         LET l_sql = l_sql CLIPPED," AND MONTH(oha02)= '",p_value2,"' "
      END IF                            
      PREPARE sel_ohb_pre FROM l_sql
      DECLARE sel_ohb_cs CURSOR FOR sel_ohb_pre
      FOREACH sel_ohb_cs INTO s3
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(s3) THEN LET s3 = 0 END IF
         INSERT INTO s_temp2 VALUES(s3)
      END FOREACH

      LET l_sql = "SELECT SUM(s3) FROM s_temp2 "
      PREPARE s_s2_pre FROM l_sql         
      DECLARE s_s2_cs CURSOR FOR s_s2_pre 
      FOREACH s_s2_cs INTO s4             
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
               
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 =l_gen01
         LET l_str1 = l_gen01 CLIPPED,"(",l_gen02  CLIPPED,")"  #員工編號(姓名)
         CALL cl_chart_array_data( p_loc,"dataset",l_str1,s4)   #員工,金額 
      END FOREACH
      DELETE FROM s_temp2
    END FOREACH
   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_empachi_d"
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
   CALL cl_chart_create(p_loc,"s_chart_empachi_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_empachi_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_empachi_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
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
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_empachi_d"
   IF NOT cl_null(l_gdk02) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_combo_value = "*"   #空白
      LET l_combo_item = "ALL"  #全部
      FOR l_i = 1 TO 5
         LET l_combo_value = l_combo_value, ",",YEAR(TODAY)-l_i+1 CLIPPED
         LET l_combo_item  = l_combo_item, ",",YEAR(TODAY)-l_i+1," ",cl_getmsg('anm-156',g_lang) CLIPPED
      END FOR
      CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
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
         LET l_combo_value = l_combo_value, ",",l_i CLIPPED
         LET l_combo_item  = l_combo_item,",",l_i," ",cl_getmsg('anm-157',g_lang) CLIPPED
      END FOR
      CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
   ELSE
      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,FALSE)
   END IF
   LET l_def_filter1 =  "*"
   LET l_def_filter2 =  "*"

   RETURN l_def_filter1,l_def_filter2
END FUNCTION

#FUN-BA0095
