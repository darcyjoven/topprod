# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_customer_acc_amt_data.4gl 
# Descriptions...: 取得客戶應收帳款資料服務
# Date & Author..: 2011/08/26 by Abby
# Memo...........:
# Modify.........: 新建立  #FUN-B80168
# Modify.........: FUN-B90089 12/08/27 By Abby 調整過濾條件順序,並加上取得 ERP 限定範圍程式段
#
#}
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔 
 
#[
# Description....: 取得客戶應收帳款資料服務
# Date & Author..: 2011/08/26 By Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........: 新建立 #FUN-B80168
#]
FUNCTION aws_get_customer_acc_amt_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 
    
    #--------------------------------------------------------------------------#
    # 查詢客戶應收帳款資料                                                     #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_customer_acc_amt_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序   
END FUNCTION
 
 
#[
# Description....: 查詢客戶應收帳款資料
# Date & Author..: 2011/08/26 By Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........: 新建立 #FUN-B80168
# Modify.........: FUN-B90089 12/08/27 By Abby
#]
FUNCTION aws_get_customer_acc_amt_data_process()
    DEFINE l_oma       RECORD LIKE oma_file.*
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING 
   #FUN-B90089 add str---
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_str   STRING
    DEFINE l_end   STRING

    LET l_str = aws_ttsrv_getParameter("start")  #取由呼叫端呼叫時給予的 SQL Condition
    LET l_end = aws_ttsrv_getParameter("end")    #取由呼叫端呼叫時給予的 SQL Condition
   #FUN-B90089 add end---
    
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    #空白值表示讀取全部資料
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1"
    END IF

   #FUN-B90089 mod str---
   #LET l_sql = "SELECT * FROM oma_file ",
   #            " WHERE ",l_wc,
   #            " AND omaconf = 'Y' ",
   #            " AND omavoid = 'N' ",
   #            " AND oma00 IN ('11','12','13','14') "  #帳款類別屬於11/12/13/14
    IF NOT cl_null(l_str) AND NOT cl_null(l_end) THEN
      #指定搜尋範圍,資料筆數的限制
       LET l_sql = "SELECT * ",
            "  FROM (SELECT ROWNUM num,a.* ",
            "          FROM (SELECT * ",
            "                  FROM oma_file ",
            "                 WHERE omaconf = 'Y' ",
            "                   AND omavoid = 'N' ",
            "                   AND oma00 IN ('11','12','13','14') ",  #帳款類別屬於11/12/13/14
            "                   AND ",l_wc,") a) ",
            " WHERE num BETWEEN ",l_str CLIPPED," AND ",l_end CLIPPED
    ELSE
       LET l_sql = "SELECT ROWNUM,oma_file.* FROM oma_file ",
                   " WHERE omaconf = 'Y' ",
                   "   AND omavoid = 'N' ",
                   "   AND oma00 IN ('11','12','13','14') ",  #帳款類別屬於11/12/13/14
                   "   AND ",l_wc
    END IF
   #FUN-B90089 mod end---
 
    DECLARE oma_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
 
   #FOREACH oma_curs INTO l_oma.*           #FUN-B90089 mark
    FOREACH oma_curs INTO l_rownum,l_oma.*  #FUN-B90089 add        
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_oma), "oma_file")   #加入此筆單檔資料至 Response 中 

    END FOREACH
 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
