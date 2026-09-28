DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

DEFINE g_imm01 LIKE imm_file.imm01

FUNCTION aws_update_allot_again()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_update_allot_again_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

       
FUNCTION aws_update_allot_again_process()
    DEFINE l_sql   STRING
    DEFINE l_tlfb DYNAMIC ARRAY OF RECORD LIKE tlfb_file.*
    DEFINE ii,l_n LIKE type_file.num5
    DEFINE l_imm03 LIKE imm_file.imm03

	LET g_imm01 = aws_ttsrv_getParameter("imm01")   #取由呼叫端呼叫時給予的 SQL Condition
	
	IF cl_null(g_imm01) THEN 
		LET g_status.code = -1
       LET g_status.sqlcode = '无资料'
       RETURN
	END IF 		
   
	LET g_success = 'Y'
	BEGIN WORK 
	
	#调拨过账
	#.............................................
             LET g_prog ='aimt324'
             CALL t324sub_s(g_imm01,'','',FALSE)
             LET g_prog ='aws_ttsrv2'

             #add huxy160429--------Beg--------
             LET l_imm03 = ''
             SELECT imm03 INTO l_imm03 FROM imm_file WHERE imm01 = g_imm01 
             IF NOT cl_null(l_imm03) AND l_imm03 ='Y' THEN
             ELSE
               LET g_success = 'N'
             # LET g_status.description = "接口存在错误,请联系程序员!"
             END IF
             #add huxy160429--------End--------
             IF g_success = "Y" THEN
                UPDATE imm_file set immud06=g_user,
                                    immud14=g_today
                 WHERE imm01=g_imm01
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                # LET g_status.description = "接口存在错误,请联系程序员!"
                  LET g_status.description = "更新imm_file失败"
               END IF
             END IF
	#.............................................
	
	IF g_success = 'Y' THEN 
		LET l_sql = " SELECT * FROM tlfb_file WHERE tlfb07 = '",g_imm01,"' AND tlfb06 = -1 "
		PREPARE prep_tlfb FROM l_sql 
		DECLARE decl_tlfb CURSOR FOR prep_tlfb
		CALL l_tlfb.clear()
		
		LET ii = 1 
		FOREACH decl_tlfb INTO l_tlfb[ii].*
		
			LET ii = ii + 1
			
		END FOREACH
		CALL l_tlfb.deleteElement(ii)
		
		FOR ii = 1 TO l_tlfb.getLength()
			LET l_sql =" SELECT COUNT(*) FROM imgb_file ",
					"WHERE imgb01='",l_tlfb[ii].tlfb01,"'",
					" AND imgb04='",l_tlfb[ii].tlfb04,"'",
					" AND imgb02='",l_tlfb[ii].tlfb02,"'",
					" AND imgb03='",l_tlfb[ii].tlfb03,"'" 
			PREPARE t003_imgb_pre FROM l_sql
			EXECUTE t003_imgb_pre INTO l_n
			IF l_n = 0 THEN #没有imgb_file，新增imgb_file
				CALL s_ins_imgb(l_tlfb[ii].tlfb01,l_tlfb[ii].tlfb02,l_tlfb[ii].tlfb03,l_tlfb[ii].tlfb04,l_tlfb[ii].tlfb05,l_tlfb[ii].tlfb06,'')
                                IF g_success = 'N' THEN
                                   LET g_status.code = '9052'
                                END IF
			ELSE
				CALL s_up_imgb(l_tlfb[ii].tlfb01,l_tlfb[ii].tlfb02,l_tlfb[ii].tlfb03,l_tlfb[ii].tlfb04,l_tlfb[ii].tlfb05,l_tlfb[ii].tlfb06,'') 
                                IF g_success = 'N' THEN
                                   LET g_status.code = '9050'
                                END IF
			END IF 
		
		END FOR 
		
	END IF 	

	IF g_success = 'Y' THEN 
		LET l_sql = " SELECT * FROM tlfb_file WHERE tlfb07 = '",g_imm01,"' AND tlfb06 = 1 "
		PREPARE prep_tlfb1 FROM l_sql 
		DECLARE decl_tlfb1 CURSOR FOR prep_tlfb1
		CALL l_tlfb.clear()
		
		LET ii = 1 
		FOREACH decl_tlfb1 INTO l_tlfb[ii].*
		
			LET ii = ii + 1
			
		END FOREACH
		CALL l_tlfb.deleteElement(ii)
		
		FOR ii = 1 TO l_tlfb.getLength()
			LET l_sql =" SELECT COUNT(*) FROM imgb_file ",
					"WHERE imgb01='",l_tlfb[ii].tlfb01,"'",
					" AND imgb04='",l_tlfb[ii].tlfb04,"'",
					" AND imgb02='",l_tlfb[ii].tlfb02,"'",
					" AND imgb03='",l_tlfb[ii].tlfb03,"'" 
			PREPARE t003_imgb_pre1 FROM l_sql
			EXECUTE t003_imgb_pre1 INTO l_n
			IF l_n = 0 THEN #没有imgb_file，新增imgb_file
				CALL s_ins_imgb(l_tlfb[ii].tlfb01,l_tlfb[ii].tlfb02,l_tlfb[ii].tlfb03,l_tlfb[ii].tlfb04,l_tlfb[ii].tlfb05,l_tlfb[ii].tlfb06,'')
                                IF g_success = 'N' THEN
                                   LET g_status.code = '9052'
                                END IF
			ELSE
				CALL s_up_imgb(l_tlfb[ii].tlfb01,l_tlfb[ii].tlfb02,l_tlfb[ii].tlfb03,l_tlfb[ii].tlfb04,l_tlfb[ii].tlfb05,l_tlfb[ii].tlfb06,'') 
                                IF g_success = 'N' THEN
                                   LET g_status.code = '9050'
                                END IF
			END IF 
		
		END FOR 
		
	END IF
		
	IF g_status.code THEN 
		LET g_success = 'N'
	END IF 		
	
	IF g_success = 'Y' THEN 
		COMMIT WORK 
                LET g_status.description = "调拨成功"
	ELSE 
		ROLLBACK WORK 
		LET g_status.code = -1
                LET g_status.description = "调拨失败"
	END IF 			    

END FUNCTION
