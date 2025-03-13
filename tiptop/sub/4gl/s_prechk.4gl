# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_prechk.4gl
# Descriptions...: 檢查料件儲位的使用
# Date & Author..: 91/10/04 By Lee
# Usage..........: CALL s_prechk(p_item,p_stock,p_locat) RETURNING l_stat,l_imf04
# Input Parameter: p_stock   欲檢查之倉庫	 
#                  p_preat   欲檢查之儲位
#                  p_item    欲檢查之料件
# Return code....: l_stat    結果碼 1:Yes 0:No
#                  l_imf04   該儲位之最高限量
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_prechk(p_item,p_stock,p_locat)
DEFINE
    p_item  LIKE imf_file.imf01, #料件
    p_stock LIKE imf_file.imf02, #倉庫別
    p_locat LIKE imf_file.imf03, #儲位別
    l_status LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    l_imf04 LIKE imf_file.imf04  #最高限量
 
    #系統參數允許隨時增加, 不做任何檢查,
    #或使用預設之儲位時, 在儲位檢查
    IF g_sma.sma42 ='3' THEN
        RETURN 1,''
    END IF
#系統參數設定為使用預先倉庫資料
    IF g_sma.sma42='1' THEN
#檢查料件/倉庫
        IF p_locat IS NULL THEN
            SELECT imf04
                INTO l_imf04
                FROM imf_file
                WHERE imf01=p_item AND
                      imf02=p_stock
            LET l_status=SQLCA.sqlcode
        END IF
    ELSE
#檢查料件/倉庫/儲位
        SELECT imf04
            INTO l_imf04
            FROM imf_file
            WHERE imf01=p_item AND
                  imf02=p_stock AND
                  imf03=p_locat
        LET l_status=SQLCA.sqlcode
    END IF
    IF l_status THEN
        RETURN 0,''
    END IF
    RETURN 1,l_imf04
END FUNCTION
