# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_numfor3
# Descriptions...: 將數值不須的小數位數不列印出
# Input parameter: p_value	數值
# Return code....: l_str  	FORMAT後的數值, 以 CHAR 型態 RETURN
# Usage .........: let a = cl_numfor3(amt,13); print a
# Date & Author..: 91/06/11 By LYS
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
 
DATABASE ds    #No.FUN-690005
FUNCTION cl_numfor3(p_value)
   DEFINE p_value      LIKE bmb_file.bmb06,           #No.FUN-690005  DECIMAL(18,5),
          c_value      LIKE mpz_file.mpz04,           #No.FUN-690005  VARCHAR(19)
          l_str,l_chr  LIKE type_file.chr10,          #No.FUN-690005  VARCHAR(10) #No.TQC-6A0079
          i,l_k     LIKE type_file.num5,              #No.FUN-690005  SMALLINT
          l_cnt,l_s LIKE type_file.num5,              #No.FUN-690005  SMALLINT   
          l_f,e,l_t LIKE type_file.chr1               #No.FUN-690005  VARCHAR(01)
  
  LET c_value = p_value
  LET l_str = ' '
  LET l_cnt = 0
  LET l_t ='Y'
  FOR i = 1 to 19
      IF c_value[i,i] = '.' THEN LET l_f = 'Y' CONTINUE FOR END IF
      IF l_f = 'Y' THEN 
           IF cl_null(c_value[i,i]) THEN EXIT FOR END IF 
           IF c_value[i,i] = '0' THEN 
              LET l_cnt = l_cnt + 1
              CONTINUE FOR
           ELSE
               IF l_t ='Y' THEN 
                    LET l_str = l_str clipped,'.',c_value[i-l_cnt ,i]
                    LET l_t = 'N'
               ELSE LET l_str = l_str clipped,c_value[i-l_cnt ,i]
               END IF
               LET l_cnt = 0
           END IF
      ELSE
           LET l_str = l_str clipped,c_value[i,i] 
      END IF
  END FOR
  LET l_k = LENGTH(l_str) - 1 
  LET l_chr[10-l_k,10] = l_str  
  RETURN l_chr
END FUNCTION
