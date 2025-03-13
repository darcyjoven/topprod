# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_chk_ware1.4gl
# Descriptions...: 检查传入门店是否可以使用此仓库
# Date & Author..: 10/10/19 By Carrier   #No.FUN-AA0080
# Usage..........: CALL s_chk_ware1(p_ware,p_plant) RETURNING l_flag
# Input Parameter: p_ware    仓库编号
#                  p_plant   门店编号
# Return code....: l_flag    成功否
#                    1	YES
#                    0	NO
# Modify.........: No.FUN-AA0048 10/12/01 By Carrier 报错信息改善
# Modify.........: No:TQC-B90001 11/09/01 By pauline 修改錯誤訊息
# Modify.........: No.FUN-CB0052 12/11/15 By xianghui 發票倉控管改善
# Modify.........: No.TQC-D10101 13/01/29 By xianghui 發票倉控管排除axms100和axmt670
 
DATABASE ds 
 
GLOBALS "../../config/top.global"  #No.FUN-AA0080
 
FUNCTION s_chk_ware1(p_ware,p_plant)
   DEFINE p_ware     LIKE imd_file.imd01
   DEFINE p_plant    LIKE azp_file.azp01
   DEFINE l_azw04    LIKE azw_file.azw04
   DEFINE l_imd20    LIKE imd_file.imd20 
   DEFINE l_imd10    LIKE imd_file.imd10  #FUN-CB0052
   DEFINE l_sql      STRING
   DEFINE l_str      STRING

   WHENEVER ERROR CALL cl_err_msg_log

   IF cl_null(p_ware) THEN RETURN TRUE END IF
   IF cl_null(p_plant) THEN LET p_plant = g_plant END IF

   LET l_sql = "SELECT imd20,imd10 FROM ",cl_get_target_table(p_plant,'imd_file'),    #FUN-CB0052  add imd10
               " WHERE imd01='",p_ware,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
   PREPARE imd20_cs1 FROM l_sql
   EXECUTE imd20_cs1 INTO l_imd20,l_imd10   #FUN-CB0052  add l_imd10
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.SQLCODE USING '-------'
      IF g_bgerr THEN
         CALL s_errmsg('imd01',p_ware,'sel imd20',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3('sel','imd_file',p_ware,'',SQLCA.sqlcode,'','sel imd20',1)
      END IF
      RETURN FALSE
   END IF

   IF cl_null(l_imd20) THEN
      LET g_errno = 'sub-300'
      IF g_bgerr THEN
         CALL s_errmsg('imd01',p_ware,'imd20 is null','sub-300',1)
      ELSE
         LET l_str = p_ware CLIPPED,':imd20 is null'  #No.FUN-AA0048
         CALL cl_err(l_str,'sub-300',1)
      END IF
      RETURN FALSE
   END IF

   IF l_imd20 <> p_plant THEN
      LET g_errno = 'sub-302'
    #  LET l_str = p_ware CLIPPED,':',l_imd20,'<>',g_plant  #No.FUN-AA0048   #TQC-B90001 mark
      LET l_str = p_ware CLIPPED,':',l_imd20,'<>',p_plant        #TQC-B90001 add
      IF g_bgerr THEN
         CALL s_errmsg('imd01',p_ware,l_str,'sub-302',1)
      ELSE
         CALL cl_err(l_str,'sub-302',1)
      END IF
      RETURN FALSE
   END IF

   #FUN-CB0052---add---str---
   #IF NOT cl_null(l_imd10) THEN      #TQC-D10101 mark
   IF NOT cl_null(l_imd10) AND g_prog <> 'axms100' AND  g_prog <> 'axmt670' THEN   #TQC-D10101 add
      IF l_imd10 MATCHES '[Ii]' THEN
         CALL cl_err(l_imd10,'axm-693',1)
         RETURN FALSE
      END IF
   END IF
   #FUN-CB0052---add---end---

   RETURN TRUE
 
END FUNCTION
