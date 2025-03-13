# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_check_aps_execution.4gl
# Descriptions...: 檢查apsp702 是否該重新啟動
# Date & Author..: 2009/01/12 by Kevin
# Memo...........:
# Modify.........: 新建立 #TQC-910021
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50050 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B50050 11/05/06 By Mandy---GP5.25 追版:以下為GP5.25的單號---str---
# Modify.........: No:FUN-960076 09/06/09 By Joe TQC-950064 增加廠別顯示功能程式錯誤修正
# Modify.........: No:TQC-990068 09/09/18 By Mandy 不需再run apsp702
# Modify.........: No.FUN-B50050 11/05/06 By Mandy---GP5.25 追版----------------------end---
 
DATABASE ds
 
#TQC-910021
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
#[
# Description....: 檢查apsp702 是否該重新啟動(入口 function)
# Date & Author..: 2009/01/14 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_check_aps_execution()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    IF g_status.code = "0" THEN
       CALL aws_check_aps_execution_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 檢查apsp702 是否該重新啟動
# Date & Author..: 2009/01/14 by Kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_check_aps_execution_process()    
    DEFINE l_msg    STRING        
    DEFINE l_cnt    INT,
           l_vzv01  LIKE vzv_file.vzv01,  
           l_vzv02  LIKE vzv_file.vzv02,
           l_user   STRING
        
    LET l_vzv01 = aws_ttsrv_getParameter("vzv01") 
    LET l_vzv02 = aws_ttsrv_getParameter("vzv02") 
 
    SELECT COUNT(*) INTO l_cnt FROM vlh_file
    IF l_cnt > 0 THEN
       LET g_status.code = "0"
       LET g_status.description = "Program has been running!(vlh_file has data)"
       RETURN
    END IF 
    
    SELECT COUNT(*) INTO l_cnt FROM vzv_file
     WHERE vzv00=g_plant      
       AND vzv07 ='N'
       AND vzv04>='40'
     
    IF l_cnt = 0 THEN
       LET g_status.code = "0"
       LET g_status.description = "Not found data to be processed!"
       RETURN
    ELSE
       #FUN-960076 呼叫apsp702時,參數增加廠別
       #LET l_msg = " apsp702 'Y' '",l_vzv01 CLIPPED,"' '",l_vzv02 CLIPPED,"'"
       LET l_msg = " apsp702 '",g_plant CLIPPED,"' 'Y' '",l_vzv01 CLIPPED,"' '",l_vzv02 CLIPPED,"'"  
      #CALL cl_cmdrun(l_msg CLIPPED)                    #TQC-990068 mark
       LET g_status.code = "0"
      #LET g_status.description = "Start job apsp702 !" #TQC-990068 mark
    END IF 
   
END FUNCTION
#FUN-B50050
 
