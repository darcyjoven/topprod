# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_ar_m.4gl
# Descriptions...: 各年月應收帳款狀況
# Date & Author..: No.FUN-BA0095 2011/11/18 By linlin
# Input Parameter: p_loc  圖表位置
# Usage..........: CALL s_chart_ar_m(p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_chart.global"

FUNCTION s_chart_ar_m(p_loc)
DEFINE p_loc                  LIKE type_file.chr10
DEFINE ar_s1                  LIKE oma_file.oma56t #應收金額
DEFINE ar_s2                  LIKE oma_file.oma57  #已沖金額
DEFINE l_oma02                LIKE type_file.chr6 #日期 
DEFINE l_sql                  STRING
DEFINE l_str1                 STRING
DEFINE l_str2                 STRING
DEFINE l_str3                 STRING
DEFINE l_substr               STRING               #子標題
DEFINE l_str                  STRING     
DEFINE l_chk_auth             STRING           

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_ar_m",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限
   #抓取金額
   INITIALIZE l_oma02,ar_s1,ar_s2 TO NULL
   LET l_sql = " SELECT ",cl_tp_tochar('oma02','YYYYMM'),",SUM(oma56t),SUM(oma57) ",
               "   FROM oma_file ",
               "  WHERE oma56t>oma57 ",
               "    AND omaconf='Y' ",
               "    AND oma00 LIKE '1%' ",
               "  GROUP BY ",cl_tp_tochar('oma02','YYYYMM'),
               "  ORDER BY ",cl_tp_tochar('oma02','YYYYMM')
   PREPARE sel_oma_pre FROM l_sql
   DECLARE sel_oma_cs CURSOR FOR sel_oma_pre
   FOREACH sel_oma_cs INTO l_oma02,ar_s1,ar_s2
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(ar_s1) THEN 
         LET ar_s1 = 0  
      END IF
      IF cl_null(ar_s2) THEN 
         LET ar_s2 = 0  
      END IF
      #各年月應收帳款狀況
      SELECT oma02 INTO l_oma02 FROM oma_file WHERE oma01 = l_oma02
      LET l_str1 = l_oma02 CLIPPED                                     #日期
      LET l_str2 = cl_getmsg('azz-197',g_lang) CLIPPED                 #應收金額
      LET l_str3 = cl_getmsg('azz1132',g_lang) CLIPPED                 #已沖金額
       
      CALL cl_chart_array_data( p_loc ,"categories","",l_str1)
      CALL cl_chart_array_data(p_loc,"dataset",l_str2,ar_s1)
      CALL cl_chart_array_data(p_loc,"dataset",l_str3,ar_s2)
      
   END FOREACH
   CALL cl_chart_create(p_loc,"s_chart_ar_m")
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
   

   #以最後一個年度連動其他5個圖表
   CALL s_chart_ar_s1(l_oma02,'','','','',"wc_2")
   CALL s_chart_ar_s2(l_oma02,'','','','',"wc_3")
   CALL s_chart_ar_s3(l_oma02,'','','',"wc_4")
   CALL s_chart_ar_s4(l_oma02,'','','','',"wc_5")
   CALL s_chart_ar_s5(l_oma02,'','','','',"wc_6")

   LET g_lnkchart7.argv1 = l_oma02

END FUNCTION

#FUN-BA0095
