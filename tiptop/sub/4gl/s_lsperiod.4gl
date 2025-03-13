# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_lsperiod.4gl
# Descriptions...: 計算上一期間的年度和期別
# Date & Author..: 93/09/21 By  Felicity  Tseng
# Usage..........: CALL s_lsperiod(p_sma51,p_sma52) RETURNING l_sma51, l_sma52
# Input Parameter: p_sma51   本期年度              
#                  p_sma52   本期期別              
# Return code....: l_sma51,l_sma52
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_lsperiod(p_sma51,p_sma52) 
   DEFINE  p_sma51     LIKE sma_file.sma51,
           p_sma52     LIKE sma_file.sma52,
           l_sma51     LIKE sma_file.sma51,
           l_sma52     LIKE sma_file.sma52 
  
   IF p_sma52 != 1 THEN
      LET l_sma51 = p_sma51
      LET l_sma52 = p_sma52 - 1
   ELSE
      IF g_aza.aza02 =  '1' THEN          #12期
         LET l_sma51 = p_sma51 - 1
         LET l_sma52 = 12
      ELSE
         LET l_sma51 = p_sma51 - 1
         LET l_sma52 = 13                 #13期
      END IF
   END IF
   RETURN l_sma51, l_sma52
 
END FUNCTION
