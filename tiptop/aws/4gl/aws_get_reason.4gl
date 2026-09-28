DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_reason()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_reason_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_reason_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_qce  RECORD 
            qce01 LIKE qce_file.qce01,
            qce03 LIKE qce_file.qce03
                   END RECORD
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_sql2   STRING
    DEFINE l_ta_qce01 LIKE type_file.chr20
    DEFINE l_ta_qce01_t LIKE type_file.chr20
    DEFINE l_n     LIKE type_file.num10

    LET l_ta_qce01_t = aws_ttsrv_getParameter("ta_qce01")   #取由呼叫端呼叫時給予的 SQL Condition
     SELECT LOWER(l_ta_qce01_t) INTO l_ta_qce01 FROM dual

    IF cl_null(l_ta_qce01) THEN 
       LET g_status.code=-1
       LET g_status.description="说明内容简称不能为空！"
       return
    END IF
    LET l_sql2 = "SELECT COUNT(*) FROM qce_file WHERE ta_qce01 LIKE '%",l_ta_qce01,"%'"
               ," OR qce03 LIKE '%",l_ta_qce01,"%'  " #add huxy160329
    PREPARE qce_cus FROM l_sql2
    EXECUTE qce_cus INTO l_n 
    IF cl_null(l_n) THEN LET l_n=0 END IF
    IF l_n=0 THEN
        LET g_status.code=-1
        LET g_status.description="该说明内容简称不存在！"
        RETURN
    END IF
       LET l_sql = " SELECT qce01,qce03",
                   " FROM qce_file ",
                   " WHERE ta_qce01 like '%",l_ta_qce01,"%'",
                " OR qce03 LIKE '%",l_ta_qce01,"%'  ",  #add huxy160329
                   " ORDER BY qce01 "
  
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_qce.*
 
      LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_qce), "Master")   #加入此筆單檔資料至 Response 中
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
