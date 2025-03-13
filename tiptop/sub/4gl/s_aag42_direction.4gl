# Prog. Version..: '5.3.0.07-13.05.13(00001)'
#
# Pattern name...: s_aag42_direction.4gl
# Descriptions...:
# Date & Author..: 13/05/13 By yinhy NO.CHI-D50021

DATABASE ds

GLOBALS "../../config/top.global"
FUNCTION s_aag42_direction(p_bookno,p_npq03,p_npq06,p_npq07,p_npq07f)
   DEFINE p_bookno  LIKE aag_file.aag00
   DEFINE p_npq03   LIKE npq_file.npq03
   DEFINE p_npq06   LIKE npq_file.npq06
   DEFINE p_npq07   LIKE npq_file.npq07
   DEFINE p_npq07f  LIKE npq_file.npq07f
   DEFINE l_aag06   LIKE aag_file.aag06
   DEFINE l_aag42   LIKE aag_file.aag42

   IF cl_null(p_npq03) THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   IF cl_null(p_npq06) OR p_npq06 NOT MATCHES '[12]' THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF

   IF cl_null(p_npq07)  THEN LET p_npq07  = 0 END IF
   IF cl_null(p_npq07f) THEN LET p_npq07f = 0 END IF
   IF p_npq07 = 0 AND p_npq07f = 0 THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   
    SELECT aag06,aag42 INTO l_aag06,l_aag42
     FROM aag_file
    WHERE aag00 = p_bookno
      AND aag01 = p_npq03
   IF cl_null(l_aag42) OR l_aag42 = 'N' THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   IF l_aag06 = '1' AND p_npq06 = '1' OR
      l_aag06 = '2' AND p_npq06 = '2' THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   IF p_npq06 = '1' THEN
      LET p_npq06 = '2'
   ELSE
      LET p_npq06 = '1'
   END IF
   LET p_npq07 = p_npq07 * -1
   LET p_npq07f= p_npq07f* -1
   
   RETURN p_npq06,p_npq07,p_npq07f
END FUNCTION
