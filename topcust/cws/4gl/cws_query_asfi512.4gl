# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 
# Date & Author..: by gujq 20161005


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global" 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
GLOBALS "../../../tiptop/aba/4gl/barcode.global"
#add by lili 170109 ---s---
GLOBALS 
  DEFINE g_uid        STRING
  DEFINE g_service    STRING
END GLOBALS
#add by lili 170109 ---e--- 
 
#[
# Description....: 提供取得 ERP 料件資料服務(入口 function)
# Date & Author..: 2007/02/12 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION cws_query_asfi512_g()
DEFINE l_str     STRING   #add by lili 170109 
DEFINE l_stime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_etime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_costtime INTERVAL HOUR TO FRACTION(3)
DEFINE l_stimestr STRING
DEFINE l_etimestr STRING
DEFINE l_logfile  STRING
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 料件編號資料                                                    #
    #--------------------------------------------------------------------------#
    #add by lili 170109 ---s---
    LET g_service = "cws_query_asfi512"

    LET g_uid = getGuid()
    LET l_logfile = "/u1/out/aws_ttsrv2costtime-",TODAY USING 'YYYYMMDD',".log"
    LET l_stimestr = CURRENT HOUR TO FRACTION(3)
    LET l_stime = l_stimestr
    LET l_str = g_uid," ",g_service," ",l_stimestr," Start"
    CALL writeStringToFile(l_str,l_logfile) 
    #add by lili 170109 ---e---
    IF g_status.code = "0" THEN
       CALL cws_query_asfi512_process()
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
# Description....: 查詢 ERP 料件編號資料
# Date & Author..: 2007/02/06 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION cws_query_asfi512_process()
DEFINE l_sfs   RECORD 
         sfp01  LIKE sfp_file.sfp01,
         sfs04  LIKE sfs_file.sfs04,
         ima02  LIKE ima_file.ima02,
         ima021 LIKE ima_file.ima021,
         sfs05  LIKE sfs_file.sfs05,
         statu   LIKE type_file.chr1  #6
     END RECORD	
DEFINE l_sfs1  RECORD
           sfs05  LIKE sfs_file.sfs05,
           ima02  LIKE ima_file.ima02,
           ima021 LIKE ima_file.ima02,
           sfs05a  LIKE sfs_file.sfs05,  # 最大退料量
           statu    LIKE type_file.chr1
        END RECORD
DEFINE l_imd    RECORD
	        imd01   LIKE imd_file.imd01,     #仓库编码  #仓库信息
          imd02   LIKE imd_file.imd02,     #仓库名称
	        ime02   LIKE ime_file.ime02,     #库位编码
          ime03   LIKE ime_file.ime03,     #库位名称
          statu    LIKE type_file.chr1      #状态#1、仓库信息 2、非核心物料3、栈板条码4、成品5、重要原材料&四大厂
         END RECORD
DEFINE l_ima1    RECORD
          ima01   LIKE ima_file.ima01,     #料号      #料号信息
          ima02   LIKE ima_file.ima02,     #品名
          ima021  LIKE ima_file.ima021,    #规格
          statu    LIKE type_file.chr1      #状态#1、仓库信息 2、非核心物料3、栈板条码4、成品5、重要原材料&四大厂
         END RECORD
DEFINE l_ima2    RECORD
          sfb01   LIKE sfb_file.sfb01,     #工单号   #栈板
          zbh     LIKE type_file.chr10,    #栈板号   #栈板
          nyr     LIKE type_file.chr10,    #年月日   #除非核心料外ALL
          statu    LIKE type_file.chr1      #状态#1、仓库信息 2、非核心物料3、栈板条码4、成品5、重要原材料&四大厂
         END RECORD
DEFINE l_ima3    RECORD
          ima01   LIKE ima_file.ima01,     #料号      #料号信息
          ima02   LIKE ima_file.ima02,     #品名
          ima021  LIKE ima_file.ima021,    #规格
          b_pihao LIKE imgb_file.imgb04,   #批号     #原材料、四大厂、成品料
          nyr     LIKE type_file.chr10,    #年月日   #除非核心料外ALL
          oea10   LIKE oea_file.oea10,     #客户订单 #成品料
          statu    LIKE type_file.chr1      #状态#1、仓库信息 2、非核心物料3、栈板条码4、成品5、重要原材料&四大厂
         END RECORD
DEFINE l_ima4    RECORD
          ima01   LIKE ima_file.ima01,     #料号      #料号信息
          ima02   LIKE ima_file.ima02,     #品名
          ima021  LIKE ima_file.ima021,    #规格
          b_pihao LIKE imgb_file.imgb04,   #批号     #原材料、四大厂、成品料
          b_num   LIKE img_file.img10,     #条码数量 #原材料、四大厂
          nyr     LIKE type_file.chr10,    #年月日   #除非核心料外ALL
          statu    LIKE type_file.chr1      #状态#1、仓库信息 2、非核心物料3、栈板条码4、成品5、重要原材料&四大厂
         END RECORD
DEFINE l_ima    RECORD
	      ima01   LIKE ima_file.ima01,
	      ima02   LIKE ima_file.ima02,
	      ima021  LIKE ima_file.ima021,
	      img10   LIKE img_file.img10,
	      pici    LIKE type_file.chr100,
	      statu    LIKE type_file.chr1 #1超领单、2仓库、3料号
	     END RECORD
DEFINE l_wc    STRING
DEFINE l_sql   STRING
DEFINE l_node  om.DomNode
DEFINE l_mm    LIKE type_file.num5
DEFINE l_ime01  LIKE ime_file.ime01
DEFINE l_ime   RECORD 
               ime01 LIKE ime_file.ime01
               END RECORD 

DEFINE   l_cnt    LIKE type_file.num5
DEFINE   l_srg05  LIKE srg_file.srg05,
         l_sfa063  LIKE sfa_file.sfa063,
         l_sfa06   LIKE sfa_file.sfa06,
         l_sfa161  LIKE sfa_file.sfa161,
         l_ima01   LIKE ima_file.ima01,
         l_sfs03  LIKE sfs_file.sfs03,
         l_sfs04  LIKE sfs_file.sfs04
         
DEFINE   l_wc1    LIKE type_file.chr1000
DEFINE l_n        LIKE type_file.num5

   LET l_wc = aws_ttsrv_getParameter("barcode")   #取由呼叫端呼叫時給予的 SQL Condition
   LET l_wc1 = l_wc
   IF cl_null(l_wc) THEN #如果为空，就是查询超领单 #改为为空就报错
   	  LET g_status.code = -1
      LET g_status.description = '条码为空,请检查!'
      RETURN
   ELSE 
      #判断接受的值是否为(超领单 库位 箱条码)
      SELECT  COUNT(*) INTO  l_cnt FROM sfp_file WHERE sfp01=l_wc1 AND sfp06='2' and sfpconf='Y' AND sfp04='N'
      IF l_cnt>0 THEN    #表明是入超领单
         LET l_sql=" SELECT sfp01,sfs04,ima02,ima021,SUM(sfs05),'6' from sfp_file",
                   " inner join sfs_file  on   sfp01=sfs01 ",
                   " inner join ima_file on  ima01=sfs04 ",
                   " WHERE sfp06='2' and sfpconf='Y' AND sfp04='N' AND sfp01='",l_wc1,"' ",
                   "  GROUP BY sfp01,sfs04,ima02,ima021"
         DECLARE sfs1_cur CURSOR FROM l_sql
         IF SQLCA.SQLCODE THEN
           LET g_status.sqlcode = SQLCA.SQLCODE
           RETURN
         END IF
         FOREACH sfs1_cur INTO l_sfs.* 
           CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_sfs))    
         END FOREACH 
   
      ELSE
         CALL cs_get_barcode_info(l_wc) #找不到工单号就检查是否为仓库、料件编号
   	     CASE g_barcode_n.stat
   	     	 WHEN '1'
   	     	    LET l_imd.imd01 = g_barcode_n.imd01
   	     	    LET l_imd.imd02 = g_barcode_n.imd02
   	     	    LET l_imd.ime02 = g_barcode_n.ime02
   	     	    LET l_imd.ime03 = g_barcode_n.ime03
   	     	    LET l_imd.statu = g_barcode_n.stat
   	     	    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_imd))
   	     	 WHEN '2'
   	     	    LET l_ima1.ima01 = g_barcode_n.ima01
   	     	    LET l_ima1.ima02 = g_barcode_n.ima02
   	     	    LET l_ima1.ima021 = g_barcode_n.ima021
   	     	    LET l_ima1.statu = g_barcode_n.stat
   	     	    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_ima1))
#   	     	 WHEN '3'
#   	     	    LET l_ima2.sfb01 = g_barcode_n.sfb01
#   	     	    LET l_ima2.zbh = g_barcode_n.zbh
#   	     	    LET l_ima2.nyr = g_barcode_n.nyr
#   	     	    LET l_ima2.statu = g_barcode_n.stat
#   	     	    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_ima2))
#   	     	 WHEN '4'
#   	     	    LET l_ima3.ima01 = g_barcode_n.ima01
#   	     	    LET l_ima3.ima02 = g_barcode_n.ima02
#   	     	    LET l_ima3.ima021 = g_barcode_n.ima021
#   	     	    LET l_ima3.b_pihao = g_barcode_n.b_pihao
#   	     	    LET l_ima3.nyr = g_barcode_n.nyr
#   	     	    LET l_ima3.oea10 = g_barcode_n.oea10
#   	     	    LET l_ima3.statu = g_barcode_n.stat
#   	     	    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_ima3))
#   	     	 WHEN '5'	           
#   	     	 	  LET l_ima4.ima01 = g_barcode_n.ima01
#   	     	 	  LET l_ima4.ima02 = g_barcode_n.ima02
#   	     	 	  LET l_ima4.ima021 = g_barcode_n.ima021
#   	     	 	  LET l_ima4.b_pihao = g_barcode_n.b_pihao
#   	     	 	  LET l_ima4.b_num = g_barcode_n.b_num
#   	     	 	  LET l_ima4.nyr = g_barcode_n.nyr
#   	     	 	  LET l_ima4.statu = g_barcode_n.stat
#   	     	 	  CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_ima4))
   	     END CASE
      END  IF
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
