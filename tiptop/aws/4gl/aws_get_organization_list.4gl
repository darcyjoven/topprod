# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_organization_list.4gl
# Descriptions...: 提供取得 ERP 營運中心代碼服務
# Date & Author..: 2007/02/12 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-860037 08/06/20 By Kevin 升級到aws_ttsrv2
# Modify.........: No.FUN-840012 08/08/01 By kim 加入可傳人員代號
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版
 
DATABASE ds
 
#FUN-720021
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 營運中心代碼服務(入口 function)
# Date & Author..: 2007/02/12 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_organization_list()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
 
    #--------------------------------------------------------------------------#
    # 查詢 ERP 營運中心代碼                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_organization_list_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 營運中心代碼
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_organization_list_process()
    DEFINE l_azp   RECORD 
                      azp01   LIKE azp_file.azp01,
                      azp02   LIKE azp_file.azp02
                   END RECORD
    DEFINE l_node  om.DomNode
    DEFINE l_sql   STRING   #FUN-840012
    DEFINE l_zxy01 LIKE zxy_file.zxy01                  #使用者代號 #FUN-840012
    
    LET l_zxy01 = aws_ttsrv_getParameter("zxy01")    #使用者代號,可空白
 
    IF cl_null(l_zxy01) THEN
       LET l_sql = "SELECT * ",
                   " FROM azp_file WHERE azp053='Y'"
    ELSE
       LET l_sql = "SELECT azp_file.* ",
                   " FROM azp_file,zxy_file ",
                   " WHERE azp01=zxy03 AND zxy01='",l_zxy01,"'"
    END IF
 
    LET l_sql=l_sql," ORDER BY azp01"
 
    DECLARE azp_cur CURSOR FROM l_sql 
     #SELECT azp01, azp02 FROM azp_file WHERE azp053 = 'Y' ORDER BY azp01 #FUN-840012
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF    
    
    FOREACH azp_cur INTO l_azp.*
        
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_azp), "azp_file")   #加入此筆單檔資料至 Response 中
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
#FUN-AA0022
