# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_organization_list.4gl
# Descriptions...: 提供取得 ERP 營運中心代碼服務
# Date & Author..: 2007/02/12 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-840004 08/06/17 By Echo 新架構的 Services 與舊架構必須進行區別，
#                                                 因此需調整舊 Services 的程式名稱
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021 #FUN-840004
 
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
FUNCTION aws_getOrganizationList_g()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
    
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getOrganizationList_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 營運中心代碼                                                    #
    #--------------------------------------------------------------------------#
    CALL g_getOrganizationList_out.azp.clear()   #清空回覆參數的 ARRAY
    IF g_status.code = "0" THEN
       CALL aws_getOrganizationList_get()
    END IF
    
    LET g_getOrganizationList_out.status = aws_ttsrv_getStatus()
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
FUNCTION aws_getOrganizationList_get()
    DEFINE l_i     LIKE type_file.num10,
           l_azp   RECORD 
                      azp01   LIKE azp_file.azp01,
                      azp02   LIKE azp_file.azp02
                   END RECORD
 
    
    DECLARE azp_cur CURSOR FOR 
      SELECT azp01, azp02 FROM azp_file WHERE azp053 = 'Y' ORDER BY azp01
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    LET l_i = 1
    FOREACH azp_cur INTO l_azp.*
        LET g_getOrganizationList_out.azp[l_i].azp01 = l_azp.azp01 CLIPPED
        LET g_getOrganizationList_out.azp[l_i].azp02 = l_azp.azp02 CLIPPED
        LET l_i = l_i + 1
    END FOREACH
END FUNCTION
