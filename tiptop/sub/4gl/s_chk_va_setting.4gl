# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_chk_va_setting.4gl
# Descriptions...: 檢查ima906的設定和sma115是否一致
# Date & Author..: 05/04/22 By Carrier  FUN-540022
# Usage..........: CALL s_chk_va_setting(p_item)
# Input PARAMETER: p_item           料件
# RETURN Code....: 0,ima906,ima907  ok
#                  1,ima906,ima907  no ok
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_chk_va_setting(p_item)
 
DEFINE
    p_item     LIKE imgg_file.imgg01,
    l_ima906   LIKE ima_file.ima906,
    l_ima907   LIKE ima_file.ima907,
    l_flag     LIKE type_file.chr1              #No.FUN-680147 VARCHAR(01)
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    LET l_ima906 = 1
    LET l_ima906 = NULL
    SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
     WHERE ima01 = p_item
    IF cl_null(l_ima906) OR SQLCA.sqlcode THEN
       IF SQLCA.sqlcode <> 100 THEN
          #CALL cl_err(p_item,'aim-996',0)  #FUN-670091
           CALL cl_err3("sel","ima_file",p_item,"",SQLCA.sqlcode,"",'aim-996',0) #FUN-670091
          RETURN 1,l_ima906,l_ima907
       ELSE
          IF p_item MATCHES 'MISC*' THEN
             SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
              WHERE ima01 = 'MISC'
             IF cl_null(l_ima906) OR SQLCA.sqlcode THEN
                #CALL cl_err(p_item,'aim-996',0)    #FUN-670091
                 CALL cl_err3("sel","ima_file",p_item,"",SQLCA.sqlcode,"",'aim-996',0) #FUN-670091
                RETURN 1,l_ima906,l_ima907
             END IF
          END IF
       END IF
    END IF
    IF (g_sma.sma115 = 'N' AND l_ima906 MATCHES '[23]') OR
       (g_sma.sma115 = 'Y' AND l_ima906 IS NULL) THEN
       CALL cl_err(p_item,'aim-997',0)
       RETURN 1,l_ima906,l_ima907
    END IF
    RETURN 0,l_ima906,l_ima907
 
END FUNCTION
    
