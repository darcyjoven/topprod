# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ttsrv_lib.4gl
# Descriptions...: 處理 TIPTOP 服務的共用 FUNCTION
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
# Description....: 處理服務起始時設定 --- e.x. 預設處理狀態值
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: none
# Return.........: none 
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_initial()
    
    WHENEVER ERROR CONTINUE
 
    
    INITIALIZE g_field TO NULL
    
    LET g_status.code = "0"
    LET g_status.sqlcode = ""
    LET g_status.description = ""
END FUNCTION
 
 
#[
# Description....: 回傳處理狀態 XML
# Date & Author..: 2007/02/07 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_getStatus()
    DEFINE l_status   STRING
 
    
    IF g_status.code != "0" THEN
       #-----------------------------------------------------------------------#
       # 取得錯誤敘述                                                          #
       #-----------------------------------------------------------------------#
       LET g_status.description = cl_getmsg(g_status.code, g_lang)
    END IF
    
    #--------------------------------------------------------------------------#
    # 這裡直接用字串組 <Status> XML, 比較方便   ;-)                            #
    #--------------------------------------------------------------------------#
    LET l_status = "<Status>\n",
                   "  <Result code=\"", g_status.code, "\" sqlcode=\"", g_status.sqlcode, "\" description=\"", g_status.description.trim(), "\" />\n",
                   "</Status>"
    RETURN l_status
END FUNCTION
 
 
#[
# Description....: 檢查傳入欄位長度並將欄位值依 ERP 欄位長度作裁切
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: p_table - STRING - TABLE 名稱
#                : p_column - STRING - 欄位名稱
#                : p_value - STRING - 欄位值
# Return.........: l_value - STRING - 欄位值
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv_checkDataValue(p_table, p_column, p_value)
    DEFINE p_table      STRING,
           p_column     STRING,
           p_value      STRING
    DEFINE l_dataType   STRING,
           l_dataLen    LIKE type_file.num10,
           l_value      STRING
           
    
    IF cl_null(p_table) OR cl_null(p_column) OR cl_null(p_value) THEN
       RETURN NULL
    END IF
    
    #--------------------------------------------------------------------------#
    # 取得欄位型態與長度                                                       #
    #--------------------------------------------------------------------------#
    CALL cl_get_column_info('ds', p_table, p_column)
         RETURNING l_dataType, l_dataLen
    
    LET l_value = p_value CLIPPED
    CASE
        #----------------------------------------------------------------------#
        # 若 ERP 欄位為文字型態, 需檢查欄位值是否超過欄位長度                  #
        #----------------------------------------------------------------------#
        WHEN l_dataType CLIPPED = "varchar2" OR l_dataType CLIPPED = "char"
             IF p_value.getLength() > l_dataLen THEN
                LET l_value = p_value.subString(1, l_dataLen)
             END IF
    END CASE
    
    RETURN l_value
END FUNCTION
