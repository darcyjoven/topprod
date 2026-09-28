DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_appver()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_appver_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

       
FUNCTION aws_get_appver_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_tc_ver  RECORD 
			tc_ver01 LIKE tc_ver_file.tc_ver01 ,       # IP,
			tc_ver02 LIKE tc_ver_file.tc_ver02       # 版本号
                   END RECORD
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_rownum LIKE type_file.num10
    DEFINE l_wc    STRING
    DEFINE l_str   STRING
    DEFINE l_end   STRING
    DEFINE l_sql   STRING
    DEFINE l_n,l_nn     LIKE type_file.num10 


   LET l_nn = 0
   SELECT count(*) INTO l_nn FROM tc_ver_file WHERE tc_ver00 = '0' 
   IF l_nn <> 1 THEN
      LET g_status.code = '-1'
      LET g_status.description = '检测更新失败'
      RETURN
   END IF

   LET l_sql = "select tc_ver01, tc_ver02",         
               " from tc_ver_file ",
               " where tc_ver00 = '0' "
  
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
     FOREACH occ_cur INTO l_tc_ver.*

         LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_tc_ver), "Master")   #加入此筆單檔資料至 Response 中
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
