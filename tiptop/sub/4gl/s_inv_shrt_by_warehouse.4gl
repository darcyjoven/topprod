# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_inv_shrt_by_warehouse.4gl
# Descriptions...: 按仓库设定是否允许负库存
# Date & Author..: 12/08/27 By Carrier
# Memo...........: 按aimi200中设置的是否允许负库存来判断
#
# Return Code....: Y     --> 可以负库存
#                  N     --> 不可负库存
# Modify.........: No:FUN-C80107 12/09/07 By suncx 仓库设定是否允许负库存 
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30054 13/03/21 By lixh1 FUN-D30024所做的修改在正式區被還原,故重新過單
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存參數添加營運中心參數
                                                                                                                                    
DATABASE ds         
 
GLOBALS "../../config/top.global"
 
FUNCTION s_inv_shrt_by_warehouse(p_ware,p_plant)  #FUN-D30024 去除sma894傳參 #TQC-D30054 #TQC-D40078 add p_plant 
  #DEFINE p_sma894        LIKE type_file.chr1           #系统整理参数:杂项/出货/工单发料/调拨出库/还料出库/采购退货或入库还原/销退/盘点  #FUN-D30024
   DEFINE p_ware          LIKE imd_file.imd01           #仓库代号
   DEFINE l_imd23         LIKE imd_file.imd23           #仓库负库存设定字段
   DEFINE l_flag          LIKE type_file.chr1
   DEFINE p_plant         LIKE azp_file.azp01           #TQC-D40078 add
   DEFINE g_sql           STRING                        #TQC-D40078 add
       
   #FUN-D30024--mark--str--
   #IF cl_null(p_sma894) THEN   #参数为空
   #   RETURN 'N'
   #END IF
   #IF cl_null(p_ware) THEN
   #   RETURN p_sma894
   #END IF
   #FUN-D30024--mark--end--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #TQC-D40078 add
   LET g_plant_new = p_plant                            #TQC-D40078 add

   #TQC-D40078--mark--str--
   #SELECT imd23 INTO l_imd23 FROM imd_file
   # WHERE imd01 = p_ware
   #TQC-D40078--mark--end--

   #TQC-D40078--add--str--
   LET g_sql = "SELECT imd23 FROM ",cl_get_target_table(g_plant_new,'imd_file'),
               " WHERE imd01 = '", p_ware ,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE inv_shrt_pre FROM g_sql
   DECLARE inv_shrt_cs CURSOR FOR inv_shrt_pre
   OPEN inv_shrt_cs
   FETCH inv_shrt_cs INTO l_imd23
   #TQC-D40078--add--end--

   IF SQLCA.sqlcode THEN
      #此仓库不存在仓库主档内,请重新录入
      IF g_bgjob = 'N' THEN
         CALL cl_err(p_ware,'mfg0094',1)
      ELSE
         CALL s_errmsg('imd01',p_ware,'','mfg0094',1)
      END IF
      RETURN 'N'
   END IF 

   IF cl_null(l_imd23) THEN
     #LET l_imd23 = p_sma894  #FUN-D30024 mark
      LET l_imd23 = 'N'       #FUN-D30024 add
   ELSE
      IF l_imd23 NOT MATCHES '[YN]' THEN
         LET l_imd23 = 'N'
      END IF
   END IF

   #FUN-D30024--mark--str--
   #IF p_sma894 = 'N' OR p_sma894 IS NULL THEN      #整体参数为不可负库存
   #   RETURN 'N'
   #ELSE
   #   RETURN l_imd23
   #END IF
   #FUN-D30024--mark--end--
   RETURN l_imd23  #FUN-D30024 add

END FUNCTION
 
#FUN-C80107
