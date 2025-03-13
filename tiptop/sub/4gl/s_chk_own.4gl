# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chk_own.4gl
# Descriptions...: 判斷是否為同法人自營櫃商戶(同法人的營運中心)
# Date & Author..: FUN-BB0117 2012/01/05 By shiwuying
# Usage..........: CALL s_chk_own(p_occ01) RETURNING TRUE/FALSE
# Input PARAMETER: p_occ01  客戶編號
# RETURN Code....: TRUE/FALSE

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chk_own(p_occ01)
 DEFINE p_occ01  LIKE occ_file.occ01
 DEFINE l_occ930 LIKE occ_file.occ930
 DEFINE l_azw02  LIKE azw_file.azw02

   SELECT occ930 INTO l_occ930 FROM occ_file
    WHERE occ01 = p_occ01
   IF cl_null(l_occ930) THEN
      RETURN FALSE     
   ELSE
      SELECT azw02 INTO l_azw02 FROM azw_file
       WHERE azw01 = l_occ930
      IF l_azw02 != g_legal THEN
         RETURN FALSE
      ELSE 
         RETURN TRUE
      END IF
   END IF  
END FUNCTION
#FUN-BB0117
