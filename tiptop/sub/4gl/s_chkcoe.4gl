# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chkcoe
# Descriptions...: 檢查已進口材料之可用數量額度(coe_file)
# Input Parameter: p_key1  合同編號
#                  p_key2  合同序號
# Date & Autor...: 03/09/03 By Danny
# Modify.........: 04/12/28 By Carrier  合同轉入量納入合同的進口量中
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
DEFINE g_coc01 LIKE coc_file.coc01
 
FUNCTION s_chkcoe(p_key1,p_key2)
   DEFINE p_key1   LIKE coc_file.coc04
   DEFINE p_key2   LIKE coe_file.coe02
   DEFINE l_tot    LIKE coe_file.coe05
   DEFINE l_export LIKE coe_file.coe09
   DEFINE l_import LIKE coe_file.coe091
   DEFINE l_credit LIKE coe_file.coe05
   DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(300)
 
   SELECT coc01 INTO g_coc01 FROM coc_file
    WHERE coc04 = p_key1
      AND cocacti !='N' 
   IF STATUS = 100 THEN CALL cl_err('','aco-050',1) RETURN 0 END IF
   
 #No.MOD-490398  --begin
#   SELECT (coe09+coe101+coe103-coe104),(coe091+coe102+coe105+coe106)
#     INTO l_import,l_export
#     FROM coe_file WHERE coe01 = g_coc01 AND coe02 = p_key2
   SELECT (coe09+coe101+coe103-coe104+coe051),(coe091+coe102+coe105+coe106)
     INTO l_import,l_export
     FROM coe_file WHERE coe01 = g_coc01 AND coe02 = p_key2
 #No.MOD-490398  --begin
   #可用量 = 已進口量 - 已耗用量
   LET l_credit = l_import - l_export
  
   RETURN l_credit
 
END FUNCTION
