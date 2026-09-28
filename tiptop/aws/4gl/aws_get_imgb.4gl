# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_imgb.4gl
# Descriptions...: 获取批次条码库存信息
# Date & Author..: 2016-05-31 15:32:03 by shenran

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_imgb()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_imgb_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_imgb_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_cnt   LIKE type_file.num10
    DEFINE l_sfa01 LIKE sfa_file.sfa01
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_n     LIKE type_file.num10
    DEFINE l_sfv09 LIKE sfv_file.sfv09
    DEFINE l_imgb01 LIKE imgb_file.imgb01
    DEFINE l_imgb03 LIKE imgb_file.imgb03
    DEFINE l_imgb    RECORD 
               ima01  LIKE ima_file.ima01, #料号
               ima02  LIKE ima_file.ima02, #品名
               ima021 LIKE ima_file.ima021,#规格
               ima25  LIKE ima_file.ima25, #库存单位
               imgb02 LIKE imgb_file.imgb02,#仓库
               imgb03 LIKE imgb_file.imgb03,#库位
               imgb05 LIKE imgb_file.imgb05 #数量
                    END RECORD
    
    LET l_imgb01 = aws_ttsrv_getParameter("imgb01")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_imgb03 = aws_ttsrv_getParameter("imgb03")   #取由呼叫端呼叫時給予的 SQL Condition

    IF cl_null(l_imgb01) THEN 
       LET g_status.code=-1
       LET g_status.description="批次条码不能为空！"
       RETURN
    END IF
    SELECT COUNT(*) INTO l_cnt FROM ibb_file WHERE ibb01=l_imgb01
    IF l_cnt=0 THEN
    	 LET g_status.code=-1
       LET g_status.description="批次条码不存在,请检查！"
       RETURN
    END IF
    IF cl_null(l_imgb03) THEN 
       LET l_sql = " SELECT ibb06,ima02,ima021,ima25,imgb02,imgb03,imgb05",
                   " FROM ibb_file",
                   " LEFT JOIN ima_file on ibb06 = ima01",
                   " LEFT JOIN imgb_file on ibb01 = imgb01 AND imgb05>0",
                   " WHERE ibb01='",l_imgb01,"'"
    ELSE 
       LET l_sql = " SELECT ibb06,ima02,ima021,ima25,imgb02,imgb03,imgb05",
                   " FROM ibb_file",
                   " LEFT JOIN ima_file on ibb06 = ima01",
                   " LEFT JOIN imgb_file on ibb01 = imgb01 and imgb03='",l_imgb03,"' AND imgb05>0",
                   " WHERE ibb01='",l_imgb01,"'"
    END IF
    	
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_imgb.*
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_imgb), "Master")   #加入此筆單檔資料至 Response 中
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
	

