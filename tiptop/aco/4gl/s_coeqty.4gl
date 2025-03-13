# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name ..: s_coeqty
# DESCRIPTION....: 檢查進口材料可用數量額度(coe_file)
# Parmeter.......: p_key1  手冊編號
#                  p_key2  合同序號
# Date & Autor...: 00/10/12 By Kammy
# Modify.........: No.MOD-490398 04/12/22 By Danny   1.合同編號改為手冊編號
# Modify.........: No.TQC-660045 06/06/13 By hellen     cl_err --> cl_err3
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE g_coc01 LIKE coc_file.coc01
 
FUNCTION s_coeqty(p_key1,p_key2)
   DEFINE p_key1   LIKE coc_file.coc03                #No.MOD-490398
   DEFINE p_key2   LIKE coe_file.coe02
   DEFINE l_tot    LIKE coe_file.coe05
   DEFINE l_export LIKE coe_file.coe09
   DEFINE l_import LIKE coe_file.coe091
   DEFINE l_credit LIKE coe_file.coe05
   DEFINE l_sql    STRING        
 
   SELECT coc01 INTO g_coc01 FROM coc_file
     WHERE coc03 = p_key1                              #No.MOD-490398
      AND cocacti !='N' #010807 增
    IF STATUS = 100 THEN 
#   CALL cl_err('','aco-062',1)    #No.MOD-490398 #No.TQC-660045
    CALL cl_err3("sel","coc_file",p_key1,"","aco-062","","",1)  #TQC-660045
    RETURN 0 END IF    
   
 #No.MOD-490398 
#(申請量+加簽量),(直進+轉進+內購+轉入),(國外退貨+轉廠退貨+內購退貨)
   SELECT (coe05+coe10),(coe09+coe101+coe107+coe051),(coe104+coe108+coe109)
     INTO l_tot,l_import,l_export
     FROM coe_file WHERE coe01 = g_coc01 AND coe02 = p_key2
   #合同剩餘量 = 申請量 - (進口量 -出口量)
   LET l_credit = l_tot - (l_import - l_export)
  
   RETURN l_credit
 
END FUNCTION
