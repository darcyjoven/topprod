# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_move.4gl
# Descriptions...: 获取移库相关信息
# Date & Author..: 2016-06-04 15:42:12 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"

                   
FUNCTION aws_get_move()
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_move_process()
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
FUNCTION aws_get_move_process()
	DEFINE l_username LIKE type_file.chr20
	DEFINE l_barcode  LIKE type_file.chr50
	DEFINE l_n        LIKE type_file.num5
	DEFINE l_statu    LIKE type_file.chr1
	DEFINE l_length   LIKE type_file.num5
  DEFINE l_node     om.DomNode
  DEFINE l_statu1    RECORD                  #返回库位和仓库信息
            statu   LIKE type_file.chr1,     #状态
            ime02   LIKE ime_file.ime02,     #库位编码
            ime03   LIKE ime_file.ime03,     #库位名称
            imd01   LIKE imd_file.imd01,     #仓库编码
            imd02   LIKE imd_file.imd02      #仓库名称           
           END RECORD  
  DEFINE l_statu3    RECORD                  #返回料件信息
            statu   LIKE type_file.chr1,     #状态
            barcode LIKE type_file.chr50,    #批次条码
            ima01   LIKE ima_file.ima01,     #料件编码
            batch   LIKE type_file.chr20,    #批次
            ima02   LIKE ima_file.ima02,     #品名
            ima021  LIKE ima_file.ima021     #规格
           END RECORD                                                   
    DEFINE l_sql   STRING
    
    LET l_statu = aws_ttsrv_getParameter("statu")   #传入状态
    LET l_barcode = aws_ttsrv_getParameter("barcode")   #传入条码
    IF cl_null(l_statu) THEN
    	   LET g_status.code = -1
         LET g_status.description = '状态为空,请检查!'
         RETURN
    END IF
    	  
    IF cl_null(l_barcode) THEN
    	   LET g_status.code = -1
         LET g_status.description = '条码为空,请检查!'
         RETURN
    END IF
    IF l_statu='3' THEN
    	   LET l_length= LENGTH(l_barcode)
         SELECT instr(l_barcode,'.',1,1) INTO l_n FROM dual
         IF l_n>0 AND l_n<l_length THEN
         	 LET l_statu3.barcode=l_barcode
         	 LET l_statu3.ima01 = l_barcode[1,l_n-1]           #物料编码
           LET l_statu3.batch = l_barcode[l_n+1,l_length]
            SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=l_statu3.ima01 AND imaacti='Y'
            IF l_n=1 THEN
            	  LET l_statu3.statu=l_statu
            	  SELECT ima02,ima021 INTO l_statu3.ima02,l_statu3.ima021 FROM ima_file
            	  WHERE ima01=l_statu3.ima01 AND imaacti='Y'
            	  CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu3))
            ELSE 
                LET g_status.code = -1
                LET g_status.description = '条码有误,请检查!'
                RETURN
            END IF
         ELSE 
         	  LET g_status.code = -1
            LET g_status.description = '条码有误,请检查!'
            RETURN
         END IF
    ELSE 
    	   SELECT COUNT(*) INTO l_n FROM ime_file WHERE ime02=l_barcode AND imeacti='Y' ##库位和仓库
         IF l_n>1 THEN
         	  LET g_status.code = -1
            LET g_status.description = '库位重复,请至aimi201中检查!'
            RETURN
         ELSE 
         	 IF l_n=1 THEN
         	 	  LET l_statu1.statu=l_statu
         	 	  LET l_statu1.ime02=l_barcode
         	 	  SELECT ime01,ime03 INTO l_statu1.imd01,l_statu1.ime03 FROM ime_file WHERE ime02=l_barcode AND imeacti='Y'
         	 	  SELECT imd02 INTO l_statu1.imd02 FROM imd_file WHERE imd01=l_statu1.imd01 AND imdacti='Y'
         	 	  CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu1))
         	 ELSE
         	 	   LET g_status.code = -1
               LET g_status.description = '条码有误,请检查!'
               RETURN
         	 END IF
         END IF
    END IF
  	    
END FUNCTION

	