# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_gactpd.4gl
# Descriptions...: 讀取會計期間 
# Date & Author..: 91/12/24 By Wu 
# Usage..........: CALL s_gactpd(p_date)
#                       RETURNING l_flag,l_azn02,l_azn03,l_azn04,l_azn05
# Input Parameter: p_date   欲讀取日期
# Return code....: l_flag   是否成功(0/1)
#                  l_azn02  年度
#                  l_azn03  季別
#                  l_azn04  期別
#                  l_azn05  週別
# MODIFY.........: 91/12/24 BY MAY
# Modify.........: NO.FUN-670091 06/08/02 By rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_gactpd(p_date)
DEFINE
    p_date     LIKE type_file.dat,          #No.FUN-680147 DATE
    l_flag     LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
    l_azn02    LIKE azn_file.azn02,
    l_azn03    LIKE azn_file.azn03,
    l_azn04    LIKE azn_file.azn04,
    l_azn05    LIKE azn_file.azn05
 
    SELECT azn02,azn03,azn04,azn05 INTO l_azn02,l_azn03,l_azn04,l_azn05 
         FROM azn_file WHERE azn01 = p_date
    IF SQLCA.sqlcode THEN 
       LET l_azn02  = NULL
       LET l_azn03  = NULL
       LET l_azn04  = NULL
       LET l_azn05  = NULL
       LET  l_flag = '1'
       #CALL cl_err(p_date,'mfg0027',1)  #FUN-670091
        CALL cl_err3("sel","azn_file",p_date,"",SQLCA.sqlcode,"","",0) #FUN-670091
    ELSE LET l_flag = '0'
    END IF 
    RETURN l_flag,l_azn02,l_azn03,l_azn04,l_azn05
END FUNCTION
