DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_allot_again()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_allot_again_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

       
FUNCTION aws_get_allot_again_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_imm  RECORD 
			imm02 LIKE imm_file.imm02 ,       # 调拨日期,
			imm01 LIKE imm_file.imm01 ,       # 调拨单号,
			imn02 LIKE imn_file.imn02 ,       # ,
			imm14 LIKE imm_file.imm14 ,       # 申请部门,
			imm16 LIKE imm_file.imm16 ,       # 申请人,
			imn04 LIKE imn_file.imn04 ,       # 拨出仓,
			imn15 LIKE imn_file.imn15 ,       # 拨入仓,
			imn03 LIKE imn_file.imn03 ,       # 料号,
			imnud07 LIKE imn_file.imnud07 ,   # 数量,
			imn10 LIKE imn_file.imn10 ,       # 数量,
			ima02 LIKE ima_file.ima02,        # 品名
			ima021 LIKE ima_file.ima021       # 
                   END RECORD
    DEFINE l_node  om.DomNode

    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_n     LIKE type_file.num10 

   LET l_sql = "SELECT ",
               "       imm02,",       
               "       imm01,",       
               "       imn02,",       
               "       imm14,",       
               "       imm16,",       
               "       imn04,",       
               "       imn15,",       
               "       imn03,",       
               "       imnud07,",       
               "       imn10,",       
               "       ima02,",       
               "       ima021",       
               "    FROM IMN_FILE ",
               " INNER JOIN IMM_FILE ON IMM01 = IMN01  ",
               " INNER JOIN IMA_FILE ON IMA01 = IMN03  ",
               " WHERE IMM03 = 'N' ",
               "   AND IMMCONF = 'Y'",
               "   AND imnud06 = 'Y' ",
               " ORDER BY IMM01, IMN02 " 
 
    PREPARE prep_aaaaaa FROM l_sql 
    DECLARE decl_aaaaaa CURSOR FOR prep_aaaaaa
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
     FOREACH decl_aaaaaa INTO l_imm.*

         LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_imm), "Master")   #加入此筆單檔資料至 Response 中
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
