# Prog. Version..: '5.25.07-12.04.03(00002)'     #
#
# Program name...: s_get_aznn.4gl
# Descriptions...: 传入营运中心,账别，日期，抓取aznn_file的年度，季别，期别和周别 
# PARAMETERS           
#      p_plant            营运中心   
#      p_bookno           账别     
#      p_date             日期
#      p_flag             标识符   1，回传年度     2，回传季别       3，回传期别            4，回传周别
# RETURNING	   p_mm       回传值           年度/季别/期别/周别
# Date & Author..: 12/09/19   by wujie 


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_sql        STRING

FUNCTION s_get_aznn(p_plant,p_bookno,p_date,p_flag)
DEFINE  p_plant           LIKE  azp_file.azp01
DEFINE  p_bookno          LIKE  aza_file.aza81
DEFINE  p_date            LIKE  type_file.dat
DEFINE  p_flag            LIKE  type_file.chr1
DEFINE  p_mm              LIKE  type_file.num5
DEFINE  l_year            LIKE  type_file.num5      
DEFINE  l_season          LIKE  type_file.num5
DEFINE  l_month           LIKE  type_file.num5
DEFINE  l_week            LIKE  type_file.num5


   IF cl_null(p_date) THEN RETURN '' END IF
   LET g_sql = "SELECT aznn02,aznn03,aznn04,aznn05 ",
               "  FROM ",cl_get_target_table(p_plant,'aznn_file'),
               " WHERE aznn00 = '",p_bookno,"'",
               "   AND aznn01 = '",p_date,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE p FROM g_sql
   DECLARE c CURSOR FOR p
   OPEN c
   FETCH c INTO l_year,l_season,l_month,l_week
   CLOSE c
            
            
            
   CASE p_flag
       WHEN '1'  #年
         LET p_mm = l_year
       WHEN '2'  #季
         LET p_mm = l_season
       WHEN '3'  #月
         LET p_mm = l_month
       WHEN '4'  #周 
         LET p_mm = l_week
   END CASE
   RETURN p_mm
END FUNCTION 
