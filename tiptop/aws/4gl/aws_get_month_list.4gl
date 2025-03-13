# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_month_list.4gl
# Descriptions...: 提供取得 ERP 月份列表服務
# Date & Author..: 2007/06/25 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-760069
# Modify.........: No.FUN-860037 08/06/20 By Kevin 升級到aws_ttsrv2
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-760069
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 月份列表服務(入口 function)
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_month_list()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 月份                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_month_list_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 月份
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_month_list_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_mon   DYNAMIC ARRAY OF RECORD
                   mon01   LIKE type_file.num10        #月份碼(1~12)             
                   END RECORD
    DEFINE l_node      om.DomNode                   
    
    FOR l_i = 1  TO 12
    	  LET l_mon[l_i].mon01 = l_i
    	  LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_mon[l_i]), "tmp_file")   #加入此筆單檔資料至 Response 中
    END FOR
  	
        
END FUNCTION
