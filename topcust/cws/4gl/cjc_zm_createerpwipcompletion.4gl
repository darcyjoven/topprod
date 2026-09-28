# Program name...: cjc_zm_createerpwipcompletion.4gl
# Descriptions...: 提供建立半成品资料的服务
# Date & Author..: 2018/04/14 by jc

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 

FUNCTION cjc_zm_createerpwipcompletion()
 
  WHENEVER ERROR CONTINUE
 
  CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
  
  IF g_status.code = "0" THEN
    CALL cjc_zm_createerpwipcompletion_process()
  END IF
 
  CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
FUNCTION cjc_zm_createerpwipcompletion_process()
  DEFINE l_i        LIKE type_file.num10,
         l_j        LIKE type_file.num10
  DEFINE l_sql      STRING        
  DEFINE l_cnt      LIKE type_file.num10,
         l_cnt1     LIKE type_file.num10,
         l_cnt2     LIKE type_file.num10
  DEFINE l_sfu      RECORD LIKE sfu_file.*,
         l_sfv      RECORD LIKE sfv_file.*,
         l_sfb      RECORD LIKE sfb_file.*
  DEFINE l_node1    om.DomNode,
         l_node2    om.DomNode
  DEFINE l_flag     LIKE type_file.num10,
         l_time     LIKE type_file.chr100,
         l_remark   LIKE type_file.chr1000,
         l_qty      LIKE sfb_file.sfb08
  DEFINE l_sfu01_t  LIKE sfu_file.sfu01 


  LET l_cnt1 = aws_ttsrv_getMasterRecordLength("INVENTORY_DETAILS")
  IF l_cnt1 = 0 THEN
    LET g_status.code = "-1"
    LET g_status.description = "No recordset processed!"
    RETURN
  END IF
    
  BEGIN WORK
  
  FOR l_i = 1 TO l_cnt1       
    LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "INVENTORY_DETAILS")        #目前處理單檔的 XML 節點
    LET l_sfu.sfu00 = '1'
    LET l_sfu.sfu07 =  aws_ttsrv_getRecordField(l_node1, "SOURCE_ID_CODE"),"-",aws_ttsrv_getRecordField(l_node1, "UPDATE_NUM") ,"-",aws_ttsrv_getRecordField(l_node1, "STATUS")   #来源SCM单号        #任务单+执行项次
    LET l_sfu.sfu04 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_DEPARTMENT_ID_CODE")         #部门
    LET l_sfu.sfu16 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_ID_CODE")         #人员
    LET l_sfu.sfuuser = aws_ttsrv_getRecordField(l_node1, "CREATED_BY_CODE")         #执行人
    LET l_time = aws_ttsrv_getRecordField(l_node1, "CREATED_ON")                   #执行时间
    LET l_sfu.sfu02 = l_time[1,10]
    LET l_time = aws_ttsrv_getRecordField(l_node1, "SOURCE_CREATED_ON")             #申请时间
    LET l_sfu.sfu14 = l_time[1,10]
    LET l_sfu.sfuplant = aws_ttsrv_getRecordField(l_node1, "GROUP_ID_CODE")        #营运中心
    LET l_remark = aws_ttsrv_getRecordField(l_node1, "REMARKS")                     #备注
    LET l_sfu.sfu07 = l_sfu.sfu07 CLIPPED
    LET l_sfu.sfulegal = l_sfu.sfuplant
    LET l_sfu.sfupost='N'
    LET l_sfu.sfuconf='N'     #FUN-660079
    LET l_sfu.sfuuser=l_sfu.sfu16
    LET l_sfu.sfuoriu = l_sfu.sfu16 #FUN-980030
    LET l_sfu.sfuorig = l_sfu.sfu04 #FUN-980030
    LET l_sfu.sfugrup=l_sfu.sfu04
    LET l_sfu.sfudate=l_sfu.sfu02
    LET l_sfu.sfu15 = '0'           #開立  #FUN-550047
    LET l_sfu.sfumksg = 'N'         #簽核否#FUN-550047
    
    #add by shawn 191004 --begin 
    LET l_sql = " select sfu01 from sfu_file where sfu07 like '",l_sfu.sfu07 CLIPPED ,"' and rownum=1"
    PREPARE pre_sfu_t FROM l_sql
    EXECUTE pre_sfu_t INTO l_sfu01_t
    IF NOT cl_null(l_sfu01_t) THEN
      LET g_status.code = 0
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = l_sfu01_t
      RETURN 
    END IF
    #--end 
    
    
    #----------------------------------------------------------------------#
    # 自動取號                                                       #
    #----------------------------------------------------------------------#       
    SELECT smyslip INTO l_sfu.sfu01    #抓取单别
    FROM smy_file
    WHERE smysys = 'asf' AND smykind = 'A' AND smyacti = 'Y' AND smyauno = 'Y' AND rownum <= 1 and smydesc not like '%期初%' AND smyslip not like 'TT%' 
    IF cl_null(l_sfu.sfu01) THEN 
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "无有效完工入库单别！"
    	EXIT FOR
    END IF 
    CALL s_auto_assign_no("asf",l_sfu.sfu01,l_sfu.sfu14,"A","sfu_file","sfu01","","","")
         RETURNING l_flag,l_sfu.sfu01
    IF NOT l_flag THEN
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "完工入库单取号失败！"
      EXIT FOR
    END IF

    #----------------------------------------------------------------------#
    # 執行單頭 INSERT SQL                                                  #
    #----------------------------------------------------------------------#
    INSERT INTO sfu_file VALUES (l_sfu.*)
    IF SQLCA.SQLCODE THEN
      LET g_status.code = "-1"
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = "insert sfu_file失败！"
      EXIT FOR
    END IF
    
    #----------------------------------------------------------------------#
    # 處理單身資料                                                         #
    #----------------------------------------------------------------------#
    LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "INVENTORY_DETAILS")       #取得目前單頭共有幾筆單身資料
    IF l_cnt2 = 0 THEN
      LET g_status.code = "-1"   #必須有單身資料
      LET g_status.description = "sfv_file无资料!"
      EXIT FOR
    END IF
    
    FOR l_j = 1 TO l_cnt2
      LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "INVENTORY_DETAILS")   #目前單身的 XML 節點
      LET l_sfv.sfv01 = l_sfu.sfu01
      
      LET l_sfv.sfv03 =  l_j    # aws_ttsrv_getRecordField(l_node2, "SEQ_NUM")         #项次
      LET l_sfv.sfv11 = aws_ttsrv_getRecordField(l_node2, "WORK_SHEET_CODE")           #工单
      LET l_sfv.sfv04 = aws_ttsrv_getRecordField(l_node2, "PRODUCT_ID_CODE")         #物料
      LET l_sfv.sfv07 = aws_ttsrv_getRecordField(l_node2, "LOT_NUM")         #批号
      LET l_sfv.sfv08 = aws_ttsrv_getRecordField(l_node2, "UNIT_ID_CODE")         #单位
      LET l_sfv.sfv09 = aws_ttsrv_getRecordField(l_node2, "QUANTITY")         #数量
      LET l_sfv.sfv05 = aws_ttsrv_getRecordField(l_node2, "WAREHOUSE_ID_CODE")         #仓库
      LET l_sfv.sfv06 = aws_ttsrv_getRecordField(l_node2, "LOCATION_ID_CODE")         #库位
      LET l_sfv.sfv15 = aws_ttsrv_getRecordField(l_node2, "REASON")         #原因
      LET l_sfv.sfvplant = aws_ttsrv_getRecordField(l_node2, "GROUP_ID_CODE")         #营运中心
      LET l_sfv.sfv12 = aws_ttsrv_getRecordField(l_node2, "REMARKS")         #备注
      LET l_sfv.sfvud07 = aws_ttsrv_getRecordField(l_node2, "BOXES_NUMBER")         #箱数
      LET l_sfv.sfvud08 = aws_ttsrv_getRecordField(l_node2, "WEIGHT")         #箱数
      LET l_sfv.sfv20  = aws_ttsrv_getRecordField(l_node2, "RUNCARD_CODE")         #runcard 
      IF cl_null(l_sfv.sfv03) THEN 
          SELECT NVL(MAX(sfv03),0)+1
            INTO l_sfv.sfv03
            FROM sfv_file 
           WHERE sfv01 = l_sfv.sfv01
      END IF 
      LET l_sfv.sfv16 = 'N'
      LET l_sfv.sfv30 = l_sfv.sfv08
      LET l_sfv.sfv31 = 1
      LET l_sfv.sfv32 = l_sfv.sfv09
          #批号管理 ima159 = 1 带批号，否则不带批号  --begin ---- 
     { SELECT count(*) INTO l_cnt FROM ima_file WHERE ima159 = '1'  AND ima01=l_sfv.sfv04
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
      IF l_cnt = 0 THEN 
          LET l_sfv.sfv07 = ' '
      END IF} 
      #--end---
      IF cl_null(l_sfv.sfv06) THEN LET l_sfv.sfv06 = ' ' END IF 
      IF cl_null(l_sfv.sfv07) THEN LET l_sfv.sfv07 = ' ' END IF 
      INITIALIZE l_sfb.* TO NULL
      SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = l_sfv.sfv11
      IF cl_null(l_sfb.sfb01) THEN 
        LET g_status.code = "-1"
        LET g_status.description = "无此工单!"
        EXIT FOR
      END IF 
      IF l_sfb.sfb87 <> 'Y' OR l_sfb.sfb04 = '0' OR l_sfb.sfb04 = '8' THEN 
        LET g_status.code = "-1"
        LET g_status.description = l_sfb.sfb01,"工单未审核或已结案!"
        EXIT FOR
      END IF 
      IF l_sfb.sfb39 = '1' THEN 
      	LET l_qty = l_sfb.sfb081 - l_sfb.sfb09 - l_sfb.sfb12
      	ELSE 
      	LET l_qty = l_sfb.sfb08 - l_sfb.sfb09 - l_sfb.sfb12
      END IF 
      #IF l_qty < l_sfv.sfv09 THEN 
      #  LET g_status.code = "-1"
      #  LET g_status.description = "入库量大于可入库量!"
      #  EXIT FOR
     # END IF 
      LET l_sfv.sfv930 = l_sfb.sfb98
      LET l_sfv.sfvlegal = l_sfv.sfvplant
      SELECT COUNT(*) INTO l_cnt
      FROM img_file 
      WHERE img01 = l_sfv.sfv04 AND img02 = l_sfv.sfv05
      AND img03 = l_sfv.sfv06 AND img04 = l_sfv.sfv07
      IF l_cnt = 0 THEN 
         CALL s_add_img(l_sfv.sfv04,l_sfv.sfv05,
                        l_sfv.sfv06,l_sfv.sfv07,
                        l_sfu.sfu01,l_sfv.sfv03,l_sfu.sfu02)
      END IF 
      INSERT INTO sfv_file VALUES (l_sfv.*)
      IF SQLCA.SQLCODE THEN
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        LET g_status.description = "insert sfv_file失败！"
        EXIT FOR
      END IF
    END FOR
    IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
       EXIT FOR
    END IF
      
  END FOR
  
  #全部處理都成功才 COMMIT WORK
  IF g_status.code = "0" THEN
    LET g_status.description = l_sfu.sfu01
    COMMIT WORK
    CALL p300_sfu(l_sfu.sfu01)
    #CALL t620_dk(l_sfu.sfu01)
  ELSE
    ROLLBACK WORK
  END IF
    
END FUNCTION
