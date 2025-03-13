# Prog. Version..: '5.20.01'
#
# Library name...: cl_user_has_plant_auth.4gl
# Descriptions...: 判斷使用者是否具有Plant權限.
# Date & Author..: 2009/08/05 by Hiko
# Modify.........: No.FUN-980030 09/08/04 By Hiko 新建程式
 
DATABASE ds
 
#FUN-980030
 
##########################################################################
# Private Func...: FALSE
# Descriptions...: FOR GP5.2:判斷使用者是否具有Plant權限
# Input parameter: p_user   使用者 
#                : p_plant  營運中心
# Return code....: l_result TRUE/FALSE
# Usage..........: CALL cl_user_has_plant_auth(gac05)
# Date & Author..: 2009/08/05 by Hiko
##########################################################################
FUNCTION cl_user_has_plant_auth(p_user, p_plant)
   DEFINE p_user  LIKE zxy_file.zxy01,
          p_plant LIKE zxy_file.zxy03
   DEFINE l_zxy_sql STRING,
          l_zxy_cnt SMALLINT,
          l_result  BOOLEAN
   
   LET l_result = FALSE
 
   LET l_zxy_sql = "SELECT COUNT(*) FROM zxy_file",
                   " WHERE zxy01='",p_user CLIPPED,"' AND zxy03='",p_plant CLIPPED,"'"
   DECLARE zxy_curs SCROLL CURSOR FROM l_zxy_sql
   OPEN zxy_curs
   FETCH FIRST zxy_curs INTO l_zxy_cnt
   CLOSE zxy_curs
   
   IF l_zxy_cnt > 0 THEN #判斷是否具有權限.
      LET l_result = TRUE
   END IF
      
   RETURN l_result
END FUNCTION
