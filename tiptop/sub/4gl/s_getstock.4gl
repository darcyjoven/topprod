# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Pattern name...: s_getstock.4gl
# Descriptions...: 抓取庫存量 
# Date & Author..: 10/03/18 By jiachenchao
# Usage..........: CALL s_getstock(p_ima01) RETURNING: l_ima26, l_ima261, l_ima262
# Input Parameter: p_ima01     
# Return code....: l_version   版本 
# modify..........:FUN-A20044  10/03/25 By JIACHAOCHAO 加入plant
# modify..........:FUN-A30098  10/03/31 BY huangrh ------過單

DATABASE ds

GLOBALS "../../config/top.global" #FUN-A20044

FUNCTION s_getstock(p_ima01, p_plant)

DEFINE p_ima01 LIKE ima_file.ima01 
DEFINE p_plant LIKE type_file.chr10 #FUN-A20044
DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3
DEFINE l_unavl_stk      LIKE type_file.num15_3
DEFINE l_avl_stk        LIKE type_file.num15_3 
DEFINE g_sql   STRING    #FUN-A20044
   LET g_sql = "SELECT SUM(img10*img21) ",
               " FROM ", cl_get_target_table( p_plant, 'img_file'),
               " WHERE img01 = ? AND img24 = 'Y' "
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE avl_stk_mpsmrp_pre FROM g_sql
   EXECUTE avl_stk_mpsmrp_pre INTO l_avl_stk_mpsmrp  USING p_ima01       
     IF cl_null(l_avl_stk_mpsmrp) THEN
        LET l_avl_stk_mpsmrp = 0
     END IF
   LET g_sql = "SELECT SUM(img10*img21) ",
               " FROM ", cl_get_target_table( p_plant, 'img_file'),
               " WHERE img01 = ? AND img23 = 'N'  "
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE unavl_stk_pre FROM g_sql
      EXECUTE unavl_stk_pre INTO l_unavl_stk  USING p_ima01
         IF cl_null(l_unavl_stk) THEN
            LET l_unavl_stk = 0
         END IF
   LET g_sql = "SELECT SUM(img10*img21) ",
               " FROM ", cl_get_target_table( p_plant, 'img_file'),
               " WHERE img01 = ? AND img23 = 'Y' "
       CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
       PREPARE avl_stk_pre FROM g_sql
       EXECUTE avl_stk_pre INTO l_avl_stk  USING p_ima01
          IF cl_null(l_avl_stk) THEN
             LET l_avl_stk = 0
          END IF
   RETURN  l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
END FUNCTION
#FUN-A30098
