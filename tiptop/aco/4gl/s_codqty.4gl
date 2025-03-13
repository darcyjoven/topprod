# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name ..: s_codqty
# DESCRIPTION....: 檢查出口成品可用數量額度(cod_file)
# Parmeter.......: p_key1  手冊編號
#                  p_key2  合同序號
# Date & Autor...: 00/10/11 By Kammy
# Modify.........: No.MOD-490398 04/12/22 By Danny        合同編號改為手冊編號
# Modify.........: No.TQC-660045 06/06/13 By hellen     cl_err --> cl_err3
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE g_coc01 LIKE coc_file.coc01
 
FUNCTION s_codqty(p_key1,p_key2)
   DEFINE p_key1   LIKE coc_file.coc03               #No.MOD-490398
   DEFINE p_key2   LIKE cod_file.cod02
   DEFINE l_tot    LIKE cod_file.cod05
   DEFINE l_export LIKE cod_file.cod09
   DEFINE l_import LIKE cod_file.cod091
   DEFINE l_credit LIKE cod_file.cod05
   DEFINE l_sql    STRING        
 
   SELECT coc01 INTO g_coc01 FROM coc_file
     WHERE coc03 = p_key1                             #No.MOD-490398
      AND cocacti !='N' #010807增  
    IF STATUS = 100 THEN 
#      CALL cl_err('','aco-062',1)   #No.MOD-490398 #No.TQC-660045
       CALL cl_err3("sel","coc_file",p_key1,"","aco-062","","",1) #TQC-660045
       RETURN 0 END IF  
    #No.MOD-490398
   #(申請量+加簽量),(直出+轉出+內銷),(國外退貨+轉廠退貨+內銷退貨)
   SELECT (cod05+cod10),(cod09+cod101+cod106),(cod091+cod102+cod104)
     INTO l_tot,l_export,l_import
     FROM cod_file WHERE cod01 = g_coc01 AND cod02 = p_key2
   #合同剩餘量 = 申請量 - (出口量 -進口量)
   LET l_credit = l_tot - (l_export - l_import)
 
   RETURN l_credit
 
END FUNCTION
