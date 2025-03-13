# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_weight_cubage.4gl
# Descriptions...: 計算料件重量體積	
# Date & Author..: 06/01/23 By elva
# Usage..........: s_weight_cubage(p_inb04,p_inb08,p_inb09) RETURNING l_weight,l_cubage
# Input Parameter: p_inb04    料號 
#                  p_inb08    單位 
#                  p_inb09    數量
# Return Code....: l_weight   重量 
#                  l_cubage   體積
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_weight_cubage(p_inb04,p_inb08,p_inb09)
   DEFINE p_inb04     LIKE ima_file.ima01, 	#No.FUN-680147 VARCHAR(20)
          p_inb08     LIKE ima_file.ima25, 	#No.FUN-680147 VARCHAR(04)
#          p_inb09     LIKE ima_file.ima262, 	#No.FUN-680147 DEC(15,3) #FUN-A20044
          p_inb09     LIKE type_file.num15_3, 	#No.FUN-680147 DEC(15,3) #FUN-A20044
          l_weight    LIKE ima_file.ima1023,
          l_cubage    LIKE ima_file.ima1022,
          l_flag      LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
          l_factor    LIKE ima_file.ima31_fac   #No.FUN-680147 DEC(16,8)
   DEFINE l_ima       RECORD LIKE ima_file.*
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT ima25,ima31,ima1022,ima1023,ima1027,ima1028
     INTO l_ima.ima25,l_ima.ima31,l_ima.ima1022,
          l_ima.ima1023,l_ima.ima1027,l_ima.ima1028
     FROM ima_file
    WHERE ima01 = p_inb04
   IF SQLCA.sqlcode THEN
      RETURN 0,0
   END IF
   IF p_inb08 = l_ima.ima25 THEN #選擇庫存單位
      LET l_weight = l_ima.ima1023 * p_inb09 
      LET l_cubage = l_ima.ima1022 * p_inb09 
   ELSE
      IF p_inb08 = l_ima.ima31 THEN #選擇銷售單位
         LET l_weight = l_ima.ima1028 * p_inb09 
         LET l_cubage = l_ima.ima1027 * p_inb09 
      ELSE #選擇其他單位
         CALL s_umfchk(p_inb04,p_inb08,l_ima.ima25)
             RETURNING l_flag,l_factor
         IF l_flag THEN 
            RETURN 0,0
         END IF 
         LET l_weight = l_ima.ima1023 * p_inb09 * l_factor
         LET l_cubage = l_ima.ima1022 * p_inb09 * l_factor
      END IF
   END IF  
   IF cl_null(l_weight) THEN LET l_weight = 0 END IF
   IF cl_null(l_cubage) THEN LET l_cubage = 0 END IF
   RETURN l_weight,l_cubage
END FUNCTION
