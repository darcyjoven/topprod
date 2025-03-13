# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_aimt302.4gl
# Descriptions...: 获取杂收单相关信息
# Date & Author..: 2016-05-24 15:28:38 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../../tiptop/aba/4gl/barcode.global"
#add by lili 170109 ---s---
GLOBALS 
  DEFINE g_uid        STRING
  DEFINE g_service    STRING
END GLOBALS
#add by lili 170109 ---e---
                   
FUNCTION cws_get_aimt301_g()
DEFINE l_str     STRING   #add by lili 170109
DEFINE l_stime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_etime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_costtime INTERVAL HOUR TO FRACTION(3)
DEFINE l_stimestr STRING
DEFINE l_etimestr STRING
DEFINE l_logfile  STRING
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    #add by lili 170109 ---s---
    LET g_service = "cws_get_aimt301"

    LET g_uid = getGuid()
    LET l_logfile = "/u1/out/aws_ttsrv2costtime-",TODAY USING 'YYYYMMDD',".log"
    LET l_stimestr = CURRENT HOUR TO FRACTION(3)
    LET l_stime = l_stimestr
    LET l_str = g_uid," ",g_service," ",l_stimestr," Start"
    CALL writeStringToFile(l_str,l_logfile) 
    #add by lili 170109 ---e---
    IF g_status.code = "0" THEN
       CALL cws_get_aimt301_process()
    END IF
    #add by lili 170109 ---s---	                                                                                        
    LET l_etimestr = CURRENT HOUR TO FRACTION(3)
    LET l_etime = l_etimestr
    LET l_str = g_uid," ",g_service," ",l_etimestr," End"
    CALL writeStringToFile(l_str,l_logfile)
    #add by lili 170109 ---e---
    
    LET l_costtime = l_etime - l_stime
    LET l_str = g_uid," ",g_service," ",l_costtime," Cost"
    CALL writeStringToFile(l_str,l_logfile)
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
FUNCTION cws_get_aimt301_process()
	DEFINE l_username LIKE type_file.chr20
	DEFINE l_barcode  LIKE type_file.chr50
	DEFINE l_n        LIKE type_file.num5
	DEFINE l_length   LIKE type_file.num5
   DEFINE l_node     om.DomNode
   DEFINE l_statu1    RECORD                  #返回库位和仓库信息
            statu   LIKE type_file.chr1,     #状态
            imd01   LIKE imd_file.imd01,     #仓库编码
            imd02   LIKE imd_file.imd02,     #仓库名称 
            ime02   LIKE ime_file.ime02,     #库位编码
            ime03   LIKE ime_file.ime03,     #库位名称
            fifo_flag  LIKE tc_codesys_file.tc_codesys09 #先进先出否			
           END RECORD  
   DEFINE l_statu2    RECORD                  #返回料件信息
            statu   LIKE type_file.chr1,     #状态
            barcode LIKE type_file.chr50,    #批次条码
            ima01   LIKE ima_file.ima01,     #料件编码
            ima02   LIKE ima_file.ima02,     #品名
            ima021  LIKE ima_file.ima021,    #规格
            batch   LIKE type_file.chr20,    #批次
            qty     LIKE sfs_file.sfs05,      #数量
			fifo_flag  LIKE tc_codesys_file.tc_codesys09 #先进先出否
           END RECORD
	DEFINE l_statu3    RECORD                  #返回杂收单信息
            statu   LIKE type_file.chr1,     #状态
            ina01   LIKE ina_file.ina01,     #杂收单号
            #inb03   LIKE inb_file.inb03,     #项次
            inb04   LIKE inb_file.inb04,     #料号
            ima02   LIKE ima_file.ima02,     #品名
            ima021  LIKE ima_file.ima021,		#规格
            #inb05	  LIKE inb_file.inb05,		#仓库
            #inb06	  LIKE inb_file.inb06,		#库位  
            #inb07	  LIKE inb_file.inb07,		#批号  
            inb08         LIKE inb_file.inb08,          #单位
            inb09	  LIKE inb_file.inb09,#,		#数量  
            #inb15	  LIKE inb_file.inb15 		#理由码
            fifo_flag  LIKE tc_codesys_file.tc_codesys09 #先进先出否			
           END RECORD          
	DEFINE l_statu4    RECORD                  #返回员工和部门信息
            statu   LIKE type_file.chr1,     #状态
            gen01   LIKE gen_file.gen01,     #员工编码
            gen02   LIKE gen_file.gen02,     #员工姓名
            gem01   LIKE gem_file.gem01,     #部门编码
            gem02   LIKE gem_file.gem02,      #部门名称 
            fifo_flag  LIKE tc_codesys_file.tc_codesys09 #先进先出否			
           END RECORD 
	DEFINE l_statu5    RECORD                  #返回理由码
            statu   LIKE type_file.chr1,     #状态
            azf01   LIKE azf_file.azf01,     #理由码编码
            azf03   LIKE azf_file.azf03,     #理由码说明
			fifo_flag  LIKE tc_codesys_file.tc_codesys09 #先进先出否
           END RECORD                  
    DEFINE l_sql   STRING
    define l_fifo_flag like type_file.chr1
    
    LET l_barcode = aws_ttsrv_getParameter("barcode")   #传入条码
  
    IF cl_null(l_barcode) THEN
    	   LET g_status.code = -1
         LET g_status.description = '条码为空,请检查!'
         RETURN
    END IF  
  	select tc_codesys09 into l_fifo_flag from tc_codesys_file  #add by caojf20180428   
    SELECT COUNT(*) INTO l_n FROM ina_file,inb_file
     WHERE ina01=inb01 
       #AND ina00='1' 
       AND (ina00='1' OR ina00 = '2' OR ina00 = '5' OR ina00 = '6')
       AND inaconf='Y' AND inapost='N' AND ina01=l_barcode
    IF l_n>0 THEN 
    	 LET l_sql="SELECT '3',ina01,inb04,ima02,ima021,inb08,SUM(inb09) ",
    		  	  	  "FROM ina_file,inb_file,ima_file ",
    		  	  	  "WHERE ina01=inb01 and inb04=ima01 ",
    		  	 # 	  "AND ina00='1' AND inaconf='Y' and inapost='N' ",   #mark wanjz by 170207
    	#	  	  	  "AND (ina00='1' OR ina00 = '2') AND inaconf='Y' and inapost='N' ",   #mark wanjz by 170217 #add wanjz by 170207
    		  	  	  "AND (ina00='1' OR ina00 = '2' OR ina00 = '5' OR ina00 = '6') AND inaconf='Y' and inapost='N' ",   #add wanjz by 170217
    		  	  	  "AND ina01='",l_barcode,"' GROUP BY ina01,inb04,ima02,ima021,inb08"
    	 PREPARE ina_pre FROM l_sql
    	 DECLARE ina_c CURSOR FOR ina_pre
    	 FOREACH ina_c INTO l_statu3.*
		     let l_statu3.fifo_flag=l_fifo_flag  #add by caojf20180428
    	 	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu3))
    	 END FOREACH 
    ELSE 
    	 SELECT COUNT(*) INTO l_n FROM gen_file WHERE gen01=l_barcode AND genacti='Y' 
    	 IF l_n=1 THEN 
    	 	 LET l_statu4.statu='4'
        	 LET l_statu4.gen01=l_barcode
        	 SELECT gen02,gen03 INTO l_statu4.gen02,l_statu4.gem01 FROM gen_file WHERE gen01=l_barcode
        	 SELECT gem02 INTO l_statu4.gem02 FROM gem_file WHERE gem01=l_statu4.gem01
			 let l_statu4.fifo_flag=l_fifo_flag  #add by caojf20180428
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu4))
       ELSE 
       	 SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01=l_barcode AND azf09='4' #理由码
       	         IF l_n=1 THEN 
       	     	         LET l_statu5.statu='5'
    	 		 LET l_statu5.azf01=l_barcode
    	 		 SELECT azf03 INTO l_statu5.azf03 FROM azf_file WHERE azf01=l_barcode AND azf09='4'
				 let l_statu5.fifo_flag=l_fifo_flag  #add by caojf20180428
    	 		 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu5))
    	 	 ELSE 
    	 	 	 INITIALIZE g_barcode_n TO NULL 
    	 		 CALL cs_get_barcode_info(l_barcode)
    	 	       	        IF g_barcode_n.stat = '1' THEN 
		 		 	 LET l_statu1.statu='1'
		 		 	 LET l_statu1.imd01=g_barcode_n.imd01
		 		 	 LET l_statu1.imd02=g_barcode_n.imd02
		 		 	 LET l_statu1.ime02=g_barcode_n.ime02
		 		 	 LET l_statu1.ime03=g_barcode_n.ime03
					 let l_statu1.fifo_flag=l_fifo_flag  #add by caojf20180428
		 		 	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu1))
		 		 ELSE 
		 		 	 IF g_barcode_n.stat MATCHES '[2345]' THEN 
		 		 	 	 LET l_statu2.statu= '2'
		 		 	 	 LET l_statu2.barcode=l_barcode
		 		 	 	 LET l_statu2.ima01=g_barcode_n.ima01
		 		 	 	 LET l_statu2.ima02=g_barcode_n.ima02
		 		 	 	 LET l_statu2.ima021=g_barcode_n.ima021
		 		 	 	 LET l_statu2.batch=g_barcode_n.pihao
#		 		 	 	 LET l_statu2.qty=g_barcode_n.b_num
                         let l_statu2.fifo_flag=l_fifo_flag  #add by caojf20180428
		 		 	 	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu2))
		 		 	 ELSE 
		 		 	     LET g_status.code = -1
       		                             LET g_status.description = '条码有误,或者资料已过帐或未审核!'
            		                     RETURN
		 		 	 END IF 
  	 	 		 END IF 
       	          END IF 
    	 END IF 
    END IF 
    	
END FUNCTION

#add by lili 170109 ---s---
FUNCTION writeStringToFile(p_str,p_logname)
  DEFINE p_str      STRING
  DEFINE l_ch       base.Channel
  DEFINE p_logname  STRING
  DEFINE l_logFile  STRING
  
  IF p_logname IS NULL THEN
    LET l_logFile = "/u1/out/wscosttime.log"
  ELSE
    LET l_logFile = p_logname
  END IF
  LET l_ch = base.Channel.create()
  CALL l_ch.setDelimiter(NULL)
  CALL l_ch.openFile(l_logFile, "a")
  CALL l_ch.write(p_str)
END FUNCTION

FUNCTION getGuid()
  DEFINE l_uid       STRING
  DEFINE l_sb        base.StringBuffer
  LET l_uid = CURRENT HOUR TO FRACTION(5)
  LET l_sb = base.StringBuffer.create()
  CALL l_sb.append(l_uid)
  CALL l_sb.replace(":", "", 0)
  CALL l_sb.replace(".", "", 0)
  RETURN l_sb.toString()
END FUNCTION
#add by lili 170109 ---e---		
