# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 获取扫描条码信息
# Date & Author..: 20160612 by nihuan


DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../../tiptop/aba/4gl/barcode.global"

#stat状态
#1、仓库信息 2、物料
FUNCTION cs_get_barcode_info(p_barcode)
DEFINE p_barcode    LIKE type_file.chr1000
DEFINE l_cnt        LIKE type_file.num10,
       l_cnt1       LIKE type_file.num10,
       l_cnt2       LIKE type_file.num10,
       l_cnt3       LIKE type_file.num10,
       l_cnt4       LIKE type_file.num10    #add by sunll 170322
DEFINE l_sql        STRING
DEFINE l_ima01      LIKE ima_file.ima01
DEFINE l_imd20      LIKE imd_file.imd20
DEFINE l_bar        LIKE type_file.chr1000
DEFINE l_i,l_n,l_n2,l_length      LIKE type_file.num5

          
{DEFINE g_return    RECORD
	        imd01   LIKE imd_file.imd01,     #仓库编码  #仓库信息
          imd02   LIKE imd_file.imd02,     #仓库名称
	        ime02   LIKE ime_file.ime02,     #库位编码
          ime03   LIKE ime_file.ime03,     #库位名称
          
          ima01   LIKE ima_file.ima01,     #料号      #料号信息
          ima02   LIKE ima_file.ima02,     #品名
          ima021  LIKE ima_file.ima021     #规格
          b_pihao LIKE imgb_file.imgb04,   #批号     #原材料、四大厂、成品料
          b_num   LIKE img_file.img10,     #条码数量 #原材料、四大厂
          sfb01   LIKE sfb_file.sfb01,     #工单号   #栈板
          zbh     LIKE type_file.chr10,    #栈板号   #栈板
          nyr     LIKE type_file.chr10,    #年月日   #除非核心料外ALL
          oea10   LIKE oea_file.oea10,     #客户订单 #成品料
          
          stat    LIKE type_file.chr1      #状态#1、仓库信息 2、非核心物料3、栈板条码4、成品5、重要原材料&四大厂
         END RECORD }#移动到全局变量
   INITIALIZE g_barcode_n.* TO NULL
   
   ##条码规则：仓库%储位
   ############料件编号%生产年月日（或收货日期）_厂商代码%序号（3位）
   
   #获取条码分隔符
   LET l_i=0
   SELECT LENGTH(REGEXP_REPLACE(REPLACE(p_barcode,'%','@'),'[^@]+','')) INTO l_i FROM DUAL

   IF l_i=0 THEN 
   	  LET g_barcode_n.err_det='条码分隔符为空请检查!'
   	  RETURN
   END IF 	
   #获取分隔符的位置
   SELECT instr(p_barcode,'%',1,1) INTO l_n FROM dual	  #第一个分隔符位置
   SELECT instr(p_barcode,'%',1,2) INTO l_n2 FROM dual	#第二个分隔符位置
   LET l_length= LENGTH(p_barcode)
   ####一个分隔符就是物料条码
   #####1########仓库储位条码 
   IF l_i=1 THEN 
   	  LET g_barcode_n.imd01=p_barcode[1,l_n-1]
   	  LET g_barcode_n.ime02=p_barcode[l_n+1,l_length]
   	  LET l_cnt=0
   	  SELECT COUNT(*) INTO l_cnt FROM imd_file
   	  WHERE imd01 = g_barcode_n.imd01 AND imd20 = g_plant
   	  IF l_cnt=0  THEN 
   	  	 LET g_barcode_n.err_det='仓库编号不存在，请检查!'
   	  	 RETURN 
   	  END IF 
   	   
   	  LET l_cnt=0
   	  SELECT COUNT(*) INTO l_cnt FROM ime_file,imd_file 
   	  WHERE ime01=imd01 AND ime01 = g_barcode_n.imd01 
   	    AND ime02 = g_barcode_n.ime02 AND imd20 = g_plant
   	  IF l_cnt=0  THEN 
   	  	 LET g_barcode_n.err_det='仓库库位不匹配，请检查!'
   	  	 RETURN 
   	  END IF
   	  
   	  SELECT imd02 INTO g_barcode_n.imd02 FROM imd_file 
   	  WHERE imd01 = g_barcode_n.imd01 AND imd20 = g_plant	
   	  
   	  SELECT ime03 INTO g_barcode_n.ime03 FROM ime_file,imd_file 
   	  WHERE ime01=imd01 AND ime01 = g_barcode_n.imd01 
   	    AND ime02 = g_barcode_n.ime02 AND imd20 = g_plant
   	  
   	  LET g_barcode_n.stat='1'  #仓库	
   	  
   END IF
   
   #分隔符2个为物料条码
   IF l_i=2 THEN
   	  LET g_barcode_n.ima01=p_barcode[1,l_n-1]  #料号
   	  LET g_barcode_n.pihao=p_barcode[l_n+1,l_n2-1]   #批号
   	  
   	  LET l_cnt=0
   	  SELECT COUNT(*) INTO l_cnt FROM ima_file
   	  WHERE ima01=g_barcode_n.ima01 
   	  IF l_cnt=0  THEN 
   	  	 LET g_barcode_n.err_det='料号不存在，请检查!'
   	  	 RETURN 
   	  END IF
   	  SELECT ima02,ima021,ima25 INTO g_barcode_n.ima02,g_barcode_n.ima021,g_barcode_n.ima25
   	  FROM ima_file WHERE ima01=g_barcode_n.ima01
   	  	
   	  LET g_barcode_n.stat='2'  #物料	
   END IF	
   	 	
#   #检查为否为料件条码
#   LET l_cnt = 0
#   SELECT COUNT(*) INTO l_cnt FROM ibb_file WHERE ibb01 = l_bar
#       IF l_cnt = 0 AND g_return.stat != '3' THEN 
#   	LET g_status.code = -1
#   	      INITIALIZE g_return.* TO NULL
#          LET g_status.description = '条码不存在!'
#          LET g_success = "N"
#          RETURN
#   END IF

END FUNCTION
