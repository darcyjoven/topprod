# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: s_weight_cubage1.4gl
# Descriptions...: 計算料件重量體積	
# Date & Author..: 06/01/23 By elva
# Usage..........: s_weight_cubage1(p_inb04,p_inb08,p_inb09) RETURNING l_weight,l_cubage
# Input Parameter: p_inb04    料號 
#                  p_inb08    單位 
#                  p_inb09    數量
# Return Code....: l_weight   重量 
#                  l_cubage   體積
# Modify.........: No:FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No:FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:FUN-A10099 10/02/02 By Carrier 跨db方式
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A50102 10/06/30 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
DATABASE ds

GLOBALS "../../config/top.global"   #No.FUN-A10099

FUNCTION s_weight_cubage1(p_inb04,p_inb08,p_inb09,p_plant)
   DEFINE p_inb04     LIKE ima_file.ima01 
   DEFINE p_inb08     LIKE ima_file.ima25 
#   DEFINE p_inb09     LIKE ima_file.ima262 #FUN-A20044
   DEFINE p_inb09     LIKE type_file.num15_3 #FUN-A20044
   DEFINE p_plant     LIKE azp_file.azp01 
   DEFINE p_dbs       LIKE type_file.chr21
   DEFINE p_tdbs      LIKE type_file.chr21
   DEFINE l_weight    LIKE ima_file.ima1023
   DEFINE l_cubage    LIKE ima_file.ima1022
   DEFINE l_flag      LIKE type_file.chr1  
   DEFINE l_factor    LIKE ima_file.ima31_fac
   DEFINE l_ima       RECORD LIKE ima_file.*
   DEFINE l_sql       STRING

   WHENEVER ERROR CALL cl_err_msg_log

   LET g_plant_new = p_plant
   CALL s_getdbs()
   LET p_dbs=g_dbs_new
   CALL s_gettrandbs()
   LET p_tdbs=g_dbs_tra

   LET l_sql = " SELECT ima25,ima31,ima1022,ima1023,ima1027,ima1028 ",
               #"   FROM ",p_dbs CLIPPED,"ima_file ",
               "   FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
               "  WHERE ima01 = '",p_inb04,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102
   PREPARE ima_p1 FROM l_sql
   EXECUTE ima_p1 INTO l_ima.ima25,l_ima.ima31,l_ima.ima1022,
                       l_ima.ima1023,l_ima.ima1027,l_ima.ima1028
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('ima01',p_inb04,'select ima',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('select ima',SQLCA.sqlcode,1)
      END IF
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
         CALL s_umfchkm(p_inb04,p_inb08,l_ima.ima25,p_plant)
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
