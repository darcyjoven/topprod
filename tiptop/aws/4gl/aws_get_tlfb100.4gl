# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_tlfb100.4gl
# Descriptions...: 获取产线条码相关信息
# Date & Author..: 2016-05-24 15:28:38 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"

                   
FUNCTION aws_get_tlfb100()
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_tlfb100_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 检验逻辑
# Date & Author..: 2016/4/17 16:40:06 by shenran
# Parameter......: none
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_get_tlfb100_process()
	DEFINE l_username LIKE type_file.chr20
	DEFINE l_barcode  LIKE type_file.chr50
	DEFINE l_n        LIKE type_file.num5
	DEFINE l_length   LIKE type_file.num5
  DEFINE l_node     om.DomNode
  DEFINE l_statu1    RECORD                  #返回料件信息
            statu   LIKE type_file.chr1,     #状态
            barcode LIKE type_file.chr50,    #批次条码
            ima01   LIKE ima_file.ima01,     #料件编码
            batch   LIKE type_file.chr20,    #批次
            ima02   LIKE ima_file.ima02,     #品名
            ima021  LIKE ima_file.ima021     #规格
           END RECORD
  DEFINE l_statu2    RECORD                  #返回工单相关信息
            statu    LIKE type_file.chr1,    #状态
            sfa01    LIKE sfa_file.sfa01,    #工单单号
            sfa03    LIKE sfa_file.sfa03,    #料件编号 
            ima02    LIKE ima_file.ima02,    #品名 
            ima021   LIKE ima_file.ima021,   #规格
            sfa05_06 LIKE sfa_file.sfa05,    #欠料量(需求量)
            marry_num LIKE ogb_file.ogb12    #匹配数量
           END RECORD                                 
    DEFINE l_sql   STRING
    
    LET l_barcode = aws_ttsrv_getParameter("barcode")   #传入条码
  
    IF cl_null(l_barcode) THEN
    	   LET g_status.code = -1
         LET g_status.description = '条码为空,请检查!'
         RETURN
    END IF

    #料件处理
    LET l_length= LENGTH(l_barcode)
    SELECT instr(l_barcode,'.',1,1) INTO l_n FROM dual
    IF l_n>0 AND l_n<l_length THEN
    	 LET l_statu1.barcode=l_barcode
    	 LET l_statu1.ima01 = l_barcode[1,l_n-1]           #物料编码
       LET l_statu1.batch = l_barcode[l_n+1,l_length]
       SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=l_statu1.ima01 AND imaacti='Y'
       IF l_n=1 THEN
       	  LET l_statu1.statu='1'
       	  SELECT ima02,ima021 INTO l_statu1.ima02,l_statu1.ima021 FROM ima_file
       	  WHERE ima01=l_statu1.ima01 AND imaacti='Y'
       	  LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu1), "Master")   #Response
       ELSE 
          LET g_status.code = -1
          LET g_status.description = '料号不存在,请检查!'
          RETURN
  	   END IF
  	ELSE 
  		 SELECT COUNT(*) INTO l_n FROM sfb_file WHERE sfb01=l_barcode AND sfb87 = 'Y' AND sfb04 <>'8'
  		 IF l_n<1 THEN 
    		   LET g_status.code = "-1"
      	   LET g_status.description = "找不到资料,请检查工单单号是否不存在/未审核/已结案!"
      	   RETURN
       ELSE  
       	SELECT COUNT(*) INTO l_n FROM sfb_file,sfa_file WHERE sfb01 = sfa01 AND sfa05 > sfa06 AND sfb01 = l_barcode
          IF l_n<1 THEN
    				LET g_status.code = "-1"
      			LET g_status.description = "此工单已发料完毕!"
      			RETURN
      	  END IF
         	
      	  LET l_sql = " SELECT '2',sfa01,sfa03,ima02,ima021,", #mod  huxy160407
      		            " sfa05-sfa06 sfa05_06,0 FROM sfb_file,",
     		              " sfa_file ",
                      " LEFT JOIN ima_file ON sfa03=ima01",
                   	  " WHERE sfa01='",l_barcode,"'",
                   	  " AND sfa01=sfb01",
                   	  " ORDER BY sfa01,sfa03"
                     PREPARE sfa_pre FROM l_sql
                     DECLARE sfa_cur CURSOR FOR sfa_pre
                     
                     IF SQLCA.SQLCODE THEN
                        LET g_status.code ="-1"
                        LET g_status.sqlcode = SQLCA.SQLCODE
                        LET g_status.description="发生语法错误!"
                        RETURN
                     END IF
                     	
                     FOREACH sfa_cur INTO l_statu2.*
                         
                         LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu2), "Master")   #Response   
                     
                     END FOREACH         	        	
       END IF
  	END IF
END FUNCTION

	