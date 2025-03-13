# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_area_list.4gl
# Descriptions...: 提供取得 ERP 區域代碼服務
# Date & Author..: 2007/02/14 by Echo
# Memo...........:
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-860037 08/06/20 By Kevin 升級到aws_ttsrv2
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 區域代碼服務(入口 function)
# Date & Author..: 2007/02/12 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_area_list()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 區域別編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_area_list_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 區域代碼
# Date & Author..: 2007/02/06 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_area_list_process()
    DEFINE l_i     LIKE type_file.num10,
           l_gea   RECORD 
                      gea01   LIKE gea_file.gea01,
                      gea02   LIKE gea_file.gea02
                   END RECORD
    DEFINE l_node  om.DomNode                   
    DEFINE l_gea2  DYNAMIC ARRAY OF RECORD
                      gea01   LIKE gea_file.gea01,
                      gea02   LIKE gea_file.gea02          
                   END RECORD                   
 
    
    DECLARE gea_cur CURSOR FOR SELECT gea01, gea02 FROM gea_file WHERE geaacti = 'Y'  ORDER BY gea01 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    LET l_i = 1
    FOREACH gea_cur INTO l_gea.*
        LET l_gea2[l_i].gea01 = l_gea.gea01 CLIPPED
        LET l_gea2[l_i].gea02 = l_gea.gea02 CLIPPED
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_gea2[l_i]), "gea_file")   #加入此筆單檔資料至 Response 中
        LET l_i = l_i + 1
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
