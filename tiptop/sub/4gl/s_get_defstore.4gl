# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_get_defstore,4gl
# Descriptions...: 取得預設成本倉與預設非成本倉
# Date & Author..: 12/10/18 by Lori(FUN-C90049)
# Input Parameter: p_plant: 營運中心編號
#                  p_prod: 產品編號
# Return code....: g_rty14: 預設成本倉
#                  g_rty15: 預設非成本倉

DATABASE ds
GLOBALS "../../config/top.global"
#FUN-C90049

DEFINE g_sql   STRING
DEFINE g_rty14 LIKE rty_file.rty14,      #預設成本倉
       g_rty15 LIKE rty_file.rty15       #預設非成本倉

#同時取得預設成本倉與非成本倉時使用
FUNCTION s_get_defstore(p_plant,p_prod)
   DEFINE p_plant LIKE rty_file.rty01,   #營運中心編號
          p_prod  LIKE rty_file.rty02    #產品編號   
  
   LET g_rty14 = NULL
   LET g_rty15 = NULL

   LET g_rty14 = s_get_coststore(p_plant,p_prod)
   LET g_rty15 = s_get_noncoststore(p_plant,p_prod)

   RETURN g_rty14,g_rty15
END FUNCTION

#只取得預設成本倉時使用
FUNCTION s_get_coststore(p_plant_1,p_prod_1)
   DEFINE p_plant_1 LIKE rty_file.rty01,   #營運中心編號
          p_prod_1  LIKE rty_file.rty02    #產品編號

   LET g_rty14 = NULL

   IF NOT cl_null(p_prod_1) THEN
      LET g_sql = "SELECT DISTINCT rty14 ",
                  "  FROM rty_file ",
                  " WHERE rty01 = '",p_plant_1,"'",
                  "   AND rty02 = '",p_prod_1,"'"

      PREPARE rty14_pre FROM g_sql
      EXECUTE rty14_pre INTO g_rty14
   END IF

   IF cl_null(g_rty14) THEN
      SELECT rtz07 INTO g_rty14
        FROM rtz_file
       WHERE rtz01 = p_plant_1
   END IF

   RETURN g_rty14
END FUNCTION


#只取得預設非成本倉時使用
FUNCTION s_get_noncoststore(p_plant_2,p_prod_2)
   DEFINE p_plant_2 LIKE rty_file.rty01,   #營運中心編號
          p_prod_2  LIKE rty_file.rty02    #產品編號

   LET g_rty15 = NULL

   IF NOT cl_null(p_prod_2) THEN
      LET g_sql = "SELECT DISTINCT rty15 ",
                  "  FROM rty_file ",
                  " WHERE rty01 = '",p_plant_2,"'",
                  "   AND rty02 = '",p_prod_2,"'"

      PREPARE rty15_pre FROM g_sql
      EXECUTE rty15_pre INTO g_rty15
   END IF

   IF cl_null(g_rty15) THEN
      SELECT rtz08 INTO g_rty15
        FROM rtz_file
       WHERE rtz01 = p_plant_2
   END IF

   RETURN g_rty15
END FUNCTION
