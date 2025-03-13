# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_tlfb510.4gl
# Descriptions...: 获取产线条码相关信息
# Date & Author..: 2016-05-24 15:28:38 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"

                   
FUNCTION aws_get_tlfb510()
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_tlfb510_process()
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
FUNCTION aws_get_tlfb510_process()
	DEFINE l_username LIKE type_file.chr20
	DEFINE l_barcode  LIKE type_file.chr50
	DEFINE l_n,l_n2,l_i,l_cnt        LIKE type_file.num5
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
  DEFINE l_statu3    RECORD                  #返回库位和仓库信息
            statu   LIKE type_file.chr1,     #状态
            ime02   LIKE ime_file.ime02,     #库位编码
            ime03   LIKE ime_file.ime03,     #库位名称
            imd01   LIKE imd_file.imd01,     #仓库编码
            imd02   LIKE imd_file.imd02      #仓库名称           
           END RECORD                                 
    DEFINE l_sql   STRING
    DEFINE l_statu           LIKE type_file.chr1
    DEFINE l_response        STRING
    DEFINE l_receiptString   STRING
    DEFINE l_line            STRING
    
    LET l_statu=''
    LET l_response=''
    LET l_receiptString=''
    LET l_line=''
       
    LET l_barcode = aws_ttsrv_getParameter("barcode")   #传入条码
  
    IF cl_null(l_barcode) THEN
    	 LET g_status.code = -1
       LET g_status.description = '条码为空,请检查!'
       RETURN
    END IF
    
    #获取条码分隔符
    LET l_i=0
    SELECT LENGTH(REGEXP_REPLACE(REPLACE(l_barcode,'%','@'),'[^@]+','')) INTO l_i FROM DUAL
    
    #获取分隔符的位置
    SELECT instr(l_barcode,'%',1,1) INTO l_n FROM dual	  #第一个分隔符位置
    SELECT instr(l_barcode,'%',1,2) INTO l_n2 FROM dual	  #第二个分隔符位置
    LET l_length= LENGTH(l_barcode)
    ####一个分隔符就是物料条码
    #####1########仓库储位条码 
    IF l_i=1 THEN 
    	  LET l_statu3.imd01=l_barcode[1,l_n-1]
    	  LET l_statu3.ime02=l_barcode[l_n+1,l_length]
    	  LET l_cnt=0
    	  SELECT COUNT(*) INTO l_cnt FROM imd_file
    	  WHERE imd01 = l_statu3.imd01 AND imd20 = g_plant
    	  IF l_cnt=0  THEN
    	  	 LET g_status.code = -1
           LET g_status.description = '仓库编号不存在，请检查!'
           RETURN 
    	  END IF 
    	   
    	  LET l_cnt=0
    	  SELECT COUNT(*) INTO l_cnt FROM ime_file,imd_file 
    	  WHERE ime01=imd01 AND ime01 = l_statu3.imd01 
    	    AND ime02 = l_statu3.ime02 AND imd20 = g_plant
    	  IF l_cnt=0  THEN
    	  	 LET g_status.code = -1
           LET g_status.description = '仓库库位不匹配，请检查!'
           RETURN  
    	  END IF
    	  
    	  SELECT imd02 INTO l_statu3.imd02 FROM imd_file 
    	  WHERE imd01 = l_statu3.imd01 AND imd20 = g_plant	
    	  
    	  SELECT ime03 INTO l_statu3.ime03 FROM ime_file,imd_file 
    	  WHERE ime01=imd01 AND ime01 = l_statu3.imd01 AND ime02=l_statu3.ime02
    	  
    	  LET l_statu3.statu='3'  #仓库	
    	  LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu3), "Master")   #Response 
    END IF

    #料件处理

    IF l_i=2 THEN
    	 LET l_statu1.barcode=l_barcode
    	 LET l_statu1.ima01 = l_barcode[1,l_n-1]           #物料编码
       LET l_statu1.batch = l_barcode[l_n+1,l_n2-1]      #批号
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
  	END IF 
  	
  	IF l_i=0 THEN 	
  		 SELECT COUNT(*) INTO l_n FROM sfb_file WHERE sfb01=l_barcode
  		 IF l_n=1 THEN 
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
                             #LET l_line=l_line,"<Line ItemCode=\"",l_statu2.sfa03,"\" TargetQty=\"",l_statu2.sfa05_06,"\"/>"
                         END FOREACH
                         #LET l_receiptString="<pickup No=\"",l_statu2.sfa01,"\">",l_line,"</pickup>"
                         #CALL CreatePickupSheet(l_receiptString) RETURNING l_statu,l_response       	        	
           END IF
       ELSE 
#       	   SELECT COUNT(*) INTO l_n FROM ime_file WHERE ime02=l_barcode AND imeacti='Y' #库位和仓库
#           IF l_n>1 THEN
#           	  LET g_status.code = -1
#              LET g_status.description = '库位重复,请至aimi201中检查!'
#              RETURN
#           ELSE 
#           	 IF l_n=1 THEN
#           	 	  LET l_statu3.statu='3'
#           	 	  LET l_statu3.ime02=l_barcode
#           	 	  SELECT ime01,ime03 INTO l_statu3.imd01,l_statu3.ime03 FROM ime_file WHERE ime02=l_barcode AND imeacti='Y'
#           	 	  SELECT imd02 INTO l_statu3.imd02 FROM imd_file WHERE imd01=l_statu3.imd01 AND imdacti='Y'
#           	 	   LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu3), "Master")   #Response   
#           	 ELSE
#           	 	   LET g_status.code = -1
#                 LET g_status.description = '条码有误,请检查!'
#                 RETURN
#           	 END IF
#           END IF
       END IF
  	END IF
END FUNCTION

	