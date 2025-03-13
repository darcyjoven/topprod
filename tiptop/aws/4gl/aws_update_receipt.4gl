# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_update_receipt.4gl
# Descriptions...: 更新收货单
# Date & Author..:huxya160427 By huxya
# Memo...........:
#}
DATABASE ds
 
#No.FUN-B10004
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_cnt    LIKE type_file.num5 
DEFINE l_return   RECORD 
           code       LIKE type_file.chr10,
           msg        LIKE type_file.chr100
           END RECORD
 
FUNCTION aws_update_receipt()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增订單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_update_receipt_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 

FUNCTION aws_update_receipt_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10,
           l_t        LIKE type_file.num10
    DEFINE l_sql      STRING
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode

    DEFINE g_rva01 LIKE rva_file.rva01
    DEFINE l_rvb RECORD 
			rvb01    LIKE rvb_file.rvb01,   
			rvb02    LIKE rvb_file.rvb02,   
			rvb33    LIKE rvb_file.rvb33,   
			rvb29    LIKE rvb_file.rvb29 
		END RECORD 


    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("rva_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    BEGIN WORK
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
    
    FOR l_i = 1 TO l_cnt1
        LET g_rva01 = ''
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "rva_file")        #目前處理單檔的 XML 節點
        LET g_rva01 = aws_ttsrv_getRecordField(l_node1,"rva01") CLIPPED
            
        # 處理單身資料
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "rvb_file")       #取得目前單身共有幾筆單身資料
        IF l_cnt2 = 0 THEN 
           LET g_status.code = "mfg-009" 
           LET g_status.description = "无处理资料" 
           EXIT FOR
        END IF
        
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_rvb.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1,l_j,"rvb_file")   #目前單身的 XML 節點
 
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_rvb.rvb01 = aws_ttsrv_getRecordField(l_node2, "rvb01")
            LET l_rvb.rvb02 = aws_ttsrv_getRecordField(l_node2, "rvb02")
            LET l_rvb.rvb33 = aws_ttsrv_getRecordField(l_node2, "rvb33")
            LET l_rvb.rvb29 = aws_ttsrv_getRecordField(l_node2, "rvb29")
            
            UPDATE rvb_file 
                   SET rvb33 = l_rvb.rvb33,
                          rvb29 = l_rvb.rvb29,
                          rvb40 = g_today,
                          rvb41 = 'OK'
            WHERE rvb01 = l_rvb.rvb01 AND rvb02 = l_rvb.rvb02
            
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF 
        END FOR
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
    END FOR
    
    IF g_status.code="0" THEN
		COMMIT WORK 
		LET g_status.description = "检验成功"
    ELSE 
		LET g_status.code="-1"
		#CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
		ROLLBACK WORK 
		LET g_status.description = "检验失败"
	END IF 

END FUNCTION
