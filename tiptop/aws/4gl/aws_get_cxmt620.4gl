# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_cxmt620.4gl
# Descriptions...: 获取产线条码相关信息
# Date & Author..: 2016-05-24 15:28:38 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"

                   
FUNCTION aws_get_cxmt620()
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_cxmt620_process()
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
FUNCTION aws_get_cxmt620_process()
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
            statu    LIKE type_file.chr1,       #状态
            tc_spx01 LIKE tc_spx_file.tc_spx01, #单号
            tc_spx05 LIKE tc_spx_file.tc_spx05, #客户编号
            tc_spy02 LIKE tc_spy_file.tc_spy02, #项次
            tc_spy04 LIKE tc_spy_file.tc_spy04, #料号
            ima02    LIKE ima_file.ima02,       #品名
            tc_spy05 LIKE tc_spy_file.tc_spy05, #申请数量
            tc_spy06 LIKE tc_spy_file.tc_spy06  #实际数量
           END RECORD
  DEFINE l_statu3    RECORD                  #返回库位和仓库信息
            statu   LIKE type_file.chr1,     #状态
            ime02   LIKE ime_file.ime02,     #库位编码
            ime03   LIKE ime_file.ime03,     #库位名称
            imd01   LIKE imd_file.imd01,     #仓库编码
            imd02   LIKE imd_file.imd02      #仓库名称           
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
  		 SELECT COUNT(*) INTO l_n FROM tc_spy_file WHERE tc_spy01=l_barcode
  		 IF l_n>0 THEN
  		     SELECT COUNT(*) INTO l_n FROM tc_spy_file WHERE tc_spy01=l_barcode AND tc_spy06>0
  		     IF l_n>0 THEN
    		       LET g_status.code = "-1"
      	       LET g_status.description = "配货计划单已转无订单出货!"
      	       RETURN
           ELSE
           	   SELECT COUNT(*) INTO l_n FROM tc_spy_file WHERE tc_spy01=l_barcode AND tc_spy05>0
           	   IF l_n<1 THEN
    		          LET g_status.code = "-1"
      	          LET g_status.description = "配货计划单无可转出货数据!"
      	          RETURN
               ELSE
                  LET l_sql=" select '2',tc_spx01,tc_spx05,tc_spy02,tc_spy04,'',tc_spy05,tc_spy06",
                            " from tc_spx_file,tc_spy_file",
                            " where tc_spx01=tc_spy01",
                            " and tc_spx01='",l_barcode,"'",
                            " and tc_spy05>0"
              
                            DECLARE occ_cur CURSOR FROM l_sql
                            
                            IF SQLCA.SQLCODE THEN
                               LET g_status.code = SQLCA.SQLCODE
                               LET g_status.sqlcode = SQLCA.SQLCODE
                               RETURN
                            END IF
                            FOREACH occ_cur INTO l_statu2.*
                               SELECT ima02 INTO l_statu2.ima02 FROM ima_file WHERE ima01=l_statu2.tc_spy04
                               LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu2), "Master")   #加入此筆單檔資料至 Response 中
                            END FOREACH
               END IF       	        	
           END IF
       ELSE 
       	   SELECT COUNT(*) INTO l_n FROM ime_file WHERE ime02=l_barcode AND imeacti='Y' #库位和仓库
           IF l_n>1 THEN
           	  LET g_status.code = -1
              LET g_status.description = '库位重复,请至aimi201中检查!'
              RETURN
           ELSE 
           	 IF l_n=1 THEN
           	 	  LET l_statu3.statu='3'
           	 	  LET l_statu3.ime02=l_barcode
           	 	  SELECT ime01,ime03 INTO l_statu3.imd01,l_statu3.ime03 FROM ime_file WHERE ime02=l_barcode AND imeacti='Y'
           	 	  SELECT imd02 INTO l_statu3.imd02 FROM imd_file WHERE imd01=l_statu3.imd01 AND imdacti='Y'
           	 	   LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu3), "Master")   #Response   
           	 ELSE
           	 	   LET g_status.code = -1
                 LET g_status.description = '条码有误,请检查!'
                 RETURN
           	 END IF
           END IF
       END IF
  	END IF
END FUNCTION

	