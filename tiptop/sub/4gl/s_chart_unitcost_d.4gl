# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_unitcost_d.4gl
# Descriptions...: 查詢單一料件各期別的單位成本波動
# Date & Author..: No.FUN-BA0095 2011/11/30 By linlin
# Input Parameter: p_value1 combo值1 料件編號
#                  p_value2 combo值2 成本年度
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_unitcost_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_unitcost_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE img_file.img01
DEFINE p_value2    LIKE type_file.chr4
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
DEFINE l_ccc02     LIKE type_file.chr20
DEFINE l_ccc03     LIKE ccc_file.ccc03
DEFINE l_imb111    LIKE imb_file.imb111
DEFINE l_imb112    LIKE imb_file.imb112
DEFINE l_imb1131   LIKE imb_file.imb1131
DEFINE l_imb1132   LIKE imb_file.imb1132
DEFINE l_imb114    LIKE imb_file.imb114
DEFINE l_imb115    LIKE imb_file.imb115
DEFINE l_imb116    LIKE imb_file.imb116
DEFINE l_imb1171   LIKE imb_file.imb1171
DEFINE l_imb1172   LIKE imb_file.imb1172 
DEFINE l_imb119    LIKE imb_file.imb119
DEFINE l_imb121    LIKE imb_file.imb121
DEFINE l_imb122    LIKE imb_file.imb122
DEFINE l_imb1231   LIKE imb_file.imb1231
DEFINE l_imb1232   LIKE imb_file.imb1232
DEFINE l_imb124    LIKE imb_file.imb124
DEFINE l_imb125    LIKE imb_file.imb125 
DEFINE l_imb126    LIKE imb_file.imb126 
DEFINE l_imb1271   LIKE imb_file.imb1271
DEFINE l_imb1272   LIKE imb_file.imb1272 
DEFINE l_imb129    LIKE imb_file.imb129
DEFINE l_imb118    LIKE imb_file.imb118
DEFINE l_ima08     LIKE ima_file.ima08
DEFINE l_imb_sum   LIKE imb_file.imb111
DEFINE l_sum       LIKE imb_file.imb111
DEFINE l_max       LIKE ccc_file.ccc23
DEFINE l_min       LIKE ccc_file.ccc23
DEFINE l_avg       LIKE ccc_file.ccc23
DEFINE l_ccc23     LIKE ccc_file.ccc23
DEFINE l_ccz01     LIKE ccz_file.ccz01 
DEFINE l_ccz02     LIKE ccz_file.ccz01 
DEFINE l_month     LIKE type_file.num5
DEFINE l_year      LIKE type_file.chr4
DEFINE l_ym        LIKE type_file.chr6
DEFINE l_chk_auth  STRING
DEFINE l_str1      STRING
DEFINE l_str2      STRING
DEFINE l_str3      STRING
DEFINE l_str4      STRING
DEFINE l_str5      STRING
DEFINE l_count     LIKE type_file.num5

   WHENEVER ERROR CONTINUE

   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_unitcost_d",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                       #判斷權限
   IF cl_null(p_value1) OR cl_null(p_value2) THEN RETURN END IF
   #抓取年度期別
   LET l_max = NULL
   LET l_min = NULL
   LET l_sum = 0
   LET l_avg = 0
   LET l_count = 0
   SELECT ccz01,ccz02 INTO l_ccz01,l_ccz02 FROM ccz_file
   IF p_value2 < l_ccz01 THEN
      FOR l_month = 1 TO 12
         LET l_ym = MDY(l_month,1,p_value2) USING 'YYYYMM'
         LET l_sql = "SELECT ccc23 FROM ccc_file ",
                     " WHERE ccc02 = '",p_value2,"' ",
                     "   AND ccc03 = '",l_month,"' ",
                     "   AND ccc07 = '1' "
         IF NOT cl_null(p_value1) THEN 
            LET l_sql = l_sql CLIPPED," AND ccc01 = '",p_value1,"' "
         END IF
         PREPARE s_ccc_pre FROM l_sql
         EXECUTE s_ccc_pre INTO l_ccc23
         IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF
         IF cl_null(l_max) THEN
            LET l_max = l_ccc23
         ELSE   
            IF l_max > l_ccc23 THEN
               LET l_max = l_max
            ELSE
               LET l_max = l_ccc23
            END IF
         END IF
         IF cl_null(l_min) THEN
            LET l_min = l_ccc23
         ELSE
            IF l_min < l_ccc23 THEN
               LET l_min = l_min
            ELSE
               LET l_min = l_ccc23
            END IF
         END IF                              
         LET l_sum = l_sum + l_ccc23
         LET l_count = l_count + 1
         LET l_str1 = cl_getmsg('azz1153',g_lang) CLIPPED          #單位成本
         CALL cl_chart_array_data( p_loc ,"categories","",l_ym )
         CALL cl_chart_array_data( p_loc ,"dataset",l_str1, l_ccc23)
         INITIALIZE l_ccc23 TO NULL
      END FOR
   ELSE
      FOR l_month = l_ccz02 + 1 TO 12
         LET l_ym = MDY(l_month,1,p_value2-1) USING 'YYYYMM'
         LET l_sql = "SELECT ccc23 FROM ccc_file ",
                     " WHERE ccc02 = '",p_value2,"' ", 
                     "   AND ccc03 = '",l_month,"' ",
                     "   AND ccc07 = '1'  "
         IF NOT cl_null(p_value1) THEN 
            LET l_sql = l_sql CLIPPED," AND ccc01 = '",p_value1,"' "
         END IF
         PREPARE s3_ccc_pre FROM l_sql
         EXECUTE s3_ccc_pre INTO l_ccc23
         IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF
         IF cl_null(l_max) THEN
            LET l_max = l_ccc23
         ELSE
            IF l_max > l_ccc23 THEN
               LET l_max = l_max
            ELSE
               LET l_max = l_ccc23
            END IF
         END IF
          IF cl_null(l_min) THEN
            LET l_min = l_ccc23
         ELSE
            IF l_min < l_ccc23 THEN
               LET l_min = l_min
            ELSE
               LET l_min = l_ccc23
            END IF
         END IF
         LET l_sum = l_sum + l_ccc23
         LET l_count = l_count + 1
         LET l_str1 = cl_getmsg('azz1153',g_lang) CLIPPED          #單位成本
         CALL cl_chart_array_data( p_loc ,"categories","",l_ym)
         CALL cl_chart_array_data( p_loc ,"dataset",l_str1, l_ccc23)
         INITIALIZE l_ccc23 TO NULL
      END FOR
      FOR l_month = 1 TO l_ccz02
         LET l_ym = MDY(l_month,2,p_value2) USING 'YYYYMM'
         LET l_sql = "SELECT ccc23 FROM ccc_file ",
                     " WHERE ccc02 = '",p_value2,"' ",
                     "   AND ccc03 = '",l_month,"' ",
                     "   AND ccc07 = '1'  "
         IF NOT cl_null(p_value1) THEN 
            LET l_sql = l_sql CLIPPED," AND ccc01 = '",p_value1,"' "
         END IF
         PREPARE s2_ccc_pre FROM l_sql
         EXECUTE s2_ccc_pre INTO l_ccc23
         IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF
         IF cl_null(l_max) THEN
            LET l_max = l_ccc23
         ELSE
            IF l_max > l_ccc23 THEN
               LET l_max = l_max
            ELSE
               LET l_max = l_ccc23
            END IF
         END IF
          IF cl_null(l_min) THEN
            LET l_min = l_ccc23
         ELSE
            IF l_min < l_ccc23 THEN
               LET l_min = l_min
            ELSE
               LET l_min = l_ccc23
            END IF
         END IF
         LET l_sum = l_sum + l_ccc23
         LET l_count = l_count + 1
         LET l_str1 = cl_getmsg('azz1153',g_lang) CLIPPED          #單位成本
         CALL cl_chart_array_data( p_loc ,"categories","",l_ym )
         CALL cl_chart_array_data( p_loc ,"dataset",l_str1, l_ccc23)
         INITIALIZE l_ccc23 TO NULL
      END FOR
   END IF
   LET l_avg = l_sum / l_count

   #單位成本   
   SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01 = p_value1 
   IF l_ima08 NOT MATCHES '[PUZ]'  THEN   #成本計算方式分為採購料件及非採購料件				
      SELECT imb111,imb112,imb1131,imb1132,imb114,imb115,imb116,imb1171,imb1172,imb119,
             imb121,imb122,imb1231,imb1232,imb124,imb125,imb126,imb1271,imb1272,imb129
        INTO l_imb111,l_imb112,l_imb1131,l_imb1132,l_imb114,l_imb115,l_imb116,l_imb1171,l_imb1172,l_imb119,
             l_imb121,l_imb122,l_imb1231,l_imb1232,l_imb124,l_imb125,l_imb126,l_imb1271,l_imb1272,l_imb129
        FROM imb_file
       WHERE imb01 = p_value1
      IF  cl_null(l_imb111)  THEN LET l_imb111 = 0  END IF
      IF  cl_null(l_imb112)  THEN LET l_imb112 = 0  END IF
      IF  cl_null(l_imb1131) THEN LET l_imb1131 = 0 END IF
      IF  cl_null(l_imb1132) THEN LET l_imb1132 = 0 END IF
      IF  cl_null(l_imb114)  THEN LET l_imb114 = 0  END IF
      IF  cl_null(l_imb115)  THEN LET l_imb115 = 0  END IF
      IF  cl_null(l_imb116)  THEN LET l_imb116 = 0  END IF
      IF  cl_null(l_imb1171) THEN LET l_imb1171 = 0 END IF
      IF  cl_null(l_imb1172) THEN LET l_imb1172 = 0 END IF
      IF  cl_null(l_imb119)  THEN LET l_imb119 = 0  END IF
      IF  cl_null(l_imb121)  THEN LET l_imb121 = 0  END IF
      IF  cl_null(l_imb122)  THEN LET l_imb122 = 0  END IF
      IF  cl_null(l_imb1231) THEN LET l_imb1231 = 0 END IF
      IF  cl_null(l_imb1232) THEN LET l_imb1232 = 0 END IF
      IF  cl_null(l_imb124)  THEN LET l_imb124 = 0  END IF
      IF  cl_null(l_imb125)  THEN LET l_imb125 = 0  END IF
      IF  cl_null(l_imb126)  THEN LET l_imb126 = 0  END IF
      IF  cl_null(l_imb1271) THEN LET l_imb1271 = 0 END IF
      IF  cl_null(l_imb1272) THEN LET l_imb1272 = 0 END IF
      IF  cl_null(l_imb129)  THEN LET l_imb129 = 0  END IF
      
      LET  l_imb_sum = l_imb111  + l_imb112   + l_imb1131 + l_imb1132 + l_imb114  + l_imb115  + l_imb116 				
                     + l_imb1171 + l_imb1172 + l_imb119  + l_imb121  + l_imb122  + l_imb1231 + l_imb1232				
                     + l_imb124  + l_imb125   + l_imb126  + l_imb1271 + l_imb1272 + l_imb129				
   ELSE	
      SELECT imb118 INTO l_imb118 FROM imb_file WHERE imb01 = p_value1    
      LET  l_imb_sum= l_imb118  #計算標準成本(採購料件)				
   END IF
   LET l_str1 = cl_getmsg('azz1153',g_lang) CLIPPED          #單位成本
   LET l_str2 = cl_getmsg('azz1154',g_lang) CLIPPED          #最高成本		
   LET l_str3 = cl_getmsg('azz1155',g_lang) CLIPPED          #平均成本
   LET l_str4 = cl_getmsg('azz1156',g_lang) CLIPPED          #最低成本  
   LET l_str5 = cl_getmsg('mfg1315',g_lang) CLIPPED          #標準成本

   CALL cl_chart_del_trend_line( p_loc )  #先清空標準線 
   CALL cl_chart_add_trend_line( p_loc,l_max,l_max,"FF0000",l_str2,"valueOnRight=1,thickness=3")            #最高-紅線 
   CALL cl_chart_add_trend_line( p_loc,l_avg,l_avg,"00FF00",l_str3,"valueOnRight=1,thickness=3")            #平均-綠線 
   CALL cl_chart_add_trend_line( p_loc,l_min,l_min,"0000FF",l_str4,"valueOnRight=1,thickness=3")            #最低-藍線 
   CALL cl_chart_add_trend_line( p_loc,l_imb_sum,l_imb_sum,"FFFF00",l_str5,"valueOnRight=1,thickness=3")   #標準-黃線 

   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_unitcost_d"
   IF NOT cl_null(p_value1) THEN     #料號
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_ima02,")"
   END IF
   IF NOT cl_null(p_value2) THEN
      IF NOT cl_null(l_sub_str) THEN #年度
         LET l_sub_str = l_sub_str,"(",cl_getmsg(l_gdk03,g_lang),":",p_value2,")"
      ELSE
         LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk03,g_lang),":",p_value2
      END IF
   END IF
   IF NOT cl_null(p_value1) OR NOT cl_null(p_value2) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_unitcost_d")
   CALL cl_chart_clear(p_loc)                          #清除相關變數資料(釋放記憶體)

END FUNCTION

#FUNCTION s_chart_unitcost_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_unitcost_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
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
DEFINE l_ccc01       LIKE ccc_file.ccc01
DEFINE l_ccc02       LIKE type_file.chr4
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_unitcost_d"
   IF NOT cl_null(l_gdk02) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT ccc01,ima02  ",
                  "  FROM ccc_file,ima_file ",
                  " WHERE ccc01=ima01 ",
                  "   AND ccc07 = '1'  ",
                  " ORDER BY ccc01 "
      PREPARE s_ccc_pre1 FROM l_sql
      DECLARE s_ccc_cs1 CURSOR FOR s_ccc_pre1
      FOREACH s_ccc_cs1 INTO l_ccc01,l_ima02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_ccc01 CLIPPED
            LET l_combo_item  = l_combo_item,",",l_ccc01 CLIPPED,"(",l_ima02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_ccc01
            LET l_combo_item = l_ccc01 CLIPPED,"(",l_ima02 CLIPPED,")"
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

   IF NOT cl_null(l_gdk03) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT  ccc02 FROM ccc_file ",
                  " WHERE ccc07 = '1'  ",
                  " ORDER BY ccc02 DESC "
      PREPARE sel_combo_pre2 FROM l_sql
      DECLARE sel_combo_cs2 CURSOR FOR sel_combo_pre2
      FOREACH sel_combo_cs2 INTO l_ccc02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_ccc02 CLIPPED
            LET l_combo_item = l_combo_item,",",l_ccc02 ," ",cl_getmsg('anm-156',g_lang)  CLIPPED
         ELSE
            LET l_combo_value = l_ccc02 CLIPPED
            LET l_combo_item = l_ccc02 CLIPPED ," ",cl_getmsg('anm-156',g_lang)  CLIPPED
         END IF
      END FOREACH
      CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
      IF l_combo_value.getIndexof(",",1)=0 THEN
         LET l_def_filter1 = l_combo_value
      ELSE
         LET l_def_filter2 = l_combo_value.subString(1,l_combo_value.getIndexof(",",1)-1)
      END IF
   ELSE
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,FALSE)
   END IF
   RETURN l_def_filter1,l_def_filter2
END FUNCTION

#FUN-BA0095
