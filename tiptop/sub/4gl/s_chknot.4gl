# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chknot.4gl
# Descriptions...: 檢查支票號碼 
# Date & Author..: 
# Usage..........: CALL s_chknot(p_part)
# Input Parameter: p_bank       銀行編號
#                  p_notno      支票號碼
#                  p_bookno     支票簿號
# Return code....: g_errno      錯誤訊息
# Modify.........: 00/05/22 By Kammy (加傳簿號)
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_chknot(p_bank,p_notno,p_bookno)
  DEFINE p_bank	     LIKE nma_file.nma01        #No.FUN-680147 VARCHAR(6) # 銀行編號
  DEFINE p_notno     LIKE nma_file.nma12        #No.FUN-680147 VARCHAR(10) # 支票編號
  DEFINE p_bookno    LIKE type_file.num5        #No.FUN-680147 SMALLINT # 支票簿號
  DEFINE l_sql       LIKE type_file.chr1000,    #No.FUN-680147 VARCHAR(1000)
         l_len       LIKE type_file.num5,       #No.FUN-680147 SMALLINT
         l_point     LIKE type_file.num5,       #No.FUN-680147 SMALLINT
         l_no1,l_no2 LIKE nma_file.nma12,       #No.FUN-680147 VARCHAR(10) 
         l_nna04     LIKE nna_file.nna04,
         l_nna05     LIKE nna_file.nna05,
         l_nmw04     LIKE nmw_file.nmw04,
         l_nmw05     LIKE nmw_file.nmw05
 
    LET g_errno = ' '
    #-->票號位數正確否
     SELECT nna04,nna05 INTO l_nna04,l_nna05
       FROM nna_file 
      WHERE nna01 = p_bank
        AND nna02 = p_bookno 
        AND nna021=(SELECT MAX(nna021) FROM nna_file
                     WHERE nna01 = p_bank AND
                           nna02 = p_bookno)
     IF SQLCA.sqlcode THEN LET l_nna04 = 0 LET l_nna05 = 0 END IF 
     IF l_nna04 IS NOT NULL AND l_nna04 > 0 AND	l_nna04 < 10 THEN 
          LET l_len = LENGTH(p_notno) 
          IF l_len != l_nna04 
          THEN LET g_errno = 'anm-135'
               RETURN 
          END IF
     END IF
    #-->號碼檢查
    LET g_errno = 'anm-134' 
    DECLARE t100_book_cur CURSOR FOR
            SELECT nmw04,nmw05 FROM nmw_file
             WHERE nmw01 = p_bank
               AND nmw06 = p_bookno
    FOREACH t100_book_cur INTO l_nmw04,l_nmw05
        IF SQLCA.sqlcode THEN 
           CALL cl_err('t100_book_cur',SQLCA.sqlcode,0)
           EXIT FOREACH 
        END IF
        IF p_notno < l_nmw04 OR p_notno >l_nmw05
        THEN LET g_errno = 'anm-134'
        ELSE LET g_errno = '' 
             #-->票號前幾碼檢查 
              IF l_nna05 < l_nna04 
              THEN LET l_point = l_nna04 - l_nna05
                   LET l_no1   = p_notno[1,l_point] clipped
                   LET l_no2   = l_nmw04[1,l_point] clipped
                   IF l_no1 != l_no2 THEN 
                      LET g_errno = 'anm-138'
                      CONTINUE FOREACH 
                   ELSE EXIT FOREACH
                   END IF 
              ELSE EXIT FOREACH 
              END IF 
        END IF
    END FOREACH 
END FUNCTION
