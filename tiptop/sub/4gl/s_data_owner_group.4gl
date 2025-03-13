# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_data_owner_group.4gl
# Descriptions...: 從data belong中取得欄位後，至畫面中取得設定的欄位值
# Date & Author..: 11/01/28 By  tommas
# Usage..........: CALL s_get_data_owner(p_table_name) RETURNING l_owner
#                  CALL s_get_data_group(p_table_name) RETURNING l_grup
# Input Parameter: p_table_name 資料表名稱
# Return Code....: l_owner 資料擁有者
#                  l_grup 資料群組
# Modify.........: No.FUN-B10069 By tommas 新建程式
# Modify.........: No.FUN-C20008 By madey 增加function s_upd_owner_group
# Modify.........: No.TQC-C80038 By Hiko 主程式因為使用*來更新所有資料,導致此功能出現錯誤,因此調整.
 
DATABASE ds
 
GLOBALS "../../config/top.global"   
 
FUNCTION s_get_data_owner(p_table_name)  #No.FUN-B10069 新建
   DEFINE p_table_name LIKE gfk_file.gfk01  #資料表名稱
   DEFINE l_gfk02      LIKE gfk_file.gfk02  #資料所有者欄位  
   DEFINE l_owner      LIKE type_file.chr10
   DEFINE l_win        ui.Window
   DEFINE l_node_list  om.NodeList
   DEFINE l_win_node   om.DomNode,
          l_field      om.DomNode
   DEFINE l_len        INTEGER,
          l_i          INTEGER
   #Begin : #TQC-C80038
   DEFINE l_table_name STRING,
          l_table_idx  SMALLINT,
          l_table_pre  STRING,
          l_rtn_value  STRING
   #End : #TQC-C80038

   SELECT gfk02 INTO l_gfk02 FROM gfk_file WHERE gfk01 = p_table_name

   IF cl_null(l_gfk02) THEN  #p_data_belong未設定時，回傳g_user #TQC-C80038:改為取得畫面上的user欄位
      #Begin : #TQC-C80038
      #RETURN g_user
      LET l_table_name = p_table_name CLIPPED
      LET l_table_idx = l_table_name.getIndexOf("_", 1) #取得table name的識別符號,例如"oea_file"的"_"
      LET l_table_pre = l_table_name.subString(1, l_table_idx-1) #例如"oea_file"的"oea"
      LET l_gfk02 = l_table_pre,"user"
   END IF
   #ELSE
   #End : #TQC-C80038
      LET l_win = ui.Window.getCurrent()
      LET l_win_node = l_win.getNode()
      LET l_node_list = l_win_node.selectByTagName("FormField")
      LET l_len = l_node_list.getLength()
      FOR l_i = 1 TO l_len
          LET l_field = l_node_list.item(l_i)
          IF l_field.getAttribute("colName") == l_gfk02 THEN
             LET l_owner = l_field.getAttribute("name")
            
             #畫面欄位為空值或null時，回傳g_user
             IF cl_null(l_owner) THEN
                #RETURN g_user #TQC-C80038
                LET l_rtn_value = g_user #TQC-C80038:這種狀況一定是新增.
             ELSE
                #RETURN l_field.getAttribute("value") #TQC-C80038
                LET l_rtn_value = l_field.getAttribute("value") #TQC-C80038
             END IF
             EXIT FOR
          END IF
      END FOR
   #Begin : #TQC-C80038
   #END IF
   #RETURN g_user
   RETURN l_rtn_value
   #End : #TQC-C80038
END FUNCTION

FUNCTION s_get_data_group(p_table_name)   #No.FUN-B10069 新建
   DEFINE p_table_name  LIKE gfk_file.gfk01    #資料表名稱
   DEFINE l_gfk03       LIKE gfk_file.gfk03    #資料群組欄位
   DEFINE l_grup        LIKE  type_file.chr20  
   DEFINE l_win         ui.Window
   DEFINE l_node_list   om.NodeList,
          l_win_node    om.DomNode,
          l_field       om.DomNode
   DEFINE l_len         INTEGER,
          l_i           INTEGER
   #Begin : #TQC-C80038
   DEFINE l_table_name STRING,
          l_table_idx  SMALLINT,
          l_table_pre  STRING,
          l_rtn_value  STRING
   #End : #TQC-C80038

   SELECT gfk03 INTO l_gfk03 FROM gfk_file WHERE gfk01 = p_table_name

   #未設定p_data_belong時，回傳g_grup
   IF cl_null(l_gfk03) THEN
      #Begin : #TQC-C80038:改為取得畫面上的user欄位
      #RETURN g_grup
      LET l_table_name = p_table_name CLIPPED
      LET l_table_idx = l_table_name.getIndexOf("_", 1) #取得table name的識別符號,例如"oea_file"的"_"
      LET l_table_pre = l_table_name.subString(1, l_table_idx-1) #例如"oea_file"的"oea"
      LET l_gfk03 = l_table_pre,"grup"
   END IF
   #ELSE
   #End : #TQC-C80038
      LET l_win = ui.Window.getCurrent()
      LET l_win_node = l_win.getNode()
      LET l_node_list = l_win_node.selectByTagName("FormField")
      LET l_len = l_node_list.getLength()
      FOR l_i = 1 TO l_len
          LET l_field = l_node_list.item(l_i)
          IF l_field.getAttribute("colName") == l_gfk03 THEN
             LET l_grup = l_field.getAttribute("value")
             #畫面值為空值或null時，回傳g_grup
             IF cl_null(l_grup) THEN
                #RETURN g_grup #TQC-C80038
                LET l_rtn_value = g_grup #TQC-C80038:這種狀況一定是新增.
             ELSE
                #RETURN l_field.getAttribute("value") #TQC-C80038
                LET l_rtn_value = l_field.getAttribute("value") #TQC-C80038
             END IF
             EXIT FOR
          END IF
      END FOR
   #Begin : #TQC-C80038
   #END IF
   #RETURN g_grup
   RETURN l_rtn_value
   #End : #TQC-C80038
END FUNCTION

# No.FUN-C20008
# Descriptions...: 依gfk_file設定更新該筆record之資料所有人(owner)及所屬部門(group)欄位
#                  fgk_file有設定時才更新
# Date & Author..: 2012/02/04 by madey
# Input Parameter: p_table_name          表格名稱
#                  p_pk_where            表格pk where條件
# Return Code....: none
# Usage..........: CALL s_upd_owner_group("oea_file","oea01='100-09020008'")

FUNCTION s_upd_owner_group(p_table_name, p_pk_where)   #No.FUN-C20008
   DEFINE p_table_name LIKE gfk_file.gfk01   #資料表名稱
   DEFINE p_pk_where   LIKE type_file.chr300 #資料表條件
   DEFINE l_gfk02      LIKE gfk_file.gfk02   #資料所有者column name
   DEFINE l_gfk03      LIKE gfk_file.gfk03   #資料部門column name
   DEFINE l_owner      LIKE type_file.chr10
   DEFINE l_grup       LIKE type_file.chr20
   DEFINE l_str        LIKE type_file.chr300
   DEFINE l_under_idx  LIKE type_file.num5,
          l_prefix     STRING
   DEFINE l_sql        STRING,
          l_table_name STRING

   SELECT gfk02,gfk03 INTO l_gfk02,l_gfk03 FROM gfk_file WHERE gfk01 = p_table_name
   IF NOT cl_null(l_gfk02) THEN
      LET l_sql = "SELECT ",l_gfk02,",",l_gfk03," FROM ",p_table_name," WHERE ",p_pk_where CLIPPED
      PREPARE gfk1_pre FROM l_sql
      EXECUTE gfk1_pre INTO l_owner,l_grup
      IF NOT cl_null(l_owner) THEN
         LET l_table_name= p_table_name
         LET l_under_idx = l_table_name.getIndexOf("_", 1) #ex. oea_file
         IF l_under_idx > 0 THEN
            LET l_prefix = l_table_name.subString(1,l_under_idx-1) #ex. oea
            LET l_sql = "UPDATE ",l_table_name," SET ",l_prefix,"user = '",l_owner,"',",l_prefix,"grup = '", l_grup,
                        "' WHERE ",p_pk_where CLIPPED
            PREPARE gfk2_pre FROM l_sql
            EXECUTE gfk2_pre
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd",l_table_name,"","",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
            END IF
         END IF
      END IF
   END IF
END FUNCTION
