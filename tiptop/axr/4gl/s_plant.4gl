# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_r140_plant.4gl
# Descriptions...: 判斷plant 是否來自於流通,若是流通則回傳總營運中心或者是第一筆plan 
# Date & Author..: No.FUN-BB0173 11/11/30 by pauline
# Input parameter: p_plant 
# RETURN code....: l_plant

DATABASE ds 

FUNCTION chk_plant(p_plant)
DEFINE p_plant         LIKE azw_file.azw01
DEFINE p_string        STRING
DEFINE l_azw01         LIKE azw_file.azw01
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_sql           STRING
   LET l_azw01 = ' '
   SELECT COUNT(*) INTO l_cnt FROM azw_file
      WHERE azw09 = azw05 AND azw02 IN (SELECT azw02 FROM azw_file WHERE azw01 = p_plant)
   IF l_cnt > 1 THEN #流通
      SELECT azw01 INTO l_azw01 FROM azw_file  #選擇總部(登入DB=實體DB)為plant
         WHERE azw09 = azw05 AND azw02 IN (SELECT azw02 FROM azw_file WHERE azw01 = p_plant)
           AND azw05 = azw06
      IF cl_null(l_azw01) THEN #沒設定總部(登入DB=實體DB),則第一筆plant為主
         LET l_sql = "SELECT azw01 FROM azw_file ",
                     " WHERE azw09 = azw05 AND azw02 IN (SELECT azw02 FROM azw_file WHERE azw01 = '",p_plant,"') ",
                     " ORDER BY azw01 "
         PREPARE plant_pre FROM l_sql
         DECLARE plant_cur CURSOR FOR plant_pre
         FOREACH plant_cur INTO l_azw01
           IF NOT cl_null(l_azw01) THEN
              EXIT FOREACH
           END IF
         END FOREACH         
      END IF
   ELSE
      SELECT azw01 INTO l_azw01 FROM azw_file  
         WHERE azw09 = azw05 AND azw02 IN (SELECT azw02 FROM azw_file WHERE azw01 = p_plant)      
   END IF
   RETURN l_azw01
END FUNCTION
#FUN-BB0173
