# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_hqty.4gl
# Descriptions...: 得最高存量與庫存單位
# Date & Author..: 92/05/29 By Pin
# Usage..........: CALL s_hqty(p_item,p_stock,p_locat)
#                             RETURNING l_stat,l_imf04,l_imf05
# Input Parameter: p_item    欲檢查之料件
#                  p_stock   欲檢查之倉庫	 
#                  p_locat   欲檢查之儲位
# Return code....: l_stat    1:Yes 0:No
#                  imf04     該儲位之最高限量
#                  imf05     該儲位之庫存單位
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds   #FUN-7C0053
 
FUNCTION s_hqty(p_item,p_stock,p_locat)
DEFINE
    p_item  LIKE imf_file.imf01, #料件
    p_stock LIKE imf_file.imf02, #倉庫別
    p_locat LIKE imf_file.imf03, #儲位別
    l_status LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_sn     LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_imf04 LIKE imf_file.imf04, #最高限量
    l_imf05 LIKE imf_file.imf05  #庫存單位
 
     IF p_locat IS NULL THEN LET p_locat=' ' END IF
        SELECT imf04,imf05
            INTO l_imf04,l_imf05
            FROM imf_file
            WHERE imf01=p_item AND
                  imf02=p_stock AND
                  imf03=p_locat
        LET l_status=SQLCA.sqlcode
    IF l_status THEN
        RETURN 0,'',' '
    END IF
    RETURN 1,l_imf04,l_imf05
END FUNCTION
