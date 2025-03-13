# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_apmt110.4gl
# Descriptions...: 获取到货单和批次条码信息
# Date & Author..: 2016-06-25 15:34:04 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"

                   
FUNCTION aws_get_apmt110()
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_apmt110_process()
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
FUNCTION aws_get_apmt110_process()
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
  DEFINE l_statu2    RECORD                  #返回到货单相关信息
             statu      LIKE type_file.chr1,       #状态
             pmc03      LIKE pmc_file.pmc03,       #供应商名称
             tc_sib01   LIKE tc_sib_file.tc_sib01, #到货单号
             tc_sib02   LIKE tc_sib_file.tc_sib02, #到货单项次
             tc_sib03   LIKE tc_sib_file.tc_sib03, #采购单号
             tc_sib04   LIKE tc_sib_file.tc_sib04, #采购单项次
             ima01      LIKE ima_file.ima01,       #料件
             ima02      LIKE ima_file.ima02,       #品名
             ima021     LIKE ima_file.ima021,      #规格
             tc_sib05   LIKE tc_sib_file.tc_sib05, #需求量
             tc_sib05a  LIKE tc_sib_file.tc_sib05  #匹配量
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
  		 SELECT COUNT(*) INTO l_n FROM tc_sia_file,tc_sib_file WHERE tc_sia01=tc_sib01 AND tc_sia01=l_barcode
  		 IF l_n>0 THEN
  		     SELECT COUNT(*) INTO l_n FROM tc_sia_file,tc_sib_file WHERE tc_sia01=tc_sib01 
           AND tc_sia01=l_barcode AND tc_sia08='2' AND tc_sib05>tc_sib07
  		     IF l_n=0 THEN
    		       LET g_status.code = "-1"
      	       LET g_status.description = "单据状态不对应或已全部发货!"
      	       RETURN
           ELSE
               LET l_sql = " SELECT '2','',tc_sib01,tc_sib02,tc_sib03,tc_sib04,'','','',tc_sib05-tc_sib07,0",
                           " FROM tc_sib_file ",
                           " WHERE tc_sib01 = '",l_barcode,"'",
                           " AND tc_sib05>tc_sib07",
                           " ORDER BY tc_sib01 "
               
               DECLARE occ_cur CURSOR FROM l_sql
               
               IF SQLCA.SQLCODE THEN
                  LET g_status.code = SQLCA.SQLCODE
                  LET g_status.sqlcode = SQLCA.SQLCODE
                  RETURN
               END IF
               
               FOREACH occ_cur INTO l_statu2.*
               SELECT pmn04,pmn041 INTO l_statu2.ima01,l_statu2.ima02 FROM  pmn_file
               WHERE pmn01 = l_statu2.tc_sib03 AND pmn02 = l_statu2.tc_sib04
               SELECT pmm09 INTO l_statu2.pmc03 FROM pmm_file
               WHERE  pmm01 = l_statu2.tc_sib03
               SELECT pmc03 INTO l_statu2.pmc03 FROM pmc_file WHERE pmc01=l_statu2.pmc03
               SELECT ima021 INTO l_statu2.ima021 FROM ima_file WHERE ima01=l_statu2.ima01
               LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu2), "Master")   #加入此筆單檔資料至 Response 中
               END FOREACH       	        	
           END IF
       ELSE 
           LET g_status.code = -1
           LET g_status.description = '条码有误,请检查!'
           RETURN
       END IF
  	END IF
END FUNCTION

	