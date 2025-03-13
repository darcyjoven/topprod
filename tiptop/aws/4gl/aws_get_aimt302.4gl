# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_aimt302.4gl
# Descriptions...: 获取杂收单相关信息
# Date & Author..: 2016-05-24 15:28:38 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"

                   
FUNCTION aws_get_aimt302()
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_aimt302_process()
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
FUNCTION aws_get_aimt302_process()
	DEFINE l_username LIKE type_file.chr20
	DEFINE l_barcode  LIKE type_file.chr50
	DEFINE l_n,l_n2,l_i,l_cnt        LIKE type_file.num5
	DEFINE l_length   LIKE type_file.num5
  DEFINE l_node     om.DomNode
  DEFINE l_statu1    RECORD                  #返回理由码
            statu   LIKE type_file.chr1,     #状态
            azf01   LIKE azf_file.azf01,     #理由码编码
            azf03   LIKE azf_file.azf03      #理由码说明
           END RECORD
  DEFINE l_statu2    RECORD                  #返回员工和部门信息
            statu   LIKE type_file.chr1,     #状态
            gen01   LIKE gen_file.gen01,     #员工编码
            gen02   LIKE gen_file.gen02,     #员工姓名
            gem01   LIKE gem_file.gem01,     #部门编码
            gem02   LIKE gem_file.gem02      #部门名称
           END RECORD
  DEFINE l_statu3    RECORD                  #返回部门信息
            statu   LIKE type_file.chr1,     #状态
            gem01   LIKE gem_file.gem01,     #部门编码
            gem02   LIKE gem_file.gem02      #部门名称
           END RECORD
  DEFINE l_statu4    RECORD                  #返回料件信息
            statu   LIKE type_file.chr1,     #状态
            barcode LIKE type_file.chr50,    #批次条码
            ima01   LIKE ima_file.ima01,     #料件编码
            batch   LIKE type_file.chr20,    #批次
            ima02   LIKE ima_file.ima02,     #品名
            ima021  LIKE ima_file.ima021     #规格
           END RECORD
  DEFINE l_statu5    RECORD                  #返回库位和仓库信息
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
    SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01=l_barcode AND azf09='4' #理由码
    IF l_n=1 THEN
    	 LET l_statu1.statu='1'
    	 LET l_statu1.azf01=l_barcode
    	 SELECT azf03 INTO l_statu1.azf03 FROM azf_file WHERE azf01=l_barcode AND azf09='4'
    	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu1))
    ELSE
    	  #员工工号处理
        SELECT COUNT(*) INTO l_n FROM gen_file WHERE gen01=l_barcode AND genacti='Y'  
        IF l_n=1 THEN
        	  LET l_statu2.statu='2'
        	  LET l_statu2.gen01=l_barcode
        	  SELECT gen02,gen03 INTO l_statu2.gen02,l_statu2.gem01 FROM gen_file WHERE gen01=l_barcode
        	  SELECT gem02 INTO l_statu2.gem02 FROM gem_file WHERE gem01=l_statu2.gem01
            CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu2))
        ELSE 
        	  #部门处理
            SELECT COUNT(*) INTO l_n FROM gem_file WHERE gem01=l_barcode AND gemacti='Y'  
            IF l_n=1 THEN
            	  LET l_statu3.statu='3'
            	  LET l_statu3.gem01=l_barcode
            	  SELECT gem02 INTO l_statu3.gem02 FROM gem_file WHERE gem01=l_barcode
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu3))
            ELSE 
            	  #料件处理
            	  #获取条码分隔符
                LET l_i=0
                SELECT LENGTH(REGEXP_REPLACE(REPLACE(l_barcode,'%','@'),'[^@]+','')) INTO l_i FROM DUAL
            	  LET l_length= LENGTH(l_barcode)
                SELECT instr(l_barcode,'%',1,1) INTO l_n FROM dual
                SELECT instr(l_barcode,'%',1,2) INTO l_n2 FROM dual	#第二个分隔符位置
                IF l_i=2 THEN   #物料条码，两个分隔符
                	 LET l_statu4.barcode=l_barcode
                	 LET l_statu4.ima01 = l_barcode[1,l_n-1]           #物料编码
                   LET l_statu4.batch = l_barcode[l_n+1,l_n2-1]      #批号
                   SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=l_statu4.ima01 AND imaacti='Y'
                   IF l_n=1 THEN
                   	  LET l_statu4.statu='4'
                   	  SELECT ima02,ima021 INTO l_statu4.ima02,l_statu4.ima021 FROM ima_file
                   	  WHERE ima01=l_statu4.ima01 AND imaacti='Y'
                   	  CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu4))
                   ELSE 
                   	  LET g_status.code = -1
                      LET g_status.description = '料件不存在,请检查!'
                      RETURN
                   END IF
                END IF 
                IF l_i=1 THEN 	 #仓库条码一个分隔符
                	 LET l_statu5.imd01=l_barcode[1,l_n-1]
    	             LET l_statu5.ime02=l_barcode[l_n+1,l_length]
    	             LET l_cnt=0
    	             SELECT COUNT(*) INTO l_cnt FROM imd_file
    	             WHERE imd01 = l_statu5.imd01 AND imd20 = g_plant
    	             IF l_cnt=0  THEN
    	             	 LET g_status.code = -1
                      LET g_status.description = '仓库编号不存在，请检查!'
                      RETURN 
    	             END IF 
    	              
    	             LET l_cnt=0
    	             SELECT COUNT(*) INTO l_cnt FROM ime_file,imd_file 
    	             WHERE ime01=imd01 AND ime01 = l_statu5.imd01 
    	               AND ime02 = l_statu5.ime02 AND imd20 = g_plant
    	             IF l_cnt=0  THEN
    	             	 LET g_status.code = -1
                      LET g_status.description = '仓库库位不匹配，请检查!'
                      RETURN  
    	             END IF
    	             
    	             SELECT imd02 INTO l_statu5.imd02 FROM imd_file 
    	             WHERE imd01 = l_statu5.imd01 AND imd20 = g_plant	
    	             
    	             SELECT ime03 INTO l_statu5.ime03 FROM ime_file,imd_file 
    	             WHERE ime01=imd01 AND ime01 = l_statu5.imd01 AND ime02=l_statu5.ime02
    	             
    	             LET l_statu5.statu='5'  #仓库	
                	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu5))
#                	 SELECT COUNT(*) INTO l_n FROM ime_file WHERE ime02=l_barcode AND imeacti='Y' #库位和仓库
#                   IF l_n>1 THEN
#                   	 LET g_status.code = -1
#                      LET g_status.description = '库位重复,请至aimi201中检查!'
#                      RETURN
#                   ELSE 
#                   	 IF l_n=1 THEN
#                   	 	  LET l_statu5.statu='5'
#                   	 	  LET l_statu5.ime02=l_barcode
#                   	 	  SELECT ime01,ime03 INTO l_statu5.imd01,l_statu5.ime03 FROM ime_file WHERE ime02=l_barcode AND imeacti='Y'
#                   	 	  SELECT imd02 INTO l_statu5.imd02 FROM imd_file WHERE imd01=l_statu5.imd01 AND imdacti='Y'
#                   	 	  CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu5))
#                   	 ELSE
#                   	 	   LET l_n=0
#           	    	       SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=l_barcode
#           	    	       IF l_n=1 THEN
#           	    	       	  LET l_statu4.barcode=l_barcode
#    	                      LET l_statu4.ima01 = l_barcode
#                            LET l_statu4.batch = ''
#                            LET l_statu4.statu='4'
#                            SELECT ima02,ima021 INTO l_statu4.ima02,l_statu4.ima021 FROM ima_file
#       	                    WHERE ima01=l_statu4.ima01 AND imaacti='Y'
#       	                    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu4))
#           	    	       ELSE
#           	    	          LET g_status.code = -1
#                            LET g_status.description = '条码有误,请检查!'
#                            RETURN
#                         END IF
#                   	 END IF
#                   END IF
                END IF
            END IF
        END IF
    END IF
  	    
END FUNCTION

	