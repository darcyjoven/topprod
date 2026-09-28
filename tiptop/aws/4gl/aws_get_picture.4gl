# Program name...: aws_get_picture.4gl                                                    
# Description....: 获取图片信息                                              
# Date & Author..: 2016/03/18 by yanglan  

DATABASE ds                     
    
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   

# Description....:  获取ERP图片信息服务入口程序
# Date & Author..: 2016/03/18 by yanglan
# Parameter......: none
# Return.........: none
# Memo...........:

FUNCTION aws_get_picture()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess() 
    
 
    IF g_status.code = "0" THEN
       CALL aws_get_picture_process()
    END IF
 
    CALL aws_ttsrv_postprocess()  
END FUNCTION
	
# Description....: 获取图片信息
# Date & Author..: 2016/03/18 by yanglan
# Parameter......: none
# Return.........: none
# Memo...........:

FUNCTION aws_get_picture_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_tc_image RECORD 
                      	tc_image02   LIKE tc_image_file.tc_image02
                   		END RECORD
    DEFINE l_node  om.DomNode
		DEFINE l_http RECORD 
										http VARCHAR(4000)  
									END RECORD  
   #FUN-B90089 add str---
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_sql   STRING
		DEFINE l_num INTEGER
		DEFINE l_str STRING
		DEFINE l_tc_image01 LIKE tc_image_file.tc_image01
		
    LET l_tc_image01 = aws_ttsrv_getParameter("ima01")   #SQL Condition
    
    IF cl_null(l_tc_image01) THEN 
    	LET l_str = "料件编号不能为空 !"
    	LET g_status.description=l_str
    	RETURN
    END IF
     
    SELECT COUNT(*) INTO l_num FROM ima_file
    WHERE ima01 = l_tc_image01
 
    IF l_num=0 OR l_num>1 THEN
    	LET g_status.code = -1
      LET g_status.description="该料件编号不存在 !"
      RETURN
    END IF
    IF NOT cl_null(l_tc_image01) THEN 
      LET l_sql =  " SELECT ROWNUM,tc_image02",
                   " FROM ima_file,tc_image_file ",
                   " WHERE ima01=tc_image01",
                   " AND ima01='",l_tc_image01,"'"
		END IF
		
		PREPARE tc_image_pr FROM l_sql	
    DECLARE tc_image_cur CURSOR FOR tc_image_pr
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = -1
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET g_status.description="发生语法错误 !"
       RETURN
    END IF
    
    FOREACH tc_image_cur INTO l_rownum,l_tc_image.*
     	#暂时mark 改为外网地址 2016/4/18 22:14:14 shenran str
     	#LET l_http.http=FGL_GETENV("FGLASIP")||"pic/",l_tc_image.tc_image02
    	#LET l_http.http=cl_replace_str(l_http.http,"topprod","")
      LET l_http.http ="http://180.167.0.43:8009/pic/",l_tc_image.tc_image02
      #暂时mark 改为外网地址 2016/4/18 22:14:14 shenran end
    	LET l_node= aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_http), "Master")   #Response
    END FOREACH  

END FUNCTION