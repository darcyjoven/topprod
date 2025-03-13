# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: s_chkidn.4gl
# Descriptions...: 國民身分證統一編號檢查
# Date & Author..: 96/01/24 By Lynn
# Usage..........: IF NOT s_chkidn(p_idn)
# Input PARAMETER: p_idn  國民身分證統一編號
# RETURN Code....:   0  FALSE
#                    1  TRUE
# Memo...........: if not s_chkidn(idn_code) then error 'Wrong idn_code'
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-990128 09/09/14 By mike 在第36行的re后面加上CLIPPED.    
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_chkidn(p_idn_code)
  DEFINE p_idn_code		LIKE cre_file.cre08          #No.FUN-680147 VARCHAR(10)
  DEFINE letter    		LIKE type_file.chr50         #No.FUN-680147 VARCHAR(26)
  DEFINE i,j,weight,mo 		LIKE type_file.num5          #No.FUN-680147 SMALLINT
  DEFINE re        		LIKE aba_file.aba18          #No.FUN-680147 VARCHAR(2)
  DEFINE re_idn    		LIKE gse_file.gse07          #No.FUN-680147 VARCHAR(11)
 
  WHENEVER ERROR CALL cl_err_msg_log
  LET letter = 'ABCDEFGHJKLMNPQRSTUVXYWZIO'
  FOR i = 1 TO 10 
     IF cl_null(p_idn_code[i,i]) THEN RETURN FALSE END IF
  END FOR
  FOR i = 1 TO 26
    IF letter[i,i] = p_idn_code[1,1] THEN
	LET j = 9 + i
	LET re = j USING '&&'
    END IF
  END FOR
  LET re_idn = re CLIPPED, p_idn_code[2,10] #MOD-990128 ADD clipped     
  LET weight = re_idn[1,1] + 9 * re_idn[2,2] + 8 * re_idn[3,3] + 7 * re_idn[4,4]
               + 6 * re_idn[5,5] + 5 * re_idn[6,6] + 4 * re_idn[7,7]
               + 3 * re_idn[8,8] + 2 * re_idn[9,9] + re_idn[10,10]+re_idn[11,11]
  LET mo = weight MOD 10
  IF mo = 0 THEN RETURN TRUE ELSE RETURN FALSE END IF
END FUNCTION
