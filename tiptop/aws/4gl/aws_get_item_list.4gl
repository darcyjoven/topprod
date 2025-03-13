# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_item_list.4gl
# Descriptions...: 提供取得 ERP 料件編號列表服務
# Date & Author..: 2007/02/14 by Echo
# Memo...........:
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-860037 08/06/20 By Kevin 升級到aws_ttsrv2
# Modify.........: No.FUN-B90089 12/08/27 By Abby 加上取得 ERP 限定範圍程式段
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 料件編號列表服務(入口 function)
# Date & Author..: 2007/02/14 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_item_list()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037 
 
    #--------------------------------------------------------------------------#
    # 查詢 ERP 料件編號                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_item_list_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 料件編號
# Date & Author..: 2007/02/06 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........: No.FUN-B90089 12/08/27 By Abby 加上取得 ERP 限定範圍程式段
#
#]
FUNCTION aws_get_item_list_process()
    DEFINE l_i     LIKE type_file.num10,
           l_ima   RECORD 
                      ima01   LIKE ima_file.ima01,
                      ima02   LIKE ima_file.ima02
                   END RECORD
    DEFINE l_node  om.DomNode
   #FUN-B90089 add str---
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING

    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_str = aws_ttsrv_getParameter("start")  #取由呼叫端呼叫時給予的 SQL Condition
    LET l_end = aws_ttsrv_getParameter("end")    #取由呼叫端呼叫時給予的 SQL Condition

    IF cl_null(l_wc) THEN LET l_wc = ' 1=1' END IF

    IF NOT cl_null(l_str) AND NOT cl_null(l_end) THEN
       LET l_sql = "SELECT ROWNUM,a.ima01,a.ima02 ",
                   "  FROM (SELECT ima_file.* ",
                   "          FROM ima_file ",
                   "         WHERE imaacti = 'Y' ",
                   "           AND ",l_wc,
                   "         ORDER BY ima01) a ",
                   " WHERE ROWNUM < ",l_end CLIPPED,"+1",
                   " MINUS ",
                   "SELECT ROWNUM,a.ima01,a.ima02 ",
                   "  FROM (SELECT ima_file.* ",
                   "          FROM ima_file ",
                   "         WHERE imaacti = 'Y' ",
                   "           AND ",l_wc,
                   "         ORDER BY ima01) a ",
                   " WHERE ROWNUM < ",l_str CLIPPED
    ELSE
       LET l_sql = "SELECT ROWNUM, ima01, ima02 ",
                   "  FROM ima_file ",
                   " WHERE imaacti = 'Y' ",
                   " ORDER BY ima01 "
    END IF
   #FUN-B90089 add end---

   #FUN-B90089 mod str---
   #DECLARE ima_cur CURSOR FOR
   #     SELECT ima01, ima02 FROM ima_file WHERE imaacti = 'Y' ORDER BY ima01
    DECLARE ima_cur CURSOR FROM l_sql
   #FUN-B90089 mod end---    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF    

   #FOREACH ima_cur INTO l_ima.*           #FUN-B90089 mark
    FOREACH ima_cur INTO l_rownum,l_ima.*  #FUN-B90089 add    
    	  IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           RETURN
        END IF        
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_ima), "ima_file")   #加入此筆單檔資料至 Response 中
    END FOREACH    
        
END FUNCTION
