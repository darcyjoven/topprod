# Program name...: cjc_zm_createerpreceipts.4gl
# Descriptions...: V4.0提供建立收货单资料的服务
# Date & Author..: 2018/04/11 by jc

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 

FUNCTION cjc_zm_createerpreceipts()
 
  WHENEVER ERROR CONTINUE
 
  CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
  
  IF g_status.code = "0" THEN
    CALL cjc_zm_createerpreceipts_process()
  END IF
 
  CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
FUNCTION cjc_zm_createerpreceipts_process()
  DEFINE l_i        LIKE type_file.num10,
         l_j        LIKE type_file.num10
  DEFINE l_sql      STRING        
  DEFINE l_cnt      LIKE type_file.num10,
         l_cnt1     LIKE type_file.num10,
         l_cnt2     LIKE type_file.num10
  DEFINE l_rva      RECORD LIKE rva_file.*,
         l_rvb      RECORD LIKE rvb_file.*
  DEFINE l_node1    om.DomNode,
         l_node2    om.DomNode
  DEFINE l_flag     LIKE type_file.num10,
         l_time     LIKE type_file.chr100,
         l_time1     LIKE type_file.chr100,
         l_time2     LIKE type_file.chr100,
         l_remark   LIKE type_file.chr1000,
         l_rvb05    LIKE rvb_file.rvb05,
         l_ima25    LIKE ima_file.ima25,
         l_rva01_t  LIKE rva_file.rva01, 
         l_ima906   LIKE ima_file.ima906,
			   l_ima907   LIKE ima_file.ima907,
			   l_ima44    LIKE ima_file.ima44,
			   l_ima159   LIKE ima_file.ima159,
			   l_ima921   LIKE ima_file.ima921,
			   l_ima918   LIKE ima_file.ima918,
			   l_ima491   LIKE ima_file.ima491,
			   l_pmn16    LIKE pmn_file.pmn16,
			   l_azi03    LIKE azi_file.azi03,
			   l_azi04    LIKE azi_file.azi04,
			   l_gec05    LIKE gec_file.gec05,
			   l_gec07    LIKE gec_file.gec07,
			   l_pmm43    LIKE pmm_file.pmm43,
			   l_fac	    LIKE rvb_file.rvb90_fac,
			   l_pmn20    LIKE pmn_file.pmn20,
			   l_pmn13    LIKE pmn_file.pmn13,
			   l_pmn50    LIKE pmn_file.pmn50,
			   l_pmn51    LIKE pmn_file.pmn51,
			   l_pmn53    LIKE pmn_file.pmn53,
			   l_pmn55    LIKE pmn_file.pmn55,
			   l_pmn58    LIKE pmn_file.pmn58
  DEFINE l_ret RECORD
           success LIKE type_file.chr1,
           code    LIKE type_file.chr10,
           msg     STRING
               END RECORD
 DEFINE l_iqcstatus    LIKE type_file.chr5 
 DEFINE l_pmm09   LIKE pmm_file.pmm09  
 DEFINE l_pmn04   LIKE pmn_file.pmn04
 define l_imaud34   like ima_file.imaud34   #darcy:2024/08/05 add

  LET l_cnt1 = aws_ttsrv_getMasterRecordLength("TASK_SHEET")
  IF l_cnt1 = 0 THEN
    LET g_status.code = "-1"
    LET g_status.description = "No recordset processed!"
    RETURN
  END IF
    
  BEGIN WORK
  
  FOR l_i = 1 TO l_cnt1       
    LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "TASK_SHEET")          #任务单单头节点
    
    LET l_rva.rvaud01 = aws_ttsrv_getRecordField(l_node1, "CODE"),"-",aws_ttsrv_getRecordField(l_node1, "UPDATE_NUM") ,"-",aws_ttsrv_getRecordField(l_node1, "STATUS")   #来源SCM单号        #任务单+执行项次
    LET l_rva.rvaud03 = aws_ttsrv_getRecordField(l_node1, "SOURCE_CODE")     #SCM送货单号
    LET l_rva.rvaud04 = aws_ttsrv_getRecordField(l_node1, "CODE")            #SCM收货单号
    LET l_rva.rva10 = aws_ttsrv_getRecordField(l_node1, "SOURCE_D_TYPE_ID_CODE")        #来源单据类型   区分:一般采购/委外采购
   
    IF cl_null(l_rva.rva10) OR (l_rva.rva10 NOT MATCHES 'REG' AND l_rva.rva10 NOT MATCHES 'SUB')  THEN 
         LET l_rva.rva10 = 'REG'
    END IF 
    LET l_time = aws_ttsrv_getRecordField(l_node1, "CREATED_ON")                #执行时间
    let l_rva.rvaud05 = l_time[12,19] #darcy:2023/09/20 add 记录时间
    LET l_rva.rva06 = l_time[1,10]
    LET l_rva.rva33 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_ID_CODE")      #执行人
    IF cl_null(l_rva.rva33) THEN 
        LET l_rva.rva33 = g_user
    END IF 
    LET l_rva.rvauser = l_rva.rva33
    LET l_rva.rvagrup = aws_ttsrv_getRecordField(l_node1, "APPLICANT_DEPARTMENT_ID_CODE")         #部门
    IF cl_null(l_rva.rvagrup) THEN 
    	SELECT gen03 INTO l_rva.rvagrup FROM gen_file WHERE gen01 = l_rva.rvauser
    END IF 
    LET l_rva.rva05 = aws_ttsrv_getRecordField(l_node1, "SUPPLIER_ID_CODE")         #供应商
    LET l_rva.rvaud02 =  l_rva.rvaud03   #aws_ttsrv_getRecordField(l_node1, "REMARKS")         #供应商送货单号
    LET l_rva.rvaud01 = l_rva.rvaud01 CLIPPED
    LET l_rva.rvaplant = aws_ttsrv_getRecordField(l_node1, "GROUP_ID_CODE")         #营运中心
    LET l_rva.rvalegal = l_rva.rvaplant
    LET l_rva.rva04 = 'N'
    LET l_rva.rva00 = '1'
    LET l_rva.rva21 = NULL
    LET l_rva.rva29 = '1'
    LET l_rva.rva32 = '0'
    LET l_rva.rvamksg = 'N'
    LET l_rva.rvaprsw = 'Y'
    LET l_rva.rvaprno = 0
    LET l_rva.rvaconf = 'N'
    LET l_rva.rvaspc = '0'
    LET l_rva.rvaoriu = l_rva.rvauser
    LET l_rva.rvaorig = l_rva.rvagrup
    LET l_rva.rvacrat=l_rva.rva06
    LET l_rva.rvaacti='Y'
    
    IF cl_null(l_rva.rva05) THEN
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "供应商为空，请检查"
    	EXIT FOR
    END IF 
    
    SELECT COUNT(*)  INTO l_cnt FROM pmc_file WHERE pmc01= l_rva.rva05 AND pmc05='1' AND pmcacti='Y'
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
    IF l_cnt = 0 THEN
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = l_rva.rva05 ,"供应商不存在或者不是有效状态，请检查！"
    	EXIT FOR 
    END IF     

    #add by shawn 191004 --begin 
    LET l_sql = " select rva01 from rva_file where rvaud04 like '",l_rva.rvaud04 CLIPPED ,"' and rownum=1 and rvaconf <> 'X'"
    PREPARE pre_rva_t FROM l_sql
    EXECUTE pre_rva_t INTO l_rva01_t
    IF NOT cl_null(l_rva01_t) THEN
      LET g_status.code = 0
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = l_rva01_t
      RETURN 
    END IF
    #--end 
    #----------------------------------------------------------------------#
    # 自動取號                                                       #
    #----------------------------------------------------------------------#   
    #add 若有设置，则取设置的单别  ---待补      接口中提供对应采购单 单别  
   # SELECT smyud02 INTO l_rva.rva01   
   # FROM smy_file WHERE smy01 =      

    #darcy:2024/07/03 mod s---
    # 修改默认收货单别，当第一个项次采购单为PRS的时候，取PRT，其它情况取PRD
    LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, 1, "TASK_SHEET_D")
    LET l_rvb.rvb04 = aws_ttsrv_getRecordField(l_node2, "PUR_ID_CODE")
    if l_rvb.rvb04[1,3] = "PRS" then
        let l_rva.rva01 = 'PRT'
    else
      #darcy:2024/07/12 add s---
      if l_rva.rva10 = "SUB" then
        let l_rva.rva01 = 'PRE'
      else
        let l_rva.rva01 = 'PRD'
      end if
      #darcy:2024/07/12 add e---
      # let l_rva.rva01 = 'PRD' #darcy:2024/07/12 mark
    end if
    # SELECT smyslip INTO l_rva.rva01    #抓取单别
    # FROM smy_file
    # WHERE smysys = 'apm' AND smykind = '3' AND smy72 = l_rva.rva10 AND smyacti = 'Y' AND smyauno = 'Y' AND rownum <= 1 AND smyslip NOT LIKE 'HC33%'
    #darcy:2024/07/03 mod e---
    IF cl_null(l_rva.rva01) THEN 
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "无有效收货单别！"
    	EXIT FOR
    END IF 
    CALL s_auto_assign_no("apm",l_rva.rva01,l_rva.rva06,"3","rva_file","rva01","","","")
         RETURNING l_flag, l_rva.rva01
    IF NOT l_flag THEN
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "收货单取号失败！"
      EXIT FOR
    END IF

    #----------------------------------------------------------------------#
    # 執行單頭 INSERT SQL                                                  #
    #----------------------------------------------------------------------#
    INSERT INTO rva_file VALUES (l_rva.*)
    IF SQLCA.SQLCODE THEN
      LET g_status.code = "-1"
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = "insert rva_file失败！"
      EXIT FOR
    END IF
    
    #----------------------------------------------------------------------#
    # 處理單身資料                                                         #
    #----------------------------------------------------------------------#
    LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "TASK_SHEET_D")       #取得目前單頭共有幾筆單身資料
    IF l_cnt2 = 0 THEN
      LET g_status.code = "-1"   #必須有單身資料
      LET g_status.description = "TASK_SHEET_D无资料!"
      EXIT FOR
    END IF
    
     FOR l_j = 1 TO l_cnt2
      LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "TASK_SHEET_D")   #目前單身的 XML 節點
      LET l_rvb.rvb01 = l_rva.rva01
      
      LET l_rvb.rvb02 = aws_ttsrv_getRecordField(l_node2, "SERIAL_NUMBER")       #项次
      LET l_rvb.rvb03 = aws_ttsrv_getRecordField(l_node2, "PUR_SEQ_NUM")         #采购单项次
      LET l_rvb.rvb04 = aws_ttsrv_getRecordField(l_node2, "PUR_ID_CODE")         #采购单
      LET l_rvb05 = aws_ttsrv_getRecordField(l_node2, "MATERIAL_ID_CODE")         #物料
      LET l_rvb.rvb38 = aws_ttsrv_getRecordField(l_node2, "BATCH_NO")             #批号
      LET l_rvb.rvb90 = aws_ttsrv_getRecordField(l_node2, "UNIT_ID_CODE")        #单位
      LET l_rvb.rvb07 = aws_ttsrv_getRecordField(l_node2, "NUM")            #数量
      LET l_rvb.rvb36 = aws_ttsrv_getRecordField(l_node2, "WAREHOUSE_ID_CODE")       #仓库
      LET l_rvb.rvb37 = aws_ttsrv_getRecordField(l_node2, "LOCATION_ID_CODE")        #库位
      LET l_rvb.rvb14 = aws_ttsrv_getRecordField(l_node2, "CARTON")                #箱规
      LET l_rvb.rvb16 = aws_ttsrv_getRecordField(l_node2, "BOXES_NUMBER")          #箱数
      LET l_rvb.rvbplant = aws_ttsrv_getRecordField(l_node2, "GROUP_ID_CODE")      #营运中心
      LET l_rvb.rvbud01 = aws_ttsrv_getRecordField(l_node2, "REMARKS")            #单身备注
      LET l_iqcstatus = aws_ttsrv_getRecordField(l_node2, "QUALITY_STATUS")            #检验状态   若为4 免检，写入合格 
      LET l_time1 = aws_ttsrv_getRecordField(l_node2, "END_EXPIRY_DATE")       #有效期
      LET l_rvb.rvbud14 = l_time1[1,10]
      LET l_time2 = aws_ttsrv_getRecordField(l_node2, "MANUFACTURING_DATE")       #生产日期
      LET l_rvb.rvbud13 = l_time2[1,10]
      LET l_rvb.rvbud04 = l_rva.rvaud03     #送货单号
      #LET l_rvb.rvb40 = g_today
      IF cl_null(l_rvb.rvbud13)  THEN 
        LET l_rvb.rvbud13 = g_today 
      END IF 
      IF cl_null(l_rvb.rvb38) THEN LET l_rvb.rvb38 = ' ' END IF 
      IF cl_null(l_rvb.rvb37) THEN LET l_rvb.rvb37 = ' ' END IF 
    	SELECT pmn04,pmn31,pmn41,pmn80,pmn81,pmn83,pmn84,pmn86,pmn31t,pmn89,pmn930,pmn919,
    				 pmn041,ima25,ima906,ima907,ima44,ima159,ima921,pmn16,ima918,ima491,pmn20,pmn13,pmn50
    	INTO l_rvb.rvb05,l_rvb.rvb10,l_rvb.rvb34,l_rvb.rvb80,l_rvb.rvb81,l_rvb.rvb83,l_rvb.rvb84,
    			 l_rvb.rvb86,l_rvb.rvb10t,l_rvb.rvb89,l_rvb.rvb930,l_rvb.rvb919,
    			 l_rvb.rvb051,l_ima25,l_ima906,l_ima907,
    			 l_ima44,l_ima159,l_ima921,l_pmn16,l_ima918,l_ima491,l_pmn20,l_pmn13,l_pmn50
    	FROM pmn_file,ima_file
    	WHERE pmn01 = l_rvb.rvb04 AND pmn02 = l_rvb.rvb03
    	AND pmn04 = ima01
      IF STATUS THEN
      	LET g_status.code = "-1"
      	LET g_status.description = "ERP中不存在对应的采购单号",l_rvb.rvb04 CLIPPED ,"或项次",l_rvb.rvb03 CLIPPED 
        EXIT FOR
      END IF 
    	IF l_pmn16 <> '2' THEN 
      	LET g_status.code = "-1"
      	LET g_status.description = l_rvb.rvb04 CLIPPED,"采购单非采购发出状态,不可收货!"
        EXIT FOR
    	END IF 
      #add by shawn 201109 --- check material---- begin ----
      SELECT pmn04 INTO l_pmn04 FROM pmn_file WHERE  pmn01 = l_rvb.rvb04 AND pmn02 = l_rvb.rvb03
      IF l_pmn04 <> l_rvb.rvb05 THEN 
      	LET g_status.code = "-1"
      	LET g_status.description = "采购单-项次",l_rvb.rvb04 CLIPPED,"-",l_rvb.rvb03 CLIPPED ,"物料",l_pmn04 CLIPPED ,"和收货物料",l_rvb.rvb05 CLIPPED ,"不一致，请检查！"
        EXIT FOR
      END IF     
      #add by shawn 201109 --- check material---- end ---- 
    	IF cl_null(l_pmn13) THEN LET l_pmn13 = 0 END IF 
    	LET l_pmn20 = l_pmn20 + l_pmn20*l_pmn13/100
    	#IF l_pmn50 + l_rvb.rvb07 > l_pmn20 THEN 
    	IF l_pmn50 + l_pmn58 + l_pmn55 - l_pmn51 - l_pmn53 + l_rvb.rvb07 > l_pmn20 THEN 
      	LET g_status.code = "-1"
      	LET g_status.description = "收货量超过允收数量!"
        EXIT FOR
    	END IF 
    	LET l_rvb.rvb06 = 0
    	LET l_rvb.rvb08 = l_rvb.rvb07
    	LET l_rvb.rvb09 = l_rvb.rvb07
    	LET l_rvb.rvb11 = 0
      IF l_ima491 > 0 THEN
        CALL s_getdate(l_rva.rva06,l_ima491) RETURNING l_rvb.rvb12
      ELSE
        IF cl_null(l_rvb.rvb12) THEN
          LET l_rvb.rvb12 = l_rva.rva06
        END IF
      END IF
    	IF cl_null(l_rvb.rvb16) THEN LET l_rvb.rvb16 = 0 END IF 
    	IF l_rvb.rvb16 = 0 THEN 
    		LET l_rvb.rvb15 = 0
    		ELSE 
    		LET l_rvb.rvb15 = l_rvb.rvb07/l_rvb.rvb16
    	END IF 
    	LET l_rvb.rvb18 = '10'
    	LET l_rvb.rvb19 = '1'
      LET l_rvb.rvb27=0
      LET l_rvb.rvb28=0
      LET l_rvb.rvb29=0
      LET l_rvb.rvb30=0
      LET l_rvb.rvb31=l_rvb.rvb07
      LET l_rvb.rvb32=0
      LET l_rvb.rvb33=0
      LET l_rvb.rvb331=0
      LET l_rvb.rvb332=0
      LET l_rvb.rvb35 = 'N'
      IF l_ima159 <> '1' THEN LET l_rvb.rvb38 = ' ' END IF
      IF l_rvb.rvb05[1,4] = 'MISC' THEN 
        LET l_rvb.rvb36 = ' '
        LET l_rvb.rvb37 = ' '
        LET l_rvb.rvb38 = ' '
      END IF 
      #darcy:2024/08/05 add s---
      # 模具根据imaud34类型，进行选择库位
      if l_rvb.rvb05[1,4] = 'H.MJ.' then
        select imaud34 into l_imaud34 from ima_file where ima01 = l_rvb.rvb05
        case l_imaud34
          when '首批量产'
            let l_rvb.rvb37 = 'MJ03'
          when '试生产'
            let l_rvb.rvb37 = 'MJ02'
          when '免费样品'
            let l_rvb.rvb37 = 'MJ01'
          when '量产增开'
            let l_rvb.rvb37 = 'MJ04'
          otherwise
            let l_rvb.rvb37 = ' '
        end case
      end if
      #darcy:2024/08/05 add e---
      IF l_ima159 = '1' AND l_rvb.rvb38 = ' ' THEN 
      	LET g_status.code = "-1"
      	LET g_status.description = "必须输入批号物料没有维护批号!"
        EXIT FOR
      END IF 
      IF cl_null(l_rvb.rvbud14) THEN 
      	LET g_status.code = "-1"
      	LET g_status.description = "项次:",l_rvb.rvb02 CLIPPED ,"未维护截止有效日期，请检查！"
        EXIT FOR
      END IF
      IF l_rvb.rvb36 <> ' ' THEN 
        SELECT COUNT(*) INTO l_cnt FROM img_file
          WHERE img01 = l_rvb.rvb05
            AND img02 = l_rvb.rvb36
            AND img03 = l_rvb.rvb37
            AND img04 = l_rvb.rvb38
        IF l_cnt = 0 THEN 
          CALL s_add_img(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,
                         l_rvb.rvb38,l_rva.rva01,l_rvb.rvb02,
                         l_rva.rva06)
          UPDATE img_file SET img18 = l_rvb.rvbud14 WHERE img01=l_rvb.rvb05 AND img02=l_rvb.rvb36 AND 
          img03 = l_rvb.rvb37 AND img04 = l_rvb.rvb38 
        END IF 
      END IF 
      CALL t110_get_rvb39(l_rvb.rvb03,l_rvb.rvb04,l_rvb.rvb05,l_rvb.rvb19,l_rva.rva05,g_sma.sma886) 
        RETURNING l_rvb.rvb39
      IF NOT cl_null(l_rvb.rvb80) AND l_rvb.rvb81 <> 0 THEN 
      	LET l_rvb.rvb82 = l_rvb.rvb07/ l_rvb.rvb81
      	LET l_rvb.rvb82 = s_digqty(l_rvb.rvb82,l_rvb.rvb80)
      END IF 
      IF NOT cl_null(l_rvb.rvb83) AND l_rvb.rvb84 <> 0 THEN 
      	LET l_rvb.rvb85 = l_rvb.rvb07/ l_rvb.rvb84
      	LET l_rvb.rvb85 = s_digqty(l_rvb.rvb85,l_rvb.rvb80)
      END IF 
      LET l_rvb.rvb87 = l_rvb.rvb07
      SELECT pmm43,azi03,azi04,gec05,gec07 
      INTO l_pmm43,l_azi03,l_azi04,l_gec05,l_gec07
      FROM pmm_file,azi_file,gec_file
      WHERE pmm22=azi01 AND gec01 = pmm21 AND pmm01=l_rvb.rvb04
      LET l_rvb.rvb88 = l_rvb.rvb07*l_rvb.rvb10
      LET l_rvb.rvb88t = l_rvb.rvb07*l_rvb.rvb10t
      LET l_rvb.rvb88 = cl_digcut(l_rvb.rvb88, l_azi04)
      LET l_rvb.rvb88t = cl_digcut(l_rvb.rvb88t, l_azi04)
      IF l_gec07='Y' THEN
      	IF l_gec05 MATCHES '[AT]' THEN  #FUN-D10128
        	LET l_rvb.rvb10 = l_rvb.rvb10t * ( 1 - l_pmm43/100) #TQC-C30225 add
          LET l_rvb.rvb10 = cl_digcut(l_rvb.rvb10 , l_azi03)            #TQC-C30225 add
          LET l_rvb.rvb88 = l_rvb.rvb88t * ( 1 - l_pmm43/100)
          LET l_rvb.rvb88 = cl_digcut(l_rvb.rvb88 , l_azi04)  
    		ELSE
          LET l_rvb.rvb88 = l_rvb.rvb88t / ( 1 + l_pmm43/100)
          LET l_rvb.rvb88 = cl_digcut(l_rvb.rvb88 , l_azi04)  
    		END IF
      ELSE
    		LET l_rvb.rvb88t = l_rvb.rvb88 * ( 1 + l_pmm43/100)
    		LET l_rvb.rvb88t = cl_digcut( l_rvb.rvb88t , l_azi04)  
      END IF
      CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb90,l_ima25)
           RETURNING l_flag,l_fac
      IF l_flag THEN
         LET l_rvb.rvb90_fac = 1
      ELSE
         LET l_rvb.rvb90_fac = l_fac
      END IF
      LET l_rvb.rvb42 = '4'
      LET l_rvb.rvblegal = l_rvb.rvbplant
      LET l_rvb.rvb40 = '' 
      #add by shawn 191219 -- begin --- 
      IF l_iqcstatus = '4' AND NOT cl_null(l_iqcstatus) AND l_rvb.rvb39 = 'Y' THEN 
           LET l_rvb.rvb40 = g_today 
           LET l_rvb.rvb41 = 1 
           LET l_rvb.rvb33 = l_rvb.rvb07 
      END IF 
      #----end ---  
      #add by shawn 200316 --- beign ----  增加供应商检查----- begin-----  
      SELECT pmm09 INTO l_pmm09 FROM pmm_file WHERE pmm01 = l_rvb.rvb04 
      IF cl_null(l_pmm09) OR l_pmm09 <> l_rva.rva05 THEN 
            LET g_status.code = "-1"
            LET g_status.sqlcode = SQLCA.SQLCODE
            LET g_status.description = "单身采购单供应商",l_pmm09 CLIPPED ,"和收货单头供应商",l_rva.rva05 CLIPPED , "不一致，请检查！"
            EXIT FOR
      END IF 
      #---end  -----
      #add by shawn 200316  = begin ------- 
      IF l_rva.rva10 = "SUB" AND cl_null(l_rvb.rvb34) THEN 
            LET g_status.code = "-1"
            LET g_status.sqlcode = SQLCA.SQLCODE
            LET g_status.description = "委外采购单",l_rva.rvaud04 CLIPPED ,"对应工单不能为空！"
            EXIT FOR
      END IF 
      #---end -----  
      INSERT INTO rvb_file VALUES (l_rvb.*)
      IF SQLCA.SQLCODE THEN
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE
        LET g_status.description = "insert rvb_file失败！"
        EXIT FOR
      END IF
    END FOR
    IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
       EXIT FOR
    END IF
      
  END FOR
  
  {IF g_status.code = '0' THEN 
      INITIALIZE l_ret TO NULL
      CALL cs_rva_y(l_rva.rva01) RETURNING l_ret.*
      IF l_ret.success = 'N' THEN 
         INSERT INTO tc_zmx_file VALUES (g_plant,'11',l_rva.rva01,'0','N','N',to_date(to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),'YYYY/MM/DD HH24:Mi:SS'),g_today,'','','','','',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),'')
      ELSE 
         INSERT INTO tc_zmx_file VALUES (g_plant,'11',l_rva.rva01,'1','Y','Y',to_date(to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),'YYYY/MM/DD HH24:Mi:SS'),g_today,'','','','','',to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),'')
      END IF 
  END IF }

  #全部處理都成功才 COMMIT WORK
  IF g_status.code = "0" THEN
    LET g_status.description = l_rva.rva01
    COMMIT WORK
    CALL p300_rva(l_rva.rva01,'')
  ELSE
    ROLLBACK WORK
  END IF

    
END FUNCTION
