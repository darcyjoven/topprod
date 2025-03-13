# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_stkchk.4gl
# Descriptions...: 檢查倉庫的使用
# Date & Author..: 91/10/04 By Lee
# Usage..........: IF NOT s_stkchk(p_stock,p_type)
# Input Parameter: p_stock  欲檢查之倉庫	 
#                  p_type   是否使用預設倉庫
# Return code....: 1   Yes
#                  0   No
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_stkchk(p_stock,p_type)
DEFINE
    p_stock LIKE imd_file.imd01,
    p_type LIKE type_file.chr1   #倉庫性質 	#No.FUN-680147 VARCHAR(01)
 
    WHENEVER ERROR CALL cl_err_msg_log
    #系統參數允許隨時增加, 不做任何檢查,
#   IF g_sma.sma41 ='3' THEN
#       RETURN 1
#   END IF
    #系統參數設定為使用預先倉庫資料
    IF p_type = 'A' THEN
        SELECT imd01
            FROM imd_file
            WHERE imd01=p_stock AND imdacti='Y'
    ELSE
        SELECT imd01
            FROM imd_file
            WHERE imd01=p_stock AND imdacti='Y' AND
                  imd10=p_type
    END IF
    IF SQLCA.sqlcode THEN
        RETURN 0
    END IF
    RETURN 1
END FUNCTION
