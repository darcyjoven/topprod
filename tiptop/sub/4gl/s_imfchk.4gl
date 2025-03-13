# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_imfchk.4gl
# Descriptions...: 檢查料件儲位的使用
# Date & Author..: 92/05/29 By Pin
# Usage..........: IF s_imfchk(p_item,p_stock,p_locat)
# Input Parameter: p_stock   欲檢查之倉庫	 
#                  p_preat   欲檢查之儲位
#                  p_item    欲檢查之料件
# Return code....: 1  Yes
#                  0  No
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_imfchk(p_item,p_stock,p_locat)
DEFINE
    p_item    LIKE imf_file.imf01, #料件
    p_stock   LIKE imf_file.imf02, #倉庫別
    p_locat   LIKE imf_file.imf03, #儲位別
    l_status  LIKE imf_file.imf06,       #No.FUN-680147 SMALLINT
    l_sn      LIKE imf_file.imf06,       #No.FUN-680147 SMALLINT
    l_imf04   LIKE imf_file.imf04, #最高限量
    l_imf05   LIKE imf_file.imf05  #庫存單位
 
#-------------------------------------------------#
#*****表該料件可存放任何倉庫/儲位*****************#
#-------------------------------------------------#
 
    IF p_locat IS NULL THEN LET p_locat=' ' END IF
    IF g_sma.sma42 ='3' OR g_sma.sma42 IS NULL 
       THEN RETURN 1
    END IF
 
#-------------------------------------------------#
#*****表該料設定存放在某個倉庫********************#
#-------------------------------------------------#
    IF g_sma.sma42='1' THEN 
            SELECT count(*)
                INTO l_sn
                FROM imf_file
                WHERE imf01=p_item AND
                      imf02=p_stock
             IF l_sn=0 THEN 
                LET l_status=100 RETURN 0 ELSE 
                LET l_status=SQLCA.sqlcode 
             END IF
    ELSE
#-------------------------------------------------#
#*****表該料設定存放在某個倉庫/儲位中*************#
#-------------------------------------------------#
        SELECT imf04,imf05
            INTO l_imf04,l_imf05
            FROM imf_file
            WHERE imf01=p_item AND
                  imf02=p_stock AND
                  imf03=p_locat
        LET l_status=SQLCA.sqlcode
    END IF
    IF l_status THEN
        RETURN 0
    END IF
 
    RETURN 1
END FUNCTION
