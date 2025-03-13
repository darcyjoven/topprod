# Prog. Version..: '5.30.05-13.01.08(00000)'     #
#
# Program name...: cl_get_hrzxa.4gl
# Descriptions...: 组成部门设限的SQL
# Date & Author..: 2016-04-28 by yj

DATABASE ds
 
#FUN-980030
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_get_hrzxa(p_user)  
    DEFINE  l_cnt    LIKE type_file.num5 
    DEFINE  l_zxa04  LIKE hrzxa_file.hrzxa04 
    DEFINE  l_zxa05  LIKE hrzxa_file.hrzxa05 
    DEFINE  l_hrao01 LIKE hrao_file.hrao01
    DEFINE  l_wc    string  
    DEFINE  l_len    LIKE type_file.num5 
    DEFINE  p_user   LIKE zx_file.zx01
    DEFINE  l_zx04     LIKE zx_file.zx04
    DEFINE g_sql1                 STRING
    DEFINE g_sql2                 STRING

    SELECT zx04 INTO  l_zx04 FROM zx_file WHERE zx01=p_user
    IF not cl_null(l_zx04) THEN 
    LET  l_wc='1=1'
    ELSE
    LET g_sql1 = "SELECT hrzxa04,hrzxa05 from hrzxa_file where hrzxa01='",p_user,"'"
    LET l_wc="hrat04 in ("
    PREPARE i006_zxp FROM g_sql1
    DECLARE i006_zxcs CURSOR FOR i006_zxp
    FOREACH  i006_zxcs INTO l_zxa04,l_zxa05
       IF l_zxa05 = 'Y' THEN 
          LET g_sql2="select hrao01 from hrao_file where hrao01='",l_zxa04,"'",
                     " union select hrao01 from hrao_file where hrao06='",l_zxa04,"'",
                     " union select hrao01 from hrao_file where hrao06 in (select hrao01 ",
	             " from hrao_file where hrao06='",l_zxa04,"')",
                     " union select hrao01 from hrao_file where hrao06 in (select hrao01 ",
		     " from hrao_file where hrao06 in (select hrao01 from hrao_file where hrao06='",l_zxa04,"'))"
		   ELSE 
		      LET g_sql2="select hrao01 from hrao_file where hrao01='",l_zxa04,"'"
		   END IF 
          PREPARE  i006_zxp1 FROM g_sql2
          DECLARE  i006_zxcs1  CURSOR FOR i006_zxp1
          FOREACH  i006_zxcs1 INTO  l_hrao01
	        LET l_wc=l_wc,"'",l_hrao01,"',"
	        END FOREACH  

    END FOREACH
       LET l_wc=l_wc,"'')"  
    END IF 
       RETURN l_wc
END FUNCTION

