# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_counting_label_data.4gl
# Descriptions...: 提供取得 ERP 盤點標籤相關資料
# Date & Author..: 2008/05/19 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP 盤點標籤相關資料(入口 function)
# Date & Author..: 2008/05/19 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_counting_label_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
    #--------------------------------------------------------------------------#
    # 查詢 盤點標籤 資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_counting_label_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 盤點標籤
# Date & Author..: 2008/05/19 by kim (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_counting_label_data_process()
    DEFINE l_pia       RECORD LIKE pia_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode
    DEFINE l_labtype   LIKE pib_file.pib01
    DEFINE l_labstart  LIKE pib_file.pib03
    DEFINE l_labend    LIKE pib_file.pib03
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
    
    LET l_labtype  = aws_ttsrv_getParameter("labtype")   #不可空白
    LET l_labstart = aws_ttsrv_getParameter("labstart")  #可空白
    LET l_labend   = aws_ttsrv_getParameter("labend")    #可空白
 
    LET l_sql = "SELECT * FROM pia_file WHERE ",
                l_wc," AND pia19 ='N'",
                " AND pia01 LIKE '",l_labtype,"%' "
                
    IF NOT cl_null(l_labstart) THEN
       LET l_sql = l_sql , " AND pia01 >= '",
                   l_labtype,"-", l_labstart USING "&&&&&&&&&&" ,"' "
    END IF
    IF NOT cl_null(l_labend) THEN
       LET l_sql = l_sql , " AND pia01 <= '",
                   l_labtype,"-",l_labend USING "&&&&&&&&&&" ,"' "
    END IF
    LET l_sql = l_sql," ORDER BY pia01"
 
    DECLARE pia_curs CURSOR FROM l_sql
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
 
    FOREACH pia_curs INTO l_pia.*
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF  
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_pia), "pia_file")   #加入此筆單檔資料至 Response 中
 
    END FOREACH
    
END FUNCTION
