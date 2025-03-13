# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_chk_apprl.4gl
# Descriptions...: 收貨和品管是否要檢查承認文號
# Date & Author..: 03/03/04 By Carol
# Usage..........: CALL s_chk_apprl(p_bmj01,p_bmj03,p_pmm01) RETURN 0/1/2
# Input PARAMETER: p_no   收貨單號
#                  (料件   ,供應商 ,採購單號)
# Modify.........: No.MOD-570232 05/07/19 By Yiting 承認文號檢查 應撿查 文號及承認狀態
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-930109 09/04/07 By xiaofeizhu 檢查時需增加按照料件的設定來判斷是否做AVL串聯
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_chk_apprl(p_bmj01,p_bmj03,p_pmm01)
DEFINE
    p_bmj01    LIKE bmj_file.bmj01,#料件
    p_bmj03    LIKE bmj_file.bmj03,#供應商 
    p_pmm01    LIKE pmm_file.pmm01,#採購單號
    l_sql      LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(500)
    l_code     LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    l_success  LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    l_msg      LIKE zaa_file.zaa01,          #No.FUN-680147 VARCHAR(12)
    l_cnt      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    l_pmm02    LIKE pmm_file.pmm02,
    l_ima08    LIKE ima_file.ima08,
    l_ima926   LIKE ima_file.ima926          #No.FUN-930109 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF g_sma.sma102 = 'N' THEN RETURN 0,'' END IF  #參數設定不做管制返回
    IF g_sma.sma103 = '0' THEN RETURN 0,'' END IF  #參數設定不做管制返回
    SELECT ima926 INTO l_ima926 FROM ima_file      #FUN-930109
     WHERE ima01 = p_bmj01                         #FUN-930109
    IF l_ima926 !='Y' THEN RETURN 0,'' END IF       #料件參數設定AVL否為‘N'不做管制返回 FUN-930109
    #No:7631
    #要卡承認文認號的範圍:
    #1.採購單據性質為'REG','TRI','TAP'
    #2.料件來源碼為  'P','M','V'
    #3.要驗的料件
    SELECT pmm02 INTO l_pmm02 
      FROM pmm_file
     WHERE pmm01 = p_pmm01
    IF cl_null(l_pmm02) OR NOT ( l_pmm02='REG' OR l_pmm02='TRI' OR l_pmm02='TAP' ) THEN #No:7631
       RETURN 0,''
    END IF
    SELECT ima08 INTO l_ima08 FROM ima_file
     WHERE ima01 = p_bmj01 #No:7631
    IF l_ima08 NOT MATCHES '[PMV]' OR cl_null(l_ima08) THEN #No:7631
       RETURN 0,''
    END IF
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt 
      FROM bmj_file
     WHERE bmj01 = p_bmj01
       AND bmj03 = p_bmj03
       AND ( bmj10 IS NOT NULL AND bmj10 !=' ' )
        AND bmj08 = '3'  #NO.MOD-570232
    IF l_cnt >=1 THEN
       LET l_success = 'Y' 
    END IF 
    IF l_success = 'Y' THEN 
       RETURN 0,''
    ELSE
       CASE g_sma.sma103 
            WHEN '1'    
                 LET l_code=1
                 LET l_msg='apm-450'
            WHEN '2' 
                 LET l_code=2
                 LET l_msg='apm-451'
       END CASE
       RETURN l_code,l_msg
    END IF
END FUNCTION
