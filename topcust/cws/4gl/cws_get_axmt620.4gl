# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_get_axmt670.4gl
# Descriptions...: 获取出货单相关信息
# Date & Author..: 20161222 by gujq
 
 
DATABASE ds
 
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../../tiptop/aba/4gl/barcode.global"

DEFINE g_uid        STRING          #add by lidj170109
DEFINE g_service    STRING          #add by lidj170109
DEFINE l_str        STRING          #add by lidj170109
DEFINE l_stime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_etime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_costtime INTERVAL HOUR TO FRACTION(3)
DEFINE l_stimestr STRING
DEFINE l_etimestr STRING
DEFINE l_logfile  STRING
                   
FUNCTION cws_get_axmt620_g()
     
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    #add by lidj170109-----str------
	  LET g_service = "cws_get_axmt620"
    LET g_uid = getGuid()
    LET l_logfile = "/u1/out/aws_ttsrv2costtime-",TODAY USING 'YYYYMMDD',".log"
    LET l_stimestr = CURRENT HOUR TO FRACTION(3)
    LET l_stime = l_stimestr
    LET l_str = g_uid," ",g_service," ",l_stimestr," Start"
    CALL writeStringToFile(l_str,l_logfile)
    #add by lidj170109-----end------  
    IF g_status.code = "0" THEN
       CALL cws_get_axmt620_process()
    END IF
    #add by lidj170109-----str------
    LET l_etimestr = CURRENT HOUR TO FRACTION(3)
    LET l_etime = l_etimestr
    LET l_str = g_uid," ",g_service," ",l_etimestr," End"
    CALL writeStringToFile(l_str,l_logfile)
    #add by lidj170109-----end------								
 
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
FUNCTION cws_get_axmt620_process()
DEFINE l_username LIKE type_file.chr20
DEFINE l_barcode  LIKE type_file.chr50
DEFINE l_n        LIKE type_file.num5
DEFINE l_length   LIKE type_file.num5
DEFINE l_node     om.DomNode
DEFINE l_imd    RECORD                  #返回库位和仓库信息
         statu   LIKE type_file.chr1,     #状态 1
         imd01   LIKE imd_file.imd01,     #仓库编码
         imd02   LIKE imd_file.imd02,     #仓库名称 
         ime02   LIKE ime_file.ime02,     #库位编码
         ime03   LIKE ime_file.ime03      #库位名称          
        END RECORD  
DEFINE l_ima    RECORD                  #返回料件信息
         statu   LIKE type_file.chr1,     #状态 2
         barcode LIKE type_file.chr50,    #批次条码
         ima01   LIKE ima_file.ima01,     #料件编码
         ima02   LIKE ima_file.ima02,     #品名
         ima021  LIKE ima_file.ima021,    #规格
         ima25   LIKE ima_file.ima25,     #单位
         batch   LIKE type_file.chr20,    #批次
         qty     LIKE sfs_file.sfs05      #数量
        END RECORD
DEFINE l_ogb    RECORD                  #
          statu   LIKE type_file.chr1,     #状态 3
          oga01   LIKE oga_file.oga01,     #通知单号
          ogb04   LIKE ogb_file.ogb04,     #料号
          ima02   LIKE ima_file.ima02,     #品名
          ima021  LIKE ima_file.ima021,    #规格
          ima25   LIKE ima_file.ima25,     #单位
          ogb12   LIKE ogb_file.ogb12      #数量
      END RECORD
DEFINE l_sql   STRING
    
    
    LET l_barcode = aws_ttsrv_getParameter("barcode")   #传入条码
  
    IF cl_null(l_barcode) THEN
    	   LET g_status.code = -1
         LET g_status.description = '条码为空,请检查!'
         RETURN
    END IF  
  	    
  	SELECT COUNT(*) INTO l_n FROM oga_file,ogb_file
     #WHERE oga01=ogb01 AND oga09='1' AND ogaconf='Y' AND ogapost='N' AND oga01=l_barcode            #mark by lidj170115
     WHERE oga01=ogb01 AND oga09 IN ('1','5') AND ogaconf='Y' AND ogapost='N' AND oga01=l_barcode    #add by lidj170115
    IF l_n>0 THEN
       LET l_sql="SELECT '3',oga01,ogb04,ima02,ima021,ima25,SUM(ogb12) ",
                        "FROM oga_file,ogb_file,ima_file ",
                        "WHERE oga01=ogb01 and ogb04=ima01 ",
                        #"AND oga09='1' and ogaconf='Y' and ogapost='N' ",     #mark by lidj170115
                        "AND oga09 IN ('1','5') and ogaconf='Y' and ogapost='N' ",  #add by lidj170115   
                        "AND oga01='",l_barcode,"' GROUP BY oga01,ogb04,ima02,ima021,ima25"
       PREPARE ogb_pre FROM l_sql
       DECLARE ogb_c CURSOR FOR ogb_pre
       FOREACH ogb_c INTO l_ogb.*
               CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_ogb))
       END FOREACH
    ELSE 
    	 INITIALIZE g_barcode_n TO NULL 
    	 CALL cs_get_barcode_info(l_barcode)
    	 IF g_barcode_n.stat = '1' THEN 
		 		 	LET l_imd.statu='1'
		 		 	LET l_imd.imd01=g_barcode_n.imd01
		 		 	LET l_imd.imd02=g_barcode_n.imd02
		 		 	LET l_imd.ime02=g_barcode_n.ime02
		 		 	LET l_imd.ime03=g_barcode_n.ime03
		 		 	CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_imd))
		 	 ELSE 
		 		  IF g_barcode_n.stat MATCHES '[2345]' THEN 
		 		  	 LET l_ima.statu= '2'
		 		  	 LET l_ima.barcode=l_barcode
		 		  	 LET l_ima.ima01=g_barcode_n.ima01
		 		  	 LET l_ima.ima02=g_barcode_n.ima02
		 		  	 LET l_ima.ima021=g_barcode_n.ima021
		 		  	 LET l_ima.batch=g_barcode_n.pihao
		 		  	 LET l_ima.ima25 = g_barcode_n.ima25
#		 		  	 LET l_ima.qty=g_barcode_n.b_num
		 		  	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_ima))
		 		  ELSE 
		 		  	 LET g_status.code = -1
       		   LET g_status.description = '条码有误,或者资料不符!'
       		   RETURN
		 		  END IF 
  	 	 END IF  
    END IF 
    	
END FUNCTION

#add by lidj170109-----str-----
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
#add by lidj170109-----end-----			
