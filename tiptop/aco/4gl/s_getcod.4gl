# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name ..: s_getcod
# DESCRIPTION....: 取得成品折算量
# Parmeter.......: p_key1  手冊編號
#                  p_key2  商品編號(進口材料)
# Date & Autor...: 00/10/14 By Kammy
# Modify.........: No.MOD-490398 04/12/27 By Danny     合同編號改為手冊編號
# Modify.........: No.TQC-660045 06/06/12 By Czl cl_err-->cl_err3
# Modify.........: NO.FUN-680069 06/08/31 By Czl 類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE g_coc01 LIKE coc_file.coc01
 
FUNCTION s_getcod(p_key1,p_key2)
   DEFINE p_key1   LIKE coc_file.coc04
   DEFINE p_key2   LIKE coe_file.coe03
   DEFINE l_cod03  LIKE cod_file.cod03
   DEFINE l_cod041 LIKE cod_file.cod041     
   DEFINE l_cod05  LIKE cod_file.cod05
   DEFINE l_con05  LIKE con_file.con05
   DEFINE l_con06  LIKE con_file.con06
   DEFINE l_qty    LIKE cod_file.cod05
   DEFINE l_rate   LIKE ima_file.ima31_fac       #No.FUN-680069 DEC(10,5)
   DEFINE l_sql    LIKE type_file.chr1000    #NO.FUN-680069 VARCHAR(300)        
 
   SELECT coc01 INTO g_coc01 FROM coc_file
     WHERE coc03 = p_key1                #No.MOD-490398
      AND cocacti !='N' #010807 增
   IF STATUS = 100 THEN 
#     CALL cl_err('','aco-050',1) #No.TQC-660045
      CALL cl_err3("sel","coc_file",p_key1,"","aco-050","","",1) #NO.TQC-660045
   RETURN 0,0 END IF
 
   LET l_rate = 0
   LET l_qty  = 0
 
   
   DECLARE cod_cs CURSOR FOR
    SELECT cod03,cod041,(cod09-cod091+cod101-cod102)
      FROM cod_file WHERE cod01 = g_coc01
   FOREACH cod_cs INTO l_cod03,l_cod041,l_cod05
      IF STATUS THEN CALL cl_err('',STATUS,1) EXIT FOREACH END IF
      #檢查此成品是否有用到本材料
      SELECT con05,con06 INTO l_con05,l_con06 FROM con_file 
       WHERE con01 =l_cod03 
         AND con013=l_cod041
         AND con03 =p_key2 
      IF STATUS = 100 THEN CONTINUE FOREACH END IF
   
 
       LET l_rate = l_con05 / (1 - l_con06)        #No.MOD-490398
      LET l_qty  = l_qty + (l_cod05 * l_rate)
 
   END FOREACH 
 
   RETURN l_rate,l_qty
   
END FUNCTION
