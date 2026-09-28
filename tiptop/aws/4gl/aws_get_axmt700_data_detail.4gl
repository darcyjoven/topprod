# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_axmt700_data_detail.4gl
# Descriptions...: 获取销退单单身信息
# Date & Author..: 17/06/14 By nihuan
# Memo...........:
# Modify.........:
#
#}

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_axmt700_data_detail()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_axmt700_data_detail_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_axmt700_data_detail_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_node  om.DomNode
    DEFINE l_oha01 LIKE oha_file.oha01
    DEFINE l_sql   STRING
    DEFINE l_pagesize,l_pageno       LIKE type_file.num5
    DEFINE l_n,l_nn     LIKE type_file.num10
    DEFINE l_return      RECORD 
               ohb04         LIKE  ohb_file.ohb04,                 #料号
               ima02         LIKE  ima_file.ima02,                 #品名
               ima021        LIKE  ima_file.ima021,                #规格
               ohb05         LIKE  ohb_file.ohb05,                 #单位
               ohb12         LIKE  ohb_file.ohb12                  #申请量
                       END RECORD 
    
    LET l_oha01 = aws_ttsrv_getParameter("oha01")   #
    LET l_pageno = aws_ttsrv_getParameter("pageno")
    LET l_pagesize = aws_ttsrv_getParameter("pagesize")
    
    IF cl_null(l_pagesize) THEN LET l_pagesize=10 END IF 
    IF cl_null(l_pageno) THEN LET l_pageno=1 END IF 
    	

    SELECT COUNT(*) INTO l_n FROM oha_file 
    WHERE oha01=l_oha01 AND ohaconf='Y' AND ohapost!='Y'
    IF cl_null(l_n) THEN LET l_n=0 END IF
    IF l_n=0 THEN
        LET g_status.code=-1
        LET g_status.description="销退单不存在或未审核或已过帐,请检查！"
        RETURN
    END IF

    LET l_sql = "select ohb04,ima02,ima021,ohb05,sum(ohb12) from ohb_file
                 left join ima_file on ima01=ohb04
                 where ohb01='",l_oha01,"'
                 group by ohb04,ima02,ima021,ohb05"
                
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
