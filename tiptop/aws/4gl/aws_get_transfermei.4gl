DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_transfermei()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_transfermei_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_transfermei_process()
    DEFINE l_i     LIKE type_file.num10,
           l_imm   RECORD 
             imm01      LIKE imm_file.imm01,
             gem02      LIKE gem_file.gem02,
             gen02      LIKE gen_file.gen02,
             imn02      LIKE imn_file.imn02,
             imn03      LIKE imn_file.imn03,
             ima02      LIKE ima_file.ima02,
             imn10      LIKE imn_file.imn10,
             imn10a     LIKE imn_file.imn10
                   END RECORD
    DEFINE l_node  om.DomNode
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_imm01 LIKE imm_file.imm01
    DEFINE l_n,l_nn     LIKE type_file.num10

    LET l_imm01 = aws_ttsrv_getParameter("imm01")   #取由呼叫端呼叫時給予的 SQL Condition


    IF cl_null(l_imm01) THEN 
       LET g_status.code=-1
       LET g_status.description="调拨单号不能为空!"
       RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM imm_file WHERE imm01=l_imm01 
    AND immconf='Y' AND imm03='N'
    IF cl_null(l_n) THEN LET l_n=0 END IF
    IF l_n=0 THEN
        LET g_status.code=-1
        LET g_status.description="调拨单不存在或者单据状态不对应"
        RETURN
    END IF

    LET l_sql = " SELECT imm01,gem02,gen02,imn02,imn03,ima02,imn10,imn10",
                " FROM imm_file",
                " INNER JOIN imn_file on imm01=imn01",
                " LEFT JOIN  gem_file on imm14=gem01",
                " LEFT JOIN  gen_file on imm16=gen01",
                " LEFT JOIN  ima_file on imn03=ima01",
                #" WHERE imm01=",l_imm01 CLIPPED,
                " WHERE imm01 = '",l_imm01,"'",
                " ORDER BY imm01,imn02"
  
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_imm.*

      LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_imm), "Master")   #加入此筆單檔資料至 Response 中

    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
