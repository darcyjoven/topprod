#{
# Program name...: aws_get_asfi528.4gl
# Descriptions...: 获取ERP工单退料资料信息
# Date & Author..: 2016-09-10 20:37:38 shenran 
# Memo...........:
#}

DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl" 

FUNCTION aws_get_asfi528()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()                                                        
    
    IF g_status.code = "0" THEN
       CALL aws_get_asfi528_process()     #提供取得工单资料的入口程序          
    END IF 
    CALL aws_ttsrv_postprocess()        
END FUNCTION
	
FUNCTION aws_get_asfi528_process()
    DEFINE l_i   LIKE type_file.num10
    DEFINE l_statu1    RECORD                #工单信息
            statu    LIKE type_file.chr1,    #状态
            sfa01    LIKE sfa_file.sfa01,    #工单单号
            sfa03    LIKE sfa_file.sfa03,    #料件编号 
            sfs05    LIKE sfs_file.sfs05,    #退料量
            sfs05a   LIKE sfs_file.sfs05     #匹配数量
                 END RECORD 
   DEFINE l_statu2    RECORD                 #返回料件信息
            statu   LIKE type_file.chr1,     #状态
            barcode LIKE type_file.chr50,    #批次条码
            ima01   LIKE ima_file.ima01,     #料件编码
            batch   LIKE type_file.chr20,    #批次
            ima02   LIKE ima_file.ima02,     #品名
            ima021  LIKE ima_file.ima021     #规格
                    END RECORD
   DEFINE l_statu3    RECORD                  #返回库位和仓库信息
            statu   LIKE type_file.chr1,     #状态
            ime02   LIKE ime_file.ime02,     #库位编码
            ime03   LIKE ime_file.ime03,     #库位名称
            imd01   LIKE imd_file.imd01,     #仓库编码
            imd02   LIKE imd_file.imd02      #仓库名称           
                    END RECORD                       
    DEFINE l_num INTEGER 
    DEFINE l_node   om.DomNode
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_barcode  LIKE type_file.chr50               
    DEFINE l_str   STRING
    DEFINE l_sql   STRING
	  DEFINE l_n        LIKE type_file.num5
	  DEFINE l_length   LIKE type_file.num5    
    
    LET l_barcode = aws_ttsrv_getParameter("barcode")   #SQL Condition
  
    IF cl_null(l_barcode) THEN 
    	LET g_status.code = "-1"
      LET g_status.description = "条码为空,请扫描条码"
      RETURN
    END IF
    LET l_num=0
    SELECT COUNT(*) INTO l_num FROM sfb_file WHERE sfb01=l_barcode
    IF l_num>0 THEN 
    	  SELECT COUNT(*) INTO l_num FROM sfb_file
    	  WHERE sfb01=l_barcode AND sfb87 = 'Y' 
    	  AND sfb04 <>'8' AND sfb04<>'1'
    	  IF l_num<1 THEN 
    	  	LET g_status.code = "-1"
        	LET g_status.description = "找不到资料,请检查工单单号是否不存在/未审核/已结案!"
        	RETURN
        ELSE  
        	LET l_sql = "SELECT '1',sfa01,sfa03,sfa06-((sfb09 + sfb11)*sfa161),0", #mod  huxy160407
                      " FROM sfb_file,sfa_file ",
                     	" WHERE sfa01='",l_barcode,"'",
                     	" AND sfa01=sfb01",
                     	" ORDER BY sfa01,sfa03"
           PREPARE sfa_pre FROM l_sql
           DECLARE sfa_cur CURSOR FOR sfa_pre
           
           IF SQLCA.SQLCODE THEN
           	 LET l_str="发生语法错误!"
              LET g_status.code ="-1"
              LET g_status.sqlcode = SQLCA.SQLCODE
              LET g_status.description=l_str
              RETURN
           END IF
           	
           FOREACH sfa_cur INTO l_statu1.*
               
               LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu1), "Master")   #Response   
           
           END FOREACH         	
        END IF
    ELSE 
    	  #料件处理
        LET l_length= LENGTH(l_barcode)
        SELECT instr(l_barcode,'.',1,1) INTO l_n FROM dual
        IF l_n>0 AND l_n<l_length THEN
        	 LET l_statu2.barcode=l_barcode
        	 LET l_statu2.ima01 = l_barcode[1,l_n-1]           #物料编码
           LET l_statu2.batch = l_barcode[l_n+1,l_length]
           SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=l_statu2.ima01 AND imaacti='Y'
           IF l_n=1 THEN
           	  LET l_statu2.statu='2'
           	  SELECT ima02,ima021 INTO l_statu2.ima02,l_statu2.ima021 FROM ima_file
           	  WHERE ima01=l_statu2.ima01 AND imaacti='Y'
           	  LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu2), "Master")
           ELSE 
           	  LET g_status.code = -1
              LET g_status.description = '料件不存在,请检查!'
              RETURN
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
           	 	  LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu3), "Master")
           	 ELSE
           	 	   LET g_status.code = -1
                 LET g_status.description = '条码有误,请检查!'
                 RETURN
           	 END IF
           END IF
        END IF
    END IF 
    
END FUNCTION
