# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv_lib_sql.4gl
# Descriptions...: 處理 TIPTOP 服務 SQL 的共用 FUNCTION
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
 
#[
# Description....: 依 g_field 包含的欄位及欄位值, 組合出 INSERT SQL
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_table - STRING - TABLE 名稱
# Return.........: l_sql   - STRING - INSERT SQL 語法
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getInsertSql(p_table)
    DEFINE p_table   STRING
    DEFINE l_sql     STRING,
           l_i       LIKE type_file.num10,
           l_str     STRING,
           l_col     base.StringBuffer,
           l_val     base.StringBuffer,
           l_path    STRING,
           l_list    om.NodeList,
           l_node    om.DomNode,
           l_name    STRING,
           l_value   STRING
 
    
    WHENEVER ERROR CONTINUE
    
    IF cl_null(p_table) OR g_field IS NULL THEN
       RETURN NULL
    END IF
    
    #--------------------------------------------------------------------------#
    # 利用 StringBuffer 組合長字串時效率會比字串直接附加好                     #
    #--------------------------------------------------------------------------#
    LET l_col = base.StringBuffer.create()
    LET l_val = base.StringBuffer.create()
    CALL l_col.append("")
    CALL l_val.append("")
    
    #--------------------------------------------------------------------------#
    # 依 g_field 建立的欄位名稱及欄位值, 建立 SQL 欄位及欄位值字串             #
    #--------------------------------------------------------------------------#
    LET l_path = "//Table[@name=\"", p_table CLIPPED, "\"]/Column"
    LET l_list = g_field.selectByPath(l_path)
    FOR l_i = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_i)
        
        IF l_i != 1 THEN
           CALL l_col.append(", ")
           CALL l_val.append(", ")
        END IF
        
        LET l_name = l_node.getAttribute("name")
        LET l_value = l_node.getAttribute("value")
        IF cl_null(l_value) THEN   # 若未有值, 則再取預設值
           LET l_value = l_node.getAttribute("default")
        END IF
        
        CALL l_col.append(l_name CLIPPED)
        LET l_str = "'", l_value CLIPPED, "'"
        CALL l_val.append(l_str)
    END FOR
    
    LET l_sql = "INSERT INTO ", p_table, " (", l_col.toString(), ") VALUES (", l_val.toString(), ")"
    RETURN l_sql
END FUNCTION
 
 
#[
# Description....: 依 g_field 包含的欄位及欄位值, 組合出 UPDATE SQL
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_table - STRING - TABLE 名稱
#                : p_key1  - STRING - Key1 欄位名稱
#                : p_key2  - STRING - Key2 欄位名稱
#                : p_key3  - STRING - Key3 欄位名稱
#                : p_key4  - STRING - Key4 欄位名稱
#                : p_key5  - STRING - Key5 欄位名稱
# Return.........: l_sql   - STRING - UPDATE SQL 語法
# Memo...........: 目前預設最多五組 Key 值欄位
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getUpdateSql(p_table, p_key1, p_key2, p_key3, p_key4, p_key5)
    DEFINE p_table   STRING,
           p_key1    STRING,
           p_key2    STRING,
           p_key3    STRING,
           p_key4    STRING,
           p_key5    STRING
    DEFINE l_where   STRING,
           l_sql     STRING,
           l_i       LIKE type_file.num10,
           l_str     STRING,
           l_col     base.StringBuffer,
           l_list    om.nodelist,
           l_node    om.DomNode,
           l_path    STRING,
           l_name    STRING,
           l_value   STRING
  
    
    IF cl_null(p_table) OR cl_null(p_key1) OR g_field IS NULL THEN
       RETURN NULL
    END IF
    
    #--------------------------------------------------------------------------#
    # 利用 StringBuffer 組合長字串時效率會比字串直接附加好                     #
    #--------------------------------------------------------------------------#
    LET l_col = base.StringBuffer.create()
    CALL l_col.append("")
 
    #--------------------------------------------------------------------------#
    # 依 g_field 建立的欄位名稱及欄位值, 建立 SQL 欄位及欄位值字串             #
    #--------------------------------------------------------------------------#
    LET l_path = "//Table[@name=\"", p_table CLIPPED, "\"]/Column[@parsed=\"1\"]"
    LET l_list = g_field.selectByPath(l_path)    
    FOR l_i = 1 TO l_list.getLength()
        LET l_node = l_list.item(l_i)
    
        IF l_i != 1 THEN
           CALL l_col.append(", ")
        END IF
 
        LET l_name = l_node.getAttribute("name")
        LET l_value = l_node.getAttribute("value")
        
        LET l_str = l_name CLIPPED," = '", l_value CLIPPED, "'"
        CALL l_col.append(l_str)
    END FOR
    
    #--------------------------------------------------------------------------#
    # 組 WHERE 條件字串,目前 key 為 5 組                                       #
    #--------------------------------------------------------------------------#
    IF NOT cl_null(p_key1) THEN
       LET l_value = aws_ttsrv_getServiceColumnValue(p_table, p_key1)
       LET l_where = p_key1, " = '", l_value, "'"
    ELSE
       LET l_where = "1=1"
    END IF
    IF NOT cl_null(p_key2) THEN
       LET l_value = aws_ttsrv_getServiceColumnValue(p_table, p_key2)
       LET l_where = l_where, " AND ", p_key2, " = '", l_value, "'"
    END IF
    IF NOT cl_null(p_key3) THEN
       LET l_value = aws_ttsrv_getServiceColumnValue(p_table, p_key3)
       LET l_where = l_where, " AND ", p_key3, " = '", l_value, "'"
    END IF
    IF NOT cl_null(p_key4) THEN
       LET l_value = aws_ttsrv_getServiceColumnValue(p_table, p_key4)
       LET l_where = l_where, " AND ", p_key4, " = '", l_value, "'"
    END IF
    IF NOT cl_null(p_key5) THEN
       LET l_value = aws_ttsrv_getServiceColumnValue(p_table, p_key5)
       LET l_where = l_where, " AND ", p_key5, " = '", l_value, "'"
    END IF
    LET l_sql = "UPDATE ", p_table, " SET ", l_col.toString(),
                " WHERE ",l_where
                
    RETURN l_sql
END FUNCTION
