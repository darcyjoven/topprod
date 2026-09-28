# Program name...: cjc_zm_createerpissue.4gl
# Descriptions...: 提供接收SCM任务执行结果
# Date & Author..: 2019/07/23 by sh 
# Modify.........: No:2021111801 21/11/18 By jc 成套发料和欠料补料单号取最大后换单别

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 

FUNCTION cjc_zm_createerpissue()
 
  WHENEVER ERROR CONTINUE
 
  CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
  
  IF g_status.code = "0" THEN
    CALL cjc_zm_createerpissue_process()
  END IF
 
  CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
FUNCTION cjc_zm_createerpissue_process()
  DEFINE l_i        LIKE type_file.num10,
         l_j        LIKE type_file.num10
  DEFINE l_sql      STRING        
  DEFINE l_cnt      LIKE type_file.num10,
         l_cnt1     LIKE type_file.num10,
         l_cnt2     LIKE type_file.num10
  DEFINE l_sfp      RECORD LIKE sfp_file.*,
         l_sfq      RECORD LIKE sfq_file.*,
         l_sfs      RECORD LIKE sfs_file.*
         #l_sfv_t      RECORD LIKE tc_sfv_file.*,
         #l_tc_sfp_t   RECORD LIKE tc_sfp_file.* 
  DEFINE l_node1    om.DomNode,
         l_node2    om.DomNode
  DEFINE l_flag     LIKE type_file.num10,
         l_time     LIKE type_file.chr100,
         l_remark   LIKE type_file.chr1000,
         l_img10    LIKE img_file.img10,
         l_gen03    LIKE gen_file.gen03,
         l_smykind  LIKE smy_file.smykind,
         l_sfa05    LIKE sfa_file.sfa05,
         l_sfa06    LIKE sfa_file.sfa06,
         l_sfa062   LIKE sfa_file.sfa062,
         l_sfa063   LIKE sfa_file.sfa063,
         l_sfa064   LIKE sfa_file.sfa064,
         l_sfa11    LIKE sfa_file.sfa11,
         l_sfb08    LIKE sfb_file.sfb08,
         l_sfb081   LIKE sfb_file.sfb081,
         l_sfb09    LIKE sfb_file.sfb09,
         l_doc      like type_file.chr50,
         l_type     LIKE type_file.chr10,
         l_sn       LIKE type_file.num10,
         l_sfb01    LIKE type_file.chr50,
         l_sfa012   LIKE sfa_file.sfa012,
         l_sfa013   LIKE sfa_file.sfa013,
         l_sfa26    LIKE sfa_file.sfa26,
         l_sfa27    LIKE sfa_file.sfa27,
         l_sfa28    LIKE sfa_file.sfa28,
        # l_tc_sft01  LIKE tc_sft_file.tc_sft01 ,
         l_sfa08     LIKE sfa_file.sfa08,
         l_sfp01_t   LIKE sfp_file.sfp01,
        # l_tc_sft05  LIKE tc_sft_file.tc_sft05,
        # l_tc_sft04  LIKE tc_sft_file.tc_sft04,  #200228 
         l_sfk       RECORD LIKE sfk_file.*
  DEFINE l_sfbud03   LIKE sfb_file.sfbud03 ,
         l_oem       LIKE sfb_file.sfbud03
  DEFINE l_gem02     LIKE gem_file.gem02,
         l_sfq03     LIKE sfq_file.sfq03    #20211102 add
         ,l_length   LIKE type_file.num10,   #2021111801 add
         l_sfp01t    LIKE sfp_file.sfp01     #2021111801 add
         ,l_sfq03a   LIKE sfq_file.sfq03     #2022032401 add
         


  LET l_cnt1 = aws_ttsrv_getMasterRecordLength("INVENTORY_DETAILS")
  IF l_cnt1 = 0 THEN
    LET g_status.code = "-1"
    LET g_status.description = "No recordset processed!"
    RETURN
  END IF
    
  BEGIN WORK
  
  #任务单执行结果接收 
  #发料单
  FOR l_i = 1 TO l_cnt1       
    LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "INVENTORY_DETAILS")        #单头
    LET l_sfp.sfpud06 = aws_ttsrv_getRecordField(l_node1, "SOURCE_ID_CODE"),"-",aws_ttsrv_getRecordField(l_node1, "UPDATE_NUM") ,"-",aws_ttsrv_getRecordField(l_node1, "STATUS")   #来源SCM单号
    LET l_sfp.sfp06 = aws_ttsrv_getRecordField(l_node1, "ISSUE_TYPE")         #取得此筆單檔資料的欄位值
    LET l_sfp.sfpuser = aws_ttsrv_getRecordField(l_node1, "CREATED_BY_CODE")   #
    
    LET l_sfp.sfp07 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_DEPARTMENT_ID_CODE")         #取得此筆單檔資料的欄位值
    LET l_sfp.sfp16 = aws_ttsrv_getRecordField(l_node1, "CREATED_BY_CODE")         #取得此筆單檔資料的欄位值
    LET l_sfp.sfpplant = aws_ttsrv_getRecordField(l_node1, "GROUP_ID_CODE")      #营运中心 
    LET l_time    = aws_ttsrv_getRecordField(l_node1, "CREATED_ON")          #单据申请时间
    LET l_sfp.sfpud02    = aws_ttsrv_getRecordField(l_node1, "REMARKS")          #备注
    LET  l_sfp.sfp02 = l_time[1,10]
    LET l_time    = aws_ttsrv_getRecordField(l_node1, "CREATED_ON")          #执行时间
    LET  l_sfp.sfp03 = l_time[1,10]
    #LET l_tc_sft01 = aws_ttsrv_getRecordField(l_node1, "SOURCE_CODE")   #来源单号
    LET l_type     = aws_ttsrv_getRecordField(l_node1, "SOURCE_DOC_TYPE_ID_CODE")   #来源类型
    LET  l_sfp.sfp01  = aws_ttsrv_getRecordField(l_node1, "ERP_TYPE")      #单别
    LET  l_sfp.sfpud03  = aws_ttsrv_getRecordField(l_node1, "ERPCode")      #来源ERP单号
    IF NOT cl_null(l_sfp.sfpud03) THEN 
       SELECT tc_sfd07 INTO l_sfp.sfpud02 FROM tc_sfd_file WHERE tc_sfd01= l_sfp.sfpud03 AND rownum=1
    END IF 
    #IF cl_null(l_tc_sft01) THEN 
    	#LET g_status.code = "-1"
    	#LET g_status.description = "来源发料需求单号不能为空！"
    	#EXIT FOR
    #END IF 

    #add by shawn 191004 --begin 
    LET l_sql = " select sfp01 from sfp_file where sfpud06 like '",l_sfp.sfpud06 CLIPPED ,"' and rownum=1"
    PREPARE pre_sfp_t FROM l_sql
    EXECUTE pre_sfp_t INTO l_sfp01_t
    IF NOT cl_null(l_sfp01_t) THEN
      LET g_status.code = 0
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = l_sfp01_t
      RETURN 
    END IF
    #--end 
    
    #过账时间
	#add by sh ---190220 --- beign ---- 
    #抓取csfp513 相关资料
    #SELECT tc_sft05 INTO l_tc_sft05 FROM tc_sft_file WHERE tc_sft01=l_tc_sft01  
    #IF l_tc_sft05 MATCHES '[1-9]*' THEN 
    #    SELECT * INTO l_tc_sfp_t.* FROM tc_sfp_file WHERE tc_sfp01=l_tc_sft05
   # END IF 
    #IF l_tc_sft05 MATCHES 'H*' THEN 
    #    SELECT * INTO l_sfk.* FROM sfk_file WHERE sfk01=l_tc_sft05
    #END IF 
    #LET l_sfp.sfpud05 = l_tc_sft05   #来源发料序号
    
    IF cl_null(l_sfp.sfpplant) AND  cl_null(l_sfk.sfkplant) THEN 
    	LET g_status.code = "-1"
    	LET g_status.description = "营运中心不可为空!"
    	EXIT FOR
    END IF 
	#---end ---- 
    #add by shawn 200228 -- beign  --- 抓起需求单对应的领料部门 --- 
    #SELECT tc_sft04 INTO l_tc_sft04  FROM tc_sft_file WHERE tc_sft01=l_tc_sft01 
    ##IF NOT cl_null(l_tc_sft04) THEN 
    #   LET l_sfp.sfp07 = l_tc_sft04
    #END IF  
    #--end ----  
    IF l_sfp.sfp06  = '1' OR l_sfp.sfp06  = '2' THEN 
       LET  l_sfp.sfp06  = '1'
    END IF 
    IF l_sfp.sfp06  = '3' THEN 
       LET  l_sfp.sfp06  = '2'
    END IF  
    IF l_sfp.sfp06  = '4' THEN 
       LET  l_sfp.sfp06  = '3'
    END IF  
    IF l_type MATCHES "*OR1*" THEN 
         LET l_sfp.sfp06  = '8'
    ELSE 
    #    IF l_tc_sft05 MATCHES 'H*' THEN
    #       LET l_sfp.sfp06  = '2'
    #    ELSE 
    #        LET l_sfp.sfp06  = '1'
    #s    END IF 
    END IF 
    IF cl_null(l_sfp.sfp06) THEN 
    	LET g_status.code = "-1"
    	LET g_status.description = "发料类型不可为空!"
    	EXIT FOR
    END IF 
    IF l_sfp.sfp06 NOT MATCHES '[12346789]' THEN 
    	LET g_status.code = "-1"
    	LET g_status.description = "发料类型不正确!"
    	EXIT FOR
    END IF 
    IF l_sfp.sfp06 MATCHES '[1234]' THEN 
    	LET l_smykind = '3'
    	ELSE 
    	LET l_smykind = '4'
    END IF 
    IF cl_null(l_sfp.sfp16) THEN 
    	LET g_status.code = "-1"
    	LET g_status.description = "申请人不可为空!"
    	EXIT FOR
    END IF 
    SELECT gen03 INTO l_gen03 FROM gen_file WHERE gen01 = l_sfp.sfp16 AND genacti = 'Y'
    IF cl_null(l_gen03) THEN 
    	LET g_status.code = "-1"
    	LET g_status.description = l_sfp.sfp16,"申请人无效!"
    	EXIT FOR
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM gem_file WHERE gem01 = l_sfp.sfp07 AND gemacti = 'Y'
    IF l_cnt = 0 THEN 
    	LET g_status.code = "-1"
    	LET g_status.description = l_sfp.sfp07,"部门无效!"
    	EXIT FOR
    ELSE 
        SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_sfp.sfp07 AND gemacti = 'Y'
        IF l_gem02 MATCHES '*外协*' AND cl_null(l_sfp.sfp01)  THEN 
           LET  l_sfp.sfp01  =  'MRR'
        END IF 
    END IF 
    IF cl_null(l_sfp.sfp02) THEN
      LET l_sfp.sfp02 = g_today 
    END IF


    LET l_sfp.sfp03 = l_sfp.sfp02
    LET l_sfp.sfp04  ='N'
    LET l_sfp.sfpconf='N' #FUN-660106
    LET l_sfp.sfp05  ='N'
    LET l_sfp.sfp09  ='N'
    LET l_sfp.sfp15 = '0'     #開立  
    LET l_sfp.sfpmksg = "N"
    LET l_sfp.sfplegal = l_sfp.sfpplant
    LET l_sfp.sfpuser=l_sfp.sfp16
    LET l_sfp.sfporiu = l_sfp.sfp16
    LET l_sfp.sfporig = l_gen03
    LET l_sfp.sfpgrup=l_gen03
    LET l_sfp.sfpdate=l_sfp.sfp02
    
    
    #----------------------------------------------------------------------#
    # 自動取號                                                       #
    #----------------------------------------------------------------------# 
    IF NOT cl_null(l_sfp.sfp01) THEN 
    #    LET l_sfp.sfp01 = l_tc_sfp_t.tc_sfp05
        #LET l_sfp.sfp10 = l_tc_sfp_t.tc_sfp01
        
    ELSE    
        SELECT smyslip INTO l_sfp.sfp01    #抓取单别
        FROM smy_file
        WHERE smysys = 'asf' AND smykind = l_smykind AND smy72 = l_sfp.sfp06 AND smyacti = 'Y' AND smyauno = 'Y'  AND smyslip NOT LIKE '%RR%' AND smyslip NOT LIKE '%TT%' AND rownum <=1
        IF cl_null(l_sfp.sfp01) THEN 
            LET g_status.code = "-1"
            LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
            LET g_status.description = "无有效发料/退料单别！"
            EXIT FOR
        END IF 
    END IF 
    LET l_sfp01t = l_sfp.sfp01     #2021111801 add
    CALL s_auto_assign_no("asf",l_sfp.sfp01,l_sfp.sfp02,"","INVENTORY_DETAILS","sfp01","","","")
         RETURNING l_flag,l_sfp.sfp01
    IF NOT l_flag THEN
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "发料/退料单/超领取号失败！"
      EXIT FOR
    END IF
    #2021111801 add----begin----
    IF l_sfp.sfp06 MATCHES '[13]' THEN 
    	LET l_length = length(l_sfp.sfp01)
    	IF l_sfp.sfp01[l_length-3,l_length] = '9999' THEN 
    		LET l_flag = 0
    		DECLARE smy_curs CURSOR FOR SELECT smyslip FROM smy_file WHERE smysys = 'asf' AND smykind = l_smykind AND smy72 = l_sfp.sfp06 AND smyacti = 'Y' AND smyauno = 'Y'  AND smyslip NOT LIKE '%RR%' AND smyslip <> l_sfp01t ORDER BY smyslip
    		FOREACH smy_curs INTO l_sfp.sfp01
    		  IF STATUS THEN EXIT FOREACH END IF 
    		  CALL s_auto_assign_no("asf",l_sfp.sfp01,l_sfp.sfp02,"","INVENTORY_DETAILS","sfp01","","","") RETURNING l_flag,l_sfp.sfp01
    		  IF NOT l_flag THEN EXIT FOREACH END IF 
    		  LET l_length = length(l_sfp.sfp01)
    		  IF l_sfp.sfp01[l_length-3,l_length] = '9999' THEN
    		  	LET l_flag = 0
    		  	ELSE 
    		  	EXIT FOREACH 
    		  END IF 
    		END FOREACH
        IF NOT l_flag THEN
        	LET g_status.code = "-1"
        	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        	LET g_status.description = "发料/退料单/超领取号失败！"
          EXIT FOR
        END IF
    	END IF 
    END IF 
    #2021111801 add----end----

    #----------------------------------------------------------------------#
    # 執行單頭 INSERT SQL                                                  #
    #----------------------------------------------------------------------#
    INSERT INTO sfp_file VALUES (l_sfp.*)
    IF SQLCA.SQLCODE THEN
      LET g_status.code = "-1"
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = "insert sfp_file失败！"
      EXIT FOR
    END IF
    
    #----------------------------------------------------------------------#
    # 處理單身資料                                                         #
    #----------------------------------------------------------------------#
    LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "INVENTORY_DETAILS")       #取得目前單頭共有幾筆單身資料
    IF l_cnt2 = 0 THEN
      LET g_status.code = "-1"   #必須有單身資料
      LET g_status.description = "INVENTORY_DETAILS_D无资料!"
      EXIT FOR
    END IF
    
    FOR l_j = 1 TO l_cnt2
      INITIALIZE l_sfs.* TO NULL 
      LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "INVENTORY_DETAILS")   #目前單身的 XML 節點
      LET l_sfs.sfs01 = l_sfp.sfp01
      LET l_sfs.sfs02 = aws_ttsrv_getRecordField(l_node2, "SEQ_NUM")                   #项次
      LET l_sfs.sfs04 = aws_ttsrv_getRecordField(l_node2, "PRODUCT_ID_CODE")           #料号
      LET l_sfs.sfs09 = aws_ttsrv_getRecordField(l_node2, "LOT_NUM")                   #批号
      LET l_sfs.sfs06 = aws_ttsrv_getRecordField(l_node2, "UNIT_ID_CODE")              #单位
      LET l_sfs.sfs05 = aws_ttsrv_getRecordField(l_node2, "QUANTITY")                  #数量
      LET l_sfs.sfsud02 = aws_ttsrv_getRecordField(l_node2, "WAREHOUSE_ID_CODE")         #仓库
      LET l_sfs.sfs08 = aws_ttsrv_getRecordField(l_node2, "LOCATION_ID_CODE")          #库位
      LET l_sfs.sfsplant = aws_ttsrv_getRecordField(l_node2, "GROUP_ID_CODE")          #营运中心
      LET l_doc       =  aws_ttsrv_getRecordField(l_node2, "SOURCE_CODE")              #来源单号
      LET l_sn       =  aws_ttsrv_getRecordField(l_node2, "SOURCE_SEQ_NUM")            #来源单号项次
      LET l_sfb01    =  aws_ttsrv_getRecordField(l_node2, "PRO_WORK_TASK_CODE")        #工单单号
      LET l_sfs.sfs10  = aws_ttsrv_getRecordField(l_node2, "SOURCE_JOB_NAME")          #作业编号
      LET l_sfs.sfsud07 = l_sfs.sfs05                                                  #实发量
      LET l_sfs.sfs07 = l_sfs.sfsud02
      LET l_sfs.sfs02 = l_j
      {IF (cl_null(l_doc) or cl_null(l_sn)) AND l_sfp.sfp06 = '1' THEN
        LET g_status.code = "-1"
        LET g_status.description = "来源单号或来源单号项次不能为空！！"
        EXIT FOR
      END IF }
      #IF l_sfp.sfp06 = '1' THEN
         # SELECT * INTO l_sfv_t.* FROM tc_sfv_file WHERE tc_sfv01 = l_doc AND tc_sfv02 = l_sn      #抓取发料明细相关其他资料
         # LET l_sfs.sfs03 = l_sfv_t.tc_sfv03            #工单号
         # IF cl_null(l_sfs.sfs10) THEN 
         #   LET l_sfs.sfs10 = l_sfv_t.tc_sfv10            #作业编号
         # END IF 
          #LET l_sfs.sfs012 = l_sfv_t.tc_sfv012          #制程
         # LET l_sfs.sfs26 = l_sfv_t.tc_sfv11            #替代码
         # LET l_sfs.sfs27 = l_sfv_t.tc_sfv12           #被替代料号
         # LET l_sfs.sfs28 = l_sfv_t.tc_sfv13           #替代率
          #LET l_sfs.sfs013 = l_sfv_t.tc_sfv013            #制程序 
          # LET l_sfs.sfs014 = ' '#l_sfv_t.tc_sfv014              #Run Card
          #LET l_sfs.sfs37 = l_sfv_t.tc_sfv37            #理由码
      #ELSE 
      
      LET l_sfs.sfs03 = aws_ttsrv_getRecordField(l_node2, "PRO_WORK_TASK_CODE")           #工单
      #END IF 
      IF cl_null(l_sfs.sfs03) THEN 
            LET g_status.code = "-1"
            LET g_status.description = "工单号不可为空!"
            EXIT FOR
      END IF 
      SELECT COUNT(*) INTO l_cnt 
      FROM sfb_file WHERE sfb01 = l_sfs.sfs03 AND sfb87 = 'Y' AND sfb04 <> '8'
      IF l_cnt = 0 THEN 
      	LET g_status.code = "-1"
        LET g_status.description = "工单号无效或已结案!"
        EXIT FOR
      END IF 
      IF cl_null(l_sfs.sfs04) THEN 
        LET g_status.code = "-1"
        LET g_status.description = "料号不可为空!"
        EXIT FOR
      END IF 
      SELECT COUNT(*) INTO l_cnt
      FROM sfa_file WHERE sfa01 = l_sfs.sfs03 AND sfa03 = l_sfs.sfs04
      IF l_cnt = 0 THEN 
        LET g_status.code = "-1"
        LET g_status.description = "工单备料档无此料号!"
        EXIT FOR
      END IF 
      #批号管理 ima159 = 1 带批号，否则不带批号  --begin ---- 
     # SELECT count(*) INTO l_cnt FROM ima_file WHERE ima159 = '1'  AND ima01=l_sfs.sfs04
     # IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
     # IF l_cnt = 0 THEN 
     #     LET l_sfs.sfs09 = ' ' 
     # END IF 
      
      
      IF cl_null(l_sfs.sfs28) THEN LET l_sfs.sfs28 = 1 END IF 
      IF cl_null(l_sfs.sfs014) THEN LET l_sfs.sfs014 = ' ' END IF 
      IF cl_null(l_sfs.sfs08) THEN LET l_sfs.sfs08 = ' ' END IF 
      IF cl_null(l_sfs.sfs09) THEN LET l_sfs.sfs09 = ' ' END IF 
      IF cl_null(l_sfs.sfs012) THEN LET l_sfs.sfs012 = ' ' END IF 
      IF cl_null(l_sfs.sfsud13) THEN LET l_sfs.sfsud13 = ' ' END IF 
      IF cl_null(l_sfs.sfsud14) THEN LET l_sfs.sfsud14 = ' ' END IF 
      IF cl_null(l_sfs.sfsud15) THEN LET l_sfs.sfsud15 = ' ' END IF 
      
      LET l_sfs.sfslegal = l_sfs.sfsplant
      
      SELECT sfa05,sfa06,sfa062,sfa063,sfa064,sfa11,sfa08,sfa012,sfa013,sfa26,sfa27,sfa28 
      INTO l_sfa05,l_sfa06,l_sfa062,l_sfa063,l_sfa064,l_sfa11,l_sfa08,l_sfa012,l_sfa013,l_sfa26,l_sfa27,l_sfa28
      FROM sfa_file WHERE sfa01 = l_sfs.sfs03 AND sfa03 = l_sfs.sfs04 AND sfa08= l_sfs.sfs10 AND rownum = 1 
      IF cl_null(l_sfa06) THEN LET l_sfa06 = 0 END IF 
      IF cl_null(l_sfa062) THEN LET l_sfa062 = 0 END IF 

      LET l_sfs.sfs012 = l_sfa012          #制程
      LET l_sfs.sfs26 =  l_sfa26            #替代码
      LET l_sfs.sfs27 =  l_sfa27           #被替代料号
      LET l_sfs.sfs28 =  l_sfa28           #替代率
      LET l_sfs.sfs013 = l_sfa013            #制程序 
      LET l_sfs.sfs014 = ' '#l_sfv_t.tc_sfv014              #Run Card
      #LET l_sfs.sfs37 = l_sfv_t.tc_sfv37            #理由码
       IF l_sfp.sfp06 <> '1' AND cl_null(l_sfs.sfs10) THEN
          LET l_sfs.sfs10 = l_sfa08
        END IF 
      SELECT sfb08,sfb081,sfb09 INTO l_sfb08,l_sfb081,l_sfb09
      FROM sfb_file WHERE sfb01 = l_sfs.sfs03
      IF l_smykind = '3' THEN 
        SELECT img10 INTO l_img10
        FROM img_file 
        WHERE img01 = l_sfs.sfs04 AND img02 = l_sfs.sfs07
        AND img03 = l_sfs.sfs08 AND img04 = l_sfs.sfs09
        IF cl_null(l_img10) THEN LET l_img10 = 0 END IF 
        {IF l_img10 < l_sfs.sfs05 THEN 
          LET g_status.code = "-1"
          LET g_status.description = "发料量大于库存量!"
          EXIT FOR
        END IF }
       { IF l_sfa11 = 'E' AND l_sfp.sfp06 <> '4' THEN 
          LET g_status.code = "-1"
          LET g_status.description = "发料类型和来源特性不匹配!"
          EXIT FOR
        END IF }
        IF l_sfp.sfp06 MATCHES '[13]' THEN 
        	LET l_sfq.sfq03 = ''
        	LET l_sfq.sfq03 = aws_ttsrv_getRecordField(l_node2, "qpa_amount")         #取得此筆單檔資料的欄位值
        	#20211102 add----begin----
        	LET l_sfq03 = 0
        	SELECT SUM(sfq03) INTO l_sfq03 FROM sfq_file,sfp_file WHERE sfq01 = sfp01 AND sfpconf <> 'X' AND sfq02 = l_sfs.sfs03 AND (sfq04 = l_sfs.sfs10 OR sfq04 = ' ')
        	IF cl_null(l_sfq03) THEN LET l_sfq03 = 0 END IF 
        	#20211102 add----end----
        	IF cl_null(l_sfq.sfq03) THEN LET l_sfq.sfq03 = l_sfb08 - l_sfq03 END IF 
        	IF l_sfq.sfq03 + l_sfq03 > l_sfb08 THEN     #20211102 add l_sfq03
        		LET l_sfq.sfq03 = l_sfb08 - l_sfq03
#                LET g_status.code = "-1"
#                LET g_status.description = "成套发料套数(含未扣账发料单)大于生产量!"
#                EXIT FOR
        	END IF 

        	SELECT COUNT(*) INTO l_cnt 
        	FROM sfq_file WHERE sfq01 = l_sfp.sfp01 AND sfq02 = l_sfs.sfs03 AND (sfq04 = l_sfs.sfs10 OR sfq04 = ' ')
        	IF l_cnt = 0 THEN 
        		LET l_sfq.sfq01 = l_sfp.sfp01
        		LET l_sfq.sfq02 = l_sfs.sfs03
        		LET l_sfq.sfq04 = l_sfs.sfs10
        		LET l_sfq.sfq05 = l_sfp.sfp02
        		LET l_sfq.sfq06 = 0
        		LET l_sfq.sfq012 = l_sfs.sfs012
        		LET l_sfq.sfq014 = l_sfs.sfs014
        		LET l_sfq03a = 0
                SELECT tc_sfe03 INTO l_sfq03a FROM tc_sfe_file WHERE tc_sfe01 = l_sfp.sfpud03 AND tc_sfe02 =  l_sfq.sfq02 AND (tc_sfe04 = l_sfs.sfs10 OR tc_sfe04 = ' ')
                # IF cl_null(l_sfq.sfq03) THEN LET l_sfq.sfq03 = 0 END IF 
                IF l_sfq.sfq03 > l_sfq03a THEN LET l_sfq.sfq03 = l_sfq03a END IF 
                IF l_sfb081 >= l_sfb08 THEN 
                    LET l_sfq.sfq03 = 0 
                END IF 
                IF cl_null(l_sfq.sfq04) THEN LET l_sfq.sfq04 = ' 'END IF 
                IF cl_null(l_sfq.sfq012) THEN LET l_sfq.sfq012 = ' 'END IF 
                IF cl_null(l_sfq.sfq014) THEN LET l_sfq.sfq014 = ' ' END IF 
        		LET l_sfq.sfqplant = l_sfp.sfpplant
        		LET l_sfq.sfqlegal = l_sfp.sfplegal
            INSERT INTO sfq_file VALUES (l_sfq.*)
            IF SQLCA.SQLCODE THEN
              LET g_status.code = "-1"
              LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
              LET g_status.description = "insert sfq_file失败！"
              EXIT FOR
            END IF
          END IF 
        END IF 
      	ELSE 
        IF l_sfa11 = 'E' AND l_sfp.sfp06 <> '9' THEN 
          LET g_status.code = "-1"
          LET g_status.description = "发料类型和来源特性不匹配!"
          EXIT FOR
        END IF 
        IF l_sfp.sfp06 = '7' AND l_sfs.sfs05 > l_sfa062 THEN 
          LET g_status.code = "-1"
          LET g_status.description = "超领退料量大于超领发料量!"
          EXIT FOR
        END IF 
        IF l_sfp.sfp06 MATCHES '[689]' AND l_sfs.sfs05 > l_sfa06 THEN 
          LET g_status.code = "-1"
          LET g_status.description = "退料量大于发料量!"
          EXIT FOR
        END IF 
        IF l_sfp.sfp06 MATCHES '[68]' THEN 
        	LET l_sfq.sfq03 = aws_ttsrv_getRecordField(l_node2, "qpa_amount")         #取得此筆單檔資料的欄位值
        	IF l_sfq.sfq03 + l_sfb09 > l_sfb081 THEN 
            LET g_status.code = "-1"
            LET g_status.description = "成套退料套数大于已发套数-入库量!"
            EXIT FOR
        	END IF 
        	SELECT COUNT(*) INTO l_cnt 
        	FROM sfq_file WHERE sfq01 = l_sfp.sfp01 AND sfq02 = l_sfs.sfs03
        	IF l_cnt = 0 THEN 
        		LET l_sfq.sfq01 = l_sfp.sfp01
        		LET l_sfq.sfq02 = l_sfs.sfs03
        		LET l_sfq.sfq04 = l_sfs.sfs10
        		LET l_sfq.sfq05 = l_sfp.sfp02
        		LET l_sfq.sfq06 = 0
        		LET l_sfq.sfq012 = l_sfs.sfs012
        		LET l_sfq.sfq014 = l_sfs.sfs014
                IF cl_null(l_sfq.sfq04) THEN LET l_sfq.sfq04 = ' 'END IF 
                IF cl_null(l_sfq.sfq012) THEN LET l_sfq.sfq012 = ' 'END IF 
                IF cl_null(l_sfq.sfq014) THEN LET l_sfq.sfq014 = ' ' END IF 
        		LET l_sfq.sfqplant = l_sfp.sfpplant
        		LET l_sfq.sfqlegal = l_sfp.sfplegal
            INSERT INTO sfq_file VALUES (l_sfq.*)
            IF SQLCA.SQLCODE THEN
              LET g_status.code = "-1"
              LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
              LET g_status.description = "insert sfq_file失败！"
              EXIT FOR
            END IF
          END IF 
        END IF 
        #20211213 add--begin--
        SELECT COUNT(*) INTO l_cnt
        FROM img_file 
        WHERE img01 = l_sfs.sfs04 AND img02 = l_sfs.sfs07
        AND img03 = l_sfs.sfs08 AND img04 = l_sfs.sfs09
        IF l_cnt = 0 THEN 
           CALL s_add_img(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08, l_sfs.sfs09,l_sfp.sfp01,l_sfs.sfs02,l_sfp.sfp02)
        END IF 
        #20211213 add--end--
      END IF 
      IF cl_null(l_sfs.sfs10) THEN 
	  LET l_sfs.sfs10 = ' '
      END IF 
      IF cl_null(l_sfs.sfs27) THEN LET l_sfs.sfs27 = l_sfs.sfs04 END IF 
      INSERT INTO sfs_file VALUES (l_sfs.*)
      IF SQLCA.SQLCODE THEN
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        LET g_status.description = "insert sfs_file失败！"
        EXIT FOR
      END IF
    END FOR
    IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
       EXIT FOR
    END IF
      
  END FOR
  #全部處理都成功才 COMMIT WORK
  IF g_status.code = "0" THEN
    LET g_status.description = l_sfp.sfp01
    COMMIT WORK
    CALL p300_sfp(l_sfp.sfp01,'1')
  ELSE
    ROLLBACK WORK
  END IF
    
END FUNCTION
