# Program name...: cjc_zm_createerprequisition.4gl
# Descriptions...: V4.0 提供建立调拨单资料的服务
# Date & Author..: 2019/07/23  by shawn 

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 

FUNCTION cjc_zm_createerprequisition()
 
  WHENEVER ERROR CONTINUE
 
  CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
  
  IF g_status.code = "0" THEN
    CALL cjc_zm_createerprequisition_process()
  END IF
 
  CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
FUNCTION cjc_zm_createerprequisition_process()
  DEFINE l_i        LIKE type_file.num10,
         l_j        LIKE type_file.num10
  DEFINE l_sql      STRING        
  DEFINE l_cnt      LIKE type_file.num10,
         l_cnt1     LIKE type_file.num10,
         l_cnt2     LIKE type_file.num10
  DEFINE l_imm      RECORD LIKE imm_file.*,
         l_imn      RECORD LIKE imn_file.*
  DEFINE l_node1    om.DomNode,
         l_node2    om.DomNode
  DEFINE l_flag     LIKE type_file.num10,
         l_time     LIKE type_file.chr100,
         l_remark   LIKE type_file.chr1000
  DEFINE l_imm01_t  LIKE imm_file.imm01 


  LET l_cnt1 = aws_ttsrv_getMasterRecordLength("INVENTORY_DETAILS")
  IF l_cnt1 = 0 THEN
    LET g_status.code = "-1"
    LET g_status.description = "No recordset processed!"
    RETURN
  END IF
    
  BEGIN WORK
  
  FOR l_i = 1 TO l_cnt1       
    LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "INVENTORY_DETAILS")        #目前處理單檔的 XML 節點
    
    LET l_imm.imm09 = aws_ttsrv_getRecordField(l_node1, "CODE"),"-",aws_ttsrv_getRecordField(l_node1, "UPDATE_NUM"),"-",aws_ttsrv_getRecordField(l_node1, "STATUS")   #来源SCM单号         #任务单+执行项次
    LET l_imm.imm14 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_DEPARTMENT_ID_CODE")         #部门
    LET l_imm.imm16 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_ID_CODE")        #申请人         #取得此筆單檔資料的欄位值
   #LET l_time = aws_ttsrv_getRecordField(l_node1, "finishTime")         #取得此筆單檔資料的欄位值
    LET l_imm.immmodu = aws_ttsrv_getRecordField(l_node1, "CREATED_BY_CODE")        #执行人
    LET l_time = aws_ttsrv_getRecordField(l_node1, "CREATED_ON")         #取得此筆單檔資料的欄位值
    LET l_imm.imm17 = l_time[1,10]
    IF cl_null(l_imm.imm02) THEN 
        LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "单据日期不能为空！"
    	EXIT FOR
       # LET l_imm.imm02 = g_today
    END IF 
    LET l_time = aws_ttsrv_getRecordField(l_node1, "SOURCE_CREATED_ON")             #申请时间
    LET l_imm.imm02 = l_time[1,10]
   #LET l_imm.immplant = aws_ttsrv_getRecordField(l_node1, "GROUP_ID_CODE")         #取得此筆單檔資料的欄位值
   #LET l_imm.immlegal = l_imm.immplant
    LET l_imm.immplant = g_plant
    LET l_imm.immlegal = g_legal
    LET l_imm.imm03 = 'N'
    LET l_imm.imm10 = '1'
    LET l_imm.imm15 = '0'
    LET l_imm.immmksg = "N"
    #LET l_imm.imm17  =l_imm.imm02
    LET l_imm.immconf= 'N' #FUN-660029
    LET l_imm.immspc = '0' #FUN-680010
    LET l_imm.immuser=l_imm.imm14
    LET l_imm.immoriu = l_imm.imm14 #FUN-980030
    LET l_imm.immorig = l_imm.imm16 #FUN-980030
    LET l_imm.immgrup=l_imm.imm16
    LET l_imm.immdate=l_imm.imm02
   #add by shawn 191004 --begin 
    LET l_sql = "select imm01 from imm_file where imm09 like '",l_imm.imm09 CLIPPED ,"' and rownum=1"
    PREPARE pre_imm_t FROM l_sql
    EXECUTE pre_imm_t INTO l_imm01_t
    IF NOT cl_null(l_imm01_t) THEN
      LET g_status.code = 0
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = l_imm01_t
      RETURN 
    END IF
    #--end 
    
    #----------------------------------------------------------------------#
    # 自動取號                                                       #
    #----------------------------------------------------------------------#       
    SELECT smyslip INTO l_imm.imm01    #抓取单别
    FROM smy_file
    WHERE smysys = 'aim' AND smykind = '4' AND smyacti = 'Y' AND smyauno = 'Y' AND rownum <= 1
    IF cl_null(l_imm.imm01) THEN 
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "无有效调拨单别！"
    	EXIT FOR
    END IF 
    CALL s_auto_assign_no("aim",l_imm.imm01,l_imm.imm02,"","imm_file","imm01","","","")
         RETURNING l_flag,l_imm.imm01
    IF NOT l_flag THEN
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "调拨单取号失败！"
      EXIT FOR
    END IF

    #----------------------------------------------------------------------#
    # 執行單頭 INSERT SQL                                                  #
    #----------------------------------------------------------------------#
    INSERT INTO imm_file VALUES (l_imm.*)
    IF SQLCA.SQLCODE THEN
      LET g_status.code = "-1"
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = "insert imm_file失败！"
      EXIT FOR
    END IF
    
    #----------------------------------------------------------------------#
    # 處理單身資料                                                         #
    #----------------------------------------------------------------------#
    LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "INVENTORY_DETAILS")       #取得目前單頭共有幾筆單身資料
    IF l_cnt2 = 0 THEN
      LET g_status.code = "-1"   #必須有單身資料
      LET g_status.description = "LOGI_STORE_ALLOCATION_D 单身无资料!"
      EXIT FOR
    END IF
    
    FOR l_j = 1 TO l_cnt2
      LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "INVENTORY_DETAILS")   #目前單身的 XML 節點
      LET l_imn.imn01 = l_imm.imm01
      
      LET l_imn.imn02 = aws_ttsrv_getRecordField(l_node2, "SEQ_NUM")         #取得此筆單檔資料的欄位值
      LET l_imn.imn03 = aws_ttsrv_getRecordField(l_node2, "PRODUCT_ID_CODE")         #取得此筆單檔資料的欄位值
      LET l_imn.imn06 = aws_ttsrv_getRecordField(l_node2, "LOT_NUM")         #取得此筆單檔資料的欄位值
      LET l_imn.imn09 = aws_ttsrv_getRecordField(l_node2, "UNIT_ID_CODE")         #取得此筆單檔資料的欄位值
      LET l_imn.imn10 = aws_ttsrv_getRecordField(l_node2,  "QUANTITY")         #取得此筆單檔資料的欄位值
      LET l_imn.imn22 = aws_ttsrv_getRecordField(l_node2,"QUANTITY")         #取得此筆單檔資料的欄位值
      LET l_imn.imn04 = aws_ttsrv_getRecordField(l_node2, "OUT_WAREHOUSE_ID_CODE")         #取得此筆單檔資料的欄位值
      LET l_imn.imn05 = aws_ttsrv_getRecordField(l_node2, "OUT_LOCATION_ID_CODE")         #取得此筆單檔資料的欄位值
      LET l_imn.imn15 = aws_ttsrv_getRecordField(l_node2, "IN_WAREHOUSE_ID_CODE")         #取得此筆單檔資料的欄位值
      LET l_imn.imn16 = aws_ttsrv_getRecordField(l_node2, "IN_LOCATION_ID_CODE")         #取得此筆單檔資料的欄位值
      LET l_imn.imn28 = aws_ttsrv_getRecordField(l_node2, "REASON_ID_CODE")         #取得此筆單檔資料的欄位值
     #LET l_imn.imnplant = aws_ttsrv_getRecordField(l_node2,"GROUP_ID_CODE")         #取得此筆單檔資料的欄位值
      LET l_imn.imnud01 = aws_ttsrv_getRecordField(l_node2, "REMARKS")         #取得此筆單檔資料的欄位值
      LET l_imn.imn02 =  l_j
      IF cl_null(l_imn.imn02) THEN 
          SELECT NVL(MAX(imn02),0)+1 INTO l_imn.imn02 FROM imn_file 
           WHERE imn01 = l_imn.imn01
      END IF 
    #批号管理 ima159 = 1 带批号，否则不带批号  --begin ---- 
     { SELECT count(*) INTO l_cnt FROM ima_file WHERE ima159 = '1'  AND ima01=l_imn.imn03
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
      IF l_cnt = 0 THEN 
          LET l_imn.imn06 = ' '
      END IF} 
      #--end---   
      
      IF cl_null(l_imn.imn06) THEN LET l_imn.imn06 = ' ' END IF 
      IF cl_null(l_imn.imn05) THEN LET l_imn.imn05 = ' ' END IF 
      IF cl_null(l_imn.imn16) THEN LET l_imn.imn16 = ' ' END IF 
      LET l_imn.imn17 = l_imn.imn06
      LET l_imn.imn20 = l_imn.imn09
      LET l_imn.imn21 = 1
      #LET l_imn.imn22 = l_imn.imn10
      LET l_imn.imn29='N'
     #LET l_imn.imnlegal = l_imn.imnplant
      IF cl_null(l_imn.imn10) OR cl_null(l_imn.imn22) OR l_imn.imn10 = 0 OR l_imn.imn22 = 0  THEN
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        LET g_status.description = "调拨量不能为空或者0，请检查！"
        EXIT FOR
      END IF
      IF cl_null(l_imn.imn04) OR cl_null(l_imn.imn15) THEN
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        LET g_status.description = "调拨出仓库或者调拨入仓库为空，检查对应的SCM仓库是否有设置对应的ERP仓库！"
        EXIT FOR
      END IF
      LET l_imn.imnplant = g_plant
      LET l_imn.imnlegal = g_legal
      SELECT COUNT(*) INTO l_cnt
      FROM img_file 
      WHERE img01 = l_imn.imn03 AND img02 = l_imn.imn15
      AND img03 = l_imn.imn16 AND img04 = l_imn.imn17
      IF l_cnt = 0 THEN 
        CALL s_add_img(l_imn.imn03,l_imn.imn15,
                        l_imn.imn16,l_imn.imn17,
                        l_imm.imm01,l_imn.imn02,
                        l_imm.imm17)
      END IF 
      INSERT INTO imn_file VALUES (l_imn.*)
      IF SQLCA.SQLCODE THEN
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        LET g_status.description = "insert imn_file失败！"
        EXIT FOR
      END IF
    END FOR
    IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
       EXIT FOR
    END IF
      
  END FOR
  
  #全部處理都成功才 COMMIT WORK
  IF g_status.code = "0" THEN
    LET g_status.description = l_imm.imm01
    COMMIT WORK
    CALL p300_imm(l_imm.imm01)
  ELSE
    ROLLBACK WORK
  END IF
    
END FUNCTION
