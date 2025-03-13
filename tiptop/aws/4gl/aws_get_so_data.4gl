# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#{
# Program name...: aws_get_so_data.4gl
# Descriptions...: 提供取得訂單資料服務
# Date & Author..: 2011/09/22 By Abby
# Memo...........: 新建立：FUN-B90089
# Modify.........:
#
#}
 
DATABASE ds
 
#FUN-B90089 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得訂單資料服務(入口 function)
# Date & Author..: 2011/09/22 By Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_so_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 訂貨資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_so_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 訂單
# Date & Author..: 2011/09/22 By Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_so_data_process()
    DEFINE l_oea       DYNAMIC ARRAY OF RECORD LIKE oea_file.*
    DEFINE l_oeb       DYNAMIC ARRAY OF RECORD LIKE oeb_file.*
    DEFINE l_oea_t     DYNAMIC ARRAY OF RECORD LIKE oea_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_curs      STRING
    DEFINE l_flag      STRING
    DEFINE l_i         LIKE type_file.num10   #FOR oeb陣列
    DEFINE l_ii        LIKE type_file.num10   #FOR oea陣列
    DEFINE l_j         LIKE type_file.num10   #FOR迴圈變數
    DEFINE l_node      om.DomNode
    DEFINE l_rownum    LIKE type_file.num10
    DEFINE l_str       STRING
    DEFINE l_end       STRING
 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_str = aws_ttsrv_getParameter("start")      #取由呼叫端呼叫時給予的 SQL Condition
    LET l_end = aws_ttsrv_getParameter("end")        #取由呼叫端呼叫時給予的 SQL Condition

    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF

    IF NOT cl_null(l_str) AND NOT cl_null(l_end) THEN
      #指定搜尋範圍,資料筆數的限制
       LET l_sql = "SELECT * ",
                   "  FROM (SELECT ROWNUM num,a.* ",
                   "          FROM ( SELECT oea_file.* ",
                   "                   FROM oea_file ",
                   "             LEFT OUTER JOIN oeb_file ON oea01 = oeb01 ",
                   "                  WHERE ",l_wc,") a ) ",
                   " WHERE num BETWEEN ",l_str CLIPPED," AND ",l_end CLIPPED
    ELSE
       LET l_sql = "SELECT ROWNUM,oea_file.* FROM oea_file LEFT OUTER JOIN oeb_file ON oea01 = oeb01 WHERE ",
                   l_wc
    END IF
                 
    DECLARE oea_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  

    IF NOT cl_null(l_str) AND NOT cl_null(l_end) THEN  
      #指定搜尋範圍,資料筆數的限制
       LET l_sql = "SELECT * ",
                   "  FROM (SELECT ROWNUM num,a.* ",
                   "          FROM ( SELECT oeb_file.* ",
                   "                   FROM oeb_file ",
                   "             LEFT OUTER JOIN oea_file ON oea01 = oeb01 ",
                   "                  WHERE ",l_wc,") a ) ",
                   " WHERE num BETWEEN ",l_str CLIPPED," AND ",l_end CLIPPED
       LET l_curs = '1'
    ELSE
       LET l_sql = "SELECT ROWNUM,oeb_file.* FROM oeb_file LEFT OUTER JOIN oea_file ON oeb01 = oea01 WHERE oeb01 = ? ", 
                   "AND ",l_wc
       LET l_curs = '2'
    END IF

    IF l_curs = '1' THEN
      #指定搜尋範圍,資料筆數的限制
       DECLARE oeb_curs1 CURSOR FROM l_sql
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF
    ELSE
       DECLARE oeb_curs2 CURSOR FROM l_sql
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF
    END IF

    LET l_flag = 'Y'
    LET l_ii = 1
    CALL l_oea.clear()

    FOREACH oea_curs INTO l_rownum,l_oea[l_ii].*
      #避免單頭資料重複寫入顯示到Response中
       FOR l_j = 1 TO (l_ii - 1)
          IF l_oea[l_j].oea01 <> l_oea[l_ii].oea01 THEN  #若先前已有相同單頭資料record則不寫入
             LET l_flag = 'Y'
          ELSE
             LET l_flag = 'N'
             EXIT FOR
          END IF
       END FOR

       CALL l_oeb.clear()
       LET l_i = 1
       IF l_curs = '1' THEN
          LET l_oea_t[l_ii].oea01 = l_oea[l_ii].oea01
          FOREACH oeb_curs1 INTO l_rownum,l_oeb[l_i].*
            #依單頭資訊帶入所有單身資料於l_oeb陣列中，若不判斷則其他單頭資訊的單身資料也會一併寫入
             IF l_oea_t[l_ii].oea01 <> l_oeb[l_i].oeb01 THEN
                CALL l_oeb.deleteElement(l_i)
                LET l_i = l_i - 1
             END IF
             LET l_i = l_i + 1
          END FOREACH
       ELSE
          FOREACH oeb_curs2 USING l_oea[l_ii].oea01 INTO l_rownum,l_oeb[l_i].*
             LET l_i = l_i + 1
          END FOREACH
       END IF
       CALL l_oeb.deleteElement(l_i)

       IF l_flag = 'Y' THEN  #無此筆單頭資料才寫入
          IF l_oeb.getlength() > 0 THEN  #避免帶出有單頭,無單身的資料
             LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_oea[l_ii]), "oea_file")   #加入此筆單頭資料至 Response 中
             CALL aws_ttsrv_addDetailRecord(l_node, base.TypeInfo.create(l_oeb), "oeb_file")         #加入此筆單頭的單身資料至 Response 中
             LET l_flag = 'N'
          END IF
       END IF
       LET l_ii = l_ii + 1
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
END FUNCTION
