# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: cws_get_start_works.4gl
# Descriptions...: 获取开工资料
# Date & Author..: 2016/06/03 by guanyao
 
 
DATABASE ds
 
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 客戶編號列表服務(入口 function)
# Date & Author..: 2015/11/04 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]

                   
FUNCTION cws_get_start_works()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL cws_get_start_works_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 检验逻辑
# Date & Author..: 2016/06/03 by guanyao
# Parameter......: none
# Return.........: none
# Memo...........:
#
#]
FUNCTION cws_get_start_works_process()
    DEFINE l_barcode     LIKE shm_file.shm01
    DEFINE l_sql   STRING
    DEFINE l_node  om.DomNode
    DEFINE l_statuscode     LIKE type_file.chr10
    DEFINE l_msg            STRING
    DEFINE l_n        LIKE type_file.num5
    DEFINE l_return1   RECORD 
           statu      LIKE type_file.chr1,     #状况码
           shm01      LIKE shm_file.shm01,     #LOT单号
           shm012     LIKE shm_file.shm012,    #工单号
           shm05      LIKE shm_file.shm05,     #料号
           ima02      LIKE ima_file.ima02      #品名
         END RECORD 
    DEFINE l_return2   RECORD    
           statu      LIKE type_file.chr1,     #状况码
           sgm04      LIKE sgm_file.sgm04,     #工艺编号
           sgm58      LIKE sgm_file.sgm58,     #单位
           sgm03      LIKE sgm_file.sgm03,     #工艺序号
           sgm45      LIKE sgm_file.sgm45,     #工艺名称
           sgm06      LIKE sgm_file.sgm06,     #工作站编号
           eca02      LIKE eca_file.eca02      #工作站名称
         END RECORD
    DEFINE l_return3  RECORD 
           statu      LIKE type_file.chr1,        #状况码
           gen01      LIKE gen_file.gen01,        #报工人员
           gen02      LIKE gen_file.gen02         #人员名称
         END RECORD 
    DEFINE l_return4  RECORD 
           statu      LIKE type_file.chr1,     #状况码
           ecg01      LIKE ecg_file.ecg01,     #班别
           ecg02      LIKE ecg_file.ecg02      #班别班别
         END RECORD  
    LET l_statuscode = '0'                  
    LET l_msg = ''

    LET l_barcode = aws_ttsrv_getParameter("barcode")
    IF cl_null(l_barcode) THEN 
       LET g_status.code = -1
       LET g_status.description = '条码为空,请检查!'
       RETURN
    END IF 
    #LOT单号
    SELECT COUNT(*) INTO l_n FROM shm_file WHERE shm01=l_barcode 
    IF l_n=1 THEN
    	 SELECT '1',shm01,shm012,shm05,ima02 INTO l_return1.* 
           FROM shm_file LEFT JOIN ima_file ON ima01 = shm05
          WHERE shm01=l_barcode 
    	 LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return1), "Master")
    ELSE 
       #工艺编号
       SELECT COUNT(*) INTO l_n FROM sgm_file WHERE sgm04 =l_barcode
       IF l_n > 0 THEN
          SELECT DISTINCT '2',sgm04,sgm58,sgm03,sgm45,sgm06,eca02 
            INTO l_return2.*
            FROM sgm_file LEFT JOIN eca_file ON eca01 = sgm06
           WHERE sgm04=l_barcode
          LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return2), "Master")
       ELSE 
          #报工人员
          SELECT count(*) INTO l_n FROM gen_file WHERE gen01=l_barcode
          IF l_n = 1 THEN 
             SELECT '3',gen01,gen02 INTO l_return3.* FROM gen_file WHERE gen01 = l_barcode
             LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return3), "Master")
          ELSE 
             #班别
             SELECT COUNT(*) INTO l_n FROM ecg_file WHERE ecg01 = l_barcode
             IF l_n = 1 THEN 
                SELECT '4',ecg01,ecg02 INTO l_return4.* FROM ecg_file WHERE ecg01 = l_barcode
                LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return4), "Master")
             ELSE 
                LET g_status.code = -1
                LET g_status.description = '没有开工资料'
                RETURN
             END IF 
          END IF 
       END IF 
    END IF 
    	    
END FUNCTION
