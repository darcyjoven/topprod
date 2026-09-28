#{
# Program name...: aws_create_arts.4gl
# Descriptions...: 提供产生报工数据接口
# Date & Author..: 2016-04-13 8:47:57 shenran


DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl" 

FUNCTION aws_create_arts()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()                                                        
    
    IF g_status.code = "0" THEN
       CALL aws_create_arts_process()     #提供取得条码库存档资料的入口程序          
    END IF 
    CALL aws_ttsrv_postprocess()        
END FUNCTION
	

FUNCTION aws_create_arts_process()
    DEFINE l_i   LIKE type_file.num10
    DEFINE l_tc_workt RECORD LIKE tc_workt_file.*
    DEFINE l_num INTEGER 
    DEFINE l_node   om.DomNode
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_ima01  LIKE ima_file.ima01
    DEFINE l_ima94  LIKE ima_file.ima94               
    DEFINE l_str   STRING
    DEFINE l_sql   STRING
    DEFINE l_cnt      LIKE type_file.num10,
           l_n        LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10,
           l_cnt3     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode,
           l_node3    om.DomNode
    

     LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       LET g_success='N'
       RETURN
    END IF

    #
    BEGIN WORK 
    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
        
        LET l_tc_workt.tc_workt11 = aws_ttsrv_getRecordField(l_node1,"sfa01") #工单号
        LET l_tc_workt.tc_workt04 = aws_ttsrv_getRecordField(l_node1,"ecb06") #作业编号
        LET l_tc_workt.tc_workt05 = aws_ttsrv_getRecordField(l_node1,"gen01") #员工编号
        LET l_tc_workt.tc_workt06 = aws_ttsrv_getRecordField(l_node1,"tc_workt06") #良品数
        LET l_tc_workt.tc_workt12 = aws_ttsrv_getRecordField(l_node1,"tc_workt12") #不良品数
        LET l_tc_workt.tc_workt10 = aws_ttsrv_getRecordField(l_node1,"tc_workt10") #报工时数
        LET l_tc_workt.tc_workt03 = aws_ttsrv_getRecordField(l_node1,"ima571") #料件
        LET l_tc_workt.tc_workt01 = g_today
        LET l_tc_workt.tc_workt02 = TIME
        LET l_tc_workt.tc_workt07 = 'N'
        LET l_tc_workt.tc_workt08 = 'N'
        
        SELECT ima94 INTO l_ima94 FROM ima_file WHERE ima01=l_tc_workt.tc_workt03
          IF cl_null(l_ima94) THEN
          	 LET g_status.code=-1
             LET g_status.description="料件对应工艺编号为空,请检查!"
             ROLLBACK WORK
             RETURN
          END IF
       	 SELECT COUNT(*) INTO l_n FROM ecb_file,ecu_file WHERE ecb01=ecu01 AND ecb02=ecu02
       	 AND ecb06=l_tc_workt.tc_workt04 AND ecb01=l_tc_workt.tc_workt03 
       	 AND ecb02=l_ima94 AND ecu10='Y'
       	 IF l_n>0 THEN
            INSERT INTO tc_workt_file VALUES (l_tc_workt.*)
            IF STATUS THEN
               LET g_status.code = -1
               LET g_status.sqlcode = SQLCA.SQLCODE
               LET g_status.description="产生tc_workt_file有错误!"
               LET g_success='N'
               ROLLBACK WORK
               RETURN
            END IF
         ELSE 
         	  LET g_status.code=-1
            LET g_status.description="料件对应工艺资料有误,请至aeci100检查!"
            LET g_success='N'
            ROLLBACK WORK
            RETURN
         END IF
        
    END FOR
    IF g_success='Y' THEN
    	 COMMIT WORK
    ELSE 
    	 ROLLBACK WORK 
    END IF
END FUNCTION