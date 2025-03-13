# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_get_extra_cond.4gl
# Descriptions...: 增加額外的查詢條件
# Date & Author..: 2009/07/24 by Hiko
# Usage..........: CALL cl_get_extra_cond(azpuser, azpgrup) RETURNING l_extra_cond
# Modify.........: No.FUN-980030 09/08/04 By Hiko 新建程式
# Modify.........: No.FUN-A60005 10/06/01 By Hiko 調整效率問題
# Modify.........: No.FUN-B10069 11/01/28 By tommas 資料權限方式改變,這邊要移除gfk_file的過濾. 
# Modify.........: NO.FUN-B70080 11/07/21 By tommas 不可拿掉LET g_prog_name = g_prog
# Modify.........: NO.MOD-C60105 12/06/19 By Elise 使用matches會發生'運算子錯誤'

DATABASE ds
 
#FUN-980030
 
GLOBALS "../../config/top.global"
 
DEFINE g_prog_name LIKE type_file.chr20
 
##################################################
# Descriptions...: 開窗程式專用:增加額外的查詢條件
# Date & Author..: 2009/08/11 by Hiko
# Input Parameter: p_prog_name  開窗程式代碼
#                : p_table_name 開窗程式的主Table
# Return code....: l_extra_cond 額外的查詢條件
##################################################
FUNCTION cl_get_extra_cond_for_qry(p_prog_name, p_table_name)
   DEFINE p_prog_name  LIKE type_file.chr20,
          p_table_name LIKE gfk_file.gfk01
   DEFINE l_gfk02      LIKE gfk_file.gfk02,
          l_gfk03      LIKE gfk_file.gfk03
   DEFINE l_extra_cond STRING
 
   LET g_prog_name = p_prog_name
 
   CALL get_data_owner_fields(p_table_name) RETURNING l_gfk02,l_gfk03
 
   #這裡就和一般程式的判斷有所不同,有設定就有設定,沒設定也沒有預設的欄位.
   LET l_extra_cond = get_data_filter(l_gfk02, l_gfk03)
 
   RETURN l_extra_cond
END FUNCTION
 
##################################################
# Descriptions...: 增加額外的查詢條件
# Date & Author..: 2009/07/24 by Hiko
# Input Parameter: p_user_field 資料歸屬人員攔位
#                : p_grup_field 資料歸屬部門欄位
# Return code....: l_extra_cond 額外的查詢條件
##################################################
FUNCTION cl_get_extra_cond(p_user_field, p_grup_field)
   DEFINE p_user_field STRING,
          p_grup_field STRING
#Begin No.FUN-B10069
#   DEFINE l_table_name STRING,
#          l_gfk_sql    STRING,
#          l_gfk_cnt    SMALLINT,
#          l_gfk02      LIKE gfk_file.gfk02,
#          l_gfk03      LIKE gfk_file.gfk03
#End No.FUN-B10069
   DEFINE l_extra_cond STRING
 
#Begin No.FUN-B10069
    LET g_prog_name = g_prog #FUN-B70080
 
#   #FUN-A60005:若是都沒有設定gfk_file,則直接跳過parse段落.
#   SELECT count(*) INTO l_gfk_cnt FROM gfk_file
#    IF l_gfk_cnt>0 THEN
#      #依據欄位找出對應的Table Name.
#      IF NOT cl_null(p_user_field) THEN
#         LET l_table_name = cl_get_table_name(p_user_field)
#      ELSE
#         IF NOT cl_null(p_grup_field) THEN
#            LET l_table_name = cl_get_table_name(p_grup_field)
#         END IF
#      END IF
#      
#      #依據Table Name找出對應的資料歸屬欄位.
#      #若是有設定gfk_file,則要以gfk_file的設定為主.
#      IF NOT cl_null(l_table_name) THEN
#         CALL get_data_owner_fields(l_table_name) RETURNING l_gfk02,l_gfk03
#         #實際上,若有設定p_data_belong,則兩個欄位都一定會有設定.
#         IF NOT cl_null(l_gfk02) THEN
#            LET p_user_field = l_gfk02
#         END IF
#      
#         IF NOT cl_null(l_gfk03) THEN
#            LET p_grup_field = l_gfk03
#         END IF
#      END IF
#   END IF
#End No.FUN-B10069
 
   LET l_extra_cond = get_data_filter(p_user_field, p_grup_field)
 
   RETURN l_extra_cond
END FUNCTION
 
##################################################
# Descriptions...: 依據Table Name找出對應的資料歸屬欄位
# Date & Author..: 2009/08/11 by Hiko
# Input Parameter: p_table_name Table Name
# Return code....: 資料歸屬人員,資料歸屬部門
##################################################
FUNCTION get_data_owner_fields(p_table_name)
   DEFINE p_table_name LIKE gfk_file.gfk01
   DEFINE l_gfk_cnt    SMALLINT,
          l_gfk02      LIKE gfk_file.gfk02,
          l_gfk03      LIKE gfk_file.gfk03
 
   SELECT count(*) INTO l_gfk_cnt FROM gfk_file WHERE gfk01=p_table_name
   IF l_gfk_cnt > 0 THEN
      SELECT gfk02,gfk03 INTO l_gfk02,l_gfk03 FROM gfk_file WHERE gfk01=p_table_name
   END IF
 
   RETURN l_gfk02,l_gfk03
END FUNCTION
 
##################################################
# Descriptions...: 取得資料過濾條件
# Date & Author..: 2009/08/11 by Hiko
# Input Parameter: p_user_field  資料歸屬人員攔位
#                : p_grup_field  資料歸屬部門欄位
# Return code....: l_data_filter 資料過濾條件
##################################################
FUNCTION get_data_filter(p_user_field, p_grup_field)
   DEFINE p_user_field STRING,
          p_grup_field STRING
   DEFINE l_filter_cond STRING
 
   IF NOT cl_null(p_user_field) THEN
      LET p_user_field = p_user_field.trim()
      IF g_priv2='4' THEN  #只能使用自己的資料
         LET l_filter_cond = p_user_field," = '",g_user,"'"
      END IF
   END IF
   
   IF NOT cl_null(p_grup_field) THEN
      LET p_grup_field = p_grup_field.trim()
      IF g_priv3='4' THEN  #只能使用相同部門的資料
         IF NOT cl_null(l_filter_cond) THEN
            LET l_filter_cond = l_filter_cond," AND "
         END IF
        #LET l_filter_cond = l_filter_cond,p_grup_field," MATCHES '",g_grup CLIPPED,"*'"  #MOD-C60105 mark
         LET l_filter_cond = l_filter_cond,p_grup_field," LIKE '",g_grup CLIPPED,"%'"     #MOD-C60105
      END IF
      
      IF g_priv3 MATCHES "[5678]" THEN #只能使用相同部門群組的資料
         IF NOT cl_null(l_filter_cond) THEN
            LET l_filter_cond = l_filter_cond," AND "
         END IF
         LET l_filter_cond = l_filter_cond,p_grup_field," IN ",cl_chk_tgrup_list()
      END IF
   END IF
 
   IF NOT cl_null(l_filter_cond) THEN
      LET l_filter_cond = " AND ",l_filter_cond
   END IF
 
   #加上權限過濾器的設定條件(cl_auth_filter的設定是包含AND/OR)
   LET l_filter_cond = l_filter_cond,cl_auth_filter(g_prog_name)
 
   RETURN l_filter_cond
END FUNCTION
