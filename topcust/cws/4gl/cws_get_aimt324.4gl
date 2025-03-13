# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_get_aimt324.4gl
# Descriptions...: 获取生产调拨单相关信息
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
                   
FUNCTION cws_get_aimt324()
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
    LET g_service = "cws_get_aimt324"

    LET g_uid = getGuid()
    LET l_logfile = "/u1/out/aws_ttsrv2costtime-",TODAY USING 'YYYYMMDD',".log"
    LET l_stimestr = CURRENT HOUR TO FRACTION(3)
    LET l_stime = l_stimestr
    LET l_str = g_uid," ",g_service," ",l_stimestr," Start"
    CALL writeStringToFile(l_str,l_logfile) 
    #add by lili 170109 ---e---
    IF g_status.code = "0" THEN
       CALL cws_get_aimt324_process()
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
FUNCTION cws_get_aimt324_process()
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
            ime03   LIKE ime_file.ime03      #库位名称
           END RECORD       
   DEFINE l_statu2    RECORD                  #返回料件信息
            statu   LIKE type_file.chr1,     #状态
            barcode LIKE type_file.chr50,    #批次条码
            ima01   LIKE ima_file.ima01,     #料件编码
            ima02   LIKE ima_file.ima02,     #品名
            ima021  LIKE ima_file.ima021,    #规格
            ima25   LIKE ima_file.ima25,     #单位
            batch   LIKE type_file.chr20,    #批次
            qty     LIKE sfs_file.sfs05      #数量
           END RECORD
   DEFINE l_statu3    RECORD                  #返回调拨单信息
            statu   	LIKE type_file.chr1,     #状态
            imm02	  	LIKE imm_file.imm02,		#调拨日期
            imm01   	LIKE imm_file.imm01,		#调拨单号
            imm14	  	LIKE imm_file.imm14,		#申请部门
            imm16	  	LIKE imm_file.imm16,		#申请人
            #imn02		LIKE imn_file.imn02,		#项次
            #imn04		LIKE imn_file.imn04,		#拨出仓库
            #imn15		LIKE imn_file.imn15,		#拨入仓库
            imn03		  LIKE imn_file.imn03,		#料号
            imn041    LIKE imn_file.imn041,   #拨出营运中心编号
            imn151    LIKE imn_file.imn151,   #拨入营运中心编号
            imn10		  LIKE imn_file.imn10,		#数量
            ima02		  LIKE ima_file.ima02,		#品名
            ima021	  LIKE ima_file.ima021		#规格
           END RECORD                                     
    DEFINE l_sql   STRING
    
    LET l_barcode = aws_ttsrv_getParameter("barcode")   #传入条码
  
    IF cl_null(l_barcode) THEN
    	   LET g_status.code = -1
         LET g_status.description = '条码为空,请检查!'
         RETURN
    END IF
    
    SELECT COUNT(*) INTO l_n FROM imm_file,imn_file
     WHERE imm01=imn01 AND (immconf='Y' OR imm04 = 'Y') AND imm03='N' AND imm01=l_barcode
    IF l_n>0 THEN 
    	 SELECT COUNT(DISTINCT imn15||imn16) INTO l_n FROM imm_file,imn_file
    	  WHERE imm01=imn01 AND immconf='Y' AND imm03='N' AND imm01=l_barcode
    	 IF l_n>1 THEN  
    	 	 LET g_status.code=-1
    	 	 LET g_status.description='该调拨单有多个拨入仓库库位'
    	 	 RETURN 
    	 ELSE 
    	 	 LET l_sql="SELECT '3',imm02,imm01,imm14,imm16,imn03,imn041,imn151,SUM(imn10),ima02,ima021 ",
    	 		  	  "FROM imm_file,imn_file,ima_file ",
    	 		  	  "WHERE imm01=imn01 and imn03=ima01 ",
    	 		  	  "AND (immconf='Y' OR imm04 = 'Y') and imm03='N' ",
    	 		  	  "AND imm01='",l_barcode,"' GROUP BY imm02,imm01,imm14,imm16,imn03,ima02,ima021,imn041,imn151"
    	 	 PREPARE imn_pre FROM l_sql
    	 	 DECLARE imn_c CURSOR FOR imn_pre
    	 	 FOREACH imn_c INTO l_statu3.*
    	 	 	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu3))
    	 	 END FOREACH 
    	 END IF 
    ELSE 
    	 INITIALIZE g_barcode_n TO NULL 
  	 	 CALL cs_get_barcode_info(l_barcode)
  	 	 IF g_barcode_n.stat = '1' THEN 
		 	 LET l_statu1.statu='1'
		 	 LET l_statu1.imd01=g_barcode_n.imd01
		 	 LET l_statu1.imd02=g_barcode_n.imd02
		 	 LET l_statu1.ime02=g_barcode_n.ime02
		 	 LET l_statu1.ime03=g_barcode_n.ime03
		 	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu1))
		 ELSE 
		 	 IF g_barcode_n.stat MATCHES '[2345]' THEN 
		 	 	 LET l_statu2.statu= '2'
		 	 	 LET l_statu2.barcode=l_barcode
		 	 	 LET l_statu2.ima01=g_barcode_n.ima01
		 	 	 LET l_statu2.ima02=g_barcode_n.ima02
		 	 	 LET l_statu2.ima021=g_barcode_n.ima021
		 	 	 LET l_statu2.ima25=g_barcode_n.ima25
		 	 	 LET l_statu2.batch=g_barcode_n.pihao
#		 	 	 LET l_statu2.qty=g_barcode_n.b_num
		 	 	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_statu2))
		 	 ELSE 
		 	 	 #LET g_status.code = -1
         #    LET g_status.description = '条码有误,请检查!'
         #    RETURN
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
