# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# 
# Pattern name...: s_get_defslip.4gl
# Descriptions...: 取得預設單別或預設POS上下傳單別
# Date & Author..: 12/10/26 Lori(FUN-C90050)
# Usage..........: CALL s_get_defslip(p_module,p_slip_type,p_plant,p_pos)
# Input Parameter: p_module: 系統別         
#                  p_slip_type: 單據性質
#                  p_plant: 營運中心編號
#                  p_pos: 是否取得POS上下傳的預設單別
# Return code....: g_slip: 預設單別或預設POS上下傳單別

DATABASE ds
GLOBALS "../../config/top.global"
#FUN-C90050
DEFINE g_module      LIKE rye_file.rye01,
       g_slip_type   LIKE rye_file.rye02,
       g_slip        LIKE rye_file.rye03
DEFINE g_sql         STRING

FUNCTION s_get_defslip(p_module,p_slip_type,p_plant,p_pos)
   DEFINE p_module      LIKE rye_file.rye01,
          p_slip_type   LIKE rye_file.rye02,
          p_plant       LIKE rye_file.rye05,
          p_pos         LIKE type_file.chr1
   DEFINE l_sql         STRING
              
   LET g_module       = p_module
   LET g_slip_type    = p_slip_type
   LET g_slip         = NULL
   LET g_sql          = NULL
   LET l_sql          = NULL

   IF p_pos = 'Y' THEN
      #預設POS上傳單別 (rye04)條件為: "系統別+單據性質+所屬營運中心" (所屬營運中心 = 目前user登入的營運中心)
      #                               取不到時再進一步取得 "系統別+單據性質+未設定所屬營運中心" 的預設POS上傳單別 (rye04)

      LET l_sql = "SELECT rye04"
   ELSE
      #預設單別(rye03)條件為:"系統別+單據性質+所屬營運中心" (所屬營運中心 = 目前user登入的營運中心)
      #                      取不到時再進一步取得 "系統別+單據性質+未設定所屬營運中心" 的預設單別(rye03)

      LET l_sql = "SELECT rye03"
   END IF

   LET g_sql = l_sql CLIPPED,"  FROM ",cl_get_target_table(p_plant,'rye_file'),
                             " WHERE rye01 = '",g_module,"'",
                             "   AND rye02 = '",g_slip_type,"'",
                             "   AND rye05 = '",p_plant,"'",
                             "   AND ryeacti = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE pre_sel_rye1 FROM g_sql
   EXECUTE pre_sel_rye1 INTO g_slip


   IF cl_null(g_slip) THEN
      LET g_sql = l_sql CLIPPED,"  FROM ",cl_get_target_table(p_plant,'rye_file'),
                                " WHERE rye01 = '",g_module,"'",
                                "   AND rye02 = '",g_slip_type,"'",
                                "   AND TRIM(rye05) IS NULL",
                                "   AND ryeacti = 'Y'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE pre_sel_rye2 FROM g_sql
      EXECUTE pre_sel_rye2 INTO g_slip
   END IF

   RETURN g_slip
END FUNCTION
