# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_imfchk1.4gl
# Descriptions...: 使用於在收料時檢查該料是否可收至該倉(依參數來決定)
# Date & Author..: 92/10/14 By Pin
# Usage..........: IF s_imfchk1(p_item,p_stock)
# Input Parameter: p_item    欲檢查之料件
#                  p_stock   欲檢查之倉庫	 
# Return code....: 1  Yes
#                  0  No
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_imfchk1(p_item,p_stock)
DEFINE
    p_item   LIKE imf_file.imf01, #料件
    p_stock  LIKE imf_file.imf02, #倉庫別
    l_status LIKE imf_file.imf06,       #No.FUN-680147
    l_sn     LIKE imf_file.imf06        #No.FUN-680147
 
#-------------------------------------------------#
#*****表該料件可存放任何倉庫中********************#
#-------------------------------------------------#
 
    IF g_sma.sma42 ='3' OR g_sma.sma42 IS NULL THEN 
        RETURN 1
    END IF
 
#-------------------------------------------------#
#*****表該料設定存放在某個倉庫********************#
#-------------------------------------------------#
    IF g_sma.sma42 MATCHES '[12]' THEN 
            SELECT count(*)
                INTO l_sn
                FROM imf_file
                WHERE imf01=p_item AND
                      imf02=p_stock
             IF l_sn=0 THEN 
                LET l_status=100 RETURN 0 ELSE 
                LET l_status=SQLCA.sqlcode 
             END IF
    END IF
 
    IF l_status THEN
        RETURN 0
    END IF
 
    RETURN 1
END FUNCTION
