# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_process.4gl
# Descriptions...: 获取杂收单相关信息
# Date & Author..: 2016-05-24 15:28:38 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"

                   
FUNCTION aws_get_process()
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_process_process()
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
FUNCTION aws_get_process_process()
	DEFINE l_username LIKE type_file.chr20
	DEFINE l_barcode  LIKE type_file.chr50
	DEFINE l_n        LIKE type_file.num5
	DEFINE l_length   LIKE type_file.num5
	DEFINE l_sfb05    LIKE sfb_file.sfb05
	DEFINE l_ima571   LIKE ima_file.ima571
	DEFINE l_ima94    LIKE ima_file.ima94
  DEFINE l_node     om.DomNode
  DEFINE l_statu1   RECORD                   #扫描工单返回料件品名
            statu   LIKE type_file.chr1,     #状态
            sfa01   LIKE sfa_file.sfa01,     #工单号
            ima571  LIKE ima_file.ima571,    #料件
            ima02   LIKE ima_file.ima02      #品名
                END RECORD
  DEFINE l_statu2   RECORD                   #扫描作业编码返回作业名称
           statu    LIKE type_file.chr1,     #状态
           ecb06    LIKE ecb_file.ecb06,     #作业编码
           ecd02    LIKE ecd_file.ecd02      #作业名称
                 END RECORD
  DEFINE l_statu3   RECORD                   #扫描员工编码返回员工姓名
           statu    LIKE type_file.chr1,     #状态
           gen01    LIKE gen_file.gen01,     #员工编码
           gen02    LIKE gen_file.gen02      #姓名
                END RECORD 
  DEFINE l_sql   STRING
    
    LET l_barcode = aws_ttsrv_getParameter("barcode")   #传入条码
  
    IF cl_null(l_barcode) THEN
    	   LET g_status.code = -1
         LET g_status.description = '条码为空,请检查!'
         RETURN
    END IF
    LET l_n=0
    LET l_sfb05=''
    LET l_ima571=''
    LET l_ima94=''
    INITIALIZE l_statu1.* TO NULL
    INITIALIZE l_statu2.* TO NULL
    INITIALIZE l_statu3.* TO NULL
    SELECT COUNT(*) INTO l_n FROM gen_file WHERE gen01=l_barcode AND genacti='Y'
    IF l_n=1 THEN
    	 SELECT gen02 INTO l_statu3.gen02 FROM gen_file WHERE gen01=l_barcode AND genacti='Y'
    	 LET l_statu3.statu='3'
    	 LET l_statu3.gen01=l_barcode
    	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu3))
    ELSE
    	  SELECT COUNT(*) INTO l_n FROM sfb_file WHERE sfb01=l_barcode
    	  IF l_n=1 THEN
    	     SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01=l_barcode
           SELECT ima571,ima94 INTO l_ima571,l_ima94 FROM ima_file WHERE ima01=l_sfb05
           IF cl_null(l_ima571) OR cl_null(l_ima94) THEN
           	  LET g_status.code=-1
              LET g_status.description="料件对应工艺路线料号或工艺编号为空,请检查!"
              RETURN
           END IF
           SELECT COUNT(*) INTO l_n FROM ecu_file WHERE ecu01=l_ima571 AND ecu02=l_ima94 AND ecu10='Y'
           IF l_n>0 THEN
           	  LET l_statu1.ima571=l_ima571
           	  SELECT ima02 INTO l_statu1.ima02 FROM ima_file WHERE ima01=l_statu1.ima571
           	  LET l_statu1.statu='1'
           	  LET l_statu1.sfa01=l_barcode
              CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu1))       
           ELSE 
           	  LET g_status.code=-1
              LET g_status.description="料件对应工艺资料有误!"
              RETURN
           END IF
        ELSE 
        	 SELECT COUNT(*) INTO l_n FROM ecd_file WHERE ecd01=l_barcode
        	 IF l_n=1 THEN
        	 	 SELECT ecd02 INTO l_statu2.ecd02 FROM ecd_file WHERE ecd01=l_barcode
        	 	 LET l_statu2.statu='2'
        	 	 LET l_statu2.ecb06=l_barcode
        	 	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu2))
        	 ELSE 
        	 	 LET g_status.code=-1
             LET g_status.description="条码有误,请检查!"
             RETURN 
        	 END IF
        END IF
    END IF
  	    
END FUNCTION

	