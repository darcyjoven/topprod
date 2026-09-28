# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_item_no.4gl
# Descriptions...: 获取物料条码信息
# Date & Author..: 17/05/08 By nihuan
# Memo...........:
# Modify.........:
#
#}

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_item_no()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_item_no_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_item_no_process()
    DEFINE l_i     LIKE type_file.num10

    DEFINE l_node  om.DomNode
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_barcode_no  LIKE type_file.chr1000
    DEFINE l_doc_no      LIKE type_file.chr100
    DEFINE l_n,l_n2,l_h,l_cnt     LIKE type_file.num10
	  DEFINE l_length     LIKE type_file.num5
    DEFINE l_statu    RECORD 
                  ima01      LIKE ima_file.ima01,
                  ima02      LIKE ima_file.ima02,        
                  ima021     LIKE ima_file.ima021,
                  ima25      LIKE ima_file.ima25,        #单位
                  pi_hao     LIKE type_file.chr100,      #批号
                  barcode_no LIKE type_file.chr100,      #物料条码
                  tc_imp08   LIKE tc_imp_file.tc_imp08,
                  flag       LIKE type_file.chr1,        #标记：1.仓库；2.物料
                  imd01      LIKE imd_file.imd01,        #仓库编号
                  imd02      LIKE imd_file.imd02,        #仓库名称
                  ime02      LIKE ime_file.ime02,        #储位编号
                  ime03      LIKE ime_file.ime03,        #储位名称
				  fifo_flag  LIKE tc_codesys_file.tc_codesys09 #先进先出否
    end record 
    
    
    LET l_barcode_no = aws_ttsrv_getParameter("barcode_no")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_doc_no = aws_ttsrv_getParameter("doc_no")   #取由呼叫端呼叫時給予的 SQL Condition
    
    
    SELECT trim(l_barcode_no) INTO l_barcode_no FROM dual 
    SELECT trim(l_doc_no)     INTO l_doc_no FROM dual 
    
    IF cl_null(l_barcode_no) THEN 
       LET g_status.code=-1
       LET g_status.description="条码不可为空"
       RETURN
    END IF 
    
#    IF cl_null(l_doc_no) THEN 
#       LET g_status.code=-1
#       LET g_status.description="调拨单号不可为空"
#       RETURN
#    END IF  
    	
    ##条码规则：仓库%储位
    ############料件编号%生产年月日（或收货日期）_厂商代码%序号（3位）
    
    #获取条码分隔符
    LET l_i=0
    SELECT LENGTH(REGEXP_REPLACE(REPLACE(l_barcode_no,'%','@'),'[^@]+','')) INTO l_i FROM DUAL
    
    IF l_i=0 THEN 
    	 LET g_status.code=-1
    	 LET g_status.description='条码分隔符为空请检查!'
    	 RETURN
    END IF 	
    #获取分隔符的位置
    SELECT instr(l_barcode_no,'%',1,1) INTO l_n FROM dual	  #第一个分隔符位置
    SELECT instr(l_barcode_no,'%',1,2) INTO l_n2 FROM dual	#第二个分隔符位置
    LET l_length= LENGTH(l_barcode_no)
    ####一个分隔符就是物料条码
    #####1########仓库储位条码 
    IF l_i=1 THEN 
   	  LET l_statu.imd01=l_barcode_no[1,l_n-1]
   	  LET l_statu.ime02=l_barcode_no[l_n+1,l_length]
   	  LET l_cnt=0
   	  SELECT COUNT(*) INTO l_cnt FROM imd_file
   	  WHERE imd01 = l_statu.imd01 AND imd20 = g_plant
   	  IF l_cnt=0  THEN
   	  	 LET g_status.code=-1
    	   LET g_status.description='仓库编号不存在，请检查!'
    	   RETURN 
   	  END IF 
   	   
   	  LET l_cnt=0
   	  SELECT COUNT(*) INTO l_cnt FROM ime_file,imd_file 
   	  WHERE ime01=imd01 AND ime01 = l_statu.imd01 
   	    AND ime02 = l_statu.ime02 AND imd20 = g_plant
   	  IF l_cnt=0  THEN
   	  	 LET g_status.code=-1
    	   LET g_status.description='仓库库位不匹配，请检查!'
    	   RETURN 
   	  END IF
   	  
   	  SELECT imd02 INTO l_statu.imd02 FROM imd_file 
   	  WHERE imd01 = l_statu.imd01 AND imd20 = g_plant	
   	  
   	  SELECT ime03 INTO l_statu.ime03 FROM ime_file,imd_file 
   	  WHERE ime01=imd01 AND ime01 = l_statu.imd01 
   	  
   	  LET l_statu.flag='1'  #仓库	
   	  
    END IF
    
    #分隔符2个为物料条码
    IF l_i=2 THEN
    	  LET l_statu.ima01=l_barcode_no[1,l_n-1]  #料号
    	  LET l_statu.pi_hao=l_barcode_no[l_n+1,l_n2-1]   #批号
    	  
    	  LET l_cnt=0
    	  SELECT COUNT(*) INTO l_cnt FROM ima_file
    	  WHERE ima01=l_statu.ima01 
    	  IF l_cnt=0  THEN 
    	  	 LET g_status.code=-1
    	     LET g_status.description='料号不存在，请检查!'
    	     RETURN
    	  END IF
    	  SELECT ima02,ima021,ima25 INTO l_statu.ima02,l_statu.ima021,l_statu.ima25
    	  FROM ima_file WHERE ima01=l_statu.ima01
    	  SELECT SUM(tc_imp08) INTO l_statu.tc_imp08 FROM tc_imp_file 
    	  WHERE tc_imp01=l_doc_no AND tc_imp05=l_statu.ima01
    	  LET l_statu.barcode_no=l_barcode_no
    	  LET l_statu.flag='2'  #物料	
    END IF	
	
	select tc_codesys09 into l_statu.fifo_flag from tc_codesys_file  #add by caojf20180428
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu))

END FUNCTION
