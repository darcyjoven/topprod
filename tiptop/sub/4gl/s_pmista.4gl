# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_pmista.4gl
# Descriptions...: 狀況碼轉換為狀況說明
# Date & Author..: 90/09/26 By Nora
# Usage..........: CALL s_pmista(p_file,p_code1,p_code2,p_code3) RETURNING l_sta
# Input Parameter: p_file   單據名
#                  p_code1  狀況碼
#                  p_code2  確認碼
#                  p_code3  簽核否
# Return code....: l_sta    狀況說明
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_pmista(p_file,p_code1,p_code2,p_code3)
   DEFINE  p_file   LIKE oay_file.oayslip,        #No.FUN-680147 VARCHAR(03)
           p_code1  LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
           p_code2  LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
           p_code3  LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
           l_sta    LIKE ze_file.ze03             #No.FUN-680147 VARCHAR(12)
   LET l_sta = " "
   IF cl_null(p_code1) THEN RETURN  l_sta END IF
#  IF p_file != 'pmi' THEN
#     RETURN l_sta
#  END IF
#..當狀況碼為開立且確認碼='Y'and 簽核碼='Y' --> p_code1='S' -- 送簽中
   IF p_code1='0' AND p_code2='Y' AND p_code3='Y' AND g_aza.aza23='N'
      THEN  
      LET p_code1='S'  
   END IF 
   CASE p_code1
		WHEN '0' CALL cl_getmsg('mfg3211',g_lang) RETURNING l_sta
		WHEN '1' CALL cl_getmsg('mfg3212',g_lang) RETURNING l_sta
		WHEN 'S' CALL cl_getmsg('mfg3546',g_lang) RETURNING l_sta
                WHEN 'R' CALL cl_getmsg('mfg3548',g_lang) RETURNING l_sta
                WHEN 'W' CALL cl_getmsg('mfg3556',g_lang) RETURNING l_sta
   END CASE
   RETURN l_sta
END FUNCTION
