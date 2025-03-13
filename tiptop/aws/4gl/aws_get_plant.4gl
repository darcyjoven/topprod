# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_plant.4gl
# Descriptions...: 获取登录用户营运中心
# Date & Author..: 2016/4/17 16:36:26 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_defaultplant  RECORD
            defaultplant   LIKE type_file.chr50
           END RECORD
DEFINE g_plant1   RECORD 
            plant          LIKE type_file.chr50
           END RECORD
                   
FUNCTION aws_get_plant()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_plant_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 检验逻辑
# Date & Author..: 2016/4/17 16:40:06 by shenran
# Parameter......: none
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_get_plant_process()
	DEFINE l_username LIKE type_file.chr20
	DEFINE l_n        LIKE type_file.num5
  DEFINE l_node  om.DomNode

    DEFINE l_sql   STRING
    
    LET l_username = aws_ttsrv_getParameter("username")   #取由呼叫端呼叫時給予的 SQL Condition
  
    IF cl_null(l_username) THEN
    	   LET g_status.code = -1
         LET g_status.description = '用户名不能为空!'
         RETURN
    END IF

		LET l_sql =" SELECT zx08 FROM zx_file WHERE zx01 = '",l_username,"'"
		PREPARE prep_aaa FROM l_sql
		EXECUTE prep_aaa INTO g_defaultplant.defaultplant
		IF cl_null(g_defaultplant.defaultplant) THEN 
			   LET g_status.code = -1
         LET g_status.description = '用户名不存在,请重新输入!'
         RETURN
    ELSE 
    	   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_defaultplant))
		END IF
		LET l_sql= "select zxy03 from zxy_file where zxy01='",l_username,"'"
     
     PREPARE plant_ipb_iba FROM l_sql
     DECLARE t001_iba CURSOR FOR plant_ipb_iba

     FOREACH t001_iba INTO g_plant1.plant
       IF STATUS THEN
        EXIT FOREACH
       END IF
       LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(g_plant1), "Master")  #response
     END FOREACH
     IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
     END IF
    	    
END FUNCTION

	
	