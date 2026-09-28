# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_transferdata_detail.4gl
# Descriptions...: 获取调拨单单身信息
# Date & Author..: 17/06/14 By nihuan
# Memo...........:
# Modify.........:
#
#}

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_transferdata_detail()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_transferdata_detail_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_transferdata_detail_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_node  om.DomNode
    DEFINE l_imm01 LIKE tc_imm_file.tc_imm01
    DEFINE l_sql   STRING
    DEFINE l_pagesize,l_pageno       LIKE type_file.num5
    DEFINE l_n,l_nn     LIKE type_file.num10
    DEFINE l_return      RECORD 
               tc_imp03      LIKE  tc_imp_file.tc_imp03,           #工单号
               tc_imp04      LIKE  tc_imp_file.tc_imp04,           #作业编号
               tc_imp05      LIKE  tc_imp_file.tc_imp05,           #发料料号
               ima02         LIKE  ima_file.ima02,                 #料号
               ima021        LIKE  ima_file.ima021,                #规格
               tc_imp10      LIKE  tc_imp_file.tc_imp10,           #单位
               tc_imp08      LIKE  tc_imp_file.tc_imp08            #申请量
                       END RECORD 
    
    LET l_imm01 = aws_ttsrv_getParameter("imm01")   #
    LET l_pageno = aws_ttsrv_getParameter("pageno")
    LET l_pagesize = aws_ttsrv_getParameter("pagesize")
    
    IF cl_null(l_pagesize) THEN LET l_pagesize=50 END IF 
    IF cl_null(l_pageno) THEN LET l_pageno=1 END IF 
    	

    SELECT COUNT(*) INTO l_n FROM tc_imp_file WHERE tc_imp01=l_imm01 
    IF cl_null(l_n) THEN LET l_n=0 END IF
    IF l_n=0 THEN
        LET g_status.code=-1
        LET g_status.description="调拨单不存在,请检查！"
        RETURN
    END IF

    LET l_sql = "select tc_imp03,tc_imp04,tc_imp05,ima02,ima021,tc_imp10,tc_imp08 
                 from tc_imp_file
                 left join ima_file on ima01=tc_imp05
                 where tc_imp01='",l_imm01,"'"
                
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_return.*

      LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")   #加入此筆單檔資料至 Response 中

    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    	
    	
    	
END FUNCTION
