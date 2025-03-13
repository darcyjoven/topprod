# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_prod_routing_data.4gl
# Descriptions...: 提供取得 ERP 產品製程相關資料
# Date & Author..: 2010/02/06 by Lilan (FUN-A20026)
# Memo...........:
# Modify.........: No.FUN-A20026 11/06/20 By Abby GP5.1追版至GP5.25
#
#}

DATABASE ds



GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           

#[
# Description....: 提供取得 ERP 產品製程相關資料(入口 function)
# Date & Author..: 2010/02/06 by Lilan  (FUN-A20026)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_prod_routing_data()


    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 產品製程 資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_prod_routing_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 查詢 ERP 產品製程
# Date & Author..: 2010/02/06 by Lilan (FUN-A20026)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_prod_routing_data_process()
    DEFINE l_ecu       RECORD LIKE ecu_file.*
    DEFINE l_ecb       DYNAMIC ARRAY OF RECORD LIKE ecb_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode


    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition

    IF cl_null(l_wc) THEN 
       LET l_wc=" 1=1" 
    END IF

    LET l_sql = "SELECT * FROM ecu_file WHERE ",
                l_wc,
                " ORDER BY ecu01"
                 
    DECLARE ecu_curs CURSOR FROM l_sql
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  

    LET l_sql = "SELECT * FROM ecb_file WHERE ecb01 = ? ",
                " ORDER BY ecb02,ecb03"
    DECLARE ecb_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
   
    FOREACH ecu_curs INTO l_ecu.*
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF  
      
       CALL l_ecb.clear()
       LET l_i = 1
       FOREACH ecb_curs USING l_ecu.ecu01 INTO l_ecb[l_i].*
          LET l_i = l_i + 1
       END FOREACH
       CALL l_ecb.deleteElement(l_i)

       IF l_ecb.getlength()>0 THEN  #避免帶出有單頭,無單身的資料
          LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_ecu), "ecu_file")   #加入此筆單頭資料至 Respo_receiving_innse 中
          CALL aws_ttsrv_addDetailRecord(l_node, base.TypeInfo.create(l_ecb), "ecb_file")   #加入此筆單頭的單身資料至 Respo_receiving_innse 中
       END IF
    END FOREACH
    
END FUNCTION
