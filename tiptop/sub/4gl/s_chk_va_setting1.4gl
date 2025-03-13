# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_chk_va_setting1.4gl
# Descriptions...: 檢查ima908的設定和sma116是否一致
# Date & Author..: 05/04/22 By Carrier  FUN-540022
# Usage..........: CALL s_chk_va_setting1(p_item)
# Input PARAMETER: p_item   料件
# RETURN Code....: 0,ima908  ok
#                  1,ima908  no ok
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_chk_va_setting1(p_item)
 
DEFINE
    p_item     LIKE imgg_file.imgg01,
    l_ima908   LIKE ima_file.ima908,
    l_flag     LIKE type_file.chr1           #No.FUN-680147 VARCHAR(01)
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    SELECT ima908 INTO l_ima908 FROM ima_file
     WHERE ima01 = p_item
    IF SQLCA.sqlcode = 100 THEN
       IF p_item MATCHES 'MISC*' THEN
          SELECT ima908 INTO l_ima908 FROM ima_file
           WHERE ima01 = 'MISC'
          IF SQLCA.sqlcode THEN
             CALL cl_err('sel ima908',SQLCA.sqlcode,0)
          END IF
       ELSE
          CALL cl_err('sel ima908',SQLCA.sqlcode,0)
       END IF
    END IF
          
    IF (g_sma.sma116 = '0' AND l_ima908 IS NOT NULL) OR    #No.FUN-610076
       (g_sma.sma116 MATCHES '[123]' AND l_ima908 IS NULL) THEN  #No.FUN-610076
       CALL cl_err(p_item,'aim-997',0)
       RETURN 1,l_ima908
    END IF
    RETURN 0,l_ima908
 
END FUNCTION
    
