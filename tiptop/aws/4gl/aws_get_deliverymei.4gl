DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_deliverymei()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_deliverymei_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_deliverymei_process()
    DEFINE l_i     LIKE type_file.num10,
           l_sib  RECORD 
             pmc03   LIKE pmc_file.pmc03,
             tc_sib01   LIKE tc_sib_file.tc_sib01,
             tc_sib02   LIKE tc_sib_file.tc_sib02,
             tc_sib03   LIKE tc_sib_file.tc_sib03,
             tc_sib04   LIKE tc_sib_file.tc_sib04,
             ima01      LIKE ima_file.ima01,
             ima02      LIKE ima_file.ima02,
             tc_sib05   LIKE tc_sib_file.tc_sib05,
             tc_sib05a  LIKE tc_sib_file.tc_sib05
                   END RECORD
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_tc_sia01 LIKE tc_sia_file.tc_sia01
    DEFINE l_n,l_nn     LIKE type_file.num10

    LET l_tc_sia01 = aws_ttsrv_getParameter("tc_sia01")   #取由呼叫端呼叫時給予的 SQL Condition


    IF cl_null(l_tc_sia01) THEN 
       LET g_status.code=-1
       LET g_status.description="到货单号不能为空！"
       return
    END IF
    SELECT COUNT(*) INTO l_n FROM tc_sia_file,tc_sib_file WHERE tc_sia01=tc_sib01 
    AND tc_sia01=l_tc_sia01 AND tc_sia08='2'
    IF cl_null(l_n) THEN LET l_n=0 END IF
    IF l_n=0 THEN
        LET g_status.code=-1
        LET g_status.description="到货单不存在或者单据状态不对应"
        RETURN
    END IF

    LET l_sql = " SELECT '',tc_sib01,tc_sib02,tc_sib03,tc_sib04,'','',tc_sib05-tc_sib07,tc_sib05-tc_sib07",
                " FROM tc_sib_file ",
                " WHERE tc_sib01 = '",l_tc_sia01,"'",
                " ORDER BY tc_sib01 "
  
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_sib.*
    SELECT pmn04,pmn041 INTO l_sib.ima01,l_sib.ima02 FROM  pmn_file
    WHERE pmn01 = l_sib.tc_sib03 AND pmn02 = l_sib.tc_sib04
    SELECT pmm09 INTO l_sib.pmc03 FROM pmm_file
    WHERE  pmm01 = l_sib.tc_sib03
    SELECT pmc03 INTO l_sib.pmc03 FROM pmc_file WHERE pmc01=l_sib.pmc03
    IF l_sib.tc_sib05>0 THEN 
      LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_sib), "Master")   #加入此筆單檔資料至 Response 中
    END IF 
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
