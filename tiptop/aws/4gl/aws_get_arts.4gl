# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_arts.4gl
# Descriptions...: 提供取得 ERP工艺资料
# Date & Author..: 2016-04-12 17:29:36 shenran
# Memo...........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-840004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供取得 ERP 料件資料服務(入口 function)
# Date & Author..: 2007/02/12 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_arts()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 料件編號資料                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_arts_process()
    END IF
 
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
FUNCTION aws_get_arts_process()
    DEFINE l_arts   RECORD
           ima571 LIKE ima_file.ima571,
           ima02  LIKE ima_file.ima02
                   END RECORD
    DEFINE l_arts1   RECORD
           ecd02       LIKE ecd_file.ecd02,
           tc_workt06  LIKE tc_workt_file.tc_workt06
                   END RECORD
    DEFINE l_arts2   RECORD
           gen02       LIKE gen_file.gen02
                   END RECORD                   
    DEFINE l_wc    STRING
    DEFINE l_sql   STRING
    DEFINE l_node  om.DomNode
    DEFINE l_sfa01  LIKE sfa_file.sfa01  #工单号
    DEFINE l_ecb06  LIKE ecb_file.ecb06  #作业编号
    DEFINE l_sfb05  LIKE sfb_file.sfb05  #料件
    DEFINE l_ima571 LIKE ima_file.ima571 #工艺路线料号
    DEFINE l_ima94  LIKE ima_file.ima94  #工艺编号
    DEFINE l_n      LIKE type_file.num5
    DEFINE l_gen01  LIKE gen_file.gen01  #员工编码
   
    LET l_sfa01 = aws_ttsrv_getParameter("sfa01")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_ecb06 = aws_ttsrv_getParameter("ecb06")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_gen01 = aws_ttsrv_getParameter("gen01")   #取由呼叫端呼叫時給予的 SQL Condition
    IF NOT cl_null(l_gen01) THEN
    	 SELECT COUNT(*) INTO l_n FROM gen_file WHERE gen01=l_gen01
    	 IF l_n>0 THEN
    	 	  SELECT gen02 INTO l_arts2.gen02 FROM gen_file WHERE gen01=l_gen01
    	 	  LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_arts2), "Master")   #加入此筆單檔資料至 Response 中
    	 ELSE
    	 	  LET g_status.code=-1
          LET g_status.description="报工人员不存在!"
          RETURN
    	 END IF
    ELSE
       IF cl_null(l_sfa01) THEN
       	  LET g_status.code=-1
          LET g_status.description="工单号不能为空!"
          RETURN
       END IF
       IF cl_null(l_ecb06) THEN 
          SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01=l_sfa01
          SELECT ima571,ima94 INTO l_ima571,l_ima94 FROM ima_file WHERE ima01=l_sfb05
          IF cl_null(l_ima571) OR cl_null(l_ima94) THEN
          	 LET g_status.code=-1
             LET g_status.description="料件对应工艺路线料号或工艺编号为空,请检查!"
             RETURN
          END IF
          SELECT COUNT(*) INTO l_n FROM ecu_file WHERE ecu01=l_ima571 AND ecu02=l_ima94 AND ecu10='Y'
          IF l_n>0 THEN
          	 LET l_arts.ima571=l_ima571
          	 SELECT ima02 INTO l_arts.ima02 FROM ima_file WHERE ima01=l_arts.ima571
             LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_arts), "Master")   #加入此筆單檔資料至 Response 中        
          ELSE 
          	 LET g_status.code=-1
             LET g_status.description="料件对应工艺资料有误!"
             RETURN
          END IF
       ELSE
       	  SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01=l_sfa01
          SELECT ima571,ima94 INTO l_ima571,l_ima94 FROM ima_file WHERE ima01=l_sfb05
          IF cl_null(l_ima571) OR cl_null(l_ima94) THEN
          	 LET g_status.code=-1
             LET g_status.description="料件对应工艺路线料号或工艺编号为空,请检查!"
             RETURN
          END IF
       	 SELECT COUNT(*) INTO l_n FROM ecb_file,ecu_file WHERE ecb01=ecu01 AND ecb02=ecu02
       	 AND ecb06=l_ecb06 AND ecb01=l_ima571 AND ecb02=l_ima94 AND ecu10='Y'
       	 IF l_n>0 THEN
       	 	  SELECT ecd02 INTO l_arts1.ecd02 FROM ecd_file WHERE ecd01=l_ecb06
       	 	  SELECT SUM(tc_workt06) INTO l_arts1.tc_workt06 FROM tc_workt_file
       	 	  WHERE tc_workt11=l_sfa01 AND tc_workt04=l_ecb06 AND tc_workt01=g_today
       	 	  IF cl_null(l_arts1.tc_workt06) THEN
       	 	  	 LET l_arts1.tc_workt06=0
       	 	  END IF
       	 	  LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_arts1), "Master")   #加入此筆單檔資料至 Response 中 
       	 ELSE
       	 	  LET g_status.code=-1
            LET g_status.description="料件对应工艺资料有误!"
            RETURN
       	 END IF
       END IF
    END IF
END FUNCTION
