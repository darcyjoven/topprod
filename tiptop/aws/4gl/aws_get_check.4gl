#MOD huxy160416 增加料号筛选条件

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_check()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_check_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_check_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_n     LIKE type_file.num10
    DEFINE l_qct RECORD 
           qct01  LIKE qct_file.qct01,      #收货单号
           qct02  LIKE qct_file.qct02,      #项次
           qct021 LIKE qct_file.qct021,     #顺序
           qct03  LIKE qct_file.qct03,      #行序
           qcs021 LIKE qcs_file.qcs021,     #料件编码
           ima02  LIKE ima_file.ima01,      #品名    
           qct04  LIKE qct_file.qct04,      #检验项目
           azf03  LIKE azf_file.azf03,      #项目说明
           qct11  LIKE qct_file.qct11,      #抽样数量
           qct09  LIKE qct_file.qct09,      #AC
           qct10  LIKE qct_file.qct10,      #AC
           qct07  LIKE type_file.num5       #不良数
           END RECORD
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_sql2   STRING
    DEFINE l_ibb RECORD 
               ibb01 LIKE ibb_file.ibb01,
               ibb06 LIKE ibb_file.ibb06, #add huxy160416
               ibb03 LIKE ibb_file.ibb03
                END RECORD
    DEFINE l_rva RECORD
               rvaacti LIKE rva_file.rvaacti
                 END RECORD
    DEFINE l_qcs  RECORD
               qcs14 LIKE qcs_file.qcs14
                 END RECORD 
    LET l_ibb.ibb01 = aws_ttsrv_getParameter("ibb01")   #取由呼叫端呼叫時給予的 SQL Condition


     IF cl_null(l_ibb.ibb01) THEN 
       LET g_status.code=-1
       LET g_status.description="条码编号不能为空！"
     END IF
   SELECT COUNT(*) INTO l_i FROM ibb_file WHERE ibb01=l_ibb.ibb01 
     IF cl_null(l_i) THEN LET l_i=0 END IF
     IF l_i=0 THEN
        LET g_status.code=-1
        LET g_status.description="条码编号不存在！"
        RETURN
     END IF

   #SELECT ibb03 INTO l_ibb.ibb03 FROM ibb_file WHERE ibb01 = l_ibb.ibb01                    #mark huxy160416    
    SELECT ibb03,ibb06 INTO l_ibb.ibb03,l_ibb.ibb06 FROM ibb_file WHERE ibb01 = l_ibb.ibb01  #add  huxy160416      
       LET l_sql = " SELECT qct01,qct02,qct021,qct03,qcs021,'',qct04,'',qct11,qct09,qct10,qct07",
                   " FROM  qct_file,qcs_file",
                   " WHERE qct01 = '",l_ibb.ibb03,"'",
                   " AND qcs01 = qct01 AND qcs14 = 'N'",
                   " AND qcs02 = qct02 AND qcs05 = qct021",
                   " AND qcs021 = '",l_ibb.ibb06,"'",  #add huxy160416
                   " ORDER BY qct01 "

    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
FOREACH occ_cur INTO l_qct.*
   SELECT count(*) INTO l_n FROM qcs_file WHERE qcs14 = 'N'
       IF l_n = 0 THEN 
       LET g_status.code=-1
       LET g_status.description="QC单已全部审核！"
       RETURN 
       END IF
    SELECT rvaacti INTO l_rva.rvaacti FROM rva_file
    IF l_rva.rvaacti = 'N' THEN
       LET g_status.code=-1
       LET g_status.description="此收货单号未审核！"
       RETURN
    END IF
#   SELECT qcs021 INTO l_qct.qcs021 FROM qcs_file WHERE qcs01 = l_qct.qct01 
#   AND qcs02 = l_qct.qct02 #add huxy160418
   SELECT ima02  INTO l_qct.ima02 FROM  ima_file,ibb_file WHERE ima01 = ibb06 AND ibb01 = l_ibb.ibb01 
   SELECT azf03 INTO l_qct.azf03 FROM azf_file WHERE azf02 = '6' AND azf01 = l_qct.qct04
      LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_qct), "Master")   #加入此筆單檔資料至 Response 中
END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
