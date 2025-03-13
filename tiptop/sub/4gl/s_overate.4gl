# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_overate.4gl
# Descriptions...: 讀取系統參數中的(A/B/C 類的超短交限率)
# Date & Author..: 90/12/17 By Wu 
# Usage..........: CALL s_overate(p_item) RETURNING l_rate
# Input Parameter: p_item  料件編號
# Return code....: l_rate  超短交限率
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl-err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds   #FUN-7C0053
 
GLOBALS
    DEFINE
        g_chr           LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
END GLOBALS
 
FUNCTION s_overate(p_item)
DEFINE
    p_item     LIKE ima_file.ima01,
    p_rate     LIKE sma_file.sma401,
    l_ima07    LIKE ima_file.ima07,
    l_sma401   LIKE sma_file.sma401,
    l_sma402   LIKE sma_file.sma402,
    l_sma403   LIKE sma_file.sma403 
 
    WHENEVER ERROR CALL cl_err_msg_log
    SELECT ima07 INTO l_ima07 FROM ima_file 
                  WHERE ima01 = p_item
    IF SQLCA.sqlcode!=0  THEN 
       #CALL cl_err('cannot select ima_file',SQLCA.sqlcode,0)  #FUN-670091
        CALL cl_err3("sel","ima_file",p_item,"",SQLCA.sqlcode,"","",0) #FUN-670091
    END IF
    SELECT sma401,sma402,sma403 
         INTO l_sma401,l_sma402,l_sma403
         FROM sma_file 
        WHERE sma00 = '0'
    IF SQLCA.sqlcode THEN 
       #CALL cl_err('cannot select sma_file',SQLCA.sqlcode,0)       #FUN-670091 
        CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0)  #FUN-670091
    END IF
    CASE l_ima07
      WHEN 'A'  LET p_rate = l_sma401 
      WHEN 'B'  LET p_rate = l_sma402 
      WHEN 'C'  LET p_rate = l_sma403 
      OTHERWISE LET p_rate = 0    
    END CASE
    RETURN p_rate 
END FUNCTION
