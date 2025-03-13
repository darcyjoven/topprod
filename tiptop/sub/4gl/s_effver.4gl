# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_effver.4gl
# Descriptions...: 由有效日期讀取列印版本
# Date & Author..: 94/06/15 By Apple
# Usage..........: CALL s_effver(p_part,p_effdate) RETURNING l_version 
# Input Parameter: p_part      料件編號
#                  p_effdate   列印日期
# Return code....: l_version   版本 
# Modify.........: No.FUN-650139 06/06/13 By Sarah 先抓bmz03,沒找到換找bmy17
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:MOD-A40143 10/04/23 By lilingyu l_bmx06欄位長度為2,會造成後續被截位
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_effver(p_part,p_effdate)
   DEFINE p_part       LIKE ima_file.ima01,       #料件編號
          p_effdate    LIKE type_file.dat,        #No.FUN-680147 DATE
       #  l_bmx06      LIKE bmx_file.bmx06       #MOD-A40143
          l_bmx06      LIKE type_file.chr10      #MOD-A40143
 
    #start FUN-650139 modify
    #SELECT bmx06 INTO l_bmx06
    #  FROM bmx_file
    # WHERE bmx03 = p_part 
    #  #AND bmx04 != '0'
    #   AND bmx04 != 'X' #mandy 01/07/31
    #   AND bmx07 <= p_effdate
    #   AND (bmx08 > p_effdate OR bmx08 IS NULL)
    #IF SQLCA.sqlcode THEN LET l_bmx06 = ' ' END IF
     DECLARE effver_c1 CURSOR FOR
        SELECT bmz03
          FROM bmx_file,bmz_file
         WHERE bmx01 = bmz01
           AND bmz02 = p_part 
           AND bmx04 != 'X' #mandy 01/07/31
           AND bmx07 <= p_effdate
           AND (bmx08 > p_effdate OR bmx08 IS NULL)
         ORDER BY bmx07 desc,bmx01 desc
     FOREACH effver_c1 INTO l_bmx06
        IF NOT cl_null(l_bmx06) THEN EXIT FOREACH END IF
     END FOREACH
     IF cl_null(l_bmx06) THEN
        DECLARE effver_c2 CURSOR FOR
           SELECT bmy17
             FROM bmx_file,bmy_file
            WHERE bmx01 = bmy01
              AND bmy14 = p_part 
              AND bmx04 != 'X' #mandy 01/07/31
              AND bmx07 <= p_effdate
              AND (bmx08 > p_effdate OR bmx08 IS NULL)
            ORDER BY bmx07 desc,bmx01 desc
        FOREACH effver_c2 INTO l_bmx06
           IF NOT cl_null(l_bmx06) THEN EXIT FOREACH END IF
        END FOREACH
        IF cl_null(l_bmx06) THEN LET l_bmx06 = ' ' END IF
     END IF
    #end FUN-650139 modify
     RETURN l_bmx06 
END FUNCTION
