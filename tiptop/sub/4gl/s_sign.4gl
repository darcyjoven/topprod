# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_sign.4gl
# Descriptions...: 自動賦予單據之簽核等級
# Date & Author..: 91/10/18 By Lee
# Usage..........: CALL s_sign(p_no,p_type,p_filed,p_file) RETURNING l_label
# Input Parameter: p_no      單號
#                  p_type    單據性質
#                  p_field   單號欄位名稱
#                  p_file    檔案名稱
# Return code....: l_label   符合條件之等級
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_sign(p_no,p_type,p_field,p_file)
DEFINE
    p_no LIKE oea_file.oea01,                #No.FUN-680147 VARCHAR(20)   #單號
    p_type LIKE type_file.num5,              #No.FUN-680147 SMALLINT #單據性質
    p_field LIKE zta_file.zta02,             #No.FUN-680147 VARCHAR(10) #單號欄位名稱
    p_file LIKE zta_file.zta01,              #No.FUN-680147 VARCHAR(10) #檔案名稱
    l_sql LIKE type_file.chr1000,#組sql用的string  #No.FUN-680147 VARCHAR(1000)
    l_label LIKE aze_file.aze01, #符合條件之等級
    l_aze10 LIKE aze_file.aze10, #條件之一
    l_aze11 LIKE aze_file.aze11  #條件之二
 
    DECLARE sign_cur CURSOR FOR
        SELECT aze01,aze10,aze11
        FROM aze_file
        WHERE aze09=p_type AND  azeacti IN ('Y','y')
		order by 2 desc
 
    LET l_label=''
 
    FOREACH sign_cur INTO l_label,l_aze10,l_aze11
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        IF (l_aze10 IS NULL OR l_aze10=' ') AND (l_aze11 IS NULL 
            OR l_aze11=' ')    THEN
           LET l_aze10 = '1=1'
        END IF
        IF cl_null(l_aze11) THEN LET l_aze11 = ' ' END IF 
        LET l_sql="SELECT ",p_field CLIPPED," FROM ",p_file CLIPPED, 
                  " WHERE ",p_field CLIPPED,"='",p_no,"' AND ",
                  l_aze10 CLIPPED," ",l_aze11 CLIPPED
        PREPARE sign_p1 FROM l_sql
        DECLARE sign_p CURSOR FOR sign_p1       
        IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
        OPEN sign_p
        FETCH sign_p INTO l_aze10
        IF SQLCA.sqlcode THEN
            CONTINUE FOREACH
        END IF
        EXIT FOREACH
    END FOREACH
 
    RETURN l_label
END FUNCTION
