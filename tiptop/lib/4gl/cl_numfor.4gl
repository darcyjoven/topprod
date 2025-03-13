# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_numfor
# Descriptions...: 將數值依指定的列印長度及小數位數做FORMAT, 以便列印.
#                  若值為 0 , 將傳回 0.00, 並非空白.
# Input parameter: p_value    數值
#                  p_len      最大可列印長度
#                             (voucher:輸入長度,非憑證:輸入p_zaa項目編號)
#                  p_n        指定小數位數
# Return code....: l_str      FORMAT後的數值, 以 CHAR 型態 RETURN
# Usage .........: let a = cl_numfor(amt,17,2); print a
# Date & Author..: 91/06/11 By LYS
# 1994/02/22(Lee):原和式使用隨小數位數而變動的長度(j)但若傳進來的p_len>16
# 時, 而使用的p_n=0, 則會在列印的字串前加上兩個null字, 所以我改成使用固定
# 的j=22, 在轉換時採用固定長度的USING, 敬請原諒!!
# Modify.........: No.MOD-4C0016 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0039 04/12/23 By CoCo p_len改抓zaa_file中的欄位寬度
# Modify.........: No.MOD-540161 05/04/25 By Echo cl_numfor中抓zaa_file漏了客制欄位
# Modify.........: No.MOD-540176 05/04/25 By Echo cl_numfor當指定寬度時會出現*
# Modify.........: No.MOD-560071 05/06/14 By Echo 利用g_w[]陣列抓取p_zaa欄位寬度
# Modify.........: No.FUN-560048 05/08/01 By Echo 欄位寬度為負值時必須顯示錯誤訊息
# Modify.........: No.MOD-590093 05/09/22 By Echo 1.即使資料長度超過欄位寬度也不會出現星號,而是往後擠
#                                                 2.欄位最大寬度為29
# Modify.........: No.TQC-640038 06/04/07 By Echo 將參考p_value DECIMAL(22,6) 放大為 DECIMAL(26,10)
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換 
# Modify.........: No.CHI-690007 06/12/05 By kim 當p_n為null時,讓他為0
# Modify.........: No.FUN-920079 06/05/04 By Echo 欄位寬度等於37時,程式不該掛掉
 
DATABASE ds
GLOBALS "../../config/top.global"
 
FUNCTION cl_numfor(p_value,p_len,p_n)
    DEFINE p_value      LIKE type_file.num26_10,         #No.FUN-690005	DECIMAL(26,10) #No.MOD-4C0016   #MOD-590093 #TQC-640038
          p_len,p_n     LIKE type_file.num5,             #No.FUN-690005	SMALLINT
          l_len         LIKE type_file.num5,             #No.FUN-690005	SMALLINT
          l_str	        LIKE type_file.chr37,            #No.FUN-690005 VARCHAR(37)       #No.MOD-4C0039  #MOD-590093 #TQC-640038
          l_length      LIKE type_file.num5,             #No.FUN-690005 SMALLINT
          i,j,k         LIKE type_file.num5              #No.FUN-690005 SMALLINT
     
   IF not cl_null(g_xml_rep) THEN
       LET l_len = g_w[p_len]              #MOD-560071
   END IF
   IF l_len > 0 THEN LET p_len = l_len END IF #MOD-540176
   ## END MOD-540161 ##
#  IF l_str IS NULL THEN RETURN '' END IF
   IF p_n IS NULL THEN LET p_n=0 END IF #CHI-690007
   LET p_value = cl_digcut(p_value,p_n)
 #No.MOD-4C0039
#   LET l_str = p_value USING '----,---,---,--&.&&&&&' LET j = 22
 
#   CASE WHEN p_n = 0 LET l_str = p_value USING '--,---,---,---,---,--&'
#                    LET j = 16
         #-----No.MOD-4C0016-----
#   	WHEN p_n = 6 LET l_str = p_value USING '---,---,---,--&.&&&&&&'
#                     LET j = 23
         #-----No.MOD-4C0016 END-----
#   	WHEN p_n = 5 LET l_str = p_value USING '----,---,---,--&.&&&&&'
#                     LET j = 22
#        WHEN p_n = 4 LET l_str = p_value USING '-,---,---,---,--&.&&&&'
#                     LET j = 21
#        WHEN p_n = 3 LET l_str = p_value USING '--,---,---,---,--&.&&&'
#                     LET j = 20
#        WHEN p_n = 2 LET l_str = p_value USING '---,---,---,---,--&.&&'
#                     LET j = 19
#        WHEN p_n = 1 LET l_str = p_value USING '----,---,---,---,--&.&'
#                     LET j = 18
#   END CASE
 #No.MOD-4C0039
   #MOD-590093
   #TQC-640038
   CASE WHEN p_n = 0  LET l_str = p_value USING '-,---,---,---,---,---,---,---,---,--&'
        WHEN p_n = 10 LET l_str = p_value USING '--,---,---,---,---,---,--&.&&&&&&&&&&'
        WHEN p_n = 9  LET l_str = p_value USING '---,---,---,---,---,---,--&.&&&&&&&&&'
        WHEN p_n = 8  LET l_str = p_value USING '----,---,---,---,---,---,--&.&&&&&&&&'
        WHEN p_n = 7  LET l_str = p_value USING '-,---,---,---,---,---,---,--&.&&&&&&&'
        WHEN p_n = 6  LET l_str = p_value USING '--,---,---,---,---,---,---,--&.&&&&&&'
        WHEN p_n = 5  LET l_str = p_value USING '---,---,---,---,---,---,---,--&.&&&&&'
        WHEN p_n = 4  LET l_str = p_value USING '----,---,---,---,---,---,---,--&.&&&&'
        WHEN p_n = 3  LET l_str = p_value USING '-,---,---,---,---,---,---,---,--&.&&&'
        WHEN p_n = 2  LET l_str = p_value USING '--,---,---,---,---,---,---,---,--&.&&'
        WHEN p_n = 1  LET l_str = p_value USING '---,---,---,---,---,---,---,---,--&.&'
   END CASE
   #EDN TQC-640038
   #END MOD-590093
   #請勿除去此值(李增坤)
 #### No.MOD-4C0039 ####
#   LET j=22
#   LET i = j - p_len
#   IF i = 0 OR i IS NULL THEN LET i = 1 END IF
#   LET l_length = 0
 
   #MOD-590093
   #LET j=29                    
   LET j=37                    #TQC-640038 
   LET i = j - p_len
   IF i <= 0 THEN               #FUN-560048   #No.FUN-920079
        #CALL cl_err(p_len,'lib-277',1)
        #EXIT PROGRAM
        IF not cl_null(g_xml_rep) THEN
          LET i = 0
        ELSE
          LET i = 1
        END IF
   END IF
   #END MOD-590093
 
   LET l_length = 0
 #### No.MOD-4C0039 ####
 
   #當傳進的金額位數實際上大於所要求回傳的位數時，該欄位應show"*****" NO:0508
   #FOR k = 29 TO 1 STEP -1                       #MOD-590093
   FOR k = 37 TO 1 STEP -1                        #MOD-590093 #TQC-640038
       IF cl_null(l_str[k,k]) THEN EXIT FOR END IF
       LET l_length = l_length + 1
   END FOR
   IF l_length > p_len THEN
      #MOD-590093
      #LET l_str = '*************************'
      LET i = j - l_length
      IF i < 0 THEN
            RETURN l_str
      END IF
      #MOD-590093
   END IF
 
#  display i,j,"'",l_str,"'"
#   LET l_str = l_str[i,j]
   
   IF not cl_null(g_xml_rep) THEN
     RETURN l_str[i+1,j]
   ELSE 
     RETURN l_str[i,j]
   END IF
END FUNCTION
