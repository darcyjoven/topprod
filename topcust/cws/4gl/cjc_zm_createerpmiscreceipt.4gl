# Program name...: cjc_zm_createerpmiscreceipt.4gl
# Descriptions...: 提供建立杂收单资料的服务
# Date & Author..: 2018/04/14 by jc

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 

FUNCTION cjc_zm_createerpmiscreceipt()
 
  WHENEVER ERROR CONTINUE
 
  CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
  
  IF g_status.code = "0" THEN
    CALL cjc_zm_createerpmiscreceipt_process()
  END IF
 
  CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
FUNCTION cjc_zm_createerpmiscreceipt_process()
  DEFINE l_i        LIKE type_file.num10,
         l_j        LIKE type_file.num10
  DEFINE l_sql      STRING        
  DEFINE l_cnt      LIKE type_file.num10,
         l_cnt1     LIKE type_file.num10,
         l_cnt2     LIKE type_file.num10
  DEFINE l_ina      RECORD LIKE ina_file.*,
         l_inb      RECORD LIKE inb_file.*
  DEFINE l_node1    om.DomNode,
         l_node2    om.DomNode
  DEFINE l_flag     LIKE type_file.num10,
         l_time     LIKE type_file.chr100,
         l_remark   LIKE type_file.chr1000
  DEFINE l_ina01_t  LIKE ina_file.ina01 


  LET l_cnt1 = aws_ttsrv_getMasterRecordLength("INVENTORY_DETAILS")
  IF l_cnt1 = 0 THEN
    LET g_status.code = "-1"
    LET g_status.description = "No recordset processed!"
    RETURN
  END IF
    
  BEGIN WORK
  
  FOR l_i = 1 TO l_cnt1       
    LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "INVENTORY_DETAILS")        #任务单单头节点
    LET l_ina.ina00 = aws_ttsrv_getRecordField(l_node1, "ISSUE_NUMBER")         #杂收类型
    LET l_ina.ina07 = aws_ttsrv_getRecordField(l_node1, "SOURCE_ID_CODE"),"-",aws_ttsrv_getRecordField(l_node1, "UPDATE_NUM") ,"-",aws_ttsrv_getRecordField(l_node1, "STATUS")   #来源SCM单号        #任务单+执行项次
    LET l_ina.ina04 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_DEPARTMENT_ID_CODE")         #部门
    LET l_ina.ina11 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_ID_CODE")        #申请人
    LET l_ina.inamodu = aws_ttsrv_getRecordField(l_node1, "CREATED_BY_CODE")        #执行人
    LET l_time = aws_ttsrv_getRecordField(l_node1, "CREATED_ON")                                #执行时间
    LET l_ina.ina02 = l_time[1,10]
    LET l_time = aws_ttsrv_getRecordField(l_node1, "SOURCE_CREATED_ON")             #申请时间
    LET l_ina.ina03 = l_time[1,10]
   # IF cl_null(l_ina.ina03) then LET l_ina.ina03 = l_ina.ina02 end IF
    LET l_ina.inaplant = aws_ttsrv_getRecordField(l_node1, "GROUP_ID_CODE")                     #营运中心
    LET l_ina.ina01  =   aws_ttsrv_getRecordField(l_node1, "ORDER_CATEGORY")                     #单别
    IF cl_null(l_ina.inaplant) THEN LET l_ina.inaplant = g_plant END IF 
    LET l_ina.inalegal = l_ina.inaplant
    LET l_ina.inapost='N'
    LET l_ina.inaconf='N'     #FUN-660079
    LET l_ina.inaspc ='0'     #FUN-680010
    LET l_ina.inauser=l_ina.ina11
    LET l_ina.inaoriu = l_ina.ina11 #FUN-980030
    LET l_ina.inaorig = l_ina.ina04 #FUN-980030
    LET l_ina.inagrup=l_ina.ina04
    LET l_ina.inadate=l_ina.ina02
    LET l_ina.ina08 = '0'           #開立  #FUN-550047
    LET l_ina.inamksg = 'N'         #簽核否#FUN-550047
    LET l_ina.ina12='N'       #No.FUN-870100
    LET l_ina.inapos='N'       #No.FUN-870100
    LET l_ina.inacont=''       #No.FUN-870100
    LET l_ina.inaconu=''
    
    #add by shawn 191004 --begin 
    LET l_sql = " select ina01 from ina_file where ina07 like '",l_ina.ina07 CLIPPED ,"' and rownum=1"
    PREPARE pre_ina_t FROM l_sql
    EXECUTE pre_ina_t INTO l_ina01_t
    IF NOT cl_null(l_ina01_t) THEN
      LET g_status.code = 0
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = l_ina01_t
      RETURN 
    END IF
    #--end 
    
    
    #----------------------------------------------------------------------#
    # 自動取號                                                       #
    #----------------------------------------------------------------------#       
    IF cl_null(l_ina.ina01) THEN 
        SELECT smyslip INTO l_ina.ina01    #抓取单别
        FROM smy_file
        WHERE smysys = 'aim' AND smykind = '2' AND smyacti = 'Y' AND smyauno = 'Y' AND rownum <= 1
    END IF 
    IF cl_null(l_ina.ina01) THEN 
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "无有效杂收单别！"
    	EXIT FOR
    END IF 
    CALL s_auto_assign_no("aim",l_ina.ina01,l_ina.ina03,"2","INVENTORY_DETAILS","ina01","","","")
         RETURNING l_flag,l_ina.ina01
    IF NOT l_flag THEN
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "杂收单取号失败！"
      EXIT FOR
    END IF

    #----------------------------------------------------------------------#
    # 執行單頭 INSERT SQL                                                  #
    #----------------------------------------------------------------------#
    INSERT INTO ina_file VALUES (l_ina.*)
    IF SQLCA.SQLCODE THEN
      LET g_status.code = "-1"
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = "insert ina_file失败！"
      EXIT FOR
    END IF
    
    #----------------------------------------------------------------------#
    # 處理單身資料                                                         #
    #----------------------------------------------------------------------#
    LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "INVENTORY_DETAILS")       #取得目前單頭共有幾筆單身資料
    IF l_cnt2 = 0 THEN
      LET g_status.code = "-1"   #必須有單身資料
      LET g_status.description = "inb_file无资料!"
      EXIT FOR
    END IF
    
    FOR l_j = 1 TO l_cnt2
      LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "INVENTORY_DETAILS")   #目前單身的 XML 節點
      LET l_inb.inb01 = l_ina.ina01
      
      LET l_inb.inb03 = l_j #aws_ttsrv_getRecordField(l_node2, "SEQ_NUM")         #项次
      LET l_inb.inb04 = aws_ttsrv_getRecordField(l_node2, "PRODUCT_ID_CODE")    #物料
      LET l_inb.inb07 = aws_ttsrv_getRecordField(l_node2, "LOT_NUM")         #批号
      LET l_inb.inb08 = aws_ttsrv_getRecordField(l_node2, "UNIT_ID_CODE")            #单位
      LET l_inb.inb09 = aws_ttsrv_getRecordField(l_node2, "QUANTITY")    #数量
      LET l_inb.inb05 = aws_ttsrv_getRecordField(l_node2, "WAREHOUSE_ID_CODE")   #仓库
      LET l_inb.inb06 = aws_ttsrv_getRecordField(l_node2, "LOCATION_ID_CODE")    #库位
      LET l_inb.inb15 = aws_ttsrv_getRecordField(l_node2, "REASON_ID_CODE")          #原因
      LET l_inb.inbplant = aws_ttsrv_getRecordField(l_node2, "GROUP_ID_CODE")    #营运中心
      LET l_inb.inbud01 = aws_ttsrv_getRecordField(l_node2, "REMARKS")        #备注
      LET l_inb.inbud02 = aws_ttsrv_getRecordField(l_node2, "DETAILNOTE")        #单身备注
      LET l_inb.inb08_fac = 1
      LET l_inb.inb10 = 'N'
      LET l_inb.inb16 = l_inb.inb09
      SELECT count(*) INTO l_cnt FROM ima_file WHERE ima01= l_inb.inb04 AND ima1010 = '1'
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
      IF l_cnt = 0 THEN 
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        LET g_status.description = "料号:",l_inb.inb04 ,"不存在，或已失效，请检查！"
        EXIT FOR
      END IF 
    #批号管理 ima159 = 1 带批号，否则不带批号  --begin ---- 
     { SELECT count(*) INTO l_cnt FROM ima_file WHERE ima159 = '1'  AND ima01=l_inb.inb04
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
      IF l_cnt = 0 THEN 
         LET l_inb.inb07 = ' ' 
      END IF} 
      #--end---   
      #add by sh 190201  --- begin --- 
      IF l_inb.inb09 <= 0 OR cl_null(l_inb.inb09) THEN
          CONTINUE FOR 
      END IF 
      #---end 
      IF cl_null(l_inb.inb06) THEN LET l_inb.inb06 = ' ' END IF 
      IF cl_null(l_inb.inb07) THEN LET l_inb.inb07 = ' ' END IF 
      LET l_inb.inblegal = l_inb.inbplant
      SELECT COUNT(*) INTO l_cnt
      FROM img_file 
      WHERE img01 = l_inb.inb04 AND img02 = l_inb.inb05
      AND img03 = l_inb.inb06 AND img04 = l_inb.inb07
      IF l_cnt = 0 THEN 
         CALL s_add_img(l_inb.inb04,l_inb.inb05,
                        l_inb.inb06,l_inb.inb07,
                        l_ina.ina01,l_inb.inb03,l_ina.ina02)
      END IF 
      INSERT INTO inb_file VALUES (l_inb.*)
      IF SQLCA.SQLCODE THEN
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        LET g_status.description = "insert inb_file失败！"
        EXIT FOR
      END IF
    END FOR
    IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
       EXIT FOR
    END IF
      
  END FOR
  
  #全部處理都成功才 COMMIT WORK
  IF g_status.code = "0" THEN
    LET g_status.description = l_ina.ina01
    COMMIT WORK
    CALL p300_ina(l_ina.ina01)
  ELSE
    ROLLBACK WORK
  END IF
    
END FUNCTION
