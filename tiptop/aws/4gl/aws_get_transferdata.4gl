# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_transferdata.4gl
# Descriptions...: 获取调拨单信息
# Date & Author..: 17/05/08 By nihuan
# Memo...........:
# Modify.........:
#
#}

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_transferdata()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_transferdata_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_transferdata_process()
    DEFINE l_i     LIKE type_file.num10,
           l_imm   RECORD 
             imm01      LIKE imm_file.imm01,
             gem02      LIKE gem_file.gem02,
             gen02      LIKE gen_file.gen02,
             imm02      LIKE imm_file.imm02,
             imn04      LIKE imn_file.imn04,
             imn15      LIKE imn_file.imn15
                   END RECORD
    DEFINE l_node  om.DomNode
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_imm16 LIKE imm_file.imm16
    DEFINE l_imm02 LIKE imm_file.imm02
    DEFINE l_imm14 LIKE imm_file.imm14
    DEFINE l_pagesize,l_pageno       LIKE type_file.num5
    DEFINE l_n,l_nn     LIKE type_file.num10

    LET l_imm16 = aws_ttsrv_getParameter("imm16")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_imm02 = aws_ttsrv_getParameter("imm02")
    LET l_imm14 = aws_ttsrv_getParameter("imm14")
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

    LET l_sql = "select tc_imm01,gem02,gen02,tc_imm02,tc_imp04,tc_imp06 from (
                 select rownum item,a.* from (",
                " SELECT tc_imm01,gem02,gen02,tc_imm02,tc_imp04,tc_imp06",
                " FROM tc_imm_file",
                " INNER JOIN tc_imp_file on tc_imm01=tc_imp01",
                " LEFT JOIN  gem_file on tc_imm14=gem01",
                " LEFT JOIN  gen_file on tc_imm16=gen01",
                " where 1=1 and tc_immconf='Y' and tc_imm03!='Y' "
                
    IF NOT cl_null(l_imm02) THEN 
    	LET l_sql=l_sql," and tc_imm02='",l_imm02,"'"  
    END IF 	
    IF NOT cl_null(l_imm14) THEN 
    	LET l_sql=l_sql," and tc_imm14='",l_imm14,"'"  
    END IF 
    IF NOT cl_null(l_imm16) THEN 
    	LET l_sql=l_sql," and tc_imm16='",l_imm16,"'"  
    END IF 		          
    
    LET l_sql=l_sql," ORDER BY tc_imm02 desc) a)
                where item>0 and item<='",l_pagesize,"'"
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
