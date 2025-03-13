# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_gdays.4gl
# Descriptions...: 計算簽核時所剩餘天數                
# Date & Author..: 92/09/22 By Pin    
# Usage..........: LET l_days=s_gdays(p_date)
# Input Parameter: p_date  單据日期+簽核完成天數
# Return code....: l_days  剩餘天數            
# Modify.........: FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_gdays(l_date)
   DEFINE  l_days     LIKE type_file.num5,         #No.FUN-680147 SMALLINT
           l_date     LIKE type_file.dat           #No.FUN-680147 DATE
        
 
   WHENEVER ERROR CALL cl_err_msg_log
 
    IF l_date IS NULL THEN RETURN 0 END IF
    LET l_days=l_date-g_sma.sma30
    RETURN l_days
  
END FUNCTION
