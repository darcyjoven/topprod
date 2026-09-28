# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_axmt700_data.4gl
# Descriptions...: 获取销退单信息
# Date & Author..: 17/06/15 By nihuan
# Memo...........:
# Modify.........:
#
#}

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_axmt700_data()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_axmt700_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_axmt700_data_process()
    DEFINE l_i     LIKE type_file.num10,
           l_return    RECORD 
             oha01      LIKE oha_file.oha01,         #销退单号
             oha02      LIKE oha_file.oha02,         #日期
             oha14      LIKE oha_file.oha14,         #人员编号
             gen02      LIKE gen_file.gen02,         #人员名称
             oha15      LIKE oha_file.oha15,         #部门编号
             gem02      LIKE gem_file.gem02,         #部门名称
             oha03      LIKE oha_file.oha03,         #客户编号
             oha032     LIKE oha_file.oha032         #客户名称
                   END RECORD
    DEFINE l_node  om.DomNode
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_oha02 LIKE oha_file.oha02
    DEFINE l_oha03 LIKE oha_file.oha03
    DEFINE l_oha14 LIKE oha_file.oha14
    DEFINE l_oha15 LIKE oha_file.oha15
    DEFINE l_pagesize,l_pageno       LIKE type_file.num5
    DEFINE l_n,l_nn     LIKE type_file.num10

    LET l_oha02 = aws_ttsrv_getParameter("oha02")   
    LET l_oha03 = aws_ttsrv_getParameter("oha03")
    LET l_oha14 = aws_ttsrv_getParameter("oha14")
    LET l_oha15 = aws_ttsrv_getParameter("oha15")
    LET l_pageno = aws_ttsrv_getParameter("pageno")
    LET l_pagesize = aws_ttsrv_getParameter("pagesize")
    
    IF cl_null(l_pagesize) THEN LET l_pagesize=50 END IF 
    IF cl_null(l_pageno) THEN LET l_pageno=1 END IF 
    	

#    SELECT COUNT(*) INTO l_n FROM imm_file WHERE imm01=l_imm01 
#    AND immconf='Y' AND imm03='N'
#    IF cl_null(l_n) THEN LET l_n=0 END IF
#    IF l_n=0 THEN
#        LET g_status.code=-1
#        LET g_status.description="调拨单不存在或者单据状态不对应"
#        RETURN
#    END IF

    LET l_sql = "select oha01,oha02,oha14,gen02,oha15,gem02,oha03,oha032 from (
                 select rownum item,a.* from (",
                " select oha01,oha02,oha14,gen02,oha15,gem02,oha03,oha032 from oha_file 
                  left join gen_file on gen01=oha14
                  left join gem_file on gem01=oha15
                  where ohaconf='Y' and ohapost!='Y' "
                
    IF NOT cl_null(l_oha02) THEN 
    	LET l_sql=l_sql," and oha02='",l_oha02,"'"  
    END IF 	
    IF NOT cl_null(l_oha03) THEN 
    	LET l_sql=l_sql," and oha03='",l_oha03,"'"  
    END IF 
    IF NOT cl_null(l_oha14) THEN 
    	LET l_sql=l_sql," and oha14='",l_oha14,"'"  
    END IF
    IF NOT cl_null(l_oha15) THEN 
    	LET l_sql=l_sql," and oha15='",l_oha15,"'"  
    END IF 	 		          
    
    LET l_sql=l_sql," ORDER BY oha02 desc) a)
                where item>0 and item<='",l_pagesize,"'"
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
