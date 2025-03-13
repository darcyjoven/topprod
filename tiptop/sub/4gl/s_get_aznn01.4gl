# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: s_get_aznn01.4gl
# Descriptions...: 抓取aznn_file截止日期 
# PARAMETERS       p_azp01      營運中心
# 		   p_axa06      編製合併期別      
# 		   p_axa03      帳別     
# 		   p_yy         年度     
# 		   p_q1         季     
# 		   p_h1         半年     
# RETURNING	   p_em         截止日期
# Date & Author..: 11/01/24 CHI-B10030 by Summer 
# Modify.........: No.FUN-C30098 12/03/20 By Belle 增加起始期別
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_sql        STRING

FUNCTION s_get_aznn01(p_azp01,p_axa06,p_axa03,p_yy,p_q1,p_h1)
DEFINE  p_azp01      LIKE azp_file.azp01
DEFINE  p_axa06      LIKE axa_file.axa06
DEFINE  p_axa03      LIKE axa_file.axa03
DEFINE  p_axz01      LIKE axz_file.axz01
DEFINE  p_yy         LIKE type_file.num5
DEFINE  p_q1         LIKE type_file.chr1
DEFINE  p_h1         LIKE type_file.chr1
DEFINE  l_aznn01     LIKE aznn_file.aznn01
DEFINE  p_em         LIKE type_file.num5

   CASE p_axa06
       WHEN '2'  #季 
            LET g_sql = "SELECT MAX(aznn01) ",
                        "  FROM ",cl_get_target_table(p_azp01,'aznn_file'),
                        " WHERE aznn00 = '",p_axa03,"'",
                        "   AND aznn02 = '",p_yy,"'",
                        "   AND aznn03 = '",p_q1,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql
            PREPARE p2 FROM g_sql
            DECLARE c2 CURSOR FOR p2
            OPEN c2
            FETCH c2 INTO l_aznn01
            CLOSE c2
            LET p_em = MONTH(l_aznn01)
       WHEN '3'  #半年
            IF p_h1 = '1' THEN  #上半年
                LET g_sql = "SELECT MAX(aznn01) ",
                            "  FROM ",cl_get_target_table(p_azp01,'aznn_file'),
                            " WHERE aznn00 = '",p_axa03,"'",
                            "   AND aznn02 = '",p_yy,"'",
                            "   AND aznn03  < 3 "
            ELSE                 #下半年
                LET g_sql = "SELECT MAX(aznn01) ",
                            "  FROM ",cl_get_target_table(p_azp01,'aznn_file'),
                            " WHERE aznn00 = '",p_axa03,"'",
                            "   AND aznn02 = '",p_yy,"'",
                            "   AND aznn03  >= 3 "  #大於等於第三季
            END IF
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql
            PREPARE p3 FROM g_sql
            DECLARE c3 CURSOR FOR p3
            OPEN c3
            FETCH c3 INTO l_aznn01
            CLOSE c3
            LET p_em = MONTH(l_aznn01)
       WHEN  '4'  #年
            LET g_sql = "SELECT MAX(aznn01) ",
                        "  FROM ",cl_get_target_table(p_azp01,'aznn_file'),
                        " WHERE aznn00 = '",p_axa03,"'",
                        "   AND aznn02 = '",p_yy,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql
            PREPARE p4 FROM g_sql
            DECLARE c4 CURSOR FOR p4
            OPEN c4
            FETCH c4 INTO l_aznn01
            CLOSE c4
            LET p_em = MONTH(l_aznn01)
   END CASE
   RETURN p_em
END FUNCTION 
#CHI-B10030
#FUN-C30098
FUNCTION s_get_aznn02(p_azp01,p_axa06,p_axa03,p_yy,p_q1,p_h1)
DEFINE  p_azp01      LIKE azp_file.azp01
DEFINE  p_axa06      LIKE axa_file.axa06
DEFINE  p_axa03      LIKE axa_file.axa03
DEFINE  p_axz01      LIKE axz_file.axz01
DEFINE  p_yy         LIKE type_file.num5
DEFINE  p_q1         LIKE type_file.chr1
DEFINE  p_h1         LIKE type_file.chr1
DEFINE  l_aznn01     LIKE aznn_file.aznn01
DEFINE  p_em         LIKE type_file.num5

   CASE p_axa06
       WHEN '2'  #季 
            LET g_sql = "SELECT MIN(aznn01) ",
                        "  FROM ",cl_get_target_table(p_azp01,'aznn_file'),
                        " WHERE aznn00 = '",p_axa03,"'",
                        "   AND aznn02 = '",p_yy,"'",
                        "   AND aznn03 = '",p_q1,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql
            PREPARE p22 FROM g_sql
            DECLARE c22 CURSOR FOR p22
            OPEN c22
            FETCH c22 INTO l_aznn01
            CLOSE c22
            LET p_em = MONTH(l_aznn01)
       WHEN '3'  #半年
            IF p_h1 = '1' THEN  #上半年
                LET g_sql = "SELECT MIN(aznn01) ",
                            "  FROM ",cl_get_target_table(p_azp01,'aznn_file'),
                            " WHERE aznn00 = '",p_axa03,"'",
                            "   AND aznn02 = '",p_yy,"'",
                            "   AND aznn03  < 3 "
            ELSE                 #下半年
                LET g_sql = "SELECT MIN(aznn01) ",
                            "  FROM ",cl_get_target_table(p_azp01,'aznn_file'),
                            " WHERE aznn00 = '",p_axa03,"'",
                            "   AND aznn02 = '",p_yy,"'",
                            "   AND aznn03  >= 3 "  #大於等於第三季
            END IF
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql
            PREPARE p32 FROM g_sql
            DECLARE c32 CURSOR FOR p32
            OPEN c32
            FETCH c32 INTO l_aznn01
            CLOSE c32
            LET p_em = MONTH(l_aznn01)
       WHEN  '4'  #年
            LET g_sql = "SELECT MIN(aznn01) ",
                        "  FROM ",cl_get_target_table(p_azp01,'aznn_file'),
                        " WHERE aznn00 = '",p_axa03,"'",
                        "   AND aznn02 = '",p_yy,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql
            PREPARE p42 FROM g_sql
            DECLARE c42 CURSOR FOR p42
            OPEN c42
            FETCH c42 INTO l_aznn01
            CLOSE c42
            LET p_em = MONTH(l_aznn01)
   END CASE
   RETURN p_em
END FUNCTION 
#FUN-C30098
