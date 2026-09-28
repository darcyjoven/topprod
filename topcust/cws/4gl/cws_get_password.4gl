# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: cws_get_start_works.4gl
# Descriptions...: 获取开工资料
# Date & Author..: 2016/07/18 by guanyao
 
 
DATABASE ds
 
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 客戶編號列表服務(入口 function)
# Date & Author..: 2016/07/18 by guanyao
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]

                   
FUNCTION cws_get_password()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL cws_get_password_process()
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
FUNCTION cws_get_password_process()
    DEFINE l_azaud07     LIKE aza_file.azaud07
    DEFINE l_azaud07_1   LIKE aza_file.azaud07
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
    LET l_statuscode = '0'                  
    LET l_msg = ''

    LET l_azaud07 = aws_ttsrv_getParameter("azaud07")
    IF cl_null(l_azaud07) THEN 
       LET g_status.code = -1
       LET g_status.description = '密码为空,请检查!'
       RETURN
    END IF 
    LET l_azaud07_1 = ''
    SELECT azaud07 INTO l_azaud07_1 FROM aza_file     
    IF l_azaud07_1<>l_azaud07 OR l_azaud07_1 IS NULL THEN 
       LET g_status.code = -1
       LET g_status.description = '密码不正确'
       RETURN
    END IF 
    	    
END FUNCTION
