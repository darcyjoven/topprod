# Program name...: cjc_zm_createerpgodownentry.4gl
# Descriptions...: SCM v4.0提供建立入库单资料的服务
# Date & Author..: 2018/04/14 by jc
# Modify.........: No:2022022201 22/02/22 By jc 调整审核位置
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 

FUNCTION cjc_zm_createerpgodownentry()
 
  WHENEVER ERROR CONTINUE
 
  CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
  
  IF g_status.code = "0" THEN
    CALL cjc_zm_createerpgodownentry_process()
  END IF
 
  CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
FUNCTION cjc_zm_createerpgodownentry_process()
  DEFINE l_i        LIKE type_file.num10,
         l_j        LIKE type_file.num10
  DEFINE l_sql      STRING        
  DEFINE l_cnt      LIKE type_file.num10,
         l_cnt1     LIKE type_file.num10,
         l_cnt2     LIKE type_file.num10
  DEFINE l_rvu      RECORD LIKE rvu_file.*,
         l_rvv      RECORD LIKE rvv_file.*
  DEFINE l_node1    om.DomNode,
         l_node2    om.DomNode
  DEFINE l_flag     LIKE type_file.num10,
         l_time     LIKE type_file.chr100,
         l_remark   LIKE type_file.chr1000,
         l_rvv31    LIKE rvv_file.rvv31,
         l_ima25    LIKE ima_file.ima25,
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
			   l_fac	    LIKE rvv_file.rvv35_fac,
			   l_rvb31    LIKE rvb_file.rvb31,
			   l_rvv17    LIKE rvv_file.rvv17,
			   l_img09    LIKE img_file.img09,
               l_rvu01_t  LIKE rvu_file.rvu01 

  DEFINE l_ret RECORD
           success LIKE type_file.chr1,
           code    LIKE type_file.chr10,
           msg     STRING
               END RECORD
  DEFINE l_pmm09   LIKE pmm_file.pmm09 
  DEFINE l_pmn04   LIKE pmn_file.pmn04

  LET l_cnt1 = aws_ttsrv_getMasterRecordLength("INVENTORY_DETAILS")
  IF l_cnt1 = 0 THEN
    LET g_status.code = "-1"
    LET g_status.description = "No recordset processed!"
    RETURN
  END IF
    
  BEGIN WORK
  
  FOR l_i = 1 TO l_cnt1       
    LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "INVENTORY_DETAILS")        #目前處理單檔的 XML 節點
    
    LET l_rvu.rvuud01 = aws_ttsrv_getRecordField(l_node1, "SOURCE_ID_CODE"),"-",aws_ttsrv_getRecordField(l_node1, "UPDATE_NUM"),"-",aws_ttsrv_getRecordField(l_node1, "STATUS")         #任务单+执行项次
    LET l_rvu.rvu02 = aws_ttsrv_getRecordField(l_node1, "RE_SOURCE_ID_CODE")         #入库单号
    LET l_rvu.rvu08 = aws_ttsrv_getRecordField(l_node1, "SOURCE_D_TYPE_ID_CODE")   #单据类型
    IF cl_null(l_rvu.rvu08) THEN LET l_rvu.rvu08 = 'REG' END IF 
    LET l_time = aws_ttsrv_getRecordField(l_node1, "CREATED_ON")                     #单据时间
    LET l_rvu.rvu03 = l_time[1,10]
    LET l_rvu.rvu07 = aws_ttsrv_getRecordField(l_node1, "CREATED_BY_CODE")           #执行人
    LET l_rvu.rvuuser = l_rvu.rvu07
    LET l_rvu.rvugrup = aws_ttsrv_getRecordField(l_node1, "APPLICANT_DEPARTMENT_ID_CODE")         #申请部门  ？
    IF cl_null(l_rvu.rvugrup) THEN 
    	SELECT gen03 INTO l_rvu.rvugrup FROM gen_file WHERE gen01 = l_rvu.rvuuser
    END IF 
    LET l_rvu.rvu06 = l_rvu.rvugrup
    LET l_rvu.rvuud02 = aws_ttsrv_getRecordField(l_node1, "RE_DELIVERY_CODE")           #送货单号
    LET l_remark = aws_ttsrv_getRecordField(l_node1, "REMARKS")                 #备注
    LET l_rvu.rvuud01 = l_rvu.rvuud01 CLIPPED
    LET l_rvu.rvuplant = aws_ttsrv_getRecordField(l_node1, "GROUP_ID_CODE")     #营运中心
    LET l_rvu.rvulegal = l_rvu.rvuplant
    SELECT COUNT(*) INTO l_cnt
    FROM rva_file WHERE rva01 = l_rvu.rvu02 AND rvaconf = 'Y'
    IF l_cnt = 0 THEN 
    	LET g_status.code = "-1"
    	LET g_status.description = "收货单不存在或未审核!"
    	EXIT FOR
    END IF 

    #add by shawn 191004 --begin 
    LET l_sql = " select rvu01 from rvu_file where rvu00 ='1' and rvuud01 = '",l_rvu.rvuud01 CLIPPED ,"'   and rownum=1 AND rvuconf<>'X'"
    PREPARE pre_rvu_t FROM l_sql
    EXECUTE pre_rvu_t INTO l_rvu01_t
    IF NOT cl_null(l_rvu01_t) THEN
      LET g_status.code = 0
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = l_rvu01_t
      RETURN 
    END IF
    #--end 
    LET l_rvu.rvu00 = '1'
    SELECT rva05,pmc03,rva29 INTO l_rvu.rvu04,l_rvu.rvu05,l_rvu.rvu21
    FROM rva_file,pmc_file WHERE rva05 = pmc01 AND rva01 = l_rvu.rvu02
    LET l_rvu.rvu20='N'
    LET l_rvu.rvuconf='N'
    LET l_rvu.rvuacti='Y'
    LET l_rvu.rvudate=l_rvu.rvu03
    LET l_rvu.rvu900 = '0'
    LET l_rvu.rvumksg = 'N'
    LET l_rvu.rvu17='0'
    LET l_rvu.rvucrat = l_rvu.rvu03
    LET l_rvu.rvupos = 'N'
    LET l_rvu.rvuoriu = l_rvu.rvuuser
    LET l_rvu.rvuorig = l_rvu.rvugrup
    LET l_rvu.rvu27 = '1'
    LET l_rvu.rvu09 = NULL
    
    #----------------------------------------------------------------------#
    # 自動取號                                                       #
    #----------------------------------------------------------------------#       
    SELECT smyslip INTO l_rvu.rvu01    #抓取单别
    FROM smy_file
    WHERE smysys = 'apm' AND smykind = '7' AND smy72 = l_rvu.rvu08 AND smyacti = 'Y' AND smyauno = 'Y' AND rownum <= 1
    IF cl_null(l_rvu.rvu01) THEN 
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "无有效入库单别！"
    	EXIT FOR
    END IF 
    CALL s_auto_assign_no("apm",l_rvu.rvu01,l_rvu.rvu03,"7","INVENTORY_DETAILS","rvu01","","","")
         RETURNING l_flag,l_rvu.rvu01
    IF NOT l_flag THEN
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "入库单取号失败！"
      EXIT FOR
    END IF

    #----------------------------------------------------------------------#
    # 執行單頭 INSERT SQL                                                  #
    #----------------------------------------------------------------------#
    INSERT INTO rvu_file VALUES (l_rvu.*)
    IF SQLCA.SQLCODE THEN
      LET g_status.code = "-1"
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = "insert rvu_file失败！"
      EXIT FOR
    END IF
    
    #----------------------------------------------------------------------#
    # 處理單身資料                                                         #
    #----------------------------------------------------------------------#
    LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "INVENTORY_DETAILS")       #取得目前單頭共有幾筆單身資料
    IF l_cnt2 = 0 THEN
      LET g_status.code = "-1"   #必須有單身資料
      LET g_status.description = "rvv_file无资料!"
      EXIT FOR
    END IF
    
    FOR l_j = 1 TO l_cnt2
      LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "INVENTORY_DETAILS")   #目前單身的 XML 節點
      LET l_rvv.rvv01 = l_rvu.rvu01
      
      LET l_rvv.rvv02 = aws_ttsrv_getRecordField(l_node2, "SEQ_NUM")                   #项次
      LET l_rvv.rvv05 = aws_ttsrv_getRecordField(l_node2, "RE_SOURCE_SEQ_NUM")         #来源入库单项次
      LET l_rvv.rvv04 = aws_ttsrv_getRecordField(l_node2, "RE_SOURCE_ID_CODE")         #来源入库单单号
      LET l_rvv.rvv37 = aws_ttsrv_getRecordField(l_node2, "PUR_SEQ_NUM")               #采购单项次
      LET l_rvv.rvv36 = aws_ttsrv_getRecordField(l_node2, "PUR_ID_CODE")               #采购单单号
      LET l_rvv.rvv31 = aws_ttsrv_getRecordField(l_node2, "PRODUCT_ID_CODE")           #物料编号
      LET l_rvv.rvv34 = aws_ttsrv_getRecordField(l_node2, "LOT_NUM")                   #批号
      LET l_rvv.rvv35 = aws_ttsrv_getRecordField(l_node2, "SOURCE_UNIT_ID_CODE")       #单位
      LET l_rvv.rvv17 = aws_ttsrv_getRecordField(l_node2, "SOURCE_QUANTITY")                  #数量
      LET l_rvv.rvv32 = aws_ttsrv_getRecordField(l_node2, "WAREHOUSE_ID_CODE")         #仓库编号
      LET l_rvv.rvv33 = aws_ttsrv_getRecordField(l_node2, "LOCATION_ID_CODE")          #库位编号
      LET l_rvv.rvvplant = aws_ttsrv_getRecordField(l_node2, "GROUP_ID_CODE")          #营运中心
      LET l_rvv.rvvud01 = aws_ttsrv_getRecordField(l_node2, "REMARKS")                 #备注
      LET l_rvv.rvvud05 = l_rvu.rvuud02 
      #批号管理 ima159 = 1 带批号，否则不带批号  --begin ---- 
     { SELECT count(*) INTO l_cnt FROM ima_file WHERE ima159 = '1' AND ima01=l_rvv.rvv31
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
      IF l_cnt = 0 THEN 
          LET l_rvv.rvv34 = ' '
      END IF} 
      #--end---   
      IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34 = ' ' END IF 
      IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33 = ' ' END IF 
      IF cl_null(l_rvv.rvv02) THEN 
          SELECT NVL(MAX(rvv02),0)+1                   #入库单项次
            INTO l_rvv.rvv02
            FROM rvv_file
           WHERE rvv01 = l_rvv.rvv01
      END IF 

      #收货单号  #rvv05 
      # SELECT rvb02 INTO l_rvv.rvv05 FROM rvb_file WHERE rvb01 = l_rvu.rvu02 AND rvb04 = l_rvv.rvv36 AND rvb03 = l_rvv.rvv37 
      # IF cl_null(l_rvv.rvv05) THEN 
      #      LET g_status.code = "-1"
      #      LET g_status.description = "收货项次不能为空！"
      #      EXIT FOR
      # END IF 
      #
      
      IF cl_null(l_rvv.rvv32) THEN 
        LET g_status.code = "-1"   #必須有單身資料
        LET g_status.description = "仓库不能为空!"
        EXIT FOR
      END IF 
      SELECT pmn16 INTO l_pmn16
    	FROM pmn_file
    	WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37
    	IF l_pmn16 <> '2' THEN 
      	LET g_status.code = "-1"
      	LET g_status.description = "采购单非采购发出状态,不可入库!"
        EXIT FOR
    	END IF 

      #add by shawn 201109 --- check material---- begin ----
      SELECT pmn04 INTO l_pmn04 FROM pmn_file WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37 
      IF l_pmn04 <> l_rvv.rvv31 THEN 
      	LET g_status.code = "-1"
      	LET g_status.description = "采购单-项次",l_rvv.rvv36 CLIPPED,"-",l_rvv.rvv37 CLIPPED ,"物料",l_pmn04 CLIPPED ,"和入库物料",l_rvv.rvv31 CLIPPED ,"不一致，请检查！"
        EXIT FOR
      END IF     
      #add by shawn 201109 --- check material---- end ---- 
      
    	LET l_rvv.rvv03=l_rvu.rvu00
      LET l_rvv.rvv06=l_rvu.rvu04
      LET l_rvv.rvv09=l_rvu.rvu03
      
      SELECT rvb31,rvb80,rvb81,rvb83,rvb84,rvb86,rvb34,rvb89,rvb35,rvb051,rvb90_fac,
      rvb25,rvb930,rvb42,rvb43,rvb44,rvb45,rvb919,rvb22,rvb10,rvb10t,rvbud13
      INTO l_rvb31,l_rvv.rvv80,l_rvv.rvv81,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv86,
      l_rvv.rvv18,l_rvv.rvv89,l_rvv.rvv25,l_rvv.rvv031,l_rvv.rvv35_fac,l_rvv.rvv41,
      l_rvv.rvv930,l_rvv.rvv10,l_rvv.rvv11,l_rvv.rvv12,l_rvv.rvv13,l_rvv.rvv919,
      l_rvv.rvv22,l_rvv.rvv38,l_rvv.rvv38t,l_rvv.rvvud13 
      FROM rvb_file WHERE rvb01 = l_rvv.rvv04 AND rvb02 = l_rvv.rvv05
      
      SELECT SUM(rvv17) INTO l_rvv17 
      FROM rvu_file,rvv_file
      WHERE rvu01 = rvv01 AND rvuconf = 'N' AND rvv04 = l_rvv.rvv04 AND rvv05 = l_rvv.rvv05 AND rvu00 = '1'
      IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF 
      {IF l_rvv17 + l_rvv.rvv17 > l_rvb31 THEN 
        LET g_status.code = "-1"   #必須有單身資料
        LET g_status.description = "入库量大于可入库量!"
        EXIT FOR
      END IF }
      IF g_sma.sma115 = 'Y' THEN
      	IF NOT cl_null(l_rvv.rvv80) AND l_rvv.rvv81 <> 0 THEN 
           LET l_rvv.rvv82=l_rvv.rvv17/l_rvv.rvv81
           LET l_rvv.rvv82 = s_digqty(l_rvv.rvv82,l_rvv.rvv80)
        END IF 
        IF NOT cl_null(l_rvv.rvv83) AND l_rvv.rvv84 <> 0 THEN 
           LET l_rvv.rvv85=l_rvv.rvv17/l_rvv.rvv84
           LET l_rvv.rvv85 = s_digqty(l_rvv.rvv85,l_rvv.rvv83)
        END IF 
      END IF
      IF cl_null(l_rvv.rvv82) THEN LET l_rvv.rvv82 = l_rvv.rvv17 END IF 
      SELECT ima159,ima906 INTO l_ima159,l_ima906
      FROM ima_file WHERE ima01 = l_rvv.rvv31
      IF l_ima159 = '2' THEN LET l_rvv.rvv34 = ' ' END IF
      IF l_rvv.rvv31[1,4] = 'MISC' THEN 
        LET l_rvv.rvv32 = ' '
        LET l_rvv.rvv33 = ' '
        LET l_rvv.rvv34 = ' '
      END IF 
      IF l_ima159 = '1' AND l_rvv.rvv34 = ' ' THEN 
      	LET g_status.code = "-1"
      	LET g_status.description = "必须输入批号物料没有维护批号!"
        EXIT FOR
      END IF 

      IF NOT cl_null(l_rvv.rvv32) AND l_rvv.rvv32 <> ' ' AND l_rvv.rvv31[1,4] <> 'MISC' THEN
       SELECT count(*) INTO l_cnt  FROM img_file
         WHERE img01=l_rvv.rvv31 AND img02=l_rvv.rvv32
           AND img03=l_rvv.rvv33 AND img04=l_rvv.rvv34
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
         IF l_cnt = 0 THEN 
            IF NOT cl_null(l_rvv.rvvud13) THEN 
                CALL s_add_img(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                             l_rvv.rvv34,l_rvv.rvv01,l_rvv.rvv02,
                             l_rvv.rvvud13)
            ELSE 
                CALL s_add_img(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                             l_rvv.rvv34,l_rvv.rvv01,l_rvv.rvv02,
                             l_rvu.rvu03)
            END IF 
         END IF 

           
        SELECT img09 INTO l_img09 FROM img_file
         WHERE img01=l_rvv.rvv31 AND img02=l_rvv.rvv32
           AND img03=l_rvv.rvv33 AND img04=l_rvv.rvv34

        CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_img09)
             RETURNING l_cnt,l_rvv.rvv35_fac
        IF cl_null(l_rvv.rvv35_fac) THEN LET l_rvv.rvv35_fac = 1 END IF 

#        IF l_i = 1 THEN
#          LET g_success ='N'
#          RETURN
#        END IF

        IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
          IF NOT cl_null(l_rvv.rvv83) THEN
            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                            l_rvv.rvv83) RETURNING l_flag

            IF l_flag = 1 THEN
              CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                              l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv83,l_rvv.rvv84,
                              l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag
#              IF l_flag = 1 THEN
#                LET g_success = 'N'
#                RETURN
#              END IF
            END IF
            CALL s_du_umfchk(l_rvv.rvv31,'','','',
                             l_ima44,l_rvv.rvv83,l_ima906)
                 RETURNING g_errno,l_rvv.rvv84
#            IF NOT cl_null(g_errno) THEN
#              LET g_success = 'N'
#              RETURN
#            END IF
          END IF

          IF NOT cl_null(l_rvv.rvv80) AND l_ima906 = '2' THEN
            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                            l_rvv.rvv80) RETURNING l_flag
            IF l_flag = 1 THEN
              CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                              l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv80,l_rvv.rvv81,
                              l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag
#               IF l_flag = 1 THEN
#                 LET g_success = 'N'
#                 RETURN
#               END IF
            END IF
            CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima44)
                 RETURNING l_cnt,l_rvv.rvv81
#            IF l_i = 1 THEN
#              LET g_success = 'N'
#              RETURN
#            END IF
          END IF

          IF l_ima906 = '3' THEN
             IF l_rvv.rvv85 <> 0 THEN
                LET l_rvv.rvv84=l_rvv.rvv82/l_rvv.rvv85
             ELSE
                LET l_rvv.rvv84=0
             END IF
          END IF
        END IF
      END IF

      LET l_rvv.rvv87 = l_rvv.rvv17
      LET l_rvv.rvv40 = 'N'
      LET l_rvv.rvv88 = 0 
      SELECT pmm43,azi03,azi04,gec05,gec07 
      INTO l_pmm43,l_azi03,l_azi04,l_gec05,l_gec07
      FROM pmm_file,azi_file,gec_file
      WHERE pmm22=azi01 AND gec01 = pmm21 AND pmm01=l_rvv.rvv36
      LET l_rvv.rvv39 = l_rvv.rvv17*l_rvv.rvv38
      LET l_rvv.rvv39t = l_rvv.rvv17*l_rvv.rvv38t
      LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39, l_azi04)
      LET l_rvv.rvv39t = cl_digcut(l_rvv.rvv39t, l_azi04)
      IF l_gec07='Y' THEN
      	IF l_gec05 MATCHES '[AT]' THEN  #FUN-D10128
        	LET l_rvv.rvv38 = l_rvv.rvv38t * ( 1 - l_pmm43/100) #TQC-C30225 add
          LET l_rvv.rvv38 = cl_digcut(l_rvv.rvv10 , l_azi03)            #TQC-C30225 add
          LET l_rvv.rvv39 = l_rvv.rvv39t * ( 1 - l_pmm43/100)
          LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , l_azi04)  
    		ELSE
          LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)
          LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , l_azi04)  
    		END IF
      ELSE
    		LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + l_pmm43/100)
    		LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , l_azi04)  
      END IF
      
      LET l_rvv.rvvlegal = l_rvv.rvvplant
      IF cl_null(l_rvv.rvv10) THEN LET l_rvv.rvv10 = ' ' END IF 
      IF cl_null(l_rvv.rvv23) THEN LET l_rvv.rvv23 = 0 END IF 
      IF cl_null(l_rvv.rvv25) THEN LET l_rvv.rvv25 = 'N' END IF 
      LET l_rvv.rvv89 = 'N' 
        #add by shawn 200316 --- beign ----  增加供应商检查----- begin-----  
      SELECT pmm09 INTO l_pmm09 FROM pmm_file WHERE pmm01 = l_rvv.rvv36
      IF cl_null(l_pmm09) OR l_pmm09 <> l_rvu.rvu04 THEN 
            LET g_status.code = "-1"
            LET g_status.sqlcode = SQLCA.SQLCODE
            LET g_status.description = "单身采购单供应商",l_pmm09 CLIPPED ,"和收货单头供应商",l_rvu.rvu04 CLIPPED , "不一致，请检查！"
            EXIT FOR
      END IF 
      #---end  -----
      INSERT INTO rvv_file VALUES (l_rvv.*)
      IF SQLCA.SQLCODE THEN
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        LET g_status.description = "insert rvv_file失败！"
        EXIT FOR
     #add by shawn 210927  --- begin ---  按单号+项次 更新对应的有效日期  
      ELSE 
        UPDATE img_file SET img18 = (SELECT rvbud14 FROM rvb_file WHERE rvb01 = l_rvv.rvv04 AND rvb02 = l_rvv.rvv05 )   WHERE img05 = l_rvv.rvv01 
        AND img06 = l_rvv.rvv02 AND img01 = l_rvv.rvv31 AND img04 = l_rvv.rvv34 AND img04 IS NOT NULL AND img04 <> ' '
     #---end ---- 
      END IF
    END FOR
    IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
       EXIT FOR
    END IF
      
  END FOR

  #入库单审核 #2022022201 mark
{ IF g_status.code = '0' THEN
     INITIALIZE l_ret TO NULL
     CALL p300_rvu(l_rvu.rvu01,'1') 
  END IF}

  
  #全部處理都成功才 COMMIT WORK
  IF g_status.code = "0" THEN
    LET g_status.description = l_rvu.rvu01
    COMMIT WORK
   # CALL p300_rvu(l_rvu.rvu01,'1')     #2022022201 add
  ELSE
    ROLLBACK WORK
  END IF
    
END FUNCTION
