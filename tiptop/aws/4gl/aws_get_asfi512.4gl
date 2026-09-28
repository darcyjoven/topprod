# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_asf512.4gl
# Descriptions...: 获取产线超领单号条码相关信息
# Date & Author..: 2016-05-24 15:28:38 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"


                   
FUNCTION aws_get_asfi512()
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_asfi512_process()
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
FUNCTION aws_get_asfi512_process()
	DEFINE l_username LIKE type_file.chr20
	DEFINE l_barcode  LIKE type_file.chr50
	DEFINE l_n        LIKE type_file.num5
	DEFINE l_length   LIKE type_file.num5
    DEFINE sfp04      LIKE sfp_file.sfp04    #过账码
    DEFINE sfp06      LIKE sfp_file.sfp06    #异动类型
    DEFINE sfpconf    LIKE sfp_file.sfpconf  #确认码
  DEFINE l_node     om.DomNode
  DEFINE l_statu1    RECORD                  #返回料件信息
            statu   LIKE type_file.chr1,     #状态
            barcode LIKE type_file.chr50,    #批次条码
            ima01   LIKE ima_file.ima01,     #料件编码
            batch   LIKE type_file.chr20,    #批次
            ima02   LIKE ima_file.ima02,     #品名
            ima021  LIKE ima_file.ima021     #规格
           END RECORD
  DEFINE l_statu2    RECORD                  #返回超领单相关信息
            statu    LIKE type_file.chr1,    #状态
            sfp01    LIKE sfp_file.sfp01,    #超领单号
            sfp02    LIKE sfp_file.sfp02,    #日期
            sfp16    LIKE sfp_file.sfp16,    #申请人
            gen02    LIKE gen_file.gen02,    #员工姓名
            sfp07    LIKE sfp_file.sfp07,    #申请部门
            gem02    LIKE gem_file.gem02,    #部门名称
            sfs02    LIKE sfs_file.sfs02,    #项次
            sfs04    LIKE sfs_file.sfs04,    #料号
            ima02    LIKE ima_file.ima02,    #品名
            sfs05    LIKE sfs_file.sfs05,    #申请量
            sfs07    LIKE sfs_file.sfs07     #仓库
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
    INITIALIZE l_statu1.* TO NULL
    INITIALIZE l_statu2.* TO NULL
    INITIALIZE l_statu3.* TO NULL
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
  		     LET l_n=0
         	 LET l_sql=" select count(*) from sfp_file,sfs_file ",
         	           " where sfp01=sfs01",
         	           " and sfp01='",l_barcode,"'",
         	           " and sfp06='2'"
         	    PREPARE execute1_sql FROM l_sql
              EXECUTE execute1_sql INTO l_n
  		     IF l_n=0 THEN
 		     	    SELECT COUNT(*) INTO l_n FROM ime_file WHERE ime02=l_barcode  #库位和仓库
              IF l_n>1 THEN
           	    LET g_status.code = -1
                LET g_status.description = '库位重复,请至aimi201中检查!'
                RETURN
              ELSE 
           	    IF l_n=1 THEN
           	    	  LET l_statu3.statu='3'
           	    	  LET l_statu3.ime02=l_barcode
           	    	  SELECT ime01,ime03 INTO l_statu3.imd01,l_statu3.ime03 FROM ime_file WHERE ime02=l_barcode
           	    	  SELECT imd02 INTO l_statu3.imd02 FROM imd_file WHERE imd01=l_statu3.imd01
           	    	   LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu3), "Master")   #Response   
           	    ELSE
           	    	  LET l_n=0
           	    	  SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=l_barcode
           	    	  IF l_n=1 THEN
           	    	  	 LET l_statu1.barcode=l_barcode
    	                 LET l_statu1.ima01 = l_barcode
                       LET l_statu1.batch = ''
                       LET l_statu1.statu='1'
                       SELECT ima02,ima021 INTO l_statu1.ima02,l_statu1.ima021 FROM ima_file
       	               WHERE ima01=l_statu1.ima01 AND imaacti='Y'
       	               LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu1), "Master")
           	    	  ELSE
           	    	     LET g_status.code = -1
                       LET g_status.description = '条码有误,请检查!'
                       RETURN
                    END IF
           	    END IF
              END IF
           ELSE
           	  LET l_n=0
           	  LET l_sql=" select count(*) from sfp_file ",
           	            " where sfp01='",l_barcode,"'",
           	            " and sfp06='2'",
           	            " and sfpconf='Y'"
           	    PREPARE execute2_sql FROM l_sql
                EXECUTE execute2_sql INTO l_n
           	  IF l_n>0 THEN

           	  	  LET l_sql = "select '2',sfp01,sfp02,sfp16,gen02,sfp07,gem02,sfs02,sfs04,ima02,sfs05,sfs07",
           	  	              " from sfp_file,sfs_file,gen_file,gem_file,ima_file",
           	  	              " where sfp01=sfs01",
           	  	              "   and sfp01='",l_barcode,"'",
           	  	              "   and sfp16=gen01(+)",
           	  	              "   and sfp07=gem01(+)",
           	  	              "   and sfs04=ima01(+)"
           	  	         PREPARE i512_statu2 FROM l_sql
   
                         DECLARE i512_statu2_cur CURSOR FOR i512_statu2

                        FOREACH i512_statu2_cur INTO l_statu2.*
                            IF STATUS THEN
                               CALL cl_err('foreach i512_statu2_cur:',STATUS,1)
                               EXIT FOREACH
                            END IF     
                            LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_statu2), "Master")   #Response     
                        END FOREACH                     
              ELSE  
                  LET g_status.code = -1
      	          LET g_status.description = "请检查超领工单号状态!"
      	          RETURN
              END IF
  		     END IF 
    END IF 
END FUNCTION

