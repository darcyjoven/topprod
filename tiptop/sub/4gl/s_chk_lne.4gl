# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chk_lne.4gl
# Descriptions...: 判断是否为商户
# Date & Author..: FUN-A80105 2010/08/20 By shaoyong
# Usage..........: CALL s_chk_lne(l_occ01) RETURNING l_flag
# Input PARAMETER: l_occ01  客戶編號
# RETURN Code....: l_flag   成功否
#                    TRUE   YES
#                    FALSE  NO

DATABASE ds

GLOBALS "../../config/top.global"
FUNCTION s_chk_lne(l_occ01) 
   DEFINE l_occ01 LIKE occ_file.occ01
   DEFINE l_n     LIKE type_file.num5

   SELECT count(*) INTO l_n FROM lne_file
    WHERE lne01 = l_occ01
   IF STATUS THEN
      RETURN FALSE
   END IF

   IF l_n > 0 THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF

END FUNCTION
#No.FUN-A80105
