# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name ..: s_chkcoe1
# Description....: 檢查已進口材料之可用數量額度(coe_file)
# Parmeter.......: p_key1  手冊編號
#                  p_key2  手冊序號
# Date & Autor...: 05/01/13 By Carrier
# MOdify.........: No.TQC-660045 06/06/09 BY hellen  cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE g_coc01 LIKE coc_file.coc01
 
FUNCTION s_chkcoe1(p_key1,p_key2)
   DEFINE p_key1   LIKE coc_file.coc03
   DEFINE p_key2   LIKE coe_file.coe02
   DEFINE l_tot    LIKE coe_file.coe05
   DEFINE l_export LIKE coe_file.coe09
   DEFINE l_import LIKE coe_file.coe091
   DEFINE l_credit LIKE coe_file.coe05
   DEFINE l_sql    LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(300)
 
   SELECT coc01 INTO g_coc01 FROM coc_file
    WHERE coc03 = p_key1
      AND cocacti !='N'
   IF STATUS = 100 THEN 
#     CALL cl_err('','aco-062',1)  #No.TQC-660045
      CALL cl_err3("sel","coc_file",p_key1,"","aco-062","","",1) #TQC-660045
      RETURN 0 END IF
 
#  進口量=手冊轉入(coe051)+直接進口(coe09)+轉廠進口(coe101)+內購數量(coe107)-
#         國外退貨(coe104)-轉廠退貨(coe108)-內購退貨(coe109)
#  耗用量=直接耗用(coe091)+轉廠耗用(coe102)+手冊轉出(coe103)+
#         報廢數量(coe105)+內銷耗用(coe106)
   SELECT (coe051+coe09+coe101+coe107-coe104-coe108-coe109),
          (coe091+coe102+coe103+coe105+coe106)
     INTO l_import,l_export
     FROM coe_file WHERE coe01 = g_coc01 AND coe02 = p_key2
 
   #可用量 = 已進口量 - 已耗用量
   LET l_credit = l_import - l_export
 
   RETURN l_credit
 
END FUNCTION
