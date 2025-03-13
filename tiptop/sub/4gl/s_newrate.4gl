# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#                                                                               
# Pattern name...: s_newrate
# Descriptions...:
# Date & Author..: No.FUN-9A0036 10/01/18 By chenmoyan
# Modify.........: No:MOD-A30110 10/03/16 By sabrina 當總帳單身幣別<>拋轉幣別時，傳回的匯率會為null值
# Modify.........: No:FUN-9A0009 10/07/21 By Dido 合併報表專案需要此程式 
# Modify.........: No:MOD-C50256 12/06/08 By Elise CALL s_curr3 前再重新給予 p_abb25 匯率

DATABASE ds                                                                     
                                                                                
GLOBALS "../../config/top.global"
FUNCTION s_newrate(p_aba00_o,p_aba00_n,p_abb24,p_abb25,p_aba02)
DEFINE
   p_aba00_o,p_aba00_n LIKE aba_file.aba00,
   p_abb24             LIKE aba_file.aba24,
   p_abb25             LIKE abb_file.abb25,
   p_aba02             LIKE aba_file.aba02,
   l_aaa03_o,l_aaa03_n LIKE aaa_file.aaa03,
   l_abb25,l_abb25_n   LIKE abb_file.abb25
    
   SELECT aaa03 INTO l_aaa03_o FROM aaa_file                               
    WHERE aaa01 = p_aba00_o  #原始帳別                                    
   SELECT aaa03 INTO l_aaa03_n FROM aaa_file                               
    WHERE aaa01 = p_aba00_n  #拋轉帳別                                    

   IF l_aaa03_o = l_aaa03_n THEN                                           
     #IF p_abb24=l_aaa03_n THEN      #MOD-A30110 mark                                    
         LET l_abb25 = p_abb25       
     #END IF                         #MOD-A30110 mark                                      
   ELSE                                                                    
      IF p_abb24=l_aaa03_n THEN                                          
         LET l_abb25 = 1                                                 
      ELSE
         CALL s_curr3(p_abb24,p_aba02,'M') RETURNING p_abb25    #MOD-C50256 
         CALL s_curr3(l_aaa03_n,p_aba02,'M')                           
             RETURNING l_abb25_n                                           
         LET l_abb25 = p_abb25/l_abb25_n                               
      END IF                                                               
   END IF
   IF cl_null(l_abb25) THEN LET l_abb25=1 END IF
   RETURN l_abb25
END FUNCTION
#No.FUN-9A0036
#FUN-9A0009
