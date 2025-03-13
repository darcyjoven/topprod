# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Library name...: s_get_plant_tree.4gl
# Descriptions...: 向下展階取得傳入Plant的階層關係(WHERE IN格式)
# Date & Author..: 2010/05/24 by Hiko
# Usage..........: CALL s_get_plant_tree(g_plant)
# Modify.........: FUN-A50080 10/05/24 By Hiko 新建程式
# Modify.........: No.FUN-A70096 10/07/16 By tommas 調整get_plant_by_azw07內判斷階層是否有遞迴情況的作法,以避免判斷錯誤. 
# Modify.........: No:FUN-B70007 11/07/05 By jrg542 在EXIT PROGRAM前加上CALL cl_used(2)

DATABASE ds
 
GLOBALS "../../config/top.global"

#FUN-A50080
 
##################################################
# Descriptions...: 向下展階取得傳入Plant的階層關係(WHERE IN格式)
# Date & Author..: 2010/05/24 by Hiko
# Input Parameter: p_plant 營運中心
# Return code....: 營運中心階層清單
##################################################
FUNCTION s_get_plant_tree(p_plant)
   DEFINE p_plant LIKE azw_file.azw07
   DEFINE l_plant_tree STRING

   LET l_plant_tree = "'",p_plant CLIPPED,"'"
   RETURN get_plant_by_azw07(p_plant, l_plant_tree)
END FUNCTION

##################################################
# Descriptions...: 向下展階取得傳入Plant的階層關係(WHERE IN格式)
# Date & Author..: 2010/05/24 by Hiko
# Input Parameter: p_azw07 上層營運中心
#                : p_plant_tree 營運中心清單
# Return code....: p_plant_tree
##################################################
PRIVATE FUNCTION get_plant_by_azw07(p_azw07, p_plant_tree)
   DEFINE p_azw07 LIKE azw_file.azw07,
          p_plant_tree STRING
   DEFINE l_azw_sql STRING,
          l_i       SMALLINT
   DEFINE l_azw_rec DYNAMIC ARRAY OF RECORD
                    azw01 LIKE azw_file.azw01
                    END RECORD,
          l_plant STRING
   DEFINE l_key_word STRING,   #FUN-A70096 用來比對g_plant_tree用的   
          l_err_msg  STRING    #用來顯示錯誤訊息。因為在此function時，g_lang尚未賦值，所以用cl_err，不用cl_err_msg

   LET p_azw07 = p_azw07 CLIPPED

   LET l_azw_sql = "SELECT azw01 FROM azw_file WHERE azw07='",p_azw07,"'"
   PREPARE azw_pre FROM l_azw_sql
   DECLARE azw_curs CURSOR FOR azw_pre

   LET l_i = 1
   FOREACH azw_curs INTO l_azw_rec[l_i].*
      IF STATUS THEN
         CALL cl_err('foreach:', STATUS, 1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time # FUN-B70007
         EXIT PROGRAM
      END IF

      LET l_i = l_i + 1
   END FOREACH

   CALL l_azw_rec.deleteElement(l_i)

   FOR l_i=1 TO l_azw_rec.getLength()
      LET l_plant = l_azw_rec[l_i].azw01 CLIPPED
      LET l_key_word = "'",l_plant,"'"            #No.FUN-A70096 用來與p_plant_tree比對的key word

      IF cl_null(p_plant_tree) THEN
         LET p_plant_tree = "'",l_plant,"'"
      ELSE
         IF p_plant_tree.getIndexOf(l_key_word, 1)>0 THEN #在清單內有找到目前的營運中心,表示資料有錯誤,會造成無窮迴圈.
            LET l_err_msg = "The plant '",l_plant,"' belongs to a ring structure architecture, please check for errors!"
            CALL cl_err(l_err_msg, "!", 1)        #No.FUN-A70096 g_lang尚未賦值，所以用cl_err直接輸出錯誤訊息!
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007 
            EXIT PROGRAM
         ELSE
            LET p_plant_tree = p_plant_tree,",'",l_plant,"'"
         END IF
      END IF

      LET p_plant_tree = get_plant_by_azw07(l_plant, p_plant_tree)
   END FOR

   RETURN p_plant_tree
END FUNCTION
