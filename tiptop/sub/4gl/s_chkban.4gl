# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_chkban.4gl
# Descriptions...: 營利事業統一編號檢查
# Date & Author..: 93/05/25 By Roger
# Uasge .........: if not s_chkban(ban_code) then error 'Wrong ban_code'
#                  IF NOT s_chkban(p_ban)
# Input PARAMETER: p_ban  營利事業統一編號
# RETURN.........: 0  FALSE
#                  1  TRUE
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-990064 09/09/16 By wujie 大陸版不做檢查
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: no:MOD-C30016 12/03/06 By Polly 增加檢查統編長度若不為8位數，則提示aoo-080錯誤訊息
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_chkban(p_ban_code)
  DEFINE p_ban_code		LIKE type_file.chr10       #LIKE cqa_file.cqa03        #No.FUN-680147 VARCHAR(8)   #TQC-B90211
  DEFINE logic_no  		LIKE type_file.chr10       #LIKE cqa_file.cqa03        #No.FUN-680147 VARCHAR(8)   #TQC-B90211
  DEFINE c1,c2     		LIKE type_file.chr10       #LIKE cqa_file.cqa03        #No.FUN-680147 VARCHAR(8)   #TQC-B90211
  DEFINE a         		LIKE aba_file.aba18        #No.FUN-680147 VARCHAR(2)
  DEFINE i,j,n     		LIKE type_file.num5        #No.FUN-680147 SMALLINT
  DEFINE l_ban_code             STRING                 #MOD-C30016 add
 
  WHENEVER ERROR CALL cl_err_msg_log
#No.TQC-990064 --begin                                                          
  IF g_aza.aza26 ='2' THEN                                                      
     RETURN TRUE                                                                
  END IF                                                                        
#No.TQC-990064 --end  
 #-----------------MOD-C30016------------start
  LET l_ban_code = p_ban_code
  IF l_ban_code.getLength() <> 8  THEN
     RETURN FALSE
  END IF
 #-----------------MOD-C30016--------------end
  #-->非八碼數字則不檢查 
  FOR i=1 TO 8
    IF p_ban_code[i] IS NULL OR p_ban_code[i] NOT MATCHES '[1234567890]' THEN
       CALL cl_err('chkban:','mfg7015',0) #no.2028
       DISPLAY "p_ban_code=",p_ban_code
       RETURN TRUE
    END IF
  END FOR
  LET logic_no = '12121241'
  FOR i = 1 to 8
    IF cl_null(p_ban_code[i,i]) OR p_ban_code[i,i] <'0' OR p_ban_code[i,i] >'9'
       THEN RETURN FALSE
    END IF
    LET a = (p_ban_code[i,i] * logic_no[i,i]) USING '&&'
    IF a[1,1] = '0'
       THEN LET c1[i,i] = a[2,2] LET c2[i,i] = a[2,2]
       ELSE LET c1[i,i] = a[1,1] LET c2[i,i] = a[2,2]
            LET a = (a[1,1] + a[2,2]) USING '&&'
            IF a[1,1] = '0'
               THEN LET c1[i,i] = a[2,2] LET c2[i,i] = a[2,2]
               ELSE LET c1[i,i] = a[1,1] LET c2[i,i] = a[2,2]
            END IF
    END IF
  END FOR
  LET n = 0 FOR i = 1 to 8 LET n = n + c1[i,i] END FOR
  LET i = n / 10 LET j = n - i * 10
  IF j = 0 THEN RETURN TRUE END IF
  LET n = 0 FOR i = 1 to 8 LET n = n + c2[i,i] END FOR
  LET i = n / 10 LET j = n - i * 10
  IF j = 0 THEN RETURN TRUE END IF
  RETURN FALSE
END FUNCTION
