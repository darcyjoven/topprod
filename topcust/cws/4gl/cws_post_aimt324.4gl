# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: cws_post_aimt324
# Descriptions...: 调拨单过账
# Date & Author..: 2016/10/13 by shids
# Memo...........:
#
#}
 
 
DATABASE ds
 
 
GLOBALS "../../../tiptop/config/top.global" 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
GLOBALS "../../../tiptop/aba/4gl/barcode.global"
#add by lili 170109 ---s---
GLOBALS 
  DEFINE g_uid        STRING
  DEFINE g_service    STRING
  DEFINE g_vmi        LIKE type_file.chr1
  DEFINE g_vmi_i      LIKE type_file.num5          #add wanjz by 170221 
END GLOBALS
#add by lili 170109 ---e---
 
#[
# Description....: 提供调拨单过账服務(入口 function)
# Date & Author..: 2016/10/13 by shids
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION cws_post_aimt324_g()
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
    LET g_service = "cws_post_aimt324"

    LET g_uid = getGuid()
    LET l_logfile = "/u1/out/aws_ttsrv2costtime-",TODAY USING 'YYYYMMDD',".log"
    LET l_stimestr = CURRENT HOUR TO FRACTION(3)
    LET l_stime = l_stimestr
    LET l_str = g_uid," ",g_service," ",l_stimestr," Start"
    CALL writeStringToFile(l_str,l_logfile) 
    #add by lili 170109 ---e---
    IF g_status.code = "0" THEN
       CALL cws_post_aimt324_process()
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
    DROP TABLE t324_file
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 料件編號資料
# Date & Author..: 2016/10/10 shdis
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION cws_post_aimt324_process()
DEFINE l_i,l_j,l_n,l_nn	LIKE type_file.num5
DEFINE l_imn	  RECORD 
			imn02			LIKE imn_file.imn02,
			imn03			LIKE imn_file.imn03,
			imn10			LIKE imn_file.imn10
						END RECORD 
DEFINE l_detail		DYNAMIC ARRAY of RECORD 
	    imm01     LIKE imm_file.imm01,
			barcode		LIKE type_file.chr100,
			ima01			LIKE ima_file.ima01,
			imn04 		LIKE imn_file.imn04,
			imn05 		LIKE imn_file.imn05,
			imn15			LIKE imn_file.imn15,
			imn16			LIKE imn_file.imn16,
			imn04_1   LIKE imn_file.imn04,
			imn05_1   LIKE imn_file.imn05,
			batch			LIKE type_file.chr50,
			qty			  LIKE inb_file.inb09
						END RECORD 
DEFINE l_tlfb		RECORD LIKE tlfb_file.*
DEFINE l_imm01		LIKE imm_file.imm01
DEFINE l_sql      STRING
DEFINE l_cnt      LIKE type_file.num10,
       l_cnt1     LIKE type_file.num10,
       l_cnt2     LIKE type_file.num10,
       l_cnt3     LIKE type_file.num10
DEFINE l_cnt4     LIKE type_file.num10
DEFINE l_node1    om.DomNode,
       l_node2    om.DomNode,
       l_node3    om.DomNode
DEFINE l_node  	  om.DomNode
DEFINE l_ibb		  RECORD LIKE ibb_file.*
DEFINE l_ima01	  LIKE ima_file.ima01

   CREATE TEMP TABLE t324_file(
                            imm01     LIKE imm_file.imm01,
                            barcode		LIKE type_file.chr100,
			                      ima01			LIKE ima_file.ima01,
			                      imn04 		LIKE imn_file.imn04,
			                      imn05 		LIKE imn_file.imn05,
			                      imn15			LIKE imn_file.imn15,
			                      imn16			LIKE imn_file.imn16,
			                      imn04_1   LIKE imn_file.imn04,
			                      imn05_1   LIKE imn_file.imn05,
			                      batch			LIKE type_file.chr50,
			                      qty			  LIKE inb_file.inb09)
   DROP TABLE aimt324_temp
   LET l_sql ="CREATE GLOBAL TEMPORARY TABLE aimt324_temp AS SELECT * FROM imn_file WHERE 1=2"
   PREPARE aimt324_temp_work_tab FROM l_sql
   EXECUTE aimt324_temp_work_tab  
   LET g_success='Y' 
   BEGIN WORK
   LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
   IF l_cnt1 = 0 THEN
   	  LET g_status.code = "-1"
      LET g_status.description = "No recordset processed!"
      RETURN
   END IF
   FOR l_i=1 TO l_cnt1
   	  LET l_ima01=''
   	  LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")        #目前處理單檔的 XML 節點
   	  LET l_imm01 = aws_ttsrv_getRecordField(l_node1, "imm01")  		  #调拨单号
      #add by zhaopeng170313 s  
      SELECT COUNT(1) INTO l_nn FROM imm_file WHERE imm01 = l_imm01 AND immconf = 'Y' AND imm03 ='N' 
      IF l_nn = 0 THEN
        LET g_status.code = "-1"
        LET g_status.description = "该调拨单不是已审核未过账单据！"
        RETURN
      END IF 
   	  #add by zhaopeng170313 e
   	  #LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "imn_file")       #取得第一單身共有幾筆單身資料
   	  #IF l_cnt2 = 0 THEN 
      #  	LET g_status.code = "mfg-009"   #必須有單身資料
      #  	EXIT FOR
      #  END IF
      #  INITIALIZE l_imn TO NULL 
   	  #FOR l_j=1 TO l_cnt2
   	  #	LET l_node2 = aws_ttsrv_getDetailRecord(l_node1,l_j,"imn_file")   #目前單身的 XML 節點
   	  #	LET l_imn.imn02 = aws_ttsrv_getRecordField(l_node2, "imn02")  
   	  #	LET l_imn.imn03 = aws_ttsrv_getRecordField(l_node2, "imn03") 
   	  #	LET l_imn.imn10 = aws_ttsrv_getRecordField(l_node2, "imn10") 
   	  #	UPDATE imn_file SET imn10=l_imn.imn10
      #   	 WHERE imn01=l_imm01 AND imn02=l_imn.imn02 AND imn03=l_imn.imn03
   	  #END FOR 
   	
   	  LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "detail_file")       #取得第二單身共有幾筆單身資料
   	  IF l_cnt3 = 0 THEN 
      	 LET g_status.code = "mfg-009"   #必須有單身資料
      	 EXIT FOR
      END IF
      INITIALIZE l_detail TO NULL 
      FOR l_j=1 TO l_cnt3
      	 LET l_node3 = aws_ttsrv_getDetailRecord(l_node1,l_j,"detail_file")   #目前單身的 XML 節點
      	 LET l_detail[l_j].imm01 = l_imm01                                            #单号
      	 LET l_detail[l_j].barcode = aws_ttsrv_getRecordField(l_node3, "barcode")			#料号条码
      	 CALL cs_get_barcode_info(l_detail[l_j].barcode)
#         IF g_return.stat = 5 THEN
#            SELECT instr(l_detail[l_j].barcode, '%',1,2) INTO l_cnt4 FROM DUAL #找第二个%的位置
#            LET l_detail[l_j].barcode = l_detail[l_j].barcode[1,l_cnt4-1]
#         END IF 
      	 LET l_detail[l_j].ima01=aws_ttsrv_getRecordField(l_node3, "ima01")			      #料号
      	 LET l_detail[l_j].imn04=aws_ttsrv_getRecordField(l_node3, "imn04")			      #拨出仓库
         LET l_detail[l_j].imn05=aws_ttsrv_getRecordField(l_node3, "imn05")			      #拨出库位
      	 LET l_detail[l_j].imn15=aws_ttsrv_getRecordField(l_node3, "imn15")			      #拨入仓库
      	 LET l_detail[l_j].imn16=aws_ttsrv_getRecordField(l_node3, "imn16")			      #拨入库位
      	 IF cl_null(l_detail[l_j].imn04) THEN LET l_detail[l_j].imn04 = ' ' END IF
     # 	 CALL get_vmi_store(l_imm01,l_detail[l_j].imn04,l_detail[l_j].imn05,l_detail[l_j].imn15,l_detail[l_j].imn16)  #mark wanjz by 170222
      	    #RETURNING l_detail[l_j].imn04,l_detail[l_j].imn05,l_detail[l_j].imn15,l_detail[l_j].imn16
      	 LET l_detail[l_j].batch=aws_ttsrv_getRecordField(l_node3, "batch")			      #批号
      	 LET l_detail[l_j].qty = aws_ttsrv_getRecordField(l_node3, "qty")			        #数量
      	 SELECT COUNT(*) INTO l_cnt FROM ibb_file 
      	  WHERE ibb01=l_detail[l_j].barcode AND ibb11='Y' AND ibbacti='Y'
      	 IF l_cnt=0 THEN 
      		  INITIALIZE l_ibb TO NULL 
      		  LET l_ibb.ibb01=l_detail[l_j].barcode      #条码编号
            LET l_ibb.ibb02='K'            #条码产生时机点
            LET l_ibb.ibb03=l_imm01		    #来源单号
            LET l_ibb.ibb04=0              #来源项次
            LET l_ibb.ibb05=0              #包号
            LET l_ibb.ibb06=l_detail[l_j].ima01        #料号
            LET l_ibb.ibb11='Y'            #使用否         
            LET l_ibb.ibb12=0              #打印次数
            LET l_ibb.ibb13=0              #检验批号(分批检验顺序)
            LET l_ibb.ibbacti='Y'          #资料有效码
#            LET l_ibb.ibb17=l_detail[l_j].batch       #批号
#            LET l_ibb.ibb14=l_detail[l_j].qty        #数量
#            LET l_ibb.ibb20=g_today        #生成日期
            INSERT INTO ibb_file VALUES(l_ibb.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'
               LET g_status.code = "-1"
               LET g_status.description = "插入ibb_file有误!"
               RETURN
            END IF
      	 END IF
      	 INSERT INTO t324_file VALUES(l_detail[l_j].*)
      END FOR 
      CALL l_detail.deleteElement(l_j)
      
      IF g_success = "Y" THEN
         CALL exc_item_aimt324(l_imm01)
      END IF
#      IF g_success = 'Y' THEN 
#           CALL get_vmi_store(l_imm01)
#      END IF 
      IF g_success = "Y" THEN 
         LET g_prog='aimt324'
		     CALL t324sub_s(l_imm01,'','',g_today)
		     LET g_prog='aws_ttsrv2'
		  END IF
		  IF g_success='N' THEN
   		   EXIT FOR 
   	  END IF
   		
   	  FOR l_j=1 TO l_detail.getlength()		
   		   #拨出段条码库存异动
   		   INITIALIZE g_tlfb TO NULL  
   		   LET g_tlfb.tlfb01=l_detail[l_j].barcode
   		   LET g_tlfb.tlfb02=l_detail[l_j].imn04
   		   LET g_tlfb.tlfb03=l_detail[l_j].imn05
   		   LET g_tlfb.tlfb04=l_detail[l_j].batch
   		   LET g_tlfb.tlfb05=l_detail[l_j].qty
   		   LET g_tlfb.tlfb09 = l_imm01
         LET g_tlfb.tlfb08 = 0 
         LET g_tlfb.tlfb07 = l_imm01
         LET g_tlfb.tlfb10 = ' '  
         LET g_tlfb.tlfb905= l_imm01
         LET g_tlfb.tlfb906= ' '         
         LET g_tlfb.tlfb06 = -1   #出库
         LET g_tlfb.tlfb16 = '条码枪'         
         LET g_tlfb.tlfb17 = ' '             #杂发理由码
         LET g_tlfb.tlfb18 = ' '             #产品分类码 
         LET g_tlfb.tlfb19 ='Y'               #扣账否为N
#         IF NOT cs_chk_imd(g_tlfb.tlfb02,g_plant) THEN
#            LET g_tlfb.tlfb19 = 'P'
#         END IF
         CALL s_web_tlfb('','','','','')  #更新条码异动档
   		   IF g_tlfb.tlfb19 = 'P' THEN
   		   ELSE
   		      LET l_sql =" SELECT COUNT(*) FROM imgb_file ",
                       "WHERE imgb01='",g_tlfb.tlfb01,"'",
                       " AND imgb02='",g_tlfb.tlfb02,"'",
                       " AND imgb03='",g_tlfb.tlfb03,"'" ,
                       " AND imgb04='",g_tlfb.tlfb04,"'"
                       
            PREPARE i510_imgb_pre FROM l_sql
            EXECUTE i510_imgb_pre INTO l_n
            IF l_n = 0 THEN #没有imgb_file，新增imgb_file
               CALL s_ins_imgb(g_tlfb.tlfb01,
                     g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,'')
            ELSE
               CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
                g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                g_tlfb.tlfb05,g_tlfb.tlfb06,'') 
            END IF	
         END IF
         
         #拨入段条码库存异动 #因考虑后期倒扣时无法关联到条码，故这里只做拨出异动记录（相当于条码库存杂发,账务库存正常）
   		   INITIALIZE g_tlfb TO NULL  
   		   LET g_tlfb.tlfb01=l_detail[l_j].barcode
   		   IF cl_null(l_detail[l_j].imn15) THEN
   		      SELECT imn15,imn16 INTO l_detail[l_j].imn15,l_detail[l_j].imn16 FROM imn_file WHERE imn01 = l_imm01 AND imn03 = l_detail[l_j].ima01
   		      IF cl_null(l_detail[l_j].imn16) THEN LET l_detail[l_j].imn16 = ' ' END IF
   		      IF cl_null(l_detail[l_j].imn15) THEN 
   		      	 LET g_status.code=-1
   	  	       LET g_status.sqlcode=-1
   	  	       LET g_status.description="拨入仓库为空！"
   		      END IF	
   		   END IF
   		   LET g_tlfb.tlfb02=l_detail[l_j].imn15
   		   IF cl_null(l_detail[l_j].imn16) OR l_detail[l_j].imn16 = ' ' THEN
   		       LET g_tlfb.tlfb03=l_detail[l_j].imn15
   		   ELSE
   		   	   LET g_tlfb.tlfb03=l_detail[l_j].imn16    
   		   END IF
   		   LET g_tlfb.tlfb04=l_detail[l_j].batch
   		   LET g_tlfb.tlfb05=l_detail[l_j].qty
   		   LET g_tlfb.tlfb09 = l_imm01
         LET g_tlfb.tlfb08 = 0 
         LET g_tlfb.tlfb07 = l_imm01
         LET g_tlfb.tlfb10 = ' '  
         LET g_tlfb.tlfb905= l_imm01
         LET g_tlfb.tlfb906= ' '         
         LET g_tlfb.tlfb06 = 1   #入库
         LET g_tlfb.tlfb16 = '条码枪'         
         LET g_tlfb.tlfb17 = ' '             #杂发理由码
         LET g_tlfb.tlfb18 = ' '             #产品分类码 
         LET g_tlfb.tlfb19 ='Y'               #扣账否为N
#         IF NOT cs_chk_imd(g_tlfb.tlfb02,g_plant) THEN
#            LET g_tlfb.tlfb19 = 'P'
#         END IF
         CALL s_web_tlfb('','','','','')  #更新条码异动档
   		   #
   		   IF g_tlfb.tlfb19 = 'P' THEN
   		   ELSE
   		      LET l_sql =" SELECT COUNT(*) FROM imgb_file ",
                       "WHERE imgb01='",g_tlfb.tlfb01,"'",
                       " AND imgb02='",g_tlfb.tlfb02,"'",
                       " AND imgb03='",g_tlfb.tlfb03,"'" ,
                       " AND imgb04='",g_tlfb.tlfb04,"'"
                       
            PREPARE i510_imgb_pre1 FROM l_sql
            EXECUTE i510_imgb_pre1 INTO l_n
            IF l_n = 0 THEN #没有imgb_file，新增imgb_file
               CALL s_ins_imgb(g_tlfb.tlfb01,
                     g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,'')
            ELSE
               CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
                g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                g_tlfb.tlfb05,g_tlfb.tlfb06,'') 
            END IF	
         END IF	
   	  END FOR 
   END FOR 
   IF g_success = 'Y' THEN 
   	  LET g_status.code=0
   	  LET g_status.sqlcode=0
   	  LET g_status.description="调拨单过账成功"
      COMMIT WORK 
   ELSE
   	  IF g_status.code = 0 THEN
   	     LET g_status.code=-1
   	     LET g_status.sqlcode=-1
   	     LET g_status.description="调拨单过账失败"
   	  END IF
      ROLLBACK WORK 
   END IF
END FUNCTION
#mark wanjz by 170222 start -----------
#FUNCTION get_vmi_store(p_imn01,p_imn04,p_imn05,p_imn15,p_imn16)
#DEFINE p_imn01       LIKE imn_file.imn01
#DEFINE p_imn04       LIKE imd_file.imd01
#DEFINE p_imn05       LIKE imn_file.imn05
#DEFINE p_imn15       LIKE imd_file.imd01
#DEFINE p_imn16       LIKE imn_file.imn05
#DEFINE l_imn04       LIKE imn_file.imn04
#DEFINE l_imn05       LIKE imn_file.imn05
#DEFINE l_imn15       LIKE imn_file.imn15
#DEFINE l_imn16       LIKE imn_file.imn16
#DEFINE l_type        LIKE type_file.chr1
#DEFINE l_cnt         LIKE type_file.num5
#DEFINE l_imn04_1     LIKE imn_file.imn04
#DEFINE l_imn05_1     LIKE imn_file.imn05
#   
#   LET l_imn04_1 = p_imn04
#   LET l_imn05_1 = p_imn05
#   #因为只扫入拨出仓库，所以就判断这个
#   SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01 = p_imn04 AND ime02 = p_imn05 AND ime12 = '1' #判断扫出仓库为是否为vmi仓
#   IF l_cnt = 0 THEN
#      #RETURN #p_imn04,p_imn05,p_imn15,p_imn16
#      SELECT COUNT(*) INTO l_cnt FROM ime_file,imn_file WHERE imn15 = ime01 AND imn16 = ime02 AND imn01 = p_imn01 AND ime12 = '1' #判断是否存在vmi拨入仓库
#      IF l_cnt = 0 THEN
#         RETURN
#3      END IF
#   END IF
#   
#   #SELECT ime01,ime02 INTO p_imn04,p_imn05 FROM ime_file WHERE ime02 = p_imn05 AND ime12 = '2'
#   #SELECT imn04,imn05,imn15,imn16 INTO l_imn04,l_imn05,l_imn15,l_imn16 FROM imn_file WHERE imn01 = p_imn01 AND imn04 = p_imn04 AND imn05 = p_imn05
#3   #
#3   #IF cl_null(l_imn04) THEN
#   #   SELECT imn04,imn05,imn15,imn16 INTO l_imn04,l_imn05,l_imn15,l_imn16 FROM imn_file WHERE imn01 = p_imn01 AND imn15 = p_imn04 AND imn16 = p_imn05
#3   #END IF
#   LET g_prog = 'cimt324' 
#   CALL t324_vmi(p_imn01)#
#   LET g_prog = 'aws_ttsrv2'
#   IF g_success = 'Y' THEN
#      LET g_vmi = '1'
#   END IF
#   #RETURN l_imn04,l_imn05,l_imn15,l_imn16
#END FUNCTION
#mark wanjz by 170222 end  -----------
#add wanjz by 170222 start ============
FUNCTION get_vmi_store(p_imn01)
DEFINE p_imn01       LIKE imn_file.imn01
#DEFINE p_imn04       LIKE imd_file.imd01
#DEFINE p_imn05       LIKE imn_file.imn05
#DEFINE p_imn15       LIKE imd_file.imd01
#DEFINE p_imn16       LIKE imn_file.imn05
DEFINE l_imn04       LIKE imn_file.imn04
DEFINE l_imn05       LIKE imn_file.imn05
DEFINE l_imn15       LIKE imn_file.imn15
DEFINE l_imn16       LIKE imn_file.imn16
DEFINE l_type        LIKE type_file.chr1
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_imn04_1     LIKE imn_file.imn04
DEFINE l_imn05_1     LIKE imn_file.imn05
DEFINE l_imn04glb    LIKE imn_file.imn04
DEFINE l_imn05glb    LIKE imn_file.imn05
DEFINE l_sql1        STRING 

      LET g_vmi_i = 0

   LET l_sql1 = " SELECT imn04,imn05 FROM t324_file "

     PREPARE t001_ipb_imn FROM l_sql1
     DECLARE t001_imn CURSOR FOR t001_ipb_imn
     FOREACH t001_imn INTO l_imn04glb,l_imn05glb
   
        LET l_imn04_1 = l_imn04glb
        LET l_imn05_1 = l_imn05glb
        #因为只扫入拨出仓库，所以就判断这个
        SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01 = l_imn04glb AND ime02 = l_imn05glb AND ime12 = '1' #判断扫出仓库为是否为vmi仓
         IF l_cnt = 0 THEN
            #RETURN #p_imn04,p_imn05,p_imn15,p_imn16
             SELECT COUNT(*) INTO l_cnt FROM ime_file,imn_file WHERE imn15 = ime01 AND imn16 = ime02 AND imn01 = p_imn01 AND ime12 = '1' #判断是否存在vmi拨入仓库
            IF l_cnt = 0 THEN
                RETURN
            END IF
         END IF
   
   #SELECT ime01,ime02 INTO p_imn04,p_imn05 FROM ime_file WHERE ime02 = p_imn05 AND ime12 = '2'
   #SELECT imn04,imn05,imn15,imn16 INTO l_imn04,l_imn05,l_imn15,l_imn16 FROM imn_file WHERE imn01 = p_imn01 AND imn04 = p_imn04 AND imn05 = p_imn05
   #
   #IF cl_null(l_imn04) THEN
   #   SELECT imn04,imn05,imn15,imn16 INTO l_imn04,l_imn05,l_imn15,l_imn16 FROM imn_file WHERE imn01 = p_imn01 AND imn15 = p_imn04 AND imn16 = p_imn05
   #END IF
#        LET g_prog = 'cimt324' 
#        # CALL t324_vmi(p_imn01)   #mark wanjz by 170222
#        #add wanjz by 170222 start---------
#        IF g_vmi_i = 0 THEN 
#           CALL t324_vmi(p_imn01)
#           IF g_success = 'Y' THEN 
#              LET g_vmi_i = 1
#           END IF     
#        END IF 
#        #add wanjz by 170222 end  --------------
        LET g_prog = 'aws_ttsrv2'
        IF g_success = 'Y' THEN
            LET g_vmi = '1'
        END IF
    END FOREACH     
   #RETURN l_imn04,l_imn05,l_imn15,l_imn16
END FUNCTION
#add wanjz by 170222 end ------------------
FUNCTION exc_item_aimt324(p_imm01)
DEFINE p_imm01       LIKE imm_file.imm01
DEFINE l_sql         STRING
DEFINE l_ima01       LIKE ima_file.ima01
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_imn04_sum   LIKE imn_file.imn04
DEFINE l_imn10_sum   LIKE imn_file.imn10
DEFINE l_imn02       LIKE imn_file.imn02
DEFINE l_imn03       LIKE imn_file.imn03
DEFINE l_imn04       LIKE imn_file.imn04
DEFINE l_imn05       LIKE imn_file.imn05
DEFINE l_imn06       LIKE imn_file.imn06
DEFINE l_imn10       LIKE imn_file.imn10
DEFINE l_imn         RECORD LIKE imn_file.*

   ##单身数据插入临时表
   LET l_sql ="insert into aimt324_temp select * from imn_file where imn01='",p_imm01,"'"
   PREPARE aimt324b_tmp_s FROM l_sql
   EXECUTE aimt324b_tmp_s
   ##删除原先单身数据
   DELETE FROM imn_file WHERE imn01=p_imm01
   
   LET l_sql="select ima01,imn04,imn05,batch,SUM(qty) FROM t324_file 
              WHERE imm01 = '",p_imm01 CLIPPED,"'
               GROUP BY ima01,imn04,imn05,batch"
   PREPARE imm_pre FROM l_sql
   DECLARE imm_c CURSOR FOR imm_pre
   FOREACH imm_c INTO l_imn03,l_imn04,l_imn05,l_imn06,l_imn10
      IF l_imn10=0 THEN 
      	 CONTINUE FOREACH
      END IF 	
      
      LET l_sql="select * from aimt324_temp where imn03='",l_imn03,"' and imn10>0 order by imn02"
      PREPARE imn_pre2 FROM l_sql
      DECLARE imn_c2 CURSOR FOR imn_pre2
      FOREACH imn_c2 INTO l_imn.*
         IF l_imn10=0 THEN #数量必相等
            EXIT FOREACH 
         END IF
         
         IF l_imn10>=l_imn.imn10 THEN 
         	  UPDATE aimt324_temp SET imn10=0 
         	  WHERE imn01=l_imn.imn01 AND imn02=l_imn.imn02
         	  LET l_imn10=l_imn10-l_imn.imn10
         ELSE 
         	  UPDATE aimt324_temp SET imn10=l_imn.imn10-l_imn10
         	  WHERE imn01=l_imn.imn01 AND imn02=l_imn.imn02
         	  LET l_imn.imn10=l_imn10
         	  LET l_imn10=0
         END IF 		
         
         SELECT MAX(imn02)+1 INTO l_imn.imn02 FROM imn_file 
         WHERE imn01=l_imn.imn01 
         IF cl_null(l_imn.imn02) THEN 
         	  LET l_imn.imn02=1
         END IF 	
         
         LET l_imn.imn04=l_imn04      #拨出仓库
         LET l_imn.imn05=l_imn05      #拨出库位
         LET l_imn.imn06=l_imn06      #拨出批号
         
         LET l_imn.imn17=l_imn06      #拨入批号
         LET l_imn.imn22=l_imn.imn21*l_imn.imn10   #拨入数量
         INSERT INTO imn_file VALUES(l_imn.*)
         
         IF SQLCA.SQLCODE THEN
            LET g_status.code = SQLCA.SQLCODE
            LET g_status.sqlcode = SQLCA.SQLCODE
            ROLLBACK WORK
            RETURN
         END IF	
      END FOREACH 

   END FOREACH 
 

#add wanjz by 170213 start----------
#将调拨日期修改问作业日期
#     UPDATE imm_file SET imm02 = g_today WHERE imm01 = p_imm01
#     IF SQLCA.sqlcode THEN
#         LET g_success='N'
#         LET g_status.code=-1
#         LET g_status.description="更新调拨日期失败！"
#     END IF
#
#add wanjz by 170213 end ---------
 

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
